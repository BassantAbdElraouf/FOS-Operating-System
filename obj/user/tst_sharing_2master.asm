
obj/user/tst_sharing_2master:     file format elf32-i386


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
  800031:	e8 35 03 00 00       	call   80036b <libmain>
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
  80008d:	68 60 35 80 00       	push   $0x803560
  800092:	6a 13                	push   $0x13
  800094:	68 7c 35 80 00       	push   $0x80357c
  800099:	e8 09 04 00 00       	call   8004a7 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	6a 00                	push   $0x0
  8000a3:	e8 e2 15 00 00       	call   80168a <malloc>
  8000a8:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	uint32 *x, *y, *z ;

	//x: Readonly
	int freeFrames = sys_calculate_free_frames() ;
  8000ab:	e8 47 1a 00 00       	call   801af7 <sys_calculate_free_frames>
  8000b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	x = smalloc("x", 4, 0);
  8000b3:	83 ec 04             	sub    $0x4,%esp
  8000b6:	6a 00                	push   $0x0
  8000b8:	6a 04                	push   $0x4
  8000ba:	68 97 35 80 00       	push   $0x803597
  8000bf:	e8 1a 17 00 00       	call   8017de <smalloc>
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if (x != (uint32*)USER_HEAP_START) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000ca:	81 7d e8 00 00 00 80 	cmpl   $0x80000000,-0x18(%ebp)
  8000d1:	74 14                	je     8000e7 <_main+0xaf>
  8000d3:	83 ec 04             	sub    $0x4,%esp
  8000d6:	68 9c 35 80 00       	push   $0x80359c
  8000db:	6a 1e                	push   $0x1e
  8000dd:	68 7c 35 80 00       	push   $0x80357c
  8000e2:	e8 c0 03 00 00       	call   8004a7 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8000e7:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8000ea:	e8 08 1a 00 00       	call   801af7 <sys_calculate_free_frames>
  8000ef:	29 c3                	sub    %eax,%ebx
  8000f1:	89 d8                	mov    %ebx,%eax
  8000f3:	83 f8 04             	cmp    $0x4,%eax
  8000f6:	74 14                	je     80010c <_main+0xd4>
  8000f8:	83 ec 04             	sub    $0x4,%esp
  8000fb:	68 00 36 80 00       	push   $0x803600
  800100:	6a 1f                	push   $0x1f
  800102:	68 7c 35 80 00       	push   $0x80357c
  800107:	e8 9b 03 00 00       	call   8004a7 <_panic>

	//y: Readonly
	freeFrames = sys_calculate_free_frames() ;
  80010c:	e8 e6 19 00 00       	call   801af7 <sys_calculate_free_frames>
  800111:	89 45 ec             	mov    %eax,-0x14(%ebp)
	y = smalloc("y", 4, 0);
  800114:	83 ec 04             	sub    $0x4,%esp
  800117:	6a 00                	push   $0x0
  800119:	6a 04                	push   $0x4
  80011b:	68 88 36 80 00       	push   $0x803688
  800120:	e8 b9 16 00 00       	call   8017de <smalloc>
  800125:	83 c4 10             	add    $0x10,%esp
  800128:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  80012b:	81 7d e4 00 10 00 80 	cmpl   $0x80001000,-0x1c(%ebp)
  800132:	74 14                	je     800148 <_main+0x110>
  800134:	83 ec 04             	sub    $0x4,%esp
  800137:	68 9c 35 80 00       	push   $0x80359c
  80013c:	6a 24                	push   $0x24
  80013e:	68 7c 35 80 00       	push   $0x80357c
  800143:	e8 5f 03 00 00       	call   8004a7 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800148:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  80014b:	e8 a7 19 00 00       	call   801af7 <sys_calculate_free_frames>
  800150:	29 c3                	sub    %eax,%ebx
  800152:	89 d8                	mov    %ebx,%eax
  800154:	83 f8 03             	cmp    $0x3,%eax
  800157:	74 14                	je     80016d <_main+0x135>
  800159:	83 ec 04             	sub    $0x4,%esp
  80015c:	68 00 36 80 00       	push   $0x803600
  800161:	6a 25                	push   $0x25
  800163:	68 7c 35 80 00       	push   $0x80357c
  800168:	e8 3a 03 00 00       	call   8004a7 <_panic>

	//z: Writable
	freeFrames = sys_calculate_free_frames() ;
  80016d:	e8 85 19 00 00       	call   801af7 <sys_calculate_free_frames>
  800172:	89 45 ec             	mov    %eax,-0x14(%ebp)
	z = smalloc("z", 4, 1);
  800175:	83 ec 04             	sub    $0x4,%esp
  800178:	6a 01                	push   $0x1
  80017a:	6a 04                	push   $0x4
  80017c:	68 8a 36 80 00       	push   $0x80368a
  800181:	e8 58 16 00 00       	call   8017de <smalloc>
  800186:	83 c4 10             	add    $0x10,%esp
  800189:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Create(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  80018c:	81 7d e0 00 20 00 80 	cmpl   $0x80002000,-0x20(%ebp)
  800193:	74 14                	je     8001a9 <_main+0x171>
  800195:	83 ec 04             	sub    $0x4,%esp
  800198:	68 9c 35 80 00       	push   $0x80359c
  80019d:	6a 2a                	push   $0x2a
  80019f:	68 7c 35 80 00       	push   $0x80357c
  8001a4:	e8 fe 02 00 00       	call   8004a7 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Create(): Wrong allocation- make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001a9:	8b 5d ec             	mov    -0x14(%ebp),%ebx
  8001ac:	e8 46 19 00 00       	call   801af7 <sys_calculate_free_frames>
  8001b1:	29 c3                	sub    %eax,%ebx
  8001b3:	89 d8                	mov    %ebx,%eax
  8001b5:	83 f8 03             	cmp    $0x3,%eax
  8001b8:	74 14                	je     8001ce <_main+0x196>
  8001ba:	83 ec 04             	sub    $0x4,%esp
  8001bd:	68 00 36 80 00       	push   $0x803600
  8001c2:	6a 2b                	push   $0x2b
  8001c4:	68 7c 35 80 00       	push   $0x80357c
  8001c9:	e8 d9 02 00 00       	call   8004a7 <_panic>

	*x = 10 ;
  8001ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001d1:	c7 00 0a 00 00 00    	movl   $0xa,(%eax)
	*y = 20 ;
  8001d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001da:	c7 00 14 00 00 00    	movl   $0x14,(%eax)

	int id1, id2, id3;
	id1 = sys_create_env("shr2Slave1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8001e0:	a1 20 40 80 00       	mov    0x804020,%eax
  8001e5:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8001eb:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f0:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8001f6:	89 c1                	mov    %eax,%ecx
  8001f8:	a1 20 40 80 00       	mov    0x804020,%eax
  8001fd:	8b 40 74             	mov    0x74(%eax),%eax
  800200:	52                   	push   %edx
  800201:	51                   	push   %ecx
  800202:	50                   	push   %eax
  800203:	68 8c 36 80 00       	push   $0x80368c
  800208:	e8 5c 1b 00 00       	call   801d69 <sys_create_env>
  80020d:	83 c4 10             	add    $0x10,%esp
  800210:	89 45 dc             	mov    %eax,-0x24(%ebp)
	id2 = sys_create_env("shr2Slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800213:	a1 20 40 80 00       	mov    0x804020,%eax
  800218:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80021e:	a1 20 40 80 00       	mov    0x804020,%eax
  800223:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800229:	89 c1                	mov    %eax,%ecx
  80022b:	a1 20 40 80 00       	mov    0x804020,%eax
  800230:	8b 40 74             	mov    0x74(%eax),%eax
  800233:	52                   	push   %edx
  800234:	51                   	push   %ecx
  800235:	50                   	push   %eax
  800236:	68 8c 36 80 00       	push   $0x80368c
  80023b:	e8 29 1b 00 00       	call   801d69 <sys_create_env>
  800240:	83 c4 10             	add    $0x10,%esp
  800243:	89 45 d8             	mov    %eax,-0x28(%ebp)
	id3 = sys_create_env("shr2Slave1", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800246:	a1 20 40 80 00       	mov    0x804020,%eax
  80024b:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800251:	a1 20 40 80 00       	mov    0x804020,%eax
  800256:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80025c:	89 c1                	mov    %eax,%ecx
  80025e:	a1 20 40 80 00       	mov    0x804020,%eax
  800263:	8b 40 74             	mov    0x74(%eax),%eax
  800266:	52                   	push   %edx
  800267:	51                   	push   %ecx
  800268:	50                   	push   %eax
  800269:	68 8c 36 80 00       	push   $0x80368c
  80026e:	e8 f6 1a 00 00       	call   801d69 <sys_create_env>
  800273:	83 c4 10             	add    $0x10,%esp
  800276:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//to check that the slave environments completed successfully
	rsttst();
  800279:	e8 37 1c 00 00       	call   801eb5 <rsttst>

	sys_run_env(id1);
  80027e:	83 ec 0c             	sub    $0xc,%esp
  800281:	ff 75 dc             	pushl  -0x24(%ebp)
  800284:	e8 fe 1a 00 00       	call   801d87 <sys_run_env>
  800289:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	ff 75 d8             	pushl  -0x28(%ebp)
  800292:	e8 f0 1a 00 00       	call   801d87 <sys_run_env>
  800297:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  80029a:	83 ec 0c             	sub    $0xc,%esp
  80029d:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002a0:	e8 e2 1a 00 00       	call   801d87 <sys_run_env>
  8002a5:	83 c4 10             	add    $0x10,%esp

	env_sleep(12000) ;
  8002a8:	83 ec 0c             	sub    $0xc,%esp
  8002ab:	68 e0 2e 00 00       	push   $0x2ee0
  8002b0:	e8 8e 2f 00 00       	call   803243 <env_sleep>
  8002b5:	83 c4 10             	add    $0x10,%esp

	//to ensure that the slave environments completed successfully
	if (gettst()!=3) panic("test failed");
  8002b8:	e8 72 1c 00 00       	call   801f2f <gettst>
  8002bd:	83 f8 03             	cmp    $0x3,%eax
  8002c0:	74 14                	je     8002d6 <_main+0x29e>
  8002c2:	83 ec 04             	sub    $0x4,%esp
  8002c5:	68 97 36 80 00       	push   $0x803697
  8002ca:	6a 3f                	push   $0x3f
  8002cc:	68 7c 35 80 00       	push   $0x80357c
  8002d1:	e8 d1 01 00 00       	call   8004a7 <_panic>


	if (*z != 30)
  8002d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002d9:	8b 00                	mov    (%eax),%eax
  8002db:	83 f8 1e             	cmp    $0x1e,%eax
  8002de:	74 14                	je     8002f4 <_main+0x2bc>
		panic("Error!! Please check the creation (or the getting) of shared variables!!\n\n\n");
  8002e0:	83 ec 04             	sub    $0x4,%esp
  8002e3:	68 a4 36 80 00       	push   $0x8036a4
  8002e8:	6a 43                	push   $0x43
  8002ea:	68 7c 35 80 00       	push   $0x80357c
  8002ef:	e8 b3 01 00 00       	call   8004a7 <_panic>
	else
		cprintf("Congratulations!! Test of Shared Variables [Create & Get] [2] completed successfully!!\n\n\n");
  8002f4:	83 ec 0c             	sub    $0xc,%esp
  8002f7:	68 f0 36 80 00       	push   $0x8036f0
  8002fc:	e8 5a 04 00 00       	call   80075b <cprintf>
  800301:	83 c4 10             	add    $0x10,%esp

	cprintf("Now, ILLEGAL MEM ACCESS should be occur, due to attempting to write a ReadOnly variable\n\n\n");
  800304:	83 ec 0c             	sub    $0xc,%esp
  800307:	68 4c 37 80 00       	push   $0x80374c
  80030c:	e8 4a 04 00 00       	call   80075b <cprintf>
  800311:	83 c4 10             	add    $0x10,%esp

	id1 = sys_create_env("shr2Slave2", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800314:	a1 20 40 80 00       	mov    0x804020,%eax
  800319:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80031f:	a1 20 40 80 00       	mov    0x804020,%eax
  800324:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80032a:	89 c1                	mov    %eax,%ecx
  80032c:	a1 20 40 80 00       	mov    0x804020,%eax
  800331:	8b 40 74             	mov    0x74(%eax),%eax
  800334:	52                   	push   %edx
  800335:	51                   	push   %ecx
  800336:	50                   	push   %eax
  800337:	68 a7 37 80 00       	push   $0x8037a7
  80033c:	e8 28 1a 00 00       	call   801d69 <sys_create_env>
  800341:	83 c4 10             	add    $0x10,%esp
  800344:	89 45 dc             	mov    %eax,-0x24(%ebp)

	env_sleep(3000) ;
  800347:	83 ec 0c             	sub    $0xc,%esp
  80034a:	68 b8 0b 00 00       	push   $0xbb8
  80034f:	e8 ef 2e 00 00       	call   803243 <env_sleep>
  800354:	83 c4 10             	add    $0x10,%esp

	sys_run_env(id1);
  800357:	83 ec 0c             	sub    $0xc,%esp
  80035a:	ff 75 dc             	pushl  -0x24(%ebp)
  80035d:	e8 25 1a 00 00       	call   801d87 <sys_run_env>
  800362:	83 c4 10             	add    $0x10,%esp

	return;
  800365:	90                   	nop
}
  800366:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800369:	c9                   	leave  
  80036a:	c3                   	ret    

0080036b <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80036b:	55                   	push   %ebp
  80036c:	89 e5                	mov    %esp,%ebp
  80036e:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800371:	e8 61 1a 00 00       	call   801dd7 <sys_getenvindex>
  800376:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800379:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80037c:	89 d0                	mov    %edx,%eax
  80037e:	c1 e0 03             	shl    $0x3,%eax
  800381:	01 d0                	add    %edx,%eax
  800383:	01 c0                	add    %eax,%eax
  800385:	01 d0                	add    %edx,%eax
  800387:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80038e:	01 d0                	add    %edx,%eax
  800390:	c1 e0 04             	shl    $0x4,%eax
  800393:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800398:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80039d:	a1 20 40 80 00       	mov    0x804020,%eax
  8003a2:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8003a8:	84 c0                	test   %al,%al
  8003aa:	74 0f                	je     8003bb <libmain+0x50>
		binaryname = myEnv->prog_name;
  8003ac:	a1 20 40 80 00       	mov    0x804020,%eax
  8003b1:	05 5c 05 00 00       	add    $0x55c,%eax
  8003b6:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003bf:	7e 0a                	jle    8003cb <libmain+0x60>
		binaryname = argv[0];
  8003c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c4:	8b 00                	mov    (%eax),%eax
  8003c6:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8003cb:	83 ec 08             	sub    $0x8,%esp
  8003ce:	ff 75 0c             	pushl  0xc(%ebp)
  8003d1:	ff 75 08             	pushl  0x8(%ebp)
  8003d4:	e8 5f fc ff ff       	call   800038 <_main>
  8003d9:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8003dc:	e8 03 18 00 00       	call   801be4 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003e1:	83 ec 0c             	sub    $0xc,%esp
  8003e4:	68 cc 37 80 00       	push   $0x8037cc
  8003e9:	e8 6d 03 00 00       	call   80075b <cprintf>
  8003ee:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003f1:	a1 20 40 80 00       	mov    0x804020,%eax
  8003f6:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8003fc:	a1 20 40 80 00       	mov    0x804020,%eax
  800401:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800407:	83 ec 04             	sub    $0x4,%esp
  80040a:	52                   	push   %edx
  80040b:	50                   	push   %eax
  80040c:	68 f4 37 80 00       	push   $0x8037f4
  800411:	e8 45 03 00 00       	call   80075b <cprintf>
  800416:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800419:	a1 20 40 80 00       	mov    0x804020,%eax
  80041e:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800424:	a1 20 40 80 00       	mov    0x804020,%eax
  800429:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80042f:	a1 20 40 80 00       	mov    0x804020,%eax
  800434:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80043a:	51                   	push   %ecx
  80043b:	52                   	push   %edx
  80043c:	50                   	push   %eax
  80043d:	68 1c 38 80 00       	push   $0x80381c
  800442:	e8 14 03 00 00       	call   80075b <cprintf>
  800447:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80044a:	a1 20 40 80 00       	mov    0x804020,%eax
  80044f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800455:	83 ec 08             	sub    $0x8,%esp
  800458:	50                   	push   %eax
  800459:	68 74 38 80 00       	push   $0x803874
  80045e:	e8 f8 02 00 00       	call   80075b <cprintf>
  800463:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800466:	83 ec 0c             	sub    $0xc,%esp
  800469:	68 cc 37 80 00       	push   $0x8037cc
  80046e:	e8 e8 02 00 00       	call   80075b <cprintf>
  800473:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800476:	e8 83 17 00 00       	call   801bfe <sys_enable_interrupt>

	// exit gracefully
	exit();
  80047b:	e8 19 00 00 00       	call   800499 <exit>
}
  800480:	90                   	nop
  800481:	c9                   	leave  
  800482:	c3                   	ret    

00800483 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800483:	55                   	push   %ebp
  800484:	89 e5                	mov    %esp,%ebp
  800486:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800489:	83 ec 0c             	sub    $0xc,%esp
  80048c:	6a 00                	push   $0x0
  80048e:	e8 10 19 00 00       	call   801da3 <sys_destroy_env>
  800493:	83 c4 10             	add    $0x10,%esp
}
  800496:	90                   	nop
  800497:	c9                   	leave  
  800498:	c3                   	ret    

00800499 <exit>:

void
exit(void)
{
  800499:	55                   	push   %ebp
  80049a:	89 e5                	mov    %esp,%ebp
  80049c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80049f:	e8 65 19 00 00       	call   801e09 <sys_exit_env>
}
  8004a4:	90                   	nop
  8004a5:	c9                   	leave  
  8004a6:	c3                   	ret    

008004a7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004a7:	55                   	push   %ebp
  8004a8:	89 e5                	mov    %esp,%ebp
  8004aa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004ad:	8d 45 10             	lea    0x10(%ebp),%eax
  8004b0:	83 c0 04             	add    $0x4,%eax
  8004b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004b6:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8004bb:	85 c0                	test   %eax,%eax
  8004bd:	74 16                	je     8004d5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004bf:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8004c4:	83 ec 08             	sub    $0x8,%esp
  8004c7:	50                   	push   %eax
  8004c8:	68 88 38 80 00       	push   $0x803888
  8004cd:	e8 89 02 00 00       	call   80075b <cprintf>
  8004d2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8004d5:	a1 00 40 80 00       	mov    0x804000,%eax
  8004da:	ff 75 0c             	pushl  0xc(%ebp)
  8004dd:	ff 75 08             	pushl  0x8(%ebp)
  8004e0:	50                   	push   %eax
  8004e1:	68 8d 38 80 00       	push   $0x80388d
  8004e6:	e8 70 02 00 00       	call   80075b <cprintf>
  8004eb:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8004ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8004f1:	83 ec 08             	sub    $0x8,%esp
  8004f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8004f7:	50                   	push   %eax
  8004f8:	e8 f3 01 00 00       	call   8006f0 <vcprintf>
  8004fd:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800500:	83 ec 08             	sub    $0x8,%esp
  800503:	6a 00                	push   $0x0
  800505:	68 a9 38 80 00       	push   $0x8038a9
  80050a:	e8 e1 01 00 00       	call   8006f0 <vcprintf>
  80050f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800512:	e8 82 ff ff ff       	call   800499 <exit>

	// should not return here
	while (1) ;
  800517:	eb fe                	jmp    800517 <_panic+0x70>

00800519 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800519:	55                   	push   %ebp
  80051a:	89 e5                	mov    %esp,%ebp
  80051c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80051f:	a1 20 40 80 00       	mov    0x804020,%eax
  800524:	8b 50 74             	mov    0x74(%eax),%edx
  800527:	8b 45 0c             	mov    0xc(%ebp),%eax
  80052a:	39 c2                	cmp    %eax,%edx
  80052c:	74 14                	je     800542 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80052e:	83 ec 04             	sub    $0x4,%esp
  800531:	68 ac 38 80 00       	push   $0x8038ac
  800536:	6a 26                	push   $0x26
  800538:	68 f8 38 80 00       	push   $0x8038f8
  80053d:	e8 65 ff ff ff       	call   8004a7 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800542:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800549:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800550:	e9 c2 00 00 00       	jmp    800617 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800555:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800558:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80055f:	8b 45 08             	mov    0x8(%ebp),%eax
  800562:	01 d0                	add    %edx,%eax
  800564:	8b 00                	mov    (%eax),%eax
  800566:	85 c0                	test   %eax,%eax
  800568:	75 08                	jne    800572 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80056a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80056d:	e9 a2 00 00 00       	jmp    800614 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800572:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800579:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800580:	eb 69                	jmp    8005eb <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800582:	a1 20 40 80 00       	mov    0x804020,%eax
  800587:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80058d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800590:	89 d0                	mov    %edx,%eax
  800592:	01 c0                	add    %eax,%eax
  800594:	01 d0                	add    %edx,%eax
  800596:	c1 e0 03             	shl    $0x3,%eax
  800599:	01 c8                	add    %ecx,%eax
  80059b:	8a 40 04             	mov    0x4(%eax),%al
  80059e:	84 c0                	test   %al,%al
  8005a0:	75 46                	jne    8005e8 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005a2:	a1 20 40 80 00       	mov    0x804020,%eax
  8005a7:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005ad:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005b0:	89 d0                	mov    %edx,%eax
  8005b2:	01 c0                	add    %eax,%eax
  8005b4:	01 d0                	add    %edx,%eax
  8005b6:	c1 e0 03             	shl    $0x3,%eax
  8005b9:	01 c8                	add    %ecx,%eax
  8005bb:	8b 00                	mov    (%eax),%eax
  8005bd:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005c0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005c3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005c8:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005cd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d7:	01 c8                	add    %ecx,%eax
  8005d9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005db:	39 c2                	cmp    %eax,%edx
  8005dd:	75 09                	jne    8005e8 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8005df:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005e6:	eb 12                	jmp    8005fa <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005e8:	ff 45 e8             	incl   -0x18(%ebp)
  8005eb:	a1 20 40 80 00       	mov    0x804020,%eax
  8005f0:	8b 50 74             	mov    0x74(%eax),%edx
  8005f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005f6:	39 c2                	cmp    %eax,%edx
  8005f8:	77 88                	ja     800582 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005fa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005fe:	75 14                	jne    800614 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800600:	83 ec 04             	sub    $0x4,%esp
  800603:	68 04 39 80 00       	push   $0x803904
  800608:	6a 3a                	push   $0x3a
  80060a:	68 f8 38 80 00       	push   $0x8038f8
  80060f:	e8 93 fe ff ff       	call   8004a7 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800614:	ff 45 f0             	incl   -0x10(%ebp)
  800617:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80061a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80061d:	0f 8c 32 ff ff ff    	jl     800555 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800623:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80062a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800631:	eb 26                	jmp    800659 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800633:	a1 20 40 80 00       	mov    0x804020,%eax
  800638:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80063e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800641:	89 d0                	mov    %edx,%eax
  800643:	01 c0                	add    %eax,%eax
  800645:	01 d0                	add    %edx,%eax
  800647:	c1 e0 03             	shl    $0x3,%eax
  80064a:	01 c8                	add    %ecx,%eax
  80064c:	8a 40 04             	mov    0x4(%eax),%al
  80064f:	3c 01                	cmp    $0x1,%al
  800651:	75 03                	jne    800656 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800653:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800656:	ff 45 e0             	incl   -0x20(%ebp)
  800659:	a1 20 40 80 00       	mov    0x804020,%eax
  80065e:	8b 50 74             	mov    0x74(%eax),%edx
  800661:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800664:	39 c2                	cmp    %eax,%edx
  800666:	77 cb                	ja     800633 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800668:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80066b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80066e:	74 14                	je     800684 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800670:	83 ec 04             	sub    $0x4,%esp
  800673:	68 58 39 80 00       	push   $0x803958
  800678:	6a 44                	push   $0x44
  80067a:	68 f8 38 80 00       	push   $0x8038f8
  80067f:	e8 23 fe ff ff       	call   8004a7 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800684:	90                   	nop
  800685:	c9                   	leave  
  800686:	c3                   	ret    

00800687 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800687:	55                   	push   %ebp
  800688:	89 e5                	mov    %esp,%ebp
  80068a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80068d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800690:	8b 00                	mov    (%eax),%eax
  800692:	8d 48 01             	lea    0x1(%eax),%ecx
  800695:	8b 55 0c             	mov    0xc(%ebp),%edx
  800698:	89 0a                	mov    %ecx,(%edx)
  80069a:	8b 55 08             	mov    0x8(%ebp),%edx
  80069d:	88 d1                	mov    %dl,%cl
  80069f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006a2:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006a9:	8b 00                	mov    (%eax),%eax
  8006ab:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006b0:	75 2c                	jne    8006de <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8006b2:	a0 24 40 80 00       	mov    0x804024,%al
  8006b7:	0f b6 c0             	movzbl %al,%eax
  8006ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006bd:	8b 12                	mov    (%edx),%edx
  8006bf:	89 d1                	mov    %edx,%ecx
  8006c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006c4:	83 c2 08             	add    $0x8,%edx
  8006c7:	83 ec 04             	sub    $0x4,%esp
  8006ca:	50                   	push   %eax
  8006cb:	51                   	push   %ecx
  8006cc:	52                   	push   %edx
  8006cd:	e8 64 13 00 00       	call   801a36 <sys_cputs>
  8006d2:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e1:	8b 40 04             	mov    0x4(%eax),%eax
  8006e4:	8d 50 01             	lea    0x1(%eax),%edx
  8006e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ea:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006ed:	90                   	nop
  8006ee:	c9                   	leave  
  8006ef:	c3                   	ret    

008006f0 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006f0:	55                   	push   %ebp
  8006f1:	89 e5                	mov    %esp,%ebp
  8006f3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006f9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800700:	00 00 00 
	b.cnt = 0;
  800703:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80070a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80070d:	ff 75 0c             	pushl  0xc(%ebp)
  800710:	ff 75 08             	pushl  0x8(%ebp)
  800713:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800719:	50                   	push   %eax
  80071a:	68 87 06 80 00       	push   $0x800687
  80071f:	e8 11 02 00 00       	call   800935 <vprintfmt>
  800724:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800727:	a0 24 40 80 00       	mov    0x804024,%al
  80072c:	0f b6 c0             	movzbl %al,%eax
  80072f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800735:	83 ec 04             	sub    $0x4,%esp
  800738:	50                   	push   %eax
  800739:	52                   	push   %edx
  80073a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800740:	83 c0 08             	add    $0x8,%eax
  800743:	50                   	push   %eax
  800744:	e8 ed 12 00 00       	call   801a36 <sys_cputs>
  800749:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80074c:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800753:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800759:	c9                   	leave  
  80075a:	c3                   	ret    

0080075b <cprintf>:

int cprintf(const char *fmt, ...) {
  80075b:	55                   	push   %ebp
  80075c:	89 e5                	mov    %esp,%ebp
  80075e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800761:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800768:	8d 45 0c             	lea    0xc(%ebp),%eax
  80076b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80076e:	8b 45 08             	mov    0x8(%ebp),%eax
  800771:	83 ec 08             	sub    $0x8,%esp
  800774:	ff 75 f4             	pushl  -0xc(%ebp)
  800777:	50                   	push   %eax
  800778:	e8 73 ff ff ff       	call   8006f0 <vcprintf>
  80077d:	83 c4 10             	add    $0x10,%esp
  800780:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800783:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800786:	c9                   	leave  
  800787:	c3                   	ret    

00800788 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800788:	55                   	push   %ebp
  800789:	89 e5                	mov    %esp,%ebp
  80078b:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80078e:	e8 51 14 00 00       	call   801be4 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800793:	8d 45 0c             	lea    0xc(%ebp),%eax
  800796:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800799:	8b 45 08             	mov    0x8(%ebp),%eax
  80079c:	83 ec 08             	sub    $0x8,%esp
  80079f:	ff 75 f4             	pushl  -0xc(%ebp)
  8007a2:	50                   	push   %eax
  8007a3:	e8 48 ff ff ff       	call   8006f0 <vcprintf>
  8007a8:	83 c4 10             	add    $0x10,%esp
  8007ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007ae:	e8 4b 14 00 00       	call   801bfe <sys_enable_interrupt>
	return cnt;
  8007b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007b6:	c9                   	leave  
  8007b7:	c3                   	ret    

008007b8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007b8:	55                   	push   %ebp
  8007b9:	89 e5                	mov    %esp,%ebp
  8007bb:	53                   	push   %ebx
  8007bc:	83 ec 14             	sub    $0x14,%esp
  8007bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8007c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007cb:	8b 45 18             	mov    0x18(%ebp),%eax
  8007ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007d6:	77 55                	ja     80082d <printnum+0x75>
  8007d8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007db:	72 05                	jb     8007e2 <printnum+0x2a>
  8007dd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007e0:	77 4b                	ja     80082d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007e2:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007e5:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007e8:	8b 45 18             	mov    0x18(%ebp),%eax
  8007eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f0:	52                   	push   %edx
  8007f1:	50                   	push   %eax
  8007f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8007f5:	ff 75 f0             	pushl  -0x10(%ebp)
  8007f8:	e8 fb 2a 00 00       	call   8032f8 <__udivdi3>
  8007fd:	83 c4 10             	add    $0x10,%esp
  800800:	83 ec 04             	sub    $0x4,%esp
  800803:	ff 75 20             	pushl  0x20(%ebp)
  800806:	53                   	push   %ebx
  800807:	ff 75 18             	pushl  0x18(%ebp)
  80080a:	52                   	push   %edx
  80080b:	50                   	push   %eax
  80080c:	ff 75 0c             	pushl  0xc(%ebp)
  80080f:	ff 75 08             	pushl  0x8(%ebp)
  800812:	e8 a1 ff ff ff       	call   8007b8 <printnum>
  800817:	83 c4 20             	add    $0x20,%esp
  80081a:	eb 1a                	jmp    800836 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80081c:	83 ec 08             	sub    $0x8,%esp
  80081f:	ff 75 0c             	pushl  0xc(%ebp)
  800822:	ff 75 20             	pushl  0x20(%ebp)
  800825:	8b 45 08             	mov    0x8(%ebp),%eax
  800828:	ff d0                	call   *%eax
  80082a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80082d:	ff 4d 1c             	decl   0x1c(%ebp)
  800830:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800834:	7f e6                	jg     80081c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800836:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800839:	bb 00 00 00 00       	mov    $0x0,%ebx
  80083e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800841:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800844:	53                   	push   %ebx
  800845:	51                   	push   %ecx
  800846:	52                   	push   %edx
  800847:	50                   	push   %eax
  800848:	e8 bb 2b 00 00       	call   803408 <__umoddi3>
  80084d:	83 c4 10             	add    $0x10,%esp
  800850:	05 d4 3b 80 00       	add    $0x803bd4,%eax
  800855:	8a 00                	mov    (%eax),%al
  800857:	0f be c0             	movsbl %al,%eax
  80085a:	83 ec 08             	sub    $0x8,%esp
  80085d:	ff 75 0c             	pushl  0xc(%ebp)
  800860:	50                   	push   %eax
  800861:	8b 45 08             	mov    0x8(%ebp),%eax
  800864:	ff d0                	call   *%eax
  800866:	83 c4 10             	add    $0x10,%esp
}
  800869:	90                   	nop
  80086a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80086d:	c9                   	leave  
  80086e:	c3                   	ret    

0080086f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80086f:	55                   	push   %ebp
  800870:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800872:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800876:	7e 1c                	jle    800894 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800878:	8b 45 08             	mov    0x8(%ebp),%eax
  80087b:	8b 00                	mov    (%eax),%eax
  80087d:	8d 50 08             	lea    0x8(%eax),%edx
  800880:	8b 45 08             	mov    0x8(%ebp),%eax
  800883:	89 10                	mov    %edx,(%eax)
  800885:	8b 45 08             	mov    0x8(%ebp),%eax
  800888:	8b 00                	mov    (%eax),%eax
  80088a:	83 e8 08             	sub    $0x8,%eax
  80088d:	8b 50 04             	mov    0x4(%eax),%edx
  800890:	8b 00                	mov    (%eax),%eax
  800892:	eb 40                	jmp    8008d4 <getuint+0x65>
	else if (lflag)
  800894:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800898:	74 1e                	je     8008b8 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80089a:	8b 45 08             	mov    0x8(%ebp),%eax
  80089d:	8b 00                	mov    (%eax),%eax
  80089f:	8d 50 04             	lea    0x4(%eax),%edx
  8008a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a5:	89 10                	mov    %edx,(%eax)
  8008a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008aa:	8b 00                	mov    (%eax),%eax
  8008ac:	83 e8 04             	sub    $0x4,%eax
  8008af:	8b 00                	mov    (%eax),%eax
  8008b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8008b6:	eb 1c                	jmp    8008d4 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bb:	8b 00                	mov    (%eax),%eax
  8008bd:	8d 50 04             	lea    0x4(%eax),%edx
  8008c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c3:	89 10                	mov    %edx,(%eax)
  8008c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c8:	8b 00                	mov    (%eax),%eax
  8008ca:	83 e8 04             	sub    $0x4,%eax
  8008cd:	8b 00                	mov    (%eax),%eax
  8008cf:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008d4:	5d                   	pop    %ebp
  8008d5:	c3                   	ret    

008008d6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008d6:	55                   	push   %ebp
  8008d7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008d9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008dd:	7e 1c                	jle    8008fb <getint+0x25>
		return va_arg(*ap, long long);
  8008df:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e2:	8b 00                	mov    (%eax),%eax
  8008e4:	8d 50 08             	lea    0x8(%eax),%edx
  8008e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ea:	89 10                	mov    %edx,(%eax)
  8008ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ef:	8b 00                	mov    (%eax),%eax
  8008f1:	83 e8 08             	sub    $0x8,%eax
  8008f4:	8b 50 04             	mov    0x4(%eax),%edx
  8008f7:	8b 00                	mov    (%eax),%eax
  8008f9:	eb 38                	jmp    800933 <getint+0x5d>
	else if (lflag)
  8008fb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008ff:	74 1a                	je     80091b <getint+0x45>
		return va_arg(*ap, long);
  800901:	8b 45 08             	mov    0x8(%ebp),%eax
  800904:	8b 00                	mov    (%eax),%eax
  800906:	8d 50 04             	lea    0x4(%eax),%edx
  800909:	8b 45 08             	mov    0x8(%ebp),%eax
  80090c:	89 10                	mov    %edx,(%eax)
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	8b 00                	mov    (%eax),%eax
  800913:	83 e8 04             	sub    $0x4,%eax
  800916:	8b 00                	mov    (%eax),%eax
  800918:	99                   	cltd   
  800919:	eb 18                	jmp    800933 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	8b 00                	mov    (%eax),%eax
  800920:	8d 50 04             	lea    0x4(%eax),%edx
  800923:	8b 45 08             	mov    0x8(%ebp),%eax
  800926:	89 10                	mov    %edx,(%eax)
  800928:	8b 45 08             	mov    0x8(%ebp),%eax
  80092b:	8b 00                	mov    (%eax),%eax
  80092d:	83 e8 04             	sub    $0x4,%eax
  800930:	8b 00                	mov    (%eax),%eax
  800932:	99                   	cltd   
}
  800933:	5d                   	pop    %ebp
  800934:	c3                   	ret    

00800935 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800935:	55                   	push   %ebp
  800936:	89 e5                	mov    %esp,%ebp
  800938:	56                   	push   %esi
  800939:	53                   	push   %ebx
  80093a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80093d:	eb 17                	jmp    800956 <vprintfmt+0x21>
			if (ch == '\0')
  80093f:	85 db                	test   %ebx,%ebx
  800941:	0f 84 af 03 00 00    	je     800cf6 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800947:	83 ec 08             	sub    $0x8,%esp
  80094a:	ff 75 0c             	pushl  0xc(%ebp)
  80094d:	53                   	push   %ebx
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	ff d0                	call   *%eax
  800953:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800956:	8b 45 10             	mov    0x10(%ebp),%eax
  800959:	8d 50 01             	lea    0x1(%eax),%edx
  80095c:	89 55 10             	mov    %edx,0x10(%ebp)
  80095f:	8a 00                	mov    (%eax),%al
  800961:	0f b6 d8             	movzbl %al,%ebx
  800964:	83 fb 25             	cmp    $0x25,%ebx
  800967:	75 d6                	jne    80093f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800969:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80096d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800974:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80097b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800982:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800989:	8b 45 10             	mov    0x10(%ebp),%eax
  80098c:	8d 50 01             	lea    0x1(%eax),%edx
  80098f:	89 55 10             	mov    %edx,0x10(%ebp)
  800992:	8a 00                	mov    (%eax),%al
  800994:	0f b6 d8             	movzbl %al,%ebx
  800997:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80099a:	83 f8 55             	cmp    $0x55,%eax
  80099d:	0f 87 2b 03 00 00    	ja     800cce <vprintfmt+0x399>
  8009a3:	8b 04 85 f8 3b 80 00 	mov    0x803bf8(,%eax,4),%eax
  8009aa:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009ac:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009b0:	eb d7                	jmp    800989 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009b2:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009b6:	eb d1                	jmp    800989 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009b8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009bf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009c2:	89 d0                	mov    %edx,%eax
  8009c4:	c1 e0 02             	shl    $0x2,%eax
  8009c7:	01 d0                	add    %edx,%eax
  8009c9:	01 c0                	add    %eax,%eax
  8009cb:	01 d8                	add    %ebx,%eax
  8009cd:	83 e8 30             	sub    $0x30,%eax
  8009d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8009d6:	8a 00                	mov    (%eax),%al
  8009d8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009db:	83 fb 2f             	cmp    $0x2f,%ebx
  8009de:	7e 3e                	jle    800a1e <vprintfmt+0xe9>
  8009e0:	83 fb 39             	cmp    $0x39,%ebx
  8009e3:	7f 39                	jg     800a1e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009e5:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009e8:	eb d5                	jmp    8009bf <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ed:	83 c0 04             	add    $0x4,%eax
  8009f0:	89 45 14             	mov    %eax,0x14(%ebp)
  8009f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f6:	83 e8 04             	sub    $0x4,%eax
  8009f9:	8b 00                	mov    (%eax),%eax
  8009fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009fe:	eb 1f                	jmp    800a1f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a00:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a04:	79 83                	jns    800989 <vprintfmt+0x54>
				width = 0;
  800a06:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a0d:	e9 77 ff ff ff       	jmp    800989 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a12:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a19:	e9 6b ff ff ff       	jmp    800989 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a1e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a1f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a23:	0f 89 60 ff ff ff    	jns    800989 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a29:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a2c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a2f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a36:	e9 4e ff ff ff       	jmp    800989 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a3b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a3e:	e9 46 ff ff ff       	jmp    800989 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a43:	8b 45 14             	mov    0x14(%ebp),%eax
  800a46:	83 c0 04             	add    $0x4,%eax
  800a49:	89 45 14             	mov    %eax,0x14(%ebp)
  800a4c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4f:	83 e8 04             	sub    $0x4,%eax
  800a52:	8b 00                	mov    (%eax),%eax
  800a54:	83 ec 08             	sub    $0x8,%esp
  800a57:	ff 75 0c             	pushl  0xc(%ebp)
  800a5a:	50                   	push   %eax
  800a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5e:	ff d0                	call   *%eax
  800a60:	83 c4 10             	add    $0x10,%esp
			break;
  800a63:	e9 89 02 00 00       	jmp    800cf1 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a68:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6b:	83 c0 04             	add    $0x4,%eax
  800a6e:	89 45 14             	mov    %eax,0x14(%ebp)
  800a71:	8b 45 14             	mov    0x14(%ebp),%eax
  800a74:	83 e8 04             	sub    $0x4,%eax
  800a77:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a79:	85 db                	test   %ebx,%ebx
  800a7b:	79 02                	jns    800a7f <vprintfmt+0x14a>
				err = -err;
  800a7d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a7f:	83 fb 64             	cmp    $0x64,%ebx
  800a82:	7f 0b                	jg     800a8f <vprintfmt+0x15a>
  800a84:	8b 34 9d 40 3a 80 00 	mov    0x803a40(,%ebx,4),%esi
  800a8b:	85 f6                	test   %esi,%esi
  800a8d:	75 19                	jne    800aa8 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a8f:	53                   	push   %ebx
  800a90:	68 e5 3b 80 00       	push   $0x803be5
  800a95:	ff 75 0c             	pushl  0xc(%ebp)
  800a98:	ff 75 08             	pushl  0x8(%ebp)
  800a9b:	e8 5e 02 00 00       	call   800cfe <printfmt>
  800aa0:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800aa3:	e9 49 02 00 00       	jmp    800cf1 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800aa8:	56                   	push   %esi
  800aa9:	68 ee 3b 80 00       	push   $0x803bee
  800aae:	ff 75 0c             	pushl  0xc(%ebp)
  800ab1:	ff 75 08             	pushl  0x8(%ebp)
  800ab4:	e8 45 02 00 00       	call   800cfe <printfmt>
  800ab9:	83 c4 10             	add    $0x10,%esp
			break;
  800abc:	e9 30 02 00 00       	jmp    800cf1 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ac1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac4:	83 c0 04             	add    $0x4,%eax
  800ac7:	89 45 14             	mov    %eax,0x14(%ebp)
  800aca:	8b 45 14             	mov    0x14(%ebp),%eax
  800acd:	83 e8 04             	sub    $0x4,%eax
  800ad0:	8b 30                	mov    (%eax),%esi
  800ad2:	85 f6                	test   %esi,%esi
  800ad4:	75 05                	jne    800adb <vprintfmt+0x1a6>
				p = "(null)";
  800ad6:	be f1 3b 80 00       	mov    $0x803bf1,%esi
			if (width > 0 && padc != '-')
  800adb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800adf:	7e 6d                	jle    800b4e <vprintfmt+0x219>
  800ae1:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ae5:	74 67                	je     800b4e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ae7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800aea:	83 ec 08             	sub    $0x8,%esp
  800aed:	50                   	push   %eax
  800aee:	56                   	push   %esi
  800aef:	e8 0c 03 00 00       	call   800e00 <strnlen>
  800af4:	83 c4 10             	add    $0x10,%esp
  800af7:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800afa:	eb 16                	jmp    800b12 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800afc:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b00:	83 ec 08             	sub    $0x8,%esp
  800b03:	ff 75 0c             	pushl  0xc(%ebp)
  800b06:	50                   	push   %eax
  800b07:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0a:	ff d0                	call   *%eax
  800b0c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b0f:	ff 4d e4             	decl   -0x1c(%ebp)
  800b12:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b16:	7f e4                	jg     800afc <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b18:	eb 34                	jmp    800b4e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b1a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b1e:	74 1c                	je     800b3c <vprintfmt+0x207>
  800b20:	83 fb 1f             	cmp    $0x1f,%ebx
  800b23:	7e 05                	jle    800b2a <vprintfmt+0x1f5>
  800b25:	83 fb 7e             	cmp    $0x7e,%ebx
  800b28:	7e 12                	jle    800b3c <vprintfmt+0x207>
					putch('?', putdat);
  800b2a:	83 ec 08             	sub    $0x8,%esp
  800b2d:	ff 75 0c             	pushl  0xc(%ebp)
  800b30:	6a 3f                	push   $0x3f
  800b32:	8b 45 08             	mov    0x8(%ebp),%eax
  800b35:	ff d0                	call   *%eax
  800b37:	83 c4 10             	add    $0x10,%esp
  800b3a:	eb 0f                	jmp    800b4b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b3c:	83 ec 08             	sub    $0x8,%esp
  800b3f:	ff 75 0c             	pushl  0xc(%ebp)
  800b42:	53                   	push   %ebx
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	ff d0                	call   *%eax
  800b48:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b4b:	ff 4d e4             	decl   -0x1c(%ebp)
  800b4e:	89 f0                	mov    %esi,%eax
  800b50:	8d 70 01             	lea    0x1(%eax),%esi
  800b53:	8a 00                	mov    (%eax),%al
  800b55:	0f be d8             	movsbl %al,%ebx
  800b58:	85 db                	test   %ebx,%ebx
  800b5a:	74 24                	je     800b80 <vprintfmt+0x24b>
  800b5c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b60:	78 b8                	js     800b1a <vprintfmt+0x1e5>
  800b62:	ff 4d e0             	decl   -0x20(%ebp)
  800b65:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b69:	79 af                	jns    800b1a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b6b:	eb 13                	jmp    800b80 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b6d:	83 ec 08             	sub    $0x8,%esp
  800b70:	ff 75 0c             	pushl  0xc(%ebp)
  800b73:	6a 20                	push   $0x20
  800b75:	8b 45 08             	mov    0x8(%ebp),%eax
  800b78:	ff d0                	call   *%eax
  800b7a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b7d:	ff 4d e4             	decl   -0x1c(%ebp)
  800b80:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b84:	7f e7                	jg     800b6d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b86:	e9 66 01 00 00       	jmp    800cf1 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b8b:	83 ec 08             	sub    $0x8,%esp
  800b8e:	ff 75 e8             	pushl  -0x18(%ebp)
  800b91:	8d 45 14             	lea    0x14(%ebp),%eax
  800b94:	50                   	push   %eax
  800b95:	e8 3c fd ff ff       	call   8008d6 <getint>
  800b9a:	83 c4 10             	add    $0x10,%esp
  800b9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ba0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ba3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ba6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ba9:	85 d2                	test   %edx,%edx
  800bab:	79 23                	jns    800bd0 <vprintfmt+0x29b>
				putch('-', putdat);
  800bad:	83 ec 08             	sub    $0x8,%esp
  800bb0:	ff 75 0c             	pushl  0xc(%ebp)
  800bb3:	6a 2d                	push   $0x2d
  800bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb8:	ff d0                	call   *%eax
  800bba:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bc0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bc3:	f7 d8                	neg    %eax
  800bc5:	83 d2 00             	adc    $0x0,%edx
  800bc8:	f7 da                	neg    %edx
  800bca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bcd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bd0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bd7:	e9 bc 00 00 00       	jmp    800c98 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bdc:	83 ec 08             	sub    $0x8,%esp
  800bdf:	ff 75 e8             	pushl  -0x18(%ebp)
  800be2:	8d 45 14             	lea    0x14(%ebp),%eax
  800be5:	50                   	push   %eax
  800be6:	e8 84 fc ff ff       	call   80086f <getuint>
  800beb:	83 c4 10             	add    $0x10,%esp
  800bee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800bf4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bfb:	e9 98 00 00 00       	jmp    800c98 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c00:	83 ec 08             	sub    $0x8,%esp
  800c03:	ff 75 0c             	pushl  0xc(%ebp)
  800c06:	6a 58                	push   $0x58
  800c08:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0b:	ff d0                	call   *%eax
  800c0d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c10:	83 ec 08             	sub    $0x8,%esp
  800c13:	ff 75 0c             	pushl  0xc(%ebp)
  800c16:	6a 58                	push   $0x58
  800c18:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1b:	ff d0                	call   *%eax
  800c1d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c20:	83 ec 08             	sub    $0x8,%esp
  800c23:	ff 75 0c             	pushl  0xc(%ebp)
  800c26:	6a 58                	push   $0x58
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2b:	ff d0                	call   *%eax
  800c2d:	83 c4 10             	add    $0x10,%esp
			break;
  800c30:	e9 bc 00 00 00       	jmp    800cf1 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c35:	83 ec 08             	sub    $0x8,%esp
  800c38:	ff 75 0c             	pushl  0xc(%ebp)
  800c3b:	6a 30                	push   $0x30
  800c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c40:	ff d0                	call   *%eax
  800c42:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c45:	83 ec 08             	sub    $0x8,%esp
  800c48:	ff 75 0c             	pushl  0xc(%ebp)
  800c4b:	6a 78                	push   $0x78
  800c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c50:	ff d0                	call   *%eax
  800c52:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c55:	8b 45 14             	mov    0x14(%ebp),%eax
  800c58:	83 c0 04             	add    $0x4,%eax
  800c5b:	89 45 14             	mov    %eax,0x14(%ebp)
  800c5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800c61:	83 e8 04             	sub    $0x4,%eax
  800c64:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c66:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c69:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c70:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c77:	eb 1f                	jmp    800c98 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c79:	83 ec 08             	sub    $0x8,%esp
  800c7c:	ff 75 e8             	pushl  -0x18(%ebp)
  800c7f:	8d 45 14             	lea    0x14(%ebp),%eax
  800c82:	50                   	push   %eax
  800c83:	e8 e7 fb ff ff       	call   80086f <getuint>
  800c88:	83 c4 10             	add    $0x10,%esp
  800c8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c8e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c91:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c98:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c9f:	83 ec 04             	sub    $0x4,%esp
  800ca2:	52                   	push   %edx
  800ca3:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ca6:	50                   	push   %eax
  800ca7:	ff 75 f4             	pushl  -0xc(%ebp)
  800caa:	ff 75 f0             	pushl  -0x10(%ebp)
  800cad:	ff 75 0c             	pushl  0xc(%ebp)
  800cb0:	ff 75 08             	pushl  0x8(%ebp)
  800cb3:	e8 00 fb ff ff       	call   8007b8 <printnum>
  800cb8:	83 c4 20             	add    $0x20,%esp
			break;
  800cbb:	eb 34                	jmp    800cf1 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cbd:	83 ec 08             	sub    $0x8,%esp
  800cc0:	ff 75 0c             	pushl  0xc(%ebp)
  800cc3:	53                   	push   %ebx
  800cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc7:	ff d0                	call   *%eax
  800cc9:	83 c4 10             	add    $0x10,%esp
			break;
  800ccc:	eb 23                	jmp    800cf1 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cce:	83 ec 08             	sub    $0x8,%esp
  800cd1:	ff 75 0c             	pushl  0xc(%ebp)
  800cd4:	6a 25                	push   $0x25
  800cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd9:	ff d0                	call   *%eax
  800cdb:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cde:	ff 4d 10             	decl   0x10(%ebp)
  800ce1:	eb 03                	jmp    800ce6 <vprintfmt+0x3b1>
  800ce3:	ff 4d 10             	decl   0x10(%ebp)
  800ce6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ce9:	48                   	dec    %eax
  800cea:	8a 00                	mov    (%eax),%al
  800cec:	3c 25                	cmp    $0x25,%al
  800cee:	75 f3                	jne    800ce3 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800cf0:	90                   	nop
		}
	}
  800cf1:	e9 47 fc ff ff       	jmp    80093d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800cf6:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800cf7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cfa:	5b                   	pop    %ebx
  800cfb:	5e                   	pop    %esi
  800cfc:	5d                   	pop    %ebp
  800cfd:	c3                   	ret    

00800cfe <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800cfe:	55                   	push   %ebp
  800cff:	89 e5                	mov    %esp,%ebp
  800d01:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d04:	8d 45 10             	lea    0x10(%ebp),%eax
  800d07:	83 c0 04             	add    $0x4,%eax
  800d0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d10:	ff 75 f4             	pushl  -0xc(%ebp)
  800d13:	50                   	push   %eax
  800d14:	ff 75 0c             	pushl  0xc(%ebp)
  800d17:	ff 75 08             	pushl  0x8(%ebp)
  800d1a:	e8 16 fc ff ff       	call   800935 <vprintfmt>
  800d1f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d22:	90                   	nop
  800d23:	c9                   	leave  
  800d24:	c3                   	ret    

00800d25 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d25:	55                   	push   %ebp
  800d26:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2b:	8b 40 08             	mov    0x8(%eax),%eax
  800d2e:	8d 50 01             	lea    0x1(%eax),%edx
  800d31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d34:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3a:	8b 10                	mov    (%eax),%edx
  800d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3f:	8b 40 04             	mov    0x4(%eax),%eax
  800d42:	39 c2                	cmp    %eax,%edx
  800d44:	73 12                	jae    800d58 <sprintputch+0x33>
		*b->buf++ = ch;
  800d46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d49:	8b 00                	mov    (%eax),%eax
  800d4b:	8d 48 01             	lea    0x1(%eax),%ecx
  800d4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d51:	89 0a                	mov    %ecx,(%edx)
  800d53:	8b 55 08             	mov    0x8(%ebp),%edx
  800d56:	88 10                	mov    %dl,(%eax)
}
  800d58:	90                   	nop
  800d59:	5d                   	pop    %ebp
  800d5a:	c3                   	ret    

00800d5b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d5b:	55                   	push   %ebp
  800d5c:	89 e5                	mov    %esp,%ebp
  800d5e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
  800d64:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d70:	01 d0                	add    %edx,%eax
  800d72:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d75:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d7c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d80:	74 06                	je     800d88 <vsnprintf+0x2d>
  800d82:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d86:	7f 07                	jg     800d8f <vsnprintf+0x34>
		return -E_INVAL;
  800d88:	b8 03 00 00 00       	mov    $0x3,%eax
  800d8d:	eb 20                	jmp    800daf <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d8f:	ff 75 14             	pushl  0x14(%ebp)
  800d92:	ff 75 10             	pushl  0x10(%ebp)
  800d95:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d98:	50                   	push   %eax
  800d99:	68 25 0d 80 00       	push   $0x800d25
  800d9e:	e8 92 fb ff ff       	call   800935 <vprintfmt>
  800da3:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800da6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800da9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800daf:	c9                   	leave  
  800db0:	c3                   	ret    

00800db1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800db1:	55                   	push   %ebp
  800db2:	89 e5                	mov    %esp,%ebp
  800db4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800db7:	8d 45 10             	lea    0x10(%ebp),%eax
  800dba:	83 c0 04             	add    $0x4,%eax
  800dbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800dc0:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc3:	ff 75 f4             	pushl  -0xc(%ebp)
  800dc6:	50                   	push   %eax
  800dc7:	ff 75 0c             	pushl  0xc(%ebp)
  800dca:	ff 75 08             	pushl  0x8(%ebp)
  800dcd:	e8 89 ff ff ff       	call   800d5b <vsnprintf>
  800dd2:	83 c4 10             	add    $0x10,%esp
  800dd5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800dd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ddb:	c9                   	leave  
  800ddc:	c3                   	ret    

00800ddd <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
  800de0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800de3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dea:	eb 06                	jmp    800df2 <strlen+0x15>
		n++;
  800dec:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800def:	ff 45 08             	incl   0x8(%ebp)
  800df2:	8b 45 08             	mov    0x8(%ebp),%eax
  800df5:	8a 00                	mov    (%eax),%al
  800df7:	84 c0                	test   %al,%al
  800df9:	75 f1                	jne    800dec <strlen+0xf>
		n++;
	return n;
  800dfb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dfe:	c9                   	leave  
  800dff:	c3                   	ret    

00800e00 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e00:	55                   	push   %ebp
  800e01:	89 e5                	mov    %esp,%ebp
  800e03:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e06:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e0d:	eb 09                	jmp    800e18 <strnlen+0x18>
		n++;
  800e0f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e12:	ff 45 08             	incl   0x8(%ebp)
  800e15:	ff 4d 0c             	decl   0xc(%ebp)
  800e18:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e1c:	74 09                	je     800e27 <strnlen+0x27>
  800e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e21:	8a 00                	mov    (%eax),%al
  800e23:	84 c0                	test   %al,%al
  800e25:	75 e8                	jne    800e0f <strnlen+0xf>
		n++;
	return n;
  800e27:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e2a:	c9                   	leave  
  800e2b:	c3                   	ret    

00800e2c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e2c:	55                   	push   %ebp
  800e2d:	89 e5                	mov    %esp,%ebp
  800e2f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e32:	8b 45 08             	mov    0x8(%ebp),%eax
  800e35:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e38:	90                   	nop
  800e39:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3c:	8d 50 01             	lea    0x1(%eax),%edx
  800e3f:	89 55 08             	mov    %edx,0x8(%ebp)
  800e42:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e45:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e48:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e4b:	8a 12                	mov    (%edx),%dl
  800e4d:	88 10                	mov    %dl,(%eax)
  800e4f:	8a 00                	mov    (%eax),%al
  800e51:	84 c0                	test   %al,%al
  800e53:	75 e4                	jne    800e39 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e55:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e58:	c9                   	leave  
  800e59:	c3                   	ret    

00800e5a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e5a:	55                   	push   %ebp
  800e5b:	89 e5                	mov    %esp,%ebp
  800e5d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e60:	8b 45 08             	mov    0x8(%ebp),%eax
  800e63:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e66:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e6d:	eb 1f                	jmp    800e8e <strncpy+0x34>
		*dst++ = *src;
  800e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e72:	8d 50 01             	lea    0x1(%eax),%edx
  800e75:	89 55 08             	mov    %edx,0x8(%ebp)
  800e78:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e7b:	8a 12                	mov    (%edx),%dl
  800e7d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e82:	8a 00                	mov    (%eax),%al
  800e84:	84 c0                	test   %al,%al
  800e86:	74 03                	je     800e8b <strncpy+0x31>
			src++;
  800e88:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e8b:	ff 45 fc             	incl   -0x4(%ebp)
  800e8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e91:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e94:	72 d9                	jb     800e6f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e96:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e99:	c9                   	leave  
  800e9a:	c3                   	ret    

00800e9b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e9b:	55                   	push   %ebp
  800e9c:	89 e5                	mov    %esp,%ebp
  800e9e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ea7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eab:	74 30                	je     800edd <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ead:	eb 16                	jmp    800ec5 <strlcpy+0x2a>
			*dst++ = *src++;
  800eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb2:	8d 50 01             	lea    0x1(%eax),%edx
  800eb5:	89 55 08             	mov    %edx,0x8(%ebp)
  800eb8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ebb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ebe:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ec1:	8a 12                	mov    (%edx),%dl
  800ec3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ec5:	ff 4d 10             	decl   0x10(%ebp)
  800ec8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ecc:	74 09                	je     800ed7 <strlcpy+0x3c>
  800ece:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed1:	8a 00                	mov    (%eax),%al
  800ed3:	84 c0                	test   %al,%al
  800ed5:	75 d8                	jne    800eaf <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eda:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800edd:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee3:	29 c2                	sub    %eax,%edx
  800ee5:	89 d0                	mov    %edx,%eax
}
  800ee7:	c9                   	leave  
  800ee8:	c3                   	ret    

00800ee9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ee9:	55                   	push   %ebp
  800eea:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800eec:	eb 06                	jmp    800ef4 <strcmp+0xb>
		p++, q++;
  800eee:	ff 45 08             	incl   0x8(%ebp)
  800ef1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef7:	8a 00                	mov    (%eax),%al
  800ef9:	84 c0                	test   %al,%al
  800efb:	74 0e                	je     800f0b <strcmp+0x22>
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
  800f00:	8a 10                	mov    (%eax),%dl
  800f02:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f05:	8a 00                	mov    (%eax),%al
  800f07:	38 c2                	cmp    %al,%dl
  800f09:	74 e3                	je     800eee <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0e:	8a 00                	mov    (%eax),%al
  800f10:	0f b6 d0             	movzbl %al,%edx
  800f13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f16:	8a 00                	mov    (%eax),%al
  800f18:	0f b6 c0             	movzbl %al,%eax
  800f1b:	29 c2                	sub    %eax,%edx
  800f1d:	89 d0                	mov    %edx,%eax
}
  800f1f:	5d                   	pop    %ebp
  800f20:	c3                   	ret    

00800f21 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f21:	55                   	push   %ebp
  800f22:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f24:	eb 09                	jmp    800f2f <strncmp+0xe>
		n--, p++, q++;
  800f26:	ff 4d 10             	decl   0x10(%ebp)
  800f29:	ff 45 08             	incl   0x8(%ebp)
  800f2c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f2f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f33:	74 17                	je     800f4c <strncmp+0x2b>
  800f35:	8b 45 08             	mov    0x8(%ebp),%eax
  800f38:	8a 00                	mov    (%eax),%al
  800f3a:	84 c0                	test   %al,%al
  800f3c:	74 0e                	je     800f4c <strncmp+0x2b>
  800f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f41:	8a 10                	mov    (%eax),%dl
  800f43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f46:	8a 00                	mov    (%eax),%al
  800f48:	38 c2                	cmp    %al,%dl
  800f4a:	74 da                	je     800f26 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f4c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f50:	75 07                	jne    800f59 <strncmp+0x38>
		return 0;
  800f52:	b8 00 00 00 00       	mov    $0x0,%eax
  800f57:	eb 14                	jmp    800f6d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f59:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5c:	8a 00                	mov    (%eax),%al
  800f5e:	0f b6 d0             	movzbl %al,%edx
  800f61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f64:	8a 00                	mov    (%eax),%al
  800f66:	0f b6 c0             	movzbl %al,%eax
  800f69:	29 c2                	sub    %eax,%edx
  800f6b:	89 d0                	mov    %edx,%eax
}
  800f6d:	5d                   	pop    %ebp
  800f6e:	c3                   	ret    

00800f6f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f6f:	55                   	push   %ebp
  800f70:	89 e5                	mov    %esp,%ebp
  800f72:	83 ec 04             	sub    $0x4,%esp
  800f75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f78:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f7b:	eb 12                	jmp    800f8f <strchr+0x20>
		if (*s == c)
  800f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f80:	8a 00                	mov    (%eax),%al
  800f82:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f85:	75 05                	jne    800f8c <strchr+0x1d>
			return (char *) s;
  800f87:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8a:	eb 11                	jmp    800f9d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f8c:	ff 45 08             	incl   0x8(%ebp)
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	8a 00                	mov    (%eax),%al
  800f94:	84 c0                	test   %al,%al
  800f96:	75 e5                	jne    800f7d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f98:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f9d:	c9                   	leave  
  800f9e:	c3                   	ret    

00800f9f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f9f:	55                   	push   %ebp
  800fa0:	89 e5                	mov    %esp,%ebp
  800fa2:	83 ec 04             	sub    $0x4,%esp
  800fa5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fab:	eb 0d                	jmp    800fba <strfind+0x1b>
		if (*s == c)
  800fad:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb0:	8a 00                	mov    (%eax),%al
  800fb2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fb5:	74 0e                	je     800fc5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fb7:	ff 45 08             	incl   0x8(%ebp)
  800fba:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbd:	8a 00                	mov    (%eax),%al
  800fbf:	84 c0                	test   %al,%al
  800fc1:	75 ea                	jne    800fad <strfind+0xe>
  800fc3:	eb 01                	jmp    800fc6 <strfind+0x27>
		if (*s == c)
			break;
  800fc5:	90                   	nop
	return (char *) s;
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fc9:	c9                   	leave  
  800fca:	c3                   	ret    

00800fcb <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800fcb:	55                   	push   %ebp
  800fcc:	89 e5                	mov    %esp,%ebp
  800fce:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800fd7:	8b 45 10             	mov    0x10(%ebp),%eax
  800fda:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800fdd:	eb 0e                	jmp    800fed <memset+0x22>
		*p++ = c;
  800fdf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe2:	8d 50 01             	lea    0x1(%eax),%edx
  800fe5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fe8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800feb:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800fed:	ff 4d f8             	decl   -0x8(%ebp)
  800ff0:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800ff4:	79 e9                	jns    800fdf <memset+0x14>
		*p++ = c;

	return v;
  800ff6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ff9:	c9                   	leave  
  800ffa:	c3                   	ret    

00800ffb <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ffb:	55                   	push   %ebp
  800ffc:	89 e5                	mov    %esp,%ebp
  800ffe:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801001:	8b 45 0c             	mov    0xc(%ebp),%eax
  801004:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801007:	8b 45 08             	mov    0x8(%ebp),%eax
  80100a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80100d:	eb 16                	jmp    801025 <memcpy+0x2a>
		*d++ = *s++;
  80100f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801012:	8d 50 01             	lea    0x1(%eax),%edx
  801015:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801018:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80101b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80101e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801021:	8a 12                	mov    (%edx),%dl
  801023:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801025:	8b 45 10             	mov    0x10(%ebp),%eax
  801028:	8d 50 ff             	lea    -0x1(%eax),%edx
  80102b:	89 55 10             	mov    %edx,0x10(%ebp)
  80102e:	85 c0                	test   %eax,%eax
  801030:	75 dd                	jne    80100f <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801032:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801035:	c9                   	leave  
  801036:	c3                   	ret    

00801037 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801037:	55                   	push   %ebp
  801038:	89 e5                	mov    %esp,%ebp
  80103a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80103d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801040:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801043:	8b 45 08             	mov    0x8(%ebp),%eax
  801046:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801049:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80104c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80104f:	73 50                	jae    8010a1 <memmove+0x6a>
  801051:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801054:	8b 45 10             	mov    0x10(%ebp),%eax
  801057:	01 d0                	add    %edx,%eax
  801059:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80105c:	76 43                	jbe    8010a1 <memmove+0x6a>
		s += n;
  80105e:	8b 45 10             	mov    0x10(%ebp),%eax
  801061:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801064:	8b 45 10             	mov    0x10(%ebp),%eax
  801067:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80106a:	eb 10                	jmp    80107c <memmove+0x45>
			*--d = *--s;
  80106c:	ff 4d f8             	decl   -0x8(%ebp)
  80106f:	ff 4d fc             	decl   -0x4(%ebp)
  801072:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801075:	8a 10                	mov    (%eax),%dl
  801077:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80107a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80107c:	8b 45 10             	mov    0x10(%ebp),%eax
  80107f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801082:	89 55 10             	mov    %edx,0x10(%ebp)
  801085:	85 c0                	test   %eax,%eax
  801087:	75 e3                	jne    80106c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801089:	eb 23                	jmp    8010ae <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80108b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80108e:	8d 50 01             	lea    0x1(%eax),%edx
  801091:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801094:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801097:	8d 4a 01             	lea    0x1(%edx),%ecx
  80109a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80109d:	8a 12                	mov    (%edx),%dl
  80109f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010a7:	89 55 10             	mov    %edx,0x10(%ebp)
  8010aa:	85 c0                	test   %eax,%eax
  8010ac:	75 dd                	jne    80108b <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010ae:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010b1:	c9                   	leave  
  8010b2:	c3                   	ret    

008010b3 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010b3:	55                   	push   %ebp
  8010b4:	89 e5                	mov    %esp,%ebp
  8010b6:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010c5:	eb 2a                	jmp    8010f1 <memcmp+0x3e>
		if (*s1 != *s2)
  8010c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ca:	8a 10                	mov    (%eax),%dl
  8010cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010cf:	8a 00                	mov    (%eax),%al
  8010d1:	38 c2                	cmp    %al,%dl
  8010d3:	74 16                	je     8010eb <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d8:	8a 00                	mov    (%eax),%al
  8010da:	0f b6 d0             	movzbl %al,%edx
  8010dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e0:	8a 00                	mov    (%eax),%al
  8010e2:	0f b6 c0             	movzbl %al,%eax
  8010e5:	29 c2                	sub    %eax,%edx
  8010e7:	89 d0                	mov    %edx,%eax
  8010e9:	eb 18                	jmp    801103 <memcmp+0x50>
		s1++, s2++;
  8010eb:	ff 45 fc             	incl   -0x4(%ebp)
  8010ee:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8010f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010f7:	89 55 10             	mov    %edx,0x10(%ebp)
  8010fa:	85 c0                	test   %eax,%eax
  8010fc:	75 c9                	jne    8010c7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8010fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801103:	c9                   	leave  
  801104:	c3                   	ret    

00801105 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801105:	55                   	push   %ebp
  801106:	89 e5                	mov    %esp,%ebp
  801108:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80110b:	8b 55 08             	mov    0x8(%ebp),%edx
  80110e:	8b 45 10             	mov    0x10(%ebp),%eax
  801111:	01 d0                	add    %edx,%eax
  801113:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801116:	eb 15                	jmp    80112d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801118:	8b 45 08             	mov    0x8(%ebp),%eax
  80111b:	8a 00                	mov    (%eax),%al
  80111d:	0f b6 d0             	movzbl %al,%edx
  801120:	8b 45 0c             	mov    0xc(%ebp),%eax
  801123:	0f b6 c0             	movzbl %al,%eax
  801126:	39 c2                	cmp    %eax,%edx
  801128:	74 0d                	je     801137 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80112a:	ff 45 08             	incl   0x8(%ebp)
  80112d:	8b 45 08             	mov    0x8(%ebp),%eax
  801130:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801133:	72 e3                	jb     801118 <memfind+0x13>
  801135:	eb 01                	jmp    801138 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801137:	90                   	nop
	return (void *) s;
  801138:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80113b:	c9                   	leave  
  80113c:	c3                   	ret    

0080113d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80113d:	55                   	push   %ebp
  80113e:	89 e5                	mov    %esp,%ebp
  801140:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801143:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80114a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801151:	eb 03                	jmp    801156 <strtol+0x19>
		s++;
  801153:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801156:	8b 45 08             	mov    0x8(%ebp),%eax
  801159:	8a 00                	mov    (%eax),%al
  80115b:	3c 20                	cmp    $0x20,%al
  80115d:	74 f4                	je     801153 <strtol+0x16>
  80115f:	8b 45 08             	mov    0x8(%ebp),%eax
  801162:	8a 00                	mov    (%eax),%al
  801164:	3c 09                	cmp    $0x9,%al
  801166:	74 eb                	je     801153 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801168:	8b 45 08             	mov    0x8(%ebp),%eax
  80116b:	8a 00                	mov    (%eax),%al
  80116d:	3c 2b                	cmp    $0x2b,%al
  80116f:	75 05                	jne    801176 <strtol+0x39>
		s++;
  801171:	ff 45 08             	incl   0x8(%ebp)
  801174:	eb 13                	jmp    801189 <strtol+0x4c>
	else if (*s == '-')
  801176:	8b 45 08             	mov    0x8(%ebp),%eax
  801179:	8a 00                	mov    (%eax),%al
  80117b:	3c 2d                	cmp    $0x2d,%al
  80117d:	75 0a                	jne    801189 <strtol+0x4c>
		s++, neg = 1;
  80117f:	ff 45 08             	incl   0x8(%ebp)
  801182:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801189:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80118d:	74 06                	je     801195 <strtol+0x58>
  80118f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801193:	75 20                	jne    8011b5 <strtol+0x78>
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
  801198:	8a 00                	mov    (%eax),%al
  80119a:	3c 30                	cmp    $0x30,%al
  80119c:	75 17                	jne    8011b5 <strtol+0x78>
  80119e:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a1:	40                   	inc    %eax
  8011a2:	8a 00                	mov    (%eax),%al
  8011a4:	3c 78                	cmp    $0x78,%al
  8011a6:	75 0d                	jne    8011b5 <strtol+0x78>
		s += 2, base = 16;
  8011a8:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011ac:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011b3:	eb 28                	jmp    8011dd <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011b5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011b9:	75 15                	jne    8011d0 <strtol+0x93>
  8011bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011be:	8a 00                	mov    (%eax),%al
  8011c0:	3c 30                	cmp    $0x30,%al
  8011c2:	75 0c                	jne    8011d0 <strtol+0x93>
		s++, base = 8;
  8011c4:	ff 45 08             	incl   0x8(%ebp)
  8011c7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011ce:	eb 0d                	jmp    8011dd <strtol+0xa0>
	else if (base == 0)
  8011d0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011d4:	75 07                	jne    8011dd <strtol+0xa0>
		base = 10;
  8011d6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e0:	8a 00                	mov    (%eax),%al
  8011e2:	3c 2f                	cmp    $0x2f,%al
  8011e4:	7e 19                	jle    8011ff <strtol+0xc2>
  8011e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e9:	8a 00                	mov    (%eax),%al
  8011eb:	3c 39                	cmp    $0x39,%al
  8011ed:	7f 10                	jg     8011ff <strtol+0xc2>
			dig = *s - '0';
  8011ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f2:	8a 00                	mov    (%eax),%al
  8011f4:	0f be c0             	movsbl %al,%eax
  8011f7:	83 e8 30             	sub    $0x30,%eax
  8011fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011fd:	eb 42                	jmp    801241 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8011ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801202:	8a 00                	mov    (%eax),%al
  801204:	3c 60                	cmp    $0x60,%al
  801206:	7e 19                	jle    801221 <strtol+0xe4>
  801208:	8b 45 08             	mov    0x8(%ebp),%eax
  80120b:	8a 00                	mov    (%eax),%al
  80120d:	3c 7a                	cmp    $0x7a,%al
  80120f:	7f 10                	jg     801221 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801211:	8b 45 08             	mov    0x8(%ebp),%eax
  801214:	8a 00                	mov    (%eax),%al
  801216:	0f be c0             	movsbl %al,%eax
  801219:	83 e8 57             	sub    $0x57,%eax
  80121c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80121f:	eb 20                	jmp    801241 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801221:	8b 45 08             	mov    0x8(%ebp),%eax
  801224:	8a 00                	mov    (%eax),%al
  801226:	3c 40                	cmp    $0x40,%al
  801228:	7e 39                	jle    801263 <strtol+0x126>
  80122a:	8b 45 08             	mov    0x8(%ebp),%eax
  80122d:	8a 00                	mov    (%eax),%al
  80122f:	3c 5a                	cmp    $0x5a,%al
  801231:	7f 30                	jg     801263 <strtol+0x126>
			dig = *s - 'A' + 10;
  801233:	8b 45 08             	mov    0x8(%ebp),%eax
  801236:	8a 00                	mov    (%eax),%al
  801238:	0f be c0             	movsbl %al,%eax
  80123b:	83 e8 37             	sub    $0x37,%eax
  80123e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801241:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801244:	3b 45 10             	cmp    0x10(%ebp),%eax
  801247:	7d 19                	jge    801262 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801249:	ff 45 08             	incl   0x8(%ebp)
  80124c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80124f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801253:	89 c2                	mov    %eax,%edx
  801255:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801258:	01 d0                	add    %edx,%eax
  80125a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80125d:	e9 7b ff ff ff       	jmp    8011dd <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801262:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801263:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801267:	74 08                	je     801271 <strtol+0x134>
		*endptr = (char *) s;
  801269:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126c:	8b 55 08             	mov    0x8(%ebp),%edx
  80126f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801271:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801275:	74 07                	je     80127e <strtol+0x141>
  801277:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80127a:	f7 d8                	neg    %eax
  80127c:	eb 03                	jmp    801281 <strtol+0x144>
  80127e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801281:	c9                   	leave  
  801282:	c3                   	ret    

00801283 <ltostr>:

void
ltostr(long value, char *str)
{
  801283:	55                   	push   %ebp
  801284:	89 e5                	mov    %esp,%ebp
  801286:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801289:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801290:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801297:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80129b:	79 13                	jns    8012b0 <ltostr+0x2d>
	{
		neg = 1;
  80129d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a7:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012aa:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012ad:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b3:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012b8:	99                   	cltd   
  8012b9:	f7 f9                	idiv   %ecx
  8012bb:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c1:	8d 50 01             	lea    0x1(%eax),%edx
  8012c4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012c7:	89 c2                	mov    %eax,%edx
  8012c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012cc:	01 d0                	add    %edx,%eax
  8012ce:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012d1:	83 c2 30             	add    $0x30,%edx
  8012d4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012d9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012de:	f7 e9                	imul   %ecx
  8012e0:	c1 fa 02             	sar    $0x2,%edx
  8012e3:	89 c8                	mov    %ecx,%eax
  8012e5:	c1 f8 1f             	sar    $0x1f,%eax
  8012e8:	29 c2                	sub    %eax,%edx
  8012ea:	89 d0                	mov    %edx,%eax
  8012ec:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8012ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012f2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012f7:	f7 e9                	imul   %ecx
  8012f9:	c1 fa 02             	sar    $0x2,%edx
  8012fc:	89 c8                	mov    %ecx,%eax
  8012fe:	c1 f8 1f             	sar    $0x1f,%eax
  801301:	29 c2                	sub    %eax,%edx
  801303:	89 d0                	mov    %edx,%eax
  801305:	c1 e0 02             	shl    $0x2,%eax
  801308:	01 d0                	add    %edx,%eax
  80130a:	01 c0                	add    %eax,%eax
  80130c:	29 c1                	sub    %eax,%ecx
  80130e:	89 ca                	mov    %ecx,%edx
  801310:	85 d2                	test   %edx,%edx
  801312:	75 9c                	jne    8012b0 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801314:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80131b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80131e:	48                   	dec    %eax
  80131f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801322:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801326:	74 3d                	je     801365 <ltostr+0xe2>
		start = 1 ;
  801328:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80132f:	eb 34                	jmp    801365 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801331:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801334:	8b 45 0c             	mov    0xc(%ebp),%eax
  801337:	01 d0                	add    %edx,%eax
  801339:	8a 00                	mov    (%eax),%al
  80133b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80133e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801341:	8b 45 0c             	mov    0xc(%ebp),%eax
  801344:	01 c2                	add    %eax,%edx
  801346:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801349:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134c:	01 c8                	add    %ecx,%eax
  80134e:	8a 00                	mov    (%eax),%al
  801350:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801352:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801355:	8b 45 0c             	mov    0xc(%ebp),%eax
  801358:	01 c2                	add    %eax,%edx
  80135a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80135d:	88 02                	mov    %al,(%edx)
		start++ ;
  80135f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801362:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801365:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801368:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80136b:	7c c4                	jl     801331 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80136d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801370:	8b 45 0c             	mov    0xc(%ebp),%eax
  801373:	01 d0                	add    %edx,%eax
  801375:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801378:	90                   	nop
  801379:	c9                   	leave  
  80137a:	c3                   	ret    

0080137b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80137b:	55                   	push   %ebp
  80137c:	89 e5                	mov    %esp,%ebp
  80137e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801381:	ff 75 08             	pushl  0x8(%ebp)
  801384:	e8 54 fa ff ff       	call   800ddd <strlen>
  801389:	83 c4 04             	add    $0x4,%esp
  80138c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80138f:	ff 75 0c             	pushl  0xc(%ebp)
  801392:	e8 46 fa ff ff       	call   800ddd <strlen>
  801397:	83 c4 04             	add    $0x4,%esp
  80139a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80139d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013ab:	eb 17                	jmp    8013c4 <strcconcat+0x49>
		final[s] = str1[s] ;
  8013ad:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b3:	01 c2                	add    %eax,%edx
  8013b5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bb:	01 c8                	add    %ecx,%eax
  8013bd:	8a 00                	mov    (%eax),%al
  8013bf:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013c1:	ff 45 fc             	incl   -0x4(%ebp)
  8013c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013c7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013ca:	7c e1                	jl     8013ad <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013cc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013d3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013da:	eb 1f                	jmp    8013fb <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013df:	8d 50 01             	lea    0x1(%eax),%edx
  8013e2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013e5:	89 c2                	mov    %eax,%edx
  8013e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ea:	01 c2                	add    %eax,%edx
  8013ec:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8013ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f2:	01 c8                	add    %ecx,%eax
  8013f4:	8a 00                	mov    (%eax),%al
  8013f6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8013f8:	ff 45 f8             	incl   -0x8(%ebp)
  8013fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013fe:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801401:	7c d9                	jl     8013dc <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801403:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801406:	8b 45 10             	mov    0x10(%ebp),%eax
  801409:	01 d0                	add    %edx,%eax
  80140b:	c6 00 00             	movb   $0x0,(%eax)
}
  80140e:	90                   	nop
  80140f:	c9                   	leave  
  801410:	c3                   	ret    

00801411 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801411:	55                   	push   %ebp
  801412:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801414:	8b 45 14             	mov    0x14(%ebp),%eax
  801417:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80141d:	8b 45 14             	mov    0x14(%ebp),%eax
  801420:	8b 00                	mov    (%eax),%eax
  801422:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801429:	8b 45 10             	mov    0x10(%ebp),%eax
  80142c:	01 d0                	add    %edx,%eax
  80142e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801434:	eb 0c                	jmp    801442 <strsplit+0x31>
			*string++ = 0;
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	8d 50 01             	lea    0x1(%eax),%edx
  80143c:	89 55 08             	mov    %edx,0x8(%ebp)
  80143f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801442:	8b 45 08             	mov    0x8(%ebp),%eax
  801445:	8a 00                	mov    (%eax),%al
  801447:	84 c0                	test   %al,%al
  801449:	74 18                	je     801463 <strsplit+0x52>
  80144b:	8b 45 08             	mov    0x8(%ebp),%eax
  80144e:	8a 00                	mov    (%eax),%al
  801450:	0f be c0             	movsbl %al,%eax
  801453:	50                   	push   %eax
  801454:	ff 75 0c             	pushl  0xc(%ebp)
  801457:	e8 13 fb ff ff       	call   800f6f <strchr>
  80145c:	83 c4 08             	add    $0x8,%esp
  80145f:	85 c0                	test   %eax,%eax
  801461:	75 d3                	jne    801436 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801463:	8b 45 08             	mov    0x8(%ebp),%eax
  801466:	8a 00                	mov    (%eax),%al
  801468:	84 c0                	test   %al,%al
  80146a:	74 5a                	je     8014c6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80146c:	8b 45 14             	mov    0x14(%ebp),%eax
  80146f:	8b 00                	mov    (%eax),%eax
  801471:	83 f8 0f             	cmp    $0xf,%eax
  801474:	75 07                	jne    80147d <strsplit+0x6c>
		{
			return 0;
  801476:	b8 00 00 00 00       	mov    $0x0,%eax
  80147b:	eb 66                	jmp    8014e3 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80147d:	8b 45 14             	mov    0x14(%ebp),%eax
  801480:	8b 00                	mov    (%eax),%eax
  801482:	8d 48 01             	lea    0x1(%eax),%ecx
  801485:	8b 55 14             	mov    0x14(%ebp),%edx
  801488:	89 0a                	mov    %ecx,(%edx)
  80148a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801491:	8b 45 10             	mov    0x10(%ebp),%eax
  801494:	01 c2                	add    %eax,%edx
  801496:	8b 45 08             	mov    0x8(%ebp),%eax
  801499:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80149b:	eb 03                	jmp    8014a0 <strsplit+0x8f>
			string++;
  80149d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a3:	8a 00                	mov    (%eax),%al
  8014a5:	84 c0                	test   %al,%al
  8014a7:	74 8b                	je     801434 <strsplit+0x23>
  8014a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ac:	8a 00                	mov    (%eax),%al
  8014ae:	0f be c0             	movsbl %al,%eax
  8014b1:	50                   	push   %eax
  8014b2:	ff 75 0c             	pushl  0xc(%ebp)
  8014b5:	e8 b5 fa ff ff       	call   800f6f <strchr>
  8014ba:	83 c4 08             	add    $0x8,%esp
  8014bd:	85 c0                	test   %eax,%eax
  8014bf:	74 dc                	je     80149d <strsplit+0x8c>
			string++;
	}
  8014c1:	e9 6e ff ff ff       	jmp    801434 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014c6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ca:	8b 00                	mov    (%eax),%eax
  8014cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d6:	01 d0                	add    %edx,%eax
  8014d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014de:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014e3:	c9                   	leave  
  8014e4:	c3                   	ret    

008014e5 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8014e5:	55                   	push   %ebp
  8014e6:	89 e5                	mov    %esp,%ebp
  8014e8:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8014eb:	a1 04 40 80 00       	mov    0x804004,%eax
  8014f0:	85 c0                	test   %eax,%eax
  8014f2:	74 1f                	je     801513 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8014f4:	e8 1d 00 00 00       	call   801516 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8014f9:	83 ec 0c             	sub    $0xc,%esp
  8014fc:	68 50 3d 80 00       	push   $0x803d50
  801501:	e8 55 f2 ff ff       	call   80075b <cprintf>
  801506:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801509:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801510:	00 00 00 
	}
}
  801513:	90                   	nop
  801514:	c9                   	leave  
  801515:	c3                   	ret    

00801516 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801516:	55                   	push   %ebp
  801517:	89 e5                	mov    %esp,%ebp
  801519:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  80151c:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801523:	00 00 00 
  801526:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80152d:	00 00 00 
  801530:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801537:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  80153a:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801541:	00 00 00 
  801544:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80154b:	00 00 00 
  80154e:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801555:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801558:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  80155f:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801562:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801569:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80156c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801571:	2d 00 10 00 00       	sub    $0x1000,%eax
  801576:	a3 50 40 80 00       	mov    %eax,0x804050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  80157b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801582:	a1 20 41 80 00       	mov    0x804120,%eax
  801587:	c1 e0 04             	shl    $0x4,%eax
  80158a:	89 c2                	mov    %eax,%edx
  80158c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80158f:	01 d0                	add    %edx,%eax
  801591:	48                   	dec    %eax
  801592:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801595:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801598:	ba 00 00 00 00       	mov    $0x0,%edx
  80159d:	f7 75 f0             	divl   -0x10(%ebp)
  8015a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015a3:	29 d0                	sub    %edx,%eax
  8015a5:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  8015a8:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8015af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015b2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015b7:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015bc:	83 ec 04             	sub    $0x4,%esp
  8015bf:	6a 06                	push   $0x6
  8015c1:	ff 75 e8             	pushl  -0x18(%ebp)
  8015c4:	50                   	push   %eax
  8015c5:	e8 b0 05 00 00       	call   801b7a <sys_allocate_chunk>
  8015ca:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8015cd:	a1 20 41 80 00       	mov    0x804120,%eax
  8015d2:	83 ec 0c             	sub    $0xc,%esp
  8015d5:	50                   	push   %eax
  8015d6:	e8 25 0c 00 00       	call   802200 <initialize_MemBlocksList>
  8015db:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  8015de:	a1 48 41 80 00       	mov    0x804148,%eax
  8015e3:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  8015e6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8015ea:	75 14                	jne    801600 <initialize_dyn_block_system+0xea>
  8015ec:	83 ec 04             	sub    $0x4,%esp
  8015ef:	68 75 3d 80 00       	push   $0x803d75
  8015f4:	6a 29                	push   $0x29
  8015f6:	68 93 3d 80 00       	push   $0x803d93
  8015fb:	e8 a7 ee ff ff       	call   8004a7 <_panic>
  801600:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801603:	8b 00                	mov    (%eax),%eax
  801605:	85 c0                	test   %eax,%eax
  801607:	74 10                	je     801619 <initialize_dyn_block_system+0x103>
  801609:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80160c:	8b 00                	mov    (%eax),%eax
  80160e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801611:	8b 52 04             	mov    0x4(%edx),%edx
  801614:	89 50 04             	mov    %edx,0x4(%eax)
  801617:	eb 0b                	jmp    801624 <initialize_dyn_block_system+0x10e>
  801619:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80161c:	8b 40 04             	mov    0x4(%eax),%eax
  80161f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801624:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801627:	8b 40 04             	mov    0x4(%eax),%eax
  80162a:	85 c0                	test   %eax,%eax
  80162c:	74 0f                	je     80163d <initialize_dyn_block_system+0x127>
  80162e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801631:	8b 40 04             	mov    0x4(%eax),%eax
  801634:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801637:	8b 12                	mov    (%edx),%edx
  801639:	89 10                	mov    %edx,(%eax)
  80163b:	eb 0a                	jmp    801647 <initialize_dyn_block_system+0x131>
  80163d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801640:	8b 00                	mov    (%eax),%eax
  801642:	a3 48 41 80 00       	mov    %eax,0x804148
  801647:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80164a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801650:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801653:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80165a:	a1 54 41 80 00       	mov    0x804154,%eax
  80165f:	48                   	dec    %eax
  801660:	a3 54 41 80 00       	mov    %eax,0x804154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  801665:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801668:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  80166f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801672:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  801679:	83 ec 0c             	sub    $0xc,%esp
  80167c:	ff 75 e0             	pushl  -0x20(%ebp)
  80167f:	e8 b9 14 00 00       	call   802b3d <insert_sorted_with_merge_freeList>
  801684:	83 c4 10             	add    $0x10,%esp

}
  801687:	90                   	nop
  801688:	c9                   	leave  
  801689:	c3                   	ret    

0080168a <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80168a:	55                   	push   %ebp
  80168b:	89 e5                	mov    %esp,%ebp
  80168d:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801690:	e8 50 fe ff ff       	call   8014e5 <InitializeUHeap>
	if (size == 0) return NULL ;
  801695:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801699:	75 07                	jne    8016a2 <malloc+0x18>
  80169b:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a0:	eb 68                	jmp    80170a <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  8016a2:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8016a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8016ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016af:	01 d0                	add    %edx,%eax
  8016b1:	48                   	dec    %eax
  8016b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8016bd:	f7 75 f4             	divl   -0xc(%ebp)
  8016c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016c3:	29 d0                	sub    %edx,%eax
  8016c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  8016c8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8016cf:	e8 74 08 00 00       	call   801f48 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016d4:	85 c0                	test   %eax,%eax
  8016d6:	74 2d                	je     801705 <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  8016d8:	83 ec 0c             	sub    $0xc,%esp
  8016db:	ff 75 ec             	pushl  -0x14(%ebp)
  8016de:	e8 52 0e 00 00       	call   802535 <alloc_block_FF>
  8016e3:	83 c4 10             	add    $0x10,%esp
  8016e6:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  8016e9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8016ed:	74 16                	je     801705 <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  8016ef:	83 ec 0c             	sub    $0xc,%esp
  8016f2:	ff 75 e8             	pushl  -0x18(%ebp)
  8016f5:	e8 3b 0c 00 00       	call   802335 <insert_sorted_allocList>
  8016fa:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  8016fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801700:	8b 40 08             	mov    0x8(%eax),%eax
  801703:	eb 05                	jmp    80170a <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  801705:	b8 00 00 00 00       	mov    $0x0,%eax

}
  80170a:	c9                   	leave  
  80170b:	c3                   	ret    

0080170c <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80170c:	55                   	push   %ebp
  80170d:	89 e5                	mov    %esp,%ebp
  80170f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  801712:	8b 45 08             	mov    0x8(%ebp),%eax
  801715:	83 ec 08             	sub    $0x8,%esp
  801718:	50                   	push   %eax
  801719:	68 40 40 80 00       	push   $0x804040
  80171e:	e8 ba 0b 00 00       	call   8022dd <find_block>
  801723:	83 c4 10             	add    $0x10,%esp
  801726:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  801729:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80172c:	8b 40 0c             	mov    0xc(%eax),%eax
  80172f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  801732:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801736:	0f 84 9f 00 00 00    	je     8017db <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  80173c:	8b 45 08             	mov    0x8(%ebp),%eax
  80173f:	83 ec 08             	sub    $0x8,%esp
  801742:	ff 75 f0             	pushl  -0x10(%ebp)
  801745:	50                   	push   %eax
  801746:	e8 f7 03 00 00       	call   801b42 <sys_free_user_mem>
  80174b:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  80174e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801752:	75 14                	jne    801768 <free+0x5c>
  801754:	83 ec 04             	sub    $0x4,%esp
  801757:	68 75 3d 80 00       	push   $0x803d75
  80175c:	6a 6a                	push   $0x6a
  80175e:	68 93 3d 80 00       	push   $0x803d93
  801763:	e8 3f ed ff ff       	call   8004a7 <_panic>
  801768:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80176b:	8b 00                	mov    (%eax),%eax
  80176d:	85 c0                	test   %eax,%eax
  80176f:	74 10                	je     801781 <free+0x75>
  801771:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801774:	8b 00                	mov    (%eax),%eax
  801776:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801779:	8b 52 04             	mov    0x4(%edx),%edx
  80177c:	89 50 04             	mov    %edx,0x4(%eax)
  80177f:	eb 0b                	jmp    80178c <free+0x80>
  801781:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801784:	8b 40 04             	mov    0x4(%eax),%eax
  801787:	a3 44 40 80 00       	mov    %eax,0x804044
  80178c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80178f:	8b 40 04             	mov    0x4(%eax),%eax
  801792:	85 c0                	test   %eax,%eax
  801794:	74 0f                	je     8017a5 <free+0x99>
  801796:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801799:	8b 40 04             	mov    0x4(%eax),%eax
  80179c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80179f:	8b 12                	mov    (%edx),%edx
  8017a1:	89 10                	mov    %edx,(%eax)
  8017a3:	eb 0a                	jmp    8017af <free+0xa3>
  8017a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017a8:	8b 00                	mov    (%eax),%eax
  8017aa:	a3 40 40 80 00       	mov    %eax,0x804040
  8017af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8017b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017bb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8017c2:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8017c7:	48                   	dec    %eax
  8017c8:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(blk);
  8017cd:	83 ec 0c             	sub    $0xc,%esp
  8017d0:	ff 75 f4             	pushl  -0xc(%ebp)
  8017d3:	e8 65 13 00 00       	call   802b3d <insert_sorted_with_merge_freeList>
  8017d8:	83 c4 10             	add    $0x10,%esp
	}
}
  8017db:	90                   	nop
  8017dc:	c9                   	leave  
  8017dd:	c3                   	ret    

008017de <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8017de:	55                   	push   %ebp
  8017df:	89 e5                	mov    %esp,%ebp
  8017e1:	83 ec 28             	sub    $0x28,%esp
  8017e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8017e7:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017ea:	e8 f6 fc ff ff       	call   8014e5 <InitializeUHeap>
	if (size == 0) return NULL ;
  8017ef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8017f3:	75 0a                	jne    8017ff <smalloc+0x21>
  8017f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8017fa:	e9 af 00 00 00       	jmp    8018ae <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  8017ff:	e8 44 07 00 00       	call   801f48 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801804:	83 f8 01             	cmp    $0x1,%eax
  801807:	0f 85 9c 00 00 00    	jne    8018a9 <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  80180d:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801814:	8b 55 0c             	mov    0xc(%ebp),%edx
  801817:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80181a:	01 d0                	add    %edx,%eax
  80181c:	48                   	dec    %eax
  80181d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801820:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801823:	ba 00 00 00 00       	mov    $0x0,%edx
  801828:	f7 75 f4             	divl   -0xc(%ebp)
  80182b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80182e:	29 d0                	sub    %edx,%eax
  801830:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  801833:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  80183a:	76 07                	jbe    801843 <smalloc+0x65>
			return NULL;
  80183c:	b8 00 00 00 00       	mov    $0x0,%eax
  801841:	eb 6b                	jmp    8018ae <smalloc+0xd0>
		blk =alloc_block_FF(size);
  801843:	83 ec 0c             	sub    $0xc,%esp
  801846:	ff 75 0c             	pushl  0xc(%ebp)
  801849:	e8 e7 0c 00 00       	call   802535 <alloc_block_FF>
  80184e:	83 c4 10             	add    $0x10,%esp
  801851:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  801854:	83 ec 0c             	sub    $0xc,%esp
  801857:	ff 75 ec             	pushl  -0x14(%ebp)
  80185a:	e8 d6 0a 00 00       	call   802335 <insert_sorted_allocList>
  80185f:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  801862:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801866:	75 07                	jne    80186f <smalloc+0x91>
		{
			return NULL;
  801868:	b8 00 00 00 00       	mov    $0x0,%eax
  80186d:	eb 3f                	jmp    8018ae <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  80186f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801872:	8b 40 08             	mov    0x8(%eax),%eax
  801875:	89 c2                	mov    %eax,%edx
  801877:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80187b:	52                   	push   %edx
  80187c:	50                   	push   %eax
  80187d:	ff 75 0c             	pushl  0xc(%ebp)
  801880:	ff 75 08             	pushl  0x8(%ebp)
  801883:	e8 45 04 00 00       	call   801ccd <sys_createSharedObject>
  801888:	83 c4 10             	add    $0x10,%esp
  80188b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  80188e:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801892:	74 06                	je     80189a <smalloc+0xbc>
  801894:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801898:	75 07                	jne    8018a1 <smalloc+0xc3>
		{
			return NULL;
  80189a:	b8 00 00 00 00       	mov    $0x0,%eax
  80189f:	eb 0d                	jmp    8018ae <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  8018a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018a4:	8b 40 08             	mov    0x8(%eax),%eax
  8018a7:	eb 05                	jmp    8018ae <smalloc+0xd0>
		}
	}
	else
		return NULL;
  8018a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018ae:	c9                   	leave  
  8018af:	c3                   	ret    

008018b0 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8018b0:	55                   	push   %ebp
  8018b1:	89 e5                	mov    %esp,%ebp
  8018b3:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018b6:	e8 2a fc ff ff       	call   8014e5 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8018bb:	83 ec 08             	sub    $0x8,%esp
  8018be:	ff 75 0c             	pushl  0xc(%ebp)
  8018c1:	ff 75 08             	pushl  0x8(%ebp)
  8018c4:	e8 2e 04 00 00       	call   801cf7 <sys_getSizeOfSharedObject>
  8018c9:	83 c4 10             	add    $0x10,%esp
  8018cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  8018cf:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8018d3:	75 0a                	jne    8018df <sget+0x2f>
	{
		return NULL;
  8018d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8018da:	e9 94 00 00 00       	jmp    801973 <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8018df:	e8 64 06 00 00       	call   801f48 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8018e4:	85 c0                	test   %eax,%eax
  8018e6:	0f 84 82 00 00 00    	je     80196e <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  8018ec:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  8018f3:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8018fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801900:	01 d0                	add    %edx,%eax
  801902:	48                   	dec    %eax
  801903:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801906:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801909:	ba 00 00 00 00       	mov    $0x0,%edx
  80190e:	f7 75 ec             	divl   -0x14(%ebp)
  801911:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801914:	29 d0                	sub    %edx,%eax
  801916:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  801919:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80191c:	83 ec 0c             	sub    $0xc,%esp
  80191f:	50                   	push   %eax
  801920:	e8 10 0c 00 00       	call   802535 <alloc_block_FF>
  801925:	83 c4 10             	add    $0x10,%esp
  801928:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  80192b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80192f:	75 07                	jne    801938 <sget+0x88>
		{
			return NULL;
  801931:	b8 00 00 00 00       	mov    $0x0,%eax
  801936:	eb 3b                	jmp    801973 <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  801938:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80193b:	8b 40 08             	mov    0x8(%eax),%eax
  80193e:	83 ec 04             	sub    $0x4,%esp
  801941:	50                   	push   %eax
  801942:	ff 75 0c             	pushl  0xc(%ebp)
  801945:	ff 75 08             	pushl  0x8(%ebp)
  801948:	e8 c7 03 00 00       	call   801d14 <sys_getSharedObject>
  80194d:	83 c4 10             	add    $0x10,%esp
  801950:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  801953:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801957:	74 06                	je     80195f <sget+0xaf>
  801959:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  80195d:	75 07                	jne    801966 <sget+0xb6>
		{
			return NULL;
  80195f:	b8 00 00 00 00       	mov    $0x0,%eax
  801964:	eb 0d                	jmp    801973 <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  801966:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801969:	8b 40 08             	mov    0x8(%eax),%eax
  80196c:	eb 05                	jmp    801973 <sget+0xc3>
		}
	}
	else
			return NULL;
  80196e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801973:	c9                   	leave  
  801974:	c3                   	ret    

00801975 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801975:	55                   	push   %ebp
  801976:	89 e5                	mov    %esp,%ebp
  801978:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80197b:	e8 65 fb ff ff       	call   8014e5 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801980:	83 ec 04             	sub    $0x4,%esp
  801983:	68 a0 3d 80 00       	push   $0x803da0
  801988:	68 e1 00 00 00       	push   $0xe1
  80198d:	68 93 3d 80 00       	push   $0x803d93
  801992:	e8 10 eb ff ff       	call   8004a7 <_panic>

00801997 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801997:	55                   	push   %ebp
  801998:	89 e5                	mov    %esp,%ebp
  80199a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80199d:	83 ec 04             	sub    $0x4,%esp
  8019a0:	68 c8 3d 80 00       	push   $0x803dc8
  8019a5:	68 f5 00 00 00       	push   $0xf5
  8019aa:	68 93 3d 80 00       	push   $0x803d93
  8019af:	e8 f3 ea ff ff       	call   8004a7 <_panic>

008019b4 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8019b4:	55                   	push   %ebp
  8019b5:	89 e5                	mov    %esp,%ebp
  8019b7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019ba:	83 ec 04             	sub    $0x4,%esp
  8019bd:	68 ec 3d 80 00       	push   $0x803dec
  8019c2:	68 00 01 00 00       	push   $0x100
  8019c7:	68 93 3d 80 00       	push   $0x803d93
  8019cc:	e8 d6 ea ff ff       	call   8004a7 <_panic>

008019d1 <shrink>:

}
void shrink(uint32 newSize)
{
  8019d1:	55                   	push   %ebp
  8019d2:	89 e5                	mov    %esp,%ebp
  8019d4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019d7:	83 ec 04             	sub    $0x4,%esp
  8019da:	68 ec 3d 80 00       	push   $0x803dec
  8019df:	68 05 01 00 00       	push   $0x105
  8019e4:	68 93 3d 80 00       	push   $0x803d93
  8019e9:	e8 b9 ea ff ff       	call   8004a7 <_panic>

008019ee <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8019ee:	55                   	push   %ebp
  8019ef:	89 e5                	mov    %esp,%ebp
  8019f1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019f4:	83 ec 04             	sub    $0x4,%esp
  8019f7:	68 ec 3d 80 00       	push   $0x803dec
  8019fc:	68 0a 01 00 00       	push   $0x10a
  801a01:	68 93 3d 80 00       	push   $0x803d93
  801a06:	e8 9c ea ff ff       	call   8004a7 <_panic>

00801a0b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a0b:	55                   	push   %ebp
  801a0c:	89 e5                	mov    %esp,%ebp
  801a0e:	57                   	push   %edi
  801a0f:	56                   	push   %esi
  801a10:	53                   	push   %ebx
  801a11:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a14:	8b 45 08             	mov    0x8(%ebp),%eax
  801a17:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a1a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a1d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a20:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a23:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a26:	cd 30                	int    $0x30
  801a28:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a2e:	83 c4 10             	add    $0x10,%esp
  801a31:	5b                   	pop    %ebx
  801a32:	5e                   	pop    %esi
  801a33:	5f                   	pop    %edi
  801a34:	5d                   	pop    %ebp
  801a35:	c3                   	ret    

00801a36 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a36:	55                   	push   %ebp
  801a37:	89 e5                	mov    %esp,%ebp
  801a39:	83 ec 04             	sub    $0x4,%esp
  801a3c:	8b 45 10             	mov    0x10(%ebp),%eax
  801a3f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a42:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a46:	8b 45 08             	mov    0x8(%ebp),%eax
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	52                   	push   %edx
  801a4e:	ff 75 0c             	pushl  0xc(%ebp)
  801a51:	50                   	push   %eax
  801a52:	6a 00                	push   $0x0
  801a54:	e8 b2 ff ff ff       	call   801a0b <syscall>
  801a59:	83 c4 18             	add    $0x18,%esp
}
  801a5c:	90                   	nop
  801a5d:	c9                   	leave  
  801a5e:	c3                   	ret    

00801a5f <sys_cgetc>:

int
sys_cgetc(void)
{
  801a5f:	55                   	push   %ebp
  801a60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 01                	push   $0x1
  801a6e:	e8 98 ff ff ff       	call   801a0b <syscall>
  801a73:	83 c4 18             	add    $0x18,%esp
}
  801a76:	c9                   	leave  
  801a77:	c3                   	ret    

00801a78 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a78:	55                   	push   %ebp
  801a79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	52                   	push   %edx
  801a88:	50                   	push   %eax
  801a89:	6a 05                	push   $0x5
  801a8b:	e8 7b ff ff ff       	call   801a0b <syscall>
  801a90:	83 c4 18             	add    $0x18,%esp
}
  801a93:	c9                   	leave  
  801a94:	c3                   	ret    

00801a95 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
  801a98:	56                   	push   %esi
  801a99:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a9a:	8b 75 18             	mov    0x18(%ebp),%esi
  801a9d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801aa0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801aa3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa9:	56                   	push   %esi
  801aaa:	53                   	push   %ebx
  801aab:	51                   	push   %ecx
  801aac:	52                   	push   %edx
  801aad:	50                   	push   %eax
  801aae:	6a 06                	push   $0x6
  801ab0:	e8 56 ff ff ff       	call   801a0b <syscall>
  801ab5:	83 c4 18             	add    $0x18,%esp
}
  801ab8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801abb:	5b                   	pop    %ebx
  801abc:	5e                   	pop    %esi
  801abd:	5d                   	pop    %ebp
  801abe:	c3                   	ret    

00801abf <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801abf:	55                   	push   %ebp
  801ac0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801ac2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	52                   	push   %edx
  801acf:	50                   	push   %eax
  801ad0:	6a 07                	push   $0x7
  801ad2:	e8 34 ff ff ff       	call   801a0b <syscall>
  801ad7:	83 c4 18             	add    $0x18,%esp
}
  801ada:	c9                   	leave  
  801adb:	c3                   	ret    

00801adc <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801adc:	55                   	push   %ebp
  801add:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	ff 75 0c             	pushl  0xc(%ebp)
  801ae8:	ff 75 08             	pushl  0x8(%ebp)
  801aeb:	6a 08                	push   $0x8
  801aed:	e8 19 ff ff ff       	call   801a0b <syscall>
  801af2:	83 c4 18             	add    $0x18,%esp
}
  801af5:	c9                   	leave  
  801af6:	c3                   	ret    

00801af7 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801af7:	55                   	push   %ebp
  801af8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 09                	push   $0x9
  801b06:	e8 00 ff ff ff       	call   801a0b <syscall>
  801b0b:	83 c4 18             	add    $0x18,%esp
}
  801b0e:	c9                   	leave  
  801b0f:	c3                   	ret    

00801b10 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b10:	55                   	push   %ebp
  801b11:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 0a                	push   $0xa
  801b1f:	e8 e7 fe ff ff       	call   801a0b <syscall>
  801b24:	83 c4 18             	add    $0x18,%esp
}
  801b27:	c9                   	leave  
  801b28:	c3                   	ret    

00801b29 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b29:	55                   	push   %ebp
  801b2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	6a 0b                	push   $0xb
  801b38:	e8 ce fe ff ff       	call   801a0b <syscall>
  801b3d:	83 c4 18             	add    $0x18,%esp
}
  801b40:	c9                   	leave  
  801b41:	c3                   	ret    

00801b42 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b42:	55                   	push   %ebp
  801b43:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	ff 75 0c             	pushl  0xc(%ebp)
  801b4e:	ff 75 08             	pushl  0x8(%ebp)
  801b51:	6a 0f                	push   $0xf
  801b53:	e8 b3 fe ff ff       	call   801a0b <syscall>
  801b58:	83 c4 18             	add    $0x18,%esp
	return;
  801b5b:	90                   	nop
}
  801b5c:	c9                   	leave  
  801b5d:	c3                   	ret    

00801b5e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b5e:	55                   	push   %ebp
  801b5f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	ff 75 0c             	pushl  0xc(%ebp)
  801b6a:	ff 75 08             	pushl  0x8(%ebp)
  801b6d:	6a 10                	push   $0x10
  801b6f:	e8 97 fe ff ff       	call   801a0b <syscall>
  801b74:	83 c4 18             	add    $0x18,%esp
	return ;
  801b77:	90                   	nop
}
  801b78:	c9                   	leave  
  801b79:	c3                   	ret    

00801b7a <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	ff 75 10             	pushl  0x10(%ebp)
  801b84:	ff 75 0c             	pushl  0xc(%ebp)
  801b87:	ff 75 08             	pushl  0x8(%ebp)
  801b8a:	6a 11                	push   $0x11
  801b8c:	e8 7a fe ff ff       	call   801a0b <syscall>
  801b91:	83 c4 18             	add    $0x18,%esp
	return ;
  801b94:	90                   	nop
}
  801b95:	c9                   	leave  
  801b96:	c3                   	ret    

00801b97 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801b97:	55                   	push   %ebp
  801b98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 0c                	push   $0xc
  801ba6:	e8 60 fe ff ff       	call   801a0b <syscall>
  801bab:	83 c4 18             	add    $0x18,%esp
}
  801bae:	c9                   	leave  
  801baf:	c3                   	ret    

00801bb0 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801bb0:	55                   	push   %ebp
  801bb1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	ff 75 08             	pushl  0x8(%ebp)
  801bbe:	6a 0d                	push   $0xd
  801bc0:	e8 46 fe ff ff       	call   801a0b <syscall>
  801bc5:	83 c4 18             	add    $0x18,%esp
}
  801bc8:	c9                   	leave  
  801bc9:	c3                   	ret    

00801bca <sys_scarce_memory>:

void sys_scarce_memory()
{
  801bca:	55                   	push   %ebp
  801bcb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 0e                	push   $0xe
  801bd9:	e8 2d fe ff ff       	call   801a0b <syscall>
  801bde:	83 c4 18             	add    $0x18,%esp
}
  801be1:	90                   	nop
  801be2:	c9                   	leave  
  801be3:	c3                   	ret    

00801be4 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801be4:	55                   	push   %ebp
  801be5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 13                	push   $0x13
  801bf3:	e8 13 fe ff ff       	call   801a0b <syscall>
  801bf8:	83 c4 18             	add    $0x18,%esp
}
  801bfb:	90                   	nop
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    

00801bfe <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 14                	push   $0x14
  801c0d:	e8 f9 fd ff ff       	call   801a0b <syscall>
  801c12:	83 c4 18             	add    $0x18,%esp
}
  801c15:	90                   	nop
  801c16:	c9                   	leave  
  801c17:	c3                   	ret    

00801c18 <sys_cputc>:


void
sys_cputc(const char c)
{
  801c18:	55                   	push   %ebp
  801c19:	89 e5                	mov    %esp,%ebp
  801c1b:	83 ec 04             	sub    $0x4,%esp
  801c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c21:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c24:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	50                   	push   %eax
  801c31:	6a 15                	push   $0x15
  801c33:	e8 d3 fd ff ff       	call   801a0b <syscall>
  801c38:	83 c4 18             	add    $0x18,%esp
}
  801c3b:	90                   	nop
  801c3c:	c9                   	leave  
  801c3d:	c3                   	ret    

00801c3e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c3e:	55                   	push   %ebp
  801c3f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 16                	push   $0x16
  801c4d:	e8 b9 fd ff ff       	call   801a0b <syscall>
  801c52:	83 c4 18             	add    $0x18,%esp
}
  801c55:	90                   	nop
  801c56:	c9                   	leave  
  801c57:	c3                   	ret    

00801c58 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801c58:	55                   	push   %ebp
  801c59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	ff 75 0c             	pushl  0xc(%ebp)
  801c67:	50                   	push   %eax
  801c68:	6a 17                	push   $0x17
  801c6a:	e8 9c fd ff ff       	call   801a0b <syscall>
  801c6f:	83 c4 18             	add    $0x18,%esp
}
  801c72:	c9                   	leave  
  801c73:	c3                   	ret    

00801c74 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801c74:	55                   	push   %ebp
  801c75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c77:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	52                   	push   %edx
  801c84:	50                   	push   %eax
  801c85:	6a 1a                	push   $0x1a
  801c87:	e8 7f fd ff ff       	call   801a0b <syscall>
  801c8c:	83 c4 18             	add    $0x18,%esp
}
  801c8f:	c9                   	leave  
  801c90:	c3                   	ret    

00801c91 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c91:	55                   	push   %ebp
  801c92:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c94:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c97:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	52                   	push   %edx
  801ca1:	50                   	push   %eax
  801ca2:	6a 18                	push   $0x18
  801ca4:	e8 62 fd ff ff       	call   801a0b <syscall>
  801ca9:	83 c4 18             	add    $0x18,%esp
}
  801cac:	90                   	nop
  801cad:	c9                   	leave  
  801cae:	c3                   	ret    

00801caf <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801caf:	55                   	push   %ebp
  801cb0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	52                   	push   %edx
  801cbf:	50                   	push   %eax
  801cc0:	6a 19                	push   $0x19
  801cc2:	e8 44 fd ff ff       	call   801a0b <syscall>
  801cc7:	83 c4 18             	add    $0x18,%esp
}
  801cca:	90                   	nop
  801ccb:	c9                   	leave  
  801ccc:	c3                   	ret    

00801ccd <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ccd:	55                   	push   %ebp
  801cce:	89 e5                	mov    %esp,%ebp
  801cd0:	83 ec 04             	sub    $0x4,%esp
  801cd3:	8b 45 10             	mov    0x10(%ebp),%eax
  801cd6:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801cd9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cdc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce3:	6a 00                	push   $0x0
  801ce5:	51                   	push   %ecx
  801ce6:	52                   	push   %edx
  801ce7:	ff 75 0c             	pushl  0xc(%ebp)
  801cea:	50                   	push   %eax
  801ceb:	6a 1b                	push   $0x1b
  801ced:	e8 19 fd ff ff       	call   801a0b <syscall>
  801cf2:	83 c4 18             	add    $0x18,%esp
}
  801cf5:	c9                   	leave  
  801cf6:	c3                   	ret    

00801cf7 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801cf7:	55                   	push   %ebp
  801cf8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801cfa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	52                   	push   %edx
  801d07:	50                   	push   %eax
  801d08:	6a 1c                	push   $0x1c
  801d0a:	e8 fc fc ff ff       	call   801a0b <syscall>
  801d0f:	83 c4 18             	add    $0x18,%esp
}
  801d12:	c9                   	leave  
  801d13:	c3                   	ret    

00801d14 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d14:	55                   	push   %ebp
  801d15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d17:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	51                   	push   %ecx
  801d25:	52                   	push   %edx
  801d26:	50                   	push   %eax
  801d27:	6a 1d                	push   $0x1d
  801d29:	e8 dd fc ff ff       	call   801a0b <syscall>
  801d2e:	83 c4 18             	add    $0x18,%esp
}
  801d31:	c9                   	leave  
  801d32:	c3                   	ret    

00801d33 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d33:	55                   	push   %ebp
  801d34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d36:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d39:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	52                   	push   %edx
  801d43:	50                   	push   %eax
  801d44:	6a 1e                	push   $0x1e
  801d46:	e8 c0 fc ff ff       	call   801a0b <syscall>
  801d4b:	83 c4 18             	add    $0x18,%esp
}
  801d4e:	c9                   	leave  
  801d4f:	c3                   	ret    

00801d50 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801d50:	55                   	push   %ebp
  801d51:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 1f                	push   $0x1f
  801d5f:	e8 a7 fc ff ff       	call   801a0b <syscall>
  801d64:	83 c4 18             	add    $0x18,%esp
}
  801d67:	c9                   	leave  
  801d68:	c3                   	ret    

00801d69 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d69:	55                   	push   %ebp
  801d6a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6f:	6a 00                	push   $0x0
  801d71:	ff 75 14             	pushl  0x14(%ebp)
  801d74:	ff 75 10             	pushl  0x10(%ebp)
  801d77:	ff 75 0c             	pushl  0xc(%ebp)
  801d7a:	50                   	push   %eax
  801d7b:	6a 20                	push   $0x20
  801d7d:	e8 89 fc ff ff       	call   801a0b <syscall>
  801d82:	83 c4 18             	add    $0x18,%esp
}
  801d85:	c9                   	leave  
  801d86:	c3                   	ret    

00801d87 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801d87:	55                   	push   %ebp
  801d88:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	50                   	push   %eax
  801d96:	6a 21                	push   $0x21
  801d98:	e8 6e fc ff ff       	call   801a0b <syscall>
  801d9d:	83 c4 18             	add    $0x18,%esp
}
  801da0:	90                   	nop
  801da1:	c9                   	leave  
  801da2:	c3                   	ret    

00801da3 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801da3:	55                   	push   %ebp
  801da4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801da6:	8b 45 08             	mov    0x8(%ebp),%eax
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	50                   	push   %eax
  801db2:	6a 22                	push   $0x22
  801db4:	e8 52 fc ff ff       	call   801a0b <syscall>
  801db9:	83 c4 18             	add    $0x18,%esp
}
  801dbc:	c9                   	leave  
  801dbd:	c3                   	ret    

00801dbe <sys_getenvid>:

int32 sys_getenvid(void)
{
  801dbe:	55                   	push   %ebp
  801dbf:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 02                	push   $0x2
  801dcd:	e8 39 fc ff ff       	call   801a0b <syscall>
  801dd2:	83 c4 18             	add    $0x18,%esp
}
  801dd5:	c9                   	leave  
  801dd6:	c3                   	ret    

00801dd7 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801dd7:	55                   	push   %ebp
  801dd8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	6a 03                	push   $0x3
  801de6:	e8 20 fc ff ff       	call   801a0b <syscall>
  801deb:	83 c4 18             	add    $0x18,%esp
}
  801dee:	c9                   	leave  
  801def:	c3                   	ret    

00801df0 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801df0:	55                   	push   %ebp
  801df1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 04                	push   $0x4
  801dff:	e8 07 fc ff ff       	call   801a0b <syscall>
  801e04:	83 c4 18             	add    $0x18,%esp
}
  801e07:	c9                   	leave  
  801e08:	c3                   	ret    

00801e09 <sys_exit_env>:


void sys_exit_env(void)
{
  801e09:	55                   	push   %ebp
  801e0a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	6a 00                	push   $0x0
  801e16:	6a 23                	push   $0x23
  801e18:	e8 ee fb ff ff       	call   801a0b <syscall>
  801e1d:	83 c4 18             	add    $0x18,%esp
}
  801e20:	90                   	nop
  801e21:	c9                   	leave  
  801e22:	c3                   	ret    

00801e23 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801e23:	55                   	push   %ebp
  801e24:	89 e5                	mov    %esp,%ebp
  801e26:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e29:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e2c:	8d 50 04             	lea    0x4(%eax),%edx
  801e2f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e32:	6a 00                	push   $0x0
  801e34:	6a 00                	push   $0x0
  801e36:	6a 00                	push   $0x0
  801e38:	52                   	push   %edx
  801e39:	50                   	push   %eax
  801e3a:	6a 24                	push   $0x24
  801e3c:	e8 ca fb ff ff       	call   801a0b <syscall>
  801e41:	83 c4 18             	add    $0x18,%esp
	return result;
  801e44:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e47:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e4a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e4d:	89 01                	mov    %eax,(%ecx)
  801e4f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e52:	8b 45 08             	mov    0x8(%ebp),%eax
  801e55:	c9                   	leave  
  801e56:	c2 04 00             	ret    $0x4

00801e59 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e59:	55                   	push   %ebp
  801e5a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 00                	push   $0x0
  801e60:	ff 75 10             	pushl  0x10(%ebp)
  801e63:	ff 75 0c             	pushl  0xc(%ebp)
  801e66:	ff 75 08             	pushl  0x8(%ebp)
  801e69:	6a 12                	push   $0x12
  801e6b:	e8 9b fb ff ff       	call   801a0b <syscall>
  801e70:	83 c4 18             	add    $0x18,%esp
	return ;
  801e73:	90                   	nop
}
  801e74:	c9                   	leave  
  801e75:	c3                   	ret    

00801e76 <sys_rcr2>:
uint32 sys_rcr2()
{
  801e76:	55                   	push   %ebp
  801e77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 00                	push   $0x0
  801e7d:	6a 00                	push   $0x0
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	6a 25                	push   $0x25
  801e85:	e8 81 fb ff ff       	call   801a0b <syscall>
  801e8a:	83 c4 18             	add    $0x18,%esp
}
  801e8d:	c9                   	leave  
  801e8e:	c3                   	ret    

00801e8f <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801e8f:	55                   	push   %ebp
  801e90:	89 e5                	mov    %esp,%ebp
  801e92:	83 ec 04             	sub    $0x4,%esp
  801e95:	8b 45 08             	mov    0x8(%ebp),%eax
  801e98:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e9b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 00                	push   $0x0
  801ea7:	50                   	push   %eax
  801ea8:	6a 26                	push   $0x26
  801eaa:	e8 5c fb ff ff       	call   801a0b <syscall>
  801eaf:	83 c4 18             	add    $0x18,%esp
	return ;
  801eb2:	90                   	nop
}
  801eb3:	c9                   	leave  
  801eb4:	c3                   	ret    

00801eb5 <rsttst>:
void rsttst()
{
  801eb5:	55                   	push   %ebp
  801eb6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801eb8:	6a 00                	push   $0x0
  801eba:	6a 00                	push   $0x0
  801ebc:	6a 00                	push   $0x0
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 28                	push   $0x28
  801ec4:	e8 42 fb ff ff       	call   801a0b <syscall>
  801ec9:	83 c4 18             	add    $0x18,%esp
	return ;
  801ecc:	90                   	nop
}
  801ecd:	c9                   	leave  
  801ece:	c3                   	ret    

00801ecf <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ecf:	55                   	push   %ebp
  801ed0:	89 e5                	mov    %esp,%ebp
  801ed2:	83 ec 04             	sub    $0x4,%esp
  801ed5:	8b 45 14             	mov    0x14(%ebp),%eax
  801ed8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801edb:	8b 55 18             	mov    0x18(%ebp),%edx
  801ede:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ee2:	52                   	push   %edx
  801ee3:	50                   	push   %eax
  801ee4:	ff 75 10             	pushl  0x10(%ebp)
  801ee7:	ff 75 0c             	pushl  0xc(%ebp)
  801eea:	ff 75 08             	pushl  0x8(%ebp)
  801eed:	6a 27                	push   $0x27
  801eef:	e8 17 fb ff ff       	call   801a0b <syscall>
  801ef4:	83 c4 18             	add    $0x18,%esp
	return ;
  801ef7:	90                   	nop
}
  801ef8:	c9                   	leave  
  801ef9:	c3                   	ret    

00801efa <chktst>:
void chktst(uint32 n)
{
  801efa:	55                   	push   %ebp
  801efb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801efd:	6a 00                	push   $0x0
  801eff:	6a 00                	push   $0x0
  801f01:	6a 00                	push   $0x0
  801f03:	6a 00                	push   $0x0
  801f05:	ff 75 08             	pushl  0x8(%ebp)
  801f08:	6a 29                	push   $0x29
  801f0a:	e8 fc fa ff ff       	call   801a0b <syscall>
  801f0f:	83 c4 18             	add    $0x18,%esp
	return ;
  801f12:	90                   	nop
}
  801f13:	c9                   	leave  
  801f14:	c3                   	ret    

00801f15 <inctst>:

void inctst()
{
  801f15:	55                   	push   %ebp
  801f16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f18:	6a 00                	push   $0x0
  801f1a:	6a 00                	push   $0x0
  801f1c:	6a 00                	push   $0x0
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 00                	push   $0x0
  801f22:	6a 2a                	push   $0x2a
  801f24:	e8 e2 fa ff ff       	call   801a0b <syscall>
  801f29:	83 c4 18             	add    $0x18,%esp
	return ;
  801f2c:	90                   	nop
}
  801f2d:	c9                   	leave  
  801f2e:	c3                   	ret    

00801f2f <gettst>:
uint32 gettst()
{
  801f2f:	55                   	push   %ebp
  801f30:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f32:	6a 00                	push   $0x0
  801f34:	6a 00                	push   $0x0
  801f36:	6a 00                	push   $0x0
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 2b                	push   $0x2b
  801f3e:	e8 c8 fa ff ff       	call   801a0b <syscall>
  801f43:	83 c4 18             	add    $0x18,%esp
}
  801f46:	c9                   	leave  
  801f47:	c3                   	ret    

00801f48 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f48:	55                   	push   %ebp
  801f49:	89 e5                	mov    %esp,%ebp
  801f4b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f4e:	6a 00                	push   $0x0
  801f50:	6a 00                	push   $0x0
  801f52:	6a 00                	push   $0x0
  801f54:	6a 00                	push   $0x0
  801f56:	6a 00                	push   $0x0
  801f58:	6a 2c                	push   $0x2c
  801f5a:	e8 ac fa ff ff       	call   801a0b <syscall>
  801f5f:	83 c4 18             	add    $0x18,%esp
  801f62:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f65:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f69:	75 07                	jne    801f72 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f6b:	b8 01 00 00 00       	mov    $0x1,%eax
  801f70:	eb 05                	jmp    801f77 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f72:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f77:	c9                   	leave  
  801f78:	c3                   	ret    

00801f79 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f79:	55                   	push   %ebp
  801f7a:	89 e5                	mov    %esp,%ebp
  801f7c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 00                	push   $0x0
  801f83:	6a 00                	push   $0x0
  801f85:	6a 00                	push   $0x0
  801f87:	6a 00                	push   $0x0
  801f89:	6a 2c                	push   $0x2c
  801f8b:	e8 7b fa ff ff       	call   801a0b <syscall>
  801f90:	83 c4 18             	add    $0x18,%esp
  801f93:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f96:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f9a:	75 07                	jne    801fa3 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f9c:	b8 01 00 00 00       	mov    $0x1,%eax
  801fa1:	eb 05                	jmp    801fa8 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801fa3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fa8:	c9                   	leave  
  801fa9:	c3                   	ret    

00801faa <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801faa:	55                   	push   %ebp
  801fab:	89 e5                	mov    %esp,%ebp
  801fad:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fb0:	6a 00                	push   $0x0
  801fb2:	6a 00                	push   $0x0
  801fb4:	6a 00                	push   $0x0
  801fb6:	6a 00                	push   $0x0
  801fb8:	6a 00                	push   $0x0
  801fba:	6a 2c                	push   $0x2c
  801fbc:	e8 4a fa ff ff       	call   801a0b <syscall>
  801fc1:	83 c4 18             	add    $0x18,%esp
  801fc4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801fc7:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801fcb:	75 07                	jne    801fd4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801fcd:	b8 01 00 00 00       	mov    $0x1,%eax
  801fd2:	eb 05                	jmp    801fd9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801fd4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fd9:	c9                   	leave  
  801fda:	c3                   	ret    

00801fdb <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801fdb:	55                   	push   %ebp
  801fdc:	89 e5                	mov    %esp,%ebp
  801fde:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fe1:	6a 00                	push   $0x0
  801fe3:	6a 00                	push   $0x0
  801fe5:	6a 00                	push   $0x0
  801fe7:	6a 00                	push   $0x0
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 2c                	push   $0x2c
  801fed:	e8 19 fa ff ff       	call   801a0b <syscall>
  801ff2:	83 c4 18             	add    $0x18,%esp
  801ff5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ff8:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ffc:	75 07                	jne    802005 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ffe:	b8 01 00 00 00       	mov    $0x1,%eax
  802003:	eb 05                	jmp    80200a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802005:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80200a:	c9                   	leave  
  80200b:	c3                   	ret    

0080200c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80200c:	55                   	push   %ebp
  80200d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80200f:	6a 00                	push   $0x0
  802011:	6a 00                	push   $0x0
  802013:	6a 00                	push   $0x0
  802015:	6a 00                	push   $0x0
  802017:	ff 75 08             	pushl  0x8(%ebp)
  80201a:	6a 2d                	push   $0x2d
  80201c:	e8 ea f9 ff ff       	call   801a0b <syscall>
  802021:	83 c4 18             	add    $0x18,%esp
	return ;
  802024:	90                   	nop
}
  802025:	c9                   	leave  
  802026:	c3                   	ret    

00802027 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802027:	55                   	push   %ebp
  802028:	89 e5                	mov    %esp,%ebp
  80202a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80202b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80202e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802031:	8b 55 0c             	mov    0xc(%ebp),%edx
  802034:	8b 45 08             	mov    0x8(%ebp),%eax
  802037:	6a 00                	push   $0x0
  802039:	53                   	push   %ebx
  80203a:	51                   	push   %ecx
  80203b:	52                   	push   %edx
  80203c:	50                   	push   %eax
  80203d:	6a 2e                	push   $0x2e
  80203f:	e8 c7 f9 ff ff       	call   801a0b <syscall>
  802044:	83 c4 18             	add    $0x18,%esp
}
  802047:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80204a:	c9                   	leave  
  80204b:	c3                   	ret    

0080204c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80204c:	55                   	push   %ebp
  80204d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80204f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802052:	8b 45 08             	mov    0x8(%ebp),%eax
  802055:	6a 00                	push   $0x0
  802057:	6a 00                	push   $0x0
  802059:	6a 00                	push   $0x0
  80205b:	52                   	push   %edx
  80205c:	50                   	push   %eax
  80205d:	6a 2f                	push   $0x2f
  80205f:	e8 a7 f9 ff ff       	call   801a0b <syscall>
  802064:	83 c4 18             	add    $0x18,%esp
}
  802067:	c9                   	leave  
  802068:	c3                   	ret    

00802069 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802069:	55                   	push   %ebp
  80206a:	89 e5                	mov    %esp,%ebp
  80206c:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80206f:	83 ec 0c             	sub    $0xc,%esp
  802072:	68 fc 3d 80 00       	push   $0x803dfc
  802077:	e8 df e6 ff ff       	call   80075b <cprintf>
  80207c:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80207f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802086:	83 ec 0c             	sub    $0xc,%esp
  802089:	68 28 3e 80 00       	push   $0x803e28
  80208e:	e8 c8 e6 ff ff       	call   80075b <cprintf>
  802093:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802096:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80209a:	a1 38 41 80 00       	mov    0x804138,%eax
  80209f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020a2:	eb 56                	jmp    8020fa <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8020a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020a8:	74 1c                	je     8020c6 <print_mem_block_lists+0x5d>
  8020aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ad:	8b 50 08             	mov    0x8(%eax),%edx
  8020b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b3:	8b 48 08             	mov    0x8(%eax),%ecx
  8020b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8020bc:	01 c8                	add    %ecx,%eax
  8020be:	39 c2                	cmp    %eax,%edx
  8020c0:	73 04                	jae    8020c6 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8020c2:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c9:	8b 50 08             	mov    0x8(%eax),%edx
  8020cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8020d2:	01 c2                	add    %eax,%edx
  8020d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d7:	8b 40 08             	mov    0x8(%eax),%eax
  8020da:	83 ec 04             	sub    $0x4,%esp
  8020dd:	52                   	push   %edx
  8020de:	50                   	push   %eax
  8020df:	68 3d 3e 80 00       	push   $0x803e3d
  8020e4:	e8 72 e6 ff ff       	call   80075b <cprintf>
  8020e9:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8020ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8020f2:	a1 40 41 80 00       	mov    0x804140,%eax
  8020f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020fe:	74 07                	je     802107 <print_mem_block_lists+0x9e>
  802100:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802103:	8b 00                	mov    (%eax),%eax
  802105:	eb 05                	jmp    80210c <print_mem_block_lists+0xa3>
  802107:	b8 00 00 00 00       	mov    $0x0,%eax
  80210c:	a3 40 41 80 00       	mov    %eax,0x804140
  802111:	a1 40 41 80 00       	mov    0x804140,%eax
  802116:	85 c0                	test   %eax,%eax
  802118:	75 8a                	jne    8020a4 <print_mem_block_lists+0x3b>
  80211a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80211e:	75 84                	jne    8020a4 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802120:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802124:	75 10                	jne    802136 <print_mem_block_lists+0xcd>
  802126:	83 ec 0c             	sub    $0xc,%esp
  802129:	68 4c 3e 80 00       	push   $0x803e4c
  80212e:	e8 28 e6 ff ff       	call   80075b <cprintf>
  802133:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802136:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80213d:	83 ec 0c             	sub    $0xc,%esp
  802140:	68 70 3e 80 00       	push   $0x803e70
  802145:	e8 11 e6 ff ff       	call   80075b <cprintf>
  80214a:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80214d:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802151:	a1 40 40 80 00       	mov    0x804040,%eax
  802156:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802159:	eb 56                	jmp    8021b1 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80215b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80215f:	74 1c                	je     80217d <print_mem_block_lists+0x114>
  802161:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802164:	8b 50 08             	mov    0x8(%eax),%edx
  802167:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80216a:	8b 48 08             	mov    0x8(%eax),%ecx
  80216d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802170:	8b 40 0c             	mov    0xc(%eax),%eax
  802173:	01 c8                	add    %ecx,%eax
  802175:	39 c2                	cmp    %eax,%edx
  802177:	73 04                	jae    80217d <print_mem_block_lists+0x114>
			sorted = 0 ;
  802179:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80217d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802180:	8b 50 08             	mov    0x8(%eax),%edx
  802183:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802186:	8b 40 0c             	mov    0xc(%eax),%eax
  802189:	01 c2                	add    %eax,%edx
  80218b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80218e:	8b 40 08             	mov    0x8(%eax),%eax
  802191:	83 ec 04             	sub    $0x4,%esp
  802194:	52                   	push   %edx
  802195:	50                   	push   %eax
  802196:	68 3d 3e 80 00       	push   $0x803e3d
  80219b:	e8 bb e5 ff ff       	call   80075b <cprintf>
  8021a0:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8021a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8021a9:	a1 48 40 80 00       	mov    0x804048,%eax
  8021ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021b5:	74 07                	je     8021be <print_mem_block_lists+0x155>
  8021b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ba:	8b 00                	mov    (%eax),%eax
  8021bc:	eb 05                	jmp    8021c3 <print_mem_block_lists+0x15a>
  8021be:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c3:	a3 48 40 80 00       	mov    %eax,0x804048
  8021c8:	a1 48 40 80 00       	mov    0x804048,%eax
  8021cd:	85 c0                	test   %eax,%eax
  8021cf:	75 8a                	jne    80215b <print_mem_block_lists+0xf2>
  8021d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021d5:	75 84                	jne    80215b <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8021d7:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8021db:	75 10                	jne    8021ed <print_mem_block_lists+0x184>
  8021dd:	83 ec 0c             	sub    $0xc,%esp
  8021e0:	68 88 3e 80 00       	push   $0x803e88
  8021e5:	e8 71 e5 ff ff       	call   80075b <cprintf>
  8021ea:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8021ed:	83 ec 0c             	sub    $0xc,%esp
  8021f0:	68 fc 3d 80 00       	push   $0x803dfc
  8021f5:	e8 61 e5 ff ff       	call   80075b <cprintf>
  8021fa:	83 c4 10             	add    $0x10,%esp

}
  8021fd:	90                   	nop
  8021fe:	c9                   	leave  
  8021ff:	c3                   	ret    

00802200 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802200:	55                   	push   %ebp
  802201:	89 e5                	mov    %esp,%ebp
  802203:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802206:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  80220d:	00 00 00 
  802210:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802217:	00 00 00 
  80221a:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802221:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  802224:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80222b:	e9 9e 00 00 00       	jmp    8022ce <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802230:	a1 50 40 80 00       	mov    0x804050,%eax
  802235:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802238:	c1 e2 04             	shl    $0x4,%edx
  80223b:	01 d0                	add    %edx,%eax
  80223d:	85 c0                	test   %eax,%eax
  80223f:	75 14                	jne    802255 <initialize_MemBlocksList+0x55>
  802241:	83 ec 04             	sub    $0x4,%esp
  802244:	68 b0 3e 80 00       	push   $0x803eb0
  802249:	6a 42                	push   $0x42
  80224b:	68 d3 3e 80 00       	push   $0x803ed3
  802250:	e8 52 e2 ff ff       	call   8004a7 <_panic>
  802255:	a1 50 40 80 00       	mov    0x804050,%eax
  80225a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80225d:	c1 e2 04             	shl    $0x4,%edx
  802260:	01 d0                	add    %edx,%eax
  802262:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802268:	89 10                	mov    %edx,(%eax)
  80226a:	8b 00                	mov    (%eax),%eax
  80226c:	85 c0                	test   %eax,%eax
  80226e:	74 18                	je     802288 <initialize_MemBlocksList+0x88>
  802270:	a1 48 41 80 00       	mov    0x804148,%eax
  802275:	8b 15 50 40 80 00    	mov    0x804050,%edx
  80227b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80227e:	c1 e1 04             	shl    $0x4,%ecx
  802281:	01 ca                	add    %ecx,%edx
  802283:	89 50 04             	mov    %edx,0x4(%eax)
  802286:	eb 12                	jmp    80229a <initialize_MemBlocksList+0x9a>
  802288:	a1 50 40 80 00       	mov    0x804050,%eax
  80228d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802290:	c1 e2 04             	shl    $0x4,%edx
  802293:	01 d0                	add    %edx,%eax
  802295:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80229a:	a1 50 40 80 00       	mov    0x804050,%eax
  80229f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022a2:	c1 e2 04             	shl    $0x4,%edx
  8022a5:	01 d0                	add    %edx,%eax
  8022a7:	a3 48 41 80 00       	mov    %eax,0x804148
  8022ac:	a1 50 40 80 00       	mov    0x804050,%eax
  8022b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022b4:	c1 e2 04             	shl    $0x4,%edx
  8022b7:	01 d0                	add    %edx,%eax
  8022b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022c0:	a1 54 41 80 00       	mov    0x804154,%eax
  8022c5:	40                   	inc    %eax
  8022c6:	a3 54 41 80 00       	mov    %eax,0x804154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  8022cb:	ff 45 f4             	incl   -0xc(%ebp)
  8022ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022d4:	0f 82 56 ff ff ff    	jb     802230 <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  8022da:	90                   	nop
  8022db:	c9                   	leave  
  8022dc:	c3                   	ret    

008022dd <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8022dd:	55                   	push   %ebp
  8022de:	89 e5                	mov    %esp,%ebp
  8022e0:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  8022e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e6:	8b 00                	mov    (%eax),%eax
  8022e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8022eb:	eb 19                	jmp    802306 <find_block+0x29>
	{
		if(blk->sva==va)
  8022ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022f0:	8b 40 08             	mov    0x8(%eax),%eax
  8022f3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8022f6:	75 05                	jne    8022fd <find_block+0x20>
			return (blk);
  8022f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022fb:	eb 36                	jmp    802333 <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  8022fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802300:	8b 40 08             	mov    0x8(%eax),%eax
  802303:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802306:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80230a:	74 07                	je     802313 <find_block+0x36>
  80230c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80230f:	8b 00                	mov    (%eax),%eax
  802311:	eb 05                	jmp    802318 <find_block+0x3b>
  802313:	b8 00 00 00 00       	mov    $0x0,%eax
  802318:	8b 55 08             	mov    0x8(%ebp),%edx
  80231b:	89 42 08             	mov    %eax,0x8(%edx)
  80231e:	8b 45 08             	mov    0x8(%ebp),%eax
  802321:	8b 40 08             	mov    0x8(%eax),%eax
  802324:	85 c0                	test   %eax,%eax
  802326:	75 c5                	jne    8022ed <find_block+0x10>
  802328:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80232c:	75 bf                	jne    8022ed <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  80232e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802333:	c9                   	leave  
  802334:	c3                   	ret    

00802335 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802335:	55                   	push   %ebp
  802336:	89 e5                	mov    %esp,%ebp
  802338:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  80233b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802340:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802343:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  80234a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80234d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802350:	75 65                	jne    8023b7 <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802352:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802356:	75 14                	jne    80236c <insert_sorted_allocList+0x37>
  802358:	83 ec 04             	sub    $0x4,%esp
  80235b:	68 b0 3e 80 00       	push   $0x803eb0
  802360:	6a 5c                	push   $0x5c
  802362:	68 d3 3e 80 00       	push   $0x803ed3
  802367:	e8 3b e1 ff ff       	call   8004a7 <_panic>
  80236c:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802372:	8b 45 08             	mov    0x8(%ebp),%eax
  802375:	89 10                	mov    %edx,(%eax)
  802377:	8b 45 08             	mov    0x8(%ebp),%eax
  80237a:	8b 00                	mov    (%eax),%eax
  80237c:	85 c0                	test   %eax,%eax
  80237e:	74 0d                	je     80238d <insert_sorted_allocList+0x58>
  802380:	a1 40 40 80 00       	mov    0x804040,%eax
  802385:	8b 55 08             	mov    0x8(%ebp),%edx
  802388:	89 50 04             	mov    %edx,0x4(%eax)
  80238b:	eb 08                	jmp    802395 <insert_sorted_allocList+0x60>
  80238d:	8b 45 08             	mov    0x8(%ebp),%eax
  802390:	a3 44 40 80 00       	mov    %eax,0x804044
  802395:	8b 45 08             	mov    0x8(%ebp),%eax
  802398:	a3 40 40 80 00       	mov    %eax,0x804040
  80239d:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023a7:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023ac:	40                   	inc    %eax
  8023ad:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  8023b2:	e9 7b 01 00 00       	jmp    802532 <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  8023b7:	a1 44 40 80 00       	mov    0x804044,%eax
  8023bc:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  8023bf:	a1 40 40 80 00       	mov    0x804040,%eax
  8023c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  8023c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ca:	8b 50 08             	mov    0x8(%eax),%edx
  8023cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023d0:	8b 40 08             	mov    0x8(%eax),%eax
  8023d3:	39 c2                	cmp    %eax,%edx
  8023d5:	76 65                	jbe    80243c <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  8023d7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023db:	75 14                	jne    8023f1 <insert_sorted_allocList+0xbc>
  8023dd:	83 ec 04             	sub    $0x4,%esp
  8023e0:	68 ec 3e 80 00       	push   $0x803eec
  8023e5:	6a 64                	push   $0x64
  8023e7:	68 d3 3e 80 00       	push   $0x803ed3
  8023ec:	e8 b6 e0 ff ff       	call   8004a7 <_panic>
  8023f1:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8023f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fa:	89 50 04             	mov    %edx,0x4(%eax)
  8023fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802400:	8b 40 04             	mov    0x4(%eax),%eax
  802403:	85 c0                	test   %eax,%eax
  802405:	74 0c                	je     802413 <insert_sorted_allocList+0xde>
  802407:	a1 44 40 80 00       	mov    0x804044,%eax
  80240c:	8b 55 08             	mov    0x8(%ebp),%edx
  80240f:	89 10                	mov    %edx,(%eax)
  802411:	eb 08                	jmp    80241b <insert_sorted_allocList+0xe6>
  802413:	8b 45 08             	mov    0x8(%ebp),%eax
  802416:	a3 40 40 80 00       	mov    %eax,0x804040
  80241b:	8b 45 08             	mov    0x8(%ebp),%eax
  80241e:	a3 44 40 80 00       	mov    %eax,0x804044
  802423:	8b 45 08             	mov    0x8(%ebp),%eax
  802426:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80242c:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802431:	40                   	inc    %eax
  802432:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  802437:	e9 f6 00 00 00       	jmp    802532 <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  80243c:	8b 45 08             	mov    0x8(%ebp),%eax
  80243f:	8b 50 08             	mov    0x8(%eax),%edx
  802442:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802445:	8b 40 08             	mov    0x8(%eax),%eax
  802448:	39 c2                	cmp    %eax,%edx
  80244a:	73 65                	jae    8024b1 <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80244c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802450:	75 14                	jne    802466 <insert_sorted_allocList+0x131>
  802452:	83 ec 04             	sub    $0x4,%esp
  802455:	68 b0 3e 80 00       	push   $0x803eb0
  80245a:	6a 68                	push   $0x68
  80245c:	68 d3 3e 80 00       	push   $0x803ed3
  802461:	e8 41 e0 ff ff       	call   8004a7 <_panic>
  802466:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80246c:	8b 45 08             	mov    0x8(%ebp),%eax
  80246f:	89 10                	mov    %edx,(%eax)
  802471:	8b 45 08             	mov    0x8(%ebp),%eax
  802474:	8b 00                	mov    (%eax),%eax
  802476:	85 c0                	test   %eax,%eax
  802478:	74 0d                	je     802487 <insert_sorted_allocList+0x152>
  80247a:	a1 40 40 80 00       	mov    0x804040,%eax
  80247f:	8b 55 08             	mov    0x8(%ebp),%edx
  802482:	89 50 04             	mov    %edx,0x4(%eax)
  802485:	eb 08                	jmp    80248f <insert_sorted_allocList+0x15a>
  802487:	8b 45 08             	mov    0x8(%ebp),%eax
  80248a:	a3 44 40 80 00       	mov    %eax,0x804044
  80248f:	8b 45 08             	mov    0x8(%ebp),%eax
  802492:	a3 40 40 80 00       	mov    %eax,0x804040
  802497:	8b 45 08             	mov    0x8(%ebp),%eax
  80249a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024a1:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8024a6:	40                   	inc    %eax
  8024a7:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  8024ac:	e9 81 00 00 00       	jmp    802532 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  8024b1:	a1 40 40 80 00       	mov    0x804040,%eax
  8024b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024b9:	eb 51                	jmp    80250c <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  8024bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024be:	8b 50 08             	mov    0x8(%eax),%edx
  8024c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c4:	8b 40 08             	mov    0x8(%eax),%eax
  8024c7:	39 c2                	cmp    %eax,%edx
  8024c9:	73 39                	jae    802504 <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  8024cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ce:	8b 40 04             	mov    0x4(%eax),%eax
  8024d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  8024d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8024da:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  8024dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024df:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8024e2:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  8024e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024eb:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  8024ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8024f3:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  8024f6:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8024fb:	40                   	inc    %eax
  8024fc:	a3 4c 40 80 00       	mov    %eax,0x80404c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  802501:	90                   	nop
				}
			}
		 }

	}
}
  802502:	eb 2e                	jmp    802532 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802504:	a1 48 40 80 00       	mov    0x804048,%eax
  802509:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80250c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802510:	74 07                	je     802519 <insert_sorted_allocList+0x1e4>
  802512:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802515:	8b 00                	mov    (%eax),%eax
  802517:	eb 05                	jmp    80251e <insert_sorted_allocList+0x1e9>
  802519:	b8 00 00 00 00       	mov    $0x0,%eax
  80251e:	a3 48 40 80 00       	mov    %eax,0x804048
  802523:	a1 48 40 80 00       	mov    0x804048,%eax
  802528:	85 c0                	test   %eax,%eax
  80252a:	75 8f                	jne    8024bb <insert_sorted_allocList+0x186>
  80252c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802530:	75 89                	jne    8024bb <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  802532:	90                   	nop
  802533:	c9                   	leave  
  802534:	c3                   	ret    

00802535 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802535:	55                   	push   %ebp
  802536:	89 e5                	mov    %esp,%ebp
  802538:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  80253b:	a1 38 41 80 00       	mov    0x804138,%eax
  802540:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802543:	e9 76 01 00 00       	jmp    8026be <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  802548:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254b:	8b 40 0c             	mov    0xc(%eax),%eax
  80254e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802551:	0f 85 8a 00 00 00    	jne    8025e1 <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  802557:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80255b:	75 17                	jne    802574 <alloc_block_FF+0x3f>
  80255d:	83 ec 04             	sub    $0x4,%esp
  802560:	68 0f 3f 80 00       	push   $0x803f0f
  802565:	68 8a 00 00 00       	push   $0x8a
  80256a:	68 d3 3e 80 00       	push   $0x803ed3
  80256f:	e8 33 df ff ff       	call   8004a7 <_panic>
  802574:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802577:	8b 00                	mov    (%eax),%eax
  802579:	85 c0                	test   %eax,%eax
  80257b:	74 10                	je     80258d <alloc_block_FF+0x58>
  80257d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802580:	8b 00                	mov    (%eax),%eax
  802582:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802585:	8b 52 04             	mov    0x4(%edx),%edx
  802588:	89 50 04             	mov    %edx,0x4(%eax)
  80258b:	eb 0b                	jmp    802598 <alloc_block_FF+0x63>
  80258d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802590:	8b 40 04             	mov    0x4(%eax),%eax
  802593:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802598:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259b:	8b 40 04             	mov    0x4(%eax),%eax
  80259e:	85 c0                	test   %eax,%eax
  8025a0:	74 0f                	je     8025b1 <alloc_block_FF+0x7c>
  8025a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a5:	8b 40 04             	mov    0x4(%eax),%eax
  8025a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025ab:	8b 12                	mov    (%edx),%edx
  8025ad:	89 10                	mov    %edx,(%eax)
  8025af:	eb 0a                	jmp    8025bb <alloc_block_FF+0x86>
  8025b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b4:	8b 00                	mov    (%eax),%eax
  8025b6:	a3 38 41 80 00       	mov    %eax,0x804138
  8025bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025ce:	a1 44 41 80 00       	mov    0x804144,%eax
  8025d3:	48                   	dec    %eax
  8025d4:	a3 44 41 80 00       	mov    %eax,0x804144
			return element;
  8025d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dc:	e9 10 01 00 00       	jmp    8026f1 <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  8025e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8025e7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025ea:	0f 86 c6 00 00 00    	jbe    8026b6 <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  8025f0:	a1 48 41 80 00       	mov    0x804148,%eax
  8025f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  8025f8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025fc:	75 17                	jne    802615 <alloc_block_FF+0xe0>
  8025fe:	83 ec 04             	sub    $0x4,%esp
  802601:	68 0f 3f 80 00       	push   $0x803f0f
  802606:	68 90 00 00 00       	push   $0x90
  80260b:	68 d3 3e 80 00       	push   $0x803ed3
  802610:	e8 92 de ff ff       	call   8004a7 <_panic>
  802615:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802618:	8b 00                	mov    (%eax),%eax
  80261a:	85 c0                	test   %eax,%eax
  80261c:	74 10                	je     80262e <alloc_block_FF+0xf9>
  80261e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802621:	8b 00                	mov    (%eax),%eax
  802623:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802626:	8b 52 04             	mov    0x4(%edx),%edx
  802629:	89 50 04             	mov    %edx,0x4(%eax)
  80262c:	eb 0b                	jmp    802639 <alloc_block_FF+0x104>
  80262e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802631:	8b 40 04             	mov    0x4(%eax),%eax
  802634:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802639:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80263c:	8b 40 04             	mov    0x4(%eax),%eax
  80263f:	85 c0                	test   %eax,%eax
  802641:	74 0f                	je     802652 <alloc_block_FF+0x11d>
  802643:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802646:	8b 40 04             	mov    0x4(%eax),%eax
  802649:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80264c:	8b 12                	mov    (%edx),%edx
  80264e:	89 10                	mov    %edx,(%eax)
  802650:	eb 0a                	jmp    80265c <alloc_block_FF+0x127>
  802652:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802655:	8b 00                	mov    (%eax),%eax
  802657:	a3 48 41 80 00       	mov    %eax,0x804148
  80265c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80265f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802665:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802668:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80266f:	a1 54 41 80 00       	mov    0x804154,%eax
  802674:	48                   	dec    %eax
  802675:	a3 54 41 80 00       	mov    %eax,0x804154
			 element1->size =size;
  80267a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80267d:	8b 55 08             	mov    0x8(%ebp),%edx
  802680:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  802683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802686:	8b 50 08             	mov    0x8(%eax),%edx
  802689:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80268c:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  80268f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802692:	8b 50 08             	mov    0x8(%eax),%edx
  802695:	8b 45 08             	mov    0x8(%ebp),%eax
  802698:	01 c2                	add    %eax,%edx
  80269a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269d:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  8026a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8026a6:	2b 45 08             	sub    0x8(%ebp),%eax
  8026a9:	89 c2                	mov    %eax,%edx
  8026ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ae:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  8026b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026b4:	eb 3b                	jmp    8026f1 <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  8026b6:	a1 40 41 80 00       	mov    0x804140,%eax
  8026bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026c2:	74 07                	je     8026cb <alloc_block_FF+0x196>
  8026c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c7:	8b 00                	mov    (%eax),%eax
  8026c9:	eb 05                	jmp    8026d0 <alloc_block_FF+0x19b>
  8026cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d0:	a3 40 41 80 00       	mov    %eax,0x804140
  8026d5:	a1 40 41 80 00       	mov    0x804140,%eax
  8026da:	85 c0                	test   %eax,%eax
  8026dc:	0f 85 66 fe ff ff    	jne    802548 <alloc_block_FF+0x13>
  8026e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026e6:	0f 85 5c fe ff ff    	jne    802548 <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  8026ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026f1:	c9                   	leave  
  8026f2:	c3                   	ret    

008026f3 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8026f3:	55                   	push   %ebp
  8026f4:	89 e5                	mov    %esp,%ebp
  8026f6:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  8026f9:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  802700:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  802707:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  80270e:	a1 38 41 80 00       	mov    0x804138,%eax
  802713:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802716:	e9 cf 00 00 00       	jmp    8027ea <alloc_block_BF+0xf7>
		{
			c++;
  80271b:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  80271e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802721:	8b 40 0c             	mov    0xc(%eax),%eax
  802724:	3b 45 08             	cmp    0x8(%ebp),%eax
  802727:	0f 85 8a 00 00 00    	jne    8027b7 <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  80272d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802731:	75 17                	jne    80274a <alloc_block_BF+0x57>
  802733:	83 ec 04             	sub    $0x4,%esp
  802736:	68 0f 3f 80 00       	push   $0x803f0f
  80273b:	68 a8 00 00 00       	push   $0xa8
  802740:	68 d3 3e 80 00       	push   $0x803ed3
  802745:	e8 5d dd ff ff       	call   8004a7 <_panic>
  80274a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274d:	8b 00                	mov    (%eax),%eax
  80274f:	85 c0                	test   %eax,%eax
  802751:	74 10                	je     802763 <alloc_block_BF+0x70>
  802753:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802756:	8b 00                	mov    (%eax),%eax
  802758:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80275b:	8b 52 04             	mov    0x4(%edx),%edx
  80275e:	89 50 04             	mov    %edx,0x4(%eax)
  802761:	eb 0b                	jmp    80276e <alloc_block_BF+0x7b>
  802763:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802766:	8b 40 04             	mov    0x4(%eax),%eax
  802769:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80276e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802771:	8b 40 04             	mov    0x4(%eax),%eax
  802774:	85 c0                	test   %eax,%eax
  802776:	74 0f                	je     802787 <alloc_block_BF+0x94>
  802778:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277b:	8b 40 04             	mov    0x4(%eax),%eax
  80277e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802781:	8b 12                	mov    (%edx),%edx
  802783:	89 10                	mov    %edx,(%eax)
  802785:	eb 0a                	jmp    802791 <alloc_block_BF+0x9e>
  802787:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278a:	8b 00                	mov    (%eax),%eax
  80278c:	a3 38 41 80 00       	mov    %eax,0x804138
  802791:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802794:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80279a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027a4:	a1 44 41 80 00       	mov    0x804144,%eax
  8027a9:	48                   	dec    %eax
  8027aa:	a3 44 41 80 00       	mov    %eax,0x804144
				return block;
  8027af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b2:	e9 85 01 00 00       	jmp    80293c <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  8027b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8027bd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027c0:	76 20                	jbe    8027e2 <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  8027c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8027c8:	2b 45 08             	sub    0x8(%ebp),%eax
  8027cb:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  8027ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027d1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8027d4:	73 0c                	jae    8027e2 <alloc_block_BF+0xef>
				{
					ma=tempi;
  8027d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  8027dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027df:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8027e2:	a1 40 41 80 00       	mov    0x804140,%eax
  8027e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ee:	74 07                	je     8027f7 <alloc_block_BF+0x104>
  8027f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f3:	8b 00                	mov    (%eax),%eax
  8027f5:	eb 05                	jmp    8027fc <alloc_block_BF+0x109>
  8027f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8027fc:	a3 40 41 80 00       	mov    %eax,0x804140
  802801:	a1 40 41 80 00       	mov    0x804140,%eax
  802806:	85 c0                	test   %eax,%eax
  802808:	0f 85 0d ff ff ff    	jne    80271b <alloc_block_BF+0x28>
  80280e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802812:	0f 85 03 ff ff ff    	jne    80271b <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  802818:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  80281f:	a1 38 41 80 00       	mov    0x804138,%eax
  802824:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802827:	e9 dd 00 00 00       	jmp    802909 <alloc_block_BF+0x216>
		{
			if(x==sol)
  80282c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80282f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802832:	0f 85 c6 00 00 00    	jne    8028fe <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802838:	a1 48 41 80 00       	mov    0x804148,%eax
  80283d:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802840:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802844:	75 17                	jne    80285d <alloc_block_BF+0x16a>
  802846:	83 ec 04             	sub    $0x4,%esp
  802849:	68 0f 3f 80 00       	push   $0x803f0f
  80284e:	68 bb 00 00 00       	push   $0xbb
  802853:	68 d3 3e 80 00       	push   $0x803ed3
  802858:	e8 4a dc ff ff       	call   8004a7 <_panic>
  80285d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802860:	8b 00                	mov    (%eax),%eax
  802862:	85 c0                	test   %eax,%eax
  802864:	74 10                	je     802876 <alloc_block_BF+0x183>
  802866:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802869:	8b 00                	mov    (%eax),%eax
  80286b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80286e:	8b 52 04             	mov    0x4(%edx),%edx
  802871:	89 50 04             	mov    %edx,0x4(%eax)
  802874:	eb 0b                	jmp    802881 <alloc_block_BF+0x18e>
  802876:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802879:	8b 40 04             	mov    0x4(%eax),%eax
  80287c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802881:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802884:	8b 40 04             	mov    0x4(%eax),%eax
  802887:	85 c0                	test   %eax,%eax
  802889:	74 0f                	je     80289a <alloc_block_BF+0x1a7>
  80288b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80288e:	8b 40 04             	mov    0x4(%eax),%eax
  802891:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802894:	8b 12                	mov    (%edx),%edx
  802896:	89 10                	mov    %edx,(%eax)
  802898:	eb 0a                	jmp    8028a4 <alloc_block_BF+0x1b1>
  80289a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80289d:	8b 00                	mov    (%eax),%eax
  80289f:	a3 48 41 80 00       	mov    %eax,0x804148
  8028a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028b7:	a1 54 41 80 00       	mov    0x804154,%eax
  8028bc:	48                   	dec    %eax
  8028bd:	a3 54 41 80 00       	mov    %eax,0x804154
						 element1->size =size;
  8028c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8028c8:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  8028cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ce:	8b 50 08             	mov    0x8(%eax),%edx
  8028d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028d4:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  8028d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028da:	8b 50 08             	mov    0x8(%eax),%edx
  8028dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e0:	01 c2                	add    %eax,%edx
  8028e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e5:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  8028e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8028ee:	2b 45 08             	sub    0x8(%ebp),%eax
  8028f1:	89 c2                	mov    %eax,%edx
  8028f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f6:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  8028f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028fc:	eb 3e                	jmp    80293c <alloc_block_BF+0x249>
						 break;
			}
			x++;
  8028fe:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802901:	a1 40 41 80 00       	mov    0x804140,%eax
  802906:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802909:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80290d:	74 07                	je     802916 <alloc_block_BF+0x223>
  80290f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802912:	8b 00                	mov    (%eax),%eax
  802914:	eb 05                	jmp    80291b <alloc_block_BF+0x228>
  802916:	b8 00 00 00 00       	mov    $0x0,%eax
  80291b:	a3 40 41 80 00       	mov    %eax,0x804140
  802920:	a1 40 41 80 00       	mov    0x804140,%eax
  802925:	85 c0                	test   %eax,%eax
  802927:	0f 85 ff fe ff ff    	jne    80282c <alloc_block_BF+0x139>
  80292d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802931:	0f 85 f5 fe ff ff    	jne    80282c <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  802937:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80293c:	c9                   	leave  
  80293d:	c3                   	ret    

0080293e <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  80293e:	55                   	push   %ebp
  80293f:	89 e5                	mov    %esp,%ebp
  802941:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  802944:	a1 28 40 80 00       	mov    0x804028,%eax
  802949:	85 c0                	test   %eax,%eax
  80294b:	75 14                	jne    802961 <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  80294d:	a1 38 41 80 00       	mov    0x804138,%eax
  802952:	a3 60 41 80 00       	mov    %eax,0x804160
		hh=1;
  802957:	c7 05 28 40 80 00 01 	movl   $0x1,0x804028
  80295e:	00 00 00 
	}
	uint32 c=1;
  802961:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  802968:	a1 60 41 80 00       	mov    0x804160,%eax
  80296d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802970:	e9 b3 01 00 00       	jmp    802b28 <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  802975:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802978:	8b 40 0c             	mov    0xc(%eax),%eax
  80297b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80297e:	0f 85 a9 00 00 00    	jne    802a2d <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  802984:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802987:	8b 00                	mov    (%eax),%eax
  802989:	85 c0                	test   %eax,%eax
  80298b:	75 0c                	jne    802999 <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  80298d:	a1 38 41 80 00       	mov    0x804138,%eax
  802992:	a3 60 41 80 00       	mov    %eax,0x804160
  802997:	eb 0a                	jmp    8029a3 <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  802999:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80299c:	8b 00                	mov    (%eax),%eax
  80299e:	a3 60 41 80 00       	mov    %eax,0x804160
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  8029a3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029a7:	75 17                	jne    8029c0 <alloc_block_NF+0x82>
  8029a9:	83 ec 04             	sub    $0x4,%esp
  8029ac:	68 0f 3f 80 00       	push   $0x803f0f
  8029b1:	68 e3 00 00 00       	push   $0xe3
  8029b6:	68 d3 3e 80 00       	push   $0x803ed3
  8029bb:	e8 e7 da ff ff       	call   8004a7 <_panic>
  8029c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c3:	8b 00                	mov    (%eax),%eax
  8029c5:	85 c0                	test   %eax,%eax
  8029c7:	74 10                	je     8029d9 <alloc_block_NF+0x9b>
  8029c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029cc:	8b 00                	mov    (%eax),%eax
  8029ce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029d1:	8b 52 04             	mov    0x4(%edx),%edx
  8029d4:	89 50 04             	mov    %edx,0x4(%eax)
  8029d7:	eb 0b                	jmp    8029e4 <alloc_block_NF+0xa6>
  8029d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029dc:	8b 40 04             	mov    0x4(%eax),%eax
  8029df:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e7:	8b 40 04             	mov    0x4(%eax),%eax
  8029ea:	85 c0                	test   %eax,%eax
  8029ec:	74 0f                	je     8029fd <alloc_block_NF+0xbf>
  8029ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f1:	8b 40 04             	mov    0x4(%eax),%eax
  8029f4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029f7:	8b 12                	mov    (%edx),%edx
  8029f9:	89 10                	mov    %edx,(%eax)
  8029fb:	eb 0a                	jmp    802a07 <alloc_block_NF+0xc9>
  8029fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a00:	8b 00                	mov    (%eax),%eax
  802a02:	a3 38 41 80 00       	mov    %eax,0x804138
  802a07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a0a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a13:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a1a:	a1 44 41 80 00       	mov    0x804144,%eax
  802a1f:	48                   	dec    %eax
  802a20:	a3 44 41 80 00       	mov    %eax,0x804144
				return element;
  802a25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a28:	e9 0e 01 00 00       	jmp    802b3b <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  802a2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a30:	8b 40 0c             	mov    0xc(%eax),%eax
  802a33:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a36:	0f 86 ce 00 00 00    	jbe    802b0a <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802a3c:	a1 48 41 80 00       	mov    0x804148,%eax
  802a41:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802a44:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a48:	75 17                	jne    802a61 <alloc_block_NF+0x123>
  802a4a:	83 ec 04             	sub    $0x4,%esp
  802a4d:	68 0f 3f 80 00       	push   $0x803f0f
  802a52:	68 e9 00 00 00       	push   $0xe9
  802a57:	68 d3 3e 80 00       	push   $0x803ed3
  802a5c:	e8 46 da ff ff       	call   8004a7 <_panic>
  802a61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a64:	8b 00                	mov    (%eax),%eax
  802a66:	85 c0                	test   %eax,%eax
  802a68:	74 10                	je     802a7a <alloc_block_NF+0x13c>
  802a6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a6d:	8b 00                	mov    (%eax),%eax
  802a6f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a72:	8b 52 04             	mov    0x4(%edx),%edx
  802a75:	89 50 04             	mov    %edx,0x4(%eax)
  802a78:	eb 0b                	jmp    802a85 <alloc_block_NF+0x147>
  802a7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a7d:	8b 40 04             	mov    0x4(%eax),%eax
  802a80:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a88:	8b 40 04             	mov    0x4(%eax),%eax
  802a8b:	85 c0                	test   %eax,%eax
  802a8d:	74 0f                	je     802a9e <alloc_block_NF+0x160>
  802a8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a92:	8b 40 04             	mov    0x4(%eax),%eax
  802a95:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a98:	8b 12                	mov    (%edx),%edx
  802a9a:	89 10                	mov    %edx,(%eax)
  802a9c:	eb 0a                	jmp    802aa8 <alloc_block_NF+0x16a>
  802a9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aa1:	8b 00                	mov    (%eax),%eax
  802aa3:	a3 48 41 80 00       	mov    %eax,0x804148
  802aa8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ab1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ab4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802abb:	a1 54 41 80 00       	mov    0x804154,%eax
  802ac0:	48                   	dec    %eax
  802ac1:	a3 54 41 80 00       	mov    %eax,0x804154
				 element1->size =size;
  802ac6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac9:	8b 55 08             	mov    0x8(%ebp),%edx
  802acc:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  802acf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad2:	8b 50 08             	mov    0x8(%eax),%edx
  802ad5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad8:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  802adb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ade:	8b 50 08             	mov    0x8(%eax),%edx
  802ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae4:	01 c2                	add    %eax,%edx
  802ae6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae9:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  802aec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aef:	8b 40 0c             	mov    0xc(%eax),%eax
  802af2:	2b 45 08             	sub    0x8(%ebp),%eax
  802af5:	89 c2                	mov    %eax,%edx
  802af7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802afa:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  802afd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b00:	a3 60 41 80 00       	mov    %eax,0x804160
				 return element1;
  802b05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b08:	eb 31                	jmp    802b3b <alloc_block_NF+0x1fd>
			 }
		 c++;
  802b0a:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  802b0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b10:	8b 00                	mov    (%eax),%eax
  802b12:	85 c0                	test   %eax,%eax
  802b14:	75 0a                	jne    802b20 <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  802b16:	a1 38 41 80 00       	mov    0x804138,%eax
  802b1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802b1e:	eb 08                	jmp    802b28 <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  802b20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b23:	8b 00                	mov    (%eax),%eax
  802b25:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802b28:	a1 44 41 80 00       	mov    0x804144,%eax
  802b2d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802b30:	0f 85 3f fe ff ff    	jne    802975 <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  802b36:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b3b:	c9                   	leave  
  802b3c:	c3                   	ret    

00802b3d <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802b3d:	55                   	push   %ebp
  802b3e:	89 e5                	mov    %esp,%ebp
  802b40:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  802b43:	a1 44 41 80 00       	mov    0x804144,%eax
  802b48:	85 c0                	test   %eax,%eax
  802b4a:	75 68                	jne    802bb4 <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802b4c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b50:	75 17                	jne    802b69 <insert_sorted_with_merge_freeList+0x2c>
  802b52:	83 ec 04             	sub    $0x4,%esp
  802b55:	68 b0 3e 80 00       	push   $0x803eb0
  802b5a:	68 0e 01 00 00       	push   $0x10e
  802b5f:	68 d3 3e 80 00       	push   $0x803ed3
  802b64:	e8 3e d9 ff ff       	call   8004a7 <_panic>
  802b69:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b72:	89 10                	mov    %edx,(%eax)
  802b74:	8b 45 08             	mov    0x8(%ebp),%eax
  802b77:	8b 00                	mov    (%eax),%eax
  802b79:	85 c0                	test   %eax,%eax
  802b7b:	74 0d                	je     802b8a <insert_sorted_with_merge_freeList+0x4d>
  802b7d:	a1 38 41 80 00       	mov    0x804138,%eax
  802b82:	8b 55 08             	mov    0x8(%ebp),%edx
  802b85:	89 50 04             	mov    %edx,0x4(%eax)
  802b88:	eb 08                	jmp    802b92 <insert_sorted_with_merge_freeList+0x55>
  802b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b92:	8b 45 08             	mov    0x8(%ebp),%eax
  802b95:	a3 38 41 80 00       	mov    %eax,0x804138
  802b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ba4:	a1 44 41 80 00       	mov    0x804144,%eax
  802ba9:	40                   	inc    %eax
  802baa:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802baf:	e9 8c 06 00 00       	jmp    803240 <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  802bb4:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802bb9:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  802bbc:	a1 38 41 80 00       	mov    0x804138,%eax
  802bc1:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  802bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc7:	8b 50 08             	mov    0x8(%eax),%edx
  802bca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bcd:	8b 40 08             	mov    0x8(%eax),%eax
  802bd0:	39 c2                	cmp    %eax,%edx
  802bd2:	0f 86 14 01 00 00    	jbe    802cec <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  802bd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bdb:	8b 50 0c             	mov    0xc(%eax),%edx
  802bde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be1:	8b 40 08             	mov    0x8(%eax),%eax
  802be4:	01 c2                	add    %eax,%edx
  802be6:	8b 45 08             	mov    0x8(%ebp),%eax
  802be9:	8b 40 08             	mov    0x8(%eax),%eax
  802bec:	39 c2                	cmp    %eax,%edx
  802bee:	0f 85 90 00 00 00    	jne    802c84 <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  802bf4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf7:	8b 50 0c             	mov    0xc(%eax),%edx
  802bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfd:	8b 40 0c             	mov    0xc(%eax),%eax
  802c00:	01 c2                	add    %eax,%edx
  802c02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c05:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802c08:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802c12:	8b 45 08             	mov    0x8(%ebp),%eax
  802c15:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802c1c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c20:	75 17                	jne    802c39 <insert_sorted_with_merge_freeList+0xfc>
  802c22:	83 ec 04             	sub    $0x4,%esp
  802c25:	68 b0 3e 80 00       	push   $0x803eb0
  802c2a:	68 1b 01 00 00       	push   $0x11b
  802c2f:	68 d3 3e 80 00       	push   $0x803ed3
  802c34:	e8 6e d8 ff ff       	call   8004a7 <_panic>
  802c39:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c42:	89 10                	mov    %edx,(%eax)
  802c44:	8b 45 08             	mov    0x8(%ebp),%eax
  802c47:	8b 00                	mov    (%eax),%eax
  802c49:	85 c0                	test   %eax,%eax
  802c4b:	74 0d                	je     802c5a <insert_sorted_with_merge_freeList+0x11d>
  802c4d:	a1 48 41 80 00       	mov    0x804148,%eax
  802c52:	8b 55 08             	mov    0x8(%ebp),%edx
  802c55:	89 50 04             	mov    %edx,0x4(%eax)
  802c58:	eb 08                	jmp    802c62 <insert_sorted_with_merge_freeList+0x125>
  802c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c62:	8b 45 08             	mov    0x8(%ebp),%eax
  802c65:	a3 48 41 80 00       	mov    %eax,0x804148
  802c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c74:	a1 54 41 80 00       	mov    0x804154,%eax
  802c79:	40                   	inc    %eax
  802c7a:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802c7f:	e9 bc 05 00 00       	jmp    803240 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802c84:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c88:	75 17                	jne    802ca1 <insert_sorted_with_merge_freeList+0x164>
  802c8a:	83 ec 04             	sub    $0x4,%esp
  802c8d:	68 ec 3e 80 00       	push   $0x803eec
  802c92:	68 1f 01 00 00       	push   $0x11f
  802c97:	68 d3 3e 80 00       	push   $0x803ed3
  802c9c:	e8 06 d8 ff ff       	call   8004a7 <_panic>
  802ca1:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  802caa:	89 50 04             	mov    %edx,0x4(%eax)
  802cad:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb0:	8b 40 04             	mov    0x4(%eax),%eax
  802cb3:	85 c0                	test   %eax,%eax
  802cb5:	74 0c                	je     802cc3 <insert_sorted_with_merge_freeList+0x186>
  802cb7:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802cbc:	8b 55 08             	mov    0x8(%ebp),%edx
  802cbf:	89 10                	mov    %edx,(%eax)
  802cc1:	eb 08                	jmp    802ccb <insert_sorted_with_merge_freeList+0x18e>
  802cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc6:	a3 38 41 80 00       	mov    %eax,0x804138
  802ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cce:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cdc:	a1 44 41 80 00       	mov    0x804144,%eax
  802ce1:	40                   	inc    %eax
  802ce2:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802ce7:	e9 54 05 00 00       	jmp    803240 <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  802cec:	8b 45 08             	mov    0x8(%ebp),%eax
  802cef:	8b 50 08             	mov    0x8(%eax),%edx
  802cf2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cf5:	8b 40 08             	mov    0x8(%eax),%eax
  802cf8:	39 c2                	cmp    %eax,%edx
  802cfa:	0f 83 20 01 00 00    	jae    802e20 <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  802d00:	8b 45 08             	mov    0x8(%ebp),%eax
  802d03:	8b 50 0c             	mov    0xc(%eax),%edx
  802d06:	8b 45 08             	mov    0x8(%ebp),%eax
  802d09:	8b 40 08             	mov    0x8(%eax),%eax
  802d0c:	01 c2                	add    %eax,%edx
  802d0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d11:	8b 40 08             	mov    0x8(%eax),%eax
  802d14:	39 c2                	cmp    %eax,%edx
  802d16:	0f 85 9c 00 00 00    	jne    802db8 <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  802d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1f:	8b 50 08             	mov    0x8(%eax),%edx
  802d22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d25:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  802d28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d2b:	8b 50 0c             	mov    0xc(%eax),%edx
  802d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d31:	8b 40 0c             	mov    0xc(%eax),%eax
  802d34:	01 c2                	add    %eax,%edx
  802d36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d39:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802d46:	8b 45 08             	mov    0x8(%ebp),%eax
  802d49:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802d50:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d54:	75 17                	jne    802d6d <insert_sorted_with_merge_freeList+0x230>
  802d56:	83 ec 04             	sub    $0x4,%esp
  802d59:	68 b0 3e 80 00       	push   $0x803eb0
  802d5e:	68 2a 01 00 00       	push   $0x12a
  802d63:	68 d3 3e 80 00       	push   $0x803ed3
  802d68:	e8 3a d7 ff ff       	call   8004a7 <_panic>
  802d6d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d73:	8b 45 08             	mov    0x8(%ebp),%eax
  802d76:	89 10                	mov    %edx,(%eax)
  802d78:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7b:	8b 00                	mov    (%eax),%eax
  802d7d:	85 c0                	test   %eax,%eax
  802d7f:	74 0d                	je     802d8e <insert_sorted_with_merge_freeList+0x251>
  802d81:	a1 48 41 80 00       	mov    0x804148,%eax
  802d86:	8b 55 08             	mov    0x8(%ebp),%edx
  802d89:	89 50 04             	mov    %edx,0x4(%eax)
  802d8c:	eb 08                	jmp    802d96 <insert_sorted_with_merge_freeList+0x259>
  802d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d91:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d96:	8b 45 08             	mov    0x8(%ebp),%eax
  802d99:	a3 48 41 80 00       	mov    %eax,0x804148
  802d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802da1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802da8:	a1 54 41 80 00       	mov    0x804154,%eax
  802dad:	40                   	inc    %eax
  802dae:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802db3:	e9 88 04 00 00       	jmp    803240 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802db8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dbc:	75 17                	jne    802dd5 <insert_sorted_with_merge_freeList+0x298>
  802dbe:	83 ec 04             	sub    $0x4,%esp
  802dc1:	68 b0 3e 80 00       	push   $0x803eb0
  802dc6:	68 2e 01 00 00       	push   $0x12e
  802dcb:	68 d3 3e 80 00       	push   $0x803ed3
  802dd0:	e8 d2 d6 ff ff       	call   8004a7 <_panic>
  802dd5:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dde:	89 10                	mov    %edx,(%eax)
  802de0:	8b 45 08             	mov    0x8(%ebp),%eax
  802de3:	8b 00                	mov    (%eax),%eax
  802de5:	85 c0                	test   %eax,%eax
  802de7:	74 0d                	je     802df6 <insert_sorted_with_merge_freeList+0x2b9>
  802de9:	a1 38 41 80 00       	mov    0x804138,%eax
  802dee:	8b 55 08             	mov    0x8(%ebp),%edx
  802df1:	89 50 04             	mov    %edx,0x4(%eax)
  802df4:	eb 08                	jmp    802dfe <insert_sorted_with_merge_freeList+0x2c1>
  802df6:	8b 45 08             	mov    0x8(%ebp),%eax
  802df9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802e01:	a3 38 41 80 00       	mov    %eax,0x804138
  802e06:	8b 45 08             	mov    0x8(%ebp),%eax
  802e09:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e10:	a1 44 41 80 00       	mov    0x804144,%eax
  802e15:	40                   	inc    %eax
  802e16:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802e1b:	e9 20 04 00 00       	jmp    803240 <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  802e20:	a1 38 41 80 00       	mov    0x804138,%eax
  802e25:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e28:	e9 e2 03 00 00       	jmp    80320f <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  802e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e30:	8b 50 08             	mov    0x8(%eax),%edx
  802e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e36:	8b 40 08             	mov    0x8(%eax),%eax
  802e39:	39 c2                	cmp    %eax,%edx
  802e3b:	0f 83 c6 03 00 00    	jae    803207 <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  802e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e44:	8b 40 04             	mov    0x4(%eax),%eax
  802e47:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  802e4a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e4d:	8b 50 08             	mov    0x8(%eax),%edx
  802e50:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e53:	8b 40 0c             	mov    0xc(%eax),%eax
  802e56:	01 d0                	add    %edx,%eax
  802e58:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  802e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5e:	8b 50 0c             	mov    0xc(%eax),%edx
  802e61:	8b 45 08             	mov    0x8(%ebp),%eax
  802e64:	8b 40 08             	mov    0x8(%eax),%eax
  802e67:	01 d0                	add    %edx,%eax
  802e69:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  802e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6f:	8b 40 08             	mov    0x8(%eax),%eax
  802e72:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802e75:	74 7a                	je     802ef1 <insert_sorted_with_merge_freeList+0x3b4>
  802e77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7a:	8b 40 08             	mov    0x8(%eax),%eax
  802e7d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802e80:	74 6f                	je     802ef1 <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  802e82:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e86:	74 06                	je     802e8e <insert_sorted_with_merge_freeList+0x351>
  802e88:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e8c:	75 17                	jne    802ea5 <insert_sorted_with_merge_freeList+0x368>
  802e8e:	83 ec 04             	sub    $0x4,%esp
  802e91:	68 30 3f 80 00       	push   $0x803f30
  802e96:	68 43 01 00 00       	push   $0x143
  802e9b:	68 d3 3e 80 00       	push   $0x803ed3
  802ea0:	e8 02 d6 ff ff       	call   8004a7 <_panic>
  802ea5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea8:	8b 50 04             	mov    0x4(%eax),%edx
  802eab:	8b 45 08             	mov    0x8(%ebp),%eax
  802eae:	89 50 04             	mov    %edx,0x4(%eax)
  802eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802eb7:	89 10                	mov    %edx,(%eax)
  802eb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebc:	8b 40 04             	mov    0x4(%eax),%eax
  802ebf:	85 c0                	test   %eax,%eax
  802ec1:	74 0d                	je     802ed0 <insert_sorted_with_merge_freeList+0x393>
  802ec3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec6:	8b 40 04             	mov    0x4(%eax),%eax
  802ec9:	8b 55 08             	mov    0x8(%ebp),%edx
  802ecc:	89 10                	mov    %edx,(%eax)
  802ece:	eb 08                	jmp    802ed8 <insert_sorted_with_merge_freeList+0x39b>
  802ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed3:	a3 38 41 80 00       	mov    %eax,0x804138
  802ed8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edb:	8b 55 08             	mov    0x8(%ebp),%edx
  802ede:	89 50 04             	mov    %edx,0x4(%eax)
  802ee1:	a1 44 41 80 00       	mov    0x804144,%eax
  802ee6:	40                   	inc    %eax
  802ee7:	a3 44 41 80 00       	mov    %eax,0x804144
  802eec:	e9 14 03 00 00       	jmp    803205 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  802ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef4:	8b 40 08             	mov    0x8(%eax),%eax
  802ef7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802efa:	0f 85 a0 01 00 00    	jne    8030a0 <insert_sorted_with_merge_freeList+0x563>
  802f00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f03:	8b 40 08             	mov    0x8(%eax),%eax
  802f06:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802f09:	0f 85 91 01 00 00    	jne    8030a0 <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  802f0f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f12:	8b 50 0c             	mov    0xc(%eax),%edx
  802f15:	8b 45 08             	mov    0x8(%ebp),%eax
  802f18:	8b 48 0c             	mov    0xc(%eax),%ecx
  802f1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1e:	8b 40 0c             	mov    0xc(%eax),%eax
  802f21:	01 c8                	add    %ecx,%eax
  802f23:	01 c2                	add    %eax,%edx
  802f25:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f28:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802f35:	8b 45 08             	mov    0x8(%ebp),%eax
  802f38:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  802f3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f42:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  802f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802f53:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f57:	75 17                	jne    802f70 <insert_sorted_with_merge_freeList+0x433>
  802f59:	83 ec 04             	sub    $0x4,%esp
  802f5c:	68 b0 3e 80 00       	push   $0x803eb0
  802f61:	68 4d 01 00 00       	push   $0x14d
  802f66:	68 d3 3e 80 00       	push   $0x803ed3
  802f6b:	e8 37 d5 ff ff       	call   8004a7 <_panic>
  802f70:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f76:	8b 45 08             	mov    0x8(%ebp),%eax
  802f79:	89 10                	mov    %edx,(%eax)
  802f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7e:	8b 00                	mov    (%eax),%eax
  802f80:	85 c0                	test   %eax,%eax
  802f82:	74 0d                	je     802f91 <insert_sorted_with_merge_freeList+0x454>
  802f84:	a1 48 41 80 00       	mov    0x804148,%eax
  802f89:	8b 55 08             	mov    0x8(%ebp),%edx
  802f8c:	89 50 04             	mov    %edx,0x4(%eax)
  802f8f:	eb 08                	jmp    802f99 <insert_sorted_with_merge_freeList+0x45c>
  802f91:	8b 45 08             	mov    0x8(%ebp),%eax
  802f94:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f99:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9c:	a3 48 41 80 00       	mov    %eax,0x804148
  802fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fab:	a1 54 41 80 00       	mov    0x804154,%eax
  802fb0:	40                   	inc    %eax
  802fb1:	a3 54 41 80 00       	mov    %eax,0x804154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  802fb6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fba:	75 17                	jne    802fd3 <insert_sorted_with_merge_freeList+0x496>
  802fbc:	83 ec 04             	sub    $0x4,%esp
  802fbf:	68 0f 3f 80 00       	push   $0x803f0f
  802fc4:	68 4e 01 00 00       	push   $0x14e
  802fc9:	68 d3 3e 80 00       	push   $0x803ed3
  802fce:	e8 d4 d4 ff ff       	call   8004a7 <_panic>
  802fd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd6:	8b 00                	mov    (%eax),%eax
  802fd8:	85 c0                	test   %eax,%eax
  802fda:	74 10                	je     802fec <insert_sorted_with_merge_freeList+0x4af>
  802fdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fdf:	8b 00                	mov    (%eax),%eax
  802fe1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fe4:	8b 52 04             	mov    0x4(%edx),%edx
  802fe7:	89 50 04             	mov    %edx,0x4(%eax)
  802fea:	eb 0b                	jmp    802ff7 <insert_sorted_with_merge_freeList+0x4ba>
  802fec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fef:	8b 40 04             	mov    0x4(%eax),%eax
  802ff2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ff7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffa:	8b 40 04             	mov    0x4(%eax),%eax
  802ffd:	85 c0                	test   %eax,%eax
  802fff:	74 0f                	je     803010 <insert_sorted_with_merge_freeList+0x4d3>
  803001:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803004:	8b 40 04             	mov    0x4(%eax),%eax
  803007:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80300a:	8b 12                	mov    (%edx),%edx
  80300c:	89 10                	mov    %edx,(%eax)
  80300e:	eb 0a                	jmp    80301a <insert_sorted_with_merge_freeList+0x4dd>
  803010:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803013:	8b 00                	mov    (%eax),%eax
  803015:	a3 38 41 80 00       	mov    %eax,0x804138
  80301a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803023:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803026:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80302d:	a1 44 41 80 00       	mov    0x804144,%eax
  803032:	48                   	dec    %eax
  803033:	a3 44 41 80 00       	mov    %eax,0x804144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  803038:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80303c:	75 17                	jne    803055 <insert_sorted_with_merge_freeList+0x518>
  80303e:	83 ec 04             	sub    $0x4,%esp
  803041:	68 b0 3e 80 00       	push   $0x803eb0
  803046:	68 4f 01 00 00       	push   $0x14f
  80304b:	68 d3 3e 80 00       	push   $0x803ed3
  803050:	e8 52 d4 ff ff       	call   8004a7 <_panic>
  803055:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80305b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305e:	89 10                	mov    %edx,(%eax)
  803060:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803063:	8b 00                	mov    (%eax),%eax
  803065:	85 c0                	test   %eax,%eax
  803067:	74 0d                	je     803076 <insert_sorted_with_merge_freeList+0x539>
  803069:	a1 48 41 80 00       	mov    0x804148,%eax
  80306e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803071:	89 50 04             	mov    %edx,0x4(%eax)
  803074:	eb 08                	jmp    80307e <insert_sorted_with_merge_freeList+0x541>
  803076:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803079:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80307e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803081:	a3 48 41 80 00       	mov    %eax,0x804148
  803086:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803089:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803090:	a1 54 41 80 00       	mov    0x804154,%eax
  803095:	40                   	inc    %eax
  803096:	a3 54 41 80 00       	mov    %eax,0x804154
  80309b:	e9 65 01 00 00       	jmp    803205 <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  8030a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a3:	8b 40 08             	mov    0x8(%eax),%eax
  8030a6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8030a9:	0f 85 9f 00 00 00    	jne    80314e <insert_sorted_with_merge_freeList+0x611>
  8030af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b2:	8b 40 08             	mov    0x8(%eax),%eax
  8030b5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8030b8:	0f 84 90 00 00 00    	je     80314e <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  8030be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c1:	8b 50 0c             	mov    0xc(%eax),%edx
  8030c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8030ca:	01 c2                	add    %eax,%edx
  8030cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030cf:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  8030d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  8030dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030df:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8030e6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030ea:	75 17                	jne    803103 <insert_sorted_with_merge_freeList+0x5c6>
  8030ec:	83 ec 04             	sub    $0x4,%esp
  8030ef:	68 b0 3e 80 00       	push   $0x803eb0
  8030f4:	68 58 01 00 00       	push   $0x158
  8030f9:	68 d3 3e 80 00       	push   $0x803ed3
  8030fe:	e8 a4 d3 ff ff       	call   8004a7 <_panic>
  803103:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803109:	8b 45 08             	mov    0x8(%ebp),%eax
  80310c:	89 10                	mov    %edx,(%eax)
  80310e:	8b 45 08             	mov    0x8(%ebp),%eax
  803111:	8b 00                	mov    (%eax),%eax
  803113:	85 c0                	test   %eax,%eax
  803115:	74 0d                	je     803124 <insert_sorted_with_merge_freeList+0x5e7>
  803117:	a1 48 41 80 00       	mov    0x804148,%eax
  80311c:	8b 55 08             	mov    0x8(%ebp),%edx
  80311f:	89 50 04             	mov    %edx,0x4(%eax)
  803122:	eb 08                	jmp    80312c <insert_sorted_with_merge_freeList+0x5ef>
  803124:	8b 45 08             	mov    0x8(%ebp),%eax
  803127:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80312c:	8b 45 08             	mov    0x8(%ebp),%eax
  80312f:	a3 48 41 80 00       	mov    %eax,0x804148
  803134:	8b 45 08             	mov    0x8(%ebp),%eax
  803137:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80313e:	a1 54 41 80 00       	mov    0x804154,%eax
  803143:	40                   	inc    %eax
  803144:	a3 54 41 80 00       	mov    %eax,0x804154
  803149:	e9 b7 00 00 00       	jmp    803205 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  80314e:	8b 45 08             	mov    0x8(%ebp),%eax
  803151:	8b 40 08             	mov    0x8(%eax),%eax
  803154:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803157:	0f 84 e2 00 00 00    	je     80323f <insert_sorted_with_merge_freeList+0x702>
  80315d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803160:	8b 40 08             	mov    0x8(%eax),%eax
  803163:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803166:	0f 85 d3 00 00 00    	jne    80323f <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  80316c:	8b 45 08             	mov    0x8(%ebp),%eax
  80316f:	8b 50 08             	mov    0x8(%eax),%edx
  803172:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803175:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  803178:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317b:	8b 50 0c             	mov    0xc(%eax),%edx
  80317e:	8b 45 08             	mov    0x8(%ebp),%eax
  803181:	8b 40 0c             	mov    0xc(%eax),%eax
  803184:	01 c2                	add    %eax,%edx
  803186:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803189:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  80318c:	8b 45 08             	mov    0x8(%ebp),%eax
  80318f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  803196:	8b 45 08             	mov    0x8(%ebp),%eax
  803199:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8031a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031a4:	75 17                	jne    8031bd <insert_sorted_with_merge_freeList+0x680>
  8031a6:	83 ec 04             	sub    $0x4,%esp
  8031a9:	68 b0 3e 80 00       	push   $0x803eb0
  8031ae:	68 61 01 00 00       	push   $0x161
  8031b3:	68 d3 3e 80 00       	push   $0x803ed3
  8031b8:	e8 ea d2 ff ff       	call   8004a7 <_panic>
  8031bd:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8031c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c6:	89 10                	mov    %edx,(%eax)
  8031c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cb:	8b 00                	mov    (%eax),%eax
  8031cd:	85 c0                	test   %eax,%eax
  8031cf:	74 0d                	je     8031de <insert_sorted_with_merge_freeList+0x6a1>
  8031d1:	a1 48 41 80 00       	mov    0x804148,%eax
  8031d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8031d9:	89 50 04             	mov    %edx,0x4(%eax)
  8031dc:	eb 08                	jmp    8031e6 <insert_sorted_with_merge_freeList+0x6a9>
  8031de:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8031e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e9:	a3 48 41 80 00       	mov    %eax,0x804148
  8031ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031f8:	a1 54 41 80 00       	mov    0x804154,%eax
  8031fd:	40                   	inc    %eax
  8031fe:	a3 54 41 80 00       	mov    %eax,0x804154
								}
								break;
  803203:	eb 3a                	jmp    80323f <insert_sorted_with_merge_freeList+0x702>
  803205:	eb 38                	jmp    80323f <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  803207:	a1 40 41 80 00       	mov    0x804140,%eax
  80320c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80320f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803213:	74 07                	je     80321c <insert_sorted_with_merge_freeList+0x6df>
  803215:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803218:	8b 00                	mov    (%eax),%eax
  80321a:	eb 05                	jmp    803221 <insert_sorted_with_merge_freeList+0x6e4>
  80321c:	b8 00 00 00 00       	mov    $0x0,%eax
  803221:	a3 40 41 80 00       	mov    %eax,0x804140
  803226:	a1 40 41 80 00       	mov    0x804140,%eax
  80322b:	85 c0                	test   %eax,%eax
  80322d:	0f 85 fa fb ff ff    	jne    802e2d <insert_sorted_with_merge_freeList+0x2f0>
  803233:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803237:	0f 85 f0 fb ff ff    	jne    802e2d <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  80323d:	eb 01                	jmp    803240 <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  80323f:	90                   	nop
							}

						}
		          }
		}
}
  803240:	90                   	nop
  803241:	c9                   	leave  
  803242:	c3                   	ret    

00803243 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803243:	55                   	push   %ebp
  803244:	89 e5                	mov    %esp,%ebp
  803246:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803249:	8b 55 08             	mov    0x8(%ebp),%edx
  80324c:	89 d0                	mov    %edx,%eax
  80324e:	c1 e0 02             	shl    $0x2,%eax
  803251:	01 d0                	add    %edx,%eax
  803253:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80325a:	01 d0                	add    %edx,%eax
  80325c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803263:	01 d0                	add    %edx,%eax
  803265:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80326c:	01 d0                	add    %edx,%eax
  80326e:	c1 e0 04             	shl    $0x4,%eax
  803271:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803274:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80327b:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80327e:	83 ec 0c             	sub    $0xc,%esp
  803281:	50                   	push   %eax
  803282:	e8 9c eb ff ff       	call   801e23 <sys_get_virtual_time>
  803287:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80328a:	eb 41                	jmp    8032cd <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80328c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80328f:	83 ec 0c             	sub    $0xc,%esp
  803292:	50                   	push   %eax
  803293:	e8 8b eb ff ff       	call   801e23 <sys_get_virtual_time>
  803298:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80329b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80329e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a1:	29 c2                	sub    %eax,%edx
  8032a3:	89 d0                	mov    %edx,%eax
  8032a5:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8032a8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8032ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032ae:	89 d1                	mov    %edx,%ecx
  8032b0:	29 c1                	sub    %eax,%ecx
  8032b2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8032b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032b8:	39 c2                	cmp    %eax,%edx
  8032ba:	0f 97 c0             	seta   %al
  8032bd:	0f b6 c0             	movzbl %al,%eax
  8032c0:	29 c1                	sub    %eax,%ecx
  8032c2:	89 c8                	mov    %ecx,%eax
  8032c4:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8032c7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8032ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8032cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8032d3:	72 b7                	jb     80328c <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8032d5:	90                   	nop
  8032d6:	c9                   	leave  
  8032d7:	c3                   	ret    

008032d8 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8032d8:	55                   	push   %ebp
  8032d9:	89 e5                	mov    %esp,%ebp
  8032db:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8032de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8032e5:	eb 03                	jmp    8032ea <busy_wait+0x12>
  8032e7:	ff 45 fc             	incl   -0x4(%ebp)
  8032ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8032ed:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032f0:	72 f5                	jb     8032e7 <busy_wait+0xf>
	return i;
  8032f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8032f5:	c9                   	leave  
  8032f6:	c3                   	ret    
  8032f7:	90                   	nop

008032f8 <__udivdi3>:
  8032f8:	55                   	push   %ebp
  8032f9:	57                   	push   %edi
  8032fa:	56                   	push   %esi
  8032fb:	53                   	push   %ebx
  8032fc:	83 ec 1c             	sub    $0x1c,%esp
  8032ff:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803303:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803307:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80330b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80330f:	89 ca                	mov    %ecx,%edx
  803311:	89 f8                	mov    %edi,%eax
  803313:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803317:	85 f6                	test   %esi,%esi
  803319:	75 2d                	jne    803348 <__udivdi3+0x50>
  80331b:	39 cf                	cmp    %ecx,%edi
  80331d:	77 65                	ja     803384 <__udivdi3+0x8c>
  80331f:	89 fd                	mov    %edi,%ebp
  803321:	85 ff                	test   %edi,%edi
  803323:	75 0b                	jne    803330 <__udivdi3+0x38>
  803325:	b8 01 00 00 00       	mov    $0x1,%eax
  80332a:	31 d2                	xor    %edx,%edx
  80332c:	f7 f7                	div    %edi
  80332e:	89 c5                	mov    %eax,%ebp
  803330:	31 d2                	xor    %edx,%edx
  803332:	89 c8                	mov    %ecx,%eax
  803334:	f7 f5                	div    %ebp
  803336:	89 c1                	mov    %eax,%ecx
  803338:	89 d8                	mov    %ebx,%eax
  80333a:	f7 f5                	div    %ebp
  80333c:	89 cf                	mov    %ecx,%edi
  80333e:	89 fa                	mov    %edi,%edx
  803340:	83 c4 1c             	add    $0x1c,%esp
  803343:	5b                   	pop    %ebx
  803344:	5e                   	pop    %esi
  803345:	5f                   	pop    %edi
  803346:	5d                   	pop    %ebp
  803347:	c3                   	ret    
  803348:	39 ce                	cmp    %ecx,%esi
  80334a:	77 28                	ja     803374 <__udivdi3+0x7c>
  80334c:	0f bd fe             	bsr    %esi,%edi
  80334f:	83 f7 1f             	xor    $0x1f,%edi
  803352:	75 40                	jne    803394 <__udivdi3+0x9c>
  803354:	39 ce                	cmp    %ecx,%esi
  803356:	72 0a                	jb     803362 <__udivdi3+0x6a>
  803358:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80335c:	0f 87 9e 00 00 00    	ja     803400 <__udivdi3+0x108>
  803362:	b8 01 00 00 00       	mov    $0x1,%eax
  803367:	89 fa                	mov    %edi,%edx
  803369:	83 c4 1c             	add    $0x1c,%esp
  80336c:	5b                   	pop    %ebx
  80336d:	5e                   	pop    %esi
  80336e:	5f                   	pop    %edi
  80336f:	5d                   	pop    %ebp
  803370:	c3                   	ret    
  803371:	8d 76 00             	lea    0x0(%esi),%esi
  803374:	31 ff                	xor    %edi,%edi
  803376:	31 c0                	xor    %eax,%eax
  803378:	89 fa                	mov    %edi,%edx
  80337a:	83 c4 1c             	add    $0x1c,%esp
  80337d:	5b                   	pop    %ebx
  80337e:	5e                   	pop    %esi
  80337f:	5f                   	pop    %edi
  803380:	5d                   	pop    %ebp
  803381:	c3                   	ret    
  803382:	66 90                	xchg   %ax,%ax
  803384:	89 d8                	mov    %ebx,%eax
  803386:	f7 f7                	div    %edi
  803388:	31 ff                	xor    %edi,%edi
  80338a:	89 fa                	mov    %edi,%edx
  80338c:	83 c4 1c             	add    $0x1c,%esp
  80338f:	5b                   	pop    %ebx
  803390:	5e                   	pop    %esi
  803391:	5f                   	pop    %edi
  803392:	5d                   	pop    %ebp
  803393:	c3                   	ret    
  803394:	bd 20 00 00 00       	mov    $0x20,%ebp
  803399:	89 eb                	mov    %ebp,%ebx
  80339b:	29 fb                	sub    %edi,%ebx
  80339d:	89 f9                	mov    %edi,%ecx
  80339f:	d3 e6                	shl    %cl,%esi
  8033a1:	89 c5                	mov    %eax,%ebp
  8033a3:	88 d9                	mov    %bl,%cl
  8033a5:	d3 ed                	shr    %cl,%ebp
  8033a7:	89 e9                	mov    %ebp,%ecx
  8033a9:	09 f1                	or     %esi,%ecx
  8033ab:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8033af:	89 f9                	mov    %edi,%ecx
  8033b1:	d3 e0                	shl    %cl,%eax
  8033b3:	89 c5                	mov    %eax,%ebp
  8033b5:	89 d6                	mov    %edx,%esi
  8033b7:	88 d9                	mov    %bl,%cl
  8033b9:	d3 ee                	shr    %cl,%esi
  8033bb:	89 f9                	mov    %edi,%ecx
  8033bd:	d3 e2                	shl    %cl,%edx
  8033bf:	8b 44 24 08          	mov    0x8(%esp),%eax
  8033c3:	88 d9                	mov    %bl,%cl
  8033c5:	d3 e8                	shr    %cl,%eax
  8033c7:	09 c2                	or     %eax,%edx
  8033c9:	89 d0                	mov    %edx,%eax
  8033cb:	89 f2                	mov    %esi,%edx
  8033cd:	f7 74 24 0c          	divl   0xc(%esp)
  8033d1:	89 d6                	mov    %edx,%esi
  8033d3:	89 c3                	mov    %eax,%ebx
  8033d5:	f7 e5                	mul    %ebp
  8033d7:	39 d6                	cmp    %edx,%esi
  8033d9:	72 19                	jb     8033f4 <__udivdi3+0xfc>
  8033db:	74 0b                	je     8033e8 <__udivdi3+0xf0>
  8033dd:	89 d8                	mov    %ebx,%eax
  8033df:	31 ff                	xor    %edi,%edi
  8033e1:	e9 58 ff ff ff       	jmp    80333e <__udivdi3+0x46>
  8033e6:	66 90                	xchg   %ax,%ax
  8033e8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8033ec:	89 f9                	mov    %edi,%ecx
  8033ee:	d3 e2                	shl    %cl,%edx
  8033f0:	39 c2                	cmp    %eax,%edx
  8033f2:	73 e9                	jae    8033dd <__udivdi3+0xe5>
  8033f4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8033f7:	31 ff                	xor    %edi,%edi
  8033f9:	e9 40 ff ff ff       	jmp    80333e <__udivdi3+0x46>
  8033fe:	66 90                	xchg   %ax,%ax
  803400:	31 c0                	xor    %eax,%eax
  803402:	e9 37 ff ff ff       	jmp    80333e <__udivdi3+0x46>
  803407:	90                   	nop

00803408 <__umoddi3>:
  803408:	55                   	push   %ebp
  803409:	57                   	push   %edi
  80340a:	56                   	push   %esi
  80340b:	53                   	push   %ebx
  80340c:	83 ec 1c             	sub    $0x1c,%esp
  80340f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803413:	8b 74 24 34          	mov    0x34(%esp),%esi
  803417:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80341b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80341f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803423:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803427:	89 f3                	mov    %esi,%ebx
  803429:	89 fa                	mov    %edi,%edx
  80342b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80342f:	89 34 24             	mov    %esi,(%esp)
  803432:	85 c0                	test   %eax,%eax
  803434:	75 1a                	jne    803450 <__umoddi3+0x48>
  803436:	39 f7                	cmp    %esi,%edi
  803438:	0f 86 a2 00 00 00    	jbe    8034e0 <__umoddi3+0xd8>
  80343e:	89 c8                	mov    %ecx,%eax
  803440:	89 f2                	mov    %esi,%edx
  803442:	f7 f7                	div    %edi
  803444:	89 d0                	mov    %edx,%eax
  803446:	31 d2                	xor    %edx,%edx
  803448:	83 c4 1c             	add    $0x1c,%esp
  80344b:	5b                   	pop    %ebx
  80344c:	5e                   	pop    %esi
  80344d:	5f                   	pop    %edi
  80344e:	5d                   	pop    %ebp
  80344f:	c3                   	ret    
  803450:	39 f0                	cmp    %esi,%eax
  803452:	0f 87 ac 00 00 00    	ja     803504 <__umoddi3+0xfc>
  803458:	0f bd e8             	bsr    %eax,%ebp
  80345b:	83 f5 1f             	xor    $0x1f,%ebp
  80345e:	0f 84 ac 00 00 00    	je     803510 <__umoddi3+0x108>
  803464:	bf 20 00 00 00       	mov    $0x20,%edi
  803469:	29 ef                	sub    %ebp,%edi
  80346b:	89 fe                	mov    %edi,%esi
  80346d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803471:	89 e9                	mov    %ebp,%ecx
  803473:	d3 e0                	shl    %cl,%eax
  803475:	89 d7                	mov    %edx,%edi
  803477:	89 f1                	mov    %esi,%ecx
  803479:	d3 ef                	shr    %cl,%edi
  80347b:	09 c7                	or     %eax,%edi
  80347d:	89 e9                	mov    %ebp,%ecx
  80347f:	d3 e2                	shl    %cl,%edx
  803481:	89 14 24             	mov    %edx,(%esp)
  803484:	89 d8                	mov    %ebx,%eax
  803486:	d3 e0                	shl    %cl,%eax
  803488:	89 c2                	mov    %eax,%edx
  80348a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80348e:	d3 e0                	shl    %cl,%eax
  803490:	89 44 24 04          	mov    %eax,0x4(%esp)
  803494:	8b 44 24 08          	mov    0x8(%esp),%eax
  803498:	89 f1                	mov    %esi,%ecx
  80349a:	d3 e8                	shr    %cl,%eax
  80349c:	09 d0                	or     %edx,%eax
  80349e:	d3 eb                	shr    %cl,%ebx
  8034a0:	89 da                	mov    %ebx,%edx
  8034a2:	f7 f7                	div    %edi
  8034a4:	89 d3                	mov    %edx,%ebx
  8034a6:	f7 24 24             	mull   (%esp)
  8034a9:	89 c6                	mov    %eax,%esi
  8034ab:	89 d1                	mov    %edx,%ecx
  8034ad:	39 d3                	cmp    %edx,%ebx
  8034af:	0f 82 87 00 00 00    	jb     80353c <__umoddi3+0x134>
  8034b5:	0f 84 91 00 00 00    	je     80354c <__umoddi3+0x144>
  8034bb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8034bf:	29 f2                	sub    %esi,%edx
  8034c1:	19 cb                	sbb    %ecx,%ebx
  8034c3:	89 d8                	mov    %ebx,%eax
  8034c5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8034c9:	d3 e0                	shl    %cl,%eax
  8034cb:	89 e9                	mov    %ebp,%ecx
  8034cd:	d3 ea                	shr    %cl,%edx
  8034cf:	09 d0                	or     %edx,%eax
  8034d1:	89 e9                	mov    %ebp,%ecx
  8034d3:	d3 eb                	shr    %cl,%ebx
  8034d5:	89 da                	mov    %ebx,%edx
  8034d7:	83 c4 1c             	add    $0x1c,%esp
  8034da:	5b                   	pop    %ebx
  8034db:	5e                   	pop    %esi
  8034dc:	5f                   	pop    %edi
  8034dd:	5d                   	pop    %ebp
  8034de:	c3                   	ret    
  8034df:	90                   	nop
  8034e0:	89 fd                	mov    %edi,%ebp
  8034e2:	85 ff                	test   %edi,%edi
  8034e4:	75 0b                	jne    8034f1 <__umoddi3+0xe9>
  8034e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8034eb:	31 d2                	xor    %edx,%edx
  8034ed:	f7 f7                	div    %edi
  8034ef:	89 c5                	mov    %eax,%ebp
  8034f1:	89 f0                	mov    %esi,%eax
  8034f3:	31 d2                	xor    %edx,%edx
  8034f5:	f7 f5                	div    %ebp
  8034f7:	89 c8                	mov    %ecx,%eax
  8034f9:	f7 f5                	div    %ebp
  8034fb:	89 d0                	mov    %edx,%eax
  8034fd:	e9 44 ff ff ff       	jmp    803446 <__umoddi3+0x3e>
  803502:	66 90                	xchg   %ax,%ax
  803504:	89 c8                	mov    %ecx,%eax
  803506:	89 f2                	mov    %esi,%edx
  803508:	83 c4 1c             	add    $0x1c,%esp
  80350b:	5b                   	pop    %ebx
  80350c:	5e                   	pop    %esi
  80350d:	5f                   	pop    %edi
  80350e:	5d                   	pop    %ebp
  80350f:	c3                   	ret    
  803510:	3b 04 24             	cmp    (%esp),%eax
  803513:	72 06                	jb     80351b <__umoddi3+0x113>
  803515:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803519:	77 0f                	ja     80352a <__umoddi3+0x122>
  80351b:	89 f2                	mov    %esi,%edx
  80351d:	29 f9                	sub    %edi,%ecx
  80351f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803523:	89 14 24             	mov    %edx,(%esp)
  803526:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80352a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80352e:	8b 14 24             	mov    (%esp),%edx
  803531:	83 c4 1c             	add    $0x1c,%esp
  803534:	5b                   	pop    %ebx
  803535:	5e                   	pop    %esi
  803536:	5f                   	pop    %edi
  803537:	5d                   	pop    %ebp
  803538:	c3                   	ret    
  803539:	8d 76 00             	lea    0x0(%esi),%esi
  80353c:	2b 04 24             	sub    (%esp),%eax
  80353f:	19 fa                	sbb    %edi,%edx
  803541:	89 d1                	mov    %edx,%ecx
  803543:	89 c6                	mov    %eax,%esi
  803545:	e9 71 ff ff ff       	jmp    8034bb <__umoddi3+0xb3>
  80354a:	66 90                	xchg   %ax,%ax
  80354c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803550:	72 ea                	jb     80353c <__umoddi3+0x134>
  803552:	89 d9                	mov    %ebx,%ecx
  803554:	e9 62 ff ff ff       	jmp    8034bb <__umoddi3+0xb3>


obj/user/tst_freeRAM_2:     file format elf32-i386


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
  800031:	e8 ac 05 00 00       	call   8005e2 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
	char a;
	short b;
	int c;
};
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	81 ec b0 00 00 00    	sub    $0xb0,%esp





	int Mega = 1024*1024;
  800043:	c7 45 f4 00 00 10 00 	movl   $0x100000,-0xc(%ebp)
	int kilo = 1024;
  80004a:	c7 45 f0 00 04 00 00 	movl   $0x400,-0x10(%ebp)
	char minByte = 1<<7;
  800051:	c6 45 ef 80          	movb   $0x80,-0x11(%ebp)
	char maxByte = 0x7F;
  800055:	c6 45 ee 7f          	movb   $0x7f,-0x12(%ebp)
	short minShort = 1<<15 ;
  800059:	66 c7 45 ec 00 80    	movw   $0x8000,-0x14(%ebp)
	short maxShort = 0x7FFF;
  80005f:	66 c7 45 ea ff 7f    	movw   $0x7fff,-0x16(%ebp)
	int minInt = 1<<31 ;
  800065:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
	int maxInt = 0x7FFFFFFF;
  80006c:	c7 45 e0 ff ff ff 7f 	movl   $0x7fffffff,-0x20(%ebp)

	void* ptr_allocations[20] = {0};
  800073:	8d 95 4c ff ff ff    	lea    -0xb4(%ebp),%edx
  800079:	b9 14 00 00 00       	mov    $0x14,%ecx
  80007e:	b8 00 00 00 00       	mov    $0x0,%eax
  800083:	89 d7                	mov    %edx,%edi
  800085:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		//Load "fib" & "fos_helloWorld" programs into RAM
		cprintf("Loading Fib & fos_helloWorld programs into RAM...");
  800087:	83 ec 0c             	sub    $0xc,%esp
  80008a:	68 e0 37 80 00       	push   $0x8037e0
  80008f:	e8 3e 09 00 00       	call   8009d2 <cprintf>
  800094:	83 c4 10             	add    $0x10,%esp
		int32 envIdFib = sys_create_env("fib", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800097:	a1 20 50 80 00       	mov    0x805020,%eax
  80009c:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8000a2:	a1 20 50 80 00       	mov    0x805020,%eax
  8000a7:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000ad:	89 c1                	mov    %eax,%ecx
  8000af:	a1 20 50 80 00       	mov    0x805020,%eax
  8000b4:	8b 40 74             	mov    0x74(%eax),%eax
  8000b7:	52                   	push   %edx
  8000b8:	51                   	push   %ecx
  8000b9:	50                   	push   %eax
  8000ba:	68 12 38 80 00       	push   $0x803812
  8000bf:	e8 1c 1f 00 00       	call   801fe0 <sys_create_env>
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  8000ca:	e8 9f 1c 00 00       	call   801d6e <sys_calculate_free_frames>
  8000cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
		int32 envIdHelloWorld = sys_create_env("fos_helloWorld", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8000d2:	a1 20 50 80 00       	mov    0x805020,%eax
  8000d7:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8000dd:	a1 20 50 80 00       	mov    0x805020,%eax
  8000e2:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000e8:	89 c1                	mov    %eax,%ecx
  8000ea:	a1 20 50 80 00       	mov    0x805020,%eax
  8000ef:	8b 40 74             	mov    0x74(%eax),%eax
  8000f2:	52                   	push   %edx
  8000f3:	51                   	push   %ecx
  8000f4:	50                   	push   %eax
  8000f5:	68 16 38 80 00       	push   $0x803816
  8000fa:	e8 e1 1e 00 00       	call   801fe0 <sys_create_env>
  8000ff:	83 c4 10             	add    $0x10,%esp
  800102:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int helloWorldFrames = freeFrames - sys_calculate_free_frames() ;
  800105:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800108:	e8 61 1c 00 00       	call   801d6e <sys_calculate_free_frames>
  80010d:	29 c3                	sub    %eax,%ebx
  80010f:	89 d8                	mov    %ebx,%eax
  800111:	89 45 d0             	mov    %eax,-0x30(%ebp)
		env_sleep(2000);
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	68 d0 07 00 00       	push   $0x7d0
  80011c:	e8 99 33 00 00       	call   8034ba <env_sleep>
  800121:	83 c4 10             	add    $0x10,%esp
		cprintf("[DONE]\n\n");
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	68 25 38 80 00       	push   $0x803825
  80012c:	e8 a1 08 00 00       	call   8009d2 <cprintf>
  800131:	83 c4 10             	add    $0x10,%esp

		//Load and run "fos_add"
		cprintf("Loading fos_add program into RAM...");
  800134:	83 ec 0c             	sub    $0xc,%esp
  800137:	68 30 38 80 00       	push   $0x803830
  80013c:	e8 91 08 00 00       	call   8009d2 <cprintf>
  800141:	83 c4 10             	add    $0x10,%esp
		int32 envIdFOSAdd= sys_create_env("fos_add", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800144:	a1 20 50 80 00       	mov    0x805020,%eax
  800149:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80014f:	a1 20 50 80 00       	mov    0x805020,%eax
  800154:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80015a:	89 c1                	mov    %eax,%ecx
  80015c:	a1 20 50 80 00       	mov    0x805020,%eax
  800161:	8b 40 74             	mov    0x74(%eax),%eax
  800164:	52                   	push   %edx
  800165:	51                   	push   %ecx
  800166:	50                   	push   %eax
  800167:	68 54 38 80 00       	push   $0x803854
  80016c:	e8 6f 1e 00 00       	call   801fe0 <sys_create_env>
  800171:	83 c4 10             	add    $0x10,%esp
  800174:	89 45 cc             	mov    %eax,-0x34(%ebp)
		env_sleep(2000);
  800177:	83 ec 0c             	sub    $0xc,%esp
  80017a:	68 d0 07 00 00       	push   $0x7d0
  80017f:	e8 36 33 00 00       	call   8034ba <env_sleep>
  800184:	83 c4 10             	add    $0x10,%esp
		cprintf("[DONE]\n\n");
  800187:	83 ec 0c             	sub    $0xc,%esp
  80018a:	68 25 38 80 00       	push   $0x803825
  80018f:	e8 3e 08 00 00       	call   8009d2 <cprintf>
  800194:	83 c4 10             	add    $0x10,%esp
		cprintf("running fos_add program...\n\n");
  800197:	83 ec 0c             	sub    $0xc,%esp
  80019a:	68 5c 38 80 00       	push   $0x80385c
  80019f:	e8 2e 08 00 00       	call   8009d2 <cprintf>
  8001a4:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdFOSAdd);
  8001a7:	83 ec 0c             	sub    $0xc,%esp
  8001aa:	ff 75 cc             	pushl  -0x34(%ebp)
  8001ad:	e8 4c 1e 00 00       	call   801ffe <sys_run_env>
  8001b2:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001b5:	83 ec 0c             	sub    $0xc,%esp
  8001b8:	68 79 38 80 00       	push   $0x803879
  8001bd:	e8 10 08 00 00       	call   8009d2 <cprintf>
  8001c2:	83 c4 10             	add    $0x10,%esp
		env_sleep(5000);
  8001c5:	83 ec 0c             	sub    $0xc,%esp
  8001c8:	68 88 13 00 00       	push   $0x1388
  8001cd:	e8 e8 32 00 00       	call   8034ba <env_sleep>
  8001d2:	83 c4 10             	add    $0x10,%esp

		//Allocate 2 MB
		ptr_allocations[0] = malloc(2*Mega-kilo);
  8001d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001d8:	01 c0                	add    %eax,%eax
  8001da:	2b 45 f0             	sub    -0x10(%ebp),%eax
  8001dd:	83 ec 0c             	sub    $0xc,%esp
  8001e0:	50                   	push   %eax
  8001e1:	e8 1b 17 00 00       	call   801901 <malloc>
  8001e6:	83 c4 10             	add    $0x10,%esp
  8001e9:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
		char *byteArr = (char *) ptr_allocations[0];
  8001ef:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  8001f5:	89 45 c8             	mov    %eax,-0x38(%ebp)
		int lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  8001f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001fb:	01 c0                	add    %eax,%eax
  8001fd:	2b 45 f0             	sub    -0x10(%ebp),%eax
  800200:	48                   	dec    %eax
  800201:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		byteArr[0] = minByte ;
  800204:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800207:	8a 55 ef             	mov    -0x11(%ebp),%dl
  80020a:	88 10                	mov    %dl,(%eax)
		byteArr[lastIndexOfByte] = maxByte ;
  80020c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80020f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800212:	01 c2                	add    %eax,%edx
  800214:	8a 45 ee             	mov    -0x12(%ebp),%al
  800217:	88 02                	mov    %al,(%edx)

		//Allocate another 2 MB
		ptr_allocations[1] = malloc(2*Mega-kilo);
  800219:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80021c:	01 c0                	add    %eax,%eax
  80021e:	2b 45 f0             	sub    -0x10(%ebp),%eax
  800221:	83 ec 0c             	sub    $0xc,%esp
  800224:	50                   	push   %eax
  800225:	e8 d7 16 00 00       	call   801901 <malloc>
  80022a:	83 c4 10             	add    $0x10,%esp
  80022d:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
		short *shortArr = (short *) ptr_allocations[1];
  800233:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800239:	89 45 c0             	mov    %eax,-0x40(%ebp)
		int lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  80023c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80023f:	01 c0                	add    %eax,%eax
  800241:	2b 45 f0             	sub    -0x10(%ebp),%eax
  800244:	d1 e8                	shr    %eax
  800246:	48                   	dec    %eax
  800247:	89 45 bc             	mov    %eax,-0x44(%ebp)
		shortArr[0] = minShort;
  80024a:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80024d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800250:	66 89 02             	mov    %ax,(%edx)
		shortArr[lastIndexOfShort] = maxShort;
  800253:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800256:	01 c0                	add    %eax,%eax
  800258:	89 c2                	mov    %eax,%edx
  80025a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80025d:	01 c2                	add    %eax,%edx
  80025f:	66 8b 45 ea          	mov    -0x16(%ebp),%ax
  800263:	66 89 02             	mov    %ax,(%edx)

		//Allocate all remaining RAM (Here: it requires to free some RAM by removing exited program (fos_add))
		freeFrames = sys_calculate_free_frames() ;
  800266:	e8 03 1b 00 00       	call   801d6e <sys_calculate_free_frames>
  80026b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[2] = malloc(freeFrames*PAGE_SIZE);
  80026e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800271:	c1 e0 0c             	shl    $0xc,%eax
  800274:	83 ec 0c             	sub    $0xc,%esp
  800277:	50                   	push   %eax
  800278:	e8 84 16 00 00       	call   801901 <malloc>
  80027d:	83 c4 10             	add    $0x10,%esp
  800280:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
		int *intArr = (int *) ptr_allocations[2];
  800286:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  80028c:	89 45 b8             	mov    %eax,-0x48(%ebp)
		int lastIndexOfInt = (freeFrames*PAGE_SIZE)/sizeof(int) - 1;
  80028f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800292:	c1 e0 0c             	shl    $0xc,%eax
  800295:	c1 e8 02             	shr    $0x2,%eax
  800298:	48                   	dec    %eax
  800299:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		intArr[0] = minInt;
  80029c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80029f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002a2:	89 10                	mov    %edx,(%eax)
		intArr[lastIndexOfInt] = maxInt;
  8002a4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8002a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002ae:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8002b1:	01 c2                	add    %eax,%edx
  8002b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002b6:	89 02                	mov    %eax,(%edx)

		//Allocate 7 KB after freeing some RAM
		ptr_allocations[3] = malloc(7*kilo);
  8002b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8002bb:	89 d0                	mov    %edx,%eax
  8002bd:	01 c0                	add    %eax,%eax
  8002bf:	01 d0                	add    %edx,%eax
  8002c1:	01 c0                	add    %eax,%eax
  8002c3:	01 d0                	add    %edx,%eax
  8002c5:	83 ec 0c             	sub    $0xc,%esp
  8002c8:	50                   	push   %eax
  8002c9:	e8 33 16 00 00       	call   801901 <malloc>
  8002ce:	83 c4 10             	add    $0x10,%esp
  8002d1:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
		struct MyStruct *structArr = (struct MyStruct *) ptr_allocations[3];
  8002d7:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8002dd:	89 45 b0             	mov    %eax,-0x50(%ebp)
		int lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  8002e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8002e3:	89 d0                	mov    %edx,%eax
  8002e5:	01 c0                	add    %eax,%eax
  8002e7:	01 d0                	add    %edx,%eax
  8002e9:	01 c0                	add    %eax,%eax
  8002eb:	01 d0                	add    %edx,%eax
  8002ed:	c1 e8 03             	shr    $0x3,%eax
  8002f0:	48                   	dec    %eax
  8002f1:	89 45 ac             	mov    %eax,-0x54(%ebp)
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  8002f4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8002f7:	8a 55 ef             	mov    -0x11(%ebp),%dl
  8002fa:	88 10                	mov    %dl,(%eax)
  8002fc:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8002ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800302:	66 89 42 02          	mov    %ax,0x2(%edx)
  800306:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800309:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80030c:	89 50 04             	mov    %edx,0x4(%eax)
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  80030f:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800312:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800319:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80031c:	01 c2                	add    %eax,%edx
  80031e:	8a 45 ee             	mov    -0x12(%ebp),%al
  800321:	88 02                	mov    %al,(%edx)
  800323:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800326:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80032d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800330:	01 c2                	add    %eax,%edx
  800332:	66 8b 45 ea          	mov    -0x16(%ebp),%ax
  800336:	66 89 42 02          	mov    %ax,0x2(%edx)
  80033a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80033d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800344:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800347:	01 c2                	add    %eax,%edx
  800349:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80034c:	89 42 04             	mov    %eax,0x4(%edx)

		cprintf("running fos_helloWorld program...\n\n");
  80034f:	83 ec 0c             	sub    $0xc,%esp
  800352:	68 90 38 80 00       	push   $0x803890
  800357:	e8 76 06 00 00       	call   8009d2 <cprintf>
  80035c:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdHelloWorld);
  80035f:	83 ec 0c             	sub    $0xc,%esp
  800362:	ff 75 d4             	pushl  -0x2c(%ebp)
  800365:	e8 94 1c 00 00       	call   801ffe <sys_run_env>
  80036a:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  80036d:	83 ec 0c             	sub    $0xc,%esp
  800370:	68 79 38 80 00       	push   $0x803879
  800375:	e8 58 06 00 00       	call   8009d2 <cprintf>
  80037a:	83 c4 10             	add    $0x10,%esp
		env_sleep(5000);
  80037d:	83 ec 0c             	sub    $0xc,%esp
  800380:	68 88 13 00 00       	push   $0x1388
  800385:	e8 30 31 00 00       	call   8034ba <env_sleep>
  80038a:	83 c4 10             	add    $0x10,%esp

		//Allocate the remaining RAM + extra RAM by the size of helloWorld program (Here: it requires to free some RAM by removing exited & loaded program(s) (fos_helloWorld & fib))
		freeFrames = sys_calculate_free_frames() ;
  80038d:	e8 dc 19 00 00       	call   801d6e <sys_calculate_free_frames>
  800392:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[4] = malloc((freeFrames + helloWorldFrames)*PAGE_SIZE);
  800395:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800398:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80039b:	01 d0                	add    %edx,%eax
  80039d:	c1 e0 0c             	shl    $0xc,%eax
  8003a0:	83 ec 0c             	sub    $0xc,%esp
  8003a3:	50                   	push   %eax
  8003a4:	e8 58 15 00 00       	call   801901 <malloc>
  8003a9:	83 c4 10             	add    $0x10,%esp
  8003ac:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
		int *intArr2 = (int *) ptr_allocations[4];
  8003b2:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  8003b8:	89 45 a8             	mov    %eax,-0x58(%ebp)
		int lastIndexOfInt2 = ((freeFrames + helloWorldFrames)*PAGE_SIZE)/sizeof(int) - 1;
  8003bb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8003be:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003c1:	01 d0                	add    %edx,%eax
  8003c3:	c1 e0 0c             	shl    $0xc,%eax
  8003c6:	c1 e8 02             	shr    $0x2,%eax
  8003c9:	48                   	dec    %eax
  8003ca:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		intArr2[0] = minInt;
  8003cd:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8003d3:	89 10                	mov    %edx,(%eax)
		intArr2[lastIndexOfInt2] = maxInt;
  8003d5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003d8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003df:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003e2:	01 c2                	add    %eax,%edx
  8003e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003e7:	89 02                	mov    %eax,(%edx)

		//Allocate 8 B after freeing the RAM
		ptr_allocations[5] = malloc(8);
  8003e9:	83 ec 0c             	sub    $0xc,%esp
  8003ec:	6a 08                	push   $0x8
  8003ee:	e8 0e 15 00 00       	call   801901 <malloc>
  8003f3:	83 c4 10             	add    $0x10,%esp
  8003f6:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
		int *intArr3 = (int *) ptr_allocations[5];
  8003fc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800402:	89 45 a0             	mov    %eax,-0x60(%ebp)
		int lastIndexOfInt3 = 8/sizeof(int) - 1;
  800405:	c7 45 9c 01 00 00 00 	movl   $0x1,-0x64(%ebp)
		intArr3[0] = minInt;
  80040c:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80040f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800412:	89 10                	mov    %edx,(%eax)
		intArr3[lastIndexOfInt3] = maxInt;
  800414:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800417:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80041e:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800421:	01 c2                	add    %eax,%edx
  800423:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800426:	89 02                	mov    %eax,(%edx)

		//Check that the values are successfully stored
		if (byteArr[0] 	!= minByte 	|| byteArr[lastIndexOfByte] 	!= maxByte) panic("Wrong allocation: stored values are wrongly changed!");
  800428:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80042b:	8a 00                	mov    (%eax),%al
  80042d:	3a 45 ef             	cmp    -0x11(%ebp),%al
  800430:	75 0f                	jne    800441 <_main+0x409>
  800432:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800435:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800438:	01 d0                	add    %edx,%eax
  80043a:	8a 00                	mov    (%eax),%al
  80043c:	3a 45 ee             	cmp    -0x12(%ebp),%al
  80043f:	74 14                	je     800455 <_main+0x41d>
  800441:	83 ec 04             	sub    $0x4,%esp
  800444:	68 b4 38 80 00       	push   $0x8038b4
  800449:	6a 62                	push   $0x62
  80044b:	68 e9 38 80 00       	push   $0x8038e9
  800450:	e8 c9 02 00 00       	call   80071e <_panic>
		if (shortArr[0] != minShort || shortArr[lastIndexOfShort] 	!= maxShort) panic("Wrong allocation: stored values are wrongly changed!");
  800455:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800458:	66 8b 00             	mov    (%eax),%ax
  80045b:	66 3b 45 ec          	cmp    -0x14(%ebp),%ax
  80045f:	75 15                	jne    800476 <_main+0x43e>
  800461:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800464:	01 c0                	add    %eax,%eax
  800466:	89 c2                	mov    %eax,%edx
  800468:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80046b:	01 d0                	add    %edx,%eax
  80046d:	66 8b 00             	mov    (%eax),%ax
  800470:	66 3b 45 ea          	cmp    -0x16(%ebp),%ax
  800474:	74 14                	je     80048a <_main+0x452>
  800476:	83 ec 04             	sub    $0x4,%esp
  800479:	68 b4 38 80 00       	push   $0x8038b4
  80047e:	6a 63                	push   $0x63
  800480:	68 e9 38 80 00       	push   $0x8038e9
  800485:	e8 94 02 00 00       	call   80071e <_panic>
		if (intArr[0] 	!= minInt 	|| intArr[lastIndexOfInt] 		!= maxInt) panic("Wrong allocation: stored values are wrongly changed!");
  80048a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80048d:	8b 00                	mov    (%eax),%eax
  80048f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800492:	75 16                	jne    8004aa <_main+0x472>
  800494:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800497:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80049e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8004a1:	01 d0                	add    %edx,%eax
  8004a3:	8b 00                	mov    (%eax),%eax
  8004a5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004a8:	74 14                	je     8004be <_main+0x486>
  8004aa:	83 ec 04             	sub    $0x4,%esp
  8004ad:	68 b4 38 80 00       	push   $0x8038b4
  8004b2:	6a 64                	push   $0x64
  8004b4:	68 e9 38 80 00       	push   $0x8038e9
  8004b9:	e8 60 02 00 00       	call   80071e <_panic>
		if (intArr2[0] 	!= minInt 	|| intArr2[lastIndexOfInt2] 	!= maxInt) panic("Wrong allocation: stored values are wrongly changed!");
  8004be:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8004c1:	8b 00                	mov    (%eax),%eax
  8004c3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004c6:	75 16                	jne    8004de <_main+0x4a6>
  8004c8:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8004cb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004d2:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8004d5:	01 d0                	add    %edx,%eax
  8004d7:	8b 00                	mov    (%eax),%eax
  8004d9:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004dc:	74 14                	je     8004f2 <_main+0x4ba>
  8004de:	83 ec 04             	sub    $0x4,%esp
  8004e1:	68 b4 38 80 00       	push   $0x8038b4
  8004e6:	6a 65                	push   $0x65
  8004e8:	68 e9 38 80 00       	push   $0x8038e9
  8004ed:	e8 2c 02 00 00       	call   80071e <_panic>
		if (intArr3[0] 	!= minInt 	|| intArr3[lastIndexOfInt3] 	!= maxInt) panic("Wrong allocation: stored values are wrongly changed!");
  8004f2:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8004f5:	8b 00                	mov    (%eax),%eax
  8004f7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004fa:	75 16                	jne    800512 <_main+0x4da>
  8004fc:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8004ff:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800506:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800509:	01 d0                	add    %edx,%eax
  80050b:	8b 00                	mov    (%eax),%eax
  80050d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800510:	74 14                	je     800526 <_main+0x4ee>
  800512:	83 ec 04             	sub    $0x4,%esp
  800515:	68 b4 38 80 00       	push   $0x8038b4
  80051a:	6a 66                	push   $0x66
  80051c:	68 e9 38 80 00       	push   $0x8038e9
  800521:	e8 f8 01 00 00       	call   80071e <_panic>

		if (structArr[0].a != minByte 	|| structArr[lastIndexOfStruct].a != maxByte) 	panic("Wrong allocation: stored values are wrongly changed!");
  800526:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800529:	8a 00                	mov    (%eax),%al
  80052b:	3a 45 ef             	cmp    -0x11(%ebp),%al
  80052e:	75 16                	jne    800546 <_main+0x50e>
  800530:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800533:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80053a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80053d:	01 d0                	add    %edx,%eax
  80053f:	8a 00                	mov    (%eax),%al
  800541:	3a 45 ee             	cmp    -0x12(%ebp),%al
  800544:	74 14                	je     80055a <_main+0x522>
  800546:	83 ec 04             	sub    $0x4,%esp
  800549:	68 b4 38 80 00       	push   $0x8038b4
  80054e:	6a 68                	push   $0x68
  800550:	68 e9 38 80 00       	push   $0x8038e9
  800555:	e8 c4 01 00 00       	call   80071e <_panic>
		if (structArr[0].b != minShort 	|| structArr[lastIndexOfStruct].b != maxShort) 	panic("Wrong allocation: stored values are wrongly changed!");
  80055a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80055d:	66 8b 40 02          	mov    0x2(%eax),%ax
  800561:	66 3b 45 ec          	cmp    -0x14(%ebp),%ax
  800565:	75 19                	jne    800580 <_main+0x548>
  800567:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80056a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800571:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800574:	01 d0                	add    %edx,%eax
  800576:	66 8b 40 02          	mov    0x2(%eax),%ax
  80057a:	66 3b 45 ea          	cmp    -0x16(%ebp),%ax
  80057e:	74 14                	je     800594 <_main+0x55c>
  800580:	83 ec 04             	sub    $0x4,%esp
  800583:	68 b4 38 80 00       	push   $0x8038b4
  800588:	6a 69                	push   $0x69
  80058a:	68 e9 38 80 00       	push   $0x8038e9
  80058f:	e8 8a 01 00 00       	call   80071e <_panic>
		if (structArr[0].c != minInt 	|| structArr[lastIndexOfStruct].c != maxInt) 	panic("Wrong allocation: stored values are wrongly changed!");
  800594:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800597:	8b 40 04             	mov    0x4(%eax),%eax
  80059a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80059d:	75 17                	jne    8005b6 <_main+0x57e>
  80059f:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8005a2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8005a9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8005ac:	01 d0                	add    %edx,%eax
  8005ae:	8b 40 04             	mov    0x4(%eax),%eax
  8005b1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005b4:	74 14                	je     8005ca <_main+0x592>
  8005b6:	83 ec 04             	sub    $0x4,%esp
  8005b9:	68 b4 38 80 00       	push   $0x8038b4
  8005be:	6a 6a                	push   $0x6a
  8005c0:	68 e9 38 80 00       	push   $0x8038e9
  8005c5:	e8 54 01 00 00       	call   80071e <_panic>


	}

	cprintf("Congratulations!! test freeRAM (1) completed successfully.\n");
  8005ca:	83 ec 0c             	sub    $0xc,%esp
  8005cd:	68 00 39 80 00       	push   $0x803900
  8005d2:	e8 fb 03 00 00       	call   8009d2 <cprintf>
  8005d7:	83 c4 10             	add    $0x10,%esp

	return;
  8005da:	90                   	nop
}
  8005db:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8005de:	5b                   	pop    %ebx
  8005df:	5f                   	pop    %edi
  8005e0:	5d                   	pop    %ebp
  8005e1:	c3                   	ret    

008005e2 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8005e2:	55                   	push   %ebp
  8005e3:	89 e5                	mov    %esp,%ebp
  8005e5:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8005e8:	e8 61 1a 00 00       	call   80204e <sys_getenvindex>
  8005ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8005f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005f3:	89 d0                	mov    %edx,%eax
  8005f5:	c1 e0 03             	shl    $0x3,%eax
  8005f8:	01 d0                	add    %edx,%eax
  8005fa:	01 c0                	add    %eax,%eax
  8005fc:	01 d0                	add    %edx,%eax
  8005fe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800605:	01 d0                	add    %edx,%eax
  800607:	c1 e0 04             	shl    $0x4,%eax
  80060a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80060f:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800614:	a1 20 50 80 00       	mov    0x805020,%eax
  800619:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80061f:	84 c0                	test   %al,%al
  800621:	74 0f                	je     800632 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800623:	a1 20 50 80 00       	mov    0x805020,%eax
  800628:	05 5c 05 00 00       	add    $0x55c,%eax
  80062d:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800632:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800636:	7e 0a                	jle    800642 <libmain+0x60>
		binaryname = argv[0];
  800638:	8b 45 0c             	mov    0xc(%ebp),%eax
  80063b:	8b 00                	mov    (%eax),%eax
  80063d:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800642:	83 ec 08             	sub    $0x8,%esp
  800645:	ff 75 0c             	pushl  0xc(%ebp)
  800648:	ff 75 08             	pushl  0x8(%ebp)
  80064b:	e8 e8 f9 ff ff       	call   800038 <_main>
  800650:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800653:	e8 03 18 00 00       	call   801e5b <sys_disable_interrupt>
	cprintf("**************************************\n");
  800658:	83 ec 0c             	sub    $0xc,%esp
  80065b:	68 54 39 80 00       	push   $0x803954
  800660:	e8 6d 03 00 00       	call   8009d2 <cprintf>
  800665:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800668:	a1 20 50 80 00       	mov    0x805020,%eax
  80066d:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800673:	a1 20 50 80 00       	mov    0x805020,%eax
  800678:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80067e:	83 ec 04             	sub    $0x4,%esp
  800681:	52                   	push   %edx
  800682:	50                   	push   %eax
  800683:	68 7c 39 80 00       	push   $0x80397c
  800688:	e8 45 03 00 00       	call   8009d2 <cprintf>
  80068d:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800690:	a1 20 50 80 00       	mov    0x805020,%eax
  800695:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80069b:	a1 20 50 80 00       	mov    0x805020,%eax
  8006a0:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8006a6:	a1 20 50 80 00       	mov    0x805020,%eax
  8006ab:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8006b1:	51                   	push   %ecx
  8006b2:	52                   	push   %edx
  8006b3:	50                   	push   %eax
  8006b4:	68 a4 39 80 00       	push   $0x8039a4
  8006b9:	e8 14 03 00 00       	call   8009d2 <cprintf>
  8006be:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006c1:	a1 20 50 80 00       	mov    0x805020,%eax
  8006c6:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8006cc:	83 ec 08             	sub    $0x8,%esp
  8006cf:	50                   	push   %eax
  8006d0:	68 fc 39 80 00       	push   $0x8039fc
  8006d5:	e8 f8 02 00 00       	call   8009d2 <cprintf>
  8006da:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8006dd:	83 ec 0c             	sub    $0xc,%esp
  8006e0:	68 54 39 80 00       	push   $0x803954
  8006e5:	e8 e8 02 00 00       	call   8009d2 <cprintf>
  8006ea:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8006ed:	e8 83 17 00 00       	call   801e75 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8006f2:	e8 19 00 00 00       	call   800710 <exit>
}
  8006f7:	90                   	nop
  8006f8:	c9                   	leave  
  8006f9:	c3                   	ret    

008006fa <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8006fa:	55                   	push   %ebp
  8006fb:	89 e5                	mov    %esp,%ebp
  8006fd:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800700:	83 ec 0c             	sub    $0xc,%esp
  800703:	6a 00                	push   $0x0
  800705:	e8 10 19 00 00       	call   80201a <sys_destroy_env>
  80070a:	83 c4 10             	add    $0x10,%esp
}
  80070d:	90                   	nop
  80070e:	c9                   	leave  
  80070f:	c3                   	ret    

00800710 <exit>:

void
exit(void)
{
  800710:	55                   	push   %ebp
  800711:	89 e5                	mov    %esp,%ebp
  800713:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800716:	e8 65 19 00 00       	call   802080 <sys_exit_env>
}
  80071b:	90                   	nop
  80071c:	c9                   	leave  
  80071d:	c3                   	ret    

0080071e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80071e:	55                   	push   %ebp
  80071f:	89 e5                	mov    %esp,%ebp
  800721:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800724:	8d 45 10             	lea    0x10(%ebp),%eax
  800727:	83 c0 04             	add    $0x4,%eax
  80072a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80072d:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800732:	85 c0                	test   %eax,%eax
  800734:	74 16                	je     80074c <_panic+0x2e>
		cprintf("%s: ", argv0);
  800736:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80073b:	83 ec 08             	sub    $0x8,%esp
  80073e:	50                   	push   %eax
  80073f:	68 10 3a 80 00       	push   $0x803a10
  800744:	e8 89 02 00 00       	call   8009d2 <cprintf>
  800749:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80074c:	a1 00 50 80 00       	mov    0x805000,%eax
  800751:	ff 75 0c             	pushl  0xc(%ebp)
  800754:	ff 75 08             	pushl  0x8(%ebp)
  800757:	50                   	push   %eax
  800758:	68 15 3a 80 00       	push   $0x803a15
  80075d:	e8 70 02 00 00       	call   8009d2 <cprintf>
  800762:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800765:	8b 45 10             	mov    0x10(%ebp),%eax
  800768:	83 ec 08             	sub    $0x8,%esp
  80076b:	ff 75 f4             	pushl  -0xc(%ebp)
  80076e:	50                   	push   %eax
  80076f:	e8 f3 01 00 00       	call   800967 <vcprintf>
  800774:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800777:	83 ec 08             	sub    $0x8,%esp
  80077a:	6a 00                	push   $0x0
  80077c:	68 31 3a 80 00       	push   $0x803a31
  800781:	e8 e1 01 00 00       	call   800967 <vcprintf>
  800786:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800789:	e8 82 ff ff ff       	call   800710 <exit>

	// should not return here
	while (1) ;
  80078e:	eb fe                	jmp    80078e <_panic+0x70>

00800790 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800790:	55                   	push   %ebp
  800791:	89 e5                	mov    %esp,%ebp
  800793:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800796:	a1 20 50 80 00       	mov    0x805020,%eax
  80079b:	8b 50 74             	mov    0x74(%eax),%edx
  80079e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007a1:	39 c2                	cmp    %eax,%edx
  8007a3:	74 14                	je     8007b9 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8007a5:	83 ec 04             	sub    $0x4,%esp
  8007a8:	68 34 3a 80 00       	push   $0x803a34
  8007ad:	6a 26                	push   $0x26
  8007af:	68 80 3a 80 00       	push   $0x803a80
  8007b4:	e8 65 ff ff ff       	call   80071e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8007b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8007c0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8007c7:	e9 c2 00 00 00       	jmp    80088e <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8007cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d9:	01 d0                	add    %edx,%eax
  8007db:	8b 00                	mov    (%eax),%eax
  8007dd:	85 c0                	test   %eax,%eax
  8007df:	75 08                	jne    8007e9 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8007e1:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8007e4:	e9 a2 00 00 00       	jmp    80088b <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8007e9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007f0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8007f7:	eb 69                	jmp    800862 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8007f9:	a1 20 50 80 00       	mov    0x805020,%eax
  8007fe:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800804:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800807:	89 d0                	mov    %edx,%eax
  800809:	01 c0                	add    %eax,%eax
  80080b:	01 d0                	add    %edx,%eax
  80080d:	c1 e0 03             	shl    $0x3,%eax
  800810:	01 c8                	add    %ecx,%eax
  800812:	8a 40 04             	mov    0x4(%eax),%al
  800815:	84 c0                	test   %al,%al
  800817:	75 46                	jne    80085f <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800819:	a1 20 50 80 00       	mov    0x805020,%eax
  80081e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800824:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800827:	89 d0                	mov    %edx,%eax
  800829:	01 c0                	add    %eax,%eax
  80082b:	01 d0                	add    %edx,%eax
  80082d:	c1 e0 03             	shl    $0x3,%eax
  800830:	01 c8                	add    %ecx,%eax
  800832:	8b 00                	mov    (%eax),%eax
  800834:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800837:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80083a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80083f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800841:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800844:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80084b:	8b 45 08             	mov    0x8(%ebp),%eax
  80084e:	01 c8                	add    %ecx,%eax
  800850:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800852:	39 c2                	cmp    %eax,%edx
  800854:	75 09                	jne    80085f <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800856:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80085d:	eb 12                	jmp    800871 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80085f:	ff 45 e8             	incl   -0x18(%ebp)
  800862:	a1 20 50 80 00       	mov    0x805020,%eax
  800867:	8b 50 74             	mov    0x74(%eax),%edx
  80086a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80086d:	39 c2                	cmp    %eax,%edx
  80086f:	77 88                	ja     8007f9 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800871:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800875:	75 14                	jne    80088b <CheckWSWithoutLastIndex+0xfb>
			panic(
  800877:	83 ec 04             	sub    $0x4,%esp
  80087a:	68 8c 3a 80 00       	push   $0x803a8c
  80087f:	6a 3a                	push   $0x3a
  800881:	68 80 3a 80 00       	push   $0x803a80
  800886:	e8 93 fe ff ff       	call   80071e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80088b:	ff 45 f0             	incl   -0x10(%ebp)
  80088e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800891:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800894:	0f 8c 32 ff ff ff    	jl     8007cc <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80089a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008a1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8008a8:	eb 26                	jmp    8008d0 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8008aa:	a1 20 50 80 00       	mov    0x805020,%eax
  8008af:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8008b5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008b8:	89 d0                	mov    %edx,%eax
  8008ba:	01 c0                	add    %eax,%eax
  8008bc:	01 d0                	add    %edx,%eax
  8008be:	c1 e0 03             	shl    $0x3,%eax
  8008c1:	01 c8                	add    %ecx,%eax
  8008c3:	8a 40 04             	mov    0x4(%eax),%al
  8008c6:	3c 01                	cmp    $0x1,%al
  8008c8:	75 03                	jne    8008cd <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8008ca:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008cd:	ff 45 e0             	incl   -0x20(%ebp)
  8008d0:	a1 20 50 80 00       	mov    0x805020,%eax
  8008d5:	8b 50 74             	mov    0x74(%eax),%edx
  8008d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008db:	39 c2                	cmp    %eax,%edx
  8008dd:	77 cb                	ja     8008aa <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8008df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008e2:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8008e5:	74 14                	je     8008fb <CheckWSWithoutLastIndex+0x16b>
		panic(
  8008e7:	83 ec 04             	sub    $0x4,%esp
  8008ea:	68 e0 3a 80 00       	push   $0x803ae0
  8008ef:	6a 44                	push   $0x44
  8008f1:	68 80 3a 80 00       	push   $0x803a80
  8008f6:	e8 23 fe ff ff       	call   80071e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8008fb:	90                   	nop
  8008fc:	c9                   	leave  
  8008fd:	c3                   	ret    

008008fe <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8008fe:	55                   	push   %ebp
  8008ff:	89 e5                	mov    %esp,%ebp
  800901:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800904:	8b 45 0c             	mov    0xc(%ebp),%eax
  800907:	8b 00                	mov    (%eax),%eax
  800909:	8d 48 01             	lea    0x1(%eax),%ecx
  80090c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80090f:	89 0a                	mov    %ecx,(%edx)
  800911:	8b 55 08             	mov    0x8(%ebp),%edx
  800914:	88 d1                	mov    %dl,%cl
  800916:	8b 55 0c             	mov    0xc(%ebp),%edx
  800919:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80091d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800920:	8b 00                	mov    (%eax),%eax
  800922:	3d ff 00 00 00       	cmp    $0xff,%eax
  800927:	75 2c                	jne    800955 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800929:	a0 24 50 80 00       	mov    0x805024,%al
  80092e:	0f b6 c0             	movzbl %al,%eax
  800931:	8b 55 0c             	mov    0xc(%ebp),%edx
  800934:	8b 12                	mov    (%edx),%edx
  800936:	89 d1                	mov    %edx,%ecx
  800938:	8b 55 0c             	mov    0xc(%ebp),%edx
  80093b:	83 c2 08             	add    $0x8,%edx
  80093e:	83 ec 04             	sub    $0x4,%esp
  800941:	50                   	push   %eax
  800942:	51                   	push   %ecx
  800943:	52                   	push   %edx
  800944:	e8 64 13 00 00       	call   801cad <sys_cputs>
  800949:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80094c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800955:	8b 45 0c             	mov    0xc(%ebp),%eax
  800958:	8b 40 04             	mov    0x4(%eax),%eax
  80095b:	8d 50 01             	lea    0x1(%eax),%edx
  80095e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800961:	89 50 04             	mov    %edx,0x4(%eax)
}
  800964:	90                   	nop
  800965:	c9                   	leave  
  800966:	c3                   	ret    

00800967 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800967:	55                   	push   %ebp
  800968:	89 e5                	mov    %esp,%ebp
  80096a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800970:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800977:	00 00 00 
	b.cnt = 0;
  80097a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800981:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800984:	ff 75 0c             	pushl  0xc(%ebp)
  800987:	ff 75 08             	pushl  0x8(%ebp)
  80098a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800990:	50                   	push   %eax
  800991:	68 fe 08 80 00       	push   $0x8008fe
  800996:	e8 11 02 00 00       	call   800bac <vprintfmt>
  80099b:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80099e:	a0 24 50 80 00       	mov    0x805024,%al
  8009a3:	0f b6 c0             	movzbl %al,%eax
  8009a6:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8009ac:	83 ec 04             	sub    $0x4,%esp
  8009af:	50                   	push   %eax
  8009b0:	52                   	push   %edx
  8009b1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009b7:	83 c0 08             	add    $0x8,%eax
  8009ba:	50                   	push   %eax
  8009bb:	e8 ed 12 00 00       	call   801cad <sys_cputs>
  8009c0:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8009c3:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  8009ca:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8009d0:	c9                   	leave  
  8009d1:	c3                   	ret    

008009d2 <cprintf>:

int cprintf(const char *fmt, ...) {
  8009d2:	55                   	push   %ebp
  8009d3:	89 e5                	mov    %esp,%ebp
  8009d5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8009d8:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  8009df:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e8:	83 ec 08             	sub    $0x8,%esp
  8009eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8009ee:	50                   	push   %eax
  8009ef:	e8 73 ff ff ff       	call   800967 <vcprintf>
  8009f4:	83 c4 10             	add    $0x10,%esp
  8009f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8009fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009fd:	c9                   	leave  
  8009fe:	c3                   	ret    

008009ff <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8009ff:	55                   	push   %ebp
  800a00:	89 e5                	mov    %esp,%ebp
  800a02:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a05:	e8 51 14 00 00       	call   801e5b <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a0a:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a10:	8b 45 08             	mov    0x8(%ebp),%eax
  800a13:	83 ec 08             	sub    $0x8,%esp
  800a16:	ff 75 f4             	pushl  -0xc(%ebp)
  800a19:	50                   	push   %eax
  800a1a:	e8 48 ff ff ff       	call   800967 <vcprintf>
  800a1f:	83 c4 10             	add    $0x10,%esp
  800a22:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a25:	e8 4b 14 00 00       	call   801e75 <sys_enable_interrupt>
	return cnt;
  800a2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a2d:	c9                   	leave  
  800a2e:	c3                   	ret    

00800a2f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a2f:	55                   	push   %ebp
  800a30:	89 e5                	mov    %esp,%ebp
  800a32:	53                   	push   %ebx
  800a33:	83 ec 14             	sub    $0x14,%esp
  800a36:	8b 45 10             	mov    0x10(%ebp),%eax
  800a39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a3c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a42:	8b 45 18             	mov    0x18(%ebp),%eax
  800a45:	ba 00 00 00 00       	mov    $0x0,%edx
  800a4a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a4d:	77 55                	ja     800aa4 <printnum+0x75>
  800a4f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a52:	72 05                	jb     800a59 <printnum+0x2a>
  800a54:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a57:	77 4b                	ja     800aa4 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a59:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a5c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a5f:	8b 45 18             	mov    0x18(%ebp),%eax
  800a62:	ba 00 00 00 00       	mov    $0x0,%edx
  800a67:	52                   	push   %edx
  800a68:	50                   	push   %eax
  800a69:	ff 75 f4             	pushl  -0xc(%ebp)
  800a6c:	ff 75 f0             	pushl  -0x10(%ebp)
  800a6f:	e8 fc 2a 00 00       	call   803570 <__udivdi3>
  800a74:	83 c4 10             	add    $0x10,%esp
  800a77:	83 ec 04             	sub    $0x4,%esp
  800a7a:	ff 75 20             	pushl  0x20(%ebp)
  800a7d:	53                   	push   %ebx
  800a7e:	ff 75 18             	pushl  0x18(%ebp)
  800a81:	52                   	push   %edx
  800a82:	50                   	push   %eax
  800a83:	ff 75 0c             	pushl  0xc(%ebp)
  800a86:	ff 75 08             	pushl  0x8(%ebp)
  800a89:	e8 a1 ff ff ff       	call   800a2f <printnum>
  800a8e:	83 c4 20             	add    $0x20,%esp
  800a91:	eb 1a                	jmp    800aad <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a93:	83 ec 08             	sub    $0x8,%esp
  800a96:	ff 75 0c             	pushl  0xc(%ebp)
  800a99:	ff 75 20             	pushl  0x20(%ebp)
  800a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9f:	ff d0                	call   *%eax
  800aa1:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800aa4:	ff 4d 1c             	decl   0x1c(%ebp)
  800aa7:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800aab:	7f e6                	jg     800a93 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800aad:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800ab0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ab5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ab8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800abb:	53                   	push   %ebx
  800abc:	51                   	push   %ecx
  800abd:	52                   	push   %edx
  800abe:	50                   	push   %eax
  800abf:	e8 bc 2b 00 00       	call   803680 <__umoddi3>
  800ac4:	83 c4 10             	add    $0x10,%esp
  800ac7:	05 54 3d 80 00       	add    $0x803d54,%eax
  800acc:	8a 00                	mov    (%eax),%al
  800ace:	0f be c0             	movsbl %al,%eax
  800ad1:	83 ec 08             	sub    $0x8,%esp
  800ad4:	ff 75 0c             	pushl  0xc(%ebp)
  800ad7:	50                   	push   %eax
  800ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  800adb:	ff d0                	call   *%eax
  800add:	83 c4 10             	add    $0x10,%esp
}
  800ae0:	90                   	nop
  800ae1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ae4:	c9                   	leave  
  800ae5:	c3                   	ret    

00800ae6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800ae6:	55                   	push   %ebp
  800ae7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ae9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800aed:	7e 1c                	jle    800b0b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800aef:	8b 45 08             	mov    0x8(%ebp),%eax
  800af2:	8b 00                	mov    (%eax),%eax
  800af4:	8d 50 08             	lea    0x8(%eax),%edx
  800af7:	8b 45 08             	mov    0x8(%ebp),%eax
  800afa:	89 10                	mov    %edx,(%eax)
  800afc:	8b 45 08             	mov    0x8(%ebp),%eax
  800aff:	8b 00                	mov    (%eax),%eax
  800b01:	83 e8 08             	sub    $0x8,%eax
  800b04:	8b 50 04             	mov    0x4(%eax),%edx
  800b07:	8b 00                	mov    (%eax),%eax
  800b09:	eb 40                	jmp    800b4b <getuint+0x65>
	else if (lflag)
  800b0b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b0f:	74 1e                	je     800b2f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b11:	8b 45 08             	mov    0x8(%ebp),%eax
  800b14:	8b 00                	mov    (%eax),%eax
  800b16:	8d 50 04             	lea    0x4(%eax),%edx
  800b19:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1c:	89 10                	mov    %edx,(%eax)
  800b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b21:	8b 00                	mov    (%eax),%eax
  800b23:	83 e8 04             	sub    $0x4,%eax
  800b26:	8b 00                	mov    (%eax),%eax
  800b28:	ba 00 00 00 00       	mov    $0x0,%edx
  800b2d:	eb 1c                	jmp    800b4b <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b32:	8b 00                	mov    (%eax),%eax
  800b34:	8d 50 04             	lea    0x4(%eax),%edx
  800b37:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3a:	89 10                	mov    %edx,(%eax)
  800b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3f:	8b 00                	mov    (%eax),%eax
  800b41:	83 e8 04             	sub    $0x4,%eax
  800b44:	8b 00                	mov    (%eax),%eax
  800b46:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b4b:	5d                   	pop    %ebp
  800b4c:	c3                   	ret    

00800b4d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b4d:	55                   	push   %ebp
  800b4e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b50:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b54:	7e 1c                	jle    800b72 <getint+0x25>
		return va_arg(*ap, long long);
  800b56:	8b 45 08             	mov    0x8(%ebp),%eax
  800b59:	8b 00                	mov    (%eax),%eax
  800b5b:	8d 50 08             	lea    0x8(%eax),%edx
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	89 10                	mov    %edx,(%eax)
  800b63:	8b 45 08             	mov    0x8(%ebp),%eax
  800b66:	8b 00                	mov    (%eax),%eax
  800b68:	83 e8 08             	sub    $0x8,%eax
  800b6b:	8b 50 04             	mov    0x4(%eax),%edx
  800b6e:	8b 00                	mov    (%eax),%eax
  800b70:	eb 38                	jmp    800baa <getint+0x5d>
	else if (lflag)
  800b72:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b76:	74 1a                	je     800b92 <getint+0x45>
		return va_arg(*ap, long);
  800b78:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7b:	8b 00                	mov    (%eax),%eax
  800b7d:	8d 50 04             	lea    0x4(%eax),%edx
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	89 10                	mov    %edx,(%eax)
  800b85:	8b 45 08             	mov    0x8(%ebp),%eax
  800b88:	8b 00                	mov    (%eax),%eax
  800b8a:	83 e8 04             	sub    $0x4,%eax
  800b8d:	8b 00                	mov    (%eax),%eax
  800b8f:	99                   	cltd   
  800b90:	eb 18                	jmp    800baa <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b92:	8b 45 08             	mov    0x8(%ebp),%eax
  800b95:	8b 00                	mov    (%eax),%eax
  800b97:	8d 50 04             	lea    0x4(%eax),%edx
  800b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9d:	89 10                	mov    %edx,(%eax)
  800b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba2:	8b 00                	mov    (%eax),%eax
  800ba4:	83 e8 04             	sub    $0x4,%eax
  800ba7:	8b 00                	mov    (%eax),%eax
  800ba9:	99                   	cltd   
}
  800baa:	5d                   	pop    %ebp
  800bab:	c3                   	ret    

00800bac <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800bac:	55                   	push   %ebp
  800bad:	89 e5                	mov    %esp,%ebp
  800baf:	56                   	push   %esi
  800bb0:	53                   	push   %ebx
  800bb1:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bb4:	eb 17                	jmp    800bcd <vprintfmt+0x21>
			if (ch == '\0')
  800bb6:	85 db                	test   %ebx,%ebx
  800bb8:	0f 84 af 03 00 00    	je     800f6d <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800bbe:	83 ec 08             	sub    $0x8,%esp
  800bc1:	ff 75 0c             	pushl  0xc(%ebp)
  800bc4:	53                   	push   %ebx
  800bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc8:	ff d0                	call   *%eax
  800bca:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bcd:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd0:	8d 50 01             	lea    0x1(%eax),%edx
  800bd3:	89 55 10             	mov    %edx,0x10(%ebp)
  800bd6:	8a 00                	mov    (%eax),%al
  800bd8:	0f b6 d8             	movzbl %al,%ebx
  800bdb:	83 fb 25             	cmp    $0x25,%ebx
  800bde:	75 d6                	jne    800bb6 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800be0:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800be4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800beb:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800bf2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800bf9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c00:	8b 45 10             	mov    0x10(%ebp),%eax
  800c03:	8d 50 01             	lea    0x1(%eax),%edx
  800c06:	89 55 10             	mov    %edx,0x10(%ebp)
  800c09:	8a 00                	mov    (%eax),%al
  800c0b:	0f b6 d8             	movzbl %al,%ebx
  800c0e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c11:	83 f8 55             	cmp    $0x55,%eax
  800c14:	0f 87 2b 03 00 00    	ja     800f45 <vprintfmt+0x399>
  800c1a:	8b 04 85 78 3d 80 00 	mov    0x803d78(,%eax,4),%eax
  800c21:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c23:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c27:	eb d7                	jmp    800c00 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c29:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c2d:	eb d1                	jmp    800c00 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c2f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c36:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c39:	89 d0                	mov    %edx,%eax
  800c3b:	c1 e0 02             	shl    $0x2,%eax
  800c3e:	01 d0                	add    %edx,%eax
  800c40:	01 c0                	add    %eax,%eax
  800c42:	01 d8                	add    %ebx,%eax
  800c44:	83 e8 30             	sub    $0x30,%eax
  800c47:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c4a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c4d:	8a 00                	mov    (%eax),%al
  800c4f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c52:	83 fb 2f             	cmp    $0x2f,%ebx
  800c55:	7e 3e                	jle    800c95 <vprintfmt+0xe9>
  800c57:	83 fb 39             	cmp    $0x39,%ebx
  800c5a:	7f 39                	jg     800c95 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c5c:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c5f:	eb d5                	jmp    800c36 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c61:	8b 45 14             	mov    0x14(%ebp),%eax
  800c64:	83 c0 04             	add    $0x4,%eax
  800c67:	89 45 14             	mov    %eax,0x14(%ebp)
  800c6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6d:	83 e8 04             	sub    $0x4,%eax
  800c70:	8b 00                	mov    (%eax),%eax
  800c72:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c75:	eb 1f                	jmp    800c96 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c77:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c7b:	79 83                	jns    800c00 <vprintfmt+0x54>
				width = 0;
  800c7d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c84:	e9 77 ff ff ff       	jmp    800c00 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c89:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c90:	e9 6b ff ff ff       	jmp    800c00 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c95:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c96:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c9a:	0f 89 60 ff ff ff    	jns    800c00 <vprintfmt+0x54>
				width = precision, precision = -1;
  800ca0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ca3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ca6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800cad:	e9 4e ff ff ff       	jmp    800c00 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800cb2:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800cb5:	e9 46 ff ff ff       	jmp    800c00 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800cba:	8b 45 14             	mov    0x14(%ebp),%eax
  800cbd:	83 c0 04             	add    $0x4,%eax
  800cc0:	89 45 14             	mov    %eax,0x14(%ebp)
  800cc3:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc6:	83 e8 04             	sub    $0x4,%eax
  800cc9:	8b 00                	mov    (%eax),%eax
  800ccb:	83 ec 08             	sub    $0x8,%esp
  800cce:	ff 75 0c             	pushl  0xc(%ebp)
  800cd1:	50                   	push   %eax
  800cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd5:	ff d0                	call   *%eax
  800cd7:	83 c4 10             	add    $0x10,%esp
			break;
  800cda:	e9 89 02 00 00       	jmp    800f68 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800cdf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce2:	83 c0 04             	add    $0x4,%eax
  800ce5:	89 45 14             	mov    %eax,0x14(%ebp)
  800ce8:	8b 45 14             	mov    0x14(%ebp),%eax
  800ceb:	83 e8 04             	sub    $0x4,%eax
  800cee:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800cf0:	85 db                	test   %ebx,%ebx
  800cf2:	79 02                	jns    800cf6 <vprintfmt+0x14a>
				err = -err;
  800cf4:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800cf6:	83 fb 64             	cmp    $0x64,%ebx
  800cf9:	7f 0b                	jg     800d06 <vprintfmt+0x15a>
  800cfb:	8b 34 9d c0 3b 80 00 	mov    0x803bc0(,%ebx,4),%esi
  800d02:	85 f6                	test   %esi,%esi
  800d04:	75 19                	jne    800d1f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d06:	53                   	push   %ebx
  800d07:	68 65 3d 80 00       	push   $0x803d65
  800d0c:	ff 75 0c             	pushl  0xc(%ebp)
  800d0f:	ff 75 08             	pushl  0x8(%ebp)
  800d12:	e8 5e 02 00 00       	call   800f75 <printfmt>
  800d17:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d1a:	e9 49 02 00 00       	jmp    800f68 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d1f:	56                   	push   %esi
  800d20:	68 6e 3d 80 00       	push   $0x803d6e
  800d25:	ff 75 0c             	pushl  0xc(%ebp)
  800d28:	ff 75 08             	pushl  0x8(%ebp)
  800d2b:	e8 45 02 00 00       	call   800f75 <printfmt>
  800d30:	83 c4 10             	add    $0x10,%esp
			break;
  800d33:	e9 30 02 00 00       	jmp    800f68 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d38:	8b 45 14             	mov    0x14(%ebp),%eax
  800d3b:	83 c0 04             	add    $0x4,%eax
  800d3e:	89 45 14             	mov    %eax,0x14(%ebp)
  800d41:	8b 45 14             	mov    0x14(%ebp),%eax
  800d44:	83 e8 04             	sub    $0x4,%eax
  800d47:	8b 30                	mov    (%eax),%esi
  800d49:	85 f6                	test   %esi,%esi
  800d4b:	75 05                	jne    800d52 <vprintfmt+0x1a6>
				p = "(null)";
  800d4d:	be 71 3d 80 00       	mov    $0x803d71,%esi
			if (width > 0 && padc != '-')
  800d52:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d56:	7e 6d                	jle    800dc5 <vprintfmt+0x219>
  800d58:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d5c:	74 67                	je     800dc5 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d5e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d61:	83 ec 08             	sub    $0x8,%esp
  800d64:	50                   	push   %eax
  800d65:	56                   	push   %esi
  800d66:	e8 0c 03 00 00       	call   801077 <strnlen>
  800d6b:	83 c4 10             	add    $0x10,%esp
  800d6e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d71:	eb 16                	jmp    800d89 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d73:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d77:	83 ec 08             	sub    $0x8,%esp
  800d7a:	ff 75 0c             	pushl  0xc(%ebp)
  800d7d:	50                   	push   %eax
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	ff d0                	call   *%eax
  800d83:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d86:	ff 4d e4             	decl   -0x1c(%ebp)
  800d89:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d8d:	7f e4                	jg     800d73 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d8f:	eb 34                	jmp    800dc5 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d91:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d95:	74 1c                	je     800db3 <vprintfmt+0x207>
  800d97:	83 fb 1f             	cmp    $0x1f,%ebx
  800d9a:	7e 05                	jle    800da1 <vprintfmt+0x1f5>
  800d9c:	83 fb 7e             	cmp    $0x7e,%ebx
  800d9f:	7e 12                	jle    800db3 <vprintfmt+0x207>
					putch('?', putdat);
  800da1:	83 ec 08             	sub    $0x8,%esp
  800da4:	ff 75 0c             	pushl  0xc(%ebp)
  800da7:	6a 3f                	push   $0x3f
  800da9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dac:	ff d0                	call   *%eax
  800dae:	83 c4 10             	add    $0x10,%esp
  800db1:	eb 0f                	jmp    800dc2 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800db3:	83 ec 08             	sub    $0x8,%esp
  800db6:	ff 75 0c             	pushl  0xc(%ebp)
  800db9:	53                   	push   %ebx
  800dba:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbd:	ff d0                	call   *%eax
  800dbf:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dc2:	ff 4d e4             	decl   -0x1c(%ebp)
  800dc5:	89 f0                	mov    %esi,%eax
  800dc7:	8d 70 01             	lea    0x1(%eax),%esi
  800dca:	8a 00                	mov    (%eax),%al
  800dcc:	0f be d8             	movsbl %al,%ebx
  800dcf:	85 db                	test   %ebx,%ebx
  800dd1:	74 24                	je     800df7 <vprintfmt+0x24b>
  800dd3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800dd7:	78 b8                	js     800d91 <vprintfmt+0x1e5>
  800dd9:	ff 4d e0             	decl   -0x20(%ebp)
  800ddc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800de0:	79 af                	jns    800d91 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800de2:	eb 13                	jmp    800df7 <vprintfmt+0x24b>
				putch(' ', putdat);
  800de4:	83 ec 08             	sub    $0x8,%esp
  800de7:	ff 75 0c             	pushl  0xc(%ebp)
  800dea:	6a 20                	push   $0x20
  800dec:	8b 45 08             	mov    0x8(%ebp),%eax
  800def:	ff d0                	call   *%eax
  800df1:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800df4:	ff 4d e4             	decl   -0x1c(%ebp)
  800df7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dfb:	7f e7                	jg     800de4 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800dfd:	e9 66 01 00 00       	jmp    800f68 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e02:	83 ec 08             	sub    $0x8,%esp
  800e05:	ff 75 e8             	pushl  -0x18(%ebp)
  800e08:	8d 45 14             	lea    0x14(%ebp),%eax
  800e0b:	50                   	push   %eax
  800e0c:	e8 3c fd ff ff       	call   800b4d <getint>
  800e11:	83 c4 10             	add    $0x10,%esp
  800e14:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e17:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e20:	85 d2                	test   %edx,%edx
  800e22:	79 23                	jns    800e47 <vprintfmt+0x29b>
				putch('-', putdat);
  800e24:	83 ec 08             	sub    $0x8,%esp
  800e27:	ff 75 0c             	pushl  0xc(%ebp)
  800e2a:	6a 2d                	push   $0x2d
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	ff d0                	call   *%eax
  800e31:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e3a:	f7 d8                	neg    %eax
  800e3c:	83 d2 00             	adc    $0x0,%edx
  800e3f:	f7 da                	neg    %edx
  800e41:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e44:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e47:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e4e:	e9 bc 00 00 00       	jmp    800f0f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e53:	83 ec 08             	sub    $0x8,%esp
  800e56:	ff 75 e8             	pushl  -0x18(%ebp)
  800e59:	8d 45 14             	lea    0x14(%ebp),%eax
  800e5c:	50                   	push   %eax
  800e5d:	e8 84 fc ff ff       	call   800ae6 <getuint>
  800e62:	83 c4 10             	add    $0x10,%esp
  800e65:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e68:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e6b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e72:	e9 98 00 00 00       	jmp    800f0f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e77:	83 ec 08             	sub    $0x8,%esp
  800e7a:	ff 75 0c             	pushl  0xc(%ebp)
  800e7d:	6a 58                	push   $0x58
  800e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e82:	ff d0                	call   *%eax
  800e84:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e87:	83 ec 08             	sub    $0x8,%esp
  800e8a:	ff 75 0c             	pushl  0xc(%ebp)
  800e8d:	6a 58                	push   $0x58
  800e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e92:	ff d0                	call   *%eax
  800e94:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e97:	83 ec 08             	sub    $0x8,%esp
  800e9a:	ff 75 0c             	pushl  0xc(%ebp)
  800e9d:	6a 58                	push   $0x58
  800e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea2:	ff d0                	call   *%eax
  800ea4:	83 c4 10             	add    $0x10,%esp
			break;
  800ea7:	e9 bc 00 00 00       	jmp    800f68 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800eac:	83 ec 08             	sub    $0x8,%esp
  800eaf:	ff 75 0c             	pushl  0xc(%ebp)
  800eb2:	6a 30                	push   $0x30
  800eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb7:	ff d0                	call   *%eax
  800eb9:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ebc:	83 ec 08             	sub    $0x8,%esp
  800ebf:	ff 75 0c             	pushl  0xc(%ebp)
  800ec2:	6a 78                	push   $0x78
  800ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec7:	ff d0                	call   *%eax
  800ec9:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ecc:	8b 45 14             	mov    0x14(%ebp),%eax
  800ecf:	83 c0 04             	add    $0x4,%eax
  800ed2:	89 45 14             	mov    %eax,0x14(%ebp)
  800ed5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed8:	83 e8 04             	sub    $0x4,%eax
  800edb:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800edd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ee0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ee7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800eee:	eb 1f                	jmp    800f0f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ef0:	83 ec 08             	sub    $0x8,%esp
  800ef3:	ff 75 e8             	pushl  -0x18(%ebp)
  800ef6:	8d 45 14             	lea    0x14(%ebp),%eax
  800ef9:	50                   	push   %eax
  800efa:	e8 e7 fb ff ff       	call   800ae6 <getuint>
  800eff:	83 c4 10             	add    $0x10,%esp
  800f02:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f05:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f08:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f0f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f16:	83 ec 04             	sub    $0x4,%esp
  800f19:	52                   	push   %edx
  800f1a:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f1d:	50                   	push   %eax
  800f1e:	ff 75 f4             	pushl  -0xc(%ebp)
  800f21:	ff 75 f0             	pushl  -0x10(%ebp)
  800f24:	ff 75 0c             	pushl  0xc(%ebp)
  800f27:	ff 75 08             	pushl  0x8(%ebp)
  800f2a:	e8 00 fb ff ff       	call   800a2f <printnum>
  800f2f:	83 c4 20             	add    $0x20,%esp
			break;
  800f32:	eb 34                	jmp    800f68 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f34:	83 ec 08             	sub    $0x8,%esp
  800f37:	ff 75 0c             	pushl  0xc(%ebp)
  800f3a:	53                   	push   %ebx
  800f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3e:	ff d0                	call   *%eax
  800f40:	83 c4 10             	add    $0x10,%esp
			break;
  800f43:	eb 23                	jmp    800f68 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f45:	83 ec 08             	sub    $0x8,%esp
  800f48:	ff 75 0c             	pushl  0xc(%ebp)
  800f4b:	6a 25                	push   $0x25
  800f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f50:	ff d0                	call   *%eax
  800f52:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f55:	ff 4d 10             	decl   0x10(%ebp)
  800f58:	eb 03                	jmp    800f5d <vprintfmt+0x3b1>
  800f5a:	ff 4d 10             	decl   0x10(%ebp)
  800f5d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f60:	48                   	dec    %eax
  800f61:	8a 00                	mov    (%eax),%al
  800f63:	3c 25                	cmp    $0x25,%al
  800f65:	75 f3                	jne    800f5a <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f67:	90                   	nop
		}
	}
  800f68:	e9 47 fc ff ff       	jmp    800bb4 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f6d:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f6e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f71:	5b                   	pop    %ebx
  800f72:	5e                   	pop    %esi
  800f73:	5d                   	pop    %ebp
  800f74:	c3                   	ret    

00800f75 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f75:	55                   	push   %ebp
  800f76:	89 e5                	mov    %esp,%ebp
  800f78:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f7b:	8d 45 10             	lea    0x10(%ebp),%eax
  800f7e:	83 c0 04             	add    $0x4,%eax
  800f81:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f84:	8b 45 10             	mov    0x10(%ebp),%eax
  800f87:	ff 75 f4             	pushl  -0xc(%ebp)
  800f8a:	50                   	push   %eax
  800f8b:	ff 75 0c             	pushl  0xc(%ebp)
  800f8e:	ff 75 08             	pushl  0x8(%ebp)
  800f91:	e8 16 fc ff ff       	call   800bac <vprintfmt>
  800f96:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f99:	90                   	nop
  800f9a:	c9                   	leave  
  800f9b:	c3                   	ret    

00800f9c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f9c:	55                   	push   %ebp
  800f9d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa2:	8b 40 08             	mov    0x8(%eax),%eax
  800fa5:	8d 50 01             	lea    0x1(%eax),%edx
  800fa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fab:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800fae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb1:	8b 10                	mov    (%eax),%edx
  800fb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb6:	8b 40 04             	mov    0x4(%eax),%eax
  800fb9:	39 c2                	cmp    %eax,%edx
  800fbb:	73 12                	jae    800fcf <sprintputch+0x33>
		*b->buf++ = ch;
  800fbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc0:	8b 00                	mov    (%eax),%eax
  800fc2:	8d 48 01             	lea    0x1(%eax),%ecx
  800fc5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fc8:	89 0a                	mov    %ecx,(%edx)
  800fca:	8b 55 08             	mov    0x8(%ebp),%edx
  800fcd:	88 10                	mov    %dl,(%eax)
}
  800fcf:	90                   	nop
  800fd0:	5d                   	pop    %ebp
  800fd1:	c3                   	ret    

00800fd2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800fd2:	55                   	push   %ebp
  800fd3:	89 e5                	mov    %esp,%ebp
  800fd5:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800fde:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe7:	01 d0                	add    %edx,%eax
  800fe9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ff3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ff7:	74 06                	je     800fff <vsnprintf+0x2d>
  800ff9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ffd:	7f 07                	jg     801006 <vsnprintf+0x34>
		return -E_INVAL;
  800fff:	b8 03 00 00 00       	mov    $0x3,%eax
  801004:	eb 20                	jmp    801026 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801006:	ff 75 14             	pushl  0x14(%ebp)
  801009:	ff 75 10             	pushl  0x10(%ebp)
  80100c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80100f:	50                   	push   %eax
  801010:	68 9c 0f 80 00       	push   $0x800f9c
  801015:	e8 92 fb ff ff       	call   800bac <vprintfmt>
  80101a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80101d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801020:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801023:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801026:	c9                   	leave  
  801027:	c3                   	ret    

00801028 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801028:	55                   	push   %ebp
  801029:	89 e5                	mov    %esp,%ebp
  80102b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80102e:	8d 45 10             	lea    0x10(%ebp),%eax
  801031:	83 c0 04             	add    $0x4,%eax
  801034:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801037:	8b 45 10             	mov    0x10(%ebp),%eax
  80103a:	ff 75 f4             	pushl  -0xc(%ebp)
  80103d:	50                   	push   %eax
  80103e:	ff 75 0c             	pushl  0xc(%ebp)
  801041:	ff 75 08             	pushl  0x8(%ebp)
  801044:	e8 89 ff ff ff       	call   800fd2 <vsnprintf>
  801049:	83 c4 10             	add    $0x10,%esp
  80104c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80104f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801052:	c9                   	leave  
  801053:	c3                   	ret    

00801054 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801054:	55                   	push   %ebp
  801055:	89 e5                	mov    %esp,%ebp
  801057:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80105a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801061:	eb 06                	jmp    801069 <strlen+0x15>
		n++;
  801063:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801066:	ff 45 08             	incl   0x8(%ebp)
  801069:	8b 45 08             	mov    0x8(%ebp),%eax
  80106c:	8a 00                	mov    (%eax),%al
  80106e:	84 c0                	test   %al,%al
  801070:	75 f1                	jne    801063 <strlen+0xf>
		n++;
	return n;
  801072:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801075:	c9                   	leave  
  801076:	c3                   	ret    

00801077 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801077:	55                   	push   %ebp
  801078:	89 e5                	mov    %esp,%ebp
  80107a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80107d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801084:	eb 09                	jmp    80108f <strnlen+0x18>
		n++;
  801086:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801089:	ff 45 08             	incl   0x8(%ebp)
  80108c:	ff 4d 0c             	decl   0xc(%ebp)
  80108f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801093:	74 09                	je     80109e <strnlen+0x27>
  801095:	8b 45 08             	mov    0x8(%ebp),%eax
  801098:	8a 00                	mov    (%eax),%al
  80109a:	84 c0                	test   %al,%al
  80109c:	75 e8                	jne    801086 <strnlen+0xf>
		n++;
	return n;
  80109e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010a1:	c9                   	leave  
  8010a2:	c3                   	ret    

008010a3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010a3:	55                   	push   %ebp
  8010a4:	89 e5                	mov    %esp,%ebp
  8010a6:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8010af:	90                   	nop
  8010b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b3:	8d 50 01             	lea    0x1(%eax),%edx
  8010b6:	89 55 08             	mov    %edx,0x8(%ebp)
  8010b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010bc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010bf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010c2:	8a 12                	mov    (%edx),%dl
  8010c4:	88 10                	mov    %dl,(%eax)
  8010c6:	8a 00                	mov    (%eax),%al
  8010c8:	84 c0                	test   %al,%al
  8010ca:	75 e4                	jne    8010b0 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8010cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010cf:	c9                   	leave  
  8010d0:	c3                   	ret    

008010d1 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8010d1:	55                   	push   %ebp
  8010d2:	89 e5                	mov    %esp,%ebp
  8010d4:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010da:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8010dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010e4:	eb 1f                	jmp    801105 <strncpy+0x34>
		*dst++ = *src;
  8010e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e9:	8d 50 01             	lea    0x1(%eax),%edx
  8010ec:	89 55 08             	mov    %edx,0x8(%ebp)
  8010ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f2:	8a 12                	mov    (%edx),%dl
  8010f4:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f9:	8a 00                	mov    (%eax),%al
  8010fb:	84 c0                	test   %al,%al
  8010fd:	74 03                	je     801102 <strncpy+0x31>
			src++;
  8010ff:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801102:	ff 45 fc             	incl   -0x4(%ebp)
  801105:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801108:	3b 45 10             	cmp    0x10(%ebp),%eax
  80110b:	72 d9                	jb     8010e6 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80110d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801110:	c9                   	leave  
  801111:	c3                   	ret    

00801112 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801112:	55                   	push   %ebp
  801113:	89 e5                	mov    %esp,%ebp
  801115:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801118:	8b 45 08             	mov    0x8(%ebp),%eax
  80111b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80111e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801122:	74 30                	je     801154 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801124:	eb 16                	jmp    80113c <strlcpy+0x2a>
			*dst++ = *src++;
  801126:	8b 45 08             	mov    0x8(%ebp),%eax
  801129:	8d 50 01             	lea    0x1(%eax),%edx
  80112c:	89 55 08             	mov    %edx,0x8(%ebp)
  80112f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801132:	8d 4a 01             	lea    0x1(%edx),%ecx
  801135:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801138:	8a 12                	mov    (%edx),%dl
  80113a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80113c:	ff 4d 10             	decl   0x10(%ebp)
  80113f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801143:	74 09                	je     80114e <strlcpy+0x3c>
  801145:	8b 45 0c             	mov    0xc(%ebp),%eax
  801148:	8a 00                	mov    (%eax),%al
  80114a:	84 c0                	test   %al,%al
  80114c:	75 d8                	jne    801126 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80114e:	8b 45 08             	mov    0x8(%ebp),%eax
  801151:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801154:	8b 55 08             	mov    0x8(%ebp),%edx
  801157:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80115a:	29 c2                	sub    %eax,%edx
  80115c:	89 d0                	mov    %edx,%eax
}
  80115e:	c9                   	leave  
  80115f:	c3                   	ret    

00801160 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801160:	55                   	push   %ebp
  801161:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801163:	eb 06                	jmp    80116b <strcmp+0xb>
		p++, q++;
  801165:	ff 45 08             	incl   0x8(%ebp)
  801168:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80116b:	8b 45 08             	mov    0x8(%ebp),%eax
  80116e:	8a 00                	mov    (%eax),%al
  801170:	84 c0                	test   %al,%al
  801172:	74 0e                	je     801182 <strcmp+0x22>
  801174:	8b 45 08             	mov    0x8(%ebp),%eax
  801177:	8a 10                	mov    (%eax),%dl
  801179:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117c:	8a 00                	mov    (%eax),%al
  80117e:	38 c2                	cmp    %al,%dl
  801180:	74 e3                	je     801165 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	8a 00                	mov    (%eax),%al
  801187:	0f b6 d0             	movzbl %al,%edx
  80118a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118d:	8a 00                	mov    (%eax),%al
  80118f:	0f b6 c0             	movzbl %al,%eax
  801192:	29 c2                	sub    %eax,%edx
  801194:	89 d0                	mov    %edx,%eax
}
  801196:	5d                   	pop    %ebp
  801197:	c3                   	ret    

00801198 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801198:	55                   	push   %ebp
  801199:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80119b:	eb 09                	jmp    8011a6 <strncmp+0xe>
		n--, p++, q++;
  80119d:	ff 4d 10             	decl   0x10(%ebp)
  8011a0:	ff 45 08             	incl   0x8(%ebp)
  8011a3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8011a6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011aa:	74 17                	je     8011c3 <strncmp+0x2b>
  8011ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8011af:	8a 00                	mov    (%eax),%al
  8011b1:	84 c0                	test   %al,%al
  8011b3:	74 0e                	je     8011c3 <strncmp+0x2b>
  8011b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b8:	8a 10                	mov    (%eax),%dl
  8011ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bd:	8a 00                	mov    (%eax),%al
  8011bf:	38 c2                	cmp    %al,%dl
  8011c1:	74 da                	je     80119d <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8011c3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011c7:	75 07                	jne    8011d0 <strncmp+0x38>
		return 0;
  8011c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8011ce:	eb 14                	jmp    8011e4 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8011d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d3:	8a 00                	mov    (%eax),%al
  8011d5:	0f b6 d0             	movzbl %al,%edx
  8011d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011db:	8a 00                	mov    (%eax),%al
  8011dd:	0f b6 c0             	movzbl %al,%eax
  8011e0:	29 c2                	sub    %eax,%edx
  8011e2:	89 d0                	mov    %edx,%eax
}
  8011e4:	5d                   	pop    %ebp
  8011e5:	c3                   	ret    

008011e6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011e6:	55                   	push   %ebp
  8011e7:	89 e5                	mov    %esp,%ebp
  8011e9:	83 ec 04             	sub    $0x4,%esp
  8011ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ef:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011f2:	eb 12                	jmp    801206 <strchr+0x20>
		if (*s == c)
  8011f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f7:	8a 00                	mov    (%eax),%al
  8011f9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011fc:	75 05                	jne    801203 <strchr+0x1d>
			return (char *) s;
  8011fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801201:	eb 11                	jmp    801214 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801203:	ff 45 08             	incl   0x8(%ebp)
  801206:	8b 45 08             	mov    0x8(%ebp),%eax
  801209:	8a 00                	mov    (%eax),%al
  80120b:	84 c0                	test   %al,%al
  80120d:	75 e5                	jne    8011f4 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80120f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801214:	c9                   	leave  
  801215:	c3                   	ret    

00801216 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801216:	55                   	push   %ebp
  801217:	89 e5                	mov    %esp,%ebp
  801219:	83 ec 04             	sub    $0x4,%esp
  80121c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801222:	eb 0d                	jmp    801231 <strfind+0x1b>
		if (*s == c)
  801224:	8b 45 08             	mov    0x8(%ebp),%eax
  801227:	8a 00                	mov    (%eax),%al
  801229:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80122c:	74 0e                	je     80123c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80122e:	ff 45 08             	incl   0x8(%ebp)
  801231:	8b 45 08             	mov    0x8(%ebp),%eax
  801234:	8a 00                	mov    (%eax),%al
  801236:	84 c0                	test   %al,%al
  801238:	75 ea                	jne    801224 <strfind+0xe>
  80123a:	eb 01                	jmp    80123d <strfind+0x27>
		if (*s == c)
			break;
  80123c:	90                   	nop
	return (char *) s;
  80123d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801240:	c9                   	leave  
  801241:	c3                   	ret    

00801242 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801242:	55                   	push   %ebp
  801243:	89 e5                	mov    %esp,%ebp
  801245:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801248:	8b 45 08             	mov    0x8(%ebp),%eax
  80124b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80124e:	8b 45 10             	mov    0x10(%ebp),%eax
  801251:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801254:	eb 0e                	jmp    801264 <memset+0x22>
		*p++ = c;
  801256:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801259:	8d 50 01             	lea    0x1(%eax),%edx
  80125c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80125f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801262:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801264:	ff 4d f8             	decl   -0x8(%ebp)
  801267:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80126b:	79 e9                	jns    801256 <memset+0x14>
		*p++ = c;

	return v;
  80126d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801270:	c9                   	leave  
  801271:	c3                   	ret    

00801272 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801272:	55                   	push   %ebp
  801273:	89 e5                	mov    %esp,%ebp
  801275:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801278:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
  801281:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801284:	eb 16                	jmp    80129c <memcpy+0x2a>
		*d++ = *s++;
  801286:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801289:	8d 50 01             	lea    0x1(%eax),%edx
  80128c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80128f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801292:	8d 4a 01             	lea    0x1(%edx),%ecx
  801295:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801298:	8a 12                	mov    (%edx),%dl
  80129a:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80129c:	8b 45 10             	mov    0x10(%ebp),%eax
  80129f:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012a2:	89 55 10             	mov    %edx,0x10(%ebp)
  8012a5:	85 c0                	test   %eax,%eax
  8012a7:	75 dd                	jne    801286 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8012a9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012ac:	c9                   	leave  
  8012ad:	c3                   	ret    

008012ae <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8012ae:	55                   	push   %ebp
  8012af:	89 e5                	mov    %esp,%ebp
  8012b1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8012b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8012c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012c3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012c6:	73 50                	jae    801318 <memmove+0x6a>
  8012c8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ce:	01 d0                	add    %edx,%eax
  8012d0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012d3:	76 43                	jbe    801318 <memmove+0x6a>
		s += n;
  8012d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d8:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8012db:	8b 45 10             	mov    0x10(%ebp),%eax
  8012de:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8012e1:	eb 10                	jmp    8012f3 <memmove+0x45>
			*--d = *--s;
  8012e3:	ff 4d f8             	decl   -0x8(%ebp)
  8012e6:	ff 4d fc             	decl   -0x4(%ebp)
  8012e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012ec:	8a 10                	mov    (%eax),%dl
  8012ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f1:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8012f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012f9:	89 55 10             	mov    %edx,0x10(%ebp)
  8012fc:	85 c0                	test   %eax,%eax
  8012fe:	75 e3                	jne    8012e3 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801300:	eb 23                	jmp    801325 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801302:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801305:	8d 50 01             	lea    0x1(%eax),%edx
  801308:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80130b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80130e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801311:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801314:	8a 12                	mov    (%edx),%dl
  801316:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801318:	8b 45 10             	mov    0x10(%ebp),%eax
  80131b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80131e:	89 55 10             	mov    %edx,0x10(%ebp)
  801321:	85 c0                	test   %eax,%eax
  801323:	75 dd                	jne    801302 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801325:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801328:	c9                   	leave  
  801329:	c3                   	ret    

0080132a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80132a:	55                   	push   %ebp
  80132b:	89 e5                	mov    %esp,%ebp
  80132d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801330:	8b 45 08             	mov    0x8(%ebp),%eax
  801333:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801336:	8b 45 0c             	mov    0xc(%ebp),%eax
  801339:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80133c:	eb 2a                	jmp    801368 <memcmp+0x3e>
		if (*s1 != *s2)
  80133e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801341:	8a 10                	mov    (%eax),%dl
  801343:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801346:	8a 00                	mov    (%eax),%al
  801348:	38 c2                	cmp    %al,%dl
  80134a:	74 16                	je     801362 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80134c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80134f:	8a 00                	mov    (%eax),%al
  801351:	0f b6 d0             	movzbl %al,%edx
  801354:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801357:	8a 00                	mov    (%eax),%al
  801359:	0f b6 c0             	movzbl %al,%eax
  80135c:	29 c2                	sub    %eax,%edx
  80135e:	89 d0                	mov    %edx,%eax
  801360:	eb 18                	jmp    80137a <memcmp+0x50>
		s1++, s2++;
  801362:	ff 45 fc             	incl   -0x4(%ebp)
  801365:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801368:	8b 45 10             	mov    0x10(%ebp),%eax
  80136b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80136e:	89 55 10             	mov    %edx,0x10(%ebp)
  801371:	85 c0                	test   %eax,%eax
  801373:	75 c9                	jne    80133e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801375:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80137a:	c9                   	leave  
  80137b:	c3                   	ret    

0080137c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80137c:	55                   	push   %ebp
  80137d:	89 e5                	mov    %esp,%ebp
  80137f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801382:	8b 55 08             	mov    0x8(%ebp),%edx
  801385:	8b 45 10             	mov    0x10(%ebp),%eax
  801388:	01 d0                	add    %edx,%eax
  80138a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80138d:	eb 15                	jmp    8013a4 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80138f:	8b 45 08             	mov    0x8(%ebp),%eax
  801392:	8a 00                	mov    (%eax),%al
  801394:	0f b6 d0             	movzbl %al,%edx
  801397:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139a:	0f b6 c0             	movzbl %al,%eax
  80139d:	39 c2                	cmp    %eax,%edx
  80139f:	74 0d                	je     8013ae <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013a1:	ff 45 08             	incl   0x8(%ebp)
  8013a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8013aa:	72 e3                	jb     80138f <memfind+0x13>
  8013ac:	eb 01                	jmp    8013af <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8013ae:	90                   	nop
	return (void *) s;
  8013af:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013b2:	c9                   	leave  
  8013b3:	c3                   	ret    

008013b4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013b4:	55                   	push   %ebp
  8013b5:	89 e5                	mov    %esp,%ebp
  8013b7:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8013ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8013c1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013c8:	eb 03                	jmp    8013cd <strtol+0x19>
		s++;
  8013ca:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d0:	8a 00                	mov    (%eax),%al
  8013d2:	3c 20                	cmp    $0x20,%al
  8013d4:	74 f4                	je     8013ca <strtol+0x16>
  8013d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d9:	8a 00                	mov    (%eax),%al
  8013db:	3c 09                	cmp    $0x9,%al
  8013dd:	74 eb                	je     8013ca <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013df:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e2:	8a 00                	mov    (%eax),%al
  8013e4:	3c 2b                	cmp    $0x2b,%al
  8013e6:	75 05                	jne    8013ed <strtol+0x39>
		s++;
  8013e8:	ff 45 08             	incl   0x8(%ebp)
  8013eb:	eb 13                	jmp    801400 <strtol+0x4c>
	else if (*s == '-')
  8013ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f0:	8a 00                	mov    (%eax),%al
  8013f2:	3c 2d                	cmp    $0x2d,%al
  8013f4:	75 0a                	jne    801400 <strtol+0x4c>
		s++, neg = 1;
  8013f6:	ff 45 08             	incl   0x8(%ebp)
  8013f9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801400:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801404:	74 06                	je     80140c <strtol+0x58>
  801406:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80140a:	75 20                	jne    80142c <strtol+0x78>
  80140c:	8b 45 08             	mov    0x8(%ebp),%eax
  80140f:	8a 00                	mov    (%eax),%al
  801411:	3c 30                	cmp    $0x30,%al
  801413:	75 17                	jne    80142c <strtol+0x78>
  801415:	8b 45 08             	mov    0x8(%ebp),%eax
  801418:	40                   	inc    %eax
  801419:	8a 00                	mov    (%eax),%al
  80141b:	3c 78                	cmp    $0x78,%al
  80141d:	75 0d                	jne    80142c <strtol+0x78>
		s += 2, base = 16;
  80141f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801423:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80142a:	eb 28                	jmp    801454 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80142c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801430:	75 15                	jne    801447 <strtol+0x93>
  801432:	8b 45 08             	mov    0x8(%ebp),%eax
  801435:	8a 00                	mov    (%eax),%al
  801437:	3c 30                	cmp    $0x30,%al
  801439:	75 0c                	jne    801447 <strtol+0x93>
		s++, base = 8;
  80143b:	ff 45 08             	incl   0x8(%ebp)
  80143e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801445:	eb 0d                	jmp    801454 <strtol+0xa0>
	else if (base == 0)
  801447:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80144b:	75 07                	jne    801454 <strtol+0xa0>
		base = 10;
  80144d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801454:	8b 45 08             	mov    0x8(%ebp),%eax
  801457:	8a 00                	mov    (%eax),%al
  801459:	3c 2f                	cmp    $0x2f,%al
  80145b:	7e 19                	jle    801476 <strtol+0xc2>
  80145d:	8b 45 08             	mov    0x8(%ebp),%eax
  801460:	8a 00                	mov    (%eax),%al
  801462:	3c 39                	cmp    $0x39,%al
  801464:	7f 10                	jg     801476 <strtol+0xc2>
			dig = *s - '0';
  801466:	8b 45 08             	mov    0x8(%ebp),%eax
  801469:	8a 00                	mov    (%eax),%al
  80146b:	0f be c0             	movsbl %al,%eax
  80146e:	83 e8 30             	sub    $0x30,%eax
  801471:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801474:	eb 42                	jmp    8014b8 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801476:	8b 45 08             	mov    0x8(%ebp),%eax
  801479:	8a 00                	mov    (%eax),%al
  80147b:	3c 60                	cmp    $0x60,%al
  80147d:	7e 19                	jle    801498 <strtol+0xe4>
  80147f:	8b 45 08             	mov    0x8(%ebp),%eax
  801482:	8a 00                	mov    (%eax),%al
  801484:	3c 7a                	cmp    $0x7a,%al
  801486:	7f 10                	jg     801498 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801488:	8b 45 08             	mov    0x8(%ebp),%eax
  80148b:	8a 00                	mov    (%eax),%al
  80148d:	0f be c0             	movsbl %al,%eax
  801490:	83 e8 57             	sub    $0x57,%eax
  801493:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801496:	eb 20                	jmp    8014b8 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801498:	8b 45 08             	mov    0x8(%ebp),%eax
  80149b:	8a 00                	mov    (%eax),%al
  80149d:	3c 40                	cmp    $0x40,%al
  80149f:	7e 39                	jle    8014da <strtol+0x126>
  8014a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a4:	8a 00                	mov    (%eax),%al
  8014a6:	3c 5a                	cmp    $0x5a,%al
  8014a8:	7f 30                	jg     8014da <strtol+0x126>
			dig = *s - 'A' + 10;
  8014aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ad:	8a 00                	mov    (%eax),%al
  8014af:	0f be c0             	movsbl %al,%eax
  8014b2:	83 e8 37             	sub    $0x37,%eax
  8014b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8014b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014bb:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014be:	7d 19                	jge    8014d9 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8014c0:	ff 45 08             	incl   0x8(%ebp)
  8014c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014c6:	0f af 45 10          	imul   0x10(%ebp),%eax
  8014ca:	89 c2                	mov    %eax,%edx
  8014cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014cf:	01 d0                	add    %edx,%eax
  8014d1:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8014d4:	e9 7b ff ff ff       	jmp    801454 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8014d9:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8014da:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014de:	74 08                	je     8014e8 <strtol+0x134>
		*endptr = (char *) s;
  8014e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8014e6:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8014e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8014ec:	74 07                	je     8014f5 <strtol+0x141>
  8014ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014f1:	f7 d8                	neg    %eax
  8014f3:	eb 03                	jmp    8014f8 <strtol+0x144>
  8014f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014f8:	c9                   	leave  
  8014f9:	c3                   	ret    

008014fa <ltostr>:

void
ltostr(long value, char *str)
{
  8014fa:	55                   	push   %ebp
  8014fb:	89 e5                	mov    %esp,%ebp
  8014fd:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801500:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801507:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80150e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801512:	79 13                	jns    801527 <ltostr+0x2d>
	{
		neg = 1;
  801514:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80151b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801521:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801524:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801527:	8b 45 08             	mov    0x8(%ebp),%eax
  80152a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80152f:	99                   	cltd   
  801530:	f7 f9                	idiv   %ecx
  801532:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801535:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801538:	8d 50 01             	lea    0x1(%eax),%edx
  80153b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80153e:	89 c2                	mov    %eax,%edx
  801540:	8b 45 0c             	mov    0xc(%ebp),%eax
  801543:	01 d0                	add    %edx,%eax
  801545:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801548:	83 c2 30             	add    $0x30,%edx
  80154b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80154d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801550:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801555:	f7 e9                	imul   %ecx
  801557:	c1 fa 02             	sar    $0x2,%edx
  80155a:	89 c8                	mov    %ecx,%eax
  80155c:	c1 f8 1f             	sar    $0x1f,%eax
  80155f:	29 c2                	sub    %eax,%edx
  801561:	89 d0                	mov    %edx,%eax
  801563:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801566:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801569:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80156e:	f7 e9                	imul   %ecx
  801570:	c1 fa 02             	sar    $0x2,%edx
  801573:	89 c8                	mov    %ecx,%eax
  801575:	c1 f8 1f             	sar    $0x1f,%eax
  801578:	29 c2                	sub    %eax,%edx
  80157a:	89 d0                	mov    %edx,%eax
  80157c:	c1 e0 02             	shl    $0x2,%eax
  80157f:	01 d0                	add    %edx,%eax
  801581:	01 c0                	add    %eax,%eax
  801583:	29 c1                	sub    %eax,%ecx
  801585:	89 ca                	mov    %ecx,%edx
  801587:	85 d2                	test   %edx,%edx
  801589:	75 9c                	jne    801527 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80158b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801592:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801595:	48                   	dec    %eax
  801596:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801599:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80159d:	74 3d                	je     8015dc <ltostr+0xe2>
		start = 1 ;
  80159f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8015a6:	eb 34                	jmp    8015dc <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8015a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ae:	01 d0                	add    %edx,%eax
  8015b0:	8a 00                	mov    (%eax),%al
  8015b2:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8015b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015bb:	01 c2                	add    %eax,%edx
  8015bd:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8015c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c3:	01 c8                	add    %ecx,%eax
  8015c5:	8a 00                	mov    (%eax),%al
  8015c7:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8015c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015cf:	01 c2                	add    %eax,%edx
  8015d1:	8a 45 eb             	mov    -0x15(%ebp),%al
  8015d4:	88 02                	mov    %al,(%edx)
		start++ ;
  8015d6:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8015d9:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8015dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015df:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015e2:	7c c4                	jl     8015a8 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8015e4:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8015e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ea:	01 d0                	add    %edx,%eax
  8015ec:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8015ef:	90                   	nop
  8015f0:	c9                   	leave  
  8015f1:	c3                   	ret    

008015f2 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8015f2:	55                   	push   %ebp
  8015f3:	89 e5                	mov    %esp,%ebp
  8015f5:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8015f8:	ff 75 08             	pushl  0x8(%ebp)
  8015fb:	e8 54 fa ff ff       	call   801054 <strlen>
  801600:	83 c4 04             	add    $0x4,%esp
  801603:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801606:	ff 75 0c             	pushl  0xc(%ebp)
  801609:	e8 46 fa ff ff       	call   801054 <strlen>
  80160e:	83 c4 04             	add    $0x4,%esp
  801611:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801614:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80161b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801622:	eb 17                	jmp    80163b <strcconcat+0x49>
		final[s] = str1[s] ;
  801624:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801627:	8b 45 10             	mov    0x10(%ebp),%eax
  80162a:	01 c2                	add    %eax,%edx
  80162c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80162f:	8b 45 08             	mov    0x8(%ebp),%eax
  801632:	01 c8                	add    %ecx,%eax
  801634:	8a 00                	mov    (%eax),%al
  801636:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801638:	ff 45 fc             	incl   -0x4(%ebp)
  80163b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80163e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801641:	7c e1                	jl     801624 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801643:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80164a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801651:	eb 1f                	jmp    801672 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801653:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801656:	8d 50 01             	lea    0x1(%eax),%edx
  801659:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80165c:	89 c2                	mov    %eax,%edx
  80165e:	8b 45 10             	mov    0x10(%ebp),%eax
  801661:	01 c2                	add    %eax,%edx
  801663:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801666:	8b 45 0c             	mov    0xc(%ebp),%eax
  801669:	01 c8                	add    %ecx,%eax
  80166b:	8a 00                	mov    (%eax),%al
  80166d:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80166f:	ff 45 f8             	incl   -0x8(%ebp)
  801672:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801675:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801678:	7c d9                	jl     801653 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80167a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80167d:	8b 45 10             	mov    0x10(%ebp),%eax
  801680:	01 d0                	add    %edx,%eax
  801682:	c6 00 00             	movb   $0x0,(%eax)
}
  801685:	90                   	nop
  801686:	c9                   	leave  
  801687:	c3                   	ret    

00801688 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801688:	55                   	push   %ebp
  801689:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80168b:	8b 45 14             	mov    0x14(%ebp),%eax
  80168e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801694:	8b 45 14             	mov    0x14(%ebp),%eax
  801697:	8b 00                	mov    (%eax),%eax
  801699:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a3:	01 d0                	add    %edx,%eax
  8016a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016ab:	eb 0c                	jmp    8016b9 <strsplit+0x31>
			*string++ = 0;
  8016ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b0:	8d 50 01             	lea    0x1(%eax),%edx
  8016b3:	89 55 08             	mov    %edx,0x8(%ebp)
  8016b6:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bc:	8a 00                	mov    (%eax),%al
  8016be:	84 c0                	test   %al,%al
  8016c0:	74 18                	je     8016da <strsplit+0x52>
  8016c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c5:	8a 00                	mov    (%eax),%al
  8016c7:	0f be c0             	movsbl %al,%eax
  8016ca:	50                   	push   %eax
  8016cb:	ff 75 0c             	pushl  0xc(%ebp)
  8016ce:	e8 13 fb ff ff       	call   8011e6 <strchr>
  8016d3:	83 c4 08             	add    $0x8,%esp
  8016d6:	85 c0                	test   %eax,%eax
  8016d8:	75 d3                	jne    8016ad <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8016da:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dd:	8a 00                	mov    (%eax),%al
  8016df:	84 c0                	test   %al,%al
  8016e1:	74 5a                	je     80173d <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8016e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8016e6:	8b 00                	mov    (%eax),%eax
  8016e8:	83 f8 0f             	cmp    $0xf,%eax
  8016eb:	75 07                	jne    8016f4 <strsplit+0x6c>
		{
			return 0;
  8016ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f2:	eb 66                	jmp    80175a <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8016f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8016f7:	8b 00                	mov    (%eax),%eax
  8016f9:	8d 48 01             	lea    0x1(%eax),%ecx
  8016fc:	8b 55 14             	mov    0x14(%ebp),%edx
  8016ff:	89 0a                	mov    %ecx,(%edx)
  801701:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801708:	8b 45 10             	mov    0x10(%ebp),%eax
  80170b:	01 c2                	add    %eax,%edx
  80170d:	8b 45 08             	mov    0x8(%ebp),%eax
  801710:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801712:	eb 03                	jmp    801717 <strsplit+0x8f>
			string++;
  801714:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801717:	8b 45 08             	mov    0x8(%ebp),%eax
  80171a:	8a 00                	mov    (%eax),%al
  80171c:	84 c0                	test   %al,%al
  80171e:	74 8b                	je     8016ab <strsplit+0x23>
  801720:	8b 45 08             	mov    0x8(%ebp),%eax
  801723:	8a 00                	mov    (%eax),%al
  801725:	0f be c0             	movsbl %al,%eax
  801728:	50                   	push   %eax
  801729:	ff 75 0c             	pushl  0xc(%ebp)
  80172c:	e8 b5 fa ff ff       	call   8011e6 <strchr>
  801731:	83 c4 08             	add    $0x8,%esp
  801734:	85 c0                	test   %eax,%eax
  801736:	74 dc                	je     801714 <strsplit+0x8c>
			string++;
	}
  801738:	e9 6e ff ff ff       	jmp    8016ab <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80173d:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80173e:	8b 45 14             	mov    0x14(%ebp),%eax
  801741:	8b 00                	mov    (%eax),%eax
  801743:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80174a:	8b 45 10             	mov    0x10(%ebp),%eax
  80174d:	01 d0                	add    %edx,%eax
  80174f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801755:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80175a:	c9                   	leave  
  80175b:	c3                   	ret    

0080175c <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80175c:	55                   	push   %ebp
  80175d:	89 e5                	mov    %esp,%ebp
  80175f:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801762:	a1 04 50 80 00       	mov    0x805004,%eax
  801767:	85 c0                	test   %eax,%eax
  801769:	74 1f                	je     80178a <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80176b:	e8 1d 00 00 00       	call   80178d <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801770:	83 ec 0c             	sub    $0xc,%esp
  801773:	68 d0 3e 80 00       	push   $0x803ed0
  801778:	e8 55 f2 ff ff       	call   8009d2 <cprintf>
  80177d:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801780:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801787:	00 00 00 
	}
}
  80178a:	90                   	nop
  80178b:	c9                   	leave  
  80178c:	c3                   	ret    

0080178d <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80178d:	55                   	push   %ebp
  80178e:	89 e5                	mov    %esp,%ebp
  801790:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801793:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  80179a:	00 00 00 
  80179d:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  8017a4:	00 00 00 
  8017a7:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  8017ae:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  8017b1:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  8017b8:	00 00 00 
  8017bb:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  8017c2:	00 00 00 
  8017c5:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8017cc:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  8017cf:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  8017d6:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  8017d9:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  8017e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017e8:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017ed:	a3 50 50 80 00       	mov    %eax,0x805050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  8017f2:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8017f9:	a1 20 51 80 00       	mov    0x805120,%eax
  8017fe:	c1 e0 04             	shl    $0x4,%eax
  801801:	89 c2                	mov    %eax,%edx
  801803:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801806:	01 d0                	add    %edx,%eax
  801808:	48                   	dec    %eax
  801809:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80180c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80180f:	ba 00 00 00 00       	mov    $0x0,%edx
  801814:	f7 75 f0             	divl   -0x10(%ebp)
  801817:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80181a:	29 d0                	sub    %edx,%eax
  80181c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  80181f:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801826:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801829:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80182e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801833:	83 ec 04             	sub    $0x4,%esp
  801836:	6a 06                	push   $0x6
  801838:	ff 75 e8             	pushl  -0x18(%ebp)
  80183b:	50                   	push   %eax
  80183c:	e8 b0 05 00 00       	call   801df1 <sys_allocate_chunk>
  801841:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801844:	a1 20 51 80 00       	mov    0x805120,%eax
  801849:	83 ec 0c             	sub    $0xc,%esp
  80184c:	50                   	push   %eax
  80184d:	e8 25 0c 00 00       	call   802477 <initialize_MemBlocksList>
  801852:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  801855:	a1 48 51 80 00       	mov    0x805148,%eax
  80185a:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  80185d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801861:	75 14                	jne    801877 <initialize_dyn_block_system+0xea>
  801863:	83 ec 04             	sub    $0x4,%esp
  801866:	68 f5 3e 80 00       	push   $0x803ef5
  80186b:	6a 29                	push   $0x29
  80186d:	68 13 3f 80 00       	push   $0x803f13
  801872:	e8 a7 ee ff ff       	call   80071e <_panic>
  801877:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80187a:	8b 00                	mov    (%eax),%eax
  80187c:	85 c0                	test   %eax,%eax
  80187e:	74 10                	je     801890 <initialize_dyn_block_system+0x103>
  801880:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801883:	8b 00                	mov    (%eax),%eax
  801885:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801888:	8b 52 04             	mov    0x4(%edx),%edx
  80188b:	89 50 04             	mov    %edx,0x4(%eax)
  80188e:	eb 0b                	jmp    80189b <initialize_dyn_block_system+0x10e>
  801890:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801893:	8b 40 04             	mov    0x4(%eax),%eax
  801896:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80189b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80189e:	8b 40 04             	mov    0x4(%eax),%eax
  8018a1:	85 c0                	test   %eax,%eax
  8018a3:	74 0f                	je     8018b4 <initialize_dyn_block_system+0x127>
  8018a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018a8:	8b 40 04             	mov    0x4(%eax),%eax
  8018ab:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8018ae:	8b 12                	mov    (%edx),%edx
  8018b0:	89 10                	mov    %edx,(%eax)
  8018b2:	eb 0a                	jmp    8018be <initialize_dyn_block_system+0x131>
  8018b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018b7:	8b 00                	mov    (%eax),%eax
  8018b9:	a3 48 51 80 00       	mov    %eax,0x805148
  8018be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8018c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018ca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8018d1:	a1 54 51 80 00       	mov    0x805154,%eax
  8018d6:	48                   	dec    %eax
  8018d7:	a3 54 51 80 00       	mov    %eax,0x805154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  8018dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018df:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  8018e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018e9:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  8018f0:	83 ec 0c             	sub    $0xc,%esp
  8018f3:	ff 75 e0             	pushl  -0x20(%ebp)
  8018f6:	e8 b9 14 00 00       	call   802db4 <insert_sorted_with_merge_freeList>
  8018fb:	83 c4 10             	add    $0x10,%esp

}
  8018fe:	90                   	nop
  8018ff:	c9                   	leave  
  801900:	c3                   	ret    

00801901 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801901:	55                   	push   %ebp
  801902:	89 e5                	mov    %esp,%ebp
  801904:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801907:	e8 50 fe ff ff       	call   80175c <InitializeUHeap>
	if (size == 0) return NULL ;
  80190c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801910:	75 07                	jne    801919 <malloc+0x18>
  801912:	b8 00 00 00 00       	mov    $0x0,%eax
  801917:	eb 68                	jmp    801981 <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  801919:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801920:	8b 55 08             	mov    0x8(%ebp),%edx
  801923:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801926:	01 d0                	add    %edx,%eax
  801928:	48                   	dec    %eax
  801929:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80192c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80192f:	ba 00 00 00 00       	mov    $0x0,%edx
  801934:	f7 75 f4             	divl   -0xc(%ebp)
  801937:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80193a:	29 d0                	sub    %edx,%eax
  80193c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  80193f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801946:	e8 74 08 00 00       	call   8021bf <sys_isUHeapPlacementStrategyFIRSTFIT>
  80194b:	85 c0                	test   %eax,%eax
  80194d:	74 2d                	je     80197c <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  80194f:	83 ec 0c             	sub    $0xc,%esp
  801952:	ff 75 ec             	pushl  -0x14(%ebp)
  801955:	e8 52 0e 00 00       	call   8027ac <alloc_block_FF>
  80195a:	83 c4 10             	add    $0x10,%esp
  80195d:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  801960:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801964:	74 16                	je     80197c <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  801966:	83 ec 0c             	sub    $0xc,%esp
  801969:	ff 75 e8             	pushl  -0x18(%ebp)
  80196c:	e8 3b 0c 00 00       	call   8025ac <insert_sorted_allocList>
  801971:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  801974:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801977:	8b 40 08             	mov    0x8(%eax),%eax
  80197a:	eb 05                	jmp    801981 <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  80197c:	b8 00 00 00 00       	mov    $0x0,%eax

}
  801981:	c9                   	leave  
  801982:	c3                   	ret    

00801983 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801983:	55                   	push   %ebp
  801984:	89 e5                	mov    %esp,%ebp
  801986:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  801989:	8b 45 08             	mov    0x8(%ebp),%eax
  80198c:	83 ec 08             	sub    $0x8,%esp
  80198f:	50                   	push   %eax
  801990:	68 40 50 80 00       	push   $0x805040
  801995:	e8 ba 0b 00 00       	call   802554 <find_block>
  80199a:	83 c4 10             	add    $0x10,%esp
  80199d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  8019a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8019a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  8019a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8019ad:	0f 84 9f 00 00 00    	je     801a52 <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  8019b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b6:	83 ec 08             	sub    $0x8,%esp
  8019b9:	ff 75 f0             	pushl  -0x10(%ebp)
  8019bc:	50                   	push   %eax
  8019bd:	e8 f7 03 00 00       	call   801db9 <sys_free_user_mem>
  8019c2:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  8019c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8019c9:	75 14                	jne    8019df <free+0x5c>
  8019cb:	83 ec 04             	sub    $0x4,%esp
  8019ce:	68 f5 3e 80 00       	push   $0x803ef5
  8019d3:	6a 6a                	push   $0x6a
  8019d5:	68 13 3f 80 00       	push   $0x803f13
  8019da:	e8 3f ed ff ff       	call   80071e <_panic>
  8019df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e2:	8b 00                	mov    (%eax),%eax
  8019e4:	85 c0                	test   %eax,%eax
  8019e6:	74 10                	je     8019f8 <free+0x75>
  8019e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019eb:	8b 00                	mov    (%eax),%eax
  8019ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019f0:	8b 52 04             	mov    0x4(%edx),%edx
  8019f3:	89 50 04             	mov    %edx,0x4(%eax)
  8019f6:	eb 0b                	jmp    801a03 <free+0x80>
  8019f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019fb:	8b 40 04             	mov    0x4(%eax),%eax
  8019fe:	a3 44 50 80 00       	mov    %eax,0x805044
  801a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a06:	8b 40 04             	mov    0x4(%eax),%eax
  801a09:	85 c0                	test   %eax,%eax
  801a0b:	74 0f                	je     801a1c <free+0x99>
  801a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a10:	8b 40 04             	mov    0x4(%eax),%eax
  801a13:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a16:	8b 12                	mov    (%edx),%edx
  801a18:	89 10                	mov    %edx,(%eax)
  801a1a:	eb 0a                	jmp    801a26 <free+0xa3>
  801a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a1f:	8b 00                	mov    (%eax),%eax
  801a21:	a3 40 50 80 00       	mov    %eax,0x805040
  801a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a29:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a32:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801a39:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801a3e:	48                   	dec    %eax
  801a3f:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(blk);
  801a44:	83 ec 0c             	sub    $0xc,%esp
  801a47:	ff 75 f4             	pushl  -0xc(%ebp)
  801a4a:	e8 65 13 00 00       	call   802db4 <insert_sorted_with_merge_freeList>
  801a4f:	83 c4 10             	add    $0x10,%esp
	}
}
  801a52:	90                   	nop
  801a53:	c9                   	leave  
  801a54:	c3                   	ret    

00801a55 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801a55:	55                   	push   %ebp
  801a56:	89 e5                	mov    %esp,%ebp
  801a58:	83 ec 28             	sub    $0x28,%esp
  801a5b:	8b 45 10             	mov    0x10(%ebp),%eax
  801a5e:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a61:	e8 f6 fc ff ff       	call   80175c <InitializeUHeap>
	if (size == 0) return NULL ;
  801a66:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a6a:	75 0a                	jne    801a76 <smalloc+0x21>
  801a6c:	b8 00 00 00 00       	mov    $0x0,%eax
  801a71:	e9 af 00 00 00       	jmp    801b25 <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  801a76:	e8 44 07 00 00       	call   8021bf <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a7b:	83 f8 01             	cmp    $0x1,%eax
  801a7e:	0f 85 9c 00 00 00    	jne    801b20 <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  801a84:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801a8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a91:	01 d0                	add    %edx,%eax
  801a93:	48                   	dec    %eax
  801a94:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a9a:	ba 00 00 00 00       	mov    $0x0,%edx
  801a9f:	f7 75 f4             	divl   -0xc(%ebp)
  801aa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aa5:	29 d0                	sub    %edx,%eax
  801aa7:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  801aaa:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  801ab1:	76 07                	jbe    801aba <smalloc+0x65>
			return NULL;
  801ab3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ab8:	eb 6b                	jmp    801b25 <smalloc+0xd0>
		blk =alloc_block_FF(size);
  801aba:	83 ec 0c             	sub    $0xc,%esp
  801abd:	ff 75 0c             	pushl  0xc(%ebp)
  801ac0:	e8 e7 0c 00 00       	call   8027ac <alloc_block_FF>
  801ac5:	83 c4 10             	add    $0x10,%esp
  801ac8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  801acb:	83 ec 0c             	sub    $0xc,%esp
  801ace:	ff 75 ec             	pushl  -0x14(%ebp)
  801ad1:	e8 d6 0a 00 00       	call   8025ac <insert_sorted_allocList>
  801ad6:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  801ad9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801add:	75 07                	jne    801ae6 <smalloc+0x91>
		{
			return NULL;
  801adf:	b8 00 00 00 00       	mov    $0x0,%eax
  801ae4:	eb 3f                	jmp    801b25 <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  801ae6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ae9:	8b 40 08             	mov    0x8(%eax),%eax
  801aec:	89 c2                	mov    %eax,%edx
  801aee:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801af2:	52                   	push   %edx
  801af3:	50                   	push   %eax
  801af4:	ff 75 0c             	pushl  0xc(%ebp)
  801af7:	ff 75 08             	pushl  0x8(%ebp)
  801afa:	e8 45 04 00 00       	call   801f44 <sys_createSharedObject>
  801aff:	83 c4 10             	add    $0x10,%esp
  801b02:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  801b05:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801b09:	74 06                	je     801b11 <smalloc+0xbc>
  801b0b:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801b0f:	75 07                	jne    801b18 <smalloc+0xc3>
		{
			return NULL;
  801b11:	b8 00 00 00 00       	mov    $0x0,%eax
  801b16:	eb 0d                	jmp    801b25 <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  801b18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b1b:	8b 40 08             	mov    0x8(%eax),%eax
  801b1e:	eb 05                	jmp    801b25 <smalloc+0xd0>
		}
	}
	else
		return NULL;
  801b20:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b25:	c9                   	leave  
  801b26:	c3                   	ret    

00801b27 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801b27:	55                   	push   %ebp
  801b28:	89 e5                	mov    %esp,%ebp
  801b2a:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b2d:	e8 2a fc ff ff       	call   80175c <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801b32:	83 ec 08             	sub    $0x8,%esp
  801b35:	ff 75 0c             	pushl  0xc(%ebp)
  801b38:	ff 75 08             	pushl  0x8(%ebp)
  801b3b:	e8 2e 04 00 00       	call   801f6e <sys_getSizeOfSharedObject>
  801b40:	83 c4 10             	add    $0x10,%esp
  801b43:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  801b46:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801b4a:	75 0a                	jne    801b56 <sget+0x2f>
	{
		return NULL;
  801b4c:	b8 00 00 00 00       	mov    $0x0,%eax
  801b51:	e9 94 00 00 00       	jmp    801bea <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801b56:	e8 64 06 00 00       	call   8021bf <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b5b:	85 c0                	test   %eax,%eax
  801b5d:	0f 84 82 00 00 00    	je     801be5 <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  801b63:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  801b6a:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801b71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b77:	01 d0                	add    %edx,%eax
  801b79:	48                   	dec    %eax
  801b7a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801b7d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b80:	ba 00 00 00 00       	mov    $0x0,%edx
  801b85:	f7 75 ec             	divl   -0x14(%ebp)
  801b88:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b8b:	29 d0                	sub    %edx,%eax
  801b8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  801b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b93:	83 ec 0c             	sub    $0xc,%esp
  801b96:	50                   	push   %eax
  801b97:	e8 10 0c 00 00       	call   8027ac <alloc_block_FF>
  801b9c:	83 c4 10             	add    $0x10,%esp
  801b9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  801ba2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ba6:	75 07                	jne    801baf <sget+0x88>
		{
			return NULL;
  801ba8:	b8 00 00 00 00       	mov    $0x0,%eax
  801bad:	eb 3b                	jmp    801bea <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  801baf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bb2:	8b 40 08             	mov    0x8(%eax),%eax
  801bb5:	83 ec 04             	sub    $0x4,%esp
  801bb8:	50                   	push   %eax
  801bb9:	ff 75 0c             	pushl  0xc(%ebp)
  801bbc:	ff 75 08             	pushl  0x8(%ebp)
  801bbf:	e8 c7 03 00 00       	call   801f8b <sys_getSharedObject>
  801bc4:	83 c4 10             	add    $0x10,%esp
  801bc7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  801bca:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801bce:	74 06                	je     801bd6 <sget+0xaf>
  801bd0:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  801bd4:	75 07                	jne    801bdd <sget+0xb6>
		{
			return NULL;
  801bd6:	b8 00 00 00 00       	mov    $0x0,%eax
  801bdb:	eb 0d                	jmp    801bea <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  801bdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801be0:	8b 40 08             	mov    0x8(%eax),%eax
  801be3:	eb 05                	jmp    801bea <sget+0xc3>
		}
	}
	else
			return NULL;
  801be5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bea:	c9                   	leave  
  801beb:	c3                   	ret    

00801bec <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801bec:	55                   	push   %ebp
  801bed:	89 e5                	mov    %esp,%ebp
  801bef:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801bf2:	e8 65 fb ff ff       	call   80175c <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801bf7:	83 ec 04             	sub    $0x4,%esp
  801bfa:	68 20 3f 80 00       	push   $0x803f20
  801bff:	68 e1 00 00 00       	push   $0xe1
  801c04:	68 13 3f 80 00       	push   $0x803f13
  801c09:	e8 10 eb ff ff       	call   80071e <_panic>

00801c0e <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801c0e:	55                   	push   %ebp
  801c0f:	89 e5                	mov    %esp,%ebp
  801c11:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801c14:	83 ec 04             	sub    $0x4,%esp
  801c17:	68 48 3f 80 00       	push   $0x803f48
  801c1c:	68 f5 00 00 00       	push   $0xf5
  801c21:	68 13 3f 80 00       	push   $0x803f13
  801c26:	e8 f3 ea ff ff       	call   80071e <_panic>

00801c2b <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801c2b:	55                   	push   %ebp
  801c2c:	89 e5                	mov    %esp,%ebp
  801c2e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c31:	83 ec 04             	sub    $0x4,%esp
  801c34:	68 6c 3f 80 00       	push   $0x803f6c
  801c39:	68 00 01 00 00       	push   $0x100
  801c3e:	68 13 3f 80 00       	push   $0x803f13
  801c43:	e8 d6 ea ff ff       	call   80071e <_panic>

00801c48 <shrink>:

}
void shrink(uint32 newSize)
{
  801c48:	55                   	push   %ebp
  801c49:	89 e5                	mov    %esp,%ebp
  801c4b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c4e:	83 ec 04             	sub    $0x4,%esp
  801c51:	68 6c 3f 80 00       	push   $0x803f6c
  801c56:	68 05 01 00 00       	push   $0x105
  801c5b:	68 13 3f 80 00       	push   $0x803f13
  801c60:	e8 b9 ea ff ff       	call   80071e <_panic>

00801c65 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801c65:	55                   	push   %ebp
  801c66:	89 e5                	mov    %esp,%ebp
  801c68:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c6b:	83 ec 04             	sub    $0x4,%esp
  801c6e:	68 6c 3f 80 00       	push   $0x803f6c
  801c73:	68 0a 01 00 00       	push   $0x10a
  801c78:	68 13 3f 80 00       	push   $0x803f13
  801c7d:	e8 9c ea ff ff       	call   80071e <_panic>

00801c82 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
  801c85:	57                   	push   %edi
  801c86:	56                   	push   %esi
  801c87:	53                   	push   %ebx
  801c88:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c91:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c94:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c97:	8b 7d 18             	mov    0x18(%ebp),%edi
  801c9a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801c9d:	cd 30                	int    $0x30
  801c9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801ca2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ca5:	83 c4 10             	add    $0x10,%esp
  801ca8:	5b                   	pop    %ebx
  801ca9:	5e                   	pop    %esi
  801caa:	5f                   	pop    %edi
  801cab:	5d                   	pop    %ebp
  801cac:	c3                   	ret    

00801cad <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801cad:	55                   	push   %ebp
  801cae:	89 e5                	mov    %esp,%ebp
  801cb0:	83 ec 04             	sub    $0x4,%esp
  801cb3:	8b 45 10             	mov    0x10(%ebp),%eax
  801cb6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801cb9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	52                   	push   %edx
  801cc5:	ff 75 0c             	pushl  0xc(%ebp)
  801cc8:	50                   	push   %eax
  801cc9:	6a 00                	push   $0x0
  801ccb:	e8 b2 ff ff ff       	call   801c82 <syscall>
  801cd0:	83 c4 18             	add    $0x18,%esp
}
  801cd3:	90                   	nop
  801cd4:	c9                   	leave  
  801cd5:	c3                   	ret    

00801cd6 <sys_cgetc>:

int
sys_cgetc(void)
{
  801cd6:	55                   	push   %ebp
  801cd7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 01                	push   $0x1
  801ce5:	e8 98 ff ff ff       	call   801c82 <syscall>
  801cea:	83 c4 18             	add    $0x18,%esp
}
  801ced:	c9                   	leave  
  801cee:	c3                   	ret    

00801cef <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801cef:	55                   	push   %ebp
  801cf0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801cf2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	52                   	push   %edx
  801cff:	50                   	push   %eax
  801d00:	6a 05                	push   $0x5
  801d02:	e8 7b ff ff ff       	call   801c82 <syscall>
  801d07:	83 c4 18             	add    $0x18,%esp
}
  801d0a:	c9                   	leave  
  801d0b:	c3                   	ret    

00801d0c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801d0c:	55                   	push   %ebp
  801d0d:	89 e5                	mov    %esp,%ebp
  801d0f:	56                   	push   %esi
  801d10:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801d11:	8b 75 18             	mov    0x18(%ebp),%esi
  801d14:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d17:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d20:	56                   	push   %esi
  801d21:	53                   	push   %ebx
  801d22:	51                   	push   %ecx
  801d23:	52                   	push   %edx
  801d24:	50                   	push   %eax
  801d25:	6a 06                	push   $0x6
  801d27:	e8 56 ff ff ff       	call   801c82 <syscall>
  801d2c:	83 c4 18             	add    $0x18,%esp
}
  801d2f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d32:	5b                   	pop    %ebx
  801d33:	5e                   	pop    %esi
  801d34:	5d                   	pop    %ebp
  801d35:	c3                   	ret    

00801d36 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801d36:	55                   	push   %ebp
  801d37:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801d39:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	52                   	push   %edx
  801d46:	50                   	push   %eax
  801d47:	6a 07                	push   $0x7
  801d49:	e8 34 ff ff ff       	call   801c82 <syscall>
  801d4e:	83 c4 18             	add    $0x18,%esp
}
  801d51:	c9                   	leave  
  801d52:	c3                   	ret    

00801d53 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801d53:	55                   	push   %ebp
  801d54:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	ff 75 0c             	pushl  0xc(%ebp)
  801d5f:	ff 75 08             	pushl  0x8(%ebp)
  801d62:	6a 08                	push   $0x8
  801d64:	e8 19 ff ff ff       	call   801c82 <syscall>
  801d69:	83 c4 18             	add    $0x18,%esp
}
  801d6c:	c9                   	leave  
  801d6d:	c3                   	ret    

00801d6e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801d6e:	55                   	push   %ebp
  801d6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 09                	push   $0x9
  801d7d:	e8 00 ff ff ff       	call   801c82 <syscall>
  801d82:	83 c4 18             	add    $0x18,%esp
}
  801d85:	c9                   	leave  
  801d86:	c3                   	ret    

00801d87 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801d87:	55                   	push   %ebp
  801d88:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	6a 00                	push   $0x0
  801d94:	6a 0a                	push   $0xa
  801d96:	e8 e7 fe ff ff       	call   801c82 <syscall>
  801d9b:	83 c4 18             	add    $0x18,%esp
}
  801d9e:	c9                   	leave  
  801d9f:	c3                   	ret    

00801da0 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801da0:	55                   	push   %ebp
  801da1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	6a 0b                	push   $0xb
  801daf:	e8 ce fe ff ff       	call   801c82 <syscall>
  801db4:	83 c4 18             	add    $0x18,%esp
}
  801db7:	c9                   	leave  
  801db8:	c3                   	ret    

00801db9 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801db9:	55                   	push   %ebp
  801dba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	ff 75 0c             	pushl  0xc(%ebp)
  801dc5:	ff 75 08             	pushl  0x8(%ebp)
  801dc8:	6a 0f                	push   $0xf
  801dca:	e8 b3 fe ff ff       	call   801c82 <syscall>
  801dcf:	83 c4 18             	add    $0x18,%esp
	return;
  801dd2:	90                   	nop
}
  801dd3:	c9                   	leave  
  801dd4:	c3                   	ret    

00801dd5 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801dd5:	55                   	push   %ebp
  801dd6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	ff 75 0c             	pushl  0xc(%ebp)
  801de1:	ff 75 08             	pushl  0x8(%ebp)
  801de4:	6a 10                	push   $0x10
  801de6:	e8 97 fe ff ff       	call   801c82 <syscall>
  801deb:	83 c4 18             	add    $0x18,%esp
	return ;
  801dee:	90                   	nop
}
  801def:	c9                   	leave  
  801df0:	c3                   	ret    

00801df1 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801df1:	55                   	push   %ebp
  801df2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	ff 75 10             	pushl  0x10(%ebp)
  801dfb:	ff 75 0c             	pushl  0xc(%ebp)
  801dfe:	ff 75 08             	pushl  0x8(%ebp)
  801e01:	6a 11                	push   $0x11
  801e03:	e8 7a fe ff ff       	call   801c82 <syscall>
  801e08:	83 c4 18             	add    $0x18,%esp
	return ;
  801e0b:	90                   	nop
}
  801e0c:	c9                   	leave  
  801e0d:	c3                   	ret    

00801e0e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801e0e:	55                   	push   %ebp
  801e0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	6a 00                	push   $0x0
  801e1b:	6a 0c                	push   $0xc
  801e1d:	e8 60 fe ff ff       	call   801c82 <syscall>
  801e22:	83 c4 18             	add    $0x18,%esp
}
  801e25:	c9                   	leave  
  801e26:	c3                   	ret    

00801e27 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801e27:	55                   	push   %ebp
  801e28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	ff 75 08             	pushl  0x8(%ebp)
  801e35:	6a 0d                	push   $0xd
  801e37:	e8 46 fe ff ff       	call   801c82 <syscall>
  801e3c:	83 c4 18             	add    $0x18,%esp
}
  801e3f:	c9                   	leave  
  801e40:	c3                   	ret    

00801e41 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801e41:	55                   	push   %ebp
  801e42:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	6a 00                	push   $0x0
  801e4a:	6a 00                	push   $0x0
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 0e                	push   $0xe
  801e50:	e8 2d fe ff ff       	call   801c82 <syscall>
  801e55:	83 c4 18             	add    $0x18,%esp
}
  801e58:	90                   	nop
  801e59:	c9                   	leave  
  801e5a:	c3                   	ret    

00801e5b <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801e5b:	55                   	push   %ebp
  801e5c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 00                	push   $0x0
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	6a 13                	push   $0x13
  801e6a:	e8 13 fe ff ff       	call   801c82 <syscall>
  801e6f:	83 c4 18             	add    $0x18,%esp
}
  801e72:	90                   	nop
  801e73:	c9                   	leave  
  801e74:	c3                   	ret    

00801e75 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801e75:	55                   	push   %ebp
  801e76:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 00                	push   $0x0
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 00                	push   $0x0
  801e82:	6a 14                	push   $0x14
  801e84:	e8 f9 fd ff ff       	call   801c82 <syscall>
  801e89:	83 c4 18             	add    $0x18,%esp
}
  801e8c:	90                   	nop
  801e8d:	c9                   	leave  
  801e8e:	c3                   	ret    

00801e8f <sys_cputc>:


void
sys_cputc(const char c)
{
  801e8f:	55                   	push   %ebp
  801e90:	89 e5                	mov    %esp,%ebp
  801e92:	83 ec 04             	sub    $0x4,%esp
  801e95:	8b 45 08             	mov    0x8(%ebp),%eax
  801e98:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801e9b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 00                	push   $0x0
  801ea7:	50                   	push   %eax
  801ea8:	6a 15                	push   $0x15
  801eaa:	e8 d3 fd ff ff       	call   801c82 <syscall>
  801eaf:	83 c4 18             	add    $0x18,%esp
}
  801eb2:	90                   	nop
  801eb3:	c9                   	leave  
  801eb4:	c3                   	ret    

00801eb5 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801eb5:	55                   	push   %ebp
  801eb6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801eb8:	6a 00                	push   $0x0
  801eba:	6a 00                	push   $0x0
  801ebc:	6a 00                	push   $0x0
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 16                	push   $0x16
  801ec4:	e8 b9 fd ff ff       	call   801c82 <syscall>
  801ec9:	83 c4 18             	add    $0x18,%esp
}
  801ecc:	90                   	nop
  801ecd:	c9                   	leave  
  801ece:	c3                   	ret    

00801ecf <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801ecf:	55                   	push   %ebp
  801ed0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed5:	6a 00                	push   $0x0
  801ed7:	6a 00                	push   $0x0
  801ed9:	6a 00                	push   $0x0
  801edb:	ff 75 0c             	pushl  0xc(%ebp)
  801ede:	50                   	push   %eax
  801edf:	6a 17                	push   $0x17
  801ee1:	e8 9c fd ff ff       	call   801c82 <syscall>
  801ee6:	83 c4 18             	add    $0x18,%esp
}
  801ee9:	c9                   	leave  
  801eea:	c3                   	ret    

00801eeb <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801eeb:	55                   	push   %ebp
  801eec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801eee:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef4:	6a 00                	push   $0x0
  801ef6:	6a 00                	push   $0x0
  801ef8:	6a 00                	push   $0x0
  801efa:	52                   	push   %edx
  801efb:	50                   	push   %eax
  801efc:	6a 1a                	push   $0x1a
  801efe:	e8 7f fd ff ff       	call   801c82 <syscall>
  801f03:	83 c4 18             	add    $0x18,%esp
}
  801f06:	c9                   	leave  
  801f07:	c3                   	ret    

00801f08 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f08:	55                   	push   %ebp
  801f09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f11:	6a 00                	push   $0x0
  801f13:	6a 00                	push   $0x0
  801f15:	6a 00                	push   $0x0
  801f17:	52                   	push   %edx
  801f18:	50                   	push   %eax
  801f19:	6a 18                	push   $0x18
  801f1b:	e8 62 fd ff ff       	call   801c82 <syscall>
  801f20:	83 c4 18             	add    $0x18,%esp
}
  801f23:	90                   	nop
  801f24:	c9                   	leave  
  801f25:	c3                   	ret    

00801f26 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f26:	55                   	push   %ebp
  801f27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f29:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2f:	6a 00                	push   $0x0
  801f31:	6a 00                	push   $0x0
  801f33:	6a 00                	push   $0x0
  801f35:	52                   	push   %edx
  801f36:	50                   	push   %eax
  801f37:	6a 19                	push   $0x19
  801f39:	e8 44 fd ff ff       	call   801c82 <syscall>
  801f3e:	83 c4 18             	add    $0x18,%esp
}
  801f41:	90                   	nop
  801f42:	c9                   	leave  
  801f43:	c3                   	ret    

00801f44 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801f44:	55                   	push   %ebp
  801f45:	89 e5                	mov    %esp,%ebp
  801f47:	83 ec 04             	sub    $0x4,%esp
  801f4a:	8b 45 10             	mov    0x10(%ebp),%eax
  801f4d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801f50:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f53:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f57:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5a:	6a 00                	push   $0x0
  801f5c:	51                   	push   %ecx
  801f5d:	52                   	push   %edx
  801f5e:	ff 75 0c             	pushl  0xc(%ebp)
  801f61:	50                   	push   %eax
  801f62:	6a 1b                	push   $0x1b
  801f64:	e8 19 fd ff ff       	call   801c82 <syscall>
  801f69:	83 c4 18             	add    $0x18,%esp
}
  801f6c:	c9                   	leave  
  801f6d:	c3                   	ret    

00801f6e <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801f6e:	55                   	push   %ebp
  801f6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801f71:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f74:	8b 45 08             	mov    0x8(%ebp),%eax
  801f77:	6a 00                	push   $0x0
  801f79:	6a 00                	push   $0x0
  801f7b:	6a 00                	push   $0x0
  801f7d:	52                   	push   %edx
  801f7e:	50                   	push   %eax
  801f7f:	6a 1c                	push   $0x1c
  801f81:	e8 fc fc ff ff       	call   801c82 <syscall>
  801f86:	83 c4 18             	add    $0x18,%esp
}
  801f89:	c9                   	leave  
  801f8a:	c3                   	ret    

00801f8b <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801f8b:	55                   	push   %ebp
  801f8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801f8e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f91:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f94:	8b 45 08             	mov    0x8(%ebp),%eax
  801f97:	6a 00                	push   $0x0
  801f99:	6a 00                	push   $0x0
  801f9b:	51                   	push   %ecx
  801f9c:	52                   	push   %edx
  801f9d:	50                   	push   %eax
  801f9e:	6a 1d                	push   $0x1d
  801fa0:	e8 dd fc ff ff       	call   801c82 <syscall>
  801fa5:	83 c4 18             	add    $0x18,%esp
}
  801fa8:	c9                   	leave  
  801fa9:	c3                   	ret    

00801faa <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801faa:	55                   	push   %ebp
  801fab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801fad:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb3:	6a 00                	push   $0x0
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 00                	push   $0x0
  801fb9:	52                   	push   %edx
  801fba:	50                   	push   %eax
  801fbb:	6a 1e                	push   $0x1e
  801fbd:	e8 c0 fc ff ff       	call   801c82 <syscall>
  801fc2:	83 c4 18             	add    $0x18,%esp
}
  801fc5:	c9                   	leave  
  801fc6:	c3                   	ret    

00801fc7 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801fc7:	55                   	push   %ebp
  801fc8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801fca:	6a 00                	push   $0x0
  801fcc:	6a 00                	push   $0x0
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 1f                	push   $0x1f
  801fd6:	e8 a7 fc ff ff       	call   801c82 <syscall>
  801fdb:	83 c4 18             	add    $0x18,%esp
}
  801fde:	c9                   	leave  
  801fdf:	c3                   	ret    

00801fe0 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801fe0:	55                   	push   %ebp
  801fe1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe6:	6a 00                	push   $0x0
  801fe8:	ff 75 14             	pushl  0x14(%ebp)
  801feb:	ff 75 10             	pushl  0x10(%ebp)
  801fee:	ff 75 0c             	pushl  0xc(%ebp)
  801ff1:	50                   	push   %eax
  801ff2:	6a 20                	push   $0x20
  801ff4:	e8 89 fc ff ff       	call   801c82 <syscall>
  801ff9:	83 c4 18             	add    $0x18,%esp
}
  801ffc:	c9                   	leave  
  801ffd:	c3                   	ret    

00801ffe <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801ffe:	55                   	push   %ebp
  801fff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802001:	8b 45 08             	mov    0x8(%ebp),%eax
  802004:	6a 00                	push   $0x0
  802006:	6a 00                	push   $0x0
  802008:	6a 00                	push   $0x0
  80200a:	6a 00                	push   $0x0
  80200c:	50                   	push   %eax
  80200d:	6a 21                	push   $0x21
  80200f:	e8 6e fc ff ff       	call   801c82 <syscall>
  802014:	83 c4 18             	add    $0x18,%esp
}
  802017:	90                   	nop
  802018:	c9                   	leave  
  802019:	c3                   	ret    

0080201a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80201a:	55                   	push   %ebp
  80201b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80201d:	8b 45 08             	mov    0x8(%ebp),%eax
  802020:	6a 00                	push   $0x0
  802022:	6a 00                	push   $0x0
  802024:	6a 00                	push   $0x0
  802026:	6a 00                	push   $0x0
  802028:	50                   	push   %eax
  802029:	6a 22                	push   $0x22
  80202b:	e8 52 fc ff ff       	call   801c82 <syscall>
  802030:	83 c4 18             	add    $0x18,%esp
}
  802033:	c9                   	leave  
  802034:	c3                   	ret    

00802035 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802035:	55                   	push   %ebp
  802036:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802038:	6a 00                	push   $0x0
  80203a:	6a 00                	push   $0x0
  80203c:	6a 00                	push   $0x0
  80203e:	6a 00                	push   $0x0
  802040:	6a 00                	push   $0x0
  802042:	6a 02                	push   $0x2
  802044:	e8 39 fc ff ff       	call   801c82 <syscall>
  802049:	83 c4 18             	add    $0x18,%esp
}
  80204c:	c9                   	leave  
  80204d:	c3                   	ret    

0080204e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80204e:	55                   	push   %ebp
  80204f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802051:	6a 00                	push   $0x0
  802053:	6a 00                	push   $0x0
  802055:	6a 00                	push   $0x0
  802057:	6a 00                	push   $0x0
  802059:	6a 00                	push   $0x0
  80205b:	6a 03                	push   $0x3
  80205d:	e8 20 fc ff ff       	call   801c82 <syscall>
  802062:	83 c4 18             	add    $0x18,%esp
}
  802065:	c9                   	leave  
  802066:	c3                   	ret    

00802067 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802067:	55                   	push   %ebp
  802068:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80206a:	6a 00                	push   $0x0
  80206c:	6a 00                	push   $0x0
  80206e:	6a 00                	push   $0x0
  802070:	6a 00                	push   $0x0
  802072:	6a 00                	push   $0x0
  802074:	6a 04                	push   $0x4
  802076:	e8 07 fc ff ff       	call   801c82 <syscall>
  80207b:	83 c4 18             	add    $0x18,%esp
}
  80207e:	c9                   	leave  
  80207f:	c3                   	ret    

00802080 <sys_exit_env>:


void sys_exit_env(void)
{
  802080:	55                   	push   %ebp
  802081:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802083:	6a 00                	push   $0x0
  802085:	6a 00                	push   $0x0
  802087:	6a 00                	push   $0x0
  802089:	6a 00                	push   $0x0
  80208b:	6a 00                	push   $0x0
  80208d:	6a 23                	push   $0x23
  80208f:	e8 ee fb ff ff       	call   801c82 <syscall>
  802094:	83 c4 18             	add    $0x18,%esp
}
  802097:	90                   	nop
  802098:	c9                   	leave  
  802099:	c3                   	ret    

0080209a <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80209a:	55                   	push   %ebp
  80209b:	89 e5                	mov    %esp,%ebp
  80209d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8020a0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020a3:	8d 50 04             	lea    0x4(%eax),%edx
  8020a6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020a9:	6a 00                	push   $0x0
  8020ab:	6a 00                	push   $0x0
  8020ad:	6a 00                	push   $0x0
  8020af:	52                   	push   %edx
  8020b0:	50                   	push   %eax
  8020b1:	6a 24                	push   $0x24
  8020b3:	e8 ca fb ff ff       	call   801c82 <syscall>
  8020b8:	83 c4 18             	add    $0x18,%esp
	return result;
  8020bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020c1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8020c4:	89 01                	mov    %eax,(%ecx)
  8020c6:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8020c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cc:	c9                   	leave  
  8020cd:	c2 04 00             	ret    $0x4

008020d0 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8020d0:	55                   	push   %ebp
  8020d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8020d3:	6a 00                	push   $0x0
  8020d5:	6a 00                	push   $0x0
  8020d7:	ff 75 10             	pushl  0x10(%ebp)
  8020da:	ff 75 0c             	pushl  0xc(%ebp)
  8020dd:	ff 75 08             	pushl  0x8(%ebp)
  8020e0:	6a 12                	push   $0x12
  8020e2:	e8 9b fb ff ff       	call   801c82 <syscall>
  8020e7:	83 c4 18             	add    $0x18,%esp
	return ;
  8020ea:	90                   	nop
}
  8020eb:	c9                   	leave  
  8020ec:	c3                   	ret    

008020ed <sys_rcr2>:
uint32 sys_rcr2()
{
  8020ed:	55                   	push   %ebp
  8020ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8020f0:	6a 00                	push   $0x0
  8020f2:	6a 00                	push   $0x0
  8020f4:	6a 00                	push   $0x0
  8020f6:	6a 00                	push   $0x0
  8020f8:	6a 00                	push   $0x0
  8020fa:	6a 25                	push   $0x25
  8020fc:	e8 81 fb ff ff       	call   801c82 <syscall>
  802101:	83 c4 18             	add    $0x18,%esp
}
  802104:	c9                   	leave  
  802105:	c3                   	ret    

00802106 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802106:	55                   	push   %ebp
  802107:	89 e5                	mov    %esp,%ebp
  802109:	83 ec 04             	sub    $0x4,%esp
  80210c:	8b 45 08             	mov    0x8(%ebp),%eax
  80210f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802112:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802116:	6a 00                	push   $0x0
  802118:	6a 00                	push   $0x0
  80211a:	6a 00                	push   $0x0
  80211c:	6a 00                	push   $0x0
  80211e:	50                   	push   %eax
  80211f:	6a 26                	push   $0x26
  802121:	e8 5c fb ff ff       	call   801c82 <syscall>
  802126:	83 c4 18             	add    $0x18,%esp
	return ;
  802129:	90                   	nop
}
  80212a:	c9                   	leave  
  80212b:	c3                   	ret    

0080212c <rsttst>:
void rsttst()
{
  80212c:	55                   	push   %ebp
  80212d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80212f:	6a 00                	push   $0x0
  802131:	6a 00                	push   $0x0
  802133:	6a 00                	push   $0x0
  802135:	6a 00                	push   $0x0
  802137:	6a 00                	push   $0x0
  802139:	6a 28                	push   $0x28
  80213b:	e8 42 fb ff ff       	call   801c82 <syscall>
  802140:	83 c4 18             	add    $0x18,%esp
	return ;
  802143:	90                   	nop
}
  802144:	c9                   	leave  
  802145:	c3                   	ret    

00802146 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802146:	55                   	push   %ebp
  802147:	89 e5                	mov    %esp,%ebp
  802149:	83 ec 04             	sub    $0x4,%esp
  80214c:	8b 45 14             	mov    0x14(%ebp),%eax
  80214f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802152:	8b 55 18             	mov    0x18(%ebp),%edx
  802155:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802159:	52                   	push   %edx
  80215a:	50                   	push   %eax
  80215b:	ff 75 10             	pushl  0x10(%ebp)
  80215e:	ff 75 0c             	pushl  0xc(%ebp)
  802161:	ff 75 08             	pushl  0x8(%ebp)
  802164:	6a 27                	push   $0x27
  802166:	e8 17 fb ff ff       	call   801c82 <syscall>
  80216b:	83 c4 18             	add    $0x18,%esp
	return ;
  80216e:	90                   	nop
}
  80216f:	c9                   	leave  
  802170:	c3                   	ret    

00802171 <chktst>:
void chktst(uint32 n)
{
  802171:	55                   	push   %ebp
  802172:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802174:	6a 00                	push   $0x0
  802176:	6a 00                	push   $0x0
  802178:	6a 00                	push   $0x0
  80217a:	6a 00                	push   $0x0
  80217c:	ff 75 08             	pushl  0x8(%ebp)
  80217f:	6a 29                	push   $0x29
  802181:	e8 fc fa ff ff       	call   801c82 <syscall>
  802186:	83 c4 18             	add    $0x18,%esp
	return ;
  802189:	90                   	nop
}
  80218a:	c9                   	leave  
  80218b:	c3                   	ret    

0080218c <inctst>:

void inctst()
{
  80218c:	55                   	push   %ebp
  80218d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80218f:	6a 00                	push   $0x0
  802191:	6a 00                	push   $0x0
  802193:	6a 00                	push   $0x0
  802195:	6a 00                	push   $0x0
  802197:	6a 00                	push   $0x0
  802199:	6a 2a                	push   $0x2a
  80219b:	e8 e2 fa ff ff       	call   801c82 <syscall>
  8021a0:	83 c4 18             	add    $0x18,%esp
	return ;
  8021a3:	90                   	nop
}
  8021a4:	c9                   	leave  
  8021a5:	c3                   	ret    

008021a6 <gettst>:
uint32 gettst()
{
  8021a6:	55                   	push   %ebp
  8021a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8021a9:	6a 00                	push   $0x0
  8021ab:	6a 00                	push   $0x0
  8021ad:	6a 00                	push   $0x0
  8021af:	6a 00                	push   $0x0
  8021b1:	6a 00                	push   $0x0
  8021b3:	6a 2b                	push   $0x2b
  8021b5:	e8 c8 fa ff ff       	call   801c82 <syscall>
  8021ba:	83 c4 18             	add    $0x18,%esp
}
  8021bd:	c9                   	leave  
  8021be:	c3                   	ret    

008021bf <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8021bf:	55                   	push   %ebp
  8021c0:	89 e5                	mov    %esp,%ebp
  8021c2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021c5:	6a 00                	push   $0x0
  8021c7:	6a 00                	push   $0x0
  8021c9:	6a 00                	push   $0x0
  8021cb:	6a 00                	push   $0x0
  8021cd:	6a 00                	push   $0x0
  8021cf:	6a 2c                	push   $0x2c
  8021d1:	e8 ac fa ff ff       	call   801c82 <syscall>
  8021d6:	83 c4 18             	add    $0x18,%esp
  8021d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8021dc:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8021e0:	75 07                	jne    8021e9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8021e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8021e7:	eb 05                	jmp    8021ee <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8021e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021ee:	c9                   	leave  
  8021ef:	c3                   	ret    

008021f0 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8021f0:	55                   	push   %ebp
  8021f1:	89 e5                	mov    %esp,%ebp
  8021f3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021f6:	6a 00                	push   $0x0
  8021f8:	6a 00                	push   $0x0
  8021fa:	6a 00                	push   $0x0
  8021fc:	6a 00                	push   $0x0
  8021fe:	6a 00                	push   $0x0
  802200:	6a 2c                	push   $0x2c
  802202:	e8 7b fa ff ff       	call   801c82 <syscall>
  802207:	83 c4 18             	add    $0x18,%esp
  80220a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80220d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802211:	75 07                	jne    80221a <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802213:	b8 01 00 00 00       	mov    $0x1,%eax
  802218:	eb 05                	jmp    80221f <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80221a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80221f:	c9                   	leave  
  802220:	c3                   	ret    

00802221 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802221:	55                   	push   %ebp
  802222:	89 e5                	mov    %esp,%ebp
  802224:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802227:	6a 00                	push   $0x0
  802229:	6a 00                	push   $0x0
  80222b:	6a 00                	push   $0x0
  80222d:	6a 00                	push   $0x0
  80222f:	6a 00                	push   $0x0
  802231:	6a 2c                	push   $0x2c
  802233:	e8 4a fa ff ff       	call   801c82 <syscall>
  802238:	83 c4 18             	add    $0x18,%esp
  80223b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80223e:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802242:	75 07                	jne    80224b <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802244:	b8 01 00 00 00       	mov    $0x1,%eax
  802249:	eb 05                	jmp    802250 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80224b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802250:	c9                   	leave  
  802251:	c3                   	ret    

00802252 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802252:	55                   	push   %ebp
  802253:	89 e5                	mov    %esp,%ebp
  802255:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802258:	6a 00                	push   $0x0
  80225a:	6a 00                	push   $0x0
  80225c:	6a 00                	push   $0x0
  80225e:	6a 00                	push   $0x0
  802260:	6a 00                	push   $0x0
  802262:	6a 2c                	push   $0x2c
  802264:	e8 19 fa ff ff       	call   801c82 <syscall>
  802269:	83 c4 18             	add    $0x18,%esp
  80226c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80226f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802273:	75 07                	jne    80227c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802275:	b8 01 00 00 00       	mov    $0x1,%eax
  80227a:	eb 05                	jmp    802281 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80227c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802281:	c9                   	leave  
  802282:	c3                   	ret    

00802283 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802283:	55                   	push   %ebp
  802284:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802286:	6a 00                	push   $0x0
  802288:	6a 00                	push   $0x0
  80228a:	6a 00                	push   $0x0
  80228c:	6a 00                	push   $0x0
  80228e:	ff 75 08             	pushl  0x8(%ebp)
  802291:	6a 2d                	push   $0x2d
  802293:	e8 ea f9 ff ff       	call   801c82 <syscall>
  802298:	83 c4 18             	add    $0x18,%esp
	return ;
  80229b:	90                   	nop
}
  80229c:	c9                   	leave  
  80229d:	c3                   	ret    

0080229e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80229e:	55                   	push   %ebp
  80229f:	89 e5                	mov    %esp,%ebp
  8022a1:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8022a2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022a5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ae:	6a 00                	push   $0x0
  8022b0:	53                   	push   %ebx
  8022b1:	51                   	push   %ecx
  8022b2:	52                   	push   %edx
  8022b3:	50                   	push   %eax
  8022b4:	6a 2e                	push   $0x2e
  8022b6:	e8 c7 f9 ff ff       	call   801c82 <syscall>
  8022bb:	83 c4 18             	add    $0x18,%esp
}
  8022be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022c1:	c9                   	leave  
  8022c2:	c3                   	ret    

008022c3 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8022c3:	55                   	push   %ebp
  8022c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8022c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cc:	6a 00                	push   $0x0
  8022ce:	6a 00                	push   $0x0
  8022d0:	6a 00                	push   $0x0
  8022d2:	52                   	push   %edx
  8022d3:	50                   	push   %eax
  8022d4:	6a 2f                	push   $0x2f
  8022d6:	e8 a7 f9 ff ff       	call   801c82 <syscall>
  8022db:	83 c4 18             	add    $0x18,%esp
}
  8022de:	c9                   	leave  
  8022df:	c3                   	ret    

008022e0 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8022e0:	55                   	push   %ebp
  8022e1:	89 e5                	mov    %esp,%ebp
  8022e3:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8022e6:	83 ec 0c             	sub    $0xc,%esp
  8022e9:	68 7c 3f 80 00       	push   $0x803f7c
  8022ee:	e8 df e6 ff ff       	call   8009d2 <cprintf>
  8022f3:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8022f6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8022fd:	83 ec 0c             	sub    $0xc,%esp
  802300:	68 a8 3f 80 00       	push   $0x803fa8
  802305:	e8 c8 e6 ff ff       	call   8009d2 <cprintf>
  80230a:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80230d:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802311:	a1 38 51 80 00       	mov    0x805138,%eax
  802316:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802319:	eb 56                	jmp    802371 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80231b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80231f:	74 1c                	je     80233d <print_mem_block_lists+0x5d>
  802321:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802324:	8b 50 08             	mov    0x8(%eax),%edx
  802327:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80232a:	8b 48 08             	mov    0x8(%eax),%ecx
  80232d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802330:	8b 40 0c             	mov    0xc(%eax),%eax
  802333:	01 c8                	add    %ecx,%eax
  802335:	39 c2                	cmp    %eax,%edx
  802337:	73 04                	jae    80233d <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802339:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80233d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802340:	8b 50 08             	mov    0x8(%eax),%edx
  802343:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802346:	8b 40 0c             	mov    0xc(%eax),%eax
  802349:	01 c2                	add    %eax,%edx
  80234b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234e:	8b 40 08             	mov    0x8(%eax),%eax
  802351:	83 ec 04             	sub    $0x4,%esp
  802354:	52                   	push   %edx
  802355:	50                   	push   %eax
  802356:	68 bd 3f 80 00       	push   $0x803fbd
  80235b:	e8 72 e6 ff ff       	call   8009d2 <cprintf>
  802360:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802363:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802366:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802369:	a1 40 51 80 00       	mov    0x805140,%eax
  80236e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802371:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802375:	74 07                	je     80237e <print_mem_block_lists+0x9e>
  802377:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237a:	8b 00                	mov    (%eax),%eax
  80237c:	eb 05                	jmp    802383 <print_mem_block_lists+0xa3>
  80237e:	b8 00 00 00 00       	mov    $0x0,%eax
  802383:	a3 40 51 80 00       	mov    %eax,0x805140
  802388:	a1 40 51 80 00       	mov    0x805140,%eax
  80238d:	85 c0                	test   %eax,%eax
  80238f:	75 8a                	jne    80231b <print_mem_block_lists+0x3b>
  802391:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802395:	75 84                	jne    80231b <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802397:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80239b:	75 10                	jne    8023ad <print_mem_block_lists+0xcd>
  80239d:	83 ec 0c             	sub    $0xc,%esp
  8023a0:	68 cc 3f 80 00       	push   $0x803fcc
  8023a5:	e8 28 e6 ff ff       	call   8009d2 <cprintf>
  8023aa:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8023ad:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8023b4:	83 ec 0c             	sub    $0xc,%esp
  8023b7:	68 f0 3f 80 00       	push   $0x803ff0
  8023bc:	e8 11 e6 ff ff       	call   8009d2 <cprintf>
  8023c1:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8023c4:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8023c8:	a1 40 50 80 00       	mov    0x805040,%eax
  8023cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023d0:	eb 56                	jmp    802428 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8023d2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023d6:	74 1c                	je     8023f4 <print_mem_block_lists+0x114>
  8023d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023db:	8b 50 08             	mov    0x8(%eax),%edx
  8023de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e1:	8b 48 08             	mov    0x8(%eax),%ecx
  8023e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8023ea:	01 c8                	add    %ecx,%eax
  8023ec:	39 c2                	cmp    %eax,%edx
  8023ee:	73 04                	jae    8023f4 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8023f0:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8023f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f7:	8b 50 08             	mov    0x8(%eax),%edx
  8023fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fd:	8b 40 0c             	mov    0xc(%eax),%eax
  802400:	01 c2                	add    %eax,%edx
  802402:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802405:	8b 40 08             	mov    0x8(%eax),%eax
  802408:	83 ec 04             	sub    $0x4,%esp
  80240b:	52                   	push   %edx
  80240c:	50                   	push   %eax
  80240d:	68 bd 3f 80 00       	push   $0x803fbd
  802412:	e8 bb e5 ff ff       	call   8009d2 <cprintf>
  802417:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80241a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802420:	a1 48 50 80 00       	mov    0x805048,%eax
  802425:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802428:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80242c:	74 07                	je     802435 <print_mem_block_lists+0x155>
  80242e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802431:	8b 00                	mov    (%eax),%eax
  802433:	eb 05                	jmp    80243a <print_mem_block_lists+0x15a>
  802435:	b8 00 00 00 00       	mov    $0x0,%eax
  80243a:	a3 48 50 80 00       	mov    %eax,0x805048
  80243f:	a1 48 50 80 00       	mov    0x805048,%eax
  802444:	85 c0                	test   %eax,%eax
  802446:	75 8a                	jne    8023d2 <print_mem_block_lists+0xf2>
  802448:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80244c:	75 84                	jne    8023d2 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80244e:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802452:	75 10                	jne    802464 <print_mem_block_lists+0x184>
  802454:	83 ec 0c             	sub    $0xc,%esp
  802457:	68 08 40 80 00       	push   $0x804008
  80245c:	e8 71 e5 ff ff       	call   8009d2 <cprintf>
  802461:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802464:	83 ec 0c             	sub    $0xc,%esp
  802467:	68 7c 3f 80 00       	push   $0x803f7c
  80246c:	e8 61 e5 ff ff       	call   8009d2 <cprintf>
  802471:	83 c4 10             	add    $0x10,%esp

}
  802474:	90                   	nop
  802475:	c9                   	leave  
  802476:	c3                   	ret    

00802477 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802477:	55                   	push   %ebp
  802478:	89 e5                	mov    %esp,%ebp
  80247a:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  80247d:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802484:	00 00 00 
  802487:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80248e:	00 00 00 
  802491:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802498:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  80249b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8024a2:	e9 9e 00 00 00       	jmp    802545 <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  8024a7:	a1 50 50 80 00       	mov    0x805050,%eax
  8024ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024af:	c1 e2 04             	shl    $0x4,%edx
  8024b2:	01 d0                	add    %edx,%eax
  8024b4:	85 c0                	test   %eax,%eax
  8024b6:	75 14                	jne    8024cc <initialize_MemBlocksList+0x55>
  8024b8:	83 ec 04             	sub    $0x4,%esp
  8024bb:	68 30 40 80 00       	push   $0x804030
  8024c0:	6a 42                	push   $0x42
  8024c2:	68 53 40 80 00       	push   $0x804053
  8024c7:	e8 52 e2 ff ff       	call   80071e <_panic>
  8024cc:	a1 50 50 80 00       	mov    0x805050,%eax
  8024d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024d4:	c1 e2 04             	shl    $0x4,%edx
  8024d7:	01 d0                	add    %edx,%eax
  8024d9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8024df:	89 10                	mov    %edx,(%eax)
  8024e1:	8b 00                	mov    (%eax),%eax
  8024e3:	85 c0                	test   %eax,%eax
  8024e5:	74 18                	je     8024ff <initialize_MemBlocksList+0x88>
  8024e7:	a1 48 51 80 00       	mov    0x805148,%eax
  8024ec:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8024f2:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8024f5:	c1 e1 04             	shl    $0x4,%ecx
  8024f8:	01 ca                	add    %ecx,%edx
  8024fa:	89 50 04             	mov    %edx,0x4(%eax)
  8024fd:	eb 12                	jmp    802511 <initialize_MemBlocksList+0x9a>
  8024ff:	a1 50 50 80 00       	mov    0x805050,%eax
  802504:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802507:	c1 e2 04             	shl    $0x4,%edx
  80250a:	01 d0                	add    %edx,%eax
  80250c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802511:	a1 50 50 80 00       	mov    0x805050,%eax
  802516:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802519:	c1 e2 04             	shl    $0x4,%edx
  80251c:	01 d0                	add    %edx,%eax
  80251e:	a3 48 51 80 00       	mov    %eax,0x805148
  802523:	a1 50 50 80 00       	mov    0x805050,%eax
  802528:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80252b:	c1 e2 04             	shl    $0x4,%edx
  80252e:	01 d0                	add    %edx,%eax
  802530:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802537:	a1 54 51 80 00       	mov    0x805154,%eax
  80253c:	40                   	inc    %eax
  80253d:	a3 54 51 80 00       	mov    %eax,0x805154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  802542:	ff 45 f4             	incl   -0xc(%ebp)
  802545:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802548:	3b 45 08             	cmp    0x8(%ebp),%eax
  80254b:	0f 82 56 ff ff ff    	jb     8024a7 <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  802551:	90                   	nop
  802552:	c9                   	leave  
  802553:	c3                   	ret    

00802554 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802554:	55                   	push   %ebp
  802555:	89 e5                	mov    %esp,%ebp
  802557:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  80255a:	8b 45 08             	mov    0x8(%ebp),%eax
  80255d:	8b 00                	mov    (%eax),%eax
  80255f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802562:	eb 19                	jmp    80257d <find_block+0x29>
	{
		if(blk->sva==va)
  802564:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802567:	8b 40 08             	mov    0x8(%eax),%eax
  80256a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80256d:	75 05                	jne    802574 <find_block+0x20>
			return (blk);
  80256f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802572:	eb 36                	jmp    8025aa <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  802574:	8b 45 08             	mov    0x8(%ebp),%eax
  802577:	8b 40 08             	mov    0x8(%eax),%eax
  80257a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80257d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802581:	74 07                	je     80258a <find_block+0x36>
  802583:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802586:	8b 00                	mov    (%eax),%eax
  802588:	eb 05                	jmp    80258f <find_block+0x3b>
  80258a:	b8 00 00 00 00       	mov    $0x0,%eax
  80258f:	8b 55 08             	mov    0x8(%ebp),%edx
  802592:	89 42 08             	mov    %eax,0x8(%edx)
  802595:	8b 45 08             	mov    0x8(%ebp),%eax
  802598:	8b 40 08             	mov    0x8(%eax),%eax
  80259b:	85 c0                	test   %eax,%eax
  80259d:	75 c5                	jne    802564 <find_block+0x10>
  80259f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8025a3:	75 bf                	jne    802564 <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  8025a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025aa:	c9                   	leave  
  8025ab:	c3                   	ret    

008025ac <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8025ac:	55                   	push   %ebp
  8025ad:	89 e5                	mov    %esp,%ebp
  8025af:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  8025b2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8025b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8025ba:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  8025c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8025c7:	75 65                	jne    80262e <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  8025c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025cd:	75 14                	jne    8025e3 <insert_sorted_allocList+0x37>
  8025cf:	83 ec 04             	sub    $0x4,%esp
  8025d2:	68 30 40 80 00       	push   $0x804030
  8025d7:	6a 5c                	push   $0x5c
  8025d9:	68 53 40 80 00       	push   $0x804053
  8025de:	e8 3b e1 ff ff       	call   80071e <_panic>
  8025e3:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8025e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ec:	89 10                	mov    %edx,(%eax)
  8025ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f1:	8b 00                	mov    (%eax),%eax
  8025f3:	85 c0                	test   %eax,%eax
  8025f5:	74 0d                	je     802604 <insert_sorted_allocList+0x58>
  8025f7:	a1 40 50 80 00       	mov    0x805040,%eax
  8025fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8025ff:	89 50 04             	mov    %edx,0x4(%eax)
  802602:	eb 08                	jmp    80260c <insert_sorted_allocList+0x60>
  802604:	8b 45 08             	mov    0x8(%ebp),%eax
  802607:	a3 44 50 80 00       	mov    %eax,0x805044
  80260c:	8b 45 08             	mov    0x8(%ebp),%eax
  80260f:	a3 40 50 80 00       	mov    %eax,0x805040
  802614:	8b 45 08             	mov    0x8(%ebp),%eax
  802617:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80261e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802623:	40                   	inc    %eax
  802624:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  802629:	e9 7b 01 00 00       	jmp    8027a9 <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  80262e:	a1 44 50 80 00       	mov    0x805044,%eax
  802633:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  802636:	a1 40 50 80 00       	mov    0x805040,%eax
  80263b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  80263e:	8b 45 08             	mov    0x8(%ebp),%eax
  802641:	8b 50 08             	mov    0x8(%eax),%edx
  802644:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802647:	8b 40 08             	mov    0x8(%eax),%eax
  80264a:	39 c2                	cmp    %eax,%edx
  80264c:	76 65                	jbe    8026b3 <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  80264e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802652:	75 14                	jne    802668 <insert_sorted_allocList+0xbc>
  802654:	83 ec 04             	sub    $0x4,%esp
  802657:	68 6c 40 80 00       	push   $0x80406c
  80265c:	6a 64                	push   $0x64
  80265e:	68 53 40 80 00       	push   $0x804053
  802663:	e8 b6 e0 ff ff       	call   80071e <_panic>
  802668:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80266e:	8b 45 08             	mov    0x8(%ebp),%eax
  802671:	89 50 04             	mov    %edx,0x4(%eax)
  802674:	8b 45 08             	mov    0x8(%ebp),%eax
  802677:	8b 40 04             	mov    0x4(%eax),%eax
  80267a:	85 c0                	test   %eax,%eax
  80267c:	74 0c                	je     80268a <insert_sorted_allocList+0xde>
  80267e:	a1 44 50 80 00       	mov    0x805044,%eax
  802683:	8b 55 08             	mov    0x8(%ebp),%edx
  802686:	89 10                	mov    %edx,(%eax)
  802688:	eb 08                	jmp    802692 <insert_sorted_allocList+0xe6>
  80268a:	8b 45 08             	mov    0x8(%ebp),%eax
  80268d:	a3 40 50 80 00       	mov    %eax,0x805040
  802692:	8b 45 08             	mov    0x8(%ebp),%eax
  802695:	a3 44 50 80 00       	mov    %eax,0x805044
  80269a:	8b 45 08             	mov    0x8(%ebp),%eax
  80269d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026a3:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8026a8:	40                   	inc    %eax
  8026a9:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  8026ae:	e9 f6 00 00 00       	jmp    8027a9 <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  8026b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b6:	8b 50 08             	mov    0x8(%eax),%edx
  8026b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026bc:	8b 40 08             	mov    0x8(%eax),%eax
  8026bf:	39 c2                	cmp    %eax,%edx
  8026c1:	73 65                	jae    802728 <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  8026c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026c7:	75 14                	jne    8026dd <insert_sorted_allocList+0x131>
  8026c9:	83 ec 04             	sub    $0x4,%esp
  8026cc:	68 30 40 80 00       	push   $0x804030
  8026d1:	6a 68                	push   $0x68
  8026d3:	68 53 40 80 00       	push   $0x804053
  8026d8:	e8 41 e0 ff ff       	call   80071e <_panic>
  8026dd:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8026e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e6:	89 10                	mov    %edx,(%eax)
  8026e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026eb:	8b 00                	mov    (%eax),%eax
  8026ed:	85 c0                	test   %eax,%eax
  8026ef:	74 0d                	je     8026fe <insert_sorted_allocList+0x152>
  8026f1:	a1 40 50 80 00       	mov    0x805040,%eax
  8026f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8026f9:	89 50 04             	mov    %edx,0x4(%eax)
  8026fc:	eb 08                	jmp    802706 <insert_sorted_allocList+0x15a>
  8026fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802701:	a3 44 50 80 00       	mov    %eax,0x805044
  802706:	8b 45 08             	mov    0x8(%ebp),%eax
  802709:	a3 40 50 80 00       	mov    %eax,0x805040
  80270e:	8b 45 08             	mov    0x8(%ebp),%eax
  802711:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802718:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80271d:	40                   	inc    %eax
  80271e:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  802723:	e9 81 00 00 00       	jmp    8027a9 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802728:	a1 40 50 80 00       	mov    0x805040,%eax
  80272d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802730:	eb 51                	jmp    802783 <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  802732:	8b 45 08             	mov    0x8(%ebp),%eax
  802735:	8b 50 08             	mov    0x8(%eax),%edx
  802738:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273b:	8b 40 08             	mov    0x8(%eax),%eax
  80273e:	39 c2                	cmp    %eax,%edx
  802740:	73 39                	jae    80277b <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  802742:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802745:	8b 40 04             	mov    0x4(%eax),%eax
  802748:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  80274b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80274e:	8b 55 08             	mov    0x8(%ebp),%edx
  802751:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  802753:	8b 45 08             	mov    0x8(%ebp),%eax
  802756:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802759:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  80275c:	8b 45 08             	mov    0x8(%ebp),%eax
  80275f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802762:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  802764:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802767:	8b 55 08             	mov    0x8(%ebp),%edx
  80276a:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  80276d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802772:	40                   	inc    %eax
  802773:	a3 4c 50 80 00       	mov    %eax,0x80504c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  802778:	90                   	nop
				}
			}
		 }

	}
}
  802779:	eb 2e                	jmp    8027a9 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  80277b:	a1 48 50 80 00       	mov    0x805048,%eax
  802780:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802783:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802787:	74 07                	je     802790 <insert_sorted_allocList+0x1e4>
  802789:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278c:	8b 00                	mov    (%eax),%eax
  80278e:	eb 05                	jmp    802795 <insert_sorted_allocList+0x1e9>
  802790:	b8 00 00 00 00       	mov    $0x0,%eax
  802795:	a3 48 50 80 00       	mov    %eax,0x805048
  80279a:	a1 48 50 80 00       	mov    0x805048,%eax
  80279f:	85 c0                	test   %eax,%eax
  8027a1:	75 8f                	jne    802732 <insert_sorted_allocList+0x186>
  8027a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027a7:	75 89                	jne    802732 <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  8027a9:	90                   	nop
  8027aa:	c9                   	leave  
  8027ab:	c3                   	ret    

008027ac <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8027ac:	55                   	push   %ebp
  8027ad:	89 e5                	mov    %esp,%ebp
  8027af:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  8027b2:	a1 38 51 80 00       	mov    0x805138,%eax
  8027b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027ba:	e9 76 01 00 00       	jmp    802935 <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  8027bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8027c5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027c8:	0f 85 8a 00 00 00    	jne    802858 <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  8027ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027d2:	75 17                	jne    8027eb <alloc_block_FF+0x3f>
  8027d4:	83 ec 04             	sub    $0x4,%esp
  8027d7:	68 8f 40 80 00       	push   $0x80408f
  8027dc:	68 8a 00 00 00       	push   $0x8a
  8027e1:	68 53 40 80 00       	push   $0x804053
  8027e6:	e8 33 df ff ff       	call   80071e <_panic>
  8027eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ee:	8b 00                	mov    (%eax),%eax
  8027f0:	85 c0                	test   %eax,%eax
  8027f2:	74 10                	je     802804 <alloc_block_FF+0x58>
  8027f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f7:	8b 00                	mov    (%eax),%eax
  8027f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027fc:	8b 52 04             	mov    0x4(%edx),%edx
  8027ff:	89 50 04             	mov    %edx,0x4(%eax)
  802802:	eb 0b                	jmp    80280f <alloc_block_FF+0x63>
  802804:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802807:	8b 40 04             	mov    0x4(%eax),%eax
  80280a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80280f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802812:	8b 40 04             	mov    0x4(%eax),%eax
  802815:	85 c0                	test   %eax,%eax
  802817:	74 0f                	je     802828 <alloc_block_FF+0x7c>
  802819:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281c:	8b 40 04             	mov    0x4(%eax),%eax
  80281f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802822:	8b 12                	mov    (%edx),%edx
  802824:	89 10                	mov    %edx,(%eax)
  802826:	eb 0a                	jmp    802832 <alloc_block_FF+0x86>
  802828:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282b:	8b 00                	mov    (%eax),%eax
  80282d:	a3 38 51 80 00       	mov    %eax,0x805138
  802832:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802835:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80283b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802845:	a1 44 51 80 00       	mov    0x805144,%eax
  80284a:	48                   	dec    %eax
  80284b:	a3 44 51 80 00       	mov    %eax,0x805144
			return element;
  802850:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802853:	e9 10 01 00 00       	jmp    802968 <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  802858:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285b:	8b 40 0c             	mov    0xc(%eax),%eax
  80285e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802861:	0f 86 c6 00 00 00    	jbe    80292d <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802867:	a1 48 51 80 00       	mov    0x805148,%eax
  80286c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  80286f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802873:	75 17                	jne    80288c <alloc_block_FF+0xe0>
  802875:	83 ec 04             	sub    $0x4,%esp
  802878:	68 8f 40 80 00       	push   $0x80408f
  80287d:	68 90 00 00 00       	push   $0x90
  802882:	68 53 40 80 00       	push   $0x804053
  802887:	e8 92 de ff ff       	call   80071e <_panic>
  80288c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80288f:	8b 00                	mov    (%eax),%eax
  802891:	85 c0                	test   %eax,%eax
  802893:	74 10                	je     8028a5 <alloc_block_FF+0xf9>
  802895:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802898:	8b 00                	mov    (%eax),%eax
  80289a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80289d:	8b 52 04             	mov    0x4(%edx),%edx
  8028a0:	89 50 04             	mov    %edx,0x4(%eax)
  8028a3:	eb 0b                	jmp    8028b0 <alloc_block_FF+0x104>
  8028a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a8:	8b 40 04             	mov    0x4(%eax),%eax
  8028ab:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b3:	8b 40 04             	mov    0x4(%eax),%eax
  8028b6:	85 c0                	test   %eax,%eax
  8028b8:	74 0f                	je     8028c9 <alloc_block_FF+0x11d>
  8028ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028bd:	8b 40 04             	mov    0x4(%eax),%eax
  8028c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028c3:	8b 12                	mov    (%edx),%edx
  8028c5:	89 10                	mov    %edx,(%eax)
  8028c7:	eb 0a                	jmp    8028d3 <alloc_block_FF+0x127>
  8028c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028cc:	8b 00                	mov    (%eax),%eax
  8028ce:	a3 48 51 80 00       	mov    %eax,0x805148
  8028d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028e6:	a1 54 51 80 00       	mov    0x805154,%eax
  8028eb:	48                   	dec    %eax
  8028ec:	a3 54 51 80 00       	mov    %eax,0x805154
			 element1->size =size;
  8028f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8028f7:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  8028fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fd:	8b 50 08             	mov    0x8(%eax),%edx
  802900:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802903:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  802906:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802909:	8b 50 08             	mov    0x8(%eax),%edx
  80290c:	8b 45 08             	mov    0x8(%ebp),%eax
  80290f:	01 c2                	add    %eax,%edx
  802911:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802914:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  802917:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291a:	8b 40 0c             	mov    0xc(%eax),%eax
  80291d:	2b 45 08             	sub    0x8(%ebp),%eax
  802920:	89 c2                	mov    %eax,%edx
  802922:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802925:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  802928:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80292b:	eb 3b                	jmp    802968 <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  80292d:	a1 40 51 80 00       	mov    0x805140,%eax
  802932:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802935:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802939:	74 07                	je     802942 <alloc_block_FF+0x196>
  80293b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293e:	8b 00                	mov    (%eax),%eax
  802940:	eb 05                	jmp    802947 <alloc_block_FF+0x19b>
  802942:	b8 00 00 00 00       	mov    $0x0,%eax
  802947:	a3 40 51 80 00       	mov    %eax,0x805140
  80294c:	a1 40 51 80 00       	mov    0x805140,%eax
  802951:	85 c0                	test   %eax,%eax
  802953:	0f 85 66 fe ff ff    	jne    8027bf <alloc_block_FF+0x13>
  802959:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80295d:	0f 85 5c fe ff ff    	jne    8027bf <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  802963:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802968:	c9                   	leave  
  802969:	c3                   	ret    

0080296a <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80296a:	55                   	push   %ebp
  80296b:	89 e5                	mov    %esp,%ebp
  80296d:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  802970:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  802977:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  80297e:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802985:	a1 38 51 80 00       	mov    0x805138,%eax
  80298a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80298d:	e9 cf 00 00 00       	jmp    802a61 <alloc_block_BF+0xf7>
		{
			c++;
  802992:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  802995:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802998:	8b 40 0c             	mov    0xc(%eax),%eax
  80299b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80299e:	0f 85 8a 00 00 00    	jne    802a2e <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  8029a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029a8:	75 17                	jne    8029c1 <alloc_block_BF+0x57>
  8029aa:	83 ec 04             	sub    $0x4,%esp
  8029ad:	68 8f 40 80 00       	push   $0x80408f
  8029b2:	68 a8 00 00 00       	push   $0xa8
  8029b7:	68 53 40 80 00       	push   $0x804053
  8029bc:	e8 5d dd ff ff       	call   80071e <_panic>
  8029c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c4:	8b 00                	mov    (%eax),%eax
  8029c6:	85 c0                	test   %eax,%eax
  8029c8:	74 10                	je     8029da <alloc_block_BF+0x70>
  8029ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cd:	8b 00                	mov    (%eax),%eax
  8029cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029d2:	8b 52 04             	mov    0x4(%edx),%edx
  8029d5:	89 50 04             	mov    %edx,0x4(%eax)
  8029d8:	eb 0b                	jmp    8029e5 <alloc_block_BF+0x7b>
  8029da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029dd:	8b 40 04             	mov    0x4(%eax),%eax
  8029e0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8029e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e8:	8b 40 04             	mov    0x4(%eax),%eax
  8029eb:	85 c0                	test   %eax,%eax
  8029ed:	74 0f                	je     8029fe <alloc_block_BF+0x94>
  8029ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f2:	8b 40 04             	mov    0x4(%eax),%eax
  8029f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029f8:	8b 12                	mov    (%edx),%edx
  8029fa:	89 10                	mov    %edx,(%eax)
  8029fc:	eb 0a                	jmp    802a08 <alloc_block_BF+0x9e>
  8029fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a01:	8b 00                	mov    (%eax),%eax
  802a03:	a3 38 51 80 00       	mov    %eax,0x805138
  802a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a14:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a1b:	a1 44 51 80 00       	mov    0x805144,%eax
  802a20:	48                   	dec    %eax
  802a21:	a3 44 51 80 00       	mov    %eax,0x805144
				return block;
  802a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a29:	e9 85 01 00 00       	jmp    802bb3 <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  802a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a31:	8b 40 0c             	mov    0xc(%eax),%eax
  802a34:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a37:	76 20                	jbe    802a59 <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  802a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a3f:	2b 45 08             	sub    0x8(%ebp),%eax
  802a42:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  802a45:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a48:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802a4b:	73 0c                	jae    802a59 <alloc_block_BF+0xef>
				{
					ma=tempi;
  802a4d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a50:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  802a53:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a56:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802a59:	a1 40 51 80 00       	mov    0x805140,%eax
  802a5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a61:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a65:	74 07                	je     802a6e <alloc_block_BF+0x104>
  802a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6a:	8b 00                	mov    (%eax),%eax
  802a6c:	eb 05                	jmp    802a73 <alloc_block_BF+0x109>
  802a6e:	b8 00 00 00 00       	mov    $0x0,%eax
  802a73:	a3 40 51 80 00       	mov    %eax,0x805140
  802a78:	a1 40 51 80 00       	mov    0x805140,%eax
  802a7d:	85 c0                	test   %eax,%eax
  802a7f:	0f 85 0d ff ff ff    	jne    802992 <alloc_block_BF+0x28>
  802a85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a89:	0f 85 03 ff ff ff    	jne    802992 <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  802a8f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802a96:	a1 38 51 80 00       	mov    0x805138,%eax
  802a9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a9e:	e9 dd 00 00 00       	jmp    802b80 <alloc_block_BF+0x216>
		{
			if(x==sol)
  802aa3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802aa6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802aa9:	0f 85 c6 00 00 00    	jne    802b75 <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802aaf:	a1 48 51 80 00       	mov    0x805148,%eax
  802ab4:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802ab7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802abb:	75 17                	jne    802ad4 <alloc_block_BF+0x16a>
  802abd:	83 ec 04             	sub    $0x4,%esp
  802ac0:	68 8f 40 80 00       	push   $0x80408f
  802ac5:	68 bb 00 00 00       	push   $0xbb
  802aca:	68 53 40 80 00       	push   $0x804053
  802acf:	e8 4a dc ff ff       	call   80071e <_panic>
  802ad4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ad7:	8b 00                	mov    (%eax),%eax
  802ad9:	85 c0                	test   %eax,%eax
  802adb:	74 10                	je     802aed <alloc_block_BF+0x183>
  802add:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ae0:	8b 00                	mov    (%eax),%eax
  802ae2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ae5:	8b 52 04             	mov    0x4(%edx),%edx
  802ae8:	89 50 04             	mov    %edx,0x4(%eax)
  802aeb:	eb 0b                	jmp    802af8 <alloc_block_BF+0x18e>
  802aed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802af0:	8b 40 04             	mov    0x4(%eax),%eax
  802af3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802af8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802afb:	8b 40 04             	mov    0x4(%eax),%eax
  802afe:	85 c0                	test   %eax,%eax
  802b00:	74 0f                	je     802b11 <alloc_block_BF+0x1a7>
  802b02:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b05:	8b 40 04             	mov    0x4(%eax),%eax
  802b08:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b0b:	8b 12                	mov    (%edx),%edx
  802b0d:	89 10                	mov    %edx,(%eax)
  802b0f:	eb 0a                	jmp    802b1b <alloc_block_BF+0x1b1>
  802b11:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b14:	8b 00                	mov    (%eax),%eax
  802b16:	a3 48 51 80 00       	mov    %eax,0x805148
  802b1b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b1e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b24:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b27:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b2e:	a1 54 51 80 00       	mov    0x805154,%eax
  802b33:	48                   	dec    %eax
  802b34:	a3 54 51 80 00       	mov    %eax,0x805154
						 element1->size =size;
  802b39:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b3c:	8b 55 08             	mov    0x8(%ebp),%edx
  802b3f:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  802b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b45:	8b 50 08             	mov    0x8(%eax),%edx
  802b48:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b4b:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  802b4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b51:	8b 50 08             	mov    0x8(%eax),%edx
  802b54:	8b 45 08             	mov    0x8(%ebp),%eax
  802b57:	01 c2                	add    %eax,%edx
  802b59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5c:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  802b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b62:	8b 40 0c             	mov    0xc(%eax),%eax
  802b65:	2b 45 08             	sub    0x8(%ebp),%eax
  802b68:	89 c2                	mov    %eax,%edx
  802b6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6d:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  802b70:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b73:	eb 3e                	jmp    802bb3 <alloc_block_BF+0x249>
						 break;
			}
			x++;
  802b75:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802b78:	a1 40 51 80 00       	mov    0x805140,%eax
  802b7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b80:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b84:	74 07                	je     802b8d <alloc_block_BF+0x223>
  802b86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b89:	8b 00                	mov    (%eax),%eax
  802b8b:	eb 05                	jmp    802b92 <alloc_block_BF+0x228>
  802b8d:	b8 00 00 00 00       	mov    $0x0,%eax
  802b92:	a3 40 51 80 00       	mov    %eax,0x805140
  802b97:	a1 40 51 80 00       	mov    0x805140,%eax
  802b9c:	85 c0                	test   %eax,%eax
  802b9e:	0f 85 ff fe ff ff    	jne    802aa3 <alloc_block_BF+0x139>
  802ba4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ba8:	0f 85 f5 fe ff ff    	jne    802aa3 <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  802bae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bb3:	c9                   	leave  
  802bb4:	c3                   	ret    

00802bb5 <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802bb5:	55                   	push   %ebp
  802bb6:	89 e5                	mov    %esp,%ebp
  802bb8:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  802bbb:	a1 28 50 80 00       	mov    0x805028,%eax
  802bc0:	85 c0                	test   %eax,%eax
  802bc2:	75 14                	jne    802bd8 <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  802bc4:	a1 38 51 80 00       	mov    0x805138,%eax
  802bc9:	a3 60 51 80 00       	mov    %eax,0x805160
		hh=1;
  802bce:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  802bd5:	00 00 00 
	}
	uint32 c=1;
  802bd8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  802bdf:	a1 60 51 80 00       	mov    0x805160,%eax
  802be4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802be7:	e9 b3 01 00 00       	jmp    802d9f <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  802bec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bef:	8b 40 0c             	mov    0xc(%eax),%eax
  802bf2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bf5:	0f 85 a9 00 00 00    	jne    802ca4 <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  802bfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bfe:	8b 00                	mov    (%eax),%eax
  802c00:	85 c0                	test   %eax,%eax
  802c02:	75 0c                	jne    802c10 <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  802c04:	a1 38 51 80 00       	mov    0x805138,%eax
  802c09:	a3 60 51 80 00       	mov    %eax,0x805160
  802c0e:	eb 0a                	jmp    802c1a <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  802c10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c13:	8b 00                	mov    (%eax),%eax
  802c15:	a3 60 51 80 00       	mov    %eax,0x805160
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  802c1a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c1e:	75 17                	jne    802c37 <alloc_block_NF+0x82>
  802c20:	83 ec 04             	sub    $0x4,%esp
  802c23:	68 8f 40 80 00       	push   $0x80408f
  802c28:	68 e3 00 00 00       	push   $0xe3
  802c2d:	68 53 40 80 00       	push   $0x804053
  802c32:	e8 e7 da ff ff       	call   80071e <_panic>
  802c37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c3a:	8b 00                	mov    (%eax),%eax
  802c3c:	85 c0                	test   %eax,%eax
  802c3e:	74 10                	je     802c50 <alloc_block_NF+0x9b>
  802c40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c43:	8b 00                	mov    (%eax),%eax
  802c45:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c48:	8b 52 04             	mov    0x4(%edx),%edx
  802c4b:	89 50 04             	mov    %edx,0x4(%eax)
  802c4e:	eb 0b                	jmp    802c5b <alloc_block_NF+0xa6>
  802c50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c53:	8b 40 04             	mov    0x4(%eax),%eax
  802c56:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c5e:	8b 40 04             	mov    0x4(%eax),%eax
  802c61:	85 c0                	test   %eax,%eax
  802c63:	74 0f                	je     802c74 <alloc_block_NF+0xbf>
  802c65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c68:	8b 40 04             	mov    0x4(%eax),%eax
  802c6b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c6e:	8b 12                	mov    (%edx),%edx
  802c70:	89 10                	mov    %edx,(%eax)
  802c72:	eb 0a                	jmp    802c7e <alloc_block_NF+0xc9>
  802c74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c77:	8b 00                	mov    (%eax),%eax
  802c79:	a3 38 51 80 00       	mov    %eax,0x805138
  802c7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c81:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c8a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c91:	a1 44 51 80 00       	mov    0x805144,%eax
  802c96:	48                   	dec    %eax
  802c97:	a3 44 51 80 00       	mov    %eax,0x805144
				return element;
  802c9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9f:	e9 0e 01 00 00       	jmp    802db2 <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  802ca4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca7:	8b 40 0c             	mov    0xc(%eax),%eax
  802caa:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cad:	0f 86 ce 00 00 00    	jbe    802d81 <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802cb3:	a1 48 51 80 00       	mov    0x805148,%eax
  802cb8:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802cbb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802cbf:	75 17                	jne    802cd8 <alloc_block_NF+0x123>
  802cc1:	83 ec 04             	sub    $0x4,%esp
  802cc4:	68 8f 40 80 00       	push   $0x80408f
  802cc9:	68 e9 00 00 00       	push   $0xe9
  802cce:	68 53 40 80 00       	push   $0x804053
  802cd3:	e8 46 da ff ff       	call   80071e <_panic>
  802cd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cdb:	8b 00                	mov    (%eax),%eax
  802cdd:	85 c0                	test   %eax,%eax
  802cdf:	74 10                	je     802cf1 <alloc_block_NF+0x13c>
  802ce1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ce4:	8b 00                	mov    (%eax),%eax
  802ce6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ce9:	8b 52 04             	mov    0x4(%edx),%edx
  802cec:	89 50 04             	mov    %edx,0x4(%eax)
  802cef:	eb 0b                	jmp    802cfc <alloc_block_NF+0x147>
  802cf1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cf4:	8b 40 04             	mov    0x4(%eax),%eax
  802cf7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802cfc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cff:	8b 40 04             	mov    0x4(%eax),%eax
  802d02:	85 c0                	test   %eax,%eax
  802d04:	74 0f                	je     802d15 <alloc_block_NF+0x160>
  802d06:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d09:	8b 40 04             	mov    0x4(%eax),%eax
  802d0c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d0f:	8b 12                	mov    (%edx),%edx
  802d11:	89 10                	mov    %edx,(%eax)
  802d13:	eb 0a                	jmp    802d1f <alloc_block_NF+0x16a>
  802d15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d18:	8b 00                	mov    (%eax),%eax
  802d1a:	a3 48 51 80 00       	mov    %eax,0x805148
  802d1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d22:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d2b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d32:	a1 54 51 80 00       	mov    0x805154,%eax
  802d37:	48                   	dec    %eax
  802d38:	a3 54 51 80 00       	mov    %eax,0x805154
				 element1->size =size;
  802d3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d40:	8b 55 08             	mov    0x8(%ebp),%edx
  802d43:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  802d46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d49:	8b 50 08             	mov    0x8(%eax),%edx
  802d4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d4f:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  802d52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d55:	8b 50 08             	mov    0x8(%eax),%edx
  802d58:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5b:	01 c2                	add    %eax,%edx
  802d5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d60:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  802d63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d66:	8b 40 0c             	mov    0xc(%eax),%eax
  802d69:	2b 45 08             	sub    0x8(%ebp),%eax
  802d6c:	89 c2                	mov    %eax,%edx
  802d6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d71:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  802d74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d77:	a3 60 51 80 00       	mov    %eax,0x805160
				 return element1;
  802d7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d7f:	eb 31                	jmp    802db2 <alloc_block_NF+0x1fd>
			 }
		 c++;
  802d81:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  802d84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d87:	8b 00                	mov    (%eax),%eax
  802d89:	85 c0                	test   %eax,%eax
  802d8b:	75 0a                	jne    802d97 <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  802d8d:	a1 38 51 80 00       	mov    0x805138,%eax
  802d92:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802d95:	eb 08                	jmp    802d9f <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  802d97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d9a:	8b 00                	mov    (%eax),%eax
  802d9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802d9f:	a1 44 51 80 00       	mov    0x805144,%eax
  802da4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802da7:	0f 85 3f fe ff ff    	jne    802bec <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  802dad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802db2:	c9                   	leave  
  802db3:	c3                   	ret    

00802db4 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802db4:	55                   	push   %ebp
  802db5:	89 e5                	mov    %esp,%ebp
  802db7:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  802dba:	a1 44 51 80 00       	mov    0x805144,%eax
  802dbf:	85 c0                	test   %eax,%eax
  802dc1:	75 68                	jne    802e2b <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802dc3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dc7:	75 17                	jne    802de0 <insert_sorted_with_merge_freeList+0x2c>
  802dc9:	83 ec 04             	sub    $0x4,%esp
  802dcc:	68 30 40 80 00       	push   $0x804030
  802dd1:	68 0e 01 00 00       	push   $0x10e
  802dd6:	68 53 40 80 00       	push   $0x804053
  802ddb:	e8 3e d9 ff ff       	call   80071e <_panic>
  802de0:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802de6:	8b 45 08             	mov    0x8(%ebp),%eax
  802de9:	89 10                	mov    %edx,(%eax)
  802deb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dee:	8b 00                	mov    (%eax),%eax
  802df0:	85 c0                	test   %eax,%eax
  802df2:	74 0d                	je     802e01 <insert_sorted_with_merge_freeList+0x4d>
  802df4:	a1 38 51 80 00       	mov    0x805138,%eax
  802df9:	8b 55 08             	mov    0x8(%ebp),%edx
  802dfc:	89 50 04             	mov    %edx,0x4(%eax)
  802dff:	eb 08                	jmp    802e09 <insert_sorted_with_merge_freeList+0x55>
  802e01:	8b 45 08             	mov    0x8(%ebp),%eax
  802e04:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e09:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0c:	a3 38 51 80 00       	mov    %eax,0x805138
  802e11:	8b 45 08             	mov    0x8(%ebp),%eax
  802e14:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e1b:	a1 44 51 80 00       	mov    0x805144,%eax
  802e20:	40                   	inc    %eax
  802e21:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  802e26:	e9 8c 06 00 00       	jmp    8034b7 <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  802e2b:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e30:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  802e33:	a1 38 51 80 00       	mov    0x805138,%eax
  802e38:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  802e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3e:	8b 50 08             	mov    0x8(%eax),%edx
  802e41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e44:	8b 40 08             	mov    0x8(%eax),%eax
  802e47:	39 c2                	cmp    %eax,%edx
  802e49:	0f 86 14 01 00 00    	jbe    802f63 <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  802e4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e52:	8b 50 0c             	mov    0xc(%eax),%edx
  802e55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e58:	8b 40 08             	mov    0x8(%eax),%eax
  802e5b:	01 c2                	add    %eax,%edx
  802e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e60:	8b 40 08             	mov    0x8(%eax),%eax
  802e63:	39 c2                	cmp    %eax,%edx
  802e65:	0f 85 90 00 00 00    	jne    802efb <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  802e6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e6e:	8b 50 0c             	mov    0xc(%eax),%edx
  802e71:	8b 45 08             	mov    0x8(%ebp),%eax
  802e74:	8b 40 0c             	mov    0xc(%eax),%eax
  802e77:	01 c2                	add    %eax,%edx
  802e79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e7c:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e82:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802e89:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802e93:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e97:	75 17                	jne    802eb0 <insert_sorted_with_merge_freeList+0xfc>
  802e99:	83 ec 04             	sub    $0x4,%esp
  802e9c:	68 30 40 80 00       	push   $0x804030
  802ea1:	68 1b 01 00 00       	push   $0x11b
  802ea6:	68 53 40 80 00       	push   $0x804053
  802eab:	e8 6e d8 ff ff       	call   80071e <_panic>
  802eb0:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb9:	89 10                	mov    %edx,(%eax)
  802ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebe:	8b 00                	mov    (%eax),%eax
  802ec0:	85 c0                	test   %eax,%eax
  802ec2:	74 0d                	je     802ed1 <insert_sorted_with_merge_freeList+0x11d>
  802ec4:	a1 48 51 80 00       	mov    0x805148,%eax
  802ec9:	8b 55 08             	mov    0x8(%ebp),%edx
  802ecc:	89 50 04             	mov    %edx,0x4(%eax)
  802ecf:	eb 08                	jmp    802ed9 <insert_sorted_with_merge_freeList+0x125>
  802ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  802edc:	a3 48 51 80 00       	mov    %eax,0x805148
  802ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eeb:	a1 54 51 80 00       	mov    0x805154,%eax
  802ef0:	40                   	inc    %eax
  802ef1:	a3 54 51 80 00       	mov    %eax,0x805154
							}

						}
		          }
		}
}
  802ef6:	e9 bc 05 00 00       	jmp    8034b7 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802efb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802eff:	75 17                	jne    802f18 <insert_sorted_with_merge_freeList+0x164>
  802f01:	83 ec 04             	sub    $0x4,%esp
  802f04:	68 6c 40 80 00       	push   $0x80406c
  802f09:	68 1f 01 00 00       	push   $0x11f
  802f0e:	68 53 40 80 00       	push   $0x804053
  802f13:	e8 06 d8 ff ff       	call   80071e <_panic>
  802f18:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f21:	89 50 04             	mov    %edx,0x4(%eax)
  802f24:	8b 45 08             	mov    0x8(%ebp),%eax
  802f27:	8b 40 04             	mov    0x4(%eax),%eax
  802f2a:	85 c0                	test   %eax,%eax
  802f2c:	74 0c                	je     802f3a <insert_sorted_with_merge_freeList+0x186>
  802f2e:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f33:	8b 55 08             	mov    0x8(%ebp),%edx
  802f36:	89 10                	mov    %edx,(%eax)
  802f38:	eb 08                	jmp    802f42 <insert_sorted_with_merge_freeList+0x18e>
  802f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3d:	a3 38 51 80 00       	mov    %eax,0x805138
  802f42:	8b 45 08             	mov    0x8(%ebp),%eax
  802f45:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f53:	a1 44 51 80 00       	mov    0x805144,%eax
  802f58:	40                   	inc    %eax
  802f59:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  802f5e:	e9 54 05 00 00       	jmp    8034b7 <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  802f63:	8b 45 08             	mov    0x8(%ebp),%eax
  802f66:	8b 50 08             	mov    0x8(%eax),%edx
  802f69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f6c:	8b 40 08             	mov    0x8(%eax),%eax
  802f6f:	39 c2                	cmp    %eax,%edx
  802f71:	0f 83 20 01 00 00    	jae    803097 <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  802f77:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7a:	8b 50 0c             	mov    0xc(%eax),%edx
  802f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f80:	8b 40 08             	mov    0x8(%eax),%eax
  802f83:	01 c2                	add    %eax,%edx
  802f85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f88:	8b 40 08             	mov    0x8(%eax),%eax
  802f8b:	39 c2                	cmp    %eax,%edx
  802f8d:	0f 85 9c 00 00 00    	jne    80302f <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  802f93:	8b 45 08             	mov    0x8(%ebp),%eax
  802f96:	8b 50 08             	mov    0x8(%eax),%edx
  802f99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f9c:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  802f9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fa2:	8b 50 0c             	mov    0xc(%eax),%edx
  802fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa8:	8b 40 0c             	mov    0xc(%eax),%eax
  802fab:	01 c2                	add    %eax,%edx
  802fad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fb0:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802fc7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fcb:	75 17                	jne    802fe4 <insert_sorted_with_merge_freeList+0x230>
  802fcd:	83 ec 04             	sub    $0x4,%esp
  802fd0:	68 30 40 80 00       	push   $0x804030
  802fd5:	68 2a 01 00 00       	push   $0x12a
  802fda:	68 53 40 80 00       	push   $0x804053
  802fdf:	e8 3a d7 ff ff       	call   80071e <_panic>
  802fe4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802fea:	8b 45 08             	mov    0x8(%ebp),%eax
  802fed:	89 10                	mov    %edx,(%eax)
  802fef:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff2:	8b 00                	mov    (%eax),%eax
  802ff4:	85 c0                	test   %eax,%eax
  802ff6:	74 0d                	je     803005 <insert_sorted_with_merge_freeList+0x251>
  802ff8:	a1 48 51 80 00       	mov    0x805148,%eax
  802ffd:	8b 55 08             	mov    0x8(%ebp),%edx
  803000:	89 50 04             	mov    %edx,0x4(%eax)
  803003:	eb 08                	jmp    80300d <insert_sorted_with_merge_freeList+0x259>
  803005:	8b 45 08             	mov    0x8(%ebp),%eax
  803008:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80300d:	8b 45 08             	mov    0x8(%ebp),%eax
  803010:	a3 48 51 80 00       	mov    %eax,0x805148
  803015:	8b 45 08             	mov    0x8(%ebp),%eax
  803018:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80301f:	a1 54 51 80 00       	mov    0x805154,%eax
  803024:	40                   	inc    %eax
  803025:	a3 54 51 80 00       	mov    %eax,0x805154
							}

						}
		          }
		}
}
  80302a:	e9 88 04 00 00       	jmp    8034b7 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  80302f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803033:	75 17                	jne    80304c <insert_sorted_with_merge_freeList+0x298>
  803035:	83 ec 04             	sub    $0x4,%esp
  803038:	68 30 40 80 00       	push   $0x804030
  80303d:	68 2e 01 00 00       	push   $0x12e
  803042:	68 53 40 80 00       	push   $0x804053
  803047:	e8 d2 d6 ff ff       	call   80071e <_panic>
  80304c:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803052:	8b 45 08             	mov    0x8(%ebp),%eax
  803055:	89 10                	mov    %edx,(%eax)
  803057:	8b 45 08             	mov    0x8(%ebp),%eax
  80305a:	8b 00                	mov    (%eax),%eax
  80305c:	85 c0                	test   %eax,%eax
  80305e:	74 0d                	je     80306d <insert_sorted_with_merge_freeList+0x2b9>
  803060:	a1 38 51 80 00       	mov    0x805138,%eax
  803065:	8b 55 08             	mov    0x8(%ebp),%edx
  803068:	89 50 04             	mov    %edx,0x4(%eax)
  80306b:	eb 08                	jmp    803075 <insert_sorted_with_merge_freeList+0x2c1>
  80306d:	8b 45 08             	mov    0x8(%ebp),%eax
  803070:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803075:	8b 45 08             	mov    0x8(%ebp),%eax
  803078:	a3 38 51 80 00       	mov    %eax,0x805138
  80307d:	8b 45 08             	mov    0x8(%ebp),%eax
  803080:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803087:	a1 44 51 80 00       	mov    0x805144,%eax
  80308c:	40                   	inc    %eax
  80308d:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  803092:	e9 20 04 00 00       	jmp    8034b7 <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  803097:	a1 38 51 80 00       	mov    0x805138,%eax
  80309c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80309f:	e9 e2 03 00 00       	jmp    803486 <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  8030a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a7:	8b 50 08             	mov    0x8(%eax),%edx
  8030aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ad:	8b 40 08             	mov    0x8(%eax),%eax
  8030b0:	39 c2                	cmp    %eax,%edx
  8030b2:	0f 83 c6 03 00 00    	jae    80347e <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  8030b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bb:	8b 40 04             	mov    0x4(%eax),%eax
  8030be:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  8030c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c4:	8b 50 08             	mov    0x8(%eax),%edx
  8030c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8030cd:	01 d0                	add    %edx,%eax
  8030cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  8030d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d5:	8b 50 0c             	mov    0xc(%eax),%edx
  8030d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030db:	8b 40 08             	mov    0x8(%eax),%eax
  8030de:	01 d0                	add    %edx,%eax
  8030e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  8030e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e6:	8b 40 08             	mov    0x8(%eax),%eax
  8030e9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8030ec:	74 7a                	je     803168 <insert_sorted_with_merge_freeList+0x3b4>
  8030ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f1:	8b 40 08             	mov    0x8(%eax),%eax
  8030f4:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8030f7:	74 6f                	je     803168 <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  8030f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030fd:	74 06                	je     803105 <insert_sorted_with_merge_freeList+0x351>
  8030ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803103:	75 17                	jne    80311c <insert_sorted_with_merge_freeList+0x368>
  803105:	83 ec 04             	sub    $0x4,%esp
  803108:	68 b0 40 80 00       	push   $0x8040b0
  80310d:	68 43 01 00 00       	push   $0x143
  803112:	68 53 40 80 00       	push   $0x804053
  803117:	e8 02 d6 ff ff       	call   80071e <_panic>
  80311c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311f:	8b 50 04             	mov    0x4(%eax),%edx
  803122:	8b 45 08             	mov    0x8(%ebp),%eax
  803125:	89 50 04             	mov    %edx,0x4(%eax)
  803128:	8b 45 08             	mov    0x8(%ebp),%eax
  80312b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80312e:	89 10                	mov    %edx,(%eax)
  803130:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803133:	8b 40 04             	mov    0x4(%eax),%eax
  803136:	85 c0                	test   %eax,%eax
  803138:	74 0d                	je     803147 <insert_sorted_with_merge_freeList+0x393>
  80313a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313d:	8b 40 04             	mov    0x4(%eax),%eax
  803140:	8b 55 08             	mov    0x8(%ebp),%edx
  803143:	89 10                	mov    %edx,(%eax)
  803145:	eb 08                	jmp    80314f <insert_sorted_with_merge_freeList+0x39b>
  803147:	8b 45 08             	mov    0x8(%ebp),%eax
  80314a:	a3 38 51 80 00       	mov    %eax,0x805138
  80314f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803152:	8b 55 08             	mov    0x8(%ebp),%edx
  803155:	89 50 04             	mov    %edx,0x4(%eax)
  803158:	a1 44 51 80 00       	mov    0x805144,%eax
  80315d:	40                   	inc    %eax
  80315e:	a3 44 51 80 00       	mov    %eax,0x805144
  803163:	e9 14 03 00 00       	jmp    80347c <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  803168:	8b 45 08             	mov    0x8(%ebp),%eax
  80316b:	8b 40 08             	mov    0x8(%eax),%eax
  80316e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803171:	0f 85 a0 01 00 00    	jne    803317 <insert_sorted_with_merge_freeList+0x563>
  803177:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80317a:	8b 40 08             	mov    0x8(%eax),%eax
  80317d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803180:	0f 85 91 01 00 00    	jne    803317 <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  803186:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803189:	8b 50 0c             	mov    0xc(%eax),%edx
  80318c:	8b 45 08             	mov    0x8(%ebp),%eax
  80318f:	8b 48 0c             	mov    0xc(%eax),%ecx
  803192:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803195:	8b 40 0c             	mov    0xc(%eax),%eax
  803198:	01 c8                	add    %ecx,%eax
  80319a:	01 c2                	add    %eax,%edx
  80319c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80319f:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  8031a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  8031ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8031af:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  8031b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  8031c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8031ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031ce:	75 17                	jne    8031e7 <insert_sorted_with_merge_freeList+0x433>
  8031d0:	83 ec 04             	sub    $0x4,%esp
  8031d3:	68 30 40 80 00       	push   $0x804030
  8031d8:	68 4d 01 00 00       	push   $0x14d
  8031dd:	68 53 40 80 00       	push   $0x804053
  8031e2:	e8 37 d5 ff ff       	call   80071e <_panic>
  8031e7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f0:	89 10                	mov    %edx,(%eax)
  8031f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f5:	8b 00                	mov    (%eax),%eax
  8031f7:	85 c0                	test   %eax,%eax
  8031f9:	74 0d                	je     803208 <insert_sorted_with_merge_freeList+0x454>
  8031fb:	a1 48 51 80 00       	mov    0x805148,%eax
  803200:	8b 55 08             	mov    0x8(%ebp),%edx
  803203:	89 50 04             	mov    %edx,0x4(%eax)
  803206:	eb 08                	jmp    803210 <insert_sorted_with_merge_freeList+0x45c>
  803208:	8b 45 08             	mov    0x8(%ebp),%eax
  80320b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803210:	8b 45 08             	mov    0x8(%ebp),%eax
  803213:	a3 48 51 80 00       	mov    %eax,0x805148
  803218:	8b 45 08             	mov    0x8(%ebp),%eax
  80321b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803222:	a1 54 51 80 00       	mov    0x805154,%eax
  803227:	40                   	inc    %eax
  803228:	a3 54 51 80 00       	mov    %eax,0x805154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  80322d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803231:	75 17                	jne    80324a <insert_sorted_with_merge_freeList+0x496>
  803233:	83 ec 04             	sub    $0x4,%esp
  803236:	68 8f 40 80 00       	push   $0x80408f
  80323b:	68 4e 01 00 00       	push   $0x14e
  803240:	68 53 40 80 00       	push   $0x804053
  803245:	e8 d4 d4 ff ff       	call   80071e <_panic>
  80324a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324d:	8b 00                	mov    (%eax),%eax
  80324f:	85 c0                	test   %eax,%eax
  803251:	74 10                	je     803263 <insert_sorted_with_merge_freeList+0x4af>
  803253:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803256:	8b 00                	mov    (%eax),%eax
  803258:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80325b:	8b 52 04             	mov    0x4(%edx),%edx
  80325e:	89 50 04             	mov    %edx,0x4(%eax)
  803261:	eb 0b                	jmp    80326e <insert_sorted_with_merge_freeList+0x4ba>
  803263:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803266:	8b 40 04             	mov    0x4(%eax),%eax
  803269:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80326e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803271:	8b 40 04             	mov    0x4(%eax),%eax
  803274:	85 c0                	test   %eax,%eax
  803276:	74 0f                	je     803287 <insert_sorted_with_merge_freeList+0x4d3>
  803278:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327b:	8b 40 04             	mov    0x4(%eax),%eax
  80327e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803281:	8b 12                	mov    (%edx),%edx
  803283:	89 10                	mov    %edx,(%eax)
  803285:	eb 0a                	jmp    803291 <insert_sorted_with_merge_freeList+0x4dd>
  803287:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328a:	8b 00                	mov    (%eax),%eax
  80328c:	a3 38 51 80 00       	mov    %eax,0x805138
  803291:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803294:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80329a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80329d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032a4:	a1 44 51 80 00       	mov    0x805144,%eax
  8032a9:	48                   	dec    %eax
  8032aa:	a3 44 51 80 00       	mov    %eax,0x805144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  8032af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032b3:	75 17                	jne    8032cc <insert_sorted_with_merge_freeList+0x518>
  8032b5:	83 ec 04             	sub    $0x4,%esp
  8032b8:	68 30 40 80 00       	push   $0x804030
  8032bd:	68 4f 01 00 00       	push   $0x14f
  8032c2:	68 53 40 80 00       	push   $0x804053
  8032c7:	e8 52 d4 ff ff       	call   80071e <_panic>
  8032cc:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d5:	89 10                	mov    %edx,(%eax)
  8032d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032da:	8b 00                	mov    (%eax),%eax
  8032dc:	85 c0                	test   %eax,%eax
  8032de:	74 0d                	je     8032ed <insert_sorted_with_merge_freeList+0x539>
  8032e0:	a1 48 51 80 00       	mov    0x805148,%eax
  8032e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032e8:	89 50 04             	mov    %edx,0x4(%eax)
  8032eb:	eb 08                	jmp    8032f5 <insert_sorted_with_merge_freeList+0x541>
  8032ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f8:	a3 48 51 80 00       	mov    %eax,0x805148
  8032fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803300:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803307:	a1 54 51 80 00       	mov    0x805154,%eax
  80330c:	40                   	inc    %eax
  80330d:	a3 54 51 80 00       	mov    %eax,0x805154
  803312:	e9 65 01 00 00       	jmp    80347c <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  803317:	8b 45 08             	mov    0x8(%ebp),%eax
  80331a:	8b 40 08             	mov    0x8(%eax),%eax
  80331d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803320:	0f 85 9f 00 00 00    	jne    8033c5 <insert_sorted_with_merge_freeList+0x611>
  803326:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803329:	8b 40 08             	mov    0x8(%eax),%eax
  80332c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80332f:	0f 84 90 00 00 00    	je     8033c5 <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  803335:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803338:	8b 50 0c             	mov    0xc(%eax),%edx
  80333b:	8b 45 08             	mov    0x8(%ebp),%eax
  80333e:	8b 40 0c             	mov    0xc(%eax),%eax
  803341:	01 c2                	add    %eax,%edx
  803343:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803346:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  803349:	8b 45 08             	mov    0x8(%ebp),%eax
  80334c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  803353:	8b 45 08             	mov    0x8(%ebp),%eax
  803356:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80335d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803361:	75 17                	jne    80337a <insert_sorted_with_merge_freeList+0x5c6>
  803363:	83 ec 04             	sub    $0x4,%esp
  803366:	68 30 40 80 00       	push   $0x804030
  80336b:	68 58 01 00 00       	push   $0x158
  803370:	68 53 40 80 00       	push   $0x804053
  803375:	e8 a4 d3 ff ff       	call   80071e <_panic>
  80337a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803380:	8b 45 08             	mov    0x8(%ebp),%eax
  803383:	89 10                	mov    %edx,(%eax)
  803385:	8b 45 08             	mov    0x8(%ebp),%eax
  803388:	8b 00                	mov    (%eax),%eax
  80338a:	85 c0                	test   %eax,%eax
  80338c:	74 0d                	je     80339b <insert_sorted_with_merge_freeList+0x5e7>
  80338e:	a1 48 51 80 00       	mov    0x805148,%eax
  803393:	8b 55 08             	mov    0x8(%ebp),%edx
  803396:	89 50 04             	mov    %edx,0x4(%eax)
  803399:	eb 08                	jmp    8033a3 <insert_sorted_with_merge_freeList+0x5ef>
  80339b:	8b 45 08             	mov    0x8(%ebp),%eax
  80339e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a6:	a3 48 51 80 00       	mov    %eax,0x805148
  8033ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033b5:	a1 54 51 80 00       	mov    0x805154,%eax
  8033ba:	40                   	inc    %eax
  8033bb:	a3 54 51 80 00       	mov    %eax,0x805154
  8033c0:	e9 b7 00 00 00       	jmp    80347c <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  8033c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c8:	8b 40 08             	mov    0x8(%eax),%eax
  8033cb:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8033ce:	0f 84 e2 00 00 00    	je     8034b6 <insert_sorted_with_merge_freeList+0x702>
  8033d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d7:	8b 40 08             	mov    0x8(%eax),%eax
  8033da:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8033dd:	0f 85 d3 00 00 00    	jne    8034b6 <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  8033e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e6:	8b 50 08             	mov    0x8(%eax),%edx
  8033e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ec:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  8033ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f2:	8b 50 0c             	mov    0xc(%eax),%edx
  8033f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8033fb:	01 c2                	add    %eax,%edx
  8033fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803400:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  803403:	8b 45 08             	mov    0x8(%ebp),%eax
  803406:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  80340d:	8b 45 08             	mov    0x8(%ebp),%eax
  803410:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803417:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80341b:	75 17                	jne    803434 <insert_sorted_with_merge_freeList+0x680>
  80341d:	83 ec 04             	sub    $0x4,%esp
  803420:	68 30 40 80 00       	push   $0x804030
  803425:	68 61 01 00 00       	push   $0x161
  80342a:	68 53 40 80 00       	push   $0x804053
  80342f:	e8 ea d2 ff ff       	call   80071e <_panic>
  803434:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80343a:	8b 45 08             	mov    0x8(%ebp),%eax
  80343d:	89 10                	mov    %edx,(%eax)
  80343f:	8b 45 08             	mov    0x8(%ebp),%eax
  803442:	8b 00                	mov    (%eax),%eax
  803444:	85 c0                	test   %eax,%eax
  803446:	74 0d                	je     803455 <insert_sorted_with_merge_freeList+0x6a1>
  803448:	a1 48 51 80 00       	mov    0x805148,%eax
  80344d:	8b 55 08             	mov    0x8(%ebp),%edx
  803450:	89 50 04             	mov    %edx,0x4(%eax)
  803453:	eb 08                	jmp    80345d <insert_sorted_with_merge_freeList+0x6a9>
  803455:	8b 45 08             	mov    0x8(%ebp),%eax
  803458:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80345d:	8b 45 08             	mov    0x8(%ebp),%eax
  803460:	a3 48 51 80 00       	mov    %eax,0x805148
  803465:	8b 45 08             	mov    0x8(%ebp),%eax
  803468:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80346f:	a1 54 51 80 00       	mov    0x805154,%eax
  803474:	40                   	inc    %eax
  803475:	a3 54 51 80 00       	mov    %eax,0x805154
								}
								break;
  80347a:	eb 3a                	jmp    8034b6 <insert_sorted_with_merge_freeList+0x702>
  80347c:	eb 38                	jmp    8034b6 <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  80347e:	a1 40 51 80 00       	mov    0x805140,%eax
  803483:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803486:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80348a:	74 07                	je     803493 <insert_sorted_with_merge_freeList+0x6df>
  80348c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80348f:	8b 00                	mov    (%eax),%eax
  803491:	eb 05                	jmp    803498 <insert_sorted_with_merge_freeList+0x6e4>
  803493:	b8 00 00 00 00       	mov    $0x0,%eax
  803498:	a3 40 51 80 00       	mov    %eax,0x805140
  80349d:	a1 40 51 80 00       	mov    0x805140,%eax
  8034a2:	85 c0                	test   %eax,%eax
  8034a4:	0f 85 fa fb ff ff    	jne    8030a4 <insert_sorted_with_merge_freeList+0x2f0>
  8034aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034ae:	0f 85 f0 fb ff ff    	jne    8030a4 <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  8034b4:	eb 01                	jmp    8034b7 <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  8034b6:	90                   	nop
							}

						}
		          }
		}
}
  8034b7:	90                   	nop
  8034b8:	c9                   	leave  
  8034b9:	c3                   	ret    

008034ba <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8034ba:	55                   	push   %ebp
  8034bb:	89 e5                	mov    %esp,%ebp
  8034bd:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8034c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8034c3:	89 d0                	mov    %edx,%eax
  8034c5:	c1 e0 02             	shl    $0x2,%eax
  8034c8:	01 d0                	add    %edx,%eax
  8034ca:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8034d1:	01 d0                	add    %edx,%eax
  8034d3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8034da:	01 d0                	add    %edx,%eax
  8034dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8034e3:	01 d0                	add    %edx,%eax
  8034e5:	c1 e0 04             	shl    $0x4,%eax
  8034e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8034eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8034f2:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8034f5:	83 ec 0c             	sub    $0xc,%esp
  8034f8:	50                   	push   %eax
  8034f9:	e8 9c eb ff ff       	call   80209a <sys_get_virtual_time>
  8034fe:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803501:	eb 41                	jmp    803544 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803503:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803506:	83 ec 0c             	sub    $0xc,%esp
  803509:	50                   	push   %eax
  80350a:	e8 8b eb ff ff       	call   80209a <sys_get_virtual_time>
  80350f:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803512:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803515:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803518:	29 c2                	sub    %eax,%edx
  80351a:	89 d0                	mov    %edx,%eax
  80351c:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80351f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803522:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803525:	89 d1                	mov    %edx,%ecx
  803527:	29 c1                	sub    %eax,%ecx
  803529:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80352c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80352f:	39 c2                	cmp    %eax,%edx
  803531:	0f 97 c0             	seta   %al
  803534:	0f b6 c0             	movzbl %al,%eax
  803537:	29 c1                	sub    %eax,%ecx
  803539:	89 c8                	mov    %ecx,%eax
  80353b:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80353e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803541:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803544:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803547:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80354a:	72 b7                	jb     803503 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80354c:	90                   	nop
  80354d:	c9                   	leave  
  80354e:	c3                   	ret    

0080354f <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80354f:	55                   	push   %ebp
  803550:	89 e5                	mov    %esp,%ebp
  803552:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803555:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80355c:	eb 03                	jmp    803561 <busy_wait+0x12>
  80355e:	ff 45 fc             	incl   -0x4(%ebp)
  803561:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803564:	3b 45 08             	cmp    0x8(%ebp),%eax
  803567:	72 f5                	jb     80355e <busy_wait+0xf>
	return i;
  803569:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80356c:	c9                   	leave  
  80356d:	c3                   	ret    
  80356e:	66 90                	xchg   %ax,%ax

00803570 <__udivdi3>:
  803570:	55                   	push   %ebp
  803571:	57                   	push   %edi
  803572:	56                   	push   %esi
  803573:	53                   	push   %ebx
  803574:	83 ec 1c             	sub    $0x1c,%esp
  803577:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80357b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80357f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803583:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803587:	89 ca                	mov    %ecx,%edx
  803589:	89 f8                	mov    %edi,%eax
  80358b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80358f:	85 f6                	test   %esi,%esi
  803591:	75 2d                	jne    8035c0 <__udivdi3+0x50>
  803593:	39 cf                	cmp    %ecx,%edi
  803595:	77 65                	ja     8035fc <__udivdi3+0x8c>
  803597:	89 fd                	mov    %edi,%ebp
  803599:	85 ff                	test   %edi,%edi
  80359b:	75 0b                	jne    8035a8 <__udivdi3+0x38>
  80359d:	b8 01 00 00 00       	mov    $0x1,%eax
  8035a2:	31 d2                	xor    %edx,%edx
  8035a4:	f7 f7                	div    %edi
  8035a6:	89 c5                	mov    %eax,%ebp
  8035a8:	31 d2                	xor    %edx,%edx
  8035aa:	89 c8                	mov    %ecx,%eax
  8035ac:	f7 f5                	div    %ebp
  8035ae:	89 c1                	mov    %eax,%ecx
  8035b0:	89 d8                	mov    %ebx,%eax
  8035b2:	f7 f5                	div    %ebp
  8035b4:	89 cf                	mov    %ecx,%edi
  8035b6:	89 fa                	mov    %edi,%edx
  8035b8:	83 c4 1c             	add    $0x1c,%esp
  8035bb:	5b                   	pop    %ebx
  8035bc:	5e                   	pop    %esi
  8035bd:	5f                   	pop    %edi
  8035be:	5d                   	pop    %ebp
  8035bf:	c3                   	ret    
  8035c0:	39 ce                	cmp    %ecx,%esi
  8035c2:	77 28                	ja     8035ec <__udivdi3+0x7c>
  8035c4:	0f bd fe             	bsr    %esi,%edi
  8035c7:	83 f7 1f             	xor    $0x1f,%edi
  8035ca:	75 40                	jne    80360c <__udivdi3+0x9c>
  8035cc:	39 ce                	cmp    %ecx,%esi
  8035ce:	72 0a                	jb     8035da <__udivdi3+0x6a>
  8035d0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8035d4:	0f 87 9e 00 00 00    	ja     803678 <__udivdi3+0x108>
  8035da:	b8 01 00 00 00       	mov    $0x1,%eax
  8035df:	89 fa                	mov    %edi,%edx
  8035e1:	83 c4 1c             	add    $0x1c,%esp
  8035e4:	5b                   	pop    %ebx
  8035e5:	5e                   	pop    %esi
  8035e6:	5f                   	pop    %edi
  8035e7:	5d                   	pop    %ebp
  8035e8:	c3                   	ret    
  8035e9:	8d 76 00             	lea    0x0(%esi),%esi
  8035ec:	31 ff                	xor    %edi,%edi
  8035ee:	31 c0                	xor    %eax,%eax
  8035f0:	89 fa                	mov    %edi,%edx
  8035f2:	83 c4 1c             	add    $0x1c,%esp
  8035f5:	5b                   	pop    %ebx
  8035f6:	5e                   	pop    %esi
  8035f7:	5f                   	pop    %edi
  8035f8:	5d                   	pop    %ebp
  8035f9:	c3                   	ret    
  8035fa:	66 90                	xchg   %ax,%ax
  8035fc:	89 d8                	mov    %ebx,%eax
  8035fe:	f7 f7                	div    %edi
  803600:	31 ff                	xor    %edi,%edi
  803602:	89 fa                	mov    %edi,%edx
  803604:	83 c4 1c             	add    $0x1c,%esp
  803607:	5b                   	pop    %ebx
  803608:	5e                   	pop    %esi
  803609:	5f                   	pop    %edi
  80360a:	5d                   	pop    %ebp
  80360b:	c3                   	ret    
  80360c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803611:	89 eb                	mov    %ebp,%ebx
  803613:	29 fb                	sub    %edi,%ebx
  803615:	89 f9                	mov    %edi,%ecx
  803617:	d3 e6                	shl    %cl,%esi
  803619:	89 c5                	mov    %eax,%ebp
  80361b:	88 d9                	mov    %bl,%cl
  80361d:	d3 ed                	shr    %cl,%ebp
  80361f:	89 e9                	mov    %ebp,%ecx
  803621:	09 f1                	or     %esi,%ecx
  803623:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803627:	89 f9                	mov    %edi,%ecx
  803629:	d3 e0                	shl    %cl,%eax
  80362b:	89 c5                	mov    %eax,%ebp
  80362d:	89 d6                	mov    %edx,%esi
  80362f:	88 d9                	mov    %bl,%cl
  803631:	d3 ee                	shr    %cl,%esi
  803633:	89 f9                	mov    %edi,%ecx
  803635:	d3 e2                	shl    %cl,%edx
  803637:	8b 44 24 08          	mov    0x8(%esp),%eax
  80363b:	88 d9                	mov    %bl,%cl
  80363d:	d3 e8                	shr    %cl,%eax
  80363f:	09 c2                	or     %eax,%edx
  803641:	89 d0                	mov    %edx,%eax
  803643:	89 f2                	mov    %esi,%edx
  803645:	f7 74 24 0c          	divl   0xc(%esp)
  803649:	89 d6                	mov    %edx,%esi
  80364b:	89 c3                	mov    %eax,%ebx
  80364d:	f7 e5                	mul    %ebp
  80364f:	39 d6                	cmp    %edx,%esi
  803651:	72 19                	jb     80366c <__udivdi3+0xfc>
  803653:	74 0b                	je     803660 <__udivdi3+0xf0>
  803655:	89 d8                	mov    %ebx,%eax
  803657:	31 ff                	xor    %edi,%edi
  803659:	e9 58 ff ff ff       	jmp    8035b6 <__udivdi3+0x46>
  80365e:	66 90                	xchg   %ax,%ax
  803660:	8b 54 24 08          	mov    0x8(%esp),%edx
  803664:	89 f9                	mov    %edi,%ecx
  803666:	d3 e2                	shl    %cl,%edx
  803668:	39 c2                	cmp    %eax,%edx
  80366a:	73 e9                	jae    803655 <__udivdi3+0xe5>
  80366c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80366f:	31 ff                	xor    %edi,%edi
  803671:	e9 40 ff ff ff       	jmp    8035b6 <__udivdi3+0x46>
  803676:	66 90                	xchg   %ax,%ax
  803678:	31 c0                	xor    %eax,%eax
  80367a:	e9 37 ff ff ff       	jmp    8035b6 <__udivdi3+0x46>
  80367f:	90                   	nop

00803680 <__umoddi3>:
  803680:	55                   	push   %ebp
  803681:	57                   	push   %edi
  803682:	56                   	push   %esi
  803683:	53                   	push   %ebx
  803684:	83 ec 1c             	sub    $0x1c,%esp
  803687:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80368b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80368f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803693:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803697:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80369b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80369f:	89 f3                	mov    %esi,%ebx
  8036a1:	89 fa                	mov    %edi,%edx
  8036a3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036a7:	89 34 24             	mov    %esi,(%esp)
  8036aa:	85 c0                	test   %eax,%eax
  8036ac:	75 1a                	jne    8036c8 <__umoddi3+0x48>
  8036ae:	39 f7                	cmp    %esi,%edi
  8036b0:	0f 86 a2 00 00 00    	jbe    803758 <__umoddi3+0xd8>
  8036b6:	89 c8                	mov    %ecx,%eax
  8036b8:	89 f2                	mov    %esi,%edx
  8036ba:	f7 f7                	div    %edi
  8036bc:	89 d0                	mov    %edx,%eax
  8036be:	31 d2                	xor    %edx,%edx
  8036c0:	83 c4 1c             	add    $0x1c,%esp
  8036c3:	5b                   	pop    %ebx
  8036c4:	5e                   	pop    %esi
  8036c5:	5f                   	pop    %edi
  8036c6:	5d                   	pop    %ebp
  8036c7:	c3                   	ret    
  8036c8:	39 f0                	cmp    %esi,%eax
  8036ca:	0f 87 ac 00 00 00    	ja     80377c <__umoddi3+0xfc>
  8036d0:	0f bd e8             	bsr    %eax,%ebp
  8036d3:	83 f5 1f             	xor    $0x1f,%ebp
  8036d6:	0f 84 ac 00 00 00    	je     803788 <__umoddi3+0x108>
  8036dc:	bf 20 00 00 00       	mov    $0x20,%edi
  8036e1:	29 ef                	sub    %ebp,%edi
  8036e3:	89 fe                	mov    %edi,%esi
  8036e5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8036e9:	89 e9                	mov    %ebp,%ecx
  8036eb:	d3 e0                	shl    %cl,%eax
  8036ed:	89 d7                	mov    %edx,%edi
  8036ef:	89 f1                	mov    %esi,%ecx
  8036f1:	d3 ef                	shr    %cl,%edi
  8036f3:	09 c7                	or     %eax,%edi
  8036f5:	89 e9                	mov    %ebp,%ecx
  8036f7:	d3 e2                	shl    %cl,%edx
  8036f9:	89 14 24             	mov    %edx,(%esp)
  8036fc:	89 d8                	mov    %ebx,%eax
  8036fe:	d3 e0                	shl    %cl,%eax
  803700:	89 c2                	mov    %eax,%edx
  803702:	8b 44 24 08          	mov    0x8(%esp),%eax
  803706:	d3 e0                	shl    %cl,%eax
  803708:	89 44 24 04          	mov    %eax,0x4(%esp)
  80370c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803710:	89 f1                	mov    %esi,%ecx
  803712:	d3 e8                	shr    %cl,%eax
  803714:	09 d0                	or     %edx,%eax
  803716:	d3 eb                	shr    %cl,%ebx
  803718:	89 da                	mov    %ebx,%edx
  80371a:	f7 f7                	div    %edi
  80371c:	89 d3                	mov    %edx,%ebx
  80371e:	f7 24 24             	mull   (%esp)
  803721:	89 c6                	mov    %eax,%esi
  803723:	89 d1                	mov    %edx,%ecx
  803725:	39 d3                	cmp    %edx,%ebx
  803727:	0f 82 87 00 00 00    	jb     8037b4 <__umoddi3+0x134>
  80372d:	0f 84 91 00 00 00    	je     8037c4 <__umoddi3+0x144>
  803733:	8b 54 24 04          	mov    0x4(%esp),%edx
  803737:	29 f2                	sub    %esi,%edx
  803739:	19 cb                	sbb    %ecx,%ebx
  80373b:	89 d8                	mov    %ebx,%eax
  80373d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803741:	d3 e0                	shl    %cl,%eax
  803743:	89 e9                	mov    %ebp,%ecx
  803745:	d3 ea                	shr    %cl,%edx
  803747:	09 d0                	or     %edx,%eax
  803749:	89 e9                	mov    %ebp,%ecx
  80374b:	d3 eb                	shr    %cl,%ebx
  80374d:	89 da                	mov    %ebx,%edx
  80374f:	83 c4 1c             	add    $0x1c,%esp
  803752:	5b                   	pop    %ebx
  803753:	5e                   	pop    %esi
  803754:	5f                   	pop    %edi
  803755:	5d                   	pop    %ebp
  803756:	c3                   	ret    
  803757:	90                   	nop
  803758:	89 fd                	mov    %edi,%ebp
  80375a:	85 ff                	test   %edi,%edi
  80375c:	75 0b                	jne    803769 <__umoddi3+0xe9>
  80375e:	b8 01 00 00 00       	mov    $0x1,%eax
  803763:	31 d2                	xor    %edx,%edx
  803765:	f7 f7                	div    %edi
  803767:	89 c5                	mov    %eax,%ebp
  803769:	89 f0                	mov    %esi,%eax
  80376b:	31 d2                	xor    %edx,%edx
  80376d:	f7 f5                	div    %ebp
  80376f:	89 c8                	mov    %ecx,%eax
  803771:	f7 f5                	div    %ebp
  803773:	89 d0                	mov    %edx,%eax
  803775:	e9 44 ff ff ff       	jmp    8036be <__umoddi3+0x3e>
  80377a:	66 90                	xchg   %ax,%ax
  80377c:	89 c8                	mov    %ecx,%eax
  80377e:	89 f2                	mov    %esi,%edx
  803780:	83 c4 1c             	add    $0x1c,%esp
  803783:	5b                   	pop    %ebx
  803784:	5e                   	pop    %esi
  803785:	5f                   	pop    %edi
  803786:	5d                   	pop    %ebp
  803787:	c3                   	ret    
  803788:	3b 04 24             	cmp    (%esp),%eax
  80378b:	72 06                	jb     803793 <__umoddi3+0x113>
  80378d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803791:	77 0f                	ja     8037a2 <__umoddi3+0x122>
  803793:	89 f2                	mov    %esi,%edx
  803795:	29 f9                	sub    %edi,%ecx
  803797:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80379b:	89 14 24             	mov    %edx,(%esp)
  80379e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037a2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8037a6:	8b 14 24             	mov    (%esp),%edx
  8037a9:	83 c4 1c             	add    $0x1c,%esp
  8037ac:	5b                   	pop    %ebx
  8037ad:	5e                   	pop    %esi
  8037ae:	5f                   	pop    %edi
  8037af:	5d                   	pop    %ebp
  8037b0:	c3                   	ret    
  8037b1:	8d 76 00             	lea    0x0(%esi),%esi
  8037b4:	2b 04 24             	sub    (%esp),%eax
  8037b7:	19 fa                	sbb    %edi,%edx
  8037b9:	89 d1                	mov    %edx,%ecx
  8037bb:	89 c6                	mov    %eax,%esi
  8037bd:	e9 71 ff ff ff       	jmp    803733 <__umoddi3+0xb3>
  8037c2:	66 90                	xchg   %ax,%ax
  8037c4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8037c8:	72 ea                	jb     8037b4 <__umoddi3+0x134>
  8037ca:	89 d9                	mov    %ebx,%ecx
  8037cc:	e9 62 ff ff ff       	jmp    803733 <__umoddi3+0xb3>

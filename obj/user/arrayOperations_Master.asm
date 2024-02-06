
obj/user/arrayOperations_Master:     file format elf32-i386


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
  800031:	e8 2b 07 00 00       	call   800761 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
uint32 CheckSorted(int *Elements, int NumOfElements);
void ArrayStats(int *Elements, int NumOfElements, int *mean, int *var);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 88 00 00 00    	sub    $0x88,%esp
	/*[1] CREATE SHARED ARRAY*/
	int ret;
	char Chose;
	char Line[30];
	//2012: lock the interrupt
	sys_disable_interrupt();
  800041:	e8 9a 21 00 00       	call   8021e0 <sys_disable_interrupt>
		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 c0 3a 80 00       	push   $0x803ac0
  80004e:	e8 fe 0a 00 00       	call   800b51 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 c2 3a 80 00       	push   $0x803ac2
  80005e:	e8 ee 0a 00 00       	call   800b51 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   ARRAY OOERATIONS   !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 e0 3a 80 00       	push   $0x803ae0
  80006e:	e8 de 0a 00 00       	call   800b51 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 c2 3a 80 00       	push   $0x803ac2
  80007e:	e8 ce 0a 00 00       	call   800b51 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 c0 3a 80 00       	push   $0x803ac0
  80008e:	e8 be 0a 00 00       	call   800b51 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 45 82             	lea    -0x7e(%ebp),%eax
  80009c:	50                   	push   %eax
  80009d:	68 00 3b 80 00       	push   $0x803b00
  8000a2:	e8 2c 11 00 00       	call   8011d3 <readline>
  8000a7:	83 c4 10             	add    $0x10,%esp

		//Create the shared array & its size
		int *arrSize = smalloc("arrSize", sizeof(int) , 0) ;
  8000aa:	83 ec 04             	sub    $0x4,%esp
  8000ad:	6a 00                	push   $0x0
  8000af:	6a 04                	push   $0x4
  8000b1:	68 1f 3b 80 00       	push   $0x803b1f
  8000b6:	e8 1f 1d 00 00       	call   801dda <smalloc>
  8000bb:	83 c4 10             	add    $0x10,%esp
  8000be:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*arrSize = strtol(Line, NULL, 10) ;
  8000c1:	83 ec 04             	sub    $0x4,%esp
  8000c4:	6a 0a                	push   $0xa
  8000c6:	6a 00                	push   $0x0
  8000c8:	8d 45 82             	lea    -0x7e(%ebp),%eax
  8000cb:	50                   	push   %eax
  8000cc:	e8 68 16 00 00       	call   801739 <strtol>
  8000d1:	83 c4 10             	add    $0x10,%esp
  8000d4:	89 c2                	mov    %eax,%edx
  8000d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000d9:	89 10                	mov    %edx,(%eax)
		int NumOfElements = *arrSize;
  8000db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000de:	8b 00                	mov    (%eax),%eax
  8000e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int *Elements = smalloc("arr", sizeof(int) * NumOfElements , 0) ;
  8000e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000e6:	c1 e0 02             	shl    $0x2,%eax
  8000e9:	83 ec 04             	sub    $0x4,%esp
  8000ec:	6a 00                	push   $0x0
  8000ee:	50                   	push   %eax
  8000ef:	68 27 3b 80 00       	push   $0x803b27
  8000f4:	e8 e1 1c 00 00       	call   801dda <smalloc>
  8000f9:	83 c4 10             	add    $0x10,%esp
  8000fc:	89 45 ec             	mov    %eax,-0x14(%ebp)

		cprintf("Chose the initialization method:\n") ;
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	68 2c 3b 80 00       	push   $0x803b2c
  800107:	e8 45 0a 00 00       	call   800b51 <cprintf>
  80010c:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 4e 3b 80 00       	push   $0x803b4e
  800117:	e8 35 0a 00 00       	call   800b51 <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	68 5c 3b 80 00       	push   $0x803b5c
  800127:	e8 25 0a 00 00       	call   800b51 <cprintf>
  80012c:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80012f:	83 ec 0c             	sub    $0xc,%esp
  800132:	68 6b 3b 80 00       	push   $0x803b6b
  800137:	e8 15 0a 00 00       	call   800b51 <cprintf>
  80013c:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	68 7b 3b 80 00       	push   $0x803b7b
  800147:	e8 05 0a 00 00       	call   800b51 <cprintf>
  80014c:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80014f:	e8 b5 05 00 00       	call   800709 <getchar>
  800154:	88 45 eb             	mov    %al,-0x15(%ebp)
			cputchar(Chose);
  800157:	0f be 45 eb          	movsbl -0x15(%ebp),%eax
  80015b:	83 ec 0c             	sub    $0xc,%esp
  80015e:	50                   	push   %eax
  80015f:	e8 5d 05 00 00       	call   8006c1 <cputchar>
  800164:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800167:	83 ec 0c             	sub    $0xc,%esp
  80016a:	6a 0a                	push   $0xa
  80016c:	e8 50 05 00 00       	call   8006c1 <cputchar>
  800171:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800174:	80 7d eb 61          	cmpb   $0x61,-0x15(%ebp)
  800178:	74 0c                	je     800186 <_main+0x14e>
  80017a:	80 7d eb 62          	cmpb   $0x62,-0x15(%ebp)
  80017e:	74 06                	je     800186 <_main+0x14e>
  800180:	80 7d eb 63          	cmpb   $0x63,-0x15(%ebp)
  800184:	75 b9                	jne    80013f <_main+0x107>

	//2012: unlock the interrupt
	sys_enable_interrupt();
  800186:	e8 6f 20 00 00       	call   8021fa <sys_enable_interrupt>

	int  i ;
	switch (Chose)
  80018b:	0f be 45 eb          	movsbl -0x15(%ebp),%eax
  80018f:	83 f8 62             	cmp    $0x62,%eax
  800192:	74 1d                	je     8001b1 <_main+0x179>
  800194:	83 f8 63             	cmp    $0x63,%eax
  800197:	74 2b                	je     8001c4 <_main+0x18c>
  800199:	83 f8 61             	cmp    $0x61,%eax
  80019c:	75 39                	jne    8001d7 <_main+0x19f>
	{
	case 'a':
		InitializeAscending(Elements, NumOfElements);
  80019e:	83 ec 08             	sub    $0x8,%esp
  8001a1:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a4:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a7:	e8 9b 03 00 00       	call   800547 <InitializeAscending>
  8001ac:	83 c4 10             	add    $0x10,%esp
		break ;
  8001af:	eb 37                	jmp    8001e8 <_main+0x1b0>
	case 'b':
		InitializeDescending(Elements, NumOfElements);
  8001b1:	83 ec 08             	sub    $0x8,%esp
  8001b4:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ba:	e8 b9 03 00 00       	call   800578 <InitializeDescending>
  8001bf:	83 c4 10             	add    $0x10,%esp
		break ;
  8001c2:	eb 24                	jmp    8001e8 <_main+0x1b0>
	case 'c':
		InitializeSemiRandom(Elements, NumOfElements);
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cd:	e8 db 03 00 00       	call   8005ad <InitializeSemiRandom>
  8001d2:	83 c4 10             	add    $0x10,%esp
		break ;
  8001d5:	eb 11                	jmp    8001e8 <_main+0x1b0>
	default:
		InitializeSemiRandom(Elements, NumOfElements);
  8001d7:	83 ec 08             	sub    $0x8,%esp
  8001da:	ff 75 f0             	pushl  -0x10(%ebp)
  8001dd:	ff 75 ec             	pushl  -0x14(%ebp)
  8001e0:	e8 c8 03 00 00       	call   8005ad <InitializeSemiRandom>
  8001e5:	83 c4 10             	add    $0x10,%esp
	}

	//Create the check-finishing counter
	int numOfSlaveProgs = 3 ;
  8001e8:	c7 45 e4 03 00 00 00 	movl   $0x3,-0x1c(%ebp)
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  8001ef:	83 ec 04             	sub    $0x4,%esp
  8001f2:	6a 01                	push   $0x1
  8001f4:	6a 04                	push   $0x4
  8001f6:	68 84 3b 80 00       	push   $0x803b84
  8001fb:	e8 da 1b 00 00       	call   801dda <smalloc>
  800200:	83 c4 10             	add    $0x10,%esp
  800203:	89 45 e0             	mov    %eax,-0x20(%ebp)
	*numOfFinished = 0 ;
  800206:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800209:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	/*[2] RUN THE SLAVES PROGRAMS*/
	int32 envIdQuickSort = sys_create_env("slave_qs", (myEnv->page_WS_max_size),(myEnv->SecondListSize) ,(myEnv->percentage_of_WS_pages_to_be_removed));
  80020f:	a1 20 50 80 00       	mov    0x805020,%eax
  800214:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80021a:	a1 20 50 80 00       	mov    0x805020,%eax
  80021f:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800225:	89 c1                	mov    %eax,%ecx
  800227:	a1 20 50 80 00       	mov    0x805020,%eax
  80022c:	8b 40 74             	mov    0x74(%eax),%eax
  80022f:	52                   	push   %edx
  800230:	51                   	push   %ecx
  800231:	50                   	push   %eax
  800232:	68 92 3b 80 00       	push   $0x803b92
  800237:	e8 29 21 00 00       	call   802365 <sys_create_env>
  80023c:	83 c4 10             	add    $0x10,%esp
  80023f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int32 envIdMergeSort = sys_create_env("slave_ms", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800242:	a1 20 50 80 00       	mov    0x805020,%eax
  800247:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80024d:	a1 20 50 80 00       	mov    0x805020,%eax
  800252:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800258:	89 c1                	mov    %eax,%ecx
  80025a:	a1 20 50 80 00       	mov    0x805020,%eax
  80025f:	8b 40 74             	mov    0x74(%eax),%eax
  800262:	52                   	push   %edx
  800263:	51                   	push   %ecx
  800264:	50                   	push   %eax
  800265:	68 9b 3b 80 00       	push   $0x803b9b
  80026a:	e8 f6 20 00 00       	call   802365 <sys_create_env>
  80026f:	83 c4 10             	add    $0x10,%esp
  800272:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int32 envIdStats = sys_create_env("slave_stats", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800275:	a1 20 50 80 00       	mov    0x805020,%eax
  80027a:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800280:	a1 20 50 80 00       	mov    0x805020,%eax
  800285:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80028b:	89 c1                	mov    %eax,%ecx
  80028d:	a1 20 50 80 00       	mov    0x805020,%eax
  800292:	8b 40 74             	mov    0x74(%eax),%eax
  800295:	52                   	push   %edx
  800296:	51                   	push   %ecx
  800297:	50                   	push   %eax
  800298:	68 a4 3b 80 00       	push   $0x803ba4
  80029d:	e8 c3 20 00 00       	call   802365 <sys_create_env>
  8002a2:	83 c4 10             	add    $0x10,%esp
  8002a5:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if (envIdQuickSort == E_ENV_CREATION_ERROR || envIdMergeSort == E_ENV_CREATION_ERROR || envIdStats == E_ENV_CREATION_ERROR)
  8002a8:	83 7d dc ef          	cmpl   $0xffffffef,-0x24(%ebp)
  8002ac:	74 0c                	je     8002ba <_main+0x282>
  8002ae:	83 7d d8 ef          	cmpl   $0xffffffef,-0x28(%ebp)
  8002b2:	74 06                	je     8002ba <_main+0x282>
  8002b4:	83 7d d4 ef          	cmpl   $0xffffffef,-0x2c(%ebp)
  8002b8:	75 14                	jne    8002ce <_main+0x296>
		panic("NO AVAILABLE ENVs...");
  8002ba:	83 ec 04             	sub    $0x4,%esp
  8002bd:	68 b0 3b 80 00       	push   $0x803bb0
  8002c2:	6a 4b                	push   $0x4b
  8002c4:	68 c5 3b 80 00       	push   $0x803bc5
  8002c9:	e8 cf 05 00 00       	call   80089d <_panic>

	sys_run_env(envIdQuickSort);
  8002ce:	83 ec 0c             	sub    $0xc,%esp
  8002d1:	ff 75 dc             	pushl  -0x24(%ebp)
  8002d4:	e8 aa 20 00 00       	call   802383 <sys_run_env>
  8002d9:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdMergeSort);
  8002dc:	83 ec 0c             	sub    $0xc,%esp
  8002df:	ff 75 d8             	pushl  -0x28(%ebp)
  8002e2:	e8 9c 20 00 00       	call   802383 <sys_run_env>
  8002e7:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdStats);
  8002ea:	83 ec 0c             	sub    $0xc,%esp
  8002ed:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002f0:	e8 8e 20 00 00       	call   802383 <sys_run_env>
  8002f5:	83 c4 10             	add    $0x10,%esp

	/*[3] BUSY-WAIT TILL FINISHING THEM*/
	while (*numOfFinished != numOfSlaveProgs) ;
  8002f8:	90                   	nop
  8002f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002fc:	8b 00                	mov    (%eax),%eax
  8002fe:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800301:	75 f6                	jne    8002f9 <_main+0x2c1>

	/*[4] GET THEIR RESULTS*/
	int *quicksortedArr = NULL;
  800303:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
	int *mergesortedArr = NULL;
  80030a:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
	int *mean = NULL;
  800311:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
	int *var = NULL;
  800318:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
	int *min = NULL;
  80031f:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
	int *max = NULL;
  800326:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int *med = NULL;
  80032d:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
	quicksortedArr = sget(envIdQuickSort, "quicksortedArr") ;
  800334:	83 ec 08             	sub    $0x8,%esp
  800337:	68 e3 3b 80 00       	push   $0x803be3
  80033c:	ff 75 dc             	pushl  -0x24(%ebp)
  80033f:	e8 68 1b 00 00       	call   801eac <sget>
  800344:	83 c4 10             	add    $0x10,%esp
  800347:	89 45 d0             	mov    %eax,-0x30(%ebp)
	mergesortedArr = sget(envIdMergeSort, "mergesortedArr") ;
  80034a:	83 ec 08             	sub    $0x8,%esp
  80034d:	68 f2 3b 80 00       	push   $0x803bf2
  800352:	ff 75 d8             	pushl  -0x28(%ebp)
  800355:	e8 52 1b 00 00       	call   801eac <sget>
  80035a:	83 c4 10             	add    $0x10,%esp
  80035d:	89 45 cc             	mov    %eax,-0x34(%ebp)
	mean = sget(envIdStats, "mean") ;
  800360:	83 ec 08             	sub    $0x8,%esp
  800363:	68 01 3c 80 00       	push   $0x803c01
  800368:	ff 75 d4             	pushl  -0x2c(%ebp)
  80036b:	e8 3c 1b 00 00       	call   801eac <sget>
  800370:	83 c4 10             	add    $0x10,%esp
  800373:	89 45 c8             	mov    %eax,-0x38(%ebp)
	var = sget(envIdStats,"var") ;
  800376:	83 ec 08             	sub    $0x8,%esp
  800379:	68 06 3c 80 00       	push   $0x803c06
  80037e:	ff 75 d4             	pushl  -0x2c(%ebp)
  800381:	e8 26 1b 00 00       	call   801eac <sget>
  800386:	83 c4 10             	add    $0x10,%esp
  800389:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	min = sget(envIdStats,"min") ;
  80038c:	83 ec 08             	sub    $0x8,%esp
  80038f:	68 0a 3c 80 00       	push   $0x803c0a
  800394:	ff 75 d4             	pushl  -0x2c(%ebp)
  800397:	e8 10 1b 00 00       	call   801eac <sget>
  80039c:	83 c4 10             	add    $0x10,%esp
  80039f:	89 45 c0             	mov    %eax,-0x40(%ebp)
	max = sget(envIdStats,"max") ;
  8003a2:	83 ec 08             	sub    $0x8,%esp
  8003a5:	68 0e 3c 80 00       	push   $0x803c0e
  8003aa:	ff 75 d4             	pushl  -0x2c(%ebp)
  8003ad:	e8 fa 1a 00 00       	call   801eac <sget>
  8003b2:	83 c4 10             	add    $0x10,%esp
  8003b5:	89 45 bc             	mov    %eax,-0x44(%ebp)
	med = sget(envIdStats,"med") ;
  8003b8:	83 ec 08             	sub    $0x8,%esp
  8003bb:	68 12 3c 80 00       	push   $0x803c12
  8003c0:	ff 75 d4             	pushl  -0x2c(%ebp)
  8003c3:	e8 e4 1a 00 00       	call   801eac <sget>
  8003c8:	83 c4 10             	add    $0x10,%esp
  8003cb:	89 45 b8             	mov    %eax,-0x48(%ebp)

	/*[5] VALIDATE THE RESULTS*/
	uint32 sorted = CheckSorted(quicksortedArr, NumOfElements);
  8003ce:	83 ec 08             	sub    $0x8,%esp
  8003d1:	ff 75 f0             	pushl  -0x10(%ebp)
  8003d4:	ff 75 d0             	pushl  -0x30(%ebp)
  8003d7:	e8 14 01 00 00       	call   8004f0 <CheckSorted>
  8003dc:	83 c4 10             	add    $0x10,%esp
  8003df:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(sorted == 0) panic("The array is NOT quick-sorted correctly") ;
  8003e2:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  8003e6:	75 14                	jne    8003fc <_main+0x3c4>
  8003e8:	83 ec 04             	sub    $0x4,%esp
  8003eb:	68 18 3c 80 00       	push   $0x803c18
  8003f0:	6a 66                	push   $0x66
  8003f2:	68 c5 3b 80 00       	push   $0x803bc5
  8003f7:	e8 a1 04 00 00       	call   80089d <_panic>
	sorted = CheckSorted(mergesortedArr, NumOfElements);
  8003fc:	83 ec 08             	sub    $0x8,%esp
  8003ff:	ff 75 f0             	pushl  -0x10(%ebp)
  800402:	ff 75 cc             	pushl  -0x34(%ebp)
  800405:	e8 e6 00 00 00       	call   8004f0 <CheckSorted>
  80040a:	83 c4 10             	add    $0x10,%esp
  80040d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(sorted == 0) panic("The array is NOT merge-sorted correctly") ;
  800410:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  800414:	75 14                	jne    80042a <_main+0x3f2>
  800416:	83 ec 04             	sub    $0x4,%esp
  800419:	68 40 3c 80 00       	push   $0x803c40
  80041e:	6a 68                	push   $0x68
  800420:	68 c5 3b 80 00       	push   $0x803bc5
  800425:	e8 73 04 00 00       	call   80089d <_panic>
	int correctMean, correctVar ;
	ArrayStats(Elements, NumOfElements, &correctMean , &correctVar);
  80042a:	8d 85 78 ff ff ff    	lea    -0x88(%ebp),%eax
  800430:	50                   	push   %eax
  800431:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800437:	50                   	push   %eax
  800438:	ff 75 f0             	pushl  -0x10(%ebp)
  80043b:	ff 75 ec             	pushl  -0x14(%ebp)
  80043e:	e8 b6 01 00 00       	call   8005f9 <ArrayStats>
  800443:	83 c4 10             	add    $0x10,%esp
	int correctMin = quicksortedArr[0];
  800446:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800449:	8b 00                	mov    (%eax),%eax
  80044b:	89 45 b0             	mov    %eax,-0x50(%ebp)
	int last = NumOfElements-1;
  80044e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800451:	48                   	dec    %eax
  800452:	89 45 ac             	mov    %eax,-0x54(%ebp)
	int middle = (NumOfElements-1)/2;
  800455:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800458:	48                   	dec    %eax
  800459:	89 c2                	mov    %eax,%edx
  80045b:	c1 ea 1f             	shr    $0x1f,%edx
  80045e:	01 d0                	add    %edx,%eax
  800460:	d1 f8                	sar    %eax
  800462:	89 45 a8             	mov    %eax,-0x58(%ebp)
	int correctMax = quicksortedArr[last];
  800465:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800468:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80046f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800472:	01 d0                	add    %edx,%eax
  800474:	8b 00                	mov    (%eax),%eax
  800476:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int correctMed = quicksortedArr[middle];
  800479:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80047c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800483:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800486:	01 d0                	add    %edx,%eax
  800488:	8b 00                	mov    (%eax),%eax
  80048a:	89 45 a0             	mov    %eax,-0x60(%ebp)
	//cprintf("Array is correctly sorted\n");
	//cprintf("mean = %d, var = %d\nmin = %d, max = %d, med = %d\n", *mean, *var, *min, *max, *med);
	//cprintf("mean = %d, var = %d\nmin = %d, max = %d, med = %d\n", correctMean, correctVar, correctMin, correctMax, correctMed);

	if(*mean != correctMean || *var != correctVar|| *min != correctMin || *max != correctMax || *med != correctMed)
  80048d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800490:	8b 10                	mov    (%eax),%edx
  800492:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800498:	39 c2                	cmp    %eax,%edx
  80049a:	75 2d                	jne    8004c9 <_main+0x491>
  80049c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80049f:	8b 10                	mov    (%eax),%edx
  8004a1:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  8004a7:	39 c2                	cmp    %eax,%edx
  8004a9:	75 1e                	jne    8004c9 <_main+0x491>
  8004ab:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8004ae:	8b 00                	mov    (%eax),%eax
  8004b0:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  8004b3:	75 14                	jne    8004c9 <_main+0x491>
  8004b5:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8004b8:	8b 00                	mov    (%eax),%eax
  8004ba:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8004bd:	75 0a                	jne    8004c9 <_main+0x491>
  8004bf:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8004c2:	8b 00                	mov    (%eax),%eax
  8004c4:	3b 45 a0             	cmp    -0x60(%ebp),%eax
  8004c7:	74 14                	je     8004dd <_main+0x4a5>
		panic("The array STATS are NOT calculated correctly") ;
  8004c9:	83 ec 04             	sub    $0x4,%esp
  8004cc:	68 68 3c 80 00       	push   $0x803c68
  8004d1:	6a 75                	push   $0x75
  8004d3:	68 c5 3b 80 00       	push   $0x803bc5
  8004d8:	e8 c0 03 00 00       	call   80089d <_panic>

	cprintf("Congratulations!! Scenario of Using the Shared Variables [Create & Get] completed successfully!!\n\n\n");
  8004dd:	83 ec 0c             	sub    $0xc,%esp
  8004e0:	68 98 3c 80 00       	push   $0x803c98
  8004e5:	e8 67 06 00 00       	call   800b51 <cprintf>
  8004ea:	83 c4 10             	add    $0x10,%esp

	return;
  8004ed:	90                   	nop
}
  8004ee:	c9                   	leave  
  8004ef:	c3                   	ret    

008004f0 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8004f0:	55                   	push   %ebp
  8004f1:	89 e5                	mov    %esp,%ebp
  8004f3:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8004f6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8004fd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800504:	eb 33                	jmp    800539 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  800506:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800509:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800510:	8b 45 08             	mov    0x8(%ebp),%eax
  800513:	01 d0                	add    %edx,%eax
  800515:	8b 10                	mov    (%eax),%edx
  800517:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80051a:	40                   	inc    %eax
  80051b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800522:	8b 45 08             	mov    0x8(%ebp),%eax
  800525:	01 c8                	add    %ecx,%eax
  800527:	8b 00                	mov    (%eax),%eax
  800529:	39 c2                	cmp    %eax,%edx
  80052b:	7e 09                	jle    800536 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  80052d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800534:	eb 0c                	jmp    800542 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800536:	ff 45 f8             	incl   -0x8(%ebp)
  800539:	8b 45 0c             	mov    0xc(%ebp),%eax
  80053c:	48                   	dec    %eax
  80053d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800540:	7f c4                	jg     800506 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800542:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800545:	c9                   	leave  
  800546:	c3                   	ret    

00800547 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  800547:	55                   	push   %ebp
  800548:	89 e5                	mov    %esp,%ebp
  80054a:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80054d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800554:	eb 17                	jmp    80056d <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  800556:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800559:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800560:	8b 45 08             	mov    0x8(%ebp),%eax
  800563:	01 c2                	add    %eax,%edx
  800565:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800568:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80056a:	ff 45 fc             	incl   -0x4(%ebp)
  80056d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800570:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800573:	7c e1                	jl     800556 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  800575:	90                   	nop
  800576:	c9                   	leave  
  800577:	c3                   	ret    

00800578 <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  800578:	55                   	push   %ebp
  800579:	89 e5                	mov    %esp,%ebp
  80057b:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80057e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800585:	eb 1b                	jmp    8005a2 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  800587:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80058a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800591:	8b 45 08             	mov    0x8(%ebp),%eax
  800594:	01 c2                	add    %eax,%edx
  800596:	8b 45 0c             	mov    0xc(%ebp),%eax
  800599:	2b 45 fc             	sub    -0x4(%ebp),%eax
  80059c:	48                   	dec    %eax
  80059d:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80059f:	ff 45 fc             	incl   -0x4(%ebp)
  8005a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8005a5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005a8:	7c dd                	jl     800587 <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8005aa:	90                   	nop
  8005ab:	c9                   	leave  
  8005ac:	c3                   	ret    

008005ad <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8005ad:	55                   	push   %ebp
  8005ae:	89 e5                	mov    %esp,%ebp
  8005b0:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8005b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005b6:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8005bb:	f7 e9                	imul   %ecx
  8005bd:	c1 f9 1f             	sar    $0x1f,%ecx
  8005c0:	89 d0                	mov    %edx,%eax
  8005c2:	29 c8                	sub    %ecx,%eax
  8005c4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8005c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8005ce:	eb 1e                	jmp    8005ee <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  8005d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8005d3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005da:	8b 45 08             	mov    0x8(%ebp),%eax
  8005dd:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8005e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8005e3:	99                   	cltd   
  8005e4:	f7 7d f8             	idivl  -0x8(%ebp)
  8005e7:	89 d0                	mov    %edx,%eax
  8005e9:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  8005eb:	ff 45 fc             	incl   -0x4(%ebp)
  8005ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8005f1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005f4:	7c da                	jl     8005d0 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//cprintf("Elements[%d] = %d\n",i, Elements[i]);
	}

}
  8005f6:	90                   	nop
  8005f7:	c9                   	leave  
  8005f8:	c3                   	ret    

008005f9 <ArrayStats>:

void ArrayStats(int *Elements, int NumOfElements, int *mean, int *var)
{
  8005f9:	55                   	push   %ebp
  8005fa:	89 e5                	mov    %esp,%ebp
  8005fc:	53                   	push   %ebx
  8005fd:	83 ec 10             	sub    $0x10,%esp
	int i ;
	*mean =0 ;
  800600:	8b 45 10             	mov    0x10(%ebp),%eax
  800603:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  800609:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800610:	eb 20                	jmp    800632 <ArrayStats+0x39>
	{
		*mean += Elements[i];
  800612:	8b 45 10             	mov    0x10(%ebp),%eax
  800615:	8b 10                	mov    (%eax),%edx
  800617:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80061a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800621:	8b 45 08             	mov    0x8(%ebp),%eax
  800624:	01 c8                	add    %ecx,%eax
  800626:	8b 00                	mov    (%eax),%eax
  800628:	01 c2                	add    %eax,%edx
  80062a:	8b 45 10             	mov    0x10(%ebp),%eax
  80062d:	89 10                	mov    %edx,(%eax)

void ArrayStats(int *Elements, int NumOfElements, int *mean, int *var)
{
	int i ;
	*mean =0 ;
	for (i = 0 ; i < NumOfElements ; i++)
  80062f:	ff 45 f8             	incl   -0x8(%ebp)
  800632:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800635:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800638:	7c d8                	jl     800612 <ArrayStats+0x19>
	{
		*mean += Elements[i];
	}
	*mean /= NumOfElements;
  80063a:	8b 45 10             	mov    0x10(%ebp),%eax
  80063d:	8b 00                	mov    (%eax),%eax
  80063f:	99                   	cltd   
  800640:	f7 7d 0c             	idivl  0xc(%ebp)
  800643:	89 c2                	mov    %eax,%edx
  800645:	8b 45 10             	mov    0x10(%ebp),%eax
  800648:	89 10                	mov    %edx,(%eax)
	*var = 0;
  80064a:	8b 45 14             	mov    0x14(%ebp),%eax
  80064d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  800653:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80065a:	eb 46                	jmp    8006a2 <ArrayStats+0xa9>
	{
		*var += (Elements[i] - *mean)*(Elements[i] - *mean);
  80065c:	8b 45 14             	mov    0x14(%ebp),%eax
  80065f:	8b 10                	mov    (%eax),%edx
  800661:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800664:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80066b:	8b 45 08             	mov    0x8(%ebp),%eax
  80066e:	01 c8                	add    %ecx,%eax
  800670:	8b 08                	mov    (%eax),%ecx
  800672:	8b 45 10             	mov    0x10(%ebp),%eax
  800675:	8b 00                	mov    (%eax),%eax
  800677:	89 cb                	mov    %ecx,%ebx
  800679:	29 c3                	sub    %eax,%ebx
  80067b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80067e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800685:	8b 45 08             	mov    0x8(%ebp),%eax
  800688:	01 c8                	add    %ecx,%eax
  80068a:	8b 08                	mov    (%eax),%ecx
  80068c:	8b 45 10             	mov    0x10(%ebp),%eax
  80068f:	8b 00                	mov    (%eax),%eax
  800691:	29 c1                	sub    %eax,%ecx
  800693:	89 c8                	mov    %ecx,%eax
  800695:	0f af c3             	imul   %ebx,%eax
  800698:	01 c2                	add    %eax,%edx
  80069a:	8b 45 14             	mov    0x14(%ebp),%eax
  80069d:	89 10                	mov    %edx,(%eax)
	{
		*mean += Elements[i];
	}
	*mean /= NumOfElements;
	*var = 0;
	for (i = 0 ; i < NumOfElements ; i++)
  80069f:	ff 45 f8             	incl   -0x8(%ebp)
  8006a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8006a5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006a8:	7c b2                	jl     80065c <ArrayStats+0x63>
	{
		*var += (Elements[i] - *mean)*(Elements[i] - *mean);
	}
	*var /= NumOfElements;
  8006aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ad:	8b 00                	mov    (%eax),%eax
  8006af:	99                   	cltd   
  8006b0:	f7 7d 0c             	idivl  0xc(%ebp)
  8006b3:	89 c2                	mov    %eax,%edx
  8006b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b8:	89 10                	mov    %edx,(%eax)
}
  8006ba:	90                   	nop
  8006bb:	83 c4 10             	add    $0x10,%esp
  8006be:	5b                   	pop    %ebx
  8006bf:	5d                   	pop    %ebp
  8006c0:	c3                   	ret    

008006c1 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8006c1:	55                   	push   %ebp
  8006c2:	89 e5                	mov    %esp,%ebp
  8006c4:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8006c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ca:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8006cd:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8006d1:	83 ec 0c             	sub    $0xc,%esp
  8006d4:	50                   	push   %eax
  8006d5:	e8 3a 1b 00 00       	call   802214 <sys_cputc>
  8006da:	83 c4 10             	add    $0x10,%esp
}
  8006dd:	90                   	nop
  8006de:	c9                   	leave  
  8006df:	c3                   	ret    

008006e0 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8006e0:	55                   	push   %ebp
  8006e1:	89 e5                	mov    %esp,%ebp
  8006e3:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8006e6:	e8 f5 1a 00 00       	call   8021e0 <sys_disable_interrupt>
	char c = ch;
  8006eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ee:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8006f1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8006f5:	83 ec 0c             	sub    $0xc,%esp
  8006f8:	50                   	push   %eax
  8006f9:	e8 16 1b 00 00       	call   802214 <sys_cputc>
  8006fe:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800701:	e8 f4 1a 00 00       	call   8021fa <sys_enable_interrupt>
}
  800706:	90                   	nop
  800707:	c9                   	leave  
  800708:	c3                   	ret    

00800709 <getchar>:

int
getchar(void)
{
  800709:	55                   	push   %ebp
  80070a:	89 e5                	mov    %esp,%ebp
  80070c:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  80070f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800716:	eb 08                	jmp    800720 <getchar+0x17>
	{
		c = sys_cgetc();
  800718:	e8 3e 19 00 00       	call   80205b <sys_cgetc>
  80071d:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800720:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800724:	74 f2                	je     800718 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  800726:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800729:	c9                   	leave  
  80072a:	c3                   	ret    

0080072b <atomic_getchar>:

int
atomic_getchar(void)
{
  80072b:	55                   	push   %ebp
  80072c:	89 e5                	mov    %esp,%ebp
  80072e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800731:	e8 aa 1a 00 00       	call   8021e0 <sys_disable_interrupt>
	int c=0;
  800736:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80073d:	eb 08                	jmp    800747 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  80073f:	e8 17 19 00 00       	call   80205b <sys_cgetc>
  800744:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  800747:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80074b:	74 f2                	je     80073f <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  80074d:	e8 a8 1a 00 00       	call   8021fa <sys_enable_interrupt>
	return c;
  800752:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800755:	c9                   	leave  
  800756:	c3                   	ret    

00800757 <iscons>:

int iscons(int fdnum)
{
  800757:	55                   	push   %ebp
  800758:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80075a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80075f:	5d                   	pop    %ebp
  800760:	c3                   	ret    

00800761 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800761:	55                   	push   %ebp
  800762:	89 e5                	mov    %esp,%ebp
  800764:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800767:	e8 67 1c 00 00       	call   8023d3 <sys_getenvindex>
  80076c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80076f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800772:	89 d0                	mov    %edx,%eax
  800774:	c1 e0 03             	shl    $0x3,%eax
  800777:	01 d0                	add    %edx,%eax
  800779:	01 c0                	add    %eax,%eax
  80077b:	01 d0                	add    %edx,%eax
  80077d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800784:	01 d0                	add    %edx,%eax
  800786:	c1 e0 04             	shl    $0x4,%eax
  800789:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80078e:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800793:	a1 20 50 80 00       	mov    0x805020,%eax
  800798:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80079e:	84 c0                	test   %al,%al
  8007a0:	74 0f                	je     8007b1 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8007a2:	a1 20 50 80 00       	mov    0x805020,%eax
  8007a7:	05 5c 05 00 00       	add    $0x55c,%eax
  8007ac:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8007b5:	7e 0a                	jle    8007c1 <libmain+0x60>
		binaryname = argv[0];
  8007b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007ba:	8b 00                	mov    (%eax),%eax
  8007bc:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8007c1:	83 ec 08             	sub    $0x8,%esp
  8007c4:	ff 75 0c             	pushl  0xc(%ebp)
  8007c7:	ff 75 08             	pushl  0x8(%ebp)
  8007ca:	e8 69 f8 ff ff       	call   800038 <_main>
  8007cf:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8007d2:	e8 09 1a 00 00       	call   8021e0 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8007d7:	83 ec 0c             	sub    $0xc,%esp
  8007da:	68 14 3d 80 00       	push   $0x803d14
  8007df:	e8 6d 03 00 00       	call   800b51 <cprintf>
  8007e4:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8007e7:	a1 20 50 80 00       	mov    0x805020,%eax
  8007ec:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8007f2:	a1 20 50 80 00       	mov    0x805020,%eax
  8007f7:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8007fd:	83 ec 04             	sub    $0x4,%esp
  800800:	52                   	push   %edx
  800801:	50                   	push   %eax
  800802:	68 3c 3d 80 00       	push   $0x803d3c
  800807:	e8 45 03 00 00       	call   800b51 <cprintf>
  80080c:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80080f:	a1 20 50 80 00       	mov    0x805020,%eax
  800814:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80081a:	a1 20 50 80 00       	mov    0x805020,%eax
  80081f:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800825:	a1 20 50 80 00       	mov    0x805020,%eax
  80082a:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800830:	51                   	push   %ecx
  800831:	52                   	push   %edx
  800832:	50                   	push   %eax
  800833:	68 64 3d 80 00       	push   $0x803d64
  800838:	e8 14 03 00 00       	call   800b51 <cprintf>
  80083d:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800840:	a1 20 50 80 00       	mov    0x805020,%eax
  800845:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80084b:	83 ec 08             	sub    $0x8,%esp
  80084e:	50                   	push   %eax
  80084f:	68 bc 3d 80 00       	push   $0x803dbc
  800854:	e8 f8 02 00 00       	call   800b51 <cprintf>
  800859:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80085c:	83 ec 0c             	sub    $0xc,%esp
  80085f:	68 14 3d 80 00       	push   $0x803d14
  800864:	e8 e8 02 00 00       	call   800b51 <cprintf>
  800869:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80086c:	e8 89 19 00 00       	call   8021fa <sys_enable_interrupt>

	// exit gracefully
	exit();
  800871:	e8 19 00 00 00       	call   80088f <exit>
}
  800876:	90                   	nop
  800877:	c9                   	leave  
  800878:	c3                   	ret    

00800879 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800879:	55                   	push   %ebp
  80087a:	89 e5                	mov    %esp,%ebp
  80087c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80087f:	83 ec 0c             	sub    $0xc,%esp
  800882:	6a 00                	push   $0x0
  800884:	e8 16 1b 00 00       	call   80239f <sys_destroy_env>
  800889:	83 c4 10             	add    $0x10,%esp
}
  80088c:	90                   	nop
  80088d:	c9                   	leave  
  80088e:	c3                   	ret    

0080088f <exit>:

void
exit(void)
{
  80088f:	55                   	push   %ebp
  800890:	89 e5                	mov    %esp,%ebp
  800892:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800895:	e8 6b 1b 00 00       	call   802405 <sys_exit_env>
}
  80089a:	90                   	nop
  80089b:	c9                   	leave  
  80089c:	c3                   	ret    

0080089d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80089d:	55                   	push   %ebp
  80089e:	89 e5                	mov    %esp,%ebp
  8008a0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8008a3:	8d 45 10             	lea    0x10(%ebp),%eax
  8008a6:	83 c0 04             	add    $0x4,%eax
  8008a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8008ac:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8008b1:	85 c0                	test   %eax,%eax
  8008b3:	74 16                	je     8008cb <_panic+0x2e>
		cprintf("%s: ", argv0);
  8008b5:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8008ba:	83 ec 08             	sub    $0x8,%esp
  8008bd:	50                   	push   %eax
  8008be:	68 d0 3d 80 00       	push   $0x803dd0
  8008c3:	e8 89 02 00 00       	call   800b51 <cprintf>
  8008c8:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8008cb:	a1 00 50 80 00       	mov    0x805000,%eax
  8008d0:	ff 75 0c             	pushl  0xc(%ebp)
  8008d3:	ff 75 08             	pushl  0x8(%ebp)
  8008d6:	50                   	push   %eax
  8008d7:	68 d5 3d 80 00       	push   $0x803dd5
  8008dc:	e8 70 02 00 00       	call   800b51 <cprintf>
  8008e1:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8008e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8008e7:	83 ec 08             	sub    $0x8,%esp
  8008ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8008ed:	50                   	push   %eax
  8008ee:	e8 f3 01 00 00       	call   800ae6 <vcprintf>
  8008f3:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8008f6:	83 ec 08             	sub    $0x8,%esp
  8008f9:	6a 00                	push   $0x0
  8008fb:	68 f1 3d 80 00       	push   $0x803df1
  800900:	e8 e1 01 00 00       	call   800ae6 <vcprintf>
  800905:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800908:	e8 82 ff ff ff       	call   80088f <exit>

	// should not return here
	while (1) ;
  80090d:	eb fe                	jmp    80090d <_panic+0x70>

0080090f <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80090f:	55                   	push   %ebp
  800910:	89 e5                	mov    %esp,%ebp
  800912:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800915:	a1 20 50 80 00       	mov    0x805020,%eax
  80091a:	8b 50 74             	mov    0x74(%eax),%edx
  80091d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800920:	39 c2                	cmp    %eax,%edx
  800922:	74 14                	je     800938 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800924:	83 ec 04             	sub    $0x4,%esp
  800927:	68 f4 3d 80 00       	push   $0x803df4
  80092c:	6a 26                	push   $0x26
  80092e:	68 40 3e 80 00       	push   $0x803e40
  800933:	e8 65 ff ff ff       	call   80089d <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800938:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80093f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800946:	e9 c2 00 00 00       	jmp    800a0d <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80094b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80094e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800955:	8b 45 08             	mov    0x8(%ebp),%eax
  800958:	01 d0                	add    %edx,%eax
  80095a:	8b 00                	mov    (%eax),%eax
  80095c:	85 c0                	test   %eax,%eax
  80095e:	75 08                	jne    800968 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800960:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800963:	e9 a2 00 00 00       	jmp    800a0a <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800968:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80096f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800976:	eb 69                	jmp    8009e1 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800978:	a1 20 50 80 00       	mov    0x805020,%eax
  80097d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800983:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800986:	89 d0                	mov    %edx,%eax
  800988:	01 c0                	add    %eax,%eax
  80098a:	01 d0                	add    %edx,%eax
  80098c:	c1 e0 03             	shl    $0x3,%eax
  80098f:	01 c8                	add    %ecx,%eax
  800991:	8a 40 04             	mov    0x4(%eax),%al
  800994:	84 c0                	test   %al,%al
  800996:	75 46                	jne    8009de <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800998:	a1 20 50 80 00       	mov    0x805020,%eax
  80099d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009a3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009a6:	89 d0                	mov    %edx,%eax
  8009a8:	01 c0                	add    %eax,%eax
  8009aa:	01 d0                	add    %edx,%eax
  8009ac:	c1 e0 03             	shl    $0x3,%eax
  8009af:	01 c8                	add    %ecx,%eax
  8009b1:	8b 00                	mov    (%eax),%eax
  8009b3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8009b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8009b9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8009be:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8009c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009c3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8009ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cd:	01 c8                	add    %ecx,%eax
  8009cf:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009d1:	39 c2                	cmp    %eax,%edx
  8009d3:	75 09                	jne    8009de <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8009d5:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8009dc:	eb 12                	jmp    8009f0 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009de:	ff 45 e8             	incl   -0x18(%ebp)
  8009e1:	a1 20 50 80 00       	mov    0x805020,%eax
  8009e6:	8b 50 74             	mov    0x74(%eax),%edx
  8009e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8009ec:	39 c2                	cmp    %eax,%edx
  8009ee:	77 88                	ja     800978 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8009f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8009f4:	75 14                	jne    800a0a <CheckWSWithoutLastIndex+0xfb>
			panic(
  8009f6:	83 ec 04             	sub    $0x4,%esp
  8009f9:	68 4c 3e 80 00       	push   $0x803e4c
  8009fe:	6a 3a                	push   $0x3a
  800a00:	68 40 3e 80 00       	push   $0x803e40
  800a05:	e8 93 fe ff ff       	call   80089d <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a0a:	ff 45 f0             	incl   -0x10(%ebp)
  800a0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a10:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a13:	0f 8c 32 ff ff ff    	jl     80094b <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a19:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a20:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a27:	eb 26                	jmp    800a4f <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a29:	a1 20 50 80 00       	mov    0x805020,%eax
  800a2e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800a34:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a37:	89 d0                	mov    %edx,%eax
  800a39:	01 c0                	add    %eax,%eax
  800a3b:	01 d0                	add    %edx,%eax
  800a3d:	c1 e0 03             	shl    $0x3,%eax
  800a40:	01 c8                	add    %ecx,%eax
  800a42:	8a 40 04             	mov    0x4(%eax),%al
  800a45:	3c 01                	cmp    $0x1,%al
  800a47:	75 03                	jne    800a4c <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800a49:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a4c:	ff 45 e0             	incl   -0x20(%ebp)
  800a4f:	a1 20 50 80 00       	mov    0x805020,%eax
  800a54:	8b 50 74             	mov    0x74(%eax),%edx
  800a57:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a5a:	39 c2                	cmp    %eax,%edx
  800a5c:	77 cb                	ja     800a29 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a61:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800a64:	74 14                	je     800a7a <CheckWSWithoutLastIndex+0x16b>
		panic(
  800a66:	83 ec 04             	sub    $0x4,%esp
  800a69:	68 a0 3e 80 00       	push   $0x803ea0
  800a6e:	6a 44                	push   $0x44
  800a70:	68 40 3e 80 00       	push   $0x803e40
  800a75:	e8 23 fe ff ff       	call   80089d <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800a7a:	90                   	nop
  800a7b:	c9                   	leave  
  800a7c:	c3                   	ret    

00800a7d <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800a7d:	55                   	push   %ebp
  800a7e:	89 e5                	mov    %esp,%ebp
  800a80:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800a83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a86:	8b 00                	mov    (%eax),%eax
  800a88:	8d 48 01             	lea    0x1(%eax),%ecx
  800a8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a8e:	89 0a                	mov    %ecx,(%edx)
  800a90:	8b 55 08             	mov    0x8(%ebp),%edx
  800a93:	88 d1                	mov    %dl,%cl
  800a95:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a98:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800a9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a9f:	8b 00                	mov    (%eax),%eax
  800aa1:	3d ff 00 00 00       	cmp    $0xff,%eax
  800aa6:	75 2c                	jne    800ad4 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800aa8:	a0 24 50 80 00       	mov    0x805024,%al
  800aad:	0f b6 c0             	movzbl %al,%eax
  800ab0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ab3:	8b 12                	mov    (%edx),%edx
  800ab5:	89 d1                	mov    %edx,%ecx
  800ab7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aba:	83 c2 08             	add    $0x8,%edx
  800abd:	83 ec 04             	sub    $0x4,%esp
  800ac0:	50                   	push   %eax
  800ac1:	51                   	push   %ecx
  800ac2:	52                   	push   %edx
  800ac3:	e8 6a 15 00 00       	call   802032 <sys_cputs>
  800ac8:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800acb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ace:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800ad4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad7:	8b 40 04             	mov    0x4(%eax),%eax
  800ada:	8d 50 01             	lea    0x1(%eax),%edx
  800add:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae0:	89 50 04             	mov    %edx,0x4(%eax)
}
  800ae3:	90                   	nop
  800ae4:	c9                   	leave  
  800ae5:	c3                   	ret    

00800ae6 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800ae6:	55                   	push   %ebp
  800ae7:	89 e5                	mov    %esp,%ebp
  800ae9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800aef:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800af6:	00 00 00 
	b.cnt = 0;
  800af9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b00:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b03:	ff 75 0c             	pushl  0xc(%ebp)
  800b06:	ff 75 08             	pushl  0x8(%ebp)
  800b09:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b0f:	50                   	push   %eax
  800b10:	68 7d 0a 80 00       	push   $0x800a7d
  800b15:	e8 11 02 00 00       	call   800d2b <vprintfmt>
  800b1a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800b1d:	a0 24 50 80 00       	mov    0x805024,%al
  800b22:	0f b6 c0             	movzbl %al,%eax
  800b25:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b2b:	83 ec 04             	sub    $0x4,%esp
  800b2e:	50                   	push   %eax
  800b2f:	52                   	push   %edx
  800b30:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b36:	83 c0 08             	add    $0x8,%eax
  800b39:	50                   	push   %eax
  800b3a:	e8 f3 14 00 00       	call   802032 <sys_cputs>
  800b3f:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800b42:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800b49:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800b4f:	c9                   	leave  
  800b50:	c3                   	ret    

00800b51 <cprintf>:

int cprintf(const char *fmt, ...) {
  800b51:	55                   	push   %ebp
  800b52:	89 e5                	mov    %esp,%ebp
  800b54:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800b57:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800b5e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b61:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b64:	8b 45 08             	mov    0x8(%ebp),%eax
  800b67:	83 ec 08             	sub    $0x8,%esp
  800b6a:	ff 75 f4             	pushl  -0xc(%ebp)
  800b6d:	50                   	push   %eax
  800b6e:	e8 73 ff ff ff       	call   800ae6 <vcprintf>
  800b73:	83 c4 10             	add    $0x10,%esp
  800b76:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800b79:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b7c:	c9                   	leave  
  800b7d:	c3                   	ret    

00800b7e <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800b7e:	55                   	push   %ebp
  800b7f:	89 e5                	mov    %esp,%ebp
  800b81:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800b84:	e8 57 16 00 00       	call   8021e0 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800b89:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b92:	83 ec 08             	sub    $0x8,%esp
  800b95:	ff 75 f4             	pushl  -0xc(%ebp)
  800b98:	50                   	push   %eax
  800b99:	e8 48 ff ff ff       	call   800ae6 <vcprintf>
  800b9e:	83 c4 10             	add    $0x10,%esp
  800ba1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800ba4:	e8 51 16 00 00       	call   8021fa <sys_enable_interrupt>
	return cnt;
  800ba9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bac:	c9                   	leave  
  800bad:	c3                   	ret    

00800bae <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800bae:	55                   	push   %ebp
  800baf:	89 e5                	mov    %esp,%ebp
  800bb1:	53                   	push   %ebx
  800bb2:	83 ec 14             	sub    $0x14,%esp
  800bb5:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bbb:	8b 45 14             	mov    0x14(%ebp),%eax
  800bbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800bc1:	8b 45 18             	mov    0x18(%ebp),%eax
  800bc4:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800bcc:	77 55                	ja     800c23 <printnum+0x75>
  800bce:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800bd1:	72 05                	jb     800bd8 <printnum+0x2a>
  800bd3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800bd6:	77 4b                	ja     800c23 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800bd8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800bdb:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800bde:	8b 45 18             	mov    0x18(%ebp),%eax
  800be1:	ba 00 00 00 00       	mov    $0x0,%edx
  800be6:	52                   	push   %edx
  800be7:	50                   	push   %eax
  800be8:	ff 75 f4             	pushl  -0xc(%ebp)
  800beb:	ff 75 f0             	pushl  -0x10(%ebp)
  800bee:	e8 4d 2c 00 00       	call   803840 <__udivdi3>
  800bf3:	83 c4 10             	add    $0x10,%esp
  800bf6:	83 ec 04             	sub    $0x4,%esp
  800bf9:	ff 75 20             	pushl  0x20(%ebp)
  800bfc:	53                   	push   %ebx
  800bfd:	ff 75 18             	pushl  0x18(%ebp)
  800c00:	52                   	push   %edx
  800c01:	50                   	push   %eax
  800c02:	ff 75 0c             	pushl  0xc(%ebp)
  800c05:	ff 75 08             	pushl  0x8(%ebp)
  800c08:	e8 a1 ff ff ff       	call   800bae <printnum>
  800c0d:	83 c4 20             	add    $0x20,%esp
  800c10:	eb 1a                	jmp    800c2c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c12:	83 ec 08             	sub    $0x8,%esp
  800c15:	ff 75 0c             	pushl  0xc(%ebp)
  800c18:	ff 75 20             	pushl  0x20(%ebp)
  800c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1e:	ff d0                	call   *%eax
  800c20:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c23:	ff 4d 1c             	decl   0x1c(%ebp)
  800c26:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c2a:	7f e6                	jg     800c12 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c2c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c2f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c3a:	53                   	push   %ebx
  800c3b:	51                   	push   %ecx
  800c3c:	52                   	push   %edx
  800c3d:	50                   	push   %eax
  800c3e:	e8 0d 2d 00 00       	call   803950 <__umoddi3>
  800c43:	83 c4 10             	add    $0x10,%esp
  800c46:	05 14 41 80 00       	add    $0x804114,%eax
  800c4b:	8a 00                	mov    (%eax),%al
  800c4d:	0f be c0             	movsbl %al,%eax
  800c50:	83 ec 08             	sub    $0x8,%esp
  800c53:	ff 75 0c             	pushl  0xc(%ebp)
  800c56:	50                   	push   %eax
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	ff d0                	call   *%eax
  800c5c:	83 c4 10             	add    $0x10,%esp
}
  800c5f:	90                   	nop
  800c60:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c63:	c9                   	leave  
  800c64:	c3                   	ret    

00800c65 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c65:	55                   	push   %ebp
  800c66:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c68:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c6c:	7e 1c                	jle    800c8a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c71:	8b 00                	mov    (%eax),%eax
  800c73:	8d 50 08             	lea    0x8(%eax),%edx
  800c76:	8b 45 08             	mov    0x8(%ebp),%eax
  800c79:	89 10                	mov    %edx,(%eax)
  800c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7e:	8b 00                	mov    (%eax),%eax
  800c80:	83 e8 08             	sub    $0x8,%eax
  800c83:	8b 50 04             	mov    0x4(%eax),%edx
  800c86:	8b 00                	mov    (%eax),%eax
  800c88:	eb 40                	jmp    800cca <getuint+0x65>
	else if (lflag)
  800c8a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c8e:	74 1e                	je     800cae <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800c90:	8b 45 08             	mov    0x8(%ebp),%eax
  800c93:	8b 00                	mov    (%eax),%eax
  800c95:	8d 50 04             	lea    0x4(%eax),%edx
  800c98:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9b:	89 10                	mov    %edx,(%eax)
  800c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca0:	8b 00                	mov    (%eax),%eax
  800ca2:	83 e8 04             	sub    $0x4,%eax
  800ca5:	8b 00                	mov    (%eax),%eax
  800ca7:	ba 00 00 00 00       	mov    $0x0,%edx
  800cac:	eb 1c                	jmp    800cca <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800cae:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb1:	8b 00                	mov    (%eax),%eax
  800cb3:	8d 50 04             	lea    0x4(%eax),%edx
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	89 10                	mov    %edx,(%eax)
  800cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbe:	8b 00                	mov    (%eax),%eax
  800cc0:	83 e8 04             	sub    $0x4,%eax
  800cc3:	8b 00                	mov    (%eax),%eax
  800cc5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800cca:	5d                   	pop    %ebp
  800ccb:	c3                   	ret    

00800ccc <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ccc:	55                   	push   %ebp
  800ccd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ccf:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800cd3:	7e 1c                	jle    800cf1 <getint+0x25>
		return va_arg(*ap, long long);
  800cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd8:	8b 00                	mov    (%eax),%eax
  800cda:	8d 50 08             	lea    0x8(%eax),%edx
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	89 10                	mov    %edx,(%eax)
  800ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce5:	8b 00                	mov    (%eax),%eax
  800ce7:	83 e8 08             	sub    $0x8,%eax
  800cea:	8b 50 04             	mov    0x4(%eax),%edx
  800ced:	8b 00                	mov    (%eax),%eax
  800cef:	eb 38                	jmp    800d29 <getint+0x5d>
	else if (lflag)
  800cf1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cf5:	74 1a                	je     800d11 <getint+0x45>
		return va_arg(*ap, long);
  800cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfa:	8b 00                	mov    (%eax),%eax
  800cfc:	8d 50 04             	lea    0x4(%eax),%edx
  800cff:	8b 45 08             	mov    0x8(%ebp),%eax
  800d02:	89 10                	mov    %edx,(%eax)
  800d04:	8b 45 08             	mov    0x8(%ebp),%eax
  800d07:	8b 00                	mov    (%eax),%eax
  800d09:	83 e8 04             	sub    $0x4,%eax
  800d0c:	8b 00                	mov    (%eax),%eax
  800d0e:	99                   	cltd   
  800d0f:	eb 18                	jmp    800d29 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d11:	8b 45 08             	mov    0x8(%ebp),%eax
  800d14:	8b 00                	mov    (%eax),%eax
  800d16:	8d 50 04             	lea    0x4(%eax),%edx
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	89 10                	mov    %edx,(%eax)
  800d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d21:	8b 00                	mov    (%eax),%eax
  800d23:	83 e8 04             	sub    $0x4,%eax
  800d26:	8b 00                	mov    (%eax),%eax
  800d28:	99                   	cltd   
}
  800d29:	5d                   	pop    %ebp
  800d2a:	c3                   	ret    

00800d2b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d2b:	55                   	push   %ebp
  800d2c:	89 e5                	mov    %esp,%ebp
  800d2e:	56                   	push   %esi
  800d2f:	53                   	push   %ebx
  800d30:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d33:	eb 17                	jmp    800d4c <vprintfmt+0x21>
			if (ch == '\0')
  800d35:	85 db                	test   %ebx,%ebx
  800d37:	0f 84 af 03 00 00    	je     8010ec <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800d3d:	83 ec 08             	sub    $0x8,%esp
  800d40:	ff 75 0c             	pushl  0xc(%ebp)
  800d43:	53                   	push   %ebx
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	ff d0                	call   *%eax
  800d49:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d4c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d4f:	8d 50 01             	lea    0x1(%eax),%edx
  800d52:	89 55 10             	mov    %edx,0x10(%ebp)
  800d55:	8a 00                	mov    (%eax),%al
  800d57:	0f b6 d8             	movzbl %al,%ebx
  800d5a:	83 fb 25             	cmp    $0x25,%ebx
  800d5d:	75 d6                	jne    800d35 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800d5f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800d63:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800d6a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800d71:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800d78:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d7f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d82:	8d 50 01             	lea    0x1(%eax),%edx
  800d85:	89 55 10             	mov    %edx,0x10(%ebp)
  800d88:	8a 00                	mov    (%eax),%al
  800d8a:	0f b6 d8             	movzbl %al,%ebx
  800d8d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800d90:	83 f8 55             	cmp    $0x55,%eax
  800d93:	0f 87 2b 03 00 00    	ja     8010c4 <vprintfmt+0x399>
  800d99:	8b 04 85 38 41 80 00 	mov    0x804138(,%eax,4),%eax
  800da0:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800da2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800da6:	eb d7                	jmp    800d7f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800da8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800dac:	eb d1                	jmp    800d7f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800dae:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800db5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800db8:	89 d0                	mov    %edx,%eax
  800dba:	c1 e0 02             	shl    $0x2,%eax
  800dbd:	01 d0                	add    %edx,%eax
  800dbf:	01 c0                	add    %eax,%eax
  800dc1:	01 d8                	add    %ebx,%eax
  800dc3:	83 e8 30             	sub    $0x30,%eax
  800dc6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800dc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800dcc:	8a 00                	mov    (%eax),%al
  800dce:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800dd1:	83 fb 2f             	cmp    $0x2f,%ebx
  800dd4:	7e 3e                	jle    800e14 <vprintfmt+0xe9>
  800dd6:	83 fb 39             	cmp    $0x39,%ebx
  800dd9:	7f 39                	jg     800e14 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ddb:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800dde:	eb d5                	jmp    800db5 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800de0:	8b 45 14             	mov    0x14(%ebp),%eax
  800de3:	83 c0 04             	add    $0x4,%eax
  800de6:	89 45 14             	mov    %eax,0x14(%ebp)
  800de9:	8b 45 14             	mov    0x14(%ebp),%eax
  800dec:	83 e8 04             	sub    $0x4,%eax
  800def:	8b 00                	mov    (%eax),%eax
  800df1:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800df4:	eb 1f                	jmp    800e15 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800df6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dfa:	79 83                	jns    800d7f <vprintfmt+0x54>
				width = 0;
  800dfc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e03:	e9 77 ff ff ff       	jmp    800d7f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e08:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e0f:	e9 6b ff ff ff       	jmp    800d7f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e14:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e15:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e19:	0f 89 60 ff ff ff    	jns    800d7f <vprintfmt+0x54>
				width = precision, precision = -1;
  800e1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e22:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e25:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e2c:	e9 4e ff ff ff       	jmp    800d7f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e31:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e34:	e9 46 ff ff ff       	jmp    800d7f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e39:	8b 45 14             	mov    0x14(%ebp),%eax
  800e3c:	83 c0 04             	add    $0x4,%eax
  800e3f:	89 45 14             	mov    %eax,0x14(%ebp)
  800e42:	8b 45 14             	mov    0x14(%ebp),%eax
  800e45:	83 e8 04             	sub    $0x4,%eax
  800e48:	8b 00                	mov    (%eax),%eax
  800e4a:	83 ec 08             	sub    $0x8,%esp
  800e4d:	ff 75 0c             	pushl  0xc(%ebp)
  800e50:	50                   	push   %eax
  800e51:	8b 45 08             	mov    0x8(%ebp),%eax
  800e54:	ff d0                	call   *%eax
  800e56:	83 c4 10             	add    $0x10,%esp
			break;
  800e59:	e9 89 02 00 00       	jmp    8010e7 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800e5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800e61:	83 c0 04             	add    $0x4,%eax
  800e64:	89 45 14             	mov    %eax,0x14(%ebp)
  800e67:	8b 45 14             	mov    0x14(%ebp),%eax
  800e6a:	83 e8 04             	sub    $0x4,%eax
  800e6d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800e6f:	85 db                	test   %ebx,%ebx
  800e71:	79 02                	jns    800e75 <vprintfmt+0x14a>
				err = -err;
  800e73:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800e75:	83 fb 64             	cmp    $0x64,%ebx
  800e78:	7f 0b                	jg     800e85 <vprintfmt+0x15a>
  800e7a:	8b 34 9d 80 3f 80 00 	mov    0x803f80(,%ebx,4),%esi
  800e81:	85 f6                	test   %esi,%esi
  800e83:	75 19                	jne    800e9e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e85:	53                   	push   %ebx
  800e86:	68 25 41 80 00       	push   $0x804125
  800e8b:	ff 75 0c             	pushl  0xc(%ebp)
  800e8e:	ff 75 08             	pushl  0x8(%ebp)
  800e91:	e8 5e 02 00 00       	call   8010f4 <printfmt>
  800e96:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e99:	e9 49 02 00 00       	jmp    8010e7 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e9e:	56                   	push   %esi
  800e9f:	68 2e 41 80 00       	push   $0x80412e
  800ea4:	ff 75 0c             	pushl  0xc(%ebp)
  800ea7:	ff 75 08             	pushl  0x8(%ebp)
  800eaa:	e8 45 02 00 00       	call   8010f4 <printfmt>
  800eaf:	83 c4 10             	add    $0x10,%esp
			break;
  800eb2:	e9 30 02 00 00       	jmp    8010e7 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800eb7:	8b 45 14             	mov    0x14(%ebp),%eax
  800eba:	83 c0 04             	add    $0x4,%eax
  800ebd:	89 45 14             	mov    %eax,0x14(%ebp)
  800ec0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec3:	83 e8 04             	sub    $0x4,%eax
  800ec6:	8b 30                	mov    (%eax),%esi
  800ec8:	85 f6                	test   %esi,%esi
  800eca:	75 05                	jne    800ed1 <vprintfmt+0x1a6>
				p = "(null)";
  800ecc:	be 31 41 80 00       	mov    $0x804131,%esi
			if (width > 0 && padc != '-')
  800ed1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ed5:	7e 6d                	jle    800f44 <vprintfmt+0x219>
  800ed7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800edb:	74 67                	je     800f44 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800edd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ee0:	83 ec 08             	sub    $0x8,%esp
  800ee3:	50                   	push   %eax
  800ee4:	56                   	push   %esi
  800ee5:	e8 12 05 00 00       	call   8013fc <strnlen>
  800eea:	83 c4 10             	add    $0x10,%esp
  800eed:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ef0:	eb 16                	jmp    800f08 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ef2:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ef6:	83 ec 08             	sub    $0x8,%esp
  800ef9:	ff 75 0c             	pushl  0xc(%ebp)
  800efc:	50                   	push   %eax
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
  800f00:	ff d0                	call   *%eax
  800f02:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f05:	ff 4d e4             	decl   -0x1c(%ebp)
  800f08:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f0c:	7f e4                	jg     800ef2 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f0e:	eb 34                	jmp    800f44 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f10:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f14:	74 1c                	je     800f32 <vprintfmt+0x207>
  800f16:	83 fb 1f             	cmp    $0x1f,%ebx
  800f19:	7e 05                	jle    800f20 <vprintfmt+0x1f5>
  800f1b:	83 fb 7e             	cmp    $0x7e,%ebx
  800f1e:	7e 12                	jle    800f32 <vprintfmt+0x207>
					putch('?', putdat);
  800f20:	83 ec 08             	sub    $0x8,%esp
  800f23:	ff 75 0c             	pushl  0xc(%ebp)
  800f26:	6a 3f                	push   $0x3f
  800f28:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2b:	ff d0                	call   *%eax
  800f2d:	83 c4 10             	add    $0x10,%esp
  800f30:	eb 0f                	jmp    800f41 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f32:	83 ec 08             	sub    $0x8,%esp
  800f35:	ff 75 0c             	pushl  0xc(%ebp)
  800f38:	53                   	push   %ebx
  800f39:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3c:	ff d0                	call   *%eax
  800f3e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f41:	ff 4d e4             	decl   -0x1c(%ebp)
  800f44:	89 f0                	mov    %esi,%eax
  800f46:	8d 70 01             	lea    0x1(%eax),%esi
  800f49:	8a 00                	mov    (%eax),%al
  800f4b:	0f be d8             	movsbl %al,%ebx
  800f4e:	85 db                	test   %ebx,%ebx
  800f50:	74 24                	je     800f76 <vprintfmt+0x24b>
  800f52:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f56:	78 b8                	js     800f10 <vprintfmt+0x1e5>
  800f58:	ff 4d e0             	decl   -0x20(%ebp)
  800f5b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f5f:	79 af                	jns    800f10 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f61:	eb 13                	jmp    800f76 <vprintfmt+0x24b>
				putch(' ', putdat);
  800f63:	83 ec 08             	sub    $0x8,%esp
  800f66:	ff 75 0c             	pushl  0xc(%ebp)
  800f69:	6a 20                	push   $0x20
  800f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6e:	ff d0                	call   *%eax
  800f70:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f73:	ff 4d e4             	decl   -0x1c(%ebp)
  800f76:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f7a:	7f e7                	jg     800f63 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800f7c:	e9 66 01 00 00       	jmp    8010e7 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800f81:	83 ec 08             	sub    $0x8,%esp
  800f84:	ff 75 e8             	pushl  -0x18(%ebp)
  800f87:	8d 45 14             	lea    0x14(%ebp),%eax
  800f8a:	50                   	push   %eax
  800f8b:	e8 3c fd ff ff       	call   800ccc <getint>
  800f90:	83 c4 10             	add    $0x10,%esp
  800f93:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f96:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800f99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f9f:	85 d2                	test   %edx,%edx
  800fa1:	79 23                	jns    800fc6 <vprintfmt+0x29b>
				putch('-', putdat);
  800fa3:	83 ec 08             	sub    $0x8,%esp
  800fa6:	ff 75 0c             	pushl  0xc(%ebp)
  800fa9:	6a 2d                	push   $0x2d
  800fab:	8b 45 08             	mov    0x8(%ebp),%eax
  800fae:	ff d0                	call   *%eax
  800fb0:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800fb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fb6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fb9:	f7 d8                	neg    %eax
  800fbb:	83 d2 00             	adc    $0x0,%edx
  800fbe:	f7 da                	neg    %edx
  800fc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fc3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800fc6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800fcd:	e9 bc 00 00 00       	jmp    80108e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800fd2:	83 ec 08             	sub    $0x8,%esp
  800fd5:	ff 75 e8             	pushl  -0x18(%ebp)
  800fd8:	8d 45 14             	lea    0x14(%ebp),%eax
  800fdb:	50                   	push   %eax
  800fdc:	e8 84 fc ff ff       	call   800c65 <getuint>
  800fe1:	83 c4 10             	add    $0x10,%esp
  800fe4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fe7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800fea:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ff1:	e9 98 00 00 00       	jmp    80108e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ff6:	83 ec 08             	sub    $0x8,%esp
  800ff9:	ff 75 0c             	pushl  0xc(%ebp)
  800ffc:	6a 58                	push   $0x58
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	ff d0                	call   *%eax
  801003:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801006:	83 ec 08             	sub    $0x8,%esp
  801009:	ff 75 0c             	pushl  0xc(%ebp)
  80100c:	6a 58                	push   $0x58
  80100e:	8b 45 08             	mov    0x8(%ebp),%eax
  801011:	ff d0                	call   *%eax
  801013:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801016:	83 ec 08             	sub    $0x8,%esp
  801019:	ff 75 0c             	pushl  0xc(%ebp)
  80101c:	6a 58                	push   $0x58
  80101e:	8b 45 08             	mov    0x8(%ebp),%eax
  801021:	ff d0                	call   *%eax
  801023:	83 c4 10             	add    $0x10,%esp
			break;
  801026:	e9 bc 00 00 00       	jmp    8010e7 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80102b:	83 ec 08             	sub    $0x8,%esp
  80102e:	ff 75 0c             	pushl  0xc(%ebp)
  801031:	6a 30                	push   $0x30
  801033:	8b 45 08             	mov    0x8(%ebp),%eax
  801036:	ff d0                	call   *%eax
  801038:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80103b:	83 ec 08             	sub    $0x8,%esp
  80103e:	ff 75 0c             	pushl  0xc(%ebp)
  801041:	6a 78                	push   $0x78
  801043:	8b 45 08             	mov    0x8(%ebp),%eax
  801046:	ff d0                	call   *%eax
  801048:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80104b:	8b 45 14             	mov    0x14(%ebp),%eax
  80104e:	83 c0 04             	add    $0x4,%eax
  801051:	89 45 14             	mov    %eax,0x14(%ebp)
  801054:	8b 45 14             	mov    0x14(%ebp),%eax
  801057:	83 e8 04             	sub    $0x4,%eax
  80105a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80105c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80105f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801066:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80106d:	eb 1f                	jmp    80108e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80106f:	83 ec 08             	sub    $0x8,%esp
  801072:	ff 75 e8             	pushl  -0x18(%ebp)
  801075:	8d 45 14             	lea    0x14(%ebp),%eax
  801078:	50                   	push   %eax
  801079:	e8 e7 fb ff ff       	call   800c65 <getuint>
  80107e:	83 c4 10             	add    $0x10,%esp
  801081:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801084:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801087:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80108e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801092:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801095:	83 ec 04             	sub    $0x4,%esp
  801098:	52                   	push   %edx
  801099:	ff 75 e4             	pushl  -0x1c(%ebp)
  80109c:	50                   	push   %eax
  80109d:	ff 75 f4             	pushl  -0xc(%ebp)
  8010a0:	ff 75 f0             	pushl  -0x10(%ebp)
  8010a3:	ff 75 0c             	pushl  0xc(%ebp)
  8010a6:	ff 75 08             	pushl  0x8(%ebp)
  8010a9:	e8 00 fb ff ff       	call   800bae <printnum>
  8010ae:	83 c4 20             	add    $0x20,%esp
			break;
  8010b1:	eb 34                	jmp    8010e7 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8010b3:	83 ec 08             	sub    $0x8,%esp
  8010b6:	ff 75 0c             	pushl  0xc(%ebp)
  8010b9:	53                   	push   %ebx
  8010ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bd:	ff d0                	call   *%eax
  8010bf:	83 c4 10             	add    $0x10,%esp
			break;
  8010c2:	eb 23                	jmp    8010e7 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8010c4:	83 ec 08             	sub    $0x8,%esp
  8010c7:	ff 75 0c             	pushl  0xc(%ebp)
  8010ca:	6a 25                	push   $0x25
  8010cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cf:	ff d0                	call   *%eax
  8010d1:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010d4:	ff 4d 10             	decl   0x10(%ebp)
  8010d7:	eb 03                	jmp    8010dc <vprintfmt+0x3b1>
  8010d9:	ff 4d 10             	decl   0x10(%ebp)
  8010dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8010df:	48                   	dec    %eax
  8010e0:	8a 00                	mov    (%eax),%al
  8010e2:	3c 25                	cmp    $0x25,%al
  8010e4:	75 f3                	jne    8010d9 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8010e6:	90                   	nop
		}
	}
  8010e7:	e9 47 fc ff ff       	jmp    800d33 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8010ec:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8010ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010f0:	5b                   	pop    %ebx
  8010f1:	5e                   	pop    %esi
  8010f2:	5d                   	pop    %ebp
  8010f3:	c3                   	ret    

008010f4 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8010f4:	55                   	push   %ebp
  8010f5:	89 e5                	mov    %esp,%ebp
  8010f7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8010fa:	8d 45 10             	lea    0x10(%ebp),%eax
  8010fd:	83 c0 04             	add    $0x4,%eax
  801100:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801103:	8b 45 10             	mov    0x10(%ebp),%eax
  801106:	ff 75 f4             	pushl  -0xc(%ebp)
  801109:	50                   	push   %eax
  80110a:	ff 75 0c             	pushl  0xc(%ebp)
  80110d:	ff 75 08             	pushl  0x8(%ebp)
  801110:	e8 16 fc ff ff       	call   800d2b <vprintfmt>
  801115:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801118:	90                   	nop
  801119:	c9                   	leave  
  80111a:	c3                   	ret    

0080111b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80111b:	55                   	push   %ebp
  80111c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80111e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801121:	8b 40 08             	mov    0x8(%eax),%eax
  801124:	8d 50 01             	lea    0x1(%eax),%edx
  801127:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112a:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80112d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801130:	8b 10                	mov    (%eax),%edx
  801132:	8b 45 0c             	mov    0xc(%ebp),%eax
  801135:	8b 40 04             	mov    0x4(%eax),%eax
  801138:	39 c2                	cmp    %eax,%edx
  80113a:	73 12                	jae    80114e <sprintputch+0x33>
		*b->buf++ = ch;
  80113c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113f:	8b 00                	mov    (%eax),%eax
  801141:	8d 48 01             	lea    0x1(%eax),%ecx
  801144:	8b 55 0c             	mov    0xc(%ebp),%edx
  801147:	89 0a                	mov    %ecx,(%edx)
  801149:	8b 55 08             	mov    0x8(%ebp),%edx
  80114c:	88 10                	mov    %dl,(%eax)
}
  80114e:	90                   	nop
  80114f:	5d                   	pop    %ebp
  801150:	c3                   	ret    

00801151 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801151:	55                   	push   %ebp
  801152:	89 e5                	mov    %esp,%ebp
  801154:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801157:	8b 45 08             	mov    0x8(%ebp),%eax
  80115a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80115d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801160:	8d 50 ff             	lea    -0x1(%eax),%edx
  801163:	8b 45 08             	mov    0x8(%ebp),%eax
  801166:	01 d0                	add    %edx,%eax
  801168:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80116b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801172:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801176:	74 06                	je     80117e <vsnprintf+0x2d>
  801178:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80117c:	7f 07                	jg     801185 <vsnprintf+0x34>
		return -E_INVAL;
  80117e:	b8 03 00 00 00       	mov    $0x3,%eax
  801183:	eb 20                	jmp    8011a5 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801185:	ff 75 14             	pushl  0x14(%ebp)
  801188:	ff 75 10             	pushl  0x10(%ebp)
  80118b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80118e:	50                   	push   %eax
  80118f:	68 1b 11 80 00       	push   $0x80111b
  801194:	e8 92 fb ff ff       	call   800d2b <vprintfmt>
  801199:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80119c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80119f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8011a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8011a5:	c9                   	leave  
  8011a6:	c3                   	ret    

008011a7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011a7:	55                   	push   %ebp
  8011a8:	89 e5                	mov    %esp,%ebp
  8011aa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8011ad:	8d 45 10             	lea    0x10(%ebp),%eax
  8011b0:	83 c0 04             	add    $0x4,%eax
  8011b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8011b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8011bc:	50                   	push   %eax
  8011bd:	ff 75 0c             	pushl  0xc(%ebp)
  8011c0:	ff 75 08             	pushl  0x8(%ebp)
  8011c3:	e8 89 ff ff ff       	call   801151 <vsnprintf>
  8011c8:	83 c4 10             	add    $0x10,%esp
  8011cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8011ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8011d1:	c9                   	leave  
  8011d2:	c3                   	ret    

008011d3 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8011d3:	55                   	push   %ebp
  8011d4:	89 e5                	mov    %esp,%ebp
  8011d6:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  8011d9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011dd:	74 13                	je     8011f2 <readline+0x1f>
		cprintf("%s", prompt);
  8011df:	83 ec 08             	sub    $0x8,%esp
  8011e2:	ff 75 08             	pushl  0x8(%ebp)
  8011e5:	68 90 42 80 00       	push   $0x804290
  8011ea:	e8 62 f9 ff ff       	call   800b51 <cprintf>
  8011ef:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8011f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8011f9:	83 ec 0c             	sub    $0xc,%esp
  8011fc:	6a 00                	push   $0x0
  8011fe:	e8 54 f5 ff ff       	call   800757 <iscons>
  801203:	83 c4 10             	add    $0x10,%esp
  801206:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801209:	e8 fb f4 ff ff       	call   800709 <getchar>
  80120e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801211:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801215:	79 22                	jns    801239 <readline+0x66>
			if (c != -E_EOF)
  801217:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80121b:	0f 84 ad 00 00 00    	je     8012ce <readline+0xfb>
				cprintf("read error: %e\n", c);
  801221:	83 ec 08             	sub    $0x8,%esp
  801224:	ff 75 ec             	pushl  -0x14(%ebp)
  801227:	68 93 42 80 00       	push   $0x804293
  80122c:	e8 20 f9 ff ff       	call   800b51 <cprintf>
  801231:	83 c4 10             	add    $0x10,%esp
			return;
  801234:	e9 95 00 00 00       	jmp    8012ce <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801239:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80123d:	7e 34                	jle    801273 <readline+0xa0>
  80123f:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801246:	7f 2b                	jg     801273 <readline+0xa0>
			if (echoing)
  801248:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80124c:	74 0e                	je     80125c <readline+0x89>
				cputchar(c);
  80124e:	83 ec 0c             	sub    $0xc,%esp
  801251:	ff 75 ec             	pushl  -0x14(%ebp)
  801254:	e8 68 f4 ff ff       	call   8006c1 <cputchar>
  801259:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80125c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80125f:	8d 50 01             	lea    0x1(%eax),%edx
  801262:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801265:	89 c2                	mov    %eax,%edx
  801267:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126a:	01 d0                	add    %edx,%eax
  80126c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80126f:	88 10                	mov    %dl,(%eax)
  801271:	eb 56                	jmp    8012c9 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801273:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801277:	75 1f                	jne    801298 <readline+0xc5>
  801279:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80127d:	7e 19                	jle    801298 <readline+0xc5>
			if (echoing)
  80127f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801283:	74 0e                	je     801293 <readline+0xc0>
				cputchar(c);
  801285:	83 ec 0c             	sub    $0xc,%esp
  801288:	ff 75 ec             	pushl  -0x14(%ebp)
  80128b:	e8 31 f4 ff ff       	call   8006c1 <cputchar>
  801290:	83 c4 10             	add    $0x10,%esp

			i--;
  801293:	ff 4d f4             	decl   -0xc(%ebp)
  801296:	eb 31                	jmp    8012c9 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801298:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80129c:	74 0a                	je     8012a8 <readline+0xd5>
  80129e:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8012a2:	0f 85 61 ff ff ff    	jne    801209 <readline+0x36>
			if (echoing)
  8012a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012ac:	74 0e                	je     8012bc <readline+0xe9>
				cputchar(c);
  8012ae:	83 ec 0c             	sub    $0xc,%esp
  8012b1:	ff 75 ec             	pushl  -0x14(%ebp)
  8012b4:	e8 08 f4 ff ff       	call   8006c1 <cputchar>
  8012b9:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8012bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c2:	01 d0                	add    %edx,%eax
  8012c4:	c6 00 00             	movb   $0x0,(%eax)
			return;
  8012c7:	eb 06                	jmp    8012cf <readline+0xfc>
		}
	}
  8012c9:	e9 3b ff ff ff       	jmp    801209 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  8012ce:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  8012cf:	c9                   	leave  
  8012d0:	c3                   	ret    

008012d1 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8012d1:	55                   	push   %ebp
  8012d2:	89 e5                	mov    %esp,%ebp
  8012d4:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8012d7:	e8 04 0f 00 00       	call   8021e0 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  8012dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012e0:	74 13                	je     8012f5 <atomic_readline+0x24>
		cprintf("%s", prompt);
  8012e2:	83 ec 08             	sub    $0x8,%esp
  8012e5:	ff 75 08             	pushl  0x8(%ebp)
  8012e8:	68 90 42 80 00       	push   $0x804290
  8012ed:	e8 5f f8 ff ff       	call   800b51 <cprintf>
  8012f2:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8012f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8012fc:	83 ec 0c             	sub    $0xc,%esp
  8012ff:	6a 00                	push   $0x0
  801301:	e8 51 f4 ff ff       	call   800757 <iscons>
  801306:	83 c4 10             	add    $0x10,%esp
  801309:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  80130c:	e8 f8 f3 ff ff       	call   800709 <getchar>
  801311:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801314:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801318:	79 23                	jns    80133d <atomic_readline+0x6c>
			if (c != -E_EOF)
  80131a:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80131e:	74 13                	je     801333 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  801320:	83 ec 08             	sub    $0x8,%esp
  801323:	ff 75 ec             	pushl  -0x14(%ebp)
  801326:	68 93 42 80 00       	push   $0x804293
  80132b:	e8 21 f8 ff ff       	call   800b51 <cprintf>
  801330:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801333:	e8 c2 0e 00 00       	call   8021fa <sys_enable_interrupt>
			return;
  801338:	e9 9a 00 00 00       	jmp    8013d7 <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80133d:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801341:	7e 34                	jle    801377 <atomic_readline+0xa6>
  801343:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80134a:	7f 2b                	jg     801377 <atomic_readline+0xa6>
			if (echoing)
  80134c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801350:	74 0e                	je     801360 <atomic_readline+0x8f>
				cputchar(c);
  801352:	83 ec 0c             	sub    $0xc,%esp
  801355:	ff 75 ec             	pushl  -0x14(%ebp)
  801358:	e8 64 f3 ff ff       	call   8006c1 <cputchar>
  80135d:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801360:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801363:	8d 50 01             	lea    0x1(%eax),%edx
  801366:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801369:	89 c2                	mov    %eax,%edx
  80136b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136e:	01 d0                	add    %edx,%eax
  801370:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801373:	88 10                	mov    %dl,(%eax)
  801375:	eb 5b                	jmp    8013d2 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  801377:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80137b:	75 1f                	jne    80139c <atomic_readline+0xcb>
  80137d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801381:	7e 19                	jle    80139c <atomic_readline+0xcb>
			if (echoing)
  801383:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801387:	74 0e                	je     801397 <atomic_readline+0xc6>
				cputchar(c);
  801389:	83 ec 0c             	sub    $0xc,%esp
  80138c:	ff 75 ec             	pushl  -0x14(%ebp)
  80138f:	e8 2d f3 ff ff       	call   8006c1 <cputchar>
  801394:	83 c4 10             	add    $0x10,%esp
			i--;
  801397:	ff 4d f4             	decl   -0xc(%ebp)
  80139a:	eb 36                	jmp    8013d2 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  80139c:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8013a0:	74 0a                	je     8013ac <atomic_readline+0xdb>
  8013a2:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8013a6:	0f 85 60 ff ff ff    	jne    80130c <atomic_readline+0x3b>
			if (echoing)
  8013ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013b0:	74 0e                	je     8013c0 <atomic_readline+0xef>
				cputchar(c);
  8013b2:	83 ec 0c             	sub    $0xc,%esp
  8013b5:	ff 75 ec             	pushl  -0x14(%ebp)
  8013b8:	e8 04 f3 ff ff       	call   8006c1 <cputchar>
  8013bd:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  8013c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c6:	01 d0                	add    %edx,%eax
  8013c8:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  8013cb:	e8 2a 0e 00 00       	call   8021fa <sys_enable_interrupt>
			return;
  8013d0:	eb 05                	jmp    8013d7 <atomic_readline+0x106>
		}
	}
  8013d2:	e9 35 ff ff ff       	jmp    80130c <atomic_readline+0x3b>
}
  8013d7:	c9                   	leave  
  8013d8:	c3                   	ret    

008013d9 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8013d9:	55                   	push   %ebp
  8013da:	89 e5                	mov    %esp,%ebp
  8013dc:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8013df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013e6:	eb 06                	jmp    8013ee <strlen+0x15>
		n++;
  8013e8:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8013eb:	ff 45 08             	incl   0x8(%ebp)
  8013ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f1:	8a 00                	mov    (%eax),%al
  8013f3:	84 c0                	test   %al,%al
  8013f5:	75 f1                	jne    8013e8 <strlen+0xf>
		n++;
	return n;
  8013f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013fa:	c9                   	leave  
  8013fb:	c3                   	ret    

008013fc <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8013fc:	55                   	push   %ebp
  8013fd:	89 e5                	mov    %esp,%ebp
  8013ff:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801402:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801409:	eb 09                	jmp    801414 <strnlen+0x18>
		n++;
  80140b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80140e:	ff 45 08             	incl   0x8(%ebp)
  801411:	ff 4d 0c             	decl   0xc(%ebp)
  801414:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801418:	74 09                	je     801423 <strnlen+0x27>
  80141a:	8b 45 08             	mov    0x8(%ebp),%eax
  80141d:	8a 00                	mov    (%eax),%al
  80141f:	84 c0                	test   %al,%al
  801421:	75 e8                	jne    80140b <strnlen+0xf>
		n++;
	return n;
  801423:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801426:	c9                   	leave  
  801427:	c3                   	ret    

00801428 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801428:	55                   	push   %ebp
  801429:	89 e5                	mov    %esp,%ebp
  80142b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80142e:	8b 45 08             	mov    0x8(%ebp),%eax
  801431:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801434:	90                   	nop
  801435:	8b 45 08             	mov    0x8(%ebp),%eax
  801438:	8d 50 01             	lea    0x1(%eax),%edx
  80143b:	89 55 08             	mov    %edx,0x8(%ebp)
  80143e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801441:	8d 4a 01             	lea    0x1(%edx),%ecx
  801444:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801447:	8a 12                	mov    (%edx),%dl
  801449:	88 10                	mov    %dl,(%eax)
  80144b:	8a 00                	mov    (%eax),%al
  80144d:	84 c0                	test   %al,%al
  80144f:	75 e4                	jne    801435 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801451:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801454:	c9                   	leave  
  801455:	c3                   	ret    

00801456 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801456:	55                   	push   %ebp
  801457:	89 e5                	mov    %esp,%ebp
  801459:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80145c:	8b 45 08             	mov    0x8(%ebp),%eax
  80145f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801462:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801469:	eb 1f                	jmp    80148a <strncpy+0x34>
		*dst++ = *src;
  80146b:	8b 45 08             	mov    0x8(%ebp),%eax
  80146e:	8d 50 01             	lea    0x1(%eax),%edx
  801471:	89 55 08             	mov    %edx,0x8(%ebp)
  801474:	8b 55 0c             	mov    0xc(%ebp),%edx
  801477:	8a 12                	mov    (%edx),%dl
  801479:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80147b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147e:	8a 00                	mov    (%eax),%al
  801480:	84 c0                	test   %al,%al
  801482:	74 03                	je     801487 <strncpy+0x31>
			src++;
  801484:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801487:	ff 45 fc             	incl   -0x4(%ebp)
  80148a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80148d:	3b 45 10             	cmp    0x10(%ebp),%eax
  801490:	72 d9                	jb     80146b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801492:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801495:	c9                   	leave  
  801496:	c3                   	ret    

00801497 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801497:	55                   	push   %ebp
  801498:	89 e5                	mov    %esp,%ebp
  80149a:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80149d:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8014a3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014a7:	74 30                	je     8014d9 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8014a9:	eb 16                	jmp    8014c1 <strlcpy+0x2a>
			*dst++ = *src++;
  8014ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ae:	8d 50 01             	lea    0x1(%eax),%edx
  8014b1:	89 55 08             	mov    %edx,0x8(%ebp)
  8014b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014ba:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014bd:	8a 12                	mov    (%edx),%dl
  8014bf:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014c1:	ff 4d 10             	decl   0x10(%ebp)
  8014c4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014c8:	74 09                	je     8014d3 <strlcpy+0x3c>
  8014ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014cd:	8a 00                	mov    (%eax),%al
  8014cf:	84 c0                	test   %al,%al
  8014d1:	75 d8                	jne    8014ab <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8014d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8014d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8014dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014df:	29 c2                	sub    %eax,%edx
  8014e1:	89 d0                	mov    %edx,%eax
}
  8014e3:	c9                   	leave  
  8014e4:	c3                   	ret    

008014e5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8014e5:	55                   	push   %ebp
  8014e6:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8014e8:	eb 06                	jmp    8014f0 <strcmp+0xb>
		p++, q++;
  8014ea:	ff 45 08             	incl   0x8(%ebp)
  8014ed:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8014f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f3:	8a 00                	mov    (%eax),%al
  8014f5:	84 c0                	test   %al,%al
  8014f7:	74 0e                	je     801507 <strcmp+0x22>
  8014f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fc:	8a 10                	mov    (%eax),%dl
  8014fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801501:	8a 00                	mov    (%eax),%al
  801503:	38 c2                	cmp    %al,%dl
  801505:	74 e3                	je     8014ea <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801507:	8b 45 08             	mov    0x8(%ebp),%eax
  80150a:	8a 00                	mov    (%eax),%al
  80150c:	0f b6 d0             	movzbl %al,%edx
  80150f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801512:	8a 00                	mov    (%eax),%al
  801514:	0f b6 c0             	movzbl %al,%eax
  801517:	29 c2                	sub    %eax,%edx
  801519:	89 d0                	mov    %edx,%eax
}
  80151b:	5d                   	pop    %ebp
  80151c:	c3                   	ret    

0080151d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80151d:	55                   	push   %ebp
  80151e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801520:	eb 09                	jmp    80152b <strncmp+0xe>
		n--, p++, q++;
  801522:	ff 4d 10             	decl   0x10(%ebp)
  801525:	ff 45 08             	incl   0x8(%ebp)
  801528:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80152b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80152f:	74 17                	je     801548 <strncmp+0x2b>
  801531:	8b 45 08             	mov    0x8(%ebp),%eax
  801534:	8a 00                	mov    (%eax),%al
  801536:	84 c0                	test   %al,%al
  801538:	74 0e                	je     801548 <strncmp+0x2b>
  80153a:	8b 45 08             	mov    0x8(%ebp),%eax
  80153d:	8a 10                	mov    (%eax),%dl
  80153f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801542:	8a 00                	mov    (%eax),%al
  801544:	38 c2                	cmp    %al,%dl
  801546:	74 da                	je     801522 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801548:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80154c:	75 07                	jne    801555 <strncmp+0x38>
		return 0;
  80154e:	b8 00 00 00 00       	mov    $0x0,%eax
  801553:	eb 14                	jmp    801569 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801555:	8b 45 08             	mov    0x8(%ebp),%eax
  801558:	8a 00                	mov    (%eax),%al
  80155a:	0f b6 d0             	movzbl %al,%edx
  80155d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801560:	8a 00                	mov    (%eax),%al
  801562:	0f b6 c0             	movzbl %al,%eax
  801565:	29 c2                	sub    %eax,%edx
  801567:	89 d0                	mov    %edx,%eax
}
  801569:	5d                   	pop    %ebp
  80156a:	c3                   	ret    

0080156b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80156b:	55                   	push   %ebp
  80156c:	89 e5                	mov    %esp,%ebp
  80156e:	83 ec 04             	sub    $0x4,%esp
  801571:	8b 45 0c             	mov    0xc(%ebp),%eax
  801574:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801577:	eb 12                	jmp    80158b <strchr+0x20>
		if (*s == c)
  801579:	8b 45 08             	mov    0x8(%ebp),%eax
  80157c:	8a 00                	mov    (%eax),%al
  80157e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801581:	75 05                	jne    801588 <strchr+0x1d>
			return (char *) s;
  801583:	8b 45 08             	mov    0x8(%ebp),%eax
  801586:	eb 11                	jmp    801599 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801588:	ff 45 08             	incl   0x8(%ebp)
  80158b:	8b 45 08             	mov    0x8(%ebp),%eax
  80158e:	8a 00                	mov    (%eax),%al
  801590:	84 c0                	test   %al,%al
  801592:	75 e5                	jne    801579 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801594:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801599:	c9                   	leave  
  80159a:	c3                   	ret    

0080159b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80159b:	55                   	push   %ebp
  80159c:	89 e5                	mov    %esp,%ebp
  80159e:	83 ec 04             	sub    $0x4,%esp
  8015a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015a7:	eb 0d                	jmp    8015b6 <strfind+0x1b>
		if (*s == c)
  8015a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ac:	8a 00                	mov    (%eax),%al
  8015ae:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015b1:	74 0e                	je     8015c1 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8015b3:	ff 45 08             	incl   0x8(%ebp)
  8015b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b9:	8a 00                	mov    (%eax),%al
  8015bb:	84 c0                	test   %al,%al
  8015bd:	75 ea                	jne    8015a9 <strfind+0xe>
  8015bf:	eb 01                	jmp    8015c2 <strfind+0x27>
		if (*s == c)
			break;
  8015c1:	90                   	nop
	return (char *) s;
  8015c2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015c5:	c9                   	leave  
  8015c6:	c3                   	ret    

008015c7 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8015c7:	55                   	push   %ebp
  8015c8:	89 e5                	mov    %esp,%ebp
  8015ca:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8015cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8015d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8015d9:	eb 0e                	jmp    8015e9 <memset+0x22>
		*p++ = c;
  8015db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015de:	8d 50 01             	lea    0x1(%eax),%edx
  8015e1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e7:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8015e9:	ff 4d f8             	decl   -0x8(%ebp)
  8015ec:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8015f0:	79 e9                	jns    8015db <memset+0x14>
		*p++ = c;

	return v;
  8015f2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015f5:	c9                   	leave  
  8015f6:	c3                   	ret    

008015f7 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
  8015fa:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8015fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801600:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801603:	8b 45 08             	mov    0x8(%ebp),%eax
  801606:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801609:	eb 16                	jmp    801621 <memcpy+0x2a>
		*d++ = *s++;
  80160b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80160e:	8d 50 01             	lea    0x1(%eax),%edx
  801611:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801614:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801617:	8d 4a 01             	lea    0x1(%edx),%ecx
  80161a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80161d:	8a 12                	mov    (%edx),%dl
  80161f:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801621:	8b 45 10             	mov    0x10(%ebp),%eax
  801624:	8d 50 ff             	lea    -0x1(%eax),%edx
  801627:	89 55 10             	mov    %edx,0x10(%ebp)
  80162a:	85 c0                	test   %eax,%eax
  80162c:	75 dd                	jne    80160b <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80162e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801631:	c9                   	leave  
  801632:	c3                   	ret    

00801633 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801633:	55                   	push   %ebp
  801634:	89 e5                	mov    %esp,%ebp
  801636:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801639:	8b 45 0c             	mov    0xc(%ebp),%eax
  80163c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80163f:	8b 45 08             	mov    0x8(%ebp),%eax
  801642:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801645:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801648:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80164b:	73 50                	jae    80169d <memmove+0x6a>
  80164d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801650:	8b 45 10             	mov    0x10(%ebp),%eax
  801653:	01 d0                	add    %edx,%eax
  801655:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801658:	76 43                	jbe    80169d <memmove+0x6a>
		s += n;
  80165a:	8b 45 10             	mov    0x10(%ebp),%eax
  80165d:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801660:	8b 45 10             	mov    0x10(%ebp),%eax
  801663:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801666:	eb 10                	jmp    801678 <memmove+0x45>
			*--d = *--s;
  801668:	ff 4d f8             	decl   -0x8(%ebp)
  80166b:	ff 4d fc             	decl   -0x4(%ebp)
  80166e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801671:	8a 10                	mov    (%eax),%dl
  801673:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801676:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801678:	8b 45 10             	mov    0x10(%ebp),%eax
  80167b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80167e:	89 55 10             	mov    %edx,0x10(%ebp)
  801681:	85 c0                	test   %eax,%eax
  801683:	75 e3                	jne    801668 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801685:	eb 23                	jmp    8016aa <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801687:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80168a:	8d 50 01             	lea    0x1(%eax),%edx
  80168d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801690:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801693:	8d 4a 01             	lea    0x1(%edx),%ecx
  801696:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801699:	8a 12                	mov    (%edx),%dl
  80169b:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80169d:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016a3:	89 55 10             	mov    %edx,0x10(%ebp)
  8016a6:	85 c0                	test   %eax,%eax
  8016a8:	75 dd                	jne    801687 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8016aa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016ad:	c9                   	leave  
  8016ae:	c3                   	ret    

008016af <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8016af:	55                   	push   %ebp
  8016b0:	89 e5                	mov    %esp,%ebp
  8016b2:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8016b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8016bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016be:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8016c1:	eb 2a                	jmp    8016ed <memcmp+0x3e>
		if (*s1 != *s2)
  8016c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016c6:	8a 10                	mov    (%eax),%dl
  8016c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016cb:	8a 00                	mov    (%eax),%al
  8016cd:	38 c2                	cmp    %al,%dl
  8016cf:	74 16                	je     8016e7 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8016d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016d4:	8a 00                	mov    (%eax),%al
  8016d6:	0f b6 d0             	movzbl %al,%edx
  8016d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016dc:	8a 00                	mov    (%eax),%al
  8016de:	0f b6 c0             	movzbl %al,%eax
  8016e1:	29 c2                	sub    %eax,%edx
  8016e3:	89 d0                	mov    %edx,%eax
  8016e5:	eb 18                	jmp    8016ff <memcmp+0x50>
		s1++, s2++;
  8016e7:	ff 45 fc             	incl   -0x4(%ebp)
  8016ea:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8016ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016f3:	89 55 10             	mov    %edx,0x10(%ebp)
  8016f6:	85 c0                	test   %eax,%eax
  8016f8:	75 c9                	jne    8016c3 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016ff:	c9                   	leave  
  801700:	c3                   	ret    

00801701 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801701:	55                   	push   %ebp
  801702:	89 e5                	mov    %esp,%ebp
  801704:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801707:	8b 55 08             	mov    0x8(%ebp),%edx
  80170a:	8b 45 10             	mov    0x10(%ebp),%eax
  80170d:	01 d0                	add    %edx,%eax
  80170f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801712:	eb 15                	jmp    801729 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801714:	8b 45 08             	mov    0x8(%ebp),%eax
  801717:	8a 00                	mov    (%eax),%al
  801719:	0f b6 d0             	movzbl %al,%edx
  80171c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80171f:	0f b6 c0             	movzbl %al,%eax
  801722:	39 c2                	cmp    %eax,%edx
  801724:	74 0d                	je     801733 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801726:	ff 45 08             	incl   0x8(%ebp)
  801729:	8b 45 08             	mov    0x8(%ebp),%eax
  80172c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80172f:	72 e3                	jb     801714 <memfind+0x13>
  801731:	eb 01                	jmp    801734 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801733:	90                   	nop
	return (void *) s;
  801734:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801737:	c9                   	leave  
  801738:	c3                   	ret    

00801739 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801739:	55                   	push   %ebp
  80173a:	89 e5                	mov    %esp,%ebp
  80173c:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80173f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801746:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80174d:	eb 03                	jmp    801752 <strtol+0x19>
		s++;
  80174f:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801752:	8b 45 08             	mov    0x8(%ebp),%eax
  801755:	8a 00                	mov    (%eax),%al
  801757:	3c 20                	cmp    $0x20,%al
  801759:	74 f4                	je     80174f <strtol+0x16>
  80175b:	8b 45 08             	mov    0x8(%ebp),%eax
  80175e:	8a 00                	mov    (%eax),%al
  801760:	3c 09                	cmp    $0x9,%al
  801762:	74 eb                	je     80174f <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801764:	8b 45 08             	mov    0x8(%ebp),%eax
  801767:	8a 00                	mov    (%eax),%al
  801769:	3c 2b                	cmp    $0x2b,%al
  80176b:	75 05                	jne    801772 <strtol+0x39>
		s++;
  80176d:	ff 45 08             	incl   0x8(%ebp)
  801770:	eb 13                	jmp    801785 <strtol+0x4c>
	else if (*s == '-')
  801772:	8b 45 08             	mov    0x8(%ebp),%eax
  801775:	8a 00                	mov    (%eax),%al
  801777:	3c 2d                	cmp    $0x2d,%al
  801779:	75 0a                	jne    801785 <strtol+0x4c>
		s++, neg = 1;
  80177b:	ff 45 08             	incl   0x8(%ebp)
  80177e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801785:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801789:	74 06                	je     801791 <strtol+0x58>
  80178b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80178f:	75 20                	jne    8017b1 <strtol+0x78>
  801791:	8b 45 08             	mov    0x8(%ebp),%eax
  801794:	8a 00                	mov    (%eax),%al
  801796:	3c 30                	cmp    $0x30,%al
  801798:	75 17                	jne    8017b1 <strtol+0x78>
  80179a:	8b 45 08             	mov    0x8(%ebp),%eax
  80179d:	40                   	inc    %eax
  80179e:	8a 00                	mov    (%eax),%al
  8017a0:	3c 78                	cmp    $0x78,%al
  8017a2:	75 0d                	jne    8017b1 <strtol+0x78>
		s += 2, base = 16;
  8017a4:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8017a8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8017af:	eb 28                	jmp    8017d9 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8017b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017b5:	75 15                	jne    8017cc <strtol+0x93>
  8017b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ba:	8a 00                	mov    (%eax),%al
  8017bc:	3c 30                	cmp    $0x30,%al
  8017be:	75 0c                	jne    8017cc <strtol+0x93>
		s++, base = 8;
  8017c0:	ff 45 08             	incl   0x8(%ebp)
  8017c3:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8017ca:	eb 0d                	jmp    8017d9 <strtol+0xa0>
	else if (base == 0)
  8017cc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017d0:	75 07                	jne    8017d9 <strtol+0xa0>
		base = 10;
  8017d2:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017dc:	8a 00                	mov    (%eax),%al
  8017de:	3c 2f                	cmp    $0x2f,%al
  8017e0:	7e 19                	jle    8017fb <strtol+0xc2>
  8017e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e5:	8a 00                	mov    (%eax),%al
  8017e7:	3c 39                	cmp    $0x39,%al
  8017e9:	7f 10                	jg     8017fb <strtol+0xc2>
			dig = *s - '0';
  8017eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ee:	8a 00                	mov    (%eax),%al
  8017f0:	0f be c0             	movsbl %al,%eax
  8017f3:	83 e8 30             	sub    $0x30,%eax
  8017f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017f9:	eb 42                	jmp    80183d <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8017fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fe:	8a 00                	mov    (%eax),%al
  801800:	3c 60                	cmp    $0x60,%al
  801802:	7e 19                	jle    80181d <strtol+0xe4>
  801804:	8b 45 08             	mov    0x8(%ebp),%eax
  801807:	8a 00                	mov    (%eax),%al
  801809:	3c 7a                	cmp    $0x7a,%al
  80180b:	7f 10                	jg     80181d <strtol+0xe4>
			dig = *s - 'a' + 10;
  80180d:	8b 45 08             	mov    0x8(%ebp),%eax
  801810:	8a 00                	mov    (%eax),%al
  801812:	0f be c0             	movsbl %al,%eax
  801815:	83 e8 57             	sub    $0x57,%eax
  801818:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80181b:	eb 20                	jmp    80183d <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80181d:	8b 45 08             	mov    0x8(%ebp),%eax
  801820:	8a 00                	mov    (%eax),%al
  801822:	3c 40                	cmp    $0x40,%al
  801824:	7e 39                	jle    80185f <strtol+0x126>
  801826:	8b 45 08             	mov    0x8(%ebp),%eax
  801829:	8a 00                	mov    (%eax),%al
  80182b:	3c 5a                	cmp    $0x5a,%al
  80182d:	7f 30                	jg     80185f <strtol+0x126>
			dig = *s - 'A' + 10;
  80182f:	8b 45 08             	mov    0x8(%ebp),%eax
  801832:	8a 00                	mov    (%eax),%al
  801834:	0f be c0             	movsbl %al,%eax
  801837:	83 e8 37             	sub    $0x37,%eax
  80183a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80183d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801840:	3b 45 10             	cmp    0x10(%ebp),%eax
  801843:	7d 19                	jge    80185e <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801845:	ff 45 08             	incl   0x8(%ebp)
  801848:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80184b:	0f af 45 10          	imul   0x10(%ebp),%eax
  80184f:	89 c2                	mov    %eax,%edx
  801851:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801854:	01 d0                	add    %edx,%eax
  801856:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801859:	e9 7b ff ff ff       	jmp    8017d9 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80185e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80185f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801863:	74 08                	je     80186d <strtol+0x134>
		*endptr = (char *) s;
  801865:	8b 45 0c             	mov    0xc(%ebp),%eax
  801868:	8b 55 08             	mov    0x8(%ebp),%edx
  80186b:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80186d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801871:	74 07                	je     80187a <strtol+0x141>
  801873:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801876:	f7 d8                	neg    %eax
  801878:	eb 03                	jmp    80187d <strtol+0x144>
  80187a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80187d:	c9                   	leave  
  80187e:	c3                   	ret    

0080187f <ltostr>:

void
ltostr(long value, char *str)
{
  80187f:	55                   	push   %ebp
  801880:	89 e5                	mov    %esp,%ebp
  801882:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801885:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80188c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801893:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801897:	79 13                	jns    8018ac <ltostr+0x2d>
	{
		neg = 1;
  801899:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8018a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a3:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8018a6:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8018a9:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8018ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8018af:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8018b4:	99                   	cltd   
  8018b5:	f7 f9                	idiv   %ecx
  8018b7:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8018ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018bd:	8d 50 01             	lea    0x1(%eax),%edx
  8018c0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018c3:	89 c2                	mov    %eax,%edx
  8018c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c8:	01 d0                	add    %edx,%eax
  8018ca:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018cd:	83 c2 30             	add    $0x30,%edx
  8018d0:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8018d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018d5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8018da:	f7 e9                	imul   %ecx
  8018dc:	c1 fa 02             	sar    $0x2,%edx
  8018df:	89 c8                	mov    %ecx,%eax
  8018e1:	c1 f8 1f             	sar    $0x1f,%eax
  8018e4:	29 c2                	sub    %eax,%edx
  8018e6:	89 d0                	mov    %edx,%eax
  8018e8:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8018eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018ee:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8018f3:	f7 e9                	imul   %ecx
  8018f5:	c1 fa 02             	sar    $0x2,%edx
  8018f8:	89 c8                	mov    %ecx,%eax
  8018fa:	c1 f8 1f             	sar    $0x1f,%eax
  8018fd:	29 c2                	sub    %eax,%edx
  8018ff:	89 d0                	mov    %edx,%eax
  801901:	c1 e0 02             	shl    $0x2,%eax
  801904:	01 d0                	add    %edx,%eax
  801906:	01 c0                	add    %eax,%eax
  801908:	29 c1                	sub    %eax,%ecx
  80190a:	89 ca                	mov    %ecx,%edx
  80190c:	85 d2                	test   %edx,%edx
  80190e:	75 9c                	jne    8018ac <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801910:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801917:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80191a:	48                   	dec    %eax
  80191b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80191e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801922:	74 3d                	je     801961 <ltostr+0xe2>
		start = 1 ;
  801924:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80192b:	eb 34                	jmp    801961 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80192d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801930:	8b 45 0c             	mov    0xc(%ebp),%eax
  801933:	01 d0                	add    %edx,%eax
  801935:	8a 00                	mov    (%eax),%al
  801937:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80193a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80193d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801940:	01 c2                	add    %eax,%edx
  801942:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801945:	8b 45 0c             	mov    0xc(%ebp),%eax
  801948:	01 c8                	add    %ecx,%eax
  80194a:	8a 00                	mov    (%eax),%al
  80194c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80194e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801951:	8b 45 0c             	mov    0xc(%ebp),%eax
  801954:	01 c2                	add    %eax,%edx
  801956:	8a 45 eb             	mov    -0x15(%ebp),%al
  801959:	88 02                	mov    %al,(%edx)
		start++ ;
  80195b:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80195e:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801961:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801964:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801967:	7c c4                	jl     80192d <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801969:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80196c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80196f:	01 d0                	add    %edx,%eax
  801971:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801974:	90                   	nop
  801975:	c9                   	leave  
  801976:	c3                   	ret    

00801977 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801977:	55                   	push   %ebp
  801978:	89 e5                	mov    %esp,%ebp
  80197a:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80197d:	ff 75 08             	pushl  0x8(%ebp)
  801980:	e8 54 fa ff ff       	call   8013d9 <strlen>
  801985:	83 c4 04             	add    $0x4,%esp
  801988:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80198b:	ff 75 0c             	pushl  0xc(%ebp)
  80198e:	e8 46 fa ff ff       	call   8013d9 <strlen>
  801993:	83 c4 04             	add    $0x4,%esp
  801996:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801999:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8019a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8019a7:	eb 17                	jmp    8019c0 <strcconcat+0x49>
		final[s] = str1[s] ;
  8019a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8019af:	01 c2                	add    %eax,%edx
  8019b1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8019b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b7:	01 c8                	add    %ecx,%eax
  8019b9:	8a 00                	mov    (%eax),%al
  8019bb:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8019bd:	ff 45 fc             	incl   -0x4(%ebp)
  8019c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019c3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8019c6:	7c e1                	jl     8019a9 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8019c8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8019cf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8019d6:	eb 1f                	jmp    8019f7 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8019d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019db:	8d 50 01             	lea    0x1(%eax),%edx
  8019de:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8019e1:	89 c2                	mov    %eax,%edx
  8019e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8019e6:	01 c2                	add    %eax,%edx
  8019e8:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8019eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ee:	01 c8                	add    %ecx,%eax
  8019f0:	8a 00                	mov    (%eax),%al
  8019f2:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8019f4:	ff 45 f8             	incl   -0x8(%ebp)
  8019f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019fa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019fd:	7c d9                	jl     8019d8 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8019ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a02:	8b 45 10             	mov    0x10(%ebp),%eax
  801a05:	01 d0                	add    %edx,%eax
  801a07:	c6 00 00             	movb   $0x0,(%eax)
}
  801a0a:	90                   	nop
  801a0b:	c9                   	leave  
  801a0c:	c3                   	ret    

00801a0d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a10:	8b 45 14             	mov    0x14(%ebp),%eax
  801a13:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a19:	8b 45 14             	mov    0x14(%ebp),%eax
  801a1c:	8b 00                	mov    (%eax),%eax
  801a1e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a25:	8b 45 10             	mov    0x10(%ebp),%eax
  801a28:	01 d0                	add    %edx,%eax
  801a2a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a30:	eb 0c                	jmp    801a3e <strsplit+0x31>
			*string++ = 0;
  801a32:	8b 45 08             	mov    0x8(%ebp),%eax
  801a35:	8d 50 01             	lea    0x1(%eax),%edx
  801a38:	89 55 08             	mov    %edx,0x8(%ebp)
  801a3b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a41:	8a 00                	mov    (%eax),%al
  801a43:	84 c0                	test   %al,%al
  801a45:	74 18                	je     801a5f <strsplit+0x52>
  801a47:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4a:	8a 00                	mov    (%eax),%al
  801a4c:	0f be c0             	movsbl %al,%eax
  801a4f:	50                   	push   %eax
  801a50:	ff 75 0c             	pushl  0xc(%ebp)
  801a53:	e8 13 fb ff ff       	call   80156b <strchr>
  801a58:	83 c4 08             	add    $0x8,%esp
  801a5b:	85 c0                	test   %eax,%eax
  801a5d:	75 d3                	jne    801a32 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a62:	8a 00                	mov    (%eax),%al
  801a64:	84 c0                	test   %al,%al
  801a66:	74 5a                	je     801ac2 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a68:	8b 45 14             	mov    0x14(%ebp),%eax
  801a6b:	8b 00                	mov    (%eax),%eax
  801a6d:	83 f8 0f             	cmp    $0xf,%eax
  801a70:	75 07                	jne    801a79 <strsplit+0x6c>
		{
			return 0;
  801a72:	b8 00 00 00 00       	mov    $0x0,%eax
  801a77:	eb 66                	jmp    801adf <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a79:	8b 45 14             	mov    0x14(%ebp),%eax
  801a7c:	8b 00                	mov    (%eax),%eax
  801a7e:	8d 48 01             	lea    0x1(%eax),%ecx
  801a81:	8b 55 14             	mov    0x14(%ebp),%edx
  801a84:	89 0a                	mov    %ecx,(%edx)
  801a86:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a8d:	8b 45 10             	mov    0x10(%ebp),%eax
  801a90:	01 c2                	add    %eax,%edx
  801a92:	8b 45 08             	mov    0x8(%ebp),%eax
  801a95:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a97:	eb 03                	jmp    801a9c <strsplit+0x8f>
			string++;
  801a99:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9f:	8a 00                	mov    (%eax),%al
  801aa1:	84 c0                	test   %al,%al
  801aa3:	74 8b                	je     801a30 <strsplit+0x23>
  801aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa8:	8a 00                	mov    (%eax),%al
  801aaa:	0f be c0             	movsbl %al,%eax
  801aad:	50                   	push   %eax
  801aae:	ff 75 0c             	pushl  0xc(%ebp)
  801ab1:	e8 b5 fa ff ff       	call   80156b <strchr>
  801ab6:	83 c4 08             	add    $0x8,%esp
  801ab9:	85 c0                	test   %eax,%eax
  801abb:	74 dc                	je     801a99 <strsplit+0x8c>
			string++;
	}
  801abd:	e9 6e ff ff ff       	jmp    801a30 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801ac2:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801ac3:	8b 45 14             	mov    0x14(%ebp),%eax
  801ac6:	8b 00                	mov    (%eax),%eax
  801ac8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801acf:	8b 45 10             	mov    0x10(%ebp),%eax
  801ad2:	01 d0                	add    %edx,%eax
  801ad4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801ada:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801adf:	c9                   	leave  
  801ae0:	c3                   	ret    

00801ae1 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801ae1:	55                   	push   %ebp
  801ae2:	89 e5                	mov    %esp,%ebp
  801ae4:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801ae7:	a1 04 50 80 00       	mov    0x805004,%eax
  801aec:	85 c0                	test   %eax,%eax
  801aee:	74 1f                	je     801b0f <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801af0:	e8 1d 00 00 00       	call   801b12 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801af5:	83 ec 0c             	sub    $0xc,%esp
  801af8:	68 a4 42 80 00       	push   $0x8042a4
  801afd:	e8 4f f0 ff ff       	call   800b51 <cprintf>
  801b02:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801b05:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801b0c:	00 00 00 
	}
}
  801b0f:	90                   	nop
  801b10:	c9                   	leave  
  801b11:	c3                   	ret    

00801b12 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801b12:	55                   	push   %ebp
  801b13:	89 e5                	mov    %esp,%ebp
  801b15:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801b18:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801b1f:	00 00 00 
  801b22:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801b29:	00 00 00 
  801b2c:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801b33:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  801b36:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801b3d:	00 00 00 
  801b40:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801b47:	00 00 00 
  801b4a:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801b51:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801b54:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801b5b:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801b5e:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801b65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b68:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b6d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801b72:	a3 50 50 80 00       	mov    %eax,0x805050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  801b77:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801b7e:	a1 20 51 80 00       	mov    0x805120,%eax
  801b83:	c1 e0 04             	shl    $0x4,%eax
  801b86:	89 c2                	mov    %eax,%edx
  801b88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b8b:	01 d0                	add    %edx,%eax
  801b8d:	48                   	dec    %eax
  801b8e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b94:	ba 00 00 00 00       	mov    $0x0,%edx
  801b99:	f7 75 f0             	divl   -0x10(%ebp)
  801b9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b9f:	29 d0                	sub    %edx,%eax
  801ba1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  801ba4:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801bab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bae:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bb3:	2d 00 10 00 00       	sub    $0x1000,%eax
  801bb8:	83 ec 04             	sub    $0x4,%esp
  801bbb:	6a 06                	push   $0x6
  801bbd:	ff 75 e8             	pushl  -0x18(%ebp)
  801bc0:	50                   	push   %eax
  801bc1:	e8 b0 05 00 00       	call   802176 <sys_allocate_chunk>
  801bc6:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801bc9:	a1 20 51 80 00       	mov    0x805120,%eax
  801bce:	83 ec 0c             	sub    $0xc,%esp
  801bd1:	50                   	push   %eax
  801bd2:	e8 25 0c 00 00       	call   8027fc <initialize_MemBlocksList>
  801bd7:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  801bda:	a1 48 51 80 00       	mov    0x805148,%eax
  801bdf:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  801be2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801be6:	75 14                	jne    801bfc <initialize_dyn_block_system+0xea>
  801be8:	83 ec 04             	sub    $0x4,%esp
  801beb:	68 c9 42 80 00       	push   $0x8042c9
  801bf0:	6a 29                	push   $0x29
  801bf2:	68 e7 42 80 00       	push   $0x8042e7
  801bf7:	e8 a1 ec ff ff       	call   80089d <_panic>
  801bfc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bff:	8b 00                	mov    (%eax),%eax
  801c01:	85 c0                	test   %eax,%eax
  801c03:	74 10                	je     801c15 <initialize_dyn_block_system+0x103>
  801c05:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c08:	8b 00                	mov    (%eax),%eax
  801c0a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c0d:	8b 52 04             	mov    0x4(%edx),%edx
  801c10:	89 50 04             	mov    %edx,0x4(%eax)
  801c13:	eb 0b                	jmp    801c20 <initialize_dyn_block_system+0x10e>
  801c15:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c18:	8b 40 04             	mov    0x4(%eax),%eax
  801c1b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801c20:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c23:	8b 40 04             	mov    0x4(%eax),%eax
  801c26:	85 c0                	test   %eax,%eax
  801c28:	74 0f                	je     801c39 <initialize_dyn_block_system+0x127>
  801c2a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c2d:	8b 40 04             	mov    0x4(%eax),%eax
  801c30:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c33:	8b 12                	mov    (%edx),%edx
  801c35:	89 10                	mov    %edx,(%eax)
  801c37:	eb 0a                	jmp    801c43 <initialize_dyn_block_system+0x131>
  801c39:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c3c:	8b 00                	mov    (%eax),%eax
  801c3e:	a3 48 51 80 00       	mov    %eax,0x805148
  801c43:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c46:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c4f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801c56:	a1 54 51 80 00       	mov    0x805154,%eax
  801c5b:	48                   	dec    %eax
  801c5c:	a3 54 51 80 00       	mov    %eax,0x805154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  801c61:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c64:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  801c6b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c6e:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  801c75:	83 ec 0c             	sub    $0xc,%esp
  801c78:	ff 75 e0             	pushl  -0x20(%ebp)
  801c7b:	e8 b9 14 00 00       	call   803139 <insert_sorted_with_merge_freeList>
  801c80:	83 c4 10             	add    $0x10,%esp

}
  801c83:	90                   	nop
  801c84:	c9                   	leave  
  801c85:	c3                   	ret    

00801c86 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801c86:	55                   	push   %ebp
  801c87:	89 e5                	mov    %esp,%ebp
  801c89:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c8c:	e8 50 fe ff ff       	call   801ae1 <InitializeUHeap>
	if (size == 0) return NULL ;
  801c91:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c95:	75 07                	jne    801c9e <malloc+0x18>
  801c97:	b8 00 00 00 00       	mov    $0x0,%eax
  801c9c:	eb 68                	jmp    801d06 <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  801c9e:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801ca5:	8b 55 08             	mov    0x8(%ebp),%edx
  801ca8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cab:	01 d0                	add    %edx,%eax
  801cad:	48                   	dec    %eax
  801cae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801cb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cb4:	ba 00 00 00 00       	mov    $0x0,%edx
  801cb9:	f7 75 f4             	divl   -0xc(%ebp)
  801cbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cbf:	29 d0                	sub    %edx,%eax
  801cc1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  801cc4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801ccb:	e8 74 08 00 00       	call   802544 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801cd0:	85 c0                	test   %eax,%eax
  801cd2:	74 2d                	je     801d01 <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  801cd4:	83 ec 0c             	sub    $0xc,%esp
  801cd7:	ff 75 ec             	pushl  -0x14(%ebp)
  801cda:	e8 52 0e 00 00       	call   802b31 <alloc_block_FF>
  801cdf:	83 c4 10             	add    $0x10,%esp
  801ce2:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  801ce5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801ce9:	74 16                	je     801d01 <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  801ceb:	83 ec 0c             	sub    $0xc,%esp
  801cee:	ff 75 e8             	pushl  -0x18(%ebp)
  801cf1:	e8 3b 0c 00 00       	call   802931 <insert_sorted_allocList>
  801cf6:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  801cf9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801cfc:	8b 40 08             	mov    0x8(%eax),%eax
  801cff:	eb 05                	jmp    801d06 <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  801d01:	b8 00 00 00 00       	mov    $0x0,%eax

}
  801d06:	c9                   	leave  
  801d07:	c3                   	ret    

00801d08 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801d08:	55                   	push   %ebp
  801d09:	89 e5                	mov    %esp,%ebp
  801d0b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  801d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d11:	83 ec 08             	sub    $0x8,%esp
  801d14:	50                   	push   %eax
  801d15:	68 40 50 80 00       	push   $0x805040
  801d1a:	e8 ba 0b 00 00       	call   8028d9 <find_block>
  801d1f:	83 c4 10             	add    $0x10,%esp
  801d22:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  801d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d28:	8b 40 0c             	mov    0xc(%eax),%eax
  801d2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  801d2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d32:	0f 84 9f 00 00 00    	je     801dd7 <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  801d38:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3b:	83 ec 08             	sub    $0x8,%esp
  801d3e:	ff 75 f0             	pushl  -0x10(%ebp)
  801d41:	50                   	push   %eax
  801d42:	e8 f7 03 00 00       	call   80213e <sys_free_user_mem>
  801d47:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  801d4a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d4e:	75 14                	jne    801d64 <free+0x5c>
  801d50:	83 ec 04             	sub    $0x4,%esp
  801d53:	68 c9 42 80 00       	push   $0x8042c9
  801d58:	6a 6a                	push   $0x6a
  801d5a:	68 e7 42 80 00       	push   $0x8042e7
  801d5f:	e8 39 eb ff ff       	call   80089d <_panic>
  801d64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d67:	8b 00                	mov    (%eax),%eax
  801d69:	85 c0                	test   %eax,%eax
  801d6b:	74 10                	je     801d7d <free+0x75>
  801d6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d70:	8b 00                	mov    (%eax),%eax
  801d72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d75:	8b 52 04             	mov    0x4(%edx),%edx
  801d78:	89 50 04             	mov    %edx,0x4(%eax)
  801d7b:	eb 0b                	jmp    801d88 <free+0x80>
  801d7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d80:	8b 40 04             	mov    0x4(%eax),%eax
  801d83:	a3 44 50 80 00       	mov    %eax,0x805044
  801d88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d8b:	8b 40 04             	mov    0x4(%eax),%eax
  801d8e:	85 c0                	test   %eax,%eax
  801d90:	74 0f                	je     801da1 <free+0x99>
  801d92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d95:	8b 40 04             	mov    0x4(%eax),%eax
  801d98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d9b:	8b 12                	mov    (%edx),%edx
  801d9d:	89 10                	mov    %edx,(%eax)
  801d9f:	eb 0a                	jmp    801dab <free+0xa3>
  801da1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da4:	8b 00                	mov    (%eax),%eax
  801da6:	a3 40 50 80 00       	mov    %eax,0x805040
  801dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801db4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801dbe:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801dc3:	48                   	dec    %eax
  801dc4:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(blk);
  801dc9:	83 ec 0c             	sub    $0xc,%esp
  801dcc:	ff 75 f4             	pushl  -0xc(%ebp)
  801dcf:	e8 65 13 00 00       	call   803139 <insert_sorted_with_merge_freeList>
  801dd4:	83 c4 10             	add    $0x10,%esp
	}
}
  801dd7:	90                   	nop
  801dd8:	c9                   	leave  
  801dd9:	c3                   	ret    

00801dda <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801dda:	55                   	push   %ebp
  801ddb:	89 e5                	mov    %esp,%ebp
  801ddd:	83 ec 28             	sub    $0x28,%esp
  801de0:	8b 45 10             	mov    0x10(%ebp),%eax
  801de3:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801de6:	e8 f6 fc ff ff       	call   801ae1 <InitializeUHeap>
	if (size == 0) return NULL ;
  801deb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801def:	75 0a                	jne    801dfb <smalloc+0x21>
  801df1:	b8 00 00 00 00       	mov    $0x0,%eax
  801df6:	e9 af 00 00 00       	jmp    801eaa <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  801dfb:	e8 44 07 00 00       	call   802544 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801e00:	83 f8 01             	cmp    $0x1,%eax
  801e03:	0f 85 9c 00 00 00    	jne    801ea5 <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  801e09:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801e10:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e16:	01 d0                	add    %edx,%eax
  801e18:	48                   	dec    %eax
  801e19:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e1f:	ba 00 00 00 00       	mov    $0x0,%edx
  801e24:	f7 75 f4             	divl   -0xc(%ebp)
  801e27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e2a:	29 d0                	sub    %edx,%eax
  801e2c:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  801e2f:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  801e36:	76 07                	jbe    801e3f <smalloc+0x65>
			return NULL;
  801e38:	b8 00 00 00 00       	mov    $0x0,%eax
  801e3d:	eb 6b                	jmp    801eaa <smalloc+0xd0>
		blk =alloc_block_FF(size);
  801e3f:	83 ec 0c             	sub    $0xc,%esp
  801e42:	ff 75 0c             	pushl  0xc(%ebp)
  801e45:	e8 e7 0c 00 00       	call   802b31 <alloc_block_FF>
  801e4a:	83 c4 10             	add    $0x10,%esp
  801e4d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  801e50:	83 ec 0c             	sub    $0xc,%esp
  801e53:	ff 75 ec             	pushl  -0x14(%ebp)
  801e56:	e8 d6 0a 00 00       	call   802931 <insert_sorted_allocList>
  801e5b:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  801e5e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e62:	75 07                	jne    801e6b <smalloc+0x91>
		{
			return NULL;
  801e64:	b8 00 00 00 00       	mov    $0x0,%eax
  801e69:	eb 3f                	jmp    801eaa <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  801e6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e6e:	8b 40 08             	mov    0x8(%eax),%eax
  801e71:	89 c2                	mov    %eax,%edx
  801e73:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801e77:	52                   	push   %edx
  801e78:	50                   	push   %eax
  801e79:	ff 75 0c             	pushl  0xc(%ebp)
  801e7c:	ff 75 08             	pushl  0x8(%ebp)
  801e7f:	e8 45 04 00 00       	call   8022c9 <sys_createSharedObject>
  801e84:	83 c4 10             	add    $0x10,%esp
  801e87:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  801e8a:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801e8e:	74 06                	je     801e96 <smalloc+0xbc>
  801e90:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801e94:	75 07                	jne    801e9d <smalloc+0xc3>
		{
			return NULL;
  801e96:	b8 00 00 00 00       	mov    $0x0,%eax
  801e9b:	eb 0d                	jmp    801eaa <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  801e9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ea0:	8b 40 08             	mov    0x8(%eax),%eax
  801ea3:	eb 05                	jmp    801eaa <smalloc+0xd0>
		}
	}
	else
		return NULL;
  801ea5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eaa:	c9                   	leave  
  801eab:	c3                   	ret    

00801eac <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801eac:	55                   	push   %ebp
  801ead:	89 e5                	mov    %esp,%ebp
  801eaf:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801eb2:	e8 2a fc ff ff       	call   801ae1 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801eb7:	83 ec 08             	sub    $0x8,%esp
  801eba:	ff 75 0c             	pushl  0xc(%ebp)
  801ebd:	ff 75 08             	pushl  0x8(%ebp)
  801ec0:	e8 2e 04 00 00       	call   8022f3 <sys_getSizeOfSharedObject>
  801ec5:	83 c4 10             	add    $0x10,%esp
  801ec8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  801ecb:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801ecf:	75 0a                	jne    801edb <sget+0x2f>
	{
		return NULL;
  801ed1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed6:	e9 94 00 00 00       	jmp    801f6f <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801edb:	e8 64 06 00 00       	call   802544 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801ee0:	85 c0                	test   %eax,%eax
  801ee2:	0f 84 82 00 00 00    	je     801f6a <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  801ee8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  801eef:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801ef6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ef9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801efc:	01 d0                	add    %edx,%eax
  801efe:	48                   	dec    %eax
  801eff:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801f02:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f05:	ba 00 00 00 00       	mov    $0x0,%edx
  801f0a:	f7 75 ec             	divl   -0x14(%ebp)
  801f0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f10:	29 d0                	sub    %edx,%eax
  801f12:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  801f15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f18:	83 ec 0c             	sub    $0xc,%esp
  801f1b:	50                   	push   %eax
  801f1c:	e8 10 0c 00 00       	call   802b31 <alloc_block_FF>
  801f21:	83 c4 10             	add    $0x10,%esp
  801f24:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  801f27:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f2b:	75 07                	jne    801f34 <sget+0x88>
		{
			return NULL;
  801f2d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f32:	eb 3b                	jmp    801f6f <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  801f34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f37:	8b 40 08             	mov    0x8(%eax),%eax
  801f3a:	83 ec 04             	sub    $0x4,%esp
  801f3d:	50                   	push   %eax
  801f3e:	ff 75 0c             	pushl  0xc(%ebp)
  801f41:	ff 75 08             	pushl  0x8(%ebp)
  801f44:	e8 c7 03 00 00       	call   802310 <sys_getSharedObject>
  801f49:	83 c4 10             	add    $0x10,%esp
  801f4c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  801f4f:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801f53:	74 06                	je     801f5b <sget+0xaf>
  801f55:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  801f59:	75 07                	jne    801f62 <sget+0xb6>
		{
			return NULL;
  801f5b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f60:	eb 0d                	jmp    801f6f <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  801f62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f65:	8b 40 08             	mov    0x8(%eax),%eax
  801f68:	eb 05                	jmp    801f6f <sget+0xc3>
		}
	}
	else
			return NULL;
  801f6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f6f:	c9                   	leave  
  801f70:	c3                   	ret    

00801f71 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801f71:	55                   	push   %ebp
  801f72:	89 e5                	mov    %esp,%ebp
  801f74:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f77:	e8 65 fb ff ff       	call   801ae1 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801f7c:	83 ec 04             	sub    $0x4,%esp
  801f7f:	68 f4 42 80 00       	push   $0x8042f4
  801f84:	68 e1 00 00 00       	push   $0xe1
  801f89:	68 e7 42 80 00       	push   $0x8042e7
  801f8e:	e8 0a e9 ff ff       	call   80089d <_panic>

00801f93 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801f93:	55                   	push   %ebp
  801f94:	89 e5                	mov    %esp,%ebp
  801f96:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801f99:	83 ec 04             	sub    $0x4,%esp
  801f9c:	68 1c 43 80 00       	push   $0x80431c
  801fa1:	68 f5 00 00 00       	push   $0xf5
  801fa6:	68 e7 42 80 00       	push   $0x8042e7
  801fab:	e8 ed e8 ff ff       	call   80089d <_panic>

00801fb0 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801fb0:	55                   	push   %ebp
  801fb1:	89 e5                	mov    %esp,%ebp
  801fb3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801fb6:	83 ec 04             	sub    $0x4,%esp
  801fb9:	68 40 43 80 00       	push   $0x804340
  801fbe:	68 00 01 00 00       	push   $0x100
  801fc3:	68 e7 42 80 00       	push   $0x8042e7
  801fc8:	e8 d0 e8 ff ff       	call   80089d <_panic>

00801fcd <shrink>:

}
void shrink(uint32 newSize)
{
  801fcd:	55                   	push   %ebp
  801fce:	89 e5                	mov    %esp,%ebp
  801fd0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801fd3:	83 ec 04             	sub    $0x4,%esp
  801fd6:	68 40 43 80 00       	push   $0x804340
  801fdb:	68 05 01 00 00       	push   $0x105
  801fe0:	68 e7 42 80 00       	push   $0x8042e7
  801fe5:	e8 b3 e8 ff ff       	call   80089d <_panic>

00801fea <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801fea:	55                   	push   %ebp
  801feb:	89 e5                	mov    %esp,%ebp
  801fed:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ff0:	83 ec 04             	sub    $0x4,%esp
  801ff3:	68 40 43 80 00       	push   $0x804340
  801ff8:	68 0a 01 00 00       	push   $0x10a
  801ffd:	68 e7 42 80 00       	push   $0x8042e7
  802002:	e8 96 e8 ff ff       	call   80089d <_panic>

00802007 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802007:	55                   	push   %ebp
  802008:	89 e5                	mov    %esp,%ebp
  80200a:	57                   	push   %edi
  80200b:	56                   	push   %esi
  80200c:	53                   	push   %ebx
  80200d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802010:	8b 45 08             	mov    0x8(%ebp),%eax
  802013:	8b 55 0c             	mov    0xc(%ebp),%edx
  802016:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802019:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80201c:	8b 7d 18             	mov    0x18(%ebp),%edi
  80201f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802022:	cd 30                	int    $0x30
  802024:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802027:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80202a:	83 c4 10             	add    $0x10,%esp
  80202d:	5b                   	pop    %ebx
  80202e:	5e                   	pop    %esi
  80202f:	5f                   	pop    %edi
  802030:	5d                   	pop    %ebp
  802031:	c3                   	ret    

00802032 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802032:	55                   	push   %ebp
  802033:	89 e5                	mov    %esp,%ebp
  802035:	83 ec 04             	sub    $0x4,%esp
  802038:	8b 45 10             	mov    0x10(%ebp),%eax
  80203b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80203e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802042:	8b 45 08             	mov    0x8(%ebp),%eax
  802045:	6a 00                	push   $0x0
  802047:	6a 00                	push   $0x0
  802049:	52                   	push   %edx
  80204a:	ff 75 0c             	pushl  0xc(%ebp)
  80204d:	50                   	push   %eax
  80204e:	6a 00                	push   $0x0
  802050:	e8 b2 ff ff ff       	call   802007 <syscall>
  802055:	83 c4 18             	add    $0x18,%esp
}
  802058:	90                   	nop
  802059:	c9                   	leave  
  80205a:	c3                   	ret    

0080205b <sys_cgetc>:

int
sys_cgetc(void)
{
  80205b:	55                   	push   %ebp
  80205c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80205e:	6a 00                	push   $0x0
  802060:	6a 00                	push   $0x0
  802062:	6a 00                	push   $0x0
  802064:	6a 00                	push   $0x0
  802066:	6a 00                	push   $0x0
  802068:	6a 01                	push   $0x1
  80206a:	e8 98 ff ff ff       	call   802007 <syscall>
  80206f:	83 c4 18             	add    $0x18,%esp
}
  802072:	c9                   	leave  
  802073:	c3                   	ret    

00802074 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802074:	55                   	push   %ebp
  802075:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802077:	8b 55 0c             	mov    0xc(%ebp),%edx
  80207a:	8b 45 08             	mov    0x8(%ebp),%eax
  80207d:	6a 00                	push   $0x0
  80207f:	6a 00                	push   $0x0
  802081:	6a 00                	push   $0x0
  802083:	52                   	push   %edx
  802084:	50                   	push   %eax
  802085:	6a 05                	push   $0x5
  802087:	e8 7b ff ff ff       	call   802007 <syscall>
  80208c:	83 c4 18             	add    $0x18,%esp
}
  80208f:	c9                   	leave  
  802090:	c3                   	ret    

00802091 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802091:	55                   	push   %ebp
  802092:	89 e5                	mov    %esp,%ebp
  802094:	56                   	push   %esi
  802095:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802096:	8b 75 18             	mov    0x18(%ebp),%esi
  802099:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80209c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80209f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a5:	56                   	push   %esi
  8020a6:	53                   	push   %ebx
  8020a7:	51                   	push   %ecx
  8020a8:	52                   	push   %edx
  8020a9:	50                   	push   %eax
  8020aa:	6a 06                	push   $0x6
  8020ac:	e8 56 ff ff ff       	call   802007 <syscall>
  8020b1:	83 c4 18             	add    $0x18,%esp
}
  8020b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020b7:	5b                   	pop    %ebx
  8020b8:	5e                   	pop    %esi
  8020b9:	5d                   	pop    %ebp
  8020ba:	c3                   	ret    

008020bb <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8020bb:	55                   	push   %ebp
  8020bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8020be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c4:	6a 00                	push   $0x0
  8020c6:	6a 00                	push   $0x0
  8020c8:	6a 00                	push   $0x0
  8020ca:	52                   	push   %edx
  8020cb:	50                   	push   %eax
  8020cc:	6a 07                	push   $0x7
  8020ce:	e8 34 ff ff ff       	call   802007 <syscall>
  8020d3:	83 c4 18             	add    $0x18,%esp
}
  8020d6:	c9                   	leave  
  8020d7:	c3                   	ret    

008020d8 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8020d8:	55                   	push   %ebp
  8020d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8020db:	6a 00                	push   $0x0
  8020dd:	6a 00                	push   $0x0
  8020df:	6a 00                	push   $0x0
  8020e1:	ff 75 0c             	pushl  0xc(%ebp)
  8020e4:	ff 75 08             	pushl  0x8(%ebp)
  8020e7:	6a 08                	push   $0x8
  8020e9:	e8 19 ff ff ff       	call   802007 <syscall>
  8020ee:	83 c4 18             	add    $0x18,%esp
}
  8020f1:	c9                   	leave  
  8020f2:	c3                   	ret    

008020f3 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8020f3:	55                   	push   %ebp
  8020f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8020f6:	6a 00                	push   $0x0
  8020f8:	6a 00                	push   $0x0
  8020fa:	6a 00                	push   $0x0
  8020fc:	6a 00                	push   $0x0
  8020fe:	6a 00                	push   $0x0
  802100:	6a 09                	push   $0x9
  802102:	e8 00 ff ff ff       	call   802007 <syscall>
  802107:	83 c4 18             	add    $0x18,%esp
}
  80210a:	c9                   	leave  
  80210b:	c3                   	ret    

0080210c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80210c:	55                   	push   %ebp
  80210d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80210f:	6a 00                	push   $0x0
  802111:	6a 00                	push   $0x0
  802113:	6a 00                	push   $0x0
  802115:	6a 00                	push   $0x0
  802117:	6a 00                	push   $0x0
  802119:	6a 0a                	push   $0xa
  80211b:	e8 e7 fe ff ff       	call   802007 <syscall>
  802120:	83 c4 18             	add    $0x18,%esp
}
  802123:	c9                   	leave  
  802124:	c3                   	ret    

00802125 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802125:	55                   	push   %ebp
  802126:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802128:	6a 00                	push   $0x0
  80212a:	6a 00                	push   $0x0
  80212c:	6a 00                	push   $0x0
  80212e:	6a 00                	push   $0x0
  802130:	6a 00                	push   $0x0
  802132:	6a 0b                	push   $0xb
  802134:	e8 ce fe ff ff       	call   802007 <syscall>
  802139:	83 c4 18             	add    $0x18,%esp
}
  80213c:	c9                   	leave  
  80213d:	c3                   	ret    

0080213e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80213e:	55                   	push   %ebp
  80213f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802141:	6a 00                	push   $0x0
  802143:	6a 00                	push   $0x0
  802145:	6a 00                	push   $0x0
  802147:	ff 75 0c             	pushl  0xc(%ebp)
  80214a:	ff 75 08             	pushl  0x8(%ebp)
  80214d:	6a 0f                	push   $0xf
  80214f:	e8 b3 fe ff ff       	call   802007 <syscall>
  802154:	83 c4 18             	add    $0x18,%esp
	return;
  802157:	90                   	nop
}
  802158:	c9                   	leave  
  802159:	c3                   	ret    

0080215a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80215a:	55                   	push   %ebp
  80215b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80215d:	6a 00                	push   $0x0
  80215f:	6a 00                	push   $0x0
  802161:	6a 00                	push   $0x0
  802163:	ff 75 0c             	pushl  0xc(%ebp)
  802166:	ff 75 08             	pushl  0x8(%ebp)
  802169:	6a 10                	push   $0x10
  80216b:	e8 97 fe ff ff       	call   802007 <syscall>
  802170:	83 c4 18             	add    $0x18,%esp
	return ;
  802173:	90                   	nop
}
  802174:	c9                   	leave  
  802175:	c3                   	ret    

00802176 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802176:	55                   	push   %ebp
  802177:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802179:	6a 00                	push   $0x0
  80217b:	6a 00                	push   $0x0
  80217d:	ff 75 10             	pushl  0x10(%ebp)
  802180:	ff 75 0c             	pushl  0xc(%ebp)
  802183:	ff 75 08             	pushl  0x8(%ebp)
  802186:	6a 11                	push   $0x11
  802188:	e8 7a fe ff ff       	call   802007 <syscall>
  80218d:	83 c4 18             	add    $0x18,%esp
	return ;
  802190:	90                   	nop
}
  802191:	c9                   	leave  
  802192:	c3                   	ret    

00802193 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802193:	55                   	push   %ebp
  802194:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802196:	6a 00                	push   $0x0
  802198:	6a 00                	push   $0x0
  80219a:	6a 00                	push   $0x0
  80219c:	6a 00                	push   $0x0
  80219e:	6a 00                	push   $0x0
  8021a0:	6a 0c                	push   $0xc
  8021a2:	e8 60 fe ff ff       	call   802007 <syscall>
  8021a7:	83 c4 18             	add    $0x18,%esp
}
  8021aa:	c9                   	leave  
  8021ab:	c3                   	ret    

008021ac <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8021ac:	55                   	push   %ebp
  8021ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8021af:	6a 00                	push   $0x0
  8021b1:	6a 00                	push   $0x0
  8021b3:	6a 00                	push   $0x0
  8021b5:	6a 00                	push   $0x0
  8021b7:	ff 75 08             	pushl  0x8(%ebp)
  8021ba:	6a 0d                	push   $0xd
  8021bc:	e8 46 fe ff ff       	call   802007 <syscall>
  8021c1:	83 c4 18             	add    $0x18,%esp
}
  8021c4:	c9                   	leave  
  8021c5:	c3                   	ret    

008021c6 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8021c6:	55                   	push   %ebp
  8021c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8021c9:	6a 00                	push   $0x0
  8021cb:	6a 00                	push   $0x0
  8021cd:	6a 00                	push   $0x0
  8021cf:	6a 00                	push   $0x0
  8021d1:	6a 00                	push   $0x0
  8021d3:	6a 0e                	push   $0xe
  8021d5:	e8 2d fe ff ff       	call   802007 <syscall>
  8021da:	83 c4 18             	add    $0x18,%esp
}
  8021dd:	90                   	nop
  8021de:	c9                   	leave  
  8021df:	c3                   	ret    

008021e0 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8021e0:	55                   	push   %ebp
  8021e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8021e3:	6a 00                	push   $0x0
  8021e5:	6a 00                	push   $0x0
  8021e7:	6a 00                	push   $0x0
  8021e9:	6a 00                	push   $0x0
  8021eb:	6a 00                	push   $0x0
  8021ed:	6a 13                	push   $0x13
  8021ef:	e8 13 fe ff ff       	call   802007 <syscall>
  8021f4:	83 c4 18             	add    $0x18,%esp
}
  8021f7:	90                   	nop
  8021f8:	c9                   	leave  
  8021f9:	c3                   	ret    

008021fa <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8021fa:	55                   	push   %ebp
  8021fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 00                	push   $0x0
  802201:	6a 00                	push   $0x0
  802203:	6a 00                	push   $0x0
  802205:	6a 00                	push   $0x0
  802207:	6a 14                	push   $0x14
  802209:	e8 f9 fd ff ff       	call   802007 <syscall>
  80220e:	83 c4 18             	add    $0x18,%esp
}
  802211:	90                   	nop
  802212:	c9                   	leave  
  802213:	c3                   	ret    

00802214 <sys_cputc>:


void
sys_cputc(const char c)
{
  802214:	55                   	push   %ebp
  802215:	89 e5                	mov    %esp,%ebp
  802217:	83 ec 04             	sub    $0x4,%esp
  80221a:	8b 45 08             	mov    0x8(%ebp),%eax
  80221d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802220:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802224:	6a 00                	push   $0x0
  802226:	6a 00                	push   $0x0
  802228:	6a 00                	push   $0x0
  80222a:	6a 00                	push   $0x0
  80222c:	50                   	push   %eax
  80222d:	6a 15                	push   $0x15
  80222f:	e8 d3 fd ff ff       	call   802007 <syscall>
  802234:	83 c4 18             	add    $0x18,%esp
}
  802237:	90                   	nop
  802238:	c9                   	leave  
  802239:	c3                   	ret    

0080223a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80223a:	55                   	push   %ebp
  80223b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80223d:	6a 00                	push   $0x0
  80223f:	6a 00                	push   $0x0
  802241:	6a 00                	push   $0x0
  802243:	6a 00                	push   $0x0
  802245:	6a 00                	push   $0x0
  802247:	6a 16                	push   $0x16
  802249:	e8 b9 fd ff ff       	call   802007 <syscall>
  80224e:	83 c4 18             	add    $0x18,%esp
}
  802251:	90                   	nop
  802252:	c9                   	leave  
  802253:	c3                   	ret    

00802254 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802254:	55                   	push   %ebp
  802255:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802257:	8b 45 08             	mov    0x8(%ebp),%eax
  80225a:	6a 00                	push   $0x0
  80225c:	6a 00                	push   $0x0
  80225e:	6a 00                	push   $0x0
  802260:	ff 75 0c             	pushl  0xc(%ebp)
  802263:	50                   	push   %eax
  802264:	6a 17                	push   $0x17
  802266:	e8 9c fd ff ff       	call   802007 <syscall>
  80226b:	83 c4 18             	add    $0x18,%esp
}
  80226e:	c9                   	leave  
  80226f:	c3                   	ret    

00802270 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802270:	55                   	push   %ebp
  802271:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802273:	8b 55 0c             	mov    0xc(%ebp),%edx
  802276:	8b 45 08             	mov    0x8(%ebp),%eax
  802279:	6a 00                	push   $0x0
  80227b:	6a 00                	push   $0x0
  80227d:	6a 00                	push   $0x0
  80227f:	52                   	push   %edx
  802280:	50                   	push   %eax
  802281:	6a 1a                	push   $0x1a
  802283:	e8 7f fd ff ff       	call   802007 <syscall>
  802288:	83 c4 18             	add    $0x18,%esp
}
  80228b:	c9                   	leave  
  80228c:	c3                   	ret    

0080228d <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80228d:	55                   	push   %ebp
  80228e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802290:	8b 55 0c             	mov    0xc(%ebp),%edx
  802293:	8b 45 08             	mov    0x8(%ebp),%eax
  802296:	6a 00                	push   $0x0
  802298:	6a 00                	push   $0x0
  80229a:	6a 00                	push   $0x0
  80229c:	52                   	push   %edx
  80229d:	50                   	push   %eax
  80229e:	6a 18                	push   $0x18
  8022a0:	e8 62 fd ff ff       	call   802007 <syscall>
  8022a5:	83 c4 18             	add    $0x18,%esp
}
  8022a8:	90                   	nop
  8022a9:	c9                   	leave  
  8022aa:	c3                   	ret    

008022ab <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8022ab:	55                   	push   %ebp
  8022ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b4:	6a 00                	push   $0x0
  8022b6:	6a 00                	push   $0x0
  8022b8:	6a 00                	push   $0x0
  8022ba:	52                   	push   %edx
  8022bb:	50                   	push   %eax
  8022bc:	6a 19                	push   $0x19
  8022be:	e8 44 fd ff ff       	call   802007 <syscall>
  8022c3:	83 c4 18             	add    $0x18,%esp
}
  8022c6:	90                   	nop
  8022c7:	c9                   	leave  
  8022c8:	c3                   	ret    

008022c9 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8022c9:	55                   	push   %ebp
  8022ca:	89 e5                	mov    %esp,%ebp
  8022cc:	83 ec 04             	sub    $0x4,%esp
  8022cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8022d2:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8022d5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8022d8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8022dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022df:	6a 00                	push   $0x0
  8022e1:	51                   	push   %ecx
  8022e2:	52                   	push   %edx
  8022e3:	ff 75 0c             	pushl  0xc(%ebp)
  8022e6:	50                   	push   %eax
  8022e7:	6a 1b                	push   $0x1b
  8022e9:	e8 19 fd ff ff       	call   802007 <syscall>
  8022ee:	83 c4 18             	add    $0x18,%esp
}
  8022f1:	c9                   	leave  
  8022f2:	c3                   	ret    

008022f3 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8022f3:	55                   	push   %ebp
  8022f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8022f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fc:	6a 00                	push   $0x0
  8022fe:	6a 00                	push   $0x0
  802300:	6a 00                	push   $0x0
  802302:	52                   	push   %edx
  802303:	50                   	push   %eax
  802304:	6a 1c                	push   $0x1c
  802306:	e8 fc fc ff ff       	call   802007 <syscall>
  80230b:	83 c4 18             	add    $0x18,%esp
}
  80230e:	c9                   	leave  
  80230f:	c3                   	ret    

00802310 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802310:	55                   	push   %ebp
  802311:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802313:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802316:	8b 55 0c             	mov    0xc(%ebp),%edx
  802319:	8b 45 08             	mov    0x8(%ebp),%eax
  80231c:	6a 00                	push   $0x0
  80231e:	6a 00                	push   $0x0
  802320:	51                   	push   %ecx
  802321:	52                   	push   %edx
  802322:	50                   	push   %eax
  802323:	6a 1d                	push   $0x1d
  802325:	e8 dd fc ff ff       	call   802007 <syscall>
  80232a:	83 c4 18             	add    $0x18,%esp
}
  80232d:	c9                   	leave  
  80232e:	c3                   	ret    

0080232f <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80232f:	55                   	push   %ebp
  802330:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802332:	8b 55 0c             	mov    0xc(%ebp),%edx
  802335:	8b 45 08             	mov    0x8(%ebp),%eax
  802338:	6a 00                	push   $0x0
  80233a:	6a 00                	push   $0x0
  80233c:	6a 00                	push   $0x0
  80233e:	52                   	push   %edx
  80233f:	50                   	push   %eax
  802340:	6a 1e                	push   $0x1e
  802342:	e8 c0 fc ff ff       	call   802007 <syscall>
  802347:	83 c4 18             	add    $0x18,%esp
}
  80234a:	c9                   	leave  
  80234b:	c3                   	ret    

0080234c <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80234c:	55                   	push   %ebp
  80234d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80234f:	6a 00                	push   $0x0
  802351:	6a 00                	push   $0x0
  802353:	6a 00                	push   $0x0
  802355:	6a 00                	push   $0x0
  802357:	6a 00                	push   $0x0
  802359:	6a 1f                	push   $0x1f
  80235b:	e8 a7 fc ff ff       	call   802007 <syscall>
  802360:	83 c4 18             	add    $0x18,%esp
}
  802363:	c9                   	leave  
  802364:	c3                   	ret    

00802365 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802365:	55                   	push   %ebp
  802366:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802368:	8b 45 08             	mov    0x8(%ebp),%eax
  80236b:	6a 00                	push   $0x0
  80236d:	ff 75 14             	pushl  0x14(%ebp)
  802370:	ff 75 10             	pushl  0x10(%ebp)
  802373:	ff 75 0c             	pushl  0xc(%ebp)
  802376:	50                   	push   %eax
  802377:	6a 20                	push   $0x20
  802379:	e8 89 fc ff ff       	call   802007 <syscall>
  80237e:	83 c4 18             	add    $0x18,%esp
}
  802381:	c9                   	leave  
  802382:	c3                   	ret    

00802383 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802383:	55                   	push   %ebp
  802384:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802386:	8b 45 08             	mov    0x8(%ebp),%eax
  802389:	6a 00                	push   $0x0
  80238b:	6a 00                	push   $0x0
  80238d:	6a 00                	push   $0x0
  80238f:	6a 00                	push   $0x0
  802391:	50                   	push   %eax
  802392:	6a 21                	push   $0x21
  802394:	e8 6e fc ff ff       	call   802007 <syscall>
  802399:	83 c4 18             	add    $0x18,%esp
}
  80239c:	90                   	nop
  80239d:	c9                   	leave  
  80239e:	c3                   	ret    

0080239f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80239f:	55                   	push   %ebp
  8023a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8023a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a5:	6a 00                	push   $0x0
  8023a7:	6a 00                	push   $0x0
  8023a9:	6a 00                	push   $0x0
  8023ab:	6a 00                	push   $0x0
  8023ad:	50                   	push   %eax
  8023ae:	6a 22                	push   $0x22
  8023b0:	e8 52 fc ff ff       	call   802007 <syscall>
  8023b5:	83 c4 18             	add    $0x18,%esp
}
  8023b8:	c9                   	leave  
  8023b9:	c3                   	ret    

008023ba <sys_getenvid>:

int32 sys_getenvid(void)
{
  8023ba:	55                   	push   %ebp
  8023bb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8023bd:	6a 00                	push   $0x0
  8023bf:	6a 00                	push   $0x0
  8023c1:	6a 00                	push   $0x0
  8023c3:	6a 00                	push   $0x0
  8023c5:	6a 00                	push   $0x0
  8023c7:	6a 02                	push   $0x2
  8023c9:	e8 39 fc ff ff       	call   802007 <syscall>
  8023ce:	83 c4 18             	add    $0x18,%esp
}
  8023d1:	c9                   	leave  
  8023d2:	c3                   	ret    

008023d3 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8023d3:	55                   	push   %ebp
  8023d4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8023d6:	6a 00                	push   $0x0
  8023d8:	6a 00                	push   $0x0
  8023da:	6a 00                	push   $0x0
  8023dc:	6a 00                	push   $0x0
  8023de:	6a 00                	push   $0x0
  8023e0:	6a 03                	push   $0x3
  8023e2:	e8 20 fc ff ff       	call   802007 <syscall>
  8023e7:	83 c4 18             	add    $0x18,%esp
}
  8023ea:	c9                   	leave  
  8023eb:	c3                   	ret    

008023ec <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8023ec:	55                   	push   %ebp
  8023ed:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8023ef:	6a 00                	push   $0x0
  8023f1:	6a 00                	push   $0x0
  8023f3:	6a 00                	push   $0x0
  8023f5:	6a 00                	push   $0x0
  8023f7:	6a 00                	push   $0x0
  8023f9:	6a 04                	push   $0x4
  8023fb:	e8 07 fc ff ff       	call   802007 <syscall>
  802400:	83 c4 18             	add    $0x18,%esp
}
  802403:	c9                   	leave  
  802404:	c3                   	ret    

00802405 <sys_exit_env>:


void sys_exit_env(void)
{
  802405:	55                   	push   %ebp
  802406:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802408:	6a 00                	push   $0x0
  80240a:	6a 00                	push   $0x0
  80240c:	6a 00                	push   $0x0
  80240e:	6a 00                	push   $0x0
  802410:	6a 00                	push   $0x0
  802412:	6a 23                	push   $0x23
  802414:	e8 ee fb ff ff       	call   802007 <syscall>
  802419:	83 c4 18             	add    $0x18,%esp
}
  80241c:	90                   	nop
  80241d:	c9                   	leave  
  80241e:	c3                   	ret    

0080241f <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80241f:	55                   	push   %ebp
  802420:	89 e5                	mov    %esp,%ebp
  802422:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802425:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802428:	8d 50 04             	lea    0x4(%eax),%edx
  80242b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80242e:	6a 00                	push   $0x0
  802430:	6a 00                	push   $0x0
  802432:	6a 00                	push   $0x0
  802434:	52                   	push   %edx
  802435:	50                   	push   %eax
  802436:	6a 24                	push   $0x24
  802438:	e8 ca fb ff ff       	call   802007 <syscall>
  80243d:	83 c4 18             	add    $0x18,%esp
	return result;
  802440:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802443:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802446:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802449:	89 01                	mov    %eax,(%ecx)
  80244b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80244e:	8b 45 08             	mov    0x8(%ebp),%eax
  802451:	c9                   	leave  
  802452:	c2 04 00             	ret    $0x4

00802455 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802455:	55                   	push   %ebp
  802456:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802458:	6a 00                	push   $0x0
  80245a:	6a 00                	push   $0x0
  80245c:	ff 75 10             	pushl  0x10(%ebp)
  80245f:	ff 75 0c             	pushl  0xc(%ebp)
  802462:	ff 75 08             	pushl  0x8(%ebp)
  802465:	6a 12                	push   $0x12
  802467:	e8 9b fb ff ff       	call   802007 <syscall>
  80246c:	83 c4 18             	add    $0x18,%esp
	return ;
  80246f:	90                   	nop
}
  802470:	c9                   	leave  
  802471:	c3                   	ret    

00802472 <sys_rcr2>:
uint32 sys_rcr2()
{
  802472:	55                   	push   %ebp
  802473:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802475:	6a 00                	push   $0x0
  802477:	6a 00                	push   $0x0
  802479:	6a 00                	push   $0x0
  80247b:	6a 00                	push   $0x0
  80247d:	6a 00                	push   $0x0
  80247f:	6a 25                	push   $0x25
  802481:	e8 81 fb ff ff       	call   802007 <syscall>
  802486:	83 c4 18             	add    $0x18,%esp
}
  802489:	c9                   	leave  
  80248a:	c3                   	ret    

0080248b <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80248b:	55                   	push   %ebp
  80248c:	89 e5                	mov    %esp,%ebp
  80248e:	83 ec 04             	sub    $0x4,%esp
  802491:	8b 45 08             	mov    0x8(%ebp),%eax
  802494:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802497:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80249b:	6a 00                	push   $0x0
  80249d:	6a 00                	push   $0x0
  80249f:	6a 00                	push   $0x0
  8024a1:	6a 00                	push   $0x0
  8024a3:	50                   	push   %eax
  8024a4:	6a 26                	push   $0x26
  8024a6:	e8 5c fb ff ff       	call   802007 <syscall>
  8024ab:	83 c4 18             	add    $0x18,%esp
	return ;
  8024ae:	90                   	nop
}
  8024af:	c9                   	leave  
  8024b0:	c3                   	ret    

008024b1 <rsttst>:
void rsttst()
{
  8024b1:	55                   	push   %ebp
  8024b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8024b4:	6a 00                	push   $0x0
  8024b6:	6a 00                	push   $0x0
  8024b8:	6a 00                	push   $0x0
  8024ba:	6a 00                	push   $0x0
  8024bc:	6a 00                	push   $0x0
  8024be:	6a 28                	push   $0x28
  8024c0:	e8 42 fb ff ff       	call   802007 <syscall>
  8024c5:	83 c4 18             	add    $0x18,%esp
	return ;
  8024c8:	90                   	nop
}
  8024c9:	c9                   	leave  
  8024ca:	c3                   	ret    

008024cb <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8024cb:	55                   	push   %ebp
  8024cc:	89 e5                	mov    %esp,%ebp
  8024ce:	83 ec 04             	sub    $0x4,%esp
  8024d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8024d4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8024d7:	8b 55 18             	mov    0x18(%ebp),%edx
  8024da:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8024de:	52                   	push   %edx
  8024df:	50                   	push   %eax
  8024e0:	ff 75 10             	pushl  0x10(%ebp)
  8024e3:	ff 75 0c             	pushl  0xc(%ebp)
  8024e6:	ff 75 08             	pushl  0x8(%ebp)
  8024e9:	6a 27                	push   $0x27
  8024eb:	e8 17 fb ff ff       	call   802007 <syscall>
  8024f0:	83 c4 18             	add    $0x18,%esp
	return ;
  8024f3:	90                   	nop
}
  8024f4:	c9                   	leave  
  8024f5:	c3                   	ret    

008024f6 <chktst>:
void chktst(uint32 n)
{
  8024f6:	55                   	push   %ebp
  8024f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8024f9:	6a 00                	push   $0x0
  8024fb:	6a 00                	push   $0x0
  8024fd:	6a 00                	push   $0x0
  8024ff:	6a 00                	push   $0x0
  802501:	ff 75 08             	pushl  0x8(%ebp)
  802504:	6a 29                	push   $0x29
  802506:	e8 fc fa ff ff       	call   802007 <syscall>
  80250b:	83 c4 18             	add    $0x18,%esp
	return ;
  80250e:	90                   	nop
}
  80250f:	c9                   	leave  
  802510:	c3                   	ret    

00802511 <inctst>:

void inctst()
{
  802511:	55                   	push   %ebp
  802512:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802514:	6a 00                	push   $0x0
  802516:	6a 00                	push   $0x0
  802518:	6a 00                	push   $0x0
  80251a:	6a 00                	push   $0x0
  80251c:	6a 00                	push   $0x0
  80251e:	6a 2a                	push   $0x2a
  802520:	e8 e2 fa ff ff       	call   802007 <syscall>
  802525:	83 c4 18             	add    $0x18,%esp
	return ;
  802528:	90                   	nop
}
  802529:	c9                   	leave  
  80252a:	c3                   	ret    

0080252b <gettst>:
uint32 gettst()
{
  80252b:	55                   	push   %ebp
  80252c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80252e:	6a 00                	push   $0x0
  802530:	6a 00                	push   $0x0
  802532:	6a 00                	push   $0x0
  802534:	6a 00                	push   $0x0
  802536:	6a 00                	push   $0x0
  802538:	6a 2b                	push   $0x2b
  80253a:	e8 c8 fa ff ff       	call   802007 <syscall>
  80253f:	83 c4 18             	add    $0x18,%esp
}
  802542:	c9                   	leave  
  802543:	c3                   	ret    

00802544 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802544:	55                   	push   %ebp
  802545:	89 e5                	mov    %esp,%ebp
  802547:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80254a:	6a 00                	push   $0x0
  80254c:	6a 00                	push   $0x0
  80254e:	6a 00                	push   $0x0
  802550:	6a 00                	push   $0x0
  802552:	6a 00                	push   $0x0
  802554:	6a 2c                	push   $0x2c
  802556:	e8 ac fa ff ff       	call   802007 <syscall>
  80255b:	83 c4 18             	add    $0x18,%esp
  80255e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802561:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802565:	75 07                	jne    80256e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802567:	b8 01 00 00 00       	mov    $0x1,%eax
  80256c:	eb 05                	jmp    802573 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80256e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802573:	c9                   	leave  
  802574:	c3                   	ret    

00802575 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802575:	55                   	push   %ebp
  802576:	89 e5                	mov    %esp,%ebp
  802578:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80257b:	6a 00                	push   $0x0
  80257d:	6a 00                	push   $0x0
  80257f:	6a 00                	push   $0x0
  802581:	6a 00                	push   $0x0
  802583:	6a 00                	push   $0x0
  802585:	6a 2c                	push   $0x2c
  802587:	e8 7b fa ff ff       	call   802007 <syscall>
  80258c:	83 c4 18             	add    $0x18,%esp
  80258f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802592:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802596:	75 07                	jne    80259f <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802598:	b8 01 00 00 00       	mov    $0x1,%eax
  80259d:	eb 05                	jmp    8025a4 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80259f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025a4:	c9                   	leave  
  8025a5:	c3                   	ret    

008025a6 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8025a6:	55                   	push   %ebp
  8025a7:	89 e5                	mov    %esp,%ebp
  8025a9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025ac:	6a 00                	push   $0x0
  8025ae:	6a 00                	push   $0x0
  8025b0:	6a 00                	push   $0x0
  8025b2:	6a 00                	push   $0x0
  8025b4:	6a 00                	push   $0x0
  8025b6:	6a 2c                	push   $0x2c
  8025b8:	e8 4a fa ff ff       	call   802007 <syscall>
  8025bd:	83 c4 18             	add    $0x18,%esp
  8025c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8025c3:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8025c7:	75 07                	jne    8025d0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8025c9:	b8 01 00 00 00       	mov    $0x1,%eax
  8025ce:	eb 05                	jmp    8025d5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8025d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025d5:	c9                   	leave  
  8025d6:	c3                   	ret    

008025d7 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8025d7:	55                   	push   %ebp
  8025d8:	89 e5                	mov    %esp,%ebp
  8025da:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025dd:	6a 00                	push   $0x0
  8025df:	6a 00                	push   $0x0
  8025e1:	6a 00                	push   $0x0
  8025e3:	6a 00                	push   $0x0
  8025e5:	6a 00                	push   $0x0
  8025e7:	6a 2c                	push   $0x2c
  8025e9:	e8 19 fa ff ff       	call   802007 <syscall>
  8025ee:	83 c4 18             	add    $0x18,%esp
  8025f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8025f4:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8025f8:	75 07                	jne    802601 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8025fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8025ff:	eb 05                	jmp    802606 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802601:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802606:	c9                   	leave  
  802607:	c3                   	ret    

00802608 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802608:	55                   	push   %ebp
  802609:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80260b:	6a 00                	push   $0x0
  80260d:	6a 00                	push   $0x0
  80260f:	6a 00                	push   $0x0
  802611:	6a 00                	push   $0x0
  802613:	ff 75 08             	pushl  0x8(%ebp)
  802616:	6a 2d                	push   $0x2d
  802618:	e8 ea f9 ff ff       	call   802007 <syscall>
  80261d:	83 c4 18             	add    $0x18,%esp
	return ;
  802620:	90                   	nop
}
  802621:	c9                   	leave  
  802622:	c3                   	ret    

00802623 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802623:	55                   	push   %ebp
  802624:	89 e5                	mov    %esp,%ebp
  802626:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802627:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80262a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80262d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802630:	8b 45 08             	mov    0x8(%ebp),%eax
  802633:	6a 00                	push   $0x0
  802635:	53                   	push   %ebx
  802636:	51                   	push   %ecx
  802637:	52                   	push   %edx
  802638:	50                   	push   %eax
  802639:	6a 2e                	push   $0x2e
  80263b:	e8 c7 f9 ff ff       	call   802007 <syscall>
  802640:	83 c4 18             	add    $0x18,%esp
}
  802643:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802646:	c9                   	leave  
  802647:	c3                   	ret    

00802648 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802648:	55                   	push   %ebp
  802649:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80264b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80264e:	8b 45 08             	mov    0x8(%ebp),%eax
  802651:	6a 00                	push   $0x0
  802653:	6a 00                	push   $0x0
  802655:	6a 00                	push   $0x0
  802657:	52                   	push   %edx
  802658:	50                   	push   %eax
  802659:	6a 2f                	push   $0x2f
  80265b:	e8 a7 f9 ff ff       	call   802007 <syscall>
  802660:	83 c4 18             	add    $0x18,%esp
}
  802663:	c9                   	leave  
  802664:	c3                   	ret    

00802665 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802665:	55                   	push   %ebp
  802666:	89 e5                	mov    %esp,%ebp
  802668:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80266b:	83 ec 0c             	sub    $0xc,%esp
  80266e:	68 50 43 80 00       	push   $0x804350
  802673:	e8 d9 e4 ff ff       	call   800b51 <cprintf>
  802678:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80267b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802682:	83 ec 0c             	sub    $0xc,%esp
  802685:	68 7c 43 80 00       	push   $0x80437c
  80268a:	e8 c2 e4 ff ff       	call   800b51 <cprintf>
  80268f:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802692:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802696:	a1 38 51 80 00       	mov    0x805138,%eax
  80269b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80269e:	eb 56                	jmp    8026f6 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8026a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026a4:	74 1c                	je     8026c2 <print_mem_block_lists+0x5d>
  8026a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a9:	8b 50 08             	mov    0x8(%eax),%edx
  8026ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026af:	8b 48 08             	mov    0x8(%eax),%ecx
  8026b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8026b8:	01 c8                	add    %ecx,%eax
  8026ba:	39 c2                	cmp    %eax,%edx
  8026bc:	73 04                	jae    8026c2 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8026be:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8026c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c5:	8b 50 08             	mov    0x8(%eax),%edx
  8026c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ce:	01 c2                	add    %eax,%edx
  8026d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d3:	8b 40 08             	mov    0x8(%eax),%eax
  8026d6:	83 ec 04             	sub    $0x4,%esp
  8026d9:	52                   	push   %edx
  8026da:	50                   	push   %eax
  8026db:	68 91 43 80 00       	push   $0x804391
  8026e0:	e8 6c e4 ff ff       	call   800b51 <cprintf>
  8026e5:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8026e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026ee:	a1 40 51 80 00       	mov    0x805140,%eax
  8026f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026fa:	74 07                	je     802703 <print_mem_block_lists+0x9e>
  8026fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ff:	8b 00                	mov    (%eax),%eax
  802701:	eb 05                	jmp    802708 <print_mem_block_lists+0xa3>
  802703:	b8 00 00 00 00       	mov    $0x0,%eax
  802708:	a3 40 51 80 00       	mov    %eax,0x805140
  80270d:	a1 40 51 80 00       	mov    0x805140,%eax
  802712:	85 c0                	test   %eax,%eax
  802714:	75 8a                	jne    8026a0 <print_mem_block_lists+0x3b>
  802716:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80271a:	75 84                	jne    8026a0 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80271c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802720:	75 10                	jne    802732 <print_mem_block_lists+0xcd>
  802722:	83 ec 0c             	sub    $0xc,%esp
  802725:	68 a0 43 80 00       	push   $0x8043a0
  80272a:	e8 22 e4 ff ff       	call   800b51 <cprintf>
  80272f:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802732:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802739:	83 ec 0c             	sub    $0xc,%esp
  80273c:	68 c4 43 80 00       	push   $0x8043c4
  802741:	e8 0b e4 ff ff       	call   800b51 <cprintf>
  802746:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802749:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80274d:	a1 40 50 80 00       	mov    0x805040,%eax
  802752:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802755:	eb 56                	jmp    8027ad <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802757:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80275b:	74 1c                	je     802779 <print_mem_block_lists+0x114>
  80275d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802760:	8b 50 08             	mov    0x8(%eax),%edx
  802763:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802766:	8b 48 08             	mov    0x8(%eax),%ecx
  802769:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80276c:	8b 40 0c             	mov    0xc(%eax),%eax
  80276f:	01 c8                	add    %ecx,%eax
  802771:	39 c2                	cmp    %eax,%edx
  802773:	73 04                	jae    802779 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802775:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802779:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277c:	8b 50 08             	mov    0x8(%eax),%edx
  80277f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802782:	8b 40 0c             	mov    0xc(%eax),%eax
  802785:	01 c2                	add    %eax,%edx
  802787:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278a:	8b 40 08             	mov    0x8(%eax),%eax
  80278d:	83 ec 04             	sub    $0x4,%esp
  802790:	52                   	push   %edx
  802791:	50                   	push   %eax
  802792:	68 91 43 80 00       	push   $0x804391
  802797:	e8 b5 e3 ff ff       	call   800b51 <cprintf>
  80279c:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80279f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8027a5:	a1 48 50 80 00       	mov    0x805048,%eax
  8027aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027b1:	74 07                	je     8027ba <print_mem_block_lists+0x155>
  8027b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b6:	8b 00                	mov    (%eax),%eax
  8027b8:	eb 05                	jmp    8027bf <print_mem_block_lists+0x15a>
  8027ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8027bf:	a3 48 50 80 00       	mov    %eax,0x805048
  8027c4:	a1 48 50 80 00       	mov    0x805048,%eax
  8027c9:	85 c0                	test   %eax,%eax
  8027cb:	75 8a                	jne    802757 <print_mem_block_lists+0xf2>
  8027cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027d1:	75 84                	jne    802757 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8027d3:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8027d7:	75 10                	jne    8027e9 <print_mem_block_lists+0x184>
  8027d9:	83 ec 0c             	sub    $0xc,%esp
  8027dc:	68 dc 43 80 00       	push   $0x8043dc
  8027e1:	e8 6b e3 ff ff       	call   800b51 <cprintf>
  8027e6:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8027e9:	83 ec 0c             	sub    $0xc,%esp
  8027ec:	68 50 43 80 00       	push   $0x804350
  8027f1:	e8 5b e3 ff ff       	call   800b51 <cprintf>
  8027f6:	83 c4 10             	add    $0x10,%esp

}
  8027f9:	90                   	nop
  8027fa:	c9                   	leave  
  8027fb:	c3                   	ret    

008027fc <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8027fc:	55                   	push   %ebp
  8027fd:	89 e5                	mov    %esp,%ebp
  8027ff:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802802:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802809:	00 00 00 
  80280c:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802813:	00 00 00 
  802816:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80281d:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  802820:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802827:	e9 9e 00 00 00       	jmp    8028ca <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  80282c:	a1 50 50 80 00       	mov    0x805050,%eax
  802831:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802834:	c1 e2 04             	shl    $0x4,%edx
  802837:	01 d0                	add    %edx,%eax
  802839:	85 c0                	test   %eax,%eax
  80283b:	75 14                	jne    802851 <initialize_MemBlocksList+0x55>
  80283d:	83 ec 04             	sub    $0x4,%esp
  802840:	68 04 44 80 00       	push   $0x804404
  802845:	6a 42                	push   $0x42
  802847:	68 27 44 80 00       	push   $0x804427
  80284c:	e8 4c e0 ff ff       	call   80089d <_panic>
  802851:	a1 50 50 80 00       	mov    0x805050,%eax
  802856:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802859:	c1 e2 04             	shl    $0x4,%edx
  80285c:	01 d0                	add    %edx,%eax
  80285e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802864:	89 10                	mov    %edx,(%eax)
  802866:	8b 00                	mov    (%eax),%eax
  802868:	85 c0                	test   %eax,%eax
  80286a:	74 18                	je     802884 <initialize_MemBlocksList+0x88>
  80286c:	a1 48 51 80 00       	mov    0x805148,%eax
  802871:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802877:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80287a:	c1 e1 04             	shl    $0x4,%ecx
  80287d:	01 ca                	add    %ecx,%edx
  80287f:	89 50 04             	mov    %edx,0x4(%eax)
  802882:	eb 12                	jmp    802896 <initialize_MemBlocksList+0x9a>
  802884:	a1 50 50 80 00       	mov    0x805050,%eax
  802889:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80288c:	c1 e2 04             	shl    $0x4,%edx
  80288f:	01 d0                	add    %edx,%eax
  802891:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802896:	a1 50 50 80 00       	mov    0x805050,%eax
  80289b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80289e:	c1 e2 04             	shl    $0x4,%edx
  8028a1:	01 d0                	add    %edx,%eax
  8028a3:	a3 48 51 80 00       	mov    %eax,0x805148
  8028a8:	a1 50 50 80 00       	mov    0x805050,%eax
  8028ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028b0:	c1 e2 04             	shl    $0x4,%edx
  8028b3:	01 d0                	add    %edx,%eax
  8028b5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028bc:	a1 54 51 80 00       	mov    0x805154,%eax
  8028c1:	40                   	inc    %eax
  8028c2:	a3 54 51 80 00       	mov    %eax,0x805154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  8028c7:	ff 45 f4             	incl   -0xc(%ebp)
  8028ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028d0:	0f 82 56 ff ff ff    	jb     80282c <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  8028d6:	90                   	nop
  8028d7:	c9                   	leave  
  8028d8:	c3                   	ret    

008028d9 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8028d9:	55                   	push   %ebp
  8028da:	89 e5                	mov    %esp,%ebp
  8028dc:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  8028df:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e2:	8b 00                	mov    (%eax),%eax
  8028e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8028e7:	eb 19                	jmp    802902 <find_block+0x29>
	{
		if(blk->sva==va)
  8028e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8028ec:	8b 40 08             	mov    0x8(%eax),%eax
  8028ef:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8028f2:	75 05                	jne    8028f9 <find_block+0x20>
			return (blk);
  8028f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8028f7:	eb 36                	jmp    80292f <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  8028f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fc:	8b 40 08             	mov    0x8(%eax),%eax
  8028ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802902:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802906:	74 07                	je     80290f <find_block+0x36>
  802908:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80290b:	8b 00                	mov    (%eax),%eax
  80290d:	eb 05                	jmp    802914 <find_block+0x3b>
  80290f:	b8 00 00 00 00       	mov    $0x0,%eax
  802914:	8b 55 08             	mov    0x8(%ebp),%edx
  802917:	89 42 08             	mov    %eax,0x8(%edx)
  80291a:	8b 45 08             	mov    0x8(%ebp),%eax
  80291d:	8b 40 08             	mov    0x8(%eax),%eax
  802920:	85 c0                	test   %eax,%eax
  802922:	75 c5                	jne    8028e9 <find_block+0x10>
  802924:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802928:	75 bf                	jne    8028e9 <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  80292a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80292f:	c9                   	leave  
  802930:	c3                   	ret    

00802931 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802931:	55                   	push   %ebp
  802932:	89 e5                	mov    %esp,%ebp
  802934:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  802937:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80293c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80293f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  802946:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802949:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80294c:	75 65                	jne    8029b3 <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80294e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802952:	75 14                	jne    802968 <insert_sorted_allocList+0x37>
  802954:	83 ec 04             	sub    $0x4,%esp
  802957:	68 04 44 80 00       	push   $0x804404
  80295c:	6a 5c                	push   $0x5c
  80295e:	68 27 44 80 00       	push   $0x804427
  802963:	e8 35 df ff ff       	call   80089d <_panic>
  802968:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80296e:	8b 45 08             	mov    0x8(%ebp),%eax
  802971:	89 10                	mov    %edx,(%eax)
  802973:	8b 45 08             	mov    0x8(%ebp),%eax
  802976:	8b 00                	mov    (%eax),%eax
  802978:	85 c0                	test   %eax,%eax
  80297a:	74 0d                	je     802989 <insert_sorted_allocList+0x58>
  80297c:	a1 40 50 80 00       	mov    0x805040,%eax
  802981:	8b 55 08             	mov    0x8(%ebp),%edx
  802984:	89 50 04             	mov    %edx,0x4(%eax)
  802987:	eb 08                	jmp    802991 <insert_sorted_allocList+0x60>
  802989:	8b 45 08             	mov    0x8(%ebp),%eax
  80298c:	a3 44 50 80 00       	mov    %eax,0x805044
  802991:	8b 45 08             	mov    0x8(%ebp),%eax
  802994:	a3 40 50 80 00       	mov    %eax,0x805040
  802999:	8b 45 08             	mov    0x8(%ebp),%eax
  80299c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029a3:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029a8:	40                   	inc    %eax
  8029a9:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  8029ae:	e9 7b 01 00 00       	jmp    802b2e <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  8029b3:	a1 44 50 80 00       	mov    0x805044,%eax
  8029b8:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  8029bb:	a1 40 50 80 00       	mov    0x805040,%eax
  8029c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  8029c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c6:	8b 50 08             	mov    0x8(%eax),%edx
  8029c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029cc:	8b 40 08             	mov    0x8(%eax),%eax
  8029cf:	39 c2                	cmp    %eax,%edx
  8029d1:	76 65                	jbe    802a38 <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  8029d3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029d7:	75 14                	jne    8029ed <insert_sorted_allocList+0xbc>
  8029d9:	83 ec 04             	sub    $0x4,%esp
  8029dc:	68 40 44 80 00       	push   $0x804440
  8029e1:	6a 64                	push   $0x64
  8029e3:	68 27 44 80 00       	push   $0x804427
  8029e8:	e8 b0 de ff ff       	call   80089d <_panic>
  8029ed:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8029f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f6:	89 50 04             	mov    %edx,0x4(%eax)
  8029f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fc:	8b 40 04             	mov    0x4(%eax),%eax
  8029ff:	85 c0                	test   %eax,%eax
  802a01:	74 0c                	je     802a0f <insert_sorted_allocList+0xde>
  802a03:	a1 44 50 80 00       	mov    0x805044,%eax
  802a08:	8b 55 08             	mov    0x8(%ebp),%edx
  802a0b:	89 10                	mov    %edx,(%eax)
  802a0d:	eb 08                	jmp    802a17 <insert_sorted_allocList+0xe6>
  802a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a12:	a3 40 50 80 00       	mov    %eax,0x805040
  802a17:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1a:	a3 44 50 80 00       	mov    %eax,0x805044
  802a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a22:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a28:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a2d:	40                   	inc    %eax
  802a2e:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  802a33:	e9 f6 00 00 00       	jmp    802b2e <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  802a38:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3b:	8b 50 08             	mov    0x8(%eax),%edx
  802a3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a41:	8b 40 08             	mov    0x8(%eax),%eax
  802a44:	39 c2                	cmp    %eax,%edx
  802a46:	73 65                	jae    802aad <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802a48:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a4c:	75 14                	jne    802a62 <insert_sorted_allocList+0x131>
  802a4e:	83 ec 04             	sub    $0x4,%esp
  802a51:	68 04 44 80 00       	push   $0x804404
  802a56:	6a 68                	push   $0x68
  802a58:	68 27 44 80 00       	push   $0x804427
  802a5d:	e8 3b de ff ff       	call   80089d <_panic>
  802a62:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802a68:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6b:	89 10                	mov    %edx,(%eax)
  802a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a70:	8b 00                	mov    (%eax),%eax
  802a72:	85 c0                	test   %eax,%eax
  802a74:	74 0d                	je     802a83 <insert_sorted_allocList+0x152>
  802a76:	a1 40 50 80 00       	mov    0x805040,%eax
  802a7b:	8b 55 08             	mov    0x8(%ebp),%edx
  802a7e:	89 50 04             	mov    %edx,0x4(%eax)
  802a81:	eb 08                	jmp    802a8b <insert_sorted_allocList+0x15a>
  802a83:	8b 45 08             	mov    0x8(%ebp),%eax
  802a86:	a3 44 50 80 00       	mov    %eax,0x805044
  802a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8e:	a3 40 50 80 00       	mov    %eax,0x805040
  802a93:	8b 45 08             	mov    0x8(%ebp),%eax
  802a96:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a9d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802aa2:	40                   	inc    %eax
  802aa3:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  802aa8:	e9 81 00 00 00       	jmp    802b2e <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802aad:	a1 40 50 80 00       	mov    0x805040,%eax
  802ab2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ab5:	eb 51                	jmp    802b08 <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  802ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aba:	8b 50 08             	mov    0x8(%eax),%edx
  802abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac0:	8b 40 08             	mov    0x8(%eax),%eax
  802ac3:	39 c2                	cmp    %eax,%edx
  802ac5:	73 39                	jae    802b00 <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  802ac7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aca:	8b 40 04             	mov    0x4(%eax),%eax
  802acd:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  802ad0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ad3:	8b 55 08             	mov    0x8(%ebp),%edx
  802ad6:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  802ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  802adb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ade:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  802ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ae7:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  802ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aec:	8b 55 08             	mov    0x8(%ebp),%edx
  802aef:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  802af2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802af7:	40                   	inc    %eax
  802af8:	a3 4c 50 80 00       	mov    %eax,0x80504c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  802afd:	90                   	nop
				}
			}
		 }

	}
}
  802afe:	eb 2e                	jmp    802b2e <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802b00:	a1 48 50 80 00       	mov    0x805048,%eax
  802b05:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b0c:	74 07                	je     802b15 <insert_sorted_allocList+0x1e4>
  802b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b11:	8b 00                	mov    (%eax),%eax
  802b13:	eb 05                	jmp    802b1a <insert_sorted_allocList+0x1e9>
  802b15:	b8 00 00 00 00       	mov    $0x0,%eax
  802b1a:	a3 48 50 80 00       	mov    %eax,0x805048
  802b1f:	a1 48 50 80 00       	mov    0x805048,%eax
  802b24:	85 c0                	test   %eax,%eax
  802b26:	75 8f                	jne    802ab7 <insert_sorted_allocList+0x186>
  802b28:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b2c:	75 89                	jne    802ab7 <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  802b2e:	90                   	nop
  802b2f:	c9                   	leave  
  802b30:	c3                   	ret    

00802b31 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802b31:	55                   	push   %ebp
  802b32:	89 e5                	mov    %esp,%ebp
  802b34:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802b37:	a1 38 51 80 00       	mov    0x805138,%eax
  802b3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b3f:	e9 76 01 00 00       	jmp    802cba <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  802b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b47:	8b 40 0c             	mov    0xc(%eax),%eax
  802b4a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b4d:	0f 85 8a 00 00 00    	jne    802bdd <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  802b53:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b57:	75 17                	jne    802b70 <alloc_block_FF+0x3f>
  802b59:	83 ec 04             	sub    $0x4,%esp
  802b5c:	68 63 44 80 00       	push   $0x804463
  802b61:	68 8a 00 00 00       	push   $0x8a
  802b66:	68 27 44 80 00       	push   $0x804427
  802b6b:	e8 2d dd ff ff       	call   80089d <_panic>
  802b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b73:	8b 00                	mov    (%eax),%eax
  802b75:	85 c0                	test   %eax,%eax
  802b77:	74 10                	je     802b89 <alloc_block_FF+0x58>
  802b79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7c:	8b 00                	mov    (%eax),%eax
  802b7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b81:	8b 52 04             	mov    0x4(%edx),%edx
  802b84:	89 50 04             	mov    %edx,0x4(%eax)
  802b87:	eb 0b                	jmp    802b94 <alloc_block_FF+0x63>
  802b89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8c:	8b 40 04             	mov    0x4(%eax),%eax
  802b8f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b97:	8b 40 04             	mov    0x4(%eax),%eax
  802b9a:	85 c0                	test   %eax,%eax
  802b9c:	74 0f                	je     802bad <alloc_block_FF+0x7c>
  802b9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba1:	8b 40 04             	mov    0x4(%eax),%eax
  802ba4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ba7:	8b 12                	mov    (%edx),%edx
  802ba9:	89 10                	mov    %edx,(%eax)
  802bab:	eb 0a                	jmp    802bb7 <alloc_block_FF+0x86>
  802bad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb0:	8b 00                	mov    (%eax),%eax
  802bb2:	a3 38 51 80 00       	mov    %eax,0x805138
  802bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bca:	a1 44 51 80 00       	mov    0x805144,%eax
  802bcf:	48                   	dec    %eax
  802bd0:	a3 44 51 80 00       	mov    %eax,0x805144
			return element;
  802bd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd8:	e9 10 01 00 00       	jmp    802ced <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  802bdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be0:	8b 40 0c             	mov    0xc(%eax),%eax
  802be3:	3b 45 08             	cmp    0x8(%ebp),%eax
  802be6:	0f 86 c6 00 00 00    	jbe    802cb2 <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802bec:	a1 48 51 80 00       	mov    0x805148,%eax
  802bf1:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802bf4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bf8:	75 17                	jne    802c11 <alloc_block_FF+0xe0>
  802bfa:	83 ec 04             	sub    $0x4,%esp
  802bfd:	68 63 44 80 00       	push   $0x804463
  802c02:	68 90 00 00 00       	push   $0x90
  802c07:	68 27 44 80 00       	push   $0x804427
  802c0c:	e8 8c dc ff ff       	call   80089d <_panic>
  802c11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c14:	8b 00                	mov    (%eax),%eax
  802c16:	85 c0                	test   %eax,%eax
  802c18:	74 10                	je     802c2a <alloc_block_FF+0xf9>
  802c1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1d:	8b 00                	mov    (%eax),%eax
  802c1f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c22:	8b 52 04             	mov    0x4(%edx),%edx
  802c25:	89 50 04             	mov    %edx,0x4(%eax)
  802c28:	eb 0b                	jmp    802c35 <alloc_block_FF+0x104>
  802c2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2d:	8b 40 04             	mov    0x4(%eax),%eax
  802c30:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c38:	8b 40 04             	mov    0x4(%eax),%eax
  802c3b:	85 c0                	test   %eax,%eax
  802c3d:	74 0f                	je     802c4e <alloc_block_FF+0x11d>
  802c3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c42:	8b 40 04             	mov    0x4(%eax),%eax
  802c45:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c48:	8b 12                	mov    (%edx),%edx
  802c4a:	89 10                	mov    %edx,(%eax)
  802c4c:	eb 0a                	jmp    802c58 <alloc_block_FF+0x127>
  802c4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c51:	8b 00                	mov    (%eax),%eax
  802c53:	a3 48 51 80 00       	mov    %eax,0x805148
  802c58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c5b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c64:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c6b:	a1 54 51 80 00       	mov    0x805154,%eax
  802c70:	48                   	dec    %eax
  802c71:	a3 54 51 80 00       	mov    %eax,0x805154
			 element1->size =size;
  802c76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c79:	8b 55 08             	mov    0x8(%ebp),%edx
  802c7c:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  802c7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c82:	8b 50 08             	mov    0x8(%eax),%edx
  802c85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c88:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  802c8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8e:	8b 50 08             	mov    0x8(%eax),%edx
  802c91:	8b 45 08             	mov    0x8(%ebp),%eax
  802c94:	01 c2                	add    %eax,%edx
  802c96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c99:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  802c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9f:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca2:	2b 45 08             	sub    0x8(%ebp),%eax
  802ca5:	89 c2                	mov    %eax,%edx
  802ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802caa:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  802cad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb0:	eb 3b                	jmp    802ced <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802cb2:	a1 40 51 80 00       	mov    0x805140,%eax
  802cb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cbe:	74 07                	je     802cc7 <alloc_block_FF+0x196>
  802cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc3:	8b 00                	mov    (%eax),%eax
  802cc5:	eb 05                	jmp    802ccc <alloc_block_FF+0x19b>
  802cc7:	b8 00 00 00 00       	mov    $0x0,%eax
  802ccc:	a3 40 51 80 00       	mov    %eax,0x805140
  802cd1:	a1 40 51 80 00       	mov    0x805140,%eax
  802cd6:	85 c0                	test   %eax,%eax
  802cd8:	0f 85 66 fe ff ff    	jne    802b44 <alloc_block_FF+0x13>
  802cde:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ce2:	0f 85 5c fe ff ff    	jne    802b44 <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  802ce8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ced:	c9                   	leave  
  802cee:	c3                   	ret    

00802cef <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802cef:	55                   	push   %ebp
  802cf0:	89 e5                	mov    %esp,%ebp
  802cf2:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  802cf5:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  802cfc:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  802d03:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802d0a:	a1 38 51 80 00       	mov    0x805138,%eax
  802d0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d12:	e9 cf 00 00 00       	jmp    802de6 <alloc_block_BF+0xf7>
		{
			c++;
  802d17:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  802d1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1d:	8b 40 0c             	mov    0xc(%eax),%eax
  802d20:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d23:	0f 85 8a 00 00 00    	jne    802db3 <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  802d29:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d2d:	75 17                	jne    802d46 <alloc_block_BF+0x57>
  802d2f:	83 ec 04             	sub    $0x4,%esp
  802d32:	68 63 44 80 00       	push   $0x804463
  802d37:	68 a8 00 00 00       	push   $0xa8
  802d3c:	68 27 44 80 00       	push   $0x804427
  802d41:	e8 57 db ff ff       	call   80089d <_panic>
  802d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d49:	8b 00                	mov    (%eax),%eax
  802d4b:	85 c0                	test   %eax,%eax
  802d4d:	74 10                	je     802d5f <alloc_block_BF+0x70>
  802d4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d52:	8b 00                	mov    (%eax),%eax
  802d54:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d57:	8b 52 04             	mov    0x4(%edx),%edx
  802d5a:	89 50 04             	mov    %edx,0x4(%eax)
  802d5d:	eb 0b                	jmp    802d6a <alloc_block_BF+0x7b>
  802d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d62:	8b 40 04             	mov    0x4(%eax),%eax
  802d65:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6d:	8b 40 04             	mov    0x4(%eax),%eax
  802d70:	85 c0                	test   %eax,%eax
  802d72:	74 0f                	je     802d83 <alloc_block_BF+0x94>
  802d74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d77:	8b 40 04             	mov    0x4(%eax),%eax
  802d7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d7d:	8b 12                	mov    (%edx),%edx
  802d7f:	89 10                	mov    %edx,(%eax)
  802d81:	eb 0a                	jmp    802d8d <alloc_block_BF+0x9e>
  802d83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d86:	8b 00                	mov    (%eax),%eax
  802d88:	a3 38 51 80 00       	mov    %eax,0x805138
  802d8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d90:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d99:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802da0:	a1 44 51 80 00       	mov    0x805144,%eax
  802da5:	48                   	dec    %eax
  802da6:	a3 44 51 80 00       	mov    %eax,0x805144
				return block;
  802dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dae:	e9 85 01 00 00       	jmp    802f38 <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  802db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db6:	8b 40 0c             	mov    0xc(%eax),%eax
  802db9:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dbc:	76 20                	jbe    802dde <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  802dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc1:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc4:	2b 45 08             	sub    0x8(%ebp),%eax
  802dc7:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  802dca:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dcd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802dd0:	73 0c                	jae    802dde <alloc_block_BF+0xef>
				{
					ma=tempi;
  802dd2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802dd5:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  802dd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ddb:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802dde:	a1 40 51 80 00       	mov    0x805140,%eax
  802de3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802de6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dea:	74 07                	je     802df3 <alloc_block_BF+0x104>
  802dec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802def:	8b 00                	mov    (%eax),%eax
  802df1:	eb 05                	jmp    802df8 <alloc_block_BF+0x109>
  802df3:	b8 00 00 00 00       	mov    $0x0,%eax
  802df8:	a3 40 51 80 00       	mov    %eax,0x805140
  802dfd:	a1 40 51 80 00       	mov    0x805140,%eax
  802e02:	85 c0                	test   %eax,%eax
  802e04:	0f 85 0d ff ff ff    	jne    802d17 <alloc_block_BF+0x28>
  802e0a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e0e:	0f 85 03 ff ff ff    	jne    802d17 <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  802e14:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802e1b:	a1 38 51 80 00       	mov    0x805138,%eax
  802e20:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e23:	e9 dd 00 00 00       	jmp    802f05 <alloc_block_BF+0x216>
		{
			if(x==sol)
  802e28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e2b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802e2e:	0f 85 c6 00 00 00    	jne    802efa <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802e34:	a1 48 51 80 00       	mov    0x805148,%eax
  802e39:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802e3c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802e40:	75 17                	jne    802e59 <alloc_block_BF+0x16a>
  802e42:	83 ec 04             	sub    $0x4,%esp
  802e45:	68 63 44 80 00       	push   $0x804463
  802e4a:	68 bb 00 00 00       	push   $0xbb
  802e4f:	68 27 44 80 00       	push   $0x804427
  802e54:	e8 44 da ff ff       	call   80089d <_panic>
  802e59:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e5c:	8b 00                	mov    (%eax),%eax
  802e5e:	85 c0                	test   %eax,%eax
  802e60:	74 10                	je     802e72 <alloc_block_BF+0x183>
  802e62:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e65:	8b 00                	mov    (%eax),%eax
  802e67:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e6a:	8b 52 04             	mov    0x4(%edx),%edx
  802e6d:	89 50 04             	mov    %edx,0x4(%eax)
  802e70:	eb 0b                	jmp    802e7d <alloc_block_BF+0x18e>
  802e72:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e75:	8b 40 04             	mov    0x4(%eax),%eax
  802e78:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e80:	8b 40 04             	mov    0x4(%eax),%eax
  802e83:	85 c0                	test   %eax,%eax
  802e85:	74 0f                	je     802e96 <alloc_block_BF+0x1a7>
  802e87:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e8a:	8b 40 04             	mov    0x4(%eax),%eax
  802e8d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802e90:	8b 12                	mov    (%edx),%edx
  802e92:	89 10                	mov    %edx,(%eax)
  802e94:	eb 0a                	jmp    802ea0 <alloc_block_BF+0x1b1>
  802e96:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e99:	8b 00                	mov    (%eax),%eax
  802e9b:	a3 48 51 80 00       	mov    %eax,0x805148
  802ea0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ea3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ea9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802eac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eb3:	a1 54 51 80 00       	mov    0x805154,%eax
  802eb8:	48                   	dec    %eax
  802eb9:	a3 54 51 80 00       	mov    %eax,0x805154
						 element1->size =size;
  802ebe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ec1:	8b 55 08             	mov    0x8(%ebp),%edx
  802ec4:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  802ec7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eca:	8b 50 08             	mov    0x8(%eax),%edx
  802ecd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ed0:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  802ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed6:	8b 50 08             	mov    0x8(%eax),%edx
  802ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  802edc:	01 c2                	add    %eax,%edx
  802ede:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee1:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  802ee4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee7:	8b 40 0c             	mov    0xc(%eax),%eax
  802eea:	2b 45 08             	sub    0x8(%ebp),%eax
  802eed:	89 c2                	mov    %eax,%edx
  802eef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef2:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  802ef5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ef8:	eb 3e                	jmp    802f38 <alloc_block_BF+0x249>
						 break;
			}
			x++;
  802efa:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802efd:	a1 40 51 80 00       	mov    0x805140,%eax
  802f02:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f05:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f09:	74 07                	je     802f12 <alloc_block_BF+0x223>
  802f0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0e:	8b 00                	mov    (%eax),%eax
  802f10:	eb 05                	jmp    802f17 <alloc_block_BF+0x228>
  802f12:	b8 00 00 00 00       	mov    $0x0,%eax
  802f17:	a3 40 51 80 00       	mov    %eax,0x805140
  802f1c:	a1 40 51 80 00       	mov    0x805140,%eax
  802f21:	85 c0                	test   %eax,%eax
  802f23:	0f 85 ff fe ff ff    	jne    802e28 <alloc_block_BF+0x139>
  802f29:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f2d:	0f 85 f5 fe ff ff    	jne    802e28 <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  802f33:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f38:	c9                   	leave  
  802f39:	c3                   	ret    

00802f3a <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802f3a:	55                   	push   %ebp
  802f3b:	89 e5                	mov    %esp,%ebp
  802f3d:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  802f40:	a1 28 50 80 00       	mov    0x805028,%eax
  802f45:	85 c0                	test   %eax,%eax
  802f47:	75 14                	jne    802f5d <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  802f49:	a1 38 51 80 00       	mov    0x805138,%eax
  802f4e:	a3 60 51 80 00       	mov    %eax,0x805160
		hh=1;
  802f53:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  802f5a:	00 00 00 
	}
	uint32 c=1;
  802f5d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  802f64:	a1 60 51 80 00       	mov    0x805160,%eax
  802f69:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802f6c:	e9 b3 01 00 00       	jmp    803124 <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  802f71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f74:	8b 40 0c             	mov    0xc(%eax),%eax
  802f77:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f7a:	0f 85 a9 00 00 00    	jne    803029 <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  802f80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f83:	8b 00                	mov    (%eax),%eax
  802f85:	85 c0                	test   %eax,%eax
  802f87:	75 0c                	jne    802f95 <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  802f89:	a1 38 51 80 00       	mov    0x805138,%eax
  802f8e:	a3 60 51 80 00       	mov    %eax,0x805160
  802f93:	eb 0a                	jmp    802f9f <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  802f95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f98:	8b 00                	mov    (%eax),%eax
  802f9a:	a3 60 51 80 00       	mov    %eax,0x805160
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  802f9f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fa3:	75 17                	jne    802fbc <alloc_block_NF+0x82>
  802fa5:	83 ec 04             	sub    $0x4,%esp
  802fa8:	68 63 44 80 00       	push   $0x804463
  802fad:	68 e3 00 00 00       	push   $0xe3
  802fb2:	68 27 44 80 00       	push   $0x804427
  802fb7:	e8 e1 d8 ff ff       	call   80089d <_panic>
  802fbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fbf:	8b 00                	mov    (%eax),%eax
  802fc1:	85 c0                	test   %eax,%eax
  802fc3:	74 10                	je     802fd5 <alloc_block_NF+0x9b>
  802fc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc8:	8b 00                	mov    (%eax),%eax
  802fca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802fcd:	8b 52 04             	mov    0x4(%edx),%edx
  802fd0:	89 50 04             	mov    %edx,0x4(%eax)
  802fd3:	eb 0b                	jmp    802fe0 <alloc_block_NF+0xa6>
  802fd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fd8:	8b 40 04             	mov    0x4(%eax),%eax
  802fdb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fe0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe3:	8b 40 04             	mov    0x4(%eax),%eax
  802fe6:	85 c0                	test   %eax,%eax
  802fe8:	74 0f                	je     802ff9 <alloc_block_NF+0xbf>
  802fea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fed:	8b 40 04             	mov    0x4(%eax),%eax
  802ff0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ff3:	8b 12                	mov    (%edx),%edx
  802ff5:	89 10                	mov    %edx,(%eax)
  802ff7:	eb 0a                	jmp    803003 <alloc_block_NF+0xc9>
  802ff9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ffc:	8b 00                	mov    (%eax),%eax
  802ffe:	a3 38 51 80 00       	mov    %eax,0x805138
  803003:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803006:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80300c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80300f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803016:	a1 44 51 80 00       	mov    0x805144,%eax
  80301b:	48                   	dec    %eax
  80301c:	a3 44 51 80 00       	mov    %eax,0x805144
				return element;
  803021:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803024:	e9 0e 01 00 00       	jmp    803137 <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  803029:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80302c:	8b 40 0c             	mov    0xc(%eax),%eax
  80302f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803032:	0f 86 ce 00 00 00    	jbe    803106 <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  803038:	a1 48 51 80 00       	mov    0x805148,%eax
  80303d:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  803040:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803044:	75 17                	jne    80305d <alloc_block_NF+0x123>
  803046:	83 ec 04             	sub    $0x4,%esp
  803049:	68 63 44 80 00       	push   $0x804463
  80304e:	68 e9 00 00 00       	push   $0xe9
  803053:	68 27 44 80 00       	push   $0x804427
  803058:	e8 40 d8 ff ff       	call   80089d <_panic>
  80305d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803060:	8b 00                	mov    (%eax),%eax
  803062:	85 c0                	test   %eax,%eax
  803064:	74 10                	je     803076 <alloc_block_NF+0x13c>
  803066:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803069:	8b 00                	mov    (%eax),%eax
  80306b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80306e:	8b 52 04             	mov    0x4(%edx),%edx
  803071:	89 50 04             	mov    %edx,0x4(%eax)
  803074:	eb 0b                	jmp    803081 <alloc_block_NF+0x147>
  803076:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803079:	8b 40 04             	mov    0x4(%eax),%eax
  80307c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803081:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803084:	8b 40 04             	mov    0x4(%eax),%eax
  803087:	85 c0                	test   %eax,%eax
  803089:	74 0f                	je     80309a <alloc_block_NF+0x160>
  80308b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80308e:	8b 40 04             	mov    0x4(%eax),%eax
  803091:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803094:	8b 12                	mov    (%edx),%edx
  803096:	89 10                	mov    %edx,(%eax)
  803098:	eb 0a                	jmp    8030a4 <alloc_block_NF+0x16a>
  80309a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80309d:	8b 00                	mov    (%eax),%eax
  80309f:	a3 48 51 80 00       	mov    %eax,0x805148
  8030a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030b7:	a1 54 51 80 00       	mov    0x805154,%eax
  8030bc:	48                   	dec    %eax
  8030bd:	a3 54 51 80 00       	mov    %eax,0x805154
				 element1->size =size;
  8030c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8030c8:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  8030cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ce:	8b 50 08             	mov    0x8(%eax),%edx
  8030d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030d4:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  8030d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030da:	8b 50 08             	mov    0x8(%eax),%edx
  8030dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e0:	01 c2                	add    %eax,%edx
  8030e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e5:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  8030e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8030ee:	2b 45 08             	sub    0x8(%ebp),%eax
  8030f1:	89 c2                	mov    %eax,%edx
  8030f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f6:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  8030f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030fc:	a3 60 51 80 00       	mov    %eax,0x805160
				 return element1;
  803101:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803104:	eb 31                	jmp    803137 <alloc_block_NF+0x1fd>
			 }
		 c++;
  803106:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  803109:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80310c:	8b 00                	mov    (%eax),%eax
  80310e:	85 c0                	test   %eax,%eax
  803110:	75 0a                	jne    80311c <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  803112:	a1 38 51 80 00       	mov    0x805138,%eax
  803117:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80311a:	eb 08                	jmp    803124 <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  80311c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80311f:	8b 00                	mov    (%eax),%eax
  803121:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  803124:	a1 44 51 80 00       	mov    0x805144,%eax
  803129:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80312c:	0f 85 3f fe ff ff    	jne    802f71 <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  803132:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803137:	c9                   	leave  
  803138:	c3                   	ret    

00803139 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803139:	55                   	push   %ebp
  80313a:	89 e5                	mov    %esp,%ebp
  80313c:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  80313f:	a1 44 51 80 00       	mov    0x805144,%eax
  803144:	85 c0                	test   %eax,%eax
  803146:	75 68                	jne    8031b0 <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  803148:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80314c:	75 17                	jne    803165 <insert_sorted_with_merge_freeList+0x2c>
  80314e:	83 ec 04             	sub    $0x4,%esp
  803151:	68 04 44 80 00       	push   $0x804404
  803156:	68 0e 01 00 00       	push   $0x10e
  80315b:	68 27 44 80 00       	push   $0x804427
  803160:	e8 38 d7 ff ff       	call   80089d <_panic>
  803165:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80316b:	8b 45 08             	mov    0x8(%ebp),%eax
  80316e:	89 10                	mov    %edx,(%eax)
  803170:	8b 45 08             	mov    0x8(%ebp),%eax
  803173:	8b 00                	mov    (%eax),%eax
  803175:	85 c0                	test   %eax,%eax
  803177:	74 0d                	je     803186 <insert_sorted_with_merge_freeList+0x4d>
  803179:	a1 38 51 80 00       	mov    0x805138,%eax
  80317e:	8b 55 08             	mov    0x8(%ebp),%edx
  803181:	89 50 04             	mov    %edx,0x4(%eax)
  803184:	eb 08                	jmp    80318e <insert_sorted_with_merge_freeList+0x55>
  803186:	8b 45 08             	mov    0x8(%ebp),%eax
  803189:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80318e:	8b 45 08             	mov    0x8(%ebp),%eax
  803191:	a3 38 51 80 00       	mov    %eax,0x805138
  803196:	8b 45 08             	mov    0x8(%ebp),%eax
  803199:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031a0:	a1 44 51 80 00       	mov    0x805144,%eax
  8031a5:	40                   	inc    %eax
  8031a6:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  8031ab:	e9 8c 06 00 00       	jmp    80383c <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  8031b0:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8031b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  8031b8:	a1 38 51 80 00       	mov    0x805138,%eax
  8031bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  8031c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c3:	8b 50 08             	mov    0x8(%eax),%edx
  8031c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c9:	8b 40 08             	mov    0x8(%eax),%eax
  8031cc:	39 c2                	cmp    %eax,%edx
  8031ce:	0f 86 14 01 00 00    	jbe    8032e8 <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  8031d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d7:	8b 50 0c             	mov    0xc(%eax),%edx
  8031da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031dd:	8b 40 08             	mov    0x8(%eax),%eax
  8031e0:	01 c2                	add    %eax,%edx
  8031e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e5:	8b 40 08             	mov    0x8(%eax),%eax
  8031e8:	39 c2                	cmp    %eax,%edx
  8031ea:	0f 85 90 00 00 00    	jne    803280 <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  8031f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f3:	8b 50 0c             	mov    0xc(%eax),%edx
  8031f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8031fc:	01 c2                	add    %eax,%edx
  8031fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803201:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  803204:	8b 45 08             	mov    0x8(%ebp),%eax
  803207:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  80320e:	8b 45 08             	mov    0x8(%ebp),%eax
  803211:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803218:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80321c:	75 17                	jne    803235 <insert_sorted_with_merge_freeList+0xfc>
  80321e:	83 ec 04             	sub    $0x4,%esp
  803221:	68 04 44 80 00       	push   $0x804404
  803226:	68 1b 01 00 00       	push   $0x11b
  80322b:	68 27 44 80 00       	push   $0x804427
  803230:	e8 68 d6 ff ff       	call   80089d <_panic>
  803235:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80323b:	8b 45 08             	mov    0x8(%ebp),%eax
  80323e:	89 10                	mov    %edx,(%eax)
  803240:	8b 45 08             	mov    0x8(%ebp),%eax
  803243:	8b 00                	mov    (%eax),%eax
  803245:	85 c0                	test   %eax,%eax
  803247:	74 0d                	je     803256 <insert_sorted_with_merge_freeList+0x11d>
  803249:	a1 48 51 80 00       	mov    0x805148,%eax
  80324e:	8b 55 08             	mov    0x8(%ebp),%edx
  803251:	89 50 04             	mov    %edx,0x4(%eax)
  803254:	eb 08                	jmp    80325e <insert_sorted_with_merge_freeList+0x125>
  803256:	8b 45 08             	mov    0x8(%ebp),%eax
  803259:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80325e:	8b 45 08             	mov    0x8(%ebp),%eax
  803261:	a3 48 51 80 00       	mov    %eax,0x805148
  803266:	8b 45 08             	mov    0x8(%ebp),%eax
  803269:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803270:	a1 54 51 80 00       	mov    0x805154,%eax
  803275:	40                   	inc    %eax
  803276:	a3 54 51 80 00       	mov    %eax,0x805154
							}

						}
		          }
		}
}
  80327b:	e9 bc 05 00 00       	jmp    80383c <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803280:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803284:	75 17                	jne    80329d <insert_sorted_with_merge_freeList+0x164>
  803286:	83 ec 04             	sub    $0x4,%esp
  803289:	68 40 44 80 00       	push   $0x804440
  80328e:	68 1f 01 00 00       	push   $0x11f
  803293:	68 27 44 80 00       	push   $0x804427
  803298:	e8 00 d6 ff ff       	call   80089d <_panic>
  80329d:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8032a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a6:	89 50 04             	mov    %edx,0x4(%eax)
  8032a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ac:	8b 40 04             	mov    0x4(%eax),%eax
  8032af:	85 c0                	test   %eax,%eax
  8032b1:	74 0c                	je     8032bf <insert_sorted_with_merge_freeList+0x186>
  8032b3:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8032b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8032bb:	89 10                	mov    %edx,(%eax)
  8032bd:	eb 08                	jmp    8032c7 <insert_sorted_with_merge_freeList+0x18e>
  8032bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c2:	a3 38 51 80 00       	mov    %eax,0x805138
  8032c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ca:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032d8:	a1 44 51 80 00       	mov    0x805144,%eax
  8032dd:	40                   	inc    %eax
  8032de:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  8032e3:	e9 54 05 00 00       	jmp    80383c <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  8032e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032eb:	8b 50 08             	mov    0x8(%eax),%edx
  8032ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032f1:	8b 40 08             	mov    0x8(%eax),%eax
  8032f4:	39 c2                	cmp    %eax,%edx
  8032f6:	0f 83 20 01 00 00    	jae    80341c <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  8032fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ff:	8b 50 0c             	mov    0xc(%eax),%edx
  803302:	8b 45 08             	mov    0x8(%ebp),%eax
  803305:	8b 40 08             	mov    0x8(%eax),%eax
  803308:	01 c2                	add    %eax,%edx
  80330a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80330d:	8b 40 08             	mov    0x8(%eax),%eax
  803310:	39 c2                	cmp    %eax,%edx
  803312:	0f 85 9c 00 00 00    	jne    8033b4 <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  803318:	8b 45 08             	mov    0x8(%ebp),%eax
  80331b:	8b 50 08             	mov    0x8(%eax),%edx
  80331e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803321:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  803324:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803327:	8b 50 0c             	mov    0xc(%eax),%edx
  80332a:	8b 45 08             	mov    0x8(%ebp),%eax
  80332d:	8b 40 0c             	mov    0xc(%eax),%eax
  803330:	01 c2                	add    %eax,%edx
  803332:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803335:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  803338:	8b 45 08             	mov    0x8(%ebp),%eax
  80333b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  803342:	8b 45 08             	mov    0x8(%ebp),%eax
  803345:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80334c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803350:	75 17                	jne    803369 <insert_sorted_with_merge_freeList+0x230>
  803352:	83 ec 04             	sub    $0x4,%esp
  803355:	68 04 44 80 00       	push   $0x804404
  80335a:	68 2a 01 00 00       	push   $0x12a
  80335f:	68 27 44 80 00       	push   $0x804427
  803364:	e8 34 d5 ff ff       	call   80089d <_panic>
  803369:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80336f:	8b 45 08             	mov    0x8(%ebp),%eax
  803372:	89 10                	mov    %edx,(%eax)
  803374:	8b 45 08             	mov    0x8(%ebp),%eax
  803377:	8b 00                	mov    (%eax),%eax
  803379:	85 c0                	test   %eax,%eax
  80337b:	74 0d                	je     80338a <insert_sorted_with_merge_freeList+0x251>
  80337d:	a1 48 51 80 00       	mov    0x805148,%eax
  803382:	8b 55 08             	mov    0x8(%ebp),%edx
  803385:	89 50 04             	mov    %edx,0x4(%eax)
  803388:	eb 08                	jmp    803392 <insert_sorted_with_merge_freeList+0x259>
  80338a:	8b 45 08             	mov    0x8(%ebp),%eax
  80338d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803392:	8b 45 08             	mov    0x8(%ebp),%eax
  803395:	a3 48 51 80 00       	mov    %eax,0x805148
  80339a:	8b 45 08             	mov    0x8(%ebp),%eax
  80339d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033a4:	a1 54 51 80 00       	mov    0x805154,%eax
  8033a9:	40                   	inc    %eax
  8033aa:	a3 54 51 80 00       	mov    %eax,0x805154
							}

						}
		          }
		}
}
  8033af:	e9 88 04 00 00       	jmp    80383c <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8033b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033b8:	75 17                	jne    8033d1 <insert_sorted_with_merge_freeList+0x298>
  8033ba:	83 ec 04             	sub    $0x4,%esp
  8033bd:	68 04 44 80 00       	push   $0x804404
  8033c2:	68 2e 01 00 00       	push   $0x12e
  8033c7:	68 27 44 80 00       	push   $0x804427
  8033cc:	e8 cc d4 ff ff       	call   80089d <_panic>
  8033d1:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8033d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033da:	89 10                	mov    %edx,(%eax)
  8033dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033df:	8b 00                	mov    (%eax),%eax
  8033e1:	85 c0                	test   %eax,%eax
  8033e3:	74 0d                	je     8033f2 <insert_sorted_with_merge_freeList+0x2b9>
  8033e5:	a1 38 51 80 00       	mov    0x805138,%eax
  8033ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8033ed:	89 50 04             	mov    %edx,0x4(%eax)
  8033f0:	eb 08                	jmp    8033fa <insert_sorted_with_merge_freeList+0x2c1>
  8033f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fd:	a3 38 51 80 00       	mov    %eax,0x805138
  803402:	8b 45 08             	mov    0x8(%ebp),%eax
  803405:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80340c:	a1 44 51 80 00       	mov    0x805144,%eax
  803411:	40                   	inc    %eax
  803412:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  803417:	e9 20 04 00 00       	jmp    80383c <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  80341c:	a1 38 51 80 00       	mov    0x805138,%eax
  803421:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803424:	e9 e2 03 00 00       	jmp    80380b <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  803429:	8b 45 08             	mov    0x8(%ebp),%eax
  80342c:	8b 50 08             	mov    0x8(%eax),%edx
  80342f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803432:	8b 40 08             	mov    0x8(%eax),%eax
  803435:	39 c2                	cmp    %eax,%edx
  803437:	0f 83 c6 03 00 00    	jae    803803 <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  80343d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803440:	8b 40 04             	mov    0x4(%eax),%eax
  803443:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  803446:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803449:	8b 50 08             	mov    0x8(%eax),%edx
  80344c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80344f:	8b 40 0c             	mov    0xc(%eax),%eax
  803452:	01 d0                	add    %edx,%eax
  803454:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  803457:	8b 45 08             	mov    0x8(%ebp),%eax
  80345a:	8b 50 0c             	mov    0xc(%eax),%edx
  80345d:	8b 45 08             	mov    0x8(%ebp),%eax
  803460:	8b 40 08             	mov    0x8(%eax),%eax
  803463:	01 d0                	add    %edx,%eax
  803465:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  803468:	8b 45 08             	mov    0x8(%ebp),%eax
  80346b:	8b 40 08             	mov    0x8(%eax),%eax
  80346e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803471:	74 7a                	je     8034ed <insert_sorted_with_merge_freeList+0x3b4>
  803473:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803476:	8b 40 08             	mov    0x8(%eax),%eax
  803479:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80347c:	74 6f                	je     8034ed <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  80347e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803482:	74 06                	je     80348a <insert_sorted_with_merge_freeList+0x351>
  803484:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803488:	75 17                	jne    8034a1 <insert_sorted_with_merge_freeList+0x368>
  80348a:	83 ec 04             	sub    $0x4,%esp
  80348d:	68 84 44 80 00       	push   $0x804484
  803492:	68 43 01 00 00       	push   $0x143
  803497:	68 27 44 80 00       	push   $0x804427
  80349c:	e8 fc d3 ff ff       	call   80089d <_panic>
  8034a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a4:	8b 50 04             	mov    0x4(%eax),%edx
  8034a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034aa:	89 50 04             	mov    %edx,0x4(%eax)
  8034ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034b3:	89 10                	mov    %edx,(%eax)
  8034b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b8:	8b 40 04             	mov    0x4(%eax),%eax
  8034bb:	85 c0                	test   %eax,%eax
  8034bd:	74 0d                	je     8034cc <insert_sorted_with_merge_freeList+0x393>
  8034bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c2:	8b 40 04             	mov    0x4(%eax),%eax
  8034c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8034c8:	89 10                	mov    %edx,(%eax)
  8034ca:	eb 08                	jmp    8034d4 <insert_sorted_with_merge_freeList+0x39b>
  8034cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8034cf:	a3 38 51 80 00       	mov    %eax,0x805138
  8034d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8034da:	89 50 04             	mov    %edx,0x4(%eax)
  8034dd:	a1 44 51 80 00       	mov    0x805144,%eax
  8034e2:	40                   	inc    %eax
  8034e3:	a3 44 51 80 00       	mov    %eax,0x805144
  8034e8:	e9 14 03 00 00       	jmp    803801 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  8034ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f0:	8b 40 08             	mov    0x8(%eax),%eax
  8034f3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8034f6:	0f 85 a0 01 00 00    	jne    80369c <insert_sorted_with_merge_freeList+0x563>
  8034fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ff:	8b 40 08             	mov    0x8(%eax),%eax
  803502:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803505:	0f 85 91 01 00 00    	jne    80369c <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  80350b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80350e:	8b 50 0c             	mov    0xc(%eax),%edx
  803511:	8b 45 08             	mov    0x8(%ebp),%eax
  803514:	8b 48 0c             	mov    0xc(%eax),%ecx
  803517:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80351a:	8b 40 0c             	mov    0xc(%eax),%eax
  80351d:	01 c8                	add    %ecx,%eax
  80351f:	01 c2                	add    %eax,%edx
  803521:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803524:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  803527:	8b 45 08             	mov    0x8(%ebp),%eax
  80352a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  803531:	8b 45 08             	mov    0x8(%ebp),%eax
  803534:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  80353b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80353e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  803545:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803548:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80354f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803553:	75 17                	jne    80356c <insert_sorted_with_merge_freeList+0x433>
  803555:	83 ec 04             	sub    $0x4,%esp
  803558:	68 04 44 80 00       	push   $0x804404
  80355d:	68 4d 01 00 00       	push   $0x14d
  803562:	68 27 44 80 00       	push   $0x804427
  803567:	e8 31 d3 ff ff       	call   80089d <_panic>
  80356c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803572:	8b 45 08             	mov    0x8(%ebp),%eax
  803575:	89 10                	mov    %edx,(%eax)
  803577:	8b 45 08             	mov    0x8(%ebp),%eax
  80357a:	8b 00                	mov    (%eax),%eax
  80357c:	85 c0                	test   %eax,%eax
  80357e:	74 0d                	je     80358d <insert_sorted_with_merge_freeList+0x454>
  803580:	a1 48 51 80 00       	mov    0x805148,%eax
  803585:	8b 55 08             	mov    0x8(%ebp),%edx
  803588:	89 50 04             	mov    %edx,0x4(%eax)
  80358b:	eb 08                	jmp    803595 <insert_sorted_with_merge_freeList+0x45c>
  80358d:	8b 45 08             	mov    0x8(%ebp),%eax
  803590:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803595:	8b 45 08             	mov    0x8(%ebp),%eax
  803598:	a3 48 51 80 00       	mov    %eax,0x805148
  80359d:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035a7:	a1 54 51 80 00       	mov    0x805154,%eax
  8035ac:	40                   	inc    %eax
  8035ad:	a3 54 51 80 00       	mov    %eax,0x805154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  8035b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035b6:	75 17                	jne    8035cf <insert_sorted_with_merge_freeList+0x496>
  8035b8:	83 ec 04             	sub    $0x4,%esp
  8035bb:	68 63 44 80 00       	push   $0x804463
  8035c0:	68 4e 01 00 00       	push   $0x14e
  8035c5:	68 27 44 80 00       	push   $0x804427
  8035ca:	e8 ce d2 ff ff       	call   80089d <_panic>
  8035cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d2:	8b 00                	mov    (%eax),%eax
  8035d4:	85 c0                	test   %eax,%eax
  8035d6:	74 10                	je     8035e8 <insert_sorted_with_merge_freeList+0x4af>
  8035d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035db:	8b 00                	mov    (%eax),%eax
  8035dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035e0:	8b 52 04             	mov    0x4(%edx),%edx
  8035e3:	89 50 04             	mov    %edx,0x4(%eax)
  8035e6:	eb 0b                	jmp    8035f3 <insert_sorted_with_merge_freeList+0x4ba>
  8035e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035eb:	8b 40 04             	mov    0x4(%eax),%eax
  8035ee:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f6:	8b 40 04             	mov    0x4(%eax),%eax
  8035f9:	85 c0                	test   %eax,%eax
  8035fb:	74 0f                	je     80360c <insert_sorted_with_merge_freeList+0x4d3>
  8035fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803600:	8b 40 04             	mov    0x4(%eax),%eax
  803603:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803606:	8b 12                	mov    (%edx),%edx
  803608:	89 10                	mov    %edx,(%eax)
  80360a:	eb 0a                	jmp    803616 <insert_sorted_with_merge_freeList+0x4dd>
  80360c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80360f:	8b 00                	mov    (%eax),%eax
  803611:	a3 38 51 80 00       	mov    %eax,0x805138
  803616:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803619:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80361f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803622:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803629:	a1 44 51 80 00       	mov    0x805144,%eax
  80362e:	48                   	dec    %eax
  80362f:	a3 44 51 80 00       	mov    %eax,0x805144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  803634:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803638:	75 17                	jne    803651 <insert_sorted_with_merge_freeList+0x518>
  80363a:	83 ec 04             	sub    $0x4,%esp
  80363d:	68 04 44 80 00       	push   $0x804404
  803642:	68 4f 01 00 00       	push   $0x14f
  803647:	68 27 44 80 00       	push   $0x804427
  80364c:	e8 4c d2 ff ff       	call   80089d <_panic>
  803651:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803657:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80365a:	89 10                	mov    %edx,(%eax)
  80365c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80365f:	8b 00                	mov    (%eax),%eax
  803661:	85 c0                	test   %eax,%eax
  803663:	74 0d                	je     803672 <insert_sorted_with_merge_freeList+0x539>
  803665:	a1 48 51 80 00       	mov    0x805148,%eax
  80366a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80366d:	89 50 04             	mov    %edx,0x4(%eax)
  803670:	eb 08                	jmp    80367a <insert_sorted_with_merge_freeList+0x541>
  803672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803675:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80367a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80367d:	a3 48 51 80 00       	mov    %eax,0x805148
  803682:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803685:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80368c:	a1 54 51 80 00       	mov    0x805154,%eax
  803691:	40                   	inc    %eax
  803692:	a3 54 51 80 00       	mov    %eax,0x805154
  803697:	e9 65 01 00 00       	jmp    803801 <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  80369c:	8b 45 08             	mov    0x8(%ebp),%eax
  80369f:	8b 40 08             	mov    0x8(%eax),%eax
  8036a2:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8036a5:	0f 85 9f 00 00 00    	jne    80374a <insert_sorted_with_merge_freeList+0x611>
  8036ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ae:	8b 40 08             	mov    0x8(%eax),%eax
  8036b1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8036b4:	0f 84 90 00 00 00    	je     80374a <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  8036ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036bd:	8b 50 0c             	mov    0xc(%eax),%edx
  8036c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8036c6:	01 c2                	add    %eax,%edx
  8036c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036cb:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  8036ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  8036d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036db:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8036e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036e6:	75 17                	jne    8036ff <insert_sorted_with_merge_freeList+0x5c6>
  8036e8:	83 ec 04             	sub    $0x4,%esp
  8036eb:	68 04 44 80 00       	push   $0x804404
  8036f0:	68 58 01 00 00       	push   $0x158
  8036f5:	68 27 44 80 00       	push   $0x804427
  8036fa:	e8 9e d1 ff ff       	call   80089d <_panic>
  8036ff:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803705:	8b 45 08             	mov    0x8(%ebp),%eax
  803708:	89 10                	mov    %edx,(%eax)
  80370a:	8b 45 08             	mov    0x8(%ebp),%eax
  80370d:	8b 00                	mov    (%eax),%eax
  80370f:	85 c0                	test   %eax,%eax
  803711:	74 0d                	je     803720 <insert_sorted_with_merge_freeList+0x5e7>
  803713:	a1 48 51 80 00       	mov    0x805148,%eax
  803718:	8b 55 08             	mov    0x8(%ebp),%edx
  80371b:	89 50 04             	mov    %edx,0x4(%eax)
  80371e:	eb 08                	jmp    803728 <insert_sorted_with_merge_freeList+0x5ef>
  803720:	8b 45 08             	mov    0x8(%ebp),%eax
  803723:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803728:	8b 45 08             	mov    0x8(%ebp),%eax
  80372b:	a3 48 51 80 00       	mov    %eax,0x805148
  803730:	8b 45 08             	mov    0x8(%ebp),%eax
  803733:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80373a:	a1 54 51 80 00       	mov    0x805154,%eax
  80373f:	40                   	inc    %eax
  803740:	a3 54 51 80 00       	mov    %eax,0x805154
  803745:	e9 b7 00 00 00       	jmp    803801 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  80374a:	8b 45 08             	mov    0x8(%ebp),%eax
  80374d:	8b 40 08             	mov    0x8(%eax),%eax
  803750:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803753:	0f 84 e2 00 00 00    	je     80383b <insert_sorted_with_merge_freeList+0x702>
  803759:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80375c:	8b 40 08             	mov    0x8(%eax),%eax
  80375f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803762:	0f 85 d3 00 00 00    	jne    80383b <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  803768:	8b 45 08             	mov    0x8(%ebp),%eax
  80376b:	8b 50 08             	mov    0x8(%eax),%edx
  80376e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803771:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  803774:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803777:	8b 50 0c             	mov    0xc(%eax),%edx
  80377a:	8b 45 08             	mov    0x8(%ebp),%eax
  80377d:	8b 40 0c             	mov    0xc(%eax),%eax
  803780:	01 c2                	add    %eax,%edx
  803782:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803785:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  803788:	8b 45 08             	mov    0x8(%ebp),%eax
  80378b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  803792:	8b 45 08             	mov    0x8(%ebp),%eax
  803795:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80379c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037a0:	75 17                	jne    8037b9 <insert_sorted_with_merge_freeList+0x680>
  8037a2:	83 ec 04             	sub    $0x4,%esp
  8037a5:	68 04 44 80 00       	push   $0x804404
  8037aa:	68 61 01 00 00       	push   $0x161
  8037af:	68 27 44 80 00       	push   $0x804427
  8037b4:	e8 e4 d0 ff ff       	call   80089d <_panic>
  8037b9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8037bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c2:	89 10                	mov    %edx,(%eax)
  8037c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c7:	8b 00                	mov    (%eax),%eax
  8037c9:	85 c0                	test   %eax,%eax
  8037cb:	74 0d                	je     8037da <insert_sorted_with_merge_freeList+0x6a1>
  8037cd:	a1 48 51 80 00       	mov    0x805148,%eax
  8037d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8037d5:	89 50 04             	mov    %edx,0x4(%eax)
  8037d8:	eb 08                	jmp    8037e2 <insert_sorted_with_merge_freeList+0x6a9>
  8037da:	8b 45 08             	mov    0x8(%ebp),%eax
  8037dd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8037e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e5:	a3 48 51 80 00       	mov    %eax,0x805148
  8037ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037f4:	a1 54 51 80 00       	mov    0x805154,%eax
  8037f9:	40                   	inc    %eax
  8037fa:	a3 54 51 80 00       	mov    %eax,0x805154
								}
								break;
  8037ff:	eb 3a                	jmp    80383b <insert_sorted_with_merge_freeList+0x702>
  803801:	eb 38                	jmp    80383b <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  803803:	a1 40 51 80 00       	mov    0x805140,%eax
  803808:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80380b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80380f:	74 07                	je     803818 <insert_sorted_with_merge_freeList+0x6df>
  803811:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803814:	8b 00                	mov    (%eax),%eax
  803816:	eb 05                	jmp    80381d <insert_sorted_with_merge_freeList+0x6e4>
  803818:	b8 00 00 00 00       	mov    $0x0,%eax
  80381d:	a3 40 51 80 00       	mov    %eax,0x805140
  803822:	a1 40 51 80 00       	mov    0x805140,%eax
  803827:	85 c0                	test   %eax,%eax
  803829:	0f 85 fa fb ff ff    	jne    803429 <insert_sorted_with_merge_freeList+0x2f0>
  80382f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803833:	0f 85 f0 fb ff ff    	jne    803429 <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  803839:	eb 01                	jmp    80383c <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  80383b:	90                   	nop
							}

						}
		          }
		}
}
  80383c:	90                   	nop
  80383d:	c9                   	leave  
  80383e:	c3                   	ret    
  80383f:	90                   	nop

00803840 <__udivdi3>:
  803840:	55                   	push   %ebp
  803841:	57                   	push   %edi
  803842:	56                   	push   %esi
  803843:	53                   	push   %ebx
  803844:	83 ec 1c             	sub    $0x1c,%esp
  803847:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80384b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80384f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803853:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803857:	89 ca                	mov    %ecx,%edx
  803859:	89 f8                	mov    %edi,%eax
  80385b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80385f:	85 f6                	test   %esi,%esi
  803861:	75 2d                	jne    803890 <__udivdi3+0x50>
  803863:	39 cf                	cmp    %ecx,%edi
  803865:	77 65                	ja     8038cc <__udivdi3+0x8c>
  803867:	89 fd                	mov    %edi,%ebp
  803869:	85 ff                	test   %edi,%edi
  80386b:	75 0b                	jne    803878 <__udivdi3+0x38>
  80386d:	b8 01 00 00 00       	mov    $0x1,%eax
  803872:	31 d2                	xor    %edx,%edx
  803874:	f7 f7                	div    %edi
  803876:	89 c5                	mov    %eax,%ebp
  803878:	31 d2                	xor    %edx,%edx
  80387a:	89 c8                	mov    %ecx,%eax
  80387c:	f7 f5                	div    %ebp
  80387e:	89 c1                	mov    %eax,%ecx
  803880:	89 d8                	mov    %ebx,%eax
  803882:	f7 f5                	div    %ebp
  803884:	89 cf                	mov    %ecx,%edi
  803886:	89 fa                	mov    %edi,%edx
  803888:	83 c4 1c             	add    $0x1c,%esp
  80388b:	5b                   	pop    %ebx
  80388c:	5e                   	pop    %esi
  80388d:	5f                   	pop    %edi
  80388e:	5d                   	pop    %ebp
  80388f:	c3                   	ret    
  803890:	39 ce                	cmp    %ecx,%esi
  803892:	77 28                	ja     8038bc <__udivdi3+0x7c>
  803894:	0f bd fe             	bsr    %esi,%edi
  803897:	83 f7 1f             	xor    $0x1f,%edi
  80389a:	75 40                	jne    8038dc <__udivdi3+0x9c>
  80389c:	39 ce                	cmp    %ecx,%esi
  80389e:	72 0a                	jb     8038aa <__udivdi3+0x6a>
  8038a0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8038a4:	0f 87 9e 00 00 00    	ja     803948 <__udivdi3+0x108>
  8038aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8038af:	89 fa                	mov    %edi,%edx
  8038b1:	83 c4 1c             	add    $0x1c,%esp
  8038b4:	5b                   	pop    %ebx
  8038b5:	5e                   	pop    %esi
  8038b6:	5f                   	pop    %edi
  8038b7:	5d                   	pop    %ebp
  8038b8:	c3                   	ret    
  8038b9:	8d 76 00             	lea    0x0(%esi),%esi
  8038bc:	31 ff                	xor    %edi,%edi
  8038be:	31 c0                	xor    %eax,%eax
  8038c0:	89 fa                	mov    %edi,%edx
  8038c2:	83 c4 1c             	add    $0x1c,%esp
  8038c5:	5b                   	pop    %ebx
  8038c6:	5e                   	pop    %esi
  8038c7:	5f                   	pop    %edi
  8038c8:	5d                   	pop    %ebp
  8038c9:	c3                   	ret    
  8038ca:	66 90                	xchg   %ax,%ax
  8038cc:	89 d8                	mov    %ebx,%eax
  8038ce:	f7 f7                	div    %edi
  8038d0:	31 ff                	xor    %edi,%edi
  8038d2:	89 fa                	mov    %edi,%edx
  8038d4:	83 c4 1c             	add    $0x1c,%esp
  8038d7:	5b                   	pop    %ebx
  8038d8:	5e                   	pop    %esi
  8038d9:	5f                   	pop    %edi
  8038da:	5d                   	pop    %ebp
  8038db:	c3                   	ret    
  8038dc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8038e1:	89 eb                	mov    %ebp,%ebx
  8038e3:	29 fb                	sub    %edi,%ebx
  8038e5:	89 f9                	mov    %edi,%ecx
  8038e7:	d3 e6                	shl    %cl,%esi
  8038e9:	89 c5                	mov    %eax,%ebp
  8038eb:	88 d9                	mov    %bl,%cl
  8038ed:	d3 ed                	shr    %cl,%ebp
  8038ef:	89 e9                	mov    %ebp,%ecx
  8038f1:	09 f1                	or     %esi,%ecx
  8038f3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8038f7:	89 f9                	mov    %edi,%ecx
  8038f9:	d3 e0                	shl    %cl,%eax
  8038fb:	89 c5                	mov    %eax,%ebp
  8038fd:	89 d6                	mov    %edx,%esi
  8038ff:	88 d9                	mov    %bl,%cl
  803901:	d3 ee                	shr    %cl,%esi
  803903:	89 f9                	mov    %edi,%ecx
  803905:	d3 e2                	shl    %cl,%edx
  803907:	8b 44 24 08          	mov    0x8(%esp),%eax
  80390b:	88 d9                	mov    %bl,%cl
  80390d:	d3 e8                	shr    %cl,%eax
  80390f:	09 c2                	or     %eax,%edx
  803911:	89 d0                	mov    %edx,%eax
  803913:	89 f2                	mov    %esi,%edx
  803915:	f7 74 24 0c          	divl   0xc(%esp)
  803919:	89 d6                	mov    %edx,%esi
  80391b:	89 c3                	mov    %eax,%ebx
  80391d:	f7 e5                	mul    %ebp
  80391f:	39 d6                	cmp    %edx,%esi
  803921:	72 19                	jb     80393c <__udivdi3+0xfc>
  803923:	74 0b                	je     803930 <__udivdi3+0xf0>
  803925:	89 d8                	mov    %ebx,%eax
  803927:	31 ff                	xor    %edi,%edi
  803929:	e9 58 ff ff ff       	jmp    803886 <__udivdi3+0x46>
  80392e:	66 90                	xchg   %ax,%ax
  803930:	8b 54 24 08          	mov    0x8(%esp),%edx
  803934:	89 f9                	mov    %edi,%ecx
  803936:	d3 e2                	shl    %cl,%edx
  803938:	39 c2                	cmp    %eax,%edx
  80393a:	73 e9                	jae    803925 <__udivdi3+0xe5>
  80393c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80393f:	31 ff                	xor    %edi,%edi
  803941:	e9 40 ff ff ff       	jmp    803886 <__udivdi3+0x46>
  803946:	66 90                	xchg   %ax,%ax
  803948:	31 c0                	xor    %eax,%eax
  80394a:	e9 37 ff ff ff       	jmp    803886 <__udivdi3+0x46>
  80394f:	90                   	nop

00803950 <__umoddi3>:
  803950:	55                   	push   %ebp
  803951:	57                   	push   %edi
  803952:	56                   	push   %esi
  803953:	53                   	push   %ebx
  803954:	83 ec 1c             	sub    $0x1c,%esp
  803957:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80395b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80395f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803963:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803967:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80396b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80396f:	89 f3                	mov    %esi,%ebx
  803971:	89 fa                	mov    %edi,%edx
  803973:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803977:	89 34 24             	mov    %esi,(%esp)
  80397a:	85 c0                	test   %eax,%eax
  80397c:	75 1a                	jne    803998 <__umoddi3+0x48>
  80397e:	39 f7                	cmp    %esi,%edi
  803980:	0f 86 a2 00 00 00    	jbe    803a28 <__umoddi3+0xd8>
  803986:	89 c8                	mov    %ecx,%eax
  803988:	89 f2                	mov    %esi,%edx
  80398a:	f7 f7                	div    %edi
  80398c:	89 d0                	mov    %edx,%eax
  80398e:	31 d2                	xor    %edx,%edx
  803990:	83 c4 1c             	add    $0x1c,%esp
  803993:	5b                   	pop    %ebx
  803994:	5e                   	pop    %esi
  803995:	5f                   	pop    %edi
  803996:	5d                   	pop    %ebp
  803997:	c3                   	ret    
  803998:	39 f0                	cmp    %esi,%eax
  80399a:	0f 87 ac 00 00 00    	ja     803a4c <__umoddi3+0xfc>
  8039a0:	0f bd e8             	bsr    %eax,%ebp
  8039a3:	83 f5 1f             	xor    $0x1f,%ebp
  8039a6:	0f 84 ac 00 00 00    	je     803a58 <__umoddi3+0x108>
  8039ac:	bf 20 00 00 00       	mov    $0x20,%edi
  8039b1:	29 ef                	sub    %ebp,%edi
  8039b3:	89 fe                	mov    %edi,%esi
  8039b5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8039b9:	89 e9                	mov    %ebp,%ecx
  8039bb:	d3 e0                	shl    %cl,%eax
  8039bd:	89 d7                	mov    %edx,%edi
  8039bf:	89 f1                	mov    %esi,%ecx
  8039c1:	d3 ef                	shr    %cl,%edi
  8039c3:	09 c7                	or     %eax,%edi
  8039c5:	89 e9                	mov    %ebp,%ecx
  8039c7:	d3 e2                	shl    %cl,%edx
  8039c9:	89 14 24             	mov    %edx,(%esp)
  8039cc:	89 d8                	mov    %ebx,%eax
  8039ce:	d3 e0                	shl    %cl,%eax
  8039d0:	89 c2                	mov    %eax,%edx
  8039d2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039d6:	d3 e0                	shl    %cl,%eax
  8039d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8039dc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039e0:	89 f1                	mov    %esi,%ecx
  8039e2:	d3 e8                	shr    %cl,%eax
  8039e4:	09 d0                	or     %edx,%eax
  8039e6:	d3 eb                	shr    %cl,%ebx
  8039e8:	89 da                	mov    %ebx,%edx
  8039ea:	f7 f7                	div    %edi
  8039ec:	89 d3                	mov    %edx,%ebx
  8039ee:	f7 24 24             	mull   (%esp)
  8039f1:	89 c6                	mov    %eax,%esi
  8039f3:	89 d1                	mov    %edx,%ecx
  8039f5:	39 d3                	cmp    %edx,%ebx
  8039f7:	0f 82 87 00 00 00    	jb     803a84 <__umoddi3+0x134>
  8039fd:	0f 84 91 00 00 00    	je     803a94 <__umoddi3+0x144>
  803a03:	8b 54 24 04          	mov    0x4(%esp),%edx
  803a07:	29 f2                	sub    %esi,%edx
  803a09:	19 cb                	sbb    %ecx,%ebx
  803a0b:	89 d8                	mov    %ebx,%eax
  803a0d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803a11:	d3 e0                	shl    %cl,%eax
  803a13:	89 e9                	mov    %ebp,%ecx
  803a15:	d3 ea                	shr    %cl,%edx
  803a17:	09 d0                	or     %edx,%eax
  803a19:	89 e9                	mov    %ebp,%ecx
  803a1b:	d3 eb                	shr    %cl,%ebx
  803a1d:	89 da                	mov    %ebx,%edx
  803a1f:	83 c4 1c             	add    $0x1c,%esp
  803a22:	5b                   	pop    %ebx
  803a23:	5e                   	pop    %esi
  803a24:	5f                   	pop    %edi
  803a25:	5d                   	pop    %ebp
  803a26:	c3                   	ret    
  803a27:	90                   	nop
  803a28:	89 fd                	mov    %edi,%ebp
  803a2a:	85 ff                	test   %edi,%edi
  803a2c:	75 0b                	jne    803a39 <__umoddi3+0xe9>
  803a2e:	b8 01 00 00 00       	mov    $0x1,%eax
  803a33:	31 d2                	xor    %edx,%edx
  803a35:	f7 f7                	div    %edi
  803a37:	89 c5                	mov    %eax,%ebp
  803a39:	89 f0                	mov    %esi,%eax
  803a3b:	31 d2                	xor    %edx,%edx
  803a3d:	f7 f5                	div    %ebp
  803a3f:	89 c8                	mov    %ecx,%eax
  803a41:	f7 f5                	div    %ebp
  803a43:	89 d0                	mov    %edx,%eax
  803a45:	e9 44 ff ff ff       	jmp    80398e <__umoddi3+0x3e>
  803a4a:	66 90                	xchg   %ax,%ax
  803a4c:	89 c8                	mov    %ecx,%eax
  803a4e:	89 f2                	mov    %esi,%edx
  803a50:	83 c4 1c             	add    $0x1c,%esp
  803a53:	5b                   	pop    %ebx
  803a54:	5e                   	pop    %esi
  803a55:	5f                   	pop    %edi
  803a56:	5d                   	pop    %ebp
  803a57:	c3                   	ret    
  803a58:	3b 04 24             	cmp    (%esp),%eax
  803a5b:	72 06                	jb     803a63 <__umoddi3+0x113>
  803a5d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803a61:	77 0f                	ja     803a72 <__umoddi3+0x122>
  803a63:	89 f2                	mov    %esi,%edx
  803a65:	29 f9                	sub    %edi,%ecx
  803a67:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803a6b:	89 14 24             	mov    %edx,(%esp)
  803a6e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a72:	8b 44 24 04          	mov    0x4(%esp),%eax
  803a76:	8b 14 24             	mov    (%esp),%edx
  803a79:	83 c4 1c             	add    $0x1c,%esp
  803a7c:	5b                   	pop    %ebx
  803a7d:	5e                   	pop    %esi
  803a7e:	5f                   	pop    %edi
  803a7f:	5d                   	pop    %ebp
  803a80:	c3                   	ret    
  803a81:	8d 76 00             	lea    0x0(%esi),%esi
  803a84:	2b 04 24             	sub    (%esp),%eax
  803a87:	19 fa                	sbb    %edi,%edx
  803a89:	89 d1                	mov    %edx,%ecx
  803a8b:	89 c6                	mov    %eax,%esi
  803a8d:	e9 71 ff ff ff       	jmp    803a03 <__umoddi3+0xb3>
  803a92:	66 90                	xchg   %ax,%ax
  803a94:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803a98:	72 ea                	jb     803a84 <__umoddi3+0x134>
  803a9a:	89 d9                	mov    %ebx,%ecx
  803a9c:	e9 62 ff ff ff       	jmp    803a03 <__umoddi3+0xb3>

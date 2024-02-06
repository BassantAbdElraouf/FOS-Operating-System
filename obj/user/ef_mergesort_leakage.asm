
obj/user/ef_mergesort_leakage:     file format elf32-i386


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
  800031:	e8 9a 07 00 00       	call   8007d0 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void Merge(int* A, int p, int q, int r);

uint32 CheckSorted(int *Elements, int NumOfElements);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 28 01 00 00    	sub    $0x128,%esp
	char Line[255] ;
	char Chose ;
	int numOfRep = 0;
  800041:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	do
	{
		numOfRep++ ;
  800048:	ff 45 f0             	incl   -0x10(%ebp)
		//2012: lock the interrupt
		sys_disable_interrupt();
  80004b:	e8 f9 1f 00 00       	call   802049 <sys_disable_interrupt>

		cprintf("\n");
  800050:	83 ec 0c             	sub    $0xc,%esp
  800053:	68 20 39 80 00       	push   $0x803920
  800058:	e8 63 0b 00 00       	call   800bc0 <cprintf>
  80005d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800060:	83 ec 0c             	sub    $0xc,%esp
  800063:	68 22 39 80 00       	push   $0x803922
  800068:	e8 53 0b 00 00       	call   800bc0 <cprintf>
  80006d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800070:	83 ec 0c             	sub    $0xc,%esp
  800073:	68 38 39 80 00       	push   $0x803938
  800078:	e8 43 0b 00 00       	call   800bc0 <cprintf>
  80007d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800080:	83 ec 0c             	sub    $0xc,%esp
  800083:	68 22 39 80 00       	push   $0x803922
  800088:	e8 33 0b 00 00       	call   800bc0 <cprintf>
  80008d:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800090:	83 ec 0c             	sub    $0xc,%esp
  800093:	68 20 39 80 00       	push   $0x803920
  800098:	e8 23 0b 00 00       	call   800bc0 <cprintf>
  80009d:	83 c4 10             	add    $0x10,%esp
		cprintf("Enter the number of elements: ");
  8000a0:	83 ec 0c             	sub    $0xc,%esp
  8000a3:	68 50 39 80 00       	push   $0x803950
  8000a8:	e8 13 0b 00 00       	call   800bc0 <cprintf>
  8000ad:	83 c4 10             	add    $0x10,%esp

		int NumOfElements ;

		if (numOfRep == 1)
  8000b0:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  8000b4:	75 09                	jne    8000bf <_main+0x87>
			NumOfElements = 32;
  8000b6:	c7 45 ec 20 00 00 00 	movl   $0x20,-0x14(%ebp)
  8000bd:	eb 0d                	jmp    8000cc <_main+0x94>
		else if (numOfRep == 2)
  8000bf:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  8000c3:	75 07                	jne    8000cc <_main+0x94>
			NumOfElements = 32;
  8000c5:	c7 45 ec 20 00 00 00 	movl   $0x20,-0x14(%ebp)

		cprintf("%d\n", NumOfElements) ;
  8000cc:	83 ec 08             	sub    $0x8,%esp
  8000cf:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d2:	68 6f 39 80 00       	push   $0x80396f
  8000d7:	e8 e4 0a 00 00       	call   800bc0 <cprintf>
  8000dc:	83 c4 10             	add    $0x10,%esp

		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000e2:	c1 e0 02             	shl    $0x2,%eax
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	50                   	push   %eax
  8000e9:	e8 01 1a 00 00       	call   801aef <malloc>
  8000ee:	83 c4 10             	add    $0x10,%esp
  8000f1:	89 45 e8             	mov    %eax,-0x18(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	68 74 39 80 00       	push   $0x803974
  8000fc:	e8 bf 0a 00 00       	call   800bc0 <cprintf>
  800101:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  800104:	83 ec 0c             	sub    $0xc,%esp
  800107:	68 96 39 80 00       	push   $0x803996
  80010c:	e8 af 0a 00 00       	call   800bc0 <cprintf>
  800111:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	68 a4 39 80 00       	push   $0x8039a4
  80011c:	e8 9f 0a 00 00       	call   800bc0 <cprintf>
  800121:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	68 b3 39 80 00       	push   $0x8039b3
  80012c:	e8 8f 0a 00 00       	call   800bc0 <cprintf>
  800131:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800134:	83 ec 0c             	sub    $0xc,%esp
  800137:	68 c3 39 80 00       	push   $0x8039c3
  80013c:	e8 7f 0a 00 00       	call   800bc0 <cprintf>
  800141:	83 c4 10             	add    $0x10,%esp
			if (numOfRep == 1)
  800144:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  800148:	75 06                	jne    800150 <_main+0x118>
				Chose = 'a' ;
  80014a:	c6 45 f7 61          	movb   $0x61,-0x9(%ebp)
  80014e:	eb 0a                	jmp    80015a <_main+0x122>
			else if (numOfRep == 2)
  800150:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  800154:	75 04                	jne    80015a <_main+0x122>
				Chose = 'c' ;
  800156:	c6 45 f7 63          	movb   $0x63,-0x9(%ebp)
			cputchar(Chose);
  80015a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80015e:	83 ec 0c             	sub    $0xc,%esp
  800161:	50                   	push   %eax
  800162:	e8 c9 05 00 00       	call   800730 <cputchar>
  800167:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80016a:	83 ec 0c             	sub    $0xc,%esp
  80016d:	6a 0a                	push   $0xa
  80016f:	e8 bc 05 00 00       	call   800730 <cputchar>
  800174:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800177:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  80017b:	74 0c                	je     800189 <_main+0x151>
  80017d:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  800181:	74 06                	je     800189 <_main+0x151>
  800183:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800187:	75 ab                	jne    800134 <_main+0xfc>

		//2012: lock the interrupt
		sys_enable_interrupt();
  800189:	e8 d5 1e 00 00       	call   802063 <sys_enable_interrupt>

		int  i ;
		switch (Chose)
  80018e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800192:	83 f8 62             	cmp    $0x62,%eax
  800195:	74 1d                	je     8001b4 <_main+0x17c>
  800197:	83 f8 63             	cmp    $0x63,%eax
  80019a:	74 2b                	je     8001c7 <_main+0x18f>
  80019c:	83 f8 61             	cmp    $0x61,%eax
  80019f:	75 39                	jne    8001da <_main+0x1a2>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  8001a1:	83 ec 08             	sub    $0x8,%esp
  8001a4:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a7:	ff 75 e8             	pushl  -0x18(%ebp)
  8001aa:	e8 f4 01 00 00       	call   8003a3 <InitializeAscending>
  8001af:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b2:	eb 37                	jmp    8001eb <_main+0x1b3>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  8001b4:	83 ec 08             	sub    $0x8,%esp
  8001b7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ba:	ff 75 e8             	pushl  -0x18(%ebp)
  8001bd:	e8 12 02 00 00       	call   8003d4 <InitializeDescending>
  8001c2:	83 c4 10             	add    $0x10,%esp
			break ;
  8001c5:	eb 24                	jmp    8001eb <_main+0x1b3>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001c7:	83 ec 08             	sub    $0x8,%esp
  8001ca:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cd:	ff 75 e8             	pushl  -0x18(%ebp)
  8001d0:	e8 34 02 00 00       	call   800409 <InitializeSemiRandom>
  8001d5:	83 c4 10             	add    $0x10,%esp
			break ;
  8001d8:	eb 11                	jmp    8001eb <_main+0x1b3>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001da:	83 ec 08             	sub    $0x8,%esp
  8001dd:	ff 75 ec             	pushl  -0x14(%ebp)
  8001e0:	ff 75 e8             	pushl  -0x18(%ebp)
  8001e3:	e8 21 02 00 00       	call   800409 <InitializeSemiRandom>
  8001e8:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001eb:	83 ec 04             	sub    $0x4,%esp
  8001ee:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f1:	6a 01                	push   $0x1
  8001f3:	ff 75 e8             	pushl  -0x18(%ebp)
  8001f6:	e8 e0 02 00 00       	call   8004db <MSort>
  8001fb:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001fe:	e8 46 1e 00 00       	call   802049 <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  800203:	83 ec 0c             	sub    $0xc,%esp
  800206:	68 cc 39 80 00       	push   $0x8039cc
  80020b:	e8 b0 09 00 00       	call   800bc0 <cprintf>
  800210:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  800213:	e8 4b 1e 00 00       	call   802063 <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  800218:	83 ec 08             	sub    $0x8,%esp
  80021b:	ff 75 ec             	pushl  -0x14(%ebp)
  80021e:	ff 75 e8             	pushl  -0x18(%ebp)
  800221:	e8 d3 00 00 00       	call   8002f9 <CheckSorted>
  800226:	83 c4 10             	add    $0x10,%esp
  800229:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  80022c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800230:	75 14                	jne    800246 <_main+0x20e>
  800232:	83 ec 04             	sub    $0x4,%esp
  800235:	68 00 3a 80 00       	push   $0x803a00
  80023a:	6a 58                	push   $0x58
  80023c:	68 22 3a 80 00       	push   $0x803a22
  800241:	e8 c6 06 00 00       	call   80090c <_panic>
		else
		{
			sys_disable_interrupt();
  800246:	e8 fe 1d 00 00       	call   802049 <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  80024b:	83 ec 0c             	sub    $0xc,%esp
  80024e:	68 40 3a 80 00       	push   $0x803a40
  800253:	e8 68 09 00 00       	call   800bc0 <cprintf>
  800258:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  80025b:	83 ec 0c             	sub    $0xc,%esp
  80025e:	68 74 3a 80 00       	push   $0x803a74
  800263:	e8 58 09 00 00       	call   800bc0 <cprintf>
  800268:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  80026b:	83 ec 0c             	sub    $0xc,%esp
  80026e:	68 a8 3a 80 00       	push   $0x803aa8
  800273:	e8 48 09 00 00       	call   800bc0 <cprintf>
  800278:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  80027b:	e8 e3 1d 00 00       	call   802063 <sys_enable_interrupt>
		}

		//free(Elements) ;

		sys_disable_interrupt();
  800280:	e8 c4 1d 00 00       	call   802049 <sys_disable_interrupt>
		Chose = 0 ;
  800285:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
		while (Chose != 'y' && Chose != 'n')
  800289:	eb 50                	jmp    8002db <_main+0x2a3>
		{
			cprintf("Do you want to repeat (y/n): ") ;
  80028b:	83 ec 0c             	sub    $0xc,%esp
  80028e:	68 da 3a 80 00       	push   $0x803ada
  800293:	e8 28 09 00 00       	call   800bc0 <cprintf>
  800298:	83 c4 10             	add    $0x10,%esp
			if (numOfRep == 1)
  80029b:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  80029f:	75 06                	jne    8002a7 <_main+0x26f>
				Chose = 'y' ;
  8002a1:	c6 45 f7 79          	movb   $0x79,-0x9(%ebp)
  8002a5:	eb 0a                	jmp    8002b1 <_main+0x279>
			else if (numOfRep == 2)
  8002a7:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  8002ab:	75 04                	jne    8002b1 <_main+0x279>
				Chose = 'n' ;
  8002ad:	c6 45 f7 6e          	movb   $0x6e,-0x9(%ebp)
			cputchar(Chose);
  8002b1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8002b5:	83 ec 0c             	sub    $0xc,%esp
  8002b8:	50                   	push   %eax
  8002b9:	e8 72 04 00 00       	call   800730 <cputchar>
  8002be:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8002c1:	83 ec 0c             	sub    $0xc,%esp
  8002c4:	6a 0a                	push   $0xa
  8002c6:	e8 65 04 00 00       	call   800730 <cputchar>
  8002cb:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8002ce:	83 ec 0c             	sub    $0xc,%esp
  8002d1:	6a 0a                	push   $0xa
  8002d3:	e8 58 04 00 00       	call   800730 <cputchar>
  8002d8:	83 c4 10             	add    $0x10,%esp

		//free(Elements) ;

		sys_disable_interrupt();
		Chose = 0 ;
		while (Chose != 'y' && Chose != 'n')
  8002db:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002df:	74 06                	je     8002e7 <_main+0x2af>
  8002e1:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002e5:	75 a4                	jne    80028b <_main+0x253>
				Chose = 'n' ;
			cputchar(Chose);
			cputchar('\n');
			cputchar('\n');
		}
		sys_enable_interrupt();
  8002e7:	e8 77 1d 00 00       	call   802063 <sys_enable_interrupt>

	} while (Chose == 'y');
  8002ec:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002f0:	0f 84 52 fd ff ff    	je     800048 <_main+0x10>
}
  8002f6:	90                   	nop
  8002f7:	c9                   	leave  
  8002f8:	c3                   	ret    

008002f9 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002f9:	55                   	push   %ebp
  8002fa:	89 e5                	mov    %esp,%ebp
  8002fc:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8002ff:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800306:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80030d:	eb 33                	jmp    800342 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  80030f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800312:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800319:	8b 45 08             	mov    0x8(%ebp),%eax
  80031c:	01 d0                	add    %edx,%eax
  80031e:	8b 10                	mov    (%eax),%edx
  800320:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800323:	40                   	inc    %eax
  800324:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80032b:	8b 45 08             	mov    0x8(%ebp),%eax
  80032e:	01 c8                	add    %ecx,%eax
  800330:	8b 00                	mov    (%eax),%eax
  800332:	39 c2                	cmp    %eax,%edx
  800334:	7e 09                	jle    80033f <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800336:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  80033d:	eb 0c                	jmp    80034b <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80033f:	ff 45 f8             	incl   -0x8(%ebp)
  800342:	8b 45 0c             	mov    0xc(%ebp),%eax
  800345:	48                   	dec    %eax
  800346:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800349:	7f c4                	jg     80030f <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  80034b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80034e:	c9                   	leave  
  80034f:	c3                   	ret    

00800350 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  800350:	55                   	push   %ebp
  800351:	89 e5                	mov    %esp,%ebp
  800353:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800356:	8b 45 0c             	mov    0xc(%ebp),%eax
  800359:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800360:	8b 45 08             	mov    0x8(%ebp),%eax
  800363:	01 d0                	add    %edx,%eax
  800365:	8b 00                	mov    (%eax),%eax
  800367:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  80036a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80036d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800374:	8b 45 08             	mov    0x8(%ebp),%eax
  800377:	01 c2                	add    %eax,%edx
  800379:	8b 45 10             	mov    0x10(%ebp),%eax
  80037c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800383:	8b 45 08             	mov    0x8(%ebp),%eax
  800386:	01 c8                	add    %ecx,%eax
  800388:	8b 00                	mov    (%eax),%eax
  80038a:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  80038c:	8b 45 10             	mov    0x10(%ebp),%eax
  80038f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800396:	8b 45 08             	mov    0x8(%ebp),%eax
  800399:	01 c2                	add    %eax,%edx
  80039b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80039e:	89 02                	mov    %eax,(%edx)
}
  8003a0:	90                   	nop
  8003a1:	c9                   	leave  
  8003a2:	c3                   	ret    

008003a3 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  8003a3:	55                   	push   %ebp
  8003a4:	89 e5                	mov    %esp,%ebp
  8003a6:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003b0:	eb 17                	jmp    8003c9 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  8003b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bf:	01 c2                	add    %eax,%edx
  8003c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003c4:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003c6:	ff 45 fc             	incl   -0x4(%ebp)
  8003c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003cf:	7c e1                	jl     8003b2 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8003d1:	90                   	nop
  8003d2:	c9                   	leave  
  8003d3:	c3                   	ret    

008003d4 <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8003d4:	55                   	push   %ebp
  8003d5:	89 e5                	mov    %esp,%ebp
  8003d7:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003e1:	eb 1b                	jmp    8003fe <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8003e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003e6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f0:	01 c2                	add    %eax,%edx
  8003f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f5:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003f8:	48                   	dec    %eax
  8003f9:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003fb:	ff 45 fc             	incl   -0x4(%ebp)
  8003fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800401:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800404:	7c dd                	jl     8003e3 <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  800406:	90                   	nop
  800407:	c9                   	leave  
  800408:	c3                   	ret    

00800409 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  800409:	55                   	push   %ebp
  80040a:	89 e5                	mov    %esp,%ebp
  80040c:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  80040f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800412:	b8 56 55 55 55       	mov    $0x55555556,%eax
  800417:	f7 e9                	imul   %ecx
  800419:	c1 f9 1f             	sar    $0x1f,%ecx
  80041c:	89 d0                	mov    %edx,%eax
  80041e:	29 c8                	sub    %ecx,%eax
  800420:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  800423:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80042a:	eb 1e                	jmp    80044a <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  80042c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80042f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800436:	8b 45 08             	mov    0x8(%ebp),%eax
  800439:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80043c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80043f:	99                   	cltd   
  800440:	f7 7d f8             	idivl  -0x8(%ebp)
  800443:	89 d0                	mov    %edx,%eax
  800445:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800447:	ff 45 fc             	incl   -0x4(%ebp)
  80044a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80044d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800450:	7c da                	jl     80042c <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  800452:	90                   	nop
  800453:	c9                   	leave  
  800454:	c3                   	ret    

00800455 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800455:	55                   	push   %ebp
  800456:	89 e5                	mov    %esp,%ebp
  800458:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  80045b:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800462:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800469:	eb 42                	jmp    8004ad <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  80046b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80046e:	99                   	cltd   
  80046f:	f7 7d f0             	idivl  -0x10(%ebp)
  800472:	89 d0                	mov    %edx,%eax
  800474:	85 c0                	test   %eax,%eax
  800476:	75 10                	jne    800488 <PrintElements+0x33>
			cprintf("\n");
  800478:	83 ec 0c             	sub    $0xc,%esp
  80047b:	68 20 39 80 00       	push   $0x803920
  800480:	e8 3b 07 00 00       	call   800bc0 <cprintf>
  800485:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800488:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80048b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800492:	8b 45 08             	mov    0x8(%ebp),%eax
  800495:	01 d0                	add    %edx,%eax
  800497:	8b 00                	mov    (%eax),%eax
  800499:	83 ec 08             	sub    $0x8,%esp
  80049c:	50                   	push   %eax
  80049d:	68 f8 3a 80 00       	push   $0x803af8
  8004a2:	e8 19 07 00 00       	call   800bc0 <cprintf>
  8004a7:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8004aa:	ff 45 f4             	incl   -0xc(%ebp)
  8004ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b0:	48                   	dec    %eax
  8004b1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8004b4:	7f b5                	jg     80046b <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  8004b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c3:	01 d0                	add    %edx,%eax
  8004c5:	8b 00                	mov    (%eax),%eax
  8004c7:	83 ec 08             	sub    $0x8,%esp
  8004ca:	50                   	push   %eax
  8004cb:	68 6f 39 80 00       	push   $0x80396f
  8004d0:	e8 eb 06 00 00       	call   800bc0 <cprintf>
  8004d5:	83 c4 10             	add    $0x10,%esp

}
  8004d8:	90                   	nop
  8004d9:	c9                   	leave  
  8004da:	c3                   	ret    

008004db <MSort>:


void MSort(int* A, int p, int r)
{
  8004db:	55                   	push   %ebp
  8004dc:	89 e5                	mov    %esp,%ebp
  8004de:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  8004e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e4:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004e7:	7d 54                	jge    80053d <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ef:	01 d0                	add    %edx,%eax
  8004f1:	89 c2                	mov    %eax,%edx
  8004f3:	c1 ea 1f             	shr    $0x1f,%edx
  8004f6:	01 d0                	add    %edx,%eax
  8004f8:	d1 f8                	sar    %eax
  8004fa:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8004fd:	83 ec 04             	sub    $0x4,%esp
  800500:	ff 75 f4             	pushl  -0xc(%ebp)
  800503:	ff 75 0c             	pushl  0xc(%ebp)
  800506:	ff 75 08             	pushl  0x8(%ebp)
  800509:	e8 cd ff ff ff       	call   8004db <MSort>
  80050e:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  800511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800514:	40                   	inc    %eax
  800515:	83 ec 04             	sub    $0x4,%esp
  800518:	ff 75 10             	pushl  0x10(%ebp)
  80051b:	50                   	push   %eax
  80051c:	ff 75 08             	pushl  0x8(%ebp)
  80051f:	e8 b7 ff ff ff       	call   8004db <MSort>
  800524:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  800527:	ff 75 10             	pushl  0x10(%ebp)
  80052a:	ff 75 f4             	pushl  -0xc(%ebp)
  80052d:	ff 75 0c             	pushl  0xc(%ebp)
  800530:	ff 75 08             	pushl  0x8(%ebp)
  800533:	e8 08 00 00 00       	call   800540 <Merge>
  800538:	83 c4 10             	add    $0x10,%esp
  80053b:	eb 01                	jmp    80053e <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  80053d:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  80053e:	c9                   	leave  
  80053f:	c3                   	ret    

00800540 <Merge>:

void Merge(int* A, int p, int q, int r)
{
  800540:	55                   	push   %ebp
  800541:	89 e5                	mov    %esp,%ebp
  800543:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  800546:	8b 45 10             	mov    0x10(%ebp),%eax
  800549:	2b 45 0c             	sub    0xc(%ebp),%eax
  80054c:	40                   	inc    %eax
  80054d:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  800550:	8b 45 14             	mov    0x14(%ebp),%eax
  800553:	2b 45 10             	sub    0x10(%ebp),%eax
  800556:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800559:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  800560:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int* Left = malloc(sizeof(int) * leftCapacity);
  800567:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80056a:	c1 e0 02             	shl    $0x2,%eax
  80056d:	83 ec 0c             	sub    $0xc,%esp
  800570:	50                   	push   %eax
  800571:	e8 79 15 00 00       	call   801aef <malloc>
  800576:	83 c4 10             	add    $0x10,%esp
  800579:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  80057c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80057f:	c1 e0 02             	shl    $0x2,%eax
  800582:	83 ec 0c             	sub    $0xc,%esp
  800585:	50                   	push   %eax
  800586:	e8 64 15 00 00       	call   801aef <malloc>
  80058b:	83 c4 10             	add    $0x10,%esp
  80058e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800591:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800598:	eb 2f                	jmp    8005c9 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  80059a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80059d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005a7:	01 c2                	add    %eax,%edx
  8005a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005af:	01 c8                	add    %ecx,%eax
  8005b1:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8005b6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c0:	01 c8                	add    %ecx,%eax
  8005c2:	8b 00                	mov    (%eax),%eax
  8005c4:	89 02                	mov    %eax,(%edx)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  8005c6:	ff 45 ec             	incl   -0x14(%ebp)
  8005c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005cc:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005cf:	7c c9                	jl     80059a <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005d1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005d8:	eb 2a                	jmp    800604 <Merge+0xc4>
	{
		Right[j] = A[q + j];
  8005da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005e7:	01 c2                	add    %eax,%edx
  8005e9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005ef:	01 c8                	add    %ecx,%eax
  8005f1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fb:	01 c8                	add    %ecx,%eax
  8005fd:	8b 00                	mov    (%eax),%eax
  8005ff:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  800601:	ff 45 e8             	incl   -0x18(%ebp)
  800604:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800607:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80060a:	7c ce                	jl     8005da <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  80060c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80060f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800612:	e9 0a 01 00 00       	jmp    800721 <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  800617:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80061a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80061d:	0f 8d 95 00 00 00    	jge    8006b8 <Merge+0x178>
  800623:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800626:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800629:	0f 8d 89 00 00 00    	jge    8006b8 <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80062f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800632:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800639:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80063c:	01 d0                	add    %edx,%eax
  80063e:	8b 10                	mov    (%eax),%edx
  800640:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800643:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80064a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80064d:	01 c8                	add    %ecx,%eax
  80064f:	8b 00                	mov    (%eax),%eax
  800651:	39 c2                	cmp    %eax,%edx
  800653:	7d 33                	jge    800688 <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  800655:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800658:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80065d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800664:	8b 45 08             	mov    0x8(%ebp),%eax
  800667:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80066a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80066d:	8d 50 01             	lea    0x1(%eax),%edx
  800670:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800673:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80067a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80067d:	01 d0                	add    %edx,%eax
  80067f:	8b 00                	mov    (%eax),%eax
  800681:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800683:	e9 96 00 00 00       	jmp    80071e <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  800688:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80068b:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800690:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800697:	8b 45 08             	mov    0x8(%ebp),%eax
  80069a:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80069d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006a0:	8d 50 01             	lea    0x1(%eax),%edx
  8006a3:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8006a6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006b0:	01 d0                	add    %edx,%eax
  8006b2:	8b 00                	mov    (%eax),%eax
  8006b4:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8006b6:	eb 66                	jmp    80071e <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  8006b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006bb:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8006be:	7d 30                	jge    8006f0 <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  8006c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006c3:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006c8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d2:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006d8:	8d 50 01             	lea    0x1(%eax),%edx
  8006db:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8006de:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006e5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006e8:	01 d0                	add    %edx,%eax
  8006ea:	8b 00                	mov    (%eax),%eax
  8006ec:	89 01                	mov    %eax,(%ecx)
  8006ee:	eb 2e                	jmp    80071e <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  8006f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006f3:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800702:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800705:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800708:	8d 50 01             	lea    0x1(%eax),%edx
  80070b:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80070e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800715:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800718:	01 d0                	add    %edx,%eax
  80071a:	8b 00                	mov    (%eax),%eax
  80071c:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  80071e:	ff 45 e4             	incl   -0x1c(%ebp)
  800721:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800724:	3b 45 14             	cmp    0x14(%ebp),%eax
  800727:	0f 8e ea fe ff ff    	jle    800617 <Merge+0xd7>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

}
  80072d:	90                   	nop
  80072e:	c9                   	leave  
  80072f:	c3                   	ret    

00800730 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800730:	55                   	push   %ebp
  800731:	89 e5                	mov    %esp,%ebp
  800733:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800736:	8b 45 08             	mov    0x8(%ebp),%eax
  800739:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  80073c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800740:	83 ec 0c             	sub    $0xc,%esp
  800743:	50                   	push   %eax
  800744:	e8 34 19 00 00       	call   80207d <sys_cputc>
  800749:	83 c4 10             	add    $0x10,%esp
}
  80074c:	90                   	nop
  80074d:	c9                   	leave  
  80074e:	c3                   	ret    

0080074f <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  80074f:	55                   	push   %ebp
  800750:	89 e5                	mov    %esp,%ebp
  800752:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800755:	e8 ef 18 00 00       	call   802049 <sys_disable_interrupt>
	char c = ch;
  80075a:	8b 45 08             	mov    0x8(%ebp),%eax
  80075d:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800760:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800764:	83 ec 0c             	sub    $0xc,%esp
  800767:	50                   	push   %eax
  800768:	e8 10 19 00 00       	call   80207d <sys_cputc>
  80076d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800770:	e8 ee 18 00 00       	call   802063 <sys_enable_interrupt>
}
  800775:	90                   	nop
  800776:	c9                   	leave  
  800777:	c3                   	ret    

00800778 <getchar>:

int
getchar(void)
{
  800778:	55                   	push   %ebp
  800779:	89 e5                	mov    %esp,%ebp
  80077b:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  80077e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800785:	eb 08                	jmp    80078f <getchar+0x17>
	{
		c = sys_cgetc();
  800787:	e8 38 17 00 00       	call   801ec4 <sys_cgetc>
  80078c:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  80078f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800793:	74 f2                	je     800787 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  800795:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800798:	c9                   	leave  
  800799:	c3                   	ret    

0080079a <atomic_getchar>:

int
atomic_getchar(void)
{
  80079a:	55                   	push   %ebp
  80079b:	89 e5                	mov    %esp,%ebp
  80079d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007a0:	e8 a4 18 00 00       	call   802049 <sys_disable_interrupt>
	int c=0;
  8007a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8007ac:	eb 08                	jmp    8007b6 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  8007ae:	e8 11 17 00 00       	call   801ec4 <sys_cgetc>
  8007b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  8007b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8007ba:	74 f2                	je     8007ae <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  8007bc:	e8 a2 18 00 00       	call   802063 <sys_enable_interrupt>
	return c;
  8007c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8007c4:	c9                   	leave  
  8007c5:	c3                   	ret    

008007c6 <iscons>:

int iscons(int fdnum)
{
  8007c6:	55                   	push   %ebp
  8007c7:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8007c9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8007ce:	5d                   	pop    %ebp
  8007cf:	c3                   	ret    

008007d0 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8007d0:	55                   	push   %ebp
  8007d1:	89 e5                	mov    %esp,%ebp
  8007d3:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8007d6:	e8 61 1a 00 00       	call   80223c <sys_getenvindex>
  8007db:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8007de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007e1:	89 d0                	mov    %edx,%eax
  8007e3:	c1 e0 03             	shl    $0x3,%eax
  8007e6:	01 d0                	add    %edx,%eax
  8007e8:	01 c0                	add    %eax,%eax
  8007ea:	01 d0                	add    %edx,%eax
  8007ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007f3:	01 d0                	add    %edx,%eax
  8007f5:	c1 e0 04             	shl    $0x4,%eax
  8007f8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8007fd:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800802:	a1 24 50 80 00       	mov    0x805024,%eax
  800807:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80080d:	84 c0                	test   %al,%al
  80080f:	74 0f                	je     800820 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800811:	a1 24 50 80 00       	mov    0x805024,%eax
  800816:	05 5c 05 00 00       	add    $0x55c,%eax
  80081b:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800820:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800824:	7e 0a                	jle    800830 <libmain+0x60>
		binaryname = argv[0];
  800826:	8b 45 0c             	mov    0xc(%ebp),%eax
  800829:	8b 00                	mov    (%eax),%eax
  80082b:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800830:	83 ec 08             	sub    $0x8,%esp
  800833:	ff 75 0c             	pushl  0xc(%ebp)
  800836:	ff 75 08             	pushl  0x8(%ebp)
  800839:	e8 fa f7 ff ff       	call   800038 <_main>
  80083e:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800841:	e8 03 18 00 00       	call   802049 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800846:	83 ec 0c             	sub    $0xc,%esp
  800849:	68 18 3b 80 00       	push   $0x803b18
  80084e:	e8 6d 03 00 00       	call   800bc0 <cprintf>
  800853:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800856:	a1 24 50 80 00       	mov    0x805024,%eax
  80085b:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800861:	a1 24 50 80 00       	mov    0x805024,%eax
  800866:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80086c:	83 ec 04             	sub    $0x4,%esp
  80086f:	52                   	push   %edx
  800870:	50                   	push   %eax
  800871:	68 40 3b 80 00       	push   $0x803b40
  800876:	e8 45 03 00 00       	call   800bc0 <cprintf>
  80087b:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80087e:	a1 24 50 80 00       	mov    0x805024,%eax
  800883:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800889:	a1 24 50 80 00       	mov    0x805024,%eax
  80088e:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800894:	a1 24 50 80 00       	mov    0x805024,%eax
  800899:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80089f:	51                   	push   %ecx
  8008a0:	52                   	push   %edx
  8008a1:	50                   	push   %eax
  8008a2:	68 68 3b 80 00       	push   $0x803b68
  8008a7:	e8 14 03 00 00       	call   800bc0 <cprintf>
  8008ac:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8008af:	a1 24 50 80 00       	mov    0x805024,%eax
  8008b4:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8008ba:	83 ec 08             	sub    $0x8,%esp
  8008bd:	50                   	push   %eax
  8008be:	68 c0 3b 80 00       	push   $0x803bc0
  8008c3:	e8 f8 02 00 00       	call   800bc0 <cprintf>
  8008c8:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8008cb:	83 ec 0c             	sub    $0xc,%esp
  8008ce:	68 18 3b 80 00       	push   $0x803b18
  8008d3:	e8 e8 02 00 00       	call   800bc0 <cprintf>
  8008d8:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8008db:	e8 83 17 00 00       	call   802063 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8008e0:	e8 19 00 00 00       	call   8008fe <exit>
}
  8008e5:	90                   	nop
  8008e6:	c9                   	leave  
  8008e7:	c3                   	ret    

008008e8 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8008e8:	55                   	push   %ebp
  8008e9:	89 e5                	mov    %esp,%ebp
  8008eb:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8008ee:	83 ec 0c             	sub    $0xc,%esp
  8008f1:	6a 00                	push   $0x0
  8008f3:	e8 10 19 00 00       	call   802208 <sys_destroy_env>
  8008f8:	83 c4 10             	add    $0x10,%esp
}
  8008fb:	90                   	nop
  8008fc:	c9                   	leave  
  8008fd:	c3                   	ret    

008008fe <exit>:

void
exit(void)
{
  8008fe:	55                   	push   %ebp
  8008ff:	89 e5                	mov    %esp,%ebp
  800901:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800904:	e8 65 19 00 00       	call   80226e <sys_exit_env>
}
  800909:	90                   	nop
  80090a:	c9                   	leave  
  80090b:	c3                   	ret    

0080090c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80090c:	55                   	push   %ebp
  80090d:	89 e5                	mov    %esp,%ebp
  80090f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800912:	8d 45 10             	lea    0x10(%ebp),%eax
  800915:	83 c0 04             	add    $0x4,%eax
  800918:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80091b:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800920:	85 c0                	test   %eax,%eax
  800922:	74 16                	je     80093a <_panic+0x2e>
		cprintf("%s: ", argv0);
  800924:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800929:	83 ec 08             	sub    $0x8,%esp
  80092c:	50                   	push   %eax
  80092d:	68 d4 3b 80 00       	push   $0x803bd4
  800932:	e8 89 02 00 00       	call   800bc0 <cprintf>
  800937:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80093a:	a1 00 50 80 00       	mov    0x805000,%eax
  80093f:	ff 75 0c             	pushl  0xc(%ebp)
  800942:	ff 75 08             	pushl  0x8(%ebp)
  800945:	50                   	push   %eax
  800946:	68 d9 3b 80 00       	push   $0x803bd9
  80094b:	e8 70 02 00 00       	call   800bc0 <cprintf>
  800950:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800953:	8b 45 10             	mov    0x10(%ebp),%eax
  800956:	83 ec 08             	sub    $0x8,%esp
  800959:	ff 75 f4             	pushl  -0xc(%ebp)
  80095c:	50                   	push   %eax
  80095d:	e8 f3 01 00 00       	call   800b55 <vcprintf>
  800962:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800965:	83 ec 08             	sub    $0x8,%esp
  800968:	6a 00                	push   $0x0
  80096a:	68 f5 3b 80 00       	push   $0x803bf5
  80096f:	e8 e1 01 00 00       	call   800b55 <vcprintf>
  800974:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800977:	e8 82 ff ff ff       	call   8008fe <exit>

	// should not return here
	while (1) ;
  80097c:	eb fe                	jmp    80097c <_panic+0x70>

0080097e <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80097e:	55                   	push   %ebp
  80097f:	89 e5                	mov    %esp,%ebp
  800981:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800984:	a1 24 50 80 00       	mov    0x805024,%eax
  800989:	8b 50 74             	mov    0x74(%eax),%edx
  80098c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098f:	39 c2                	cmp    %eax,%edx
  800991:	74 14                	je     8009a7 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800993:	83 ec 04             	sub    $0x4,%esp
  800996:	68 f8 3b 80 00       	push   $0x803bf8
  80099b:	6a 26                	push   $0x26
  80099d:	68 44 3c 80 00       	push   $0x803c44
  8009a2:	e8 65 ff ff ff       	call   80090c <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8009a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8009ae:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009b5:	e9 c2 00 00 00       	jmp    800a7c <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8009ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009bd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c7:	01 d0                	add    %edx,%eax
  8009c9:	8b 00                	mov    (%eax),%eax
  8009cb:	85 c0                	test   %eax,%eax
  8009cd:	75 08                	jne    8009d7 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8009cf:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8009d2:	e9 a2 00 00 00       	jmp    800a79 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8009d7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009de:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8009e5:	eb 69                	jmp    800a50 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8009e7:	a1 24 50 80 00       	mov    0x805024,%eax
  8009ec:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009f2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009f5:	89 d0                	mov    %edx,%eax
  8009f7:	01 c0                	add    %eax,%eax
  8009f9:	01 d0                	add    %edx,%eax
  8009fb:	c1 e0 03             	shl    $0x3,%eax
  8009fe:	01 c8                	add    %ecx,%eax
  800a00:	8a 40 04             	mov    0x4(%eax),%al
  800a03:	84 c0                	test   %al,%al
  800a05:	75 46                	jne    800a4d <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a07:	a1 24 50 80 00       	mov    0x805024,%eax
  800a0c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800a12:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a15:	89 d0                	mov    %edx,%eax
  800a17:	01 c0                	add    %eax,%eax
  800a19:	01 d0                	add    %edx,%eax
  800a1b:	c1 e0 03             	shl    $0x3,%eax
  800a1e:	01 c8                	add    %ecx,%eax
  800a20:	8b 00                	mov    (%eax),%eax
  800a22:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a25:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a28:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a2d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800a2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a32:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a39:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3c:	01 c8                	add    %ecx,%eax
  800a3e:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a40:	39 c2                	cmp    %eax,%edx
  800a42:	75 09                	jne    800a4d <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800a44:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a4b:	eb 12                	jmp    800a5f <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a4d:	ff 45 e8             	incl   -0x18(%ebp)
  800a50:	a1 24 50 80 00       	mov    0x805024,%eax
  800a55:	8b 50 74             	mov    0x74(%eax),%edx
  800a58:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a5b:	39 c2                	cmp    %eax,%edx
  800a5d:	77 88                	ja     8009e7 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a5f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a63:	75 14                	jne    800a79 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800a65:	83 ec 04             	sub    $0x4,%esp
  800a68:	68 50 3c 80 00       	push   $0x803c50
  800a6d:	6a 3a                	push   $0x3a
  800a6f:	68 44 3c 80 00       	push   $0x803c44
  800a74:	e8 93 fe ff ff       	call   80090c <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a79:	ff 45 f0             	incl   -0x10(%ebp)
  800a7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a7f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a82:	0f 8c 32 ff ff ff    	jl     8009ba <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a88:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a8f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a96:	eb 26                	jmp    800abe <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a98:	a1 24 50 80 00       	mov    0x805024,%eax
  800a9d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800aa3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800aa6:	89 d0                	mov    %edx,%eax
  800aa8:	01 c0                	add    %eax,%eax
  800aaa:	01 d0                	add    %edx,%eax
  800aac:	c1 e0 03             	shl    $0x3,%eax
  800aaf:	01 c8                	add    %ecx,%eax
  800ab1:	8a 40 04             	mov    0x4(%eax),%al
  800ab4:	3c 01                	cmp    $0x1,%al
  800ab6:	75 03                	jne    800abb <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800ab8:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800abb:	ff 45 e0             	incl   -0x20(%ebp)
  800abe:	a1 24 50 80 00       	mov    0x805024,%eax
  800ac3:	8b 50 74             	mov    0x74(%eax),%edx
  800ac6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ac9:	39 c2                	cmp    %eax,%edx
  800acb:	77 cb                	ja     800a98 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ad0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800ad3:	74 14                	je     800ae9 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800ad5:	83 ec 04             	sub    $0x4,%esp
  800ad8:	68 a4 3c 80 00       	push   $0x803ca4
  800add:	6a 44                	push   $0x44
  800adf:	68 44 3c 80 00       	push   $0x803c44
  800ae4:	e8 23 fe ff ff       	call   80090c <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800ae9:	90                   	nop
  800aea:	c9                   	leave  
  800aeb:	c3                   	ret    

00800aec <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800aec:	55                   	push   %ebp
  800aed:	89 e5                	mov    %esp,%ebp
  800aef:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800af2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af5:	8b 00                	mov    (%eax),%eax
  800af7:	8d 48 01             	lea    0x1(%eax),%ecx
  800afa:	8b 55 0c             	mov    0xc(%ebp),%edx
  800afd:	89 0a                	mov    %ecx,(%edx)
  800aff:	8b 55 08             	mov    0x8(%ebp),%edx
  800b02:	88 d1                	mov    %dl,%cl
  800b04:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b07:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800b0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0e:	8b 00                	mov    (%eax),%eax
  800b10:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b15:	75 2c                	jne    800b43 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800b17:	a0 28 50 80 00       	mov    0x805028,%al
  800b1c:	0f b6 c0             	movzbl %al,%eax
  800b1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b22:	8b 12                	mov    (%edx),%edx
  800b24:	89 d1                	mov    %edx,%ecx
  800b26:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b29:	83 c2 08             	add    $0x8,%edx
  800b2c:	83 ec 04             	sub    $0x4,%esp
  800b2f:	50                   	push   %eax
  800b30:	51                   	push   %ecx
  800b31:	52                   	push   %edx
  800b32:	e8 64 13 00 00       	call   801e9b <sys_cputs>
  800b37:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b46:	8b 40 04             	mov    0x4(%eax),%eax
  800b49:	8d 50 01             	lea    0x1(%eax),%edx
  800b4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4f:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b52:	90                   	nop
  800b53:	c9                   	leave  
  800b54:	c3                   	ret    

00800b55 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b55:	55                   	push   %ebp
  800b56:	89 e5                	mov    %esp,%ebp
  800b58:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b5e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b65:	00 00 00 
	b.cnt = 0;
  800b68:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b6f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b72:	ff 75 0c             	pushl  0xc(%ebp)
  800b75:	ff 75 08             	pushl  0x8(%ebp)
  800b78:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b7e:	50                   	push   %eax
  800b7f:	68 ec 0a 80 00       	push   $0x800aec
  800b84:	e8 11 02 00 00       	call   800d9a <vprintfmt>
  800b89:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800b8c:	a0 28 50 80 00       	mov    0x805028,%al
  800b91:	0f b6 c0             	movzbl %al,%eax
  800b94:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b9a:	83 ec 04             	sub    $0x4,%esp
  800b9d:	50                   	push   %eax
  800b9e:	52                   	push   %edx
  800b9f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ba5:	83 c0 08             	add    $0x8,%eax
  800ba8:	50                   	push   %eax
  800ba9:	e8 ed 12 00 00       	call   801e9b <sys_cputs>
  800bae:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800bb1:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800bb8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800bbe:	c9                   	leave  
  800bbf:	c3                   	ret    

00800bc0 <cprintf>:

int cprintf(const char *fmt, ...) {
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
  800bc3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800bc6:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800bcd:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd6:	83 ec 08             	sub    $0x8,%esp
  800bd9:	ff 75 f4             	pushl  -0xc(%ebp)
  800bdc:	50                   	push   %eax
  800bdd:	e8 73 ff ff ff       	call   800b55 <vcprintf>
  800be2:	83 c4 10             	add    $0x10,%esp
  800be5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800be8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800beb:	c9                   	leave  
  800bec:	c3                   	ret    

00800bed <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800bed:	55                   	push   %ebp
  800bee:	89 e5                	mov    %esp,%ebp
  800bf0:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800bf3:	e8 51 14 00 00       	call   802049 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800bf8:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800c01:	83 ec 08             	sub    $0x8,%esp
  800c04:	ff 75 f4             	pushl  -0xc(%ebp)
  800c07:	50                   	push   %eax
  800c08:	e8 48 ff ff ff       	call   800b55 <vcprintf>
  800c0d:	83 c4 10             	add    $0x10,%esp
  800c10:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800c13:	e8 4b 14 00 00       	call   802063 <sys_enable_interrupt>
	return cnt;
  800c18:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c1b:	c9                   	leave  
  800c1c:	c3                   	ret    

00800c1d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c1d:	55                   	push   %ebp
  800c1e:	89 e5                	mov    %esp,%ebp
  800c20:	53                   	push   %ebx
  800c21:	83 ec 14             	sub    $0x14,%esp
  800c24:	8b 45 10             	mov    0x10(%ebp),%eax
  800c27:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c2a:	8b 45 14             	mov    0x14(%ebp),%eax
  800c2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c30:	8b 45 18             	mov    0x18(%ebp),%eax
  800c33:	ba 00 00 00 00       	mov    $0x0,%edx
  800c38:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c3b:	77 55                	ja     800c92 <printnum+0x75>
  800c3d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c40:	72 05                	jb     800c47 <printnum+0x2a>
  800c42:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c45:	77 4b                	ja     800c92 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c47:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800c4a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800c4d:	8b 45 18             	mov    0x18(%ebp),%eax
  800c50:	ba 00 00 00 00       	mov    $0x0,%edx
  800c55:	52                   	push   %edx
  800c56:	50                   	push   %eax
  800c57:	ff 75 f4             	pushl  -0xc(%ebp)
  800c5a:	ff 75 f0             	pushl  -0x10(%ebp)
  800c5d:	e8 46 2a 00 00       	call   8036a8 <__udivdi3>
  800c62:	83 c4 10             	add    $0x10,%esp
  800c65:	83 ec 04             	sub    $0x4,%esp
  800c68:	ff 75 20             	pushl  0x20(%ebp)
  800c6b:	53                   	push   %ebx
  800c6c:	ff 75 18             	pushl  0x18(%ebp)
  800c6f:	52                   	push   %edx
  800c70:	50                   	push   %eax
  800c71:	ff 75 0c             	pushl  0xc(%ebp)
  800c74:	ff 75 08             	pushl  0x8(%ebp)
  800c77:	e8 a1 ff ff ff       	call   800c1d <printnum>
  800c7c:	83 c4 20             	add    $0x20,%esp
  800c7f:	eb 1a                	jmp    800c9b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c81:	83 ec 08             	sub    $0x8,%esp
  800c84:	ff 75 0c             	pushl  0xc(%ebp)
  800c87:	ff 75 20             	pushl  0x20(%ebp)
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8d:	ff d0                	call   *%eax
  800c8f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c92:	ff 4d 1c             	decl   0x1c(%ebp)
  800c95:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c99:	7f e6                	jg     800c81 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c9b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c9e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ca3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ca6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ca9:	53                   	push   %ebx
  800caa:	51                   	push   %ecx
  800cab:	52                   	push   %edx
  800cac:	50                   	push   %eax
  800cad:	e8 06 2b 00 00       	call   8037b8 <__umoddi3>
  800cb2:	83 c4 10             	add    $0x10,%esp
  800cb5:	05 14 3f 80 00       	add    $0x803f14,%eax
  800cba:	8a 00                	mov    (%eax),%al
  800cbc:	0f be c0             	movsbl %al,%eax
  800cbf:	83 ec 08             	sub    $0x8,%esp
  800cc2:	ff 75 0c             	pushl  0xc(%ebp)
  800cc5:	50                   	push   %eax
  800cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc9:	ff d0                	call   *%eax
  800ccb:	83 c4 10             	add    $0x10,%esp
}
  800cce:	90                   	nop
  800ccf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800cd2:	c9                   	leave  
  800cd3:	c3                   	ret    

00800cd4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800cd4:	55                   	push   %ebp
  800cd5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800cd7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800cdb:	7e 1c                	jle    800cf9 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	8b 00                	mov    (%eax),%eax
  800ce2:	8d 50 08             	lea    0x8(%eax),%edx
  800ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce8:	89 10                	mov    %edx,(%eax)
  800cea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ced:	8b 00                	mov    (%eax),%eax
  800cef:	83 e8 08             	sub    $0x8,%eax
  800cf2:	8b 50 04             	mov    0x4(%eax),%edx
  800cf5:	8b 00                	mov    (%eax),%eax
  800cf7:	eb 40                	jmp    800d39 <getuint+0x65>
	else if (lflag)
  800cf9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cfd:	74 1e                	je     800d1d <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800cff:	8b 45 08             	mov    0x8(%ebp),%eax
  800d02:	8b 00                	mov    (%eax),%eax
  800d04:	8d 50 04             	lea    0x4(%eax),%edx
  800d07:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0a:	89 10                	mov    %edx,(%eax)
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0f:	8b 00                	mov    (%eax),%eax
  800d11:	83 e8 04             	sub    $0x4,%eax
  800d14:	8b 00                	mov    (%eax),%eax
  800d16:	ba 00 00 00 00       	mov    $0x0,%edx
  800d1b:	eb 1c                	jmp    800d39 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d20:	8b 00                	mov    (%eax),%eax
  800d22:	8d 50 04             	lea    0x4(%eax),%edx
  800d25:	8b 45 08             	mov    0x8(%ebp),%eax
  800d28:	89 10                	mov    %edx,(%eax)
  800d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2d:	8b 00                	mov    (%eax),%eax
  800d2f:	83 e8 04             	sub    $0x4,%eax
  800d32:	8b 00                	mov    (%eax),%eax
  800d34:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800d39:	5d                   	pop    %ebp
  800d3a:	c3                   	ret    

00800d3b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800d3b:	55                   	push   %ebp
  800d3c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d3e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d42:	7e 1c                	jle    800d60 <getint+0x25>
		return va_arg(*ap, long long);
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	8b 00                	mov    (%eax),%eax
  800d49:	8d 50 08             	lea    0x8(%eax),%edx
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	89 10                	mov    %edx,(%eax)
  800d51:	8b 45 08             	mov    0x8(%ebp),%eax
  800d54:	8b 00                	mov    (%eax),%eax
  800d56:	83 e8 08             	sub    $0x8,%eax
  800d59:	8b 50 04             	mov    0x4(%eax),%edx
  800d5c:	8b 00                	mov    (%eax),%eax
  800d5e:	eb 38                	jmp    800d98 <getint+0x5d>
	else if (lflag)
  800d60:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d64:	74 1a                	je     800d80 <getint+0x45>
		return va_arg(*ap, long);
  800d66:	8b 45 08             	mov    0x8(%ebp),%eax
  800d69:	8b 00                	mov    (%eax),%eax
  800d6b:	8d 50 04             	lea    0x4(%eax),%edx
  800d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d71:	89 10                	mov    %edx,(%eax)
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	8b 00                	mov    (%eax),%eax
  800d78:	83 e8 04             	sub    $0x4,%eax
  800d7b:	8b 00                	mov    (%eax),%eax
  800d7d:	99                   	cltd   
  800d7e:	eb 18                	jmp    800d98 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8b 00                	mov    (%eax),%eax
  800d85:	8d 50 04             	lea    0x4(%eax),%edx
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	89 10                	mov    %edx,(%eax)
  800d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d90:	8b 00                	mov    (%eax),%eax
  800d92:	83 e8 04             	sub    $0x4,%eax
  800d95:	8b 00                	mov    (%eax),%eax
  800d97:	99                   	cltd   
}
  800d98:	5d                   	pop    %ebp
  800d99:	c3                   	ret    

00800d9a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d9a:	55                   	push   %ebp
  800d9b:	89 e5                	mov    %esp,%ebp
  800d9d:	56                   	push   %esi
  800d9e:	53                   	push   %ebx
  800d9f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800da2:	eb 17                	jmp    800dbb <vprintfmt+0x21>
			if (ch == '\0')
  800da4:	85 db                	test   %ebx,%ebx
  800da6:	0f 84 af 03 00 00    	je     80115b <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800dac:	83 ec 08             	sub    $0x8,%esp
  800daf:	ff 75 0c             	pushl  0xc(%ebp)
  800db2:	53                   	push   %ebx
  800db3:	8b 45 08             	mov    0x8(%ebp),%eax
  800db6:	ff d0                	call   *%eax
  800db8:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800dbb:	8b 45 10             	mov    0x10(%ebp),%eax
  800dbe:	8d 50 01             	lea    0x1(%eax),%edx
  800dc1:	89 55 10             	mov    %edx,0x10(%ebp)
  800dc4:	8a 00                	mov    (%eax),%al
  800dc6:	0f b6 d8             	movzbl %al,%ebx
  800dc9:	83 fb 25             	cmp    $0x25,%ebx
  800dcc:	75 d6                	jne    800da4 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800dce:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800dd2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800dd9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800de0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800de7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800dee:	8b 45 10             	mov    0x10(%ebp),%eax
  800df1:	8d 50 01             	lea    0x1(%eax),%edx
  800df4:	89 55 10             	mov    %edx,0x10(%ebp)
  800df7:	8a 00                	mov    (%eax),%al
  800df9:	0f b6 d8             	movzbl %al,%ebx
  800dfc:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800dff:	83 f8 55             	cmp    $0x55,%eax
  800e02:	0f 87 2b 03 00 00    	ja     801133 <vprintfmt+0x399>
  800e08:	8b 04 85 38 3f 80 00 	mov    0x803f38(,%eax,4),%eax
  800e0f:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800e11:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800e15:	eb d7                	jmp    800dee <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e17:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800e1b:	eb d1                	jmp    800dee <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e1d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800e24:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e27:	89 d0                	mov    %edx,%eax
  800e29:	c1 e0 02             	shl    $0x2,%eax
  800e2c:	01 d0                	add    %edx,%eax
  800e2e:	01 c0                	add    %eax,%eax
  800e30:	01 d8                	add    %ebx,%eax
  800e32:	83 e8 30             	sub    $0x30,%eax
  800e35:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800e38:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3b:	8a 00                	mov    (%eax),%al
  800e3d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e40:	83 fb 2f             	cmp    $0x2f,%ebx
  800e43:	7e 3e                	jle    800e83 <vprintfmt+0xe9>
  800e45:	83 fb 39             	cmp    $0x39,%ebx
  800e48:	7f 39                	jg     800e83 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e4a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e4d:	eb d5                	jmp    800e24 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800e4f:	8b 45 14             	mov    0x14(%ebp),%eax
  800e52:	83 c0 04             	add    $0x4,%eax
  800e55:	89 45 14             	mov    %eax,0x14(%ebp)
  800e58:	8b 45 14             	mov    0x14(%ebp),%eax
  800e5b:	83 e8 04             	sub    $0x4,%eax
  800e5e:	8b 00                	mov    (%eax),%eax
  800e60:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800e63:	eb 1f                	jmp    800e84 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800e65:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e69:	79 83                	jns    800dee <vprintfmt+0x54>
				width = 0;
  800e6b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e72:	e9 77 ff ff ff       	jmp    800dee <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e77:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e7e:	e9 6b ff ff ff       	jmp    800dee <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e83:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e84:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e88:	0f 89 60 ff ff ff    	jns    800dee <vprintfmt+0x54>
				width = precision, precision = -1;
  800e8e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e91:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e94:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e9b:	e9 4e ff ff ff       	jmp    800dee <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ea0:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800ea3:	e9 46 ff ff ff       	jmp    800dee <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800ea8:	8b 45 14             	mov    0x14(%ebp),%eax
  800eab:	83 c0 04             	add    $0x4,%eax
  800eae:	89 45 14             	mov    %eax,0x14(%ebp)
  800eb1:	8b 45 14             	mov    0x14(%ebp),%eax
  800eb4:	83 e8 04             	sub    $0x4,%eax
  800eb7:	8b 00                	mov    (%eax),%eax
  800eb9:	83 ec 08             	sub    $0x8,%esp
  800ebc:	ff 75 0c             	pushl  0xc(%ebp)
  800ebf:	50                   	push   %eax
  800ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec3:	ff d0                	call   *%eax
  800ec5:	83 c4 10             	add    $0x10,%esp
			break;
  800ec8:	e9 89 02 00 00       	jmp    801156 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ecd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed0:	83 c0 04             	add    $0x4,%eax
  800ed3:	89 45 14             	mov    %eax,0x14(%ebp)
  800ed6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed9:	83 e8 04             	sub    $0x4,%eax
  800edc:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ede:	85 db                	test   %ebx,%ebx
  800ee0:	79 02                	jns    800ee4 <vprintfmt+0x14a>
				err = -err;
  800ee2:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ee4:	83 fb 64             	cmp    $0x64,%ebx
  800ee7:	7f 0b                	jg     800ef4 <vprintfmt+0x15a>
  800ee9:	8b 34 9d 80 3d 80 00 	mov    0x803d80(,%ebx,4),%esi
  800ef0:	85 f6                	test   %esi,%esi
  800ef2:	75 19                	jne    800f0d <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ef4:	53                   	push   %ebx
  800ef5:	68 25 3f 80 00       	push   $0x803f25
  800efa:	ff 75 0c             	pushl  0xc(%ebp)
  800efd:	ff 75 08             	pushl  0x8(%ebp)
  800f00:	e8 5e 02 00 00       	call   801163 <printfmt>
  800f05:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f08:	e9 49 02 00 00       	jmp    801156 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f0d:	56                   	push   %esi
  800f0e:	68 2e 3f 80 00       	push   $0x803f2e
  800f13:	ff 75 0c             	pushl  0xc(%ebp)
  800f16:	ff 75 08             	pushl  0x8(%ebp)
  800f19:	e8 45 02 00 00       	call   801163 <printfmt>
  800f1e:	83 c4 10             	add    $0x10,%esp
			break;
  800f21:	e9 30 02 00 00       	jmp    801156 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800f26:	8b 45 14             	mov    0x14(%ebp),%eax
  800f29:	83 c0 04             	add    $0x4,%eax
  800f2c:	89 45 14             	mov    %eax,0x14(%ebp)
  800f2f:	8b 45 14             	mov    0x14(%ebp),%eax
  800f32:	83 e8 04             	sub    $0x4,%eax
  800f35:	8b 30                	mov    (%eax),%esi
  800f37:	85 f6                	test   %esi,%esi
  800f39:	75 05                	jne    800f40 <vprintfmt+0x1a6>
				p = "(null)";
  800f3b:	be 31 3f 80 00       	mov    $0x803f31,%esi
			if (width > 0 && padc != '-')
  800f40:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f44:	7e 6d                	jle    800fb3 <vprintfmt+0x219>
  800f46:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800f4a:	74 67                	je     800fb3 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800f4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f4f:	83 ec 08             	sub    $0x8,%esp
  800f52:	50                   	push   %eax
  800f53:	56                   	push   %esi
  800f54:	e8 0c 03 00 00       	call   801265 <strnlen>
  800f59:	83 c4 10             	add    $0x10,%esp
  800f5c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800f5f:	eb 16                	jmp    800f77 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800f61:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800f65:	83 ec 08             	sub    $0x8,%esp
  800f68:	ff 75 0c             	pushl  0xc(%ebp)
  800f6b:	50                   	push   %eax
  800f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6f:	ff d0                	call   *%eax
  800f71:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f74:	ff 4d e4             	decl   -0x1c(%ebp)
  800f77:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f7b:	7f e4                	jg     800f61 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f7d:	eb 34                	jmp    800fb3 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f7f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f83:	74 1c                	je     800fa1 <vprintfmt+0x207>
  800f85:	83 fb 1f             	cmp    $0x1f,%ebx
  800f88:	7e 05                	jle    800f8f <vprintfmt+0x1f5>
  800f8a:	83 fb 7e             	cmp    $0x7e,%ebx
  800f8d:	7e 12                	jle    800fa1 <vprintfmt+0x207>
					putch('?', putdat);
  800f8f:	83 ec 08             	sub    $0x8,%esp
  800f92:	ff 75 0c             	pushl  0xc(%ebp)
  800f95:	6a 3f                	push   $0x3f
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9a:	ff d0                	call   *%eax
  800f9c:	83 c4 10             	add    $0x10,%esp
  800f9f:	eb 0f                	jmp    800fb0 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800fa1:	83 ec 08             	sub    $0x8,%esp
  800fa4:	ff 75 0c             	pushl  0xc(%ebp)
  800fa7:	53                   	push   %ebx
  800fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fab:	ff d0                	call   *%eax
  800fad:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800fb0:	ff 4d e4             	decl   -0x1c(%ebp)
  800fb3:	89 f0                	mov    %esi,%eax
  800fb5:	8d 70 01             	lea    0x1(%eax),%esi
  800fb8:	8a 00                	mov    (%eax),%al
  800fba:	0f be d8             	movsbl %al,%ebx
  800fbd:	85 db                	test   %ebx,%ebx
  800fbf:	74 24                	je     800fe5 <vprintfmt+0x24b>
  800fc1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fc5:	78 b8                	js     800f7f <vprintfmt+0x1e5>
  800fc7:	ff 4d e0             	decl   -0x20(%ebp)
  800fca:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fce:	79 af                	jns    800f7f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fd0:	eb 13                	jmp    800fe5 <vprintfmt+0x24b>
				putch(' ', putdat);
  800fd2:	83 ec 08             	sub    $0x8,%esp
  800fd5:	ff 75 0c             	pushl  0xc(%ebp)
  800fd8:	6a 20                	push   $0x20
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	ff d0                	call   *%eax
  800fdf:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fe2:	ff 4d e4             	decl   -0x1c(%ebp)
  800fe5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fe9:	7f e7                	jg     800fd2 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800feb:	e9 66 01 00 00       	jmp    801156 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ff0:	83 ec 08             	sub    $0x8,%esp
  800ff3:	ff 75 e8             	pushl  -0x18(%ebp)
  800ff6:	8d 45 14             	lea    0x14(%ebp),%eax
  800ff9:	50                   	push   %eax
  800ffa:	e8 3c fd ff ff       	call   800d3b <getint>
  800fff:	83 c4 10             	add    $0x10,%esp
  801002:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801005:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801008:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80100b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80100e:	85 d2                	test   %edx,%edx
  801010:	79 23                	jns    801035 <vprintfmt+0x29b>
				putch('-', putdat);
  801012:	83 ec 08             	sub    $0x8,%esp
  801015:	ff 75 0c             	pushl  0xc(%ebp)
  801018:	6a 2d                	push   $0x2d
  80101a:	8b 45 08             	mov    0x8(%ebp),%eax
  80101d:	ff d0                	call   *%eax
  80101f:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801022:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801025:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801028:	f7 d8                	neg    %eax
  80102a:	83 d2 00             	adc    $0x0,%edx
  80102d:	f7 da                	neg    %edx
  80102f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801032:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801035:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80103c:	e9 bc 00 00 00       	jmp    8010fd <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801041:	83 ec 08             	sub    $0x8,%esp
  801044:	ff 75 e8             	pushl  -0x18(%ebp)
  801047:	8d 45 14             	lea    0x14(%ebp),%eax
  80104a:	50                   	push   %eax
  80104b:	e8 84 fc ff ff       	call   800cd4 <getuint>
  801050:	83 c4 10             	add    $0x10,%esp
  801053:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801056:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801059:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801060:	e9 98 00 00 00       	jmp    8010fd <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801065:	83 ec 08             	sub    $0x8,%esp
  801068:	ff 75 0c             	pushl  0xc(%ebp)
  80106b:	6a 58                	push   $0x58
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	ff d0                	call   *%eax
  801072:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801075:	83 ec 08             	sub    $0x8,%esp
  801078:	ff 75 0c             	pushl  0xc(%ebp)
  80107b:	6a 58                	push   $0x58
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
  801080:	ff d0                	call   *%eax
  801082:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801085:	83 ec 08             	sub    $0x8,%esp
  801088:	ff 75 0c             	pushl  0xc(%ebp)
  80108b:	6a 58                	push   $0x58
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
  801090:	ff d0                	call   *%eax
  801092:	83 c4 10             	add    $0x10,%esp
			break;
  801095:	e9 bc 00 00 00       	jmp    801156 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80109a:	83 ec 08             	sub    $0x8,%esp
  80109d:	ff 75 0c             	pushl  0xc(%ebp)
  8010a0:	6a 30                	push   $0x30
  8010a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a5:	ff d0                	call   *%eax
  8010a7:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8010aa:	83 ec 08             	sub    $0x8,%esp
  8010ad:	ff 75 0c             	pushl  0xc(%ebp)
  8010b0:	6a 78                	push   $0x78
  8010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b5:	ff d0                	call   *%eax
  8010b7:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8010ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8010bd:	83 c0 04             	add    $0x4,%eax
  8010c0:	89 45 14             	mov    %eax,0x14(%ebp)
  8010c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8010c6:	83 e8 04             	sub    $0x4,%eax
  8010c9:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8010cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8010d5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8010dc:	eb 1f                	jmp    8010fd <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8010de:	83 ec 08             	sub    $0x8,%esp
  8010e1:	ff 75 e8             	pushl  -0x18(%ebp)
  8010e4:	8d 45 14             	lea    0x14(%ebp),%eax
  8010e7:	50                   	push   %eax
  8010e8:	e8 e7 fb ff ff       	call   800cd4 <getuint>
  8010ed:	83 c4 10             	add    $0x10,%esp
  8010f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010f3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8010f6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8010fd:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801101:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801104:	83 ec 04             	sub    $0x4,%esp
  801107:	52                   	push   %edx
  801108:	ff 75 e4             	pushl  -0x1c(%ebp)
  80110b:	50                   	push   %eax
  80110c:	ff 75 f4             	pushl  -0xc(%ebp)
  80110f:	ff 75 f0             	pushl  -0x10(%ebp)
  801112:	ff 75 0c             	pushl  0xc(%ebp)
  801115:	ff 75 08             	pushl  0x8(%ebp)
  801118:	e8 00 fb ff ff       	call   800c1d <printnum>
  80111d:	83 c4 20             	add    $0x20,%esp
			break;
  801120:	eb 34                	jmp    801156 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801122:	83 ec 08             	sub    $0x8,%esp
  801125:	ff 75 0c             	pushl  0xc(%ebp)
  801128:	53                   	push   %ebx
  801129:	8b 45 08             	mov    0x8(%ebp),%eax
  80112c:	ff d0                	call   *%eax
  80112e:	83 c4 10             	add    $0x10,%esp
			break;
  801131:	eb 23                	jmp    801156 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801133:	83 ec 08             	sub    $0x8,%esp
  801136:	ff 75 0c             	pushl  0xc(%ebp)
  801139:	6a 25                	push   $0x25
  80113b:	8b 45 08             	mov    0x8(%ebp),%eax
  80113e:	ff d0                	call   *%eax
  801140:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801143:	ff 4d 10             	decl   0x10(%ebp)
  801146:	eb 03                	jmp    80114b <vprintfmt+0x3b1>
  801148:	ff 4d 10             	decl   0x10(%ebp)
  80114b:	8b 45 10             	mov    0x10(%ebp),%eax
  80114e:	48                   	dec    %eax
  80114f:	8a 00                	mov    (%eax),%al
  801151:	3c 25                	cmp    $0x25,%al
  801153:	75 f3                	jne    801148 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801155:	90                   	nop
		}
	}
  801156:	e9 47 fc ff ff       	jmp    800da2 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80115b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80115c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80115f:	5b                   	pop    %ebx
  801160:	5e                   	pop    %esi
  801161:	5d                   	pop    %ebp
  801162:	c3                   	ret    

00801163 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801163:	55                   	push   %ebp
  801164:	89 e5                	mov    %esp,%ebp
  801166:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801169:	8d 45 10             	lea    0x10(%ebp),%eax
  80116c:	83 c0 04             	add    $0x4,%eax
  80116f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801172:	8b 45 10             	mov    0x10(%ebp),%eax
  801175:	ff 75 f4             	pushl  -0xc(%ebp)
  801178:	50                   	push   %eax
  801179:	ff 75 0c             	pushl  0xc(%ebp)
  80117c:	ff 75 08             	pushl  0x8(%ebp)
  80117f:	e8 16 fc ff ff       	call   800d9a <vprintfmt>
  801184:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801187:	90                   	nop
  801188:	c9                   	leave  
  801189:	c3                   	ret    

0080118a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80118a:	55                   	push   %ebp
  80118b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80118d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801190:	8b 40 08             	mov    0x8(%eax),%eax
  801193:	8d 50 01             	lea    0x1(%eax),%edx
  801196:	8b 45 0c             	mov    0xc(%ebp),%eax
  801199:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80119c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119f:	8b 10                	mov    (%eax),%edx
  8011a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a4:	8b 40 04             	mov    0x4(%eax),%eax
  8011a7:	39 c2                	cmp    %eax,%edx
  8011a9:	73 12                	jae    8011bd <sprintputch+0x33>
		*b->buf++ = ch;
  8011ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ae:	8b 00                	mov    (%eax),%eax
  8011b0:	8d 48 01             	lea    0x1(%eax),%ecx
  8011b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011b6:	89 0a                	mov    %ecx,(%edx)
  8011b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8011bb:	88 10                	mov    %dl,(%eax)
}
  8011bd:	90                   	nop
  8011be:	5d                   	pop    %ebp
  8011bf:	c3                   	ret    

008011c0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8011c0:	55                   	push   %ebp
  8011c1:	89 e5                	mov    %esp,%ebp
  8011c3:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8011c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8011cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cf:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d5:	01 d0                	add    %edx,%eax
  8011d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8011e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011e5:	74 06                	je     8011ed <vsnprintf+0x2d>
  8011e7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011eb:	7f 07                	jg     8011f4 <vsnprintf+0x34>
		return -E_INVAL;
  8011ed:	b8 03 00 00 00       	mov    $0x3,%eax
  8011f2:	eb 20                	jmp    801214 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8011f4:	ff 75 14             	pushl  0x14(%ebp)
  8011f7:	ff 75 10             	pushl  0x10(%ebp)
  8011fa:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8011fd:	50                   	push   %eax
  8011fe:	68 8a 11 80 00       	push   $0x80118a
  801203:	e8 92 fb ff ff       	call   800d9a <vprintfmt>
  801208:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80120b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80120e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801211:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801214:	c9                   	leave  
  801215:	c3                   	ret    

00801216 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801216:	55                   	push   %ebp
  801217:	89 e5                	mov    %esp,%ebp
  801219:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80121c:	8d 45 10             	lea    0x10(%ebp),%eax
  80121f:	83 c0 04             	add    $0x4,%eax
  801222:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801225:	8b 45 10             	mov    0x10(%ebp),%eax
  801228:	ff 75 f4             	pushl  -0xc(%ebp)
  80122b:	50                   	push   %eax
  80122c:	ff 75 0c             	pushl  0xc(%ebp)
  80122f:	ff 75 08             	pushl  0x8(%ebp)
  801232:	e8 89 ff ff ff       	call   8011c0 <vsnprintf>
  801237:	83 c4 10             	add    $0x10,%esp
  80123a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80123d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801240:	c9                   	leave  
  801241:	c3                   	ret    

00801242 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801242:	55                   	push   %ebp
  801243:	89 e5                	mov    %esp,%ebp
  801245:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801248:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80124f:	eb 06                	jmp    801257 <strlen+0x15>
		n++;
  801251:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801254:	ff 45 08             	incl   0x8(%ebp)
  801257:	8b 45 08             	mov    0x8(%ebp),%eax
  80125a:	8a 00                	mov    (%eax),%al
  80125c:	84 c0                	test   %al,%al
  80125e:	75 f1                	jne    801251 <strlen+0xf>
		n++;
	return n;
  801260:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801263:	c9                   	leave  
  801264:	c3                   	ret    

00801265 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801265:	55                   	push   %ebp
  801266:	89 e5                	mov    %esp,%ebp
  801268:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80126b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801272:	eb 09                	jmp    80127d <strnlen+0x18>
		n++;
  801274:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801277:	ff 45 08             	incl   0x8(%ebp)
  80127a:	ff 4d 0c             	decl   0xc(%ebp)
  80127d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801281:	74 09                	je     80128c <strnlen+0x27>
  801283:	8b 45 08             	mov    0x8(%ebp),%eax
  801286:	8a 00                	mov    (%eax),%al
  801288:	84 c0                	test   %al,%al
  80128a:	75 e8                	jne    801274 <strnlen+0xf>
		n++;
	return n;
  80128c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80128f:	c9                   	leave  
  801290:	c3                   	ret    

00801291 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801291:	55                   	push   %ebp
  801292:	89 e5                	mov    %esp,%ebp
  801294:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801297:	8b 45 08             	mov    0x8(%ebp),%eax
  80129a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80129d:	90                   	nop
  80129e:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a1:	8d 50 01             	lea    0x1(%eax),%edx
  8012a4:	89 55 08             	mov    %edx,0x8(%ebp)
  8012a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012aa:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012ad:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8012b0:	8a 12                	mov    (%edx),%dl
  8012b2:	88 10                	mov    %dl,(%eax)
  8012b4:	8a 00                	mov    (%eax),%al
  8012b6:	84 c0                	test   %al,%al
  8012b8:	75 e4                	jne    80129e <strcpy+0xd>
		/* do nothing */;
	return ret;
  8012ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012bd:	c9                   	leave  
  8012be:	c3                   	ret    

008012bf <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8012bf:	55                   	push   %ebp
  8012c0:	89 e5                	mov    %esp,%ebp
  8012c2:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8012c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8012cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012d2:	eb 1f                	jmp    8012f3 <strncpy+0x34>
		*dst++ = *src;
  8012d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d7:	8d 50 01             	lea    0x1(%eax),%edx
  8012da:	89 55 08             	mov    %edx,0x8(%ebp)
  8012dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012e0:	8a 12                	mov    (%edx),%dl
  8012e2:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8012e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e7:	8a 00                	mov    (%eax),%al
  8012e9:	84 c0                	test   %al,%al
  8012eb:	74 03                	je     8012f0 <strncpy+0x31>
			src++;
  8012ed:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012f0:	ff 45 fc             	incl   -0x4(%ebp)
  8012f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012f6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012f9:	72 d9                	jb     8012d4 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8012fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012fe:	c9                   	leave  
  8012ff:	c3                   	ret    

00801300 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801300:	55                   	push   %ebp
  801301:	89 e5                	mov    %esp,%ebp
  801303:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801306:	8b 45 08             	mov    0x8(%ebp),%eax
  801309:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80130c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801310:	74 30                	je     801342 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801312:	eb 16                	jmp    80132a <strlcpy+0x2a>
			*dst++ = *src++;
  801314:	8b 45 08             	mov    0x8(%ebp),%eax
  801317:	8d 50 01             	lea    0x1(%eax),%edx
  80131a:	89 55 08             	mov    %edx,0x8(%ebp)
  80131d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801320:	8d 4a 01             	lea    0x1(%edx),%ecx
  801323:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801326:	8a 12                	mov    (%edx),%dl
  801328:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80132a:	ff 4d 10             	decl   0x10(%ebp)
  80132d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801331:	74 09                	je     80133c <strlcpy+0x3c>
  801333:	8b 45 0c             	mov    0xc(%ebp),%eax
  801336:	8a 00                	mov    (%eax),%al
  801338:	84 c0                	test   %al,%al
  80133a:	75 d8                	jne    801314 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80133c:	8b 45 08             	mov    0x8(%ebp),%eax
  80133f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801342:	8b 55 08             	mov    0x8(%ebp),%edx
  801345:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801348:	29 c2                	sub    %eax,%edx
  80134a:	89 d0                	mov    %edx,%eax
}
  80134c:	c9                   	leave  
  80134d:	c3                   	ret    

0080134e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80134e:	55                   	push   %ebp
  80134f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801351:	eb 06                	jmp    801359 <strcmp+0xb>
		p++, q++;
  801353:	ff 45 08             	incl   0x8(%ebp)
  801356:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801359:	8b 45 08             	mov    0x8(%ebp),%eax
  80135c:	8a 00                	mov    (%eax),%al
  80135e:	84 c0                	test   %al,%al
  801360:	74 0e                	je     801370 <strcmp+0x22>
  801362:	8b 45 08             	mov    0x8(%ebp),%eax
  801365:	8a 10                	mov    (%eax),%dl
  801367:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136a:	8a 00                	mov    (%eax),%al
  80136c:	38 c2                	cmp    %al,%dl
  80136e:	74 e3                	je     801353 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801370:	8b 45 08             	mov    0x8(%ebp),%eax
  801373:	8a 00                	mov    (%eax),%al
  801375:	0f b6 d0             	movzbl %al,%edx
  801378:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137b:	8a 00                	mov    (%eax),%al
  80137d:	0f b6 c0             	movzbl %al,%eax
  801380:	29 c2                	sub    %eax,%edx
  801382:	89 d0                	mov    %edx,%eax
}
  801384:	5d                   	pop    %ebp
  801385:	c3                   	ret    

00801386 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801386:	55                   	push   %ebp
  801387:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801389:	eb 09                	jmp    801394 <strncmp+0xe>
		n--, p++, q++;
  80138b:	ff 4d 10             	decl   0x10(%ebp)
  80138e:	ff 45 08             	incl   0x8(%ebp)
  801391:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801394:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801398:	74 17                	je     8013b1 <strncmp+0x2b>
  80139a:	8b 45 08             	mov    0x8(%ebp),%eax
  80139d:	8a 00                	mov    (%eax),%al
  80139f:	84 c0                	test   %al,%al
  8013a1:	74 0e                	je     8013b1 <strncmp+0x2b>
  8013a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a6:	8a 10                	mov    (%eax),%dl
  8013a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ab:	8a 00                	mov    (%eax),%al
  8013ad:	38 c2                	cmp    %al,%dl
  8013af:	74 da                	je     80138b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8013b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013b5:	75 07                	jne    8013be <strncmp+0x38>
		return 0;
  8013b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8013bc:	eb 14                	jmp    8013d2 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8013be:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c1:	8a 00                	mov    (%eax),%al
  8013c3:	0f b6 d0             	movzbl %al,%edx
  8013c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c9:	8a 00                	mov    (%eax),%al
  8013cb:	0f b6 c0             	movzbl %al,%eax
  8013ce:	29 c2                	sub    %eax,%edx
  8013d0:	89 d0                	mov    %edx,%eax
}
  8013d2:	5d                   	pop    %ebp
  8013d3:	c3                   	ret    

008013d4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8013d4:	55                   	push   %ebp
  8013d5:	89 e5                	mov    %esp,%ebp
  8013d7:	83 ec 04             	sub    $0x4,%esp
  8013da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013dd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8013e0:	eb 12                	jmp    8013f4 <strchr+0x20>
		if (*s == c)
  8013e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e5:	8a 00                	mov    (%eax),%al
  8013e7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8013ea:	75 05                	jne    8013f1 <strchr+0x1d>
			return (char *) s;
  8013ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ef:	eb 11                	jmp    801402 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8013f1:	ff 45 08             	incl   0x8(%ebp)
  8013f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f7:	8a 00                	mov    (%eax),%al
  8013f9:	84 c0                	test   %al,%al
  8013fb:	75 e5                	jne    8013e2 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8013fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801402:	c9                   	leave  
  801403:	c3                   	ret    

00801404 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801404:	55                   	push   %ebp
  801405:	89 e5                	mov    %esp,%ebp
  801407:	83 ec 04             	sub    $0x4,%esp
  80140a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80140d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801410:	eb 0d                	jmp    80141f <strfind+0x1b>
		if (*s == c)
  801412:	8b 45 08             	mov    0x8(%ebp),%eax
  801415:	8a 00                	mov    (%eax),%al
  801417:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80141a:	74 0e                	je     80142a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80141c:	ff 45 08             	incl   0x8(%ebp)
  80141f:	8b 45 08             	mov    0x8(%ebp),%eax
  801422:	8a 00                	mov    (%eax),%al
  801424:	84 c0                	test   %al,%al
  801426:	75 ea                	jne    801412 <strfind+0xe>
  801428:	eb 01                	jmp    80142b <strfind+0x27>
		if (*s == c)
			break;
  80142a:	90                   	nop
	return (char *) s;
  80142b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80142e:	c9                   	leave  
  80142f:	c3                   	ret    

00801430 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801430:	55                   	push   %ebp
  801431:	89 e5                	mov    %esp,%ebp
  801433:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80143c:	8b 45 10             	mov    0x10(%ebp),%eax
  80143f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801442:	eb 0e                	jmp    801452 <memset+0x22>
		*p++ = c;
  801444:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801447:	8d 50 01             	lea    0x1(%eax),%edx
  80144a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80144d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801450:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801452:	ff 4d f8             	decl   -0x8(%ebp)
  801455:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801459:	79 e9                	jns    801444 <memset+0x14>
		*p++ = c;

	return v;
  80145b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80145e:	c9                   	leave  
  80145f:	c3                   	ret    

00801460 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801460:	55                   	push   %ebp
  801461:	89 e5                	mov    %esp,%ebp
  801463:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801466:	8b 45 0c             	mov    0xc(%ebp),%eax
  801469:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80146c:	8b 45 08             	mov    0x8(%ebp),%eax
  80146f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801472:	eb 16                	jmp    80148a <memcpy+0x2a>
		*d++ = *s++;
  801474:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801477:	8d 50 01             	lea    0x1(%eax),%edx
  80147a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80147d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801480:	8d 4a 01             	lea    0x1(%edx),%ecx
  801483:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801486:	8a 12                	mov    (%edx),%dl
  801488:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80148a:	8b 45 10             	mov    0x10(%ebp),%eax
  80148d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801490:	89 55 10             	mov    %edx,0x10(%ebp)
  801493:	85 c0                	test   %eax,%eax
  801495:	75 dd                	jne    801474 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801497:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80149a:	c9                   	leave  
  80149b:	c3                   	ret    

0080149c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80149c:	55                   	push   %ebp
  80149d:	89 e5                	mov    %esp,%ebp
  80149f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ab:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8014ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014b1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8014b4:	73 50                	jae    801506 <memmove+0x6a>
  8014b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014bc:	01 d0                	add    %edx,%eax
  8014be:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8014c1:	76 43                	jbe    801506 <memmove+0x6a>
		s += n;
  8014c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c6:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8014c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014cc:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8014cf:	eb 10                	jmp    8014e1 <memmove+0x45>
			*--d = *--s;
  8014d1:	ff 4d f8             	decl   -0x8(%ebp)
  8014d4:	ff 4d fc             	decl   -0x4(%ebp)
  8014d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014da:	8a 10                	mov    (%eax),%dl
  8014dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014df:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8014e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014e7:	89 55 10             	mov    %edx,0x10(%ebp)
  8014ea:	85 c0                	test   %eax,%eax
  8014ec:	75 e3                	jne    8014d1 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8014ee:	eb 23                	jmp    801513 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8014f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014f3:	8d 50 01             	lea    0x1(%eax),%edx
  8014f6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014fc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014ff:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801502:	8a 12                	mov    (%edx),%dl
  801504:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801506:	8b 45 10             	mov    0x10(%ebp),%eax
  801509:	8d 50 ff             	lea    -0x1(%eax),%edx
  80150c:	89 55 10             	mov    %edx,0x10(%ebp)
  80150f:	85 c0                	test   %eax,%eax
  801511:	75 dd                	jne    8014f0 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801513:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801516:	c9                   	leave  
  801517:	c3                   	ret    

00801518 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801518:	55                   	push   %ebp
  801519:	89 e5                	mov    %esp,%ebp
  80151b:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80151e:	8b 45 08             	mov    0x8(%ebp),%eax
  801521:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801524:	8b 45 0c             	mov    0xc(%ebp),%eax
  801527:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80152a:	eb 2a                	jmp    801556 <memcmp+0x3e>
		if (*s1 != *s2)
  80152c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80152f:	8a 10                	mov    (%eax),%dl
  801531:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801534:	8a 00                	mov    (%eax),%al
  801536:	38 c2                	cmp    %al,%dl
  801538:	74 16                	je     801550 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80153a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80153d:	8a 00                	mov    (%eax),%al
  80153f:	0f b6 d0             	movzbl %al,%edx
  801542:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801545:	8a 00                	mov    (%eax),%al
  801547:	0f b6 c0             	movzbl %al,%eax
  80154a:	29 c2                	sub    %eax,%edx
  80154c:	89 d0                	mov    %edx,%eax
  80154e:	eb 18                	jmp    801568 <memcmp+0x50>
		s1++, s2++;
  801550:	ff 45 fc             	incl   -0x4(%ebp)
  801553:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801556:	8b 45 10             	mov    0x10(%ebp),%eax
  801559:	8d 50 ff             	lea    -0x1(%eax),%edx
  80155c:	89 55 10             	mov    %edx,0x10(%ebp)
  80155f:	85 c0                	test   %eax,%eax
  801561:	75 c9                	jne    80152c <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801563:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801568:	c9                   	leave  
  801569:	c3                   	ret    

0080156a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80156a:	55                   	push   %ebp
  80156b:	89 e5                	mov    %esp,%ebp
  80156d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801570:	8b 55 08             	mov    0x8(%ebp),%edx
  801573:	8b 45 10             	mov    0x10(%ebp),%eax
  801576:	01 d0                	add    %edx,%eax
  801578:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80157b:	eb 15                	jmp    801592 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80157d:	8b 45 08             	mov    0x8(%ebp),%eax
  801580:	8a 00                	mov    (%eax),%al
  801582:	0f b6 d0             	movzbl %al,%edx
  801585:	8b 45 0c             	mov    0xc(%ebp),%eax
  801588:	0f b6 c0             	movzbl %al,%eax
  80158b:	39 c2                	cmp    %eax,%edx
  80158d:	74 0d                	je     80159c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80158f:	ff 45 08             	incl   0x8(%ebp)
  801592:	8b 45 08             	mov    0x8(%ebp),%eax
  801595:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801598:	72 e3                	jb     80157d <memfind+0x13>
  80159a:	eb 01                	jmp    80159d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80159c:	90                   	nop
	return (void *) s;
  80159d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015a0:	c9                   	leave  
  8015a1:	c3                   	ret    

008015a2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015a2:	55                   	push   %ebp
  8015a3:	89 e5                	mov    %esp,%ebp
  8015a5:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8015a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8015af:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015b6:	eb 03                	jmp    8015bb <strtol+0x19>
		s++;
  8015b8:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015be:	8a 00                	mov    (%eax),%al
  8015c0:	3c 20                	cmp    $0x20,%al
  8015c2:	74 f4                	je     8015b8 <strtol+0x16>
  8015c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c7:	8a 00                	mov    (%eax),%al
  8015c9:	3c 09                	cmp    $0x9,%al
  8015cb:	74 eb                	je     8015b8 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d0:	8a 00                	mov    (%eax),%al
  8015d2:	3c 2b                	cmp    $0x2b,%al
  8015d4:	75 05                	jne    8015db <strtol+0x39>
		s++;
  8015d6:	ff 45 08             	incl   0x8(%ebp)
  8015d9:	eb 13                	jmp    8015ee <strtol+0x4c>
	else if (*s == '-')
  8015db:	8b 45 08             	mov    0x8(%ebp),%eax
  8015de:	8a 00                	mov    (%eax),%al
  8015e0:	3c 2d                	cmp    $0x2d,%al
  8015e2:	75 0a                	jne    8015ee <strtol+0x4c>
		s++, neg = 1;
  8015e4:	ff 45 08             	incl   0x8(%ebp)
  8015e7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015ee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015f2:	74 06                	je     8015fa <strtol+0x58>
  8015f4:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8015f8:	75 20                	jne    80161a <strtol+0x78>
  8015fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fd:	8a 00                	mov    (%eax),%al
  8015ff:	3c 30                	cmp    $0x30,%al
  801601:	75 17                	jne    80161a <strtol+0x78>
  801603:	8b 45 08             	mov    0x8(%ebp),%eax
  801606:	40                   	inc    %eax
  801607:	8a 00                	mov    (%eax),%al
  801609:	3c 78                	cmp    $0x78,%al
  80160b:	75 0d                	jne    80161a <strtol+0x78>
		s += 2, base = 16;
  80160d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801611:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801618:	eb 28                	jmp    801642 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80161a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80161e:	75 15                	jne    801635 <strtol+0x93>
  801620:	8b 45 08             	mov    0x8(%ebp),%eax
  801623:	8a 00                	mov    (%eax),%al
  801625:	3c 30                	cmp    $0x30,%al
  801627:	75 0c                	jne    801635 <strtol+0x93>
		s++, base = 8;
  801629:	ff 45 08             	incl   0x8(%ebp)
  80162c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801633:	eb 0d                	jmp    801642 <strtol+0xa0>
	else if (base == 0)
  801635:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801639:	75 07                	jne    801642 <strtol+0xa0>
		base = 10;
  80163b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801642:	8b 45 08             	mov    0x8(%ebp),%eax
  801645:	8a 00                	mov    (%eax),%al
  801647:	3c 2f                	cmp    $0x2f,%al
  801649:	7e 19                	jle    801664 <strtol+0xc2>
  80164b:	8b 45 08             	mov    0x8(%ebp),%eax
  80164e:	8a 00                	mov    (%eax),%al
  801650:	3c 39                	cmp    $0x39,%al
  801652:	7f 10                	jg     801664 <strtol+0xc2>
			dig = *s - '0';
  801654:	8b 45 08             	mov    0x8(%ebp),%eax
  801657:	8a 00                	mov    (%eax),%al
  801659:	0f be c0             	movsbl %al,%eax
  80165c:	83 e8 30             	sub    $0x30,%eax
  80165f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801662:	eb 42                	jmp    8016a6 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801664:	8b 45 08             	mov    0x8(%ebp),%eax
  801667:	8a 00                	mov    (%eax),%al
  801669:	3c 60                	cmp    $0x60,%al
  80166b:	7e 19                	jle    801686 <strtol+0xe4>
  80166d:	8b 45 08             	mov    0x8(%ebp),%eax
  801670:	8a 00                	mov    (%eax),%al
  801672:	3c 7a                	cmp    $0x7a,%al
  801674:	7f 10                	jg     801686 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801676:	8b 45 08             	mov    0x8(%ebp),%eax
  801679:	8a 00                	mov    (%eax),%al
  80167b:	0f be c0             	movsbl %al,%eax
  80167e:	83 e8 57             	sub    $0x57,%eax
  801681:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801684:	eb 20                	jmp    8016a6 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801686:	8b 45 08             	mov    0x8(%ebp),%eax
  801689:	8a 00                	mov    (%eax),%al
  80168b:	3c 40                	cmp    $0x40,%al
  80168d:	7e 39                	jle    8016c8 <strtol+0x126>
  80168f:	8b 45 08             	mov    0x8(%ebp),%eax
  801692:	8a 00                	mov    (%eax),%al
  801694:	3c 5a                	cmp    $0x5a,%al
  801696:	7f 30                	jg     8016c8 <strtol+0x126>
			dig = *s - 'A' + 10;
  801698:	8b 45 08             	mov    0x8(%ebp),%eax
  80169b:	8a 00                	mov    (%eax),%al
  80169d:	0f be c0             	movsbl %al,%eax
  8016a0:	83 e8 37             	sub    $0x37,%eax
  8016a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8016a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a9:	3b 45 10             	cmp    0x10(%ebp),%eax
  8016ac:	7d 19                	jge    8016c7 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8016ae:	ff 45 08             	incl   0x8(%ebp)
  8016b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016b4:	0f af 45 10          	imul   0x10(%ebp),%eax
  8016b8:	89 c2                	mov    %eax,%edx
  8016ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016bd:	01 d0                	add    %edx,%eax
  8016bf:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8016c2:	e9 7b ff ff ff       	jmp    801642 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8016c7:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8016c8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016cc:	74 08                	je     8016d6 <strtol+0x134>
		*endptr = (char *) s;
  8016ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8016d4:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8016d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8016da:	74 07                	je     8016e3 <strtol+0x141>
  8016dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016df:	f7 d8                	neg    %eax
  8016e1:	eb 03                	jmp    8016e6 <strtol+0x144>
  8016e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8016e6:	c9                   	leave  
  8016e7:	c3                   	ret    

008016e8 <ltostr>:

void
ltostr(long value, char *str)
{
  8016e8:	55                   	push   %ebp
  8016e9:	89 e5                	mov    %esp,%ebp
  8016eb:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8016ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8016f5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8016fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801700:	79 13                	jns    801715 <ltostr+0x2d>
	{
		neg = 1;
  801702:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801709:	8b 45 0c             	mov    0xc(%ebp),%eax
  80170c:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80170f:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801712:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801715:	8b 45 08             	mov    0x8(%ebp),%eax
  801718:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80171d:	99                   	cltd   
  80171e:	f7 f9                	idiv   %ecx
  801720:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801723:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801726:	8d 50 01             	lea    0x1(%eax),%edx
  801729:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80172c:	89 c2                	mov    %eax,%edx
  80172e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801731:	01 d0                	add    %edx,%eax
  801733:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801736:	83 c2 30             	add    $0x30,%edx
  801739:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80173b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80173e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801743:	f7 e9                	imul   %ecx
  801745:	c1 fa 02             	sar    $0x2,%edx
  801748:	89 c8                	mov    %ecx,%eax
  80174a:	c1 f8 1f             	sar    $0x1f,%eax
  80174d:	29 c2                	sub    %eax,%edx
  80174f:	89 d0                	mov    %edx,%eax
  801751:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801754:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801757:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80175c:	f7 e9                	imul   %ecx
  80175e:	c1 fa 02             	sar    $0x2,%edx
  801761:	89 c8                	mov    %ecx,%eax
  801763:	c1 f8 1f             	sar    $0x1f,%eax
  801766:	29 c2                	sub    %eax,%edx
  801768:	89 d0                	mov    %edx,%eax
  80176a:	c1 e0 02             	shl    $0x2,%eax
  80176d:	01 d0                	add    %edx,%eax
  80176f:	01 c0                	add    %eax,%eax
  801771:	29 c1                	sub    %eax,%ecx
  801773:	89 ca                	mov    %ecx,%edx
  801775:	85 d2                	test   %edx,%edx
  801777:	75 9c                	jne    801715 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801779:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801780:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801783:	48                   	dec    %eax
  801784:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801787:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80178b:	74 3d                	je     8017ca <ltostr+0xe2>
		start = 1 ;
  80178d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801794:	eb 34                	jmp    8017ca <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801796:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801799:	8b 45 0c             	mov    0xc(%ebp),%eax
  80179c:	01 d0                	add    %edx,%eax
  80179e:	8a 00                	mov    (%eax),%al
  8017a0:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8017a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a9:	01 c2                	add    %eax,%edx
  8017ab:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8017ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017b1:	01 c8                	add    %ecx,%eax
  8017b3:	8a 00                	mov    (%eax),%al
  8017b5:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8017b7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017bd:	01 c2                	add    %eax,%edx
  8017bf:	8a 45 eb             	mov    -0x15(%ebp),%al
  8017c2:	88 02                	mov    %al,(%edx)
		start++ ;
  8017c4:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8017c7:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8017ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017cd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8017d0:	7c c4                	jl     801796 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8017d2:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8017d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d8:	01 d0                	add    %edx,%eax
  8017da:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8017dd:	90                   	nop
  8017de:	c9                   	leave  
  8017df:	c3                   	ret    

008017e0 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
  8017e3:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8017e6:	ff 75 08             	pushl  0x8(%ebp)
  8017e9:	e8 54 fa ff ff       	call   801242 <strlen>
  8017ee:	83 c4 04             	add    $0x4,%esp
  8017f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8017f4:	ff 75 0c             	pushl  0xc(%ebp)
  8017f7:	e8 46 fa ff ff       	call   801242 <strlen>
  8017fc:	83 c4 04             	add    $0x4,%esp
  8017ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801802:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801809:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801810:	eb 17                	jmp    801829 <strcconcat+0x49>
		final[s] = str1[s] ;
  801812:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801815:	8b 45 10             	mov    0x10(%ebp),%eax
  801818:	01 c2                	add    %eax,%edx
  80181a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80181d:	8b 45 08             	mov    0x8(%ebp),%eax
  801820:	01 c8                	add    %ecx,%eax
  801822:	8a 00                	mov    (%eax),%al
  801824:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801826:	ff 45 fc             	incl   -0x4(%ebp)
  801829:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80182c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80182f:	7c e1                	jl     801812 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801831:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801838:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80183f:	eb 1f                	jmp    801860 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801841:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801844:	8d 50 01             	lea    0x1(%eax),%edx
  801847:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80184a:	89 c2                	mov    %eax,%edx
  80184c:	8b 45 10             	mov    0x10(%ebp),%eax
  80184f:	01 c2                	add    %eax,%edx
  801851:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801854:	8b 45 0c             	mov    0xc(%ebp),%eax
  801857:	01 c8                	add    %ecx,%eax
  801859:	8a 00                	mov    (%eax),%al
  80185b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80185d:	ff 45 f8             	incl   -0x8(%ebp)
  801860:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801863:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801866:	7c d9                	jl     801841 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801868:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80186b:	8b 45 10             	mov    0x10(%ebp),%eax
  80186e:	01 d0                	add    %edx,%eax
  801870:	c6 00 00             	movb   $0x0,(%eax)
}
  801873:	90                   	nop
  801874:	c9                   	leave  
  801875:	c3                   	ret    

00801876 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801879:	8b 45 14             	mov    0x14(%ebp),%eax
  80187c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801882:	8b 45 14             	mov    0x14(%ebp),%eax
  801885:	8b 00                	mov    (%eax),%eax
  801887:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80188e:	8b 45 10             	mov    0x10(%ebp),%eax
  801891:	01 d0                	add    %edx,%eax
  801893:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801899:	eb 0c                	jmp    8018a7 <strsplit+0x31>
			*string++ = 0;
  80189b:	8b 45 08             	mov    0x8(%ebp),%eax
  80189e:	8d 50 01             	lea    0x1(%eax),%edx
  8018a1:	89 55 08             	mov    %edx,0x8(%ebp)
  8018a4:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018aa:	8a 00                	mov    (%eax),%al
  8018ac:	84 c0                	test   %al,%al
  8018ae:	74 18                	je     8018c8 <strsplit+0x52>
  8018b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b3:	8a 00                	mov    (%eax),%al
  8018b5:	0f be c0             	movsbl %al,%eax
  8018b8:	50                   	push   %eax
  8018b9:	ff 75 0c             	pushl  0xc(%ebp)
  8018bc:	e8 13 fb ff ff       	call   8013d4 <strchr>
  8018c1:	83 c4 08             	add    $0x8,%esp
  8018c4:	85 c0                	test   %eax,%eax
  8018c6:	75 d3                	jne    80189b <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8018c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cb:	8a 00                	mov    (%eax),%al
  8018cd:	84 c0                	test   %al,%al
  8018cf:	74 5a                	je     80192b <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8018d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8018d4:	8b 00                	mov    (%eax),%eax
  8018d6:	83 f8 0f             	cmp    $0xf,%eax
  8018d9:	75 07                	jne    8018e2 <strsplit+0x6c>
		{
			return 0;
  8018db:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e0:	eb 66                	jmp    801948 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8018e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8018e5:	8b 00                	mov    (%eax),%eax
  8018e7:	8d 48 01             	lea    0x1(%eax),%ecx
  8018ea:	8b 55 14             	mov    0x14(%ebp),%edx
  8018ed:	89 0a                	mov    %ecx,(%edx)
  8018ef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f9:	01 c2                	add    %eax,%edx
  8018fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fe:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801900:	eb 03                	jmp    801905 <strsplit+0x8f>
			string++;
  801902:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801905:	8b 45 08             	mov    0x8(%ebp),%eax
  801908:	8a 00                	mov    (%eax),%al
  80190a:	84 c0                	test   %al,%al
  80190c:	74 8b                	je     801899 <strsplit+0x23>
  80190e:	8b 45 08             	mov    0x8(%ebp),%eax
  801911:	8a 00                	mov    (%eax),%al
  801913:	0f be c0             	movsbl %al,%eax
  801916:	50                   	push   %eax
  801917:	ff 75 0c             	pushl  0xc(%ebp)
  80191a:	e8 b5 fa ff ff       	call   8013d4 <strchr>
  80191f:	83 c4 08             	add    $0x8,%esp
  801922:	85 c0                	test   %eax,%eax
  801924:	74 dc                	je     801902 <strsplit+0x8c>
			string++;
	}
  801926:	e9 6e ff ff ff       	jmp    801899 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80192b:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80192c:	8b 45 14             	mov    0x14(%ebp),%eax
  80192f:	8b 00                	mov    (%eax),%eax
  801931:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801938:	8b 45 10             	mov    0x10(%ebp),%eax
  80193b:	01 d0                	add    %edx,%eax
  80193d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801943:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801948:	c9                   	leave  
  801949:	c3                   	ret    

0080194a <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
  80194d:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801950:	a1 04 50 80 00       	mov    0x805004,%eax
  801955:	85 c0                	test   %eax,%eax
  801957:	74 1f                	je     801978 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801959:	e8 1d 00 00 00       	call   80197b <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80195e:	83 ec 0c             	sub    $0xc,%esp
  801961:	68 90 40 80 00       	push   $0x804090
  801966:	e8 55 f2 ff ff       	call   800bc0 <cprintf>
  80196b:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80196e:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801975:	00 00 00 
	}
}
  801978:	90                   	nop
  801979:	c9                   	leave  
  80197a:	c3                   	ret    

0080197b <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80197b:	55                   	push   %ebp
  80197c:	89 e5                	mov    %esp,%ebp
  80197e:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801981:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801988:	00 00 00 
  80198b:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801992:	00 00 00 
  801995:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  80199c:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  80199f:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  8019a6:	00 00 00 
  8019a9:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  8019b0:	00 00 00 
  8019b3:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8019ba:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  8019bd:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  8019c4:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  8019c7:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  8019ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8019d6:	2d 00 10 00 00       	sub    $0x1000,%eax
  8019db:	a3 50 50 80 00       	mov    %eax,0x805050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  8019e0:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8019e7:	a1 20 51 80 00       	mov    0x805120,%eax
  8019ec:	c1 e0 04             	shl    $0x4,%eax
  8019ef:	89 c2                	mov    %eax,%edx
  8019f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019f4:	01 d0                	add    %edx,%eax
  8019f6:	48                   	dec    %eax
  8019f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8019fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019fd:	ba 00 00 00 00       	mov    $0x0,%edx
  801a02:	f7 75 f0             	divl   -0x10(%ebp)
  801a05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a08:	29 d0                	sub    %edx,%eax
  801a0a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  801a0d:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801a14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a17:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a1c:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a21:	83 ec 04             	sub    $0x4,%esp
  801a24:	6a 06                	push   $0x6
  801a26:	ff 75 e8             	pushl  -0x18(%ebp)
  801a29:	50                   	push   %eax
  801a2a:	e8 b0 05 00 00       	call   801fdf <sys_allocate_chunk>
  801a2f:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801a32:	a1 20 51 80 00       	mov    0x805120,%eax
  801a37:	83 ec 0c             	sub    $0xc,%esp
  801a3a:	50                   	push   %eax
  801a3b:	e8 25 0c 00 00       	call   802665 <initialize_MemBlocksList>
  801a40:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  801a43:	a1 48 51 80 00       	mov    0x805148,%eax
  801a48:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  801a4b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801a4f:	75 14                	jne    801a65 <initialize_dyn_block_system+0xea>
  801a51:	83 ec 04             	sub    $0x4,%esp
  801a54:	68 b5 40 80 00       	push   $0x8040b5
  801a59:	6a 29                	push   $0x29
  801a5b:	68 d3 40 80 00       	push   $0x8040d3
  801a60:	e8 a7 ee ff ff       	call   80090c <_panic>
  801a65:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a68:	8b 00                	mov    (%eax),%eax
  801a6a:	85 c0                	test   %eax,%eax
  801a6c:	74 10                	je     801a7e <initialize_dyn_block_system+0x103>
  801a6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a71:	8b 00                	mov    (%eax),%eax
  801a73:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a76:	8b 52 04             	mov    0x4(%edx),%edx
  801a79:	89 50 04             	mov    %edx,0x4(%eax)
  801a7c:	eb 0b                	jmp    801a89 <initialize_dyn_block_system+0x10e>
  801a7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a81:	8b 40 04             	mov    0x4(%eax),%eax
  801a84:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801a89:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a8c:	8b 40 04             	mov    0x4(%eax),%eax
  801a8f:	85 c0                	test   %eax,%eax
  801a91:	74 0f                	je     801aa2 <initialize_dyn_block_system+0x127>
  801a93:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a96:	8b 40 04             	mov    0x4(%eax),%eax
  801a99:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a9c:	8b 12                	mov    (%edx),%edx
  801a9e:	89 10                	mov    %edx,(%eax)
  801aa0:	eb 0a                	jmp    801aac <initialize_dyn_block_system+0x131>
  801aa2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801aa5:	8b 00                	mov    (%eax),%eax
  801aa7:	a3 48 51 80 00       	mov    %eax,0x805148
  801aac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801aaf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ab5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ab8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801abf:	a1 54 51 80 00       	mov    0x805154,%eax
  801ac4:	48                   	dec    %eax
  801ac5:	a3 54 51 80 00       	mov    %eax,0x805154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  801aca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801acd:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  801ad4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ad7:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  801ade:	83 ec 0c             	sub    $0xc,%esp
  801ae1:	ff 75 e0             	pushl  -0x20(%ebp)
  801ae4:	e8 b9 14 00 00       	call   802fa2 <insert_sorted_with_merge_freeList>
  801ae9:	83 c4 10             	add    $0x10,%esp

}
  801aec:	90                   	nop
  801aed:	c9                   	leave  
  801aee:	c3                   	ret    

00801aef <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801aef:	55                   	push   %ebp
  801af0:	89 e5                	mov    %esp,%ebp
  801af2:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801af5:	e8 50 fe ff ff       	call   80194a <InitializeUHeap>
	if (size == 0) return NULL ;
  801afa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801afe:	75 07                	jne    801b07 <malloc+0x18>
  801b00:	b8 00 00 00 00       	mov    $0x0,%eax
  801b05:	eb 68                	jmp    801b6f <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  801b07:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801b0e:	8b 55 08             	mov    0x8(%ebp),%edx
  801b11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b14:	01 d0                	add    %edx,%eax
  801b16:	48                   	dec    %eax
  801b17:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b1d:	ba 00 00 00 00       	mov    $0x0,%edx
  801b22:	f7 75 f4             	divl   -0xc(%ebp)
  801b25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b28:	29 d0                	sub    %edx,%eax
  801b2a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  801b2d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801b34:	e8 74 08 00 00       	call   8023ad <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b39:	85 c0                	test   %eax,%eax
  801b3b:	74 2d                	je     801b6a <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  801b3d:	83 ec 0c             	sub    $0xc,%esp
  801b40:	ff 75 ec             	pushl  -0x14(%ebp)
  801b43:	e8 52 0e 00 00       	call   80299a <alloc_block_FF>
  801b48:	83 c4 10             	add    $0x10,%esp
  801b4b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  801b4e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801b52:	74 16                	je     801b6a <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  801b54:	83 ec 0c             	sub    $0xc,%esp
  801b57:	ff 75 e8             	pushl  -0x18(%ebp)
  801b5a:	e8 3b 0c 00 00       	call   80279a <insert_sorted_allocList>
  801b5f:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  801b62:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b65:	8b 40 08             	mov    0x8(%eax),%eax
  801b68:	eb 05                	jmp    801b6f <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  801b6a:	b8 00 00 00 00       	mov    $0x0,%eax

}
  801b6f:	c9                   	leave  
  801b70:	c3                   	ret    

00801b71 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801b71:	55                   	push   %ebp
  801b72:	89 e5                	mov    %esp,%ebp
  801b74:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  801b77:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7a:	83 ec 08             	sub    $0x8,%esp
  801b7d:	50                   	push   %eax
  801b7e:	68 40 50 80 00       	push   $0x805040
  801b83:	e8 ba 0b 00 00       	call   802742 <find_block>
  801b88:	83 c4 10             	add    $0x10,%esp
  801b8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  801b8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b91:	8b 40 0c             	mov    0xc(%eax),%eax
  801b94:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  801b97:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b9b:	0f 84 9f 00 00 00    	je     801c40 <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  801ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba4:	83 ec 08             	sub    $0x8,%esp
  801ba7:	ff 75 f0             	pushl  -0x10(%ebp)
  801baa:	50                   	push   %eax
  801bab:	e8 f7 03 00 00       	call   801fa7 <sys_free_user_mem>
  801bb0:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  801bb3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bb7:	75 14                	jne    801bcd <free+0x5c>
  801bb9:	83 ec 04             	sub    $0x4,%esp
  801bbc:	68 b5 40 80 00       	push   $0x8040b5
  801bc1:	6a 6a                	push   $0x6a
  801bc3:	68 d3 40 80 00       	push   $0x8040d3
  801bc8:	e8 3f ed ff ff       	call   80090c <_panic>
  801bcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd0:	8b 00                	mov    (%eax),%eax
  801bd2:	85 c0                	test   %eax,%eax
  801bd4:	74 10                	je     801be6 <free+0x75>
  801bd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd9:	8b 00                	mov    (%eax),%eax
  801bdb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bde:	8b 52 04             	mov    0x4(%edx),%edx
  801be1:	89 50 04             	mov    %edx,0x4(%eax)
  801be4:	eb 0b                	jmp    801bf1 <free+0x80>
  801be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be9:	8b 40 04             	mov    0x4(%eax),%eax
  801bec:	a3 44 50 80 00       	mov    %eax,0x805044
  801bf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bf4:	8b 40 04             	mov    0x4(%eax),%eax
  801bf7:	85 c0                	test   %eax,%eax
  801bf9:	74 0f                	je     801c0a <free+0x99>
  801bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bfe:	8b 40 04             	mov    0x4(%eax),%eax
  801c01:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c04:	8b 12                	mov    (%edx),%edx
  801c06:	89 10                	mov    %edx,(%eax)
  801c08:	eb 0a                	jmp    801c14 <free+0xa3>
  801c0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c0d:	8b 00                	mov    (%eax),%eax
  801c0f:	a3 40 50 80 00       	mov    %eax,0x805040
  801c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c17:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c20:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801c27:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801c2c:	48                   	dec    %eax
  801c2d:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(blk);
  801c32:	83 ec 0c             	sub    $0xc,%esp
  801c35:	ff 75 f4             	pushl  -0xc(%ebp)
  801c38:	e8 65 13 00 00       	call   802fa2 <insert_sorted_with_merge_freeList>
  801c3d:	83 c4 10             	add    $0x10,%esp
	}
}
  801c40:	90                   	nop
  801c41:	c9                   	leave  
  801c42:	c3                   	ret    

00801c43 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
  801c46:	83 ec 28             	sub    $0x28,%esp
  801c49:	8b 45 10             	mov    0x10(%ebp),%eax
  801c4c:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c4f:	e8 f6 fc ff ff       	call   80194a <InitializeUHeap>
	if (size == 0) return NULL ;
  801c54:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c58:	75 0a                	jne    801c64 <smalloc+0x21>
  801c5a:	b8 00 00 00 00       	mov    $0x0,%eax
  801c5f:	e9 af 00 00 00       	jmp    801d13 <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  801c64:	e8 44 07 00 00       	call   8023ad <sys_isUHeapPlacementStrategyFIRSTFIT>
  801c69:	83 f8 01             	cmp    $0x1,%eax
  801c6c:	0f 85 9c 00 00 00    	jne    801d0e <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  801c72:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801c79:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c7f:	01 d0                	add    %edx,%eax
  801c81:	48                   	dec    %eax
  801c82:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c88:	ba 00 00 00 00       	mov    $0x0,%edx
  801c8d:	f7 75 f4             	divl   -0xc(%ebp)
  801c90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c93:	29 d0                	sub    %edx,%eax
  801c95:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  801c98:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  801c9f:	76 07                	jbe    801ca8 <smalloc+0x65>
			return NULL;
  801ca1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ca6:	eb 6b                	jmp    801d13 <smalloc+0xd0>
		blk =alloc_block_FF(size);
  801ca8:	83 ec 0c             	sub    $0xc,%esp
  801cab:	ff 75 0c             	pushl  0xc(%ebp)
  801cae:	e8 e7 0c 00 00       	call   80299a <alloc_block_FF>
  801cb3:	83 c4 10             	add    $0x10,%esp
  801cb6:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  801cb9:	83 ec 0c             	sub    $0xc,%esp
  801cbc:	ff 75 ec             	pushl  -0x14(%ebp)
  801cbf:	e8 d6 0a 00 00       	call   80279a <insert_sorted_allocList>
  801cc4:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  801cc7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ccb:	75 07                	jne    801cd4 <smalloc+0x91>
		{
			return NULL;
  801ccd:	b8 00 00 00 00       	mov    $0x0,%eax
  801cd2:	eb 3f                	jmp    801d13 <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  801cd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cd7:	8b 40 08             	mov    0x8(%eax),%eax
  801cda:	89 c2                	mov    %eax,%edx
  801cdc:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801ce0:	52                   	push   %edx
  801ce1:	50                   	push   %eax
  801ce2:	ff 75 0c             	pushl  0xc(%ebp)
  801ce5:	ff 75 08             	pushl  0x8(%ebp)
  801ce8:	e8 45 04 00 00       	call   802132 <sys_createSharedObject>
  801ced:	83 c4 10             	add    $0x10,%esp
  801cf0:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  801cf3:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801cf7:	74 06                	je     801cff <smalloc+0xbc>
  801cf9:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801cfd:	75 07                	jne    801d06 <smalloc+0xc3>
		{
			return NULL;
  801cff:	b8 00 00 00 00       	mov    $0x0,%eax
  801d04:	eb 0d                	jmp    801d13 <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  801d06:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d09:	8b 40 08             	mov    0x8(%eax),%eax
  801d0c:	eb 05                	jmp    801d13 <smalloc+0xd0>
		}
	}
	else
		return NULL;
  801d0e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d13:	c9                   	leave  
  801d14:	c3                   	ret    

00801d15 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
  801d18:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d1b:	e8 2a fc ff ff       	call   80194a <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801d20:	83 ec 08             	sub    $0x8,%esp
  801d23:	ff 75 0c             	pushl  0xc(%ebp)
  801d26:	ff 75 08             	pushl  0x8(%ebp)
  801d29:	e8 2e 04 00 00       	call   80215c <sys_getSizeOfSharedObject>
  801d2e:	83 c4 10             	add    $0x10,%esp
  801d31:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  801d34:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801d38:	75 0a                	jne    801d44 <sget+0x2f>
	{
		return NULL;
  801d3a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d3f:	e9 94 00 00 00       	jmp    801dd8 <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801d44:	e8 64 06 00 00       	call   8023ad <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d49:	85 c0                	test   %eax,%eax
  801d4b:	0f 84 82 00 00 00    	je     801dd3 <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  801d51:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  801d58:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801d5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d65:	01 d0                	add    %edx,%eax
  801d67:	48                   	dec    %eax
  801d68:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801d6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d6e:	ba 00 00 00 00       	mov    $0x0,%edx
  801d73:	f7 75 ec             	divl   -0x14(%ebp)
  801d76:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d79:	29 d0                	sub    %edx,%eax
  801d7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  801d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d81:	83 ec 0c             	sub    $0xc,%esp
  801d84:	50                   	push   %eax
  801d85:	e8 10 0c 00 00       	call   80299a <alloc_block_FF>
  801d8a:	83 c4 10             	add    $0x10,%esp
  801d8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  801d90:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d94:	75 07                	jne    801d9d <sget+0x88>
		{
			return NULL;
  801d96:	b8 00 00 00 00       	mov    $0x0,%eax
  801d9b:	eb 3b                	jmp    801dd8 <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  801d9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801da0:	8b 40 08             	mov    0x8(%eax),%eax
  801da3:	83 ec 04             	sub    $0x4,%esp
  801da6:	50                   	push   %eax
  801da7:	ff 75 0c             	pushl  0xc(%ebp)
  801daa:	ff 75 08             	pushl  0x8(%ebp)
  801dad:	e8 c7 03 00 00       	call   802179 <sys_getSharedObject>
  801db2:	83 c4 10             	add    $0x10,%esp
  801db5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  801db8:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801dbc:	74 06                	je     801dc4 <sget+0xaf>
  801dbe:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  801dc2:	75 07                	jne    801dcb <sget+0xb6>
		{
			return NULL;
  801dc4:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc9:	eb 0d                	jmp    801dd8 <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  801dcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dce:	8b 40 08             	mov    0x8(%eax),%eax
  801dd1:	eb 05                	jmp    801dd8 <sget+0xc3>
		}
	}
	else
			return NULL;
  801dd3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dd8:	c9                   	leave  
  801dd9:	c3                   	ret    

00801dda <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801dda:	55                   	push   %ebp
  801ddb:	89 e5                	mov    %esp,%ebp
  801ddd:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801de0:	e8 65 fb ff ff       	call   80194a <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801de5:	83 ec 04             	sub    $0x4,%esp
  801de8:	68 e0 40 80 00       	push   $0x8040e0
  801ded:	68 e1 00 00 00       	push   $0xe1
  801df2:	68 d3 40 80 00       	push   $0x8040d3
  801df7:	e8 10 eb ff ff       	call   80090c <_panic>

00801dfc <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801dfc:	55                   	push   %ebp
  801dfd:	89 e5                	mov    %esp,%ebp
  801dff:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801e02:	83 ec 04             	sub    $0x4,%esp
  801e05:	68 08 41 80 00       	push   $0x804108
  801e0a:	68 f5 00 00 00       	push   $0xf5
  801e0f:	68 d3 40 80 00       	push   $0x8040d3
  801e14:	e8 f3 ea ff ff       	call   80090c <_panic>

00801e19 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801e19:	55                   	push   %ebp
  801e1a:	89 e5                	mov    %esp,%ebp
  801e1c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e1f:	83 ec 04             	sub    $0x4,%esp
  801e22:	68 2c 41 80 00       	push   $0x80412c
  801e27:	68 00 01 00 00       	push   $0x100
  801e2c:	68 d3 40 80 00       	push   $0x8040d3
  801e31:	e8 d6 ea ff ff       	call   80090c <_panic>

00801e36 <shrink>:

}
void shrink(uint32 newSize)
{
  801e36:	55                   	push   %ebp
  801e37:	89 e5                	mov    %esp,%ebp
  801e39:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e3c:	83 ec 04             	sub    $0x4,%esp
  801e3f:	68 2c 41 80 00       	push   $0x80412c
  801e44:	68 05 01 00 00       	push   $0x105
  801e49:	68 d3 40 80 00       	push   $0x8040d3
  801e4e:	e8 b9 ea ff ff       	call   80090c <_panic>

00801e53 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801e53:	55                   	push   %ebp
  801e54:	89 e5                	mov    %esp,%ebp
  801e56:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e59:	83 ec 04             	sub    $0x4,%esp
  801e5c:	68 2c 41 80 00       	push   $0x80412c
  801e61:	68 0a 01 00 00       	push   $0x10a
  801e66:	68 d3 40 80 00       	push   $0x8040d3
  801e6b:	e8 9c ea ff ff       	call   80090c <_panic>

00801e70 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801e70:	55                   	push   %ebp
  801e71:	89 e5                	mov    %esp,%ebp
  801e73:	57                   	push   %edi
  801e74:	56                   	push   %esi
  801e75:	53                   	push   %ebx
  801e76:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801e79:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e7f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e82:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e85:	8b 7d 18             	mov    0x18(%ebp),%edi
  801e88:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801e8b:	cd 30                	int    $0x30
  801e8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801e90:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801e93:	83 c4 10             	add    $0x10,%esp
  801e96:	5b                   	pop    %ebx
  801e97:	5e                   	pop    %esi
  801e98:	5f                   	pop    %edi
  801e99:	5d                   	pop    %ebp
  801e9a:	c3                   	ret    

00801e9b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801e9b:	55                   	push   %ebp
  801e9c:	89 e5                	mov    %esp,%ebp
  801e9e:	83 ec 04             	sub    $0x4,%esp
  801ea1:	8b 45 10             	mov    0x10(%ebp),%eax
  801ea4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801ea7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801eab:	8b 45 08             	mov    0x8(%ebp),%eax
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	52                   	push   %edx
  801eb3:	ff 75 0c             	pushl  0xc(%ebp)
  801eb6:	50                   	push   %eax
  801eb7:	6a 00                	push   $0x0
  801eb9:	e8 b2 ff ff ff       	call   801e70 <syscall>
  801ebe:	83 c4 18             	add    $0x18,%esp
}
  801ec1:	90                   	nop
  801ec2:	c9                   	leave  
  801ec3:	c3                   	ret    

00801ec4 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ec4:	55                   	push   %ebp
  801ec5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 01                	push   $0x1
  801ed3:	e8 98 ff ff ff       	call   801e70 <syscall>
  801ed8:	83 c4 18             	add    $0x18,%esp
}
  801edb:	c9                   	leave  
  801edc:	c3                   	ret    

00801edd <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801edd:	55                   	push   %ebp
  801ede:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801ee0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 00                	push   $0x0
  801eea:	6a 00                	push   $0x0
  801eec:	52                   	push   %edx
  801eed:	50                   	push   %eax
  801eee:	6a 05                	push   $0x5
  801ef0:	e8 7b ff ff ff       	call   801e70 <syscall>
  801ef5:	83 c4 18             	add    $0x18,%esp
}
  801ef8:	c9                   	leave  
  801ef9:	c3                   	ret    

00801efa <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801efa:	55                   	push   %ebp
  801efb:	89 e5                	mov    %esp,%ebp
  801efd:	56                   	push   %esi
  801efe:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801eff:	8b 75 18             	mov    0x18(%ebp),%esi
  801f02:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f05:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f08:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0e:	56                   	push   %esi
  801f0f:	53                   	push   %ebx
  801f10:	51                   	push   %ecx
  801f11:	52                   	push   %edx
  801f12:	50                   	push   %eax
  801f13:	6a 06                	push   $0x6
  801f15:	e8 56 ff ff ff       	call   801e70 <syscall>
  801f1a:	83 c4 18             	add    $0x18,%esp
}
  801f1d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f20:	5b                   	pop    %ebx
  801f21:	5e                   	pop    %esi
  801f22:	5d                   	pop    %ebp
  801f23:	c3                   	ret    

00801f24 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801f24:	55                   	push   %ebp
  801f25:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801f27:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2d:	6a 00                	push   $0x0
  801f2f:	6a 00                	push   $0x0
  801f31:	6a 00                	push   $0x0
  801f33:	52                   	push   %edx
  801f34:	50                   	push   %eax
  801f35:	6a 07                	push   $0x7
  801f37:	e8 34 ff ff ff       	call   801e70 <syscall>
  801f3c:	83 c4 18             	add    $0x18,%esp
}
  801f3f:	c9                   	leave  
  801f40:	c3                   	ret    

00801f41 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801f41:	55                   	push   %ebp
  801f42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801f44:	6a 00                	push   $0x0
  801f46:	6a 00                	push   $0x0
  801f48:	6a 00                	push   $0x0
  801f4a:	ff 75 0c             	pushl  0xc(%ebp)
  801f4d:	ff 75 08             	pushl  0x8(%ebp)
  801f50:	6a 08                	push   $0x8
  801f52:	e8 19 ff ff ff       	call   801e70 <syscall>
  801f57:	83 c4 18             	add    $0x18,%esp
}
  801f5a:	c9                   	leave  
  801f5b:	c3                   	ret    

00801f5c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801f5c:	55                   	push   %ebp
  801f5d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801f5f:	6a 00                	push   $0x0
  801f61:	6a 00                	push   $0x0
  801f63:	6a 00                	push   $0x0
  801f65:	6a 00                	push   $0x0
  801f67:	6a 00                	push   $0x0
  801f69:	6a 09                	push   $0x9
  801f6b:	e8 00 ff ff ff       	call   801e70 <syscall>
  801f70:	83 c4 18             	add    $0x18,%esp
}
  801f73:	c9                   	leave  
  801f74:	c3                   	ret    

00801f75 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801f75:	55                   	push   %ebp
  801f76:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801f78:	6a 00                	push   $0x0
  801f7a:	6a 00                	push   $0x0
  801f7c:	6a 00                	push   $0x0
  801f7e:	6a 00                	push   $0x0
  801f80:	6a 00                	push   $0x0
  801f82:	6a 0a                	push   $0xa
  801f84:	e8 e7 fe ff ff       	call   801e70 <syscall>
  801f89:	83 c4 18             	add    $0x18,%esp
}
  801f8c:	c9                   	leave  
  801f8d:	c3                   	ret    

00801f8e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801f8e:	55                   	push   %ebp
  801f8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801f91:	6a 00                	push   $0x0
  801f93:	6a 00                	push   $0x0
  801f95:	6a 00                	push   $0x0
  801f97:	6a 00                	push   $0x0
  801f99:	6a 00                	push   $0x0
  801f9b:	6a 0b                	push   $0xb
  801f9d:	e8 ce fe ff ff       	call   801e70 <syscall>
  801fa2:	83 c4 18             	add    $0x18,%esp
}
  801fa5:	c9                   	leave  
  801fa6:	c3                   	ret    

00801fa7 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801fa7:	55                   	push   %ebp
  801fa8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801faa:	6a 00                	push   $0x0
  801fac:	6a 00                	push   $0x0
  801fae:	6a 00                	push   $0x0
  801fb0:	ff 75 0c             	pushl  0xc(%ebp)
  801fb3:	ff 75 08             	pushl  0x8(%ebp)
  801fb6:	6a 0f                	push   $0xf
  801fb8:	e8 b3 fe ff ff       	call   801e70 <syscall>
  801fbd:	83 c4 18             	add    $0x18,%esp
	return;
  801fc0:	90                   	nop
}
  801fc1:	c9                   	leave  
  801fc2:	c3                   	ret    

00801fc3 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801fc3:	55                   	push   %ebp
  801fc4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801fc6:	6a 00                	push   $0x0
  801fc8:	6a 00                	push   $0x0
  801fca:	6a 00                	push   $0x0
  801fcc:	ff 75 0c             	pushl  0xc(%ebp)
  801fcf:	ff 75 08             	pushl  0x8(%ebp)
  801fd2:	6a 10                	push   $0x10
  801fd4:	e8 97 fe ff ff       	call   801e70 <syscall>
  801fd9:	83 c4 18             	add    $0x18,%esp
	return ;
  801fdc:	90                   	nop
}
  801fdd:	c9                   	leave  
  801fde:	c3                   	ret    

00801fdf <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801fdf:	55                   	push   %ebp
  801fe0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801fe2:	6a 00                	push   $0x0
  801fe4:	6a 00                	push   $0x0
  801fe6:	ff 75 10             	pushl  0x10(%ebp)
  801fe9:	ff 75 0c             	pushl  0xc(%ebp)
  801fec:	ff 75 08             	pushl  0x8(%ebp)
  801fef:	6a 11                	push   $0x11
  801ff1:	e8 7a fe ff ff       	call   801e70 <syscall>
  801ff6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ff9:	90                   	nop
}
  801ffa:	c9                   	leave  
  801ffb:	c3                   	ret    

00801ffc <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ffc:	55                   	push   %ebp
  801ffd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801fff:	6a 00                	push   $0x0
  802001:	6a 00                	push   $0x0
  802003:	6a 00                	push   $0x0
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	6a 0c                	push   $0xc
  80200b:	e8 60 fe ff ff       	call   801e70 <syscall>
  802010:	83 c4 18             	add    $0x18,%esp
}
  802013:	c9                   	leave  
  802014:	c3                   	ret    

00802015 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802015:	55                   	push   %ebp
  802016:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802018:	6a 00                	push   $0x0
  80201a:	6a 00                	push   $0x0
  80201c:	6a 00                	push   $0x0
  80201e:	6a 00                	push   $0x0
  802020:	ff 75 08             	pushl  0x8(%ebp)
  802023:	6a 0d                	push   $0xd
  802025:	e8 46 fe ff ff       	call   801e70 <syscall>
  80202a:	83 c4 18             	add    $0x18,%esp
}
  80202d:	c9                   	leave  
  80202e:	c3                   	ret    

0080202f <sys_scarce_memory>:

void sys_scarce_memory()
{
  80202f:	55                   	push   %ebp
  802030:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802032:	6a 00                	push   $0x0
  802034:	6a 00                	push   $0x0
  802036:	6a 00                	push   $0x0
  802038:	6a 00                	push   $0x0
  80203a:	6a 00                	push   $0x0
  80203c:	6a 0e                	push   $0xe
  80203e:	e8 2d fe ff ff       	call   801e70 <syscall>
  802043:	83 c4 18             	add    $0x18,%esp
}
  802046:	90                   	nop
  802047:	c9                   	leave  
  802048:	c3                   	ret    

00802049 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802049:	55                   	push   %ebp
  80204a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80204c:	6a 00                	push   $0x0
  80204e:	6a 00                	push   $0x0
  802050:	6a 00                	push   $0x0
  802052:	6a 00                	push   $0x0
  802054:	6a 00                	push   $0x0
  802056:	6a 13                	push   $0x13
  802058:	e8 13 fe ff ff       	call   801e70 <syscall>
  80205d:	83 c4 18             	add    $0x18,%esp
}
  802060:	90                   	nop
  802061:	c9                   	leave  
  802062:	c3                   	ret    

00802063 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802063:	55                   	push   %ebp
  802064:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802066:	6a 00                	push   $0x0
  802068:	6a 00                	push   $0x0
  80206a:	6a 00                	push   $0x0
  80206c:	6a 00                	push   $0x0
  80206e:	6a 00                	push   $0x0
  802070:	6a 14                	push   $0x14
  802072:	e8 f9 fd ff ff       	call   801e70 <syscall>
  802077:	83 c4 18             	add    $0x18,%esp
}
  80207a:	90                   	nop
  80207b:	c9                   	leave  
  80207c:	c3                   	ret    

0080207d <sys_cputc>:


void
sys_cputc(const char c)
{
  80207d:	55                   	push   %ebp
  80207e:	89 e5                	mov    %esp,%ebp
  802080:	83 ec 04             	sub    $0x4,%esp
  802083:	8b 45 08             	mov    0x8(%ebp),%eax
  802086:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802089:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80208d:	6a 00                	push   $0x0
  80208f:	6a 00                	push   $0x0
  802091:	6a 00                	push   $0x0
  802093:	6a 00                	push   $0x0
  802095:	50                   	push   %eax
  802096:	6a 15                	push   $0x15
  802098:	e8 d3 fd ff ff       	call   801e70 <syscall>
  80209d:	83 c4 18             	add    $0x18,%esp
}
  8020a0:	90                   	nop
  8020a1:	c9                   	leave  
  8020a2:	c3                   	ret    

008020a3 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8020a3:	55                   	push   %ebp
  8020a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8020a6:	6a 00                	push   $0x0
  8020a8:	6a 00                	push   $0x0
  8020aa:	6a 00                	push   $0x0
  8020ac:	6a 00                	push   $0x0
  8020ae:	6a 00                	push   $0x0
  8020b0:	6a 16                	push   $0x16
  8020b2:	e8 b9 fd ff ff       	call   801e70 <syscall>
  8020b7:	83 c4 18             	add    $0x18,%esp
}
  8020ba:	90                   	nop
  8020bb:	c9                   	leave  
  8020bc:	c3                   	ret    

008020bd <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8020bd:	55                   	push   %ebp
  8020be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8020c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c3:	6a 00                	push   $0x0
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 00                	push   $0x0
  8020c9:	ff 75 0c             	pushl  0xc(%ebp)
  8020cc:	50                   	push   %eax
  8020cd:	6a 17                	push   $0x17
  8020cf:	e8 9c fd ff ff       	call   801e70 <syscall>
  8020d4:	83 c4 18             	add    $0x18,%esp
}
  8020d7:	c9                   	leave  
  8020d8:	c3                   	ret    

008020d9 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8020d9:	55                   	push   %ebp
  8020da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8020dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020df:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e2:	6a 00                	push   $0x0
  8020e4:	6a 00                	push   $0x0
  8020e6:	6a 00                	push   $0x0
  8020e8:	52                   	push   %edx
  8020e9:	50                   	push   %eax
  8020ea:	6a 1a                	push   $0x1a
  8020ec:	e8 7f fd ff ff       	call   801e70 <syscall>
  8020f1:	83 c4 18             	add    $0x18,%esp
}
  8020f4:	c9                   	leave  
  8020f5:	c3                   	ret    

008020f6 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8020f6:	55                   	push   %ebp
  8020f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8020f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ff:	6a 00                	push   $0x0
  802101:	6a 00                	push   $0x0
  802103:	6a 00                	push   $0x0
  802105:	52                   	push   %edx
  802106:	50                   	push   %eax
  802107:	6a 18                	push   $0x18
  802109:	e8 62 fd ff ff       	call   801e70 <syscall>
  80210e:	83 c4 18             	add    $0x18,%esp
}
  802111:	90                   	nop
  802112:	c9                   	leave  
  802113:	c3                   	ret    

00802114 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802114:	55                   	push   %ebp
  802115:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802117:	8b 55 0c             	mov    0xc(%ebp),%edx
  80211a:	8b 45 08             	mov    0x8(%ebp),%eax
  80211d:	6a 00                	push   $0x0
  80211f:	6a 00                	push   $0x0
  802121:	6a 00                	push   $0x0
  802123:	52                   	push   %edx
  802124:	50                   	push   %eax
  802125:	6a 19                	push   $0x19
  802127:	e8 44 fd ff ff       	call   801e70 <syscall>
  80212c:	83 c4 18             	add    $0x18,%esp
}
  80212f:	90                   	nop
  802130:	c9                   	leave  
  802131:	c3                   	ret    

00802132 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802132:	55                   	push   %ebp
  802133:	89 e5                	mov    %esp,%ebp
  802135:	83 ec 04             	sub    $0x4,%esp
  802138:	8b 45 10             	mov    0x10(%ebp),%eax
  80213b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80213e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802141:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802145:	8b 45 08             	mov    0x8(%ebp),%eax
  802148:	6a 00                	push   $0x0
  80214a:	51                   	push   %ecx
  80214b:	52                   	push   %edx
  80214c:	ff 75 0c             	pushl  0xc(%ebp)
  80214f:	50                   	push   %eax
  802150:	6a 1b                	push   $0x1b
  802152:	e8 19 fd ff ff       	call   801e70 <syscall>
  802157:	83 c4 18             	add    $0x18,%esp
}
  80215a:	c9                   	leave  
  80215b:	c3                   	ret    

0080215c <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80215c:	55                   	push   %ebp
  80215d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80215f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802162:	8b 45 08             	mov    0x8(%ebp),%eax
  802165:	6a 00                	push   $0x0
  802167:	6a 00                	push   $0x0
  802169:	6a 00                	push   $0x0
  80216b:	52                   	push   %edx
  80216c:	50                   	push   %eax
  80216d:	6a 1c                	push   $0x1c
  80216f:	e8 fc fc ff ff       	call   801e70 <syscall>
  802174:	83 c4 18             	add    $0x18,%esp
}
  802177:	c9                   	leave  
  802178:	c3                   	ret    

00802179 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802179:	55                   	push   %ebp
  80217a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80217c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80217f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802182:	8b 45 08             	mov    0x8(%ebp),%eax
  802185:	6a 00                	push   $0x0
  802187:	6a 00                	push   $0x0
  802189:	51                   	push   %ecx
  80218a:	52                   	push   %edx
  80218b:	50                   	push   %eax
  80218c:	6a 1d                	push   $0x1d
  80218e:	e8 dd fc ff ff       	call   801e70 <syscall>
  802193:	83 c4 18             	add    $0x18,%esp
}
  802196:	c9                   	leave  
  802197:	c3                   	ret    

00802198 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802198:	55                   	push   %ebp
  802199:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80219b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80219e:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a1:	6a 00                	push   $0x0
  8021a3:	6a 00                	push   $0x0
  8021a5:	6a 00                	push   $0x0
  8021a7:	52                   	push   %edx
  8021a8:	50                   	push   %eax
  8021a9:	6a 1e                	push   $0x1e
  8021ab:	e8 c0 fc ff ff       	call   801e70 <syscall>
  8021b0:	83 c4 18             	add    $0x18,%esp
}
  8021b3:	c9                   	leave  
  8021b4:	c3                   	ret    

008021b5 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8021b5:	55                   	push   %ebp
  8021b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8021b8:	6a 00                	push   $0x0
  8021ba:	6a 00                	push   $0x0
  8021bc:	6a 00                	push   $0x0
  8021be:	6a 00                	push   $0x0
  8021c0:	6a 00                	push   $0x0
  8021c2:	6a 1f                	push   $0x1f
  8021c4:	e8 a7 fc ff ff       	call   801e70 <syscall>
  8021c9:	83 c4 18             	add    $0x18,%esp
}
  8021cc:	c9                   	leave  
  8021cd:	c3                   	ret    

008021ce <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8021ce:	55                   	push   %ebp
  8021cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8021d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d4:	6a 00                	push   $0x0
  8021d6:	ff 75 14             	pushl  0x14(%ebp)
  8021d9:	ff 75 10             	pushl  0x10(%ebp)
  8021dc:	ff 75 0c             	pushl  0xc(%ebp)
  8021df:	50                   	push   %eax
  8021e0:	6a 20                	push   $0x20
  8021e2:	e8 89 fc ff ff       	call   801e70 <syscall>
  8021e7:	83 c4 18             	add    $0x18,%esp
}
  8021ea:	c9                   	leave  
  8021eb:	c3                   	ret    

008021ec <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8021ec:	55                   	push   %ebp
  8021ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8021ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f2:	6a 00                	push   $0x0
  8021f4:	6a 00                	push   $0x0
  8021f6:	6a 00                	push   $0x0
  8021f8:	6a 00                	push   $0x0
  8021fa:	50                   	push   %eax
  8021fb:	6a 21                	push   $0x21
  8021fd:	e8 6e fc ff ff       	call   801e70 <syscall>
  802202:	83 c4 18             	add    $0x18,%esp
}
  802205:	90                   	nop
  802206:	c9                   	leave  
  802207:	c3                   	ret    

00802208 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802208:	55                   	push   %ebp
  802209:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80220b:	8b 45 08             	mov    0x8(%ebp),%eax
  80220e:	6a 00                	push   $0x0
  802210:	6a 00                	push   $0x0
  802212:	6a 00                	push   $0x0
  802214:	6a 00                	push   $0x0
  802216:	50                   	push   %eax
  802217:	6a 22                	push   $0x22
  802219:	e8 52 fc ff ff       	call   801e70 <syscall>
  80221e:	83 c4 18             	add    $0x18,%esp
}
  802221:	c9                   	leave  
  802222:	c3                   	ret    

00802223 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802223:	55                   	push   %ebp
  802224:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802226:	6a 00                	push   $0x0
  802228:	6a 00                	push   $0x0
  80222a:	6a 00                	push   $0x0
  80222c:	6a 00                	push   $0x0
  80222e:	6a 00                	push   $0x0
  802230:	6a 02                	push   $0x2
  802232:	e8 39 fc ff ff       	call   801e70 <syscall>
  802237:	83 c4 18             	add    $0x18,%esp
}
  80223a:	c9                   	leave  
  80223b:	c3                   	ret    

0080223c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80223c:	55                   	push   %ebp
  80223d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80223f:	6a 00                	push   $0x0
  802241:	6a 00                	push   $0x0
  802243:	6a 00                	push   $0x0
  802245:	6a 00                	push   $0x0
  802247:	6a 00                	push   $0x0
  802249:	6a 03                	push   $0x3
  80224b:	e8 20 fc ff ff       	call   801e70 <syscall>
  802250:	83 c4 18             	add    $0x18,%esp
}
  802253:	c9                   	leave  
  802254:	c3                   	ret    

00802255 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802255:	55                   	push   %ebp
  802256:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802258:	6a 00                	push   $0x0
  80225a:	6a 00                	push   $0x0
  80225c:	6a 00                	push   $0x0
  80225e:	6a 00                	push   $0x0
  802260:	6a 00                	push   $0x0
  802262:	6a 04                	push   $0x4
  802264:	e8 07 fc ff ff       	call   801e70 <syscall>
  802269:	83 c4 18             	add    $0x18,%esp
}
  80226c:	c9                   	leave  
  80226d:	c3                   	ret    

0080226e <sys_exit_env>:


void sys_exit_env(void)
{
  80226e:	55                   	push   %ebp
  80226f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802271:	6a 00                	push   $0x0
  802273:	6a 00                	push   $0x0
  802275:	6a 00                	push   $0x0
  802277:	6a 00                	push   $0x0
  802279:	6a 00                	push   $0x0
  80227b:	6a 23                	push   $0x23
  80227d:	e8 ee fb ff ff       	call   801e70 <syscall>
  802282:	83 c4 18             	add    $0x18,%esp
}
  802285:	90                   	nop
  802286:	c9                   	leave  
  802287:	c3                   	ret    

00802288 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802288:	55                   	push   %ebp
  802289:	89 e5                	mov    %esp,%ebp
  80228b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80228e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802291:	8d 50 04             	lea    0x4(%eax),%edx
  802294:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802297:	6a 00                	push   $0x0
  802299:	6a 00                	push   $0x0
  80229b:	6a 00                	push   $0x0
  80229d:	52                   	push   %edx
  80229e:	50                   	push   %eax
  80229f:	6a 24                	push   $0x24
  8022a1:	e8 ca fb ff ff       	call   801e70 <syscall>
  8022a6:	83 c4 18             	add    $0x18,%esp
	return result;
  8022a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022af:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022b2:	89 01                	mov    %eax,(%ecx)
  8022b4:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8022b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ba:	c9                   	leave  
  8022bb:	c2 04 00             	ret    $0x4

008022be <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8022be:	55                   	push   %ebp
  8022bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8022c1:	6a 00                	push   $0x0
  8022c3:	6a 00                	push   $0x0
  8022c5:	ff 75 10             	pushl  0x10(%ebp)
  8022c8:	ff 75 0c             	pushl  0xc(%ebp)
  8022cb:	ff 75 08             	pushl  0x8(%ebp)
  8022ce:	6a 12                	push   $0x12
  8022d0:	e8 9b fb ff ff       	call   801e70 <syscall>
  8022d5:	83 c4 18             	add    $0x18,%esp
	return ;
  8022d8:	90                   	nop
}
  8022d9:	c9                   	leave  
  8022da:	c3                   	ret    

008022db <sys_rcr2>:
uint32 sys_rcr2()
{
  8022db:	55                   	push   %ebp
  8022dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8022de:	6a 00                	push   $0x0
  8022e0:	6a 00                	push   $0x0
  8022e2:	6a 00                	push   $0x0
  8022e4:	6a 00                	push   $0x0
  8022e6:	6a 00                	push   $0x0
  8022e8:	6a 25                	push   $0x25
  8022ea:	e8 81 fb ff ff       	call   801e70 <syscall>
  8022ef:	83 c4 18             	add    $0x18,%esp
}
  8022f2:	c9                   	leave  
  8022f3:	c3                   	ret    

008022f4 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8022f4:	55                   	push   %ebp
  8022f5:	89 e5                	mov    %esp,%ebp
  8022f7:	83 ec 04             	sub    $0x4,%esp
  8022fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802300:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802304:	6a 00                	push   $0x0
  802306:	6a 00                	push   $0x0
  802308:	6a 00                	push   $0x0
  80230a:	6a 00                	push   $0x0
  80230c:	50                   	push   %eax
  80230d:	6a 26                	push   $0x26
  80230f:	e8 5c fb ff ff       	call   801e70 <syscall>
  802314:	83 c4 18             	add    $0x18,%esp
	return ;
  802317:	90                   	nop
}
  802318:	c9                   	leave  
  802319:	c3                   	ret    

0080231a <rsttst>:
void rsttst()
{
  80231a:	55                   	push   %ebp
  80231b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80231d:	6a 00                	push   $0x0
  80231f:	6a 00                	push   $0x0
  802321:	6a 00                	push   $0x0
  802323:	6a 00                	push   $0x0
  802325:	6a 00                	push   $0x0
  802327:	6a 28                	push   $0x28
  802329:	e8 42 fb ff ff       	call   801e70 <syscall>
  80232e:	83 c4 18             	add    $0x18,%esp
	return ;
  802331:	90                   	nop
}
  802332:	c9                   	leave  
  802333:	c3                   	ret    

00802334 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802334:	55                   	push   %ebp
  802335:	89 e5                	mov    %esp,%ebp
  802337:	83 ec 04             	sub    $0x4,%esp
  80233a:	8b 45 14             	mov    0x14(%ebp),%eax
  80233d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802340:	8b 55 18             	mov    0x18(%ebp),%edx
  802343:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802347:	52                   	push   %edx
  802348:	50                   	push   %eax
  802349:	ff 75 10             	pushl  0x10(%ebp)
  80234c:	ff 75 0c             	pushl  0xc(%ebp)
  80234f:	ff 75 08             	pushl  0x8(%ebp)
  802352:	6a 27                	push   $0x27
  802354:	e8 17 fb ff ff       	call   801e70 <syscall>
  802359:	83 c4 18             	add    $0x18,%esp
	return ;
  80235c:	90                   	nop
}
  80235d:	c9                   	leave  
  80235e:	c3                   	ret    

0080235f <chktst>:
void chktst(uint32 n)
{
  80235f:	55                   	push   %ebp
  802360:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802362:	6a 00                	push   $0x0
  802364:	6a 00                	push   $0x0
  802366:	6a 00                	push   $0x0
  802368:	6a 00                	push   $0x0
  80236a:	ff 75 08             	pushl  0x8(%ebp)
  80236d:	6a 29                	push   $0x29
  80236f:	e8 fc fa ff ff       	call   801e70 <syscall>
  802374:	83 c4 18             	add    $0x18,%esp
	return ;
  802377:	90                   	nop
}
  802378:	c9                   	leave  
  802379:	c3                   	ret    

0080237a <inctst>:

void inctst()
{
  80237a:	55                   	push   %ebp
  80237b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80237d:	6a 00                	push   $0x0
  80237f:	6a 00                	push   $0x0
  802381:	6a 00                	push   $0x0
  802383:	6a 00                	push   $0x0
  802385:	6a 00                	push   $0x0
  802387:	6a 2a                	push   $0x2a
  802389:	e8 e2 fa ff ff       	call   801e70 <syscall>
  80238e:	83 c4 18             	add    $0x18,%esp
	return ;
  802391:	90                   	nop
}
  802392:	c9                   	leave  
  802393:	c3                   	ret    

00802394 <gettst>:
uint32 gettst()
{
  802394:	55                   	push   %ebp
  802395:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802397:	6a 00                	push   $0x0
  802399:	6a 00                	push   $0x0
  80239b:	6a 00                	push   $0x0
  80239d:	6a 00                	push   $0x0
  80239f:	6a 00                	push   $0x0
  8023a1:	6a 2b                	push   $0x2b
  8023a3:	e8 c8 fa ff ff       	call   801e70 <syscall>
  8023a8:	83 c4 18             	add    $0x18,%esp
}
  8023ab:	c9                   	leave  
  8023ac:	c3                   	ret    

008023ad <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8023ad:	55                   	push   %ebp
  8023ae:	89 e5                	mov    %esp,%ebp
  8023b0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023b3:	6a 00                	push   $0x0
  8023b5:	6a 00                	push   $0x0
  8023b7:	6a 00                	push   $0x0
  8023b9:	6a 00                	push   $0x0
  8023bb:	6a 00                	push   $0x0
  8023bd:	6a 2c                	push   $0x2c
  8023bf:	e8 ac fa ff ff       	call   801e70 <syscall>
  8023c4:	83 c4 18             	add    $0x18,%esp
  8023c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8023ca:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8023ce:	75 07                	jne    8023d7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8023d0:	b8 01 00 00 00       	mov    $0x1,%eax
  8023d5:	eb 05                	jmp    8023dc <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8023d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023dc:	c9                   	leave  
  8023dd:	c3                   	ret    

008023de <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8023de:	55                   	push   %ebp
  8023df:	89 e5                	mov    %esp,%ebp
  8023e1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023e4:	6a 00                	push   $0x0
  8023e6:	6a 00                	push   $0x0
  8023e8:	6a 00                	push   $0x0
  8023ea:	6a 00                	push   $0x0
  8023ec:	6a 00                	push   $0x0
  8023ee:	6a 2c                	push   $0x2c
  8023f0:	e8 7b fa ff ff       	call   801e70 <syscall>
  8023f5:	83 c4 18             	add    $0x18,%esp
  8023f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8023fb:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8023ff:	75 07                	jne    802408 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802401:	b8 01 00 00 00       	mov    $0x1,%eax
  802406:	eb 05                	jmp    80240d <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802408:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80240d:	c9                   	leave  
  80240e:	c3                   	ret    

0080240f <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80240f:	55                   	push   %ebp
  802410:	89 e5                	mov    %esp,%ebp
  802412:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802415:	6a 00                	push   $0x0
  802417:	6a 00                	push   $0x0
  802419:	6a 00                	push   $0x0
  80241b:	6a 00                	push   $0x0
  80241d:	6a 00                	push   $0x0
  80241f:	6a 2c                	push   $0x2c
  802421:	e8 4a fa ff ff       	call   801e70 <syscall>
  802426:	83 c4 18             	add    $0x18,%esp
  802429:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80242c:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802430:	75 07                	jne    802439 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802432:	b8 01 00 00 00       	mov    $0x1,%eax
  802437:	eb 05                	jmp    80243e <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802439:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80243e:	c9                   	leave  
  80243f:	c3                   	ret    

00802440 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802440:	55                   	push   %ebp
  802441:	89 e5                	mov    %esp,%ebp
  802443:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802446:	6a 00                	push   $0x0
  802448:	6a 00                	push   $0x0
  80244a:	6a 00                	push   $0x0
  80244c:	6a 00                	push   $0x0
  80244e:	6a 00                	push   $0x0
  802450:	6a 2c                	push   $0x2c
  802452:	e8 19 fa ff ff       	call   801e70 <syscall>
  802457:	83 c4 18             	add    $0x18,%esp
  80245a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80245d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802461:	75 07                	jne    80246a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802463:	b8 01 00 00 00       	mov    $0x1,%eax
  802468:	eb 05                	jmp    80246f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80246a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80246f:	c9                   	leave  
  802470:	c3                   	ret    

00802471 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802471:	55                   	push   %ebp
  802472:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802474:	6a 00                	push   $0x0
  802476:	6a 00                	push   $0x0
  802478:	6a 00                	push   $0x0
  80247a:	6a 00                	push   $0x0
  80247c:	ff 75 08             	pushl  0x8(%ebp)
  80247f:	6a 2d                	push   $0x2d
  802481:	e8 ea f9 ff ff       	call   801e70 <syscall>
  802486:	83 c4 18             	add    $0x18,%esp
	return ;
  802489:	90                   	nop
}
  80248a:	c9                   	leave  
  80248b:	c3                   	ret    

0080248c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80248c:	55                   	push   %ebp
  80248d:	89 e5                	mov    %esp,%ebp
  80248f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802490:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802493:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802496:	8b 55 0c             	mov    0xc(%ebp),%edx
  802499:	8b 45 08             	mov    0x8(%ebp),%eax
  80249c:	6a 00                	push   $0x0
  80249e:	53                   	push   %ebx
  80249f:	51                   	push   %ecx
  8024a0:	52                   	push   %edx
  8024a1:	50                   	push   %eax
  8024a2:	6a 2e                	push   $0x2e
  8024a4:	e8 c7 f9 ff ff       	call   801e70 <syscall>
  8024a9:	83 c4 18             	add    $0x18,%esp
}
  8024ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024af:	c9                   	leave  
  8024b0:	c3                   	ret    

008024b1 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8024b1:	55                   	push   %ebp
  8024b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8024b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ba:	6a 00                	push   $0x0
  8024bc:	6a 00                	push   $0x0
  8024be:	6a 00                	push   $0x0
  8024c0:	52                   	push   %edx
  8024c1:	50                   	push   %eax
  8024c2:	6a 2f                	push   $0x2f
  8024c4:	e8 a7 f9 ff ff       	call   801e70 <syscall>
  8024c9:	83 c4 18             	add    $0x18,%esp
}
  8024cc:	c9                   	leave  
  8024cd:	c3                   	ret    

008024ce <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8024ce:	55                   	push   %ebp
  8024cf:	89 e5                	mov    %esp,%ebp
  8024d1:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8024d4:	83 ec 0c             	sub    $0xc,%esp
  8024d7:	68 3c 41 80 00       	push   $0x80413c
  8024dc:	e8 df e6 ff ff       	call   800bc0 <cprintf>
  8024e1:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8024e4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8024eb:	83 ec 0c             	sub    $0xc,%esp
  8024ee:	68 68 41 80 00       	push   $0x804168
  8024f3:	e8 c8 e6 ff ff       	call   800bc0 <cprintf>
  8024f8:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8024fb:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8024ff:	a1 38 51 80 00       	mov    0x805138,%eax
  802504:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802507:	eb 56                	jmp    80255f <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802509:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80250d:	74 1c                	je     80252b <print_mem_block_lists+0x5d>
  80250f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802512:	8b 50 08             	mov    0x8(%eax),%edx
  802515:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802518:	8b 48 08             	mov    0x8(%eax),%ecx
  80251b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80251e:	8b 40 0c             	mov    0xc(%eax),%eax
  802521:	01 c8                	add    %ecx,%eax
  802523:	39 c2                	cmp    %eax,%edx
  802525:	73 04                	jae    80252b <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802527:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80252b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252e:	8b 50 08             	mov    0x8(%eax),%edx
  802531:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802534:	8b 40 0c             	mov    0xc(%eax),%eax
  802537:	01 c2                	add    %eax,%edx
  802539:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253c:	8b 40 08             	mov    0x8(%eax),%eax
  80253f:	83 ec 04             	sub    $0x4,%esp
  802542:	52                   	push   %edx
  802543:	50                   	push   %eax
  802544:	68 7d 41 80 00       	push   $0x80417d
  802549:	e8 72 e6 ff ff       	call   800bc0 <cprintf>
  80254e:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802554:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802557:	a1 40 51 80 00       	mov    0x805140,%eax
  80255c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80255f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802563:	74 07                	je     80256c <print_mem_block_lists+0x9e>
  802565:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802568:	8b 00                	mov    (%eax),%eax
  80256a:	eb 05                	jmp    802571 <print_mem_block_lists+0xa3>
  80256c:	b8 00 00 00 00       	mov    $0x0,%eax
  802571:	a3 40 51 80 00       	mov    %eax,0x805140
  802576:	a1 40 51 80 00       	mov    0x805140,%eax
  80257b:	85 c0                	test   %eax,%eax
  80257d:	75 8a                	jne    802509 <print_mem_block_lists+0x3b>
  80257f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802583:	75 84                	jne    802509 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802585:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802589:	75 10                	jne    80259b <print_mem_block_lists+0xcd>
  80258b:	83 ec 0c             	sub    $0xc,%esp
  80258e:	68 8c 41 80 00       	push   $0x80418c
  802593:	e8 28 e6 ff ff       	call   800bc0 <cprintf>
  802598:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80259b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8025a2:	83 ec 0c             	sub    $0xc,%esp
  8025a5:	68 b0 41 80 00       	push   $0x8041b0
  8025aa:	e8 11 e6 ff ff       	call   800bc0 <cprintf>
  8025af:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8025b2:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8025b6:	a1 40 50 80 00       	mov    0x805040,%eax
  8025bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025be:	eb 56                	jmp    802616 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8025c0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025c4:	74 1c                	je     8025e2 <print_mem_block_lists+0x114>
  8025c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c9:	8b 50 08             	mov    0x8(%eax),%edx
  8025cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025cf:	8b 48 08             	mov    0x8(%eax),%ecx
  8025d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8025d8:	01 c8                	add    %ecx,%eax
  8025da:	39 c2                	cmp    %eax,%edx
  8025dc:	73 04                	jae    8025e2 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8025de:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8025e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e5:	8b 50 08             	mov    0x8(%eax),%edx
  8025e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ee:	01 c2                	add    %eax,%edx
  8025f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f3:	8b 40 08             	mov    0x8(%eax),%eax
  8025f6:	83 ec 04             	sub    $0x4,%esp
  8025f9:	52                   	push   %edx
  8025fa:	50                   	push   %eax
  8025fb:	68 7d 41 80 00       	push   $0x80417d
  802600:	e8 bb e5 ff ff       	call   800bc0 <cprintf>
  802605:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80260e:	a1 48 50 80 00       	mov    0x805048,%eax
  802613:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802616:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80261a:	74 07                	je     802623 <print_mem_block_lists+0x155>
  80261c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261f:	8b 00                	mov    (%eax),%eax
  802621:	eb 05                	jmp    802628 <print_mem_block_lists+0x15a>
  802623:	b8 00 00 00 00       	mov    $0x0,%eax
  802628:	a3 48 50 80 00       	mov    %eax,0x805048
  80262d:	a1 48 50 80 00       	mov    0x805048,%eax
  802632:	85 c0                	test   %eax,%eax
  802634:	75 8a                	jne    8025c0 <print_mem_block_lists+0xf2>
  802636:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80263a:	75 84                	jne    8025c0 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80263c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802640:	75 10                	jne    802652 <print_mem_block_lists+0x184>
  802642:	83 ec 0c             	sub    $0xc,%esp
  802645:	68 c8 41 80 00       	push   $0x8041c8
  80264a:	e8 71 e5 ff ff       	call   800bc0 <cprintf>
  80264f:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802652:	83 ec 0c             	sub    $0xc,%esp
  802655:	68 3c 41 80 00       	push   $0x80413c
  80265a:	e8 61 e5 ff ff       	call   800bc0 <cprintf>
  80265f:	83 c4 10             	add    $0x10,%esp

}
  802662:	90                   	nop
  802663:	c9                   	leave  
  802664:	c3                   	ret    

00802665 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802665:	55                   	push   %ebp
  802666:	89 e5                	mov    %esp,%ebp
  802668:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  80266b:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802672:	00 00 00 
  802675:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80267c:	00 00 00 
  80267f:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802686:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  802689:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802690:	e9 9e 00 00 00       	jmp    802733 <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802695:	a1 50 50 80 00       	mov    0x805050,%eax
  80269a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80269d:	c1 e2 04             	shl    $0x4,%edx
  8026a0:	01 d0                	add    %edx,%eax
  8026a2:	85 c0                	test   %eax,%eax
  8026a4:	75 14                	jne    8026ba <initialize_MemBlocksList+0x55>
  8026a6:	83 ec 04             	sub    $0x4,%esp
  8026a9:	68 f0 41 80 00       	push   $0x8041f0
  8026ae:	6a 42                	push   $0x42
  8026b0:	68 13 42 80 00       	push   $0x804213
  8026b5:	e8 52 e2 ff ff       	call   80090c <_panic>
  8026ba:	a1 50 50 80 00       	mov    0x805050,%eax
  8026bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026c2:	c1 e2 04             	shl    $0x4,%edx
  8026c5:	01 d0                	add    %edx,%eax
  8026c7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8026cd:	89 10                	mov    %edx,(%eax)
  8026cf:	8b 00                	mov    (%eax),%eax
  8026d1:	85 c0                	test   %eax,%eax
  8026d3:	74 18                	je     8026ed <initialize_MemBlocksList+0x88>
  8026d5:	a1 48 51 80 00       	mov    0x805148,%eax
  8026da:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8026e0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8026e3:	c1 e1 04             	shl    $0x4,%ecx
  8026e6:	01 ca                	add    %ecx,%edx
  8026e8:	89 50 04             	mov    %edx,0x4(%eax)
  8026eb:	eb 12                	jmp    8026ff <initialize_MemBlocksList+0x9a>
  8026ed:	a1 50 50 80 00       	mov    0x805050,%eax
  8026f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026f5:	c1 e2 04             	shl    $0x4,%edx
  8026f8:	01 d0                	add    %edx,%eax
  8026fa:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8026ff:	a1 50 50 80 00       	mov    0x805050,%eax
  802704:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802707:	c1 e2 04             	shl    $0x4,%edx
  80270a:	01 d0                	add    %edx,%eax
  80270c:	a3 48 51 80 00       	mov    %eax,0x805148
  802711:	a1 50 50 80 00       	mov    0x805050,%eax
  802716:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802719:	c1 e2 04             	shl    $0x4,%edx
  80271c:	01 d0                	add    %edx,%eax
  80271e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802725:	a1 54 51 80 00       	mov    0x805154,%eax
  80272a:	40                   	inc    %eax
  80272b:	a3 54 51 80 00       	mov    %eax,0x805154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  802730:	ff 45 f4             	incl   -0xc(%ebp)
  802733:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802736:	3b 45 08             	cmp    0x8(%ebp),%eax
  802739:	0f 82 56 ff ff ff    	jb     802695 <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  80273f:	90                   	nop
  802740:	c9                   	leave  
  802741:	c3                   	ret    

00802742 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802742:	55                   	push   %ebp
  802743:	89 e5                	mov    %esp,%ebp
  802745:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  802748:	8b 45 08             	mov    0x8(%ebp),%eax
  80274b:	8b 00                	mov    (%eax),%eax
  80274d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802750:	eb 19                	jmp    80276b <find_block+0x29>
	{
		if(blk->sva==va)
  802752:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802755:	8b 40 08             	mov    0x8(%eax),%eax
  802758:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80275b:	75 05                	jne    802762 <find_block+0x20>
			return (blk);
  80275d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802760:	eb 36                	jmp    802798 <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  802762:	8b 45 08             	mov    0x8(%ebp),%eax
  802765:	8b 40 08             	mov    0x8(%eax),%eax
  802768:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80276b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80276f:	74 07                	je     802778 <find_block+0x36>
  802771:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802774:	8b 00                	mov    (%eax),%eax
  802776:	eb 05                	jmp    80277d <find_block+0x3b>
  802778:	b8 00 00 00 00       	mov    $0x0,%eax
  80277d:	8b 55 08             	mov    0x8(%ebp),%edx
  802780:	89 42 08             	mov    %eax,0x8(%edx)
  802783:	8b 45 08             	mov    0x8(%ebp),%eax
  802786:	8b 40 08             	mov    0x8(%eax),%eax
  802789:	85 c0                	test   %eax,%eax
  80278b:	75 c5                	jne    802752 <find_block+0x10>
  80278d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802791:	75 bf                	jne    802752 <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  802793:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802798:	c9                   	leave  
  802799:	c3                   	ret    

0080279a <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80279a:	55                   	push   %ebp
  80279b:	89 e5                	mov    %esp,%ebp
  80279d:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  8027a0:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8027a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8027a8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  8027af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8027b5:	75 65                	jne    80281c <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  8027b7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027bb:	75 14                	jne    8027d1 <insert_sorted_allocList+0x37>
  8027bd:	83 ec 04             	sub    $0x4,%esp
  8027c0:	68 f0 41 80 00       	push   $0x8041f0
  8027c5:	6a 5c                	push   $0x5c
  8027c7:	68 13 42 80 00       	push   $0x804213
  8027cc:	e8 3b e1 ff ff       	call   80090c <_panic>
  8027d1:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8027d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027da:	89 10                	mov    %edx,(%eax)
  8027dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027df:	8b 00                	mov    (%eax),%eax
  8027e1:	85 c0                	test   %eax,%eax
  8027e3:	74 0d                	je     8027f2 <insert_sorted_allocList+0x58>
  8027e5:	a1 40 50 80 00       	mov    0x805040,%eax
  8027ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8027ed:	89 50 04             	mov    %edx,0x4(%eax)
  8027f0:	eb 08                	jmp    8027fa <insert_sorted_allocList+0x60>
  8027f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f5:	a3 44 50 80 00       	mov    %eax,0x805044
  8027fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fd:	a3 40 50 80 00       	mov    %eax,0x805040
  802802:	8b 45 08             	mov    0x8(%ebp),%eax
  802805:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80280c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802811:	40                   	inc    %eax
  802812:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  802817:	e9 7b 01 00 00       	jmp    802997 <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  80281c:	a1 44 50 80 00       	mov    0x805044,%eax
  802821:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  802824:	a1 40 50 80 00       	mov    0x805040,%eax
  802829:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  80282c:	8b 45 08             	mov    0x8(%ebp),%eax
  80282f:	8b 50 08             	mov    0x8(%eax),%edx
  802832:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802835:	8b 40 08             	mov    0x8(%eax),%eax
  802838:	39 c2                	cmp    %eax,%edx
  80283a:	76 65                	jbe    8028a1 <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  80283c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802840:	75 14                	jne    802856 <insert_sorted_allocList+0xbc>
  802842:	83 ec 04             	sub    $0x4,%esp
  802845:	68 2c 42 80 00       	push   $0x80422c
  80284a:	6a 64                	push   $0x64
  80284c:	68 13 42 80 00       	push   $0x804213
  802851:	e8 b6 e0 ff ff       	call   80090c <_panic>
  802856:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80285c:	8b 45 08             	mov    0x8(%ebp),%eax
  80285f:	89 50 04             	mov    %edx,0x4(%eax)
  802862:	8b 45 08             	mov    0x8(%ebp),%eax
  802865:	8b 40 04             	mov    0x4(%eax),%eax
  802868:	85 c0                	test   %eax,%eax
  80286a:	74 0c                	je     802878 <insert_sorted_allocList+0xde>
  80286c:	a1 44 50 80 00       	mov    0x805044,%eax
  802871:	8b 55 08             	mov    0x8(%ebp),%edx
  802874:	89 10                	mov    %edx,(%eax)
  802876:	eb 08                	jmp    802880 <insert_sorted_allocList+0xe6>
  802878:	8b 45 08             	mov    0x8(%ebp),%eax
  80287b:	a3 40 50 80 00       	mov    %eax,0x805040
  802880:	8b 45 08             	mov    0x8(%ebp),%eax
  802883:	a3 44 50 80 00       	mov    %eax,0x805044
  802888:	8b 45 08             	mov    0x8(%ebp),%eax
  80288b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802891:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802896:	40                   	inc    %eax
  802897:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  80289c:	e9 f6 00 00 00       	jmp    802997 <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  8028a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a4:	8b 50 08             	mov    0x8(%eax),%edx
  8028a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028aa:	8b 40 08             	mov    0x8(%eax),%eax
  8028ad:	39 c2                	cmp    %eax,%edx
  8028af:	73 65                	jae    802916 <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  8028b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028b5:	75 14                	jne    8028cb <insert_sorted_allocList+0x131>
  8028b7:	83 ec 04             	sub    $0x4,%esp
  8028ba:	68 f0 41 80 00       	push   $0x8041f0
  8028bf:	6a 68                	push   $0x68
  8028c1:	68 13 42 80 00       	push   $0x804213
  8028c6:	e8 41 e0 ff ff       	call   80090c <_panic>
  8028cb:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8028d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d4:	89 10                	mov    %edx,(%eax)
  8028d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d9:	8b 00                	mov    (%eax),%eax
  8028db:	85 c0                	test   %eax,%eax
  8028dd:	74 0d                	je     8028ec <insert_sorted_allocList+0x152>
  8028df:	a1 40 50 80 00       	mov    0x805040,%eax
  8028e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8028e7:	89 50 04             	mov    %edx,0x4(%eax)
  8028ea:	eb 08                	jmp    8028f4 <insert_sorted_allocList+0x15a>
  8028ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ef:	a3 44 50 80 00       	mov    %eax,0x805044
  8028f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f7:	a3 40 50 80 00       	mov    %eax,0x805040
  8028fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802906:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80290b:	40                   	inc    %eax
  80290c:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  802911:	e9 81 00 00 00       	jmp    802997 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802916:	a1 40 50 80 00       	mov    0x805040,%eax
  80291b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80291e:	eb 51                	jmp    802971 <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  802920:	8b 45 08             	mov    0x8(%ebp),%eax
  802923:	8b 50 08             	mov    0x8(%eax),%edx
  802926:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802929:	8b 40 08             	mov    0x8(%eax),%eax
  80292c:	39 c2                	cmp    %eax,%edx
  80292e:	73 39                	jae    802969 <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  802930:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802933:	8b 40 04             	mov    0x4(%eax),%eax
  802936:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  802939:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80293c:	8b 55 08             	mov    0x8(%ebp),%edx
  80293f:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  802941:	8b 45 08             	mov    0x8(%ebp),%eax
  802944:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802947:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  80294a:	8b 45 08             	mov    0x8(%ebp),%eax
  80294d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802950:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  802952:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802955:	8b 55 08             	mov    0x8(%ebp),%edx
  802958:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  80295b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802960:	40                   	inc    %eax
  802961:	a3 4c 50 80 00       	mov    %eax,0x80504c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  802966:	90                   	nop
				}
			}
		 }

	}
}
  802967:	eb 2e                	jmp    802997 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802969:	a1 48 50 80 00       	mov    0x805048,%eax
  80296e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802971:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802975:	74 07                	je     80297e <insert_sorted_allocList+0x1e4>
  802977:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297a:	8b 00                	mov    (%eax),%eax
  80297c:	eb 05                	jmp    802983 <insert_sorted_allocList+0x1e9>
  80297e:	b8 00 00 00 00       	mov    $0x0,%eax
  802983:	a3 48 50 80 00       	mov    %eax,0x805048
  802988:	a1 48 50 80 00       	mov    0x805048,%eax
  80298d:	85 c0                	test   %eax,%eax
  80298f:	75 8f                	jne    802920 <insert_sorted_allocList+0x186>
  802991:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802995:	75 89                	jne    802920 <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  802997:	90                   	nop
  802998:	c9                   	leave  
  802999:	c3                   	ret    

0080299a <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80299a:	55                   	push   %ebp
  80299b:	89 e5                	mov    %esp,%ebp
  80299d:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  8029a0:	a1 38 51 80 00       	mov    0x805138,%eax
  8029a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029a8:	e9 76 01 00 00       	jmp    802b23 <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  8029ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8029b3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029b6:	0f 85 8a 00 00 00    	jne    802a46 <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  8029bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029c0:	75 17                	jne    8029d9 <alloc_block_FF+0x3f>
  8029c2:	83 ec 04             	sub    $0x4,%esp
  8029c5:	68 4f 42 80 00       	push   $0x80424f
  8029ca:	68 8a 00 00 00       	push   $0x8a
  8029cf:	68 13 42 80 00       	push   $0x804213
  8029d4:	e8 33 df ff ff       	call   80090c <_panic>
  8029d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029dc:	8b 00                	mov    (%eax),%eax
  8029de:	85 c0                	test   %eax,%eax
  8029e0:	74 10                	je     8029f2 <alloc_block_FF+0x58>
  8029e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e5:	8b 00                	mov    (%eax),%eax
  8029e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029ea:	8b 52 04             	mov    0x4(%edx),%edx
  8029ed:	89 50 04             	mov    %edx,0x4(%eax)
  8029f0:	eb 0b                	jmp    8029fd <alloc_block_FF+0x63>
  8029f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f5:	8b 40 04             	mov    0x4(%eax),%eax
  8029f8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8029fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a00:	8b 40 04             	mov    0x4(%eax),%eax
  802a03:	85 c0                	test   %eax,%eax
  802a05:	74 0f                	je     802a16 <alloc_block_FF+0x7c>
  802a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0a:	8b 40 04             	mov    0x4(%eax),%eax
  802a0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a10:	8b 12                	mov    (%edx),%edx
  802a12:	89 10                	mov    %edx,(%eax)
  802a14:	eb 0a                	jmp    802a20 <alloc_block_FF+0x86>
  802a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a19:	8b 00                	mov    (%eax),%eax
  802a1b:	a3 38 51 80 00       	mov    %eax,0x805138
  802a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a23:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a33:	a1 44 51 80 00       	mov    0x805144,%eax
  802a38:	48                   	dec    %eax
  802a39:	a3 44 51 80 00       	mov    %eax,0x805144
			return element;
  802a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a41:	e9 10 01 00 00       	jmp    802b56 <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  802a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a49:	8b 40 0c             	mov    0xc(%eax),%eax
  802a4c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a4f:	0f 86 c6 00 00 00    	jbe    802b1b <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802a55:	a1 48 51 80 00       	mov    0x805148,%eax
  802a5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802a5d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a61:	75 17                	jne    802a7a <alloc_block_FF+0xe0>
  802a63:	83 ec 04             	sub    $0x4,%esp
  802a66:	68 4f 42 80 00       	push   $0x80424f
  802a6b:	68 90 00 00 00       	push   $0x90
  802a70:	68 13 42 80 00       	push   $0x804213
  802a75:	e8 92 de ff ff       	call   80090c <_panic>
  802a7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a7d:	8b 00                	mov    (%eax),%eax
  802a7f:	85 c0                	test   %eax,%eax
  802a81:	74 10                	je     802a93 <alloc_block_FF+0xf9>
  802a83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a86:	8b 00                	mov    (%eax),%eax
  802a88:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a8b:	8b 52 04             	mov    0x4(%edx),%edx
  802a8e:	89 50 04             	mov    %edx,0x4(%eax)
  802a91:	eb 0b                	jmp    802a9e <alloc_block_FF+0x104>
  802a93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a96:	8b 40 04             	mov    0x4(%eax),%eax
  802a99:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa1:	8b 40 04             	mov    0x4(%eax),%eax
  802aa4:	85 c0                	test   %eax,%eax
  802aa6:	74 0f                	je     802ab7 <alloc_block_FF+0x11d>
  802aa8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aab:	8b 40 04             	mov    0x4(%eax),%eax
  802aae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ab1:	8b 12                	mov    (%edx),%edx
  802ab3:	89 10                	mov    %edx,(%eax)
  802ab5:	eb 0a                	jmp    802ac1 <alloc_block_FF+0x127>
  802ab7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aba:	8b 00                	mov    (%eax),%eax
  802abc:	a3 48 51 80 00       	mov    %eax,0x805148
  802ac1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802acd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ad4:	a1 54 51 80 00       	mov    0x805154,%eax
  802ad9:	48                   	dec    %eax
  802ada:	a3 54 51 80 00       	mov    %eax,0x805154
			 element1->size =size;
  802adf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae2:	8b 55 08             	mov    0x8(%ebp),%edx
  802ae5:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  802ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aeb:	8b 50 08             	mov    0x8(%eax),%edx
  802aee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af1:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  802af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af7:	8b 50 08             	mov    0x8(%eax),%edx
  802afa:	8b 45 08             	mov    0x8(%ebp),%eax
  802afd:	01 c2                	add    %eax,%edx
  802aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b02:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  802b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b08:	8b 40 0c             	mov    0xc(%eax),%eax
  802b0b:	2b 45 08             	sub    0x8(%ebp),%eax
  802b0e:	89 c2                	mov    %eax,%edx
  802b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b13:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  802b16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b19:	eb 3b                	jmp    802b56 <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802b1b:	a1 40 51 80 00       	mov    0x805140,%eax
  802b20:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b27:	74 07                	je     802b30 <alloc_block_FF+0x196>
  802b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2c:	8b 00                	mov    (%eax),%eax
  802b2e:	eb 05                	jmp    802b35 <alloc_block_FF+0x19b>
  802b30:	b8 00 00 00 00       	mov    $0x0,%eax
  802b35:	a3 40 51 80 00       	mov    %eax,0x805140
  802b3a:	a1 40 51 80 00       	mov    0x805140,%eax
  802b3f:	85 c0                	test   %eax,%eax
  802b41:	0f 85 66 fe ff ff    	jne    8029ad <alloc_block_FF+0x13>
  802b47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b4b:	0f 85 5c fe ff ff    	jne    8029ad <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  802b51:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b56:	c9                   	leave  
  802b57:	c3                   	ret    

00802b58 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802b58:	55                   	push   %ebp
  802b59:	89 e5                	mov    %esp,%ebp
  802b5b:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  802b5e:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  802b65:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  802b6c:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802b73:	a1 38 51 80 00       	mov    0x805138,%eax
  802b78:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b7b:	e9 cf 00 00 00       	jmp    802c4f <alloc_block_BF+0xf7>
		{
			c++;
  802b80:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  802b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b86:	8b 40 0c             	mov    0xc(%eax),%eax
  802b89:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b8c:	0f 85 8a 00 00 00    	jne    802c1c <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  802b92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b96:	75 17                	jne    802baf <alloc_block_BF+0x57>
  802b98:	83 ec 04             	sub    $0x4,%esp
  802b9b:	68 4f 42 80 00       	push   $0x80424f
  802ba0:	68 a8 00 00 00       	push   $0xa8
  802ba5:	68 13 42 80 00       	push   $0x804213
  802baa:	e8 5d dd ff ff       	call   80090c <_panic>
  802baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb2:	8b 00                	mov    (%eax),%eax
  802bb4:	85 c0                	test   %eax,%eax
  802bb6:	74 10                	je     802bc8 <alloc_block_BF+0x70>
  802bb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbb:	8b 00                	mov    (%eax),%eax
  802bbd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bc0:	8b 52 04             	mov    0x4(%edx),%edx
  802bc3:	89 50 04             	mov    %edx,0x4(%eax)
  802bc6:	eb 0b                	jmp    802bd3 <alloc_block_BF+0x7b>
  802bc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcb:	8b 40 04             	mov    0x4(%eax),%eax
  802bce:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd6:	8b 40 04             	mov    0x4(%eax),%eax
  802bd9:	85 c0                	test   %eax,%eax
  802bdb:	74 0f                	je     802bec <alloc_block_BF+0x94>
  802bdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be0:	8b 40 04             	mov    0x4(%eax),%eax
  802be3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802be6:	8b 12                	mov    (%edx),%edx
  802be8:	89 10                	mov    %edx,(%eax)
  802bea:	eb 0a                	jmp    802bf6 <alloc_block_BF+0x9e>
  802bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bef:	8b 00                	mov    (%eax),%eax
  802bf1:	a3 38 51 80 00       	mov    %eax,0x805138
  802bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c02:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c09:	a1 44 51 80 00       	mov    0x805144,%eax
  802c0e:	48                   	dec    %eax
  802c0f:	a3 44 51 80 00       	mov    %eax,0x805144
				return block;
  802c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c17:	e9 85 01 00 00       	jmp    802da1 <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  802c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1f:	8b 40 0c             	mov    0xc(%eax),%eax
  802c22:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c25:	76 20                	jbe    802c47 <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  802c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2a:	8b 40 0c             	mov    0xc(%eax),%eax
  802c2d:	2b 45 08             	sub    0x8(%ebp),%eax
  802c30:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  802c33:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c36:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802c39:	73 0c                	jae    802c47 <alloc_block_BF+0xef>
				{
					ma=tempi;
  802c3b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  802c41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c44:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802c47:	a1 40 51 80 00       	mov    0x805140,%eax
  802c4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c4f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c53:	74 07                	je     802c5c <alloc_block_BF+0x104>
  802c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c58:	8b 00                	mov    (%eax),%eax
  802c5a:	eb 05                	jmp    802c61 <alloc_block_BF+0x109>
  802c5c:	b8 00 00 00 00       	mov    $0x0,%eax
  802c61:	a3 40 51 80 00       	mov    %eax,0x805140
  802c66:	a1 40 51 80 00       	mov    0x805140,%eax
  802c6b:	85 c0                	test   %eax,%eax
  802c6d:	0f 85 0d ff ff ff    	jne    802b80 <alloc_block_BF+0x28>
  802c73:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c77:	0f 85 03 ff ff ff    	jne    802b80 <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  802c7d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802c84:	a1 38 51 80 00       	mov    0x805138,%eax
  802c89:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c8c:	e9 dd 00 00 00       	jmp    802d6e <alloc_block_BF+0x216>
		{
			if(x==sol)
  802c91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c94:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802c97:	0f 85 c6 00 00 00    	jne    802d63 <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802c9d:	a1 48 51 80 00       	mov    0x805148,%eax
  802ca2:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802ca5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802ca9:	75 17                	jne    802cc2 <alloc_block_BF+0x16a>
  802cab:	83 ec 04             	sub    $0x4,%esp
  802cae:	68 4f 42 80 00       	push   $0x80424f
  802cb3:	68 bb 00 00 00       	push   $0xbb
  802cb8:	68 13 42 80 00       	push   $0x804213
  802cbd:	e8 4a dc ff ff       	call   80090c <_panic>
  802cc2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cc5:	8b 00                	mov    (%eax),%eax
  802cc7:	85 c0                	test   %eax,%eax
  802cc9:	74 10                	je     802cdb <alloc_block_BF+0x183>
  802ccb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cce:	8b 00                	mov    (%eax),%eax
  802cd0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802cd3:	8b 52 04             	mov    0x4(%edx),%edx
  802cd6:	89 50 04             	mov    %edx,0x4(%eax)
  802cd9:	eb 0b                	jmp    802ce6 <alloc_block_BF+0x18e>
  802cdb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cde:	8b 40 04             	mov    0x4(%eax),%eax
  802ce1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ce6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ce9:	8b 40 04             	mov    0x4(%eax),%eax
  802cec:	85 c0                	test   %eax,%eax
  802cee:	74 0f                	je     802cff <alloc_block_BF+0x1a7>
  802cf0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cf3:	8b 40 04             	mov    0x4(%eax),%eax
  802cf6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802cf9:	8b 12                	mov    (%edx),%edx
  802cfb:	89 10                	mov    %edx,(%eax)
  802cfd:	eb 0a                	jmp    802d09 <alloc_block_BF+0x1b1>
  802cff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d02:	8b 00                	mov    (%eax),%eax
  802d04:	a3 48 51 80 00       	mov    %eax,0x805148
  802d09:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d0c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d12:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d15:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d1c:	a1 54 51 80 00       	mov    0x805154,%eax
  802d21:	48                   	dec    %eax
  802d22:	a3 54 51 80 00       	mov    %eax,0x805154
						 element1->size =size;
  802d27:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d2a:	8b 55 08             	mov    0x8(%ebp),%edx
  802d2d:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  802d30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d33:	8b 50 08             	mov    0x8(%eax),%edx
  802d36:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d39:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  802d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3f:	8b 50 08             	mov    0x8(%eax),%edx
  802d42:	8b 45 08             	mov    0x8(%ebp),%eax
  802d45:	01 c2                	add    %eax,%edx
  802d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4a:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  802d4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d50:	8b 40 0c             	mov    0xc(%eax),%eax
  802d53:	2b 45 08             	sub    0x8(%ebp),%eax
  802d56:	89 c2                	mov    %eax,%edx
  802d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5b:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  802d5e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d61:	eb 3e                	jmp    802da1 <alloc_block_BF+0x249>
						 break;
			}
			x++;
  802d63:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802d66:	a1 40 51 80 00       	mov    0x805140,%eax
  802d6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d6e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d72:	74 07                	je     802d7b <alloc_block_BF+0x223>
  802d74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d77:	8b 00                	mov    (%eax),%eax
  802d79:	eb 05                	jmp    802d80 <alloc_block_BF+0x228>
  802d7b:	b8 00 00 00 00       	mov    $0x0,%eax
  802d80:	a3 40 51 80 00       	mov    %eax,0x805140
  802d85:	a1 40 51 80 00       	mov    0x805140,%eax
  802d8a:	85 c0                	test   %eax,%eax
  802d8c:	0f 85 ff fe ff ff    	jne    802c91 <alloc_block_BF+0x139>
  802d92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d96:	0f 85 f5 fe ff ff    	jne    802c91 <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  802d9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802da1:	c9                   	leave  
  802da2:	c3                   	ret    

00802da3 <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802da3:	55                   	push   %ebp
  802da4:	89 e5                	mov    %esp,%ebp
  802da6:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  802da9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802dae:	85 c0                	test   %eax,%eax
  802db0:	75 14                	jne    802dc6 <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  802db2:	a1 38 51 80 00       	mov    0x805138,%eax
  802db7:	a3 60 51 80 00       	mov    %eax,0x805160
		hh=1;
  802dbc:	c7 05 2c 50 80 00 01 	movl   $0x1,0x80502c
  802dc3:	00 00 00 
	}
	uint32 c=1;
  802dc6:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  802dcd:	a1 60 51 80 00       	mov    0x805160,%eax
  802dd2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802dd5:	e9 b3 01 00 00       	jmp    802f8d <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  802dda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ddd:	8b 40 0c             	mov    0xc(%eax),%eax
  802de0:	3b 45 08             	cmp    0x8(%ebp),%eax
  802de3:	0f 85 a9 00 00 00    	jne    802e92 <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  802de9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dec:	8b 00                	mov    (%eax),%eax
  802dee:	85 c0                	test   %eax,%eax
  802df0:	75 0c                	jne    802dfe <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  802df2:	a1 38 51 80 00       	mov    0x805138,%eax
  802df7:	a3 60 51 80 00       	mov    %eax,0x805160
  802dfc:	eb 0a                	jmp    802e08 <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  802dfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e01:	8b 00                	mov    (%eax),%eax
  802e03:	a3 60 51 80 00       	mov    %eax,0x805160
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  802e08:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e0c:	75 17                	jne    802e25 <alloc_block_NF+0x82>
  802e0e:	83 ec 04             	sub    $0x4,%esp
  802e11:	68 4f 42 80 00       	push   $0x80424f
  802e16:	68 e3 00 00 00       	push   $0xe3
  802e1b:	68 13 42 80 00       	push   $0x804213
  802e20:	e8 e7 da ff ff       	call   80090c <_panic>
  802e25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e28:	8b 00                	mov    (%eax),%eax
  802e2a:	85 c0                	test   %eax,%eax
  802e2c:	74 10                	je     802e3e <alloc_block_NF+0x9b>
  802e2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e31:	8b 00                	mov    (%eax),%eax
  802e33:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e36:	8b 52 04             	mov    0x4(%edx),%edx
  802e39:	89 50 04             	mov    %edx,0x4(%eax)
  802e3c:	eb 0b                	jmp    802e49 <alloc_block_NF+0xa6>
  802e3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e41:	8b 40 04             	mov    0x4(%eax),%eax
  802e44:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e4c:	8b 40 04             	mov    0x4(%eax),%eax
  802e4f:	85 c0                	test   %eax,%eax
  802e51:	74 0f                	je     802e62 <alloc_block_NF+0xbf>
  802e53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e56:	8b 40 04             	mov    0x4(%eax),%eax
  802e59:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e5c:	8b 12                	mov    (%edx),%edx
  802e5e:	89 10                	mov    %edx,(%eax)
  802e60:	eb 0a                	jmp    802e6c <alloc_block_NF+0xc9>
  802e62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e65:	8b 00                	mov    (%eax),%eax
  802e67:	a3 38 51 80 00       	mov    %eax,0x805138
  802e6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e6f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e78:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e7f:	a1 44 51 80 00       	mov    0x805144,%eax
  802e84:	48                   	dec    %eax
  802e85:	a3 44 51 80 00       	mov    %eax,0x805144
				return element;
  802e8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e8d:	e9 0e 01 00 00       	jmp    802fa0 <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  802e92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e95:	8b 40 0c             	mov    0xc(%eax),%eax
  802e98:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e9b:	0f 86 ce 00 00 00    	jbe    802f6f <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802ea1:	a1 48 51 80 00       	mov    0x805148,%eax
  802ea6:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802ea9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ead:	75 17                	jne    802ec6 <alloc_block_NF+0x123>
  802eaf:	83 ec 04             	sub    $0x4,%esp
  802eb2:	68 4f 42 80 00       	push   $0x80424f
  802eb7:	68 e9 00 00 00       	push   $0xe9
  802ebc:	68 13 42 80 00       	push   $0x804213
  802ec1:	e8 46 da ff ff       	call   80090c <_panic>
  802ec6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ec9:	8b 00                	mov    (%eax),%eax
  802ecb:	85 c0                	test   %eax,%eax
  802ecd:	74 10                	je     802edf <alloc_block_NF+0x13c>
  802ecf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ed2:	8b 00                	mov    (%eax),%eax
  802ed4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ed7:	8b 52 04             	mov    0x4(%edx),%edx
  802eda:	89 50 04             	mov    %edx,0x4(%eax)
  802edd:	eb 0b                	jmp    802eea <alloc_block_NF+0x147>
  802edf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ee2:	8b 40 04             	mov    0x4(%eax),%eax
  802ee5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802eea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eed:	8b 40 04             	mov    0x4(%eax),%eax
  802ef0:	85 c0                	test   %eax,%eax
  802ef2:	74 0f                	je     802f03 <alloc_block_NF+0x160>
  802ef4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ef7:	8b 40 04             	mov    0x4(%eax),%eax
  802efa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802efd:	8b 12                	mov    (%edx),%edx
  802eff:	89 10                	mov    %edx,(%eax)
  802f01:	eb 0a                	jmp    802f0d <alloc_block_NF+0x16a>
  802f03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f06:	8b 00                	mov    (%eax),%eax
  802f08:	a3 48 51 80 00       	mov    %eax,0x805148
  802f0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f19:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f20:	a1 54 51 80 00       	mov    0x805154,%eax
  802f25:	48                   	dec    %eax
  802f26:	a3 54 51 80 00       	mov    %eax,0x805154
				 element1->size =size;
  802f2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f2e:	8b 55 08             	mov    0x8(%ebp),%edx
  802f31:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  802f34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f37:	8b 50 08             	mov    0x8(%eax),%edx
  802f3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f3d:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  802f40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f43:	8b 50 08             	mov    0x8(%eax),%edx
  802f46:	8b 45 08             	mov    0x8(%ebp),%eax
  802f49:	01 c2                	add    %eax,%edx
  802f4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f4e:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  802f51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f54:	8b 40 0c             	mov    0xc(%eax),%eax
  802f57:	2b 45 08             	sub    0x8(%ebp),%eax
  802f5a:	89 c2                	mov    %eax,%edx
  802f5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f5f:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  802f62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f65:	a3 60 51 80 00       	mov    %eax,0x805160
				 return element1;
  802f6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f6d:	eb 31                	jmp    802fa0 <alloc_block_NF+0x1fd>
			 }
		 c++;
  802f6f:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  802f72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f75:	8b 00                	mov    (%eax),%eax
  802f77:	85 c0                	test   %eax,%eax
  802f79:	75 0a                	jne    802f85 <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  802f7b:	a1 38 51 80 00       	mov    0x805138,%eax
  802f80:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802f83:	eb 08                	jmp    802f8d <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  802f85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f88:	8b 00                	mov    (%eax),%eax
  802f8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802f8d:	a1 44 51 80 00       	mov    0x805144,%eax
  802f92:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802f95:	0f 85 3f fe ff ff    	jne    802dda <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  802f9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802fa0:	c9                   	leave  
  802fa1:	c3                   	ret    

00802fa2 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802fa2:	55                   	push   %ebp
  802fa3:	89 e5                	mov    %esp,%ebp
  802fa5:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  802fa8:	a1 44 51 80 00       	mov    0x805144,%eax
  802fad:	85 c0                	test   %eax,%eax
  802faf:	75 68                	jne    803019 <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802fb1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fb5:	75 17                	jne    802fce <insert_sorted_with_merge_freeList+0x2c>
  802fb7:	83 ec 04             	sub    $0x4,%esp
  802fba:	68 f0 41 80 00       	push   $0x8041f0
  802fbf:	68 0e 01 00 00       	push   $0x10e
  802fc4:	68 13 42 80 00       	push   $0x804213
  802fc9:	e8 3e d9 ff ff       	call   80090c <_panic>
  802fce:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd7:	89 10                	mov    %edx,(%eax)
  802fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdc:	8b 00                	mov    (%eax),%eax
  802fde:	85 c0                	test   %eax,%eax
  802fe0:	74 0d                	je     802fef <insert_sorted_with_merge_freeList+0x4d>
  802fe2:	a1 38 51 80 00       	mov    0x805138,%eax
  802fe7:	8b 55 08             	mov    0x8(%ebp),%edx
  802fea:	89 50 04             	mov    %edx,0x4(%eax)
  802fed:	eb 08                	jmp    802ff7 <insert_sorted_with_merge_freeList+0x55>
  802fef:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffa:	a3 38 51 80 00       	mov    %eax,0x805138
  802fff:	8b 45 08             	mov    0x8(%ebp),%eax
  803002:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803009:	a1 44 51 80 00       	mov    0x805144,%eax
  80300e:	40                   	inc    %eax
  80300f:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  803014:	e9 8c 06 00 00       	jmp    8036a5 <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  803019:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80301e:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  803021:	a1 38 51 80 00       	mov    0x805138,%eax
  803026:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  803029:	8b 45 08             	mov    0x8(%ebp),%eax
  80302c:	8b 50 08             	mov    0x8(%eax),%edx
  80302f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803032:	8b 40 08             	mov    0x8(%eax),%eax
  803035:	39 c2                	cmp    %eax,%edx
  803037:	0f 86 14 01 00 00    	jbe    803151 <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  80303d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803040:	8b 50 0c             	mov    0xc(%eax),%edx
  803043:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803046:	8b 40 08             	mov    0x8(%eax),%eax
  803049:	01 c2                	add    %eax,%edx
  80304b:	8b 45 08             	mov    0x8(%ebp),%eax
  80304e:	8b 40 08             	mov    0x8(%eax),%eax
  803051:	39 c2                	cmp    %eax,%edx
  803053:	0f 85 90 00 00 00    	jne    8030e9 <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  803059:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80305c:	8b 50 0c             	mov    0xc(%eax),%edx
  80305f:	8b 45 08             	mov    0x8(%ebp),%eax
  803062:	8b 40 0c             	mov    0xc(%eax),%eax
  803065:	01 c2                	add    %eax,%edx
  803067:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80306a:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  80306d:	8b 45 08             	mov    0x8(%ebp),%eax
  803070:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  803077:	8b 45 08             	mov    0x8(%ebp),%eax
  80307a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803081:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803085:	75 17                	jne    80309e <insert_sorted_with_merge_freeList+0xfc>
  803087:	83 ec 04             	sub    $0x4,%esp
  80308a:	68 f0 41 80 00       	push   $0x8041f0
  80308f:	68 1b 01 00 00       	push   $0x11b
  803094:	68 13 42 80 00       	push   $0x804213
  803099:	e8 6e d8 ff ff       	call   80090c <_panic>
  80309e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a7:	89 10                	mov    %edx,(%eax)
  8030a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ac:	8b 00                	mov    (%eax),%eax
  8030ae:	85 c0                	test   %eax,%eax
  8030b0:	74 0d                	je     8030bf <insert_sorted_with_merge_freeList+0x11d>
  8030b2:	a1 48 51 80 00       	mov    0x805148,%eax
  8030b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8030ba:	89 50 04             	mov    %edx,0x4(%eax)
  8030bd:	eb 08                	jmp    8030c7 <insert_sorted_with_merge_freeList+0x125>
  8030bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ca:	a3 48 51 80 00       	mov    %eax,0x805148
  8030cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030d9:	a1 54 51 80 00       	mov    0x805154,%eax
  8030de:	40                   	inc    %eax
  8030df:	a3 54 51 80 00       	mov    %eax,0x805154
							}

						}
		          }
		}
}
  8030e4:	e9 bc 05 00 00       	jmp    8036a5 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8030e9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030ed:	75 17                	jne    803106 <insert_sorted_with_merge_freeList+0x164>
  8030ef:	83 ec 04             	sub    $0x4,%esp
  8030f2:	68 2c 42 80 00       	push   $0x80422c
  8030f7:	68 1f 01 00 00       	push   $0x11f
  8030fc:	68 13 42 80 00       	push   $0x804213
  803101:	e8 06 d8 ff ff       	call   80090c <_panic>
  803106:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80310c:	8b 45 08             	mov    0x8(%ebp),%eax
  80310f:	89 50 04             	mov    %edx,0x4(%eax)
  803112:	8b 45 08             	mov    0x8(%ebp),%eax
  803115:	8b 40 04             	mov    0x4(%eax),%eax
  803118:	85 c0                	test   %eax,%eax
  80311a:	74 0c                	je     803128 <insert_sorted_with_merge_freeList+0x186>
  80311c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803121:	8b 55 08             	mov    0x8(%ebp),%edx
  803124:	89 10                	mov    %edx,(%eax)
  803126:	eb 08                	jmp    803130 <insert_sorted_with_merge_freeList+0x18e>
  803128:	8b 45 08             	mov    0x8(%ebp),%eax
  80312b:	a3 38 51 80 00       	mov    %eax,0x805138
  803130:	8b 45 08             	mov    0x8(%ebp),%eax
  803133:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803138:	8b 45 08             	mov    0x8(%ebp),%eax
  80313b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803141:	a1 44 51 80 00       	mov    0x805144,%eax
  803146:	40                   	inc    %eax
  803147:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  80314c:	e9 54 05 00 00       	jmp    8036a5 <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  803151:	8b 45 08             	mov    0x8(%ebp),%eax
  803154:	8b 50 08             	mov    0x8(%eax),%edx
  803157:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80315a:	8b 40 08             	mov    0x8(%eax),%eax
  80315d:	39 c2                	cmp    %eax,%edx
  80315f:	0f 83 20 01 00 00    	jae    803285 <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  803165:	8b 45 08             	mov    0x8(%ebp),%eax
  803168:	8b 50 0c             	mov    0xc(%eax),%edx
  80316b:	8b 45 08             	mov    0x8(%ebp),%eax
  80316e:	8b 40 08             	mov    0x8(%eax),%eax
  803171:	01 c2                	add    %eax,%edx
  803173:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803176:	8b 40 08             	mov    0x8(%eax),%eax
  803179:	39 c2                	cmp    %eax,%edx
  80317b:	0f 85 9c 00 00 00    	jne    80321d <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  803181:	8b 45 08             	mov    0x8(%ebp),%eax
  803184:	8b 50 08             	mov    0x8(%eax),%edx
  803187:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80318a:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  80318d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803190:	8b 50 0c             	mov    0xc(%eax),%edx
  803193:	8b 45 08             	mov    0x8(%ebp),%eax
  803196:	8b 40 0c             	mov    0xc(%eax),%eax
  803199:	01 c2                	add    %eax,%edx
  80319b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80319e:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  8031a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  8031ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ae:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8031b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031b9:	75 17                	jne    8031d2 <insert_sorted_with_merge_freeList+0x230>
  8031bb:	83 ec 04             	sub    $0x4,%esp
  8031be:	68 f0 41 80 00       	push   $0x8041f0
  8031c3:	68 2a 01 00 00       	push   $0x12a
  8031c8:	68 13 42 80 00       	push   $0x804213
  8031cd:	e8 3a d7 ff ff       	call   80090c <_panic>
  8031d2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031db:	89 10                	mov    %edx,(%eax)
  8031dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e0:	8b 00                	mov    (%eax),%eax
  8031e2:	85 c0                	test   %eax,%eax
  8031e4:	74 0d                	je     8031f3 <insert_sorted_with_merge_freeList+0x251>
  8031e6:	a1 48 51 80 00       	mov    0x805148,%eax
  8031eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8031ee:	89 50 04             	mov    %edx,0x4(%eax)
  8031f1:	eb 08                	jmp    8031fb <insert_sorted_with_merge_freeList+0x259>
  8031f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fe:	a3 48 51 80 00       	mov    %eax,0x805148
  803203:	8b 45 08             	mov    0x8(%ebp),%eax
  803206:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80320d:	a1 54 51 80 00       	mov    0x805154,%eax
  803212:	40                   	inc    %eax
  803213:	a3 54 51 80 00       	mov    %eax,0x805154
							}

						}
		          }
		}
}
  803218:	e9 88 04 00 00       	jmp    8036a5 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  80321d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803221:	75 17                	jne    80323a <insert_sorted_with_merge_freeList+0x298>
  803223:	83 ec 04             	sub    $0x4,%esp
  803226:	68 f0 41 80 00       	push   $0x8041f0
  80322b:	68 2e 01 00 00       	push   $0x12e
  803230:	68 13 42 80 00       	push   $0x804213
  803235:	e8 d2 d6 ff ff       	call   80090c <_panic>
  80323a:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803240:	8b 45 08             	mov    0x8(%ebp),%eax
  803243:	89 10                	mov    %edx,(%eax)
  803245:	8b 45 08             	mov    0x8(%ebp),%eax
  803248:	8b 00                	mov    (%eax),%eax
  80324a:	85 c0                	test   %eax,%eax
  80324c:	74 0d                	je     80325b <insert_sorted_with_merge_freeList+0x2b9>
  80324e:	a1 38 51 80 00       	mov    0x805138,%eax
  803253:	8b 55 08             	mov    0x8(%ebp),%edx
  803256:	89 50 04             	mov    %edx,0x4(%eax)
  803259:	eb 08                	jmp    803263 <insert_sorted_with_merge_freeList+0x2c1>
  80325b:	8b 45 08             	mov    0x8(%ebp),%eax
  80325e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803263:	8b 45 08             	mov    0x8(%ebp),%eax
  803266:	a3 38 51 80 00       	mov    %eax,0x805138
  80326b:	8b 45 08             	mov    0x8(%ebp),%eax
  80326e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803275:	a1 44 51 80 00       	mov    0x805144,%eax
  80327a:	40                   	inc    %eax
  80327b:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  803280:	e9 20 04 00 00       	jmp    8036a5 <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  803285:	a1 38 51 80 00       	mov    0x805138,%eax
  80328a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80328d:	e9 e2 03 00 00       	jmp    803674 <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  803292:	8b 45 08             	mov    0x8(%ebp),%eax
  803295:	8b 50 08             	mov    0x8(%eax),%edx
  803298:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80329b:	8b 40 08             	mov    0x8(%eax),%eax
  80329e:	39 c2                	cmp    %eax,%edx
  8032a0:	0f 83 c6 03 00 00    	jae    80366c <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  8032a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a9:	8b 40 04             	mov    0x4(%eax),%eax
  8032ac:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  8032af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b2:	8b 50 08             	mov    0x8(%eax),%edx
  8032b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8032bb:	01 d0                	add    %edx,%eax
  8032bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  8032c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c3:	8b 50 0c             	mov    0xc(%eax),%edx
  8032c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c9:	8b 40 08             	mov    0x8(%eax),%eax
  8032cc:	01 d0                	add    %edx,%eax
  8032ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  8032d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d4:	8b 40 08             	mov    0x8(%eax),%eax
  8032d7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8032da:	74 7a                	je     803356 <insert_sorted_with_merge_freeList+0x3b4>
  8032dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032df:	8b 40 08             	mov    0x8(%eax),%eax
  8032e2:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8032e5:	74 6f                	je     803356 <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  8032e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032eb:	74 06                	je     8032f3 <insert_sorted_with_merge_freeList+0x351>
  8032ed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032f1:	75 17                	jne    80330a <insert_sorted_with_merge_freeList+0x368>
  8032f3:	83 ec 04             	sub    $0x4,%esp
  8032f6:	68 70 42 80 00       	push   $0x804270
  8032fb:	68 43 01 00 00       	push   $0x143
  803300:	68 13 42 80 00       	push   $0x804213
  803305:	e8 02 d6 ff ff       	call   80090c <_panic>
  80330a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80330d:	8b 50 04             	mov    0x4(%eax),%edx
  803310:	8b 45 08             	mov    0x8(%ebp),%eax
  803313:	89 50 04             	mov    %edx,0x4(%eax)
  803316:	8b 45 08             	mov    0x8(%ebp),%eax
  803319:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80331c:	89 10                	mov    %edx,(%eax)
  80331e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803321:	8b 40 04             	mov    0x4(%eax),%eax
  803324:	85 c0                	test   %eax,%eax
  803326:	74 0d                	je     803335 <insert_sorted_with_merge_freeList+0x393>
  803328:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332b:	8b 40 04             	mov    0x4(%eax),%eax
  80332e:	8b 55 08             	mov    0x8(%ebp),%edx
  803331:	89 10                	mov    %edx,(%eax)
  803333:	eb 08                	jmp    80333d <insert_sorted_with_merge_freeList+0x39b>
  803335:	8b 45 08             	mov    0x8(%ebp),%eax
  803338:	a3 38 51 80 00       	mov    %eax,0x805138
  80333d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803340:	8b 55 08             	mov    0x8(%ebp),%edx
  803343:	89 50 04             	mov    %edx,0x4(%eax)
  803346:	a1 44 51 80 00       	mov    0x805144,%eax
  80334b:	40                   	inc    %eax
  80334c:	a3 44 51 80 00       	mov    %eax,0x805144
  803351:	e9 14 03 00 00       	jmp    80366a <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  803356:	8b 45 08             	mov    0x8(%ebp),%eax
  803359:	8b 40 08             	mov    0x8(%eax),%eax
  80335c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80335f:	0f 85 a0 01 00 00    	jne    803505 <insert_sorted_with_merge_freeList+0x563>
  803365:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803368:	8b 40 08             	mov    0x8(%eax),%eax
  80336b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80336e:	0f 85 91 01 00 00    	jne    803505 <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  803374:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803377:	8b 50 0c             	mov    0xc(%eax),%edx
  80337a:	8b 45 08             	mov    0x8(%ebp),%eax
  80337d:	8b 48 0c             	mov    0xc(%eax),%ecx
  803380:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803383:	8b 40 0c             	mov    0xc(%eax),%eax
  803386:	01 c8                	add    %ecx,%eax
  803388:	01 c2                	add    %eax,%edx
  80338a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80338d:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  803390:	8b 45 08             	mov    0x8(%ebp),%eax
  803393:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  80339a:	8b 45 08             	mov    0x8(%ebp),%eax
  80339d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  8033a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  8033ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8033b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033bc:	75 17                	jne    8033d5 <insert_sorted_with_merge_freeList+0x433>
  8033be:	83 ec 04             	sub    $0x4,%esp
  8033c1:	68 f0 41 80 00       	push   $0x8041f0
  8033c6:	68 4d 01 00 00       	push   $0x14d
  8033cb:	68 13 42 80 00       	push   $0x804213
  8033d0:	e8 37 d5 ff ff       	call   80090c <_panic>
  8033d5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033db:	8b 45 08             	mov    0x8(%ebp),%eax
  8033de:	89 10                	mov    %edx,(%eax)
  8033e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e3:	8b 00                	mov    (%eax),%eax
  8033e5:	85 c0                	test   %eax,%eax
  8033e7:	74 0d                	je     8033f6 <insert_sorted_with_merge_freeList+0x454>
  8033e9:	a1 48 51 80 00       	mov    0x805148,%eax
  8033ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8033f1:	89 50 04             	mov    %edx,0x4(%eax)
  8033f4:	eb 08                	jmp    8033fe <insert_sorted_with_merge_freeList+0x45c>
  8033f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803401:	a3 48 51 80 00       	mov    %eax,0x805148
  803406:	8b 45 08             	mov    0x8(%ebp),%eax
  803409:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803410:	a1 54 51 80 00       	mov    0x805154,%eax
  803415:	40                   	inc    %eax
  803416:	a3 54 51 80 00       	mov    %eax,0x805154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  80341b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80341f:	75 17                	jne    803438 <insert_sorted_with_merge_freeList+0x496>
  803421:	83 ec 04             	sub    $0x4,%esp
  803424:	68 4f 42 80 00       	push   $0x80424f
  803429:	68 4e 01 00 00       	push   $0x14e
  80342e:	68 13 42 80 00       	push   $0x804213
  803433:	e8 d4 d4 ff ff       	call   80090c <_panic>
  803438:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343b:	8b 00                	mov    (%eax),%eax
  80343d:	85 c0                	test   %eax,%eax
  80343f:	74 10                	je     803451 <insert_sorted_with_merge_freeList+0x4af>
  803441:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803444:	8b 00                	mov    (%eax),%eax
  803446:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803449:	8b 52 04             	mov    0x4(%edx),%edx
  80344c:	89 50 04             	mov    %edx,0x4(%eax)
  80344f:	eb 0b                	jmp    80345c <insert_sorted_with_merge_freeList+0x4ba>
  803451:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803454:	8b 40 04             	mov    0x4(%eax),%eax
  803457:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80345c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345f:	8b 40 04             	mov    0x4(%eax),%eax
  803462:	85 c0                	test   %eax,%eax
  803464:	74 0f                	je     803475 <insert_sorted_with_merge_freeList+0x4d3>
  803466:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803469:	8b 40 04             	mov    0x4(%eax),%eax
  80346c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80346f:	8b 12                	mov    (%edx),%edx
  803471:	89 10                	mov    %edx,(%eax)
  803473:	eb 0a                	jmp    80347f <insert_sorted_with_merge_freeList+0x4dd>
  803475:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803478:	8b 00                	mov    (%eax),%eax
  80347a:	a3 38 51 80 00       	mov    %eax,0x805138
  80347f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803482:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803488:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80348b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803492:	a1 44 51 80 00       	mov    0x805144,%eax
  803497:	48                   	dec    %eax
  803498:	a3 44 51 80 00       	mov    %eax,0x805144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  80349d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034a1:	75 17                	jne    8034ba <insert_sorted_with_merge_freeList+0x518>
  8034a3:	83 ec 04             	sub    $0x4,%esp
  8034a6:	68 f0 41 80 00       	push   $0x8041f0
  8034ab:	68 4f 01 00 00       	push   $0x14f
  8034b0:	68 13 42 80 00       	push   $0x804213
  8034b5:	e8 52 d4 ff ff       	call   80090c <_panic>
  8034ba:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c3:	89 10                	mov    %edx,(%eax)
  8034c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c8:	8b 00                	mov    (%eax),%eax
  8034ca:	85 c0                	test   %eax,%eax
  8034cc:	74 0d                	je     8034db <insert_sorted_with_merge_freeList+0x539>
  8034ce:	a1 48 51 80 00       	mov    0x805148,%eax
  8034d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034d6:	89 50 04             	mov    %edx,0x4(%eax)
  8034d9:	eb 08                	jmp    8034e3 <insert_sorted_with_merge_freeList+0x541>
  8034db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034de:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e6:	a3 48 51 80 00       	mov    %eax,0x805148
  8034eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034f5:	a1 54 51 80 00       	mov    0x805154,%eax
  8034fa:	40                   	inc    %eax
  8034fb:	a3 54 51 80 00       	mov    %eax,0x805154
  803500:	e9 65 01 00 00       	jmp    80366a <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  803505:	8b 45 08             	mov    0x8(%ebp),%eax
  803508:	8b 40 08             	mov    0x8(%eax),%eax
  80350b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80350e:	0f 85 9f 00 00 00    	jne    8035b3 <insert_sorted_with_merge_freeList+0x611>
  803514:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803517:	8b 40 08             	mov    0x8(%eax),%eax
  80351a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80351d:	0f 84 90 00 00 00    	je     8035b3 <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  803523:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803526:	8b 50 0c             	mov    0xc(%eax),%edx
  803529:	8b 45 08             	mov    0x8(%ebp),%eax
  80352c:	8b 40 0c             	mov    0xc(%eax),%eax
  80352f:	01 c2                	add    %eax,%edx
  803531:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803534:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  803537:	8b 45 08             	mov    0x8(%ebp),%eax
  80353a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  803541:	8b 45 08             	mov    0x8(%ebp),%eax
  803544:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80354b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80354f:	75 17                	jne    803568 <insert_sorted_with_merge_freeList+0x5c6>
  803551:	83 ec 04             	sub    $0x4,%esp
  803554:	68 f0 41 80 00       	push   $0x8041f0
  803559:	68 58 01 00 00       	push   $0x158
  80355e:	68 13 42 80 00       	push   $0x804213
  803563:	e8 a4 d3 ff ff       	call   80090c <_panic>
  803568:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80356e:	8b 45 08             	mov    0x8(%ebp),%eax
  803571:	89 10                	mov    %edx,(%eax)
  803573:	8b 45 08             	mov    0x8(%ebp),%eax
  803576:	8b 00                	mov    (%eax),%eax
  803578:	85 c0                	test   %eax,%eax
  80357a:	74 0d                	je     803589 <insert_sorted_with_merge_freeList+0x5e7>
  80357c:	a1 48 51 80 00       	mov    0x805148,%eax
  803581:	8b 55 08             	mov    0x8(%ebp),%edx
  803584:	89 50 04             	mov    %edx,0x4(%eax)
  803587:	eb 08                	jmp    803591 <insert_sorted_with_merge_freeList+0x5ef>
  803589:	8b 45 08             	mov    0x8(%ebp),%eax
  80358c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803591:	8b 45 08             	mov    0x8(%ebp),%eax
  803594:	a3 48 51 80 00       	mov    %eax,0x805148
  803599:	8b 45 08             	mov    0x8(%ebp),%eax
  80359c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035a3:	a1 54 51 80 00       	mov    0x805154,%eax
  8035a8:	40                   	inc    %eax
  8035a9:	a3 54 51 80 00       	mov    %eax,0x805154
  8035ae:	e9 b7 00 00 00       	jmp    80366a <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  8035b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b6:	8b 40 08             	mov    0x8(%eax),%eax
  8035b9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8035bc:	0f 84 e2 00 00 00    	je     8036a4 <insert_sorted_with_merge_freeList+0x702>
  8035c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c5:	8b 40 08             	mov    0x8(%eax),%eax
  8035c8:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8035cb:	0f 85 d3 00 00 00    	jne    8036a4 <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  8035d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d4:	8b 50 08             	mov    0x8(%eax),%edx
  8035d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035da:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  8035dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e0:	8b 50 0c             	mov    0xc(%eax),%edx
  8035e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8035e9:	01 c2                	add    %eax,%edx
  8035eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ee:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  8035f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  8035fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fe:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803605:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803609:	75 17                	jne    803622 <insert_sorted_with_merge_freeList+0x680>
  80360b:	83 ec 04             	sub    $0x4,%esp
  80360e:	68 f0 41 80 00       	push   $0x8041f0
  803613:	68 61 01 00 00       	push   $0x161
  803618:	68 13 42 80 00       	push   $0x804213
  80361d:	e8 ea d2 ff ff       	call   80090c <_panic>
  803622:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803628:	8b 45 08             	mov    0x8(%ebp),%eax
  80362b:	89 10                	mov    %edx,(%eax)
  80362d:	8b 45 08             	mov    0x8(%ebp),%eax
  803630:	8b 00                	mov    (%eax),%eax
  803632:	85 c0                	test   %eax,%eax
  803634:	74 0d                	je     803643 <insert_sorted_with_merge_freeList+0x6a1>
  803636:	a1 48 51 80 00       	mov    0x805148,%eax
  80363b:	8b 55 08             	mov    0x8(%ebp),%edx
  80363e:	89 50 04             	mov    %edx,0x4(%eax)
  803641:	eb 08                	jmp    80364b <insert_sorted_with_merge_freeList+0x6a9>
  803643:	8b 45 08             	mov    0x8(%ebp),%eax
  803646:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80364b:	8b 45 08             	mov    0x8(%ebp),%eax
  80364e:	a3 48 51 80 00       	mov    %eax,0x805148
  803653:	8b 45 08             	mov    0x8(%ebp),%eax
  803656:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80365d:	a1 54 51 80 00       	mov    0x805154,%eax
  803662:	40                   	inc    %eax
  803663:	a3 54 51 80 00       	mov    %eax,0x805154
								}
								break;
  803668:	eb 3a                	jmp    8036a4 <insert_sorted_with_merge_freeList+0x702>
  80366a:	eb 38                	jmp    8036a4 <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  80366c:	a1 40 51 80 00       	mov    0x805140,%eax
  803671:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803674:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803678:	74 07                	je     803681 <insert_sorted_with_merge_freeList+0x6df>
  80367a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80367d:	8b 00                	mov    (%eax),%eax
  80367f:	eb 05                	jmp    803686 <insert_sorted_with_merge_freeList+0x6e4>
  803681:	b8 00 00 00 00       	mov    $0x0,%eax
  803686:	a3 40 51 80 00       	mov    %eax,0x805140
  80368b:	a1 40 51 80 00       	mov    0x805140,%eax
  803690:	85 c0                	test   %eax,%eax
  803692:	0f 85 fa fb ff ff    	jne    803292 <insert_sorted_with_merge_freeList+0x2f0>
  803698:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80369c:	0f 85 f0 fb ff ff    	jne    803292 <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  8036a2:	eb 01                	jmp    8036a5 <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  8036a4:	90                   	nop
							}

						}
		          }
		}
}
  8036a5:	90                   	nop
  8036a6:	c9                   	leave  
  8036a7:	c3                   	ret    

008036a8 <__udivdi3>:
  8036a8:	55                   	push   %ebp
  8036a9:	57                   	push   %edi
  8036aa:	56                   	push   %esi
  8036ab:	53                   	push   %ebx
  8036ac:	83 ec 1c             	sub    $0x1c,%esp
  8036af:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8036b3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8036b7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8036bb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8036bf:	89 ca                	mov    %ecx,%edx
  8036c1:	89 f8                	mov    %edi,%eax
  8036c3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8036c7:	85 f6                	test   %esi,%esi
  8036c9:	75 2d                	jne    8036f8 <__udivdi3+0x50>
  8036cb:	39 cf                	cmp    %ecx,%edi
  8036cd:	77 65                	ja     803734 <__udivdi3+0x8c>
  8036cf:	89 fd                	mov    %edi,%ebp
  8036d1:	85 ff                	test   %edi,%edi
  8036d3:	75 0b                	jne    8036e0 <__udivdi3+0x38>
  8036d5:	b8 01 00 00 00       	mov    $0x1,%eax
  8036da:	31 d2                	xor    %edx,%edx
  8036dc:	f7 f7                	div    %edi
  8036de:	89 c5                	mov    %eax,%ebp
  8036e0:	31 d2                	xor    %edx,%edx
  8036e2:	89 c8                	mov    %ecx,%eax
  8036e4:	f7 f5                	div    %ebp
  8036e6:	89 c1                	mov    %eax,%ecx
  8036e8:	89 d8                	mov    %ebx,%eax
  8036ea:	f7 f5                	div    %ebp
  8036ec:	89 cf                	mov    %ecx,%edi
  8036ee:	89 fa                	mov    %edi,%edx
  8036f0:	83 c4 1c             	add    $0x1c,%esp
  8036f3:	5b                   	pop    %ebx
  8036f4:	5e                   	pop    %esi
  8036f5:	5f                   	pop    %edi
  8036f6:	5d                   	pop    %ebp
  8036f7:	c3                   	ret    
  8036f8:	39 ce                	cmp    %ecx,%esi
  8036fa:	77 28                	ja     803724 <__udivdi3+0x7c>
  8036fc:	0f bd fe             	bsr    %esi,%edi
  8036ff:	83 f7 1f             	xor    $0x1f,%edi
  803702:	75 40                	jne    803744 <__udivdi3+0x9c>
  803704:	39 ce                	cmp    %ecx,%esi
  803706:	72 0a                	jb     803712 <__udivdi3+0x6a>
  803708:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80370c:	0f 87 9e 00 00 00    	ja     8037b0 <__udivdi3+0x108>
  803712:	b8 01 00 00 00       	mov    $0x1,%eax
  803717:	89 fa                	mov    %edi,%edx
  803719:	83 c4 1c             	add    $0x1c,%esp
  80371c:	5b                   	pop    %ebx
  80371d:	5e                   	pop    %esi
  80371e:	5f                   	pop    %edi
  80371f:	5d                   	pop    %ebp
  803720:	c3                   	ret    
  803721:	8d 76 00             	lea    0x0(%esi),%esi
  803724:	31 ff                	xor    %edi,%edi
  803726:	31 c0                	xor    %eax,%eax
  803728:	89 fa                	mov    %edi,%edx
  80372a:	83 c4 1c             	add    $0x1c,%esp
  80372d:	5b                   	pop    %ebx
  80372e:	5e                   	pop    %esi
  80372f:	5f                   	pop    %edi
  803730:	5d                   	pop    %ebp
  803731:	c3                   	ret    
  803732:	66 90                	xchg   %ax,%ax
  803734:	89 d8                	mov    %ebx,%eax
  803736:	f7 f7                	div    %edi
  803738:	31 ff                	xor    %edi,%edi
  80373a:	89 fa                	mov    %edi,%edx
  80373c:	83 c4 1c             	add    $0x1c,%esp
  80373f:	5b                   	pop    %ebx
  803740:	5e                   	pop    %esi
  803741:	5f                   	pop    %edi
  803742:	5d                   	pop    %ebp
  803743:	c3                   	ret    
  803744:	bd 20 00 00 00       	mov    $0x20,%ebp
  803749:	89 eb                	mov    %ebp,%ebx
  80374b:	29 fb                	sub    %edi,%ebx
  80374d:	89 f9                	mov    %edi,%ecx
  80374f:	d3 e6                	shl    %cl,%esi
  803751:	89 c5                	mov    %eax,%ebp
  803753:	88 d9                	mov    %bl,%cl
  803755:	d3 ed                	shr    %cl,%ebp
  803757:	89 e9                	mov    %ebp,%ecx
  803759:	09 f1                	or     %esi,%ecx
  80375b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80375f:	89 f9                	mov    %edi,%ecx
  803761:	d3 e0                	shl    %cl,%eax
  803763:	89 c5                	mov    %eax,%ebp
  803765:	89 d6                	mov    %edx,%esi
  803767:	88 d9                	mov    %bl,%cl
  803769:	d3 ee                	shr    %cl,%esi
  80376b:	89 f9                	mov    %edi,%ecx
  80376d:	d3 e2                	shl    %cl,%edx
  80376f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803773:	88 d9                	mov    %bl,%cl
  803775:	d3 e8                	shr    %cl,%eax
  803777:	09 c2                	or     %eax,%edx
  803779:	89 d0                	mov    %edx,%eax
  80377b:	89 f2                	mov    %esi,%edx
  80377d:	f7 74 24 0c          	divl   0xc(%esp)
  803781:	89 d6                	mov    %edx,%esi
  803783:	89 c3                	mov    %eax,%ebx
  803785:	f7 e5                	mul    %ebp
  803787:	39 d6                	cmp    %edx,%esi
  803789:	72 19                	jb     8037a4 <__udivdi3+0xfc>
  80378b:	74 0b                	je     803798 <__udivdi3+0xf0>
  80378d:	89 d8                	mov    %ebx,%eax
  80378f:	31 ff                	xor    %edi,%edi
  803791:	e9 58 ff ff ff       	jmp    8036ee <__udivdi3+0x46>
  803796:	66 90                	xchg   %ax,%ax
  803798:	8b 54 24 08          	mov    0x8(%esp),%edx
  80379c:	89 f9                	mov    %edi,%ecx
  80379e:	d3 e2                	shl    %cl,%edx
  8037a0:	39 c2                	cmp    %eax,%edx
  8037a2:	73 e9                	jae    80378d <__udivdi3+0xe5>
  8037a4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8037a7:	31 ff                	xor    %edi,%edi
  8037a9:	e9 40 ff ff ff       	jmp    8036ee <__udivdi3+0x46>
  8037ae:	66 90                	xchg   %ax,%ax
  8037b0:	31 c0                	xor    %eax,%eax
  8037b2:	e9 37 ff ff ff       	jmp    8036ee <__udivdi3+0x46>
  8037b7:	90                   	nop

008037b8 <__umoddi3>:
  8037b8:	55                   	push   %ebp
  8037b9:	57                   	push   %edi
  8037ba:	56                   	push   %esi
  8037bb:	53                   	push   %ebx
  8037bc:	83 ec 1c             	sub    $0x1c,%esp
  8037bf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8037c3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8037c7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8037cb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8037cf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8037d3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8037d7:	89 f3                	mov    %esi,%ebx
  8037d9:	89 fa                	mov    %edi,%edx
  8037db:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037df:	89 34 24             	mov    %esi,(%esp)
  8037e2:	85 c0                	test   %eax,%eax
  8037e4:	75 1a                	jne    803800 <__umoddi3+0x48>
  8037e6:	39 f7                	cmp    %esi,%edi
  8037e8:	0f 86 a2 00 00 00    	jbe    803890 <__umoddi3+0xd8>
  8037ee:	89 c8                	mov    %ecx,%eax
  8037f0:	89 f2                	mov    %esi,%edx
  8037f2:	f7 f7                	div    %edi
  8037f4:	89 d0                	mov    %edx,%eax
  8037f6:	31 d2                	xor    %edx,%edx
  8037f8:	83 c4 1c             	add    $0x1c,%esp
  8037fb:	5b                   	pop    %ebx
  8037fc:	5e                   	pop    %esi
  8037fd:	5f                   	pop    %edi
  8037fe:	5d                   	pop    %ebp
  8037ff:	c3                   	ret    
  803800:	39 f0                	cmp    %esi,%eax
  803802:	0f 87 ac 00 00 00    	ja     8038b4 <__umoddi3+0xfc>
  803808:	0f bd e8             	bsr    %eax,%ebp
  80380b:	83 f5 1f             	xor    $0x1f,%ebp
  80380e:	0f 84 ac 00 00 00    	je     8038c0 <__umoddi3+0x108>
  803814:	bf 20 00 00 00       	mov    $0x20,%edi
  803819:	29 ef                	sub    %ebp,%edi
  80381b:	89 fe                	mov    %edi,%esi
  80381d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803821:	89 e9                	mov    %ebp,%ecx
  803823:	d3 e0                	shl    %cl,%eax
  803825:	89 d7                	mov    %edx,%edi
  803827:	89 f1                	mov    %esi,%ecx
  803829:	d3 ef                	shr    %cl,%edi
  80382b:	09 c7                	or     %eax,%edi
  80382d:	89 e9                	mov    %ebp,%ecx
  80382f:	d3 e2                	shl    %cl,%edx
  803831:	89 14 24             	mov    %edx,(%esp)
  803834:	89 d8                	mov    %ebx,%eax
  803836:	d3 e0                	shl    %cl,%eax
  803838:	89 c2                	mov    %eax,%edx
  80383a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80383e:	d3 e0                	shl    %cl,%eax
  803840:	89 44 24 04          	mov    %eax,0x4(%esp)
  803844:	8b 44 24 08          	mov    0x8(%esp),%eax
  803848:	89 f1                	mov    %esi,%ecx
  80384a:	d3 e8                	shr    %cl,%eax
  80384c:	09 d0                	or     %edx,%eax
  80384e:	d3 eb                	shr    %cl,%ebx
  803850:	89 da                	mov    %ebx,%edx
  803852:	f7 f7                	div    %edi
  803854:	89 d3                	mov    %edx,%ebx
  803856:	f7 24 24             	mull   (%esp)
  803859:	89 c6                	mov    %eax,%esi
  80385b:	89 d1                	mov    %edx,%ecx
  80385d:	39 d3                	cmp    %edx,%ebx
  80385f:	0f 82 87 00 00 00    	jb     8038ec <__umoddi3+0x134>
  803865:	0f 84 91 00 00 00    	je     8038fc <__umoddi3+0x144>
  80386b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80386f:	29 f2                	sub    %esi,%edx
  803871:	19 cb                	sbb    %ecx,%ebx
  803873:	89 d8                	mov    %ebx,%eax
  803875:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803879:	d3 e0                	shl    %cl,%eax
  80387b:	89 e9                	mov    %ebp,%ecx
  80387d:	d3 ea                	shr    %cl,%edx
  80387f:	09 d0                	or     %edx,%eax
  803881:	89 e9                	mov    %ebp,%ecx
  803883:	d3 eb                	shr    %cl,%ebx
  803885:	89 da                	mov    %ebx,%edx
  803887:	83 c4 1c             	add    $0x1c,%esp
  80388a:	5b                   	pop    %ebx
  80388b:	5e                   	pop    %esi
  80388c:	5f                   	pop    %edi
  80388d:	5d                   	pop    %ebp
  80388e:	c3                   	ret    
  80388f:	90                   	nop
  803890:	89 fd                	mov    %edi,%ebp
  803892:	85 ff                	test   %edi,%edi
  803894:	75 0b                	jne    8038a1 <__umoddi3+0xe9>
  803896:	b8 01 00 00 00       	mov    $0x1,%eax
  80389b:	31 d2                	xor    %edx,%edx
  80389d:	f7 f7                	div    %edi
  80389f:	89 c5                	mov    %eax,%ebp
  8038a1:	89 f0                	mov    %esi,%eax
  8038a3:	31 d2                	xor    %edx,%edx
  8038a5:	f7 f5                	div    %ebp
  8038a7:	89 c8                	mov    %ecx,%eax
  8038a9:	f7 f5                	div    %ebp
  8038ab:	89 d0                	mov    %edx,%eax
  8038ad:	e9 44 ff ff ff       	jmp    8037f6 <__umoddi3+0x3e>
  8038b2:	66 90                	xchg   %ax,%ax
  8038b4:	89 c8                	mov    %ecx,%eax
  8038b6:	89 f2                	mov    %esi,%edx
  8038b8:	83 c4 1c             	add    $0x1c,%esp
  8038bb:	5b                   	pop    %ebx
  8038bc:	5e                   	pop    %esi
  8038bd:	5f                   	pop    %edi
  8038be:	5d                   	pop    %ebp
  8038bf:	c3                   	ret    
  8038c0:	3b 04 24             	cmp    (%esp),%eax
  8038c3:	72 06                	jb     8038cb <__umoddi3+0x113>
  8038c5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8038c9:	77 0f                	ja     8038da <__umoddi3+0x122>
  8038cb:	89 f2                	mov    %esi,%edx
  8038cd:	29 f9                	sub    %edi,%ecx
  8038cf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8038d3:	89 14 24             	mov    %edx,(%esp)
  8038d6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8038da:	8b 44 24 04          	mov    0x4(%esp),%eax
  8038de:	8b 14 24             	mov    (%esp),%edx
  8038e1:	83 c4 1c             	add    $0x1c,%esp
  8038e4:	5b                   	pop    %ebx
  8038e5:	5e                   	pop    %esi
  8038e6:	5f                   	pop    %edi
  8038e7:	5d                   	pop    %ebp
  8038e8:	c3                   	ret    
  8038e9:	8d 76 00             	lea    0x0(%esi),%esi
  8038ec:	2b 04 24             	sub    (%esp),%eax
  8038ef:	19 fa                	sbb    %edi,%edx
  8038f1:	89 d1                	mov    %edx,%ecx
  8038f3:	89 c6                	mov    %eax,%esi
  8038f5:	e9 71 ff ff ff       	jmp    80386b <__umoddi3+0xb3>
  8038fa:	66 90                	xchg   %ax,%ax
  8038fc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803900:	72 ea                	jb     8038ec <__umoddi3+0x134>
  803902:	89 d9                	mov    %ebx,%ecx
  803904:	e9 62 ff ff ff       	jmp    80386b <__umoddi3+0xb3>

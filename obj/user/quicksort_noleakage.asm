
obj/user/quicksort_noleakage:     file format elf32-i386


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
  800031:	e8 0e 06 00 00       	call   800644 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void QuickSort(int *Elements, int NumOfElements);
void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex);
uint32 CheckSorted(int *Elements, int NumOfElements);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	char Line[255] ;
	char Chose ;
	do
	{
		//2012: lock the interrupt
		sys_disable_interrupt();
  800041:	e8 7d 20 00 00       	call   8020c3 <sys_disable_interrupt>
		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 a0 39 80 00       	push   $0x8039a0
  80004e:	e8 e1 09 00 00       	call   800a34 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 a2 39 80 00       	push   $0x8039a2
  80005e:	e8 d1 09 00 00       	call   800a34 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   QUICK SORT    !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 bb 39 80 00       	push   $0x8039bb
  80006e:	e8 c1 09 00 00       	call   800a34 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 a2 39 80 00       	push   $0x8039a2
  80007e:	e8 b1 09 00 00       	call   800a34 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 a0 39 80 00       	push   $0x8039a0
  80008e:	e8 a1 09 00 00       	call   800a34 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 d4 39 80 00       	push   $0x8039d4
  8000a5:	e8 0c 10 00 00       	call   8010b6 <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 5c 15 00 00       	call   80161c <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 94 1a 00 00       	call   801b69 <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 f4 39 80 00       	push   $0x8039f4
  8000e3:	e8 4c 09 00 00       	call   800a34 <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 16 3a 80 00       	push   $0x803a16
  8000f3:	e8 3c 09 00 00       	call   800a34 <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 24 3a 80 00       	push   $0x803a24
  800103:	e8 2c 09 00 00       	call   800a34 <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 33 3a 80 00       	push   $0x803a33
  800113:	e8 1c 09 00 00       	call   800a34 <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 43 3a 80 00       	push   $0x803a43
  800123:	e8 0c 09 00 00       	call   800a34 <cprintf>
  800128:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012b:	e8 bc 04 00 00       	call   8005ec <getchar>
  800130:	88 45 ef             	mov    %al,-0x11(%ebp)
			cputchar(Chose);
  800133:	0f be 45 ef          	movsbl -0x11(%ebp),%eax
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	50                   	push   %eax
  80013b:	e8 64 04 00 00       	call   8005a4 <cputchar>
  800140:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	6a 0a                	push   $0xa
  800148:	e8 57 04 00 00       	call   8005a4 <cputchar>
  80014d:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800150:	80 7d ef 61          	cmpb   $0x61,-0x11(%ebp)
  800154:	74 0c                	je     800162 <_main+0x12a>
  800156:	80 7d ef 62          	cmpb   $0x62,-0x11(%ebp)
  80015a:	74 06                	je     800162 <_main+0x12a>
  80015c:	80 7d ef 63          	cmpb   $0x63,-0x11(%ebp)
  800160:	75 b9                	jne    80011b <_main+0xe3>

		//2012: lock the interrupt
		sys_enable_interrupt();
  800162:	e8 76 1f 00 00       	call   8020dd <sys_enable_interrupt>

		int  i ;
		switch (Chose)
  800167:	0f be 45 ef          	movsbl -0x11(%ebp),%eax
  80016b:	83 f8 62             	cmp    $0x62,%eax
  80016e:	74 1d                	je     80018d <_main+0x155>
  800170:	83 f8 63             	cmp    $0x63,%eax
  800173:	74 2b                	je     8001a0 <_main+0x168>
  800175:	83 f8 61             	cmp    $0x61,%eax
  800178:	75 39                	jne    8001b3 <_main+0x17b>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80017a:	83 ec 08             	sub    $0x8,%esp
  80017d:	ff 75 f4             	pushl  -0xc(%ebp)
  800180:	ff 75 f0             	pushl  -0x10(%ebp)
  800183:	e8 e4 02 00 00       	call   80046c <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f4             	pushl  -0xc(%ebp)
  800193:	ff 75 f0             	pushl  -0x10(%ebp)
  800196:	e8 02 03 00 00       	call   80049d <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8001a6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a9:	e8 24 03 00 00       	call   8004d2 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8001b9:	ff 75 f0             	pushl  -0x10(%ebp)
  8001bc:	e8 11 03 00 00       	call   8004d2 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8001ca:	ff 75 f0             	pushl  -0x10(%ebp)
  8001cd:	e8 df 00 00 00       	call   8002b1 <QuickSort>
  8001d2:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001d5:	e8 e9 1e 00 00       	call   8020c3 <sys_disable_interrupt>
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 4c 3a 80 00       	push   $0x803a4c
  8001e2:	e8 4d 08 00 00       	call   800a34 <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
		//		PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ea:	e8 ee 1e 00 00       	call   8020dd <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001ef:	83 ec 08             	sub    $0x8,%esp
  8001f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8001f5:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f8:	e8 c5 01 00 00       	call   8003c2 <CheckSorted>
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800203:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800207:	75 14                	jne    80021d <_main+0x1e5>
  800209:	83 ec 04             	sub    $0x4,%esp
  80020c:	68 80 3a 80 00       	push   $0x803a80
  800211:	6a 49                	push   $0x49
  800213:	68 a2 3a 80 00       	push   $0x803aa2
  800218:	e8 63 05 00 00       	call   800780 <_panic>
		else
		{
			sys_disable_interrupt();
  80021d:	e8 a1 1e 00 00       	call   8020c3 <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 c0 3a 80 00       	push   $0x803ac0
  80022a:	e8 05 08 00 00       	call   800a34 <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 f4 3a 80 00       	push   $0x803af4
  80023a:	e8 f5 07 00 00       	call   800a34 <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 28 3b 80 00       	push   $0x803b28
  80024a:	e8 e5 07 00 00       	call   800a34 <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800252:	e8 86 1e 00 00       	call   8020dd <sys_enable_interrupt>

		}

		free(Elements) ;
  800257:	83 ec 0c             	sub    $0xc,%esp
  80025a:	ff 75 f0             	pushl  -0x10(%ebp)
  80025d:	e8 89 19 00 00       	call   801beb <free>
  800262:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  800265:	e8 59 1e 00 00       	call   8020c3 <sys_disable_interrupt>

		cprintf("Do you want to repeat (y/n): ") ;
  80026a:	83 ec 0c             	sub    $0xc,%esp
  80026d:	68 5a 3b 80 00       	push   $0x803b5a
  800272:	e8 bd 07 00 00       	call   800a34 <cprintf>
  800277:	83 c4 10             	add    $0x10,%esp
		Chose = getchar() ;
  80027a:	e8 6d 03 00 00       	call   8005ec <getchar>
  80027f:	88 45 ef             	mov    %al,-0x11(%ebp)
		cputchar(Chose);
  800282:	0f be 45 ef          	movsbl -0x11(%ebp),%eax
  800286:	83 ec 0c             	sub    $0xc,%esp
  800289:	50                   	push   %eax
  80028a:	e8 15 03 00 00       	call   8005a4 <cputchar>
  80028f:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  800292:	83 ec 0c             	sub    $0xc,%esp
  800295:	6a 0a                	push   $0xa
  800297:	e8 08 03 00 00       	call   8005a4 <cputchar>
  80029c:	83 c4 10             	add    $0x10,%esp

		sys_enable_interrupt();
  80029f:	e8 39 1e 00 00       	call   8020dd <sys_enable_interrupt>

	} while (Chose == 'y');
  8002a4:	80 7d ef 79          	cmpb   $0x79,-0x11(%ebp)
  8002a8:	0f 84 93 fd ff ff    	je     800041 <_main+0x9>

}
  8002ae:	90                   	nop
  8002af:	c9                   	leave  
  8002b0:	c3                   	ret    

008002b1 <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  8002b1:	55                   	push   %ebp
  8002b2:	89 e5                	mov    %esp,%ebp
  8002b4:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  8002b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ba:	48                   	dec    %eax
  8002bb:	50                   	push   %eax
  8002bc:	6a 00                	push   $0x0
  8002be:	ff 75 0c             	pushl  0xc(%ebp)
  8002c1:	ff 75 08             	pushl  0x8(%ebp)
  8002c4:	e8 06 00 00 00       	call   8002cf <QSort>
  8002c9:	83 c4 10             	add    $0x10,%esp
}
  8002cc:	90                   	nop
  8002cd:	c9                   	leave  
  8002ce:	c3                   	ret    

008002cf <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  8002cf:	55                   	push   %ebp
  8002d0:	89 e5                	mov    %esp,%ebp
  8002d2:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8002d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8002d8:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002db:	0f 8d de 00 00 00    	jge    8003bf <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  8002e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8002e4:	40                   	inc    %eax
  8002e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8002e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8002eb:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  8002ee:	e9 80 00 00 00       	jmp    800373 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  8002f3:	ff 45 f4             	incl   -0xc(%ebp)
  8002f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002f9:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002fc:	7f 2b                	jg     800329 <QSort+0x5a>
  8002fe:	8b 45 10             	mov    0x10(%ebp),%eax
  800301:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800308:	8b 45 08             	mov    0x8(%ebp),%eax
  80030b:	01 d0                	add    %edx,%eax
  80030d:	8b 10                	mov    (%eax),%edx
  80030f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800312:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800319:	8b 45 08             	mov    0x8(%ebp),%eax
  80031c:	01 c8                	add    %ecx,%eax
  80031e:	8b 00                	mov    (%eax),%eax
  800320:	39 c2                	cmp    %eax,%edx
  800322:	7d cf                	jge    8002f3 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  800324:	eb 03                	jmp    800329 <QSort+0x5a>
  800326:	ff 4d f0             	decl   -0x10(%ebp)
  800329:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80032c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80032f:	7e 26                	jle    800357 <QSort+0x88>
  800331:	8b 45 10             	mov    0x10(%ebp),%eax
  800334:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80033b:	8b 45 08             	mov    0x8(%ebp),%eax
  80033e:	01 d0                	add    %edx,%eax
  800340:	8b 10                	mov    (%eax),%edx
  800342:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800345:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80034c:	8b 45 08             	mov    0x8(%ebp),%eax
  80034f:	01 c8                	add    %ecx,%eax
  800351:	8b 00                	mov    (%eax),%eax
  800353:	39 c2                	cmp    %eax,%edx
  800355:	7e cf                	jle    800326 <QSort+0x57>

		if (i <= j)
  800357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80035a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80035d:	7f 14                	jg     800373 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  80035f:	83 ec 04             	sub    $0x4,%esp
  800362:	ff 75 f0             	pushl  -0x10(%ebp)
  800365:	ff 75 f4             	pushl  -0xc(%ebp)
  800368:	ff 75 08             	pushl  0x8(%ebp)
  80036b:	e8 a9 00 00 00       	call   800419 <Swap>
  800370:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800373:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800376:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800379:	0f 8e 77 ff ff ff    	jle    8002f6 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  80037f:	83 ec 04             	sub    $0x4,%esp
  800382:	ff 75 f0             	pushl  -0x10(%ebp)
  800385:	ff 75 10             	pushl  0x10(%ebp)
  800388:	ff 75 08             	pushl  0x8(%ebp)
  80038b:	e8 89 00 00 00       	call   800419 <Swap>
  800390:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  800393:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800396:	48                   	dec    %eax
  800397:	50                   	push   %eax
  800398:	ff 75 10             	pushl  0x10(%ebp)
  80039b:	ff 75 0c             	pushl  0xc(%ebp)
  80039e:	ff 75 08             	pushl  0x8(%ebp)
  8003a1:	e8 29 ff ff ff       	call   8002cf <QSort>
  8003a6:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  8003a9:	ff 75 14             	pushl  0x14(%ebp)
  8003ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8003af:	ff 75 0c             	pushl  0xc(%ebp)
  8003b2:	ff 75 08             	pushl  0x8(%ebp)
  8003b5:	e8 15 ff ff ff       	call   8002cf <QSort>
  8003ba:	83 c4 10             	add    $0x10,%esp
  8003bd:	eb 01                	jmp    8003c0 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  8003bf:	90                   	nop
	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);

	//cprintf("qs,after sorting: start = %d, end = %d\n", startIndex, finalIndex);

}
  8003c0:	c9                   	leave  
  8003c1:	c3                   	ret    

008003c2 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8003c2:	55                   	push   %ebp
  8003c3:	89 e5                	mov    %esp,%ebp
  8003c5:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8003c8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003cf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8003d6:	eb 33                	jmp    80040b <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8003d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003db:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e5:	01 d0                	add    %edx,%eax
  8003e7:	8b 10                	mov    (%eax),%edx
  8003e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003ec:	40                   	inc    %eax
  8003ed:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f7:	01 c8                	add    %ecx,%eax
  8003f9:	8b 00                	mov    (%eax),%eax
  8003fb:	39 c2                	cmp    %eax,%edx
  8003fd:	7e 09                	jle    800408 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  8003ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800406:	eb 0c                	jmp    800414 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800408:	ff 45 f8             	incl   -0x8(%ebp)
  80040b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80040e:	48                   	dec    %eax
  80040f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800412:	7f c4                	jg     8003d8 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800414:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800417:	c9                   	leave  
  800418:	c3                   	ret    

00800419 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  800419:	55                   	push   %ebp
  80041a:	89 e5                	mov    %esp,%ebp
  80041c:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  80041f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800422:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800429:	8b 45 08             	mov    0x8(%ebp),%eax
  80042c:	01 d0                	add    %edx,%eax
  80042e:	8b 00                	mov    (%eax),%eax
  800430:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800433:	8b 45 0c             	mov    0xc(%ebp),%eax
  800436:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80043d:	8b 45 08             	mov    0x8(%ebp),%eax
  800440:	01 c2                	add    %eax,%edx
  800442:	8b 45 10             	mov    0x10(%ebp),%eax
  800445:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80044c:	8b 45 08             	mov    0x8(%ebp),%eax
  80044f:	01 c8                	add    %ecx,%eax
  800451:	8b 00                	mov    (%eax),%eax
  800453:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800455:	8b 45 10             	mov    0x10(%ebp),%eax
  800458:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045f:	8b 45 08             	mov    0x8(%ebp),%eax
  800462:	01 c2                	add    %eax,%edx
  800464:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800467:	89 02                	mov    %eax,(%edx)
}
  800469:	90                   	nop
  80046a:	c9                   	leave  
  80046b:	c3                   	ret    

0080046c <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80046c:	55                   	push   %ebp
  80046d:	89 e5                	mov    %esp,%ebp
  80046f:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800472:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800479:	eb 17                	jmp    800492 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80047b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80047e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800485:	8b 45 08             	mov    0x8(%ebp),%eax
  800488:	01 c2                	add    %eax,%edx
  80048a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80048d:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80048f:	ff 45 fc             	incl   -0x4(%ebp)
  800492:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800495:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800498:	7c e1                	jl     80047b <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  80049a:	90                   	nop
  80049b:	c9                   	leave  
  80049c:	c3                   	ret    

0080049d <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  80049d:	55                   	push   %ebp
  80049e:	89 e5                	mov    %esp,%ebp
  8004a0:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004aa:	eb 1b                	jmp    8004c7 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8004ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004af:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b9:	01 c2                	add    %eax,%edx
  8004bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004be:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8004c1:	48                   	dec    %eax
  8004c2:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004c4:	ff 45 fc             	incl   -0x4(%ebp)
  8004c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004ca:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004cd:	7c dd                	jl     8004ac <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8004cf:	90                   	nop
  8004d0:	c9                   	leave  
  8004d1:	c3                   	ret    

008004d2 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8004d2:	55                   	push   %ebp
  8004d3:	89 e5                	mov    %esp,%ebp
  8004d5:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8004d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004db:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8004e0:	f7 e9                	imul   %ecx
  8004e2:	c1 f9 1f             	sar    $0x1f,%ecx
  8004e5:	89 d0                	mov    %edx,%eax
  8004e7:	29 c8                	sub    %ecx,%eax
  8004e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8004ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004f3:	eb 1e                	jmp    800513 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  8004f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800502:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800505:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800508:	99                   	cltd   
  800509:	f7 7d f8             	idivl  -0x8(%ebp)
  80050c:	89 d0                	mov    %edx,%eax
  80050e:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800510:	ff 45 fc             	incl   -0x4(%ebp)
  800513:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800516:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800519:	7c da                	jl     8004f5 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  80051b:	90                   	nop
  80051c:	c9                   	leave  
  80051d:	c3                   	ret    

0080051e <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  80051e:	55                   	push   %ebp
  80051f:	89 e5                	mov    %esp,%ebp
  800521:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800524:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80052b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800532:	eb 42                	jmp    800576 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800534:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800537:	99                   	cltd   
  800538:	f7 7d f0             	idivl  -0x10(%ebp)
  80053b:	89 d0                	mov    %edx,%eax
  80053d:	85 c0                	test   %eax,%eax
  80053f:	75 10                	jne    800551 <PrintElements+0x33>
			cprintf("\n");
  800541:	83 ec 0c             	sub    $0xc,%esp
  800544:	68 a0 39 80 00       	push   $0x8039a0
  800549:	e8 e6 04 00 00       	call   800a34 <cprintf>
  80054e:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800554:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80055b:	8b 45 08             	mov    0x8(%ebp),%eax
  80055e:	01 d0                	add    %edx,%eax
  800560:	8b 00                	mov    (%eax),%eax
  800562:	83 ec 08             	sub    $0x8,%esp
  800565:	50                   	push   %eax
  800566:	68 78 3b 80 00       	push   $0x803b78
  80056b:	e8 c4 04 00 00       	call   800a34 <cprintf>
  800570:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800573:	ff 45 f4             	incl   -0xc(%ebp)
  800576:	8b 45 0c             	mov    0xc(%ebp),%eax
  800579:	48                   	dec    %eax
  80057a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80057d:	7f b5                	jg     800534 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  80057f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800582:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800589:	8b 45 08             	mov    0x8(%ebp),%eax
  80058c:	01 d0                	add    %edx,%eax
  80058e:	8b 00                	mov    (%eax),%eax
  800590:	83 ec 08             	sub    $0x8,%esp
  800593:	50                   	push   %eax
  800594:	68 7d 3b 80 00       	push   $0x803b7d
  800599:	e8 96 04 00 00       	call   800a34 <cprintf>
  80059e:	83 c4 10             	add    $0x10,%esp

}
  8005a1:	90                   	nop
  8005a2:	c9                   	leave  
  8005a3:	c3                   	ret    

008005a4 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8005a4:	55                   	push   %ebp
  8005a5:	89 e5                	mov    %esp,%ebp
  8005a7:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8005aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ad:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005b0:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005b4:	83 ec 0c             	sub    $0xc,%esp
  8005b7:	50                   	push   %eax
  8005b8:	e8 3a 1b 00 00       	call   8020f7 <sys_cputc>
  8005bd:	83 c4 10             	add    $0x10,%esp
}
  8005c0:	90                   	nop
  8005c1:	c9                   	leave  
  8005c2:	c3                   	ret    

008005c3 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8005c3:	55                   	push   %ebp
  8005c4:	89 e5                	mov    %esp,%ebp
  8005c6:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005c9:	e8 f5 1a 00 00       	call   8020c3 <sys_disable_interrupt>
	char c = ch;
  8005ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d1:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005d4:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005d8:	83 ec 0c             	sub    $0xc,%esp
  8005db:	50                   	push   %eax
  8005dc:	e8 16 1b 00 00       	call   8020f7 <sys_cputc>
  8005e1:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8005e4:	e8 f4 1a 00 00       	call   8020dd <sys_enable_interrupt>
}
  8005e9:	90                   	nop
  8005ea:	c9                   	leave  
  8005eb:	c3                   	ret    

008005ec <getchar>:

int
getchar(void)
{
  8005ec:	55                   	push   %ebp
  8005ed:	89 e5                	mov    %esp,%ebp
  8005ef:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  8005f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8005f9:	eb 08                	jmp    800603 <getchar+0x17>
	{
		c = sys_cgetc();
  8005fb:	e8 3e 19 00 00       	call   801f3e <sys_cgetc>
  800600:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800603:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800607:	74 f2                	je     8005fb <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  800609:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80060c:	c9                   	leave  
  80060d:	c3                   	ret    

0080060e <atomic_getchar>:

int
atomic_getchar(void)
{
  80060e:	55                   	push   %ebp
  80060f:	89 e5                	mov    %esp,%ebp
  800611:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800614:	e8 aa 1a 00 00       	call   8020c3 <sys_disable_interrupt>
	int c=0;
  800619:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800620:	eb 08                	jmp    80062a <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800622:	e8 17 19 00 00       	call   801f3e <sys_cgetc>
  800627:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  80062a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80062e:	74 f2                	je     800622 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800630:	e8 a8 1a 00 00       	call   8020dd <sys_enable_interrupt>
	return c;
  800635:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800638:	c9                   	leave  
  800639:	c3                   	ret    

0080063a <iscons>:

int iscons(int fdnum)
{
  80063a:	55                   	push   %ebp
  80063b:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80063d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800642:	5d                   	pop    %ebp
  800643:	c3                   	ret    

00800644 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800644:	55                   	push   %ebp
  800645:	89 e5                	mov    %esp,%ebp
  800647:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80064a:	e8 67 1c 00 00       	call   8022b6 <sys_getenvindex>
  80064f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800652:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800655:	89 d0                	mov    %edx,%eax
  800657:	c1 e0 03             	shl    $0x3,%eax
  80065a:	01 d0                	add    %edx,%eax
  80065c:	01 c0                	add    %eax,%eax
  80065e:	01 d0                	add    %edx,%eax
  800660:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800667:	01 d0                	add    %edx,%eax
  800669:	c1 e0 04             	shl    $0x4,%eax
  80066c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800671:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800676:	a1 24 50 80 00       	mov    0x805024,%eax
  80067b:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800681:	84 c0                	test   %al,%al
  800683:	74 0f                	je     800694 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800685:	a1 24 50 80 00       	mov    0x805024,%eax
  80068a:	05 5c 05 00 00       	add    $0x55c,%eax
  80068f:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800694:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800698:	7e 0a                	jle    8006a4 <libmain+0x60>
		binaryname = argv[0];
  80069a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80069d:	8b 00                	mov    (%eax),%eax
  80069f:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8006a4:	83 ec 08             	sub    $0x8,%esp
  8006a7:	ff 75 0c             	pushl  0xc(%ebp)
  8006aa:	ff 75 08             	pushl  0x8(%ebp)
  8006ad:	e8 86 f9 ff ff       	call   800038 <_main>
  8006b2:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8006b5:	e8 09 1a 00 00       	call   8020c3 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006ba:	83 ec 0c             	sub    $0xc,%esp
  8006bd:	68 9c 3b 80 00       	push   $0x803b9c
  8006c2:	e8 6d 03 00 00       	call   800a34 <cprintf>
  8006c7:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006ca:	a1 24 50 80 00       	mov    0x805024,%eax
  8006cf:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8006d5:	a1 24 50 80 00       	mov    0x805024,%eax
  8006da:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8006e0:	83 ec 04             	sub    $0x4,%esp
  8006e3:	52                   	push   %edx
  8006e4:	50                   	push   %eax
  8006e5:	68 c4 3b 80 00       	push   $0x803bc4
  8006ea:	e8 45 03 00 00       	call   800a34 <cprintf>
  8006ef:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8006f2:	a1 24 50 80 00       	mov    0x805024,%eax
  8006f7:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8006fd:	a1 24 50 80 00       	mov    0x805024,%eax
  800702:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800708:	a1 24 50 80 00       	mov    0x805024,%eax
  80070d:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800713:	51                   	push   %ecx
  800714:	52                   	push   %edx
  800715:	50                   	push   %eax
  800716:	68 ec 3b 80 00       	push   $0x803bec
  80071b:	e8 14 03 00 00       	call   800a34 <cprintf>
  800720:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800723:	a1 24 50 80 00       	mov    0x805024,%eax
  800728:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80072e:	83 ec 08             	sub    $0x8,%esp
  800731:	50                   	push   %eax
  800732:	68 44 3c 80 00       	push   $0x803c44
  800737:	e8 f8 02 00 00       	call   800a34 <cprintf>
  80073c:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80073f:	83 ec 0c             	sub    $0xc,%esp
  800742:	68 9c 3b 80 00       	push   $0x803b9c
  800747:	e8 e8 02 00 00       	call   800a34 <cprintf>
  80074c:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80074f:	e8 89 19 00 00       	call   8020dd <sys_enable_interrupt>

	// exit gracefully
	exit();
  800754:	e8 19 00 00 00       	call   800772 <exit>
}
  800759:	90                   	nop
  80075a:	c9                   	leave  
  80075b:	c3                   	ret    

0080075c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80075c:	55                   	push   %ebp
  80075d:	89 e5                	mov    %esp,%ebp
  80075f:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800762:	83 ec 0c             	sub    $0xc,%esp
  800765:	6a 00                	push   $0x0
  800767:	e8 16 1b 00 00       	call   802282 <sys_destroy_env>
  80076c:	83 c4 10             	add    $0x10,%esp
}
  80076f:	90                   	nop
  800770:	c9                   	leave  
  800771:	c3                   	ret    

00800772 <exit>:

void
exit(void)
{
  800772:	55                   	push   %ebp
  800773:	89 e5                	mov    %esp,%ebp
  800775:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800778:	e8 6b 1b 00 00       	call   8022e8 <sys_exit_env>
}
  80077d:	90                   	nop
  80077e:	c9                   	leave  
  80077f:	c3                   	ret    

00800780 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800780:	55                   	push   %ebp
  800781:	89 e5                	mov    %esp,%ebp
  800783:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800786:	8d 45 10             	lea    0x10(%ebp),%eax
  800789:	83 c0 04             	add    $0x4,%eax
  80078c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80078f:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800794:	85 c0                	test   %eax,%eax
  800796:	74 16                	je     8007ae <_panic+0x2e>
		cprintf("%s: ", argv0);
  800798:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80079d:	83 ec 08             	sub    $0x8,%esp
  8007a0:	50                   	push   %eax
  8007a1:	68 58 3c 80 00       	push   $0x803c58
  8007a6:	e8 89 02 00 00       	call   800a34 <cprintf>
  8007ab:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007ae:	a1 00 50 80 00       	mov    0x805000,%eax
  8007b3:	ff 75 0c             	pushl  0xc(%ebp)
  8007b6:	ff 75 08             	pushl  0x8(%ebp)
  8007b9:	50                   	push   %eax
  8007ba:	68 5d 3c 80 00       	push   $0x803c5d
  8007bf:	e8 70 02 00 00       	call   800a34 <cprintf>
  8007c4:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8007c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ca:	83 ec 08             	sub    $0x8,%esp
  8007cd:	ff 75 f4             	pushl  -0xc(%ebp)
  8007d0:	50                   	push   %eax
  8007d1:	e8 f3 01 00 00       	call   8009c9 <vcprintf>
  8007d6:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007d9:	83 ec 08             	sub    $0x8,%esp
  8007dc:	6a 00                	push   $0x0
  8007de:	68 79 3c 80 00       	push   $0x803c79
  8007e3:	e8 e1 01 00 00       	call   8009c9 <vcprintf>
  8007e8:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8007eb:	e8 82 ff ff ff       	call   800772 <exit>

	// should not return here
	while (1) ;
  8007f0:	eb fe                	jmp    8007f0 <_panic+0x70>

008007f2 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8007f2:	55                   	push   %ebp
  8007f3:	89 e5                	mov    %esp,%ebp
  8007f5:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8007f8:	a1 24 50 80 00       	mov    0x805024,%eax
  8007fd:	8b 50 74             	mov    0x74(%eax),%edx
  800800:	8b 45 0c             	mov    0xc(%ebp),%eax
  800803:	39 c2                	cmp    %eax,%edx
  800805:	74 14                	je     80081b <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800807:	83 ec 04             	sub    $0x4,%esp
  80080a:	68 7c 3c 80 00       	push   $0x803c7c
  80080f:	6a 26                	push   $0x26
  800811:	68 c8 3c 80 00       	push   $0x803cc8
  800816:	e8 65 ff ff ff       	call   800780 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80081b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800822:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800829:	e9 c2 00 00 00       	jmp    8008f0 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80082e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800831:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800838:	8b 45 08             	mov    0x8(%ebp),%eax
  80083b:	01 d0                	add    %edx,%eax
  80083d:	8b 00                	mov    (%eax),%eax
  80083f:	85 c0                	test   %eax,%eax
  800841:	75 08                	jne    80084b <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800843:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800846:	e9 a2 00 00 00       	jmp    8008ed <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80084b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800852:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800859:	eb 69                	jmp    8008c4 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80085b:	a1 24 50 80 00       	mov    0x805024,%eax
  800860:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800866:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800869:	89 d0                	mov    %edx,%eax
  80086b:	01 c0                	add    %eax,%eax
  80086d:	01 d0                	add    %edx,%eax
  80086f:	c1 e0 03             	shl    $0x3,%eax
  800872:	01 c8                	add    %ecx,%eax
  800874:	8a 40 04             	mov    0x4(%eax),%al
  800877:	84 c0                	test   %al,%al
  800879:	75 46                	jne    8008c1 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80087b:	a1 24 50 80 00       	mov    0x805024,%eax
  800880:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800886:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800889:	89 d0                	mov    %edx,%eax
  80088b:	01 c0                	add    %eax,%eax
  80088d:	01 d0                	add    %edx,%eax
  80088f:	c1 e0 03             	shl    $0x3,%eax
  800892:	01 c8                	add    %ecx,%eax
  800894:	8b 00                	mov    (%eax),%eax
  800896:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800899:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80089c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008a1:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008a6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b0:	01 c8                	add    %ecx,%eax
  8008b2:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008b4:	39 c2                	cmp    %eax,%edx
  8008b6:	75 09                	jne    8008c1 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8008b8:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8008bf:	eb 12                	jmp    8008d3 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008c1:	ff 45 e8             	incl   -0x18(%ebp)
  8008c4:	a1 24 50 80 00       	mov    0x805024,%eax
  8008c9:	8b 50 74             	mov    0x74(%eax),%edx
  8008cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008cf:	39 c2                	cmp    %eax,%edx
  8008d1:	77 88                	ja     80085b <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8008d3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008d7:	75 14                	jne    8008ed <CheckWSWithoutLastIndex+0xfb>
			panic(
  8008d9:	83 ec 04             	sub    $0x4,%esp
  8008dc:	68 d4 3c 80 00       	push   $0x803cd4
  8008e1:	6a 3a                	push   $0x3a
  8008e3:	68 c8 3c 80 00       	push   $0x803cc8
  8008e8:	e8 93 fe ff ff       	call   800780 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8008ed:	ff 45 f0             	incl   -0x10(%ebp)
  8008f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008f3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8008f6:	0f 8c 32 ff ff ff    	jl     80082e <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8008fc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800903:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80090a:	eb 26                	jmp    800932 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80090c:	a1 24 50 80 00       	mov    0x805024,%eax
  800911:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800917:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80091a:	89 d0                	mov    %edx,%eax
  80091c:	01 c0                	add    %eax,%eax
  80091e:	01 d0                	add    %edx,%eax
  800920:	c1 e0 03             	shl    $0x3,%eax
  800923:	01 c8                	add    %ecx,%eax
  800925:	8a 40 04             	mov    0x4(%eax),%al
  800928:	3c 01                	cmp    $0x1,%al
  80092a:	75 03                	jne    80092f <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80092c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80092f:	ff 45 e0             	incl   -0x20(%ebp)
  800932:	a1 24 50 80 00       	mov    0x805024,%eax
  800937:	8b 50 74             	mov    0x74(%eax),%edx
  80093a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80093d:	39 c2                	cmp    %eax,%edx
  80093f:	77 cb                	ja     80090c <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800941:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800944:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800947:	74 14                	je     80095d <CheckWSWithoutLastIndex+0x16b>
		panic(
  800949:	83 ec 04             	sub    $0x4,%esp
  80094c:	68 28 3d 80 00       	push   $0x803d28
  800951:	6a 44                	push   $0x44
  800953:	68 c8 3c 80 00       	push   $0x803cc8
  800958:	e8 23 fe ff ff       	call   800780 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80095d:	90                   	nop
  80095e:	c9                   	leave  
  80095f:	c3                   	ret    

00800960 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800960:	55                   	push   %ebp
  800961:	89 e5                	mov    %esp,%ebp
  800963:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800966:	8b 45 0c             	mov    0xc(%ebp),%eax
  800969:	8b 00                	mov    (%eax),%eax
  80096b:	8d 48 01             	lea    0x1(%eax),%ecx
  80096e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800971:	89 0a                	mov    %ecx,(%edx)
  800973:	8b 55 08             	mov    0x8(%ebp),%edx
  800976:	88 d1                	mov    %dl,%cl
  800978:	8b 55 0c             	mov    0xc(%ebp),%edx
  80097b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80097f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800982:	8b 00                	mov    (%eax),%eax
  800984:	3d ff 00 00 00       	cmp    $0xff,%eax
  800989:	75 2c                	jne    8009b7 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80098b:	a0 28 50 80 00       	mov    0x805028,%al
  800990:	0f b6 c0             	movzbl %al,%eax
  800993:	8b 55 0c             	mov    0xc(%ebp),%edx
  800996:	8b 12                	mov    (%edx),%edx
  800998:	89 d1                	mov    %edx,%ecx
  80099a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80099d:	83 c2 08             	add    $0x8,%edx
  8009a0:	83 ec 04             	sub    $0x4,%esp
  8009a3:	50                   	push   %eax
  8009a4:	51                   	push   %ecx
  8009a5:	52                   	push   %edx
  8009a6:	e8 6a 15 00 00       	call   801f15 <sys_cputs>
  8009ab:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ba:	8b 40 04             	mov    0x4(%eax),%eax
  8009bd:	8d 50 01             	lea    0x1(%eax),%edx
  8009c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c3:	89 50 04             	mov    %edx,0x4(%eax)
}
  8009c6:	90                   	nop
  8009c7:	c9                   	leave  
  8009c8:	c3                   	ret    

008009c9 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8009c9:	55                   	push   %ebp
  8009ca:	89 e5                	mov    %esp,%ebp
  8009cc:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009d2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009d9:	00 00 00 
	b.cnt = 0;
  8009dc:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009e3:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8009e6:	ff 75 0c             	pushl  0xc(%ebp)
  8009e9:	ff 75 08             	pushl  0x8(%ebp)
  8009ec:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009f2:	50                   	push   %eax
  8009f3:	68 60 09 80 00       	push   $0x800960
  8009f8:	e8 11 02 00 00       	call   800c0e <vprintfmt>
  8009fd:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800a00:	a0 28 50 80 00       	mov    0x805028,%al
  800a05:	0f b6 c0             	movzbl %al,%eax
  800a08:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800a0e:	83 ec 04             	sub    $0x4,%esp
  800a11:	50                   	push   %eax
  800a12:	52                   	push   %edx
  800a13:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a19:	83 c0 08             	add    $0x8,%eax
  800a1c:	50                   	push   %eax
  800a1d:	e8 f3 14 00 00       	call   801f15 <sys_cputs>
  800a22:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a25:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800a2c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a32:	c9                   	leave  
  800a33:	c3                   	ret    

00800a34 <cprintf>:

int cprintf(const char *fmt, ...) {
  800a34:	55                   	push   %ebp
  800a35:	89 e5                	mov    %esp,%ebp
  800a37:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a3a:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800a41:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a44:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a47:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4a:	83 ec 08             	sub    $0x8,%esp
  800a4d:	ff 75 f4             	pushl  -0xc(%ebp)
  800a50:	50                   	push   %eax
  800a51:	e8 73 ff ff ff       	call   8009c9 <vcprintf>
  800a56:	83 c4 10             	add    $0x10,%esp
  800a59:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a5f:	c9                   	leave  
  800a60:	c3                   	ret    

00800a61 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a61:	55                   	push   %ebp
  800a62:	89 e5                	mov    %esp,%ebp
  800a64:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a67:	e8 57 16 00 00       	call   8020c3 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a6c:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a72:	8b 45 08             	mov    0x8(%ebp),%eax
  800a75:	83 ec 08             	sub    $0x8,%esp
  800a78:	ff 75 f4             	pushl  -0xc(%ebp)
  800a7b:	50                   	push   %eax
  800a7c:	e8 48 ff ff ff       	call   8009c9 <vcprintf>
  800a81:	83 c4 10             	add    $0x10,%esp
  800a84:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a87:	e8 51 16 00 00       	call   8020dd <sys_enable_interrupt>
	return cnt;
  800a8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a8f:	c9                   	leave  
  800a90:	c3                   	ret    

00800a91 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a91:	55                   	push   %ebp
  800a92:	89 e5                	mov    %esp,%ebp
  800a94:	53                   	push   %ebx
  800a95:	83 ec 14             	sub    $0x14,%esp
  800a98:	8b 45 10             	mov    0x10(%ebp),%eax
  800a9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a9e:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800aa4:	8b 45 18             	mov    0x18(%ebp),%eax
  800aa7:	ba 00 00 00 00       	mov    $0x0,%edx
  800aac:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800aaf:	77 55                	ja     800b06 <printnum+0x75>
  800ab1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ab4:	72 05                	jb     800abb <printnum+0x2a>
  800ab6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ab9:	77 4b                	ja     800b06 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800abb:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800abe:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800ac1:	8b 45 18             	mov    0x18(%ebp),%eax
  800ac4:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac9:	52                   	push   %edx
  800aca:	50                   	push   %eax
  800acb:	ff 75 f4             	pushl  -0xc(%ebp)
  800ace:	ff 75 f0             	pushl  -0x10(%ebp)
  800ad1:	e8 4e 2c 00 00       	call   803724 <__udivdi3>
  800ad6:	83 c4 10             	add    $0x10,%esp
  800ad9:	83 ec 04             	sub    $0x4,%esp
  800adc:	ff 75 20             	pushl  0x20(%ebp)
  800adf:	53                   	push   %ebx
  800ae0:	ff 75 18             	pushl  0x18(%ebp)
  800ae3:	52                   	push   %edx
  800ae4:	50                   	push   %eax
  800ae5:	ff 75 0c             	pushl  0xc(%ebp)
  800ae8:	ff 75 08             	pushl  0x8(%ebp)
  800aeb:	e8 a1 ff ff ff       	call   800a91 <printnum>
  800af0:	83 c4 20             	add    $0x20,%esp
  800af3:	eb 1a                	jmp    800b0f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800af5:	83 ec 08             	sub    $0x8,%esp
  800af8:	ff 75 0c             	pushl  0xc(%ebp)
  800afb:	ff 75 20             	pushl  0x20(%ebp)
  800afe:	8b 45 08             	mov    0x8(%ebp),%eax
  800b01:	ff d0                	call   *%eax
  800b03:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b06:	ff 4d 1c             	decl   0x1c(%ebp)
  800b09:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b0d:	7f e6                	jg     800af5 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b0f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b12:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b1d:	53                   	push   %ebx
  800b1e:	51                   	push   %ecx
  800b1f:	52                   	push   %edx
  800b20:	50                   	push   %eax
  800b21:	e8 0e 2d 00 00       	call   803834 <__umoddi3>
  800b26:	83 c4 10             	add    $0x10,%esp
  800b29:	05 94 3f 80 00       	add    $0x803f94,%eax
  800b2e:	8a 00                	mov    (%eax),%al
  800b30:	0f be c0             	movsbl %al,%eax
  800b33:	83 ec 08             	sub    $0x8,%esp
  800b36:	ff 75 0c             	pushl  0xc(%ebp)
  800b39:	50                   	push   %eax
  800b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3d:	ff d0                	call   *%eax
  800b3f:	83 c4 10             	add    $0x10,%esp
}
  800b42:	90                   	nop
  800b43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b46:	c9                   	leave  
  800b47:	c3                   	ret    

00800b48 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b48:	55                   	push   %ebp
  800b49:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b4b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b4f:	7e 1c                	jle    800b6d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b51:	8b 45 08             	mov    0x8(%ebp),%eax
  800b54:	8b 00                	mov    (%eax),%eax
  800b56:	8d 50 08             	lea    0x8(%eax),%edx
  800b59:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5c:	89 10                	mov    %edx,(%eax)
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	8b 00                	mov    (%eax),%eax
  800b63:	83 e8 08             	sub    $0x8,%eax
  800b66:	8b 50 04             	mov    0x4(%eax),%edx
  800b69:	8b 00                	mov    (%eax),%eax
  800b6b:	eb 40                	jmp    800bad <getuint+0x65>
	else if (lflag)
  800b6d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b71:	74 1e                	je     800b91 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b73:	8b 45 08             	mov    0x8(%ebp),%eax
  800b76:	8b 00                	mov    (%eax),%eax
  800b78:	8d 50 04             	lea    0x4(%eax),%edx
  800b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7e:	89 10                	mov    %edx,(%eax)
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	8b 00                	mov    (%eax),%eax
  800b85:	83 e8 04             	sub    $0x4,%eax
  800b88:	8b 00                	mov    (%eax),%eax
  800b8a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b8f:	eb 1c                	jmp    800bad <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b91:	8b 45 08             	mov    0x8(%ebp),%eax
  800b94:	8b 00                	mov    (%eax),%eax
  800b96:	8d 50 04             	lea    0x4(%eax),%edx
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	89 10                	mov    %edx,(%eax)
  800b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba1:	8b 00                	mov    (%eax),%eax
  800ba3:	83 e8 04             	sub    $0x4,%eax
  800ba6:	8b 00                	mov    (%eax),%eax
  800ba8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800bad:	5d                   	pop    %ebp
  800bae:	c3                   	ret    

00800baf <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800baf:	55                   	push   %ebp
  800bb0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bb2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bb6:	7e 1c                	jle    800bd4 <getint+0x25>
		return va_arg(*ap, long long);
  800bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbb:	8b 00                	mov    (%eax),%eax
  800bbd:	8d 50 08             	lea    0x8(%eax),%edx
  800bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc3:	89 10                	mov    %edx,(%eax)
  800bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc8:	8b 00                	mov    (%eax),%eax
  800bca:	83 e8 08             	sub    $0x8,%eax
  800bcd:	8b 50 04             	mov    0x4(%eax),%edx
  800bd0:	8b 00                	mov    (%eax),%eax
  800bd2:	eb 38                	jmp    800c0c <getint+0x5d>
	else if (lflag)
  800bd4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bd8:	74 1a                	je     800bf4 <getint+0x45>
		return va_arg(*ap, long);
  800bda:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdd:	8b 00                	mov    (%eax),%eax
  800bdf:	8d 50 04             	lea    0x4(%eax),%edx
  800be2:	8b 45 08             	mov    0x8(%ebp),%eax
  800be5:	89 10                	mov    %edx,(%eax)
  800be7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bea:	8b 00                	mov    (%eax),%eax
  800bec:	83 e8 04             	sub    $0x4,%eax
  800bef:	8b 00                	mov    (%eax),%eax
  800bf1:	99                   	cltd   
  800bf2:	eb 18                	jmp    800c0c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf7:	8b 00                	mov    (%eax),%eax
  800bf9:	8d 50 04             	lea    0x4(%eax),%edx
  800bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bff:	89 10                	mov    %edx,(%eax)
  800c01:	8b 45 08             	mov    0x8(%ebp),%eax
  800c04:	8b 00                	mov    (%eax),%eax
  800c06:	83 e8 04             	sub    $0x4,%eax
  800c09:	8b 00                	mov    (%eax),%eax
  800c0b:	99                   	cltd   
}
  800c0c:	5d                   	pop    %ebp
  800c0d:	c3                   	ret    

00800c0e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c0e:	55                   	push   %ebp
  800c0f:	89 e5                	mov    %esp,%ebp
  800c11:	56                   	push   %esi
  800c12:	53                   	push   %ebx
  800c13:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c16:	eb 17                	jmp    800c2f <vprintfmt+0x21>
			if (ch == '\0')
  800c18:	85 db                	test   %ebx,%ebx
  800c1a:	0f 84 af 03 00 00    	je     800fcf <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800c20:	83 ec 08             	sub    $0x8,%esp
  800c23:	ff 75 0c             	pushl  0xc(%ebp)
  800c26:	53                   	push   %ebx
  800c27:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2a:	ff d0                	call   *%eax
  800c2c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c32:	8d 50 01             	lea    0x1(%eax),%edx
  800c35:	89 55 10             	mov    %edx,0x10(%ebp)
  800c38:	8a 00                	mov    (%eax),%al
  800c3a:	0f b6 d8             	movzbl %al,%ebx
  800c3d:	83 fb 25             	cmp    $0x25,%ebx
  800c40:	75 d6                	jne    800c18 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c42:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c46:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c4d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c54:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c5b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c62:	8b 45 10             	mov    0x10(%ebp),%eax
  800c65:	8d 50 01             	lea    0x1(%eax),%edx
  800c68:	89 55 10             	mov    %edx,0x10(%ebp)
  800c6b:	8a 00                	mov    (%eax),%al
  800c6d:	0f b6 d8             	movzbl %al,%ebx
  800c70:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c73:	83 f8 55             	cmp    $0x55,%eax
  800c76:	0f 87 2b 03 00 00    	ja     800fa7 <vprintfmt+0x399>
  800c7c:	8b 04 85 b8 3f 80 00 	mov    0x803fb8(,%eax,4),%eax
  800c83:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c85:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c89:	eb d7                	jmp    800c62 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c8b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c8f:	eb d1                	jmp    800c62 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c91:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c98:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c9b:	89 d0                	mov    %edx,%eax
  800c9d:	c1 e0 02             	shl    $0x2,%eax
  800ca0:	01 d0                	add    %edx,%eax
  800ca2:	01 c0                	add    %eax,%eax
  800ca4:	01 d8                	add    %ebx,%eax
  800ca6:	83 e8 30             	sub    $0x30,%eax
  800ca9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800cac:	8b 45 10             	mov    0x10(%ebp),%eax
  800caf:	8a 00                	mov    (%eax),%al
  800cb1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800cb4:	83 fb 2f             	cmp    $0x2f,%ebx
  800cb7:	7e 3e                	jle    800cf7 <vprintfmt+0xe9>
  800cb9:	83 fb 39             	cmp    $0x39,%ebx
  800cbc:	7f 39                	jg     800cf7 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cbe:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800cc1:	eb d5                	jmp    800c98 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800cc3:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc6:	83 c0 04             	add    $0x4,%eax
  800cc9:	89 45 14             	mov    %eax,0x14(%ebp)
  800ccc:	8b 45 14             	mov    0x14(%ebp),%eax
  800ccf:	83 e8 04             	sub    $0x4,%eax
  800cd2:	8b 00                	mov    (%eax),%eax
  800cd4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800cd7:	eb 1f                	jmp    800cf8 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800cd9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cdd:	79 83                	jns    800c62 <vprintfmt+0x54>
				width = 0;
  800cdf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800ce6:	e9 77 ff ff ff       	jmp    800c62 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800ceb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800cf2:	e9 6b ff ff ff       	jmp    800c62 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800cf7:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800cf8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cfc:	0f 89 60 ff ff ff    	jns    800c62 <vprintfmt+0x54>
				width = precision, precision = -1;
  800d02:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d08:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d0f:	e9 4e ff ff ff       	jmp    800c62 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d14:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d17:	e9 46 ff ff ff       	jmp    800c62 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d1f:	83 c0 04             	add    $0x4,%eax
  800d22:	89 45 14             	mov    %eax,0x14(%ebp)
  800d25:	8b 45 14             	mov    0x14(%ebp),%eax
  800d28:	83 e8 04             	sub    $0x4,%eax
  800d2b:	8b 00                	mov    (%eax),%eax
  800d2d:	83 ec 08             	sub    $0x8,%esp
  800d30:	ff 75 0c             	pushl  0xc(%ebp)
  800d33:	50                   	push   %eax
  800d34:	8b 45 08             	mov    0x8(%ebp),%eax
  800d37:	ff d0                	call   *%eax
  800d39:	83 c4 10             	add    $0x10,%esp
			break;
  800d3c:	e9 89 02 00 00       	jmp    800fca <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d41:	8b 45 14             	mov    0x14(%ebp),%eax
  800d44:	83 c0 04             	add    $0x4,%eax
  800d47:	89 45 14             	mov    %eax,0x14(%ebp)
  800d4a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d4d:	83 e8 04             	sub    $0x4,%eax
  800d50:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d52:	85 db                	test   %ebx,%ebx
  800d54:	79 02                	jns    800d58 <vprintfmt+0x14a>
				err = -err;
  800d56:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d58:	83 fb 64             	cmp    $0x64,%ebx
  800d5b:	7f 0b                	jg     800d68 <vprintfmt+0x15a>
  800d5d:	8b 34 9d 00 3e 80 00 	mov    0x803e00(,%ebx,4),%esi
  800d64:	85 f6                	test   %esi,%esi
  800d66:	75 19                	jne    800d81 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d68:	53                   	push   %ebx
  800d69:	68 a5 3f 80 00       	push   $0x803fa5
  800d6e:	ff 75 0c             	pushl  0xc(%ebp)
  800d71:	ff 75 08             	pushl  0x8(%ebp)
  800d74:	e8 5e 02 00 00       	call   800fd7 <printfmt>
  800d79:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d7c:	e9 49 02 00 00       	jmp    800fca <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d81:	56                   	push   %esi
  800d82:	68 ae 3f 80 00       	push   $0x803fae
  800d87:	ff 75 0c             	pushl  0xc(%ebp)
  800d8a:	ff 75 08             	pushl  0x8(%ebp)
  800d8d:	e8 45 02 00 00       	call   800fd7 <printfmt>
  800d92:	83 c4 10             	add    $0x10,%esp
			break;
  800d95:	e9 30 02 00 00       	jmp    800fca <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d9a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d9d:	83 c0 04             	add    $0x4,%eax
  800da0:	89 45 14             	mov    %eax,0x14(%ebp)
  800da3:	8b 45 14             	mov    0x14(%ebp),%eax
  800da6:	83 e8 04             	sub    $0x4,%eax
  800da9:	8b 30                	mov    (%eax),%esi
  800dab:	85 f6                	test   %esi,%esi
  800dad:	75 05                	jne    800db4 <vprintfmt+0x1a6>
				p = "(null)";
  800daf:	be b1 3f 80 00       	mov    $0x803fb1,%esi
			if (width > 0 && padc != '-')
  800db4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800db8:	7e 6d                	jle    800e27 <vprintfmt+0x219>
  800dba:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800dbe:	74 67                	je     800e27 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800dc0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dc3:	83 ec 08             	sub    $0x8,%esp
  800dc6:	50                   	push   %eax
  800dc7:	56                   	push   %esi
  800dc8:	e8 12 05 00 00       	call   8012df <strnlen>
  800dcd:	83 c4 10             	add    $0x10,%esp
  800dd0:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800dd3:	eb 16                	jmp    800deb <vprintfmt+0x1dd>
					putch(padc, putdat);
  800dd5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800dd9:	83 ec 08             	sub    $0x8,%esp
  800ddc:	ff 75 0c             	pushl  0xc(%ebp)
  800ddf:	50                   	push   %eax
  800de0:	8b 45 08             	mov    0x8(%ebp),%eax
  800de3:	ff d0                	call   *%eax
  800de5:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800de8:	ff 4d e4             	decl   -0x1c(%ebp)
  800deb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800def:	7f e4                	jg     800dd5 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800df1:	eb 34                	jmp    800e27 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800df3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800df7:	74 1c                	je     800e15 <vprintfmt+0x207>
  800df9:	83 fb 1f             	cmp    $0x1f,%ebx
  800dfc:	7e 05                	jle    800e03 <vprintfmt+0x1f5>
  800dfe:	83 fb 7e             	cmp    $0x7e,%ebx
  800e01:	7e 12                	jle    800e15 <vprintfmt+0x207>
					putch('?', putdat);
  800e03:	83 ec 08             	sub    $0x8,%esp
  800e06:	ff 75 0c             	pushl  0xc(%ebp)
  800e09:	6a 3f                	push   $0x3f
  800e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0e:	ff d0                	call   *%eax
  800e10:	83 c4 10             	add    $0x10,%esp
  800e13:	eb 0f                	jmp    800e24 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e15:	83 ec 08             	sub    $0x8,%esp
  800e18:	ff 75 0c             	pushl  0xc(%ebp)
  800e1b:	53                   	push   %ebx
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	ff d0                	call   *%eax
  800e21:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e24:	ff 4d e4             	decl   -0x1c(%ebp)
  800e27:	89 f0                	mov    %esi,%eax
  800e29:	8d 70 01             	lea    0x1(%eax),%esi
  800e2c:	8a 00                	mov    (%eax),%al
  800e2e:	0f be d8             	movsbl %al,%ebx
  800e31:	85 db                	test   %ebx,%ebx
  800e33:	74 24                	je     800e59 <vprintfmt+0x24b>
  800e35:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e39:	78 b8                	js     800df3 <vprintfmt+0x1e5>
  800e3b:	ff 4d e0             	decl   -0x20(%ebp)
  800e3e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e42:	79 af                	jns    800df3 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e44:	eb 13                	jmp    800e59 <vprintfmt+0x24b>
				putch(' ', putdat);
  800e46:	83 ec 08             	sub    $0x8,%esp
  800e49:	ff 75 0c             	pushl  0xc(%ebp)
  800e4c:	6a 20                	push   $0x20
  800e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e51:	ff d0                	call   *%eax
  800e53:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e56:	ff 4d e4             	decl   -0x1c(%ebp)
  800e59:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e5d:	7f e7                	jg     800e46 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e5f:	e9 66 01 00 00       	jmp    800fca <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e64:	83 ec 08             	sub    $0x8,%esp
  800e67:	ff 75 e8             	pushl  -0x18(%ebp)
  800e6a:	8d 45 14             	lea    0x14(%ebp),%eax
  800e6d:	50                   	push   %eax
  800e6e:	e8 3c fd ff ff       	call   800baf <getint>
  800e73:	83 c4 10             	add    $0x10,%esp
  800e76:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e79:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e82:	85 d2                	test   %edx,%edx
  800e84:	79 23                	jns    800ea9 <vprintfmt+0x29b>
				putch('-', putdat);
  800e86:	83 ec 08             	sub    $0x8,%esp
  800e89:	ff 75 0c             	pushl  0xc(%ebp)
  800e8c:	6a 2d                	push   $0x2d
  800e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e91:	ff d0                	call   *%eax
  800e93:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e99:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e9c:	f7 d8                	neg    %eax
  800e9e:	83 d2 00             	adc    $0x0,%edx
  800ea1:	f7 da                	neg    %edx
  800ea3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ea6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ea9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800eb0:	e9 bc 00 00 00       	jmp    800f71 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800eb5:	83 ec 08             	sub    $0x8,%esp
  800eb8:	ff 75 e8             	pushl  -0x18(%ebp)
  800ebb:	8d 45 14             	lea    0x14(%ebp),%eax
  800ebe:	50                   	push   %eax
  800ebf:	e8 84 fc ff ff       	call   800b48 <getuint>
  800ec4:	83 c4 10             	add    $0x10,%esp
  800ec7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eca:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ecd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ed4:	e9 98 00 00 00       	jmp    800f71 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ed9:	83 ec 08             	sub    $0x8,%esp
  800edc:	ff 75 0c             	pushl  0xc(%ebp)
  800edf:	6a 58                	push   $0x58
  800ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee4:	ff d0                	call   *%eax
  800ee6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ee9:	83 ec 08             	sub    $0x8,%esp
  800eec:	ff 75 0c             	pushl  0xc(%ebp)
  800eef:	6a 58                	push   $0x58
  800ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef4:	ff d0                	call   *%eax
  800ef6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ef9:	83 ec 08             	sub    $0x8,%esp
  800efc:	ff 75 0c             	pushl  0xc(%ebp)
  800eff:	6a 58                	push   $0x58
  800f01:	8b 45 08             	mov    0x8(%ebp),%eax
  800f04:	ff d0                	call   *%eax
  800f06:	83 c4 10             	add    $0x10,%esp
			break;
  800f09:	e9 bc 00 00 00       	jmp    800fca <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800f0e:	83 ec 08             	sub    $0x8,%esp
  800f11:	ff 75 0c             	pushl  0xc(%ebp)
  800f14:	6a 30                	push   $0x30
  800f16:	8b 45 08             	mov    0x8(%ebp),%eax
  800f19:	ff d0                	call   *%eax
  800f1b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f1e:	83 ec 08             	sub    $0x8,%esp
  800f21:	ff 75 0c             	pushl  0xc(%ebp)
  800f24:	6a 78                	push   $0x78
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	ff d0                	call   *%eax
  800f2b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f2e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f31:	83 c0 04             	add    $0x4,%eax
  800f34:	89 45 14             	mov    %eax,0x14(%ebp)
  800f37:	8b 45 14             	mov    0x14(%ebp),%eax
  800f3a:	83 e8 04             	sub    $0x4,%eax
  800f3d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f42:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f49:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f50:	eb 1f                	jmp    800f71 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f52:	83 ec 08             	sub    $0x8,%esp
  800f55:	ff 75 e8             	pushl  -0x18(%ebp)
  800f58:	8d 45 14             	lea    0x14(%ebp),%eax
  800f5b:	50                   	push   %eax
  800f5c:	e8 e7 fb ff ff       	call   800b48 <getuint>
  800f61:	83 c4 10             	add    $0x10,%esp
  800f64:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f67:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f6a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f71:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f78:	83 ec 04             	sub    $0x4,%esp
  800f7b:	52                   	push   %edx
  800f7c:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f7f:	50                   	push   %eax
  800f80:	ff 75 f4             	pushl  -0xc(%ebp)
  800f83:	ff 75 f0             	pushl  -0x10(%ebp)
  800f86:	ff 75 0c             	pushl  0xc(%ebp)
  800f89:	ff 75 08             	pushl  0x8(%ebp)
  800f8c:	e8 00 fb ff ff       	call   800a91 <printnum>
  800f91:	83 c4 20             	add    $0x20,%esp
			break;
  800f94:	eb 34                	jmp    800fca <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f96:	83 ec 08             	sub    $0x8,%esp
  800f99:	ff 75 0c             	pushl  0xc(%ebp)
  800f9c:	53                   	push   %ebx
  800f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa0:	ff d0                	call   *%eax
  800fa2:	83 c4 10             	add    $0x10,%esp
			break;
  800fa5:	eb 23                	jmp    800fca <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fa7:	83 ec 08             	sub    $0x8,%esp
  800faa:	ff 75 0c             	pushl  0xc(%ebp)
  800fad:	6a 25                	push   $0x25
  800faf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb2:	ff d0                	call   *%eax
  800fb4:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fb7:	ff 4d 10             	decl   0x10(%ebp)
  800fba:	eb 03                	jmp    800fbf <vprintfmt+0x3b1>
  800fbc:	ff 4d 10             	decl   0x10(%ebp)
  800fbf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc2:	48                   	dec    %eax
  800fc3:	8a 00                	mov    (%eax),%al
  800fc5:	3c 25                	cmp    $0x25,%al
  800fc7:	75 f3                	jne    800fbc <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800fc9:	90                   	nop
		}
	}
  800fca:	e9 47 fc ff ff       	jmp    800c16 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800fcf:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800fd0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fd3:	5b                   	pop    %ebx
  800fd4:	5e                   	pop    %esi
  800fd5:	5d                   	pop    %ebp
  800fd6:	c3                   	ret    

00800fd7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800fd7:	55                   	push   %ebp
  800fd8:	89 e5                	mov    %esp,%ebp
  800fda:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800fdd:	8d 45 10             	lea    0x10(%ebp),%eax
  800fe0:	83 c0 04             	add    $0x4,%eax
  800fe3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800fe6:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe9:	ff 75 f4             	pushl  -0xc(%ebp)
  800fec:	50                   	push   %eax
  800fed:	ff 75 0c             	pushl  0xc(%ebp)
  800ff0:	ff 75 08             	pushl  0x8(%ebp)
  800ff3:	e8 16 fc ff ff       	call   800c0e <vprintfmt>
  800ff8:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800ffb:	90                   	nop
  800ffc:	c9                   	leave  
  800ffd:	c3                   	ret    

00800ffe <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ffe:	55                   	push   %ebp
  800fff:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801001:	8b 45 0c             	mov    0xc(%ebp),%eax
  801004:	8b 40 08             	mov    0x8(%eax),%eax
  801007:	8d 50 01             	lea    0x1(%eax),%edx
  80100a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100d:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801010:	8b 45 0c             	mov    0xc(%ebp),%eax
  801013:	8b 10                	mov    (%eax),%edx
  801015:	8b 45 0c             	mov    0xc(%ebp),%eax
  801018:	8b 40 04             	mov    0x4(%eax),%eax
  80101b:	39 c2                	cmp    %eax,%edx
  80101d:	73 12                	jae    801031 <sprintputch+0x33>
		*b->buf++ = ch;
  80101f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801022:	8b 00                	mov    (%eax),%eax
  801024:	8d 48 01             	lea    0x1(%eax),%ecx
  801027:	8b 55 0c             	mov    0xc(%ebp),%edx
  80102a:	89 0a                	mov    %ecx,(%edx)
  80102c:	8b 55 08             	mov    0x8(%ebp),%edx
  80102f:	88 10                	mov    %dl,(%eax)
}
  801031:	90                   	nop
  801032:	5d                   	pop    %ebp
  801033:	c3                   	ret    

00801034 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801034:	55                   	push   %ebp
  801035:	89 e5                	mov    %esp,%ebp
  801037:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80103a:	8b 45 08             	mov    0x8(%ebp),%eax
  80103d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801040:	8b 45 0c             	mov    0xc(%ebp),%eax
  801043:	8d 50 ff             	lea    -0x1(%eax),%edx
  801046:	8b 45 08             	mov    0x8(%ebp),%eax
  801049:	01 d0                	add    %edx,%eax
  80104b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80104e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801055:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801059:	74 06                	je     801061 <vsnprintf+0x2d>
  80105b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80105f:	7f 07                	jg     801068 <vsnprintf+0x34>
		return -E_INVAL;
  801061:	b8 03 00 00 00       	mov    $0x3,%eax
  801066:	eb 20                	jmp    801088 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801068:	ff 75 14             	pushl  0x14(%ebp)
  80106b:	ff 75 10             	pushl  0x10(%ebp)
  80106e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801071:	50                   	push   %eax
  801072:	68 fe 0f 80 00       	push   $0x800ffe
  801077:	e8 92 fb ff ff       	call   800c0e <vprintfmt>
  80107c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80107f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801082:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801085:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801088:	c9                   	leave  
  801089:	c3                   	ret    

0080108a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80108a:	55                   	push   %ebp
  80108b:	89 e5                	mov    %esp,%ebp
  80108d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801090:	8d 45 10             	lea    0x10(%ebp),%eax
  801093:	83 c0 04             	add    $0x4,%eax
  801096:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801099:	8b 45 10             	mov    0x10(%ebp),%eax
  80109c:	ff 75 f4             	pushl  -0xc(%ebp)
  80109f:	50                   	push   %eax
  8010a0:	ff 75 0c             	pushl  0xc(%ebp)
  8010a3:	ff 75 08             	pushl  0x8(%ebp)
  8010a6:	e8 89 ff ff ff       	call   801034 <vsnprintf>
  8010ab:	83 c4 10             	add    $0x10,%esp
  8010ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8010b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010b4:	c9                   	leave  
  8010b5:	c3                   	ret    

008010b6 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8010b6:	55                   	push   %ebp
  8010b7:	89 e5                	mov    %esp,%ebp
  8010b9:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  8010bc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010c0:	74 13                	je     8010d5 <readline+0x1f>
		cprintf("%s", prompt);
  8010c2:	83 ec 08             	sub    $0x8,%esp
  8010c5:	ff 75 08             	pushl  0x8(%ebp)
  8010c8:	68 10 41 80 00       	push   $0x804110
  8010cd:	e8 62 f9 ff ff       	call   800a34 <cprintf>
  8010d2:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8010d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8010dc:	83 ec 0c             	sub    $0xc,%esp
  8010df:	6a 00                	push   $0x0
  8010e1:	e8 54 f5 ff ff       	call   80063a <iscons>
  8010e6:	83 c4 10             	add    $0x10,%esp
  8010e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8010ec:	e8 fb f4 ff ff       	call   8005ec <getchar>
  8010f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8010f4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8010f8:	79 22                	jns    80111c <readline+0x66>
			if (c != -E_EOF)
  8010fa:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8010fe:	0f 84 ad 00 00 00    	je     8011b1 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801104:	83 ec 08             	sub    $0x8,%esp
  801107:	ff 75 ec             	pushl  -0x14(%ebp)
  80110a:	68 13 41 80 00       	push   $0x804113
  80110f:	e8 20 f9 ff ff       	call   800a34 <cprintf>
  801114:	83 c4 10             	add    $0x10,%esp
			return;
  801117:	e9 95 00 00 00       	jmp    8011b1 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80111c:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801120:	7e 34                	jle    801156 <readline+0xa0>
  801122:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801129:	7f 2b                	jg     801156 <readline+0xa0>
			if (echoing)
  80112b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80112f:	74 0e                	je     80113f <readline+0x89>
				cputchar(c);
  801131:	83 ec 0c             	sub    $0xc,%esp
  801134:	ff 75 ec             	pushl  -0x14(%ebp)
  801137:	e8 68 f4 ff ff       	call   8005a4 <cputchar>
  80113c:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80113f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801142:	8d 50 01             	lea    0x1(%eax),%edx
  801145:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801148:	89 c2                	mov    %eax,%edx
  80114a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114d:	01 d0                	add    %edx,%eax
  80114f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801152:	88 10                	mov    %dl,(%eax)
  801154:	eb 56                	jmp    8011ac <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801156:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80115a:	75 1f                	jne    80117b <readline+0xc5>
  80115c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801160:	7e 19                	jle    80117b <readline+0xc5>
			if (echoing)
  801162:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801166:	74 0e                	je     801176 <readline+0xc0>
				cputchar(c);
  801168:	83 ec 0c             	sub    $0xc,%esp
  80116b:	ff 75 ec             	pushl  -0x14(%ebp)
  80116e:	e8 31 f4 ff ff       	call   8005a4 <cputchar>
  801173:	83 c4 10             	add    $0x10,%esp

			i--;
  801176:	ff 4d f4             	decl   -0xc(%ebp)
  801179:	eb 31                	jmp    8011ac <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  80117b:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80117f:	74 0a                	je     80118b <readline+0xd5>
  801181:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801185:	0f 85 61 ff ff ff    	jne    8010ec <readline+0x36>
			if (echoing)
  80118b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80118f:	74 0e                	je     80119f <readline+0xe9>
				cputchar(c);
  801191:	83 ec 0c             	sub    $0xc,%esp
  801194:	ff 75 ec             	pushl  -0x14(%ebp)
  801197:	e8 08 f4 ff ff       	call   8005a4 <cputchar>
  80119c:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  80119f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a5:	01 d0                	add    %edx,%eax
  8011a7:	c6 00 00             	movb   $0x0,(%eax)
			return;
  8011aa:	eb 06                	jmp    8011b2 <readline+0xfc>
		}
	}
  8011ac:	e9 3b ff ff ff       	jmp    8010ec <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  8011b1:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  8011b2:	c9                   	leave  
  8011b3:	c3                   	ret    

008011b4 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8011b4:	55                   	push   %ebp
  8011b5:	89 e5                	mov    %esp,%ebp
  8011b7:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8011ba:	e8 04 0f 00 00       	call   8020c3 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  8011bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011c3:	74 13                	je     8011d8 <atomic_readline+0x24>
		cprintf("%s", prompt);
  8011c5:	83 ec 08             	sub    $0x8,%esp
  8011c8:	ff 75 08             	pushl  0x8(%ebp)
  8011cb:	68 10 41 80 00       	push   $0x804110
  8011d0:	e8 5f f8 ff ff       	call   800a34 <cprintf>
  8011d5:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8011d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8011df:	83 ec 0c             	sub    $0xc,%esp
  8011e2:	6a 00                	push   $0x0
  8011e4:	e8 51 f4 ff ff       	call   80063a <iscons>
  8011e9:	83 c4 10             	add    $0x10,%esp
  8011ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8011ef:	e8 f8 f3 ff ff       	call   8005ec <getchar>
  8011f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8011f7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8011fb:	79 23                	jns    801220 <atomic_readline+0x6c>
			if (c != -E_EOF)
  8011fd:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801201:	74 13                	je     801216 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  801203:	83 ec 08             	sub    $0x8,%esp
  801206:	ff 75 ec             	pushl  -0x14(%ebp)
  801209:	68 13 41 80 00       	push   $0x804113
  80120e:	e8 21 f8 ff ff       	call   800a34 <cprintf>
  801213:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801216:	e8 c2 0e 00 00       	call   8020dd <sys_enable_interrupt>
			return;
  80121b:	e9 9a 00 00 00       	jmp    8012ba <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801220:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801224:	7e 34                	jle    80125a <atomic_readline+0xa6>
  801226:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80122d:	7f 2b                	jg     80125a <atomic_readline+0xa6>
			if (echoing)
  80122f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801233:	74 0e                	je     801243 <atomic_readline+0x8f>
				cputchar(c);
  801235:	83 ec 0c             	sub    $0xc,%esp
  801238:	ff 75 ec             	pushl  -0x14(%ebp)
  80123b:	e8 64 f3 ff ff       	call   8005a4 <cputchar>
  801240:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801243:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801246:	8d 50 01             	lea    0x1(%eax),%edx
  801249:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80124c:	89 c2                	mov    %eax,%edx
  80124e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801251:	01 d0                	add    %edx,%eax
  801253:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801256:	88 10                	mov    %dl,(%eax)
  801258:	eb 5b                	jmp    8012b5 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  80125a:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80125e:	75 1f                	jne    80127f <atomic_readline+0xcb>
  801260:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801264:	7e 19                	jle    80127f <atomic_readline+0xcb>
			if (echoing)
  801266:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80126a:	74 0e                	je     80127a <atomic_readline+0xc6>
				cputchar(c);
  80126c:	83 ec 0c             	sub    $0xc,%esp
  80126f:	ff 75 ec             	pushl  -0x14(%ebp)
  801272:	e8 2d f3 ff ff       	call   8005a4 <cputchar>
  801277:	83 c4 10             	add    $0x10,%esp
			i--;
  80127a:	ff 4d f4             	decl   -0xc(%ebp)
  80127d:	eb 36                	jmp    8012b5 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  80127f:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801283:	74 0a                	je     80128f <atomic_readline+0xdb>
  801285:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801289:	0f 85 60 ff ff ff    	jne    8011ef <atomic_readline+0x3b>
			if (echoing)
  80128f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801293:	74 0e                	je     8012a3 <atomic_readline+0xef>
				cputchar(c);
  801295:	83 ec 0c             	sub    $0xc,%esp
  801298:	ff 75 ec             	pushl  -0x14(%ebp)
  80129b:	e8 04 f3 ff ff       	call   8005a4 <cputchar>
  8012a0:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  8012a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a9:	01 d0                	add    %edx,%eax
  8012ab:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  8012ae:	e8 2a 0e 00 00       	call   8020dd <sys_enable_interrupt>
			return;
  8012b3:	eb 05                	jmp    8012ba <atomic_readline+0x106>
		}
	}
  8012b5:	e9 35 ff ff ff       	jmp    8011ef <atomic_readline+0x3b>
}
  8012ba:	c9                   	leave  
  8012bb:	c3                   	ret    

008012bc <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8012bc:	55                   	push   %ebp
  8012bd:	89 e5                	mov    %esp,%ebp
  8012bf:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8012c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012c9:	eb 06                	jmp    8012d1 <strlen+0x15>
		n++;
  8012cb:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012ce:	ff 45 08             	incl   0x8(%ebp)
  8012d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d4:	8a 00                	mov    (%eax),%al
  8012d6:	84 c0                	test   %al,%al
  8012d8:	75 f1                	jne    8012cb <strlen+0xf>
		n++;
	return n;
  8012da:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012dd:	c9                   	leave  
  8012de:	c3                   	ret    

008012df <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8012df:	55                   	push   %ebp
  8012e0:	89 e5                	mov    %esp,%ebp
  8012e2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012ec:	eb 09                	jmp    8012f7 <strnlen+0x18>
		n++;
  8012ee:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012f1:	ff 45 08             	incl   0x8(%ebp)
  8012f4:	ff 4d 0c             	decl   0xc(%ebp)
  8012f7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012fb:	74 09                	je     801306 <strnlen+0x27>
  8012fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801300:	8a 00                	mov    (%eax),%al
  801302:	84 c0                	test   %al,%al
  801304:	75 e8                	jne    8012ee <strnlen+0xf>
		n++;
	return n;
  801306:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801309:	c9                   	leave  
  80130a:	c3                   	ret    

0080130b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80130b:	55                   	push   %ebp
  80130c:	89 e5                	mov    %esp,%ebp
  80130e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801311:	8b 45 08             	mov    0x8(%ebp),%eax
  801314:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801317:	90                   	nop
  801318:	8b 45 08             	mov    0x8(%ebp),%eax
  80131b:	8d 50 01             	lea    0x1(%eax),%edx
  80131e:	89 55 08             	mov    %edx,0x8(%ebp)
  801321:	8b 55 0c             	mov    0xc(%ebp),%edx
  801324:	8d 4a 01             	lea    0x1(%edx),%ecx
  801327:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80132a:	8a 12                	mov    (%edx),%dl
  80132c:	88 10                	mov    %dl,(%eax)
  80132e:	8a 00                	mov    (%eax),%al
  801330:	84 c0                	test   %al,%al
  801332:	75 e4                	jne    801318 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801334:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801337:	c9                   	leave  
  801338:	c3                   	ret    

00801339 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801339:	55                   	push   %ebp
  80133a:	89 e5                	mov    %esp,%ebp
  80133c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80133f:	8b 45 08             	mov    0x8(%ebp),%eax
  801342:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801345:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80134c:	eb 1f                	jmp    80136d <strncpy+0x34>
		*dst++ = *src;
  80134e:	8b 45 08             	mov    0x8(%ebp),%eax
  801351:	8d 50 01             	lea    0x1(%eax),%edx
  801354:	89 55 08             	mov    %edx,0x8(%ebp)
  801357:	8b 55 0c             	mov    0xc(%ebp),%edx
  80135a:	8a 12                	mov    (%edx),%dl
  80135c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80135e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801361:	8a 00                	mov    (%eax),%al
  801363:	84 c0                	test   %al,%al
  801365:	74 03                	je     80136a <strncpy+0x31>
			src++;
  801367:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80136a:	ff 45 fc             	incl   -0x4(%ebp)
  80136d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801370:	3b 45 10             	cmp    0x10(%ebp),%eax
  801373:	72 d9                	jb     80134e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801375:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801378:	c9                   	leave  
  801379:	c3                   	ret    

0080137a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80137a:	55                   	push   %ebp
  80137b:	89 e5                	mov    %esp,%ebp
  80137d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801380:	8b 45 08             	mov    0x8(%ebp),%eax
  801383:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801386:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80138a:	74 30                	je     8013bc <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80138c:	eb 16                	jmp    8013a4 <strlcpy+0x2a>
			*dst++ = *src++;
  80138e:	8b 45 08             	mov    0x8(%ebp),%eax
  801391:	8d 50 01             	lea    0x1(%eax),%edx
  801394:	89 55 08             	mov    %edx,0x8(%ebp)
  801397:	8b 55 0c             	mov    0xc(%ebp),%edx
  80139a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80139d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013a0:	8a 12                	mov    (%edx),%dl
  8013a2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013a4:	ff 4d 10             	decl   0x10(%ebp)
  8013a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013ab:	74 09                	je     8013b6 <strlcpy+0x3c>
  8013ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b0:	8a 00                	mov    (%eax),%al
  8013b2:	84 c0                	test   %al,%al
  8013b4:	75 d8                	jne    80138e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8013b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8013bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8013bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013c2:	29 c2                	sub    %eax,%edx
  8013c4:	89 d0                	mov    %edx,%eax
}
  8013c6:	c9                   	leave  
  8013c7:	c3                   	ret    

008013c8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013c8:	55                   	push   %ebp
  8013c9:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8013cb:	eb 06                	jmp    8013d3 <strcmp+0xb>
		p++, q++;
  8013cd:	ff 45 08             	incl   0x8(%ebp)
  8013d0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d6:	8a 00                	mov    (%eax),%al
  8013d8:	84 c0                	test   %al,%al
  8013da:	74 0e                	je     8013ea <strcmp+0x22>
  8013dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013df:	8a 10                	mov    (%eax),%dl
  8013e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e4:	8a 00                	mov    (%eax),%al
  8013e6:	38 c2                	cmp    %al,%dl
  8013e8:	74 e3                	je     8013cd <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ed:	8a 00                	mov    (%eax),%al
  8013ef:	0f b6 d0             	movzbl %al,%edx
  8013f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f5:	8a 00                	mov    (%eax),%al
  8013f7:	0f b6 c0             	movzbl %al,%eax
  8013fa:	29 c2                	sub    %eax,%edx
  8013fc:	89 d0                	mov    %edx,%eax
}
  8013fe:	5d                   	pop    %ebp
  8013ff:	c3                   	ret    

00801400 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801400:	55                   	push   %ebp
  801401:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801403:	eb 09                	jmp    80140e <strncmp+0xe>
		n--, p++, q++;
  801405:	ff 4d 10             	decl   0x10(%ebp)
  801408:	ff 45 08             	incl   0x8(%ebp)
  80140b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80140e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801412:	74 17                	je     80142b <strncmp+0x2b>
  801414:	8b 45 08             	mov    0x8(%ebp),%eax
  801417:	8a 00                	mov    (%eax),%al
  801419:	84 c0                	test   %al,%al
  80141b:	74 0e                	je     80142b <strncmp+0x2b>
  80141d:	8b 45 08             	mov    0x8(%ebp),%eax
  801420:	8a 10                	mov    (%eax),%dl
  801422:	8b 45 0c             	mov    0xc(%ebp),%eax
  801425:	8a 00                	mov    (%eax),%al
  801427:	38 c2                	cmp    %al,%dl
  801429:	74 da                	je     801405 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80142b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80142f:	75 07                	jne    801438 <strncmp+0x38>
		return 0;
  801431:	b8 00 00 00 00       	mov    $0x0,%eax
  801436:	eb 14                	jmp    80144c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801438:	8b 45 08             	mov    0x8(%ebp),%eax
  80143b:	8a 00                	mov    (%eax),%al
  80143d:	0f b6 d0             	movzbl %al,%edx
  801440:	8b 45 0c             	mov    0xc(%ebp),%eax
  801443:	8a 00                	mov    (%eax),%al
  801445:	0f b6 c0             	movzbl %al,%eax
  801448:	29 c2                	sub    %eax,%edx
  80144a:	89 d0                	mov    %edx,%eax
}
  80144c:	5d                   	pop    %ebp
  80144d:	c3                   	ret    

0080144e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80144e:	55                   	push   %ebp
  80144f:	89 e5                	mov    %esp,%ebp
  801451:	83 ec 04             	sub    $0x4,%esp
  801454:	8b 45 0c             	mov    0xc(%ebp),%eax
  801457:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80145a:	eb 12                	jmp    80146e <strchr+0x20>
		if (*s == c)
  80145c:	8b 45 08             	mov    0x8(%ebp),%eax
  80145f:	8a 00                	mov    (%eax),%al
  801461:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801464:	75 05                	jne    80146b <strchr+0x1d>
			return (char *) s;
  801466:	8b 45 08             	mov    0x8(%ebp),%eax
  801469:	eb 11                	jmp    80147c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80146b:	ff 45 08             	incl   0x8(%ebp)
  80146e:	8b 45 08             	mov    0x8(%ebp),%eax
  801471:	8a 00                	mov    (%eax),%al
  801473:	84 c0                	test   %al,%al
  801475:	75 e5                	jne    80145c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801477:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80147c:	c9                   	leave  
  80147d:	c3                   	ret    

0080147e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80147e:	55                   	push   %ebp
  80147f:	89 e5                	mov    %esp,%ebp
  801481:	83 ec 04             	sub    $0x4,%esp
  801484:	8b 45 0c             	mov    0xc(%ebp),%eax
  801487:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80148a:	eb 0d                	jmp    801499 <strfind+0x1b>
		if (*s == c)
  80148c:	8b 45 08             	mov    0x8(%ebp),%eax
  80148f:	8a 00                	mov    (%eax),%al
  801491:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801494:	74 0e                	je     8014a4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801496:	ff 45 08             	incl   0x8(%ebp)
  801499:	8b 45 08             	mov    0x8(%ebp),%eax
  80149c:	8a 00                	mov    (%eax),%al
  80149e:	84 c0                	test   %al,%al
  8014a0:	75 ea                	jne    80148c <strfind+0xe>
  8014a2:	eb 01                	jmp    8014a5 <strfind+0x27>
		if (*s == c)
			break;
  8014a4:	90                   	nop
	return (char *) s;
  8014a5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014a8:	c9                   	leave  
  8014a9:	c3                   	ret    

008014aa <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8014aa:	55                   	push   %ebp
  8014ab:	89 e5                	mov    %esp,%ebp
  8014ad:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8014b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8014b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8014bc:	eb 0e                	jmp    8014cc <memset+0x22>
		*p++ = c;
  8014be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014c1:	8d 50 01             	lea    0x1(%eax),%edx
  8014c4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ca:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8014cc:	ff 4d f8             	decl   -0x8(%ebp)
  8014cf:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8014d3:	79 e9                	jns    8014be <memset+0x14>
		*p++ = c;

	return v;
  8014d5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014d8:	c9                   	leave  
  8014d9:	c3                   	ret    

008014da <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8014da:	55                   	push   %ebp
  8014db:	89 e5                	mov    %esp,%ebp
  8014dd:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8014ec:	eb 16                	jmp    801504 <memcpy+0x2a>
		*d++ = *s++;
  8014ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014f1:	8d 50 01             	lea    0x1(%eax),%edx
  8014f4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014f7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014fa:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014fd:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801500:	8a 12                	mov    (%edx),%dl
  801502:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801504:	8b 45 10             	mov    0x10(%ebp),%eax
  801507:	8d 50 ff             	lea    -0x1(%eax),%edx
  80150a:	89 55 10             	mov    %edx,0x10(%ebp)
  80150d:	85 c0                	test   %eax,%eax
  80150f:	75 dd                	jne    8014ee <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801511:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801514:	c9                   	leave  
  801515:	c3                   	ret    

00801516 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801516:	55                   	push   %ebp
  801517:	89 e5                	mov    %esp,%ebp
  801519:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80151c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801522:	8b 45 08             	mov    0x8(%ebp),%eax
  801525:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801528:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80152b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80152e:	73 50                	jae    801580 <memmove+0x6a>
  801530:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801533:	8b 45 10             	mov    0x10(%ebp),%eax
  801536:	01 d0                	add    %edx,%eax
  801538:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80153b:	76 43                	jbe    801580 <memmove+0x6a>
		s += n;
  80153d:	8b 45 10             	mov    0x10(%ebp),%eax
  801540:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801543:	8b 45 10             	mov    0x10(%ebp),%eax
  801546:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801549:	eb 10                	jmp    80155b <memmove+0x45>
			*--d = *--s;
  80154b:	ff 4d f8             	decl   -0x8(%ebp)
  80154e:	ff 4d fc             	decl   -0x4(%ebp)
  801551:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801554:	8a 10                	mov    (%eax),%dl
  801556:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801559:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80155b:	8b 45 10             	mov    0x10(%ebp),%eax
  80155e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801561:	89 55 10             	mov    %edx,0x10(%ebp)
  801564:	85 c0                	test   %eax,%eax
  801566:	75 e3                	jne    80154b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801568:	eb 23                	jmp    80158d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80156a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80156d:	8d 50 01             	lea    0x1(%eax),%edx
  801570:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801573:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801576:	8d 4a 01             	lea    0x1(%edx),%ecx
  801579:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80157c:	8a 12                	mov    (%edx),%dl
  80157e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801580:	8b 45 10             	mov    0x10(%ebp),%eax
  801583:	8d 50 ff             	lea    -0x1(%eax),%edx
  801586:	89 55 10             	mov    %edx,0x10(%ebp)
  801589:	85 c0                	test   %eax,%eax
  80158b:	75 dd                	jne    80156a <memmove+0x54>
			*d++ = *s++;

	return dst;
  80158d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801590:	c9                   	leave  
  801591:	c3                   	ret    

00801592 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801592:	55                   	push   %ebp
  801593:	89 e5                	mov    %esp,%ebp
  801595:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801598:	8b 45 08             	mov    0x8(%ebp),%eax
  80159b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80159e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8015a4:	eb 2a                	jmp    8015d0 <memcmp+0x3e>
		if (*s1 != *s2)
  8015a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015a9:	8a 10                	mov    (%eax),%dl
  8015ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015ae:	8a 00                	mov    (%eax),%al
  8015b0:	38 c2                	cmp    %al,%dl
  8015b2:	74 16                	je     8015ca <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8015b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015b7:	8a 00                	mov    (%eax),%al
  8015b9:	0f b6 d0             	movzbl %al,%edx
  8015bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015bf:	8a 00                	mov    (%eax),%al
  8015c1:	0f b6 c0             	movzbl %al,%eax
  8015c4:	29 c2                	sub    %eax,%edx
  8015c6:	89 d0                	mov    %edx,%eax
  8015c8:	eb 18                	jmp    8015e2 <memcmp+0x50>
		s1++, s2++;
  8015ca:	ff 45 fc             	incl   -0x4(%ebp)
  8015cd:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8015d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015d6:	89 55 10             	mov    %edx,0x10(%ebp)
  8015d9:	85 c0                	test   %eax,%eax
  8015db:	75 c9                	jne    8015a6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015e2:	c9                   	leave  
  8015e3:	c3                   	ret    

008015e4 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8015e4:	55                   	push   %ebp
  8015e5:	89 e5                	mov    %esp,%ebp
  8015e7:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8015ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8015ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f0:	01 d0                	add    %edx,%eax
  8015f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8015f5:	eb 15                	jmp    80160c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fa:	8a 00                	mov    (%eax),%al
  8015fc:	0f b6 d0             	movzbl %al,%edx
  8015ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801602:	0f b6 c0             	movzbl %al,%eax
  801605:	39 c2                	cmp    %eax,%edx
  801607:	74 0d                	je     801616 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801609:	ff 45 08             	incl   0x8(%ebp)
  80160c:	8b 45 08             	mov    0x8(%ebp),%eax
  80160f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801612:	72 e3                	jb     8015f7 <memfind+0x13>
  801614:	eb 01                	jmp    801617 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801616:	90                   	nop
	return (void *) s;
  801617:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80161a:	c9                   	leave  
  80161b:	c3                   	ret    

0080161c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80161c:	55                   	push   %ebp
  80161d:	89 e5                	mov    %esp,%ebp
  80161f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801622:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801629:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801630:	eb 03                	jmp    801635 <strtol+0x19>
		s++;
  801632:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801635:	8b 45 08             	mov    0x8(%ebp),%eax
  801638:	8a 00                	mov    (%eax),%al
  80163a:	3c 20                	cmp    $0x20,%al
  80163c:	74 f4                	je     801632 <strtol+0x16>
  80163e:	8b 45 08             	mov    0x8(%ebp),%eax
  801641:	8a 00                	mov    (%eax),%al
  801643:	3c 09                	cmp    $0x9,%al
  801645:	74 eb                	je     801632 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801647:	8b 45 08             	mov    0x8(%ebp),%eax
  80164a:	8a 00                	mov    (%eax),%al
  80164c:	3c 2b                	cmp    $0x2b,%al
  80164e:	75 05                	jne    801655 <strtol+0x39>
		s++;
  801650:	ff 45 08             	incl   0x8(%ebp)
  801653:	eb 13                	jmp    801668 <strtol+0x4c>
	else if (*s == '-')
  801655:	8b 45 08             	mov    0x8(%ebp),%eax
  801658:	8a 00                	mov    (%eax),%al
  80165a:	3c 2d                	cmp    $0x2d,%al
  80165c:	75 0a                	jne    801668 <strtol+0x4c>
		s++, neg = 1;
  80165e:	ff 45 08             	incl   0x8(%ebp)
  801661:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801668:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80166c:	74 06                	je     801674 <strtol+0x58>
  80166e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801672:	75 20                	jne    801694 <strtol+0x78>
  801674:	8b 45 08             	mov    0x8(%ebp),%eax
  801677:	8a 00                	mov    (%eax),%al
  801679:	3c 30                	cmp    $0x30,%al
  80167b:	75 17                	jne    801694 <strtol+0x78>
  80167d:	8b 45 08             	mov    0x8(%ebp),%eax
  801680:	40                   	inc    %eax
  801681:	8a 00                	mov    (%eax),%al
  801683:	3c 78                	cmp    $0x78,%al
  801685:	75 0d                	jne    801694 <strtol+0x78>
		s += 2, base = 16;
  801687:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80168b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801692:	eb 28                	jmp    8016bc <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801694:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801698:	75 15                	jne    8016af <strtol+0x93>
  80169a:	8b 45 08             	mov    0x8(%ebp),%eax
  80169d:	8a 00                	mov    (%eax),%al
  80169f:	3c 30                	cmp    $0x30,%al
  8016a1:	75 0c                	jne    8016af <strtol+0x93>
		s++, base = 8;
  8016a3:	ff 45 08             	incl   0x8(%ebp)
  8016a6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8016ad:	eb 0d                	jmp    8016bc <strtol+0xa0>
	else if (base == 0)
  8016af:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016b3:	75 07                	jne    8016bc <strtol+0xa0>
		base = 10;
  8016b5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bf:	8a 00                	mov    (%eax),%al
  8016c1:	3c 2f                	cmp    $0x2f,%al
  8016c3:	7e 19                	jle    8016de <strtol+0xc2>
  8016c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c8:	8a 00                	mov    (%eax),%al
  8016ca:	3c 39                	cmp    $0x39,%al
  8016cc:	7f 10                	jg     8016de <strtol+0xc2>
			dig = *s - '0';
  8016ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d1:	8a 00                	mov    (%eax),%al
  8016d3:	0f be c0             	movsbl %al,%eax
  8016d6:	83 e8 30             	sub    $0x30,%eax
  8016d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016dc:	eb 42                	jmp    801720 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8016de:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e1:	8a 00                	mov    (%eax),%al
  8016e3:	3c 60                	cmp    $0x60,%al
  8016e5:	7e 19                	jle    801700 <strtol+0xe4>
  8016e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ea:	8a 00                	mov    (%eax),%al
  8016ec:	3c 7a                	cmp    $0x7a,%al
  8016ee:	7f 10                	jg     801700 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8016f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f3:	8a 00                	mov    (%eax),%al
  8016f5:	0f be c0             	movsbl %al,%eax
  8016f8:	83 e8 57             	sub    $0x57,%eax
  8016fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016fe:	eb 20                	jmp    801720 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801700:	8b 45 08             	mov    0x8(%ebp),%eax
  801703:	8a 00                	mov    (%eax),%al
  801705:	3c 40                	cmp    $0x40,%al
  801707:	7e 39                	jle    801742 <strtol+0x126>
  801709:	8b 45 08             	mov    0x8(%ebp),%eax
  80170c:	8a 00                	mov    (%eax),%al
  80170e:	3c 5a                	cmp    $0x5a,%al
  801710:	7f 30                	jg     801742 <strtol+0x126>
			dig = *s - 'A' + 10;
  801712:	8b 45 08             	mov    0x8(%ebp),%eax
  801715:	8a 00                	mov    (%eax),%al
  801717:	0f be c0             	movsbl %al,%eax
  80171a:	83 e8 37             	sub    $0x37,%eax
  80171d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801720:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801723:	3b 45 10             	cmp    0x10(%ebp),%eax
  801726:	7d 19                	jge    801741 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801728:	ff 45 08             	incl   0x8(%ebp)
  80172b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80172e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801732:	89 c2                	mov    %eax,%edx
  801734:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801737:	01 d0                	add    %edx,%eax
  801739:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80173c:	e9 7b ff ff ff       	jmp    8016bc <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801741:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801742:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801746:	74 08                	je     801750 <strtol+0x134>
		*endptr = (char *) s;
  801748:	8b 45 0c             	mov    0xc(%ebp),%eax
  80174b:	8b 55 08             	mov    0x8(%ebp),%edx
  80174e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801750:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801754:	74 07                	je     80175d <strtol+0x141>
  801756:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801759:	f7 d8                	neg    %eax
  80175b:	eb 03                	jmp    801760 <strtol+0x144>
  80175d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801760:	c9                   	leave  
  801761:	c3                   	ret    

00801762 <ltostr>:

void
ltostr(long value, char *str)
{
  801762:	55                   	push   %ebp
  801763:	89 e5                	mov    %esp,%ebp
  801765:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801768:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80176f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801776:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80177a:	79 13                	jns    80178f <ltostr+0x2d>
	{
		neg = 1;
  80177c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801783:	8b 45 0c             	mov    0xc(%ebp),%eax
  801786:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801789:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80178c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80178f:	8b 45 08             	mov    0x8(%ebp),%eax
  801792:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801797:	99                   	cltd   
  801798:	f7 f9                	idiv   %ecx
  80179a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80179d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017a0:	8d 50 01             	lea    0x1(%eax),%edx
  8017a3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017a6:	89 c2                	mov    %eax,%edx
  8017a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ab:	01 d0                	add    %edx,%eax
  8017ad:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017b0:	83 c2 30             	add    $0x30,%edx
  8017b3:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8017b5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017b8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8017bd:	f7 e9                	imul   %ecx
  8017bf:	c1 fa 02             	sar    $0x2,%edx
  8017c2:	89 c8                	mov    %ecx,%eax
  8017c4:	c1 f8 1f             	sar    $0x1f,%eax
  8017c7:	29 c2                	sub    %eax,%edx
  8017c9:	89 d0                	mov    %edx,%eax
  8017cb:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8017ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017d1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8017d6:	f7 e9                	imul   %ecx
  8017d8:	c1 fa 02             	sar    $0x2,%edx
  8017db:	89 c8                	mov    %ecx,%eax
  8017dd:	c1 f8 1f             	sar    $0x1f,%eax
  8017e0:	29 c2                	sub    %eax,%edx
  8017e2:	89 d0                	mov    %edx,%eax
  8017e4:	c1 e0 02             	shl    $0x2,%eax
  8017e7:	01 d0                	add    %edx,%eax
  8017e9:	01 c0                	add    %eax,%eax
  8017eb:	29 c1                	sub    %eax,%ecx
  8017ed:	89 ca                	mov    %ecx,%edx
  8017ef:	85 d2                	test   %edx,%edx
  8017f1:	75 9c                	jne    80178f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8017f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8017fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017fd:	48                   	dec    %eax
  8017fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801801:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801805:	74 3d                	je     801844 <ltostr+0xe2>
		start = 1 ;
  801807:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80180e:	eb 34                	jmp    801844 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801810:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801813:	8b 45 0c             	mov    0xc(%ebp),%eax
  801816:	01 d0                	add    %edx,%eax
  801818:	8a 00                	mov    (%eax),%al
  80181a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80181d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801820:	8b 45 0c             	mov    0xc(%ebp),%eax
  801823:	01 c2                	add    %eax,%edx
  801825:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801828:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182b:	01 c8                	add    %ecx,%eax
  80182d:	8a 00                	mov    (%eax),%al
  80182f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801831:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801834:	8b 45 0c             	mov    0xc(%ebp),%eax
  801837:	01 c2                	add    %eax,%edx
  801839:	8a 45 eb             	mov    -0x15(%ebp),%al
  80183c:	88 02                	mov    %al,(%edx)
		start++ ;
  80183e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801841:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801847:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80184a:	7c c4                	jl     801810 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80184c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80184f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801852:	01 d0                	add    %edx,%eax
  801854:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801857:	90                   	nop
  801858:	c9                   	leave  
  801859:	c3                   	ret    

0080185a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80185a:	55                   	push   %ebp
  80185b:	89 e5                	mov    %esp,%ebp
  80185d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801860:	ff 75 08             	pushl  0x8(%ebp)
  801863:	e8 54 fa ff ff       	call   8012bc <strlen>
  801868:	83 c4 04             	add    $0x4,%esp
  80186b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80186e:	ff 75 0c             	pushl  0xc(%ebp)
  801871:	e8 46 fa ff ff       	call   8012bc <strlen>
  801876:	83 c4 04             	add    $0x4,%esp
  801879:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80187c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801883:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80188a:	eb 17                	jmp    8018a3 <strcconcat+0x49>
		final[s] = str1[s] ;
  80188c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80188f:	8b 45 10             	mov    0x10(%ebp),%eax
  801892:	01 c2                	add    %eax,%edx
  801894:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801897:	8b 45 08             	mov    0x8(%ebp),%eax
  80189a:	01 c8                	add    %ecx,%eax
  80189c:	8a 00                	mov    (%eax),%al
  80189e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8018a0:	ff 45 fc             	incl   -0x4(%ebp)
  8018a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018a6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8018a9:	7c e1                	jl     80188c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8018ab:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8018b2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8018b9:	eb 1f                	jmp    8018da <strcconcat+0x80>
		final[s++] = str2[i] ;
  8018bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018be:	8d 50 01             	lea    0x1(%eax),%edx
  8018c1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8018c4:	89 c2                	mov    %eax,%edx
  8018c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8018c9:	01 c2                	add    %eax,%edx
  8018cb:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8018ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d1:	01 c8                	add    %ecx,%eax
  8018d3:	8a 00                	mov    (%eax),%al
  8018d5:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8018d7:	ff 45 f8             	incl   -0x8(%ebp)
  8018da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018dd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018e0:	7c d9                	jl     8018bb <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8018e2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e8:	01 d0                	add    %edx,%eax
  8018ea:	c6 00 00             	movb   $0x0,(%eax)
}
  8018ed:	90                   	nop
  8018ee:	c9                   	leave  
  8018ef:	c3                   	ret    

008018f0 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8018f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8018f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8018fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8018ff:	8b 00                	mov    (%eax),%eax
  801901:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801908:	8b 45 10             	mov    0x10(%ebp),%eax
  80190b:	01 d0                	add    %edx,%eax
  80190d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801913:	eb 0c                	jmp    801921 <strsplit+0x31>
			*string++ = 0;
  801915:	8b 45 08             	mov    0x8(%ebp),%eax
  801918:	8d 50 01             	lea    0x1(%eax),%edx
  80191b:	89 55 08             	mov    %edx,0x8(%ebp)
  80191e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801921:	8b 45 08             	mov    0x8(%ebp),%eax
  801924:	8a 00                	mov    (%eax),%al
  801926:	84 c0                	test   %al,%al
  801928:	74 18                	je     801942 <strsplit+0x52>
  80192a:	8b 45 08             	mov    0x8(%ebp),%eax
  80192d:	8a 00                	mov    (%eax),%al
  80192f:	0f be c0             	movsbl %al,%eax
  801932:	50                   	push   %eax
  801933:	ff 75 0c             	pushl  0xc(%ebp)
  801936:	e8 13 fb ff ff       	call   80144e <strchr>
  80193b:	83 c4 08             	add    $0x8,%esp
  80193e:	85 c0                	test   %eax,%eax
  801940:	75 d3                	jne    801915 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801942:	8b 45 08             	mov    0x8(%ebp),%eax
  801945:	8a 00                	mov    (%eax),%al
  801947:	84 c0                	test   %al,%al
  801949:	74 5a                	je     8019a5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80194b:	8b 45 14             	mov    0x14(%ebp),%eax
  80194e:	8b 00                	mov    (%eax),%eax
  801950:	83 f8 0f             	cmp    $0xf,%eax
  801953:	75 07                	jne    80195c <strsplit+0x6c>
		{
			return 0;
  801955:	b8 00 00 00 00       	mov    $0x0,%eax
  80195a:	eb 66                	jmp    8019c2 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80195c:	8b 45 14             	mov    0x14(%ebp),%eax
  80195f:	8b 00                	mov    (%eax),%eax
  801961:	8d 48 01             	lea    0x1(%eax),%ecx
  801964:	8b 55 14             	mov    0x14(%ebp),%edx
  801967:	89 0a                	mov    %ecx,(%edx)
  801969:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801970:	8b 45 10             	mov    0x10(%ebp),%eax
  801973:	01 c2                	add    %eax,%edx
  801975:	8b 45 08             	mov    0x8(%ebp),%eax
  801978:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80197a:	eb 03                	jmp    80197f <strsplit+0x8f>
			string++;
  80197c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80197f:	8b 45 08             	mov    0x8(%ebp),%eax
  801982:	8a 00                	mov    (%eax),%al
  801984:	84 c0                	test   %al,%al
  801986:	74 8b                	je     801913 <strsplit+0x23>
  801988:	8b 45 08             	mov    0x8(%ebp),%eax
  80198b:	8a 00                	mov    (%eax),%al
  80198d:	0f be c0             	movsbl %al,%eax
  801990:	50                   	push   %eax
  801991:	ff 75 0c             	pushl  0xc(%ebp)
  801994:	e8 b5 fa ff ff       	call   80144e <strchr>
  801999:	83 c4 08             	add    $0x8,%esp
  80199c:	85 c0                	test   %eax,%eax
  80199e:	74 dc                	je     80197c <strsplit+0x8c>
			string++;
	}
  8019a0:	e9 6e ff ff ff       	jmp    801913 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8019a5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8019a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8019a9:	8b 00                	mov    (%eax),%eax
  8019ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8019b5:	01 d0                	add    %edx,%eax
  8019b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8019bd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8019c2:	c9                   	leave  
  8019c3:	c3                   	ret    

008019c4 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8019c4:	55                   	push   %ebp
  8019c5:	89 e5                	mov    %esp,%ebp
  8019c7:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8019ca:	a1 04 50 80 00       	mov    0x805004,%eax
  8019cf:	85 c0                	test   %eax,%eax
  8019d1:	74 1f                	je     8019f2 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8019d3:	e8 1d 00 00 00       	call   8019f5 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8019d8:	83 ec 0c             	sub    $0xc,%esp
  8019db:	68 24 41 80 00       	push   $0x804124
  8019e0:	e8 4f f0 ff ff       	call   800a34 <cprintf>
  8019e5:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8019e8:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  8019ef:	00 00 00 
	}
}
  8019f2:	90                   	nop
  8019f3:	c9                   	leave  
  8019f4:	c3                   	ret    

008019f5 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8019f5:	55                   	push   %ebp
  8019f6:	89 e5                	mov    %esp,%ebp
  8019f8:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  8019fb:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801a02:	00 00 00 
  801a05:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801a0c:	00 00 00 
  801a0f:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801a16:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  801a19:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801a20:	00 00 00 
  801a23:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801a2a:	00 00 00 
  801a2d:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801a34:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801a37:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801a3e:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801a41:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a4b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a50:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a55:	a3 50 50 80 00       	mov    %eax,0x805050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  801a5a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801a61:	a1 20 51 80 00       	mov    0x805120,%eax
  801a66:	c1 e0 04             	shl    $0x4,%eax
  801a69:	89 c2                	mov    %eax,%edx
  801a6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a6e:	01 d0                	add    %edx,%eax
  801a70:	48                   	dec    %eax
  801a71:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801a74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a77:	ba 00 00 00 00       	mov    $0x0,%edx
  801a7c:	f7 75 f0             	divl   -0x10(%ebp)
  801a7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a82:	29 d0                	sub    %edx,%eax
  801a84:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  801a87:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801a8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a91:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a96:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a9b:	83 ec 04             	sub    $0x4,%esp
  801a9e:	6a 06                	push   $0x6
  801aa0:	ff 75 e8             	pushl  -0x18(%ebp)
  801aa3:	50                   	push   %eax
  801aa4:	e8 b0 05 00 00       	call   802059 <sys_allocate_chunk>
  801aa9:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801aac:	a1 20 51 80 00       	mov    0x805120,%eax
  801ab1:	83 ec 0c             	sub    $0xc,%esp
  801ab4:	50                   	push   %eax
  801ab5:	e8 25 0c 00 00       	call   8026df <initialize_MemBlocksList>
  801aba:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  801abd:	a1 48 51 80 00       	mov    0x805148,%eax
  801ac2:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  801ac5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ac9:	75 14                	jne    801adf <initialize_dyn_block_system+0xea>
  801acb:	83 ec 04             	sub    $0x4,%esp
  801ace:	68 49 41 80 00       	push   $0x804149
  801ad3:	6a 29                	push   $0x29
  801ad5:	68 67 41 80 00       	push   $0x804167
  801ada:	e8 a1 ec ff ff       	call   800780 <_panic>
  801adf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ae2:	8b 00                	mov    (%eax),%eax
  801ae4:	85 c0                	test   %eax,%eax
  801ae6:	74 10                	je     801af8 <initialize_dyn_block_system+0x103>
  801ae8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801aeb:	8b 00                	mov    (%eax),%eax
  801aed:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801af0:	8b 52 04             	mov    0x4(%edx),%edx
  801af3:	89 50 04             	mov    %edx,0x4(%eax)
  801af6:	eb 0b                	jmp    801b03 <initialize_dyn_block_system+0x10e>
  801af8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801afb:	8b 40 04             	mov    0x4(%eax),%eax
  801afe:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801b03:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b06:	8b 40 04             	mov    0x4(%eax),%eax
  801b09:	85 c0                	test   %eax,%eax
  801b0b:	74 0f                	je     801b1c <initialize_dyn_block_system+0x127>
  801b0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b10:	8b 40 04             	mov    0x4(%eax),%eax
  801b13:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b16:	8b 12                	mov    (%edx),%edx
  801b18:	89 10                	mov    %edx,(%eax)
  801b1a:	eb 0a                	jmp    801b26 <initialize_dyn_block_system+0x131>
  801b1c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b1f:	8b 00                	mov    (%eax),%eax
  801b21:	a3 48 51 80 00       	mov    %eax,0x805148
  801b26:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b29:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801b2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b32:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801b39:	a1 54 51 80 00       	mov    0x805154,%eax
  801b3e:	48                   	dec    %eax
  801b3f:	a3 54 51 80 00       	mov    %eax,0x805154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  801b44:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b47:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  801b4e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b51:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  801b58:	83 ec 0c             	sub    $0xc,%esp
  801b5b:	ff 75 e0             	pushl  -0x20(%ebp)
  801b5e:	e8 b9 14 00 00       	call   80301c <insert_sorted_with_merge_freeList>
  801b63:	83 c4 10             	add    $0x10,%esp

}
  801b66:	90                   	nop
  801b67:	c9                   	leave  
  801b68:	c3                   	ret    

00801b69 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801b69:	55                   	push   %ebp
  801b6a:	89 e5                	mov    %esp,%ebp
  801b6c:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b6f:	e8 50 fe ff ff       	call   8019c4 <InitializeUHeap>
	if (size == 0) return NULL ;
  801b74:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b78:	75 07                	jne    801b81 <malloc+0x18>
  801b7a:	b8 00 00 00 00       	mov    $0x0,%eax
  801b7f:	eb 68                	jmp    801be9 <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  801b81:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801b88:	8b 55 08             	mov    0x8(%ebp),%edx
  801b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b8e:	01 d0                	add    %edx,%eax
  801b90:	48                   	dec    %eax
  801b91:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b97:	ba 00 00 00 00       	mov    $0x0,%edx
  801b9c:	f7 75 f4             	divl   -0xc(%ebp)
  801b9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ba2:	29 d0                	sub    %edx,%eax
  801ba4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  801ba7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801bae:	e8 74 08 00 00       	call   802427 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801bb3:	85 c0                	test   %eax,%eax
  801bb5:	74 2d                	je     801be4 <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  801bb7:	83 ec 0c             	sub    $0xc,%esp
  801bba:	ff 75 ec             	pushl  -0x14(%ebp)
  801bbd:	e8 52 0e 00 00       	call   802a14 <alloc_block_FF>
  801bc2:	83 c4 10             	add    $0x10,%esp
  801bc5:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  801bc8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801bcc:	74 16                	je     801be4 <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  801bce:	83 ec 0c             	sub    $0xc,%esp
  801bd1:	ff 75 e8             	pushl  -0x18(%ebp)
  801bd4:	e8 3b 0c 00 00       	call   802814 <insert_sorted_allocList>
  801bd9:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  801bdc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bdf:	8b 40 08             	mov    0x8(%eax),%eax
  801be2:	eb 05                	jmp    801be9 <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  801be4:	b8 00 00 00 00       	mov    $0x0,%eax

}
  801be9:	c9                   	leave  
  801bea:	c3                   	ret    

00801beb <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801beb:	55                   	push   %ebp
  801bec:	89 e5                	mov    %esp,%ebp
  801bee:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  801bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf4:	83 ec 08             	sub    $0x8,%esp
  801bf7:	50                   	push   %eax
  801bf8:	68 40 50 80 00       	push   $0x805040
  801bfd:	e8 ba 0b 00 00       	call   8027bc <find_block>
  801c02:	83 c4 10             	add    $0x10,%esp
  801c05:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  801c08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c0b:	8b 40 0c             	mov    0xc(%eax),%eax
  801c0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  801c11:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c15:	0f 84 9f 00 00 00    	je     801cba <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  801c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1e:	83 ec 08             	sub    $0x8,%esp
  801c21:	ff 75 f0             	pushl  -0x10(%ebp)
  801c24:	50                   	push   %eax
  801c25:	e8 f7 03 00 00       	call   802021 <sys_free_user_mem>
  801c2a:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  801c2d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c31:	75 14                	jne    801c47 <free+0x5c>
  801c33:	83 ec 04             	sub    $0x4,%esp
  801c36:	68 49 41 80 00       	push   $0x804149
  801c3b:	6a 6a                	push   $0x6a
  801c3d:	68 67 41 80 00       	push   $0x804167
  801c42:	e8 39 eb ff ff       	call   800780 <_panic>
  801c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c4a:	8b 00                	mov    (%eax),%eax
  801c4c:	85 c0                	test   %eax,%eax
  801c4e:	74 10                	je     801c60 <free+0x75>
  801c50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c53:	8b 00                	mov    (%eax),%eax
  801c55:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c58:	8b 52 04             	mov    0x4(%edx),%edx
  801c5b:	89 50 04             	mov    %edx,0x4(%eax)
  801c5e:	eb 0b                	jmp    801c6b <free+0x80>
  801c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c63:	8b 40 04             	mov    0x4(%eax),%eax
  801c66:	a3 44 50 80 00       	mov    %eax,0x805044
  801c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c6e:	8b 40 04             	mov    0x4(%eax),%eax
  801c71:	85 c0                	test   %eax,%eax
  801c73:	74 0f                	je     801c84 <free+0x99>
  801c75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c78:	8b 40 04             	mov    0x4(%eax),%eax
  801c7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c7e:	8b 12                	mov    (%edx),%edx
  801c80:	89 10                	mov    %edx,(%eax)
  801c82:	eb 0a                	jmp    801c8e <free+0xa3>
  801c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c87:	8b 00                	mov    (%eax),%eax
  801c89:	a3 40 50 80 00       	mov    %eax,0x805040
  801c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c91:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c9a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ca1:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801ca6:	48                   	dec    %eax
  801ca7:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(blk);
  801cac:	83 ec 0c             	sub    $0xc,%esp
  801caf:	ff 75 f4             	pushl  -0xc(%ebp)
  801cb2:	e8 65 13 00 00       	call   80301c <insert_sorted_with_merge_freeList>
  801cb7:	83 c4 10             	add    $0x10,%esp
	}
}
  801cba:	90                   	nop
  801cbb:	c9                   	leave  
  801cbc:	c3                   	ret    

00801cbd <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801cbd:	55                   	push   %ebp
  801cbe:	89 e5                	mov    %esp,%ebp
  801cc0:	83 ec 28             	sub    $0x28,%esp
  801cc3:	8b 45 10             	mov    0x10(%ebp),%eax
  801cc6:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801cc9:	e8 f6 fc ff ff       	call   8019c4 <InitializeUHeap>
	if (size == 0) return NULL ;
  801cce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801cd2:	75 0a                	jne    801cde <smalloc+0x21>
  801cd4:	b8 00 00 00 00       	mov    $0x0,%eax
  801cd9:	e9 af 00 00 00       	jmp    801d8d <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  801cde:	e8 44 07 00 00       	call   802427 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801ce3:	83 f8 01             	cmp    $0x1,%eax
  801ce6:	0f 85 9c 00 00 00    	jne    801d88 <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  801cec:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801cf3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf9:	01 d0                	add    %edx,%eax
  801cfb:	48                   	dec    %eax
  801cfc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801cff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d02:	ba 00 00 00 00       	mov    $0x0,%edx
  801d07:	f7 75 f4             	divl   -0xc(%ebp)
  801d0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d0d:	29 d0                	sub    %edx,%eax
  801d0f:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  801d12:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  801d19:	76 07                	jbe    801d22 <smalloc+0x65>
			return NULL;
  801d1b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d20:	eb 6b                	jmp    801d8d <smalloc+0xd0>
		blk =alloc_block_FF(size);
  801d22:	83 ec 0c             	sub    $0xc,%esp
  801d25:	ff 75 0c             	pushl  0xc(%ebp)
  801d28:	e8 e7 0c 00 00       	call   802a14 <alloc_block_FF>
  801d2d:	83 c4 10             	add    $0x10,%esp
  801d30:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  801d33:	83 ec 0c             	sub    $0xc,%esp
  801d36:	ff 75 ec             	pushl  -0x14(%ebp)
  801d39:	e8 d6 0a 00 00       	call   802814 <insert_sorted_allocList>
  801d3e:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  801d41:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d45:	75 07                	jne    801d4e <smalloc+0x91>
		{
			return NULL;
  801d47:	b8 00 00 00 00       	mov    $0x0,%eax
  801d4c:	eb 3f                	jmp    801d8d <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  801d4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d51:	8b 40 08             	mov    0x8(%eax),%eax
  801d54:	89 c2                	mov    %eax,%edx
  801d56:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801d5a:	52                   	push   %edx
  801d5b:	50                   	push   %eax
  801d5c:	ff 75 0c             	pushl  0xc(%ebp)
  801d5f:	ff 75 08             	pushl  0x8(%ebp)
  801d62:	e8 45 04 00 00       	call   8021ac <sys_createSharedObject>
  801d67:	83 c4 10             	add    $0x10,%esp
  801d6a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  801d6d:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801d71:	74 06                	je     801d79 <smalloc+0xbc>
  801d73:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801d77:	75 07                	jne    801d80 <smalloc+0xc3>
		{
			return NULL;
  801d79:	b8 00 00 00 00       	mov    $0x0,%eax
  801d7e:	eb 0d                	jmp    801d8d <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  801d80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d83:	8b 40 08             	mov    0x8(%eax),%eax
  801d86:	eb 05                	jmp    801d8d <smalloc+0xd0>
		}
	}
	else
		return NULL;
  801d88:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d8d:	c9                   	leave  
  801d8e:	c3                   	ret    

00801d8f <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801d8f:	55                   	push   %ebp
  801d90:	89 e5                	mov    %esp,%ebp
  801d92:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d95:	e8 2a fc ff ff       	call   8019c4 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801d9a:	83 ec 08             	sub    $0x8,%esp
  801d9d:	ff 75 0c             	pushl  0xc(%ebp)
  801da0:	ff 75 08             	pushl  0x8(%ebp)
  801da3:	e8 2e 04 00 00       	call   8021d6 <sys_getSizeOfSharedObject>
  801da8:	83 c4 10             	add    $0x10,%esp
  801dab:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  801dae:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801db2:	75 0a                	jne    801dbe <sget+0x2f>
	{
		return NULL;
  801db4:	b8 00 00 00 00       	mov    $0x0,%eax
  801db9:	e9 94 00 00 00       	jmp    801e52 <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801dbe:	e8 64 06 00 00       	call   802427 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801dc3:	85 c0                	test   %eax,%eax
  801dc5:	0f 84 82 00 00 00    	je     801e4d <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  801dcb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  801dd2:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801dd9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ddc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ddf:	01 d0                	add    %edx,%eax
  801de1:	48                   	dec    %eax
  801de2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801de5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801de8:	ba 00 00 00 00       	mov    $0x0,%edx
  801ded:	f7 75 ec             	divl   -0x14(%ebp)
  801df0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801df3:	29 d0                	sub    %edx,%eax
  801df5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  801df8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dfb:	83 ec 0c             	sub    $0xc,%esp
  801dfe:	50                   	push   %eax
  801dff:	e8 10 0c 00 00       	call   802a14 <alloc_block_FF>
  801e04:	83 c4 10             	add    $0x10,%esp
  801e07:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  801e0a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e0e:	75 07                	jne    801e17 <sget+0x88>
		{
			return NULL;
  801e10:	b8 00 00 00 00       	mov    $0x0,%eax
  801e15:	eb 3b                	jmp    801e52 <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  801e17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e1a:	8b 40 08             	mov    0x8(%eax),%eax
  801e1d:	83 ec 04             	sub    $0x4,%esp
  801e20:	50                   	push   %eax
  801e21:	ff 75 0c             	pushl  0xc(%ebp)
  801e24:	ff 75 08             	pushl  0x8(%ebp)
  801e27:	e8 c7 03 00 00       	call   8021f3 <sys_getSharedObject>
  801e2c:	83 c4 10             	add    $0x10,%esp
  801e2f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  801e32:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801e36:	74 06                	je     801e3e <sget+0xaf>
  801e38:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  801e3c:	75 07                	jne    801e45 <sget+0xb6>
		{
			return NULL;
  801e3e:	b8 00 00 00 00       	mov    $0x0,%eax
  801e43:	eb 0d                	jmp    801e52 <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  801e45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e48:	8b 40 08             	mov    0x8(%eax),%eax
  801e4b:	eb 05                	jmp    801e52 <sget+0xc3>
		}
	}
	else
			return NULL;
  801e4d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e52:	c9                   	leave  
  801e53:	c3                   	ret    

00801e54 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801e54:	55                   	push   %ebp
  801e55:	89 e5                	mov    %esp,%ebp
  801e57:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e5a:	e8 65 fb ff ff       	call   8019c4 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801e5f:	83 ec 04             	sub    $0x4,%esp
  801e62:	68 74 41 80 00       	push   $0x804174
  801e67:	68 e1 00 00 00       	push   $0xe1
  801e6c:	68 67 41 80 00       	push   $0x804167
  801e71:	e8 0a e9 ff ff       	call   800780 <_panic>

00801e76 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801e76:	55                   	push   %ebp
  801e77:	89 e5                	mov    %esp,%ebp
  801e79:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801e7c:	83 ec 04             	sub    $0x4,%esp
  801e7f:	68 9c 41 80 00       	push   $0x80419c
  801e84:	68 f5 00 00 00       	push   $0xf5
  801e89:	68 67 41 80 00       	push   $0x804167
  801e8e:	e8 ed e8 ff ff       	call   800780 <_panic>

00801e93 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801e93:	55                   	push   %ebp
  801e94:	89 e5                	mov    %esp,%ebp
  801e96:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e99:	83 ec 04             	sub    $0x4,%esp
  801e9c:	68 c0 41 80 00       	push   $0x8041c0
  801ea1:	68 00 01 00 00       	push   $0x100
  801ea6:	68 67 41 80 00       	push   $0x804167
  801eab:	e8 d0 e8 ff ff       	call   800780 <_panic>

00801eb0 <shrink>:

}
void shrink(uint32 newSize)
{
  801eb0:	55                   	push   %ebp
  801eb1:	89 e5                	mov    %esp,%ebp
  801eb3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801eb6:	83 ec 04             	sub    $0x4,%esp
  801eb9:	68 c0 41 80 00       	push   $0x8041c0
  801ebe:	68 05 01 00 00       	push   $0x105
  801ec3:	68 67 41 80 00       	push   $0x804167
  801ec8:	e8 b3 e8 ff ff       	call   800780 <_panic>

00801ecd <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801ecd:	55                   	push   %ebp
  801ece:	89 e5                	mov    %esp,%ebp
  801ed0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ed3:	83 ec 04             	sub    $0x4,%esp
  801ed6:	68 c0 41 80 00       	push   $0x8041c0
  801edb:	68 0a 01 00 00       	push   $0x10a
  801ee0:	68 67 41 80 00       	push   $0x804167
  801ee5:	e8 96 e8 ff ff       	call   800780 <_panic>

00801eea <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801eea:	55                   	push   %ebp
  801eeb:	89 e5                	mov    %esp,%ebp
  801eed:	57                   	push   %edi
  801eee:	56                   	push   %esi
  801eef:	53                   	push   %ebx
  801ef0:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801efc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801eff:	8b 7d 18             	mov    0x18(%ebp),%edi
  801f02:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801f05:	cd 30                	int    $0x30
  801f07:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801f0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f0d:	83 c4 10             	add    $0x10,%esp
  801f10:	5b                   	pop    %ebx
  801f11:	5e                   	pop    %esi
  801f12:	5f                   	pop    %edi
  801f13:	5d                   	pop    %ebp
  801f14:	c3                   	ret    

00801f15 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801f15:	55                   	push   %ebp
  801f16:	89 e5                	mov    %esp,%ebp
  801f18:	83 ec 04             	sub    $0x4,%esp
  801f1b:	8b 45 10             	mov    0x10(%ebp),%eax
  801f1e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801f21:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f25:	8b 45 08             	mov    0x8(%ebp),%eax
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 00                	push   $0x0
  801f2c:	52                   	push   %edx
  801f2d:	ff 75 0c             	pushl  0xc(%ebp)
  801f30:	50                   	push   %eax
  801f31:	6a 00                	push   $0x0
  801f33:	e8 b2 ff ff ff       	call   801eea <syscall>
  801f38:	83 c4 18             	add    $0x18,%esp
}
  801f3b:	90                   	nop
  801f3c:	c9                   	leave  
  801f3d:	c3                   	ret    

00801f3e <sys_cgetc>:

int
sys_cgetc(void)
{
  801f3e:	55                   	push   %ebp
  801f3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801f41:	6a 00                	push   $0x0
  801f43:	6a 00                	push   $0x0
  801f45:	6a 00                	push   $0x0
  801f47:	6a 00                	push   $0x0
  801f49:	6a 00                	push   $0x0
  801f4b:	6a 01                	push   $0x1
  801f4d:	e8 98 ff ff ff       	call   801eea <syscall>
  801f52:	83 c4 18             	add    $0x18,%esp
}
  801f55:	c9                   	leave  
  801f56:	c3                   	ret    

00801f57 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801f57:	55                   	push   %ebp
  801f58:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801f5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f60:	6a 00                	push   $0x0
  801f62:	6a 00                	push   $0x0
  801f64:	6a 00                	push   $0x0
  801f66:	52                   	push   %edx
  801f67:	50                   	push   %eax
  801f68:	6a 05                	push   $0x5
  801f6a:	e8 7b ff ff ff       	call   801eea <syscall>
  801f6f:	83 c4 18             	add    $0x18,%esp
}
  801f72:	c9                   	leave  
  801f73:	c3                   	ret    

00801f74 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f74:	55                   	push   %ebp
  801f75:	89 e5                	mov    %esp,%ebp
  801f77:	56                   	push   %esi
  801f78:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801f79:	8b 75 18             	mov    0x18(%ebp),%esi
  801f7c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f7f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f82:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f85:	8b 45 08             	mov    0x8(%ebp),%eax
  801f88:	56                   	push   %esi
  801f89:	53                   	push   %ebx
  801f8a:	51                   	push   %ecx
  801f8b:	52                   	push   %edx
  801f8c:	50                   	push   %eax
  801f8d:	6a 06                	push   $0x6
  801f8f:	e8 56 ff ff ff       	call   801eea <syscall>
  801f94:	83 c4 18             	add    $0x18,%esp
}
  801f97:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f9a:	5b                   	pop    %ebx
  801f9b:	5e                   	pop    %esi
  801f9c:	5d                   	pop    %ebp
  801f9d:	c3                   	ret    

00801f9e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801f9e:	55                   	push   %ebp
  801f9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801fa1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa7:	6a 00                	push   $0x0
  801fa9:	6a 00                	push   $0x0
  801fab:	6a 00                	push   $0x0
  801fad:	52                   	push   %edx
  801fae:	50                   	push   %eax
  801faf:	6a 07                	push   $0x7
  801fb1:	e8 34 ff ff ff       	call   801eea <syscall>
  801fb6:	83 c4 18             	add    $0x18,%esp
}
  801fb9:	c9                   	leave  
  801fba:	c3                   	ret    

00801fbb <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801fbb:	55                   	push   %ebp
  801fbc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801fbe:	6a 00                	push   $0x0
  801fc0:	6a 00                	push   $0x0
  801fc2:	6a 00                	push   $0x0
  801fc4:	ff 75 0c             	pushl  0xc(%ebp)
  801fc7:	ff 75 08             	pushl  0x8(%ebp)
  801fca:	6a 08                	push   $0x8
  801fcc:	e8 19 ff ff ff       	call   801eea <syscall>
  801fd1:	83 c4 18             	add    $0x18,%esp
}
  801fd4:	c9                   	leave  
  801fd5:	c3                   	ret    

00801fd6 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801fd6:	55                   	push   %ebp
  801fd7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801fd9:	6a 00                	push   $0x0
  801fdb:	6a 00                	push   $0x0
  801fdd:	6a 00                	push   $0x0
  801fdf:	6a 00                	push   $0x0
  801fe1:	6a 00                	push   $0x0
  801fe3:	6a 09                	push   $0x9
  801fe5:	e8 00 ff ff ff       	call   801eea <syscall>
  801fea:	83 c4 18             	add    $0x18,%esp
}
  801fed:	c9                   	leave  
  801fee:	c3                   	ret    

00801fef <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801fef:	55                   	push   %ebp
  801ff0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ff2:	6a 00                	push   $0x0
  801ff4:	6a 00                	push   $0x0
  801ff6:	6a 00                	push   $0x0
  801ff8:	6a 00                	push   $0x0
  801ffa:	6a 00                	push   $0x0
  801ffc:	6a 0a                	push   $0xa
  801ffe:	e8 e7 fe ff ff       	call   801eea <syscall>
  802003:	83 c4 18             	add    $0x18,%esp
}
  802006:	c9                   	leave  
  802007:	c3                   	ret    

00802008 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802008:	55                   	push   %ebp
  802009:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80200b:	6a 00                	push   $0x0
  80200d:	6a 00                	push   $0x0
  80200f:	6a 00                	push   $0x0
  802011:	6a 00                	push   $0x0
  802013:	6a 00                	push   $0x0
  802015:	6a 0b                	push   $0xb
  802017:	e8 ce fe ff ff       	call   801eea <syscall>
  80201c:	83 c4 18             	add    $0x18,%esp
}
  80201f:	c9                   	leave  
  802020:	c3                   	ret    

00802021 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802021:	55                   	push   %ebp
  802022:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802024:	6a 00                	push   $0x0
  802026:	6a 00                	push   $0x0
  802028:	6a 00                	push   $0x0
  80202a:	ff 75 0c             	pushl  0xc(%ebp)
  80202d:	ff 75 08             	pushl  0x8(%ebp)
  802030:	6a 0f                	push   $0xf
  802032:	e8 b3 fe ff ff       	call   801eea <syscall>
  802037:	83 c4 18             	add    $0x18,%esp
	return;
  80203a:	90                   	nop
}
  80203b:	c9                   	leave  
  80203c:	c3                   	ret    

0080203d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80203d:	55                   	push   %ebp
  80203e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802040:	6a 00                	push   $0x0
  802042:	6a 00                	push   $0x0
  802044:	6a 00                	push   $0x0
  802046:	ff 75 0c             	pushl  0xc(%ebp)
  802049:	ff 75 08             	pushl  0x8(%ebp)
  80204c:	6a 10                	push   $0x10
  80204e:	e8 97 fe ff ff       	call   801eea <syscall>
  802053:	83 c4 18             	add    $0x18,%esp
	return ;
  802056:	90                   	nop
}
  802057:	c9                   	leave  
  802058:	c3                   	ret    

00802059 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802059:	55                   	push   %ebp
  80205a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80205c:	6a 00                	push   $0x0
  80205e:	6a 00                	push   $0x0
  802060:	ff 75 10             	pushl  0x10(%ebp)
  802063:	ff 75 0c             	pushl  0xc(%ebp)
  802066:	ff 75 08             	pushl  0x8(%ebp)
  802069:	6a 11                	push   $0x11
  80206b:	e8 7a fe ff ff       	call   801eea <syscall>
  802070:	83 c4 18             	add    $0x18,%esp
	return ;
  802073:	90                   	nop
}
  802074:	c9                   	leave  
  802075:	c3                   	ret    

00802076 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802076:	55                   	push   %ebp
  802077:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802079:	6a 00                	push   $0x0
  80207b:	6a 00                	push   $0x0
  80207d:	6a 00                	push   $0x0
  80207f:	6a 00                	push   $0x0
  802081:	6a 00                	push   $0x0
  802083:	6a 0c                	push   $0xc
  802085:	e8 60 fe ff ff       	call   801eea <syscall>
  80208a:	83 c4 18             	add    $0x18,%esp
}
  80208d:	c9                   	leave  
  80208e:	c3                   	ret    

0080208f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80208f:	55                   	push   %ebp
  802090:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802092:	6a 00                	push   $0x0
  802094:	6a 00                	push   $0x0
  802096:	6a 00                	push   $0x0
  802098:	6a 00                	push   $0x0
  80209a:	ff 75 08             	pushl  0x8(%ebp)
  80209d:	6a 0d                	push   $0xd
  80209f:	e8 46 fe ff ff       	call   801eea <syscall>
  8020a4:	83 c4 18             	add    $0x18,%esp
}
  8020a7:	c9                   	leave  
  8020a8:	c3                   	ret    

008020a9 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8020a9:	55                   	push   %ebp
  8020aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8020ac:	6a 00                	push   $0x0
  8020ae:	6a 00                	push   $0x0
  8020b0:	6a 00                	push   $0x0
  8020b2:	6a 00                	push   $0x0
  8020b4:	6a 00                	push   $0x0
  8020b6:	6a 0e                	push   $0xe
  8020b8:	e8 2d fe ff ff       	call   801eea <syscall>
  8020bd:	83 c4 18             	add    $0x18,%esp
}
  8020c0:	90                   	nop
  8020c1:	c9                   	leave  
  8020c2:	c3                   	ret    

008020c3 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8020c3:	55                   	push   %ebp
  8020c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8020c6:	6a 00                	push   $0x0
  8020c8:	6a 00                	push   $0x0
  8020ca:	6a 00                	push   $0x0
  8020cc:	6a 00                	push   $0x0
  8020ce:	6a 00                	push   $0x0
  8020d0:	6a 13                	push   $0x13
  8020d2:	e8 13 fe ff ff       	call   801eea <syscall>
  8020d7:	83 c4 18             	add    $0x18,%esp
}
  8020da:	90                   	nop
  8020db:	c9                   	leave  
  8020dc:	c3                   	ret    

008020dd <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8020dd:	55                   	push   %ebp
  8020de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8020e0:	6a 00                	push   $0x0
  8020e2:	6a 00                	push   $0x0
  8020e4:	6a 00                	push   $0x0
  8020e6:	6a 00                	push   $0x0
  8020e8:	6a 00                	push   $0x0
  8020ea:	6a 14                	push   $0x14
  8020ec:	e8 f9 fd ff ff       	call   801eea <syscall>
  8020f1:	83 c4 18             	add    $0x18,%esp
}
  8020f4:	90                   	nop
  8020f5:	c9                   	leave  
  8020f6:	c3                   	ret    

008020f7 <sys_cputc>:


void
sys_cputc(const char c)
{
  8020f7:	55                   	push   %ebp
  8020f8:	89 e5                	mov    %esp,%ebp
  8020fa:	83 ec 04             	sub    $0x4,%esp
  8020fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802100:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802103:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802107:	6a 00                	push   $0x0
  802109:	6a 00                	push   $0x0
  80210b:	6a 00                	push   $0x0
  80210d:	6a 00                	push   $0x0
  80210f:	50                   	push   %eax
  802110:	6a 15                	push   $0x15
  802112:	e8 d3 fd ff ff       	call   801eea <syscall>
  802117:	83 c4 18             	add    $0x18,%esp
}
  80211a:	90                   	nop
  80211b:	c9                   	leave  
  80211c:	c3                   	ret    

0080211d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80211d:	55                   	push   %ebp
  80211e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802120:	6a 00                	push   $0x0
  802122:	6a 00                	push   $0x0
  802124:	6a 00                	push   $0x0
  802126:	6a 00                	push   $0x0
  802128:	6a 00                	push   $0x0
  80212a:	6a 16                	push   $0x16
  80212c:	e8 b9 fd ff ff       	call   801eea <syscall>
  802131:	83 c4 18             	add    $0x18,%esp
}
  802134:	90                   	nop
  802135:	c9                   	leave  
  802136:	c3                   	ret    

00802137 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802137:	55                   	push   %ebp
  802138:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80213a:	8b 45 08             	mov    0x8(%ebp),%eax
  80213d:	6a 00                	push   $0x0
  80213f:	6a 00                	push   $0x0
  802141:	6a 00                	push   $0x0
  802143:	ff 75 0c             	pushl  0xc(%ebp)
  802146:	50                   	push   %eax
  802147:	6a 17                	push   $0x17
  802149:	e8 9c fd ff ff       	call   801eea <syscall>
  80214e:	83 c4 18             	add    $0x18,%esp
}
  802151:	c9                   	leave  
  802152:	c3                   	ret    

00802153 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802153:	55                   	push   %ebp
  802154:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802156:	8b 55 0c             	mov    0xc(%ebp),%edx
  802159:	8b 45 08             	mov    0x8(%ebp),%eax
  80215c:	6a 00                	push   $0x0
  80215e:	6a 00                	push   $0x0
  802160:	6a 00                	push   $0x0
  802162:	52                   	push   %edx
  802163:	50                   	push   %eax
  802164:	6a 1a                	push   $0x1a
  802166:	e8 7f fd ff ff       	call   801eea <syscall>
  80216b:	83 c4 18             	add    $0x18,%esp
}
  80216e:	c9                   	leave  
  80216f:	c3                   	ret    

00802170 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802170:	55                   	push   %ebp
  802171:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802173:	8b 55 0c             	mov    0xc(%ebp),%edx
  802176:	8b 45 08             	mov    0x8(%ebp),%eax
  802179:	6a 00                	push   $0x0
  80217b:	6a 00                	push   $0x0
  80217d:	6a 00                	push   $0x0
  80217f:	52                   	push   %edx
  802180:	50                   	push   %eax
  802181:	6a 18                	push   $0x18
  802183:	e8 62 fd ff ff       	call   801eea <syscall>
  802188:	83 c4 18             	add    $0x18,%esp
}
  80218b:	90                   	nop
  80218c:	c9                   	leave  
  80218d:	c3                   	ret    

0080218e <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80218e:	55                   	push   %ebp
  80218f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802191:	8b 55 0c             	mov    0xc(%ebp),%edx
  802194:	8b 45 08             	mov    0x8(%ebp),%eax
  802197:	6a 00                	push   $0x0
  802199:	6a 00                	push   $0x0
  80219b:	6a 00                	push   $0x0
  80219d:	52                   	push   %edx
  80219e:	50                   	push   %eax
  80219f:	6a 19                	push   $0x19
  8021a1:	e8 44 fd ff ff       	call   801eea <syscall>
  8021a6:	83 c4 18             	add    $0x18,%esp
}
  8021a9:	90                   	nop
  8021aa:	c9                   	leave  
  8021ab:	c3                   	ret    

008021ac <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8021ac:	55                   	push   %ebp
  8021ad:	89 e5                	mov    %esp,%ebp
  8021af:	83 ec 04             	sub    $0x4,%esp
  8021b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8021b5:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8021b8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8021bb:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8021bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c2:	6a 00                	push   $0x0
  8021c4:	51                   	push   %ecx
  8021c5:	52                   	push   %edx
  8021c6:	ff 75 0c             	pushl  0xc(%ebp)
  8021c9:	50                   	push   %eax
  8021ca:	6a 1b                	push   $0x1b
  8021cc:	e8 19 fd ff ff       	call   801eea <syscall>
  8021d1:	83 c4 18             	add    $0x18,%esp
}
  8021d4:	c9                   	leave  
  8021d5:	c3                   	ret    

008021d6 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8021d6:	55                   	push   %ebp
  8021d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8021d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021df:	6a 00                	push   $0x0
  8021e1:	6a 00                	push   $0x0
  8021e3:	6a 00                	push   $0x0
  8021e5:	52                   	push   %edx
  8021e6:	50                   	push   %eax
  8021e7:	6a 1c                	push   $0x1c
  8021e9:	e8 fc fc ff ff       	call   801eea <syscall>
  8021ee:	83 c4 18             	add    $0x18,%esp
}
  8021f1:	c9                   	leave  
  8021f2:	c3                   	ret    

008021f3 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8021f3:	55                   	push   %ebp
  8021f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8021f6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ff:	6a 00                	push   $0x0
  802201:	6a 00                	push   $0x0
  802203:	51                   	push   %ecx
  802204:	52                   	push   %edx
  802205:	50                   	push   %eax
  802206:	6a 1d                	push   $0x1d
  802208:	e8 dd fc ff ff       	call   801eea <syscall>
  80220d:	83 c4 18             	add    $0x18,%esp
}
  802210:	c9                   	leave  
  802211:	c3                   	ret    

00802212 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802212:	55                   	push   %ebp
  802213:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802215:	8b 55 0c             	mov    0xc(%ebp),%edx
  802218:	8b 45 08             	mov    0x8(%ebp),%eax
  80221b:	6a 00                	push   $0x0
  80221d:	6a 00                	push   $0x0
  80221f:	6a 00                	push   $0x0
  802221:	52                   	push   %edx
  802222:	50                   	push   %eax
  802223:	6a 1e                	push   $0x1e
  802225:	e8 c0 fc ff ff       	call   801eea <syscall>
  80222a:	83 c4 18             	add    $0x18,%esp
}
  80222d:	c9                   	leave  
  80222e:	c3                   	ret    

0080222f <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80222f:	55                   	push   %ebp
  802230:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802232:	6a 00                	push   $0x0
  802234:	6a 00                	push   $0x0
  802236:	6a 00                	push   $0x0
  802238:	6a 00                	push   $0x0
  80223a:	6a 00                	push   $0x0
  80223c:	6a 1f                	push   $0x1f
  80223e:	e8 a7 fc ff ff       	call   801eea <syscall>
  802243:	83 c4 18             	add    $0x18,%esp
}
  802246:	c9                   	leave  
  802247:	c3                   	ret    

00802248 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802248:	55                   	push   %ebp
  802249:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80224b:	8b 45 08             	mov    0x8(%ebp),%eax
  80224e:	6a 00                	push   $0x0
  802250:	ff 75 14             	pushl  0x14(%ebp)
  802253:	ff 75 10             	pushl  0x10(%ebp)
  802256:	ff 75 0c             	pushl  0xc(%ebp)
  802259:	50                   	push   %eax
  80225a:	6a 20                	push   $0x20
  80225c:	e8 89 fc ff ff       	call   801eea <syscall>
  802261:	83 c4 18             	add    $0x18,%esp
}
  802264:	c9                   	leave  
  802265:	c3                   	ret    

00802266 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802266:	55                   	push   %ebp
  802267:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802269:	8b 45 08             	mov    0x8(%ebp),%eax
  80226c:	6a 00                	push   $0x0
  80226e:	6a 00                	push   $0x0
  802270:	6a 00                	push   $0x0
  802272:	6a 00                	push   $0x0
  802274:	50                   	push   %eax
  802275:	6a 21                	push   $0x21
  802277:	e8 6e fc ff ff       	call   801eea <syscall>
  80227c:	83 c4 18             	add    $0x18,%esp
}
  80227f:	90                   	nop
  802280:	c9                   	leave  
  802281:	c3                   	ret    

00802282 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802282:	55                   	push   %ebp
  802283:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802285:	8b 45 08             	mov    0x8(%ebp),%eax
  802288:	6a 00                	push   $0x0
  80228a:	6a 00                	push   $0x0
  80228c:	6a 00                	push   $0x0
  80228e:	6a 00                	push   $0x0
  802290:	50                   	push   %eax
  802291:	6a 22                	push   $0x22
  802293:	e8 52 fc ff ff       	call   801eea <syscall>
  802298:	83 c4 18             	add    $0x18,%esp
}
  80229b:	c9                   	leave  
  80229c:	c3                   	ret    

0080229d <sys_getenvid>:

int32 sys_getenvid(void)
{
  80229d:	55                   	push   %ebp
  80229e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8022a0:	6a 00                	push   $0x0
  8022a2:	6a 00                	push   $0x0
  8022a4:	6a 00                	push   $0x0
  8022a6:	6a 00                	push   $0x0
  8022a8:	6a 00                	push   $0x0
  8022aa:	6a 02                	push   $0x2
  8022ac:	e8 39 fc ff ff       	call   801eea <syscall>
  8022b1:	83 c4 18             	add    $0x18,%esp
}
  8022b4:	c9                   	leave  
  8022b5:	c3                   	ret    

008022b6 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8022b6:	55                   	push   %ebp
  8022b7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8022b9:	6a 00                	push   $0x0
  8022bb:	6a 00                	push   $0x0
  8022bd:	6a 00                	push   $0x0
  8022bf:	6a 00                	push   $0x0
  8022c1:	6a 00                	push   $0x0
  8022c3:	6a 03                	push   $0x3
  8022c5:	e8 20 fc ff ff       	call   801eea <syscall>
  8022ca:	83 c4 18             	add    $0x18,%esp
}
  8022cd:	c9                   	leave  
  8022ce:	c3                   	ret    

008022cf <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8022cf:	55                   	push   %ebp
  8022d0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8022d2:	6a 00                	push   $0x0
  8022d4:	6a 00                	push   $0x0
  8022d6:	6a 00                	push   $0x0
  8022d8:	6a 00                	push   $0x0
  8022da:	6a 00                	push   $0x0
  8022dc:	6a 04                	push   $0x4
  8022de:	e8 07 fc ff ff       	call   801eea <syscall>
  8022e3:	83 c4 18             	add    $0x18,%esp
}
  8022e6:	c9                   	leave  
  8022e7:	c3                   	ret    

008022e8 <sys_exit_env>:


void sys_exit_env(void)
{
  8022e8:	55                   	push   %ebp
  8022e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8022eb:	6a 00                	push   $0x0
  8022ed:	6a 00                	push   $0x0
  8022ef:	6a 00                	push   $0x0
  8022f1:	6a 00                	push   $0x0
  8022f3:	6a 00                	push   $0x0
  8022f5:	6a 23                	push   $0x23
  8022f7:	e8 ee fb ff ff       	call   801eea <syscall>
  8022fc:	83 c4 18             	add    $0x18,%esp
}
  8022ff:	90                   	nop
  802300:	c9                   	leave  
  802301:	c3                   	ret    

00802302 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802302:	55                   	push   %ebp
  802303:	89 e5                	mov    %esp,%ebp
  802305:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802308:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80230b:	8d 50 04             	lea    0x4(%eax),%edx
  80230e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802311:	6a 00                	push   $0x0
  802313:	6a 00                	push   $0x0
  802315:	6a 00                	push   $0x0
  802317:	52                   	push   %edx
  802318:	50                   	push   %eax
  802319:	6a 24                	push   $0x24
  80231b:	e8 ca fb ff ff       	call   801eea <syscall>
  802320:	83 c4 18             	add    $0x18,%esp
	return result;
  802323:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802326:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802329:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80232c:	89 01                	mov    %eax,(%ecx)
  80232e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802331:	8b 45 08             	mov    0x8(%ebp),%eax
  802334:	c9                   	leave  
  802335:	c2 04 00             	ret    $0x4

00802338 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802338:	55                   	push   %ebp
  802339:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80233b:	6a 00                	push   $0x0
  80233d:	6a 00                	push   $0x0
  80233f:	ff 75 10             	pushl  0x10(%ebp)
  802342:	ff 75 0c             	pushl  0xc(%ebp)
  802345:	ff 75 08             	pushl  0x8(%ebp)
  802348:	6a 12                	push   $0x12
  80234a:	e8 9b fb ff ff       	call   801eea <syscall>
  80234f:	83 c4 18             	add    $0x18,%esp
	return ;
  802352:	90                   	nop
}
  802353:	c9                   	leave  
  802354:	c3                   	ret    

00802355 <sys_rcr2>:
uint32 sys_rcr2()
{
  802355:	55                   	push   %ebp
  802356:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802358:	6a 00                	push   $0x0
  80235a:	6a 00                	push   $0x0
  80235c:	6a 00                	push   $0x0
  80235e:	6a 00                	push   $0x0
  802360:	6a 00                	push   $0x0
  802362:	6a 25                	push   $0x25
  802364:	e8 81 fb ff ff       	call   801eea <syscall>
  802369:	83 c4 18             	add    $0x18,%esp
}
  80236c:	c9                   	leave  
  80236d:	c3                   	ret    

0080236e <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80236e:	55                   	push   %ebp
  80236f:	89 e5                	mov    %esp,%ebp
  802371:	83 ec 04             	sub    $0x4,%esp
  802374:	8b 45 08             	mov    0x8(%ebp),%eax
  802377:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80237a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80237e:	6a 00                	push   $0x0
  802380:	6a 00                	push   $0x0
  802382:	6a 00                	push   $0x0
  802384:	6a 00                	push   $0x0
  802386:	50                   	push   %eax
  802387:	6a 26                	push   $0x26
  802389:	e8 5c fb ff ff       	call   801eea <syscall>
  80238e:	83 c4 18             	add    $0x18,%esp
	return ;
  802391:	90                   	nop
}
  802392:	c9                   	leave  
  802393:	c3                   	ret    

00802394 <rsttst>:
void rsttst()
{
  802394:	55                   	push   %ebp
  802395:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802397:	6a 00                	push   $0x0
  802399:	6a 00                	push   $0x0
  80239b:	6a 00                	push   $0x0
  80239d:	6a 00                	push   $0x0
  80239f:	6a 00                	push   $0x0
  8023a1:	6a 28                	push   $0x28
  8023a3:	e8 42 fb ff ff       	call   801eea <syscall>
  8023a8:	83 c4 18             	add    $0x18,%esp
	return ;
  8023ab:	90                   	nop
}
  8023ac:	c9                   	leave  
  8023ad:	c3                   	ret    

008023ae <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8023ae:	55                   	push   %ebp
  8023af:	89 e5                	mov    %esp,%ebp
  8023b1:	83 ec 04             	sub    $0x4,%esp
  8023b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8023b7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8023ba:	8b 55 18             	mov    0x18(%ebp),%edx
  8023bd:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8023c1:	52                   	push   %edx
  8023c2:	50                   	push   %eax
  8023c3:	ff 75 10             	pushl  0x10(%ebp)
  8023c6:	ff 75 0c             	pushl  0xc(%ebp)
  8023c9:	ff 75 08             	pushl  0x8(%ebp)
  8023cc:	6a 27                	push   $0x27
  8023ce:	e8 17 fb ff ff       	call   801eea <syscall>
  8023d3:	83 c4 18             	add    $0x18,%esp
	return ;
  8023d6:	90                   	nop
}
  8023d7:	c9                   	leave  
  8023d8:	c3                   	ret    

008023d9 <chktst>:
void chktst(uint32 n)
{
  8023d9:	55                   	push   %ebp
  8023da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8023dc:	6a 00                	push   $0x0
  8023de:	6a 00                	push   $0x0
  8023e0:	6a 00                	push   $0x0
  8023e2:	6a 00                	push   $0x0
  8023e4:	ff 75 08             	pushl  0x8(%ebp)
  8023e7:	6a 29                	push   $0x29
  8023e9:	e8 fc fa ff ff       	call   801eea <syscall>
  8023ee:	83 c4 18             	add    $0x18,%esp
	return ;
  8023f1:	90                   	nop
}
  8023f2:	c9                   	leave  
  8023f3:	c3                   	ret    

008023f4 <inctst>:

void inctst()
{
  8023f4:	55                   	push   %ebp
  8023f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8023f7:	6a 00                	push   $0x0
  8023f9:	6a 00                	push   $0x0
  8023fb:	6a 00                	push   $0x0
  8023fd:	6a 00                	push   $0x0
  8023ff:	6a 00                	push   $0x0
  802401:	6a 2a                	push   $0x2a
  802403:	e8 e2 fa ff ff       	call   801eea <syscall>
  802408:	83 c4 18             	add    $0x18,%esp
	return ;
  80240b:	90                   	nop
}
  80240c:	c9                   	leave  
  80240d:	c3                   	ret    

0080240e <gettst>:
uint32 gettst()
{
  80240e:	55                   	push   %ebp
  80240f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802411:	6a 00                	push   $0x0
  802413:	6a 00                	push   $0x0
  802415:	6a 00                	push   $0x0
  802417:	6a 00                	push   $0x0
  802419:	6a 00                	push   $0x0
  80241b:	6a 2b                	push   $0x2b
  80241d:	e8 c8 fa ff ff       	call   801eea <syscall>
  802422:	83 c4 18             	add    $0x18,%esp
}
  802425:	c9                   	leave  
  802426:	c3                   	ret    

00802427 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802427:	55                   	push   %ebp
  802428:	89 e5                	mov    %esp,%ebp
  80242a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80242d:	6a 00                	push   $0x0
  80242f:	6a 00                	push   $0x0
  802431:	6a 00                	push   $0x0
  802433:	6a 00                	push   $0x0
  802435:	6a 00                	push   $0x0
  802437:	6a 2c                	push   $0x2c
  802439:	e8 ac fa ff ff       	call   801eea <syscall>
  80243e:	83 c4 18             	add    $0x18,%esp
  802441:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802444:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802448:	75 07                	jne    802451 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80244a:	b8 01 00 00 00       	mov    $0x1,%eax
  80244f:	eb 05                	jmp    802456 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802451:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802456:	c9                   	leave  
  802457:	c3                   	ret    

00802458 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802458:	55                   	push   %ebp
  802459:	89 e5                	mov    %esp,%ebp
  80245b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80245e:	6a 00                	push   $0x0
  802460:	6a 00                	push   $0x0
  802462:	6a 00                	push   $0x0
  802464:	6a 00                	push   $0x0
  802466:	6a 00                	push   $0x0
  802468:	6a 2c                	push   $0x2c
  80246a:	e8 7b fa ff ff       	call   801eea <syscall>
  80246f:	83 c4 18             	add    $0x18,%esp
  802472:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802475:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802479:	75 07                	jne    802482 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80247b:	b8 01 00 00 00       	mov    $0x1,%eax
  802480:	eb 05                	jmp    802487 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802482:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802487:	c9                   	leave  
  802488:	c3                   	ret    

00802489 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802489:	55                   	push   %ebp
  80248a:	89 e5                	mov    %esp,%ebp
  80248c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80248f:	6a 00                	push   $0x0
  802491:	6a 00                	push   $0x0
  802493:	6a 00                	push   $0x0
  802495:	6a 00                	push   $0x0
  802497:	6a 00                	push   $0x0
  802499:	6a 2c                	push   $0x2c
  80249b:	e8 4a fa ff ff       	call   801eea <syscall>
  8024a0:	83 c4 18             	add    $0x18,%esp
  8024a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8024a6:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8024aa:	75 07                	jne    8024b3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8024ac:	b8 01 00 00 00       	mov    $0x1,%eax
  8024b1:	eb 05                	jmp    8024b8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8024b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024b8:	c9                   	leave  
  8024b9:	c3                   	ret    

008024ba <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8024ba:	55                   	push   %ebp
  8024bb:	89 e5                	mov    %esp,%ebp
  8024bd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024c0:	6a 00                	push   $0x0
  8024c2:	6a 00                	push   $0x0
  8024c4:	6a 00                	push   $0x0
  8024c6:	6a 00                	push   $0x0
  8024c8:	6a 00                	push   $0x0
  8024ca:	6a 2c                	push   $0x2c
  8024cc:	e8 19 fa ff ff       	call   801eea <syscall>
  8024d1:	83 c4 18             	add    $0x18,%esp
  8024d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8024d7:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8024db:	75 07                	jne    8024e4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8024dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8024e2:	eb 05                	jmp    8024e9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8024e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024e9:	c9                   	leave  
  8024ea:	c3                   	ret    

008024eb <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8024eb:	55                   	push   %ebp
  8024ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8024ee:	6a 00                	push   $0x0
  8024f0:	6a 00                	push   $0x0
  8024f2:	6a 00                	push   $0x0
  8024f4:	6a 00                	push   $0x0
  8024f6:	ff 75 08             	pushl  0x8(%ebp)
  8024f9:	6a 2d                	push   $0x2d
  8024fb:	e8 ea f9 ff ff       	call   801eea <syscall>
  802500:	83 c4 18             	add    $0x18,%esp
	return ;
  802503:	90                   	nop
}
  802504:	c9                   	leave  
  802505:	c3                   	ret    

00802506 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802506:	55                   	push   %ebp
  802507:	89 e5                	mov    %esp,%ebp
  802509:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80250a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80250d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802510:	8b 55 0c             	mov    0xc(%ebp),%edx
  802513:	8b 45 08             	mov    0x8(%ebp),%eax
  802516:	6a 00                	push   $0x0
  802518:	53                   	push   %ebx
  802519:	51                   	push   %ecx
  80251a:	52                   	push   %edx
  80251b:	50                   	push   %eax
  80251c:	6a 2e                	push   $0x2e
  80251e:	e8 c7 f9 ff ff       	call   801eea <syscall>
  802523:	83 c4 18             	add    $0x18,%esp
}
  802526:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802529:	c9                   	leave  
  80252a:	c3                   	ret    

0080252b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80252b:	55                   	push   %ebp
  80252c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80252e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802531:	8b 45 08             	mov    0x8(%ebp),%eax
  802534:	6a 00                	push   $0x0
  802536:	6a 00                	push   $0x0
  802538:	6a 00                	push   $0x0
  80253a:	52                   	push   %edx
  80253b:	50                   	push   %eax
  80253c:	6a 2f                	push   $0x2f
  80253e:	e8 a7 f9 ff ff       	call   801eea <syscall>
  802543:	83 c4 18             	add    $0x18,%esp
}
  802546:	c9                   	leave  
  802547:	c3                   	ret    

00802548 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802548:	55                   	push   %ebp
  802549:	89 e5                	mov    %esp,%ebp
  80254b:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80254e:	83 ec 0c             	sub    $0xc,%esp
  802551:	68 d0 41 80 00       	push   $0x8041d0
  802556:	e8 d9 e4 ff ff       	call   800a34 <cprintf>
  80255b:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80255e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802565:	83 ec 0c             	sub    $0xc,%esp
  802568:	68 fc 41 80 00       	push   $0x8041fc
  80256d:	e8 c2 e4 ff ff       	call   800a34 <cprintf>
  802572:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802575:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802579:	a1 38 51 80 00       	mov    0x805138,%eax
  80257e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802581:	eb 56                	jmp    8025d9 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802583:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802587:	74 1c                	je     8025a5 <print_mem_block_lists+0x5d>
  802589:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258c:	8b 50 08             	mov    0x8(%eax),%edx
  80258f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802592:	8b 48 08             	mov    0x8(%eax),%ecx
  802595:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802598:	8b 40 0c             	mov    0xc(%eax),%eax
  80259b:	01 c8                	add    %ecx,%eax
  80259d:	39 c2                	cmp    %eax,%edx
  80259f:	73 04                	jae    8025a5 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8025a1:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8025a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a8:	8b 50 08             	mov    0x8(%eax),%edx
  8025ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8025b1:	01 c2                	add    %eax,%edx
  8025b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b6:	8b 40 08             	mov    0x8(%eax),%eax
  8025b9:	83 ec 04             	sub    $0x4,%esp
  8025bc:	52                   	push   %edx
  8025bd:	50                   	push   %eax
  8025be:	68 11 42 80 00       	push   $0x804211
  8025c3:	e8 6c e4 ff ff       	call   800a34 <cprintf>
  8025c8:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8025cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8025d1:	a1 40 51 80 00       	mov    0x805140,%eax
  8025d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025dd:	74 07                	je     8025e6 <print_mem_block_lists+0x9e>
  8025df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e2:	8b 00                	mov    (%eax),%eax
  8025e4:	eb 05                	jmp    8025eb <print_mem_block_lists+0xa3>
  8025e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8025eb:	a3 40 51 80 00       	mov    %eax,0x805140
  8025f0:	a1 40 51 80 00       	mov    0x805140,%eax
  8025f5:	85 c0                	test   %eax,%eax
  8025f7:	75 8a                	jne    802583 <print_mem_block_lists+0x3b>
  8025f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025fd:	75 84                	jne    802583 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8025ff:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802603:	75 10                	jne    802615 <print_mem_block_lists+0xcd>
  802605:	83 ec 0c             	sub    $0xc,%esp
  802608:	68 20 42 80 00       	push   $0x804220
  80260d:	e8 22 e4 ff ff       	call   800a34 <cprintf>
  802612:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802615:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80261c:	83 ec 0c             	sub    $0xc,%esp
  80261f:	68 44 42 80 00       	push   $0x804244
  802624:	e8 0b e4 ff ff       	call   800a34 <cprintf>
  802629:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80262c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802630:	a1 40 50 80 00       	mov    0x805040,%eax
  802635:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802638:	eb 56                	jmp    802690 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80263a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80263e:	74 1c                	je     80265c <print_mem_block_lists+0x114>
  802640:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802643:	8b 50 08             	mov    0x8(%eax),%edx
  802646:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802649:	8b 48 08             	mov    0x8(%eax),%ecx
  80264c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80264f:	8b 40 0c             	mov    0xc(%eax),%eax
  802652:	01 c8                	add    %ecx,%eax
  802654:	39 c2                	cmp    %eax,%edx
  802656:	73 04                	jae    80265c <print_mem_block_lists+0x114>
			sorted = 0 ;
  802658:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80265c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265f:	8b 50 08             	mov    0x8(%eax),%edx
  802662:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802665:	8b 40 0c             	mov    0xc(%eax),%eax
  802668:	01 c2                	add    %eax,%edx
  80266a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266d:	8b 40 08             	mov    0x8(%eax),%eax
  802670:	83 ec 04             	sub    $0x4,%esp
  802673:	52                   	push   %edx
  802674:	50                   	push   %eax
  802675:	68 11 42 80 00       	push   $0x804211
  80267a:	e8 b5 e3 ff ff       	call   800a34 <cprintf>
  80267f:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802682:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802685:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802688:	a1 48 50 80 00       	mov    0x805048,%eax
  80268d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802690:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802694:	74 07                	je     80269d <print_mem_block_lists+0x155>
  802696:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802699:	8b 00                	mov    (%eax),%eax
  80269b:	eb 05                	jmp    8026a2 <print_mem_block_lists+0x15a>
  80269d:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a2:	a3 48 50 80 00       	mov    %eax,0x805048
  8026a7:	a1 48 50 80 00       	mov    0x805048,%eax
  8026ac:	85 c0                	test   %eax,%eax
  8026ae:	75 8a                	jne    80263a <print_mem_block_lists+0xf2>
  8026b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026b4:	75 84                	jne    80263a <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8026b6:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8026ba:	75 10                	jne    8026cc <print_mem_block_lists+0x184>
  8026bc:	83 ec 0c             	sub    $0xc,%esp
  8026bf:	68 5c 42 80 00       	push   $0x80425c
  8026c4:	e8 6b e3 ff ff       	call   800a34 <cprintf>
  8026c9:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8026cc:	83 ec 0c             	sub    $0xc,%esp
  8026cf:	68 d0 41 80 00       	push   $0x8041d0
  8026d4:	e8 5b e3 ff ff       	call   800a34 <cprintf>
  8026d9:	83 c4 10             	add    $0x10,%esp

}
  8026dc:	90                   	nop
  8026dd:	c9                   	leave  
  8026de:	c3                   	ret    

008026df <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8026df:	55                   	push   %ebp
  8026e0:	89 e5                	mov    %esp,%ebp
  8026e2:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8026e5:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8026ec:	00 00 00 
  8026ef:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8026f6:	00 00 00 
  8026f9:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802700:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  802703:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80270a:	e9 9e 00 00 00       	jmp    8027ad <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  80270f:	a1 50 50 80 00       	mov    0x805050,%eax
  802714:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802717:	c1 e2 04             	shl    $0x4,%edx
  80271a:	01 d0                	add    %edx,%eax
  80271c:	85 c0                	test   %eax,%eax
  80271e:	75 14                	jne    802734 <initialize_MemBlocksList+0x55>
  802720:	83 ec 04             	sub    $0x4,%esp
  802723:	68 84 42 80 00       	push   $0x804284
  802728:	6a 42                	push   $0x42
  80272a:	68 a7 42 80 00       	push   $0x8042a7
  80272f:	e8 4c e0 ff ff       	call   800780 <_panic>
  802734:	a1 50 50 80 00       	mov    0x805050,%eax
  802739:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80273c:	c1 e2 04             	shl    $0x4,%edx
  80273f:	01 d0                	add    %edx,%eax
  802741:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802747:	89 10                	mov    %edx,(%eax)
  802749:	8b 00                	mov    (%eax),%eax
  80274b:	85 c0                	test   %eax,%eax
  80274d:	74 18                	je     802767 <initialize_MemBlocksList+0x88>
  80274f:	a1 48 51 80 00       	mov    0x805148,%eax
  802754:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80275a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80275d:	c1 e1 04             	shl    $0x4,%ecx
  802760:	01 ca                	add    %ecx,%edx
  802762:	89 50 04             	mov    %edx,0x4(%eax)
  802765:	eb 12                	jmp    802779 <initialize_MemBlocksList+0x9a>
  802767:	a1 50 50 80 00       	mov    0x805050,%eax
  80276c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80276f:	c1 e2 04             	shl    $0x4,%edx
  802772:	01 d0                	add    %edx,%eax
  802774:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802779:	a1 50 50 80 00       	mov    0x805050,%eax
  80277e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802781:	c1 e2 04             	shl    $0x4,%edx
  802784:	01 d0                	add    %edx,%eax
  802786:	a3 48 51 80 00       	mov    %eax,0x805148
  80278b:	a1 50 50 80 00       	mov    0x805050,%eax
  802790:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802793:	c1 e2 04             	shl    $0x4,%edx
  802796:	01 d0                	add    %edx,%eax
  802798:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80279f:	a1 54 51 80 00       	mov    0x805154,%eax
  8027a4:	40                   	inc    %eax
  8027a5:	a3 54 51 80 00       	mov    %eax,0x805154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  8027aa:	ff 45 f4             	incl   -0xc(%ebp)
  8027ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027b3:	0f 82 56 ff ff ff    	jb     80270f <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  8027b9:	90                   	nop
  8027ba:	c9                   	leave  
  8027bb:	c3                   	ret    

008027bc <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8027bc:	55                   	push   %ebp
  8027bd:	89 e5                	mov    %esp,%ebp
  8027bf:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  8027c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c5:	8b 00                	mov    (%eax),%eax
  8027c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8027ca:	eb 19                	jmp    8027e5 <find_block+0x29>
	{
		if(blk->sva==va)
  8027cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027cf:	8b 40 08             	mov    0x8(%eax),%eax
  8027d2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8027d5:	75 05                	jne    8027dc <find_block+0x20>
			return (blk);
  8027d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027da:	eb 36                	jmp    802812 <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  8027dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027df:	8b 40 08             	mov    0x8(%eax),%eax
  8027e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8027e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8027e9:	74 07                	je     8027f2 <find_block+0x36>
  8027eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027ee:	8b 00                	mov    (%eax),%eax
  8027f0:	eb 05                	jmp    8027f7 <find_block+0x3b>
  8027f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8027fa:	89 42 08             	mov    %eax,0x8(%edx)
  8027fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802800:	8b 40 08             	mov    0x8(%eax),%eax
  802803:	85 c0                	test   %eax,%eax
  802805:	75 c5                	jne    8027cc <find_block+0x10>
  802807:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80280b:	75 bf                	jne    8027cc <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  80280d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802812:	c9                   	leave  
  802813:	c3                   	ret    

00802814 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802814:	55                   	push   %ebp
  802815:	89 e5                	mov    %esp,%ebp
  802817:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  80281a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80281f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802822:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  802829:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80282f:	75 65                	jne    802896 <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802831:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802835:	75 14                	jne    80284b <insert_sorted_allocList+0x37>
  802837:	83 ec 04             	sub    $0x4,%esp
  80283a:	68 84 42 80 00       	push   $0x804284
  80283f:	6a 5c                	push   $0x5c
  802841:	68 a7 42 80 00       	push   $0x8042a7
  802846:	e8 35 df ff ff       	call   800780 <_panic>
  80284b:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802851:	8b 45 08             	mov    0x8(%ebp),%eax
  802854:	89 10                	mov    %edx,(%eax)
  802856:	8b 45 08             	mov    0x8(%ebp),%eax
  802859:	8b 00                	mov    (%eax),%eax
  80285b:	85 c0                	test   %eax,%eax
  80285d:	74 0d                	je     80286c <insert_sorted_allocList+0x58>
  80285f:	a1 40 50 80 00       	mov    0x805040,%eax
  802864:	8b 55 08             	mov    0x8(%ebp),%edx
  802867:	89 50 04             	mov    %edx,0x4(%eax)
  80286a:	eb 08                	jmp    802874 <insert_sorted_allocList+0x60>
  80286c:	8b 45 08             	mov    0x8(%ebp),%eax
  80286f:	a3 44 50 80 00       	mov    %eax,0x805044
  802874:	8b 45 08             	mov    0x8(%ebp),%eax
  802877:	a3 40 50 80 00       	mov    %eax,0x805040
  80287c:	8b 45 08             	mov    0x8(%ebp),%eax
  80287f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802886:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80288b:	40                   	inc    %eax
  80288c:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  802891:	e9 7b 01 00 00       	jmp    802a11 <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  802896:	a1 44 50 80 00       	mov    0x805044,%eax
  80289b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  80289e:	a1 40 50 80 00       	mov    0x805040,%eax
  8028a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  8028a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a9:	8b 50 08             	mov    0x8(%eax),%edx
  8028ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028af:	8b 40 08             	mov    0x8(%eax),%eax
  8028b2:	39 c2                	cmp    %eax,%edx
  8028b4:	76 65                	jbe    80291b <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  8028b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028ba:	75 14                	jne    8028d0 <insert_sorted_allocList+0xbc>
  8028bc:	83 ec 04             	sub    $0x4,%esp
  8028bf:	68 c0 42 80 00       	push   $0x8042c0
  8028c4:	6a 64                	push   $0x64
  8028c6:	68 a7 42 80 00       	push   $0x8042a7
  8028cb:	e8 b0 de ff ff       	call   800780 <_panic>
  8028d0:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8028d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d9:	89 50 04             	mov    %edx,0x4(%eax)
  8028dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8028df:	8b 40 04             	mov    0x4(%eax),%eax
  8028e2:	85 c0                	test   %eax,%eax
  8028e4:	74 0c                	je     8028f2 <insert_sorted_allocList+0xde>
  8028e6:	a1 44 50 80 00       	mov    0x805044,%eax
  8028eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8028ee:	89 10                	mov    %edx,(%eax)
  8028f0:	eb 08                	jmp    8028fa <insert_sorted_allocList+0xe6>
  8028f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f5:	a3 40 50 80 00       	mov    %eax,0x805040
  8028fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fd:	a3 44 50 80 00       	mov    %eax,0x805044
  802902:	8b 45 08             	mov    0x8(%ebp),%eax
  802905:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80290b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802910:	40                   	inc    %eax
  802911:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  802916:	e9 f6 00 00 00       	jmp    802a11 <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  80291b:	8b 45 08             	mov    0x8(%ebp),%eax
  80291e:	8b 50 08             	mov    0x8(%eax),%edx
  802921:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802924:	8b 40 08             	mov    0x8(%eax),%eax
  802927:	39 c2                	cmp    %eax,%edx
  802929:	73 65                	jae    802990 <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80292b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80292f:	75 14                	jne    802945 <insert_sorted_allocList+0x131>
  802931:	83 ec 04             	sub    $0x4,%esp
  802934:	68 84 42 80 00       	push   $0x804284
  802939:	6a 68                	push   $0x68
  80293b:	68 a7 42 80 00       	push   $0x8042a7
  802940:	e8 3b de ff ff       	call   800780 <_panic>
  802945:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80294b:	8b 45 08             	mov    0x8(%ebp),%eax
  80294e:	89 10                	mov    %edx,(%eax)
  802950:	8b 45 08             	mov    0x8(%ebp),%eax
  802953:	8b 00                	mov    (%eax),%eax
  802955:	85 c0                	test   %eax,%eax
  802957:	74 0d                	je     802966 <insert_sorted_allocList+0x152>
  802959:	a1 40 50 80 00       	mov    0x805040,%eax
  80295e:	8b 55 08             	mov    0x8(%ebp),%edx
  802961:	89 50 04             	mov    %edx,0x4(%eax)
  802964:	eb 08                	jmp    80296e <insert_sorted_allocList+0x15a>
  802966:	8b 45 08             	mov    0x8(%ebp),%eax
  802969:	a3 44 50 80 00       	mov    %eax,0x805044
  80296e:	8b 45 08             	mov    0x8(%ebp),%eax
  802971:	a3 40 50 80 00       	mov    %eax,0x805040
  802976:	8b 45 08             	mov    0x8(%ebp),%eax
  802979:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802980:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802985:	40                   	inc    %eax
  802986:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  80298b:	e9 81 00 00 00       	jmp    802a11 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802990:	a1 40 50 80 00       	mov    0x805040,%eax
  802995:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802998:	eb 51                	jmp    8029eb <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  80299a:	8b 45 08             	mov    0x8(%ebp),%eax
  80299d:	8b 50 08             	mov    0x8(%eax),%edx
  8029a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a3:	8b 40 08             	mov    0x8(%eax),%eax
  8029a6:	39 c2                	cmp    %eax,%edx
  8029a8:	73 39                	jae    8029e3 <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  8029aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ad:	8b 40 04             	mov    0x4(%eax),%eax
  8029b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  8029b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8029b9:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  8029bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029be:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8029c1:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  8029c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029ca:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  8029cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8029d2:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  8029d5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029da:	40                   	inc    %eax
  8029db:	a3 4c 50 80 00       	mov    %eax,0x80504c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  8029e0:	90                   	nop
				}
			}
		 }

	}
}
  8029e1:	eb 2e                	jmp    802a11 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  8029e3:	a1 48 50 80 00       	mov    0x805048,%eax
  8029e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029ef:	74 07                	je     8029f8 <insert_sorted_allocList+0x1e4>
  8029f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f4:	8b 00                	mov    (%eax),%eax
  8029f6:	eb 05                	jmp    8029fd <insert_sorted_allocList+0x1e9>
  8029f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8029fd:	a3 48 50 80 00       	mov    %eax,0x805048
  802a02:	a1 48 50 80 00       	mov    0x805048,%eax
  802a07:	85 c0                	test   %eax,%eax
  802a09:	75 8f                	jne    80299a <insert_sorted_allocList+0x186>
  802a0b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a0f:	75 89                	jne    80299a <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  802a11:	90                   	nop
  802a12:	c9                   	leave  
  802a13:	c3                   	ret    

00802a14 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802a14:	55                   	push   %ebp
  802a15:	89 e5                	mov    %esp,%ebp
  802a17:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802a1a:	a1 38 51 80 00       	mov    0x805138,%eax
  802a1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a22:	e9 76 01 00 00       	jmp    802b9d <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  802a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2a:	8b 40 0c             	mov    0xc(%eax),%eax
  802a2d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a30:	0f 85 8a 00 00 00    	jne    802ac0 <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  802a36:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a3a:	75 17                	jne    802a53 <alloc_block_FF+0x3f>
  802a3c:	83 ec 04             	sub    $0x4,%esp
  802a3f:	68 e3 42 80 00       	push   $0x8042e3
  802a44:	68 8a 00 00 00       	push   $0x8a
  802a49:	68 a7 42 80 00       	push   $0x8042a7
  802a4e:	e8 2d dd ff ff       	call   800780 <_panic>
  802a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a56:	8b 00                	mov    (%eax),%eax
  802a58:	85 c0                	test   %eax,%eax
  802a5a:	74 10                	je     802a6c <alloc_block_FF+0x58>
  802a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5f:	8b 00                	mov    (%eax),%eax
  802a61:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a64:	8b 52 04             	mov    0x4(%edx),%edx
  802a67:	89 50 04             	mov    %edx,0x4(%eax)
  802a6a:	eb 0b                	jmp    802a77 <alloc_block_FF+0x63>
  802a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6f:	8b 40 04             	mov    0x4(%eax),%eax
  802a72:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7a:	8b 40 04             	mov    0x4(%eax),%eax
  802a7d:	85 c0                	test   %eax,%eax
  802a7f:	74 0f                	je     802a90 <alloc_block_FF+0x7c>
  802a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a84:	8b 40 04             	mov    0x4(%eax),%eax
  802a87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a8a:	8b 12                	mov    (%edx),%edx
  802a8c:	89 10                	mov    %edx,(%eax)
  802a8e:	eb 0a                	jmp    802a9a <alloc_block_FF+0x86>
  802a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a93:	8b 00                	mov    (%eax),%eax
  802a95:	a3 38 51 80 00       	mov    %eax,0x805138
  802a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aad:	a1 44 51 80 00       	mov    0x805144,%eax
  802ab2:	48                   	dec    %eax
  802ab3:	a3 44 51 80 00       	mov    %eax,0x805144
			return element;
  802ab8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abb:	e9 10 01 00 00       	jmp    802bd0 <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  802ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac3:	8b 40 0c             	mov    0xc(%eax),%eax
  802ac6:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ac9:	0f 86 c6 00 00 00    	jbe    802b95 <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802acf:	a1 48 51 80 00       	mov    0x805148,%eax
  802ad4:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802ad7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802adb:	75 17                	jne    802af4 <alloc_block_FF+0xe0>
  802add:	83 ec 04             	sub    $0x4,%esp
  802ae0:	68 e3 42 80 00       	push   $0x8042e3
  802ae5:	68 90 00 00 00       	push   $0x90
  802aea:	68 a7 42 80 00       	push   $0x8042a7
  802aef:	e8 8c dc ff ff       	call   800780 <_panic>
  802af4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af7:	8b 00                	mov    (%eax),%eax
  802af9:	85 c0                	test   %eax,%eax
  802afb:	74 10                	je     802b0d <alloc_block_FF+0xf9>
  802afd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b00:	8b 00                	mov    (%eax),%eax
  802b02:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b05:	8b 52 04             	mov    0x4(%edx),%edx
  802b08:	89 50 04             	mov    %edx,0x4(%eax)
  802b0b:	eb 0b                	jmp    802b18 <alloc_block_FF+0x104>
  802b0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b10:	8b 40 04             	mov    0x4(%eax),%eax
  802b13:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1b:	8b 40 04             	mov    0x4(%eax),%eax
  802b1e:	85 c0                	test   %eax,%eax
  802b20:	74 0f                	je     802b31 <alloc_block_FF+0x11d>
  802b22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b25:	8b 40 04             	mov    0x4(%eax),%eax
  802b28:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b2b:	8b 12                	mov    (%edx),%edx
  802b2d:	89 10                	mov    %edx,(%eax)
  802b2f:	eb 0a                	jmp    802b3b <alloc_block_FF+0x127>
  802b31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b34:	8b 00                	mov    (%eax),%eax
  802b36:	a3 48 51 80 00       	mov    %eax,0x805148
  802b3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b3e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b47:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b4e:	a1 54 51 80 00       	mov    0x805154,%eax
  802b53:	48                   	dec    %eax
  802b54:	a3 54 51 80 00       	mov    %eax,0x805154
			 element1->size =size;
  802b59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5c:	8b 55 08             	mov    0x8(%ebp),%edx
  802b5f:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  802b62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b65:	8b 50 08             	mov    0x8(%eax),%edx
  802b68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6b:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  802b6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b71:	8b 50 08             	mov    0x8(%eax),%edx
  802b74:	8b 45 08             	mov    0x8(%ebp),%eax
  802b77:	01 c2                	add    %eax,%edx
  802b79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7c:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  802b7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b82:	8b 40 0c             	mov    0xc(%eax),%eax
  802b85:	2b 45 08             	sub    0x8(%ebp),%eax
  802b88:	89 c2                	mov    %eax,%edx
  802b8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8d:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  802b90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b93:	eb 3b                	jmp    802bd0 <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802b95:	a1 40 51 80 00       	mov    0x805140,%eax
  802b9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b9d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ba1:	74 07                	je     802baa <alloc_block_FF+0x196>
  802ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba6:	8b 00                	mov    (%eax),%eax
  802ba8:	eb 05                	jmp    802baf <alloc_block_FF+0x19b>
  802baa:	b8 00 00 00 00       	mov    $0x0,%eax
  802baf:	a3 40 51 80 00       	mov    %eax,0x805140
  802bb4:	a1 40 51 80 00       	mov    0x805140,%eax
  802bb9:	85 c0                	test   %eax,%eax
  802bbb:	0f 85 66 fe ff ff    	jne    802a27 <alloc_block_FF+0x13>
  802bc1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bc5:	0f 85 5c fe ff ff    	jne    802a27 <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  802bcb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bd0:	c9                   	leave  
  802bd1:	c3                   	ret    

00802bd2 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802bd2:	55                   	push   %ebp
  802bd3:	89 e5                	mov    %esp,%ebp
  802bd5:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  802bd8:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  802bdf:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  802be6:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802bed:	a1 38 51 80 00       	mov    0x805138,%eax
  802bf2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bf5:	e9 cf 00 00 00       	jmp    802cc9 <alloc_block_BF+0xf7>
		{
			c++;
  802bfa:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  802bfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c00:	8b 40 0c             	mov    0xc(%eax),%eax
  802c03:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c06:	0f 85 8a 00 00 00    	jne    802c96 <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  802c0c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c10:	75 17                	jne    802c29 <alloc_block_BF+0x57>
  802c12:	83 ec 04             	sub    $0x4,%esp
  802c15:	68 e3 42 80 00       	push   $0x8042e3
  802c1a:	68 a8 00 00 00       	push   $0xa8
  802c1f:	68 a7 42 80 00       	push   $0x8042a7
  802c24:	e8 57 db ff ff       	call   800780 <_panic>
  802c29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2c:	8b 00                	mov    (%eax),%eax
  802c2e:	85 c0                	test   %eax,%eax
  802c30:	74 10                	je     802c42 <alloc_block_BF+0x70>
  802c32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c35:	8b 00                	mov    (%eax),%eax
  802c37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c3a:	8b 52 04             	mov    0x4(%edx),%edx
  802c3d:	89 50 04             	mov    %edx,0x4(%eax)
  802c40:	eb 0b                	jmp    802c4d <alloc_block_BF+0x7b>
  802c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c45:	8b 40 04             	mov    0x4(%eax),%eax
  802c48:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c50:	8b 40 04             	mov    0x4(%eax),%eax
  802c53:	85 c0                	test   %eax,%eax
  802c55:	74 0f                	je     802c66 <alloc_block_BF+0x94>
  802c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5a:	8b 40 04             	mov    0x4(%eax),%eax
  802c5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c60:	8b 12                	mov    (%edx),%edx
  802c62:	89 10                	mov    %edx,(%eax)
  802c64:	eb 0a                	jmp    802c70 <alloc_block_BF+0x9e>
  802c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c69:	8b 00                	mov    (%eax),%eax
  802c6b:	a3 38 51 80 00       	mov    %eax,0x805138
  802c70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c73:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c83:	a1 44 51 80 00       	mov    0x805144,%eax
  802c88:	48                   	dec    %eax
  802c89:	a3 44 51 80 00       	mov    %eax,0x805144
				return block;
  802c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c91:	e9 85 01 00 00       	jmp    802e1b <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  802c96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c99:	8b 40 0c             	mov    0xc(%eax),%eax
  802c9c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c9f:	76 20                	jbe    802cc1 <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  802ca1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca7:	2b 45 08             	sub    0x8(%ebp),%eax
  802caa:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  802cad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cb0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802cb3:	73 0c                	jae    802cc1 <alloc_block_BF+0xef>
				{
					ma=tempi;
  802cb5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  802cbb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cbe:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802cc1:	a1 40 51 80 00       	mov    0x805140,%eax
  802cc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cc9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ccd:	74 07                	je     802cd6 <alloc_block_BF+0x104>
  802ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd2:	8b 00                	mov    (%eax),%eax
  802cd4:	eb 05                	jmp    802cdb <alloc_block_BF+0x109>
  802cd6:	b8 00 00 00 00       	mov    $0x0,%eax
  802cdb:	a3 40 51 80 00       	mov    %eax,0x805140
  802ce0:	a1 40 51 80 00       	mov    0x805140,%eax
  802ce5:	85 c0                	test   %eax,%eax
  802ce7:	0f 85 0d ff ff ff    	jne    802bfa <alloc_block_BF+0x28>
  802ced:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cf1:	0f 85 03 ff ff ff    	jne    802bfa <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  802cf7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802cfe:	a1 38 51 80 00       	mov    0x805138,%eax
  802d03:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d06:	e9 dd 00 00 00       	jmp    802de8 <alloc_block_BF+0x216>
		{
			if(x==sol)
  802d0b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d0e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802d11:	0f 85 c6 00 00 00    	jne    802ddd <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802d17:	a1 48 51 80 00       	mov    0x805148,%eax
  802d1c:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802d1f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802d23:	75 17                	jne    802d3c <alloc_block_BF+0x16a>
  802d25:	83 ec 04             	sub    $0x4,%esp
  802d28:	68 e3 42 80 00       	push   $0x8042e3
  802d2d:	68 bb 00 00 00       	push   $0xbb
  802d32:	68 a7 42 80 00       	push   $0x8042a7
  802d37:	e8 44 da ff ff       	call   800780 <_panic>
  802d3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d3f:	8b 00                	mov    (%eax),%eax
  802d41:	85 c0                	test   %eax,%eax
  802d43:	74 10                	je     802d55 <alloc_block_BF+0x183>
  802d45:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d48:	8b 00                	mov    (%eax),%eax
  802d4a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d4d:	8b 52 04             	mov    0x4(%edx),%edx
  802d50:	89 50 04             	mov    %edx,0x4(%eax)
  802d53:	eb 0b                	jmp    802d60 <alloc_block_BF+0x18e>
  802d55:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d58:	8b 40 04             	mov    0x4(%eax),%eax
  802d5b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d60:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d63:	8b 40 04             	mov    0x4(%eax),%eax
  802d66:	85 c0                	test   %eax,%eax
  802d68:	74 0f                	je     802d79 <alloc_block_BF+0x1a7>
  802d6a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d6d:	8b 40 04             	mov    0x4(%eax),%eax
  802d70:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d73:	8b 12                	mov    (%edx),%edx
  802d75:	89 10                	mov    %edx,(%eax)
  802d77:	eb 0a                	jmp    802d83 <alloc_block_BF+0x1b1>
  802d79:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d7c:	8b 00                	mov    (%eax),%eax
  802d7e:	a3 48 51 80 00       	mov    %eax,0x805148
  802d83:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d86:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d8f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d96:	a1 54 51 80 00       	mov    0x805154,%eax
  802d9b:	48                   	dec    %eax
  802d9c:	a3 54 51 80 00       	mov    %eax,0x805154
						 element1->size =size;
  802da1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802da4:	8b 55 08             	mov    0x8(%ebp),%edx
  802da7:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  802daa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dad:	8b 50 08             	mov    0x8(%eax),%edx
  802db0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802db3:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  802db6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db9:	8b 50 08             	mov    0x8(%eax),%edx
  802dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbf:	01 c2                	add    %eax,%edx
  802dc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc4:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  802dc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dca:	8b 40 0c             	mov    0xc(%eax),%eax
  802dcd:	2b 45 08             	sub    0x8(%ebp),%eax
  802dd0:	89 c2                	mov    %eax,%edx
  802dd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd5:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  802dd8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ddb:	eb 3e                	jmp    802e1b <alloc_block_BF+0x249>
						 break;
			}
			x++;
  802ddd:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802de0:	a1 40 51 80 00       	mov    0x805140,%eax
  802de5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802de8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dec:	74 07                	je     802df5 <alloc_block_BF+0x223>
  802dee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df1:	8b 00                	mov    (%eax),%eax
  802df3:	eb 05                	jmp    802dfa <alloc_block_BF+0x228>
  802df5:	b8 00 00 00 00       	mov    $0x0,%eax
  802dfa:	a3 40 51 80 00       	mov    %eax,0x805140
  802dff:	a1 40 51 80 00       	mov    0x805140,%eax
  802e04:	85 c0                	test   %eax,%eax
  802e06:	0f 85 ff fe ff ff    	jne    802d0b <alloc_block_BF+0x139>
  802e0c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e10:	0f 85 f5 fe ff ff    	jne    802d0b <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  802e16:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e1b:	c9                   	leave  
  802e1c:	c3                   	ret    

00802e1d <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802e1d:	55                   	push   %ebp
  802e1e:	89 e5                	mov    %esp,%ebp
  802e20:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  802e23:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e28:	85 c0                	test   %eax,%eax
  802e2a:	75 14                	jne    802e40 <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  802e2c:	a1 38 51 80 00       	mov    0x805138,%eax
  802e31:	a3 60 51 80 00       	mov    %eax,0x805160
		hh=1;
  802e36:	c7 05 2c 50 80 00 01 	movl   $0x1,0x80502c
  802e3d:	00 00 00 
	}
	uint32 c=1;
  802e40:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  802e47:	a1 60 51 80 00       	mov    0x805160,%eax
  802e4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802e4f:	e9 b3 01 00 00       	jmp    803007 <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  802e54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e57:	8b 40 0c             	mov    0xc(%eax),%eax
  802e5a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e5d:	0f 85 a9 00 00 00    	jne    802f0c <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  802e63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e66:	8b 00                	mov    (%eax),%eax
  802e68:	85 c0                	test   %eax,%eax
  802e6a:	75 0c                	jne    802e78 <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  802e6c:	a1 38 51 80 00       	mov    0x805138,%eax
  802e71:	a3 60 51 80 00       	mov    %eax,0x805160
  802e76:	eb 0a                	jmp    802e82 <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  802e78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e7b:	8b 00                	mov    (%eax),%eax
  802e7d:	a3 60 51 80 00       	mov    %eax,0x805160
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  802e82:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e86:	75 17                	jne    802e9f <alloc_block_NF+0x82>
  802e88:	83 ec 04             	sub    $0x4,%esp
  802e8b:	68 e3 42 80 00       	push   $0x8042e3
  802e90:	68 e3 00 00 00       	push   $0xe3
  802e95:	68 a7 42 80 00       	push   $0x8042a7
  802e9a:	e8 e1 d8 ff ff       	call   800780 <_panic>
  802e9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea2:	8b 00                	mov    (%eax),%eax
  802ea4:	85 c0                	test   %eax,%eax
  802ea6:	74 10                	je     802eb8 <alloc_block_NF+0x9b>
  802ea8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eab:	8b 00                	mov    (%eax),%eax
  802ead:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802eb0:	8b 52 04             	mov    0x4(%edx),%edx
  802eb3:	89 50 04             	mov    %edx,0x4(%eax)
  802eb6:	eb 0b                	jmp    802ec3 <alloc_block_NF+0xa6>
  802eb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ebb:	8b 40 04             	mov    0x4(%eax),%eax
  802ebe:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ec3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec6:	8b 40 04             	mov    0x4(%eax),%eax
  802ec9:	85 c0                	test   %eax,%eax
  802ecb:	74 0f                	je     802edc <alloc_block_NF+0xbf>
  802ecd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed0:	8b 40 04             	mov    0x4(%eax),%eax
  802ed3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ed6:	8b 12                	mov    (%edx),%edx
  802ed8:	89 10                	mov    %edx,(%eax)
  802eda:	eb 0a                	jmp    802ee6 <alloc_block_NF+0xc9>
  802edc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802edf:	8b 00                	mov    (%eax),%eax
  802ee1:	a3 38 51 80 00       	mov    %eax,0x805138
  802ee6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ef9:	a1 44 51 80 00       	mov    0x805144,%eax
  802efe:	48                   	dec    %eax
  802eff:	a3 44 51 80 00       	mov    %eax,0x805144
				return element;
  802f04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f07:	e9 0e 01 00 00       	jmp    80301a <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  802f0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f0f:	8b 40 0c             	mov    0xc(%eax),%eax
  802f12:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f15:	0f 86 ce 00 00 00    	jbe    802fe9 <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802f1b:	a1 48 51 80 00       	mov    0x805148,%eax
  802f20:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802f23:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f27:	75 17                	jne    802f40 <alloc_block_NF+0x123>
  802f29:	83 ec 04             	sub    $0x4,%esp
  802f2c:	68 e3 42 80 00       	push   $0x8042e3
  802f31:	68 e9 00 00 00       	push   $0xe9
  802f36:	68 a7 42 80 00       	push   $0x8042a7
  802f3b:	e8 40 d8 ff ff       	call   800780 <_panic>
  802f40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f43:	8b 00                	mov    (%eax),%eax
  802f45:	85 c0                	test   %eax,%eax
  802f47:	74 10                	je     802f59 <alloc_block_NF+0x13c>
  802f49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f4c:	8b 00                	mov    (%eax),%eax
  802f4e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f51:	8b 52 04             	mov    0x4(%edx),%edx
  802f54:	89 50 04             	mov    %edx,0x4(%eax)
  802f57:	eb 0b                	jmp    802f64 <alloc_block_NF+0x147>
  802f59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f5c:	8b 40 04             	mov    0x4(%eax),%eax
  802f5f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f67:	8b 40 04             	mov    0x4(%eax),%eax
  802f6a:	85 c0                	test   %eax,%eax
  802f6c:	74 0f                	je     802f7d <alloc_block_NF+0x160>
  802f6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f71:	8b 40 04             	mov    0x4(%eax),%eax
  802f74:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f77:	8b 12                	mov    (%edx),%edx
  802f79:	89 10                	mov    %edx,(%eax)
  802f7b:	eb 0a                	jmp    802f87 <alloc_block_NF+0x16a>
  802f7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f80:	8b 00                	mov    (%eax),%eax
  802f82:	a3 48 51 80 00       	mov    %eax,0x805148
  802f87:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f8a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f93:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f9a:	a1 54 51 80 00       	mov    0x805154,%eax
  802f9f:	48                   	dec    %eax
  802fa0:	a3 54 51 80 00       	mov    %eax,0x805154
				 element1->size =size;
  802fa5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fa8:	8b 55 08             	mov    0x8(%ebp),%edx
  802fab:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  802fae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb1:	8b 50 08             	mov    0x8(%eax),%edx
  802fb4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fb7:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  802fba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fbd:	8b 50 08             	mov    0x8(%eax),%edx
  802fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc3:	01 c2                	add    %eax,%edx
  802fc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc8:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  802fcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fce:	8b 40 0c             	mov    0xc(%eax),%eax
  802fd1:	2b 45 08             	sub    0x8(%ebp),%eax
  802fd4:	89 c2                	mov    %eax,%edx
  802fd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fd9:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  802fdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fdf:	a3 60 51 80 00       	mov    %eax,0x805160
				 return element1;
  802fe4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fe7:	eb 31                	jmp    80301a <alloc_block_NF+0x1fd>
			 }
		 c++;
  802fe9:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  802fec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fef:	8b 00                	mov    (%eax),%eax
  802ff1:	85 c0                	test   %eax,%eax
  802ff3:	75 0a                	jne    802fff <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  802ff5:	a1 38 51 80 00       	mov    0x805138,%eax
  802ffa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802ffd:	eb 08                	jmp    803007 <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  802fff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803002:	8b 00                	mov    (%eax),%eax
  803004:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  803007:	a1 44 51 80 00       	mov    0x805144,%eax
  80300c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80300f:	0f 85 3f fe ff ff    	jne    802e54 <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  803015:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80301a:	c9                   	leave  
  80301b:	c3                   	ret    

0080301c <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80301c:	55                   	push   %ebp
  80301d:	89 e5                	mov    %esp,%ebp
  80301f:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  803022:	a1 44 51 80 00       	mov    0x805144,%eax
  803027:	85 c0                	test   %eax,%eax
  803029:	75 68                	jne    803093 <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  80302b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80302f:	75 17                	jne    803048 <insert_sorted_with_merge_freeList+0x2c>
  803031:	83 ec 04             	sub    $0x4,%esp
  803034:	68 84 42 80 00       	push   $0x804284
  803039:	68 0e 01 00 00       	push   $0x10e
  80303e:	68 a7 42 80 00       	push   $0x8042a7
  803043:	e8 38 d7 ff ff       	call   800780 <_panic>
  803048:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80304e:	8b 45 08             	mov    0x8(%ebp),%eax
  803051:	89 10                	mov    %edx,(%eax)
  803053:	8b 45 08             	mov    0x8(%ebp),%eax
  803056:	8b 00                	mov    (%eax),%eax
  803058:	85 c0                	test   %eax,%eax
  80305a:	74 0d                	je     803069 <insert_sorted_with_merge_freeList+0x4d>
  80305c:	a1 38 51 80 00       	mov    0x805138,%eax
  803061:	8b 55 08             	mov    0x8(%ebp),%edx
  803064:	89 50 04             	mov    %edx,0x4(%eax)
  803067:	eb 08                	jmp    803071 <insert_sorted_with_merge_freeList+0x55>
  803069:	8b 45 08             	mov    0x8(%ebp),%eax
  80306c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803071:	8b 45 08             	mov    0x8(%ebp),%eax
  803074:	a3 38 51 80 00       	mov    %eax,0x805138
  803079:	8b 45 08             	mov    0x8(%ebp),%eax
  80307c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803083:	a1 44 51 80 00       	mov    0x805144,%eax
  803088:	40                   	inc    %eax
  803089:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  80308e:	e9 8c 06 00 00       	jmp    80371f <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  803093:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803098:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  80309b:	a1 38 51 80 00       	mov    0x805138,%eax
  8030a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  8030a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a6:	8b 50 08             	mov    0x8(%eax),%edx
  8030a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ac:	8b 40 08             	mov    0x8(%eax),%eax
  8030af:	39 c2                	cmp    %eax,%edx
  8030b1:	0f 86 14 01 00 00    	jbe    8031cb <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  8030b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ba:	8b 50 0c             	mov    0xc(%eax),%edx
  8030bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030c0:	8b 40 08             	mov    0x8(%eax),%eax
  8030c3:	01 c2                	add    %eax,%edx
  8030c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c8:	8b 40 08             	mov    0x8(%eax),%eax
  8030cb:	39 c2                	cmp    %eax,%edx
  8030cd:	0f 85 90 00 00 00    	jne    803163 <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  8030d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030d6:	8b 50 0c             	mov    0xc(%eax),%edx
  8030d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8030df:	01 c2                	add    %eax,%edx
  8030e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e4:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  8030e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ea:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  8030f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8030fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030ff:	75 17                	jne    803118 <insert_sorted_with_merge_freeList+0xfc>
  803101:	83 ec 04             	sub    $0x4,%esp
  803104:	68 84 42 80 00       	push   $0x804284
  803109:	68 1b 01 00 00       	push   $0x11b
  80310e:	68 a7 42 80 00       	push   $0x8042a7
  803113:	e8 68 d6 ff ff       	call   800780 <_panic>
  803118:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80311e:	8b 45 08             	mov    0x8(%ebp),%eax
  803121:	89 10                	mov    %edx,(%eax)
  803123:	8b 45 08             	mov    0x8(%ebp),%eax
  803126:	8b 00                	mov    (%eax),%eax
  803128:	85 c0                	test   %eax,%eax
  80312a:	74 0d                	je     803139 <insert_sorted_with_merge_freeList+0x11d>
  80312c:	a1 48 51 80 00       	mov    0x805148,%eax
  803131:	8b 55 08             	mov    0x8(%ebp),%edx
  803134:	89 50 04             	mov    %edx,0x4(%eax)
  803137:	eb 08                	jmp    803141 <insert_sorted_with_merge_freeList+0x125>
  803139:	8b 45 08             	mov    0x8(%ebp),%eax
  80313c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803141:	8b 45 08             	mov    0x8(%ebp),%eax
  803144:	a3 48 51 80 00       	mov    %eax,0x805148
  803149:	8b 45 08             	mov    0x8(%ebp),%eax
  80314c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803153:	a1 54 51 80 00       	mov    0x805154,%eax
  803158:	40                   	inc    %eax
  803159:	a3 54 51 80 00       	mov    %eax,0x805154
							}

						}
		          }
		}
}
  80315e:	e9 bc 05 00 00       	jmp    80371f <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803163:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803167:	75 17                	jne    803180 <insert_sorted_with_merge_freeList+0x164>
  803169:	83 ec 04             	sub    $0x4,%esp
  80316c:	68 c0 42 80 00       	push   $0x8042c0
  803171:	68 1f 01 00 00       	push   $0x11f
  803176:	68 a7 42 80 00       	push   $0x8042a7
  80317b:	e8 00 d6 ff ff       	call   800780 <_panic>
  803180:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803186:	8b 45 08             	mov    0x8(%ebp),%eax
  803189:	89 50 04             	mov    %edx,0x4(%eax)
  80318c:	8b 45 08             	mov    0x8(%ebp),%eax
  80318f:	8b 40 04             	mov    0x4(%eax),%eax
  803192:	85 c0                	test   %eax,%eax
  803194:	74 0c                	je     8031a2 <insert_sorted_with_merge_freeList+0x186>
  803196:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80319b:	8b 55 08             	mov    0x8(%ebp),%edx
  80319e:	89 10                	mov    %edx,(%eax)
  8031a0:	eb 08                	jmp    8031aa <insert_sorted_with_merge_freeList+0x18e>
  8031a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a5:	a3 38 51 80 00       	mov    %eax,0x805138
  8031aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ad:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031bb:	a1 44 51 80 00       	mov    0x805144,%eax
  8031c0:	40                   	inc    %eax
  8031c1:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  8031c6:	e9 54 05 00 00       	jmp    80371f <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  8031cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ce:	8b 50 08             	mov    0x8(%eax),%edx
  8031d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031d4:	8b 40 08             	mov    0x8(%eax),%eax
  8031d7:	39 c2                	cmp    %eax,%edx
  8031d9:	0f 83 20 01 00 00    	jae    8032ff <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  8031df:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e2:	8b 50 0c             	mov    0xc(%eax),%edx
  8031e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e8:	8b 40 08             	mov    0x8(%eax),%eax
  8031eb:	01 c2                	add    %eax,%edx
  8031ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031f0:	8b 40 08             	mov    0x8(%eax),%eax
  8031f3:	39 c2                	cmp    %eax,%edx
  8031f5:	0f 85 9c 00 00 00    	jne    803297 <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  8031fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fe:	8b 50 08             	mov    0x8(%eax),%edx
  803201:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803204:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  803207:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80320a:	8b 50 0c             	mov    0xc(%eax),%edx
  80320d:	8b 45 08             	mov    0x8(%ebp),%eax
  803210:	8b 40 0c             	mov    0xc(%eax),%eax
  803213:	01 c2                	add    %eax,%edx
  803215:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803218:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  80321b:	8b 45 08             	mov    0x8(%ebp),%eax
  80321e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  803225:	8b 45 08             	mov    0x8(%ebp),%eax
  803228:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80322f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803233:	75 17                	jne    80324c <insert_sorted_with_merge_freeList+0x230>
  803235:	83 ec 04             	sub    $0x4,%esp
  803238:	68 84 42 80 00       	push   $0x804284
  80323d:	68 2a 01 00 00       	push   $0x12a
  803242:	68 a7 42 80 00       	push   $0x8042a7
  803247:	e8 34 d5 ff ff       	call   800780 <_panic>
  80324c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803252:	8b 45 08             	mov    0x8(%ebp),%eax
  803255:	89 10                	mov    %edx,(%eax)
  803257:	8b 45 08             	mov    0x8(%ebp),%eax
  80325a:	8b 00                	mov    (%eax),%eax
  80325c:	85 c0                	test   %eax,%eax
  80325e:	74 0d                	je     80326d <insert_sorted_with_merge_freeList+0x251>
  803260:	a1 48 51 80 00       	mov    0x805148,%eax
  803265:	8b 55 08             	mov    0x8(%ebp),%edx
  803268:	89 50 04             	mov    %edx,0x4(%eax)
  80326b:	eb 08                	jmp    803275 <insert_sorted_with_merge_freeList+0x259>
  80326d:	8b 45 08             	mov    0x8(%ebp),%eax
  803270:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803275:	8b 45 08             	mov    0x8(%ebp),%eax
  803278:	a3 48 51 80 00       	mov    %eax,0x805148
  80327d:	8b 45 08             	mov    0x8(%ebp),%eax
  803280:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803287:	a1 54 51 80 00       	mov    0x805154,%eax
  80328c:	40                   	inc    %eax
  80328d:	a3 54 51 80 00       	mov    %eax,0x805154
							}

						}
		          }
		}
}
  803292:	e9 88 04 00 00       	jmp    80371f <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  803297:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80329b:	75 17                	jne    8032b4 <insert_sorted_with_merge_freeList+0x298>
  80329d:	83 ec 04             	sub    $0x4,%esp
  8032a0:	68 84 42 80 00       	push   $0x804284
  8032a5:	68 2e 01 00 00       	push   $0x12e
  8032aa:	68 a7 42 80 00       	push   $0x8042a7
  8032af:	e8 cc d4 ff ff       	call   800780 <_panic>
  8032b4:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8032ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bd:	89 10                	mov    %edx,(%eax)
  8032bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c2:	8b 00                	mov    (%eax),%eax
  8032c4:	85 c0                	test   %eax,%eax
  8032c6:	74 0d                	je     8032d5 <insert_sorted_with_merge_freeList+0x2b9>
  8032c8:	a1 38 51 80 00       	mov    0x805138,%eax
  8032cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8032d0:	89 50 04             	mov    %edx,0x4(%eax)
  8032d3:	eb 08                	jmp    8032dd <insert_sorted_with_merge_freeList+0x2c1>
  8032d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e0:	a3 38 51 80 00       	mov    %eax,0x805138
  8032e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032ef:	a1 44 51 80 00       	mov    0x805144,%eax
  8032f4:	40                   	inc    %eax
  8032f5:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  8032fa:	e9 20 04 00 00       	jmp    80371f <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  8032ff:	a1 38 51 80 00       	mov    0x805138,%eax
  803304:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803307:	e9 e2 03 00 00       	jmp    8036ee <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  80330c:	8b 45 08             	mov    0x8(%ebp),%eax
  80330f:	8b 50 08             	mov    0x8(%eax),%edx
  803312:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803315:	8b 40 08             	mov    0x8(%eax),%eax
  803318:	39 c2                	cmp    %eax,%edx
  80331a:	0f 83 c6 03 00 00    	jae    8036e6 <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  803320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803323:	8b 40 04             	mov    0x4(%eax),%eax
  803326:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  803329:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80332c:	8b 50 08             	mov    0x8(%eax),%edx
  80332f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803332:	8b 40 0c             	mov    0xc(%eax),%eax
  803335:	01 d0                	add    %edx,%eax
  803337:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  80333a:	8b 45 08             	mov    0x8(%ebp),%eax
  80333d:	8b 50 0c             	mov    0xc(%eax),%edx
  803340:	8b 45 08             	mov    0x8(%ebp),%eax
  803343:	8b 40 08             	mov    0x8(%eax),%eax
  803346:	01 d0                	add    %edx,%eax
  803348:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  80334b:	8b 45 08             	mov    0x8(%ebp),%eax
  80334e:	8b 40 08             	mov    0x8(%eax),%eax
  803351:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803354:	74 7a                	je     8033d0 <insert_sorted_with_merge_freeList+0x3b4>
  803356:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803359:	8b 40 08             	mov    0x8(%eax),%eax
  80335c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80335f:	74 6f                	je     8033d0 <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  803361:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803365:	74 06                	je     80336d <insert_sorted_with_merge_freeList+0x351>
  803367:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80336b:	75 17                	jne    803384 <insert_sorted_with_merge_freeList+0x368>
  80336d:	83 ec 04             	sub    $0x4,%esp
  803370:	68 04 43 80 00       	push   $0x804304
  803375:	68 43 01 00 00       	push   $0x143
  80337a:	68 a7 42 80 00       	push   $0x8042a7
  80337f:	e8 fc d3 ff ff       	call   800780 <_panic>
  803384:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803387:	8b 50 04             	mov    0x4(%eax),%edx
  80338a:	8b 45 08             	mov    0x8(%ebp),%eax
  80338d:	89 50 04             	mov    %edx,0x4(%eax)
  803390:	8b 45 08             	mov    0x8(%ebp),%eax
  803393:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803396:	89 10                	mov    %edx,(%eax)
  803398:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339b:	8b 40 04             	mov    0x4(%eax),%eax
  80339e:	85 c0                	test   %eax,%eax
  8033a0:	74 0d                	je     8033af <insert_sorted_with_merge_freeList+0x393>
  8033a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a5:	8b 40 04             	mov    0x4(%eax),%eax
  8033a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8033ab:	89 10                	mov    %edx,(%eax)
  8033ad:	eb 08                	jmp    8033b7 <insert_sorted_with_merge_freeList+0x39b>
  8033af:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b2:	a3 38 51 80 00       	mov    %eax,0x805138
  8033b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8033bd:	89 50 04             	mov    %edx,0x4(%eax)
  8033c0:	a1 44 51 80 00       	mov    0x805144,%eax
  8033c5:	40                   	inc    %eax
  8033c6:	a3 44 51 80 00       	mov    %eax,0x805144
  8033cb:	e9 14 03 00 00       	jmp    8036e4 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  8033d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d3:	8b 40 08             	mov    0x8(%eax),%eax
  8033d6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8033d9:	0f 85 a0 01 00 00    	jne    80357f <insert_sorted_with_merge_freeList+0x563>
  8033df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e2:	8b 40 08             	mov    0x8(%eax),%eax
  8033e5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8033e8:	0f 85 91 01 00 00    	jne    80357f <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  8033ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f1:	8b 50 0c             	mov    0xc(%eax),%edx
  8033f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f7:	8b 48 0c             	mov    0xc(%eax),%ecx
  8033fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033fd:	8b 40 0c             	mov    0xc(%eax),%eax
  803400:	01 c8                	add    %ecx,%eax
  803402:	01 c2                	add    %eax,%edx
  803404:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803407:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  80340a:	8b 45 08             	mov    0x8(%ebp),%eax
  80340d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  803414:	8b 45 08             	mov    0x8(%ebp),%eax
  803417:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  80341e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803421:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  803428:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80342b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803432:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803436:	75 17                	jne    80344f <insert_sorted_with_merge_freeList+0x433>
  803438:	83 ec 04             	sub    $0x4,%esp
  80343b:	68 84 42 80 00       	push   $0x804284
  803440:	68 4d 01 00 00       	push   $0x14d
  803445:	68 a7 42 80 00       	push   $0x8042a7
  80344a:	e8 31 d3 ff ff       	call   800780 <_panic>
  80344f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803455:	8b 45 08             	mov    0x8(%ebp),%eax
  803458:	89 10                	mov    %edx,(%eax)
  80345a:	8b 45 08             	mov    0x8(%ebp),%eax
  80345d:	8b 00                	mov    (%eax),%eax
  80345f:	85 c0                	test   %eax,%eax
  803461:	74 0d                	je     803470 <insert_sorted_with_merge_freeList+0x454>
  803463:	a1 48 51 80 00       	mov    0x805148,%eax
  803468:	8b 55 08             	mov    0x8(%ebp),%edx
  80346b:	89 50 04             	mov    %edx,0x4(%eax)
  80346e:	eb 08                	jmp    803478 <insert_sorted_with_merge_freeList+0x45c>
  803470:	8b 45 08             	mov    0x8(%ebp),%eax
  803473:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803478:	8b 45 08             	mov    0x8(%ebp),%eax
  80347b:	a3 48 51 80 00       	mov    %eax,0x805148
  803480:	8b 45 08             	mov    0x8(%ebp),%eax
  803483:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80348a:	a1 54 51 80 00       	mov    0x805154,%eax
  80348f:	40                   	inc    %eax
  803490:	a3 54 51 80 00       	mov    %eax,0x805154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  803495:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803499:	75 17                	jne    8034b2 <insert_sorted_with_merge_freeList+0x496>
  80349b:	83 ec 04             	sub    $0x4,%esp
  80349e:	68 e3 42 80 00       	push   $0x8042e3
  8034a3:	68 4e 01 00 00       	push   $0x14e
  8034a8:	68 a7 42 80 00       	push   $0x8042a7
  8034ad:	e8 ce d2 ff ff       	call   800780 <_panic>
  8034b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b5:	8b 00                	mov    (%eax),%eax
  8034b7:	85 c0                	test   %eax,%eax
  8034b9:	74 10                	je     8034cb <insert_sorted_with_merge_freeList+0x4af>
  8034bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034be:	8b 00                	mov    (%eax),%eax
  8034c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034c3:	8b 52 04             	mov    0x4(%edx),%edx
  8034c6:	89 50 04             	mov    %edx,0x4(%eax)
  8034c9:	eb 0b                	jmp    8034d6 <insert_sorted_with_merge_freeList+0x4ba>
  8034cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ce:	8b 40 04             	mov    0x4(%eax),%eax
  8034d1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d9:	8b 40 04             	mov    0x4(%eax),%eax
  8034dc:	85 c0                	test   %eax,%eax
  8034de:	74 0f                	je     8034ef <insert_sorted_with_merge_freeList+0x4d3>
  8034e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e3:	8b 40 04             	mov    0x4(%eax),%eax
  8034e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034e9:	8b 12                	mov    (%edx),%edx
  8034eb:	89 10                	mov    %edx,(%eax)
  8034ed:	eb 0a                	jmp    8034f9 <insert_sorted_with_merge_freeList+0x4dd>
  8034ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f2:	8b 00                	mov    (%eax),%eax
  8034f4:	a3 38 51 80 00       	mov    %eax,0x805138
  8034f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034fc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803502:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803505:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80350c:	a1 44 51 80 00       	mov    0x805144,%eax
  803511:	48                   	dec    %eax
  803512:	a3 44 51 80 00       	mov    %eax,0x805144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  803517:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80351b:	75 17                	jne    803534 <insert_sorted_with_merge_freeList+0x518>
  80351d:	83 ec 04             	sub    $0x4,%esp
  803520:	68 84 42 80 00       	push   $0x804284
  803525:	68 4f 01 00 00       	push   $0x14f
  80352a:	68 a7 42 80 00       	push   $0x8042a7
  80352f:	e8 4c d2 ff ff       	call   800780 <_panic>
  803534:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80353a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80353d:	89 10                	mov    %edx,(%eax)
  80353f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803542:	8b 00                	mov    (%eax),%eax
  803544:	85 c0                	test   %eax,%eax
  803546:	74 0d                	je     803555 <insert_sorted_with_merge_freeList+0x539>
  803548:	a1 48 51 80 00       	mov    0x805148,%eax
  80354d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803550:	89 50 04             	mov    %edx,0x4(%eax)
  803553:	eb 08                	jmp    80355d <insert_sorted_with_merge_freeList+0x541>
  803555:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803558:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80355d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803560:	a3 48 51 80 00       	mov    %eax,0x805148
  803565:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803568:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80356f:	a1 54 51 80 00       	mov    0x805154,%eax
  803574:	40                   	inc    %eax
  803575:	a3 54 51 80 00       	mov    %eax,0x805154
  80357a:	e9 65 01 00 00       	jmp    8036e4 <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  80357f:	8b 45 08             	mov    0x8(%ebp),%eax
  803582:	8b 40 08             	mov    0x8(%eax),%eax
  803585:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803588:	0f 85 9f 00 00 00    	jne    80362d <insert_sorted_with_merge_freeList+0x611>
  80358e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803591:	8b 40 08             	mov    0x8(%eax),%eax
  803594:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803597:	0f 84 90 00 00 00    	je     80362d <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  80359d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035a0:	8b 50 0c             	mov    0xc(%eax),%edx
  8035a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8035a9:	01 c2                	add    %eax,%edx
  8035ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035ae:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  8035b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  8035bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8035be:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8035c5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035c9:	75 17                	jne    8035e2 <insert_sorted_with_merge_freeList+0x5c6>
  8035cb:	83 ec 04             	sub    $0x4,%esp
  8035ce:	68 84 42 80 00       	push   $0x804284
  8035d3:	68 58 01 00 00       	push   $0x158
  8035d8:	68 a7 42 80 00       	push   $0x8042a7
  8035dd:	e8 9e d1 ff ff       	call   800780 <_panic>
  8035e2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035eb:	89 10                	mov    %edx,(%eax)
  8035ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f0:	8b 00                	mov    (%eax),%eax
  8035f2:	85 c0                	test   %eax,%eax
  8035f4:	74 0d                	je     803603 <insert_sorted_with_merge_freeList+0x5e7>
  8035f6:	a1 48 51 80 00       	mov    0x805148,%eax
  8035fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8035fe:	89 50 04             	mov    %edx,0x4(%eax)
  803601:	eb 08                	jmp    80360b <insert_sorted_with_merge_freeList+0x5ef>
  803603:	8b 45 08             	mov    0x8(%ebp),%eax
  803606:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80360b:	8b 45 08             	mov    0x8(%ebp),%eax
  80360e:	a3 48 51 80 00       	mov    %eax,0x805148
  803613:	8b 45 08             	mov    0x8(%ebp),%eax
  803616:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80361d:	a1 54 51 80 00       	mov    0x805154,%eax
  803622:	40                   	inc    %eax
  803623:	a3 54 51 80 00       	mov    %eax,0x805154
  803628:	e9 b7 00 00 00       	jmp    8036e4 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  80362d:	8b 45 08             	mov    0x8(%ebp),%eax
  803630:	8b 40 08             	mov    0x8(%eax),%eax
  803633:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803636:	0f 84 e2 00 00 00    	je     80371e <insert_sorted_with_merge_freeList+0x702>
  80363c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80363f:	8b 40 08             	mov    0x8(%eax),%eax
  803642:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803645:	0f 85 d3 00 00 00    	jne    80371e <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  80364b:	8b 45 08             	mov    0x8(%ebp),%eax
  80364e:	8b 50 08             	mov    0x8(%eax),%edx
  803651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803654:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  803657:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80365a:	8b 50 0c             	mov    0xc(%eax),%edx
  80365d:	8b 45 08             	mov    0x8(%ebp),%eax
  803660:	8b 40 0c             	mov    0xc(%eax),%eax
  803663:	01 c2                	add    %eax,%edx
  803665:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803668:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  80366b:	8b 45 08             	mov    0x8(%ebp),%eax
  80366e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  803675:	8b 45 08             	mov    0x8(%ebp),%eax
  803678:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80367f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803683:	75 17                	jne    80369c <insert_sorted_with_merge_freeList+0x680>
  803685:	83 ec 04             	sub    $0x4,%esp
  803688:	68 84 42 80 00       	push   $0x804284
  80368d:	68 61 01 00 00       	push   $0x161
  803692:	68 a7 42 80 00       	push   $0x8042a7
  803697:	e8 e4 d0 ff ff       	call   800780 <_panic>
  80369c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8036a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a5:	89 10                	mov    %edx,(%eax)
  8036a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8036aa:	8b 00                	mov    (%eax),%eax
  8036ac:	85 c0                	test   %eax,%eax
  8036ae:	74 0d                	je     8036bd <insert_sorted_with_merge_freeList+0x6a1>
  8036b0:	a1 48 51 80 00       	mov    0x805148,%eax
  8036b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8036b8:	89 50 04             	mov    %edx,0x4(%eax)
  8036bb:	eb 08                	jmp    8036c5 <insert_sorted_with_merge_freeList+0x6a9>
  8036bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c8:	a3 48 51 80 00       	mov    %eax,0x805148
  8036cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036d7:	a1 54 51 80 00       	mov    0x805154,%eax
  8036dc:	40                   	inc    %eax
  8036dd:	a3 54 51 80 00       	mov    %eax,0x805154
								}
								break;
  8036e2:	eb 3a                	jmp    80371e <insert_sorted_with_merge_freeList+0x702>
  8036e4:	eb 38                	jmp    80371e <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  8036e6:	a1 40 51 80 00       	mov    0x805140,%eax
  8036eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036f2:	74 07                	je     8036fb <insert_sorted_with_merge_freeList+0x6df>
  8036f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f7:	8b 00                	mov    (%eax),%eax
  8036f9:	eb 05                	jmp    803700 <insert_sorted_with_merge_freeList+0x6e4>
  8036fb:	b8 00 00 00 00       	mov    $0x0,%eax
  803700:	a3 40 51 80 00       	mov    %eax,0x805140
  803705:	a1 40 51 80 00       	mov    0x805140,%eax
  80370a:	85 c0                	test   %eax,%eax
  80370c:	0f 85 fa fb ff ff    	jne    80330c <insert_sorted_with_merge_freeList+0x2f0>
  803712:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803716:	0f 85 f0 fb ff ff    	jne    80330c <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  80371c:	eb 01                	jmp    80371f <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  80371e:	90                   	nop
							}

						}
		          }
		}
}
  80371f:	90                   	nop
  803720:	c9                   	leave  
  803721:	c3                   	ret    
  803722:	66 90                	xchg   %ax,%ax

00803724 <__udivdi3>:
  803724:	55                   	push   %ebp
  803725:	57                   	push   %edi
  803726:	56                   	push   %esi
  803727:	53                   	push   %ebx
  803728:	83 ec 1c             	sub    $0x1c,%esp
  80372b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80372f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803733:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803737:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80373b:	89 ca                	mov    %ecx,%edx
  80373d:	89 f8                	mov    %edi,%eax
  80373f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803743:	85 f6                	test   %esi,%esi
  803745:	75 2d                	jne    803774 <__udivdi3+0x50>
  803747:	39 cf                	cmp    %ecx,%edi
  803749:	77 65                	ja     8037b0 <__udivdi3+0x8c>
  80374b:	89 fd                	mov    %edi,%ebp
  80374d:	85 ff                	test   %edi,%edi
  80374f:	75 0b                	jne    80375c <__udivdi3+0x38>
  803751:	b8 01 00 00 00       	mov    $0x1,%eax
  803756:	31 d2                	xor    %edx,%edx
  803758:	f7 f7                	div    %edi
  80375a:	89 c5                	mov    %eax,%ebp
  80375c:	31 d2                	xor    %edx,%edx
  80375e:	89 c8                	mov    %ecx,%eax
  803760:	f7 f5                	div    %ebp
  803762:	89 c1                	mov    %eax,%ecx
  803764:	89 d8                	mov    %ebx,%eax
  803766:	f7 f5                	div    %ebp
  803768:	89 cf                	mov    %ecx,%edi
  80376a:	89 fa                	mov    %edi,%edx
  80376c:	83 c4 1c             	add    $0x1c,%esp
  80376f:	5b                   	pop    %ebx
  803770:	5e                   	pop    %esi
  803771:	5f                   	pop    %edi
  803772:	5d                   	pop    %ebp
  803773:	c3                   	ret    
  803774:	39 ce                	cmp    %ecx,%esi
  803776:	77 28                	ja     8037a0 <__udivdi3+0x7c>
  803778:	0f bd fe             	bsr    %esi,%edi
  80377b:	83 f7 1f             	xor    $0x1f,%edi
  80377e:	75 40                	jne    8037c0 <__udivdi3+0x9c>
  803780:	39 ce                	cmp    %ecx,%esi
  803782:	72 0a                	jb     80378e <__udivdi3+0x6a>
  803784:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803788:	0f 87 9e 00 00 00    	ja     80382c <__udivdi3+0x108>
  80378e:	b8 01 00 00 00       	mov    $0x1,%eax
  803793:	89 fa                	mov    %edi,%edx
  803795:	83 c4 1c             	add    $0x1c,%esp
  803798:	5b                   	pop    %ebx
  803799:	5e                   	pop    %esi
  80379a:	5f                   	pop    %edi
  80379b:	5d                   	pop    %ebp
  80379c:	c3                   	ret    
  80379d:	8d 76 00             	lea    0x0(%esi),%esi
  8037a0:	31 ff                	xor    %edi,%edi
  8037a2:	31 c0                	xor    %eax,%eax
  8037a4:	89 fa                	mov    %edi,%edx
  8037a6:	83 c4 1c             	add    $0x1c,%esp
  8037a9:	5b                   	pop    %ebx
  8037aa:	5e                   	pop    %esi
  8037ab:	5f                   	pop    %edi
  8037ac:	5d                   	pop    %ebp
  8037ad:	c3                   	ret    
  8037ae:	66 90                	xchg   %ax,%ax
  8037b0:	89 d8                	mov    %ebx,%eax
  8037b2:	f7 f7                	div    %edi
  8037b4:	31 ff                	xor    %edi,%edi
  8037b6:	89 fa                	mov    %edi,%edx
  8037b8:	83 c4 1c             	add    $0x1c,%esp
  8037bb:	5b                   	pop    %ebx
  8037bc:	5e                   	pop    %esi
  8037bd:	5f                   	pop    %edi
  8037be:	5d                   	pop    %ebp
  8037bf:	c3                   	ret    
  8037c0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8037c5:	89 eb                	mov    %ebp,%ebx
  8037c7:	29 fb                	sub    %edi,%ebx
  8037c9:	89 f9                	mov    %edi,%ecx
  8037cb:	d3 e6                	shl    %cl,%esi
  8037cd:	89 c5                	mov    %eax,%ebp
  8037cf:	88 d9                	mov    %bl,%cl
  8037d1:	d3 ed                	shr    %cl,%ebp
  8037d3:	89 e9                	mov    %ebp,%ecx
  8037d5:	09 f1                	or     %esi,%ecx
  8037d7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8037db:	89 f9                	mov    %edi,%ecx
  8037dd:	d3 e0                	shl    %cl,%eax
  8037df:	89 c5                	mov    %eax,%ebp
  8037e1:	89 d6                	mov    %edx,%esi
  8037e3:	88 d9                	mov    %bl,%cl
  8037e5:	d3 ee                	shr    %cl,%esi
  8037e7:	89 f9                	mov    %edi,%ecx
  8037e9:	d3 e2                	shl    %cl,%edx
  8037eb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037ef:	88 d9                	mov    %bl,%cl
  8037f1:	d3 e8                	shr    %cl,%eax
  8037f3:	09 c2                	or     %eax,%edx
  8037f5:	89 d0                	mov    %edx,%eax
  8037f7:	89 f2                	mov    %esi,%edx
  8037f9:	f7 74 24 0c          	divl   0xc(%esp)
  8037fd:	89 d6                	mov    %edx,%esi
  8037ff:	89 c3                	mov    %eax,%ebx
  803801:	f7 e5                	mul    %ebp
  803803:	39 d6                	cmp    %edx,%esi
  803805:	72 19                	jb     803820 <__udivdi3+0xfc>
  803807:	74 0b                	je     803814 <__udivdi3+0xf0>
  803809:	89 d8                	mov    %ebx,%eax
  80380b:	31 ff                	xor    %edi,%edi
  80380d:	e9 58 ff ff ff       	jmp    80376a <__udivdi3+0x46>
  803812:	66 90                	xchg   %ax,%ax
  803814:	8b 54 24 08          	mov    0x8(%esp),%edx
  803818:	89 f9                	mov    %edi,%ecx
  80381a:	d3 e2                	shl    %cl,%edx
  80381c:	39 c2                	cmp    %eax,%edx
  80381e:	73 e9                	jae    803809 <__udivdi3+0xe5>
  803820:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803823:	31 ff                	xor    %edi,%edi
  803825:	e9 40 ff ff ff       	jmp    80376a <__udivdi3+0x46>
  80382a:	66 90                	xchg   %ax,%ax
  80382c:	31 c0                	xor    %eax,%eax
  80382e:	e9 37 ff ff ff       	jmp    80376a <__udivdi3+0x46>
  803833:	90                   	nop

00803834 <__umoddi3>:
  803834:	55                   	push   %ebp
  803835:	57                   	push   %edi
  803836:	56                   	push   %esi
  803837:	53                   	push   %ebx
  803838:	83 ec 1c             	sub    $0x1c,%esp
  80383b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80383f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803843:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803847:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80384b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80384f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803853:	89 f3                	mov    %esi,%ebx
  803855:	89 fa                	mov    %edi,%edx
  803857:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80385b:	89 34 24             	mov    %esi,(%esp)
  80385e:	85 c0                	test   %eax,%eax
  803860:	75 1a                	jne    80387c <__umoddi3+0x48>
  803862:	39 f7                	cmp    %esi,%edi
  803864:	0f 86 a2 00 00 00    	jbe    80390c <__umoddi3+0xd8>
  80386a:	89 c8                	mov    %ecx,%eax
  80386c:	89 f2                	mov    %esi,%edx
  80386e:	f7 f7                	div    %edi
  803870:	89 d0                	mov    %edx,%eax
  803872:	31 d2                	xor    %edx,%edx
  803874:	83 c4 1c             	add    $0x1c,%esp
  803877:	5b                   	pop    %ebx
  803878:	5e                   	pop    %esi
  803879:	5f                   	pop    %edi
  80387a:	5d                   	pop    %ebp
  80387b:	c3                   	ret    
  80387c:	39 f0                	cmp    %esi,%eax
  80387e:	0f 87 ac 00 00 00    	ja     803930 <__umoddi3+0xfc>
  803884:	0f bd e8             	bsr    %eax,%ebp
  803887:	83 f5 1f             	xor    $0x1f,%ebp
  80388a:	0f 84 ac 00 00 00    	je     80393c <__umoddi3+0x108>
  803890:	bf 20 00 00 00       	mov    $0x20,%edi
  803895:	29 ef                	sub    %ebp,%edi
  803897:	89 fe                	mov    %edi,%esi
  803899:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80389d:	89 e9                	mov    %ebp,%ecx
  80389f:	d3 e0                	shl    %cl,%eax
  8038a1:	89 d7                	mov    %edx,%edi
  8038a3:	89 f1                	mov    %esi,%ecx
  8038a5:	d3 ef                	shr    %cl,%edi
  8038a7:	09 c7                	or     %eax,%edi
  8038a9:	89 e9                	mov    %ebp,%ecx
  8038ab:	d3 e2                	shl    %cl,%edx
  8038ad:	89 14 24             	mov    %edx,(%esp)
  8038b0:	89 d8                	mov    %ebx,%eax
  8038b2:	d3 e0                	shl    %cl,%eax
  8038b4:	89 c2                	mov    %eax,%edx
  8038b6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038ba:	d3 e0                	shl    %cl,%eax
  8038bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8038c0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038c4:	89 f1                	mov    %esi,%ecx
  8038c6:	d3 e8                	shr    %cl,%eax
  8038c8:	09 d0                	or     %edx,%eax
  8038ca:	d3 eb                	shr    %cl,%ebx
  8038cc:	89 da                	mov    %ebx,%edx
  8038ce:	f7 f7                	div    %edi
  8038d0:	89 d3                	mov    %edx,%ebx
  8038d2:	f7 24 24             	mull   (%esp)
  8038d5:	89 c6                	mov    %eax,%esi
  8038d7:	89 d1                	mov    %edx,%ecx
  8038d9:	39 d3                	cmp    %edx,%ebx
  8038db:	0f 82 87 00 00 00    	jb     803968 <__umoddi3+0x134>
  8038e1:	0f 84 91 00 00 00    	je     803978 <__umoddi3+0x144>
  8038e7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8038eb:	29 f2                	sub    %esi,%edx
  8038ed:	19 cb                	sbb    %ecx,%ebx
  8038ef:	89 d8                	mov    %ebx,%eax
  8038f1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8038f5:	d3 e0                	shl    %cl,%eax
  8038f7:	89 e9                	mov    %ebp,%ecx
  8038f9:	d3 ea                	shr    %cl,%edx
  8038fb:	09 d0                	or     %edx,%eax
  8038fd:	89 e9                	mov    %ebp,%ecx
  8038ff:	d3 eb                	shr    %cl,%ebx
  803901:	89 da                	mov    %ebx,%edx
  803903:	83 c4 1c             	add    $0x1c,%esp
  803906:	5b                   	pop    %ebx
  803907:	5e                   	pop    %esi
  803908:	5f                   	pop    %edi
  803909:	5d                   	pop    %ebp
  80390a:	c3                   	ret    
  80390b:	90                   	nop
  80390c:	89 fd                	mov    %edi,%ebp
  80390e:	85 ff                	test   %edi,%edi
  803910:	75 0b                	jne    80391d <__umoddi3+0xe9>
  803912:	b8 01 00 00 00       	mov    $0x1,%eax
  803917:	31 d2                	xor    %edx,%edx
  803919:	f7 f7                	div    %edi
  80391b:	89 c5                	mov    %eax,%ebp
  80391d:	89 f0                	mov    %esi,%eax
  80391f:	31 d2                	xor    %edx,%edx
  803921:	f7 f5                	div    %ebp
  803923:	89 c8                	mov    %ecx,%eax
  803925:	f7 f5                	div    %ebp
  803927:	89 d0                	mov    %edx,%eax
  803929:	e9 44 ff ff ff       	jmp    803872 <__umoddi3+0x3e>
  80392e:	66 90                	xchg   %ax,%ax
  803930:	89 c8                	mov    %ecx,%eax
  803932:	89 f2                	mov    %esi,%edx
  803934:	83 c4 1c             	add    $0x1c,%esp
  803937:	5b                   	pop    %ebx
  803938:	5e                   	pop    %esi
  803939:	5f                   	pop    %edi
  80393a:	5d                   	pop    %ebp
  80393b:	c3                   	ret    
  80393c:	3b 04 24             	cmp    (%esp),%eax
  80393f:	72 06                	jb     803947 <__umoddi3+0x113>
  803941:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803945:	77 0f                	ja     803956 <__umoddi3+0x122>
  803947:	89 f2                	mov    %esi,%edx
  803949:	29 f9                	sub    %edi,%ecx
  80394b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80394f:	89 14 24             	mov    %edx,(%esp)
  803952:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803956:	8b 44 24 04          	mov    0x4(%esp),%eax
  80395a:	8b 14 24             	mov    (%esp),%edx
  80395d:	83 c4 1c             	add    $0x1c,%esp
  803960:	5b                   	pop    %ebx
  803961:	5e                   	pop    %esi
  803962:	5f                   	pop    %edi
  803963:	5d                   	pop    %ebp
  803964:	c3                   	ret    
  803965:	8d 76 00             	lea    0x0(%esi),%esi
  803968:	2b 04 24             	sub    (%esp),%eax
  80396b:	19 fa                	sbb    %edi,%edx
  80396d:	89 d1                	mov    %edx,%ecx
  80396f:	89 c6                	mov    %eax,%esi
  803971:	e9 71 ff ff ff       	jmp    8038e7 <__umoddi3+0xb3>
  803976:	66 90                	xchg   %ax,%ax
  803978:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80397c:	72 ea                	jb     803968 <__umoddi3+0x134>
  80397e:	89 d9                	mov    %ebx,%ecx
  803980:	e9 62 ff ff ff       	jmp    8038e7 <__umoddi3+0xb3>

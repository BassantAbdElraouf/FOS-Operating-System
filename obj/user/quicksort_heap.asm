
obj/user/quicksort_heap:     file format elf32-i386


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
  800031:	e8 1f 06 00 00       	call   800655 <libmain>
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
  800041:	e8 8e 20 00 00       	call   8020d4 <sys_disable_interrupt>
		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 a0 39 80 00       	push   $0x8039a0
  80004e:	e8 f2 09 00 00       	call   800a45 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 a2 39 80 00       	push   $0x8039a2
  80005e:	e8 e2 09 00 00       	call   800a45 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   QUICK SORT   !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 bb 39 80 00       	push   $0x8039bb
  80006e:	e8 d2 09 00 00       	call   800a45 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 a2 39 80 00       	push   $0x8039a2
  80007e:	e8 c2 09 00 00       	call   800a45 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 a0 39 80 00       	push   $0x8039a0
  80008e:	e8 b2 09 00 00       	call   800a45 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 d4 39 80 00       	push   $0x8039d4
  8000a5:	e8 1d 10 00 00       	call   8010c7 <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 6d 15 00 00       	call   80162d <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 a5 1a 00 00       	call   801b7a <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 f4 39 80 00       	push   $0x8039f4
  8000e3:	e8 5d 09 00 00       	call   800a45 <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 16 3a 80 00       	push   $0x803a16
  8000f3:	e8 4d 09 00 00       	call   800a45 <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 24 3a 80 00       	push   $0x803a24
  800103:	e8 3d 09 00 00       	call   800a45 <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 33 3a 80 00       	push   $0x803a33
  800113:	e8 2d 09 00 00       	call   800a45 <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 43 3a 80 00       	push   $0x803a43
  800123:	e8 1d 09 00 00       	call   800a45 <cprintf>
  800128:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012b:	e8 cd 04 00 00       	call   8005fd <getchar>
  800130:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  800133:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	50                   	push   %eax
  80013b:	e8 75 04 00 00       	call   8005b5 <cputchar>
  800140:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	6a 0a                	push   $0xa
  800148:	e8 68 04 00 00       	call   8005b5 <cputchar>
  80014d:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800150:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  800154:	74 0c                	je     800162 <_main+0x12a>
  800156:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  80015a:	74 06                	je     800162 <_main+0x12a>
  80015c:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800160:	75 b9                	jne    80011b <_main+0xe3>
		//2012: lock the interrupt
		sys_enable_interrupt();
  800162:	e8 87 1f 00 00       	call   8020ee <sys_enable_interrupt>

		int  i ;
		switch (Chose)
  800167:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
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
  80017d:	ff 75 f0             	pushl  -0x10(%ebp)
  800180:	ff 75 ec             	pushl  -0x14(%ebp)
  800183:	e8 f5 02 00 00       	call   80047d <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 13 03 00 00       	call   8004ae <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 35 03 00 00       	call   8004e3 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 22 03 00 00       	call   8004e3 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cd:	e8 f0 00 00 00       	call   8002c2 <QuickSort>
  8001d2:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001d5:	e8 fa 1e 00 00       	call   8020d4 <sys_disable_interrupt>
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 4c 3a 80 00       	push   $0x803a4c
  8001e2:	e8 5e 08 00 00       	call   800a45 <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
		//		PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ea:	e8 ff 1e 00 00       	call   8020ee <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001ef:	83 ec 08             	sub    $0x8,%esp
  8001f2:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f5:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f8:	e8 d6 01 00 00       	call   8003d3 <CheckSorted>
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800203:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800207:	75 14                	jne    80021d <_main+0x1e5>
  800209:	83 ec 04             	sub    $0x4,%esp
  80020c:	68 80 3a 80 00       	push   $0x803a80
  800211:	6a 48                	push   $0x48
  800213:	68 a2 3a 80 00       	push   $0x803aa2
  800218:	e8 74 05 00 00       	call   800791 <_panic>
		else
		{
			sys_disable_interrupt();
  80021d:	e8 b2 1e 00 00       	call   8020d4 <sys_disable_interrupt>
			cprintf("\n===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 b8 3a 80 00       	push   $0x803ab8
  80022a:	e8 16 08 00 00       	call   800a45 <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 ec 3a 80 00       	push   $0x803aec
  80023a:	e8 06 08 00 00       	call   800a45 <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 20 3b 80 00       	push   $0x803b20
  80024a:	e8 f6 07 00 00       	call   800a45 <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800252:	e8 97 1e 00 00       	call   8020ee <sys_enable_interrupt>
		}

		sys_disable_interrupt();
  800257:	e8 78 1e 00 00       	call   8020d4 <sys_disable_interrupt>
			Chose = 0 ;
  80025c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800260:	eb 42                	jmp    8002a4 <_main+0x26c>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800262:	83 ec 0c             	sub    $0xc,%esp
  800265:	68 52 3b 80 00       	push   $0x803b52
  80026a:	e8 d6 07 00 00       	call   800a45 <cprintf>
  80026f:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800272:	e8 86 03 00 00       	call   8005fd <getchar>
  800277:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80027a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80027e:	83 ec 0c             	sub    $0xc,%esp
  800281:	50                   	push   %eax
  800282:	e8 2e 03 00 00       	call   8005b5 <cputchar>
  800287:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80028a:	83 ec 0c             	sub    $0xc,%esp
  80028d:	6a 0a                	push   $0xa
  80028f:	e8 21 03 00 00       	call   8005b5 <cputchar>
  800294:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800297:	83 ec 0c             	sub    $0xc,%esp
  80029a:	6a 0a                	push   $0xa
  80029c:	e8 14 03 00 00       	call   8005b5 <cputchar>
  8002a1:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
		}

		sys_disable_interrupt();
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002a4:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002a8:	74 06                	je     8002b0 <_main+0x278>
  8002aa:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002ae:	75 b2                	jne    800262 <_main+0x22a>
				Chose = getchar() ;
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		sys_enable_interrupt();
  8002b0:	e8 39 1e 00 00       	call   8020ee <sys_enable_interrupt>

	} while (Chose == 'y');
  8002b5:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002b9:	0f 84 82 fd ff ff    	je     800041 <_main+0x9>

}
  8002bf:	90                   	nop
  8002c0:	c9                   	leave  
  8002c1:	c3                   	ret    

008002c2 <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  8002c2:	55                   	push   %ebp
  8002c3:	89 e5                	mov    %esp,%ebp
  8002c5:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  8002c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002cb:	48                   	dec    %eax
  8002cc:	50                   	push   %eax
  8002cd:	6a 00                	push   $0x0
  8002cf:	ff 75 0c             	pushl  0xc(%ebp)
  8002d2:	ff 75 08             	pushl  0x8(%ebp)
  8002d5:	e8 06 00 00 00       	call   8002e0 <QSort>
  8002da:	83 c4 10             	add    $0x10,%esp
}
  8002dd:	90                   	nop
  8002de:	c9                   	leave  
  8002df:	c3                   	ret    

008002e0 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  8002e0:	55                   	push   %ebp
  8002e1:	89 e5                	mov    %esp,%ebp
  8002e3:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8002e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002e9:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002ec:	0f 8d de 00 00 00    	jge    8003d0 <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  8002f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8002f5:	40                   	inc    %eax
  8002f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8002f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8002fc:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  8002ff:	e9 80 00 00 00       	jmp    800384 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800304:	ff 45 f4             	incl   -0xc(%ebp)
  800307:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80030a:	3b 45 14             	cmp    0x14(%ebp),%eax
  80030d:	7f 2b                	jg     80033a <QSort+0x5a>
  80030f:	8b 45 10             	mov    0x10(%ebp),%eax
  800312:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800319:	8b 45 08             	mov    0x8(%ebp),%eax
  80031c:	01 d0                	add    %edx,%eax
  80031e:	8b 10                	mov    (%eax),%edx
  800320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800323:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80032a:	8b 45 08             	mov    0x8(%ebp),%eax
  80032d:	01 c8                	add    %ecx,%eax
  80032f:	8b 00                	mov    (%eax),%eax
  800331:	39 c2                	cmp    %eax,%edx
  800333:	7d cf                	jge    800304 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  800335:	eb 03                	jmp    80033a <QSort+0x5a>
  800337:	ff 4d f0             	decl   -0x10(%ebp)
  80033a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80033d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800340:	7e 26                	jle    800368 <QSort+0x88>
  800342:	8b 45 10             	mov    0x10(%ebp),%eax
  800345:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80034c:	8b 45 08             	mov    0x8(%ebp),%eax
  80034f:	01 d0                	add    %edx,%eax
  800351:	8b 10                	mov    (%eax),%edx
  800353:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800356:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80035d:	8b 45 08             	mov    0x8(%ebp),%eax
  800360:	01 c8                	add    %ecx,%eax
  800362:	8b 00                	mov    (%eax),%eax
  800364:	39 c2                	cmp    %eax,%edx
  800366:	7e cf                	jle    800337 <QSort+0x57>

		if (i <= j)
  800368:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80036b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80036e:	7f 14                	jg     800384 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  800370:	83 ec 04             	sub    $0x4,%esp
  800373:	ff 75 f0             	pushl  -0x10(%ebp)
  800376:	ff 75 f4             	pushl  -0xc(%ebp)
  800379:	ff 75 08             	pushl  0x8(%ebp)
  80037c:	e8 a9 00 00 00       	call   80042a <Swap>
  800381:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800384:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800387:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80038a:	0f 8e 77 ff ff ff    	jle    800307 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  800390:	83 ec 04             	sub    $0x4,%esp
  800393:	ff 75 f0             	pushl  -0x10(%ebp)
  800396:	ff 75 10             	pushl  0x10(%ebp)
  800399:	ff 75 08             	pushl  0x8(%ebp)
  80039c:	e8 89 00 00 00       	call   80042a <Swap>
  8003a1:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  8003a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003a7:	48                   	dec    %eax
  8003a8:	50                   	push   %eax
  8003a9:	ff 75 10             	pushl  0x10(%ebp)
  8003ac:	ff 75 0c             	pushl  0xc(%ebp)
  8003af:	ff 75 08             	pushl  0x8(%ebp)
  8003b2:	e8 29 ff ff ff       	call   8002e0 <QSort>
  8003b7:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  8003ba:	ff 75 14             	pushl  0x14(%ebp)
  8003bd:	ff 75 f4             	pushl  -0xc(%ebp)
  8003c0:	ff 75 0c             	pushl  0xc(%ebp)
  8003c3:	ff 75 08             	pushl  0x8(%ebp)
  8003c6:	e8 15 ff ff ff       	call   8002e0 <QSort>
  8003cb:	83 c4 10             	add    $0x10,%esp
  8003ce:	eb 01                	jmp    8003d1 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  8003d0:	90                   	nop
	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);

	//cprintf("qs,after sorting: start = %d, end = %d\n", startIndex, finalIndex);

}
  8003d1:	c9                   	leave  
  8003d2:	c3                   	ret    

008003d3 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8003d3:	55                   	push   %ebp
  8003d4:	89 e5                	mov    %esp,%ebp
  8003d6:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8003d9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003e0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8003e7:	eb 33                	jmp    80041c <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8003e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f6:	01 d0                	add    %edx,%eax
  8003f8:	8b 10                	mov    (%eax),%edx
  8003fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003fd:	40                   	inc    %eax
  8003fe:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800405:	8b 45 08             	mov    0x8(%ebp),%eax
  800408:	01 c8                	add    %ecx,%eax
  80040a:	8b 00                	mov    (%eax),%eax
  80040c:	39 c2                	cmp    %eax,%edx
  80040e:	7e 09                	jle    800419 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800410:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800417:	eb 0c                	jmp    800425 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800419:	ff 45 f8             	incl   -0x8(%ebp)
  80041c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80041f:	48                   	dec    %eax
  800420:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800423:	7f c4                	jg     8003e9 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800425:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800428:	c9                   	leave  
  800429:	c3                   	ret    

0080042a <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80042a:	55                   	push   %ebp
  80042b:	89 e5                	mov    %esp,%ebp
  80042d:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800430:	8b 45 0c             	mov    0xc(%ebp),%eax
  800433:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80043a:	8b 45 08             	mov    0x8(%ebp),%eax
  80043d:	01 d0                	add    %edx,%eax
  80043f:	8b 00                	mov    (%eax),%eax
  800441:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800444:	8b 45 0c             	mov    0xc(%ebp),%eax
  800447:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80044e:	8b 45 08             	mov    0x8(%ebp),%eax
  800451:	01 c2                	add    %eax,%edx
  800453:	8b 45 10             	mov    0x10(%ebp),%eax
  800456:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80045d:	8b 45 08             	mov    0x8(%ebp),%eax
  800460:	01 c8                	add    %ecx,%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800466:	8b 45 10             	mov    0x10(%ebp),%eax
  800469:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800470:	8b 45 08             	mov    0x8(%ebp),%eax
  800473:	01 c2                	add    %eax,%edx
  800475:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800478:	89 02                	mov    %eax,(%edx)
}
  80047a:	90                   	nop
  80047b:	c9                   	leave  
  80047c:	c3                   	ret    

0080047d <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80047d:	55                   	push   %ebp
  80047e:	89 e5                	mov    %esp,%ebp
  800480:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800483:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80048a:	eb 17                	jmp    8004a3 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80048c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80048f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800496:	8b 45 08             	mov    0x8(%ebp),%eax
  800499:	01 c2                	add    %eax,%edx
  80049b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80049e:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004a0:	ff 45 fc             	incl   -0x4(%ebp)
  8004a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004a6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004a9:	7c e1                	jl     80048c <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8004ab:	90                   	nop
  8004ac:	c9                   	leave  
  8004ad:	c3                   	ret    

008004ae <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8004ae:	55                   	push   %ebp
  8004af:	89 e5                	mov    %esp,%ebp
  8004b1:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004bb:	eb 1b                	jmp    8004d8 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8004bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004c0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ca:	01 c2                	add    %eax,%edx
  8004cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004cf:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8004d2:	48                   	dec    %eax
  8004d3:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004d5:	ff 45 fc             	incl   -0x4(%ebp)
  8004d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004db:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004de:	7c dd                	jl     8004bd <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8004e0:	90                   	nop
  8004e1:	c9                   	leave  
  8004e2:	c3                   	ret    

008004e3 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8004e3:	55                   	push   %ebp
  8004e4:	89 e5                	mov    %esp,%ebp
  8004e6:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8004e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004ec:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8004f1:	f7 e9                	imul   %ecx
  8004f3:	c1 f9 1f             	sar    $0x1f,%ecx
  8004f6:	89 d0                	mov    %edx,%eax
  8004f8:	29 c8                	sub    %ecx,%eax
  8004fa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8004fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800504:	eb 1e                	jmp    800524 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  800506:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800509:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800510:	8b 45 08             	mov    0x8(%ebp),%eax
  800513:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800516:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800519:	99                   	cltd   
  80051a:	f7 7d f8             	idivl  -0x8(%ebp)
  80051d:	89 d0                	mov    %edx,%eax
  80051f:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800521:	ff 45 fc             	incl   -0x4(%ebp)
  800524:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800527:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80052a:	7c da                	jl     800506 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  80052c:	90                   	nop
  80052d:	c9                   	leave  
  80052e:	c3                   	ret    

0080052f <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  80052f:	55                   	push   %ebp
  800530:	89 e5                	mov    %esp,%ebp
  800532:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800535:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80053c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800543:	eb 42                	jmp    800587 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800545:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800548:	99                   	cltd   
  800549:	f7 7d f0             	idivl  -0x10(%ebp)
  80054c:	89 d0                	mov    %edx,%eax
  80054e:	85 c0                	test   %eax,%eax
  800550:	75 10                	jne    800562 <PrintElements+0x33>
			cprintf("\n");
  800552:	83 ec 0c             	sub    $0xc,%esp
  800555:	68 a0 39 80 00       	push   $0x8039a0
  80055a:	e8 e6 04 00 00       	call   800a45 <cprintf>
  80055f:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800562:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800565:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80056c:	8b 45 08             	mov    0x8(%ebp),%eax
  80056f:	01 d0                	add    %edx,%eax
  800571:	8b 00                	mov    (%eax),%eax
  800573:	83 ec 08             	sub    $0x8,%esp
  800576:	50                   	push   %eax
  800577:	68 70 3b 80 00       	push   $0x803b70
  80057c:	e8 c4 04 00 00       	call   800a45 <cprintf>
  800581:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800584:	ff 45 f4             	incl   -0xc(%ebp)
  800587:	8b 45 0c             	mov    0xc(%ebp),%eax
  80058a:	48                   	dec    %eax
  80058b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80058e:	7f b5                	jg     800545 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800590:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800593:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80059a:	8b 45 08             	mov    0x8(%ebp),%eax
  80059d:	01 d0                	add    %edx,%eax
  80059f:	8b 00                	mov    (%eax),%eax
  8005a1:	83 ec 08             	sub    $0x8,%esp
  8005a4:	50                   	push   %eax
  8005a5:	68 75 3b 80 00       	push   $0x803b75
  8005aa:	e8 96 04 00 00       	call   800a45 <cprintf>
  8005af:	83 c4 10             	add    $0x10,%esp

}
  8005b2:	90                   	nop
  8005b3:	c9                   	leave  
  8005b4:	c3                   	ret    

008005b5 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8005b5:	55                   	push   %ebp
  8005b6:	89 e5                	mov    %esp,%ebp
  8005b8:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8005bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005be:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005c1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005c5:	83 ec 0c             	sub    $0xc,%esp
  8005c8:	50                   	push   %eax
  8005c9:	e8 3a 1b 00 00       	call   802108 <sys_cputc>
  8005ce:	83 c4 10             	add    $0x10,%esp
}
  8005d1:	90                   	nop
  8005d2:	c9                   	leave  
  8005d3:	c3                   	ret    

008005d4 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8005d4:	55                   	push   %ebp
  8005d5:	89 e5                	mov    %esp,%ebp
  8005d7:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005da:	e8 f5 1a 00 00       	call   8020d4 <sys_disable_interrupt>
	char c = ch;
  8005df:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e2:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005e5:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005e9:	83 ec 0c             	sub    $0xc,%esp
  8005ec:	50                   	push   %eax
  8005ed:	e8 16 1b 00 00       	call   802108 <sys_cputc>
  8005f2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8005f5:	e8 f4 1a 00 00       	call   8020ee <sys_enable_interrupt>
}
  8005fa:	90                   	nop
  8005fb:	c9                   	leave  
  8005fc:	c3                   	ret    

008005fd <getchar>:

int
getchar(void)
{
  8005fd:	55                   	push   %ebp
  8005fe:	89 e5                	mov    %esp,%ebp
  800600:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800603:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80060a:	eb 08                	jmp    800614 <getchar+0x17>
	{
		c = sys_cgetc();
  80060c:	e8 3e 19 00 00       	call   801f4f <sys_cgetc>
  800611:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800614:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800618:	74 f2                	je     80060c <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  80061a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80061d:	c9                   	leave  
  80061e:	c3                   	ret    

0080061f <atomic_getchar>:

int
atomic_getchar(void)
{
  80061f:	55                   	push   %ebp
  800620:	89 e5                	mov    %esp,%ebp
  800622:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800625:	e8 aa 1a 00 00       	call   8020d4 <sys_disable_interrupt>
	int c=0;
  80062a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800631:	eb 08                	jmp    80063b <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800633:	e8 17 19 00 00       	call   801f4f <sys_cgetc>
  800638:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  80063b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80063f:	74 f2                	je     800633 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800641:	e8 a8 1a 00 00       	call   8020ee <sys_enable_interrupt>
	return c;
  800646:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800649:	c9                   	leave  
  80064a:	c3                   	ret    

0080064b <iscons>:

int iscons(int fdnum)
{
  80064b:	55                   	push   %ebp
  80064c:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80064e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800653:	5d                   	pop    %ebp
  800654:	c3                   	ret    

00800655 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800655:	55                   	push   %ebp
  800656:	89 e5                	mov    %esp,%ebp
  800658:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80065b:	e8 67 1c 00 00       	call   8022c7 <sys_getenvindex>
  800660:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800663:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800666:	89 d0                	mov    %edx,%eax
  800668:	c1 e0 03             	shl    $0x3,%eax
  80066b:	01 d0                	add    %edx,%eax
  80066d:	01 c0                	add    %eax,%eax
  80066f:	01 d0                	add    %edx,%eax
  800671:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800678:	01 d0                	add    %edx,%eax
  80067a:	c1 e0 04             	shl    $0x4,%eax
  80067d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800682:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800687:	a1 24 50 80 00       	mov    0x805024,%eax
  80068c:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800692:	84 c0                	test   %al,%al
  800694:	74 0f                	je     8006a5 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800696:	a1 24 50 80 00       	mov    0x805024,%eax
  80069b:	05 5c 05 00 00       	add    $0x55c,%eax
  8006a0:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006a9:	7e 0a                	jle    8006b5 <libmain+0x60>
		binaryname = argv[0];
  8006ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ae:	8b 00                	mov    (%eax),%eax
  8006b0:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8006b5:	83 ec 08             	sub    $0x8,%esp
  8006b8:	ff 75 0c             	pushl  0xc(%ebp)
  8006bb:	ff 75 08             	pushl  0x8(%ebp)
  8006be:	e8 75 f9 ff ff       	call   800038 <_main>
  8006c3:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8006c6:	e8 09 1a 00 00       	call   8020d4 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006cb:	83 ec 0c             	sub    $0xc,%esp
  8006ce:	68 94 3b 80 00       	push   $0x803b94
  8006d3:	e8 6d 03 00 00       	call   800a45 <cprintf>
  8006d8:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006db:	a1 24 50 80 00       	mov    0x805024,%eax
  8006e0:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8006e6:	a1 24 50 80 00       	mov    0x805024,%eax
  8006eb:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8006f1:	83 ec 04             	sub    $0x4,%esp
  8006f4:	52                   	push   %edx
  8006f5:	50                   	push   %eax
  8006f6:	68 bc 3b 80 00       	push   $0x803bbc
  8006fb:	e8 45 03 00 00       	call   800a45 <cprintf>
  800700:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800703:	a1 24 50 80 00       	mov    0x805024,%eax
  800708:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80070e:	a1 24 50 80 00       	mov    0x805024,%eax
  800713:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800719:	a1 24 50 80 00       	mov    0x805024,%eax
  80071e:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800724:	51                   	push   %ecx
  800725:	52                   	push   %edx
  800726:	50                   	push   %eax
  800727:	68 e4 3b 80 00       	push   $0x803be4
  80072c:	e8 14 03 00 00       	call   800a45 <cprintf>
  800731:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800734:	a1 24 50 80 00       	mov    0x805024,%eax
  800739:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80073f:	83 ec 08             	sub    $0x8,%esp
  800742:	50                   	push   %eax
  800743:	68 3c 3c 80 00       	push   $0x803c3c
  800748:	e8 f8 02 00 00       	call   800a45 <cprintf>
  80074d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800750:	83 ec 0c             	sub    $0xc,%esp
  800753:	68 94 3b 80 00       	push   $0x803b94
  800758:	e8 e8 02 00 00       	call   800a45 <cprintf>
  80075d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800760:	e8 89 19 00 00       	call   8020ee <sys_enable_interrupt>

	// exit gracefully
	exit();
  800765:	e8 19 00 00 00       	call   800783 <exit>
}
  80076a:	90                   	nop
  80076b:	c9                   	leave  
  80076c:	c3                   	ret    

0080076d <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80076d:	55                   	push   %ebp
  80076e:	89 e5                	mov    %esp,%ebp
  800770:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800773:	83 ec 0c             	sub    $0xc,%esp
  800776:	6a 00                	push   $0x0
  800778:	e8 16 1b 00 00       	call   802293 <sys_destroy_env>
  80077d:	83 c4 10             	add    $0x10,%esp
}
  800780:	90                   	nop
  800781:	c9                   	leave  
  800782:	c3                   	ret    

00800783 <exit>:

void
exit(void)
{
  800783:	55                   	push   %ebp
  800784:	89 e5                	mov    %esp,%ebp
  800786:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800789:	e8 6b 1b 00 00       	call   8022f9 <sys_exit_env>
}
  80078e:	90                   	nop
  80078f:	c9                   	leave  
  800790:	c3                   	ret    

00800791 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800791:	55                   	push   %ebp
  800792:	89 e5                	mov    %esp,%ebp
  800794:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800797:	8d 45 10             	lea    0x10(%ebp),%eax
  80079a:	83 c0 04             	add    $0x4,%eax
  80079d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8007a0:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8007a5:	85 c0                	test   %eax,%eax
  8007a7:	74 16                	je     8007bf <_panic+0x2e>
		cprintf("%s: ", argv0);
  8007a9:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8007ae:	83 ec 08             	sub    $0x8,%esp
  8007b1:	50                   	push   %eax
  8007b2:	68 50 3c 80 00       	push   $0x803c50
  8007b7:	e8 89 02 00 00       	call   800a45 <cprintf>
  8007bc:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007bf:	a1 00 50 80 00       	mov    0x805000,%eax
  8007c4:	ff 75 0c             	pushl  0xc(%ebp)
  8007c7:	ff 75 08             	pushl  0x8(%ebp)
  8007ca:	50                   	push   %eax
  8007cb:	68 55 3c 80 00       	push   $0x803c55
  8007d0:	e8 70 02 00 00       	call   800a45 <cprintf>
  8007d5:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8007d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8007db:	83 ec 08             	sub    $0x8,%esp
  8007de:	ff 75 f4             	pushl  -0xc(%ebp)
  8007e1:	50                   	push   %eax
  8007e2:	e8 f3 01 00 00       	call   8009da <vcprintf>
  8007e7:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007ea:	83 ec 08             	sub    $0x8,%esp
  8007ed:	6a 00                	push   $0x0
  8007ef:	68 71 3c 80 00       	push   $0x803c71
  8007f4:	e8 e1 01 00 00       	call   8009da <vcprintf>
  8007f9:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8007fc:	e8 82 ff ff ff       	call   800783 <exit>

	// should not return here
	while (1) ;
  800801:	eb fe                	jmp    800801 <_panic+0x70>

00800803 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800803:	55                   	push   %ebp
  800804:	89 e5                	mov    %esp,%ebp
  800806:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800809:	a1 24 50 80 00       	mov    0x805024,%eax
  80080e:	8b 50 74             	mov    0x74(%eax),%edx
  800811:	8b 45 0c             	mov    0xc(%ebp),%eax
  800814:	39 c2                	cmp    %eax,%edx
  800816:	74 14                	je     80082c <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800818:	83 ec 04             	sub    $0x4,%esp
  80081b:	68 74 3c 80 00       	push   $0x803c74
  800820:	6a 26                	push   $0x26
  800822:	68 c0 3c 80 00       	push   $0x803cc0
  800827:	e8 65 ff ff ff       	call   800791 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80082c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800833:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80083a:	e9 c2 00 00 00       	jmp    800901 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80083f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800842:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800849:	8b 45 08             	mov    0x8(%ebp),%eax
  80084c:	01 d0                	add    %edx,%eax
  80084e:	8b 00                	mov    (%eax),%eax
  800850:	85 c0                	test   %eax,%eax
  800852:	75 08                	jne    80085c <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800854:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800857:	e9 a2 00 00 00       	jmp    8008fe <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80085c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800863:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80086a:	eb 69                	jmp    8008d5 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80086c:	a1 24 50 80 00       	mov    0x805024,%eax
  800871:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800877:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80087a:	89 d0                	mov    %edx,%eax
  80087c:	01 c0                	add    %eax,%eax
  80087e:	01 d0                	add    %edx,%eax
  800880:	c1 e0 03             	shl    $0x3,%eax
  800883:	01 c8                	add    %ecx,%eax
  800885:	8a 40 04             	mov    0x4(%eax),%al
  800888:	84 c0                	test   %al,%al
  80088a:	75 46                	jne    8008d2 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80088c:	a1 24 50 80 00       	mov    0x805024,%eax
  800891:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800897:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80089a:	89 d0                	mov    %edx,%eax
  80089c:	01 c0                	add    %eax,%eax
  80089e:	01 d0                	add    %edx,%eax
  8008a0:	c1 e0 03             	shl    $0x3,%eax
  8008a3:	01 c8                	add    %ecx,%eax
  8008a5:	8b 00                	mov    (%eax),%eax
  8008a7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008aa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008b2:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008b7:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008be:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c1:	01 c8                	add    %ecx,%eax
  8008c3:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008c5:	39 c2                	cmp    %eax,%edx
  8008c7:	75 09                	jne    8008d2 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8008c9:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8008d0:	eb 12                	jmp    8008e4 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008d2:	ff 45 e8             	incl   -0x18(%ebp)
  8008d5:	a1 24 50 80 00       	mov    0x805024,%eax
  8008da:	8b 50 74             	mov    0x74(%eax),%edx
  8008dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008e0:	39 c2                	cmp    %eax,%edx
  8008e2:	77 88                	ja     80086c <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8008e4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008e8:	75 14                	jne    8008fe <CheckWSWithoutLastIndex+0xfb>
			panic(
  8008ea:	83 ec 04             	sub    $0x4,%esp
  8008ed:	68 cc 3c 80 00       	push   $0x803ccc
  8008f2:	6a 3a                	push   $0x3a
  8008f4:	68 c0 3c 80 00       	push   $0x803cc0
  8008f9:	e8 93 fe ff ff       	call   800791 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8008fe:	ff 45 f0             	incl   -0x10(%ebp)
  800901:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800904:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800907:	0f 8c 32 ff ff ff    	jl     80083f <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80090d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800914:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80091b:	eb 26                	jmp    800943 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80091d:	a1 24 50 80 00       	mov    0x805024,%eax
  800922:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800928:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80092b:	89 d0                	mov    %edx,%eax
  80092d:	01 c0                	add    %eax,%eax
  80092f:	01 d0                	add    %edx,%eax
  800931:	c1 e0 03             	shl    $0x3,%eax
  800934:	01 c8                	add    %ecx,%eax
  800936:	8a 40 04             	mov    0x4(%eax),%al
  800939:	3c 01                	cmp    $0x1,%al
  80093b:	75 03                	jne    800940 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80093d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800940:	ff 45 e0             	incl   -0x20(%ebp)
  800943:	a1 24 50 80 00       	mov    0x805024,%eax
  800948:	8b 50 74             	mov    0x74(%eax),%edx
  80094b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80094e:	39 c2                	cmp    %eax,%edx
  800950:	77 cb                	ja     80091d <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800952:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800955:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800958:	74 14                	je     80096e <CheckWSWithoutLastIndex+0x16b>
		panic(
  80095a:	83 ec 04             	sub    $0x4,%esp
  80095d:	68 20 3d 80 00       	push   $0x803d20
  800962:	6a 44                	push   $0x44
  800964:	68 c0 3c 80 00       	push   $0x803cc0
  800969:	e8 23 fe ff ff       	call   800791 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80096e:	90                   	nop
  80096f:	c9                   	leave  
  800970:	c3                   	ret    

00800971 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800971:	55                   	push   %ebp
  800972:	89 e5                	mov    %esp,%ebp
  800974:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800977:	8b 45 0c             	mov    0xc(%ebp),%eax
  80097a:	8b 00                	mov    (%eax),%eax
  80097c:	8d 48 01             	lea    0x1(%eax),%ecx
  80097f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800982:	89 0a                	mov    %ecx,(%edx)
  800984:	8b 55 08             	mov    0x8(%ebp),%edx
  800987:	88 d1                	mov    %dl,%cl
  800989:	8b 55 0c             	mov    0xc(%ebp),%edx
  80098c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800990:	8b 45 0c             	mov    0xc(%ebp),%eax
  800993:	8b 00                	mov    (%eax),%eax
  800995:	3d ff 00 00 00       	cmp    $0xff,%eax
  80099a:	75 2c                	jne    8009c8 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80099c:	a0 28 50 80 00       	mov    0x805028,%al
  8009a1:	0f b6 c0             	movzbl %al,%eax
  8009a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a7:	8b 12                	mov    (%edx),%edx
  8009a9:	89 d1                	mov    %edx,%ecx
  8009ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ae:	83 c2 08             	add    $0x8,%edx
  8009b1:	83 ec 04             	sub    $0x4,%esp
  8009b4:	50                   	push   %eax
  8009b5:	51                   	push   %ecx
  8009b6:	52                   	push   %edx
  8009b7:	e8 6a 15 00 00       	call   801f26 <sys_cputs>
  8009bc:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009cb:	8b 40 04             	mov    0x4(%eax),%eax
  8009ce:	8d 50 01             	lea    0x1(%eax),%edx
  8009d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d4:	89 50 04             	mov    %edx,0x4(%eax)
}
  8009d7:	90                   	nop
  8009d8:	c9                   	leave  
  8009d9:	c3                   	ret    

008009da <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8009da:	55                   	push   %ebp
  8009db:	89 e5                	mov    %esp,%ebp
  8009dd:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009e3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009ea:	00 00 00 
	b.cnt = 0;
  8009ed:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009f4:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8009f7:	ff 75 0c             	pushl  0xc(%ebp)
  8009fa:	ff 75 08             	pushl  0x8(%ebp)
  8009fd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a03:	50                   	push   %eax
  800a04:	68 71 09 80 00       	push   $0x800971
  800a09:	e8 11 02 00 00       	call   800c1f <vprintfmt>
  800a0e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800a11:	a0 28 50 80 00       	mov    0x805028,%al
  800a16:	0f b6 c0             	movzbl %al,%eax
  800a19:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800a1f:	83 ec 04             	sub    $0x4,%esp
  800a22:	50                   	push   %eax
  800a23:	52                   	push   %edx
  800a24:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a2a:	83 c0 08             	add    $0x8,%eax
  800a2d:	50                   	push   %eax
  800a2e:	e8 f3 14 00 00       	call   801f26 <sys_cputs>
  800a33:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a36:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800a3d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a43:	c9                   	leave  
  800a44:	c3                   	ret    

00800a45 <cprintf>:

int cprintf(const char *fmt, ...) {
  800a45:	55                   	push   %ebp
  800a46:	89 e5                	mov    %esp,%ebp
  800a48:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a4b:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800a52:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a55:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a58:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5b:	83 ec 08             	sub    $0x8,%esp
  800a5e:	ff 75 f4             	pushl  -0xc(%ebp)
  800a61:	50                   	push   %eax
  800a62:	e8 73 ff ff ff       	call   8009da <vcprintf>
  800a67:	83 c4 10             	add    $0x10,%esp
  800a6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a70:	c9                   	leave  
  800a71:	c3                   	ret    

00800a72 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a72:	55                   	push   %ebp
  800a73:	89 e5                	mov    %esp,%ebp
  800a75:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a78:	e8 57 16 00 00       	call   8020d4 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a7d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a80:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a83:	8b 45 08             	mov    0x8(%ebp),%eax
  800a86:	83 ec 08             	sub    $0x8,%esp
  800a89:	ff 75 f4             	pushl  -0xc(%ebp)
  800a8c:	50                   	push   %eax
  800a8d:	e8 48 ff ff ff       	call   8009da <vcprintf>
  800a92:	83 c4 10             	add    $0x10,%esp
  800a95:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a98:	e8 51 16 00 00       	call   8020ee <sys_enable_interrupt>
	return cnt;
  800a9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800aa0:	c9                   	leave  
  800aa1:	c3                   	ret    

00800aa2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800aa2:	55                   	push   %ebp
  800aa3:	89 e5                	mov    %esp,%ebp
  800aa5:	53                   	push   %ebx
  800aa6:	83 ec 14             	sub    $0x14,%esp
  800aa9:	8b 45 10             	mov    0x10(%ebp),%eax
  800aac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aaf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800ab5:	8b 45 18             	mov    0x18(%ebp),%eax
  800ab8:	ba 00 00 00 00       	mov    $0x0,%edx
  800abd:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ac0:	77 55                	ja     800b17 <printnum+0x75>
  800ac2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ac5:	72 05                	jb     800acc <printnum+0x2a>
  800ac7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800aca:	77 4b                	ja     800b17 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800acc:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800acf:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800ad2:	8b 45 18             	mov    0x18(%ebp),%eax
  800ad5:	ba 00 00 00 00       	mov    $0x0,%edx
  800ada:	52                   	push   %edx
  800adb:	50                   	push   %eax
  800adc:	ff 75 f4             	pushl  -0xc(%ebp)
  800adf:	ff 75 f0             	pushl  -0x10(%ebp)
  800ae2:	e8 4d 2c 00 00       	call   803734 <__udivdi3>
  800ae7:	83 c4 10             	add    $0x10,%esp
  800aea:	83 ec 04             	sub    $0x4,%esp
  800aed:	ff 75 20             	pushl  0x20(%ebp)
  800af0:	53                   	push   %ebx
  800af1:	ff 75 18             	pushl  0x18(%ebp)
  800af4:	52                   	push   %edx
  800af5:	50                   	push   %eax
  800af6:	ff 75 0c             	pushl  0xc(%ebp)
  800af9:	ff 75 08             	pushl  0x8(%ebp)
  800afc:	e8 a1 ff ff ff       	call   800aa2 <printnum>
  800b01:	83 c4 20             	add    $0x20,%esp
  800b04:	eb 1a                	jmp    800b20 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b06:	83 ec 08             	sub    $0x8,%esp
  800b09:	ff 75 0c             	pushl  0xc(%ebp)
  800b0c:	ff 75 20             	pushl  0x20(%ebp)
  800b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b12:	ff d0                	call   *%eax
  800b14:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b17:	ff 4d 1c             	decl   0x1c(%ebp)
  800b1a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b1e:	7f e6                	jg     800b06 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b20:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b23:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b2e:	53                   	push   %ebx
  800b2f:	51                   	push   %ecx
  800b30:	52                   	push   %edx
  800b31:	50                   	push   %eax
  800b32:	e8 0d 2d 00 00       	call   803844 <__umoddi3>
  800b37:	83 c4 10             	add    $0x10,%esp
  800b3a:	05 94 3f 80 00       	add    $0x803f94,%eax
  800b3f:	8a 00                	mov    (%eax),%al
  800b41:	0f be c0             	movsbl %al,%eax
  800b44:	83 ec 08             	sub    $0x8,%esp
  800b47:	ff 75 0c             	pushl  0xc(%ebp)
  800b4a:	50                   	push   %eax
  800b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4e:	ff d0                	call   *%eax
  800b50:	83 c4 10             	add    $0x10,%esp
}
  800b53:	90                   	nop
  800b54:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b57:	c9                   	leave  
  800b58:	c3                   	ret    

00800b59 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b59:	55                   	push   %ebp
  800b5a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b5c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b60:	7e 1c                	jle    800b7e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b62:	8b 45 08             	mov    0x8(%ebp),%eax
  800b65:	8b 00                	mov    (%eax),%eax
  800b67:	8d 50 08             	lea    0x8(%eax),%edx
  800b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6d:	89 10                	mov    %edx,(%eax)
  800b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b72:	8b 00                	mov    (%eax),%eax
  800b74:	83 e8 08             	sub    $0x8,%eax
  800b77:	8b 50 04             	mov    0x4(%eax),%edx
  800b7a:	8b 00                	mov    (%eax),%eax
  800b7c:	eb 40                	jmp    800bbe <getuint+0x65>
	else if (lflag)
  800b7e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b82:	74 1e                	je     800ba2 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b84:	8b 45 08             	mov    0x8(%ebp),%eax
  800b87:	8b 00                	mov    (%eax),%eax
  800b89:	8d 50 04             	lea    0x4(%eax),%edx
  800b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8f:	89 10                	mov    %edx,(%eax)
  800b91:	8b 45 08             	mov    0x8(%ebp),%eax
  800b94:	8b 00                	mov    (%eax),%eax
  800b96:	83 e8 04             	sub    $0x4,%eax
  800b99:	8b 00                	mov    (%eax),%eax
  800b9b:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba0:	eb 1c                	jmp    800bbe <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba5:	8b 00                	mov    (%eax),%eax
  800ba7:	8d 50 04             	lea    0x4(%eax),%edx
  800baa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bad:	89 10                	mov    %edx,(%eax)
  800baf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb2:	8b 00                	mov    (%eax),%eax
  800bb4:	83 e8 04             	sub    $0x4,%eax
  800bb7:	8b 00                	mov    (%eax),%eax
  800bb9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800bbe:	5d                   	pop    %ebp
  800bbf:	c3                   	ret    

00800bc0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bc3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bc7:	7e 1c                	jle    800be5 <getint+0x25>
		return va_arg(*ap, long long);
  800bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcc:	8b 00                	mov    (%eax),%eax
  800bce:	8d 50 08             	lea    0x8(%eax),%edx
  800bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd4:	89 10                	mov    %edx,(%eax)
  800bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd9:	8b 00                	mov    (%eax),%eax
  800bdb:	83 e8 08             	sub    $0x8,%eax
  800bde:	8b 50 04             	mov    0x4(%eax),%edx
  800be1:	8b 00                	mov    (%eax),%eax
  800be3:	eb 38                	jmp    800c1d <getint+0x5d>
	else if (lflag)
  800be5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800be9:	74 1a                	je     800c05 <getint+0x45>
		return va_arg(*ap, long);
  800beb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bee:	8b 00                	mov    (%eax),%eax
  800bf0:	8d 50 04             	lea    0x4(%eax),%edx
  800bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf6:	89 10                	mov    %edx,(%eax)
  800bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfb:	8b 00                	mov    (%eax),%eax
  800bfd:	83 e8 04             	sub    $0x4,%eax
  800c00:	8b 00                	mov    (%eax),%eax
  800c02:	99                   	cltd   
  800c03:	eb 18                	jmp    800c1d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c05:	8b 45 08             	mov    0x8(%ebp),%eax
  800c08:	8b 00                	mov    (%eax),%eax
  800c0a:	8d 50 04             	lea    0x4(%eax),%edx
  800c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c10:	89 10                	mov    %edx,(%eax)
  800c12:	8b 45 08             	mov    0x8(%ebp),%eax
  800c15:	8b 00                	mov    (%eax),%eax
  800c17:	83 e8 04             	sub    $0x4,%eax
  800c1a:	8b 00                	mov    (%eax),%eax
  800c1c:	99                   	cltd   
}
  800c1d:	5d                   	pop    %ebp
  800c1e:	c3                   	ret    

00800c1f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c1f:	55                   	push   %ebp
  800c20:	89 e5                	mov    %esp,%ebp
  800c22:	56                   	push   %esi
  800c23:	53                   	push   %ebx
  800c24:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c27:	eb 17                	jmp    800c40 <vprintfmt+0x21>
			if (ch == '\0')
  800c29:	85 db                	test   %ebx,%ebx
  800c2b:	0f 84 af 03 00 00    	je     800fe0 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800c31:	83 ec 08             	sub    $0x8,%esp
  800c34:	ff 75 0c             	pushl  0xc(%ebp)
  800c37:	53                   	push   %ebx
  800c38:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3b:	ff d0                	call   *%eax
  800c3d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c40:	8b 45 10             	mov    0x10(%ebp),%eax
  800c43:	8d 50 01             	lea    0x1(%eax),%edx
  800c46:	89 55 10             	mov    %edx,0x10(%ebp)
  800c49:	8a 00                	mov    (%eax),%al
  800c4b:	0f b6 d8             	movzbl %al,%ebx
  800c4e:	83 fb 25             	cmp    $0x25,%ebx
  800c51:	75 d6                	jne    800c29 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c53:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c57:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c5e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c65:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c6c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c73:	8b 45 10             	mov    0x10(%ebp),%eax
  800c76:	8d 50 01             	lea    0x1(%eax),%edx
  800c79:	89 55 10             	mov    %edx,0x10(%ebp)
  800c7c:	8a 00                	mov    (%eax),%al
  800c7e:	0f b6 d8             	movzbl %al,%ebx
  800c81:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c84:	83 f8 55             	cmp    $0x55,%eax
  800c87:	0f 87 2b 03 00 00    	ja     800fb8 <vprintfmt+0x399>
  800c8d:	8b 04 85 b8 3f 80 00 	mov    0x803fb8(,%eax,4),%eax
  800c94:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c96:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c9a:	eb d7                	jmp    800c73 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c9c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800ca0:	eb d1                	jmp    800c73 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ca2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800ca9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800cac:	89 d0                	mov    %edx,%eax
  800cae:	c1 e0 02             	shl    $0x2,%eax
  800cb1:	01 d0                	add    %edx,%eax
  800cb3:	01 c0                	add    %eax,%eax
  800cb5:	01 d8                	add    %ebx,%eax
  800cb7:	83 e8 30             	sub    $0x30,%eax
  800cba:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800cbd:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc0:	8a 00                	mov    (%eax),%al
  800cc2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800cc5:	83 fb 2f             	cmp    $0x2f,%ebx
  800cc8:	7e 3e                	jle    800d08 <vprintfmt+0xe9>
  800cca:	83 fb 39             	cmp    $0x39,%ebx
  800ccd:	7f 39                	jg     800d08 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ccf:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800cd2:	eb d5                	jmp    800ca9 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800cd4:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd7:	83 c0 04             	add    $0x4,%eax
  800cda:	89 45 14             	mov    %eax,0x14(%ebp)
  800cdd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce0:	83 e8 04             	sub    $0x4,%eax
  800ce3:	8b 00                	mov    (%eax),%eax
  800ce5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800ce8:	eb 1f                	jmp    800d09 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800cea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cee:	79 83                	jns    800c73 <vprintfmt+0x54>
				width = 0;
  800cf0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800cf7:	e9 77 ff ff ff       	jmp    800c73 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800cfc:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d03:	e9 6b ff ff ff       	jmp    800c73 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d08:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d09:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d0d:	0f 89 60 ff ff ff    	jns    800c73 <vprintfmt+0x54>
				width = precision, precision = -1;
  800d13:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d19:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d20:	e9 4e ff ff ff       	jmp    800c73 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d25:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d28:	e9 46 ff ff ff       	jmp    800c73 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d30:	83 c0 04             	add    $0x4,%eax
  800d33:	89 45 14             	mov    %eax,0x14(%ebp)
  800d36:	8b 45 14             	mov    0x14(%ebp),%eax
  800d39:	83 e8 04             	sub    $0x4,%eax
  800d3c:	8b 00                	mov    (%eax),%eax
  800d3e:	83 ec 08             	sub    $0x8,%esp
  800d41:	ff 75 0c             	pushl  0xc(%ebp)
  800d44:	50                   	push   %eax
  800d45:	8b 45 08             	mov    0x8(%ebp),%eax
  800d48:	ff d0                	call   *%eax
  800d4a:	83 c4 10             	add    $0x10,%esp
			break;
  800d4d:	e9 89 02 00 00       	jmp    800fdb <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d52:	8b 45 14             	mov    0x14(%ebp),%eax
  800d55:	83 c0 04             	add    $0x4,%eax
  800d58:	89 45 14             	mov    %eax,0x14(%ebp)
  800d5b:	8b 45 14             	mov    0x14(%ebp),%eax
  800d5e:	83 e8 04             	sub    $0x4,%eax
  800d61:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d63:	85 db                	test   %ebx,%ebx
  800d65:	79 02                	jns    800d69 <vprintfmt+0x14a>
				err = -err;
  800d67:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d69:	83 fb 64             	cmp    $0x64,%ebx
  800d6c:	7f 0b                	jg     800d79 <vprintfmt+0x15a>
  800d6e:	8b 34 9d 00 3e 80 00 	mov    0x803e00(,%ebx,4),%esi
  800d75:	85 f6                	test   %esi,%esi
  800d77:	75 19                	jne    800d92 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d79:	53                   	push   %ebx
  800d7a:	68 a5 3f 80 00       	push   $0x803fa5
  800d7f:	ff 75 0c             	pushl  0xc(%ebp)
  800d82:	ff 75 08             	pushl  0x8(%ebp)
  800d85:	e8 5e 02 00 00       	call   800fe8 <printfmt>
  800d8a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d8d:	e9 49 02 00 00       	jmp    800fdb <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d92:	56                   	push   %esi
  800d93:	68 ae 3f 80 00       	push   $0x803fae
  800d98:	ff 75 0c             	pushl  0xc(%ebp)
  800d9b:	ff 75 08             	pushl  0x8(%ebp)
  800d9e:	e8 45 02 00 00       	call   800fe8 <printfmt>
  800da3:	83 c4 10             	add    $0x10,%esp
			break;
  800da6:	e9 30 02 00 00       	jmp    800fdb <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800dab:	8b 45 14             	mov    0x14(%ebp),%eax
  800dae:	83 c0 04             	add    $0x4,%eax
  800db1:	89 45 14             	mov    %eax,0x14(%ebp)
  800db4:	8b 45 14             	mov    0x14(%ebp),%eax
  800db7:	83 e8 04             	sub    $0x4,%eax
  800dba:	8b 30                	mov    (%eax),%esi
  800dbc:	85 f6                	test   %esi,%esi
  800dbe:	75 05                	jne    800dc5 <vprintfmt+0x1a6>
				p = "(null)";
  800dc0:	be b1 3f 80 00       	mov    $0x803fb1,%esi
			if (width > 0 && padc != '-')
  800dc5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dc9:	7e 6d                	jle    800e38 <vprintfmt+0x219>
  800dcb:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800dcf:	74 67                	je     800e38 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800dd1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dd4:	83 ec 08             	sub    $0x8,%esp
  800dd7:	50                   	push   %eax
  800dd8:	56                   	push   %esi
  800dd9:	e8 12 05 00 00       	call   8012f0 <strnlen>
  800dde:	83 c4 10             	add    $0x10,%esp
  800de1:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800de4:	eb 16                	jmp    800dfc <vprintfmt+0x1dd>
					putch(padc, putdat);
  800de6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800dea:	83 ec 08             	sub    $0x8,%esp
  800ded:	ff 75 0c             	pushl  0xc(%ebp)
  800df0:	50                   	push   %eax
  800df1:	8b 45 08             	mov    0x8(%ebp),%eax
  800df4:	ff d0                	call   *%eax
  800df6:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800df9:	ff 4d e4             	decl   -0x1c(%ebp)
  800dfc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e00:	7f e4                	jg     800de6 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e02:	eb 34                	jmp    800e38 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e04:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e08:	74 1c                	je     800e26 <vprintfmt+0x207>
  800e0a:	83 fb 1f             	cmp    $0x1f,%ebx
  800e0d:	7e 05                	jle    800e14 <vprintfmt+0x1f5>
  800e0f:	83 fb 7e             	cmp    $0x7e,%ebx
  800e12:	7e 12                	jle    800e26 <vprintfmt+0x207>
					putch('?', putdat);
  800e14:	83 ec 08             	sub    $0x8,%esp
  800e17:	ff 75 0c             	pushl  0xc(%ebp)
  800e1a:	6a 3f                	push   $0x3f
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	ff d0                	call   *%eax
  800e21:	83 c4 10             	add    $0x10,%esp
  800e24:	eb 0f                	jmp    800e35 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e26:	83 ec 08             	sub    $0x8,%esp
  800e29:	ff 75 0c             	pushl  0xc(%ebp)
  800e2c:	53                   	push   %ebx
  800e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e30:	ff d0                	call   *%eax
  800e32:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e35:	ff 4d e4             	decl   -0x1c(%ebp)
  800e38:	89 f0                	mov    %esi,%eax
  800e3a:	8d 70 01             	lea    0x1(%eax),%esi
  800e3d:	8a 00                	mov    (%eax),%al
  800e3f:	0f be d8             	movsbl %al,%ebx
  800e42:	85 db                	test   %ebx,%ebx
  800e44:	74 24                	je     800e6a <vprintfmt+0x24b>
  800e46:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e4a:	78 b8                	js     800e04 <vprintfmt+0x1e5>
  800e4c:	ff 4d e0             	decl   -0x20(%ebp)
  800e4f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e53:	79 af                	jns    800e04 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e55:	eb 13                	jmp    800e6a <vprintfmt+0x24b>
				putch(' ', putdat);
  800e57:	83 ec 08             	sub    $0x8,%esp
  800e5a:	ff 75 0c             	pushl  0xc(%ebp)
  800e5d:	6a 20                	push   $0x20
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e62:	ff d0                	call   *%eax
  800e64:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e67:	ff 4d e4             	decl   -0x1c(%ebp)
  800e6a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e6e:	7f e7                	jg     800e57 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e70:	e9 66 01 00 00       	jmp    800fdb <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e75:	83 ec 08             	sub    $0x8,%esp
  800e78:	ff 75 e8             	pushl  -0x18(%ebp)
  800e7b:	8d 45 14             	lea    0x14(%ebp),%eax
  800e7e:	50                   	push   %eax
  800e7f:	e8 3c fd ff ff       	call   800bc0 <getint>
  800e84:	83 c4 10             	add    $0x10,%esp
  800e87:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e8a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e90:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e93:	85 d2                	test   %edx,%edx
  800e95:	79 23                	jns    800eba <vprintfmt+0x29b>
				putch('-', putdat);
  800e97:	83 ec 08             	sub    $0x8,%esp
  800e9a:	ff 75 0c             	pushl  0xc(%ebp)
  800e9d:	6a 2d                	push   $0x2d
  800e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea2:	ff d0                	call   *%eax
  800ea4:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ea7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eaa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ead:	f7 d8                	neg    %eax
  800eaf:	83 d2 00             	adc    $0x0,%edx
  800eb2:	f7 da                	neg    %edx
  800eb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eb7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800eba:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ec1:	e9 bc 00 00 00       	jmp    800f82 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ec6:	83 ec 08             	sub    $0x8,%esp
  800ec9:	ff 75 e8             	pushl  -0x18(%ebp)
  800ecc:	8d 45 14             	lea    0x14(%ebp),%eax
  800ecf:	50                   	push   %eax
  800ed0:	e8 84 fc ff ff       	call   800b59 <getuint>
  800ed5:	83 c4 10             	add    $0x10,%esp
  800ed8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800edb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ede:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ee5:	e9 98 00 00 00       	jmp    800f82 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800eea:	83 ec 08             	sub    $0x8,%esp
  800eed:	ff 75 0c             	pushl  0xc(%ebp)
  800ef0:	6a 58                	push   $0x58
  800ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef5:	ff d0                	call   *%eax
  800ef7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800efa:	83 ec 08             	sub    $0x8,%esp
  800efd:	ff 75 0c             	pushl  0xc(%ebp)
  800f00:	6a 58                	push   $0x58
  800f02:	8b 45 08             	mov    0x8(%ebp),%eax
  800f05:	ff d0                	call   *%eax
  800f07:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f0a:	83 ec 08             	sub    $0x8,%esp
  800f0d:	ff 75 0c             	pushl  0xc(%ebp)
  800f10:	6a 58                	push   $0x58
  800f12:	8b 45 08             	mov    0x8(%ebp),%eax
  800f15:	ff d0                	call   *%eax
  800f17:	83 c4 10             	add    $0x10,%esp
			break;
  800f1a:	e9 bc 00 00 00       	jmp    800fdb <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800f1f:	83 ec 08             	sub    $0x8,%esp
  800f22:	ff 75 0c             	pushl  0xc(%ebp)
  800f25:	6a 30                	push   $0x30
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	ff d0                	call   *%eax
  800f2c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f2f:	83 ec 08             	sub    $0x8,%esp
  800f32:	ff 75 0c             	pushl  0xc(%ebp)
  800f35:	6a 78                	push   $0x78
  800f37:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3a:	ff d0                	call   *%eax
  800f3c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f3f:	8b 45 14             	mov    0x14(%ebp),%eax
  800f42:	83 c0 04             	add    $0x4,%eax
  800f45:	89 45 14             	mov    %eax,0x14(%ebp)
  800f48:	8b 45 14             	mov    0x14(%ebp),%eax
  800f4b:	83 e8 04             	sub    $0x4,%eax
  800f4e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f50:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f53:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f5a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f61:	eb 1f                	jmp    800f82 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f63:	83 ec 08             	sub    $0x8,%esp
  800f66:	ff 75 e8             	pushl  -0x18(%ebp)
  800f69:	8d 45 14             	lea    0x14(%ebp),%eax
  800f6c:	50                   	push   %eax
  800f6d:	e8 e7 fb ff ff       	call   800b59 <getuint>
  800f72:	83 c4 10             	add    $0x10,%esp
  800f75:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f78:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f7b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f82:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f89:	83 ec 04             	sub    $0x4,%esp
  800f8c:	52                   	push   %edx
  800f8d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f90:	50                   	push   %eax
  800f91:	ff 75 f4             	pushl  -0xc(%ebp)
  800f94:	ff 75 f0             	pushl  -0x10(%ebp)
  800f97:	ff 75 0c             	pushl  0xc(%ebp)
  800f9a:	ff 75 08             	pushl  0x8(%ebp)
  800f9d:	e8 00 fb ff ff       	call   800aa2 <printnum>
  800fa2:	83 c4 20             	add    $0x20,%esp
			break;
  800fa5:	eb 34                	jmp    800fdb <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fa7:	83 ec 08             	sub    $0x8,%esp
  800faa:	ff 75 0c             	pushl  0xc(%ebp)
  800fad:	53                   	push   %ebx
  800fae:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb1:	ff d0                	call   *%eax
  800fb3:	83 c4 10             	add    $0x10,%esp
			break;
  800fb6:	eb 23                	jmp    800fdb <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fb8:	83 ec 08             	sub    $0x8,%esp
  800fbb:	ff 75 0c             	pushl  0xc(%ebp)
  800fbe:	6a 25                	push   $0x25
  800fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc3:	ff d0                	call   *%eax
  800fc5:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fc8:	ff 4d 10             	decl   0x10(%ebp)
  800fcb:	eb 03                	jmp    800fd0 <vprintfmt+0x3b1>
  800fcd:	ff 4d 10             	decl   0x10(%ebp)
  800fd0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd3:	48                   	dec    %eax
  800fd4:	8a 00                	mov    (%eax),%al
  800fd6:	3c 25                	cmp    $0x25,%al
  800fd8:	75 f3                	jne    800fcd <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800fda:	90                   	nop
		}
	}
  800fdb:	e9 47 fc ff ff       	jmp    800c27 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800fe0:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800fe1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fe4:	5b                   	pop    %ebx
  800fe5:	5e                   	pop    %esi
  800fe6:	5d                   	pop    %ebp
  800fe7:	c3                   	ret    

00800fe8 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800fe8:	55                   	push   %ebp
  800fe9:	89 e5                	mov    %esp,%ebp
  800feb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800fee:	8d 45 10             	lea    0x10(%ebp),%eax
  800ff1:	83 c0 04             	add    $0x4,%eax
  800ff4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ff7:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffa:	ff 75 f4             	pushl  -0xc(%ebp)
  800ffd:	50                   	push   %eax
  800ffe:	ff 75 0c             	pushl  0xc(%ebp)
  801001:	ff 75 08             	pushl  0x8(%ebp)
  801004:	e8 16 fc ff ff       	call   800c1f <vprintfmt>
  801009:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80100c:	90                   	nop
  80100d:	c9                   	leave  
  80100e:	c3                   	ret    

0080100f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80100f:	55                   	push   %ebp
  801010:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801012:	8b 45 0c             	mov    0xc(%ebp),%eax
  801015:	8b 40 08             	mov    0x8(%eax),%eax
  801018:	8d 50 01             	lea    0x1(%eax),%edx
  80101b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801021:	8b 45 0c             	mov    0xc(%ebp),%eax
  801024:	8b 10                	mov    (%eax),%edx
  801026:	8b 45 0c             	mov    0xc(%ebp),%eax
  801029:	8b 40 04             	mov    0x4(%eax),%eax
  80102c:	39 c2                	cmp    %eax,%edx
  80102e:	73 12                	jae    801042 <sprintputch+0x33>
		*b->buf++ = ch;
  801030:	8b 45 0c             	mov    0xc(%ebp),%eax
  801033:	8b 00                	mov    (%eax),%eax
  801035:	8d 48 01             	lea    0x1(%eax),%ecx
  801038:	8b 55 0c             	mov    0xc(%ebp),%edx
  80103b:	89 0a                	mov    %ecx,(%edx)
  80103d:	8b 55 08             	mov    0x8(%ebp),%edx
  801040:	88 10                	mov    %dl,(%eax)
}
  801042:	90                   	nop
  801043:	5d                   	pop    %ebp
  801044:	c3                   	ret    

00801045 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801045:	55                   	push   %ebp
  801046:	89 e5                	mov    %esp,%ebp
  801048:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80104b:	8b 45 08             	mov    0x8(%ebp),%eax
  80104e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801051:	8b 45 0c             	mov    0xc(%ebp),%eax
  801054:	8d 50 ff             	lea    -0x1(%eax),%edx
  801057:	8b 45 08             	mov    0x8(%ebp),%eax
  80105a:	01 d0                	add    %edx,%eax
  80105c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80105f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801066:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80106a:	74 06                	je     801072 <vsnprintf+0x2d>
  80106c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801070:	7f 07                	jg     801079 <vsnprintf+0x34>
		return -E_INVAL;
  801072:	b8 03 00 00 00       	mov    $0x3,%eax
  801077:	eb 20                	jmp    801099 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801079:	ff 75 14             	pushl  0x14(%ebp)
  80107c:	ff 75 10             	pushl  0x10(%ebp)
  80107f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801082:	50                   	push   %eax
  801083:	68 0f 10 80 00       	push   $0x80100f
  801088:	e8 92 fb ff ff       	call   800c1f <vprintfmt>
  80108d:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801090:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801093:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801096:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801099:	c9                   	leave  
  80109a:	c3                   	ret    

0080109b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80109b:	55                   	push   %ebp
  80109c:	89 e5                	mov    %esp,%ebp
  80109e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8010a1:	8d 45 10             	lea    0x10(%ebp),%eax
  8010a4:	83 c0 04             	add    $0x4,%eax
  8010a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8010aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8010b0:	50                   	push   %eax
  8010b1:	ff 75 0c             	pushl  0xc(%ebp)
  8010b4:	ff 75 08             	pushl  0x8(%ebp)
  8010b7:	e8 89 ff ff ff       	call   801045 <vsnprintf>
  8010bc:	83 c4 10             	add    $0x10,%esp
  8010bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8010c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010c5:	c9                   	leave  
  8010c6:	c3                   	ret    

008010c7 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8010c7:	55                   	push   %ebp
  8010c8:	89 e5                	mov    %esp,%ebp
  8010ca:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  8010cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010d1:	74 13                	je     8010e6 <readline+0x1f>
		cprintf("%s", prompt);
  8010d3:	83 ec 08             	sub    $0x8,%esp
  8010d6:	ff 75 08             	pushl  0x8(%ebp)
  8010d9:	68 10 41 80 00       	push   $0x804110
  8010de:	e8 62 f9 ff ff       	call   800a45 <cprintf>
  8010e3:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8010e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8010ed:	83 ec 0c             	sub    $0xc,%esp
  8010f0:	6a 00                	push   $0x0
  8010f2:	e8 54 f5 ff ff       	call   80064b <iscons>
  8010f7:	83 c4 10             	add    $0x10,%esp
  8010fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8010fd:	e8 fb f4 ff ff       	call   8005fd <getchar>
  801102:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801105:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801109:	79 22                	jns    80112d <readline+0x66>
			if (c != -E_EOF)
  80110b:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80110f:	0f 84 ad 00 00 00    	je     8011c2 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801115:	83 ec 08             	sub    $0x8,%esp
  801118:	ff 75 ec             	pushl  -0x14(%ebp)
  80111b:	68 13 41 80 00       	push   $0x804113
  801120:	e8 20 f9 ff ff       	call   800a45 <cprintf>
  801125:	83 c4 10             	add    $0x10,%esp
			return;
  801128:	e9 95 00 00 00       	jmp    8011c2 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80112d:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801131:	7e 34                	jle    801167 <readline+0xa0>
  801133:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80113a:	7f 2b                	jg     801167 <readline+0xa0>
			if (echoing)
  80113c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801140:	74 0e                	je     801150 <readline+0x89>
				cputchar(c);
  801142:	83 ec 0c             	sub    $0xc,%esp
  801145:	ff 75 ec             	pushl  -0x14(%ebp)
  801148:	e8 68 f4 ff ff       	call   8005b5 <cputchar>
  80114d:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801150:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801153:	8d 50 01             	lea    0x1(%eax),%edx
  801156:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801159:	89 c2                	mov    %eax,%edx
  80115b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115e:	01 d0                	add    %edx,%eax
  801160:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801163:	88 10                	mov    %dl,(%eax)
  801165:	eb 56                	jmp    8011bd <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801167:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80116b:	75 1f                	jne    80118c <readline+0xc5>
  80116d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801171:	7e 19                	jle    80118c <readline+0xc5>
			if (echoing)
  801173:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801177:	74 0e                	je     801187 <readline+0xc0>
				cputchar(c);
  801179:	83 ec 0c             	sub    $0xc,%esp
  80117c:	ff 75 ec             	pushl  -0x14(%ebp)
  80117f:	e8 31 f4 ff ff       	call   8005b5 <cputchar>
  801184:	83 c4 10             	add    $0x10,%esp

			i--;
  801187:	ff 4d f4             	decl   -0xc(%ebp)
  80118a:	eb 31                	jmp    8011bd <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  80118c:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801190:	74 0a                	je     80119c <readline+0xd5>
  801192:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801196:	0f 85 61 ff ff ff    	jne    8010fd <readline+0x36>
			if (echoing)
  80119c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011a0:	74 0e                	je     8011b0 <readline+0xe9>
				cputchar(c);
  8011a2:	83 ec 0c             	sub    $0xc,%esp
  8011a5:	ff 75 ec             	pushl  -0x14(%ebp)
  8011a8:	e8 08 f4 ff ff       	call   8005b5 <cputchar>
  8011ad:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8011b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b6:	01 d0                	add    %edx,%eax
  8011b8:	c6 00 00             	movb   $0x0,(%eax)
			return;
  8011bb:	eb 06                	jmp    8011c3 <readline+0xfc>
		}
	}
  8011bd:	e9 3b ff ff ff       	jmp    8010fd <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  8011c2:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  8011c3:	c9                   	leave  
  8011c4:	c3                   	ret    

008011c5 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8011c5:	55                   	push   %ebp
  8011c6:	89 e5                	mov    %esp,%ebp
  8011c8:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8011cb:	e8 04 0f 00 00       	call   8020d4 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  8011d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011d4:	74 13                	je     8011e9 <atomic_readline+0x24>
		cprintf("%s", prompt);
  8011d6:	83 ec 08             	sub    $0x8,%esp
  8011d9:	ff 75 08             	pushl  0x8(%ebp)
  8011dc:	68 10 41 80 00       	push   $0x804110
  8011e1:	e8 5f f8 ff ff       	call   800a45 <cprintf>
  8011e6:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8011e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8011f0:	83 ec 0c             	sub    $0xc,%esp
  8011f3:	6a 00                	push   $0x0
  8011f5:	e8 51 f4 ff ff       	call   80064b <iscons>
  8011fa:	83 c4 10             	add    $0x10,%esp
  8011fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801200:	e8 f8 f3 ff ff       	call   8005fd <getchar>
  801205:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801208:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80120c:	79 23                	jns    801231 <atomic_readline+0x6c>
			if (c != -E_EOF)
  80120e:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801212:	74 13                	je     801227 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  801214:	83 ec 08             	sub    $0x8,%esp
  801217:	ff 75 ec             	pushl  -0x14(%ebp)
  80121a:	68 13 41 80 00       	push   $0x804113
  80121f:	e8 21 f8 ff ff       	call   800a45 <cprintf>
  801224:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801227:	e8 c2 0e 00 00       	call   8020ee <sys_enable_interrupt>
			return;
  80122c:	e9 9a 00 00 00       	jmp    8012cb <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801231:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801235:	7e 34                	jle    80126b <atomic_readline+0xa6>
  801237:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80123e:	7f 2b                	jg     80126b <atomic_readline+0xa6>
			if (echoing)
  801240:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801244:	74 0e                	je     801254 <atomic_readline+0x8f>
				cputchar(c);
  801246:	83 ec 0c             	sub    $0xc,%esp
  801249:	ff 75 ec             	pushl  -0x14(%ebp)
  80124c:	e8 64 f3 ff ff       	call   8005b5 <cputchar>
  801251:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801254:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801257:	8d 50 01             	lea    0x1(%eax),%edx
  80125a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80125d:	89 c2                	mov    %eax,%edx
  80125f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801262:	01 d0                	add    %edx,%eax
  801264:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801267:	88 10                	mov    %dl,(%eax)
  801269:	eb 5b                	jmp    8012c6 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  80126b:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80126f:	75 1f                	jne    801290 <atomic_readline+0xcb>
  801271:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801275:	7e 19                	jle    801290 <atomic_readline+0xcb>
			if (echoing)
  801277:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80127b:	74 0e                	je     80128b <atomic_readline+0xc6>
				cputchar(c);
  80127d:	83 ec 0c             	sub    $0xc,%esp
  801280:	ff 75 ec             	pushl  -0x14(%ebp)
  801283:	e8 2d f3 ff ff       	call   8005b5 <cputchar>
  801288:	83 c4 10             	add    $0x10,%esp
			i--;
  80128b:	ff 4d f4             	decl   -0xc(%ebp)
  80128e:	eb 36                	jmp    8012c6 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  801290:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801294:	74 0a                	je     8012a0 <atomic_readline+0xdb>
  801296:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80129a:	0f 85 60 ff ff ff    	jne    801200 <atomic_readline+0x3b>
			if (echoing)
  8012a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012a4:	74 0e                	je     8012b4 <atomic_readline+0xef>
				cputchar(c);
  8012a6:	83 ec 0c             	sub    $0xc,%esp
  8012a9:	ff 75 ec             	pushl  -0x14(%ebp)
  8012ac:	e8 04 f3 ff ff       	call   8005b5 <cputchar>
  8012b1:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  8012b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ba:	01 d0                	add    %edx,%eax
  8012bc:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  8012bf:	e8 2a 0e 00 00       	call   8020ee <sys_enable_interrupt>
			return;
  8012c4:	eb 05                	jmp    8012cb <atomic_readline+0x106>
		}
	}
  8012c6:	e9 35 ff ff ff       	jmp    801200 <atomic_readline+0x3b>
}
  8012cb:	c9                   	leave  
  8012cc:	c3                   	ret    

008012cd <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8012cd:	55                   	push   %ebp
  8012ce:	89 e5                	mov    %esp,%ebp
  8012d0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8012d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012da:	eb 06                	jmp    8012e2 <strlen+0x15>
		n++;
  8012dc:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012df:	ff 45 08             	incl   0x8(%ebp)
  8012e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e5:	8a 00                	mov    (%eax),%al
  8012e7:	84 c0                	test   %al,%al
  8012e9:	75 f1                	jne    8012dc <strlen+0xf>
		n++;
	return n;
  8012eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012ee:	c9                   	leave  
  8012ef:	c3                   	ret    

008012f0 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8012f0:	55                   	push   %ebp
  8012f1:	89 e5                	mov    %esp,%ebp
  8012f3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012fd:	eb 09                	jmp    801308 <strnlen+0x18>
		n++;
  8012ff:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801302:	ff 45 08             	incl   0x8(%ebp)
  801305:	ff 4d 0c             	decl   0xc(%ebp)
  801308:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80130c:	74 09                	je     801317 <strnlen+0x27>
  80130e:	8b 45 08             	mov    0x8(%ebp),%eax
  801311:	8a 00                	mov    (%eax),%al
  801313:	84 c0                	test   %al,%al
  801315:	75 e8                	jne    8012ff <strnlen+0xf>
		n++;
	return n;
  801317:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80131a:	c9                   	leave  
  80131b:	c3                   	ret    

0080131c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80131c:	55                   	push   %ebp
  80131d:	89 e5                	mov    %esp,%ebp
  80131f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801322:	8b 45 08             	mov    0x8(%ebp),%eax
  801325:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801328:	90                   	nop
  801329:	8b 45 08             	mov    0x8(%ebp),%eax
  80132c:	8d 50 01             	lea    0x1(%eax),%edx
  80132f:	89 55 08             	mov    %edx,0x8(%ebp)
  801332:	8b 55 0c             	mov    0xc(%ebp),%edx
  801335:	8d 4a 01             	lea    0x1(%edx),%ecx
  801338:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80133b:	8a 12                	mov    (%edx),%dl
  80133d:	88 10                	mov    %dl,(%eax)
  80133f:	8a 00                	mov    (%eax),%al
  801341:	84 c0                	test   %al,%al
  801343:	75 e4                	jne    801329 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801345:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801348:	c9                   	leave  
  801349:	c3                   	ret    

0080134a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80134a:	55                   	push   %ebp
  80134b:	89 e5                	mov    %esp,%ebp
  80134d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801350:	8b 45 08             	mov    0x8(%ebp),%eax
  801353:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801356:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80135d:	eb 1f                	jmp    80137e <strncpy+0x34>
		*dst++ = *src;
  80135f:	8b 45 08             	mov    0x8(%ebp),%eax
  801362:	8d 50 01             	lea    0x1(%eax),%edx
  801365:	89 55 08             	mov    %edx,0x8(%ebp)
  801368:	8b 55 0c             	mov    0xc(%ebp),%edx
  80136b:	8a 12                	mov    (%edx),%dl
  80136d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80136f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801372:	8a 00                	mov    (%eax),%al
  801374:	84 c0                	test   %al,%al
  801376:	74 03                	je     80137b <strncpy+0x31>
			src++;
  801378:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80137b:	ff 45 fc             	incl   -0x4(%ebp)
  80137e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801381:	3b 45 10             	cmp    0x10(%ebp),%eax
  801384:	72 d9                	jb     80135f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801386:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801389:	c9                   	leave  
  80138a:	c3                   	ret    

0080138b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80138b:	55                   	push   %ebp
  80138c:	89 e5                	mov    %esp,%ebp
  80138e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801391:	8b 45 08             	mov    0x8(%ebp),%eax
  801394:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801397:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80139b:	74 30                	je     8013cd <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80139d:	eb 16                	jmp    8013b5 <strlcpy+0x2a>
			*dst++ = *src++;
  80139f:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a2:	8d 50 01             	lea    0x1(%eax),%edx
  8013a5:	89 55 08             	mov    %edx,0x8(%ebp)
  8013a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013ab:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013ae:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013b1:	8a 12                	mov    (%edx),%dl
  8013b3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013b5:	ff 4d 10             	decl   0x10(%ebp)
  8013b8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013bc:	74 09                	je     8013c7 <strlcpy+0x3c>
  8013be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c1:	8a 00                	mov    (%eax),%al
  8013c3:	84 c0                	test   %al,%al
  8013c5:	75 d8                	jne    80139f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8013c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ca:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8013cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8013d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013d3:	29 c2                	sub    %eax,%edx
  8013d5:	89 d0                	mov    %edx,%eax
}
  8013d7:	c9                   	leave  
  8013d8:	c3                   	ret    

008013d9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013d9:	55                   	push   %ebp
  8013da:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8013dc:	eb 06                	jmp    8013e4 <strcmp+0xb>
		p++, q++;
  8013de:	ff 45 08             	incl   0x8(%ebp)
  8013e1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e7:	8a 00                	mov    (%eax),%al
  8013e9:	84 c0                	test   %al,%al
  8013eb:	74 0e                	je     8013fb <strcmp+0x22>
  8013ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f0:	8a 10                	mov    (%eax),%dl
  8013f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f5:	8a 00                	mov    (%eax),%al
  8013f7:	38 c2                	cmp    %al,%dl
  8013f9:	74 e3                	je     8013de <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fe:	8a 00                	mov    (%eax),%al
  801400:	0f b6 d0             	movzbl %al,%edx
  801403:	8b 45 0c             	mov    0xc(%ebp),%eax
  801406:	8a 00                	mov    (%eax),%al
  801408:	0f b6 c0             	movzbl %al,%eax
  80140b:	29 c2                	sub    %eax,%edx
  80140d:	89 d0                	mov    %edx,%eax
}
  80140f:	5d                   	pop    %ebp
  801410:	c3                   	ret    

00801411 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801411:	55                   	push   %ebp
  801412:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801414:	eb 09                	jmp    80141f <strncmp+0xe>
		n--, p++, q++;
  801416:	ff 4d 10             	decl   0x10(%ebp)
  801419:	ff 45 08             	incl   0x8(%ebp)
  80141c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80141f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801423:	74 17                	je     80143c <strncmp+0x2b>
  801425:	8b 45 08             	mov    0x8(%ebp),%eax
  801428:	8a 00                	mov    (%eax),%al
  80142a:	84 c0                	test   %al,%al
  80142c:	74 0e                	je     80143c <strncmp+0x2b>
  80142e:	8b 45 08             	mov    0x8(%ebp),%eax
  801431:	8a 10                	mov    (%eax),%dl
  801433:	8b 45 0c             	mov    0xc(%ebp),%eax
  801436:	8a 00                	mov    (%eax),%al
  801438:	38 c2                	cmp    %al,%dl
  80143a:	74 da                	je     801416 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80143c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801440:	75 07                	jne    801449 <strncmp+0x38>
		return 0;
  801442:	b8 00 00 00 00       	mov    $0x0,%eax
  801447:	eb 14                	jmp    80145d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801449:	8b 45 08             	mov    0x8(%ebp),%eax
  80144c:	8a 00                	mov    (%eax),%al
  80144e:	0f b6 d0             	movzbl %al,%edx
  801451:	8b 45 0c             	mov    0xc(%ebp),%eax
  801454:	8a 00                	mov    (%eax),%al
  801456:	0f b6 c0             	movzbl %al,%eax
  801459:	29 c2                	sub    %eax,%edx
  80145b:	89 d0                	mov    %edx,%eax
}
  80145d:	5d                   	pop    %ebp
  80145e:	c3                   	ret    

0080145f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80145f:	55                   	push   %ebp
  801460:	89 e5                	mov    %esp,%ebp
  801462:	83 ec 04             	sub    $0x4,%esp
  801465:	8b 45 0c             	mov    0xc(%ebp),%eax
  801468:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80146b:	eb 12                	jmp    80147f <strchr+0x20>
		if (*s == c)
  80146d:	8b 45 08             	mov    0x8(%ebp),%eax
  801470:	8a 00                	mov    (%eax),%al
  801472:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801475:	75 05                	jne    80147c <strchr+0x1d>
			return (char *) s;
  801477:	8b 45 08             	mov    0x8(%ebp),%eax
  80147a:	eb 11                	jmp    80148d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80147c:	ff 45 08             	incl   0x8(%ebp)
  80147f:	8b 45 08             	mov    0x8(%ebp),%eax
  801482:	8a 00                	mov    (%eax),%al
  801484:	84 c0                	test   %al,%al
  801486:	75 e5                	jne    80146d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801488:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80148d:	c9                   	leave  
  80148e:	c3                   	ret    

0080148f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80148f:	55                   	push   %ebp
  801490:	89 e5                	mov    %esp,%ebp
  801492:	83 ec 04             	sub    $0x4,%esp
  801495:	8b 45 0c             	mov    0xc(%ebp),%eax
  801498:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80149b:	eb 0d                	jmp    8014aa <strfind+0x1b>
		if (*s == c)
  80149d:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a0:	8a 00                	mov    (%eax),%al
  8014a2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8014a5:	74 0e                	je     8014b5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8014a7:	ff 45 08             	incl   0x8(%ebp)
  8014aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ad:	8a 00                	mov    (%eax),%al
  8014af:	84 c0                	test   %al,%al
  8014b1:	75 ea                	jne    80149d <strfind+0xe>
  8014b3:	eb 01                	jmp    8014b6 <strfind+0x27>
		if (*s == c)
			break;
  8014b5:	90                   	nop
	return (char *) s;
  8014b6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014b9:	c9                   	leave  
  8014ba:	c3                   	ret    

008014bb <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8014bb:	55                   	push   %ebp
  8014bc:	89 e5                	mov    %esp,%ebp
  8014be:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8014c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8014c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ca:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8014cd:	eb 0e                	jmp    8014dd <memset+0x22>
		*p++ = c;
  8014cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014d2:	8d 50 01             	lea    0x1(%eax),%edx
  8014d5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014db:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8014dd:	ff 4d f8             	decl   -0x8(%ebp)
  8014e0:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8014e4:	79 e9                	jns    8014cf <memset+0x14>
		*p++ = c;

	return v;
  8014e6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014e9:	c9                   	leave  
  8014ea:	c3                   	ret    

008014eb <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8014eb:	55                   	push   %ebp
  8014ec:	89 e5                	mov    %esp,%ebp
  8014ee:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8014fd:	eb 16                	jmp    801515 <memcpy+0x2a>
		*d++ = *s++;
  8014ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801502:	8d 50 01             	lea    0x1(%eax),%edx
  801505:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801508:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80150b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80150e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801511:	8a 12                	mov    (%edx),%dl
  801513:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801515:	8b 45 10             	mov    0x10(%ebp),%eax
  801518:	8d 50 ff             	lea    -0x1(%eax),%edx
  80151b:	89 55 10             	mov    %edx,0x10(%ebp)
  80151e:	85 c0                	test   %eax,%eax
  801520:	75 dd                	jne    8014ff <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801522:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801525:	c9                   	leave  
  801526:	c3                   	ret    

00801527 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801527:	55                   	push   %ebp
  801528:	89 e5                	mov    %esp,%ebp
  80152a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80152d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801530:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801533:	8b 45 08             	mov    0x8(%ebp),%eax
  801536:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801539:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80153c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80153f:	73 50                	jae    801591 <memmove+0x6a>
  801541:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801544:	8b 45 10             	mov    0x10(%ebp),%eax
  801547:	01 d0                	add    %edx,%eax
  801549:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80154c:	76 43                	jbe    801591 <memmove+0x6a>
		s += n;
  80154e:	8b 45 10             	mov    0x10(%ebp),%eax
  801551:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801554:	8b 45 10             	mov    0x10(%ebp),%eax
  801557:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80155a:	eb 10                	jmp    80156c <memmove+0x45>
			*--d = *--s;
  80155c:	ff 4d f8             	decl   -0x8(%ebp)
  80155f:	ff 4d fc             	decl   -0x4(%ebp)
  801562:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801565:	8a 10                	mov    (%eax),%dl
  801567:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80156a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80156c:	8b 45 10             	mov    0x10(%ebp),%eax
  80156f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801572:	89 55 10             	mov    %edx,0x10(%ebp)
  801575:	85 c0                	test   %eax,%eax
  801577:	75 e3                	jne    80155c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801579:	eb 23                	jmp    80159e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80157b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80157e:	8d 50 01             	lea    0x1(%eax),%edx
  801581:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801584:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801587:	8d 4a 01             	lea    0x1(%edx),%ecx
  80158a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80158d:	8a 12                	mov    (%edx),%dl
  80158f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801591:	8b 45 10             	mov    0x10(%ebp),%eax
  801594:	8d 50 ff             	lea    -0x1(%eax),%edx
  801597:	89 55 10             	mov    %edx,0x10(%ebp)
  80159a:	85 c0                	test   %eax,%eax
  80159c:	75 dd                	jne    80157b <memmove+0x54>
			*d++ = *s++;

	return dst;
  80159e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015a1:	c9                   	leave  
  8015a2:	c3                   	ret    

008015a3 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8015a3:	55                   	push   %ebp
  8015a4:	89 e5                	mov    %esp,%ebp
  8015a6:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8015a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8015af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8015b5:	eb 2a                	jmp    8015e1 <memcmp+0x3e>
		if (*s1 != *s2)
  8015b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015ba:	8a 10                	mov    (%eax),%dl
  8015bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015bf:	8a 00                	mov    (%eax),%al
  8015c1:	38 c2                	cmp    %al,%dl
  8015c3:	74 16                	je     8015db <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8015c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015c8:	8a 00                	mov    (%eax),%al
  8015ca:	0f b6 d0             	movzbl %al,%edx
  8015cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015d0:	8a 00                	mov    (%eax),%al
  8015d2:	0f b6 c0             	movzbl %al,%eax
  8015d5:	29 c2                	sub    %eax,%edx
  8015d7:	89 d0                	mov    %edx,%eax
  8015d9:	eb 18                	jmp    8015f3 <memcmp+0x50>
		s1++, s2++;
  8015db:	ff 45 fc             	incl   -0x4(%ebp)
  8015de:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8015e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015e7:	89 55 10             	mov    %edx,0x10(%ebp)
  8015ea:	85 c0                	test   %eax,%eax
  8015ec:	75 c9                	jne    8015b7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015f3:	c9                   	leave  
  8015f4:	c3                   	ret    

008015f5 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8015f5:	55                   	push   %ebp
  8015f6:	89 e5                	mov    %esp,%ebp
  8015f8:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8015fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8015fe:	8b 45 10             	mov    0x10(%ebp),%eax
  801601:	01 d0                	add    %edx,%eax
  801603:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801606:	eb 15                	jmp    80161d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801608:	8b 45 08             	mov    0x8(%ebp),%eax
  80160b:	8a 00                	mov    (%eax),%al
  80160d:	0f b6 d0             	movzbl %al,%edx
  801610:	8b 45 0c             	mov    0xc(%ebp),%eax
  801613:	0f b6 c0             	movzbl %al,%eax
  801616:	39 c2                	cmp    %eax,%edx
  801618:	74 0d                	je     801627 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80161a:	ff 45 08             	incl   0x8(%ebp)
  80161d:	8b 45 08             	mov    0x8(%ebp),%eax
  801620:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801623:	72 e3                	jb     801608 <memfind+0x13>
  801625:	eb 01                	jmp    801628 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801627:	90                   	nop
	return (void *) s;
  801628:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80162b:	c9                   	leave  
  80162c:	c3                   	ret    

0080162d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80162d:	55                   	push   %ebp
  80162e:	89 e5                	mov    %esp,%ebp
  801630:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801633:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80163a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801641:	eb 03                	jmp    801646 <strtol+0x19>
		s++;
  801643:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801646:	8b 45 08             	mov    0x8(%ebp),%eax
  801649:	8a 00                	mov    (%eax),%al
  80164b:	3c 20                	cmp    $0x20,%al
  80164d:	74 f4                	je     801643 <strtol+0x16>
  80164f:	8b 45 08             	mov    0x8(%ebp),%eax
  801652:	8a 00                	mov    (%eax),%al
  801654:	3c 09                	cmp    $0x9,%al
  801656:	74 eb                	je     801643 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801658:	8b 45 08             	mov    0x8(%ebp),%eax
  80165b:	8a 00                	mov    (%eax),%al
  80165d:	3c 2b                	cmp    $0x2b,%al
  80165f:	75 05                	jne    801666 <strtol+0x39>
		s++;
  801661:	ff 45 08             	incl   0x8(%ebp)
  801664:	eb 13                	jmp    801679 <strtol+0x4c>
	else if (*s == '-')
  801666:	8b 45 08             	mov    0x8(%ebp),%eax
  801669:	8a 00                	mov    (%eax),%al
  80166b:	3c 2d                	cmp    $0x2d,%al
  80166d:	75 0a                	jne    801679 <strtol+0x4c>
		s++, neg = 1;
  80166f:	ff 45 08             	incl   0x8(%ebp)
  801672:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801679:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80167d:	74 06                	je     801685 <strtol+0x58>
  80167f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801683:	75 20                	jne    8016a5 <strtol+0x78>
  801685:	8b 45 08             	mov    0x8(%ebp),%eax
  801688:	8a 00                	mov    (%eax),%al
  80168a:	3c 30                	cmp    $0x30,%al
  80168c:	75 17                	jne    8016a5 <strtol+0x78>
  80168e:	8b 45 08             	mov    0x8(%ebp),%eax
  801691:	40                   	inc    %eax
  801692:	8a 00                	mov    (%eax),%al
  801694:	3c 78                	cmp    $0x78,%al
  801696:	75 0d                	jne    8016a5 <strtol+0x78>
		s += 2, base = 16;
  801698:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80169c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8016a3:	eb 28                	jmp    8016cd <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8016a5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016a9:	75 15                	jne    8016c0 <strtol+0x93>
  8016ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ae:	8a 00                	mov    (%eax),%al
  8016b0:	3c 30                	cmp    $0x30,%al
  8016b2:	75 0c                	jne    8016c0 <strtol+0x93>
		s++, base = 8;
  8016b4:	ff 45 08             	incl   0x8(%ebp)
  8016b7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8016be:	eb 0d                	jmp    8016cd <strtol+0xa0>
	else if (base == 0)
  8016c0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016c4:	75 07                	jne    8016cd <strtol+0xa0>
		base = 10;
  8016c6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d0:	8a 00                	mov    (%eax),%al
  8016d2:	3c 2f                	cmp    $0x2f,%al
  8016d4:	7e 19                	jle    8016ef <strtol+0xc2>
  8016d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d9:	8a 00                	mov    (%eax),%al
  8016db:	3c 39                	cmp    $0x39,%al
  8016dd:	7f 10                	jg     8016ef <strtol+0xc2>
			dig = *s - '0';
  8016df:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e2:	8a 00                	mov    (%eax),%al
  8016e4:	0f be c0             	movsbl %al,%eax
  8016e7:	83 e8 30             	sub    $0x30,%eax
  8016ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016ed:	eb 42                	jmp    801731 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	8a 00                	mov    (%eax),%al
  8016f4:	3c 60                	cmp    $0x60,%al
  8016f6:	7e 19                	jle    801711 <strtol+0xe4>
  8016f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fb:	8a 00                	mov    (%eax),%al
  8016fd:	3c 7a                	cmp    $0x7a,%al
  8016ff:	7f 10                	jg     801711 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801701:	8b 45 08             	mov    0x8(%ebp),%eax
  801704:	8a 00                	mov    (%eax),%al
  801706:	0f be c0             	movsbl %al,%eax
  801709:	83 e8 57             	sub    $0x57,%eax
  80170c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80170f:	eb 20                	jmp    801731 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801711:	8b 45 08             	mov    0x8(%ebp),%eax
  801714:	8a 00                	mov    (%eax),%al
  801716:	3c 40                	cmp    $0x40,%al
  801718:	7e 39                	jle    801753 <strtol+0x126>
  80171a:	8b 45 08             	mov    0x8(%ebp),%eax
  80171d:	8a 00                	mov    (%eax),%al
  80171f:	3c 5a                	cmp    $0x5a,%al
  801721:	7f 30                	jg     801753 <strtol+0x126>
			dig = *s - 'A' + 10;
  801723:	8b 45 08             	mov    0x8(%ebp),%eax
  801726:	8a 00                	mov    (%eax),%al
  801728:	0f be c0             	movsbl %al,%eax
  80172b:	83 e8 37             	sub    $0x37,%eax
  80172e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801731:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801734:	3b 45 10             	cmp    0x10(%ebp),%eax
  801737:	7d 19                	jge    801752 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801739:	ff 45 08             	incl   0x8(%ebp)
  80173c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80173f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801743:	89 c2                	mov    %eax,%edx
  801745:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801748:	01 d0                	add    %edx,%eax
  80174a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80174d:	e9 7b ff ff ff       	jmp    8016cd <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801752:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801753:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801757:	74 08                	je     801761 <strtol+0x134>
		*endptr = (char *) s;
  801759:	8b 45 0c             	mov    0xc(%ebp),%eax
  80175c:	8b 55 08             	mov    0x8(%ebp),%edx
  80175f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801761:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801765:	74 07                	je     80176e <strtol+0x141>
  801767:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80176a:	f7 d8                	neg    %eax
  80176c:	eb 03                	jmp    801771 <strtol+0x144>
  80176e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801771:	c9                   	leave  
  801772:	c3                   	ret    

00801773 <ltostr>:

void
ltostr(long value, char *str)
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
  801776:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801779:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801780:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801787:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80178b:	79 13                	jns    8017a0 <ltostr+0x2d>
	{
		neg = 1;
  80178d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801794:	8b 45 0c             	mov    0xc(%ebp),%eax
  801797:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80179a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80179d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8017a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a3:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8017a8:	99                   	cltd   
  8017a9:	f7 f9                	idiv   %ecx
  8017ab:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8017ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017b1:	8d 50 01             	lea    0x1(%eax),%edx
  8017b4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017b7:	89 c2                	mov    %eax,%edx
  8017b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017bc:	01 d0                	add    %edx,%eax
  8017be:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017c1:	83 c2 30             	add    $0x30,%edx
  8017c4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8017c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017c9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8017ce:	f7 e9                	imul   %ecx
  8017d0:	c1 fa 02             	sar    $0x2,%edx
  8017d3:	89 c8                	mov    %ecx,%eax
  8017d5:	c1 f8 1f             	sar    $0x1f,%eax
  8017d8:	29 c2                	sub    %eax,%edx
  8017da:	89 d0                	mov    %edx,%eax
  8017dc:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8017df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017e2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8017e7:	f7 e9                	imul   %ecx
  8017e9:	c1 fa 02             	sar    $0x2,%edx
  8017ec:	89 c8                	mov    %ecx,%eax
  8017ee:	c1 f8 1f             	sar    $0x1f,%eax
  8017f1:	29 c2                	sub    %eax,%edx
  8017f3:	89 d0                	mov    %edx,%eax
  8017f5:	c1 e0 02             	shl    $0x2,%eax
  8017f8:	01 d0                	add    %edx,%eax
  8017fa:	01 c0                	add    %eax,%eax
  8017fc:	29 c1                	sub    %eax,%ecx
  8017fe:	89 ca                	mov    %ecx,%edx
  801800:	85 d2                	test   %edx,%edx
  801802:	75 9c                	jne    8017a0 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801804:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80180b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80180e:	48                   	dec    %eax
  80180f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801812:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801816:	74 3d                	je     801855 <ltostr+0xe2>
		start = 1 ;
  801818:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80181f:	eb 34                	jmp    801855 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801821:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801824:	8b 45 0c             	mov    0xc(%ebp),%eax
  801827:	01 d0                	add    %edx,%eax
  801829:	8a 00                	mov    (%eax),%al
  80182b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80182e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801831:	8b 45 0c             	mov    0xc(%ebp),%eax
  801834:	01 c2                	add    %eax,%edx
  801836:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801839:	8b 45 0c             	mov    0xc(%ebp),%eax
  80183c:	01 c8                	add    %ecx,%eax
  80183e:	8a 00                	mov    (%eax),%al
  801840:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801842:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801845:	8b 45 0c             	mov    0xc(%ebp),%eax
  801848:	01 c2                	add    %eax,%edx
  80184a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80184d:	88 02                	mov    %al,(%edx)
		start++ ;
  80184f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801852:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801855:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801858:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80185b:	7c c4                	jl     801821 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80185d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801860:	8b 45 0c             	mov    0xc(%ebp),%eax
  801863:	01 d0                	add    %edx,%eax
  801865:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801868:	90                   	nop
  801869:	c9                   	leave  
  80186a:	c3                   	ret    

0080186b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80186b:	55                   	push   %ebp
  80186c:	89 e5                	mov    %esp,%ebp
  80186e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801871:	ff 75 08             	pushl  0x8(%ebp)
  801874:	e8 54 fa ff ff       	call   8012cd <strlen>
  801879:	83 c4 04             	add    $0x4,%esp
  80187c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80187f:	ff 75 0c             	pushl  0xc(%ebp)
  801882:	e8 46 fa ff ff       	call   8012cd <strlen>
  801887:	83 c4 04             	add    $0x4,%esp
  80188a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80188d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801894:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80189b:	eb 17                	jmp    8018b4 <strcconcat+0x49>
		final[s] = str1[s] ;
  80189d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a3:	01 c2                	add    %eax,%edx
  8018a5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8018a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ab:	01 c8                	add    %ecx,%eax
  8018ad:	8a 00                	mov    (%eax),%al
  8018af:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8018b1:	ff 45 fc             	incl   -0x4(%ebp)
  8018b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018b7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8018ba:	7c e1                	jl     80189d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8018bc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8018c3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8018ca:	eb 1f                	jmp    8018eb <strcconcat+0x80>
		final[s++] = str2[i] ;
  8018cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018cf:	8d 50 01             	lea    0x1(%eax),%edx
  8018d2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8018d5:	89 c2                	mov    %eax,%edx
  8018d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8018da:	01 c2                	add    %eax,%edx
  8018dc:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8018df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e2:	01 c8                	add    %ecx,%eax
  8018e4:	8a 00                	mov    (%eax),%al
  8018e6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8018e8:	ff 45 f8             	incl   -0x8(%ebp)
  8018eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018ee:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018f1:	7c d9                	jl     8018cc <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8018f3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f9:	01 d0                	add    %edx,%eax
  8018fb:	c6 00 00             	movb   $0x0,(%eax)
}
  8018fe:	90                   	nop
  8018ff:	c9                   	leave  
  801900:	c3                   	ret    

00801901 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801901:	55                   	push   %ebp
  801902:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801904:	8b 45 14             	mov    0x14(%ebp),%eax
  801907:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80190d:	8b 45 14             	mov    0x14(%ebp),%eax
  801910:	8b 00                	mov    (%eax),%eax
  801912:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801919:	8b 45 10             	mov    0x10(%ebp),%eax
  80191c:	01 d0                	add    %edx,%eax
  80191e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801924:	eb 0c                	jmp    801932 <strsplit+0x31>
			*string++ = 0;
  801926:	8b 45 08             	mov    0x8(%ebp),%eax
  801929:	8d 50 01             	lea    0x1(%eax),%edx
  80192c:	89 55 08             	mov    %edx,0x8(%ebp)
  80192f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801932:	8b 45 08             	mov    0x8(%ebp),%eax
  801935:	8a 00                	mov    (%eax),%al
  801937:	84 c0                	test   %al,%al
  801939:	74 18                	je     801953 <strsplit+0x52>
  80193b:	8b 45 08             	mov    0x8(%ebp),%eax
  80193e:	8a 00                	mov    (%eax),%al
  801940:	0f be c0             	movsbl %al,%eax
  801943:	50                   	push   %eax
  801944:	ff 75 0c             	pushl  0xc(%ebp)
  801947:	e8 13 fb ff ff       	call   80145f <strchr>
  80194c:	83 c4 08             	add    $0x8,%esp
  80194f:	85 c0                	test   %eax,%eax
  801951:	75 d3                	jne    801926 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801953:	8b 45 08             	mov    0x8(%ebp),%eax
  801956:	8a 00                	mov    (%eax),%al
  801958:	84 c0                	test   %al,%al
  80195a:	74 5a                	je     8019b6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80195c:	8b 45 14             	mov    0x14(%ebp),%eax
  80195f:	8b 00                	mov    (%eax),%eax
  801961:	83 f8 0f             	cmp    $0xf,%eax
  801964:	75 07                	jne    80196d <strsplit+0x6c>
		{
			return 0;
  801966:	b8 00 00 00 00       	mov    $0x0,%eax
  80196b:	eb 66                	jmp    8019d3 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80196d:	8b 45 14             	mov    0x14(%ebp),%eax
  801970:	8b 00                	mov    (%eax),%eax
  801972:	8d 48 01             	lea    0x1(%eax),%ecx
  801975:	8b 55 14             	mov    0x14(%ebp),%edx
  801978:	89 0a                	mov    %ecx,(%edx)
  80197a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801981:	8b 45 10             	mov    0x10(%ebp),%eax
  801984:	01 c2                	add    %eax,%edx
  801986:	8b 45 08             	mov    0x8(%ebp),%eax
  801989:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80198b:	eb 03                	jmp    801990 <strsplit+0x8f>
			string++;
  80198d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801990:	8b 45 08             	mov    0x8(%ebp),%eax
  801993:	8a 00                	mov    (%eax),%al
  801995:	84 c0                	test   %al,%al
  801997:	74 8b                	je     801924 <strsplit+0x23>
  801999:	8b 45 08             	mov    0x8(%ebp),%eax
  80199c:	8a 00                	mov    (%eax),%al
  80199e:	0f be c0             	movsbl %al,%eax
  8019a1:	50                   	push   %eax
  8019a2:	ff 75 0c             	pushl  0xc(%ebp)
  8019a5:	e8 b5 fa ff ff       	call   80145f <strchr>
  8019aa:	83 c4 08             	add    $0x8,%esp
  8019ad:	85 c0                	test   %eax,%eax
  8019af:	74 dc                	je     80198d <strsplit+0x8c>
			string++;
	}
  8019b1:	e9 6e ff ff ff       	jmp    801924 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8019b6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8019b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ba:	8b 00                	mov    (%eax),%eax
  8019bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c6:	01 d0                	add    %edx,%eax
  8019c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8019ce:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8019d3:	c9                   	leave  
  8019d4:	c3                   	ret    

008019d5 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8019d5:	55                   	push   %ebp
  8019d6:	89 e5                	mov    %esp,%ebp
  8019d8:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8019db:	a1 04 50 80 00       	mov    0x805004,%eax
  8019e0:	85 c0                	test   %eax,%eax
  8019e2:	74 1f                	je     801a03 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8019e4:	e8 1d 00 00 00       	call   801a06 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8019e9:	83 ec 0c             	sub    $0xc,%esp
  8019ec:	68 24 41 80 00       	push   $0x804124
  8019f1:	e8 4f f0 ff ff       	call   800a45 <cprintf>
  8019f6:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8019f9:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801a00:	00 00 00 
	}
}
  801a03:	90                   	nop
  801a04:	c9                   	leave  
  801a05:	c3                   	ret    

00801a06 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
  801a09:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801a0c:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801a13:	00 00 00 
  801a16:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801a1d:	00 00 00 
  801a20:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801a27:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  801a2a:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801a31:	00 00 00 
  801a34:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801a3b:	00 00 00 
  801a3e:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801a45:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801a48:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801a4f:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801a52:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a5c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a61:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a66:	a3 50 50 80 00       	mov    %eax,0x805050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  801a6b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801a72:	a1 20 51 80 00       	mov    0x805120,%eax
  801a77:	c1 e0 04             	shl    $0x4,%eax
  801a7a:	89 c2                	mov    %eax,%edx
  801a7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a7f:	01 d0                	add    %edx,%eax
  801a81:	48                   	dec    %eax
  801a82:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801a85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a88:	ba 00 00 00 00       	mov    $0x0,%edx
  801a8d:	f7 75 f0             	divl   -0x10(%ebp)
  801a90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a93:	29 d0                	sub    %edx,%eax
  801a95:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  801a98:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801a9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801aa2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801aa7:	2d 00 10 00 00       	sub    $0x1000,%eax
  801aac:	83 ec 04             	sub    $0x4,%esp
  801aaf:	6a 06                	push   $0x6
  801ab1:	ff 75 e8             	pushl  -0x18(%ebp)
  801ab4:	50                   	push   %eax
  801ab5:	e8 b0 05 00 00       	call   80206a <sys_allocate_chunk>
  801aba:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801abd:	a1 20 51 80 00       	mov    0x805120,%eax
  801ac2:	83 ec 0c             	sub    $0xc,%esp
  801ac5:	50                   	push   %eax
  801ac6:	e8 25 0c 00 00       	call   8026f0 <initialize_MemBlocksList>
  801acb:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  801ace:	a1 48 51 80 00       	mov    0x805148,%eax
  801ad3:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  801ad6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ada:	75 14                	jne    801af0 <initialize_dyn_block_system+0xea>
  801adc:	83 ec 04             	sub    $0x4,%esp
  801adf:	68 49 41 80 00       	push   $0x804149
  801ae4:	6a 29                	push   $0x29
  801ae6:	68 67 41 80 00       	push   $0x804167
  801aeb:	e8 a1 ec ff ff       	call   800791 <_panic>
  801af0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801af3:	8b 00                	mov    (%eax),%eax
  801af5:	85 c0                	test   %eax,%eax
  801af7:	74 10                	je     801b09 <initialize_dyn_block_system+0x103>
  801af9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801afc:	8b 00                	mov    (%eax),%eax
  801afe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b01:	8b 52 04             	mov    0x4(%edx),%edx
  801b04:	89 50 04             	mov    %edx,0x4(%eax)
  801b07:	eb 0b                	jmp    801b14 <initialize_dyn_block_system+0x10e>
  801b09:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b0c:	8b 40 04             	mov    0x4(%eax),%eax
  801b0f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801b14:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b17:	8b 40 04             	mov    0x4(%eax),%eax
  801b1a:	85 c0                	test   %eax,%eax
  801b1c:	74 0f                	je     801b2d <initialize_dyn_block_system+0x127>
  801b1e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b21:	8b 40 04             	mov    0x4(%eax),%eax
  801b24:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801b27:	8b 12                	mov    (%edx),%edx
  801b29:	89 10                	mov    %edx,(%eax)
  801b2b:	eb 0a                	jmp    801b37 <initialize_dyn_block_system+0x131>
  801b2d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b30:	8b 00                	mov    (%eax),%eax
  801b32:	a3 48 51 80 00       	mov    %eax,0x805148
  801b37:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b3a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801b40:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b43:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801b4a:	a1 54 51 80 00       	mov    0x805154,%eax
  801b4f:	48                   	dec    %eax
  801b50:	a3 54 51 80 00       	mov    %eax,0x805154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  801b55:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b58:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  801b5f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b62:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  801b69:	83 ec 0c             	sub    $0xc,%esp
  801b6c:	ff 75 e0             	pushl  -0x20(%ebp)
  801b6f:	e8 b9 14 00 00       	call   80302d <insert_sorted_with_merge_freeList>
  801b74:	83 c4 10             	add    $0x10,%esp

}
  801b77:	90                   	nop
  801b78:	c9                   	leave  
  801b79:	c3                   	ret    

00801b7a <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
  801b7d:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b80:	e8 50 fe ff ff       	call   8019d5 <InitializeUHeap>
	if (size == 0) return NULL ;
  801b85:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b89:	75 07                	jne    801b92 <malloc+0x18>
  801b8b:	b8 00 00 00 00       	mov    $0x0,%eax
  801b90:	eb 68                	jmp    801bfa <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  801b92:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801b99:	8b 55 08             	mov    0x8(%ebp),%edx
  801b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b9f:	01 d0                	add    %edx,%eax
  801ba1:	48                   	dec    %eax
  801ba2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ba5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ba8:	ba 00 00 00 00       	mov    $0x0,%edx
  801bad:	f7 75 f4             	divl   -0xc(%ebp)
  801bb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bb3:	29 d0                	sub    %edx,%eax
  801bb5:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  801bb8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801bbf:	e8 74 08 00 00       	call   802438 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801bc4:	85 c0                	test   %eax,%eax
  801bc6:	74 2d                	je     801bf5 <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  801bc8:	83 ec 0c             	sub    $0xc,%esp
  801bcb:	ff 75 ec             	pushl  -0x14(%ebp)
  801bce:	e8 52 0e 00 00       	call   802a25 <alloc_block_FF>
  801bd3:	83 c4 10             	add    $0x10,%esp
  801bd6:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  801bd9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801bdd:	74 16                	je     801bf5 <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  801bdf:	83 ec 0c             	sub    $0xc,%esp
  801be2:	ff 75 e8             	pushl  -0x18(%ebp)
  801be5:	e8 3b 0c 00 00       	call   802825 <insert_sorted_allocList>
  801bea:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  801bed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bf0:	8b 40 08             	mov    0x8(%eax),%eax
  801bf3:	eb 05                	jmp    801bfa <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  801bf5:	b8 00 00 00 00       	mov    $0x0,%eax

}
  801bfa:	c9                   	leave  
  801bfb:	c3                   	ret    

00801bfc <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
  801bff:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  801c02:	8b 45 08             	mov    0x8(%ebp),%eax
  801c05:	83 ec 08             	sub    $0x8,%esp
  801c08:	50                   	push   %eax
  801c09:	68 40 50 80 00       	push   $0x805040
  801c0e:	e8 ba 0b 00 00       	call   8027cd <find_block>
  801c13:	83 c4 10             	add    $0x10,%esp
  801c16:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  801c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c1c:	8b 40 0c             	mov    0xc(%eax),%eax
  801c1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  801c22:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c26:	0f 84 9f 00 00 00    	je     801ccb <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  801c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2f:	83 ec 08             	sub    $0x8,%esp
  801c32:	ff 75 f0             	pushl  -0x10(%ebp)
  801c35:	50                   	push   %eax
  801c36:	e8 f7 03 00 00       	call   802032 <sys_free_user_mem>
  801c3b:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  801c3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c42:	75 14                	jne    801c58 <free+0x5c>
  801c44:	83 ec 04             	sub    $0x4,%esp
  801c47:	68 49 41 80 00       	push   $0x804149
  801c4c:	6a 6a                	push   $0x6a
  801c4e:	68 67 41 80 00       	push   $0x804167
  801c53:	e8 39 eb ff ff       	call   800791 <_panic>
  801c58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c5b:	8b 00                	mov    (%eax),%eax
  801c5d:	85 c0                	test   %eax,%eax
  801c5f:	74 10                	je     801c71 <free+0x75>
  801c61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c64:	8b 00                	mov    (%eax),%eax
  801c66:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c69:	8b 52 04             	mov    0x4(%edx),%edx
  801c6c:	89 50 04             	mov    %edx,0x4(%eax)
  801c6f:	eb 0b                	jmp    801c7c <free+0x80>
  801c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c74:	8b 40 04             	mov    0x4(%eax),%eax
  801c77:	a3 44 50 80 00       	mov    %eax,0x805044
  801c7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c7f:	8b 40 04             	mov    0x4(%eax),%eax
  801c82:	85 c0                	test   %eax,%eax
  801c84:	74 0f                	je     801c95 <free+0x99>
  801c86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c89:	8b 40 04             	mov    0x4(%eax),%eax
  801c8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c8f:	8b 12                	mov    (%edx),%edx
  801c91:	89 10                	mov    %edx,(%eax)
  801c93:	eb 0a                	jmp    801c9f <free+0xa3>
  801c95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c98:	8b 00                	mov    (%eax),%eax
  801c9a:	a3 40 50 80 00       	mov    %eax,0x805040
  801c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ca2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ca8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801cb2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801cb7:	48                   	dec    %eax
  801cb8:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(blk);
  801cbd:	83 ec 0c             	sub    $0xc,%esp
  801cc0:	ff 75 f4             	pushl  -0xc(%ebp)
  801cc3:	e8 65 13 00 00       	call   80302d <insert_sorted_with_merge_freeList>
  801cc8:	83 c4 10             	add    $0x10,%esp
	}
}
  801ccb:	90                   	nop
  801ccc:	c9                   	leave  
  801ccd:	c3                   	ret    

00801cce <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801cce:	55                   	push   %ebp
  801ccf:	89 e5                	mov    %esp,%ebp
  801cd1:	83 ec 28             	sub    $0x28,%esp
  801cd4:	8b 45 10             	mov    0x10(%ebp),%eax
  801cd7:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801cda:	e8 f6 fc ff ff       	call   8019d5 <InitializeUHeap>
	if (size == 0) return NULL ;
  801cdf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ce3:	75 0a                	jne    801cef <smalloc+0x21>
  801ce5:	b8 00 00 00 00       	mov    $0x0,%eax
  801cea:	e9 af 00 00 00       	jmp    801d9e <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  801cef:	e8 44 07 00 00       	call   802438 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801cf4:	83 f8 01             	cmp    $0x1,%eax
  801cf7:	0f 85 9c 00 00 00    	jne    801d99 <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  801cfd:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801d04:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d0a:	01 d0                	add    %edx,%eax
  801d0c:	48                   	dec    %eax
  801d0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d13:	ba 00 00 00 00       	mov    $0x0,%edx
  801d18:	f7 75 f4             	divl   -0xc(%ebp)
  801d1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d1e:	29 d0                	sub    %edx,%eax
  801d20:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  801d23:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  801d2a:	76 07                	jbe    801d33 <smalloc+0x65>
			return NULL;
  801d2c:	b8 00 00 00 00       	mov    $0x0,%eax
  801d31:	eb 6b                	jmp    801d9e <smalloc+0xd0>
		blk =alloc_block_FF(size);
  801d33:	83 ec 0c             	sub    $0xc,%esp
  801d36:	ff 75 0c             	pushl  0xc(%ebp)
  801d39:	e8 e7 0c 00 00       	call   802a25 <alloc_block_FF>
  801d3e:	83 c4 10             	add    $0x10,%esp
  801d41:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  801d44:	83 ec 0c             	sub    $0xc,%esp
  801d47:	ff 75 ec             	pushl  -0x14(%ebp)
  801d4a:	e8 d6 0a 00 00       	call   802825 <insert_sorted_allocList>
  801d4f:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  801d52:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d56:	75 07                	jne    801d5f <smalloc+0x91>
		{
			return NULL;
  801d58:	b8 00 00 00 00       	mov    $0x0,%eax
  801d5d:	eb 3f                	jmp    801d9e <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  801d5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d62:	8b 40 08             	mov    0x8(%eax),%eax
  801d65:	89 c2                	mov    %eax,%edx
  801d67:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801d6b:	52                   	push   %edx
  801d6c:	50                   	push   %eax
  801d6d:	ff 75 0c             	pushl  0xc(%ebp)
  801d70:	ff 75 08             	pushl  0x8(%ebp)
  801d73:	e8 45 04 00 00       	call   8021bd <sys_createSharedObject>
  801d78:	83 c4 10             	add    $0x10,%esp
  801d7b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  801d7e:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801d82:	74 06                	je     801d8a <smalloc+0xbc>
  801d84:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801d88:	75 07                	jne    801d91 <smalloc+0xc3>
		{
			return NULL;
  801d8a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d8f:	eb 0d                	jmp    801d9e <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  801d91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d94:	8b 40 08             	mov    0x8(%eax),%eax
  801d97:	eb 05                	jmp    801d9e <smalloc+0xd0>
		}
	}
	else
		return NULL;
  801d99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d9e:	c9                   	leave  
  801d9f:	c3                   	ret    

00801da0 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801da0:	55                   	push   %ebp
  801da1:	89 e5                	mov    %esp,%ebp
  801da3:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801da6:	e8 2a fc ff ff       	call   8019d5 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801dab:	83 ec 08             	sub    $0x8,%esp
  801dae:	ff 75 0c             	pushl  0xc(%ebp)
  801db1:	ff 75 08             	pushl  0x8(%ebp)
  801db4:	e8 2e 04 00 00       	call   8021e7 <sys_getSizeOfSharedObject>
  801db9:	83 c4 10             	add    $0x10,%esp
  801dbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  801dbf:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801dc3:	75 0a                	jne    801dcf <sget+0x2f>
	{
		return NULL;
  801dc5:	b8 00 00 00 00       	mov    $0x0,%eax
  801dca:	e9 94 00 00 00       	jmp    801e63 <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801dcf:	e8 64 06 00 00       	call   802438 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801dd4:	85 c0                	test   %eax,%eax
  801dd6:	0f 84 82 00 00 00    	je     801e5e <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  801ddc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  801de3:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801dea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ded:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801df0:	01 d0                	add    %edx,%eax
  801df2:	48                   	dec    %eax
  801df3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801df6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801df9:	ba 00 00 00 00       	mov    $0x0,%edx
  801dfe:	f7 75 ec             	divl   -0x14(%ebp)
  801e01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e04:	29 d0                	sub    %edx,%eax
  801e06:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  801e09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e0c:	83 ec 0c             	sub    $0xc,%esp
  801e0f:	50                   	push   %eax
  801e10:	e8 10 0c 00 00       	call   802a25 <alloc_block_FF>
  801e15:	83 c4 10             	add    $0x10,%esp
  801e18:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  801e1b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e1f:	75 07                	jne    801e28 <sget+0x88>
		{
			return NULL;
  801e21:	b8 00 00 00 00       	mov    $0x0,%eax
  801e26:	eb 3b                	jmp    801e63 <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  801e28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e2b:	8b 40 08             	mov    0x8(%eax),%eax
  801e2e:	83 ec 04             	sub    $0x4,%esp
  801e31:	50                   	push   %eax
  801e32:	ff 75 0c             	pushl  0xc(%ebp)
  801e35:	ff 75 08             	pushl  0x8(%ebp)
  801e38:	e8 c7 03 00 00       	call   802204 <sys_getSharedObject>
  801e3d:	83 c4 10             	add    $0x10,%esp
  801e40:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  801e43:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801e47:	74 06                	je     801e4f <sget+0xaf>
  801e49:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  801e4d:	75 07                	jne    801e56 <sget+0xb6>
		{
			return NULL;
  801e4f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e54:	eb 0d                	jmp    801e63 <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  801e56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e59:	8b 40 08             	mov    0x8(%eax),%eax
  801e5c:	eb 05                	jmp    801e63 <sget+0xc3>
		}
	}
	else
			return NULL;
  801e5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e63:	c9                   	leave  
  801e64:	c3                   	ret    

00801e65 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801e65:	55                   	push   %ebp
  801e66:	89 e5                	mov    %esp,%ebp
  801e68:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e6b:	e8 65 fb ff ff       	call   8019d5 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801e70:	83 ec 04             	sub    $0x4,%esp
  801e73:	68 74 41 80 00       	push   $0x804174
  801e78:	68 e1 00 00 00       	push   $0xe1
  801e7d:	68 67 41 80 00       	push   $0x804167
  801e82:	e8 0a e9 ff ff       	call   800791 <_panic>

00801e87 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801e87:	55                   	push   %ebp
  801e88:	89 e5                	mov    %esp,%ebp
  801e8a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801e8d:	83 ec 04             	sub    $0x4,%esp
  801e90:	68 9c 41 80 00       	push   $0x80419c
  801e95:	68 f5 00 00 00       	push   $0xf5
  801e9a:	68 67 41 80 00       	push   $0x804167
  801e9f:	e8 ed e8 ff ff       	call   800791 <_panic>

00801ea4 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801ea4:	55                   	push   %ebp
  801ea5:	89 e5                	mov    %esp,%ebp
  801ea7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801eaa:	83 ec 04             	sub    $0x4,%esp
  801ead:	68 c0 41 80 00       	push   $0x8041c0
  801eb2:	68 00 01 00 00       	push   $0x100
  801eb7:	68 67 41 80 00       	push   $0x804167
  801ebc:	e8 d0 e8 ff ff       	call   800791 <_panic>

00801ec1 <shrink>:

}
void shrink(uint32 newSize)
{
  801ec1:	55                   	push   %ebp
  801ec2:	89 e5                	mov    %esp,%ebp
  801ec4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ec7:	83 ec 04             	sub    $0x4,%esp
  801eca:	68 c0 41 80 00       	push   $0x8041c0
  801ecf:	68 05 01 00 00       	push   $0x105
  801ed4:	68 67 41 80 00       	push   $0x804167
  801ed9:	e8 b3 e8 ff ff       	call   800791 <_panic>

00801ede <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801ede:	55                   	push   %ebp
  801edf:	89 e5                	mov    %esp,%ebp
  801ee1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ee4:	83 ec 04             	sub    $0x4,%esp
  801ee7:	68 c0 41 80 00       	push   $0x8041c0
  801eec:	68 0a 01 00 00       	push   $0x10a
  801ef1:	68 67 41 80 00       	push   $0x804167
  801ef6:	e8 96 e8 ff ff       	call   800791 <_panic>

00801efb <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801efb:	55                   	push   %ebp
  801efc:	89 e5                	mov    %esp,%ebp
  801efe:	57                   	push   %edi
  801eff:	56                   	push   %esi
  801f00:	53                   	push   %ebx
  801f01:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801f04:	8b 45 08             	mov    0x8(%ebp),%eax
  801f07:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f0a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f0d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f10:	8b 7d 18             	mov    0x18(%ebp),%edi
  801f13:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801f16:	cd 30                	int    $0x30
  801f18:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801f1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f1e:	83 c4 10             	add    $0x10,%esp
  801f21:	5b                   	pop    %ebx
  801f22:	5e                   	pop    %esi
  801f23:	5f                   	pop    %edi
  801f24:	5d                   	pop    %ebp
  801f25:	c3                   	ret    

00801f26 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801f26:	55                   	push   %ebp
  801f27:	89 e5                	mov    %esp,%ebp
  801f29:	83 ec 04             	sub    $0x4,%esp
  801f2c:	8b 45 10             	mov    0x10(%ebp),%eax
  801f2f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801f32:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f36:	8b 45 08             	mov    0x8(%ebp),%eax
  801f39:	6a 00                	push   $0x0
  801f3b:	6a 00                	push   $0x0
  801f3d:	52                   	push   %edx
  801f3e:	ff 75 0c             	pushl  0xc(%ebp)
  801f41:	50                   	push   %eax
  801f42:	6a 00                	push   $0x0
  801f44:	e8 b2 ff ff ff       	call   801efb <syscall>
  801f49:	83 c4 18             	add    $0x18,%esp
}
  801f4c:	90                   	nop
  801f4d:	c9                   	leave  
  801f4e:	c3                   	ret    

00801f4f <sys_cgetc>:

int
sys_cgetc(void)
{
  801f4f:	55                   	push   %ebp
  801f50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801f52:	6a 00                	push   $0x0
  801f54:	6a 00                	push   $0x0
  801f56:	6a 00                	push   $0x0
  801f58:	6a 00                	push   $0x0
  801f5a:	6a 00                	push   $0x0
  801f5c:	6a 01                	push   $0x1
  801f5e:	e8 98 ff ff ff       	call   801efb <syscall>
  801f63:	83 c4 18             	add    $0x18,%esp
}
  801f66:	c9                   	leave  
  801f67:	c3                   	ret    

00801f68 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801f68:	55                   	push   %ebp
  801f69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801f6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f71:	6a 00                	push   $0x0
  801f73:	6a 00                	push   $0x0
  801f75:	6a 00                	push   $0x0
  801f77:	52                   	push   %edx
  801f78:	50                   	push   %eax
  801f79:	6a 05                	push   $0x5
  801f7b:	e8 7b ff ff ff       	call   801efb <syscall>
  801f80:	83 c4 18             	add    $0x18,%esp
}
  801f83:	c9                   	leave  
  801f84:	c3                   	ret    

00801f85 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f85:	55                   	push   %ebp
  801f86:	89 e5                	mov    %esp,%ebp
  801f88:	56                   	push   %esi
  801f89:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801f8a:	8b 75 18             	mov    0x18(%ebp),%esi
  801f8d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f90:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f93:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f96:	8b 45 08             	mov    0x8(%ebp),%eax
  801f99:	56                   	push   %esi
  801f9a:	53                   	push   %ebx
  801f9b:	51                   	push   %ecx
  801f9c:	52                   	push   %edx
  801f9d:	50                   	push   %eax
  801f9e:	6a 06                	push   $0x6
  801fa0:	e8 56 ff ff ff       	call   801efb <syscall>
  801fa5:	83 c4 18             	add    $0x18,%esp
}
  801fa8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fab:	5b                   	pop    %ebx
  801fac:	5e                   	pop    %esi
  801fad:	5d                   	pop    %ebp
  801fae:	c3                   	ret    

00801faf <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801faf:	55                   	push   %ebp
  801fb0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801fb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb8:	6a 00                	push   $0x0
  801fba:	6a 00                	push   $0x0
  801fbc:	6a 00                	push   $0x0
  801fbe:	52                   	push   %edx
  801fbf:	50                   	push   %eax
  801fc0:	6a 07                	push   $0x7
  801fc2:	e8 34 ff ff ff       	call   801efb <syscall>
  801fc7:	83 c4 18             	add    $0x18,%esp
}
  801fca:	c9                   	leave  
  801fcb:	c3                   	ret    

00801fcc <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801fcc:	55                   	push   %ebp
  801fcd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801fcf:	6a 00                	push   $0x0
  801fd1:	6a 00                	push   $0x0
  801fd3:	6a 00                	push   $0x0
  801fd5:	ff 75 0c             	pushl  0xc(%ebp)
  801fd8:	ff 75 08             	pushl  0x8(%ebp)
  801fdb:	6a 08                	push   $0x8
  801fdd:	e8 19 ff ff ff       	call   801efb <syscall>
  801fe2:	83 c4 18             	add    $0x18,%esp
}
  801fe5:	c9                   	leave  
  801fe6:	c3                   	ret    

00801fe7 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801fe7:	55                   	push   %ebp
  801fe8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801fea:	6a 00                	push   $0x0
  801fec:	6a 00                	push   $0x0
  801fee:	6a 00                	push   $0x0
  801ff0:	6a 00                	push   $0x0
  801ff2:	6a 00                	push   $0x0
  801ff4:	6a 09                	push   $0x9
  801ff6:	e8 00 ff ff ff       	call   801efb <syscall>
  801ffb:	83 c4 18             	add    $0x18,%esp
}
  801ffe:	c9                   	leave  
  801fff:	c3                   	ret    

00802000 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802000:	55                   	push   %ebp
  802001:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802003:	6a 00                	push   $0x0
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	6a 00                	push   $0x0
  80200b:	6a 00                	push   $0x0
  80200d:	6a 0a                	push   $0xa
  80200f:	e8 e7 fe ff ff       	call   801efb <syscall>
  802014:	83 c4 18             	add    $0x18,%esp
}
  802017:	c9                   	leave  
  802018:	c3                   	ret    

00802019 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802019:	55                   	push   %ebp
  80201a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80201c:	6a 00                	push   $0x0
  80201e:	6a 00                	push   $0x0
  802020:	6a 00                	push   $0x0
  802022:	6a 00                	push   $0x0
  802024:	6a 00                	push   $0x0
  802026:	6a 0b                	push   $0xb
  802028:	e8 ce fe ff ff       	call   801efb <syscall>
  80202d:	83 c4 18             	add    $0x18,%esp
}
  802030:	c9                   	leave  
  802031:	c3                   	ret    

00802032 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802032:	55                   	push   %ebp
  802033:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802035:	6a 00                	push   $0x0
  802037:	6a 00                	push   $0x0
  802039:	6a 00                	push   $0x0
  80203b:	ff 75 0c             	pushl  0xc(%ebp)
  80203e:	ff 75 08             	pushl  0x8(%ebp)
  802041:	6a 0f                	push   $0xf
  802043:	e8 b3 fe ff ff       	call   801efb <syscall>
  802048:	83 c4 18             	add    $0x18,%esp
	return;
  80204b:	90                   	nop
}
  80204c:	c9                   	leave  
  80204d:	c3                   	ret    

0080204e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80204e:	55                   	push   %ebp
  80204f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802051:	6a 00                	push   $0x0
  802053:	6a 00                	push   $0x0
  802055:	6a 00                	push   $0x0
  802057:	ff 75 0c             	pushl  0xc(%ebp)
  80205a:	ff 75 08             	pushl  0x8(%ebp)
  80205d:	6a 10                	push   $0x10
  80205f:	e8 97 fe ff ff       	call   801efb <syscall>
  802064:	83 c4 18             	add    $0x18,%esp
	return ;
  802067:	90                   	nop
}
  802068:	c9                   	leave  
  802069:	c3                   	ret    

0080206a <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80206a:	55                   	push   %ebp
  80206b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80206d:	6a 00                	push   $0x0
  80206f:	6a 00                	push   $0x0
  802071:	ff 75 10             	pushl  0x10(%ebp)
  802074:	ff 75 0c             	pushl  0xc(%ebp)
  802077:	ff 75 08             	pushl  0x8(%ebp)
  80207a:	6a 11                	push   $0x11
  80207c:	e8 7a fe ff ff       	call   801efb <syscall>
  802081:	83 c4 18             	add    $0x18,%esp
	return ;
  802084:	90                   	nop
}
  802085:	c9                   	leave  
  802086:	c3                   	ret    

00802087 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802087:	55                   	push   %ebp
  802088:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80208a:	6a 00                	push   $0x0
  80208c:	6a 00                	push   $0x0
  80208e:	6a 00                	push   $0x0
  802090:	6a 00                	push   $0x0
  802092:	6a 00                	push   $0x0
  802094:	6a 0c                	push   $0xc
  802096:	e8 60 fe ff ff       	call   801efb <syscall>
  80209b:	83 c4 18             	add    $0x18,%esp
}
  80209e:	c9                   	leave  
  80209f:	c3                   	ret    

008020a0 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8020a0:	55                   	push   %ebp
  8020a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8020a3:	6a 00                	push   $0x0
  8020a5:	6a 00                	push   $0x0
  8020a7:	6a 00                	push   $0x0
  8020a9:	6a 00                	push   $0x0
  8020ab:	ff 75 08             	pushl  0x8(%ebp)
  8020ae:	6a 0d                	push   $0xd
  8020b0:	e8 46 fe ff ff       	call   801efb <syscall>
  8020b5:	83 c4 18             	add    $0x18,%esp
}
  8020b8:	c9                   	leave  
  8020b9:	c3                   	ret    

008020ba <sys_scarce_memory>:

void sys_scarce_memory()
{
  8020ba:	55                   	push   %ebp
  8020bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 00                	push   $0x0
  8020c1:	6a 00                	push   $0x0
  8020c3:	6a 00                	push   $0x0
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 0e                	push   $0xe
  8020c9:	e8 2d fe ff ff       	call   801efb <syscall>
  8020ce:	83 c4 18             	add    $0x18,%esp
}
  8020d1:	90                   	nop
  8020d2:	c9                   	leave  
  8020d3:	c3                   	ret    

008020d4 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8020d4:	55                   	push   %ebp
  8020d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8020d7:	6a 00                	push   $0x0
  8020d9:	6a 00                	push   $0x0
  8020db:	6a 00                	push   $0x0
  8020dd:	6a 00                	push   $0x0
  8020df:	6a 00                	push   $0x0
  8020e1:	6a 13                	push   $0x13
  8020e3:	e8 13 fe ff ff       	call   801efb <syscall>
  8020e8:	83 c4 18             	add    $0x18,%esp
}
  8020eb:	90                   	nop
  8020ec:	c9                   	leave  
  8020ed:	c3                   	ret    

008020ee <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8020ee:	55                   	push   %ebp
  8020ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8020f1:	6a 00                	push   $0x0
  8020f3:	6a 00                	push   $0x0
  8020f5:	6a 00                	push   $0x0
  8020f7:	6a 00                	push   $0x0
  8020f9:	6a 00                	push   $0x0
  8020fb:	6a 14                	push   $0x14
  8020fd:	e8 f9 fd ff ff       	call   801efb <syscall>
  802102:	83 c4 18             	add    $0x18,%esp
}
  802105:	90                   	nop
  802106:	c9                   	leave  
  802107:	c3                   	ret    

00802108 <sys_cputc>:


void
sys_cputc(const char c)
{
  802108:	55                   	push   %ebp
  802109:	89 e5                	mov    %esp,%ebp
  80210b:	83 ec 04             	sub    $0x4,%esp
  80210e:	8b 45 08             	mov    0x8(%ebp),%eax
  802111:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802114:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802118:	6a 00                	push   $0x0
  80211a:	6a 00                	push   $0x0
  80211c:	6a 00                	push   $0x0
  80211e:	6a 00                	push   $0x0
  802120:	50                   	push   %eax
  802121:	6a 15                	push   $0x15
  802123:	e8 d3 fd ff ff       	call   801efb <syscall>
  802128:	83 c4 18             	add    $0x18,%esp
}
  80212b:	90                   	nop
  80212c:	c9                   	leave  
  80212d:	c3                   	ret    

0080212e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80212e:	55                   	push   %ebp
  80212f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802131:	6a 00                	push   $0x0
  802133:	6a 00                	push   $0x0
  802135:	6a 00                	push   $0x0
  802137:	6a 00                	push   $0x0
  802139:	6a 00                	push   $0x0
  80213b:	6a 16                	push   $0x16
  80213d:	e8 b9 fd ff ff       	call   801efb <syscall>
  802142:	83 c4 18             	add    $0x18,%esp
}
  802145:	90                   	nop
  802146:	c9                   	leave  
  802147:	c3                   	ret    

00802148 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802148:	55                   	push   %ebp
  802149:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80214b:	8b 45 08             	mov    0x8(%ebp),%eax
  80214e:	6a 00                	push   $0x0
  802150:	6a 00                	push   $0x0
  802152:	6a 00                	push   $0x0
  802154:	ff 75 0c             	pushl  0xc(%ebp)
  802157:	50                   	push   %eax
  802158:	6a 17                	push   $0x17
  80215a:	e8 9c fd ff ff       	call   801efb <syscall>
  80215f:	83 c4 18             	add    $0x18,%esp
}
  802162:	c9                   	leave  
  802163:	c3                   	ret    

00802164 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802164:	55                   	push   %ebp
  802165:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802167:	8b 55 0c             	mov    0xc(%ebp),%edx
  80216a:	8b 45 08             	mov    0x8(%ebp),%eax
  80216d:	6a 00                	push   $0x0
  80216f:	6a 00                	push   $0x0
  802171:	6a 00                	push   $0x0
  802173:	52                   	push   %edx
  802174:	50                   	push   %eax
  802175:	6a 1a                	push   $0x1a
  802177:	e8 7f fd ff ff       	call   801efb <syscall>
  80217c:	83 c4 18             	add    $0x18,%esp
}
  80217f:	c9                   	leave  
  802180:	c3                   	ret    

00802181 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802181:	55                   	push   %ebp
  802182:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802184:	8b 55 0c             	mov    0xc(%ebp),%edx
  802187:	8b 45 08             	mov    0x8(%ebp),%eax
  80218a:	6a 00                	push   $0x0
  80218c:	6a 00                	push   $0x0
  80218e:	6a 00                	push   $0x0
  802190:	52                   	push   %edx
  802191:	50                   	push   %eax
  802192:	6a 18                	push   $0x18
  802194:	e8 62 fd ff ff       	call   801efb <syscall>
  802199:	83 c4 18             	add    $0x18,%esp
}
  80219c:	90                   	nop
  80219d:	c9                   	leave  
  80219e:	c3                   	ret    

0080219f <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80219f:	55                   	push   %ebp
  8021a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8021a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a8:	6a 00                	push   $0x0
  8021aa:	6a 00                	push   $0x0
  8021ac:	6a 00                	push   $0x0
  8021ae:	52                   	push   %edx
  8021af:	50                   	push   %eax
  8021b0:	6a 19                	push   $0x19
  8021b2:	e8 44 fd ff ff       	call   801efb <syscall>
  8021b7:	83 c4 18             	add    $0x18,%esp
}
  8021ba:	90                   	nop
  8021bb:	c9                   	leave  
  8021bc:	c3                   	ret    

008021bd <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8021bd:	55                   	push   %ebp
  8021be:	89 e5                	mov    %esp,%ebp
  8021c0:	83 ec 04             	sub    $0x4,%esp
  8021c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8021c6:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8021c9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8021cc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8021d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d3:	6a 00                	push   $0x0
  8021d5:	51                   	push   %ecx
  8021d6:	52                   	push   %edx
  8021d7:	ff 75 0c             	pushl  0xc(%ebp)
  8021da:	50                   	push   %eax
  8021db:	6a 1b                	push   $0x1b
  8021dd:	e8 19 fd ff ff       	call   801efb <syscall>
  8021e2:	83 c4 18             	add    $0x18,%esp
}
  8021e5:	c9                   	leave  
  8021e6:	c3                   	ret    

008021e7 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8021e7:	55                   	push   %ebp
  8021e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8021ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f0:	6a 00                	push   $0x0
  8021f2:	6a 00                	push   $0x0
  8021f4:	6a 00                	push   $0x0
  8021f6:	52                   	push   %edx
  8021f7:	50                   	push   %eax
  8021f8:	6a 1c                	push   $0x1c
  8021fa:	e8 fc fc ff ff       	call   801efb <syscall>
  8021ff:	83 c4 18             	add    $0x18,%esp
}
  802202:	c9                   	leave  
  802203:	c3                   	ret    

00802204 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802204:	55                   	push   %ebp
  802205:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802207:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80220a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80220d:	8b 45 08             	mov    0x8(%ebp),%eax
  802210:	6a 00                	push   $0x0
  802212:	6a 00                	push   $0x0
  802214:	51                   	push   %ecx
  802215:	52                   	push   %edx
  802216:	50                   	push   %eax
  802217:	6a 1d                	push   $0x1d
  802219:	e8 dd fc ff ff       	call   801efb <syscall>
  80221e:	83 c4 18             	add    $0x18,%esp
}
  802221:	c9                   	leave  
  802222:	c3                   	ret    

00802223 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802223:	55                   	push   %ebp
  802224:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802226:	8b 55 0c             	mov    0xc(%ebp),%edx
  802229:	8b 45 08             	mov    0x8(%ebp),%eax
  80222c:	6a 00                	push   $0x0
  80222e:	6a 00                	push   $0x0
  802230:	6a 00                	push   $0x0
  802232:	52                   	push   %edx
  802233:	50                   	push   %eax
  802234:	6a 1e                	push   $0x1e
  802236:	e8 c0 fc ff ff       	call   801efb <syscall>
  80223b:	83 c4 18             	add    $0x18,%esp
}
  80223e:	c9                   	leave  
  80223f:	c3                   	ret    

00802240 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802240:	55                   	push   %ebp
  802241:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802243:	6a 00                	push   $0x0
  802245:	6a 00                	push   $0x0
  802247:	6a 00                	push   $0x0
  802249:	6a 00                	push   $0x0
  80224b:	6a 00                	push   $0x0
  80224d:	6a 1f                	push   $0x1f
  80224f:	e8 a7 fc ff ff       	call   801efb <syscall>
  802254:	83 c4 18             	add    $0x18,%esp
}
  802257:	c9                   	leave  
  802258:	c3                   	ret    

00802259 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802259:	55                   	push   %ebp
  80225a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80225c:	8b 45 08             	mov    0x8(%ebp),%eax
  80225f:	6a 00                	push   $0x0
  802261:	ff 75 14             	pushl  0x14(%ebp)
  802264:	ff 75 10             	pushl  0x10(%ebp)
  802267:	ff 75 0c             	pushl  0xc(%ebp)
  80226a:	50                   	push   %eax
  80226b:	6a 20                	push   $0x20
  80226d:	e8 89 fc ff ff       	call   801efb <syscall>
  802272:	83 c4 18             	add    $0x18,%esp
}
  802275:	c9                   	leave  
  802276:	c3                   	ret    

00802277 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802277:	55                   	push   %ebp
  802278:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80227a:	8b 45 08             	mov    0x8(%ebp),%eax
  80227d:	6a 00                	push   $0x0
  80227f:	6a 00                	push   $0x0
  802281:	6a 00                	push   $0x0
  802283:	6a 00                	push   $0x0
  802285:	50                   	push   %eax
  802286:	6a 21                	push   $0x21
  802288:	e8 6e fc ff ff       	call   801efb <syscall>
  80228d:	83 c4 18             	add    $0x18,%esp
}
  802290:	90                   	nop
  802291:	c9                   	leave  
  802292:	c3                   	ret    

00802293 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802293:	55                   	push   %ebp
  802294:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802296:	8b 45 08             	mov    0x8(%ebp),%eax
  802299:	6a 00                	push   $0x0
  80229b:	6a 00                	push   $0x0
  80229d:	6a 00                	push   $0x0
  80229f:	6a 00                	push   $0x0
  8022a1:	50                   	push   %eax
  8022a2:	6a 22                	push   $0x22
  8022a4:	e8 52 fc ff ff       	call   801efb <syscall>
  8022a9:	83 c4 18             	add    $0x18,%esp
}
  8022ac:	c9                   	leave  
  8022ad:	c3                   	ret    

008022ae <sys_getenvid>:

int32 sys_getenvid(void)
{
  8022ae:	55                   	push   %ebp
  8022af:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8022b1:	6a 00                	push   $0x0
  8022b3:	6a 00                	push   $0x0
  8022b5:	6a 00                	push   $0x0
  8022b7:	6a 00                	push   $0x0
  8022b9:	6a 00                	push   $0x0
  8022bb:	6a 02                	push   $0x2
  8022bd:	e8 39 fc ff ff       	call   801efb <syscall>
  8022c2:	83 c4 18             	add    $0x18,%esp
}
  8022c5:	c9                   	leave  
  8022c6:	c3                   	ret    

008022c7 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8022c7:	55                   	push   %ebp
  8022c8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8022ca:	6a 00                	push   $0x0
  8022cc:	6a 00                	push   $0x0
  8022ce:	6a 00                	push   $0x0
  8022d0:	6a 00                	push   $0x0
  8022d2:	6a 00                	push   $0x0
  8022d4:	6a 03                	push   $0x3
  8022d6:	e8 20 fc ff ff       	call   801efb <syscall>
  8022db:	83 c4 18             	add    $0x18,%esp
}
  8022de:	c9                   	leave  
  8022df:	c3                   	ret    

008022e0 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8022e0:	55                   	push   %ebp
  8022e1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8022e3:	6a 00                	push   $0x0
  8022e5:	6a 00                	push   $0x0
  8022e7:	6a 00                	push   $0x0
  8022e9:	6a 00                	push   $0x0
  8022eb:	6a 00                	push   $0x0
  8022ed:	6a 04                	push   $0x4
  8022ef:	e8 07 fc ff ff       	call   801efb <syscall>
  8022f4:	83 c4 18             	add    $0x18,%esp
}
  8022f7:	c9                   	leave  
  8022f8:	c3                   	ret    

008022f9 <sys_exit_env>:


void sys_exit_env(void)
{
  8022f9:	55                   	push   %ebp
  8022fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8022fc:	6a 00                	push   $0x0
  8022fe:	6a 00                	push   $0x0
  802300:	6a 00                	push   $0x0
  802302:	6a 00                	push   $0x0
  802304:	6a 00                	push   $0x0
  802306:	6a 23                	push   $0x23
  802308:	e8 ee fb ff ff       	call   801efb <syscall>
  80230d:	83 c4 18             	add    $0x18,%esp
}
  802310:	90                   	nop
  802311:	c9                   	leave  
  802312:	c3                   	ret    

00802313 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802313:	55                   	push   %ebp
  802314:	89 e5                	mov    %esp,%ebp
  802316:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802319:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80231c:	8d 50 04             	lea    0x4(%eax),%edx
  80231f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802322:	6a 00                	push   $0x0
  802324:	6a 00                	push   $0x0
  802326:	6a 00                	push   $0x0
  802328:	52                   	push   %edx
  802329:	50                   	push   %eax
  80232a:	6a 24                	push   $0x24
  80232c:	e8 ca fb ff ff       	call   801efb <syscall>
  802331:	83 c4 18             	add    $0x18,%esp
	return result;
  802334:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802337:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80233a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80233d:	89 01                	mov    %eax,(%ecx)
  80233f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802342:	8b 45 08             	mov    0x8(%ebp),%eax
  802345:	c9                   	leave  
  802346:	c2 04 00             	ret    $0x4

00802349 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802349:	55                   	push   %ebp
  80234a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80234c:	6a 00                	push   $0x0
  80234e:	6a 00                	push   $0x0
  802350:	ff 75 10             	pushl  0x10(%ebp)
  802353:	ff 75 0c             	pushl  0xc(%ebp)
  802356:	ff 75 08             	pushl  0x8(%ebp)
  802359:	6a 12                	push   $0x12
  80235b:	e8 9b fb ff ff       	call   801efb <syscall>
  802360:	83 c4 18             	add    $0x18,%esp
	return ;
  802363:	90                   	nop
}
  802364:	c9                   	leave  
  802365:	c3                   	ret    

00802366 <sys_rcr2>:
uint32 sys_rcr2()
{
  802366:	55                   	push   %ebp
  802367:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802369:	6a 00                	push   $0x0
  80236b:	6a 00                	push   $0x0
  80236d:	6a 00                	push   $0x0
  80236f:	6a 00                	push   $0x0
  802371:	6a 00                	push   $0x0
  802373:	6a 25                	push   $0x25
  802375:	e8 81 fb ff ff       	call   801efb <syscall>
  80237a:	83 c4 18             	add    $0x18,%esp
}
  80237d:	c9                   	leave  
  80237e:	c3                   	ret    

0080237f <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80237f:	55                   	push   %ebp
  802380:	89 e5                	mov    %esp,%ebp
  802382:	83 ec 04             	sub    $0x4,%esp
  802385:	8b 45 08             	mov    0x8(%ebp),%eax
  802388:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80238b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80238f:	6a 00                	push   $0x0
  802391:	6a 00                	push   $0x0
  802393:	6a 00                	push   $0x0
  802395:	6a 00                	push   $0x0
  802397:	50                   	push   %eax
  802398:	6a 26                	push   $0x26
  80239a:	e8 5c fb ff ff       	call   801efb <syscall>
  80239f:	83 c4 18             	add    $0x18,%esp
	return ;
  8023a2:	90                   	nop
}
  8023a3:	c9                   	leave  
  8023a4:	c3                   	ret    

008023a5 <rsttst>:
void rsttst()
{
  8023a5:	55                   	push   %ebp
  8023a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8023a8:	6a 00                	push   $0x0
  8023aa:	6a 00                	push   $0x0
  8023ac:	6a 00                	push   $0x0
  8023ae:	6a 00                	push   $0x0
  8023b0:	6a 00                	push   $0x0
  8023b2:	6a 28                	push   $0x28
  8023b4:	e8 42 fb ff ff       	call   801efb <syscall>
  8023b9:	83 c4 18             	add    $0x18,%esp
	return ;
  8023bc:	90                   	nop
}
  8023bd:	c9                   	leave  
  8023be:	c3                   	ret    

008023bf <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8023bf:	55                   	push   %ebp
  8023c0:	89 e5                	mov    %esp,%ebp
  8023c2:	83 ec 04             	sub    $0x4,%esp
  8023c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8023c8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8023cb:	8b 55 18             	mov    0x18(%ebp),%edx
  8023ce:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8023d2:	52                   	push   %edx
  8023d3:	50                   	push   %eax
  8023d4:	ff 75 10             	pushl  0x10(%ebp)
  8023d7:	ff 75 0c             	pushl  0xc(%ebp)
  8023da:	ff 75 08             	pushl  0x8(%ebp)
  8023dd:	6a 27                	push   $0x27
  8023df:	e8 17 fb ff ff       	call   801efb <syscall>
  8023e4:	83 c4 18             	add    $0x18,%esp
	return ;
  8023e7:	90                   	nop
}
  8023e8:	c9                   	leave  
  8023e9:	c3                   	ret    

008023ea <chktst>:
void chktst(uint32 n)
{
  8023ea:	55                   	push   %ebp
  8023eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8023ed:	6a 00                	push   $0x0
  8023ef:	6a 00                	push   $0x0
  8023f1:	6a 00                	push   $0x0
  8023f3:	6a 00                	push   $0x0
  8023f5:	ff 75 08             	pushl  0x8(%ebp)
  8023f8:	6a 29                	push   $0x29
  8023fa:	e8 fc fa ff ff       	call   801efb <syscall>
  8023ff:	83 c4 18             	add    $0x18,%esp
	return ;
  802402:	90                   	nop
}
  802403:	c9                   	leave  
  802404:	c3                   	ret    

00802405 <inctst>:

void inctst()
{
  802405:	55                   	push   %ebp
  802406:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802408:	6a 00                	push   $0x0
  80240a:	6a 00                	push   $0x0
  80240c:	6a 00                	push   $0x0
  80240e:	6a 00                	push   $0x0
  802410:	6a 00                	push   $0x0
  802412:	6a 2a                	push   $0x2a
  802414:	e8 e2 fa ff ff       	call   801efb <syscall>
  802419:	83 c4 18             	add    $0x18,%esp
	return ;
  80241c:	90                   	nop
}
  80241d:	c9                   	leave  
  80241e:	c3                   	ret    

0080241f <gettst>:
uint32 gettst()
{
  80241f:	55                   	push   %ebp
  802420:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802422:	6a 00                	push   $0x0
  802424:	6a 00                	push   $0x0
  802426:	6a 00                	push   $0x0
  802428:	6a 00                	push   $0x0
  80242a:	6a 00                	push   $0x0
  80242c:	6a 2b                	push   $0x2b
  80242e:	e8 c8 fa ff ff       	call   801efb <syscall>
  802433:	83 c4 18             	add    $0x18,%esp
}
  802436:	c9                   	leave  
  802437:	c3                   	ret    

00802438 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802438:	55                   	push   %ebp
  802439:	89 e5                	mov    %esp,%ebp
  80243b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80243e:	6a 00                	push   $0x0
  802440:	6a 00                	push   $0x0
  802442:	6a 00                	push   $0x0
  802444:	6a 00                	push   $0x0
  802446:	6a 00                	push   $0x0
  802448:	6a 2c                	push   $0x2c
  80244a:	e8 ac fa ff ff       	call   801efb <syscall>
  80244f:	83 c4 18             	add    $0x18,%esp
  802452:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802455:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802459:	75 07                	jne    802462 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80245b:	b8 01 00 00 00       	mov    $0x1,%eax
  802460:	eb 05                	jmp    802467 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802462:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802467:	c9                   	leave  
  802468:	c3                   	ret    

00802469 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802469:	55                   	push   %ebp
  80246a:	89 e5                	mov    %esp,%ebp
  80246c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80246f:	6a 00                	push   $0x0
  802471:	6a 00                	push   $0x0
  802473:	6a 00                	push   $0x0
  802475:	6a 00                	push   $0x0
  802477:	6a 00                	push   $0x0
  802479:	6a 2c                	push   $0x2c
  80247b:	e8 7b fa ff ff       	call   801efb <syscall>
  802480:	83 c4 18             	add    $0x18,%esp
  802483:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802486:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80248a:	75 07                	jne    802493 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80248c:	b8 01 00 00 00       	mov    $0x1,%eax
  802491:	eb 05                	jmp    802498 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802493:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802498:	c9                   	leave  
  802499:	c3                   	ret    

0080249a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80249a:	55                   	push   %ebp
  80249b:	89 e5                	mov    %esp,%ebp
  80249d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024a0:	6a 00                	push   $0x0
  8024a2:	6a 00                	push   $0x0
  8024a4:	6a 00                	push   $0x0
  8024a6:	6a 00                	push   $0x0
  8024a8:	6a 00                	push   $0x0
  8024aa:	6a 2c                	push   $0x2c
  8024ac:	e8 4a fa ff ff       	call   801efb <syscall>
  8024b1:	83 c4 18             	add    $0x18,%esp
  8024b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8024b7:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8024bb:	75 07                	jne    8024c4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8024bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8024c2:	eb 05                	jmp    8024c9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8024c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024c9:	c9                   	leave  
  8024ca:	c3                   	ret    

008024cb <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8024cb:	55                   	push   %ebp
  8024cc:	89 e5                	mov    %esp,%ebp
  8024ce:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024d1:	6a 00                	push   $0x0
  8024d3:	6a 00                	push   $0x0
  8024d5:	6a 00                	push   $0x0
  8024d7:	6a 00                	push   $0x0
  8024d9:	6a 00                	push   $0x0
  8024db:	6a 2c                	push   $0x2c
  8024dd:	e8 19 fa ff ff       	call   801efb <syscall>
  8024e2:	83 c4 18             	add    $0x18,%esp
  8024e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8024e8:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8024ec:	75 07                	jne    8024f5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8024ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8024f3:	eb 05                	jmp    8024fa <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8024f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024fa:	c9                   	leave  
  8024fb:	c3                   	ret    

008024fc <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8024fc:	55                   	push   %ebp
  8024fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8024ff:	6a 00                	push   $0x0
  802501:	6a 00                	push   $0x0
  802503:	6a 00                	push   $0x0
  802505:	6a 00                	push   $0x0
  802507:	ff 75 08             	pushl  0x8(%ebp)
  80250a:	6a 2d                	push   $0x2d
  80250c:	e8 ea f9 ff ff       	call   801efb <syscall>
  802511:	83 c4 18             	add    $0x18,%esp
	return ;
  802514:	90                   	nop
}
  802515:	c9                   	leave  
  802516:	c3                   	ret    

00802517 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802517:	55                   	push   %ebp
  802518:	89 e5                	mov    %esp,%ebp
  80251a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80251b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80251e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802521:	8b 55 0c             	mov    0xc(%ebp),%edx
  802524:	8b 45 08             	mov    0x8(%ebp),%eax
  802527:	6a 00                	push   $0x0
  802529:	53                   	push   %ebx
  80252a:	51                   	push   %ecx
  80252b:	52                   	push   %edx
  80252c:	50                   	push   %eax
  80252d:	6a 2e                	push   $0x2e
  80252f:	e8 c7 f9 ff ff       	call   801efb <syscall>
  802534:	83 c4 18             	add    $0x18,%esp
}
  802537:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80253a:	c9                   	leave  
  80253b:	c3                   	ret    

0080253c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80253c:	55                   	push   %ebp
  80253d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80253f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802542:	8b 45 08             	mov    0x8(%ebp),%eax
  802545:	6a 00                	push   $0x0
  802547:	6a 00                	push   $0x0
  802549:	6a 00                	push   $0x0
  80254b:	52                   	push   %edx
  80254c:	50                   	push   %eax
  80254d:	6a 2f                	push   $0x2f
  80254f:	e8 a7 f9 ff ff       	call   801efb <syscall>
  802554:	83 c4 18             	add    $0x18,%esp
}
  802557:	c9                   	leave  
  802558:	c3                   	ret    

00802559 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802559:	55                   	push   %ebp
  80255a:	89 e5                	mov    %esp,%ebp
  80255c:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80255f:	83 ec 0c             	sub    $0xc,%esp
  802562:	68 d0 41 80 00       	push   $0x8041d0
  802567:	e8 d9 e4 ff ff       	call   800a45 <cprintf>
  80256c:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80256f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802576:	83 ec 0c             	sub    $0xc,%esp
  802579:	68 fc 41 80 00       	push   $0x8041fc
  80257e:	e8 c2 e4 ff ff       	call   800a45 <cprintf>
  802583:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802586:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80258a:	a1 38 51 80 00       	mov    0x805138,%eax
  80258f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802592:	eb 56                	jmp    8025ea <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802594:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802598:	74 1c                	je     8025b6 <print_mem_block_lists+0x5d>
  80259a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259d:	8b 50 08             	mov    0x8(%eax),%edx
  8025a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a3:	8b 48 08             	mov    0x8(%eax),%ecx
  8025a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ac:	01 c8                	add    %ecx,%eax
  8025ae:	39 c2                	cmp    %eax,%edx
  8025b0:	73 04                	jae    8025b6 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8025b2:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8025b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b9:	8b 50 08             	mov    0x8(%eax),%edx
  8025bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8025c2:	01 c2                	add    %eax,%edx
  8025c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c7:	8b 40 08             	mov    0x8(%eax),%eax
  8025ca:	83 ec 04             	sub    $0x4,%esp
  8025cd:	52                   	push   %edx
  8025ce:	50                   	push   %eax
  8025cf:	68 11 42 80 00       	push   $0x804211
  8025d4:	e8 6c e4 ff ff       	call   800a45 <cprintf>
  8025d9:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8025dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025df:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8025e2:	a1 40 51 80 00       	mov    0x805140,%eax
  8025e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ee:	74 07                	je     8025f7 <print_mem_block_lists+0x9e>
  8025f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f3:	8b 00                	mov    (%eax),%eax
  8025f5:	eb 05                	jmp    8025fc <print_mem_block_lists+0xa3>
  8025f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8025fc:	a3 40 51 80 00       	mov    %eax,0x805140
  802601:	a1 40 51 80 00       	mov    0x805140,%eax
  802606:	85 c0                	test   %eax,%eax
  802608:	75 8a                	jne    802594 <print_mem_block_lists+0x3b>
  80260a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80260e:	75 84                	jne    802594 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802610:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802614:	75 10                	jne    802626 <print_mem_block_lists+0xcd>
  802616:	83 ec 0c             	sub    $0xc,%esp
  802619:	68 20 42 80 00       	push   $0x804220
  80261e:	e8 22 e4 ff ff       	call   800a45 <cprintf>
  802623:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802626:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80262d:	83 ec 0c             	sub    $0xc,%esp
  802630:	68 44 42 80 00       	push   $0x804244
  802635:	e8 0b e4 ff ff       	call   800a45 <cprintf>
  80263a:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80263d:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802641:	a1 40 50 80 00       	mov    0x805040,%eax
  802646:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802649:	eb 56                	jmp    8026a1 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80264b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80264f:	74 1c                	je     80266d <print_mem_block_lists+0x114>
  802651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802654:	8b 50 08             	mov    0x8(%eax),%edx
  802657:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80265a:	8b 48 08             	mov    0x8(%eax),%ecx
  80265d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802660:	8b 40 0c             	mov    0xc(%eax),%eax
  802663:	01 c8                	add    %ecx,%eax
  802665:	39 c2                	cmp    %eax,%edx
  802667:	73 04                	jae    80266d <print_mem_block_lists+0x114>
			sorted = 0 ;
  802669:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80266d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802670:	8b 50 08             	mov    0x8(%eax),%edx
  802673:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802676:	8b 40 0c             	mov    0xc(%eax),%eax
  802679:	01 c2                	add    %eax,%edx
  80267b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267e:	8b 40 08             	mov    0x8(%eax),%eax
  802681:	83 ec 04             	sub    $0x4,%esp
  802684:	52                   	push   %edx
  802685:	50                   	push   %eax
  802686:	68 11 42 80 00       	push   $0x804211
  80268b:	e8 b5 e3 ff ff       	call   800a45 <cprintf>
  802690:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802693:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802696:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802699:	a1 48 50 80 00       	mov    0x805048,%eax
  80269e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a5:	74 07                	je     8026ae <print_mem_block_lists+0x155>
  8026a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026aa:	8b 00                	mov    (%eax),%eax
  8026ac:	eb 05                	jmp    8026b3 <print_mem_block_lists+0x15a>
  8026ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b3:	a3 48 50 80 00       	mov    %eax,0x805048
  8026b8:	a1 48 50 80 00       	mov    0x805048,%eax
  8026bd:	85 c0                	test   %eax,%eax
  8026bf:	75 8a                	jne    80264b <print_mem_block_lists+0xf2>
  8026c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026c5:	75 84                	jne    80264b <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8026c7:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8026cb:	75 10                	jne    8026dd <print_mem_block_lists+0x184>
  8026cd:	83 ec 0c             	sub    $0xc,%esp
  8026d0:	68 5c 42 80 00       	push   $0x80425c
  8026d5:	e8 6b e3 ff ff       	call   800a45 <cprintf>
  8026da:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8026dd:	83 ec 0c             	sub    $0xc,%esp
  8026e0:	68 d0 41 80 00       	push   $0x8041d0
  8026e5:	e8 5b e3 ff ff       	call   800a45 <cprintf>
  8026ea:	83 c4 10             	add    $0x10,%esp

}
  8026ed:	90                   	nop
  8026ee:	c9                   	leave  
  8026ef:	c3                   	ret    

008026f0 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8026f0:	55                   	push   %ebp
  8026f1:	89 e5                	mov    %esp,%ebp
  8026f3:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8026f6:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8026fd:	00 00 00 
  802700:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802707:	00 00 00 
  80270a:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802711:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  802714:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80271b:	e9 9e 00 00 00       	jmp    8027be <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802720:	a1 50 50 80 00       	mov    0x805050,%eax
  802725:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802728:	c1 e2 04             	shl    $0x4,%edx
  80272b:	01 d0                	add    %edx,%eax
  80272d:	85 c0                	test   %eax,%eax
  80272f:	75 14                	jne    802745 <initialize_MemBlocksList+0x55>
  802731:	83 ec 04             	sub    $0x4,%esp
  802734:	68 84 42 80 00       	push   $0x804284
  802739:	6a 42                	push   $0x42
  80273b:	68 a7 42 80 00       	push   $0x8042a7
  802740:	e8 4c e0 ff ff       	call   800791 <_panic>
  802745:	a1 50 50 80 00       	mov    0x805050,%eax
  80274a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80274d:	c1 e2 04             	shl    $0x4,%edx
  802750:	01 d0                	add    %edx,%eax
  802752:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802758:	89 10                	mov    %edx,(%eax)
  80275a:	8b 00                	mov    (%eax),%eax
  80275c:	85 c0                	test   %eax,%eax
  80275e:	74 18                	je     802778 <initialize_MemBlocksList+0x88>
  802760:	a1 48 51 80 00       	mov    0x805148,%eax
  802765:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80276b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80276e:	c1 e1 04             	shl    $0x4,%ecx
  802771:	01 ca                	add    %ecx,%edx
  802773:	89 50 04             	mov    %edx,0x4(%eax)
  802776:	eb 12                	jmp    80278a <initialize_MemBlocksList+0x9a>
  802778:	a1 50 50 80 00       	mov    0x805050,%eax
  80277d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802780:	c1 e2 04             	shl    $0x4,%edx
  802783:	01 d0                	add    %edx,%eax
  802785:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80278a:	a1 50 50 80 00       	mov    0x805050,%eax
  80278f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802792:	c1 e2 04             	shl    $0x4,%edx
  802795:	01 d0                	add    %edx,%eax
  802797:	a3 48 51 80 00       	mov    %eax,0x805148
  80279c:	a1 50 50 80 00       	mov    0x805050,%eax
  8027a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027a4:	c1 e2 04             	shl    $0x4,%edx
  8027a7:	01 d0                	add    %edx,%eax
  8027a9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027b0:	a1 54 51 80 00       	mov    0x805154,%eax
  8027b5:	40                   	inc    %eax
  8027b6:	a3 54 51 80 00       	mov    %eax,0x805154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  8027bb:	ff 45 f4             	incl   -0xc(%ebp)
  8027be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027c4:	0f 82 56 ff ff ff    	jb     802720 <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  8027ca:	90                   	nop
  8027cb:	c9                   	leave  
  8027cc:	c3                   	ret    

008027cd <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8027cd:	55                   	push   %ebp
  8027ce:	89 e5                	mov    %esp,%ebp
  8027d0:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  8027d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d6:	8b 00                	mov    (%eax),%eax
  8027d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8027db:	eb 19                	jmp    8027f6 <find_block+0x29>
	{
		if(blk->sva==va)
  8027dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027e0:	8b 40 08             	mov    0x8(%eax),%eax
  8027e3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8027e6:	75 05                	jne    8027ed <find_block+0x20>
			return (blk);
  8027e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027eb:	eb 36                	jmp    802823 <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  8027ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f0:	8b 40 08             	mov    0x8(%eax),%eax
  8027f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8027f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8027fa:	74 07                	je     802803 <find_block+0x36>
  8027fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027ff:	8b 00                	mov    (%eax),%eax
  802801:	eb 05                	jmp    802808 <find_block+0x3b>
  802803:	b8 00 00 00 00       	mov    $0x0,%eax
  802808:	8b 55 08             	mov    0x8(%ebp),%edx
  80280b:	89 42 08             	mov    %eax,0x8(%edx)
  80280e:	8b 45 08             	mov    0x8(%ebp),%eax
  802811:	8b 40 08             	mov    0x8(%eax),%eax
  802814:	85 c0                	test   %eax,%eax
  802816:	75 c5                	jne    8027dd <find_block+0x10>
  802818:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80281c:	75 bf                	jne    8027dd <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  80281e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802823:	c9                   	leave  
  802824:	c3                   	ret    

00802825 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802825:	55                   	push   %ebp
  802826:	89 e5                	mov    %esp,%ebp
  802828:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  80282b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802830:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802833:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  80283a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80283d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802840:	75 65                	jne    8028a7 <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802842:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802846:	75 14                	jne    80285c <insert_sorted_allocList+0x37>
  802848:	83 ec 04             	sub    $0x4,%esp
  80284b:	68 84 42 80 00       	push   $0x804284
  802850:	6a 5c                	push   $0x5c
  802852:	68 a7 42 80 00       	push   $0x8042a7
  802857:	e8 35 df ff ff       	call   800791 <_panic>
  80285c:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802862:	8b 45 08             	mov    0x8(%ebp),%eax
  802865:	89 10                	mov    %edx,(%eax)
  802867:	8b 45 08             	mov    0x8(%ebp),%eax
  80286a:	8b 00                	mov    (%eax),%eax
  80286c:	85 c0                	test   %eax,%eax
  80286e:	74 0d                	je     80287d <insert_sorted_allocList+0x58>
  802870:	a1 40 50 80 00       	mov    0x805040,%eax
  802875:	8b 55 08             	mov    0x8(%ebp),%edx
  802878:	89 50 04             	mov    %edx,0x4(%eax)
  80287b:	eb 08                	jmp    802885 <insert_sorted_allocList+0x60>
  80287d:	8b 45 08             	mov    0x8(%ebp),%eax
  802880:	a3 44 50 80 00       	mov    %eax,0x805044
  802885:	8b 45 08             	mov    0x8(%ebp),%eax
  802888:	a3 40 50 80 00       	mov    %eax,0x805040
  80288d:	8b 45 08             	mov    0x8(%ebp),%eax
  802890:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802897:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80289c:	40                   	inc    %eax
  80289d:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  8028a2:	e9 7b 01 00 00       	jmp    802a22 <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  8028a7:	a1 44 50 80 00       	mov    0x805044,%eax
  8028ac:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  8028af:	a1 40 50 80 00       	mov    0x805040,%eax
  8028b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  8028b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ba:	8b 50 08             	mov    0x8(%eax),%edx
  8028bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028c0:	8b 40 08             	mov    0x8(%eax),%eax
  8028c3:	39 c2                	cmp    %eax,%edx
  8028c5:	76 65                	jbe    80292c <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  8028c7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028cb:	75 14                	jne    8028e1 <insert_sorted_allocList+0xbc>
  8028cd:	83 ec 04             	sub    $0x4,%esp
  8028d0:	68 c0 42 80 00       	push   $0x8042c0
  8028d5:	6a 64                	push   $0x64
  8028d7:	68 a7 42 80 00       	push   $0x8042a7
  8028dc:	e8 b0 de ff ff       	call   800791 <_panic>
  8028e1:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8028e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ea:	89 50 04             	mov    %edx,0x4(%eax)
  8028ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f0:	8b 40 04             	mov    0x4(%eax),%eax
  8028f3:	85 c0                	test   %eax,%eax
  8028f5:	74 0c                	je     802903 <insert_sorted_allocList+0xde>
  8028f7:	a1 44 50 80 00       	mov    0x805044,%eax
  8028fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8028ff:	89 10                	mov    %edx,(%eax)
  802901:	eb 08                	jmp    80290b <insert_sorted_allocList+0xe6>
  802903:	8b 45 08             	mov    0x8(%ebp),%eax
  802906:	a3 40 50 80 00       	mov    %eax,0x805040
  80290b:	8b 45 08             	mov    0x8(%ebp),%eax
  80290e:	a3 44 50 80 00       	mov    %eax,0x805044
  802913:	8b 45 08             	mov    0x8(%ebp),%eax
  802916:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80291c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802921:	40                   	inc    %eax
  802922:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  802927:	e9 f6 00 00 00       	jmp    802a22 <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  80292c:	8b 45 08             	mov    0x8(%ebp),%eax
  80292f:	8b 50 08             	mov    0x8(%eax),%edx
  802932:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802935:	8b 40 08             	mov    0x8(%eax),%eax
  802938:	39 c2                	cmp    %eax,%edx
  80293a:	73 65                	jae    8029a1 <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80293c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802940:	75 14                	jne    802956 <insert_sorted_allocList+0x131>
  802942:	83 ec 04             	sub    $0x4,%esp
  802945:	68 84 42 80 00       	push   $0x804284
  80294a:	6a 68                	push   $0x68
  80294c:	68 a7 42 80 00       	push   $0x8042a7
  802951:	e8 3b de ff ff       	call   800791 <_panic>
  802956:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80295c:	8b 45 08             	mov    0x8(%ebp),%eax
  80295f:	89 10                	mov    %edx,(%eax)
  802961:	8b 45 08             	mov    0x8(%ebp),%eax
  802964:	8b 00                	mov    (%eax),%eax
  802966:	85 c0                	test   %eax,%eax
  802968:	74 0d                	je     802977 <insert_sorted_allocList+0x152>
  80296a:	a1 40 50 80 00       	mov    0x805040,%eax
  80296f:	8b 55 08             	mov    0x8(%ebp),%edx
  802972:	89 50 04             	mov    %edx,0x4(%eax)
  802975:	eb 08                	jmp    80297f <insert_sorted_allocList+0x15a>
  802977:	8b 45 08             	mov    0x8(%ebp),%eax
  80297a:	a3 44 50 80 00       	mov    %eax,0x805044
  80297f:	8b 45 08             	mov    0x8(%ebp),%eax
  802982:	a3 40 50 80 00       	mov    %eax,0x805040
  802987:	8b 45 08             	mov    0x8(%ebp),%eax
  80298a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802991:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802996:	40                   	inc    %eax
  802997:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  80299c:	e9 81 00 00 00       	jmp    802a22 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  8029a1:	a1 40 50 80 00       	mov    0x805040,%eax
  8029a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029a9:	eb 51                	jmp    8029fc <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  8029ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ae:	8b 50 08             	mov    0x8(%eax),%edx
  8029b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b4:	8b 40 08             	mov    0x8(%eax),%eax
  8029b7:	39 c2                	cmp    %eax,%edx
  8029b9:	73 39                	jae    8029f4 <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  8029bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029be:	8b 40 04             	mov    0x4(%eax),%eax
  8029c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  8029c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8029ca:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  8029cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8029d2:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  8029d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029db:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  8029dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8029e3:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  8029e6:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029eb:	40                   	inc    %eax
  8029ec:	a3 4c 50 80 00       	mov    %eax,0x80504c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  8029f1:	90                   	nop
				}
			}
		 }

	}
}
  8029f2:	eb 2e                	jmp    802a22 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  8029f4:	a1 48 50 80 00       	mov    0x805048,%eax
  8029f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a00:	74 07                	je     802a09 <insert_sorted_allocList+0x1e4>
  802a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a05:	8b 00                	mov    (%eax),%eax
  802a07:	eb 05                	jmp    802a0e <insert_sorted_allocList+0x1e9>
  802a09:	b8 00 00 00 00       	mov    $0x0,%eax
  802a0e:	a3 48 50 80 00       	mov    %eax,0x805048
  802a13:	a1 48 50 80 00       	mov    0x805048,%eax
  802a18:	85 c0                	test   %eax,%eax
  802a1a:	75 8f                	jne    8029ab <insert_sorted_allocList+0x186>
  802a1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a20:	75 89                	jne    8029ab <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  802a22:	90                   	nop
  802a23:	c9                   	leave  
  802a24:	c3                   	ret    

00802a25 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802a25:	55                   	push   %ebp
  802a26:	89 e5                	mov    %esp,%ebp
  802a28:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802a2b:	a1 38 51 80 00       	mov    0x805138,%eax
  802a30:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a33:	e9 76 01 00 00       	jmp    802bae <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  802a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3b:	8b 40 0c             	mov    0xc(%eax),%eax
  802a3e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a41:	0f 85 8a 00 00 00    	jne    802ad1 <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  802a47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a4b:	75 17                	jne    802a64 <alloc_block_FF+0x3f>
  802a4d:	83 ec 04             	sub    $0x4,%esp
  802a50:	68 e3 42 80 00       	push   $0x8042e3
  802a55:	68 8a 00 00 00       	push   $0x8a
  802a5a:	68 a7 42 80 00       	push   $0x8042a7
  802a5f:	e8 2d dd ff ff       	call   800791 <_panic>
  802a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a67:	8b 00                	mov    (%eax),%eax
  802a69:	85 c0                	test   %eax,%eax
  802a6b:	74 10                	je     802a7d <alloc_block_FF+0x58>
  802a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a70:	8b 00                	mov    (%eax),%eax
  802a72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a75:	8b 52 04             	mov    0x4(%edx),%edx
  802a78:	89 50 04             	mov    %edx,0x4(%eax)
  802a7b:	eb 0b                	jmp    802a88 <alloc_block_FF+0x63>
  802a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a80:	8b 40 04             	mov    0x4(%eax),%eax
  802a83:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8b:	8b 40 04             	mov    0x4(%eax),%eax
  802a8e:	85 c0                	test   %eax,%eax
  802a90:	74 0f                	je     802aa1 <alloc_block_FF+0x7c>
  802a92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a95:	8b 40 04             	mov    0x4(%eax),%eax
  802a98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a9b:	8b 12                	mov    (%edx),%edx
  802a9d:	89 10                	mov    %edx,(%eax)
  802a9f:	eb 0a                	jmp    802aab <alloc_block_FF+0x86>
  802aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa4:	8b 00                	mov    (%eax),%eax
  802aa6:	a3 38 51 80 00       	mov    %eax,0x805138
  802aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802abe:	a1 44 51 80 00       	mov    0x805144,%eax
  802ac3:	48                   	dec    %eax
  802ac4:	a3 44 51 80 00       	mov    %eax,0x805144
			return element;
  802ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acc:	e9 10 01 00 00       	jmp    802be1 <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  802ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ad7:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ada:	0f 86 c6 00 00 00    	jbe    802ba6 <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802ae0:	a1 48 51 80 00       	mov    0x805148,%eax
  802ae5:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802ae8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802aec:	75 17                	jne    802b05 <alloc_block_FF+0xe0>
  802aee:	83 ec 04             	sub    $0x4,%esp
  802af1:	68 e3 42 80 00       	push   $0x8042e3
  802af6:	68 90 00 00 00       	push   $0x90
  802afb:	68 a7 42 80 00       	push   $0x8042a7
  802b00:	e8 8c dc ff ff       	call   800791 <_panic>
  802b05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b08:	8b 00                	mov    (%eax),%eax
  802b0a:	85 c0                	test   %eax,%eax
  802b0c:	74 10                	je     802b1e <alloc_block_FF+0xf9>
  802b0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b11:	8b 00                	mov    (%eax),%eax
  802b13:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b16:	8b 52 04             	mov    0x4(%edx),%edx
  802b19:	89 50 04             	mov    %edx,0x4(%eax)
  802b1c:	eb 0b                	jmp    802b29 <alloc_block_FF+0x104>
  802b1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b21:	8b 40 04             	mov    0x4(%eax),%eax
  802b24:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2c:	8b 40 04             	mov    0x4(%eax),%eax
  802b2f:	85 c0                	test   %eax,%eax
  802b31:	74 0f                	je     802b42 <alloc_block_FF+0x11d>
  802b33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b36:	8b 40 04             	mov    0x4(%eax),%eax
  802b39:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b3c:	8b 12                	mov    (%edx),%edx
  802b3e:	89 10                	mov    %edx,(%eax)
  802b40:	eb 0a                	jmp    802b4c <alloc_block_FF+0x127>
  802b42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b45:	8b 00                	mov    (%eax),%eax
  802b47:	a3 48 51 80 00       	mov    %eax,0x805148
  802b4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b4f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b58:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b5f:	a1 54 51 80 00       	mov    0x805154,%eax
  802b64:	48                   	dec    %eax
  802b65:	a3 54 51 80 00       	mov    %eax,0x805154
			 element1->size =size;
  802b6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6d:	8b 55 08             	mov    0x8(%ebp),%edx
  802b70:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  802b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b76:	8b 50 08             	mov    0x8(%eax),%edx
  802b79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b7c:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  802b7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b82:	8b 50 08             	mov    0x8(%eax),%edx
  802b85:	8b 45 08             	mov    0x8(%ebp),%eax
  802b88:	01 c2                	add    %eax,%edx
  802b8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8d:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  802b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b93:	8b 40 0c             	mov    0xc(%eax),%eax
  802b96:	2b 45 08             	sub    0x8(%ebp),%eax
  802b99:	89 c2                	mov    %eax,%edx
  802b9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9e:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  802ba1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba4:	eb 3b                	jmp    802be1 <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802ba6:	a1 40 51 80 00       	mov    0x805140,%eax
  802bab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bb2:	74 07                	je     802bbb <alloc_block_FF+0x196>
  802bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb7:	8b 00                	mov    (%eax),%eax
  802bb9:	eb 05                	jmp    802bc0 <alloc_block_FF+0x19b>
  802bbb:	b8 00 00 00 00       	mov    $0x0,%eax
  802bc0:	a3 40 51 80 00       	mov    %eax,0x805140
  802bc5:	a1 40 51 80 00       	mov    0x805140,%eax
  802bca:	85 c0                	test   %eax,%eax
  802bcc:	0f 85 66 fe ff ff    	jne    802a38 <alloc_block_FF+0x13>
  802bd2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bd6:	0f 85 5c fe ff ff    	jne    802a38 <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  802bdc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802be1:	c9                   	leave  
  802be2:	c3                   	ret    

00802be3 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802be3:	55                   	push   %ebp
  802be4:	89 e5                	mov    %esp,%ebp
  802be6:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  802be9:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  802bf0:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  802bf7:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802bfe:	a1 38 51 80 00       	mov    0x805138,%eax
  802c03:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c06:	e9 cf 00 00 00       	jmp    802cda <alloc_block_BF+0xf7>
		{
			c++;
  802c0b:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  802c0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c11:	8b 40 0c             	mov    0xc(%eax),%eax
  802c14:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c17:	0f 85 8a 00 00 00    	jne    802ca7 <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  802c1d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c21:	75 17                	jne    802c3a <alloc_block_BF+0x57>
  802c23:	83 ec 04             	sub    $0x4,%esp
  802c26:	68 e3 42 80 00       	push   $0x8042e3
  802c2b:	68 a8 00 00 00       	push   $0xa8
  802c30:	68 a7 42 80 00       	push   $0x8042a7
  802c35:	e8 57 db ff ff       	call   800791 <_panic>
  802c3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3d:	8b 00                	mov    (%eax),%eax
  802c3f:	85 c0                	test   %eax,%eax
  802c41:	74 10                	je     802c53 <alloc_block_BF+0x70>
  802c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c46:	8b 00                	mov    (%eax),%eax
  802c48:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c4b:	8b 52 04             	mov    0x4(%edx),%edx
  802c4e:	89 50 04             	mov    %edx,0x4(%eax)
  802c51:	eb 0b                	jmp    802c5e <alloc_block_BF+0x7b>
  802c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c56:	8b 40 04             	mov    0x4(%eax),%eax
  802c59:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c61:	8b 40 04             	mov    0x4(%eax),%eax
  802c64:	85 c0                	test   %eax,%eax
  802c66:	74 0f                	je     802c77 <alloc_block_BF+0x94>
  802c68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6b:	8b 40 04             	mov    0x4(%eax),%eax
  802c6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c71:	8b 12                	mov    (%edx),%edx
  802c73:	89 10                	mov    %edx,(%eax)
  802c75:	eb 0a                	jmp    802c81 <alloc_block_BF+0x9e>
  802c77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7a:	8b 00                	mov    (%eax),%eax
  802c7c:	a3 38 51 80 00       	mov    %eax,0x805138
  802c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c84:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c94:	a1 44 51 80 00       	mov    0x805144,%eax
  802c99:	48                   	dec    %eax
  802c9a:	a3 44 51 80 00       	mov    %eax,0x805144
				return block;
  802c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca2:	e9 85 01 00 00       	jmp    802e2c <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  802ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802caa:	8b 40 0c             	mov    0xc(%eax),%eax
  802cad:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cb0:	76 20                	jbe    802cd2 <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  802cb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb5:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb8:	2b 45 08             	sub    0x8(%ebp),%eax
  802cbb:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  802cbe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cc1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802cc4:	73 0c                	jae    802cd2 <alloc_block_BF+0xef>
				{
					ma=tempi;
  802cc6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802cc9:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  802ccc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ccf:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802cd2:	a1 40 51 80 00       	mov    0x805140,%eax
  802cd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cda:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cde:	74 07                	je     802ce7 <alloc_block_BF+0x104>
  802ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce3:	8b 00                	mov    (%eax),%eax
  802ce5:	eb 05                	jmp    802cec <alloc_block_BF+0x109>
  802ce7:	b8 00 00 00 00       	mov    $0x0,%eax
  802cec:	a3 40 51 80 00       	mov    %eax,0x805140
  802cf1:	a1 40 51 80 00       	mov    0x805140,%eax
  802cf6:	85 c0                	test   %eax,%eax
  802cf8:	0f 85 0d ff ff ff    	jne    802c0b <alloc_block_BF+0x28>
  802cfe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d02:	0f 85 03 ff ff ff    	jne    802c0b <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  802d08:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802d0f:	a1 38 51 80 00       	mov    0x805138,%eax
  802d14:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d17:	e9 dd 00 00 00       	jmp    802df9 <alloc_block_BF+0x216>
		{
			if(x==sol)
  802d1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d1f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802d22:	0f 85 c6 00 00 00    	jne    802dee <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802d28:	a1 48 51 80 00       	mov    0x805148,%eax
  802d2d:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802d30:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802d34:	75 17                	jne    802d4d <alloc_block_BF+0x16a>
  802d36:	83 ec 04             	sub    $0x4,%esp
  802d39:	68 e3 42 80 00       	push   $0x8042e3
  802d3e:	68 bb 00 00 00       	push   $0xbb
  802d43:	68 a7 42 80 00       	push   $0x8042a7
  802d48:	e8 44 da ff ff       	call   800791 <_panic>
  802d4d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d50:	8b 00                	mov    (%eax),%eax
  802d52:	85 c0                	test   %eax,%eax
  802d54:	74 10                	je     802d66 <alloc_block_BF+0x183>
  802d56:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d59:	8b 00                	mov    (%eax),%eax
  802d5b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d5e:	8b 52 04             	mov    0x4(%edx),%edx
  802d61:	89 50 04             	mov    %edx,0x4(%eax)
  802d64:	eb 0b                	jmp    802d71 <alloc_block_BF+0x18e>
  802d66:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d69:	8b 40 04             	mov    0x4(%eax),%eax
  802d6c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d71:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d74:	8b 40 04             	mov    0x4(%eax),%eax
  802d77:	85 c0                	test   %eax,%eax
  802d79:	74 0f                	je     802d8a <alloc_block_BF+0x1a7>
  802d7b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d7e:	8b 40 04             	mov    0x4(%eax),%eax
  802d81:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d84:	8b 12                	mov    (%edx),%edx
  802d86:	89 10                	mov    %edx,(%eax)
  802d88:	eb 0a                	jmp    802d94 <alloc_block_BF+0x1b1>
  802d8a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d8d:	8b 00                	mov    (%eax),%eax
  802d8f:	a3 48 51 80 00       	mov    %eax,0x805148
  802d94:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d97:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802da0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802da7:	a1 54 51 80 00       	mov    0x805154,%eax
  802dac:	48                   	dec    %eax
  802dad:	a3 54 51 80 00       	mov    %eax,0x805154
						 element1->size =size;
  802db2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802db5:	8b 55 08             	mov    0x8(%ebp),%edx
  802db8:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  802dbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbe:	8b 50 08             	mov    0x8(%eax),%edx
  802dc1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dc4:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  802dc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dca:	8b 50 08             	mov    0x8(%eax),%edx
  802dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd0:	01 c2                	add    %eax,%edx
  802dd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd5:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  802dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddb:	8b 40 0c             	mov    0xc(%eax),%eax
  802dde:	2b 45 08             	sub    0x8(%ebp),%eax
  802de1:	89 c2                	mov    %eax,%edx
  802de3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de6:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  802de9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dec:	eb 3e                	jmp    802e2c <alloc_block_BF+0x249>
						 break;
			}
			x++;
  802dee:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802df1:	a1 40 51 80 00       	mov    0x805140,%eax
  802df6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802df9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dfd:	74 07                	je     802e06 <alloc_block_BF+0x223>
  802dff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e02:	8b 00                	mov    (%eax),%eax
  802e04:	eb 05                	jmp    802e0b <alloc_block_BF+0x228>
  802e06:	b8 00 00 00 00       	mov    $0x0,%eax
  802e0b:	a3 40 51 80 00       	mov    %eax,0x805140
  802e10:	a1 40 51 80 00       	mov    0x805140,%eax
  802e15:	85 c0                	test   %eax,%eax
  802e17:	0f 85 ff fe ff ff    	jne    802d1c <alloc_block_BF+0x139>
  802e1d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e21:	0f 85 f5 fe ff ff    	jne    802d1c <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  802e27:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e2c:	c9                   	leave  
  802e2d:	c3                   	ret    

00802e2e <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802e2e:	55                   	push   %ebp
  802e2f:	89 e5                	mov    %esp,%ebp
  802e31:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  802e34:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802e39:	85 c0                	test   %eax,%eax
  802e3b:	75 14                	jne    802e51 <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  802e3d:	a1 38 51 80 00       	mov    0x805138,%eax
  802e42:	a3 60 51 80 00       	mov    %eax,0x805160
		hh=1;
  802e47:	c7 05 2c 50 80 00 01 	movl   $0x1,0x80502c
  802e4e:	00 00 00 
	}
	uint32 c=1;
  802e51:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  802e58:	a1 60 51 80 00       	mov    0x805160,%eax
  802e5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802e60:	e9 b3 01 00 00       	jmp    803018 <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  802e65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e68:	8b 40 0c             	mov    0xc(%eax),%eax
  802e6b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e6e:	0f 85 a9 00 00 00    	jne    802f1d <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  802e74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e77:	8b 00                	mov    (%eax),%eax
  802e79:	85 c0                	test   %eax,%eax
  802e7b:	75 0c                	jne    802e89 <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  802e7d:	a1 38 51 80 00       	mov    0x805138,%eax
  802e82:	a3 60 51 80 00       	mov    %eax,0x805160
  802e87:	eb 0a                	jmp    802e93 <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  802e89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e8c:	8b 00                	mov    (%eax),%eax
  802e8e:	a3 60 51 80 00       	mov    %eax,0x805160
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  802e93:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e97:	75 17                	jne    802eb0 <alloc_block_NF+0x82>
  802e99:	83 ec 04             	sub    $0x4,%esp
  802e9c:	68 e3 42 80 00       	push   $0x8042e3
  802ea1:	68 e3 00 00 00       	push   $0xe3
  802ea6:	68 a7 42 80 00       	push   $0x8042a7
  802eab:	e8 e1 d8 ff ff       	call   800791 <_panic>
  802eb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb3:	8b 00                	mov    (%eax),%eax
  802eb5:	85 c0                	test   %eax,%eax
  802eb7:	74 10                	je     802ec9 <alloc_block_NF+0x9b>
  802eb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ebc:	8b 00                	mov    (%eax),%eax
  802ebe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ec1:	8b 52 04             	mov    0x4(%edx),%edx
  802ec4:	89 50 04             	mov    %edx,0x4(%eax)
  802ec7:	eb 0b                	jmp    802ed4 <alloc_block_NF+0xa6>
  802ec9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ecc:	8b 40 04             	mov    0x4(%eax),%eax
  802ecf:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ed4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ed7:	8b 40 04             	mov    0x4(%eax),%eax
  802eda:	85 c0                	test   %eax,%eax
  802edc:	74 0f                	je     802eed <alloc_block_NF+0xbf>
  802ede:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ee1:	8b 40 04             	mov    0x4(%eax),%eax
  802ee4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ee7:	8b 12                	mov    (%edx),%edx
  802ee9:	89 10                	mov    %edx,(%eax)
  802eeb:	eb 0a                	jmp    802ef7 <alloc_block_NF+0xc9>
  802eed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ef0:	8b 00                	mov    (%eax),%eax
  802ef2:	a3 38 51 80 00       	mov    %eax,0x805138
  802ef7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802efa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f03:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f0a:	a1 44 51 80 00       	mov    0x805144,%eax
  802f0f:	48                   	dec    %eax
  802f10:	a3 44 51 80 00       	mov    %eax,0x805144
				return element;
  802f15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f18:	e9 0e 01 00 00       	jmp    80302b <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  802f1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f20:	8b 40 0c             	mov    0xc(%eax),%eax
  802f23:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f26:	0f 86 ce 00 00 00    	jbe    802ffa <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802f2c:	a1 48 51 80 00       	mov    0x805148,%eax
  802f31:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802f34:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f38:	75 17                	jne    802f51 <alloc_block_NF+0x123>
  802f3a:	83 ec 04             	sub    $0x4,%esp
  802f3d:	68 e3 42 80 00       	push   $0x8042e3
  802f42:	68 e9 00 00 00       	push   $0xe9
  802f47:	68 a7 42 80 00       	push   $0x8042a7
  802f4c:	e8 40 d8 ff ff       	call   800791 <_panic>
  802f51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f54:	8b 00                	mov    (%eax),%eax
  802f56:	85 c0                	test   %eax,%eax
  802f58:	74 10                	je     802f6a <alloc_block_NF+0x13c>
  802f5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f5d:	8b 00                	mov    (%eax),%eax
  802f5f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f62:	8b 52 04             	mov    0x4(%edx),%edx
  802f65:	89 50 04             	mov    %edx,0x4(%eax)
  802f68:	eb 0b                	jmp    802f75 <alloc_block_NF+0x147>
  802f6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f6d:	8b 40 04             	mov    0x4(%eax),%eax
  802f70:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f78:	8b 40 04             	mov    0x4(%eax),%eax
  802f7b:	85 c0                	test   %eax,%eax
  802f7d:	74 0f                	je     802f8e <alloc_block_NF+0x160>
  802f7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f82:	8b 40 04             	mov    0x4(%eax),%eax
  802f85:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f88:	8b 12                	mov    (%edx),%edx
  802f8a:	89 10                	mov    %edx,(%eax)
  802f8c:	eb 0a                	jmp    802f98 <alloc_block_NF+0x16a>
  802f8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f91:	8b 00                	mov    (%eax),%eax
  802f93:	a3 48 51 80 00       	mov    %eax,0x805148
  802f98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f9b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fa1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fa4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fab:	a1 54 51 80 00       	mov    0x805154,%eax
  802fb0:	48                   	dec    %eax
  802fb1:	a3 54 51 80 00       	mov    %eax,0x805154
				 element1->size =size;
  802fb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fb9:	8b 55 08             	mov    0x8(%ebp),%edx
  802fbc:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  802fbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc2:	8b 50 08             	mov    0x8(%eax),%edx
  802fc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fc8:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  802fcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fce:	8b 50 08             	mov    0x8(%eax),%edx
  802fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd4:	01 c2                	add    %eax,%edx
  802fd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fd9:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  802fdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fdf:	8b 40 0c             	mov    0xc(%eax),%eax
  802fe2:	2b 45 08             	sub    0x8(%ebp),%eax
  802fe5:	89 c2                	mov    %eax,%edx
  802fe7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fea:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  802fed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff0:	a3 60 51 80 00       	mov    %eax,0x805160
				 return element1;
  802ff5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ff8:	eb 31                	jmp    80302b <alloc_block_NF+0x1fd>
			 }
		 c++;
  802ffa:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  802ffd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803000:	8b 00                	mov    (%eax),%eax
  803002:	85 c0                	test   %eax,%eax
  803004:	75 0a                	jne    803010 <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  803006:	a1 38 51 80 00       	mov    0x805138,%eax
  80300b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80300e:	eb 08                	jmp    803018 <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  803010:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803013:	8b 00                	mov    (%eax),%eax
  803015:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  803018:	a1 44 51 80 00       	mov    0x805144,%eax
  80301d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803020:	0f 85 3f fe ff ff    	jne    802e65 <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  803026:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80302b:	c9                   	leave  
  80302c:	c3                   	ret    

0080302d <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80302d:	55                   	push   %ebp
  80302e:	89 e5                	mov    %esp,%ebp
  803030:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  803033:	a1 44 51 80 00       	mov    0x805144,%eax
  803038:	85 c0                	test   %eax,%eax
  80303a:	75 68                	jne    8030a4 <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  80303c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803040:	75 17                	jne    803059 <insert_sorted_with_merge_freeList+0x2c>
  803042:	83 ec 04             	sub    $0x4,%esp
  803045:	68 84 42 80 00       	push   $0x804284
  80304a:	68 0e 01 00 00       	push   $0x10e
  80304f:	68 a7 42 80 00       	push   $0x8042a7
  803054:	e8 38 d7 ff ff       	call   800791 <_panic>
  803059:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80305f:	8b 45 08             	mov    0x8(%ebp),%eax
  803062:	89 10                	mov    %edx,(%eax)
  803064:	8b 45 08             	mov    0x8(%ebp),%eax
  803067:	8b 00                	mov    (%eax),%eax
  803069:	85 c0                	test   %eax,%eax
  80306b:	74 0d                	je     80307a <insert_sorted_with_merge_freeList+0x4d>
  80306d:	a1 38 51 80 00       	mov    0x805138,%eax
  803072:	8b 55 08             	mov    0x8(%ebp),%edx
  803075:	89 50 04             	mov    %edx,0x4(%eax)
  803078:	eb 08                	jmp    803082 <insert_sorted_with_merge_freeList+0x55>
  80307a:	8b 45 08             	mov    0x8(%ebp),%eax
  80307d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803082:	8b 45 08             	mov    0x8(%ebp),%eax
  803085:	a3 38 51 80 00       	mov    %eax,0x805138
  80308a:	8b 45 08             	mov    0x8(%ebp),%eax
  80308d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803094:	a1 44 51 80 00       	mov    0x805144,%eax
  803099:	40                   	inc    %eax
  80309a:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  80309f:	e9 8c 06 00 00       	jmp    803730 <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  8030a4:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8030a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  8030ac:	a1 38 51 80 00       	mov    0x805138,%eax
  8030b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  8030b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b7:	8b 50 08             	mov    0x8(%eax),%edx
  8030ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030bd:	8b 40 08             	mov    0x8(%eax),%eax
  8030c0:	39 c2                	cmp    %eax,%edx
  8030c2:	0f 86 14 01 00 00    	jbe    8031dc <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  8030c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030cb:	8b 50 0c             	mov    0xc(%eax),%edx
  8030ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030d1:	8b 40 08             	mov    0x8(%eax),%eax
  8030d4:	01 c2                	add    %eax,%edx
  8030d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d9:	8b 40 08             	mov    0x8(%eax),%eax
  8030dc:	39 c2                	cmp    %eax,%edx
  8030de:	0f 85 90 00 00 00    	jne    803174 <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  8030e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e7:	8b 50 0c             	mov    0xc(%eax),%edx
  8030ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8030f0:	01 c2                	add    %eax,%edx
  8030f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f5:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  8030f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  803102:	8b 45 08             	mov    0x8(%ebp),%eax
  803105:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80310c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803110:	75 17                	jne    803129 <insert_sorted_with_merge_freeList+0xfc>
  803112:	83 ec 04             	sub    $0x4,%esp
  803115:	68 84 42 80 00       	push   $0x804284
  80311a:	68 1b 01 00 00       	push   $0x11b
  80311f:	68 a7 42 80 00       	push   $0x8042a7
  803124:	e8 68 d6 ff ff       	call   800791 <_panic>
  803129:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80312f:	8b 45 08             	mov    0x8(%ebp),%eax
  803132:	89 10                	mov    %edx,(%eax)
  803134:	8b 45 08             	mov    0x8(%ebp),%eax
  803137:	8b 00                	mov    (%eax),%eax
  803139:	85 c0                	test   %eax,%eax
  80313b:	74 0d                	je     80314a <insert_sorted_with_merge_freeList+0x11d>
  80313d:	a1 48 51 80 00       	mov    0x805148,%eax
  803142:	8b 55 08             	mov    0x8(%ebp),%edx
  803145:	89 50 04             	mov    %edx,0x4(%eax)
  803148:	eb 08                	jmp    803152 <insert_sorted_with_merge_freeList+0x125>
  80314a:	8b 45 08             	mov    0x8(%ebp),%eax
  80314d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803152:	8b 45 08             	mov    0x8(%ebp),%eax
  803155:	a3 48 51 80 00       	mov    %eax,0x805148
  80315a:	8b 45 08             	mov    0x8(%ebp),%eax
  80315d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803164:	a1 54 51 80 00       	mov    0x805154,%eax
  803169:	40                   	inc    %eax
  80316a:	a3 54 51 80 00       	mov    %eax,0x805154
							}

						}
		          }
		}
}
  80316f:	e9 bc 05 00 00       	jmp    803730 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803174:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803178:	75 17                	jne    803191 <insert_sorted_with_merge_freeList+0x164>
  80317a:	83 ec 04             	sub    $0x4,%esp
  80317d:	68 c0 42 80 00       	push   $0x8042c0
  803182:	68 1f 01 00 00       	push   $0x11f
  803187:	68 a7 42 80 00       	push   $0x8042a7
  80318c:	e8 00 d6 ff ff       	call   800791 <_panic>
  803191:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803197:	8b 45 08             	mov    0x8(%ebp),%eax
  80319a:	89 50 04             	mov    %edx,0x4(%eax)
  80319d:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a0:	8b 40 04             	mov    0x4(%eax),%eax
  8031a3:	85 c0                	test   %eax,%eax
  8031a5:	74 0c                	je     8031b3 <insert_sorted_with_merge_freeList+0x186>
  8031a7:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8031ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8031af:	89 10                	mov    %edx,(%eax)
  8031b1:	eb 08                	jmp    8031bb <insert_sorted_with_merge_freeList+0x18e>
  8031b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b6:	a3 38 51 80 00       	mov    %eax,0x805138
  8031bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031be:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031cc:	a1 44 51 80 00       	mov    0x805144,%eax
  8031d1:	40                   	inc    %eax
  8031d2:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  8031d7:	e9 54 05 00 00       	jmp    803730 <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  8031dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031df:	8b 50 08             	mov    0x8(%eax),%edx
  8031e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031e5:	8b 40 08             	mov    0x8(%eax),%eax
  8031e8:	39 c2                	cmp    %eax,%edx
  8031ea:	0f 83 20 01 00 00    	jae    803310 <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  8031f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f3:	8b 50 0c             	mov    0xc(%eax),%edx
  8031f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f9:	8b 40 08             	mov    0x8(%eax),%eax
  8031fc:	01 c2                	add    %eax,%edx
  8031fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803201:	8b 40 08             	mov    0x8(%eax),%eax
  803204:	39 c2                	cmp    %eax,%edx
  803206:	0f 85 9c 00 00 00    	jne    8032a8 <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  80320c:	8b 45 08             	mov    0x8(%ebp),%eax
  80320f:	8b 50 08             	mov    0x8(%eax),%edx
  803212:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803215:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  803218:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80321b:	8b 50 0c             	mov    0xc(%eax),%edx
  80321e:	8b 45 08             	mov    0x8(%ebp),%eax
  803221:	8b 40 0c             	mov    0xc(%eax),%eax
  803224:	01 c2                	add    %eax,%edx
  803226:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803229:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  80322c:	8b 45 08             	mov    0x8(%ebp),%eax
  80322f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  803236:	8b 45 08             	mov    0x8(%ebp),%eax
  803239:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803240:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803244:	75 17                	jne    80325d <insert_sorted_with_merge_freeList+0x230>
  803246:	83 ec 04             	sub    $0x4,%esp
  803249:	68 84 42 80 00       	push   $0x804284
  80324e:	68 2a 01 00 00       	push   $0x12a
  803253:	68 a7 42 80 00       	push   $0x8042a7
  803258:	e8 34 d5 ff ff       	call   800791 <_panic>
  80325d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803263:	8b 45 08             	mov    0x8(%ebp),%eax
  803266:	89 10                	mov    %edx,(%eax)
  803268:	8b 45 08             	mov    0x8(%ebp),%eax
  80326b:	8b 00                	mov    (%eax),%eax
  80326d:	85 c0                	test   %eax,%eax
  80326f:	74 0d                	je     80327e <insert_sorted_with_merge_freeList+0x251>
  803271:	a1 48 51 80 00       	mov    0x805148,%eax
  803276:	8b 55 08             	mov    0x8(%ebp),%edx
  803279:	89 50 04             	mov    %edx,0x4(%eax)
  80327c:	eb 08                	jmp    803286 <insert_sorted_with_merge_freeList+0x259>
  80327e:	8b 45 08             	mov    0x8(%ebp),%eax
  803281:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803286:	8b 45 08             	mov    0x8(%ebp),%eax
  803289:	a3 48 51 80 00       	mov    %eax,0x805148
  80328e:	8b 45 08             	mov    0x8(%ebp),%eax
  803291:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803298:	a1 54 51 80 00       	mov    0x805154,%eax
  80329d:	40                   	inc    %eax
  80329e:	a3 54 51 80 00       	mov    %eax,0x805154
							}

						}
		          }
		}
}
  8032a3:	e9 88 04 00 00       	jmp    803730 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8032a8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032ac:	75 17                	jne    8032c5 <insert_sorted_with_merge_freeList+0x298>
  8032ae:	83 ec 04             	sub    $0x4,%esp
  8032b1:	68 84 42 80 00       	push   $0x804284
  8032b6:	68 2e 01 00 00       	push   $0x12e
  8032bb:	68 a7 42 80 00       	push   $0x8042a7
  8032c0:	e8 cc d4 ff ff       	call   800791 <_panic>
  8032c5:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8032cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ce:	89 10                	mov    %edx,(%eax)
  8032d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d3:	8b 00                	mov    (%eax),%eax
  8032d5:	85 c0                	test   %eax,%eax
  8032d7:	74 0d                	je     8032e6 <insert_sorted_with_merge_freeList+0x2b9>
  8032d9:	a1 38 51 80 00       	mov    0x805138,%eax
  8032de:	8b 55 08             	mov    0x8(%ebp),%edx
  8032e1:	89 50 04             	mov    %edx,0x4(%eax)
  8032e4:	eb 08                	jmp    8032ee <insert_sorted_with_merge_freeList+0x2c1>
  8032e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f1:	a3 38 51 80 00       	mov    %eax,0x805138
  8032f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803300:	a1 44 51 80 00       	mov    0x805144,%eax
  803305:	40                   	inc    %eax
  803306:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  80330b:	e9 20 04 00 00       	jmp    803730 <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  803310:	a1 38 51 80 00       	mov    0x805138,%eax
  803315:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803318:	e9 e2 03 00 00       	jmp    8036ff <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  80331d:	8b 45 08             	mov    0x8(%ebp),%eax
  803320:	8b 50 08             	mov    0x8(%eax),%edx
  803323:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803326:	8b 40 08             	mov    0x8(%eax),%eax
  803329:	39 c2                	cmp    %eax,%edx
  80332b:	0f 83 c6 03 00 00    	jae    8036f7 <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  803331:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803334:	8b 40 04             	mov    0x4(%eax),%eax
  803337:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  80333a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80333d:	8b 50 08             	mov    0x8(%eax),%edx
  803340:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803343:	8b 40 0c             	mov    0xc(%eax),%eax
  803346:	01 d0                	add    %edx,%eax
  803348:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  80334b:	8b 45 08             	mov    0x8(%ebp),%eax
  80334e:	8b 50 0c             	mov    0xc(%eax),%edx
  803351:	8b 45 08             	mov    0x8(%ebp),%eax
  803354:	8b 40 08             	mov    0x8(%eax),%eax
  803357:	01 d0                	add    %edx,%eax
  803359:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  80335c:	8b 45 08             	mov    0x8(%ebp),%eax
  80335f:	8b 40 08             	mov    0x8(%eax),%eax
  803362:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803365:	74 7a                	je     8033e1 <insert_sorted_with_merge_freeList+0x3b4>
  803367:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336a:	8b 40 08             	mov    0x8(%eax),%eax
  80336d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803370:	74 6f                	je     8033e1 <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  803372:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803376:	74 06                	je     80337e <insert_sorted_with_merge_freeList+0x351>
  803378:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80337c:	75 17                	jne    803395 <insert_sorted_with_merge_freeList+0x368>
  80337e:	83 ec 04             	sub    $0x4,%esp
  803381:	68 04 43 80 00       	push   $0x804304
  803386:	68 43 01 00 00       	push   $0x143
  80338b:	68 a7 42 80 00       	push   $0x8042a7
  803390:	e8 fc d3 ff ff       	call   800791 <_panic>
  803395:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803398:	8b 50 04             	mov    0x4(%eax),%edx
  80339b:	8b 45 08             	mov    0x8(%ebp),%eax
  80339e:	89 50 04             	mov    %edx,0x4(%eax)
  8033a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033a7:	89 10                	mov    %edx,(%eax)
  8033a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ac:	8b 40 04             	mov    0x4(%eax),%eax
  8033af:	85 c0                	test   %eax,%eax
  8033b1:	74 0d                	je     8033c0 <insert_sorted_with_merge_freeList+0x393>
  8033b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b6:	8b 40 04             	mov    0x4(%eax),%eax
  8033b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8033bc:	89 10                	mov    %edx,(%eax)
  8033be:	eb 08                	jmp    8033c8 <insert_sorted_with_merge_freeList+0x39b>
  8033c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c3:	a3 38 51 80 00       	mov    %eax,0x805138
  8033c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8033ce:	89 50 04             	mov    %edx,0x4(%eax)
  8033d1:	a1 44 51 80 00       	mov    0x805144,%eax
  8033d6:	40                   	inc    %eax
  8033d7:	a3 44 51 80 00       	mov    %eax,0x805144
  8033dc:	e9 14 03 00 00       	jmp    8036f5 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  8033e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e4:	8b 40 08             	mov    0x8(%eax),%eax
  8033e7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8033ea:	0f 85 a0 01 00 00    	jne    803590 <insert_sorted_with_merge_freeList+0x563>
  8033f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f3:	8b 40 08             	mov    0x8(%eax),%eax
  8033f6:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8033f9:	0f 85 91 01 00 00    	jne    803590 <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  8033ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803402:	8b 50 0c             	mov    0xc(%eax),%edx
  803405:	8b 45 08             	mov    0x8(%ebp),%eax
  803408:	8b 48 0c             	mov    0xc(%eax),%ecx
  80340b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80340e:	8b 40 0c             	mov    0xc(%eax),%eax
  803411:	01 c8                	add    %ecx,%eax
  803413:	01 c2                	add    %eax,%edx
  803415:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803418:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  80341b:	8b 45 08             	mov    0x8(%ebp),%eax
  80341e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  803425:	8b 45 08             	mov    0x8(%ebp),%eax
  803428:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  80342f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803432:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  803439:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803443:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803447:	75 17                	jne    803460 <insert_sorted_with_merge_freeList+0x433>
  803449:	83 ec 04             	sub    $0x4,%esp
  80344c:	68 84 42 80 00       	push   $0x804284
  803451:	68 4d 01 00 00       	push   $0x14d
  803456:	68 a7 42 80 00       	push   $0x8042a7
  80345b:	e8 31 d3 ff ff       	call   800791 <_panic>
  803460:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803466:	8b 45 08             	mov    0x8(%ebp),%eax
  803469:	89 10                	mov    %edx,(%eax)
  80346b:	8b 45 08             	mov    0x8(%ebp),%eax
  80346e:	8b 00                	mov    (%eax),%eax
  803470:	85 c0                	test   %eax,%eax
  803472:	74 0d                	je     803481 <insert_sorted_with_merge_freeList+0x454>
  803474:	a1 48 51 80 00       	mov    0x805148,%eax
  803479:	8b 55 08             	mov    0x8(%ebp),%edx
  80347c:	89 50 04             	mov    %edx,0x4(%eax)
  80347f:	eb 08                	jmp    803489 <insert_sorted_with_merge_freeList+0x45c>
  803481:	8b 45 08             	mov    0x8(%ebp),%eax
  803484:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803489:	8b 45 08             	mov    0x8(%ebp),%eax
  80348c:	a3 48 51 80 00       	mov    %eax,0x805148
  803491:	8b 45 08             	mov    0x8(%ebp),%eax
  803494:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80349b:	a1 54 51 80 00       	mov    0x805154,%eax
  8034a0:	40                   	inc    %eax
  8034a1:	a3 54 51 80 00       	mov    %eax,0x805154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  8034a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034aa:	75 17                	jne    8034c3 <insert_sorted_with_merge_freeList+0x496>
  8034ac:	83 ec 04             	sub    $0x4,%esp
  8034af:	68 e3 42 80 00       	push   $0x8042e3
  8034b4:	68 4e 01 00 00       	push   $0x14e
  8034b9:	68 a7 42 80 00       	push   $0x8042a7
  8034be:	e8 ce d2 ff ff       	call   800791 <_panic>
  8034c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c6:	8b 00                	mov    (%eax),%eax
  8034c8:	85 c0                	test   %eax,%eax
  8034ca:	74 10                	je     8034dc <insert_sorted_with_merge_freeList+0x4af>
  8034cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034cf:	8b 00                	mov    (%eax),%eax
  8034d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034d4:	8b 52 04             	mov    0x4(%edx),%edx
  8034d7:	89 50 04             	mov    %edx,0x4(%eax)
  8034da:	eb 0b                	jmp    8034e7 <insert_sorted_with_merge_freeList+0x4ba>
  8034dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034df:	8b 40 04             	mov    0x4(%eax),%eax
  8034e2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ea:	8b 40 04             	mov    0x4(%eax),%eax
  8034ed:	85 c0                	test   %eax,%eax
  8034ef:	74 0f                	je     803500 <insert_sorted_with_merge_freeList+0x4d3>
  8034f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f4:	8b 40 04             	mov    0x4(%eax),%eax
  8034f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034fa:	8b 12                	mov    (%edx),%edx
  8034fc:	89 10                	mov    %edx,(%eax)
  8034fe:	eb 0a                	jmp    80350a <insert_sorted_with_merge_freeList+0x4dd>
  803500:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803503:	8b 00                	mov    (%eax),%eax
  803505:	a3 38 51 80 00       	mov    %eax,0x805138
  80350a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80350d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803513:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803516:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80351d:	a1 44 51 80 00       	mov    0x805144,%eax
  803522:	48                   	dec    %eax
  803523:	a3 44 51 80 00       	mov    %eax,0x805144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  803528:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80352c:	75 17                	jne    803545 <insert_sorted_with_merge_freeList+0x518>
  80352e:	83 ec 04             	sub    $0x4,%esp
  803531:	68 84 42 80 00       	push   $0x804284
  803536:	68 4f 01 00 00       	push   $0x14f
  80353b:	68 a7 42 80 00       	push   $0x8042a7
  803540:	e8 4c d2 ff ff       	call   800791 <_panic>
  803545:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80354b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80354e:	89 10                	mov    %edx,(%eax)
  803550:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803553:	8b 00                	mov    (%eax),%eax
  803555:	85 c0                	test   %eax,%eax
  803557:	74 0d                	je     803566 <insert_sorted_with_merge_freeList+0x539>
  803559:	a1 48 51 80 00       	mov    0x805148,%eax
  80355e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803561:	89 50 04             	mov    %edx,0x4(%eax)
  803564:	eb 08                	jmp    80356e <insert_sorted_with_merge_freeList+0x541>
  803566:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803569:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80356e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803571:	a3 48 51 80 00       	mov    %eax,0x805148
  803576:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803579:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803580:	a1 54 51 80 00       	mov    0x805154,%eax
  803585:	40                   	inc    %eax
  803586:	a3 54 51 80 00       	mov    %eax,0x805154
  80358b:	e9 65 01 00 00       	jmp    8036f5 <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  803590:	8b 45 08             	mov    0x8(%ebp),%eax
  803593:	8b 40 08             	mov    0x8(%eax),%eax
  803596:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803599:	0f 85 9f 00 00 00    	jne    80363e <insert_sorted_with_merge_freeList+0x611>
  80359f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a2:	8b 40 08             	mov    0x8(%eax),%eax
  8035a5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8035a8:	0f 84 90 00 00 00    	je     80363e <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  8035ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035b1:	8b 50 0c             	mov    0xc(%eax),%edx
  8035b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8035ba:	01 c2                	add    %eax,%edx
  8035bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035bf:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  8035c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  8035cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8035cf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8035d6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035da:	75 17                	jne    8035f3 <insert_sorted_with_merge_freeList+0x5c6>
  8035dc:	83 ec 04             	sub    $0x4,%esp
  8035df:	68 84 42 80 00       	push   $0x804284
  8035e4:	68 58 01 00 00       	push   $0x158
  8035e9:	68 a7 42 80 00       	push   $0x8042a7
  8035ee:	e8 9e d1 ff ff       	call   800791 <_panic>
  8035f3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fc:	89 10                	mov    %edx,(%eax)
  8035fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803601:	8b 00                	mov    (%eax),%eax
  803603:	85 c0                	test   %eax,%eax
  803605:	74 0d                	je     803614 <insert_sorted_with_merge_freeList+0x5e7>
  803607:	a1 48 51 80 00       	mov    0x805148,%eax
  80360c:	8b 55 08             	mov    0x8(%ebp),%edx
  80360f:	89 50 04             	mov    %edx,0x4(%eax)
  803612:	eb 08                	jmp    80361c <insert_sorted_with_merge_freeList+0x5ef>
  803614:	8b 45 08             	mov    0x8(%ebp),%eax
  803617:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80361c:	8b 45 08             	mov    0x8(%ebp),%eax
  80361f:	a3 48 51 80 00       	mov    %eax,0x805148
  803624:	8b 45 08             	mov    0x8(%ebp),%eax
  803627:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80362e:	a1 54 51 80 00       	mov    0x805154,%eax
  803633:	40                   	inc    %eax
  803634:	a3 54 51 80 00       	mov    %eax,0x805154
  803639:	e9 b7 00 00 00       	jmp    8036f5 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  80363e:	8b 45 08             	mov    0x8(%ebp),%eax
  803641:	8b 40 08             	mov    0x8(%eax),%eax
  803644:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803647:	0f 84 e2 00 00 00    	je     80372f <insert_sorted_with_merge_freeList+0x702>
  80364d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803650:	8b 40 08             	mov    0x8(%eax),%eax
  803653:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803656:	0f 85 d3 00 00 00    	jne    80372f <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  80365c:	8b 45 08             	mov    0x8(%ebp),%eax
  80365f:	8b 50 08             	mov    0x8(%eax),%edx
  803662:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803665:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  803668:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80366b:	8b 50 0c             	mov    0xc(%eax),%edx
  80366e:	8b 45 08             	mov    0x8(%ebp),%eax
  803671:	8b 40 0c             	mov    0xc(%eax),%eax
  803674:	01 c2                	add    %eax,%edx
  803676:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803679:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  80367c:	8b 45 08             	mov    0x8(%ebp),%eax
  80367f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  803686:	8b 45 08             	mov    0x8(%ebp),%eax
  803689:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803690:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803694:	75 17                	jne    8036ad <insert_sorted_with_merge_freeList+0x680>
  803696:	83 ec 04             	sub    $0x4,%esp
  803699:	68 84 42 80 00       	push   $0x804284
  80369e:	68 61 01 00 00       	push   $0x161
  8036a3:	68 a7 42 80 00       	push   $0x8042a7
  8036a8:	e8 e4 d0 ff ff       	call   800791 <_panic>
  8036ad:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8036b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b6:	89 10                	mov    %edx,(%eax)
  8036b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036bb:	8b 00                	mov    (%eax),%eax
  8036bd:	85 c0                	test   %eax,%eax
  8036bf:	74 0d                	je     8036ce <insert_sorted_with_merge_freeList+0x6a1>
  8036c1:	a1 48 51 80 00       	mov    0x805148,%eax
  8036c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8036c9:	89 50 04             	mov    %edx,0x4(%eax)
  8036cc:	eb 08                	jmp    8036d6 <insert_sorted_with_merge_freeList+0x6a9>
  8036ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d9:	a3 48 51 80 00       	mov    %eax,0x805148
  8036de:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036e8:	a1 54 51 80 00       	mov    0x805154,%eax
  8036ed:	40                   	inc    %eax
  8036ee:	a3 54 51 80 00       	mov    %eax,0x805154
								}
								break;
  8036f3:	eb 3a                	jmp    80372f <insert_sorted_with_merge_freeList+0x702>
  8036f5:	eb 38                	jmp    80372f <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  8036f7:	a1 40 51 80 00       	mov    0x805140,%eax
  8036fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803703:	74 07                	je     80370c <insert_sorted_with_merge_freeList+0x6df>
  803705:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803708:	8b 00                	mov    (%eax),%eax
  80370a:	eb 05                	jmp    803711 <insert_sorted_with_merge_freeList+0x6e4>
  80370c:	b8 00 00 00 00       	mov    $0x0,%eax
  803711:	a3 40 51 80 00       	mov    %eax,0x805140
  803716:	a1 40 51 80 00       	mov    0x805140,%eax
  80371b:	85 c0                	test   %eax,%eax
  80371d:	0f 85 fa fb ff ff    	jne    80331d <insert_sorted_with_merge_freeList+0x2f0>
  803723:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803727:	0f 85 f0 fb ff ff    	jne    80331d <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  80372d:	eb 01                	jmp    803730 <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  80372f:	90                   	nop
							}

						}
		          }
		}
}
  803730:	90                   	nop
  803731:	c9                   	leave  
  803732:	c3                   	ret    
  803733:	90                   	nop

00803734 <__udivdi3>:
  803734:	55                   	push   %ebp
  803735:	57                   	push   %edi
  803736:	56                   	push   %esi
  803737:	53                   	push   %ebx
  803738:	83 ec 1c             	sub    $0x1c,%esp
  80373b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80373f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803743:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803747:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80374b:	89 ca                	mov    %ecx,%edx
  80374d:	89 f8                	mov    %edi,%eax
  80374f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803753:	85 f6                	test   %esi,%esi
  803755:	75 2d                	jne    803784 <__udivdi3+0x50>
  803757:	39 cf                	cmp    %ecx,%edi
  803759:	77 65                	ja     8037c0 <__udivdi3+0x8c>
  80375b:	89 fd                	mov    %edi,%ebp
  80375d:	85 ff                	test   %edi,%edi
  80375f:	75 0b                	jne    80376c <__udivdi3+0x38>
  803761:	b8 01 00 00 00       	mov    $0x1,%eax
  803766:	31 d2                	xor    %edx,%edx
  803768:	f7 f7                	div    %edi
  80376a:	89 c5                	mov    %eax,%ebp
  80376c:	31 d2                	xor    %edx,%edx
  80376e:	89 c8                	mov    %ecx,%eax
  803770:	f7 f5                	div    %ebp
  803772:	89 c1                	mov    %eax,%ecx
  803774:	89 d8                	mov    %ebx,%eax
  803776:	f7 f5                	div    %ebp
  803778:	89 cf                	mov    %ecx,%edi
  80377a:	89 fa                	mov    %edi,%edx
  80377c:	83 c4 1c             	add    $0x1c,%esp
  80377f:	5b                   	pop    %ebx
  803780:	5e                   	pop    %esi
  803781:	5f                   	pop    %edi
  803782:	5d                   	pop    %ebp
  803783:	c3                   	ret    
  803784:	39 ce                	cmp    %ecx,%esi
  803786:	77 28                	ja     8037b0 <__udivdi3+0x7c>
  803788:	0f bd fe             	bsr    %esi,%edi
  80378b:	83 f7 1f             	xor    $0x1f,%edi
  80378e:	75 40                	jne    8037d0 <__udivdi3+0x9c>
  803790:	39 ce                	cmp    %ecx,%esi
  803792:	72 0a                	jb     80379e <__udivdi3+0x6a>
  803794:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803798:	0f 87 9e 00 00 00    	ja     80383c <__udivdi3+0x108>
  80379e:	b8 01 00 00 00       	mov    $0x1,%eax
  8037a3:	89 fa                	mov    %edi,%edx
  8037a5:	83 c4 1c             	add    $0x1c,%esp
  8037a8:	5b                   	pop    %ebx
  8037a9:	5e                   	pop    %esi
  8037aa:	5f                   	pop    %edi
  8037ab:	5d                   	pop    %ebp
  8037ac:	c3                   	ret    
  8037ad:	8d 76 00             	lea    0x0(%esi),%esi
  8037b0:	31 ff                	xor    %edi,%edi
  8037b2:	31 c0                	xor    %eax,%eax
  8037b4:	89 fa                	mov    %edi,%edx
  8037b6:	83 c4 1c             	add    $0x1c,%esp
  8037b9:	5b                   	pop    %ebx
  8037ba:	5e                   	pop    %esi
  8037bb:	5f                   	pop    %edi
  8037bc:	5d                   	pop    %ebp
  8037bd:	c3                   	ret    
  8037be:	66 90                	xchg   %ax,%ax
  8037c0:	89 d8                	mov    %ebx,%eax
  8037c2:	f7 f7                	div    %edi
  8037c4:	31 ff                	xor    %edi,%edi
  8037c6:	89 fa                	mov    %edi,%edx
  8037c8:	83 c4 1c             	add    $0x1c,%esp
  8037cb:	5b                   	pop    %ebx
  8037cc:	5e                   	pop    %esi
  8037cd:	5f                   	pop    %edi
  8037ce:	5d                   	pop    %ebp
  8037cf:	c3                   	ret    
  8037d0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8037d5:	89 eb                	mov    %ebp,%ebx
  8037d7:	29 fb                	sub    %edi,%ebx
  8037d9:	89 f9                	mov    %edi,%ecx
  8037db:	d3 e6                	shl    %cl,%esi
  8037dd:	89 c5                	mov    %eax,%ebp
  8037df:	88 d9                	mov    %bl,%cl
  8037e1:	d3 ed                	shr    %cl,%ebp
  8037e3:	89 e9                	mov    %ebp,%ecx
  8037e5:	09 f1                	or     %esi,%ecx
  8037e7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8037eb:	89 f9                	mov    %edi,%ecx
  8037ed:	d3 e0                	shl    %cl,%eax
  8037ef:	89 c5                	mov    %eax,%ebp
  8037f1:	89 d6                	mov    %edx,%esi
  8037f3:	88 d9                	mov    %bl,%cl
  8037f5:	d3 ee                	shr    %cl,%esi
  8037f7:	89 f9                	mov    %edi,%ecx
  8037f9:	d3 e2                	shl    %cl,%edx
  8037fb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037ff:	88 d9                	mov    %bl,%cl
  803801:	d3 e8                	shr    %cl,%eax
  803803:	09 c2                	or     %eax,%edx
  803805:	89 d0                	mov    %edx,%eax
  803807:	89 f2                	mov    %esi,%edx
  803809:	f7 74 24 0c          	divl   0xc(%esp)
  80380d:	89 d6                	mov    %edx,%esi
  80380f:	89 c3                	mov    %eax,%ebx
  803811:	f7 e5                	mul    %ebp
  803813:	39 d6                	cmp    %edx,%esi
  803815:	72 19                	jb     803830 <__udivdi3+0xfc>
  803817:	74 0b                	je     803824 <__udivdi3+0xf0>
  803819:	89 d8                	mov    %ebx,%eax
  80381b:	31 ff                	xor    %edi,%edi
  80381d:	e9 58 ff ff ff       	jmp    80377a <__udivdi3+0x46>
  803822:	66 90                	xchg   %ax,%ax
  803824:	8b 54 24 08          	mov    0x8(%esp),%edx
  803828:	89 f9                	mov    %edi,%ecx
  80382a:	d3 e2                	shl    %cl,%edx
  80382c:	39 c2                	cmp    %eax,%edx
  80382e:	73 e9                	jae    803819 <__udivdi3+0xe5>
  803830:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803833:	31 ff                	xor    %edi,%edi
  803835:	e9 40 ff ff ff       	jmp    80377a <__udivdi3+0x46>
  80383a:	66 90                	xchg   %ax,%ax
  80383c:	31 c0                	xor    %eax,%eax
  80383e:	e9 37 ff ff ff       	jmp    80377a <__udivdi3+0x46>
  803843:	90                   	nop

00803844 <__umoddi3>:
  803844:	55                   	push   %ebp
  803845:	57                   	push   %edi
  803846:	56                   	push   %esi
  803847:	53                   	push   %ebx
  803848:	83 ec 1c             	sub    $0x1c,%esp
  80384b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80384f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803853:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803857:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80385b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80385f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803863:	89 f3                	mov    %esi,%ebx
  803865:	89 fa                	mov    %edi,%edx
  803867:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80386b:	89 34 24             	mov    %esi,(%esp)
  80386e:	85 c0                	test   %eax,%eax
  803870:	75 1a                	jne    80388c <__umoddi3+0x48>
  803872:	39 f7                	cmp    %esi,%edi
  803874:	0f 86 a2 00 00 00    	jbe    80391c <__umoddi3+0xd8>
  80387a:	89 c8                	mov    %ecx,%eax
  80387c:	89 f2                	mov    %esi,%edx
  80387e:	f7 f7                	div    %edi
  803880:	89 d0                	mov    %edx,%eax
  803882:	31 d2                	xor    %edx,%edx
  803884:	83 c4 1c             	add    $0x1c,%esp
  803887:	5b                   	pop    %ebx
  803888:	5e                   	pop    %esi
  803889:	5f                   	pop    %edi
  80388a:	5d                   	pop    %ebp
  80388b:	c3                   	ret    
  80388c:	39 f0                	cmp    %esi,%eax
  80388e:	0f 87 ac 00 00 00    	ja     803940 <__umoddi3+0xfc>
  803894:	0f bd e8             	bsr    %eax,%ebp
  803897:	83 f5 1f             	xor    $0x1f,%ebp
  80389a:	0f 84 ac 00 00 00    	je     80394c <__umoddi3+0x108>
  8038a0:	bf 20 00 00 00       	mov    $0x20,%edi
  8038a5:	29 ef                	sub    %ebp,%edi
  8038a7:	89 fe                	mov    %edi,%esi
  8038a9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8038ad:	89 e9                	mov    %ebp,%ecx
  8038af:	d3 e0                	shl    %cl,%eax
  8038b1:	89 d7                	mov    %edx,%edi
  8038b3:	89 f1                	mov    %esi,%ecx
  8038b5:	d3 ef                	shr    %cl,%edi
  8038b7:	09 c7                	or     %eax,%edi
  8038b9:	89 e9                	mov    %ebp,%ecx
  8038bb:	d3 e2                	shl    %cl,%edx
  8038bd:	89 14 24             	mov    %edx,(%esp)
  8038c0:	89 d8                	mov    %ebx,%eax
  8038c2:	d3 e0                	shl    %cl,%eax
  8038c4:	89 c2                	mov    %eax,%edx
  8038c6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038ca:	d3 e0                	shl    %cl,%eax
  8038cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8038d0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038d4:	89 f1                	mov    %esi,%ecx
  8038d6:	d3 e8                	shr    %cl,%eax
  8038d8:	09 d0                	or     %edx,%eax
  8038da:	d3 eb                	shr    %cl,%ebx
  8038dc:	89 da                	mov    %ebx,%edx
  8038de:	f7 f7                	div    %edi
  8038e0:	89 d3                	mov    %edx,%ebx
  8038e2:	f7 24 24             	mull   (%esp)
  8038e5:	89 c6                	mov    %eax,%esi
  8038e7:	89 d1                	mov    %edx,%ecx
  8038e9:	39 d3                	cmp    %edx,%ebx
  8038eb:	0f 82 87 00 00 00    	jb     803978 <__umoddi3+0x134>
  8038f1:	0f 84 91 00 00 00    	je     803988 <__umoddi3+0x144>
  8038f7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8038fb:	29 f2                	sub    %esi,%edx
  8038fd:	19 cb                	sbb    %ecx,%ebx
  8038ff:	89 d8                	mov    %ebx,%eax
  803901:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803905:	d3 e0                	shl    %cl,%eax
  803907:	89 e9                	mov    %ebp,%ecx
  803909:	d3 ea                	shr    %cl,%edx
  80390b:	09 d0                	or     %edx,%eax
  80390d:	89 e9                	mov    %ebp,%ecx
  80390f:	d3 eb                	shr    %cl,%ebx
  803911:	89 da                	mov    %ebx,%edx
  803913:	83 c4 1c             	add    $0x1c,%esp
  803916:	5b                   	pop    %ebx
  803917:	5e                   	pop    %esi
  803918:	5f                   	pop    %edi
  803919:	5d                   	pop    %ebp
  80391a:	c3                   	ret    
  80391b:	90                   	nop
  80391c:	89 fd                	mov    %edi,%ebp
  80391e:	85 ff                	test   %edi,%edi
  803920:	75 0b                	jne    80392d <__umoddi3+0xe9>
  803922:	b8 01 00 00 00       	mov    $0x1,%eax
  803927:	31 d2                	xor    %edx,%edx
  803929:	f7 f7                	div    %edi
  80392b:	89 c5                	mov    %eax,%ebp
  80392d:	89 f0                	mov    %esi,%eax
  80392f:	31 d2                	xor    %edx,%edx
  803931:	f7 f5                	div    %ebp
  803933:	89 c8                	mov    %ecx,%eax
  803935:	f7 f5                	div    %ebp
  803937:	89 d0                	mov    %edx,%eax
  803939:	e9 44 ff ff ff       	jmp    803882 <__umoddi3+0x3e>
  80393e:	66 90                	xchg   %ax,%ax
  803940:	89 c8                	mov    %ecx,%eax
  803942:	89 f2                	mov    %esi,%edx
  803944:	83 c4 1c             	add    $0x1c,%esp
  803947:	5b                   	pop    %ebx
  803948:	5e                   	pop    %esi
  803949:	5f                   	pop    %edi
  80394a:	5d                   	pop    %ebp
  80394b:	c3                   	ret    
  80394c:	3b 04 24             	cmp    (%esp),%eax
  80394f:	72 06                	jb     803957 <__umoddi3+0x113>
  803951:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803955:	77 0f                	ja     803966 <__umoddi3+0x122>
  803957:	89 f2                	mov    %esi,%edx
  803959:	29 f9                	sub    %edi,%ecx
  80395b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80395f:	89 14 24             	mov    %edx,(%esp)
  803962:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803966:	8b 44 24 04          	mov    0x4(%esp),%eax
  80396a:	8b 14 24             	mov    (%esp),%edx
  80396d:	83 c4 1c             	add    $0x1c,%esp
  803970:	5b                   	pop    %ebx
  803971:	5e                   	pop    %esi
  803972:	5f                   	pop    %edi
  803973:	5d                   	pop    %ebp
  803974:	c3                   	ret    
  803975:	8d 76 00             	lea    0x0(%esi),%esi
  803978:	2b 04 24             	sub    (%esp),%eax
  80397b:	19 fa                	sbb    %edi,%edx
  80397d:	89 d1                	mov    %edx,%ecx
  80397f:	89 c6                	mov    %eax,%esi
  803981:	e9 71 ff ff ff       	jmp    8038f7 <__umoddi3+0xb3>
  803986:	66 90                	xchg   %ax,%ax
  803988:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80398c:	72 ea                	jb     803978 <__umoddi3+0x134>
  80398e:	89 d9                	mov    %ebx,%ecx
  803990:	e9 62 ff ff ff       	jmp    8038f7 <__umoddi3+0xb3>


obj/user/quicksort_freeheap:     file format elf32-i386


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
  800031:	e8 b4 05 00 00       	call   8005ea <libmain>
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
  80003b:	53                   	push   %ebx
  80003c:	81 ec 24 01 00 00    	sub    $0x124,%esp
	char Chose ;
	char Line[255] ;
	int Iteration = 0 ;
  800042:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	do
	{
		int InitFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames();
  800049:	e8 2e 1f 00 00       	call   801f7c <sys_calculate_free_frames>
  80004e:	89 c3                	mov    %eax,%ebx
  800050:	e8 40 1f 00 00       	call   801f95 <sys_calculate_modified_frames>
  800055:	01 d8                	add    %ebx,%eax
  800057:	89 45 f0             	mov    %eax,-0x10(%ebp)

		Iteration++ ;
  80005a:	ff 45 f4             	incl   -0xc(%ebp)
		//		cprintf("Free Frames Before Allocation = %d\n", sys_calculate_free_frames()) ;

		//	sys_disable_interrupt();

		readline("Enter the number of elements: ", Line);
  80005d:	83 ec 08             	sub    $0x8,%esp
  800060:	8d 85 e1 fe ff ff    	lea    -0x11f(%ebp),%eax
  800066:	50                   	push   %eax
  800067:	68 40 39 80 00       	push   $0x803940
  80006c:	e8 eb 0f 00 00       	call   80105c <readline>
  800071:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  800074:	83 ec 04             	sub    $0x4,%esp
  800077:	6a 0a                	push   $0xa
  800079:	6a 00                	push   $0x0
  80007b:	8d 85 e1 fe ff ff    	lea    -0x11f(%ebp),%eax
  800081:	50                   	push   %eax
  800082:	e8 3b 15 00 00       	call   8015c2 <strtol>
  800087:	83 c4 10             	add    $0x10,%esp
  80008a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  80008d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800090:	c1 e0 02             	shl    $0x2,%eax
  800093:	83 ec 0c             	sub    $0xc,%esp
  800096:	50                   	push   %eax
  800097:	e8 73 1a 00 00       	call   801b0f <malloc>
  80009c:	83 c4 10             	add    $0x10,%esp
  80009f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		cprintf("Choose the initialization method:\n") ;
  8000a2:	83 ec 0c             	sub    $0xc,%esp
  8000a5:	68 60 39 80 00       	push   $0x803960
  8000aa:	e8 2b 09 00 00       	call   8009da <cprintf>
  8000af:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000b2:	83 ec 0c             	sub    $0xc,%esp
  8000b5:	68 83 39 80 00       	push   $0x803983
  8000ba:	e8 1b 09 00 00       	call   8009da <cprintf>
  8000bf:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000c2:	83 ec 0c             	sub    $0xc,%esp
  8000c5:	68 91 39 80 00       	push   $0x803991
  8000ca:	e8 0b 09 00 00       	call   8009da <cprintf>
  8000cf:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  8000d2:	83 ec 0c             	sub    $0xc,%esp
  8000d5:	68 a0 39 80 00       	push   $0x8039a0
  8000da:	e8 fb 08 00 00       	call   8009da <cprintf>
  8000df:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	68 b0 39 80 00       	push   $0x8039b0
  8000ea:	e8 eb 08 00 00       	call   8009da <cprintf>
  8000ef:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  8000f2:	e8 9b 04 00 00       	call   800592 <getchar>
  8000f7:	88 45 e7             	mov    %al,-0x19(%ebp)
			cputchar(Chose);
  8000fa:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  8000fe:	83 ec 0c             	sub    $0xc,%esp
  800101:	50                   	push   %eax
  800102:	e8 43 04 00 00       	call   80054a <cputchar>
  800107:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80010a:	83 ec 0c             	sub    $0xc,%esp
  80010d:	6a 0a                	push   $0xa
  80010f:	e8 36 04 00 00       	call   80054a <cputchar>
  800114:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800117:	80 7d e7 61          	cmpb   $0x61,-0x19(%ebp)
  80011b:	74 0c                	je     800129 <_main+0xf1>
  80011d:	80 7d e7 62          	cmpb   $0x62,-0x19(%ebp)
  800121:	74 06                	je     800129 <_main+0xf1>
  800123:	80 7d e7 63          	cmpb   $0x63,-0x19(%ebp)
  800127:	75 b9                	jne    8000e2 <_main+0xaa>
		//sys_enable_interrupt();
		int  i ;
		switch (Chose)
  800129:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  80012d:	83 f8 62             	cmp    $0x62,%eax
  800130:	74 1d                	je     80014f <_main+0x117>
  800132:	83 f8 63             	cmp    $0x63,%eax
  800135:	74 2b                	je     800162 <_main+0x12a>
  800137:	83 f8 61             	cmp    $0x61,%eax
  80013a:	75 39                	jne    800175 <_main+0x13d>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80013c:	83 ec 08             	sub    $0x8,%esp
  80013f:	ff 75 ec             	pushl  -0x14(%ebp)
  800142:	ff 75 e8             	pushl  -0x18(%ebp)
  800145:	e8 c8 02 00 00       	call   800412 <InitializeAscending>
  80014a:	83 c4 10             	add    $0x10,%esp
			break ;
  80014d:	eb 37                	jmp    800186 <_main+0x14e>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80014f:	83 ec 08             	sub    $0x8,%esp
  800152:	ff 75 ec             	pushl  -0x14(%ebp)
  800155:	ff 75 e8             	pushl  -0x18(%ebp)
  800158:	e8 e6 02 00 00       	call   800443 <InitializeDescending>
  80015d:	83 c4 10             	add    $0x10,%esp
			break ;
  800160:	eb 24                	jmp    800186 <_main+0x14e>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  800162:	83 ec 08             	sub    $0x8,%esp
  800165:	ff 75 ec             	pushl  -0x14(%ebp)
  800168:	ff 75 e8             	pushl  -0x18(%ebp)
  80016b:	e8 08 03 00 00       	call   800478 <InitializeSemiRandom>
  800170:	83 c4 10             	add    $0x10,%esp
			break ;
  800173:	eb 11                	jmp    800186 <_main+0x14e>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  800175:	83 ec 08             	sub    $0x8,%esp
  800178:	ff 75 ec             	pushl  -0x14(%ebp)
  80017b:	ff 75 e8             	pushl  -0x18(%ebp)
  80017e:	e8 f5 02 00 00       	call   800478 <InitializeSemiRandom>
  800183:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  800186:	83 ec 08             	sub    $0x8,%esp
  800189:	ff 75 ec             	pushl  -0x14(%ebp)
  80018c:	ff 75 e8             	pushl  -0x18(%ebp)
  80018f:	e8 c3 00 00 00       	call   800257 <QuickSort>
  800194:	83 c4 10             	add    $0x10,%esp

		//		PrintElements(Elements, NumOfElements);

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  800197:	83 ec 08             	sub    $0x8,%esp
  80019a:	ff 75 ec             	pushl  -0x14(%ebp)
  80019d:	ff 75 e8             	pushl  -0x18(%ebp)
  8001a0:	e8 c3 01 00 00       	call   800368 <CheckSorted>
  8001a5:	83 c4 10             	add    $0x10,%esp
  8001a8:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001ab:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8001af:	75 14                	jne    8001c5 <_main+0x18d>
  8001b1:	83 ec 04             	sub    $0x4,%esp
  8001b4:	68 bc 39 80 00       	push   $0x8039bc
  8001b9:	6a 45                	push   $0x45
  8001bb:	68 de 39 80 00       	push   $0x8039de
  8001c0:	e8 61 05 00 00       	call   800726 <_panic>
		else
		{ 
			cprintf("===============================================\n") ;
  8001c5:	83 ec 0c             	sub    $0xc,%esp
  8001c8:	68 f8 39 80 00       	push   $0x8039f8
  8001cd:	e8 08 08 00 00       	call   8009da <cprintf>
  8001d2:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	68 2c 3a 80 00       	push   $0x803a2c
  8001dd:	e8 f8 07 00 00       	call   8009da <cprintf>
  8001e2:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  8001e5:	83 ec 0c             	sub    $0xc,%esp
  8001e8:	68 60 3a 80 00       	push   $0x803a60
  8001ed:	e8 e8 07 00 00       	call   8009da <cprintf>
  8001f2:	83 c4 10             	add    $0x10,%esp
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		cprintf("Freeing the Heap...\n\n") ;
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	68 92 3a 80 00       	push   $0x803a92
  8001fd:	e8 d8 07 00 00       	call   8009da <cprintf>
  800202:	83 c4 10             	add    $0x10,%esp

		//freeHeap() ;

		///========================================================================
		//sys_disable_interrupt();
		cprintf("Do you want to repeat (y/n): ") ;
  800205:	83 ec 0c             	sub    $0xc,%esp
  800208:	68 a8 3a 80 00       	push   $0x803aa8
  80020d:	e8 c8 07 00 00       	call   8009da <cprintf>
  800212:	83 c4 10             	add    $0x10,%esp
		Chose = getchar() ;
  800215:	e8 78 03 00 00       	call   800592 <getchar>
  80021a:	88 45 e7             	mov    %al,-0x19(%ebp)
		cputchar(Chose);
  80021d:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  800221:	83 ec 0c             	sub    $0xc,%esp
  800224:	50                   	push   %eax
  800225:	e8 20 03 00 00       	call   80054a <cputchar>
  80022a:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  80022d:	83 ec 0c             	sub    $0xc,%esp
  800230:	6a 0a                	push   $0xa
  800232:	e8 13 03 00 00       	call   80054a <cputchar>
  800237:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  80023a:	83 ec 0c             	sub    $0xc,%esp
  80023d:	6a 0a                	push   $0xa
  80023f:	e8 06 03 00 00       	call   80054a <cputchar>
  800244:	83 c4 10             	add    $0x10,%esp
		//sys_enable_interrupt();

	} while (Chose == 'y');
  800247:	80 7d e7 79          	cmpb   $0x79,-0x19(%ebp)
  80024b:	0f 84 f8 fd ff ff    	je     800049 <_main+0x11>

}
  800251:	90                   	nop
  800252:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800255:	c9                   	leave  
  800256:	c3                   	ret    

00800257 <QuickSort>:

///Quick sort 
void QuickSort(int *Elements, int NumOfElements)
{
  800257:	55                   	push   %ebp
  800258:	89 e5                	mov    %esp,%ebp
  80025a:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  80025d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800260:	48                   	dec    %eax
  800261:	50                   	push   %eax
  800262:	6a 00                	push   $0x0
  800264:	ff 75 0c             	pushl  0xc(%ebp)
  800267:	ff 75 08             	pushl  0x8(%ebp)
  80026a:	e8 06 00 00 00       	call   800275 <QSort>
  80026f:	83 c4 10             	add    $0x10,%esp
}
  800272:	90                   	nop
  800273:	c9                   	leave  
  800274:	c3                   	ret    

00800275 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  800275:	55                   	push   %ebp
  800276:	89 e5                	mov    %esp,%ebp
  800278:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  80027b:	8b 45 10             	mov    0x10(%ebp),%eax
  80027e:	3b 45 14             	cmp    0x14(%ebp),%eax
  800281:	0f 8d de 00 00 00    	jge    800365 <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  800287:	8b 45 10             	mov    0x10(%ebp),%eax
  80028a:	40                   	inc    %eax
  80028b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80028e:	8b 45 14             	mov    0x14(%ebp),%eax
  800291:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  800294:	e9 80 00 00 00       	jmp    800319 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800299:	ff 45 f4             	incl   -0xc(%ebp)
  80029c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80029f:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002a2:	7f 2b                	jg     8002cf <QSort+0x5a>
  8002a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8002a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b1:	01 d0                	add    %edx,%eax
  8002b3:	8b 10                	mov    (%eax),%edx
  8002b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002b8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c2:	01 c8                	add    %ecx,%eax
  8002c4:	8b 00                	mov    (%eax),%eax
  8002c6:	39 c2                	cmp    %eax,%edx
  8002c8:	7d cf                	jge    800299 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  8002ca:	eb 03                	jmp    8002cf <QSort+0x5a>
  8002cc:	ff 4d f0             	decl   -0x10(%ebp)
  8002cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002d2:	3b 45 10             	cmp    0x10(%ebp),%eax
  8002d5:	7e 26                	jle    8002fd <QSort+0x88>
  8002d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8002da:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e4:	01 d0                	add    %edx,%eax
  8002e6:	8b 10                	mov    (%eax),%edx
  8002e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002eb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f5:	01 c8                	add    %ecx,%eax
  8002f7:	8b 00                	mov    (%eax),%eax
  8002f9:	39 c2                	cmp    %eax,%edx
  8002fb:	7e cf                	jle    8002cc <QSort+0x57>

		if (i <= j)
  8002fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800300:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800303:	7f 14                	jg     800319 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  800305:	83 ec 04             	sub    $0x4,%esp
  800308:	ff 75 f0             	pushl  -0x10(%ebp)
  80030b:	ff 75 f4             	pushl  -0xc(%ebp)
  80030e:	ff 75 08             	pushl  0x8(%ebp)
  800311:	e8 a9 00 00 00       	call   8003bf <Swap>
  800316:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800319:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80031c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80031f:	0f 8e 77 ff ff ff    	jle    80029c <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  800325:	83 ec 04             	sub    $0x4,%esp
  800328:	ff 75 f0             	pushl  -0x10(%ebp)
  80032b:	ff 75 10             	pushl  0x10(%ebp)
  80032e:	ff 75 08             	pushl  0x8(%ebp)
  800331:	e8 89 00 00 00       	call   8003bf <Swap>
  800336:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  800339:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80033c:	48                   	dec    %eax
  80033d:	50                   	push   %eax
  80033e:	ff 75 10             	pushl  0x10(%ebp)
  800341:	ff 75 0c             	pushl  0xc(%ebp)
  800344:	ff 75 08             	pushl  0x8(%ebp)
  800347:	e8 29 ff ff ff       	call   800275 <QSort>
  80034c:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  80034f:	ff 75 14             	pushl  0x14(%ebp)
  800352:	ff 75 f4             	pushl  -0xc(%ebp)
  800355:	ff 75 0c             	pushl  0xc(%ebp)
  800358:	ff 75 08             	pushl  0x8(%ebp)
  80035b:	e8 15 ff ff ff       	call   800275 <QSort>
  800360:	83 c4 10             	add    $0x10,%esp
  800363:	eb 01                	jmp    800366 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  800365:	90                   	nop

	Swap( Elements, startIndex, j);

	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);
}
  800366:	c9                   	leave  
  800367:	c3                   	ret    

00800368 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  800368:	55                   	push   %ebp
  800369:	89 e5                	mov    %esp,%ebp
  80036b:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  80036e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800375:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80037c:	eb 33                	jmp    8003b1 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  80037e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800381:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800388:	8b 45 08             	mov    0x8(%ebp),%eax
  80038b:	01 d0                	add    %edx,%eax
  80038d:	8b 10                	mov    (%eax),%edx
  80038f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800392:	40                   	inc    %eax
  800393:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80039a:	8b 45 08             	mov    0x8(%ebp),%eax
  80039d:	01 c8                	add    %ecx,%eax
  80039f:	8b 00                	mov    (%eax),%eax
  8003a1:	39 c2                	cmp    %eax,%edx
  8003a3:	7e 09                	jle    8003ae <CheckSorted+0x46>
		{
			Sorted = 0 ;
  8003a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  8003ac:	eb 0c                	jmp    8003ba <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003ae:	ff 45 f8             	incl   -0x8(%ebp)
  8003b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b4:	48                   	dec    %eax
  8003b5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8003b8:	7f c4                	jg     80037e <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  8003ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8003bd:	c9                   	leave  
  8003be:	c3                   	ret    

008003bf <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  8003bf:	55                   	push   %ebp
  8003c0:	89 e5                	mov    %esp,%ebp
  8003c2:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  8003c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d2:	01 d0                	add    %edx,%eax
  8003d4:	8b 00                	mov    (%eax),%eax
  8003d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  8003d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e6:	01 c2                	add    %eax,%edx
  8003e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8003eb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f5:	01 c8                	add    %ecx,%eax
  8003f7:	8b 00                	mov    (%eax),%eax
  8003f9:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  8003fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8003fe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800405:	8b 45 08             	mov    0x8(%ebp),%eax
  800408:	01 c2                	add    %eax,%edx
  80040a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80040d:	89 02                	mov    %eax,(%edx)
}
  80040f:	90                   	nop
  800410:	c9                   	leave  
  800411:	c3                   	ret    

00800412 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  800412:	55                   	push   %ebp
  800413:	89 e5                	mov    %esp,%ebp
  800415:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800418:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80041f:	eb 17                	jmp    800438 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  800421:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800424:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80042b:	8b 45 08             	mov    0x8(%ebp),%eax
  80042e:	01 c2                	add    %eax,%edx
  800430:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800433:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800435:	ff 45 fc             	incl   -0x4(%ebp)
  800438:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80043b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80043e:	7c e1                	jl     800421 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  800440:	90                   	nop
  800441:	c9                   	leave  
  800442:	c3                   	ret    

00800443 <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  800443:	55                   	push   %ebp
  800444:	89 e5                	mov    %esp,%ebp
  800446:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800449:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800450:	eb 1b                	jmp    80046d <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  800452:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800455:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045c:	8b 45 08             	mov    0x8(%ebp),%eax
  80045f:	01 c2                	add    %eax,%edx
  800461:	8b 45 0c             	mov    0xc(%ebp),%eax
  800464:	2b 45 fc             	sub    -0x4(%ebp),%eax
  800467:	48                   	dec    %eax
  800468:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80046a:	ff 45 fc             	incl   -0x4(%ebp)
  80046d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800470:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800473:	7c dd                	jl     800452 <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  800475:	90                   	nop
  800476:	c9                   	leave  
  800477:	c3                   	ret    

00800478 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  800478:	55                   	push   %ebp
  800479:	89 e5                	mov    %esp,%ebp
  80047b:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  80047e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800481:	b8 56 55 55 55       	mov    $0x55555556,%eax
  800486:	f7 e9                	imul   %ecx
  800488:	c1 f9 1f             	sar    $0x1f,%ecx
  80048b:	89 d0                	mov    %edx,%eax
  80048d:	29 c8                	sub    %ecx,%eax
  80048f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  800492:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800499:	eb 1e                	jmp    8004b9 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  80049b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80049e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a8:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8004ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004ae:	99                   	cltd   
  8004af:	f7 7d f8             	idivl  -0x8(%ebp)
  8004b2:	89 d0                	mov    %edx,%eax
  8004b4:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004b6:	ff 45 fc             	incl   -0x4(%ebp)
  8004b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004bc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004bf:	7c da                	jl     80049b <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
	}

}
  8004c1:	90                   	nop
  8004c2:	c9                   	leave  
  8004c3:	c3                   	ret    

008004c4 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  8004c4:	55                   	push   %ebp
  8004c5:	89 e5                	mov    %esp,%ebp
  8004c7:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  8004ca:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8004d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8004d8:	eb 42                	jmp    80051c <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  8004da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004dd:	99                   	cltd   
  8004de:	f7 7d f0             	idivl  -0x10(%ebp)
  8004e1:	89 d0                	mov    %edx,%eax
  8004e3:	85 c0                	test   %eax,%eax
  8004e5:	75 10                	jne    8004f7 <PrintElements+0x33>
			cprintf("\n");
  8004e7:	83 ec 0c             	sub    $0xc,%esp
  8004ea:	68 c6 3a 80 00       	push   $0x803ac6
  8004ef:	e8 e6 04 00 00       	call   8009da <cprintf>
  8004f4:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  8004f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800501:	8b 45 08             	mov    0x8(%ebp),%eax
  800504:	01 d0                	add    %edx,%eax
  800506:	8b 00                	mov    (%eax),%eax
  800508:	83 ec 08             	sub    $0x8,%esp
  80050b:	50                   	push   %eax
  80050c:	68 c8 3a 80 00       	push   $0x803ac8
  800511:	e8 c4 04 00 00       	call   8009da <cprintf>
  800516:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800519:	ff 45 f4             	incl   -0xc(%ebp)
  80051c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051f:	48                   	dec    %eax
  800520:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800523:	7f b5                	jg     8004da <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800525:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800528:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80052f:	8b 45 08             	mov    0x8(%ebp),%eax
  800532:	01 d0                	add    %edx,%eax
  800534:	8b 00                	mov    (%eax),%eax
  800536:	83 ec 08             	sub    $0x8,%esp
  800539:	50                   	push   %eax
  80053a:	68 cd 3a 80 00       	push   $0x803acd
  80053f:	e8 96 04 00 00       	call   8009da <cprintf>
  800544:	83 c4 10             	add    $0x10,%esp
}
  800547:	90                   	nop
  800548:	c9                   	leave  
  800549:	c3                   	ret    

0080054a <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  80054a:	55                   	push   %ebp
  80054b:	89 e5                	mov    %esp,%ebp
  80054d:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800550:	8b 45 08             	mov    0x8(%ebp),%eax
  800553:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800556:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80055a:	83 ec 0c             	sub    $0xc,%esp
  80055d:	50                   	push   %eax
  80055e:	e8 3a 1b 00 00       	call   80209d <sys_cputc>
  800563:	83 c4 10             	add    $0x10,%esp
}
  800566:	90                   	nop
  800567:	c9                   	leave  
  800568:	c3                   	ret    

00800569 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  800569:	55                   	push   %ebp
  80056a:	89 e5                	mov    %esp,%ebp
  80056c:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80056f:	e8 f5 1a 00 00       	call   802069 <sys_disable_interrupt>
	char c = ch;
  800574:	8b 45 08             	mov    0x8(%ebp),%eax
  800577:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  80057a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80057e:	83 ec 0c             	sub    $0xc,%esp
  800581:	50                   	push   %eax
  800582:	e8 16 1b 00 00       	call   80209d <sys_cputc>
  800587:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80058a:	e8 f4 1a 00 00       	call   802083 <sys_enable_interrupt>
}
  80058f:	90                   	nop
  800590:	c9                   	leave  
  800591:	c3                   	ret    

00800592 <getchar>:

int
getchar(void)
{
  800592:	55                   	push   %ebp
  800593:	89 e5                	mov    %esp,%ebp
  800595:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800598:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80059f:	eb 08                	jmp    8005a9 <getchar+0x17>
	{
		c = sys_cgetc();
  8005a1:	e8 3e 19 00 00       	call   801ee4 <sys_cgetc>
  8005a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  8005a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8005ad:	74 f2                	je     8005a1 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  8005af:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8005b2:	c9                   	leave  
  8005b3:	c3                   	ret    

008005b4 <atomic_getchar>:

int
atomic_getchar(void)
{
  8005b4:	55                   	push   %ebp
  8005b5:	89 e5                	mov    %esp,%ebp
  8005b7:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005ba:	e8 aa 1a 00 00       	call   802069 <sys_disable_interrupt>
	int c=0;
  8005bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8005c6:	eb 08                	jmp    8005d0 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  8005c8:	e8 17 19 00 00       	call   801ee4 <sys_cgetc>
  8005cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  8005d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8005d4:	74 f2                	je     8005c8 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  8005d6:	e8 a8 1a 00 00       	call   802083 <sys_enable_interrupt>
	return c;
  8005db:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8005de:	c9                   	leave  
  8005df:	c3                   	ret    

008005e0 <iscons>:

int iscons(int fdnum)
{
  8005e0:	55                   	push   %ebp
  8005e1:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8005e3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8005e8:	5d                   	pop    %ebp
  8005e9:	c3                   	ret    

008005ea <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8005ea:	55                   	push   %ebp
  8005eb:	89 e5                	mov    %esp,%ebp
  8005ed:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8005f0:	e8 67 1c 00 00       	call   80225c <sys_getenvindex>
  8005f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8005f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005fb:	89 d0                	mov    %edx,%eax
  8005fd:	c1 e0 03             	shl    $0x3,%eax
  800600:	01 d0                	add    %edx,%eax
  800602:	01 c0                	add    %eax,%eax
  800604:	01 d0                	add    %edx,%eax
  800606:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80060d:	01 d0                	add    %edx,%eax
  80060f:	c1 e0 04             	shl    $0x4,%eax
  800612:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800617:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80061c:	a1 24 50 80 00       	mov    0x805024,%eax
  800621:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800627:	84 c0                	test   %al,%al
  800629:	74 0f                	je     80063a <libmain+0x50>
		binaryname = myEnv->prog_name;
  80062b:	a1 24 50 80 00       	mov    0x805024,%eax
  800630:	05 5c 05 00 00       	add    $0x55c,%eax
  800635:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80063a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80063e:	7e 0a                	jle    80064a <libmain+0x60>
		binaryname = argv[0];
  800640:	8b 45 0c             	mov    0xc(%ebp),%eax
  800643:	8b 00                	mov    (%eax),%eax
  800645:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  80064a:	83 ec 08             	sub    $0x8,%esp
  80064d:	ff 75 0c             	pushl  0xc(%ebp)
  800650:	ff 75 08             	pushl  0x8(%ebp)
  800653:	e8 e0 f9 ff ff       	call   800038 <_main>
  800658:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80065b:	e8 09 1a 00 00       	call   802069 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800660:	83 ec 0c             	sub    $0xc,%esp
  800663:	68 ec 3a 80 00       	push   $0x803aec
  800668:	e8 6d 03 00 00       	call   8009da <cprintf>
  80066d:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800670:	a1 24 50 80 00       	mov    0x805024,%eax
  800675:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80067b:	a1 24 50 80 00       	mov    0x805024,%eax
  800680:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800686:	83 ec 04             	sub    $0x4,%esp
  800689:	52                   	push   %edx
  80068a:	50                   	push   %eax
  80068b:	68 14 3b 80 00       	push   $0x803b14
  800690:	e8 45 03 00 00       	call   8009da <cprintf>
  800695:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800698:	a1 24 50 80 00       	mov    0x805024,%eax
  80069d:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8006a3:	a1 24 50 80 00       	mov    0x805024,%eax
  8006a8:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8006ae:	a1 24 50 80 00       	mov    0x805024,%eax
  8006b3:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8006b9:	51                   	push   %ecx
  8006ba:	52                   	push   %edx
  8006bb:	50                   	push   %eax
  8006bc:	68 3c 3b 80 00       	push   $0x803b3c
  8006c1:	e8 14 03 00 00       	call   8009da <cprintf>
  8006c6:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006c9:	a1 24 50 80 00       	mov    0x805024,%eax
  8006ce:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8006d4:	83 ec 08             	sub    $0x8,%esp
  8006d7:	50                   	push   %eax
  8006d8:	68 94 3b 80 00       	push   $0x803b94
  8006dd:	e8 f8 02 00 00       	call   8009da <cprintf>
  8006e2:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8006e5:	83 ec 0c             	sub    $0xc,%esp
  8006e8:	68 ec 3a 80 00       	push   $0x803aec
  8006ed:	e8 e8 02 00 00       	call   8009da <cprintf>
  8006f2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8006f5:	e8 89 19 00 00       	call   802083 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8006fa:	e8 19 00 00 00       	call   800718 <exit>
}
  8006ff:	90                   	nop
  800700:	c9                   	leave  
  800701:	c3                   	ret    

00800702 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800702:	55                   	push   %ebp
  800703:	89 e5                	mov    %esp,%ebp
  800705:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800708:	83 ec 0c             	sub    $0xc,%esp
  80070b:	6a 00                	push   $0x0
  80070d:	e8 16 1b 00 00       	call   802228 <sys_destroy_env>
  800712:	83 c4 10             	add    $0x10,%esp
}
  800715:	90                   	nop
  800716:	c9                   	leave  
  800717:	c3                   	ret    

00800718 <exit>:

void
exit(void)
{
  800718:	55                   	push   %ebp
  800719:	89 e5                	mov    %esp,%ebp
  80071b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80071e:	e8 6b 1b 00 00       	call   80228e <sys_exit_env>
}
  800723:	90                   	nop
  800724:	c9                   	leave  
  800725:	c3                   	ret    

00800726 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800726:	55                   	push   %ebp
  800727:	89 e5                	mov    %esp,%ebp
  800729:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80072c:	8d 45 10             	lea    0x10(%ebp),%eax
  80072f:	83 c0 04             	add    $0x4,%eax
  800732:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800735:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80073a:	85 c0                	test   %eax,%eax
  80073c:	74 16                	je     800754 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80073e:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800743:	83 ec 08             	sub    $0x8,%esp
  800746:	50                   	push   %eax
  800747:	68 a8 3b 80 00       	push   $0x803ba8
  80074c:	e8 89 02 00 00       	call   8009da <cprintf>
  800751:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800754:	a1 00 50 80 00       	mov    0x805000,%eax
  800759:	ff 75 0c             	pushl  0xc(%ebp)
  80075c:	ff 75 08             	pushl  0x8(%ebp)
  80075f:	50                   	push   %eax
  800760:	68 ad 3b 80 00       	push   $0x803bad
  800765:	e8 70 02 00 00       	call   8009da <cprintf>
  80076a:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80076d:	8b 45 10             	mov    0x10(%ebp),%eax
  800770:	83 ec 08             	sub    $0x8,%esp
  800773:	ff 75 f4             	pushl  -0xc(%ebp)
  800776:	50                   	push   %eax
  800777:	e8 f3 01 00 00       	call   80096f <vcprintf>
  80077c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80077f:	83 ec 08             	sub    $0x8,%esp
  800782:	6a 00                	push   $0x0
  800784:	68 c9 3b 80 00       	push   $0x803bc9
  800789:	e8 e1 01 00 00       	call   80096f <vcprintf>
  80078e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800791:	e8 82 ff ff ff       	call   800718 <exit>

	// should not return here
	while (1) ;
  800796:	eb fe                	jmp    800796 <_panic+0x70>

00800798 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800798:	55                   	push   %ebp
  800799:	89 e5                	mov    %esp,%ebp
  80079b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80079e:	a1 24 50 80 00       	mov    0x805024,%eax
  8007a3:	8b 50 74             	mov    0x74(%eax),%edx
  8007a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007a9:	39 c2                	cmp    %eax,%edx
  8007ab:	74 14                	je     8007c1 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8007ad:	83 ec 04             	sub    $0x4,%esp
  8007b0:	68 cc 3b 80 00       	push   $0x803bcc
  8007b5:	6a 26                	push   $0x26
  8007b7:	68 18 3c 80 00       	push   $0x803c18
  8007bc:	e8 65 ff ff ff       	call   800726 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8007c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8007c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8007cf:	e9 c2 00 00 00       	jmp    800896 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8007d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007d7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007de:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e1:	01 d0                	add    %edx,%eax
  8007e3:	8b 00                	mov    (%eax),%eax
  8007e5:	85 c0                	test   %eax,%eax
  8007e7:	75 08                	jne    8007f1 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8007e9:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8007ec:	e9 a2 00 00 00       	jmp    800893 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8007f1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007f8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8007ff:	eb 69                	jmp    80086a <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800801:	a1 24 50 80 00       	mov    0x805024,%eax
  800806:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80080c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80080f:	89 d0                	mov    %edx,%eax
  800811:	01 c0                	add    %eax,%eax
  800813:	01 d0                	add    %edx,%eax
  800815:	c1 e0 03             	shl    $0x3,%eax
  800818:	01 c8                	add    %ecx,%eax
  80081a:	8a 40 04             	mov    0x4(%eax),%al
  80081d:	84 c0                	test   %al,%al
  80081f:	75 46                	jne    800867 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800821:	a1 24 50 80 00       	mov    0x805024,%eax
  800826:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80082c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80082f:	89 d0                	mov    %edx,%eax
  800831:	01 c0                	add    %eax,%eax
  800833:	01 d0                	add    %edx,%eax
  800835:	c1 e0 03             	shl    $0x3,%eax
  800838:	01 c8                	add    %ecx,%eax
  80083a:	8b 00                	mov    (%eax),%eax
  80083c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80083f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800842:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800847:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800849:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80084c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800853:	8b 45 08             	mov    0x8(%ebp),%eax
  800856:	01 c8                	add    %ecx,%eax
  800858:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80085a:	39 c2                	cmp    %eax,%edx
  80085c:	75 09                	jne    800867 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80085e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800865:	eb 12                	jmp    800879 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800867:	ff 45 e8             	incl   -0x18(%ebp)
  80086a:	a1 24 50 80 00       	mov    0x805024,%eax
  80086f:	8b 50 74             	mov    0x74(%eax),%edx
  800872:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800875:	39 c2                	cmp    %eax,%edx
  800877:	77 88                	ja     800801 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800879:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80087d:	75 14                	jne    800893 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80087f:	83 ec 04             	sub    $0x4,%esp
  800882:	68 24 3c 80 00       	push   $0x803c24
  800887:	6a 3a                	push   $0x3a
  800889:	68 18 3c 80 00       	push   $0x803c18
  80088e:	e8 93 fe ff ff       	call   800726 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800893:	ff 45 f0             	incl   -0x10(%ebp)
  800896:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800899:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80089c:	0f 8c 32 ff ff ff    	jl     8007d4 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8008a2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008a9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8008b0:	eb 26                	jmp    8008d8 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8008b2:	a1 24 50 80 00       	mov    0x805024,%eax
  8008b7:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8008bd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008c0:	89 d0                	mov    %edx,%eax
  8008c2:	01 c0                	add    %eax,%eax
  8008c4:	01 d0                	add    %edx,%eax
  8008c6:	c1 e0 03             	shl    $0x3,%eax
  8008c9:	01 c8                	add    %ecx,%eax
  8008cb:	8a 40 04             	mov    0x4(%eax),%al
  8008ce:	3c 01                	cmp    $0x1,%al
  8008d0:	75 03                	jne    8008d5 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8008d2:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008d5:	ff 45 e0             	incl   -0x20(%ebp)
  8008d8:	a1 24 50 80 00       	mov    0x805024,%eax
  8008dd:	8b 50 74             	mov    0x74(%eax),%edx
  8008e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008e3:	39 c2                	cmp    %eax,%edx
  8008e5:	77 cb                	ja     8008b2 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8008e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008ea:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8008ed:	74 14                	je     800903 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8008ef:	83 ec 04             	sub    $0x4,%esp
  8008f2:	68 78 3c 80 00       	push   $0x803c78
  8008f7:	6a 44                	push   $0x44
  8008f9:	68 18 3c 80 00       	push   $0x803c18
  8008fe:	e8 23 fe ff ff       	call   800726 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800903:	90                   	nop
  800904:	c9                   	leave  
  800905:	c3                   	ret    

00800906 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800906:	55                   	push   %ebp
  800907:	89 e5                	mov    %esp,%ebp
  800909:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80090c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80090f:	8b 00                	mov    (%eax),%eax
  800911:	8d 48 01             	lea    0x1(%eax),%ecx
  800914:	8b 55 0c             	mov    0xc(%ebp),%edx
  800917:	89 0a                	mov    %ecx,(%edx)
  800919:	8b 55 08             	mov    0x8(%ebp),%edx
  80091c:	88 d1                	mov    %dl,%cl
  80091e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800921:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800925:	8b 45 0c             	mov    0xc(%ebp),%eax
  800928:	8b 00                	mov    (%eax),%eax
  80092a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80092f:	75 2c                	jne    80095d <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800931:	a0 28 50 80 00       	mov    0x805028,%al
  800936:	0f b6 c0             	movzbl %al,%eax
  800939:	8b 55 0c             	mov    0xc(%ebp),%edx
  80093c:	8b 12                	mov    (%edx),%edx
  80093e:	89 d1                	mov    %edx,%ecx
  800940:	8b 55 0c             	mov    0xc(%ebp),%edx
  800943:	83 c2 08             	add    $0x8,%edx
  800946:	83 ec 04             	sub    $0x4,%esp
  800949:	50                   	push   %eax
  80094a:	51                   	push   %ecx
  80094b:	52                   	push   %edx
  80094c:	e8 6a 15 00 00       	call   801ebb <sys_cputs>
  800951:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800954:	8b 45 0c             	mov    0xc(%ebp),%eax
  800957:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80095d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800960:	8b 40 04             	mov    0x4(%eax),%eax
  800963:	8d 50 01             	lea    0x1(%eax),%edx
  800966:	8b 45 0c             	mov    0xc(%ebp),%eax
  800969:	89 50 04             	mov    %edx,0x4(%eax)
}
  80096c:	90                   	nop
  80096d:	c9                   	leave  
  80096e:	c3                   	ret    

0080096f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80096f:	55                   	push   %ebp
  800970:	89 e5                	mov    %esp,%ebp
  800972:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800978:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80097f:	00 00 00 
	b.cnt = 0;
  800982:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800989:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80098c:	ff 75 0c             	pushl  0xc(%ebp)
  80098f:	ff 75 08             	pushl  0x8(%ebp)
  800992:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800998:	50                   	push   %eax
  800999:	68 06 09 80 00       	push   $0x800906
  80099e:	e8 11 02 00 00       	call   800bb4 <vprintfmt>
  8009a3:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8009a6:	a0 28 50 80 00       	mov    0x805028,%al
  8009ab:	0f b6 c0             	movzbl %al,%eax
  8009ae:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8009b4:	83 ec 04             	sub    $0x4,%esp
  8009b7:	50                   	push   %eax
  8009b8:	52                   	push   %edx
  8009b9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009bf:	83 c0 08             	add    $0x8,%eax
  8009c2:	50                   	push   %eax
  8009c3:	e8 f3 14 00 00       	call   801ebb <sys_cputs>
  8009c8:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8009cb:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  8009d2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8009d8:	c9                   	leave  
  8009d9:	c3                   	ret    

008009da <cprintf>:

int cprintf(const char *fmt, ...) {
  8009da:	55                   	push   %ebp
  8009db:	89 e5                	mov    %esp,%ebp
  8009dd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8009e0:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  8009e7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f0:	83 ec 08             	sub    $0x8,%esp
  8009f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8009f6:	50                   	push   %eax
  8009f7:	e8 73 ff ff ff       	call   80096f <vcprintf>
  8009fc:	83 c4 10             	add    $0x10,%esp
  8009ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a02:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a05:	c9                   	leave  
  800a06:	c3                   	ret    

00800a07 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a07:	55                   	push   %ebp
  800a08:	89 e5                	mov    %esp,%ebp
  800a0a:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a0d:	e8 57 16 00 00       	call   802069 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a12:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a15:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a18:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1b:	83 ec 08             	sub    $0x8,%esp
  800a1e:	ff 75 f4             	pushl  -0xc(%ebp)
  800a21:	50                   	push   %eax
  800a22:	e8 48 ff ff ff       	call   80096f <vcprintf>
  800a27:	83 c4 10             	add    $0x10,%esp
  800a2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a2d:	e8 51 16 00 00       	call   802083 <sys_enable_interrupt>
	return cnt;
  800a32:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a35:	c9                   	leave  
  800a36:	c3                   	ret    

00800a37 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a37:	55                   	push   %ebp
  800a38:	89 e5                	mov    %esp,%ebp
  800a3a:	53                   	push   %ebx
  800a3b:	83 ec 14             	sub    $0x14,%esp
  800a3e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a41:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a44:	8b 45 14             	mov    0x14(%ebp),%eax
  800a47:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a4a:	8b 45 18             	mov    0x18(%ebp),%eax
  800a4d:	ba 00 00 00 00       	mov    $0x0,%edx
  800a52:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a55:	77 55                	ja     800aac <printnum+0x75>
  800a57:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a5a:	72 05                	jb     800a61 <printnum+0x2a>
  800a5c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a5f:	77 4b                	ja     800aac <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a61:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a64:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a67:	8b 45 18             	mov    0x18(%ebp),%eax
  800a6a:	ba 00 00 00 00       	mov    $0x0,%edx
  800a6f:	52                   	push   %edx
  800a70:	50                   	push   %eax
  800a71:	ff 75 f4             	pushl  -0xc(%ebp)
  800a74:	ff 75 f0             	pushl  -0x10(%ebp)
  800a77:	e8 4c 2c 00 00       	call   8036c8 <__udivdi3>
  800a7c:	83 c4 10             	add    $0x10,%esp
  800a7f:	83 ec 04             	sub    $0x4,%esp
  800a82:	ff 75 20             	pushl  0x20(%ebp)
  800a85:	53                   	push   %ebx
  800a86:	ff 75 18             	pushl  0x18(%ebp)
  800a89:	52                   	push   %edx
  800a8a:	50                   	push   %eax
  800a8b:	ff 75 0c             	pushl  0xc(%ebp)
  800a8e:	ff 75 08             	pushl  0x8(%ebp)
  800a91:	e8 a1 ff ff ff       	call   800a37 <printnum>
  800a96:	83 c4 20             	add    $0x20,%esp
  800a99:	eb 1a                	jmp    800ab5 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a9b:	83 ec 08             	sub    $0x8,%esp
  800a9e:	ff 75 0c             	pushl  0xc(%ebp)
  800aa1:	ff 75 20             	pushl  0x20(%ebp)
  800aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa7:	ff d0                	call   *%eax
  800aa9:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800aac:	ff 4d 1c             	decl   0x1c(%ebp)
  800aaf:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800ab3:	7f e6                	jg     800a9b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800ab5:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800ab8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800abd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ac0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ac3:	53                   	push   %ebx
  800ac4:	51                   	push   %ecx
  800ac5:	52                   	push   %edx
  800ac6:	50                   	push   %eax
  800ac7:	e8 0c 2d 00 00       	call   8037d8 <__umoddi3>
  800acc:	83 c4 10             	add    $0x10,%esp
  800acf:	05 f4 3e 80 00       	add    $0x803ef4,%eax
  800ad4:	8a 00                	mov    (%eax),%al
  800ad6:	0f be c0             	movsbl %al,%eax
  800ad9:	83 ec 08             	sub    $0x8,%esp
  800adc:	ff 75 0c             	pushl  0xc(%ebp)
  800adf:	50                   	push   %eax
  800ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae3:	ff d0                	call   *%eax
  800ae5:	83 c4 10             	add    $0x10,%esp
}
  800ae8:	90                   	nop
  800ae9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800aec:	c9                   	leave  
  800aed:	c3                   	ret    

00800aee <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800aee:	55                   	push   %ebp
  800aef:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800af1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800af5:	7e 1c                	jle    800b13 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800af7:	8b 45 08             	mov    0x8(%ebp),%eax
  800afa:	8b 00                	mov    (%eax),%eax
  800afc:	8d 50 08             	lea    0x8(%eax),%edx
  800aff:	8b 45 08             	mov    0x8(%ebp),%eax
  800b02:	89 10                	mov    %edx,(%eax)
  800b04:	8b 45 08             	mov    0x8(%ebp),%eax
  800b07:	8b 00                	mov    (%eax),%eax
  800b09:	83 e8 08             	sub    $0x8,%eax
  800b0c:	8b 50 04             	mov    0x4(%eax),%edx
  800b0f:	8b 00                	mov    (%eax),%eax
  800b11:	eb 40                	jmp    800b53 <getuint+0x65>
	else if (lflag)
  800b13:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b17:	74 1e                	je     800b37 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b19:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1c:	8b 00                	mov    (%eax),%eax
  800b1e:	8d 50 04             	lea    0x4(%eax),%edx
  800b21:	8b 45 08             	mov    0x8(%ebp),%eax
  800b24:	89 10                	mov    %edx,(%eax)
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	8b 00                	mov    (%eax),%eax
  800b2b:	83 e8 04             	sub    $0x4,%eax
  800b2e:	8b 00                	mov    (%eax),%eax
  800b30:	ba 00 00 00 00       	mov    $0x0,%edx
  800b35:	eb 1c                	jmp    800b53 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b37:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3a:	8b 00                	mov    (%eax),%eax
  800b3c:	8d 50 04             	lea    0x4(%eax),%edx
  800b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b42:	89 10                	mov    %edx,(%eax)
  800b44:	8b 45 08             	mov    0x8(%ebp),%eax
  800b47:	8b 00                	mov    (%eax),%eax
  800b49:	83 e8 04             	sub    $0x4,%eax
  800b4c:	8b 00                	mov    (%eax),%eax
  800b4e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b53:	5d                   	pop    %ebp
  800b54:	c3                   	ret    

00800b55 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b55:	55                   	push   %ebp
  800b56:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b58:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b5c:	7e 1c                	jle    800b7a <getint+0x25>
		return va_arg(*ap, long long);
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	8b 00                	mov    (%eax),%eax
  800b63:	8d 50 08             	lea    0x8(%eax),%edx
  800b66:	8b 45 08             	mov    0x8(%ebp),%eax
  800b69:	89 10                	mov    %edx,(%eax)
  800b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6e:	8b 00                	mov    (%eax),%eax
  800b70:	83 e8 08             	sub    $0x8,%eax
  800b73:	8b 50 04             	mov    0x4(%eax),%edx
  800b76:	8b 00                	mov    (%eax),%eax
  800b78:	eb 38                	jmp    800bb2 <getint+0x5d>
	else if (lflag)
  800b7a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b7e:	74 1a                	je     800b9a <getint+0x45>
		return va_arg(*ap, long);
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	8b 00                	mov    (%eax),%eax
  800b85:	8d 50 04             	lea    0x4(%eax),%edx
  800b88:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8b:	89 10                	mov    %edx,(%eax)
  800b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b90:	8b 00                	mov    (%eax),%eax
  800b92:	83 e8 04             	sub    $0x4,%eax
  800b95:	8b 00                	mov    (%eax),%eax
  800b97:	99                   	cltd   
  800b98:	eb 18                	jmp    800bb2 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9d:	8b 00                	mov    (%eax),%eax
  800b9f:	8d 50 04             	lea    0x4(%eax),%edx
  800ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba5:	89 10                	mov    %edx,(%eax)
  800ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  800baa:	8b 00                	mov    (%eax),%eax
  800bac:	83 e8 04             	sub    $0x4,%eax
  800baf:	8b 00                	mov    (%eax),%eax
  800bb1:	99                   	cltd   
}
  800bb2:	5d                   	pop    %ebp
  800bb3:	c3                   	ret    

00800bb4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800bb4:	55                   	push   %ebp
  800bb5:	89 e5                	mov    %esp,%ebp
  800bb7:	56                   	push   %esi
  800bb8:	53                   	push   %ebx
  800bb9:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bbc:	eb 17                	jmp    800bd5 <vprintfmt+0x21>
			if (ch == '\0')
  800bbe:	85 db                	test   %ebx,%ebx
  800bc0:	0f 84 af 03 00 00    	je     800f75 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800bc6:	83 ec 08             	sub    $0x8,%esp
  800bc9:	ff 75 0c             	pushl  0xc(%ebp)
  800bcc:	53                   	push   %ebx
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	ff d0                	call   *%eax
  800bd2:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bd5:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd8:	8d 50 01             	lea    0x1(%eax),%edx
  800bdb:	89 55 10             	mov    %edx,0x10(%ebp)
  800bde:	8a 00                	mov    (%eax),%al
  800be0:	0f b6 d8             	movzbl %al,%ebx
  800be3:	83 fb 25             	cmp    $0x25,%ebx
  800be6:	75 d6                	jne    800bbe <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800be8:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800bec:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800bf3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800bfa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c01:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c08:	8b 45 10             	mov    0x10(%ebp),%eax
  800c0b:	8d 50 01             	lea    0x1(%eax),%edx
  800c0e:	89 55 10             	mov    %edx,0x10(%ebp)
  800c11:	8a 00                	mov    (%eax),%al
  800c13:	0f b6 d8             	movzbl %al,%ebx
  800c16:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c19:	83 f8 55             	cmp    $0x55,%eax
  800c1c:	0f 87 2b 03 00 00    	ja     800f4d <vprintfmt+0x399>
  800c22:	8b 04 85 18 3f 80 00 	mov    0x803f18(,%eax,4),%eax
  800c29:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c2b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c2f:	eb d7                	jmp    800c08 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c31:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c35:	eb d1                	jmp    800c08 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c37:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c3e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c41:	89 d0                	mov    %edx,%eax
  800c43:	c1 e0 02             	shl    $0x2,%eax
  800c46:	01 d0                	add    %edx,%eax
  800c48:	01 c0                	add    %eax,%eax
  800c4a:	01 d8                	add    %ebx,%eax
  800c4c:	83 e8 30             	sub    $0x30,%eax
  800c4f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c52:	8b 45 10             	mov    0x10(%ebp),%eax
  800c55:	8a 00                	mov    (%eax),%al
  800c57:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c5a:	83 fb 2f             	cmp    $0x2f,%ebx
  800c5d:	7e 3e                	jle    800c9d <vprintfmt+0xe9>
  800c5f:	83 fb 39             	cmp    $0x39,%ebx
  800c62:	7f 39                	jg     800c9d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c64:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c67:	eb d5                	jmp    800c3e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c69:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6c:	83 c0 04             	add    $0x4,%eax
  800c6f:	89 45 14             	mov    %eax,0x14(%ebp)
  800c72:	8b 45 14             	mov    0x14(%ebp),%eax
  800c75:	83 e8 04             	sub    $0x4,%eax
  800c78:	8b 00                	mov    (%eax),%eax
  800c7a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c7d:	eb 1f                	jmp    800c9e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c7f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c83:	79 83                	jns    800c08 <vprintfmt+0x54>
				width = 0;
  800c85:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c8c:	e9 77 ff ff ff       	jmp    800c08 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c91:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c98:	e9 6b ff ff ff       	jmp    800c08 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c9d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c9e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ca2:	0f 89 60 ff ff ff    	jns    800c08 <vprintfmt+0x54>
				width = precision, precision = -1;
  800ca8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800cae:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800cb5:	e9 4e ff ff ff       	jmp    800c08 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800cba:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800cbd:	e9 46 ff ff ff       	jmp    800c08 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800cc2:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc5:	83 c0 04             	add    $0x4,%eax
  800cc8:	89 45 14             	mov    %eax,0x14(%ebp)
  800ccb:	8b 45 14             	mov    0x14(%ebp),%eax
  800cce:	83 e8 04             	sub    $0x4,%eax
  800cd1:	8b 00                	mov    (%eax),%eax
  800cd3:	83 ec 08             	sub    $0x8,%esp
  800cd6:	ff 75 0c             	pushl  0xc(%ebp)
  800cd9:	50                   	push   %eax
  800cda:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdd:	ff d0                	call   *%eax
  800cdf:	83 c4 10             	add    $0x10,%esp
			break;
  800ce2:	e9 89 02 00 00       	jmp    800f70 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ce7:	8b 45 14             	mov    0x14(%ebp),%eax
  800cea:	83 c0 04             	add    $0x4,%eax
  800ced:	89 45 14             	mov    %eax,0x14(%ebp)
  800cf0:	8b 45 14             	mov    0x14(%ebp),%eax
  800cf3:	83 e8 04             	sub    $0x4,%eax
  800cf6:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800cf8:	85 db                	test   %ebx,%ebx
  800cfa:	79 02                	jns    800cfe <vprintfmt+0x14a>
				err = -err;
  800cfc:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800cfe:	83 fb 64             	cmp    $0x64,%ebx
  800d01:	7f 0b                	jg     800d0e <vprintfmt+0x15a>
  800d03:	8b 34 9d 60 3d 80 00 	mov    0x803d60(,%ebx,4),%esi
  800d0a:	85 f6                	test   %esi,%esi
  800d0c:	75 19                	jne    800d27 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d0e:	53                   	push   %ebx
  800d0f:	68 05 3f 80 00       	push   $0x803f05
  800d14:	ff 75 0c             	pushl  0xc(%ebp)
  800d17:	ff 75 08             	pushl  0x8(%ebp)
  800d1a:	e8 5e 02 00 00       	call   800f7d <printfmt>
  800d1f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d22:	e9 49 02 00 00       	jmp    800f70 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d27:	56                   	push   %esi
  800d28:	68 0e 3f 80 00       	push   $0x803f0e
  800d2d:	ff 75 0c             	pushl  0xc(%ebp)
  800d30:	ff 75 08             	pushl  0x8(%ebp)
  800d33:	e8 45 02 00 00       	call   800f7d <printfmt>
  800d38:	83 c4 10             	add    $0x10,%esp
			break;
  800d3b:	e9 30 02 00 00       	jmp    800f70 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d40:	8b 45 14             	mov    0x14(%ebp),%eax
  800d43:	83 c0 04             	add    $0x4,%eax
  800d46:	89 45 14             	mov    %eax,0x14(%ebp)
  800d49:	8b 45 14             	mov    0x14(%ebp),%eax
  800d4c:	83 e8 04             	sub    $0x4,%eax
  800d4f:	8b 30                	mov    (%eax),%esi
  800d51:	85 f6                	test   %esi,%esi
  800d53:	75 05                	jne    800d5a <vprintfmt+0x1a6>
				p = "(null)";
  800d55:	be 11 3f 80 00       	mov    $0x803f11,%esi
			if (width > 0 && padc != '-')
  800d5a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d5e:	7e 6d                	jle    800dcd <vprintfmt+0x219>
  800d60:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d64:	74 67                	je     800dcd <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d66:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d69:	83 ec 08             	sub    $0x8,%esp
  800d6c:	50                   	push   %eax
  800d6d:	56                   	push   %esi
  800d6e:	e8 12 05 00 00       	call   801285 <strnlen>
  800d73:	83 c4 10             	add    $0x10,%esp
  800d76:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d79:	eb 16                	jmp    800d91 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d7b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d7f:	83 ec 08             	sub    $0x8,%esp
  800d82:	ff 75 0c             	pushl  0xc(%ebp)
  800d85:	50                   	push   %eax
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	ff d0                	call   *%eax
  800d8b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d8e:	ff 4d e4             	decl   -0x1c(%ebp)
  800d91:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d95:	7f e4                	jg     800d7b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d97:	eb 34                	jmp    800dcd <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d99:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d9d:	74 1c                	je     800dbb <vprintfmt+0x207>
  800d9f:	83 fb 1f             	cmp    $0x1f,%ebx
  800da2:	7e 05                	jle    800da9 <vprintfmt+0x1f5>
  800da4:	83 fb 7e             	cmp    $0x7e,%ebx
  800da7:	7e 12                	jle    800dbb <vprintfmt+0x207>
					putch('?', putdat);
  800da9:	83 ec 08             	sub    $0x8,%esp
  800dac:	ff 75 0c             	pushl  0xc(%ebp)
  800daf:	6a 3f                	push   $0x3f
  800db1:	8b 45 08             	mov    0x8(%ebp),%eax
  800db4:	ff d0                	call   *%eax
  800db6:	83 c4 10             	add    $0x10,%esp
  800db9:	eb 0f                	jmp    800dca <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800dbb:	83 ec 08             	sub    $0x8,%esp
  800dbe:	ff 75 0c             	pushl  0xc(%ebp)
  800dc1:	53                   	push   %ebx
  800dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc5:	ff d0                	call   *%eax
  800dc7:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dca:	ff 4d e4             	decl   -0x1c(%ebp)
  800dcd:	89 f0                	mov    %esi,%eax
  800dcf:	8d 70 01             	lea    0x1(%eax),%esi
  800dd2:	8a 00                	mov    (%eax),%al
  800dd4:	0f be d8             	movsbl %al,%ebx
  800dd7:	85 db                	test   %ebx,%ebx
  800dd9:	74 24                	je     800dff <vprintfmt+0x24b>
  800ddb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ddf:	78 b8                	js     800d99 <vprintfmt+0x1e5>
  800de1:	ff 4d e0             	decl   -0x20(%ebp)
  800de4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800de8:	79 af                	jns    800d99 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800dea:	eb 13                	jmp    800dff <vprintfmt+0x24b>
				putch(' ', putdat);
  800dec:	83 ec 08             	sub    $0x8,%esp
  800def:	ff 75 0c             	pushl  0xc(%ebp)
  800df2:	6a 20                	push   $0x20
  800df4:	8b 45 08             	mov    0x8(%ebp),%eax
  800df7:	ff d0                	call   *%eax
  800df9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800dfc:	ff 4d e4             	decl   -0x1c(%ebp)
  800dff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e03:	7f e7                	jg     800dec <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e05:	e9 66 01 00 00       	jmp    800f70 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e0a:	83 ec 08             	sub    $0x8,%esp
  800e0d:	ff 75 e8             	pushl  -0x18(%ebp)
  800e10:	8d 45 14             	lea    0x14(%ebp),%eax
  800e13:	50                   	push   %eax
  800e14:	e8 3c fd ff ff       	call   800b55 <getint>
  800e19:	83 c4 10             	add    $0x10,%esp
  800e1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e1f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e28:	85 d2                	test   %edx,%edx
  800e2a:	79 23                	jns    800e4f <vprintfmt+0x29b>
				putch('-', putdat);
  800e2c:	83 ec 08             	sub    $0x8,%esp
  800e2f:	ff 75 0c             	pushl  0xc(%ebp)
  800e32:	6a 2d                	push   $0x2d
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
  800e37:	ff d0                	call   *%eax
  800e39:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e42:	f7 d8                	neg    %eax
  800e44:	83 d2 00             	adc    $0x0,%edx
  800e47:	f7 da                	neg    %edx
  800e49:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e4c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e4f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e56:	e9 bc 00 00 00       	jmp    800f17 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e5b:	83 ec 08             	sub    $0x8,%esp
  800e5e:	ff 75 e8             	pushl  -0x18(%ebp)
  800e61:	8d 45 14             	lea    0x14(%ebp),%eax
  800e64:	50                   	push   %eax
  800e65:	e8 84 fc ff ff       	call   800aee <getuint>
  800e6a:	83 c4 10             	add    $0x10,%esp
  800e6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e70:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e73:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e7a:	e9 98 00 00 00       	jmp    800f17 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e7f:	83 ec 08             	sub    $0x8,%esp
  800e82:	ff 75 0c             	pushl  0xc(%ebp)
  800e85:	6a 58                	push   $0x58
  800e87:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8a:	ff d0                	call   *%eax
  800e8c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e8f:	83 ec 08             	sub    $0x8,%esp
  800e92:	ff 75 0c             	pushl  0xc(%ebp)
  800e95:	6a 58                	push   $0x58
  800e97:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9a:	ff d0                	call   *%eax
  800e9c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e9f:	83 ec 08             	sub    $0x8,%esp
  800ea2:	ff 75 0c             	pushl  0xc(%ebp)
  800ea5:	6a 58                	push   $0x58
  800ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaa:	ff d0                	call   *%eax
  800eac:	83 c4 10             	add    $0x10,%esp
			break;
  800eaf:	e9 bc 00 00 00       	jmp    800f70 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800eb4:	83 ec 08             	sub    $0x8,%esp
  800eb7:	ff 75 0c             	pushl  0xc(%ebp)
  800eba:	6a 30                	push   $0x30
  800ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebf:	ff d0                	call   *%eax
  800ec1:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ec4:	83 ec 08             	sub    $0x8,%esp
  800ec7:	ff 75 0c             	pushl  0xc(%ebp)
  800eca:	6a 78                	push   $0x78
  800ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecf:	ff d0                	call   *%eax
  800ed1:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ed4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed7:	83 c0 04             	add    $0x4,%eax
  800eda:	89 45 14             	mov    %eax,0x14(%ebp)
  800edd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ee0:	83 e8 04             	sub    $0x4,%eax
  800ee3:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ee5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ee8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800eef:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ef6:	eb 1f                	jmp    800f17 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ef8:	83 ec 08             	sub    $0x8,%esp
  800efb:	ff 75 e8             	pushl  -0x18(%ebp)
  800efe:	8d 45 14             	lea    0x14(%ebp),%eax
  800f01:	50                   	push   %eax
  800f02:	e8 e7 fb ff ff       	call   800aee <getuint>
  800f07:	83 c4 10             	add    $0x10,%esp
  800f0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f0d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f10:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f17:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f1e:	83 ec 04             	sub    $0x4,%esp
  800f21:	52                   	push   %edx
  800f22:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f25:	50                   	push   %eax
  800f26:	ff 75 f4             	pushl  -0xc(%ebp)
  800f29:	ff 75 f0             	pushl  -0x10(%ebp)
  800f2c:	ff 75 0c             	pushl  0xc(%ebp)
  800f2f:	ff 75 08             	pushl  0x8(%ebp)
  800f32:	e8 00 fb ff ff       	call   800a37 <printnum>
  800f37:	83 c4 20             	add    $0x20,%esp
			break;
  800f3a:	eb 34                	jmp    800f70 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f3c:	83 ec 08             	sub    $0x8,%esp
  800f3f:	ff 75 0c             	pushl  0xc(%ebp)
  800f42:	53                   	push   %ebx
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
  800f46:	ff d0                	call   *%eax
  800f48:	83 c4 10             	add    $0x10,%esp
			break;
  800f4b:	eb 23                	jmp    800f70 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f4d:	83 ec 08             	sub    $0x8,%esp
  800f50:	ff 75 0c             	pushl  0xc(%ebp)
  800f53:	6a 25                	push   $0x25
  800f55:	8b 45 08             	mov    0x8(%ebp),%eax
  800f58:	ff d0                	call   *%eax
  800f5a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f5d:	ff 4d 10             	decl   0x10(%ebp)
  800f60:	eb 03                	jmp    800f65 <vprintfmt+0x3b1>
  800f62:	ff 4d 10             	decl   0x10(%ebp)
  800f65:	8b 45 10             	mov    0x10(%ebp),%eax
  800f68:	48                   	dec    %eax
  800f69:	8a 00                	mov    (%eax),%al
  800f6b:	3c 25                	cmp    $0x25,%al
  800f6d:	75 f3                	jne    800f62 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f6f:	90                   	nop
		}
	}
  800f70:	e9 47 fc ff ff       	jmp    800bbc <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f75:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f76:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f79:	5b                   	pop    %ebx
  800f7a:	5e                   	pop    %esi
  800f7b:	5d                   	pop    %ebp
  800f7c:	c3                   	ret    

00800f7d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f7d:	55                   	push   %ebp
  800f7e:	89 e5                	mov    %esp,%ebp
  800f80:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f83:	8d 45 10             	lea    0x10(%ebp),%eax
  800f86:	83 c0 04             	add    $0x4,%eax
  800f89:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f8c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8f:	ff 75 f4             	pushl  -0xc(%ebp)
  800f92:	50                   	push   %eax
  800f93:	ff 75 0c             	pushl  0xc(%ebp)
  800f96:	ff 75 08             	pushl  0x8(%ebp)
  800f99:	e8 16 fc ff ff       	call   800bb4 <vprintfmt>
  800f9e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800fa1:	90                   	nop
  800fa2:	c9                   	leave  
  800fa3:	c3                   	ret    

00800fa4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fa4:	55                   	push   %ebp
  800fa5:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800fa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800faa:	8b 40 08             	mov    0x8(%eax),%eax
  800fad:	8d 50 01             	lea    0x1(%eax),%edx
  800fb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb3:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800fb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb9:	8b 10                	mov    (%eax),%edx
  800fbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbe:	8b 40 04             	mov    0x4(%eax),%eax
  800fc1:	39 c2                	cmp    %eax,%edx
  800fc3:	73 12                	jae    800fd7 <sprintputch+0x33>
		*b->buf++ = ch;
  800fc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc8:	8b 00                	mov    (%eax),%eax
  800fca:	8d 48 01             	lea    0x1(%eax),%ecx
  800fcd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fd0:	89 0a                	mov    %ecx,(%edx)
  800fd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd5:	88 10                	mov    %dl,(%eax)
}
  800fd7:	90                   	nop
  800fd8:	5d                   	pop    %ebp
  800fd9:	c3                   	ret    

00800fda <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800fda:	55                   	push   %ebp
  800fdb:	89 e5                	mov    %esp,%ebp
  800fdd:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800fe6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fec:	8b 45 08             	mov    0x8(%ebp),%eax
  800fef:	01 d0                	add    %edx,%eax
  800ff1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ff4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ffb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fff:	74 06                	je     801007 <vsnprintf+0x2d>
  801001:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801005:	7f 07                	jg     80100e <vsnprintf+0x34>
		return -E_INVAL;
  801007:	b8 03 00 00 00       	mov    $0x3,%eax
  80100c:	eb 20                	jmp    80102e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80100e:	ff 75 14             	pushl  0x14(%ebp)
  801011:	ff 75 10             	pushl  0x10(%ebp)
  801014:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801017:	50                   	push   %eax
  801018:	68 a4 0f 80 00       	push   $0x800fa4
  80101d:	e8 92 fb ff ff       	call   800bb4 <vprintfmt>
  801022:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801025:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801028:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80102b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80102e:	c9                   	leave  
  80102f:	c3                   	ret    

00801030 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801030:	55                   	push   %ebp
  801031:	89 e5                	mov    %esp,%ebp
  801033:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801036:	8d 45 10             	lea    0x10(%ebp),%eax
  801039:	83 c0 04             	add    $0x4,%eax
  80103c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80103f:	8b 45 10             	mov    0x10(%ebp),%eax
  801042:	ff 75 f4             	pushl  -0xc(%ebp)
  801045:	50                   	push   %eax
  801046:	ff 75 0c             	pushl  0xc(%ebp)
  801049:	ff 75 08             	pushl  0x8(%ebp)
  80104c:	e8 89 ff ff ff       	call   800fda <vsnprintf>
  801051:	83 c4 10             	add    $0x10,%esp
  801054:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801057:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80105a:	c9                   	leave  
  80105b:	c3                   	ret    

0080105c <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  80105c:	55                   	push   %ebp
  80105d:	89 e5                	mov    %esp,%ebp
  80105f:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  801062:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801066:	74 13                	je     80107b <readline+0x1f>
		cprintf("%s", prompt);
  801068:	83 ec 08             	sub    $0x8,%esp
  80106b:	ff 75 08             	pushl  0x8(%ebp)
  80106e:	68 70 40 80 00       	push   $0x804070
  801073:	e8 62 f9 ff ff       	call   8009da <cprintf>
  801078:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80107b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801082:	83 ec 0c             	sub    $0xc,%esp
  801085:	6a 00                	push   $0x0
  801087:	e8 54 f5 ff ff       	call   8005e0 <iscons>
  80108c:	83 c4 10             	add    $0x10,%esp
  80108f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801092:	e8 fb f4 ff ff       	call   800592 <getchar>
  801097:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80109a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80109e:	79 22                	jns    8010c2 <readline+0x66>
			if (c != -E_EOF)
  8010a0:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8010a4:	0f 84 ad 00 00 00    	je     801157 <readline+0xfb>
				cprintf("read error: %e\n", c);
  8010aa:	83 ec 08             	sub    $0x8,%esp
  8010ad:	ff 75 ec             	pushl  -0x14(%ebp)
  8010b0:	68 73 40 80 00       	push   $0x804073
  8010b5:	e8 20 f9 ff ff       	call   8009da <cprintf>
  8010ba:	83 c4 10             	add    $0x10,%esp
			return;
  8010bd:	e9 95 00 00 00       	jmp    801157 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8010c2:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8010c6:	7e 34                	jle    8010fc <readline+0xa0>
  8010c8:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8010cf:	7f 2b                	jg     8010fc <readline+0xa0>
			if (echoing)
  8010d1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8010d5:	74 0e                	je     8010e5 <readline+0x89>
				cputchar(c);
  8010d7:	83 ec 0c             	sub    $0xc,%esp
  8010da:	ff 75 ec             	pushl  -0x14(%ebp)
  8010dd:	e8 68 f4 ff ff       	call   80054a <cputchar>
  8010e2:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8010e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010e8:	8d 50 01             	lea    0x1(%eax),%edx
  8010eb:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8010ee:	89 c2                	mov    %eax,%edx
  8010f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f3:	01 d0                	add    %edx,%eax
  8010f5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010f8:	88 10                	mov    %dl,(%eax)
  8010fa:	eb 56                	jmp    801152 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  8010fc:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801100:	75 1f                	jne    801121 <readline+0xc5>
  801102:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801106:	7e 19                	jle    801121 <readline+0xc5>
			if (echoing)
  801108:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80110c:	74 0e                	je     80111c <readline+0xc0>
				cputchar(c);
  80110e:	83 ec 0c             	sub    $0xc,%esp
  801111:	ff 75 ec             	pushl  -0x14(%ebp)
  801114:	e8 31 f4 ff ff       	call   80054a <cputchar>
  801119:	83 c4 10             	add    $0x10,%esp

			i--;
  80111c:	ff 4d f4             	decl   -0xc(%ebp)
  80111f:	eb 31                	jmp    801152 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801121:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801125:	74 0a                	je     801131 <readline+0xd5>
  801127:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80112b:	0f 85 61 ff ff ff    	jne    801092 <readline+0x36>
			if (echoing)
  801131:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801135:	74 0e                	je     801145 <readline+0xe9>
				cputchar(c);
  801137:	83 ec 0c             	sub    $0xc,%esp
  80113a:	ff 75 ec             	pushl  -0x14(%ebp)
  80113d:	e8 08 f4 ff ff       	call   80054a <cputchar>
  801142:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  801145:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801148:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114b:	01 d0                	add    %edx,%eax
  80114d:	c6 00 00             	movb   $0x0,(%eax)
			return;
  801150:	eb 06                	jmp    801158 <readline+0xfc>
		}
	}
  801152:	e9 3b ff ff ff       	jmp    801092 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  801157:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  801158:	c9                   	leave  
  801159:	c3                   	ret    

0080115a <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  80115a:	55                   	push   %ebp
  80115b:	89 e5                	mov    %esp,%ebp
  80115d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801160:	e8 04 0f 00 00       	call   802069 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  801165:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801169:	74 13                	je     80117e <atomic_readline+0x24>
		cprintf("%s", prompt);
  80116b:	83 ec 08             	sub    $0x8,%esp
  80116e:	ff 75 08             	pushl  0x8(%ebp)
  801171:	68 70 40 80 00       	push   $0x804070
  801176:	e8 5f f8 ff ff       	call   8009da <cprintf>
  80117b:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80117e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801185:	83 ec 0c             	sub    $0xc,%esp
  801188:	6a 00                	push   $0x0
  80118a:	e8 51 f4 ff ff       	call   8005e0 <iscons>
  80118f:	83 c4 10             	add    $0x10,%esp
  801192:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801195:	e8 f8 f3 ff ff       	call   800592 <getchar>
  80119a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80119d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8011a1:	79 23                	jns    8011c6 <atomic_readline+0x6c>
			if (c != -E_EOF)
  8011a3:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8011a7:	74 13                	je     8011bc <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  8011a9:	83 ec 08             	sub    $0x8,%esp
  8011ac:	ff 75 ec             	pushl  -0x14(%ebp)
  8011af:	68 73 40 80 00       	push   $0x804073
  8011b4:	e8 21 f8 ff ff       	call   8009da <cprintf>
  8011b9:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  8011bc:	e8 c2 0e 00 00       	call   802083 <sys_enable_interrupt>
			return;
  8011c1:	e9 9a 00 00 00       	jmp    801260 <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8011c6:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8011ca:	7e 34                	jle    801200 <atomic_readline+0xa6>
  8011cc:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8011d3:	7f 2b                	jg     801200 <atomic_readline+0xa6>
			if (echoing)
  8011d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011d9:	74 0e                	je     8011e9 <atomic_readline+0x8f>
				cputchar(c);
  8011db:	83 ec 0c             	sub    $0xc,%esp
  8011de:	ff 75 ec             	pushl  -0x14(%ebp)
  8011e1:	e8 64 f3 ff ff       	call   80054a <cputchar>
  8011e6:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8011e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ec:	8d 50 01             	lea    0x1(%eax),%edx
  8011ef:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8011f2:	89 c2                	mov    %eax,%edx
  8011f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f7:	01 d0                	add    %edx,%eax
  8011f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011fc:	88 10                	mov    %dl,(%eax)
  8011fe:	eb 5b                	jmp    80125b <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  801200:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801204:	75 1f                	jne    801225 <atomic_readline+0xcb>
  801206:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80120a:	7e 19                	jle    801225 <atomic_readline+0xcb>
			if (echoing)
  80120c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801210:	74 0e                	je     801220 <atomic_readline+0xc6>
				cputchar(c);
  801212:	83 ec 0c             	sub    $0xc,%esp
  801215:	ff 75 ec             	pushl  -0x14(%ebp)
  801218:	e8 2d f3 ff ff       	call   80054a <cputchar>
  80121d:	83 c4 10             	add    $0x10,%esp
			i--;
  801220:	ff 4d f4             	decl   -0xc(%ebp)
  801223:	eb 36                	jmp    80125b <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  801225:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801229:	74 0a                	je     801235 <atomic_readline+0xdb>
  80122b:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80122f:	0f 85 60 ff ff ff    	jne    801195 <atomic_readline+0x3b>
			if (echoing)
  801235:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801239:	74 0e                	je     801249 <atomic_readline+0xef>
				cputchar(c);
  80123b:	83 ec 0c             	sub    $0xc,%esp
  80123e:	ff 75 ec             	pushl  -0x14(%ebp)
  801241:	e8 04 f3 ff ff       	call   80054a <cputchar>
  801246:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  801249:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80124c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124f:	01 d0                	add    %edx,%eax
  801251:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  801254:	e8 2a 0e 00 00       	call   802083 <sys_enable_interrupt>
			return;
  801259:	eb 05                	jmp    801260 <atomic_readline+0x106>
		}
	}
  80125b:	e9 35 ff ff ff       	jmp    801195 <atomic_readline+0x3b>
}
  801260:	c9                   	leave  
  801261:	c3                   	ret    

00801262 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801262:	55                   	push   %ebp
  801263:	89 e5                	mov    %esp,%ebp
  801265:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801268:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80126f:	eb 06                	jmp    801277 <strlen+0x15>
		n++;
  801271:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801274:	ff 45 08             	incl   0x8(%ebp)
  801277:	8b 45 08             	mov    0x8(%ebp),%eax
  80127a:	8a 00                	mov    (%eax),%al
  80127c:	84 c0                	test   %al,%al
  80127e:	75 f1                	jne    801271 <strlen+0xf>
		n++;
	return n;
  801280:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801283:	c9                   	leave  
  801284:	c3                   	ret    

00801285 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801285:	55                   	push   %ebp
  801286:	89 e5                	mov    %esp,%ebp
  801288:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80128b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801292:	eb 09                	jmp    80129d <strnlen+0x18>
		n++;
  801294:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801297:	ff 45 08             	incl   0x8(%ebp)
  80129a:	ff 4d 0c             	decl   0xc(%ebp)
  80129d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012a1:	74 09                	je     8012ac <strnlen+0x27>
  8012a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a6:	8a 00                	mov    (%eax),%al
  8012a8:	84 c0                	test   %al,%al
  8012aa:	75 e8                	jne    801294 <strnlen+0xf>
		n++;
	return n;
  8012ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012af:	c9                   	leave  
  8012b0:	c3                   	ret    

008012b1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8012b1:	55                   	push   %ebp
  8012b2:	89 e5                	mov    %esp,%ebp
  8012b4:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8012b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8012bd:	90                   	nop
  8012be:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c1:	8d 50 01             	lea    0x1(%eax),%edx
  8012c4:	89 55 08             	mov    %edx,0x8(%ebp)
  8012c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ca:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012cd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8012d0:	8a 12                	mov    (%edx),%dl
  8012d2:	88 10                	mov    %dl,(%eax)
  8012d4:	8a 00                	mov    (%eax),%al
  8012d6:	84 c0                	test   %al,%al
  8012d8:	75 e4                	jne    8012be <strcpy+0xd>
		/* do nothing */;
	return ret;
  8012da:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012dd:	c9                   	leave  
  8012de:	c3                   	ret    

008012df <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8012df:	55                   	push   %ebp
  8012e0:	89 e5                	mov    %esp,%ebp
  8012e2:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8012e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8012eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012f2:	eb 1f                	jmp    801313 <strncpy+0x34>
		*dst++ = *src;
  8012f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f7:	8d 50 01             	lea    0x1(%eax),%edx
  8012fa:	89 55 08             	mov    %edx,0x8(%ebp)
  8012fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801300:	8a 12                	mov    (%edx),%dl
  801302:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801304:	8b 45 0c             	mov    0xc(%ebp),%eax
  801307:	8a 00                	mov    (%eax),%al
  801309:	84 c0                	test   %al,%al
  80130b:	74 03                	je     801310 <strncpy+0x31>
			src++;
  80130d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801310:	ff 45 fc             	incl   -0x4(%ebp)
  801313:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801316:	3b 45 10             	cmp    0x10(%ebp),%eax
  801319:	72 d9                	jb     8012f4 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80131b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80131e:	c9                   	leave  
  80131f:	c3                   	ret    

00801320 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801320:	55                   	push   %ebp
  801321:	89 e5                	mov    %esp,%ebp
  801323:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801326:	8b 45 08             	mov    0x8(%ebp),%eax
  801329:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80132c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801330:	74 30                	je     801362 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801332:	eb 16                	jmp    80134a <strlcpy+0x2a>
			*dst++ = *src++;
  801334:	8b 45 08             	mov    0x8(%ebp),%eax
  801337:	8d 50 01             	lea    0x1(%eax),%edx
  80133a:	89 55 08             	mov    %edx,0x8(%ebp)
  80133d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801340:	8d 4a 01             	lea    0x1(%edx),%ecx
  801343:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801346:	8a 12                	mov    (%edx),%dl
  801348:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80134a:	ff 4d 10             	decl   0x10(%ebp)
  80134d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801351:	74 09                	je     80135c <strlcpy+0x3c>
  801353:	8b 45 0c             	mov    0xc(%ebp),%eax
  801356:	8a 00                	mov    (%eax),%al
  801358:	84 c0                	test   %al,%al
  80135a:	75 d8                	jne    801334 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80135c:	8b 45 08             	mov    0x8(%ebp),%eax
  80135f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801362:	8b 55 08             	mov    0x8(%ebp),%edx
  801365:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801368:	29 c2                	sub    %eax,%edx
  80136a:	89 d0                	mov    %edx,%eax
}
  80136c:	c9                   	leave  
  80136d:	c3                   	ret    

0080136e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80136e:	55                   	push   %ebp
  80136f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801371:	eb 06                	jmp    801379 <strcmp+0xb>
		p++, q++;
  801373:	ff 45 08             	incl   0x8(%ebp)
  801376:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801379:	8b 45 08             	mov    0x8(%ebp),%eax
  80137c:	8a 00                	mov    (%eax),%al
  80137e:	84 c0                	test   %al,%al
  801380:	74 0e                	je     801390 <strcmp+0x22>
  801382:	8b 45 08             	mov    0x8(%ebp),%eax
  801385:	8a 10                	mov    (%eax),%dl
  801387:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138a:	8a 00                	mov    (%eax),%al
  80138c:	38 c2                	cmp    %al,%dl
  80138e:	74 e3                	je     801373 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801390:	8b 45 08             	mov    0x8(%ebp),%eax
  801393:	8a 00                	mov    (%eax),%al
  801395:	0f b6 d0             	movzbl %al,%edx
  801398:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139b:	8a 00                	mov    (%eax),%al
  80139d:	0f b6 c0             	movzbl %al,%eax
  8013a0:	29 c2                	sub    %eax,%edx
  8013a2:	89 d0                	mov    %edx,%eax
}
  8013a4:	5d                   	pop    %ebp
  8013a5:	c3                   	ret    

008013a6 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8013a6:	55                   	push   %ebp
  8013a7:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8013a9:	eb 09                	jmp    8013b4 <strncmp+0xe>
		n--, p++, q++;
  8013ab:	ff 4d 10             	decl   0x10(%ebp)
  8013ae:	ff 45 08             	incl   0x8(%ebp)
  8013b1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8013b4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013b8:	74 17                	je     8013d1 <strncmp+0x2b>
  8013ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bd:	8a 00                	mov    (%eax),%al
  8013bf:	84 c0                	test   %al,%al
  8013c1:	74 0e                	je     8013d1 <strncmp+0x2b>
  8013c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c6:	8a 10                	mov    (%eax),%dl
  8013c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013cb:	8a 00                	mov    (%eax),%al
  8013cd:	38 c2                	cmp    %al,%dl
  8013cf:	74 da                	je     8013ab <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8013d1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013d5:	75 07                	jne    8013de <strncmp+0x38>
		return 0;
  8013d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8013dc:	eb 14                	jmp    8013f2 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8013de:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e1:	8a 00                	mov    (%eax),%al
  8013e3:	0f b6 d0             	movzbl %al,%edx
  8013e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e9:	8a 00                	mov    (%eax),%al
  8013eb:	0f b6 c0             	movzbl %al,%eax
  8013ee:	29 c2                	sub    %eax,%edx
  8013f0:	89 d0                	mov    %edx,%eax
}
  8013f2:	5d                   	pop    %ebp
  8013f3:	c3                   	ret    

008013f4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8013f4:	55                   	push   %ebp
  8013f5:	89 e5                	mov    %esp,%ebp
  8013f7:	83 ec 04             	sub    $0x4,%esp
  8013fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801400:	eb 12                	jmp    801414 <strchr+0x20>
		if (*s == c)
  801402:	8b 45 08             	mov    0x8(%ebp),%eax
  801405:	8a 00                	mov    (%eax),%al
  801407:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80140a:	75 05                	jne    801411 <strchr+0x1d>
			return (char *) s;
  80140c:	8b 45 08             	mov    0x8(%ebp),%eax
  80140f:	eb 11                	jmp    801422 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801411:	ff 45 08             	incl   0x8(%ebp)
  801414:	8b 45 08             	mov    0x8(%ebp),%eax
  801417:	8a 00                	mov    (%eax),%al
  801419:	84 c0                	test   %al,%al
  80141b:	75 e5                	jne    801402 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80141d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801422:	c9                   	leave  
  801423:	c3                   	ret    

00801424 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801424:	55                   	push   %ebp
  801425:	89 e5                	mov    %esp,%ebp
  801427:	83 ec 04             	sub    $0x4,%esp
  80142a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801430:	eb 0d                	jmp    80143f <strfind+0x1b>
		if (*s == c)
  801432:	8b 45 08             	mov    0x8(%ebp),%eax
  801435:	8a 00                	mov    (%eax),%al
  801437:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80143a:	74 0e                	je     80144a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80143c:	ff 45 08             	incl   0x8(%ebp)
  80143f:	8b 45 08             	mov    0x8(%ebp),%eax
  801442:	8a 00                	mov    (%eax),%al
  801444:	84 c0                	test   %al,%al
  801446:	75 ea                	jne    801432 <strfind+0xe>
  801448:	eb 01                	jmp    80144b <strfind+0x27>
		if (*s == c)
			break;
  80144a:	90                   	nop
	return (char *) s;
  80144b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80144e:	c9                   	leave  
  80144f:	c3                   	ret    

00801450 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801450:	55                   	push   %ebp
  801451:	89 e5                	mov    %esp,%ebp
  801453:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801456:	8b 45 08             	mov    0x8(%ebp),%eax
  801459:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80145c:	8b 45 10             	mov    0x10(%ebp),%eax
  80145f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801462:	eb 0e                	jmp    801472 <memset+0x22>
		*p++ = c;
  801464:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801467:	8d 50 01             	lea    0x1(%eax),%edx
  80146a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80146d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801470:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801472:	ff 4d f8             	decl   -0x8(%ebp)
  801475:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801479:	79 e9                	jns    801464 <memset+0x14>
		*p++ = c;

	return v;
  80147b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80147e:	c9                   	leave  
  80147f:	c3                   	ret    

00801480 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801480:	55                   	push   %ebp
  801481:	89 e5                	mov    %esp,%ebp
  801483:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801486:	8b 45 0c             	mov    0xc(%ebp),%eax
  801489:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80148c:	8b 45 08             	mov    0x8(%ebp),%eax
  80148f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801492:	eb 16                	jmp    8014aa <memcpy+0x2a>
		*d++ = *s++;
  801494:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801497:	8d 50 01             	lea    0x1(%eax),%edx
  80149a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80149d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014a0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014a3:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8014a6:	8a 12                	mov    (%edx),%dl
  8014a8:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8014aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ad:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014b0:	89 55 10             	mov    %edx,0x10(%ebp)
  8014b3:	85 c0                	test   %eax,%eax
  8014b5:	75 dd                	jne    801494 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8014b7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014ba:	c9                   	leave  
  8014bb:	c3                   	ret    

008014bc <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8014bc:	55                   	push   %ebp
  8014bd:	89 e5                	mov    %esp,%ebp
  8014bf:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8014ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014d1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8014d4:	73 50                	jae    801526 <memmove+0x6a>
  8014d6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014dc:	01 d0                	add    %edx,%eax
  8014de:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8014e1:	76 43                	jbe    801526 <memmove+0x6a>
		s += n;
  8014e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e6:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8014e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ec:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8014ef:	eb 10                	jmp    801501 <memmove+0x45>
			*--d = *--s;
  8014f1:	ff 4d f8             	decl   -0x8(%ebp)
  8014f4:	ff 4d fc             	decl   -0x4(%ebp)
  8014f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014fa:	8a 10                	mov    (%eax),%dl
  8014fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014ff:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801501:	8b 45 10             	mov    0x10(%ebp),%eax
  801504:	8d 50 ff             	lea    -0x1(%eax),%edx
  801507:	89 55 10             	mov    %edx,0x10(%ebp)
  80150a:	85 c0                	test   %eax,%eax
  80150c:	75 e3                	jne    8014f1 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80150e:	eb 23                	jmp    801533 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801510:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801513:	8d 50 01             	lea    0x1(%eax),%edx
  801516:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801519:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80151c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80151f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801522:	8a 12                	mov    (%edx),%dl
  801524:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801526:	8b 45 10             	mov    0x10(%ebp),%eax
  801529:	8d 50 ff             	lea    -0x1(%eax),%edx
  80152c:	89 55 10             	mov    %edx,0x10(%ebp)
  80152f:	85 c0                	test   %eax,%eax
  801531:	75 dd                	jne    801510 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801533:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801536:	c9                   	leave  
  801537:	c3                   	ret    

00801538 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801538:	55                   	push   %ebp
  801539:	89 e5                	mov    %esp,%ebp
  80153b:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80153e:	8b 45 08             	mov    0x8(%ebp),%eax
  801541:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801544:	8b 45 0c             	mov    0xc(%ebp),%eax
  801547:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80154a:	eb 2a                	jmp    801576 <memcmp+0x3e>
		if (*s1 != *s2)
  80154c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80154f:	8a 10                	mov    (%eax),%dl
  801551:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801554:	8a 00                	mov    (%eax),%al
  801556:	38 c2                	cmp    %al,%dl
  801558:	74 16                	je     801570 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80155a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80155d:	8a 00                	mov    (%eax),%al
  80155f:	0f b6 d0             	movzbl %al,%edx
  801562:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801565:	8a 00                	mov    (%eax),%al
  801567:	0f b6 c0             	movzbl %al,%eax
  80156a:	29 c2                	sub    %eax,%edx
  80156c:	89 d0                	mov    %edx,%eax
  80156e:	eb 18                	jmp    801588 <memcmp+0x50>
		s1++, s2++;
  801570:	ff 45 fc             	incl   -0x4(%ebp)
  801573:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801576:	8b 45 10             	mov    0x10(%ebp),%eax
  801579:	8d 50 ff             	lea    -0x1(%eax),%edx
  80157c:	89 55 10             	mov    %edx,0x10(%ebp)
  80157f:	85 c0                	test   %eax,%eax
  801581:	75 c9                	jne    80154c <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801583:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801588:	c9                   	leave  
  801589:	c3                   	ret    

0080158a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80158a:	55                   	push   %ebp
  80158b:	89 e5                	mov    %esp,%ebp
  80158d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801590:	8b 55 08             	mov    0x8(%ebp),%edx
  801593:	8b 45 10             	mov    0x10(%ebp),%eax
  801596:	01 d0                	add    %edx,%eax
  801598:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80159b:	eb 15                	jmp    8015b2 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80159d:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a0:	8a 00                	mov    (%eax),%al
  8015a2:	0f b6 d0             	movzbl %al,%edx
  8015a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a8:	0f b6 c0             	movzbl %al,%eax
  8015ab:	39 c2                	cmp    %eax,%edx
  8015ad:	74 0d                	je     8015bc <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015af:	ff 45 08             	incl   0x8(%ebp)
  8015b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8015b8:	72 e3                	jb     80159d <memfind+0x13>
  8015ba:	eb 01                	jmp    8015bd <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8015bc:	90                   	nop
	return (void *) s;
  8015bd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015c0:	c9                   	leave  
  8015c1:	c3                   	ret    

008015c2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015c2:	55                   	push   %ebp
  8015c3:	89 e5                	mov    %esp,%ebp
  8015c5:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8015c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8015cf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015d6:	eb 03                	jmp    8015db <strtol+0x19>
		s++;
  8015d8:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015db:	8b 45 08             	mov    0x8(%ebp),%eax
  8015de:	8a 00                	mov    (%eax),%al
  8015e0:	3c 20                	cmp    $0x20,%al
  8015e2:	74 f4                	je     8015d8 <strtol+0x16>
  8015e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e7:	8a 00                	mov    (%eax),%al
  8015e9:	3c 09                	cmp    $0x9,%al
  8015eb:	74 eb                	je     8015d8 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f0:	8a 00                	mov    (%eax),%al
  8015f2:	3c 2b                	cmp    $0x2b,%al
  8015f4:	75 05                	jne    8015fb <strtol+0x39>
		s++;
  8015f6:	ff 45 08             	incl   0x8(%ebp)
  8015f9:	eb 13                	jmp    80160e <strtol+0x4c>
	else if (*s == '-')
  8015fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fe:	8a 00                	mov    (%eax),%al
  801600:	3c 2d                	cmp    $0x2d,%al
  801602:	75 0a                	jne    80160e <strtol+0x4c>
		s++, neg = 1;
  801604:	ff 45 08             	incl   0x8(%ebp)
  801607:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80160e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801612:	74 06                	je     80161a <strtol+0x58>
  801614:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801618:	75 20                	jne    80163a <strtol+0x78>
  80161a:	8b 45 08             	mov    0x8(%ebp),%eax
  80161d:	8a 00                	mov    (%eax),%al
  80161f:	3c 30                	cmp    $0x30,%al
  801621:	75 17                	jne    80163a <strtol+0x78>
  801623:	8b 45 08             	mov    0x8(%ebp),%eax
  801626:	40                   	inc    %eax
  801627:	8a 00                	mov    (%eax),%al
  801629:	3c 78                	cmp    $0x78,%al
  80162b:	75 0d                	jne    80163a <strtol+0x78>
		s += 2, base = 16;
  80162d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801631:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801638:	eb 28                	jmp    801662 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80163a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80163e:	75 15                	jne    801655 <strtol+0x93>
  801640:	8b 45 08             	mov    0x8(%ebp),%eax
  801643:	8a 00                	mov    (%eax),%al
  801645:	3c 30                	cmp    $0x30,%al
  801647:	75 0c                	jne    801655 <strtol+0x93>
		s++, base = 8;
  801649:	ff 45 08             	incl   0x8(%ebp)
  80164c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801653:	eb 0d                	jmp    801662 <strtol+0xa0>
	else if (base == 0)
  801655:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801659:	75 07                	jne    801662 <strtol+0xa0>
		base = 10;
  80165b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801662:	8b 45 08             	mov    0x8(%ebp),%eax
  801665:	8a 00                	mov    (%eax),%al
  801667:	3c 2f                	cmp    $0x2f,%al
  801669:	7e 19                	jle    801684 <strtol+0xc2>
  80166b:	8b 45 08             	mov    0x8(%ebp),%eax
  80166e:	8a 00                	mov    (%eax),%al
  801670:	3c 39                	cmp    $0x39,%al
  801672:	7f 10                	jg     801684 <strtol+0xc2>
			dig = *s - '0';
  801674:	8b 45 08             	mov    0x8(%ebp),%eax
  801677:	8a 00                	mov    (%eax),%al
  801679:	0f be c0             	movsbl %al,%eax
  80167c:	83 e8 30             	sub    $0x30,%eax
  80167f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801682:	eb 42                	jmp    8016c6 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801684:	8b 45 08             	mov    0x8(%ebp),%eax
  801687:	8a 00                	mov    (%eax),%al
  801689:	3c 60                	cmp    $0x60,%al
  80168b:	7e 19                	jle    8016a6 <strtol+0xe4>
  80168d:	8b 45 08             	mov    0x8(%ebp),%eax
  801690:	8a 00                	mov    (%eax),%al
  801692:	3c 7a                	cmp    $0x7a,%al
  801694:	7f 10                	jg     8016a6 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801696:	8b 45 08             	mov    0x8(%ebp),%eax
  801699:	8a 00                	mov    (%eax),%al
  80169b:	0f be c0             	movsbl %al,%eax
  80169e:	83 e8 57             	sub    $0x57,%eax
  8016a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016a4:	eb 20                	jmp    8016c6 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8016a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a9:	8a 00                	mov    (%eax),%al
  8016ab:	3c 40                	cmp    $0x40,%al
  8016ad:	7e 39                	jle    8016e8 <strtol+0x126>
  8016af:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b2:	8a 00                	mov    (%eax),%al
  8016b4:	3c 5a                	cmp    $0x5a,%al
  8016b6:	7f 30                	jg     8016e8 <strtol+0x126>
			dig = *s - 'A' + 10;
  8016b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bb:	8a 00                	mov    (%eax),%al
  8016bd:	0f be c0             	movsbl %al,%eax
  8016c0:	83 e8 37             	sub    $0x37,%eax
  8016c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8016c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c9:	3b 45 10             	cmp    0x10(%ebp),%eax
  8016cc:	7d 19                	jge    8016e7 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8016ce:	ff 45 08             	incl   0x8(%ebp)
  8016d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016d4:	0f af 45 10          	imul   0x10(%ebp),%eax
  8016d8:	89 c2                	mov    %eax,%edx
  8016da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016dd:	01 d0                	add    %edx,%eax
  8016df:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8016e2:	e9 7b ff ff ff       	jmp    801662 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8016e7:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8016e8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016ec:	74 08                	je     8016f6 <strtol+0x134>
		*endptr = (char *) s;
  8016ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8016f4:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8016f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8016fa:	74 07                	je     801703 <strtol+0x141>
  8016fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016ff:	f7 d8                	neg    %eax
  801701:	eb 03                	jmp    801706 <strtol+0x144>
  801703:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801706:	c9                   	leave  
  801707:	c3                   	ret    

00801708 <ltostr>:

void
ltostr(long value, char *str)
{
  801708:	55                   	push   %ebp
  801709:	89 e5                	mov    %esp,%ebp
  80170b:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80170e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801715:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80171c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801720:	79 13                	jns    801735 <ltostr+0x2d>
	{
		neg = 1;
  801722:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801729:	8b 45 0c             	mov    0xc(%ebp),%eax
  80172c:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80172f:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801732:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801735:	8b 45 08             	mov    0x8(%ebp),%eax
  801738:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80173d:	99                   	cltd   
  80173e:	f7 f9                	idiv   %ecx
  801740:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801743:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801746:	8d 50 01             	lea    0x1(%eax),%edx
  801749:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80174c:	89 c2                	mov    %eax,%edx
  80174e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801751:	01 d0                	add    %edx,%eax
  801753:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801756:	83 c2 30             	add    $0x30,%edx
  801759:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80175b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80175e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801763:	f7 e9                	imul   %ecx
  801765:	c1 fa 02             	sar    $0x2,%edx
  801768:	89 c8                	mov    %ecx,%eax
  80176a:	c1 f8 1f             	sar    $0x1f,%eax
  80176d:	29 c2                	sub    %eax,%edx
  80176f:	89 d0                	mov    %edx,%eax
  801771:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801774:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801777:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80177c:	f7 e9                	imul   %ecx
  80177e:	c1 fa 02             	sar    $0x2,%edx
  801781:	89 c8                	mov    %ecx,%eax
  801783:	c1 f8 1f             	sar    $0x1f,%eax
  801786:	29 c2                	sub    %eax,%edx
  801788:	89 d0                	mov    %edx,%eax
  80178a:	c1 e0 02             	shl    $0x2,%eax
  80178d:	01 d0                	add    %edx,%eax
  80178f:	01 c0                	add    %eax,%eax
  801791:	29 c1                	sub    %eax,%ecx
  801793:	89 ca                	mov    %ecx,%edx
  801795:	85 d2                	test   %edx,%edx
  801797:	75 9c                	jne    801735 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801799:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8017a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017a3:	48                   	dec    %eax
  8017a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8017a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8017ab:	74 3d                	je     8017ea <ltostr+0xe2>
		start = 1 ;
  8017ad:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8017b4:	eb 34                	jmp    8017ea <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8017b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017bc:	01 d0                	add    %edx,%eax
  8017be:	8a 00                	mov    (%eax),%al
  8017c0:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8017c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c9:	01 c2                	add    %eax,%edx
  8017cb:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8017ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d1:	01 c8                	add    %ecx,%eax
  8017d3:	8a 00                	mov    (%eax),%al
  8017d5:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8017d7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017dd:	01 c2                	add    %eax,%edx
  8017df:	8a 45 eb             	mov    -0x15(%ebp),%al
  8017e2:	88 02                	mov    %al,(%edx)
		start++ ;
  8017e4:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8017e7:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8017ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ed:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8017f0:	7c c4                	jl     8017b6 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8017f2:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8017f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f8:	01 d0                	add    %edx,%eax
  8017fa:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8017fd:	90                   	nop
  8017fe:	c9                   	leave  
  8017ff:	c3                   	ret    

00801800 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
  801803:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801806:	ff 75 08             	pushl  0x8(%ebp)
  801809:	e8 54 fa ff ff       	call   801262 <strlen>
  80180e:	83 c4 04             	add    $0x4,%esp
  801811:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801814:	ff 75 0c             	pushl  0xc(%ebp)
  801817:	e8 46 fa ff ff       	call   801262 <strlen>
  80181c:	83 c4 04             	add    $0x4,%esp
  80181f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801822:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801829:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801830:	eb 17                	jmp    801849 <strcconcat+0x49>
		final[s] = str1[s] ;
  801832:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801835:	8b 45 10             	mov    0x10(%ebp),%eax
  801838:	01 c2                	add    %eax,%edx
  80183a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80183d:	8b 45 08             	mov    0x8(%ebp),%eax
  801840:	01 c8                	add    %ecx,%eax
  801842:	8a 00                	mov    (%eax),%al
  801844:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801846:	ff 45 fc             	incl   -0x4(%ebp)
  801849:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80184c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80184f:	7c e1                	jl     801832 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801851:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801858:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80185f:	eb 1f                	jmp    801880 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801861:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801864:	8d 50 01             	lea    0x1(%eax),%edx
  801867:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80186a:	89 c2                	mov    %eax,%edx
  80186c:	8b 45 10             	mov    0x10(%ebp),%eax
  80186f:	01 c2                	add    %eax,%edx
  801871:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801874:	8b 45 0c             	mov    0xc(%ebp),%eax
  801877:	01 c8                	add    %ecx,%eax
  801879:	8a 00                	mov    (%eax),%al
  80187b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80187d:	ff 45 f8             	incl   -0x8(%ebp)
  801880:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801883:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801886:	7c d9                	jl     801861 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801888:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80188b:	8b 45 10             	mov    0x10(%ebp),%eax
  80188e:	01 d0                	add    %edx,%eax
  801890:	c6 00 00             	movb   $0x0,(%eax)
}
  801893:	90                   	nop
  801894:	c9                   	leave  
  801895:	c3                   	ret    

00801896 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801899:	8b 45 14             	mov    0x14(%ebp),%eax
  80189c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8018a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8018a5:	8b 00                	mov    (%eax),%eax
  8018a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8018b1:	01 d0                	add    %edx,%eax
  8018b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018b9:	eb 0c                	jmp    8018c7 <strsplit+0x31>
			*string++ = 0;
  8018bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018be:	8d 50 01             	lea    0x1(%eax),%edx
  8018c1:	89 55 08             	mov    %edx,0x8(%ebp)
  8018c4:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ca:	8a 00                	mov    (%eax),%al
  8018cc:	84 c0                	test   %al,%al
  8018ce:	74 18                	je     8018e8 <strsplit+0x52>
  8018d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d3:	8a 00                	mov    (%eax),%al
  8018d5:	0f be c0             	movsbl %al,%eax
  8018d8:	50                   	push   %eax
  8018d9:	ff 75 0c             	pushl  0xc(%ebp)
  8018dc:	e8 13 fb ff ff       	call   8013f4 <strchr>
  8018e1:	83 c4 08             	add    $0x8,%esp
  8018e4:	85 c0                	test   %eax,%eax
  8018e6:	75 d3                	jne    8018bb <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8018e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018eb:	8a 00                	mov    (%eax),%al
  8018ed:	84 c0                	test   %al,%al
  8018ef:	74 5a                	je     80194b <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8018f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8018f4:	8b 00                	mov    (%eax),%eax
  8018f6:	83 f8 0f             	cmp    $0xf,%eax
  8018f9:	75 07                	jne    801902 <strsplit+0x6c>
		{
			return 0;
  8018fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801900:	eb 66                	jmp    801968 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801902:	8b 45 14             	mov    0x14(%ebp),%eax
  801905:	8b 00                	mov    (%eax),%eax
  801907:	8d 48 01             	lea    0x1(%eax),%ecx
  80190a:	8b 55 14             	mov    0x14(%ebp),%edx
  80190d:	89 0a                	mov    %ecx,(%edx)
  80190f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801916:	8b 45 10             	mov    0x10(%ebp),%eax
  801919:	01 c2                	add    %eax,%edx
  80191b:	8b 45 08             	mov    0x8(%ebp),%eax
  80191e:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801920:	eb 03                	jmp    801925 <strsplit+0x8f>
			string++;
  801922:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801925:	8b 45 08             	mov    0x8(%ebp),%eax
  801928:	8a 00                	mov    (%eax),%al
  80192a:	84 c0                	test   %al,%al
  80192c:	74 8b                	je     8018b9 <strsplit+0x23>
  80192e:	8b 45 08             	mov    0x8(%ebp),%eax
  801931:	8a 00                	mov    (%eax),%al
  801933:	0f be c0             	movsbl %al,%eax
  801936:	50                   	push   %eax
  801937:	ff 75 0c             	pushl  0xc(%ebp)
  80193a:	e8 b5 fa ff ff       	call   8013f4 <strchr>
  80193f:	83 c4 08             	add    $0x8,%esp
  801942:	85 c0                	test   %eax,%eax
  801944:	74 dc                	je     801922 <strsplit+0x8c>
			string++;
	}
  801946:	e9 6e ff ff ff       	jmp    8018b9 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80194b:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80194c:	8b 45 14             	mov    0x14(%ebp),%eax
  80194f:	8b 00                	mov    (%eax),%eax
  801951:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801958:	8b 45 10             	mov    0x10(%ebp),%eax
  80195b:	01 d0                	add    %edx,%eax
  80195d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801963:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801968:	c9                   	leave  
  801969:	c3                   	ret    

0080196a <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80196a:	55                   	push   %ebp
  80196b:	89 e5                	mov    %esp,%ebp
  80196d:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801970:	a1 04 50 80 00       	mov    0x805004,%eax
  801975:	85 c0                	test   %eax,%eax
  801977:	74 1f                	je     801998 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801979:	e8 1d 00 00 00       	call   80199b <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80197e:	83 ec 0c             	sub    $0xc,%esp
  801981:	68 84 40 80 00       	push   $0x804084
  801986:	e8 4f f0 ff ff       	call   8009da <cprintf>
  80198b:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80198e:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801995:	00 00 00 
	}
}
  801998:	90                   	nop
  801999:	c9                   	leave  
  80199a:	c3                   	ret    

0080199b <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80199b:	55                   	push   %ebp
  80199c:	89 e5                	mov    %esp,%ebp
  80199e:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  8019a1:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  8019a8:	00 00 00 
  8019ab:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  8019b2:	00 00 00 
  8019b5:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  8019bc:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  8019bf:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  8019c6:	00 00 00 
  8019c9:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  8019d0:	00 00 00 
  8019d3:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8019da:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  8019dd:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  8019e4:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  8019e7:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  8019ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019f1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8019f6:	2d 00 10 00 00       	sub    $0x1000,%eax
  8019fb:	a3 50 50 80 00       	mov    %eax,0x805050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  801a00:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801a07:	a1 20 51 80 00       	mov    0x805120,%eax
  801a0c:	c1 e0 04             	shl    $0x4,%eax
  801a0f:	89 c2                	mov    %eax,%edx
  801a11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a14:	01 d0                	add    %edx,%eax
  801a16:	48                   	dec    %eax
  801a17:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801a1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a1d:	ba 00 00 00 00       	mov    $0x0,%edx
  801a22:	f7 75 f0             	divl   -0x10(%ebp)
  801a25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a28:	29 d0                	sub    %edx,%eax
  801a2a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  801a2d:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801a34:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a37:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a3c:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a41:	83 ec 04             	sub    $0x4,%esp
  801a44:	6a 06                	push   $0x6
  801a46:	ff 75 e8             	pushl  -0x18(%ebp)
  801a49:	50                   	push   %eax
  801a4a:	e8 b0 05 00 00       	call   801fff <sys_allocate_chunk>
  801a4f:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801a52:	a1 20 51 80 00       	mov    0x805120,%eax
  801a57:	83 ec 0c             	sub    $0xc,%esp
  801a5a:	50                   	push   %eax
  801a5b:	e8 25 0c 00 00       	call   802685 <initialize_MemBlocksList>
  801a60:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  801a63:	a1 48 51 80 00       	mov    0x805148,%eax
  801a68:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  801a6b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801a6f:	75 14                	jne    801a85 <initialize_dyn_block_system+0xea>
  801a71:	83 ec 04             	sub    $0x4,%esp
  801a74:	68 a9 40 80 00       	push   $0x8040a9
  801a79:	6a 29                	push   $0x29
  801a7b:	68 c7 40 80 00       	push   $0x8040c7
  801a80:	e8 a1 ec ff ff       	call   800726 <_panic>
  801a85:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a88:	8b 00                	mov    (%eax),%eax
  801a8a:	85 c0                	test   %eax,%eax
  801a8c:	74 10                	je     801a9e <initialize_dyn_block_system+0x103>
  801a8e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a91:	8b 00                	mov    (%eax),%eax
  801a93:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a96:	8b 52 04             	mov    0x4(%edx),%edx
  801a99:	89 50 04             	mov    %edx,0x4(%eax)
  801a9c:	eb 0b                	jmp    801aa9 <initialize_dyn_block_system+0x10e>
  801a9e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801aa1:	8b 40 04             	mov    0x4(%eax),%eax
  801aa4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801aa9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801aac:	8b 40 04             	mov    0x4(%eax),%eax
  801aaf:	85 c0                	test   %eax,%eax
  801ab1:	74 0f                	je     801ac2 <initialize_dyn_block_system+0x127>
  801ab3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ab6:	8b 40 04             	mov    0x4(%eax),%eax
  801ab9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801abc:	8b 12                	mov    (%edx),%edx
  801abe:	89 10                	mov    %edx,(%eax)
  801ac0:	eb 0a                	jmp    801acc <initialize_dyn_block_system+0x131>
  801ac2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ac5:	8b 00                	mov    (%eax),%eax
  801ac7:	a3 48 51 80 00       	mov    %eax,0x805148
  801acc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801acf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ad5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ad8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801adf:	a1 54 51 80 00       	mov    0x805154,%eax
  801ae4:	48                   	dec    %eax
  801ae5:	a3 54 51 80 00       	mov    %eax,0x805154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  801aea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801aed:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  801af4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801af7:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  801afe:	83 ec 0c             	sub    $0xc,%esp
  801b01:	ff 75 e0             	pushl  -0x20(%ebp)
  801b04:	e8 b9 14 00 00       	call   802fc2 <insert_sorted_with_merge_freeList>
  801b09:	83 c4 10             	add    $0x10,%esp

}
  801b0c:	90                   	nop
  801b0d:	c9                   	leave  
  801b0e:	c3                   	ret    

00801b0f <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801b0f:	55                   	push   %ebp
  801b10:	89 e5                	mov    %esp,%ebp
  801b12:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b15:	e8 50 fe ff ff       	call   80196a <InitializeUHeap>
	if (size == 0) return NULL ;
  801b1a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b1e:	75 07                	jne    801b27 <malloc+0x18>
  801b20:	b8 00 00 00 00       	mov    $0x0,%eax
  801b25:	eb 68                	jmp    801b8f <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  801b27:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801b2e:	8b 55 08             	mov    0x8(%ebp),%edx
  801b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b34:	01 d0                	add    %edx,%eax
  801b36:	48                   	dec    %eax
  801b37:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b3d:	ba 00 00 00 00       	mov    $0x0,%edx
  801b42:	f7 75 f4             	divl   -0xc(%ebp)
  801b45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b48:	29 d0                	sub    %edx,%eax
  801b4a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  801b4d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801b54:	e8 74 08 00 00       	call   8023cd <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b59:	85 c0                	test   %eax,%eax
  801b5b:	74 2d                	je     801b8a <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  801b5d:	83 ec 0c             	sub    $0xc,%esp
  801b60:	ff 75 ec             	pushl  -0x14(%ebp)
  801b63:	e8 52 0e 00 00       	call   8029ba <alloc_block_FF>
  801b68:	83 c4 10             	add    $0x10,%esp
  801b6b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  801b6e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801b72:	74 16                	je     801b8a <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  801b74:	83 ec 0c             	sub    $0xc,%esp
  801b77:	ff 75 e8             	pushl  -0x18(%ebp)
  801b7a:	e8 3b 0c 00 00       	call   8027ba <insert_sorted_allocList>
  801b7f:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  801b82:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b85:	8b 40 08             	mov    0x8(%eax),%eax
  801b88:	eb 05                	jmp    801b8f <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  801b8a:	b8 00 00 00 00       	mov    $0x0,%eax

}
  801b8f:	c9                   	leave  
  801b90:	c3                   	ret    

00801b91 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801b91:	55                   	push   %ebp
  801b92:	89 e5                	mov    %esp,%ebp
  801b94:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  801b97:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9a:	83 ec 08             	sub    $0x8,%esp
  801b9d:	50                   	push   %eax
  801b9e:	68 40 50 80 00       	push   $0x805040
  801ba3:	e8 ba 0b 00 00       	call   802762 <find_block>
  801ba8:	83 c4 10             	add    $0x10,%esp
  801bab:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  801bae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb1:	8b 40 0c             	mov    0xc(%eax),%eax
  801bb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  801bb7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bbb:	0f 84 9f 00 00 00    	je     801c60 <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  801bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc4:	83 ec 08             	sub    $0x8,%esp
  801bc7:	ff 75 f0             	pushl  -0x10(%ebp)
  801bca:	50                   	push   %eax
  801bcb:	e8 f7 03 00 00       	call   801fc7 <sys_free_user_mem>
  801bd0:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  801bd3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bd7:	75 14                	jne    801bed <free+0x5c>
  801bd9:	83 ec 04             	sub    $0x4,%esp
  801bdc:	68 a9 40 80 00       	push   $0x8040a9
  801be1:	6a 6a                	push   $0x6a
  801be3:	68 c7 40 80 00       	push   $0x8040c7
  801be8:	e8 39 eb ff ff       	call   800726 <_panic>
  801bed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bf0:	8b 00                	mov    (%eax),%eax
  801bf2:	85 c0                	test   %eax,%eax
  801bf4:	74 10                	je     801c06 <free+0x75>
  801bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bf9:	8b 00                	mov    (%eax),%eax
  801bfb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bfe:	8b 52 04             	mov    0x4(%edx),%edx
  801c01:	89 50 04             	mov    %edx,0x4(%eax)
  801c04:	eb 0b                	jmp    801c11 <free+0x80>
  801c06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c09:	8b 40 04             	mov    0x4(%eax),%eax
  801c0c:	a3 44 50 80 00       	mov    %eax,0x805044
  801c11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c14:	8b 40 04             	mov    0x4(%eax),%eax
  801c17:	85 c0                	test   %eax,%eax
  801c19:	74 0f                	je     801c2a <free+0x99>
  801c1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c1e:	8b 40 04             	mov    0x4(%eax),%eax
  801c21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c24:	8b 12                	mov    (%edx),%edx
  801c26:	89 10                	mov    %edx,(%eax)
  801c28:	eb 0a                	jmp    801c34 <free+0xa3>
  801c2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c2d:	8b 00                	mov    (%eax),%eax
  801c2f:	a3 40 50 80 00       	mov    %eax,0x805040
  801c34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c37:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c40:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801c47:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801c4c:	48                   	dec    %eax
  801c4d:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(blk);
  801c52:	83 ec 0c             	sub    $0xc,%esp
  801c55:	ff 75 f4             	pushl  -0xc(%ebp)
  801c58:	e8 65 13 00 00       	call   802fc2 <insert_sorted_with_merge_freeList>
  801c5d:	83 c4 10             	add    $0x10,%esp
	}
}
  801c60:	90                   	nop
  801c61:	c9                   	leave  
  801c62:	c3                   	ret    

00801c63 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801c63:	55                   	push   %ebp
  801c64:	89 e5                	mov    %esp,%ebp
  801c66:	83 ec 28             	sub    $0x28,%esp
  801c69:	8b 45 10             	mov    0x10(%ebp),%eax
  801c6c:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c6f:	e8 f6 fc ff ff       	call   80196a <InitializeUHeap>
	if (size == 0) return NULL ;
  801c74:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c78:	75 0a                	jne    801c84 <smalloc+0x21>
  801c7a:	b8 00 00 00 00       	mov    $0x0,%eax
  801c7f:	e9 af 00 00 00       	jmp    801d33 <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  801c84:	e8 44 07 00 00       	call   8023cd <sys_isUHeapPlacementStrategyFIRSTFIT>
  801c89:	83 f8 01             	cmp    $0x1,%eax
  801c8c:	0f 85 9c 00 00 00    	jne    801d2e <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  801c92:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801c99:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c9f:	01 d0                	add    %edx,%eax
  801ca1:	48                   	dec    %eax
  801ca2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ca5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ca8:	ba 00 00 00 00       	mov    $0x0,%edx
  801cad:	f7 75 f4             	divl   -0xc(%ebp)
  801cb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cb3:	29 d0                	sub    %edx,%eax
  801cb5:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  801cb8:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  801cbf:	76 07                	jbe    801cc8 <smalloc+0x65>
			return NULL;
  801cc1:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc6:	eb 6b                	jmp    801d33 <smalloc+0xd0>
		blk =alloc_block_FF(size);
  801cc8:	83 ec 0c             	sub    $0xc,%esp
  801ccb:	ff 75 0c             	pushl  0xc(%ebp)
  801cce:	e8 e7 0c 00 00       	call   8029ba <alloc_block_FF>
  801cd3:	83 c4 10             	add    $0x10,%esp
  801cd6:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  801cd9:	83 ec 0c             	sub    $0xc,%esp
  801cdc:	ff 75 ec             	pushl  -0x14(%ebp)
  801cdf:	e8 d6 0a 00 00       	call   8027ba <insert_sorted_allocList>
  801ce4:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  801ce7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ceb:	75 07                	jne    801cf4 <smalloc+0x91>
		{
			return NULL;
  801ced:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf2:	eb 3f                	jmp    801d33 <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  801cf4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cf7:	8b 40 08             	mov    0x8(%eax),%eax
  801cfa:	89 c2                	mov    %eax,%edx
  801cfc:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801d00:	52                   	push   %edx
  801d01:	50                   	push   %eax
  801d02:	ff 75 0c             	pushl  0xc(%ebp)
  801d05:	ff 75 08             	pushl  0x8(%ebp)
  801d08:	e8 45 04 00 00       	call   802152 <sys_createSharedObject>
  801d0d:	83 c4 10             	add    $0x10,%esp
  801d10:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  801d13:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801d17:	74 06                	je     801d1f <smalloc+0xbc>
  801d19:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801d1d:	75 07                	jne    801d26 <smalloc+0xc3>
		{
			return NULL;
  801d1f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d24:	eb 0d                	jmp    801d33 <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  801d26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d29:	8b 40 08             	mov    0x8(%eax),%eax
  801d2c:	eb 05                	jmp    801d33 <smalloc+0xd0>
		}
	}
	else
		return NULL;
  801d2e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d33:	c9                   	leave  
  801d34:	c3                   	ret    

00801d35 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801d35:	55                   	push   %ebp
  801d36:	89 e5                	mov    %esp,%ebp
  801d38:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d3b:	e8 2a fc ff ff       	call   80196a <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801d40:	83 ec 08             	sub    $0x8,%esp
  801d43:	ff 75 0c             	pushl  0xc(%ebp)
  801d46:	ff 75 08             	pushl  0x8(%ebp)
  801d49:	e8 2e 04 00 00       	call   80217c <sys_getSizeOfSharedObject>
  801d4e:	83 c4 10             	add    $0x10,%esp
  801d51:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  801d54:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801d58:	75 0a                	jne    801d64 <sget+0x2f>
	{
		return NULL;
  801d5a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d5f:	e9 94 00 00 00       	jmp    801df8 <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801d64:	e8 64 06 00 00       	call   8023cd <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d69:	85 c0                	test   %eax,%eax
  801d6b:	0f 84 82 00 00 00    	je     801df3 <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  801d71:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  801d78:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801d7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d85:	01 d0                	add    %edx,%eax
  801d87:	48                   	dec    %eax
  801d88:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801d8b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d8e:	ba 00 00 00 00       	mov    $0x0,%edx
  801d93:	f7 75 ec             	divl   -0x14(%ebp)
  801d96:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d99:	29 d0                	sub    %edx,%eax
  801d9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  801d9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da1:	83 ec 0c             	sub    $0xc,%esp
  801da4:	50                   	push   %eax
  801da5:	e8 10 0c 00 00       	call   8029ba <alloc_block_FF>
  801daa:	83 c4 10             	add    $0x10,%esp
  801dad:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  801db0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801db4:	75 07                	jne    801dbd <sget+0x88>
		{
			return NULL;
  801db6:	b8 00 00 00 00       	mov    $0x0,%eax
  801dbb:	eb 3b                	jmp    801df8 <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  801dbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dc0:	8b 40 08             	mov    0x8(%eax),%eax
  801dc3:	83 ec 04             	sub    $0x4,%esp
  801dc6:	50                   	push   %eax
  801dc7:	ff 75 0c             	pushl  0xc(%ebp)
  801dca:	ff 75 08             	pushl  0x8(%ebp)
  801dcd:	e8 c7 03 00 00       	call   802199 <sys_getSharedObject>
  801dd2:	83 c4 10             	add    $0x10,%esp
  801dd5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  801dd8:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801ddc:	74 06                	je     801de4 <sget+0xaf>
  801dde:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  801de2:	75 07                	jne    801deb <sget+0xb6>
		{
			return NULL;
  801de4:	b8 00 00 00 00       	mov    $0x0,%eax
  801de9:	eb 0d                	jmp    801df8 <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  801deb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dee:	8b 40 08             	mov    0x8(%eax),%eax
  801df1:	eb 05                	jmp    801df8 <sget+0xc3>
		}
	}
	else
			return NULL;
  801df3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801df8:	c9                   	leave  
  801df9:	c3                   	ret    

00801dfa <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801dfa:	55                   	push   %ebp
  801dfb:	89 e5                	mov    %esp,%ebp
  801dfd:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e00:	e8 65 fb ff ff       	call   80196a <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801e05:	83 ec 04             	sub    $0x4,%esp
  801e08:	68 d4 40 80 00       	push   $0x8040d4
  801e0d:	68 e1 00 00 00       	push   $0xe1
  801e12:	68 c7 40 80 00       	push   $0x8040c7
  801e17:	e8 0a e9 ff ff       	call   800726 <_panic>

00801e1c <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801e1c:	55                   	push   %ebp
  801e1d:	89 e5                	mov    %esp,%ebp
  801e1f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801e22:	83 ec 04             	sub    $0x4,%esp
  801e25:	68 fc 40 80 00       	push   $0x8040fc
  801e2a:	68 f5 00 00 00       	push   $0xf5
  801e2f:	68 c7 40 80 00       	push   $0x8040c7
  801e34:	e8 ed e8 ff ff       	call   800726 <_panic>

00801e39 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801e39:	55                   	push   %ebp
  801e3a:	89 e5                	mov    %esp,%ebp
  801e3c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e3f:	83 ec 04             	sub    $0x4,%esp
  801e42:	68 20 41 80 00       	push   $0x804120
  801e47:	68 00 01 00 00       	push   $0x100
  801e4c:	68 c7 40 80 00       	push   $0x8040c7
  801e51:	e8 d0 e8 ff ff       	call   800726 <_panic>

00801e56 <shrink>:

}
void shrink(uint32 newSize)
{
  801e56:	55                   	push   %ebp
  801e57:	89 e5                	mov    %esp,%ebp
  801e59:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e5c:	83 ec 04             	sub    $0x4,%esp
  801e5f:	68 20 41 80 00       	push   $0x804120
  801e64:	68 05 01 00 00       	push   $0x105
  801e69:	68 c7 40 80 00       	push   $0x8040c7
  801e6e:	e8 b3 e8 ff ff       	call   800726 <_panic>

00801e73 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801e73:	55                   	push   %ebp
  801e74:	89 e5                	mov    %esp,%ebp
  801e76:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e79:	83 ec 04             	sub    $0x4,%esp
  801e7c:	68 20 41 80 00       	push   $0x804120
  801e81:	68 0a 01 00 00       	push   $0x10a
  801e86:	68 c7 40 80 00       	push   $0x8040c7
  801e8b:	e8 96 e8 ff ff       	call   800726 <_panic>

00801e90 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801e90:	55                   	push   %ebp
  801e91:	89 e5                	mov    %esp,%ebp
  801e93:	57                   	push   %edi
  801e94:	56                   	push   %esi
  801e95:	53                   	push   %ebx
  801e96:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801e99:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e9f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ea2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ea5:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ea8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801eab:	cd 30                	int    $0x30
  801ead:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801eb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801eb3:	83 c4 10             	add    $0x10,%esp
  801eb6:	5b                   	pop    %ebx
  801eb7:	5e                   	pop    %esi
  801eb8:	5f                   	pop    %edi
  801eb9:	5d                   	pop    %ebp
  801eba:	c3                   	ret    

00801ebb <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801ebb:	55                   	push   %ebp
  801ebc:	89 e5                	mov    %esp,%ebp
  801ebe:	83 ec 04             	sub    $0x4,%esp
  801ec1:	8b 45 10             	mov    0x10(%ebp),%eax
  801ec4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801ec7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	52                   	push   %edx
  801ed3:	ff 75 0c             	pushl  0xc(%ebp)
  801ed6:	50                   	push   %eax
  801ed7:	6a 00                	push   $0x0
  801ed9:	e8 b2 ff ff ff       	call   801e90 <syscall>
  801ede:	83 c4 18             	add    $0x18,%esp
}
  801ee1:	90                   	nop
  801ee2:	c9                   	leave  
  801ee3:	c3                   	ret    

00801ee4 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ee4:	55                   	push   %ebp
  801ee5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 00                	push   $0x0
  801eef:	6a 00                	push   $0x0
  801ef1:	6a 01                	push   $0x1
  801ef3:	e8 98 ff ff ff       	call   801e90 <syscall>
  801ef8:	83 c4 18             	add    $0x18,%esp
}
  801efb:	c9                   	leave  
  801efc:	c3                   	ret    

00801efd <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801efd:	55                   	push   %ebp
  801efe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801f00:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f03:	8b 45 08             	mov    0x8(%ebp),%eax
  801f06:	6a 00                	push   $0x0
  801f08:	6a 00                	push   $0x0
  801f0a:	6a 00                	push   $0x0
  801f0c:	52                   	push   %edx
  801f0d:	50                   	push   %eax
  801f0e:	6a 05                	push   $0x5
  801f10:	e8 7b ff ff ff       	call   801e90 <syscall>
  801f15:	83 c4 18             	add    $0x18,%esp
}
  801f18:	c9                   	leave  
  801f19:	c3                   	ret    

00801f1a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f1a:	55                   	push   %ebp
  801f1b:	89 e5                	mov    %esp,%ebp
  801f1d:	56                   	push   %esi
  801f1e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801f1f:	8b 75 18             	mov    0x18(%ebp),%esi
  801f22:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f25:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f28:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2e:	56                   	push   %esi
  801f2f:	53                   	push   %ebx
  801f30:	51                   	push   %ecx
  801f31:	52                   	push   %edx
  801f32:	50                   	push   %eax
  801f33:	6a 06                	push   $0x6
  801f35:	e8 56 ff ff ff       	call   801e90 <syscall>
  801f3a:	83 c4 18             	add    $0x18,%esp
}
  801f3d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f40:	5b                   	pop    %ebx
  801f41:	5e                   	pop    %esi
  801f42:	5d                   	pop    %ebp
  801f43:	c3                   	ret    

00801f44 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801f44:	55                   	push   %ebp
  801f45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801f47:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4d:	6a 00                	push   $0x0
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 00                	push   $0x0
  801f53:	52                   	push   %edx
  801f54:	50                   	push   %eax
  801f55:	6a 07                	push   $0x7
  801f57:	e8 34 ff ff ff       	call   801e90 <syscall>
  801f5c:	83 c4 18             	add    $0x18,%esp
}
  801f5f:	c9                   	leave  
  801f60:	c3                   	ret    

00801f61 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801f61:	55                   	push   %ebp
  801f62:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801f64:	6a 00                	push   $0x0
  801f66:	6a 00                	push   $0x0
  801f68:	6a 00                	push   $0x0
  801f6a:	ff 75 0c             	pushl  0xc(%ebp)
  801f6d:	ff 75 08             	pushl  0x8(%ebp)
  801f70:	6a 08                	push   $0x8
  801f72:	e8 19 ff ff ff       	call   801e90 <syscall>
  801f77:	83 c4 18             	add    $0x18,%esp
}
  801f7a:	c9                   	leave  
  801f7b:	c3                   	ret    

00801f7c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801f7c:	55                   	push   %ebp
  801f7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 00                	push   $0x0
  801f83:	6a 00                	push   $0x0
  801f85:	6a 00                	push   $0x0
  801f87:	6a 00                	push   $0x0
  801f89:	6a 09                	push   $0x9
  801f8b:	e8 00 ff ff ff       	call   801e90 <syscall>
  801f90:	83 c4 18             	add    $0x18,%esp
}
  801f93:	c9                   	leave  
  801f94:	c3                   	ret    

00801f95 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801f95:	55                   	push   %ebp
  801f96:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801f98:	6a 00                	push   $0x0
  801f9a:	6a 00                	push   $0x0
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 00                	push   $0x0
  801fa0:	6a 00                	push   $0x0
  801fa2:	6a 0a                	push   $0xa
  801fa4:	e8 e7 fe ff ff       	call   801e90 <syscall>
  801fa9:	83 c4 18             	add    $0x18,%esp
}
  801fac:	c9                   	leave  
  801fad:	c3                   	ret    

00801fae <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801fae:	55                   	push   %ebp
  801faf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801fb1:	6a 00                	push   $0x0
  801fb3:	6a 00                	push   $0x0
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 00                	push   $0x0
  801fb9:	6a 00                	push   $0x0
  801fbb:	6a 0b                	push   $0xb
  801fbd:	e8 ce fe ff ff       	call   801e90 <syscall>
  801fc2:	83 c4 18             	add    $0x18,%esp
}
  801fc5:	c9                   	leave  
  801fc6:	c3                   	ret    

00801fc7 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801fc7:	55                   	push   %ebp
  801fc8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801fca:	6a 00                	push   $0x0
  801fcc:	6a 00                	push   $0x0
  801fce:	6a 00                	push   $0x0
  801fd0:	ff 75 0c             	pushl  0xc(%ebp)
  801fd3:	ff 75 08             	pushl  0x8(%ebp)
  801fd6:	6a 0f                	push   $0xf
  801fd8:	e8 b3 fe ff ff       	call   801e90 <syscall>
  801fdd:	83 c4 18             	add    $0x18,%esp
	return;
  801fe0:	90                   	nop
}
  801fe1:	c9                   	leave  
  801fe2:	c3                   	ret    

00801fe3 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801fe3:	55                   	push   %ebp
  801fe4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801fe6:	6a 00                	push   $0x0
  801fe8:	6a 00                	push   $0x0
  801fea:	6a 00                	push   $0x0
  801fec:	ff 75 0c             	pushl  0xc(%ebp)
  801fef:	ff 75 08             	pushl  0x8(%ebp)
  801ff2:	6a 10                	push   $0x10
  801ff4:	e8 97 fe ff ff       	call   801e90 <syscall>
  801ff9:	83 c4 18             	add    $0x18,%esp
	return ;
  801ffc:	90                   	nop
}
  801ffd:	c9                   	leave  
  801ffe:	c3                   	ret    

00801fff <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801fff:	55                   	push   %ebp
  802000:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802002:	6a 00                	push   $0x0
  802004:	6a 00                	push   $0x0
  802006:	ff 75 10             	pushl  0x10(%ebp)
  802009:	ff 75 0c             	pushl  0xc(%ebp)
  80200c:	ff 75 08             	pushl  0x8(%ebp)
  80200f:	6a 11                	push   $0x11
  802011:	e8 7a fe ff ff       	call   801e90 <syscall>
  802016:	83 c4 18             	add    $0x18,%esp
	return ;
  802019:	90                   	nop
}
  80201a:	c9                   	leave  
  80201b:	c3                   	ret    

0080201c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80201c:	55                   	push   %ebp
  80201d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80201f:	6a 00                	push   $0x0
  802021:	6a 00                	push   $0x0
  802023:	6a 00                	push   $0x0
  802025:	6a 00                	push   $0x0
  802027:	6a 00                	push   $0x0
  802029:	6a 0c                	push   $0xc
  80202b:	e8 60 fe ff ff       	call   801e90 <syscall>
  802030:	83 c4 18             	add    $0x18,%esp
}
  802033:	c9                   	leave  
  802034:	c3                   	ret    

00802035 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802035:	55                   	push   %ebp
  802036:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802038:	6a 00                	push   $0x0
  80203a:	6a 00                	push   $0x0
  80203c:	6a 00                	push   $0x0
  80203e:	6a 00                	push   $0x0
  802040:	ff 75 08             	pushl  0x8(%ebp)
  802043:	6a 0d                	push   $0xd
  802045:	e8 46 fe ff ff       	call   801e90 <syscall>
  80204a:	83 c4 18             	add    $0x18,%esp
}
  80204d:	c9                   	leave  
  80204e:	c3                   	ret    

0080204f <sys_scarce_memory>:

void sys_scarce_memory()
{
  80204f:	55                   	push   %ebp
  802050:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802052:	6a 00                	push   $0x0
  802054:	6a 00                	push   $0x0
  802056:	6a 00                	push   $0x0
  802058:	6a 00                	push   $0x0
  80205a:	6a 00                	push   $0x0
  80205c:	6a 0e                	push   $0xe
  80205e:	e8 2d fe ff ff       	call   801e90 <syscall>
  802063:	83 c4 18             	add    $0x18,%esp
}
  802066:	90                   	nop
  802067:	c9                   	leave  
  802068:	c3                   	ret    

00802069 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802069:	55                   	push   %ebp
  80206a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80206c:	6a 00                	push   $0x0
  80206e:	6a 00                	push   $0x0
  802070:	6a 00                	push   $0x0
  802072:	6a 00                	push   $0x0
  802074:	6a 00                	push   $0x0
  802076:	6a 13                	push   $0x13
  802078:	e8 13 fe ff ff       	call   801e90 <syscall>
  80207d:	83 c4 18             	add    $0x18,%esp
}
  802080:	90                   	nop
  802081:	c9                   	leave  
  802082:	c3                   	ret    

00802083 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802083:	55                   	push   %ebp
  802084:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802086:	6a 00                	push   $0x0
  802088:	6a 00                	push   $0x0
  80208a:	6a 00                	push   $0x0
  80208c:	6a 00                	push   $0x0
  80208e:	6a 00                	push   $0x0
  802090:	6a 14                	push   $0x14
  802092:	e8 f9 fd ff ff       	call   801e90 <syscall>
  802097:	83 c4 18             	add    $0x18,%esp
}
  80209a:	90                   	nop
  80209b:	c9                   	leave  
  80209c:	c3                   	ret    

0080209d <sys_cputc>:


void
sys_cputc(const char c)
{
  80209d:	55                   	push   %ebp
  80209e:	89 e5                	mov    %esp,%ebp
  8020a0:	83 ec 04             	sub    $0x4,%esp
  8020a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8020a9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020ad:	6a 00                	push   $0x0
  8020af:	6a 00                	push   $0x0
  8020b1:	6a 00                	push   $0x0
  8020b3:	6a 00                	push   $0x0
  8020b5:	50                   	push   %eax
  8020b6:	6a 15                	push   $0x15
  8020b8:	e8 d3 fd ff ff       	call   801e90 <syscall>
  8020bd:	83 c4 18             	add    $0x18,%esp
}
  8020c0:	90                   	nop
  8020c1:	c9                   	leave  
  8020c2:	c3                   	ret    

008020c3 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8020c3:	55                   	push   %ebp
  8020c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8020c6:	6a 00                	push   $0x0
  8020c8:	6a 00                	push   $0x0
  8020ca:	6a 00                	push   $0x0
  8020cc:	6a 00                	push   $0x0
  8020ce:	6a 00                	push   $0x0
  8020d0:	6a 16                	push   $0x16
  8020d2:	e8 b9 fd ff ff       	call   801e90 <syscall>
  8020d7:	83 c4 18             	add    $0x18,%esp
}
  8020da:	90                   	nop
  8020db:	c9                   	leave  
  8020dc:	c3                   	ret    

008020dd <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8020dd:	55                   	push   %ebp
  8020de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8020e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e3:	6a 00                	push   $0x0
  8020e5:	6a 00                	push   $0x0
  8020e7:	6a 00                	push   $0x0
  8020e9:	ff 75 0c             	pushl  0xc(%ebp)
  8020ec:	50                   	push   %eax
  8020ed:	6a 17                	push   $0x17
  8020ef:	e8 9c fd ff ff       	call   801e90 <syscall>
  8020f4:	83 c4 18             	add    $0x18,%esp
}
  8020f7:	c9                   	leave  
  8020f8:	c3                   	ret    

008020f9 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8020f9:	55                   	push   %ebp
  8020fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8020fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802102:	6a 00                	push   $0x0
  802104:	6a 00                	push   $0x0
  802106:	6a 00                	push   $0x0
  802108:	52                   	push   %edx
  802109:	50                   	push   %eax
  80210a:	6a 1a                	push   $0x1a
  80210c:	e8 7f fd ff ff       	call   801e90 <syscall>
  802111:	83 c4 18             	add    $0x18,%esp
}
  802114:	c9                   	leave  
  802115:	c3                   	ret    

00802116 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802116:	55                   	push   %ebp
  802117:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802119:	8b 55 0c             	mov    0xc(%ebp),%edx
  80211c:	8b 45 08             	mov    0x8(%ebp),%eax
  80211f:	6a 00                	push   $0x0
  802121:	6a 00                	push   $0x0
  802123:	6a 00                	push   $0x0
  802125:	52                   	push   %edx
  802126:	50                   	push   %eax
  802127:	6a 18                	push   $0x18
  802129:	e8 62 fd ff ff       	call   801e90 <syscall>
  80212e:	83 c4 18             	add    $0x18,%esp
}
  802131:	90                   	nop
  802132:	c9                   	leave  
  802133:	c3                   	ret    

00802134 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802134:	55                   	push   %ebp
  802135:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802137:	8b 55 0c             	mov    0xc(%ebp),%edx
  80213a:	8b 45 08             	mov    0x8(%ebp),%eax
  80213d:	6a 00                	push   $0x0
  80213f:	6a 00                	push   $0x0
  802141:	6a 00                	push   $0x0
  802143:	52                   	push   %edx
  802144:	50                   	push   %eax
  802145:	6a 19                	push   $0x19
  802147:	e8 44 fd ff ff       	call   801e90 <syscall>
  80214c:	83 c4 18             	add    $0x18,%esp
}
  80214f:	90                   	nop
  802150:	c9                   	leave  
  802151:	c3                   	ret    

00802152 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802152:	55                   	push   %ebp
  802153:	89 e5                	mov    %esp,%ebp
  802155:	83 ec 04             	sub    $0x4,%esp
  802158:	8b 45 10             	mov    0x10(%ebp),%eax
  80215b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80215e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802161:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802165:	8b 45 08             	mov    0x8(%ebp),%eax
  802168:	6a 00                	push   $0x0
  80216a:	51                   	push   %ecx
  80216b:	52                   	push   %edx
  80216c:	ff 75 0c             	pushl  0xc(%ebp)
  80216f:	50                   	push   %eax
  802170:	6a 1b                	push   $0x1b
  802172:	e8 19 fd ff ff       	call   801e90 <syscall>
  802177:	83 c4 18             	add    $0x18,%esp
}
  80217a:	c9                   	leave  
  80217b:	c3                   	ret    

0080217c <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80217c:	55                   	push   %ebp
  80217d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80217f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802182:	8b 45 08             	mov    0x8(%ebp),%eax
  802185:	6a 00                	push   $0x0
  802187:	6a 00                	push   $0x0
  802189:	6a 00                	push   $0x0
  80218b:	52                   	push   %edx
  80218c:	50                   	push   %eax
  80218d:	6a 1c                	push   $0x1c
  80218f:	e8 fc fc ff ff       	call   801e90 <syscall>
  802194:	83 c4 18             	add    $0x18,%esp
}
  802197:	c9                   	leave  
  802198:	c3                   	ret    

00802199 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802199:	55                   	push   %ebp
  80219a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80219c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80219f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a5:	6a 00                	push   $0x0
  8021a7:	6a 00                	push   $0x0
  8021a9:	51                   	push   %ecx
  8021aa:	52                   	push   %edx
  8021ab:	50                   	push   %eax
  8021ac:	6a 1d                	push   $0x1d
  8021ae:	e8 dd fc ff ff       	call   801e90 <syscall>
  8021b3:	83 c4 18             	add    $0x18,%esp
}
  8021b6:	c9                   	leave  
  8021b7:	c3                   	ret    

008021b8 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8021b8:	55                   	push   %ebp
  8021b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8021bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021be:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c1:	6a 00                	push   $0x0
  8021c3:	6a 00                	push   $0x0
  8021c5:	6a 00                	push   $0x0
  8021c7:	52                   	push   %edx
  8021c8:	50                   	push   %eax
  8021c9:	6a 1e                	push   $0x1e
  8021cb:	e8 c0 fc ff ff       	call   801e90 <syscall>
  8021d0:	83 c4 18             	add    $0x18,%esp
}
  8021d3:	c9                   	leave  
  8021d4:	c3                   	ret    

008021d5 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8021d5:	55                   	push   %ebp
  8021d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8021d8:	6a 00                	push   $0x0
  8021da:	6a 00                	push   $0x0
  8021dc:	6a 00                	push   $0x0
  8021de:	6a 00                	push   $0x0
  8021e0:	6a 00                	push   $0x0
  8021e2:	6a 1f                	push   $0x1f
  8021e4:	e8 a7 fc ff ff       	call   801e90 <syscall>
  8021e9:	83 c4 18             	add    $0x18,%esp
}
  8021ec:	c9                   	leave  
  8021ed:	c3                   	ret    

008021ee <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8021ee:	55                   	push   %ebp
  8021ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8021f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f4:	6a 00                	push   $0x0
  8021f6:	ff 75 14             	pushl  0x14(%ebp)
  8021f9:	ff 75 10             	pushl  0x10(%ebp)
  8021fc:	ff 75 0c             	pushl  0xc(%ebp)
  8021ff:	50                   	push   %eax
  802200:	6a 20                	push   $0x20
  802202:	e8 89 fc ff ff       	call   801e90 <syscall>
  802207:	83 c4 18             	add    $0x18,%esp
}
  80220a:	c9                   	leave  
  80220b:	c3                   	ret    

0080220c <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80220c:	55                   	push   %ebp
  80220d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80220f:	8b 45 08             	mov    0x8(%ebp),%eax
  802212:	6a 00                	push   $0x0
  802214:	6a 00                	push   $0x0
  802216:	6a 00                	push   $0x0
  802218:	6a 00                	push   $0x0
  80221a:	50                   	push   %eax
  80221b:	6a 21                	push   $0x21
  80221d:	e8 6e fc ff ff       	call   801e90 <syscall>
  802222:	83 c4 18             	add    $0x18,%esp
}
  802225:	90                   	nop
  802226:	c9                   	leave  
  802227:	c3                   	ret    

00802228 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802228:	55                   	push   %ebp
  802229:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80222b:	8b 45 08             	mov    0x8(%ebp),%eax
  80222e:	6a 00                	push   $0x0
  802230:	6a 00                	push   $0x0
  802232:	6a 00                	push   $0x0
  802234:	6a 00                	push   $0x0
  802236:	50                   	push   %eax
  802237:	6a 22                	push   $0x22
  802239:	e8 52 fc ff ff       	call   801e90 <syscall>
  80223e:	83 c4 18             	add    $0x18,%esp
}
  802241:	c9                   	leave  
  802242:	c3                   	ret    

00802243 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802243:	55                   	push   %ebp
  802244:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802246:	6a 00                	push   $0x0
  802248:	6a 00                	push   $0x0
  80224a:	6a 00                	push   $0x0
  80224c:	6a 00                	push   $0x0
  80224e:	6a 00                	push   $0x0
  802250:	6a 02                	push   $0x2
  802252:	e8 39 fc ff ff       	call   801e90 <syscall>
  802257:	83 c4 18             	add    $0x18,%esp
}
  80225a:	c9                   	leave  
  80225b:	c3                   	ret    

0080225c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80225c:	55                   	push   %ebp
  80225d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80225f:	6a 00                	push   $0x0
  802261:	6a 00                	push   $0x0
  802263:	6a 00                	push   $0x0
  802265:	6a 00                	push   $0x0
  802267:	6a 00                	push   $0x0
  802269:	6a 03                	push   $0x3
  80226b:	e8 20 fc ff ff       	call   801e90 <syscall>
  802270:	83 c4 18             	add    $0x18,%esp
}
  802273:	c9                   	leave  
  802274:	c3                   	ret    

00802275 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802275:	55                   	push   %ebp
  802276:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802278:	6a 00                	push   $0x0
  80227a:	6a 00                	push   $0x0
  80227c:	6a 00                	push   $0x0
  80227e:	6a 00                	push   $0x0
  802280:	6a 00                	push   $0x0
  802282:	6a 04                	push   $0x4
  802284:	e8 07 fc ff ff       	call   801e90 <syscall>
  802289:	83 c4 18             	add    $0x18,%esp
}
  80228c:	c9                   	leave  
  80228d:	c3                   	ret    

0080228e <sys_exit_env>:


void sys_exit_env(void)
{
  80228e:	55                   	push   %ebp
  80228f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802291:	6a 00                	push   $0x0
  802293:	6a 00                	push   $0x0
  802295:	6a 00                	push   $0x0
  802297:	6a 00                	push   $0x0
  802299:	6a 00                	push   $0x0
  80229b:	6a 23                	push   $0x23
  80229d:	e8 ee fb ff ff       	call   801e90 <syscall>
  8022a2:	83 c4 18             	add    $0x18,%esp
}
  8022a5:	90                   	nop
  8022a6:	c9                   	leave  
  8022a7:	c3                   	ret    

008022a8 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8022a8:	55                   	push   %ebp
  8022a9:	89 e5                	mov    %esp,%ebp
  8022ab:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8022ae:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022b1:	8d 50 04             	lea    0x4(%eax),%edx
  8022b4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022b7:	6a 00                	push   $0x0
  8022b9:	6a 00                	push   $0x0
  8022bb:	6a 00                	push   $0x0
  8022bd:	52                   	push   %edx
  8022be:	50                   	push   %eax
  8022bf:	6a 24                	push   $0x24
  8022c1:	e8 ca fb ff ff       	call   801e90 <syscall>
  8022c6:	83 c4 18             	add    $0x18,%esp
	return result;
  8022c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022cf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022d2:	89 01                	mov    %eax,(%ecx)
  8022d4:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8022d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022da:	c9                   	leave  
  8022db:	c2 04 00             	ret    $0x4

008022de <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8022de:	55                   	push   %ebp
  8022df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8022e1:	6a 00                	push   $0x0
  8022e3:	6a 00                	push   $0x0
  8022e5:	ff 75 10             	pushl  0x10(%ebp)
  8022e8:	ff 75 0c             	pushl  0xc(%ebp)
  8022eb:	ff 75 08             	pushl  0x8(%ebp)
  8022ee:	6a 12                	push   $0x12
  8022f0:	e8 9b fb ff ff       	call   801e90 <syscall>
  8022f5:	83 c4 18             	add    $0x18,%esp
	return ;
  8022f8:	90                   	nop
}
  8022f9:	c9                   	leave  
  8022fa:	c3                   	ret    

008022fb <sys_rcr2>:
uint32 sys_rcr2()
{
  8022fb:	55                   	push   %ebp
  8022fc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8022fe:	6a 00                	push   $0x0
  802300:	6a 00                	push   $0x0
  802302:	6a 00                	push   $0x0
  802304:	6a 00                	push   $0x0
  802306:	6a 00                	push   $0x0
  802308:	6a 25                	push   $0x25
  80230a:	e8 81 fb ff ff       	call   801e90 <syscall>
  80230f:	83 c4 18             	add    $0x18,%esp
}
  802312:	c9                   	leave  
  802313:	c3                   	ret    

00802314 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802314:	55                   	push   %ebp
  802315:	89 e5                	mov    %esp,%ebp
  802317:	83 ec 04             	sub    $0x4,%esp
  80231a:	8b 45 08             	mov    0x8(%ebp),%eax
  80231d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802320:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802324:	6a 00                	push   $0x0
  802326:	6a 00                	push   $0x0
  802328:	6a 00                	push   $0x0
  80232a:	6a 00                	push   $0x0
  80232c:	50                   	push   %eax
  80232d:	6a 26                	push   $0x26
  80232f:	e8 5c fb ff ff       	call   801e90 <syscall>
  802334:	83 c4 18             	add    $0x18,%esp
	return ;
  802337:	90                   	nop
}
  802338:	c9                   	leave  
  802339:	c3                   	ret    

0080233a <rsttst>:
void rsttst()
{
  80233a:	55                   	push   %ebp
  80233b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80233d:	6a 00                	push   $0x0
  80233f:	6a 00                	push   $0x0
  802341:	6a 00                	push   $0x0
  802343:	6a 00                	push   $0x0
  802345:	6a 00                	push   $0x0
  802347:	6a 28                	push   $0x28
  802349:	e8 42 fb ff ff       	call   801e90 <syscall>
  80234e:	83 c4 18             	add    $0x18,%esp
	return ;
  802351:	90                   	nop
}
  802352:	c9                   	leave  
  802353:	c3                   	ret    

00802354 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802354:	55                   	push   %ebp
  802355:	89 e5                	mov    %esp,%ebp
  802357:	83 ec 04             	sub    $0x4,%esp
  80235a:	8b 45 14             	mov    0x14(%ebp),%eax
  80235d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802360:	8b 55 18             	mov    0x18(%ebp),%edx
  802363:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802367:	52                   	push   %edx
  802368:	50                   	push   %eax
  802369:	ff 75 10             	pushl  0x10(%ebp)
  80236c:	ff 75 0c             	pushl  0xc(%ebp)
  80236f:	ff 75 08             	pushl  0x8(%ebp)
  802372:	6a 27                	push   $0x27
  802374:	e8 17 fb ff ff       	call   801e90 <syscall>
  802379:	83 c4 18             	add    $0x18,%esp
	return ;
  80237c:	90                   	nop
}
  80237d:	c9                   	leave  
  80237e:	c3                   	ret    

0080237f <chktst>:
void chktst(uint32 n)
{
  80237f:	55                   	push   %ebp
  802380:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802382:	6a 00                	push   $0x0
  802384:	6a 00                	push   $0x0
  802386:	6a 00                	push   $0x0
  802388:	6a 00                	push   $0x0
  80238a:	ff 75 08             	pushl  0x8(%ebp)
  80238d:	6a 29                	push   $0x29
  80238f:	e8 fc fa ff ff       	call   801e90 <syscall>
  802394:	83 c4 18             	add    $0x18,%esp
	return ;
  802397:	90                   	nop
}
  802398:	c9                   	leave  
  802399:	c3                   	ret    

0080239a <inctst>:

void inctst()
{
  80239a:	55                   	push   %ebp
  80239b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80239d:	6a 00                	push   $0x0
  80239f:	6a 00                	push   $0x0
  8023a1:	6a 00                	push   $0x0
  8023a3:	6a 00                	push   $0x0
  8023a5:	6a 00                	push   $0x0
  8023a7:	6a 2a                	push   $0x2a
  8023a9:	e8 e2 fa ff ff       	call   801e90 <syscall>
  8023ae:	83 c4 18             	add    $0x18,%esp
	return ;
  8023b1:	90                   	nop
}
  8023b2:	c9                   	leave  
  8023b3:	c3                   	ret    

008023b4 <gettst>:
uint32 gettst()
{
  8023b4:	55                   	push   %ebp
  8023b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8023b7:	6a 00                	push   $0x0
  8023b9:	6a 00                	push   $0x0
  8023bb:	6a 00                	push   $0x0
  8023bd:	6a 00                	push   $0x0
  8023bf:	6a 00                	push   $0x0
  8023c1:	6a 2b                	push   $0x2b
  8023c3:	e8 c8 fa ff ff       	call   801e90 <syscall>
  8023c8:	83 c4 18             	add    $0x18,%esp
}
  8023cb:	c9                   	leave  
  8023cc:	c3                   	ret    

008023cd <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8023cd:	55                   	push   %ebp
  8023ce:	89 e5                	mov    %esp,%ebp
  8023d0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023d3:	6a 00                	push   $0x0
  8023d5:	6a 00                	push   $0x0
  8023d7:	6a 00                	push   $0x0
  8023d9:	6a 00                	push   $0x0
  8023db:	6a 00                	push   $0x0
  8023dd:	6a 2c                	push   $0x2c
  8023df:	e8 ac fa ff ff       	call   801e90 <syscall>
  8023e4:	83 c4 18             	add    $0x18,%esp
  8023e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8023ea:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8023ee:	75 07                	jne    8023f7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8023f0:	b8 01 00 00 00       	mov    $0x1,%eax
  8023f5:	eb 05                	jmp    8023fc <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8023f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023fc:	c9                   	leave  
  8023fd:	c3                   	ret    

008023fe <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8023fe:	55                   	push   %ebp
  8023ff:	89 e5                	mov    %esp,%ebp
  802401:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802404:	6a 00                	push   $0x0
  802406:	6a 00                	push   $0x0
  802408:	6a 00                	push   $0x0
  80240a:	6a 00                	push   $0x0
  80240c:	6a 00                	push   $0x0
  80240e:	6a 2c                	push   $0x2c
  802410:	e8 7b fa ff ff       	call   801e90 <syscall>
  802415:	83 c4 18             	add    $0x18,%esp
  802418:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80241b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80241f:	75 07                	jne    802428 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802421:	b8 01 00 00 00       	mov    $0x1,%eax
  802426:	eb 05                	jmp    80242d <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802428:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80242d:	c9                   	leave  
  80242e:	c3                   	ret    

0080242f <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80242f:	55                   	push   %ebp
  802430:	89 e5                	mov    %esp,%ebp
  802432:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802435:	6a 00                	push   $0x0
  802437:	6a 00                	push   $0x0
  802439:	6a 00                	push   $0x0
  80243b:	6a 00                	push   $0x0
  80243d:	6a 00                	push   $0x0
  80243f:	6a 2c                	push   $0x2c
  802441:	e8 4a fa ff ff       	call   801e90 <syscall>
  802446:	83 c4 18             	add    $0x18,%esp
  802449:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80244c:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802450:	75 07                	jne    802459 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802452:	b8 01 00 00 00       	mov    $0x1,%eax
  802457:	eb 05                	jmp    80245e <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802459:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80245e:	c9                   	leave  
  80245f:	c3                   	ret    

00802460 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802460:	55                   	push   %ebp
  802461:	89 e5                	mov    %esp,%ebp
  802463:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802466:	6a 00                	push   $0x0
  802468:	6a 00                	push   $0x0
  80246a:	6a 00                	push   $0x0
  80246c:	6a 00                	push   $0x0
  80246e:	6a 00                	push   $0x0
  802470:	6a 2c                	push   $0x2c
  802472:	e8 19 fa ff ff       	call   801e90 <syscall>
  802477:	83 c4 18             	add    $0x18,%esp
  80247a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80247d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802481:	75 07                	jne    80248a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802483:	b8 01 00 00 00       	mov    $0x1,%eax
  802488:	eb 05                	jmp    80248f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80248a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80248f:	c9                   	leave  
  802490:	c3                   	ret    

00802491 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802491:	55                   	push   %ebp
  802492:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802494:	6a 00                	push   $0x0
  802496:	6a 00                	push   $0x0
  802498:	6a 00                	push   $0x0
  80249a:	6a 00                	push   $0x0
  80249c:	ff 75 08             	pushl  0x8(%ebp)
  80249f:	6a 2d                	push   $0x2d
  8024a1:	e8 ea f9 ff ff       	call   801e90 <syscall>
  8024a6:	83 c4 18             	add    $0x18,%esp
	return ;
  8024a9:	90                   	nop
}
  8024aa:	c9                   	leave  
  8024ab:	c3                   	ret    

008024ac <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8024ac:	55                   	push   %ebp
  8024ad:	89 e5                	mov    %esp,%ebp
  8024af:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8024b0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8024b3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bc:	6a 00                	push   $0x0
  8024be:	53                   	push   %ebx
  8024bf:	51                   	push   %ecx
  8024c0:	52                   	push   %edx
  8024c1:	50                   	push   %eax
  8024c2:	6a 2e                	push   $0x2e
  8024c4:	e8 c7 f9 ff ff       	call   801e90 <syscall>
  8024c9:	83 c4 18             	add    $0x18,%esp
}
  8024cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024cf:	c9                   	leave  
  8024d0:	c3                   	ret    

008024d1 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8024d1:	55                   	push   %ebp
  8024d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8024d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024da:	6a 00                	push   $0x0
  8024dc:	6a 00                	push   $0x0
  8024de:	6a 00                	push   $0x0
  8024e0:	52                   	push   %edx
  8024e1:	50                   	push   %eax
  8024e2:	6a 2f                	push   $0x2f
  8024e4:	e8 a7 f9 ff ff       	call   801e90 <syscall>
  8024e9:	83 c4 18             	add    $0x18,%esp
}
  8024ec:	c9                   	leave  
  8024ed:	c3                   	ret    

008024ee <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8024ee:	55                   	push   %ebp
  8024ef:	89 e5                	mov    %esp,%ebp
  8024f1:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8024f4:	83 ec 0c             	sub    $0xc,%esp
  8024f7:	68 30 41 80 00       	push   $0x804130
  8024fc:	e8 d9 e4 ff ff       	call   8009da <cprintf>
  802501:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802504:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80250b:	83 ec 0c             	sub    $0xc,%esp
  80250e:	68 5c 41 80 00       	push   $0x80415c
  802513:	e8 c2 e4 ff ff       	call   8009da <cprintf>
  802518:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80251b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80251f:	a1 38 51 80 00       	mov    0x805138,%eax
  802524:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802527:	eb 56                	jmp    80257f <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802529:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80252d:	74 1c                	je     80254b <print_mem_block_lists+0x5d>
  80252f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802532:	8b 50 08             	mov    0x8(%eax),%edx
  802535:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802538:	8b 48 08             	mov    0x8(%eax),%ecx
  80253b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80253e:	8b 40 0c             	mov    0xc(%eax),%eax
  802541:	01 c8                	add    %ecx,%eax
  802543:	39 c2                	cmp    %eax,%edx
  802545:	73 04                	jae    80254b <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802547:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80254b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254e:	8b 50 08             	mov    0x8(%eax),%edx
  802551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802554:	8b 40 0c             	mov    0xc(%eax),%eax
  802557:	01 c2                	add    %eax,%edx
  802559:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255c:	8b 40 08             	mov    0x8(%eax),%eax
  80255f:	83 ec 04             	sub    $0x4,%esp
  802562:	52                   	push   %edx
  802563:	50                   	push   %eax
  802564:	68 71 41 80 00       	push   $0x804171
  802569:	e8 6c e4 ff ff       	call   8009da <cprintf>
  80256e:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802571:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802574:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802577:	a1 40 51 80 00       	mov    0x805140,%eax
  80257c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80257f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802583:	74 07                	je     80258c <print_mem_block_lists+0x9e>
  802585:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802588:	8b 00                	mov    (%eax),%eax
  80258a:	eb 05                	jmp    802591 <print_mem_block_lists+0xa3>
  80258c:	b8 00 00 00 00       	mov    $0x0,%eax
  802591:	a3 40 51 80 00       	mov    %eax,0x805140
  802596:	a1 40 51 80 00       	mov    0x805140,%eax
  80259b:	85 c0                	test   %eax,%eax
  80259d:	75 8a                	jne    802529 <print_mem_block_lists+0x3b>
  80259f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025a3:	75 84                	jne    802529 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8025a5:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8025a9:	75 10                	jne    8025bb <print_mem_block_lists+0xcd>
  8025ab:	83 ec 0c             	sub    $0xc,%esp
  8025ae:	68 80 41 80 00       	push   $0x804180
  8025b3:	e8 22 e4 ff ff       	call   8009da <cprintf>
  8025b8:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8025bb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8025c2:	83 ec 0c             	sub    $0xc,%esp
  8025c5:	68 a4 41 80 00       	push   $0x8041a4
  8025ca:	e8 0b e4 ff ff       	call   8009da <cprintf>
  8025cf:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8025d2:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8025d6:	a1 40 50 80 00       	mov    0x805040,%eax
  8025db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025de:	eb 56                	jmp    802636 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8025e0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025e4:	74 1c                	je     802602 <print_mem_block_lists+0x114>
  8025e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e9:	8b 50 08             	mov    0x8(%eax),%edx
  8025ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ef:	8b 48 08             	mov    0x8(%eax),%ecx
  8025f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8025f8:	01 c8                	add    %ecx,%eax
  8025fa:	39 c2                	cmp    %eax,%edx
  8025fc:	73 04                	jae    802602 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8025fe:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802602:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802605:	8b 50 08             	mov    0x8(%eax),%edx
  802608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260b:	8b 40 0c             	mov    0xc(%eax),%eax
  80260e:	01 c2                	add    %eax,%edx
  802610:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802613:	8b 40 08             	mov    0x8(%eax),%eax
  802616:	83 ec 04             	sub    $0x4,%esp
  802619:	52                   	push   %edx
  80261a:	50                   	push   %eax
  80261b:	68 71 41 80 00       	push   $0x804171
  802620:	e8 b5 e3 ff ff       	call   8009da <cprintf>
  802625:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802628:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80262e:	a1 48 50 80 00       	mov    0x805048,%eax
  802633:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802636:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80263a:	74 07                	je     802643 <print_mem_block_lists+0x155>
  80263c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263f:	8b 00                	mov    (%eax),%eax
  802641:	eb 05                	jmp    802648 <print_mem_block_lists+0x15a>
  802643:	b8 00 00 00 00       	mov    $0x0,%eax
  802648:	a3 48 50 80 00       	mov    %eax,0x805048
  80264d:	a1 48 50 80 00       	mov    0x805048,%eax
  802652:	85 c0                	test   %eax,%eax
  802654:	75 8a                	jne    8025e0 <print_mem_block_lists+0xf2>
  802656:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80265a:	75 84                	jne    8025e0 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80265c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802660:	75 10                	jne    802672 <print_mem_block_lists+0x184>
  802662:	83 ec 0c             	sub    $0xc,%esp
  802665:	68 bc 41 80 00       	push   $0x8041bc
  80266a:	e8 6b e3 ff ff       	call   8009da <cprintf>
  80266f:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802672:	83 ec 0c             	sub    $0xc,%esp
  802675:	68 30 41 80 00       	push   $0x804130
  80267a:	e8 5b e3 ff ff       	call   8009da <cprintf>
  80267f:	83 c4 10             	add    $0x10,%esp

}
  802682:	90                   	nop
  802683:	c9                   	leave  
  802684:	c3                   	ret    

00802685 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802685:	55                   	push   %ebp
  802686:	89 e5                	mov    %esp,%ebp
  802688:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  80268b:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802692:	00 00 00 
  802695:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80269c:	00 00 00 
  80269f:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8026a6:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  8026a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8026b0:	e9 9e 00 00 00       	jmp    802753 <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  8026b5:	a1 50 50 80 00       	mov    0x805050,%eax
  8026ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026bd:	c1 e2 04             	shl    $0x4,%edx
  8026c0:	01 d0                	add    %edx,%eax
  8026c2:	85 c0                	test   %eax,%eax
  8026c4:	75 14                	jne    8026da <initialize_MemBlocksList+0x55>
  8026c6:	83 ec 04             	sub    $0x4,%esp
  8026c9:	68 e4 41 80 00       	push   $0x8041e4
  8026ce:	6a 42                	push   $0x42
  8026d0:	68 07 42 80 00       	push   $0x804207
  8026d5:	e8 4c e0 ff ff       	call   800726 <_panic>
  8026da:	a1 50 50 80 00       	mov    0x805050,%eax
  8026df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026e2:	c1 e2 04             	shl    $0x4,%edx
  8026e5:	01 d0                	add    %edx,%eax
  8026e7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8026ed:	89 10                	mov    %edx,(%eax)
  8026ef:	8b 00                	mov    (%eax),%eax
  8026f1:	85 c0                	test   %eax,%eax
  8026f3:	74 18                	je     80270d <initialize_MemBlocksList+0x88>
  8026f5:	a1 48 51 80 00       	mov    0x805148,%eax
  8026fa:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802700:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802703:	c1 e1 04             	shl    $0x4,%ecx
  802706:	01 ca                	add    %ecx,%edx
  802708:	89 50 04             	mov    %edx,0x4(%eax)
  80270b:	eb 12                	jmp    80271f <initialize_MemBlocksList+0x9a>
  80270d:	a1 50 50 80 00       	mov    0x805050,%eax
  802712:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802715:	c1 e2 04             	shl    $0x4,%edx
  802718:	01 d0                	add    %edx,%eax
  80271a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80271f:	a1 50 50 80 00       	mov    0x805050,%eax
  802724:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802727:	c1 e2 04             	shl    $0x4,%edx
  80272a:	01 d0                	add    %edx,%eax
  80272c:	a3 48 51 80 00       	mov    %eax,0x805148
  802731:	a1 50 50 80 00       	mov    0x805050,%eax
  802736:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802739:	c1 e2 04             	shl    $0x4,%edx
  80273c:	01 d0                	add    %edx,%eax
  80273e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802745:	a1 54 51 80 00       	mov    0x805154,%eax
  80274a:	40                   	inc    %eax
  80274b:	a3 54 51 80 00       	mov    %eax,0x805154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  802750:	ff 45 f4             	incl   -0xc(%ebp)
  802753:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802756:	3b 45 08             	cmp    0x8(%ebp),%eax
  802759:	0f 82 56 ff ff ff    	jb     8026b5 <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  80275f:	90                   	nop
  802760:	c9                   	leave  
  802761:	c3                   	ret    

00802762 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802762:	55                   	push   %ebp
  802763:	89 e5                	mov    %esp,%ebp
  802765:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  802768:	8b 45 08             	mov    0x8(%ebp),%eax
  80276b:	8b 00                	mov    (%eax),%eax
  80276d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802770:	eb 19                	jmp    80278b <find_block+0x29>
	{
		if(blk->sva==va)
  802772:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802775:	8b 40 08             	mov    0x8(%eax),%eax
  802778:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80277b:	75 05                	jne    802782 <find_block+0x20>
			return (blk);
  80277d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802780:	eb 36                	jmp    8027b8 <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  802782:	8b 45 08             	mov    0x8(%ebp),%eax
  802785:	8b 40 08             	mov    0x8(%eax),%eax
  802788:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80278b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80278f:	74 07                	je     802798 <find_block+0x36>
  802791:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802794:	8b 00                	mov    (%eax),%eax
  802796:	eb 05                	jmp    80279d <find_block+0x3b>
  802798:	b8 00 00 00 00       	mov    $0x0,%eax
  80279d:	8b 55 08             	mov    0x8(%ebp),%edx
  8027a0:	89 42 08             	mov    %eax,0x8(%edx)
  8027a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a6:	8b 40 08             	mov    0x8(%eax),%eax
  8027a9:	85 c0                	test   %eax,%eax
  8027ab:	75 c5                	jne    802772 <find_block+0x10>
  8027ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8027b1:	75 bf                	jne    802772 <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  8027b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027b8:	c9                   	leave  
  8027b9:	c3                   	ret    

008027ba <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8027ba:	55                   	push   %ebp
  8027bb:	89 e5                	mov    %esp,%ebp
  8027bd:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  8027c0:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8027c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8027c8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  8027cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8027d5:	75 65                	jne    80283c <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  8027d7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027db:	75 14                	jne    8027f1 <insert_sorted_allocList+0x37>
  8027dd:	83 ec 04             	sub    $0x4,%esp
  8027e0:	68 e4 41 80 00       	push   $0x8041e4
  8027e5:	6a 5c                	push   $0x5c
  8027e7:	68 07 42 80 00       	push   $0x804207
  8027ec:	e8 35 df ff ff       	call   800726 <_panic>
  8027f1:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8027f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fa:	89 10                	mov    %edx,(%eax)
  8027fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ff:	8b 00                	mov    (%eax),%eax
  802801:	85 c0                	test   %eax,%eax
  802803:	74 0d                	je     802812 <insert_sorted_allocList+0x58>
  802805:	a1 40 50 80 00       	mov    0x805040,%eax
  80280a:	8b 55 08             	mov    0x8(%ebp),%edx
  80280d:	89 50 04             	mov    %edx,0x4(%eax)
  802810:	eb 08                	jmp    80281a <insert_sorted_allocList+0x60>
  802812:	8b 45 08             	mov    0x8(%ebp),%eax
  802815:	a3 44 50 80 00       	mov    %eax,0x805044
  80281a:	8b 45 08             	mov    0x8(%ebp),%eax
  80281d:	a3 40 50 80 00       	mov    %eax,0x805040
  802822:	8b 45 08             	mov    0x8(%ebp),%eax
  802825:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80282c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802831:	40                   	inc    %eax
  802832:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  802837:	e9 7b 01 00 00       	jmp    8029b7 <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  80283c:	a1 44 50 80 00       	mov    0x805044,%eax
  802841:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  802844:	a1 40 50 80 00       	mov    0x805040,%eax
  802849:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  80284c:	8b 45 08             	mov    0x8(%ebp),%eax
  80284f:	8b 50 08             	mov    0x8(%eax),%edx
  802852:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802855:	8b 40 08             	mov    0x8(%eax),%eax
  802858:	39 c2                	cmp    %eax,%edx
  80285a:	76 65                	jbe    8028c1 <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  80285c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802860:	75 14                	jne    802876 <insert_sorted_allocList+0xbc>
  802862:	83 ec 04             	sub    $0x4,%esp
  802865:	68 20 42 80 00       	push   $0x804220
  80286a:	6a 64                	push   $0x64
  80286c:	68 07 42 80 00       	push   $0x804207
  802871:	e8 b0 de ff ff       	call   800726 <_panic>
  802876:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80287c:	8b 45 08             	mov    0x8(%ebp),%eax
  80287f:	89 50 04             	mov    %edx,0x4(%eax)
  802882:	8b 45 08             	mov    0x8(%ebp),%eax
  802885:	8b 40 04             	mov    0x4(%eax),%eax
  802888:	85 c0                	test   %eax,%eax
  80288a:	74 0c                	je     802898 <insert_sorted_allocList+0xde>
  80288c:	a1 44 50 80 00       	mov    0x805044,%eax
  802891:	8b 55 08             	mov    0x8(%ebp),%edx
  802894:	89 10                	mov    %edx,(%eax)
  802896:	eb 08                	jmp    8028a0 <insert_sorted_allocList+0xe6>
  802898:	8b 45 08             	mov    0x8(%ebp),%eax
  80289b:	a3 40 50 80 00       	mov    %eax,0x805040
  8028a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a3:	a3 44 50 80 00       	mov    %eax,0x805044
  8028a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028b1:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8028b6:	40                   	inc    %eax
  8028b7:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  8028bc:	e9 f6 00 00 00       	jmp    8029b7 <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  8028c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c4:	8b 50 08             	mov    0x8(%eax),%edx
  8028c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028ca:	8b 40 08             	mov    0x8(%eax),%eax
  8028cd:	39 c2                	cmp    %eax,%edx
  8028cf:	73 65                	jae    802936 <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  8028d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028d5:	75 14                	jne    8028eb <insert_sorted_allocList+0x131>
  8028d7:	83 ec 04             	sub    $0x4,%esp
  8028da:	68 e4 41 80 00       	push   $0x8041e4
  8028df:	6a 68                	push   $0x68
  8028e1:	68 07 42 80 00       	push   $0x804207
  8028e6:	e8 3b de ff ff       	call   800726 <_panic>
  8028eb:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8028f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f4:	89 10                	mov    %edx,(%eax)
  8028f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f9:	8b 00                	mov    (%eax),%eax
  8028fb:	85 c0                	test   %eax,%eax
  8028fd:	74 0d                	je     80290c <insert_sorted_allocList+0x152>
  8028ff:	a1 40 50 80 00       	mov    0x805040,%eax
  802904:	8b 55 08             	mov    0x8(%ebp),%edx
  802907:	89 50 04             	mov    %edx,0x4(%eax)
  80290a:	eb 08                	jmp    802914 <insert_sorted_allocList+0x15a>
  80290c:	8b 45 08             	mov    0x8(%ebp),%eax
  80290f:	a3 44 50 80 00       	mov    %eax,0x805044
  802914:	8b 45 08             	mov    0x8(%ebp),%eax
  802917:	a3 40 50 80 00       	mov    %eax,0x805040
  80291c:	8b 45 08             	mov    0x8(%ebp),%eax
  80291f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802926:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80292b:	40                   	inc    %eax
  80292c:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  802931:	e9 81 00 00 00       	jmp    8029b7 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802936:	a1 40 50 80 00       	mov    0x805040,%eax
  80293b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80293e:	eb 51                	jmp    802991 <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  802940:	8b 45 08             	mov    0x8(%ebp),%eax
  802943:	8b 50 08             	mov    0x8(%eax),%edx
  802946:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802949:	8b 40 08             	mov    0x8(%eax),%eax
  80294c:	39 c2                	cmp    %eax,%edx
  80294e:	73 39                	jae    802989 <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  802950:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802953:	8b 40 04             	mov    0x4(%eax),%eax
  802956:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  802959:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80295c:	8b 55 08             	mov    0x8(%ebp),%edx
  80295f:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  802961:	8b 45 08             	mov    0x8(%ebp),%eax
  802964:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802967:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  80296a:	8b 45 08             	mov    0x8(%ebp),%eax
  80296d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802970:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  802972:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802975:	8b 55 08             	mov    0x8(%ebp),%edx
  802978:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  80297b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802980:	40                   	inc    %eax
  802981:	a3 4c 50 80 00       	mov    %eax,0x80504c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  802986:	90                   	nop
				}
			}
		 }

	}
}
  802987:	eb 2e                	jmp    8029b7 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802989:	a1 48 50 80 00       	mov    0x805048,%eax
  80298e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802991:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802995:	74 07                	je     80299e <insert_sorted_allocList+0x1e4>
  802997:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299a:	8b 00                	mov    (%eax),%eax
  80299c:	eb 05                	jmp    8029a3 <insert_sorted_allocList+0x1e9>
  80299e:	b8 00 00 00 00       	mov    $0x0,%eax
  8029a3:	a3 48 50 80 00       	mov    %eax,0x805048
  8029a8:	a1 48 50 80 00       	mov    0x805048,%eax
  8029ad:	85 c0                	test   %eax,%eax
  8029af:	75 8f                	jne    802940 <insert_sorted_allocList+0x186>
  8029b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029b5:	75 89                	jne    802940 <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  8029b7:	90                   	nop
  8029b8:	c9                   	leave  
  8029b9:	c3                   	ret    

008029ba <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8029ba:	55                   	push   %ebp
  8029bb:	89 e5                	mov    %esp,%ebp
  8029bd:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  8029c0:	a1 38 51 80 00       	mov    0x805138,%eax
  8029c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029c8:	e9 76 01 00 00       	jmp    802b43 <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  8029cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8029d3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029d6:	0f 85 8a 00 00 00    	jne    802a66 <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  8029dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029e0:	75 17                	jne    8029f9 <alloc_block_FF+0x3f>
  8029e2:	83 ec 04             	sub    $0x4,%esp
  8029e5:	68 43 42 80 00       	push   $0x804243
  8029ea:	68 8a 00 00 00       	push   $0x8a
  8029ef:	68 07 42 80 00       	push   $0x804207
  8029f4:	e8 2d dd ff ff       	call   800726 <_panic>
  8029f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fc:	8b 00                	mov    (%eax),%eax
  8029fe:	85 c0                	test   %eax,%eax
  802a00:	74 10                	je     802a12 <alloc_block_FF+0x58>
  802a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a05:	8b 00                	mov    (%eax),%eax
  802a07:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a0a:	8b 52 04             	mov    0x4(%edx),%edx
  802a0d:	89 50 04             	mov    %edx,0x4(%eax)
  802a10:	eb 0b                	jmp    802a1d <alloc_block_FF+0x63>
  802a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a15:	8b 40 04             	mov    0x4(%eax),%eax
  802a18:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a20:	8b 40 04             	mov    0x4(%eax),%eax
  802a23:	85 c0                	test   %eax,%eax
  802a25:	74 0f                	je     802a36 <alloc_block_FF+0x7c>
  802a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2a:	8b 40 04             	mov    0x4(%eax),%eax
  802a2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a30:	8b 12                	mov    (%edx),%edx
  802a32:	89 10                	mov    %edx,(%eax)
  802a34:	eb 0a                	jmp    802a40 <alloc_block_FF+0x86>
  802a36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a39:	8b 00                	mov    (%eax),%eax
  802a3b:	a3 38 51 80 00       	mov    %eax,0x805138
  802a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a43:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a53:	a1 44 51 80 00       	mov    0x805144,%eax
  802a58:	48                   	dec    %eax
  802a59:	a3 44 51 80 00       	mov    %eax,0x805144
			return element;
  802a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a61:	e9 10 01 00 00       	jmp    802b76 <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  802a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a69:	8b 40 0c             	mov    0xc(%eax),%eax
  802a6c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a6f:	0f 86 c6 00 00 00    	jbe    802b3b <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802a75:	a1 48 51 80 00       	mov    0x805148,%eax
  802a7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802a7d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a81:	75 17                	jne    802a9a <alloc_block_FF+0xe0>
  802a83:	83 ec 04             	sub    $0x4,%esp
  802a86:	68 43 42 80 00       	push   $0x804243
  802a8b:	68 90 00 00 00       	push   $0x90
  802a90:	68 07 42 80 00       	push   $0x804207
  802a95:	e8 8c dc ff ff       	call   800726 <_panic>
  802a9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a9d:	8b 00                	mov    (%eax),%eax
  802a9f:	85 c0                	test   %eax,%eax
  802aa1:	74 10                	je     802ab3 <alloc_block_FF+0xf9>
  802aa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa6:	8b 00                	mov    (%eax),%eax
  802aa8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802aab:	8b 52 04             	mov    0x4(%edx),%edx
  802aae:	89 50 04             	mov    %edx,0x4(%eax)
  802ab1:	eb 0b                	jmp    802abe <alloc_block_FF+0x104>
  802ab3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab6:	8b 40 04             	mov    0x4(%eax),%eax
  802ab9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802abe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac1:	8b 40 04             	mov    0x4(%eax),%eax
  802ac4:	85 c0                	test   %eax,%eax
  802ac6:	74 0f                	je     802ad7 <alloc_block_FF+0x11d>
  802ac8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802acb:	8b 40 04             	mov    0x4(%eax),%eax
  802ace:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ad1:	8b 12                	mov    (%edx),%edx
  802ad3:	89 10                	mov    %edx,(%eax)
  802ad5:	eb 0a                	jmp    802ae1 <alloc_block_FF+0x127>
  802ad7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ada:	8b 00                	mov    (%eax),%eax
  802adc:	a3 48 51 80 00       	mov    %eax,0x805148
  802ae1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802af4:	a1 54 51 80 00       	mov    0x805154,%eax
  802af9:	48                   	dec    %eax
  802afa:	a3 54 51 80 00       	mov    %eax,0x805154
			 element1->size =size;
  802aff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b02:	8b 55 08             	mov    0x8(%ebp),%edx
  802b05:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  802b08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0b:	8b 50 08             	mov    0x8(%eax),%edx
  802b0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b11:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  802b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b17:	8b 50 08             	mov    0x8(%eax),%edx
  802b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1d:	01 c2                	add    %eax,%edx
  802b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b22:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  802b25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b28:	8b 40 0c             	mov    0xc(%eax),%eax
  802b2b:	2b 45 08             	sub    0x8(%ebp),%eax
  802b2e:	89 c2                	mov    %eax,%edx
  802b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b33:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  802b36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b39:	eb 3b                	jmp    802b76 <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802b3b:	a1 40 51 80 00       	mov    0x805140,%eax
  802b40:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b43:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b47:	74 07                	je     802b50 <alloc_block_FF+0x196>
  802b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4c:	8b 00                	mov    (%eax),%eax
  802b4e:	eb 05                	jmp    802b55 <alloc_block_FF+0x19b>
  802b50:	b8 00 00 00 00       	mov    $0x0,%eax
  802b55:	a3 40 51 80 00       	mov    %eax,0x805140
  802b5a:	a1 40 51 80 00       	mov    0x805140,%eax
  802b5f:	85 c0                	test   %eax,%eax
  802b61:	0f 85 66 fe ff ff    	jne    8029cd <alloc_block_FF+0x13>
  802b67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b6b:	0f 85 5c fe ff ff    	jne    8029cd <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  802b71:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b76:	c9                   	leave  
  802b77:	c3                   	ret    

00802b78 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802b78:	55                   	push   %ebp
  802b79:	89 e5                	mov    %esp,%ebp
  802b7b:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  802b7e:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  802b85:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  802b8c:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802b93:	a1 38 51 80 00       	mov    0x805138,%eax
  802b98:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b9b:	e9 cf 00 00 00       	jmp    802c6f <alloc_block_BF+0xf7>
		{
			c++;
  802ba0:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  802ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ba9:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bac:	0f 85 8a 00 00 00    	jne    802c3c <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  802bb2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bb6:	75 17                	jne    802bcf <alloc_block_BF+0x57>
  802bb8:	83 ec 04             	sub    $0x4,%esp
  802bbb:	68 43 42 80 00       	push   $0x804243
  802bc0:	68 a8 00 00 00       	push   $0xa8
  802bc5:	68 07 42 80 00       	push   $0x804207
  802bca:	e8 57 db ff ff       	call   800726 <_panic>
  802bcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd2:	8b 00                	mov    (%eax),%eax
  802bd4:	85 c0                	test   %eax,%eax
  802bd6:	74 10                	je     802be8 <alloc_block_BF+0x70>
  802bd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdb:	8b 00                	mov    (%eax),%eax
  802bdd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802be0:	8b 52 04             	mov    0x4(%edx),%edx
  802be3:	89 50 04             	mov    %edx,0x4(%eax)
  802be6:	eb 0b                	jmp    802bf3 <alloc_block_BF+0x7b>
  802be8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802beb:	8b 40 04             	mov    0x4(%eax),%eax
  802bee:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802bf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf6:	8b 40 04             	mov    0x4(%eax),%eax
  802bf9:	85 c0                	test   %eax,%eax
  802bfb:	74 0f                	je     802c0c <alloc_block_BF+0x94>
  802bfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c00:	8b 40 04             	mov    0x4(%eax),%eax
  802c03:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c06:	8b 12                	mov    (%edx),%edx
  802c08:	89 10                	mov    %edx,(%eax)
  802c0a:	eb 0a                	jmp    802c16 <alloc_block_BF+0x9e>
  802c0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0f:	8b 00                	mov    (%eax),%eax
  802c11:	a3 38 51 80 00       	mov    %eax,0x805138
  802c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c19:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c22:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c29:	a1 44 51 80 00       	mov    0x805144,%eax
  802c2e:	48                   	dec    %eax
  802c2f:	a3 44 51 80 00       	mov    %eax,0x805144
				return block;
  802c34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c37:	e9 85 01 00 00       	jmp    802dc1 <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  802c3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3f:	8b 40 0c             	mov    0xc(%eax),%eax
  802c42:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c45:	76 20                	jbe    802c67 <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  802c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4a:	8b 40 0c             	mov    0xc(%eax),%eax
  802c4d:	2b 45 08             	sub    0x8(%ebp),%eax
  802c50:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  802c53:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c56:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802c59:	73 0c                	jae    802c67 <alloc_block_BF+0xef>
				{
					ma=tempi;
  802c5b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  802c61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c64:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802c67:	a1 40 51 80 00       	mov    0x805140,%eax
  802c6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c73:	74 07                	je     802c7c <alloc_block_BF+0x104>
  802c75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c78:	8b 00                	mov    (%eax),%eax
  802c7a:	eb 05                	jmp    802c81 <alloc_block_BF+0x109>
  802c7c:	b8 00 00 00 00       	mov    $0x0,%eax
  802c81:	a3 40 51 80 00       	mov    %eax,0x805140
  802c86:	a1 40 51 80 00       	mov    0x805140,%eax
  802c8b:	85 c0                	test   %eax,%eax
  802c8d:	0f 85 0d ff ff ff    	jne    802ba0 <alloc_block_BF+0x28>
  802c93:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c97:	0f 85 03 ff ff ff    	jne    802ba0 <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  802c9d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802ca4:	a1 38 51 80 00       	mov    0x805138,%eax
  802ca9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cac:	e9 dd 00 00 00       	jmp    802d8e <alloc_block_BF+0x216>
		{
			if(x==sol)
  802cb1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cb4:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802cb7:	0f 85 c6 00 00 00    	jne    802d83 <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802cbd:	a1 48 51 80 00       	mov    0x805148,%eax
  802cc2:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802cc5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802cc9:	75 17                	jne    802ce2 <alloc_block_BF+0x16a>
  802ccb:	83 ec 04             	sub    $0x4,%esp
  802cce:	68 43 42 80 00       	push   $0x804243
  802cd3:	68 bb 00 00 00       	push   $0xbb
  802cd8:	68 07 42 80 00       	push   $0x804207
  802cdd:	e8 44 da ff ff       	call   800726 <_panic>
  802ce2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ce5:	8b 00                	mov    (%eax),%eax
  802ce7:	85 c0                	test   %eax,%eax
  802ce9:	74 10                	je     802cfb <alloc_block_BF+0x183>
  802ceb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cee:	8b 00                	mov    (%eax),%eax
  802cf0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802cf3:	8b 52 04             	mov    0x4(%edx),%edx
  802cf6:	89 50 04             	mov    %edx,0x4(%eax)
  802cf9:	eb 0b                	jmp    802d06 <alloc_block_BF+0x18e>
  802cfb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cfe:	8b 40 04             	mov    0x4(%eax),%eax
  802d01:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d06:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d09:	8b 40 04             	mov    0x4(%eax),%eax
  802d0c:	85 c0                	test   %eax,%eax
  802d0e:	74 0f                	je     802d1f <alloc_block_BF+0x1a7>
  802d10:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d13:	8b 40 04             	mov    0x4(%eax),%eax
  802d16:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802d19:	8b 12                	mov    (%edx),%edx
  802d1b:	89 10                	mov    %edx,(%eax)
  802d1d:	eb 0a                	jmp    802d29 <alloc_block_BF+0x1b1>
  802d1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d22:	8b 00                	mov    (%eax),%eax
  802d24:	a3 48 51 80 00       	mov    %eax,0x805148
  802d29:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d2c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d32:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d35:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d3c:	a1 54 51 80 00       	mov    0x805154,%eax
  802d41:	48                   	dec    %eax
  802d42:	a3 54 51 80 00       	mov    %eax,0x805154
						 element1->size =size;
  802d47:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d4a:	8b 55 08             	mov    0x8(%ebp),%edx
  802d4d:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  802d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d53:	8b 50 08             	mov    0x8(%eax),%edx
  802d56:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d59:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  802d5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5f:	8b 50 08             	mov    0x8(%eax),%edx
  802d62:	8b 45 08             	mov    0x8(%ebp),%eax
  802d65:	01 c2                	add    %eax,%edx
  802d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6a:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  802d6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d70:	8b 40 0c             	mov    0xc(%eax),%eax
  802d73:	2b 45 08             	sub    0x8(%ebp),%eax
  802d76:	89 c2                	mov    %eax,%edx
  802d78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7b:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  802d7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d81:	eb 3e                	jmp    802dc1 <alloc_block_BF+0x249>
						 break;
			}
			x++;
  802d83:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802d86:	a1 40 51 80 00       	mov    0x805140,%eax
  802d8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d8e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d92:	74 07                	je     802d9b <alloc_block_BF+0x223>
  802d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d97:	8b 00                	mov    (%eax),%eax
  802d99:	eb 05                	jmp    802da0 <alloc_block_BF+0x228>
  802d9b:	b8 00 00 00 00       	mov    $0x0,%eax
  802da0:	a3 40 51 80 00       	mov    %eax,0x805140
  802da5:	a1 40 51 80 00       	mov    0x805140,%eax
  802daa:	85 c0                	test   %eax,%eax
  802dac:	0f 85 ff fe ff ff    	jne    802cb1 <alloc_block_BF+0x139>
  802db2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802db6:	0f 85 f5 fe ff ff    	jne    802cb1 <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  802dbc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802dc1:	c9                   	leave  
  802dc2:	c3                   	ret    

00802dc3 <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802dc3:	55                   	push   %ebp
  802dc4:	89 e5                	mov    %esp,%ebp
  802dc6:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  802dc9:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802dce:	85 c0                	test   %eax,%eax
  802dd0:	75 14                	jne    802de6 <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  802dd2:	a1 38 51 80 00       	mov    0x805138,%eax
  802dd7:	a3 60 51 80 00       	mov    %eax,0x805160
		hh=1;
  802ddc:	c7 05 2c 50 80 00 01 	movl   $0x1,0x80502c
  802de3:	00 00 00 
	}
	uint32 c=1;
  802de6:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  802ded:	a1 60 51 80 00       	mov    0x805160,%eax
  802df2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802df5:	e9 b3 01 00 00       	jmp    802fad <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  802dfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dfd:	8b 40 0c             	mov    0xc(%eax),%eax
  802e00:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e03:	0f 85 a9 00 00 00    	jne    802eb2 <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  802e09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0c:	8b 00                	mov    (%eax),%eax
  802e0e:	85 c0                	test   %eax,%eax
  802e10:	75 0c                	jne    802e1e <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  802e12:	a1 38 51 80 00       	mov    0x805138,%eax
  802e17:	a3 60 51 80 00       	mov    %eax,0x805160
  802e1c:	eb 0a                	jmp    802e28 <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  802e1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e21:	8b 00                	mov    (%eax),%eax
  802e23:	a3 60 51 80 00       	mov    %eax,0x805160
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  802e28:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e2c:	75 17                	jne    802e45 <alloc_block_NF+0x82>
  802e2e:	83 ec 04             	sub    $0x4,%esp
  802e31:	68 43 42 80 00       	push   $0x804243
  802e36:	68 e3 00 00 00       	push   $0xe3
  802e3b:	68 07 42 80 00       	push   $0x804207
  802e40:	e8 e1 d8 ff ff       	call   800726 <_panic>
  802e45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e48:	8b 00                	mov    (%eax),%eax
  802e4a:	85 c0                	test   %eax,%eax
  802e4c:	74 10                	je     802e5e <alloc_block_NF+0x9b>
  802e4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e51:	8b 00                	mov    (%eax),%eax
  802e53:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e56:	8b 52 04             	mov    0x4(%edx),%edx
  802e59:	89 50 04             	mov    %edx,0x4(%eax)
  802e5c:	eb 0b                	jmp    802e69 <alloc_block_NF+0xa6>
  802e5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e61:	8b 40 04             	mov    0x4(%eax),%eax
  802e64:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e6c:	8b 40 04             	mov    0x4(%eax),%eax
  802e6f:	85 c0                	test   %eax,%eax
  802e71:	74 0f                	je     802e82 <alloc_block_NF+0xbf>
  802e73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e76:	8b 40 04             	mov    0x4(%eax),%eax
  802e79:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e7c:	8b 12                	mov    (%edx),%edx
  802e7e:	89 10                	mov    %edx,(%eax)
  802e80:	eb 0a                	jmp    802e8c <alloc_block_NF+0xc9>
  802e82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e85:	8b 00                	mov    (%eax),%eax
  802e87:	a3 38 51 80 00       	mov    %eax,0x805138
  802e8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e8f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e98:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e9f:	a1 44 51 80 00       	mov    0x805144,%eax
  802ea4:	48                   	dec    %eax
  802ea5:	a3 44 51 80 00       	mov    %eax,0x805144
				return element;
  802eaa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ead:	e9 0e 01 00 00       	jmp    802fc0 <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  802eb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb5:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb8:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ebb:	0f 86 ce 00 00 00    	jbe    802f8f <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802ec1:	a1 48 51 80 00       	mov    0x805148,%eax
  802ec6:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802ec9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ecd:	75 17                	jne    802ee6 <alloc_block_NF+0x123>
  802ecf:	83 ec 04             	sub    $0x4,%esp
  802ed2:	68 43 42 80 00       	push   $0x804243
  802ed7:	68 e9 00 00 00       	push   $0xe9
  802edc:	68 07 42 80 00       	push   $0x804207
  802ee1:	e8 40 d8 ff ff       	call   800726 <_panic>
  802ee6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ee9:	8b 00                	mov    (%eax),%eax
  802eeb:	85 c0                	test   %eax,%eax
  802eed:	74 10                	je     802eff <alloc_block_NF+0x13c>
  802eef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ef2:	8b 00                	mov    (%eax),%eax
  802ef4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ef7:	8b 52 04             	mov    0x4(%edx),%edx
  802efa:	89 50 04             	mov    %edx,0x4(%eax)
  802efd:	eb 0b                	jmp    802f0a <alloc_block_NF+0x147>
  802eff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f02:	8b 40 04             	mov    0x4(%eax),%eax
  802f05:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f0d:	8b 40 04             	mov    0x4(%eax),%eax
  802f10:	85 c0                	test   %eax,%eax
  802f12:	74 0f                	je     802f23 <alloc_block_NF+0x160>
  802f14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f17:	8b 40 04             	mov    0x4(%eax),%eax
  802f1a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f1d:	8b 12                	mov    (%edx),%edx
  802f1f:	89 10                	mov    %edx,(%eax)
  802f21:	eb 0a                	jmp    802f2d <alloc_block_NF+0x16a>
  802f23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f26:	8b 00                	mov    (%eax),%eax
  802f28:	a3 48 51 80 00       	mov    %eax,0x805148
  802f2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f39:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f40:	a1 54 51 80 00       	mov    0x805154,%eax
  802f45:	48                   	dec    %eax
  802f46:	a3 54 51 80 00       	mov    %eax,0x805154
				 element1->size =size;
  802f4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f4e:	8b 55 08             	mov    0x8(%ebp),%edx
  802f51:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  802f54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f57:	8b 50 08             	mov    0x8(%eax),%edx
  802f5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f5d:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  802f60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f63:	8b 50 08             	mov    0x8(%eax),%edx
  802f66:	8b 45 08             	mov    0x8(%ebp),%eax
  802f69:	01 c2                	add    %eax,%edx
  802f6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f6e:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  802f71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f74:	8b 40 0c             	mov    0xc(%eax),%eax
  802f77:	2b 45 08             	sub    0x8(%ebp),%eax
  802f7a:	89 c2                	mov    %eax,%edx
  802f7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f7f:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  802f82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f85:	a3 60 51 80 00       	mov    %eax,0x805160
				 return element1;
  802f8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f8d:	eb 31                	jmp    802fc0 <alloc_block_NF+0x1fd>
			 }
		 c++;
  802f8f:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  802f92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f95:	8b 00                	mov    (%eax),%eax
  802f97:	85 c0                	test   %eax,%eax
  802f99:	75 0a                	jne    802fa5 <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  802f9b:	a1 38 51 80 00       	mov    0x805138,%eax
  802fa0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802fa3:	eb 08                	jmp    802fad <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  802fa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fa8:	8b 00                	mov    (%eax),%eax
  802faa:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802fad:	a1 44 51 80 00       	mov    0x805144,%eax
  802fb2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802fb5:	0f 85 3f fe ff ff    	jne    802dfa <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  802fbb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802fc0:	c9                   	leave  
  802fc1:	c3                   	ret    

00802fc2 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802fc2:	55                   	push   %ebp
  802fc3:	89 e5                	mov    %esp,%ebp
  802fc5:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  802fc8:	a1 44 51 80 00       	mov    0x805144,%eax
  802fcd:	85 c0                	test   %eax,%eax
  802fcf:	75 68                	jne    803039 <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802fd1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fd5:	75 17                	jne    802fee <insert_sorted_with_merge_freeList+0x2c>
  802fd7:	83 ec 04             	sub    $0x4,%esp
  802fda:	68 e4 41 80 00       	push   $0x8041e4
  802fdf:	68 0e 01 00 00       	push   $0x10e
  802fe4:	68 07 42 80 00       	push   $0x804207
  802fe9:	e8 38 d7 ff ff       	call   800726 <_panic>
  802fee:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff7:	89 10                	mov    %edx,(%eax)
  802ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffc:	8b 00                	mov    (%eax),%eax
  802ffe:	85 c0                	test   %eax,%eax
  803000:	74 0d                	je     80300f <insert_sorted_with_merge_freeList+0x4d>
  803002:	a1 38 51 80 00       	mov    0x805138,%eax
  803007:	8b 55 08             	mov    0x8(%ebp),%edx
  80300a:	89 50 04             	mov    %edx,0x4(%eax)
  80300d:	eb 08                	jmp    803017 <insert_sorted_with_merge_freeList+0x55>
  80300f:	8b 45 08             	mov    0x8(%ebp),%eax
  803012:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803017:	8b 45 08             	mov    0x8(%ebp),%eax
  80301a:	a3 38 51 80 00       	mov    %eax,0x805138
  80301f:	8b 45 08             	mov    0x8(%ebp),%eax
  803022:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803029:	a1 44 51 80 00       	mov    0x805144,%eax
  80302e:	40                   	inc    %eax
  80302f:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  803034:	e9 8c 06 00 00       	jmp    8036c5 <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  803039:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80303e:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  803041:	a1 38 51 80 00       	mov    0x805138,%eax
  803046:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  803049:	8b 45 08             	mov    0x8(%ebp),%eax
  80304c:	8b 50 08             	mov    0x8(%eax),%edx
  80304f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803052:	8b 40 08             	mov    0x8(%eax),%eax
  803055:	39 c2                	cmp    %eax,%edx
  803057:	0f 86 14 01 00 00    	jbe    803171 <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  80305d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803060:	8b 50 0c             	mov    0xc(%eax),%edx
  803063:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803066:	8b 40 08             	mov    0x8(%eax),%eax
  803069:	01 c2                	add    %eax,%edx
  80306b:	8b 45 08             	mov    0x8(%ebp),%eax
  80306e:	8b 40 08             	mov    0x8(%eax),%eax
  803071:	39 c2                	cmp    %eax,%edx
  803073:	0f 85 90 00 00 00    	jne    803109 <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  803079:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80307c:	8b 50 0c             	mov    0xc(%eax),%edx
  80307f:	8b 45 08             	mov    0x8(%ebp),%eax
  803082:	8b 40 0c             	mov    0xc(%eax),%eax
  803085:	01 c2                	add    %eax,%edx
  803087:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80308a:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  80308d:	8b 45 08             	mov    0x8(%ebp),%eax
  803090:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  803097:	8b 45 08             	mov    0x8(%ebp),%eax
  80309a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8030a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030a5:	75 17                	jne    8030be <insert_sorted_with_merge_freeList+0xfc>
  8030a7:	83 ec 04             	sub    $0x4,%esp
  8030aa:	68 e4 41 80 00       	push   $0x8041e4
  8030af:	68 1b 01 00 00       	push   $0x11b
  8030b4:	68 07 42 80 00       	push   $0x804207
  8030b9:	e8 68 d6 ff ff       	call   800726 <_panic>
  8030be:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c7:	89 10                	mov    %edx,(%eax)
  8030c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cc:	8b 00                	mov    (%eax),%eax
  8030ce:	85 c0                	test   %eax,%eax
  8030d0:	74 0d                	je     8030df <insert_sorted_with_merge_freeList+0x11d>
  8030d2:	a1 48 51 80 00       	mov    0x805148,%eax
  8030d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8030da:	89 50 04             	mov    %edx,0x4(%eax)
  8030dd:	eb 08                	jmp    8030e7 <insert_sorted_with_merge_freeList+0x125>
  8030df:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ea:	a3 48 51 80 00       	mov    %eax,0x805148
  8030ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030f9:	a1 54 51 80 00       	mov    0x805154,%eax
  8030fe:	40                   	inc    %eax
  8030ff:	a3 54 51 80 00       	mov    %eax,0x805154
							}

						}
		          }
		}
}
  803104:	e9 bc 05 00 00       	jmp    8036c5 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803109:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80310d:	75 17                	jne    803126 <insert_sorted_with_merge_freeList+0x164>
  80310f:	83 ec 04             	sub    $0x4,%esp
  803112:	68 20 42 80 00       	push   $0x804220
  803117:	68 1f 01 00 00       	push   $0x11f
  80311c:	68 07 42 80 00       	push   $0x804207
  803121:	e8 00 d6 ff ff       	call   800726 <_panic>
  803126:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80312c:	8b 45 08             	mov    0x8(%ebp),%eax
  80312f:	89 50 04             	mov    %edx,0x4(%eax)
  803132:	8b 45 08             	mov    0x8(%ebp),%eax
  803135:	8b 40 04             	mov    0x4(%eax),%eax
  803138:	85 c0                	test   %eax,%eax
  80313a:	74 0c                	je     803148 <insert_sorted_with_merge_freeList+0x186>
  80313c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803141:	8b 55 08             	mov    0x8(%ebp),%edx
  803144:	89 10                	mov    %edx,(%eax)
  803146:	eb 08                	jmp    803150 <insert_sorted_with_merge_freeList+0x18e>
  803148:	8b 45 08             	mov    0x8(%ebp),%eax
  80314b:	a3 38 51 80 00       	mov    %eax,0x805138
  803150:	8b 45 08             	mov    0x8(%ebp),%eax
  803153:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803158:	8b 45 08             	mov    0x8(%ebp),%eax
  80315b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803161:	a1 44 51 80 00       	mov    0x805144,%eax
  803166:	40                   	inc    %eax
  803167:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  80316c:	e9 54 05 00 00       	jmp    8036c5 <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  803171:	8b 45 08             	mov    0x8(%ebp),%eax
  803174:	8b 50 08             	mov    0x8(%eax),%edx
  803177:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80317a:	8b 40 08             	mov    0x8(%eax),%eax
  80317d:	39 c2                	cmp    %eax,%edx
  80317f:	0f 83 20 01 00 00    	jae    8032a5 <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  803185:	8b 45 08             	mov    0x8(%ebp),%eax
  803188:	8b 50 0c             	mov    0xc(%eax),%edx
  80318b:	8b 45 08             	mov    0x8(%ebp),%eax
  80318e:	8b 40 08             	mov    0x8(%eax),%eax
  803191:	01 c2                	add    %eax,%edx
  803193:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803196:	8b 40 08             	mov    0x8(%eax),%eax
  803199:	39 c2                	cmp    %eax,%edx
  80319b:	0f 85 9c 00 00 00    	jne    80323d <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  8031a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a4:	8b 50 08             	mov    0x8(%eax),%edx
  8031a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031aa:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  8031ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031b0:	8b 50 0c             	mov    0xc(%eax),%edx
  8031b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8031b9:	01 c2                	add    %eax,%edx
  8031bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031be:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  8031c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  8031cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ce:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8031d5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031d9:	75 17                	jne    8031f2 <insert_sorted_with_merge_freeList+0x230>
  8031db:	83 ec 04             	sub    $0x4,%esp
  8031de:	68 e4 41 80 00       	push   $0x8041e4
  8031e3:	68 2a 01 00 00       	push   $0x12a
  8031e8:	68 07 42 80 00       	push   $0x804207
  8031ed:	e8 34 d5 ff ff       	call   800726 <_panic>
  8031f2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fb:	89 10                	mov    %edx,(%eax)
  8031fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803200:	8b 00                	mov    (%eax),%eax
  803202:	85 c0                	test   %eax,%eax
  803204:	74 0d                	je     803213 <insert_sorted_with_merge_freeList+0x251>
  803206:	a1 48 51 80 00       	mov    0x805148,%eax
  80320b:	8b 55 08             	mov    0x8(%ebp),%edx
  80320e:	89 50 04             	mov    %edx,0x4(%eax)
  803211:	eb 08                	jmp    80321b <insert_sorted_with_merge_freeList+0x259>
  803213:	8b 45 08             	mov    0x8(%ebp),%eax
  803216:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80321b:	8b 45 08             	mov    0x8(%ebp),%eax
  80321e:	a3 48 51 80 00       	mov    %eax,0x805148
  803223:	8b 45 08             	mov    0x8(%ebp),%eax
  803226:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80322d:	a1 54 51 80 00       	mov    0x805154,%eax
  803232:	40                   	inc    %eax
  803233:	a3 54 51 80 00       	mov    %eax,0x805154
							}

						}
		          }
		}
}
  803238:	e9 88 04 00 00       	jmp    8036c5 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  80323d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803241:	75 17                	jne    80325a <insert_sorted_with_merge_freeList+0x298>
  803243:	83 ec 04             	sub    $0x4,%esp
  803246:	68 e4 41 80 00       	push   $0x8041e4
  80324b:	68 2e 01 00 00       	push   $0x12e
  803250:	68 07 42 80 00       	push   $0x804207
  803255:	e8 cc d4 ff ff       	call   800726 <_panic>
  80325a:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803260:	8b 45 08             	mov    0x8(%ebp),%eax
  803263:	89 10                	mov    %edx,(%eax)
  803265:	8b 45 08             	mov    0x8(%ebp),%eax
  803268:	8b 00                	mov    (%eax),%eax
  80326a:	85 c0                	test   %eax,%eax
  80326c:	74 0d                	je     80327b <insert_sorted_with_merge_freeList+0x2b9>
  80326e:	a1 38 51 80 00       	mov    0x805138,%eax
  803273:	8b 55 08             	mov    0x8(%ebp),%edx
  803276:	89 50 04             	mov    %edx,0x4(%eax)
  803279:	eb 08                	jmp    803283 <insert_sorted_with_merge_freeList+0x2c1>
  80327b:	8b 45 08             	mov    0x8(%ebp),%eax
  80327e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803283:	8b 45 08             	mov    0x8(%ebp),%eax
  803286:	a3 38 51 80 00       	mov    %eax,0x805138
  80328b:	8b 45 08             	mov    0x8(%ebp),%eax
  80328e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803295:	a1 44 51 80 00       	mov    0x805144,%eax
  80329a:	40                   	inc    %eax
  80329b:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  8032a0:	e9 20 04 00 00       	jmp    8036c5 <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  8032a5:	a1 38 51 80 00       	mov    0x805138,%eax
  8032aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032ad:	e9 e2 03 00 00       	jmp    803694 <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  8032b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b5:	8b 50 08             	mov    0x8(%eax),%edx
  8032b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032bb:	8b 40 08             	mov    0x8(%eax),%eax
  8032be:	39 c2                	cmp    %eax,%edx
  8032c0:	0f 83 c6 03 00 00    	jae    80368c <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  8032c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c9:	8b 40 04             	mov    0x4(%eax),%eax
  8032cc:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  8032cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d2:	8b 50 08             	mov    0x8(%eax),%edx
  8032d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8032db:	01 d0                	add    %edx,%eax
  8032dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  8032e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e3:	8b 50 0c             	mov    0xc(%eax),%edx
  8032e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e9:	8b 40 08             	mov    0x8(%eax),%eax
  8032ec:	01 d0                	add    %edx,%eax
  8032ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  8032f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f4:	8b 40 08             	mov    0x8(%eax),%eax
  8032f7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8032fa:	74 7a                	je     803376 <insert_sorted_with_merge_freeList+0x3b4>
  8032fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ff:	8b 40 08             	mov    0x8(%eax),%eax
  803302:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803305:	74 6f                	je     803376 <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  803307:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80330b:	74 06                	je     803313 <insert_sorted_with_merge_freeList+0x351>
  80330d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803311:	75 17                	jne    80332a <insert_sorted_with_merge_freeList+0x368>
  803313:	83 ec 04             	sub    $0x4,%esp
  803316:	68 64 42 80 00       	push   $0x804264
  80331b:	68 43 01 00 00       	push   $0x143
  803320:	68 07 42 80 00       	push   $0x804207
  803325:	e8 fc d3 ff ff       	call   800726 <_panic>
  80332a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332d:	8b 50 04             	mov    0x4(%eax),%edx
  803330:	8b 45 08             	mov    0x8(%ebp),%eax
  803333:	89 50 04             	mov    %edx,0x4(%eax)
  803336:	8b 45 08             	mov    0x8(%ebp),%eax
  803339:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80333c:	89 10                	mov    %edx,(%eax)
  80333e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803341:	8b 40 04             	mov    0x4(%eax),%eax
  803344:	85 c0                	test   %eax,%eax
  803346:	74 0d                	je     803355 <insert_sorted_with_merge_freeList+0x393>
  803348:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334b:	8b 40 04             	mov    0x4(%eax),%eax
  80334e:	8b 55 08             	mov    0x8(%ebp),%edx
  803351:	89 10                	mov    %edx,(%eax)
  803353:	eb 08                	jmp    80335d <insert_sorted_with_merge_freeList+0x39b>
  803355:	8b 45 08             	mov    0x8(%ebp),%eax
  803358:	a3 38 51 80 00       	mov    %eax,0x805138
  80335d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803360:	8b 55 08             	mov    0x8(%ebp),%edx
  803363:	89 50 04             	mov    %edx,0x4(%eax)
  803366:	a1 44 51 80 00       	mov    0x805144,%eax
  80336b:	40                   	inc    %eax
  80336c:	a3 44 51 80 00       	mov    %eax,0x805144
  803371:	e9 14 03 00 00       	jmp    80368a <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  803376:	8b 45 08             	mov    0x8(%ebp),%eax
  803379:	8b 40 08             	mov    0x8(%eax),%eax
  80337c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80337f:	0f 85 a0 01 00 00    	jne    803525 <insert_sorted_with_merge_freeList+0x563>
  803385:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803388:	8b 40 08             	mov    0x8(%eax),%eax
  80338b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80338e:	0f 85 91 01 00 00    	jne    803525 <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  803394:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803397:	8b 50 0c             	mov    0xc(%eax),%edx
  80339a:	8b 45 08             	mov    0x8(%ebp),%eax
  80339d:	8b 48 0c             	mov    0xc(%eax),%ecx
  8033a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8033a6:	01 c8                	add    %ecx,%eax
  8033a8:	01 c2                	add    %eax,%edx
  8033aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ad:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  8033b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  8033ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8033bd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  8033c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  8033ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8033d8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033dc:	75 17                	jne    8033f5 <insert_sorted_with_merge_freeList+0x433>
  8033de:	83 ec 04             	sub    $0x4,%esp
  8033e1:	68 e4 41 80 00       	push   $0x8041e4
  8033e6:	68 4d 01 00 00       	push   $0x14d
  8033eb:	68 07 42 80 00       	push   $0x804207
  8033f0:	e8 31 d3 ff ff       	call   800726 <_panic>
  8033f5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fe:	89 10                	mov    %edx,(%eax)
  803400:	8b 45 08             	mov    0x8(%ebp),%eax
  803403:	8b 00                	mov    (%eax),%eax
  803405:	85 c0                	test   %eax,%eax
  803407:	74 0d                	je     803416 <insert_sorted_with_merge_freeList+0x454>
  803409:	a1 48 51 80 00       	mov    0x805148,%eax
  80340e:	8b 55 08             	mov    0x8(%ebp),%edx
  803411:	89 50 04             	mov    %edx,0x4(%eax)
  803414:	eb 08                	jmp    80341e <insert_sorted_with_merge_freeList+0x45c>
  803416:	8b 45 08             	mov    0x8(%ebp),%eax
  803419:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80341e:	8b 45 08             	mov    0x8(%ebp),%eax
  803421:	a3 48 51 80 00       	mov    %eax,0x805148
  803426:	8b 45 08             	mov    0x8(%ebp),%eax
  803429:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803430:	a1 54 51 80 00       	mov    0x805154,%eax
  803435:	40                   	inc    %eax
  803436:	a3 54 51 80 00       	mov    %eax,0x805154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  80343b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80343f:	75 17                	jne    803458 <insert_sorted_with_merge_freeList+0x496>
  803441:	83 ec 04             	sub    $0x4,%esp
  803444:	68 43 42 80 00       	push   $0x804243
  803449:	68 4e 01 00 00       	push   $0x14e
  80344e:	68 07 42 80 00       	push   $0x804207
  803453:	e8 ce d2 ff ff       	call   800726 <_panic>
  803458:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345b:	8b 00                	mov    (%eax),%eax
  80345d:	85 c0                	test   %eax,%eax
  80345f:	74 10                	je     803471 <insert_sorted_with_merge_freeList+0x4af>
  803461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803464:	8b 00                	mov    (%eax),%eax
  803466:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803469:	8b 52 04             	mov    0x4(%edx),%edx
  80346c:	89 50 04             	mov    %edx,0x4(%eax)
  80346f:	eb 0b                	jmp    80347c <insert_sorted_with_merge_freeList+0x4ba>
  803471:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803474:	8b 40 04             	mov    0x4(%eax),%eax
  803477:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80347c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80347f:	8b 40 04             	mov    0x4(%eax),%eax
  803482:	85 c0                	test   %eax,%eax
  803484:	74 0f                	je     803495 <insert_sorted_with_merge_freeList+0x4d3>
  803486:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803489:	8b 40 04             	mov    0x4(%eax),%eax
  80348c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80348f:	8b 12                	mov    (%edx),%edx
  803491:	89 10                	mov    %edx,(%eax)
  803493:	eb 0a                	jmp    80349f <insert_sorted_with_merge_freeList+0x4dd>
  803495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803498:	8b 00                	mov    (%eax),%eax
  80349a:	a3 38 51 80 00       	mov    %eax,0x805138
  80349f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034b2:	a1 44 51 80 00       	mov    0x805144,%eax
  8034b7:	48                   	dec    %eax
  8034b8:	a3 44 51 80 00       	mov    %eax,0x805144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  8034bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034c1:	75 17                	jne    8034da <insert_sorted_with_merge_freeList+0x518>
  8034c3:	83 ec 04             	sub    $0x4,%esp
  8034c6:	68 e4 41 80 00       	push   $0x8041e4
  8034cb:	68 4f 01 00 00       	push   $0x14f
  8034d0:	68 07 42 80 00       	push   $0x804207
  8034d5:	e8 4c d2 ff ff       	call   800726 <_panic>
  8034da:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e3:	89 10                	mov    %edx,(%eax)
  8034e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e8:	8b 00                	mov    (%eax),%eax
  8034ea:	85 c0                	test   %eax,%eax
  8034ec:	74 0d                	je     8034fb <insert_sorted_with_merge_freeList+0x539>
  8034ee:	a1 48 51 80 00       	mov    0x805148,%eax
  8034f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034f6:	89 50 04             	mov    %edx,0x4(%eax)
  8034f9:	eb 08                	jmp    803503 <insert_sorted_with_merge_freeList+0x541>
  8034fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034fe:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803503:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803506:	a3 48 51 80 00       	mov    %eax,0x805148
  80350b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80350e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803515:	a1 54 51 80 00       	mov    0x805154,%eax
  80351a:	40                   	inc    %eax
  80351b:	a3 54 51 80 00       	mov    %eax,0x805154
  803520:	e9 65 01 00 00       	jmp    80368a <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  803525:	8b 45 08             	mov    0x8(%ebp),%eax
  803528:	8b 40 08             	mov    0x8(%eax),%eax
  80352b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80352e:	0f 85 9f 00 00 00    	jne    8035d3 <insert_sorted_with_merge_freeList+0x611>
  803534:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803537:	8b 40 08             	mov    0x8(%eax),%eax
  80353a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80353d:	0f 84 90 00 00 00    	je     8035d3 <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  803543:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803546:	8b 50 0c             	mov    0xc(%eax),%edx
  803549:	8b 45 08             	mov    0x8(%ebp),%eax
  80354c:	8b 40 0c             	mov    0xc(%eax),%eax
  80354f:	01 c2                	add    %eax,%edx
  803551:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803554:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  803557:	8b 45 08             	mov    0x8(%ebp),%eax
  80355a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  803561:	8b 45 08             	mov    0x8(%ebp),%eax
  803564:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80356b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80356f:	75 17                	jne    803588 <insert_sorted_with_merge_freeList+0x5c6>
  803571:	83 ec 04             	sub    $0x4,%esp
  803574:	68 e4 41 80 00       	push   $0x8041e4
  803579:	68 58 01 00 00       	push   $0x158
  80357e:	68 07 42 80 00       	push   $0x804207
  803583:	e8 9e d1 ff ff       	call   800726 <_panic>
  803588:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80358e:	8b 45 08             	mov    0x8(%ebp),%eax
  803591:	89 10                	mov    %edx,(%eax)
  803593:	8b 45 08             	mov    0x8(%ebp),%eax
  803596:	8b 00                	mov    (%eax),%eax
  803598:	85 c0                	test   %eax,%eax
  80359a:	74 0d                	je     8035a9 <insert_sorted_with_merge_freeList+0x5e7>
  80359c:	a1 48 51 80 00       	mov    0x805148,%eax
  8035a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8035a4:	89 50 04             	mov    %edx,0x4(%eax)
  8035a7:	eb 08                	jmp    8035b1 <insert_sorted_with_merge_freeList+0x5ef>
  8035a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ac:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b4:	a3 48 51 80 00       	mov    %eax,0x805148
  8035b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035bc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035c3:	a1 54 51 80 00       	mov    0x805154,%eax
  8035c8:	40                   	inc    %eax
  8035c9:	a3 54 51 80 00       	mov    %eax,0x805154
  8035ce:	e9 b7 00 00 00       	jmp    80368a <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  8035d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d6:	8b 40 08             	mov    0x8(%eax),%eax
  8035d9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8035dc:	0f 84 e2 00 00 00    	je     8036c4 <insert_sorted_with_merge_freeList+0x702>
  8035e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e5:	8b 40 08             	mov    0x8(%eax),%eax
  8035e8:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8035eb:	0f 85 d3 00 00 00    	jne    8036c4 <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  8035f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f4:	8b 50 08             	mov    0x8(%eax),%edx
  8035f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035fa:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  8035fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803600:	8b 50 0c             	mov    0xc(%eax),%edx
  803603:	8b 45 08             	mov    0x8(%ebp),%eax
  803606:	8b 40 0c             	mov    0xc(%eax),%eax
  803609:	01 c2                	add    %eax,%edx
  80360b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80360e:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  803611:	8b 45 08             	mov    0x8(%ebp),%eax
  803614:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  80361b:	8b 45 08             	mov    0x8(%ebp),%eax
  80361e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803625:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803629:	75 17                	jne    803642 <insert_sorted_with_merge_freeList+0x680>
  80362b:	83 ec 04             	sub    $0x4,%esp
  80362e:	68 e4 41 80 00       	push   $0x8041e4
  803633:	68 61 01 00 00       	push   $0x161
  803638:	68 07 42 80 00       	push   $0x804207
  80363d:	e8 e4 d0 ff ff       	call   800726 <_panic>
  803642:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803648:	8b 45 08             	mov    0x8(%ebp),%eax
  80364b:	89 10                	mov    %edx,(%eax)
  80364d:	8b 45 08             	mov    0x8(%ebp),%eax
  803650:	8b 00                	mov    (%eax),%eax
  803652:	85 c0                	test   %eax,%eax
  803654:	74 0d                	je     803663 <insert_sorted_with_merge_freeList+0x6a1>
  803656:	a1 48 51 80 00       	mov    0x805148,%eax
  80365b:	8b 55 08             	mov    0x8(%ebp),%edx
  80365e:	89 50 04             	mov    %edx,0x4(%eax)
  803661:	eb 08                	jmp    80366b <insert_sorted_with_merge_freeList+0x6a9>
  803663:	8b 45 08             	mov    0x8(%ebp),%eax
  803666:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80366b:	8b 45 08             	mov    0x8(%ebp),%eax
  80366e:	a3 48 51 80 00       	mov    %eax,0x805148
  803673:	8b 45 08             	mov    0x8(%ebp),%eax
  803676:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80367d:	a1 54 51 80 00       	mov    0x805154,%eax
  803682:	40                   	inc    %eax
  803683:	a3 54 51 80 00       	mov    %eax,0x805154
								}
								break;
  803688:	eb 3a                	jmp    8036c4 <insert_sorted_with_merge_freeList+0x702>
  80368a:	eb 38                	jmp    8036c4 <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  80368c:	a1 40 51 80 00       	mov    0x805140,%eax
  803691:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803694:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803698:	74 07                	je     8036a1 <insert_sorted_with_merge_freeList+0x6df>
  80369a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80369d:	8b 00                	mov    (%eax),%eax
  80369f:	eb 05                	jmp    8036a6 <insert_sorted_with_merge_freeList+0x6e4>
  8036a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8036a6:	a3 40 51 80 00       	mov    %eax,0x805140
  8036ab:	a1 40 51 80 00       	mov    0x805140,%eax
  8036b0:	85 c0                	test   %eax,%eax
  8036b2:	0f 85 fa fb ff ff    	jne    8032b2 <insert_sorted_with_merge_freeList+0x2f0>
  8036b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036bc:	0f 85 f0 fb ff ff    	jne    8032b2 <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  8036c2:	eb 01                	jmp    8036c5 <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  8036c4:	90                   	nop
							}

						}
		          }
		}
}
  8036c5:	90                   	nop
  8036c6:	c9                   	leave  
  8036c7:	c3                   	ret    

008036c8 <__udivdi3>:
  8036c8:	55                   	push   %ebp
  8036c9:	57                   	push   %edi
  8036ca:	56                   	push   %esi
  8036cb:	53                   	push   %ebx
  8036cc:	83 ec 1c             	sub    $0x1c,%esp
  8036cf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8036d3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8036d7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8036db:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8036df:	89 ca                	mov    %ecx,%edx
  8036e1:	89 f8                	mov    %edi,%eax
  8036e3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8036e7:	85 f6                	test   %esi,%esi
  8036e9:	75 2d                	jne    803718 <__udivdi3+0x50>
  8036eb:	39 cf                	cmp    %ecx,%edi
  8036ed:	77 65                	ja     803754 <__udivdi3+0x8c>
  8036ef:	89 fd                	mov    %edi,%ebp
  8036f1:	85 ff                	test   %edi,%edi
  8036f3:	75 0b                	jne    803700 <__udivdi3+0x38>
  8036f5:	b8 01 00 00 00       	mov    $0x1,%eax
  8036fa:	31 d2                	xor    %edx,%edx
  8036fc:	f7 f7                	div    %edi
  8036fe:	89 c5                	mov    %eax,%ebp
  803700:	31 d2                	xor    %edx,%edx
  803702:	89 c8                	mov    %ecx,%eax
  803704:	f7 f5                	div    %ebp
  803706:	89 c1                	mov    %eax,%ecx
  803708:	89 d8                	mov    %ebx,%eax
  80370a:	f7 f5                	div    %ebp
  80370c:	89 cf                	mov    %ecx,%edi
  80370e:	89 fa                	mov    %edi,%edx
  803710:	83 c4 1c             	add    $0x1c,%esp
  803713:	5b                   	pop    %ebx
  803714:	5e                   	pop    %esi
  803715:	5f                   	pop    %edi
  803716:	5d                   	pop    %ebp
  803717:	c3                   	ret    
  803718:	39 ce                	cmp    %ecx,%esi
  80371a:	77 28                	ja     803744 <__udivdi3+0x7c>
  80371c:	0f bd fe             	bsr    %esi,%edi
  80371f:	83 f7 1f             	xor    $0x1f,%edi
  803722:	75 40                	jne    803764 <__udivdi3+0x9c>
  803724:	39 ce                	cmp    %ecx,%esi
  803726:	72 0a                	jb     803732 <__udivdi3+0x6a>
  803728:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80372c:	0f 87 9e 00 00 00    	ja     8037d0 <__udivdi3+0x108>
  803732:	b8 01 00 00 00       	mov    $0x1,%eax
  803737:	89 fa                	mov    %edi,%edx
  803739:	83 c4 1c             	add    $0x1c,%esp
  80373c:	5b                   	pop    %ebx
  80373d:	5e                   	pop    %esi
  80373e:	5f                   	pop    %edi
  80373f:	5d                   	pop    %ebp
  803740:	c3                   	ret    
  803741:	8d 76 00             	lea    0x0(%esi),%esi
  803744:	31 ff                	xor    %edi,%edi
  803746:	31 c0                	xor    %eax,%eax
  803748:	89 fa                	mov    %edi,%edx
  80374a:	83 c4 1c             	add    $0x1c,%esp
  80374d:	5b                   	pop    %ebx
  80374e:	5e                   	pop    %esi
  80374f:	5f                   	pop    %edi
  803750:	5d                   	pop    %ebp
  803751:	c3                   	ret    
  803752:	66 90                	xchg   %ax,%ax
  803754:	89 d8                	mov    %ebx,%eax
  803756:	f7 f7                	div    %edi
  803758:	31 ff                	xor    %edi,%edi
  80375a:	89 fa                	mov    %edi,%edx
  80375c:	83 c4 1c             	add    $0x1c,%esp
  80375f:	5b                   	pop    %ebx
  803760:	5e                   	pop    %esi
  803761:	5f                   	pop    %edi
  803762:	5d                   	pop    %ebp
  803763:	c3                   	ret    
  803764:	bd 20 00 00 00       	mov    $0x20,%ebp
  803769:	89 eb                	mov    %ebp,%ebx
  80376b:	29 fb                	sub    %edi,%ebx
  80376d:	89 f9                	mov    %edi,%ecx
  80376f:	d3 e6                	shl    %cl,%esi
  803771:	89 c5                	mov    %eax,%ebp
  803773:	88 d9                	mov    %bl,%cl
  803775:	d3 ed                	shr    %cl,%ebp
  803777:	89 e9                	mov    %ebp,%ecx
  803779:	09 f1                	or     %esi,%ecx
  80377b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80377f:	89 f9                	mov    %edi,%ecx
  803781:	d3 e0                	shl    %cl,%eax
  803783:	89 c5                	mov    %eax,%ebp
  803785:	89 d6                	mov    %edx,%esi
  803787:	88 d9                	mov    %bl,%cl
  803789:	d3 ee                	shr    %cl,%esi
  80378b:	89 f9                	mov    %edi,%ecx
  80378d:	d3 e2                	shl    %cl,%edx
  80378f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803793:	88 d9                	mov    %bl,%cl
  803795:	d3 e8                	shr    %cl,%eax
  803797:	09 c2                	or     %eax,%edx
  803799:	89 d0                	mov    %edx,%eax
  80379b:	89 f2                	mov    %esi,%edx
  80379d:	f7 74 24 0c          	divl   0xc(%esp)
  8037a1:	89 d6                	mov    %edx,%esi
  8037a3:	89 c3                	mov    %eax,%ebx
  8037a5:	f7 e5                	mul    %ebp
  8037a7:	39 d6                	cmp    %edx,%esi
  8037a9:	72 19                	jb     8037c4 <__udivdi3+0xfc>
  8037ab:	74 0b                	je     8037b8 <__udivdi3+0xf0>
  8037ad:	89 d8                	mov    %ebx,%eax
  8037af:	31 ff                	xor    %edi,%edi
  8037b1:	e9 58 ff ff ff       	jmp    80370e <__udivdi3+0x46>
  8037b6:	66 90                	xchg   %ax,%ax
  8037b8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8037bc:	89 f9                	mov    %edi,%ecx
  8037be:	d3 e2                	shl    %cl,%edx
  8037c0:	39 c2                	cmp    %eax,%edx
  8037c2:	73 e9                	jae    8037ad <__udivdi3+0xe5>
  8037c4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8037c7:	31 ff                	xor    %edi,%edi
  8037c9:	e9 40 ff ff ff       	jmp    80370e <__udivdi3+0x46>
  8037ce:	66 90                	xchg   %ax,%ax
  8037d0:	31 c0                	xor    %eax,%eax
  8037d2:	e9 37 ff ff ff       	jmp    80370e <__udivdi3+0x46>
  8037d7:	90                   	nop

008037d8 <__umoddi3>:
  8037d8:	55                   	push   %ebp
  8037d9:	57                   	push   %edi
  8037da:	56                   	push   %esi
  8037db:	53                   	push   %ebx
  8037dc:	83 ec 1c             	sub    $0x1c,%esp
  8037df:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8037e3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8037e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8037eb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8037ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8037f3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8037f7:	89 f3                	mov    %esi,%ebx
  8037f9:	89 fa                	mov    %edi,%edx
  8037fb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037ff:	89 34 24             	mov    %esi,(%esp)
  803802:	85 c0                	test   %eax,%eax
  803804:	75 1a                	jne    803820 <__umoddi3+0x48>
  803806:	39 f7                	cmp    %esi,%edi
  803808:	0f 86 a2 00 00 00    	jbe    8038b0 <__umoddi3+0xd8>
  80380e:	89 c8                	mov    %ecx,%eax
  803810:	89 f2                	mov    %esi,%edx
  803812:	f7 f7                	div    %edi
  803814:	89 d0                	mov    %edx,%eax
  803816:	31 d2                	xor    %edx,%edx
  803818:	83 c4 1c             	add    $0x1c,%esp
  80381b:	5b                   	pop    %ebx
  80381c:	5e                   	pop    %esi
  80381d:	5f                   	pop    %edi
  80381e:	5d                   	pop    %ebp
  80381f:	c3                   	ret    
  803820:	39 f0                	cmp    %esi,%eax
  803822:	0f 87 ac 00 00 00    	ja     8038d4 <__umoddi3+0xfc>
  803828:	0f bd e8             	bsr    %eax,%ebp
  80382b:	83 f5 1f             	xor    $0x1f,%ebp
  80382e:	0f 84 ac 00 00 00    	je     8038e0 <__umoddi3+0x108>
  803834:	bf 20 00 00 00       	mov    $0x20,%edi
  803839:	29 ef                	sub    %ebp,%edi
  80383b:	89 fe                	mov    %edi,%esi
  80383d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803841:	89 e9                	mov    %ebp,%ecx
  803843:	d3 e0                	shl    %cl,%eax
  803845:	89 d7                	mov    %edx,%edi
  803847:	89 f1                	mov    %esi,%ecx
  803849:	d3 ef                	shr    %cl,%edi
  80384b:	09 c7                	or     %eax,%edi
  80384d:	89 e9                	mov    %ebp,%ecx
  80384f:	d3 e2                	shl    %cl,%edx
  803851:	89 14 24             	mov    %edx,(%esp)
  803854:	89 d8                	mov    %ebx,%eax
  803856:	d3 e0                	shl    %cl,%eax
  803858:	89 c2                	mov    %eax,%edx
  80385a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80385e:	d3 e0                	shl    %cl,%eax
  803860:	89 44 24 04          	mov    %eax,0x4(%esp)
  803864:	8b 44 24 08          	mov    0x8(%esp),%eax
  803868:	89 f1                	mov    %esi,%ecx
  80386a:	d3 e8                	shr    %cl,%eax
  80386c:	09 d0                	or     %edx,%eax
  80386e:	d3 eb                	shr    %cl,%ebx
  803870:	89 da                	mov    %ebx,%edx
  803872:	f7 f7                	div    %edi
  803874:	89 d3                	mov    %edx,%ebx
  803876:	f7 24 24             	mull   (%esp)
  803879:	89 c6                	mov    %eax,%esi
  80387b:	89 d1                	mov    %edx,%ecx
  80387d:	39 d3                	cmp    %edx,%ebx
  80387f:	0f 82 87 00 00 00    	jb     80390c <__umoddi3+0x134>
  803885:	0f 84 91 00 00 00    	je     80391c <__umoddi3+0x144>
  80388b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80388f:	29 f2                	sub    %esi,%edx
  803891:	19 cb                	sbb    %ecx,%ebx
  803893:	89 d8                	mov    %ebx,%eax
  803895:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803899:	d3 e0                	shl    %cl,%eax
  80389b:	89 e9                	mov    %ebp,%ecx
  80389d:	d3 ea                	shr    %cl,%edx
  80389f:	09 d0                	or     %edx,%eax
  8038a1:	89 e9                	mov    %ebp,%ecx
  8038a3:	d3 eb                	shr    %cl,%ebx
  8038a5:	89 da                	mov    %ebx,%edx
  8038a7:	83 c4 1c             	add    $0x1c,%esp
  8038aa:	5b                   	pop    %ebx
  8038ab:	5e                   	pop    %esi
  8038ac:	5f                   	pop    %edi
  8038ad:	5d                   	pop    %ebp
  8038ae:	c3                   	ret    
  8038af:	90                   	nop
  8038b0:	89 fd                	mov    %edi,%ebp
  8038b2:	85 ff                	test   %edi,%edi
  8038b4:	75 0b                	jne    8038c1 <__umoddi3+0xe9>
  8038b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8038bb:	31 d2                	xor    %edx,%edx
  8038bd:	f7 f7                	div    %edi
  8038bf:	89 c5                	mov    %eax,%ebp
  8038c1:	89 f0                	mov    %esi,%eax
  8038c3:	31 d2                	xor    %edx,%edx
  8038c5:	f7 f5                	div    %ebp
  8038c7:	89 c8                	mov    %ecx,%eax
  8038c9:	f7 f5                	div    %ebp
  8038cb:	89 d0                	mov    %edx,%eax
  8038cd:	e9 44 ff ff ff       	jmp    803816 <__umoddi3+0x3e>
  8038d2:	66 90                	xchg   %ax,%ax
  8038d4:	89 c8                	mov    %ecx,%eax
  8038d6:	89 f2                	mov    %esi,%edx
  8038d8:	83 c4 1c             	add    $0x1c,%esp
  8038db:	5b                   	pop    %ebx
  8038dc:	5e                   	pop    %esi
  8038dd:	5f                   	pop    %edi
  8038de:	5d                   	pop    %ebp
  8038df:	c3                   	ret    
  8038e0:	3b 04 24             	cmp    (%esp),%eax
  8038e3:	72 06                	jb     8038eb <__umoddi3+0x113>
  8038e5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8038e9:	77 0f                	ja     8038fa <__umoddi3+0x122>
  8038eb:	89 f2                	mov    %esi,%edx
  8038ed:	29 f9                	sub    %edi,%ecx
  8038ef:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8038f3:	89 14 24             	mov    %edx,(%esp)
  8038f6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8038fa:	8b 44 24 04          	mov    0x4(%esp),%eax
  8038fe:	8b 14 24             	mov    (%esp),%edx
  803901:	83 c4 1c             	add    $0x1c,%esp
  803904:	5b                   	pop    %ebx
  803905:	5e                   	pop    %esi
  803906:	5f                   	pop    %edi
  803907:	5d                   	pop    %ebp
  803908:	c3                   	ret    
  803909:	8d 76 00             	lea    0x0(%esi),%esi
  80390c:	2b 04 24             	sub    (%esp),%eax
  80390f:	19 fa                	sbb    %edi,%edx
  803911:	89 d1                	mov    %edx,%ecx
  803913:	89 c6                	mov    %eax,%esi
  803915:	e9 71 ff ff ff       	jmp    80388b <__umoddi3+0xb3>
  80391a:	66 90                	xchg   %ax,%ax
  80391c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803920:	72 ea                	jb     80390c <__umoddi3+0x134>
  803922:	89 d9                	mov    %ebx,%ecx
  803924:	e9 62 ff ff ff       	jmp    80388b <__umoddi3+0xb3>

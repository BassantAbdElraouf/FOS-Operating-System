
obj/user/ef_mergesort_noleakage:     file format elf32-i386


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
  800031:	e8 81 07 00 00       	call   8007b7 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void Merge(int* A, int p, int q, int r);

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
  800041:	e8 ea 1f 00 00       	call   802030 <sys_disable_interrupt>

		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 00 39 80 00       	push   $0x803900
  80004e:	e8 54 0b 00 00       	call   800ba7 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 02 39 80 00       	push   $0x803902
  80005e:	e8 44 0b 00 00       	call   800ba7 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 18 39 80 00       	push   $0x803918
  80006e:	e8 34 0b 00 00       	call   800ba7 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 02 39 80 00       	push   $0x803902
  80007e:	e8 24 0b 00 00       	call   800ba7 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 00 39 80 00       	push   $0x803900
  80008e:	e8 14 0b 00 00       	call   800ba7 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
		//readline("Enter the number of elements: ", Line);
		cprintf("Enter the number of elements: ");
  800096:	83 ec 0c             	sub    $0xc,%esp
  800099:	68 30 39 80 00       	push   $0x803930
  80009e:	e8 04 0b 00 00       	call   800ba7 <cprintf>
  8000a3:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = 2000 ;
  8000a6:	c7 45 f0 d0 07 00 00 	movl   $0x7d0,-0x10(%ebp)
		cprintf("%d\n", NumOfElements) ;
  8000ad:	83 ec 08             	sub    $0x8,%esp
  8000b0:	ff 75 f0             	pushl  -0x10(%ebp)
  8000b3:	68 4f 39 80 00       	push   $0x80394f
  8000b8:	e8 ea 0a 00 00       	call   800ba7 <cprintf>
  8000bd:	83 c4 10             	add    $0x10,%esp

		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c3:	c1 e0 02             	shl    $0x2,%eax
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	50                   	push   %eax
  8000ca:	e8 07 1a 00 00       	call   801ad6 <malloc>
  8000cf:	83 c4 10             	add    $0x10,%esp
  8000d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000d5:	83 ec 0c             	sub    $0xc,%esp
  8000d8:	68 54 39 80 00       	push   $0x803954
  8000dd:	e8 c5 0a 00 00       	call   800ba7 <cprintf>
  8000e2:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	68 76 39 80 00       	push   $0x803976
  8000ed:	e8 b5 0a 00 00       	call   800ba7 <cprintf>
  8000f2:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000f5:	83 ec 0c             	sub    $0xc,%esp
  8000f8:	68 84 39 80 00       	push   $0x803984
  8000fd:	e8 a5 0a 00 00       	call   800ba7 <cprintf>
  800102:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  800105:	83 ec 0c             	sub    $0xc,%esp
  800108:	68 93 39 80 00       	push   $0x803993
  80010d:	e8 95 0a 00 00       	call   800ba7 <cprintf>
  800112:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800115:	83 ec 0c             	sub    $0xc,%esp
  800118:	68 a3 39 80 00       	push   $0x8039a3
  80011d:	e8 85 0a 00 00       	call   800ba7 <cprintf>
  800122:	83 c4 10             	add    $0x10,%esp
			//Chose = getchar() ;
			Chose = 'a';
  800125:	c6 45 f7 61          	movb   $0x61,-0x9(%ebp)
			cputchar(Chose);
  800129:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80012d:	83 ec 0c             	sub    $0xc,%esp
  800130:	50                   	push   %eax
  800131:	e8 e1 05 00 00       	call   800717 <cputchar>
  800136:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800139:	83 ec 0c             	sub    $0xc,%esp
  80013c:	6a 0a                	push   $0xa
  80013e:	e8 d4 05 00 00       	call   800717 <cputchar>
  800143:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800146:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  80014a:	74 0c                	je     800158 <_main+0x120>
  80014c:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  800150:	74 06                	je     800158 <_main+0x120>
  800152:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800156:	75 bd                	jne    800115 <_main+0xdd>

		//2012: lock the interrupt
		sys_enable_interrupt();
  800158:	e8 ed 1e 00 00       	call   80204a <sys_enable_interrupt>

		int  i ;
		switch (Chose)
  80015d:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800161:	83 f8 62             	cmp    $0x62,%eax
  800164:	74 1d                	je     800183 <_main+0x14b>
  800166:	83 f8 63             	cmp    $0x63,%eax
  800169:	74 2b                	je     800196 <_main+0x15e>
  80016b:	83 f8 61             	cmp    $0x61,%eax
  80016e:	75 39                	jne    8001a9 <_main+0x171>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  800170:	83 ec 08             	sub    $0x8,%esp
  800173:	ff 75 f0             	pushl  -0x10(%ebp)
  800176:	ff 75 ec             	pushl  -0x14(%ebp)
  800179:	e8 f0 01 00 00       	call   80036e <InitializeAscending>
  80017e:	83 c4 10             	add    $0x10,%esp
			break ;
  800181:	eb 37                	jmp    8001ba <_main+0x182>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  800183:	83 ec 08             	sub    $0x8,%esp
  800186:	ff 75 f0             	pushl  -0x10(%ebp)
  800189:	ff 75 ec             	pushl  -0x14(%ebp)
  80018c:	e8 0e 02 00 00       	call   80039f <InitializeDescending>
  800191:	83 c4 10             	add    $0x10,%esp
			break ;
  800194:	eb 24                	jmp    8001ba <_main+0x182>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  800196:	83 ec 08             	sub    $0x8,%esp
  800199:	ff 75 f0             	pushl  -0x10(%ebp)
  80019c:	ff 75 ec             	pushl  -0x14(%ebp)
  80019f:	e8 30 02 00 00       	call   8003d4 <InitializeSemiRandom>
  8001a4:	83 c4 10             	add    $0x10,%esp
			break ;
  8001a7:	eb 11                	jmp    8001ba <_main+0x182>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001a9:	83 ec 08             	sub    $0x8,%esp
  8001ac:	ff 75 f0             	pushl  -0x10(%ebp)
  8001af:	ff 75 ec             	pushl  -0x14(%ebp)
  8001b2:	e8 1d 02 00 00       	call   8003d4 <InitializeSemiRandom>
  8001b7:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001ba:	83 ec 04             	sub    $0x4,%esp
  8001bd:	ff 75 f0             	pushl  -0x10(%ebp)
  8001c0:	6a 01                	push   $0x1
  8001c2:	ff 75 ec             	pushl  -0x14(%ebp)
  8001c5:	e8 dc 02 00 00       	call   8004a6 <MSort>
  8001ca:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001cd:	e8 5e 1e 00 00       	call   802030 <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001d2:	83 ec 0c             	sub    $0xc,%esp
  8001d5:	68 ac 39 80 00       	push   $0x8039ac
  8001da:	e8 c8 09 00 00       	call   800ba7 <cprintf>
  8001df:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001e2:	e8 63 1e 00 00       	call   80204a <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001e7:	83 ec 08             	sub    $0x8,%esp
  8001ea:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ed:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f0:	e8 cf 00 00 00       	call   8002c4 <CheckSorted>
  8001f5:	83 c4 10             	add    $0x10,%esp
  8001f8:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001fb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8001ff:	75 14                	jne    800215 <_main+0x1dd>
  800201:	83 ec 04             	sub    $0x4,%esp
  800204:	68 e0 39 80 00       	push   $0x8039e0
  800209:	6a 4e                	push   $0x4e
  80020b:	68 02 3a 80 00       	push   $0x803a02
  800210:	e8 de 06 00 00       	call   8008f3 <_panic>
		else
		{
			sys_disable_interrupt();
  800215:	e8 16 1e 00 00       	call   802030 <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	68 20 3a 80 00       	push   $0x803a20
  800222:	e8 80 09 00 00       	call   800ba7 <cprintf>
  800227:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  80022a:	83 ec 0c             	sub    $0xc,%esp
  80022d:	68 54 3a 80 00       	push   $0x803a54
  800232:	e8 70 09 00 00       	call   800ba7 <cprintf>
  800237:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  80023a:	83 ec 0c             	sub    $0xc,%esp
  80023d:	68 88 3a 80 00       	push   $0x803a88
  800242:	e8 60 09 00 00       	call   800ba7 <cprintf>
  800247:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  80024a:	e8 fb 1d 00 00       	call   80204a <sys_enable_interrupt>
		}

		free(Elements) ;
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	ff 75 ec             	pushl  -0x14(%ebp)
  800255:	e8 fe 18 00 00       	call   801b58 <free>
  80025a:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  80025d:	e8 ce 1d 00 00       	call   802030 <sys_disable_interrupt>
			Chose = 0 ;
  800262:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800266:	eb 3e                	jmp    8002a6 <_main+0x26e>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800268:	83 ec 0c             	sub    $0xc,%esp
  80026b:	68 ba 3a 80 00       	push   $0x803aba
  800270:	e8 32 09 00 00       	call   800ba7 <cprintf>
  800275:	83 c4 10             	add    $0x10,%esp
				Chose = 'n' ;
  800278:	c6 45 f7 6e          	movb   $0x6e,-0x9(%ebp)
				cputchar(Chose);
  80027c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800280:	83 ec 0c             	sub    $0xc,%esp
  800283:	50                   	push   %eax
  800284:	e8 8e 04 00 00       	call   800717 <cputchar>
  800289:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	6a 0a                	push   $0xa
  800291:	e8 81 04 00 00       	call   800717 <cputchar>
  800296:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800299:	83 ec 0c             	sub    $0xc,%esp
  80029c:	6a 0a                	push   $0xa
  80029e:	e8 74 04 00 00       	call   800717 <cputchar>
  8002a3:	83 c4 10             	add    $0x10,%esp

		free(Elements) ;

		sys_disable_interrupt();
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002a6:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002aa:	74 06                	je     8002b2 <_main+0x27a>
  8002ac:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002b0:	75 b6                	jne    800268 <_main+0x230>
				Chose = 'n' ;
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		sys_enable_interrupt();
  8002b2:	e8 93 1d 00 00       	call   80204a <sys_enable_interrupt>

	} while (Chose == 'y');
  8002b7:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002bb:	0f 84 80 fd ff ff    	je     800041 <_main+0x9>
}
  8002c1:	90                   	nop
  8002c2:	c9                   	leave  
  8002c3:	c3                   	ret    

008002c4 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002c4:	55                   	push   %ebp
  8002c5:	89 e5                	mov    %esp,%ebp
  8002c7:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8002ca:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8002d1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8002d8:	eb 33                	jmp    80030d <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8002da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e7:	01 d0                	add    %edx,%eax
  8002e9:	8b 10                	mov    (%eax),%edx
  8002eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002ee:	40                   	inc    %eax
  8002ef:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f9:	01 c8                	add    %ecx,%eax
  8002fb:	8b 00                	mov    (%eax),%eax
  8002fd:	39 c2                	cmp    %eax,%edx
  8002ff:	7e 09                	jle    80030a <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800301:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800308:	eb 0c                	jmp    800316 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80030a:	ff 45 f8             	incl   -0x8(%ebp)
  80030d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800310:	48                   	dec    %eax
  800311:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800314:	7f c4                	jg     8002da <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800316:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800319:	c9                   	leave  
  80031a:	c3                   	ret    

0080031b <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80031b:	55                   	push   %ebp
  80031c:	89 e5                	mov    %esp,%ebp
  80031e:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800321:	8b 45 0c             	mov    0xc(%ebp),%eax
  800324:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80032b:	8b 45 08             	mov    0x8(%ebp),%eax
  80032e:	01 d0                	add    %edx,%eax
  800330:	8b 00                	mov    (%eax),%eax
  800332:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800335:	8b 45 0c             	mov    0xc(%ebp),%eax
  800338:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80033f:	8b 45 08             	mov    0x8(%ebp),%eax
  800342:	01 c2                	add    %eax,%edx
  800344:	8b 45 10             	mov    0x10(%ebp),%eax
  800347:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80034e:	8b 45 08             	mov    0x8(%ebp),%eax
  800351:	01 c8                	add    %ecx,%eax
  800353:	8b 00                	mov    (%eax),%eax
  800355:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800357:	8b 45 10             	mov    0x10(%ebp),%eax
  80035a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800361:	8b 45 08             	mov    0x8(%ebp),%eax
  800364:	01 c2                	add    %eax,%edx
  800366:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800369:	89 02                	mov    %eax,(%edx)
}
  80036b:	90                   	nop
  80036c:	c9                   	leave  
  80036d:	c3                   	ret    

0080036e <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80036e:	55                   	push   %ebp
  80036f:	89 e5                	mov    %esp,%ebp
  800371:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800374:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80037b:	eb 17                	jmp    800394 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80037d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800380:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800387:	8b 45 08             	mov    0x8(%ebp),%eax
  80038a:	01 c2                	add    %eax,%edx
  80038c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80038f:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800391:	ff 45 fc             	incl   -0x4(%ebp)
  800394:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800397:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80039a:	7c e1                	jl     80037d <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  80039c:	90                   	nop
  80039d:	c9                   	leave  
  80039e:	c3                   	ret    

0080039f <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  80039f:	55                   	push   %ebp
  8003a0:	89 e5                	mov    %esp,%ebp
  8003a2:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003ac:	eb 1b                	jmp    8003c9 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8003ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bb:	01 c2                	add    %eax,%edx
  8003bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c0:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003c3:	48                   	dec    %eax
  8003c4:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003c6:	ff 45 fc             	incl   -0x4(%ebp)
  8003c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003cf:	7c dd                	jl     8003ae <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8003d1:	90                   	nop
  8003d2:	c9                   	leave  
  8003d3:	c3                   	ret    

008003d4 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8003d4:	55                   	push   %ebp
  8003d5:	89 e5                	mov    %esp,%ebp
  8003d7:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8003da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003dd:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8003e2:	f7 e9                	imul   %ecx
  8003e4:	c1 f9 1f             	sar    $0x1f,%ecx
  8003e7:	89 d0                	mov    %edx,%eax
  8003e9:	29 c8                	sub    %ecx,%eax
  8003eb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8003ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003f5:	eb 1e                	jmp    800415 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  8003f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800401:	8b 45 08             	mov    0x8(%ebp),%eax
  800404:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800407:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80040a:	99                   	cltd   
  80040b:	f7 7d f8             	idivl  -0x8(%ebp)
  80040e:	89 d0                	mov    %edx,%eax
  800410:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800412:	ff 45 fc             	incl   -0x4(%ebp)
  800415:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800418:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80041b:	7c da                	jl     8003f7 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  80041d:	90                   	nop
  80041e:	c9                   	leave  
  80041f:	c3                   	ret    

00800420 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800420:	55                   	push   %ebp
  800421:	89 e5                	mov    %esp,%ebp
  800423:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800426:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80042d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800434:	eb 42                	jmp    800478 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800436:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800439:	99                   	cltd   
  80043a:	f7 7d f0             	idivl  -0x10(%ebp)
  80043d:	89 d0                	mov    %edx,%eax
  80043f:	85 c0                	test   %eax,%eax
  800441:	75 10                	jne    800453 <PrintElements+0x33>
			cprintf("\n");
  800443:	83 ec 0c             	sub    $0xc,%esp
  800446:	68 00 39 80 00       	push   $0x803900
  80044b:	e8 57 07 00 00       	call   800ba7 <cprintf>
  800450:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800456:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045d:	8b 45 08             	mov    0x8(%ebp),%eax
  800460:	01 d0                	add    %edx,%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	83 ec 08             	sub    $0x8,%esp
  800467:	50                   	push   %eax
  800468:	68 d8 3a 80 00       	push   $0x803ad8
  80046d:	e8 35 07 00 00       	call   800ba7 <cprintf>
  800472:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800475:	ff 45 f4             	incl   -0xc(%ebp)
  800478:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047b:	48                   	dec    %eax
  80047c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80047f:	7f b5                	jg     800436 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800484:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80048b:	8b 45 08             	mov    0x8(%ebp),%eax
  80048e:	01 d0                	add    %edx,%eax
  800490:	8b 00                	mov    (%eax),%eax
  800492:	83 ec 08             	sub    $0x8,%esp
  800495:	50                   	push   %eax
  800496:	68 4f 39 80 00       	push   $0x80394f
  80049b:	e8 07 07 00 00       	call   800ba7 <cprintf>
  8004a0:	83 c4 10             	add    $0x10,%esp

}
  8004a3:	90                   	nop
  8004a4:	c9                   	leave  
  8004a5:	c3                   	ret    

008004a6 <MSort>:


void MSort(int* A, int p, int r)
{
  8004a6:	55                   	push   %ebp
  8004a7:	89 e5                	mov    %esp,%ebp
  8004a9:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  8004ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004af:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004b2:	7d 54                	jge    800508 <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ba:	01 d0                	add    %edx,%eax
  8004bc:	89 c2                	mov    %eax,%edx
  8004be:	c1 ea 1f             	shr    $0x1f,%edx
  8004c1:	01 d0                	add    %edx,%eax
  8004c3:	d1 f8                	sar    %eax
  8004c5:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8004c8:	83 ec 04             	sub    $0x4,%esp
  8004cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8004ce:	ff 75 0c             	pushl  0xc(%ebp)
  8004d1:	ff 75 08             	pushl  0x8(%ebp)
  8004d4:	e8 cd ff ff ff       	call   8004a6 <MSort>
  8004d9:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  8004dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004df:	40                   	inc    %eax
  8004e0:	83 ec 04             	sub    $0x4,%esp
  8004e3:	ff 75 10             	pushl  0x10(%ebp)
  8004e6:	50                   	push   %eax
  8004e7:	ff 75 08             	pushl  0x8(%ebp)
  8004ea:	e8 b7 ff ff ff       	call   8004a6 <MSort>
  8004ef:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  8004f2:	ff 75 10             	pushl  0x10(%ebp)
  8004f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8004f8:	ff 75 0c             	pushl  0xc(%ebp)
  8004fb:	ff 75 08             	pushl  0x8(%ebp)
  8004fe:	e8 08 00 00 00       	call   80050b <Merge>
  800503:	83 c4 10             	add    $0x10,%esp
  800506:	eb 01                	jmp    800509 <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  800508:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  800509:	c9                   	leave  
  80050a:	c3                   	ret    

0080050b <Merge>:

void Merge(int* A, int p, int q, int r)
{
  80050b:	55                   	push   %ebp
  80050c:	89 e5                	mov    %esp,%ebp
  80050e:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  800511:	8b 45 10             	mov    0x10(%ebp),%eax
  800514:	2b 45 0c             	sub    0xc(%ebp),%eax
  800517:	40                   	inc    %eax
  800518:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  80051b:	8b 45 14             	mov    0x14(%ebp),%eax
  80051e:	2b 45 10             	sub    0x10(%ebp),%eax
  800521:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800524:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  80052b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int* Left = malloc(sizeof(int) * leftCapacity);
  800532:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800535:	c1 e0 02             	shl    $0x2,%eax
  800538:	83 ec 0c             	sub    $0xc,%esp
  80053b:	50                   	push   %eax
  80053c:	e8 95 15 00 00       	call   801ad6 <malloc>
  800541:	83 c4 10             	add    $0x10,%esp
  800544:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  800547:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80054a:	c1 e0 02             	shl    $0x2,%eax
  80054d:	83 ec 0c             	sub    $0xc,%esp
  800550:	50                   	push   %eax
  800551:	e8 80 15 00 00       	call   801ad6 <malloc>
  800556:	83 c4 10             	add    $0x10,%esp
  800559:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  80055c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800563:	eb 2f                	jmp    800594 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  800565:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800568:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80056f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800572:	01 c2                	add    %eax,%edx
  800574:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800577:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80057a:	01 c8                	add    %ecx,%eax
  80057c:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800581:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800588:	8b 45 08             	mov    0x8(%ebp),%eax
  80058b:	01 c8                	add    %ecx,%eax
  80058d:	8b 00                	mov    (%eax),%eax
  80058f:	89 02                	mov    %eax,(%edx)
	int* Left = malloc(sizeof(int) * leftCapacity);

	int* Right = malloc(sizeof(int) * rightCapacity);

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800591:	ff 45 ec             	incl   -0x14(%ebp)
  800594:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800597:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80059a:	7c c9                	jl     800565 <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  80059c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005a3:	eb 2a                	jmp    8005cf <Merge+0xc4>
	{
		Right[j] = A[q + j];
  8005a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005af:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005b2:	01 c2                	add    %eax,%edx
  8005b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005ba:	01 c8                	add    %ecx,%eax
  8005bc:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c6:	01 c8                	add    %ecx,%eax
  8005c8:	8b 00                	mov    (%eax),%eax
  8005ca:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005cc:	ff 45 e8             	incl   -0x18(%ebp)
  8005cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005d2:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005d5:	7c ce                	jl     8005a5 <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8005d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005dd:	e9 0a 01 00 00       	jmp    8006ec <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  8005e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005e5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005e8:	0f 8d 95 00 00 00    	jge    800683 <Merge+0x178>
  8005ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005f1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005f4:	0f 8d 89 00 00 00    	jge    800683 <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8005fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005fd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800604:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800607:	01 d0                	add    %edx,%eax
  800609:	8b 10                	mov    (%eax),%edx
  80060b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80060e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800615:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800618:	01 c8                	add    %ecx,%eax
  80061a:	8b 00                	mov    (%eax),%eax
  80061c:	39 c2                	cmp    %eax,%edx
  80061e:	7d 33                	jge    800653 <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  800620:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800623:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800628:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80062f:	8b 45 08             	mov    0x8(%ebp),%eax
  800632:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800638:	8d 50 01             	lea    0x1(%eax),%edx
  80063b:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80063e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800645:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800648:	01 d0                	add    %edx,%eax
  80064a:	8b 00                	mov    (%eax),%eax
  80064c:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80064e:	e9 96 00 00 00       	jmp    8006e9 <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  800653:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800656:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80065b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800662:	8b 45 08             	mov    0x8(%ebp),%eax
  800665:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800668:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80066b:	8d 50 01             	lea    0x1(%eax),%edx
  80066e:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800671:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800678:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80067b:	01 d0                	add    %edx,%eax
  80067d:	8b 00                	mov    (%eax),%eax
  80067f:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800681:	eb 66                	jmp    8006e9 <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  800683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800686:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800689:	7d 30                	jge    8006bb <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  80068b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80068e:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800693:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80069a:	8b 45 08             	mov    0x8(%ebp),%eax
  80069d:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006a3:	8d 50 01             	lea    0x1(%eax),%edx
  8006a6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8006a9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006b0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006b3:	01 d0                	add    %edx,%eax
  8006b5:	8b 00                	mov    (%eax),%eax
  8006b7:	89 01                	mov    %eax,(%ecx)
  8006b9:	eb 2e                	jmp    8006e9 <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  8006bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006be:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cd:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006d3:	8d 50 01             	lea    0x1(%eax),%edx
  8006d6:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8006d9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006e0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006e3:	01 d0                	add    %edx,%eax
  8006e5:	8b 00                	mov    (%eax),%eax
  8006e7:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8006e9:	ff 45 e4             	incl   -0x1c(%ebp)
  8006ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006ef:	3b 45 14             	cmp    0x14(%ebp),%eax
  8006f2:	0f 8e ea fe ff ff    	jle    8005e2 <Merge+0xd7>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

	free(Left);
  8006f8:	83 ec 0c             	sub    $0xc,%esp
  8006fb:	ff 75 d8             	pushl  -0x28(%ebp)
  8006fe:	e8 55 14 00 00       	call   801b58 <free>
  800703:	83 c4 10             	add    $0x10,%esp
	free(Right);
  800706:	83 ec 0c             	sub    $0xc,%esp
  800709:	ff 75 d4             	pushl  -0x2c(%ebp)
  80070c:	e8 47 14 00 00       	call   801b58 <free>
  800711:	83 c4 10             	add    $0x10,%esp

}
  800714:	90                   	nop
  800715:	c9                   	leave  
  800716:	c3                   	ret    

00800717 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800717:	55                   	push   %ebp
  800718:	89 e5                	mov    %esp,%ebp
  80071a:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  80071d:	8b 45 08             	mov    0x8(%ebp),%eax
  800720:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800723:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800727:	83 ec 0c             	sub    $0xc,%esp
  80072a:	50                   	push   %eax
  80072b:	e8 34 19 00 00       	call   802064 <sys_cputc>
  800730:	83 c4 10             	add    $0x10,%esp
}
  800733:	90                   	nop
  800734:	c9                   	leave  
  800735:	c3                   	ret    

00800736 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  800736:	55                   	push   %ebp
  800737:	89 e5                	mov    %esp,%ebp
  800739:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80073c:	e8 ef 18 00 00       	call   802030 <sys_disable_interrupt>
	char c = ch;
  800741:	8b 45 08             	mov    0x8(%ebp),%eax
  800744:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800747:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80074b:	83 ec 0c             	sub    $0xc,%esp
  80074e:	50                   	push   %eax
  80074f:	e8 10 19 00 00       	call   802064 <sys_cputc>
  800754:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800757:	e8 ee 18 00 00       	call   80204a <sys_enable_interrupt>
}
  80075c:	90                   	nop
  80075d:	c9                   	leave  
  80075e:	c3                   	ret    

0080075f <getchar>:

int
getchar(void)
{
  80075f:	55                   	push   %ebp
  800760:	89 e5                	mov    %esp,%ebp
  800762:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800765:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80076c:	eb 08                	jmp    800776 <getchar+0x17>
	{
		c = sys_cgetc();
  80076e:	e8 38 17 00 00       	call   801eab <sys_cgetc>
  800773:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800776:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80077a:	74 f2                	je     80076e <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  80077c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80077f:	c9                   	leave  
  800780:	c3                   	ret    

00800781 <atomic_getchar>:

int
atomic_getchar(void)
{
  800781:	55                   	push   %ebp
  800782:	89 e5                	mov    %esp,%ebp
  800784:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800787:	e8 a4 18 00 00       	call   802030 <sys_disable_interrupt>
	int c=0;
  80078c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800793:	eb 08                	jmp    80079d <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800795:	e8 11 17 00 00       	call   801eab <sys_cgetc>
  80079a:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  80079d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8007a1:	74 f2                	je     800795 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  8007a3:	e8 a2 18 00 00       	call   80204a <sys_enable_interrupt>
	return c;
  8007a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8007ab:	c9                   	leave  
  8007ac:	c3                   	ret    

008007ad <iscons>:

int iscons(int fdnum)
{
  8007ad:	55                   	push   %ebp
  8007ae:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8007b0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8007b5:	5d                   	pop    %ebp
  8007b6:	c3                   	ret    

008007b7 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8007b7:	55                   	push   %ebp
  8007b8:	89 e5                	mov    %esp,%ebp
  8007ba:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8007bd:	e8 61 1a 00 00       	call   802223 <sys_getenvindex>
  8007c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8007c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007c8:	89 d0                	mov    %edx,%eax
  8007ca:	c1 e0 03             	shl    $0x3,%eax
  8007cd:	01 d0                	add    %edx,%eax
  8007cf:	01 c0                	add    %eax,%eax
  8007d1:	01 d0                	add    %edx,%eax
  8007d3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007da:	01 d0                	add    %edx,%eax
  8007dc:	c1 e0 04             	shl    $0x4,%eax
  8007df:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8007e4:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8007e9:	a1 24 50 80 00       	mov    0x805024,%eax
  8007ee:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8007f4:	84 c0                	test   %al,%al
  8007f6:	74 0f                	je     800807 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8007f8:	a1 24 50 80 00       	mov    0x805024,%eax
  8007fd:	05 5c 05 00 00       	add    $0x55c,%eax
  800802:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800807:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80080b:	7e 0a                	jle    800817 <libmain+0x60>
		binaryname = argv[0];
  80080d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800810:	8b 00                	mov    (%eax),%eax
  800812:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800817:	83 ec 08             	sub    $0x8,%esp
  80081a:	ff 75 0c             	pushl  0xc(%ebp)
  80081d:	ff 75 08             	pushl  0x8(%ebp)
  800820:	e8 13 f8 ff ff       	call   800038 <_main>
  800825:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800828:	e8 03 18 00 00       	call   802030 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80082d:	83 ec 0c             	sub    $0xc,%esp
  800830:	68 f8 3a 80 00       	push   $0x803af8
  800835:	e8 6d 03 00 00       	call   800ba7 <cprintf>
  80083a:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80083d:	a1 24 50 80 00       	mov    0x805024,%eax
  800842:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800848:	a1 24 50 80 00       	mov    0x805024,%eax
  80084d:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800853:	83 ec 04             	sub    $0x4,%esp
  800856:	52                   	push   %edx
  800857:	50                   	push   %eax
  800858:	68 20 3b 80 00       	push   $0x803b20
  80085d:	e8 45 03 00 00       	call   800ba7 <cprintf>
  800862:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800865:	a1 24 50 80 00       	mov    0x805024,%eax
  80086a:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800870:	a1 24 50 80 00       	mov    0x805024,%eax
  800875:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80087b:	a1 24 50 80 00       	mov    0x805024,%eax
  800880:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800886:	51                   	push   %ecx
  800887:	52                   	push   %edx
  800888:	50                   	push   %eax
  800889:	68 48 3b 80 00       	push   $0x803b48
  80088e:	e8 14 03 00 00       	call   800ba7 <cprintf>
  800893:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800896:	a1 24 50 80 00       	mov    0x805024,%eax
  80089b:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8008a1:	83 ec 08             	sub    $0x8,%esp
  8008a4:	50                   	push   %eax
  8008a5:	68 a0 3b 80 00       	push   $0x803ba0
  8008aa:	e8 f8 02 00 00       	call   800ba7 <cprintf>
  8008af:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8008b2:	83 ec 0c             	sub    $0xc,%esp
  8008b5:	68 f8 3a 80 00       	push   $0x803af8
  8008ba:	e8 e8 02 00 00       	call   800ba7 <cprintf>
  8008bf:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8008c2:	e8 83 17 00 00       	call   80204a <sys_enable_interrupt>

	// exit gracefully
	exit();
  8008c7:	e8 19 00 00 00       	call   8008e5 <exit>
}
  8008cc:	90                   	nop
  8008cd:	c9                   	leave  
  8008ce:	c3                   	ret    

008008cf <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8008cf:	55                   	push   %ebp
  8008d0:	89 e5                	mov    %esp,%ebp
  8008d2:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8008d5:	83 ec 0c             	sub    $0xc,%esp
  8008d8:	6a 00                	push   $0x0
  8008da:	e8 10 19 00 00       	call   8021ef <sys_destroy_env>
  8008df:	83 c4 10             	add    $0x10,%esp
}
  8008e2:	90                   	nop
  8008e3:	c9                   	leave  
  8008e4:	c3                   	ret    

008008e5 <exit>:

void
exit(void)
{
  8008e5:	55                   	push   %ebp
  8008e6:	89 e5                	mov    %esp,%ebp
  8008e8:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8008eb:	e8 65 19 00 00       	call   802255 <sys_exit_env>
}
  8008f0:	90                   	nop
  8008f1:	c9                   	leave  
  8008f2:	c3                   	ret    

008008f3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8008f3:	55                   	push   %ebp
  8008f4:	89 e5                	mov    %esp,%ebp
  8008f6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8008f9:	8d 45 10             	lea    0x10(%ebp),%eax
  8008fc:	83 c0 04             	add    $0x4,%eax
  8008ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800902:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800907:	85 c0                	test   %eax,%eax
  800909:	74 16                	je     800921 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80090b:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800910:	83 ec 08             	sub    $0x8,%esp
  800913:	50                   	push   %eax
  800914:	68 b4 3b 80 00       	push   $0x803bb4
  800919:	e8 89 02 00 00       	call   800ba7 <cprintf>
  80091e:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800921:	a1 00 50 80 00       	mov    0x805000,%eax
  800926:	ff 75 0c             	pushl  0xc(%ebp)
  800929:	ff 75 08             	pushl  0x8(%ebp)
  80092c:	50                   	push   %eax
  80092d:	68 b9 3b 80 00       	push   $0x803bb9
  800932:	e8 70 02 00 00       	call   800ba7 <cprintf>
  800937:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80093a:	8b 45 10             	mov    0x10(%ebp),%eax
  80093d:	83 ec 08             	sub    $0x8,%esp
  800940:	ff 75 f4             	pushl  -0xc(%ebp)
  800943:	50                   	push   %eax
  800944:	e8 f3 01 00 00       	call   800b3c <vcprintf>
  800949:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80094c:	83 ec 08             	sub    $0x8,%esp
  80094f:	6a 00                	push   $0x0
  800951:	68 d5 3b 80 00       	push   $0x803bd5
  800956:	e8 e1 01 00 00       	call   800b3c <vcprintf>
  80095b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80095e:	e8 82 ff ff ff       	call   8008e5 <exit>

	// should not return here
	while (1) ;
  800963:	eb fe                	jmp    800963 <_panic+0x70>

00800965 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800965:	55                   	push   %ebp
  800966:	89 e5                	mov    %esp,%ebp
  800968:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80096b:	a1 24 50 80 00       	mov    0x805024,%eax
  800970:	8b 50 74             	mov    0x74(%eax),%edx
  800973:	8b 45 0c             	mov    0xc(%ebp),%eax
  800976:	39 c2                	cmp    %eax,%edx
  800978:	74 14                	je     80098e <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80097a:	83 ec 04             	sub    $0x4,%esp
  80097d:	68 d8 3b 80 00       	push   $0x803bd8
  800982:	6a 26                	push   $0x26
  800984:	68 24 3c 80 00       	push   $0x803c24
  800989:	e8 65 ff ff ff       	call   8008f3 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80098e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800995:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80099c:	e9 c2 00 00 00       	jmp    800a63 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8009a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009a4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ae:	01 d0                	add    %edx,%eax
  8009b0:	8b 00                	mov    (%eax),%eax
  8009b2:	85 c0                	test   %eax,%eax
  8009b4:	75 08                	jne    8009be <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8009b6:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8009b9:	e9 a2 00 00 00       	jmp    800a60 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8009be:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009c5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8009cc:	eb 69                	jmp    800a37 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8009ce:	a1 24 50 80 00       	mov    0x805024,%eax
  8009d3:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009d9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009dc:	89 d0                	mov    %edx,%eax
  8009de:	01 c0                	add    %eax,%eax
  8009e0:	01 d0                	add    %edx,%eax
  8009e2:	c1 e0 03             	shl    $0x3,%eax
  8009e5:	01 c8                	add    %ecx,%eax
  8009e7:	8a 40 04             	mov    0x4(%eax),%al
  8009ea:	84 c0                	test   %al,%al
  8009ec:	75 46                	jne    800a34 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009ee:	a1 24 50 80 00       	mov    0x805024,%eax
  8009f3:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009f9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009fc:	89 d0                	mov    %edx,%eax
  8009fe:	01 c0                	add    %eax,%eax
  800a00:	01 d0                	add    %edx,%eax
  800a02:	c1 e0 03             	shl    $0x3,%eax
  800a05:	01 c8                	add    %ecx,%eax
  800a07:	8b 00                	mov    (%eax),%eax
  800a09:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a0c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a0f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a14:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800a16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a19:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a20:	8b 45 08             	mov    0x8(%ebp),%eax
  800a23:	01 c8                	add    %ecx,%eax
  800a25:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a27:	39 c2                	cmp    %eax,%edx
  800a29:	75 09                	jne    800a34 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800a2b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a32:	eb 12                	jmp    800a46 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a34:	ff 45 e8             	incl   -0x18(%ebp)
  800a37:	a1 24 50 80 00       	mov    0x805024,%eax
  800a3c:	8b 50 74             	mov    0x74(%eax),%edx
  800a3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a42:	39 c2                	cmp    %eax,%edx
  800a44:	77 88                	ja     8009ce <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a46:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a4a:	75 14                	jne    800a60 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800a4c:	83 ec 04             	sub    $0x4,%esp
  800a4f:	68 30 3c 80 00       	push   $0x803c30
  800a54:	6a 3a                	push   $0x3a
  800a56:	68 24 3c 80 00       	push   $0x803c24
  800a5b:	e8 93 fe ff ff       	call   8008f3 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a60:	ff 45 f0             	incl   -0x10(%ebp)
  800a63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a66:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a69:	0f 8c 32 ff ff ff    	jl     8009a1 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a6f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a76:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a7d:	eb 26                	jmp    800aa5 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a7f:	a1 24 50 80 00       	mov    0x805024,%eax
  800a84:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800a8a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a8d:	89 d0                	mov    %edx,%eax
  800a8f:	01 c0                	add    %eax,%eax
  800a91:	01 d0                	add    %edx,%eax
  800a93:	c1 e0 03             	shl    $0x3,%eax
  800a96:	01 c8                	add    %ecx,%eax
  800a98:	8a 40 04             	mov    0x4(%eax),%al
  800a9b:	3c 01                	cmp    $0x1,%al
  800a9d:	75 03                	jne    800aa2 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800a9f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800aa2:	ff 45 e0             	incl   -0x20(%ebp)
  800aa5:	a1 24 50 80 00       	mov    0x805024,%eax
  800aaa:	8b 50 74             	mov    0x74(%eax),%edx
  800aad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ab0:	39 c2                	cmp    %eax,%edx
  800ab2:	77 cb                	ja     800a7f <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ab7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800aba:	74 14                	je     800ad0 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800abc:	83 ec 04             	sub    $0x4,%esp
  800abf:	68 84 3c 80 00       	push   $0x803c84
  800ac4:	6a 44                	push   $0x44
  800ac6:	68 24 3c 80 00       	push   $0x803c24
  800acb:	e8 23 fe ff ff       	call   8008f3 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800ad0:	90                   	nop
  800ad1:	c9                   	leave  
  800ad2:	c3                   	ret    

00800ad3 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800ad3:	55                   	push   %ebp
  800ad4:	89 e5                	mov    %esp,%ebp
  800ad6:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800ad9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800adc:	8b 00                	mov    (%eax),%eax
  800ade:	8d 48 01             	lea    0x1(%eax),%ecx
  800ae1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ae4:	89 0a                	mov    %ecx,(%edx)
  800ae6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ae9:	88 d1                	mov    %dl,%cl
  800aeb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aee:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800af2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af5:	8b 00                	mov    (%eax),%eax
  800af7:	3d ff 00 00 00       	cmp    $0xff,%eax
  800afc:	75 2c                	jne    800b2a <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800afe:	a0 28 50 80 00       	mov    0x805028,%al
  800b03:	0f b6 c0             	movzbl %al,%eax
  800b06:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b09:	8b 12                	mov    (%edx),%edx
  800b0b:	89 d1                	mov    %edx,%ecx
  800b0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b10:	83 c2 08             	add    $0x8,%edx
  800b13:	83 ec 04             	sub    $0x4,%esp
  800b16:	50                   	push   %eax
  800b17:	51                   	push   %ecx
  800b18:	52                   	push   %edx
  800b19:	e8 64 13 00 00       	call   801e82 <sys_cputs>
  800b1e:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b24:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2d:	8b 40 04             	mov    0x4(%eax),%eax
  800b30:	8d 50 01             	lea    0x1(%eax),%edx
  800b33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b36:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b39:	90                   	nop
  800b3a:	c9                   	leave  
  800b3b:	c3                   	ret    

00800b3c <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b3c:	55                   	push   %ebp
  800b3d:	89 e5                	mov    %esp,%ebp
  800b3f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b45:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b4c:	00 00 00 
	b.cnt = 0;
  800b4f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b56:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b59:	ff 75 0c             	pushl  0xc(%ebp)
  800b5c:	ff 75 08             	pushl  0x8(%ebp)
  800b5f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b65:	50                   	push   %eax
  800b66:	68 d3 0a 80 00       	push   $0x800ad3
  800b6b:	e8 11 02 00 00       	call   800d81 <vprintfmt>
  800b70:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800b73:	a0 28 50 80 00       	mov    0x805028,%al
  800b78:	0f b6 c0             	movzbl %al,%eax
  800b7b:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b81:	83 ec 04             	sub    $0x4,%esp
  800b84:	50                   	push   %eax
  800b85:	52                   	push   %edx
  800b86:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b8c:	83 c0 08             	add    $0x8,%eax
  800b8f:	50                   	push   %eax
  800b90:	e8 ed 12 00 00       	call   801e82 <sys_cputs>
  800b95:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800b98:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800b9f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800ba5:	c9                   	leave  
  800ba6:	c3                   	ret    

00800ba7 <cprintf>:

int cprintf(const char *fmt, ...) {
  800ba7:	55                   	push   %ebp
  800ba8:	89 e5                	mov    %esp,%ebp
  800baa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800bad:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800bb4:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bba:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbd:	83 ec 08             	sub    $0x8,%esp
  800bc0:	ff 75 f4             	pushl  -0xc(%ebp)
  800bc3:	50                   	push   %eax
  800bc4:	e8 73 ff ff ff       	call   800b3c <vcprintf>
  800bc9:	83 c4 10             	add    $0x10,%esp
  800bcc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800bcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bd2:	c9                   	leave  
  800bd3:	c3                   	ret    

00800bd4 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800bd4:	55                   	push   %ebp
  800bd5:	89 e5                	mov    %esp,%ebp
  800bd7:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800bda:	e8 51 14 00 00       	call   802030 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800bdf:	8d 45 0c             	lea    0xc(%ebp),%eax
  800be2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800be5:	8b 45 08             	mov    0x8(%ebp),%eax
  800be8:	83 ec 08             	sub    $0x8,%esp
  800beb:	ff 75 f4             	pushl  -0xc(%ebp)
  800bee:	50                   	push   %eax
  800bef:	e8 48 ff ff ff       	call   800b3c <vcprintf>
  800bf4:	83 c4 10             	add    $0x10,%esp
  800bf7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800bfa:	e8 4b 14 00 00       	call   80204a <sys_enable_interrupt>
	return cnt;
  800bff:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c02:	c9                   	leave  
  800c03:	c3                   	ret    

00800c04 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c04:	55                   	push   %ebp
  800c05:	89 e5                	mov    %esp,%ebp
  800c07:	53                   	push   %ebx
  800c08:	83 ec 14             	sub    $0x14,%esp
  800c0b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c11:	8b 45 14             	mov    0x14(%ebp),%eax
  800c14:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c17:	8b 45 18             	mov    0x18(%ebp),%eax
  800c1a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c1f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c22:	77 55                	ja     800c79 <printnum+0x75>
  800c24:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c27:	72 05                	jb     800c2e <printnum+0x2a>
  800c29:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c2c:	77 4b                	ja     800c79 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c2e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800c31:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800c34:	8b 45 18             	mov    0x18(%ebp),%eax
  800c37:	ba 00 00 00 00       	mov    $0x0,%edx
  800c3c:	52                   	push   %edx
  800c3d:	50                   	push   %eax
  800c3e:	ff 75 f4             	pushl  -0xc(%ebp)
  800c41:	ff 75 f0             	pushl  -0x10(%ebp)
  800c44:	e8 47 2a 00 00       	call   803690 <__udivdi3>
  800c49:	83 c4 10             	add    $0x10,%esp
  800c4c:	83 ec 04             	sub    $0x4,%esp
  800c4f:	ff 75 20             	pushl  0x20(%ebp)
  800c52:	53                   	push   %ebx
  800c53:	ff 75 18             	pushl  0x18(%ebp)
  800c56:	52                   	push   %edx
  800c57:	50                   	push   %eax
  800c58:	ff 75 0c             	pushl  0xc(%ebp)
  800c5b:	ff 75 08             	pushl  0x8(%ebp)
  800c5e:	e8 a1 ff ff ff       	call   800c04 <printnum>
  800c63:	83 c4 20             	add    $0x20,%esp
  800c66:	eb 1a                	jmp    800c82 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c68:	83 ec 08             	sub    $0x8,%esp
  800c6b:	ff 75 0c             	pushl  0xc(%ebp)
  800c6e:	ff 75 20             	pushl  0x20(%ebp)
  800c71:	8b 45 08             	mov    0x8(%ebp),%eax
  800c74:	ff d0                	call   *%eax
  800c76:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c79:	ff 4d 1c             	decl   0x1c(%ebp)
  800c7c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c80:	7f e6                	jg     800c68 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c82:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c85:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c90:	53                   	push   %ebx
  800c91:	51                   	push   %ecx
  800c92:	52                   	push   %edx
  800c93:	50                   	push   %eax
  800c94:	e8 07 2b 00 00       	call   8037a0 <__umoddi3>
  800c99:	83 c4 10             	add    $0x10,%esp
  800c9c:	05 f4 3e 80 00       	add    $0x803ef4,%eax
  800ca1:	8a 00                	mov    (%eax),%al
  800ca3:	0f be c0             	movsbl %al,%eax
  800ca6:	83 ec 08             	sub    $0x8,%esp
  800ca9:	ff 75 0c             	pushl  0xc(%ebp)
  800cac:	50                   	push   %eax
  800cad:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb0:	ff d0                	call   *%eax
  800cb2:	83 c4 10             	add    $0x10,%esp
}
  800cb5:	90                   	nop
  800cb6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800cb9:	c9                   	leave  
  800cba:	c3                   	ret    

00800cbb <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800cbb:	55                   	push   %ebp
  800cbc:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800cbe:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800cc2:	7e 1c                	jle    800ce0 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc7:	8b 00                	mov    (%eax),%eax
  800cc9:	8d 50 08             	lea    0x8(%eax),%edx
  800ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccf:	89 10                	mov    %edx,(%eax)
  800cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd4:	8b 00                	mov    (%eax),%eax
  800cd6:	83 e8 08             	sub    $0x8,%eax
  800cd9:	8b 50 04             	mov    0x4(%eax),%edx
  800cdc:	8b 00                	mov    (%eax),%eax
  800cde:	eb 40                	jmp    800d20 <getuint+0x65>
	else if (lflag)
  800ce0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ce4:	74 1e                	je     800d04 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce9:	8b 00                	mov    (%eax),%eax
  800ceb:	8d 50 04             	lea    0x4(%eax),%edx
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf1:	89 10                	mov    %edx,(%eax)
  800cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf6:	8b 00                	mov    (%eax),%eax
  800cf8:	83 e8 04             	sub    $0x4,%eax
  800cfb:	8b 00                	mov    (%eax),%eax
  800cfd:	ba 00 00 00 00       	mov    $0x0,%edx
  800d02:	eb 1c                	jmp    800d20 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800d04:	8b 45 08             	mov    0x8(%ebp),%eax
  800d07:	8b 00                	mov    (%eax),%eax
  800d09:	8d 50 04             	lea    0x4(%eax),%edx
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0f:	89 10                	mov    %edx,(%eax)
  800d11:	8b 45 08             	mov    0x8(%ebp),%eax
  800d14:	8b 00                	mov    (%eax),%eax
  800d16:	83 e8 04             	sub    $0x4,%eax
  800d19:	8b 00                	mov    (%eax),%eax
  800d1b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800d20:	5d                   	pop    %ebp
  800d21:	c3                   	ret    

00800d22 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800d22:	55                   	push   %ebp
  800d23:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d25:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d29:	7e 1c                	jle    800d47 <getint+0x25>
		return va_arg(*ap, long long);
  800d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2e:	8b 00                	mov    (%eax),%eax
  800d30:	8d 50 08             	lea    0x8(%eax),%edx
  800d33:	8b 45 08             	mov    0x8(%ebp),%eax
  800d36:	89 10                	mov    %edx,(%eax)
  800d38:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3b:	8b 00                	mov    (%eax),%eax
  800d3d:	83 e8 08             	sub    $0x8,%eax
  800d40:	8b 50 04             	mov    0x4(%eax),%edx
  800d43:	8b 00                	mov    (%eax),%eax
  800d45:	eb 38                	jmp    800d7f <getint+0x5d>
	else if (lflag)
  800d47:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d4b:	74 1a                	je     800d67 <getint+0x45>
		return va_arg(*ap, long);
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	8b 00                	mov    (%eax),%eax
  800d52:	8d 50 04             	lea    0x4(%eax),%edx
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	89 10                	mov    %edx,(%eax)
  800d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5d:	8b 00                	mov    (%eax),%eax
  800d5f:	83 e8 04             	sub    $0x4,%eax
  800d62:	8b 00                	mov    (%eax),%eax
  800d64:	99                   	cltd   
  800d65:	eb 18                	jmp    800d7f <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	8b 00                	mov    (%eax),%eax
  800d6c:	8d 50 04             	lea    0x4(%eax),%edx
  800d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d72:	89 10                	mov    %edx,(%eax)
  800d74:	8b 45 08             	mov    0x8(%ebp),%eax
  800d77:	8b 00                	mov    (%eax),%eax
  800d79:	83 e8 04             	sub    $0x4,%eax
  800d7c:	8b 00                	mov    (%eax),%eax
  800d7e:	99                   	cltd   
}
  800d7f:	5d                   	pop    %ebp
  800d80:	c3                   	ret    

00800d81 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d81:	55                   	push   %ebp
  800d82:	89 e5                	mov    %esp,%ebp
  800d84:	56                   	push   %esi
  800d85:	53                   	push   %ebx
  800d86:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d89:	eb 17                	jmp    800da2 <vprintfmt+0x21>
			if (ch == '\0')
  800d8b:	85 db                	test   %ebx,%ebx
  800d8d:	0f 84 af 03 00 00    	je     801142 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800d93:	83 ec 08             	sub    $0x8,%esp
  800d96:	ff 75 0c             	pushl  0xc(%ebp)
  800d99:	53                   	push   %ebx
  800d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9d:	ff d0                	call   *%eax
  800d9f:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800da2:	8b 45 10             	mov    0x10(%ebp),%eax
  800da5:	8d 50 01             	lea    0x1(%eax),%edx
  800da8:	89 55 10             	mov    %edx,0x10(%ebp)
  800dab:	8a 00                	mov    (%eax),%al
  800dad:	0f b6 d8             	movzbl %al,%ebx
  800db0:	83 fb 25             	cmp    $0x25,%ebx
  800db3:	75 d6                	jne    800d8b <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800db5:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800db9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800dc0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800dc7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800dce:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800dd5:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd8:	8d 50 01             	lea    0x1(%eax),%edx
  800ddb:	89 55 10             	mov    %edx,0x10(%ebp)
  800dde:	8a 00                	mov    (%eax),%al
  800de0:	0f b6 d8             	movzbl %al,%ebx
  800de3:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800de6:	83 f8 55             	cmp    $0x55,%eax
  800de9:	0f 87 2b 03 00 00    	ja     80111a <vprintfmt+0x399>
  800def:	8b 04 85 18 3f 80 00 	mov    0x803f18(,%eax,4),%eax
  800df6:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800df8:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800dfc:	eb d7                	jmp    800dd5 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800dfe:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800e02:	eb d1                	jmp    800dd5 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e04:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800e0b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e0e:	89 d0                	mov    %edx,%eax
  800e10:	c1 e0 02             	shl    $0x2,%eax
  800e13:	01 d0                	add    %edx,%eax
  800e15:	01 c0                	add    %eax,%eax
  800e17:	01 d8                	add    %ebx,%eax
  800e19:	83 e8 30             	sub    $0x30,%eax
  800e1c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800e1f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e22:	8a 00                	mov    (%eax),%al
  800e24:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e27:	83 fb 2f             	cmp    $0x2f,%ebx
  800e2a:	7e 3e                	jle    800e6a <vprintfmt+0xe9>
  800e2c:	83 fb 39             	cmp    $0x39,%ebx
  800e2f:	7f 39                	jg     800e6a <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e31:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e34:	eb d5                	jmp    800e0b <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800e36:	8b 45 14             	mov    0x14(%ebp),%eax
  800e39:	83 c0 04             	add    $0x4,%eax
  800e3c:	89 45 14             	mov    %eax,0x14(%ebp)
  800e3f:	8b 45 14             	mov    0x14(%ebp),%eax
  800e42:	83 e8 04             	sub    $0x4,%eax
  800e45:	8b 00                	mov    (%eax),%eax
  800e47:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800e4a:	eb 1f                	jmp    800e6b <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800e4c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e50:	79 83                	jns    800dd5 <vprintfmt+0x54>
				width = 0;
  800e52:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e59:	e9 77 ff ff ff       	jmp    800dd5 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e5e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e65:	e9 6b ff ff ff       	jmp    800dd5 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e6a:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e6b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e6f:	0f 89 60 ff ff ff    	jns    800dd5 <vprintfmt+0x54>
				width = precision, precision = -1;
  800e75:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e78:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e7b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e82:	e9 4e ff ff ff       	jmp    800dd5 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e87:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e8a:	e9 46 ff ff ff       	jmp    800dd5 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e8f:	8b 45 14             	mov    0x14(%ebp),%eax
  800e92:	83 c0 04             	add    $0x4,%eax
  800e95:	89 45 14             	mov    %eax,0x14(%ebp)
  800e98:	8b 45 14             	mov    0x14(%ebp),%eax
  800e9b:	83 e8 04             	sub    $0x4,%eax
  800e9e:	8b 00                	mov    (%eax),%eax
  800ea0:	83 ec 08             	sub    $0x8,%esp
  800ea3:	ff 75 0c             	pushl  0xc(%ebp)
  800ea6:	50                   	push   %eax
  800ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaa:	ff d0                	call   *%eax
  800eac:	83 c4 10             	add    $0x10,%esp
			break;
  800eaf:	e9 89 02 00 00       	jmp    80113d <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800eb4:	8b 45 14             	mov    0x14(%ebp),%eax
  800eb7:	83 c0 04             	add    $0x4,%eax
  800eba:	89 45 14             	mov    %eax,0x14(%ebp)
  800ebd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec0:	83 e8 04             	sub    $0x4,%eax
  800ec3:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ec5:	85 db                	test   %ebx,%ebx
  800ec7:	79 02                	jns    800ecb <vprintfmt+0x14a>
				err = -err;
  800ec9:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ecb:	83 fb 64             	cmp    $0x64,%ebx
  800ece:	7f 0b                	jg     800edb <vprintfmt+0x15a>
  800ed0:	8b 34 9d 60 3d 80 00 	mov    0x803d60(,%ebx,4),%esi
  800ed7:	85 f6                	test   %esi,%esi
  800ed9:	75 19                	jne    800ef4 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800edb:	53                   	push   %ebx
  800edc:	68 05 3f 80 00       	push   $0x803f05
  800ee1:	ff 75 0c             	pushl  0xc(%ebp)
  800ee4:	ff 75 08             	pushl  0x8(%ebp)
  800ee7:	e8 5e 02 00 00       	call   80114a <printfmt>
  800eec:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800eef:	e9 49 02 00 00       	jmp    80113d <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ef4:	56                   	push   %esi
  800ef5:	68 0e 3f 80 00       	push   $0x803f0e
  800efa:	ff 75 0c             	pushl  0xc(%ebp)
  800efd:	ff 75 08             	pushl  0x8(%ebp)
  800f00:	e8 45 02 00 00       	call   80114a <printfmt>
  800f05:	83 c4 10             	add    $0x10,%esp
			break;
  800f08:	e9 30 02 00 00       	jmp    80113d <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800f0d:	8b 45 14             	mov    0x14(%ebp),%eax
  800f10:	83 c0 04             	add    $0x4,%eax
  800f13:	89 45 14             	mov    %eax,0x14(%ebp)
  800f16:	8b 45 14             	mov    0x14(%ebp),%eax
  800f19:	83 e8 04             	sub    $0x4,%eax
  800f1c:	8b 30                	mov    (%eax),%esi
  800f1e:	85 f6                	test   %esi,%esi
  800f20:	75 05                	jne    800f27 <vprintfmt+0x1a6>
				p = "(null)";
  800f22:	be 11 3f 80 00       	mov    $0x803f11,%esi
			if (width > 0 && padc != '-')
  800f27:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f2b:	7e 6d                	jle    800f9a <vprintfmt+0x219>
  800f2d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800f31:	74 67                	je     800f9a <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800f33:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f36:	83 ec 08             	sub    $0x8,%esp
  800f39:	50                   	push   %eax
  800f3a:	56                   	push   %esi
  800f3b:	e8 0c 03 00 00       	call   80124c <strnlen>
  800f40:	83 c4 10             	add    $0x10,%esp
  800f43:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800f46:	eb 16                	jmp    800f5e <vprintfmt+0x1dd>
					putch(padc, putdat);
  800f48:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800f4c:	83 ec 08             	sub    $0x8,%esp
  800f4f:	ff 75 0c             	pushl  0xc(%ebp)
  800f52:	50                   	push   %eax
  800f53:	8b 45 08             	mov    0x8(%ebp),%eax
  800f56:	ff d0                	call   *%eax
  800f58:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f5b:	ff 4d e4             	decl   -0x1c(%ebp)
  800f5e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f62:	7f e4                	jg     800f48 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f64:	eb 34                	jmp    800f9a <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f66:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f6a:	74 1c                	je     800f88 <vprintfmt+0x207>
  800f6c:	83 fb 1f             	cmp    $0x1f,%ebx
  800f6f:	7e 05                	jle    800f76 <vprintfmt+0x1f5>
  800f71:	83 fb 7e             	cmp    $0x7e,%ebx
  800f74:	7e 12                	jle    800f88 <vprintfmt+0x207>
					putch('?', putdat);
  800f76:	83 ec 08             	sub    $0x8,%esp
  800f79:	ff 75 0c             	pushl  0xc(%ebp)
  800f7c:	6a 3f                	push   $0x3f
  800f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f81:	ff d0                	call   *%eax
  800f83:	83 c4 10             	add    $0x10,%esp
  800f86:	eb 0f                	jmp    800f97 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f88:	83 ec 08             	sub    $0x8,%esp
  800f8b:	ff 75 0c             	pushl  0xc(%ebp)
  800f8e:	53                   	push   %ebx
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	ff d0                	call   *%eax
  800f94:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f97:	ff 4d e4             	decl   -0x1c(%ebp)
  800f9a:	89 f0                	mov    %esi,%eax
  800f9c:	8d 70 01             	lea    0x1(%eax),%esi
  800f9f:	8a 00                	mov    (%eax),%al
  800fa1:	0f be d8             	movsbl %al,%ebx
  800fa4:	85 db                	test   %ebx,%ebx
  800fa6:	74 24                	je     800fcc <vprintfmt+0x24b>
  800fa8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fac:	78 b8                	js     800f66 <vprintfmt+0x1e5>
  800fae:	ff 4d e0             	decl   -0x20(%ebp)
  800fb1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fb5:	79 af                	jns    800f66 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fb7:	eb 13                	jmp    800fcc <vprintfmt+0x24b>
				putch(' ', putdat);
  800fb9:	83 ec 08             	sub    $0x8,%esp
  800fbc:	ff 75 0c             	pushl  0xc(%ebp)
  800fbf:	6a 20                	push   $0x20
  800fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc4:	ff d0                	call   *%eax
  800fc6:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fc9:	ff 4d e4             	decl   -0x1c(%ebp)
  800fcc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fd0:	7f e7                	jg     800fb9 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800fd2:	e9 66 01 00 00       	jmp    80113d <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800fd7:	83 ec 08             	sub    $0x8,%esp
  800fda:	ff 75 e8             	pushl  -0x18(%ebp)
  800fdd:	8d 45 14             	lea    0x14(%ebp),%eax
  800fe0:	50                   	push   %eax
  800fe1:	e8 3c fd ff ff       	call   800d22 <getint>
  800fe6:	83 c4 10             	add    $0x10,%esp
  800fe9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fec:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800fef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ff2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ff5:	85 d2                	test   %edx,%edx
  800ff7:	79 23                	jns    80101c <vprintfmt+0x29b>
				putch('-', putdat);
  800ff9:	83 ec 08             	sub    $0x8,%esp
  800ffc:	ff 75 0c             	pushl  0xc(%ebp)
  800fff:	6a 2d                	push   $0x2d
  801001:	8b 45 08             	mov    0x8(%ebp),%eax
  801004:	ff d0                	call   *%eax
  801006:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801009:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80100c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80100f:	f7 d8                	neg    %eax
  801011:	83 d2 00             	adc    $0x0,%edx
  801014:	f7 da                	neg    %edx
  801016:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801019:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80101c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801023:	e9 bc 00 00 00       	jmp    8010e4 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801028:	83 ec 08             	sub    $0x8,%esp
  80102b:	ff 75 e8             	pushl  -0x18(%ebp)
  80102e:	8d 45 14             	lea    0x14(%ebp),%eax
  801031:	50                   	push   %eax
  801032:	e8 84 fc ff ff       	call   800cbb <getuint>
  801037:	83 c4 10             	add    $0x10,%esp
  80103a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80103d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801040:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801047:	e9 98 00 00 00       	jmp    8010e4 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80104c:	83 ec 08             	sub    $0x8,%esp
  80104f:	ff 75 0c             	pushl  0xc(%ebp)
  801052:	6a 58                	push   $0x58
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
  801057:	ff d0                	call   *%eax
  801059:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80105c:	83 ec 08             	sub    $0x8,%esp
  80105f:	ff 75 0c             	pushl  0xc(%ebp)
  801062:	6a 58                	push   $0x58
  801064:	8b 45 08             	mov    0x8(%ebp),%eax
  801067:	ff d0                	call   *%eax
  801069:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80106c:	83 ec 08             	sub    $0x8,%esp
  80106f:	ff 75 0c             	pushl  0xc(%ebp)
  801072:	6a 58                	push   $0x58
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
  801077:	ff d0                	call   *%eax
  801079:	83 c4 10             	add    $0x10,%esp
			break;
  80107c:	e9 bc 00 00 00       	jmp    80113d <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801081:	83 ec 08             	sub    $0x8,%esp
  801084:	ff 75 0c             	pushl  0xc(%ebp)
  801087:	6a 30                	push   $0x30
  801089:	8b 45 08             	mov    0x8(%ebp),%eax
  80108c:	ff d0                	call   *%eax
  80108e:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801091:	83 ec 08             	sub    $0x8,%esp
  801094:	ff 75 0c             	pushl  0xc(%ebp)
  801097:	6a 78                	push   $0x78
  801099:	8b 45 08             	mov    0x8(%ebp),%eax
  80109c:	ff d0                	call   *%eax
  80109e:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8010a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8010a4:	83 c0 04             	add    $0x4,%eax
  8010a7:	89 45 14             	mov    %eax,0x14(%ebp)
  8010aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8010ad:	83 e8 04             	sub    $0x4,%eax
  8010b0:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8010b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8010bc:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8010c3:	eb 1f                	jmp    8010e4 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8010c5:	83 ec 08             	sub    $0x8,%esp
  8010c8:	ff 75 e8             	pushl  -0x18(%ebp)
  8010cb:	8d 45 14             	lea    0x14(%ebp),%eax
  8010ce:	50                   	push   %eax
  8010cf:	e8 e7 fb ff ff       	call   800cbb <getuint>
  8010d4:	83 c4 10             	add    $0x10,%esp
  8010d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010da:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8010dd:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8010e4:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8010e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010eb:	83 ec 04             	sub    $0x4,%esp
  8010ee:	52                   	push   %edx
  8010ef:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010f2:	50                   	push   %eax
  8010f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8010f6:	ff 75 f0             	pushl  -0x10(%ebp)
  8010f9:	ff 75 0c             	pushl  0xc(%ebp)
  8010fc:	ff 75 08             	pushl  0x8(%ebp)
  8010ff:	e8 00 fb ff ff       	call   800c04 <printnum>
  801104:	83 c4 20             	add    $0x20,%esp
			break;
  801107:	eb 34                	jmp    80113d <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801109:	83 ec 08             	sub    $0x8,%esp
  80110c:	ff 75 0c             	pushl  0xc(%ebp)
  80110f:	53                   	push   %ebx
  801110:	8b 45 08             	mov    0x8(%ebp),%eax
  801113:	ff d0                	call   *%eax
  801115:	83 c4 10             	add    $0x10,%esp
			break;
  801118:	eb 23                	jmp    80113d <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80111a:	83 ec 08             	sub    $0x8,%esp
  80111d:	ff 75 0c             	pushl  0xc(%ebp)
  801120:	6a 25                	push   $0x25
  801122:	8b 45 08             	mov    0x8(%ebp),%eax
  801125:	ff d0                	call   *%eax
  801127:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80112a:	ff 4d 10             	decl   0x10(%ebp)
  80112d:	eb 03                	jmp    801132 <vprintfmt+0x3b1>
  80112f:	ff 4d 10             	decl   0x10(%ebp)
  801132:	8b 45 10             	mov    0x10(%ebp),%eax
  801135:	48                   	dec    %eax
  801136:	8a 00                	mov    (%eax),%al
  801138:	3c 25                	cmp    $0x25,%al
  80113a:	75 f3                	jne    80112f <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80113c:	90                   	nop
		}
	}
  80113d:	e9 47 fc ff ff       	jmp    800d89 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801142:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801143:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801146:	5b                   	pop    %ebx
  801147:	5e                   	pop    %esi
  801148:	5d                   	pop    %ebp
  801149:	c3                   	ret    

0080114a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80114a:	55                   	push   %ebp
  80114b:	89 e5                	mov    %esp,%ebp
  80114d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801150:	8d 45 10             	lea    0x10(%ebp),%eax
  801153:	83 c0 04             	add    $0x4,%eax
  801156:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801159:	8b 45 10             	mov    0x10(%ebp),%eax
  80115c:	ff 75 f4             	pushl  -0xc(%ebp)
  80115f:	50                   	push   %eax
  801160:	ff 75 0c             	pushl  0xc(%ebp)
  801163:	ff 75 08             	pushl  0x8(%ebp)
  801166:	e8 16 fc ff ff       	call   800d81 <vprintfmt>
  80116b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80116e:	90                   	nop
  80116f:	c9                   	leave  
  801170:	c3                   	ret    

00801171 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801171:	55                   	push   %ebp
  801172:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801174:	8b 45 0c             	mov    0xc(%ebp),%eax
  801177:	8b 40 08             	mov    0x8(%eax),%eax
  80117a:	8d 50 01             	lea    0x1(%eax),%edx
  80117d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801180:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801183:	8b 45 0c             	mov    0xc(%ebp),%eax
  801186:	8b 10                	mov    (%eax),%edx
  801188:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118b:	8b 40 04             	mov    0x4(%eax),%eax
  80118e:	39 c2                	cmp    %eax,%edx
  801190:	73 12                	jae    8011a4 <sprintputch+0x33>
		*b->buf++ = ch;
  801192:	8b 45 0c             	mov    0xc(%ebp),%eax
  801195:	8b 00                	mov    (%eax),%eax
  801197:	8d 48 01             	lea    0x1(%eax),%ecx
  80119a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80119d:	89 0a                	mov    %ecx,(%edx)
  80119f:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a2:	88 10                	mov    %dl,(%eax)
}
  8011a4:	90                   	nop
  8011a5:	5d                   	pop    %ebp
  8011a6:	c3                   	ret    

008011a7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8011a7:	55                   	push   %ebp
  8011a8:	89 e5                	mov    %esp,%ebp
  8011aa:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8011ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8011b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bc:	01 d0                	add    %edx,%eax
  8011be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8011c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011cc:	74 06                	je     8011d4 <vsnprintf+0x2d>
  8011ce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011d2:	7f 07                	jg     8011db <vsnprintf+0x34>
		return -E_INVAL;
  8011d4:	b8 03 00 00 00       	mov    $0x3,%eax
  8011d9:	eb 20                	jmp    8011fb <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8011db:	ff 75 14             	pushl  0x14(%ebp)
  8011de:	ff 75 10             	pushl  0x10(%ebp)
  8011e1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8011e4:	50                   	push   %eax
  8011e5:	68 71 11 80 00       	push   $0x801171
  8011ea:	e8 92 fb ff ff       	call   800d81 <vprintfmt>
  8011ef:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8011f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011f5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8011f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8011fb:	c9                   	leave  
  8011fc:	c3                   	ret    

008011fd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011fd:	55                   	push   %ebp
  8011fe:	89 e5                	mov    %esp,%ebp
  801200:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801203:	8d 45 10             	lea    0x10(%ebp),%eax
  801206:	83 c0 04             	add    $0x4,%eax
  801209:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80120c:	8b 45 10             	mov    0x10(%ebp),%eax
  80120f:	ff 75 f4             	pushl  -0xc(%ebp)
  801212:	50                   	push   %eax
  801213:	ff 75 0c             	pushl  0xc(%ebp)
  801216:	ff 75 08             	pushl  0x8(%ebp)
  801219:	e8 89 ff ff ff       	call   8011a7 <vsnprintf>
  80121e:	83 c4 10             	add    $0x10,%esp
  801221:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801224:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801227:	c9                   	leave  
  801228:	c3                   	ret    

00801229 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801229:	55                   	push   %ebp
  80122a:	89 e5                	mov    %esp,%ebp
  80122c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80122f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801236:	eb 06                	jmp    80123e <strlen+0x15>
		n++;
  801238:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80123b:	ff 45 08             	incl   0x8(%ebp)
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
  801241:	8a 00                	mov    (%eax),%al
  801243:	84 c0                	test   %al,%al
  801245:	75 f1                	jne    801238 <strlen+0xf>
		n++;
	return n;
  801247:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80124a:	c9                   	leave  
  80124b:	c3                   	ret    

0080124c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80124c:	55                   	push   %ebp
  80124d:	89 e5                	mov    %esp,%ebp
  80124f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801252:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801259:	eb 09                	jmp    801264 <strnlen+0x18>
		n++;
  80125b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80125e:	ff 45 08             	incl   0x8(%ebp)
  801261:	ff 4d 0c             	decl   0xc(%ebp)
  801264:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801268:	74 09                	je     801273 <strnlen+0x27>
  80126a:	8b 45 08             	mov    0x8(%ebp),%eax
  80126d:	8a 00                	mov    (%eax),%al
  80126f:	84 c0                	test   %al,%al
  801271:	75 e8                	jne    80125b <strnlen+0xf>
		n++;
	return n;
  801273:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801276:	c9                   	leave  
  801277:	c3                   	ret    

00801278 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801278:	55                   	push   %ebp
  801279:	89 e5                	mov    %esp,%ebp
  80127b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
  801281:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801284:	90                   	nop
  801285:	8b 45 08             	mov    0x8(%ebp),%eax
  801288:	8d 50 01             	lea    0x1(%eax),%edx
  80128b:	89 55 08             	mov    %edx,0x8(%ebp)
  80128e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801291:	8d 4a 01             	lea    0x1(%edx),%ecx
  801294:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801297:	8a 12                	mov    (%edx),%dl
  801299:	88 10                	mov    %dl,(%eax)
  80129b:	8a 00                	mov    (%eax),%al
  80129d:	84 c0                	test   %al,%al
  80129f:	75 e4                	jne    801285 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8012a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012a4:	c9                   	leave  
  8012a5:	c3                   	ret    

008012a6 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8012a6:	55                   	push   %ebp
  8012a7:	89 e5                	mov    %esp,%ebp
  8012a9:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8012ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8012af:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8012b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012b9:	eb 1f                	jmp    8012da <strncpy+0x34>
		*dst++ = *src;
  8012bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012be:	8d 50 01             	lea    0x1(%eax),%edx
  8012c1:	89 55 08             	mov    %edx,0x8(%ebp)
  8012c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012c7:	8a 12                	mov    (%edx),%dl
  8012c9:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8012cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ce:	8a 00                	mov    (%eax),%al
  8012d0:	84 c0                	test   %al,%al
  8012d2:	74 03                	je     8012d7 <strncpy+0x31>
			src++;
  8012d4:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012d7:	ff 45 fc             	incl   -0x4(%ebp)
  8012da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012dd:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012e0:	72 d9                	jb     8012bb <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8012e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012e5:	c9                   	leave  
  8012e6:	c3                   	ret    

008012e7 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8012e7:	55                   	push   %ebp
  8012e8:	89 e5                	mov    %esp,%ebp
  8012ea:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8012ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8012f3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012f7:	74 30                	je     801329 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8012f9:	eb 16                	jmp    801311 <strlcpy+0x2a>
			*dst++ = *src++;
  8012fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fe:	8d 50 01             	lea    0x1(%eax),%edx
  801301:	89 55 08             	mov    %edx,0x8(%ebp)
  801304:	8b 55 0c             	mov    0xc(%ebp),%edx
  801307:	8d 4a 01             	lea    0x1(%edx),%ecx
  80130a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80130d:	8a 12                	mov    (%edx),%dl
  80130f:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801311:	ff 4d 10             	decl   0x10(%ebp)
  801314:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801318:	74 09                	je     801323 <strlcpy+0x3c>
  80131a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131d:	8a 00                	mov    (%eax),%al
  80131f:	84 c0                	test   %al,%al
  801321:	75 d8                	jne    8012fb <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801323:	8b 45 08             	mov    0x8(%ebp),%eax
  801326:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801329:	8b 55 08             	mov    0x8(%ebp),%edx
  80132c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80132f:	29 c2                	sub    %eax,%edx
  801331:	89 d0                	mov    %edx,%eax
}
  801333:	c9                   	leave  
  801334:	c3                   	ret    

00801335 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801335:	55                   	push   %ebp
  801336:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801338:	eb 06                	jmp    801340 <strcmp+0xb>
		p++, q++;
  80133a:	ff 45 08             	incl   0x8(%ebp)
  80133d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801340:	8b 45 08             	mov    0x8(%ebp),%eax
  801343:	8a 00                	mov    (%eax),%al
  801345:	84 c0                	test   %al,%al
  801347:	74 0e                	je     801357 <strcmp+0x22>
  801349:	8b 45 08             	mov    0x8(%ebp),%eax
  80134c:	8a 10                	mov    (%eax),%dl
  80134e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801351:	8a 00                	mov    (%eax),%al
  801353:	38 c2                	cmp    %al,%dl
  801355:	74 e3                	je     80133a <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801357:	8b 45 08             	mov    0x8(%ebp),%eax
  80135a:	8a 00                	mov    (%eax),%al
  80135c:	0f b6 d0             	movzbl %al,%edx
  80135f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801362:	8a 00                	mov    (%eax),%al
  801364:	0f b6 c0             	movzbl %al,%eax
  801367:	29 c2                	sub    %eax,%edx
  801369:	89 d0                	mov    %edx,%eax
}
  80136b:	5d                   	pop    %ebp
  80136c:	c3                   	ret    

0080136d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80136d:	55                   	push   %ebp
  80136e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801370:	eb 09                	jmp    80137b <strncmp+0xe>
		n--, p++, q++;
  801372:	ff 4d 10             	decl   0x10(%ebp)
  801375:	ff 45 08             	incl   0x8(%ebp)
  801378:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80137b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80137f:	74 17                	je     801398 <strncmp+0x2b>
  801381:	8b 45 08             	mov    0x8(%ebp),%eax
  801384:	8a 00                	mov    (%eax),%al
  801386:	84 c0                	test   %al,%al
  801388:	74 0e                	je     801398 <strncmp+0x2b>
  80138a:	8b 45 08             	mov    0x8(%ebp),%eax
  80138d:	8a 10                	mov    (%eax),%dl
  80138f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801392:	8a 00                	mov    (%eax),%al
  801394:	38 c2                	cmp    %al,%dl
  801396:	74 da                	je     801372 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801398:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80139c:	75 07                	jne    8013a5 <strncmp+0x38>
		return 0;
  80139e:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a3:	eb 14                	jmp    8013b9 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8013a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a8:	8a 00                	mov    (%eax),%al
  8013aa:	0f b6 d0             	movzbl %al,%edx
  8013ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b0:	8a 00                	mov    (%eax),%al
  8013b2:	0f b6 c0             	movzbl %al,%eax
  8013b5:	29 c2                	sub    %eax,%edx
  8013b7:	89 d0                	mov    %edx,%eax
}
  8013b9:	5d                   	pop    %ebp
  8013ba:	c3                   	ret    

008013bb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8013bb:	55                   	push   %ebp
  8013bc:	89 e5                	mov    %esp,%ebp
  8013be:	83 ec 04             	sub    $0x4,%esp
  8013c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8013c7:	eb 12                	jmp    8013db <strchr+0x20>
		if (*s == c)
  8013c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cc:	8a 00                	mov    (%eax),%al
  8013ce:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8013d1:	75 05                	jne    8013d8 <strchr+0x1d>
			return (char *) s;
  8013d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d6:	eb 11                	jmp    8013e9 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8013d8:	ff 45 08             	incl   0x8(%ebp)
  8013db:	8b 45 08             	mov    0x8(%ebp),%eax
  8013de:	8a 00                	mov    (%eax),%al
  8013e0:	84 c0                	test   %al,%al
  8013e2:	75 e5                	jne    8013c9 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8013e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013e9:	c9                   	leave  
  8013ea:	c3                   	ret    

008013eb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8013eb:	55                   	push   %ebp
  8013ec:	89 e5                	mov    %esp,%ebp
  8013ee:	83 ec 04             	sub    $0x4,%esp
  8013f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8013f7:	eb 0d                	jmp    801406 <strfind+0x1b>
		if (*s == c)
  8013f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fc:	8a 00                	mov    (%eax),%al
  8013fe:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801401:	74 0e                	je     801411 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801403:	ff 45 08             	incl   0x8(%ebp)
  801406:	8b 45 08             	mov    0x8(%ebp),%eax
  801409:	8a 00                	mov    (%eax),%al
  80140b:	84 c0                	test   %al,%al
  80140d:	75 ea                	jne    8013f9 <strfind+0xe>
  80140f:	eb 01                	jmp    801412 <strfind+0x27>
		if (*s == c)
			break;
  801411:	90                   	nop
	return (char *) s;
  801412:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801415:	c9                   	leave  
  801416:	c3                   	ret    

00801417 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801417:	55                   	push   %ebp
  801418:	89 e5                	mov    %esp,%ebp
  80141a:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80141d:	8b 45 08             	mov    0x8(%ebp),%eax
  801420:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801423:	8b 45 10             	mov    0x10(%ebp),%eax
  801426:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801429:	eb 0e                	jmp    801439 <memset+0x22>
		*p++ = c;
  80142b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80142e:	8d 50 01             	lea    0x1(%eax),%edx
  801431:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801434:	8b 55 0c             	mov    0xc(%ebp),%edx
  801437:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801439:	ff 4d f8             	decl   -0x8(%ebp)
  80143c:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801440:	79 e9                	jns    80142b <memset+0x14>
		*p++ = c;

	return v;
  801442:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801445:	c9                   	leave  
  801446:	c3                   	ret    

00801447 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801447:	55                   	push   %ebp
  801448:	89 e5                	mov    %esp,%ebp
  80144a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80144d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801450:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801453:	8b 45 08             	mov    0x8(%ebp),%eax
  801456:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801459:	eb 16                	jmp    801471 <memcpy+0x2a>
		*d++ = *s++;
  80145b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80145e:	8d 50 01             	lea    0x1(%eax),%edx
  801461:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801464:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801467:	8d 4a 01             	lea    0x1(%edx),%ecx
  80146a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80146d:	8a 12                	mov    (%edx),%dl
  80146f:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801471:	8b 45 10             	mov    0x10(%ebp),%eax
  801474:	8d 50 ff             	lea    -0x1(%eax),%edx
  801477:	89 55 10             	mov    %edx,0x10(%ebp)
  80147a:	85 c0                	test   %eax,%eax
  80147c:	75 dd                	jne    80145b <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80147e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801481:	c9                   	leave  
  801482:	c3                   	ret    

00801483 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801483:	55                   	push   %ebp
  801484:	89 e5                	mov    %esp,%ebp
  801486:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801489:	8b 45 0c             	mov    0xc(%ebp),%eax
  80148c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80148f:	8b 45 08             	mov    0x8(%ebp),%eax
  801492:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801495:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801498:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80149b:	73 50                	jae    8014ed <memmove+0x6a>
  80149d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a3:	01 d0                	add    %edx,%eax
  8014a5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8014a8:	76 43                	jbe    8014ed <memmove+0x6a>
		s += n;
  8014aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ad:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8014b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b3:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8014b6:	eb 10                	jmp    8014c8 <memmove+0x45>
			*--d = *--s;
  8014b8:	ff 4d f8             	decl   -0x8(%ebp)
  8014bb:	ff 4d fc             	decl   -0x4(%ebp)
  8014be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014c1:	8a 10                	mov    (%eax),%dl
  8014c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014c6:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8014c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8014cb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014ce:	89 55 10             	mov    %edx,0x10(%ebp)
  8014d1:	85 c0                	test   %eax,%eax
  8014d3:	75 e3                	jne    8014b8 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8014d5:	eb 23                	jmp    8014fa <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8014d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014da:	8d 50 01             	lea    0x1(%eax),%edx
  8014dd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014e3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014e6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8014e9:	8a 12                	mov    (%edx),%dl
  8014eb:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8014ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014f3:	89 55 10             	mov    %edx,0x10(%ebp)
  8014f6:	85 c0                	test   %eax,%eax
  8014f8:	75 dd                	jne    8014d7 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8014fa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014fd:	c9                   	leave  
  8014fe:	c3                   	ret    

008014ff <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8014ff:	55                   	push   %ebp
  801500:	89 e5                	mov    %esp,%ebp
  801502:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801505:	8b 45 08             	mov    0x8(%ebp),%eax
  801508:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80150b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150e:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801511:	eb 2a                	jmp    80153d <memcmp+0x3e>
		if (*s1 != *s2)
  801513:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801516:	8a 10                	mov    (%eax),%dl
  801518:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80151b:	8a 00                	mov    (%eax),%al
  80151d:	38 c2                	cmp    %al,%dl
  80151f:	74 16                	je     801537 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801521:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801524:	8a 00                	mov    (%eax),%al
  801526:	0f b6 d0             	movzbl %al,%edx
  801529:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80152c:	8a 00                	mov    (%eax),%al
  80152e:	0f b6 c0             	movzbl %al,%eax
  801531:	29 c2                	sub    %eax,%edx
  801533:	89 d0                	mov    %edx,%eax
  801535:	eb 18                	jmp    80154f <memcmp+0x50>
		s1++, s2++;
  801537:	ff 45 fc             	incl   -0x4(%ebp)
  80153a:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80153d:	8b 45 10             	mov    0x10(%ebp),%eax
  801540:	8d 50 ff             	lea    -0x1(%eax),%edx
  801543:	89 55 10             	mov    %edx,0x10(%ebp)
  801546:	85 c0                	test   %eax,%eax
  801548:	75 c9                	jne    801513 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80154a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80154f:	c9                   	leave  
  801550:	c3                   	ret    

00801551 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801551:	55                   	push   %ebp
  801552:	89 e5                	mov    %esp,%ebp
  801554:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801557:	8b 55 08             	mov    0x8(%ebp),%edx
  80155a:	8b 45 10             	mov    0x10(%ebp),%eax
  80155d:	01 d0                	add    %edx,%eax
  80155f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801562:	eb 15                	jmp    801579 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801564:	8b 45 08             	mov    0x8(%ebp),%eax
  801567:	8a 00                	mov    (%eax),%al
  801569:	0f b6 d0             	movzbl %al,%edx
  80156c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156f:	0f b6 c0             	movzbl %al,%eax
  801572:	39 c2                	cmp    %eax,%edx
  801574:	74 0d                	je     801583 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801576:	ff 45 08             	incl   0x8(%ebp)
  801579:	8b 45 08             	mov    0x8(%ebp),%eax
  80157c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80157f:	72 e3                	jb     801564 <memfind+0x13>
  801581:	eb 01                	jmp    801584 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801583:	90                   	nop
	return (void *) s;
  801584:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801587:	c9                   	leave  
  801588:	c3                   	ret    

00801589 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801589:	55                   	push   %ebp
  80158a:	89 e5                	mov    %esp,%ebp
  80158c:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80158f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801596:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80159d:	eb 03                	jmp    8015a2 <strtol+0x19>
		s++;
  80159f:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a5:	8a 00                	mov    (%eax),%al
  8015a7:	3c 20                	cmp    $0x20,%al
  8015a9:	74 f4                	je     80159f <strtol+0x16>
  8015ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ae:	8a 00                	mov    (%eax),%al
  8015b0:	3c 09                	cmp    $0x9,%al
  8015b2:	74 eb                	je     80159f <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b7:	8a 00                	mov    (%eax),%al
  8015b9:	3c 2b                	cmp    $0x2b,%al
  8015bb:	75 05                	jne    8015c2 <strtol+0x39>
		s++;
  8015bd:	ff 45 08             	incl   0x8(%ebp)
  8015c0:	eb 13                	jmp    8015d5 <strtol+0x4c>
	else if (*s == '-')
  8015c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c5:	8a 00                	mov    (%eax),%al
  8015c7:	3c 2d                	cmp    $0x2d,%al
  8015c9:	75 0a                	jne    8015d5 <strtol+0x4c>
		s++, neg = 1;
  8015cb:	ff 45 08             	incl   0x8(%ebp)
  8015ce:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015d5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015d9:	74 06                	je     8015e1 <strtol+0x58>
  8015db:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8015df:	75 20                	jne    801601 <strtol+0x78>
  8015e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e4:	8a 00                	mov    (%eax),%al
  8015e6:	3c 30                	cmp    $0x30,%al
  8015e8:	75 17                	jne    801601 <strtol+0x78>
  8015ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ed:	40                   	inc    %eax
  8015ee:	8a 00                	mov    (%eax),%al
  8015f0:	3c 78                	cmp    $0x78,%al
  8015f2:	75 0d                	jne    801601 <strtol+0x78>
		s += 2, base = 16;
  8015f4:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8015f8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8015ff:	eb 28                	jmp    801629 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801601:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801605:	75 15                	jne    80161c <strtol+0x93>
  801607:	8b 45 08             	mov    0x8(%ebp),%eax
  80160a:	8a 00                	mov    (%eax),%al
  80160c:	3c 30                	cmp    $0x30,%al
  80160e:	75 0c                	jne    80161c <strtol+0x93>
		s++, base = 8;
  801610:	ff 45 08             	incl   0x8(%ebp)
  801613:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80161a:	eb 0d                	jmp    801629 <strtol+0xa0>
	else if (base == 0)
  80161c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801620:	75 07                	jne    801629 <strtol+0xa0>
		base = 10;
  801622:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801629:	8b 45 08             	mov    0x8(%ebp),%eax
  80162c:	8a 00                	mov    (%eax),%al
  80162e:	3c 2f                	cmp    $0x2f,%al
  801630:	7e 19                	jle    80164b <strtol+0xc2>
  801632:	8b 45 08             	mov    0x8(%ebp),%eax
  801635:	8a 00                	mov    (%eax),%al
  801637:	3c 39                	cmp    $0x39,%al
  801639:	7f 10                	jg     80164b <strtol+0xc2>
			dig = *s - '0';
  80163b:	8b 45 08             	mov    0x8(%ebp),%eax
  80163e:	8a 00                	mov    (%eax),%al
  801640:	0f be c0             	movsbl %al,%eax
  801643:	83 e8 30             	sub    $0x30,%eax
  801646:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801649:	eb 42                	jmp    80168d <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80164b:	8b 45 08             	mov    0x8(%ebp),%eax
  80164e:	8a 00                	mov    (%eax),%al
  801650:	3c 60                	cmp    $0x60,%al
  801652:	7e 19                	jle    80166d <strtol+0xe4>
  801654:	8b 45 08             	mov    0x8(%ebp),%eax
  801657:	8a 00                	mov    (%eax),%al
  801659:	3c 7a                	cmp    $0x7a,%al
  80165b:	7f 10                	jg     80166d <strtol+0xe4>
			dig = *s - 'a' + 10;
  80165d:	8b 45 08             	mov    0x8(%ebp),%eax
  801660:	8a 00                	mov    (%eax),%al
  801662:	0f be c0             	movsbl %al,%eax
  801665:	83 e8 57             	sub    $0x57,%eax
  801668:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80166b:	eb 20                	jmp    80168d <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80166d:	8b 45 08             	mov    0x8(%ebp),%eax
  801670:	8a 00                	mov    (%eax),%al
  801672:	3c 40                	cmp    $0x40,%al
  801674:	7e 39                	jle    8016af <strtol+0x126>
  801676:	8b 45 08             	mov    0x8(%ebp),%eax
  801679:	8a 00                	mov    (%eax),%al
  80167b:	3c 5a                	cmp    $0x5a,%al
  80167d:	7f 30                	jg     8016af <strtol+0x126>
			dig = *s - 'A' + 10;
  80167f:	8b 45 08             	mov    0x8(%ebp),%eax
  801682:	8a 00                	mov    (%eax),%al
  801684:	0f be c0             	movsbl %al,%eax
  801687:	83 e8 37             	sub    $0x37,%eax
  80168a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80168d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801690:	3b 45 10             	cmp    0x10(%ebp),%eax
  801693:	7d 19                	jge    8016ae <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801695:	ff 45 08             	incl   0x8(%ebp)
  801698:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80169b:	0f af 45 10          	imul   0x10(%ebp),%eax
  80169f:	89 c2                	mov    %eax,%edx
  8016a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a4:	01 d0                	add    %edx,%eax
  8016a6:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8016a9:	e9 7b ff ff ff       	jmp    801629 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8016ae:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8016af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016b3:	74 08                	je     8016bd <strtol+0x134>
		*endptr = (char *) s;
  8016b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8016bb:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8016bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8016c1:	74 07                	je     8016ca <strtol+0x141>
  8016c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016c6:	f7 d8                	neg    %eax
  8016c8:	eb 03                	jmp    8016cd <strtol+0x144>
  8016ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8016cd:	c9                   	leave  
  8016ce:	c3                   	ret    

008016cf <ltostr>:

void
ltostr(long value, char *str)
{
  8016cf:	55                   	push   %ebp
  8016d0:	89 e5                	mov    %esp,%ebp
  8016d2:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8016d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8016dc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8016e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016e7:	79 13                	jns    8016fc <ltostr+0x2d>
	{
		neg = 1;
  8016e9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8016f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f3:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8016f6:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8016f9:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8016fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ff:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801704:	99                   	cltd   
  801705:	f7 f9                	idiv   %ecx
  801707:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80170a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80170d:	8d 50 01             	lea    0x1(%eax),%edx
  801710:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801713:	89 c2                	mov    %eax,%edx
  801715:	8b 45 0c             	mov    0xc(%ebp),%eax
  801718:	01 d0                	add    %edx,%eax
  80171a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80171d:	83 c2 30             	add    $0x30,%edx
  801720:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801722:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801725:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80172a:	f7 e9                	imul   %ecx
  80172c:	c1 fa 02             	sar    $0x2,%edx
  80172f:	89 c8                	mov    %ecx,%eax
  801731:	c1 f8 1f             	sar    $0x1f,%eax
  801734:	29 c2                	sub    %eax,%edx
  801736:	89 d0                	mov    %edx,%eax
  801738:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80173b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80173e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801743:	f7 e9                	imul   %ecx
  801745:	c1 fa 02             	sar    $0x2,%edx
  801748:	89 c8                	mov    %ecx,%eax
  80174a:	c1 f8 1f             	sar    $0x1f,%eax
  80174d:	29 c2                	sub    %eax,%edx
  80174f:	89 d0                	mov    %edx,%eax
  801751:	c1 e0 02             	shl    $0x2,%eax
  801754:	01 d0                	add    %edx,%eax
  801756:	01 c0                	add    %eax,%eax
  801758:	29 c1                	sub    %eax,%ecx
  80175a:	89 ca                	mov    %ecx,%edx
  80175c:	85 d2                	test   %edx,%edx
  80175e:	75 9c                	jne    8016fc <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801760:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801767:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80176a:	48                   	dec    %eax
  80176b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80176e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801772:	74 3d                	je     8017b1 <ltostr+0xe2>
		start = 1 ;
  801774:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80177b:	eb 34                	jmp    8017b1 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80177d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801780:	8b 45 0c             	mov    0xc(%ebp),%eax
  801783:	01 d0                	add    %edx,%eax
  801785:	8a 00                	mov    (%eax),%al
  801787:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80178a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80178d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801790:	01 c2                	add    %eax,%edx
  801792:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801795:	8b 45 0c             	mov    0xc(%ebp),%eax
  801798:	01 c8                	add    %ecx,%eax
  80179a:	8a 00                	mov    (%eax),%al
  80179c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80179e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a4:	01 c2                	add    %eax,%edx
  8017a6:	8a 45 eb             	mov    -0x15(%ebp),%al
  8017a9:	88 02                	mov    %al,(%edx)
		start++ ;
  8017ab:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8017ae:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8017b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8017b7:	7c c4                	jl     80177d <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8017b9:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8017bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017bf:	01 d0                	add    %edx,%eax
  8017c1:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8017c4:	90                   	nop
  8017c5:	c9                   	leave  
  8017c6:	c3                   	ret    

008017c7 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8017c7:	55                   	push   %ebp
  8017c8:	89 e5                	mov    %esp,%ebp
  8017ca:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8017cd:	ff 75 08             	pushl  0x8(%ebp)
  8017d0:	e8 54 fa ff ff       	call   801229 <strlen>
  8017d5:	83 c4 04             	add    $0x4,%esp
  8017d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8017db:	ff 75 0c             	pushl  0xc(%ebp)
  8017de:	e8 46 fa ff ff       	call   801229 <strlen>
  8017e3:	83 c4 04             	add    $0x4,%esp
  8017e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8017e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8017f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8017f7:	eb 17                	jmp    801810 <strcconcat+0x49>
		final[s] = str1[s] ;
  8017f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ff:	01 c2                	add    %eax,%edx
  801801:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801804:	8b 45 08             	mov    0x8(%ebp),%eax
  801807:	01 c8                	add    %ecx,%eax
  801809:	8a 00                	mov    (%eax),%al
  80180b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80180d:	ff 45 fc             	incl   -0x4(%ebp)
  801810:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801813:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801816:	7c e1                	jl     8017f9 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801818:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80181f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801826:	eb 1f                	jmp    801847 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801828:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80182b:	8d 50 01             	lea    0x1(%eax),%edx
  80182e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801831:	89 c2                	mov    %eax,%edx
  801833:	8b 45 10             	mov    0x10(%ebp),%eax
  801836:	01 c2                	add    %eax,%edx
  801838:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80183b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80183e:	01 c8                	add    %ecx,%eax
  801840:	8a 00                	mov    (%eax),%al
  801842:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801844:	ff 45 f8             	incl   -0x8(%ebp)
  801847:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80184a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80184d:	7c d9                	jl     801828 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80184f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801852:	8b 45 10             	mov    0x10(%ebp),%eax
  801855:	01 d0                	add    %edx,%eax
  801857:	c6 00 00             	movb   $0x0,(%eax)
}
  80185a:	90                   	nop
  80185b:	c9                   	leave  
  80185c:	c3                   	ret    

0080185d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801860:	8b 45 14             	mov    0x14(%ebp),%eax
  801863:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801869:	8b 45 14             	mov    0x14(%ebp),%eax
  80186c:	8b 00                	mov    (%eax),%eax
  80186e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801875:	8b 45 10             	mov    0x10(%ebp),%eax
  801878:	01 d0                	add    %edx,%eax
  80187a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801880:	eb 0c                	jmp    80188e <strsplit+0x31>
			*string++ = 0;
  801882:	8b 45 08             	mov    0x8(%ebp),%eax
  801885:	8d 50 01             	lea    0x1(%eax),%edx
  801888:	89 55 08             	mov    %edx,0x8(%ebp)
  80188b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80188e:	8b 45 08             	mov    0x8(%ebp),%eax
  801891:	8a 00                	mov    (%eax),%al
  801893:	84 c0                	test   %al,%al
  801895:	74 18                	je     8018af <strsplit+0x52>
  801897:	8b 45 08             	mov    0x8(%ebp),%eax
  80189a:	8a 00                	mov    (%eax),%al
  80189c:	0f be c0             	movsbl %al,%eax
  80189f:	50                   	push   %eax
  8018a0:	ff 75 0c             	pushl  0xc(%ebp)
  8018a3:	e8 13 fb ff ff       	call   8013bb <strchr>
  8018a8:	83 c4 08             	add    $0x8,%esp
  8018ab:	85 c0                	test   %eax,%eax
  8018ad:	75 d3                	jne    801882 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8018af:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b2:	8a 00                	mov    (%eax),%al
  8018b4:	84 c0                	test   %al,%al
  8018b6:	74 5a                	je     801912 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8018b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8018bb:	8b 00                	mov    (%eax),%eax
  8018bd:	83 f8 0f             	cmp    $0xf,%eax
  8018c0:	75 07                	jne    8018c9 <strsplit+0x6c>
		{
			return 0;
  8018c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8018c7:	eb 66                	jmp    80192f <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8018c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8018cc:	8b 00                	mov    (%eax),%eax
  8018ce:	8d 48 01             	lea    0x1(%eax),%ecx
  8018d1:	8b 55 14             	mov    0x14(%ebp),%edx
  8018d4:	89 0a                	mov    %ecx,(%edx)
  8018d6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e0:	01 c2                	add    %eax,%edx
  8018e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e5:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8018e7:	eb 03                	jmp    8018ec <strsplit+0x8f>
			string++;
  8018e9:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8018ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ef:	8a 00                	mov    (%eax),%al
  8018f1:	84 c0                	test   %al,%al
  8018f3:	74 8b                	je     801880 <strsplit+0x23>
  8018f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f8:	8a 00                	mov    (%eax),%al
  8018fa:	0f be c0             	movsbl %al,%eax
  8018fd:	50                   	push   %eax
  8018fe:	ff 75 0c             	pushl  0xc(%ebp)
  801901:	e8 b5 fa ff ff       	call   8013bb <strchr>
  801906:	83 c4 08             	add    $0x8,%esp
  801909:	85 c0                	test   %eax,%eax
  80190b:	74 dc                	je     8018e9 <strsplit+0x8c>
			string++;
	}
  80190d:	e9 6e ff ff ff       	jmp    801880 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801912:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801913:	8b 45 14             	mov    0x14(%ebp),%eax
  801916:	8b 00                	mov    (%eax),%eax
  801918:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80191f:	8b 45 10             	mov    0x10(%ebp),%eax
  801922:	01 d0                	add    %edx,%eax
  801924:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80192a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80192f:	c9                   	leave  
  801930:	c3                   	ret    

00801931 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
  801934:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801937:	a1 04 50 80 00       	mov    0x805004,%eax
  80193c:	85 c0                	test   %eax,%eax
  80193e:	74 1f                	je     80195f <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801940:	e8 1d 00 00 00       	call   801962 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801945:	83 ec 0c             	sub    $0xc,%esp
  801948:	68 70 40 80 00       	push   $0x804070
  80194d:	e8 55 f2 ff ff       	call   800ba7 <cprintf>
  801952:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801955:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  80195c:	00 00 00 
	}
}
  80195f:	90                   	nop
  801960:	c9                   	leave  
  801961:	c3                   	ret    

00801962 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801962:	55                   	push   %ebp
  801963:	89 e5                	mov    %esp,%ebp
  801965:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801968:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  80196f:	00 00 00 
  801972:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801979:	00 00 00 
  80197c:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801983:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  801986:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  80198d:	00 00 00 
  801990:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801997:	00 00 00 
  80199a:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8019a1:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  8019a4:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  8019ab:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  8019ae:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  8019b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8019bd:	2d 00 10 00 00       	sub    $0x1000,%eax
  8019c2:	a3 50 50 80 00       	mov    %eax,0x805050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  8019c7:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8019ce:	a1 20 51 80 00       	mov    0x805120,%eax
  8019d3:	c1 e0 04             	shl    $0x4,%eax
  8019d6:	89 c2                	mov    %eax,%edx
  8019d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019db:	01 d0                	add    %edx,%eax
  8019dd:	48                   	dec    %eax
  8019de:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8019e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8019e9:	f7 75 f0             	divl   -0x10(%ebp)
  8019ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019ef:	29 d0                	sub    %edx,%eax
  8019f1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  8019f4:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8019fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019fe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a03:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a08:	83 ec 04             	sub    $0x4,%esp
  801a0b:	6a 06                	push   $0x6
  801a0d:	ff 75 e8             	pushl  -0x18(%ebp)
  801a10:	50                   	push   %eax
  801a11:	e8 b0 05 00 00       	call   801fc6 <sys_allocate_chunk>
  801a16:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801a19:	a1 20 51 80 00       	mov    0x805120,%eax
  801a1e:	83 ec 0c             	sub    $0xc,%esp
  801a21:	50                   	push   %eax
  801a22:	e8 25 0c 00 00       	call   80264c <initialize_MemBlocksList>
  801a27:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  801a2a:	a1 48 51 80 00       	mov    0x805148,%eax
  801a2f:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  801a32:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801a36:	75 14                	jne    801a4c <initialize_dyn_block_system+0xea>
  801a38:	83 ec 04             	sub    $0x4,%esp
  801a3b:	68 95 40 80 00       	push   $0x804095
  801a40:	6a 29                	push   $0x29
  801a42:	68 b3 40 80 00       	push   $0x8040b3
  801a47:	e8 a7 ee ff ff       	call   8008f3 <_panic>
  801a4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a4f:	8b 00                	mov    (%eax),%eax
  801a51:	85 c0                	test   %eax,%eax
  801a53:	74 10                	je     801a65 <initialize_dyn_block_system+0x103>
  801a55:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a58:	8b 00                	mov    (%eax),%eax
  801a5a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a5d:	8b 52 04             	mov    0x4(%edx),%edx
  801a60:	89 50 04             	mov    %edx,0x4(%eax)
  801a63:	eb 0b                	jmp    801a70 <initialize_dyn_block_system+0x10e>
  801a65:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a68:	8b 40 04             	mov    0x4(%eax),%eax
  801a6b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801a70:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a73:	8b 40 04             	mov    0x4(%eax),%eax
  801a76:	85 c0                	test   %eax,%eax
  801a78:	74 0f                	je     801a89 <initialize_dyn_block_system+0x127>
  801a7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a7d:	8b 40 04             	mov    0x4(%eax),%eax
  801a80:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a83:	8b 12                	mov    (%edx),%edx
  801a85:	89 10                	mov    %edx,(%eax)
  801a87:	eb 0a                	jmp    801a93 <initialize_dyn_block_system+0x131>
  801a89:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a8c:	8b 00                	mov    (%eax),%eax
  801a8e:	a3 48 51 80 00       	mov    %eax,0x805148
  801a93:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a96:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801a9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a9f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801aa6:	a1 54 51 80 00       	mov    0x805154,%eax
  801aab:	48                   	dec    %eax
  801aac:	a3 54 51 80 00       	mov    %eax,0x805154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  801ab1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ab4:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  801abb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801abe:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  801ac5:	83 ec 0c             	sub    $0xc,%esp
  801ac8:	ff 75 e0             	pushl  -0x20(%ebp)
  801acb:	e8 b9 14 00 00       	call   802f89 <insert_sorted_with_merge_freeList>
  801ad0:	83 c4 10             	add    $0x10,%esp

}
  801ad3:	90                   	nop
  801ad4:	c9                   	leave  
  801ad5:	c3                   	ret    

00801ad6 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801ad6:	55                   	push   %ebp
  801ad7:	89 e5                	mov    %esp,%ebp
  801ad9:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801adc:	e8 50 fe ff ff       	call   801931 <InitializeUHeap>
	if (size == 0) return NULL ;
  801ae1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ae5:	75 07                	jne    801aee <malloc+0x18>
  801ae7:	b8 00 00 00 00       	mov    $0x0,%eax
  801aec:	eb 68                	jmp    801b56 <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  801aee:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801af5:	8b 55 08             	mov    0x8(%ebp),%edx
  801af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801afb:	01 d0                	add    %edx,%eax
  801afd:	48                   	dec    %eax
  801afe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b04:	ba 00 00 00 00       	mov    $0x0,%edx
  801b09:	f7 75 f4             	divl   -0xc(%ebp)
  801b0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b0f:	29 d0                	sub    %edx,%eax
  801b11:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  801b14:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801b1b:	e8 74 08 00 00       	call   802394 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b20:	85 c0                	test   %eax,%eax
  801b22:	74 2d                	je     801b51 <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  801b24:	83 ec 0c             	sub    $0xc,%esp
  801b27:	ff 75 ec             	pushl  -0x14(%ebp)
  801b2a:	e8 52 0e 00 00       	call   802981 <alloc_block_FF>
  801b2f:	83 c4 10             	add    $0x10,%esp
  801b32:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  801b35:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801b39:	74 16                	je     801b51 <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  801b3b:	83 ec 0c             	sub    $0xc,%esp
  801b3e:	ff 75 e8             	pushl  -0x18(%ebp)
  801b41:	e8 3b 0c 00 00       	call   802781 <insert_sorted_allocList>
  801b46:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  801b49:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801b4c:	8b 40 08             	mov    0x8(%eax),%eax
  801b4f:	eb 05                	jmp    801b56 <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  801b51:	b8 00 00 00 00       	mov    $0x0,%eax

}
  801b56:	c9                   	leave  
  801b57:	c3                   	ret    

00801b58 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801b58:	55                   	push   %ebp
  801b59:	89 e5                	mov    %esp,%ebp
  801b5b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  801b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b61:	83 ec 08             	sub    $0x8,%esp
  801b64:	50                   	push   %eax
  801b65:	68 40 50 80 00       	push   $0x805040
  801b6a:	e8 ba 0b 00 00       	call   802729 <find_block>
  801b6f:	83 c4 10             	add    $0x10,%esp
  801b72:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  801b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b78:	8b 40 0c             	mov    0xc(%eax),%eax
  801b7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  801b7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b82:	0f 84 9f 00 00 00    	je     801c27 <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  801b88:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8b:	83 ec 08             	sub    $0x8,%esp
  801b8e:	ff 75 f0             	pushl  -0x10(%ebp)
  801b91:	50                   	push   %eax
  801b92:	e8 f7 03 00 00       	call   801f8e <sys_free_user_mem>
  801b97:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  801b9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b9e:	75 14                	jne    801bb4 <free+0x5c>
  801ba0:	83 ec 04             	sub    $0x4,%esp
  801ba3:	68 95 40 80 00       	push   $0x804095
  801ba8:	6a 6a                	push   $0x6a
  801baa:	68 b3 40 80 00       	push   $0x8040b3
  801baf:	e8 3f ed ff ff       	call   8008f3 <_panic>
  801bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb7:	8b 00                	mov    (%eax),%eax
  801bb9:	85 c0                	test   %eax,%eax
  801bbb:	74 10                	je     801bcd <free+0x75>
  801bbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bc0:	8b 00                	mov    (%eax),%eax
  801bc2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bc5:	8b 52 04             	mov    0x4(%edx),%edx
  801bc8:	89 50 04             	mov    %edx,0x4(%eax)
  801bcb:	eb 0b                	jmp    801bd8 <free+0x80>
  801bcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd0:	8b 40 04             	mov    0x4(%eax),%eax
  801bd3:	a3 44 50 80 00       	mov    %eax,0x805044
  801bd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bdb:	8b 40 04             	mov    0x4(%eax),%eax
  801bde:	85 c0                	test   %eax,%eax
  801be0:	74 0f                	je     801bf1 <free+0x99>
  801be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be5:	8b 40 04             	mov    0x4(%eax),%eax
  801be8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801beb:	8b 12                	mov    (%edx),%edx
  801bed:	89 10                	mov    %edx,(%eax)
  801bef:	eb 0a                	jmp    801bfb <free+0xa3>
  801bf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bf4:	8b 00                	mov    (%eax),%eax
  801bf6:	a3 40 50 80 00       	mov    %eax,0x805040
  801bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bfe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c07:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801c0e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801c13:	48                   	dec    %eax
  801c14:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(blk);
  801c19:	83 ec 0c             	sub    $0xc,%esp
  801c1c:	ff 75 f4             	pushl  -0xc(%ebp)
  801c1f:	e8 65 13 00 00       	call   802f89 <insert_sorted_with_merge_freeList>
  801c24:	83 c4 10             	add    $0x10,%esp
	}
}
  801c27:	90                   	nop
  801c28:	c9                   	leave  
  801c29:	c3                   	ret    

00801c2a <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801c2a:	55                   	push   %ebp
  801c2b:	89 e5                	mov    %esp,%ebp
  801c2d:	83 ec 28             	sub    $0x28,%esp
  801c30:	8b 45 10             	mov    0x10(%ebp),%eax
  801c33:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c36:	e8 f6 fc ff ff       	call   801931 <InitializeUHeap>
	if (size == 0) return NULL ;
  801c3b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c3f:	75 0a                	jne    801c4b <smalloc+0x21>
  801c41:	b8 00 00 00 00       	mov    $0x0,%eax
  801c46:	e9 af 00 00 00       	jmp    801cfa <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  801c4b:	e8 44 07 00 00       	call   802394 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801c50:	83 f8 01             	cmp    $0x1,%eax
  801c53:	0f 85 9c 00 00 00    	jne    801cf5 <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  801c59:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801c60:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c66:	01 d0                	add    %edx,%eax
  801c68:	48                   	dec    %eax
  801c69:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c6f:	ba 00 00 00 00       	mov    $0x0,%edx
  801c74:	f7 75 f4             	divl   -0xc(%ebp)
  801c77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c7a:	29 d0                	sub    %edx,%eax
  801c7c:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  801c7f:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  801c86:	76 07                	jbe    801c8f <smalloc+0x65>
			return NULL;
  801c88:	b8 00 00 00 00       	mov    $0x0,%eax
  801c8d:	eb 6b                	jmp    801cfa <smalloc+0xd0>
		blk =alloc_block_FF(size);
  801c8f:	83 ec 0c             	sub    $0xc,%esp
  801c92:	ff 75 0c             	pushl  0xc(%ebp)
  801c95:	e8 e7 0c 00 00       	call   802981 <alloc_block_FF>
  801c9a:	83 c4 10             	add    $0x10,%esp
  801c9d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  801ca0:	83 ec 0c             	sub    $0xc,%esp
  801ca3:	ff 75 ec             	pushl  -0x14(%ebp)
  801ca6:	e8 d6 0a 00 00       	call   802781 <insert_sorted_allocList>
  801cab:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  801cae:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801cb2:	75 07                	jne    801cbb <smalloc+0x91>
		{
			return NULL;
  801cb4:	b8 00 00 00 00       	mov    $0x0,%eax
  801cb9:	eb 3f                	jmp    801cfa <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  801cbb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cbe:	8b 40 08             	mov    0x8(%eax),%eax
  801cc1:	89 c2                	mov    %eax,%edx
  801cc3:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801cc7:	52                   	push   %edx
  801cc8:	50                   	push   %eax
  801cc9:	ff 75 0c             	pushl  0xc(%ebp)
  801ccc:	ff 75 08             	pushl  0x8(%ebp)
  801ccf:	e8 45 04 00 00       	call   802119 <sys_createSharedObject>
  801cd4:	83 c4 10             	add    $0x10,%esp
  801cd7:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  801cda:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801cde:	74 06                	je     801ce6 <smalloc+0xbc>
  801ce0:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801ce4:	75 07                	jne    801ced <smalloc+0xc3>
		{
			return NULL;
  801ce6:	b8 00 00 00 00       	mov    $0x0,%eax
  801ceb:	eb 0d                	jmp    801cfa <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  801ced:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cf0:	8b 40 08             	mov    0x8(%eax),%eax
  801cf3:	eb 05                	jmp    801cfa <smalloc+0xd0>
		}
	}
	else
		return NULL;
  801cf5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cfa:	c9                   	leave  
  801cfb:	c3                   	ret    

00801cfc <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801cfc:	55                   	push   %ebp
  801cfd:	89 e5                	mov    %esp,%ebp
  801cff:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d02:	e8 2a fc ff ff       	call   801931 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801d07:	83 ec 08             	sub    $0x8,%esp
  801d0a:	ff 75 0c             	pushl  0xc(%ebp)
  801d0d:	ff 75 08             	pushl  0x8(%ebp)
  801d10:	e8 2e 04 00 00       	call   802143 <sys_getSizeOfSharedObject>
  801d15:	83 c4 10             	add    $0x10,%esp
  801d18:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  801d1b:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801d1f:	75 0a                	jne    801d2b <sget+0x2f>
	{
		return NULL;
  801d21:	b8 00 00 00 00       	mov    $0x0,%eax
  801d26:	e9 94 00 00 00       	jmp    801dbf <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801d2b:	e8 64 06 00 00       	call   802394 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d30:	85 c0                	test   %eax,%eax
  801d32:	0f 84 82 00 00 00    	je     801dba <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  801d38:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  801d3f:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801d46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d4c:	01 d0                	add    %edx,%eax
  801d4e:	48                   	dec    %eax
  801d4f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801d52:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d55:	ba 00 00 00 00       	mov    $0x0,%edx
  801d5a:	f7 75 ec             	divl   -0x14(%ebp)
  801d5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d60:	29 d0                	sub    %edx,%eax
  801d62:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  801d65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d68:	83 ec 0c             	sub    $0xc,%esp
  801d6b:	50                   	push   %eax
  801d6c:	e8 10 0c 00 00       	call   802981 <alloc_block_FF>
  801d71:	83 c4 10             	add    $0x10,%esp
  801d74:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  801d77:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d7b:	75 07                	jne    801d84 <sget+0x88>
		{
			return NULL;
  801d7d:	b8 00 00 00 00       	mov    $0x0,%eax
  801d82:	eb 3b                	jmp    801dbf <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  801d84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d87:	8b 40 08             	mov    0x8(%eax),%eax
  801d8a:	83 ec 04             	sub    $0x4,%esp
  801d8d:	50                   	push   %eax
  801d8e:	ff 75 0c             	pushl  0xc(%ebp)
  801d91:	ff 75 08             	pushl  0x8(%ebp)
  801d94:	e8 c7 03 00 00       	call   802160 <sys_getSharedObject>
  801d99:	83 c4 10             	add    $0x10,%esp
  801d9c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  801d9f:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801da3:	74 06                	je     801dab <sget+0xaf>
  801da5:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  801da9:	75 07                	jne    801db2 <sget+0xb6>
		{
			return NULL;
  801dab:	b8 00 00 00 00       	mov    $0x0,%eax
  801db0:	eb 0d                	jmp    801dbf <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  801db2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801db5:	8b 40 08             	mov    0x8(%eax),%eax
  801db8:	eb 05                	jmp    801dbf <sget+0xc3>
		}
	}
	else
			return NULL;
  801dba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dbf:	c9                   	leave  
  801dc0:	c3                   	ret    

00801dc1 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801dc1:	55                   	push   %ebp
  801dc2:	89 e5                	mov    %esp,%ebp
  801dc4:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801dc7:	e8 65 fb ff ff       	call   801931 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801dcc:	83 ec 04             	sub    $0x4,%esp
  801dcf:	68 c0 40 80 00       	push   $0x8040c0
  801dd4:	68 e1 00 00 00       	push   $0xe1
  801dd9:	68 b3 40 80 00       	push   $0x8040b3
  801dde:	e8 10 eb ff ff       	call   8008f3 <_panic>

00801de3 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801de3:	55                   	push   %ebp
  801de4:	89 e5                	mov    %esp,%ebp
  801de6:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801de9:	83 ec 04             	sub    $0x4,%esp
  801dec:	68 e8 40 80 00       	push   $0x8040e8
  801df1:	68 f5 00 00 00       	push   $0xf5
  801df6:	68 b3 40 80 00       	push   $0x8040b3
  801dfb:	e8 f3 ea ff ff       	call   8008f3 <_panic>

00801e00 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801e00:	55                   	push   %ebp
  801e01:	89 e5                	mov    %esp,%ebp
  801e03:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e06:	83 ec 04             	sub    $0x4,%esp
  801e09:	68 0c 41 80 00       	push   $0x80410c
  801e0e:	68 00 01 00 00       	push   $0x100
  801e13:	68 b3 40 80 00       	push   $0x8040b3
  801e18:	e8 d6 ea ff ff       	call   8008f3 <_panic>

00801e1d <shrink>:

}
void shrink(uint32 newSize)
{
  801e1d:	55                   	push   %ebp
  801e1e:	89 e5                	mov    %esp,%ebp
  801e20:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e23:	83 ec 04             	sub    $0x4,%esp
  801e26:	68 0c 41 80 00       	push   $0x80410c
  801e2b:	68 05 01 00 00       	push   $0x105
  801e30:	68 b3 40 80 00       	push   $0x8040b3
  801e35:	e8 b9 ea ff ff       	call   8008f3 <_panic>

00801e3a <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801e3a:	55                   	push   %ebp
  801e3b:	89 e5                	mov    %esp,%ebp
  801e3d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e40:	83 ec 04             	sub    $0x4,%esp
  801e43:	68 0c 41 80 00       	push   $0x80410c
  801e48:	68 0a 01 00 00       	push   $0x10a
  801e4d:	68 b3 40 80 00       	push   $0x8040b3
  801e52:	e8 9c ea ff ff       	call   8008f3 <_panic>

00801e57 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801e57:	55                   	push   %ebp
  801e58:	89 e5                	mov    %esp,%ebp
  801e5a:	57                   	push   %edi
  801e5b:	56                   	push   %esi
  801e5c:	53                   	push   %ebx
  801e5d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801e60:	8b 45 08             	mov    0x8(%ebp),%eax
  801e63:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e66:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e69:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e6c:	8b 7d 18             	mov    0x18(%ebp),%edi
  801e6f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801e72:	cd 30                	int    $0x30
  801e74:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801e77:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801e7a:	83 c4 10             	add    $0x10,%esp
  801e7d:	5b                   	pop    %ebx
  801e7e:	5e                   	pop    %esi
  801e7f:	5f                   	pop    %edi
  801e80:	5d                   	pop    %ebp
  801e81:	c3                   	ret    

00801e82 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801e82:	55                   	push   %ebp
  801e83:	89 e5                	mov    %esp,%ebp
  801e85:	83 ec 04             	sub    $0x4,%esp
  801e88:	8b 45 10             	mov    0x10(%ebp),%eax
  801e8b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801e8e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e92:	8b 45 08             	mov    0x8(%ebp),%eax
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	52                   	push   %edx
  801e9a:	ff 75 0c             	pushl  0xc(%ebp)
  801e9d:	50                   	push   %eax
  801e9e:	6a 00                	push   $0x0
  801ea0:	e8 b2 ff ff ff       	call   801e57 <syscall>
  801ea5:	83 c4 18             	add    $0x18,%esp
}
  801ea8:	90                   	nop
  801ea9:	c9                   	leave  
  801eaa:	c3                   	ret    

00801eab <sys_cgetc>:

int
sys_cgetc(void)
{
  801eab:	55                   	push   %ebp
  801eac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 01                	push   $0x1
  801eba:	e8 98 ff ff ff       	call   801e57 <syscall>
  801ebf:	83 c4 18             	add    $0x18,%esp
}
  801ec2:	c9                   	leave  
  801ec3:	c3                   	ret    

00801ec4 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801ec4:	55                   	push   %ebp
  801ec5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801ec7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eca:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 00                	push   $0x0
  801ed3:	52                   	push   %edx
  801ed4:	50                   	push   %eax
  801ed5:	6a 05                	push   $0x5
  801ed7:	e8 7b ff ff ff       	call   801e57 <syscall>
  801edc:	83 c4 18             	add    $0x18,%esp
}
  801edf:	c9                   	leave  
  801ee0:	c3                   	ret    

00801ee1 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801ee1:	55                   	push   %ebp
  801ee2:	89 e5                	mov    %esp,%ebp
  801ee4:	56                   	push   %esi
  801ee5:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801ee6:	8b 75 18             	mov    0x18(%ebp),%esi
  801ee9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801eec:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801eef:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef5:	56                   	push   %esi
  801ef6:	53                   	push   %ebx
  801ef7:	51                   	push   %ecx
  801ef8:	52                   	push   %edx
  801ef9:	50                   	push   %eax
  801efa:	6a 06                	push   $0x6
  801efc:	e8 56 ff ff ff       	call   801e57 <syscall>
  801f01:	83 c4 18             	add    $0x18,%esp
}
  801f04:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f07:	5b                   	pop    %ebx
  801f08:	5e                   	pop    %esi
  801f09:	5d                   	pop    %ebp
  801f0a:	c3                   	ret    

00801f0b <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801f0b:	55                   	push   %ebp
  801f0c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801f0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f11:	8b 45 08             	mov    0x8(%ebp),%eax
  801f14:	6a 00                	push   $0x0
  801f16:	6a 00                	push   $0x0
  801f18:	6a 00                	push   $0x0
  801f1a:	52                   	push   %edx
  801f1b:	50                   	push   %eax
  801f1c:	6a 07                	push   $0x7
  801f1e:	e8 34 ff ff ff       	call   801e57 <syscall>
  801f23:	83 c4 18             	add    $0x18,%esp
}
  801f26:	c9                   	leave  
  801f27:	c3                   	ret    

00801f28 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801f28:	55                   	push   %ebp
  801f29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801f2b:	6a 00                	push   $0x0
  801f2d:	6a 00                	push   $0x0
  801f2f:	6a 00                	push   $0x0
  801f31:	ff 75 0c             	pushl  0xc(%ebp)
  801f34:	ff 75 08             	pushl  0x8(%ebp)
  801f37:	6a 08                	push   $0x8
  801f39:	e8 19 ff ff ff       	call   801e57 <syscall>
  801f3e:	83 c4 18             	add    $0x18,%esp
}
  801f41:	c9                   	leave  
  801f42:	c3                   	ret    

00801f43 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801f43:	55                   	push   %ebp
  801f44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801f46:	6a 00                	push   $0x0
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 00                	push   $0x0
  801f50:	6a 09                	push   $0x9
  801f52:	e8 00 ff ff ff       	call   801e57 <syscall>
  801f57:	83 c4 18             	add    $0x18,%esp
}
  801f5a:	c9                   	leave  
  801f5b:	c3                   	ret    

00801f5c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801f5c:	55                   	push   %ebp
  801f5d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801f5f:	6a 00                	push   $0x0
  801f61:	6a 00                	push   $0x0
  801f63:	6a 00                	push   $0x0
  801f65:	6a 00                	push   $0x0
  801f67:	6a 00                	push   $0x0
  801f69:	6a 0a                	push   $0xa
  801f6b:	e8 e7 fe ff ff       	call   801e57 <syscall>
  801f70:	83 c4 18             	add    $0x18,%esp
}
  801f73:	c9                   	leave  
  801f74:	c3                   	ret    

00801f75 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801f75:	55                   	push   %ebp
  801f76:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801f78:	6a 00                	push   $0x0
  801f7a:	6a 00                	push   $0x0
  801f7c:	6a 00                	push   $0x0
  801f7e:	6a 00                	push   $0x0
  801f80:	6a 00                	push   $0x0
  801f82:	6a 0b                	push   $0xb
  801f84:	e8 ce fe ff ff       	call   801e57 <syscall>
  801f89:	83 c4 18             	add    $0x18,%esp
}
  801f8c:	c9                   	leave  
  801f8d:	c3                   	ret    

00801f8e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801f8e:	55                   	push   %ebp
  801f8f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801f91:	6a 00                	push   $0x0
  801f93:	6a 00                	push   $0x0
  801f95:	6a 00                	push   $0x0
  801f97:	ff 75 0c             	pushl  0xc(%ebp)
  801f9a:	ff 75 08             	pushl  0x8(%ebp)
  801f9d:	6a 0f                	push   $0xf
  801f9f:	e8 b3 fe ff ff       	call   801e57 <syscall>
  801fa4:	83 c4 18             	add    $0x18,%esp
	return;
  801fa7:	90                   	nop
}
  801fa8:	c9                   	leave  
  801fa9:	c3                   	ret    

00801faa <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801faa:	55                   	push   %ebp
  801fab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801fad:	6a 00                	push   $0x0
  801faf:	6a 00                	push   $0x0
  801fb1:	6a 00                	push   $0x0
  801fb3:	ff 75 0c             	pushl  0xc(%ebp)
  801fb6:	ff 75 08             	pushl  0x8(%ebp)
  801fb9:	6a 10                	push   $0x10
  801fbb:	e8 97 fe ff ff       	call   801e57 <syscall>
  801fc0:	83 c4 18             	add    $0x18,%esp
	return ;
  801fc3:	90                   	nop
}
  801fc4:	c9                   	leave  
  801fc5:	c3                   	ret    

00801fc6 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801fc6:	55                   	push   %ebp
  801fc7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801fc9:	6a 00                	push   $0x0
  801fcb:	6a 00                	push   $0x0
  801fcd:	ff 75 10             	pushl  0x10(%ebp)
  801fd0:	ff 75 0c             	pushl  0xc(%ebp)
  801fd3:	ff 75 08             	pushl  0x8(%ebp)
  801fd6:	6a 11                	push   $0x11
  801fd8:	e8 7a fe ff ff       	call   801e57 <syscall>
  801fdd:	83 c4 18             	add    $0x18,%esp
	return ;
  801fe0:	90                   	nop
}
  801fe1:	c9                   	leave  
  801fe2:	c3                   	ret    

00801fe3 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801fe3:	55                   	push   %ebp
  801fe4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801fe6:	6a 00                	push   $0x0
  801fe8:	6a 00                	push   $0x0
  801fea:	6a 00                	push   $0x0
  801fec:	6a 00                	push   $0x0
  801fee:	6a 00                	push   $0x0
  801ff0:	6a 0c                	push   $0xc
  801ff2:	e8 60 fe ff ff       	call   801e57 <syscall>
  801ff7:	83 c4 18             	add    $0x18,%esp
}
  801ffa:	c9                   	leave  
  801ffb:	c3                   	ret    

00801ffc <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ffc:	55                   	push   %ebp
  801ffd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801fff:	6a 00                	push   $0x0
  802001:	6a 00                	push   $0x0
  802003:	6a 00                	push   $0x0
  802005:	6a 00                	push   $0x0
  802007:	ff 75 08             	pushl  0x8(%ebp)
  80200a:	6a 0d                	push   $0xd
  80200c:	e8 46 fe ff ff       	call   801e57 <syscall>
  802011:	83 c4 18             	add    $0x18,%esp
}
  802014:	c9                   	leave  
  802015:	c3                   	ret    

00802016 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802016:	55                   	push   %ebp
  802017:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802019:	6a 00                	push   $0x0
  80201b:	6a 00                	push   $0x0
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	6a 00                	push   $0x0
  802023:	6a 0e                	push   $0xe
  802025:	e8 2d fe ff ff       	call   801e57 <syscall>
  80202a:	83 c4 18             	add    $0x18,%esp
}
  80202d:	90                   	nop
  80202e:	c9                   	leave  
  80202f:	c3                   	ret    

00802030 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802030:	55                   	push   %ebp
  802031:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802033:	6a 00                	push   $0x0
  802035:	6a 00                	push   $0x0
  802037:	6a 00                	push   $0x0
  802039:	6a 00                	push   $0x0
  80203b:	6a 00                	push   $0x0
  80203d:	6a 13                	push   $0x13
  80203f:	e8 13 fe ff ff       	call   801e57 <syscall>
  802044:	83 c4 18             	add    $0x18,%esp
}
  802047:	90                   	nop
  802048:	c9                   	leave  
  802049:	c3                   	ret    

0080204a <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80204a:	55                   	push   %ebp
  80204b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80204d:	6a 00                	push   $0x0
  80204f:	6a 00                	push   $0x0
  802051:	6a 00                	push   $0x0
  802053:	6a 00                	push   $0x0
  802055:	6a 00                	push   $0x0
  802057:	6a 14                	push   $0x14
  802059:	e8 f9 fd ff ff       	call   801e57 <syscall>
  80205e:	83 c4 18             	add    $0x18,%esp
}
  802061:	90                   	nop
  802062:	c9                   	leave  
  802063:	c3                   	ret    

00802064 <sys_cputc>:


void
sys_cputc(const char c)
{
  802064:	55                   	push   %ebp
  802065:	89 e5                	mov    %esp,%ebp
  802067:	83 ec 04             	sub    $0x4,%esp
  80206a:	8b 45 08             	mov    0x8(%ebp),%eax
  80206d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802070:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802074:	6a 00                	push   $0x0
  802076:	6a 00                	push   $0x0
  802078:	6a 00                	push   $0x0
  80207a:	6a 00                	push   $0x0
  80207c:	50                   	push   %eax
  80207d:	6a 15                	push   $0x15
  80207f:	e8 d3 fd ff ff       	call   801e57 <syscall>
  802084:	83 c4 18             	add    $0x18,%esp
}
  802087:	90                   	nop
  802088:	c9                   	leave  
  802089:	c3                   	ret    

0080208a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80208a:	55                   	push   %ebp
  80208b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80208d:	6a 00                	push   $0x0
  80208f:	6a 00                	push   $0x0
  802091:	6a 00                	push   $0x0
  802093:	6a 00                	push   $0x0
  802095:	6a 00                	push   $0x0
  802097:	6a 16                	push   $0x16
  802099:	e8 b9 fd ff ff       	call   801e57 <syscall>
  80209e:	83 c4 18             	add    $0x18,%esp
}
  8020a1:	90                   	nop
  8020a2:	c9                   	leave  
  8020a3:	c3                   	ret    

008020a4 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8020a4:	55                   	push   %ebp
  8020a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8020a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020aa:	6a 00                	push   $0x0
  8020ac:	6a 00                	push   $0x0
  8020ae:	6a 00                	push   $0x0
  8020b0:	ff 75 0c             	pushl  0xc(%ebp)
  8020b3:	50                   	push   %eax
  8020b4:	6a 17                	push   $0x17
  8020b6:	e8 9c fd ff ff       	call   801e57 <syscall>
  8020bb:	83 c4 18             	add    $0x18,%esp
}
  8020be:	c9                   	leave  
  8020bf:	c3                   	ret    

008020c0 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8020c0:	55                   	push   %ebp
  8020c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8020c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c9:	6a 00                	push   $0x0
  8020cb:	6a 00                	push   $0x0
  8020cd:	6a 00                	push   $0x0
  8020cf:	52                   	push   %edx
  8020d0:	50                   	push   %eax
  8020d1:	6a 1a                	push   $0x1a
  8020d3:	e8 7f fd ff ff       	call   801e57 <syscall>
  8020d8:	83 c4 18             	add    $0x18,%esp
}
  8020db:	c9                   	leave  
  8020dc:	c3                   	ret    

008020dd <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8020dd:	55                   	push   %ebp
  8020de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8020e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e6:	6a 00                	push   $0x0
  8020e8:	6a 00                	push   $0x0
  8020ea:	6a 00                	push   $0x0
  8020ec:	52                   	push   %edx
  8020ed:	50                   	push   %eax
  8020ee:	6a 18                	push   $0x18
  8020f0:	e8 62 fd ff ff       	call   801e57 <syscall>
  8020f5:	83 c4 18             	add    $0x18,%esp
}
  8020f8:	90                   	nop
  8020f9:	c9                   	leave  
  8020fa:	c3                   	ret    

008020fb <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8020fb:	55                   	push   %ebp
  8020fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8020fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  802101:	8b 45 08             	mov    0x8(%ebp),%eax
  802104:	6a 00                	push   $0x0
  802106:	6a 00                	push   $0x0
  802108:	6a 00                	push   $0x0
  80210a:	52                   	push   %edx
  80210b:	50                   	push   %eax
  80210c:	6a 19                	push   $0x19
  80210e:	e8 44 fd ff ff       	call   801e57 <syscall>
  802113:	83 c4 18             	add    $0x18,%esp
}
  802116:	90                   	nop
  802117:	c9                   	leave  
  802118:	c3                   	ret    

00802119 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802119:	55                   	push   %ebp
  80211a:	89 e5                	mov    %esp,%ebp
  80211c:	83 ec 04             	sub    $0x4,%esp
  80211f:	8b 45 10             	mov    0x10(%ebp),%eax
  802122:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802125:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802128:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80212c:	8b 45 08             	mov    0x8(%ebp),%eax
  80212f:	6a 00                	push   $0x0
  802131:	51                   	push   %ecx
  802132:	52                   	push   %edx
  802133:	ff 75 0c             	pushl  0xc(%ebp)
  802136:	50                   	push   %eax
  802137:	6a 1b                	push   $0x1b
  802139:	e8 19 fd ff ff       	call   801e57 <syscall>
  80213e:	83 c4 18             	add    $0x18,%esp
}
  802141:	c9                   	leave  
  802142:	c3                   	ret    

00802143 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802143:	55                   	push   %ebp
  802144:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802146:	8b 55 0c             	mov    0xc(%ebp),%edx
  802149:	8b 45 08             	mov    0x8(%ebp),%eax
  80214c:	6a 00                	push   $0x0
  80214e:	6a 00                	push   $0x0
  802150:	6a 00                	push   $0x0
  802152:	52                   	push   %edx
  802153:	50                   	push   %eax
  802154:	6a 1c                	push   $0x1c
  802156:	e8 fc fc ff ff       	call   801e57 <syscall>
  80215b:	83 c4 18             	add    $0x18,%esp
}
  80215e:	c9                   	leave  
  80215f:	c3                   	ret    

00802160 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802160:	55                   	push   %ebp
  802161:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802163:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802166:	8b 55 0c             	mov    0xc(%ebp),%edx
  802169:	8b 45 08             	mov    0x8(%ebp),%eax
  80216c:	6a 00                	push   $0x0
  80216e:	6a 00                	push   $0x0
  802170:	51                   	push   %ecx
  802171:	52                   	push   %edx
  802172:	50                   	push   %eax
  802173:	6a 1d                	push   $0x1d
  802175:	e8 dd fc ff ff       	call   801e57 <syscall>
  80217a:	83 c4 18             	add    $0x18,%esp
}
  80217d:	c9                   	leave  
  80217e:	c3                   	ret    

0080217f <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80217f:	55                   	push   %ebp
  802180:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802182:	8b 55 0c             	mov    0xc(%ebp),%edx
  802185:	8b 45 08             	mov    0x8(%ebp),%eax
  802188:	6a 00                	push   $0x0
  80218a:	6a 00                	push   $0x0
  80218c:	6a 00                	push   $0x0
  80218e:	52                   	push   %edx
  80218f:	50                   	push   %eax
  802190:	6a 1e                	push   $0x1e
  802192:	e8 c0 fc ff ff       	call   801e57 <syscall>
  802197:	83 c4 18             	add    $0x18,%esp
}
  80219a:	c9                   	leave  
  80219b:	c3                   	ret    

0080219c <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80219c:	55                   	push   %ebp
  80219d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80219f:	6a 00                	push   $0x0
  8021a1:	6a 00                	push   $0x0
  8021a3:	6a 00                	push   $0x0
  8021a5:	6a 00                	push   $0x0
  8021a7:	6a 00                	push   $0x0
  8021a9:	6a 1f                	push   $0x1f
  8021ab:	e8 a7 fc ff ff       	call   801e57 <syscall>
  8021b0:	83 c4 18             	add    $0x18,%esp
}
  8021b3:	c9                   	leave  
  8021b4:	c3                   	ret    

008021b5 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8021b5:	55                   	push   %ebp
  8021b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8021b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bb:	6a 00                	push   $0x0
  8021bd:	ff 75 14             	pushl  0x14(%ebp)
  8021c0:	ff 75 10             	pushl  0x10(%ebp)
  8021c3:	ff 75 0c             	pushl  0xc(%ebp)
  8021c6:	50                   	push   %eax
  8021c7:	6a 20                	push   $0x20
  8021c9:	e8 89 fc ff ff       	call   801e57 <syscall>
  8021ce:	83 c4 18             	add    $0x18,%esp
}
  8021d1:	c9                   	leave  
  8021d2:	c3                   	ret    

008021d3 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8021d3:	55                   	push   %ebp
  8021d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8021d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d9:	6a 00                	push   $0x0
  8021db:	6a 00                	push   $0x0
  8021dd:	6a 00                	push   $0x0
  8021df:	6a 00                	push   $0x0
  8021e1:	50                   	push   %eax
  8021e2:	6a 21                	push   $0x21
  8021e4:	e8 6e fc ff ff       	call   801e57 <syscall>
  8021e9:	83 c4 18             	add    $0x18,%esp
}
  8021ec:	90                   	nop
  8021ed:	c9                   	leave  
  8021ee:	c3                   	ret    

008021ef <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8021ef:	55                   	push   %ebp
  8021f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8021f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f5:	6a 00                	push   $0x0
  8021f7:	6a 00                	push   $0x0
  8021f9:	6a 00                	push   $0x0
  8021fb:	6a 00                	push   $0x0
  8021fd:	50                   	push   %eax
  8021fe:	6a 22                	push   $0x22
  802200:	e8 52 fc ff ff       	call   801e57 <syscall>
  802205:	83 c4 18             	add    $0x18,%esp
}
  802208:	c9                   	leave  
  802209:	c3                   	ret    

0080220a <sys_getenvid>:

int32 sys_getenvid(void)
{
  80220a:	55                   	push   %ebp
  80220b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80220d:	6a 00                	push   $0x0
  80220f:	6a 00                	push   $0x0
  802211:	6a 00                	push   $0x0
  802213:	6a 00                	push   $0x0
  802215:	6a 00                	push   $0x0
  802217:	6a 02                	push   $0x2
  802219:	e8 39 fc ff ff       	call   801e57 <syscall>
  80221e:	83 c4 18             	add    $0x18,%esp
}
  802221:	c9                   	leave  
  802222:	c3                   	ret    

00802223 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802223:	55                   	push   %ebp
  802224:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802226:	6a 00                	push   $0x0
  802228:	6a 00                	push   $0x0
  80222a:	6a 00                	push   $0x0
  80222c:	6a 00                	push   $0x0
  80222e:	6a 00                	push   $0x0
  802230:	6a 03                	push   $0x3
  802232:	e8 20 fc ff ff       	call   801e57 <syscall>
  802237:	83 c4 18             	add    $0x18,%esp
}
  80223a:	c9                   	leave  
  80223b:	c3                   	ret    

0080223c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80223c:	55                   	push   %ebp
  80223d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80223f:	6a 00                	push   $0x0
  802241:	6a 00                	push   $0x0
  802243:	6a 00                	push   $0x0
  802245:	6a 00                	push   $0x0
  802247:	6a 00                	push   $0x0
  802249:	6a 04                	push   $0x4
  80224b:	e8 07 fc ff ff       	call   801e57 <syscall>
  802250:	83 c4 18             	add    $0x18,%esp
}
  802253:	c9                   	leave  
  802254:	c3                   	ret    

00802255 <sys_exit_env>:


void sys_exit_env(void)
{
  802255:	55                   	push   %ebp
  802256:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802258:	6a 00                	push   $0x0
  80225a:	6a 00                	push   $0x0
  80225c:	6a 00                	push   $0x0
  80225e:	6a 00                	push   $0x0
  802260:	6a 00                	push   $0x0
  802262:	6a 23                	push   $0x23
  802264:	e8 ee fb ff ff       	call   801e57 <syscall>
  802269:	83 c4 18             	add    $0x18,%esp
}
  80226c:	90                   	nop
  80226d:	c9                   	leave  
  80226e:	c3                   	ret    

0080226f <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80226f:	55                   	push   %ebp
  802270:	89 e5                	mov    %esp,%ebp
  802272:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802275:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802278:	8d 50 04             	lea    0x4(%eax),%edx
  80227b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80227e:	6a 00                	push   $0x0
  802280:	6a 00                	push   $0x0
  802282:	6a 00                	push   $0x0
  802284:	52                   	push   %edx
  802285:	50                   	push   %eax
  802286:	6a 24                	push   $0x24
  802288:	e8 ca fb ff ff       	call   801e57 <syscall>
  80228d:	83 c4 18             	add    $0x18,%esp
	return result;
  802290:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802293:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802296:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802299:	89 01                	mov    %eax,(%ecx)
  80229b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80229e:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a1:	c9                   	leave  
  8022a2:	c2 04 00             	ret    $0x4

008022a5 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8022a5:	55                   	push   %ebp
  8022a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8022a8:	6a 00                	push   $0x0
  8022aa:	6a 00                	push   $0x0
  8022ac:	ff 75 10             	pushl  0x10(%ebp)
  8022af:	ff 75 0c             	pushl  0xc(%ebp)
  8022b2:	ff 75 08             	pushl  0x8(%ebp)
  8022b5:	6a 12                	push   $0x12
  8022b7:	e8 9b fb ff ff       	call   801e57 <syscall>
  8022bc:	83 c4 18             	add    $0x18,%esp
	return ;
  8022bf:	90                   	nop
}
  8022c0:	c9                   	leave  
  8022c1:	c3                   	ret    

008022c2 <sys_rcr2>:
uint32 sys_rcr2()
{
  8022c2:	55                   	push   %ebp
  8022c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8022c5:	6a 00                	push   $0x0
  8022c7:	6a 00                	push   $0x0
  8022c9:	6a 00                	push   $0x0
  8022cb:	6a 00                	push   $0x0
  8022cd:	6a 00                	push   $0x0
  8022cf:	6a 25                	push   $0x25
  8022d1:	e8 81 fb ff ff       	call   801e57 <syscall>
  8022d6:	83 c4 18             	add    $0x18,%esp
}
  8022d9:	c9                   	leave  
  8022da:	c3                   	ret    

008022db <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8022db:	55                   	push   %ebp
  8022dc:	89 e5                	mov    %esp,%ebp
  8022de:	83 ec 04             	sub    $0x4,%esp
  8022e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8022e7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8022eb:	6a 00                	push   $0x0
  8022ed:	6a 00                	push   $0x0
  8022ef:	6a 00                	push   $0x0
  8022f1:	6a 00                	push   $0x0
  8022f3:	50                   	push   %eax
  8022f4:	6a 26                	push   $0x26
  8022f6:	e8 5c fb ff ff       	call   801e57 <syscall>
  8022fb:	83 c4 18             	add    $0x18,%esp
	return ;
  8022fe:	90                   	nop
}
  8022ff:	c9                   	leave  
  802300:	c3                   	ret    

00802301 <rsttst>:
void rsttst()
{
  802301:	55                   	push   %ebp
  802302:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802304:	6a 00                	push   $0x0
  802306:	6a 00                	push   $0x0
  802308:	6a 00                	push   $0x0
  80230a:	6a 00                	push   $0x0
  80230c:	6a 00                	push   $0x0
  80230e:	6a 28                	push   $0x28
  802310:	e8 42 fb ff ff       	call   801e57 <syscall>
  802315:	83 c4 18             	add    $0x18,%esp
	return ;
  802318:	90                   	nop
}
  802319:	c9                   	leave  
  80231a:	c3                   	ret    

0080231b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80231b:	55                   	push   %ebp
  80231c:	89 e5                	mov    %esp,%ebp
  80231e:	83 ec 04             	sub    $0x4,%esp
  802321:	8b 45 14             	mov    0x14(%ebp),%eax
  802324:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802327:	8b 55 18             	mov    0x18(%ebp),%edx
  80232a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80232e:	52                   	push   %edx
  80232f:	50                   	push   %eax
  802330:	ff 75 10             	pushl  0x10(%ebp)
  802333:	ff 75 0c             	pushl  0xc(%ebp)
  802336:	ff 75 08             	pushl  0x8(%ebp)
  802339:	6a 27                	push   $0x27
  80233b:	e8 17 fb ff ff       	call   801e57 <syscall>
  802340:	83 c4 18             	add    $0x18,%esp
	return ;
  802343:	90                   	nop
}
  802344:	c9                   	leave  
  802345:	c3                   	ret    

00802346 <chktst>:
void chktst(uint32 n)
{
  802346:	55                   	push   %ebp
  802347:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802349:	6a 00                	push   $0x0
  80234b:	6a 00                	push   $0x0
  80234d:	6a 00                	push   $0x0
  80234f:	6a 00                	push   $0x0
  802351:	ff 75 08             	pushl  0x8(%ebp)
  802354:	6a 29                	push   $0x29
  802356:	e8 fc fa ff ff       	call   801e57 <syscall>
  80235b:	83 c4 18             	add    $0x18,%esp
	return ;
  80235e:	90                   	nop
}
  80235f:	c9                   	leave  
  802360:	c3                   	ret    

00802361 <inctst>:

void inctst()
{
  802361:	55                   	push   %ebp
  802362:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802364:	6a 00                	push   $0x0
  802366:	6a 00                	push   $0x0
  802368:	6a 00                	push   $0x0
  80236a:	6a 00                	push   $0x0
  80236c:	6a 00                	push   $0x0
  80236e:	6a 2a                	push   $0x2a
  802370:	e8 e2 fa ff ff       	call   801e57 <syscall>
  802375:	83 c4 18             	add    $0x18,%esp
	return ;
  802378:	90                   	nop
}
  802379:	c9                   	leave  
  80237a:	c3                   	ret    

0080237b <gettst>:
uint32 gettst()
{
  80237b:	55                   	push   %ebp
  80237c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80237e:	6a 00                	push   $0x0
  802380:	6a 00                	push   $0x0
  802382:	6a 00                	push   $0x0
  802384:	6a 00                	push   $0x0
  802386:	6a 00                	push   $0x0
  802388:	6a 2b                	push   $0x2b
  80238a:	e8 c8 fa ff ff       	call   801e57 <syscall>
  80238f:	83 c4 18             	add    $0x18,%esp
}
  802392:	c9                   	leave  
  802393:	c3                   	ret    

00802394 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802394:	55                   	push   %ebp
  802395:	89 e5                	mov    %esp,%ebp
  802397:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80239a:	6a 00                	push   $0x0
  80239c:	6a 00                	push   $0x0
  80239e:	6a 00                	push   $0x0
  8023a0:	6a 00                	push   $0x0
  8023a2:	6a 00                	push   $0x0
  8023a4:	6a 2c                	push   $0x2c
  8023a6:	e8 ac fa ff ff       	call   801e57 <syscall>
  8023ab:	83 c4 18             	add    $0x18,%esp
  8023ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8023b1:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8023b5:	75 07                	jne    8023be <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8023b7:	b8 01 00 00 00       	mov    $0x1,%eax
  8023bc:	eb 05                	jmp    8023c3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8023be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023c3:	c9                   	leave  
  8023c4:	c3                   	ret    

008023c5 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8023c5:	55                   	push   %ebp
  8023c6:	89 e5                	mov    %esp,%ebp
  8023c8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023cb:	6a 00                	push   $0x0
  8023cd:	6a 00                	push   $0x0
  8023cf:	6a 00                	push   $0x0
  8023d1:	6a 00                	push   $0x0
  8023d3:	6a 00                	push   $0x0
  8023d5:	6a 2c                	push   $0x2c
  8023d7:	e8 7b fa ff ff       	call   801e57 <syscall>
  8023dc:	83 c4 18             	add    $0x18,%esp
  8023df:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8023e2:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8023e6:	75 07                	jne    8023ef <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8023e8:	b8 01 00 00 00       	mov    $0x1,%eax
  8023ed:	eb 05                	jmp    8023f4 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8023ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023f4:	c9                   	leave  
  8023f5:	c3                   	ret    

008023f6 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8023f6:	55                   	push   %ebp
  8023f7:	89 e5                	mov    %esp,%ebp
  8023f9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023fc:	6a 00                	push   $0x0
  8023fe:	6a 00                	push   $0x0
  802400:	6a 00                	push   $0x0
  802402:	6a 00                	push   $0x0
  802404:	6a 00                	push   $0x0
  802406:	6a 2c                	push   $0x2c
  802408:	e8 4a fa ff ff       	call   801e57 <syscall>
  80240d:	83 c4 18             	add    $0x18,%esp
  802410:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802413:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802417:	75 07                	jne    802420 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802419:	b8 01 00 00 00       	mov    $0x1,%eax
  80241e:	eb 05                	jmp    802425 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802420:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802425:	c9                   	leave  
  802426:	c3                   	ret    

00802427 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
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
  802439:	e8 19 fa ff ff       	call   801e57 <syscall>
  80243e:	83 c4 18             	add    $0x18,%esp
  802441:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802444:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802448:	75 07                	jne    802451 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80244a:	b8 01 00 00 00       	mov    $0x1,%eax
  80244f:	eb 05                	jmp    802456 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802451:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802456:	c9                   	leave  
  802457:	c3                   	ret    

00802458 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802458:	55                   	push   %ebp
  802459:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80245b:	6a 00                	push   $0x0
  80245d:	6a 00                	push   $0x0
  80245f:	6a 00                	push   $0x0
  802461:	6a 00                	push   $0x0
  802463:	ff 75 08             	pushl  0x8(%ebp)
  802466:	6a 2d                	push   $0x2d
  802468:	e8 ea f9 ff ff       	call   801e57 <syscall>
  80246d:	83 c4 18             	add    $0x18,%esp
	return ;
  802470:	90                   	nop
}
  802471:	c9                   	leave  
  802472:	c3                   	ret    

00802473 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802473:	55                   	push   %ebp
  802474:	89 e5                	mov    %esp,%ebp
  802476:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802477:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80247a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80247d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802480:	8b 45 08             	mov    0x8(%ebp),%eax
  802483:	6a 00                	push   $0x0
  802485:	53                   	push   %ebx
  802486:	51                   	push   %ecx
  802487:	52                   	push   %edx
  802488:	50                   	push   %eax
  802489:	6a 2e                	push   $0x2e
  80248b:	e8 c7 f9 ff ff       	call   801e57 <syscall>
  802490:	83 c4 18             	add    $0x18,%esp
}
  802493:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802496:	c9                   	leave  
  802497:	c3                   	ret    

00802498 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802498:	55                   	push   %ebp
  802499:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80249b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80249e:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a1:	6a 00                	push   $0x0
  8024a3:	6a 00                	push   $0x0
  8024a5:	6a 00                	push   $0x0
  8024a7:	52                   	push   %edx
  8024a8:	50                   	push   %eax
  8024a9:	6a 2f                	push   $0x2f
  8024ab:	e8 a7 f9 ff ff       	call   801e57 <syscall>
  8024b0:	83 c4 18             	add    $0x18,%esp
}
  8024b3:	c9                   	leave  
  8024b4:	c3                   	ret    

008024b5 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8024b5:	55                   	push   %ebp
  8024b6:	89 e5                	mov    %esp,%ebp
  8024b8:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8024bb:	83 ec 0c             	sub    $0xc,%esp
  8024be:	68 1c 41 80 00       	push   $0x80411c
  8024c3:	e8 df e6 ff ff       	call   800ba7 <cprintf>
  8024c8:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8024cb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8024d2:	83 ec 0c             	sub    $0xc,%esp
  8024d5:	68 48 41 80 00       	push   $0x804148
  8024da:	e8 c8 e6 ff ff       	call   800ba7 <cprintf>
  8024df:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8024e2:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8024e6:	a1 38 51 80 00       	mov    0x805138,%eax
  8024eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024ee:	eb 56                	jmp    802546 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8024f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024f4:	74 1c                	je     802512 <print_mem_block_lists+0x5d>
  8024f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f9:	8b 50 08             	mov    0x8(%eax),%edx
  8024fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ff:	8b 48 08             	mov    0x8(%eax),%ecx
  802502:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802505:	8b 40 0c             	mov    0xc(%eax),%eax
  802508:	01 c8                	add    %ecx,%eax
  80250a:	39 c2                	cmp    %eax,%edx
  80250c:	73 04                	jae    802512 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80250e:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802512:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802515:	8b 50 08             	mov    0x8(%eax),%edx
  802518:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251b:	8b 40 0c             	mov    0xc(%eax),%eax
  80251e:	01 c2                	add    %eax,%edx
  802520:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802523:	8b 40 08             	mov    0x8(%eax),%eax
  802526:	83 ec 04             	sub    $0x4,%esp
  802529:	52                   	push   %edx
  80252a:	50                   	push   %eax
  80252b:	68 5d 41 80 00       	push   $0x80415d
  802530:	e8 72 e6 ff ff       	call   800ba7 <cprintf>
  802535:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802538:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80253e:	a1 40 51 80 00       	mov    0x805140,%eax
  802543:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802546:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80254a:	74 07                	je     802553 <print_mem_block_lists+0x9e>
  80254c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254f:	8b 00                	mov    (%eax),%eax
  802551:	eb 05                	jmp    802558 <print_mem_block_lists+0xa3>
  802553:	b8 00 00 00 00       	mov    $0x0,%eax
  802558:	a3 40 51 80 00       	mov    %eax,0x805140
  80255d:	a1 40 51 80 00       	mov    0x805140,%eax
  802562:	85 c0                	test   %eax,%eax
  802564:	75 8a                	jne    8024f0 <print_mem_block_lists+0x3b>
  802566:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80256a:	75 84                	jne    8024f0 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80256c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802570:	75 10                	jne    802582 <print_mem_block_lists+0xcd>
  802572:	83 ec 0c             	sub    $0xc,%esp
  802575:	68 6c 41 80 00       	push   $0x80416c
  80257a:	e8 28 e6 ff ff       	call   800ba7 <cprintf>
  80257f:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802582:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802589:	83 ec 0c             	sub    $0xc,%esp
  80258c:	68 90 41 80 00       	push   $0x804190
  802591:	e8 11 e6 ff ff       	call   800ba7 <cprintf>
  802596:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802599:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80259d:	a1 40 50 80 00       	mov    0x805040,%eax
  8025a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025a5:	eb 56                	jmp    8025fd <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8025a7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025ab:	74 1c                	je     8025c9 <print_mem_block_lists+0x114>
  8025ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b0:	8b 50 08             	mov    0x8(%eax),%edx
  8025b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b6:	8b 48 08             	mov    0x8(%eax),%ecx
  8025b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8025bf:	01 c8                	add    %ecx,%eax
  8025c1:	39 c2                	cmp    %eax,%edx
  8025c3:	73 04                	jae    8025c9 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8025c5:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8025c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cc:	8b 50 08             	mov    0x8(%eax),%edx
  8025cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8025d5:	01 c2                	add    %eax,%edx
  8025d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025da:	8b 40 08             	mov    0x8(%eax),%eax
  8025dd:	83 ec 04             	sub    $0x4,%esp
  8025e0:	52                   	push   %edx
  8025e1:	50                   	push   %eax
  8025e2:	68 5d 41 80 00       	push   $0x80415d
  8025e7:	e8 bb e5 ff ff       	call   800ba7 <cprintf>
  8025ec:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8025ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8025f5:	a1 48 50 80 00       	mov    0x805048,%eax
  8025fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802601:	74 07                	je     80260a <print_mem_block_lists+0x155>
  802603:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802606:	8b 00                	mov    (%eax),%eax
  802608:	eb 05                	jmp    80260f <print_mem_block_lists+0x15a>
  80260a:	b8 00 00 00 00       	mov    $0x0,%eax
  80260f:	a3 48 50 80 00       	mov    %eax,0x805048
  802614:	a1 48 50 80 00       	mov    0x805048,%eax
  802619:	85 c0                	test   %eax,%eax
  80261b:	75 8a                	jne    8025a7 <print_mem_block_lists+0xf2>
  80261d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802621:	75 84                	jne    8025a7 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802623:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802627:	75 10                	jne    802639 <print_mem_block_lists+0x184>
  802629:	83 ec 0c             	sub    $0xc,%esp
  80262c:	68 a8 41 80 00       	push   $0x8041a8
  802631:	e8 71 e5 ff ff       	call   800ba7 <cprintf>
  802636:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802639:	83 ec 0c             	sub    $0xc,%esp
  80263c:	68 1c 41 80 00       	push   $0x80411c
  802641:	e8 61 e5 ff ff       	call   800ba7 <cprintf>
  802646:	83 c4 10             	add    $0x10,%esp

}
  802649:	90                   	nop
  80264a:	c9                   	leave  
  80264b:	c3                   	ret    

0080264c <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80264c:	55                   	push   %ebp
  80264d:	89 e5                	mov    %esp,%ebp
  80264f:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802652:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802659:	00 00 00 
  80265c:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802663:	00 00 00 
  802666:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80266d:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  802670:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802677:	e9 9e 00 00 00       	jmp    80271a <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  80267c:	a1 50 50 80 00       	mov    0x805050,%eax
  802681:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802684:	c1 e2 04             	shl    $0x4,%edx
  802687:	01 d0                	add    %edx,%eax
  802689:	85 c0                	test   %eax,%eax
  80268b:	75 14                	jne    8026a1 <initialize_MemBlocksList+0x55>
  80268d:	83 ec 04             	sub    $0x4,%esp
  802690:	68 d0 41 80 00       	push   $0x8041d0
  802695:	6a 42                	push   $0x42
  802697:	68 f3 41 80 00       	push   $0x8041f3
  80269c:	e8 52 e2 ff ff       	call   8008f3 <_panic>
  8026a1:	a1 50 50 80 00       	mov    0x805050,%eax
  8026a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026a9:	c1 e2 04             	shl    $0x4,%edx
  8026ac:	01 d0                	add    %edx,%eax
  8026ae:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8026b4:	89 10                	mov    %edx,(%eax)
  8026b6:	8b 00                	mov    (%eax),%eax
  8026b8:	85 c0                	test   %eax,%eax
  8026ba:	74 18                	je     8026d4 <initialize_MemBlocksList+0x88>
  8026bc:	a1 48 51 80 00       	mov    0x805148,%eax
  8026c1:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8026c7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8026ca:	c1 e1 04             	shl    $0x4,%ecx
  8026cd:	01 ca                	add    %ecx,%edx
  8026cf:	89 50 04             	mov    %edx,0x4(%eax)
  8026d2:	eb 12                	jmp    8026e6 <initialize_MemBlocksList+0x9a>
  8026d4:	a1 50 50 80 00       	mov    0x805050,%eax
  8026d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026dc:	c1 e2 04             	shl    $0x4,%edx
  8026df:	01 d0                	add    %edx,%eax
  8026e1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8026e6:	a1 50 50 80 00       	mov    0x805050,%eax
  8026eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026ee:	c1 e2 04             	shl    $0x4,%edx
  8026f1:	01 d0                	add    %edx,%eax
  8026f3:	a3 48 51 80 00       	mov    %eax,0x805148
  8026f8:	a1 50 50 80 00       	mov    0x805050,%eax
  8026fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802700:	c1 e2 04             	shl    $0x4,%edx
  802703:	01 d0                	add    %edx,%eax
  802705:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80270c:	a1 54 51 80 00       	mov    0x805154,%eax
  802711:	40                   	inc    %eax
  802712:	a3 54 51 80 00       	mov    %eax,0x805154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  802717:	ff 45 f4             	incl   -0xc(%ebp)
  80271a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802720:	0f 82 56 ff ff ff    	jb     80267c <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  802726:	90                   	nop
  802727:	c9                   	leave  
  802728:	c3                   	ret    

00802729 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802729:	55                   	push   %ebp
  80272a:	89 e5                	mov    %esp,%ebp
  80272c:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  80272f:	8b 45 08             	mov    0x8(%ebp),%eax
  802732:	8b 00                	mov    (%eax),%eax
  802734:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802737:	eb 19                	jmp    802752 <find_block+0x29>
	{
		if(blk->sva==va)
  802739:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80273c:	8b 40 08             	mov    0x8(%eax),%eax
  80273f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802742:	75 05                	jne    802749 <find_block+0x20>
			return (blk);
  802744:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802747:	eb 36                	jmp    80277f <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  802749:	8b 45 08             	mov    0x8(%ebp),%eax
  80274c:	8b 40 08             	mov    0x8(%eax),%eax
  80274f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802752:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802756:	74 07                	je     80275f <find_block+0x36>
  802758:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80275b:	8b 00                	mov    (%eax),%eax
  80275d:	eb 05                	jmp    802764 <find_block+0x3b>
  80275f:	b8 00 00 00 00       	mov    $0x0,%eax
  802764:	8b 55 08             	mov    0x8(%ebp),%edx
  802767:	89 42 08             	mov    %eax,0x8(%edx)
  80276a:	8b 45 08             	mov    0x8(%ebp),%eax
  80276d:	8b 40 08             	mov    0x8(%eax),%eax
  802770:	85 c0                	test   %eax,%eax
  802772:	75 c5                	jne    802739 <find_block+0x10>
  802774:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802778:	75 bf                	jne    802739 <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  80277a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80277f:	c9                   	leave  
  802780:	c3                   	ret    

00802781 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802781:	55                   	push   %ebp
  802782:	89 e5                	mov    %esp,%ebp
  802784:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  802787:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80278c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80278f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  802796:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802799:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80279c:	75 65                	jne    802803 <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80279e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027a2:	75 14                	jne    8027b8 <insert_sorted_allocList+0x37>
  8027a4:	83 ec 04             	sub    $0x4,%esp
  8027a7:	68 d0 41 80 00       	push   $0x8041d0
  8027ac:	6a 5c                	push   $0x5c
  8027ae:	68 f3 41 80 00       	push   $0x8041f3
  8027b3:	e8 3b e1 ff ff       	call   8008f3 <_panic>
  8027b8:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8027be:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c1:	89 10                	mov    %edx,(%eax)
  8027c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c6:	8b 00                	mov    (%eax),%eax
  8027c8:	85 c0                	test   %eax,%eax
  8027ca:	74 0d                	je     8027d9 <insert_sorted_allocList+0x58>
  8027cc:	a1 40 50 80 00       	mov    0x805040,%eax
  8027d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8027d4:	89 50 04             	mov    %edx,0x4(%eax)
  8027d7:	eb 08                	jmp    8027e1 <insert_sorted_allocList+0x60>
  8027d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027dc:	a3 44 50 80 00       	mov    %eax,0x805044
  8027e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e4:	a3 40 50 80 00       	mov    %eax,0x805040
  8027e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027f3:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8027f8:	40                   	inc    %eax
  8027f9:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  8027fe:	e9 7b 01 00 00       	jmp    80297e <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  802803:	a1 44 50 80 00       	mov    0x805044,%eax
  802808:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  80280b:	a1 40 50 80 00       	mov    0x805040,%eax
  802810:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  802813:	8b 45 08             	mov    0x8(%ebp),%eax
  802816:	8b 50 08             	mov    0x8(%eax),%edx
  802819:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80281c:	8b 40 08             	mov    0x8(%eax),%eax
  80281f:	39 c2                	cmp    %eax,%edx
  802821:	76 65                	jbe    802888 <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  802823:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802827:	75 14                	jne    80283d <insert_sorted_allocList+0xbc>
  802829:	83 ec 04             	sub    $0x4,%esp
  80282c:	68 0c 42 80 00       	push   $0x80420c
  802831:	6a 64                	push   $0x64
  802833:	68 f3 41 80 00       	push   $0x8041f3
  802838:	e8 b6 e0 ff ff       	call   8008f3 <_panic>
  80283d:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802843:	8b 45 08             	mov    0x8(%ebp),%eax
  802846:	89 50 04             	mov    %edx,0x4(%eax)
  802849:	8b 45 08             	mov    0x8(%ebp),%eax
  80284c:	8b 40 04             	mov    0x4(%eax),%eax
  80284f:	85 c0                	test   %eax,%eax
  802851:	74 0c                	je     80285f <insert_sorted_allocList+0xde>
  802853:	a1 44 50 80 00       	mov    0x805044,%eax
  802858:	8b 55 08             	mov    0x8(%ebp),%edx
  80285b:	89 10                	mov    %edx,(%eax)
  80285d:	eb 08                	jmp    802867 <insert_sorted_allocList+0xe6>
  80285f:	8b 45 08             	mov    0x8(%ebp),%eax
  802862:	a3 40 50 80 00       	mov    %eax,0x805040
  802867:	8b 45 08             	mov    0x8(%ebp),%eax
  80286a:	a3 44 50 80 00       	mov    %eax,0x805044
  80286f:	8b 45 08             	mov    0x8(%ebp),%eax
  802872:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802878:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80287d:	40                   	inc    %eax
  80287e:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  802883:	e9 f6 00 00 00       	jmp    80297e <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  802888:	8b 45 08             	mov    0x8(%ebp),%eax
  80288b:	8b 50 08             	mov    0x8(%eax),%edx
  80288e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802891:	8b 40 08             	mov    0x8(%eax),%eax
  802894:	39 c2                	cmp    %eax,%edx
  802896:	73 65                	jae    8028fd <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802898:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80289c:	75 14                	jne    8028b2 <insert_sorted_allocList+0x131>
  80289e:	83 ec 04             	sub    $0x4,%esp
  8028a1:	68 d0 41 80 00       	push   $0x8041d0
  8028a6:	6a 68                	push   $0x68
  8028a8:	68 f3 41 80 00       	push   $0x8041f3
  8028ad:	e8 41 e0 ff ff       	call   8008f3 <_panic>
  8028b2:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8028b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028bb:	89 10                	mov    %edx,(%eax)
  8028bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c0:	8b 00                	mov    (%eax),%eax
  8028c2:	85 c0                	test   %eax,%eax
  8028c4:	74 0d                	je     8028d3 <insert_sorted_allocList+0x152>
  8028c6:	a1 40 50 80 00       	mov    0x805040,%eax
  8028cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8028ce:	89 50 04             	mov    %edx,0x4(%eax)
  8028d1:	eb 08                	jmp    8028db <insert_sorted_allocList+0x15a>
  8028d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d6:	a3 44 50 80 00       	mov    %eax,0x805044
  8028db:	8b 45 08             	mov    0x8(%ebp),%eax
  8028de:	a3 40 50 80 00       	mov    %eax,0x805040
  8028e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028ed:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8028f2:	40                   	inc    %eax
  8028f3:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  8028f8:	e9 81 00 00 00       	jmp    80297e <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  8028fd:	a1 40 50 80 00       	mov    0x805040,%eax
  802902:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802905:	eb 51                	jmp    802958 <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  802907:	8b 45 08             	mov    0x8(%ebp),%eax
  80290a:	8b 50 08             	mov    0x8(%eax),%edx
  80290d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802910:	8b 40 08             	mov    0x8(%eax),%eax
  802913:	39 c2                	cmp    %eax,%edx
  802915:	73 39                	jae    802950 <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  802917:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291a:	8b 40 04             	mov    0x4(%eax),%eax
  80291d:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  802920:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802923:	8b 55 08             	mov    0x8(%ebp),%edx
  802926:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  802928:	8b 45 08             	mov    0x8(%ebp),%eax
  80292b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80292e:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  802931:	8b 45 08             	mov    0x8(%ebp),%eax
  802934:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802937:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  802939:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293c:	8b 55 08             	mov    0x8(%ebp),%edx
  80293f:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  802942:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802947:	40                   	inc    %eax
  802948:	a3 4c 50 80 00       	mov    %eax,0x80504c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  80294d:	90                   	nop
				}
			}
		 }

	}
}
  80294e:	eb 2e                	jmp    80297e <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802950:	a1 48 50 80 00       	mov    0x805048,%eax
  802955:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802958:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80295c:	74 07                	je     802965 <insert_sorted_allocList+0x1e4>
  80295e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802961:	8b 00                	mov    (%eax),%eax
  802963:	eb 05                	jmp    80296a <insert_sorted_allocList+0x1e9>
  802965:	b8 00 00 00 00       	mov    $0x0,%eax
  80296a:	a3 48 50 80 00       	mov    %eax,0x805048
  80296f:	a1 48 50 80 00       	mov    0x805048,%eax
  802974:	85 c0                	test   %eax,%eax
  802976:	75 8f                	jne    802907 <insert_sorted_allocList+0x186>
  802978:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80297c:	75 89                	jne    802907 <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  80297e:	90                   	nop
  80297f:	c9                   	leave  
  802980:	c3                   	ret    

00802981 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802981:	55                   	push   %ebp
  802982:	89 e5                	mov    %esp,%ebp
  802984:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802987:	a1 38 51 80 00       	mov    0x805138,%eax
  80298c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80298f:	e9 76 01 00 00       	jmp    802b0a <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  802994:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802997:	8b 40 0c             	mov    0xc(%eax),%eax
  80299a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80299d:	0f 85 8a 00 00 00    	jne    802a2d <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  8029a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029a7:	75 17                	jne    8029c0 <alloc_block_FF+0x3f>
  8029a9:	83 ec 04             	sub    $0x4,%esp
  8029ac:	68 2f 42 80 00       	push   $0x80422f
  8029b1:	68 8a 00 00 00       	push   $0x8a
  8029b6:	68 f3 41 80 00       	push   $0x8041f3
  8029bb:	e8 33 df ff ff       	call   8008f3 <_panic>
  8029c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c3:	8b 00                	mov    (%eax),%eax
  8029c5:	85 c0                	test   %eax,%eax
  8029c7:	74 10                	je     8029d9 <alloc_block_FF+0x58>
  8029c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cc:	8b 00                	mov    (%eax),%eax
  8029ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029d1:	8b 52 04             	mov    0x4(%edx),%edx
  8029d4:	89 50 04             	mov    %edx,0x4(%eax)
  8029d7:	eb 0b                	jmp    8029e4 <alloc_block_FF+0x63>
  8029d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029dc:	8b 40 04             	mov    0x4(%eax),%eax
  8029df:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8029e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e7:	8b 40 04             	mov    0x4(%eax),%eax
  8029ea:	85 c0                	test   %eax,%eax
  8029ec:	74 0f                	je     8029fd <alloc_block_FF+0x7c>
  8029ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f1:	8b 40 04             	mov    0x4(%eax),%eax
  8029f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029f7:	8b 12                	mov    (%edx),%edx
  8029f9:	89 10                	mov    %edx,(%eax)
  8029fb:	eb 0a                	jmp    802a07 <alloc_block_FF+0x86>
  8029fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a00:	8b 00                	mov    (%eax),%eax
  802a02:	a3 38 51 80 00       	mov    %eax,0x805138
  802a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a13:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a1a:	a1 44 51 80 00       	mov    0x805144,%eax
  802a1f:	48                   	dec    %eax
  802a20:	a3 44 51 80 00       	mov    %eax,0x805144
			return element;
  802a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a28:	e9 10 01 00 00       	jmp    802b3d <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  802a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a30:	8b 40 0c             	mov    0xc(%eax),%eax
  802a33:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a36:	0f 86 c6 00 00 00    	jbe    802b02 <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802a3c:	a1 48 51 80 00       	mov    0x805148,%eax
  802a41:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802a44:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a48:	75 17                	jne    802a61 <alloc_block_FF+0xe0>
  802a4a:	83 ec 04             	sub    $0x4,%esp
  802a4d:	68 2f 42 80 00       	push   $0x80422f
  802a52:	68 90 00 00 00       	push   $0x90
  802a57:	68 f3 41 80 00       	push   $0x8041f3
  802a5c:	e8 92 de ff ff       	call   8008f3 <_panic>
  802a61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a64:	8b 00                	mov    (%eax),%eax
  802a66:	85 c0                	test   %eax,%eax
  802a68:	74 10                	je     802a7a <alloc_block_FF+0xf9>
  802a6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a6d:	8b 00                	mov    (%eax),%eax
  802a6f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a72:	8b 52 04             	mov    0x4(%edx),%edx
  802a75:	89 50 04             	mov    %edx,0x4(%eax)
  802a78:	eb 0b                	jmp    802a85 <alloc_block_FF+0x104>
  802a7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a7d:	8b 40 04             	mov    0x4(%eax),%eax
  802a80:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a88:	8b 40 04             	mov    0x4(%eax),%eax
  802a8b:	85 c0                	test   %eax,%eax
  802a8d:	74 0f                	je     802a9e <alloc_block_FF+0x11d>
  802a8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a92:	8b 40 04             	mov    0x4(%eax),%eax
  802a95:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a98:	8b 12                	mov    (%edx),%edx
  802a9a:	89 10                	mov    %edx,(%eax)
  802a9c:	eb 0a                	jmp    802aa8 <alloc_block_FF+0x127>
  802a9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa1:	8b 00                	mov    (%eax),%eax
  802aa3:	a3 48 51 80 00       	mov    %eax,0x805148
  802aa8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ab1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802abb:	a1 54 51 80 00       	mov    0x805154,%eax
  802ac0:	48                   	dec    %eax
  802ac1:	a3 54 51 80 00       	mov    %eax,0x805154
			 element1->size =size;
  802ac6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac9:	8b 55 08             	mov    0x8(%ebp),%edx
  802acc:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  802acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad2:	8b 50 08             	mov    0x8(%eax),%edx
  802ad5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad8:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  802adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ade:	8b 50 08             	mov    0x8(%eax),%edx
  802ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae4:	01 c2                	add    %eax,%edx
  802ae6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae9:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  802aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aef:	8b 40 0c             	mov    0xc(%eax),%eax
  802af2:	2b 45 08             	sub    0x8(%ebp),%eax
  802af5:	89 c2                	mov    %eax,%edx
  802af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afa:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  802afd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b00:	eb 3b                	jmp    802b3d <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802b02:	a1 40 51 80 00       	mov    0x805140,%eax
  802b07:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b0a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b0e:	74 07                	je     802b17 <alloc_block_FF+0x196>
  802b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b13:	8b 00                	mov    (%eax),%eax
  802b15:	eb 05                	jmp    802b1c <alloc_block_FF+0x19b>
  802b17:	b8 00 00 00 00       	mov    $0x0,%eax
  802b1c:	a3 40 51 80 00       	mov    %eax,0x805140
  802b21:	a1 40 51 80 00       	mov    0x805140,%eax
  802b26:	85 c0                	test   %eax,%eax
  802b28:	0f 85 66 fe ff ff    	jne    802994 <alloc_block_FF+0x13>
  802b2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b32:	0f 85 5c fe ff ff    	jne    802994 <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  802b38:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b3d:	c9                   	leave  
  802b3e:	c3                   	ret    

00802b3f <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802b3f:	55                   	push   %ebp
  802b40:	89 e5                	mov    %esp,%ebp
  802b42:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  802b45:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  802b4c:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  802b53:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802b5a:	a1 38 51 80 00       	mov    0x805138,%eax
  802b5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b62:	e9 cf 00 00 00       	jmp    802c36 <alloc_block_BF+0xf7>
		{
			c++;
  802b67:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  802b6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6d:	8b 40 0c             	mov    0xc(%eax),%eax
  802b70:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b73:	0f 85 8a 00 00 00    	jne    802c03 <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  802b79:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b7d:	75 17                	jne    802b96 <alloc_block_BF+0x57>
  802b7f:	83 ec 04             	sub    $0x4,%esp
  802b82:	68 2f 42 80 00       	push   $0x80422f
  802b87:	68 a8 00 00 00       	push   $0xa8
  802b8c:	68 f3 41 80 00       	push   $0x8041f3
  802b91:	e8 5d dd ff ff       	call   8008f3 <_panic>
  802b96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b99:	8b 00                	mov    (%eax),%eax
  802b9b:	85 c0                	test   %eax,%eax
  802b9d:	74 10                	je     802baf <alloc_block_BF+0x70>
  802b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba2:	8b 00                	mov    (%eax),%eax
  802ba4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ba7:	8b 52 04             	mov    0x4(%edx),%edx
  802baa:	89 50 04             	mov    %edx,0x4(%eax)
  802bad:	eb 0b                	jmp    802bba <alloc_block_BF+0x7b>
  802baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb2:	8b 40 04             	mov    0x4(%eax),%eax
  802bb5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802bba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbd:	8b 40 04             	mov    0x4(%eax),%eax
  802bc0:	85 c0                	test   %eax,%eax
  802bc2:	74 0f                	je     802bd3 <alloc_block_BF+0x94>
  802bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc7:	8b 40 04             	mov    0x4(%eax),%eax
  802bca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bcd:	8b 12                	mov    (%edx),%edx
  802bcf:	89 10                	mov    %edx,(%eax)
  802bd1:	eb 0a                	jmp    802bdd <alloc_block_BF+0x9e>
  802bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd6:	8b 00                	mov    (%eax),%eax
  802bd8:	a3 38 51 80 00       	mov    %eax,0x805138
  802bdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bf0:	a1 44 51 80 00       	mov    0x805144,%eax
  802bf5:	48                   	dec    %eax
  802bf6:	a3 44 51 80 00       	mov    %eax,0x805144
				return block;
  802bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfe:	e9 85 01 00 00       	jmp    802d88 <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  802c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c06:	8b 40 0c             	mov    0xc(%eax),%eax
  802c09:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c0c:	76 20                	jbe    802c2e <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  802c0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c11:	8b 40 0c             	mov    0xc(%eax),%eax
  802c14:	2b 45 08             	sub    0x8(%ebp),%eax
  802c17:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  802c1a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c1d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802c20:	73 0c                	jae    802c2e <alloc_block_BF+0xef>
				{
					ma=tempi;
  802c22:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802c25:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  802c28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c2b:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802c2e:	a1 40 51 80 00       	mov    0x805140,%eax
  802c33:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c36:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c3a:	74 07                	je     802c43 <alloc_block_BF+0x104>
  802c3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3f:	8b 00                	mov    (%eax),%eax
  802c41:	eb 05                	jmp    802c48 <alloc_block_BF+0x109>
  802c43:	b8 00 00 00 00       	mov    $0x0,%eax
  802c48:	a3 40 51 80 00       	mov    %eax,0x805140
  802c4d:	a1 40 51 80 00       	mov    0x805140,%eax
  802c52:	85 c0                	test   %eax,%eax
  802c54:	0f 85 0d ff ff ff    	jne    802b67 <alloc_block_BF+0x28>
  802c5a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c5e:	0f 85 03 ff ff ff    	jne    802b67 <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  802c64:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802c6b:	a1 38 51 80 00       	mov    0x805138,%eax
  802c70:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c73:	e9 dd 00 00 00       	jmp    802d55 <alloc_block_BF+0x216>
		{
			if(x==sol)
  802c78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c7b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802c7e:	0f 85 c6 00 00 00    	jne    802d4a <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802c84:	a1 48 51 80 00       	mov    0x805148,%eax
  802c89:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802c8c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802c90:	75 17                	jne    802ca9 <alloc_block_BF+0x16a>
  802c92:	83 ec 04             	sub    $0x4,%esp
  802c95:	68 2f 42 80 00       	push   $0x80422f
  802c9a:	68 bb 00 00 00       	push   $0xbb
  802c9f:	68 f3 41 80 00       	push   $0x8041f3
  802ca4:	e8 4a dc ff ff       	call   8008f3 <_panic>
  802ca9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cac:	8b 00                	mov    (%eax),%eax
  802cae:	85 c0                	test   %eax,%eax
  802cb0:	74 10                	je     802cc2 <alloc_block_BF+0x183>
  802cb2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cb5:	8b 00                	mov    (%eax),%eax
  802cb7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802cba:	8b 52 04             	mov    0x4(%edx),%edx
  802cbd:	89 50 04             	mov    %edx,0x4(%eax)
  802cc0:	eb 0b                	jmp    802ccd <alloc_block_BF+0x18e>
  802cc2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cc5:	8b 40 04             	mov    0x4(%eax),%eax
  802cc8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ccd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cd0:	8b 40 04             	mov    0x4(%eax),%eax
  802cd3:	85 c0                	test   %eax,%eax
  802cd5:	74 0f                	je     802ce6 <alloc_block_BF+0x1a7>
  802cd7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cda:	8b 40 04             	mov    0x4(%eax),%eax
  802cdd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ce0:	8b 12                	mov    (%edx),%edx
  802ce2:	89 10                	mov    %edx,(%eax)
  802ce4:	eb 0a                	jmp    802cf0 <alloc_block_BF+0x1b1>
  802ce6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ce9:	8b 00                	mov    (%eax),%eax
  802ceb:	a3 48 51 80 00       	mov    %eax,0x805148
  802cf0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cf3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cf9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cfc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d03:	a1 54 51 80 00       	mov    0x805154,%eax
  802d08:	48                   	dec    %eax
  802d09:	a3 54 51 80 00       	mov    %eax,0x805154
						 element1->size =size;
  802d0e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d11:	8b 55 08             	mov    0x8(%ebp),%edx
  802d14:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  802d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1a:	8b 50 08             	mov    0x8(%eax),%edx
  802d1d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d20:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  802d23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d26:	8b 50 08             	mov    0x8(%eax),%edx
  802d29:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2c:	01 c2                	add    %eax,%edx
  802d2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d31:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  802d34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d37:	8b 40 0c             	mov    0xc(%eax),%eax
  802d3a:	2b 45 08             	sub    0x8(%ebp),%eax
  802d3d:	89 c2                	mov    %eax,%edx
  802d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d42:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  802d45:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d48:	eb 3e                	jmp    802d88 <alloc_block_BF+0x249>
						 break;
			}
			x++;
  802d4a:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802d4d:	a1 40 51 80 00       	mov    0x805140,%eax
  802d52:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d55:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d59:	74 07                	je     802d62 <alloc_block_BF+0x223>
  802d5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5e:	8b 00                	mov    (%eax),%eax
  802d60:	eb 05                	jmp    802d67 <alloc_block_BF+0x228>
  802d62:	b8 00 00 00 00       	mov    $0x0,%eax
  802d67:	a3 40 51 80 00       	mov    %eax,0x805140
  802d6c:	a1 40 51 80 00       	mov    0x805140,%eax
  802d71:	85 c0                	test   %eax,%eax
  802d73:	0f 85 ff fe ff ff    	jne    802c78 <alloc_block_BF+0x139>
  802d79:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d7d:	0f 85 f5 fe ff ff    	jne    802c78 <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  802d83:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d88:	c9                   	leave  
  802d89:	c3                   	ret    

00802d8a <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802d8a:	55                   	push   %ebp
  802d8b:	89 e5                	mov    %esp,%ebp
  802d8d:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  802d90:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802d95:	85 c0                	test   %eax,%eax
  802d97:	75 14                	jne    802dad <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  802d99:	a1 38 51 80 00       	mov    0x805138,%eax
  802d9e:	a3 60 51 80 00       	mov    %eax,0x805160
		hh=1;
  802da3:	c7 05 2c 50 80 00 01 	movl   $0x1,0x80502c
  802daa:	00 00 00 
	}
	uint32 c=1;
  802dad:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  802db4:	a1 60 51 80 00       	mov    0x805160,%eax
  802db9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802dbc:	e9 b3 01 00 00       	jmp    802f74 <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  802dc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc4:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc7:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dca:	0f 85 a9 00 00 00    	jne    802e79 <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  802dd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd3:	8b 00                	mov    (%eax),%eax
  802dd5:	85 c0                	test   %eax,%eax
  802dd7:	75 0c                	jne    802de5 <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  802dd9:	a1 38 51 80 00       	mov    0x805138,%eax
  802dde:	a3 60 51 80 00       	mov    %eax,0x805160
  802de3:	eb 0a                	jmp    802def <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  802de5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de8:	8b 00                	mov    (%eax),%eax
  802dea:	a3 60 51 80 00       	mov    %eax,0x805160
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  802def:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802df3:	75 17                	jne    802e0c <alloc_block_NF+0x82>
  802df5:	83 ec 04             	sub    $0x4,%esp
  802df8:	68 2f 42 80 00       	push   $0x80422f
  802dfd:	68 e3 00 00 00       	push   $0xe3
  802e02:	68 f3 41 80 00       	push   $0x8041f3
  802e07:	e8 e7 da ff ff       	call   8008f3 <_panic>
  802e0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0f:	8b 00                	mov    (%eax),%eax
  802e11:	85 c0                	test   %eax,%eax
  802e13:	74 10                	je     802e25 <alloc_block_NF+0x9b>
  802e15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e18:	8b 00                	mov    (%eax),%eax
  802e1a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e1d:	8b 52 04             	mov    0x4(%edx),%edx
  802e20:	89 50 04             	mov    %edx,0x4(%eax)
  802e23:	eb 0b                	jmp    802e30 <alloc_block_NF+0xa6>
  802e25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e28:	8b 40 04             	mov    0x4(%eax),%eax
  802e2b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e30:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e33:	8b 40 04             	mov    0x4(%eax),%eax
  802e36:	85 c0                	test   %eax,%eax
  802e38:	74 0f                	je     802e49 <alloc_block_NF+0xbf>
  802e3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e3d:	8b 40 04             	mov    0x4(%eax),%eax
  802e40:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e43:	8b 12                	mov    (%edx),%edx
  802e45:	89 10                	mov    %edx,(%eax)
  802e47:	eb 0a                	jmp    802e53 <alloc_block_NF+0xc9>
  802e49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e4c:	8b 00                	mov    (%eax),%eax
  802e4e:	a3 38 51 80 00       	mov    %eax,0x805138
  802e53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e56:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e5f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e66:	a1 44 51 80 00       	mov    0x805144,%eax
  802e6b:	48                   	dec    %eax
  802e6c:	a3 44 51 80 00       	mov    %eax,0x805144
				return element;
  802e71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e74:	e9 0e 01 00 00       	jmp    802f87 <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  802e79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e7c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e7f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e82:	0f 86 ce 00 00 00    	jbe    802f56 <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802e88:	a1 48 51 80 00       	mov    0x805148,%eax
  802e8d:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802e90:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e94:	75 17                	jne    802ead <alloc_block_NF+0x123>
  802e96:	83 ec 04             	sub    $0x4,%esp
  802e99:	68 2f 42 80 00       	push   $0x80422f
  802e9e:	68 e9 00 00 00       	push   $0xe9
  802ea3:	68 f3 41 80 00       	push   $0x8041f3
  802ea8:	e8 46 da ff ff       	call   8008f3 <_panic>
  802ead:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eb0:	8b 00                	mov    (%eax),%eax
  802eb2:	85 c0                	test   %eax,%eax
  802eb4:	74 10                	je     802ec6 <alloc_block_NF+0x13c>
  802eb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eb9:	8b 00                	mov    (%eax),%eax
  802ebb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ebe:	8b 52 04             	mov    0x4(%edx),%edx
  802ec1:	89 50 04             	mov    %edx,0x4(%eax)
  802ec4:	eb 0b                	jmp    802ed1 <alloc_block_NF+0x147>
  802ec6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ec9:	8b 40 04             	mov    0x4(%eax),%eax
  802ecc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ed1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ed4:	8b 40 04             	mov    0x4(%eax),%eax
  802ed7:	85 c0                	test   %eax,%eax
  802ed9:	74 0f                	je     802eea <alloc_block_NF+0x160>
  802edb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ede:	8b 40 04             	mov    0x4(%eax),%eax
  802ee1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ee4:	8b 12                	mov    (%edx),%edx
  802ee6:	89 10                	mov    %edx,(%eax)
  802ee8:	eb 0a                	jmp    802ef4 <alloc_block_NF+0x16a>
  802eea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eed:	8b 00                	mov    (%eax),%eax
  802eef:	a3 48 51 80 00       	mov    %eax,0x805148
  802ef4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ef7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802efd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f00:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f07:	a1 54 51 80 00       	mov    0x805154,%eax
  802f0c:	48                   	dec    %eax
  802f0d:	a3 54 51 80 00       	mov    %eax,0x805154
				 element1->size =size;
  802f12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f15:	8b 55 08             	mov    0x8(%ebp),%edx
  802f18:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  802f1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f1e:	8b 50 08             	mov    0x8(%eax),%edx
  802f21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f24:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  802f27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f2a:	8b 50 08             	mov    0x8(%eax),%edx
  802f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f30:	01 c2                	add    %eax,%edx
  802f32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f35:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  802f38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f3b:	8b 40 0c             	mov    0xc(%eax),%eax
  802f3e:	2b 45 08             	sub    0x8(%ebp),%eax
  802f41:	89 c2                	mov    %eax,%edx
  802f43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f46:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  802f49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f4c:	a3 60 51 80 00       	mov    %eax,0x805160
				 return element1;
  802f51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f54:	eb 31                	jmp    802f87 <alloc_block_NF+0x1fd>
			 }
		 c++;
  802f56:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  802f59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f5c:	8b 00                	mov    (%eax),%eax
  802f5e:	85 c0                	test   %eax,%eax
  802f60:	75 0a                	jne    802f6c <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  802f62:	a1 38 51 80 00       	mov    0x805138,%eax
  802f67:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802f6a:	eb 08                	jmp    802f74 <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  802f6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f6f:	8b 00                	mov    (%eax),%eax
  802f71:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802f74:	a1 44 51 80 00       	mov    0x805144,%eax
  802f79:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802f7c:	0f 85 3f fe ff ff    	jne    802dc1 <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  802f82:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f87:	c9                   	leave  
  802f88:	c3                   	ret    

00802f89 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802f89:	55                   	push   %ebp
  802f8a:	89 e5                	mov    %esp,%ebp
  802f8c:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  802f8f:	a1 44 51 80 00       	mov    0x805144,%eax
  802f94:	85 c0                	test   %eax,%eax
  802f96:	75 68                	jne    803000 <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802f98:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f9c:	75 17                	jne    802fb5 <insert_sorted_with_merge_freeList+0x2c>
  802f9e:	83 ec 04             	sub    $0x4,%esp
  802fa1:	68 d0 41 80 00       	push   $0x8041d0
  802fa6:	68 0e 01 00 00       	push   $0x10e
  802fab:	68 f3 41 80 00       	push   $0x8041f3
  802fb0:	e8 3e d9 ff ff       	call   8008f3 <_panic>
  802fb5:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbe:	89 10                	mov    %edx,(%eax)
  802fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc3:	8b 00                	mov    (%eax),%eax
  802fc5:	85 c0                	test   %eax,%eax
  802fc7:	74 0d                	je     802fd6 <insert_sorted_with_merge_freeList+0x4d>
  802fc9:	a1 38 51 80 00       	mov    0x805138,%eax
  802fce:	8b 55 08             	mov    0x8(%ebp),%edx
  802fd1:	89 50 04             	mov    %edx,0x4(%eax)
  802fd4:	eb 08                	jmp    802fde <insert_sorted_with_merge_freeList+0x55>
  802fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fde:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe1:	a3 38 51 80 00       	mov    %eax,0x805138
  802fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ff0:	a1 44 51 80 00       	mov    0x805144,%eax
  802ff5:	40                   	inc    %eax
  802ff6:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  802ffb:	e9 8c 06 00 00       	jmp    80368c <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  803000:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803005:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  803008:	a1 38 51 80 00       	mov    0x805138,%eax
  80300d:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  803010:	8b 45 08             	mov    0x8(%ebp),%eax
  803013:	8b 50 08             	mov    0x8(%eax),%edx
  803016:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803019:	8b 40 08             	mov    0x8(%eax),%eax
  80301c:	39 c2                	cmp    %eax,%edx
  80301e:	0f 86 14 01 00 00    	jbe    803138 <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  803024:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803027:	8b 50 0c             	mov    0xc(%eax),%edx
  80302a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80302d:	8b 40 08             	mov    0x8(%eax),%eax
  803030:	01 c2                	add    %eax,%edx
  803032:	8b 45 08             	mov    0x8(%ebp),%eax
  803035:	8b 40 08             	mov    0x8(%eax),%eax
  803038:	39 c2                	cmp    %eax,%edx
  80303a:	0f 85 90 00 00 00    	jne    8030d0 <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  803040:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803043:	8b 50 0c             	mov    0xc(%eax),%edx
  803046:	8b 45 08             	mov    0x8(%ebp),%eax
  803049:	8b 40 0c             	mov    0xc(%eax),%eax
  80304c:	01 c2                	add    %eax,%edx
  80304e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803051:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  803054:	8b 45 08             	mov    0x8(%ebp),%eax
  803057:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  80305e:	8b 45 08             	mov    0x8(%ebp),%eax
  803061:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803068:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80306c:	75 17                	jne    803085 <insert_sorted_with_merge_freeList+0xfc>
  80306e:	83 ec 04             	sub    $0x4,%esp
  803071:	68 d0 41 80 00       	push   $0x8041d0
  803076:	68 1b 01 00 00       	push   $0x11b
  80307b:	68 f3 41 80 00       	push   $0x8041f3
  803080:	e8 6e d8 ff ff       	call   8008f3 <_panic>
  803085:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80308b:	8b 45 08             	mov    0x8(%ebp),%eax
  80308e:	89 10                	mov    %edx,(%eax)
  803090:	8b 45 08             	mov    0x8(%ebp),%eax
  803093:	8b 00                	mov    (%eax),%eax
  803095:	85 c0                	test   %eax,%eax
  803097:	74 0d                	je     8030a6 <insert_sorted_with_merge_freeList+0x11d>
  803099:	a1 48 51 80 00       	mov    0x805148,%eax
  80309e:	8b 55 08             	mov    0x8(%ebp),%edx
  8030a1:	89 50 04             	mov    %edx,0x4(%eax)
  8030a4:	eb 08                	jmp    8030ae <insert_sorted_with_merge_freeList+0x125>
  8030a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b1:	a3 48 51 80 00       	mov    %eax,0x805148
  8030b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030c0:	a1 54 51 80 00       	mov    0x805154,%eax
  8030c5:	40                   	inc    %eax
  8030c6:	a3 54 51 80 00       	mov    %eax,0x805154
							}

						}
		          }
		}
}
  8030cb:	e9 bc 05 00 00       	jmp    80368c <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8030d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030d4:	75 17                	jne    8030ed <insert_sorted_with_merge_freeList+0x164>
  8030d6:	83 ec 04             	sub    $0x4,%esp
  8030d9:	68 0c 42 80 00       	push   $0x80420c
  8030de:	68 1f 01 00 00       	push   $0x11f
  8030e3:	68 f3 41 80 00       	push   $0x8041f3
  8030e8:	e8 06 d8 ff ff       	call   8008f3 <_panic>
  8030ed:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8030f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f6:	89 50 04             	mov    %edx,0x4(%eax)
  8030f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fc:	8b 40 04             	mov    0x4(%eax),%eax
  8030ff:	85 c0                	test   %eax,%eax
  803101:	74 0c                	je     80310f <insert_sorted_with_merge_freeList+0x186>
  803103:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803108:	8b 55 08             	mov    0x8(%ebp),%edx
  80310b:	89 10                	mov    %edx,(%eax)
  80310d:	eb 08                	jmp    803117 <insert_sorted_with_merge_freeList+0x18e>
  80310f:	8b 45 08             	mov    0x8(%ebp),%eax
  803112:	a3 38 51 80 00       	mov    %eax,0x805138
  803117:	8b 45 08             	mov    0x8(%ebp),%eax
  80311a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80311f:	8b 45 08             	mov    0x8(%ebp),%eax
  803122:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803128:	a1 44 51 80 00       	mov    0x805144,%eax
  80312d:	40                   	inc    %eax
  80312e:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  803133:	e9 54 05 00 00       	jmp    80368c <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  803138:	8b 45 08             	mov    0x8(%ebp),%eax
  80313b:	8b 50 08             	mov    0x8(%eax),%edx
  80313e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803141:	8b 40 08             	mov    0x8(%eax),%eax
  803144:	39 c2                	cmp    %eax,%edx
  803146:	0f 83 20 01 00 00    	jae    80326c <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  80314c:	8b 45 08             	mov    0x8(%ebp),%eax
  80314f:	8b 50 0c             	mov    0xc(%eax),%edx
  803152:	8b 45 08             	mov    0x8(%ebp),%eax
  803155:	8b 40 08             	mov    0x8(%eax),%eax
  803158:	01 c2                	add    %eax,%edx
  80315a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80315d:	8b 40 08             	mov    0x8(%eax),%eax
  803160:	39 c2                	cmp    %eax,%edx
  803162:	0f 85 9c 00 00 00    	jne    803204 <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  803168:	8b 45 08             	mov    0x8(%ebp),%eax
  80316b:	8b 50 08             	mov    0x8(%eax),%edx
  80316e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803171:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  803174:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803177:	8b 50 0c             	mov    0xc(%eax),%edx
  80317a:	8b 45 08             	mov    0x8(%ebp),%eax
  80317d:	8b 40 0c             	mov    0xc(%eax),%eax
  803180:	01 c2                	add    %eax,%edx
  803182:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803185:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  803188:	8b 45 08             	mov    0x8(%ebp),%eax
  80318b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  803192:	8b 45 08             	mov    0x8(%ebp),%eax
  803195:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80319c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031a0:	75 17                	jne    8031b9 <insert_sorted_with_merge_freeList+0x230>
  8031a2:	83 ec 04             	sub    $0x4,%esp
  8031a5:	68 d0 41 80 00       	push   $0x8041d0
  8031aa:	68 2a 01 00 00       	push   $0x12a
  8031af:	68 f3 41 80 00       	push   $0x8041f3
  8031b4:	e8 3a d7 ff ff       	call   8008f3 <_panic>
  8031b9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c2:	89 10                	mov    %edx,(%eax)
  8031c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c7:	8b 00                	mov    (%eax),%eax
  8031c9:	85 c0                	test   %eax,%eax
  8031cb:	74 0d                	je     8031da <insert_sorted_with_merge_freeList+0x251>
  8031cd:	a1 48 51 80 00       	mov    0x805148,%eax
  8031d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8031d5:	89 50 04             	mov    %edx,0x4(%eax)
  8031d8:	eb 08                	jmp    8031e2 <insert_sorted_with_merge_freeList+0x259>
  8031da:	8b 45 08             	mov    0x8(%ebp),%eax
  8031dd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e5:	a3 48 51 80 00       	mov    %eax,0x805148
  8031ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031f4:	a1 54 51 80 00       	mov    0x805154,%eax
  8031f9:	40                   	inc    %eax
  8031fa:	a3 54 51 80 00       	mov    %eax,0x805154
							}

						}
		          }
		}
}
  8031ff:	e9 88 04 00 00       	jmp    80368c <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  803204:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803208:	75 17                	jne    803221 <insert_sorted_with_merge_freeList+0x298>
  80320a:	83 ec 04             	sub    $0x4,%esp
  80320d:	68 d0 41 80 00       	push   $0x8041d0
  803212:	68 2e 01 00 00       	push   $0x12e
  803217:	68 f3 41 80 00       	push   $0x8041f3
  80321c:	e8 d2 d6 ff ff       	call   8008f3 <_panic>
  803221:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803227:	8b 45 08             	mov    0x8(%ebp),%eax
  80322a:	89 10                	mov    %edx,(%eax)
  80322c:	8b 45 08             	mov    0x8(%ebp),%eax
  80322f:	8b 00                	mov    (%eax),%eax
  803231:	85 c0                	test   %eax,%eax
  803233:	74 0d                	je     803242 <insert_sorted_with_merge_freeList+0x2b9>
  803235:	a1 38 51 80 00       	mov    0x805138,%eax
  80323a:	8b 55 08             	mov    0x8(%ebp),%edx
  80323d:	89 50 04             	mov    %edx,0x4(%eax)
  803240:	eb 08                	jmp    80324a <insert_sorted_with_merge_freeList+0x2c1>
  803242:	8b 45 08             	mov    0x8(%ebp),%eax
  803245:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80324a:	8b 45 08             	mov    0x8(%ebp),%eax
  80324d:	a3 38 51 80 00       	mov    %eax,0x805138
  803252:	8b 45 08             	mov    0x8(%ebp),%eax
  803255:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80325c:	a1 44 51 80 00       	mov    0x805144,%eax
  803261:	40                   	inc    %eax
  803262:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  803267:	e9 20 04 00 00       	jmp    80368c <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  80326c:	a1 38 51 80 00       	mov    0x805138,%eax
  803271:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803274:	e9 e2 03 00 00       	jmp    80365b <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  803279:	8b 45 08             	mov    0x8(%ebp),%eax
  80327c:	8b 50 08             	mov    0x8(%eax),%edx
  80327f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803282:	8b 40 08             	mov    0x8(%eax),%eax
  803285:	39 c2                	cmp    %eax,%edx
  803287:	0f 83 c6 03 00 00    	jae    803653 <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  80328d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803290:	8b 40 04             	mov    0x4(%eax),%eax
  803293:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  803296:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803299:	8b 50 08             	mov    0x8(%eax),%edx
  80329c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80329f:	8b 40 0c             	mov    0xc(%eax),%eax
  8032a2:	01 d0                	add    %edx,%eax
  8032a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  8032a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032aa:	8b 50 0c             	mov    0xc(%eax),%edx
  8032ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b0:	8b 40 08             	mov    0x8(%eax),%eax
  8032b3:	01 d0                	add    %edx,%eax
  8032b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  8032b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bb:	8b 40 08             	mov    0x8(%eax),%eax
  8032be:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8032c1:	74 7a                	je     80333d <insert_sorted_with_merge_freeList+0x3b4>
  8032c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c6:	8b 40 08             	mov    0x8(%eax),%eax
  8032c9:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8032cc:	74 6f                	je     80333d <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  8032ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032d2:	74 06                	je     8032da <insert_sorted_with_merge_freeList+0x351>
  8032d4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032d8:	75 17                	jne    8032f1 <insert_sorted_with_merge_freeList+0x368>
  8032da:	83 ec 04             	sub    $0x4,%esp
  8032dd:	68 50 42 80 00       	push   $0x804250
  8032e2:	68 43 01 00 00       	push   $0x143
  8032e7:	68 f3 41 80 00       	push   $0x8041f3
  8032ec:	e8 02 d6 ff ff       	call   8008f3 <_panic>
  8032f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f4:	8b 50 04             	mov    0x4(%eax),%edx
  8032f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fa:	89 50 04             	mov    %edx,0x4(%eax)
  8032fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803300:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803303:	89 10                	mov    %edx,(%eax)
  803305:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803308:	8b 40 04             	mov    0x4(%eax),%eax
  80330b:	85 c0                	test   %eax,%eax
  80330d:	74 0d                	je     80331c <insert_sorted_with_merge_freeList+0x393>
  80330f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803312:	8b 40 04             	mov    0x4(%eax),%eax
  803315:	8b 55 08             	mov    0x8(%ebp),%edx
  803318:	89 10                	mov    %edx,(%eax)
  80331a:	eb 08                	jmp    803324 <insert_sorted_with_merge_freeList+0x39b>
  80331c:	8b 45 08             	mov    0x8(%ebp),%eax
  80331f:	a3 38 51 80 00       	mov    %eax,0x805138
  803324:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803327:	8b 55 08             	mov    0x8(%ebp),%edx
  80332a:	89 50 04             	mov    %edx,0x4(%eax)
  80332d:	a1 44 51 80 00       	mov    0x805144,%eax
  803332:	40                   	inc    %eax
  803333:	a3 44 51 80 00       	mov    %eax,0x805144
  803338:	e9 14 03 00 00       	jmp    803651 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  80333d:	8b 45 08             	mov    0x8(%ebp),%eax
  803340:	8b 40 08             	mov    0x8(%eax),%eax
  803343:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803346:	0f 85 a0 01 00 00    	jne    8034ec <insert_sorted_with_merge_freeList+0x563>
  80334c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334f:	8b 40 08             	mov    0x8(%eax),%eax
  803352:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803355:	0f 85 91 01 00 00    	jne    8034ec <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  80335b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80335e:	8b 50 0c             	mov    0xc(%eax),%edx
  803361:	8b 45 08             	mov    0x8(%ebp),%eax
  803364:	8b 48 0c             	mov    0xc(%eax),%ecx
  803367:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80336a:	8b 40 0c             	mov    0xc(%eax),%eax
  80336d:	01 c8                	add    %ecx,%eax
  80336f:	01 c2                	add    %eax,%edx
  803371:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803374:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  803377:	8b 45 08             	mov    0x8(%ebp),%eax
  80337a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  803381:	8b 45 08             	mov    0x8(%ebp),%eax
  803384:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  80338b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80338e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  803395:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803398:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80339f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033a3:	75 17                	jne    8033bc <insert_sorted_with_merge_freeList+0x433>
  8033a5:	83 ec 04             	sub    $0x4,%esp
  8033a8:	68 d0 41 80 00       	push   $0x8041d0
  8033ad:	68 4d 01 00 00       	push   $0x14d
  8033b2:	68 f3 41 80 00       	push   $0x8041f3
  8033b7:	e8 37 d5 ff ff       	call   8008f3 <_panic>
  8033bc:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c5:	89 10                	mov    %edx,(%eax)
  8033c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ca:	8b 00                	mov    (%eax),%eax
  8033cc:	85 c0                	test   %eax,%eax
  8033ce:	74 0d                	je     8033dd <insert_sorted_with_merge_freeList+0x454>
  8033d0:	a1 48 51 80 00       	mov    0x805148,%eax
  8033d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8033d8:	89 50 04             	mov    %edx,0x4(%eax)
  8033db:	eb 08                	jmp    8033e5 <insert_sorted_with_merge_freeList+0x45c>
  8033dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e8:	a3 48 51 80 00       	mov    %eax,0x805148
  8033ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033f7:	a1 54 51 80 00       	mov    0x805154,%eax
  8033fc:	40                   	inc    %eax
  8033fd:	a3 54 51 80 00       	mov    %eax,0x805154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  803402:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803406:	75 17                	jne    80341f <insert_sorted_with_merge_freeList+0x496>
  803408:	83 ec 04             	sub    $0x4,%esp
  80340b:	68 2f 42 80 00       	push   $0x80422f
  803410:	68 4e 01 00 00       	push   $0x14e
  803415:	68 f3 41 80 00       	push   $0x8041f3
  80341a:	e8 d4 d4 ff ff       	call   8008f3 <_panic>
  80341f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803422:	8b 00                	mov    (%eax),%eax
  803424:	85 c0                	test   %eax,%eax
  803426:	74 10                	je     803438 <insert_sorted_with_merge_freeList+0x4af>
  803428:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80342b:	8b 00                	mov    (%eax),%eax
  80342d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803430:	8b 52 04             	mov    0x4(%edx),%edx
  803433:	89 50 04             	mov    %edx,0x4(%eax)
  803436:	eb 0b                	jmp    803443 <insert_sorted_with_merge_freeList+0x4ba>
  803438:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343b:	8b 40 04             	mov    0x4(%eax),%eax
  80343e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803446:	8b 40 04             	mov    0x4(%eax),%eax
  803449:	85 c0                	test   %eax,%eax
  80344b:	74 0f                	je     80345c <insert_sorted_with_merge_freeList+0x4d3>
  80344d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803450:	8b 40 04             	mov    0x4(%eax),%eax
  803453:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803456:	8b 12                	mov    (%edx),%edx
  803458:	89 10                	mov    %edx,(%eax)
  80345a:	eb 0a                	jmp    803466 <insert_sorted_with_merge_freeList+0x4dd>
  80345c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345f:	8b 00                	mov    (%eax),%eax
  803461:	a3 38 51 80 00       	mov    %eax,0x805138
  803466:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803469:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80346f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803472:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803479:	a1 44 51 80 00       	mov    0x805144,%eax
  80347e:	48                   	dec    %eax
  80347f:	a3 44 51 80 00       	mov    %eax,0x805144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  803484:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803488:	75 17                	jne    8034a1 <insert_sorted_with_merge_freeList+0x518>
  80348a:	83 ec 04             	sub    $0x4,%esp
  80348d:	68 d0 41 80 00       	push   $0x8041d0
  803492:	68 4f 01 00 00       	push   $0x14f
  803497:	68 f3 41 80 00       	push   $0x8041f3
  80349c:	e8 52 d4 ff ff       	call   8008f3 <_panic>
  8034a1:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034aa:	89 10                	mov    %edx,(%eax)
  8034ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034af:	8b 00                	mov    (%eax),%eax
  8034b1:	85 c0                	test   %eax,%eax
  8034b3:	74 0d                	je     8034c2 <insert_sorted_with_merge_freeList+0x539>
  8034b5:	a1 48 51 80 00       	mov    0x805148,%eax
  8034ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034bd:	89 50 04             	mov    %edx,0x4(%eax)
  8034c0:	eb 08                	jmp    8034ca <insert_sorted_with_merge_freeList+0x541>
  8034c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034cd:	a3 48 51 80 00       	mov    %eax,0x805148
  8034d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034dc:	a1 54 51 80 00       	mov    0x805154,%eax
  8034e1:	40                   	inc    %eax
  8034e2:	a3 54 51 80 00       	mov    %eax,0x805154
  8034e7:	e9 65 01 00 00       	jmp    803651 <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  8034ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ef:	8b 40 08             	mov    0x8(%eax),%eax
  8034f2:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8034f5:	0f 85 9f 00 00 00    	jne    80359a <insert_sorted_with_merge_freeList+0x611>
  8034fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034fe:	8b 40 08             	mov    0x8(%eax),%eax
  803501:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803504:	0f 84 90 00 00 00    	je     80359a <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  80350a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80350d:	8b 50 0c             	mov    0xc(%eax),%edx
  803510:	8b 45 08             	mov    0x8(%ebp),%eax
  803513:	8b 40 0c             	mov    0xc(%eax),%eax
  803516:	01 c2                	add    %eax,%edx
  803518:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80351b:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  80351e:	8b 45 08             	mov    0x8(%ebp),%eax
  803521:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  803528:	8b 45 08             	mov    0x8(%ebp),%eax
  80352b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803532:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803536:	75 17                	jne    80354f <insert_sorted_with_merge_freeList+0x5c6>
  803538:	83 ec 04             	sub    $0x4,%esp
  80353b:	68 d0 41 80 00       	push   $0x8041d0
  803540:	68 58 01 00 00       	push   $0x158
  803545:	68 f3 41 80 00       	push   $0x8041f3
  80354a:	e8 a4 d3 ff ff       	call   8008f3 <_panic>
  80354f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803555:	8b 45 08             	mov    0x8(%ebp),%eax
  803558:	89 10                	mov    %edx,(%eax)
  80355a:	8b 45 08             	mov    0x8(%ebp),%eax
  80355d:	8b 00                	mov    (%eax),%eax
  80355f:	85 c0                	test   %eax,%eax
  803561:	74 0d                	je     803570 <insert_sorted_with_merge_freeList+0x5e7>
  803563:	a1 48 51 80 00       	mov    0x805148,%eax
  803568:	8b 55 08             	mov    0x8(%ebp),%edx
  80356b:	89 50 04             	mov    %edx,0x4(%eax)
  80356e:	eb 08                	jmp    803578 <insert_sorted_with_merge_freeList+0x5ef>
  803570:	8b 45 08             	mov    0x8(%ebp),%eax
  803573:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803578:	8b 45 08             	mov    0x8(%ebp),%eax
  80357b:	a3 48 51 80 00       	mov    %eax,0x805148
  803580:	8b 45 08             	mov    0x8(%ebp),%eax
  803583:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80358a:	a1 54 51 80 00       	mov    0x805154,%eax
  80358f:	40                   	inc    %eax
  803590:	a3 54 51 80 00       	mov    %eax,0x805154
  803595:	e9 b7 00 00 00       	jmp    803651 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  80359a:	8b 45 08             	mov    0x8(%ebp),%eax
  80359d:	8b 40 08             	mov    0x8(%eax),%eax
  8035a0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8035a3:	0f 84 e2 00 00 00    	je     80368b <insert_sorted_with_merge_freeList+0x702>
  8035a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ac:	8b 40 08             	mov    0x8(%eax),%eax
  8035af:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8035b2:	0f 85 d3 00 00 00    	jne    80368b <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  8035b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035bb:	8b 50 08             	mov    0x8(%eax),%edx
  8035be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c1:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  8035c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c7:	8b 50 0c             	mov    0xc(%eax),%edx
  8035ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8035cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8035d0:	01 c2                	add    %eax,%edx
  8035d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d5:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  8035d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035db:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  8035e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8035ec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035f0:	75 17                	jne    803609 <insert_sorted_with_merge_freeList+0x680>
  8035f2:	83 ec 04             	sub    $0x4,%esp
  8035f5:	68 d0 41 80 00       	push   $0x8041d0
  8035fa:	68 61 01 00 00       	push   $0x161
  8035ff:	68 f3 41 80 00       	push   $0x8041f3
  803604:	e8 ea d2 ff ff       	call   8008f3 <_panic>
  803609:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80360f:	8b 45 08             	mov    0x8(%ebp),%eax
  803612:	89 10                	mov    %edx,(%eax)
  803614:	8b 45 08             	mov    0x8(%ebp),%eax
  803617:	8b 00                	mov    (%eax),%eax
  803619:	85 c0                	test   %eax,%eax
  80361b:	74 0d                	je     80362a <insert_sorted_with_merge_freeList+0x6a1>
  80361d:	a1 48 51 80 00       	mov    0x805148,%eax
  803622:	8b 55 08             	mov    0x8(%ebp),%edx
  803625:	89 50 04             	mov    %edx,0x4(%eax)
  803628:	eb 08                	jmp    803632 <insert_sorted_with_merge_freeList+0x6a9>
  80362a:	8b 45 08             	mov    0x8(%ebp),%eax
  80362d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803632:	8b 45 08             	mov    0x8(%ebp),%eax
  803635:	a3 48 51 80 00       	mov    %eax,0x805148
  80363a:	8b 45 08             	mov    0x8(%ebp),%eax
  80363d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803644:	a1 54 51 80 00       	mov    0x805154,%eax
  803649:	40                   	inc    %eax
  80364a:	a3 54 51 80 00       	mov    %eax,0x805154
								}
								break;
  80364f:	eb 3a                	jmp    80368b <insert_sorted_with_merge_freeList+0x702>
  803651:	eb 38                	jmp    80368b <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  803653:	a1 40 51 80 00       	mov    0x805140,%eax
  803658:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80365b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80365f:	74 07                	je     803668 <insert_sorted_with_merge_freeList+0x6df>
  803661:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803664:	8b 00                	mov    (%eax),%eax
  803666:	eb 05                	jmp    80366d <insert_sorted_with_merge_freeList+0x6e4>
  803668:	b8 00 00 00 00       	mov    $0x0,%eax
  80366d:	a3 40 51 80 00       	mov    %eax,0x805140
  803672:	a1 40 51 80 00       	mov    0x805140,%eax
  803677:	85 c0                	test   %eax,%eax
  803679:	0f 85 fa fb ff ff    	jne    803279 <insert_sorted_with_merge_freeList+0x2f0>
  80367f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803683:	0f 85 f0 fb ff ff    	jne    803279 <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  803689:	eb 01                	jmp    80368c <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  80368b:	90                   	nop
							}

						}
		          }
		}
}
  80368c:	90                   	nop
  80368d:	c9                   	leave  
  80368e:	c3                   	ret    
  80368f:	90                   	nop

00803690 <__udivdi3>:
  803690:	55                   	push   %ebp
  803691:	57                   	push   %edi
  803692:	56                   	push   %esi
  803693:	53                   	push   %ebx
  803694:	83 ec 1c             	sub    $0x1c,%esp
  803697:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80369b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80369f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8036a3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8036a7:	89 ca                	mov    %ecx,%edx
  8036a9:	89 f8                	mov    %edi,%eax
  8036ab:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8036af:	85 f6                	test   %esi,%esi
  8036b1:	75 2d                	jne    8036e0 <__udivdi3+0x50>
  8036b3:	39 cf                	cmp    %ecx,%edi
  8036b5:	77 65                	ja     80371c <__udivdi3+0x8c>
  8036b7:	89 fd                	mov    %edi,%ebp
  8036b9:	85 ff                	test   %edi,%edi
  8036bb:	75 0b                	jne    8036c8 <__udivdi3+0x38>
  8036bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8036c2:	31 d2                	xor    %edx,%edx
  8036c4:	f7 f7                	div    %edi
  8036c6:	89 c5                	mov    %eax,%ebp
  8036c8:	31 d2                	xor    %edx,%edx
  8036ca:	89 c8                	mov    %ecx,%eax
  8036cc:	f7 f5                	div    %ebp
  8036ce:	89 c1                	mov    %eax,%ecx
  8036d0:	89 d8                	mov    %ebx,%eax
  8036d2:	f7 f5                	div    %ebp
  8036d4:	89 cf                	mov    %ecx,%edi
  8036d6:	89 fa                	mov    %edi,%edx
  8036d8:	83 c4 1c             	add    $0x1c,%esp
  8036db:	5b                   	pop    %ebx
  8036dc:	5e                   	pop    %esi
  8036dd:	5f                   	pop    %edi
  8036de:	5d                   	pop    %ebp
  8036df:	c3                   	ret    
  8036e0:	39 ce                	cmp    %ecx,%esi
  8036e2:	77 28                	ja     80370c <__udivdi3+0x7c>
  8036e4:	0f bd fe             	bsr    %esi,%edi
  8036e7:	83 f7 1f             	xor    $0x1f,%edi
  8036ea:	75 40                	jne    80372c <__udivdi3+0x9c>
  8036ec:	39 ce                	cmp    %ecx,%esi
  8036ee:	72 0a                	jb     8036fa <__udivdi3+0x6a>
  8036f0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8036f4:	0f 87 9e 00 00 00    	ja     803798 <__udivdi3+0x108>
  8036fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8036ff:	89 fa                	mov    %edi,%edx
  803701:	83 c4 1c             	add    $0x1c,%esp
  803704:	5b                   	pop    %ebx
  803705:	5e                   	pop    %esi
  803706:	5f                   	pop    %edi
  803707:	5d                   	pop    %ebp
  803708:	c3                   	ret    
  803709:	8d 76 00             	lea    0x0(%esi),%esi
  80370c:	31 ff                	xor    %edi,%edi
  80370e:	31 c0                	xor    %eax,%eax
  803710:	89 fa                	mov    %edi,%edx
  803712:	83 c4 1c             	add    $0x1c,%esp
  803715:	5b                   	pop    %ebx
  803716:	5e                   	pop    %esi
  803717:	5f                   	pop    %edi
  803718:	5d                   	pop    %ebp
  803719:	c3                   	ret    
  80371a:	66 90                	xchg   %ax,%ax
  80371c:	89 d8                	mov    %ebx,%eax
  80371e:	f7 f7                	div    %edi
  803720:	31 ff                	xor    %edi,%edi
  803722:	89 fa                	mov    %edi,%edx
  803724:	83 c4 1c             	add    $0x1c,%esp
  803727:	5b                   	pop    %ebx
  803728:	5e                   	pop    %esi
  803729:	5f                   	pop    %edi
  80372a:	5d                   	pop    %ebp
  80372b:	c3                   	ret    
  80372c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803731:	89 eb                	mov    %ebp,%ebx
  803733:	29 fb                	sub    %edi,%ebx
  803735:	89 f9                	mov    %edi,%ecx
  803737:	d3 e6                	shl    %cl,%esi
  803739:	89 c5                	mov    %eax,%ebp
  80373b:	88 d9                	mov    %bl,%cl
  80373d:	d3 ed                	shr    %cl,%ebp
  80373f:	89 e9                	mov    %ebp,%ecx
  803741:	09 f1                	or     %esi,%ecx
  803743:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803747:	89 f9                	mov    %edi,%ecx
  803749:	d3 e0                	shl    %cl,%eax
  80374b:	89 c5                	mov    %eax,%ebp
  80374d:	89 d6                	mov    %edx,%esi
  80374f:	88 d9                	mov    %bl,%cl
  803751:	d3 ee                	shr    %cl,%esi
  803753:	89 f9                	mov    %edi,%ecx
  803755:	d3 e2                	shl    %cl,%edx
  803757:	8b 44 24 08          	mov    0x8(%esp),%eax
  80375b:	88 d9                	mov    %bl,%cl
  80375d:	d3 e8                	shr    %cl,%eax
  80375f:	09 c2                	or     %eax,%edx
  803761:	89 d0                	mov    %edx,%eax
  803763:	89 f2                	mov    %esi,%edx
  803765:	f7 74 24 0c          	divl   0xc(%esp)
  803769:	89 d6                	mov    %edx,%esi
  80376b:	89 c3                	mov    %eax,%ebx
  80376d:	f7 e5                	mul    %ebp
  80376f:	39 d6                	cmp    %edx,%esi
  803771:	72 19                	jb     80378c <__udivdi3+0xfc>
  803773:	74 0b                	je     803780 <__udivdi3+0xf0>
  803775:	89 d8                	mov    %ebx,%eax
  803777:	31 ff                	xor    %edi,%edi
  803779:	e9 58 ff ff ff       	jmp    8036d6 <__udivdi3+0x46>
  80377e:	66 90                	xchg   %ax,%ax
  803780:	8b 54 24 08          	mov    0x8(%esp),%edx
  803784:	89 f9                	mov    %edi,%ecx
  803786:	d3 e2                	shl    %cl,%edx
  803788:	39 c2                	cmp    %eax,%edx
  80378a:	73 e9                	jae    803775 <__udivdi3+0xe5>
  80378c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80378f:	31 ff                	xor    %edi,%edi
  803791:	e9 40 ff ff ff       	jmp    8036d6 <__udivdi3+0x46>
  803796:	66 90                	xchg   %ax,%ax
  803798:	31 c0                	xor    %eax,%eax
  80379a:	e9 37 ff ff ff       	jmp    8036d6 <__udivdi3+0x46>
  80379f:	90                   	nop

008037a0 <__umoddi3>:
  8037a0:	55                   	push   %ebp
  8037a1:	57                   	push   %edi
  8037a2:	56                   	push   %esi
  8037a3:	53                   	push   %ebx
  8037a4:	83 ec 1c             	sub    $0x1c,%esp
  8037a7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8037ab:	8b 74 24 34          	mov    0x34(%esp),%esi
  8037af:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8037b3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8037b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8037bb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8037bf:	89 f3                	mov    %esi,%ebx
  8037c1:	89 fa                	mov    %edi,%edx
  8037c3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037c7:	89 34 24             	mov    %esi,(%esp)
  8037ca:	85 c0                	test   %eax,%eax
  8037cc:	75 1a                	jne    8037e8 <__umoddi3+0x48>
  8037ce:	39 f7                	cmp    %esi,%edi
  8037d0:	0f 86 a2 00 00 00    	jbe    803878 <__umoddi3+0xd8>
  8037d6:	89 c8                	mov    %ecx,%eax
  8037d8:	89 f2                	mov    %esi,%edx
  8037da:	f7 f7                	div    %edi
  8037dc:	89 d0                	mov    %edx,%eax
  8037de:	31 d2                	xor    %edx,%edx
  8037e0:	83 c4 1c             	add    $0x1c,%esp
  8037e3:	5b                   	pop    %ebx
  8037e4:	5e                   	pop    %esi
  8037e5:	5f                   	pop    %edi
  8037e6:	5d                   	pop    %ebp
  8037e7:	c3                   	ret    
  8037e8:	39 f0                	cmp    %esi,%eax
  8037ea:	0f 87 ac 00 00 00    	ja     80389c <__umoddi3+0xfc>
  8037f0:	0f bd e8             	bsr    %eax,%ebp
  8037f3:	83 f5 1f             	xor    $0x1f,%ebp
  8037f6:	0f 84 ac 00 00 00    	je     8038a8 <__umoddi3+0x108>
  8037fc:	bf 20 00 00 00       	mov    $0x20,%edi
  803801:	29 ef                	sub    %ebp,%edi
  803803:	89 fe                	mov    %edi,%esi
  803805:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803809:	89 e9                	mov    %ebp,%ecx
  80380b:	d3 e0                	shl    %cl,%eax
  80380d:	89 d7                	mov    %edx,%edi
  80380f:	89 f1                	mov    %esi,%ecx
  803811:	d3 ef                	shr    %cl,%edi
  803813:	09 c7                	or     %eax,%edi
  803815:	89 e9                	mov    %ebp,%ecx
  803817:	d3 e2                	shl    %cl,%edx
  803819:	89 14 24             	mov    %edx,(%esp)
  80381c:	89 d8                	mov    %ebx,%eax
  80381e:	d3 e0                	shl    %cl,%eax
  803820:	89 c2                	mov    %eax,%edx
  803822:	8b 44 24 08          	mov    0x8(%esp),%eax
  803826:	d3 e0                	shl    %cl,%eax
  803828:	89 44 24 04          	mov    %eax,0x4(%esp)
  80382c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803830:	89 f1                	mov    %esi,%ecx
  803832:	d3 e8                	shr    %cl,%eax
  803834:	09 d0                	or     %edx,%eax
  803836:	d3 eb                	shr    %cl,%ebx
  803838:	89 da                	mov    %ebx,%edx
  80383a:	f7 f7                	div    %edi
  80383c:	89 d3                	mov    %edx,%ebx
  80383e:	f7 24 24             	mull   (%esp)
  803841:	89 c6                	mov    %eax,%esi
  803843:	89 d1                	mov    %edx,%ecx
  803845:	39 d3                	cmp    %edx,%ebx
  803847:	0f 82 87 00 00 00    	jb     8038d4 <__umoddi3+0x134>
  80384d:	0f 84 91 00 00 00    	je     8038e4 <__umoddi3+0x144>
  803853:	8b 54 24 04          	mov    0x4(%esp),%edx
  803857:	29 f2                	sub    %esi,%edx
  803859:	19 cb                	sbb    %ecx,%ebx
  80385b:	89 d8                	mov    %ebx,%eax
  80385d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803861:	d3 e0                	shl    %cl,%eax
  803863:	89 e9                	mov    %ebp,%ecx
  803865:	d3 ea                	shr    %cl,%edx
  803867:	09 d0                	or     %edx,%eax
  803869:	89 e9                	mov    %ebp,%ecx
  80386b:	d3 eb                	shr    %cl,%ebx
  80386d:	89 da                	mov    %ebx,%edx
  80386f:	83 c4 1c             	add    $0x1c,%esp
  803872:	5b                   	pop    %ebx
  803873:	5e                   	pop    %esi
  803874:	5f                   	pop    %edi
  803875:	5d                   	pop    %ebp
  803876:	c3                   	ret    
  803877:	90                   	nop
  803878:	89 fd                	mov    %edi,%ebp
  80387a:	85 ff                	test   %edi,%edi
  80387c:	75 0b                	jne    803889 <__umoddi3+0xe9>
  80387e:	b8 01 00 00 00       	mov    $0x1,%eax
  803883:	31 d2                	xor    %edx,%edx
  803885:	f7 f7                	div    %edi
  803887:	89 c5                	mov    %eax,%ebp
  803889:	89 f0                	mov    %esi,%eax
  80388b:	31 d2                	xor    %edx,%edx
  80388d:	f7 f5                	div    %ebp
  80388f:	89 c8                	mov    %ecx,%eax
  803891:	f7 f5                	div    %ebp
  803893:	89 d0                	mov    %edx,%eax
  803895:	e9 44 ff ff ff       	jmp    8037de <__umoddi3+0x3e>
  80389a:	66 90                	xchg   %ax,%ax
  80389c:	89 c8                	mov    %ecx,%eax
  80389e:	89 f2                	mov    %esi,%edx
  8038a0:	83 c4 1c             	add    $0x1c,%esp
  8038a3:	5b                   	pop    %ebx
  8038a4:	5e                   	pop    %esi
  8038a5:	5f                   	pop    %edi
  8038a6:	5d                   	pop    %ebp
  8038a7:	c3                   	ret    
  8038a8:	3b 04 24             	cmp    (%esp),%eax
  8038ab:	72 06                	jb     8038b3 <__umoddi3+0x113>
  8038ad:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8038b1:	77 0f                	ja     8038c2 <__umoddi3+0x122>
  8038b3:	89 f2                	mov    %esi,%edx
  8038b5:	29 f9                	sub    %edi,%ecx
  8038b7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8038bb:	89 14 24             	mov    %edx,(%esp)
  8038be:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8038c2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8038c6:	8b 14 24             	mov    (%esp),%edx
  8038c9:	83 c4 1c             	add    $0x1c,%esp
  8038cc:	5b                   	pop    %ebx
  8038cd:	5e                   	pop    %esi
  8038ce:	5f                   	pop    %edi
  8038cf:	5d                   	pop    %ebp
  8038d0:	c3                   	ret    
  8038d1:	8d 76 00             	lea    0x0(%esi),%esi
  8038d4:	2b 04 24             	sub    (%esp),%eax
  8038d7:	19 fa                	sbb    %edi,%edx
  8038d9:	89 d1                	mov    %edx,%ecx
  8038db:	89 c6                	mov    %eax,%esi
  8038dd:	e9 71 ff ff ff       	jmp    803853 <__umoddi3+0xb3>
  8038e2:	66 90                	xchg   %ax,%ax
  8038e4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8038e8:	72 ea                	jb     8038d4 <__umoddi3+0x134>
  8038ea:	89 d9                	mov    %ebx,%ecx
  8038ec:	e9 62 ff ff ff       	jmp    803853 <__umoddi3+0xb3>

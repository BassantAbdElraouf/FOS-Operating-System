
obj/user/mergesort_noleakage:     file format elf32-i386


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
  800031:	e8 8f 07 00 00       	call   8007c5 <libmain>
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
  800041:	e8 fe 21 00 00       	call   802244 <sys_disable_interrupt>

		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 20 3b 80 00       	push   $0x803b20
  80004e:	e8 62 0b 00 00       	call   800bb5 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 22 3b 80 00       	push   $0x803b22
  80005e:	e8 52 0b 00 00       	call   800bb5 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 38 3b 80 00       	push   $0x803b38
  80006e:	e8 42 0b 00 00       	call   800bb5 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 22 3b 80 00       	push   $0x803b22
  80007e:	e8 32 0b 00 00       	call   800bb5 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 20 3b 80 00       	push   $0x803b20
  80008e:	e8 22 0b 00 00       	call   800bb5 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 50 3b 80 00       	push   $0x803b50
  8000a5:	e8 8d 11 00 00       	call   801237 <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 dd 16 00 00       	call   80179d <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 15 1c 00 00       	call   801cea <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 70 3b 80 00       	push   $0x803b70
  8000e3:	e8 cd 0a 00 00       	call   800bb5 <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 92 3b 80 00       	push   $0x803b92
  8000f3:	e8 bd 0a 00 00       	call   800bb5 <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 a0 3b 80 00       	push   $0x803ba0
  800103:	e8 ad 0a 00 00       	call   800bb5 <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 af 3b 80 00       	push   $0x803baf
  800113:	e8 9d 0a 00 00       	call   800bb5 <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 bf 3b 80 00       	push   $0x803bbf
  800123:	e8 8d 0a 00 00       	call   800bb5 <cprintf>
  800128:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012b:	e8 3d 06 00 00       	call   80076d <getchar>
  800130:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  800133:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	50                   	push   %eax
  80013b:	e8 e5 05 00 00       	call   800725 <cputchar>
  800140:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	6a 0a                	push   $0xa
  800148:	e8 d8 05 00 00       	call   800725 <cputchar>
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
  800162:	e8 f7 20 00 00       	call   80225e <sys_enable_interrupt>

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
  800183:	e8 f4 01 00 00       	call   80037c <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 12 02 00 00       	call   8003ad <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 34 02 00 00       	call   8003e2 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 21 02 00 00       	call   8003e2 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001c4:	83 ec 04             	sub    $0x4,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	6a 01                	push   $0x1
  8001cc:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cf:	e8 e0 02 00 00       	call   8004b4 <MSort>
  8001d4:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001d7:	e8 68 20 00 00       	call   802244 <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	68 c8 3b 80 00       	push   $0x803bc8
  8001e4:	e8 cc 09 00 00       	call   800bb5 <cprintf>
  8001e9:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ec:	e8 6d 20 00 00       	call   80225e <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001f1:	83 ec 08             	sub    $0x8,%esp
  8001f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001fa:	e8 d3 00 00 00       	call   8002d2 <CheckSorted>
  8001ff:	83 c4 10             	add    $0x10,%esp
  800202:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800205:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800209:	75 14                	jne    80021f <_main+0x1e7>
  80020b:	83 ec 04             	sub    $0x4,%esp
  80020e:	68 fc 3b 80 00       	push   $0x803bfc
  800213:	6a 4a                	push   $0x4a
  800215:	68 1e 3c 80 00       	push   $0x803c1e
  80021a:	e8 e2 06 00 00       	call   800901 <_panic>
		else
		{
			sys_disable_interrupt();
  80021f:	e8 20 20 00 00       	call   802244 <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	68 3c 3c 80 00       	push   $0x803c3c
  80022c:	e8 84 09 00 00       	call   800bb5 <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 70 3c 80 00       	push   $0x803c70
  80023c:	e8 74 09 00 00       	call   800bb5 <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 a4 3c 80 00       	push   $0x803ca4
  80024c:	e8 64 09 00 00       	call   800bb5 <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800254:	e8 05 20 00 00       	call   80225e <sys_enable_interrupt>
		}

		free(Elements) ;
  800259:	83 ec 0c             	sub    $0xc,%esp
  80025c:	ff 75 ec             	pushl  -0x14(%ebp)
  80025f:	e8 08 1b 00 00       	call   801d6c <free>
  800264:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  800267:	e8 d8 1f 00 00       	call   802244 <sys_disable_interrupt>
			Chose = 0 ;
  80026c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800270:	eb 42                	jmp    8002b4 <_main+0x27c>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800272:	83 ec 0c             	sub    $0xc,%esp
  800275:	68 d6 3c 80 00       	push   $0x803cd6
  80027a:	e8 36 09 00 00       	call   800bb5 <cprintf>
  80027f:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800282:	e8 e6 04 00 00       	call   80076d <getchar>
  800287:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80028a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80028e:	83 ec 0c             	sub    $0xc,%esp
  800291:	50                   	push   %eax
  800292:	e8 8e 04 00 00       	call   800725 <cputchar>
  800297:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80029a:	83 ec 0c             	sub    $0xc,%esp
  80029d:	6a 0a                	push   $0xa
  80029f:	e8 81 04 00 00       	call   800725 <cputchar>
  8002a4:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  8002a7:	83 ec 0c             	sub    $0xc,%esp
  8002aa:	6a 0a                	push   $0xa
  8002ac:	e8 74 04 00 00       	call   800725 <cputchar>
  8002b1:	83 c4 10             	add    $0x10,%esp

		free(Elements) ;

		sys_disable_interrupt();
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002b4:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002b8:	74 06                	je     8002c0 <_main+0x288>
  8002ba:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002be:	75 b2                	jne    800272 <_main+0x23a>
				Chose = getchar() ;
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		sys_enable_interrupt();
  8002c0:	e8 99 1f 00 00       	call   80225e <sys_enable_interrupt>

	} while (Chose == 'y');
  8002c5:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002c9:	0f 84 72 fd ff ff    	je     800041 <_main+0x9>

}
  8002cf:	90                   	nop
  8002d0:	c9                   	leave  
  8002d1:	c3                   	ret    

008002d2 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002d2:	55                   	push   %ebp
  8002d3:	89 e5                	mov    %esp,%ebp
  8002d5:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8002d8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8002df:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8002e6:	eb 33                	jmp    80031b <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8002e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f5:	01 d0                	add    %edx,%eax
  8002f7:	8b 10                	mov    (%eax),%edx
  8002f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002fc:	40                   	inc    %eax
  8002fd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800304:	8b 45 08             	mov    0x8(%ebp),%eax
  800307:	01 c8                	add    %ecx,%eax
  800309:	8b 00                	mov    (%eax),%eax
  80030b:	39 c2                	cmp    %eax,%edx
  80030d:	7e 09                	jle    800318 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  80030f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800316:	eb 0c                	jmp    800324 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800318:	ff 45 f8             	incl   -0x8(%ebp)
  80031b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80031e:	48                   	dec    %eax
  80031f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800322:	7f c4                	jg     8002e8 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800324:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800327:	c9                   	leave  
  800328:	c3                   	ret    

00800329 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  800329:	55                   	push   %ebp
  80032a:	89 e5                	mov    %esp,%ebp
  80032c:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  80032f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800332:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800339:	8b 45 08             	mov    0x8(%ebp),%eax
  80033c:	01 d0                	add    %edx,%eax
  80033e:	8b 00                	mov    (%eax),%eax
  800340:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800343:	8b 45 0c             	mov    0xc(%ebp),%eax
  800346:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80034d:	8b 45 08             	mov    0x8(%ebp),%eax
  800350:	01 c2                	add    %eax,%edx
  800352:	8b 45 10             	mov    0x10(%ebp),%eax
  800355:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80035c:	8b 45 08             	mov    0x8(%ebp),%eax
  80035f:	01 c8                	add    %ecx,%eax
  800361:	8b 00                	mov    (%eax),%eax
  800363:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800365:	8b 45 10             	mov    0x10(%ebp),%eax
  800368:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80036f:	8b 45 08             	mov    0x8(%ebp),%eax
  800372:	01 c2                	add    %eax,%edx
  800374:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800377:	89 02                	mov    %eax,(%edx)
}
  800379:	90                   	nop
  80037a:	c9                   	leave  
  80037b:	c3                   	ret    

0080037c <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80037c:	55                   	push   %ebp
  80037d:	89 e5                	mov    %esp,%ebp
  80037f:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800382:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800389:	eb 17                	jmp    8003a2 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80038b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80038e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800395:	8b 45 08             	mov    0x8(%ebp),%eax
  800398:	01 c2                	add    %eax,%edx
  80039a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80039d:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80039f:	ff 45 fc             	incl   -0x4(%ebp)
  8003a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003a5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003a8:	7c e1                	jl     80038b <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8003aa:	90                   	nop
  8003ab:	c9                   	leave  
  8003ac:	c3                   	ret    

008003ad <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8003ad:	55                   	push   %ebp
  8003ae:	89 e5                	mov    %esp,%ebp
  8003b0:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003ba:	eb 1b                	jmp    8003d7 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8003bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003bf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c9:	01 c2                	add    %eax,%edx
  8003cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ce:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003d1:	48                   	dec    %eax
  8003d2:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003d4:	ff 45 fc             	incl   -0x4(%ebp)
  8003d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003da:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003dd:	7c dd                	jl     8003bc <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8003df:	90                   	nop
  8003e0:	c9                   	leave  
  8003e1:	c3                   	ret    

008003e2 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8003e2:	55                   	push   %ebp
  8003e3:	89 e5                	mov    %esp,%ebp
  8003e5:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8003e8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003eb:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8003f0:	f7 e9                	imul   %ecx
  8003f2:	c1 f9 1f             	sar    $0x1f,%ecx
  8003f5:	89 d0                	mov    %edx,%eax
  8003f7:	29 c8                	sub    %ecx,%eax
  8003f9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8003fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800403:	eb 1e                	jmp    800423 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  800405:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800408:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80040f:	8b 45 08             	mov    0x8(%ebp),%eax
  800412:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800415:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800418:	99                   	cltd   
  800419:	f7 7d f8             	idivl  -0x8(%ebp)
  80041c:	89 d0                	mov    %edx,%eax
  80041e:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800420:	ff 45 fc             	incl   -0x4(%ebp)
  800423:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800426:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800429:	7c da                	jl     800405 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
			//cprintf("i=%d\n",i);
	}

}
  80042b:	90                   	nop
  80042c:	c9                   	leave  
  80042d:	c3                   	ret    

0080042e <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  80042e:	55                   	push   %ebp
  80042f:	89 e5                	mov    %esp,%ebp
  800431:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800434:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80043b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800442:	eb 42                	jmp    800486 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800444:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800447:	99                   	cltd   
  800448:	f7 7d f0             	idivl  -0x10(%ebp)
  80044b:	89 d0                	mov    %edx,%eax
  80044d:	85 c0                	test   %eax,%eax
  80044f:	75 10                	jne    800461 <PrintElements+0x33>
			cprintf("\n");
  800451:	83 ec 0c             	sub    $0xc,%esp
  800454:	68 20 3b 80 00       	push   $0x803b20
  800459:	e8 57 07 00 00       	call   800bb5 <cprintf>
  80045e:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800464:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80046b:	8b 45 08             	mov    0x8(%ebp),%eax
  80046e:	01 d0                	add    %edx,%eax
  800470:	8b 00                	mov    (%eax),%eax
  800472:	83 ec 08             	sub    $0x8,%esp
  800475:	50                   	push   %eax
  800476:	68 f4 3c 80 00       	push   $0x803cf4
  80047b:	e8 35 07 00 00       	call   800bb5 <cprintf>
  800480:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800483:	ff 45 f4             	incl   -0xc(%ebp)
  800486:	8b 45 0c             	mov    0xc(%ebp),%eax
  800489:	48                   	dec    %eax
  80048a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80048d:	7f b5                	jg     800444 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  80048f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800492:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800499:	8b 45 08             	mov    0x8(%ebp),%eax
  80049c:	01 d0                	add    %edx,%eax
  80049e:	8b 00                	mov    (%eax),%eax
  8004a0:	83 ec 08             	sub    $0x8,%esp
  8004a3:	50                   	push   %eax
  8004a4:	68 f9 3c 80 00       	push   $0x803cf9
  8004a9:	e8 07 07 00 00       	call   800bb5 <cprintf>
  8004ae:	83 c4 10             	add    $0x10,%esp

}
  8004b1:	90                   	nop
  8004b2:	c9                   	leave  
  8004b3:	c3                   	ret    

008004b4 <MSort>:


void MSort(int* A, int p, int r)
{
  8004b4:	55                   	push   %ebp
  8004b5:	89 e5                	mov    %esp,%ebp
  8004b7:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  8004ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004bd:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004c0:	7d 54                	jge    800516 <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8004c8:	01 d0                	add    %edx,%eax
  8004ca:	89 c2                	mov    %eax,%edx
  8004cc:	c1 ea 1f             	shr    $0x1f,%edx
  8004cf:	01 d0                	add    %edx,%eax
  8004d1:	d1 f8                	sar    %eax
  8004d3:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8004d6:	83 ec 04             	sub    $0x4,%esp
  8004d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8004dc:	ff 75 0c             	pushl  0xc(%ebp)
  8004df:	ff 75 08             	pushl  0x8(%ebp)
  8004e2:	e8 cd ff ff ff       	call   8004b4 <MSort>
  8004e7:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  8004ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004ed:	40                   	inc    %eax
  8004ee:	83 ec 04             	sub    $0x4,%esp
  8004f1:	ff 75 10             	pushl  0x10(%ebp)
  8004f4:	50                   	push   %eax
  8004f5:	ff 75 08             	pushl  0x8(%ebp)
  8004f8:	e8 b7 ff ff ff       	call   8004b4 <MSort>
  8004fd:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  800500:	ff 75 10             	pushl  0x10(%ebp)
  800503:	ff 75 f4             	pushl  -0xc(%ebp)
  800506:	ff 75 0c             	pushl  0xc(%ebp)
  800509:	ff 75 08             	pushl  0x8(%ebp)
  80050c:	e8 08 00 00 00       	call   800519 <Merge>
  800511:	83 c4 10             	add    $0x10,%esp
  800514:	eb 01                	jmp    800517 <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  800516:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  800517:	c9                   	leave  
  800518:	c3                   	ret    

00800519 <Merge>:

void Merge(int* A, int p, int q, int r)
{
  800519:	55                   	push   %ebp
  80051a:	89 e5                	mov    %esp,%ebp
  80051c:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  80051f:	8b 45 10             	mov    0x10(%ebp),%eax
  800522:	2b 45 0c             	sub    0xc(%ebp),%eax
  800525:	40                   	inc    %eax
  800526:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  800529:	8b 45 14             	mov    0x14(%ebp),%eax
  80052c:	2b 45 10             	sub    0x10(%ebp),%eax
  80052f:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800532:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  800539:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	//cprintf("allocate LEFT\n");
	int* Left = malloc(sizeof(int) * leftCapacity);
  800540:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800543:	c1 e0 02             	shl    $0x2,%eax
  800546:	83 ec 0c             	sub    $0xc,%esp
  800549:	50                   	push   %eax
  80054a:	e8 9b 17 00 00       	call   801cea <malloc>
  80054f:	83 c4 10             	add    $0x10,%esp
  800552:	89 45 d8             	mov    %eax,-0x28(%ebp)

	//cprintf("allocate RIGHT\n");
	int* Right = malloc(sizeof(int) * rightCapacity);
  800555:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800558:	c1 e0 02             	shl    $0x2,%eax
  80055b:	83 ec 0c             	sub    $0xc,%esp
  80055e:	50                   	push   %eax
  80055f:	e8 86 17 00 00       	call   801cea <malloc>
  800564:	83 c4 10             	add    $0x10,%esp
  800567:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  80056a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800571:	eb 2f                	jmp    8005a2 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  800573:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800576:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80057d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800580:	01 c2                	add    %eax,%edx
  800582:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800585:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800588:	01 c8                	add    %ecx,%eax
  80058a:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80058f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800596:	8b 45 08             	mov    0x8(%ebp),%eax
  800599:	01 c8                	add    %ecx,%eax
  80059b:	8b 00                	mov    (%eax),%eax
  80059d:	89 02                	mov    %eax,(%edx)

	//cprintf("allocate RIGHT\n");
	int* Right = malloc(sizeof(int) * rightCapacity);

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  80059f:	ff 45 ec             	incl   -0x14(%ebp)
  8005a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005a5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005a8:	7c c9                	jl     800573 <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005aa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005b1:	eb 2a                	jmp    8005dd <Merge+0xc4>
	{
		Right[j] = A[q + j];
  8005b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005b6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005c0:	01 c2                	add    %eax,%edx
  8005c2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005c8:	01 c8                	add    %ecx,%eax
  8005ca:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d4:	01 c8                	add    %ecx,%eax
  8005d6:	8b 00                	mov    (%eax),%eax
  8005d8:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005da:	ff 45 e8             	incl   -0x18(%ebp)
  8005dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005e0:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005e3:	7c ce                	jl     8005b3 <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8005e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005eb:	e9 0a 01 00 00       	jmp    8006fa <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  8005f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005f3:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005f6:	0f 8d 95 00 00 00    	jge    800691 <Merge+0x178>
  8005fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005ff:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800602:	0f 8d 89 00 00 00    	jge    800691 <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80060b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800612:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800615:	01 d0                	add    %edx,%eax
  800617:	8b 10                	mov    (%eax),%edx
  800619:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80061c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800623:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800626:	01 c8                	add    %ecx,%eax
  800628:	8b 00                	mov    (%eax),%eax
  80062a:	39 c2                	cmp    %eax,%edx
  80062c:	7d 33                	jge    800661 <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  80062e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800631:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800636:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80063d:	8b 45 08             	mov    0x8(%ebp),%eax
  800640:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800643:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800646:	8d 50 01             	lea    0x1(%eax),%edx
  800649:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80064c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800653:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800656:	01 d0                	add    %edx,%eax
  800658:	8b 00                	mov    (%eax),%eax
  80065a:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80065c:	e9 96 00 00 00       	jmp    8006f7 <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  800661:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800664:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800669:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800670:	8b 45 08             	mov    0x8(%ebp),%eax
  800673:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800676:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800679:	8d 50 01             	lea    0x1(%eax),%edx
  80067c:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80067f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800686:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800689:	01 d0                	add    %edx,%eax
  80068b:	8b 00                	mov    (%eax),%eax
  80068d:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80068f:	eb 66                	jmp    8006f7 <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  800691:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800694:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800697:	7d 30                	jge    8006c9 <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  800699:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80069c:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006a1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ab:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006b1:	8d 50 01             	lea    0x1(%eax),%edx
  8006b4:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8006b7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006be:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006c1:	01 d0                	add    %edx,%eax
  8006c3:	8b 00                	mov    (%eax),%eax
  8006c5:	89 01                	mov    %eax,(%ecx)
  8006c7:	eb 2e                	jmp    8006f7 <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  8006c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006cc:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006db:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006e1:	8d 50 01             	lea    0x1(%eax),%edx
  8006e4:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8006e7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006f1:	01 d0                	add    %edx,%eax
  8006f3:	8b 00                	mov    (%eax),%eax
  8006f5:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8006f7:	ff 45 e4             	incl   -0x1c(%ebp)
  8006fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006fd:	3b 45 14             	cmp    0x14(%ebp),%eax
  800700:	0f 8e ea fe ff ff    	jle    8005f0 <Merge+0xd7>
			A[k - 1] = Right[rightIndex++];
		}
	}

	//cprintf("free LEFT\n");
	free(Left);
  800706:	83 ec 0c             	sub    $0xc,%esp
  800709:	ff 75 d8             	pushl  -0x28(%ebp)
  80070c:	e8 5b 16 00 00       	call   801d6c <free>
  800711:	83 c4 10             	add    $0x10,%esp
	//cprintf("free RIGHT\n");
	free(Right);
  800714:	83 ec 0c             	sub    $0xc,%esp
  800717:	ff 75 d4             	pushl  -0x2c(%ebp)
  80071a:	e8 4d 16 00 00       	call   801d6c <free>
  80071f:	83 c4 10             	add    $0x10,%esp

}
  800722:	90                   	nop
  800723:	c9                   	leave  
  800724:	c3                   	ret    

00800725 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800725:	55                   	push   %ebp
  800726:	89 e5                	mov    %esp,%ebp
  800728:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  80072b:	8b 45 08             	mov    0x8(%ebp),%eax
  80072e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800731:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800735:	83 ec 0c             	sub    $0xc,%esp
  800738:	50                   	push   %eax
  800739:	e8 3a 1b 00 00       	call   802278 <sys_cputc>
  80073e:	83 c4 10             	add    $0x10,%esp
}
  800741:	90                   	nop
  800742:	c9                   	leave  
  800743:	c3                   	ret    

00800744 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  800744:	55                   	push   %ebp
  800745:	89 e5                	mov    %esp,%ebp
  800747:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80074a:	e8 f5 1a 00 00       	call   802244 <sys_disable_interrupt>
	char c = ch;
  80074f:	8b 45 08             	mov    0x8(%ebp),%eax
  800752:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800755:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800759:	83 ec 0c             	sub    $0xc,%esp
  80075c:	50                   	push   %eax
  80075d:	e8 16 1b 00 00       	call   802278 <sys_cputc>
  800762:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800765:	e8 f4 1a 00 00       	call   80225e <sys_enable_interrupt>
}
  80076a:	90                   	nop
  80076b:	c9                   	leave  
  80076c:	c3                   	ret    

0080076d <getchar>:

int
getchar(void)
{
  80076d:	55                   	push   %ebp
  80076e:	89 e5                	mov    %esp,%ebp
  800770:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800773:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80077a:	eb 08                	jmp    800784 <getchar+0x17>
	{
		c = sys_cgetc();
  80077c:	e8 3e 19 00 00       	call   8020bf <sys_cgetc>
  800781:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800784:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800788:	74 f2                	je     80077c <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  80078a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80078d:	c9                   	leave  
  80078e:	c3                   	ret    

0080078f <atomic_getchar>:

int
atomic_getchar(void)
{
  80078f:	55                   	push   %ebp
  800790:	89 e5                	mov    %esp,%ebp
  800792:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800795:	e8 aa 1a 00 00       	call   802244 <sys_disable_interrupt>
	int c=0;
  80079a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8007a1:	eb 08                	jmp    8007ab <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  8007a3:	e8 17 19 00 00       	call   8020bf <sys_cgetc>
  8007a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  8007ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8007af:	74 f2                	je     8007a3 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  8007b1:	e8 a8 1a 00 00       	call   80225e <sys_enable_interrupt>
	return c;
  8007b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8007b9:	c9                   	leave  
  8007ba:	c3                   	ret    

008007bb <iscons>:

int iscons(int fdnum)
{
  8007bb:	55                   	push   %ebp
  8007bc:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8007be:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8007c3:	5d                   	pop    %ebp
  8007c4:	c3                   	ret    

008007c5 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8007c5:	55                   	push   %ebp
  8007c6:	89 e5                	mov    %esp,%ebp
  8007c8:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8007cb:	e8 67 1c 00 00       	call   802437 <sys_getenvindex>
  8007d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8007d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007d6:	89 d0                	mov    %edx,%eax
  8007d8:	c1 e0 03             	shl    $0x3,%eax
  8007db:	01 d0                	add    %edx,%eax
  8007dd:	01 c0                	add    %eax,%eax
  8007df:	01 d0                	add    %edx,%eax
  8007e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007e8:	01 d0                	add    %edx,%eax
  8007ea:	c1 e0 04             	shl    $0x4,%eax
  8007ed:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8007f2:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8007f7:	a1 24 50 80 00       	mov    0x805024,%eax
  8007fc:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800802:	84 c0                	test   %al,%al
  800804:	74 0f                	je     800815 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800806:	a1 24 50 80 00       	mov    0x805024,%eax
  80080b:	05 5c 05 00 00       	add    $0x55c,%eax
  800810:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800815:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800819:	7e 0a                	jle    800825 <libmain+0x60>
		binaryname = argv[0];
  80081b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80081e:	8b 00                	mov    (%eax),%eax
  800820:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800825:	83 ec 08             	sub    $0x8,%esp
  800828:	ff 75 0c             	pushl  0xc(%ebp)
  80082b:	ff 75 08             	pushl  0x8(%ebp)
  80082e:	e8 05 f8 ff ff       	call   800038 <_main>
  800833:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800836:	e8 09 1a 00 00       	call   802244 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80083b:	83 ec 0c             	sub    $0xc,%esp
  80083e:	68 18 3d 80 00       	push   $0x803d18
  800843:	e8 6d 03 00 00       	call   800bb5 <cprintf>
  800848:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80084b:	a1 24 50 80 00       	mov    0x805024,%eax
  800850:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800856:	a1 24 50 80 00       	mov    0x805024,%eax
  80085b:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800861:	83 ec 04             	sub    $0x4,%esp
  800864:	52                   	push   %edx
  800865:	50                   	push   %eax
  800866:	68 40 3d 80 00       	push   $0x803d40
  80086b:	e8 45 03 00 00       	call   800bb5 <cprintf>
  800870:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800873:	a1 24 50 80 00       	mov    0x805024,%eax
  800878:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80087e:	a1 24 50 80 00       	mov    0x805024,%eax
  800883:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800889:	a1 24 50 80 00       	mov    0x805024,%eax
  80088e:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800894:	51                   	push   %ecx
  800895:	52                   	push   %edx
  800896:	50                   	push   %eax
  800897:	68 68 3d 80 00       	push   $0x803d68
  80089c:	e8 14 03 00 00       	call   800bb5 <cprintf>
  8008a1:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8008a4:	a1 24 50 80 00       	mov    0x805024,%eax
  8008a9:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8008af:	83 ec 08             	sub    $0x8,%esp
  8008b2:	50                   	push   %eax
  8008b3:	68 c0 3d 80 00       	push   $0x803dc0
  8008b8:	e8 f8 02 00 00       	call   800bb5 <cprintf>
  8008bd:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8008c0:	83 ec 0c             	sub    $0xc,%esp
  8008c3:	68 18 3d 80 00       	push   $0x803d18
  8008c8:	e8 e8 02 00 00       	call   800bb5 <cprintf>
  8008cd:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8008d0:	e8 89 19 00 00       	call   80225e <sys_enable_interrupt>

	// exit gracefully
	exit();
  8008d5:	e8 19 00 00 00       	call   8008f3 <exit>
}
  8008da:	90                   	nop
  8008db:	c9                   	leave  
  8008dc:	c3                   	ret    

008008dd <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8008dd:	55                   	push   %ebp
  8008de:	89 e5                	mov    %esp,%ebp
  8008e0:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8008e3:	83 ec 0c             	sub    $0xc,%esp
  8008e6:	6a 00                	push   $0x0
  8008e8:	e8 16 1b 00 00       	call   802403 <sys_destroy_env>
  8008ed:	83 c4 10             	add    $0x10,%esp
}
  8008f0:	90                   	nop
  8008f1:	c9                   	leave  
  8008f2:	c3                   	ret    

008008f3 <exit>:

void
exit(void)
{
  8008f3:	55                   	push   %ebp
  8008f4:	89 e5                	mov    %esp,%ebp
  8008f6:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8008f9:	e8 6b 1b 00 00       	call   802469 <sys_exit_env>
}
  8008fe:	90                   	nop
  8008ff:	c9                   	leave  
  800900:	c3                   	ret    

00800901 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800901:	55                   	push   %ebp
  800902:	89 e5                	mov    %esp,%ebp
  800904:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800907:	8d 45 10             	lea    0x10(%ebp),%eax
  80090a:	83 c0 04             	add    $0x4,%eax
  80090d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800910:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800915:	85 c0                	test   %eax,%eax
  800917:	74 16                	je     80092f <_panic+0x2e>
		cprintf("%s: ", argv0);
  800919:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80091e:	83 ec 08             	sub    $0x8,%esp
  800921:	50                   	push   %eax
  800922:	68 d4 3d 80 00       	push   $0x803dd4
  800927:	e8 89 02 00 00       	call   800bb5 <cprintf>
  80092c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80092f:	a1 00 50 80 00       	mov    0x805000,%eax
  800934:	ff 75 0c             	pushl  0xc(%ebp)
  800937:	ff 75 08             	pushl  0x8(%ebp)
  80093a:	50                   	push   %eax
  80093b:	68 d9 3d 80 00       	push   $0x803dd9
  800940:	e8 70 02 00 00       	call   800bb5 <cprintf>
  800945:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800948:	8b 45 10             	mov    0x10(%ebp),%eax
  80094b:	83 ec 08             	sub    $0x8,%esp
  80094e:	ff 75 f4             	pushl  -0xc(%ebp)
  800951:	50                   	push   %eax
  800952:	e8 f3 01 00 00       	call   800b4a <vcprintf>
  800957:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80095a:	83 ec 08             	sub    $0x8,%esp
  80095d:	6a 00                	push   $0x0
  80095f:	68 f5 3d 80 00       	push   $0x803df5
  800964:	e8 e1 01 00 00       	call   800b4a <vcprintf>
  800969:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80096c:	e8 82 ff ff ff       	call   8008f3 <exit>

	// should not return here
	while (1) ;
  800971:	eb fe                	jmp    800971 <_panic+0x70>

00800973 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800973:	55                   	push   %ebp
  800974:	89 e5                	mov    %esp,%ebp
  800976:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800979:	a1 24 50 80 00       	mov    0x805024,%eax
  80097e:	8b 50 74             	mov    0x74(%eax),%edx
  800981:	8b 45 0c             	mov    0xc(%ebp),%eax
  800984:	39 c2                	cmp    %eax,%edx
  800986:	74 14                	je     80099c <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800988:	83 ec 04             	sub    $0x4,%esp
  80098b:	68 f8 3d 80 00       	push   $0x803df8
  800990:	6a 26                	push   $0x26
  800992:	68 44 3e 80 00       	push   $0x803e44
  800997:	e8 65 ff ff ff       	call   800901 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80099c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8009a3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009aa:	e9 c2 00 00 00       	jmp    800a71 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8009af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bc:	01 d0                	add    %edx,%eax
  8009be:	8b 00                	mov    (%eax),%eax
  8009c0:	85 c0                	test   %eax,%eax
  8009c2:	75 08                	jne    8009cc <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8009c4:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8009c7:	e9 a2 00 00 00       	jmp    800a6e <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8009cc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009d3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8009da:	eb 69                	jmp    800a45 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8009dc:	a1 24 50 80 00       	mov    0x805024,%eax
  8009e1:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009e7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009ea:	89 d0                	mov    %edx,%eax
  8009ec:	01 c0                	add    %eax,%eax
  8009ee:	01 d0                	add    %edx,%eax
  8009f0:	c1 e0 03             	shl    $0x3,%eax
  8009f3:	01 c8                	add    %ecx,%eax
  8009f5:	8a 40 04             	mov    0x4(%eax),%al
  8009f8:	84 c0                	test   %al,%al
  8009fa:	75 46                	jne    800a42 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009fc:	a1 24 50 80 00       	mov    0x805024,%eax
  800a01:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800a07:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a0a:	89 d0                	mov    %edx,%eax
  800a0c:	01 c0                	add    %eax,%eax
  800a0e:	01 d0                	add    %edx,%eax
  800a10:	c1 e0 03             	shl    $0x3,%eax
  800a13:	01 c8                	add    %ecx,%eax
  800a15:	8b 00                	mov    (%eax),%eax
  800a17:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a1a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a1d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a22:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800a24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a27:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a31:	01 c8                	add    %ecx,%eax
  800a33:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a35:	39 c2                	cmp    %eax,%edx
  800a37:	75 09                	jne    800a42 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800a39:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a40:	eb 12                	jmp    800a54 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a42:	ff 45 e8             	incl   -0x18(%ebp)
  800a45:	a1 24 50 80 00       	mov    0x805024,%eax
  800a4a:	8b 50 74             	mov    0x74(%eax),%edx
  800a4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a50:	39 c2                	cmp    %eax,%edx
  800a52:	77 88                	ja     8009dc <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a54:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a58:	75 14                	jne    800a6e <CheckWSWithoutLastIndex+0xfb>
			panic(
  800a5a:	83 ec 04             	sub    $0x4,%esp
  800a5d:	68 50 3e 80 00       	push   $0x803e50
  800a62:	6a 3a                	push   $0x3a
  800a64:	68 44 3e 80 00       	push   $0x803e44
  800a69:	e8 93 fe ff ff       	call   800901 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a6e:	ff 45 f0             	incl   -0x10(%ebp)
  800a71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a74:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a77:	0f 8c 32 ff ff ff    	jl     8009af <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a7d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a84:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a8b:	eb 26                	jmp    800ab3 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a8d:	a1 24 50 80 00       	mov    0x805024,%eax
  800a92:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800a98:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a9b:	89 d0                	mov    %edx,%eax
  800a9d:	01 c0                	add    %eax,%eax
  800a9f:	01 d0                	add    %edx,%eax
  800aa1:	c1 e0 03             	shl    $0x3,%eax
  800aa4:	01 c8                	add    %ecx,%eax
  800aa6:	8a 40 04             	mov    0x4(%eax),%al
  800aa9:	3c 01                	cmp    $0x1,%al
  800aab:	75 03                	jne    800ab0 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800aad:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ab0:	ff 45 e0             	incl   -0x20(%ebp)
  800ab3:	a1 24 50 80 00       	mov    0x805024,%eax
  800ab8:	8b 50 74             	mov    0x74(%eax),%edx
  800abb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800abe:	39 c2                	cmp    %eax,%edx
  800ac0:	77 cb                	ja     800a8d <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ac5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800ac8:	74 14                	je     800ade <CheckWSWithoutLastIndex+0x16b>
		panic(
  800aca:	83 ec 04             	sub    $0x4,%esp
  800acd:	68 a4 3e 80 00       	push   $0x803ea4
  800ad2:	6a 44                	push   $0x44
  800ad4:	68 44 3e 80 00       	push   $0x803e44
  800ad9:	e8 23 fe ff ff       	call   800901 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800ade:	90                   	nop
  800adf:	c9                   	leave  
  800ae0:	c3                   	ret    

00800ae1 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800ae1:	55                   	push   %ebp
  800ae2:	89 e5                	mov    %esp,%ebp
  800ae4:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800ae7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aea:	8b 00                	mov    (%eax),%eax
  800aec:	8d 48 01             	lea    0x1(%eax),%ecx
  800aef:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af2:	89 0a                	mov    %ecx,(%edx)
  800af4:	8b 55 08             	mov    0x8(%ebp),%edx
  800af7:	88 d1                	mov    %dl,%cl
  800af9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800afc:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800b00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b03:	8b 00                	mov    (%eax),%eax
  800b05:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b0a:	75 2c                	jne    800b38 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800b0c:	a0 28 50 80 00       	mov    0x805028,%al
  800b11:	0f b6 c0             	movzbl %al,%eax
  800b14:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b17:	8b 12                	mov    (%edx),%edx
  800b19:	89 d1                	mov    %edx,%ecx
  800b1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1e:	83 c2 08             	add    $0x8,%edx
  800b21:	83 ec 04             	sub    $0x4,%esp
  800b24:	50                   	push   %eax
  800b25:	51                   	push   %ecx
  800b26:	52                   	push   %edx
  800b27:	e8 6a 15 00 00       	call   802096 <sys_cputs>
  800b2c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b32:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3b:	8b 40 04             	mov    0x4(%eax),%eax
  800b3e:	8d 50 01             	lea    0x1(%eax),%edx
  800b41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b44:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b47:	90                   	nop
  800b48:	c9                   	leave  
  800b49:	c3                   	ret    

00800b4a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b4a:	55                   	push   %ebp
  800b4b:	89 e5                	mov    %esp,%ebp
  800b4d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b53:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b5a:	00 00 00 
	b.cnt = 0;
  800b5d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b64:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b67:	ff 75 0c             	pushl  0xc(%ebp)
  800b6a:	ff 75 08             	pushl  0x8(%ebp)
  800b6d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b73:	50                   	push   %eax
  800b74:	68 e1 0a 80 00       	push   $0x800ae1
  800b79:	e8 11 02 00 00       	call   800d8f <vprintfmt>
  800b7e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800b81:	a0 28 50 80 00       	mov    0x805028,%al
  800b86:	0f b6 c0             	movzbl %al,%eax
  800b89:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b8f:	83 ec 04             	sub    $0x4,%esp
  800b92:	50                   	push   %eax
  800b93:	52                   	push   %edx
  800b94:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b9a:	83 c0 08             	add    $0x8,%eax
  800b9d:	50                   	push   %eax
  800b9e:	e8 f3 14 00 00       	call   802096 <sys_cputs>
  800ba3:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800ba6:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800bad:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800bb3:	c9                   	leave  
  800bb4:	c3                   	ret    

00800bb5 <cprintf>:

int cprintf(const char *fmt, ...) {
  800bb5:	55                   	push   %ebp
  800bb6:	89 e5                	mov    %esp,%ebp
  800bb8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800bbb:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800bc2:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcb:	83 ec 08             	sub    $0x8,%esp
  800bce:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd1:	50                   	push   %eax
  800bd2:	e8 73 ff ff ff       	call   800b4a <vcprintf>
  800bd7:	83 c4 10             	add    $0x10,%esp
  800bda:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800bdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800be0:	c9                   	leave  
  800be1:	c3                   	ret    

00800be2 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800be2:	55                   	push   %ebp
  800be3:	89 e5                	mov    %esp,%ebp
  800be5:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800be8:	e8 57 16 00 00       	call   802244 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800bed:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bf0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf6:	83 ec 08             	sub    $0x8,%esp
  800bf9:	ff 75 f4             	pushl  -0xc(%ebp)
  800bfc:	50                   	push   %eax
  800bfd:	e8 48 ff ff ff       	call   800b4a <vcprintf>
  800c02:	83 c4 10             	add    $0x10,%esp
  800c05:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800c08:	e8 51 16 00 00       	call   80225e <sys_enable_interrupt>
	return cnt;
  800c0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c10:	c9                   	leave  
  800c11:	c3                   	ret    

00800c12 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c12:	55                   	push   %ebp
  800c13:	89 e5                	mov    %esp,%ebp
  800c15:	53                   	push   %ebx
  800c16:	83 ec 14             	sub    $0x14,%esp
  800c19:	8b 45 10             	mov    0x10(%ebp),%eax
  800c1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c22:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c25:	8b 45 18             	mov    0x18(%ebp),%eax
  800c28:	ba 00 00 00 00       	mov    $0x0,%edx
  800c2d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c30:	77 55                	ja     800c87 <printnum+0x75>
  800c32:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c35:	72 05                	jb     800c3c <printnum+0x2a>
  800c37:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c3a:	77 4b                	ja     800c87 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c3c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800c3f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800c42:	8b 45 18             	mov    0x18(%ebp),%eax
  800c45:	ba 00 00 00 00       	mov    $0x0,%edx
  800c4a:	52                   	push   %edx
  800c4b:	50                   	push   %eax
  800c4c:	ff 75 f4             	pushl  -0xc(%ebp)
  800c4f:	ff 75 f0             	pushl  -0x10(%ebp)
  800c52:	e8 4d 2c 00 00       	call   8038a4 <__udivdi3>
  800c57:	83 c4 10             	add    $0x10,%esp
  800c5a:	83 ec 04             	sub    $0x4,%esp
  800c5d:	ff 75 20             	pushl  0x20(%ebp)
  800c60:	53                   	push   %ebx
  800c61:	ff 75 18             	pushl  0x18(%ebp)
  800c64:	52                   	push   %edx
  800c65:	50                   	push   %eax
  800c66:	ff 75 0c             	pushl  0xc(%ebp)
  800c69:	ff 75 08             	pushl  0x8(%ebp)
  800c6c:	e8 a1 ff ff ff       	call   800c12 <printnum>
  800c71:	83 c4 20             	add    $0x20,%esp
  800c74:	eb 1a                	jmp    800c90 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c76:	83 ec 08             	sub    $0x8,%esp
  800c79:	ff 75 0c             	pushl  0xc(%ebp)
  800c7c:	ff 75 20             	pushl  0x20(%ebp)
  800c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c82:	ff d0                	call   *%eax
  800c84:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c87:	ff 4d 1c             	decl   0x1c(%ebp)
  800c8a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c8e:	7f e6                	jg     800c76 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c90:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c93:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c9e:	53                   	push   %ebx
  800c9f:	51                   	push   %ecx
  800ca0:	52                   	push   %edx
  800ca1:	50                   	push   %eax
  800ca2:	e8 0d 2d 00 00       	call   8039b4 <__umoddi3>
  800ca7:	83 c4 10             	add    $0x10,%esp
  800caa:	05 14 41 80 00       	add    $0x804114,%eax
  800caf:	8a 00                	mov    (%eax),%al
  800cb1:	0f be c0             	movsbl %al,%eax
  800cb4:	83 ec 08             	sub    $0x8,%esp
  800cb7:	ff 75 0c             	pushl  0xc(%ebp)
  800cba:	50                   	push   %eax
  800cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbe:	ff d0                	call   *%eax
  800cc0:	83 c4 10             	add    $0x10,%esp
}
  800cc3:	90                   	nop
  800cc4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800cc7:	c9                   	leave  
  800cc8:	c3                   	ret    

00800cc9 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800cc9:	55                   	push   %ebp
  800cca:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ccc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800cd0:	7e 1c                	jle    800cee <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd5:	8b 00                	mov    (%eax),%eax
  800cd7:	8d 50 08             	lea    0x8(%eax),%edx
  800cda:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdd:	89 10                	mov    %edx,(%eax)
  800cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce2:	8b 00                	mov    (%eax),%eax
  800ce4:	83 e8 08             	sub    $0x8,%eax
  800ce7:	8b 50 04             	mov    0x4(%eax),%edx
  800cea:	8b 00                	mov    (%eax),%eax
  800cec:	eb 40                	jmp    800d2e <getuint+0x65>
	else if (lflag)
  800cee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cf2:	74 1e                	je     800d12 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf7:	8b 00                	mov    (%eax),%eax
  800cf9:	8d 50 04             	lea    0x4(%eax),%edx
  800cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cff:	89 10                	mov    %edx,(%eax)
  800d01:	8b 45 08             	mov    0x8(%ebp),%eax
  800d04:	8b 00                	mov    (%eax),%eax
  800d06:	83 e8 04             	sub    $0x4,%eax
  800d09:	8b 00                	mov    (%eax),%eax
  800d0b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d10:	eb 1c                	jmp    800d2e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800d12:	8b 45 08             	mov    0x8(%ebp),%eax
  800d15:	8b 00                	mov    (%eax),%eax
  800d17:	8d 50 04             	lea    0x4(%eax),%edx
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	89 10                	mov    %edx,(%eax)
  800d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d22:	8b 00                	mov    (%eax),%eax
  800d24:	83 e8 04             	sub    $0x4,%eax
  800d27:	8b 00                	mov    (%eax),%eax
  800d29:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800d2e:	5d                   	pop    %ebp
  800d2f:	c3                   	ret    

00800d30 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800d30:	55                   	push   %ebp
  800d31:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d33:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d37:	7e 1c                	jle    800d55 <getint+0x25>
		return va_arg(*ap, long long);
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	8b 00                	mov    (%eax),%eax
  800d3e:	8d 50 08             	lea    0x8(%eax),%edx
  800d41:	8b 45 08             	mov    0x8(%ebp),%eax
  800d44:	89 10                	mov    %edx,(%eax)
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
  800d49:	8b 00                	mov    (%eax),%eax
  800d4b:	83 e8 08             	sub    $0x8,%eax
  800d4e:	8b 50 04             	mov    0x4(%eax),%edx
  800d51:	8b 00                	mov    (%eax),%eax
  800d53:	eb 38                	jmp    800d8d <getint+0x5d>
	else if (lflag)
  800d55:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d59:	74 1a                	je     800d75 <getint+0x45>
		return va_arg(*ap, long);
  800d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5e:	8b 00                	mov    (%eax),%eax
  800d60:	8d 50 04             	lea    0x4(%eax),%edx
  800d63:	8b 45 08             	mov    0x8(%ebp),%eax
  800d66:	89 10                	mov    %edx,(%eax)
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	8b 00                	mov    (%eax),%eax
  800d6d:	83 e8 04             	sub    $0x4,%eax
  800d70:	8b 00                	mov    (%eax),%eax
  800d72:	99                   	cltd   
  800d73:	eb 18                	jmp    800d8d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d75:	8b 45 08             	mov    0x8(%ebp),%eax
  800d78:	8b 00                	mov    (%eax),%eax
  800d7a:	8d 50 04             	lea    0x4(%eax),%edx
  800d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d80:	89 10                	mov    %edx,(%eax)
  800d82:	8b 45 08             	mov    0x8(%ebp),%eax
  800d85:	8b 00                	mov    (%eax),%eax
  800d87:	83 e8 04             	sub    $0x4,%eax
  800d8a:	8b 00                	mov    (%eax),%eax
  800d8c:	99                   	cltd   
}
  800d8d:	5d                   	pop    %ebp
  800d8e:	c3                   	ret    

00800d8f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d8f:	55                   	push   %ebp
  800d90:	89 e5                	mov    %esp,%ebp
  800d92:	56                   	push   %esi
  800d93:	53                   	push   %ebx
  800d94:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d97:	eb 17                	jmp    800db0 <vprintfmt+0x21>
			if (ch == '\0')
  800d99:	85 db                	test   %ebx,%ebx
  800d9b:	0f 84 af 03 00 00    	je     801150 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800da1:	83 ec 08             	sub    $0x8,%esp
  800da4:	ff 75 0c             	pushl  0xc(%ebp)
  800da7:	53                   	push   %ebx
  800da8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dab:	ff d0                	call   *%eax
  800dad:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800db0:	8b 45 10             	mov    0x10(%ebp),%eax
  800db3:	8d 50 01             	lea    0x1(%eax),%edx
  800db6:	89 55 10             	mov    %edx,0x10(%ebp)
  800db9:	8a 00                	mov    (%eax),%al
  800dbb:	0f b6 d8             	movzbl %al,%ebx
  800dbe:	83 fb 25             	cmp    $0x25,%ebx
  800dc1:	75 d6                	jne    800d99 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800dc3:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800dc7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800dce:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800dd5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800ddc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800de3:	8b 45 10             	mov    0x10(%ebp),%eax
  800de6:	8d 50 01             	lea    0x1(%eax),%edx
  800de9:	89 55 10             	mov    %edx,0x10(%ebp)
  800dec:	8a 00                	mov    (%eax),%al
  800dee:	0f b6 d8             	movzbl %al,%ebx
  800df1:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800df4:	83 f8 55             	cmp    $0x55,%eax
  800df7:	0f 87 2b 03 00 00    	ja     801128 <vprintfmt+0x399>
  800dfd:	8b 04 85 38 41 80 00 	mov    0x804138(,%eax,4),%eax
  800e04:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800e06:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800e0a:	eb d7                	jmp    800de3 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e0c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800e10:	eb d1                	jmp    800de3 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e12:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800e19:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e1c:	89 d0                	mov    %edx,%eax
  800e1e:	c1 e0 02             	shl    $0x2,%eax
  800e21:	01 d0                	add    %edx,%eax
  800e23:	01 c0                	add    %eax,%eax
  800e25:	01 d8                	add    %ebx,%eax
  800e27:	83 e8 30             	sub    $0x30,%eax
  800e2a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800e2d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e30:	8a 00                	mov    (%eax),%al
  800e32:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e35:	83 fb 2f             	cmp    $0x2f,%ebx
  800e38:	7e 3e                	jle    800e78 <vprintfmt+0xe9>
  800e3a:	83 fb 39             	cmp    $0x39,%ebx
  800e3d:	7f 39                	jg     800e78 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e3f:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e42:	eb d5                	jmp    800e19 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800e44:	8b 45 14             	mov    0x14(%ebp),%eax
  800e47:	83 c0 04             	add    $0x4,%eax
  800e4a:	89 45 14             	mov    %eax,0x14(%ebp)
  800e4d:	8b 45 14             	mov    0x14(%ebp),%eax
  800e50:	83 e8 04             	sub    $0x4,%eax
  800e53:	8b 00                	mov    (%eax),%eax
  800e55:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800e58:	eb 1f                	jmp    800e79 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800e5a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e5e:	79 83                	jns    800de3 <vprintfmt+0x54>
				width = 0;
  800e60:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e67:	e9 77 ff ff ff       	jmp    800de3 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e6c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e73:	e9 6b ff ff ff       	jmp    800de3 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e78:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e79:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e7d:	0f 89 60 ff ff ff    	jns    800de3 <vprintfmt+0x54>
				width = precision, precision = -1;
  800e83:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e86:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e89:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e90:	e9 4e ff ff ff       	jmp    800de3 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e95:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e98:	e9 46 ff ff ff       	jmp    800de3 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e9d:	8b 45 14             	mov    0x14(%ebp),%eax
  800ea0:	83 c0 04             	add    $0x4,%eax
  800ea3:	89 45 14             	mov    %eax,0x14(%ebp)
  800ea6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ea9:	83 e8 04             	sub    $0x4,%eax
  800eac:	8b 00                	mov    (%eax),%eax
  800eae:	83 ec 08             	sub    $0x8,%esp
  800eb1:	ff 75 0c             	pushl  0xc(%ebp)
  800eb4:	50                   	push   %eax
  800eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb8:	ff d0                	call   *%eax
  800eba:	83 c4 10             	add    $0x10,%esp
			break;
  800ebd:	e9 89 02 00 00       	jmp    80114b <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ec2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec5:	83 c0 04             	add    $0x4,%eax
  800ec8:	89 45 14             	mov    %eax,0x14(%ebp)
  800ecb:	8b 45 14             	mov    0x14(%ebp),%eax
  800ece:	83 e8 04             	sub    $0x4,%eax
  800ed1:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ed3:	85 db                	test   %ebx,%ebx
  800ed5:	79 02                	jns    800ed9 <vprintfmt+0x14a>
				err = -err;
  800ed7:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ed9:	83 fb 64             	cmp    $0x64,%ebx
  800edc:	7f 0b                	jg     800ee9 <vprintfmt+0x15a>
  800ede:	8b 34 9d 80 3f 80 00 	mov    0x803f80(,%ebx,4),%esi
  800ee5:	85 f6                	test   %esi,%esi
  800ee7:	75 19                	jne    800f02 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ee9:	53                   	push   %ebx
  800eea:	68 25 41 80 00       	push   $0x804125
  800eef:	ff 75 0c             	pushl  0xc(%ebp)
  800ef2:	ff 75 08             	pushl  0x8(%ebp)
  800ef5:	e8 5e 02 00 00       	call   801158 <printfmt>
  800efa:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800efd:	e9 49 02 00 00       	jmp    80114b <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f02:	56                   	push   %esi
  800f03:	68 2e 41 80 00       	push   $0x80412e
  800f08:	ff 75 0c             	pushl  0xc(%ebp)
  800f0b:	ff 75 08             	pushl  0x8(%ebp)
  800f0e:	e8 45 02 00 00       	call   801158 <printfmt>
  800f13:	83 c4 10             	add    $0x10,%esp
			break;
  800f16:	e9 30 02 00 00       	jmp    80114b <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800f1b:	8b 45 14             	mov    0x14(%ebp),%eax
  800f1e:	83 c0 04             	add    $0x4,%eax
  800f21:	89 45 14             	mov    %eax,0x14(%ebp)
  800f24:	8b 45 14             	mov    0x14(%ebp),%eax
  800f27:	83 e8 04             	sub    $0x4,%eax
  800f2a:	8b 30                	mov    (%eax),%esi
  800f2c:	85 f6                	test   %esi,%esi
  800f2e:	75 05                	jne    800f35 <vprintfmt+0x1a6>
				p = "(null)";
  800f30:	be 31 41 80 00       	mov    $0x804131,%esi
			if (width > 0 && padc != '-')
  800f35:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f39:	7e 6d                	jle    800fa8 <vprintfmt+0x219>
  800f3b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800f3f:	74 67                	je     800fa8 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800f41:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f44:	83 ec 08             	sub    $0x8,%esp
  800f47:	50                   	push   %eax
  800f48:	56                   	push   %esi
  800f49:	e8 12 05 00 00       	call   801460 <strnlen>
  800f4e:	83 c4 10             	add    $0x10,%esp
  800f51:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800f54:	eb 16                	jmp    800f6c <vprintfmt+0x1dd>
					putch(padc, putdat);
  800f56:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800f5a:	83 ec 08             	sub    $0x8,%esp
  800f5d:	ff 75 0c             	pushl  0xc(%ebp)
  800f60:	50                   	push   %eax
  800f61:	8b 45 08             	mov    0x8(%ebp),%eax
  800f64:	ff d0                	call   *%eax
  800f66:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f69:	ff 4d e4             	decl   -0x1c(%ebp)
  800f6c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f70:	7f e4                	jg     800f56 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f72:	eb 34                	jmp    800fa8 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f74:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f78:	74 1c                	je     800f96 <vprintfmt+0x207>
  800f7a:	83 fb 1f             	cmp    $0x1f,%ebx
  800f7d:	7e 05                	jle    800f84 <vprintfmt+0x1f5>
  800f7f:	83 fb 7e             	cmp    $0x7e,%ebx
  800f82:	7e 12                	jle    800f96 <vprintfmt+0x207>
					putch('?', putdat);
  800f84:	83 ec 08             	sub    $0x8,%esp
  800f87:	ff 75 0c             	pushl  0xc(%ebp)
  800f8a:	6a 3f                	push   $0x3f
  800f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8f:	ff d0                	call   *%eax
  800f91:	83 c4 10             	add    $0x10,%esp
  800f94:	eb 0f                	jmp    800fa5 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f96:	83 ec 08             	sub    $0x8,%esp
  800f99:	ff 75 0c             	pushl  0xc(%ebp)
  800f9c:	53                   	push   %ebx
  800f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa0:	ff d0                	call   *%eax
  800fa2:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800fa5:	ff 4d e4             	decl   -0x1c(%ebp)
  800fa8:	89 f0                	mov    %esi,%eax
  800faa:	8d 70 01             	lea    0x1(%eax),%esi
  800fad:	8a 00                	mov    (%eax),%al
  800faf:	0f be d8             	movsbl %al,%ebx
  800fb2:	85 db                	test   %ebx,%ebx
  800fb4:	74 24                	je     800fda <vprintfmt+0x24b>
  800fb6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fba:	78 b8                	js     800f74 <vprintfmt+0x1e5>
  800fbc:	ff 4d e0             	decl   -0x20(%ebp)
  800fbf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fc3:	79 af                	jns    800f74 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fc5:	eb 13                	jmp    800fda <vprintfmt+0x24b>
				putch(' ', putdat);
  800fc7:	83 ec 08             	sub    $0x8,%esp
  800fca:	ff 75 0c             	pushl  0xc(%ebp)
  800fcd:	6a 20                	push   $0x20
  800fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd2:	ff d0                	call   *%eax
  800fd4:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fd7:	ff 4d e4             	decl   -0x1c(%ebp)
  800fda:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fde:	7f e7                	jg     800fc7 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800fe0:	e9 66 01 00 00       	jmp    80114b <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800fe5:	83 ec 08             	sub    $0x8,%esp
  800fe8:	ff 75 e8             	pushl  -0x18(%ebp)
  800feb:	8d 45 14             	lea    0x14(%ebp),%eax
  800fee:	50                   	push   %eax
  800fef:	e8 3c fd ff ff       	call   800d30 <getint>
  800ff4:	83 c4 10             	add    $0x10,%esp
  800ff7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ffa:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ffd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801000:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801003:	85 d2                	test   %edx,%edx
  801005:	79 23                	jns    80102a <vprintfmt+0x29b>
				putch('-', putdat);
  801007:	83 ec 08             	sub    $0x8,%esp
  80100a:	ff 75 0c             	pushl  0xc(%ebp)
  80100d:	6a 2d                	push   $0x2d
  80100f:	8b 45 08             	mov    0x8(%ebp),%eax
  801012:	ff d0                	call   *%eax
  801014:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801017:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80101a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80101d:	f7 d8                	neg    %eax
  80101f:	83 d2 00             	adc    $0x0,%edx
  801022:	f7 da                	neg    %edx
  801024:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801027:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80102a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801031:	e9 bc 00 00 00       	jmp    8010f2 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801036:	83 ec 08             	sub    $0x8,%esp
  801039:	ff 75 e8             	pushl  -0x18(%ebp)
  80103c:	8d 45 14             	lea    0x14(%ebp),%eax
  80103f:	50                   	push   %eax
  801040:	e8 84 fc ff ff       	call   800cc9 <getuint>
  801045:	83 c4 10             	add    $0x10,%esp
  801048:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80104b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80104e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801055:	e9 98 00 00 00       	jmp    8010f2 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80105a:	83 ec 08             	sub    $0x8,%esp
  80105d:	ff 75 0c             	pushl  0xc(%ebp)
  801060:	6a 58                	push   $0x58
  801062:	8b 45 08             	mov    0x8(%ebp),%eax
  801065:	ff d0                	call   *%eax
  801067:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80106a:	83 ec 08             	sub    $0x8,%esp
  80106d:	ff 75 0c             	pushl  0xc(%ebp)
  801070:	6a 58                	push   $0x58
  801072:	8b 45 08             	mov    0x8(%ebp),%eax
  801075:	ff d0                	call   *%eax
  801077:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80107a:	83 ec 08             	sub    $0x8,%esp
  80107d:	ff 75 0c             	pushl  0xc(%ebp)
  801080:	6a 58                	push   $0x58
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	ff d0                	call   *%eax
  801087:	83 c4 10             	add    $0x10,%esp
			break;
  80108a:	e9 bc 00 00 00       	jmp    80114b <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80108f:	83 ec 08             	sub    $0x8,%esp
  801092:	ff 75 0c             	pushl  0xc(%ebp)
  801095:	6a 30                	push   $0x30
  801097:	8b 45 08             	mov    0x8(%ebp),%eax
  80109a:	ff d0                	call   *%eax
  80109c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80109f:	83 ec 08             	sub    $0x8,%esp
  8010a2:	ff 75 0c             	pushl  0xc(%ebp)
  8010a5:	6a 78                	push   $0x78
  8010a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010aa:	ff d0                	call   *%eax
  8010ac:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8010af:	8b 45 14             	mov    0x14(%ebp),%eax
  8010b2:	83 c0 04             	add    $0x4,%eax
  8010b5:	89 45 14             	mov    %eax,0x14(%ebp)
  8010b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8010bb:	83 e8 04             	sub    $0x4,%eax
  8010be:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8010c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8010ca:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8010d1:	eb 1f                	jmp    8010f2 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8010d3:	83 ec 08             	sub    $0x8,%esp
  8010d6:	ff 75 e8             	pushl  -0x18(%ebp)
  8010d9:	8d 45 14             	lea    0x14(%ebp),%eax
  8010dc:	50                   	push   %eax
  8010dd:	e8 e7 fb ff ff       	call   800cc9 <getuint>
  8010e2:	83 c4 10             	add    $0x10,%esp
  8010e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010e8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8010eb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8010f2:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8010f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010f9:	83 ec 04             	sub    $0x4,%esp
  8010fc:	52                   	push   %edx
  8010fd:	ff 75 e4             	pushl  -0x1c(%ebp)
  801100:	50                   	push   %eax
  801101:	ff 75 f4             	pushl  -0xc(%ebp)
  801104:	ff 75 f0             	pushl  -0x10(%ebp)
  801107:	ff 75 0c             	pushl  0xc(%ebp)
  80110a:	ff 75 08             	pushl  0x8(%ebp)
  80110d:	e8 00 fb ff ff       	call   800c12 <printnum>
  801112:	83 c4 20             	add    $0x20,%esp
			break;
  801115:	eb 34                	jmp    80114b <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801117:	83 ec 08             	sub    $0x8,%esp
  80111a:	ff 75 0c             	pushl  0xc(%ebp)
  80111d:	53                   	push   %ebx
  80111e:	8b 45 08             	mov    0x8(%ebp),%eax
  801121:	ff d0                	call   *%eax
  801123:	83 c4 10             	add    $0x10,%esp
			break;
  801126:	eb 23                	jmp    80114b <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801128:	83 ec 08             	sub    $0x8,%esp
  80112b:	ff 75 0c             	pushl  0xc(%ebp)
  80112e:	6a 25                	push   $0x25
  801130:	8b 45 08             	mov    0x8(%ebp),%eax
  801133:	ff d0                	call   *%eax
  801135:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801138:	ff 4d 10             	decl   0x10(%ebp)
  80113b:	eb 03                	jmp    801140 <vprintfmt+0x3b1>
  80113d:	ff 4d 10             	decl   0x10(%ebp)
  801140:	8b 45 10             	mov    0x10(%ebp),%eax
  801143:	48                   	dec    %eax
  801144:	8a 00                	mov    (%eax),%al
  801146:	3c 25                	cmp    $0x25,%al
  801148:	75 f3                	jne    80113d <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80114a:	90                   	nop
		}
	}
  80114b:	e9 47 fc ff ff       	jmp    800d97 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801150:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801151:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801154:	5b                   	pop    %ebx
  801155:	5e                   	pop    %esi
  801156:	5d                   	pop    %ebp
  801157:	c3                   	ret    

00801158 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801158:	55                   	push   %ebp
  801159:	89 e5                	mov    %esp,%ebp
  80115b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80115e:	8d 45 10             	lea    0x10(%ebp),%eax
  801161:	83 c0 04             	add    $0x4,%eax
  801164:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801167:	8b 45 10             	mov    0x10(%ebp),%eax
  80116a:	ff 75 f4             	pushl  -0xc(%ebp)
  80116d:	50                   	push   %eax
  80116e:	ff 75 0c             	pushl  0xc(%ebp)
  801171:	ff 75 08             	pushl  0x8(%ebp)
  801174:	e8 16 fc ff ff       	call   800d8f <vprintfmt>
  801179:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80117c:	90                   	nop
  80117d:	c9                   	leave  
  80117e:	c3                   	ret    

0080117f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80117f:	55                   	push   %ebp
  801180:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801182:	8b 45 0c             	mov    0xc(%ebp),%eax
  801185:	8b 40 08             	mov    0x8(%eax),%eax
  801188:	8d 50 01             	lea    0x1(%eax),%edx
  80118b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801191:	8b 45 0c             	mov    0xc(%ebp),%eax
  801194:	8b 10                	mov    (%eax),%edx
  801196:	8b 45 0c             	mov    0xc(%ebp),%eax
  801199:	8b 40 04             	mov    0x4(%eax),%eax
  80119c:	39 c2                	cmp    %eax,%edx
  80119e:	73 12                	jae    8011b2 <sprintputch+0x33>
		*b->buf++ = ch;
  8011a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a3:	8b 00                	mov    (%eax),%eax
  8011a5:	8d 48 01             	lea    0x1(%eax),%ecx
  8011a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011ab:	89 0a                	mov    %ecx,(%edx)
  8011ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b0:	88 10                	mov    %dl,(%eax)
}
  8011b2:	90                   	nop
  8011b3:	5d                   	pop    %ebp
  8011b4:	c3                   	ret    

008011b5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8011b5:	55                   	push   %ebp
  8011b6:	89 e5                	mov    %esp,%ebp
  8011b8:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8011bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011be:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8011c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ca:	01 d0                	add    %edx,%eax
  8011cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8011d6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011da:	74 06                	je     8011e2 <vsnprintf+0x2d>
  8011dc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011e0:	7f 07                	jg     8011e9 <vsnprintf+0x34>
		return -E_INVAL;
  8011e2:	b8 03 00 00 00       	mov    $0x3,%eax
  8011e7:	eb 20                	jmp    801209 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8011e9:	ff 75 14             	pushl  0x14(%ebp)
  8011ec:	ff 75 10             	pushl  0x10(%ebp)
  8011ef:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8011f2:	50                   	push   %eax
  8011f3:	68 7f 11 80 00       	push   $0x80117f
  8011f8:	e8 92 fb ff ff       	call   800d8f <vprintfmt>
  8011fd:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801200:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801203:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801206:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801209:	c9                   	leave  
  80120a:	c3                   	ret    

0080120b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80120b:	55                   	push   %ebp
  80120c:	89 e5                	mov    %esp,%ebp
  80120e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801211:	8d 45 10             	lea    0x10(%ebp),%eax
  801214:	83 c0 04             	add    $0x4,%eax
  801217:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80121a:	8b 45 10             	mov    0x10(%ebp),%eax
  80121d:	ff 75 f4             	pushl  -0xc(%ebp)
  801220:	50                   	push   %eax
  801221:	ff 75 0c             	pushl  0xc(%ebp)
  801224:	ff 75 08             	pushl  0x8(%ebp)
  801227:	e8 89 ff ff ff       	call   8011b5 <vsnprintf>
  80122c:	83 c4 10             	add    $0x10,%esp
  80122f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801232:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801235:	c9                   	leave  
  801236:	c3                   	ret    

00801237 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  801237:	55                   	push   %ebp
  801238:	89 e5                	mov    %esp,%ebp
  80123a:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  80123d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801241:	74 13                	je     801256 <readline+0x1f>
		cprintf("%s", prompt);
  801243:	83 ec 08             	sub    $0x8,%esp
  801246:	ff 75 08             	pushl  0x8(%ebp)
  801249:	68 90 42 80 00       	push   $0x804290
  80124e:	e8 62 f9 ff ff       	call   800bb5 <cprintf>
  801253:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801256:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  80125d:	83 ec 0c             	sub    $0xc,%esp
  801260:	6a 00                	push   $0x0
  801262:	e8 54 f5 ff ff       	call   8007bb <iscons>
  801267:	83 c4 10             	add    $0x10,%esp
  80126a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  80126d:	e8 fb f4 ff ff       	call   80076d <getchar>
  801272:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801275:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801279:	79 22                	jns    80129d <readline+0x66>
			if (c != -E_EOF)
  80127b:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80127f:	0f 84 ad 00 00 00    	je     801332 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801285:	83 ec 08             	sub    $0x8,%esp
  801288:	ff 75 ec             	pushl  -0x14(%ebp)
  80128b:	68 93 42 80 00       	push   $0x804293
  801290:	e8 20 f9 ff ff       	call   800bb5 <cprintf>
  801295:	83 c4 10             	add    $0x10,%esp
			return;
  801298:	e9 95 00 00 00       	jmp    801332 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80129d:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8012a1:	7e 34                	jle    8012d7 <readline+0xa0>
  8012a3:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8012aa:	7f 2b                	jg     8012d7 <readline+0xa0>
			if (echoing)
  8012ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012b0:	74 0e                	je     8012c0 <readline+0x89>
				cputchar(c);
  8012b2:	83 ec 0c             	sub    $0xc,%esp
  8012b5:	ff 75 ec             	pushl  -0x14(%ebp)
  8012b8:	e8 68 f4 ff ff       	call   800725 <cputchar>
  8012bd:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8012c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012c3:	8d 50 01             	lea    0x1(%eax),%edx
  8012c6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8012c9:	89 c2                	mov    %eax,%edx
  8012cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ce:	01 d0                	add    %edx,%eax
  8012d0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012d3:	88 10                	mov    %dl,(%eax)
  8012d5:	eb 56                	jmp    80132d <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  8012d7:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8012db:	75 1f                	jne    8012fc <readline+0xc5>
  8012dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8012e1:	7e 19                	jle    8012fc <readline+0xc5>
			if (echoing)
  8012e3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012e7:	74 0e                	je     8012f7 <readline+0xc0>
				cputchar(c);
  8012e9:	83 ec 0c             	sub    $0xc,%esp
  8012ec:	ff 75 ec             	pushl  -0x14(%ebp)
  8012ef:	e8 31 f4 ff ff       	call   800725 <cputchar>
  8012f4:	83 c4 10             	add    $0x10,%esp

			i--;
  8012f7:	ff 4d f4             	decl   -0xc(%ebp)
  8012fa:	eb 31                	jmp    80132d <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  8012fc:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801300:	74 0a                	je     80130c <readline+0xd5>
  801302:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801306:	0f 85 61 ff ff ff    	jne    80126d <readline+0x36>
			if (echoing)
  80130c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801310:	74 0e                	je     801320 <readline+0xe9>
				cputchar(c);
  801312:	83 ec 0c             	sub    $0xc,%esp
  801315:	ff 75 ec             	pushl  -0x14(%ebp)
  801318:	e8 08 f4 ff ff       	call   800725 <cputchar>
  80131d:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  801320:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801323:	8b 45 0c             	mov    0xc(%ebp),%eax
  801326:	01 d0                	add    %edx,%eax
  801328:	c6 00 00             	movb   $0x0,(%eax)
			return;
  80132b:	eb 06                	jmp    801333 <readline+0xfc>
		}
	}
  80132d:	e9 3b ff ff ff       	jmp    80126d <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  801332:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  801333:	c9                   	leave  
  801334:	c3                   	ret    

00801335 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  801335:	55                   	push   %ebp
  801336:	89 e5                	mov    %esp,%ebp
  801338:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80133b:	e8 04 0f 00 00       	call   802244 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  801340:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801344:	74 13                	je     801359 <atomic_readline+0x24>
		cprintf("%s", prompt);
  801346:	83 ec 08             	sub    $0x8,%esp
  801349:	ff 75 08             	pushl  0x8(%ebp)
  80134c:	68 90 42 80 00       	push   $0x804290
  801351:	e8 5f f8 ff ff       	call   800bb5 <cprintf>
  801356:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801359:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801360:	83 ec 0c             	sub    $0xc,%esp
  801363:	6a 00                	push   $0x0
  801365:	e8 51 f4 ff ff       	call   8007bb <iscons>
  80136a:	83 c4 10             	add    $0x10,%esp
  80136d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801370:	e8 f8 f3 ff ff       	call   80076d <getchar>
  801375:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801378:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80137c:	79 23                	jns    8013a1 <atomic_readline+0x6c>
			if (c != -E_EOF)
  80137e:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801382:	74 13                	je     801397 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  801384:	83 ec 08             	sub    $0x8,%esp
  801387:	ff 75 ec             	pushl  -0x14(%ebp)
  80138a:	68 93 42 80 00       	push   $0x804293
  80138f:	e8 21 f8 ff ff       	call   800bb5 <cprintf>
  801394:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801397:	e8 c2 0e 00 00       	call   80225e <sys_enable_interrupt>
			return;
  80139c:	e9 9a 00 00 00       	jmp    80143b <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8013a1:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8013a5:	7e 34                	jle    8013db <atomic_readline+0xa6>
  8013a7:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8013ae:	7f 2b                	jg     8013db <atomic_readline+0xa6>
			if (echoing)
  8013b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013b4:	74 0e                	je     8013c4 <atomic_readline+0x8f>
				cputchar(c);
  8013b6:	83 ec 0c             	sub    $0xc,%esp
  8013b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8013bc:	e8 64 f3 ff ff       	call   800725 <cputchar>
  8013c1:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8013c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013c7:	8d 50 01             	lea    0x1(%eax),%edx
  8013ca:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8013cd:	89 c2                	mov    %eax,%edx
  8013cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d2:	01 d0                	add    %edx,%eax
  8013d4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013d7:	88 10                	mov    %dl,(%eax)
  8013d9:	eb 5b                	jmp    801436 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  8013db:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8013df:	75 1f                	jne    801400 <atomic_readline+0xcb>
  8013e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8013e5:	7e 19                	jle    801400 <atomic_readline+0xcb>
			if (echoing)
  8013e7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013eb:	74 0e                	je     8013fb <atomic_readline+0xc6>
				cputchar(c);
  8013ed:	83 ec 0c             	sub    $0xc,%esp
  8013f0:	ff 75 ec             	pushl  -0x14(%ebp)
  8013f3:	e8 2d f3 ff ff       	call   800725 <cputchar>
  8013f8:	83 c4 10             	add    $0x10,%esp
			i--;
  8013fb:	ff 4d f4             	decl   -0xc(%ebp)
  8013fe:	eb 36                	jmp    801436 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  801400:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801404:	74 0a                	je     801410 <atomic_readline+0xdb>
  801406:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80140a:	0f 85 60 ff ff ff    	jne    801370 <atomic_readline+0x3b>
			if (echoing)
  801410:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801414:	74 0e                	je     801424 <atomic_readline+0xef>
				cputchar(c);
  801416:	83 ec 0c             	sub    $0xc,%esp
  801419:	ff 75 ec             	pushl  -0x14(%ebp)
  80141c:	e8 04 f3 ff ff       	call   800725 <cputchar>
  801421:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  801424:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801427:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142a:	01 d0                	add    %edx,%eax
  80142c:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  80142f:	e8 2a 0e 00 00       	call   80225e <sys_enable_interrupt>
			return;
  801434:	eb 05                	jmp    80143b <atomic_readline+0x106>
		}
	}
  801436:	e9 35 ff ff ff       	jmp    801370 <atomic_readline+0x3b>
}
  80143b:	c9                   	leave  
  80143c:	c3                   	ret    

0080143d <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80143d:	55                   	push   %ebp
  80143e:	89 e5                	mov    %esp,%ebp
  801440:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801443:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80144a:	eb 06                	jmp    801452 <strlen+0x15>
		n++;
  80144c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80144f:	ff 45 08             	incl   0x8(%ebp)
  801452:	8b 45 08             	mov    0x8(%ebp),%eax
  801455:	8a 00                	mov    (%eax),%al
  801457:	84 c0                	test   %al,%al
  801459:	75 f1                	jne    80144c <strlen+0xf>
		n++;
	return n;
  80145b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80145e:	c9                   	leave  
  80145f:	c3                   	ret    

00801460 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801460:	55                   	push   %ebp
  801461:	89 e5                	mov    %esp,%ebp
  801463:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801466:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80146d:	eb 09                	jmp    801478 <strnlen+0x18>
		n++;
  80146f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801472:	ff 45 08             	incl   0x8(%ebp)
  801475:	ff 4d 0c             	decl   0xc(%ebp)
  801478:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80147c:	74 09                	je     801487 <strnlen+0x27>
  80147e:	8b 45 08             	mov    0x8(%ebp),%eax
  801481:	8a 00                	mov    (%eax),%al
  801483:	84 c0                	test   %al,%al
  801485:	75 e8                	jne    80146f <strnlen+0xf>
		n++;
	return n;
  801487:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80148a:	c9                   	leave  
  80148b:	c3                   	ret    

0080148c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80148c:	55                   	push   %ebp
  80148d:	89 e5                	mov    %esp,%ebp
  80148f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801492:	8b 45 08             	mov    0x8(%ebp),%eax
  801495:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801498:	90                   	nop
  801499:	8b 45 08             	mov    0x8(%ebp),%eax
  80149c:	8d 50 01             	lea    0x1(%eax),%edx
  80149f:	89 55 08             	mov    %edx,0x8(%ebp)
  8014a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014a5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014a8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014ab:	8a 12                	mov    (%edx),%dl
  8014ad:	88 10                	mov    %dl,(%eax)
  8014af:	8a 00                	mov    (%eax),%al
  8014b1:	84 c0                	test   %al,%al
  8014b3:	75 e4                	jne    801499 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8014b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8014b8:	c9                   	leave  
  8014b9:	c3                   	ret    

008014ba <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8014ba:	55                   	push   %ebp
  8014bb:	89 e5                	mov    %esp,%ebp
  8014bd:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8014c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8014c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014cd:	eb 1f                	jmp    8014ee <strncpy+0x34>
		*dst++ = *src;
  8014cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d2:	8d 50 01             	lea    0x1(%eax),%edx
  8014d5:	89 55 08             	mov    %edx,0x8(%ebp)
  8014d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014db:	8a 12                	mov    (%edx),%dl
  8014dd:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8014df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e2:	8a 00                	mov    (%eax),%al
  8014e4:	84 c0                	test   %al,%al
  8014e6:	74 03                	je     8014eb <strncpy+0x31>
			src++;
  8014e8:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8014eb:	ff 45 fc             	incl   -0x4(%ebp)
  8014ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014f1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014f4:	72 d9                	jb     8014cf <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8014f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014f9:	c9                   	leave  
  8014fa:	c3                   	ret    

008014fb <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8014fb:	55                   	push   %ebp
  8014fc:	89 e5                	mov    %esp,%ebp
  8014fe:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801501:	8b 45 08             	mov    0x8(%ebp),%eax
  801504:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801507:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80150b:	74 30                	je     80153d <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80150d:	eb 16                	jmp    801525 <strlcpy+0x2a>
			*dst++ = *src++;
  80150f:	8b 45 08             	mov    0x8(%ebp),%eax
  801512:	8d 50 01             	lea    0x1(%eax),%edx
  801515:	89 55 08             	mov    %edx,0x8(%ebp)
  801518:	8b 55 0c             	mov    0xc(%ebp),%edx
  80151b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80151e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801521:	8a 12                	mov    (%edx),%dl
  801523:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801525:	ff 4d 10             	decl   0x10(%ebp)
  801528:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80152c:	74 09                	je     801537 <strlcpy+0x3c>
  80152e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801531:	8a 00                	mov    (%eax),%al
  801533:	84 c0                	test   %al,%al
  801535:	75 d8                	jne    80150f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801537:	8b 45 08             	mov    0x8(%ebp),%eax
  80153a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80153d:	8b 55 08             	mov    0x8(%ebp),%edx
  801540:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801543:	29 c2                	sub    %eax,%edx
  801545:	89 d0                	mov    %edx,%eax
}
  801547:	c9                   	leave  
  801548:	c3                   	ret    

00801549 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801549:	55                   	push   %ebp
  80154a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80154c:	eb 06                	jmp    801554 <strcmp+0xb>
		p++, q++;
  80154e:	ff 45 08             	incl   0x8(%ebp)
  801551:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801554:	8b 45 08             	mov    0x8(%ebp),%eax
  801557:	8a 00                	mov    (%eax),%al
  801559:	84 c0                	test   %al,%al
  80155b:	74 0e                	je     80156b <strcmp+0x22>
  80155d:	8b 45 08             	mov    0x8(%ebp),%eax
  801560:	8a 10                	mov    (%eax),%dl
  801562:	8b 45 0c             	mov    0xc(%ebp),%eax
  801565:	8a 00                	mov    (%eax),%al
  801567:	38 c2                	cmp    %al,%dl
  801569:	74 e3                	je     80154e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80156b:	8b 45 08             	mov    0x8(%ebp),%eax
  80156e:	8a 00                	mov    (%eax),%al
  801570:	0f b6 d0             	movzbl %al,%edx
  801573:	8b 45 0c             	mov    0xc(%ebp),%eax
  801576:	8a 00                	mov    (%eax),%al
  801578:	0f b6 c0             	movzbl %al,%eax
  80157b:	29 c2                	sub    %eax,%edx
  80157d:	89 d0                	mov    %edx,%eax
}
  80157f:	5d                   	pop    %ebp
  801580:	c3                   	ret    

00801581 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801581:	55                   	push   %ebp
  801582:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801584:	eb 09                	jmp    80158f <strncmp+0xe>
		n--, p++, q++;
  801586:	ff 4d 10             	decl   0x10(%ebp)
  801589:	ff 45 08             	incl   0x8(%ebp)
  80158c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80158f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801593:	74 17                	je     8015ac <strncmp+0x2b>
  801595:	8b 45 08             	mov    0x8(%ebp),%eax
  801598:	8a 00                	mov    (%eax),%al
  80159a:	84 c0                	test   %al,%al
  80159c:	74 0e                	je     8015ac <strncmp+0x2b>
  80159e:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a1:	8a 10                	mov    (%eax),%dl
  8015a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a6:	8a 00                	mov    (%eax),%al
  8015a8:	38 c2                	cmp    %al,%dl
  8015aa:	74 da                	je     801586 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8015ac:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015b0:	75 07                	jne    8015b9 <strncmp+0x38>
		return 0;
  8015b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8015b7:	eb 14                	jmp    8015cd <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8015b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bc:	8a 00                	mov    (%eax),%al
  8015be:	0f b6 d0             	movzbl %al,%edx
  8015c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c4:	8a 00                	mov    (%eax),%al
  8015c6:	0f b6 c0             	movzbl %al,%eax
  8015c9:	29 c2                	sub    %eax,%edx
  8015cb:	89 d0                	mov    %edx,%eax
}
  8015cd:	5d                   	pop    %ebp
  8015ce:	c3                   	ret    

008015cf <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8015cf:	55                   	push   %ebp
  8015d0:	89 e5                	mov    %esp,%ebp
  8015d2:	83 ec 04             	sub    $0x4,%esp
  8015d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015db:	eb 12                	jmp    8015ef <strchr+0x20>
		if (*s == c)
  8015dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e0:	8a 00                	mov    (%eax),%al
  8015e2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015e5:	75 05                	jne    8015ec <strchr+0x1d>
			return (char *) s;
  8015e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ea:	eb 11                	jmp    8015fd <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8015ec:	ff 45 08             	incl   0x8(%ebp)
  8015ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f2:	8a 00                	mov    (%eax),%al
  8015f4:	84 c0                	test   %al,%al
  8015f6:	75 e5                	jne    8015dd <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8015f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015fd:	c9                   	leave  
  8015fe:	c3                   	ret    

008015ff <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8015ff:	55                   	push   %ebp
  801600:	89 e5                	mov    %esp,%ebp
  801602:	83 ec 04             	sub    $0x4,%esp
  801605:	8b 45 0c             	mov    0xc(%ebp),%eax
  801608:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80160b:	eb 0d                	jmp    80161a <strfind+0x1b>
		if (*s == c)
  80160d:	8b 45 08             	mov    0x8(%ebp),%eax
  801610:	8a 00                	mov    (%eax),%al
  801612:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801615:	74 0e                	je     801625 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801617:	ff 45 08             	incl   0x8(%ebp)
  80161a:	8b 45 08             	mov    0x8(%ebp),%eax
  80161d:	8a 00                	mov    (%eax),%al
  80161f:	84 c0                	test   %al,%al
  801621:	75 ea                	jne    80160d <strfind+0xe>
  801623:	eb 01                	jmp    801626 <strfind+0x27>
		if (*s == c)
			break;
  801625:	90                   	nop
	return (char *) s;
  801626:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801629:	c9                   	leave  
  80162a:	c3                   	ret    

0080162b <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80162b:	55                   	push   %ebp
  80162c:	89 e5                	mov    %esp,%ebp
  80162e:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801631:	8b 45 08             	mov    0x8(%ebp),%eax
  801634:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801637:	8b 45 10             	mov    0x10(%ebp),%eax
  80163a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80163d:	eb 0e                	jmp    80164d <memset+0x22>
		*p++ = c;
  80163f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801642:	8d 50 01             	lea    0x1(%eax),%edx
  801645:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801648:	8b 55 0c             	mov    0xc(%ebp),%edx
  80164b:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80164d:	ff 4d f8             	decl   -0x8(%ebp)
  801650:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801654:	79 e9                	jns    80163f <memset+0x14>
		*p++ = c;

	return v;
  801656:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801659:	c9                   	leave  
  80165a:	c3                   	ret    

0080165b <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80165b:	55                   	push   %ebp
  80165c:	89 e5                	mov    %esp,%ebp
  80165e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801661:	8b 45 0c             	mov    0xc(%ebp),%eax
  801664:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801667:	8b 45 08             	mov    0x8(%ebp),%eax
  80166a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80166d:	eb 16                	jmp    801685 <memcpy+0x2a>
		*d++ = *s++;
  80166f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801672:	8d 50 01             	lea    0x1(%eax),%edx
  801675:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801678:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80167b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80167e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801681:	8a 12                	mov    (%edx),%dl
  801683:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801685:	8b 45 10             	mov    0x10(%ebp),%eax
  801688:	8d 50 ff             	lea    -0x1(%eax),%edx
  80168b:	89 55 10             	mov    %edx,0x10(%ebp)
  80168e:	85 c0                	test   %eax,%eax
  801690:	75 dd                	jne    80166f <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801692:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801695:	c9                   	leave  
  801696:	c3                   	ret    

00801697 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801697:	55                   	push   %ebp
  801698:	89 e5                	mov    %esp,%ebp
  80169a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80169d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8016a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8016a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016ac:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8016af:	73 50                	jae    801701 <memmove+0x6a>
  8016b1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b7:	01 d0                	add    %edx,%eax
  8016b9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8016bc:	76 43                	jbe    801701 <memmove+0x6a>
		s += n;
  8016be:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c1:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8016c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c7:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8016ca:	eb 10                	jmp    8016dc <memmove+0x45>
			*--d = *--s;
  8016cc:	ff 4d f8             	decl   -0x8(%ebp)
  8016cf:	ff 4d fc             	decl   -0x4(%ebp)
  8016d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016d5:	8a 10                	mov    (%eax),%dl
  8016d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016da:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8016dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8016df:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016e2:	89 55 10             	mov    %edx,0x10(%ebp)
  8016e5:	85 c0                	test   %eax,%eax
  8016e7:	75 e3                	jne    8016cc <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8016e9:	eb 23                	jmp    80170e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8016eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016ee:	8d 50 01             	lea    0x1(%eax),%edx
  8016f1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016f4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016f7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016fa:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8016fd:	8a 12                	mov    (%edx),%dl
  8016ff:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801701:	8b 45 10             	mov    0x10(%ebp),%eax
  801704:	8d 50 ff             	lea    -0x1(%eax),%edx
  801707:	89 55 10             	mov    %edx,0x10(%ebp)
  80170a:	85 c0                	test   %eax,%eax
  80170c:	75 dd                	jne    8016eb <memmove+0x54>
			*d++ = *s++;

	return dst;
  80170e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801711:	c9                   	leave  
  801712:	c3                   	ret    

00801713 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801713:	55                   	push   %ebp
  801714:	89 e5                	mov    %esp,%ebp
  801716:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801719:	8b 45 08             	mov    0x8(%ebp),%eax
  80171c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80171f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801722:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801725:	eb 2a                	jmp    801751 <memcmp+0x3e>
		if (*s1 != *s2)
  801727:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80172a:	8a 10                	mov    (%eax),%dl
  80172c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80172f:	8a 00                	mov    (%eax),%al
  801731:	38 c2                	cmp    %al,%dl
  801733:	74 16                	je     80174b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801735:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801738:	8a 00                	mov    (%eax),%al
  80173a:	0f b6 d0             	movzbl %al,%edx
  80173d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801740:	8a 00                	mov    (%eax),%al
  801742:	0f b6 c0             	movzbl %al,%eax
  801745:	29 c2                	sub    %eax,%edx
  801747:	89 d0                	mov    %edx,%eax
  801749:	eb 18                	jmp    801763 <memcmp+0x50>
		s1++, s2++;
  80174b:	ff 45 fc             	incl   -0x4(%ebp)
  80174e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801751:	8b 45 10             	mov    0x10(%ebp),%eax
  801754:	8d 50 ff             	lea    -0x1(%eax),%edx
  801757:	89 55 10             	mov    %edx,0x10(%ebp)
  80175a:	85 c0                	test   %eax,%eax
  80175c:	75 c9                	jne    801727 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80175e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801763:	c9                   	leave  
  801764:	c3                   	ret    

00801765 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801765:	55                   	push   %ebp
  801766:	89 e5                	mov    %esp,%ebp
  801768:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80176b:	8b 55 08             	mov    0x8(%ebp),%edx
  80176e:	8b 45 10             	mov    0x10(%ebp),%eax
  801771:	01 d0                	add    %edx,%eax
  801773:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801776:	eb 15                	jmp    80178d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801778:	8b 45 08             	mov    0x8(%ebp),%eax
  80177b:	8a 00                	mov    (%eax),%al
  80177d:	0f b6 d0             	movzbl %al,%edx
  801780:	8b 45 0c             	mov    0xc(%ebp),%eax
  801783:	0f b6 c0             	movzbl %al,%eax
  801786:	39 c2                	cmp    %eax,%edx
  801788:	74 0d                	je     801797 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80178a:	ff 45 08             	incl   0x8(%ebp)
  80178d:	8b 45 08             	mov    0x8(%ebp),%eax
  801790:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801793:	72 e3                	jb     801778 <memfind+0x13>
  801795:	eb 01                	jmp    801798 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801797:	90                   	nop
	return (void *) s;
  801798:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80179b:	c9                   	leave  
  80179c:	c3                   	ret    

0080179d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80179d:	55                   	push   %ebp
  80179e:	89 e5                	mov    %esp,%ebp
  8017a0:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8017a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8017aa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017b1:	eb 03                	jmp    8017b6 <strtol+0x19>
		s++;
  8017b3:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b9:	8a 00                	mov    (%eax),%al
  8017bb:	3c 20                	cmp    $0x20,%al
  8017bd:	74 f4                	je     8017b3 <strtol+0x16>
  8017bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c2:	8a 00                	mov    (%eax),%al
  8017c4:	3c 09                	cmp    $0x9,%al
  8017c6:	74 eb                	je     8017b3 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8017c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cb:	8a 00                	mov    (%eax),%al
  8017cd:	3c 2b                	cmp    $0x2b,%al
  8017cf:	75 05                	jne    8017d6 <strtol+0x39>
		s++;
  8017d1:	ff 45 08             	incl   0x8(%ebp)
  8017d4:	eb 13                	jmp    8017e9 <strtol+0x4c>
	else if (*s == '-')
  8017d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d9:	8a 00                	mov    (%eax),%al
  8017db:	3c 2d                	cmp    $0x2d,%al
  8017dd:	75 0a                	jne    8017e9 <strtol+0x4c>
		s++, neg = 1;
  8017df:	ff 45 08             	incl   0x8(%ebp)
  8017e2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017e9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017ed:	74 06                	je     8017f5 <strtol+0x58>
  8017ef:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8017f3:	75 20                	jne    801815 <strtol+0x78>
  8017f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f8:	8a 00                	mov    (%eax),%al
  8017fa:	3c 30                	cmp    $0x30,%al
  8017fc:	75 17                	jne    801815 <strtol+0x78>
  8017fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801801:	40                   	inc    %eax
  801802:	8a 00                	mov    (%eax),%al
  801804:	3c 78                	cmp    $0x78,%al
  801806:	75 0d                	jne    801815 <strtol+0x78>
		s += 2, base = 16;
  801808:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80180c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801813:	eb 28                	jmp    80183d <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801815:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801819:	75 15                	jne    801830 <strtol+0x93>
  80181b:	8b 45 08             	mov    0x8(%ebp),%eax
  80181e:	8a 00                	mov    (%eax),%al
  801820:	3c 30                	cmp    $0x30,%al
  801822:	75 0c                	jne    801830 <strtol+0x93>
		s++, base = 8;
  801824:	ff 45 08             	incl   0x8(%ebp)
  801827:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80182e:	eb 0d                	jmp    80183d <strtol+0xa0>
	else if (base == 0)
  801830:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801834:	75 07                	jne    80183d <strtol+0xa0>
		base = 10;
  801836:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80183d:	8b 45 08             	mov    0x8(%ebp),%eax
  801840:	8a 00                	mov    (%eax),%al
  801842:	3c 2f                	cmp    $0x2f,%al
  801844:	7e 19                	jle    80185f <strtol+0xc2>
  801846:	8b 45 08             	mov    0x8(%ebp),%eax
  801849:	8a 00                	mov    (%eax),%al
  80184b:	3c 39                	cmp    $0x39,%al
  80184d:	7f 10                	jg     80185f <strtol+0xc2>
			dig = *s - '0';
  80184f:	8b 45 08             	mov    0x8(%ebp),%eax
  801852:	8a 00                	mov    (%eax),%al
  801854:	0f be c0             	movsbl %al,%eax
  801857:	83 e8 30             	sub    $0x30,%eax
  80185a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80185d:	eb 42                	jmp    8018a1 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80185f:	8b 45 08             	mov    0x8(%ebp),%eax
  801862:	8a 00                	mov    (%eax),%al
  801864:	3c 60                	cmp    $0x60,%al
  801866:	7e 19                	jle    801881 <strtol+0xe4>
  801868:	8b 45 08             	mov    0x8(%ebp),%eax
  80186b:	8a 00                	mov    (%eax),%al
  80186d:	3c 7a                	cmp    $0x7a,%al
  80186f:	7f 10                	jg     801881 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801871:	8b 45 08             	mov    0x8(%ebp),%eax
  801874:	8a 00                	mov    (%eax),%al
  801876:	0f be c0             	movsbl %al,%eax
  801879:	83 e8 57             	sub    $0x57,%eax
  80187c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80187f:	eb 20                	jmp    8018a1 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801881:	8b 45 08             	mov    0x8(%ebp),%eax
  801884:	8a 00                	mov    (%eax),%al
  801886:	3c 40                	cmp    $0x40,%al
  801888:	7e 39                	jle    8018c3 <strtol+0x126>
  80188a:	8b 45 08             	mov    0x8(%ebp),%eax
  80188d:	8a 00                	mov    (%eax),%al
  80188f:	3c 5a                	cmp    $0x5a,%al
  801891:	7f 30                	jg     8018c3 <strtol+0x126>
			dig = *s - 'A' + 10;
  801893:	8b 45 08             	mov    0x8(%ebp),%eax
  801896:	8a 00                	mov    (%eax),%al
  801898:	0f be c0             	movsbl %al,%eax
  80189b:	83 e8 37             	sub    $0x37,%eax
  80189e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8018a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a4:	3b 45 10             	cmp    0x10(%ebp),%eax
  8018a7:	7d 19                	jge    8018c2 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8018a9:	ff 45 08             	incl   0x8(%ebp)
  8018ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018af:	0f af 45 10          	imul   0x10(%ebp),%eax
  8018b3:	89 c2                	mov    %eax,%edx
  8018b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018b8:	01 d0                	add    %edx,%eax
  8018ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8018bd:	e9 7b ff ff ff       	jmp    80183d <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8018c2:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8018c3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018c7:	74 08                	je     8018d1 <strtol+0x134>
		*endptr = (char *) s;
  8018c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8018cf:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8018d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018d5:	74 07                	je     8018de <strtol+0x141>
  8018d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018da:	f7 d8                	neg    %eax
  8018dc:	eb 03                	jmp    8018e1 <strtol+0x144>
  8018de:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8018e1:	c9                   	leave  
  8018e2:	c3                   	ret    

008018e3 <ltostr>:

void
ltostr(long value, char *str)
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
  8018e6:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8018e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8018f0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8018f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018fb:	79 13                	jns    801910 <ltostr+0x2d>
	{
		neg = 1;
  8018fd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801904:	8b 45 0c             	mov    0xc(%ebp),%eax
  801907:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80190a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80190d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801910:	8b 45 08             	mov    0x8(%ebp),%eax
  801913:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801918:	99                   	cltd   
  801919:	f7 f9                	idiv   %ecx
  80191b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80191e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801921:	8d 50 01             	lea    0x1(%eax),%edx
  801924:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801927:	89 c2                	mov    %eax,%edx
  801929:	8b 45 0c             	mov    0xc(%ebp),%eax
  80192c:	01 d0                	add    %edx,%eax
  80192e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801931:	83 c2 30             	add    $0x30,%edx
  801934:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801936:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801939:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80193e:	f7 e9                	imul   %ecx
  801940:	c1 fa 02             	sar    $0x2,%edx
  801943:	89 c8                	mov    %ecx,%eax
  801945:	c1 f8 1f             	sar    $0x1f,%eax
  801948:	29 c2                	sub    %eax,%edx
  80194a:	89 d0                	mov    %edx,%eax
  80194c:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80194f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801952:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801957:	f7 e9                	imul   %ecx
  801959:	c1 fa 02             	sar    $0x2,%edx
  80195c:	89 c8                	mov    %ecx,%eax
  80195e:	c1 f8 1f             	sar    $0x1f,%eax
  801961:	29 c2                	sub    %eax,%edx
  801963:	89 d0                	mov    %edx,%eax
  801965:	c1 e0 02             	shl    $0x2,%eax
  801968:	01 d0                	add    %edx,%eax
  80196a:	01 c0                	add    %eax,%eax
  80196c:	29 c1                	sub    %eax,%ecx
  80196e:	89 ca                	mov    %ecx,%edx
  801970:	85 d2                	test   %edx,%edx
  801972:	75 9c                	jne    801910 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801974:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80197b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80197e:	48                   	dec    %eax
  80197f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801982:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801986:	74 3d                	je     8019c5 <ltostr+0xe2>
		start = 1 ;
  801988:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80198f:	eb 34                	jmp    8019c5 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801991:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801994:	8b 45 0c             	mov    0xc(%ebp),%eax
  801997:	01 d0                	add    %edx,%eax
  801999:	8a 00                	mov    (%eax),%al
  80199b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80199e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a4:	01 c2                	add    %eax,%edx
  8019a6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8019a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ac:	01 c8                	add    %ecx,%eax
  8019ae:	8a 00                	mov    (%eax),%al
  8019b0:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8019b2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019b8:	01 c2                	add    %eax,%edx
  8019ba:	8a 45 eb             	mov    -0x15(%ebp),%al
  8019bd:	88 02                	mov    %al,(%edx)
		start++ ;
  8019bf:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8019c2:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8019c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019cb:	7c c4                	jl     801991 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8019cd:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8019d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019d3:	01 d0                	add    %edx,%eax
  8019d5:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8019d8:	90                   	nop
  8019d9:	c9                   	leave  
  8019da:	c3                   	ret    

008019db <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
  8019de:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8019e1:	ff 75 08             	pushl  0x8(%ebp)
  8019e4:	e8 54 fa ff ff       	call   80143d <strlen>
  8019e9:	83 c4 04             	add    $0x4,%esp
  8019ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8019ef:	ff 75 0c             	pushl  0xc(%ebp)
  8019f2:	e8 46 fa ff ff       	call   80143d <strlen>
  8019f7:	83 c4 04             	add    $0x4,%esp
  8019fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8019fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801a04:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801a0b:	eb 17                	jmp    801a24 <strcconcat+0x49>
		final[s] = str1[s] ;
  801a0d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a10:	8b 45 10             	mov    0x10(%ebp),%eax
  801a13:	01 c2                	add    %eax,%edx
  801a15:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801a18:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1b:	01 c8                	add    %ecx,%eax
  801a1d:	8a 00                	mov    (%eax),%al
  801a1f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801a21:	ff 45 fc             	incl   -0x4(%ebp)
  801a24:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a27:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801a2a:	7c e1                	jl     801a0d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801a2c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801a33:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801a3a:	eb 1f                	jmp    801a5b <strcconcat+0x80>
		final[s++] = str2[i] ;
  801a3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a3f:	8d 50 01             	lea    0x1(%eax),%edx
  801a42:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801a45:	89 c2                	mov    %eax,%edx
  801a47:	8b 45 10             	mov    0x10(%ebp),%eax
  801a4a:	01 c2                	add    %eax,%edx
  801a4c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801a4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a52:	01 c8                	add    %ecx,%eax
  801a54:	8a 00                	mov    (%eax),%al
  801a56:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801a58:	ff 45 f8             	incl   -0x8(%ebp)
  801a5b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a5e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a61:	7c d9                	jl     801a3c <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801a63:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a66:	8b 45 10             	mov    0x10(%ebp),%eax
  801a69:	01 d0                	add    %edx,%eax
  801a6b:	c6 00 00             	movb   $0x0,(%eax)
}
  801a6e:	90                   	nop
  801a6f:	c9                   	leave  
  801a70:	c3                   	ret    

00801a71 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a74:	8b 45 14             	mov    0x14(%ebp),%eax
  801a77:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a7d:	8b 45 14             	mov    0x14(%ebp),%eax
  801a80:	8b 00                	mov    (%eax),%eax
  801a82:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a89:	8b 45 10             	mov    0x10(%ebp),%eax
  801a8c:	01 d0                	add    %edx,%eax
  801a8e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a94:	eb 0c                	jmp    801aa2 <strsplit+0x31>
			*string++ = 0;
  801a96:	8b 45 08             	mov    0x8(%ebp),%eax
  801a99:	8d 50 01             	lea    0x1(%eax),%edx
  801a9c:	89 55 08             	mov    %edx,0x8(%ebp)
  801a9f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa5:	8a 00                	mov    (%eax),%al
  801aa7:	84 c0                	test   %al,%al
  801aa9:	74 18                	je     801ac3 <strsplit+0x52>
  801aab:	8b 45 08             	mov    0x8(%ebp),%eax
  801aae:	8a 00                	mov    (%eax),%al
  801ab0:	0f be c0             	movsbl %al,%eax
  801ab3:	50                   	push   %eax
  801ab4:	ff 75 0c             	pushl  0xc(%ebp)
  801ab7:	e8 13 fb ff ff       	call   8015cf <strchr>
  801abc:	83 c4 08             	add    $0x8,%esp
  801abf:	85 c0                	test   %eax,%eax
  801ac1:	75 d3                	jne    801a96 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac6:	8a 00                	mov    (%eax),%al
  801ac8:	84 c0                	test   %al,%al
  801aca:	74 5a                	je     801b26 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801acc:	8b 45 14             	mov    0x14(%ebp),%eax
  801acf:	8b 00                	mov    (%eax),%eax
  801ad1:	83 f8 0f             	cmp    $0xf,%eax
  801ad4:	75 07                	jne    801add <strsplit+0x6c>
		{
			return 0;
  801ad6:	b8 00 00 00 00       	mov    $0x0,%eax
  801adb:	eb 66                	jmp    801b43 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801add:	8b 45 14             	mov    0x14(%ebp),%eax
  801ae0:	8b 00                	mov    (%eax),%eax
  801ae2:	8d 48 01             	lea    0x1(%eax),%ecx
  801ae5:	8b 55 14             	mov    0x14(%ebp),%edx
  801ae8:	89 0a                	mov    %ecx,(%edx)
  801aea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801af1:	8b 45 10             	mov    0x10(%ebp),%eax
  801af4:	01 c2                	add    %eax,%edx
  801af6:	8b 45 08             	mov    0x8(%ebp),%eax
  801af9:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801afb:	eb 03                	jmp    801b00 <strsplit+0x8f>
			string++;
  801afd:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801b00:	8b 45 08             	mov    0x8(%ebp),%eax
  801b03:	8a 00                	mov    (%eax),%al
  801b05:	84 c0                	test   %al,%al
  801b07:	74 8b                	je     801a94 <strsplit+0x23>
  801b09:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0c:	8a 00                	mov    (%eax),%al
  801b0e:	0f be c0             	movsbl %al,%eax
  801b11:	50                   	push   %eax
  801b12:	ff 75 0c             	pushl  0xc(%ebp)
  801b15:	e8 b5 fa ff ff       	call   8015cf <strchr>
  801b1a:	83 c4 08             	add    $0x8,%esp
  801b1d:	85 c0                	test   %eax,%eax
  801b1f:	74 dc                	je     801afd <strsplit+0x8c>
			string++;
	}
  801b21:	e9 6e ff ff ff       	jmp    801a94 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801b26:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801b27:	8b 45 14             	mov    0x14(%ebp),%eax
  801b2a:	8b 00                	mov    (%eax),%eax
  801b2c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b33:	8b 45 10             	mov    0x10(%ebp),%eax
  801b36:	01 d0                	add    %edx,%eax
  801b38:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801b3e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801b43:	c9                   	leave  
  801b44:	c3                   	ret    

00801b45 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801b45:	55                   	push   %ebp
  801b46:	89 e5                	mov    %esp,%ebp
  801b48:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801b4b:	a1 04 50 80 00       	mov    0x805004,%eax
  801b50:	85 c0                	test   %eax,%eax
  801b52:	74 1f                	je     801b73 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801b54:	e8 1d 00 00 00       	call   801b76 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801b59:	83 ec 0c             	sub    $0xc,%esp
  801b5c:	68 a4 42 80 00       	push   $0x8042a4
  801b61:	e8 4f f0 ff ff       	call   800bb5 <cprintf>
  801b66:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801b69:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801b70:	00 00 00 
	}
}
  801b73:	90                   	nop
  801b74:	c9                   	leave  
  801b75:	c3                   	ret    

00801b76 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801b76:	55                   	push   %ebp
  801b77:	89 e5                	mov    %esp,%ebp
  801b79:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801b7c:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801b83:	00 00 00 
  801b86:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801b8d:	00 00 00 
  801b90:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801b97:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  801b9a:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801ba1:	00 00 00 
  801ba4:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801bab:	00 00 00 
  801bae:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801bb5:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801bb8:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801bbf:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801bc2:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bcc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bd1:	2d 00 10 00 00       	sub    $0x1000,%eax
  801bd6:	a3 50 50 80 00       	mov    %eax,0x805050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  801bdb:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801be2:	a1 20 51 80 00       	mov    0x805120,%eax
  801be7:	c1 e0 04             	shl    $0x4,%eax
  801bea:	89 c2                	mov    %eax,%edx
  801bec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bef:	01 d0                	add    %edx,%eax
  801bf1:	48                   	dec    %eax
  801bf2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801bf5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bf8:	ba 00 00 00 00       	mov    $0x0,%edx
  801bfd:	f7 75 f0             	divl   -0x10(%ebp)
  801c00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c03:	29 d0                	sub    %edx,%eax
  801c05:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  801c08:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801c0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c12:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c17:	2d 00 10 00 00       	sub    $0x1000,%eax
  801c1c:	83 ec 04             	sub    $0x4,%esp
  801c1f:	6a 06                	push   $0x6
  801c21:	ff 75 e8             	pushl  -0x18(%ebp)
  801c24:	50                   	push   %eax
  801c25:	e8 b0 05 00 00       	call   8021da <sys_allocate_chunk>
  801c2a:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801c2d:	a1 20 51 80 00       	mov    0x805120,%eax
  801c32:	83 ec 0c             	sub    $0xc,%esp
  801c35:	50                   	push   %eax
  801c36:	e8 25 0c 00 00       	call   802860 <initialize_MemBlocksList>
  801c3b:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  801c3e:	a1 48 51 80 00       	mov    0x805148,%eax
  801c43:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  801c46:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c4a:	75 14                	jne    801c60 <initialize_dyn_block_system+0xea>
  801c4c:	83 ec 04             	sub    $0x4,%esp
  801c4f:	68 c9 42 80 00       	push   $0x8042c9
  801c54:	6a 29                	push   $0x29
  801c56:	68 e7 42 80 00       	push   $0x8042e7
  801c5b:	e8 a1 ec ff ff       	call   800901 <_panic>
  801c60:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c63:	8b 00                	mov    (%eax),%eax
  801c65:	85 c0                	test   %eax,%eax
  801c67:	74 10                	je     801c79 <initialize_dyn_block_system+0x103>
  801c69:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c6c:	8b 00                	mov    (%eax),%eax
  801c6e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c71:	8b 52 04             	mov    0x4(%edx),%edx
  801c74:	89 50 04             	mov    %edx,0x4(%eax)
  801c77:	eb 0b                	jmp    801c84 <initialize_dyn_block_system+0x10e>
  801c79:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c7c:	8b 40 04             	mov    0x4(%eax),%eax
  801c7f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801c84:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c87:	8b 40 04             	mov    0x4(%eax),%eax
  801c8a:	85 c0                	test   %eax,%eax
  801c8c:	74 0f                	je     801c9d <initialize_dyn_block_system+0x127>
  801c8e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c91:	8b 40 04             	mov    0x4(%eax),%eax
  801c94:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c97:	8b 12                	mov    (%edx),%edx
  801c99:	89 10                	mov    %edx,(%eax)
  801c9b:	eb 0a                	jmp    801ca7 <initialize_dyn_block_system+0x131>
  801c9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ca0:	8b 00                	mov    (%eax),%eax
  801ca2:	a3 48 51 80 00       	mov    %eax,0x805148
  801ca7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801caa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801cb0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cb3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801cba:	a1 54 51 80 00       	mov    0x805154,%eax
  801cbf:	48                   	dec    %eax
  801cc0:	a3 54 51 80 00       	mov    %eax,0x805154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  801cc5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cc8:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  801ccf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cd2:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  801cd9:	83 ec 0c             	sub    $0xc,%esp
  801cdc:	ff 75 e0             	pushl  -0x20(%ebp)
  801cdf:	e8 b9 14 00 00       	call   80319d <insert_sorted_with_merge_freeList>
  801ce4:	83 c4 10             	add    $0x10,%esp

}
  801ce7:	90                   	nop
  801ce8:	c9                   	leave  
  801ce9:	c3                   	ret    

00801cea <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801cea:	55                   	push   %ebp
  801ceb:	89 e5                	mov    %esp,%ebp
  801ced:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801cf0:	e8 50 fe ff ff       	call   801b45 <InitializeUHeap>
	if (size == 0) return NULL ;
  801cf5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801cf9:	75 07                	jne    801d02 <malloc+0x18>
  801cfb:	b8 00 00 00 00       	mov    $0x0,%eax
  801d00:	eb 68                	jmp    801d6a <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  801d02:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801d09:	8b 55 08             	mov    0x8(%ebp),%edx
  801d0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d0f:	01 d0                	add    %edx,%eax
  801d11:	48                   	dec    %eax
  801d12:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d18:	ba 00 00 00 00       	mov    $0x0,%edx
  801d1d:	f7 75 f4             	divl   -0xc(%ebp)
  801d20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d23:	29 d0                	sub    %edx,%eax
  801d25:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  801d28:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801d2f:	e8 74 08 00 00       	call   8025a8 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d34:	85 c0                	test   %eax,%eax
  801d36:	74 2d                	je     801d65 <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  801d38:	83 ec 0c             	sub    $0xc,%esp
  801d3b:	ff 75 ec             	pushl  -0x14(%ebp)
  801d3e:	e8 52 0e 00 00       	call   802b95 <alloc_block_FF>
  801d43:	83 c4 10             	add    $0x10,%esp
  801d46:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  801d49:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801d4d:	74 16                	je     801d65 <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  801d4f:	83 ec 0c             	sub    $0xc,%esp
  801d52:	ff 75 e8             	pushl  -0x18(%ebp)
  801d55:	e8 3b 0c 00 00       	call   802995 <insert_sorted_allocList>
  801d5a:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  801d5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d60:	8b 40 08             	mov    0x8(%eax),%eax
  801d63:	eb 05                	jmp    801d6a <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  801d65:	b8 00 00 00 00       	mov    $0x0,%eax

}
  801d6a:	c9                   	leave  
  801d6b:	c3                   	ret    

00801d6c <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801d6c:	55                   	push   %ebp
  801d6d:	89 e5                	mov    %esp,%ebp
  801d6f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  801d72:	8b 45 08             	mov    0x8(%ebp),%eax
  801d75:	83 ec 08             	sub    $0x8,%esp
  801d78:	50                   	push   %eax
  801d79:	68 40 50 80 00       	push   $0x805040
  801d7e:	e8 ba 0b 00 00       	call   80293d <find_block>
  801d83:	83 c4 10             	add    $0x10,%esp
  801d86:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  801d89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d8c:	8b 40 0c             	mov    0xc(%eax),%eax
  801d8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  801d92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d96:	0f 84 9f 00 00 00    	je     801e3b <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  801d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9f:	83 ec 08             	sub    $0x8,%esp
  801da2:	ff 75 f0             	pushl  -0x10(%ebp)
  801da5:	50                   	push   %eax
  801da6:	e8 f7 03 00 00       	call   8021a2 <sys_free_user_mem>
  801dab:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  801dae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801db2:	75 14                	jne    801dc8 <free+0x5c>
  801db4:	83 ec 04             	sub    $0x4,%esp
  801db7:	68 c9 42 80 00       	push   $0x8042c9
  801dbc:	6a 6a                	push   $0x6a
  801dbe:	68 e7 42 80 00       	push   $0x8042e7
  801dc3:	e8 39 eb ff ff       	call   800901 <_panic>
  801dc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dcb:	8b 00                	mov    (%eax),%eax
  801dcd:	85 c0                	test   %eax,%eax
  801dcf:	74 10                	je     801de1 <free+0x75>
  801dd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd4:	8b 00                	mov    (%eax),%eax
  801dd6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dd9:	8b 52 04             	mov    0x4(%edx),%edx
  801ddc:	89 50 04             	mov    %edx,0x4(%eax)
  801ddf:	eb 0b                	jmp    801dec <free+0x80>
  801de1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de4:	8b 40 04             	mov    0x4(%eax),%eax
  801de7:	a3 44 50 80 00       	mov    %eax,0x805044
  801dec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801def:	8b 40 04             	mov    0x4(%eax),%eax
  801df2:	85 c0                	test   %eax,%eax
  801df4:	74 0f                	je     801e05 <free+0x99>
  801df6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df9:	8b 40 04             	mov    0x4(%eax),%eax
  801dfc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dff:	8b 12                	mov    (%edx),%edx
  801e01:	89 10                	mov    %edx,(%eax)
  801e03:	eb 0a                	jmp    801e0f <free+0xa3>
  801e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e08:	8b 00                	mov    (%eax),%eax
  801e0a:	a3 40 50 80 00       	mov    %eax,0x805040
  801e0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e12:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e1b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e22:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801e27:	48                   	dec    %eax
  801e28:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(blk);
  801e2d:	83 ec 0c             	sub    $0xc,%esp
  801e30:	ff 75 f4             	pushl  -0xc(%ebp)
  801e33:	e8 65 13 00 00       	call   80319d <insert_sorted_with_merge_freeList>
  801e38:	83 c4 10             	add    $0x10,%esp
	}
}
  801e3b:	90                   	nop
  801e3c:	c9                   	leave  
  801e3d:	c3                   	ret    

00801e3e <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801e3e:	55                   	push   %ebp
  801e3f:	89 e5                	mov    %esp,%ebp
  801e41:	83 ec 28             	sub    $0x28,%esp
  801e44:	8b 45 10             	mov    0x10(%ebp),%eax
  801e47:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e4a:	e8 f6 fc ff ff       	call   801b45 <InitializeUHeap>
	if (size == 0) return NULL ;
  801e4f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e53:	75 0a                	jne    801e5f <smalloc+0x21>
  801e55:	b8 00 00 00 00       	mov    $0x0,%eax
  801e5a:	e9 af 00 00 00       	jmp    801f0e <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  801e5f:	e8 44 07 00 00       	call   8025a8 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801e64:	83 f8 01             	cmp    $0x1,%eax
  801e67:	0f 85 9c 00 00 00    	jne    801f09 <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  801e6d:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801e74:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e7a:	01 d0                	add    %edx,%eax
  801e7c:	48                   	dec    %eax
  801e7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e83:	ba 00 00 00 00       	mov    $0x0,%edx
  801e88:	f7 75 f4             	divl   -0xc(%ebp)
  801e8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e8e:	29 d0                	sub    %edx,%eax
  801e90:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  801e93:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  801e9a:	76 07                	jbe    801ea3 <smalloc+0x65>
			return NULL;
  801e9c:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea1:	eb 6b                	jmp    801f0e <smalloc+0xd0>
		blk =alloc_block_FF(size);
  801ea3:	83 ec 0c             	sub    $0xc,%esp
  801ea6:	ff 75 0c             	pushl  0xc(%ebp)
  801ea9:	e8 e7 0c 00 00       	call   802b95 <alloc_block_FF>
  801eae:	83 c4 10             	add    $0x10,%esp
  801eb1:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  801eb4:	83 ec 0c             	sub    $0xc,%esp
  801eb7:	ff 75 ec             	pushl  -0x14(%ebp)
  801eba:	e8 d6 0a 00 00       	call   802995 <insert_sorted_allocList>
  801ebf:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  801ec2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ec6:	75 07                	jne    801ecf <smalloc+0x91>
		{
			return NULL;
  801ec8:	b8 00 00 00 00       	mov    $0x0,%eax
  801ecd:	eb 3f                	jmp    801f0e <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  801ecf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ed2:	8b 40 08             	mov    0x8(%eax),%eax
  801ed5:	89 c2                	mov    %eax,%edx
  801ed7:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801edb:	52                   	push   %edx
  801edc:	50                   	push   %eax
  801edd:	ff 75 0c             	pushl  0xc(%ebp)
  801ee0:	ff 75 08             	pushl  0x8(%ebp)
  801ee3:	e8 45 04 00 00       	call   80232d <sys_createSharedObject>
  801ee8:	83 c4 10             	add    $0x10,%esp
  801eeb:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  801eee:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801ef2:	74 06                	je     801efa <smalloc+0xbc>
  801ef4:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801ef8:	75 07                	jne    801f01 <smalloc+0xc3>
		{
			return NULL;
  801efa:	b8 00 00 00 00       	mov    $0x0,%eax
  801eff:	eb 0d                	jmp    801f0e <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  801f01:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f04:	8b 40 08             	mov    0x8(%eax),%eax
  801f07:	eb 05                	jmp    801f0e <smalloc+0xd0>
		}
	}
	else
		return NULL;
  801f09:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f0e:	c9                   	leave  
  801f0f:	c3                   	ret    

00801f10 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801f10:	55                   	push   %ebp
  801f11:	89 e5                	mov    %esp,%ebp
  801f13:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f16:	e8 2a fc ff ff       	call   801b45 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801f1b:	83 ec 08             	sub    $0x8,%esp
  801f1e:	ff 75 0c             	pushl  0xc(%ebp)
  801f21:	ff 75 08             	pushl  0x8(%ebp)
  801f24:	e8 2e 04 00 00       	call   802357 <sys_getSizeOfSharedObject>
  801f29:	83 c4 10             	add    $0x10,%esp
  801f2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  801f2f:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801f33:	75 0a                	jne    801f3f <sget+0x2f>
	{
		return NULL;
  801f35:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3a:	e9 94 00 00 00       	jmp    801fd3 <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801f3f:	e8 64 06 00 00       	call   8025a8 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801f44:	85 c0                	test   %eax,%eax
  801f46:	0f 84 82 00 00 00    	je     801fce <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  801f4c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  801f53:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801f5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f60:	01 d0                	add    %edx,%eax
  801f62:	48                   	dec    %eax
  801f63:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801f66:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f69:	ba 00 00 00 00       	mov    $0x0,%edx
  801f6e:	f7 75 ec             	divl   -0x14(%ebp)
  801f71:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f74:	29 d0                	sub    %edx,%eax
  801f76:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  801f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7c:	83 ec 0c             	sub    $0xc,%esp
  801f7f:	50                   	push   %eax
  801f80:	e8 10 0c 00 00       	call   802b95 <alloc_block_FF>
  801f85:	83 c4 10             	add    $0x10,%esp
  801f88:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  801f8b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f8f:	75 07                	jne    801f98 <sget+0x88>
		{
			return NULL;
  801f91:	b8 00 00 00 00       	mov    $0x0,%eax
  801f96:	eb 3b                	jmp    801fd3 <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  801f98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f9b:	8b 40 08             	mov    0x8(%eax),%eax
  801f9e:	83 ec 04             	sub    $0x4,%esp
  801fa1:	50                   	push   %eax
  801fa2:	ff 75 0c             	pushl  0xc(%ebp)
  801fa5:	ff 75 08             	pushl  0x8(%ebp)
  801fa8:	e8 c7 03 00 00       	call   802374 <sys_getSharedObject>
  801fad:	83 c4 10             	add    $0x10,%esp
  801fb0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  801fb3:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801fb7:	74 06                	je     801fbf <sget+0xaf>
  801fb9:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  801fbd:	75 07                	jne    801fc6 <sget+0xb6>
		{
			return NULL;
  801fbf:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc4:	eb 0d                	jmp    801fd3 <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  801fc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc9:	8b 40 08             	mov    0x8(%eax),%eax
  801fcc:	eb 05                	jmp    801fd3 <sget+0xc3>
		}
	}
	else
			return NULL;
  801fce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fd3:	c9                   	leave  
  801fd4:	c3                   	ret    

00801fd5 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801fd5:	55                   	push   %ebp
  801fd6:	89 e5                	mov    %esp,%ebp
  801fd8:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801fdb:	e8 65 fb ff ff       	call   801b45 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801fe0:	83 ec 04             	sub    $0x4,%esp
  801fe3:	68 f4 42 80 00       	push   $0x8042f4
  801fe8:	68 e1 00 00 00       	push   $0xe1
  801fed:	68 e7 42 80 00       	push   $0x8042e7
  801ff2:	e8 0a e9 ff ff       	call   800901 <_panic>

00801ff7 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801ff7:	55                   	push   %ebp
  801ff8:	89 e5                	mov    %esp,%ebp
  801ffa:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801ffd:	83 ec 04             	sub    $0x4,%esp
  802000:	68 1c 43 80 00       	push   $0x80431c
  802005:	68 f5 00 00 00       	push   $0xf5
  80200a:	68 e7 42 80 00       	push   $0x8042e7
  80200f:	e8 ed e8 ff ff       	call   800901 <_panic>

00802014 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802014:	55                   	push   %ebp
  802015:	89 e5                	mov    %esp,%ebp
  802017:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80201a:	83 ec 04             	sub    $0x4,%esp
  80201d:	68 40 43 80 00       	push   $0x804340
  802022:	68 00 01 00 00       	push   $0x100
  802027:	68 e7 42 80 00       	push   $0x8042e7
  80202c:	e8 d0 e8 ff ff       	call   800901 <_panic>

00802031 <shrink>:

}
void shrink(uint32 newSize)
{
  802031:	55                   	push   %ebp
  802032:	89 e5                	mov    %esp,%ebp
  802034:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802037:	83 ec 04             	sub    $0x4,%esp
  80203a:	68 40 43 80 00       	push   $0x804340
  80203f:	68 05 01 00 00       	push   $0x105
  802044:	68 e7 42 80 00       	push   $0x8042e7
  802049:	e8 b3 e8 ff ff       	call   800901 <_panic>

0080204e <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80204e:	55                   	push   %ebp
  80204f:	89 e5                	mov    %esp,%ebp
  802051:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802054:	83 ec 04             	sub    $0x4,%esp
  802057:	68 40 43 80 00       	push   $0x804340
  80205c:	68 0a 01 00 00       	push   $0x10a
  802061:	68 e7 42 80 00       	push   $0x8042e7
  802066:	e8 96 e8 ff ff       	call   800901 <_panic>

0080206b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80206b:	55                   	push   %ebp
  80206c:	89 e5                	mov    %esp,%ebp
  80206e:	57                   	push   %edi
  80206f:	56                   	push   %esi
  802070:	53                   	push   %ebx
  802071:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802074:	8b 45 08             	mov    0x8(%ebp),%eax
  802077:	8b 55 0c             	mov    0xc(%ebp),%edx
  80207a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80207d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802080:	8b 7d 18             	mov    0x18(%ebp),%edi
  802083:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802086:	cd 30                	int    $0x30
  802088:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80208b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80208e:	83 c4 10             	add    $0x10,%esp
  802091:	5b                   	pop    %ebx
  802092:	5e                   	pop    %esi
  802093:	5f                   	pop    %edi
  802094:	5d                   	pop    %ebp
  802095:	c3                   	ret    

00802096 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802096:	55                   	push   %ebp
  802097:	89 e5                	mov    %esp,%ebp
  802099:	83 ec 04             	sub    $0x4,%esp
  80209c:	8b 45 10             	mov    0x10(%ebp),%eax
  80209f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8020a2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8020a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a9:	6a 00                	push   $0x0
  8020ab:	6a 00                	push   $0x0
  8020ad:	52                   	push   %edx
  8020ae:	ff 75 0c             	pushl  0xc(%ebp)
  8020b1:	50                   	push   %eax
  8020b2:	6a 00                	push   $0x0
  8020b4:	e8 b2 ff ff ff       	call   80206b <syscall>
  8020b9:	83 c4 18             	add    $0x18,%esp
}
  8020bc:	90                   	nop
  8020bd:	c9                   	leave  
  8020be:	c3                   	ret    

008020bf <sys_cgetc>:

int
sys_cgetc(void)
{
  8020bf:	55                   	push   %ebp
  8020c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8020c2:	6a 00                	push   $0x0
  8020c4:	6a 00                	push   $0x0
  8020c6:	6a 00                	push   $0x0
  8020c8:	6a 00                	push   $0x0
  8020ca:	6a 00                	push   $0x0
  8020cc:	6a 01                	push   $0x1
  8020ce:	e8 98 ff ff ff       	call   80206b <syscall>
  8020d3:	83 c4 18             	add    $0x18,%esp
}
  8020d6:	c9                   	leave  
  8020d7:	c3                   	ret    

008020d8 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8020d8:	55                   	push   %ebp
  8020d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8020db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020de:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e1:	6a 00                	push   $0x0
  8020e3:	6a 00                	push   $0x0
  8020e5:	6a 00                	push   $0x0
  8020e7:	52                   	push   %edx
  8020e8:	50                   	push   %eax
  8020e9:	6a 05                	push   $0x5
  8020eb:	e8 7b ff ff ff       	call   80206b <syscall>
  8020f0:	83 c4 18             	add    $0x18,%esp
}
  8020f3:	c9                   	leave  
  8020f4:	c3                   	ret    

008020f5 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8020f5:	55                   	push   %ebp
  8020f6:	89 e5                	mov    %esp,%ebp
  8020f8:	56                   	push   %esi
  8020f9:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8020fa:	8b 75 18             	mov    0x18(%ebp),%esi
  8020fd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802100:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802103:	8b 55 0c             	mov    0xc(%ebp),%edx
  802106:	8b 45 08             	mov    0x8(%ebp),%eax
  802109:	56                   	push   %esi
  80210a:	53                   	push   %ebx
  80210b:	51                   	push   %ecx
  80210c:	52                   	push   %edx
  80210d:	50                   	push   %eax
  80210e:	6a 06                	push   $0x6
  802110:	e8 56 ff ff ff       	call   80206b <syscall>
  802115:	83 c4 18             	add    $0x18,%esp
}
  802118:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80211b:	5b                   	pop    %ebx
  80211c:	5e                   	pop    %esi
  80211d:	5d                   	pop    %ebp
  80211e:	c3                   	ret    

0080211f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80211f:	55                   	push   %ebp
  802120:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802122:	8b 55 0c             	mov    0xc(%ebp),%edx
  802125:	8b 45 08             	mov    0x8(%ebp),%eax
  802128:	6a 00                	push   $0x0
  80212a:	6a 00                	push   $0x0
  80212c:	6a 00                	push   $0x0
  80212e:	52                   	push   %edx
  80212f:	50                   	push   %eax
  802130:	6a 07                	push   $0x7
  802132:	e8 34 ff ff ff       	call   80206b <syscall>
  802137:	83 c4 18             	add    $0x18,%esp
}
  80213a:	c9                   	leave  
  80213b:	c3                   	ret    

0080213c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80213c:	55                   	push   %ebp
  80213d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80213f:	6a 00                	push   $0x0
  802141:	6a 00                	push   $0x0
  802143:	6a 00                	push   $0x0
  802145:	ff 75 0c             	pushl  0xc(%ebp)
  802148:	ff 75 08             	pushl  0x8(%ebp)
  80214b:	6a 08                	push   $0x8
  80214d:	e8 19 ff ff ff       	call   80206b <syscall>
  802152:	83 c4 18             	add    $0x18,%esp
}
  802155:	c9                   	leave  
  802156:	c3                   	ret    

00802157 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802157:	55                   	push   %ebp
  802158:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80215a:	6a 00                	push   $0x0
  80215c:	6a 00                	push   $0x0
  80215e:	6a 00                	push   $0x0
  802160:	6a 00                	push   $0x0
  802162:	6a 00                	push   $0x0
  802164:	6a 09                	push   $0x9
  802166:	e8 00 ff ff ff       	call   80206b <syscall>
  80216b:	83 c4 18             	add    $0x18,%esp
}
  80216e:	c9                   	leave  
  80216f:	c3                   	ret    

00802170 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802170:	55                   	push   %ebp
  802171:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802173:	6a 00                	push   $0x0
  802175:	6a 00                	push   $0x0
  802177:	6a 00                	push   $0x0
  802179:	6a 00                	push   $0x0
  80217b:	6a 00                	push   $0x0
  80217d:	6a 0a                	push   $0xa
  80217f:	e8 e7 fe ff ff       	call   80206b <syscall>
  802184:	83 c4 18             	add    $0x18,%esp
}
  802187:	c9                   	leave  
  802188:	c3                   	ret    

00802189 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802189:	55                   	push   %ebp
  80218a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80218c:	6a 00                	push   $0x0
  80218e:	6a 00                	push   $0x0
  802190:	6a 00                	push   $0x0
  802192:	6a 00                	push   $0x0
  802194:	6a 00                	push   $0x0
  802196:	6a 0b                	push   $0xb
  802198:	e8 ce fe ff ff       	call   80206b <syscall>
  80219d:	83 c4 18             	add    $0x18,%esp
}
  8021a0:	c9                   	leave  
  8021a1:	c3                   	ret    

008021a2 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8021a2:	55                   	push   %ebp
  8021a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8021a5:	6a 00                	push   $0x0
  8021a7:	6a 00                	push   $0x0
  8021a9:	6a 00                	push   $0x0
  8021ab:	ff 75 0c             	pushl  0xc(%ebp)
  8021ae:	ff 75 08             	pushl  0x8(%ebp)
  8021b1:	6a 0f                	push   $0xf
  8021b3:	e8 b3 fe ff ff       	call   80206b <syscall>
  8021b8:	83 c4 18             	add    $0x18,%esp
	return;
  8021bb:	90                   	nop
}
  8021bc:	c9                   	leave  
  8021bd:	c3                   	ret    

008021be <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8021be:	55                   	push   %ebp
  8021bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8021c1:	6a 00                	push   $0x0
  8021c3:	6a 00                	push   $0x0
  8021c5:	6a 00                	push   $0x0
  8021c7:	ff 75 0c             	pushl  0xc(%ebp)
  8021ca:	ff 75 08             	pushl  0x8(%ebp)
  8021cd:	6a 10                	push   $0x10
  8021cf:	e8 97 fe ff ff       	call   80206b <syscall>
  8021d4:	83 c4 18             	add    $0x18,%esp
	return ;
  8021d7:	90                   	nop
}
  8021d8:	c9                   	leave  
  8021d9:	c3                   	ret    

008021da <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8021da:	55                   	push   %ebp
  8021db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8021dd:	6a 00                	push   $0x0
  8021df:	6a 00                	push   $0x0
  8021e1:	ff 75 10             	pushl  0x10(%ebp)
  8021e4:	ff 75 0c             	pushl  0xc(%ebp)
  8021e7:	ff 75 08             	pushl  0x8(%ebp)
  8021ea:	6a 11                	push   $0x11
  8021ec:	e8 7a fe ff ff       	call   80206b <syscall>
  8021f1:	83 c4 18             	add    $0x18,%esp
	return ;
  8021f4:	90                   	nop
}
  8021f5:	c9                   	leave  
  8021f6:	c3                   	ret    

008021f7 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8021f7:	55                   	push   %ebp
  8021f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8021fa:	6a 00                	push   $0x0
  8021fc:	6a 00                	push   $0x0
  8021fe:	6a 00                	push   $0x0
  802200:	6a 00                	push   $0x0
  802202:	6a 00                	push   $0x0
  802204:	6a 0c                	push   $0xc
  802206:	e8 60 fe ff ff       	call   80206b <syscall>
  80220b:	83 c4 18             	add    $0x18,%esp
}
  80220e:	c9                   	leave  
  80220f:	c3                   	ret    

00802210 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802210:	55                   	push   %ebp
  802211:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802213:	6a 00                	push   $0x0
  802215:	6a 00                	push   $0x0
  802217:	6a 00                	push   $0x0
  802219:	6a 00                	push   $0x0
  80221b:	ff 75 08             	pushl  0x8(%ebp)
  80221e:	6a 0d                	push   $0xd
  802220:	e8 46 fe ff ff       	call   80206b <syscall>
  802225:	83 c4 18             	add    $0x18,%esp
}
  802228:	c9                   	leave  
  802229:	c3                   	ret    

0080222a <sys_scarce_memory>:

void sys_scarce_memory()
{
  80222a:	55                   	push   %ebp
  80222b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80222d:	6a 00                	push   $0x0
  80222f:	6a 00                	push   $0x0
  802231:	6a 00                	push   $0x0
  802233:	6a 00                	push   $0x0
  802235:	6a 00                	push   $0x0
  802237:	6a 0e                	push   $0xe
  802239:	e8 2d fe ff ff       	call   80206b <syscall>
  80223e:	83 c4 18             	add    $0x18,%esp
}
  802241:	90                   	nop
  802242:	c9                   	leave  
  802243:	c3                   	ret    

00802244 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802244:	55                   	push   %ebp
  802245:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802247:	6a 00                	push   $0x0
  802249:	6a 00                	push   $0x0
  80224b:	6a 00                	push   $0x0
  80224d:	6a 00                	push   $0x0
  80224f:	6a 00                	push   $0x0
  802251:	6a 13                	push   $0x13
  802253:	e8 13 fe ff ff       	call   80206b <syscall>
  802258:	83 c4 18             	add    $0x18,%esp
}
  80225b:	90                   	nop
  80225c:	c9                   	leave  
  80225d:	c3                   	ret    

0080225e <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80225e:	55                   	push   %ebp
  80225f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802261:	6a 00                	push   $0x0
  802263:	6a 00                	push   $0x0
  802265:	6a 00                	push   $0x0
  802267:	6a 00                	push   $0x0
  802269:	6a 00                	push   $0x0
  80226b:	6a 14                	push   $0x14
  80226d:	e8 f9 fd ff ff       	call   80206b <syscall>
  802272:	83 c4 18             	add    $0x18,%esp
}
  802275:	90                   	nop
  802276:	c9                   	leave  
  802277:	c3                   	ret    

00802278 <sys_cputc>:


void
sys_cputc(const char c)
{
  802278:	55                   	push   %ebp
  802279:	89 e5                	mov    %esp,%ebp
  80227b:	83 ec 04             	sub    $0x4,%esp
  80227e:	8b 45 08             	mov    0x8(%ebp),%eax
  802281:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802284:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802288:	6a 00                	push   $0x0
  80228a:	6a 00                	push   $0x0
  80228c:	6a 00                	push   $0x0
  80228e:	6a 00                	push   $0x0
  802290:	50                   	push   %eax
  802291:	6a 15                	push   $0x15
  802293:	e8 d3 fd ff ff       	call   80206b <syscall>
  802298:	83 c4 18             	add    $0x18,%esp
}
  80229b:	90                   	nop
  80229c:	c9                   	leave  
  80229d:	c3                   	ret    

0080229e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80229e:	55                   	push   %ebp
  80229f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8022a1:	6a 00                	push   $0x0
  8022a3:	6a 00                	push   $0x0
  8022a5:	6a 00                	push   $0x0
  8022a7:	6a 00                	push   $0x0
  8022a9:	6a 00                	push   $0x0
  8022ab:	6a 16                	push   $0x16
  8022ad:	e8 b9 fd ff ff       	call   80206b <syscall>
  8022b2:	83 c4 18             	add    $0x18,%esp
}
  8022b5:	90                   	nop
  8022b6:	c9                   	leave  
  8022b7:	c3                   	ret    

008022b8 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8022b8:	55                   	push   %ebp
  8022b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8022bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022be:	6a 00                	push   $0x0
  8022c0:	6a 00                	push   $0x0
  8022c2:	6a 00                	push   $0x0
  8022c4:	ff 75 0c             	pushl  0xc(%ebp)
  8022c7:	50                   	push   %eax
  8022c8:	6a 17                	push   $0x17
  8022ca:	e8 9c fd ff ff       	call   80206b <syscall>
  8022cf:	83 c4 18             	add    $0x18,%esp
}
  8022d2:	c9                   	leave  
  8022d3:	c3                   	ret    

008022d4 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8022d4:	55                   	push   %ebp
  8022d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022da:	8b 45 08             	mov    0x8(%ebp),%eax
  8022dd:	6a 00                	push   $0x0
  8022df:	6a 00                	push   $0x0
  8022e1:	6a 00                	push   $0x0
  8022e3:	52                   	push   %edx
  8022e4:	50                   	push   %eax
  8022e5:	6a 1a                	push   $0x1a
  8022e7:	e8 7f fd ff ff       	call   80206b <syscall>
  8022ec:	83 c4 18             	add    $0x18,%esp
}
  8022ef:	c9                   	leave  
  8022f0:	c3                   	ret    

008022f1 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8022f1:	55                   	push   %ebp
  8022f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fa:	6a 00                	push   $0x0
  8022fc:	6a 00                	push   $0x0
  8022fe:	6a 00                	push   $0x0
  802300:	52                   	push   %edx
  802301:	50                   	push   %eax
  802302:	6a 18                	push   $0x18
  802304:	e8 62 fd ff ff       	call   80206b <syscall>
  802309:	83 c4 18             	add    $0x18,%esp
}
  80230c:	90                   	nop
  80230d:	c9                   	leave  
  80230e:	c3                   	ret    

0080230f <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80230f:	55                   	push   %ebp
  802310:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802312:	8b 55 0c             	mov    0xc(%ebp),%edx
  802315:	8b 45 08             	mov    0x8(%ebp),%eax
  802318:	6a 00                	push   $0x0
  80231a:	6a 00                	push   $0x0
  80231c:	6a 00                	push   $0x0
  80231e:	52                   	push   %edx
  80231f:	50                   	push   %eax
  802320:	6a 19                	push   $0x19
  802322:	e8 44 fd ff ff       	call   80206b <syscall>
  802327:	83 c4 18             	add    $0x18,%esp
}
  80232a:	90                   	nop
  80232b:	c9                   	leave  
  80232c:	c3                   	ret    

0080232d <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80232d:	55                   	push   %ebp
  80232e:	89 e5                	mov    %esp,%ebp
  802330:	83 ec 04             	sub    $0x4,%esp
  802333:	8b 45 10             	mov    0x10(%ebp),%eax
  802336:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802339:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80233c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802340:	8b 45 08             	mov    0x8(%ebp),%eax
  802343:	6a 00                	push   $0x0
  802345:	51                   	push   %ecx
  802346:	52                   	push   %edx
  802347:	ff 75 0c             	pushl  0xc(%ebp)
  80234a:	50                   	push   %eax
  80234b:	6a 1b                	push   $0x1b
  80234d:	e8 19 fd ff ff       	call   80206b <syscall>
  802352:	83 c4 18             	add    $0x18,%esp
}
  802355:	c9                   	leave  
  802356:	c3                   	ret    

00802357 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802357:	55                   	push   %ebp
  802358:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80235a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80235d:	8b 45 08             	mov    0x8(%ebp),%eax
  802360:	6a 00                	push   $0x0
  802362:	6a 00                	push   $0x0
  802364:	6a 00                	push   $0x0
  802366:	52                   	push   %edx
  802367:	50                   	push   %eax
  802368:	6a 1c                	push   $0x1c
  80236a:	e8 fc fc ff ff       	call   80206b <syscall>
  80236f:	83 c4 18             	add    $0x18,%esp
}
  802372:	c9                   	leave  
  802373:	c3                   	ret    

00802374 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802374:	55                   	push   %ebp
  802375:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802377:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80237a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80237d:	8b 45 08             	mov    0x8(%ebp),%eax
  802380:	6a 00                	push   $0x0
  802382:	6a 00                	push   $0x0
  802384:	51                   	push   %ecx
  802385:	52                   	push   %edx
  802386:	50                   	push   %eax
  802387:	6a 1d                	push   $0x1d
  802389:	e8 dd fc ff ff       	call   80206b <syscall>
  80238e:	83 c4 18             	add    $0x18,%esp
}
  802391:	c9                   	leave  
  802392:	c3                   	ret    

00802393 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802393:	55                   	push   %ebp
  802394:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802396:	8b 55 0c             	mov    0xc(%ebp),%edx
  802399:	8b 45 08             	mov    0x8(%ebp),%eax
  80239c:	6a 00                	push   $0x0
  80239e:	6a 00                	push   $0x0
  8023a0:	6a 00                	push   $0x0
  8023a2:	52                   	push   %edx
  8023a3:	50                   	push   %eax
  8023a4:	6a 1e                	push   $0x1e
  8023a6:	e8 c0 fc ff ff       	call   80206b <syscall>
  8023ab:	83 c4 18             	add    $0x18,%esp
}
  8023ae:	c9                   	leave  
  8023af:	c3                   	ret    

008023b0 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8023b0:	55                   	push   %ebp
  8023b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8023b3:	6a 00                	push   $0x0
  8023b5:	6a 00                	push   $0x0
  8023b7:	6a 00                	push   $0x0
  8023b9:	6a 00                	push   $0x0
  8023bb:	6a 00                	push   $0x0
  8023bd:	6a 1f                	push   $0x1f
  8023bf:	e8 a7 fc ff ff       	call   80206b <syscall>
  8023c4:	83 c4 18             	add    $0x18,%esp
}
  8023c7:	c9                   	leave  
  8023c8:	c3                   	ret    

008023c9 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8023c9:	55                   	push   %ebp
  8023ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8023cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cf:	6a 00                	push   $0x0
  8023d1:	ff 75 14             	pushl  0x14(%ebp)
  8023d4:	ff 75 10             	pushl  0x10(%ebp)
  8023d7:	ff 75 0c             	pushl  0xc(%ebp)
  8023da:	50                   	push   %eax
  8023db:	6a 20                	push   $0x20
  8023dd:	e8 89 fc ff ff       	call   80206b <syscall>
  8023e2:	83 c4 18             	add    $0x18,%esp
}
  8023e5:	c9                   	leave  
  8023e6:	c3                   	ret    

008023e7 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8023e7:	55                   	push   %ebp
  8023e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8023ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ed:	6a 00                	push   $0x0
  8023ef:	6a 00                	push   $0x0
  8023f1:	6a 00                	push   $0x0
  8023f3:	6a 00                	push   $0x0
  8023f5:	50                   	push   %eax
  8023f6:	6a 21                	push   $0x21
  8023f8:	e8 6e fc ff ff       	call   80206b <syscall>
  8023fd:	83 c4 18             	add    $0x18,%esp
}
  802400:	90                   	nop
  802401:	c9                   	leave  
  802402:	c3                   	ret    

00802403 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802403:	55                   	push   %ebp
  802404:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802406:	8b 45 08             	mov    0x8(%ebp),%eax
  802409:	6a 00                	push   $0x0
  80240b:	6a 00                	push   $0x0
  80240d:	6a 00                	push   $0x0
  80240f:	6a 00                	push   $0x0
  802411:	50                   	push   %eax
  802412:	6a 22                	push   $0x22
  802414:	e8 52 fc ff ff       	call   80206b <syscall>
  802419:	83 c4 18             	add    $0x18,%esp
}
  80241c:	c9                   	leave  
  80241d:	c3                   	ret    

0080241e <sys_getenvid>:

int32 sys_getenvid(void)
{
  80241e:	55                   	push   %ebp
  80241f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802421:	6a 00                	push   $0x0
  802423:	6a 00                	push   $0x0
  802425:	6a 00                	push   $0x0
  802427:	6a 00                	push   $0x0
  802429:	6a 00                	push   $0x0
  80242b:	6a 02                	push   $0x2
  80242d:	e8 39 fc ff ff       	call   80206b <syscall>
  802432:	83 c4 18             	add    $0x18,%esp
}
  802435:	c9                   	leave  
  802436:	c3                   	ret    

00802437 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802437:	55                   	push   %ebp
  802438:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80243a:	6a 00                	push   $0x0
  80243c:	6a 00                	push   $0x0
  80243e:	6a 00                	push   $0x0
  802440:	6a 00                	push   $0x0
  802442:	6a 00                	push   $0x0
  802444:	6a 03                	push   $0x3
  802446:	e8 20 fc ff ff       	call   80206b <syscall>
  80244b:	83 c4 18             	add    $0x18,%esp
}
  80244e:	c9                   	leave  
  80244f:	c3                   	ret    

00802450 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802450:	55                   	push   %ebp
  802451:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802453:	6a 00                	push   $0x0
  802455:	6a 00                	push   $0x0
  802457:	6a 00                	push   $0x0
  802459:	6a 00                	push   $0x0
  80245b:	6a 00                	push   $0x0
  80245d:	6a 04                	push   $0x4
  80245f:	e8 07 fc ff ff       	call   80206b <syscall>
  802464:	83 c4 18             	add    $0x18,%esp
}
  802467:	c9                   	leave  
  802468:	c3                   	ret    

00802469 <sys_exit_env>:


void sys_exit_env(void)
{
  802469:	55                   	push   %ebp
  80246a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80246c:	6a 00                	push   $0x0
  80246e:	6a 00                	push   $0x0
  802470:	6a 00                	push   $0x0
  802472:	6a 00                	push   $0x0
  802474:	6a 00                	push   $0x0
  802476:	6a 23                	push   $0x23
  802478:	e8 ee fb ff ff       	call   80206b <syscall>
  80247d:	83 c4 18             	add    $0x18,%esp
}
  802480:	90                   	nop
  802481:	c9                   	leave  
  802482:	c3                   	ret    

00802483 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802483:	55                   	push   %ebp
  802484:	89 e5                	mov    %esp,%ebp
  802486:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802489:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80248c:	8d 50 04             	lea    0x4(%eax),%edx
  80248f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802492:	6a 00                	push   $0x0
  802494:	6a 00                	push   $0x0
  802496:	6a 00                	push   $0x0
  802498:	52                   	push   %edx
  802499:	50                   	push   %eax
  80249a:	6a 24                	push   $0x24
  80249c:	e8 ca fb ff ff       	call   80206b <syscall>
  8024a1:	83 c4 18             	add    $0x18,%esp
	return result;
  8024a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024aa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024ad:	89 01                	mov    %eax,(%ecx)
  8024af:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8024b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b5:	c9                   	leave  
  8024b6:	c2 04 00             	ret    $0x4

008024b9 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8024b9:	55                   	push   %ebp
  8024ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8024bc:	6a 00                	push   $0x0
  8024be:	6a 00                	push   $0x0
  8024c0:	ff 75 10             	pushl  0x10(%ebp)
  8024c3:	ff 75 0c             	pushl  0xc(%ebp)
  8024c6:	ff 75 08             	pushl  0x8(%ebp)
  8024c9:	6a 12                	push   $0x12
  8024cb:	e8 9b fb ff ff       	call   80206b <syscall>
  8024d0:	83 c4 18             	add    $0x18,%esp
	return ;
  8024d3:	90                   	nop
}
  8024d4:	c9                   	leave  
  8024d5:	c3                   	ret    

008024d6 <sys_rcr2>:
uint32 sys_rcr2()
{
  8024d6:	55                   	push   %ebp
  8024d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8024d9:	6a 00                	push   $0x0
  8024db:	6a 00                	push   $0x0
  8024dd:	6a 00                	push   $0x0
  8024df:	6a 00                	push   $0x0
  8024e1:	6a 00                	push   $0x0
  8024e3:	6a 25                	push   $0x25
  8024e5:	e8 81 fb ff ff       	call   80206b <syscall>
  8024ea:	83 c4 18             	add    $0x18,%esp
}
  8024ed:	c9                   	leave  
  8024ee:	c3                   	ret    

008024ef <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8024ef:	55                   	push   %ebp
  8024f0:	89 e5                	mov    %esp,%ebp
  8024f2:	83 ec 04             	sub    $0x4,%esp
  8024f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8024fb:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8024ff:	6a 00                	push   $0x0
  802501:	6a 00                	push   $0x0
  802503:	6a 00                	push   $0x0
  802505:	6a 00                	push   $0x0
  802507:	50                   	push   %eax
  802508:	6a 26                	push   $0x26
  80250a:	e8 5c fb ff ff       	call   80206b <syscall>
  80250f:	83 c4 18             	add    $0x18,%esp
	return ;
  802512:	90                   	nop
}
  802513:	c9                   	leave  
  802514:	c3                   	ret    

00802515 <rsttst>:
void rsttst()
{
  802515:	55                   	push   %ebp
  802516:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802518:	6a 00                	push   $0x0
  80251a:	6a 00                	push   $0x0
  80251c:	6a 00                	push   $0x0
  80251e:	6a 00                	push   $0x0
  802520:	6a 00                	push   $0x0
  802522:	6a 28                	push   $0x28
  802524:	e8 42 fb ff ff       	call   80206b <syscall>
  802529:	83 c4 18             	add    $0x18,%esp
	return ;
  80252c:	90                   	nop
}
  80252d:	c9                   	leave  
  80252e:	c3                   	ret    

0080252f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80252f:	55                   	push   %ebp
  802530:	89 e5                	mov    %esp,%ebp
  802532:	83 ec 04             	sub    $0x4,%esp
  802535:	8b 45 14             	mov    0x14(%ebp),%eax
  802538:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80253b:	8b 55 18             	mov    0x18(%ebp),%edx
  80253e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802542:	52                   	push   %edx
  802543:	50                   	push   %eax
  802544:	ff 75 10             	pushl  0x10(%ebp)
  802547:	ff 75 0c             	pushl  0xc(%ebp)
  80254a:	ff 75 08             	pushl  0x8(%ebp)
  80254d:	6a 27                	push   $0x27
  80254f:	e8 17 fb ff ff       	call   80206b <syscall>
  802554:	83 c4 18             	add    $0x18,%esp
	return ;
  802557:	90                   	nop
}
  802558:	c9                   	leave  
  802559:	c3                   	ret    

0080255a <chktst>:
void chktst(uint32 n)
{
  80255a:	55                   	push   %ebp
  80255b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80255d:	6a 00                	push   $0x0
  80255f:	6a 00                	push   $0x0
  802561:	6a 00                	push   $0x0
  802563:	6a 00                	push   $0x0
  802565:	ff 75 08             	pushl  0x8(%ebp)
  802568:	6a 29                	push   $0x29
  80256a:	e8 fc fa ff ff       	call   80206b <syscall>
  80256f:	83 c4 18             	add    $0x18,%esp
	return ;
  802572:	90                   	nop
}
  802573:	c9                   	leave  
  802574:	c3                   	ret    

00802575 <inctst>:

void inctst()
{
  802575:	55                   	push   %ebp
  802576:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802578:	6a 00                	push   $0x0
  80257a:	6a 00                	push   $0x0
  80257c:	6a 00                	push   $0x0
  80257e:	6a 00                	push   $0x0
  802580:	6a 00                	push   $0x0
  802582:	6a 2a                	push   $0x2a
  802584:	e8 e2 fa ff ff       	call   80206b <syscall>
  802589:	83 c4 18             	add    $0x18,%esp
	return ;
  80258c:	90                   	nop
}
  80258d:	c9                   	leave  
  80258e:	c3                   	ret    

0080258f <gettst>:
uint32 gettst()
{
  80258f:	55                   	push   %ebp
  802590:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802592:	6a 00                	push   $0x0
  802594:	6a 00                	push   $0x0
  802596:	6a 00                	push   $0x0
  802598:	6a 00                	push   $0x0
  80259a:	6a 00                	push   $0x0
  80259c:	6a 2b                	push   $0x2b
  80259e:	e8 c8 fa ff ff       	call   80206b <syscall>
  8025a3:	83 c4 18             	add    $0x18,%esp
}
  8025a6:	c9                   	leave  
  8025a7:	c3                   	ret    

008025a8 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8025a8:	55                   	push   %ebp
  8025a9:	89 e5                	mov    %esp,%ebp
  8025ab:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025ae:	6a 00                	push   $0x0
  8025b0:	6a 00                	push   $0x0
  8025b2:	6a 00                	push   $0x0
  8025b4:	6a 00                	push   $0x0
  8025b6:	6a 00                	push   $0x0
  8025b8:	6a 2c                	push   $0x2c
  8025ba:	e8 ac fa ff ff       	call   80206b <syscall>
  8025bf:	83 c4 18             	add    $0x18,%esp
  8025c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8025c5:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8025c9:	75 07                	jne    8025d2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8025cb:	b8 01 00 00 00       	mov    $0x1,%eax
  8025d0:	eb 05                	jmp    8025d7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8025d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025d7:	c9                   	leave  
  8025d8:	c3                   	ret    

008025d9 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8025d9:	55                   	push   %ebp
  8025da:	89 e5                	mov    %esp,%ebp
  8025dc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025df:	6a 00                	push   $0x0
  8025e1:	6a 00                	push   $0x0
  8025e3:	6a 00                	push   $0x0
  8025e5:	6a 00                	push   $0x0
  8025e7:	6a 00                	push   $0x0
  8025e9:	6a 2c                	push   $0x2c
  8025eb:	e8 7b fa ff ff       	call   80206b <syscall>
  8025f0:	83 c4 18             	add    $0x18,%esp
  8025f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8025f6:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8025fa:	75 07                	jne    802603 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8025fc:	b8 01 00 00 00       	mov    $0x1,%eax
  802601:	eb 05                	jmp    802608 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802603:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802608:	c9                   	leave  
  802609:	c3                   	ret    

0080260a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80260a:	55                   	push   %ebp
  80260b:	89 e5                	mov    %esp,%ebp
  80260d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802610:	6a 00                	push   $0x0
  802612:	6a 00                	push   $0x0
  802614:	6a 00                	push   $0x0
  802616:	6a 00                	push   $0x0
  802618:	6a 00                	push   $0x0
  80261a:	6a 2c                	push   $0x2c
  80261c:	e8 4a fa ff ff       	call   80206b <syscall>
  802621:	83 c4 18             	add    $0x18,%esp
  802624:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802627:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80262b:	75 07                	jne    802634 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80262d:	b8 01 00 00 00       	mov    $0x1,%eax
  802632:	eb 05                	jmp    802639 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802634:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802639:	c9                   	leave  
  80263a:	c3                   	ret    

0080263b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80263b:	55                   	push   %ebp
  80263c:	89 e5                	mov    %esp,%ebp
  80263e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802641:	6a 00                	push   $0x0
  802643:	6a 00                	push   $0x0
  802645:	6a 00                	push   $0x0
  802647:	6a 00                	push   $0x0
  802649:	6a 00                	push   $0x0
  80264b:	6a 2c                	push   $0x2c
  80264d:	e8 19 fa ff ff       	call   80206b <syscall>
  802652:	83 c4 18             	add    $0x18,%esp
  802655:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802658:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80265c:	75 07                	jne    802665 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80265e:	b8 01 00 00 00       	mov    $0x1,%eax
  802663:	eb 05                	jmp    80266a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802665:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80266a:	c9                   	leave  
  80266b:	c3                   	ret    

0080266c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80266c:	55                   	push   %ebp
  80266d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80266f:	6a 00                	push   $0x0
  802671:	6a 00                	push   $0x0
  802673:	6a 00                	push   $0x0
  802675:	6a 00                	push   $0x0
  802677:	ff 75 08             	pushl  0x8(%ebp)
  80267a:	6a 2d                	push   $0x2d
  80267c:	e8 ea f9 ff ff       	call   80206b <syscall>
  802681:	83 c4 18             	add    $0x18,%esp
	return ;
  802684:	90                   	nop
}
  802685:	c9                   	leave  
  802686:	c3                   	ret    

00802687 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802687:	55                   	push   %ebp
  802688:	89 e5                	mov    %esp,%ebp
  80268a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80268b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80268e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802691:	8b 55 0c             	mov    0xc(%ebp),%edx
  802694:	8b 45 08             	mov    0x8(%ebp),%eax
  802697:	6a 00                	push   $0x0
  802699:	53                   	push   %ebx
  80269a:	51                   	push   %ecx
  80269b:	52                   	push   %edx
  80269c:	50                   	push   %eax
  80269d:	6a 2e                	push   $0x2e
  80269f:	e8 c7 f9 ff ff       	call   80206b <syscall>
  8026a4:	83 c4 18             	add    $0x18,%esp
}
  8026a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8026aa:	c9                   	leave  
  8026ab:	c3                   	ret    

008026ac <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8026ac:	55                   	push   %ebp
  8026ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8026af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b5:	6a 00                	push   $0x0
  8026b7:	6a 00                	push   $0x0
  8026b9:	6a 00                	push   $0x0
  8026bb:	52                   	push   %edx
  8026bc:	50                   	push   %eax
  8026bd:	6a 2f                	push   $0x2f
  8026bf:	e8 a7 f9 ff ff       	call   80206b <syscall>
  8026c4:	83 c4 18             	add    $0x18,%esp
}
  8026c7:	c9                   	leave  
  8026c8:	c3                   	ret    

008026c9 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8026c9:	55                   	push   %ebp
  8026ca:	89 e5                	mov    %esp,%ebp
  8026cc:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8026cf:	83 ec 0c             	sub    $0xc,%esp
  8026d2:	68 50 43 80 00       	push   $0x804350
  8026d7:	e8 d9 e4 ff ff       	call   800bb5 <cprintf>
  8026dc:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8026df:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8026e6:	83 ec 0c             	sub    $0xc,%esp
  8026e9:	68 7c 43 80 00       	push   $0x80437c
  8026ee:	e8 c2 e4 ff ff       	call   800bb5 <cprintf>
  8026f3:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8026f6:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026fa:	a1 38 51 80 00       	mov    0x805138,%eax
  8026ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802702:	eb 56                	jmp    80275a <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802704:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802708:	74 1c                	je     802726 <print_mem_block_lists+0x5d>
  80270a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270d:	8b 50 08             	mov    0x8(%eax),%edx
  802710:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802713:	8b 48 08             	mov    0x8(%eax),%ecx
  802716:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802719:	8b 40 0c             	mov    0xc(%eax),%eax
  80271c:	01 c8                	add    %ecx,%eax
  80271e:	39 c2                	cmp    %eax,%edx
  802720:	73 04                	jae    802726 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802722:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802726:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802729:	8b 50 08             	mov    0x8(%eax),%edx
  80272c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272f:	8b 40 0c             	mov    0xc(%eax),%eax
  802732:	01 c2                	add    %eax,%edx
  802734:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802737:	8b 40 08             	mov    0x8(%eax),%eax
  80273a:	83 ec 04             	sub    $0x4,%esp
  80273d:	52                   	push   %edx
  80273e:	50                   	push   %eax
  80273f:	68 91 43 80 00       	push   $0x804391
  802744:	e8 6c e4 ff ff       	call   800bb5 <cprintf>
  802749:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80274c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802752:	a1 40 51 80 00       	mov    0x805140,%eax
  802757:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80275a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80275e:	74 07                	je     802767 <print_mem_block_lists+0x9e>
  802760:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802763:	8b 00                	mov    (%eax),%eax
  802765:	eb 05                	jmp    80276c <print_mem_block_lists+0xa3>
  802767:	b8 00 00 00 00       	mov    $0x0,%eax
  80276c:	a3 40 51 80 00       	mov    %eax,0x805140
  802771:	a1 40 51 80 00       	mov    0x805140,%eax
  802776:	85 c0                	test   %eax,%eax
  802778:	75 8a                	jne    802704 <print_mem_block_lists+0x3b>
  80277a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80277e:	75 84                	jne    802704 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802780:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802784:	75 10                	jne    802796 <print_mem_block_lists+0xcd>
  802786:	83 ec 0c             	sub    $0xc,%esp
  802789:	68 a0 43 80 00       	push   $0x8043a0
  80278e:	e8 22 e4 ff ff       	call   800bb5 <cprintf>
  802793:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802796:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80279d:	83 ec 0c             	sub    $0xc,%esp
  8027a0:	68 c4 43 80 00       	push   $0x8043c4
  8027a5:	e8 0b e4 ff ff       	call   800bb5 <cprintf>
  8027aa:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8027ad:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8027b1:	a1 40 50 80 00       	mov    0x805040,%eax
  8027b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027b9:	eb 56                	jmp    802811 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8027bb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027bf:	74 1c                	je     8027dd <print_mem_block_lists+0x114>
  8027c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c4:	8b 50 08             	mov    0x8(%eax),%edx
  8027c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ca:	8b 48 08             	mov    0x8(%eax),%ecx
  8027cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8027d3:	01 c8                	add    %ecx,%eax
  8027d5:	39 c2                	cmp    %eax,%edx
  8027d7:	73 04                	jae    8027dd <print_mem_block_lists+0x114>
			sorted = 0 ;
  8027d9:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8027dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e0:	8b 50 08             	mov    0x8(%eax),%edx
  8027e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8027e9:	01 c2                	add    %eax,%edx
  8027eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ee:	8b 40 08             	mov    0x8(%eax),%eax
  8027f1:	83 ec 04             	sub    $0x4,%esp
  8027f4:	52                   	push   %edx
  8027f5:	50                   	push   %eax
  8027f6:	68 91 43 80 00       	push   $0x804391
  8027fb:	e8 b5 e3 ff ff       	call   800bb5 <cprintf>
  802800:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802803:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802806:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802809:	a1 48 50 80 00       	mov    0x805048,%eax
  80280e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802811:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802815:	74 07                	je     80281e <print_mem_block_lists+0x155>
  802817:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281a:	8b 00                	mov    (%eax),%eax
  80281c:	eb 05                	jmp    802823 <print_mem_block_lists+0x15a>
  80281e:	b8 00 00 00 00       	mov    $0x0,%eax
  802823:	a3 48 50 80 00       	mov    %eax,0x805048
  802828:	a1 48 50 80 00       	mov    0x805048,%eax
  80282d:	85 c0                	test   %eax,%eax
  80282f:	75 8a                	jne    8027bb <print_mem_block_lists+0xf2>
  802831:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802835:	75 84                	jne    8027bb <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802837:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80283b:	75 10                	jne    80284d <print_mem_block_lists+0x184>
  80283d:	83 ec 0c             	sub    $0xc,%esp
  802840:	68 dc 43 80 00       	push   $0x8043dc
  802845:	e8 6b e3 ff ff       	call   800bb5 <cprintf>
  80284a:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80284d:	83 ec 0c             	sub    $0xc,%esp
  802850:	68 50 43 80 00       	push   $0x804350
  802855:	e8 5b e3 ff ff       	call   800bb5 <cprintf>
  80285a:	83 c4 10             	add    $0x10,%esp

}
  80285d:	90                   	nop
  80285e:	c9                   	leave  
  80285f:	c3                   	ret    

00802860 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802860:	55                   	push   %ebp
  802861:	89 e5                	mov    %esp,%ebp
  802863:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802866:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80286d:	00 00 00 
  802870:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802877:	00 00 00 
  80287a:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802881:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  802884:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80288b:	e9 9e 00 00 00       	jmp    80292e <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802890:	a1 50 50 80 00       	mov    0x805050,%eax
  802895:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802898:	c1 e2 04             	shl    $0x4,%edx
  80289b:	01 d0                	add    %edx,%eax
  80289d:	85 c0                	test   %eax,%eax
  80289f:	75 14                	jne    8028b5 <initialize_MemBlocksList+0x55>
  8028a1:	83 ec 04             	sub    $0x4,%esp
  8028a4:	68 04 44 80 00       	push   $0x804404
  8028a9:	6a 42                	push   $0x42
  8028ab:	68 27 44 80 00       	push   $0x804427
  8028b0:	e8 4c e0 ff ff       	call   800901 <_panic>
  8028b5:	a1 50 50 80 00       	mov    0x805050,%eax
  8028ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028bd:	c1 e2 04             	shl    $0x4,%edx
  8028c0:	01 d0                	add    %edx,%eax
  8028c2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8028c8:	89 10                	mov    %edx,(%eax)
  8028ca:	8b 00                	mov    (%eax),%eax
  8028cc:	85 c0                	test   %eax,%eax
  8028ce:	74 18                	je     8028e8 <initialize_MemBlocksList+0x88>
  8028d0:	a1 48 51 80 00       	mov    0x805148,%eax
  8028d5:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8028db:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8028de:	c1 e1 04             	shl    $0x4,%ecx
  8028e1:	01 ca                	add    %ecx,%edx
  8028e3:	89 50 04             	mov    %edx,0x4(%eax)
  8028e6:	eb 12                	jmp    8028fa <initialize_MemBlocksList+0x9a>
  8028e8:	a1 50 50 80 00       	mov    0x805050,%eax
  8028ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028f0:	c1 e2 04             	shl    $0x4,%edx
  8028f3:	01 d0                	add    %edx,%eax
  8028f5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028fa:	a1 50 50 80 00       	mov    0x805050,%eax
  8028ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802902:	c1 e2 04             	shl    $0x4,%edx
  802905:	01 d0                	add    %edx,%eax
  802907:	a3 48 51 80 00       	mov    %eax,0x805148
  80290c:	a1 50 50 80 00       	mov    0x805050,%eax
  802911:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802914:	c1 e2 04             	shl    $0x4,%edx
  802917:	01 d0                	add    %edx,%eax
  802919:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802920:	a1 54 51 80 00       	mov    0x805154,%eax
  802925:	40                   	inc    %eax
  802926:	a3 54 51 80 00       	mov    %eax,0x805154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  80292b:	ff 45 f4             	incl   -0xc(%ebp)
  80292e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802931:	3b 45 08             	cmp    0x8(%ebp),%eax
  802934:	0f 82 56 ff ff ff    	jb     802890 <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  80293a:	90                   	nop
  80293b:	c9                   	leave  
  80293c:	c3                   	ret    

0080293d <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80293d:	55                   	push   %ebp
  80293e:	89 e5                	mov    %esp,%ebp
  802940:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  802943:	8b 45 08             	mov    0x8(%ebp),%eax
  802946:	8b 00                	mov    (%eax),%eax
  802948:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80294b:	eb 19                	jmp    802966 <find_block+0x29>
	{
		if(blk->sva==va)
  80294d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802950:	8b 40 08             	mov    0x8(%eax),%eax
  802953:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802956:	75 05                	jne    80295d <find_block+0x20>
			return (blk);
  802958:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80295b:	eb 36                	jmp    802993 <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  80295d:	8b 45 08             	mov    0x8(%ebp),%eax
  802960:	8b 40 08             	mov    0x8(%eax),%eax
  802963:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802966:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80296a:	74 07                	je     802973 <find_block+0x36>
  80296c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80296f:	8b 00                	mov    (%eax),%eax
  802971:	eb 05                	jmp    802978 <find_block+0x3b>
  802973:	b8 00 00 00 00       	mov    $0x0,%eax
  802978:	8b 55 08             	mov    0x8(%ebp),%edx
  80297b:	89 42 08             	mov    %eax,0x8(%edx)
  80297e:	8b 45 08             	mov    0x8(%ebp),%eax
  802981:	8b 40 08             	mov    0x8(%eax),%eax
  802984:	85 c0                	test   %eax,%eax
  802986:	75 c5                	jne    80294d <find_block+0x10>
  802988:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80298c:	75 bf                	jne    80294d <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  80298e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802993:	c9                   	leave  
  802994:	c3                   	ret    

00802995 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802995:	55                   	push   %ebp
  802996:	89 e5                	mov    %esp,%ebp
  802998:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  80299b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8029a3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  8029aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ad:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8029b0:	75 65                	jne    802a17 <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  8029b2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029b6:	75 14                	jne    8029cc <insert_sorted_allocList+0x37>
  8029b8:	83 ec 04             	sub    $0x4,%esp
  8029bb:	68 04 44 80 00       	push   $0x804404
  8029c0:	6a 5c                	push   $0x5c
  8029c2:	68 27 44 80 00       	push   $0x804427
  8029c7:	e8 35 df ff ff       	call   800901 <_panic>
  8029cc:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8029d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d5:	89 10                	mov    %edx,(%eax)
  8029d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029da:	8b 00                	mov    (%eax),%eax
  8029dc:	85 c0                	test   %eax,%eax
  8029de:	74 0d                	je     8029ed <insert_sorted_allocList+0x58>
  8029e0:	a1 40 50 80 00       	mov    0x805040,%eax
  8029e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8029e8:	89 50 04             	mov    %edx,0x4(%eax)
  8029eb:	eb 08                	jmp    8029f5 <insert_sorted_allocList+0x60>
  8029ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f0:	a3 44 50 80 00       	mov    %eax,0x805044
  8029f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f8:	a3 40 50 80 00       	mov    %eax,0x805040
  8029fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802a00:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a07:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a0c:	40                   	inc    %eax
  802a0d:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  802a12:	e9 7b 01 00 00       	jmp    802b92 <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  802a17:	a1 44 50 80 00       	mov    0x805044,%eax
  802a1c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  802a1f:	a1 40 50 80 00       	mov    0x805040,%eax
  802a24:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  802a27:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2a:	8b 50 08             	mov    0x8(%eax),%edx
  802a2d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a30:	8b 40 08             	mov    0x8(%eax),%eax
  802a33:	39 c2                	cmp    %eax,%edx
  802a35:	76 65                	jbe    802a9c <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  802a37:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a3b:	75 14                	jne    802a51 <insert_sorted_allocList+0xbc>
  802a3d:	83 ec 04             	sub    $0x4,%esp
  802a40:	68 40 44 80 00       	push   $0x804440
  802a45:	6a 64                	push   $0x64
  802a47:	68 27 44 80 00       	push   $0x804427
  802a4c:	e8 b0 de ff ff       	call   800901 <_panic>
  802a51:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802a57:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5a:	89 50 04             	mov    %edx,0x4(%eax)
  802a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a60:	8b 40 04             	mov    0x4(%eax),%eax
  802a63:	85 c0                	test   %eax,%eax
  802a65:	74 0c                	je     802a73 <insert_sorted_allocList+0xde>
  802a67:	a1 44 50 80 00       	mov    0x805044,%eax
  802a6c:	8b 55 08             	mov    0x8(%ebp),%edx
  802a6f:	89 10                	mov    %edx,(%eax)
  802a71:	eb 08                	jmp    802a7b <insert_sorted_allocList+0xe6>
  802a73:	8b 45 08             	mov    0x8(%ebp),%eax
  802a76:	a3 40 50 80 00       	mov    %eax,0x805040
  802a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7e:	a3 44 50 80 00       	mov    %eax,0x805044
  802a83:	8b 45 08             	mov    0x8(%ebp),%eax
  802a86:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a8c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a91:	40                   	inc    %eax
  802a92:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  802a97:	e9 f6 00 00 00       	jmp    802b92 <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  802a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9f:	8b 50 08             	mov    0x8(%eax),%edx
  802aa2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802aa5:	8b 40 08             	mov    0x8(%eax),%eax
  802aa8:	39 c2                	cmp    %eax,%edx
  802aaa:	73 65                	jae    802b11 <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802aac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ab0:	75 14                	jne    802ac6 <insert_sorted_allocList+0x131>
  802ab2:	83 ec 04             	sub    $0x4,%esp
  802ab5:	68 04 44 80 00       	push   $0x804404
  802aba:	6a 68                	push   $0x68
  802abc:	68 27 44 80 00       	push   $0x804427
  802ac1:	e8 3b de ff ff       	call   800901 <_panic>
  802ac6:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802acc:	8b 45 08             	mov    0x8(%ebp),%eax
  802acf:	89 10                	mov    %edx,(%eax)
  802ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad4:	8b 00                	mov    (%eax),%eax
  802ad6:	85 c0                	test   %eax,%eax
  802ad8:	74 0d                	je     802ae7 <insert_sorted_allocList+0x152>
  802ada:	a1 40 50 80 00       	mov    0x805040,%eax
  802adf:	8b 55 08             	mov    0x8(%ebp),%edx
  802ae2:	89 50 04             	mov    %edx,0x4(%eax)
  802ae5:	eb 08                	jmp    802aef <insert_sorted_allocList+0x15a>
  802ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aea:	a3 44 50 80 00       	mov    %eax,0x805044
  802aef:	8b 45 08             	mov    0x8(%ebp),%eax
  802af2:	a3 40 50 80 00       	mov    %eax,0x805040
  802af7:	8b 45 08             	mov    0x8(%ebp),%eax
  802afa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b01:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b06:	40                   	inc    %eax
  802b07:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  802b0c:	e9 81 00 00 00       	jmp    802b92 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802b11:	a1 40 50 80 00       	mov    0x805040,%eax
  802b16:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b19:	eb 51                	jmp    802b6c <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  802b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1e:	8b 50 08             	mov    0x8(%eax),%edx
  802b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b24:	8b 40 08             	mov    0x8(%eax),%eax
  802b27:	39 c2                	cmp    %eax,%edx
  802b29:	73 39                	jae    802b64 <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  802b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2e:	8b 40 04             	mov    0x4(%eax),%eax
  802b31:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  802b34:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b37:	8b 55 08             	mov    0x8(%ebp),%edx
  802b3a:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  802b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b42:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  802b45:	8b 45 08             	mov    0x8(%ebp),%eax
  802b48:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b4b:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  802b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b50:	8b 55 08             	mov    0x8(%ebp),%edx
  802b53:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  802b56:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b5b:	40                   	inc    %eax
  802b5c:	a3 4c 50 80 00       	mov    %eax,0x80504c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  802b61:	90                   	nop
				}
			}
		 }

	}
}
  802b62:	eb 2e                	jmp    802b92 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802b64:	a1 48 50 80 00       	mov    0x805048,%eax
  802b69:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b6c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b70:	74 07                	je     802b79 <insert_sorted_allocList+0x1e4>
  802b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b75:	8b 00                	mov    (%eax),%eax
  802b77:	eb 05                	jmp    802b7e <insert_sorted_allocList+0x1e9>
  802b79:	b8 00 00 00 00       	mov    $0x0,%eax
  802b7e:	a3 48 50 80 00       	mov    %eax,0x805048
  802b83:	a1 48 50 80 00       	mov    0x805048,%eax
  802b88:	85 c0                	test   %eax,%eax
  802b8a:	75 8f                	jne    802b1b <insert_sorted_allocList+0x186>
  802b8c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b90:	75 89                	jne    802b1b <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  802b92:	90                   	nop
  802b93:	c9                   	leave  
  802b94:	c3                   	ret    

00802b95 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802b95:	55                   	push   %ebp
  802b96:	89 e5                	mov    %esp,%ebp
  802b98:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802b9b:	a1 38 51 80 00       	mov    0x805138,%eax
  802ba0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ba3:	e9 76 01 00 00       	jmp    802d1e <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  802ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bab:	8b 40 0c             	mov    0xc(%eax),%eax
  802bae:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bb1:	0f 85 8a 00 00 00    	jne    802c41 <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  802bb7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bbb:	75 17                	jne    802bd4 <alloc_block_FF+0x3f>
  802bbd:	83 ec 04             	sub    $0x4,%esp
  802bc0:	68 63 44 80 00       	push   $0x804463
  802bc5:	68 8a 00 00 00       	push   $0x8a
  802bca:	68 27 44 80 00       	push   $0x804427
  802bcf:	e8 2d dd ff ff       	call   800901 <_panic>
  802bd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd7:	8b 00                	mov    (%eax),%eax
  802bd9:	85 c0                	test   %eax,%eax
  802bdb:	74 10                	je     802bed <alloc_block_FF+0x58>
  802bdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be0:	8b 00                	mov    (%eax),%eax
  802be2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802be5:	8b 52 04             	mov    0x4(%edx),%edx
  802be8:	89 50 04             	mov    %edx,0x4(%eax)
  802beb:	eb 0b                	jmp    802bf8 <alloc_block_FF+0x63>
  802bed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf0:	8b 40 04             	mov    0x4(%eax),%eax
  802bf3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfb:	8b 40 04             	mov    0x4(%eax),%eax
  802bfe:	85 c0                	test   %eax,%eax
  802c00:	74 0f                	je     802c11 <alloc_block_FF+0x7c>
  802c02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c05:	8b 40 04             	mov    0x4(%eax),%eax
  802c08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c0b:	8b 12                	mov    (%edx),%edx
  802c0d:	89 10                	mov    %edx,(%eax)
  802c0f:	eb 0a                	jmp    802c1b <alloc_block_FF+0x86>
  802c11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c14:	8b 00                	mov    (%eax),%eax
  802c16:	a3 38 51 80 00       	mov    %eax,0x805138
  802c1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c27:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c2e:	a1 44 51 80 00       	mov    0x805144,%eax
  802c33:	48                   	dec    %eax
  802c34:	a3 44 51 80 00       	mov    %eax,0x805144
			return element;
  802c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3c:	e9 10 01 00 00       	jmp    802d51 <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  802c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c44:	8b 40 0c             	mov    0xc(%eax),%eax
  802c47:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c4a:	0f 86 c6 00 00 00    	jbe    802d16 <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802c50:	a1 48 51 80 00       	mov    0x805148,%eax
  802c55:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802c58:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c5c:	75 17                	jne    802c75 <alloc_block_FF+0xe0>
  802c5e:	83 ec 04             	sub    $0x4,%esp
  802c61:	68 63 44 80 00       	push   $0x804463
  802c66:	68 90 00 00 00       	push   $0x90
  802c6b:	68 27 44 80 00       	push   $0x804427
  802c70:	e8 8c dc ff ff       	call   800901 <_panic>
  802c75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c78:	8b 00                	mov    (%eax),%eax
  802c7a:	85 c0                	test   %eax,%eax
  802c7c:	74 10                	je     802c8e <alloc_block_FF+0xf9>
  802c7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c81:	8b 00                	mov    (%eax),%eax
  802c83:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c86:	8b 52 04             	mov    0x4(%edx),%edx
  802c89:	89 50 04             	mov    %edx,0x4(%eax)
  802c8c:	eb 0b                	jmp    802c99 <alloc_block_FF+0x104>
  802c8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c91:	8b 40 04             	mov    0x4(%eax),%eax
  802c94:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9c:	8b 40 04             	mov    0x4(%eax),%eax
  802c9f:	85 c0                	test   %eax,%eax
  802ca1:	74 0f                	je     802cb2 <alloc_block_FF+0x11d>
  802ca3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca6:	8b 40 04             	mov    0x4(%eax),%eax
  802ca9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802cac:	8b 12                	mov    (%edx),%edx
  802cae:	89 10                	mov    %edx,(%eax)
  802cb0:	eb 0a                	jmp    802cbc <alloc_block_FF+0x127>
  802cb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb5:	8b 00                	mov    (%eax),%eax
  802cb7:	a3 48 51 80 00       	mov    %eax,0x805148
  802cbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cbf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ccf:	a1 54 51 80 00       	mov    0x805154,%eax
  802cd4:	48                   	dec    %eax
  802cd5:	a3 54 51 80 00       	mov    %eax,0x805154
			 element1->size =size;
  802cda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cdd:	8b 55 08             	mov    0x8(%ebp),%edx
  802ce0:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  802ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce6:	8b 50 08             	mov    0x8(%eax),%edx
  802ce9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cec:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  802cef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf2:	8b 50 08             	mov    0x8(%eax),%edx
  802cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf8:	01 c2                	add    %eax,%edx
  802cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfd:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  802d00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d03:	8b 40 0c             	mov    0xc(%eax),%eax
  802d06:	2b 45 08             	sub    0x8(%ebp),%eax
  802d09:	89 c2                	mov    %eax,%edx
  802d0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0e:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  802d11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d14:	eb 3b                	jmp    802d51 <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802d16:	a1 40 51 80 00       	mov    0x805140,%eax
  802d1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d1e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d22:	74 07                	je     802d2b <alloc_block_FF+0x196>
  802d24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d27:	8b 00                	mov    (%eax),%eax
  802d29:	eb 05                	jmp    802d30 <alloc_block_FF+0x19b>
  802d2b:	b8 00 00 00 00       	mov    $0x0,%eax
  802d30:	a3 40 51 80 00       	mov    %eax,0x805140
  802d35:	a1 40 51 80 00       	mov    0x805140,%eax
  802d3a:	85 c0                	test   %eax,%eax
  802d3c:	0f 85 66 fe ff ff    	jne    802ba8 <alloc_block_FF+0x13>
  802d42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d46:	0f 85 5c fe ff ff    	jne    802ba8 <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  802d4c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d51:	c9                   	leave  
  802d52:	c3                   	ret    

00802d53 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802d53:	55                   	push   %ebp
  802d54:	89 e5                	mov    %esp,%ebp
  802d56:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  802d59:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  802d60:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  802d67:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802d6e:	a1 38 51 80 00       	mov    0x805138,%eax
  802d73:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d76:	e9 cf 00 00 00       	jmp    802e4a <alloc_block_BF+0xf7>
		{
			c++;
  802d7b:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  802d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d81:	8b 40 0c             	mov    0xc(%eax),%eax
  802d84:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d87:	0f 85 8a 00 00 00    	jne    802e17 <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  802d8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d91:	75 17                	jne    802daa <alloc_block_BF+0x57>
  802d93:	83 ec 04             	sub    $0x4,%esp
  802d96:	68 63 44 80 00       	push   $0x804463
  802d9b:	68 a8 00 00 00       	push   $0xa8
  802da0:	68 27 44 80 00       	push   $0x804427
  802da5:	e8 57 db ff ff       	call   800901 <_panic>
  802daa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dad:	8b 00                	mov    (%eax),%eax
  802daf:	85 c0                	test   %eax,%eax
  802db1:	74 10                	je     802dc3 <alloc_block_BF+0x70>
  802db3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db6:	8b 00                	mov    (%eax),%eax
  802db8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dbb:	8b 52 04             	mov    0x4(%edx),%edx
  802dbe:	89 50 04             	mov    %edx,0x4(%eax)
  802dc1:	eb 0b                	jmp    802dce <alloc_block_BF+0x7b>
  802dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc6:	8b 40 04             	mov    0x4(%eax),%eax
  802dc9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802dce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd1:	8b 40 04             	mov    0x4(%eax),%eax
  802dd4:	85 c0                	test   %eax,%eax
  802dd6:	74 0f                	je     802de7 <alloc_block_BF+0x94>
  802dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddb:	8b 40 04             	mov    0x4(%eax),%eax
  802dde:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802de1:	8b 12                	mov    (%edx),%edx
  802de3:	89 10                	mov    %edx,(%eax)
  802de5:	eb 0a                	jmp    802df1 <alloc_block_BF+0x9e>
  802de7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dea:	8b 00                	mov    (%eax),%eax
  802dec:	a3 38 51 80 00       	mov    %eax,0x805138
  802df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e04:	a1 44 51 80 00       	mov    0x805144,%eax
  802e09:	48                   	dec    %eax
  802e0a:	a3 44 51 80 00       	mov    %eax,0x805144
				return block;
  802e0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e12:	e9 85 01 00 00       	jmp    802f9c <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  802e17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1a:	8b 40 0c             	mov    0xc(%eax),%eax
  802e1d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e20:	76 20                	jbe    802e42 <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  802e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e25:	8b 40 0c             	mov    0xc(%eax),%eax
  802e28:	2b 45 08             	sub    0x8(%ebp),%eax
  802e2b:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  802e2e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e31:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802e34:	73 0c                	jae    802e42 <alloc_block_BF+0xef>
				{
					ma=tempi;
  802e36:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e39:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  802e3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e3f:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802e42:	a1 40 51 80 00       	mov    0x805140,%eax
  802e47:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e4a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e4e:	74 07                	je     802e57 <alloc_block_BF+0x104>
  802e50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e53:	8b 00                	mov    (%eax),%eax
  802e55:	eb 05                	jmp    802e5c <alloc_block_BF+0x109>
  802e57:	b8 00 00 00 00       	mov    $0x0,%eax
  802e5c:	a3 40 51 80 00       	mov    %eax,0x805140
  802e61:	a1 40 51 80 00       	mov    0x805140,%eax
  802e66:	85 c0                	test   %eax,%eax
  802e68:	0f 85 0d ff ff ff    	jne    802d7b <alloc_block_BF+0x28>
  802e6e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e72:	0f 85 03 ff ff ff    	jne    802d7b <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  802e78:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802e7f:	a1 38 51 80 00       	mov    0x805138,%eax
  802e84:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e87:	e9 dd 00 00 00       	jmp    802f69 <alloc_block_BF+0x216>
		{
			if(x==sol)
  802e8c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e8f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802e92:	0f 85 c6 00 00 00    	jne    802f5e <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802e98:	a1 48 51 80 00       	mov    0x805148,%eax
  802e9d:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802ea0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802ea4:	75 17                	jne    802ebd <alloc_block_BF+0x16a>
  802ea6:	83 ec 04             	sub    $0x4,%esp
  802ea9:	68 63 44 80 00       	push   $0x804463
  802eae:	68 bb 00 00 00       	push   $0xbb
  802eb3:	68 27 44 80 00       	push   $0x804427
  802eb8:	e8 44 da ff ff       	call   800901 <_panic>
  802ebd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ec0:	8b 00                	mov    (%eax),%eax
  802ec2:	85 c0                	test   %eax,%eax
  802ec4:	74 10                	je     802ed6 <alloc_block_BF+0x183>
  802ec6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ec9:	8b 00                	mov    (%eax),%eax
  802ecb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ece:	8b 52 04             	mov    0x4(%edx),%edx
  802ed1:	89 50 04             	mov    %edx,0x4(%eax)
  802ed4:	eb 0b                	jmp    802ee1 <alloc_block_BF+0x18e>
  802ed6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ed9:	8b 40 04             	mov    0x4(%eax),%eax
  802edc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ee1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ee4:	8b 40 04             	mov    0x4(%eax),%eax
  802ee7:	85 c0                	test   %eax,%eax
  802ee9:	74 0f                	je     802efa <alloc_block_BF+0x1a7>
  802eeb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802eee:	8b 40 04             	mov    0x4(%eax),%eax
  802ef1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ef4:	8b 12                	mov    (%edx),%edx
  802ef6:	89 10                	mov    %edx,(%eax)
  802ef8:	eb 0a                	jmp    802f04 <alloc_block_BF+0x1b1>
  802efa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802efd:	8b 00                	mov    (%eax),%eax
  802eff:	a3 48 51 80 00       	mov    %eax,0x805148
  802f04:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f07:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f10:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f17:	a1 54 51 80 00       	mov    0x805154,%eax
  802f1c:	48                   	dec    %eax
  802f1d:	a3 54 51 80 00       	mov    %eax,0x805154
						 element1->size =size;
  802f22:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f25:	8b 55 08             	mov    0x8(%ebp),%edx
  802f28:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  802f2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2e:	8b 50 08             	mov    0x8(%eax),%edx
  802f31:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f34:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  802f37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3a:	8b 50 08             	mov    0x8(%eax),%edx
  802f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f40:	01 c2                	add    %eax,%edx
  802f42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f45:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  802f48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4b:	8b 40 0c             	mov    0xc(%eax),%eax
  802f4e:	2b 45 08             	sub    0x8(%ebp),%eax
  802f51:	89 c2                	mov    %eax,%edx
  802f53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f56:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  802f59:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f5c:	eb 3e                	jmp    802f9c <alloc_block_BF+0x249>
						 break;
			}
			x++;
  802f5e:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802f61:	a1 40 51 80 00       	mov    0x805140,%eax
  802f66:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f69:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f6d:	74 07                	je     802f76 <alloc_block_BF+0x223>
  802f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f72:	8b 00                	mov    (%eax),%eax
  802f74:	eb 05                	jmp    802f7b <alloc_block_BF+0x228>
  802f76:	b8 00 00 00 00       	mov    $0x0,%eax
  802f7b:	a3 40 51 80 00       	mov    %eax,0x805140
  802f80:	a1 40 51 80 00       	mov    0x805140,%eax
  802f85:	85 c0                	test   %eax,%eax
  802f87:	0f 85 ff fe ff ff    	jne    802e8c <alloc_block_BF+0x139>
  802f8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f91:	0f 85 f5 fe ff ff    	jne    802e8c <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  802f97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f9c:	c9                   	leave  
  802f9d:	c3                   	ret    

00802f9e <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802f9e:	55                   	push   %ebp
  802f9f:	89 e5                	mov    %esp,%ebp
  802fa1:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  802fa4:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802fa9:	85 c0                	test   %eax,%eax
  802fab:	75 14                	jne    802fc1 <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  802fad:	a1 38 51 80 00       	mov    0x805138,%eax
  802fb2:	a3 60 51 80 00       	mov    %eax,0x805160
		hh=1;
  802fb7:	c7 05 2c 50 80 00 01 	movl   $0x1,0x80502c
  802fbe:	00 00 00 
	}
	uint32 c=1;
  802fc1:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  802fc8:	a1 60 51 80 00       	mov    0x805160,%eax
  802fcd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802fd0:	e9 b3 01 00 00       	jmp    803188 <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  802fd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fd8:	8b 40 0c             	mov    0xc(%eax),%eax
  802fdb:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fde:	0f 85 a9 00 00 00    	jne    80308d <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  802fe4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe7:	8b 00                	mov    (%eax),%eax
  802fe9:	85 c0                	test   %eax,%eax
  802feb:	75 0c                	jne    802ff9 <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  802fed:	a1 38 51 80 00       	mov    0x805138,%eax
  802ff2:	a3 60 51 80 00       	mov    %eax,0x805160
  802ff7:	eb 0a                	jmp    803003 <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  802ff9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ffc:	8b 00                	mov    (%eax),%eax
  802ffe:	a3 60 51 80 00       	mov    %eax,0x805160
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  803003:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803007:	75 17                	jne    803020 <alloc_block_NF+0x82>
  803009:	83 ec 04             	sub    $0x4,%esp
  80300c:	68 63 44 80 00       	push   $0x804463
  803011:	68 e3 00 00 00       	push   $0xe3
  803016:	68 27 44 80 00       	push   $0x804427
  80301b:	e8 e1 d8 ff ff       	call   800901 <_panic>
  803020:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803023:	8b 00                	mov    (%eax),%eax
  803025:	85 c0                	test   %eax,%eax
  803027:	74 10                	je     803039 <alloc_block_NF+0x9b>
  803029:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80302c:	8b 00                	mov    (%eax),%eax
  80302e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803031:	8b 52 04             	mov    0x4(%edx),%edx
  803034:	89 50 04             	mov    %edx,0x4(%eax)
  803037:	eb 0b                	jmp    803044 <alloc_block_NF+0xa6>
  803039:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80303c:	8b 40 04             	mov    0x4(%eax),%eax
  80303f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803044:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803047:	8b 40 04             	mov    0x4(%eax),%eax
  80304a:	85 c0                	test   %eax,%eax
  80304c:	74 0f                	je     80305d <alloc_block_NF+0xbf>
  80304e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803051:	8b 40 04             	mov    0x4(%eax),%eax
  803054:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803057:	8b 12                	mov    (%edx),%edx
  803059:	89 10                	mov    %edx,(%eax)
  80305b:	eb 0a                	jmp    803067 <alloc_block_NF+0xc9>
  80305d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803060:	8b 00                	mov    (%eax),%eax
  803062:	a3 38 51 80 00       	mov    %eax,0x805138
  803067:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80306a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803070:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803073:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80307a:	a1 44 51 80 00       	mov    0x805144,%eax
  80307f:	48                   	dec    %eax
  803080:	a3 44 51 80 00       	mov    %eax,0x805144
				return element;
  803085:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803088:	e9 0e 01 00 00       	jmp    80319b <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  80308d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803090:	8b 40 0c             	mov    0xc(%eax),%eax
  803093:	3b 45 08             	cmp    0x8(%ebp),%eax
  803096:	0f 86 ce 00 00 00    	jbe    80316a <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  80309c:	a1 48 51 80 00       	mov    0x805148,%eax
  8030a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  8030a4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8030a8:	75 17                	jne    8030c1 <alloc_block_NF+0x123>
  8030aa:	83 ec 04             	sub    $0x4,%esp
  8030ad:	68 63 44 80 00       	push   $0x804463
  8030b2:	68 e9 00 00 00       	push   $0xe9
  8030b7:	68 27 44 80 00       	push   $0x804427
  8030bc:	e8 40 d8 ff ff       	call   800901 <_panic>
  8030c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030c4:	8b 00                	mov    (%eax),%eax
  8030c6:	85 c0                	test   %eax,%eax
  8030c8:	74 10                	je     8030da <alloc_block_NF+0x13c>
  8030ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030cd:	8b 00                	mov    (%eax),%eax
  8030cf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030d2:	8b 52 04             	mov    0x4(%edx),%edx
  8030d5:	89 50 04             	mov    %edx,0x4(%eax)
  8030d8:	eb 0b                	jmp    8030e5 <alloc_block_NF+0x147>
  8030da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030dd:	8b 40 04             	mov    0x4(%eax),%eax
  8030e0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030e8:	8b 40 04             	mov    0x4(%eax),%eax
  8030eb:	85 c0                	test   %eax,%eax
  8030ed:	74 0f                	je     8030fe <alloc_block_NF+0x160>
  8030ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030f2:	8b 40 04             	mov    0x4(%eax),%eax
  8030f5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030f8:	8b 12                	mov    (%edx),%edx
  8030fa:	89 10                	mov    %edx,(%eax)
  8030fc:	eb 0a                	jmp    803108 <alloc_block_NF+0x16a>
  8030fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803101:	8b 00                	mov    (%eax),%eax
  803103:	a3 48 51 80 00       	mov    %eax,0x805148
  803108:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80310b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803111:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803114:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80311b:	a1 54 51 80 00       	mov    0x805154,%eax
  803120:	48                   	dec    %eax
  803121:	a3 54 51 80 00       	mov    %eax,0x805154
				 element1->size =size;
  803126:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803129:	8b 55 08             	mov    0x8(%ebp),%edx
  80312c:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  80312f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803132:	8b 50 08             	mov    0x8(%eax),%edx
  803135:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803138:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  80313b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80313e:	8b 50 08             	mov    0x8(%eax),%edx
  803141:	8b 45 08             	mov    0x8(%ebp),%eax
  803144:	01 c2                	add    %eax,%edx
  803146:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803149:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  80314c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80314f:	8b 40 0c             	mov    0xc(%eax),%eax
  803152:	2b 45 08             	sub    0x8(%ebp),%eax
  803155:	89 c2                	mov    %eax,%edx
  803157:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80315a:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  80315d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803160:	a3 60 51 80 00       	mov    %eax,0x805160
				 return element1;
  803165:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803168:	eb 31                	jmp    80319b <alloc_block_NF+0x1fd>
			 }
		 c++;
  80316a:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  80316d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803170:	8b 00                	mov    (%eax),%eax
  803172:	85 c0                	test   %eax,%eax
  803174:	75 0a                	jne    803180 <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  803176:	a1 38 51 80 00       	mov    0x805138,%eax
  80317b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80317e:	eb 08                	jmp    803188 <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  803180:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803183:	8b 00                	mov    (%eax),%eax
  803185:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  803188:	a1 44 51 80 00       	mov    0x805144,%eax
  80318d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803190:	0f 85 3f fe ff ff    	jne    802fd5 <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  803196:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80319b:	c9                   	leave  
  80319c:	c3                   	ret    

0080319d <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80319d:	55                   	push   %ebp
  80319e:	89 e5                	mov    %esp,%ebp
  8031a0:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  8031a3:	a1 44 51 80 00       	mov    0x805144,%eax
  8031a8:	85 c0                	test   %eax,%eax
  8031aa:	75 68                	jne    803214 <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8031ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031b0:	75 17                	jne    8031c9 <insert_sorted_with_merge_freeList+0x2c>
  8031b2:	83 ec 04             	sub    $0x4,%esp
  8031b5:	68 04 44 80 00       	push   $0x804404
  8031ba:	68 0e 01 00 00       	push   $0x10e
  8031bf:	68 27 44 80 00       	push   $0x804427
  8031c4:	e8 38 d7 ff ff       	call   800901 <_panic>
  8031c9:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8031cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d2:	89 10                	mov    %edx,(%eax)
  8031d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d7:	8b 00                	mov    (%eax),%eax
  8031d9:	85 c0                	test   %eax,%eax
  8031db:	74 0d                	je     8031ea <insert_sorted_with_merge_freeList+0x4d>
  8031dd:	a1 38 51 80 00       	mov    0x805138,%eax
  8031e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8031e5:	89 50 04             	mov    %edx,0x4(%eax)
  8031e8:	eb 08                	jmp    8031f2 <insert_sorted_with_merge_freeList+0x55>
  8031ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ed:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f5:	a3 38 51 80 00       	mov    %eax,0x805138
  8031fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803204:	a1 44 51 80 00       	mov    0x805144,%eax
  803209:	40                   	inc    %eax
  80320a:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  80320f:	e9 8c 06 00 00       	jmp    8038a0 <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  803214:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803219:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  80321c:	a1 38 51 80 00       	mov    0x805138,%eax
  803221:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  803224:	8b 45 08             	mov    0x8(%ebp),%eax
  803227:	8b 50 08             	mov    0x8(%eax),%edx
  80322a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80322d:	8b 40 08             	mov    0x8(%eax),%eax
  803230:	39 c2                	cmp    %eax,%edx
  803232:	0f 86 14 01 00 00    	jbe    80334c <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  803238:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80323b:	8b 50 0c             	mov    0xc(%eax),%edx
  80323e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803241:	8b 40 08             	mov    0x8(%eax),%eax
  803244:	01 c2                	add    %eax,%edx
  803246:	8b 45 08             	mov    0x8(%ebp),%eax
  803249:	8b 40 08             	mov    0x8(%eax),%eax
  80324c:	39 c2                	cmp    %eax,%edx
  80324e:	0f 85 90 00 00 00    	jne    8032e4 <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  803254:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803257:	8b 50 0c             	mov    0xc(%eax),%edx
  80325a:	8b 45 08             	mov    0x8(%ebp),%eax
  80325d:	8b 40 0c             	mov    0xc(%eax),%eax
  803260:	01 c2                	add    %eax,%edx
  803262:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803265:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  803268:	8b 45 08             	mov    0x8(%ebp),%eax
  80326b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  803272:	8b 45 08             	mov    0x8(%ebp),%eax
  803275:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80327c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803280:	75 17                	jne    803299 <insert_sorted_with_merge_freeList+0xfc>
  803282:	83 ec 04             	sub    $0x4,%esp
  803285:	68 04 44 80 00       	push   $0x804404
  80328a:	68 1b 01 00 00       	push   $0x11b
  80328f:	68 27 44 80 00       	push   $0x804427
  803294:	e8 68 d6 ff ff       	call   800901 <_panic>
  803299:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80329f:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a2:	89 10                	mov    %edx,(%eax)
  8032a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a7:	8b 00                	mov    (%eax),%eax
  8032a9:	85 c0                	test   %eax,%eax
  8032ab:	74 0d                	je     8032ba <insert_sorted_with_merge_freeList+0x11d>
  8032ad:	a1 48 51 80 00       	mov    0x805148,%eax
  8032b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8032b5:	89 50 04             	mov    %edx,0x4(%eax)
  8032b8:	eb 08                	jmp    8032c2 <insert_sorted_with_merge_freeList+0x125>
  8032ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c5:	a3 48 51 80 00       	mov    %eax,0x805148
  8032ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032d4:	a1 54 51 80 00       	mov    0x805154,%eax
  8032d9:	40                   	inc    %eax
  8032da:	a3 54 51 80 00       	mov    %eax,0x805154
							}

						}
		          }
		}
}
  8032df:	e9 bc 05 00 00       	jmp    8038a0 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8032e4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032e8:	75 17                	jne    803301 <insert_sorted_with_merge_freeList+0x164>
  8032ea:	83 ec 04             	sub    $0x4,%esp
  8032ed:	68 40 44 80 00       	push   $0x804440
  8032f2:	68 1f 01 00 00       	push   $0x11f
  8032f7:	68 27 44 80 00       	push   $0x804427
  8032fc:	e8 00 d6 ff ff       	call   800901 <_panic>
  803301:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803307:	8b 45 08             	mov    0x8(%ebp),%eax
  80330a:	89 50 04             	mov    %edx,0x4(%eax)
  80330d:	8b 45 08             	mov    0x8(%ebp),%eax
  803310:	8b 40 04             	mov    0x4(%eax),%eax
  803313:	85 c0                	test   %eax,%eax
  803315:	74 0c                	je     803323 <insert_sorted_with_merge_freeList+0x186>
  803317:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80331c:	8b 55 08             	mov    0x8(%ebp),%edx
  80331f:	89 10                	mov    %edx,(%eax)
  803321:	eb 08                	jmp    80332b <insert_sorted_with_merge_freeList+0x18e>
  803323:	8b 45 08             	mov    0x8(%ebp),%eax
  803326:	a3 38 51 80 00       	mov    %eax,0x805138
  80332b:	8b 45 08             	mov    0x8(%ebp),%eax
  80332e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803333:	8b 45 08             	mov    0x8(%ebp),%eax
  803336:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80333c:	a1 44 51 80 00       	mov    0x805144,%eax
  803341:	40                   	inc    %eax
  803342:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  803347:	e9 54 05 00 00       	jmp    8038a0 <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  80334c:	8b 45 08             	mov    0x8(%ebp),%eax
  80334f:	8b 50 08             	mov    0x8(%eax),%edx
  803352:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803355:	8b 40 08             	mov    0x8(%eax),%eax
  803358:	39 c2                	cmp    %eax,%edx
  80335a:	0f 83 20 01 00 00    	jae    803480 <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  803360:	8b 45 08             	mov    0x8(%ebp),%eax
  803363:	8b 50 0c             	mov    0xc(%eax),%edx
  803366:	8b 45 08             	mov    0x8(%ebp),%eax
  803369:	8b 40 08             	mov    0x8(%eax),%eax
  80336c:	01 c2                	add    %eax,%edx
  80336e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803371:	8b 40 08             	mov    0x8(%eax),%eax
  803374:	39 c2                	cmp    %eax,%edx
  803376:	0f 85 9c 00 00 00    	jne    803418 <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  80337c:	8b 45 08             	mov    0x8(%ebp),%eax
  80337f:	8b 50 08             	mov    0x8(%eax),%edx
  803382:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803385:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  803388:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80338b:	8b 50 0c             	mov    0xc(%eax),%edx
  80338e:	8b 45 08             	mov    0x8(%ebp),%eax
  803391:	8b 40 0c             	mov    0xc(%eax),%eax
  803394:	01 c2                	add    %eax,%edx
  803396:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803399:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  80339c:	8b 45 08             	mov    0x8(%ebp),%eax
  80339f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  8033a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8033b0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033b4:	75 17                	jne    8033cd <insert_sorted_with_merge_freeList+0x230>
  8033b6:	83 ec 04             	sub    $0x4,%esp
  8033b9:	68 04 44 80 00       	push   $0x804404
  8033be:	68 2a 01 00 00       	push   $0x12a
  8033c3:	68 27 44 80 00       	push   $0x804427
  8033c8:	e8 34 d5 ff ff       	call   800901 <_panic>
  8033cd:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d6:	89 10                	mov    %edx,(%eax)
  8033d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033db:	8b 00                	mov    (%eax),%eax
  8033dd:	85 c0                	test   %eax,%eax
  8033df:	74 0d                	je     8033ee <insert_sorted_with_merge_freeList+0x251>
  8033e1:	a1 48 51 80 00       	mov    0x805148,%eax
  8033e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8033e9:	89 50 04             	mov    %edx,0x4(%eax)
  8033ec:	eb 08                	jmp    8033f6 <insert_sorted_with_merge_freeList+0x259>
  8033ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f9:	a3 48 51 80 00       	mov    %eax,0x805148
  8033fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803401:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803408:	a1 54 51 80 00       	mov    0x805154,%eax
  80340d:	40                   	inc    %eax
  80340e:	a3 54 51 80 00       	mov    %eax,0x805154
							}

						}
		          }
		}
}
  803413:	e9 88 04 00 00       	jmp    8038a0 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  803418:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80341c:	75 17                	jne    803435 <insert_sorted_with_merge_freeList+0x298>
  80341e:	83 ec 04             	sub    $0x4,%esp
  803421:	68 04 44 80 00       	push   $0x804404
  803426:	68 2e 01 00 00       	push   $0x12e
  80342b:	68 27 44 80 00       	push   $0x804427
  803430:	e8 cc d4 ff ff       	call   800901 <_panic>
  803435:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80343b:	8b 45 08             	mov    0x8(%ebp),%eax
  80343e:	89 10                	mov    %edx,(%eax)
  803440:	8b 45 08             	mov    0x8(%ebp),%eax
  803443:	8b 00                	mov    (%eax),%eax
  803445:	85 c0                	test   %eax,%eax
  803447:	74 0d                	je     803456 <insert_sorted_with_merge_freeList+0x2b9>
  803449:	a1 38 51 80 00       	mov    0x805138,%eax
  80344e:	8b 55 08             	mov    0x8(%ebp),%edx
  803451:	89 50 04             	mov    %edx,0x4(%eax)
  803454:	eb 08                	jmp    80345e <insert_sorted_with_merge_freeList+0x2c1>
  803456:	8b 45 08             	mov    0x8(%ebp),%eax
  803459:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80345e:	8b 45 08             	mov    0x8(%ebp),%eax
  803461:	a3 38 51 80 00       	mov    %eax,0x805138
  803466:	8b 45 08             	mov    0x8(%ebp),%eax
  803469:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803470:	a1 44 51 80 00       	mov    0x805144,%eax
  803475:	40                   	inc    %eax
  803476:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  80347b:	e9 20 04 00 00       	jmp    8038a0 <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  803480:	a1 38 51 80 00       	mov    0x805138,%eax
  803485:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803488:	e9 e2 03 00 00       	jmp    80386f <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  80348d:	8b 45 08             	mov    0x8(%ebp),%eax
  803490:	8b 50 08             	mov    0x8(%eax),%edx
  803493:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803496:	8b 40 08             	mov    0x8(%eax),%eax
  803499:	39 c2                	cmp    %eax,%edx
  80349b:	0f 83 c6 03 00 00    	jae    803867 <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  8034a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a4:	8b 40 04             	mov    0x4(%eax),%eax
  8034a7:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  8034aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ad:	8b 50 08             	mov    0x8(%eax),%edx
  8034b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8034b6:	01 d0                	add    %edx,%eax
  8034b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  8034bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8034be:	8b 50 0c             	mov    0xc(%eax),%edx
  8034c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c4:	8b 40 08             	mov    0x8(%eax),%eax
  8034c7:	01 d0                	add    %edx,%eax
  8034c9:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  8034cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8034cf:	8b 40 08             	mov    0x8(%eax),%eax
  8034d2:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8034d5:	74 7a                	je     803551 <insert_sorted_with_merge_freeList+0x3b4>
  8034d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034da:	8b 40 08             	mov    0x8(%eax),%eax
  8034dd:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8034e0:	74 6f                	je     803551 <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  8034e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034e6:	74 06                	je     8034ee <insert_sorted_with_merge_freeList+0x351>
  8034e8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034ec:	75 17                	jne    803505 <insert_sorted_with_merge_freeList+0x368>
  8034ee:	83 ec 04             	sub    $0x4,%esp
  8034f1:	68 84 44 80 00       	push   $0x804484
  8034f6:	68 43 01 00 00       	push   $0x143
  8034fb:	68 27 44 80 00       	push   $0x804427
  803500:	e8 fc d3 ff ff       	call   800901 <_panic>
  803505:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803508:	8b 50 04             	mov    0x4(%eax),%edx
  80350b:	8b 45 08             	mov    0x8(%ebp),%eax
  80350e:	89 50 04             	mov    %edx,0x4(%eax)
  803511:	8b 45 08             	mov    0x8(%ebp),%eax
  803514:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803517:	89 10                	mov    %edx,(%eax)
  803519:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80351c:	8b 40 04             	mov    0x4(%eax),%eax
  80351f:	85 c0                	test   %eax,%eax
  803521:	74 0d                	je     803530 <insert_sorted_with_merge_freeList+0x393>
  803523:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803526:	8b 40 04             	mov    0x4(%eax),%eax
  803529:	8b 55 08             	mov    0x8(%ebp),%edx
  80352c:	89 10                	mov    %edx,(%eax)
  80352e:	eb 08                	jmp    803538 <insert_sorted_with_merge_freeList+0x39b>
  803530:	8b 45 08             	mov    0x8(%ebp),%eax
  803533:	a3 38 51 80 00       	mov    %eax,0x805138
  803538:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80353b:	8b 55 08             	mov    0x8(%ebp),%edx
  80353e:	89 50 04             	mov    %edx,0x4(%eax)
  803541:	a1 44 51 80 00       	mov    0x805144,%eax
  803546:	40                   	inc    %eax
  803547:	a3 44 51 80 00       	mov    %eax,0x805144
  80354c:	e9 14 03 00 00       	jmp    803865 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  803551:	8b 45 08             	mov    0x8(%ebp),%eax
  803554:	8b 40 08             	mov    0x8(%eax),%eax
  803557:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80355a:	0f 85 a0 01 00 00    	jne    803700 <insert_sorted_with_merge_freeList+0x563>
  803560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803563:	8b 40 08             	mov    0x8(%eax),%eax
  803566:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803569:	0f 85 91 01 00 00    	jne    803700 <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  80356f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803572:	8b 50 0c             	mov    0xc(%eax),%edx
  803575:	8b 45 08             	mov    0x8(%ebp),%eax
  803578:	8b 48 0c             	mov    0xc(%eax),%ecx
  80357b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80357e:	8b 40 0c             	mov    0xc(%eax),%eax
  803581:	01 c8                	add    %ecx,%eax
  803583:	01 c2                	add    %eax,%edx
  803585:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803588:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  80358b:	8b 45 08             	mov    0x8(%ebp),%eax
  80358e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  803595:	8b 45 08             	mov    0x8(%ebp),%eax
  803598:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  80359f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  8035a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ac:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8035b3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035b7:	75 17                	jne    8035d0 <insert_sorted_with_merge_freeList+0x433>
  8035b9:	83 ec 04             	sub    $0x4,%esp
  8035bc:	68 04 44 80 00       	push   $0x804404
  8035c1:	68 4d 01 00 00       	push   $0x14d
  8035c6:	68 27 44 80 00       	push   $0x804427
  8035cb:	e8 31 d3 ff ff       	call   800901 <_panic>
  8035d0:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d9:	89 10                	mov    %edx,(%eax)
  8035db:	8b 45 08             	mov    0x8(%ebp),%eax
  8035de:	8b 00                	mov    (%eax),%eax
  8035e0:	85 c0                	test   %eax,%eax
  8035e2:	74 0d                	je     8035f1 <insert_sorted_with_merge_freeList+0x454>
  8035e4:	a1 48 51 80 00       	mov    0x805148,%eax
  8035e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8035ec:	89 50 04             	mov    %edx,0x4(%eax)
  8035ef:	eb 08                	jmp    8035f9 <insert_sorted_with_merge_freeList+0x45c>
  8035f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fc:	a3 48 51 80 00       	mov    %eax,0x805148
  803601:	8b 45 08             	mov    0x8(%ebp),%eax
  803604:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80360b:	a1 54 51 80 00       	mov    0x805154,%eax
  803610:	40                   	inc    %eax
  803611:	a3 54 51 80 00       	mov    %eax,0x805154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  803616:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80361a:	75 17                	jne    803633 <insert_sorted_with_merge_freeList+0x496>
  80361c:	83 ec 04             	sub    $0x4,%esp
  80361f:	68 63 44 80 00       	push   $0x804463
  803624:	68 4e 01 00 00       	push   $0x14e
  803629:	68 27 44 80 00       	push   $0x804427
  80362e:	e8 ce d2 ff ff       	call   800901 <_panic>
  803633:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803636:	8b 00                	mov    (%eax),%eax
  803638:	85 c0                	test   %eax,%eax
  80363a:	74 10                	je     80364c <insert_sorted_with_merge_freeList+0x4af>
  80363c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80363f:	8b 00                	mov    (%eax),%eax
  803641:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803644:	8b 52 04             	mov    0x4(%edx),%edx
  803647:	89 50 04             	mov    %edx,0x4(%eax)
  80364a:	eb 0b                	jmp    803657 <insert_sorted_with_merge_freeList+0x4ba>
  80364c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80364f:	8b 40 04             	mov    0x4(%eax),%eax
  803652:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803657:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80365a:	8b 40 04             	mov    0x4(%eax),%eax
  80365d:	85 c0                	test   %eax,%eax
  80365f:	74 0f                	je     803670 <insert_sorted_with_merge_freeList+0x4d3>
  803661:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803664:	8b 40 04             	mov    0x4(%eax),%eax
  803667:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80366a:	8b 12                	mov    (%edx),%edx
  80366c:	89 10                	mov    %edx,(%eax)
  80366e:	eb 0a                	jmp    80367a <insert_sorted_with_merge_freeList+0x4dd>
  803670:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803673:	8b 00                	mov    (%eax),%eax
  803675:	a3 38 51 80 00       	mov    %eax,0x805138
  80367a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80367d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803686:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80368d:	a1 44 51 80 00       	mov    0x805144,%eax
  803692:	48                   	dec    %eax
  803693:	a3 44 51 80 00       	mov    %eax,0x805144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  803698:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80369c:	75 17                	jne    8036b5 <insert_sorted_with_merge_freeList+0x518>
  80369e:	83 ec 04             	sub    $0x4,%esp
  8036a1:	68 04 44 80 00       	push   $0x804404
  8036a6:	68 4f 01 00 00       	push   $0x14f
  8036ab:	68 27 44 80 00       	push   $0x804427
  8036b0:	e8 4c d2 ff ff       	call   800901 <_panic>
  8036b5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8036bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036be:	89 10                	mov    %edx,(%eax)
  8036c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c3:	8b 00                	mov    (%eax),%eax
  8036c5:	85 c0                	test   %eax,%eax
  8036c7:	74 0d                	je     8036d6 <insert_sorted_with_merge_freeList+0x539>
  8036c9:	a1 48 51 80 00       	mov    0x805148,%eax
  8036ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036d1:	89 50 04             	mov    %edx,0x4(%eax)
  8036d4:	eb 08                	jmp    8036de <insert_sorted_with_merge_freeList+0x541>
  8036d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e1:	a3 48 51 80 00       	mov    %eax,0x805148
  8036e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036f0:	a1 54 51 80 00       	mov    0x805154,%eax
  8036f5:	40                   	inc    %eax
  8036f6:	a3 54 51 80 00       	mov    %eax,0x805154
  8036fb:	e9 65 01 00 00       	jmp    803865 <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  803700:	8b 45 08             	mov    0x8(%ebp),%eax
  803703:	8b 40 08             	mov    0x8(%eax),%eax
  803706:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803709:	0f 85 9f 00 00 00    	jne    8037ae <insert_sorted_with_merge_freeList+0x611>
  80370f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803712:	8b 40 08             	mov    0x8(%eax),%eax
  803715:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803718:	0f 84 90 00 00 00    	je     8037ae <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  80371e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803721:	8b 50 0c             	mov    0xc(%eax),%edx
  803724:	8b 45 08             	mov    0x8(%ebp),%eax
  803727:	8b 40 0c             	mov    0xc(%eax),%eax
  80372a:	01 c2                	add    %eax,%edx
  80372c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80372f:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  803732:	8b 45 08             	mov    0x8(%ebp),%eax
  803735:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  80373c:	8b 45 08             	mov    0x8(%ebp),%eax
  80373f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803746:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80374a:	75 17                	jne    803763 <insert_sorted_with_merge_freeList+0x5c6>
  80374c:	83 ec 04             	sub    $0x4,%esp
  80374f:	68 04 44 80 00       	push   $0x804404
  803754:	68 58 01 00 00       	push   $0x158
  803759:	68 27 44 80 00       	push   $0x804427
  80375e:	e8 9e d1 ff ff       	call   800901 <_panic>
  803763:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803769:	8b 45 08             	mov    0x8(%ebp),%eax
  80376c:	89 10                	mov    %edx,(%eax)
  80376e:	8b 45 08             	mov    0x8(%ebp),%eax
  803771:	8b 00                	mov    (%eax),%eax
  803773:	85 c0                	test   %eax,%eax
  803775:	74 0d                	je     803784 <insert_sorted_with_merge_freeList+0x5e7>
  803777:	a1 48 51 80 00       	mov    0x805148,%eax
  80377c:	8b 55 08             	mov    0x8(%ebp),%edx
  80377f:	89 50 04             	mov    %edx,0x4(%eax)
  803782:	eb 08                	jmp    80378c <insert_sorted_with_merge_freeList+0x5ef>
  803784:	8b 45 08             	mov    0x8(%ebp),%eax
  803787:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80378c:	8b 45 08             	mov    0x8(%ebp),%eax
  80378f:	a3 48 51 80 00       	mov    %eax,0x805148
  803794:	8b 45 08             	mov    0x8(%ebp),%eax
  803797:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80379e:	a1 54 51 80 00       	mov    0x805154,%eax
  8037a3:	40                   	inc    %eax
  8037a4:	a3 54 51 80 00       	mov    %eax,0x805154
  8037a9:	e9 b7 00 00 00       	jmp    803865 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  8037ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b1:	8b 40 08             	mov    0x8(%eax),%eax
  8037b4:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8037b7:	0f 84 e2 00 00 00    	je     80389f <insert_sorted_with_merge_freeList+0x702>
  8037bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037c0:	8b 40 08             	mov    0x8(%eax),%eax
  8037c3:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8037c6:	0f 85 d3 00 00 00    	jne    80389f <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  8037cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8037cf:	8b 50 08             	mov    0x8(%eax),%edx
  8037d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037d5:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  8037d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037db:	8b 50 0c             	mov    0xc(%eax),%edx
  8037de:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8037e4:	01 c2                	add    %eax,%edx
  8037e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037e9:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  8037ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ef:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  8037f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803800:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803804:	75 17                	jne    80381d <insert_sorted_with_merge_freeList+0x680>
  803806:	83 ec 04             	sub    $0x4,%esp
  803809:	68 04 44 80 00       	push   $0x804404
  80380e:	68 61 01 00 00       	push   $0x161
  803813:	68 27 44 80 00       	push   $0x804427
  803818:	e8 e4 d0 ff ff       	call   800901 <_panic>
  80381d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803823:	8b 45 08             	mov    0x8(%ebp),%eax
  803826:	89 10                	mov    %edx,(%eax)
  803828:	8b 45 08             	mov    0x8(%ebp),%eax
  80382b:	8b 00                	mov    (%eax),%eax
  80382d:	85 c0                	test   %eax,%eax
  80382f:	74 0d                	je     80383e <insert_sorted_with_merge_freeList+0x6a1>
  803831:	a1 48 51 80 00       	mov    0x805148,%eax
  803836:	8b 55 08             	mov    0x8(%ebp),%edx
  803839:	89 50 04             	mov    %edx,0x4(%eax)
  80383c:	eb 08                	jmp    803846 <insert_sorted_with_merge_freeList+0x6a9>
  80383e:	8b 45 08             	mov    0x8(%ebp),%eax
  803841:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803846:	8b 45 08             	mov    0x8(%ebp),%eax
  803849:	a3 48 51 80 00       	mov    %eax,0x805148
  80384e:	8b 45 08             	mov    0x8(%ebp),%eax
  803851:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803858:	a1 54 51 80 00       	mov    0x805154,%eax
  80385d:	40                   	inc    %eax
  80385e:	a3 54 51 80 00       	mov    %eax,0x805154
								}
								break;
  803863:	eb 3a                	jmp    80389f <insert_sorted_with_merge_freeList+0x702>
  803865:	eb 38                	jmp    80389f <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  803867:	a1 40 51 80 00       	mov    0x805140,%eax
  80386c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80386f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803873:	74 07                	je     80387c <insert_sorted_with_merge_freeList+0x6df>
  803875:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803878:	8b 00                	mov    (%eax),%eax
  80387a:	eb 05                	jmp    803881 <insert_sorted_with_merge_freeList+0x6e4>
  80387c:	b8 00 00 00 00       	mov    $0x0,%eax
  803881:	a3 40 51 80 00       	mov    %eax,0x805140
  803886:	a1 40 51 80 00       	mov    0x805140,%eax
  80388b:	85 c0                	test   %eax,%eax
  80388d:	0f 85 fa fb ff ff    	jne    80348d <insert_sorted_with_merge_freeList+0x2f0>
  803893:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803897:	0f 85 f0 fb ff ff    	jne    80348d <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  80389d:	eb 01                	jmp    8038a0 <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  80389f:	90                   	nop
							}

						}
		          }
		}
}
  8038a0:	90                   	nop
  8038a1:	c9                   	leave  
  8038a2:	c3                   	ret    
  8038a3:	90                   	nop

008038a4 <__udivdi3>:
  8038a4:	55                   	push   %ebp
  8038a5:	57                   	push   %edi
  8038a6:	56                   	push   %esi
  8038a7:	53                   	push   %ebx
  8038a8:	83 ec 1c             	sub    $0x1c,%esp
  8038ab:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8038af:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8038b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8038b7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8038bb:	89 ca                	mov    %ecx,%edx
  8038bd:	89 f8                	mov    %edi,%eax
  8038bf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8038c3:	85 f6                	test   %esi,%esi
  8038c5:	75 2d                	jne    8038f4 <__udivdi3+0x50>
  8038c7:	39 cf                	cmp    %ecx,%edi
  8038c9:	77 65                	ja     803930 <__udivdi3+0x8c>
  8038cb:	89 fd                	mov    %edi,%ebp
  8038cd:	85 ff                	test   %edi,%edi
  8038cf:	75 0b                	jne    8038dc <__udivdi3+0x38>
  8038d1:	b8 01 00 00 00       	mov    $0x1,%eax
  8038d6:	31 d2                	xor    %edx,%edx
  8038d8:	f7 f7                	div    %edi
  8038da:	89 c5                	mov    %eax,%ebp
  8038dc:	31 d2                	xor    %edx,%edx
  8038de:	89 c8                	mov    %ecx,%eax
  8038e0:	f7 f5                	div    %ebp
  8038e2:	89 c1                	mov    %eax,%ecx
  8038e4:	89 d8                	mov    %ebx,%eax
  8038e6:	f7 f5                	div    %ebp
  8038e8:	89 cf                	mov    %ecx,%edi
  8038ea:	89 fa                	mov    %edi,%edx
  8038ec:	83 c4 1c             	add    $0x1c,%esp
  8038ef:	5b                   	pop    %ebx
  8038f0:	5e                   	pop    %esi
  8038f1:	5f                   	pop    %edi
  8038f2:	5d                   	pop    %ebp
  8038f3:	c3                   	ret    
  8038f4:	39 ce                	cmp    %ecx,%esi
  8038f6:	77 28                	ja     803920 <__udivdi3+0x7c>
  8038f8:	0f bd fe             	bsr    %esi,%edi
  8038fb:	83 f7 1f             	xor    $0x1f,%edi
  8038fe:	75 40                	jne    803940 <__udivdi3+0x9c>
  803900:	39 ce                	cmp    %ecx,%esi
  803902:	72 0a                	jb     80390e <__udivdi3+0x6a>
  803904:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803908:	0f 87 9e 00 00 00    	ja     8039ac <__udivdi3+0x108>
  80390e:	b8 01 00 00 00       	mov    $0x1,%eax
  803913:	89 fa                	mov    %edi,%edx
  803915:	83 c4 1c             	add    $0x1c,%esp
  803918:	5b                   	pop    %ebx
  803919:	5e                   	pop    %esi
  80391a:	5f                   	pop    %edi
  80391b:	5d                   	pop    %ebp
  80391c:	c3                   	ret    
  80391d:	8d 76 00             	lea    0x0(%esi),%esi
  803920:	31 ff                	xor    %edi,%edi
  803922:	31 c0                	xor    %eax,%eax
  803924:	89 fa                	mov    %edi,%edx
  803926:	83 c4 1c             	add    $0x1c,%esp
  803929:	5b                   	pop    %ebx
  80392a:	5e                   	pop    %esi
  80392b:	5f                   	pop    %edi
  80392c:	5d                   	pop    %ebp
  80392d:	c3                   	ret    
  80392e:	66 90                	xchg   %ax,%ax
  803930:	89 d8                	mov    %ebx,%eax
  803932:	f7 f7                	div    %edi
  803934:	31 ff                	xor    %edi,%edi
  803936:	89 fa                	mov    %edi,%edx
  803938:	83 c4 1c             	add    $0x1c,%esp
  80393b:	5b                   	pop    %ebx
  80393c:	5e                   	pop    %esi
  80393d:	5f                   	pop    %edi
  80393e:	5d                   	pop    %ebp
  80393f:	c3                   	ret    
  803940:	bd 20 00 00 00       	mov    $0x20,%ebp
  803945:	89 eb                	mov    %ebp,%ebx
  803947:	29 fb                	sub    %edi,%ebx
  803949:	89 f9                	mov    %edi,%ecx
  80394b:	d3 e6                	shl    %cl,%esi
  80394d:	89 c5                	mov    %eax,%ebp
  80394f:	88 d9                	mov    %bl,%cl
  803951:	d3 ed                	shr    %cl,%ebp
  803953:	89 e9                	mov    %ebp,%ecx
  803955:	09 f1                	or     %esi,%ecx
  803957:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80395b:	89 f9                	mov    %edi,%ecx
  80395d:	d3 e0                	shl    %cl,%eax
  80395f:	89 c5                	mov    %eax,%ebp
  803961:	89 d6                	mov    %edx,%esi
  803963:	88 d9                	mov    %bl,%cl
  803965:	d3 ee                	shr    %cl,%esi
  803967:	89 f9                	mov    %edi,%ecx
  803969:	d3 e2                	shl    %cl,%edx
  80396b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80396f:	88 d9                	mov    %bl,%cl
  803971:	d3 e8                	shr    %cl,%eax
  803973:	09 c2                	or     %eax,%edx
  803975:	89 d0                	mov    %edx,%eax
  803977:	89 f2                	mov    %esi,%edx
  803979:	f7 74 24 0c          	divl   0xc(%esp)
  80397d:	89 d6                	mov    %edx,%esi
  80397f:	89 c3                	mov    %eax,%ebx
  803981:	f7 e5                	mul    %ebp
  803983:	39 d6                	cmp    %edx,%esi
  803985:	72 19                	jb     8039a0 <__udivdi3+0xfc>
  803987:	74 0b                	je     803994 <__udivdi3+0xf0>
  803989:	89 d8                	mov    %ebx,%eax
  80398b:	31 ff                	xor    %edi,%edi
  80398d:	e9 58 ff ff ff       	jmp    8038ea <__udivdi3+0x46>
  803992:	66 90                	xchg   %ax,%ax
  803994:	8b 54 24 08          	mov    0x8(%esp),%edx
  803998:	89 f9                	mov    %edi,%ecx
  80399a:	d3 e2                	shl    %cl,%edx
  80399c:	39 c2                	cmp    %eax,%edx
  80399e:	73 e9                	jae    803989 <__udivdi3+0xe5>
  8039a0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8039a3:	31 ff                	xor    %edi,%edi
  8039a5:	e9 40 ff ff ff       	jmp    8038ea <__udivdi3+0x46>
  8039aa:	66 90                	xchg   %ax,%ax
  8039ac:	31 c0                	xor    %eax,%eax
  8039ae:	e9 37 ff ff ff       	jmp    8038ea <__udivdi3+0x46>
  8039b3:	90                   	nop

008039b4 <__umoddi3>:
  8039b4:	55                   	push   %ebp
  8039b5:	57                   	push   %edi
  8039b6:	56                   	push   %esi
  8039b7:	53                   	push   %ebx
  8039b8:	83 ec 1c             	sub    $0x1c,%esp
  8039bb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8039bf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8039c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039c7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8039cb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8039cf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8039d3:	89 f3                	mov    %esi,%ebx
  8039d5:	89 fa                	mov    %edi,%edx
  8039d7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8039db:	89 34 24             	mov    %esi,(%esp)
  8039de:	85 c0                	test   %eax,%eax
  8039e0:	75 1a                	jne    8039fc <__umoddi3+0x48>
  8039e2:	39 f7                	cmp    %esi,%edi
  8039e4:	0f 86 a2 00 00 00    	jbe    803a8c <__umoddi3+0xd8>
  8039ea:	89 c8                	mov    %ecx,%eax
  8039ec:	89 f2                	mov    %esi,%edx
  8039ee:	f7 f7                	div    %edi
  8039f0:	89 d0                	mov    %edx,%eax
  8039f2:	31 d2                	xor    %edx,%edx
  8039f4:	83 c4 1c             	add    $0x1c,%esp
  8039f7:	5b                   	pop    %ebx
  8039f8:	5e                   	pop    %esi
  8039f9:	5f                   	pop    %edi
  8039fa:	5d                   	pop    %ebp
  8039fb:	c3                   	ret    
  8039fc:	39 f0                	cmp    %esi,%eax
  8039fe:	0f 87 ac 00 00 00    	ja     803ab0 <__umoddi3+0xfc>
  803a04:	0f bd e8             	bsr    %eax,%ebp
  803a07:	83 f5 1f             	xor    $0x1f,%ebp
  803a0a:	0f 84 ac 00 00 00    	je     803abc <__umoddi3+0x108>
  803a10:	bf 20 00 00 00       	mov    $0x20,%edi
  803a15:	29 ef                	sub    %ebp,%edi
  803a17:	89 fe                	mov    %edi,%esi
  803a19:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803a1d:	89 e9                	mov    %ebp,%ecx
  803a1f:	d3 e0                	shl    %cl,%eax
  803a21:	89 d7                	mov    %edx,%edi
  803a23:	89 f1                	mov    %esi,%ecx
  803a25:	d3 ef                	shr    %cl,%edi
  803a27:	09 c7                	or     %eax,%edi
  803a29:	89 e9                	mov    %ebp,%ecx
  803a2b:	d3 e2                	shl    %cl,%edx
  803a2d:	89 14 24             	mov    %edx,(%esp)
  803a30:	89 d8                	mov    %ebx,%eax
  803a32:	d3 e0                	shl    %cl,%eax
  803a34:	89 c2                	mov    %eax,%edx
  803a36:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a3a:	d3 e0                	shl    %cl,%eax
  803a3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a40:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a44:	89 f1                	mov    %esi,%ecx
  803a46:	d3 e8                	shr    %cl,%eax
  803a48:	09 d0                	or     %edx,%eax
  803a4a:	d3 eb                	shr    %cl,%ebx
  803a4c:	89 da                	mov    %ebx,%edx
  803a4e:	f7 f7                	div    %edi
  803a50:	89 d3                	mov    %edx,%ebx
  803a52:	f7 24 24             	mull   (%esp)
  803a55:	89 c6                	mov    %eax,%esi
  803a57:	89 d1                	mov    %edx,%ecx
  803a59:	39 d3                	cmp    %edx,%ebx
  803a5b:	0f 82 87 00 00 00    	jb     803ae8 <__umoddi3+0x134>
  803a61:	0f 84 91 00 00 00    	je     803af8 <__umoddi3+0x144>
  803a67:	8b 54 24 04          	mov    0x4(%esp),%edx
  803a6b:	29 f2                	sub    %esi,%edx
  803a6d:	19 cb                	sbb    %ecx,%ebx
  803a6f:	89 d8                	mov    %ebx,%eax
  803a71:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803a75:	d3 e0                	shl    %cl,%eax
  803a77:	89 e9                	mov    %ebp,%ecx
  803a79:	d3 ea                	shr    %cl,%edx
  803a7b:	09 d0                	or     %edx,%eax
  803a7d:	89 e9                	mov    %ebp,%ecx
  803a7f:	d3 eb                	shr    %cl,%ebx
  803a81:	89 da                	mov    %ebx,%edx
  803a83:	83 c4 1c             	add    $0x1c,%esp
  803a86:	5b                   	pop    %ebx
  803a87:	5e                   	pop    %esi
  803a88:	5f                   	pop    %edi
  803a89:	5d                   	pop    %ebp
  803a8a:	c3                   	ret    
  803a8b:	90                   	nop
  803a8c:	89 fd                	mov    %edi,%ebp
  803a8e:	85 ff                	test   %edi,%edi
  803a90:	75 0b                	jne    803a9d <__umoddi3+0xe9>
  803a92:	b8 01 00 00 00       	mov    $0x1,%eax
  803a97:	31 d2                	xor    %edx,%edx
  803a99:	f7 f7                	div    %edi
  803a9b:	89 c5                	mov    %eax,%ebp
  803a9d:	89 f0                	mov    %esi,%eax
  803a9f:	31 d2                	xor    %edx,%edx
  803aa1:	f7 f5                	div    %ebp
  803aa3:	89 c8                	mov    %ecx,%eax
  803aa5:	f7 f5                	div    %ebp
  803aa7:	89 d0                	mov    %edx,%eax
  803aa9:	e9 44 ff ff ff       	jmp    8039f2 <__umoddi3+0x3e>
  803aae:	66 90                	xchg   %ax,%ax
  803ab0:	89 c8                	mov    %ecx,%eax
  803ab2:	89 f2                	mov    %esi,%edx
  803ab4:	83 c4 1c             	add    $0x1c,%esp
  803ab7:	5b                   	pop    %ebx
  803ab8:	5e                   	pop    %esi
  803ab9:	5f                   	pop    %edi
  803aba:	5d                   	pop    %ebp
  803abb:	c3                   	ret    
  803abc:	3b 04 24             	cmp    (%esp),%eax
  803abf:	72 06                	jb     803ac7 <__umoddi3+0x113>
  803ac1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803ac5:	77 0f                	ja     803ad6 <__umoddi3+0x122>
  803ac7:	89 f2                	mov    %esi,%edx
  803ac9:	29 f9                	sub    %edi,%ecx
  803acb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803acf:	89 14 24             	mov    %edx,(%esp)
  803ad2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ad6:	8b 44 24 04          	mov    0x4(%esp),%eax
  803ada:	8b 14 24             	mov    (%esp),%edx
  803add:	83 c4 1c             	add    $0x1c,%esp
  803ae0:	5b                   	pop    %ebx
  803ae1:	5e                   	pop    %esi
  803ae2:	5f                   	pop    %edi
  803ae3:	5d                   	pop    %ebp
  803ae4:	c3                   	ret    
  803ae5:	8d 76 00             	lea    0x0(%esi),%esi
  803ae8:	2b 04 24             	sub    (%esp),%eax
  803aeb:	19 fa                	sbb    %edi,%edx
  803aed:	89 d1                	mov    %edx,%ecx
  803aef:	89 c6                	mov    %eax,%esi
  803af1:	e9 71 ff ff ff       	jmp    803a67 <__umoddi3+0xb3>
  803af6:	66 90                	xchg   %ax,%ax
  803af8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803afc:	72 ea                	jb     803ae8 <__umoddi3+0x134>
  803afe:	89 d9                	mov    %ebx,%ecx
  803b00:	e9 62 ff ff ff       	jmp    803a67 <__umoddi3+0xb3>

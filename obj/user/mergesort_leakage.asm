
obj/user/mergesort_leakage:     file format elf32-i386


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
  800031:	e8 65 07 00 00       	call   80079b <libmain>
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
  800041:	e8 d4 21 00 00       	call   80221a <sys_disable_interrupt>

		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 e0 3a 80 00       	push   $0x803ae0
  80004e:	e8 38 0b 00 00       	call   800b8b <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 e2 3a 80 00       	push   $0x803ae2
  80005e:	e8 28 0b 00 00       	call   800b8b <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 f8 3a 80 00       	push   $0x803af8
  80006e:	e8 18 0b 00 00       	call   800b8b <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 e2 3a 80 00       	push   $0x803ae2
  80007e:	e8 08 0b 00 00       	call   800b8b <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 e0 3a 80 00       	push   $0x803ae0
  80008e:	e8 f8 0a 00 00       	call   800b8b <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 10 3b 80 00       	push   $0x803b10
  8000a5:	e8 63 11 00 00       	call   80120d <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 b3 16 00 00       	call   801773 <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 eb 1b 00 00       	call   801cc0 <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 30 3b 80 00       	push   $0x803b30
  8000e3:	e8 a3 0a 00 00       	call   800b8b <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 52 3b 80 00       	push   $0x803b52
  8000f3:	e8 93 0a 00 00       	call   800b8b <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 60 3b 80 00       	push   $0x803b60
  800103:	e8 83 0a 00 00       	call   800b8b <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 6f 3b 80 00       	push   $0x803b6f
  800113:	e8 73 0a 00 00       	call   800b8b <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 7f 3b 80 00       	push   $0x803b7f
  800123:	e8 63 0a 00 00       	call   800b8b <cprintf>
  800128:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012b:	e8 13 06 00 00       	call   800743 <getchar>
  800130:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  800133:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	50                   	push   %eax
  80013b:	e8 bb 05 00 00       	call   8006fb <cputchar>
  800140:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	6a 0a                	push   $0xa
  800148:	e8 ae 05 00 00       	call   8006fb <cputchar>
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
  800162:	e8 cd 20 00 00       	call   802234 <sys_enable_interrupt>

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
  800183:	e8 e6 01 00 00       	call   80036e <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 04 02 00 00       	call   80039f <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 26 02 00 00       	call   8003d4 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 13 02 00 00       	call   8003d4 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001c4:	83 ec 04             	sub    $0x4,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	6a 01                	push   $0x1
  8001cc:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cf:	e8 d2 02 00 00       	call   8004a6 <MSort>
  8001d4:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001d7:	e8 3e 20 00 00       	call   80221a <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	68 88 3b 80 00       	push   $0x803b88
  8001e4:	e8 a2 09 00 00       	call   800b8b <cprintf>
  8001e9:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ec:	e8 43 20 00 00       	call   802234 <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001f1:	83 ec 08             	sub    $0x8,%esp
  8001f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001fa:	e8 c5 00 00 00       	call   8002c4 <CheckSorted>
  8001ff:	83 c4 10             	add    $0x10,%esp
  800202:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800205:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800209:	75 14                	jne    80021f <_main+0x1e7>
  80020b:	83 ec 04             	sub    $0x4,%esp
  80020e:	68 bc 3b 80 00       	push   $0x803bbc
  800213:	6a 4a                	push   $0x4a
  800215:	68 de 3b 80 00       	push   $0x803bde
  80021a:	e8 b8 06 00 00       	call   8008d7 <_panic>
		else
		{
			sys_disable_interrupt();
  80021f:	e8 f6 1f 00 00       	call   80221a <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	68 f8 3b 80 00       	push   $0x803bf8
  80022c:	e8 5a 09 00 00       	call   800b8b <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 2c 3c 80 00       	push   $0x803c2c
  80023c:	e8 4a 09 00 00       	call   800b8b <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 60 3c 80 00       	push   $0x803c60
  80024c:	e8 3a 09 00 00       	call   800b8b <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800254:	e8 db 1f 00 00       	call   802234 <sys_enable_interrupt>
		}

		//free(Elements) ;

		sys_disable_interrupt();
  800259:	e8 bc 1f 00 00       	call   80221a <sys_disable_interrupt>
			Chose = 0 ;
  80025e:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800262:	eb 42                	jmp    8002a6 <_main+0x26e>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800264:	83 ec 0c             	sub    $0xc,%esp
  800267:	68 92 3c 80 00       	push   $0x803c92
  80026c:	e8 1a 09 00 00       	call   800b8b <cprintf>
  800271:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800274:	e8 ca 04 00 00       	call   800743 <getchar>
  800279:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80027c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800280:	83 ec 0c             	sub    $0xc,%esp
  800283:	50                   	push   %eax
  800284:	e8 72 04 00 00       	call   8006fb <cputchar>
  800289:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	6a 0a                	push   $0xa
  800291:	e8 65 04 00 00       	call   8006fb <cputchar>
  800296:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800299:	83 ec 0c             	sub    $0xc,%esp
  80029c:	6a 0a                	push   $0xa
  80029e:	e8 58 04 00 00       	call   8006fb <cputchar>
  8002a3:	83 c4 10             	add    $0x10,%esp

		//free(Elements) ;

		sys_disable_interrupt();
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002a6:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002aa:	74 06                	je     8002b2 <_main+0x27a>
  8002ac:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002b0:	75 b2                	jne    800264 <_main+0x22c>
				Chose = getchar() ;
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		sys_enable_interrupt();
  8002b2:	e8 7d 1f 00 00       	call   802234 <sys_enable_interrupt>

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
  800446:	68 e0 3a 80 00       	push   $0x803ae0
  80044b:	e8 3b 07 00 00       	call   800b8b <cprintf>
  800450:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800456:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045d:	8b 45 08             	mov    0x8(%ebp),%eax
  800460:	01 d0                	add    %edx,%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	83 ec 08             	sub    $0x8,%esp
  800467:	50                   	push   %eax
  800468:	68 b0 3c 80 00       	push   $0x803cb0
  80046d:	e8 19 07 00 00       	call   800b8b <cprintf>
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
  800496:	68 b5 3c 80 00       	push   $0x803cb5
  80049b:	e8 eb 06 00 00       	call   800b8b <cprintf>
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
  80053c:	e8 7f 17 00 00       	call   801cc0 <malloc>
  800541:	83 c4 10             	add    $0x10,%esp
  800544:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  800547:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80054a:	c1 e0 02             	shl    $0x2,%eax
  80054d:	83 ec 0c             	sub    $0xc,%esp
  800550:	50                   	push   %eax
  800551:	e8 6a 17 00 00       	call   801cc0 <malloc>
  800556:	83 c4 10             	add    $0x10,%esp
  800559:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//	int Left[5000] ;
	//	int Right[5000] ;

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

	//	int Left[5000] ;
	//	int Right[5000] ;

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

}
  8006f8:	90                   	nop
  8006f9:	c9                   	leave  
  8006fa:	c3                   	ret    

008006fb <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8006fb:	55                   	push   %ebp
  8006fc:	89 e5                	mov    %esp,%ebp
  8006fe:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800701:	8b 45 08             	mov    0x8(%ebp),%eax
  800704:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800707:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80070b:	83 ec 0c             	sub    $0xc,%esp
  80070e:	50                   	push   %eax
  80070f:	e8 3a 1b 00 00       	call   80224e <sys_cputc>
  800714:	83 c4 10             	add    $0x10,%esp
}
  800717:	90                   	nop
  800718:	c9                   	leave  
  800719:	c3                   	ret    

0080071a <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  80071a:	55                   	push   %ebp
  80071b:	89 e5                	mov    %esp,%ebp
  80071d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800720:	e8 f5 1a 00 00       	call   80221a <sys_disable_interrupt>
	char c = ch;
  800725:	8b 45 08             	mov    0x8(%ebp),%eax
  800728:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  80072b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80072f:	83 ec 0c             	sub    $0xc,%esp
  800732:	50                   	push   %eax
  800733:	e8 16 1b 00 00       	call   80224e <sys_cputc>
  800738:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80073b:	e8 f4 1a 00 00       	call   802234 <sys_enable_interrupt>
}
  800740:	90                   	nop
  800741:	c9                   	leave  
  800742:	c3                   	ret    

00800743 <getchar>:

int
getchar(void)
{
  800743:	55                   	push   %ebp
  800744:	89 e5                	mov    %esp,%ebp
  800746:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800749:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800750:	eb 08                	jmp    80075a <getchar+0x17>
	{
		c = sys_cgetc();
  800752:	e8 3e 19 00 00       	call   802095 <sys_cgetc>
  800757:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  80075a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80075e:	74 f2                	je     800752 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  800760:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800763:	c9                   	leave  
  800764:	c3                   	ret    

00800765 <atomic_getchar>:

int
atomic_getchar(void)
{
  800765:	55                   	push   %ebp
  800766:	89 e5                	mov    %esp,%ebp
  800768:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80076b:	e8 aa 1a 00 00       	call   80221a <sys_disable_interrupt>
	int c=0;
  800770:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800777:	eb 08                	jmp    800781 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800779:	e8 17 19 00 00       	call   802095 <sys_cgetc>
  80077e:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  800781:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800785:	74 f2                	je     800779 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800787:	e8 a8 1a 00 00       	call   802234 <sys_enable_interrupt>
	return c;
  80078c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80078f:	c9                   	leave  
  800790:	c3                   	ret    

00800791 <iscons>:

int iscons(int fdnum)
{
  800791:	55                   	push   %ebp
  800792:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800794:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800799:	5d                   	pop    %ebp
  80079a:	c3                   	ret    

0080079b <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80079b:	55                   	push   %ebp
  80079c:	89 e5                	mov    %esp,%ebp
  80079e:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8007a1:	e8 67 1c 00 00       	call   80240d <sys_getenvindex>
  8007a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8007a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007ac:	89 d0                	mov    %edx,%eax
  8007ae:	c1 e0 03             	shl    $0x3,%eax
  8007b1:	01 d0                	add    %edx,%eax
  8007b3:	01 c0                	add    %eax,%eax
  8007b5:	01 d0                	add    %edx,%eax
  8007b7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007be:	01 d0                	add    %edx,%eax
  8007c0:	c1 e0 04             	shl    $0x4,%eax
  8007c3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8007c8:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8007cd:	a1 24 50 80 00       	mov    0x805024,%eax
  8007d2:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8007d8:	84 c0                	test   %al,%al
  8007da:	74 0f                	je     8007eb <libmain+0x50>
		binaryname = myEnv->prog_name;
  8007dc:	a1 24 50 80 00       	mov    0x805024,%eax
  8007e1:	05 5c 05 00 00       	add    $0x55c,%eax
  8007e6:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007eb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8007ef:	7e 0a                	jle    8007fb <libmain+0x60>
		binaryname = argv[0];
  8007f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007f4:	8b 00                	mov    (%eax),%eax
  8007f6:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8007fb:	83 ec 08             	sub    $0x8,%esp
  8007fe:	ff 75 0c             	pushl  0xc(%ebp)
  800801:	ff 75 08             	pushl  0x8(%ebp)
  800804:	e8 2f f8 ff ff       	call   800038 <_main>
  800809:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80080c:	e8 09 1a 00 00       	call   80221a <sys_disable_interrupt>
	cprintf("**************************************\n");
  800811:	83 ec 0c             	sub    $0xc,%esp
  800814:	68 d4 3c 80 00       	push   $0x803cd4
  800819:	e8 6d 03 00 00       	call   800b8b <cprintf>
  80081e:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800821:	a1 24 50 80 00       	mov    0x805024,%eax
  800826:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80082c:	a1 24 50 80 00       	mov    0x805024,%eax
  800831:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800837:	83 ec 04             	sub    $0x4,%esp
  80083a:	52                   	push   %edx
  80083b:	50                   	push   %eax
  80083c:	68 fc 3c 80 00       	push   $0x803cfc
  800841:	e8 45 03 00 00       	call   800b8b <cprintf>
  800846:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800849:	a1 24 50 80 00       	mov    0x805024,%eax
  80084e:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800854:	a1 24 50 80 00       	mov    0x805024,%eax
  800859:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80085f:	a1 24 50 80 00       	mov    0x805024,%eax
  800864:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80086a:	51                   	push   %ecx
  80086b:	52                   	push   %edx
  80086c:	50                   	push   %eax
  80086d:	68 24 3d 80 00       	push   $0x803d24
  800872:	e8 14 03 00 00       	call   800b8b <cprintf>
  800877:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80087a:	a1 24 50 80 00       	mov    0x805024,%eax
  80087f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800885:	83 ec 08             	sub    $0x8,%esp
  800888:	50                   	push   %eax
  800889:	68 7c 3d 80 00       	push   $0x803d7c
  80088e:	e8 f8 02 00 00       	call   800b8b <cprintf>
  800893:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800896:	83 ec 0c             	sub    $0xc,%esp
  800899:	68 d4 3c 80 00       	push   $0x803cd4
  80089e:	e8 e8 02 00 00       	call   800b8b <cprintf>
  8008a3:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8008a6:	e8 89 19 00 00       	call   802234 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8008ab:	e8 19 00 00 00       	call   8008c9 <exit>
}
  8008b0:	90                   	nop
  8008b1:	c9                   	leave  
  8008b2:	c3                   	ret    

008008b3 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8008b3:	55                   	push   %ebp
  8008b4:	89 e5                	mov    %esp,%ebp
  8008b6:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8008b9:	83 ec 0c             	sub    $0xc,%esp
  8008bc:	6a 00                	push   $0x0
  8008be:	e8 16 1b 00 00       	call   8023d9 <sys_destroy_env>
  8008c3:	83 c4 10             	add    $0x10,%esp
}
  8008c6:	90                   	nop
  8008c7:	c9                   	leave  
  8008c8:	c3                   	ret    

008008c9 <exit>:

void
exit(void)
{
  8008c9:	55                   	push   %ebp
  8008ca:	89 e5                	mov    %esp,%ebp
  8008cc:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8008cf:	e8 6b 1b 00 00       	call   80243f <sys_exit_env>
}
  8008d4:	90                   	nop
  8008d5:	c9                   	leave  
  8008d6:	c3                   	ret    

008008d7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8008d7:	55                   	push   %ebp
  8008d8:	89 e5                	mov    %esp,%ebp
  8008da:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8008dd:	8d 45 10             	lea    0x10(%ebp),%eax
  8008e0:	83 c0 04             	add    $0x4,%eax
  8008e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8008e6:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8008eb:	85 c0                	test   %eax,%eax
  8008ed:	74 16                	je     800905 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8008ef:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8008f4:	83 ec 08             	sub    $0x8,%esp
  8008f7:	50                   	push   %eax
  8008f8:	68 90 3d 80 00       	push   $0x803d90
  8008fd:	e8 89 02 00 00       	call   800b8b <cprintf>
  800902:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800905:	a1 00 50 80 00       	mov    0x805000,%eax
  80090a:	ff 75 0c             	pushl  0xc(%ebp)
  80090d:	ff 75 08             	pushl  0x8(%ebp)
  800910:	50                   	push   %eax
  800911:	68 95 3d 80 00       	push   $0x803d95
  800916:	e8 70 02 00 00       	call   800b8b <cprintf>
  80091b:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80091e:	8b 45 10             	mov    0x10(%ebp),%eax
  800921:	83 ec 08             	sub    $0x8,%esp
  800924:	ff 75 f4             	pushl  -0xc(%ebp)
  800927:	50                   	push   %eax
  800928:	e8 f3 01 00 00       	call   800b20 <vcprintf>
  80092d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800930:	83 ec 08             	sub    $0x8,%esp
  800933:	6a 00                	push   $0x0
  800935:	68 b1 3d 80 00       	push   $0x803db1
  80093a:	e8 e1 01 00 00       	call   800b20 <vcprintf>
  80093f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800942:	e8 82 ff ff ff       	call   8008c9 <exit>

	// should not return here
	while (1) ;
  800947:	eb fe                	jmp    800947 <_panic+0x70>

00800949 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800949:	55                   	push   %ebp
  80094a:	89 e5                	mov    %esp,%ebp
  80094c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80094f:	a1 24 50 80 00       	mov    0x805024,%eax
  800954:	8b 50 74             	mov    0x74(%eax),%edx
  800957:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095a:	39 c2                	cmp    %eax,%edx
  80095c:	74 14                	je     800972 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80095e:	83 ec 04             	sub    $0x4,%esp
  800961:	68 b4 3d 80 00       	push   $0x803db4
  800966:	6a 26                	push   $0x26
  800968:	68 00 3e 80 00       	push   $0x803e00
  80096d:	e8 65 ff ff ff       	call   8008d7 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800972:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800979:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800980:	e9 c2 00 00 00       	jmp    800a47 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800985:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800988:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80098f:	8b 45 08             	mov    0x8(%ebp),%eax
  800992:	01 d0                	add    %edx,%eax
  800994:	8b 00                	mov    (%eax),%eax
  800996:	85 c0                	test   %eax,%eax
  800998:	75 08                	jne    8009a2 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80099a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80099d:	e9 a2 00 00 00       	jmp    800a44 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8009a2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009a9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8009b0:	eb 69                	jmp    800a1b <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8009b2:	a1 24 50 80 00       	mov    0x805024,%eax
  8009b7:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009bd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009c0:	89 d0                	mov    %edx,%eax
  8009c2:	01 c0                	add    %eax,%eax
  8009c4:	01 d0                	add    %edx,%eax
  8009c6:	c1 e0 03             	shl    $0x3,%eax
  8009c9:	01 c8                	add    %ecx,%eax
  8009cb:	8a 40 04             	mov    0x4(%eax),%al
  8009ce:	84 c0                	test   %al,%al
  8009d0:	75 46                	jne    800a18 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009d2:	a1 24 50 80 00       	mov    0x805024,%eax
  8009d7:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009dd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009e0:	89 d0                	mov    %edx,%eax
  8009e2:	01 c0                	add    %eax,%eax
  8009e4:	01 d0                	add    %edx,%eax
  8009e6:	c1 e0 03             	shl    $0x3,%eax
  8009e9:	01 c8                	add    %ecx,%eax
  8009eb:	8b 00                	mov    (%eax),%eax
  8009ed:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8009f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8009f3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8009f8:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8009fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009fd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a04:	8b 45 08             	mov    0x8(%ebp),%eax
  800a07:	01 c8                	add    %ecx,%eax
  800a09:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a0b:	39 c2                	cmp    %eax,%edx
  800a0d:	75 09                	jne    800a18 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800a0f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a16:	eb 12                	jmp    800a2a <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a18:	ff 45 e8             	incl   -0x18(%ebp)
  800a1b:	a1 24 50 80 00       	mov    0x805024,%eax
  800a20:	8b 50 74             	mov    0x74(%eax),%edx
  800a23:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a26:	39 c2                	cmp    %eax,%edx
  800a28:	77 88                	ja     8009b2 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a2a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a2e:	75 14                	jne    800a44 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800a30:	83 ec 04             	sub    $0x4,%esp
  800a33:	68 0c 3e 80 00       	push   $0x803e0c
  800a38:	6a 3a                	push   $0x3a
  800a3a:	68 00 3e 80 00       	push   $0x803e00
  800a3f:	e8 93 fe ff ff       	call   8008d7 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a44:	ff 45 f0             	incl   -0x10(%ebp)
  800a47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a4a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a4d:	0f 8c 32 ff ff ff    	jl     800985 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a53:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a5a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a61:	eb 26                	jmp    800a89 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a63:	a1 24 50 80 00       	mov    0x805024,%eax
  800a68:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800a6e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a71:	89 d0                	mov    %edx,%eax
  800a73:	01 c0                	add    %eax,%eax
  800a75:	01 d0                	add    %edx,%eax
  800a77:	c1 e0 03             	shl    $0x3,%eax
  800a7a:	01 c8                	add    %ecx,%eax
  800a7c:	8a 40 04             	mov    0x4(%eax),%al
  800a7f:	3c 01                	cmp    $0x1,%al
  800a81:	75 03                	jne    800a86 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800a83:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a86:	ff 45 e0             	incl   -0x20(%ebp)
  800a89:	a1 24 50 80 00       	mov    0x805024,%eax
  800a8e:	8b 50 74             	mov    0x74(%eax),%edx
  800a91:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a94:	39 c2                	cmp    %eax,%edx
  800a96:	77 cb                	ja     800a63 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a9b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800a9e:	74 14                	je     800ab4 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800aa0:	83 ec 04             	sub    $0x4,%esp
  800aa3:	68 60 3e 80 00       	push   $0x803e60
  800aa8:	6a 44                	push   $0x44
  800aaa:	68 00 3e 80 00       	push   $0x803e00
  800aaf:	e8 23 fe ff ff       	call   8008d7 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800ab4:	90                   	nop
  800ab5:	c9                   	leave  
  800ab6:	c3                   	ret    

00800ab7 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800ab7:	55                   	push   %ebp
  800ab8:	89 e5                	mov    %esp,%ebp
  800aba:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800abd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac0:	8b 00                	mov    (%eax),%eax
  800ac2:	8d 48 01             	lea    0x1(%eax),%ecx
  800ac5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ac8:	89 0a                	mov    %ecx,(%edx)
  800aca:	8b 55 08             	mov    0x8(%ebp),%edx
  800acd:	88 d1                	mov    %dl,%cl
  800acf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ad2:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800ad6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad9:	8b 00                	mov    (%eax),%eax
  800adb:	3d ff 00 00 00       	cmp    $0xff,%eax
  800ae0:	75 2c                	jne    800b0e <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800ae2:	a0 28 50 80 00       	mov    0x805028,%al
  800ae7:	0f b6 c0             	movzbl %al,%eax
  800aea:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aed:	8b 12                	mov    (%edx),%edx
  800aef:	89 d1                	mov    %edx,%ecx
  800af1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af4:	83 c2 08             	add    $0x8,%edx
  800af7:	83 ec 04             	sub    $0x4,%esp
  800afa:	50                   	push   %eax
  800afb:	51                   	push   %ecx
  800afc:	52                   	push   %edx
  800afd:	e8 6a 15 00 00       	call   80206c <sys_cputs>
  800b02:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b08:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b11:	8b 40 04             	mov    0x4(%eax),%eax
  800b14:	8d 50 01             	lea    0x1(%eax),%edx
  800b17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1a:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b1d:	90                   	nop
  800b1e:	c9                   	leave  
  800b1f:	c3                   	ret    

00800b20 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b20:	55                   	push   %ebp
  800b21:	89 e5                	mov    %esp,%ebp
  800b23:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b29:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b30:	00 00 00 
	b.cnt = 0;
  800b33:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b3a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b3d:	ff 75 0c             	pushl  0xc(%ebp)
  800b40:	ff 75 08             	pushl  0x8(%ebp)
  800b43:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b49:	50                   	push   %eax
  800b4a:	68 b7 0a 80 00       	push   $0x800ab7
  800b4f:	e8 11 02 00 00       	call   800d65 <vprintfmt>
  800b54:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800b57:	a0 28 50 80 00       	mov    0x805028,%al
  800b5c:	0f b6 c0             	movzbl %al,%eax
  800b5f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b65:	83 ec 04             	sub    $0x4,%esp
  800b68:	50                   	push   %eax
  800b69:	52                   	push   %edx
  800b6a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b70:	83 c0 08             	add    $0x8,%eax
  800b73:	50                   	push   %eax
  800b74:	e8 f3 14 00 00       	call   80206c <sys_cputs>
  800b79:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800b7c:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800b83:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800b89:	c9                   	leave  
  800b8a:	c3                   	ret    

00800b8b <cprintf>:

int cprintf(const char *fmt, ...) {
  800b8b:	55                   	push   %ebp
  800b8c:	89 e5                	mov    %esp,%ebp
  800b8e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800b91:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800b98:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba1:	83 ec 08             	sub    $0x8,%esp
  800ba4:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba7:	50                   	push   %eax
  800ba8:	e8 73 ff ff ff       	call   800b20 <vcprintf>
  800bad:	83 c4 10             	add    $0x10,%esp
  800bb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800bb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bb6:	c9                   	leave  
  800bb7:	c3                   	ret    

00800bb8 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800bb8:	55                   	push   %ebp
  800bb9:	89 e5                	mov    %esp,%ebp
  800bbb:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800bbe:	e8 57 16 00 00       	call   80221a <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800bc3:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcc:	83 ec 08             	sub    $0x8,%esp
  800bcf:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd2:	50                   	push   %eax
  800bd3:	e8 48 ff ff ff       	call   800b20 <vcprintf>
  800bd8:	83 c4 10             	add    $0x10,%esp
  800bdb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800bde:	e8 51 16 00 00       	call   802234 <sys_enable_interrupt>
	return cnt;
  800be3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800be6:	c9                   	leave  
  800be7:	c3                   	ret    

00800be8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
  800beb:	53                   	push   %ebx
  800bec:	83 ec 14             	sub    $0x14,%esp
  800bef:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf5:	8b 45 14             	mov    0x14(%ebp),%eax
  800bf8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800bfb:	8b 45 18             	mov    0x18(%ebp),%eax
  800bfe:	ba 00 00 00 00       	mov    $0x0,%edx
  800c03:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c06:	77 55                	ja     800c5d <printnum+0x75>
  800c08:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c0b:	72 05                	jb     800c12 <printnum+0x2a>
  800c0d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c10:	77 4b                	ja     800c5d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c12:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800c15:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800c18:	8b 45 18             	mov    0x18(%ebp),%eax
  800c1b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c20:	52                   	push   %edx
  800c21:	50                   	push   %eax
  800c22:	ff 75 f4             	pushl  -0xc(%ebp)
  800c25:	ff 75 f0             	pushl  -0x10(%ebp)
  800c28:	e8 4f 2c 00 00       	call   80387c <__udivdi3>
  800c2d:	83 c4 10             	add    $0x10,%esp
  800c30:	83 ec 04             	sub    $0x4,%esp
  800c33:	ff 75 20             	pushl  0x20(%ebp)
  800c36:	53                   	push   %ebx
  800c37:	ff 75 18             	pushl  0x18(%ebp)
  800c3a:	52                   	push   %edx
  800c3b:	50                   	push   %eax
  800c3c:	ff 75 0c             	pushl  0xc(%ebp)
  800c3f:	ff 75 08             	pushl  0x8(%ebp)
  800c42:	e8 a1 ff ff ff       	call   800be8 <printnum>
  800c47:	83 c4 20             	add    $0x20,%esp
  800c4a:	eb 1a                	jmp    800c66 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c4c:	83 ec 08             	sub    $0x8,%esp
  800c4f:	ff 75 0c             	pushl  0xc(%ebp)
  800c52:	ff 75 20             	pushl  0x20(%ebp)
  800c55:	8b 45 08             	mov    0x8(%ebp),%eax
  800c58:	ff d0                	call   *%eax
  800c5a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c5d:	ff 4d 1c             	decl   0x1c(%ebp)
  800c60:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c64:	7f e6                	jg     800c4c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c66:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c69:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c74:	53                   	push   %ebx
  800c75:	51                   	push   %ecx
  800c76:	52                   	push   %edx
  800c77:	50                   	push   %eax
  800c78:	e8 0f 2d 00 00       	call   80398c <__umoddi3>
  800c7d:	83 c4 10             	add    $0x10,%esp
  800c80:	05 d4 40 80 00       	add    $0x8040d4,%eax
  800c85:	8a 00                	mov    (%eax),%al
  800c87:	0f be c0             	movsbl %al,%eax
  800c8a:	83 ec 08             	sub    $0x8,%esp
  800c8d:	ff 75 0c             	pushl  0xc(%ebp)
  800c90:	50                   	push   %eax
  800c91:	8b 45 08             	mov    0x8(%ebp),%eax
  800c94:	ff d0                	call   *%eax
  800c96:	83 c4 10             	add    $0x10,%esp
}
  800c99:	90                   	nop
  800c9a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c9d:	c9                   	leave  
  800c9e:	c3                   	ret    

00800c9f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c9f:	55                   	push   %ebp
  800ca0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ca2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ca6:	7e 1c                	jle    800cc4 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cab:	8b 00                	mov    (%eax),%eax
  800cad:	8d 50 08             	lea    0x8(%eax),%edx
  800cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb3:	89 10                	mov    %edx,(%eax)
  800cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb8:	8b 00                	mov    (%eax),%eax
  800cba:	83 e8 08             	sub    $0x8,%eax
  800cbd:	8b 50 04             	mov    0x4(%eax),%edx
  800cc0:	8b 00                	mov    (%eax),%eax
  800cc2:	eb 40                	jmp    800d04 <getuint+0x65>
	else if (lflag)
  800cc4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cc8:	74 1e                	je     800ce8 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800cca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccd:	8b 00                	mov    (%eax),%eax
  800ccf:	8d 50 04             	lea    0x4(%eax),%edx
  800cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd5:	89 10                	mov    %edx,(%eax)
  800cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cda:	8b 00                	mov    (%eax),%eax
  800cdc:	83 e8 04             	sub    $0x4,%eax
  800cdf:	8b 00                	mov    (%eax),%eax
  800ce1:	ba 00 00 00 00       	mov    $0x0,%edx
  800ce6:	eb 1c                	jmp    800d04 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ceb:	8b 00                	mov    (%eax),%eax
  800ced:	8d 50 04             	lea    0x4(%eax),%edx
  800cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf3:	89 10                	mov    %edx,(%eax)
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf8:	8b 00                	mov    (%eax),%eax
  800cfa:	83 e8 04             	sub    $0x4,%eax
  800cfd:	8b 00                	mov    (%eax),%eax
  800cff:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800d04:	5d                   	pop    %ebp
  800d05:	c3                   	ret    

00800d06 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800d06:	55                   	push   %ebp
  800d07:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d09:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d0d:	7e 1c                	jle    800d2b <getint+0x25>
		return va_arg(*ap, long long);
  800d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d12:	8b 00                	mov    (%eax),%eax
  800d14:	8d 50 08             	lea    0x8(%eax),%edx
  800d17:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1a:	89 10                	mov    %edx,(%eax)
  800d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1f:	8b 00                	mov    (%eax),%eax
  800d21:	83 e8 08             	sub    $0x8,%eax
  800d24:	8b 50 04             	mov    0x4(%eax),%edx
  800d27:	8b 00                	mov    (%eax),%eax
  800d29:	eb 38                	jmp    800d63 <getint+0x5d>
	else if (lflag)
  800d2b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d2f:	74 1a                	je     800d4b <getint+0x45>
		return va_arg(*ap, long);
  800d31:	8b 45 08             	mov    0x8(%ebp),%eax
  800d34:	8b 00                	mov    (%eax),%eax
  800d36:	8d 50 04             	lea    0x4(%eax),%edx
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	89 10                	mov    %edx,(%eax)
  800d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d41:	8b 00                	mov    (%eax),%eax
  800d43:	83 e8 04             	sub    $0x4,%eax
  800d46:	8b 00                	mov    (%eax),%eax
  800d48:	99                   	cltd   
  800d49:	eb 18                	jmp    800d63 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4e:	8b 00                	mov    (%eax),%eax
  800d50:	8d 50 04             	lea    0x4(%eax),%edx
  800d53:	8b 45 08             	mov    0x8(%ebp),%eax
  800d56:	89 10                	mov    %edx,(%eax)
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	8b 00                	mov    (%eax),%eax
  800d5d:	83 e8 04             	sub    $0x4,%eax
  800d60:	8b 00                	mov    (%eax),%eax
  800d62:	99                   	cltd   
}
  800d63:	5d                   	pop    %ebp
  800d64:	c3                   	ret    

00800d65 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d65:	55                   	push   %ebp
  800d66:	89 e5                	mov    %esp,%ebp
  800d68:	56                   	push   %esi
  800d69:	53                   	push   %ebx
  800d6a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d6d:	eb 17                	jmp    800d86 <vprintfmt+0x21>
			if (ch == '\0')
  800d6f:	85 db                	test   %ebx,%ebx
  800d71:	0f 84 af 03 00 00    	je     801126 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800d77:	83 ec 08             	sub    $0x8,%esp
  800d7a:	ff 75 0c             	pushl  0xc(%ebp)
  800d7d:	53                   	push   %ebx
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	ff d0                	call   *%eax
  800d83:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d86:	8b 45 10             	mov    0x10(%ebp),%eax
  800d89:	8d 50 01             	lea    0x1(%eax),%edx
  800d8c:	89 55 10             	mov    %edx,0x10(%ebp)
  800d8f:	8a 00                	mov    (%eax),%al
  800d91:	0f b6 d8             	movzbl %al,%ebx
  800d94:	83 fb 25             	cmp    $0x25,%ebx
  800d97:	75 d6                	jne    800d6f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800d99:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800d9d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800da4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800dab:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800db2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800db9:	8b 45 10             	mov    0x10(%ebp),%eax
  800dbc:	8d 50 01             	lea    0x1(%eax),%edx
  800dbf:	89 55 10             	mov    %edx,0x10(%ebp)
  800dc2:	8a 00                	mov    (%eax),%al
  800dc4:	0f b6 d8             	movzbl %al,%ebx
  800dc7:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800dca:	83 f8 55             	cmp    $0x55,%eax
  800dcd:	0f 87 2b 03 00 00    	ja     8010fe <vprintfmt+0x399>
  800dd3:	8b 04 85 f8 40 80 00 	mov    0x8040f8(,%eax,4),%eax
  800dda:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ddc:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800de0:	eb d7                	jmp    800db9 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800de2:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800de6:	eb d1                	jmp    800db9 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800de8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800def:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800df2:	89 d0                	mov    %edx,%eax
  800df4:	c1 e0 02             	shl    $0x2,%eax
  800df7:	01 d0                	add    %edx,%eax
  800df9:	01 c0                	add    %eax,%eax
  800dfb:	01 d8                	add    %ebx,%eax
  800dfd:	83 e8 30             	sub    $0x30,%eax
  800e00:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800e03:	8b 45 10             	mov    0x10(%ebp),%eax
  800e06:	8a 00                	mov    (%eax),%al
  800e08:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e0b:	83 fb 2f             	cmp    $0x2f,%ebx
  800e0e:	7e 3e                	jle    800e4e <vprintfmt+0xe9>
  800e10:	83 fb 39             	cmp    $0x39,%ebx
  800e13:	7f 39                	jg     800e4e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e15:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e18:	eb d5                	jmp    800def <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800e1a:	8b 45 14             	mov    0x14(%ebp),%eax
  800e1d:	83 c0 04             	add    $0x4,%eax
  800e20:	89 45 14             	mov    %eax,0x14(%ebp)
  800e23:	8b 45 14             	mov    0x14(%ebp),%eax
  800e26:	83 e8 04             	sub    $0x4,%eax
  800e29:	8b 00                	mov    (%eax),%eax
  800e2b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800e2e:	eb 1f                	jmp    800e4f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800e30:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e34:	79 83                	jns    800db9 <vprintfmt+0x54>
				width = 0;
  800e36:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e3d:	e9 77 ff ff ff       	jmp    800db9 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e42:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e49:	e9 6b ff ff ff       	jmp    800db9 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e4e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e4f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e53:	0f 89 60 ff ff ff    	jns    800db9 <vprintfmt+0x54>
				width = precision, precision = -1;
  800e59:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e5c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e5f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e66:	e9 4e ff ff ff       	jmp    800db9 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e6b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e6e:	e9 46 ff ff ff       	jmp    800db9 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e73:	8b 45 14             	mov    0x14(%ebp),%eax
  800e76:	83 c0 04             	add    $0x4,%eax
  800e79:	89 45 14             	mov    %eax,0x14(%ebp)
  800e7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800e7f:	83 e8 04             	sub    $0x4,%eax
  800e82:	8b 00                	mov    (%eax),%eax
  800e84:	83 ec 08             	sub    $0x8,%esp
  800e87:	ff 75 0c             	pushl  0xc(%ebp)
  800e8a:	50                   	push   %eax
  800e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8e:	ff d0                	call   *%eax
  800e90:	83 c4 10             	add    $0x10,%esp
			break;
  800e93:	e9 89 02 00 00       	jmp    801121 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800e98:	8b 45 14             	mov    0x14(%ebp),%eax
  800e9b:	83 c0 04             	add    $0x4,%eax
  800e9e:	89 45 14             	mov    %eax,0x14(%ebp)
  800ea1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ea4:	83 e8 04             	sub    $0x4,%eax
  800ea7:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ea9:	85 db                	test   %ebx,%ebx
  800eab:	79 02                	jns    800eaf <vprintfmt+0x14a>
				err = -err;
  800ead:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800eaf:	83 fb 64             	cmp    $0x64,%ebx
  800eb2:	7f 0b                	jg     800ebf <vprintfmt+0x15a>
  800eb4:	8b 34 9d 40 3f 80 00 	mov    0x803f40(,%ebx,4),%esi
  800ebb:	85 f6                	test   %esi,%esi
  800ebd:	75 19                	jne    800ed8 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ebf:	53                   	push   %ebx
  800ec0:	68 e5 40 80 00       	push   $0x8040e5
  800ec5:	ff 75 0c             	pushl  0xc(%ebp)
  800ec8:	ff 75 08             	pushl  0x8(%ebp)
  800ecb:	e8 5e 02 00 00       	call   80112e <printfmt>
  800ed0:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ed3:	e9 49 02 00 00       	jmp    801121 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ed8:	56                   	push   %esi
  800ed9:	68 ee 40 80 00       	push   $0x8040ee
  800ede:	ff 75 0c             	pushl  0xc(%ebp)
  800ee1:	ff 75 08             	pushl  0x8(%ebp)
  800ee4:	e8 45 02 00 00       	call   80112e <printfmt>
  800ee9:	83 c4 10             	add    $0x10,%esp
			break;
  800eec:	e9 30 02 00 00       	jmp    801121 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ef1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ef4:	83 c0 04             	add    $0x4,%eax
  800ef7:	89 45 14             	mov    %eax,0x14(%ebp)
  800efa:	8b 45 14             	mov    0x14(%ebp),%eax
  800efd:	83 e8 04             	sub    $0x4,%eax
  800f00:	8b 30                	mov    (%eax),%esi
  800f02:	85 f6                	test   %esi,%esi
  800f04:	75 05                	jne    800f0b <vprintfmt+0x1a6>
				p = "(null)";
  800f06:	be f1 40 80 00       	mov    $0x8040f1,%esi
			if (width > 0 && padc != '-')
  800f0b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f0f:	7e 6d                	jle    800f7e <vprintfmt+0x219>
  800f11:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800f15:	74 67                	je     800f7e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800f17:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f1a:	83 ec 08             	sub    $0x8,%esp
  800f1d:	50                   	push   %eax
  800f1e:	56                   	push   %esi
  800f1f:	e8 12 05 00 00       	call   801436 <strnlen>
  800f24:	83 c4 10             	add    $0x10,%esp
  800f27:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800f2a:	eb 16                	jmp    800f42 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800f2c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800f30:	83 ec 08             	sub    $0x8,%esp
  800f33:	ff 75 0c             	pushl  0xc(%ebp)
  800f36:	50                   	push   %eax
  800f37:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3a:	ff d0                	call   *%eax
  800f3c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f3f:	ff 4d e4             	decl   -0x1c(%ebp)
  800f42:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f46:	7f e4                	jg     800f2c <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f48:	eb 34                	jmp    800f7e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f4a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f4e:	74 1c                	je     800f6c <vprintfmt+0x207>
  800f50:	83 fb 1f             	cmp    $0x1f,%ebx
  800f53:	7e 05                	jle    800f5a <vprintfmt+0x1f5>
  800f55:	83 fb 7e             	cmp    $0x7e,%ebx
  800f58:	7e 12                	jle    800f6c <vprintfmt+0x207>
					putch('?', putdat);
  800f5a:	83 ec 08             	sub    $0x8,%esp
  800f5d:	ff 75 0c             	pushl  0xc(%ebp)
  800f60:	6a 3f                	push   $0x3f
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
  800f65:	ff d0                	call   *%eax
  800f67:	83 c4 10             	add    $0x10,%esp
  800f6a:	eb 0f                	jmp    800f7b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f6c:	83 ec 08             	sub    $0x8,%esp
  800f6f:	ff 75 0c             	pushl  0xc(%ebp)
  800f72:	53                   	push   %ebx
  800f73:	8b 45 08             	mov    0x8(%ebp),%eax
  800f76:	ff d0                	call   *%eax
  800f78:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f7b:	ff 4d e4             	decl   -0x1c(%ebp)
  800f7e:	89 f0                	mov    %esi,%eax
  800f80:	8d 70 01             	lea    0x1(%eax),%esi
  800f83:	8a 00                	mov    (%eax),%al
  800f85:	0f be d8             	movsbl %al,%ebx
  800f88:	85 db                	test   %ebx,%ebx
  800f8a:	74 24                	je     800fb0 <vprintfmt+0x24b>
  800f8c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f90:	78 b8                	js     800f4a <vprintfmt+0x1e5>
  800f92:	ff 4d e0             	decl   -0x20(%ebp)
  800f95:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f99:	79 af                	jns    800f4a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f9b:	eb 13                	jmp    800fb0 <vprintfmt+0x24b>
				putch(' ', putdat);
  800f9d:	83 ec 08             	sub    $0x8,%esp
  800fa0:	ff 75 0c             	pushl  0xc(%ebp)
  800fa3:	6a 20                	push   $0x20
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	ff d0                	call   *%eax
  800faa:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fad:	ff 4d e4             	decl   -0x1c(%ebp)
  800fb0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fb4:	7f e7                	jg     800f9d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800fb6:	e9 66 01 00 00       	jmp    801121 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800fbb:	83 ec 08             	sub    $0x8,%esp
  800fbe:	ff 75 e8             	pushl  -0x18(%ebp)
  800fc1:	8d 45 14             	lea    0x14(%ebp),%eax
  800fc4:	50                   	push   %eax
  800fc5:	e8 3c fd ff ff       	call   800d06 <getint>
  800fca:	83 c4 10             	add    $0x10,%esp
  800fcd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fd0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800fd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fd6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fd9:	85 d2                	test   %edx,%edx
  800fdb:	79 23                	jns    801000 <vprintfmt+0x29b>
				putch('-', putdat);
  800fdd:	83 ec 08             	sub    $0x8,%esp
  800fe0:	ff 75 0c             	pushl  0xc(%ebp)
  800fe3:	6a 2d                	push   $0x2d
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe8:	ff d0                	call   *%eax
  800fea:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800fed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ff0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ff3:	f7 d8                	neg    %eax
  800ff5:	83 d2 00             	adc    $0x0,%edx
  800ff8:	f7 da                	neg    %edx
  800ffa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ffd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801000:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801007:	e9 bc 00 00 00       	jmp    8010c8 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80100c:	83 ec 08             	sub    $0x8,%esp
  80100f:	ff 75 e8             	pushl  -0x18(%ebp)
  801012:	8d 45 14             	lea    0x14(%ebp),%eax
  801015:	50                   	push   %eax
  801016:	e8 84 fc ff ff       	call   800c9f <getuint>
  80101b:	83 c4 10             	add    $0x10,%esp
  80101e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801021:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801024:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80102b:	e9 98 00 00 00       	jmp    8010c8 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801030:	83 ec 08             	sub    $0x8,%esp
  801033:	ff 75 0c             	pushl  0xc(%ebp)
  801036:	6a 58                	push   $0x58
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
  80103b:	ff d0                	call   *%eax
  80103d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801040:	83 ec 08             	sub    $0x8,%esp
  801043:	ff 75 0c             	pushl  0xc(%ebp)
  801046:	6a 58                	push   $0x58
  801048:	8b 45 08             	mov    0x8(%ebp),%eax
  80104b:	ff d0                	call   *%eax
  80104d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801050:	83 ec 08             	sub    $0x8,%esp
  801053:	ff 75 0c             	pushl  0xc(%ebp)
  801056:	6a 58                	push   $0x58
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
  80105b:	ff d0                	call   *%eax
  80105d:	83 c4 10             	add    $0x10,%esp
			break;
  801060:	e9 bc 00 00 00       	jmp    801121 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801065:	83 ec 08             	sub    $0x8,%esp
  801068:	ff 75 0c             	pushl  0xc(%ebp)
  80106b:	6a 30                	push   $0x30
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	ff d0                	call   *%eax
  801072:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801075:	83 ec 08             	sub    $0x8,%esp
  801078:	ff 75 0c             	pushl  0xc(%ebp)
  80107b:	6a 78                	push   $0x78
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
  801080:	ff d0                	call   *%eax
  801082:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801085:	8b 45 14             	mov    0x14(%ebp),%eax
  801088:	83 c0 04             	add    $0x4,%eax
  80108b:	89 45 14             	mov    %eax,0x14(%ebp)
  80108e:	8b 45 14             	mov    0x14(%ebp),%eax
  801091:	83 e8 04             	sub    $0x4,%eax
  801094:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801096:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801099:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8010a0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8010a7:	eb 1f                	jmp    8010c8 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8010a9:	83 ec 08             	sub    $0x8,%esp
  8010ac:	ff 75 e8             	pushl  -0x18(%ebp)
  8010af:	8d 45 14             	lea    0x14(%ebp),%eax
  8010b2:	50                   	push   %eax
  8010b3:	e8 e7 fb ff ff       	call   800c9f <getuint>
  8010b8:	83 c4 10             	add    $0x10,%esp
  8010bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010be:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8010c1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8010c8:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8010cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010cf:	83 ec 04             	sub    $0x4,%esp
  8010d2:	52                   	push   %edx
  8010d3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010d6:	50                   	push   %eax
  8010d7:	ff 75 f4             	pushl  -0xc(%ebp)
  8010da:	ff 75 f0             	pushl  -0x10(%ebp)
  8010dd:	ff 75 0c             	pushl  0xc(%ebp)
  8010e0:	ff 75 08             	pushl  0x8(%ebp)
  8010e3:	e8 00 fb ff ff       	call   800be8 <printnum>
  8010e8:	83 c4 20             	add    $0x20,%esp
			break;
  8010eb:	eb 34                	jmp    801121 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8010ed:	83 ec 08             	sub    $0x8,%esp
  8010f0:	ff 75 0c             	pushl  0xc(%ebp)
  8010f3:	53                   	push   %ebx
  8010f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f7:	ff d0                	call   *%eax
  8010f9:	83 c4 10             	add    $0x10,%esp
			break;
  8010fc:	eb 23                	jmp    801121 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8010fe:	83 ec 08             	sub    $0x8,%esp
  801101:	ff 75 0c             	pushl  0xc(%ebp)
  801104:	6a 25                	push   $0x25
  801106:	8b 45 08             	mov    0x8(%ebp),%eax
  801109:	ff d0                	call   *%eax
  80110b:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80110e:	ff 4d 10             	decl   0x10(%ebp)
  801111:	eb 03                	jmp    801116 <vprintfmt+0x3b1>
  801113:	ff 4d 10             	decl   0x10(%ebp)
  801116:	8b 45 10             	mov    0x10(%ebp),%eax
  801119:	48                   	dec    %eax
  80111a:	8a 00                	mov    (%eax),%al
  80111c:	3c 25                	cmp    $0x25,%al
  80111e:	75 f3                	jne    801113 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801120:	90                   	nop
		}
	}
  801121:	e9 47 fc ff ff       	jmp    800d6d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801126:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801127:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80112a:	5b                   	pop    %ebx
  80112b:	5e                   	pop    %esi
  80112c:	5d                   	pop    %ebp
  80112d:	c3                   	ret    

0080112e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80112e:	55                   	push   %ebp
  80112f:	89 e5                	mov    %esp,%ebp
  801131:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801134:	8d 45 10             	lea    0x10(%ebp),%eax
  801137:	83 c0 04             	add    $0x4,%eax
  80113a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80113d:	8b 45 10             	mov    0x10(%ebp),%eax
  801140:	ff 75 f4             	pushl  -0xc(%ebp)
  801143:	50                   	push   %eax
  801144:	ff 75 0c             	pushl  0xc(%ebp)
  801147:	ff 75 08             	pushl  0x8(%ebp)
  80114a:	e8 16 fc ff ff       	call   800d65 <vprintfmt>
  80114f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801152:	90                   	nop
  801153:	c9                   	leave  
  801154:	c3                   	ret    

00801155 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801155:	55                   	push   %ebp
  801156:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801158:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115b:	8b 40 08             	mov    0x8(%eax),%eax
  80115e:	8d 50 01             	lea    0x1(%eax),%edx
  801161:	8b 45 0c             	mov    0xc(%ebp),%eax
  801164:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801167:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116a:	8b 10                	mov    (%eax),%edx
  80116c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116f:	8b 40 04             	mov    0x4(%eax),%eax
  801172:	39 c2                	cmp    %eax,%edx
  801174:	73 12                	jae    801188 <sprintputch+0x33>
		*b->buf++ = ch;
  801176:	8b 45 0c             	mov    0xc(%ebp),%eax
  801179:	8b 00                	mov    (%eax),%eax
  80117b:	8d 48 01             	lea    0x1(%eax),%ecx
  80117e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801181:	89 0a                	mov    %ecx,(%edx)
  801183:	8b 55 08             	mov    0x8(%ebp),%edx
  801186:	88 10                	mov    %dl,(%eax)
}
  801188:	90                   	nop
  801189:	5d                   	pop    %ebp
  80118a:	c3                   	ret    

0080118b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80118b:	55                   	push   %ebp
  80118c:	89 e5                	mov    %esp,%ebp
  80118e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801191:	8b 45 08             	mov    0x8(%ebp),%eax
  801194:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801197:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80119d:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a0:	01 d0                	add    %edx,%eax
  8011a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8011ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011b0:	74 06                	je     8011b8 <vsnprintf+0x2d>
  8011b2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011b6:	7f 07                	jg     8011bf <vsnprintf+0x34>
		return -E_INVAL;
  8011b8:	b8 03 00 00 00       	mov    $0x3,%eax
  8011bd:	eb 20                	jmp    8011df <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8011bf:	ff 75 14             	pushl  0x14(%ebp)
  8011c2:	ff 75 10             	pushl  0x10(%ebp)
  8011c5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8011c8:	50                   	push   %eax
  8011c9:	68 55 11 80 00       	push   $0x801155
  8011ce:	e8 92 fb ff ff       	call   800d65 <vprintfmt>
  8011d3:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8011d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011d9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8011dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8011df:	c9                   	leave  
  8011e0:	c3                   	ret    

008011e1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011e1:	55                   	push   %ebp
  8011e2:	89 e5                	mov    %esp,%ebp
  8011e4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8011e7:	8d 45 10             	lea    0x10(%ebp),%eax
  8011ea:	83 c0 04             	add    $0x4,%eax
  8011ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8011f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8011f6:	50                   	push   %eax
  8011f7:	ff 75 0c             	pushl  0xc(%ebp)
  8011fa:	ff 75 08             	pushl  0x8(%ebp)
  8011fd:	e8 89 ff ff ff       	call   80118b <vsnprintf>
  801202:	83 c4 10             	add    $0x10,%esp
  801205:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801208:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80120b:	c9                   	leave  
  80120c:	c3                   	ret    

0080120d <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  80120d:	55                   	push   %ebp
  80120e:	89 e5                	mov    %esp,%ebp
  801210:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  801213:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801217:	74 13                	je     80122c <readline+0x1f>
		cprintf("%s", prompt);
  801219:	83 ec 08             	sub    $0x8,%esp
  80121c:	ff 75 08             	pushl  0x8(%ebp)
  80121f:	68 50 42 80 00       	push   $0x804250
  801224:	e8 62 f9 ff ff       	call   800b8b <cprintf>
  801229:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80122c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801233:	83 ec 0c             	sub    $0xc,%esp
  801236:	6a 00                	push   $0x0
  801238:	e8 54 f5 ff ff       	call   800791 <iscons>
  80123d:	83 c4 10             	add    $0x10,%esp
  801240:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801243:	e8 fb f4 ff ff       	call   800743 <getchar>
  801248:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80124b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80124f:	79 22                	jns    801273 <readline+0x66>
			if (c != -E_EOF)
  801251:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801255:	0f 84 ad 00 00 00    	je     801308 <readline+0xfb>
				cprintf("read error: %e\n", c);
  80125b:	83 ec 08             	sub    $0x8,%esp
  80125e:	ff 75 ec             	pushl  -0x14(%ebp)
  801261:	68 53 42 80 00       	push   $0x804253
  801266:	e8 20 f9 ff ff       	call   800b8b <cprintf>
  80126b:	83 c4 10             	add    $0x10,%esp
			return;
  80126e:	e9 95 00 00 00       	jmp    801308 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801273:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801277:	7e 34                	jle    8012ad <readline+0xa0>
  801279:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801280:	7f 2b                	jg     8012ad <readline+0xa0>
			if (echoing)
  801282:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801286:	74 0e                	je     801296 <readline+0x89>
				cputchar(c);
  801288:	83 ec 0c             	sub    $0xc,%esp
  80128b:	ff 75 ec             	pushl  -0x14(%ebp)
  80128e:	e8 68 f4 ff ff       	call   8006fb <cputchar>
  801293:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801296:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801299:	8d 50 01             	lea    0x1(%eax),%edx
  80129c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80129f:	89 c2                	mov    %eax,%edx
  8012a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a4:	01 d0                	add    %edx,%eax
  8012a6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012a9:	88 10                	mov    %dl,(%eax)
  8012ab:	eb 56                	jmp    801303 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  8012ad:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8012b1:	75 1f                	jne    8012d2 <readline+0xc5>
  8012b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8012b7:	7e 19                	jle    8012d2 <readline+0xc5>
			if (echoing)
  8012b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012bd:	74 0e                	je     8012cd <readline+0xc0>
				cputchar(c);
  8012bf:	83 ec 0c             	sub    $0xc,%esp
  8012c2:	ff 75 ec             	pushl  -0x14(%ebp)
  8012c5:	e8 31 f4 ff ff       	call   8006fb <cputchar>
  8012ca:	83 c4 10             	add    $0x10,%esp

			i--;
  8012cd:	ff 4d f4             	decl   -0xc(%ebp)
  8012d0:	eb 31                	jmp    801303 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  8012d2:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8012d6:	74 0a                	je     8012e2 <readline+0xd5>
  8012d8:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8012dc:	0f 85 61 ff ff ff    	jne    801243 <readline+0x36>
			if (echoing)
  8012e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012e6:	74 0e                	je     8012f6 <readline+0xe9>
				cputchar(c);
  8012e8:	83 ec 0c             	sub    $0xc,%esp
  8012eb:	ff 75 ec             	pushl  -0x14(%ebp)
  8012ee:	e8 08 f4 ff ff       	call   8006fb <cputchar>
  8012f3:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8012f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fc:	01 d0                	add    %edx,%eax
  8012fe:	c6 00 00             	movb   $0x0,(%eax)
			return;
  801301:	eb 06                	jmp    801309 <readline+0xfc>
		}
	}
  801303:	e9 3b ff ff ff       	jmp    801243 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  801308:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  801309:	c9                   	leave  
  80130a:	c3                   	ret    

0080130b <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  80130b:	55                   	push   %ebp
  80130c:	89 e5                	mov    %esp,%ebp
  80130e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801311:	e8 04 0f 00 00       	call   80221a <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  801316:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80131a:	74 13                	je     80132f <atomic_readline+0x24>
		cprintf("%s", prompt);
  80131c:	83 ec 08             	sub    $0x8,%esp
  80131f:	ff 75 08             	pushl  0x8(%ebp)
  801322:	68 50 42 80 00       	push   $0x804250
  801327:	e8 5f f8 ff ff       	call   800b8b <cprintf>
  80132c:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80132f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801336:	83 ec 0c             	sub    $0xc,%esp
  801339:	6a 00                	push   $0x0
  80133b:	e8 51 f4 ff ff       	call   800791 <iscons>
  801340:	83 c4 10             	add    $0x10,%esp
  801343:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801346:	e8 f8 f3 ff ff       	call   800743 <getchar>
  80134b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80134e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801352:	79 23                	jns    801377 <atomic_readline+0x6c>
			if (c != -E_EOF)
  801354:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801358:	74 13                	je     80136d <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  80135a:	83 ec 08             	sub    $0x8,%esp
  80135d:	ff 75 ec             	pushl  -0x14(%ebp)
  801360:	68 53 42 80 00       	push   $0x804253
  801365:	e8 21 f8 ff ff       	call   800b8b <cprintf>
  80136a:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  80136d:	e8 c2 0e 00 00       	call   802234 <sys_enable_interrupt>
			return;
  801372:	e9 9a 00 00 00       	jmp    801411 <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801377:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80137b:	7e 34                	jle    8013b1 <atomic_readline+0xa6>
  80137d:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801384:	7f 2b                	jg     8013b1 <atomic_readline+0xa6>
			if (echoing)
  801386:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80138a:	74 0e                	je     80139a <atomic_readline+0x8f>
				cputchar(c);
  80138c:	83 ec 0c             	sub    $0xc,%esp
  80138f:	ff 75 ec             	pushl  -0x14(%ebp)
  801392:	e8 64 f3 ff ff       	call   8006fb <cputchar>
  801397:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80139a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80139d:	8d 50 01             	lea    0x1(%eax),%edx
  8013a0:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8013a3:	89 c2                	mov    %eax,%edx
  8013a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a8:	01 d0                	add    %edx,%eax
  8013aa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013ad:	88 10                	mov    %dl,(%eax)
  8013af:	eb 5b                	jmp    80140c <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  8013b1:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8013b5:	75 1f                	jne    8013d6 <atomic_readline+0xcb>
  8013b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8013bb:	7e 19                	jle    8013d6 <atomic_readline+0xcb>
			if (echoing)
  8013bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013c1:	74 0e                	je     8013d1 <atomic_readline+0xc6>
				cputchar(c);
  8013c3:	83 ec 0c             	sub    $0xc,%esp
  8013c6:	ff 75 ec             	pushl  -0x14(%ebp)
  8013c9:	e8 2d f3 ff ff       	call   8006fb <cputchar>
  8013ce:	83 c4 10             	add    $0x10,%esp
			i--;
  8013d1:	ff 4d f4             	decl   -0xc(%ebp)
  8013d4:	eb 36                	jmp    80140c <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  8013d6:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8013da:	74 0a                	je     8013e6 <atomic_readline+0xdb>
  8013dc:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8013e0:	0f 85 60 ff ff ff    	jne    801346 <atomic_readline+0x3b>
			if (echoing)
  8013e6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013ea:	74 0e                	je     8013fa <atomic_readline+0xef>
				cputchar(c);
  8013ec:	83 ec 0c             	sub    $0xc,%esp
  8013ef:	ff 75 ec             	pushl  -0x14(%ebp)
  8013f2:	e8 04 f3 ff ff       	call   8006fb <cputchar>
  8013f7:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  8013fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801400:	01 d0                	add    %edx,%eax
  801402:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  801405:	e8 2a 0e 00 00       	call   802234 <sys_enable_interrupt>
			return;
  80140a:	eb 05                	jmp    801411 <atomic_readline+0x106>
		}
	}
  80140c:	e9 35 ff ff ff       	jmp    801346 <atomic_readline+0x3b>
}
  801411:	c9                   	leave  
  801412:	c3                   	ret    

00801413 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801413:	55                   	push   %ebp
  801414:	89 e5                	mov    %esp,%ebp
  801416:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801419:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801420:	eb 06                	jmp    801428 <strlen+0x15>
		n++;
  801422:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801425:	ff 45 08             	incl   0x8(%ebp)
  801428:	8b 45 08             	mov    0x8(%ebp),%eax
  80142b:	8a 00                	mov    (%eax),%al
  80142d:	84 c0                	test   %al,%al
  80142f:	75 f1                	jne    801422 <strlen+0xf>
		n++;
	return n;
  801431:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801434:	c9                   	leave  
  801435:	c3                   	ret    

00801436 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801436:	55                   	push   %ebp
  801437:	89 e5                	mov    %esp,%ebp
  801439:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80143c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801443:	eb 09                	jmp    80144e <strnlen+0x18>
		n++;
  801445:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801448:	ff 45 08             	incl   0x8(%ebp)
  80144b:	ff 4d 0c             	decl   0xc(%ebp)
  80144e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801452:	74 09                	je     80145d <strnlen+0x27>
  801454:	8b 45 08             	mov    0x8(%ebp),%eax
  801457:	8a 00                	mov    (%eax),%al
  801459:	84 c0                	test   %al,%al
  80145b:	75 e8                	jne    801445 <strnlen+0xf>
		n++;
	return n;
  80145d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801460:	c9                   	leave  
  801461:	c3                   	ret    

00801462 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801462:	55                   	push   %ebp
  801463:	89 e5                	mov    %esp,%ebp
  801465:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801468:	8b 45 08             	mov    0x8(%ebp),%eax
  80146b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80146e:	90                   	nop
  80146f:	8b 45 08             	mov    0x8(%ebp),%eax
  801472:	8d 50 01             	lea    0x1(%eax),%edx
  801475:	89 55 08             	mov    %edx,0x8(%ebp)
  801478:	8b 55 0c             	mov    0xc(%ebp),%edx
  80147b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80147e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801481:	8a 12                	mov    (%edx),%dl
  801483:	88 10                	mov    %dl,(%eax)
  801485:	8a 00                	mov    (%eax),%al
  801487:	84 c0                	test   %al,%al
  801489:	75 e4                	jne    80146f <strcpy+0xd>
		/* do nothing */;
	return ret;
  80148b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80148e:	c9                   	leave  
  80148f:	c3                   	ret    

00801490 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801490:	55                   	push   %ebp
  801491:	89 e5                	mov    %esp,%ebp
  801493:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801496:	8b 45 08             	mov    0x8(%ebp),%eax
  801499:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80149c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014a3:	eb 1f                	jmp    8014c4 <strncpy+0x34>
		*dst++ = *src;
  8014a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a8:	8d 50 01             	lea    0x1(%eax),%edx
  8014ab:	89 55 08             	mov    %edx,0x8(%ebp)
  8014ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b1:	8a 12                	mov    (%edx),%dl
  8014b3:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8014b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b8:	8a 00                	mov    (%eax),%al
  8014ba:	84 c0                	test   %al,%al
  8014bc:	74 03                	je     8014c1 <strncpy+0x31>
			src++;
  8014be:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8014c1:	ff 45 fc             	incl   -0x4(%ebp)
  8014c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014c7:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014ca:	72 d9                	jb     8014a5 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8014cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014cf:	c9                   	leave  
  8014d0:	c3                   	ret    

008014d1 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8014d1:	55                   	push   %ebp
  8014d2:	89 e5                	mov    %esp,%ebp
  8014d4:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8014d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014da:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8014dd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014e1:	74 30                	je     801513 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8014e3:	eb 16                	jmp    8014fb <strlcpy+0x2a>
			*dst++ = *src++;
  8014e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e8:	8d 50 01             	lea    0x1(%eax),%edx
  8014eb:	89 55 08             	mov    %edx,0x8(%ebp)
  8014ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014f1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014f4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014f7:	8a 12                	mov    (%edx),%dl
  8014f9:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014fb:	ff 4d 10             	decl   0x10(%ebp)
  8014fe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801502:	74 09                	je     80150d <strlcpy+0x3c>
  801504:	8b 45 0c             	mov    0xc(%ebp),%eax
  801507:	8a 00                	mov    (%eax),%al
  801509:	84 c0                	test   %al,%al
  80150b:	75 d8                	jne    8014e5 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80150d:	8b 45 08             	mov    0x8(%ebp),%eax
  801510:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801513:	8b 55 08             	mov    0x8(%ebp),%edx
  801516:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801519:	29 c2                	sub    %eax,%edx
  80151b:	89 d0                	mov    %edx,%eax
}
  80151d:	c9                   	leave  
  80151e:	c3                   	ret    

0080151f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80151f:	55                   	push   %ebp
  801520:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801522:	eb 06                	jmp    80152a <strcmp+0xb>
		p++, q++;
  801524:	ff 45 08             	incl   0x8(%ebp)
  801527:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80152a:	8b 45 08             	mov    0x8(%ebp),%eax
  80152d:	8a 00                	mov    (%eax),%al
  80152f:	84 c0                	test   %al,%al
  801531:	74 0e                	je     801541 <strcmp+0x22>
  801533:	8b 45 08             	mov    0x8(%ebp),%eax
  801536:	8a 10                	mov    (%eax),%dl
  801538:	8b 45 0c             	mov    0xc(%ebp),%eax
  80153b:	8a 00                	mov    (%eax),%al
  80153d:	38 c2                	cmp    %al,%dl
  80153f:	74 e3                	je     801524 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801541:	8b 45 08             	mov    0x8(%ebp),%eax
  801544:	8a 00                	mov    (%eax),%al
  801546:	0f b6 d0             	movzbl %al,%edx
  801549:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154c:	8a 00                	mov    (%eax),%al
  80154e:	0f b6 c0             	movzbl %al,%eax
  801551:	29 c2                	sub    %eax,%edx
  801553:	89 d0                	mov    %edx,%eax
}
  801555:	5d                   	pop    %ebp
  801556:	c3                   	ret    

00801557 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801557:	55                   	push   %ebp
  801558:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80155a:	eb 09                	jmp    801565 <strncmp+0xe>
		n--, p++, q++;
  80155c:	ff 4d 10             	decl   0x10(%ebp)
  80155f:	ff 45 08             	incl   0x8(%ebp)
  801562:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801565:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801569:	74 17                	je     801582 <strncmp+0x2b>
  80156b:	8b 45 08             	mov    0x8(%ebp),%eax
  80156e:	8a 00                	mov    (%eax),%al
  801570:	84 c0                	test   %al,%al
  801572:	74 0e                	je     801582 <strncmp+0x2b>
  801574:	8b 45 08             	mov    0x8(%ebp),%eax
  801577:	8a 10                	mov    (%eax),%dl
  801579:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157c:	8a 00                	mov    (%eax),%al
  80157e:	38 c2                	cmp    %al,%dl
  801580:	74 da                	je     80155c <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801582:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801586:	75 07                	jne    80158f <strncmp+0x38>
		return 0;
  801588:	b8 00 00 00 00       	mov    $0x0,%eax
  80158d:	eb 14                	jmp    8015a3 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80158f:	8b 45 08             	mov    0x8(%ebp),%eax
  801592:	8a 00                	mov    (%eax),%al
  801594:	0f b6 d0             	movzbl %al,%edx
  801597:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159a:	8a 00                	mov    (%eax),%al
  80159c:	0f b6 c0             	movzbl %al,%eax
  80159f:	29 c2                	sub    %eax,%edx
  8015a1:	89 d0                	mov    %edx,%eax
}
  8015a3:	5d                   	pop    %ebp
  8015a4:	c3                   	ret    

008015a5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8015a5:	55                   	push   %ebp
  8015a6:	89 e5                	mov    %esp,%ebp
  8015a8:	83 ec 04             	sub    $0x4,%esp
  8015ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ae:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015b1:	eb 12                	jmp    8015c5 <strchr+0x20>
		if (*s == c)
  8015b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b6:	8a 00                	mov    (%eax),%al
  8015b8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015bb:	75 05                	jne    8015c2 <strchr+0x1d>
			return (char *) s;
  8015bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c0:	eb 11                	jmp    8015d3 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8015c2:	ff 45 08             	incl   0x8(%ebp)
  8015c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c8:	8a 00                	mov    (%eax),%al
  8015ca:	84 c0                	test   %al,%al
  8015cc:	75 e5                	jne    8015b3 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8015ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015d3:	c9                   	leave  
  8015d4:	c3                   	ret    

008015d5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8015d5:	55                   	push   %ebp
  8015d6:	89 e5                	mov    %esp,%ebp
  8015d8:	83 ec 04             	sub    $0x4,%esp
  8015db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015de:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015e1:	eb 0d                	jmp    8015f0 <strfind+0x1b>
		if (*s == c)
  8015e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e6:	8a 00                	mov    (%eax),%al
  8015e8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015eb:	74 0e                	je     8015fb <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8015ed:	ff 45 08             	incl   0x8(%ebp)
  8015f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f3:	8a 00                	mov    (%eax),%al
  8015f5:	84 c0                	test   %al,%al
  8015f7:	75 ea                	jne    8015e3 <strfind+0xe>
  8015f9:	eb 01                	jmp    8015fc <strfind+0x27>
		if (*s == c)
			break;
  8015fb:	90                   	nop
	return (char *) s;
  8015fc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015ff:	c9                   	leave  
  801600:	c3                   	ret    

00801601 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801601:	55                   	push   %ebp
  801602:	89 e5                	mov    %esp,%ebp
  801604:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801607:	8b 45 08             	mov    0x8(%ebp),%eax
  80160a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80160d:	8b 45 10             	mov    0x10(%ebp),%eax
  801610:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801613:	eb 0e                	jmp    801623 <memset+0x22>
		*p++ = c;
  801615:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801618:	8d 50 01             	lea    0x1(%eax),%edx
  80161b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80161e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801621:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801623:	ff 4d f8             	decl   -0x8(%ebp)
  801626:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80162a:	79 e9                	jns    801615 <memset+0x14>
		*p++ = c;

	return v;
  80162c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80162f:	c9                   	leave  
  801630:	c3                   	ret    

00801631 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801631:	55                   	push   %ebp
  801632:	89 e5                	mov    %esp,%ebp
  801634:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801637:	8b 45 0c             	mov    0xc(%ebp),%eax
  80163a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80163d:	8b 45 08             	mov    0x8(%ebp),%eax
  801640:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801643:	eb 16                	jmp    80165b <memcpy+0x2a>
		*d++ = *s++;
  801645:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801648:	8d 50 01             	lea    0x1(%eax),%edx
  80164b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80164e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801651:	8d 4a 01             	lea    0x1(%edx),%ecx
  801654:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801657:	8a 12                	mov    (%edx),%dl
  801659:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80165b:	8b 45 10             	mov    0x10(%ebp),%eax
  80165e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801661:	89 55 10             	mov    %edx,0x10(%ebp)
  801664:	85 c0                	test   %eax,%eax
  801666:	75 dd                	jne    801645 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801668:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80166b:	c9                   	leave  
  80166c:	c3                   	ret    

0080166d <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80166d:	55                   	push   %ebp
  80166e:	89 e5                	mov    %esp,%ebp
  801670:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801673:	8b 45 0c             	mov    0xc(%ebp),%eax
  801676:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801679:	8b 45 08             	mov    0x8(%ebp),%eax
  80167c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80167f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801682:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801685:	73 50                	jae    8016d7 <memmove+0x6a>
  801687:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80168a:	8b 45 10             	mov    0x10(%ebp),%eax
  80168d:	01 d0                	add    %edx,%eax
  80168f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801692:	76 43                	jbe    8016d7 <memmove+0x6a>
		s += n;
  801694:	8b 45 10             	mov    0x10(%ebp),%eax
  801697:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80169a:	8b 45 10             	mov    0x10(%ebp),%eax
  80169d:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8016a0:	eb 10                	jmp    8016b2 <memmove+0x45>
			*--d = *--s;
  8016a2:	ff 4d f8             	decl   -0x8(%ebp)
  8016a5:	ff 4d fc             	decl   -0x4(%ebp)
  8016a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016ab:	8a 10                	mov    (%eax),%dl
  8016ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016b0:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8016b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016b8:	89 55 10             	mov    %edx,0x10(%ebp)
  8016bb:	85 c0                	test   %eax,%eax
  8016bd:	75 e3                	jne    8016a2 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8016bf:	eb 23                	jmp    8016e4 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8016c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016c4:	8d 50 01             	lea    0x1(%eax),%edx
  8016c7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016cd:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016d0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8016d3:	8a 12                	mov    (%edx),%dl
  8016d5:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8016d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8016da:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016dd:	89 55 10             	mov    %edx,0x10(%ebp)
  8016e0:	85 c0                	test   %eax,%eax
  8016e2:	75 dd                	jne    8016c1 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8016e4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016e7:	c9                   	leave  
  8016e8:	c3                   	ret    

008016e9 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8016e9:	55                   	push   %ebp
  8016ea:	89 e5                	mov    %esp,%ebp
  8016ec:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8016f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f8:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8016fb:	eb 2a                	jmp    801727 <memcmp+0x3e>
		if (*s1 != *s2)
  8016fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801700:	8a 10                	mov    (%eax),%dl
  801702:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801705:	8a 00                	mov    (%eax),%al
  801707:	38 c2                	cmp    %al,%dl
  801709:	74 16                	je     801721 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80170b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80170e:	8a 00                	mov    (%eax),%al
  801710:	0f b6 d0             	movzbl %al,%edx
  801713:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801716:	8a 00                	mov    (%eax),%al
  801718:	0f b6 c0             	movzbl %al,%eax
  80171b:	29 c2                	sub    %eax,%edx
  80171d:	89 d0                	mov    %edx,%eax
  80171f:	eb 18                	jmp    801739 <memcmp+0x50>
		s1++, s2++;
  801721:	ff 45 fc             	incl   -0x4(%ebp)
  801724:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801727:	8b 45 10             	mov    0x10(%ebp),%eax
  80172a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80172d:	89 55 10             	mov    %edx,0x10(%ebp)
  801730:	85 c0                	test   %eax,%eax
  801732:	75 c9                	jne    8016fd <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801734:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801739:	c9                   	leave  
  80173a:	c3                   	ret    

0080173b <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80173b:	55                   	push   %ebp
  80173c:	89 e5                	mov    %esp,%ebp
  80173e:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801741:	8b 55 08             	mov    0x8(%ebp),%edx
  801744:	8b 45 10             	mov    0x10(%ebp),%eax
  801747:	01 d0                	add    %edx,%eax
  801749:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80174c:	eb 15                	jmp    801763 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80174e:	8b 45 08             	mov    0x8(%ebp),%eax
  801751:	8a 00                	mov    (%eax),%al
  801753:	0f b6 d0             	movzbl %al,%edx
  801756:	8b 45 0c             	mov    0xc(%ebp),%eax
  801759:	0f b6 c0             	movzbl %al,%eax
  80175c:	39 c2                	cmp    %eax,%edx
  80175e:	74 0d                	je     80176d <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801760:	ff 45 08             	incl   0x8(%ebp)
  801763:	8b 45 08             	mov    0x8(%ebp),%eax
  801766:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801769:	72 e3                	jb     80174e <memfind+0x13>
  80176b:	eb 01                	jmp    80176e <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80176d:	90                   	nop
	return (void *) s;
  80176e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801771:	c9                   	leave  
  801772:	c3                   	ret    

00801773 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
  801776:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801779:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801780:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801787:	eb 03                	jmp    80178c <strtol+0x19>
		s++;
  801789:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80178c:	8b 45 08             	mov    0x8(%ebp),%eax
  80178f:	8a 00                	mov    (%eax),%al
  801791:	3c 20                	cmp    $0x20,%al
  801793:	74 f4                	je     801789 <strtol+0x16>
  801795:	8b 45 08             	mov    0x8(%ebp),%eax
  801798:	8a 00                	mov    (%eax),%al
  80179a:	3c 09                	cmp    $0x9,%al
  80179c:	74 eb                	je     801789 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80179e:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a1:	8a 00                	mov    (%eax),%al
  8017a3:	3c 2b                	cmp    $0x2b,%al
  8017a5:	75 05                	jne    8017ac <strtol+0x39>
		s++;
  8017a7:	ff 45 08             	incl   0x8(%ebp)
  8017aa:	eb 13                	jmp    8017bf <strtol+0x4c>
	else if (*s == '-')
  8017ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8017af:	8a 00                	mov    (%eax),%al
  8017b1:	3c 2d                	cmp    $0x2d,%al
  8017b3:	75 0a                	jne    8017bf <strtol+0x4c>
		s++, neg = 1;
  8017b5:	ff 45 08             	incl   0x8(%ebp)
  8017b8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017bf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017c3:	74 06                	je     8017cb <strtol+0x58>
  8017c5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8017c9:	75 20                	jne    8017eb <strtol+0x78>
  8017cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ce:	8a 00                	mov    (%eax),%al
  8017d0:	3c 30                	cmp    $0x30,%al
  8017d2:	75 17                	jne    8017eb <strtol+0x78>
  8017d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d7:	40                   	inc    %eax
  8017d8:	8a 00                	mov    (%eax),%al
  8017da:	3c 78                	cmp    $0x78,%al
  8017dc:	75 0d                	jne    8017eb <strtol+0x78>
		s += 2, base = 16;
  8017de:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8017e2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8017e9:	eb 28                	jmp    801813 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8017eb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017ef:	75 15                	jne    801806 <strtol+0x93>
  8017f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f4:	8a 00                	mov    (%eax),%al
  8017f6:	3c 30                	cmp    $0x30,%al
  8017f8:	75 0c                	jne    801806 <strtol+0x93>
		s++, base = 8;
  8017fa:	ff 45 08             	incl   0x8(%ebp)
  8017fd:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801804:	eb 0d                	jmp    801813 <strtol+0xa0>
	else if (base == 0)
  801806:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80180a:	75 07                	jne    801813 <strtol+0xa0>
		base = 10;
  80180c:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801813:	8b 45 08             	mov    0x8(%ebp),%eax
  801816:	8a 00                	mov    (%eax),%al
  801818:	3c 2f                	cmp    $0x2f,%al
  80181a:	7e 19                	jle    801835 <strtol+0xc2>
  80181c:	8b 45 08             	mov    0x8(%ebp),%eax
  80181f:	8a 00                	mov    (%eax),%al
  801821:	3c 39                	cmp    $0x39,%al
  801823:	7f 10                	jg     801835 <strtol+0xc2>
			dig = *s - '0';
  801825:	8b 45 08             	mov    0x8(%ebp),%eax
  801828:	8a 00                	mov    (%eax),%al
  80182a:	0f be c0             	movsbl %al,%eax
  80182d:	83 e8 30             	sub    $0x30,%eax
  801830:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801833:	eb 42                	jmp    801877 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801835:	8b 45 08             	mov    0x8(%ebp),%eax
  801838:	8a 00                	mov    (%eax),%al
  80183a:	3c 60                	cmp    $0x60,%al
  80183c:	7e 19                	jle    801857 <strtol+0xe4>
  80183e:	8b 45 08             	mov    0x8(%ebp),%eax
  801841:	8a 00                	mov    (%eax),%al
  801843:	3c 7a                	cmp    $0x7a,%al
  801845:	7f 10                	jg     801857 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801847:	8b 45 08             	mov    0x8(%ebp),%eax
  80184a:	8a 00                	mov    (%eax),%al
  80184c:	0f be c0             	movsbl %al,%eax
  80184f:	83 e8 57             	sub    $0x57,%eax
  801852:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801855:	eb 20                	jmp    801877 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801857:	8b 45 08             	mov    0x8(%ebp),%eax
  80185a:	8a 00                	mov    (%eax),%al
  80185c:	3c 40                	cmp    $0x40,%al
  80185e:	7e 39                	jle    801899 <strtol+0x126>
  801860:	8b 45 08             	mov    0x8(%ebp),%eax
  801863:	8a 00                	mov    (%eax),%al
  801865:	3c 5a                	cmp    $0x5a,%al
  801867:	7f 30                	jg     801899 <strtol+0x126>
			dig = *s - 'A' + 10;
  801869:	8b 45 08             	mov    0x8(%ebp),%eax
  80186c:	8a 00                	mov    (%eax),%al
  80186e:	0f be c0             	movsbl %al,%eax
  801871:	83 e8 37             	sub    $0x37,%eax
  801874:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801877:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80187a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80187d:	7d 19                	jge    801898 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80187f:	ff 45 08             	incl   0x8(%ebp)
  801882:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801885:	0f af 45 10          	imul   0x10(%ebp),%eax
  801889:	89 c2                	mov    %eax,%edx
  80188b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80188e:	01 d0                	add    %edx,%eax
  801890:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801893:	e9 7b ff ff ff       	jmp    801813 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801898:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801899:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80189d:	74 08                	je     8018a7 <strtol+0x134>
		*endptr = (char *) s;
  80189f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8018a5:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8018a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018ab:	74 07                	je     8018b4 <strtol+0x141>
  8018ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018b0:	f7 d8                	neg    %eax
  8018b2:	eb 03                	jmp    8018b7 <strtol+0x144>
  8018b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8018b7:	c9                   	leave  
  8018b8:	c3                   	ret    

008018b9 <ltostr>:

void
ltostr(long value, char *str)
{
  8018b9:	55                   	push   %ebp
  8018ba:	89 e5                	mov    %esp,%ebp
  8018bc:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8018bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8018c6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8018cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018d1:	79 13                	jns    8018e6 <ltostr+0x2d>
	{
		neg = 1;
  8018d3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8018da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018dd:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8018e0:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8018e3:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8018e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e9:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8018ee:	99                   	cltd   
  8018ef:	f7 f9                	idiv   %ecx
  8018f1:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8018f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018f7:	8d 50 01             	lea    0x1(%eax),%edx
  8018fa:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018fd:	89 c2                	mov    %eax,%edx
  8018ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801902:	01 d0                	add    %edx,%eax
  801904:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801907:	83 c2 30             	add    $0x30,%edx
  80190a:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80190c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80190f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801914:	f7 e9                	imul   %ecx
  801916:	c1 fa 02             	sar    $0x2,%edx
  801919:	89 c8                	mov    %ecx,%eax
  80191b:	c1 f8 1f             	sar    $0x1f,%eax
  80191e:	29 c2                	sub    %eax,%edx
  801920:	89 d0                	mov    %edx,%eax
  801922:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801925:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801928:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80192d:	f7 e9                	imul   %ecx
  80192f:	c1 fa 02             	sar    $0x2,%edx
  801932:	89 c8                	mov    %ecx,%eax
  801934:	c1 f8 1f             	sar    $0x1f,%eax
  801937:	29 c2                	sub    %eax,%edx
  801939:	89 d0                	mov    %edx,%eax
  80193b:	c1 e0 02             	shl    $0x2,%eax
  80193e:	01 d0                	add    %edx,%eax
  801940:	01 c0                	add    %eax,%eax
  801942:	29 c1                	sub    %eax,%ecx
  801944:	89 ca                	mov    %ecx,%edx
  801946:	85 d2                	test   %edx,%edx
  801948:	75 9c                	jne    8018e6 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80194a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801951:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801954:	48                   	dec    %eax
  801955:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801958:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80195c:	74 3d                	je     80199b <ltostr+0xe2>
		start = 1 ;
  80195e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801965:	eb 34                	jmp    80199b <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801967:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80196a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80196d:	01 d0                	add    %edx,%eax
  80196f:	8a 00                	mov    (%eax),%al
  801971:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801974:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801977:	8b 45 0c             	mov    0xc(%ebp),%eax
  80197a:	01 c2                	add    %eax,%edx
  80197c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80197f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801982:	01 c8                	add    %ecx,%eax
  801984:	8a 00                	mov    (%eax),%al
  801986:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801988:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80198b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80198e:	01 c2                	add    %eax,%edx
  801990:	8a 45 eb             	mov    -0x15(%ebp),%al
  801993:	88 02                	mov    %al,(%edx)
		start++ ;
  801995:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801998:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80199b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80199e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019a1:	7c c4                	jl     801967 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8019a3:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8019a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a9:	01 d0                	add    %edx,%eax
  8019ab:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8019ae:	90                   	nop
  8019af:	c9                   	leave  
  8019b0:	c3                   	ret    

008019b1 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8019b1:	55                   	push   %ebp
  8019b2:	89 e5                	mov    %esp,%ebp
  8019b4:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8019b7:	ff 75 08             	pushl  0x8(%ebp)
  8019ba:	e8 54 fa ff ff       	call   801413 <strlen>
  8019bf:	83 c4 04             	add    $0x4,%esp
  8019c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8019c5:	ff 75 0c             	pushl  0xc(%ebp)
  8019c8:	e8 46 fa ff ff       	call   801413 <strlen>
  8019cd:	83 c4 04             	add    $0x4,%esp
  8019d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8019d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8019da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8019e1:	eb 17                	jmp    8019fa <strcconcat+0x49>
		final[s] = str1[s] ;
  8019e3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8019e9:	01 c2                	add    %eax,%edx
  8019eb:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8019ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f1:	01 c8                	add    %ecx,%eax
  8019f3:	8a 00                	mov    (%eax),%al
  8019f5:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8019f7:	ff 45 fc             	incl   -0x4(%ebp)
  8019fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019fd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801a00:	7c e1                	jl     8019e3 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801a02:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801a09:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801a10:	eb 1f                	jmp    801a31 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801a12:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a15:	8d 50 01             	lea    0x1(%eax),%edx
  801a18:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801a1b:	89 c2                	mov    %eax,%edx
  801a1d:	8b 45 10             	mov    0x10(%ebp),%eax
  801a20:	01 c2                	add    %eax,%edx
  801a22:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801a25:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a28:	01 c8                	add    %ecx,%eax
  801a2a:	8a 00                	mov    (%eax),%al
  801a2c:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801a2e:	ff 45 f8             	incl   -0x8(%ebp)
  801a31:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a34:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a37:	7c d9                	jl     801a12 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801a39:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a3c:	8b 45 10             	mov    0x10(%ebp),%eax
  801a3f:	01 d0                	add    %edx,%eax
  801a41:	c6 00 00             	movb   $0x0,(%eax)
}
  801a44:	90                   	nop
  801a45:	c9                   	leave  
  801a46:	c3                   	ret    

00801a47 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a4a:	8b 45 14             	mov    0x14(%ebp),%eax
  801a4d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a53:	8b 45 14             	mov    0x14(%ebp),%eax
  801a56:	8b 00                	mov    (%eax),%eax
  801a58:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a5f:	8b 45 10             	mov    0x10(%ebp),%eax
  801a62:	01 d0                	add    %edx,%eax
  801a64:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a6a:	eb 0c                	jmp    801a78 <strsplit+0x31>
			*string++ = 0;
  801a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6f:	8d 50 01             	lea    0x1(%eax),%edx
  801a72:	89 55 08             	mov    %edx,0x8(%ebp)
  801a75:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a78:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7b:	8a 00                	mov    (%eax),%al
  801a7d:	84 c0                	test   %al,%al
  801a7f:	74 18                	je     801a99 <strsplit+0x52>
  801a81:	8b 45 08             	mov    0x8(%ebp),%eax
  801a84:	8a 00                	mov    (%eax),%al
  801a86:	0f be c0             	movsbl %al,%eax
  801a89:	50                   	push   %eax
  801a8a:	ff 75 0c             	pushl  0xc(%ebp)
  801a8d:	e8 13 fb ff ff       	call   8015a5 <strchr>
  801a92:	83 c4 08             	add    $0x8,%esp
  801a95:	85 c0                	test   %eax,%eax
  801a97:	75 d3                	jne    801a6c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a99:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9c:	8a 00                	mov    (%eax),%al
  801a9e:	84 c0                	test   %al,%al
  801aa0:	74 5a                	je     801afc <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801aa2:	8b 45 14             	mov    0x14(%ebp),%eax
  801aa5:	8b 00                	mov    (%eax),%eax
  801aa7:	83 f8 0f             	cmp    $0xf,%eax
  801aaa:	75 07                	jne    801ab3 <strsplit+0x6c>
		{
			return 0;
  801aac:	b8 00 00 00 00       	mov    $0x0,%eax
  801ab1:	eb 66                	jmp    801b19 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801ab3:	8b 45 14             	mov    0x14(%ebp),%eax
  801ab6:	8b 00                	mov    (%eax),%eax
  801ab8:	8d 48 01             	lea    0x1(%eax),%ecx
  801abb:	8b 55 14             	mov    0x14(%ebp),%edx
  801abe:	89 0a                	mov    %ecx,(%edx)
  801ac0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ac7:	8b 45 10             	mov    0x10(%ebp),%eax
  801aca:	01 c2                	add    %eax,%edx
  801acc:	8b 45 08             	mov    0x8(%ebp),%eax
  801acf:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ad1:	eb 03                	jmp    801ad6 <strsplit+0x8f>
			string++;
  801ad3:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad9:	8a 00                	mov    (%eax),%al
  801adb:	84 c0                	test   %al,%al
  801add:	74 8b                	je     801a6a <strsplit+0x23>
  801adf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae2:	8a 00                	mov    (%eax),%al
  801ae4:	0f be c0             	movsbl %al,%eax
  801ae7:	50                   	push   %eax
  801ae8:	ff 75 0c             	pushl  0xc(%ebp)
  801aeb:	e8 b5 fa ff ff       	call   8015a5 <strchr>
  801af0:	83 c4 08             	add    $0x8,%esp
  801af3:	85 c0                	test   %eax,%eax
  801af5:	74 dc                	je     801ad3 <strsplit+0x8c>
			string++;
	}
  801af7:	e9 6e ff ff ff       	jmp    801a6a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801afc:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801afd:	8b 45 14             	mov    0x14(%ebp),%eax
  801b00:	8b 00                	mov    (%eax),%eax
  801b02:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b09:	8b 45 10             	mov    0x10(%ebp),%eax
  801b0c:	01 d0                	add    %edx,%eax
  801b0e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801b14:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801b19:	c9                   	leave  
  801b1a:	c3                   	ret    

00801b1b <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801b1b:	55                   	push   %ebp
  801b1c:	89 e5                	mov    %esp,%ebp
  801b1e:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801b21:	a1 04 50 80 00       	mov    0x805004,%eax
  801b26:	85 c0                	test   %eax,%eax
  801b28:	74 1f                	je     801b49 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801b2a:	e8 1d 00 00 00       	call   801b4c <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801b2f:	83 ec 0c             	sub    $0xc,%esp
  801b32:	68 64 42 80 00       	push   $0x804264
  801b37:	e8 4f f0 ff ff       	call   800b8b <cprintf>
  801b3c:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801b3f:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801b46:	00 00 00 
	}
}
  801b49:	90                   	nop
  801b4a:	c9                   	leave  
  801b4b:	c3                   	ret    

00801b4c <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801b4c:	55                   	push   %ebp
  801b4d:	89 e5                	mov    %esp,%ebp
  801b4f:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801b52:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801b59:	00 00 00 
  801b5c:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801b63:	00 00 00 
  801b66:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801b6d:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  801b70:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801b77:	00 00 00 
  801b7a:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801b81:	00 00 00 
  801b84:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801b8b:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801b8e:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801b95:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801b98:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ba2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801ba7:	2d 00 10 00 00       	sub    $0x1000,%eax
  801bac:	a3 50 50 80 00       	mov    %eax,0x805050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  801bb1:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801bb8:	a1 20 51 80 00       	mov    0x805120,%eax
  801bbd:	c1 e0 04             	shl    $0x4,%eax
  801bc0:	89 c2                	mov    %eax,%edx
  801bc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bc5:	01 d0                	add    %edx,%eax
  801bc7:	48                   	dec    %eax
  801bc8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801bcb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bce:	ba 00 00 00 00       	mov    $0x0,%edx
  801bd3:	f7 75 f0             	divl   -0x10(%ebp)
  801bd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bd9:	29 d0                	sub    %edx,%eax
  801bdb:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  801bde:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801be5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801be8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bed:	2d 00 10 00 00       	sub    $0x1000,%eax
  801bf2:	83 ec 04             	sub    $0x4,%esp
  801bf5:	6a 06                	push   $0x6
  801bf7:	ff 75 e8             	pushl  -0x18(%ebp)
  801bfa:	50                   	push   %eax
  801bfb:	e8 b0 05 00 00       	call   8021b0 <sys_allocate_chunk>
  801c00:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801c03:	a1 20 51 80 00       	mov    0x805120,%eax
  801c08:	83 ec 0c             	sub    $0xc,%esp
  801c0b:	50                   	push   %eax
  801c0c:	e8 25 0c 00 00       	call   802836 <initialize_MemBlocksList>
  801c11:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  801c14:	a1 48 51 80 00       	mov    0x805148,%eax
  801c19:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  801c1c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c20:	75 14                	jne    801c36 <initialize_dyn_block_system+0xea>
  801c22:	83 ec 04             	sub    $0x4,%esp
  801c25:	68 89 42 80 00       	push   $0x804289
  801c2a:	6a 29                	push   $0x29
  801c2c:	68 a7 42 80 00       	push   $0x8042a7
  801c31:	e8 a1 ec ff ff       	call   8008d7 <_panic>
  801c36:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c39:	8b 00                	mov    (%eax),%eax
  801c3b:	85 c0                	test   %eax,%eax
  801c3d:	74 10                	je     801c4f <initialize_dyn_block_system+0x103>
  801c3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c42:	8b 00                	mov    (%eax),%eax
  801c44:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c47:	8b 52 04             	mov    0x4(%edx),%edx
  801c4a:	89 50 04             	mov    %edx,0x4(%eax)
  801c4d:	eb 0b                	jmp    801c5a <initialize_dyn_block_system+0x10e>
  801c4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c52:	8b 40 04             	mov    0x4(%eax),%eax
  801c55:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801c5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c5d:	8b 40 04             	mov    0x4(%eax),%eax
  801c60:	85 c0                	test   %eax,%eax
  801c62:	74 0f                	je     801c73 <initialize_dyn_block_system+0x127>
  801c64:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c67:	8b 40 04             	mov    0x4(%eax),%eax
  801c6a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c6d:	8b 12                	mov    (%edx),%edx
  801c6f:	89 10                	mov    %edx,(%eax)
  801c71:	eb 0a                	jmp    801c7d <initialize_dyn_block_system+0x131>
  801c73:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c76:	8b 00                	mov    (%eax),%eax
  801c78:	a3 48 51 80 00       	mov    %eax,0x805148
  801c7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c86:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c89:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801c90:	a1 54 51 80 00       	mov    0x805154,%eax
  801c95:	48                   	dec    %eax
  801c96:	a3 54 51 80 00       	mov    %eax,0x805154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  801c9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c9e:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  801ca5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ca8:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  801caf:	83 ec 0c             	sub    $0xc,%esp
  801cb2:	ff 75 e0             	pushl  -0x20(%ebp)
  801cb5:	e8 b9 14 00 00       	call   803173 <insert_sorted_with_merge_freeList>
  801cba:	83 c4 10             	add    $0x10,%esp

}
  801cbd:	90                   	nop
  801cbe:	c9                   	leave  
  801cbf:	c3                   	ret    

00801cc0 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801cc0:	55                   	push   %ebp
  801cc1:	89 e5                	mov    %esp,%ebp
  801cc3:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801cc6:	e8 50 fe ff ff       	call   801b1b <InitializeUHeap>
	if (size == 0) return NULL ;
  801ccb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ccf:	75 07                	jne    801cd8 <malloc+0x18>
  801cd1:	b8 00 00 00 00       	mov    $0x0,%eax
  801cd6:	eb 68                	jmp    801d40 <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  801cd8:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801cdf:	8b 55 08             	mov    0x8(%ebp),%edx
  801ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce5:	01 d0                	add    %edx,%eax
  801ce7:	48                   	dec    %eax
  801ce8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ceb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cee:	ba 00 00 00 00       	mov    $0x0,%edx
  801cf3:	f7 75 f4             	divl   -0xc(%ebp)
  801cf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cf9:	29 d0                	sub    %edx,%eax
  801cfb:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  801cfe:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801d05:	e8 74 08 00 00       	call   80257e <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d0a:	85 c0                	test   %eax,%eax
  801d0c:	74 2d                	je     801d3b <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  801d0e:	83 ec 0c             	sub    $0xc,%esp
  801d11:	ff 75 ec             	pushl  -0x14(%ebp)
  801d14:	e8 52 0e 00 00       	call   802b6b <alloc_block_FF>
  801d19:	83 c4 10             	add    $0x10,%esp
  801d1c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  801d1f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801d23:	74 16                	je     801d3b <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  801d25:	83 ec 0c             	sub    $0xc,%esp
  801d28:	ff 75 e8             	pushl  -0x18(%ebp)
  801d2b:	e8 3b 0c 00 00       	call   80296b <insert_sorted_allocList>
  801d30:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  801d33:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d36:	8b 40 08             	mov    0x8(%eax),%eax
  801d39:	eb 05                	jmp    801d40 <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  801d3b:	b8 00 00 00 00       	mov    $0x0,%eax

}
  801d40:	c9                   	leave  
  801d41:	c3                   	ret    

00801d42 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801d42:	55                   	push   %ebp
  801d43:	89 e5                	mov    %esp,%ebp
  801d45:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  801d48:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4b:	83 ec 08             	sub    $0x8,%esp
  801d4e:	50                   	push   %eax
  801d4f:	68 40 50 80 00       	push   $0x805040
  801d54:	e8 ba 0b 00 00       	call   802913 <find_block>
  801d59:	83 c4 10             	add    $0x10,%esp
  801d5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  801d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d62:	8b 40 0c             	mov    0xc(%eax),%eax
  801d65:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  801d68:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d6c:	0f 84 9f 00 00 00    	je     801e11 <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  801d72:	8b 45 08             	mov    0x8(%ebp),%eax
  801d75:	83 ec 08             	sub    $0x8,%esp
  801d78:	ff 75 f0             	pushl  -0x10(%ebp)
  801d7b:	50                   	push   %eax
  801d7c:	e8 f7 03 00 00       	call   802178 <sys_free_user_mem>
  801d81:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  801d84:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d88:	75 14                	jne    801d9e <free+0x5c>
  801d8a:	83 ec 04             	sub    $0x4,%esp
  801d8d:	68 89 42 80 00       	push   $0x804289
  801d92:	6a 6a                	push   $0x6a
  801d94:	68 a7 42 80 00       	push   $0x8042a7
  801d99:	e8 39 eb ff ff       	call   8008d7 <_panic>
  801d9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da1:	8b 00                	mov    (%eax),%eax
  801da3:	85 c0                	test   %eax,%eax
  801da5:	74 10                	je     801db7 <free+0x75>
  801da7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801daa:	8b 00                	mov    (%eax),%eax
  801dac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801daf:	8b 52 04             	mov    0x4(%edx),%edx
  801db2:	89 50 04             	mov    %edx,0x4(%eax)
  801db5:	eb 0b                	jmp    801dc2 <free+0x80>
  801db7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dba:	8b 40 04             	mov    0x4(%eax),%eax
  801dbd:	a3 44 50 80 00       	mov    %eax,0x805044
  801dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc5:	8b 40 04             	mov    0x4(%eax),%eax
  801dc8:	85 c0                	test   %eax,%eax
  801dca:	74 0f                	je     801ddb <free+0x99>
  801dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dcf:	8b 40 04             	mov    0x4(%eax),%eax
  801dd2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dd5:	8b 12                	mov    (%edx),%edx
  801dd7:	89 10                	mov    %edx,(%eax)
  801dd9:	eb 0a                	jmp    801de5 <free+0xa3>
  801ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dde:	8b 00                	mov    (%eax),%eax
  801de0:	a3 40 50 80 00       	mov    %eax,0x805040
  801de5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801de8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801dee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801df8:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801dfd:	48                   	dec    %eax
  801dfe:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(blk);
  801e03:	83 ec 0c             	sub    $0xc,%esp
  801e06:	ff 75 f4             	pushl  -0xc(%ebp)
  801e09:	e8 65 13 00 00       	call   803173 <insert_sorted_with_merge_freeList>
  801e0e:	83 c4 10             	add    $0x10,%esp
	}
}
  801e11:	90                   	nop
  801e12:	c9                   	leave  
  801e13:	c3                   	ret    

00801e14 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801e14:	55                   	push   %ebp
  801e15:	89 e5                	mov    %esp,%ebp
  801e17:	83 ec 28             	sub    $0x28,%esp
  801e1a:	8b 45 10             	mov    0x10(%ebp),%eax
  801e1d:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e20:	e8 f6 fc ff ff       	call   801b1b <InitializeUHeap>
	if (size == 0) return NULL ;
  801e25:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e29:	75 0a                	jne    801e35 <smalloc+0x21>
  801e2b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e30:	e9 af 00 00 00       	jmp    801ee4 <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  801e35:	e8 44 07 00 00       	call   80257e <sys_isUHeapPlacementStrategyFIRSTFIT>
  801e3a:	83 f8 01             	cmp    $0x1,%eax
  801e3d:	0f 85 9c 00 00 00    	jne    801edf <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  801e43:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801e4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e50:	01 d0                	add    %edx,%eax
  801e52:	48                   	dec    %eax
  801e53:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e59:	ba 00 00 00 00       	mov    $0x0,%edx
  801e5e:	f7 75 f4             	divl   -0xc(%ebp)
  801e61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e64:	29 d0                	sub    %edx,%eax
  801e66:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  801e69:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  801e70:	76 07                	jbe    801e79 <smalloc+0x65>
			return NULL;
  801e72:	b8 00 00 00 00       	mov    $0x0,%eax
  801e77:	eb 6b                	jmp    801ee4 <smalloc+0xd0>
		blk =alloc_block_FF(size);
  801e79:	83 ec 0c             	sub    $0xc,%esp
  801e7c:	ff 75 0c             	pushl  0xc(%ebp)
  801e7f:	e8 e7 0c 00 00       	call   802b6b <alloc_block_FF>
  801e84:	83 c4 10             	add    $0x10,%esp
  801e87:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  801e8a:	83 ec 0c             	sub    $0xc,%esp
  801e8d:	ff 75 ec             	pushl  -0x14(%ebp)
  801e90:	e8 d6 0a 00 00       	call   80296b <insert_sorted_allocList>
  801e95:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  801e98:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e9c:	75 07                	jne    801ea5 <smalloc+0x91>
		{
			return NULL;
  801e9e:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea3:	eb 3f                	jmp    801ee4 <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  801ea5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ea8:	8b 40 08             	mov    0x8(%eax),%eax
  801eab:	89 c2                	mov    %eax,%edx
  801ead:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801eb1:	52                   	push   %edx
  801eb2:	50                   	push   %eax
  801eb3:	ff 75 0c             	pushl  0xc(%ebp)
  801eb6:	ff 75 08             	pushl  0x8(%ebp)
  801eb9:	e8 45 04 00 00       	call   802303 <sys_createSharedObject>
  801ebe:	83 c4 10             	add    $0x10,%esp
  801ec1:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  801ec4:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801ec8:	74 06                	je     801ed0 <smalloc+0xbc>
  801eca:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801ece:	75 07                	jne    801ed7 <smalloc+0xc3>
		{
			return NULL;
  801ed0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed5:	eb 0d                	jmp    801ee4 <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  801ed7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eda:	8b 40 08             	mov    0x8(%eax),%eax
  801edd:	eb 05                	jmp    801ee4 <smalloc+0xd0>
		}
	}
	else
		return NULL;
  801edf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ee4:	c9                   	leave  
  801ee5:	c3                   	ret    

00801ee6 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801ee6:	55                   	push   %ebp
  801ee7:	89 e5                	mov    %esp,%ebp
  801ee9:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801eec:	e8 2a fc ff ff       	call   801b1b <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801ef1:	83 ec 08             	sub    $0x8,%esp
  801ef4:	ff 75 0c             	pushl  0xc(%ebp)
  801ef7:	ff 75 08             	pushl  0x8(%ebp)
  801efa:	e8 2e 04 00 00       	call   80232d <sys_getSizeOfSharedObject>
  801eff:	83 c4 10             	add    $0x10,%esp
  801f02:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  801f05:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801f09:	75 0a                	jne    801f15 <sget+0x2f>
	{
		return NULL;
  801f0b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f10:	e9 94 00 00 00       	jmp    801fa9 <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801f15:	e8 64 06 00 00       	call   80257e <sys_isUHeapPlacementStrategyFIRSTFIT>
  801f1a:	85 c0                	test   %eax,%eax
  801f1c:	0f 84 82 00 00 00    	je     801fa4 <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  801f22:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  801f29:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801f30:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f33:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f36:	01 d0                	add    %edx,%eax
  801f38:	48                   	dec    %eax
  801f39:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801f3c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f3f:	ba 00 00 00 00       	mov    $0x0,%edx
  801f44:	f7 75 ec             	divl   -0x14(%ebp)
  801f47:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f4a:	29 d0                	sub    %edx,%eax
  801f4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  801f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f52:	83 ec 0c             	sub    $0xc,%esp
  801f55:	50                   	push   %eax
  801f56:	e8 10 0c 00 00       	call   802b6b <alloc_block_FF>
  801f5b:	83 c4 10             	add    $0x10,%esp
  801f5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  801f61:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f65:	75 07                	jne    801f6e <sget+0x88>
		{
			return NULL;
  801f67:	b8 00 00 00 00       	mov    $0x0,%eax
  801f6c:	eb 3b                	jmp    801fa9 <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  801f6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f71:	8b 40 08             	mov    0x8(%eax),%eax
  801f74:	83 ec 04             	sub    $0x4,%esp
  801f77:	50                   	push   %eax
  801f78:	ff 75 0c             	pushl  0xc(%ebp)
  801f7b:	ff 75 08             	pushl  0x8(%ebp)
  801f7e:	e8 c7 03 00 00       	call   80234a <sys_getSharedObject>
  801f83:	83 c4 10             	add    $0x10,%esp
  801f86:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  801f89:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801f8d:	74 06                	je     801f95 <sget+0xaf>
  801f8f:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  801f93:	75 07                	jne    801f9c <sget+0xb6>
		{
			return NULL;
  801f95:	b8 00 00 00 00       	mov    $0x0,%eax
  801f9a:	eb 0d                	jmp    801fa9 <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  801f9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f9f:	8b 40 08             	mov    0x8(%eax),%eax
  801fa2:	eb 05                	jmp    801fa9 <sget+0xc3>
		}
	}
	else
			return NULL;
  801fa4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fa9:	c9                   	leave  
  801faa:	c3                   	ret    

00801fab <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801fab:	55                   	push   %ebp
  801fac:	89 e5                	mov    %esp,%ebp
  801fae:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801fb1:	e8 65 fb ff ff       	call   801b1b <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801fb6:	83 ec 04             	sub    $0x4,%esp
  801fb9:	68 b4 42 80 00       	push   $0x8042b4
  801fbe:	68 e1 00 00 00       	push   $0xe1
  801fc3:	68 a7 42 80 00       	push   $0x8042a7
  801fc8:	e8 0a e9 ff ff       	call   8008d7 <_panic>

00801fcd <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801fcd:	55                   	push   %ebp
  801fce:	89 e5                	mov    %esp,%ebp
  801fd0:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801fd3:	83 ec 04             	sub    $0x4,%esp
  801fd6:	68 dc 42 80 00       	push   $0x8042dc
  801fdb:	68 f5 00 00 00       	push   $0xf5
  801fe0:	68 a7 42 80 00       	push   $0x8042a7
  801fe5:	e8 ed e8 ff ff       	call   8008d7 <_panic>

00801fea <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801fea:	55                   	push   %ebp
  801feb:	89 e5                	mov    %esp,%ebp
  801fed:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ff0:	83 ec 04             	sub    $0x4,%esp
  801ff3:	68 00 43 80 00       	push   $0x804300
  801ff8:	68 00 01 00 00       	push   $0x100
  801ffd:	68 a7 42 80 00       	push   $0x8042a7
  802002:	e8 d0 e8 ff ff       	call   8008d7 <_panic>

00802007 <shrink>:

}
void shrink(uint32 newSize)
{
  802007:	55                   	push   %ebp
  802008:	89 e5                	mov    %esp,%ebp
  80200a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80200d:	83 ec 04             	sub    $0x4,%esp
  802010:	68 00 43 80 00       	push   $0x804300
  802015:	68 05 01 00 00       	push   $0x105
  80201a:	68 a7 42 80 00       	push   $0x8042a7
  80201f:	e8 b3 e8 ff ff       	call   8008d7 <_panic>

00802024 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802024:	55                   	push   %ebp
  802025:	89 e5                	mov    %esp,%ebp
  802027:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80202a:	83 ec 04             	sub    $0x4,%esp
  80202d:	68 00 43 80 00       	push   $0x804300
  802032:	68 0a 01 00 00       	push   $0x10a
  802037:	68 a7 42 80 00       	push   $0x8042a7
  80203c:	e8 96 e8 ff ff       	call   8008d7 <_panic>

00802041 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802041:	55                   	push   %ebp
  802042:	89 e5                	mov    %esp,%ebp
  802044:	57                   	push   %edi
  802045:	56                   	push   %esi
  802046:	53                   	push   %ebx
  802047:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80204a:	8b 45 08             	mov    0x8(%ebp),%eax
  80204d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802050:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802053:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802056:	8b 7d 18             	mov    0x18(%ebp),%edi
  802059:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80205c:	cd 30                	int    $0x30
  80205e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802061:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802064:	83 c4 10             	add    $0x10,%esp
  802067:	5b                   	pop    %ebx
  802068:	5e                   	pop    %esi
  802069:	5f                   	pop    %edi
  80206a:	5d                   	pop    %ebp
  80206b:	c3                   	ret    

0080206c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80206c:	55                   	push   %ebp
  80206d:	89 e5                	mov    %esp,%ebp
  80206f:	83 ec 04             	sub    $0x4,%esp
  802072:	8b 45 10             	mov    0x10(%ebp),%eax
  802075:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802078:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80207c:	8b 45 08             	mov    0x8(%ebp),%eax
  80207f:	6a 00                	push   $0x0
  802081:	6a 00                	push   $0x0
  802083:	52                   	push   %edx
  802084:	ff 75 0c             	pushl  0xc(%ebp)
  802087:	50                   	push   %eax
  802088:	6a 00                	push   $0x0
  80208a:	e8 b2 ff ff ff       	call   802041 <syscall>
  80208f:	83 c4 18             	add    $0x18,%esp
}
  802092:	90                   	nop
  802093:	c9                   	leave  
  802094:	c3                   	ret    

00802095 <sys_cgetc>:

int
sys_cgetc(void)
{
  802095:	55                   	push   %ebp
  802096:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802098:	6a 00                	push   $0x0
  80209a:	6a 00                	push   $0x0
  80209c:	6a 00                	push   $0x0
  80209e:	6a 00                	push   $0x0
  8020a0:	6a 00                	push   $0x0
  8020a2:	6a 01                	push   $0x1
  8020a4:	e8 98 ff ff ff       	call   802041 <syscall>
  8020a9:	83 c4 18             	add    $0x18,%esp
}
  8020ac:	c9                   	leave  
  8020ad:	c3                   	ret    

008020ae <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8020ae:	55                   	push   %ebp
  8020af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8020b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b7:	6a 00                	push   $0x0
  8020b9:	6a 00                	push   $0x0
  8020bb:	6a 00                	push   $0x0
  8020bd:	52                   	push   %edx
  8020be:	50                   	push   %eax
  8020bf:	6a 05                	push   $0x5
  8020c1:	e8 7b ff ff ff       	call   802041 <syscall>
  8020c6:	83 c4 18             	add    $0x18,%esp
}
  8020c9:	c9                   	leave  
  8020ca:	c3                   	ret    

008020cb <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8020cb:	55                   	push   %ebp
  8020cc:	89 e5                	mov    %esp,%ebp
  8020ce:	56                   	push   %esi
  8020cf:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8020d0:	8b 75 18             	mov    0x18(%ebp),%esi
  8020d3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020d6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020df:	56                   	push   %esi
  8020e0:	53                   	push   %ebx
  8020e1:	51                   	push   %ecx
  8020e2:	52                   	push   %edx
  8020e3:	50                   	push   %eax
  8020e4:	6a 06                	push   $0x6
  8020e6:	e8 56 ff ff ff       	call   802041 <syscall>
  8020eb:	83 c4 18             	add    $0x18,%esp
}
  8020ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020f1:	5b                   	pop    %ebx
  8020f2:	5e                   	pop    %esi
  8020f3:	5d                   	pop    %ebp
  8020f4:	c3                   	ret    

008020f5 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8020f5:	55                   	push   %ebp
  8020f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8020f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fe:	6a 00                	push   $0x0
  802100:	6a 00                	push   $0x0
  802102:	6a 00                	push   $0x0
  802104:	52                   	push   %edx
  802105:	50                   	push   %eax
  802106:	6a 07                	push   $0x7
  802108:	e8 34 ff ff ff       	call   802041 <syscall>
  80210d:	83 c4 18             	add    $0x18,%esp
}
  802110:	c9                   	leave  
  802111:	c3                   	ret    

00802112 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802112:	55                   	push   %ebp
  802113:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802115:	6a 00                	push   $0x0
  802117:	6a 00                	push   $0x0
  802119:	6a 00                	push   $0x0
  80211b:	ff 75 0c             	pushl  0xc(%ebp)
  80211e:	ff 75 08             	pushl  0x8(%ebp)
  802121:	6a 08                	push   $0x8
  802123:	e8 19 ff ff ff       	call   802041 <syscall>
  802128:	83 c4 18             	add    $0x18,%esp
}
  80212b:	c9                   	leave  
  80212c:	c3                   	ret    

0080212d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80212d:	55                   	push   %ebp
  80212e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802130:	6a 00                	push   $0x0
  802132:	6a 00                	push   $0x0
  802134:	6a 00                	push   $0x0
  802136:	6a 00                	push   $0x0
  802138:	6a 00                	push   $0x0
  80213a:	6a 09                	push   $0x9
  80213c:	e8 00 ff ff ff       	call   802041 <syscall>
  802141:	83 c4 18             	add    $0x18,%esp
}
  802144:	c9                   	leave  
  802145:	c3                   	ret    

00802146 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802146:	55                   	push   %ebp
  802147:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802149:	6a 00                	push   $0x0
  80214b:	6a 00                	push   $0x0
  80214d:	6a 00                	push   $0x0
  80214f:	6a 00                	push   $0x0
  802151:	6a 00                	push   $0x0
  802153:	6a 0a                	push   $0xa
  802155:	e8 e7 fe ff ff       	call   802041 <syscall>
  80215a:	83 c4 18             	add    $0x18,%esp
}
  80215d:	c9                   	leave  
  80215e:	c3                   	ret    

0080215f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80215f:	55                   	push   %ebp
  802160:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802162:	6a 00                	push   $0x0
  802164:	6a 00                	push   $0x0
  802166:	6a 00                	push   $0x0
  802168:	6a 00                	push   $0x0
  80216a:	6a 00                	push   $0x0
  80216c:	6a 0b                	push   $0xb
  80216e:	e8 ce fe ff ff       	call   802041 <syscall>
  802173:	83 c4 18             	add    $0x18,%esp
}
  802176:	c9                   	leave  
  802177:	c3                   	ret    

00802178 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802178:	55                   	push   %ebp
  802179:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80217b:	6a 00                	push   $0x0
  80217d:	6a 00                	push   $0x0
  80217f:	6a 00                	push   $0x0
  802181:	ff 75 0c             	pushl  0xc(%ebp)
  802184:	ff 75 08             	pushl  0x8(%ebp)
  802187:	6a 0f                	push   $0xf
  802189:	e8 b3 fe ff ff       	call   802041 <syscall>
  80218e:	83 c4 18             	add    $0x18,%esp
	return;
  802191:	90                   	nop
}
  802192:	c9                   	leave  
  802193:	c3                   	ret    

00802194 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802194:	55                   	push   %ebp
  802195:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802197:	6a 00                	push   $0x0
  802199:	6a 00                	push   $0x0
  80219b:	6a 00                	push   $0x0
  80219d:	ff 75 0c             	pushl  0xc(%ebp)
  8021a0:	ff 75 08             	pushl  0x8(%ebp)
  8021a3:	6a 10                	push   $0x10
  8021a5:	e8 97 fe ff ff       	call   802041 <syscall>
  8021aa:	83 c4 18             	add    $0x18,%esp
	return ;
  8021ad:	90                   	nop
}
  8021ae:	c9                   	leave  
  8021af:	c3                   	ret    

008021b0 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8021b0:	55                   	push   %ebp
  8021b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8021b3:	6a 00                	push   $0x0
  8021b5:	6a 00                	push   $0x0
  8021b7:	ff 75 10             	pushl  0x10(%ebp)
  8021ba:	ff 75 0c             	pushl  0xc(%ebp)
  8021bd:	ff 75 08             	pushl  0x8(%ebp)
  8021c0:	6a 11                	push   $0x11
  8021c2:	e8 7a fe ff ff       	call   802041 <syscall>
  8021c7:	83 c4 18             	add    $0x18,%esp
	return ;
  8021ca:	90                   	nop
}
  8021cb:	c9                   	leave  
  8021cc:	c3                   	ret    

008021cd <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8021cd:	55                   	push   %ebp
  8021ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8021d0:	6a 00                	push   $0x0
  8021d2:	6a 00                	push   $0x0
  8021d4:	6a 00                	push   $0x0
  8021d6:	6a 00                	push   $0x0
  8021d8:	6a 00                	push   $0x0
  8021da:	6a 0c                	push   $0xc
  8021dc:	e8 60 fe ff ff       	call   802041 <syscall>
  8021e1:	83 c4 18             	add    $0x18,%esp
}
  8021e4:	c9                   	leave  
  8021e5:	c3                   	ret    

008021e6 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8021e6:	55                   	push   %ebp
  8021e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8021e9:	6a 00                	push   $0x0
  8021eb:	6a 00                	push   $0x0
  8021ed:	6a 00                	push   $0x0
  8021ef:	6a 00                	push   $0x0
  8021f1:	ff 75 08             	pushl  0x8(%ebp)
  8021f4:	6a 0d                	push   $0xd
  8021f6:	e8 46 fe ff ff       	call   802041 <syscall>
  8021fb:	83 c4 18             	add    $0x18,%esp
}
  8021fe:	c9                   	leave  
  8021ff:	c3                   	ret    

00802200 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802200:	55                   	push   %ebp
  802201:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802203:	6a 00                	push   $0x0
  802205:	6a 00                	push   $0x0
  802207:	6a 00                	push   $0x0
  802209:	6a 00                	push   $0x0
  80220b:	6a 00                	push   $0x0
  80220d:	6a 0e                	push   $0xe
  80220f:	e8 2d fe ff ff       	call   802041 <syscall>
  802214:	83 c4 18             	add    $0x18,%esp
}
  802217:	90                   	nop
  802218:	c9                   	leave  
  802219:	c3                   	ret    

0080221a <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80221a:	55                   	push   %ebp
  80221b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80221d:	6a 00                	push   $0x0
  80221f:	6a 00                	push   $0x0
  802221:	6a 00                	push   $0x0
  802223:	6a 00                	push   $0x0
  802225:	6a 00                	push   $0x0
  802227:	6a 13                	push   $0x13
  802229:	e8 13 fe ff ff       	call   802041 <syscall>
  80222e:	83 c4 18             	add    $0x18,%esp
}
  802231:	90                   	nop
  802232:	c9                   	leave  
  802233:	c3                   	ret    

00802234 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802234:	55                   	push   %ebp
  802235:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802237:	6a 00                	push   $0x0
  802239:	6a 00                	push   $0x0
  80223b:	6a 00                	push   $0x0
  80223d:	6a 00                	push   $0x0
  80223f:	6a 00                	push   $0x0
  802241:	6a 14                	push   $0x14
  802243:	e8 f9 fd ff ff       	call   802041 <syscall>
  802248:	83 c4 18             	add    $0x18,%esp
}
  80224b:	90                   	nop
  80224c:	c9                   	leave  
  80224d:	c3                   	ret    

0080224e <sys_cputc>:


void
sys_cputc(const char c)
{
  80224e:	55                   	push   %ebp
  80224f:	89 e5                	mov    %esp,%ebp
  802251:	83 ec 04             	sub    $0x4,%esp
  802254:	8b 45 08             	mov    0x8(%ebp),%eax
  802257:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80225a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80225e:	6a 00                	push   $0x0
  802260:	6a 00                	push   $0x0
  802262:	6a 00                	push   $0x0
  802264:	6a 00                	push   $0x0
  802266:	50                   	push   %eax
  802267:	6a 15                	push   $0x15
  802269:	e8 d3 fd ff ff       	call   802041 <syscall>
  80226e:	83 c4 18             	add    $0x18,%esp
}
  802271:	90                   	nop
  802272:	c9                   	leave  
  802273:	c3                   	ret    

00802274 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802274:	55                   	push   %ebp
  802275:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802277:	6a 00                	push   $0x0
  802279:	6a 00                	push   $0x0
  80227b:	6a 00                	push   $0x0
  80227d:	6a 00                	push   $0x0
  80227f:	6a 00                	push   $0x0
  802281:	6a 16                	push   $0x16
  802283:	e8 b9 fd ff ff       	call   802041 <syscall>
  802288:	83 c4 18             	add    $0x18,%esp
}
  80228b:	90                   	nop
  80228c:	c9                   	leave  
  80228d:	c3                   	ret    

0080228e <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80228e:	55                   	push   %ebp
  80228f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802291:	8b 45 08             	mov    0x8(%ebp),%eax
  802294:	6a 00                	push   $0x0
  802296:	6a 00                	push   $0x0
  802298:	6a 00                	push   $0x0
  80229a:	ff 75 0c             	pushl  0xc(%ebp)
  80229d:	50                   	push   %eax
  80229e:	6a 17                	push   $0x17
  8022a0:	e8 9c fd ff ff       	call   802041 <syscall>
  8022a5:	83 c4 18             	add    $0x18,%esp
}
  8022a8:	c9                   	leave  
  8022a9:	c3                   	ret    

008022aa <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8022aa:	55                   	push   %ebp
  8022ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b3:	6a 00                	push   $0x0
  8022b5:	6a 00                	push   $0x0
  8022b7:	6a 00                	push   $0x0
  8022b9:	52                   	push   %edx
  8022ba:	50                   	push   %eax
  8022bb:	6a 1a                	push   $0x1a
  8022bd:	e8 7f fd ff ff       	call   802041 <syscall>
  8022c2:	83 c4 18             	add    $0x18,%esp
}
  8022c5:	c9                   	leave  
  8022c6:	c3                   	ret    

008022c7 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8022c7:	55                   	push   %ebp
  8022c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d0:	6a 00                	push   $0x0
  8022d2:	6a 00                	push   $0x0
  8022d4:	6a 00                	push   $0x0
  8022d6:	52                   	push   %edx
  8022d7:	50                   	push   %eax
  8022d8:	6a 18                	push   $0x18
  8022da:	e8 62 fd ff ff       	call   802041 <syscall>
  8022df:	83 c4 18             	add    $0x18,%esp
}
  8022e2:	90                   	nop
  8022e3:	c9                   	leave  
  8022e4:	c3                   	ret    

008022e5 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8022e5:	55                   	push   %ebp
  8022e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ee:	6a 00                	push   $0x0
  8022f0:	6a 00                	push   $0x0
  8022f2:	6a 00                	push   $0x0
  8022f4:	52                   	push   %edx
  8022f5:	50                   	push   %eax
  8022f6:	6a 19                	push   $0x19
  8022f8:	e8 44 fd ff ff       	call   802041 <syscall>
  8022fd:	83 c4 18             	add    $0x18,%esp
}
  802300:	90                   	nop
  802301:	c9                   	leave  
  802302:	c3                   	ret    

00802303 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802303:	55                   	push   %ebp
  802304:	89 e5                	mov    %esp,%ebp
  802306:	83 ec 04             	sub    $0x4,%esp
  802309:	8b 45 10             	mov    0x10(%ebp),%eax
  80230c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80230f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802312:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802316:	8b 45 08             	mov    0x8(%ebp),%eax
  802319:	6a 00                	push   $0x0
  80231b:	51                   	push   %ecx
  80231c:	52                   	push   %edx
  80231d:	ff 75 0c             	pushl  0xc(%ebp)
  802320:	50                   	push   %eax
  802321:	6a 1b                	push   $0x1b
  802323:	e8 19 fd ff ff       	call   802041 <syscall>
  802328:	83 c4 18             	add    $0x18,%esp
}
  80232b:	c9                   	leave  
  80232c:	c3                   	ret    

0080232d <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80232d:	55                   	push   %ebp
  80232e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802330:	8b 55 0c             	mov    0xc(%ebp),%edx
  802333:	8b 45 08             	mov    0x8(%ebp),%eax
  802336:	6a 00                	push   $0x0
  802338:	6a 00                	push   $0x0
  80233a:	6a 00                	push   $0x0
  80233c:	52                   	push   %edx
  80233d:	50                   	push   %eax
  80233e:	6a 1c                	push   $0x1c
  802340:	e8 fc fc ff ff       	call   802041 <syscall>
  802345:	83 c4 18             	add    $0x18,%esp
}
  802348:	c9                   	leave  
  802349:	c3                   	ret    

0080234a <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80234a:	55                   	push   %ebp
  80234b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80234d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802350:	8b 55 0c             	mov    0xc(%ebp),%edx
  802353:	8b 45 08             	mov    0x8(%ebp),%eax
  802356:	6a 00                	push   $0x0
  802358:	6a 00                	push   $0x0
  80235a:	51                   	push   %ecx
  80235b:	52                   	push   %edx
  80235c:	50                   	push   %eax
  80235d:	6a 1d                	push   $0x1d
  80235f:	e8 dd fc ff ff       	call   802041 <syscall>
  802364:	83 c4 18             	add    $0x18,%esp
}
  802367:	c9                   	leave  
  802368:	c3                   	ret    

00802369 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802369:	55                   	push   %ebp
  80236a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80236c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80236f:	8b 45 08             	mov    0x8(%ebp),%eax
  802372:	6a 00                	push   $0x0
  802374:	6a 00                	push   $0x0
  802376:	6a 00                	push   $0x0
  802378:	52                   	push   %edx
  802379:	50                   	push   %eax
  80237a:	6a 1e                	push   $0x1e
  80237c:	e8 c0 fc ff ff       	call   802041 <syscall>
  802381:	83 c4 18             	add    $0x18,%esp
}
  802384:	c9                   	leave  
  802385:	c3                   	ret    

00802386 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802386:	55                   	push   %ebp
  802387:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802389:	6a 00                	push   $0x0
  80238b:	6a 00                	push   $0x0
  80238d:	6a 00                	push   $0x0
  80238f:	6a 00                	push   $0x0
  802391:	6a 00                	push   $0x0
  802393:	6a 1f                	push   $0x1f
  802395:	e8 a7 fc ff ff       	call   802041 <syscall>
  80239a:	83 c4 18             	add    $0x18,%esp
}
  80239d:	c9                   	leave  
  80239e:	c3                   	ret    

0080239f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80239f:	55                   	push   %ebp
  8023a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8023a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a5:	6a 00                	push   $0x0
  8023a7:	ff 75 14             	pushl  0x14(%ebp)
  8023aa:	ff 75 10             	pushl  0x10(%ebp)
  8023ad:	ff 75 0c             	pushl  0xc(%ebp)
  8023b0:	50                   	push   %eax
  8023b1:	6a 20                	push   $0x20
  8023b3:	e8 89 fc ff ff       	call   802041 <syscall>
  8023b8:	83 c4 18             	add    $0x18,%esp
}
  8023bb:	c9                   	leave  
  8023bc:	c3                   	ret    

008023bd <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8023bd:	55                   	push   %ebp
  8023be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8023c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c3:	6a 00                	push   $0x0
  8023c5:	6a 00                	push   $0x0
  8023c7:	6a 00                	push   $0x0
  8023c9:	6a 00                	push   $0x0
  8023cb:	50                   	push   %eax
  8023cc:	6a 21                	push   $0x21
  8023ce:	e8 6e fc ff ff       	call   802041 <syscall>
  8023d3:	83 c4 18             	add    $0x18,%esp
}
  8023d6:	90                   	nop
  8023d7:	c9                   	leave  
  8023d8:	c3                   	ret    

008023d9 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8023d9:	55                   	push   %ebp
  8023da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8023dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023df:	6a 00                	push   $0x0
  8023e1:	6a 00                	push   $0x0
  8023e3:	6a 00                	push   $0x0
  8023e5:	6a 00                	push   $0x0
  8023e7:	50                   	push   %eax
  8023e8:	6a 22                	push   $0x22
  8023ea:	e8 52 fc ff ff       	call   802041 <syscall>
  8023ef:	83 c4 18             	add    $0x18,%esp
}
  8023f2:	c9                   	leave  
  8023f3:	c3                   	ret    

008023f4 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8023f4:	55                   	push   %ebp
  8023f5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8023f7:	6a 00                	push   $0x0
  8023f9:	6a 00                	push   $0x0
  8023fb:	6a 00                	push   $0x0
  8023fd:	6a 00                	push   $0x0
  8023ff:	6a 00                	push   $0x0
  802401:	6a 02                	push   $0x2
  802403:	e8 39 fc ff ff       	call   802041 <syscall>
  802408:	83 c4 18             	add    $0x18,%esp
}
  80240b:	c9                   	leave  
  80240c:	c3                   	ret    

0080240d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80240d:	55                   	push   %ebp
  80240e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802410:	6a 00                	push   $0x0
  802412:	6a 00                	push   $0x0
  802414:	6a 00                	push   $0x0
  802416:	6a 00                	push   $0x0
  802418:	6a 00                	push   $0x0
  80241a:	6a 03                	push   $0x3
  80241c:	e8 20 fc ff ff       	call   802041 <syscall>
  802421:	83 c4 18             	add    $0x18,%esp
}
  802424:	c9                   	leave  
  802425:	c3                   	ret    

00802426 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802426:	55                   	push   %ebp
  802427:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802429:	6a 00                	push   $0x0
  80242b:	6a 00                	push   $0x0
  80242d:	6a 00                	push   $0x0
  80242f:	6a 00                	push   $0x0
  802431:	6a 00                	push   $0x0
  802433:	6a 04                	push   $0x4
  802435:	e8 07 fc ff ff       	call   802041 <syscall>
  80243a:	83 c4 18             	add    $0x18,%esp
}
  80243d:	c9                   	leave  
  80243e:	c3                   	ret    

0080243f <sys_exit_env>:


void sys_exit_env(void)
{
  80243f:	55                   	push   %ebp
  802440:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802442:	6a 00                	push   $0x0
  802444:	6a 00                	push   $0x0
  802446:	6a 00                	push   $0x0
  802448:	6a 00                	push   $0x0
  80244a:	6a 00                	push   $0x0
  80244c:	6a 23                	push   $0x23
  80244e:	e8 ee fb ff ff       	call   802041 <syscall>
  802453:	83 c4 18             	add    $0x18,%esp
}
  802456:	90                   	nop
  802457:	c9                   	leave  
  802458:	c3                   	ret    

00802459 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802459:	55                   	push   %ebp
  80245a:	89 e5                	mov    %esp,%ebp
  80245c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80245f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802462:	8d 50 04             	lea    0x4(%eax),%edx
  802465:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802468:	6a 00                	push   $0x0
  80246a:	6a 00                	push   $0x0
  80246c:	6a 00                	push   $0x0
  80246e:	52                   	push   %edx
  80246f:	50                   	push   %eax
  802470:	6a 24                	push   $0x24
  802472:	e8 ca fb ff ff       	call   802041 <syscall>
  802477:	83 c4 18             	add    $0x18,%esp
	return result;
  80247a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80247d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802480:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802483:	89 01                	mov    %eax,(%ecx)
  802485:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802488:	8b 45 08             	mov    0x8(%ebp),%eax
  80248b:	c9                   	leave  
  80248c:	c2 04 00             	ret    $0x4

0080248f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80248f:	55                   	push   %ebp
  802490:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802492:	6a 00                	push   $0x0
  802494:	6a 00                	push   $0x0
  802496:	ff 75 10             	pushl  0x10(%ebp)
  802499:	ff 75 0c             	pushl  0xc(%ebp)
  80249c:	ff 75 08             	pushl  0x8(%ebp)
  80249f:	6a 12                	push   $0x12
  8024a1:	e8 9b fb ff ff       	call   802041 <syscall>
  8024a6:	83 c4 18             	add    $0x18,%esp
	return ;
  8024a9:	90                   	nop
}
  8024aa:	c9                   	leave  
  8024ab:	c3                   	ret    

008024ac <sys_rcr2>:
uint32 sys_rcr2()
{
  8024ac:	55                   	push   %ebp
  8024ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8024af:	6a 00                	push   $0x0
  8024b1:	6a 00                	push   $0x0
  8024b3:	6a 00                	push   $0x0
  8024b5:	6a 00                	push   $0x0
  8024b7:	6a 00                	push   $0x0
  8024b9:	6a 25                	push   $0x25
  8024bb:	e8 81 fb ff ff       	call   802041 <syscall>
  8024c0:	83 c4 18             	add    $0x18,%esp
}
  8024c3:	c9                   	leave  
  8024c4:	c3                   	ret    

008024c5 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8024c5:	55                   	push   %ebp
  8024c6:	89 e5                	mov    %esp,%ebp
  8024c8:	83 ec 04             	sub    $0x4,%esp
  8024cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ce:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8024d1:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8024d5:	6a 00                	push   $0x0
  8024d7:	6a 00                	push   $0x0
  8024d9:	6a 00                	push   $0x0
  8024db:	6a 00                	push   $0x0
  8024dd:	50                   	push   %eax
  8024de:	6a 26                	push   $0x26
  8024e0:	e8 5c fb ff ff       	call   802041 <syscall>
  8024e5:	83 c4 18             	add    $0x18,%esp
	return ;
  8024e8:	90                   	nop
}
  8024e9:	c9                   	leave  
  8024ea:	c3                   	ret    

008024eb <rsttst>:
void rsttst()
{
  8024eb:	55                   	push   %ebp
  8024ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8024ee:	6a 00                	push   $0x0
  8024f0:	6a 00                	push   $0x0
  8024f2:	6a 00                	push   $0x0
  8024f4:	6a 00                	push   $0x0
  8024f6:	6a 00                	push   $0x0
  8024f8:	6a 28                	push   $0x28
  8024fa:	e8 42 fb ff ff       	call   802041 <syscall>
  8024ff:	83 c4 18             	add    $0x18,%esp
	return ;
  802502:	90                   	nop
}
  802503:	c9                   	leave  
  802504:	c3                   	ret    

00802505 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802505:	55                   	push   %ebp
  802506:	89 e5                	mov    %esp,%ebp
  802508:	83 ec 04             	sub    $0x4,%esp
  80250b:	8b 45 14             	mov    0x14(%ebp),%eax
  80250e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802511:	8b 55 18             	mov    0x18(%ebp),%edx
  802514:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802518:	52                   	push   %edx
  802519:	50                   	push   %eax
  80251a:	ff 75 10             	pushl  0x10(%ebp)
  80251d:	ff 75 0c             	pushl  0xc(%ebp)
  802520:	ff 75 08             	pushl  0x8(%ebp)
  802523:	6a 27                	push   $0x27
  802525:	e8 17 fb ff ff       	call   802041 <syscall>
  80252a:	83 c4 18             	add    $0x18,%esp
	return ;
  80252d:	90                   	nop
}
  80252e:	c9                   	leave  
  80252f:	c3                   	ret    

00802530 <chktst>:
void chktst(uint32 n)
{
  802530:	55                   	push   %ebp
  802531:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802533:	6a 00                	push   $0x0
  802535:	6a 00                	push   $0x0
  802537:	6a 00                	push   $0x0
  802539:	6a 00                	push   $0x0
  80253b:	ff 75 08             	pushl  0x8(%ebp)
  80253e:	6a 29                	push   $0x29
  802540:	e8 fc fa ff ff       	call   802041 <syscall>
  802545:	83 c4 18             	add    $0x18,%esp
	return ;
  802548:	90                   	nop
}
  802549:	c9                   	leave  
  80254a:	c3                   	ret    

0080254b <inctst>:

void inctst()
{
  80254b:	55                   	push   %ebp
  80254c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80254e:	6a 00                	push   $0x0
  802550:	6a 00                	push   $0x0
  802552:	6a 00                	push   $0x0
  802554:	6a 00                	push   $0x0
  802556:	6a 00                	push   $0x0
  802558:	6a 2a                	push   $0x2a
  80255a:	e8 e2 fa ff ff       	call   802041 <syscall>
  80255f:	83 c4 18             	add    $0x18,%esp
	return ;
  802562:	90                   	nop
}
  802563:	c9                   	leave  
  802564:	c3                   	ret    

00802565 <gettst>:
uint32 gettst()
{
  802565:	55                   	push   %ebp
  802566:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802568:	6a 00                	push   $0x0
  80256a:	6a 00                	push   $0x0
  80256c:	6a 00                	push   $0x0
  80256e:	6a 00                	push   $0x0
  802570:	6a 00                	push   $0x0
  802572:	6a 2b                	push   $0x2b
  802574:	e8 c8 fa ff ff       	call   802041 <syscall>
  802579:	83 c4 18             	add    $0x18,%esp
}
  80257c:	c9                   	leave  
  80257d:	c3                   	ret    

0080257e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80257e:	55                   	push   %ebp
  80257f:	89 e5                	mov    %esp,%ebp
  802581:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802584:	6a 00                	push   $0x0
  802586:	6a 00                	push   $0x0
  802588:	6a 00                	push   $0x0
  80258a:	6a 00                	push   $0x0
  80258c:	6a 00                	push   $0x0
  80258e:	6a 2c                	push   $0x2c
  802590:	e8 ac fa ff ff       	call   802041 <syscall>
  802595:	83 c4 18             	add    $0x18,%esp
  802598:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80259b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80259f:	75 07                	jne    8025a8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8025a1:	b8 01 00 00 00       	mov    $0x1,%eax
  8025a6:	eb 05                	jmp    8025ad <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8025a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025ad:	c9                   	leave  
  8025ae:	c3                   	ret    

008025af <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8025af:	55                   	push   %ebp
  8025b0:	89 e5                	mov    %esp,%ebp
  8025b2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025b5:	6a 00                	push   $0x0
  8025b7:	6a 00                	push   $0x0
  8025b9:	6a 00                	push   $0x0
  8025bb:	6a 00                	push   $0x0
  8025bd:	6a 00                	push   $0x0
  8025bf:	6a 2c                	push   $0x2c
  8025c1:	e8 7b fa ff ff       	call   802041 <syscall>
  8025c6:	83 c4 18             	add    $0x18,%esp
  8025c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8025cc:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8025d0:	75 07                	jne    8025d9 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8025d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8025d7:	eb 05                	jmp    8025de <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8025d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025de:	c9                   	leave  
  8025df:	c3                   	ret    

008025e0 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8025e0:	55                   	push   %ebp
  8025e1:	89 e5                	mov    %esp,%ebp
  8025e3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025e6:	6a 00                	push   $0x0
  8025e8:	6a 00                	push   $0x0
  8025ea:	6a 00                	push   $0x0
  8025ec:	6a 00                	push   $0x0
  8025ee:	6a 00                	push   $0x0
  8025f0:	6a 2c                	push   $0x2c
  8025f2:	e8 4a fa ff ff       	call   802041 <syscall>
  8025f7:	83 c4 18             	add    $0x18,%esp
  8025fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8025fd:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802601:	75 07                	jne    80260a <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802603:	b8 01 00 00 00       	mov    $0x1,%eax
  802608:	eb 05                	jmp    80260f <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80260a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80260f:	c9                   	leave  
  802610:	c3                   	ret    

00802611 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802611:	55                   	push   %ebp
  802612:	89 e5                	mov    %esp,%ebp
  802614:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802617:	6a 00                	push   $0x0
  802619:	6a 00                	push   $0x0
  80261b:	6a 00                	push   $0x0
  80261d:	6a 00                	push   $0x0
  80261f:	6a 00                	push   $0x0
  802621:	6a 2c                	push   $0x2c
  802623:	e8 19 fa ff ff       	call   802041 <syscall>
  802628:	83 c4 18             	add    $0x18,%esp
  80262b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80262e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802632:	75 07                	jne    80263b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802634:	b8 01 00 00 00       	mov    $0x1,%eax
  802639:	eb 05                	jmp    802640 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80263b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802640:	c9                   	leave  
  802641:	c3                   	ret    

00802642 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802642:	55                   	push   %ebp
  802643:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802645:	6a 00                	push   $0x0
  802647:	6a 00                	push   $0x0
  802649:	6a 00                	push   $0x0
  80264b:	6a 00                	push   $0x0
  80264d:	ff 75 08             	pushl  0x8(%ebp)
  802650:	6a 2d                	push   $0x2d
  802652:	e8 ea f9 ff ff       	call   802041 <syscall>
  802657:	83 c4 18             	add    $0x18,%esp
	return ;
  80265a:	90                   	nop
}
  80265b:	c9                   	leave  
  80265c:	c3                   	ret    

0080265d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80265d:	55                   	push   %ebp
  80265e:	89 e5                	mov    %esp,%ebp
  802660:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802661:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802664:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802667:	8b 55 0c             	mov    0xc(%ebp),%edx
  80266a:	8b 45 08             	mov    0x8(%ebp),%eax
  80266d:	6a 00                	push   $0x0
  80266f:	53                   	push   %ebx
  802670:	51                   	push   %ecx
  802671:	52                   	push   %edx
  802672:	50                   	push   %eax
  802673:	6a 2e                	push   $0x2e
  802675:	e8 c7 f9 ff ff       	call   802041 <syscall>
  80267a:	83 c4 18             	add    $0x18,%esp
}
  80267d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802680:	c9                   	leave  
  802681:	c3                   	ret    

00802682 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802682:	55                   	push   %ebp
  802683:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802685:	8b 55 0c             	mov    0xc(%ebp),%edx
  802688:	8b 45 08             	mov    0x8(%ebp),%eax
  80268b:	6a 00                	push   $0x0
  80268d:	6a 00                	push   $0x0
  80268f:	6a 00                	push   $0x0
  802691:	52                   	push   %edx
  802692:	50                   	push   %eax
  802693:	6a 2f                	push   $0x2f
  802695:	e8 a7 f9 ff ff       	call   802041 <syscall>
  80269a:	83 c4 18             	add    $0x18,%esp
}
  80269d:	c9                   	leave  
  80269e:	c3                   	ret    

0080269f <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80269f:	55                   	push   %ebp
  8026a0:	89 e5                	mov    %esp,%ebp
  8026a2:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8026a5:	83 ec 0c             	sub    $0xc,%esp
  8026a8:	68 10 43 80 00       	push   $0x804310
  8026ad:	e8 d9 e4 ff ff       	call   800b8b <cprintf>
  8026b2:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8026b5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8026bc:	83 ec 0c             	sub    $0xc,%esp
  8026bf:	68 3c 43 80 00       	push   $0x80433c
  8026c4:	e8 c2 e4 ff ff       	call   800b8b <cprintf>
  8026c9:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8026cc:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026d0:	a1 38 51 80 00       	mov    0x805138,%eax
  8026d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026d8:	eb 56                	jmp    802730 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8026da:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026de:	74 1c                	je     8026fc <print_mem_block_lists+0x5d>
  8026e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e3:	8b 50 08             	mov    0x8(%eax),%edx
  8026e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e9:	8b 48 08             	mov    0x8(%eax),%ecx
  8026ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8026f2:	01 c8                	add    %ecx,%eax
  8026f4:	39 c2                	cmp    %eax,%edx
  8026f6:	73 04                	jae    8026fc <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8026f8:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8026fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ff:	8b 50 08             	mov    0x8(%eax),%edx
  802702:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802705:	8b 40 0c             	mov    0xc(%eax),%eax
  802708:	01 c2                	add    %eax,%edx
  80270a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270d:	8b 40 08             	mov    0x8(%eax),%eax
  802710:	83 ec 04             	sub    $0x4,%esp
  802713:	52                   	push   %edx
  802714:	50                   	push   %eax
  802715:	68 51 43 80 00       	push   $0x804351
  80271a:	e8 6c e4 ff ff       	call   800b8b <cprintf>
  80271f:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802722:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802725:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802728:	a1 40 51 80 00       	mov    0x805140,%eax
  80272d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802730:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802734:	74 07                	je     80273d <print_mem_block_lists+0x9e>
  802736:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802739:	8b 00                	mov    (%eax),%eax
  80273b:	eb 05                	jmp    802742 <print_mem_block_lists+0xa3>
  80273d:	b8 00 00 00 00       	mov    $0x0,%eax
  802742:	a3 40 51 80 00       	mov    %eax,0x805140
  802747:	a1 40 51 80 00       	mov    0x805140,%eax
  80274c:	85 c0                	test   %eax,%eax
  80274e:	75 8a                	jne    8026da <print_mem_block_lists+0x3b>
  802750:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802754:	75 84                	jne    8026da <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802756:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80275a:	75 10                	jne    80276c <print_mem_block_lists+0xcd>
  80275c:	83 ec 0c             	sub    $0xc,%esp
  80275f:	68 60 43 80 00       	push   $0x804360
  802764:	e8 22 e4 ff ff       	call   800b8b <cprintf>
  802769:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80276c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802773:	83 ec 0c             	sub    $0xc,%esp
  802776:	68 84 43 80 00       	push   $0x804384
  80277b:	e8 0b e4 ff ff       	call   800b8b <cprintf>
  802780:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802783:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802787:	a1 40 50 80 00       	mov    0x805040,%eax
  80278c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80278f:	eb 56                	jmp    8027e7 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802791:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802795:	74 1c                	je     8027b3 <print_mem_block_lists+0x114>
  802797:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279a:	8b 50 08             	mov    0x8(%eax),%edx
  80279d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a0:	8b 48 08             	mov    0x8(%eax),%ecx
  8027a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8027a9:	01 c8                	add    %ecx,%eax
  8027ab:	39 c2                	cmp    %eax,%edx
  8027ad:	73 04                	jae    8027b3 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8027af:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8027b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b6:	8b 50 08             	mov    0x8(%eax),%edx
  8027b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8027bf:	01 c2                	add    %eax,%edx
  8027c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c4:	8b 40 08             	mov    0x8(%eax),%eax
  8027c7:	83 ec 04             	sub    $0x4,%esp
  8027ca:	52                   	push   %edx
  8027cb:	50                   	push   %eax
  8027cc:	68 51 43 80 00       	push   $0x804351
  8027d1:	e8 b5 e3 ff ff       	call   800b8b <cprintf>
  8027d6:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8027d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8027df:	a1 48 50 80 00       	mov    0x805048,%eax
  8027e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027eb:	74 07                	je     8027f4 <print_mem_block_lists+0x155>
  8027ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f0:	8b 00                	mov    (%eax),%eax
  8027f2:	eb 05                	jmp    8027f9 <print_mem_block_lists+0x15a>
  8027f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f9:	a3 48 50 80 00       	mov    %eax,0x805048
  8027fe:	a1 48 50 80 00       	mov    0x805048,%eax
  802803:	85 c0                	test   %eax,%eax
  802805:	75 8a                	jne    802791 <print_mem_block_lists+0xf2>
  802807:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80280b:	75 84                	jne    802791 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80280d:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802811:	75 10                	jne    802823 <print_mem_block_lists+0x184>
  802813:	83 ec 0c             	sub    $0xc,%esp
  802816:	68 9c 43 80 00       	push   $0x80439c
  80281b:	e8 6b e3 ff ff       	call   800b8b <cprintf>
  802820:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802823:	83 ec 0c             	sub    $0xc,%esp
  802826:	68 10 43 80 00       	push   $0x804310
  80282b:	e8 5b e3 ff ff       	call   800b8b <cprintf>
  802830:	83 c4 10             	add    $0x10,%esp

}
  802833:	90                   	nop
  802834:	c9                   	leave  
  802835:	c3                   	ret    

00802836 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802836:	55                   	push   %ebp
  802837:	89 e5                	mov    %esp,%ebp
  802839:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  80283c:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802843:	00 00 00 
  802846:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80284d:	00 00 00 
  802850:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802857:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  80285a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802861:	e9 9e 00 00 00       	jmp    802904 <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802866:	a1 50 50 80 00       	mov    0x805050,%eax
  80286b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80286e:	c1 e2 04             	shl    $0x4,%edx
  802871:	01 d0                	add    %edx,%eax
  802873:	85 c0                	test   %eax,%eax
  802875:	75 14                	jne    80288b <initialize_MemBlocksList+0x55>
  802877:	83 ec 04             	sub    $0x4,%esp
  80287a:	68 c4 43 80 00       	push   $0x8043c4
  80287f:	6a 42                	push   $0x42
  802881:	68 e7 43 80 00       	push   $0x8043e7
  802886:	e8 4c e0 ff ff       	call   8008d7 <_panic>
  80288b:	a1 50 50 80 00       	mov    0x805050,%eax
  802890:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802893:	c1 e2 04             	shl    $0x4,%edx
  802896:	01 d0                	add    %edx,%eax
  802898:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80289e:	89 10                	mov    %edx,(%eax)
  8028a0:	8b 00                	mov    (%eax),%eax
  8028a2:	85 c0                	test   %eax,%eax
  8028a4:	74 18                	je     8028be <initialize_MemBlocksList+0x88>
  8028a6:	a1 48 51 80 00       	mov    0x805148,%eax
  8028ab:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8028b1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8028b4:	c1 e1 04             	shl    $0x4,%ecx
  8028b7:	01 ca                	add    %ecx,%edx
  8028b9:	89 50 04             	mov    %edx,0x4(%eax)
  8028bc:	eb 12                	jmp    8028d0 <initialize_MemBlocksList+0x9a>
  8028be:	a1 50 50 80 00       	mov    0x805050,%eax
  8028c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028c6:	c1 e2 04             	shl    $0x4,%edx
  8028c9:	01 d0                	add    %edx,%eax
  8028cb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028d0:	a1 50 50 80 00       	mov    0x805050,%eax
  8028d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028d8:	c1 e2 04             	shl    $0x4,%edx
  8028db:	01 d0                	add    %edx,%eax
  8028dd:	a3 48 51 80 00       	mov    %eax,0x805148
  8028e2:	a1 50 50 80 00       	mov    0x805050,%eax
  8028e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028ea:	c1 e2 04             	shl    $0x4,%edx
  8028ed:	01 d0                	add    %edx,%eax
  8028ef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028f6:	a1 54 51 80 00       	mov    0x805154,%eax
  8028fb:	40                   	inc    %eax
  8028fc:	a3 54 51 80 00       	mov    %eax,0x805154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  802901:	ff 45 f4             	incl   -0xc(%ebp)
  802904:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802907:	3b 45 08             	cmp    0x8(%ebp),%eax
  80290a:	0f 82 56 ff ff ff    	jb     802866 <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  802910:	90                   	nop
  802911:	c9                   	leave  
  802912:	c3                   	ret    

00802913 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802913:	55                   	push   %ebp
  802914:	89 e5                	mov    %esp,%ebp
  802916:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  802919:	8b 45 08             	mov    0x8(%ebp),%eax
  80291c:	8b 00                	mov    (%eax),%eax
  80291e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802921:	eb 19                	jmp    80293c <find_block+0x29>
	{
		if(blk->sva==va)
  802923:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802926:	8b 40 08             	mov    0x8(%eax),%eax
  802929:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80292c:	75 05                	jne    802933 <find_block+0x20>
			return (blk);
  80292e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802931:	eb 36                	jmp    802969 <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  802933:	8b 45 08             	mov    0x8(%ebp),%eax
  802936:	8b 40 08             	mov    0x8(%eax),%eax
  802939:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80293c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802940:	74 07                	je     802949 <find_block+0x36>
  802942:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802945:	8b 00                	mov    (%eax),%eax
  802947:	eb 05                	jmp    80294e <find_block+0x3b>
  802949:	b8 00 00 00 00       	mov    $0x0,%eax
  80294e:	8b 55 08             	mov    0x8(%ebp),%edx
  802951:	89 42 08             	mov    %eax,0x8(%edx)
  802954:	8b 45 08             	mov    0x8(%ebp),%eax
  802957:	8b 40 08             	mov    0x8(%eax),%eax
  80295a:	85 c0                	test   %eax,%eax
  80295c:	75 c5                	jne    802923 <find_block+0x10>
  80295e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802962:	75 bf                	jne    802923 <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  802964:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802969:	c9                   	leave  
  80296a:	c3                   	ret    

0080296b <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80296b:	55                   	push   %ebp
  80296c:	89 e5                	mov    %esp,%ebp
  80296e:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  802971:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802976:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802979:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  802980:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802983:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802986:	75 65                	jne    8029ed <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802988:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80298c:	75 14                	jne    8029a2 <insert_sorted_allocList+0x37>
  80298e:	83 ec 04             	sub    $0x4,%esp
  802991:	68 c4 43 80 00       	push   $0x8043c4
  802996:	6a 5c                	push   $0x5c
  802998:	68 e7 43 80 00       	push   $0x8043e7
  80299d:	e8 35 df ff ff       	call   8008d7 <_panic>
  8029a2:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8029a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ab:	89 10                	mov    %edx,(%eax)
  8029ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b0:	8b 00                	mov    (%eax),%eax
  8029b2:	85 c0                	test   %eax,%eax
  8029b4:	74 0d                	je     8029c3 <insert_sorted_allocList+0x58>
  8029b6:	a1 40 50 80 00       	mov    0x805040,%eax
  8029bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8029be:	89 50 04             	mov    %edx,0x4(%eax)
  8029c1:	eb 08                	jmp    8029cb <insert_sorted_allocList+0x60>
  8029c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c6:	a3 44 50 80 00       	mov    %eax,0x805044
  8029cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ce:	a3 40 50 80 00       	mov    %eax,0x805040
  8029d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029dd:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029e2:	40                   	inc    %eax
  8029e3:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  8029e8:	e9 7b 01 00 00       	jmp    802b68 <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  8029ed:	a1 44 50 80 00       	mov    0x805044,%eax
  8029f2:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  8029f5:	a1 40 50 80 00       	mov    0x805040,%eax
  8029fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  8029fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802a00:	8b 50 08             	mov    0x8(%eax),%edx
  802a03:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a06:	8b 40 08             	mov    0x8(%eax),%eax
  802a09:	39 c2                	cmp    %eax,%edx
  802a0b:	76 65                	jbe    802a72 <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  802a0d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a11:	75 14                	jne    802a27 <insert_sorted_allocList+0xbc>
  802a13:	83 ec 04             	sub    $0x4,%esp
  802a16:	68 00 44 80 00       	push   $0x804400
  802a1b:	6a 64                	push   $0x64
  802a1d:	68 e7 43 80 00       	push   $0x8043e7
  802a22:	e8 b0 de ff ff       	call   8008d7 <_panic>
  802a27:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a30:	89 50 04             	mov    %edx,0x4(%eax)
  802a33:	8b 45 08             	mov    0x8(%ebp),%eax
  802a36:	8b 40 04             	mov    0x4(%eax),%eax
  802a39:	85 c0                	test   %eax,%eax
  802a3b:	74 0c                	je     802a49 <insert_sorted_allocList+0xde>
  802a3d:	a1 44 50 80 00       	mov    0x805044,%eax
  802a42:	8b 55 08             	mov    0x8(%ebp),%edx
  802a45:	89 10                	mov    %edx,(%eax)
  802a47:	eb 08                	jmp    802a51 <insert_sorted_allocList+0xe6>
  802a49:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4c:	a3 40 50 80 00       	mov    %eax,0x805040
  802a51:	8b 45 08             	mov    0x8(%ebp),%eax
  802a54:	a3 44 50 80 00       	mov    %eax,0x805044
  802a59:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a62:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a67:	40                   	inc    %eax
  802a68:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  802a6d:	e9 f6 00 00 00       	jmp    802b68 <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  802a72:	8b 45 08             	mov    0x8(%ebp),%eax
  802a75:	8b 50 08             	mov    0x8(%eax),%edx
  802a78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a7b:	8b 40 08             	mov    0x8(%eax),%eax
  802a7e:	39 c2                	cmp    %eax,%edx
  802a80:	73 65                	jae    802ae7 <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802a82:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a86:	75 14                	jne    802a9c <insert_sorted_allocList+0x131>
  802a88:	83 ec 04             	sub    $0x4,%esp
  802a8b:	68 c4 43 80 00       	push   $0x8043c4
  802a90:	6a 68                	push   $0x68
  802a92:	68 e7 43 80 00       	push   $0x8043e7
  802a97:	e8 3b de ff ff       	call   8008d7 <_panic>
  802a9c:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa5:	89 10                	mov    %edx,(%eax)
  802aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aaa:	8b 00                	mov    (%eax),%eax
  802aac:	85 c0                	test   %eax,%eax
  802aae:	74 0d                	je     802abd <insert_sorted_allocList+0x152>
  802ab0:	a1 40 50 80 00       	mov    0x805040,%eax
  802ab5:	8b 55 08             	mov    0x8(%ebp),%edx
  802ab8:	89 50 04             	mov    %edx,0x4(%eax)
  802abb:	eb 08                	jmp    802ac5 <insert_sorted_allocList+0x15a>
  802abd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac0:	a3 44 50 80 00       	mov    %eax,0x805044
  802ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac8:	a3 40 50 80 00       	mov    %eax,0x805040
  802acd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ad7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802adc:	40                   	inc    %eax
  802add:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  802ae2:	e9 81 00 00 00       	jmp    802b68 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802ae7:	a1 40 50 80 00       	mov    0x805040,%eax
  802aec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aef:	eb 51                	jmp    802b42 <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  802af1:	8b 45 08             	mov    0x8(%ebp),%eax
  802af4:	8b 50 08             	mov    0x8(%eax),%edx
  802af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afa:	8b 40 08             	mov    0x8(%eax),%eax
  802afd:	39 c2                	cmp    %eax,%edx
  802aff:	73 39                	jae    802b3a <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  802b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b04:	8b 40 04             	mov    0x4(%eax),%eax
  802b07:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  802b0a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b0d:	8b 55 08             	mov    0x8(%ebp),%edx
  802b10:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  802b12:	8b 45 08             	mov    0x8(%ebp),%eax
  802b15:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b18:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  802b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b21:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  802b23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b26:	8b 55 08             	mov    0x8(%ebp),%edx
  802b29:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  802b2c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b31:	40                   	inc    %eax
  802b32:	a3 4c 50 80 00       	mov    %eax,0x80504c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  802b37:	90                   	nop
				}
			}
		 }

	}
}
  802b38:	eb 2e                	jmp    802b68 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802b3a:	a1 48 50 80 00       	mov    0x805048,%eax
  802b3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b46:	74 07                	je     802b4f <insert_sorted_allocList+0x1e4>
  802b48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4b:	8b 00                	mov    (%eax),%eax
  802b4d:	eb 05                	jmp    802b54 <insert_sorted_allocList+0x1e9>
  802b4f:	b8 00 00 00 00       	mov    $0x0,%eax
  802b54:	a3 48 50 80 00       	mov    %eax,0x805048
  802b59:	a1 48 50 80 00       	mov    0x805048,%eax
  802b5e:	85 c0                	test   %eax,%eax
  802b60:	75 8f                	jne    802af1 <insert_sorted_allocList+0x186>
  802b62:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b66:	75 89                	jne    802af1 <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  802b68:	90                   	nop
  802b69:	c9                   	leave  
  802b6a:	c3                   	ret    

00802b6b <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802b6b:	55                   	push   %ebp
  802b6c:	89 e5                	mov    %esp,%ebp
  802b6e:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802b71:	a1 38 51 80 00       	mov    0x805138,%eax
  802b76:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b79:	e9 76 01 00 00       	jmp    802cf4 <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  802b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b81:	8b 40 0c             	mov    0xc(%eax),%eax
  802b84:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b87:	0f 85 8a 00 00 00    	jne    802c17 <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  802b8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b91:	75 17                	jne    802baa <alloc_block_FF+0x3f>
  802b93:	83 ec 04             	sub    $0x4,%esp
  802b96:	68 23 44 80 00       	push   $0x804423
  802b9b:	68 8a 00 00 00       	push   $0x8a
  802ba0:	68 e7 43 80 00       	push   $0x8043e7
  802ba5:	e8 2d dd ff ff       	call   8008d7 <_panic>
  802baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bad:	8b 00                	mov    (%eax),%eax
  802baf:	85 c0                	test   %eax,%eax
  802bb1:	74 10                	je     802bc3 <alloc_block_FF+0x58>
  802bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb6:	8b 00                	mov    (%eax),%eax
  802bb8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bbb:	8b 52 04             	mov    0x4(%edx),%edx
  802bbe:	89 50 04             	mov    %edx,0x4(%eax)
  802bc1:	eb 0b                	jmp    802bce <alloc_block_FF+0x63>
  802bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc6:	8b 40 04             	mov    0x4(%eax),%eax
  802bc9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd1:	8b 40 04             	mov    0x4(%eax),%eax
  802bd4:	85 c0                	test   %eax,%eax
  802bd6:	74 0f                	je     802be7 <alloc_block_FF+0x7c>
  802bd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdb:	8b 40 04             	mov    0x4(%eax),%eax
  802bde:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802be1:	8b 12                	mov    (%edx),%edx
  802be3:	89 10                	mov    %edx,(%eax)
  802be5:	eb 0a                	jmp    802bf1 <alloc_block_FF+0x86>
  802be7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bea:	8b 00                	mov    (%eax),%eax
  802bec:	a3 38 51 80 00       	mov    %eax,0x805138
  802bf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c04:	a1 44 51 80 00       	mov    0x805144,%eax
  802c09:	48                   	dec    %eax
  802c0a:	a3 44 51 80 00       	mov    %eax,0x805144
			return element;
  802c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c12:	e9 10 01 00 00       	jmp    802d27 <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  802c17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1a:	8b 40 0c             	mov    0xc(%eax),%eax
  802c1d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c20:	0f 86 c6 00 00 00    	jbe    802cec <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802c26:	a1 48 51 80 00       	mov    0x805148,%eax
  802c2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802c2e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c32:	75 17                	jne    802c4b <alloc_block_FF+0xe0>
  802c34:	83 ec 04             	sub    $0x4,%esp
  802c37:	68 23 44 80 00       	push   $0x804423
  802c3c:	68 90 00 00 00       	push   $0x90
  802c41:	68 e7 43 80 00       	push   $0x8043e7
  802c46:	e8 8c dc ff ff       	call   8008d7 <_panic>
  802c4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c4e:	8b 00                	mov    (%eax),%eax
  802c50:	85 c0                	test   %eax,%eax
  802c52:	74 10                	je     802c64 <alloc_block_FF+0xf9>
  802c54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c57:	8b 00                	mov    (%eax),%eax
  802c59:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c5c:	8b 52 04             	mov    0x4(%edx),%edx
  802c5f:	89 50 04             	mov    %edx,0x4(%eax)
  802c62:	eb 0b                	jmp    802c6f <alloc_block_FF+0x104>
  802c64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c67:	8b 40 04             	mov    0x4(%eax),%eax
  802c6a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c72:	8b 40 04             	mov    0x4(%eax),%eax
  802c75:	85 c0                	test   %eax,%eax
  802c77:	74 0f                	je     802c88 <alloc_block_FF+0x11d>
  802c79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c7c:	8b 40 04             	mov    0x4(%eax),%eax
  802c7f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c82:	8b 12                	mov    (%edx),%edx
  802c84:	89 10                	mov    %edx,(%eax)
  802c86:	eb 0a                	jmp    802c92 <alloc_block_FF+0x127>
  802c88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c8b:	8b 00                	mov    (%eax),%eax
  802c8d:	a3 48 51 80 00       	mov    %eax,0x805148
  802c92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c95:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ca5:	a1 54 51 80 00       	mov    0x805154,%eax
  802caa:	48                   	dec    %eax
  802cab:	a3 54 51 80 00       	mov    %eax,0x805154
			 element1->size =size;
  802cb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb3:	8b 55 08             	mov    0x8(%ebp),%edx
  802cb6:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  802cb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbc:	8b 50 08             	mov    0x8(%eax),%edx
  802cbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc2:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  802cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc8:	8b 50 08             	mov    0x8(%eax),%edx
  802ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cce:	01 c2                	add    %eax,%edx
  802cd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd3:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  802cd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd9:	8b 40 0c             	mov    0xc(%eax),%eax
  802cdc:	2b 45 08             	sub    0x8(%ebp),%eax
  802cdf:	89 c2                	mov    %eax,%edx
  802ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce4:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  802ce7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cea:	eb 3b                	jmp    802d27 <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802cec:	a1 40 51 80 00       	mov    0x805140,%eax
  802cf1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cf4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cf8:	74 07                	je     802d01 <alloc_block_FF+0x196>
  802cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfd:	8b 00                	mov    (%eax),%eax
  802cff:	eb 05                	jmp    802d06 <alloc_block_FF+0x19b>
  802d01:	b8 00 00 00 00       	mov    $0x0,%eax
  802d06:	a3 40 51 80 00       	mov    %eax,0x805140
  802d0b:	a1 40 51 80 00       	mov    0x805140,%eax
  802d10:	85 c0                	test   %eax,%eax
  802d12:	0f 85 66 fe ff ff    	jne    802b7e <alloc_block_FF+0x13>
  802d18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d1c:	0f 85 5c fe ff ff    	jne    802b7e <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  802d22:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d27:	c9                   	leave  
  802d28:	c3                   	ret    

00802d29 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802d29:	55                   	push   %ebp
  802d2a:	89 e5                	mov    %esp,%ebp
  802d2c:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  802d2f:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  802d36:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  802d3d:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802d44:	a1 38 51 80 00       	mov    0x805138,%eax
  802d49:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d4c:	e9 cf 00 00 00       	jmp    802e20 <alloc_block_BF+0xf7>
		{
			c++;
  802d51:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  802d54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d57:	8b 40 0c             	mov    0xc(%eax),%eax
  802d5a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d5d:	0f 85 8a 00 00 00    	jne    802ded <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  802d63:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d67:	75 17                	jne    802d80 <alloc_block_BF+0x57>
  802d69:	83 ec 04             	sub    $0x4,%esp
  802d6c:	68 23 44 80 00       	push   $0x804423
  802d71:	68 a8 00 00 00       	push   $0xa8
  802d76:	68 e7 43 80 00       	push   $0x8043e7
  802d7b:	e8 57 db ff ff       	call   8008d7 <_panic>
  802d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d83:	8b 00                	mov    (%eax),%eax
  802d85:	85 c0                	test   %eax,%eax
  802d87:	74 10                	je     802d99 <alloc_block_BF+0x70>
  802d89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8c:	8b 00                	mov    (%eax),%eax
  802d8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d91:	8b 52 04             	mov    0x4(%edx),%edx
  802d94:	89 50 04             	mov    %edx,0x4(%eax)
  802d97:	eb 0b                	jmp    802da4 <alloc_block_BF+0x7b>
  802d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9c:	8b 40 04             	mov    0x4(%eax),%eax
  802d9f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802da4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da7:	8b 40 04             	mov    0x4(%eax),%eax
  802daa:	85 c0                	test   %eax,%eax
  802dac:	74 0f                	je     802dbd <alloc_block_BF+0x94>
  802dae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db1:	8b 40 04             	mov    0x4(%eax),%eax
  802db4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802db7:	8b 12                	mov    (%edx),%edx
  802db9:	89 10                	mov    %edx,(%eax)
  802dbb:	eb 0a                	jmp    802dc7 <alloc_block_BF+0x9e>
  802dbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc0:	8b 00                	mov    (%eax),%eax
  802dc2:	a3 38 51 80 00       	mov    %eax,0x805138
  802dc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dda:	a1 44 51 80 00       	mov    0x805144,%eax
  802ddf:	48                   	dec    %eax
  802de0:	a3 44 51 80 00       	mov    %eax,0x805144
				return block;
  802de5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de8:	e9 85 01 00 00       	jmp    802f72 <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  802ded:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df0:	8b 40 0c             	mov    0xc(%eax),%eax
  802df3:	3b 45 08             	cmp    0x8(%ebp),%eax
  802df6:	76 20                	jbe    802e18 <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  802df8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfb:	8b 40 0c             	mov    0xc(%eax),%eax
  802dfe:	2b 45 08             	sub    0x8(%ebp),%eax
  802e01:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  802e04:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e07:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802e0a:	73 0c                	jae    802e18 <alloc_block_BF+0xef>
				{
					ma=tempi;
  802e0c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802e0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  802e12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e15:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802e18:	a1 40 51 80 00       	mov    0x805140,%eax
  802e1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e24:	74 07                	je     802e2d <alloc_block_BF+0x104>
  802e26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e29:	8b 00                	mov    (%eax),%eax
  802e2b:	eb 05                	jmp    802e32 <alloc_block_BF+0x109>
  802e2d:	b8 00 00 00 00       	mov    $0x0,%eax
  802e32:	a3 40 51 80 00       	mov    %eax,0x805140
  802e37:	a1 40 51 80 00       	mov    0x805140,%eax
  802e3c:	85 c0                	test   %eax,%eax
  802e3e:	0f 85 0d ff ff ff    	jne    802d51 <alloc_block_BF+0x28>
  802e44:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e48:	0f 85 03 ff ff ff    	jne    802d51 <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  802e4e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802e55:	a1 38 51 80 00       	mov    0x805138,%eax
  802e5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e5d:	e9 dd 00 00 00       	jmp    802f3f <alloc_block_BF+0x216>
		{
			if(x==sol)
  802e62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e65:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802e68:	0f 85 c6 00 00 00    	jne    802f34 <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802e6e:	a1 48 51 80 00       	mov    0x805148,%eax
  802e73:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802e76:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802e7a:	75 17                	jne    802e93 <alloc_block_BF+0x16a>
  802e7c:	83 ec 04             	sub    $0x4,%esp
  802e7f:	68 23 44 80 00       	push   $0x804423
  802e84:	68 bb 00 00 00       	push   $0xbb
  802e89:	68 e7 43 80 00       	push   $0x8043e7
  802e8e:	e8 44 da ff ff       	call   8008d7 <_panic>
  802e93:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e96:	8b 00                	mov    (%eax),%eax
  802e98:	85 c0                	test   %eax,%eax
  802e9a:	74 10                	je     802eac <alloc_block_BF+0x183>
  802e9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802e9f:	8b 00                	mov    (%eax),%eax
  802ea1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ea4:	8b 52 04             	mov    0x4(%edx),%edx
  802ea7:	89 50 04             	mov    %edx,0x4(%eax)
  802eaa:	eb 0b                	jmp    802eb7 <alloc_block_BF+0x18e>
  802eac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802eaf:	8b 40 04             	mov    0x4(%eax),%eax
  802eb2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802eb7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802eba:	8b 40 04             	mov    0x4(%eax),%eax
  802ebd:	85 c0                	test   %eax,%eax
  802ebf:	74 0f                	je     802ed0 <alloc_block_BF+0x1a7>
  802ec1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ec4:	8b 40 04             	mov    0x4(%eax),%eax
  802ec7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802eca:	8b 12                	mov    (%edx),%edx
  802ecc:	89 10                	mov    %edx,(%eax)
  802ece:	eb 0a                	jmp    802eda <alloc_block_BF+0x1b1>
  802ed0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ed3:	8b 00                	mov    (%eax),%eax
  802ed5:	a3 48 51 80 00       	mov    %eax,0x805148
  802eda:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802edd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ee3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ee6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eed:	a1 54 51 80 00       	mov    0x805154,%eax
  802ef2:	48                   	dec    %eax
  802ef3:	a3 54 51 80 00       	mov    %eax,0x805154
						 element1->size =size;
  802ef8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802efb:	8b 55 08             	mov    0x8(%ebp),%edx
  802efe:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  802f01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f04:	8b 50 08             	mov    0x8(%eax),%edx
  802f07:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f0a:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  802f0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f10:	8b 50 08             	mov    0x8(%eax),%edx
  802f13:	8b 45 08             	mov    0x8(%ebp),%eax
  802f16:	01 c2                	add    %eax,%edx
  802f18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1b:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  802f1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f21:	8b 40 0c             	mov    0xc(%eax),%eax
  802f24:	2b 45 08             	sub    0x8(%ebp),%eax
  802f27:	89 c2                	mov    %eax,%edx
  802f29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2c:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  802f2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f32:	eb 3e                	jmp    802f72 <alloc_block_BF+0x249>
						 break;
			}
			x++;
  802f34:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802f37:	a1 40 51 80 00       	mov    0x805140,%eax
  802f3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f3f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f43:	74 07                	je     802f4c <alloc_block_BF+0x223>
  802f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f48:	8b 00                	mov    (%eax),%eax
  802f4a:	eb 05                	jmp    802f51 <alloc_block_BF+0x228>
  802f4c:	b8 00 00 00 00       	mov    $0x0,%eax
  802f51:	a3 40 51 80 00       	mov    %eax,0x805140
  802f56:	a1 40 51 80 00       	mov    0x805140,%eax
  802f5b:	85 c0                	test   %eax,%eax
  802f5d:	0f 85 ff fe ff ff    	jne    802e62 <alloc_block_BF+0x139>
  802f63:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f67:	0f 85 f5 fe ff ff    	jne    802e62 <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  802f6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f72:	c9                   	leave  
  802f73:	c3                   	ret    

00802f74 <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802f74:	55                   	push   %ebp
  802f75:	89 e5                	mov    %esp,%ebp
  802f77:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  802f7a:	a1 2c 50 80 00       	mov    0x80502c,%eax
  802f7f:	85 c0                	test   %eax,%eax
  802f81:	75 14                	jne    802f97 <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  802f83:	a1 38 51 80 00       	mov    0x805138,%eax
  802f88:	a3 60 51 80 00       	mov    %eax,0x805160
		hh=1;
  802f8d:	c7 05 2c 50 80 00 01 	movl   $0x1,0x80502c
  802f94:	00 00 00 
	}
	uint32 c=1;
  802f97:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  802f9e:	a1 60 51 80 00       	mov    0x805160,%eax
  802fa3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802fa6:	e9 b3 01 00 00       	jmp    80315e <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  802fab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fae:	8b 40 0c             	mov    0xc(%eax),%eax
  802fb1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fb4:	0f 85 a9 00 00 00    	jne    803063 <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  802fba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fbd:	8b 00                	mov    (%eax),%eax
  802fbf:	85 c0                	test   %eax,%eax
  802fc1:	75 0c                	jne    802fcf <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  802fc3:	a1 38 51 80 00       	mov    0x805138,%eax
  802fc8:	a3 60 51 80 00       	mov    %eax,0x805160
  802fcd:	eb 0a                	jmp    802fd9 <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  802fcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fd2:	8b 00                	mov    (%eax),%eax
  802fd4:	a3 60 51 80 00       	mov    %eax,0x805160
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  802fd9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fdd:	75 17                	jne    802ff6 <alloc_block_NF+0x82>
  802fdf:	83 ec 04             	sub    $0x4,%esp
  802fe2:	68 23 44 80 00       	push   $0x804423
  802fe7:	68 e3 00 00 00       	push   $0xe3
  802fec:	68 e7 43 80 00       	push   $0x8043e7
  802ff1:	e8 e1 d8 ff ff       	call   8008d7 <_panic>
  802ff6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff9:	8b 00                	mov    (%eax),%eax
  802ffb:	85 c0                	test   %eax,%eax
  802ffd:	74 10                	je     80300f <alloc_block_NF+0x9b>
  802fff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803002:	8b 00                	mov    (%eax),%eax
  803004:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803007:	8b 52 04             	mov    0x4(%edx),%edx
  80300a:	89 50 04             	mov    %edx,0x4(%eax)
  80300d:	eb 0b                	jmp    80301a <alloc_block_NF+0xa6>
  80300f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803012:	8b 40 04             	mov    0x4(%eax),%eax
  803015:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80301a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80301d:	8b 40 04             	mov    0x4(%eax),%eax
  803020:	85 c0                	test   %eax,%eax
  803022:	74 0f                	je     803033 <alloc_block_NF+0xbf>
  803024:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803027:	8b 40 04             	mov    0x4(%eax),%eax
  80302a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80302d:	8b 12                	mov    (%edx),%edx
  80302f:	89 10                	mov    %edx,(%eax)
  803031:	eb 0a                	jmp    80303d <alloc_block_NF+0xc9>
  803033:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803036:	8b 00                	mov    (%eax),%eax
  803038:	a3 38 51 80 00       	mov    %eax,0x805138
  80303d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803040:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803046:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803049:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803050:	a1 44 51 80 00       	mov    0x805144,%eax
  803055:	48                   	dec    %eax
  803056:	a3 44 51 80 00       	mov    %eax,0x805144
				return element;
  80305b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80305e:	e9 0e 01 00 00       	jmp    803171 <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  803063:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803066:	8b 40 0c             	mov    0xc(%eax),%eax
  803069:	3b 45 08             	cmp    0x8(%ebp),%eax
  80306c:	0f 86 ce 00 00 00    	jbe    803140 <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  803072:	a1 48 51 80 00       	mov    0x805148,%eax
  803077:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  80307a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80307e:	75 17                	jne    803097 <alloc_block_NF+0x123>
  803080:	83 ec 04             	sub    $0x4,%esp
  803083:	68 23 44 80 00       	push   $0x804423
  803088:	68 e9 00 00 00       	push   $0xe9
  80308d:	68 e7 43 80 00       	push   $0x8043e7
  803092:	e8 40 d8 ff ff       	call   8008d7 <_panic>
  803097:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80309a:	8b 00                	mov    (%eax),%eax
  80309c:	85 c0                	test   %eax,%eax
  80309e:	74 10                	je     8030b0 <alloc_block_NF+0x13c>
  8030a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030a3:	8b 00                	mov    (%eax),%eax
  8030a5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030a8:	8b 52 04             	mov    0x4(%edx),%edx
  8030ab:	89 50 04             	mov    %edx,0x4(%eax)
  8030ae:	eb 0b                	jmp    8030bb <alloc_block_NF+0x147>
  8030b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030b3:	8b 40 04             	mov    0x4(%eax),%eax
  8030b6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030be:	8b 40 04             	mov    0x4(%eax),%eax
  8030c1:	85 c0                	test   %eax,%eax
  8030c3:	74 0f                	je     8030d4 <alloc_block_NF+0x160>
  8030c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030c8:	8b 40 04             	mov    0x4(%eax),%eax
  8030cb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030ce:	8b 12                	mov    (%edx),%edx
  8030d0:	89 10                	mov    %edx,(%eax)
  8030d2:	eb 0a                	jmp    8030de <alloc_block_NF+0x16a>
  8030d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030d7:	8b 00                	mov    (%eax),%eax
  8030d9:	a3 48 51 80 00       	mov    %eax,0x805148
  8030de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030f1:	a1 54 51 80 00       	mov    0x805154,%eax
  8030f6:	48                   	dec    %eax
  8030f7:	a3 54 51 80 00       	mov    %eax,0x805154
				 element1->size =size;
  8030fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030ff:	8b 55 08             	mov    0x8(%ebp),%edx
  803102:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  803105:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803108:	8b 50 08             	mov    0x8(%eax),%edx
  80310b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80310e:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  803111:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803114:	8b 50 08             	mov    0x8(%eax),%edx
  803117:	8b 45 08             	mov    0x8(%ebp),%eax
  80311a:	01 c2                	add    %eax,%edx
  80311c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80311f:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  803122:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803125:	8b 40 0c             	mov    0xc(%eax),%eax
  803128:	2b 45 08             	sub    0x8(%ebp),%eax
  80312b:	89 c2                	mov    %eax,%edx
  80312d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803130:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  803133:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803136:	a3 60 51 80 00       	mov    %eax,0x805160
				 return element1;
  80313b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80313e:	eb 31                	jmp    803171 <alloc_block_NF+0x1fd>
			 }
		 c++;
  803140:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  803143:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803146:	8b 00                	mov    (%eax),%eax
  803148:	85 c0                	test   %eax,%eax
  80314a:	75 0a                	jne    803156 <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  80314c:	a1 38 51 80 00       	mov    0x805138,%eax
  803151:	89 45 f0             	mov    %eax,-0x10(%ebp)
  803154:	eb 08                	jmp    80315e <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  803156:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803159:	8b 00                	mov    (%eax),%eax
  80315b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  80315e:	a1 44 51 80 00       	mov    0x805144,%eax
  803163:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803166:	0f 85 3f fe ff ff    	jne    802fab <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  80316c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803171:	c9                   	leave  
  803172:	c3                   	ret    

00803173 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803173:	55                   	push   %ebp
  803174:	89 e5                	mov    %esp,%ebp
  803176:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  803179:	a1 44 51 80 00       	mov    0x805144,%eax
  80317e:	85 c0                	test   %eax,%eax
  803180:	75 68                	jne    8031ea <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  803182:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803186:	75 17                	jne    80319f <insert_sorted_with_merge_freeList+0x2c>
  803188:	83 ec 04             	sub    $0x4,%esp
  80318b:	68 c4 43 80 00       	push   $0x8043c4
  803190:	68 0e 01 00 00       	push   $0x10e
  803195:	68 e7 43 80 00       	push   $0x8043e7
  80319a:	e8 38 d7 ff ff       	call   8008d7 <_panic>
  80319f:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8031a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a8:	89 10                	mov    %edx,(%eax)
  8031aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ad:	8b 00                	mov    (%eax),%eax
  8031af:	85 c0                	test   %eax,%eax
  8031b1:	74 0d                	je     8031c0 <insert_sorted_with_merge_freeList+0x4d>
  8031b3:	a1 38 51 80 00       	mov    0x805138,%eax
  8031b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8031bb:	89 50 04             	mov    %edx,0x4(%eax)
  8031be:	eb 08                	jmp    8031c8 <insert_sorted_with_merge_freeList+0x55>
  8031c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cb:	a3 38 51 80 00       	mov    %eax,0x805138
  8031d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031da:	a1 44 51 80 00       	mov    0x805144,%eax
  8031df:	40                   	inc    %eax
  8031e0:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  8031e5:	e9 8c 06 00 00       	jmp    803876 <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  8031ea:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8031ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  8031f2:	a1 38 51 80 00       	mov    0x805138,%eax
  8031f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  8031fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fd:	8b 50 08             	mov    0x8(%eax),%edx
  803200:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803203:	8b 40 08             	mov    0x8(%eax),%eax
  803206:	39 c2                	cmp    %eax,%edx
  803208:	0f 86 14 01 00 00    	jbe    803322 <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  80320e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803211:	8b 50 0c             	mov    0xc(%eax),%edx
  803214:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803217:	8b 40 08             	mov    0x8(%eax),%eax
  80321a:	01 c2                	add    %eax,%edx
  80321c:	8b 45 08             	mov    0x8(%ebp),%eax
  80321f:	8b 40 08             	mov    0x8(%eax),%eax
  803222:	39 c2                	cmp    %eax,%edx
  803224:	0f 85 90 00 00 00    	jne    8032ba <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  80322a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80322d:	8b 50 0c             	mov    0xc(%eax),%edx
  803230:	8b 45 08             	mov    0x8(%ebp),%eax
  803233:	8b 40 0c             	mov    0xc(%eax),%eax
  803236:	01 c2                	add    %eax,%edx
  803238:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80323b:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  80323e:	8b 45 08             	mov    0x8(%ebp),%eax
  803241:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  803248:	8b 45 08             	mov    0x8(%ebp),%eax
  80324b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803252:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803256:	75 17                	jne    80326f <insert_sorted_with_merge_freeList+0xfc>
  803258:	83 ec 04             	sub    $0x4,%esp
  80325b:	68 c4 43 80 00       	push   $0x8043c4
  803260:	68 1b 01 00 00       	push   $0x11b
  803265:	68 e7 43 80 00       	push   $0x8043e7
  80326a:	e8 68 d6 ff ff       	call   8008d7 <_panic>
  80326f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803275:	8b 45 08             	mov    0x8(%ebp),%eax
  803278:	89 10                	mov    %edx,(%eax)
  80327a:	8b 45 08             	mov    0x8(%ebp),%eax
  80327d:	8b 00                	mov    (%eax),%eax
  80327f:	85 c0                	test   %eax,%eax
  803281:	74 0d                	je     803290 <insert_sorted_with_merge_freeList+0x11d>
  803283:	a1 48 51 80 00       	mov    0x805148,%eax
  803288:	8b 55 08             	mov    0x8(%ebp),%edx
  80328b:	89 50 04             	mov    %edx,0x4(%eax)
  80328e:	eb 08                	jmp    803298 <insert_sorted_with_merge_freeList+0x125>
  803290:	8b 45 08             	mov    0x8(%ebp),%eax
  803293:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803298:	8b 45 08             	mov    0x8(%ebp),%eax
  80329b:	a3 48 51 80 00       	mov    %eax,0x805148
  8032a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032aa:	a1 54 51 80 00       	mov    0x805154,%eax
  8032af:	40                   	inc    %eax
  8032b0:	a3 54 51 80 00       	mov    %eax,0x805154
							}

						}
		          }
		}
}
  8032b5:	e9 bc 05 00 00       	jmp    803876 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  8032ba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032be:	75 17                	jne    8032d7 <insert_sorted_with_merge_freeList+0x164>
  8032c0:	83 ec 04             	sub    $0x4,%esp
  8032c3:	68 00 44 80 00       	push   $0x804400
  8032c8:	68 1f 01 00 00       	push   $0x11f
  8032cd:	68 e7 43 80 00       	push   $0x8043e7
  8032d2:	e8 00 d6 ff ff       	call   8008d7 <_panic>
  8032d7:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8032dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e0:	89 50 04             	mov    %edx,0x4(%eax)
  8032e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e6:	8b 40 04             	mov    0x4(%eax),%eax
  8032e9:	85 c0                	test   %eax,%eax
  8032eb:	74 0c                	je     8032f9 <insert_sorted_with_merge_freeList+0x186>
  8032ed:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8032f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8032f5:	89 10                	mov    %edx,(%eax)
  8032f7:	eb 08                	jmp    803301 <insert_sorted_with_merge_freeList+0x18e>
  8032f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fc:	a3 38 51 80 00       	mov    %eax,0x805138
  803301:	8b 45 08             	mov    0x8(%ebp),%eax
  803304:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803309:	8b 45 08             	mov    0x8(%ebp),%eax
  80330c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803312:	a1 44 51 80 00       	mov    0x805144,%eax
  803317:	40                   	inc    %eax
  803318:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  80331d:	e9 54 05 00 00       	jmp    803876 <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  803322:	8b 45 08             	mov    0x8(%ebp),%eax
  803325:	8b 50 08             	mov    0x8(%eax),%edx
  803328:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80332b:	8b 40 08             	mov    0x8(%eax),%eax
  80332e:	39 c2                	cmp    %eax,%edx
  803330:	0f 83 20 01 00 00    	jae    803456 <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  803336:	8b 45 08             	mov    0x8(%ebp),%eax
  803339:	8b 50 0c             	mov    0xc(%eax),%edx
  80333c:	8b 45 08             	mov    0x8(%ebp),%eax
  80333f:	8b 40 08             	mov    0x8(%eax),%eax
  803342:	01 c2                	add    %eax,%edx
  803344:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803347:	8b 40 08             	mov    0x8(%eax),%eax
  80334a:	39 c2                	cmp    %eax,%edx
  80334c:	0f 85 9c 00 00 00    	jne    8033ee <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  803352:	8b 45 08             	mov    0x8(%ebp),%eax
  803355:	8b 50 08             	mov    0x8(%eax),%edx
  803358:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80335b:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  80335e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803361:	8b 50 0c             	mov    0xc(%eax),%edx
  803364:	8b 45 08             	mov    0x8(%ebp),%eax
  803367:	8b 40 0c             	mov    0xc(%eax),%eax
  80336a:	01 c2                	add    %eax,%edx
  80336c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80336f:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  803372:	8b 45 08             	mov    0x8(%ebp),%eax
  803375:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  80337c:	8b 45 08             	mov    0x8(%ebp),%eax
  80337f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803386:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80338a:	75 17                	jne    8033a3 <insert_sorted_with_merge_freeList+0x230>
  80338c:	83 ec 04             	sub    $0x4,%esp
  80338f:	68 c4 43 80 00       	push   $0x8043c4
  803394:	68 2a 01 00 00       	push   $0x12a
  803399:	68 e7 43 80 00       	push   $0x8043e7
  80339e:	e8 34 d5 ff ff       	call   8008d7 <_panic>
  8033a3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ac:	89 10                	mov    %edx,(%eax)
  8033ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b1:	8b 00                	mov    (%eax),%eax
  8033b3:	85 c0                	test   %eax,%eax
  8033b5:	74 0d                	je     8033c4 <insert_sorted_with_merge_freeList+0x251>
  8033b7:	a1 48 51 80 00       	mov    0x805148,%eax
  8033bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8033bf:	89 50 04             	mov    %edx,0x4(%eax)
  8033c2:	eb 08                	jmp    8033cc <insert_sorted_with_merge_freeList+0x259>
  8033c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033cf:	a3 48 51 80 00       	mov    %eax,0x805148
  8033d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033de:	a1 54 51 80 00       	mov    0x805154,%eax
  8033e3:	40                   	inc    %eax
  8033e4:	a3 54 51 80 00       	mov    %eax,0x805154
							}

						}
		          }
		}
}
  8033e9:	e9 88 04 00 00       	jmp    803876 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8033ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033f2:	75 17                	jne    80340b <insert_sorted_with_merge_freeList+0x298>
  8033f4:	83 ec 04             	sub    $0x4,%esp
  8033f7:	68 c4 43 80 00       	push   $0x8043c4
  8033fc:	68 2e 01 00 00       	push   $0x12e
  803401:	68 e7 43 80 00       	push   $0x8043e7
  803406:	e8 cc d4 ff ff       	call   8008d7 <_panic>
  80340b:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803411:	8b 45 08             	mov    0x8(%ebp),%eax
  803414:	89 10                	mov    %edx,(%eax)
  803416:	8b 45 08             	mov    0x8(%ebp),%eax
  803419:	8b 00                	mov    (%eax),%eax
  80341b:	85 c0                	test   %eax,%eax
  80341d:	74 0d                	je     80342c <insert_sorted_with_merge_freeList+0x2b9>
  80341f:	a1 38 51 80 00       	mov    0x805138,%eax
  803424:	8b 55 08             	mov    0x8(%ebp),%edx
  803427:	89 50 04             	mov    %edx,0x4(%eax)
  80342a:	eb 08                	jmp    803434 <insert_sorted_with_merge_freeList+0x2c1>
  80342c:	8b 45 08             	mov    0x8(%ebp),%eax
  80342f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803434:	8b 45 08             	mov    0x8(%ebp),%eax
  803437:	a3 38 51 80 00       	mov    %eax,0x805138
  80343c:	8b 45 08             	mov    0x8(%ebp),%eax
  80343f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803446:	a1 44 51 80 00       	mov    0x805144,%eax
  80344b:	40                   	inc    %eax
  80344c:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  803451:	e9 20 04 00 00       	jmp    803876 <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  803456:	a1 38 51 80 00       	mov    0x805138,%eax
  80345b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80345e:	e9 e2 03 00 00       	jmp    803845 <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  803463:	8b 45 08             	mov    0x8(%ebp),%eax
  803466:	8b 50 08             	mov    0x8(%eax),%edx
  803469:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80346c:	8b 40 08             	mov    0x8(%eax),%eax
  80346f:	39 c2                	cmp    %eax,%edx
  803471:	0f 83 c6 03 00 00    	jae    80383d <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  803477:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80347a:	8b 40 04             	mov    0x4(%eax),%eax
  80347d:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  803480:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803483:	8b 50 08             	mov    0x8(%eax),%edx
  803486:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803489:	8b 40 0c             	mov    0xc(%eax),%eax
  80348c:	01 d0                	add    %edx,%eax
  80348e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  803491:	8b 45 08             	mov    0x8(%ebp),%eax
  803494:	8b 50 0c             	mov    0xc(%eax),%edx
  803497:	8b 45 08             	mov    0x8(%ebp),%eax
  80349a:	8b 40 08             	mov    0x8(%eax),%eax
  80349d:	01 d0                	add    %edx,%eax
  80349f:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  8034a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a5:	8b 40 08             	mov    0x8(%eax),%eax
  8034a8:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8034ab:	74 7a                	je     803527 <insert_sorted_with_merge_freeList+0x3b4>
  8034ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b0:	8b 40 08             	mov    0x8(%eax),%eax
  8034b3:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8034b6:	74 6f                	je     803527 <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  8034b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034bc:	74 06                	je     8034c4 <insert_sorted_with_merge_freeList+0x351>
  8034be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034c2:	75 17                	jne    8034db <insert_sorted_with_merge_freeList+0x368>
  8034c4:	83 ec 04             	sub    $0x4,%esp
  8034c7:	68 44 44 80 00       	push   $0x804444
  8034cc:	68 43 01 00 00       	push   $0x143
  8034d1:	68 e7 43 80 00       	push   $0x8043e7
  8034d6:	e8 fc d3 ff ff       	call   8008d7 <_panic>
  8034db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034de:	8b 50 04             	mov    0x4(%eax),%edx
  8034e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e4:	89 50 04             	mov    %edx,0x4(%eax)
  8034e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034ed:	89 10                	mov    %edx,(%eax)
  8034ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f2:	8b 40 04             	mov    0x4(%eax),%eax
  8034f5:	85 c0                	test   %eax,%eax
  8034f7:	74 0d                	je     803506 <insert_sorted_with_merge_freeList+0x393>
  8034f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034fc:	8b 40 04             	mov    0x4(%eax),%eax
  8034ff:	8b 55 08             	mov    0x8(%ebp),%edx
  803502:	89 10                	mov    %edx,(%eax)
  803504:	eb 08                	jmp    80350e <insert_sorted_with_merge_freeList+0x39b>
  803506:	8b 45 08             	mov    0x8(%ebp),%eax
  803509:	a3 38 51 80 00       	mov    %eax,0x805138
  80350e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803511:	8b 55 08             	mov    0x8(%ebp),%edx
  803514:	89 50 04             	mov    %edx,0x4(%eax)
  803517:	a1 44 51 80 00       	mov    0x805144,%eax
  80351c:	40                   	inc    %eax
  80351d:	a3 44 51 80 00       	mov    %eax,0x805144
  803522:	e9 14 03 00 00       	jmp    80383b <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  803527:	8b 45 08             	mov    0x8(%ebp),%eax
  80352a:	8b 40 08             	mov    0x8(%eax),%eax
  80352d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803530:	0f 85 a0 01 00 00    	jne    8036d6 <insert_sorted_with_merge_freeList+0x563>
  803536:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803539:	8b 40 08             	mov    0x8(%eax),%eax
  80353c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80353f:	0f 85 91 01 00 00    	jne    8036d6 <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  803545:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803548:	8b 50 0c             	mov    0xc(%eax),%edx
  80354b:	8b 45 08             	mov    0x8(%ebp),%eax
  80354e:	8b 48 0c             	mov    0xc(%eax),%ecx
  803551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803554:	8b 40 0c             	mov    0xc(%eax),%eax
  803557:	01 c8                	add    %ecx,%eax
  803559:	01 c2                	add    %eax,%edx
  80355b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80355e:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  803561:	8b 45 08             	mov    0x8(%ebp),%eax
  803564:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  80356b:	8b 45 08             	mov    0x8(%ebp),%eax
  80356e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  803575:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803578:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  80357f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803582:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803589:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80358d:	75 17                	jne    8035a6 <insert_sorted_with_merge_freeList+0x433>
  80358f:	83 ec 04             	sub    $0x4,%esp
  803592:	68 c4 43 80 00       	push   $0x8043c4
  803597:	68 4d 01 00 00       	push   $0x14d
  80359c:	68 e7 43 80 00       	push   $0x8043e7
  8035a1:	e8 31 d3 ff ff       	call   8008d7 <_panic>
  8035a6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8035af:	89 10                	mov    %edx,(%eax)
  8035b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b4:	8b 00                	mov    (%eax),%eax
  8035b6:	85 c0                	test   %eax,%eax
  8035b8:	74 0d                	je     8035c7 <insert_sorted_with_merge_freeList+0x454>
  8035ba:	a1 48 51 80 00       	mov    0x805148,%eax
  8035bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8035c2:	89 50 04             	mov    %edx,0x4(%eax)
  8035c5:	eb 08                	jmp    8035cf <insert_sorted_with_merge_freeList+0x45c>
  8035c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ca:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d2:	a3 48 51 80 00       	mov    %eax,0x805148
  8035d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035e1:	a1 54 51 80 00       	mov    0x805154,%eax
  8035e6:	40                   	inc    %eax
  8035e7:	a3 54 51 80 00       	mov    %eax,0x805154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  8035ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035f0:	75 17                	jne    803609 <insert_sorted_with_merge_freeList+0x496>
  8035f2:	83 ec 04             	sub    $0x4,%esp
  8035f5:	68 23 44 80 00       	push   $0x804423
  8035fa:	68 4e 01 00 00       	push   $0x14e
  8035ff:	68 e7 43 80 00       	push   $0x8043e7
  803604:	e8 ce d2 ff ff       	call   8008d7 <_panic>
  803609:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80360c:	8b 00                	mov    (%eax),%eax
  80360e:	85 c0                	test   %eax,%eax
  803610:	74 10                	je     803622 <insert_sorted_with_merge_freeList+0x4af>
  803612:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803615:	8b 00                	mov    (%eax),%eax
  803617:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80361a:	8b 52 04             	mov    0x4(%edx),%edx
  80361d:	89 50 04             	mov    %edx,0x4(%eax)
  803620:	eb 0b                	jmp    80362d <insert_sorted_with_merge_freeList+0x4ba>
  803622:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803625:	8b 40 04             	mov    0x4(%eax),%eax
  803628:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80362d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803630:	8b 40 04             	mov    0x4(%eax),%eax
  803633:	85 c0                	test   %eax,%eax
  803635:	74 0f                	je     803646 <insert_sorted_with_merge_freeList+0x4d3>
  803637:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80363a:	8b 40 04             	mov    0x4(%eax),%eax
  80363d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803640:	8b 12                	mov    (%edx),%edx
  803642:	89 10                	mov    %edx,(%eax)
  803644:	eb 0a                	jmp    803650 <insert_sorted_with_merge_freeList+0x4dd>
  803646:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803649:	8b 00                	mov    (%eax),%eax
  80364b:	a3 38 51 80 00       	mov    %eax,0x805138
  803650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803653:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803659:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80365c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803663:	a1 44 51 80 00       	mov    0x805144,%eax
  803668:	48                   	dec    %eax
  803669:	a3 44 51 80 00       	mov    %eax,0x805144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  80366e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803672:	75 17                	jne    80368b <insert_sorted_with_merge_freeList+0x518>
  803674:	83 ec 04             	sub    $0x4,%esp
  803677:	68 c4 43 80 00       	push   $0x8043c4
  80367c:	68 4f 01 00 00       	push   $0x14f
  803681:	68 e7 43 80 00       	push   $0x8043e7
  803686:	e8 4c d2 ff ff       	call   8008d7 <_panic>
  80368b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803691:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803694:	89 10                	mov    %edx,(%eax)
  803696:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803699:	8b 00                	mov    (%eax),%eax
  80369b:	85 c0                	test   %eax,%eax
  80369d:	74 0d                	je     8036ac <insert_sorted_with_merge_freeList+0x539>
  80369f:	a1 48 51 80 00       	mov    0x805148,%eax
  8036a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036a7:	89 50 04             	mov    %edx,0x4(%eax)
  8036aa:	eb 08                	jmp    8036b4 <insert_sorted_with_merge_freeList+0x541>
  8036ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036af:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b7:	a3 48 51 80 00       	mov    %eax,0x805148
  8036bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036bf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036c6:	a1 54 51 80 00       	mov    0x805154,%eax
  8036cb:	40                   	inc    %eax
  8036cc:	a3 54 51 80 00       	mov    %eax,0x805154
  8036d1:	e9 65 01 00 00       	jmp    80383b <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  8036d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d9:	8b 40 08             	mov    0x8(%eax),%eax
  8036dc:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8036df:	0f 85 9f 00 00 00    	jne    803784 <insert_sorted_with_merge_freeList+0x611>
  8036e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e8:	8b 40 08             	mov    0x8(%eax),%eax
  8036eb:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8036ee:	0f 84 90 00 00 00    	je     803784 <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  8036f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036f7:	8b 50 0c             	mov    0xc(%eax),%edx
  8036fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8036fd:	8b 40 0c             	mov    0xc(%eax),%eax
  803700:	01 c2                	add    %eax,%edx
  803702:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803705:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  803708:	8b 45 08             	mov    0x8(%ebp),%eax
  80370b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  803712:	8b 45 08             	mov    0x8(%ebp),%eax
  803715:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80371c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803720:	75 17                	jne    803739 <insert_sorted_with_merge_freeList+0x5c6>
  803722:	83 ec 04             	sub    $0x4,%esp
  803725:	68 c4 43 80 00       	push   $0x8043c4
  80372a:	68 58 01 00 00       	push   $0x158
  80372f:	68 e7 43 80 00       	push   $0x8043e7
  803734:	e8 9e d1 ff ff       	call   8008d7 <_panic>
  803739:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80373f:	8b 45 08             	mov    0x8(%ebp),%eax
  803742:	89 10                	mov    %edx,(%eax)
  803744:	8b 45 08             	mov    0x8(%ebp),%eax
  803747:	8b 00                	mov    (%eax),%eax
  803749:	85 c0                	test   %eax,%eax
  80374b:	74 0d                	je     80375a <insert_sorted_with_merge_freeList+0x5e7>
  80374d:	a1 48 51 80 00       	mov    0x805148,%eax
  803752:	8b 55 08             	mov    0x8(%ebp),%edx
  803755:	89 50 04             	mov    %edx,0x4(%eax)
  803758:	eb 08                	jmp    803762 <insert_sorted_with_merge_freeList+0x5ef>
  80375a:	8b 45 08             	mov    0x8(%ebp),%eax
  80375d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803762:	8b 45 08             	mov    0x8(%ebp),%eax
  803765:	a3 48 51 80 00       	mov    %eax,0x805148
  80376a:	8b 45 08             	mov    0x8(%ebp),%eax
  80376d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803774:	a1 54 51 80 00       	mov    0x805154,%eax
  803779:	40                   	inc    %eax
  80377a:	a3 54 51 80 00       	mov    %eax,0x805154
  80377f:	e9 b7 00 00 00       	jmp    80383b <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  803784:	8b 45 08             	mov    0x8(%ebp),%eax
  803787:	8b 40 08             	mov    0x8(%eax),%eax
  80378a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80378d:	0f 84 e2 00 00 00    	je     803875 <insert_sorted_with_merge_freeList+0x702>
  803793:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803796:	8b 40 08             	mov    0x8(%eax),%eax
  803799:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80379c:	0f 85 d3 00 00 00    	jne    803875 <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  8037a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a5:	8b 50 08             	mov    0x8(%eax),%edx
  8037a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ab:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  8037ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b1:	8b 50 0c             	mov    0xc(%eax),%edx
  8037b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8037ba:	01 c2                	add    %eax,%edx
  8037bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037bf:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  8037c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  8037cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8037cf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8037d6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037da:	75 17                	jne    8037f3 <insert_sorted_with_merge_freeList+0x680>
  8037dc:	83 ec 04             	sub    $0x4,%esp
  8037df:	68 c4 43 80 00       	push   $0x8043c4
  8037e4:	68 61 01 00 00       	push   $0x161
  8037e9:	68 e7 43 80 00       	push   $0x8043e7
  8037ee:	e8 e4 d0 ff ff       	call   8008d7 <_panic>
  8037f3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8037f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8037fc:	89 10                	mov    %edx,(%eax)
  8037fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803801:	8b 00                	mov    (%eax),%eax
  803803:	85 c0                	test   %eax,%eax
  803805:	74 0d                	je     803814 <insert_sorted_with_merge_freeList+0x6a1>
  803807:	a1 48 51 80 00       	mov    0x805148,%eax
  80380c:	8b 55 08             	mov    0x8(%ebp),%edx
  80380f:	89 50 04             	mov    %edx,0x4(%eax)
  803812:	eb 08                	jmp    80381c <insert_sorted_with_merge_freeList+0x6a9>
  803814:	8b 45 08             	mov    0x8(%ebp),%eax
  803817:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80381c:	8b 45 08             	mov    0x8(%ebp),%eax
  80381f:	a3 48 51 80 00       	mov    %eax,0x805148
  803824:	8b 45 08             	mov    0x8(%ebp),%eax
  803827:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80382e:	a1 54 51 80 00       	mov    0x805154,%eax
  803833:	40                   	inc    %eax
  803834:	a3 54 51 80 00       	mov    %eax,0x805154
								}
								break;
  803839:	eb 3a                	jmp    803875 <insert_sorted_with_merge_freeList+0x702>
  80383b:	eb 38                	jmp    803875 <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  80383d:	a1 40 51 80 00       	mov    0x805140,%eax
  803842:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803845:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803849:	74 07                	je     803852 <insert_sorted_with_merge_freeList+0x6df>
  80384b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80384e:	8b 00                	mov    (%eax),%eax
  803850:	eb 05                	jmp    803857 <insert_sorted_with_merge_freeList+0x6e4>
  803852:	b8 00 00 00 00       	mov    $0x0,%eax
  803857:	a3 40 51 80 00       	mov    %eax,0x805140
  80385c:	a1 40 51 80 00       	mov    0x805140,%eax
  803861:	85 c0                	test   %eax,%eax
  803863:	0f 85 fa fb ff ff    	jne    803463 <insert_sorted_with_merge_freeList+0x2f0>
  803869:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80386d:	0f 85 f0 fb ff ff    	jne    803463 <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  803873:	eb 01                	jmp    803876 <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  803875:	90                   	nop
							}

						}
		          }
		}
}
  803876:	90                   	nop
  803877:	c9                   	leave  
  803878:	c3                   	ret    
  803879:	66 90                	xchg   %ax,%ax
  80387b:	90                   	nop

0080387c <__udivdi3>:
  80387c:	55                   	push   %ebp
  80387d:	57                   	push   %edi
  80387e:	56                   	push   %esi
  80387f:	53                   	push   %ebx
  803880:	83 ec 1c             	sub    $0x1c,%esp
  803883:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803887:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80388b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80388f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803893:	89 ca                	mov    %ecx,%edx
  803895:	89 f8                	mov    %edi,%eax
  803897:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80389b:	85 f6                	test   %esi,%esi
  80389d:	75 2d                	jne    8038cc <__udivdi3+0x50>
  80389f:	39 cf                	cmp    %ecx,%edi
  8038a1:	77 65                	ja     803908 <__udivdi3+0x8c>
  8038a3:	89 fd                	mov    %edi,%ebp
  8038a5:	85 ff                	test   %edi,%edi
  8038a7:	75 0b                	jne    8038b4 <__udivdi3+0x38>
  8038a9:	b8 01 00 00 00       	mov    $0x1,%eax
  8038ae:	31 d2                	xor    %edx,%edx
  8038b0:	f7 f7                	div    %edi
  8038b2:	89 c5                	mov    %eax,%ebp
  8038b4:	31 d2                	xor    %edx,%edx
  8038b6:	89 c8                	mov    %ecx,%eax
  8038b8:	f7 f5                	div    %ebp
  8038ba:	89 c1                	mov    %eax,%ecx
  8038bc:	89 d8                	mov    %ebx,%eax
  8038be:	f7 f5                	div    %ebp
  8038c0:	89 cf                	mov    %ecx,%edi
  8038c2:	89 fa                	mov    %edi,%edx
  8038c4:	83 c4 1c             	add    $0x1c,%esp
  8038c7:	5b                   	pop    %ebx
  8038c8:	5e                   	pop    %esi
  8038c9:	5f                   	pop    %edi
  8038ca:	5d                   	pop    %ebp
  8038cb:	c3                   	ret    
  8038cc:	39 ce                	cmp    %ecx,%esi
  8038ce:	77 28                	ja     8038f8 <__udivdi3+0x7c>
  8038d0:	0f bd fe             	bsr    %esi,%edi
  8038d3:	83 f7 1f             	xor    $0x1f,%edi
  8038d6:	75 40                	jne    803918 <__udivdi3+0x9c>
  8038d8:	39 ce                	cmp    %ecx,%esi
  8038da:	72 0a                	jb     8038e6 <__udivdi3+0x6a>
  8038dc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8038e0:	0f 87 9e 00 00 00    	ja     803984 <__udivdi3+0x108>
  8038e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8038eb:	89 fa                	mov    %edi,%edx
  8038ed:	83 c4 1c             	add    $0x1c,%esp
  8038f0:	5b                   	pop    %ebx
  8038f1:	5e                   	pop    %esi
  8038f2:	5f                   	pop    %edi
  8038f3:	5d                   	pop    %ebp
  8038f4:	c3                   	ret    
  8038f5:	8d 76 00             	lea    0x0(%esi),%esi
  8038f8:	31 ff                	xor    %edi,%edi
  8038fa:	31 c0                	xor    %eax,%eax
  8038fc:	89 fa                	mov    %edi,%edx
  8038fe:	83 c4 1c             	add    $0x1c,%esp
  803901:	5b                   	pop    %ebx
  803902:	5e                   	pop    %esi
  803903:	5f                   	pop    %edi
  803904:	5d                   	pop    %ebp
  803905:	c3                   	ret    
  803906:	66 90                	xchg   %ax,%ax
  803908:	89 d8                	mov    %ebx,%eax
  80390a:	f7 f7                	div    %edi
  80390c:	31 ff                	xor    %edi,%edi
  80390e:	89 fa                	mov    %edi,%edx
  803910:	83 c4 1c             	add    $0x1c,%esp
  803913:	5b                   	pop    %ebx
  803914:	5e                   	pop    %esi
  803915:	5f                   	pop    %edi
  803916:	5d                   	pop    %ebp
  803917:	c3                   	ret    
  803918:	bd 20 00 00 00       	mov    $0x20,%ebp
  80391d:	89 eb                	mov    %ebp,%ebx
  80391f:	29 fb                	sub    %edi,%ebx
  803921:	89 f9                	mov    %edi,%ecx
  803923:	d3 e6                	shl    %cl,%esi
  803925:	89 c5                	mov    %eax,%ebp
  803927:	88 d9                	mov    %bl,%cl
  803929:	d3 ed                	shr    %cl,%ebp
  80392b:	89 e9                	mov    %ebp,%ecx
  80392d:	09 f1                	or     %esi,%ecx
  80392f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803933:	89 f9                	mov    %edi,%ecx
  803935:	d3 e0                	shl    %cl,%eax
  803937:	89 c5                	mov    %eax,%ebp
  803939:	89 d6                	mov    %edx,%esi
  80393b:	88 d9                	mov    %bl,%cl
  80393d:	d3 ee                	shr    %cl,%esi
  80393f:	89 f9                	mov    %edi,%ecx
  803941:	d3 e2                	shl    %cl,%edx
  803943:	8b 44 24 08          	mov    0x8(%esp),%eax
  803947:	88 d9                	mov    %bl,%cl
  803949:	d3 e8                	shr    %cl,%eax
  80394b:	09 c2                	or     %eax,%edx
  80394d:	89 d0                	mov    %edx,%eax
  80394f:	89 f2                	mov    %esi,%edx
  803951:	f7 74 24 0c          	divl   0xc(%esp)
  803955:	89 d6                	mov    %edx,%esi
  803957:	89 c3                	mov    %eax,%ebx
  803959:	f7 e5                	mul    %ebp
  80395b:	39 d6                	cmp    %edx,%esi
  80395d:	72 19                	jb     803978 <__udivdi3+0xfc>
  80395f:	74 0b                	je     80396c <__udivdi3+0xf0>
  803961:	89 d8                	mov    %ebx,%eax
  803963:	31 ff                	xor    %edi,%edi
  803965:	e9 58 ff ff ff       	jmp    8038c2 <__udivdi3+0x46>
  80396a:	66 90                	xchg   %ax,%ax
  80396c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803970:	89 f9                	mov    %edi,%ecx
  803972:	d3 e2                	shl    %cl,%edx
  803974:	39 c2                	cmp    %eax,%edx
  803976:	73 e9                	jae    803961 <__udivdi3+0xe5>
  803978:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80397b:	31 ff                	xor    %edi,%edi
  80397d:	e9 40 ff ff ff       	jmp    8038c2 <__udivdi3+0x46>
  803982:	66 90                	xchg   %ax,%ax
  803984:	31 c0                	xor    %eax,%eax
  803986:	e9 37 ff ff ff       	jmp    8038c2 <__udivdi3+0x46>
  80398b:	90                   	nop

0080398c <__umoddi3>:
  80398c:	55                   	push   %ebp
  80398d:	57                   	push   %edi
  80398e:	56                   	push   %esi
  80398f:	53                   	push   %ebx
  803990:	83 ec 1c             	sub    $0x1c,%esp
  803993:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803997:	8b 74 24 34          	mov    0x34(%esp),%esi
  80399b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80399f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8039a3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8039a7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8039ab:	89 f3                	mov    %esi,%ebx
  8039ad:	89 fa                	mov    %edi,%edx
  8039af:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8039b3:	89 34 24             	mov    %esi,(%esp)
  8039b6:	85 c0                	test   %eax,%eax
  8039b8:	75 1a                	jne    8039d4 <__umoddi3+0x48>
  8039ba:	39 f7                	cmp    %esi,%edi
  8039bc:	0f 86 a2 00 00 00    	jbe    803a64 <__umoddi3+0xd8>
  8039c2:	89 c8                	mov    %ecx,%eax
  8039c4:	89 f2                	mov    %esi,%edx
  8039c6:	f7 f7                	div    %edi
  8039c8:	89 d0                	mov    %edx,%eax
  8039ca:	31 d2                	xor    %edx,%edx
  8039cc:	83 c4 1c             	add    $0x1c,%esp
  8039cf:	5b                   	pop    %ebx
  8039d0:	5e                   	pop    %esi
  8039d1:	5f                   	pop    %edi
  8039d2:	5d                   	pop    %ebp
  8039d3:	c3                   	ret    
  8039d4:	39 f0                	cmp    %esi,%eax
  8039d6:	0f 87 ac 00 00 00    	ja     803a88 <__umoddi3+0xfc>
  8039dc:	0f bd e8             	bsr    %eax,%ebp
  8039df:	83 f5 1f             	xor    $0x1f,%ebp
  8039e2:	0f 84 ac 00 00 00    	je     803a94 <__umoddi3+0x108>
  8039e8:	bf 20 00 00 00       	mov    $0x20,%edi
  8039ed:	29 ef                	sub    %ebp,%edi
  8039ef:	89 fe                	mov    %edi,%esi
  8039f1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8039f5:	89 e9                	mov    %ebp,%ecx
  8039f7:	d3 e0                	shl    %cl,%eax
  8039f9:	89 d7                	mov    %edx,%edi
  8039fb:	89 f1                	mov    %esi,%ecx
  8039fd:	d3 ef                	shr    %cl,%edi
  8039ff:	09 c7                	or     %eax,%edi
  803a01:	89 e9                	mov    %ebp,%ecx
  803a03:	d3 e2                	shl    %cl,%edx
  803a05:	89 14 24             	mov    %edx,(%esp)
  803a08:	89 d8                	mov    %ebx,%eax
  803a0a:	d3 e0                	shl    %cl,%eax
  803a0c:	89 c2                	mov    %eax,%edx
  803a0e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a12:	d3 e0                	shl    %cl,%eax
  803a14:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a18:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a1c:	89 f1                	mov    %esi,%ecx
  803a1e:	d3 e8                	shr    %cl,%eax
  803a20:	09 d0                	or     %edx,%eax
  803a22:	d3 eb                	shr    %cl,%ebx
  803a24:	89 da                	mov    %ebx,%edx
  803a26:	f7 f7                	div    %edi
  803a28:	89 d3                	mov    %edx,%ebx
  803a2a:	f7 24 24             	mull   (%esp)
  803a2d:	89 c6                	mov    %eax,%esi
  803a2f:	89 d1                	mov    %edx,%ecx
  803a31:	39 d3                	cmp    %edx,%ebx
  803a33:	0f 82 87 00 00 00    	jb     803ac0 <__umoddi3+0x134>
  803a39:	0f 84 91 00 00 00    	je     803ad0 <__umoddi3+0x144>
  803a3f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803a43:	29 f2                	sub    %esi,%edx
  803a45:	19 cb                	sbb    %ecx,%ebx
  803a47:	89 d8                	mov    %ebx,%eax
  803a49:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803a4d:	d3 e0                	shl    %cl,%eax
  803a4f:	89 e9                	mov    %ebp,%ecx
  803a51:	d3 ea                	shr    %cl,%edx
  803a53:	09 d0                	or     %edx,%eax
  803a55:	89 e9                	mov    %ebp,%ecx
  803a57:	d3 eb                	shr    %cl,%ebx
  803a59:	89 da                	mov    %ebx,%edx
  803a5b:	83 c4 1c             	add    $0x1c,%esp
  803a5e:	5b                   	pop    %ebx
  803a5f:	5e                   	pop    %esi
  803a60:	5f                   	pop    %edi
  803a61:	5d                   	pop    %ebp
  803a62:	c3                   	ret    
  803a63:	90                   	nop
  803a64:	89 fd                	mov    %edi,%ebp
  803a66:	85 ff                	test   %edi,%edi
  803a68:	75 0b                	jne    803a75 <__umoddi3+0xe9>
  803a6a:	b8 01 00 00 00       	mov    $0x1,%eax
  803a6f:	31 d2                	xor    %edx,%edx
  803a71:	f7 f7                	div    %edi
  803a73:	89 c5                	mov    %eax,%ebp
  803a75:	89 f0                	mov    %esi,%eax
  803a77:	31 d2                	xor    %edx,%edx
  803a79:	f7 f5                	div    %ebp
  803a7b:	89 c8                	mov    %ecx,%eax
  803a7d:	f7 f5                	div    %ebp
  803a7f:	89 d0                	mov    %edx,%eax
  803a81:	e9 44 ff ff ff       	jmp    8039ca <__umoddi3+0x3e>
  803a86:	66 90                	xchg   %ax,%ax
  803a88:	89 c8                	mov    %ecx,%eax
  803a8a:	89 f2                	mov    %esi,%edx
  803a8c:	83 c4 1c             	add    $0x1c,%esp
  803a8f:	5b                   	pop    %ebx
  803a90:	5e                   	pop    %esi
  803a91:	5f                   	pop    %edi
  803a92:	5d                   	pop    %ebp
  803a93:	c3                   	ret    
  803a94:	3b 04 24             	cmp    (%esp),%eax
  803a97:	72 06                	jb     803a9f <__umoddi3+0x113>
  803a99:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803a9d:	77 0f                	ja     803aae <__umoddi3+0x122>
  803a9f:	89 f2                	mov    %esi,%edx
  803aa1:	29 f9                	sub    %edi,%ecx
  803aa3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803aa7:	89 14 24             	mov    %edx,(%esp)
  803aaa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803aae:	8b 44 24 04          	mov    0x4(%esp),%eax
  803ab2:	8b 14 24             	mov    (%esp),%edx
  803ab5:	83 c4 1c             	add    $0x1c,%esp
  803ab8:	5b                   	pop    %ebx
  803ab9:	5e                   	pop    %esi
  803aba:	5f                   	pop    %edi
  803abb:	5d                   	pop    %ebp
  803abc:	c3                   	ret    
  803abd:	8d 76 00             	lea    0x0(%esi),%esi
  803ac0:	2b 04 24             	sub    (%esp),%eax
  803ac3:	19 fa                	sbb    %edi,%edx
  803ac5:	89 d1                	mov    %edx,%ecx
  803ac7:	89 c6                	mov    %eax,%esi
  803ac9:	e9 71 ff ff ff       	jmp    803a3f <__umoddi3+0xb3>
  803ace:	66 90                	xchg   %ax,%ax
  803ad0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803ad4:	72 ea                	jb     803ac0 <__umoddi3+0x134>
  803ad6:	89 d9                	mov    %ebx,%ecx
  803ad8:	e9 62 ff ff ff       	jmp    803a3f <__umoddi3+0xb3>

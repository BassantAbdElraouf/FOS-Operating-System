
obj/user/arrayOperations_quicksort:     file format elf32-i386


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
  800031:	e8 20 03 00 00       	call   800356 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

void QuickSort(int *Elements, int NumOfElements);
void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	int32 envID = sys_getenvid();
  80003e:	e8 86 1b 00 00       	call   801bc9 <sys_getenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int32 parentenvID = sys_getparentenvid();
  800046:	e8 b0 1b 00 00       	call   801bfb <sys_getparentenvid>
  80004b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	int ret;
	/*[1] GET SHARED VARs*/
	//Get the shared array & its size
	int *numOfElements = NULL;
  80004e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	int *sharedArray = NULL;
  800055:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	sharedArray = sget(parentenvID,"arr") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 a0 34 80 00       	push   $0x8034a0
  800064:	ff 75 ec             	pushl  -0x14(%ebp)
  800067:	e8 4f 16 00 00       	call   8016bb <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 a4 34 80 00       	push   $0x8034a4
  80007a:	ff 75 ec             	pushl  -0x14(%ebp)
  80007d:	e8 39 16 00 00       	call   8016bb <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800088:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	finishedCount = sget(parentenvID,"finishedCount") ;
  80008f:	83 ec 08             	sub    $0x8,%esp
  800092:	68 ac 34 80 00       	push   $0x8034ac
  800097:	ff 75 ec             	pushl  -0x14(%ebp)
  80009a:	e8 1c 16 00 00       	call   8016bb <sget>
  80009f:	83 c4 10             	add    $0x10,%esp
  8000a2:	89 45 e0             	mov    %eax,-0x20(%ebp)

	/*[2] DO THE JOB*/
	//take a copy from the original array
	int *sortedArray;
	sortedArray = smalloc("quicksortedArr", sizeof(int) * *numOfElements, 0) ;
  8000a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000a8:	8b 00                	mov    (%eax),%eax
  8000aa:	c1 e0 02             	shl    $0x2,%eax
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 00                	push   $0x0
  8000b2:	50                   	push   %eax
  8000b3:	68 ba 34 80 00       	push   $0x8034ba
  8000b8:	e8 2c 15 00 00       	call   8015e9 <smalloc>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8000ca:	eb 25                	jmp    8000f1 <_main+0xb9>
	{
		sortedArray[i] = sharedArray[i];
  8000cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000d9:	01 c2                	add    %eax,%edx
  8000db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000de:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8000e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000e8:	01 c8                	add    %ecx,%eax
  8000ea:	8b 00                	mov    (%eax),%eax
  8000ec:	89 02                	mov    %eax,(%edx)
	/*[2] DO THE JOB*/
	//take a copy from the original array
	int *sortedArray;
	sortedArray = smalloc("quicksortedArr", sizeof(int) * *numOfElements, 0) ;
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000ee:	ff 45 f4             	incl   -0xc(%ebp)
  8000f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f4:	8b 00                	mov    (%eax),%eax
  8000f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000f9:	7f d1                	jg     8000cc <_main+0x94>
	{
		sortedArray[i] = sharedArray[i];
	}
	QuickSort(sortedArray, *numOfElements);
  8000fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000fe:	8b 00                	mov    (%eax),%eax
  800100:	83 ec 08             	sub    $0x8,%esp
  800103:	50                   	push   %eax
  800104:	ff 75 dc             	pushl  -0x24(%ebp)
  800107:	e8 23 00 00 00       	call   80012f <QuickSort>
  80010c:	83 c4 10             	add    $0x10,%esp
	cprintf("Quick sort is Finished!!!!\n") ;
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 c9 34 80 00       	push   $0x8034c9
  800117:	e8 4a 04 00 00       	call   800566 <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp

	/*[3] SHARE THE RESULTS & DECLARE FINISHING*/
	(*finishedCount)++ ;
  80011f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800122:	8b 00                	mov    (%eax),%eax
  800124:	8d 50 01             	lea    0x1(%eax),%edx
  800127:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80012a:	89 10                	mov    %edx,(%eax)

}
  80012c:	90                   	nop
  80012d:	c9                   	leave  
  80012e:	c3                   	ret    

0080012f <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  80012f:	55                   	push   %ebp
  800130:	89 e5                	mov    %esp,%ebp
  800132:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  800135:	8b 45 0c             	mov    0xc(%ebp),%eax
  800138:	48                   	dec    %eax
  800139:	50                   	push   %eax
  80013a:	6a 00                	push   $0x0
  80013c:	ff 75 0c             	pushl  0xc(%ebp)
  80013f:	ff 75 08             	pushl  0x8(%ebp)
  800142:	e8 06 00 00 00       	call   80014d <QSort>
  800147:	83 c4 10             	add    $0x10,%esp
}
  80014a:	90                   	nop
  80014b:	c9                   	leave  
  80014c:	c3                   	ret    

0080014d <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  80014d:	55                   	push   %ebp
  80014e:	89 e5                	mov    %esp,%ebp
  800150:	83 ec 28             	sub    $0x28,%esp
	if (startIndex >= finalIndex) return;
  800153:	8b 45 10             	mov    0x10(%ebp),%eax
  800156:	3b 45 14             	cmp    0x14(%ebp),%eax
  800159:	0f 8d 1b 01 00 00    	jge    80027a <QSort+0x12d>
	int pvtIndex = RAND(startIndex, finalIndex) ;
  80015f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800162:	83 ec 0c             	sub    $0xc,%esp
  800165:	50                   	push   %eax
  800166:	e8 c3 1a 00 00       	call   801c2e <sys_get_virtual_time>
  80016b:	83 c4 0c             	add    $0xc,%esp
  80016e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800171:	8b 55 14             	mov    0x14(%ebp),%edx
  800174:	2b 55 10             	sub    0x10(%ebp),%edx
  800177:	89 d1                	mov    %edx,%ecx
  800179:	ba 00 00 00 00       	mov    $0x0,%edx
  80017e:	f7 f1                	div    %ecx
  800180:	8b 45 10             	mov    0x10(%ebp),%eax
  800183:	01 d0                	add    %edx,%eax
  800185:	89 45 ec             	mov    %eax,-0x14(%ebp)
	Swap(Elements, startIndex, pvtIndex);
  800188:	83 ec 04             	sub    $0x4,%esp
  80018b:	ff 75 ec             	pushl  -0x14(%ebp)
  80018e:	ff 75 10             	pushl  0x10(%ebp)
  800191:	ff 75 08             	pushl  0x8(%ebp)
  800194:	e8 e4 00 00 00       	call   80027d <Swap>
  800199:	83 c4 10             	add    $0x10,%esp

	int i = startIndex+1, j = finalIndex;
  80019c:	8b 45 10             	mov    0x10(%ebp),%eax
  80019f:	40                   	inc    %eax
  8001a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8001a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8001a6:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  8001a9:	e9 80 00 00 00       	jmp    80022e <QSort+0xe1>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  8001ae:	ff 45 f4             	incl   -0xc(%ebp)
  8001b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001b4:	3b 45 14             	cmp    0x14(%ebp),%eax
  8001b7:	7f 2b                	jg     8001e4 <QSort+0x97>
  8001b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8001bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8001c6:	01 d0                	add    %edx,%eax
  8001c8:	8b 10                	mov    (%eax),%edx
  8001ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001cd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8001d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d7:	01 c8                	add    %ecx,%eax
  8001d9:	8b 00                	mov    (%eax),%eax
  8001db:	39 c2                	cmp    %eax,%edx
  8001dd:	7d cf                	jge    8001ae <QSort+0x61>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  8001df:	eb 03                	jmp    8001e4 <QSort+0x97>
  8001e1:	ff 4d f0             	decl   -0x10(%ebp)
  8001e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001e7:	3b 45 10             	cmp    0x10(%ebp),%eax
  8001ea:	7e 26                	jle    800212 <QSort+0xc5>
  8001ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8001ef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8001f9:	01 d0                	add    %edx,%eax
  8001fb:	8b 10                	mov    (%eax),%edx
  8001fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800200:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800207:	8b 45 08             	mov    0x8(%ebp),%eax
  80020a:	01 c8                	add    %ecx,%eax
  80020c:	8b 00                	mov    (%eax),%eax
  80020e:	39 c2                	cmp    %eax,%edx
  800210:	7e cf                	jle    8001e1 <QSort+0x94>

		if (i <= j)
  800212:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800215:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800218:	7f 14                	jg     80022e <QSort+0xe1>
		{
			Swap(Elements, i, j);
  80021a:	83 ec 04             	sub    $0x4,%esp
  80021d:	ff 75 f0             	pushl  -0x10(%ebp)
  800220:	ff 75 f4             	pushl  -0xc(%ebp)
  800223:	ff 75 08             	pushl  0x8(%ebp)
  800226:	e8 52 00 00 00       	call   80027d <Swap>
  80022b:	83 c4 10             	add    $0x10,%esp
	int pvtIndex = RAND(startIndex, finalIndex) ;
	Swap(Elements, startIndex, pvtIndex);

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  80022e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800231:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800234:	0f 8e 77 ff ff ff    	jle    8001b1 <QSort+0x64>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  80023a:	83 ec 04             	sub    $0x4,%esp
  80023d:	ff 75 f0             	pushl  -0x10(%ebp)
  800240:	ff 75 10             	pushl  0x10(%ebp)
  800243:	ff 75 08             	pushl  0x8(%ebp)
  800246:	e8 32 00 00 00       	call   80027d <Swap>
  80024b:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  80024e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800251:	48                   	dec    %eax
  800252:	50                   	push   %eax
  800253:	ff 75 10             	pushl  0x10(%ebp)
  800256:	ff 75 0c             	pushl  0xc(%ebp)
  800259:	ff 75 08             	pushl  0x8(%ebp)
  80025c:	e8 ec fe ff ff       	call   80014d <QSort>
  800261:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  800264:	ff 75 14             	pushl  0x14(%ebp)
  800267:	ff 75 f4             	pushl  -0xc(%ebp)
  80026a:	ff 75 0c             	pushl  0xc(%ebp)
  80026d:	ff 75 08             	pushl  0x8(%ebp)
  800270:	e8 d8 fe ff ff       	call   80014d <QSort>
  800275:	83 c4 10             	add    $0x10,%esp
  800278:	eb 01                	jmp    80027b <QSort+0x12e>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  80027a:	90                   	nop
	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);

	//cprintf("qs,after sorting: start = %d, end = %d\n", startIndex, finalIndex);

}
  80027b:	c9                   	leave  
  80027c:	c3                   	ret    

0080027d <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80027d:	55                   	push   %ebp
  80027e:	89 e5                	mov    %esp,%ebp
  800280:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800283:	8b 45 0c             	mov    0xc(%ebp),%eax
  800286:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80028d:	8b 45 08             	mov    0x8(%ebp),%eax
  800290:	01 d0                	add    %edx,%eax
  800292:	8b 00                	mov    (%eax),%eax
  800294:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800297:	8b 45 0c             	mov    0xc(%ebp),%eax
  80029a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a4:	01 c2                	add    %eax,%edx
  8002a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002a9:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b3:	01 c8                	add    %ecx,%eax
  8002b5:	8b 00                	mov    (%eax),%eax
  8002b7:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  8002b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8002bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c6:	01 c2                	add    %eax,%edx
  8002c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8002cb:	89 02                	mov    %eax,(%edx)
}
  8002cd:	90                   	nop
  8002ce:	c9                   	leave  
  8002cf:	c3                   	ret    

008002d0 <PrintElements>:


void PrintElements(int *Elements, int NumOfElements)
{
  8002d0:	55                   	push   %ebp
  8002d1:	89 e5                	mov    %esp,%ebp
  8002d3:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  8002d6:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8002dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8002e4:	eb 42                	jmp    800328 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  8002e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002e9:	99                   	cltd   
  8002ea:	f7 7d f0             	idivl  -0x10(%ebp)
  8002ed:	89 d0                	mov    %edx,%eax
  8002ef:	85 c0                	test   %eax,%eax
  8002f1:	75 10                	jne    800303 <PrintElements+0x33>
			cprintf("\n");
  8002f3:	83 ec 0c             	sub    $0xc,%esp
  8002f6:	68 e5 34 80 00       	push   $0x8034e5
  8002fb:	e8 66 02 00 00       	call   800566 <cprintf>
  800300:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800303:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800306:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80030d:	8b 45 08             	mov    0x8(%ebp),%eax
  800310:	01 d0                	add    %edx,%eax
  800312:	8b 00                	mov    (%eax),%eax
  800314:	83 ec 08             	sub    $0x8,%esp
  800317:	50                   	push   %eax
  800318:	68 e7 34 80 00       	push   $0x8034e7
  80031d:	e8 44 02 00 00       	call   800566 <cprintf>
  800322:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800325:	ff 45 f4             	incl   -0xc(%ebp)
  800328:	8b 45 0c             	mov    0xc(%ebp),%eax
  80032b:	48                   	dec    %eax
  80032c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80032f:	7f b5                	jg     8002e6 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800331:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800334:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80033b:	8b 45 08             	mov    0x8(%ebp),%eax
  80033e:	01 d0                	add    %edx,%eax
  800340:	8b 00                	mov    (%eax),%eax
  800342:	83 ec 08             	sub    $0x8,%esp
  800345:	50                   	push   %eax
  800346:	68 ec 34 80 00       	push   $0x8034ec
  80034b:	e8 16 02 00 00       	call   800566 <cprintf>
  800350:	83 c4 10             	add    $0x10,%esp

}
  800353:	90                   	nop
  800354:	c9                   	leave  
  800355:	c3                   	ret    

00800356 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800356:	55                   	push   %ebp
  800357:	89 e5                	mov    %esp,%ebp
  800359:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80035c:	e8 81 18 00 00       	call   801be2 <sys_getenvindex>
  800361:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800364:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800367:	89 d0                	mov    %edx,%eax
  800369:	c1 e0 03             	shl    $0x3,%eax
  80036c:	01 d0                	add    %edx,%eax
  80036e:	01 c0                	add    %eax,%eax
  800370:	01 d0                	add    %edx,%eax
  800372:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800379:	01 d0                	add    %edx,%eax
  80037b:	c1 e0 04             	shl    $0x4,%eax
  80037e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800383:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800388:	a1 20 40 80 00       	mov    0x804020,%eax
  80038d:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800393:	84 c0                	test   %al,%al
  800395:	74 0f                	je     8003a6 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800397:	a1 20 40 80 00       	mov    0x804020,%eax
  80039c:	05 5c 05 00 00       	add    $0x55c,%eax
  8003a1:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003aa:	7e 0a                	jle    8003b6 <libmain+0x60>
		binaryname = argv[0];
  8003ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003af:	8b 00                	mov    (%eax),%eax
  8003b1:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8003b6:	83 ec 08             	sub    $0x8,%esp
  8003b9:	ff 75 0c             	pushl  0xc(%ebp)
  8003bc:	ff 75 08             	pushl  0x8(%ebp)
  8003bf:	e8 74 fc ff ff       	call   800038 <_main>
  8003c4:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8003c7:	e8 23 16 00 00       	call   8019ef <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003cc:	83 ec 0c             	sub    $0xc,%esp
  8003cf:	68 08 35 80 00       	push   $0x803508
  8003d4:	e8 8d 01 00 00       	call   800566 <cprintf>
  8003d9:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003dc:	a1 20 40 80 00       	mov    0x804020,%eax
  8003e1:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8003e7:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ec:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8003f2:	83 ec 04             	sub    $0x4,%esp
  8003f5:	52                   	push   %edx
  8003f6:	50                   	push   %eax
  8003f7:	68 30 35 80 00       	push   $0x803530
  8003fc:	e8 65 01 00 00       	call   800566 <cprintf>
  800401:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800404:	a1 20 40 80 00       	mov    0x804020,%eax
  800409:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80040f:	a1 20 40 80 00       	mov    0x804020,%eax
  800414:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80041a:	a1 20 40 80 00       	mov    0x804020,%eax
  80041f:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800425:	51                   	push   %ecx
  800426:	52                   	push   %edx
  800427:	50                   	push   %eax
  800428:	68 58 35 80 00       	push   $0x803558
  80042d:	e8 34 01 00 00       	call   800566 <cprintf>
  800432:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800435:	a1 20 40 80 00       	mov    0x804020,%eax
  80043a:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800440:	83 ec 08             	sub    $0x8,%esp
  800443:	50                   	push   %eax
  800444:	68 b0 35 80 00       	push   $0x8035b0
  800449:	e8 18 01 00 00       	call   800566 <cprintf>
  80044e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800451:	83 ec 0c             	sub    $0xc,%esp
  800454:	68 08 35 80 00       	push   $0x803508
  800459:	e8 08 01 00 00       	call   800566 <cprintf>
  80045e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800461:	e8 a3 15 00 00       	call   801a09 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800466:	e8 19 00 00 00       	call   800484 <exit>
}
  80046b:	90                   	nop
  80046c:	c9                   	leave  
  80046d:	c3                   	ret    

0080046e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80046e:	55                   	push   %ebp
  80046f:	89 e5                	mov    %esp,%ebp
  800471:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800474:	83 ec 0c             	sub    $0xc,%esp
  800477:	6a 00                	push   $0x0
  800479:	e8 30 17 00 00       	call   801bae <sys_destroy_env>
  80047e:	83 c4 10             	add    $0x10,%esp
}
  800481:	90                   	nop
  800482:	c9                   	leave  
  800483:	c3                   	ret    

00800484 <exit>:

void
exit(void)
{
  800484:	55                   	push   %ebp
  800485:	89 e5                	mov    %esp,%ebp
  800487:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80048a:	e8 85 17 00 00       	call   801c14 <sys_exit_env>
}
  80048f:	90                   	nop
  800490:	c9                   	leave  
  800491:	c3                   	ret    

00800492 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800492:	55                   	push   %ebp
  800493:	89 e5                	mov    %esp,%ebp
  800495:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800498:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049b:	8b 00                	mov    (%eax),%eax
  80049d:	8d 48 01             	lea    0x1(%eax),%ecx
  8004a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a3:	89 0a                	mov    %ecx,(%edx)
  8004a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8004a8:	88 d1                	mov    %dl,%cl
  8004aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ad:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b4:	8b 00                	mov    (%eax),%eax
  8004b6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004bb:	75 2c                	jne    8004e9 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004bd:	a0 24 40 80 00       	mov    0x804024,%al
  8004c2:	0f b6 c0             	movzbl %al,%eax
  8004c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c8:	8b 12                	mov    (%edx),%edx
  8004ca:	89 d1                	mov    %edx,%ecx
  8004cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004cf:	83 c2 08             	add    $0x8,%edx
  8004d2:	83 ec 04             	sub    $0x4,%esp
  8004d5:	50                   	push   %eax
  8004d6:	51                   	push   %ecx
  8004d7:	52                   	push   %edx
  8004d8:	e8 64 13 00 00       	call   801841 <sys_cputs>
  8004dd:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ec:	8b 40 04             	mov    0x4(%eax),%eax
  8004ef:	8d 50 01             	lea    0x1(%eax),%edx
  8004f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f5:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004f8:	90                   	nop
  8004f9:	c9                   	leave  
  8004fa:	c3                   	ret    

008004fb <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004fb:	55                   	push   %ebp
  8004fc:	89 e5                	mov    %esp,%ebp
  8004fe:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800504:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80050b:	00 00 00 
	b.cnt = 0;
  80050e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800515:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800518:	ff 75 0c             	pushl  0xc(%ebp)
  80051b:	ff 75 08             	pushl  0x8(%ebp)
  80051e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800524:	50                   	push   %eax
  800525:	68 92 04 80 00       	push   $0x800492
  80052a:	e8 11 02 00 00       	call   800740 <vprintfmt>
  80052f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800532:	a0 24 40 80 00       	mov    0x804024,%al
  800537:	0f b6 c0             	movzbl %al,%eax
  80053a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800540:	83 ec 04             	sub    $0x4,%esp
  800543:	50                   	push   %eax
  800544:	52                   	push   %edx
  800545:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80054b:	83 c0 08             	add    $0x8,%eax
  80054e:	50                   	push   %eax
  80054f:	e8 ed 12 00 00       	call   801841 <sys_cputs>
  800554:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800557:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80055e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800564:	c9                   	leave  
  800565:	c3                   	ret    

00800566 <cprintf>:

int cprintf(const char *fmt, ...) {
  800566:	55                   	push   %ebp
  800567:	89 e5                	mov    %esp,%ebp
  800569:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80056c:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800573:	8d 45 0c             	lea    0xc(%ebp),%eax
  800576:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800579:	8b 45 08             	mov    0x8(%ebp),%eax
  80057c:	83 ec 08             	sub    $0x8,%esp
  80057f:	ff 75 f4             	pushl  -0xc(%ebp)
  800582:	50                   	push   %eax
  800583:	e8 73 ff ff ff       	call   8004fb <vcprintf>
  800588:	83 c4 10             	add    $0x10,%esp
  80058b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80058e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800591:	c9                   	leave  
  800592:	c3                   	ret    

00800593 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800593:	55                   	push   %ebp
  800594:	89 e5                	mov    %esp,%ebp
  800596:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800599:	e8 51 14 00 00       	call   8019ef <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80059e:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a7:	83 ec 08             	sub    $0x8,%esp
  8005aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8005ad:	50                   	push   %eax
  8005ae:	e8 48 ff ff ff       	call   8004fb <vcprintf>
  8005b3:	83 c4 10             	add    $0x10,%esp
  8005b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005b9:	e8 4b 14 00 00       	call   801a09 <sys_enable_interrupt>
	return cnt;
  8005be:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005c1:	c9                   	leave  
  8005c2:	c3                   	ret    

008005c3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005c3:	55                   	push   %ebp
  8005c4:	89 e5                	mov    %esp,%ebp
  8005c6:	53                   	push   %ebx
  8005c7:	83 ec 14             	sub    $0x14,%esp
  8005ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8005cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005d6:	8b 45 18             	mov    0x18(%ebp),%eax
  8005d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8005de:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005e1:	77 55                	ja     800638 <printnum+0x75>
  8005e3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005e6:	72 05                	jb     8005ed <printnum+0x2a>
  8005e8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005eb:	77 4b                	ja     800638 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005ed:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005f0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005f3:	8b 45 18             	mov    0x18(%ebp),%eax
  8005f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8005fb:	52                   	push   %edx
  8005fc:	50                   	push   %eax
  8005fd:	ff 75 f4             	pushl  -0xc(%ebp)
  800600:	ff 75 f0             	pushl  -0x10(%ebp)
  800603:	e8 28 2c 00 00       	call   803230 <__udivdi3>
  800608:	83 c4 10             	add    $0x10,%esp
  80060b:	83 ec 04             	sub    $0x4,%esp
  80060e:	ff 75 20             	pushl  0x20(%ebp)
  800611:	53                   	push   %ebx
  800612:	ff 75 18             	pushl  0x18(%ebp)
  800615:	52                   	push   %edx
  800616:	50                   	push   %eax
  800617:	ff 75 0c             	pushl  0xc(%ebp)
  80061a:	ff 75 08             	pushl  0x8(%ebp)
  80061d:	e8 a1 ff ff ff       	call   8005c3 <printnum>
  800622:	83 c4 20             	add    $0x20,%esp
  800625:	eb 1a                	jmp    800641 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800627:	83 ec 08             	sub    $0x8,%esp
  80062a:	ff 75 0c             	pushl  0xc(%ebp)
  80062d:	ff 75 20             	pushl  0x20(%ebp)
  800630:	8b 45 08             	mov    0x8(%ebp),%eax
  800633:	ff d0                	call   *%eax
  800635:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800638:	ff 4d 1c             	decl   0x1c(%ebp)
  80063b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80063f:	7f e6                	jg     800627 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800641:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800644:	bb 00 00 00 00       	mov    $0x0,%ebx
  800649:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80064c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80064f:	53                   	push   %ebx
  800650:	51                   	push   %ecx
  800651:	52                   	push   %edx
  800652:	50                   	push   %eax
  800653:	e8 e8 2c 00 00       	call   803340 <__umoddi3>
  800658:	83 c4 10             	add    $0x10,%esp
  80065b:	05 f4 37 80 00       	add    $0x8037f4,%eax
  800660:	8a 00                	mov    (%eax),%al
  800662:	0f be c0             	movsbl %al,%eax
  800665:	83 ec 08             	sub    $0x8,%esp
  800668:	ff 75 0c             	pushl  0xc(%ebp)
  80066b:	50                   	push   %eax
  80066c:	8b 45 08             	mov    0x8(%ebp),%eax
  80066f:	ff d0                	call   *%eax
  800671:	83 c4 10             	add    $0x10,%esp
}
  800674:	90                   	nop
  800675:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800678:	c9                   	leave  
  800679:	c3                   	ret    

0080067a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80067a:	55                   	push   %ebp
  80067b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80067d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800681:	7e 1c                	jle    80069f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800683:	8b 45 08             	mov    0x8(%ebp),%eax
  800686:	8b 00                	mov    (%eax),%eax
  800688:	8d 50 08             	lea    0x8(%eax),%edx
  80068b:	8b 45 08             	mov    0x8(%ebp),%eax
  80068e:	89 10                	mov    %edx,(%eax)
  800690:	8b 45 08             	mov    0x8(%ebp),%eax
  800693:	8b 00                	mov    (%eax),%eax
  800695:	83 e8 08             	sub    $0x8,%eax
  800698:	8b 50 04             	mov    0x4(%eax),%edx
  80069b:	8b 00                	mov    (%eax),%eax
  80069d:	eb 40                	jmp    8006df <getuint+0x65>
	else if (lflag)
  80069f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006a3:	74 1e                	je     8006c3 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a8:	8b 00                	mov    (%eax),%eax
  8006aa:	8d 50 04             	lea    0x4(%eax),%edx
  8006ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b0:	89 10                	mov    %edx,(%eax)
  8006b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b5:	8b 00                	mov    (%eax),%eax
  8006b7:	83 e8 04             	sub    $0x4,%eax
  8006ba:	8b 00                	mov    (%eax),%eax
  8006bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c1:	eb 1c                	jmp    8006df <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c6:	8b 00                	mov    (%eax),%eax
  8006c8:	8d 50 04             	lea    0x4(%eax),%edx
  8006cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ce:	89 10                	mov    %edx,(%eax)
  8006d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d3:	8b 00                	mov    (%eax),%eax
  8006d5:	83 e8 04             	sub    $0x4,%eax
  8006d8:	8b 00                	mov    (%eax),%eax
  8006da:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006df:	5d                   	pop    %ebp
  8006e0:	c3                   	ret    

008006e1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006e1:	55                   	push   %ebp
  8006e2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006e4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006e8:	7e 1c                	jle    800706 <getint+0x25>
		return va_arg(*ap, long long);
  8006ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ed:	8b 00                	mov    (%eax),%eax
  8006ef:	8d 50 08             	lea    0x8(%eax),%edx
  8006f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f5:	89 10                	mov    %edx,(%eax)
  8006f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fa:	8b 00                	mov    (%eax),%eax
  8006fc:	83 e8 08             	sub    $0x8,%eax
  8006ff:	8b 50 04             	mov    0x4(%eax),%edx
  800702:	8b 00                	mov    (%eax),%eax
  800704:	eb 38                	jmp    80073e <getint+0x5d>
	else if (lflag)
  800706:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80070a:	74 1a                	je     800726 <getint+0x45>
		return va_arg(*ap, long);
  80070c:	8b 45 08             	mov    0x8(%ebp),%eax
  80070f:	8b 00                	mov    (%eax),%eax
  800711:	8d 50 04             	lea    0x4(%eax),%edx
  800714:	8b 45 08             	mov    0x8(%ebp),%eax
  800717:	89 10                	mov    %edx,(%eax)
  800719:	8b 45 08             	mov    0x8(%ebp),%eax
  80071c:	8b 00                	mov    (%eax),%eax
  80071e:	83 e8 04             	sub    $0x4,%eax
  800721:	8b 00                	mov    (%eax),%eax
  800723:	99                   	cltd   
  800724:	eb 18                	jmp    80073e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800726:	8b 45 08             	mov    0x8(%ebp),%eax
  800729:	8b 00                	mov    (%eax),%eax
  80072b:	8d 50 04             	lea    0x4(%eax),%edx
  80072e:	8b 45 08             	mov    0x8(%ebp),%eax
  800731:	89 10                	mov    %edx,(%eax)
  800733:	8b 45 08             	mov    0x8(%ebp),%eax
  800736:	8b 00                	mov    (%eax),%eax
  800738:	83 e8 04             	sub    $0x4,%eax
  80073b:	8b 00                	mov    (%eax),%eax
  80073d:	99                   	cltd   
}
  80073e:	5d                   	pop    %ebp
  80073f:	c3                   	ret    

00800740 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800740:	55                   	push   %ebp
  800741:	89 e5                	mov    %esp,%ebp
  800743:	56                   	push   %esi
  800744:	53                   	push   %ebx
  800745:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800748:	eb 17                	jmp    800761 <vprintfmt+0x21>
			if (ch == '\0')
  80074a:	85 db                	test   %ebx,%ebx
  80074c:	0f 84 af 03 00 00    	je     800b01 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800752:	83 ec 08             	sub    $0x8,%esp
  800755:	ff 75 0c             	pushl  0xc(%ebp)
  800758:	53                   	push   %ebx
  800759:	8b 45 08             	mov    0x8(%ebp),%eax
  80075c:	ff d0                	call   *%eax
  80075e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800761:	8b 45 10             	mov    0x10(%ebp),%eax
  800764:	8d 50 01             	lea    0x1(%eax),%edx
  800767:	89 55 10             	mov    %edx,0x10(%ebp)
  80076a:	8a 00                	mov    (%eax),%al
  80076c:	0f b6 d8             	movzbl %al,%ebx
  80076f:	83 fb 25             	cmp    $0x25,%ebx
  800772:	75 d6                	jne    80074a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800774:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800778:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80077f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800786:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80078d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800794:	8b 45 10             	mov    0x10(%ebp),%eax
  800797:	8d 50 01             	lea    0x1(%eax),%edx
  80079a:	89 55 10             	mov    %edx,0x10(%ebp)
  80079d:	8a 00                	mov    (%eax),%al
  80079f:	0f b6 d8             	movzbl %al,%ebx
  8007a2:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007a5:	83 f8 55             	cmp    $0x55,%eax
  8007a8:	0f 87 2b 03 00 00    	ja     800ad9 <vprintfmt+0x399>
  8007ae:	8b 04 85 18 38 80 00 	mov    0x803818(,%eax,4),%eax
  8007b5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007b7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007bb:	eb d7                	jmp    800794 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007bd:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007c1:	eb d1                	jmp    800794 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007c3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007ca:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007cd:	89 d0                	mov    %edx,%eax
  8007cf:	c1 e0 02             	shl    $0x2,%eax
  8007d2:	01 d0                	add    %edx,%eax
  8007d4:	01 c0                	add    %eax,%eax
  8007d6:	01 d8                	add    %ebx,%eax
  8007d8:	83 e8 30             	sub    $0x30,%eax
  8007db:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007de:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e1:	8a 00                	mov    (%eax),%al
  8007e3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007e6:	83 fb 2f             	cmp    $0x2f,%ebx
  8007e9:	7e 3e                	jle    800829 <vprintfmt+0xe9>
  8007eb:	83 fb 39             	cmp    $0x39,%ebx
  8007ee:	7f 39                	jg     800829 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007f0:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007f3:	eb d5                	jmp    8007ca <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f8:	83 c0 04             	add    $0x4,%eax
  8007fb:	89 45 14             	mov    %eax,0x14(%ebp)
  8007fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800801:	83 e8 04             	sub    $0x4,%eax
  800804:	8b 00                	mov    (%eax),%eax
  800806:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800809:	eb 1f                	jmp    80082a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80080b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80080f:	79 83                	jns    800794 <vprintfmt+0x54>
				width = 0;
  800811:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800818:	e9 77 ff ff ff       	jmp    800794 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80081d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800824:	e9 6b ff ff ff       	jmp    800794 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800829:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80082a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80082e:	0f 89 60 ff ff ff    	jns    800794 <vprintfmt+0x54>
				width = precision, precision = -1;
  800834:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800837:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80083a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800841:	e9 4e ff ff ff       	jmp    800794 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800846:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800849:	e9 46 ff ff ff       	jmp    800794 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80084e:	8b 45 14             	mov    0x14(%ebp),%eax
  800851:	83 c0 04             	add    $0x4,%eax
  800854:	89 45 14             	mov    %eax,0x14(%ebp)
  800857:	8b 45 14             	mov    0x14(%ebp),%eax
  80085a:	83 e8 04             	sub    $0x4,%eax
  80085d:	8b 00                	mov    (%eax),%eax
  80085f:	83 ec 08             	sub    $0x8,%esp
  800862:	ff 75 0c             	pushl  0xc(%ebp)
  800865:	50                   	push   %eax
  800866:	8b 45 08             	mov    0x8(%ebp),%eax
  800869:	ff d0                	call   *%eax
  80086b:	83 c4 10             	add    $0x10,%esp
			break;
  80086e:	e9 89 02 00 00       	jmp    800afc <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800873:	8b 45 14             	mov    0x14(%ebp),%eax
  800876:	83 c0 04             	add    $0x4,%eax
  800879:	89 45 14             	mov    %eax,0x14(%ebp)
  80087c:	8b 45 14             	mov    0x14(%ebp),%eax
  80087f:	83 e8 04             	sub    $0x4,%eax
  800882:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800884:	85 db                	test   %ebx,%ebx
  800886:	79 02                	jns    80088a <vprintfmt+0x14a>
				err = -err;
  800888:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80088a:	83 fb 64             	cmp    $0x64,%ebx
  80088d:	7f 0b                	jg     80089a <vprintfmt+0x15a>
  80088f:	8b 34 9d 60 36 80 00 	mov    0x803660(,%ebx,4),%esi
  800896:	85 f6                	test   %esi,%esi
  800898:	75 19                	jne    8008b3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80089a:	53                   	push   %ebx
  80089b:	68 05 38 80 00       	push   $0x803805
  8008a0:	ff 75 0c             	pushl  0xc(%ebp)
  8008a3:	ff 75 08             	pushl  0x8(%ebp)
  8008a6:	e8 5e 02 00 00       	call   800b09 <printfmt>
  8008ab:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008ae:	e9 49 02 00 00       	jmp    800afc <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008b3:	56                   	push   %esi
  8008b4:	68 0e 38 80 00       	push   $0x80380e
  8008b9:	ff 75 0c             	pushl  0xc(%ebp)
  8008bc:	ff 75 08             	pushl  0x8(%ebp)
  8008bf:	e8 45 02 00 00       	call   800b09 <printfmt>
  8008c4:	83 c4 10             	add    $0x10,%esp
			break;
  8008c7:	e9 30 02 00 00       	jmp    800afc <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cf:	83 c0 04             	add    $0x4,%eax
  8008d2:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d8:	83 e8 04             	sub    $0x4,%eax
  8008db:	8b 30                	mov    (%eax),%esi
  8008dd:	85 f6                	test   %esi,%esi
  8008df:	75 05                	jne    8008e6 <vprintfmt+0x1a6>
				p = "(null)";
  8008e1:	be 11 38 80 00       	mov    $0x803811,%esi
			if (width > 0 && padc != '-')
  8008e6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ea:	7e 6d                	jle    800959 <vprintfmt+0x219>
  8008ec:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008f0:	74 67                	je     800959 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f5:	83 ec 08             	sub    $0x8,%esp
  8008f8:	50                   	push   %eax
  8008f9:	56                   	push   %esi
  8008fa:	e8 0c 03 00 00       	call   800c0b <strnlen>
  8008ff:	83 c4 10             	add    $0x10,%esp
  800902:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800905:	eb 16                	jmp    80091d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800907:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80090b:	83 ec 08             	sub    $0x8,%esp
  80090e:	ff 75 0c             	pushl  0xc(%ebp)
  800911:	50                   	push   %eax
  800912:	8b 45 08             	mov    0x8(%ebp),%eax
  800915:	ff d0                	call   *%eax
  800917:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80091a:	ff 4d e4             	decl   -0x1c(%ebp)
  80091d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800921:	7f e4                	jg     800907 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800923:	eb 34                	jmp    800959 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800925:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800929:	74 1c                	je     800947 <vprintfmt+0x207>
  80092b:	83 fb 1f             	cmp    $0x1f,%ebx
  80092e:	7e 05                	jle    800935 <vprintfmt+0x1f5>
  800930:	83 fb 7e             	cmp    $0x7e,%ebx
  800933:	7e 12                	jle    800947 <vprintfmt+0x207>
					putch('?', putdat);
  800935:	83 ec 08             	sub    $0x8,%esp
  800938:	ff 75 0c             	pushl  0xc(%ebp)
  80093b:	6a 3f                	push   $0x3f
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	ff d0                	call   *%eax
  800942:	83 c4 10             	add    $0x10,%esp
  800945:	eb 0f                	jmp    800956 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800947:	83 ec 08             	sub    $0x8,%esp
  80094a:	ff 75 0c             	pushl  0xc(%ebp)
  80094d:	53                   	push   %ebx
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	ff d0                	call   *%eax
  800953:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800956:	ff 4d e4             	decl   -0x1c(%ebp)
  800959:	89 f0                	mov    %esi,%eax
  80095b:	8d 70 01             	lea    0x1(%eax),%esi
  80095e:	8a 00                	mov    (%eax),%al
  800960:	0f be d8             	movsbl %al,%ebx
  800963:	85 db                	test   %ebx,%ebx
  800965:	74 24                	je     80098b <vprintfmt+0x24b>
  800967:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80096b:	78 b8                	js     800925 <vprintfmt+0x1e5>
  80096d:	ff 4d e0             	decl   -0x20(%ebp)
  800970:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800974:	79 af                	jns    800925 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800976:	eb 13                	jmp    80098b <vprintfmt+0x24b>
				putch(' ', putdat);
  800978:	83 ec 08             	sub    $0x8,%esp
  80097b:	ff 75 0c             	pushl  0xc(%ebp)
  80097e:	6a 20                	push   $0x20
  800980:	8b 45 08             	mov    0x8(%ebp),%eax
  800983:	ff d0                	call   *%eax
  800985:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800988:	ff 4d e4             	decl   -0x1c(%ebp)
  80098b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80098f:	7f e7                	jg     800978 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800991:	e9 66 01 00 00       	jmp    800afc <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800996:	83 ec 08             	sub    $0x8,%esp
  800999:	ff 75 e8             	pushl  -0x18(%ebp)
  80099c:	8d 45 14             	lea    0x14(%ebp),%eax
  80099f:	50                   	push   %eax
  8009a0:	e8 3c fd ff ff       	call   8006e1 <getint>
  8009a5:	83 c4 10             	add    $0x10,%esp
  8009a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ab:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009b4:	85 d2                	test   %edx,%edx
  8009b6:	79 23                	jns    8009db <vprintfmt+0x29b>
				putch('-', putdat);
  8009b8:	83 ec 08             	sub    $0x8,%esp
  8009bb:	ff 75 0c             	pushl  0xc(%ebp)
  8009be:	6a 2d                	push   $0x2d
  8009c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c3:	ff d0                	call   *%eax
  8009c5:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009ce:	f7 d8                	neg    %eax
  8009d0:	83 d2 00             	adc    $0x0,%edx
  8009d3:	f7 da                	neg    %edx
  8009d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009d8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009db:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009e2:	e9 bc 00 00 00       	jmp    800aa3 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009e7:	83 ec 08             	sub    $0x8,%esp
  8009ea:	ff 75 e8             	pushl  -0x18(%ebp)
  8009ed:	8d 45 14             	lea    0x14(%ebp),%eax
  8009f0:	50                   	push   %eax
  8009f1:	e8 84 fc ff ff       	call   80067a <getuint>
  8009f6:	83 c4 10             	add    $0x10,%esp
  8009f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009fc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009ff:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a06:	e9 98 00 00 00       	jmp    800aa3 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a0b:	83 ec 08             	sub    $0x8,%esp
  800a0e:	ff 75 0c             	pushl  0xc(%ebp)
  800a11:	6a 58                	push   $0x58
  800a13:	8b 45 08             	mov    0x8(%ebp),%eax
  800a16:	ff d0                	call   *%eax
  800a18:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a1b:	83 ec 08             	sub    $0x8,%esp
  800a1e:	ff 75 0c             	pushl  0xc(%ebp)
  800a21:	6a 58                	push   $0x58
  800a23:	8b 45 08             	mov    0x8(%ebp),%eax
  800a26:	ff d0                	call   *%eax
  800a28:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a2b:	83 ec 08             	sub    $0x8,%esp
  800a2e:	ff 75 0c             	pushl  0xc(%ebp)
  800a31:	6a 58                	push   $0x58
  800a33:	8b 45 08             	mov    0x8(%ebp),%eax
  800a36:	ff d0                	call   *%eax
  800a38:	83 c4 10             	add    $0x10,%esp
			break;
  800a3b:	e9 bc 00 00 00       	jmp    800afc <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a40:	83 ec 08             	sub    $0x8,%esp
  800a43:	ff 75 0c             	pushl  0xc(%ebp)
  800a46:	6a 30                	push   $0x30
  800a48:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4b:	ff d0                	call   *%eax
  800a4d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a50:	83 ec 08             	sub    $0x8,%esp
  800a53:	ff 75 0c             	pushl  0xc(%ebp)
  800a56:	6a 78                	push   $0x78
  800a58:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5b:	ff d0                	call   *%eax
  800a5d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a60:	8b 45 14             	mov    0x14(%ebp),%eax
  800a63:	83 c0 04             	add    $0x4,%eax
  800a66:	89 45 14             	mov    %eax,0x14(%ebp)
  800a69:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6c:	83 e8 04             	sub    $0x4,%eax
  800a6f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a71:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a74:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a7b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a82:	eb 1f                	jmp    800aa3 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a84:	83 ec 08             	sub    $0x8,%esp
  800a87:	ff 75 e8             	pushl  -0x18(%ebp)
  800a8a:	8d 45 14             	lea    0x14(%ebp),%eax
  800a8d:	50                   	push   %eax
  800a8e:	e8 e7 fb ff ff       	call   80067a <getuint>
  800a93:	83 c4 10             	add    $0x10,%esp
  800a96:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a99:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a9c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800aa3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800aa7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aaa:	83 ec 04             	sub    $0x4,%esp
  800aad:	52                   	push   %edx
  800aae:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ab1:	50                   	push   %eax
  800ab2:	ff 75 f4             	pushl  -0xc(%ebp)
  800ab5:	ff 75 f0             	pushl  -0x10(%ebp)
  800ab8:	ff 75 0c             	pushl  0xc(%ebp)
  800abb:	ff 75 08             	pushl  0x8(%ebp)
  800abe:	e8 00 fb ff ff       	call   8005c3 <printnum>
  800ac3:	83 c4 20             	add    $0x20,%esp
			break;
  800ac6:	eb 34                	jmp    800afc <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ac8:	83 ec 08             	sub    $0x8,%esp
  800acb:	ff 75 0c             	pushl  0xc(%ebp)
  800ace:	53                   	push   %ebx
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad2:	ff d0                	call   *%eax
  800ad4:	83 c4 10             	add    $0x10,%esp
			break;
  800ad7:	eb 23                	jmp    800afc <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ad9:	83 ec 08             	sub    $0x8,%esp
  800adc:	ff 75 0c             	pushl  0xc(%ebp)
  800adf:	6a 25                	push   $0x25
  800ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae4:	ff d0                	call   *%eax
  800ae6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ae9:	ff 4d 10             	decl   0x10(%ebp)
  800aec:	eb 03                	jmp    800af1 <vprintfmt+0x3b1>
  800aee:	ff 4d 10             	decl   0x10(%ebp)
  800af1:	8b 45 10             	mov    0x10(%ebp),%eax
  800af4:	48                   	dec    %eax
  800af5:	8a 00                	mov    (%eax),%al
  800af7:	3c 25                	cmp    $0x25,%al
  800af9:	75 f3                	jne    800aee <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800afb:	90                   	nop
		}
	}
  800afc:	e9 47 fc ff ff       	jmp    800748 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b01:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b02:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b05:	5b                   	pop    %ebx
  800b06:	5e                   	pop    %esi
  800b07:	5d                   	pop    %ebp
  800b08:	c3                   	ret    

00800b09 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b09:	55                   	push   %ebp
  800b0a:	89 e5                	mov    %esp,%ebp
  800b0c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b0f:	8d 45 10             	lea    0x10(%ebp),%eax
  800b12:	83 c0 04             	add    $0x4,%eax
  800b15:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b18:	8b 45 10             	mov    0x10(%ebp),%eax
  800b1b:	ff 75 f4             	pushl  -0xc(%ebp)
  800b1e:	50                   	push   %eax
  800b1f:	ff 75 0c             	pushl  0xc(%ebp)
  800b22:	ff 75 08             	pushl  0x8(%ebp)
  800b25:	e8 16 fc ff ff       	call   800740 <vprintfmt>
  800b2a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b2d:	90                   	nop
  800b2e:	c9                   	leave  
  800b2f:	c3                   	ret    

00800b30 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b30:	55                   	push   %ebp
  800b31:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b36:	8b 40 08             	mov    0x8(%eax),%eax
  800b39:	8d 50 01             	lea    0x1(%eax),%edx
  800b3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b45:	8b 10                	mov    (%eax),%edx
  800b47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4a:	8b 40 04             	mov    0x4(%eax),%eax
  800b4d:	39 c2                	cmp    %eax,%edx
  800b4f:	73 12                	jae    800b63 <sprintputch+0x33>
		*b->buf++ = ch;
  800b51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b54:	8b 00                	mov    (%eax),%eax
  800b56:	8d 48 01             	lea    0x1(%eax),%ecx
  800b59:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b5c:	89 0a                	mov    %ecx,(%edx)
  800b5e:	8b 55 08             	mov    0x8(%ebp),%edx
  800b61:	88 10                	mov    %dl,(%eax)
}
  800b63:	90                   	nop
  800b64:	5d                   	pop    %ebp
  800b65:	c3                   	ret    

00800b66 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b66:	55                   	push   %ebp
  800b67:	89 e5                	mov    %esp,%ebp
  800b69:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b75:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b78:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7b:	01 d0                	add    %edx,%eax
  800b7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b80:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b87:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b8b:	74 06                	je     800b93 <vsnprintf+0x2d>
  800b8d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b91:	7f 07                	jg     800b9a <vsnprintf+0x34>
		return -E_INVAL;
  800b93:	b8 03 00 00 00       	mov    $0x3,%eax
  800b98:	eb 20                	jmp    800bba <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b9a:	ff 75 14             	pushl  0x14(%ebp)
  800b9d:	ff 75 10             	pushl  0x10(%ebp)
  800ba0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ba3:	50                   	push   %eax
  800ba4:	68 30 0b 80 00       	push   $0x800b30
  800ba9:	e8 92 fb ff ff       	call   800740 <vprintfmt>
  800bae:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bb4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bba:	c9                   	leave  
  800bbb:	c3                   	ret    

00800bbc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bbc:	55                   	push   %ebp
  800bbd:	89 e5                	mov    %esp,%ebp
  800bbf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bc2:	8d 45 10             	lea    0x10(%ebp),%eax
  800bc5:	83 c0 04             	add    $0x4,%eax
  800bc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bcb:	8b 45 10             	mov    0x10(%ebp),%eax
  800bce:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd1:	50                   	push   %eax
  800bd2:	ff 75 0c             	pushl  0xc(%ebp)
  800bd5:	ff 75 08             	pushl  0x8(%ebp)
  800bd8:	e8 89 ff ff ff       	call   800b66 <vsnprintf>
  800bdd:	83 c4 10             	add    $0x10,%esp
  800be0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800be3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800be6:	c9                   	leave  
  800be7:	c3                   	ret    

00800be8 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
  800beb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bf5:	eb 06                	jmp    800bfd <strlen+0x15>
		n++;
  800bf7:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bfa:	ff 45 08             	incl   0x8(%ebp)
  800bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800c00:	8a 00                	mov    (%eax),%al
  800c02:	84 c0                	test   %al,%al
  800c04:	75 f1                	jne    800bf7 <strlen+0xf>
		n++;
	return n;
  800c06:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c09:	c9                   	leave  
  800c0a:	c3                   	ret    

00800c0b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c0b:	55                   	push   %ebp
  800c0c:	89 e5                	mov    %esp,%ebp
  800c0e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c11:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c18:	eb 09                	jmp    800c23 <strnlen+0x18>
		n++;
  800c1a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c1d:	ff 45 08             	incl   0x8(%ebp)
  800c20:	ff 4d 0c             	decl   0xc(%ebp)
  800c23:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c27:	74 09                	je     800c32 <strnlen+0x27>
  800c29:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2c:	8a 00                	mov    (%eax),%al
  800c2e:	84 c0                	test   %al,%al
  800c30:	75 e8                	jne    800c1a <strnlen+0xf>
		n++;
	return n;
  800c32:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c35:	c9                   	leave  
  800c36:	c3                   	ret    

00800c37 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c37:	55                   	push   %ebp
  800c38:	89 e5                	mov    %esp,%ebp
  800c3a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c40:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c43:	90                   	nop
  800c44:	8b 45 08             	mov    0x8(%ebp),%eax
  800c47:	8d 50 01             	lea    0x1(%eax),%edx
  800c4a:	89 55 08             	mov    %edx,0x8(%ebp)
  800c4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c50:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c53:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c56:	8a 12                	mov    (%edx),%dl
  800c58:	88 10                	mov    %dl,(%eax)
  800c5a:	8a 00                	mov    (%eax),%al
  800c5c:	84 c0                	test   %al,%al
  800c5e:	75 e4                	jne    800c44 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c60:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c63:	c9                   	leave  
  800c64:	c3                   	ret    

00800c65 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c65:	55                   	push   %ebp
  800c66:	89 e5                	mov    %esp,%ebp
  800c68:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c71:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c78:	eb 1f                	jmp    800c99 <strncpy+0x34>
		*dst++ = *src;
  800c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7d:	8d 50 01             	lea    0x1(%eax),%edx
  800c80:	89 55 08             	mov    %edx,0x8(%ebp)
  800c83:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c86:	8a 12                	mov    (%edx),%dl
  800c88:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8d:	8a 00                	mov    (%eax),%al
  800c8f:	84 c0                	test   %al,%al
  800c91:	74 03                	je     800c96 <strncpy+0x31>
			src++;
  800c93:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c96:	ff 45 fc             	incl   -0x4(%ebp)
  800c99:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c9c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c9f:	72 d9                	jb     800c7a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ca1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ca4:	c9                   	leave  
  800ca5:	c3                   	ret    

00800ca6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ca6:	55                   	push   %ebp
  800ca7:	89 e5                	mov    %esp,%ebp
  800ca9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cac:	8b 45 08             	mov    0x8(%ebp),%eax
  800caf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cb2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cb6:	74 30                	je     800ce8 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cb8:	eb 16                	jmp    800cd0 <strlcpy+0x2a>
			*dst++ = *src++;
  800cba:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbd:	8d 50 01             	lea    0x1(%eax),%edx
  800cc0:	89 55 08             	mov    %edx,0x8(%ebp)
  800cc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cc6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cc9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ccc:	8a 12                	mov    (%edx),%dl
  800cce:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cd0:	ff 4d 10             	decl   0x10(%ebp)
  800cd3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cd7:	74 09                	je     800ce2 <strlcpy+0x3c>
  800cd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cdc:	8a 00                	mov    (%eax),%al
  800cde:	84 c0                	test   %al,%al
  800ce0:	75 d8                	jne    800cba <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ce8:	8b 55 08             	mov    0x8(%ebp),%edx
  800ceb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cee:	29 c2                	sub    %eax,%edx
  800cf0:	89 d0                	mov    %edx,%eax
}
  800cf2:	c9                   	leave  
  800cf3:	c3                   	ret    

00800cf4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cf4:	55                   	push   %ebp
  800cf5:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cf7:	eb 06                	jmp    800cff <strcmp+0xb>
		p++, q++;
  800cf9:	ff 45 08             	incl   0x8(%ebp)
  800cfc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cff:	8b 45 08             	mov    0x8(%ebp),%eax
  800d02:	8a 00                	mov    (%eax),%al
  800d04:	84 c0                	test   %al,%al
  800d06:	74 0e                	je     800d16 <strcmp+0x22>
  800d08:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0b:	8a 10                	mov    (%eax),%dl
  800d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d10:	8a 00                	mov    (%eax),%al
  800d12:	38 c2                	cmp    %al,%dl
  800d14:	74 e3                	je     800cf9 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d16:	8b 45 08             	mov    0x8(%ebp),%eax
  800d19:	8a 00                	mov    (%eax),%al
  800d1b:	0f b6 d0             	movzbl %al,%edx
  800d1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d21:	8a 00                	mov    (%eax),%al
  800d23:	0f b6 c0             	movzbl %al,%eax
  800d26:	29 c2                	sub    %eax,%edx
  800d28:	89 d0                	mov    %edx,%eax
}
  800d2a:	5d                   	pop    %ebp
  800d2b:	c3                   	ret    

00800d2c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d2c:	55                   	push   %ebp
  800d2d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d2f:	eb 09                	jmp    800d3a <strncmp+0xe>
		n--, p++, q++;
  800d31:	ff 4d 10             	decl   0x10(%ebp)
  800d34:	ff 45 08             	incl   0x8(%ebp)
  800d37:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d3a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d3e:	74 17                	je     800d57 <strncmp+0x2b>
  800d40:	8b 45 08             	mov    0x8(%ebp),%eax
  800d43:	8a 00                	mov    (%eax),%al
  800d45:	84 c0                	test   %al,%al
  800d47:	74 0e                	je     800d57 <strncmp+0x2b>
  800d49:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4c:	8a 10                	mov    (%eax),%dl
  800d4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d51:	8a 00                	mov    (%eax),%al
  800d53:	38 c2                	cmp    %al,%dl
  800d55:	74 da                	je     800d31 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d57:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5b:	75 07                	jne    800d64 <strncmp+0x38>
		return 0;
  800d5d:	b8 00 00 00 00       	mov    $0x0,%eax
  800d62:	eb 14                	jmp    800d78 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d64:	8b 45 08             	mov    0x8(%ebp),%eax
  800d67:	8a 00                	mov    (%eax),%al
  800d69:	0f b6 d0             	movzbl %al,%edx
  800d6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6f:	8a 00                	mov    (%eax),%al
  800d71:	0f b6 c0             	movzbl %al,%eax
  800d74:	29 c2                	sub    %eax,%edx
  800d76:	89 d0                	mov    %edx,%eax
}
  800d78:	5d                   	pop    %ebp
  800d79:	c3                   	ret    

00800d7a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d7a:	55                   	push   %ebp
  800d7b:	89 e5                	mov    %esp,%ebp
  800d7d:	83 ec 04             	sub    $0x4,%esp
  800d80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d83:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d86:	eb 12                	jmp    800d9a <strchr+0x20>
		if (*s == c)
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	8a 00                	mov    (%eax),%al
  800d8d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d90:	75 05                	jne    800d97 <strchr+0x1d>
			return (char *) s;
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	eb 11                	jmp    800da8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d97:	ff 45 08             	incl   0x8(%ebp)
  800d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9d:	8a 00                	mov    (%eax),%al
  800d9f:	84 c0                	test   %al,%al
  800da1:	75 e5                	jne    800d88 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800da3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800da8:	c9                   	leave  
  800da9:	c3                   	ret    

00800daa <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
  800dad:	83 ec 04             	sub    $0x4,%esp
  800db0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800db6:	eb 0d                	jmp    800dc5 <strfind+0x1b>
		if (*s == c)
  800db8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbb:	8a 00                	mov    (%eax),%al
  800dbd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dc0:	74 0e                	je     800dd0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dc2:	ff 45 08             	incl   0x8(%ebp)
  800dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc8:	8a 00                	mov    (%eax),%al
  800dca:	84 c0                	test   %al,%al
  800dcc:	75 ea                	jne    800db8 <strfind+0xe>
  800dce:	eb 01                	jmp    800dd1 <strfind+0x27>
		if (*s == c)
			break;
  800dd0:	90                   	nop
	return (char *) s;
  800dd1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dd4:	c9                   	leave  
  800dd5:	c3                   	ret    

00800dd6 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800dd6:	55                   	push   %ebp
  800dd7:	89 e5                	mov    %esp,%ebp
  800dd9:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800de2:	8b 45 10             	mov    0x10(%ebp),%eax
  800de5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800de8:	eb 0e                	jmp    800df8 <memset+0x22>
		*p++ = c;
  800dea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ded:	8d 50 01             	lea    0x1(%eax),%edx
  800df0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800df3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800df6:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800df8:	ff 4d f8             	decl   -0x8(%ebp)
  800dfb:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dff:	79 e9                	jns    800dea <memset+0x14>
		*p++ = c;

	return v;
  800e01:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e04:	c9                   	leave  
  800e05:	c3                   	ret    

00800e06 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e06:	55                   	push   %ebp
  800e07:	89 e5                	mov    %esp,%ebp
  800e09:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e12:	8b 45 08             	mov    0x8(%ebp),%eax
  800e15:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e18:	eb 16                	jmp    800e30 <memcpy+0x2a>
		*d++ = *s++;
  800e1a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e1d:	8d 50 01             	lea    0x1(%eax),%edx
  800e20:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e23:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e26:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e29:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e2c:	8a 12                	mov    (%edx),%dl
  800e2e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e30:	8b 45 10             	mov    0x10(%ebp),%eax
  800e33:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e36:	89 55 10             	mov    %edx,0x10(%ebp)
  800e39:	85 c0                	test   %eax,%eax
  800e3b:	75 dd                	jne    800e1a <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e3d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e40:	c9                   	leave  
  800e41:	c3                   	ret    

00800e42 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e42:	55                   	push   %ebp
  800e43:	89 e5                	mov    %esp,%ebp
  800e45:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e51:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e54:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e57:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e5a:	73 50                	jae    800eac <memmove+0x6a>
  800e5c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e5f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e62:	01 d0                	add    %edx,%eax
  800e64:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e67:	76 43                	jbe    800eac <memmove+0x6a>
		s += n;
  800e69:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e6f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e72:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e75:	eb 10                	jmp    800e87 <memmove+0x45>
			*--d = *--s;
  800e77:	ff 4d f8             	decl   -0x8(%ebp)
  800e7a:	ff 4d fc             	decl   -0x4(%ebp)
  800e7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e80:	8a 10                	mov    (%eax),%dl
  800e82:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e85:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e87:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e8d:	89 55 10             	mov    %edx,0x10(%ebp)
  800e90:	85 c0                	test   %eax,%eax
  800e92:	75 e3                	jne    800e77 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e94:	eb 23                	jmp    800eb9 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e96:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e99:	8d 50 01             	lea    0x1(%eax),%edx
  800e9c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e9f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ea2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ea5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ea8:	8a 12                	mov    (%edx),%dl
  800eaa:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800eac:	8b 45 10             	mov    0x10(%ebp),%eax
  800eaf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eb2:	89 55 10             	mov    %edx,0x10(%ebp)
  800eb5:	85 c0                	test   %eax,%eax
  800eb7:	75 dd                	jne    800e96 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800eb9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ebc:	c9                   	leave  
  800ebd:	c3                   	ret    

00800ebe <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ebe:	55                   	push   %ebp
  800ebf:	89 e5                	mov    %esp,%ebp
  800ec1:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800eca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecd:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ed0:	eb 2a                	jmp    800efc <memcmp+0x3e>
		if (*s1 != *s2)
  800ed2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed5:	8a 10                	mov    (%eax),%dl
  800ed7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eda:	8a 00                	mov    (%eax),%al
  800edc:	38 c2                	cmp    %al,%dl
  800ede:	74 16                	je     800ef6 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ee0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee3:	8a 00                	mov    (%eax),%al
  800ee5:	0f b6 d0             	movzbl %al,%edx
  800ee8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eeb:	8a 00                	mov    (%eax),%al
  800eed:	0f b6 c0             	movzbl %al,%eax
  800ef0:	29 c2                	sub    %eax,%edx
  800ef2:	89 d0                	mov    %edx,%eax
  800ef4:	eb 18                	jmp    800f0e <memcmp+0x50>
		s1++, s2++;
  800ef6:	ff 45 fc             	incl   -0x4(%ebp)
  800ef9:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800efc:	8b 45 10             	mov    0x10(%ebp),%eax
  800eff:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f02:	89 55 10             	mov    %edx,0x10(%ebp)
  800f05:	85 c0                	test   %eax,%eax
  800f07:	75 c9                	jne    800ed2 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f09:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f0e:	c9                   	leave  
  800f0f:	c3                   	ret    

00800f10 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f10:	55                   	push   %ebp
  800f11:	89 e5                	mov    %esp,%ebp
  800f13:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f16:	8b 55 08             	mov    0x8(%ebp),%edx
  800f19:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1c:	01 d0                	add    %edx,%eax
  800f1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f21:	eb 15                	jmp    800f38 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f23:	8b 45 08             	mov    0x8(%ebp),%eax
  800f26:	8a 00                	mov    (%eax),%al
  800f28:	0f b6 d0             	movzbl %al,%edx
  800f2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2e:	0f b6 c0             	movzbl %al,%eax
  800f31:	39 c2                	cmp    %eax,%edx
  800f33:	74 0d                	je     800f42 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f35:	ff 45 08             	incl   0x8(%ebp)
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f3e:	72 e3                	jb     800f23 <memfind+0x13>
  800f40:	eb 01                	jmp    800f43 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f42:	90                   	nop
	return (void *) s;
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f46:	c9                   	leave  
  800f47:	c3                   	ret    

00800f48 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f48:	55                   	push   %ebp
  800f49:	89 e5                	mov    %esp,%ebp
  800f4b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f4e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f55:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f5c:	eb 03                	jmp    800f61 <strtol+0x19>
		s++;
  800f5e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f61:	8b 45 08             	mov    0x8(%ebp),%eax
  800f64:	8a 00                	mov    (%eax),%al
  800f66:	3c 20                	cmp    $0x20,%al
  800f68:	74 f4                	je     800f5e <strtol+0x16>
  800f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6d:	8a 00                	mov    (%eax),%al
  800f6f:	3c 09                	cmp    $0x9,%al
  800f71:	74 eb                	je     800f5e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f73:	8b 45 08             	mov    0x8(%ebp),%eax
  800f76:	8a 00                	mov    (%eax),%al
  800f78:	3c 2b                	cmp    $0x2b,%al
  800f7a:	75 05                	jne    800f81 <strtol+0x39>
		s++;
  800f7c:	ff 45 08             	incl   0x8(%ebp)
  800f7f:	eb 13                	jmp    800f94 <strtol+0x4c>
	else if (*s == '-')
  800f81:	8b 45 08             	mov    0x8(%ebp),%eax
  800f84:	8a 00                	mov    (%eax),%al
  800f86:	3c 2d                	cmp    $0x2d,%al
  800f88:	75 0a                	jne    800f94 <strtol+0x4c>
		s++, neg = 1;
  800f8a:	ff 45 08             	incl   0x8(%ebp)
  800f8d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f94:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f98:	74 06                	je     800fa0 <strtol+0x58>
  800f9a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f9e:	75 20                	jne    800fc0 <strtol+0x78>
  800fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa3:	8a 00                	mov    (%eax),%al
  800fa5:	3c 30                	cmp    $0x30,%al
  800fa7:	75 17                	jne    800fc0 <strtol+0x78>
  800fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fac:	40                   	inc    %eax
  800fad:	8a 00                	mov    (%eax),%al
  800faf:	3c 78                	cmp    $0x78,%al
  800fb1:	75 0d                	jne    800fc0 <strtol+0x78>
		s += 2, base = 16;
  800fb3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fb7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fbe:	eb 28                	jmp    800fe8 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fc0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fc4:	75 15                	jne    800fdb <strtol+0x93>
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc9:	8a 00                	mov    (%eax),%al
  800fcb:	3c 30                	cmp    $0x30,%al
  800fcd:	75 0c                	jne    800fdb <strtol+0x93>
		s++, base = 8;
  800fcf:	ff 45 08             	incl   0x8(%ebp)
  800fd2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fd9:	eb 0d                	jmp    800fe8 <strtol+0xa0>
	else if (base == 0)
  800fdb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fdf:	75 07                	jne    800fe8 <strtol+0xa0>
		base = 10;
  800fe1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  800feb:	8a 00                	mov    (%eax),%al
  800fed:	3c 2f                	cmp    $0x2f,%al
  800fef:	7e 19                	jle    80100a <strtol+0xc2>
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff4:	8a 00                	mov    (%eax),%al
  800ff6:	3c 39                	cmp    $0x39,%al
  800ff8:	7f 10                	jg     80100a <strtol+0xc2>
			dig = *s - '0';
  800ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffd:	8a 00                	mov    (%eax),%al
  800fff:	0f be c0             	movsbl %al,%eax
  801002:	83 e8 30             	sub    $0x30,%eax
  801005:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801008:	eb 42                	jmp    80104c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80100a:	8b 45 08             	mov    0x8(%ebp),%eax
  80100d:	8a 00                	mov    (%eax),%al
  80100f:	3c 60                	cmp    $0x60,%al
  801011:	7e 19                	jle    80102c <strtol+0xe4>
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
  801016:	8a 00                	mov    (%eax),%al
  801018:	3c 7a                	cmp    $0x7a,%al
  80101a:	7f 10                	jg     80102c <strtol+0xe4>
			dig = *s - 'a' + 10;
  80101c:	8b 45 08             	mov    0x8(%ebp),%eax
  80101f:	8a 00                	mov    (%eax),%al
  801021:	0f be c0             	movsbl %al,%eax
  801024:	83 e8 57             	sub    $0x57,%eax
  801027:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80102a:	eb 20                	jmp    80104c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80102c:	8b 45 08             	mov    0x8(%ebp),%eax
  80102f:	8a 00                	mov    (%eax),%al
  801031:	3c 40                	cmp    $0x40,%al
  801033:	7e 39                	jle    80106e <strtol+0x126>
  801035:	8b 45 08             	mov    0x8(%ebp),%eax
  801038:	8a 00                	mov    (%eax),%al
  80103a:	3c 5a                	cmp    $0x5a,%al
  80103c:	7f 30                	jg     80106e <strtol+0x126>
			dig = *s - 'A' + 10;
  80103e:	8b 45 08             	mov    0x8(%ebp),%eax
  801041:	8a 00                	mov    (%eax),%al
  801043:	0f be c0             	movsbl %al,%eax
  801046:	83 e8 37             	sub    $0x37,%eax
  801049:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80104c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80104f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801052:	7d 19                	jge    80106d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801054:	ff 45 08             	incl   0x8(%ebp)
  801057:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80105a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80105e:	89 c2                	mov    %eax,%edx
  801060:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801063:	01 d0                	add    %edx,%eax
  801065:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801068:	e9 7b ff ff ff       	jmp    800fe8 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80106d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80106e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801072:	74 08                	je     80107c <strtol+0x134>
		*endptr = (char *) s;
  801074:	8b 45 0c             	mov    0xc(%ebp),%eax
  801077:	8b 55 08             	mov    0x8(%ebp),%edx
  80107a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80107c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801080:	74 07                	je     801089 <strtol+0x141>
  801082:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801085:	f7 d8                	neg    %eax
  801087:	eb 03                	jmp    80108c <strtol+0x144>
  801089:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80108c:	c9                   	leave  
  80108d:	c3                   	ret    

0080108e <ltostr>:

void
ltostr(long value, char *str)
{
  80108e:	55                   	push   %ebp
  80108f:	89 e5                	mov    %esp,%ebp
  801091:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801094:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80109b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010a6:	79 13                	jns    8010bb <ltostr+0x2d>
	{
		neg = 1;
  8010a8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b2:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010b5:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010b8:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010be:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010c3:	99                   	cltd   
  8010c4:	f7 f9                	idiv   %ecx
  8010c6:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010cc:	8d 50 01             	lea    0x1(%eax),%edx
  8010cf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010d2:	89 c2                	mov    %eax,%edx
  8010d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d7:	01 d0                	add    %edx,%eax
  8010d9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010dc:	83 c2 30             	add    $0x30,%edx
  8010df:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010e4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010e9:	f7 e9                	imul   %ecx
  8010eb:	c1 fa 02             	sar    $0x2,%edx
  8010ee:	89 c8                	mov    %ecx,%eax
  8010f0:	c1 f8 1f             	sar    $0x1f,%eax
  8010f3:	29 c2                	sub    %eax,%edx
  8010f5:	89 d0                	mov    %edx,%eax
  8010f7:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010fd:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801102:	f7 e9                	imul   %ecx
  801104:	c1 fa 02             	sar    $0x2,%edx
  801107:	89 c8                	mov    %ecx,%eax
  801109:	c1 f8 1f             	sar    $0x1f,%eax
  80110c:	29 c2                	sub    %eax,%edx
  80110e:	89 d0                	mov    %edx,%eax
  801110:	c1 e0 02             	shl    $0x2,%eax
  801113:	01 d0                	add    %edx,%eax
  801115:	01 c0                	add    %eax,%eax
  801117:	29 c1                	sub    %eax,%ecx
  801119:	89 ca                	mov    %ecx,%edx
  80111b:	85 d2                	test   %edx,%edx
  80111d:	75 9c                	jne    8010bb <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80111f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801126:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801129:	48                   	dec    %eax
  80112a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80112d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801131:	74 3d                	je     801170 <ltostr+0xe2>
		start = 1 ;
  801133:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80113a:	eb 34                	jmp    801170 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80113c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80113f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801142:	01 d0                	add    %edx,%eax
  801144:	8a 00                	mov    (%eax),%al
  801146:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801149:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80114c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114f:	01 c2                	add    %eax,%edx
  801151:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801154:	8b 45 0c             	mov    0xc(%ebp),%eax
  801157:	01 c8                	add    %ecx,%eax
  801159:	8a 00                	mov    (%eax),%al
  80115b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80115d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801160:	8b 45 0c             	mov    0xc(%ebp),%eax
  801163:	01 c2                	add    %eax,%edx
  801165:	8a 45 eb             	mov    -0x15(%ebp),%al
  801168:	88 02                	mov    %al,(%edx)
		start++ ;
  80116a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80116d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801170:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801173:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801176:	7c c4                	jl     80113c <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801178:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80117b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117e:	01 d0                	add    %edx,%eax
  801180:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801183:	90                   	nop
  801184:	c9                   	leave  
  801185:	c3                   	ret    

00801186 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801186:	55                   	push   %ebp
  801187:	89 e5                	mov    %esp,%ebp
  801189:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80118c:	ff 75 08             	pushl  0x8(%ebp)
  80118f:	e8 54 fa ff ff       	call   800be8 <strlen>
  801194:	83 c4 04             	add    $0x4,%esp
  801197:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80119a:	ff 75 0c             	pushl  0xc(%ebp)
  80119d:	e8 46 fa ff ff       	call   800be8 <strlen>
  8011a2:	83 c4 04             	add    $0x4,%esp
  8011a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011b6:	eb 17                	jmp    8011cf <strcconcat+0x49>
		final[s] = str1[s] ;
  8011b8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8011be:	01 c2                	add    %eax,%edx
  8011c0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c6:	01 c8                	add    %ecx,%eax
  8011c8:	8a 00                	mov    (%eax),%al
  8011ca:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011cc:	ff 45 fc             	incl   -0x4(%ebp)
  8011cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011d5:	7c e1                	jl     8011b8 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011d7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011de:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011e5:	eb 1f                	jmp    801206 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ea:	8d 50 01             	lea    0x1(%eax),%edx
  8011ed:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011f0:	89 c2                	mov    %eax,%edx
  8011f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f5:	01 c2                	add    %eax,%edx
  8011f7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fd:	01 c8                	add    %ecx,%eax
  8011ff:	8a 00                	mov    (%eax),%al
  801201:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801203:	ff 45 f8             	incl   -0x8(%ebp)
  801206:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801209:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80120c:	7c d9                	jl     8011e7 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80120e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801211:	8b 45 10             	mov    0x10(%ebp),%eax
  801214:	01 d0                	add    %edx,%eax
  801216:	c6 00 00             	movb   $0x0,(%eax)
}
  801219:	90                   	nop
  80121a:	c9                   	leave  
  80121b:	c3                   	ret    

0080121c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80121c:	55                   	push   %ebp
  80121d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80121f:	8b 45 14             	mov    0x14(%ebp),%eax
  801222:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801228:	8b 45 14             	mov    0x14(%ebp),%eax
  80122b:	8b 00                	mov    (%eax),%eax
  80122d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801234:	8b 45 10             	mov    0x10(%ebp),%eax
  801237:	01 d0                	add    %edx,%eax
  801239:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80123f:	eb 0c                	jmp    80124d <strsplit+0x31>
			*string++ = 0;
  801241:	8b 45 08             	mov    0x8(%ebp),%eax
  801244:	8d 50 01             	lea    0x1(%eax),%edx
  801247:	89 55 08             	mov    %edx,0x8(%ebp)
  80124a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80124d:	8b 45 08             	mov    0x8(%ebp),%eax
  801250:	8a 00                	mov    (%eax),%al
  801252:	84 c0                	test   %al,%al
  801254:	74 18                	je     80126e <strsplit+0x52>
  801256:	8b 45 08             	mov    0x8(%ebp),%eax
  801259:	8a 00                	mov    (%eax),%al
  80125b:	0f be c0             	movsbl %al,%eax
  80125e:	50                   	push   %eax
  80125f:	ff 75 0c             	pushl  0xc(%ebp)
  801262:	e8 13 fb ff ff       	call   800d7a <strchr>
  801267:	83 c4 08             	add    $0x8,%esp
  80126a:	85 c0                	test   %eax,%eax
  80126c:	75 d3                	jne    801241 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80126e:	8b 45 08             	mov    0x8(%ebp),%eax
  801271:	8a 00                	mov    (%eax),%al
  801273:	84 c0                	test   %al,%al
  801275:	74 5a                	je     8012d1 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801277:	8b 45 14             	mov    0x14(%ebp),%eax
  80127a:	8b 00                	mov    (%eax),%eax
  80127c:	83 f8 0f             	cmp    $0xf,%eax
  80127f:	75 07                	jne    801288 <strsplit+0x6c>
		{
			return 0;
  801281:	b8 00 00 00 00       	mov    $0x0,%eax
  801286:	eb 66                	jmp    8012ee <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801288:	8b 45 14             	mov    0x14(%ebp),%eax
  80128b:	8b 00                	mov    (%eax),%eax
  80128d:	8d 48 01             	lea    0x1(%eax),%ecx
  801290:	8b 55 14             	mov    0x14(%ebp),%edx
  801293:	89 0a                	mov    %ecx,(%edx)
  801295:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80129c:	8b 45 10             	mov    0x10(%ebp),%eax
  80129f:	01 c2                	add    %eax,%edx
  8012a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a4:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012a6:	eb 03                	jmp    8012ab <strsplit+0x8f>
			string++;
  8012a8:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ae:	8a 00                	mov    (%eax),%al
  8012b0:	84 c0                	test   %al,%al
  8012b2:	74 8b                	je     80123f <strsplit+0x23>
  8012b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b7:	8a 00                	mov    (%eax),%al
  8012b9:	0f be c0             	movsbl %al,%eax
  8012bc:	50                   	push   %eax
  8012bd:	ff 75 0c             	pushl  0xc(%ebp)
  8012c0:	e8 b5 fa ff ff       	call   800d7a <strchr>
  8012c5:	83 c4 08             	add    $0x8,%esp
  8012c8:	85 c0                	test   %eax,%eax
  8012ca:	74 dc                	je     8012a8 <strsplit+0x8c>
			string++;
	}
  8012cc:	e9 6e ff ff ff       	jmp    80123f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012d1:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d5:	8b 00                	mov    (%eax),%eax
  8012d7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012de:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e1:	01 d0                	add    %edx,%eax
  8012e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012e9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012ee:	c9                   	leave  
  8012ef:	c3                   	ret    

008012f0 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012f0:	55                   	push   %ebp
  8012f1:	89 e5                	mov    %esp,%ebp
  8012f3:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8012f6:	a1 04 40 80 00       	mov    0x804004,%eax
  8012fb:	85 c0                	test   %eax,%eax
  8012fd:	74 1f                	je     80131e <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8012ff:	e8 1d 00 00 00       	call   801321 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801304:	83 ec 0c             	sub    $0xc,%esp
  801307:	68 70 39 80 00       	push   $0x803970
  80130c:	e8 55 f2 ff ff       	call   800566 <cprintf>
  801311:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801314:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80131b:	00 00 00 
	}
}
  80131e:	90                   	nop
  80131f:	c9                   	leave  
  801320:	c3                   	ret    

00801321 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801321:	55                   	push   %ebp
  801322:	89 e5                	mov    %esp,%ebp
  801324:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801327:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80132e:	00 00 00 
  801331:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801338:	00 00 00 
  80133b:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801342:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  801345:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80134c:	00 00 00 
  80134f:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801356:	00 00 00 
  801359:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801360:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801363:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  80136a:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  80136d:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801374:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801377:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80137c:	2d 00 10 00 00       	sub    $0x1000,%eax
  801381:	a3 50 40 80 00       	mov    %eax,0x804050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  801386:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80138d:	a1 20 41 80 00       	mov    0x804120,%eax
  801392:	c1 e0 04             	shl    $0x4,%eax
  801395:	89 c2                	mov    %eax,%edx
  801397:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80139a:	01 d0                	add    %edx,%eax
  80139c:	48                   	dec    %eax
  80139d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8013a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8013a8:	f7 75 f0             	divl   -0x10(%ebp)
  8013ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013ae:	29 d0                	sub    %edx,%eax
  8013b0:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  8013b3:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8013ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013bd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013c2:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013c7:	83 ec 04             	sub    $0x4,%esp
  8013ca:	6a 06                	push   $0x6
  8013cc:	ff 75 e8             	pushl  -0x18(%ebp)
  8013cf:	50                   	push   %eax
  8013d0:	e8 b0 05 00 00       	call   801985 <sys_allocate_chunk>
  8013d5:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013d8:	a1 20 41 80 00       	mov    0x804120,%eax
  8013dd:	83 ec 0c             	sub    $0xc,%esp
  8013e0:	50                   	push   %eax
  8013e1:	e8 25 0c 00 00       	call   80200b <initialize_MemBlocksList>
  8013e6:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  8013e9:	a1 48 41 80 00       	mov    0x804148,%eax
  8013ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  8013f1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013f5:	75 14                	jne    80140b <initialize_dyn_block_system+0xea>
  8013f7:	83 ec 04             	sub    $0x4,%esp
  8013fa:	68 95 39 80 00       	push   $0x803995
  8013ff:	6a 29                	push   $0x29
  801401:	68 b3 39 80 00       	push   $0x8039b3
  801406:	e8 43 1c 00 00       	call   80304e <_panic>
  80140b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80140e:	8b 00                	mov    (%eax),%eax
  801410:	85 c0                	test   %eax,%eax
  801412:	74 10                	je     801424 <initialize_dyn_block_system+0x103>
  801414:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801417:	8b 00                	mov    (%eax),%eax
  801419:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80141c:	8b 52 04             	mov    0x4(%edx),%edx
  80141f:	89 50 04             	mov    %edx,0x4(%eax)
  801422:	eb 0b                	jmp    80142f <initialize_dyn_block_system+0x10e>
  801424:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801427:	8b 40 04             	mov    0x4(%eax),%eax
  80142a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80142f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801432:	8b 40 04             	mov    0x4(%eax),%eax
  801435:	85 c0                	test   %eax,%eax
  801437:	74 0f                	je     801448 <initialize_dyn_block_system+0x127>
  801439:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80143c:	8b 40 04             	mov    0x4(%eax),%eax
  80143f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801442:	8b 12                	mov    (%edx),%edx
  801444:	89 10                	mov    %edx,(%eax)
  801446:	eb 0a                	jmp    801452 <initialize_dyn_block_system+0x131>
  801448:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80144b:	8b 00                	mov    (%eax),%eax
  80144d:	a3 48 41 80 00       	mov    %eax,0x804148
  801452:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801455:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80145b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80145e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801465:	a1 54 41 80 00       	mov    0x804154,%eax
  80146a:	48                   	dec    %eax
  80146b:	a3 54 41 80 00       	mov    %eax,0x804154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  801470:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801473:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  80147a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80147d:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  801484:	83 ec 0c             	sub    $0xc,%esp
  801487:	ff 75 e0             	pushl  -0x20(%ebp)
  80148a:	e8 b9 14 00 00       	call   802948 <insert_sorted_with_merge_freeList>
  80148f:	83 c4 10             	add    $0x10,%esp

}
  801492:	90                   	nop
  801493:	c9                   	leave  
  801494:	c3                   	ret    

00801495 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801495:	55                   	push   %ebp
  801496:	89 e5                	mov    %esp,%ebp
  801498:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80149b:	e8 50 fe ff ff       	call   8012f0 <InitializeUHeap>
	if (size == 0) return NULL ;
  8014a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014a4:	75 07                	jne    8014ad <malloc+0x18>
  8014a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ab:	eb 68                	jmp    801515 <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  8014ad:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8014b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8014b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ba:	01 d0                	add    %edx,%eax
  8014bc:	48                   	dec    %eax
  8014bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8014c8:	f7 75 f4             	divl   -0xc(%ebp)
  8014cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ce:	29 d0                	sub    %edx,%eax
  8014d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  8014d3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8014da:	e8 74 08 00 00       	call   801d53 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014df:	85 c0                	test   %eax,%eax
  8014e1:	74 2d                	je     801510 <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  8014e3:	83 ec 0c             	sub    $0xc,%esp
  8014e6:	ff 75 ec             	pushl  -0x14(%ebp)
  8014e9:	e8 52 0e 00 00       	call   802340 <alloc_block_FF>
  8014ee:	83 c4 10             	add    $0x10,%esp
  8014f1:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  8014f4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8014f8:	74 16                	je     801510 <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  8014fa:	83 ec 0c             	sub    $0xc,%esp
  8014fd:	ff 75 e8             	pushl  -0x18(%ebp)
  801500:	e8 3b 0c 00 00       	call   802140 <insert_sorted_allocList>
  801505:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  801508:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80150b:	8b 40 08             	mov    0x8(%eax),%eax
  80150e:	eb 05                	jmp    801515 <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  801510:	b8 00 00 00 00       	mov    $0x0,%eax

}
  801515:	c9                   	leave  
  801516:	c3                   	ret    

00801517 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801517:	55                   	push   %ebp
  801518:	89 e5                	mov    %esp,%ebp
  80151a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  80151d:	8b 45 08             	mov    0x8(%ebp),%eax
  801520:	83 ec 08             	sub    $0x8,%esp
  801523:	50                   	push   %eax
  801524:	68 40 40 80 00       	push   $0x804040
  801529:	e8 ba 0b 00 00       	call   8020e8 <find_block>
  80152e:	83 c4 10             	add    $0x10,%esp
  801531:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  801534:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801537:	8b 40 0c             	mov    0xc(%eax),%eax
  80153a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  80153d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801541:	0f 84 9f 00 00 00    	je     8015e6 <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  801547:	8b 45 08             	mov    0x8(%ebp),%eax
  80154a:	83 ec 08             	sub    $0x8,%esp
  80154d:	ff 75 f0             	pushl  -0x10(%ebp)
  801550:	50                   	push   %eax
  801551:	e8 f7 03 00 00       	call   80194d <sys_free_user_mem>
  801556:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  801559:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80155d:	75 14                	jne    801573 <free+0x5c>
  80155f:	83 ec 04             	sub    $0x4,%esp
  801562:	68 95 39 80 00       	push   $0x803995
  801567:	6a 6a                	push   $0x6a
  801569:	68 b3 39 80 00       	push   $0x8039b3
  80156e:	e8 db 1a 00 00       	call   80304e <_panic>
  801573:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801576:	8b 00                	mov    (%eax),%eax
  801578:	85 c0                	test   %eax,%eax
  80157a:	74 10                	je     80158c <free+0x75>
  80157c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80157f:	8b 00                	mov    (%eax),%eax
  801581:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801584:	8b 52 04             	mov    0x4(%edx),%edx
  801587:	89 50 04             	mov    %edx,0x4(%eax)
  80158a:	eb 0b                	jmp    801597 <free+0x80>
  80158c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80158f:	8b 40 04             	mov    0x4(%eax),%eax
  801592:	a3 44 40 80 00       	mov    %eax,0x804044
  801597:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80159a:	8b 40 04             	mov    0x4(%eax),%eax
  80159d:	85 c0                	test   %eax,%eax
  80159f:	74 0f                	je     8015b0 <free+0x99>
  8015a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a4:	8b 40 04             	mov    0x4(%eax),%eax
  8015a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015aa:	8b 12                	mov    (%edx),%edx
  8015ac:	89 10                	mov    %edx,(%eax)
  8015ae:	eb 0a                	jmp    8015ba <free+0xa3>
  8015b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b3:	8b 00                	mov    (%eax),%eax
  8015b5:	a3 40 40 80 00       	mov    %eax,0x804040
  8015ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8015c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015cd:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8015d2:	48                   	dec    %eax
  8015d3:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(blk);
  8015d8:	83 ec 0c             	sub    $0xc,%esp
  8015db:	ff 75 f4             	pushl  -0xc(%ebp)
  8015de:	e8 65 13 00 00       	call   802948 <insert_sorted_with_merge_freeList>
  8015e3:	83 c4 10             	add    $0x10,%esp
	}
}
  8015e6:	90                   	nop
  8015e7:	c9                   	leave  
  8015e8:	c3                   	ret    

008015e9 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015e9:	55                   	push   %ebp
  8015ea:	89 e5                	mov    %esp,%ebp
  8015ec:	83 ec 28             	sub    $0x28,%esp
  8015ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f2:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015f5:	e8 f6 fc ff ff       	call   8012f0 <InitializeUHeap>
	if (size == 0) return NULL ;
  8015fa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015fe:	75 0a                	jne    80160a <smalloc+0x21>
  801600:	b8 00 00 00 00       	mov    $0x0,%eax
  801605:	e9 af 00 00 00       	jmp    8016b9 <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  80160a:	e8 44 07 00 00       	call   801d53 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80160f:	83 f8 01             	cmp    $0x1,%eax
  801612:	0f 85 9c 00 00 00    	jne    8016b4 <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  801618:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80161f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801622:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801625:	01 d0                	add    %edx,%eax
  801627:	48                   	dec    %eax
  801628:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80162b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80162e:	ba 00 00 00 00       	mov    $0x0,%edx
  801633:	f7 75 f4             	divl   -0xc(%ebp)
  801636:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801639:	29 d0                	sub    %edx,%eax
  80163b:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  80163e:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  801645:	76 07                	jbe    80164e <smalloc+0x65>
			return NULL;
  801647:	b8 00 00 00 00       	mov    $0x0,%eax
  80164c:	eb 6b                	jmp    8016b9 <smalloc+0xd0>
		blk =alloc_block_FF(size);
  80164e:	83 ec 0c             	sub    $0xc,%esp
  801651:	ff 75 0c             	pushl  0xc(%ebp)
  801654:	e8 e7 0c 00 00       	call   802340 <alloc_block_FF>
  801659:	83 c4 10             	add    $0x10,%esp
  80165c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  80165f:	83 ec 0c             	sub    $0xc,%esp
  801662:	ff 75 ec             	pushl  -0x14(%ebp)
  801665:	e8 d6 0a 00 00       	call   802140 <insert_sorted_allocList>
  80166a:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  80166d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801671:	75 07                	jne    80167a <smalloc+0x91>
		{
			return NULL;
  801673:	b8 00 00 00 00       	mov    $0x0,%eax
  801678:	eb 3f                	jmp    8016b9 <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  80167a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80167d:	8b 40 08             	mov    0x8(%eax),%eax
  801680:	89 c2                	mov    %eax,%edx
  801682:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801686:	52                   	push   %edx
  801687:	50                   	push   %eax
  801688:	ff 75 0c             	pushl  0xc(%ebp)
  80168b:	ff 75 08             	pushl  0x8(%ebp)
  80168e:	e8 45 04 00 00       	call   801ad8 <sys_createSharedObject>
  801693:	83 c4 10             	add    $0x10,%esp
  801696:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  801699:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  80169d:	74 06                	je     8016a5 <smalloc+0xbc>
  80169f:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8016a3:	75 07                	jne    8016ac <smalloc+0xc3>
		{
			return NULL;
  8016a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8016aa:	eb 0d                	jmp    8016b9 <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  8016ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016af:	8b 40 08             	mov    0x8(%eax),%eax
  8016b2:	eb 05                	jmp    8016b9 <smalloc+0xd0>
		}
	}
	else
		return NULL;
  8016b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016b9:	c9                   	leave  
  8016ba:	c3                   	ret    

008016bb <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016bb:	55                   	push   %ebp
  8016bc:	89 e5                	mov    %esp,%ebp
  8016be:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016c1:	e8 2a fc ff ff       	call   8012f0 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8016c6:	83 ec 08             	sub    $0x8,%esp
  8016c9:	ff 75 0c             	pushl  0xc(%ebp)
  8016cc:	ff 75 08             	pushl  0x8(%ebp)
  8016cf:	e8 2e 04 00 00       	call   801b02 <sys_getSizeOfSharedObject>
  8016d4:	83 c4 10             	add    $0x10,%esp
  8016d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  8016da:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8016de:	75 0a                	jne    8016ea <sget+0x2f>
	{
		return NULL;
  8016e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e5:	e9 94 00 00 00       	jmp    80177e <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8016ea:	e8 64 06 00 00       	call   801d53 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016ef:	85 c0                	test   %eax,%eax
  8016f1:	0f 84 82 00 00 00    	je     801779 <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  8016f7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  8016fe:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801705:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801708:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80170b:	01 d0                	add    %edx,%eax
  80170d:	48                   	dec    %eax
  80170e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801711:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801714:	ba 00 00 00 00       	mov    $0x0,%edx
  801719:	f7 75 ec             	divl   -0x14(%ebp)
  80171c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80171f:	29 d0                	sub    %edx,%eax
  801721:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  801724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801727:	83 ec 0c             	sub    $0xc,%esp
  80172a:	50                   	push   %eax
  80172b:	e8 10 0c 00 00       	call   802340 <alloc_block_FF>
  801730:	83 c4 10             	add    $0x10,%esp
  801733:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  801736:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80173a:	75 07                	jne    801743 <sget+0x88>
		{
			return NULL;
  80173c:	b8 00 00 00 00       	mov    $0x0,%eax
  801741:	eb 3b                	jmp    80177e <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  801743:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801746:	8b 40 08             	mov    0x8(%eax),%eax
  801749:	83 ec 04             	sub    $0x4,%esp
  80174c:	50                   	push   %eax
  80174d:	ff 75 0c             	pushl  0xc(%ebp)
  801750:	ff 75 08             	pushl  0x8(%ebp)
  801753:	e8 c7 03 00 00       	call   801b1f <sys_getSharedObject>
  801758:	83 c4 10             	add    $0x10,%esp
  80175b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  80175e:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801762:	74 06                	je     80176a <sget+0xaf>
  801764:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  801768:	75 07                	jne    801771 <sget+0xb6>
		{
			return NULL;
  80176a:	b8 00 00 00 00       	mov    $0x0,%eax
  80176f:	eb 0d                	jmp    80177e <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  801771:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801774:	8b 40 08             	mov    0x8(%eax),%eax
  801777:	eb 05                	jmp    80177e <sget+0xc3>
		}
	}
	else
			return NULL;
  801779:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80177e:	c9                   	leave  
  80177f:	c3                   	ret    

00801780 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801780:	55                   	push   %ebp
  801781:	89 e5                	mov    %esp,%ebp
  801783:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801786:	e8 65 fb ff ff       	call   8012f0 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80178b:	83 ec 04             	sub    $0x4,%esp
  80178e:	68 c0 39 80 00       	push   $0x8039c0
  801793:	68 e1 00 00 00       	push   $0xe1
  801798:	68 b3 39 80 00       	push   $0x8039b3
  80179d:	e8 ac 18 00 00       	call   80304e <_panic>

008017a2 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017a2:	55                   	push   %ebp
  8017a3:	89 e5                	mov    %esp,%ebp
  8017a5:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017a8:	83 ec 04             	sub    $0x4,%esp
  8017ab:	68 e8 39 80 00       	push   $0x8039e8
  8017b0:	68 f5 00 00 00       	push   $0xf5
  8017b5:	68 b3 39 80 00       	push   $0x8039b3
  8017ba:	e8 8f 18 00 00       	call   80304e <_panic>

008017bf <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8017bf:	55                   	push   %ebp
  8017c0:	89 e5                	mov    %esp,%ebp
  8017c2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017c5:	83 ec 04             	sub    $0x4,%esp
  8017c8:	68 0c 3a 80 00       	push   $0x803a0c
  8017cd:	68 00 01 00 00       	push   $0x100
  8017d2:	68 b3 39 80 00       	push   $0x8039b3
  8017d7:	e8 72 18 00 00       	call   80304e <_panic>

008017dc <shrink>:

}
void shrink(uint32 newSize)
{
  8017dc:	55                   	push   %ebp
  8017dd:	89 e5                	mov    %esp,%ebp
  8017df:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017e2:	83 ec 04             	sub    $0x4,%esp
  8017e5:	68 0c 3a 80 00       	push   $0x803a0c
  8017ea:	68 05 01 00 00       	push   $0x105
  8017ef:	68 b3 39 80 00       	push   $0x8039b3
  8017f4:	e8 55 18 00 00       	call   80304e <_panic>

008017f9 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017f9:	55                   	push   %ebp
  8017fa:	89 e5                	mov    %esp,%ebp
  8017fc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017ff:	83 ec 04             	sub    $0x4,%esp
  801802:	68 0c 3a 80 00       	push   $0x803a0c
  801807:	68 0a 01 00 00       	push   $0x10a
  80180c:	68 b3 39 80 00       	push   $0x8039b3
  801811:	e8 38 18 00 00       	call   80304e <_panic>

00801816 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801816:	55                   	push   %ebp
  801817:	89 e5                	mov    %esp,%ebp
  801819:	57                   	push   %edi
  80181a:	56                   	push   %esi
  80181b:	53                   	push   %ebx
  80181c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80181f:	8b 45 08             	mov    0x8(%ebp),%eax
  801822:	8b 55 0c             	mov    0xc(%ebp),%edx
  801825:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801828:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80182b:	8b 7d 18             	mov    0x18(%ebp),%edi
  80182e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801831:	cd 30                	int    $0x30
  801833:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801836:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801839:	83 c4 10             	add    $0x10,%esp
  80183c:	5b                   	pop    %ebx
  80183d:	5e                   	pop    %esi
  80183e:	5f                   	pop    %edi
  80183f:	5d                   	pop    %ebp
  801840:	c3                   	ret    

00801841 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801841:	55                   	push   %ebp
  801842:	89 e5                	mov    %esp,%ebp
  801844:	83 ec 04             	sub    $0x4,%esp
  801847:	8b 45 10             	mov    0x10(%ebp),%eax
  80184a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80184d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801851:	8b 45 08             	mov    0x8(%ebp),%eax
  801854:	6a 00                	push   $0x0
  801856:	6a 00                	push   $0x0
  801858:	52                   	push   %edx
  801859:	ff 75 0c             	pushl  0xc(%ebp)
  80185c:	50                   	push   %eax
  80185d:	6a 00                	push   $0x0
  80185f:	e8 b2 ff ff ff       	call   801816 <syscall>
  801864:	83 c4 18             	add    $0x18,%esp
}
  801867:	90                   	nop
  801868:	c9                   	leave  
  801869:	c3                   	ret    

0080186a <sys_cgetc>:

int
sys_cgetc(void)
{
  80186a:	55                   	push   %ebp
  80186b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80186d:	6a 00                	push   $0x0
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 01                	push   $0x1
  801879:	e8 98 ff ff ff       	call   801816 <syscall>
  80187e:	83 c4 18             	add    $0x18,%esp
}
  801881:	c9                   	leave  
  801882:	c3                   	ret    

00801883 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801883:	55                   	push   %ebp
  801884:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801886:	8b 55 0c             	mov    0xc(%ebp),%edx
  801889:	8b 45 08             	mov    0x8(%ebp),%eax
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	52                   	push   %edx
  801893:	50                   	push   %eax
  801894:	6a 05                	push   $0x5
  801896:	e8 7b ff ff ff       	call   801816 <syscall>
  80189b:	83 c4 18             	add    $0x18,%esp
}
  80189e:	c9                   	leave  
  80189f:	c3                   	ret    

008018a0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018a0:	55                   	push   %ebp
  8018a1:	89 e5                	mov    %esp,%ebp
  8018a3:	56                   	push   %esi
  8018a4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018a5:	8b 75 18             	mov    0x18(%ebp),%esi
  8018a8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018ab:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b4:	56                   	push   %esi
  8018b5:	53                   	push   %ebx
  8018b6:	51                   	push   %ecx
  8018b7:	52                   	push   %edx
  8018b8:	50                   	push   %eax
  8018b9:	6a 06                	push   $0x6
  8018bb:	e8 56 ff ff ff       	call   801816 <syscall>
  8018c0:	83 c4 18             	add    $0x18,%esp
}
  8018c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018c6:	5b                   	pop    %ebx
  8018c7:	5e                   	pop    %esi
  8018c8:	5d                   	pop    %ebp
  8018c9:	c3                   	ret    

008018ca <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018ca:	55                   	push   %ebp
  8018cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	52                   	push   %edx
  8018da:	50                   	push   %eax
  8018db:	6a 07                	push   $0x7
  8018dd:	e8 34 ff ff ff       	call   801816 <syscall>
  8018e2:	83 c4 18             	add    $0x18,%esp
}
  8018e5:	c9                   	leave  
  8018e6:	c3                   	ret    

008018e7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018e7:	55                   	push   %ebp
  8018e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	ff 75 0c             	pushl  0xc(%ebp)
  8018f3:	ff 75 08             	pushl  0x8(%ebp)
  8018f6:	6a 08                	push   $0x8
  8018f8:	e8 19 ff ff ff       	call   801816 <syscall>
  8018fd:	83 c4 18             	add    $0x18,%esp
}
  801900:	c9                   	leave  
  801901:	c3                   	ret    

00801902 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801902:	55                   	push   %ebp
  801903:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 09                	push   $0x9
  801911:	e8 00 ff ff ff       	call   801816 <syscall>
  801916:	83 c4 18             	add    $0x18,%esp
}
  801919:	c9                   	leave  
  80191a:	c3                   	ret    

0080191b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80191b:	55                   	push   %ebp
  80191c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80191e:	6a 00                	push   $0x0
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	6a 0a                	push   $0xa
  80192a:	e8 e7 fe ff ff       	call   801816 <syscall>
  80192f:	83 c4 18             	add    $0x18,%esp
}
  801932:	c9                   	leave  
  801933:	c3                   	ret    

00801934 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801934:	55                   	push   %ebp
  801935:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 0b                	push   $0xb
  801943:	e8 ce fe ff ff       	call   801816 <syscall>
  801948:	83 c4 18             	add    $0x18,%esp
}
  80194b:	c9                   	leave  
  80194c:	c3                   	ret    

0080194d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80194d:	55                   	push   %ebp
  80194e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	ff 75 0c             	pushl  0xc(%ebp)
  801959:	ff 75 08             	pushl  0x8(%ebp)
  80195c:	6a 0f                	push   $0xf
  80195e:	e8 b3 fe ff ff       	call   801816 <syscall>
  801963:	83 c4 18             	add    $0x18,%esp
	return;
  801966:	90                   	nop
}
  801967:	c9                   	leave  
  801968:	c3                   	ret    

00801969 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	ff 75 0c             	pushl  0xc(%ebp)
  801975:	ff 75 08             	pushl  0x8(%ebp)
  801978:	6a 10                	push   $0x10
  80197a:	e8 97 fe ff ff       	call   801816 <syscall>
  80197f:	83 c4 18             	add    $0x18,%esp
	return ;
  801982:	90                   	nop
}
  801983:	c9                   	leave  
  801984:	c3                   	ret    

00801985 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801985:	55                   	push   %ebp
  801986:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	ff 75 10             	pushl  0x10(%ebp)
  80198f:	ff 75 0c             	pushl  0xc(%ebp)
  801992:	ff 75 08             	pushl  0x8(%ebp)
  801995:	6a 11                	push   $0x11
  801997:	e8 7a fe ff ff       	call   801816 <syscall>
  80199c:	83 c4 18             	add    $0x18,%esp
	return ;
  80199f:	90                   	nop
}
  8019a0:	c9                   	leave  
  8019a1:	c3                   	ret    

008019a2 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019a2:	55                   	push   %ebp
  8019a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 0c                	push   $0xc
  8019b1:	e8 60 fe ff ff       	call   801816 <syscall>
  8019b6:	83 c4 18             	add    $0x18,%esp
}
  8019b9:	c9                   	leave  
  8019ba:	c3                   	ret    

008019bb <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019bb:	55                   	push   %ebp
  8019bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 00                	push   $0x0
  8019c6:	ff 75 08             	pushl  0x8(%ebp)
  8019c9:	6a 0d                	push   $0xd
  8019cb:	e8 46 fe ff ff       	call   801816 <syscall>
  8019d0:	83 c4 18             	add    $0x18,%esp
}
  8019d3:	c9                   	leave  
  8019d4:	c3                   	ret    

008019d5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019d5:	55                   	push   %ebp
  8019d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 0e                	push   $0xe
  8019e4:	e8 2d fe ff ff       	call   801816 <syscall>
  8019e9:	83 c4 18             	add    $0x18,%esp
}
  8019ec:	90                   	nop
  8019ed:	c9                   	leave  
  8019ee:	c3                   	ret    

008019ef <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019ef:	55                   	push   %ebp
  8019f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 13                	push   $0x13
  8019fe:	e8 13 fe ff ff       	call   801816 <syscall>
  801a03:	83 c4 18             	add    $0x18,%esp
}
  801a06:	90                   	nop
  801a07:	c9                   	leave  
  801a08:	c3                   	ret    

00801a09 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a09:	55                   	push   %ebp
  801a0a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 14                	push   $0x14
  801a18:	e8 f9 fd ff ff       	call   801816 <syscall>
  801a1d:	83 c4 18             	add    $0x18,%esp
}
  801a20:	90                   	nop
  801a21:	c9                   	leave  
  801a22:	c3                   	ret    

00801a23 <sys_cputc>:


void
sys_cputc(const char c)
{
  801a23:	55                   	push   %ebp
  801a24:	89 e5                	mov    %esp,%ebp
  801a26:	83 ec 04             	sub    $0x4,%esp
  801a29:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a2f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	50                   	push   %eax
  801a3c:	6a 15                	push   $0x15
  801a3e:	e8 d3 fd ff ff       	call   801816 <syscall>
  801a43:	83 c4 18             	add    $0x18,%esp
}
  801a46:	90                   	nop
  801a47:	c9                   	leave  
  801a48:	c3                   	ret    

00801a49 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a49:	55                   	push   %ebp
  801a4a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	6a 16                	push   $0x16
  801a58:	e8 b9 fd ff ff       	call   801816 <syscall>
  801a5d:	83 c4 18             	add    $0x18,%esp
}
  801a60:	90                   	nop
  801a61:	c9                   	leave  
  801a62:	c3                   	ret    

00801a63 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a66:	8b 45 08             	mov    0x8(%ebp),%eax
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	ff 75 0c             	pushl  0xc(%ebp)
  801a72:	50                   	push   %eax
  801a73:	6a 17                	push   $0x17
  801a75:	e8 9c fd ff ff       	call   801816 <syscall>
  801a7a:	83 c4 18             	add    $0x18,%esp
}
  801a7d:	c9                   	leave  
  801a7e:	c3                   	ret    

00801a7f <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a7f:	55                   	push   %ebp
  801a80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a82:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a85:	8b 45 08             	mov    0x8(%ebp),%eax
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	52                   	push   %edx
  801a8f:	50                   	push   %eax
  801a90:	6a 1a                	push   $0x1a
  801a92:	e8 7f fd ff ff       	call   801816 <syscall>
  801a97:	83 c4 18             	add    $0x18,%esp
}
  801a9a:	c9                   	leave  
  801a9b:	c3                   	ret    

00801a9c <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a9c:	55                   	push   %ebp
  801a9d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	52                   	push   %edx
  801aac:	50                   	push   %eax
  801aad:	6a 18                	push   $0x18
  801aaf:	e8 62 fd ff ff       	call   801816 <syscall>
  801ab4:	83 c4 18             	add    $0x18,%esp
}
  801ab7:	90                   	nop
  801ab8:	c9                   	leave  
  801ab9:	c3                   	ret    

00801aba <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801aba:	55                   	push   %ebp
  801abb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801abd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	52                   	push   %edx
  801aca:	50                   	push   %eax
  801acb:	6a 19                	push   $0x19
  801acd:	e8 44 fd ff ff       	call   801816 <syscall>
  801ad2:	83 c4 18             	add    $0x18,%esp
}
  801ad5:	90                   	nop
  801ad6:	c9                   	leave  
  801ad7:	c3                   	ret    

00801ad8 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ad8:	55                   	push   %ebp
  801ad9:	89 e5                	mov    %esp,%ebp
  801adb:	83 ec 04             	sub    $0x4,%esp
  801ade:	8b 45 10             	mov    0x10(%ebp),%eax
  801ae1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ae4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ae7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  801aee:	6a 00                	push   $0x0
  801af0:	51                   	push   %ecx
  801af1:	52                   	push   %edx
  801af2:	ff 75 0c             	pushl  0xc(%ebp)
  801af5:	50                   	push   %eax
  801af6:	6a 1b                	push   $0x1b
  801af8:	e8 19 fd ff ff       	call   801816 <syscall>
  801afd:	83 c4 18             	add    $0x18,%esp
}
  801b00:	c9                   	leave  
  801b01:	c3                   	ret    

00801b02 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b02:	55                   	push   %ebp
  801b03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b05:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b08:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	52                   	push   %edx
  801b12:	50                   	push   %eax
  801b13:	6a 1c                	push   $0x1c
  801b15:	e8 fc fc ff ff       	call   801816 <syscall>
  801b1a:	83 c4 18             	add    $0x18,%esp
}
  801b1d:	c9                   	leave  
  801b1e:	c3                   	ret    

00801b1f <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b1f:	55                   	push   %ebp
  801b20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b22:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b25:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b28:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	51                   	push   %ecx
  801b30:	52                   	push   %edx
  801b31:	50                   	push   %eax
  801b32:	6a 1d                	push   $0x1d
  801b34:	e8 dd fc ff ff       	call   801816 <syscall>
  801b39:	83 c4 18             	add    $0x18,%esp
}
  801b3c:	c9                   	leave  
  801b3d:	c3                   	ret    

00801b3e <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b3e:	55                   	push   %ebp
  801b3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b41:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b44:	8b 45 08             	mov    0x8(%ebp),%eax
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	52                   	push   %edx
  801b4e:	50                   	push   %eax
  801b4f:	6a 1e                	push   $0x1e
  801b51:	e8 c0 fc ff ff       	call   801816 <syscall>
  801b56:	83 c4 18             	add    $0x18,%esp
}
  801b59:	c9                   	leave  
  801b5a:	c3                   	ret    

00801b5b <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	6a 1f                	push   $0x1f
  801b6a:	e8 a7 fc ff ff       	call   801816 <syscall>
  801b6f:	83 c4 18             	add    $0x18,%esp
}
  801b72:	c9                   	leave  
  801b73:	c3                   	ret    

00801b74 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b74:	55                   	push   %ebp
  801b75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b77:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7a:	6a 00                	push   $0x0
  801b7c:	ff 75 14             	pushl  0x14(%ebp)
  801b7f:	ff 75 10             	pushl  0x10(%ebp)
  801b82:	ff 75 0c             	pushl  0xc(%ebp)
  801b85:	50                   	push   %eax
  801b86:	6a 20                	push   $0x20
  801b88:	e8 89 fc ff ff       	call   801816 <syscall>
  801b8d:	83 c4 18             	add    $0x18,%esp
}
  801b90:	c9                   	leave  
  801b91:	c3                   	ret    

00801b92 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b92:	55                   	push   %ebp
  801b93:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b95:	8b 45 08             	mov    0x8(%ebp),%eax
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	50                   	push   %eax
  801ba1:	6a 21                	push   $0x21
  801ba3:	e8 6e fc ff ff       	call   801816 <syscall>
  801ba8:	83 c4 18             	add    $0x18,%esp
}
  801bab:	90                   	nop
  801bac:	c9                   	leave  
  801bad:	c3                   	ret    

00801bae <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bae:	55                   	push   %ebp
  801baf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	50                   	push   %eax
  801bbd:	6a 22                	push   $0x22
  801bbf:	e8 52 fc ff ff       	call   801816 <syscall>
  801bc4:	83 c4 18             	add    $0x18,%esp
}
  801bc7:	c9                   	leave  
  801bc8:	c3                   	ret    

00801bc9 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bc9:	55                   	push   %ebp
  801bca:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 02                	push   $0x2
  801bd8:	e8 39 fc ff ff       	call   801816 <syscall>
  801bdd:	83 c4 18             	add    $0x18,%esp
}
  801be0:	c9                   	leave  
  801be1:	c3                   	ret    

00801be2 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801be2:	55                   	push   %ebp
  801be3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 03                	push   $0x3
  801bf1:	e8 20 fc ff ff       	call   801816 <syscall>
  801bf6:	83 c4 18             	add    $0x18,%esp
}
  801bf9:	c9                   	leave  
  801bfa:	c3                   	ret    

00801bfb <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bfb:	55                   	push   %ebp
  801bfc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 04                	push   $0x4
  801c0a:	e8 07 fc ff ff       	call   801816 <syscall>
  801c0f:	83 c4 18             	add    $0x18,%esp
}
  801c12:	c9                   	leave  
  801c13:	c3                   	ret    

00801c14 <sys_exit_env>:


void sys_exit_env(void)
{
  801c14:	55                   	push   %ebp
  801c15:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 23                	push   $0x23
  801c23:	e8 ee fb ff ff       	call   801816 <syscall>
  801c28:	83 c4 18             	add    $0x18,%esp
}
  801c2b:	90                   	nop
  801c2c:	c9                   	leave  
  801c2d:	c3                   	ret    

00801c2e <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c2e:	55                   	push   %ebp
  801c2f:	89 e5                	mov    %esp,%ebp
  801c31:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c34:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c37:	8d 50 04             	lea    0x4(%eax),%edx
  801c3a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	52                   	push   %edx
  801c44:	50                   	push   %eax
  801c45:	6a 24                	push   $0x24
  801c47:	e8 ca fb ff ff       	call   801816 <syscall>
  801c4c:	83 c4 18             	add    $0x18,%esp
	return result;
  801c4f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c52:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c55:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c58:	89 01                	mov    %eax,(%ecx)
  801c5a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c60:	c9                   	leave  
  801c61:	c2 04 00             	ret    $0x4

00801c64 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c64:	55                   	push   %ebp
  801c65:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	ff 75 10             	pushl  0x10(%ebp)
  801c6e:	ff 75 0c             	pushl  0xc(%ebp)
  801c71:	ff 75 08             	pushl  0x8(%ebp)
  801c74:	6a 12                	push   $0x12
  801c76:	e8 9b fb ff ff       	call   801816 <syscall>
  801c7b:	83 c4 18             	add    $0x18,%esp
	return ;
  801c7e:	90                   	nop
}
  801c7f:	c9                   	leave  
  801c80:	c3                   	ret    

00801c81 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c81:	55                   	push   %ebp
  801c82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 25                	push   $0x25
  801c90:	e8 81 fb ff ff       	call   801816 <syscall>
  801c95:	83 c4 18             	add    $0x18,%esp
}
  801c98:	c9                   	leave  
  801c99:	c3                   	ret    

00801c9a <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c9a:	55                   	push   %ebp
  801c9b:	89 e5                	mov    %esp,%ebp
  801c9d:	83 ec 04             	sub    $0x4,%esp
  801ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ca6:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	50                   	push   %eax
  801cb3:	6a 26                	push   $0x26
  801cb5:	e8 5c fb ff ff       	call   801816 <syscall>
  801cba:	83 c4 18             	add    $0x18,%esp
	return ;
  801cbd:	90                   	nop
}
  801cbe:	c9                   	leave  
  801cbf:	c3                   	ret    

00801cc0 <rsttst>:
void rsttst()
{
  801cc0:	55                   	push   %ebp
  801cc1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 28                	push   $0x28
  801ccf:	e8 42 fb ff ff       	call   801816 <syscall>
  801cd4:	83 c4 18             	add    $0x18,%esp
	return ;
  801cd7:	90                   	nop
}
  801cd8:	c9                   	leave  
  801cd9:	c3                   	ret    

00801cda <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cda:	55                   	push   %ebp
  801cdb:	89 e5                	mov    %esp,%ebp
  801cdd:	83 ec 04             	sub    $0x4,%esp
  801ce0:	8b 45 14             	mov    0x14(%ebp),%eax
  801ce3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ce6:	8b 55 18             	mov    0x18(%ebp),%edx
  801ce9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ced:	52                   	push   %edx
  801cee:	50                   	push   %eax
  801cef:	ff 75 10             	pushl  0x10(%ebp)
  801cf2:	ff 75 0c             	pushl  0xc(%ebp)
  801cf5:	ff 75 08             	pushl  0x8(%ebp)
  801cf8:	6a 27                	push   $0x27
  801cfa:	e8 17 fb ff ff       	call   801816 <syscall>
  801cff:	83 c4 18             	add    $0x18,%esp
	return ;
  801d02:	90                   	nop
}
  801d03:	c9                   	leave  
  801d04:	c3                   	ret    

00801d05 <chktst>:
void chktst(uint32 n)
{
  801d05:	55                   	push   %ebp
  801d06:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	ff 75 08             	pushl  0x8(%ebp)
  801d13:	6a 29                	push   $0x29
  801d15:	e8 fc fa ff ff       	call   801816 <syscall>
  801d1a:	83 c4 18             	add    $0x18,%esp
	return ;
  801d1d:	90                   	nop
}
  801d1e:	c9                   	leave  
  801d1f:	c3                   	ret    

00801d20 <inctst>:

void inctst()
{
  801d20:	55                   	push   %ebp
  801d21:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 2a                	push   $0x2a
  801d2f:	e8 e2 fa ff ff       	call   801816 <syscall>
  801d34:	83 c4 18             	add    $0x18,%esp
	return ;
  801d37:	90                   	nop
}
  801d38:	c9                   	leave  
  801d39:	c3                   	ret    

00801d3a <gettst>:
uint32 gettst()
{
  801d3a:	55                   	push   %ebp
  801d3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 2b                	push   $0x2b
  801d49:	e8 c8 fa ff ff       	call   801816 <syscall>
  801d4e:	83 c4 18             	add    $0x18,%esp
}
  801d51:	c9                   	leave  
  801d52:	c3                   	ret    

00801d53 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d53:	55                   	push   %ebp
  801d54:	89 e5                	mov    %esp,%ebp
  801d56:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 00                	push   $0x0
  801d63:	6a 2c                	push   $0x2c
  801d65:	e8 ac fa ff ff       	call   801816 <syscall>
  801d6a:	83 c4 18             	add    $0x18,%esp
  801d6d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d70:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d74:	75 07                	jne    801d7d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d76:	b8 01 00 00 00       	mov    $0x1,%eax
  801d7b:	eb 05                	jmp    801d82 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d82:	c9                   	leave  
  801d83:	c3                   	ret    

00801d84 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d84:	55                   	push   %ebp
  801d85:	89 e5                	mov    %esp,%ebp
  801d87:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	6a 00                	push   $0x0
  801d94:	6a 2c                	push   $0x2c
  801d96:	e8 7b fa ff ff       	call   801816 <syscall>
  801d9b:	83 c4 18             	add    $0x18,%esp
  801d9e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801da1:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801da5:	75 07                	jne    801dae <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801da7:	b8 01 00 00 00       	mov    $0x1,%eax
  801dac:	eb 05                	jmp    801db3 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801dae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801db3:	c9                   	leave  
  801db4:	c3                   	ret    

00801db5 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801db5:	55                   	push   %ebp
  801db6:	89 e5                	mov    %esp,%ebp
  801db8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 2c                	push   $0x2c
  801dc7:	e8 4a fa ff ff       	call   801816 <syscall>
  801dcc:	83 c4 18             	add    $0x18,%esp
  801dcf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801dd2:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801dd6:	75 07                	jne    801ddf <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801dd8:	b8 01 00 00 00       	mov    $0x1,%eax
  801ddd:	eb 05                	jmp    801de4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ddf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801de4:	c9                   	leave  
  801de5:	c3                   	ret    

00801de6 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801de6:	55                   	push   %ebp
  801de7:	89 e5                	mov    %esp,%ebp
  801de9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 2c                	push   $0x2c
  801df8:	e8 19 fa ff ff       	call   801816 <syscall>
  801dfd:	83 c4 18             	add    $0x18,%esp
  801e00:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e03:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e07:	75 07                	jne    801e10 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e09:	b8 01 00 00 00       	mov    $0x1,%eax
  801e0e:	eb 05                	jmp    801e15 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e10:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e15:	c9                   	leave  
  801e16:	c3                   	ret    

00801e17 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e17:	55                   	push   %ebp
  801e18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e1a:	6a 00                	push   $0x0
  801e1c:	6a 00                	push   $0x0
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	ff 75 08             	pushl  0x8(%ebp)
  801e25:	6a 2d                	push   $0x2d
  801e27:	e8 ea f9 ff ff       	call   801816 <syscall>
  801e2c:	83 c4 18             	add    $0x18,%esp
	return ;
  801e2f:	90                   	nop
}
  801e30:	c9                   	leave  
  801e31:	c3                   	ret    

00801e32 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e32:	55                   	push   %ebp
  801e33:	89 e5                	mov    %esp,%ebp
  801e35:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e36:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e39:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e42:	6a 00                	push   $0x0
  801e44:	53                   	push   %ebx
  801e45:	51                   	push   %ecx
  801e46:	52                   	push   %edx
  801e47:	50                   	push   %eax
  801e48:	6a 2e                	push   $0x2e
  801e4a:	e8 c7 f9 ff ff       	call   801816 <syscall>
  801e4f:	83 c4 18             	add    $0x18,%esp
}
  801e52:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e55:	c9                   	leave  
  801e56:	c3                   	ret    

00801e57 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e57:	55                   	push   %ebp
  801e58:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e60:	6a 00                	push   $0x0
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	52                   	push   %edx
  801e67:	50                   	push   %eax
  801e68:	6a 2f                	push   $0x2f
  801e6a:	e8 a7 f9 ff ff       	call   801816 <syscall>
  801e6f:	83 c4 18             	add    $0x18,%esp
}
  801e72:	c9                   	leave  
  801e73:	c3                   	ret    

00801e74 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e74:	55                   	push   %ebp
  801e75:	89 e5                	mov    %esp,%ebp
  801e77:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e7a:	83 ec 0c             	sub    $0xc,%esp
  801e7d:	68 1c 3a 80 00       	push   $0x803a1c
  801e82:	e8 df e6 ff ff       	call   800566 <cprintf>
  801e87:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e8a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e91:	83 ec 0c             	sub    $0xc,%esp
  801e94:	68 48 3a 80 00       	push   $0x803a48
  801e99:	e8 c8 e6 ff ff       	call   800566 <cprintf>
  801e9e:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801ea1:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ea5:	a1 38 41 80 00       	mov    0x804138,%eax
  801eaa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ead:	eb 56                	jmp    801f05 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801eaf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801eb3:	74 1c                	je     801ed1 <print_mem_block_lists+0x5d>
  801eb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb8:	8b 50 08             	mov    0x8(%eax),%edx
  801ebb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ebe:	8b 48 08             	mov    0x8(%eax),%ecx
  801ec1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ec4:	8b 40 0c             	mov    0xc(%eax),%eax
  801ec7:	01 c8                	add    %ecx,%eax
  801ec9:	39 c2                	cmp    %eax,%edx
  801ecb:	73 04                	jae    801ed1 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801ecd:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ed1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed4:	8b 50 08             	mov    0x8(%eax),%edx
  801ed7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eda:	8b 40 0c             	mov    0xc(%eax),%eax
  801edd:	01 c2                	add    %eax,%edx
  801edf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee2:	8b 40 08             	mov    0x8(%eax),%eax
  801ee5:	83 ec 04             	sub    $0x4,%esp
  801ee8:	52                   	push   %edx
  801ee9:	50                   	push   %eax
  801eea:	68 5d 3a 80 00       	push   $0x803a5d
  801eef:	e8 72 e6 ff ff       	call   800566 <cprintf>
  801ef4:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ef7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801efa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801efd:	a1 40 41 80 00       	mov    0x804140,%eax
  801f02:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f05:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f09:	74 07                	je     801f12 <print_mem_block_lists+0x9e>
  801f0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f0e:	8b 00                	mov    (%eax),%eax
  801f10:	eb 05                	jmp    801f17 <print_mem_block_lists+0xa3>
  801f12:	b8 00 00 00 00       	mov    $0x0,%eax
  801f17:	a3 40 41 80 00       	mov    %eax,0x804140
  801f1c:	a1 40 41 80 00       	mov    0x804140,%eax
  801f21:	85 c0                	test   %eax,%eax
  801f23:	75 8a                	jne    801eaf <print_mem_block_lists+0x3b>
  801f25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f29:	75 84                	jne    801eaf <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f2b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f2f:	75 10                	jne    801f41 <print_mem_block_lists+0xcd>
  801f31:	83 ec 0c             	sub    $0xc,%esp
  801f34:	68 6c 3a 80 00       	push   $0x803a6c
  801f39:	e8 28 e6 ff ff       	call   800566 <cprintf>
  801f3e:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f41:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f48:	83 ec 0c             	sub    $0xc,%esp
  801f4b:	68 90 3a 80 00       	push   $0x803a90
  801f50:	e8 11 e6 ff ff       	call   800566 <cprintf>
  801f55:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f58:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f5c:	a1 40 40 80 00       	mov    0x804040,%eax
  801f61:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f64:	eb 56                	jmp    801fbc <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f66:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f6a:	74 1c                	je     801f88 <print_mem_block_lists+0x114>
  801f6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6f:	8b 50 08             	mov    0x8(%eax),%edx
  801f72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f75:	8b 48 08             	mov    0x8(%eax),%ecx
  801f78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f7b:	8b 40 0c             	mov    0xc(%eax),%eax
  801f7e:	01 c8                	add    %ecx,%eax
  801f80:	39 c2                	cmp    %eax,%edx
  801f82:	73 04                	jae    801f88 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f84:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8b:	8b 50 08             	mov    0x8(%eax),%edx
  801f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f91:	8b 40 0c             	mov    0xc(%eax),%eax
  801f94:	01 c2                	add    %eax,%edx
  801f96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f99:	8b 40 08             	mov    0x8(%eax),%eax
  801f9c:	83 ec 04             	sub    $0x4,%esp
  801f9f:	52                   	push   %edx
  801fa0:	50                   	push   %eax
  801fa1:	68 5d 3a 80 00       	push   $0x803a5d
  801fa6:	e8 bb e5 ff ff       	call   800566 <cprintf>
  801fab:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fb4:	a1 48 40 80 00       	mov    0x804048,%eax
  801fb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fbc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fc0:	74 07                	je     801fc9 <print_mem_block_lists+0x155>
  801fc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc5:	8b 00                	mov    (%eax),%eax
  801fc7:	eb 05                	jmp    801fce <print_mem_block_lists+0x15a>
  801fc9:	b8 00 00 00 00       	mov    $0x0,%eax
  801fce:	a3 48 40 80 00       	mov    %eax,0x804048
  801fd3:	a1 48 40 80 00       	mov    0x804048,%eax
  801fd8:	85 c0                	test   %eax,%eax
  801fda:	75 8a                	jne    801f66 <print_mem_block_lists+0xf2>
  801fdc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fe0:	75 84                	jne    801f66 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801fe2:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fe6:	75 10                	jne    801ff8 <print_mem_block_lists+0x184>
  801fe8:	83 ec 0c             	sub    $0xc,%esp
  801feb:	68 a8 3a 80 00       	push   $0x803aa8
  801ff0:	e8 71 e5 ff ff       	call   800566 <cprintf>
  801ff5:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801ff8:	83 ec 0c             	sub    $0xc,%esp
  801ffb:	68 1c 3a 80 00       	push   $0x803a1c
  802000:	e8 61 e5 ff ff       	call   800566 <cprintf>
  802005:	83 c4 10             	add    $0x10,%esp

}
  802008:	90                   	nop
  802009:	c9                   	leave  
  80200a:	c3                   	ret    

0080200b <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80200b:	55                   	push   %ebp
  80200c:	89 e5                	mov    %esp,%ebp
  80200e:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802011:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802018:	00 00 00 
  80201b:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802022:	00 00 00 
  802025:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  80202c:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  80202f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802036:	e9 9e 00 00 00       	jmp    8020d9 <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  80203b:	a1 50 40 80 00       	mov    0x804050,%eax
  802040:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802043:	c1 e2 04             	shl    $0x4,%edx
  802046:	01 d0                	add    %edx,%eax
  802048:	85 c0                	test   %eax,%eax
  80204a:	75 14                	jne    802060 <initialize_MemBlocksList+0x55>
  80204c:	83 ec 04             	sub    $0x4,%esp
  80204f:	68 d0 3a 80 00       	push   $0x803ad0
  802054:	6a 42                	push   $0x42
  802056:	68 f3 3a 80 00       	push   $0x803af3
  80205b:	e8 ee 0f 00 00       	call   80304e <_panic>
  802060:	a1 50 40 80 00       	mov    0x804050,%eax
  802065:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802068:	c1 e2 04             	shl    $0x4,%edx
  80206b:	01 d0                	add    %edx,%eax
  80206d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802073:	89 10                	mov    %edx,(%eax)
  802075:	8b 00                	mov    (%eax),%eax
  802077:	85 c0                	test   %eax,%eax
  802079:	74 18                	je     802093 <initialize_MemBlocksList+0x88>
  80207b:	a1 48 41 80 00       	mov    0x804148,%eax
  802080:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802086:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802089:	c1 e1 04             	shl    $0x4,%ecx
  80208c:	01 ca                	add    %ecx,%edx
  80208e:	89 50 04             	mov    %edx,0x4(%eax)
  802091:	eb 12                	jmp    8020a5 <initialize_MemBlocksList+0x9a>
  802093:	a1 50 40 80 00       	mov    0x804050,%eax
  802098:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80209b:	c1 e2 04             	shl    $0x4,%edx
  80209e:	01 d0                	add    %edx,%eax
  8020a0:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8020a5:	a1 50 40 80 00       	mov    0x804050,%eax
  8020aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020ad:	c1 e2 04             	shl    $0x4,%edx
  8020b0:	01 d0                	add    %edx,%eax
  8020b2:	a3 48 41 80 00       	mov    %eax,0x804148
  8020b7:	a1 50 40 80 00       	mov    0x804050,%eax
  8020bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020bf:	c1 e2 04             	shl    $0x4,%edx
  8020c2:	01 d0                	add    %edx,%eax
  8020c4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020cb:	a1 54 41 80 00       	mov    0x804154,%eax
  8020d0:	40                   	inc    %eax
  8020d1:	a3 54 41 80 00       	mov    %eax,0x804154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  8020d6:	ff 45 f4             	incl   -0xc(%ebp)
  8020d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020dc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020df:	0f 82 56 ff ff ff    	jb     80203b <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  8020e5:	90                   	nop
  8020e6:	c9                   	leave  
  8020e7:	c3                   	ret    

008020e8 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8020e8:	55                   	push   %ebp
  8020e9:	89 e5                	mov    %esp,%ebp
  8020eb:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  8020ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f1:	8b 00                	mov    (%eax),%eax
  8020f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020f6:	eb 19                	jmp    802111 <find_block+0x29>
	{
		if(blk->sva==va)
  8020f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020fb:	8b 40 08             	mov    0x8(%eax),%eax
  8020fe:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802101:	75 05                	jne    802108 <find_block+0x20>
			return (blk);
  802103:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802106:	eb 36                	jmp    80213e <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  802108:	8b 45 08             	mov    0x8(%ebp),%eax
  80210b:	8b 40 08             	mov    0x8(%eax),%eax
  80210e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802111:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802115:	74 07                	je     80211e <find_block+0x36>
  802117:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80211a:	8b 00                	mov    (%eax),%eax
  80211c:	eb 05                	jmp    802123 <find_block+0x3b>
  80211e:	b8 00 00 00 00       	mov    $0x0,%eax
  802123:	8b 55 08             	mov    0x8(%ebp),%edx
  802126:	89 42 08             	mov    %eax,0x8(%edx)
  802129:	8b 45 08             	mov    0x8(%ebp),%eax
  80212c:	8b 40 08             	mov    0x8(%eax),%eax
  80212f:	85 c0                	test   %eax,%eax
  802131:	75 c5                	jne    8020f8 <find_block+0x10>
  802133:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802137:	75 bf                	jne    8020f8 <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  802139:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80213e:	c9                   	leave  
  80213f:	c3                   	ret    

00802140 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802140:	55                   	push   %ebp
  802141:	89 e5                	mov    %esp,%ebp
  802143:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  802146:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80214b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80214e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  802155:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802158:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80215b:	75 65                	jne    8021c2 <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80215d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802161:	75 14                	jne    802177 <insert_sorted_allocList+0x37>
  802163:	83 ec 04             	sub    $0x4,%esp
  802166:	68 d0 3a 80 00       	push   $0x803ad0
  80216b:	6a 5c                	push   $0x5c
  80216d:	68 f3 3a 80 00       	push   $0x803af3
  802172:	e8 d7 0e 00 00       	call   80304e <_panic>
  802177:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80217d:	8b 45 08             	mov    0x8(%ebp),%eax
  802180:	89 10                	mov    %edx,(%eax)
  802182:	8b 45 08             	mov    0x8(%ebp),%eax
  802185:	8b 00                	mov    (%eax),%eax
  802187:	85 c0                	test   %eax,%eax
  802189:	74 0d                	je     802198 <insert_sorted_allocList+0x58>
  80218b:	a1 40 40 80 00       	mov    0x804040,%eax
  802190:	8b 55 08             	mov    0x8(%ebp),%edx
  802193:	89 50 04             	mov    %edx,0x4(%eax)
  802196:	eb 08                	jmp    8021a0 <insert_sorted_allocList+0x60>
  802198:	8b 45 08             	mov    0x8(%ebp),%eax
  80219b:	a3 44 40 80 00       	mov    %eax,0x804044
  8021a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a3:	a3 40 40 80 00       	mov    %eax,0x804040
  8021a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021b2:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021b7:	40                   	inc    %eax
  8021b8:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  8021bd:	e9 7b 01 00 00       	jmp    80233d <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  8021c2:	a1 44 40 80 00       	mov    0x804044,%eax
  8021c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  8021ca:	a1 40 40 80 00       	mov    0x804040,%eax
  8021cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  8021d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d5:	8b 50 08             	mov    0x8(%eax),%edx
  8021d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021db:	8b 40 08             	mov    0x8(%eax),%eax
  8021de:	39 c2                	cmp    %eax,%edx
  8021e0:	76 65                	jbe    802247 <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  8021e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021e6:	75 14                	jne    8021fc <insert_sorted_allocList+0xbc>
  8021e8:	83 ec 04             	sub    $0x4,%esp
  8021eb:	68 0c 3b 80 00       	push   $0x803b0c
  8021f0:	6a 64                	push   $0x64
  8021f2:	68 f3 3a 80 00       	push   $0x803af3
  8021f7:	e8 52 0e 00 00       	call   80304e <_panic>
  8021fc:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802202:	8b 45 08             	mov    0x8(%ebp),%eax
  802205:	89 50 04             	mov    %edx,0x4(%eax)
  802208:	8b 45 08             	mov    0x8(%ebp),%eax
  80220b:	8b 40 04             	mov    0x4(%eax),%eax
  80220e:	85 c0                	test   %eax,%eax
  802210:	74 0c                	je     80221e <insert_sorted_allocList+0xde>
  802212:	a1 44 40 80 00       	mov    0x804044,%eax
  802217:	8b 55 08             	mov    0x8(%ebp),%edx
  80221a:	89 10                	mov    %edx,(%eax)
  80221c:	eb 08                	jmp    802226 <insert_sorted_allocList+0xe6>
  80221e:	8b 45 08             	mov    0x8(%ebp),%eax
  802221:	a3 40 40 80 00       	mov    %eax,0x804040
  802226:	8b 45 08             	mov    0x8(%ebp),%eax
  802229:	a3 44 40 80 00       	mov    %eax,0x804044
  80222e:	8b 45 08             	mov    0x8(%ebp),%eax
  802231:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802237:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80223c:	40                   	inc    %eax
  80223d:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  802242:	e9 f6 00 00 00       	jmp    80233d <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  802247:	8b 45 08             	mov    0x8(%ebp),%eax
  80224a:	8b 50 08             	mov    0x8(%eax),%edx
  80224d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802250:	8b 40 08             	mov    0x8(%eax),%eax
  802253:	39 c2                	cmp    %eax,%edx
  802255:	73 65                	jae    8022bc <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802257:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80225b:	75 14                	jne    802271 <insert_sorted_allocList+0x131>
  80225d:	83 ec 04             	sub    $0x4,%esp
  802260:	68 d0 3a 80 00       	push   $0x803ad0
  802265:	6a 68                	push   $0x68
  802267:	68 f3 3a 80 00       	push   $0x803af3
  80226c:	e8 dd 0d 00 00       	call   80304e <_panic>
  802271:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802277:	8b 45 08             	mov    0x8(%ebp),%eax
  80227a:	89 10                	mov    %edx,(%eax)
  80227c:	8b 45 08             	mov    0x8(%ebp),%eax
  80227f:	8b 00                	mov    (%eax),%eax
  802281:	85 c0                	test   %eax,%eax
  802283:	74 0d                	je     802292 <insert_sorted_allocList+0x152>
  802285:	a1 40 40 80 00       	mov    0x804040,%eax
  80228a:	8b 55 08             	mov    0x8(%ebp),%edx
  80228d:	89 50 04             	mov    %edx,0x4(%eax)
  802290:	eb 08                	jmp    80229a <insert_sorted_allocList+0x15a>
  802292:	8b 45 08             	mov    0x8(%ebp),%eax
  802295:	a3 44 40 80 00       	mov    %eax,0x804044
  80229a:	8b 45 08             	mov    0x8(%ebp),%eax
  80229d:	a3 40 40 80 00       	mov    %eax,0x804040
  8022a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022ac:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022b1:	40                   	inc    %eax
  8022b2:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  8022b7:	e9 81 00 00 00       	jmp    80233d <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  8022bc:	a1 40 40 80 00       	mov    0x804040,%eax
  8022c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022c4:	eb 51                	jmp    802317 <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  8022c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c9:	8b 50 08             	mov    0x8(%eax),%edx
  8022cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cf:	8b 40 08             	mov    0x8(%eax),%eax
  8022d2:	39 c2                	cmp    %eax,%edx
  8022d4:	73 39                	jae    80230f <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  8022d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d9:	8b 40 04             	mov    0x4(%eax),%eax
  8022dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  8022df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8022e5:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  8022e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ea:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022ed:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  8022f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022f6:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  8022f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8022fe:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  802301:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802306:	40                   	inc    %eax
  802307:	a3 4c 40 80 00       	mov    %eax,0x80404c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  80230c:	90                   	nop
				}
			}
		 }

	}
}
  80230d:	eb 2e                	jmp    80233d <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  80230f:	a1 48 40 80 00       	mov    0x804048,%eax
  802314:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802317:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80231b:	74 07                	je     802324 <insert_sorted_allocList+0x1e4>
  80231d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802320:	8b 00                	mov    (%eax),%eax
  802322:	eb 05                	jmp    802329 <insert_sorted_allocList+0x1e9>
  802324:	b8 00 00 00 00       	mov    $0x0,%eax
  802329:	a3 48 40 80 00       	mov    %eax,0x804048
  80232e:	a1 48 40 80 00       	mov    0x804048,%eax
  802333:	85 c0                	test   %eax,%eax
  802335:	75 8f                	jne    8022c6 <insert_sorted_allocList+0x186>
  802337:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80233b:	75 89                	jne    8022c6 <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  80233d:	90                   	nop
  80233e:	c9                   	leave  
  80233f:	c3                   	ret    

00802340 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802340:	55                   	push   %ebp
  802341:	89 e5                	mov    %esp,%ebp
  802343:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802346:	a1 38 41 80 00       	mov    0x804138,%eax
  80234b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80234e:	e9 76 01 00 00       	jmp    8024c9 <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  802353:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802356:	8b 40 0c             	mov    0xc(%eax),%eax
  802359:	3b 45 08             	cmp    0x8(%ebp),%eax
  80235c:	0f 85 8a 00 00 00    	jne    8023ec <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  802362:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802366:	75 17                	jne    80237f <alloc_block_FF+0x3f>
  802368:	83 ec 04             	sub    $0x4,%esp
  80236b:	68 2f 3b 80 00       	push   $0x803b2f
  802370:	68 8a 00 00 00       	push   $0x8a
  802375:	68 f3 3a 80 00       	push   $0x803af3
  80237a:	e8 cf 0c 00 00       	call   80304e <_panic>
  80237f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802382:	8b 00                	mov    (%eax),%eax
  802384:	85 c0                	test   %eax,%eax
  802386:	74 10                	je     802398 <alloc_block_FF+0x58>
  802388:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238b:	8b 00                	mov    (%eax),%eax
  80238d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802390:	8b 52 04             	mov    0x4(%edx),%edx
  802393:	89 50 04             	mov    %edx,0x4(%eax)
  802396:	eb 0b                	jmp    8023a3 <alloc_block_FF+0x63>
  802398:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239b:	8b 40 04             	mov    0x4(%eax),%eax
  80239e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8023a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a6:	8b 40 04             	mov    0x4(%eax),%eax
  8023a9:	85 c0                	test   %eax,%eax
  8023ab:	74 0f                	je     8023bc <alloc_block_FF+0x7c>
  8023ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b0:	8b 40 04             	mov    0x4(%eax),%eax
  8023b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023b6:	8b 12                	mov    (%edx),%edx
  8023b8:	89 10                	mov    %edx,(%eax)
  8023ba:	eb 0a                	jmp    8023c6 <alloc_block_FF+0x86>
  8023bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bf:	8b 00                	mov    (%eax),%eax
  8023c1:	a3 38 41 80 00       	mov    %eax,0x804138
  8023c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023d9:	a1 44 41 80 00       	mov    0x804144,%eax
  8023de:	48                   	dec    %eax
  8023df:	a3 44 41 80 00       	mov    %eax,0x804144
			return element;
  8023e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e7:	e9 10 01 00 00       	jmp    8024fc <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  8023ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8023f2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023f5:	0f 86 c6 00 00 00    	jbe    8024c1 <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  8023fb:	a1 48 41 80 00       	mov    0x804148,%eax
  802400:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802403:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802407:	75 17                	jne    802420 <alloc_block_FF+0xe0>
  802409:	83 ec 04             	sub    $0x4,%esp
  80240c:	68 2f 3b 80 00       	push   $0x803b2f
  802411:	68 90 00 00 00       	push   $0x90
  802416:	68 f3 3a 80 00       	push   $0x803af3
  80241b:	e8 2e 0c 00 00       	call   80304e <_panic>
  802420:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802423:	8b 00                	mov    (%eax),%eax
  802425:	85 c0                	test   %eax,%eax
  802427:	74 10                	je     802439 <alloc_block_FF+0xf9>
  802429:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80242c:	8b 00                	mov    (%eax),%eax
  80242e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802431:	8b 52 04             	mov    0x4(%edx),%edx
  802434:	89 50 04             	mov    %edx,0x4(%eax)
  802437:	eb 0b                	jmp    802444 <alloc_block_FF+0x104>
  802439:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80243c:	8b 40 04             	mov    0x4(%eax),%eax
  80243f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802444:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802447:	8b 40 04             	mov    0x4(%eax),%eax
  80244a:	85 c0                	test   %eax,%eax
  80244c:	74 0f                	je     80245d <alloc_block_FF+0x11d>
  80244e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802451:	8b 40 04             	mov    0x4(%eax),%eax
  802454:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802457:	8b 12                	mov    (%edx),%edx
  802459:	89 10                	mov    %edx,(%eax)
  80245b:	eb 0a                	jmp    802467 <alloc_block_FF+0x127>
  80245d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802460:	8b 00                	mov    (%eax),%eax
  802462:	a3 48 41 80 00       	mov    %eax,0x804148
  802467:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80246a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802470:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802473:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80247a:	a1 54 41 80 00       	mov    0x804154,%eax
  80247f:	48                   	dec    %eax
  802480:	a3 54 41 80 00       	mov    %eax,0x804154
			 element1->size =size;
  802485:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802488:	8b 55 08             	mov    0x8(%ebp),%edx
  80248b:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  80248e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802491:	8b 50 08             	mov    0x8(%eax),%edx
  802494:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802497:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  80249a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249d:	8b 50 08             	mov    0x8(%eax),%edx
  8024a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a3:	01 c2                	add    %eax,%edx
  8024a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a8:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  8024ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8024b1:	2b 45 08             	sub    0x8(%ebp),%eax
  8024b4:	89 c2                	mov    %eax,%edx
  8024b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b9:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  8024bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024bf:	eb 3b                	jmp    8024fc <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  8024c1:	a1 40 41 80 00       	mov    0x804140,%eax
  8024c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024cd:	74 07                	je     8024d6 <alloc_block_FF+0x196>
  8024cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d2:	8b 00                	mov    (%eax),%eax
  8024d4:	eb 05                	jmp    8024db <alloc_block_FF+0x19b>
  8024d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8024db:	a3 40 41 80 00       	mov    %eax,0x804140
  8024e0:	a1 40 41 80 00       	mov    0x804140,%eax
  8024e5:	85 c0                	test   %eax,%eax
  8024e7:	0f 85 66 fe ff ff    	jne    802353 <alloc_block_FF+0x13>
  8024ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024f1:	0f 85 5c fe ff ff    	jne    802353 <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  8024f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024fc:	c9                   	leave  
  8024fd:	c3                   	ret    

008024fe <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8024fe:	55                   	push   %ebp
  8024ff:	89 e5                	mov    %esp,%ebp
  802501:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  802504:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  80250b:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  802512:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802519:	a1 38 41 80 00       	mov    0x804138,%eax
  80251e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802521:	e9 cf 00 00 00       	jmp    8025f5 <alloc_block_BF+0xf7>
		{
			c++;
  802526:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  802529:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252c:	8b 40 0c             	mov    0xc(%eax),%eax
  80252f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802532:	0f 85 8a 00 00 00    	jne    8025c2 <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  802538:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80253c:	75 17                	jne    802555 <alloc_block_BF+0x57>
  80253e:	83 ec 04             	sub    $0x4,%esp
  802541:	68 2f 3b 80 00       	push   $0x803b2f
  802546:	68 a8 00 00 00       	push   $0xa8
  80254b:	68 f3 3a 80 00       	push   $0x803af3
  802550:	e8 f9 0a 00 00       	call   80304e <_panic>
  802555:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802558:	8b 00                	mov    (%eax),%eax
  80255a:	85 c0                	test   %eax,%eax
  80255c:	74 10                	je     80256e <alloc_block_BF+0x70>
  80255e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802561:	8b 00                	mov    (%eax),%eax
  802563:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802566:	8b 52 04             	mov    0x4(%edx),%edx
  802569:	89 50 04             	mov    %edx,0x4(%eax)
  80256c:	eb 0b                	jmp    802579 <alloc_block_BF+0x7b>
  80256e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802571:	8b 40 04             	mov    0x4(%eax),%eax
  802574:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802579:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257c:	8b 40 04             	mov    0x4(%eax),%eax
  80257f:	85 c0                	test   %eax,%eax
  802581:	74 0f                	je     802592 <alloc_block_BF+0x94>
  802583:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802586:	8b 40 04             	mov    0x4(%eax),%eax
  802589:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80258c:	8b 12                	mov    (%edx),%edx
  80258e:	89 10                	mov    %edx,(%eax)
  802590:	eb 0a                	jmp    80259c <alloc_block_BF+0x9e>
  802592:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802595:	8b 00                	mov    (%eax),%eax
  802597:	a3 38 41 80 00       	mov    %eax,0x804138
  80259c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025af:	a1 44 41 80 00       	mov    0x804144,%eax
  8025b4:	48                   	dec    %eax
  8025b5:	a3 44 41 80 00       	mov    %eax,0x804144
				return block;
  8025ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bd:	e9 85 01 00 00       	jmp    802747 <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  8025c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8025c8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025cb:	76 20                	jbe    8025ed <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  8025cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8025d3:	2b 45 08             	sub    0x8(%ebp),%eax
  8025d6:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  8025d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8025dc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025df:	73 0c                	jae    8025ed <alloc_block_BF+0xef>
				{
					ma=tempi;
  8025e1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8025e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  8025e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ea:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8025ed:	a1 40 41 80 00       	mov    0x804140,%eax
  8025f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f9:	74 07                	je     802602 <alloc_block_BF+0x104>
  8025fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fe:	8b 00                	mov    (%eax),%eax
  802600:	eb 05                	jmp    802607 <alloc_block_BF+0x109>
  802602:	b8 00 00 00 00       	mov    $0x0,%eax
  802607:	a3 40 41 80 00       	mov    %eax,0x804140
  80260c:	a1 40 41 80 00       	mov    0x804140,%eax
  802611:	85 c0                	test   %eax,%eax
  802613:	0f 85 0d ff ff ff    	jne    802526 <alloc_block_BF+0x28>
  802619:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80261d:	0f 85 03 ff ff ff    	jne    802526 <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  802623:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  80262a:	a1 38 41 80 00       	mov    0x804138,%eax
  80262f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802632:	e9 dd 00 00 00       	jmp    802714 <alloc_block_BF+0x216>
		{
			if(x==sol)
  802637:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80263a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80263d:	0f 85 c6 00 00 00    	jne    802709 <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802643:	a1 48 41 80 00       	mov    0x804148,%eax
  802648:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  80264b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80264f:	75 17                	jne    802668 <alloc_block_BF+0x16a>
  802651:	83 ec 04             	sub    $0x4,%esp
  802654:	68 2f 3b 80 00       	push   $0x803b2f
  802659:	68 bb 00 00 00       	push   $0xbb
  80265e:	68 f3 3a 80 00       	push   $0x803af3
  802663:	e8 e6 09 00 00       	call   80304e <_panic>
  802668:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80266b:	8b 00                	mov    (%eax),%eax
  80266d:	85 c0                	test   %eax,%eax
  80266f:	74 10                	je     802681 <alloc_block_BF+0x183>
  802671:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802674:	8b 00                	mov    (%eax),%eax
  802676:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802679:	8b 52 04             	mov    0x4(%edx),%edx
  80267c:	89 50 04             	mov    %edx,0x4(%eax)
  80267f:	eb 0b                	jmp    80268c <alloc_block_BF+0x18e>
  802681:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802684:	8b 40 04             	mov    0x4(%eax),%eax
  802687:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80268c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80268f:	8b 40 04             	mov    0x4(%eax),%eax
  802692:	85 c0                	test   %eax,%eax
  802694:	74 0f                	je     8026a5 <alloc_block_BF+0x1a7>
  802696:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802699:	8b 40 04             	mov    0x4(%eax),%eax
  80269c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80269f:	8b 12                	mov    (%edx),%edx
  8026a1:	89 10                	mov    %edx,(%eax)
  8026a3:	eb 0a                	jmp    8026af <alloc_block_BF+0x1b1>
  8026a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026a8:	8b 00                	mov    (%eax),%eax
  8026aa:	a3 48 41 80 00       	mov    %eax,0x804148
  8026af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026bb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026c2:	a1 54 41 80 00       	mov    0x804154,%eax
  8026c7:	48                   	dec    %eax
  8026c8:	a3 54 41 80 00       	mov    %eax,0x804154
						 element1->size =size;
  8026cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8026d3:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  8026d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d9:	8b 50 08             	mov    0x8(%eax),%edx
  8026dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026df:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  8026e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e5:	8b 50 08             	mov    0x8(%eax),%edx
  8026e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026eb:	01 c2                	add    %eax,%edx
  8026ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f0:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  8026f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8026f9:	2b 45 08             	sub    0x8(%ebp),%eax
  8026fc:	89 c2                	mov    %eax,%edx
  8026fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802701:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  802704:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802707:	eb 3e                	jmp    802747 <alloc_block_BF+0x249>
						 break;
			}
			x++;
  802709:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  80270c:	a1 40 41 80 00       	mov    0x804140,%eax
  802711:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802714:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802718:	74 07                	je     802721 <alloc_block_BF+0x223>
  80271a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271d:	8b 00                	mov    (%eax),%eax
  80271f:	eb 05                	jmp    802726 <alloc_block_BF+0x228>
  802721:	b8 00 00 00 00       	mov    $0x0,%eax
  802726:	a3 40 41 80 00       	mov    %eax,0x804140
  80272b:	a1 40 41 80 00       	mov    0x804140,%eax
  802730:	85 c0                	test   %eax,%eax
  802732:	0f 85 ff fe ff ff    	jne    802637 <alloc_block_BF+0x139>
  802738:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80273c:	0f 85 f5 fe ff ff    	jne    802637 <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  802742:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802747:	c9                   	leave  
  802748:	c3                   	ret    

00802749 <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802749:	55                   	push   %ebp
  80274a:	89 e5                	mov    %esp,%ebp
  80274c:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  80274f:	a1 28 40 80 00       	mov    0x804028,%eax
  802754:	85 c0                	test   %eax,%eax
  802756:	75 14                	jne    80276c <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  802758:	a1 38 41 80 00       	mov    0x804138,%eax
  80275d:	a3 5c 41 80 00       	mov    %eax,0x80415c
		hh=1;
  802762:	c7 05 28 40 80 00 01 	movl   $0x1,0x804028
  802769:	00 00 00 
	}
	uint32 c=1;
  80276c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  802773:	a1 5c 41 80 00       	mov    0x80415c,%eax
  802778:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  80277b:	e9 b3 01 00 00       	jmp    802933 <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  802780:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802783:	8b 40 0c             	mov    0xc(%eax),%eax
  802786:	3b 45 08             	cmp    0x8(%ebp),%eax
  802789:	0f 85 a9 00 00 00    	jne    802838 <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  80278f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802792:	8b 00                	mov    (%eax),%eax
  802794:	85 c0                	test   %eax,%eax
  802796:	75 0c                	jne    8027a4 <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  802798:	a1 38 41 80 00       	mov    0x804138,%eax
  80279d:	a3 5c 41 80 00       	mov    %eax,0x80415c
  8027a2:	eb 0a                	jmp    8027ae <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  8027a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a7:	8b 00                	mov    (%eax),%eax
  8027a9:	a3 5c 41 80 00       	mov    %eax,0x80415c
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  8027ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027b2:	75 17                	jne    8027cb <alloc_block_NF+0x82>
  8027b4:	83 ec 04             	sub    $0x4,%esp
  8027b7:	68 2f 3b 80 00       	push   $0x803b2f
  8027bc:	68 e3 00 00 00       	push   $0xe3
  8027c1:	68 f3 3a 80 00       	push   $0x803af3
  8027c6:	e8 83 08 00 00       	call   80304e <_panic>
  8027cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ce:	8b 00                	mov    (%eax),%eax
  8027d0:	85 c0                	test   %eax,%eax
  8027d2:	74 10                	je     8027e4 <alloc_block_NF+0x9b>
  8027d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d7:	8b 00                	mov    (%eax),%eax
  8027d9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027dc:	8b 52 04             	mov    0x4(%edx),%edx
  8027df:	89 50 04             	mov    %edx,0x4(%eax)
  8027e2:	eb 0b                	jmp    8027ef <alloc_block_NF+0xa6>
  8027e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e7:	8b 40 04             	mov    0x4(%eax),%eax
  8027ea:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f2:	8b 40 04             	mov    0x4(%eax),%eax
  8027f5:	85 c0                	test   %eax,%eax
  8027f7:	74 0f                	je     802808 <alloc_block_NF+0xbf>
  8027f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027fc:	8b 40 04             	mov    0x4(%eax),%eax
  8027ff:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802802:	8b 12                	mov    (%edx),%edx
  802804:	89 10                	mov    %edx,(%eax)
  802806:	eb 0a                	jmp    802812 <alloc_block_NF+0xc9>
  802808:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80280b:	8b 00                	mov    (%eax),%eax
  80280d:	a3 38 41 80 00       	mov    %eax,0x804138
  802812:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802815:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80281b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80281e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802825:	a1 44 41 80 00       	mov    0x804144,%eax
  80282a:	48                   	dec    %eax
  80282b:	a3 44 41 80 00       	mov    %eax,0x804144
				return element;
  802830:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802833:	e9 0e 01 00 00       	jmp    802946 <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  802838:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80283b:	8b 40 0c             	mov    0xc(%eax),%eax
  80283e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802841:	0f 86 ce 00 00 00    	jbe    802915 <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802847:	a1 48 41 80 00       	mov    0x804148,%eax
  80284c:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  80284f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802853:	75 17                	jne    80286c <alloc_block_NF+0x123>
  802855:	83 ec 04             	sub    $0x4,%esp
  802858:	68 2f 3b 80 00       	push   $0x803b2f
  80285d:	68 e9 00 00 00       	push   $0xe9
  802862:	68 f3 3a 80 00       	push   $0x803af3
  802867:	e8 e2 07 00 00       	call   80304e <_panic>
  80286c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80286f:	8b 00                	mov    (%eax),%eax
  802871:	85 c0                	test   %eax,%eax
  802873:	74 10                	je     802885 <alloc_block_NF+0x13c>
  802875:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802878:	8b 00                	mov    (%eax),%eax
  80287a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80287d:	8b 52 04             	mov    0x4(%edx),%edx
  802880:	89 50 04             	mov    %edx,0x4(%eax)
  802883:	eb 0b                	jmp    802890 <alloc_block_NF+0x147>
  802885:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802888:	8b 40 04             	mov    0x4(%eax),%eax
  80288b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802890:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802893:	8b 40 04             	mov    0x4(%eax),%eax
  802896:	85 c0                	test   %eax,%eax
  802898:	74 0f                	je     8028a9 <alloc_block_NF+0x160>
  80289a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80289d:	8b 40 04             	mov    0x4(%eax),%eax
  8028a0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028a3:	8b 12                	mov    (%edx),%edx
  8028a5:	89 10                	mov    %edx,(%eax)
  8028a7:	eb 0a                	jmp    8028b3 <alloc_block_NF+0x16a>
  8028a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ac:	8b 00                	mov    (%eax),%eax
  8028ae:	a3 48 41 80 00       	mov    %eax,0x804148
  8028b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028bf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028c6:	a1 54 41 80 00       	mov    0x804154,%eax
  8028cb:	48                   	dec    %eax
  8028cc:	a3 54 41 80 00       	mov    %eax,0x804154
				 element1->size =size;
  8028d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8028d7:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  8028da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028dd:	8b 50 08             	mov    0x8(%eax),%edx
  8028e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028e3:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  8028e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e9:	8b 50 08             	mov    0x8(%eax),%edx
  8028ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ef:	01 c2                	add    %eax,%edx
  8028f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f4:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  8028f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8028fd:	2b 45 08             	sub    0x8(%ebp),%eax
  802900:	89 c2                	mov    %eax,%edx
  802902:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802905:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  802908:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80290b:	a3 5c 41 80 00       	mov    %eax,0x80415c
				 return element1;
  802910:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802913:	eb 31                	jmp    802946 <alloc_block_NF+0x1fd>
			 }
		 c++;
  802915:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  802918:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80291b:	8b 00                	mov    (%eax),%eax
  80291d:	85 c0                	test   %eax,%eax
  80291f:	75 0a                	jne    80292b <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  802921:	a1 38 41 80 00       	mov    0x804138,%eax
  802926:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802929:	eb 08                	jmp    802933 <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  80292b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80292e:	8b 00                	mov    (%eax),%eax
  802930:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802933:	a1 44 41 80 00       	mov    0x804144,%eax
  802938:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80293b:	0f 85 3f fe ff ff    	jne    802780 <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  802941:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802946:	c9                   	leave  
  802947:	c3                   	ret    

00802948 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802948:	55                   	push   %ebp
  802949:	89 e5                	mov    %esp,%ebp
  80294b:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  80294e:	a1 44 41 80 00       	mov    0x804144,%eax
  802953:	85 c0                	test   %eax,%eax
  802955:	75 68                	jne    8029bf <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802957:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80295b:	75 17                	jne    802974 <insert_sorted_with_merge_freeList+0x2c>
  80295d:	83 ec 04             	sub    $0x4,%esp
  802960:	68 d0 3a 80 00       	push   $0x803ad0
  802965:	68 0e 01 00 00       	push   $0x10e
  80296a:	68 f3 3a 80 00       	push   $0x803af3
  80296f:	e8 da 06 00 00       	call   80304e <_panic>
  802974:	8b 15 38 41 80 00    	mov    0x804138,%edx
  80297a:	8b 45 08             	mov    0x8(%ebp),%eax
  80297d:	89 10                	mov    %edx,(%eax)
  80297f:	8b 45 08             	mov    0x8(%ebp),%eax
  802982:	8b 00                	mov    (%eax),%eax
  802984:	85 c0                	test   %eax,%eax
  802986:	74 0d                	je     802995 <insert_sorted_with_merge_freeList+0x4d>
  802988:	a1 38 41 80 00       	mov    0x804138,%eax
  80298d:	8b 55 08             	mov    0x8(%ebp),%edx
  802990:	89 50 04             	mov    %edx,0x4(%eax)
  802993:	eb 08                	jmp    80299d <insert_sorted_with_merge_freeList+0x55>
  802995:	8b 45 08             	mov    0x8(%ebp),%eax
  802998:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80299d:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a0:	a3 38 41 80 00       	mov    %eax,0x804138
  8029a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029af:	a1 44 41 80 00       	mov    0x804144,%eax
  8029b4:	40                   	inc    %eax
  8029b5:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  8029ba:	e9 8c 06 00 00       	jmp    80304b <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  8029bf:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  8029c7:	a1 38 41 80 00       	mov    0x804138,%eax
  8029cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  8029cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d2:	8b 50 08             	mov    0x8(%eax),%edx
  8029d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d8:	8b 40 08             	mov    0x8(%eax),%eax
  8029db:	39 c2                	cmp    %eax,%edx
  8029dd:	0f 86 14 01 00 00    	jbe    802af7 <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  8029e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e6:	8b 50 0c             	mov    0xc(%eax),%edx
  8029e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ec:	8b 40 08             	mov    0x8(%eax),%eax
  8029ef:	01 c2                	add    %eax,%edx
  8029f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f4:	8b 40 08             	mov    0x8(%eax),%eax
  8029f7:	39 c2                	cmp    %eax,%edx
  8029f9:	0f 85 90 00 00 00    	jne    802a8f <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  8029ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a02:	8b 50 0c             	mov    0xc(%eax),%edx
  802a05:	8b 45 08             	mov    0x8(%ebp),%eax
  802a08:	8b 40 0c             	mov    0xc(%eax),%eax
  802a0b:	01 c2                	add    %eax,%edx
  802a0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a10:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802a13:	8b 45 08             	mov    0x8(%ebp),%eax
  802a16:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a20:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802a27:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a2b:	75 17                	jne    802a44 <insert_sorted_with_merge_freeList+0xfc>
  802a2d:	83 ec 04             	sub    $0x4,%esp
  802a30:	68 d0 3a 80 00       	push   $0x803ad0
  802a35:	68 1b 01 00 00       	push   $0x11b
  802a3a:	68 f3 3a 80 00       	push   $0x803af3
  802a3f:	e8 0a 06 00 00       	call   80304e <_panic>
  802a44:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4d:	89 10                	mov    %edx,(%eax)
  802a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a52:	8b 00                	mov    (%eax),%eax
  802a54:	85 c0                	test   %eax,%eax
  802a56:	74 0d                	je     802a65 <insert_sorted_with_merge_freeList+0x11d>
  802a58:	a1 48 41 80 00       	mov    0x804148,%eax
  802a5d:	8b 55 08             	mov    0x8(%ebp),%edx
  802a60:	89 50 04             	mov    %edx,0x4(%eax)
  802a63:	eb 08                	jmp    802a6d <insert_sorted_with_merge_freeList+0x125>
  802a65:	8b 45 08             	mov    0x8(%ebp),%eax
  802a68:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a70:	a3 48 41 80 00       	mov    %eax,0x804148
  802a75:	8b 45 08             	mov    0x8(%ebp),%eax
  802a78:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a7f:	a1 54 41 80 00       	mov    0x804154,%eax
  802a84:	40                   	inc    %eax
  802a85:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802a8a:	e9 bc 05 00 00       	jmp    80304b <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802a8f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a93:	75 17                	jne    802aac <insert_sorted_with_merge_freeList+0x164>
  802a95:	83 ec 04             	sub    $0x4,%esp
  802a98:	68 0c 3b 80 00       	push   $0x803b0c
  802a9d:	68 1f 01 00 00       	push   $0x11f
  802aa2:	68 f3 3a 80 00       	push   $0x803af3
  802aa7:	e8 a2 05 00 00       	call   80304e <_panic>
  802aac:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab5:	89 50 04             	mov    %edx,0x4(%eax)
  802ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  802abb:	8b 40 04             	mov    0x4(%eax),%eax
  802abe:	85 c0                	test   %eax,%eax
  802ac0:	74 0c                	je     802ace <insert_sorted_with_merge_freeList+0x186>
  802ac2:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ac7:	8b 55 08             	mov    0x8(%ebp),%edx
  802aca:	89 10                	mov    %edx,(%eax)
  802acc:	eb 08                	jmp    802ad6 <insert_sorted_with_merge_freeList+0x18e>
  802ace:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad1:	a3 38 41 80 00       	mov    %eax,0x804138
  802ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ade:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ae7:	a1 44 41 80 00       	mov    0x804144,%eax
  802aec:	40                   	inc    %eax
  802aed:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802af2:	e9 54 05 00 00       	jmp    80304b <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  802af7:	8b 45 08             	mov    0x8(%ebp),%eax
  802afa:	8b 50 08             	mov    0x8(%eax),%edx
  802afd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b00:	8b 40 08             	mov    0x8(%eax),%eax
  802b03:	39 c2                	cmp    %eax,%edx
  802b05:	0f 83 20 01 00 00    	jae    802c2b <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  802b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0e:	8b 50 0c             	mov    0xc(%eax),%edx
  802b11:	8b 45 08             	mov    0x8(%ebp),%eax
  802b14:	8b 40 08             	mov    0x8(%eax),%eax
  802b17:	01 c2                	add    %eax,%edx
  802b19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b1c:	8b 40 08             	mov    0x8(%eax),%eax
  802b1f:	39 c2                	cmp    %eax,%edx
  802b21:	0f 85 9c 00 00 00    	jne    802bc3 <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  802b27:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2a:	8b 50 08             	mov    0x8(%eax),%edx
  802b2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b30:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  802b33:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b36:	8b 50 0c             	mov    0xc(%eax),%edx
  802b39:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3c:	8b 40 0c             	mov    0xc(%eax),%eax
  802b3f:	01 c2                	add    %eax,%edx
  802b41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b44:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802b47:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802b51:	8b 45 08             	mov    0x8(%ebp),%eax
  802b54:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802b5b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b5f:	75 17                	jne    802b78 <insert_sorted_with_merge_freeList+0x230>
  802b61:	83 ec 04             	sub    $0x4,%esp
  802b64:	68 d0 3a 80 00       	push   $0x803ad0
  802b69:	68 2a 01 00 00       	push   $0x12a
  802b6e:	68 f3 3a 80 00       	push   $0x803af3
  802b73:	e8 d6 04 00 00       	call   80304e <_panic>
  802b78:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b81:	89 10                	mov    %edx,(%eax)
  802b83:	8b 45 08             	mov    0x8(%ebp),%eax
  802b86:	8b 00                	mov    (%eax),%eax
  802b88:	85 c0                	test   %eax,%eax
  802b8a:	74 0d                	je     802b99 <insert_sorted_with_merge_freeList+0x251>
  802b8c:	a1 48 41 80 00       	mov    0x804148,%eax
  802b91:	8b 55 08             	mov    0x8(%ebp),%edx
  802b94:	89 50 04             	mov    %edx,0x4(%eax)
  802b97:	eb 08                	jmp    802ba1 <insert_sorted_with_merge_freeList+0x259>
  802b99:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba4:	a3 48 41 80 00       	mov    %eax,0x804148
  802ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bb3:	a1 54 41 80 00       	mov    0x804154,%eax
  802bb8:	40                   	inc    %eax
  802bb9:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802bbe:	e9 88 04 00 00       	jmp    80304b <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802bc3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bc7:	75 17                	jne    802be0 <insert_sorted_with_merge_freeList+0x298>
  802bc9:	83 ec 04             	sub    $0x4,%esp
  802bcc:	68 d0 3a 80 00       	push   $0x803ad0
  802bd1:	68 2e 01 00 00       	push   $0x12e
  802bd6:	68 f3 3a 80 00       	push   $0x803af3
  802bdb:	e8 6e 04 00 00       	call   80304e <_panic>
  802be0:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802be6:	8b 45 08             	mov    0x8(%ebp),%eax
  802be9:	89 10                	mov    %edx,(%eax)
  802beb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bee:	8b 00                	mov    (%eax),%eax
  802bf0:	85 c0                	test   %eax,%eax
  802bf2:	74 0d                	je     802c01 <insert_sorted_with_merge_freeList+0x2b9>
  802bf4:	a1 38 41 80 00       	mov    0x804138,%eax
  802bf9:	8b 55 08             	mov    0x8(%ebp),%edx
  802bfc:	89 50 04             	mov    %edx,0x4(%eax)
  802bff:	eb 08                	jmp    802c09 <insert_sorted_with_merge_freeList+0x2c1>
  802c01:	8b 45 08             	mov    0x8(%ebp),%eax
  802c04:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c09:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0c:	a3 38 41 80 00       	mov    %eax,0x804138
  802c11:	8b 45 08             	mov    0x8(%ebp),%eax
  802c14:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c1b:	a1 44 41 80 00       	mov    0x804144,%eax
  802c20:	40                   	inc    %eax
  802c21:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802c26:	e9 20 04 00 00       	jmp    80304b <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  802c2b:	a1 38 41 80 00       	mov    0x804138,%eax
  802c30:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c33:	e9 e2 03 00 00       	jmp    80301a <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  802c38:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3b:	8b 50 08             	mov    0x8(%eax),%edx
  802c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c41:	8b 40 08             	mov    0x8(%eax),%eax
  802c44:	39 c2                	cmp    %eax,%edx
  802c46:	0f 83 c6 03 00 00    	jae    803012 <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  802c4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4f:	8b 40 04             	mov    0x4(%eax),%eax
  802c52:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  802c55:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c58:	8b 50 08             	mov    0x8(%eax),%edx
  802c5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c5e:	8b 40 0c             	mov    0xc(%eax),%eax
  802c61:	01 d0                	add    %edx,%eax
  802c63:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  802c66:	8b 45 08             	mov    0x8(%ebp),%eax
  802c69:	8b 50 0c             	mov    0xc(%eax),%edx
  802c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6f:	8b 40 08             	mov    0x8(%eax),%eax
  802c72:	01 d0                	add    %edx,%eax
  802c74:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  802c77:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7a:	8b 40 08             	mov    0x8(%eax),%eax
  802c7d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802c80:	74 7a                	je     802cfc <insert_sorted_with_merge_freeList+0x3b4>
  802c82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c85:	8b 40 08             	mov    0x8(%eax),%eax
  802c88:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802c8b:	74 6f                	je     802cfc <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  802c8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c91:	74 06                	je     802c99 <insert_sorted_with_merge_freeList+0x351>
  802c93:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c97:	75 17                	jne    802cb0 <insert_sorted_with_merge_freeList+0x368>
  802c99:	83 ec 04             	sub    $0x4,%esp
  802c9c:	68 50 3b 80 00       	push   $0x803b50
  802ca1:	68 43 01 00 00       	push   $0x143
  802ca6:	68 f3 3a 80 00       	push   $0x803af3
  802cab:	e8 9e 03 00 00       	call   80304e <_panic>
  802cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb3:	8b 50 04             	mov    0x4(%eax),%edx
  802cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb9:	89 50 04             	mov    %edx,0x4(%eax)
  802cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cc2:	89 10                	mov    %edx,(%eax)
  802cc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc7:	8b 40 04             	mov    0x4(%eax),%eax
  802cca:	85 c0                	test   %eax,%eax
  802ccc:	74 0d                	je     802cdb <insert_sorted_with_merge_freeList+0x393>
  802cce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd1:	8b 40 04             	mov    0x4(%eax),%eax
  802cd4:	8b 55 08             	mov    0x8(%ebp),%edx
  802cd7:	89 10                	mov    %edx,(%eax)
  802cd9:	eb 08                	jmp    802ce3 <insert_sorted_with_merge_freeList+0x39b>
  802cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cde:	a3 38 41 80 00       	mov    %eax,0x804138
  802ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce6:	8b 55 08             	mov    0x8(%ebp),%edx
  802ce9:	89 50 04             	mov    %edx,0x4(%eax)
  802cec:	a1 44 41 80 00       	mov    0x804144,%eax
  802cf1:	40                   	inc    %eax
  802cf2:	a3 44 41 80 00       	mov    %eax,0x804144
  802cf7:	e9 14 03 00 00       	jmp    803010 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  802cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cff:	8b 40 08             	mov    0x8(%eax),%eax
  802d02:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802d05:	0f 85 a0 01 00 00    	jne    802eab <insert_sorted_with_merge_freeList+0x563>
  802d0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0e:	8b 40 08             	mov    0x8(%eax),%eax
  802d11:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802d14:	0f 85 91 01 00 00    	jne    802eab <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  802d1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d1d:	8b 50 0c             	mov    0xc(%eax),%edx
  802d20:	8b 45 08             	mov    0x8(%ebp),%eax
  802d23:	8b 48 0c             	mov    0xc(%eax),%ecx
  802d26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d29:	8b 40 0c             	mov    0xc(%eax),%eax
  802d2c:	01 c8                	add    %ecx,%eax
  802d2e:	01 c2                	add    %eax,%edx
  802d30:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d33:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802d36:	8b 45 08             	mov    0x8(%ebp),%eax
  802d39:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802d40:	8b 45 08             	mov    0x8(%ebp),%eax
  802d43:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  802d4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  802d54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d57:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802d5e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d62:	75 17                	jne    802d7b <insert_sorted_with_merge_freeList+0x433>
  802d64:	83 ec 04             	sub    $0x4,%esp
  802d67:	68 d0 3a 80 00       	push   $0x803ad0
  802d6c:	68 4d 01 00 00       	push   $0x14d
  802d71:	68 f3 3a 80 00       	push   $0x803af3
  802d76:	e8 d3 02 00 00       	call   80304e <_panic>
  802d7b:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d81:	8b 45 08             	mov    0x8(%ebp),%eax
  802d84:	89 10                	mov    %edx,(%eax)
  802d86:	8b 45 08             	mov    0x8(%ebp),%eax
  802d89:	8b 00                	mov    (%eax),%eax
  802d8b:	85 c0                	test   %eax,%eax
  802d8d:	74 0d                	je     802d9c <insert_sorted_with_merge_freeList+0x454>
  802d8f:	a1 48 41 80 00       	mov    0x804148,%eax
  802d94:	8b 55 08             	mov    0x8(%ebp),%edx
  802d97:	89 50 04             	mov    %edx,0x4(%eax)
  802d9a:	eb 08                	jmp    802da4 <insert_sorted_with_merge_freeList+0x45c>
  802d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802da4:	8b 45 08             	mov    0x8(%ebp),%eax
  802da7:	a3 48 41 80 00       	mov    %eax,0x804148
  802dac:	8b 45 08             	mov    0x8(%ebp),%eax
  802daf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802db6:	a1 54 41 80 00       	mov    0x804154,%eax
  802dbb:	40                   	inc    %eax
  802dbc:	a3 54 41 80 00       	mov    %eax,0x804154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  802dc1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dc5:	75 17                	jne    802dde <insert_sorted_with_merge_freeList+0x496>
  802dc7:	83 ec 04             	sub    $0x4,%esp
  802dca:	68 2f 3b 80 00       	push   $0x803b2f
  802dcf:	68 4e 01 00 00       	push   $0x14e
  802dd4:	68 f3 3a 80 00       	push   $0x803af3
  802dd9:	e8 70 02 00 00       	call   80304e <_panic>
  802dde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de1:	8b 00                	mov    (%eax),%eax
  802de3:	85 c0                	test   %eax,%eax
  802de5:	74 10                	je     802df7 <insert_sorted_with_merge_freeList+0x4af>
  802de7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dea:	8b 00                	mov    (%eax),%eax
  802dec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802def:	8b 52 04             	mov    0x4(%edx),%edx
  802df2:	89 50 04             	mov    %edx,0x4(%eax)
  802df5:	eb 0b                	jmp    802e02 <insert_sorted_with_merge_freeList+0x4ba>
  802df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfa:	8b 40 04             	mov    0x4(%eax),%eax
  802dfd:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e05:	8b 40 04             	mov    0x4(%eax),%eax
  802e08:	85 c0                	test   %eax,%eax
  802e0a:	74 0f                	je     802e1b <insert_sorted_with_merge_freeList+0x4d3>
  802e0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0f:	8b 40 04             	mov    0x4(%eax),%eax
  802e12:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e15:	8b 12                	mov    (%edx),%edx
  802e17:	89 10                	mov    %edx,(%eax)
  802e19:	eb 0a                	jmp    802e25 <insert_sorted_with_merge_freeList+0x4dd>
  802e1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1e:	8b 00                	mov    (%eax),%eax
  802e20:	a3 38 41 80 00       	mov    %eax,0x804138
  802e25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e28:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e31:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e38:	a1 44 41 80 00       	mov    0x804144,%eax
  802e3d:	48                   	dec    %eax
  802e3e:	a3 44 41 80 00       	mov    %eax,0x804144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  802e43:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e47:	75 17                	jne    802e60 <insert_sorted_with_merge_freeList+0x518>
  802e49:	83 ec 04             	sub    $0x4,%esp
  802e4c:	68 d0 3a 80 00       	push   $0x803ad0
  802e51:	68 4f 01 00 00       	push   $0x14f
  802e56:	68 f3 3a 80 00       	push   $0x803af3
  802e5b:	e8 ee 01 00 00       	call   80304e <_panic>
  802e60:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e69:	89 10                	mov    %edx,(%eax)
  802e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6e:	8b 00                	mov    (%eax),%eax
  802e70:	85 c0                	test   %eax,%eax
  802e72:	74 0d                	je     802e81 <insert_sorted_with_merge_freeList+0x539>
  802e74:	a1 48 41 80 00       	mov    0x804148,%eax
  802e79:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e7c:	89 50 04             	mov    %edx,0x4(%eax)
  802e7f:	eb 08                	jmp    802e89 <insert_sorted_with_merge_freeList+0x541>
  802e81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e84:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8c:	a3 48 41 80 00       	mov    %eax,0x804148
  802e91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e94:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e9b:	a1 54 41 80 00       	mov    0x804154,%eax
  802ea0:	40                   	inc    %eax
  802ea1:	a3 54 41 80 00       	mov    %eax,0x804154
  802ea6:	e9 65 01 00 00       	jmp    803010 <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  802eab:	8b 45 08             	mov    0x8(%ebp),%eax
  802eae:	8b 40 08             	mov    0x8(%eax),%eax
  802eb1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802eb4:	0f 85 9f 00 00 00    	jne    802f59 <insert_sorted_with_merge_freeList+0x611>
  802eba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebd:	8b 40 08             	mov    0x8(%eax),%eax
  802ec0:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802ec3:	0f 84 90 00 00 00    	je     802f59 <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  802ec9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ecc:	8b 50 0c             	mov    0xc(%eax),%edx
  802ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed5:	01 c2                	add    %eax,%edx
  802ed7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eda:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802edd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eea:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802ef1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ef5:	75 17                	jne    802f0e <insert_sorted_with_merge_freeList+0x5c6>
  802ef7:	83 ec 04             	sub    $0x4,%esp
  802efa:	68 d0 3a 80 00       	push   $0x803ad0
  802eff:	68 58 01 00 00       	push   $0x158
  802f04:	68 f3 3a 80 00       	push   $0x803af3
  802f09:	e8 40 01 00 00       	call   80304e <_panic>
  802f0e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f14:	8b 45 08             	mov    0x8(%ebp),%eax
  802f17:	89 10                	mov    %edx,(%eax)
  802f19:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1c:	8b 00                	mov    (%eax),%eax
  802f1e:	85 c0                	test   %eax,%eax
  802f20:	74 0d                	je     802f2f <insert_sorted_with_merge_freeList+0x5e7>
  802f22:	a1 48 41 80 00       	mov    0x804148,%eax
  802f27:	8b 55 08             	mov    0x8(%ebp),%edx
  802f2a:	89 50 04             	mov    %edx,0x4(%eax)
  802f2d:	eb 08                	jmp    802f37 <insert_sorted_with_merge_freeList+0x5ef>
  802f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f32:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f37:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3a:	a3 48 41 80 00       	mov    %eax,0x804148
  802f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f42:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f49:	a1 54 41 80 00       	mov    0x804154,%eax
  802f4e:	40                   	inc    %eax
  802f4f:	a3 54 41 80 00       	mov    %eax,0x804154
  802f54:	e9 b7 00 00 00       	jmp    803010 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  802f59:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5c:	8b 40 08             	mov    0x8(%eax),%eax
  802f5f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802f62:	0f 84 e2 00 00 00    	je     80304a <insert_sorted_with_merge_freeList+0x702>
  802f68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6b:	8b 40 08             	mov    0x8(%eax),%eax
  802f6e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802f71:	0f 85 d3 00 00 00    	jne    80304a <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  802f77:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7a:	8b 50 08             	mov    0x8(%eax),%edx
  802f7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f80:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  802f83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f86:	8b 50 0c             	mov    0xc(%eax),%edx
  802f89:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8c:	8b 40 0c             	mov    0xc(%eax),%eax
  802f8f:	01 c2                	add    %eax,%edx
  802f91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f94:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802f97:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802fab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802faf:	75 17                	jne    802fc8 <insert_sorted_with_merge_freeList+0x680>
  802fb1:	83 ec 04             	sub    $0x4,%esp
  802fb4:	68 d0 3a 80 00       	push   $0x803ad0
  802fb9:	68 61 01 00 00       	push   $0x161
  802fbe:	68 f3 3a 80 00       	push   $0x803af3
  802fc3:	e8 86 00 00 00       	call   80304e <_panic>
  802fc8:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802fce:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd1:	89 10                	mov    %edx,(%eax)
  802fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd6:	8b 00                	mov    (%eax),%eax
  802fd8:	85 c0                	test   %eax,%eax
  802fda:	74 0d                	je     802fe9 <insert_sorted_with_merge_freeList+0x6a1>
  802fdc:	a1 48 41 80 00       	mov    0x804148,%eax
  802fe1:	8b 55 08             	mov    0x8(%ebp),%edx
  802fe4:	89 50 04             	mov    %edx,0x4(%eax)
  802fe7:	eb 08                	jmp    802ff1 <insert_sorted_with_merge_freeList+0x6a9>
  802fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fec:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff4:	a3 48 41 80 00       	mov    %eax,0x804148
  802ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803003:	a1 54 41 80 00       	mov    0x804154,%eax
  803008:	40                   	inc    %eax
  803009:	a3 54 41 80 00       	mov    %eax,0x804154
								}
								break;
  80300e:	eb 3a                	jmp    80304a <insert_sorted_with_merge_freeList+0x702>
  803010:	eb 38                	jmp    80304a <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  803012:	a1 40 41 80 00       	mov    0x804140,%eax
  803017:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80301a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80301e:	74 07                	je     803027 <insert_sorted_with_merge_freeList+0x6df>
  803020:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803023:	8b 00                	mov    (%eax),%eax
  803025:	eb 05                	jmp    80302c <insert_sorted_with_merge_freeList+0x6e4>
  803027:	b8 00 00 00 00       	mov    $0x0,%eax
  80302c:	a3 40 41 80 00       	mov    %eax,0x804140
  803031:	a1 40 41 80 00       	mov    0x804140,%eax
  803036:	85 c0                	test   %eax,%eax
  803038:	0f 85 fa fb ff ff    	jne    802c38 <insert_sorted_with_merge_freeList+0x2f0>
  80303e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803042:	0f 85 f0 fb ff ff    	jne    802c38 <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  803048:	eb 01                	jmp    80304b <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  80304a:	90                   	nop
							}

						}
		          }
		}
}
  80304b:	90                   	nop
  80304c:	c9                   	leave  
  80304d:	c3                   	ret    

0080304e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80304e:	55                   	push   %ebp
  80304f:	89 e5                	mov    %esp,%ebp
  803051:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803054:	8d 45 10             	lea    0x10(%ebp),%eax
  803057:	83 c0 04             	add    $0x4,%eax
  80305a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80305d:	a1 60 41 80 00       	mov    0x804160,%eax
  803062:	85 c0                	test   %eax,%eax
  803064:	74 16                	je     80307c <_panic+0x2e>
		cprintf("%s: ", argv0);
  803066:	a1 60 41 80 00       	mov    0x804160,%eax
  80306b:	83 ec 08             	sub    $0x8,%esp
  80306e:	50                   	push   %eax
  80306f:	68 88 3b 80 00       	push   $0x803b88
  803074:	e8 ed d4 ff ff       	call   800566 <cprintf>
  803079:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80307c:	a1 00 40 80 00       	mov    0x804000,%eax
  803081:	ff 75 0c             	pushl  0xc(%ebp)
  803084:	ff 75 08             	pushl  0x8(%ebp)
  803087:	50                   	push   %eax
  803088:	68 8d 3b 80 00       	push   $0x803b8d
  80308d:	e8 d4 d4 ff ff       	call   800566 <cprintf>
  803092:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803095:	8b 45 10             	mov    0x10(%ebp),%eax
  803098:	83 ec 08             	sub    $0x8,%esp
  80309b:	ff 75 f4             	pushl  -0xc(%ebp)
  80309e:	50                   	push   %eax
  80309f:	e8 57 d4 ff ff       	call   8004fb <vcprintf>
  8030a4:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8030a7:	83 ec 08             	sub    $0x8,%esp
  8030aa:	6a 00                	push   $0x0
  8030ac:	68 a9 3b 80 00       	push   $0x803ba9
  8030b1:	e8 45 d4 ff ff       	call   8004fb <vcprintf>
  8030b6:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8030b9:	e8 c6 d3 ff ff       	call   800484 <exit>

	// should not return here
	while (1) ;
  8030be:	eb fe                	jmp    8030be <_panic+0x70>

008030c0 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8030c0:	55                   	push   %ebp
  8030c1:	89 e5                	mov    %esp,%ebp
  8030c3:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8030c6:	a1 20 40 80 00       	mov    0x804020,%eax
  8030cb:	8b 50 74             	mov    0x74(%eax),%edx
  8030ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030d1:	39 c2                	cmp    %eax,%edx
  8030d3:	74 14                	je     8030e9 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8030d5:	83 ec 04             	sub    $0x4,%esp
  8030d8:	68 ac 3b 80 00       	push   $0x803bac
  8030dd:	6a 26                	push   $0x26
  8030df:	68 f8 3b 80 00       	push   $0x803bf8
  8030e4:	e8 65 ff ff ff       	call   80304e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8030e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8030f0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8030f7:	e9 c2 00 00 00       	jmp    8031be <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8030fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030ff:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803106:	8b 45 08             	mov    0x8(%ebp),%eax
  803109:	01 d0                	add    %edx,%eax
  80310b:	8b 00                	mov    (%eax),%eax
  80310d:	85 c0                	test   %eax,%eax
  80310f:	75 08                	jne    803119 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  803111:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803114:	e9 a2 00 00 00       	jmp    8031bb <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  803119:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803120:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803127:	eb 69                	jmp    803192 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803129:	a1 20 40 80 00       	mov    0x804020,%eax
  80312e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803134:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803137:	89 d0                	mov    %edx,%eax
  803139:	01 c0                	add    %eax,%eax
  80313b:	01 d0                	add    %edx,%eax
  80313d:	c1 e0 03             	shl    $0x3,%eax
  803140:	01 c8                	add    %ecx,%eax
  803142:	8a 40 04             	mov    0x4(%eax),%al
  803145:	84 c0                	test   %al,%al
  803147:	75 46                	jne    80318f <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803149:	a1 20 40 80 00       	mov    0x804020,%eax
  80314e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803154:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803157:	89 d0                	mov    %edx,%eax
  803159:	01 c0                	add    %eax,%eax
  80315b:	01 d0                	add    %edx,%eax
  80315d:	c1 e0 03             	shl    $0x3,%eax
  803160:	01 c8                	add    %ecx,%eax
  803162:	8b 00                	mov    (%eax),%eax
  803164:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803167:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80316a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80316f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803171:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803174:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80317b:	8b 45 08             	mov    0x8(%ebp),%eax
  80317e:	01 c8                	add    %ecx,%eax
  803180:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803182:	39 c2                	cmp    %eax,%edx
  803184:	75 09                	jne    80318f <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  803186:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80318d:	eb 12                	jmp    8031a1 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80318f:	ff 45 e8             	incl   -0x18(%ebp)
  803192:	a1 20 40 80 00       	mov    0x804020,%eax
  803197:	8b 50 74             	mov    0x74(%eax),%edx
  80319a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80319d:	39 c2                	cmp    %eax,%edx
  80319f:	77 88                	ja     803129 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8031a1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8031a5:	75 14                	jne    8031bb <CheckWSWithoutLastIndex+0xfb>
			panic(
  8031a7:	83 ec 04             	sub    $0x4,%esp
  8031aa:	68 04 3c 80 00       	push   $0x803c04
  8031af:	6a 3a                	push   $0x3a
  8031b1:	68 f8 3b 80 00       	push   $0x803bf8
  8031b6:	e8 93 fe ff ff       	call   80304e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8031bb:	ff 45 f0             	incl   -0x10(%ebp)
  8031be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8031c4:	0f 8c 32 ff ff ff    	jl     8030fc <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8031ca:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8031d1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8031d8:	eb 26                	jmp    803200 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8031da:	a1 20 40 80 00       	mov    0x804020,%eax
  8031df:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8031e5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8031e8:	89 d0                	mov    %edx,%eax
  8031ea:	01 c0                	add    %eax,%eax
  8031ec:	01 d0                	add    %edx,%eax
  8031ee:	c1 e0 03             	shl    $0x3,%eax
  8031f1:	01 c8                	add    %ecx,%eax
  8031f3:	8a 40 04             	mov    0x4(%eax),%al
  8031f6:	3c 01                	cmp    $0x1,%al
  8031f8:	75 03                	jne    8031fd <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8031fa:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8031fd:	ff 45 e0             	incl   -0x20(%ebp)
  803200:	a1 20 40 80 00       	mov    0x804020,%eax
  803205:	8b 50 74             	mov    0x74(%eax),%edx
  803208:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80320b:	39 c2                	cmp    %eax,%edx
  80320d:	77 cb                	ja     8031da <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80320f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803212:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803215:	74 14                	je     80322b <CheckWSWithoutLastIndex+0x16b>
		panic(
  803217:	83 ec 04             	sub    $0x4,%esp
  80321a:	68 58 3c 80 00       	push   $0x803c58
  80321f:	6a 44                	push   $0x44
  803221:	68 f8 3b 80 00       	push   $0x803bf8
  803226:	e8 23 fe ff ff       	call   80304e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80322b:	90                   	nop
  80322c:	c9                   	leave  
  80322d:	c3                   	ret    
  80322e:	66 90                	xchg   %ax,%ax

00803230 <__udivdi3>:
  803230:	55                   	push   %ebp
  803231:	57                   	push   %edi
  803232:	56                   	push   %esi
  803233:	53                   	push   %ebx
  803234:	83 ec 1c             	sub    $0x1c,%esp
  803237:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80323b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80323f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803243:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803247:	89 ca                	mov    %ecx,%edx
  803249:	89 f8                	mov    %edi,%eax
  80324b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80324f:	85 f6                	test   %esi,%esi
  803251:	75 2d                	jne    803280 <__udivdi3+0x50>
  803253:	39 cf                	cmp    %ecx,%edi
  803255:	77 65                	ja     8032bc <__udivdi3+0x8c>
  803257:	89 fd                	mov    %edi,%ebp
  803259:	85 ff                	test   %edi,%edi
  80325b:	75 0b                	jne    803268 <__udivdi3+0x38>
  80325d:	b8 01 00 00 00       	mov    $0x1,%eax
  803262:	31 d2                	xor    %edx,%edx
  803264:	f7 f7                	div    %edi
  803266:	89 c5                	mov    %eax,%ebp
  803268:	31 d2                	xor    %edx,%edx
  80326a:	89 c8                	mov    %ecx,%eax
  80326c:	f7 f5                	div    %ebp
  80326e:	89 c1                	mov    %eax,%ecx
  803270:	89 d8                	mov    %ebx,%eax
  803272:	f7 f5                	div    %ebp
  803274:	89 cf                	mov    %ecx,%edi
  803276:	89 fa                	mov    %edi,%edx
  803278:	83 c4 1c             	add    $0x1c,%esp
  80327b:	5b                   	pop    %ebx
  80327c:	5e                   	pop    %esi
  80327d:	5f                   	pop    %edi
  80327e:	5d                   	pop    %ebp
  80327f:	c3                   	ret    
  803280:	39 ce                	cmp    %ecx,%esi
  803282:	77 28                	ja     8032ac <__udivdi3+0x7c>
  803284:	0f bd fe             	bsr    %esi,%edi
  803287:	83 f7 1f             	xor    $0x1f,%edi
  80328a:	75 40                	jne    8032cc <__udivdi3+0x9c>
  80328c:	39 ce                	cmp    %ecx,%esi
  80328e:	72 0a                	jb     80329a <__udivdi3+0x6a>
  803290:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803294:	0f 87 9e 00 00 00    	ja     803338 <__udivdi3+0x108>
  80329a:	b8 01 00 00 00       	mov    $0x1,%eax
  80329f:	89 fa                	mov    %edi,%edx
  8032a1:	83 c4 1c             	add    $0x1c,%esp
  8032a4:	5b                   	pop    %ebx
  8032a5:	5e                   	pop    %esi
  8032a6:	5f                   	pop    %edi
  8032a7:	5d                   	pop    %ebp
  8032a8:	c3                   	ret    
  8032a9:	8d 76 00             	lea    0x0(%esi),%esi
  8032ac:	31 ff                	xor    %edi,%edi
  8032ae:	31 c0                	xor    %eax,%eax
  8032b0:	89 fa                	mov    %edi,%edx
  8032b2:	83 c4 1c             	add    $0x1c,%esp
  8032b5:	5b                   	pop    %ebx
  8032b6:	5e                   	pop    %esi
  8032b7:	5f                   	pop    %edi
  8032b8:	5d                   	pop    %ebp
  8032b9:	c3                   	ret    
  8032ba:	66 90                	xchg   %ax,%ax
  8032bc:	89 d8                	mov    %ebx,%eax
  8032be:	f7 f7                	div    %edi
  8032c0:	31 ff                	xor    %edi,%edi
  8032c2:	89 fa                	mov    %edi,%edx
  8032c4:	83 c4 1c             	add    $0x1c,%esp
  8032c7:	5b                   	pop    %ebx
  8032c8:	5e                   	pop    %esi
  8032c9:	5f                   	pop    %edi
  8032ca:	5d                   	pop    %ebp
  8032cb:	c3                   	ret    
  8032cc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8032d1:	89 eb                	mov    %ebp,%ebx
  8032d3:	29 fb                	sub    %edi,%ebx
  8032d5:	89 f9                	mov    %edi,%ecx
  8032d7:	d3 e6                	shl    %cl,%esi
  8032d9:	89 c5                	mov    %eax,%ebp
  8032db:	88 d9                	mov    %bl,%cl
  8032dd:	d3 ed                	shr    %cl,%ebp
  8032df:	89 e9                	mov    %ebp,%ecx
  8032e1:	09 f1                	or     %esi,%ecx
  8032e3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8032e7:	89 f9                	mov    %edi,%ecx
  8032e9:	d3 e0                	shl    %cl,%eax
  8032eb:	89 c5                	mov    %eax,%ebp
  8032ed:	89 d6                	mov    %edx,%esi
  8032ef:	88 d9                	mov    %bl,%cl
  8032f1:	d3 ee                	shr    %cl,%esi
  8032f3:	89 f9                	mov    %edi,%ecx
  8032f5:	d3 e2                	shl    %cl,%edx
  8032f7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032fb:	88 d9                	mov    %bl,%cl
  8032fd:	d3 e8                	shr    %cl,%eax
  8032ff:	09 c2                	or     %eax,%edx
  803301:	89 d0                	mov    %edx,%eax
  803303:	89 f2                	mov    %esi,%edx
  803305:	f7 74 24 0c          	divl   0xc(%esp)
  803309:	89 d6                	mov    %edx,%esi
  80330b:	89 c3                	mov    %eax,%ebx
  80330d:	f7 e5                	mul    %ebp
  80330f:	39 d6                	cmp    %edx,%esi
  803311:	72 19                	jb     80332c <__udivdi3+0xfc>
  803313:	74 0b                	je     803320 <__udivdi3+0xf0>
  803315:	89 d8                	mov    %ebx,%eax
  803317:	31 ff                	xor    %edi,%edi
  803319:	e9 58 ff ff ff       	jmp    803276 <__udivdi3+0x46>
  80331e:	66 90                	xchg   %ax,%ax
  803320:	8b 54 24 08          	mov    0x8(%esp),%edx
  803324:	89 f9                	mov    %edi,%ecx
  803326:	d3 e2                	shl    %cl,%edx
  803328:	39 c2                	cmp    %eax,%edx
  80332a:	73 e9                	jae    803315 <__udivdi3+0xe5>
  80332c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80332f:	31 ff                	xor    %edi,%edi
  803331:	e9 40 ff ff ff       	jmp    803276 <__udivdi3+0x46>
  803336:	66 90                	xchg   %ax,%ax
  803338:	31 c0                	xor    %eax,%eax
  80333a:	e9 37 ff ff ff       	jmp    803276 <__udivdi3+0x46>
  80333f:	90                   	nop

00803340 <__umoddi3>:
  803340:	55                   	push   %ebp
  803341:	57                   	push   %edi
  803342:	56                   	push   %esi
  803343:	53                   	push   %ebx
  803344:	83 ec 1c             	sub    $0x1c,%esp
  803347:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80334b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80334f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803353:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803357:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80335b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80335f:	89 f3                	mov    %esi,%ebx
  803361:	89 fa                	mov    %edi,%edx
  803363:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803367:	89 34 24             	mov    %esi,(%esp)
  80336a:	85 c0                	test   %eax,%eax
  80336c:	75 1a                	jne    803388 <__umoddi3+0x48>
  80336e:	39 f7                	cmp    %esi,%edi
  803370:	0f 86 a2 00 00 00    	jbe    803418 <__umoddi3+0xd8>
  803376:	89 c8                	mov    %ecx,%eax
  803378:	89 f2                	mov    %esi,%edx
  80337a:	f7 f7                	div    %edi
  80337c:	89 d0                	mov    %edx,%eax
  80337e:	31 d2                	xor    %edx,%edx
  803380:	83 c4 1c             	add    $0x1c,%esp
  803383:	5b                   	pop    %ebx
  803384:	5e                   	pop    %esi
  803385:	5f                   	pop    %edi
  803386:	5d                   	pop    %ebp
  803387:	c3                   	ret    
  803388:	39 f0                	cmp    %esi,%eax
  80338a:	0f 87 ac 00 00 00    	ja     80343c <__umoddi3+0xfc>
  803390:	0f bd e8             	bsr    %eax,%ebp
  803393:	83 f5 1f             	xor    $0x1f,%ebp
  803396:	0f 84 ac 00 00 00    	je     803448 <__umoddi3+0x108>
  80339c:	bf 20 00 00 00       	mov    $0x20,%edi
  8033a1:	29 ef                	sub    %ebp,%edi
  8033a3:	89 fe                	mov    %edi,%esi
  8033a5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8033a9:	89 e9                	mov    %ebp,%ecx
  8033ab:	d3 e0                	shl    %cl,%eax
  8033ad:	89 d7                	mov    %edx,%edi
  8033af:	89 f1                	mov    %esi,%ecx
  8033b1:	d3 ef                	shr    %cl,%edi
  8033b3:	09 c7                	or     %eax,%edi
  8033b5:	89 e9                	mov    %ebp,%ecx
  8033b7:	d3 e2                	shl    %cl,%edx
  8033b9:	89 14 24             	mov    %edx,(%esp)
  8033bc:	89 d8                	mov    %ebx,%eax
  8033be:	d3 e0                	shl    %cl,%eax
  8033c0:	89 c2                	mov    %eax,%edx
  8033c2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8033c6:	d3 e0                	shl    %cl,%eax
  8033c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8033cc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8033d0:	89 f1                	mov    %esi,%ecx
  8033d2:	d3 e8                	shr    %cl,%eax
  8033d4:	09 d0                	or     %edx,%eax
  8033d6:	d3 eb                	shr    %cl,%ebx
  8033d8:	89 da                	mov    %ebx,%edx
  8033da:	f7 f7                	div    %edi
  8033dc:	89 d3                	mov    %edx,%ebx
  8033de:	f7 24 24             	mull   (%esp)
  8033e1:	89 c6                	mov    %eax,%esi
  8033e3:	89 d1                	mov    %edx,%ecx
  8033e5:	39 d3                	cmp    %edx,%ebx
  8033e7:	0f 82 87 00 00 00    	jb     803474 <__umoddi3+0x134>
  8033ed:	0f 84 91 00 00 00    	je     803484 <__umoddi3+0x144>
  8033f3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8033f7:	29 f2                	sub    %esi,%edx
  8033f9:	19 cb                	sbb    %ecx,%ebx
  8033fb:	89 d8                	mov    %ebx,%eax
  8033fd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803401:	d3 e0                	shl    %cl,%eax
  803403:	89 e9                	mov    %ebp,%ecx
  803405:	d3 ea                	shr    %cl,%edx
  803407:	09 d0                	or     %edx,%eax
  803409:	89 e9                	mov    %ebp,%ecx
  80340b:	d3 eb                	shr    %cl,%ebx
  80340d:	89 da                	mov    %ebx,%edx
  80340f:	83 c4 1c             	add    $0x1c,%esp
  803412:	5b                   	pop    %ebx
  803413:	5e                   	pop    %esi
  803414:	5f                   	pop    %edi
  803415:	5d                   	pop    %ebp
  803416:	c3                   	ret    
  803417:	90                   	nop
  803418:	89 fd                	mov    %edi,%ebp
  80341a:	85 ff                	test   %edi,%edi
  80341c:	75 0b                	jne    803429 <__umoddi3+0xe9>
  80341e:	b8 01 00 00 00       	mov    $0x1,%eax
  803423:	31 d2                	xor    %edx,%edx
  803425:	f7 f7                	div    %edi
  803427:	89 c5                	mov    %eax,%ebp
  803429:	89 f0                	mov    %esi,%eax
  80342b:	31 d2                	xor    %edx,%edx
  80342d:	f7 f5                	div    %ebp
  80342f:	89 c8                	mov    %ecx,%eax
  803431:	f7 f5                	div    %ebp
  803433:	89 d0                	mov    %edx,%eax
  803435:	e9 44 ff ff ff       	jmp    80337e <__umoddi3+0x3e>
  80343a:	66 90                	xchg   %ax,%ax
  80343c:	89 c8                	mov    %ecx,%eax
  80343e:	89 f2                	mov    %esi,%edx
  803440:	83 c4 1c             	add    $0x1c,%esp
  803443:	5b                   	pop    %ebx
  803444:	5e                   	pop    %esi
  803445:	5f                   	pop    %edi
  803446:	5d                   	pop    %ebp
  803447:	c3                   	ret    
  803448:	3b 04 24             	cmp    (%esp),%eax
  80344b:	72 06                	jb     803453 <__umoddi3+0x113>
  80344d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803451:	77 0f                	ja     803462 <__umoddi3+0x122>
  803453:	89 f2                	mov    %esi,%edx
  803455:	29 f9                	sub    %edi,%ecx
  803457:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80345b:	89 14 24             	mov    %edx,(%esp)
  80345e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803462:	8b 44 24 04          	mov    0x4(%esp),%eax
  803466:	8b 14 24             	mov    (%esp),%edx
  803469:	83 c4 1c             	add    $0x1c,%esp
  80346c:	5b                   	pop    %ebx
  80346d:	5e                   	pop    %esi
  80346e:	5f                   	pop    %edi
  80346f:	5d                   	pop    %ebp
  803470:	c3                   	ret    
  803471:	8d 76 00             	lea    0x0(%esi),%esi
  803474:	2b 04 24             	sub    (%esp),%eax
  803477:	19 fa                	sbb    %edi,%edx
  803479:	89 d1                	mov    %edx,%ecx
  80347b:	89 c6                	mov    %eax,%esi
  80347d:	e9 71 ff ff ff       	jmp    8033f3 <__umoddi3+0xb3>
  803482:	66 90                	xchg   %ax,%ax
  803484:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803488:	72 ea                	jb     803474 <__umoddi3+0x134>
  80348a:	89 d9                	mov    %ebx,%ecx
  80348c:	e9 62 ff ff ff       	jmp    8033f3 <__umoddi3+0xb3>

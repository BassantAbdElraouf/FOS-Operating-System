
obj/user/arrayOperations_mergesort:     file format elf32-i386


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
  800031:	e8 3d 04 00 00       	call   800473 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

//int *Left;
//int *Right;

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	int32 parentenvID = sys_getparentenvid();
  80003e:	e8 d5 1c 00 00       	call   801d18 <sys_getparentenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int ret;
	/*[1] GET SHARED VARs*/
	//Get the shared array & its size
	int *numOfElements = NULL;
  800046:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	int *sharedArray = NULL;
  80004d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	sharedArray = sget(parentenvID, "arr") ;
  800054:	83 ec 08             	sub    $0x8,%esp
  800057:	68 c0 35 80 00       	push   $0x8035c0
  80005c:	ff 75 f0             	pushl  -0x10(%ebp)
  80005f:	e8 74 17 00 00       	call   8017d8 <sget>
  800064:	83 c4 10             	add    $0x10,%esp
  800067:	89 45 e8             	mov    %eax,-0x18(%ebp)
	numOfElements = sget(parentenvID, "arrSize") ;
  80006a:	83 ec 08             	sub    $0x8,%esp
  80006d:	68 c4 35 80 00       	push   $0x8035c4
  800072:	ff 75 f0             	pushl  -0x10(%ebp)
  800075:	e8 5e 17 00 00       	call   8017d8 <sget>
  80007a:	83 c4 10             	add    $0x10,%esp
  80007d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//PrintElements(sharedArray, *numOfElements);

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800080:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	finishedCount = sget(parentenvID, "finishedCount") ;
  800087:	83 ec 08             	sub    $0x8,%esp
  80008a:	68 cc 35 80 00       	push   $0x8035cc
  80008f:	ff 75 f0             	pushl  -0x10(%ebp)
  800092:	e8 41 17 00 00       	call   8017d8 <sget>
  800097:	83 c4 10             	add    $0x10,%esp
  80009a:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	/*[2] DO THE JOB*/
	//take a copy from the original array
	int *sortedArray;

	sortedArray = smalloc("mergesortedArr", sizeof(int) * *numOfElements, 0) ;
  80009d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000a0:	8b 00                	mov    (%eax),%eax
  8000a2:	c1 e0 02             	shl    $0x2,%eax
  8000a5:	83 ec 04             	sub    $0x4,%esp
  8000a8:	6a 00                	push   $0x0
  8000aa:	50                   	push   %eax
  8000ab:	68 da 35 80 00       	push   $0x8035da
  8000b0:	e8 51 16 00 00       	call   801706 <smalloc>
  8000b5:	83 c4 10             	add    $0x10,%esp
  8000b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8000c2:	eb 25                	jmp    8000e9 <_main+0xb1>
	{
		sortedArray[i] = sharedArray[i];
  8000c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000c7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000d1:	01 c2                	add    %eax,%edx
  8000d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000d6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8000dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000e0:	01 c8                	add    %ecx,%eax
  8000e2:	8b 00                	mov    (%eax),%eax
  8000e4:	89 02                	mov    %eax,(%edx)
	//take a copy from the original array
	int *sortedArray;

	sortedArray = smalloc("mergesortedArr", sizeof(int) * *numOfElements, 0) ;
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000e6:	ff 45 f4             	incl   -0xc(%ebp)
  8000e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000ec:	8b 00                	mov    (%eax),%eax
  8000ee:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000f1:	7f d1                	jg     8000c4 <_main+0x8c>
	}
//	//Create two temps array for "left" & "right"
//	Left = smalloc("mergesortLeftArr", sizeof(int) * (*numOfElements), 1) ;
//	Right = smalloc("mergesortRightArr", sizeof(int) * (*numOfElements), 1) ;

	MSort(sortedArray, 1, *numOfElements);
  8000f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000f6:	8b 00                	mov    (%eax),%eax
  8000f8:	83 ec 04             	sub    $0x4,%esp
  8000fb:	50                   	push   %eax
  8000fc:	6a 01                	push   $0x1
  8000fe:	ff 75 e0             	pushl  -0x20(%ebp)
  800101:	e8 fc 00 00 00       	call   800202 <MSort>
  800106:	83 c4 10             	add    $0x10,%esp
	cprintf("Merge sort is Finished!!!!\n") ;
  800109:	83 ec 0c             	sub    $0xc,%esp
  80010c:	68 e9 35 80 00       	push   $0x8035e9
  800111:	e8 6d 05 00 00       	call   800683 <cprintf>
  800116:	83 c4 10             	add    $0x10,%esp

	/*[3] SHARE THE RESULTS & DECLARE FINISHING*/
	(*finishedCount)++ ;
  800119:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80011c:	8b 00                	mov    (%eax),%eax
  80011e:	8d 50 01             	lea    0x1(%eax),%edx
  800121:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800124:	89 10                	mov    %edx,(%eax)

}
  800126:	90                   	nop
  800127:	c9                   	leave  
  800128:	c3                   	ret    

00800129 <Swap>:

void Swap(int *Elements, int First, int Second)
{
  800129:	55                   	push   %ebp
  80012a:	89 e5                	mov    %esp,%ebp
  80012c:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  80012f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800132:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800139:	8b 45 08             	mov    0x8(%ebp),%eax
  80013c:	01 d0                	add    %edx,%eax
  80013e:	8b 00                	mov    (%eax),%eax
  800140:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800143:	8b 45 0c             	mov    0xc(%ebp),%eax
  800146:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80014d:	8b 45 08             	mov    0x8(%ebp),%eax
  800150:	01 c2                	add    %eax,%edx
  800152:	8b 45 10             	mov    0x10(%ebp),%eax
  800155:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80015c:	8b 45 08             	mov    0x8(%ebp),%eax
  80015f:	01 c8                	add    %ecx,%eax
  800161:	8b 00                	mov    (%eax),%eax
  800163:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800165:	8b 45 10             	mov    0x10(%ebp),%eax
  800168:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80016f:	8b 45 08             	mov    0x8(%ebp),%eax
  800172:	01 c2                	add    %eax,%edx
  800174:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800177:	89 02                	mov    %eax,(%edx)
}
  800179:	90                   	nop
  80017a:	c9                   	leave  
  80017b:	c3                   	ret    

0080017c <PrintElements>:


void PrintElements(int *Elements, int NumOfElements)
{
  80017c:	55                   	push   %ebp
  80017d:	89 e5                	mov    %esp,%ebp
  80017f:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800182:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800189:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800190:	eb 42                	jmp    8001d4 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800192:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800195:	99                   	cltd   
  800196:	f7 7d f0             	idivl  -0x10(%ebp)
  800199:	89 d0                	mov    %edx,%eax
  80019b:	85 c0                	test   %eax,%eax
  80019d:	75 10                	jne    8001af <PrintElements+0x33>
			cprintf("\n");
  80019f:	83 ec 0c             	sub    $0xc,%esp
  8001a2:	68 05 36 80 00       	push   $0x803605
  8001a7:	e8 d7 04 00 00       	call   800683 <cprintf>
  8001ac:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  8001af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8001bc:	01 d0                	add    %edx,%eax
  8001be:	8b 00                	mov    (%eax),%eax
  8001c0:	83 ec 08             	sub    $0x8,%esp
  8001c3:	50                   	push   %eax
  8001c4:	68 07 36 80 00       	push   $0x803607
  8001c9:	e8 b5 04 00 00       	call   800683 <cprintf>
  8001ce:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8001d1:	ff 45 f4             	incl   -0xc(%ebp)
  8001d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d7:	48                   	dec    %eax
  8001d8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8001db:	7f b5                	jg     800192 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  8001dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001e0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8001ea:	01 d0                	add    %edx,%eax
  8001ec:	8b 00                	mov    (%eax),%eax
  8001ee:	83 ec 08             	sub    $0x8,%esp
  8001f1:	50                   	push   %eax
  8001f2:	68 0c 36 80 00       	push   $0x80360c
  8001f7:	e8 87 04 00 00       	call   800683 <cprintf>
  8001fc:	83 c4 10             	add    $0x10,%esp

}
  8001ff:	90                   	nop
  800200:	c9                   	leave  
  800201:	c3                   	ret    

00800202 <MSort>:


void MSort(int* A, int p, int r)
{
  800202:	55                   	push   %ebp
  800203:	89 e5                	mov    %esp,%ebp
  800205:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  800208:	8b 45 0c             	mov    0xc(%ebp),%eax
  80020b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80020e:	7d 54                	jge    800264 <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  800210:	8b 55 0c             	mov    0xc(%ebp),%edx
  800213:	8b 45 10             	mov    0x10(%ebp),%eax
  800216:	01 d0                	add    %edx,%eax
  800218:	89 c2                	mov    %eax,%edx
  80021a:	c1 ea 1f             	shr    $0x1f,%edx
  80021d:	01 d0                	add    %edx,%eax
  80021f:	d1 f8                	sar    %eax
  800221:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  800224:	83 ec 04             	sub    $0x4,%esp
  800227:	ff 75 f4             	pushl  -0xc(%ebp)
  80022a:	ff 75 0c             	pushl  0xc(%ebp)
  80022d:	ff 75 08             	pushl  0x8(%ebp)
  800230:	e8 cd ff ff ff       	call   800202 <MSort>
  800235:	83 c4 10             	add    $0x10,%esp
//	cprintf("LEFT is sorted: from %d to %d\n", p, q);

	MSort(A, q + 1, r);
  800238:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80023b:	40                   	inc    %eax
  80023c:	83 ec 04             	sub    $0x4,%esp
  80023f:	ff 75 10             	pushl  0x10(%ebp)
  800242:	50                   	push   %eax
  800243:	ff 75 08             	pushl  0x8(%ebp)
  800246:	e8 b7 ff ff ff       	call   800202 <MSort>
  80024b:	83 c4 10             	add    $0x10,%esp
//	cprintf("RIGHT is sorted: from %d to %d\n", q+1, r);

	Merge(A, p, q, r);
  80024e:	ff 75 10             	pushl  0x10(%ebp)
  800251:	ff 75 f4             	pushl  -0xc(%ebp)
  800254:	ff 75 0c             	pushl  0xc(%ebp)
  800257:	ff 75 08             	pushl  0x8(%ebp)
  80025a:	e8 08 00 00 00       	call   800267 <Merge>
  80025f:	83 c4 10             	add    $0x10,%esp
  800262:	eb 01                	jmp    800265 <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  800264:	90                   	nop
//	cprintf("RIGHT is sorted: from %d to %d\n", q+1, r);

	Merge(A, p, q, r);
	//cprintf("[%d %d] + [%d %d] = [%d %d]\n", p, q, q+1, r, p, r);

}
  800265:	c9                   	leave  
  800266:	c3                   	ret    

00800267 <Merge>:

void Merge(int* A, int p, int q, int r)
{
  800267:	55                   	push   %ebp
  800268:	89 e5                	mov    %esp,%ebp
  80026a:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  80026d:	8b 45 10             	mov    0x10(%ebp),%eax
  800270:	2b 45 0c             	sub    0xc(%ebp),%eax
  800273:	40                   	inc    %eax
  800274:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  800277:	8b 45 14             	mov    0x14(%ebp),%eax
  80027a:	2b 45 10             	sub    0x10(%ebp),%eax
  80027d:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800280:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  800287:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int* Left = malloc(sizeof(int) * leftCapacity);
  80028e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800291:	c1 e0 02             	shl    $0x2,%eax
  800294:	83 ec 0c             	sub    $0xc,%esp
  800297:	50                   	push   %eax
  800298:	e8 15 13 00 00       	call   8015b2 <malloc>
  80029d:	83 c4 10             	add    $0x10,%esp
  8002a0:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  8002a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002a6:	c1 e0 02             	shl    $0x2,%eax
  8002a9:	83 ec 0c             	sub    $0xc,%esp
  8002ac:	50                   	push   %eax
  8002ad:	e8 00 13 00 00       	call   8015b2 <malloc>
  8002b2:	83 c4 10             	add    $0x10,%esp
  8002b5:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  8002b8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8002bf:	eb 2f                	jmp    8002f0 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  8002c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002ce:	01 c2                	add    %eax,%edx
  8002d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002d6:	01 c8                	add    %ecx,%eax
  8002d8:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8002dd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e7:	01 c8                	add    %ecx,%eax
  8002e9:	8b 00                	mov    (%eax),%eax
  8002eb:	89 02                	mov    %eax,(%edx)
	int* Left = malloc(sizeof(int) * leftCapacity);

	int* Right = malloc(sizeof(int) * rightCapacity);

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  8002ed:	ff 45 ec             	incl   -0x14(%ebp)
  8002f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002f3:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002f6:	7c c9                	jl     8002c1 <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8002f8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8002ff:	eb 2a                	jmp    80032b <Merge+0xc4>
	{
		Right[j] = A[q + j];
  800301:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800304:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80030b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80030e:	01 c2                	add    %eax,%edx
  800310:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800313:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800316:	01 c8                	add    %ecx,%eax
  800318:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80031f:	8b 45 08             	mov    0x8(%ebp),%eax
  800322:	01 c8                	add    %ecx,%eax
  800324:	8b 00                	mov    (%eax),%eax
  800326:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  800328:	ff 45 e8             	incl   -0x18(%ebp)
  80032b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80032e:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800331:	7c ce                	jl     800301 <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  800333:	8b 45 0c             	mov    0xc(%ebp),%eax
  800336:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800339:	e9 0a 01 00 00       	jmp    800448 <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  80033e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800341:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800344:	0f 8d 95 00 00 00    	jge    8003df <Merge+0x178>
  80034a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80034d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800350:	0f 8d 89 00 00 00    	jge    8003df <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800356:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800359:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800360:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800363:	01 d0                	add    %edx,%eax
  800365:	8b 10                	mov    (%eax),%edx
  800367:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80036a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800371:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800374:	01 c8                	add    %ecx,%eax
  800376:	8b 00                	mov    (%eax),%eax
  800378:	39 c2                	cmp    %eax,%edx
  80037a:	7d 33                	jge    8003af <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  80037c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80037f:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800384:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80038b:	8b 45 08             	mov    0x8(%ebp),%eax
  80038e:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800391:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800394:	8d 50 01             	lea    0x1(%eax),%edx
  800397:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80039a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003a1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003a4:	01 d0                	add    %edx,%eax
  8003a6:	8b 00                	mov    (%eax),%eax
  8003a8:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8003aa:	e9 96 00 00 00       	jmp    800445 <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  8003af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003b2:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8003b7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003be:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c1:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8003c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003c7:	8d 50 01             	lea    0x1(%eax),%edx
  8003ca:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8003cd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003d4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003d7:	01 d0                	add    %edx,%eax
  8003d9:	8b 00                	mov    (%eax),%eax
  8003db:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8003dd:	eb 66                	jmp    800445 <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  8003df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003e2:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8003e5:	7d 30                	jge    800417 <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  8003e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003ea:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8003ef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f9:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8003fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003ff:	8d 50 01             	lea    0x1(%eax),%edx
  800402:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800405:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80040c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80040f:	01 d0                	add    %edx,%eax
  800411:	8b 00                	mov    (%eax),%eax
  800413:	89 01                	mov    %eax,(%ecx)
  800415:	eb 2e                	jmp    800445 <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  800417:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80041a:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80041f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800426:	8b 45 08             	mov    0x8(%ebp),%eax
  800429:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80042c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80042f:	8d 50 01             	lea    0x1(%eax),%edx
  800432:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800435:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80043c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80043f:	01 d0                	add    %edx,%eax
  800441:	8b 00                	mov    (%eax),%eax
  800443:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  800445:	ff 45 e4             	incl   -0x1c(%ebp)
  800448:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80044b:	3b 45 14             	cmp    0x14(%ebp),%eax
  80044e:	0f 8e ea fe ff ff    	jle    80033e <Merge+0xd7>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

	free(Left);
  800454:	83 ec 0c             	sub    $0xc,%esp
  800457:	ff 75 d8             	pushl  -0x28(%ebp)
  80045a:	e8 d5 11 00 00       	call   801634 <free>
  80045f:	83 c4 10             	add    $0x10,%esp
	free(Right);
  800462:	83 ec 0c             	sub    $0xc,%esp
  800465:	ff 75 d4             	pushl  -0x2c(%ebp)
  800468:	e8 c7 11 00 00       	call   801634 <free>
  80046d:	83 c4 10             	add    $0x10,%esp

}
  800470:	90                   	nop
  800471:	c9                   	leave  
  800472:	c3                   	ret    

00800473 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800473:	55                   	push   %ebp
  800474:	89 e5                	mov    %esp,%ebp
  800476:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800479:	e8 81 18 00 00       	call   801cff <sys_getenvindex>
  80047e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800481:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800484:	89 d0                	mov    %edx,%eax
  800486:	c1 e0 03             	shl    $0x3,%eax
  800489:	01 d0                	add    %edx,%eax
  80048b:	01 c0                	add    %eax,%eax
  80048d:	01 d0                	add    %edx,%eax
  80048f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800496:	01 d0                	add    %edx,%eax
  800498:	c1 e0 04             	shl    $0x4,%eax
  80049b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8004a0:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8004a5:	a1 20 40 80 00       	mov    0x804020,%eax
  8004aa:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8004b0:	84 c0                	test   %al,%al
  8004b2:	74 0f                	je     8004c3 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8004b4:	a1 20 40 80 00       	mov    0x804020,%eax
  8004b9:	05 5c 05 00 00       	add    $0x55c,%eax
  8004be:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8004c7:	7e 0a                	jle    8004d3 <libmain+0x60>
		binaryname = argv[0];
  8004c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004cc:	8b 00                	mov    (%eax),%eax
  8004ce:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8004d3:	83 ec 08             	sub    $0x8,%esp
  8004d6:	ff 75 0c             	pushl  0xc(%ebp)
  8004d9:	ff 75 08             	pushl  0x8(%ebp)
  8004dc:	e8 57 fb ff ff       	call   800038 <_main>
  8004e1:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8004e4:	e8 23 16 00 00       	call   801b0c <sys_disable_interrupt>
	cprintf("**************************************\n");
  8004e9:	83 ec 0c             	sub    $0xc,%esp
  8004ec:	68 28 36 80 00       	push   $0x803628
  8004f1:	e8 8d 01 00 00       	call   800683 <cprintf>
  8004f6:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8004f9:	a1 20 40 80 00       	mov    0x804020,%eax
  8004fe:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800504:	a1 20 40 80 00       	mov    0x804020,%eax
  800509:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80050f:	83 ec 04             	sub    $0x4,%esp
  800512:	52                   	push   %edx
  800513:	50                   	push   %eax
  800514:	68 50 36 80 00       	push   $0x803650
  800519:	e8 65 01 00 00       	call   800683 <cprintf>
  80051e:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800521:	a1 20 40 80 00       	mov    0x804020,%eax
  800526:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80052c:	a1 20 40 80 00       	mov    0x804020,%eax
  800531:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800537:	a1 20 40 80 00       	mov    0x804020,%eax
  80053c:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800542:	51                   	push   %ecx
  800543:	52                   	push   %edx
  800544:	50                   	push   %eax
  800545:	68 78 36 80 00       	push   $0x803678
  80054a:	e8 34 01 00 00       	call   800683 <cprintf>
  80054f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800552:	a1 20 40 80 00       	mov    0x804020,%eax
  800557:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80055d:	83 ec 08             	sub    $0x8,%esp
  800560:	50                   	push   %eax
  800561:	68 d0 36 80 00       	push   $0x8036d0
  800566:	e8 18 01 00 00       	call   800683 <cprintf>
  80056b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80056e:	83 ec 0c             	sub    $0xc,%esp
  800571:	68 28 36 80 00       	push   $0x803628
  800576:	e8 08 01 00 00       	call   800683 <cprintf>
  80057b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80057e:	e8 a3 15 00 00       	call   801b26 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800583:	e8 19 00 00 00       	call   8005a1 <exit>
}
  800588:	90                   	nop
  800589:	c9                   	leave  
  80058a:	c3                   	ret    

0080058b <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80058b:	55                   	push   %ebp
  80058c:	89 e5                	mov    %esp,%ebp
  80058e:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800591:	83 ec 0c             	sub    $0xc,%esp
  800594:	6a 00                	push   $0x0
  800596:	e8 30 17 00 00       	call   801ccb <sys_destroy_env>
  80059b:	83 c4 10             	add    $0x10,%esp
}
  80059e:	90                   	nop
  80059f:	c9                   	leave  
  8005a0:	c3                   	ret    

008005a1 <exit>:

void
exit(void)
{
  8005a1:	55                   	push   %ebp
  8005a2:	89 e5                	mov    %esp,%ebp
  8005a4:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8005a7:	e8 85 17 00 00       	call   801d31 <sys_exit_env>
}
  8005ac:	90                   	nop
  8005ad:	c9                   	leave  
  8005ae:	c3                   	ret    

008005af <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8005af:	55                   	push   %ebp
  8005b0:	89 e5                	mov    %esp,%ebp
  8005b2:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8005b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005b8:	8b 00                	mov    (%eax),%eax
  8005ba:	8d 48 01             	lea    0x1(%eax),%ecx
  8005bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005c0:	89 0a                	mov    %ecx,(%edx)
  8005c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8005c5:	88 d1                	mov    %dl,%cl
  8005c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ca:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d1:	8b 00                	mov    (%eax),%eax
  8005d3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005d8:	75 2c                	jne    800606 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8005da:	a0 24 40 80 00       	mov    0x804024,%al
  8005df:	0f b6 c0             	movzbl %al,%eax
  8005e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005e5:	8b 12                	mov    (%edx),%edx
  8005e7:	89 d1                	mov    %edx,%ecx
  8005e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ec:	83 c2 08             	add    $0x8,%edx
  8005ef:	83 ec 04             	sub    $0x4,%esp
  8005f2:	50                   	push   %eax
  8005f3:	51                   	push   %ecx
  8005f4:	52                   	push   %edx
  8005f5:	e8 64 13 00 00       	call   80195e <sys_cputs>
  8005fa:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800600:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800606:	8b 45 0c             	mov    0xc(%ebp),%eax
  800609:	8b 40 04             	mov    0x4(%eax),%eax
  80060c:	8d 50 01             	lea    0x1(%eax),%edx
  80060f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800612:	89 50 04             	mov    %edx,0x4(%eax)
}
  800615:	90                   	nop
  800616:	c9                   	leave  
  800617:	c3                   	ret    

00800618 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800618:	55                   	push   %ebp
  800619:	89 e5                	mov    %esp,%ebp
  80061b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800621:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800628:	00 00 00 
	b.cnt = 0;
  80062b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800632:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800635:	ff 75 0c             	pushl  0xc(%ebp)
  800638:	ff 75 08             	pushl  0x8(%ebp)
  80063b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800641:	50                   	push   %eax
  800642:	68 af 05 80 00       	push   $0x8005af
  800647:	e8 11 02 00 00       	call   80085d <vprintfmt>
  80064c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80064f:	a0 24 40 80 00       	mov    0x804024,%al
  800654:	0f b6 c0             	movzbl %al,%eax
  800657:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80065d:	83 ec 04             	sub    $0x4,%esp
  800660:	50                   	push   %eax
  800661:	52                   	push   %edx
  800662:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800668:	83 c0 08             	add    $0x8,%eax
  80066b:	50                   	push   %eax
  80066c:	e8 ed 12 00 00       	call   80195e <sys_cputs>
  800671:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800674:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80067b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800681:	c9                   	leave  
  800682:	c3                   	ret    

00800683 <cprintf>:

int cprintf(const char *fmt, ...) {
  800683:	55                   	push   %ebp
  800684:	89 e5                	mov    %esp,%ebp
  800686:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800689:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800690:	8d 45 0c             	lea    0xc(%ebp),%eax
  800693:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800696:	8b 45 08             	mov    0x8(%ebp),%eax
  800699:	83 ec 08             	sub    $0x8,%esp
  80069c:	ff 75 f4             	pushl  -0xc(%ebp)
  80069f:	50                   	push   %eax
  8006a0:	e8 73 ff ff ff       	call   800618 <vcprintf>
  8006a5:	83 c4 10             	add    $0x10,%esp
  8006a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006ae:	c9                   	leave  
  8006af:	c3                   	ret    

008006b0 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8006b0:	55                   	push   %ebp
  8006b1:	89 e5                	mov    %esp,%ebp
  8006b3:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8006b6:	e8 51 14 00 00       	call   801b0c <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8006bb:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006be:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c4:	83 ec 08             	sub    $0x8,%esp
  8006c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8006ca:	50                   	push   %eax
  8006cb:	e8 48 ff ff ff       	call   800618 <vcprintf>
  8006d0:	83 c4 10             	add    $0x10,%esp
  8006d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8006d6:	e8 4b 14 00 00       	call   801b26 <sys_enable_interrupt>
	return cnt;
  8006db:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006de:	c9                   	leave  
  8006df:	c3                   	ret    

008006e0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006e0:	55                   	push   %ebp
  8006e1:	89 e5                	mov    %esp,%ebp
  8006e3:	53                   	push   %ebx
  8006e4:	83 ec 14             	sub    $0x14,%esp
  8006e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8006ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006f3:	8b 45 18             	mov    0x18(%ebp),%eax
  8006f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8006fb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006fe:	77 55                	ja     800755 <printnum+0x75>
  800700:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800703:	72 05                	jb     80070a <printnum+0x2a>
  800705:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800708:	77 4b                	ja     800755 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80070a:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80070d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800710:	8b 45 18             	mov    0x18(%ebp),%eax
  800713:	ba 00 00 00 00       	mov    $0x0,%edx
  800718:	52                   	push   %edx
  800719:	50                   	push   %eax
  80071a:	ff 75 f4             	pushl  -0xc(%ebp)
  80071d:	ff 75 f0             	pushl  -0x10(%ebp)
  800720:	e8 27 2c 00 00       	call   80334c <__udivdi3>
  800725:	83 c4 10             	add    $0x10,%esp
  800728:	83 ec 04             	sub    $0x4,%esp
  80072b:	ff 75 20             	pushl  0x20(%ebp)
  80072e:	53                   	push   %ebx
  80072f:	ff 75 18             	pushl  0x18(%ebp)
  800732:	52                   	push   %edx
  800733:	50                   	push   %eax
  800734:	ff 75 0c             	pushl  0xc(%ebp)
  800737:	ff 75 08             	pushl  0x8(%ebp)
  80073a:	e8 a1 ff ff ff       	call   8006e0 <printnum>
  80073f:	83 c4 20             	add    $0x20,%esp
  800742:	eb 1a                	jmp    80075e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800744:	83 ec 08             	sub    $0x8,%esp
  800747:	ff 75 0c             	pushl  0xc(%ebp)
  80074a:	ff 75 20             	pushl  0x20(%ebp)
  80074d:	8b 45 08             	mov    0x8(%ebp),%eax
  800750:	ff d0                	call   *%eax
  800752:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800755:	ff 4d 1c             	decl   0x1c(%ebp)
  800758:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80075c:	7f e6                	jg     800744 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80075e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800761:	bb 00 00 00 00       	mov    $0x0,%ebx
  800766:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800769:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80076c:	53                   	push   %ebx
  80076d:	51                   	push   %ecx
  80076e:	52                   	push   %edx
  80076f:	50                   	push   %eax
  800770:	e8 e7 2c 00 00       	call   80345c <__umoddi3>
  800775:	83 c4 10             	add    $0x10,%esp
  800778:	05 14 39 80 00       	add    $0x803914,%eax
  80077d:	8a 00                	mov    (%eax),%al
  80077f:	0f be c0             	movsbl %al,%eax
  800782:	83 ec 08             	sub    $0x8,%esp
  800785:	ff 75 0c             	pushl  0xc(%ebp)
  800788:	50                   	push   %eax
  800789:	8b 45 08             	mov    0x8(%ebp),%eax
  80078c:	ff d0                	call   *%eax
  80078e:	83 c4 10             	add    $0x10,%esp
}
  800791:	90                   	nop
  800792:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800795:	c9                   	leave  
  800796:	c3                   	ret    

00800797 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800797:	55                   	push   %ebp
  800798:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80079a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80079e:	7e 1c                	jle    8007bc <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a3:	8b 00                	mov    (%eax),%eax
  8007a5:	8d 50 08             	lea    0x8(%eax),%edx
  8007a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ab:	89 10                	mov    %edx,(%eax)
  8007ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b0:	8b 00                	mov    (%eax),%eax
  8007b2:	83 e8 08             	sub    $0x8,%eax
  8007b5:	8b 50 04             	mov    0x4(%eax),%edx
  8007b8:	8b 00                	mov    (%eax),%eax
  8007ba:	eb 40                	jmp    8007fc <getuint+0x65>
	else if (lflag)
  8007bc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007c0:	74 1e                	je     8007e0 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c5:	8b 00                	mov    (%eax),%eax
  8007c7:	8d 50 04             	lea    0x4(%eax),%edx
  8007ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cd:	89 10                	mov    %edx,(%eax)
  8007cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d2:	8b 00                	mov    (%eax),%eax
  8007d4:	83 e8 04             	sub    $0x4,%eax
  8007d7:	8b 00                	mov    (%eax),%eax
  8007d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8007de:	eb 1c                	jmp    8007fc <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8007e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e3:	8b 00                	mov    (%eax),%eax
  8007e5:	8d 50 04             	lea    0x4(%eax),%edx
  8007e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007eb:	89 10                	mov    %edx,(%eax)
  8007ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f0:	8b 00                	mov    (%eax),%eax
  8007f2:	83 e8 04             	sub    $0x4,%eax
  8007f5:	8b 00                	mov    (%eax),%eax
  8007f7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007fc:	5d                   	pop    %ebp
  8007fd:	c3                   	ret    

008007fe <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007fe:	55                   	push   %ebp
  8007ff:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800801:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800805:	7e 1c                	jle    800823 <getint+0x25>
		return va_arg(*ap, long long);
  800807:	8b 45 08             	mov    0x8(%ebp),%eax
  80080a:	8b 00                	mov    (%eax),%eax
  80080c:	8d 50 08             	lea    0x8(%eax),%edx
  80080f:	8b 45 08             	mov    0x8(%ebp),%eax
  800812:	89 10                	mov    %edx,(%eax)
  800814:	8b 45 08             	mov    0x8(%ebp),%eax
  800817:	8b 00                	mov    (%eax),%eax
  800819:	83 e8 08             	sub    $0x8,%eax
  80081c:	8b 50 04             	mov    0x4(%eax),%edx
  80081f:	8b 00                	mov    (%eax),%eax
  800821:	eb 38                	jmp    80085b <getint+0x5d>
	else if (lflag)
  800823:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800827:	74 1a                	je     800843 <getint+0x45>
		return va_arg(*ap, long);
  800829:	8b 45 08             	mov    0x8(%ebp),%eax
  80082c:	8b 00                	mov    (%eax),%eax
  80082e:	8d 50 04             	lea    0x4(%eax),%edx
  800831:	8b 45 08             	mov    0x8(%ebp),%eax
  800834:	89 10                	mov    %edx,(%eax)
  800836:	8b 45 08             	mov    0x8(%ebp),%eax
  800839:	8b 00                	mov    (%eax),%eax
  80083b:	83 e8 04             	sub    $0x4,%eax
  80083e:	8b 00                	mov    (%eax),%eax
  800840:	99                   	cltd   
  800841:	eb 18                	jmp    80085b <getint+0x5d>
	else
		return va_arg(*ap, int);
  800843:	8b 45 08             	mov    0x8(%ebp),%eax
  800846:	8b 00                	mov    (%eax),%eax
  800848:	8d 50 04             	lea    0x4(%eax),%edx
  80084b:	8b 45 08             	mov    0x8(%ebp),%eax
  80084e:	89 10                	mov    %edx,(%eax)
  800850:	8b 45 08             	mov    0x8(%ebp),%eax
  800853:	8b 00                	mov    (%eax),%eax
  800855:	83 e8 04             	sub    $0x4,%eax
  800858:	8b 00                	mov    (%eax),%eax
  80085a:	99                   	cltd   
}
  80085b:	5d                   	pop    %ebp
  80085c:	c3                   	ret    

0080085d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80085d:	55                   	push   %ebp
  80085e:	89 e5                	mov    %esp,%ebp
  800860:	56                   	push   %esi
  800861:	53                   	push   %ebx
  800862:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800865:	eb 17                	jmp    80087e <vprintfmt+0x21>
			if (ch == '\0')
  800867:	85 db                	test   %ebx,%ebx
  800869:	0f 84 af 03 00 00    	je     800c1e <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80086f:	83 ec 08             	sub    $0x8,%esp
  800872:	ff 75 0c             	pushl  0xc(%ebp)
  800875:	53                   	push   %ebx
  800876:	8b 45 08             	mov    0x8(%ebp),%eax
  800879:	ff d0                	call   *%eax
  80087b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80087e:	8b 45 10             	mov    0x10(%ebp),%eax
  800881:	8d 50 01             	lea    0x1(%eax),%edx
  800884:	89 55 10             	mov    %edx,0x10(%ebp)
  800887:	8a 00                	mov    (%eax),%al
  800889:	0f b6 d8             	movzbl %al,%ebx
  80088c:	83 fb 25             	cmp    $0x25,%ebx
  80088f:	75 d6                	jne    800867 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800891:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800895:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80089c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008a3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008aa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8008b4:	8d 50 01             	lea    0x1(%eax),%edx
  8008b7:	89 55 10             	mov    %edx,0x10(%ebp)
  8008ba:	8a 00                	mov    (%eax),%al
  8008bc:	0f b6 d8             	movzbl %al,%ebx
  8008bf:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008c2:	83 f8 55             	cmp    $0x55,%eax
  8008c5:	0f 87 2b 03 00 00    	ja     800bf6 <vprintfmt+0x399>
  8008cb:	8b 04 85 38 39 80 00 	mov    0x803938(,%eax,4),%eax
  8008d2:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008d4:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8008d8:	eb d7                	jmp    8008b1 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008da:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8008de:	eb d1                	jmp    8008b1 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008e0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8008e7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008ea:	89 d0                	mov    %edx,%eax
  8008ec:	c1 e0 02             	shl    $0x2,%eax
  8008ef:	01 d0                	add    %edx,%eax
  8008f1:	01 c0                	add    %eax,%eax
  8008f3:	01 d8                	add    %ebx,%eax
  8008f5:	83 e8 30             	sub    $0x30,%eax
  8008f8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8008fe:	8a 00                	mov    (%eax),%al
  800900:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800903:	83 fb 2f             	cmp    $0x2f,%ebx
  800906:	7e 3e                	jle    800946 <vprintfmt+0xe9>
  800908:	83 fb 39             	cmp    $0x39,%ebx
  80090b:	7f 39                	jg     800946 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80090d:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800910:	eb d5                	jmp    8008e7 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800912:	8b 45 14             	mov    0x14(%ebp),%eax
  800915:	83 c0 04             	add    $0x4,%eax
  800918:	89 45 14             	mov    %eax,0x14(%ebp)
  80091b:	8b 45 14             	mov    0x14(%ebp),%eax
  80091e:	83 e8 04             	sub    $0x4,%eax
  800921:	8b 00                	mov    (%eax),%eax
  800923:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800926:	eb 1f                	jmp    800947 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800928:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80092c:	79 83                	jns    8008b1 <vprintfmt+0x54>
				width = 0;
  80092e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800935:	e9 77 ff ff ff       	jmp    8008b1 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80093a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800941:	e9 6b ff ff ff       	jmp    8008b1 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800946:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800947:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80094b:	0f 89 60 ff ff ff    	jns    8008b1 <vprintfmt+0x54>
				width = precision, precision = -1;
  800951:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800954:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800957:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80095e:	e9 4e ff ff ff       	jmp    8008b1 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800963:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800966:	e9 46 ff ff ff       	jmp    8008b1 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80096b:	8b 45 14             	mov    0x14(%ebp),%eax
  80096e:	83 c0 04             	add    $0x4,%eax
  800971:	89 45 14             	mov    %eax,0x14(%ebp)
  800974:	8b 45 14             	mov    0x14(%ebp),%eax
  800977:	83 e8 04             	sub    $0x4,%eax
  80097a:	8b 00                	mov    (%eax),%eax
  80097c:	83 ec 08             	sub    $0x8,%esp
  80097f:	ff 75 0c             	pushl  0xc(%ebp)
  800982:	50                   	push   %eax
  800983:	8b 45 08             	mov    0x8(%ebp),%eax
  800986:	ff d0                	call   *%eax
  800988:	83 c4 10             	add    $0x10,%esp
			break;
  80098b:	e9 89 02 00 00       	jmp    800c19 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800990:	8b 45 14             	mov    0x14(%ebp),%eax
  800993:	83 c0 04             	add    $0x4,%eax
  800996:	89 45 14             	mov    %eax,0x14(%ebp)
  800999:	8b 45 14             	mov    0x14(%ebp),%eax
  80099c:	83 e8 04             	sub    $0x4,%eax
  80099f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009a1:	85 db                	test   %ebx,%ebx
  8009a3:	79 02                	jns    8009a7 <vprintfmt+0x14a>
				err = -err;
  8009a5:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009a7:	83 fb 64             	cmp    $0x64,%ebx
  8009aa:	7f 0b                	jg     8009b7 <vprintfmt+0x15a>
  8009ac:	8b 34 9d 80 37 80 00 	mov    0x803780(,%ebx,4),%esi
  8009b3:	85 f6                	test   %esi,%esi
  8009b5:	75 19                	jne    8009d0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009b7:	53                   	push   %ebx
  8009b8:	68 25 39 80 00       	push   $0x803925
  8009bd:	ff 75 0c             	pushl  0xc(%ebp)
  8009c0:	ff 75 08             	pushl  0x8(%ebp)
  8009c3:	e8 5e 02 00 00       	call   800c26 <printfmt>
  8009c8:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009cb:	e9 49 02 00 00       	jmp    800c19 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009d0:	56                   	push   %esi
  8009d1:	68 2e 39 80 00       	push   $0x80392e
  8009d6:	ff 75 0c             	pushl  0xc(%ebp)
  8009d9:	ff 75 08             	pushl  0x8(%ebp)
  8009dc:	e8 45 02 00 00       	call   800c26 <printfmt>
  8009e1:	83 c4 10             	add    $0x10,%esp
			break;
  8009e4:	e9 30 02 00 00       	jmp    800c19 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ec:	83 c0 04             	add    $0x4,%eax
  8009ef:	89 45 14             	mov    %eax,0x14(%ebp)
  8009f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f5:	83 e8 04             	sub    $0x4,%eax
  8009f8:	8b 30                	mov    (%eax),%esi
  8009fa:	85 f6                	test   %esi,%esi
  8009fc:	75 05                	jne    800a03 <vprintfmt+0x1a6>
				p = "(null)";
  8009fe:	be 31 39 80 00       	mov    $0x803931,%esi
			if (width > 0 && padc != '-')
  800a03:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a07:	7e 6d                	jle    800a76 <vprintfmt+0x219>
  800a09:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a0d:	74 67                	je     800a76 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a12:	83 ec 08             	sub    $0x8,%esp
  800a15:	50                   	push   %eax
  800a16:	56                   	push   %esi
  800a17:	e8 0c 03 00 00       	call   800d28 <strnlen>
  800a1c:	83 c4 10             	add    $0x10,%esp
  800a1f:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a22:	eb 16                	jmp    800a3a <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a24:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a28:	83 ec 08             	sub    $0x8,%esp
  800a2b:	ff 75 0c             	pushl  0xc(%ebp)
  800a2e:	50                   	push   %eax
  800a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a32:	ff d0                	call   *%eax
  800a34:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a37:	ff 4d e4             	decl   -0x1c(%ebp)
  800a3a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a3e:	7f e4                	jg     800a24 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a40:	eb 34                	jmp    800a76 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a42:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a46:	74 1c                	je     800a64 <vprintfmt+0x207>
  800a48:	83 fb 1f             	cmp    $0x1f,%ebx
  800a4b:	7e 05                	jle    800a52 <vprintfmt+0x1f5>
  800a4d:	83 fb 7e             	cmp    $0x7e,%ebx
  800a50:	7e 12                	jle    800a64 <vprintfmt+0x207>
					putch('?', putdat);
  800a52:	83 ec 08             	sub    $0x8,%esp
  800a55:	ff 75 0c             	pushl  0xc(%ebp)
  800a58:	6a 3f                	push   $0x3f
  800a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5d:	ff d0                	call   *%eax
  800a5f:	83 c4 10             	add    $0x10,%esp
  800a62:	eb 0f                	jmp    800a73 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a64:	83 ec 08             	sub    $0x8,%esp
  800a67:	ff 75 0c             	pushl  0xc(%ebp)
  800a6a:	53                   	push   %ebx
  800a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6e:	ff d0                	call   *%eax
  800a70:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a73:	ff 4d e4             	decl   -0x1c(%ebp)
  800a76:	89 f0                	mov    %esi,%eax
  800a78:	8d 70 01             	lea    0x1(%eax),%esi
  800a7b:	8a 00                	mov    (%eax),%al
  800a7d:	0f be d8             	movsbl %al,%ebx
  800a80:	85 db                	test   %ebx,%ebx
  800a82:	74 24                	je     800aa8 <vprintfmt+0x24b>
  800a84:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a88:	78 b8                	js     800a42 <vprintfmt+0x1e5>
  800a8a:	ff 4d e0             	decl   -0x20(%ebp)
  800a8d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a91:	79 af                	jns    800a42 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a93:	eb 13                	jmp    800aa8 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a95:	83 ec 08             	sub    $0x8,%esp
  800a98:	ff 75 0c             	pushl  0xc(%ebp)
  800a9b:	6a 20                	push   $0x20
  800a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa0:	ff d0                	call   *%eax
  800aa2:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800aa5:	ff 4d e4             	decl   -0x1c(%ebp)
  800aa8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aac:	7f e7                	jg     800a95 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800aae:	e9 66 01 00 00       	jmp    800c19 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ab3:	83 ec 08             	sub    $0x8,%esp
  800ab6:	ff 75 e8             	pushl  -0x18(%ebp)
  800ab9:	8d 45 14             	lea    0x14(%ebp),%eax
  800abc:	50                   	push   %eax
  800abd:	e8 3c fd ff ff       	call   8007fe <getint>
  800ac2:	83 c4 10             	add    $0x10,%esp
  800ac5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ac8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800acb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ace:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ad1:	85 d2                	test   %edx,%edx
  800ad3:	79 23                	jns    800af8 <vprintfmt+0x29b>
				putch('-', putdat);
  800ad5:	83 ec 08             	sub    $0x8,%esp
  800ad8:	ff 75 0c             	pushl  0xc(%ebp)
  800adb:	6a 2d                	push   $0x2d
  800add:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae0:	ff d0                	call   *%eax
  800ae2:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ae5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ae8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800aeb:	f7 d8                	neg    %eax
  800aed:	83 d2 00             	adc    $0x0,%edx
  800af0:	f7 da                	neg    %edx
  800af2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800af8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800aff:	e9 bc 00 00 00       	jmp    800bc0 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b04:	83 ec 08             	sub    $0x8,%esp
  800b07:	ff 75 e8             	pushl  -0x18(%ebp)
  800b0a:	8d 45 14             	lea    0x14(%ebp),%eax
  800b0d:	50                   	push   %eax
  800b0e:	e8 84 fc ff ff       	call   800797 <getuint>
  800b13:	83 c4 10             	add    $0x10,%esp
  800b16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b19:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b1c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b23:	e9 98 00 00 00       	jmp    800bc0 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b28:	83 ec 08             	sub    $0x8,%esp
  800b2b:	ff 75 0c             	pushl  0xc(%ebp)
  800b2e:	6a 58                	push   $0x58
  800b30:	8b 45 08             	mov    0x8(%ebp),%eax
  800b33:	ff d0                	call   *%eax
  800b35:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b38:	83 ec 08             	sub    $0x8,%esp
  800b3b:	ff 75 0c             	pushl  0xc(%ebp)
  800b3e:	6a 58                	push   $0x58
  800b40:	8b 45 08             	mov    0x8(%ebp),%eax
  800b43:	ff d0                	call   *%eax
  800b45:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b48:	83 ec 08             	sub    $0x8,%esp
  800b4b:	ff 75 0c             	pushl  0xc(%ebp)
  800b4e:	6a 58                	push   $0x58
  800b50:	8b 45 08             	mov    0x8(%ebp),%eax
  800b53:	ff d0                	call   *%eax
  800b55:	83 c4 10             	add    $0x10,%esp
			break;
  800b58:	e9 bc 00 00 00       	jmp    800c19 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b5d:	83 ec 08             	sub    $0x8,%esp
  800b60:	ff 75 0c             	pushl  0xc(%ebp)
  800b63:	6a 30                	push   $0x30
  800b65:	8b 45 08             	mov    0x8(%ebp),%eax
  800b68:	ff d0                	call   *%eax
  800b6a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b6d:	83 ec 08             	sub    $0x8,%esp
  800b70:	ff 75 0c             	pushl  0xc(%ebp)
  800b73:	6a 78                	push   $0x78
  800b75:	8b 45 08             	mov    0x8(%ebp),%eax
  800b78:	ff d0                	call   *%eax
  800b7a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b80:	83 c0 04             	add    $0x4,%eax
  800b83:	89 45 14             	mov    %eax,0x14(%ebp)
  800b86:	8b 45 14             	mov    0x14(%ebp),%eax
  800b89:	83 e8 04             	sub    $0x4,%eax
  800b8c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b91:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b98:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b9f:	eb 1f                	jmp    800bc0 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ba1:	83 ec 08             	sub    $0x8,%esp
  800ba4:	ff 75 e8             	pushl  -0x18(%ebp)
  800ba7:	8d 45 14             	lea    0x14(%ebp),%eax
  800baa:	50                   	push   %eax
  800bab:	e8 e7 fb ff ff       	call   800797 <getuint>
  800bb0:	83 c4 10             	add    $0x10,%esp
  800bb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800bb9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bc0:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800bc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bc7:	83 ec 04             	sub    $0x4,%esp
  800bca:	52                   	push   %edx
  800bcb:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bce:	50                   	push   %eax
  800bcf:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd2:	ff 75 f0             	pushl  -0x10(%ebp)
  800bd5:	ff 75 0c             	pushl  0xc(%ebp)
  800bd8:	ff 75 08             	pushl  0x8(%ebp)
  800bdb:	e8 00 fb ff ff       	call   8006e0 <printnum>
  800be0:	83 c4 20             	add    $0x20,%esp
			break;
  800be3:	eb 34                	jmp    800c19 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800be5:	83 ec 08             	sub    $0x8,%esp
  800be8:	ff 75 0c             	pushl  0xc(%ebp)
  800beb:	53                   	push   %ebx
  800bec:	8b 45 08             	mov    0x8(%ebp),%eax
  800bef:	ff d0                	call   *%eax
  800bf1:	83 c4 10             	add    $0x10,%esp
			break;
  800bf4:	eb 23                	jmp    800c19 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bf6:	83 ec 08             	sub    $0x8,%esp
  800bf9:	ff 75 0c             	pushl  0xc(%ebp)
  800bfc:	6a 25                	push   $0x25
  800bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800c01:	ff d0                	call   *%eax
  800c03:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c06:	ff 4d 10             	decl   0x10(%ebp)
  800c09:	eb 03                	jmp    800c0e <vprintfmt+0x3b1>
  800c0b:	ff 4d 10             	decl   0x10(%ebp)
  800c0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c11:	48                   	dec    %eax
  800c12:	8a 00                	mov    (%eax),%al
  800c14:	3c 25                	cmp    $0x25,%al
  800c16:	75 f3                	jne    800c0b <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800c18:	90                   	nop
		}
	}
  800c19:	e9 47 fc ff ff       	jmp    800865 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c1e:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c22:	5b                   	pop    %ebx
  800c23:	5e                   	pop    %esi
  800c24:	5d                   	pop    %ebp
  800c25:	c3                   	ret    

00800c26 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c26:	55                   	push   %ebp
  800c27:	89 e5                	mov    %esp,%ebp
  800c29:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c2c:	8d 45 10             	lea    0x10(%ebp),%eax
  800c2f:	83 c0 04             	add    $0x4,%eax
  800c32:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c35:	8b 45 10             	mov    0x10(%ebp),%eax
  800c38:	ff 75 f4             	pushl  -0xc(%ebp)
  800c3b:	50                   	push   %eax
  800c3c:	ff 75 0c             	pushl  0xc(%ebp)
  800c3f:	ff 75 08             	pushl  0x8(%ebp)
  800c42:	e8 16 fc ff ff       	call   80085d <vprintfmt>
  800c47:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c4a:	90                   	nop
  800c4b:	c9                   	leave  
  800c4c:	c3                   	ret    

00800c4d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c4d:	55                   	push   %ebp
  800c4e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c53:	8b 40 08             	mov    0x8(%eax),%eax
  800c56:	8d 50 01             	lea    0x1(%eax),%edx
  800c59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c62:	8b 10                	mov    (%eax),%edx
  800c64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c67:	8b 40 04             	mov    0x4(%eax),%eax
  800c6a:	39 c2                	cmp    %eax,%edx
  800c6c:	73 12                	jae    800c80 <sprintputch+0x33>
		*b->buf++ = ch;
  800c6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c71:	8b 00                	mov    (%eax),%eax
  800c73:	8d 48 01             	lea    0x1(%eax),%ecx
  800c76:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c79:	89 0a                	mov    %ecx,(%edx)
  800c7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7e:	88 10                	mov    %dl,(%eax)
}
  800c80:	90                   	nop
  800c81:	5d                   	pop    %ebp
  800c82:	c3                   	ret    

00800c83 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c89:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c92:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c95:	8b 45 08             	mov    0x8(%ebp),%eax
  800c98:	01 d0                	add    %edx,%eax
  800c9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c9d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ca4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ca8:	74 06                	je     800cb0 <vsnprintf+0x2d>
  800caa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cae:	7f 07                	jg     800cb7 <vsnprintf+0x34>
		return -E_INVAL;
  800cb0:	b8 03 00 00 00       	mov    $0x3,%eax
  800cb5:	eb 20                	jmp    800cd7 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cb7:	ff 75 14             	pushl  0x14(%ebp)
  800cba:	ff 75 10             	pushl  0x10(%ebp)
  800cbd:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800cc0:	50                   	push   %eax
  800cc1:	68 4d 0c 80 00       	push   $0x800c4d
  800cc6:	e8 92 fb ff ff       	call   80085d <vprintfmt>
  800ccb:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800cce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cd1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800cd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800cd7:	c9                   	leave  
  800cd8:	c3                   	ret    

00800cd9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cd9:	55                   	push   %ebp
  800cda:	89 e5                	mov    %esp,%ebp
  800cdc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800cdf:	8d 45 10             	lea    0x10(%ebp),%eax
  800ce2:	83 c0 04             	add    $0x4,%eax
  800ce5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ce8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ceb:	ff 75 f4             	pushl  -0xc(%ebp)
  800cee:	50                   	push   %eax
  800cef:	ff 75 0c             	pushl  0xc(%ebp)
  800cf2:	ff 75 08             	pushl  0x8(%ebp)
  800cf5:	e8 89 ff ff ff       	call   800c83 <vsnprintf>
  800cfa:	83 c4 10             	add    $0x10,%esp
  800cfd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d00:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d03:	c9                   	leave  
  800d04:	c3                   	ret    

00800d05 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d05:	55                   	push   %ebp
  800d06:	89 e5                	mov    %esp,%ebp
  800d08:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d0b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d12:	eb 06                	jmp    800d1a <strlen+0x15>
		n++;
  800d14:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d17:	ff 45 08             	incl   0x8(%ebp)
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	8a 00                	mov    (%eax),%al
  800d1f:	84 c0                	test   %al,%al
  800d21:	75 f1                	jne    800d14 <strlen+0xf>
		n++;
	return n;
  800d23:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d26:	c9                   	leave  
  800d27:	c3                   	ret    

00800d28 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d28:	55                   	push   %ebp
  800d29:	89 e5                	mov    %esp,%ebp
  800d2b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d2e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d35:	eb 09                	jmp    800d40 <strnlen+0x18>
		n++;
  800d37:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d3a:	ff 45 08             	incl   0x8(%ebp)
  800d3d:	ff 4d 0c             	decl   0xc(%ebp)
  800d40:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d44:	74 09                	je     800d4f <strnlen+0x27>
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
  800d49:	8a 00                	mov    (%eax),%al
  800d4b:	84 c0                	test   %al,%al
  800d4d:	75 e8                	jne    800d37 <strnlen+0xf>
		n++;
	return n;
  800d4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d52:	c9                   	leave  
  800d53:	c3                   	ret    

00800d54 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d54:	55                   	push   %ebp
  800d55:	89 e5                	mov    %esp,%ebp
  800d57:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d60:	90                   	nop
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
  800d64:	8d 50 01             	lea    0x1(%eax),%edx
  800d67:	89 55 08             	mov    %edx,0x8(%ebp)
  800d6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d6d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d70:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d73:	8a 12                	mov    (%edx),%dl
  800d75:	88 10                	mov    %dl,(%eax)
  800d77:	8a 00                	mov    (%eax),%al
  800d79:	84 c0                	test   %al,%al
  800d7b:	75 e4                	jne    800d61 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d80:	c9                   	leave  
  800d81:	c3                   	ret    

00800d82 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d82:	55                   	push   %ebp
  800d83:	89 e5                	mov    %esp,%ebp
  800d85:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d8e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d95:	eb 1f                	jmp    800db6 <strncpy+0x34>
		*dst++ = *src;
  800d97:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9a:	8d 50 01             	lea    0x1(%eax),%edx
  800d9d:	89 55 08             	mov    %edx,0x8(%ebp)
  800da0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da3:	8a 12                	mov    (%edx),%dl
  800da5:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800da7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800daa:	8a 00                	mov    (%eax),%al
  800dac:	84 c0                	test   %al,%al
  800dae:	74 03                	je     800db3 <strncpy+0x31>
			src++;
  800db0:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800db3:	ff 45 fc             	incl   -0x4(%ebp)
  800db6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800db9:	3b 45 10             	cmp    0x10(%ebp),%eax
  800dbc:	72 d9                	jb     800d97 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800dbe:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800dc1:	c9                   	leave  
  800dc2:	c3                   	ret    

00800dc3 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800dc3:	55                   	push   %ebp
  800dc4:	89 e5                	mov    %esp,%ebp
  800dc6:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800dcf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dd3:	74 30                	je     800e05 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800dd5:	eb 16                	jmp    800ded <strlcpy+0x2a>
			*dst++ = *src++;
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dda:	8d 50 01             	lea    0x1(%eax),%edx
  800ddd:	89 55 08             	mov    %edx,0x8(%ebp)
  800de0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800de3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800de6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800de9:	8a 12                	mov    (%edx),%dl
  800deb:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ded:	ff 4d 10             	decl   0x10(%ebp)
  800df0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df4:	74 09                	je     800dff <strlcpy+0x3c>
  800df6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df9:	8a 00                	mov    (%eax),%al
  800dfb:	84 c0                	test   %al,%al
  800dfd:	75 d8                	jne    800dd7 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800dff:	8b 45 08             	mov    0x8(%ebp),%eax
  800e02:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e05:	8b 55 08             	mov    0x8(%ebp),%edx
  800e08:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e0b:	29 c2                	sub    %eax,%edx
  800e0d:	89 d0                	mov    %edx,%eax
}
  800e0f:	c9                   	leave  
  800e10:	c3                   	ret    

00800e11 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e11:	55                   	push   %ebp
  800e12:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e14:	eb 06                	jmp    800e1c <strcmp+0xb>
		p++, q++;
  800e16:	ff 45 08             	incl   0x8(%ebp)
  800e19:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	8a 00                	mov    (%eax),%al
  800e21:	84 c0                	test   %al,%al
  800e23:	74 0e                	je     800e33 <strcmp+0x22>
  800e25:	8b 45 08             	mov    0x8(%ebp),%eax
  800e28:	8a 10                	mov    (%eax),%dl
  800e2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2d:	8a 00                	mov    (%eax),%al
  800e2f:	38 c2                	cmp    %al,%dl
  800e31:	74 e3                	je     800e16 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e33:	8b 45 08             	mov    0x8(%ebp),%eax
  800e36:	8a 00                	mov    (%eax),%al
  800e38:	0f b6 d0             	movzbl %al,%edx
  800e3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3e:	8a 00                	mov    (%eax),%al
  800e40:	0f b6 c0             	movzbl %al,%eax
  800e43:	29 c2                	sub    %eax,%edx
  800e45:	89 d0                	mov    %edx,%eax
}
  800e47:	5d                   	pop    %ebp
  800e48:	c3                   	ret    

00800e49 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e49:	55                   	push   %ebp
  800e4a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e4c:	eb 09                	jmp    800e57 <strncmp+0xe>
		n--, p++, q++;
  800e4e:	ff 4d 10             	decl   0x10(%ebp)
  800e51:	ff 45 08             	incl   0x8(%ebp)
  800e54:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e57:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e5b:	74 17                	je     800e74 <strncmp+0x2b>
  800e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e60:	8a 00                	mov    (%eax),%al
  800e62:	84 c0                	test   %al,%al
  800e64:	74 0e                	je     800e74 <strncmp+0x2b>
  800e66:	8b 45 08             	mov    0x8(%ebp),%eax
  800e69:	8a 10                	mov    (%eax),%dl
  800e6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6e:	8a 00                	mov    (%eax),%al
  800e70:	38 c2                	cmp    %al,%dl
  800e72:	74 da                	je     800e4e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e74:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e78:	75 07                	jne    800e81 <strncmp+0x38>
		return 0;
  800e7a:	b8 00 00 00 00       	mov    $0x0,%eax
  800e7f:	eb 14                	jmp    800e95 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e81:	8b 45 08             	mov    0x8(%ebp),%eax
  800e84:	8a 00                	mov    (%eax),%al
  800e86:	0f b6 d0             	movzbl %al,%edx
  800e89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8c:	8a 00                	mov    (%eax),%al
  800e8e:	0f b6 c0             	movzbl %al,%eax
  800e91:	29 c2                	sub    %eax,%edx
  800e93:	89 d0                	mov    %edx,%eax
}
  800e95:	5d                   	pop    %ebp
  800e96:	c3                   	ret    

00800e97 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e97:	55                   	push   %ebp
  800e98:	89 e5                	mov    %esp,%ebp
  800e9a:	83 ec 04             	sub    $0x4,%esp
  800e9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ea3:	eb 12                	jmp    800eb7 <strchr+0x20>
		if (*s == c)
  800ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea8:	8a 00                	mov    (%eax),%al
  800eaa:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ead:	75 05                	jne    800eb4 <strchr+0x1d>
			return (char *) s;
  800eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb2:	eb 11                	jmp    800ec5 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800eb4:	ff 45 08             	incl   0x8(%ebp)
  800eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eba:	8a 00                	mov    (%eax),%al
  800ebc:	84 c0                	test   %al,%al
  800ebe:	75 e5                	jne    800ea5 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ec0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ec5:	c9                   	leave  
  800ec6:	c3                   	ret    

00800ec7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ec7:	55                   	push   %ebp
  800ec8:	89 e5                	mov    %esp,%ebp
  800eca:	83 ec 04             	sub    $0x4,%esp
  800ecd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ed3:	eb 0d                	jmp    800ee2 <strfind+0x1b>
		if (*s == c)
  800ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed8:	8a 00                	mov    (%eax),%al
  800eda:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800edd:	74 0e                	je     800eed <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800edf:	ff 45 08             	incl   0x8(%ebp)
  800ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee5:	8a 00                	mov    (%eax),%al
  800ee7:	84 c0                	test   %al,%al
  800ee9:	75 ea                	jne    800ed5 <strfind+0xe>
  800eeb:	eb 01                	jmp    800eee <strfind+0x27>
		if (*s == c)
			break;
  800eed:	90                   	nop
	return (char *) s;
  800eee:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ef1:	c9                   	leave  
  800ef2:	c3                   	ret    

00800ef3 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ef3:	55                   	push   %ebp
  800ef4:	89 e5                	mov    %esp,%ebp
  800ef6:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  800efc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800eff:	8b 45 10             	mov    0x10(%ebp),%eax
  800f02:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f05:	eb 0e                	jmp    800f15 <memset+0x22>
		*p++ = c;
  800f07:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f0a:	8d 50 01             	lea    0x1(%eax),%edx
  800f0d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f10:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f13:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f15:	ff 4d f8             	decl   -0x8(%ebp)
  800f18:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f1c:	79 e9                	jns    800f07 <memset+0x14>
		*p++ = c;

	return v;
  800f1e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f21:	c9                   	leave  
  800f22:	c3                   	ret    

00800f23 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f23:	55                   	push   %ebp
  800f24:	89 e5                	mov    %esp,%ebp
  800f26:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f32:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f35:	eb 16                	jmp    800f4d <memcpy+0x2a>
		*d++ = *s++;
  800f37:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f3a:	8d 50 01             	lea    0x1(%eax),%edx
  800f3d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f40:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f43:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f46:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f49:	8a 12                	mov    (%edx),%dl
  800f4b:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f4d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f50:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f53:	89 55 10             	mov    %edx,0x10(%ebp)
  800f56:	85 c0                	test   %eax,%eax
  800f58:	75 dd                	jne    800f37 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f5a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f5d:	c9                   	leave  
  800f5e:	c3                   	ret    

00800f5f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f5f:	55                   	push   %ebp
  800f60:	89 e5                	mov    %esp,%ebp
  800f62:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f68:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f71:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f74:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f77:	73 50                	jae    800fc9 <memmove+0x6a>
  800f79:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7f:	01 d0                	add    %edx,%eax
  800f81:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f84:	76 43                	jbe    800fc9 <memmove+0x6a>
		s += n;
  800f86:	8b 45 10             	mov    0x10(%ebp),%eax
  800f89:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f8c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f92:	eb 10                	jmp    800fa4 <memmove+0x45>
			*--d = *--s;
  800f94:	ff 4d f8             	decl   -0x8(%ebp)
  800f97:	ff 4d fc             	decl   -0x4(%ebp)
  800f9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f9d:	8a 10                	mov    (%eax),%dl
  800f9f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa2:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fa4:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800faa:	89 55 10             	mov    %edx,0x10(%ebp)
  800fad:	85 c0                	test   %eax,%eax
  800faf:	75 e3                	jne    800f94 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fb1:	eb 23                	jmp    800fd6 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fb3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fb6:	8d 50 01             	lea    0x1(%eax),%edx
  800fb9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fbc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fbf:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fc2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fc5:	8a 12                	mov    (%edx),%dl
  800fc7:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fcf:	89 55 10             	mov    %edx,0x10(%ebp)
  800fd2:	85 c0                	test   %eax,%eax
  800fd4:	75 dd                	jne    800fb3 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800fd6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fd9:	c9                   	leave  
  800fda:	c3                   	ret    

00800fdb <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800fdb:	55                   	push   %ebp
  800fdc:	89 e5                	mov    %esp,%ebp
  800fde:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800fe7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fea:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800fed:	eb 2a                	jmp    801019 <memcmp+0x3e>
		if (*s1 != *s2)
  800fef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ff2:	8a 10                	mov    (%eax),%dl
  800ff4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff7:	8a 00                	mov    (%eax),%al
  800ff9:	38 c2                	cmp    %al,%dl
  800ffb:	74 16                	je     801013 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ffd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801000:	8a 00                	mov    (%eax),%al
  801002:	0f b6 d0             	movzbl %al,%edx
  801005:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801008:	8a 00                	mov    (%eax),%al
  80100a:	0f b6 c0             	movzbl %al,%eax
  80100d:	29 c2                	sub    %eax,%edx
  80100f:	89 d0                	mov    %edx,%eax
  801011:	eb 18                	jmp    80102b <memcmp+0x50>
		s1++, s2++;
  801013:	ff 45 fc             	incl   -0x4(%ebp)
  801016:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801019:	8b 45 10             	mov    0x10(%ebp),%eax
  80101c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80101f:	89 55 10             	mov    %edx,0x10(%ebp)
  801022:	85 c0                	test   %eax,%eax
  801024:	75 c9                	jne    800fef <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801026:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80102b:	c9                   	leave  
  80102c:	c3                   	ret    

0080102d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80102d:	55                   	push   %ebp
  80102e:	89 e5                	mov    %esp,%ebp
  801030:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801033:	8b 55 08             	mov    0x8(%ebp),%edx
  801036:	8b 45 10             	mov    0x10(%ebp),%eax
  801039:	01 d0                	add    %edx,%eax
  80103b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80103e:	eb 15                	jmp    801055 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801040:	8b 45 08             	mov    0x8(%ebp),%eax
  801043:	8a 00                	mov    (%eax),%al
  801045:	0f b6 d0             	movzbl %al,%edx
  801048:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104b:	0f b6 c0             	movzbl %al,%eax
  80104e:	39 c2                	cmp    %eax,%edx
  801050:	74 0d                	je     80105f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801052:	ff 45 08             	incl   0x8(%ebp)
  801055:	8b 45 08             	mov    0x8(%ebp),%eax
  801058:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80105b:	72 e3                	jb     801040 <memfind+0x13>
  80105d:	eb 01                	jmp    801060 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80105f:	90                   	nop
	return (void *) s;
  801060:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801063:	c9                   	leave  
  801064:	c3                   	ret    

00801065 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801065:	55                   	push   %ebp
  801066:	89 e5                	mov    %esp,%ebp
  801068:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80106b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801072:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801079:	eb 03                	jmp    80107e <strtol+0x19>
		s++;
  80107b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80107e:	8b 45 08             	mov    0x8(%ebp),%eax
  801081:	8a 00                	mov    (%eax),%al
  801083:	3c 20                	cmp    $0x20,%al
  801085:	74 f4                	je     80107b <strtol+0x16>
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	8a 00                	mov    (%eax),%al
  80108c:	3c 09                	cmp    $0x9,%al
  80108e:	74 eb                	je     80107b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801090:	8b 45 08             	mov    0x8(%ebp),%eax
  801093:	8a 00                	mov    (%eax),%al
  801095:	3c 2b                	cmp    $0x2b,%al
  801097:	75 05                	jne    80109e <strtol+0x39>
		s++;
  801099:	ff 45 08             	incl   0x8(%ebp)
  80109c:	eb 13                	jmp    8010b1 <strtol+0x4c>
	else if (*s == '-')
  80109e:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a1:	8a 00                	mov    (%eax),%al
  8010a3:	3c 2d                	cmp    $0x2d,%al
  8010a5:	75 0a                	jne    8010b1 <strtol+0x4c>
		s++, neg = 1;
  8010a7:	ff 45 08             	incl   0x8(%ebp)
  8010aa:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010b5:	74 06                	je     8010bd <strtol+0x58>
  8010b7:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010bb:	75 20                	jne    8010dd <strtol+0x78>
  8010bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c0:	8a 00                	mov    (%eax),%al
  8010c2:	3c 30                	cmp    $0x30,%al
  8010c4:	75 17                	jne    8010dd <strtol+0x78>
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c9:	40                   	inc    %eax
  8010ca:	8a 00                	mov    (%eax),%al
  8010cc:	3c 78                	cmp    $0x78,%al
  8010ce:	75 0d                	jne    8010dd <strtol+0x78>
		s += 2, base = 16;
  8010d0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010d4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010db:	eb 28                	jmp    801105 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010dd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010e1:	75 15                	jne    8010f8 <strtol+0x93>
  8010e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e6:	8a 00                	mov    (%eax),%al
  8010e8:	3c 30                	cmp    $0x30,%al
  8010ea:	75 0c                	jne    8010f8 <strtol+0x93>
		s++, base = 8;
  8010ec:	ff 45 08             	incl   0x8(%ebp)
  8010ef:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010f6:	eb 0d                	jmp    801105 <strtol+0xa0>
	else if (base == 0)
  8010f8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010fc:	75 07                	jne    801105 <strtol+0xa0>
		base = 10;
  8010fe:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801105:	8b 45 08             	mov    0x8(%ebp),%eax
  801108:	8a 00                	mov    (%eax),%al
  80110a:	3c 2f                	cmp    $0x2f,%al
  80110c:	7e 19                	jle    801127 <strtol+0xc2>
  80110e:	8b 45 08             	mov    0x8(%ebp),%eax
  801111:	8a 00                	mov    (%eax),%al
  801113:	3c 39                	cmp    $0x39,%al
  801115:	7f 10                	jg     801127 <strtol+0xc2>
			dig = *s - '0';
  801117:	8b 45 08             	mov    0x8(%ebp),%eax
  80111a:	8a 00                	mov    (%eax),%al
  80111c:	0f be c0             	movsbl %al,%eax
  80111f:	83 e8 30             	sub    $0x30,%eax
  801122:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801125:	eb 42                	jmp    801169 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801127:	8b 45 08             	mov    0x8(%ebp),%eax
  80112a:	8a 00                	mov    (%eax),%al
  80112c:	3c 60                	cmp    $0x60,%al
  80112e:	7e 19                	jle    801149 <strtol+0xe4>
  801130:	8b 45 08             	mov    0x8(%ebp),%eax
  801133:	8a 00                	mov    (%eax),%al
  801135:	3c 7a                	cmp    $0x7a,%al
  801137:	7f 10                	jg     801149 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801139:	8b 45 08             	mov    0x8(%ebp),%eax
  80113c:	8a 00                	mov    (%eax),%al
  80113e:	0f be c0             	movsbl %al,%eax
  801141:	83 e8 57             	sub    $0x57,%eax
  801144:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801147:	eb 20                	jmp    801169 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801149:	8b 45 08             	mov    0x8(%ebp),%eax
  80114c:	8a 00                	mov    (%eax),%al
  80114e:	3c 40                	cmp    $0x40,%al
  801150:	7e 39                	jle    80118b <strtol+0x126>
  801152:	8b 45 08             	mov    0x8(%ebp),%eax
  801155:	8a 00                	mov    (%eax),%al
  801157:	3c 5a                	cmp    $0x5a,%al
  801159:	7f 30                	jg     80118b <strtol+0x126>
			dig = *s - 'A' + 10;
  80115b:	8b 45 08             	mov    0x8(%ebp),%eax
  80115e:	8a 00                	mov    (%eax),%al
  801160:	0f be c0             	movsbl %al,%eax
  801163:	83 e8 37             	sub    $0x37,%eax
  801166:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801169:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80116c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80116f:	7d 19                	jge    80118a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801171:	ff 45 08             	incl   0x8(%ebp)
  801174:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801177:	0f af 45 10          	imul   0x10(%ebp),%eax
  80117b:	89 c2                	mov    %eax,%edx
  80117d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801180:	01 d0                	add    %edx,%eax
  801182:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801185:	e9 7b ff ff ff       	jmp    801105 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80118a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80118b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80118f:	74 08                	je     801199 <strtol+0x134>
		*endptr = (char *) s;
  801191:	8b 45 0c             	mov    0xc(%ebp),%eax
  801194:	8b 55 08             	mov    0x8(%ebp),%edx
  801197:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801199:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80119d:	74 07                	je     8011a6 <strtol+0x141>
  80119f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a2:	f7 d8                	neg    %eax
  8011a4:	eb 03                	jmp    8011a9 <strtol+0x144>
  8011a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011a9:	c9                   	leave  
  8011aa:	c3                   	ret    

008011ab <ltostr>:

void
ltostr(long value, char *str)
{
  8011ab:	55                   	push   %ebp
  8011ac:	89 e5                	mov    %esp,%ebp
  8011ae:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011b8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011c3:	79 13                	jns    8011d8 <ltostr+0x2d>
	{
		neg = 1;
  8011c5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cf:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011d2:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011d5:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011db:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011e0:	99                   	cltd   
  8011e1:	f7 f9                	idiv   %ecx
  8011e3:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e9:	8d 50 01             	lea    0x1(%eax),%edx
  8011ec:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011ef:	89 c2                	mov    %eax,%edx
  8011f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f4:	01 d0                	add    %edx,%eax
  8011f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011f9:	83 c2 30             	add    $0x30,%edx
  8011fc:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801201:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801206:	f7 e9                	imul   %ecx
  801208:	c1 fa 02             	sar    $0x2,%edx
  80120b:	89 c8                	mov    %ecx,%eax
  80120d:	c1 f8 1f             	sar    $0x1f,%eax
  801210:	29 c2                	sub    %eax,%edx
  801212:	89 d0                	mov    %edx,%eax
  801214:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801217:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80121a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80121f:	f7 e9                	imul   %ecx
  801221:	c1 fa 02             	sar    $0x2,%edx
  801224:	89 c8                	mov    %ecx,%eax
  801226:	c1 f8 1f             	sar    $0x1f,%eax
  801229:	29 c2                	sub    %eax,%edx
  80122b:	89 d0                	mov    %edx,%eax
  80122d:	c1 e0 02             	shl    $0x2,%eax
  801230:	01 d0                	add    %edx,%eax
  801232:	01 c0                	add    %eax,%eax
  801234:	29 c1                	sub    %eax,%ecx
  801236:	89 ca                	mov    %ecx,%edx
  801238:	85 d2                	test   %edx,%edx
  80123a:	75 9c                	jne    8011d8 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80123c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801243:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801246:	48                   	dec    %eax
  801247:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80124a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80124e:	74 3d                	je     80128d <ltostr+0xe2>
		start = 1 ;
  801250:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801257:	eb 34                	jmp    80128d <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801259:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80125c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125f:	01 d0                	add    %edx,%eax
  801261:	8a 00                	mov    (%eax),%al
  801263:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801266:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801269:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126c:	01 c2                	add    %eax,%edx
  80126e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801271:	8b 45 0c             	mov    0xc(%ebp),%eax
  801274:	01 c8                	add    %ecx,%eax
  801276:	8a 00                	mov    (%eax),%al
  801278:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80127a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80127d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801280:	01 c2                	add    %eax,%edx
  801282:	8a 45 eb             	mov    -0x15(%ebp),%al
  801285:	88 02                	mov    %al,(%edx)
		start++ ;
  801287:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80128a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80128d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801290:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801293:	7c c4                	jl     801259 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801295:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801298:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129b:	01 d0                	add    %edx,%eax
  80129d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012a0:	90                   	nop
  8012a1:	c9                   	leave  
  8012a2:	c3                   	ret    

008012a3 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012a3:	55                   	push   %ebp
  8012a4:	89 e5                	mov    %esp,%ebp
  8012a6:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012a9:	ff 75 08             	pushl  0x8(%ebp)
  8012ac:	e8 54 fa ff ff       	call   800d05 <strlen>
  8012b1:	83 c4 04             	add    $0x4,%esp
  8012b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012b7:	ff 75 0c             	pushl  0xc(%ebp)
  8012ba:	e8 46 fa ff ff       	call   800d05 <strlen>
  8012bf:	83 c4 04             	add    $0x4,%esp
  8012c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012d3:	eb 17                	jmp    8012ec <strcconcat+0x49>
		final[s] = str1[s] ;
  8012d5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012db:	01 c2                	add    %eax,%edx
  8012dd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e3:	01 c8                	add    %ecx,%eax
  8012e5:	8a 00                	mov    (%eax),%al
  8012e7:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012e9:	ff 45 fc             	incl   -0x4(%ebp)
  8012ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012ef:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012f2:	7c e1                	jl     8012d5 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012f4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012fb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801302:	eb 1f                	jmp    801323 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801304:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801307:	8d 50 01             	lea    0x1(%eax),%edx
  80130a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80130d:	89 c2                	mov    %eax,%edx
  80130f:	8b 45 10             	mov    0x10(%ebp),%eax
  801312:	01 c2                	add    %eax,%edx
  801314:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801317:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131a:	01 c8                	add    %ecx,%eax
  80131c:	8a 00                	mov    (%eax),%al
  80131e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801320:	ff 45 f8             	incl   -0x8(%ebp)
  801323:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801326:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801329:	7c d9                	jl     801304 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80132b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80132e:	8b 45 10             	mov    0x10(%ebp),%eax
  801331:	01 d0                	add    %edx,%eax
  801333:	c6 00 00             	movb   $0x0,(%eax)
}
  801336:	90                   	nop
  801337:	c9                   	leave  
  801338:	c3                   	ret    

00801339 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801339:	55                   	push   %ebp
  80133a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80133c:	8b 45 14             	mov    0x14(%ebp),%eax
  80133f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801345:	8b 45 14             	mov    0x14(%ebp),%eax
  801348:	8b 00                	mov    (%eax),%eax
  80134a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801351:	8b 45 10             	mov    0x10(%ebp),%eax
  801354:	01 d0                	add    %edx,%eax
  801356:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80135c:	eb 0c                	jmp    80136a <strsplit+0x31>
			*string++ = 0;
  80135e:	8b 45 08             	mov    0x8(%ebp),%eax
  801361:	8d 50 01             	lea    0x1(%eax),%edx
  801364:	89 55 08             	mov    %edx,0x8(%ebp)
  801367:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80136a:	8b 45 08             	mov    0x8(%ebp),%eax
  80136d:	8a 00                	mov    (%eax),%al
  80136f:	84 c0                	test   %al,%al
  801371:	74 18                	je     80138b <strsplit+0x52>
  801373:	8b 45 08             	mov    0x8(%ebp),%eax
  801376:	8a 00                	mov    (%eax),%al
  801378:	0f be c0             	movsbl %al,%eax
  80137b:	50                   	push   %eax
  80137c:	ff 75 0c             	pushl  0xc(%ebp)
  80137f:	e8 13 fb ff ff       	call   800e97 <strchr>
  801384:	83 c4 08             	add    $0x8,%esp
  801387:	85 c0                	test   %eax,%eax
  801389:	75 d3                	jne    80135e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80138b:	8b 45 08             	mov    0x8(%ebp),%eax
  80138e:	8a 00                	mov    (%eax),%al
  801390:	84 c0                	test   %al,%al
  801392:	74 5a                	je     8013ee <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801394:	8b 45 14             	mov    0x14(%ebp),%eax
  801397:	8b 00                	mov    (%eax),%eax
  801399:	83 f8 0f             	cmp    $0xf,%eax
  80139c:	75 07                	jne    8013a5 <strsplit+0x6c>
		{
			return 0;
  80139e:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a3:	eb 66                	jmp    80140b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8013a8:	8b 00                	mov    (%eax),%eax
  8013aa:	8d 48 01             	lea    0x1(%eax),%ecx
  8013ad:	8b 55 14             	mov    0x14(%ebp),%edx
  8013b0:	89 0a                	mov    %ecx,(%edx)
  8013b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013bc:	01 c2                	add    %eax,%edx
  8013be:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c1:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013c3:	eb 03                	jmp    8013c8 <strsplit+0x8f>
			string++;
  8013c5:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cb:	8a 00                	mov    (%eax),%al
  8013cd:	84 c0                	test   %al,%al
  8013cf:	74 8b                	je     80135c <strsplit+0x23>
  8013d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d4:	8a 00                	mov    (%eax),%al
  8013d6:	0f be c0             	movsbl %al,%eax
  8013d9:	50                   	push   %eax
  8013da:	ff 75 0c             	pushl  0xc(%ebp)
  8013dd:	e8 b5 fa ff ff       	call   800e97 <strchr>
  8013e2:	83 c4 08             	add    $0x8,%esp
  8013e5:	85 c0                	test   %eax,%eax
  8013e7:	74 dc                	je     8013c5 <strsplit+0x8c>
			string++;
	}
  8013e9:	e9 6e ff ff ff       	jmp    80135c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013ee:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f2:	8b 00                	mov    (%eax),%eax
  8013f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fe:	01 d0                	add    %edx,%eax
  801400:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801406:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80140b:	c9                   	leave  
  80140c:	c3                   	ret    

0080140d <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80140d:	55                   	push   %ebp
  80140e:	89 e5                	mov    %esp,%ebp
  801410:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801413:	a1 04 40 80 00       	mov    0x804004,%eax
  801418:	85 c0                	test   %eax,%eax
  80141a:	74 1f                	je     80143b <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80141c:	e8 1d 00 00 00       	call   80143e <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801421:	83 ec 0c             	sub    $0xc,%esp
  801424:	68 90 3a 80 00       	push   $0x803a90
  801429:	e8 55 f2 ff ff       	call   800683 <cprintf>
  80142e:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801431:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801438:	00 00 00 
	}
}
  80143b:	90                   	nop
  80143c:	c9                   	leave  
  80143d:	c3                   	ret    

0080143e <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80143e:	55                   	push   %ebp
  80143f:	89 e5                	mov    %esp,%ebp
  801441:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801444:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80144b:	00 00 00 
  80144e:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801455:	00 00 00 
  801458:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80145f:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  801462:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801469:	00 00 00 
  80146c:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801473:	00 00 00 
  801476:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80147d:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801480:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801487:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  80148a:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801491:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801494:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801499:	2d 00 10 00 00       	sub    $0x1000,%eax
  80149e:	a3 50 40 80 00       	mov    %eax,0x804050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  8014a3:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8014aa:	a1 20 41 80 00       	mov    0x804120,%eax
  8014af:	c1 e0 04             	shl    $0x4,%eax
  8014b2:	89 c2                	mov    %eax,%edx
  8014b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014b7:	01 d0                	add    %edx,%eax
  8014b9:	48                   	dec    %eax
  8014ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8014bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8014c5:	f7 75 f0             	divl   -0x10(%ebp)
  8014c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014cb:	29 d0                	sub    %edx,%eax
  8014cd:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  8014d0:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8014d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014da:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014df:	2d 00 10 00 00       	sub    $0x1000,%eax
  8014e4:	83 ec 04             	sub    $0x4,%esp
  8014e7:	6a 06                	push   $0x6
  8014e9:	ff 75 e8             	pushl  -0x18(%ebp)
  8014ec:	50                   	push   %eax
  8014ed:	e8 b0 05 00 00       	call   801aa2 <sys_allocate_chunk>
  8014f2:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8014f5:	a1 20 41 80 00       	mov    0x804120,%eax
  8014fa:	83 ec 0c             	sub    $0xc,%esp
  8014fd:	50                   	push   %eax
  8014fe:	e8 25 0c 00 00       	call   802128 <initialize_MemBlocksList>
  801503:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  801506:	a1 48 41 80 00       	mov    0x804148,%eax
  80150b:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  80150e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801512:	75 14                	jne    801528 <initialize_dyn_block_system+0xea>
  801514:	83 ec 04             	sub    $0x4,%esp
  801517:	68 b5 3a 80 00       	push   $0x803ab5
  80151c:	6a 29                	push   $0x29
  80151e:	68 d3 3a 80 00       	push   $0x803ad3
  801523:	e8 43 1c 00 00       	call   80316b <_panic>
  801528:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80152b:	8b 00                	mov    (%eax),%eax
  80152d:	85 c0                	test   %eax,%eax
  80152f:	74 10                	je     801541 <initialize_dyn_block_system+0x103>
  801531:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801534:	8b 00                	mov    (%eax),%eax
  801536:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801539:	8b 52 04             	mov    0x4(%edx),%edx
  80153c:	89 50 04             	mov    %edx,0x4(%eax)
  80153f:	eb 0b                	jmp    80154c <initialize_dyn_block_system+0x10e>
  801541:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801544:	8b 40 04             	mov    0x4(%eax),%eax
  801547:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80154c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80154f:	8b 40 04             	mov    0x4(%eax),%eax
  801552:	85 c0                	test   %eax,%eax
  801554:	74 0f                	je     801565 <initialize_dyn_block_system+0x127>
  801556:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801559:	8b 40 04             	mov    0x4(%eax),%eax
  80155c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80155f:	8b 12                	mov    (%edx),%edx
  801561:	89 10                	mov    %edx,(%eax)
  801563:	eb 0a                	jmp    80156f <initialize_dyn_block_system+0x131>
  801565:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801568:	8b 00                	mov    (%eax),%eax
  80156a:	a3 48 41 80 00       	mov    %eax,0x804148
  80156f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801572:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801578:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80157b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801582:	a1 54 41 80 00       	mov    0x804154,%eax
  801587:	48                   	dec    %eax
  801588:	a3 54 41 80 00       	mov    %eax,0x804154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  80158d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801590:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  801597:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80159a:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  8015a1:	83 ec 0c             	sub    $0xc,%esp
  8015a4:	ff 75 e0             	pushl  -0x20(%ebp)
  8015a7:	e8 b9 14 00 00       	call   802a65 <insert_sorted_with_merge_freeList>
  8015ac:	83 c4 10             	add    $0x10,%esp

}
  8015af:	90                   	nop
  8015b0:	c9                   	leave  
  8015b1:	c3                   	ret    

008015b2 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8015b2:	55                   	push   %ebp
  8015b3:	89 e5                	mov    %esp,%ebp
  8015b5:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015b8:	e8 50 fe ff ff       	call   80140d <InitializeUHeap>
	if (size == 0) return NULL ;
  8015bd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015c1:	75 07                	jne    8015ca <malloc+0x18>
  8015c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c8:	eb 68                	jmp    801632 <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  8015ca:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8015d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8015d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d7:	01 d0                	add    %edx,%eax
  8015d9:	48                   	dec    %eax
  8015da:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8015e5:	f7 75 f4             	divl   -0xc(%ebp)
  8015e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015eb:	29 d0                	sub    %edx,%eax
  8015ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  8015f0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8015f7:	e8 74 08 00 00       	call   801e70 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015fc:	85 c0                	test   %eax,%eax
  8015fe:	74 2d                	je     80162d <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  801600:	83 ec 0c             	sub    $0xc,%esp
  801603:	ff 75 ec             	pushl  -0x14(%ebp)
  801606:	e8 52 0e 00 00       	call   80245d <alloc_block_FF>
  80160b:	83 c4 10             	add    $0x10,%esp
  80160e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  801611:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801615:	74 16                	je     80162d <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  801617:	83 ec 0c             	sub    $0xc,%esp
  80161a:	ff 75 e8             	pushl  -0x18(%ebp)
  80161d:	e8 3b 0c 00 00       	call   80225d <insert_sorted_allocList>
  801622:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  801625:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801628:	8b 40 08             	mov    0x8(%eax),%eax
  80162b:	eb 05                	jmp    801632 <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  80162d:	b8 00 00 00 00       	mov    $0x0,%eax

}
  801632:	c9                   	leave  
  801633:	c3                   	ret    

00801634 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801634:	55                   	push   %ebp
  801635:	89 e5                	mov    %esp,%ebp
  801637:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  80163a:	8b 45 08             	mov    0x8(%ebp),%eax
  80163d:	83 ec 08             	sub    $0x8,%esp
  801640:	50                   	push   %eax
  801641:	68 40 40 80 00       	push   $0x804040
  801646:	e8 ba 0b 00 00       	call   802205 <find_block>
  80164b:	83 c4 10             	add    $0x10,%esp
  80164e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  801651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801654:	8b 40 0c             	mov    0xc(%eax),%eax
  801657:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  80165a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80165e:	0f 84 9f 00 00 00    	je     801703 <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  801664:	8b 45 08             	mov    0x8(%ebp),%eax
  801667:	83 ec 08             	sub    $0x8,%esp
  80166a:	ff 75 f0             	pushl  -0x10(%ebp)
  80166d:	50                   	push   %eax
  80166e:	e8 f7 03 00 00       	call   801a6a <sys_free_user_mem>
  801673:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  801676:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80167a:	75 14                	jne    801690 <free+0x5c>
  80167c:	83 ec 04             	sub    $0x4,%esp
  80167f:	68 b5 3a 80 00       	push   $0x803ab5
  801684:	6a 6a                	push   $0x6a
  801686:	68 d3 3a 80 00       	push   $0x803ad3
  80168b:	e8 db 1a 00 00       	call   80316b <_panic>
  801690:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801693:	8b 00                	mov    (%eax),%eax
  801695:	85 c0                	test   %eax,%eax
  801697:	74 10                	je     8016a9 <free+0x75>
  801699:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80169c:	8b 00                	mov    (%eax),%eax
  80169e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016a1:	8b 52 04             	mov    0x4(%edx),%edx
  8016a4:	89 50 04             	mov    %edx,0x4(%eax)
  8016a7:	eb 0b                	jmp    8016b4 <free+0x80>
  8016a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ac:	8b 40 04             	mov    0x4(%eax),%eax
  8016af:	a3 44 40 80 00       	mov    %eax,0x804044
  8016b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016b7:	8b 40 04             	mov    0x4(%eax),%eax
  8016ba:	85 c0                	test   %eax,%eax
  8016bc:	74 0f                	je     8016cd <free+0x99>
  8016be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c1:	8b 40 04             	mov    0x4(%eax),%eax
  8016c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016c7:	8b 12                	mov    (%edx),%edx
  8016c9:	89 10                	mov    %edx,(%eax)
  8016cb:	eb 0a                	jmp    8016d7 <free+0xa3>
  8016cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016d0:	8b 00                	mov    (%eax),%eax
  8016d2:	a3 40 40 80 00       	mov    %eax,0x804040
  8016d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8016e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8016ea:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8016ef:	48                   	dec    %eax
  8016f0:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(blk);
  8016f5:	83 ec 0c             	sub    $0xc,%esp
  8016f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8016fb:	e8 65 13 00 00       	call   802a65 <insert_sorted_with_merge_freeList>
  801700:	83 c4 10             	add    $0x10,%esp
	}
}
  801703:	90                   	nop
  801704:	c9                   	leave  
  801705:	c3                   	ret    

00801706 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801706:	55                   	push   %ebp
  801707:	89 e5                	mov    %esp,%ebp
  801709:	83 ec 28             	sub    $0x28,%esp
  80170c:	8b 45 10             	mov    0x10(%ebp),%eax
  80170f:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801712:	e8 f6 fc ff ff       	call   80140d <InitializeUHeap>
	if (size == 0) return NULL ;
  801717:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80171b:	75 0a                	jne    801727 <smalloc+0x21>
  80171d:	b8 00 00 00 00       	mov    $0x0,%eax
  801722:	e9 af 00 00 00       	jmp    8017d6 <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  801727:	e8 44 07 00 00       	call   801e70 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80172c:	83 f8 01             	cmp    $0x1,%eax
  80172f:	0f 85 9c 00 00 00    	jne    8017d1 <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  801735:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80173c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80173f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801742:	01 d0                	add    %edx,%eax
  801744:	48                   	dec    %eax
  801745:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801748:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80174b:	ba 00 00 00 00       	mov    $0x0,%edx
  801750:	f7 75 f4             	divl   -0xc(%ebp)
  801753:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801756:	29 d0                	sub    %edx,%eax
  801758:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  80175b:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  801762:	76 07                	jbe    80176b <smalloc+0x65>
			return NULL;
  801764:	b8 00 00 00 00       	mov    $0x0,%eax
  801769:	eb 6b                	jmp    8017d6 <smalloc+0xd0>
		blk =alloc_block_FF(size);
  80176b:	83 ec 0c             	sub    $0xc,%esp
  80176e:	ff 75 0c             	pushl  0xc(%ebp)
  801771:	e8 e7 0c 00 00       	call   80245d <alloc_block_FF>
  801776:	83 c4 10             	add    $0x10,%esp
  801779:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  80177c:	83 ec 0c             	sub    $0xc,%esp
  80177f:	ff 75 ec             	pushl  -0x14(%ebp)
  801782:	e8 d6 0a 00 00       	call   80225d <insert_sorted_allocList>
  801787:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  80178a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80178e:	75 07                	jne    801797 <smalloc+0x91>
		{
			return NULL;
  801790:	b8 00 00 00 00       	mov    $0x0,%eax
  801795:	eb 3f                	jmp    8017d6 <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  801797:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80179a:	8b 40 08             	mov    0x8(%eax),%eax
  80179d:	89 c2                	mov    %eax,%edx
  80179f:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8017a3:	52                   	push   %edx
  8017a4:	50                   	push   %eax
  8017a5:	ff 75 0c             	pushl  0xc(%ebp)
  8017a8:	ff 75 08             	pushl  0x8(%ebp)
  8017ab:	e8 45 04 00 00       	call   801bf5 <sys_createSharedObject>
  8017b0:	83 c4 10             	add    $0x10,%esp
  8017b3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  8017b6:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8017ba:	74 06                	je     8017c2 <smalloc+0xbc>
  8017bc:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8017c0:	75 07                	jne    8017c9 <smalloc+0xc3>
		{
			return NULL;
  8017c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c7:	eb 0d                	jmp    8017d6 <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  8017c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017cc:	8b 40 08             	mov    0x8(%eax),%eax
  8017cf:	eb 05                	jmp    8017d6 <smalloc+0xd0>
		}
	}
	else
		return NULL;
  8017d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017d6:	c9                   	leave  
  8017d7:	c3                   	ret    

008017d8 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017d8:	55                   	push   %ebp
  8017d9:	89 e5                	mov    %esp,%ebp
  8017db:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017de:	e8 2a fc ff ff       	call   80140d <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8017e3:	83 ec 08             	sub    $0x8,%esp
  8017e6:	ff 75 0c             	pushl  0xc(%ebp)
  8017e9:	ff 75 08             	pushl  0x8(%ebp)
  8017ec:	e8 2e 04 00 00       	call   801c1f <sys_getSizeOfSharedObject>
  8017f1:	83 c4 10             	add    $0x10,%esp
  8017f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  8017f7:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8017fb:	75 0a                	jne    801807 <sget+0x2f>
	{
		return NULL;
  8017fd:	b8 00 00 00 00       	mov    $0x0,%eax
  801802:	e9 94 00 00 00       	jmp    80189b <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801807:	e8 64 06 00 00       	call   801e70 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80180c:	85 c0                	test   %eax,%eax
  80180e:	0f 84 82 00 00 00    	je     801896 <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  801814:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  80181b:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801822:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801825:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801828:	01 d0                	add    %edx,%eax
  80182a:	48                   	dec    %eax
  80182b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80182e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801831:	ba 00 00 00 00       	mov    $0x0,%edx
  801836:	f7 75 ec             	divl   -0x14(%ebp)
  801839:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80183c:	29 d0                	sub    %edx,%eax
  80183e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  801841:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801844:	83 ec 0c             	sub    $0xc,%esp
  801847:	50                   	push   %eax
  801848:	e8 10 0c 00 00       	call   80245d <alloc_block_FF>
  80184d:	83 c4 10             	add    $0x10,%esp
  801850:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  801853:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801857:	75 07                	jne    801860 <sget+0x88>
		{
			return NULL;
  801859:	b8 00 00 00 00       	mov    $0x0,%eax
  80185e:	eb 3b                	jmp    80189b <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  801860:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801863:	8b 40 08             	mov    0x8(%eax),%eax
  801866:	83 ec 04             	sub    $0x4,%esp
  801869:	50                   	push   %eax
  80186a:	ff 75 0c             	pushl  0xc(%ebp)
  80186d:	ff 75 08             	pushl  0x8(%ebp)
  801870:	e8 c7 03 00 00       	call   801c3c <sys_getSharedObject>
  801875:	83 c4 10             	add    $0x10,%esp
  801878:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  80187b:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  80187f:	74 06                	je     801887 <sget+0xaf>
  801881:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  801885:	75 07                	jne    80188e <sget+0xb6>
		{
			return NULL;
  801887:	b8 00 00 00 00       	mov    $0x0,%eax
  80188c:	eb 0d                	jmp    80189b <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  80188e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801891:	8b 40 08             	mov    0x8(%eax),%eax
  801894:	eb 05                	jmp    80189b <sget+0xc3>
		}
	}
	else
			return NULL;
  801896:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80189b:	c9                   	leave  
  80189c:	c3                   	ret    

0080189d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80189d:	55                   	push   %ebp
  80189e:	89 e5                	mov    %esp,%ebp
  8018a0:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018a3:	e8 65 fb ff ff       	call   80140d <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8018a8:	83 ec 04             	sub    $0x4,%esp
  8018ab:	68 e0 3a 80 00       	push   $0x803ae0
  8018b0:	68 e1 00 00 00       	push   $0xe1
  8018b5:	68 d3 3a 80 00       	push   $0x803ad3
  8018ba:	e8 ac 18 00 00       	call   80316b <_panic>

008018bf <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8018bf:	55                   	push   %ebp
  8018c0:	89 e5                	mov    %esp,%ebp
  8018c2:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8018c5:	83 ec 04             	sub    $0x4,%esp
  8018c8:	68 08 3b 80 00       	push   $0x803b08
  8018cd:	68 f5 00 00 00       	push   $0xf5
  8018d2:	68 d3 3a 80 00       	push   $0x803ad3
  8018d7:	e8 8f 18 00 00       	call   80316b <_panic>

008018dc <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
  8018df:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018e2:	83 ec 04             	sub    $0x4,%esp
  8018e5:	68 2c 3b 80 00       	push   $0x803b2c
  8018ea:	68 00 01 00 00       	push   $0x100
  8018ef:	68 d3 3a 80 00       	push   $0x803ad3
  8018f4:	e8 72 18 00 00       	call   80316b <_panic>

008018f9 <shrink>:

}
void shrink(uint32 newSize)
{
  8018f9:	55                   	push   %ebp
  8018fa:	89 e5                	mov    %esp,%ebp
  8018fc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018ff:	83 ec 04             	sub    $0x4,%esp
  801902:	68 2c 3b 80 00       	push   $0x803b2c
  801907:	68 05 01 00 00       	push   $0x105
  80190c:	68 d3 3a 80 00       	push   $0x803ad3
  801911:	e8 55 18 00 00       	call   80316b <_panic>

00801916 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801916:	55                   	push   %ebp
  801917:	89 e5                	mov    %esp,%ebp
  801919:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80191c:	83 ec 04             	sub    $0x4,%esp
  80191f:	68 2c 3b 80 00       	push   $0x803b2c
  801924:	68 0a 01 00 00       	push   $0x10a
  801929:	68 d3 3a 80 00       	push   $0x803ad3
  80192e:	e8 38 18 00 00       	call   80316b <_panic>

00801933 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801933:	55                   	push   %ebp
  801934:	89 e5                	mov    %esp,%ebp
  801936:	57                   	push   %edi
  801937:	56                   	push   %esi
  801938:	53                   	push   %ebx
  801939:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80193c:	8b 45 08             	mov    0x8(%ebp),%eax
  80193f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801942:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801945:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801948:	8b 7d 18             	mov    0x18(%ebp),%edi
  80194b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80194e:	cd 30                	int    $0x30
  801950:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801953:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801956:	83 c4 10             	add    $0x10,%esp
  801959:	5b                   	pop    %ebx
  80195a:	5e                   	pop    %esi
  80195b:	5f                   	pop    %edi
  80195c:	5d                   	pop    %ebp
  80195d:	c3                   	ret    

0080195e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80195e:	55                   	push   %ebp
  80195f:	89 e5                	mov    %esp,%ebp
  801961:	83 ec 04             	sub    $0x4,%esp
  801964:	8b 45 10             	mov    0x10(%ebp),%eax
  801967:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80196a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80196e:	8b 45 08             	mov    0x8(%ebp),%eax
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	52                   	push   %edx
  801976:	ff 75 0c             	pushl  0xc(%ebp)
  801979:	50                   	push   %eax
  80197a:	6a 00                	push   $0x0
  80197c:	e8 b2 ff ff ff       	call   801933 <syscall>
  801981:	83 c4 18             	add    $0x18,%esp
}
  801984:	90                   	nop
  801985:	c9                   	leave  
  801986:	c3                   	ret    

00801987 <sys_cgetc>:

int
sys_cgetc(void)
{
  801987:	55                   	push   %ebp
  801988:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	6a 01                	push   $0x1
  801996:	e8 98 ff ff ff       	call   801933 <syscall>
  80199b:	83 c4 18             	add    $0x18,%esp
}
  80199e:	c9                   	leave  
  80199f:	c3                   	ret    

008019a0 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8019a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	52                   	push   %edx
  8019b0:	50                   	push   %eax
  8019b1:	6a 05                	push   $0x5
  8019b3:	e8 7b ff ff ff       	call   801933 <syscall>
  8019b8:	83 c4 18             	add    $0x18,%esp
}
  8019bb:	c9                   	leave  
  8019bc:	c3                   	ret    

008019bd <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8019bd:	55                   	push   %ebp
  8019be:	89 e5                	mov    %esp,%ebp
  8019c0:	56                   	push   %esi
  8019c1:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8019c2:	8b 75 18             	mov    0x18(%ebp),%esi
  8019c5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019c8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d1:	56                   	push   %esi
  8019d2:	53                   	push   %ebx
  8019d3:	51                   	push   %ecx
  8019d4:	52                   	push   %edx
  8019d5:	50                   	push   %eax
  8019d6:	6a 06                	push   $0x6
  8019d8:	e8 56 ff ff ff       	call   801933 <syscall>
  8019dd:	83 c4 18             	add    $0x18,%esp
}
  8019e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019e3:	5b                   	pop    %ebx
  8019e4:	5e                   	pop    %esi
  8019e5:	5d                   	pop    %ebp
  8019e6:	c3                   	ret    

008019e7 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8019e7:	55                   	push   %ebp
  8019e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8019ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	52                   	push   %edx
  8019f7:	50                   	push   %eax
  8019f8:	6a 07                	push   $0x7
  8019fa:	e8 34 ff ff ff       	call   801933 <syscall>
  8019ff:	83 c4 18             	add    $0x18,%esp
}
  801a02:	c9                   	leave  
  801a03:	c3                   	ret    

00801a04 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a04:	55                   	push   %ebp
  801a05:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	ff 75 0c             	pushl  0xc(%ebp)
  801a10:	ff 75 08             	pushl  0x8(%ebp)
  801a13:	6a 08                	push   $0x8
  801a15:	e8 19 ff ff ff       	call   801933 <syscall>
  801a1a:	83 c4 18             	add    $0x18,%esp
}
  801a1d:	c9                   	leave  
  801a1e:	c3                   	ret    

00801a1f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a1f:	55                   	push   %ebp
  801a20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 09                	push   $0x9
  801a2e:	e8 00 ff ff ff       	call   801933 <syscall>
  801a33:	83 c4 18             	add    $0x18,%esp
}
  801a36:	c9                   	leave  
  801a37:	c3                   	ret    

00801a38 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a38:	55                   	push   %ebp
  801a39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	6a 0a                	push   $0xa
  801a47:	e8 e7 fe ff ff       	call   801933 <syscall>
  801a4c:	83 c4 18             	add    $0x18,%esp
}
  801a4f:	c9                   	leave  
  801a50:	c3                   	ret    

00801a51 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 0b                	push   $0xb
  801a60:	e8 ce fe ff ff       	call   801933 <syscall>
  801a65:	83 c4 18             	add    $0x18,%esp
}
  801a68:	c9                   	leave  
  801a69:	c3                   	ret    

00801a6a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	ff 75 0c             	pushl  0xc(%ebp)
  801a76:	ff 75 08             	pushl  0x8(%ebp)
  801a79:	6a 0f                	push   $0xf
  801a7b:	e8 b3 fe ff ff       	call   801933 <syscall>
  801a80:	83 c4 18             	add    $0x18,%esp
	return;
  801a83:	90                   	nop
}
  801a84:	c9                   	leave  
  801a85:	c3                   	ret    

00801a86 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	ff 75 0c             	pushl  0xc(%ebp)
  801a92:	ff 75 08             	pushl  0x8(%ebp)
  801a95:	6a 10                	push   $0x10
  801a97:	e8 97 fe ff ff       	call   801933 <syscall>
  801a9c:	83 c4 18             	add    $0x18,%esp
	return ;
  801a9f:	90                   	nop
}
  801aa0:	c9                   	leave  
  801aa1:	c3                   	ret    

00801aa2 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801aa2:	55                   	push   %ebp
  801aa3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	ff 75 10             	pushl  0x10(%ebp)
  801aac:	ff 75 0c             	pushl  0xc(%ebp)
  801aaf:	ff 75 08             	pushl  0x8(%ebp)
  801ab2:	6a 11                	push   $0x11
  801ab4:	e8 7a fe ff ff       	call   801933 <syscall>
  801ab9:	83 c4 18             	add    $0x18,%esp
	return ;
  801abc:	90                   	nop
}
  801abd:	c9                   	leave  
  801abe:	c3                   	ret    

00801abf <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801abf:	55                   	push   %ebp
  801ac0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 0c                	push   $0xc
  801ace:	e8 60 fe ff ff       	call   801933 <syscall>
  801ad3:	83 c4 18             	add    $0x18,%esp
}
  801ad6:	c9                   	leave  
  801ad7:	c3                   	ret    

00801ad8 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ad8:	55                   	push   %ebp
  801ad9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	ff 75 08             	pushl  0x8(%ebp)
  801ae6:	6a 0d                	push   $0xd
  801ae8:	e8 46 fe ff ff       	call   801933 <syscall>
  801aed:	83 c4 18             	add    $0x18,%esp
}
  801af0:	c9                   	leave  
  801af1:	c3                   	ret    

00801af2 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801af2:	55                   	push   %ebp
  801af3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	6a 0e                	push   $0xe
  801b01:	e8 2d fe ff ff       	call   801933 <syscall>
  801b06:	83 c4 18             	add    $0x18,%esp
}
  801b09:	90                   	nop
  801b0a:	c9                   	leave  
  801b0b:	c3                   	ret    

00801b0c <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801b0c:	55                   	push   %ebp
  801b0d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 13                	push   $0x13
  801b1b:	e8 13 fe ff ff       	call   801933 <syscall>
  801b20:	83 c4 18             	add    $0x18,%esp
}
  801b23:	90                   	nop
  801b24:	c9                   	leave  
  801b25:	c3                   	ret    

00801b26 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801b26:	55                   	push   %ebp
  801b27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 14                	push   $0x14
  801b35:	e8 f9 fd ff ff       	call   801933 <syscall>
  801b3a:	83 c4 18             	add    $0x18,%esp
}
  801b3d:	90                   	nop
  801b3e:	c9                   	leave  
  801b3f:	c3                   	ret    

00801b40 <sys_cputc>:


void
sys_cputc(const char c)
{
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
  801b43:	83 ec 04             	sub    $0x4,%esp
  801b46:	8b 45 08             	mov    0x8(%ebp),%eax
  801b49:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b4c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	50                   	push   %eax
  801b59:	6a 15                	push   $0x15
  801b5b:	e8 d3 fd ff ff       	call   801933 <syscall>
  801b60:	83 c4 18             	add    $0x18,%esp
}
  801b63:	90                   	nop
  801b64:	c9                   	leave  
  801b65:	c3                   	ret    

00801b66 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b66:	55                   	push   %ebp
  801b67:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 16                	push   $0x16
  801b75:	e8 b9 fd ff ff       	call   801933 <syscall>
  801b7a:	83 c4 18             	add    $0x18,%esp
}
  801b7d:	90                   	nop
  801b7e:	c9                   	leave  
  801b7f:	c3                   	ret    

00801b80 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b80:	55                   	push   %ebp
  801b81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b83:	8b 45 08             	mov    0x8(%ebp),%eax
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	ff 75 0c             	pushl  0xc(%ebp)
  801b8f:	50                   	push   %eax
  801b90:	6a 17                	push   $0x17
  801b92:	e8 9c fd ff ff       	call   801933 <syscall>
  801b97:	83 c4 18             	add    $0x18,%esp
}
  801b9a:	c9                   	leave  
  801b9b:	c3                   	ret    

00801b9c <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b9c:	55                   	push   %ebp
  801b9d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	52                   	push   %edx
  801bac:	50                   	push   %eax
  801bad:	6a 1a                	push   $0x1a
  801baf:	e8 7f fd ff ff       	call   801933 <syscall>
  801bb4:	83 c4 18             	add    $0x18,%esp
}
  801bb7:	c9                   	leave  
  801bb8:	c3                   	ret    

00801bb9 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	52                   	push   %edx
  801bc9:	50                   	push   %eax
  801bca:	6a 18                	push   $0x18
  801bcc:	e8 62 fd ff ff       	call   801933 <syscall>
  801bd1:	83 c4 18             	add    $0x18,%esp
}
  801bd4:	90                   	nop
  801bd5:	c9                   	leave  
  801bd6:	c3                   	ret    

00801bd7 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bd7:	55                   	push   %ebp
  801bd8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bda:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	52                   	push   %edx
  801be7:	50                   	push   %eax
  801be8:	6a 19                	push   $0x19
  801bea:	e8 44 fd ff ff       	call   801933 <syscall>
  801bef:	83 c4 18             	add    $0x18,%esp
}
  801bf2:	90                   	nop
  801bf3:	c9                   	leave  
  801bf4:	c3                   	ret    

00801bf5 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801bf5:	55                   	push   %ebp
  801bf6:	89 e5                	mov    %esp,%ebp
  801bf8:	83 ec 04             	sub    $0x4,%esp
  801bfb:	8b 45 10             	mov    0x10(%ebp),%eax
  801bfe:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c01:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c04:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c08:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0b:	6a 00                	push   $0x0
  801c0d:	51                   	push   %ecx
  801c0e:	52                   	push   %edx
  801c0f:	ff 75 0c             	pushl  0xc(%ebp)
  801c12:	50                   	push   %eax
  801c13:	6a 1b                	push   $0x1b
  801c15:	e8 19 fd ff ff       	call   801933 <syscall>
  801c1a:	83 c4 18             	add    $0x18,%esp
}
  801c1d:	c9                   	leave  
  801c1e:	c3                   	ret    

00801c1f <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c1f:	55                   	push   %ebp
  801c20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c22:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c25:	8b 45 08             	mov    0x8(%ebp),%eax
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	52                   	push   %edx
  801c2f:	50                   	push   %eax
  801c30:	6a 1c                	push   $0x1c
  801c32:	e8 fc fc ff ff       	call   801933 <syscall>
  801c37:	83 c4 18             	add    $0x18,%esp
}
  801c3a:	c9                   	leave  
  801c3b:	c3                   	ret    

00801c3c <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c3c:	55                   	push   %ebp
  801c3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c3f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c42:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c45:	8b 45 08             	mov    0x8(%ebp),%eax
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	51                   	push   %ecx
  801c4d:	52                   	push   %edx
  801c4e:	50                   	push   %eax
  801c4f:	6a 1d                	push   $0x1d
  801c51:	e8 dd fc ff ff       	call   801933 <syscall>
  801c56:	83 c4 18             	add    $0x18,%esp
}
  801c59:	c9                   	leave  
  801c5a:	c3                   	ret    

00801c5b <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c5b:	55                   	push   %ebp
  801c5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c61:	8b 45 08             	mov    0x8(%ebp),%eax
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	52                   	push   %edx
  801c6b:	50                   	push   %eax
  801c6c:	6a 1e                	push   $0x1e
  801c6e:	e8 c0 fc ff ff       	call   801933 <syscall>
  801c73:	83 c4 18             	add    $0x18,%esp
}
  801c76:	c9                   	leave  
  801c77:	c3                   	ret    

00801c78 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c78:	55                   	push   %ebp
  801c79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 1f                	push   $0x1f
  801c87:	e8 a7 fc ff ff       	call   801933 <syscall>
  801c8c:	83 c4 18             	add    $0x18,%esp
}
  801c8f:	c9                   	leave  
  801c90:	c3                   	ret    

00801c91 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c91:	55                   	push   %ebp
  801c92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c94:	8b 45 08             	mov    0x8(%ebp),%eax
  801c97:	6a 00                	push   $0x0
  801c99:	ff 75 14             	pushl  0x14(%ebp)
  801c9c:	ff 75 10             	pushl  0x10(%ebp)
  801c9f:	ff 75 0c             	pushl  0xc(%ebp)
  801ca2:	50                   	push   %eax
  801ca3:	6a 20                	push   $0x20
  801ca5:	e8 89 fc ff ff       	call   801933 <syscall>
  801caa:	83 c4 18             	add    $0x18,%esp
}
  801cad:	c9                   	leave  
  801cae:	c3                   	ret    

00801caf <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801caf:	55                   	push   %ebp
  801cb0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	50                   	push   %eax
  801cbe:	6a 21                	push   $0x21
  801cc0:	e8 6e fc ff ff       	call   801933 <syscall>
  801cc5:	83 c4 18             	add    $0x18,%esp
}
  801cc8:	90                   	nop
  801cc9:	c9                   	leave  
  801cca:	c3                   	ret    

00801ccb <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ccb:	55                   	push   %ebp
  801ccc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801cce:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	50                   	push   %eax
  801cda:	6a 22                	push   $0x22
  801cdc:	e8 52 fc ff ff       	call   801933 <syscall>
  801ce1:	83 c4 18             	add    $0x18,%esp
}
  801ce4:	c9                   	leave  
  801ce5:	c3                   	ret    

00801ce6 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ce6:	55                   	push   %ebp
  801ce7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 02                	push   $0x2
  801cf5:	e8 39 fc ff ff       	call   801933 <syscall>
  801cfa:	83 c4 18             	add    $0x18,%esp
}
  801cfd:	c9                   	leave  
  801cfe:	c3                   	ret    

00801cff <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801cff:	55                   	push   %ebp
  801d00:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 03                	push   $0x3
  801d0e:	e8 20 fc ff ff       	call   801933 <syscall>
  801d13:	83 c4 18             	add    $0x18,%esp
}
  801d16:	c9                   	leave  
  801d17:	c3                   	ret    

00801d18 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d18:	55                   	push   %ebp
  801d19:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 04                	push   $0x4
  801d27:	e8 07 fc ff ff       	call   801933 <syscall>
  801d2c:	83 c4 18             	add    $0x18,%esp
}
  801d2f:	c9                   	leave  
  801d30:	c3                   	ret    

00801d31 <sys_exit_env>:


void sys_exit_env(void)
{
  801d31:	55                   	push   %ebp
  801d32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 23                	push   $0x23
  801d40:	e8 ee fb ff ff       	call   801933 <syscall>
  801d45:	83 c4 18             	add    $0x18,%esp
}
  801d48:	90                   	nop
  801d49:	c9                   	leave  
  801d4a:	c3                   	ret    

00801d4b <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d4b:	55                   	push   %ebp
  801d4c:	89 e5                	mov    %esp,%ebp
  801d4e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d51:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d54:	8d 50 04             	lea    0x4(%eax),%edx
  801d57:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	52                   	push   %edx
  801d61:	50                   	push   %eax
  801d62:	6a 24                	push   $0x24
  801d64:	e8 ca fb ff ff       	call   801933 <syscall>
  801d69:	83 c4 18             	add    $0x18,%esp
	return result;
  801d6c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d6f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d72:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d75:	89 01                	mov    %eax,(%ecx)
  801d77:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7d:	c9                   	leave  
  801d7e:	c2 04 00             	ret    $0x4

00801d81 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d81:	55                   	push   %ebp
  801d82:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	ff 75 10             	pushl  0x10(%ebp)
  801d8b:	ff 75 0c             	pushl  0xc(%ebp)
  801d8e:	ff 75 08             	pushl  0x8(%ebp)
  801d91:	6a 12                	push   $0x12
  801d93:	e8 9b fb ff ff       	call   801933 <syscall>
  801d98:	83 c4 18             	add    $0x18,%esp
	return ;
  801d9b:	90                   	nop
}
  801d9c:	c9                   	leave  
  801d9d:	c3                   	ret    

00801d9e <sys_rcr2>:
uint32 sys_rcr2()
{
  801d9e:	55                   	push   %ebp
  801d9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801da1:	6a 00                	push   $0x0
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	6a 25                	push   $0x25
  801dad:	e8 81 fb ff ff       	call   801933 <syscall>
  801db2:	83 c4 18             	add    $0x18,%esp
}
  801db5:	c9                   	leave  
  801db6:	c3                   	ret    

00801db7 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801db7:	55                   	push   %ebp
  801db8:	89 e5                	mov    %esp,%ebp
  801dba:	83 ec 04             	sub    $0x4,%esp
  801dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801dc3:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	50                   	push   %eax
  801dd0:	6a 26                	push   $0x26
  801dd2:	e8 5c fb ff ff       	call   801933 <syscall>
  801dd7:	83 c4 18             	add    $0x18,%esp
	return ;
  801dda:	90                   	nop
}
  801ddb:	c9                   	leave  
  801ddc:	c3                   	ret    

00801ddd <rsttst>:
void rsttst()
{
  801ddd:	55                   	push   %ebp
  801dde:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	6a 00                	push   $0x0
  801de8:	6a 00                	push   $0x0
  801dea:	6a 28                	push   $0x28
  801dec:	e8 42 fb ff ff       	call   801933 <syscall>
  801df1:	83 c4 18             	add    $0x18,%esp
	return ;
  801df4:	90                   	nop
}
  801df5:	c9                   	leave  
  801df6:	c3                   	ret    

00801df7 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801df7:	55                   	push   %ebp
  801df8:	89 e5                	mov    %esp,%ebp
  801dfa:	83 ec 04             	sub    $0x4,%esp
  801dfd:	8b 45 14             	mov    0x14(%ebp),%eax
  801e00:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e03:	8b 55 18             	mov    0x18(%ebp),%edx
  801e06:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e0a:	52                   	push   %edx
  801e0b:	50                   	push   %eax
  801e0c:	ff 75 10             	pushl  0x10(%ebp)
  801e0f:	ff 75 0c             	pushl  0xc(%ebp)
  801e12:	ff 75 08             	pushl  0x8(%ebp)
  801e15:	6a 27                	push   $0x27
  801e17:	e8 17 fb ff ff       	call   801933 <syscall>
  801e1c:	83 c4 18             	add    $0x18,%esp
	return ;
  801e1f:	90                   	nop
}
  801e20:	c9                   	leave  
  801e21:	c3                   	ret    

00801e22 <chktst>:
void chktst(uint32 n)
{
  801e22:	55                   	push   %ebp
  801e23:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	ff 75 08             	pushl  0x8(%ebp)
  801e30:	6a 29                	push   $0x29
  801e32:	e8 fc fa ff ff       	call   801933 <syscall>
  801e37:	83 c4 18             	add    $0x18,%esp
	return ;
  801e3a:	90                   	nop
}
  801e3b:	c9                   	leave  
  801e3c:	c3                   	ret    

00801e3d <inctst>:

void inctst()
{
  801e3d:	55                   	push   %ebp
  801e3e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	6a 00                	push   $0x0
  801e4a:	6a 2a                	push   $0x2a
  801e4c:	e8 e2 fa ff ff       	call   801933 <syscall>
  801e51:	83 c4 18             	add    $0x18,%esp
	return ;
  801e54:	90                   	nop
}
  801e55:	c9                   	leave  
  801e56:	c3                   	ret    

00801e57 <gettst>:
uint32 gettst()
{
  801e57:	55                   	push   %ebp
  801e58:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e5a:	6a 00                	push   $0x0
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 00                	push   $0x0
  801e62:	6a 00                	push   $0x0
  801e64:	6a 2b                	push   $0x2b
  801e66:	e8 c8 fa ff ff       	call   801933 <syscall>
  801e6b:	83 c4 18             	add    $0x18,%esp
}
  801e6e:	c9                   	leave  
  801e6f:	c3                   	ret    

00801e70 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e70:	55                   	push   %ebp
  801e71:	89 e5                	mov    %esp,%ebp
  801e73:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e76:	6a 00                	push   $0x0
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 00                	push   $0x0
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 2c                	push   $0x2c
  801e82:	e8 ac fa ff ff       	call   801933 <syscall>
  801e87:	83 c4 18             	add    $0x18,%esp
  801e8a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e8d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e91:	75 07                	jne    801e9a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e93:	b8 01 00 00 00       	mov    $0x1,%eax
  801e98:	eb 05                	jmp    801e9f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e9a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e9f:	c9                   	leave  
  801ea0:	c3                   	ret    

00801ea1 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ea1:	55                   	push   %ebp
  801ea2:	89 e5                	mov    %esp,%ebp
  801ea4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ea7:	6a 00                	push   $0x0
  801ea9:	6a 00                	push   $0x0
  801eab:	6a 00                	push   $0x0
  801ead:	6a 00                	push   $0x0
  801eaf:	6a 00                	push   $0x0
  801eb1:	6a 2c                	push   $0x2c
  801eb3:	e8 7b fa ff ff       	call   801933 <syscall>
  801eb8:	83 c4 18             	add    $0x18,%esp
  801ebb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ebe:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ec2:	75 07                	jne    801ecb <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ec4:	b8 01 00 00 00       	mov    $0x1,%eax
  801ec9:	eb 05                	jmp    801ed0 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ecb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ed0:	c9                   	leave  
  801ed1:	c3                   	ret    

00801ed2 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ed2:	55                   	push   %ebp
  801ed3:	89 e5                	mov    %esp,%ebp
  801ed5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ed8:	6a 00                	push   $0x0
  801eda:	6a 00                	push   $0x0
  801edc:	6a 00                	push   $0x0
  801ede:	6a 00                	push   $0x0
  801ee0:	6a 00                	push   $0x0
  801ee2:	6a 2c                	push   $0x2c
  801ee4:	e8 4a fa ff ff       	call   801933 <syscall>
  801ee9:	83 c4 18             	add    $0x18,%esp
  801eec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801eef:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ef3:	75 07                	jne    801efc <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ef5:	b8 01 00 00 00       	mov    $0x1,%eax
  801efa:	eb 05                	jmp    801f01 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801efc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f01:	c9                   	leave  
  801f02:	c3                   	ret    

00801f03 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f03:	55                   	push   %ebp
  801f04:	89 e5                	mov    %esp,%ebp
  801f06:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f09:	6a 00                	push   $0x0
  801f0b:	6a 00                	push   $0x0
  801f0d:	6a 00                	push   $0x0
  801f0f:	6a 00                	push   $0x0
  801f11:	6a 00                	push   $0x0
  801f13:	6a 2c                	push   $0x2c
  801f15:	e8 19 fa ff ff       	call   801933 <syscall>
  801f1a:	83 c4 18             	add    $0x18,%esp
  801f1d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f20:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f24:	75 07                	jne    801f2d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f26:	b8 01 00 00 00       	mov    $0x1,%eax
  801f2b:	eb 05                	jmp    801f32 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f32:	c9                   	leave  
  801f33:	c3                   	ret    

00801f34 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f34:	55                   	push   %ebp
  801f35:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f37:	6a 00                	push   $0x0
  801f39:	6a 00                	push   $0x0
  801f3b:	6a 00                	push   $0x0
  801f3d:	6a 00                	push   $0x0
  801f3f:	ff 75 08             	pushl  0x8(%ebp)
  801f42:	6a 2d                	push   $0x2d
  801f44:	e8 ea f9 ff ff       	call   801933 <syscall>
  801f49:	83 c4 18             	add    $0x18,%esp
	return ;
  801f4c:	90                   	nop
}
  801f4d:	c9                   	leave  
  801f4e:	c3                   	ret    

00801f4f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f4f:	55                   	push   %ebp
  801f50:	89 e5                	mov    %esp,%ebp
  801f52:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f53:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f56:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f59:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5f:	6a 00                	push   $0x0
  801f61:	53                   	push   %ebx
  801f62:	51                   	push   %ecx
  801f63:	52                   	push   %edx
  801f64:	50                   	push   %eax
  801f65:	6a 2e                	push   $0x2e
  801f67:	e8 c7 f9 ff ff       	call   801933 <syscall>
  801f6c:	83 c4 18             	add    $0x18,%esp
}
  801f6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f72:	c9                   	leave  
  801f73:	c3                   	ret    

00801f74 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f74:	55                   	push   %ebp
  801f75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f77:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7d:	6a 00                	push   $0x0
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 00                	push   $0x0
  801f83:	52                   	push   %edx
  801f84:	50                   	push   %eax
  801f85:	6a 2f                	push   $0x2f
  801f87:	e8 a7 f9 ff ff       	call   801933 <syscall>
  801f8c:	83 c4 18             	add    $0x18,%esp
}
  801f8f:	c9                   	leave  
  801f90:	c3                   	ret    

00801f91 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f91:	55                   	push   %ebp
  801f92:	89 e5                	mov    %esp,%ebp
  801f94:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f97:	83 ec 0c             	sub    $0xc,%esp
  801f9a:	68 3c 3b 80 00       	push   $0x803b3c
  801f9f:	e8 df e6 ff ff       	call   800683 <cprintf>
  801fa4:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801fa7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801fae:	83 ec 0c             	sub    $0xc,%esp
  801fb1:	68 68 3b 80 00       	push   $0x803b68
  801fb6:	e8 c8 e6 ff ff       	call   800683 <cprintf>
  801fbb:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801fbe:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fc2:	a1 38 41 80 00       	mov    0x804138,%eax
  801fc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fca:	eb 56                	jmp    802022 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801fcc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fd0:	74 1c                	je     801fee <print_mem_block_lists+0x5d>
  801fd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd5:	8b 50 08             	mov    0x8(%eax),%edx
  801fd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fdb:	8b 48 08             	mov    0x8(%eax),%ecx
  801fde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fe1:	8b 40 0c             	mov    0xc(%eax),%eax
  801fe4:	01 c8                	add    %ecx,%eax
  801fe6:	39 c2                	cmp    %eax,%edx
  801fe8:	73 04                	jae    801fee <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801fea:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff1:	8b 50 08             	mov    0x8(%eax),%edx
  801ff4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff7:	8b 40 0c             	mov    0xc(%eax),%eax
  801ffa:	01 c2                	add    %eax,%edx
  801ffc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fff:	8b 40 08             	mov    0x8(%eax),%eax
  802002:	83 ec 04             	sub    $0x4,%esp
  802005:	52                   	push   %edx
  802006:	50                   	push   %eax
  802007:	68 7d 3b 80 00       	push   $0x803b7d
  80200c:	e8 72 e6 ff ff       	call   800683 <cprintf>
  802011:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802014:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802017:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80201a:	a1 40 41 80 00       	mov    0x804140,%eax
  80201f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802022:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802026:	74 07                	je     80202f <print_mem_block_lists+0x9e>
  802028:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202b:	8b 00                	mov    (%eax),%eax
  80202d:	eb 05                	jmp    802034 <print_mem_block_lists+0xa3>
  80202f:	b8 00 00 00 00       	mov    $0x0,%eax
  802034:	a3 40 41 80 00       	mov    %eax,0x804140
  802039:	a1 40 41 80 00       	mov    0x804140,%eax
  80203e:	85 c0                	test   %eax,%eax
  802040:	75 8a                	jne    801fcc <print_mem_block_lists+0x3b>
  802042:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802046:	75 84                	jne    801fcc <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802048:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80204c:	75 10                	jne    80205e <print_mem_block_lists+0xcd>
  80204e:	83 ec 0c             	sub    $0xc,%esp
  802051:	68 8c 3b 80 00       	push   $0x803b8c
  802056:	e8 28 e6 ff ff       	call   800683 <cprintf>
  80205b:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80205e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802065:	83 ec 0c             	sub    $0xc,%esp
  802068:	68 b0 3b 80 00       	push   $0x803bb0
  80206d:	e8 11 e6 ff ff       	call   800683 <cprintf>
  802072:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802075:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802079:	a1 40 40 80 00       	mov    0x804040,%eax
  80207e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802081:	eb 56                	jmp    8020d9 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802083:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802087:	74 1c                	je     8020a5 <print_mem_block_lists+0x114>
  802089:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208c:	8b 50 08             	mov    0x8(%eax),%edx
  80208f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802092:	8b 48 08             	mov    0x8(%eax),%ecx
  802095:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802098:	8b 40 0c             	mov    0xc(%eax),%eax
  80209b:	01 c8                	add    %ecx,%eax
  80209d:	39 c2                	cmp    %eax,%edx
  80209f:	73 04                	jae    8020a5 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8020a1:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a8:	8b 50 08             	mov    0x8(%eax),%edx
  8020ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8020b1:	01 c2                	add    %eax,%edx
  8020b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b6:	8b 40 08             	mov    0x8(%eax),%eax
  8020b9:	83 ec 04             	sub    $0x4,%esp
  8020bc:	52                   	push   %edx
  8020bd:	50                   	push   %eax
  8020be:	68 7d 3b 80 00       	push   $0x803b7d
  8020c3:	e8 bb e5 ff ff       	call   800683 <cprintf>
  8020c8:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8020cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8020d1:	a1 48 40 80 00       	mov    0x804048,%eax
  8020d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020dd:	74 07                	je     8020e6 <print_mem_block_lists+0x155>
  8020df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e2:	8b 00                	mov    (%eax),%eax
  8020e4:	eb 05                	jmp    8020eb <print_mem_block_lists+0x15a>
  8020e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8020eb:	a3 48 40 80 00       	mov    %eax,0x804048
  8020f0:	a1 48 40 80 00       	mov    0x804048,%eax
  8020f5:	85 c0                	test   %eax,%eax
  8020f7:	75 8a                	jne    802083 <print_mem_block_lists+0xf2>
  8020f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020fd:	75 84                	jne    802083 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8020ff:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802103:	75 10                	jne    802115 <print_mem_block_lists+0x184>
  802105:	83 ec 0c             	sub    $0xc,%esp
  802108:	68 c8 3b 80 00       	push   $0x803bc8
  80210d:	e8 71 e5 ff ff       	call   800683 <cprintf>
  802112:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802115:	83 ec 0c             	sub    $0xc,%esp
  802118:	68 3c 3b 80 00       	push   $0x803b3c
  80211d:	e8 61 e5 ff ff       	call   800683 <cprintf>
  802122:	83 c4 10             	add    $0x10,%esp

}
  802125:	90                   	nop
  802126:	c9                   	leave  
  802127:	c3                   	ret    

00802128 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802128:	55                   	push   %ebp
  802129:	89 e5                	mov    %esp,%ebp
  80212b:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  80212e:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802135:	00 00 00 
  802138:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  80213f:	00 00 00 
  802142:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802149:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  80214c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802153:	e9 9e 00 00 00       	jmp    8021f6 <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802158:	a1 50 40 80 00       	mov    0x804050,%eax
  80215d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802160:	c1 e2 04             	shl    $0x4,%edx
  802163:	01 d0                	add    %edx,%eax
  802165:	85 c0                	test   %eax,%eax
  802167:	75 14                	jne    80217d <initialize_MemBlocksList+0x55>
  802169:	83 ec 04             	sub    $0x4,%esp
  80216c:	68 f0 3b 80 00       	push   $0x803bf0
  802171:	6a 42                	push   $0x42
  802173:	68 13 3c 80 00       	push   $0x803c13
  802178:	e8 ee 0f 00 00       	call   80316b <_panic>
  80217d:	a1 50 40 80 00       	mov    0x804050,%eax
  802182:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802185:	c1 e2 04             	shl    $0x4,%edx
  802188:	01 d0                	add    %edx,%eax
  80218a:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802190:	89 10                	mov    %edx,(%eax)
  802192:	8b 00                	mov    (%eax),%eax
  802194:	85 c0                	test   %eax,%eax
  802196:	74 18                	je     8021b0 <initialize_MemBlocksList+0x88>
  802198:	a1 48 41 80 00       	mov    0x804148,%eax
  80219d:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8021a3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8021a6:	c1 e1 04             	shl    $0x4,%ecx
  8021a9:	01 ca                	add    %ecx,%edx
  8021ab:	89 50 04             	mov    %edx,0x4(%eax)
  8021ae:	eb 12                	jmp    8021c2 <initialize_MemBlocksList+0x9a>
  8021b0:	a1 50 40 80 00       	mov    0x804050,%eax
  8021b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021b8:	c1 e2 04             	shl    $0x4,%edx
  8021bb:	01 d0                	add    %edx,%eax
  8021bd:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8021c2:	a1 50 40 80 00       	mov    0x804050,%eax
  8021c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021ca:	c1 e2 04             	shl    $0x4,%edx
  8021cd:	01 d0                	add    %edx,%eax
  8021cf:	a3 48 41 80 00       	mov    %eax,0x804148
  8021d4:	a1 50 40 80 00       	mov    0x804050,%eax
  8021d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021dc:	c1 e2 04             	shl    $0x4,%edx
  8021df:	01 d0                	add    %edx,%eax
  8021e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021e8:	a1 54 41 80 00       	mov    0x804154,%eax
  8021ed:	40                   	inc    %eax
  8021ee:	a3 54 41 80 00       	mov    %eax,0x804154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  8021f3:	ff 45 f4             	incl   -0xc(%ebp)
  8021f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021fc:	0f 82 56 ff ff ff    	jb     802158 <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  802202:	90                   	nop
  802203:	c9                   	leave  
  802204:	c3                   	ret    

00802205 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802205:	55                   	push   %ebp
  802206:	89 e5                	mov    %esp,%ebp
  802208:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  80220b:	8b 45 08             	mov    0x8(%ebp),%eax
  80220e:	8b 00                	mov    (%eax),%eax
  802210:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802213:	eb 19                	jmp    80222e <find_block+0x29>
	{
		if(blk->sva==va)
  802215:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802218:	8b 40 08             	mov    0x8(%eax),%eax
  80221b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80221e:	75 05                	jne    802225 <find_block+0x20>
			return (blk);
  802220:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802223:	eb 36                	jmp    80225b <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  802225:	8b 45 08             	mov    0x8(%ebp),%eax
  802228:	8b 40 08             	mov    0x8(%eax),%eax
  80222b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80222e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802232:	74 07                	je     80223b <find_block+0x36>
  802234:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802237:	8b 00                	mov    (%eax),%eax
  802239:	eb 05                	jmp    802240 <find_block+0x3b>
  80223b:	b8 00 00 00 00       	mov    $0x0,%eax
  802240:	8b 55 08             	mov    0x8(%ebp),%edx
  802243:	89 42 08             	mov    %eax,0x8(%edx)
  802246:	8b 45 08             	mov    0x8(%ebp),%eax
  802249:	8b 40 08             	mov    0x8(%eax),%eax
  80224c:	85 c0                	test   %eax,%eax
  80224e:	75 c5                	jne    802215 <find_block+0x10>
  802250:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802254:	75 bf                	jne    802215 <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  802256:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80225b:	c9                   	leave  
  80225c:	c3                   	ret    

0080225d <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80225d:	55                   	push   %ebp
  80225e:	89 e5                	mov    %esp,%ebp
  802260:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  802263:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802268:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80226b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  802272:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802275:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802278:	75 65                	jne    8022df <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80227a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80227e:	75 14                	jne    802294 <insert_sorted_allocList+0x37>
  802280:	83 ec 04             	sub    $0x4,%esp
  802283:	68 f0 3b 80 00       	push   $0x803bf0
  802288:	6a 5c                	push   $0x5c
  80228a:	68 13 3c 80 00       	push   $0x803c13
  80228f:	e8 d7 0e 00 00       	call   80316b <_panic>
  802294:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80229a:	8b 45 08             	mov    0x8(%ebp),%eax
  80229d:	89 10                	mov    %edx,(%eax)
  80229f:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a2:	8b 00                	mov    (%eax),%eax
  8022a4:	85 c0                	test   %eax,%eax
  8022a6:	74 0d                	je     8022b5 <insert_sorted_allocList+0x58>
  8022a8:	a1 40 40 80 00       	mov    0x804040,%eax
  8022ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8022b0:	89 50 04             	mov    %edx,0x4(%eax)
  8022b3:	eb 08                	jmp    8022bd <insert_sorted_allocList+0x60>
  8022b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b8:	a3 44 40 80 00       	mov    %eax,0x804044
  8022bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c0:	a3 40 40 80 00       	mov    %eax,0x804040
  8022c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022cf:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022d4:	40                   	inc    %eax
  8022d5:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  8022da:	e9 7b 01 00 00       	jmp    80245a <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  8022df:	a1 44 40 80 00       	mov    0x804044,%eax
  8022e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  8022e7:	a1 40 40 80 00       	mov    0x804040,%eax
  8022ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  8022ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f2:	8b 50 08             	mov    0x8(%eax),%edx
  8022f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022f8:	8b 40 08             	mov    0x8(%eax),%eax
  8022fb:	39 c2                	cmp    %eax,%edx
  8022fd:	76 65                	jbe    802364 <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  8022ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802303:	75 14                	jne    802319 <insert_sorted_allocList+0xbc>
  802305:	83 ec 04             	sub    $0x4,%esp
  802308:	68 2c 3c 80 00       	push   $0x803c2c
  80230d:	6a 64                	push   $0x64
  80230f:	68 13 3c 80 00       	push   $0x803c13
  802314:	e8 52 0e 00 00       	call   80316b <_panic>
  802319:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80231f:	8b 45 08             	mov    0x8(%ebp),%eax
  802322:	89 50 04             	mov    %edx,0x4(%eax)
  802325:	8b 45 08             	mov    0x8(%ebp),%eax
  802328:	8b 40 04             	mov    0x4(%eax),%eax
  80232b:	85 c0                	test   %eax,%eax
  80232d:	74 0c                	je     80233b <insert_sorted_allocList+0xde>
  80232f:	a1 44 40 80 00       	mov    0x804044,%eax
  802334:	8b 55 08             	mov    0x8(%ebp),%edx
  802337:	89 10                	mov    %edx,(%eax)
  802339:	eb 08                	jmp    802343 <insert_sorted_allocList+0xe6>
  80233b:	8b 45 08             	mov    0x8(%ebp),%eax
  80233e:	a3 40 40 80 00       	mov    %eax,0x804040
  802343:	8b 45 08             	mov    0x8(%ebp),%eax
  802346:	a3 44 40 80 00       	mov    %eax,0x804044
  80234b:	8b 45 08             	mov    0x8(%ebp),%eax
  80234e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802354:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802359:	40                   	inc    %eax
  80235a:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  80235f:	e9 f6 00 00 00       	jmp    80245a <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  802364:	8b 45 08             	mov    0x8(%ebp),%eax
  802367:	8b 50 08             	mov    0x8(%eax),%edx
  80236a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80236d:	8b 40 08             	mov    0x8(%eax),%eax
  802370:	39 c2                	cmp    %eax,%edx
  802372:	73 65                	jae    8023d9 <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802374:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802378:	75 14                	jne    80238e <insert_sorted_allocList+0x131>
  80237a:	83 ec 04             	sub    $0x4,%esp
  80237d:	68 f0 3b 80 00       	push   $0x803bf0
  802382:	6a 68                	push   $0x68
  802384:	68 13 3c 80 00       	push   $0x803c13
  802389:	e8 dd 0d 00 00       	call   80316b <_panic>
  80238e:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802394:	8b 45 08             	mov    0x8(%ebp),%eax
  802397:	89 10                	mov    %edx,(%eax)
  802399:	8b 45 08             	mov    0x8(%ebp),%eax
  80239c:	8b 00                	mov    (%eax),%eax
  80239e:	85 c0                	test   %eax,%eax
  8023a0:	74 0d                	je     8023af <insert_sorted_allocList+0x152>
  8023a2:	a1 40 40 80 00       	mov    0x804040,%eax
  8023a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8023aa:	89 50 04             	mov    %edx,0x4(%eax)
  8023ad:	eb 08                	jmp    8023b7 <insert_sorted_allocList+0x15a>
  8023af:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b2:	a3 44 40 80 00       	mov    %eax,0x804044
  8023b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ba:	a3 40 40 80 00       	mov    %eax,0x804040
  8023bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023c9:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023ce:	40                   	inc    %eax
  8023cf:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  8023d4:	e9 81 00 00 00       	jmp    80245a <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  8023d9:	a1 40 40 80 00       	mov    0x804040,%eax
  8023de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023e1:	eb 51                	jmp    802434 <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  8023e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e6:	8b 50 08             	mov    0x8(%eax),%edx
  8023e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ec:	8b 40 08             	mov    0x8(%eax),%eax
  8023ef:	39 c2                	cmp    %eax,%edx
  8023f1:	73 39                	jae    80242c <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  8023f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f6:	8b 40 04             	mov    0x4(%eax),%eax
  8023f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  8023fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023ff:	8b 55 08             	mov    0x8(%ebp),%edx
  802402:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  802404:	8b 45 08             	mov    0x8(%ebp),%eax
  802407:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80240a:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  80240d:	8b 45 08             	mov    0x8(%ebp),%eax
  802410:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802413:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  802415:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802418:	8b 55 08             	mov    0x8(%ebp),%edx
  80241b:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  80241e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802423:	40                   	inc    %eax
  802424:	a3 4c 40 80 00       	mov    %eax,0x80404c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  802429:	90                   	nop
				}
			}
		 }

	}
}
  80242a:	eb 2e                	jmp    80245a <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  80242c:	a1 48 40 80 00       	mov    0x804048,%eax
  802431:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802434:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802438:	74 07                	je     802441 <insert_sorted_allocList+0x1e4>
  80243a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243d:	8b 00                	mov    (%eax),%eax
  80243f:	eb 05                	jmp    802446 <insert_sorted_allocList+0x1e9>
  802441:	b8 00 00 00 00       	mov    $0x0,%eax
  802446:	a3 48 40 80 00       	mov    %eax,0x804048
  80244b:	a1 48 40 80 00       	mov    0x804048,%eax
  802450:	85 c0                	test   %eax,%eax
  802452:	75 8f                	jne    8023e3 <insert_sorted_allocList+0x186>
  802454:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802458:	75 89                	jne    8023e3 <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  80245a:	90                   	nop
  80245b:	c9                   	leave  
  80245c:	c3                   	ret    

0080245d <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80245d:	55                   	push   %ebp
  80245e:	89 e5                	mov    %esp,%ebp
  802460:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802463:	a1 38 41 80 00       	mov    0x804138,%eax
  802468:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80246b:	e9 76 01 00 00       	jmp    8025e6 <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  802470:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802473:	8b 40 0c             	mov    0xc(%eax),%eax
  802476:	3b 45 08             	cmp    0x8(%ebp),%eax
  802479:	0f 85 8a 00 00 00    	jne    802509 <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  80247f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802483:	75 17                	jne    80249c <alloc_block_FF+0x3f>
  802485:	83 ec 04             	sub    $0x4,%esp
  802488:	68 4f 3c 80 00       	push   $0x803c4f
  80248d:	68 8a 00 00 00       	push   $0x8a
  802492:	68 13 3c 80 00       	push   $0x803c13
  802497:	e8 cf 0c 00 00       	call   80316b <_panic>
  80249c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249f:	8b 00                	mov    (%eax),%eax
  8024a1:	85 c0                	test   %eax,%eax
  8024a3:	74 10                	je     8024b5 <alloc_block_FF+0x58>
  8024a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a8:	8b 00                	mov    (%eax),%eax
  8024aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024ad:	8b 52 04             	mov    0x4(%edx),%edx
  8024b0:	89 50 04             	mov    %edx,0x4(%eax)
  8024b3:	eb 0b                	jmp    8024c0 <alloc_block_FF+0x63>
  8024b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b8:	8b 40 04             	mov    0x4(%eax),%eax
  8024bb:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8024c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c3:	8b 40 04             	mov    0x4(%eax),%eax
  8024c6:	85 c0                	test   %eax,%eax
  8024c8:	74 0f                	je     8024d9 <alloc_block_FF+0x7c>
  8024ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cd:	8b 40 04             	mov    0x4(%eax),%eax
  8024d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024d3:	8b 12                	mov    (%edx),%edx
  8024d5:	89 10                	mov    %edx,(%eax)
  8024d7:	eb 0a                	jmp    8024e3 <alloc_block_FF+0x86>
  8024d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024dc:	8b 00                	mov    (%eax),%eax
  8024de:	a3 38 41 80 00       	mov    %eax,0x804138
  8024e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024f6:	a1 44 41 80 00       	mov    0x804144,%eax
  8024fb:	48                   	dec    %eax
  8024fc:	a3 44 41 80 00       	mov    %eax,0x804144
			return element;
  802501:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802504:	e9 10 01 00 00       	jmp    802619 <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  802509:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250c:	8b 40 0c             	mov    0xc(%eax),%eax
  80250f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802512:	0f 86 c6 00 00 00    	jbe    8025de <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802518:	a1 48 41 80 00       	mov    0x804148,%eax
  80251d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802520:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802524:	75 17                	jne    80253d <alloc_block_FF+0xe0>
  802526:	83 ec 04             	sub    $0x4,%esp
  802529:	68 4f 3c 80 00       	push   $0x803c4f
  80252e:	68 90 00 00 00       	push   $0x90
  802533:	68 13 3c 80 00       	push   $0x803c13
  802538:	e8 2e 0c 00 00       	call   80316b <_panic>
  80253d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802540:	8b 00                	mov    (%eax),%eax
  802542:	85 c0                	test   %eax,%eax
  802544:	74 10                	je     802556 <alloc_block_FF+0xf9>
  802546:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802549:	8b 00                	mov    (%eax),%eax
  80254b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80254e:	8b 52 04             	mov    0x4(%edx),%edx
  802551:	89 50 04             	mov    %edx,0x4(%eax)
  802554:	eb 0b                	jmp    802561 <alloc_block_FF+0x104>
  802556:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802559:	8b 40 04             	mov    0x4(%eax),%eax
  80255c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802561:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802564:	8b 40 04             	mov    0x4(%eax),%eax
  802567:	85 c0                	test   %eax,%eax
  802569:	74 0f                	je     80257a <alloc_block_FF+0x11d>
  80256b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80256e:	8b 40 04             	mov    0x4(%eax),%eax
  802571:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802574:	8b 12                	mov    (%edx),%edx
  802576:	89 10                	mov    %edx,(%eax)
  802578:	eb 0a                	jmp    802584 <alloc_block_FF+0x127>
  80257a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80257d:	8b 00                	mov    (%eax),%eax
  80257f:	a3 48 41 80 00       	mov    %eax,0x804148
  802584:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802587:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80258d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802590:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802597:	a1 54 41 80 00       	mov    0x804154,%eax
  80259c:	48                   	dec    %eax
  80259d:	a3 54 41 80 00       	mov    %eax,0x804154
			 element1->size =size;
  8025a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8025a8:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  8025ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ae:	8b 50 08             	mov    0x8(%eax),%edx
  8025b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b4:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  8025b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ba:	8b 50 08             	mov    0x8(%eax),%edx
  8025bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c0:	01 c2                	add    %eax,%edx
  8025c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c5:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  8025c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ce:	2b 45 08             	sub    0x8(%ebp),%eax
  8025d1:	89 c2                	mov    %eax,%edx
  8025d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d6:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  8025d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025dc:	eb 3b                	jmp    802619 <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  8025de:	a1 40 41 80 00       	mov    0x804140,%eax
  8025e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ea:	74 07                	je     8025f3 <alloc_block_FF+0x196>
  8025ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ef:	8b 00                	mov    (%eax),%eax
  8025f1:	eb 05                	jmp    8025f8 <alloc_block_FF+0x19b>
  8025f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8025f8:	a3 40 41 80 00       	mov    %eax,0x804140
  8025fd:	a1 40 41 80 00       	mov    0x804140,%eax
  802602:	85 c0                	test   %eax,%eax
  802604:	0f 85 66 fe ff ff    	jne    802470 <alloc_block_FF+0x13>
  80260a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80260e:	0f 85 5c fe ff ff    	jne    802470 <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  802614:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802619:	c9                   	leave  
  80261a:	c3                   	ret    

0080261b <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80261b:	55                   	push   %ebp
  80261c:	89 e5                	mov    %esp,%ebp
  80261e:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  802621:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  802628:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  80262f:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802636:	a1 38 41 80 00       	mov    0x804138,%eax
  80263b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80263e:	e9 cf 00 00 00       	jmp    802712 <alloc_block_BF+0xf7>
		{
			c++;
  802643:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  802646:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802649:	8b 40 0c             	mov    0xc(%eax),%eax
  80264c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80264f:	0f 85 8a 00 00 00    	jne    8026df <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  802655:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802659:	75 17                	jne    802672 <alloc_block_BF+0x57>
  80265b:	83 ec 04             	sub    $0x4,%esp
  80265e:	68 4f 3c 80 00       	push   $0x803c4f
  802663:	68 a8 00 00 00       	push   $0xa8
  802668:	68 13 3c 80 00       	push   $0x803c13
  80266d:	e8 f9 0a 00 00       	call   80316b <_panic>
  802672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802675:	8b 00                	mov    (%eax),%eax
  802677:	85 c0                	test   %eax,%eax
  802679:	74 10                	je     80268b <alloc_block_BF+0x70>
  80267b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267e:	8b 00                	mov    (%eax),%eax
  802680:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802683:	8b 52 04             	mov    0x4(%edx),%edx
  802686:	89 50 04             	mov    %edx,0x4(%eax)
  802689:	eb 0b                	jmp    802696 <alloc_block_BF+0x7b>
  80268b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268e:	8b 40 04             	mov    0x4(%eax),%eax
  802691:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802696:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802699:	8b 40 04             	mov    0x4(%eax),%eax
  80269c:	85 c0                	test   %eax,%eax
  80269e:	74 0f                	je     8026af <alloc_block_BF+0x94>
  8026a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a3:	8b 40 04             	mov    0x4(%eax),%eax
  8026a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026a9:	8b 12                	mov    (%edx),%edx
  8026ab:	89 10                	mov    %edx,(%eax)
  8026ad:	eb 0a                	jmp    8026b9 <alloc_block_BF+0x9e>
  8026af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b2:	8b 00                	mov    (%eax),%eax
  8026b4:	a3 38 41 80 00       	mov    %eax,0x804138
  8026b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026cc:	a1 44 41 80 00       	mov    0x804144,%eax
  8026d1:	48                   	dec    %eax
  8026d2:	a3 44 41 80 00       	mov    %eax,0x804144
				return block;
  8026d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026da:	e9 85 01 00 00       	jmp    802864 <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  8026df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8026e5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026e8:	76 20                	jbe    80270a <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  8026ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8026f0:	2b 45 08             	sub    0x8(%ebp),%eax
  8026f3:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  8026f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8026f9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8026fc:	73 0c                	jae    80270a <alloc_block_BF+0xef>
				{
					ma=tempi;
  8026fe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802701:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  802704:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802707:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  80270a:	a1 40 41 80 00       	mov    0x804140,%eax
  80270f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802712:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802716:	74 07                	je     80271f <alloc_block_BF+0x104>
  802718:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271b:	8b 00                	mov    (%eax),%eax
  80271d:	eb 05                	jmp    802724 <alloc_block_BF+0x109>
  80271f:	b8 00 00 00 00       	mov    $0x0,%eax
  802724:	a3 40 41 80 00       	mov    %eax,0x804140
  802729:	a1 40 41 80 00       	mov    0x804140,%eax
  80272e:	85 c0                	test   %eax,%eax
  802730:	0f 85 0d ff ff ff    	jne    802643 <alloc_block_BF+0x28>
  802736:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80273a:	0f 85 03 ff ff ff    	jne    802643 <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  802740:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802747:	a1 38 41 80 00       	mov    0x804138,%eax
  80274c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80274f:	e9 dd 00 00 00       	jmp    802831 <alloc_block_BF+0x216>
		{
			if(x==sol)
  802754:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802757:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80275a:	0f 85 c6 00 00 00    	jne    802826 <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802760:	a1 48 41 80 00       	mov    0x804148,%eax
  802765:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802768:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80276c:	75 17                	jne    802785 <alloc_block_BF+0x16a>
  80276e:	83 ec 04             	sub    $0x4,%esp
  802771:	68 4f 3c 80 00       	push   $0x803c4f
  802776:	68 bb 00 00 00       	push   $0xbb
  80277b:	68 13 3c 80 00       	push   $0x803c13
  802780:	e8 e6 09 00 00       	call   80316b <_panic>
  802785:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802788:	8b 00                	mov    (%eax),%eax
  80278a:	85 c0                	test   %eax,%eax
  80278c:	74 10                	je     80279e <alloc_block_BF+0x183>
  80278e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802791:	8b 00                	mov    (%eax),%eax
  802793:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802796:	8b 52 04             	mov    0x4(%edx),%edx
  802799:	89 50 04             	mov    %edx,0x4(%eax)
  80279c:	eb 0b                	jmp    8027a9 <alloc_block_BF+0x18e>
  80279e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027a1:	8b 40 04             	mov    0x4(%eax),%eax
  8027a4:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8027a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027ac:	8b 40 04             	mov    0x4(%eax),%eax
  8027af:	85 c0                	test   %eax,%eax
  8027b1:	74 0f                	je     8027c2 <alloc_block_BF+0x1a7>
  8027b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027b6:	8b 40 04             	mov    0x4(%eax),%eax
  8027b9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8027bc:	8b 12                	mov    (%edx),%edx
  8027be:	89 10                	mov    %edx,(%eax)
  8027c0:	eb 0a                	jmp    8027cc <alloc_block_BF+0x1b1>
  8027c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027c5:	8b 00                	mov    (%eax),%eax
  8027c7:	a3 48 41 80 00       	mov    %eax,0x804148
  8027cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027d8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027df:	a1 54 41 80 00       	mov    0x804154,%eax
  8027e4:	48                   	dec    %eax
  8027e5:	a3 54 41 80 00       	mov    %eax,0x804154
						 element1->size =size;
  8027ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8027f0:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  8027f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f6:	8b 50 08             	mov    0x8(%eax),%edx
  8027f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027fc:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  8027ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802802:	8b 50 08             	mov    0x8(%eax),%edx
  802805:	8b 45 08             	mov    0x8(%ebp),%eax
  802808:	01 c2                	add    %eax,%edx
  80280a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280d:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  802810:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802813:	8b 40 0c             	mov    0xc(%eax),%eax
  802816:	2b 45 08             	sub    0x8(%ebp),%eax
  802819:	89 c2                	mov    %eax,%edx
  80281b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281e:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  802821:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802824:	eb 3e                	jmp    802864 <alloc_block_BF+0x249>
						 break;
			}
			x++;
  802826:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802829:	a1 40 41 80 00       	mov    0x804140,%eax
  80282e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802831:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802835:	74 07                	je     80283e <alloc_block_BF+0x223>
  802837:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283a:	8b 00                	mov    (%eax),%eax
  80283c:	eb 05                	jmp    802843 <alloc_block_BF+0x228>
  80283e:	b8 00 00 00 00       	mov    $0x0,%eax
  802843:	a3 40 41 80 00       	mov    %eax,0x804140
  802848:	a1 40 41 80 00       	mov    0x804140,%eax
  80284d:	85 c0                	test   %eax,%eax
  80284f:	0f 85 ff fe ff ff    	jne    802754 <alloc_block_BF+0x139>
  802855:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802859:	0f 85 f5 fe ff ff    	jne    802754 <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  80285f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802864:	c9                   	leave  
  802865:	c3                   	ret    

00802866 <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802866:	55                   	push   %ebp
  802867:	89 e5                	mov    %esp,%ebp
  802869:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  80286c:	a1 28 40 80 00       	mov    0x804028,%eax
  802871:	85 c0                	test   %eax,%eax
  802873:	75 14                	jne    802889 <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  802875:	a1 38 41 80 00       	mov    0x804138,%eax
  80287a:	a3 5c 41 80 00       	mov    %eax,0x80415c
		hh=1;
  80287f:	c7 05 28 40 80 00 01 	movl   $0x1,0x804028
  802886:	00 00 00 
	}
	uint32 c=1;
  802889:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  802890:	a1 5c 41 80 00       	mov    0x80415c,%eax
  802895:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802898:	e9 b3 01 00 00       	jmp    802a50 <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  80289d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8028a3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028a6:	0f 85 a9 00 00 00    	jne    802955 <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  8028ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028af:	8b 00                	mov    (%eax),%eax
  8028b1:	85 c0                	test   %eax,%eax
  8028b3:	75 0c                	jne    8028c1 <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  8028b5:	a1 38 41 80 00       	mov    0x804138,%eax
  8028ba:	a3 5c 41 80 00       	mov    %eax,0x80415c
  8028bf:	eb 0a                	jmp    8028cb <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  8028c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c4:	8b 00                	mov    (%eax),%eax
  8028c6:	a3 5c 41 80 00       	mov    %eax,0x80415c
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  8028cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028cf:	75 17                	jne    8028e8 <alloc_block_NF+0x82>
  8028d1:	83 ec 04             	sub    $0x4,%esp
  8028d4:	68 4f 3c 80 00       	push   $0x803c4f
  8028d9:	68 e3 00 00 00       	push   $0xe3
  8028de:	68 13 3c 80 00       	push   $0x803c13
  8028e3:	e8 83 08 00 00       	call   80316b <_panic>
  8028e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028eb:	8b 00                	mov    (%eax),%eax
  8028ed:	85 c0                	test   %eax,%eax
  8028ef:	74 10                	je     802901 <alloc_block_NF+0x9b>
  8028f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f4:	8b 00                	mov    (%eax),%eax
  8028f6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028f9:	8b 52 04             	mov    0x4(%edx),%edx
  8028fc:	89 50 04             	mov    %edx,0x4(%eax)
  8028ff:	eb 0b                	jmp    80290c <alloc_block_NF+0xa6>
  802901:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802904:	8b 40 04             	mov    0x4(%eax),%eax
  802907:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80290c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80290f:	8b 40 04             	mov    0x4(%eax),%eax
  802912:	85 c0                	test   %eax,%eax
  802914:	74 0f                	je     802925 <alloc_block_NF+0xbf>
  802916:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802919:	8b 40 04             	mov    0x4(%eax),%eax
  80291c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80291f:	8b 12                	mov    (%edx),%edx
  802921:	89 10                	mov    %edx,(%eax)
  802923:	eb 0a                	jmp    80292f <alloc_block_NF+0xc9>
  802925:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802928:	8b 00                	mov    (%eax),%eax
  80292a:	a3 38 41 80 00       	mov    %eax,0x804138
  80292f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802932:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802938:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802942:	a1 44 41 80 00       	mov    0x804144,%eax
  802947:	48                   	dec    %eax
  802948:	a3 44 41 80 00       	mov    %eax,0x804144
				return element;
  80294d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802950:	e9 0e 01 00 00       	jmp    802a63 <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  802955:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802958:	8b 40 0c             	mov    0xc(%eax),%eax
  80295b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80295e:	0f 86 ce 00 00 00    	jbe    802a32 <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802964:	a1 48 41 80 00       	mov    0x804148,%eax
  802969:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  80296c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802970:	75 17                	jne    802989 <alloc_block_NF+0x123>
  802972:	83 ec 04             	sub    $0x4,%esp
  802975:	68 4f 3c 80 00       	push   $0x803c4f
  80297a:	68 e9 00 00 00       	push   $0xe9
  80297f:	68 13 3c 80 00       	push   $0x803c13
  802984:	e8 e2 07 00 00       	call   80316b <_panic>
  802989:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80298c:	8b 00                	mov    (%eax),%eax
  80298e:	85 c0                	test   %eax,%eax
  802990:	74 10                	je     8029a2 <alloc_block_NF+0x13c>
  802992:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802995:	8b 00                	mov    (%eax),%eax
  802997:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80299a:	8b 52 04             	mov    0x4(%edx),%edx
  80299d:	89 50 04             	mov    %edx,0x4(%eax)
  8029a0:	eb 0b                	jmp    8029ad <alloc_block_NF+0x147>
  8029a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029a5:	8b 40 04             	mov    0x4(%eax),%eax
  8029a8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8029ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029b0:	8b 40 04             	mov    0x4(%eax),%eax
  8029b3:	85 c0                	test   %eax,%eax
  8029b5:	74 0f                	je     8029c6 <alloc_block_NF+0x160>
  8029b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ba:	8b 40 04             	mov    0x4(%eax),%eax
  8029bd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029c0:	8b 12                	mov    (%edx),%edx
  8029c2:	89 10                	mov    %edx,(%eax)
  8029c4:	eb 0a                	jmp    8029d0 <alloc_block_NF+0x16a>
  8029c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c9:	8b 00                	mov    (%eax),%eax
  8029cb:	a3 48 41 80 00       	mov    %eax,0x804148
  8029d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029dc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029e3:	a1 54 41 80 00       	mov    0x804154,%eax
  8029e8:	48                   	dec    %eax
  8029e9:	a3 54 41 80 00       	mov    %eax,0x804154
				 element1->size =size;
  8029ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8029f4:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  8029f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029fa:	8b 50 08             	mov    0x8(%eax),%edx
  8029fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a00:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  802a03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a06:	8b 50 08             	mov    0x8(%eax),%edx
  802a09:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0c:	01 c2                	add    %eax,%edx
  802a0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a11:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  802a14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a17:	8b 40 0c             	mov    0xc(%eax),%eax
  802a1a:	2b 45 08             	sub    0x8(%ebp),%eax
  802a1d:	89 c2                	mov    %eax,%edx
  802a1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a22:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  802a25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a28:	a3 5c 41 80 00       	mov    %eax,0x80415c
				 return element1;
  802a2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a30:	eb 31                	jmp    802a63 <alloc_block_NF+0x1fd>
			 }
		 c++;
  802a32:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  802a35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a38:	8b 00                	mov    (%eax),%eax
  802a3a:	85 c0                	test   %eax,%eax
  802a3c:	75 0a                	jne    802a48 <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  802a3e:	a1 38 41 80 00       	mov    0x804138,%eax
  802a43:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802a46:	eb 08                	jmp    802a50 <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  802a48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a4b:	8b 00                	mov    (%eax),%eax
  802a4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802a50:	a1 44 41 80 00       	mov    0x804144,%eax
  802a55:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802a58:	0f 85 3f fe ff ff    	jne    80289d <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  802a5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a63:	c9                   	leave  
  802a64:	c3                   	ret    

00802a65 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802a65:	55                   	push   %ebp
  802a66:	89 e5                	mov    %esp,%ebp
  802a68:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  802a6b:	a1 44 41 80 00       	mov    0x804144,%eax
  802a70:	85 c0                	test   %eax,%eax
  802a72:	75 68                	jne    802adc <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802a74:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a78:	75 17                	jne    802a91 <insert_sorted_with_merge_freeList+0x2c>
  802a7a:	83 ec 04             	sub    $0x4,%esp
  802a7d:	68 f0 3b 80 00       	push   $0x803bf0
  802a82:	68 0e 01 00 00       	push   $0x10e
  802a87:	68 13 3c 80 00       	push   $0x803c13
  802a8c:	e8 da 06 00 00       	call   80316b <_panic>
  802a91:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a97:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9a:	89 10                	mov    %edx,(%eax)
  802a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9f:	8b 00                	mov    (%eax),%eax
  802aa1:	85 c0                	test   %eax,%eax
  802aa3:	74 0d                	je     802ab2 <insert_sorted_with_merge_freeList+0x4d>
  802aa5:	a1 38 41 80 00       	mov    0x804138,%eax
  802aaa:	8b 55 08             	mov    0x8(%ebp),%edx
  802aad:	89 50 04             	mov    %edx,0x4(%eax)
  802ab0:	eb 08                	jmp    802aba <insert_sorted_with_merge_freeList+0x55>
  802ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab5:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802aba:	8b 45 08             	mov    0x8(%ebp),%eax
  802abd:	a3 38 41 80 00       	mov    %eax,0x804138
  802ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802acc:	a1 44 41 80 00       	mov    0x804144,%eax
  802ad1:	40                   	inc    %eax
  802ad2:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802ad7:	e9 8c 06 00 00       	jmp    803168 <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  802adc:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ae1:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  802ae4:	a1 38 41 80 00       	mov    0x804138,%eax
  802ae9:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  802aec:	8b 45 08             	mov    0x8(%ebp),%eax
  802aef:	8b 50 08             	mov    0x8(%eax),%edx
  802af2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af5:	8b 40 08             	mov    0x8(%eax),%eax
  802af8:	39 c2                	cmp    %eax,%edx
  802afa:	0f 86 14 01 00 00    	jbe    802c14 <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  802b00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b03:	8b 50 0c             	mov    0xc(%eax),%edx
  802b06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b09:	8b 40 08             	mov    0x8(%eax),%eax
  802b0c:	01 c2                	add    %eax,%edx
  802b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b11:	8b 40 08             	mov    0x8(%eax),%eax
  802b14:	39 c2                	cmp    %eax,%edx
  802b16:	0f 85 90 00 00 00    	jne    802bac <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  802b1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1f:	8b 50 0c             	mov    0xc(%eax),%edx
  802b22:	8b 45 08             	mov    0x8(%ebp),%eax
  802b25:	8b 40 0c             	mov    0xc(%eax),%eax
  802b28:	01 c2                	add    %eax,%edx
  802b2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2d:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802b30:	8b 45 08             	mov    0x8(%ebp),%eax
  802b33:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802b44:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b48:	75 17                	jne    802b61 <insert_sorted_with_merge_freeList+0xfc>
  802b4a:	83 ec 04             	sub    $0x4,%esp
  802b4d:	68 f0 3b 80 00       	push   $0x803bf0
  802b52:	68 1b 01 00 00       	push   $0x11b
  802b57:	68 13 3c 80 00       	push   $0x803c13
  802b5c:	e8 0a 06 00 00       	call   80316b <_panic>
  802b61:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b67:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6a:	89 10                	mov    %edx,(%eax)
  802b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6f:	8b 00                	mov    (%eax),%eax
  802b71:	85 c0                	test   %eax,%eax
  802b73:	74 0d                	je     802b82 <insert_sorted_with_merge_freeList+0x11d>
  802b75:	a1 48 41 80 00       	mov    0x804148,%eax
  802b7a:	8b 55 08             	mov    0x8(%ebp),%edx
  802b7d:	89 50 04             	mov    %edx,0x4(%eax)
  802b80:	eb 08                	jmp    802b8a <insert_sorted_with_merge_freeList+0x125>
  802b82:	8b 45 08             	mov    0x8(%ebp),%eax
  802b85:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8d:	a3 48 41 80 00       	mov    %eax,0x804148
  802b92:	8b 45 08             	mov    0x8(%ebp),%eax
  802b95:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b9c:	a1 54 41 80 00       	mov    0x804154,%eax
  802ba1:	40                   	inc    %eax
  802ba2:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802ba7:	e9 bc 05 00 00       	jmp    803168 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802bac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bb0:	75 17                	jne    802bc9 <insert_sorted_with_merge_freeList+0x164>
  802bb2:	83 ec 04             	sub    $0x4,%esp
  802bb5:	68 2c 3c 80 00       	push   $0x803c2c
  802bba:	68 1f 01 00 00       	push   $0x11f
  802bbf:	68 13 3c 80 00       	push   $0x803c13
  802bc4:	e8 a2 05 00 00       	call   80316b <_panic>
  802bc9:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd2:	89 50 04             	mov    %edx,0x4(%eax)
  802bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd8:	8b 40 04             	mov    0x4(%eax),%eax
  802bdb:	85 c0                	test   %eax,%eax
  802bdd:	74 0c                	je     802beb <insert_sorted_with_merge_freeList+0x186>
  802bdf:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802be4:	8b 55 08             	mov    0x8(%ebp),%edx
  802be7:	89 10                	mov    %edx,(%eax)
  802be9:	eb 08                	jmp    802bf3 <insert_sorted_with_merge_freeList+0x18e>
  802beb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bee:	a3 38 41 80 00       	mov    %eax,0x804138
  802bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c04:	a1 44 41 80 00       	mov    0x804144,%eax
  802c09:	40                   	inc    %eax
  802c0a:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802c0f:	e9 54 05 00 00       	jmp    803168 <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  802c14:	8b 45 08             	mov    0x8(%ebp),%eax
  802c17:	8b 50 08             	mov    0x8(%eax),%edx
  802c1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c1d:	8b 40 08             	mov    0x8(%eax),%eax
  802c20:	39 c2                	cmp    %eax,%edx
  802c22:	0f 83 20 01 00 00    	jae    802d48 <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  802c28:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2b:	8b 50 0c             	mov    0xc(%eax),%edx
  802c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c31:	8b 40 08             	mov    0x8(%eax),%eax
  802c34:	01 c2                	add    %eax,%edx
  802c36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c39:	8b 40 08             	mov    0x8(%eax),%eax
  802c3c:	39 c2                	cmp    %eax,%edx
  802c3e:	0f 85 9c 00 00 00    	jne    802ce0 <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  802c44:	8b 45 08             	mov    0x8(%ebp),%eax
  802c47:	8b 50 08             	mov    0x8(%eax),%edx
  802c4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c4d:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  802c50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c53:	8b 50 0c             	mov    0xc(%eax),%edx
  802c56:	8b 45 08             	mov    0x8(%ebp),%eax
  802c59:	8b 40 0c             	mov    0xc(%eax),%eax
  802c5c:	01 c2                	add    %eax,%edx
  802c5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c61:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802c64:	8b 45 08             	mov    0x8(%ebp),%eax
  802c67:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c71:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802c78:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c7c:	75 17                	jne    802c95 <insert_sorted_with_merge_freeList+0x230>
  802c7e:	83 ec 04             	sub    $0x4,%esp
  802c81:	68 f0 3b 80 00       	push   $0x803bf0
  802c86:	68 2a 01 00 00       	push   $0x12a
  802c8b:	68 13 3c 80 00       	push   $0x803c13
  802c90:	e8 d6 04 00 00       	call   80316b <_panic>
  802c95:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9e:	89 10                	mov    %edx,(%eax)
  802ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca3:	8b 00                	mov    (%eax),%eax
  802ca5:	85 c0                	test   %eax,%eax
  802ca7:	74 0d                	je     802cb6 <insert_sorted_with_merge_freeList+0x251>
  802ca9:	a1 48 41 80 00       	mov    0x804148,%eax
  802cae:	8b 55 08             	mov    0x8(%ebp),%edx
  802cb1:	89 50 04             	mov    %edx,0x4(%eax)
  802cb4:	eb 08                	jmp    802cbe <insert_sorted_with_merge_freeList+0x259>
  802cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb9:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc1:	a3 48 41 80 00       	mov    %eax,0x804148
  802cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cd0:	a1 54 41 80 00       	mov    0x804154,%eax
  802cd5:	40                   	inc    %eax
  802cd6:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802cdb:	e9 88 04 00 00       	jmp    803168 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802ce0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ce4:	75 17                	jne    802cfd <insert_sorted_with_merge_freeList+0x298>
  802ce6:	83 ec 04             	sub    $0x4,%esp
  802ce9:	68 f0 3b 80 00       	push   $0x803bf0
  802cee:	68 2e 01 00 00       	push   $0x12e
  802cf3:	68 13 3c 80 00       	push   $0x803c13
  802cf8:	e8 6e 04 00 00       	call   80316b <_panic>
  802cfd:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802d03:	8b 45 08             	mov    0x8(%ebp),%eax
  802d06:	89 10                	mov    %edx,(%eax)
  802d08:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0b:	8b 00                	mov    (%eax),%eax
  802d0d:	85 c0                	test   %eax,%eax
  802d0f:	74 0d                	je     802d1e <insert_sorted_with_merge_freeList+0x2b9>
  802d11:	a1 38 41 80 00       	mov    0x804138,%eax
  802d16:	8b 55 08             	mov    0x8(%ebp),%edx
  802d19:	89 50 04             	mov    %edx,0x4(%eax)
  802d1c:	eb 08                	jmp    802d26 <insert_sorted_with_merge_freeList+0x2c1>
  802d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d21:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d26:	8b 45 08             	mov    0x8(%ebp),%eax
  802d29:	a3 38 41 80 00       	mov    %eax,0x804138
  802d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d31:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d38:	a1 44 41 80 00       	mov    0x804144,%eax
  802d3d:	40                   	inc    %eax
  802d3e:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802d43:	e9 20 04 00 00       	jmp    803168 <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  802d48:	a1 38 41 80 00       	mov    0x804138,%eax
  802d4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d50:	e9 e2 03 00 00       	jmp    803137 <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  802d55:	8b 45 08             	mov    0x8(%ebp),%eax
  802d58:	8b 50 08             	mov    0x8(%eax),%edx
  802d5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5e:	8b 40 08             	mov    0x8(%eax),%eax
  802d61:	39 c2                	cmp    %eax,%edx
  802d63:	0f 83 c6 03 00 00    	jae    80312f <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  802d69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6c:	8b 40 04             	mov    0x4(%eax),%eax
  802d6f:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  802d72:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d75:	8b 50 08             	mov    0x8(%eax),%edx
  802d78:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d7b:	8b 40 0c             	mov    0xc(%eax),%eax
  802d7e:	01 d0                	add    %edx,%eax
  802d80:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  802d83:	8b 45 08             	mov    0x8(%ebp),%eax
  802d86:	8b 50 0c             	mov    0xc(%eax),%edx
  802d89:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8c:	8b 40 08             	mov    0x8(%eax),%eax
  802d8f:	01 d0                	add    %edx,%eax
  802d91:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  802d94:	8b 45 08             	mov    0x8(%ebp),%eax
  802d97:	8b 40 08             	mov    0x8(%eax),%eax
  802d9a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802d9d:	74 7a                	je     802e19 <insert_sorted_with_merge_freeList+0x3b4>
  802d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da2:	8b 40 08             	mov    0x8(%eax),%eax
  802da5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802da8:	74 6f                	je     802e19 <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  802daa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dae:	74 06                	je     802db6 <insert_sorted_with_merge_freeList+0x351>
  802db0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802db4:	75 17                	jne    802dcd <insert_sorted_with_merge_freeList+0x368>
  802db6:	83 ec 04             	sub    $0x4,%esp
  802db9:	68 70 3c 80 00       	push   $0x803c70
  802dbe:	68 43 01 00 00       	push   $0x143
  802dc3:	68 13 3c 80 00       	push   $0x803c13
  802dc8:	e8 9e 03 00 00       	call   80316b <_panic>
  802dcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd0:	8b 50 04             	mov    0x4(%eax),%edx
  802dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd6:	89 50 04             	mov    %edx,0x4(%eax)
  802dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ddf:	89 10                	mov    %edx,(%eax)
  802de1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de4:	8b 40 04             	mov    0x4(%eax),%eax
  802de7:	85 c0                	test   %eax,%eax
  802de9:	74 0d                	je     802df8 <insert_sorted_with_merge_freeList+0x393>
  802deb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dee:	8b 40 04             	mov    0x4(%eax),%eax
  802df1:	8b 55 08             	mov    0x8(%ebp),%edx
  802df4:	89 10                	mov    %edx,(%eax)
  802df6:	eb 08                	jmp    802e00 <insert_sorted_with_merge_freeList+0x39b>
  802df8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfb:	a3 38 41 80 00       	mov    %eax,0x804138
  802e00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e03:	8b 55 08             	mov    0x8(%ebp),%edx
  802e06:	89 50 04             	mov    %edx,0x4(%eax)
  802e09:	a1 44 41 80 00       	mov    0x804144,%eax
  802e0e:	40                   	inc    %eax
  802e0f:	a3 44 41 80 00       	mov    %eax,0x804144
  802e14:	e9 14 03 00 00       	jmp    80312d <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  802e19:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1c:	8b 40 08             	mov    0x8(%eax),%eax
  802e1f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802e22:	0f 85 a0 01 00 00    	jne    802fc8 <insert_sorted_with_merge_freeList+0x563>
  802e28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2b:	8b 40 08             	mov    0x8(%eax),%eax
  802e2e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802e31:	0f 85 91 01 00 00    	jne    802fc8 <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  802e37:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e3a:	8b 50 0c             	mov    0xc(%eax),%edx
  802e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e40:	8b 48 0c             	mov    0xc(%eax),%ecx
  802e43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e46:	8b 40 0c             	mov    0xc(%eax),%eax
  802e49:	01 c8                	add    %ecx,%eax
  802e4b:	01 c2                	add    %eax,%edx
  802e4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e50:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802e53:	8b 45 08             	mov    0x8(%ebp),%eax
  802e56:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e60:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  802e67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  802e71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e74:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802e7b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e7f:	75 17                	jne    802e98 <insert_sorted_with_merge_freeList+0x433>
  802e81:	83 ec 04             	sub    $0x4,%esp
  802e84:	68 f0 3b 80 00       	push   $0x803bf0
  802e89:	68 4d 01 00 00       	push   $0x14d
  802e8e:	68 13 3c 80 00       	push   $0x803c13
  802e93:	e8 d3 02 00 00       	call   80316b <_panic>
  802e98:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea1:	89 10                	mov    %edx,(%eax)
  802ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea6:	8b 00                	mov    (%eax),%eax
  802ea8:	85 c0                	test   %eax,%eax
  802eaa:	74 0d                	je     802eb9 <insert_sorted_with_merge_freeList+0x454>
  802eac:	a1 48 41 80 00       	mov    0x804148,%eax
  802eb1:	8b 55 08             	mov    0x8(%ebp),%edx
  802eb4:	89 50 04             	mov    %edx,0x4(%eax)
  802eb7:	eb 08                	jmp    802ec1 <insert_sorted_with_merge_freeList+0x45c>
  802eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebc:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec4:	a3 48 41 80 00       	mov    %eax,0x804148
  802ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ed3:	a1 54 41 80 00       	mov    0x804154,%eax
  802ed8:	40                   	inc    %eax
  802ed9:	a3 54 41 80 00       	mov    %eax,0x804154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  802ede:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ee2:	75 17                	jne    802efb <insert_sorted_with_merge_freeList+0x496>
  802ee4:	83 ec 04             	sub    $0x4,%esp
  802ee7:	68 4f 3c 80 00       	push   $0x803c4f
  802eec:	68 4e 01 00 00       	push   $0x14e
  802ef1:	68 13 3c 80 00       	push   $0x803c13
  802ef6:	e8 70 02 00 00       	call   80316b <_panic>
  802efb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efe:	8b 00                	mov    (%eax),%eax
  802f00:	85 c0                	test   %eax,%eax
  802f02:	74 10                	je     802f14 <insert_sorted_with_merge_freeList+0x4af>
  802f04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f07:	8b 00                	mov    (%eax),%eax
  802f09:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f0c:	8b 52 04             	mov    0x4(%edx),%edx
  802f0f:	89 50 04             	mov    %edx,0x4(%eax)
  802f12:	eb 0b                	jmp    802f1f <insert_sorted_with_merge_freeList+0x4ba>
  802f14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f17:	8b 40 04             	mov    0x4(%eax),%eax
  802f1a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f22:	8b 40 04             	mov    0x4(%eax),%eax
  802f25:	85 c0                	test   %eax,%eax
  802f27:	74 0f                	je     802f38 <insert_sorted_with_merge_freeList+0x4d3>
  802f29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2c:	8b 40 04             	mov    0x4(%eax),%eax
  802f2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f32:	8b 12                	mov    (%edx),%edx
  802f34:	89 10                	mov    %edx,(%eax)
  802f36:	eb 0a                	jmp    802f42 <insert_sorted_with_merge_freeList+0x4dd>
  802f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3b:	8b 00                	mov    (%eax),%eax
  802f3d:	a3 38 41 80 00       	mov    %eax,0x804138
  802f42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f45:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f55:	a1 44 41 80 00       	mov    0x804144,%eax
  802f5a:	48                   	dec    %eax
  802f5b:	a3 44 41 80 00       	mov    %eax,0x804144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  802f60:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f64:	75 17                	jne    802f7d <insert_sorted_with_merge_freeList+0x518>
  802f66:	83 ec 04             	sub    $0x4,%esp
  802f69:	68 f0 3b 80 00       	push   $0x803bf0
  802f6e:	68 4f 01 00 00       	push   $0x14f
  802f73:	68 13 3c 80 00       	push   $0x803c13
  802f78:	e8 ee 01 00 00       	call   80316b <_panic>
  802f7d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f86:	89 10                	mov    %edx,(%eax)
  802f88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8b:	8b 00                	mov    (%eax),%eax
  802f8d:	85 c0                	test   %eax,%eax
  802f8f:	74 0d                	je     802f9e <insert_sorted_with_merge_freeList+0x539>
  802f91:	a1 48 41 80 00       	mov    0x804148,%eax
  802f96:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f99:	89 50 04             	mov    %edx,0x4(%eax)
  802f9c:	eb 08                	jmp    802fa6 <insert_sorted_with_merge_freeList+0x541>
  802f9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802fa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa9:	a3 48 41 80 00       	mov    %eax,0x804148
  802fae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fb8:	a1 54 41 80 00       	mov    0x804154,%eax
  802fbd:	40                   	inc    %eax
  802fbe:	a3 54 41 80 00       	mov    %eax,0x804154
  802fc3:	e9 65 01 00 00       	jmp    80312d <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  802fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcb:	8b 40 08             	mov    0x8(%eax),%eax
  802fce:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802fd1:	0f 85 9f 00 00 00    	jne    803076 <insert_sorted_with_merge_freeList+0x611>
  802fd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fda:	8b 40 08             	mov    0x8(%eax),%eax
  802fdd:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802fe0:	0f 84 90 00 00 00    	je     803076 <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  802fe6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fe9:	8b 50 0c             	mov    0xc(%eax),%edx
  802fec:	8b 45 08             	mov    0x8(%ebp),%eax
  802fef:	8b 40 0c             	mov    0xc(%eax),%eax
  802ff2:	01 c2                	add    %eax,%edx
  802ff4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff7:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  803004:	8b 45 08             	mov    0x8(%ebp),%eax
  803007:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80300e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803012:	75 17                	jne    80302b <insert_sorted_with_merge_freeList+0x5c6>
  803014:	83 ec 04             	sub    $0x4,%esp
  803017:	68 f0 3b 80 00       	push   $0x803bf0
  80301c:	68 58 01 00 00       	push   $0x158
  803021:	68 13 3c 80 00       	push   $0x803c13
  803026:	e8 40 01 00 00       	call   80316b <_panic>
  80302b:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803031:	8b 45 08             	mov    0x8(%ebp),%eax
  803034:	89 10                	mov    %edx,(%eax)
  803036:	8b 45 08             	mov    0x8(%ebp),%eax
  803039:	8b 00                	mov    (%eax),%eax
  80303b:	85 c0                	test   %eax,%eax
  80303d:	74 0d                	je     80304c <insert_sorted_with_merge_freeList+0x5e7>
  80303f:	a1 48 41 80 00       	mov    0x804148,%eax
  803044:	8b 55 08             	mov    0x8(%ebp),%edx
  803047:	89 50 04             	mov    %edx,0x4(%eax)
  80304a:	eb 08                	jmp    803054 <insert_sorted_with_merge_freeList+0x5ef>
  80304c:	8b 45 08             	mov    0x8(%ebp),%eax
  80304f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803054:	8b 45 08             	mov    0x8(%ebp),%eax
  803057:	a3 48 41 80 00       	mov    %eax,0x804148
  80305c:	8b 45 08             	mov    0x8(%ebp),%eax
  80305f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803066:	a1 54 41 80 00       	mov    0x804154,%eax
  80306b:	40                   	inc    %eax
  80306c:	a3 54 41 80 00       	mov    %eax,0x804154
  803071:	e9 b7 00 00 00       	jmp    80312d <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  803076:	8b 45 08             	mov    0x8(%ebp),%eax
  803079:	8b 40 08             	mov    0x8(%eax),%eax
  80307c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80307f:	0f 84 e2 00 00 00    	je     803167 <insert_sorted_with_merge_freeList+0x702>
  803085:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803088:	8b 40 08             	mov    0x8(%eax),%eax
  80308b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80308e:	0f 85 d3 00 00 00    	jne    803167 <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  803094:	8b 45 08             	mov    0x8(%ebp),%eax
  803097:	8b 50 08             	mov    0x8(%eax),%edx
  80309a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309d:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  8030a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a3:	8b 50 0c             	mov    0xc(%eax),%edx
  8030a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8030ac:	01 c2                	add    %eax,%edx
  8030ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b1:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  8030b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  8030be:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8030c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030cc:	75 17                	jne    8030e5 <insert_sorted_with_merge_freeList+0x680>
  8030ce:	83 ec 04             	sub    $0x4,%esp
  8030d1:	68 f0 3b 80 00       	push   $0x803bf0
  8030d6:	68 61 01 00 00       	push   $0x161
  8030db:	68 13 3c 80 00       	push   $0x803c13
  8030e0:	e8 86 00 00 00       	call   80316b <_panic>
  8030e5:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8030eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ee:	89 10                	mov    %edx,(%eax)
  8030f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f3:	8b 00                	mov    (%eax),%eax
  8030f5:	85 c0                	test   %eax,%eax
  8030f7:	74 0d                	je     803106 <insert_sorted_with_merge_freeList+0x6a1>
  8030f9:	a1 48 41 80 00       	mov    0x804148,%eax
  8030fe:	8b 55 08             	mov    0x8(%ebp),%edx
  803101:	89 50 04             	mov    %edx,0x4(%eax)
  803104:	eb 08                	jmp    80310e <insert_sorted_with_merge_freeList+0x6a9>
  803106:	8b 45 08             	mov    0x8(%ebp),%eax
  803109:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80310e:	8b 45 08             	mov    0x8(%ebp),%eax
  803111:	a3 48 41 80 00       	mov    %eax,0x804148
  803116:	8b 45 08             	mov    0x8(%ebp),%eax
  803119:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803120:	a1 54 41 80 00       	mov    0x804154,%eax
  803125:	40                   	inc    %eax
  803126:	a3 54 41 80 00       	mov    %eax,0x804154
								}
								break;
  80312b:	eb 3a                	jmp    803167 <insert_sorted_with_merge_freeList+0x702>
  80312d:	eb 38                	jmp    803167 <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  80312f:	a1 40 41 80 00       	mov    0x804140,%eax
  803134:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803137:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80313b:	74 07                	je     803144 <insert_sorted_with_merge_freeList+0x6df>
  80313d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803140:	8b 00                	mov    (%eax),%eax
  803142:	eb 05                	jmp    803149 <insert_sorted_with_merge_freeList+0x6e4>
  803144:	b8 00 00 00 00       	mov    $0x0,%eax
  803149:	a3 40 41 80 00       	mov    %eax,0x804140
  80314e:	a1 40 41 80 00       	mov    0x804140,%eax
  803153:	85 c0                	test   %eax,%eax
  803155:	0f 85 fa fb ff ff    	jne    802d55 <insert_sorted_with_merge_freeList+0x2f0>
  80315b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80315f:	0f 85 f0 fb ff ff    	jne    802d55 <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  803165:	eb 01                	jmp    803168 <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  803167:	90                   	nop
							}

						}
		          }
		}
}
  803168:	90                   	nop
  803169:	c9                   	leave  
  80316a:	c3                   	ret    

0080316b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80316b:	55                   	push   %ebp
  80316c:	89 e5                	mov    %esp,%ebp
  80316e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803171:	8d 45 10             	lea    0x10(%ebp),%eax
  803174:	83 c0 04             	add    $0x4,%eax
  803177:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80317a:	a1 60 41 80 00       	mov    0x804160,%eax
  80317f:	85 c0                	test   %eax,%eax
  803181:	74 16                	je     803199 <_panic+0x2e>
		cprintf("%s: ", argv0);
  803183:	a1 60 41 80 00       	mov    0x804160,%eax
  803188:	83 ec 08             	sub    $0x8,%esp
  80318b:	50                   	push   %eax
  80318c:	68 a8 3c 80 00       	push   $0x803ca8
  803191:	e8 ed d4 ff ff       	call   800683 <cprintf>
  803196:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803199:	a1 00 40 80 00       	mov    0x804000,%eax
  80319e:	ff 75 0c             	pushl  0xc(%ebp)
  8031a1:	ff 75 08             	pushl  0x8(%ebp)
  8031a4:	50                   	push   %eax
  8031a5:	68 ad 3c 80 00       	push   $0x803cad
  8031aa:	e8 d4 d4 ff ff       	call   800683 <cprintf>
  8031af:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8031b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8031b5:	83 ec 08             	sub    $0x8,%esp
  8031b8:	ff 75 f4             	pushl  -0xc(%ebp)
  8031bb:	50                   	push   %eax
  8031bc:	e8 57 d4 ff ff       	call   800618 <vcprintf>
  8031c1:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8031c4:	83 ec 08             	sub    $0x8,%esp
  8031c7:	6a 00                	push   $0x0
  8031c9:	68 c9 3c 80 00       	push   $0x803cc9
  8031ce:	e8 45 d4 ff ff       	call   800618 <vcprintf>
  8031d3:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8031d6:	e8 c6 d3 ff ff       	call   8005a1 <exit>

	// should not return here
	while (1) ;
  8031db:	eb fe                	jmp    8031db <_panic+0x70>

008031dd <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8031dd:	55                   	push   %ebp
  8031de:	89 e5                	mov    %esp,%ebp
  8031e0:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8031e3:	a1 20 40 80 00       	mov    0x804020,%eax
  8031e8:	8b 50 74             	mov    0x74(%eax),%edx
  8031eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031ee:	39 c2                	cmp    %eax,%edx
  8031f0:	74 14                	je     803206 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8031f2:	83 ec 04             	sub    $0x4,%esp
  8031f5:	68 cc 3c 80 00       	push   $0x803ccc
  8031fa:	6a 26                	push   $0x26
  8031fc:	68 18 3d 80 00       	push   $0x803d18
  803201:	e8 65 ff ff ff       	call   80316b <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803206:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80320d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803214:	e9 c2 00 00 00       	jmp    8032db <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  803219:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80321c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803223:	8b 45 08             	mov    0x8(%ebp),%eax
  803226:	01 d0                	add    %edx,%eax
  803228:	8b 00                	mov    (%eax),%eax
  80322a:	85 c0                	test   %eax,%eax
  80322c:	75 08                	jne    803236 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80322e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803231:	e9 a2 00 00 00       	jmp    8032d8 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  803236:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80323d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803244:	eb 69                	jmp    8032af <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803246:	a1 20 40 80 00       	mov    0x804020,%eax
  80324b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803251:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803254:	89 d0                	mov    %edx,%eax
  803256:	01 c0                	add    %eax,%eax
  803258:	01 d0                	add    %edx,%eax
  80325a:	c1 e0 03             	shl    $0x3,%eax
  80325d:	01 c8                	add    %ecx,%eax
  80325f:	8a 40 04             	mov    0x4(%eax),%al
  803262:	84 c0                	test   %al,%al
  803264:	75 46                	jne    8032ac <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803266:	a1 20 40 80 00       	mov    0x804020,%eax
  80326b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803271:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803274:	89 d0                	mov    %edx,%eax
  803276:	01 c0                	add    %eax,%eax
  803278:	01 d0                	add    %edx,%eax
  80327a:	c1 e0 03             	shl    $0x3,%eax
  80327d:	01 c8                	add    %ecx,%eax
  80327f:	8b 00                	mov    (%eax),%eax
  803281:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803284:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803287:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80328c:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80328e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803291:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803298:	8b 45 08             	mov    0x8(%ebp),%eax
  80329b:	01 c8                	add    %ecx,%eax
  80329d:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80329f:	39 c2                	cmp    %eax,%edx
  8032a1:	75 09                	jne    8032ac <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8032a3:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8032aa:	eb 12                	jmp    8032be <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8032ac:	ff 45 e8             	incl   -0x18(%ebp)
  8032af:	a1 20 40 80 00       	mov    0x804020,%eax
  8032b4:	8b 50 74             	mov    0x74(%eax),%edx
  8032b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ba:	39 c2                	cmp    %eax,%edx
  8032bc:	77 88                	ja     803246 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8032be:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8032c2:	75 14                	jne    8032d8 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8032c4:	83 ec 04             	sub    $0x4,%esp
  8032c7:	68 24 3d 80 00       	push   $0x803d24
  8032cc:	6a 3a                	push   $0x3a
  8032ce:	68 18 3d 80 00       	push   $0x803d18
  8032d3:	e8 93 fe ff ff       	call   80316b <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8032d8:	ff 45 f0             	incl   -0x10(%ebp)
  8032db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032de:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8032e1:	0f 8c 32 ff ff ff    	jl     803219 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8032e7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8032ee:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8032f5:	eb 26                	jmp    80331d <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8032f7:	a1 20 40 80 00       	mov    0x804020,%eax
  8032fc:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803302:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803305:	89 d0                	mov    %edx,%eax
  803307:	01 c0                	add    %eax,%eax
  803309:	01 d0                	add    %edx,%eax
  80330b:	c1 e0 03             	shl    $0x3,%eax
  80330e:	01 c8                	add    %ecx,%eax
  803310:	8a 40 04             	mov    0x4(%eax),%al
  803313:	3c 01                	cmp    $0x1,%al
  803315:	75 03                	jne    80331a <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  803317:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80331a:	ff 45 e0             	incl   -0x20(%ebp)
  80331d:	a1 20 40 80 00       	mov    0x804020,%eax
  803322:	8b 50 74             	mov    0x74(%eax),%edx
  803325:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803328:	39 c2                	cmp    %eax,%edx
  80332a:	77 cb                	ja     8032f7 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80332c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803332:	74 14                	je     803348 <CheckWSWithoutLastIndex+0x16b>
		panic(
  803334:	83 ec 04             	sub    $0x4,%esp
  803337:	68 78 3d 80 00       	push   $0x803d78
  80333c:	6a 44                	push   $0x44
  80333e:	68 18 3d 80 00       	push   $0x803d18
  803343:	e8 23 fe ff ff       	call   80316b <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803348:	90                   	nop
  803349:	c9                   	leave  
  80334a:	c3                   	ret    
  80334b:	90                   	nop

0080334c <__udivdi3>:
  80334c:	55                   	push   %ebp
  80334d:	57                   	push   %edi
  80334e:	56                   	push   %esi
  80334f:	53                   	push   %ebx
  803350:	83 ec 1c             	sub    $0x1c,%esp
  803353:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803357:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80335b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80335f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803363:	89 ca                	mov    %ecx,%edx
  803365:	89 f8                	mov    %edi,%eax
  803367:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80336b:	85 f6                	test   %esi,%esi
  80336d:	75 2d                	jne    80339c <__udivdi3+0x50>
  80336f:	39 cf                	cmp    %ecx,%edi
  803371:	77 65                	ja     8033d8 <__udivdi3+0x8c>
  803373:	89 fd                	mov    %edi,%ebp
  803375:	85 ff                	test   %edi,%edi
  803377:	75 0b                	jne    803384 <__udivdi3+0x38>
  803379:	b8 01 00 00 00       	mov    $0x1,%eax
  80337e:	31 d2                	xor    %edx,%edx
  803380:	f7 f7                	div    %edi
  803382:	89 c5                	mov    %eax,%ebp
  803384:	31 d2                	xor    %edx,%edx
  803386:	89 c8                	mov    %ecx,%eax
  803388:	f7 f5                	div    %ebp
  80338a:	89 c1                	mov    %eax,%ecx
  80338c:	89 d8                	mov    %ebx,%eax
  80338e:	f7 f5                	div    %ebp
  803390:	89 cf                	mov    %ecx,%edi
  803392:	89 fa                	mov    %edi,%edx
  803394:	83 c4 1c             	add    $0x1c,%esp
  803397:	5b                   	pop    %ebx
  803398:	5e                   	pop    %esi
  803399:	5f                   	pop    %edi
  80339a:	5d                   	pop    %ebp
  80339b:	c3                   	ret    
  80339c:	39 ce                	cmp    %ecx,%esi
  80339e:	77 28                	ja     8033c8 <__udivdi3+0x7c>
  8033a0:	0f bd fe             	bsr    %esi,%edi
  8033a3:	83 f7 1f             	xor    $0x1f,%edi
  8033a6:	75 40                	jne    8033e8 <__udivdi3+0x9c>
  8033a8:	39 ce                	cmp    %ecx,%esi
  8033aa:	72 0a                	jb     8033b6 <__udivdi3+0x6a>
  8033ac:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8033b0:	0f 87 9e 00 00 00    	ja     803454 <__udivdi3+0x108>
  8033b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8033bb:	89 fa                	mov    %edi,%edx
  8033bd:	83 c4 1c             	add    $0x1c,%esp
  8033c0:	5b                   	pop    %ebx
  8033c1:	5e                   	pop    %esi
  8033c2:	5f                   	pop    %edi
  8033c3:	5d                   	pop    %ebp
  8033c4:	c3                   	ret    
  8033c5:	8d 76 00             	lea    0x0(%esi),%esi
  8033c8:	31 ff                	xor    %edi,%edi
  8033ca:	31 c0                	xor    %eax,%eax
  8033cc:	89 fa                	mov    %edi,%edx
  8033ce:	83 c4 1c             	add    $0x1c,%esp
  8033d1:	5b                   	pop    %ebx
  8033d2:	5e                   	pop    %esi
  8033d3:	5f                   	pop    %edi
  8033d4:	5d                   	pop    %ebp
  8033d5:	c3                   	ret    
  8033d6:	66 90                	xchg   %ax,%ax
  8033d8:	89 d8                	mov    %ebx,%eax
  8033da:	f7 f7                	div    %edi
  8033dc:	31 ff                	xor    %edi,%edi
  8033de:	89 fa                	mov    %edi,%edx
  8033e0:	83 c4 1c             	add    $0x1c,%esp
  8033e3:	5b                   	pop    %ebx
  8033e4:	5e                   	pop    %esi
  8033e5:	5f                   	pop    %edi
  8033e6:	5d                   	pop    %ebp
  8033e7:	c3                   	ret    
  8033e8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8033ed:	89 eb                	mov    %ebp,%ebx
  8033ef:	29 fb                	sub    %edi,%ebx
  8033f1:	89 f9                	mov    %edi,%ecx
  8033f3:	d3 e6                	shl    %cl,%esi
  8033f5:	89 c5                	mov    %eax,%ebp
  8033f7:	88 d9                	mov    %bl,%cl
  8033f9:	d3 ed                	shr    %cl,%ebp
  8033fb:	89 e9                	mov    %ebp,%ecx
  8033fd:	09 f1                	or     %esi,%ecx
  8033ff:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803403:	89 f9                	mov    %edi,%ecx
  803405:	d3 e0                	shl    %cl,%eax
  803407:	89 c5                	mov    %eax,%ebp
  803409:	89 d6                	mov    %edx,%esi
  80340b:	88 d9                	mov    %bl,%cl
  80340d:	d3 ee                	shr    %cl,%esi
  80340f:	89 f9                	mov    %edi,%ecx
  803411:	d3 e2                	shl    %cl,%edx
  803413:	8b 44 24 08          	mov    0x8(%esp),%eax
  803417:	88 d9                	mov    %bl,%cl
  803419:	d3 e8                	shr    %cl,%eax
  80341b:	09 c2                	or     %eax,%edx
  80341d:	89 d0                	mov    %edx,%eax
  80341f:	89 f2                	mov    %esi,%edx
  803421:	f7 74 24 0c          	divl   0xc(%esp)
  803425:	89 d6                	mov    %edx,%esi
  803427:	89 c3                	mov    %eax,%ebx
  803429:	f7 e5                	mul    %ebp
  80342b:	39 d6                	cmp    %edx,%esi
  80342d:	72 19                	jb     803448 <__udivdi3+0xfc>
  80342f:	74 0b                	je     80343c <__udivdi3+0xf0>
  803431:	89 d8                	mov    %ebx,%eax
  803433:	31 ff                	xor    %edi,%edi
  803435:	e9 58 ff ff ff       	jmp    803392 <__udivdi3+0x46>
  80343a:	66 90                	xchg   %ax,%ax
  80343c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803440:	89 f9                	mov    %edi,%ecx
  803442:	d3 e2                	shl    %cl,%edx
  803444:	39 c2                	cmp    %eax,%edx
  803446:	73 e9                	jae    803431 <__udivdi3+0xe5>
  803448:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80344b:	31 ff                	xor    %edi,%edi
  80344d:	e9 40 ff ff ff       	jmp    803392 <__udivdi3+0x46>
  803452:	66 90                	xchg   %ax,%ax
  803454:	31 c0                	xor    %eax,%eax
  803456:	e9 37 ff ff ff       	jmp    803392 <__udivdi3+0x46>
  80345b:	90                   	nop

0080345c <__umoddi3>:
  80345c:	55                   	push   %ebp
  80345d:	57                   	push   %edi
  80345e:	56                   	push   %esi
  80345f:	53                   	push   %ebx
  803460:	83 ec 1c             	sub    $0x1c,%esp
  803463:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803467:	8b 74 24 34          	mov    0x34(%esp),%esi
  80346b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80346f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803473:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803477:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80347b:	89 f3                	mov    %esi,%ebx
  80347d:	89 fa                	mov    %edi,%edx
  80347f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803483:	89 34 24             	mov    %esi,(%esp)
  803486:	85 c0                	test   %eax,%eax
  803488:	75 1a                	jne    8034a4 <__umoddi3+0x48>
  80348a:	39 f7                	cmp    %esi,%edi
  80348c:	0f 86 a2 00 00 00    	jbe    803534 <__umoddi3+0xd8>
  803492:	89 c8                	mov    %ecx,%eax
  803494:	89 f2                	mov    %esi,%edx
  803496:	f7 f7                	div    %edi
  803498:	89 d0                	mov    %edx,%eax
  80349a:	31 d2                	xor    %edx,%edx
  80349c:	83 c4 1c             	add    $0x1c,%esp
  80349f:	5b                   	pop    %ebx
  8034a0:	5e                   	pop    %esi
  8034a1:	5f                   	pop    %edi
  8034a2:	5d                   	pop    %ebp
  8034a3:	c3                   	ret    
  8034a4:	39 f0                	cmp    %esi,%eax
  8034a6:	0f 87 ac 00 00 00    	ja     803558 <__umoddi3+0xfc>
  8034ac:	0f bd e8             	bsr    %eax,%ebp
  8034af:	83 f5 1f             	xor    $0x1f,%ebp
  8034b2:	0f 84 ac 00 00 00    	je     803564 <__umoddi3+0x108>
  8034b8:	bf 20 00 00 00       	mov    $0x20,%edi
  8034bd:	29 ef                	sub    %ebp,%edi
  8034bf:	89 fe                	mov    %edi,%esi
  8034c1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8034c5:	89 e9                	mov    %ebp,%ecx
  8034c7:	d3 e0                	shl    %cl,%eax
  8034c9:	89 d7                	mov    %edx,%edi
  8034cb:	89 f1                	mov    %esi,%ecx
  8034cd:	d3 ef                	shr    %cl,%edi
  8034cf:	09 c7                	or     %eax,%edi
  8034d1:	89 e9                	mov    %ebp,%ecx
  8034d3:	d3 e2                	shl    %cl,%edx
  8034d5:	89 14 24             	mov    %edx,(%esp)
  8034d8:	89 d8                	mov    %ebx,%eax
  8034da:	d3 e0                	shl    %cl,%eax
  8034dc:	89 c2                	mov    %eax,%edx
  8034de:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034e2:	d3 e0                	shl    %cl,%eax
  8034e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034e8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034ec:	89 f1                	mov    %esi,%ecx
  8034ee:	d3 e8                	shr    %cl,%eax
  8034f0:	09 d0                	or     %edx,%eax
  8034f2:	d3 eb                	shr    %cl,%ebx
  8034f4:	89 da                	mov    %ebx,%edx
  8034f6:	f7 f7                	div    %edi
  8034f8:	89 d3                	mov    %edx,%ebx
  8034fa:	f7 24 24             	mull   (%esp)
  8034fd:	89 c6                	mov    %eax,%esi
  8034ff:	89 d1                	mov    %edx,%ecx
  803501:	39 d3                	cmp    %edx,%ebx
  803503:	0f 82 87 00 00 00    	jb     803590 <__umoddi3+0x134>
  803509:	0f 84 91 00 00 00    	je     8035a0 <__umoddi3+0x144>
  80350f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803513:	29 f2                	sub    %esi,%edx
  803515:	19 cb                	sbb    %ecx,%ebx
  803517:	89 d8                	mov    %ebx,%eax
  803519:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80351d:	d3 e0                	shl    %cl,%eax
  80351f:	89 e9                	mov    %ebp,%ecx
  803521:	d3 ea                	shr    %cl,%edx
  803523:	09 d0                	or     %edx,%eax
  803525:	89 e9                	mov    %ebp,%ecx
  803527:	d3 eb                	shr    %cl,%ebx
  803529:	89 da                	mov    %ebx,%edx
  80352b:	83 c4 1c             	add    $0x1c,%esp
  80352e:	5b                   	pop    %ebx
  80352f:	5e                   	pop    %esi
  803530:	5f                   	pop    %edi
  803531:	5d                   	pop    %ebp
  803532:	c3                   	ret    
  803533:	90                   	nop
  803534:	89 fd                	mov    %edi,%ebp
  803536:	85 ff                	test   %edi,%edi
  803538:	75 0b                	jne    803545 <__umoddi3+0xe9>
  80353a:	b8 01 00 00 00       	mov    $0x1,%eax
  80353f:	31 d2                	xor    %edx,%edx
  803541:	f7 f7                	div    %edi
  803543:	89 c5                	mov    %eax,%ebp
  803545:	89 f0                	mov    %esi,%eax
  803547:	31 d2                	xor    %edx,%edx
  803549:	f7 f5                	div    %ebp
  80354b:	89 c8                	mov    %ecx,%eax
  80354d:	f7 f5                	div    %ebp
  80354f:	89 d0                	mov    %edx,%eax
  803551:	e9 44 ff ff ff       	jmp    80349a <__umoddi3+0x3e>
  803556:	66 90                	xchg   %ax,%ax
  803558:	89 c8                	mov    %ecx,%eax
  80355a:	89 f2                	mov    %esi,%edx
  80355c:	83 c4 1c             	add    $0x1c,%esp
  80355f:	5b                   	pop    %ebx
  803560:	5e                   	pop    %esi
  803561:	5f                   	pop    %edi
  803562:	5d                   	pop    %ebp
  803563:	c3                   	ret    
  803564:	3b 04 24             	cmp    (%esp),%eax
  803567:	72 06                	jb     80356f <__umoddi3+0x113>
  803569:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80356d:	77 0f                	ja     80357e <__umoddi3+0x122>
  80356f:	89 f2                	mov    %esi,%edx
  803571:	29 f9                	sub    %edi,%ecx
  803573:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803577:	89 14 24             	mov    %edx,(%esp)
  80357a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80357e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803582:	8b 14 24             	mov    (%esp),%edx
  803585:	83 c4 1c             	add    $0x1c,%esp
  803588:	5b                   	pop    %ebx
  803589:	5e                   	pop    %esi
  80358a:	5f                   	pop    %edi
  80358b:	5d                   	pop    %ebp
  80358c:	c3                   	ret    
  80358d:	8d 76 00             	lea    0x0(%esi),%esi
  803590:	2b 04 24             	sub    (%esp),%eax
  803593:	19 fa                	sbb    %edi,%edx
  803595:	89 d1                	mov    %edx,%ecx
  803597:	89 c6                	mov    %eax,%esi
  803599:	e9 71 ff ff ff       	jmp    80350f <__umoddi3+0xb3>
  80359e:	66 90                	xchg   %ax,%ax
  8035a0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8035a4:	72 ea                	jb     803590 <__umoddi3+0x134>
  8035a6:	89 d9                	mov    %ebx,%ecx
  8035a8:	e9 62 ff ff ff       	jmp    80350f <__umoddi3+0xb3>

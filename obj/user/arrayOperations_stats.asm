
obj/user/arrayOperations_stats:     file format elf32-i386


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
  800031:	e8 f7 04 00 00       	call   80052d <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void ArrayStats(int *Elements, int NumOfElements, int *mean, int *var, int *min, int *max, int *med);
int KthElement(int *Elements, int NumOfElements, int k);
int QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex, int kIndex);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 58             	sub    $0x58,%esp
	int32 envID = sys_getenvid();
  80003e:	e8 5d 1d 00 00       	call   801da0 <sys_getenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int32 parentenvID = sys_getparentenvid();
  800046:	e8 87 1d 00 00       	call   801dd2 <sys_getparentenvid>
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
  80005f:	68 80 36 80 00       	push   $0x803680
  800064:	ff 75 ec             	pushl  -0x14(%ebp)
  800067:	e8 26 18 00 00       	call   801892 <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 84 36 80 00       	push   $0x803684
  80007a:	ff 75 ec             	pushl  -0x14(%ebp)
  80007d:	e8 10 18 00 00       	call   801892 <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800088:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	finishedCount = sget(parentenvID,"finishedCount") ;
  80008f:	83 ec 08             	sub    $0x8,%esp
  800092:	68 8c 36 80 00       	push   $0x80368c
  800097:	ff 75 ec             	pushl  -0x14(%ebp)
  80009a:	e8 f3 17 00 00       	call   801892 <sget>
  80009f:	83 c4 10             	add    $0x10,%esp
  8000a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int max ;
	int med ;

	//take a copy from the original array
	int *tmpArray;
	tmpArray = smalloc("tmpArr", sizeof(int) * *numOfElements, 0) ;
  8000a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000a8:	8b 00                	mov    (%eax),%eax
  8000aa:	c1 e0 02             	shl    $0x2,%eax
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 00                	push   $0x0
  8000b2:	50                   	push   %eax
  8000b3:	68 9a 36 80 00       	push   $0x80369a
  8000b8:	e8 03 17 00 00       	call   8017c0 <smalloc>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8000ca:	eb 25                	jmp    8000f1 <_main+0xb9>
	{
		tmpArray[i] = sharedArray[i];
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

	//take a copy from the original array
	int *tmpArray;
	tmpArray = smalloc("tmpArr", sizeof(int) * *numOfElements, 0) ;
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000ee:	ff 45 f4             	incl   -0xc(%ebp)
  8000f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f4:	8b 00                	mov    (%eax),%eax
  8000f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000f9:	7f d1                	jg     8000cc <_main+0x94>
	{
		tmpArray[i] = sharedArray[i];
	}

	ArrayStats(tmpArray ,*numOfElements, &mean, &var, &min, &max, &med);
  8000fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000fe:	8b 00                	mov    (%eax),%eax
  800100:	83 ec 04             	sub    $0x4,%esp
  800103:	8d 55 b4             	lea    -0x4c(%ebp),%edx
  800106:	52                   	push   %edx
  800107:	8d 55 b8             	lea    -0x48(%ebp),%edx
  80010a:	52                   	push   %edx
  80010b:	8d 55 bc             	lea    -0x44(%ebp),%edx
  80010e:	52                   	push   %edx
  80010f:	8d 55 c0             	lea    -0x40(%ebp),%edx
  800112:	52                   	push   %edx
  800113:	8d 55 c4             	lea    -0x3c(%ebp),%edx
  800116:	52                   	push   %edx
  800117:	50                   	push   %eax
  800118:	ff 75 dc             	pushl  -0x24(%ebp)
  80011b:	e8 55 02 00 00       	call   800375 <ArrayStats>
  800120:	83 c4 20             	add    $0x20,%esp
	cprintf("Stats Calculations are Finished!!!!\n") ;
  800123:	83 ec 0c             	sub    $0xc,%esp
  800126:	68 a4 36 80 00       	push   $0x8036a4
  80012b:	e8 0d 06 00 00       	call   80073d <cprintf>
  800130:	83 c4 10             	add    $0x10,%esp

	/*[3] SHARE THE RESULTS & DECLARE FINISHING*/
	int *shMean, *shVar, *shMin, *shMax, *shMed;
	shMean = smalloc("mean", sizeof(int), 0) ; *shMean = mean;
  800133:	83 ec 04             	sub    $0x4,%esp
  800136:	6a 00                	push   $0x0
  800138:	6a 04                	push   $0x4
  80013a:	68 c9 36 80 00       	push   $0x8036c9
  80013f:	e8 7c 16 00 00       	call   8017c0 <smalloc>
  800144:	83 c4 10             	add    $0x10,%esp
  800147:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80014a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80014d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800150:	89 10                	mov    %edx,(%eax)
	shVar = smalloc("var", sizeof(int), 0) ; *shVar = var;
  800152:	83 ec 04             	sub    $0x4,%esp
  800155:	6a 00                	push   $0x0
  800157:	6a 04                	push   $0x4
  800159:	68 ce 36 80 00       	push   $0x8036ce
  80015e:	e8 5d 16 00 00       	call   8017c0 <smalloc>
  800163:	83 c4 10             	add    $0x10,%esp
  800166:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800169:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80016c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80016f:	89 10                	mov    %edx,(%eax)
	shMin = smalloc("min", sizeof(int), 0) ; *shMin = min;
  800171:	83 ec 04             	sub    $0x4,%esp
  800174:	6a 00                	push   $0x0
  800176:	6a 04                	push   $0x4
  800178:	68 d2 36 80 00       	push   $0x8036d2
  80017d:	e8 3e 16 00 00       	call   8017c0 <smalloc>
  800182:	83 c4 10             	add    $0x10,%esp
  800185:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800188:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80018b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80018e:	89 10                	mov    %edx,(%eax)
	shMax = smalloc("max", sizeof(int), 0) ; *shMax = max;
  800190:	83 ec 04             	sub    $0x4,%esp
  800193:	6a 00                	push   $0x0
  800195:	6a 04                	push   $0x4
  800197:	68 d6 36 80 00       	push   $0x8036d6
  80019c:	e8 1f 16 00 00       	call   8017c0 <smalloc>
  8001a1:	83 c4 10             	add    $0x10,%esp
  8001a4:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8001a7:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8001aa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001ad:	89 10                	mov    %edx,(%eax)
	shMed = smalloc("med", sizeof(int), 0) ; *shMed = med;
  8001af:	83 ec 04             	sub    $0x4,%esp
  8001b2:	6a 00                	push   $0x0
  8001b4:	6a 04                	push   $0x4
  8001b6:	68 da 36 80 00       	push   $0x8036da
  8001bb:	e8 00 16 00 00       	call   8017c0 <smalloc>
  8001c0:	83 c4 10             	add    $0x10,%esp
  8001c3:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8001c6:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  8001c9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8001cc:	89 10                	mov    %edx,(%eax)

	(*finishedCount)++ ;
  8001ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001d1:	8b 00                	mov    (%eax),%eax
  8001d3:	8d 50 01             	lea    0x1(%eax),%edx
  8001d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001d9:	89 10                	mov    %edx,(%eax)

}
  8001db:	90                   	nop
  8001dc:	c9                   	leave  
  8001dd:	c3                   	ret    

008001de <KthElement>:



///Kth Element
int KthElement(int *Elements, int NumOfElements, int k)
{
  8001de:	55                   	push   %ebp
  8001df:	89 e5                	mov    %esp,%ebp
  8001e1:	83 ec 08             	sub    $0x8,%esp
	return QSort(Elements, NumOfElements, 0, NumOfElements-1, k-1) ;
  8001e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8001e7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8001ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ed:	48                   	dec    %eax
  8001ee:	83 ec 0c             	sub    $0xc,%esp
  8001f1:	52                   	push   %edx
  8001f2:	50                   	push   %eax
  8001f3:	6a 00                	push   $0x0
  8001f5:	ff 75 0c             	pushl  0xc(%ebp)
  8001f8:	ff 75 08             	pushl  0x8(%ebp)
  8001fb:	e8 05 00 00 00       	call   800205 <QSort>
  800200:	83 c4 20             	add    $0x20,%esp
}
  800203:	c9                   	leave  
  800204:	c3                   	ret    

00800205 <QSort>:


int QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex, int kIndex)
{
  800205:	55                   	push   %ebp
  800206:	89 e5                	mov    %esp,%ebp
  800208:	83 ec 28             	sub    $0x28,%esp
	if (startIndex >= finalIndex) return Elements[finalIndex];
  80020b:	8b 45 10             	mov    0x10(%ebp),%eax
  80020e:	3b 45 14             	cmp    0x14(%ebp),%eax
  800211:	7c 16                	jl     800229 <QSort+0x24>
  800213:	8b 45 14             	mov    0x14(%ebp),%eax
  800216:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80021d:	8b 45 08             	mov    0x8(%ebp),%eax
  800220:	01 d0                	add    %edx,%eax
  800222:	8b 00                	mov    (%eax),%eax
  800224:	e9 4a 01 00 00       	jmp    800373 <QSort+0x16e>

	int pvtIndex = RAND(startIndex, finalIndex) ;
  800229:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80022c:	83 ec 0c             	sub    $0xc,%esp
  80022f:	50                   	push   %eax
  800230:	e8 d0 1b 00 00       	call   801e05 <sys_get_virtual_time>
  800235:	83 c4 0c             	add    $0xc,%esp
  800238:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80023b:	8b 55 14             	mov    0x14(%ebp),%edx
  80023e:	2b 55 10             	sub    0x10(%ebp),%edx
  800241:	89 d1                	mov    %edx,%ecx
  800243:	ba 00 00 00 00       	mov    $0x0,%edx
  800248:	f7 f1                	div    %ecx
  80024a:	8b 45 10             	mov    0x10(%ebp),%eax
  80024d:	01 d0                	add    %edx,%eax
  80024f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	Swap(Elements, startIndex, pvtIndex);
  800252:	83 ec 04             	sub    $0x4,%esp
  800255:	ff 75 ec             	pushl  -0x14(%ebp)
  800258:	ff 75 10             	pushl  0x10(%ebp)
  80025b:	ff 75 08             	pushl  0x8(%ebp)
  80025e:	e8 77 02 00 00       	call   8004da <Swap>
  800263:	83 c4 10             	add    $0x10,%esp

	int i = startIndex+1, j = finalIndex;
  800266:	8b 45 10             	mov    0x10(%ebp),%eax
  800269:	40                   	inc    %eax
  80026a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80026d:	8b 45 14             	mov    0x14(%ebp),%eax
  800270:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  800273:	e9 80 00 00 00       	jmp    8002f8 <QSort+0xf3>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800278:	ff 45 f4             	incl   -0xc(%ebp)
  80027b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80027e:	3b 45 14             	cmp    0x14(%ebp),%eax
  800281:	7f 2b                	jg     8002ae <QSort+0xa9>
  800283:	8b 45 10             	mov    0x10(%ebp),%eax
  800286:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80028d:	8b 45 08             	mov    0x8(%ebp),%eax
  800290:	01 d0                	add    %edx,%eax
  800292:	8b 10                	mov    (%eax),%edx
  800294:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800297:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80029e:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a1:	01 c8                	add    %ecx,%eax
  8002a3:	8b 00                	mov    (%eax),%eax
  8002a5:	39 c2                	cmp    %eax,%edx
  8002a7:	7d cf                	jge    800278 <QSort+0x73>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  8002a9:	eb 03                	jmp    8002ae <QSort+0xa9>
  8002ab:	ff 4d f0             	decl   -0x10(%ebp)
  8002ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002b1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8002b4:	7e 26                	jle    8002dc <QSort+0xd7>
  8002b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c3:	01 d0                	add    %edx,%eax
  8002c5:	8b 10                	mov    (%eax),%edx
  8002c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002ca:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d4:	01 c8                	add    %ecx,%eax
  8002d6:	8b 00                	mov    (%eax),%eax
  8002d8:	39 c2                	cmp    %eax,%edx
  8002da:	7e cf                	jle    8002ab <QSort+0xa6>

		if (i <= j)
  8002dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002df:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002e2:	7f 14                	jg     8002f8 <QSort+0xf3>
		{
			Swap(Elements, i, j);
  8002e4:	83 ec 04             	sub    $0x4,%esp
  8002e7:	ff 75 f0             	pushl  -0x10(%ebp)
  8002ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8002ed:	ff 75 08             	pushl  0x8(%ebp)
  8002f0:	e8 e5 01 00 00       	call   8004da <Swap>
  8002f5:	83 c4 10             	add    $0x10,%esp
	int pvtIndex = RAND(startIndex, finalIndex) ;
	Swap(Elements, startIndex, pvtIndex);

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  8002f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002fb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002fe:	0f 8e 77 ff ff ff    	jle    80027b <QSort+0x76>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  800304:	83 ec 04             	sub    $0x4,%esp
  800307:	ff 75 f0             	pushl  -0x10(%ebp)
  80030a:	ff 75 10             	pushl  0x10(%ebp)
  80030d:	ff 75 08             	pushl  0x8(%ebp)
  800310:	e8 c5 01 00 00       	call   8004da <Swap>
  800315:	83 c4 10             	add    $0x10,%esp

	if (kIndex == j)
  800318:	8b 45 18             	mov    0x18(%ebp),%eax
  80031b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80031e:	75 13                	jne    800333 <QSort+0x12e>
		return Elements[kIndex] ;
  800320:	8b 45 18             	mov    0x18(%ebp),%eax
  800323:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80032a:	8b 45 08             	mov    0x8(%ebp),%eax
  80032d:	01 d0                	add    %edx,%eax
  80032f:	8b 00                	mov    (%eax),%eax
  800331:	eb 40                	jmp    800373 <QSort+0x16e>
	else if (kIndex < j)
  800333:	8b 45 18             	mov    0x18(%ebp),%eax
  800336:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800339:	7d 1e                	jge    800359 <QSort+0x154>
		return QSort(Elements, NumOfElements, startIndex, j - 1, kIndex);
  80033b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80033e:	48                   	dec    %eax
  80033f:	83 ec 0c             	sub    $0xc,%esp
  800342:	ff 75 18             	pushl  0x18(%ebp)
  800345:	50                   	push   %eax
  800346:	ff 75 10             	pushl  0x10(%ebp)
  800349:	ff 75 0c             	pushl  0xc(%ebp)
  80034c:	ff 75 08             	pushl  0x8(%ebp)
  80034f:	e8 b1 fe ff ff       	call   800205 <QSort>
  800354:	83 c4 20             	add    $0x20,%esp
  800357:	eb 1a                	jmp    800373 <QSort+0x16e>
	else
		return QSort(Elements, NumOfElements, i, finalIndex, kIndex);
  800359:	83 ec 0c             	sub    $0xc,%esp
  80035c:	ff 75 18             	pushl  0x18(%ebp)
  80035f:	ff 75 14             	pushl  0x14(%ebp)
  800362:	ff 75 f4             	pushl  -0xc(%ebp)
  800365:	ff 75 0c             	pushl  0xc(%ebp)
  800368:	ff 75 08             	pushl  0x8(%ebp)
  80036b:	e8 95 fe ff ff       	call   800205 <QSort>
  800370:	83 c4 20             	add    $0x20,%esp
}
  800373:	c9                   	leave  
  800374:	c3                   	ret    

00800375 <ArrayStats>:

void ArrayStats(int *Elements, int NumOfElements, int *mean, int *var, int *min, int *max, int *med)
{
  800375:	55                   	push   %ebp
  800376:	89 e5                	mov    %esp,%ebp
  800378:	53                   	push   %ebx
  800379:	83 ec 14             	sub    $0x14,%esp
	int i ;
	*mean =0 ;
  80037c:	8b 45 10             	mov    0x10(%ebp),%eax
  80037f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*min = 0x7FFFFFFF ;
  800385:	8b 45 18             	mov    0x18(%ebp),%eax
  800388:	c7 00 ff ff ff 7f    	movl   $0x7fffffff,(%eax)
	*max = 0x80000000 ;
  80038e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800391:	c7 00 00 00 00 80    	movl   $0x80000000,(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  800397:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80039e:	e9 80 00 00 00       	jmp    800423 <ArrayStats+0xae>
	{
		(*mean) += Elements[i];
  8003a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8003a6:	8b 10                	mov    (%eax),%edx
  8003a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003ab:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b5:	01 c8                	add    %ecx,%eax
  8003b7:	8b 00                	mov    (%eax),%eax
  8003b9:	01 c2                	add    %eax,%edx
  8003bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8003be:	89 10                	mov    %edx,(%eax)
		if (Elements[i] < (*min))
  8003c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8003cd:	01 d0                	add    %edx,%eax
  8003cf:	8b 10                	mov    (%eax),%edx
  8003d1:	8b 45 18             	mov    0x18(%ebp),%eax
  8003d4:	8b 00                	mov    (%eax),%eax
  8003d6:	39 c2                	cmp    %eax,%edx
  8003d8:	7d 16                	jge    8003f0 <ArrayStats+0x7b>
		{
			(*min) = Elements[i];
  8003da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e7:	01 d0                	add    %edx,%eax
  8003e9:	8b 10                	mov    (%eax),%edx
  8003eb:	8b 45 18             	mov    0x18(%ebp),%eax
  8003ee:	89 10                	mov    %edx,(%eax)
		}
		if (Elements[i] > (*max))
  8003f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003f3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fd:	01 d0                	add    %edx,%eax
  8003ff:	8b 10                	mov    (%eax),%edx
  800401:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800404:	8b 00                	mov    (%eax),%eax
  800406:	39 c2                	cmp    %eax,%edx
  800408:	7e 16                	jle    800420 <ArrayStats+0xab>
		{
			(*max) = Elements[i];
  80040a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80040d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800414:	8b 45 08             	mov    0x8(%ebp),%eax
  800417:	01 d0                	add    %edx,%eax
  800419:	8b 10                	mov    (%eax),%edx
  80041b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80041e:	89 10                	mov    %edx,(%eax)
{
	int i ;
	*mean =0 ;
	*min = 0x7FFFFFFF ;
	*max = 0x80000000 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800420:	ff 45 f4             	incl   -0xc(%ebp)
  800423:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800426:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800429:	0f 8c 74 ff ff ff    	jl     8003a3 <ArrayStats+0x2e>
		{
			(*max) = Elements[i];
		}
	}

	(*med) = KthElement(Elements, NumOfElements, NumOfElements/2);
  80042f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800432:	89 c2                	mov    %eax,%edx
  800434:	c1 ea 1f             	shr    $0x1f,%edx
  800437:	01 d0                	add    %edx,%eax
  800439:	d1 f8                	sar    %eax
  80043b:	83 ec 04             	sub    $0x4,%esp
  80043e:	50                   	push   %eax
  80043f:	ff 75 0c             	pushl  0xc(%ebp)
  800442:	ff 75 08             	pushl  0x8(%ebp)
  800445:	e8 94 fd ff ff       	call   8001de <KthElement>
  80044a:	83 c4 10             	add    $0x10,%esp
  80044d:	89 c2                	mov    %eax,%edx
  80044f:	8b 45 20             	mov    0x20(%ebp),%eax
  800452:	89 10                	mov    %edx,(%eax)

	(*mean) /= NumOfElements;
  800454:	8b 45 10             	mov    0x10(%ebp),%eax
  800457:	8b 00                	mov    (%eax),%eax
  800459:	99                   	cltd   
  80045a:	f7 7d 0c             	idivl  0xc(%ebp)
  80045d:	89 c2                	mov    %eax,%edx
  80045f:	8b 45 10             	mov    0x10(%ebp),%eax
  800462:	89 10                	mov    %edx,(%eax)
	(*var) = 0;
  800464:	8b 45 14             	mov    0x14(%ebp),%eax
  800467:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  80046d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800474:	eb 46                	jmp    8004bc <ArrayStats+0x147>
	{
		(*var) += (Elements[i] - (*mean))*(Elements[i] - (*mean));
  800476:	8b 45 14             	mov    0x14(%ebp),%eax
  800479:	8b 10                	mov    (%eax),%edx
  80047b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80047e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800485:	8b 45 08             	mov    0x8(%ebp),%eax
  800488:	01 c8                	add    %ecx,%eax
  80048a:	8b 08                	mov    (%eax),%ecx
  80048c:	8b 45 10             	mov    0x10(%ebp),%eax
  80048f:	8b 00                	mov    (%eax),%eax
  800491:	89 cb                	mov    %ecx,%ebx
  800493:	29 c3                	sub    %eax,%ebx
  800495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800498:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80049f:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a2:	01 c8                	add    %ecx,%eax
  8004a4:	8b 08                	mov    (%eax),%ecx
  8004a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8004a9:	8b 00                	mov    (%eax),%eax
  8004ab:	29 c1                	sub    %eax,%ecx
  8004ad:	89 c8                	mov    %ecx,%eax
  8004af:	0f af c3             	imul   %ebx,%eax
  8004b2:	01 c2                	add    %eax,%edx
  8004b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b7:	89 10                	mov    %edx,(%eax)

	(*med) = KthElement(Elements, NumOfElements, NumOfElements/2);

	(*mean) /= NumOfElements;
	(*var) = 0;
	for (i = 0 ; i < NumOfElements ; i++)
  8004b9:	ff 45 f4             	incl   -0xc(%ebp)
  8004bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004bf:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004c2:	7c b2                	jl     800476 <ArrayStats+0x101>
	{
		(*var) += (Elements[i] - (*mean))*(Elements[i] - (*mean));
	}
	(*var) /= NumOfElements;
  8004c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c7:	8b 00                	mov    (%eax),%eax
  8004c9:	99                   	cltd   
  8004ca:	f7 7d 0c             	idivl  0xc(%ebp)
  8004cd:	89 c2                	mov    %eax,%edx
  8004cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d2:	89 10                	mov    %edx,(%eax)
}
  8004d4:	90                   	nop
  8004d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004d8:	c9                   	leave  
  8004d9:	c3                   	ret    

008004da <Swap>:

///Private Functions
void Swap(int *Elements, int First, int Second)
{
  8004da:	55                   	push   %ebp
  8004db:	89 e5                	mov    %esp,%ebp
  8004dd:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  8004e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ed:	01 d0                	add    %edx,%eax
  8004ef:	8b 00                	mov    (%eax),%eax
  8004f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  8004f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800501:	01 c2                	add    %eax,%edx
  800503:	8b 45 10             	mov    0x10(%ebp),%eax
  800506:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80050d:	8b 45 08             	mov    0x8(%ebp),%eax
  800510:	01 c8                	add    %ecx,%eax
  800512:	8b 00                	mov    (%eax),%eax
  800514:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800516:	8b 45 10             	mov    0x10(%ebp),%eax
  800519:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800520:	8b 45 08             	mov    0x8(%ebp),%eax
  800523:	01 c2                	add    %eax,%edx
  800525:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800528:	89 02                	mov    %eax,(%edx)
}
  80052a:	90                   	nop
  80052b:	c9                   	leave  
  80052c:	c3                   	ret    

0080052d <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80052d:	55                   	push   %ebp
  80052e:	89 e5                	mov    %esp,%ebp
  800530:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800533:	e8 81 18 00 00       	call   801db9 <sys_getenvindex>
  800538:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80053b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80053e:	89 d0                	mov    %edx,%eax
  800540:	c1 e0 03             	shl    $0x3,%eax
  800543:	01 d0                	add    %edx,%eax
  800545:	01 c0                	add    %eax,%eax
  800547:	01 d0                	add    %edx,%eax
  800549:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800550:	01 d0                	add    %edx,%eax
  800552:	c1 e0 04             	shl    $0x4,%eax
  800555:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80055a:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80055f:	a1 20 40 80 00       	mov    0x804020,%eax
  800564:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80056a:	84 c0                	test   %al,%al
  80056c:	74 0f                	je     80057d <libmain+0x50>
		binaryname = myEnv->prog_name;
  80056e:	a1 20 40 80 00       	mov    0x804020,%eax
  800573:	05 5c 05 00 00       	add    $0x55c,%eax
  800578:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80057d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800581:	7e 0a                	jle    80058d <libmain+0x60>
		binaryname = argv[0];
  800583:	8b 45 0c             	mov    0xc(%ebp),%eax
  800586:	8b 00                	mov    (%eax),%eax
  800588:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  80058d:	83 ec 08             	sub    $0x8,%esp
  800590:	ff 75 0c             	pushl  0xc(%ebp)
  800593:	ff 75 08             	pushl  0x8(%ebp)
  800596:	e8 9d fa ff ff       	call   800038 <_main>
  80059b:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80059e:	e8 23 16 00 00       	call   801bc6 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8005a3:	83 ec 0c             	sub    $0xc,%esp
  8005a6:	68 f8 36 80 00       	push   $0x8036f8
  8005ab:	e8 8d 01 00 00       	call   80073d <cprintf>
  8005b0:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8005b3:	a1 20 40 80 00       	mov    0x804020,%eax
  8005b8:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8005be:	a1 20 40 80 00       	mov    0x804020,%eax
  8005c3:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8005c9:	83 ec 04             	sub    $0x4,%esp
  8005cc:	52                   	push   %edx
  8005cd:	50                   	push   %eax
  8005ce:	68 20 37 80 00       	push   $0x803720
  8005d3:	e8 65 01 00 00       	call   80073d <cprintf>
  8005d8:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8005db:	a1 20 40 80 00       	mov    0x804020,%eax
  8005e0:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8005e6:	a1 20 40 80 00       	mov    0x804020,%eax
  8005eb:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8005f1:	a1 20 40 80 00       	mov    0x804020,%eax
  8005f6:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8005fc:	51                   	push   %ecx
  8005fd:	52                   	push   %edx
  8005fe:	50                   	push   %eax
  8005ff:	68 48 37 80 00       	push   $0x803748
  800604:	e8 34 01 00 00       	call   80073d <cprintf>
  800609:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80060c:	a1 20 40 80 00       	mov    0x804020,%eax
  800611:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800617:	83 ec 08             	sub    $0x8,%esp
  80061a:	50                   	push   %eax
  80061b:	68 a0 37 80 00       	push   $0x8037a0
  800620:	e8 18 01 00 00       	call   80073d <cprintf>
  800625:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800628:	83 ec 0c             	sub    $0xc,%esp
  80062b:	68 f8 36 80 00       	push   $0x8036f8
  800630:	e8 08 01 00 00       	call   80073d <cprintf>
  800635:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800638:	e8 a3 15 00 00       	call   801be0 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80063d:	e8 19 00 00 00       	call   80065b <exit>
}
  800642:	90                   	nop
  800643:	c9                   	leave  
  800644:	c3                   	ret    

00800645 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800645:	55                   	push   %ebp
  800646:	89 e5                	mov    %esp,%ebp
  800648:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80064b:	83 ec 0c             	sub    $0xc,%esp
  80064e:	6a 00                	push   $0x0
  800650:	e8 30 17 00 00       	call   801d85 <sys_destroy_env>
  800655:	83 c4 10             	add    $0x10,%esp
}
  800658:	90                   	nop
  800659:	c9                   	leave  
  80065a:	c3                   	ret    

0080065b <exit>:

void
exit(void)
{
  80065b:	55                   	push   %ebp
  80065c:	89 e5                	mov    %esp,%ebp
  80065e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800661:	e8 85 17 00 00       	call   801deb <sys_exit_env>
}
  800666:	90                   	nop
  800667:	c9                   	leave  
  800668:	c3                   	ret    

00800669 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800669:	55                   	push   %ebp
  80066a:	89 e5                	mov    %esp,%ebp
  80066c:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80066f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800672:	8b 00                	mov    (%eax),%eax
  800674:	8d 48 01             	lea    0x1(%eax),%ecx
  800677:	8b 55 0c             	mov    0xc(%ebp),%edx
  80067a:	89 0a                	mov    %ecx,(%edx)
  80067c:	8b 55 08             	mov    0x8(%ebp),%edx
  80067f:	88 d1                	mov    %dl,%cl
  800681:	8b 55 0c             	mov    0xc(%ebp),%edx
  800684:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800688:	8b 45 0c             	mov    0xc(%ebp),%eax
  80068b:	8b 00                	mov    (%eax),%eax
  80068d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800692:	75 2c                	jne    8006c0 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800694:	a0 24 40 80 00       	mov    0x804024,%al
  800699:	0f b6 c0             	movzbl %al,%eax
  80069c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80069f:	8b 12                	mov    (%edx),%edx
  8006a1:	89 d1                	mov    %edx,%ecx
  8006a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006a6:	83 c2 08             	add    $0x8,%edx
  8006a9:	83 ec 04             	sub    $0x4,%esp
  8006ac:	50                   	push   %eax
  8006ad:	51                   	push   %ecx
  8006ae:	52                   	push   %edx
  8006af:	e8 64 13 00 00       	call   801a18 <sys_cputs>
  8006b4:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c3:	8b 40 04             	mov    0x4(%eax),%eax
  8006c6:	8d 50 01             	lea    0x1(%eax),%edx
  8006c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006cc:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006cf:	90                   	nop
  8006d0:	c9                   	leave  
  8006d1:	c3                   	ret    

008006d2 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006d2:	55                   	push   %ebp
  8006d3:	89 e5                	mov    %esp,%ebp
  8006d5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006db:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006e2:	00 00 00 
	b.cnt = 0;
  8006e5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006ec:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006ef:	ff 75 0c             	pushl  0xc(%ebp)
  8006f2:	ff 75 08             	pushl  0x8(%ebp)
  8006f5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006fb:	50                   	push   %eax
  8006fc:	68 69 06 80 00       	push   $0x800669
  800701:	e8 11 02 00 00       	call   800917 <vprintfmt>
  800706:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800709:	a0 24 40 80 00       	mov    0x804024,%al
  80070e:	0f b6 c0             	movzbl %al,%eax
  800711:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800717:	83 ec 04             	sub    $0x4,%esp
  80071a:	50                   	push   %eax
  80071b:	52                   	push   %edx
  80071c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800722:	83 c0 08             	add    $0x8,%eax
  800725:	50                   	push   %eax
  800726:	e8 ed 12 00 00       	call   801a18 <sys_cputs>
  80072b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80072e:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800735:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80073b:	c9                   	leave  
  80073c:	c3                   	ret    

0080073d <cprintf>:

int cprintf(const char *fmt, ...) {
  80073d:	55                   	push   %ebp
  80073e:	89 e5                	mov    %esp,%ebp
  800740:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800743:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80074a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80074d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800750:	8b 45 08             	mov    0x8(%ebp),%eax
  800753:	83 ec 08             	sub    $0x8,%esp
  800756:	ff 75 f4             	pushl  -0xc(%ebp)
  800759:	50                   	push   %eax
  80075a:	e8 73 ff ff ff       	call   8006d2 <vcprintf>
  80075f:	83 c4 10             	add    $0x10,%esp
  800762:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800765:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800768:	c9                   	leave  
  800769:	c3                   	ret    

0080076a <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80076a:	55                   	push   %ebp
  80076b:	89 e5                	mov    %esp,%ebp
  80076d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800770:	e8 51 14 00 00       	call   801bc6 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800775:	8d 45 0c             	lea    0xc(%ebp),%eax
  800778:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80077b:	8b 45 08             	mov    0x8(%ebp),%eax
  80077e:	83 ec 08             	sub    $0x8,%esp
  800781:	ff 75 f4             	pushl  -0xc(%ebp)
  800784:	50                   	push   %eax
  800785:	e8 48 ff ff ff       	call   8006d2 <vcprintf>
  80078a:	83 c4 10             	add    $0x10,%esp
  80078d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800790:	e8 4b 14 00 00       	call   801be0 <sys_enable_interrupt>
	return cnt;
  800795:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800798:	c9                   	leave  
  800799:	c3                   	ret    

0080079a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80079a:	55                   	push   %ebp
  80079b:	89 e5                	mov    %esp,%ebp
  80079d:	53                   	push   %ebx
  80079e:	83 ec 14             	sub    $0x14,%esp
  8007a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007ad:	8b 45 18             	mov    0x18(%ebp),%eax
  8007b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007b8:	77 55                	ja     80080f <printnum+0x75>
  8007ba:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007bd:	72 05                	jb     8007c4 <printnum+0x2a>
  8007bf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007c2:	77 4b                	ja     80080f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007c4:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007c7:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007ca:	8b 45 18             	mov    0x18(%ebp),%eax
  8007cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d2:	52                   	push   %edx
  8007d3:	50                   	push   %eax
  8007d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8007d7:	ff 75 f0             	pushl  -0x10(%ebp)
  8007da:	e8 29 2c 00 00       	call   803408 <__udivdi3>
  8007df:	83 c4 10             	add    $0x10,%esp
  8007e2:	83 ec 04             	sub    $0x4,%esp
  8007e5:	ff 75 20             	pushl  0x20(%ebp)
  8007e8:	53                   	push   %ebx
  8007e9:	ff 75 18             	pushl  0x18(%ebp)
  8007ec:	52                   	push   %edx
  8007ed:	50                   	push   %eax
  8007ee:	ff 75 0c             	pushl  0xc(%ebp)
  8007f1:	ff 75 08             	pushl  0x8(%ebp)
  8007f4:	e8 a1 ff ff ff       	call   80079a <printnum>
  8007f9:	83 c4 20             	add    $0x20,%esp
  8007fc:	eb 1a                	jmp    800818 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007fe:	83 ec 08             	sub    $0x8,%esp
  800801:	ff 75 0c             	pushl  0xc(%ebp)
  800804:	ff 75 20             	pushl  0x20(%ebp)
  800807:	8b 45 08             	mov    0x8(%ebp),%eax
  80080a:	ff d0                	call   *%eax
  80080c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80080f:	ff 4d 1c             	decl   0x1c(%ebp)
  800812:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800816:	7f e6                	jg     8007fe <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800818:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80081b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800820:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800823:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800826:	53                   	push   %ebx
  800827:	51                   	push   %ecx
  800828:	52                   	push   %edx
  800829:	50                   	push   %eax
  80082a:	e8 e9 2c 00 00       	call   803518 <__umoddi3>
  80082f:	83 c4 10             	add    $0x10,%esp
  800832:	05 d4 39 80 00       	add    $0x8039d4,%eax
  800837:	8a 00                	mov    (%eax),%al
  800839:	0f be c0             	movsbl %al,%eax
  80083c:	83 ec 08             	sub    $0x8,%esp
  80083f:	ff 75 0c             	pushl  0xc(%ebp)
  800842:	50                   	push   %eax
  800843:	8b 45 08             	mov    0x8(%ebp),%eax
  800846:	ff d0                	call   *%eax
  800848:	83 c4 10             	add    $0x10,%esp
}
  80084b:	90                   	nop
  80084c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80084f:	c9                   	leave  
  800850:	c3                   	ret    

00800851 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800851:	55                   	push   %ebp
  800852:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800854:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800858:	7e 1c                	jle    800876 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80085a:	8b 45 08             	mov    0x8(%ebp),%eax
  80085d:	8b 00                	mov    (%eax),%eax
  80085f:	8d 50 08             	lea    0x8(%eax),%edx
  800862:	8b 45 08             	mov    0x8(%ebp),%eax
  800865:	89 10                	mov    %edx,(%eax)
  800867:	8b 45 08             	mov    0x8(%ebp),%eax
  80086a:	8b 00                	mov    (%eax),%eax
  80086c:	83 e8 08             	sub    $0x8,%eax
  80086f:	8b 50 04             	mov    0x4(%eax),%edx
  800872:	8b 00                	mov    (%eax),%eax
  800874:	eb 40                	jmp    8008b6 <getuint+0x65>
	else if (lflag)
  800876:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80087a:	74 1e                	je     80089a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80087c:	8b 45 08             	mov    0x8(%ebp),%eax
  80087f:	8b 00                	mov    (%eax),%eax
  800881:	8d 50 04             	lea    0x4(%eax),%edx
  800884:	8b 45 08             	mov    0x8(%ebp),%eax
  800887:	89 10                	mov    %edx,(%eax)
  800889:	8b 45 08             	mov    0x8(%ebp),%eax
  80088c:	8b 00                	mov    (%eax),%eax
  80088e:	83 e8 04             	sub    $0x4,%eax
  800891:	8b 00                	mov    (%eax),%eax
  800893:	ba 00 00 00 00       	mov    $0x0,%edx
  800898:	eb 1c                	jmp    8008b6 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80089a:	8b 45 08             	mov    0x8(%ebp),%eax
  80089d:	8b 00                	mov    (%eax),%eax
  80089f:	8d 50 04             	lea    0x4(%eax),%edx
  8008a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a5:	89 10                	mov    %edx,(%eax)
  8008a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008aa:	8b 00                	mov    (%eax),%eax
  8008ac:	83 e8 04             	sub    $0x4,%eax
  8008af:	8b 00                	mov    (%eax),%eax
  8008b1:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008b6:	5d                   	pop    %ebp
  8008b7:	c3                   	ret    

008008b8 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008b8:	55                   	push   %ebp
  8008b9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008bb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008bf:	7e 1c                	jle    8008dd <getint+0x25>
		return va_arg(*ap, long long);
  8008c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c4:	8b 00                	mov    (%eax),%eax
  8008c6:	8d 50 08             	lea    0x8(%eax),%edx
  8008c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cc:	89 10                	mov    %edx,(%eax)
  8008ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d1:	8b 00                	mov    (%eax),%eax
  8008d3:	83 e8 08             	sub    $0x8,%eax
  8008d6:	8b 50 04             	mov    0x4(%eax),%edx
  8008d9:	8b 00                	mov    (%eax),%eax
  8008db:	eb 38                	jmp    800915 <getint+0x5d>
	else if (lflag)
  8008dd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008e1:	74 1a                	je     8008fd <getint+0x45>
		return va_arg(*ap, long);
  8008e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e6:	8b 00                	mov    (%eax),%eax
  8008e8:	8d 50 04             	lea    0x4(%eax),%edx
  8008eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ee:	89 10                	mov    %edx,(%eax)
  8008f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f3:	8b 00                	mov    (%eax),%eax
  8008f5:	83 e8 04             	sub    $0x4,%eax
  8008f8:	8b 00                	mov    (%eax),%eax
  8008fa:	99                   	cltd   
  8008fb:	eb 18                	jmp    800915 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8008fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800900:	8b 00                	mov    (%eax),%eax
  800902:	8d 50 04             	lea    0x4(%eax),%edx
  800905:	8b 45 08             	mov    0x8(%ebp),%eax
  800908:	89 10                	mov    %edx,(%eax)
  80090a:	8b 45 08             	mov    0x8(%ebp),%eax
  80090d:	8b 00                	mov    (%eax),%eax
  80090f:	83 e8 04             	sub    $0x4,%eax
  800912:	8b 00                	mov    (%eax),%eax
  800914:	99                   	cltd   
}
  800915:	5d                   	pop    %ebp
  800916:	c3                   	ret    

00800917 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800917:	55                   	push   %ebp
  800918:	89 e5                	mov    %esp,%ebp
  80091a:	56                   	push   %esi
  80091b:	53                   	push   %ebx
  80091c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80091f:	eb 17                	jmp    800938 <vprintfmt+0x21>
			if (ch == '\0')
  800921:	85 db                	test   %ebx,%ebx
  800923:	0f 84 af 03 00 00    	je     800cd8 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800929:	83 ec 08             	sub    $0x8,%esp
  80092c:	ff 75 0c             	pushl  0xc(%ebp)
  80092f:	53                   	push   %ebx
  800930:	8b 45 08             	mov    0x8(%ebp),%eax
  800933:	ff d0                	call   *%eax
  800935:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800938:	8b 45 10             	mov    0x10(%ebp),%eax
  80093b:	8d 50 01             	lea    0x1(%eax),%edx
  80093e:	89 55 10             	mov    %edx,0x10(%ebp)
  800941:	8a 00                	mov    (%eax),%al
  800943:	0f b6 d8             	movzbl %al,%ebx
  800946:	83 fb 25             	cmp    $0x25,%ebx
  800949:	75 d6                	jne    800921 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80094b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80094f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800956:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80095d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800964:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80096b:	8b 45 10             	mov    0x10(%ebp),%eax
  80096e:	8d 50 01             	lea    0x1(%eax),%edx
  800971:	89 55 10             	mov    %edx,0x10(%ebp)
  800974:	8a 00                	mov    (%eax),%al
  800976:	0f b6 d8             	movzbl %al,%ebx
  800979:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80097c:	83 f8 55             	cmp    $0x55,%eax
  80097f:	0f 87 2b 03 00 00    	ja     800cb0 <vprintfmt+0x399>
  800985:	8b 04 85 f8 39 80 00 	mov    0x8039f8(,%eax,4),%eax
  80098c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80098e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800992:	eb d7                	jmp    80096b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800994:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800998:	eb d1                	jmp    80096b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80099a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009a1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009a4:	89 d0                	mov    %edx,%eax
  8009a6:	c1 e0 02             	shl    $0x2,%eax
  8009a9:	01 d0                	add    %edx,%eax
  8009ab:	01 c0                	add    %eax,%eax
  8009ad:	01 d8                	add    %ebx,%eax
  8009af:	83 e8 30             	sub    $0x30,%eax
  8009b2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b8:	8a 00                	mov    (%eax),%al
  8009ba:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009bd:	83 fb 2f             	cmp    $0x2f,%ebx
  8009c0:	7e 3e                	jle    800a00 <vprintfmt+0xe9>
  8009c2:	83 fb 39             	cmp    $0x39,%ebx
  8009c5:	7f 39                	jg     800a00 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009c7:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009ca:	eb d5                	jmp    8009a1 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8009cf:	83 c0 04             	add    $0x4,%eax
  8009d2:	89 45 14             	mov    %eax,0x14(%ebp)
  8009d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d8:	83 e8 04             	sub    $0x4,%eax
  8009db:	8b 00                	mov    (%eax),%eax
  8009dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009e0:	eb 1f                	jmp    800a01 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8009e2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009e6:	79 83                	jns    80096b <vprintfmt+0x54>
				width = 0;
  8009e8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8009ef:	e9 77 ff ff ff       	jmp    80096b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8009f4:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8009fb:	e9 6b ff ff ff       	jmp    80096b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a00:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a01:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a05:	0f 89 60 ff ff ff    	jns    80096b <vprintfmt+0x54>
				width = precision, precision = -1;
  800a0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a0e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a11:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a18:	e9 4e ff ff ff       	jmp    80096b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a1d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a20:	e9 46 ff ff ff       	jmp    80096b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a25:	8b 45 14             	mov    0x14(%ebp),%eax
  800a28:	83 c0 04             	add    $0x4,%eax
  800a2b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a2e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a31:	83 e8 04             	sub    $0x4,%eax
  800a34:	8b 00                	mov    (%eax),%eax
  800a36:	83 ec 08             	sub    $0x8,%esp
  800a39:	ff 75 0c             	pushl  0xc(%ebp)
  800a3c:	50                   	push   %eax
  800a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a40:	ff d0                	call   *%eax
  800a42:	83 c4 10             	add    $0x10,%esp
			break;
  800a45:	e9 89 02 00 00       	jmp    800cd3 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a4a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4d:	83 c0 04             	add    $0x4,%eax
  800a50:	89 45 14             	mov    %eax,0x14(%ebp)
  800a53:	8b 45 14             	mov    0x14(%ebp),%eax
  800a56:	83 e8 04             	sub    $0x4,%eax
  800a59:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a5b:	85 db                	test   %ebx,%ebx
  800a5d:	79 02                	jns    800a61 <vprintfmt+0x14a>
				err = -err;
  800a5f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a61:	83 fb 64             	cmp    $0x64,%ebx
  800a64:	7f 0b                	jg     800a71 <vprintfmt+0x15a>
  800a66:	8b 34 9d 40 38 80 00 	mov    0x803840(,%ebx,4),%esi
  800a6d:	85 f6                	test   %esi,%esi
  800a6f:	75 19                	jne    800a8a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a71:	53                   	push   %ebx
  800a72:	68 e5 39 80 00       	push   $0x8039e5
  800a77:	ff 75 0c             	pushl  0xc(%ebp)
  800a7a:	ff 75 08             	pushl  0x8(%ebp)
  800a7d:	e8 5e 02 00 00       	call   800ce0 <printfmt>
  800a82:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a85:	e9 49 02 00 00       	jmp    800cd3 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a8a:	56                   	push   %esi
  800a8b:	68 ee 39 80 00       	push   $0x8039ee
  800a90:	ff 75 0c             	pushl  0xc(%ebp)
  800a93:	ff 75 08             	pushl  0x8(%ebp)
  800a96:	e8 45 02 00 00       	call   800ce0 <printfmt>
  800a9b:	83 c4 10             	add    $0x10,%esp
			break;
  800a9e:	e9 30 02 00 00       	jmp    800cd3 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800aa3:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa6:	83 c0 04             	add    $0x4,%eax
  800aa9:	89 45 14             	mov    %eax,0x14(%ebp)
  800aac:	8b 45 14             	mov    0x14(%ebp),%eax
  800aaf:	83 e8 04             	sub    $0x4,%eax
  800ab2:	8b 30                	mov    (%eax),%esi
  800ab4:	85 f6                	test   %esi,%esi
  800ab6:	75 05                	jne    800abd <vprintfmt+0x1a6>
				p = "(null)";
  800ab8:	be f1 39 80 00       	mov    $0x8039f1,%esi
			if (width > 0 && padc != '-')
  800abd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ac1:	7e 6d                	jle    800b30 <vprintfmt+0x219>
  800ac3:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ac7:	74 67                	je     800b30 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ac9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800acc:	83 ec 08             	sub    $0x8,%esp
  800acf:	50                   	push   %eax
  800ad0:	56                   	push   %esi
  800ad1:	e8 0c 03 00 00       	call   800de2 <strnlen>
  800ad6:	83 c4 10             	add    $0x10,%esp
  800ad9:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800adc:	eb 16                	jmp    800af4 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ade:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ae2:	83 ec 08             	sub    $0x8,%esp
  800ae5:	ff 75 0c             	pushl  0xc(%ebp)
  800ae8:	50                   	push   %eax
  800ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aec:	ff d0                	call   *%eax
  800aee:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800af1:	ff 4d e4             	decl   -0x1c(%ebp)
  800af4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800af8:	7f e4                	jg     800ade <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800afa:	eb 34                	jmp    800b30 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800afc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b00:	74 1c                	je     800b1e <vprintfmt+0x207>
  800b02:	83 fb 1f             	cmp    $0x1f,%ebx
  800b05:	7e 05                	jle    800b0c <vprintfmt+0x1f5>
  800b07:	83 fb 7e             	cmp    $0x7e,%ebx
  800b0a:	7e 12                	jle    800b1e <vprintfmt+0x207>
					putch('?', putdat);
  800b0c:	83 ec 08             	sub    $0x8,%esp
  800b0f:	ff 75 0c             	pushl  0xc(%ebp)
  800b12:	6a 3f                	push   $0x3f
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	ff d0                	call   *%eax
  800b19:	83 c4 10             	add    $0x10,%esp
  800b1c:	eb 0f                	jmp    800b2d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b1e:	83 ec 08             	sub    $0x8,%esp
  800b21:	ff 75 0c             	pushl  0xc(%ebp)
  800b24:	53                   	push   %ebx
  800b25:	8b 45 08             	mov    0x8(%ebp),%eax
  800b28:	ff d0                	call   *%eax
  800b2a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b2d:	ff 4d e4             	decl   -0x1c(%ebp)
  800b30:	89 f0                	mov    %esi,%eax
  800b32:	8d 70 01             	lea    0x1(%eax),%esi
  800b35:	8a 00                	mov    (%eax),%al
  800b37:	0f be d8             	movsbl %al,%ebx
  800b3a:	85 db                	test   %ebx,%ebx
  800b3c:	74 24                	je     800b62 <vprintfmt+0x24b>
  800b3e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b42:	78 b8                	js     800afc <vprintfmt+0x1e5>
  800b44:	ff 4d e0             	decl   -0x20(%ebp)
  800b47:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b4b:	79 af                	jns    800afc <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b4d:	eb 13                	jmp    800b62 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b4f:	83 ec 08             	sub    $0x8,%esp
  800b52:	ff 75 0c             	pushl  0xc(%ebp)
  800b55:	6a 20                	push   $0x20
  800b57:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5a:	ff d0                	call   *%eax
  800b5c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b5f:	ff 4d e4             	decl   -0x1c(%ebp)
  800b62:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b66:	7f e7                	jg     800b4f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b68:	e9 66 01 00 00       	jmp    800cd3 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b6d:	83 ec 08             	sub    $0x8,%esp
  800b70:	ff 75 e8             	pushl  -0x18(%ebp)
  800b73:	8d 45 14             	lea    0x14(%ebp),%eax
  800b76:	50                   	push   %eax
  800b77:	e8 3c fd ff ff       	call   8008b8 <getint>
  800b7c:	83 c4 10             	add    $0x10,%esp
  800b7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b82:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b88:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b8b:	85 d2                	test   %edx,%edx
  800b8d:	79 23                	jns    800bb2 <vprintfmt+0x29b>
				putch('-', putdat);
  800b8f:	83 ec 08             	sub    $0x8,%esp
  800b92:	ff 75 0c             	pushl  0xc(%ebp)
  800b95:	6a 2d                	push   $0x2d
  800b97:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9a:	ff d0                	call   *%eax
  800b9c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ba2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ba5:	f7 d8                	neg    %eax
  800ba7:	83 d2 00             	adc    $0x0,%edx
  800baa:	f7 da                	neg    %edx
  800bac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800baf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bb2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bb9:	e9 bc 00 00 00       	jmp    800c7a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bbe:	83 ec 08             	sub    $0x8,%esp
  800bc1:	ff 75 e8             	pushl  -0x18(%ebp)
  800bc4:	8d 45 14             	lea    0x14(%ebp),%eax
  800bc7:	50                   	push   %eax
  800bc8:	e8 84 fc ff ff       	call   800851 <getuint>
  800bcd:	83 c4 10             	add    $0x10,%esp
  800bd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800bd6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bdd:	e9 98 00 00 00       	jmp    800c7a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800be2:	83 ec 08             	sub    $0x8,%esp
  800be5:	ff 75 0c             	pushl  0xc(%ebp)
  800be8:	6a 58                	push   $0x58
  800bea:	8b 45 08             	mov    0x8(%ebp),%eax
  800bed:	ff d0                	call   *%eax
  800bef:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800bf2:	83 ec 08             	sub    $0x8,%esp
  800bf5:	ff 75 0c             	pushl  0xc(%ebp)
  800bf8:	6a 58                	push   $0x58
  800bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfd:	ff d0                	call   *%eax
  800bff:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c02:	83 ec 08             	sub    $0x8,%esp
  800c05:	ff 75 0c             	pushl  0xc(%ebp)
  800c08:	6a 58                	push   $0x58
  800c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0d:	ff d0                	call   *%eax
  800c0f:	83 c4 10             	add    $0x10,%esp
			break;
  800c12:	e9 bc 00 00 00       	jmp    800cd3 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c17:	83 ec 08             	sub    $0x8,%esp
  800c1a:	ff 75 0c             	pushl  0xc(%ebp)
  800c1d:	6a 30                	push   $0x30
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c22:	ff d0                	call   *%eax
  800c24:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c27:	83 ec 08             	sub    $0x8,%esp
  800c2a:	ff 75 0c             	pushl  0xc(%ebp)
  800c2d:	6a 78                	push   $0x78
  800c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c32:	ff d0                	call   *%eax
  800c34:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c37:	8b 45 14             	mov    0x14(%ebp),%eax
  800c3a:	83 c0 04             	add    $0x4,%eax
  800c3d:	89 45 14             	mov    %eax,0x14(%ebp)
  800c40:	8b 45 14             	mov    0x14(%ebp),%eax
  800c43:	83 e8 04             	sub    $0x4,%eax
  800c46:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c48:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c4b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c52:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c59:	eb 1f                	jmp    800c7a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c5b:	83 ec 08             	sub    $0x8,%esp
  800c5e:	ff 75 e8             	pushl  -0x18(%ebp)
  800c61:	8d 45 14             	lea    0x14(%ebp),%eax
  800c64:	50                   	push   %eax
  800c65:	e8 e7 fb ff ff       	call   800851 <getuint>
  800c6a:	83 c4 10             	add    $0x10,%esp
  800c6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c70:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c73:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c7a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c81:	83 ec 04             	sub    $0x4,%esp
  800c84:	52                   	push   %edx
  800c85:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c88:	50                   	push   %eax
  800c89:	ff 75 f4             	pushl  -0xc(%ebp)
  800c8c:	ff 75 f0             	pushl  -0x10(%ebp)
  800c8f:	ff 75 0c             	pushl  0xc(%ebp)
  800c92:	ff 75 08             	pushl  0x8(%ebp)
  800c95:	e8 00 fb ff ff       	call   80079a <printnum>
  800c9a:	83 c4 20             	add    $0x20,%esp
			break;
  800c9d:	eb 34                	jmp    800cd3 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c9f:	83 ec 08             	sub    $0x8,%esp
  800ca2:	ff 75 0c             	pushl  0xc(%ebp)
  800ca5:	53                   	push   %ebx
  800ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca9:	ff d0                	call   *%eax
  800cab:	83 c4 10             	add    $0x10,%esp
			break;
  800cae:	eb 23                	jmp    800cd3 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cb0:	83 ec 08             	sub    $0x8,%esp
  800cb3:	ff 75 0c             	pushl  0xc(%ebp)
  800cb6:	6a 25                	push   $0x25
  800cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbb:	ff d0                	call   *%eax
  800cbd:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cc0:	ff 4d 10             	decl   0x10(%ebp)
  800cc3:	eb 03                	jmp    800cc8 <vprintfmt+0x3b1>
  800cc5:	ff 4d 10             	decl   0x10(%ebp)
  800cc8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ccb:	48                   	dec    %eax
  800ccc:	8a 00                	mov    (%eax),%al
  800cce:	3c 25                	cmp    $0x25,%al
  800cd0:	75 f3                	jne    800cc5 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800cd2:	90                   	nop
		}
	}
  800cd3:	e9 47 fc ff ff       	jmp    80091f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800cd8:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800cd9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cdc:	5b                   	pop    %ebx
  800cdd:	5e                   	pop    %esi
  800cde:	5d                   	pop    %ebp
  800cdf:	c3                   	ret    

00800ce0 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ce0:	55                   	push   %ebp
  800ce1:	89 e5                	mov    %esp,%ebp
  800ce3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ce6:	8d 45 10             	lea    0x10(%ebp),%eax
  800ce9:	83 c0 04             	add    $0x4,%eax
  800cec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800cef:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf2:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf5:	50                   	push   %eax
  800cf6:	ff 75 0c             	pushl  0xc(%ebp)
  800cf9:	ff 75 08             	pushl  0x8(%ebp)
  800cfc:	e8 16 fc ff ff       	call   800917 <vprintfmt>
  800d01:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d04:	90                   	nop
  800d05:	c9                   	leave  
  800d06:	c3                   	ret    

00800d07 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d07:	55                   	push   %ebp
  800d08:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0d:	8b 40 08             	mov    0x8(%eax),%eax
  800d10:	8d 50 01             	lea    0x1(%eax),%edx
  800d13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d16:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1c:	8b 10                	mov    (%eax),%edx
  800d1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d21:	8b 40 04             	mov    0x4(%eax),%eax
  800d24:	39 c2                	cmp    %eax,%edx
  800d26:	73 12                	jae    800d3a <sprintputch+0x33>
		*b->buf++ = ch;
  800d28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2b:	8b 00                	mov    (%eax),%eax
  800d2d:	8d 48 01             	lea    0x1(%eax),%ecx
  800d30:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d33:	89 0a                	mov    %ecx,(%edx)
  800d35:	8b 55 08             	mov    0x8(%ebp),%edx
  800d38:	88 10                	mov    %dl,(%eax)
}
  800d3a:	90                   	nop
  800d3b:	5d                   	pop    %ebp
  800d3c:	c3                   	ret    

00800d3d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d3d:	55                   	push   %ebp
  800d3e:	89 e5                	mov    %esp,%ebp
  800d40:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d43:	8b 45 08             	mov    0x8(%ebp),%eax
  800d46:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d52:	01 d0                	add    %edx,%eax
  800d54:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d57:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d5e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d62:	74 06                	je     800d6a <vsnprintf+0x2d>
  800d64:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d68:	7f 07                	jg     800d71 <vsnprintf+0x34>
		return -E_INVAL;
  800d6a:	b8 03 00 00 00       	mov    $0x3,%eax
  800d6f:	eb 20                	jmp    800d91 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d71:	ff 75 14             	pushl  0x14(%ebp)
  800d74:	ff 75 10             	pushl  0x10(%ebp)
  800d77:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d7a:	50                   	push   %eax
  800d7b:	68 07 0d 80 00       	push   $0x800d07
  800d80:	e8 92 fb ff ff       	call   800917 <vprintfmt>
  800d85:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d8b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d91:	c9                   	leave  
  800d92:	c3                   	ret    

00800d93 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d93:	55                   	push   %ebp
  800d94:	89 e5                	mov    %esp,%ebp
  800d96:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d99:	8d 45 10             	lea    0x10(%ebp),%eax
  800d9c:	83 c0 04             	add    $0x4,%eax
  800d9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800da2:	8b 45 10             	mov    0x10(%ebp),%eax
  800da5:	ff 75 f4             	pushl  -0xc(%ebp)
  800da8:	50                   	push   %eax
  800da9:	ff 75 0c             	pushl  0xc(%ebp)
  800dac:	ff 75 08             	pushl  0x8(%ebp)
  800daf:	e8 89 ff ff ff       	call   800d3d <vsnprintf>
  800db4:	83 c4 10             	add    $0x10,%esp
  800db7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800dba:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800dbd:	c9                   	leave  
  800dbe:	c3                   	ret    

00800dbf <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800dbf:	55                   	push   %ebp
  800dc0:	89 e5                	mov    %esp,%ebp
  800dc2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800dc5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dcc:	eb 06                	jmp    800dd4 <strlen+0x15>
		n++;
  800dce:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800dd1:	ff 45 08             	incl   0x8(%ebp)
  800dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd7:	8a 00                	mov    (%eax),%al
  800dd9:	84 c0                	test   %al,%al
  800ddb:	75 f1                	jne    800dce <strlen+0xf>
		n++;
	return n;
  800ddd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800de0:	c9                   	leave  
  800de1:	c3                   	ret    

00800de2 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800de2:	55                   	push   %ebp
  800de3:	89 e5                	mov    %esp,%ebp
  800de5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800de8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800def:	eb 09                	jmp    800dfa <strnlen+0x18>
		n++;
  800df1:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800df4:	ff 45 08             	incl   0x8(%ebp)
  800df7:	ff 4d 0c             	decl   0xc(%ebp)
  800dfa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dfe:	74 09                	je     800e09 <strnlen+0x27>
  800e00:	8b 45 08             	mov    0x8(%ebp),%eax
  800e03:	8a 00                	mov    (%eax),%al
  800e05:	84 c0                	test   %al,%al
  800e07:	75 e8                	jne    800df1 <strnlen+0xf>
		n++;
	return n;
  800e09:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e0c:	c9                   	leave  
  800e0d:	c3                   	ret    

00800e0e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e0e:	55                   	push   %ebp
  800e0f:	89 e5                	mov    %esp,%ebp
  800e11:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e14:	8b 45 08             	mov    0x8(%ebp),%eax
  800e17:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e1a:	90                   	nop
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1e:	8d 50 01             	lea    0x1(%eax),%edx
  800e21:	89 55 08             	mov    %edx,0x8(%ebp)
  800e24:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e27:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e2a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e2d:	8a 12                	mov    (%edx),%dl
  800e2f:	88 10                	mov    %dl,(%eax)
  800e31:	8a 00                	mov    (%eax),%al
  800e33:	84 c0                	test   %al,%al
  800e35:	75 e4                	jne    800e1b <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e37:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e3a:	c9                   	leave  
  800e3b:	c3                   	ret    

00800e3c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e3c:	55                   	push   %ebp
  800e3d:	89 e5                	mov    %esp,%ebp
  800e3f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e42:	8b 45 08             	mov    0x8(%ebp),%eax
  800e45:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e48:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e4f:	eb 1f                	jmp    800e70 <strncpy+0x34>
		*dst++ = *src;
  800e51:	8b 45 08             	mov    0x8(%ebp),%eax
  800e54:	8d 50 01             	lea    0x1(%eax),%edx
  800e57:	89 55 08             	mov    %edx,0x8(%ebp)
  800e5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e5d:	8a 12                	mov    (%edx),%dl
  800e5f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e64:	8a 00                	mov    (%eax),%al
  800e66:	84 c0                	test   %al,%al
  800e68:	74 03                	je     800e6d <strncpy+0x31>
			src++;
  800e6a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e6d:	ff 45 fc             	incl   -0x4(%ebp)
  800e70:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e73:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e76:	72 d9                	jb     800e51 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e78:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e7b:	c9                   	leave  
  800e7c:	c3                   	ret    

00800e7d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e7d:	55                   	push   %ebp
  800e7e:	89 e5                	mov    %esp,%ebp
  800e80:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e89:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e8d:	74 30                	je     800ebf <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e8f:	eb 16                	jmp    800ea7 <strlcpy+0x2a>
			*dst++ = *src++;
  800e91:	8b 45 08             	mov    0x8(%ebp),%eax
  800e94:	8d 50 01             	lea    0x1(%eax),%edx
  800e97:	89 55 08             	mov    %edx,0x8(%ebp)
  800e9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e9d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ea0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ea3:	8a 12                	mov    (%edx),%dl
  800ea5:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ea7:	ff 4d 10             	decl   0x10(%ebp)
  800eaa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eae:	74 09                	je     800eb9 <strlcpy+0x3c>
  800eb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb3:	8a 00                	mov    (%eax),%al
  800eb5:	84 c0                	test   %al,%al
  800eb7:	75 d8                	jne    800e91 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebc:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ebf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec5:	29 c2                	sub    %eax,%edx
  800ec7:	89 d0                	mov    %edx,%eax
}
  800ec9:	c9                   	leave  
  800eca:	c3                   	ret    

00800ecb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ecb:	55                   	push   %ebp
  800ecc:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ece:	eb 06                	jmp    800ed6 <strcmp+0xb>
		p++, q++;
  800ed0:	ff 45 08             	incl   0x8(%ebp)
  800ed3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed9:	8a 00                	mov    (%eax),%al
  800edb:	84 c0                	test   %al,%al
  800edd:	74 0e                	je     800eed <strcmp+0x22>
  800edf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee2:	8a 10                	mov    (%eax),%dl
  800ee4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee7:	8a 00                	mov    (%eax),%al
  800ee9:	38 c2                	cmp    %al,%dl
  800eeb:	74 e3                	je     800ed0 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800eed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef0:	8a 00                	mov    (%eax),%al
  800ef2:	0f b6 d0             	movzbl %al,%edx
  800ef5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef8:	8a 00                	mov    (%eax),%al
  800efa:	0f b6 c0             	movzbl %al,%eax
  800efd:	29 c2                	sub    %eax,%edx
  800eff:	89 d0                	mov    %edx,%eax
}
  800f01:	5d                   	pop    %ebp
  800f02:	c3                   	ret    

00800f03 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f03:	55                   	push   %ebp
  800f04:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f06:	eb 09                	jmp    800f11 <strncmp+0xe>
		n--, p++, q++;
  800f08:	ff 4d 10             	decl   0x10(%ebp)
  800f0b:	ff 45 08             	incl   0x8(%ebp)
  800f0e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f11:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f15:	74 17                	je     800f2e <strncmp+0x2b>
  800f17:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1a:	8a 00                	mov    (%eax),%al
  800f1c:	84 c0                	test   %al,%al
  800f1e:	74 0e                	je     800f2e <strncmp+0x2b>
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
  800f23:	8a 10                	mov    (%eax),%dl
  800f25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f28:	8a 00                	mov    (%eax),%al
  800f2a:	38 c2                	cmp    %al,%dl
  800f2c:	74 da                	je     800f08 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f2e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f32:	75 07                	jne    800f3b <strncmp+0x38>
		return 0;
  800f34:	b8 00 00 00 00       	mov    $0x0,%eax
  800f39:	eb 14                	jmp    800f4f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3e:	8a 00                	mov    (%eax),%al
  800f40:	0f b6 d0             	movzbl %al,%edx
  800f43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f46:	8a 00                	mov    (%eax),%al
  800f48:	0f b6 c0             	movzbl %al,%eax
  800f4b:	29 c2                	sub    %eax,%edx
  800f4d:	89 d0                	mov    %edx,%eax
}
  800f4f:	5d                   	pop    %ebp
  800f50:	c3                   	ret    

00800f51 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f51:	55                   	push   %ebp
  800f52:	89 e5                	mov    %esp,%ebp
  800f54:	83 ec 04             	sub    $0x4,%esp
  800f57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f5d:	eb 12                	jmp    800f71 <strchr+0x20>
		if (*s == c)
  800f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f62:	8a 00                	mov    (%eax),%al
  800f64:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f67:	75 05                	jne    800f6e <strchr+0x1d>
			return (char *) s;
  800f69:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6c:	eb 11                	jmp    800f7f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f6e:	ff 45 08             	incl   0x8(%ebp)
  800f71:	8b 45 08             	mov    0x8(%ebp),%eax
  800f74:	8a 00                	mov    (%eax),%al
  800f76:	84 c0                	test   %al,%al
  800f78:	75 e5                	jne    800f5f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f7f:	c9                   	leave  
  800f80:	c3                   	ret    

00800f81 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f81:	55                   	push   %ebp
  800f82:	89 e5                	mov    %esp,%ebp
  800f84:	83 ec 04             	sub    $0x4,%esp
  800f87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f8d:	eb 0d                	jmp    800f9c <strfind+0x1b>
		if (*s == c)
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	8a 00                	mov    (%eax),%al
  800f94:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f97:	74 0e                	je     800fa7 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f99:	ff 45 08             	incl   0x8(%ebp)
  800f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9f:	8a 00                	mov    (%eax),%al
  800fa1:	84 c0                	test   %al,%al
  800fa3:	75 ea                	jne    800f8f <strfind+0xe>
  800fa5:	eb 01                	jmp    800fa8 <strfind+0x27>
		if (*s == c)
			break;
  800fa7:	90                   	nop
	return (char *) s;
  800fa8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fab:	c9                   	leave  
  800fac:	c3                   	ret    

00800fad <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800fad:	55                   	push   %ebp
  800fae:	89 e5                	mov    %esp,%ebp
  800fb0:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800fb9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800fbf:	eb 0e                	jmp    800fcf <memset+0x22>
		*p++ = c;
  800fc1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc4:	8d 50 01             	lea    0x1(%eax),%edx
  800fc7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fca:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fcd:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800fcf:	ff 4d f8             	decl   -0x8(%ebp)
  800fd2:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800fd6:	79 e9                	jns    800fc1 <memset+0x14>
		*p++ = c;

	return v;
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fdb:	c9                   	leave  
  800fdc:	c3                   	ret    

00800fdd <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800fdd:	55                   	push   %ebp
  800fde:	89 e5                	mov    %esp,%ebp
  800fe0:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fe3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800fef:	eb 16                	jmp    801007 <memcpy+0x2a>
		*d++ = *s++;
  800ff1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff4:	8d 50 01             	lea    0x1(%eax),%edx
  800ff7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ffa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ffd:	8d 4a 01             	lea    0x1(%edx),%ecx
  801000:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801003:	8a 12                	mov    (%edx),%dl
  801005:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801007:	8b 45 10             	mov    0x10(%ebp),%eax
  80100a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80100d:	89 55 10             	mov    %edx,0x10(%ebp)
  801010:	85 c0                	test   %eax,%eax
  801012:	75 dd                	jne    800ff1 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801014:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801017:	c9                   	leave  
  801018:	c3                   	ret    

00801019 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801019:	55                   	push   %ebp
  80101a:	89 e5                	mov    %esp,%ebp
  80101c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80101f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801022:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801025:	8b 45 08             	mov    0x8(%ebp),%eax
  801028:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80102b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80102e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801031:	73 50                	jae    801083 <memmove+0x6a>
  801033:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801036:	8b 45 10             	mov    0x10(%ebp),%eax
  801039:	01 d0                	add    %edx,%eax
  80103b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80103e:	76 43                	jbe    801083 <memmove+0x6a>
		s += n;
  801040:	8b 45 10             	mov    0x10(%ebp),%eax
  801043:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801046:	8b 45 10             	mov    0x10(%ebp),%eax
  801049:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80104c:	eb 10                	jmp    80105e <memmove+0x45>
			*--d = *--s;
  80104e:	ff 4d f8             	decl   -0x8(%ebp)
  801051:	ff 4d fc             	decl   -0x4(%ebp)
  801054:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801057:	8a 10                	mov    (%eax),%dl
  801059:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80105c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80105e:	8b 45 10             	mov    0x10(%ebp),%eax
  801061:	8d 50 ff             	lea    -0x1(%eax),%edx
  801064:	89 55 10             	mov    %edx,0x10(%ebp)
  801067:	85 c0                	test   %eax,%eax
  801069:	75 e3                	jne    80104e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80106b:	eb 23                	jmp    801090 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80106d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801070:	8d 50 01             	lea    0x1(%eax),%edx
  801073:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801076:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801079:	8d 4a 01             	lea    0x1(%edx),%ecx
  80107c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80107f:	8a 12                	mov    (%edx),%dl
  801081:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801083:	8b 45 10             	mov    0x10(%ebp),%eax
  801086:	8d 50 ff             	lea    -0x1(%eax),%edx
  801089:	89 55 10             	mov    %edx,0x10(%ebp)
  80108c:	85 c0                	test   %eax,%eax
  80108e:	75 dd                	jne    80106d <memmove+0x54>
			*d++ = *s++;

	return dst;
  801090:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801093:	c9                   	leave  
  801094:	c3                   	ret    

00801095 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801095:	55                   	push   %ebp
  801096:	89 e5                	mov    %esp,%ebp
  801098:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80109b:	8b 45 08             	mov    0x8(%ebp),%eax
  80109e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a4:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010a7:	eb 2a                	jmp    8010d3 <memcmp+0x3e>
		if (*s1 != *s2)
  8010a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ac:	8a 10                	mov    (%eax),%dl
  8010ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010b1:	8a 00                	mov    (%eax),%al
  8010b3:	38 c2                	cmp    %al,%dl
  8010b5:	74 16                	je     8010cd <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ba:	8a 00                	mov    (%eax),%al
  8010bc:	0f b6 d0             	movzbl %al,%edx
  8010bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c2:	8a 00                	mov    (%eax),%al
  8010c4:	0f b6 c0             	movzbl %al,%eax
  8010c7:	29 c2                	sub    %eax,%edx
  8010c9:	89 d0                	mov    %edx,%eax
  8010cb:	eb 18                	jmp    8010e5 <memcmp+0x50>
		s1++, s2++;
  8010cd:	ff 45 fc             	incl   -0x4(%ebp)
  8010d0:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8010d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010d9:	89 55 10             	mov    %edx,0x10(%ebp)
  8010dc:	85 c0                	test   %eax,%eax
  8010de:	75 c9                	jne    8010a9 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8010e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010e5:	c9                   	leave  
  8010e6:	c3                   	ret    

008010e7 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8010e7:	55                   	push   %ebp
  8010e8:	89 e5                	mov    %esp,%ebp
  8010ea:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8010ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f3:	01 d0                	add    %edx,%eax
  8010f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8010f8:	eb 15                	jmp    80110f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8010fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fd:	8a 00                	mov    (%eax),%al
  8010ff:	0f b6 d0             	movzbl %al,%edx
  801102:	8b 45 0c             	mov    0xc(%ebp),%eax
  801105:	0f b6 c0             	movzbl %al,%eax
  801108:	39 c2                	cmp    %eax,%edx
  80110a:	74 0d                	je     801119 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80110c:	ff 45 08             	incl   0x8(%ebp)
  80110f:	8b 45 08             	mov    0x8(%ebp),%eax
  801112:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801115:	72 e3                	jb     8010fa <memfind+0x13>
  801117:	eb 01                	jmp    80111a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801119:	90                   	nop
	return (void *) s;
  80111a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80111d:	c9                   	leave  
  80111e:	c3                   	ret    

0080111f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80111f:	55                   	push   %ebp
  801120:	89 e5                	mov    %esp,%ebp
  801122:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801125:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80112c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801133:	eb 03                	jmp    801138 <strtol+0x19>
		s++;
  801135:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801138:	8b 45 08             	mov    0x8(%ebp),%eax
  80113b:	8a 00                	mov    (%eax),%al
  80113d:	3c 20                	cmp    $0x20,%al
  80113f:	74 f4                	je     801135 <strtol+0x16>
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	8a 00                	mov    (%eax),%al
  801146:	3c 09                	cmp    $0x9,%al
  801148:	74 eb                	je     801135 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80114a:	8b 45 08             	mov    0x8(%ebp),%eax
  80114d:	8a 00                	mov    (%eax),%al
  80114f:	3c 2b                	cmp    $0x2b,%al
  801151:	75 05                	jne    801158 <strtol+0x39>
		s++;
  801153:	ff 45 08             	incl   0x8(%ebp)
  801156:	eb 13                	jmp    80116b <strtol+0x4c>
	else if (*s == '-')
  801158:	8b 45 08             	mov    0x8(%ebp),%eax
  80115b:	8a 00                	mov    (%eax),%al
  80115d:	3c 2d                	cmp    $0x2d,%al
  80115f:	75 0a                	jne    80116b <strtol+0x4c>
		s++, neg = 1;
  801161:	ff 45 08             	incl   0x8(%ebp)
  801164:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80116b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80116f:	74 06                	je     801177 <strtol+0x58>
  801171:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801175:	75 20                	jne    801197 <strtol+0x78>
  801177:	8b 45 08             	mov    0x8(%ebp),%eax
  80117a:	8a 00                	mov    (%eax),%al
  80117c:	3c 30                	cmp    $0x30,%al
  80117e:	75 17                	jne    801197 <strtol+0x78>
  801180:	8b 45 08             	mov    0x8(%ebp),%eax
  801183:	40                   	inc    %eax
  801184:	8a 00                	mov    (%eax),%al
  801186:	3c 78                	cmp    $0x78,%al
  801188:	75 0d                	jne    801197 <strtol+0x78>
		s += 2, base = 16;
  80118a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80118e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801195:	eb 28                	jmp    8011bf <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801197:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80119b:	75 15                	jne    8011b2 <strtol+0x93>
  80119d:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a0:	8a 00                	mov    (%eax),%al
  8011a2:	3c 30                	cmp    $0x30,%al
  8011a4:	75 0c                	jne    8011b2 <strtol+0x93>
		s++, base = 8;
  8011a6:	ff 45 08             	incl   0x8(%ebp)
  8011a9:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011b0:	eb 0d                	jmp    8011bf <strtol+0xa0>
	else if (base == 0)
  8011b2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011b6:	75 07                	jne    8011bf <strtol+0xa0>
		base = 10;
  8011b8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c2:	8a 00                	mov    (%eax),%al
  8011c4:	3c 2f                	cmp    $0x2f,%al
  8011c6:	7e 19                	jle    8011e1 <strtol+0xc2>
  8011c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cb:	8a 00                	mov    (%eax),%al
  8011cd:	3c 39                	cmp    $0x39,%al
  8011cf:	7f 10                	jg     8011e1 <strtol+0xc2>
			dig = *s - '0';
  8011d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d4:	8a 00                	mov    (%eax),%al
  8011d6:	0f be c0             	movsbl %al,%eax
  8011d9:	83 e8 30             	sub    $0x30,%eax
  8011dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011df:	eb 42                	jmp    801223 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8011e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e4:	8a 00                	mov    (%eax),%al
  8011e6:	3c 60                	cmp    $0x60,%al
  8011e8:	7e 19                	jle    801203 <strtol+0xe4>
  8011ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ed:	8a 00                	mov    (%eax),%al
  8011ef:	3c 7a                	cmp    $0x7a,%al
  8011f1:	7f 10                	jg     801203 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8011f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f6:	8a 00                	mov    (%eax),%al
  8011f8:	0f be c0             	movsbl %al,%eax
  8011fb:	83 e8 57             	sub    $0x57,%eax
  8011fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801201:	eb 20                	jmp    801223 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801203:	8b 45 08             	mov    0x8(%ebp),%eax
  801206:	8a 00                	mov    (%eax),%al
  801208:	3c 40                	cmp    $0x40,%al
  80120a:	7e 39                	jle    801245 <strtol+0x126>
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	8a 00                	mov    (%eax),%al
  801211:	3c 5a                	cmp    $0x5a,%al
  801213:	7f 30                	jg     801245 <strtol+0x126>
			dig = *s - 'A' + 10;
  801215:	8b 45 08             	mov    0x8(%ebp),%eax
  801218:	8a 00                	mov    (%eax),%al
  80121a:	0f be c0             	movsbl %al,%eax
  80121d:	83 e8 37             	sub    $0x37,%eax
  801220:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801223:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801226:	3b 45 10             	cmp    0x10(%ebp),%eax
  801229:	7d 19                	jge    801244 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80122b:	ff 45 08             	incl   0x8(%ebp)
  80122e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801231:	0f af 45 10          	imul   0x10(%ebp),%eax
  801235:	89 c2                	mov    %eax,%edx
  801237:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80123a:	01 d0                	add    %edx,%eax
  80123c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80123f:	e9 7b ff ff ff       	jmp    8011bf <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801244:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801245:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801249:	74 08                	je     801253 <strtol+0x134>
		*endptr = (char *) s;
  80124b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124e:	8b 55 08             	mov    0x8(%ebp),%edx
  801251:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801253:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801257:	74 07                	je     801260 <strtol+0x141>
  801259:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80125c:	f7 d8                	neg    %eax
  80125e:	eb 03                	jmp    801263 <strtol+0x144>
  801260:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801263:	c9                   	leave  
  801264:	c3                   	ret    

00801265 <ltostr>:

void
ltostr(long value, char *str)
{
  801265:	55                   	push   %ebp
  801266:	89 e5                	mov    %esp,%ebp
  801268:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80126b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801272:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801279:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80127d:	79 13                	jns    801292 <ltostr+0x2d>
	{
		neg = 1;
  80127f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801286:	8b 45 0c             	mov    0xc(%ebp),%eax
  801289:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80128c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80128f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80129a:	99                   	cltd   
  80129b:	f7 f9                	idiv   %ecx
  80129d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012a3:	8d 50 01             	lea    0x1(%eax),%edx
  8012a6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012a9:	89 c2                	mov    %eax,%edx
  8012ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ae:	01 d0                	add    %edx,%eax
  8012b0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012b3:	83 c2 30             	add    $0x30,%edx
  8012b6:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012bb:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012c0:	f7 e9                	imul   %ecx
  8012c2:	c1 fa 02             	sar    $0x2,%edx
  8012c5:	89 c8                	mov    %ecx,%eax
  8012c7:	c1 f8 1f             	sar    $0x1f,%eax
  8012ca:	29 c2                	sub    %eax,%edx
  8012cc:	89 d0                	mov    %edx,%eax
  8012ce:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8012d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012d4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012d9:	f7 e9                	imul   %ecx
  8012db:	c1 fa 02             	sar    $0x2,%edx
  8012de:	89 c8                	mov    %ecx,%eax
  8012e0:	c1 f8 1f             	sar    $0x1f,%eax
  8012e3:	29 c2                	sub    %eax,%edx
  8012e5:	89 d0                	mov    %edx,%eax
  8012e7:	c1 e0 02             	shl    $0x2,%eax
  8012ea:	01 d0                	add    %edx,%eax
  8012ec:	01 c0                	add    %eax,%eax
  8012ee:	29 c1                	sub    %eax,%ecx
  8012f0:	89 ca                	mov    %ecx,%edx
  8012f2:	85 d2                	test   %edx,%edx
  8012f4:	75 9c                	jne    801292 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8012f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8012fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801300:	48                   	dec    %eax
  801301:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801304:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801308:	74 3d                	je     801347 <ltostr+0xe2>
		start = 1 ;
  80130a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801311:	eb 34                	jmp    801347 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801313:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801316:	8b 45 0c             	mov    0xc(%ebp),%eax
  801319:	01 d0                	add    %edx,%eax
  80131b:	8a 00                	mov    (%eax),%al
  80131d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801320:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801323:	8b 45 0c             	mov    0xc(%ebp),%eax
  801326:	01 c2                	add    %eax,%edx
  801328:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80132b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132e:	01 c8                	add    %ecx,%eax
  801330:	8a 00                	mov    (%eax),%al
  801332:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801334:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801337:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133a:	01 c2                	add    %eax,%edx
  80133c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80133f:	88 02                	mov    %al,(%edx)
		start++ ;
  801341:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801344:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801347:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80134a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80134d:	7c c4                	jl     801313 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80134f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801352:	8b 45 0c             	mov    0xc(%ebp),%eax
  801355:	01 d0                	add    %edx,%eax
  801357:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80135a:	90                   	nop
  80135b:	c9                   	leave  
  80135c:	c3                   	ret    

0080135d <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80135d:	55                   	push   %ebp
  80135e:	89 e5                	mov    %esp,%ebp
  801360:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801363:	ff 75 08             	pushl  0x8(%ebp)
  801366:	e8 54 fa ff ff       	call   800dbf <strlen>
  80136b:	83 c4 04             	add    $0x4,%esp
  80136e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801371:	ff 75 0c             	pushl  0xc(%ebp)
  801374:	e8 46 fa ff ff       	call   800dbf <strlen>
  801379:	83 c4 04             	add    $0x4,%esp
  80137c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80137f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801386:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80138d:	eb 17                	jmp    8013a6 <strcconcat+0x49>
		final[s] = str1[s] ;
  80138f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801392:	8b 45 10             	mov    0x10(%ebp),%eax
  801395:	01 c2                	add    %eax,%edx
  801397:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80139a:	8b 45 08             	mov    0x8(%ebp),%eax
  80139d:	01 c8                	add    %ecx,%eax
  80139f:	8a 00                	mov    (%eax),%al
  8013a1:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013a3:	ff 45 fc             	incl   -0x4(%ebp)
  8013a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013a9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013ac:	7c e1                	jl     80138f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013ae:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013b5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013bc:	eb 1f                	jmp    8013dd <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013c1:	8d 50 01             	lea    0x1(%eax),%edx
  8013c4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013c7:	89 c2                	mov    %eax,%edx
  8013c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013cc:	01 c2                	add    %eax,%edx
  8013ce:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8013d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d4:	01 c8                	add    %ecx,%eax
  8013d6:	8a 00                	mov    (%eax),%al
  8013d8:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8013da:	ff 45 f8             	incl   -0x8(%ebp)
  8013dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013e0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013e3:	7c d9                	jl     8013be <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8013e5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8013eb:	01 d0                	add    %edx,%eax
  8013ed:	c6 00 00             	movb   $0x0,(%eax)
}
  8013f0:	90                   	nop
  8013f1:	c9                   	leave  
  8013f2:	c3                   	ret    

008013f3 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8013f3:	55                   	push   %ebp
  8013f4:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8013f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8013ff:	8b 45 14             	mov    0x14(%ebp),%eax
  801402:	8b 00                	mov    (%eax),%eax
  801404:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80140b:	8b 45 10             	mov    0x10(%ebp),%eax
  80140e:	01 d0                	add    %edx,%eax
  801410:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801416:	eb 0c                	jmp    801424 <strsplit+0x31>
			*string++ = 0;
  801418:	8b 45 08             	mov    0x8(%ebp),%eax
  80141b:	8d 50 01             	lea    0x1(%eax),%edx
  80141e:	89 55 08             	mov    %edx,0x8(%ebp)
  801421:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801424:	8b 45 08             	mov    0x8(%ebp),%eax
  801427:	8a 00                	mov    (%eax),%al
  801429:	84 c0                	test   %al,%al
  80142b:	74 18                	je     801445 <strsplit+0x52>
  80142d:	8b 45 08             	mov    0x8(%ebp),%eax
  801430:	8a 00                	mov    (%eax),%al
  801432:	0f be c0             	movsbl %al,%eax
  801435:	50                   	push   %eax
  801436:	ff 75 0c             	pushl  0xc(%ebp)
  801439:	e8 13 fb ff ff       	call   800f51 <strchr>
  80143e:	83 c4 08             	add    $0x8,%esp
  801441:	85 c0                	test   %eax,%eax
  801443:	75 d3                	jne    801418 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801445:	8b 45 08             	mov    0x8(%ebp),%eax
  801448:	8a 00                	mov    (%eax),%al
  80144a:	84 c0                	test   %al,%al
  80144c:	74 5a                	je     8014a8 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80144e:	8b 45 14             	mov    0x14(%ebp),%eax
  801451:	8b 00                	mov    (%eax),%eax
  801453:	83 f8 0f             	cmp    $0xf,%eax
  801456:	75 07                	jne    80145f <strsplit+0x6c>
		{
			return 0;
  801458:	b8 00 00 00 00       	mov    $0x0,%eax
  80145d:	eb 66                	jmp    8014c5 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80145f:	8b 45 14             	mov    0x14(%ebp),%eax
  801462:	8b 00                	mov    (%eax),%eax
  801464:	8d 48 01             	lea    0x1(%eax),%ecx
  801467:	8b 55 14             	mov    0x14(%ebp),%edx
  80146a:	89 0a                	mov    %ecx,(%edx)
  80146c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801473:	8b 45 10             	mov    0x10(%ebp),%eax
  801476:	01 c2                	add    %eax,%edx
  801478:	8b 45 08             	mov    0x8(%ebp),%eax
  80147b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80147d:	eb 03                	jmp    801482 <strsplit+0x8f>
			string++;
  80147f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801482:	8b 45 08             	mov    0x8(%ebp),%eax
  801485:	8a 00                	mov    (%eax),%al
  801487:	84 c0                	test   %al,%al
  801489:	74 8b                	je     801416 <strsplit+0x23>
  80148b:	8b 45 08             	mov    0x8(%ebp),%eax
  80148e:	8a 00                	mov    (%eax),%al
  801490:	0f be c0             	movsbl %al,%eax
  801493:	50                   	push   %eax
  801494:	ff 75 0c             	pushl  0xc(%ebp)
  801497:	e8 b5 fa ff ff       	call   800f51 <strchr>
  80149c:	83 c4 08             	add    $0x8,%esp
  80149f:	85 c0                	test   %eax,%eax
  8014a1:	74 dc                	je     80147f <strsplit+0x8c>
			string++;
	}
  8014a3:	e9 6e ff ff ff       	jmp    801416 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014a8:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ac:	8b 00                	mov    (%eax),%eax
  8014ae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b8:	01 d0                	add    %edx,%eax
  8014ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014c0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014c5:	c9                   	leave  
  8014c6:	c3                   	ret    

008014c7 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8014c7:	55                   	push   %ebp
  8014c8:	89 e5                	mov    %esp,%ebp
  8014ca:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8014cd:	a1 04 40 80 00       	mov    0x804004,%eax
  8014d2:	85 c0                	test   %eax,%eax
  8014d4:	74 1f                	je     8014f5 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8014d6:	e8 1d 00 00 00       	call   8014f8 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8014db:	83 ec 0c             	sub    $0xc,%esp
  8014de:	68 50 3b 80 00       	push   $0x803b50
  8014e3:	e8 55 f2 ff ff       	call   80073d <cprintf>
  8014e8:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8014eb:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8014f2:	00 00 00 
	}
}
  8014f5:	90                   	nop
  8014f6:	c9                   	leave  
  8014f7:	c3                   	ret    

008014f8 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8014f8:	55                   	push   %ebp
  8014f9:	89 e5                	mov    %esp,%ebp
  8014fb:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  8014fe:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801505:	00 00 00 
  801508:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80150f:	00 00 00 
  801512:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801519:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  80151c:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801523:	00 00 00 
  801526:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80152d:	00 00 00 
  801530:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801537:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  80153a:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801541:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801544:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  80154b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80154e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801553:	2d 00 10 00 00       	sub    $0x1000,%eax
  801558:	a3 50 40 80 00       	mov    %eax,0x804050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  80155d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801564:	a1 20 41 80 00       	mov    0x804120,%eax
  801569:	c1 e0 04             	shl    $0x4,%eax
  80156c:	89 c2                	mov    %eax,%edx
  80156e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801571:	01 d0                	add    %edx,%eax
  801573:	48                   	dec    %eax
  801574:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801577:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80157a:	ba 00 00 00 00       	mov    $0x0,%edx
  80157f:	f7 75 f0             	divl   -0x10(%ebp)
  801582:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801585:	29 d0                	sub    %edx,%eax
  801587:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  80158a:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801591:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801594:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801599:	2d 00 10 00 00       	sub    $0x1000,%eax
  80159e:	83 ec 04             	sub    $0x4,%esp
  8015a1:	6a 06                	push   $0x6
  8015a3:	ff 75 e8             	pushl  -0x18(%ebp)
  8015a6:	50                   	push   %eax
  8015a7:	e8 b0 05 00 00       	call   801b5c <sys_allocate_chunk>
  8015ac:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8015af:	a1 20 41 80 00       	mov    0x804120,%eax
  8015b4:	83 ec 0c             	sub    $0xc,%esp
  8015b7:	50                   	push   %eax
  8015b8:	e8 25 0c 00 00       	call   8021e2 <initialize_MemBlocksList>
  8015bd:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  8015c0:	a1 48 41 80 00       	mov    0x804148,%eax
  8015c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  8015c8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8015cc:	75 14                	jne    8015e2 <initialize_dyn_block_system+0xea>
  8015ce:	83 ec 04             	sub    $0x4,%esp
  8015d1:	68 75 3b 80 00       	push   $0x803b75
  8015d6:	6a 29                	push   $0x29
  8015d8:	68 93 3b 80 00       	push   $0x803b93
  8015dd:	e8 43 1c 00 00       	call   803225 <_panic>
  8015e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015e5:	8b 00                	mov    (%eax),%eax
  8015e7:	85 c0                	test   %eax,%eax
  8015e9:	74 10                	je     8015fb <initialize_dyn_block_system+0x103>
  8015eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015ee:	8b 00                	mov    (%eax),%eax
  8015f0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8015f3:	8b 52 04             	mov    0x4(%edx),%edx
  8015f6:	89 50 04             	mov    %edx,0x4(%eax)
  8015f9:	eb 0b                	jmp    801606 <initialize_dyn_block_system+0x10e>
  8015fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015fe:	8b 40 04             	mov    0x4(%eax),%eax
  801601:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801606:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801609:	8b 40 04             	mov    0x4(%eax),%eax
  80160c:	85 c0                	test   %eax,%eax
  80160e:	74 0f                	je     80161f <initialize_dyn_block_system+0x127>
  801610:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801613:	8b 40 04             	mov    0x4(%eax),%eax
  801616:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801619:	8b 12                	mov    (%edx),%edx
  80161b:	89 10                	mov    %edx,(%eax)
  80161d:	eb 0a                	jmp    801629 <initialize_dyn_block_system+0x131>
  80161f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801622:	8b 00                	mov    (%eax),%eax
  801624:	a3 48 41 80 00       	mov    %eax,0x804148
  801629:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80162c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801632:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801635:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80163c:	a1 54 41 80 00       	mov    0x804154,%eax
  801641:	48                   	dec    %eax
  801642:	a3 54 41 80 00       	mov    %eax,0x804154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  801647:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80164a:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  801651:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801654:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  80165b:	83 ec 0c             	sub    $0xc,%esp
  80165e:	ff 75 e0             	pushl  -0x20(%ebp)
  801661:	e8 b9 14 00 00       	call   802b1f <insert_sorted_with_merge_freeList>
  801666:	83 c4 10             	add    $0x10,%esp

}
  801669:	90                   	nop
  80166a:	c9                   	leave  
  80166b:	c3                   	ret    

0080166c <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80166c:	55                   	push   %ebp
  80166d:	89 e5                	mov    %esp,%ebp
  80166f:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801672:	e8 50 fe ff ff       	call   8014c7 <InitializeUHeap>
	if (size == 0) return NULL ;
  801677:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80167b:	75 07                	jne    801684 <malloc+0x18>
  80167d:	b8 00 00 00 00       	mov    $0x0,%eax
  801682:	eb 68                	jmp    8016ec <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  801684:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80168b:	8b 55 08             	mov    0x8(%ebp),%edx
  80168e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801691:	01 d0                	add    %edx,%eax
  801693:	48                   	dec    %eax
  801694:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801697:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80169a:	ba 00 00 00 00       	mov    $0x0,%edx
  80169f:	f7 75 f4             	divl   -0xc(%ebp)
  8016a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a5:	29 d0                	sub    %edx,%eax
  8016a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  8016aa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8016b1:	e8 74 08 00 00       	call   801f2a <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016b6:	85 c0                	test   %eax,%eax
  8016b8:	74 2d                	je     8016e7 <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  8016ba:	83 ec 0c             	sub    $0xc,%esp
  8016bd:	ff 75 ec             	pushl  -0x14(%ebp)
  8016c0:	e8 52 0e 00 00       	call   802517 <alloc_block_FF>
  8016c5:	83 c4 10             	add    $0x10,%esp
  8016c8:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  8016cb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8016cf:	74 16                	je     8016e7 <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  8016d1:	83 ec 0c             	sub    $0xc,%esp
  8016d4:	ff 75 e8             	pushl  -0x18(%ebp)
  8016d7:	e8 3b 0c 00 00       	call   802317 <insert_sorted_allocList>
  8016dc:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  8016df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016e2:	8b 40 08             	mov    0x8(%eax),%eax
  8016e5:	eb 05                	jmp    8016ec <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  8016e7:	b8 00 00 00 00       	mov    $0x0,%eax

}
  8016ec:	c9                   	leave  
  8016ed:	c3                   	ret    

008016ee <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8016ee:	55                   	push   %ebp
  8016ef:	89 e5                	mov    %esp,%ebp
  8016f1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  8016f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f7:	83 ec 08             	sub    $0x8,%esp
  8016fa:	50                   	push   %eax
  8016fb:	68 40 40 80 00       	push   $0x804040
  801700:	e8 ba 0b 00 00       	call   8022bf <find_block>
  801705:	83 c4 10             	add    $0x10,%esp
  801708:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  80170b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80170e:	8b 40 0c             	mov    0xc(%eax),%eax
  801711:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  801714:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801718:	0f 84 9f 00 00 00    	je     8017bd <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  80171e:	8b 45 08             	mov    0x8(%ebp),%eax
  801721:	83 ec 08             	sub    $0x8,%esp
  801724:	ff 75 f0             	pushl  -0x10(%ebp)
  801727:	50                   	push   %eax
  801728:	e8 f7 03 00 00       	call   801b24 <sys_free_user_mem>
  80172d:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  801730:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801734:	75 14                	jne    80174a <free+0x5c>
  801736:	83 ec 04             	sub    $0x4,%esp
  801739:	68 75 3b 80 00       	push   $0x803b75
  80173e:	6a 6a                	push   $0x6a
  801740:	68 93 3b 80 00       	push   $0x803b93
  801745:	e8 db 1a 00 00       	call   803225 <_panic>
  80174a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80174d:	8b 00                	mov    (%eax),%eax
  80174f:	85 c0                	test   %eax,%eax
  801751:	74 10                	je     801763 <free+0x75>
  801753:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801756:	8b 00                	mov    (%eax),%eax
  801758:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80175b:	8b 52 04             	mov    0x4(%edx),%edx
  80175e:	89 50 04             	mov    %edx,0x4(%eax)
  801761:	eb 0b                	jmp    80176e <free+0x80>
  801763:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801766:	8b 40 04             	mov    0x4(%eax),%eax
  801769:	a3 44 40 80 00       	mov    %eax,0x804044
  80176e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801771:	8b 40 04             	mov    0x4(%eax),%eax
  801774:	85 c0                	test   %eax,%eax
  801776:	74 0f                	je     801787 <free+0x99>
  801778:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80177b:	8b 40 04             	mov    0x4(%eax),%eax
  80177e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801781:	8b 12                	mov    (%edx),%edx
  801783:	89 10                	mov    %edx,(%eax)
  801785:	eb 0a                	jmp    801791 <free+0xa3>
  801787:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80178a:	8b 00                	mov    (%eax),%eax
  80178c:	a3 40 40 80 00       	mov    %eax,0x804040
  801791:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801794:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80179a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80179d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8017a4:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8017a9:	48                   	dec    %eax
  8017aa:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(blk);
  8017af:	83 ec 0c             	sub    $0xc,%esp
  8017b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8017b5:	e8 65 13 00 00       	call   802b1f <insert_sorted_with_merge_freeList>
  8017ba:	83 c4 10             	add    $0x10,%esp
	}
}
  8017bd:	90                   	nop
  8017be:	c9                   	leave  
  8017bf:	c3                   	ret    

008017c0 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8017c0:	55                   	push   %ebp
  8017c1:	89 e5                	mov    %esp,%ebp
  8017c3:	83 ec 28             	sub    $0x28,%esp
  8017c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8017c9:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017cc:	e8 f6 fc ff ff       	call   8014c7 <InitializeUHeap>
	if (size == 0) return NULL ;
  8017d1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8017d5:	75 0a                	jne    8017e1 <smalloc+0x21>
  8017d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8017dc:	e9 af 00 00 00       	jmp    801890 <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  8017e1:	e8 44 07 00 00       	call   801f2a <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017e6:	83 f8 01             	cmp    $0x1,%eax
  8017e9:	0f 85 9c 00 00 00    	jne    80188b <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  8017ef:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8017f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017fc:	01 d0                	add    %edx,%eax
  8017fe:	48                   	dec    %eax
  8017ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801802:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801805:	ba 00 00 00 00       	mov    $0x0,%edx
  80180a:	f7 75 f4             	divl   -0xc(%ebp)
  80180d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801810:	29 d0                	sub    %edx,%eax
  801812:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  801815:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  80181c:	76 07                	jbe    801825 <smalloc+0x65>
			return NULL;
  80181e:	b8 00 00 00 00       	mov    $0x0,%eax
  801823:	eb 6b                	jmp    801890 <smalloc+0xd0>
		blk =alloc_block_FF(size);
  801825:	83 ec 0c             	sub    $0xc,%esp
  801828:	ff 75 0c             	pushl  0xc(%ebp)
  80182b:	e8 e7 0c 00 00       	call   802517 <alloc_block_FF>
  801830:	83 c4 10             	add    $0x10,%esp
  801833:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  801836:	83 ec 0c             	sub    $0xc,%esp
  801839:	ff 75 ec             	pushl  -0x14(%ebp)
  80183c:	e8 d6 0a 00 00       	call   802317 <insert_sorted_allocList>
  801841:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  801844:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801848:	75 07                	jne    801851 <smalloc+0x91>
		{
			return NULL;
  80184a:	b8 00 00 00 00       	mov    $0x0,%eax
  80184f:	eb 3f                	jmp    801890 <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  801851:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801854:	8b 40 08             	mov    0x8(%eax),%eax
  801857:	89 c2                	mov    %eax,%edx
  801859:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80185d:	52                   	push   %edx
  80185e:	50                   	push   %eax
  80185f:	ff 75 0c             	pushl  0xc(%ebp)
  801862:	ff 75 08             	pushl  0x8(%ebp)
  801865:	e8 45 04 00 00       	call   801caf <sys_createSharedObject>
  80186a:	83 c4 10             	add    $0x10,%esp
  80186d:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  801870:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801874:	74 06                	je     80187c <smalloc+0xbc>
  801876:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  80187a:	75 07                	jne    801883 <smalloc+0xc3>
		{
			return NULL;
  80187c:	b8 00 00 00 00       	mov    $0x0,%eax
  801881:	eb 0d                	jmp    801890 <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  801883:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801886:	8b 40 08             	mov    0x8(%eax),%eax
  801889:	eb 05                	jmp    801890 <smalloc+0xd0>
		}
	}
	else
		return NULL;
  80188b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801890:	c9                   	leave  
  801891:	c3                   	ret    

00801892 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801892:	55                   	push   %ebp
  801893:	89 e5                	mov    %esp,%ebp
  801895:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801898:	e8 2a fc ff ff       	call   8014c7 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80189d:	83 ec 08             	sub    $0x8,%esp
  8018a0:	ff 75 0c             	pushl  0xc(%ebp)
  8018a3:	ff 75 08             	pushl  0x8(%ebp)
  8018a6:	e8 2e 04 00 00       	call   801cd9 <sys_getSizeOfSharedObject>
  8018ab:	83 c4 10             	add    $0x10,%esp
  8018ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  8018b1:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8018b5:	75 0a                	jne    8018c1 <sget+0x2f>
	{
		return NULL;
  8018b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8018bc:	e9 94 00 00 00       	jmp    801955 <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8018c1:	e8 64 06 00 00       	call   801f2a <sys_isUHeapPlacementStrategyFIRSTFIT>
  8018c6:	85 c0                	test   %eax,%eax
  8018c8:	0f 84 82 00 00 00    	je     801950 <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  8018ce:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  8018d5:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8018dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018e2:	01 d0                	add    %edx,%eax
  8018e4:	48                   	dec    %eax
  8018e5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8018e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8018f0:	f7 75 ec             	divl   -0x14(%ebp)
  8018f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018f6:	29 d0                	sub    %edx,%eax
  8018f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  8018fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018fe:	83 ec 0c             	sub    $0xc,%esp
  801901:	50                   	push   %eax
  801902:	e8 10 0c 00 00       	call   802517 <alloc_block_FF>
  801907:	83 c4 10             	add    $0x10,%esp
  80190a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  80190d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801911:	75 07                	jne    80191a <sget+0x88>
		{
			return NULL;
  801913:	b8 00 00 00 00       	mov    $0x0,%eax
  801918:	eb 3b                	jmp    801955 <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  80191a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80191d:	8b 40 08             	mov    0x8(%eax),%eax
  801920:	83 ec 04             	sub    $0x4,%esp
  801923:	50                   	push   %eax
  801924:	ff 75 0c             	pushl  0xc(%ebp)
  801927:	ff 75 08             	pushl  0x8(%ebp)
  80192a:	e8 c7 03 00 00       	call   801cf6 <sys_getSharedObject>
  80192f:	83 c4 10             	add    $0x10,%esp
  801932:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  801935:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801939:	74 06                	je     801941 <sget+0xaf>
  80193b:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  80193f:	75 07                	jne    801948 <sget+0xb6>
		{
			return NULL;
  801941:	b8 00 00 00 00       	mov    $0x0,%eax
  801946:	eb 0d                	jmp    801955 <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  801948:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80194b:	8b 40 08             	mov    0x8(%eax),%eax
  80194e:	eb 05                	jmp    801955 <sget+0xc3>
		}
	}
	else
			return NULL;
  801950:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801955:	c9                   	leave  
  801956:	c3                   	ret    

00801957 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801957:	55                   	push   %ebp
  801958:	89 e5                	mov    %esp,%ebp
  80195a:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80195d:	e8 65 fb ff ff       	call   8014c7 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801962:	83 ec 04             	sub    $0x4,%esp
  801965:	68 a0 3b 80 00       	push   $0x803ba0
  80196a:	68 e1 00 00 00       	push   $0xe1
  80196f:	68 93 3b 80 00       	push   $0x803b93
  801974:	e8 ac 18 00 00       	call   803225 <_panic>

00801979 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801979:	55                   	push   %ebp
  80197a:	89 e5                	mov    %esp,%ebp
  80197c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80197f:	83 ec 04             	sub    $0x4,%esp
  801982:	68 c8 3b 80 00       	push   $0x803bc8
  801987:	68 f5 00 00 00       	push   $0xf5
  80198c:	68 93 3b 80 00       	push   $0x803b93
  801991:	e8 8f 18 00 00       	call   803225 <_panic>

00801996 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801996:	55                   	push   %ebp
  801997:	89 e5                	mov    %esp,%ebp
  801999:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80199c:	83 ec 04             	sub    $0x4,%esp
  80199f:	68 ec 3b 80 00       	push   $0x803bec
  8019a4:	68 00 01 00 00       	push   $0x100
  8019a9:	68 93 3b 80 00       	push   $0x803b93
  8019ae:	e8 72 18 00 00       	call   803225 <_panic>

008019b3 <shrink>:

}
void shrink(uint32 newSize)
{
  8019b3:	55                   	push   %ebp
  8019b4:	89 e5                	mov    %esp,%ebp
  8019b6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019b9:	83 ec 04             	sub    $0x4,%esp
  8019bc:	68 ec 3b 80 00       	push   $0x803bec
  8019c1:	68 05 01 00 00       	push   $0x105
  8019c6:	68 93 3b 80 00       	push   $0x803b93
  8019cb:	e8 55 18 00 00       	call   803225 <_panic>

008019d0 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8019d0:	55                   	push   %ebp
  8019d1:	89 e5                	mov    %esp,%ebp
  8019d3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019d6:	83 ec 04             	sub    $0x4,%esp
  8019d9:	68 ec 3b 80 00       	push   $0x803bec
  8019de:	68 0a 01 00 00       	push   $0x10a
  8019e3:	68 93 3b 80 00       	push   $0x803b93
  8019e8:	e8 38 18 00 00       	call   803225 <_panic>

008019ed <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8019ed:	55                   	push   %ebp
  8019ee:	89 e5                	mov    %esp,%ebp
  8019f0:	57                   	push   %edi
  8019f1:	56                   	push   %esi
  8019f2:	53                   	push   %ebx
  8019f3:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019fc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019ff:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a02:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a05:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a08:	cd 30                	int    $0x30
  801a0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a10:	83 c4 10             	add    $0x10,%esp
  801a13:	5b                   	pop    %ebx
  801a14:	5e                   	pop    %esi
  801a15:	5f                   	pop    %edi
  801a16:	5d                   	pop    %ebp
  801a17:	c3                   	ret    

00801a18 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a18:	55                   	push   %ebp
  801a19:	89 e5                	mov    %esp,%ebp
  801a1b:	83 ec 04             	sub    $0x4,%esp
  801a1e:	8b 45 10             	mov    0x10(%ebp),%eax
  801a21:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a24:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a28:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	52                   	push   %edx
  801a30:	ff 75 0c             	pushl  0xc(%ebp)
  801a33:	50                   	push   %eax
  801a34:	6a 00                	push   $0x0
  801a36:	e8 b2 ff ff ff       	call   8019ed <syscall>
  801a3b:	83 c4 18             	add    $0x18,%esp
}
  801a3e:	90                   	nop
  801a3f:	c9                   	leave  
  801a40:	c3                   	ret    

00801a41 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a41:	55                   	push   %ebp
  801a42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 01                	push   $0x1
  801a50:	e8 98 ff ff ff       	call   8019ed <syscall>
  801a55:	83 c4 18             	add    $0x18,%esp
}
  801a58:	c9                   	leave  
  801a59:	c3                   	ret    

00801a5a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a5a:	55                   	push   %ebp
  801a5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a60:	8b 45 08             	mov    0x8(%ebp),%eax
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	52                   	push   %edx
  801a6a:	50                   	push   %eax
  801a6b:	6a 05                	push   $0x5
  801a6d:	e8 7b ff ff ff       	call   8019ed <syscall>
  801a72:	83 c4 18             	add    $0x18,%esp
}
  801a75:	c9                   	leave  
  801a76:	c3                   	ret    

00801a77 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a77:	55                   	push   %ebp
  801a78:	89 e5                	mov    %esp,%ebp
  801a7a:	56                   	push   %esi
  801a7b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a7c:	8b 75 18             	mov    0x18(%ebp),%esi
  801a7f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a82:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a85:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a88:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8b:	56                   	push   %esi
  801a8c:	53                   	push   %ebx
  801a8d:	51                   	push   %ecx
  801a8e:	52                   	push   %edx
  801a8f:	50                   	push   %eax
  801a90:	6a 06                	push   $0x6
  801a92:	e8 56 ff ff ff       	call   8019ed <syscall>
  801a97:	83 c4 18             	add    $0x18,%esp
}
  801a9a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a9d:	5b                   	pop    %ebx
  801a9e:	5e                   	pop    %esi
  801a9f:	5d                   	pop    %ebp
  801aa0:	c3                   	ret    

00801aa1 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801aa1:	55                   	push   %ebp
  801aa2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801aa4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	52                   	push   %edx
  801ab1:	50                   	push   %eax
  801ab2:	6a 07                	push   $0x7
  801ab4:	e8 34 ff ff ff       	call   8019ed <syscall>
  801ab9:	83 c4 18             	add    $0x18,%esp
}
  801abc:	c9                   	leave  
  801abd:	c3                   	ret    

00801abe <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801abe:	55                   	push   %ebp
  801abf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	ff 75 0c             	pushl  0xc(%ebp)
  801aca:	ff 75 08             	pushl  0x8(%ebp)
  801acd:	6a 08                	push   $0x8
  801acf:	e8 19 ff ff ff       	call   8019ed <syscall>
  801ad4:	83 c4 18             	add    $0x18,%esp
}
  801ad7:	c9                   	leave  
  801ad8:	c3                   	ret    

00801ad9 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801ad9:	55                   	push   %ebp
  801ada:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 09                	push   $0x9
  801ae8:	e8 00 ff ff ff       	call   8019ed <syscall>
  801aed:	83 c4 18             	add    $0x18,%esp
}
  801af0:	c9                   	leave  
  801af1:	c3                   	ret    

00801af2 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801af2:	55                   	push   %ebp
  801af3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	6a 0a                	push   $0xa
  801b01:	e8 e7 fe ff ff       	call   8019ed <syscall>
  801b06:	83 c4 18             	add    $0x18,%esp
}
  801b09:	c9                   	leave  
  801b0a:	c3                   	ret    

00801b0b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b0b:	55                   	push   %ebp
  801b0c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 0b                	push   $0xb
  801b1a:	e8 ce fe ff ff       	call   8019ed <syscall>
  801b1f:	83 c4 18             	add    $0x18,%esp
}
  801b22:	c9                   	leave  
  801b23:	c3                   	ret    

00801b24 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b24:	55                   	push   %ebp
  801b25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	ff 75 0c             	pushl  0xc(%ebp)
  801b30:	ff 75 08             	pushl  0x8(%ebp)
  801b33:	6a 0f                	push   $0xf
  801b35:	e8 b3 fe ff ff       	call   8019ed <syscall>
  801b3a:	83 c4 18             	add    $0x18,%esp
	return;
  801b3d:	90                   	nop
}
  801b3e:	c9                   	leave  
  801b3f:	c3                   	ret    

00801b40 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	ff 75 0c             	pushl  0xc(%ebp)
  801b4c:	ff 75 08             	pushl  0x8(%ebp)
  801b4f:	6a 10                	push   $0x10
  801b51:	e8 97 fe ff ff       	call   8019ed <syscall>
  801b56:	83 c4 18             	add    $0x18,%esp
	return ;
  801b59:	90                   	nop
}
  801b5a:	c9                   	leave  
  801b5b:	c3                   	ret    

00801b5c <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b5c:	55                   	push   %ebp
  801b5d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	ff 75 10             	pushl  0x10(%ebp)
  801b66:	ff 75 0c             	pushl  0xc(%ebp)
  801b69:	ff 75 08             	pushl  0x8(%ebp)
  801b6c:	6a 11                	push   $0x11
  801b6e:	e8 7a fe ff ff       	call   8019ed <syscall>
  801b73:	83 c4 18             	add    $0x18,%esp
	return ;
  801b76:	90                   	nop
}
  801b77:	c9                   	leave  
  801b78:	c3                   	ret    

00801b79 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801b79:	55                   	push   %ebp
  801b7a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	6a 0c                	push   $0xc
  801b88:	e8 60 fe ff ff       	call   8019ed <syscall>
  801b8d:	83 c4 18             	add    $0x18,%esp
}
  801b90:	c9                   	leave  
  801b91:	c3                   	ret    

00801b92 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b92:	55                   	push   %ebp
  801b93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	ff 75 08             	pushl  0x8(%ebp)
  801ba0:	6a 0d                	push   $0xd
  801ba2:	e8 46 fe ff ff       	call   8019ed <syscall>
  801ba7:	83 c4 18             	add    $0x18,%esp
}
  801baa:	c9                   	leave  
  801bab:	c3                   	ret    

00801bac <sys_scarce_memory>:

void sys_scarce_memory()
{
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 0e                	push   $0xe
  801bbb:	e8 2d fe ff ff       	call   8019ed <syscall>
  801bc0:	83 c4 18             	add    $0x18,%esp
}
  801bc3:	90                   	nop
  801bc4:	c9                   	leave  
  801bc5:	c3                   	ret    

00801bc6 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801bc6:	55                   	push   %ebp
  801bc7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 13                	push   $0x13
  801bd5:	e8 13 fe ff ff       	call   8019ed <syscall>
  801bda:	83 c4 18             	add    $0x18,%esp
}
  801bdd:	90                   	nop
  801bde:	c9                   	leave  
  801bdf:	c3                   	ret    

00801be0 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 14                	push   $0x14
  801bef:	e8 f9 fd ff ff       	call   8019ed <syscall>
  801bf4:	83 c4 18             	add    $0x18,%esp
}
  801bf7:	90                   	nop
  801bf8:	c9                   	leave  
  801bf9:	c3                   	ret    

00801bfa <sys_cputc>:


void
sys_cputc(const char c)
{
  801bfa:	55                   	push   %ebp
  801bfb:	89 e5                	mov    %esp,%ebp
  801bfd:	83 ec 04             	sub    $0x4,%esp
  801c00:	8b 45 08             	mov    0x8(%ebp),%eax
  801c03:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c06:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	50                   	push   %eax
  801c13:	6a 15                	push   $0x15
  801c15:	e8 d3 fd ff ff       	call   8019ed <syscall>
  801c1a:	83 c4 18             	add    $0x18,%esp
}
  801c1d:	90                   	nop
  801c1e:	c9                   	leave  
  801c1f:	c3                   	ret    

00801c20 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c20:	55                   	push   %ebp
  801c21:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 16                	push   $0x16
  801c2f:	e8 b9 fd ff ff       	call   8019ed <syscall>
  801c34:	83 c4 18             	add    $0x18,%esp
}
  801c37:	90                   	nop
  801c38:	c9                   	leave  
  801c39:	c3                   	ret    

00801c3a <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801c3a:	55                   	push   %ebp
  801c3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	ff 75 0c             	pushl  0xc(%ebp)
  801c49:	50                   	push   %eax
  801c4a:	6a 17                	push   $0x17
  801c4c:	e8 9c fd ff ff       	call   8019ed <syscall>
  801c51:	83 c4 18             	add    $0x18,%esp
}
  801c54:	c9                   	leave  
  801c55:	c3                   	ret    

00801c56 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801c56:	55                   	push   %ebp
  801c57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c59:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	52                   	push   %edx
  801c66:	50                   	push   %eax
  801c67:	6a 1a                	push   $0x1a
  801c69:	e8 7f fd ff ff       	call   8019ed <syscall>
  801c6e:	83 c4 18             	add    $0x18,%esp
}
  801c71:	c9                   	leave  
  801c72:	c3                   	ret    

00801c73 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c73:	55                   	push   %ebp
  801c74:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c76:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c79:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	52                   	push   %edx
  801c83:	50                   	push   %eax
  801c84:	6a 18                	push   $0x18
  801c86:	e8 62 fd ff ff       	call   8019ed <syscall>
  801c8b:	83 c4 18             	add    $0x18,%esp
}
  801c8e:	90                   	nop
  801c8f:	c9                   	leave  
  801c90:	c3                   	ret    

00801c91 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c91:	55                   	push   %ebp
  801c92:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c94:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c97:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	52                   	push   %edx
  801ca1:	50                   	push   %eax
  801ca2:	6a 19                	push   $0x19
  801ca4:	e8 44 fd ff ff       	call   8019ed <syscall>
  801ca9:	83 c4 18             	add    $0x18,%esp
}
  801cac:	90                   	nop
  801cad:	c9                   	leave  
  801cae:	c3                   	ret    

00801caf <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801caf:	55                   	push   %ebp
  801cb0:	89 e5                	mov    %esp,%ebp
  801cb2:	83 ec 04             	sub    $0x4,%esp
  801cb5:	8b 45 10             	mov    0x10(%ebp),%eax
  801cb8:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801cbb:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cbe:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc5:	6a 00                	push   $0x0
  801cc7:	51                   	push   %ecx
  801cc8:	52                   	push   %edx
  801cc9:	ff 75 0c             	pushl  0xc(%ebp)
  801ccc:	50                   	push   %eax
  801ccd:	6a 1b                	push   $0x1b
  801ccf:	e8 19 fd ff ff       	call   8019ed <syscall>
  801cd4:	83 c4 18             	add    $0x18,%esp
}
  801cd7:	c9                   	leave  
  801cd8:	c3                   	ret    

00801cd9 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801cd9:	55                   	push   %ebp
  801cda:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801cdc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	52                   	push   %edx
  801ce9:	50                   	push   %eax
  801cea:	6a 1c                	push   $0x1c
  801cec:	e8 fc fc ff ff       	call   8019ed <syscall>
  801cf1:	83 c4 18             	add    $0x18,%esp
}
  801cf4:	c9                   	leave  
  801cf5:	c3                   	ret    

00801cf6 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801cf6:	55                   	push   %ebp
  801cf7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801cf9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cfc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cff:	8b 45 08             	mov    0x8(%ebp),%eax
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	51                   	push   %ecx
  801d07:	52                   	push   %edx
  801d08:	50                   	push   %eax
  801d09:	6a 1d                	push   $0x1d
  801d0b:	e8 dd fc ff ff       	call   8019ed <syscall>
  801d10:	83 c4 18             	add    $0x18,%esp
}
  801d13:	c9                   	leave  
  801d14:	c3                   	ret    

00801d15 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d18:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	52                   	push   %edx
  801d25:	50                   	push   %eax
  801d26:	6a 1e                	push   $0x1e
  801d28:	e8 c0 fc ff ff       	call   8019ed <syscall>
  801d2d:	83 c4 18             	add    $0x18,%esp
}
  801d30:	c9                   	leave  
  801d31:	c3                   	ret    

00801d32 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801d32:	55                   	push   %ebp
  801d33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801d35:	6a 00                	push   $0x0
  801d37:	6a 00                	push   $0x0
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 1f                	push   $0x1f
  801d41:	e8 a7 fc ff ff       	call   8019ed <syscall>
  801d46:	83 c4 18             	add    $0x18,%esp
}
  801d49:	c9                   	leave  
  801d4a:	c3                   	ret    

00801d4b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d4b:	55                   	push   %ebp
  801d4c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d51:	6a 00                	push   $0x0
  801d53:	ff 75 14             	pushl  0x14(%ebp)
  801d56:	ff 75 10             	pushl  0x10(%ebp)
  801d59:	ff 75 0c             	pushl  0xc(%ebp)
  801d5c:	50                   	push   %eax
  801d5d:	6a 20                	push   $0x20
  801d5f:	e8 89 fc ff ff       	call   8019ed <syscall>
  801d64:	83 c4 18             	add    $0x18,%esp
}
  801d67:	c9                   	leave  
  801d68:	c3                   	ret    

00801d69 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801d69:	55                   	push   %ebp
  801d6a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	50                   	push   %eax
  801d78:	6a 21                	push   $0x21
  801d7a:	e8 6e fc ff ff       	call   8019ed <syscall>
  801d7f:	83 c4 18             	add    $0x18,%esp
}
  801d82:	90                   	nop
  801d83:	c9                   	leave  
  801d84:	c3                   	ret    

00801d85 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d85:	55                   	push   %ebp
  801d86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d88:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	50                   	push   %eax
  801d94:	6a 22                	push   $0x22
  801d96:	e8 52 fc ff ff       	call   8019ed <syscall>
  801d9b:	83 c4 18             	add    $0x18,%esp
}
  801d9e:	c9                   	leave  
  801d9f:	c3                   	ret    

00801da0 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801da0:	55                   	push   %ebp
  801da1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	6a 02                	push   $0x2
  801daf:	e8 39 fc ff ff       	call   8019ed <syscall>
  801db4:	83 c4 18             	add    $0x18,%esp
}
  801db7:	c9                   	leave  
  801db8:	c3                   	ret    

00801db9 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801db9:	55                   	push   %ebp
  801dba:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 03                	push   $0x3
  801dc8:	e8 20 fc ff ff       	call   8019ed <syscall>
  801dcd:	83 c4 18             	add    $0x18,%esp
}
  801dd0:	c9                   	leave  
  801dd1:	c3                   	ret    

00801dd2 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801dd2:	55                   	push   %ebp
  801dd3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 04                	push   $0x4
  801de1:	e8 07 fc ff ff       	call   8019ed <syscall>
  801de6:	83 c4 18             	add    $0x18,%esp
}
  801de9:	c9                   	leave  
  801dea:	c3                   	ret    

00801deb <sys_exit_env>:


void sys_exit_env(void)
{
  801deb:	55                   	push   %ebp
  801dec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	6a 23                	push   $0x23
  801dfa:	e8 ee fb ff ff       	call   8019ed <syscall>
  801dff:	83 c4 18             	add    $0x18,%esp
}
  801e02:	90                   	nop
  801e03:	c9                   	leave  
  801e04:	c3                   	ret    

00801e05 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801e05:	55                   	push   %ebp
  801e06:	89 e5                	mov    %esp,%ebp
  801e08:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e0b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e0e:	8d 50 04             	lea    0x4(%eax),%edx
  801e11:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e14:	6a 00                	push   $0x0
  801e16:	6a 00                	push   $0x0
  801e18:	6a 00                	push   $0x0
  801e1a:	52                   	push   %edx
  801e1b:	50                   	push   %eax
  801e1c:	6a 24                	push   $0x24
  801e1e:	e8 ca fb ff ff       	call   8019ed <syscall>
  801e23:	83 c4 18             	add    $0x18,%esp
	return result;
  801e26:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e29:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e2c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e2f:	89 01                	mov    %eax,(%ecx)
  801e31:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e34:	8b 45 08             	mov    0x8(%ebp),%eax
  801e37:	c9                   	leave  
  801e38:	c2 04 00             	ret    $0x4

00801e3b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e3b:	55                   	push   %ebp
  801e3c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	ff 75 10             	pushl  0x10(%ebp)
  801e45:	ff 75 0c             	pushl  0xc(%ebp)
  801e48:	ff 75 08             	pushl  0x8(%ebp)
  801e4b:	6a 12                	push   $0x12
  801e4d:	e8 9b fb ff ff       	call   8019ed <syscall>
  801e52:	83 c4 18             	add    $0x18,%esp
	return ;
  801e55:	90                   	nop
}
  801e56:	c9                   	leave  
  801e57:	c3                   	ret    

00801e58 <sys_rcr2>:
uint32 sys_rcr2()
{
  801e58:	55                   	push   %ebp
  801e59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e5b:	6a 00                	push   $0x0
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 00                	push   $0x0
  801e63:	6a 00                	push   $0x0
  801e65:	6a 25                	push   $0x25
  801e67:	e8 81 fb ff ff       	call   8019ed <syscall>
  801e6c:	83 c4 18             	add    $0x18,%esp
}
  801e6f:	c9                   	leave  
  801e70:	c3                   	ret    

00801e71 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801e71:	55                   	push   %ebp
  801e72:	89 e5                	mov    %esp,%ebp
  801e74:	83 ec 04             	sub    $0x4,%esp
  801e77:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e7d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	6a 00                	push   $0x0
  801e89:	50                   	push   %eax
  801e8a:	6a 26                	push   $0x26
  801e8c:	e8 5c fb ff ff       	call   8019ed <syscall>
  801e91:	83 c4 18             	add    $0x18,%esp
	return ;
  801e94:	90                   	nop
}
  801e95:	c9                   	leave  
  801e96:	c3                   	ret    

00801e97 <rsttst>:
void rsttst()
{
  801e97:	55                   	push   %ebp
  801e98:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 00                	push   $0x0
  801ea0:	6a 00                	push   $0x0
  801ea2:	6a 00                	push   $0x0
  801ea4:	6a 28                	push   $0x28
  801ea6:	e8 42 fb ff ff       	call   8019ed <syscall>
  801eab:	83 c4 18             	add    $0x18,%esp
	return ;
  801eae:	90                   	nop
}
  801eaf:	c9                   	leave  
  801eb0:	c3                   	ret    

00801eb1 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801eb1:	55                   	push   %ebp
  801eb2:	89 e5                	mov    %esp,%ebp
  801eb4:	83 ec 04             	sub    $0x4,%esp
  801eb7:	8b 45 14             	mov    0x14(%ebp),%eax
  801eba:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ebd:	8b 55 18             	mov    0x18(%ebp),%edx
  801ec0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ec4:	52                   	push   %edx
  801ec5:	50                   	push   %eax
  801ec6:	ff 75 10             	pushl  0x10(%ebp)
  801ec9:	ff 75 0c             	pushl  0xc(%ebp)
  801ecc:	ff 75 08             	pushl  0x8(%ebp)
  801ecf:	6a 27                	push   $0x27
  801ed1:	e8 17 fb ff ff       	call   8019ed <syscall>
  801ed6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ed9:	90                   	nop
}
  801eda:	c9                   	leave  
  801edb:	c3                   	ret    

00801edc <chktst>:
void chktst(uint32 n)
{
  801edc:	55                   	push   %ebp
  801edd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801edf:	6a 00                	push   $0x0
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	ff 75 08             	pushl  0x8(%ebp)
  801eea:	6a 29                	push   $0x29
  801eec:	e8 fc fa ff ff       	call   8019ed <syscall>
  801ef1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ef4:	90                   	nop
}
  801ef5:	c9                   	leave  
  801ef6:	c3                   	ret    

00801ef7 <inctst>:

void inctst()
{
  801ef7:	55                   	push   %ebp
  801ef8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801efa:	6a 00                	push   $0x0
  801efc:	6a 00                	push   $0x0
  801efe:	6a 00                	push   $0x0
  801f00:	6a 00                	push   $0x0
  801f02:	6a 00                	push   $0x0
  801f04:	6a 2a                	push   $0x2a
  801f06:	e8 e2 fa ff ff       	call   8019ed <syscall>
  801f0b:	83 c4 18             	add    $0x18,%esp
	return ;
  801f0e:	90                   	nop
}
  801f0f:	c9                   	leave  
  801f10:	c3                   	ret    

00801f11 <gettst>:
uint32 gettst()
{
  801f11:	55                   	push   %ebp
  801f12:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f14:	6a 00                	push   $0x0
  801f16:	6a 00                	push   $0x0
  801f18:	6a 00                	push   $0x0
  801f1a:	6a 00                	push   $0x0
  801f1c:	6a 00                	push   $0x0
  801f1e:	6a 2b                	push   $0x2b
  801f20:	e8 c8 fa ff ff       	call   8019ed <syscall>
  801f25:	83 c4 18             	add    $0x18,%esp
}
  801f28:	c9                   	leave  
  801f29:	c3                   	ret    

00801f2a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f2a:	55                   	push   %ebp
  801f2b:	89 e5                	mov    %esp,%ebp
  801f2d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f30:	6a 00                	push   $0x0
  801f32:	6a 00                	push   $0x0
  801f34:	6a 00                	push   $0x0
  801f36:	6a 00                	push   $0x0
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 2c                	push   $0x2c
  801f3c:	e8 ac fa ff ff       	call   8019ed <syscall>
  801f41:	83 c4 18             	add    $0x18,%esp
  801f44:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f47:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f4b:	75 07                	jne    801f54 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f4d:	b8 01 00 00 00       	mov    $0x1,%eax
  801f52:	eb 05                	jmp    801f59 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f54:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f59:	c9                   	leave  
  801f5a:	c3                   	ret    

00801f5b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f5b:	55                   	push   %ebp
  801f5c:	89 e5                	mov    %esp,%ebp
  801f5e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f61:	6a 00                	push   $0x0
  801f63:	6a 00                	push   $0x0
  801f65:	6a 00                	push   $0x0
  801f67:	6a 00                	push   $0x0
  801f69:	6a 00                	push   $0x0
  801f6b:	6a 2c                	push   $0x2c
  801f6d:	e8 7b fa ff ff       	call   8019ed <syscall>
  801f72:	83 c4 18             	add    $0x18,%esp
  801f75:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f78:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f7c:	75 07                	jne    801f85 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f7e:	b8 01 00 00 00       	mov    $0x1,%eax
  801f83:	eb 05                	jmp    801f8a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f8a:	c9                   	leave  
  801f8b:	c3                   	ret    

00801f8c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f8c:	55                   	push   %ebp
  801f8d:	89 e5                	mov    %esp,%ebp
  801f8f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f92:	6a 00                	push   $0x0
  801f94:	6a 00                	push   $0x0
  801f96:	6a 00                	push   $0x0
  801f98:	6a 00                	push   $0x0
  801f9a:	6a 00                	push   $0x0
  801f9c:	6a 2c                	push   $0x2c
  801f9e:	e8 4a fa ff ff       	call   8019ed <syscall>
  801fa3:	83 c4 18             	add    $0x18,%esp
  801fa6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801fa9:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801fad:	75 07                	jne    801fb6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801faf:	b8 01 00 00 00       	mov    $0x1,%eax
  801fb4:	eb 05                	jmp    801fbb <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801fb6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fbb:	c9                   	leave  
  801fbc:	c3                   	ret    

00801fbd <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801fbd:	55                   	push   %ebp
  801fbe:	89 e5                	mov    %esp,%ebp
  801fc0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fc3:	6a 00                	push   $0x0
  801fc5:	6a 00                	push   $0x0
  801fc7:	6a 00                	push   $0x0
  801fc9:	6a 00                	push   $0x0
  801fcb:	6a 00                	push   $0x0
  801fcd:	6a 2c                	push   $0x2c
  801fcf:	e8 19 fa ff ff       	call   8019ed <syscall>
  801fd4:	83 c4 18             	add    $0x18,%esp
  801fd7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801fda:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801fde:	75 07                	jne    801fe7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801fe0:	b8 01 00 00 00       	mov    $0x1,%eax
  801fe5:	eb 05                	jmp    801fec <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801fe7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fec:	c9                   	leave  
  801fed:	c3                   	ret    

00801fee <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801fee:	55                   	push   %ebp
  801fef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ff1:	6a 00                	push   $0x0
  801ff3:	6a 00                	push   $0x0
  801ff5:	6a 00                	push   $0x0
  801ff7:	6a 00                	push   $0x0
  801ff9:	ff 75 08             	pushl  0x8(%ebp)
  801ffc:	6a 2d                	push   $0x2d
  801ffe:	e8 ea f9 ff ff       	call   8019ed <syscall>
  802003:	83 c4 18             	add    $0x18,%esp
	return ;
  802006:	90                   	nop
}
  802007:	c9                   	leave  
  802008:	c3                   	ret    

00802009 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802009:	55                   	push   %ebp
  80200a:	89 e5                	mov    %esp,%ebp
  80200c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80200d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802010:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802013:	8b 55 0c             	mov    0xc(%ebp),%edx
  802016:	8b 45 08             	mov    0x8(%ebp),%eax
  802019:	6a 00                	push   $0x0
  80201b:	53                   	push   %ebx
  80201c:	51                   	push   %ecx
  80201d:	52                   	push   %edx
  80201e:	50                   	push   %eax
  80201f:	6a 2e                	push   $0x2e
  802021:	e8 c7 f9 ff ff       	call   8019ed <syscall>
  802026:	83 c4 18             	add    $0x18,%esp
}
  802029:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80202c:	c9                   	leave  
  80202d:	c3                   	ret    

0080202e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80202e:	55                   	push   %ebp
  80202f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802031:	8b 55 0c             	mov    0xc(%ebp),%edx
  802034:	8b 45 08             	mov    0x8(%ebp),%eax
  802037:	6a 00                	push   $0x0
  802039:	6a 00                	push   $0x0
  80203b:	6a 00                	push   $0x0
  80203d:	52                   	push   %edx
  80203e:	50                   	push   %eax
  80203f:	6a 2f                	push   $0x2f
  802041:	e8 a7 f9 ff ff       	call   8019ed <syscall>
  802046:	83 c4 18             	add    $0x18,%esp
}
  802049:	c9                   	leave  
  80204a:	c3                   	ret    

0080204b <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80204b:	55                   	push   %ebp
  80204c:	89 e5                	mov    %esp,%ebp
  80204e:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802051:	83 ec 0c             	sub    $0xc,%esp
  802054:	68 fc 3b 80 00       	push   $0x803bfc
  802059:	e8 df e6 ff ff       	call   80073d <cprintf>
  80205e:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802061:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802068:	83 ec 0c             	sub    $0xc,%esp
  80206b:	68 28 3c 80 00       	push   $0x803c28
  802070:	e8 c8 e6 ff ff       	call   80073d <cprintf>
  802075:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802078:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80207c:	a1 38 41 80 00       	mov    0x804138,%eax
  802081:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802084:	eb 56                	jmp    8020dc <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802086:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80208a:	74 1c                	je     8020a8 <print_mem_block_lists+0x5d>
  80208c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208f:	8b 50 08             	mov    0x8(%eax),%edx
  802092:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802095:	8b 48 08             	mov    0x8(%eax),%ecx
  802098:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80209b:	8b 40 0c             	mov    0xc(%eax),%eax
  80209e:	01 c8                	add    %ecx,%eax
  8020a0:	39 c2                	cmp    %eax,%edx
  8020a2:	73 04                	jae    8020a8 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8020a4:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ab:	8b 50 08             	mov    0x8(%eax),%edx
  8020ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8020b4:	01 c2                	add    %eax,%edx
  8020b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b9:	8b 40 08             	mov    0x8(%eax),%eax
  8020bc:	83 ec 04             	sub    $0x4,%esp
  8020bf:	52                   	push   %edx
  8020c0:	50                   	push   %eax
  8020c1:	68 3d 3c 80 00       	push   $0x803c3d
  8020c6:	e8 72 e6 ff ff       	call   80073d <cprintf>
  8020cb:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8020ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8020d4:	a1 40 41 80 00       	mov    0x804140,%eax
  8020d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020e0:	74 07                	je     8020e9 <print_mem_block_lists+0x9e>
  8020e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e5:	8b 00                	mov    (%eax),%eax
  8020e7:	eb 05                	jmp    8020ee <print_mem_block_lists+0xa3>
  8020e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ee:	a3 40 41 80 00       	mov    %eax,0x804140
  8020f3:	a1 40 41 80 00       	mov    0x804140,%eax
  8020f8:	85 c0                	test   %eax,%eax
  8020fa:	75 8a                	jne    802086 <print_mem_block_lists+0x3b>
  8020fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802100:	75 84                	jne    802086 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802102:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802106:	75 10                	jne    802118 <print_mem_block_lists+0xcd>
  802108:	83 ec 0c             	sub    $0xc,%esp
  80210b:	68 4c 3c 80 00       	push   $0x803c4c
  802110:	e8 28 e6 ff ff       	call   80073d <cprintf>
  802115:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802118:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80211f:	83 ec 0c             	sub    $0xc,%esp
  802122:	68 70 3c 80 00       	push   $0x803c70
  802127:	e8 11 e6 ff ff       	call   80073d <cprintf>
  80212c:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80212f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802133:	a1 40 40 80 00       	mov    0x804040,%eax
  802138:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80213b:	eb 56                	jmp    802193 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80213d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802141:	74 1c                	je     80215f <print_mem_block_lists+0x114>
  802143:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802146:	8b 50 08             	mov    0x8(%eax),%edx
  802149:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80214c:	8b 48 08             	mov    0x8(%eax),%ecx
  80214f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802152:	8b 40 0c             	mov    0xc(%eax),%eax
  802155:	01 c8                	add    %ecx,%eax
  802157:	39 c2                	cmp    %eax,%edx
  802159:	73 04                	jae    80215f <print_mem_block_lists+0x114>
			sorted = 0 ;
  80215b:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80215f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802162:	8b 50 08             	mov    0x8(%eax),%edx
  802165:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802168:	8b 40 0c             	mov    0xc(%eax),%eax
  80216b:	01 c2                	add    %eax,%edx
  80216d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802170:	8b 40 08             	mov    0x8(%eax),%eax
  802173:	83 ec 04             	sub    $0x4,%esp
  802176:	52                   	push   %edx
  802177:	50                   	push   %eax
  802178:	68 3d 3c 80 00       	push   $0x803c3d
  80217d:	e8 bb e5 ff ff       	call   80073d <cprintf>
  802182:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802185:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802188:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80218b:	a1 48 40 80 00       	mov    0x804048,%eax
  802190:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802193:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802197:	74 07                	je     8021a0 <print_mem_block_lists+0x155>
  802199:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219c:	8b 00                	mov    (%eax),%eax
  80219e:	eb 05                	jmp    8021a5 <print_mem_block_lists+0x15a>
  8021a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8021a5:	a3 48 40 80 00       	mov    %eax,0x804048
  8021aa:	a1 48 40 80 00       	mov    0x804048,%eax
  8021af:	85 c0                	test   %eax,%eax
  8021b1:	75 8a                	jne    80213d <print_mem_block_lists+0xf2>
  8021b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021b7:	75 84                	jne    80213d <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8021b9:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8021bd:	75 10                	jne    8021cf <print_mem_block_lists+0x184>
  8021bf:	83 ec 0c             	sub    $0xc,%esp
  8021c2:	68 88 3c 80 00       	push   $0x803c88
  8021c7:	e8 71 e5 ff ff       	call   80073d <cprintf>
  8021cc:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8021cf:	83 ec 0c             	sub    $0xc,%esp
  8021d2:	68 fc 3b 80 00       	push   $0x803bfc
  8021d7:	e8 61 e5 ff ff       	call   80073d <cprintf>
  8021dc:	83 c4 10             	add    $0x10,%esp

}
  8021df:	90                   	nop
  8021e0:	c9                   	leave  
  8021e1:	c3                   	ret    

008021e2 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8021e2:	55                   	push   %ebp
  8021e3:	89 e5                	mov    %esp,%ebp
  8021e5:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8021e8:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  8021ef:	00 00 00 
  8021f2:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  8021f9:	00 00 00 
  8021fc:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802203:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  802206:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80220d:	e9 9e 00 00 00       	jmp    8022b0 <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802212:	a1 50 40 80 00       	mov    0x804050,%eax
  802217:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80221a:	c1 e2 04             	shl    $0x4,%edx
  80221d:	01 d0                	add    %edx,%eax
  80221f:	85 c0                	test   %eax,%eax
  802221:	75 14                	jne    802237 <initialize_MemBlocksList+0x55>
  802223:	83 ec 04             	sub    $0x4,%esp
  802226:	68 b0 3c 80 00       	push   $0x803cb0
  80222b:	6a 42                	push   $0x42
  80222d:	68 d3 3c 80 00       	push   $0x803cd3
  802232:	e8 ee 0f 00 00       	call   803225 <_panic>
  802237:	a1 50 40 80 00       	mov    0x804050,%eax
  80223c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80223f:	c1 e2 04             	shl    $0x4,%edx
  802242:	01 d0                	add    %edx,%eax
  802244:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80224a:	89 10                	mov    %edx,(%eax)
  80224c:	8b 00                	mov    (%eax),%eax
  80224e:	85 c0                	test   %eax,%eax
  802250:	74 18                	je     80226a <initialize_MemBlocksList+0x88>
  802252:	a1 48 41 80 00       	mov    0x804148,%eax
  802257:	8b 15 50 40 80 00    	mov    0x804050,%edx
  80225d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802260:	c1 e1 04             	shl    $0x4,%ecx
  802263:	01 ca                	add    %ecx,%edx
  802265:	89 50 04             	mov    %edx,0x4(%eax)
  802268:	eb 12                	jmp    80227c <initialize_MemBlocksList+0x9a>
  80226a:	a1 50 40 80 00       	mov    0x804050,%eax
  80226f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802272:	c1 e2 04             	shl    $0x4,%edx
  802275:	01 d0                	add    %edx,%eax
  802277:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80227c:	a1 50 40 80 00       	mov    0x804050,%eax
  802281:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802284:	c1 e2 04             	shl    $0x4,%edx
  802287:	01 d0                	add    %edx,%eax
  802289:	a3 48 41 80 00       	mov    %eax,0x804148
  80228e:	a1 50 40 80 00       	mov    0x804050,%eax
  802293:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802296:	c1 e2 04             	shl    $0x4,%edx
  802299:	01 d0                	add    %edx,%eax
  80229b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022a2:	a1 54 41 80 00       	mov    0x804154,%eax
  8022a7:	40                   	inc    %eax
  8022a8:	a3 54 41 80 00       	mov    %eax,0x804154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  8022ad:	ff 45 f4             	incl   -0xc(%ebp)
  8022b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022b6:	0f 82 56 ff ff ff    	jb     802212 <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  8022bc:	90                   	nop
  8022bd:	c9                   	leave  
  8022be:	c3                   	ret    

008022bf <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8022bf:	55                   	push   %ebp
  8022c0:	89 e5                	mov    %esp,%ebp
  8022c2:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  8022c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c8:	8b 00                	mov    (%eax),%eax
  8022ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8022cd:	eb 19                	jmp    8022e8 <find_block+0x29>
	{
		if(blk->sva==va)
  8022cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022d2:	8b 40 08             	mov    0x8(%eax),%eax
  8022d5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8022d8:	75 05                	jne    8022df <find_block+0x20>
			return (blk);
  8022da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022dd:	eb 36                	jmp    802315 <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  8022df:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e2:	8b 40 08             	mov    0x8(%eax),%eax
  8022e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8022e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8022ec:	74 07                	je     8022f5 <find_block+0x36>
  8022ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022f1:	8b 00                	mov    (%eax),%eax
  8022f3:	eb 05                	jmp    8022fa <find_block+0x3b>
  8022f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8022fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8022fd:	89 42 08             	mov    %eax,0x8(%edx)
  802300:	8b 45 08             	mov    0x8(%ebp),%eax
  802303:	8b 40 08             	mov    0x8(%eax),%eax
  802306:	85 c0                	test   %eax,%eax
  802308:	75 c5                	jne    8022cf <find_block+0x10>
  80230a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80230e:	75 bf                	jne    8022cf <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  802310:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802315:	c9                   	leave  
  802316:	c3                   	ret    

00802317 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802317:	55                   	push   %ebp
  802318:	89 e5                	mov    %esp,%ebp
  80231a:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  80231d:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802322:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802325:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  80232c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80232f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802332:	75 65                	jne    802399 <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802334:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802338:	75 14                	jne    80234e <insert_sorted_allocList+0x37>
  80233a:	83 ec 04             	sub    $0x4,%esp
  80233d:	68 b0 3c 80 00       	push   $0x803cb0
  802342:	6a 5c                	push   $0x5c
  802344:	68 d3 3c 80 00       	push   $0x803cd3
  802349:	e8 d7 0e 00 00       	call   803225 <_panic>
  80234e:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802354:	8b 45 08             	mov    0x8(%ebp),%eax
  802357:	89 10                	mov    %edx,(%eax)
  802359:	8b 45 08             	mov    0x8(%ebp),%eax
  80235c:	8b 00                	mov    (%eax),%eax
  80235e:	85 c0                	test   %eax,%eax
  802360:	74 0d                	je     80236f <insert_sorted_allocList+0x58>
  802362:	a1 40 40 80 00       	mov    0x804040,%eax
  802367:	8b 55 08             	mov    0x8(%ebp),%edx
  80236a:	89 50 04             	mov    %edx,0x4(%eax)
  80236d:	eb 08                	jmp    802377 <insert_sorted_allocList+0x60>
  80236f:	8b 45 08             	mov    0x8(%ebp),%eax
  802372:	a3 44 40 80 00       	mov    %eax,0x804044
  802377:	8b 45 08             	mov    0x8(%ebp),%eax
  80237a:	a3 40 40 80 00       	mov    %eax,0x804040
  80237f:	8b 45 08             	mov    0x8(%ebp),%eax
  802382:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802389:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80238e:	40                   	inc    %eax
  80238f:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  802394:	e9 7b 01 00 00       	jmp    802514 <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  802399:	a1 44 40 80 00       	mov    0x804044,%eax
  80239e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  8023a1:	a1 40 40 80 00       	mov    0x804040,%eax
  8023a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  8023a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ac:	8b 50 08             	mov    0x8(%eax),%edx
  8023af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023b2:	8b 40 08             	mov    0x8(%eax),%eax
  8023b5:	39 c2                	cmp    %eax,%edx
  8023b7:	76 65                	jbe    80241e <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  8023b9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023bd:	75 14                	jne    8023d3 <insert_sorted_allocList+0xbc>
  8023bf:	83 ec 04             	sub    $0x4,%esp
  8023c2:	68 ec 3c 80 00       	push   $0x803cec
  8023c7:	6a 64                	push   $0x64
  8023c9:	68 d3 3c 80 00       	push   $0x803cd3
  8023ce:	e8 52 0e 00 00       	call   803225 <_panic>
  8023d3:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8023d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023dc:	89 50 04             	mov    %edx,0x4(%eax)
  8023df:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e2:	8b 40 04             	mov    0x4(%eax),%eax
  8023e5:	85 c0                	test   %eax,%eax
  8023e7:	74 0c                	je     8023f5 <insert_sorted_allocList+0xde>
  8023e9:	a1 44 40 80 00       	mov    0x804044,%eax
  8023ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8023f1:	89 10                	mov    %edx,(%eax)
  8023f3:	eb 08                	jmp    8023fd <insert_sorted_allocList+0xe6>
  8023f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f8:	a3 40 40 80 00       	mov    %eax,0x804040
  8023fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802400:	a3 44 40 80 00       	mov    %eax,0x804044
  802405:	8b 45 08             	mov    0x8(%ebp),%eax
  802408:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80240e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802413:	40                   	inc    %eax
  802414:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  802419:	e9 f6 00 00 00       	jmp    802514 <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  80241e:	8b 45 08             	mov    0x8(%ebp),%eax
  802421:	8b 50 08             	mov    0x8(%eax),%edx
  802424:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802427:	8b 40 08             	mov    0x8(%eax),%eax
  80242a:	39 c2                	cmp    %eax,%edx
  80242c:	73 65                	jae    802493 <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80242e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802432:	75 14                	jne    802448 <insert_sorted_allocList+0x131>
  802434:	83 ec 04             	sub    $0x4,%esp
  802437:	68 b0 3c 80 00       	push   $0x803cb0
  80243c:	6a 68                	push   $0x68
  80243e:	68 d3 3c 80 00       	push   $0x803cd3
  802443:	e8 dd 0d 00 00       	call   803225 <_panic>
  802448:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80244e:	8b 45 08             	mov    0x8(%ebp),%eax
  802451:	89 10                	mov    %edx,(%eax)
  802453:	8b 45 08             	mov    0x8(%ebp),%eax
  802456:	8b 00                	mov    (%eax),%eax
  802458:	85 c0                	test   %eax,%eax
  80245a:	74 0d                	je     802469 <insert_sorted_allocList+0x152>
  80245c:	a1 40 40 80 00       	mov    0x804040,%eax
  802461:	8b 55 08             	mov    0x8(%ebp),%edx
  802464:	89 50 04             	mov    %edx,0x4(%eax)
  802467:	eb 08                	jmp    802471 <insert_sorted_allocList+0x15a>
  802469:	8b 45 08             	mov    0x8(%ebp),%eax
  80246c:	a3 44 40 80 00       	mov    %eax,0x804044
  802471:	8b 45 08             	mov    0x8(%ebp),%eax
  802474:	a3 40 40 80 00       	mov    %eax,0x804040
  802479:	8b 45 08             	mov    0x8(%ebp),%eax
  80247c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802483:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802488:	40                   	inc    %eax
  802489:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  80248e:	e9 81 00 00 00       	jmp    802514 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802493:	a1 40 40 80 00       	mov    0x804040,%eax
  802498:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80249b:	eb 51                	jmp    8024ee <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  80249d:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a0:	8b 50 08             	mov    0x8(%eax),%edx
  8024a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a6:	8b 40 08             	mov    0x8(%eax),%eax
  8024a9:	39 c2                	cmp    %eax,%edx
  8024ab:	73 39                	jae    8024e6 <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  8024ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b0:	8b 40 04             	mov    0x4(%eax),%eax
  8024b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  8024b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8024bc:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  8024be:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8024c4:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  8024c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024cd:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  8024cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8024d5:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  8024d8:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8024dd:	40                   	inc    %eax
  8024de:	a3 4c 40 80 00       	mov    %eax,0x80404c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  8024e3:	90                   	nop
				}
			}
		 }

	}
}
  8024e4:	eb 2e                	jmp    802514 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  8024e6:	a1 48 40 80 00       	mov    0x804048,%eax
  8024eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024f2:	74 07                	je     8024fb <insert_sorted_allocList+0x1e4>
  8024f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f7:	8b 00                	mov    (%eax),%eax
  8024f9:	eb 05                	jmp    802500 <insert_sorted_allocList+0x1e9>
  8024fb:	b8 00 00 00 00       	mov    $0x0,%eax
  802500:	a3 48 40 80 00       	mov    %eax,0x804048
  802505:	a1 48 40 80 00       	mov    0x804048,%eax
  80250a:	85 c0                	test   %eax,%eax
  80250c:	75 8f                	jne    80249d <insert_sorted_allocList+0x186>
  80250e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802512:	75 89                	jne    80249d <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  802514:	90                   	nop
  802515:	c9                   	leave  
  802516:	c3                   	ret    

00802517 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802517:	55                   	push   %ebp
  802518:	89 e5                	mov    %esp,%ebp
  80251a:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  80251d:	a1 38 41 80 00       	mov    0x804138,%eax
  802522:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802525:	e9 76 01 00 00       	jmp    8026a0 <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  80252a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252d:	8b 40 0c             	mov    0xc(%eax),%eax
  802530:	3b 45 08             	cmp    0x8(%ebp),%eax
  802533:	0f 85 8a 00 00 00    	jne    8025c3 <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  802539:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80253d:	75 17                	jne    802556 <alloc_block_FF+0x3f>
  80253f:	83 ec 04             	sub    $0x4,%esp
  802542:	68 0f 3d 80 00       	push   $0x803d0f
  802547:	68 8a 00 00 00       	push   $0x8a
  80254c:	68 d3 3c 80 00       	push   $0x803cd3
  802551:	e8 cf 0c 00 00       	call   803225 <_panic>
  802556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802559:	8b 00                	mov    (%eax),%eax
  80255b:	85 c0                	test   %eax,%eax
  80255d:	74 10                	je     80256f <alloc_block_FF+0x58>
  80255f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802562:	8b 00                	mov    (%eax),%eax
  802564:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802567:	8b 52 04             	mov    0x4(%edx),%edx
  80256a:	89 50 04             	mov    %edx,0x4(%eax)
  80256d:	eb 0b                	jmp    80257a <alloc_block_FF+0x63>
  80256f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802572:	8b 40 04             	mov    0x4(%eax),%eax
  802575:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80257a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257d:	8b 40 04             	mov    0x4(%eax),%eax
  802580:	85 c0                	test   %eax,%eax
  802582:	74 0f                	je     802593 <alloc_block_FF+0x7c>
  802584:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802587:	8b 40 04             	mov    0x4(%eax),%eax
  80258a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80258d:	8b 12                	mov    (%edx),%edx
  80258f:	89 10                	mov    %edx,(%eax)
  802591:	eb 0a                	jmp    80259d <alloc_block_FF+0x86>
  802593:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802596:	8b 00                	mov    (%eax),%eax
  802598:	a3 38 41 80 00       	mov    %eax,0x804138
  80259d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025b0:	a1 44 41 80 00       	mov    0x804144,%eax
  8025b5:	48                   	dec    %eax
  8025b6:	a3 44 41 80 00       	mov    %eax,0x804144
			return element;
  8025bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025be:	e9 10 01 00 00       	jmp    8026d3 <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  8025c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8025c9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025cc:	0f 86 c6 00 00 00    	jbe    802698 <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  8025d2:	a1 48 41 80 00       	mov    0x804148,%eax
  8025d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  8025da:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025de:	75 17                	jne    8025f7 <alloc_block_FF+0xe0>
  8025e0:	83 ec 04             	sub    $0x4,%esp
  8025e3:	68 0f 3d 80 00       	push   $0x803d0f
  8025e8:	68 90 00 00 00       	push   $0x90
  8025ed:	68 d3 3c 80 00       	push   $0x803cd3
  8025f2:	e8 2e 0c 00 00       	call   803225 <_panic>
  8025f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025fa:	8b 00                	mov    (%eax),%eax
  8025fc:	85 c0                	test   %eax,%eax
  8025fe:	74 10                	je     802610 <alloc_block_FF+0xf9>
  802600:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802603:	8b 00                	mov    (%eax),%eax
  802605:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802608:	8b 52 04             	mov    0x4(%edx),%edx
  80260b:	89 50 04             	mov    %edx,0x4(%eax)
  80260e:	eb 0b                	jmp    80261b <alloc_block_FF+0x104>
  802610:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802613:	8b 40 04             	mov    0x4(%eax),%eax
  802616:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80261b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80261e:	8b 40 04             	mov    0x4(%eax),%eax
  802621:	85 c0                	test   %eax,%eax
  802623:	74 0f                	je     802634 <alloc_block_FF+0x11d>
  802625:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802628:	8b 40 04             	mov    0x4(%eax),%eax
  80262b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80262e:	8b 12                	mov    (%edx),%edx
  802630:	89 10                	mov    %edx,(%eax)
  802632:	eb 0a                	jmp    80263e <alloc_block_FF+0x127>
  802634:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802637:	8b 00                	mov    (%eax),%eax
  802639:	a3 48 41 80 00       	mov    %eax,0x804148
  80263e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802641:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802647:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80264a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802651:	a1 54 41 80 00       	mov    0x804154,%eax
  802656:	48                   	dec    %eax
  802657:	a3 54 41 80 00       	mov    %eax,0x804154
			 element1->size =size;
  80265c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80265f:	8b 55 08             	mov    0x8(%ebp),%edx
  802662:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  802665:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802668:	8b 50 08             	mov    0x8(%eax),%edx
  80266b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80266e:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  802671:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802674:	8b 50 08             	mov    0x8(%eax),%edx
  802677:	8b 45 08             	mov    0x8(%ebp),%eax
  80267a:	01 c2                	add    %eax,%edx
  80267c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267f:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  802682:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802685:	8b 40 0c             	mov    0xc(%eax),%eax
  802688:	2b 45 08             	sub    0x8(%ebp),%eax
  80268b:	89 c2                	mov    %eax,%edx
  80268d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802690:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  802693:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802696:	eb 3b                	jmp    8026d3 <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802698:	a1 40 41 80 00       	mov    0x804140,%eax
  80269d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a4:	74 07                	je     8026ad <alloc_block_FF+0x196>
  8026a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a9:	8b 00                	mov    (%eax),%eax
  8026ab:	eb 05                	jmp    8026b2 <alloc_block_FF+0x19b>
  8026ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b2:	a3 40 41 80 00       	mov    %eax,0x804140
  8026b7:	a1 40 41 80 00       	mov    0x804140,%eax
  8026bc:	85 c0                	test   %eax,%eax
  8026be:	0f 85 66 fe ff ff    	jne    80252a <alloc_block_FF+0x13>
  8026c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026c8:	0f 85 5c fe ff ff    	jne    80252a <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  8026ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026d3:	c9                   	leave  
  8026d4:	c3                   	ret    

008026d5 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8026d5:	55                   	push   %ebp
  8026d6:	89 e5                	mov    %esp,%ebp
  8026d8:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  8026db:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  8026e2:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  8026e9:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8026f0:	a1 38 41 80 00       	mov    0x804138,%eax
  8026f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026f8:	e9 cf 00 00 00       	jmp    8027cc <alloc_block_BF+0xf7>
		{
			c++;
  8026fd:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  802700:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802703:	8b 40 0c             	mov    0xc(%eax),%eax
  802706:	3b 45 08             	cmp    0x8(%ebp),%eax
  802709:	0f 85 8a 00 00 00    	jne    802799 <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  80270f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802713:	75 17                	jne    80272c <alloc_block_BF+0x57>
  802715:	83 ec 04             	sub    $0x4,%esp
  802718:	68 0f 3d 80 00       	push   $0x803d0f
  80271d:	68 a8 00 00 00       	push   $0xa8
  802722:	68 d3 3c 80 00       	push   $0x803cd3
  802727:	e8 f9 0a 00 00       	call   803225 <_panic>
  80272c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272f:	8b 00                	mov    (%eax),%eax
  802731:	85 c0                	test   %eax,%eax
  802733:	74 10                	je     802745 <alloc_block_BF+0x70>
  802735:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802738:	8b 00                	mov    (%eax),%eax
  80273a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80273d:	8b 52 04             	mov    0x4(%edx),%edx
  802740:	89 50 04             	mov    %edx,0x4(%eax)
  802743:	eb 0b                	jmp    802750 <alloc_block_BF+0x7b>
  802745:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802748:	8b 40 04             	mov    0x4(%eax),%eax
  80274b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802750:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802753:	8b 40 04             	mov    0x4(%eax),%eax
  802756:	85 c0                	test   %eax,%eax
  802758:	74 0f                	je     802769 <alloc_block_BF+0x94>
  80275a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275d:	8b 40 04             	mov    0x4(%eax),%eax
  802760:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802763:	8b 12                	mov    (%edx),%edx
  802765:	89 10                	mov    %edx,(%eax)
  802767:	eb 0a                	jmp    802773 <alloc_block_BF+0x9e>
  802769:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276c:	8b 00                	mov    (%eax),%eax
  80276e:	a3 38 41 80 00       	mov    %eax,0x804138
  802773:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802776:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80277c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802786:	a1 44 41 80 00       	mov    0x804144,%eax
  80278b:	48                   	dec    %eax
  80278c:	a3 44 41 80 00       	mov    %eax,0x804144
				return block;
  802791:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802794:	e9 85 01 00 00       	jmp    80291e <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  802799:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279c:	8b 40 0c             	mov    0xc(%eax),%eax
  80279f:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027a2:	76 20                	jbe    8027c4 <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  8027a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8027aa:	2b 45 08             	sub    0x8(%ebp),%eax
  8027ad:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  8027b0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027b3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8027b6:	73 0c                	jae    8027c4 <alloc_block_BF+0xef>
				{
					ma=tempi;
  8027b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8027bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  8027be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027c1:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8027c4:	a1 40 41 80 00       	mov    0x804140,%eax
  8027c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027d0:	74 07                	je     8027d9 <alloc_block_BF+0x104>
  8027d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d5:	8b 00                	mov    (%eax),%eax
  8027d7:	eb 05                	jmp    8027de <alloc_block_BF+0x109>
  8027d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8027de:	a3 40 41 80 00       	mov    %eax,0x804140
  8027e3:	a1 40 41 80 00       	mov    0x804140,%eax
  8027e8:	85 c0                	test   %eax,%eax
  8027ea:	0f 85 0d ff ff ff    	jne    8026fd <alloc_block_BF+0x28>
  8027f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027f4:	0f 85 03 ff ff ff    	jne    8026fd <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  8027fa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802801:	a1 38 41 80 00       	mov    0x804138,%eax
  802806:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802809:	e9 dd 00 00 00       	jmp    8028eb <alloc_block_BF+0x216>
		{
			if(x==sol)
  80280e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802811:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802814:	0f 85 c6 00 00 00    	jne    8028e0 <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  80281a:	a1 48 41 80 00       	mov    0x804148,%eax
  80281f:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802822:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802826:	75 17                	jne    80283f <alloc_block_BF+0x16a>
  802828:	83 ec 04             	sub    $0x4,%esp
  80282b:	68 0f 3d 80 00       	push   $0x803d0f
  802830:	68 bb 00 00 00       	push   $0xbb
  802835:	68 d3 3c 80 00       	push   $0x803cd3
  80283a:	e8 e6 09 00 00       	call   803225 <_panic>
  80283f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802842:	8b 00                	mov    (%eax),%eax
  802844:	85 c0                	test   %eax,%eax
  802846:	74 10                	je     802858 <alloc_block_BF+0x183>
  802848:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80284b:	8b 00                	mov    (%eax),%eax
  80284d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802850:	8b 52 04             	mov    0x4(%edx),%edx
  802853:	89 50 04             	mov    %edx,0x4(%eax)
  802856:	eb 0b                	jmp    802863 <alloc_block_BF+0x18e>
  802858:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80285b:	8b 40 04             	mov    0x4(%eax),%eax
  80285e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802863:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802866:	8b 40 04             	mov    0x4(%eax),%eax
  802869:	85 c0                	test   %eax,%eax
  80286b:	74 0f                	je     80287c <alloc_block_BF+0x1a7>
  80286d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802870:	8b 40 04             	mov    0x4(%eax),%eax
  802873:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802876:	8b 12                	mov    (%edx),%edx
  802878:	89 10                	mov    %edx,(%eax)
  80287a:	eb 0a                	jmp    802886 <alloc_block_BF+0x1b1>
  80287c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80287f:	8b 00                	mov    (%eax),%eax
  802881:	a3 48 41 80 00       	mov    %eax,0x804148
  802886:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802889:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80288f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802892:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802899:	a1 54 41 80 00       	mov    0x804154,%eax
  80289e:	48                   	dec    %eax
  80289f:	a3 54 41 80 00       	mov    %eax,0x804154
						 element1->size =size;
  8028a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8028aa:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  8028ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b0:	8b 50 08             	mov    0x8(%eax),%edx
  8028b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028b6:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  8028b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bc:	8b 50 08             	mov    0x8(%eax),%edx
  8028bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c2:	01 c2                	add    %eax,%edx
  8028c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c7:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  8028ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8028d0:	2b 45 08             	sub    0x8(%ebp),%eax
  8028d3:	89 c2                	mov    %eax,%edx
  8028d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d8:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  8028db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028de:	eb 3e                	jmp    80291e <alloc_block_BF+0x249>
						 break;
			}
			x++;
  8028e0:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8028e3:	a1 40 41 80 00       	mov    0x804140,%eax
  8028e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028ef:	74 07                	je     8028f8 <alloc_block_BF+0x223>
  8028f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f4:	8b 00                	mov    (%eax),%eax
  8028f6:	eb 05                	jmp    8028fd <alloc_block_BF+0x228>
  8028f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8028fd:	a3 40 41 80 00       	mov    %eax,0x804140
  802902:	a1 40 41 80 00       	mov    0x804140,%eax
  802907:	85 c0                	test   %eax,%eax
  802909:	0f 85 ff fe ff ff    	jne    80280e <alloc_block_BF+0x139>
  80290f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802913:	0f 85 f5 fe ff ff    	jne    80280e <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  802919:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80291e:	c9                   	leave  
  80291f:	c3                   	ret    

00802920 <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802920:	55                   	push   %ebp
  802921:	89 e5                	mov    %esp,%ebp
  802923:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  802926:	a1 28 40 80 00       	mov    0x804028,%eax
  80292b:	85 c0                	test   %eax,%eax
  80292d:	75 14                	jne    802943 <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  80292f:	a1 38 41 80 00       	mov    0x804138,%eax
  802934:	a3 5c 41 80 00       	mov    %eax,0x80415c
		hh=1;
  802939:	c7 05 28 40 80 00 01 	movl   $0x1,0x804028
  802940:	00 00 00 
	}
	uint32 c=1;
  802943:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  80294a:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80294f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802952:	e9 b3 01 00 00       	jmp    802b0a <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  802957:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295a:	8b 40 0c             	mov    0xc(%eax),%eax
  80295d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802960:	0f 85 a9 00 00 00    	jne    802a0f <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  802966:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802969:	8b 00                	mov    (%eax),%eax
  80296b:	85 c0                	test   %eax,%eax
  80296d:	75 0c                	jne    80297b <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  80296f:	a1 38 41 80 00       	mov    0x804138,%eax
  802974:	a3 5c 41 80 00       	mov    %eax,0x80415c
  802979:	eb 0a                	jmp    802985 <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  80297b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80297e:	8b 00                	mov    (%eax),%eax
  802980:	a3 5c 41 80 00       	mov    %eax,0x80415c
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  802985:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802989:	75 17                	jne    8029a2 <alloc_block_NF+0x82>
  80298b:	83 ec 04             	sub    $0x4,%esp
  80298e:	68 0f 3d 80 00       	push   $0x803d0f
  802993:	68 e3 00 00 00       	push   $0xe3
  802998:	68 d3 3c 80 00       	push   $0x803cd3
  80299d:	e8 83 08 00 00       	call   803225 <_panic>
  8029a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a5:	8b 00                	mov    (%eax),%eax
  8029a7:	85 c0                	test   %eax,%eax
  8029a9:	74 10                	je     8029bb <alloc_block_NF+0x9b>
  8029ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ae:	8b 00                	mov    (%eax),%eax
  8029b0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029b3:	8b 52 04             	mov    0x4(%edx),%edx
  8029b6:	89 50 04             	mov    %edx,0x4(%eax)
  8029b9:	eb 0b                	jmp    8029c6 <alloc_block_NF+0xa6>
  8029bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029be:	8b 40 04             	mov    0x4(%eax),%eax
  8029c1:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c9:	8b 40 04             	mov    0x4(%eax),%eax
  8029cc:	85 c0                	test   %eax,%eax
  8029ce:	74 0f                	je     8029df <alloc_block_NF+0xbf>
  8029d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d3:	8b 40 04             	mov    0x4(%eax),%eax
  8029d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8029d9:	8b 12                	mov    (%edx),%edx
  8029db:	89 10                	mov    %edx,(%eax)
  8029dd:	eb 0a                	jmp    8029e9 <alloc_block_NF+0xc9>
  8029df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e2:	8b 00                	mov    (%eax),%eax
  8029e4:	a3 38 41 80 00       	mov    %eax,0x804138
  8029e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029fc:	a1 44 41 80 00       	mov    0x804144,%eax
  802a01:	48                   	dec    %eax
  802a02:	a3 44 41 80 00       	mov    %eax,0x804144
				return element;
  802a07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a0a:	e9 0e 01 00 00       	jmp    802b1d <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  802a0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a12:	8b 40 0c             	mov    0xc(%eax),%eax
  802a15:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a18:	0f 86 ce 00 00 00    	jbe    802aec <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802a1e:	a1 48 41 80 00       	mov    0x804148,%eax
  802a23:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802a26:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a2a:	75 17                	jne    802a43 <alloc_block_NF+0x123>
  802a2c:	83 ec 04             	sub    $0x4,%esp
  802a2f:	68 0f 3d 80 00       	push   $0x803d0f
  802a34:	68 e9 00 00 00       	push   $0xe9
  802a39:	68 d3 3c 80 00       	push   $0x803cd3
  802a3e:	e8 e2 07 00 00       	call   803225 <_panic>
  802a43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a46:	8b 00                	mov    (%eax),%eax
  802a48:	85 c0                	test   %eax,%eax
  802a4a:	74 10                	je     802a5c <alloc_block_NF+0x13c>
  802a4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a4f:	8b 00                	mov    (%eax),%eax
  802a51:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a54:	8b 52 04             	mov    0x4(%edx),%edx
  802a57:	89 50 04             	mov    %edx,0x4(%eax)
  802a5a:	eb 0b                	jmp    802a67 <alloc_block_NF+0x147>
  802a5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a5f:	8b 40 04             	mov    0x4(%eax),%eax
  802a62:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a67:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a6a:	8b 40 04             	mov    0x4(%eax),%eax
  802a6d:	85 c0                	test   %eax,%eax
  802a6f:	74 0f                	je     802a80 <alloc_block_NF+0x160>
  802a71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a74:	8b 40 04             	mov    0x4(%eax),%eax
  802a77:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a7a:	8b 12                	mov    (%edx),%edx
  802a7c:	89 10                	mov    %edx,(%eax)
  802a7e:	eb 0a                	jmp    802a8a <alloc_block_NF+0x16a>
  802a80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a83:	8b 00                	mov    (%eax),%eax
  802a85:	a3 48 41 80 00       	mov    %eax,0x804148
  802a8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a8d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a96:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a9d:	a1 54 41 80 00       	mov    0x804154,%eax
  802aa2:	48                   	dec    %eax
  802aa3:	a3 54 41 80 00       	mov    %eax,0x804154
				 element1->size =size;
  802aa8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aab:	8b 55 08             	mov    0x8(%ebp),%edx
  802aae:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  802ab1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab4:	8b 50 08             	mov    0x8(%eax),%edx
  802ab7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aba:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  802abd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac0:	8b 50 08             	mov    0x8(%eax),%edx
  802ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac6:	01 c2                	add    %eax,%edx
  802ac8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802acb:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  802ace:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ad4:	2b 45 08             	sub    0x8(%ebp),%eax
  802ad7:	89 c2                	mov    %eax,%edx
  802ad9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802adc:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  802adf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae2:	a3 5c 41 80 00       	mov    %eax,0x80415c
				 return element1;
  802ae7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aea:	eb 31                	jmp    802b1d <alloc_block_NF+0x1fd>
			 }
		 c++;
  802aec:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  802aef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af2:	8b 00                	mov    (%eax),%eax
  802af4:	85 c0                	test   %eax,%eax
  802af6:	75 0a                	jne    802b02 <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  802af8:	a1 38 41 80 00       	mov    0x804138,%eax
  802afd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802b00:	eb 08                	jmp    802b0a <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  802b02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b05:	8b 00                	mov    (%eax),%eax
  802b07:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802b0a:	a1 44 41 80 00       	mov    0x804144,%eax
  802b0f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802b12:	0f 85 3f fe ff ff    	jne    802957 <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  802b18:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b1d:	c9                   	leave  
  802b1e:	c3                   	ret    

00802b1f <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802b1f:	55                   	push   %ebp
  802b20:	89 e5                	mov    %esp,%ebp
  802b22:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  802b25:	a1 44 41 80 00       	mov    0x804144,%eax
  802b2a:	85 c0                	test   %eax,%eax
  802b2c:	75 68                	jne    802b96 <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802b2e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b32:	75 17                	jne    802b4b <insert_sorted_with_merge_freeList+0x2c>
  802b34:	83 ec 04             	sub    $0x4,%esp
  802b37:	68 b0 3c 80 00       	push   $0x803cb0
  802b3c:	68 0e 01 00 00       	push   $0x10e
  802b41:	68 d3 3c 80 00       	push   $0x803cd3
  802b46:	e8 da 06 00 00       	call   803225 <_panic>
  802b4b:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802b51:	8b 45 08             	mov    0x8(%ebp),%eax
  802b54:	89 10                	mov    %edx,(%eax)
  802b56:	8b 45 08             	mov    0x8(%ebp),%eax
  802b59:	8b 00                	mov    (%eax),%eax
  802b5b:	85 c0                	test   %eax,%eax
  802b5d:	74 0d                	je     802b6c <insert_sorted_with_merge_freeList+0x4d>
  802b5f:	a1 38 41 80 00       	mov    0x804138,%eax
  802b64:	8b 55 08             	mov    0x8(%ebp),%edx
  802b67:	89 50 04             	mov    %edx,0x4(%eax)
  802b6a:	eb 08                	jmp    802b74 <insert_sorted_with_merge_freeList+0x55>
  802b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b74:	8b 45 08             	mov    0x8(%ebp),%eax
  802b77:	a3 38 41 80 00       	mov    %eax,0x804138
  802b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b86:	a1 44 41 80 00       	mov    0x804144,%eax
  802b8b:	40                   	inc    %eax
  802b8c:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802b91:	e9 8c 06 00 00       	jmp    803222 <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  802b96:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  802b9e:	a1 38 41 80 00       	mov    0x804138,%eax
  802ba3:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  802ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba9:	8b 50 08             	mov    0x8(%eax),%edx
  802bac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802baf:	8b 40 08             	mov    0x8(%eax),%eax
  802bb2:	39 c2                	cmp    %eax,%edx
  802bb4:	0f 86 14 01 00 00    	jbe    802cce <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  802bba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bbd:	8b 50 0c             	mov    0xc(%eax),%edx
  802bc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc3:	8b 40 08             	mov    0x8(%eax),%eax
  802bc6:	01 c2                	add    %eax,%edx
  802bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcb:	8b 40 08             	mov    0x8(%eax),%eax
  802bce:	39 c2                	cmp    %eax,%edx
  802bd0:	0f 85 90 00 00 00    	jne    802c66 <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  802bd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd9:	8b 50 0c             	mov    0xc(%eax),%edx
  802bdc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdf:	8b 40 0c             	mov    0xc(%eax),%eax
  802be2:	01 c2                	add    %eax,%edx
  802be4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be7:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802bea:	8b 45 08             	mov    0x8(%ebp),%eax
  802bed:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802bfe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c02:	75 17                	jne    802c1b <insert_sorted_with_merge_freeList+0xfc>
  802c04:	83 ec 04             	sub    $0x4,%esp
  802c07:	68 b0 3c 80 00       	push   $0x803cb0
  802c0c:	68 1b 01 00 00       	push   $0x11b
  802c11:	68 d3 3c 80 00       	push   $0x803cd3
  802c16:	e8 0a 06 00 00       	call   803225 <_panic>
  802c1b:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c21:	8b 45 08             	mov    0x8(%ebp),%eax
  802c24:	89 10                	mov    %edx,(%eax)
  802c26:	8b 45 08             	mov    0x8(%ebp),%eax
  802c29:	8b 00                	mov    (%eax),%eax
  802c2b:	85 c0                	test   %eax,%eax
  802c2d:	74 0d                	je     802c3c <insert_sorted_with_merge_freeList+0x11d>
  802c2f:	a1 48 41 80 00       	mov    0x804148,%eax
  802c34:	8b 55 08             	mov    0x8(%ebp),%edx
  802c37:	89 50 04             	mov    %edx,0x4(%eax)
  802c3a:	eb 08                	jmp    802c44 <insert_sorted_with_merge_freeList+0x125>
  802c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c44:	8b 45 08             	mov    0x8(%ebp),%eax
  802c47:	a3 48 41 80 00       	mov    %eax,0x804148
  802c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c56:	a1 54 41 80 00       	mov    0x804154,%eax
  802c5b:	40                   	inc    %eax
  802c5c:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802c61:	e9 bc 05 00 00       	jmp    803222 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802c66:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c6a:	75 17                	jne    802c83 <insert_sorted_with_merge_freeList+0x164>
  802c6c:	83 ec 04             	sub    $0x4,%esp
  802c6f:	68 ec 3c 80 00       	push   $0x803cec
  802c74:	68 1f 01 00 00       	push   $0x11f
  802c79:	68 d3 3c 80 00       	push   $0x803cd3
  802c7e:	e8 a2 05 00 00       	call   803225 <_panic>
  802c83:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802c89:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8c:	89 50 04             	mov    %edx,0x4(%eax)
  802c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c92:	8b 40 04             	mov    0x4(%eax),%eax
  802c95:	85 c0                	test   %eax,%eax
  802c97:	74 0c                	je     802ca5 <insert_sorted_with_merge_freeList+0x186>
  802c99:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802c9e:	8b 55 08             	mov    0x8(%ebp),%edx
  802ca1:	89 10                	mov    %edx,(%eax)
  802ca3:	eb 08                	jmp    802cad <insert_sorted_with_merge_freeList+0x18e>
  802ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca8:	a3 38 41 80 00       	mov    %eax,0x804138
  802cad:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb0:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cbe:	a1 44 41 80 00       	mov    0x804144,%eax
  802cc3:	40                   	inc    %eax
  802cc4:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802cc9:	e9 54 05 00 00       	jmp    803222 <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  802cce:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd1:	8b 50 08             	mov    0x8(%eax),%edx
  802cd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cd7:	8b 40 08             	mov    0x8(%eax),%eax
  802cda:	39 c2                	cmp    %eax,%edx
  802cdc:	0f 83 20 01 00 00    	jae    802e02 <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  802ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce5:	8b 50 0c             	mov    0xc(%eax),%edx
  802ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ceb:	8b 40 08             	mov    0x8(%eax),%eax
  802cee:	01 c2                	add    %eax,%edx
  802cf0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cf3:	8b 40 08             	mov    0x8(%eax),%eax
  802cf6:	39 c2                	cmp    %eax,%edx
  802cf8:	0f 85 9c 00 00 00    	jne    802d9a <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  802cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802d01:	8b 50 08             	mov    0x8(%eax),%edx
  802d04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d07:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  802d0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d0d:	8b 50 0c             	mov    0xc(%eax),%edx
  802d10:	8b 45 08             	mov    0x8(%ebp),%eax
  802d13:	8b 40 0c             	mov    0xc(%eax),%eax
  802d16:	01 c2                	add    %eax,%edx
  802d18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d1b:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d21:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802d28:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802d32:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d36:	75 17                	jne    802d4f <insert_sorted_with_merge_freeList+0x230>
  802d38:	83 ec 04             	sub    $0x4,%esp
  802d3b:	68 b0 3c 80 00       	push   $0x803cb0
  802d40:	68 2a 01 00 00       	push   $0x12a
  802d45:	68 d3 3c 80 00       	push   $0x803cd3
  802d4a:	e8 d6 04 00 00       	call   803225 <_panic>
  802d4f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d55:	8b 45 08             	mov    0x8(%ebp),%eax
  802d58:	89 10                	mov    %edx,(%eax)
  802d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5d:	8b 00                	mov    (%eax),%eax
  802d5f:	85 c0                	test   %eax,%eax
  802d61:	74 0d                	je     802d70 <insert_sorted_with_merge_freeList+0x251>
  802d63:	a1 48 41 80 00       	mov    0x804148,%eax
  802d68:	8b 55 08             	mov    0x8(%ebp),%edx
  802d6b:	89 50 04             	mov    %edx,0x4(%eax)
  802d6e:	eb 08                	jmp    802d78 <insert_sorted_with_merge_freeList+0x259>
  802d70:	8b 45 08             	mov    0x8(%ebp),%eax
  802d73:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d78:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7b:	a3 48 41 80 00       	mov    %eax,0x804148
  802d80:	8b 45 08             	mov    0x8(%ebp),%eax
  802d83:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d8a:	a1 54 41 80 00       	mov    0x804154,%eax
  802d8f:	40                   	inc    %eax
  802d90:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802d95:	e9 88 04 00 00       	jmp    803222 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802d9a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d9e:	75 17                	jne    802db7 <insert_sorted_with_merge_freeList+0x298>
  802da0:	83 ec 04             	sub    $0x4,%esp
  802da3:	68 b0 3c 80 00       	push   $0x803cb0
  802da8:	68 2e 01 00 00       	push   $0x12e
  802dad:	68 d3 3c 80 00       	push   $0x803cd3
  802db2:	e8 6e 04 00 00       	call   803225 <_panic>
  802db7:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc0:	89 10                	mov    %edx,(%eax)
  802dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc5:	8b 00                	mov    (%eax),%eax
  802dc7:	85 c0                	test   %eax,%eax
  802dc9:	74 0d                	je     802dd8 <insert_sorted_with_merge_freeList+0x2b9>
  802dcb:	a1 38 41 80 00       	mov    0x804138,%eax
  802dd0:	8b 55 08             	mov    0x8(%ebp),%edx
  802dd3:	89 50 04             	mov    %edx,0x4(%eax)
  802dd6:	eb 08                	jmp    802de0 <insert_sorted_with_merge_freeList+0x2c1>
  802dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddb:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802de0:	8b 45 08             	mov    0x8(%ebp),%eax
  802de3:	a3 38 41 80 00       	mov    %eax,0x804138
  802de8:	8b 45 08             	mov    0x8(%ebp),%eax
  802deb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802df2:	a1 44 41 80 00       	mov    0x804144,%eax
  802df7:	40                   	inc    %eax
  802df8:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802dfd:	e9 20 04 00 00       	jmp    803222 <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  802e02:	a1 38 41 80 00       	mov    0x804138,%eax
  802e07:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e0a:	e9 e2 03 00 00       	jmp    8031f1 <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  802e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e12:	8b 50 08             	mov    0x8(%eax),%edx
  802e15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e18:	8b 40 08             	mov    0x8(%eax),%eax
  802e1b:	39 c2                	cmp    %eax,%edx
  802e1d:	0f 83 c6 03 00 00    	jae    8031e9 <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  802e23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e26:	8b 40 04             	mov    0x4(%eax),%eax
  802e29:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  802e2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e2f:	8b 50 08             	mov    0x8(%eax),%edx
  802e32:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e35:	8b 40 0c             	mov    0xc(%eax),%eax
  802e38:	01 d0                	add    %edx,%eax
  802e3a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  802e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e40:	8b 50 0c             	mov    0xc(%eax),%edx
  802e43:	8b 45 08             	mov    0x8(%ebp),%eax
  802e46:	8b 40 08             	mov    0x8(%eax),%eax
  802e49:	01 d0                	add    %edx,%eax
  802e4b:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  802e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e51:	8b 40 08             	mov    0x8(%eax),%eax
  802e54:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802e57:	74 7a                	je     802ed3 <insert_sorted_with_merge_freeList+0x3b4>
  802e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5c:	8b 40 08             	mov    0x8(%eax),%eax
  802e5f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802e62:	74 6f                	je     802ed3 <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  802e64:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e68:	74 06                	je     802e70 <insert_sorted_with_merge_freeList+0x351>
  802e6a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e6e:	75 17                	jne    802e87 <insert_sorted_with_merge_freeList+0x368>
  802e70:	83 ec 04             	sub    $0x4,%esp
  802e73:	68 30 3d 80 00       	push   $0x803d30
  802e78:	68 43 01 00 00       	push   $0x143
  802e7d:	68 d3 3c 80 00       	push   $0x803cd3
  802e82:	e8 9e 03 00 00       	call   803225 <_panic>
  802e87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8a:	8b 50 04             	mov    0x4(%eax),%edx
  802e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e90:	89 50 04             	mov    %edx,0x4(%eax)
  802e93:	8b 45 08             	mov    0x8(%ebp),%eax
  802e96:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e99:	89 10                	mov    %edx,(%eax)
  802e9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9e:	8b 40 04             	mov    0x4(%eax),%eax
  802ea1:	85 c0                	test   %eax,%eax
  802ea3:	74 0d                	je     802eb2 <insert_sorted_with_merge_freeList+0x393>
  802ea5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea8:	8b 40 04             	mov    0x4(%eax),%eax
  802eab:	8b 55 08             	mov    0x8(%ebp),%edx
  802eae:	89 10                	mov    %edx,(%eax)
  802eb0:	eb 08                	jmp    802eba <insert_sorted_with_merge_freeList+0x39b>
  802eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb5:	a3 38 41 80 00       	mov    %eax,0x804138
  802eba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebd:	8b 55 08             	mov    0x8(%ebp),%edx
  802ec0:	89 50 04             	mov    %edx,0x4(%eax)
  802ec3:	a1 44 41 80 00       	mov    0x804144,%eax
  802ec8:	40                   	inc    %eax
  802ec9:	a3 44 41 80 00       	mov    %eax,0x804144
  802ece:	e9 14 03 00 00       	jmp    8031e7 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  802ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed6:	8b 40 08             	mov    0x8(%eax),%eax
  802ed9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802edc:	0f 85 a0 01 00 00    	jne    803082 <insert_sorted_with_merge_freeList+0x563>
  802ee2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee5:	8b 40 08             	mov    0x8(%eax),%eax
  802ee8:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802eeb:	0f 85 91 01 00 00    	jne    803082 <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  802ef1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ef4:	8b 50 0c             	mov    0xc(%eax),%edx
  802ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  802efa:	8b 48 0c             	mov    0xc(%eax),%ecx
  802efd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f00:	8b 40 0c             	mov    0xc(%eax),%eax
  802f03:	01 c8                	add    %ecx,%eax
  802f05:	01 c2                	add    %eax,%edx
  802f07:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f0a:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f10:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802f17:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  802f21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f24:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  802f2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802f35:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f39:	75 17                	jne    802f52 <insert_sorted_with_merge_freeList+0x433>
  802f3b:	83 ec 04             	sub    $0x4,%esp
  802f3e:	68 b0 3c 80 00       	push   $0x803cb0
  802f43:	68 4d 01 00 00       	push   $0x14d
  802f48:	68 d3 3c 80 00       	push   $0x803cd3
  802f4d:	e8 d3 02 00 00       	call   803225 <_panic>
  802f52:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f58:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5b:	89 10                	mov    %edx,(%eax)
  802f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f60:	8b 00                	mov    (%eax),%eax
  802f62:	85 c0                	test   %eax,%eax
  802f64:	74 0d                	je     802f73 <insert_sorted_with_merge_freeList+0x454>
  802f66:	a1 48 41 80 00       	mov    0x804148,%eax
  802f6b:	8b 55 08             	mov    0x8(%ebp),%edx
  802f6e:	89 50 04             	mov    %edx,0x4(%eax)
  802f71:	eb 08                	jmp    802f7b <insert_sorted_with_merge_freeList+0x45c>
  802f73:	8b 45 08             	mov    0x8(%ebp),%eax
  802f76:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7e:	a3 48 41 80 00       	mov    %eax,0x804148
  802f83:	8b 45 08             	mov    0x8(%ebp),%eax
  802f86:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f8d:	a1 54 41 80 00       	mov    0x804154,%eax
  802f92:	40                   	inc    %eax
  802f93:	a3 54 41 80 00       	mov    %eax,0x804154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  802f98:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f9c:	75 17                	jne    802fb5 <insert_sorted_with_merge_freeList+0x496>
  802f9e:	83 ec 04             	sub    $0x4,%esp
  802fa1:	68 0f 3d 80 00       	push   $0x803d0f
  802fa6:	68 4e 01 00 00       	push   $0x14e
  802fab:	68 d3 3c 80 00       	push   $0x803cd3
  802fb0:	e8 70 02 00 00       	call   803225 <_panic>
  802fb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb8:	8b 00                	mov    (%eax),%eax
  802fba:	85 c0                	test   %eax,%eax
  802fbc:	74 10                	je     802fce <insert_sorted_with_merge_freeList+0x4af>
  802fbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc1:	8b 00                	mov    (%eax),%eax
  802fc3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fc6:	8b 52 04             	mov    0x4(%edx),%edx
  802fc9:	89 50 04             	mov    %edx,0x4(%eax)
  802fcc:	eb 0b                	jmp    802fd9 <insert_sorted_with_merge_freeList+0x4ba>
  802fce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd1:	8b 40 04             	mov    0x4(%eax),%eax
  802fd4:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802fd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fdc:	8b 40 04             	mov    0x4(%eax),%eax
  802fdf:	85 c0                	test   %eax,%eax
  802fe1:	74 0f                	je     802ff2 <insert_sorted_with_merge_freeList+0x4d3>
  802fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe6:	8b 40 04             	mov    0x4(%eax),%eax
  802fe9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fec:	8b 12                	mov    (%edx),%edx
  802fee:	89 10                	mov    %edx,(%eax)
  802ff0:	eb 0a                	jmp    802ffc <insert_sorted_with_merge_freeList+0x4dd>
  802ff2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff5:	8b 00                	mov    (%eax),%eax
  802ff7:	a3 38 41 80 00       	mov    %eax,0x804138
  802ffc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803005:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803008:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80300f:	a1 44 41 80 00       	mov    0x804144,%eax
  803014:	48                   	dec    %eax
  803015:	a3 44 41 80 00       	mov    %eax,0x804144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  80301a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80301e:	75 17                	jne    803037 <insert_sorted_with_merge_freeList+0x518>
  803020:	83 ec 04             	sub    $0x4,%esp
  803023:	68 b0 3c 80 00       	push   $0x803cb0
  803028:	68 4f 01 00 00       	push   $0x14f
  80302d:	68 d3 3c 80 00       	push   $0x803cd3
  803032:	e8 ee 01 00 00       	call   803225 <_panic>
  803037:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80303d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803040:	89 10                	mov    %edx,(%eax)
  803042:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803045:	8b 00                	mov    (%eax),%eax
  803047:	85 c0                	test   %eax,%eax
  803049:	74 0d                	je     803058 <insert_sorted_with_merge_freeList+0x539>
  80304b:	a1 48 41 80 00       	mov    0x804148,%eax
  803050:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803053:	89 50 04             	mov    %edx,0x4(%eax)
  803056:	eb 08                	jmp    803060 <insert_sorted_with_merge_freeList+0x541>
  803058:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803060:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803063:	a3 48 41 80 00       	mov    %eax,0x804148
  803068:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803072:	a1 54 41 80 00       	mov    0x804154,%eax
  803077:	40                   	inc    %eax
  803078:	a3 54 41 80 00       	mov    %eax,0x804154
  80307d:	e9 65 01 00 00       	jmp    8031e7 <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  803082:	8b 45 08             	mov    0x8(%ebp),%eax
  803085:	8b 40 08             	mov    0x8(%eax),%eax
  803088:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80308b:	0f 85 9f 00 00 00    	jne    803130 <insert_sorted_with_merge_freeList+0x611>
  803091:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803094:	8b 40 08             	mov    0x8(%eax),%eax
  803097:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80309a:	0f 84 90 00 00 00    	je     803130 <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  8030a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a3:	8b 50 0c             	mov    0xc(%eax),%edx
  8030a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8030ac:	01 c2                	add    %eax,%edx
  8030ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b1:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  8030b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  8030be:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8030c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030cc:	75 17                	jne    8030e5 <insert_sorted_with_merge_freeList+0x5c6>
  8030ce:	83 ec 04             	sub    $0x4,%esp
  8030d1:	68 b0 3c 80 00       	push   $0x803cb0
  8030d6:	68 58 01 00 00       	push   $0x158
  8030db:	68 d3 3c 80 00       	push   $0x803cd3
  8030e0:	e8 40 01 00 00       	call   803225 <_panic>
  8030e5:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8030eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ee:	89 10                	mov    %edx,(%eax)
  8030f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f3:	8b 00                	mov    (%eax),%eax
  8030f5:	85 c0                	test   %eax,%eax
  8030f7:	74 0d                	je     803106 <insert_sorted_with_merge_freeList+0x5e7>
  8030f9:	a1 48 41 80 00       	mov    0x804148,%eax
  8030fe:	8b 55 08             	mov    0x8(%ebp),%edx
  803101:	89 50 04             	mov    %edx,0x4(%eax)
  803104:	eb 08                	jmp    80310e <insert_sorted_with_merge_freeList+0x5ef>
  803106:	8b 45 08             	mov    0x8(%ebp),%eax
  803109:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80310e:	8b 45 08             	mov    0x8(%ebp),%eax
  803111:	a3 48 41 80 00       	mov    %eax,0x804148
  803116:	8b 45 08             	mov    0x8(%ebp),%eax
  803119:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803120:	a1 54 41 80 00       	mov    0x804154,%eax
  803125:	40                   	inc    %eax
  803126:	a3 54 41 80 00       	mov    %eax,0x804154
  80312b:	e9 b7 00 00 00       	jmp    8031e7 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  803130:	8b 45 08             	mov    0x8(%ebp),%eax
  803133:	8b 40 08             	mov    0x8(%eax),%eax
  803136:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803139:	0f 84 e2 00 00 00    	je     803221 <insert_sorted_with_merge_freeList+0x702>
  80313f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803142:	8b 40 08             	mov    0x8(%eax),%eax
  803145:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803148:	0f 85 d3 00 00 00    	jne    803221 <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  80314e:	8b 45 08             	mov    0x8(%ebp),%eax
  803151:	8b 50 08             	mov    0x8(%eax),%edx
  803154:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803157:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  80315a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315d:	8b 50 0c             	mov    0xc(%eax),%edx
  803160:	8b 45 08             	mov    0x8(%ebp),%eax
  803163:	8b 40 0c             	mov    0xc(%eax),%eax
  803166:	01 c2                	add    %eax,%edx
  803168:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316b:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  80316e:	8b 45 08             	mov    0x8(%ebp),%eax
  803171:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  803178:	8b 45 08             	mov    0x8(%ebp),%eax
  80317b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803182:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803186:	75 17                	jne    80319f <insert_sorted_with_merge_freeList+0x680>
  803188:	83 ec 04             	sub    $0x4,%esp
  80318b:	68 b0 3c 80 00       	push   $0x803cb0
  803190:	68 61 01 00 00       	push   $0x161
  803195:	68 d3 3c 80 00       	push   $0x803cd3
  80319a:	e8 86 00 00 00       	call   803225 <_panic>
  80319f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8031a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a8:	89 10                	mov    %edx,(%eax)
  8031aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ad:	8b 00                	mov    (%eax),%eax
  8031af:	85 c0                	test   %eax,%eax
  8031b1:	74 0d                	je     8031c0 <insert_sorted_with_merge_freeList+0x6a1>
  8031b3:	a1 48 41 80 00       	mov    0x804148,%eax
  8031b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8031bb:	89 50 04             	mov    %edx,0x4(%eax)
  8031be:	eb 08                	jmp    8031c8 <insert_sorted_with_merge_freeList+0x6a9>
  8031c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c3:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8031c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cb:	a3 48 41 80 00       	mov    %eax,0x804148
  8031d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031da:	a1 54 41 80 00       	mov    0x804154,%eax
  8031df:	40                   	inc    %eax
  8031e0:	a3 54 41 80 00       	mov    %eax,0x804154
								}
								break;
  8031e5:	eb 3a                	jmp    803221 <insert_sorted_with_merge_freeList+0x702>
  8031e7:	eb 38                	jmp    803221 <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  8031e9:	a1 40 41 80 00       	mov    0x804140,%eax
  8031ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031f5:	74 07                	je     8031fe <insert_sorted_with_merge_freeList+0x6df>
  8031f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031fa:	8b 00                	mov    (%eax),%eax
  8031fc:	eb 05                	jmp    803203 <insert_sorted_with_merge_freeList+0x6e4>
  8031fe:	b8 00 00 00 00       	mov    $0x0,%eax
  803203:	a3 40 41 80 00       	mov    %eax,0x804140
  803208:	a1 40 41 80 00       	mov    0x804140,%eax
  80320d:	85 c0                	test   %eax,%eax
  80320f:	0f 85 fa fb ff ff    	jne    802e0f <insert_sorted_with_merge_freeList+0x2f0>
  803215:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803219:	0f 85 f0 fb ff ff    	jne    802e0f <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  80321f:	eb 01                	jmp    803222 <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  803221:	90                   	nop
							}

						}
		          }
		}
}
  803222:	90                   	nop
  803223:	c9                   	leave  
  803224:	c3                   	ret    

00803225 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803225:	55                   	push   %ebp
  803226:	89 e5                	mov    %esp,%ebp
  803228:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80322b:	8d 45 10             	lea    0x10(%ebp),%eax
  80322e:	83 c0 04             	add    $0x4,%eax
  803231:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803234:	a1 60 41 80 00       	mov    0x804160,%eax
  803239:	85 c0                	test   %eax,%eax
  80323b:	74 16                	je     803253 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80323d:	a1 60 41 80 00       	mov    0x804160,%eax
  803242:	83 ec 08             	sub    $0x8,%esp
  803245:	50                   	push   %eax
  803246:	68 68 3d 80 00       	push   $0x803d68
  80324b:	e8 ed d4 ff ff       	call   80073d <cprintf>
  803250:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803253:	a1 00 40 80 00       	mov    0x804000,%eax
  803258:	ff 75 0c             	pushl  0xc(%ebp)
  80325b:	ff 75 08             	pushl  0x8(%ebp)
  80325e:	50                   	push   %eax
  80325f:	68 6d 3d 80 00       	push   $0x803d6d
  803264:	e8 d4 d4 ff ff       	call   80073d <cprintf>
  803269:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80326c:	8b 45 10             	mov    0x10(%ebp),%eax
  80326f:	83 ec 08             	sub    $0x8,%esp
  803272:	ff 75 f4             	pushl  -0xc(%ebp)
  803275:	50                   	push   %eax
  803276:	e8 57 d4 ff ff       	call   8006d2 <vcprintf>
  80327b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80327e:	83 ec 08             	sub    $0x8,%esp
  803281:	6a 00                	push   $0x0
  803283:	68 89 3d 80 00       	push   $0x803d89
  803288:	e8 45 d4 ff ff       	call   8006d2 <vcprintf>
  80328d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803290:	e8 c6 d3 ff ff       	call   80065b <exit>

	// should not return here
	while (1) ;
  803295:	eb fe                	jmp    803295 <_panic+0x70>

00803297 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803297:	55                   	push   %ebp
  803298:	89 e5                	mov    %esp,%ebp
  80329a:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80329d:	a1 20 40 80 00       	mov    0x804020,%eax
  8032a2:	8b 50 74             	mov    0x74(%eax),%edx
  8032a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032a8:	39 c2                	cmp    %eax,%edx
  8032aa:	74 14                	je     8032c0 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8032ac:	83 ec 04             	sub    $0x4,%esp
  8032af:	68 8c 3d 80 00       	push   $0x803d8c
  8032b4:	6a 26                	push   $0x26
  8032b6:	68 d8 3d 80 00       	push   $0x803dd8
  8032bb:	e8 65 ff ff ff       	call   803225 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8032c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8032c7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8032ce:	e9 c2 00 00 00       	jmp    803395 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8032d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032d6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8032dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e0:	01 d0                	add    %edx,%eax
  8032e2:	8b 00                	mov    (%eax),%eax
  8032e4:	85 c0                	test   %eax,%eax
  8032e6:	75 08                	jne    8032f0 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8032e8:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8032eb:	e9 a2 00 00 00       	jmp    803392 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8032f0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8032f7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8032fe:	eb 69                	jmp    803369 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803300:	a1 20 40 80 00       	mov    0x804020,%eax
  803305:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80330b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80330e:	89 d0                	mov    %edx,%eax
  803310:	01 c0                	add    %eax,%eax
  803312:	01 d0                	add    %edx,%eax
  803314:	c1 e0 03             	shl    $0x3,%eax
  803317:	01 c8                	add    %ecx,%eax
  803319:	8a 40 04             	mov    0x4(%eax),%al
  80331c:	84 c0                	test   %al,%al
  80331e:	75 46                	jne    803366 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803320:	a1 20 40 80 00       	mov    0x804020,%eax
  803325:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80332b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80332e:	89 d0                	mov    %edx,%eax
  803330:	01 c0                	add    %eax,%eax
  803332:	01 d0                	add    %edx,%eax
  803334:	c1 e0 03             	shl    $0x3,%eax
  803337:	01 c8                	add    %ecx,%eax
  803339:	8b 00                	mov    (%eax),%eax
  80333b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80333e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803341:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803346:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803348:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80334b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803352:	8b 45 08             	mov    0x8(%ebp),%eax
  803355:	01 c8                	add    %ecx,%eax
  803357:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803359:	39 c2                	cmp    %eax,%edx
  80335b:	75 09                	jne    803366 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80335d:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803364:	eb 12                	jmp    803378 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803366:	ff 45 e8             	incl   -0x18(%ebp)
  803369:	a1 20 40 80 00       	mov    0x804020,%eax
  80336e:	8b 50 74             	mov    0x74(%eax),%edx
  803371:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803374:	39 c2                	cmp    %eax,%edx
  803376:	77 88                	ja     803300 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803378:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80337c:	75 14                	jne    803392 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80337e:	83 ec 04             	sub    $0x4,%esp
  803381:	68 e4 3d 80 00       	push   $0x803de4
  803386:	6a 3a                	push   $0x3a
  803388:	68 d8 3d 80 00       	push   $0x803dd8
  80338d:	e8 93 fe ff ff       	call   803225 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803392:	ff 45 f0             	incl   -0x10(%ebp)
  803395:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803398:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80339b:	0f 8c 32 ff ff ff    	jl     8032d3 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8033a1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8033a8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8033af:	eb 26                	jmp    8033d7 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8033b1:	a1 20 40 80 00       	mov    0x804020,%eax
  8033b6:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8033bc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033bf:	89 d0                	mov    %edx,%eax
  8033c1:	01 c0                	add    %eax,%eax
  8033c3:	01 d0                	add    %edx,%eax
  8033c5:	c1 e0 03             	shl    $0x3,%eax
  8033c8:	01 c8                	add    %ecx,%eax
  8033ca:	8a 40 04             	mov    0x4(%eax),%al
  8033cd:	3c 01                	cmp    $0x1,%al
  8033cf:	75 03                	jne    8033d4 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8033d1:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8033d4:	ff 45 e0             	incl   -0x20(%ebp)
  8033d7:	a1 20 40 80 00       	mov    0x804020,%eax
  8033dc:	8b 50 74             	mov    0x74(%eax),%edx
  8033df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033e2:	39 c2                	cmp    %eax,%edx
  8033e4:	77 cb                	ja     8033b1 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8033e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8033ec:	74 14                	je     803402 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8033ee:	83 ec 04             	sub    $0x4,%esp
  8033f1:	68 38 3e 80 00       	push   $0x803e38
  8033f6:	6a 44                	push   $0x44
  8033f8:	68 d8 3d 80 00       	push   $0x803dd8
  8033fd:	e8 23 fe ff ff       	call   803225 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803402:	90                   	nop
  803403:	c9                   	leave  
  803404:	c3                   	ret    
  803405:	66 90                	xchg   %ax,%ax
  803407:	90                   	nop

00803408 <__udivdi3>:
  803408:	55                   	push   %ebp
  803409:	57                   	push   %edi
  80340a:	56                   	push   %esi
  80340b:	53                   	push   %ebx
  80340c:	83 ec 1c             	sub    $0x1c,%esp
  80340f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803413:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803417:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80341b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80341f:	89 ca                	mov    %ecx,%edx
  803421:	89 f8                	mov    %edi,%eax
  803423:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803427:	85 f6                	test   %esi,%esi
  803429:	75 2d                	jne    803458 <__udivdi3+0x50>
  80342b:	39 cf                	cmp    %ecx,%edi
  80342d:	77 65                	ja     803494 <__udivdi3+0x8c>
  80342f:	89 fd                	mov    %edi,%ebp
  803431:	85 ff                	test   %edi,%edi
  803433:	75 0b                	jne    803440 <__udivdi3+0x38>
  803435:	b8 01 00 00 00       	mov    $0x1,%eax
  80343a:	31 d2                	xor    %edx,%edx
  80343c:	f7 f7                	div    %edi
  80343e:	89 c5                	mov    %eax,%ebp
  803440:	31 d2                	xor    %edx,%edx
  803442:	89 c8                	mov    %ecx,%eax
  803444:	f7 f5                	div    %ebp
  803446:	89 c1                	mov    %eax,%ecx
  803448:	89 d8                	mov    %ebx,%eax
  80344a:	f7 f5                	div    %ebp
  80344c:	89 cf                	mov    %ecx,%edi
  80344e:	89 fa                	mov    %edi,%edx
  803450:	83 c4 1c             	add    $0x1c,%esp
  803453:	5b                   	pop    %ebx
  803454:	5e                   	pop    %esi
  803455:	5f                   	pop    %edi
  803456:	5d                   	pop    %ebp
  803457:	c3                   	ret    
  803458:	39 ce                	cmp    %ecx,%esi
  80345a:	77 28                	ja     803484 <__udivdi3+0x7c>
  80345c:	0f bd fe             	bsr    %esi,%edi
  80345f:	83 f7 1f             	xor    $0x1f,%edi
  803462:	75 40                	jne    8034a4 <__udivdi3+0x9c>
  803464:	39 ce                	cmp    %ecx,%esi
  803466:	72 0a                	jb     803472 <__udivdi3+0x6a>
  803468:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80346c:	0f 87 9e 00 00 00    	ja     803510 <__udivdi3+0x108>
  803472:	b8 01 00 00 00       	mov    $0x1,%eax
  803477:	89 fa                	mov    %edi,%edx
  803479:	83 c4 1c             	add    $0x1c,%esp
  80347c:	5b                   	pop    %ebx
  80347d:	5e                   	pop    %esi
  80347e:	5f                   	pop    %edi
  80347f:	5d                   	pop    %ebp
  803480:	c3                   	ret    
  803481:	8d 76 00             	lea    0x0(%esi),%esi
  803484:	31 ff                	xor    %edi,%edi
  803486:	31 c0                	xor    %eax,%eax
  803488:	89 fa                	mov    %edi,%edx
  80348a:	83 c4 1c             	add    $0x1c,%esp
  80348d:	5b                   	pop    %ebx
  80348e:	5e                   	pop    %esi
  80348f:	5f                   	pop    %edi
  803490:	5d                   	pop    %ebp
  803491:	c3                   	ret    
  803492:	66 90                	xchg   %ax,%ax
  803494:	89 d8                	mov    %ebx,%eax
  803496:	f7 f7                	div    %edi
  803498:	31 ff                	xor    %edi,%edi
  80349a:	89 fa                	mov    %edi,%edx
  80349c:	83 c4 1c             	add    $0x1c,%esp
  80349f:	5b                   	pop    %ebx
  8034a0:	5e                   	pop    %esi
  8034a1:	5f                   	pop    %edi
  8034a2:	5d                   	pop    %ebp
  8034a3:	c3                   	ret    
  8034a4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8034a9:	89 eb                	mov    %ebp,%ebx
  8034ab:	29 fb                	sub    %edi,%ebx
  8034ad:	89 f9                	mov    %edi,%ecx
  8034af:	d3 e6                	shl    %cl,%esi
  8034b1:	89 c5                	mov    %eax,%ebp
  8034b3:	88 d9                	mov    %bl,%cl
  8034b5:	d3 ed                	shr    %cl,%ebp
  8034b7:	89 e9                	mov    %ebp,%ecx
  8034b9:	09 f1                	or     %esi,%ecx
  8034bb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8034bf:	89 f9                	mov    %edi,%ecx
  8034c1:	d3 e0                	shl    %cl,%eax
  8034c3:	89 c5                	mov    %eax,%ebp
  8034c5:	89 d6                	mov    %edx,%esi
  8034c7:	88 d9                	mov    %bl,%cl
  8034c9:	d3 ee                	shr    %cl,%esi
  8034cb:	89 f9                	mov    %edi,%ecx
  8034cd:	d3 e2                	shl    %cl,%edx
  8034cf:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034d3:	88 d9                	mov    %bl,%cl
  8034d5:	d3 e8                	shr    %cl,%eax
  8034d7:	09 c2                	or     %eax,%edx
  8034d9:	89 d0                	mov    %edx,%eax
  8034db:	89 f2                	mov    %esi,%edx
  8034dd:	f7 74 24 0c          	divl   0xc(%esp)
  8034e1:	89 d6                	mov    %edx,%esi
  8034e3:	89 c3                	mov    %eax,%ebx
  8034e5:	f7 e5                	mul    %ebp
  8034e7:	39 d6                	cmp    %edx,%esi
  8034e9:	72 19                	jb     803504 <__udivdi3+0xfc>
  8034eb:	74 0b                	je     8034f8 <__udivdi3+0xf0>
  8034ed:	89 d8                	mov    %ebx,%eax
  8034ef:	31 ff                	xor    %edi,%edi
  8034f1:	e9 58 ff ff ff       	jmp    80344e <__udivdi3+0x46>
  8034f6:	66 90                	xchg   %ax,%ax
  8034f8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8034fc:	89 f9                	mov    %edi,%ecx
  8034fe:	d3 e2                	shl    %cl,%edx
  803500:	39 c2                	cmp    %eax,%edx
  803502:	73 e9                	jae    8034ed <__udivdi3+0xe5>
  803504:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803507:	31 ff                	xor    %edi,%edi
  803509:	e9 40 ff ff ff       	jmp    80344e <__udivdi3+0x46>
  80350e:	66 90                	xchg   %ax,%ax
  803510:	31 c0                	xor    %eax,%eax
  803512:	e9 37 ff ff ff       	jmp    80344e <__udivdi3+0x46>
  803517:	90                   	nop

00803518 <__umoddi3>:
  803518:	55                   	push   %ebp
  803519:	57                   	push   %edi
  80351a:	56                   	push   %esi
  80351b:	53                   	push   %ebx
  80351c:	83 ec 1c             	sub    $0x1c,%esp
  80351f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803523:	8b 74 24 34          	mov    0x34(%esp),%esi
  803527:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80352b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80352f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803533:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803537:	89 f3                	mov    %esi,%ebx
  803539:	89 fa                	mov    %edi,%edx
  80353b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80353f:	89 34 24             	mov    %esi,(%esp)
  803542:	85 c0                	test   %eax,%eax
  803544:	75 1a                	jne    803560 <__umoddi3+0x48>
  803546:	39 f7                	cmp    %esi,%edi
  803548:	0f 86 a2 00 00 00    	jbe    8035f0 <__umoddi3+0xd8>
  80354e:	89 c8                	mov    %ecx,%eax
  803550:	89 f2                	mov    %esi,%edx
  803552:	f7 f7                	div    %edi
  803554:	89 d0                	mov    %edx,%eax
  803556:	31 d2                	xor    %edx,%edx
  803558:	83 c4 1c             	add    $0x1c,%esp
  80355b:	5b                   	pop    %ebx
  80355c:	5e                   	pop    %esi
  80355d:	5f                   	pop    %edi
  80355e:	5d                   	pop    %ebp
  80355f:	c3                   	ret    
  803560:	39 f0                	cmp    %esi,%eax
  803562:	0f 87 ac 00 00 00    	ja     803614 <__umoddi3+0xfc>
  803568:	0f bd e8             	bsr    %eax,%ebp
  80356b:	83 f5 1f             	xor    $0x1f,%ebp
  80356e:	0f 84 ac 00 00 00    	je     803620 <__umoddi3+0x108>
  803574:	bf 20 00 00 00       	mov    $0x20,%edi
  803579:	29 ef                	sub    %ebp,%edi
  80357b:	89 fe                	mov    %edi,%esi
  80357d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803581:	89 e9                	mov    %ebp,%ecx
  803583:	d3 e0                	shl    %cl,%eax
  803585:	89 d7                	mov    %edx,%edi
  803587:	89 f1                	mov    %esi,%ecx
  803589:	d3 ef                	shr    %cl,%edi
  80358b:	09 c7                	or     %eax,%edi
  80358d:	89 e9                	mov    %ebp,%ecx
  80358f:	d3 e2                	shl    %cl,%edx
  803591:	89 14 24             	mov    %edx,(%esp)
  803594:	89 d8                	mov    %ebx,%eax
  803596:	d3 e0                	shl    %cl,%eax
  803598:	89 c2                	mov    %eax,%edx
  80359a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80359e:	d3 e0                	shl    %cl,%eax
  8035a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035a4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035a8:	89 f1                	mov    %esi,%ecx
  8035aa:	d3 e8                	shr    %cl,%eax
  8035ac:	09 d0                	or     %edx,%eax
  8035ae:	d3 eb                	shr    %cl,%ebx
  8035b0:	89 da                	mov    %ebx,%edx
  8035b2:	f7 f7                	div    %edi
  8035b4:	89 d3                	mov    %edx,%ebx
  8035b6:	f7 24 24             	mull   (%esp)
  8035b9:	89 c6                	mov    %eax,%esi
  8035bb:	89 d1                	mov    %edx,%ecx
  8035bd:	39 d3                	cmp    %edx,%ebx
  8035bf:	0f 82 87 00 00 00    	jb     80364c <__umoddi3+0x134>
  8035c5:	0f 84 91 00 00 00    	je     80365c <__umoddi3+0x144>
  8035cb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8035cf:	29 f2                	sub    %esi,%edx
  8035d1:	19 cb                	sbb    %ecx,%ebx
  8035d3:	89 d8                	mov    %ebx,%eax
  8035d5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8035d9:	d3 e0                	shl    %cl,%eax
  8035db:	89 e9                	mov    %ebp,%ecx
  8035dd:	d3 ea                	shr    %cl,%edx
  8035df:	09 d0                	or     %edx,%eax
  8035e1:	89 e9                	mov    %ebp,%ecx
  8035e3:	d3 eb                	shr    %cl,%ebx
  8035e5:	89 da                	mov    %ebx,%edx
  8035e7:	83 c4 1c             	add    $0x1c,%esp
  8035ea:	5b                   	pop    %ebx
  8035eb:	5e                   	pop    %esi
  8035ec:	5f                   	pop    %edi
  8035ed:	5d                   	pop    %ebp
  8035ee:	c3                   	ret    
  8035ef:	90                   	nop
  8035f0:	89 fd                	mov    %edi,%ebp
  8035f2:	85 ff                	test   %edi,%edi
  8035f4:	75 0b                	jne    803601 <__umoddi3+0xe9>
  8035f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8035fb:	31 d2                	xor    %edx,%edx
  8035fd:	f7 f7                	div    %edi
  8035ff:	89 c5                	mov    %eax,%ebp
  803601:	89 f0                	mov    %esi,%eax
  803603:	31 d2                	xor    %edx,%edx
  803605:	f7 f5                	div    %ebp
  803607:	89 c8                	mov    %ecx,%eax
  803609:	f7 f5                	div    %ebp
  80360b:	89 d0                	mov    %edx,%eax
  80360d:	e9 44 ff ff ff       	jmp    803556 <__umoddi3+0x3e>
  803612:	66 90                	xchg   %ax,%ax
  803614:	89 c8                	mov    %ecx,%eax
  803616:	89 f2                	mov    %esi,%edx
  803618:	83 c4 1c             	add    $0x1c,%esp
  80361b:	5b                   	pop    %ebx
  80361c:	5e                   	pop    %esi
  80361d:	5f                   	pop    %edi
  80361e:	5d                   	pop    %ebp
  80361f:	c3                   	ret    
  803620:	3b 04 24             	cmp    (%esp),%eax
  803623:	72 06                	jb     80362b <__umoddi3+0x113>
  803625:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803629:	77 0f                	ja     80363a <__umoddi3+0x122>
  80362b:	89 f2                	mov    %esi,%edx
  80362d:	29 f9                	sub    %edi,%ecx
  80362f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803633:	89 14 24             	mov    %edx,(%esp)
  803636:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80363a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80363e:	8b 14 24             	mov    (%esp),%edx
  803641:	83 c4 1c             	add    $0x1c,%esp
  803644:	5b                   	pop    %ebx
  803645:	5e                   	pop    %esi
  803646:	5f                   	pop    %edi
  803647:	5d                   	pop    %ebp
  803648:	c3                   	ret    
  803649:	8d 76 00             	lea    0x0(%esi),%esi
  80364c:	2b 04 24             	sub    (%esp),%eax
  80364f:	19 fa                	sbb    %edi,%edx
  803651:	89 d1                	mov    %edx,%ecx
  803653:	89 c6                	mov    %eax,%esi
  803655:	e9 71 ff ff ff       	jmp    8035cb <__umoddi3+0xb3>
  80365a:	66 90                	xchg   %ax,%ax
  80365c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803660:	72 ea                	jb     80364c <__umoddi3+0x134>
  803662:	89 d9                	mov    %ebx,%ecx
  803664:	e9 62 ff ff ff       	jmp    8035cb <__umoddi3+0xb3>

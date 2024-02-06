
obj/user/tst_quicksort_freeHeap:     file format elf32-i386


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
  800031:	e8 30 08 00 00       	call   800866 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
uint32 CheckSorted(int *Elements, int NumOfElements);

int CheckAndCountEmptyLocInWS(volatile struct Env *myEnv);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec 44 01 00 00    	sub    $0x144,%esp


	//int InitFreeFrames = sys_calculate_free_frames() ;
	char Line[255] ;
	char Chose ;
	int Iteration = 0 ;
  800042:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	do
	{

		Iteration++ ;
  800049:	ff 45 f0             	incl   -0x10(%ebp)
		//		cprintf("Free Frames Before Allocation = %d\n", sys_calculate_free_frames()) ;

	sys_disable_interrupt();
  80004c:	e8 94 22 00 00       	call   8022e5 <sys_disable_interrupt>
		readline("Enter the number of elements: ", Line);
  800051:	83 ec 08             	sub    $0x8,%esp
  800054:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  80005a:	50                   	push   %eax
  80005b:	68 c0 3b 80 00       	push   $0x803bc0
  800060:	e8 73 12 00 00       	call   8012d8 <readline>
  800065:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  800068:	83 ec 04             	sub    $0x4,%esp
  80006b:	6a 0a                	push   $0xa
  80006d:	6a 00                	push   $0x0
  80006f:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  800075:	50                   	push   %eax
  800076:	e8 c3 17 00 00       	call   80183e <strtol>
  80007b:	83 c4 10             	add    $0x10,%esp
  80007e:	89 45 ec             	mov    %eax,-0x14(%ebp)

		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  800081:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800084:	c1 e0 02             	shl    $0x2,%eax
  800087:	83 ec 0c             	sub    $0xc,%esp
  80008a:	50                   	push   %eax
  80008b:	e8 fb 1c 00 00       	call   801d8b <malloc>
  800090:	83 c4 10             	add    $0x10,%esp
  800093:	89 45 e8             	mov    %eax,-0x18(%ebp)
		uint32 num_disk_tables = 1;  //Since it is created with the first array, so it will be decremented in the 1st case only
  800096:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
		int numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  80009d:	a1 24 50 80 00       	mov    0x805024,%eax
  8000a2:	83 ec 0c             	sub    $0xc,%esp
  8000a5:	50                   	push   %eax
  8000a6:	e8 88 03 00 00       	call   800433 <CheckAndCountEmptyLocInWS>
  8000ab:	83 c4 10             	add    $0x10,%esp
  8000ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
		int InitFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  8000b1:	e8 42 21 00 00       	call   8021f8 <sys_calculate_free_frames>
  8000b6:	89 c3                	mov    %eax,%ebx
  8000b8:	e8 54 21 00 00       	call   802211 <sys_calculate_modified_frames>
  8000bd:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  8000c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000c3:	29 c2                	sub    %eax,%edx
  8000c5:	89 d0                	mov    %edx,%eax
  8000c7:	89 45 dc             	mov    %eax,-0x24(%ebp)

		Elements[NumOfElements] = 10 ;
  8000ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000cd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000d7:	01 d0                	add    %edx,%eax
  8000d9:	c7 00 0a 00 00 00    	movl   $0xa,(%eax)
		//		cprintf("Free Frames After Allocation = %d\n", sys_calculate_free_frames()) ;
		cprintf("Choose the initialization method:\n") ;
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	68 e0 3b 80 00       	push   $0x803be0
  8000e7:	e8 6a 0b 00 00       	call   800c56 <cprintf>
  8000ec:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000ef:	83 ec 0c             	sub    $0xc,%esp
  8000f2:	68 03 3c 80 00       	push   $0x803c03
  8000f7:	e8 5a 0b 00 00       	call   800c56 <cprintf>
  8000fc:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	68 11 3c 80 00       	push   $0x803c11
  800107:	e8 4a 0b 00 00       	call   800c56 <cprintf>
  80010c:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n") ;
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 20 3c 80 00       	push   $0x803c20
  800117:	e8 3a 0b 00 00       	call   800c56 <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	68 30 3c 80 00       	push   $0x803c30
  800127:	e8 2a 0b 00 00       	call   800c56 <cprintf>
  80012c:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012f:	e8 da 06 00 00       	call   80080e <getchar>
  800134:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  800137:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80013b:	83 ec 0c             	sub    $0xc,%esp
  80013e:	50                   	push   %eax
  80013f:	e8 82 06 00 00       	call   8007c6 <cputchar>
  800144:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800147:	83 ec 0c             	sub    $0xc,%esp
  80014a:	6a 0a                	push   $0xa
  80014c:	e8 75 06 00 00       	call   8007c6 <cputchar>
  800151:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800154:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  800158:	74 0c                	je     800166 <_main+0x12e>
  80015a:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  80015e:	74 06                	je     800166 <_main+0x12e>
  800160:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800164:	75 b9                	jne    80011f <_main+0xe7>
	sys_enable_interrupt();
  800166:	e8 94 21 00 00       	call   8022ff <sys_enable_interrupt>
		int  i ;
		switch (Chose)
  80016b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80016f:	83 f8 62             	cmp    $0x62,%eax
  800172:	74 1d                	je     800191 <_main+0x159>
  800174:	83 f8 63             	cmp    $0x63,%eax
  800177:	74 2b                	je     8001a4 <_main+0x16c>
  800179:	83 f8 61             	cmp    $0x61,%eax
  80017c:	75 39                	jne    8001b7 <_main+0x17f>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80017e:	83 ec 08             	sub    $0x8,%esp
  800181:	ff 75 ec             	pushl  -0x14(%ebp)
  800184:	ff 75 e8             	pushl  -0x18(%ebp)
  800187:	e8 02 05 00 00       	call   80068e <InitializeAscending>
  80018c:	83 c4 10             	add    $0x10,%esp
			break ;
  80018f:	eb 37                	jmp    8001c8 <_main+0x190>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  800191:	83 ec 08             	sub    $0x8,%esp
  800194:	ff 75 ec             	pushl  -0x14(%ebp)
  800197:	ff 75 e8             	pushl  -0x18(%ebp)
  80019a:	e8 20 05 00 00       	call   8006bf <InitializeDescending>
  80019f:	83 c4 10             	add    $0x10,%esp
			break ;
  8001a2:	eb 24                	jmp    8001c8 <_main+0x190>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a4:	83 ec 08             	sub    $0x8,%esp
  8001a7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001aa:	ff 75 e8             	pushl  -0x18(%ebp)
  8001ad:	e8 42 05 00 00       	call   8006f4 <InitializeSemiRandom>
  8001b2:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b5:	eb 11                	jmp    8001c8 <_main+0x190>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b7:	83 ec 08             	sub    $0x8,%esp
  8001ba:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bd:	ff 75 e8             	pushl  -0x18(%ebp)
  8001c0:	e8 2f 05 00 00       	call   8006f4 <InitializeSemiRandom>
  8001c5:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001c8:	83 ec 08             	sub    $0x8,%esp
  8001cb:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ce:	ff 75 e8             	pushl  -0x18(%ebp)
  8001d1:	e8 fd 02 00 00       	call   8004d3 <QuickSort>
  8001d6:	83 c4 10             	add    $0x10,%esp

		//		PrintElements(Elements, NumOfElements);

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001d9:	83 ec 08             	sub    $0x8,%esp
  8001dc:	ff 75 ec             	pushl  -0x14(%ebp)
  8001df:	ff 75 e8             	pushl  -0x18(%ebp)
  8001e2:	e8 fd 03 00 00       	call   8005e4 <CheckSorted>
  8001e7:	83 c4 10             	add    $0x10,%esp
  8001ea:	89 45 d8             	mov    %eax,-0x28(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001ed:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8001f1:	75 14                	jne    800207 <_main+0x1cf>
  8001f3:	83 ec 04             	sub    $0x4,%esp
  8001f6:	68 3c 3c 80 00       	push   $0x803c3c
  8001fb:	6a 57                	push   $0x57
  8001fd:	68 5e 3c 80 00       	push   $0x803c5e
  800202:	e8 9b 07 00 00       	call   8009a2 <_panic>
		else
		{
			cprintf("===============================================\n") ;
  800207:	83 ec 0c             	sub    $0xc,%esp
  80020a:	68 7c 3c 80 00       	push   $0x803c7c
  80020f:	e8 42 0a 00 00       	call   800c56 <cprintf>
  800214:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800217:	83 ec 0c             	sub    $0xc,%esp
  80021a:	68 b0 3c 80 00       	push   $0x803cb0
  80021f:	e8 32 0a 00 00       	call   800c56 <cprintf>
  800224:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800227:	83 ec 0c             	sub    $0xc,%esp
  80022a:	68 e4 3c 80 00       	push   $0x803ce4
  80022f:	e8 22 0a 00 00       	call   800c56 <cprintf>
  800234:	83 c4 10             	add    $0x10,%esp
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		cprintf("Freeing the Heap...\n\n") ;
  800237:	83 ec 0c             	sub    $0xc,%esp
  80023a:	68 16 3d 80 00       	push   $0x803d16
  80023f:	e8 12 0a 00 00       	call   800c56 <cprintf>
  800244:	83 c4 10             	add    $0x10,%esp
		free(Elements) ;
  800247:	83 ec 0c             	sub    $0xc,%esp
  80024a:	ff 75 e8             	pushl  -0x18(%ebp)
  80024d:	e8 bb 1b 00 00       	call   801e0d <free>
  800252:	83 c4 10             	add    $0x10,%esp


		///Testing the freeHeap according to the specified scenario
		if (Iteration == 1)
  800255:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  800259:	75 7b                	jne    8002d6 <_main+0x29e>
		{
			InitFreeFrames -= num_disk_tables;
  80025b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80025e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800261:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (!(NumOfElements == 1000 && Chose == 'a'))
  800264:	81 7d ec e8 03 00 00 	cmpl   $0x3e8,-0x14(%ebp)
  80026b:	75 06                	jne    800273 <_main+0x23b>
  80026d:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  800271:	74 14                	je     800287 <_main+0x24f>
				panic("Please ensure the number of elements and the initialization method of this test");
  800273:	83 ec 04             	sub    $0x4,%esp
  800276:	68 2c 3d 80 00       	push   $0x803d2c
  80027b:	6a 6a                	push   $0x6a
  80027d:	68 5e 3c 80 00       	push   $0x803c5e
  800282:	e8 1b 07 00 00       	call   8009a2 <_panic>

			numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  800287:	a1 24 50 80 00       	mov    0x805024,%eax
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	50                   	push   %eax
  800290:	e8 9e 01 00 00       	call   800433 <CheckAndCountEmptyLocInWS>
  800295:	83 c4 10             	add    $0x10,%esp
  800298:	89 45 e0             	mov    %eax,-0x20(%ebp)
			int CurrFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  80029b:	e8 58 1f 00 00       	call   8021f8 <sys_calculate_free_frames>
  8002a0:	89 c3                	mov    %eax,%ebx
  8002a2:	e8 6a 1f 00 00       	call   802211 <sys_calculate_modified_frames>
  8002a7:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  8002aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002ad:	29 c2                	sub    %eax,%edx
  8002af:	89 d0                	mov    %edx,%eax
  8002b1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
  8002b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002b7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8002ba:	0f 84 05 01 00 00    	je     8003c5 <_main+0x38d>
  8002c0:	68 7c 3d 80 00       	push   $0x803d7c
  8002c5:	68 a1 3d 80 00       	push   $0x803da1
  8002ca:	6a 6e                	push   $0x6e
  8002cc:	68 5e 3c 80 00       	push   $0x803c5e
  8002d1:	e8 cc 06 00 00       	call   8009a2 <_panic>
		}
		else if (Iteration == 2 )
  8002d6:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  8002da:	75 72                	jne    80034e <_main+0x316>
		{
			if (!(NumOfElements == 5000 && Chose == 'b'))
  8002dc:	81 7d ec 88 13 00 00 	cmpl   $0x1388,-0x14(%ebp)
  8002e3:	75 06                	jne    8002eb <_main+0x2b3>
  8002e5:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  8002e9:	74 14                	je     8002ff <_main+0x2c7>
				panic("Please ensure the number of elements and the initialization method of this test");
  8002eb:	83 ec 04             	sub    $0x4,%esp
  8002ee:	68 2c 3d 80 00       	push   $0x803d2c
  8002f3:	6a 73                	push   $0x73
  8002f5:	68 5e 3c 80 00       	push   $0x803c5e
  8002fa:	e8 a3 06 00 00       	call   8009a2 <_panic>

			int numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  8002ff:	a1 24 50 80 00       	mov    0x805024,%eax
  800304:	83 ec 0c             	sub    $0xc,%esp
  800307:	50                   	push   %eax
  800308:	e8 26 01 00 00       	call   800433 <CheckAndCountEmptyLocInWS>
  80030d:	83 c4 10             	add    $0x10,%esp
  800310:	89 45 d0             	mov    %eax,-0x30(%ebp)
			int CurrFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  800313:	e8 e0 1e 00 00       	call   8021f8 <sys_calculate_free_frames>
  800318:	89 c3                	mov    %eax,%ebx
  80031a:	e8 f2 1e 00 00       	call   802211 <sys_calculate_modified_frames>
  80031f:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  800322:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800325:	29 c2                	sub    %eax,%edx
  800327:	89 d0                	mov    %edx,%eax
  800329:	89 45 cc             	mov    %eax,-0x34(%ebp)
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
  80032c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80032f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800332:	0f 84 8d 00 00 00    	je     8003c5 <_main+0x38d>
  800338:	68 7c 3d 80 00       	push   $0x803d7c
  80033d:	68 a1 3d 80 00       	push   $0x803da1
  800342:	6a 77                	push   $0x77
  800344:	68 5e 3c 80 00       	push   $0x803c5e
  800349:	e8 54 06 00 00       	call   8009a2 <_panic>
		}
		else if (Iteration == 3 )
  80034e:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
  800352:	75 71                	jne    8003c5 <_main+0x38d>
		{
			if (!(NumOfElements == 300000 && Chose == 'c'))
  800354:	81 7d ec e0 93 04 00 	cmpl   $0x493e0,-0x14(%ebp)
  80035b:	75 06                	jne    800363 <_main+0x32b>
  80035d:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800361:	74 14                	je     800377 <_main+0x33f>
				panic("Please ensure the number of elements and the initialization method of this test");
  800363:	83 ec 04             	sub    $0x4,%esp
  800366:	68 2c 3d 80 00       	push   $0x803d2c
  80036b:	6a 7c                	push   $0x7c
  80036d:	68 5e 3c 80 00       	push   $0x803c5e
  800372:	e8 2b 06 00 00       	call   8009a2 <_panic>

			int numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  800377:	a1 24 50 80 00       	mov    0x805024,%eax
  80037c:	83 ec 0c             	sub    $0xc,%esp
  80037f:	50                   	push   %eax
  800380:	e8 ae 00 00 00       	call   800433 <CheckAndCountEmptyLocInWS>
  800385:	83 c4 10             	add    $0x10,%esp
  800388:	89 45 c8             	mov    %eax,-0x38(%ebp)
			int CurrFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  80038b:	e8 68 1e 00 00       	call   8021f8 <sys_calculate_free_frames>
  800390:	89 c3                	mov    %eax,%ebx
  800392:	e8 7a 1e 00 00       	call   802211 <sys_calculate_modified_frames>
  800397:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  80039a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80039d:	29 c2                	sub    %eax,%edx
  80039f:	89 d0                	mov    %edx,%eax
  8003a1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			//cprintf("numOFEmptyLocInWS = %d\n", numOFEmptyLocInWS );
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
  8003a4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8003a7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8003aa:	74 19                	je     8003c5 <_main+0x38d>
  8003ac:	68 7c 3d 80 00       	push   $0x803d7c
  8003b1:	68 a1 3d 80 00       	push   $0x803da1
  8003b6:	68 81 00 00 00       	push   $0x81
  8003bb:	68 5e 3c 80 00       	push   $0x803c5e
  8003c0:	e8 dd 05 00 00       	call   8009a2 <_panic>
		}
		///========================================================================
	sys_disable_interrupt();
  8003c5:	e8 1b 1f 00 00       	call   8022e5 <sys_disable_interrupt>
		Chose = 0 ;
  8003ca:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
		while (Chose != 'y' && Chose != 'n')
  8003ce:	eb 42                	jmp    800412 <_main+0x3da>
		{
			cprintf("Do you want to repeat (y/n): ") ;
  8003d0:	83 ec 0c             	sub    $0xc,%esp
  8003d3:	68 b6 3d 80 00       	push   $0x803db6
  8003d8:	e8 79 08 00 00       	call   800c56 <cprintf>
  8003dd:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  8003e0:	e8 29 04 00 00       	call   80080e <getchar>
  8003e5:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  8003e8:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8003ec:	83 ec 0c             	sub    $0xc,%esp
  8003ef:	50                   	push   %eax
  8003f0:	e8 d1 03 00 00       	call   8007c6 <cputchar>
  8003f5:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8003f8:	83 ec 0c             	sub    $0xc,%esp
  8003fb:	6a 0a                	push   $0xa
  8003fd:	e8 c4 03 00 00       	call   8007c6 <cputchar>
  800402:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800405:	83 ec 0c             	sub    $0xc,%esp
  800408:	6a 0a                	push   $0xa
  80040a:	e8 b7 03 00 00       	call   8007c6 <cputchar>
  80040f:	83 c4 10             	add    $0x10,%esp
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
		}
		///========================================================================
	sys_disable_interrupt();
		Chose = 0 ;
		while (Chose != 'y' && Chose != 'n')
  800412:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  800416:	74 06                	je     80041e <_main+0x3e6>
  800418:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  80041c:	75 b2                	jne    8003d0 <_main+0x398>
			Chose = getchar() ;
			cputchar(Chose);
			cputchar('\n');
			cputchar('\n');
		}
	sys_enable_interrupt();
  80041e:	e8 dc 1e 00 00       	call   8022ff <sys_enable_interrupt>

	} while (Chose == 'y');
  800423:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  800427:	0f 84 1c fc ff ff    	je     800049 <_main+0x11>
}
  80042d:	90                   	nop
  80042e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800431:	c9                   	leave  
  800432:	c3                   	ret    

00800433 <CheckAndCountEmptyLocInWS>:

int CheckAndCountEmptyLocInWS(volatile struct Env *myEnv)
{
  800433:	55                   	push   %ebp
  800434:	89 e5                	mov    %esp,%ebp
  800436:	83 ec 18             	sub    $0x18,%esp
	int numOFEmptyLocInWS = 0, i;
  800439:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (i = 0 ; i < myEnv->page_WS_max_size; i++)
  800440:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800447:	eb 74                	jmp    8004bd <CheckAndCountEmptyLocInWS+0x8a>
	{
		if (myEnv->__uptr_pws[i].empty)
  800449:	8b 45 08             	mov    0x8(%ebp),%eax
  80044c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800452:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800455:	89 d0                	mov    %edx,%eax
  800457:	01 c0                	add    %eax,%eax
  800459:	01 d0                	add    %edx,%eax
  80045b:	c1 e0 03             	shl    $0x3,%eax
  80045e:	01 c8                	add    %ecx,%eax
  800460:	8a 40 04             	mov    0x4(%eax),%al
  800463:	84 c0                	test   %al,%al
  800465:	74 05                	je     80046c <CheckAndCountEmptyLocInWS+0x39>
		{
			numOFEmptyLocInWS++;
  800467:	ff 45 f4             	incl   -0xc(%ebp)
  80046a:	eb 4e                	jmp    8004ba <CheckAndCountEmptyLocInWS+0x87>
		}
		else
		{
			uint32 va = ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) ;
  80046c:	8b 45 08             	mov    0x8(%ebp),%eax
  80046f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800475:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800478:	89 d0                	mov    %edx,%eax
  80047a:	01 c0                	add    %eax,%eax
  80047c:	01 d0                	add    %edx,%eax
  80047e:	c1 e0 03             	shl    $0x3,%eax
  800481:	01 c8                	add    %ecx,%eax
  800483:	8b 00                	mov    (%eax),%eax
  800485:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800488:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80048b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800490:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (va >= USER_HEAP_START && va < (USER_HEAP_MAX))
  800493:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800496:	85 c0                	test   %eax,%eax
  800498:	79 20                	jns    8004ba <CheckAndCountEmptyLocInWS+0x87>
  80049a:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  8004a1:	77 17                	ja     8004ba <CheckAndCountEmptyLocInWS+0x87>
				panic("freeMem didn't remove its page(s) from the WS");
  8004a3:	83 ec 04             	sub    $0x4,%esp
  8004a6:	68 d4 3d 80 00       	push   $0x803dd4
  8004ab:	68 a0 00 00 00       	push   $0xa0
  8004b0:	68 5e 3c 80 00       	push   $0x803c5e
  8004b5:	e8 e8 04 00 00       	call   8009a2 <_panic>
}

int CheckAndCountEmptyLocInWS(volatile struct Env *myEnv)
{
	int numOFEmptyLocInWS = 0, i;
	for (i = 0 ; i < myEnv->page_WS_max_size; i++)
  8004ba:	ff 45 f0             	incl   -0x10(%ebp)
  8004bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c0:	8b 50 74             	mov    0x74(%eax),%edx
  8004c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004c6:	39 c2                	cmp    %eax,%edx
  8004c8:	0f 87 7b ff ff ff    	ja     800449 <CheckAndCountEmptyLocInWS+0x16>
			uint32 va = ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) ;
			if (va >= USER_HEAP_START && va < (USER_HEAP_MAX))
				panic("freeMem didn't remove its page(s) from the WS");
		}
	}
	return numOFEmptyLocInWS;
  8004ce:	8b 45 f4             	mov    -0xc(%ebp),%eax

}
  8004d1:	c9                   	leave  
  8004d2:	c3                   	ret    

008004d3 <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  8004d3:	55                   	push   %ebp
  8004d4:	89 e5                	mov    %esp,%ebp
  8004d6:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  8004d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004dc:	48                   	dec    %eax
  8004dd:	50                   	push   %eax
  8004de:	6a 00                	push   $0x0
  8004e0:	ff 75 0c             	pushl  0xc(%ebp)
  8004e3:	ff 75 08             	pushl  0x8(%ebp)
  8004e6:	e8 06 00 00 00       	call   8004f1 <QSort>
  8004eb:	83 c4 10             	add    $0x10,%esp
}
  8004ee:	90                   	nop
  8004ef:	c9                   	leave  
  8004f0:	c3                   	ret    

008004f1 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  8004f1:	55                   	push   %ebp
  8004f2:	89 e5                	mov    %esp,%ebp
  8004f4:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8004f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8004fa:	3b 45 14             	cmp    0x14(%ebp),%eax
  8004fd:	0f 8d de 00 00 00    	jge    8005e1 <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  800503:	8b 45 10             	mov    0x10(%ebp),%eax
  800506:	40                   	inc    %eax
  800507:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80050a:	8b 45 14             	mov    0x14(%ebp),%eax
  80050d:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  800510:	e9 80 00 00 00       	jmp    800595 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800515:	ff 45 f4             	incl   -0xc(%ebp)
  800518:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80051b:	3b 45 14             	cmp    0x14(%ebp),%eax
  80051e:	7f 2b                	jg     80054b <QSort+0x5a>
  800520:	8b 45 10             	mov    0x10(%ebp),%eax
  800523:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80052a:	8b 45 08             	mov    0x8(%ebp),%eax
  80052d:	01 d0                	add    %edx,%eax
  80052f:	8b 10                	mov    (%eax),%edx
  800531:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800534:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80053b:	8b 45 08             	mov    0x8(%ebp),%eax
  80053e:	01 c8                	add    %ecx,%eax
  800540:	8b 00                	mov    (%eax),%eax
  800542:	39 c2                	cmp    %eax,%edx
  800544:	7d cf                	jge    800515 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  800546:	eb 03                	jmp    80054b <QSort+0x5a>
  800548:	ff 4d f0             	decl   -0x10(%ebp)
  80054b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80054e:	3b 45 10             	cmp    0x10(%ebp),%eax
  800551:	7e 26                	jle    800579 <QSort+0x88>
  800553:	8b 45 10             	mov    0x10(%ebp),%eax
  800556:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80055d:	8b 45 08             	mov    0x8(%ebp),%eax
  800560:	01 d0                	add    %edx,%eax
  800562:	8b 10                	mov    (%eax),%edx
  800564:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800567:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80056e:	8b 45 08             	mov    0x8(%ebp),%eax
  800571:	01 c8                	add    %ecx,%eax
  800573:	8b 00                	mov    (%eax),%eax
  800575:	39 c2                	cmp    %eax,%edx
  800577:	7e cf                	jle    800548 <QSort+0x57>

		if (i <= j)
  800579:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80057c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80057f:	7f 14                	jg     800595 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  800581:	83 ec 04             	sub    $0x4,%esp
  800584:	ff 75 f0             	pushl  -0x10(%ebp)
  800587:	ff 75 f4             	pushl  -0xc(%ebp)
  80058a:	ff 75 08             	pushl  0x8(%ebp)
  80058d:	e8 a9 00 00 00       	call   80063b <Swap>
  800592:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800595:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800598:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80059b:	0f 8e 77 ff ff ff    	jle    800518 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  8005a1:	83 ec 04             	sub    $0x4,%esp
  8005a4:	ff 75 f0             	pushl  -0x10(%ebp)
  8005a7:	ff 75 10             	pushl  0x10(%ebp)
  8005aa:	ff 75 08             	pushl  0x8(%ebp)
  8005ad:	e8 89 00 00 00       	call   80063b <Swap>
  8005b2:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  8005b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005b8:	48                   	dec    %eax
  8005b9:	50                   	push   %eax
  8005ba:	ff 75 10             	pushl  0x10(%ebp)
  8005bd:	ff 75 0c             	pushl  0xc(%ebp)
  8005c0:	ff 75 08             	pushl  0x8(%ebp)
  8005c3:	e8 29 ff ff ff       	call   8004f1 <QSort>
  8005c8:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  8005cb:	ff 75 14             	pushl  0x14(%ebp)
  8005ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8005d1:	ff 75 0c             	pushl  0xc(%ebp)
  8005d4:	ff 75 08             	pushl  0x8(%ebp)
  8005d7:	e8 15 ff ff ff       	call   8004f1 <QSort>
  8005dc:	83 c4 10             	add    $0x10,%esp
  8005df:	eb 01                	jmp    8005e2 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  8005e1:	90                   	nop

	Swap( Elements, startIndex, j);

	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);
}
  8005e2:	c9                   	leave  
  8005e3:	c3                   	ret    

008005e4 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8005e4:	55                   	push   %ebp
  8005e5:	89 e5                	mov    %esp,%ebp
  8005e7:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8005ea:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8005f1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8005f8:	eb 33                	jmp    80062d <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8005fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8005fd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800604:	8b 45 08             	mov    0x8(%ebp),%eax
  800607:	01 d0                	add    %edx,%eax
  800609:	8b 10                	mov    (%eax),%edx
  80060b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80060e:	40                   	inc    %eax
  80060f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800616:	8b 45 08             	mov    0x8(%ebp),%eax
  800619:	01 c8                	add    %ecx,%eax
  80061b:	8b 00                	mov    (%eax),%eax
  80061d:	39 c2                	cmp    %eax,%edx
  80061f:	7e 09                	jle    80062a <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800621:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800628:	eb 0c                	jmp    800636 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80062a:	ff 45 f8             	incl   -0x8(%ebp)
  80062d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800630:	48                   	dec    %eax
  800631:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800634:	7f c4                	jg     8005fa <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800636:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800639:	c9                   	leave  
  80063a:	c3                   	ret    

0080063b <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80063b:	55                   	push   %ebp
  80063c:	89 e5                	mov    %esp,%ebp
  80063e:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800641:	8b 45 0c             	mov    0xc(%ebp),%eax
  800644:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80064b:	8b 45 08             	mov    0x8(%ebp),%eax
  80064e:	01 d0                	add    %edx,%eax
  800650:	8b 00                	mov    (%eax),%eax
  800652:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800655:	8b 45 0c             	mov    0xc(%ebp),%eax
  800658:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80065f:	8b 45 08             	mov    0x8(%ebp),%eax
  800662:	01 c2                	add    %eax,%edx
  800664:	8b 45 10             	mov    0x10(%ebp),%eax
  800667:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80066e:	8b 45 08             	mov    0x8(%ebp),%eax
  800671:	01 c8                	add    %ecx,%eax
  800673:	8b 00                	mov    (%eax),%eax
  800675:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800677:	8b 45 10             	mov    0x10(%ebp),%eax
  80067a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800681:	8b 45 08             	mov    0x8(%ebp),%eax
  800684:	01 c2                	add    %eax,%edx
  800686:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800689:	89 02                	mov    %eax,(%edx)
}
  80068b:	90                   	nop
  80068c:	c9                   	leave  
  80068d:	c3                   	ret    

0080068e <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80068e:	55                   	push   %ebp
  80068f:	89 e5                	mov    %esp,%ebp
  800691:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800694:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80069b:	eb 17                	jmp    8006b4 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80069d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006aa:	01 c2                	add    %eax,%edx
  8006ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006af:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006b1:	ff 45 fc             	incl   -0x4(%ebp)
  8006b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006b7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006ba:	7c e1                	jl     80069d <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8006bc:	90                   	nop
  8006bd:	c9                   	leave  
  8006be:	c3                   	ret    

008006bf <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8006bf:	55                   	push   %ebp
  8006c0:	89 e5                	mov    %esp,%ebp
  8006c2:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8006cc:	eb 1b                	jmp    8006e9 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8006ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006db:	01 c2                	add    %eax,%edx
  8006dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e0:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8006e3:	48                   	dec    %eax
  8006e4:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006e6:	ff 45 fc             	incl   -0x4(%ebp)
  8006e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006ec:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006ef:	7c dd                	jl     8006ce <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8006f1:	90                   	nop
  8006f2:	c9                   	leave  
  8006f3:	c3                   	ret    

008006f4 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8006f4:	55                   	push   %ebp
  8006f5:	89 e5                	mov    %esp,%ebp
  8006f7:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8006fa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006fd:	b8 56 55 55 55       	mov    $0x55555556,%eax
  800702:	f7 e9                	imul   %ecx
  800704:	c1 f9 1f             	sar    $0x1f,%ecx
  800707:	89 d0                	mov    %edx,%eax
  800709:	29 c8                	sub    %ecx,%eax
  80070b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  80070e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800715:	eb 1e                	jmp    800735 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  800717:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80071a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800721:	8b 45 08             	mov    0x8(%ebp),%eax
  800724:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800727:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80072a:	99                   	cltd   
  80072b:	f7 7d f8             	idivl  -0x8(%ebp)
  80072e:	89 d0                	mov    %edx,%eax
  800730:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800732:	ff 45 fc             	incl   -0x4(%ebp)
  800735:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800738:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80073b:	7c da                	jl     800717 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
	}

}
  80073d:	90                   	nop
  80073e:	c9                   	leave  
  80073f:	c3                   	ret    

00800740 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800740:	55                   	push   %ebp
  800741:	89 e5                	mov    %esp,%ebp
  800743:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800746:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80074d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800754:	eb 42                	jmp    800798 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800756:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800759:	99                   	cltd   
  80075a:	f7 7d f0             	idivl  -0x10(%ebp)
  80075d:	89 d0                	mov    %edx,%eax
  80075f:	85 c0                	test   %eax,%eax
  800761:	75 10                	jne    800773 <PrintElements+0x33>
			cprintf("\n");
  800763:	83 ec 0c             	sub    $0xc,%esp
  800766:	68 02 3e 80 00       	push   $0x803e02
  80076b:	e8 e6 04 00 00       	call   800c56 <cprintf>
  800770:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800773:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800776:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80077d:	8b 45 08             	mov    0x8(%ebp),%eax
  800780:	01 d0                	add    %edx,%eax
  800782:	8b 00                	mov    (%eax),%eax
  800784:	83 ec 08             	sub    $0x8,%esp
  800787:	50                   	push   %eax
  800788:	68 04 3e 80 00       	push   $0x803e04
  80078d:	e8 c4 04 00 00       	call   800c56 <cprintf>
  800792:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800795:	ff 45 f4             	incl   -0xc(%ebp)
  800798:	8b 45 0c             	mov    0xc(%ebp),%eax
  80079b:	48                   	dec    %eax
  80079c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80079f:	7f b5                	jg     800756 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  8007a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007a4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ae:	01 d0                	add    %edx,%eax
  8007b0:	8b 00                	mov    (%eax),%eax
  8007b2:	83 ec 08             	sub    $0x8,%esp
  8007b5:	50                   	push   %eax
  8007b6:	68 09 3e 80 00       	push   $0x803e09
  8007bb:	e8 96 04 00 00       	call   800c56 <cprintf>
  8007c0:	83 c4 10             	add    $0x10,%esp

}
  8007c3:	90                   	nop
  8007c4:	c9                   	leave  
  8007c5:	c3                   	ret    

008007c6 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8007c6:	55                   	push   %ebp
  8007c7:	89 e5                	mov    %esp,%ebp
  8007c9:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8007cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cf:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8007d2:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8007d6:	83 ec 0c             	sub    $0xc,%esp
  8007d9:	50                   	push   %eax
  8007da:	e8 3a 1b 00 00       	call   802319 <sys_cputc>
  8007df:	83 c4 10             	add    $0x10,%esp
}
  8007e2:	90                   	nop
  8007e3:	c9                   	leave  
  8007e4:	c3                   	ret    

008007e5 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8007e5:	55                   	push   %ebp
  8007e6:	89 e5                	mov    %esp,%ebp
  8007e8:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007eb:	e8 f5 1a 00 00       	call   8022e5 <sys_disable_interrupt>
	char c = ch;
  8007f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f3:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8007f6:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8007fa:	83 ec 0c             	sub    $0xc,%esp
  8007fd:	50                   	push   %eax
  8007fe:	e8 16 1b 00 00       	call   802319 <sys_cputc>
  800803:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800806:	e8 f4 1a 00 00       	call   8022ff <sys_enable_interrupt>
}
  80080b:	90                   	nop
  80080c:	c9                   	leave  
  80080d:	c3                   	ret    

0080080e <getchar>:

int
getchar(void)
{
  80080e:	55                   	push   %ebp
  80080f:	89 e5                	mov    %esp,%ebp
  800811:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800814:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80081b:	eb 08                	jmp    800825 <getchar+0x17>
	{
		c = sys_cgetc();
  80081d:	e8 3e 19 00 00       	call   802160 <sys_cgetc>
  800822:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800825:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800829:	74 f2                	je     80081d <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  80082b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80082e:	c9                   	leave  
  80082f:	c3                   	ret    

00800830 <atomic_getchar>:

int
atomic_getchar(void)
{
  800830:	55                   	push   %ebp
  800831:	89 e5                	mov    %esp,%ebp
  800833:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800836:	e8 aa 1a 00 00       	call   8022e5 <sys_disable_interrupt>
	int c=0;
  80083b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800842:	eb 08                	jmp    80084c <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800844:	e8 17 19 00 00       	call   802160 <sys_cgetc>
  800849:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  80084c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800850:	74 f2                	je     800844 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800852:	e8 a8 1a 00 00       	call   8022ff <sys_enable_interrupt>
	return c;
  800857:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80085a:	c9                   	leave  
  80085b:	c3                   	ret    

0080085c <iscons>:

int iscons(int fdnum)
{
  80085c:	55                   	push   %ebp
  80085d:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80085f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800864:	5d                   	pop    %ebp
  800865:	c3                   	ret    

00800866 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800866:	55                   	push   %ebp
  800867:	89 e5                	mov    %esp,%ebp
  800869:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80086c:	e8 67 1c 00 00       	call   8024d8 <sys_getenvindex>
  800871:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800874:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800877:	89 d0                	mov    %edx,%eax
  800879:	c1 e0 03             	shl    $0x3,%eax
  80087c:	01 d0                	add    %edx,%eax
  80087e:	01 c0                	add    %eax,%eax
  800880:	01 d0                	add    %edx,%eax
  800882:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800889:	01 d0                	add    %edx,%eax
  80088b:	c1 e0 04             	shl    $0x4,%eax
  80088e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800893:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800898:	a1 24 50 80 00       	mov    0x805024,%eax
  80089d:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8008a3:	84 c0                	test   %al,%al
  8008a5:	74 0f                	je     8008b6 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8008a7:	a1 24 50 80 00       	mov    0x805024,%eax
  8008ac:	05 5c 05 00 00       	add    $0x55c,%eax
  8008b1:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8008b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8008ba:	7e 0a                	jle    8008c6 <libmain+0x60>
		binaryname = argv[0];
  8008bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008bf:	8b 00                	mov    (%eax),%eax
  8008c1:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8008c6:	83 ec 08             	sub    $0x8,%esp
  8008c9:	ff 75 0c             	pushl  0xc(%ebp)
  8008cc:	ff 75 08             	pushl  0x8(%ebp)
  8008cf:	e8 64 f7 ff ff       	call   800038 <_main>
  8008d4:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8008d7:	e8 09 1a 00 00       	call   8022e5 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8008dc:	83 ec 0c             	sub    $0xc,%esp
  8008df:	68 28 3e 80 00       	push   $0x803e28
  8008e4:	e8 6d 03 00 00       	call   800c56 <cprintf>
  8008e9:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8008ec:	a1 24 50 80 00       	mov    0x805024,%eax
  8008f1:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8008f7:	a1 24 50 80 00       	mov    0x805024,%eax
  8008fc:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800902:	83 ec 04             	sub    $0x4,%esp
  800905:	52                   	push   %edx
  800906:	50                   	push   %eax
  800907:	68 50 3e 80 00       	push   $0x803e50
  80090c:	e8 45 03 00 00       	call   800c56 <cprintf>
  800911:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800914:	a1 24 50 80 00       	mov    0x805024,%eax
  800919:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80091f:	a1 24 50 80 00       	mov    0x805024,%eax
  800924:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80092a:	a1 24 50 80 00       	mov    0x805024,%eax
  80092f:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800935:	51                   	push   %ecx
  800936:	52                   	push   %edx
  800937:	50                   	push   %eax
  800938:	68 78 3e 80 00       	push   $0x803e78
  80093d:	e8 14 03 00 00       	call   800c56 <cprintf>
  800942:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800945:	a1 24 50 80 00       	mov    0x805024,%eax
  80094a:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800950:	83 ec 08             	sub    $0x8,%esp
  800953:	50                   	push   %eax
  800954:	68 d0 3e 80 00       	push   $0x803ed0
  800959:	e8 f8 02 00 00       	call   800c56 <cprintf>
  80095e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800961:	83 ec 0c             	sub    $0xc,%esp
  800964:	68 28 3e 80 00       	push   $0x803e28
  800969:	e8 e8 02 00 00       	call   800c56 <cprintf>
  80096e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800971:	e8 89 19 00 00       	call   8022ff <sys_enable_interrupt>

	// exit gracefully
	exit();
  800976:	e8 19 00 00 00       	call   800994 <exit>
}
  80097b:	90                   	nop
  80097c:	c9                   	leave  
  80097d:	c3                   	ret    

0080097e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80097e:	55                   	push   %ebp
  80097f:	89 e5                	mov    %esp,%ebp
  800981:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800984:	83 ec 0c             	sub    $0xc,%esp
  800987:	6a 00                	push   $0x0
  800989:	e8 16 1b 00 00       	call   8024a4 <sys_destroy_env>
  80098e:	83 c4 10             	add    $0x10,%esp
}
  800991:	90                   	nop
  800992:	c9                   	leave  
  800993:	c3                   	ret    

00800994 <exit>:

void
exit(void)
{
  800994:	55                   	push   %ebp
  800995:	89 e5                	mov    %esp,%ebp
  800997:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80099a:	e8 6b 1b 00 00       	call   80250a <sys_exit_env>
}
  80099f:	90                   	nop
  8009a0:	c9                   	leave  
  8009a1:	c3                   	ret    

008009a2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8009a2:	55                   	push   %ebp
  8009a3:	89 e5                	mov    %esp,%ebp
  8009a5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8009a8:	8d 45 10             	lea    0x10(%ebp),%eax
  8009ab:	83 c0 04             	add    $0x4,%eax
  8009ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8009b1:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8009b6:	85 c0                	test   %eax,%eax
  8009b8:	74 16                	je     8009d0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8009ba:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8009bf:	83 ec 08             	sub    $0x8,%esp
  8009c2:	50                   	push   %eax
  8009c3:	68 e4 3e 80 00       	push   $0x803ee4
  8009c8:	e8 89 02 00 00       	call   800c56 <cprintf>
  8009cd:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8009d0:	a1 00 50 80 00       	mov    0x805000,%eax
  8009d5:	ff 75 0c             	pushl  0xc(%ebp)
  8009d8:	ff 75 08             	pushl  0x8(%ebp)
  8009db:	50                   	push   %eax
  8009dc:	68 e9 3e 80 00       	push   $0x803ee9
  8009e1:	e8 70 02 00 00       	call   800c56 <cprintf>
  8009e6:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8009e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ec:	83 ec 08             	sub    $0x8,%esp
  8009ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8009f2:	50                   	push   %eax
  8009f3:	e8 f3 01 00 00       	call   800beb <vcprintf>
  8009f8:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8009fb:	83 ec 08             	sub    $0x8,%esp
  8009fe:	6a 00                	push   $0x0
  800a00:	68 05 3f 80 00       	push   $0x803f05
  800a05:	e8 e1 01 00 00       	call   800beb <vcprintf>
  800a0a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800a0d:	e8 82 ff ff ff       	call   800994 <exit>

	// should not return here
	while (1) ;
  800a12:	eb fe                	jmp    800a12 <_panic+0x70>

00800a14 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800a14:	55                   	push   %ebp
  800a15:	89 e5                	mov    %esp,%ebp
  800a17:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800a1a:	a1 24 50 80 00       	mov    0x805024,%eax
  800a1f:	8b 50 74             	mov    0x74(%eax),%edx
  800a22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a25:	39 c2                	cmp    %eax,%edx
  800a27:	74 14                	je     800a3d <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800a29:	83 ec 04             	sub    $0x4,%esp
  800a2c:	68 08 3f 80 00       	push   $0x803f08
  800a31:	6a 26                	push   $0x26
  800a33:	68 54 3f 80 00       	push   $0x803f54
  800a38:	e8 65 ff ff ff       	call   8009a2 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800a3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800a44:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a4b:	e9 c2 00 00 00       	jmp    800b12 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800a50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a53:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5d:	01 d0                	add    %edx,%eax
  800a5f:	8b 00                	mov    (%eax),%eax
  800a61:	85 c0                	test   %eax,%eax
  800a63:	75 08                	jne    800a6d <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800a65:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800a68:	e9 a2 00 00 00       	jmp    800b0f <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800a6d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a74:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800a7b:	eb 69                	jmp    800ae6 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800a7d:	a1 24 50 80 00       	mov    0x805024,%eax
  800a82:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800a88:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a8b:	89 d0                	mov    %edx,%eax
  800a8d:	01 c0                	add    %eax,%eax
  800a8f:	01 d0                	add    %edx,%eax
  800a91:	c1 e0 03             	shl    $0x3,%eax
  800a94:	01 c8                	add    %ecx,%eax
  800a96:	8a 40 04             	mov    0x4(%eax),%al
  800a99:	84 c0                	test   %al,%al
  800a9b:	75 46                	jne    800ae3 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a9d:	a1 24 50 80 00       	mov    0x805024,%eax
  800aa2:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800aa8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800aab:	89 d0                	mov    %edx,%eax
  800aad:	01 c0                	add    %eax,%eax
  800aaf:	01 d0                	add    %edx,%eax
  800ab1:	c1 e0 03             	shl    $0x3,%eax
  800ab4:	01 c8                	add    %ecx,%eax
  800ab6:	8b 00                	mov    (%eax),%eax
  800ab8:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800abb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800abe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ac3:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800ac5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ac8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad2:	01 c8                	add    %ecx,%eax
  800ad4:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800ad6:	39 c2                	cmp    %eax,%edx
  800ad8:	75 09                	jne    800ae3 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800ada:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800ae1:	eb 12                	jmp    800af5 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ae3:	ff 45 e8             	incl   -0x18(%ebp)
  800ae6:	a1 24 50 80 00       	mov    0x805024,%eax
  800aeb:	8b 50 74             	mov    0x74(%eax),%edx
  800aee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800af1:	39 c2                	cmp    %eax,%edx
  800af3:	77 88                	ja     800a7d <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800af5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800af9:	75 14                	jne    800b0f <CheckWSWithoutLastIndex+0xfb>
			panic(
  800afb:	83 ec 04             	sub    $0x4,%esp
  800afe:	68 60 3f 80 00       	push   $0x803f60
  800b03:	6a 3a                	push   $0x3a
  800b05:	68 54 3f 80 00       	push   $0x803f54
  800b0a:	e8 93 fe ff ff       	call   8009a2 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800b0f:	ff 45 f0             	incl   -0x10(%ebp)
  800b12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b15:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800b18:	0f 8c 32 ff ff ff    	jl     800a50 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800b1e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b25:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800b2c:	eb 26                	jmp    800b54 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800b2e:	a1 24 50 80 00       	mov    0x805024,%eax
  800b33:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b39:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800b3c:	89 d0                	mov    %edx,%eax
  800b3e:	01 c0                	add    %eax,%eax
  800b40:	01 d0                	add    %edx,%eax
  800b42:	c1 e0 03             	shl    $0x3,%eax
  800b45:	01 c8                	add    %ecx,%eax
  800b47:	8a 40 04             	mov    0x4(%eax),%al
  800b4a:	3c 01                	cmp    $0x1,%al
  800b4c:	75 03                	jne    800b51 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800b4e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b51:	ff 45 e0             	incl   -0x20(%ebp)
  800b54:	a1 24 50 80 00       	mov    0x805024,%eax
  800b59:	8b 50 74             	mov    0x74(%eax),%edx
  800b5c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b5f:	39 c2                	cmp    %eax,%edx
  800b61:	77 cb                	ja     800b2e <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b66:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800b69:	74 14                	je     800b7f <CheckWSWithoutLastIndex+0x16b>
		panic(
  800b6b:	83 ec 04             	sub    $0x4,%esp
  800b6e:	68 b4 3f 80 00       	push   $0x803fb4
  800b73:	6a 44                	push   $0x44
  800b75:	68 54 3f 80 00       	push   $0x803f54
  800b7a:	e8 23 fe ff ff       	call   8009a2 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800b7f:	90                   	nop
  800b80:	c9                   	leave  
  800b81:	c3                   	ret    

00800b82 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800b82:	55                   	push   %ebp
  800b83:	89 e5                	mov    %esp,%ebp
  800b85:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800b88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8b:	8b 00                	mov    (%eax),%eax
  800b8d:	8d 48 01             	lea    0x1(%eax),%ecx
  800b90:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b93:	89 0a                	mov    %ecx,(%edx)
  800b95:	8b 55 08             	mov    0x8(%ebp),%edx
  800b98:	88 d1                	mov    %dl,%cl
  800b9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b9d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800ba1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba4:	8b 00                	mov    (%eax),%eax
  800ba6:	3d ff 00 00 00       	cmp    $0xff,%eax
  800bab:	75 2c                	jne    800bd9 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800bad:	a0 28 50 80 00       	mov    0x805028,%al
  800bb2:	0f b6 c0             	movzbl %al,%eax
  800bb5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bb8:	8b 12                	mov    (%edx),%edx
  800bba:	89 d1                	mov    %edx,%ecx
  800bbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bbf:	83 c2 08             	add    $0x8,%edx
  800bc2:	83 ec 04             	sub    $0x4,%esp
  800bc5:	50                   	push   %eax
  800bc6:	51                   	push   %ecx
  800bc7:	52                   	push   %edx
  800bc8:	e8 6a 15 00 00       	call   802137 <sys_cputs>
  800bcd:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800bd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800bd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bdc:	8b 40 04             	mov    0x4(%eax),%eax
  800bdf:	8d 50 01             	lea    0x1(%eax),%edx
  800be2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be5:	89 50 04             	mov    %edx,0x4(%eax)
}
  800be8:	90                   	nop
  800be9:	c9                   	leave  
  800bea:	c3                   	ret    

00800beb <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
  800bee:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800bf4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800bfb:	00 00 00 
	b.cnt = 0;
  800bfe:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800c05:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800c08:	ff 75 0c             	pushl  0xc(%ebp)
  800c0b:	ff 75 08             	pushl  0x8(%ebp)
  800c0e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c14:	50                   	push   %eax
  800c15:	68 82 0b 80 00       	push   $0x800b82
  800c1a:	e8 11 02 00 00       	call   800e30 <vprintfmt>
  800c1f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800c22:	a0 28 50 80 00       	mov    0x805028,%al
  800c27:	0f b6 c0             	movzbl %al,%eax
  800c2a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800c30:	83 ec 04             	sub    $0x4,%esp
  800c33:	50                   	push   %eax
  800c34:	52                   	push   %edx
  800c35:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c3b:	83 c0 08             	add    $0x8,%eax
  800c3e:	50                   	push   %eax
  800c3f:	e8 f3 14 00 00       	call   802137 <sys_cputs>
  800c44:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800c47:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800c4e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800c54:	c9                   	leave  
  800c55:	c3                   	ret    

00800c56 <cprintf>:

int cprintf(const char *fmt, ...) {
  800c56:	55                   	push   %ebp
  800c57:	89 e5                	mov    %esp,%ebp
  800c59:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800c5c:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800c63:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c66:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c69:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6c:	83 ec 08             	sub    $0x8,%esp
  800c6f:	ff 75 f4             	pushl  -0xc(%ebp)
  800c72:	50                   	push   %eax
  800c73:	e8 73 ff ff ff       	call   800beb <vcprintf>
  800c78:	83 c4 10             	add    $0x10,%esp
  800c7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800c7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c81:	c9                   	leave  
  800c82:	c3                   	ret    

00800c83 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800c89:	e8 57 16 00 00       	call   8022e5 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800c8e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c91:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c94:	8b 45 08             	mov    0x8(%ebp),%eax
  800c97:	83 ec 08             	sub    $0x8,%esp
  800c9a:	ff 75 f4             	pushl  -0xc(%ebp)
  800c9d:	50                   	push   %eax
  800c9e:	e8 48 ff ff ff       	call   800beb <vcprintf>
  800ca3:	83 c4 10             	add    $0x10,%esp
  800ca6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800ca9:	e8 51 16 00 00       	call   8022ff <sys_enable_interrupt>
	return cnt;
  800cae:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cb1:	c9                   	leave  
  800cb2:	c3                   	ret    

00800cb3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800cb3:	55                   	push   %ebp
  800cb4:	89 e5                	mov    %esp,%ebp
  800cb6:	53                   	push   %ebx
  800cb7:	83 ec 14             	sub    $0x14,%esp
  800cba:	8b 45 10             	mov    0x10(%ebp),%eax
  800cbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cc0:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800cc6:	8b 45 18             	mov    0x18(%ebp),%eax
  800cc9:	ba 00 00 00 00       	mov    $0x0,%edx
  800cce:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800cd1:	77 55                	ja     800d28 <printnum+0x75>
  800cd3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800cd6:	72 05                	jb     800cdd <printnum+0x2a>
  800cd8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800cdb:	77 4b                	ja     800d28 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800cdd:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800ce0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800ce3:	8b 45 18             	mov    0x18(%ebp),%eax
  800ce6:	ba 00 00 00 00       	mov    $0x0,%edx
  800ceb:	52                   	push   %edx
  800cec:	50                   	push   %eax
  800ced:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf0:	ff 75 f0             	pushl  -0x10(%ebp)
  800cf3:	e8 4c 2c 00 00       	call   803944 <__udivdi3>
  800cf8:	83 c4 10             	add    $0x10,%esp
  800cfb:	83 ec 04             	sub    $0x4,%esp
  800cfe:	ff 75 20             	pushl  0x20(%ebp)
  800d01:	53                   	push   %ebx
  800d02:	ff 75 18             	pushl  0x18(%ebp)
  800d05:	52                   	push   %edx
  800d06:	50                   	push   %eax
  800d07:	ff 75 0c             	pushl  0xc(%ebp)
  800d0a:	ff 75 08             	pushl  0x8(%ebp)
  800d0d:	e8 a1 ff ff ff       	call   800cb3 <printnum>
  800d12:	83 c4 20             	add    $0x20,%esp
  800d15:	eb 1a                	jmp    800d31 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800d17:	83 ec 08             	sub    $0x8,%esp
  800d1a:	ff 75 0c             	pushl  0xc(%ebp)
  800d1d:	ff 75 20             	pushl  0x20(%ebp)
  800d20:	8b 45 08             	mov    0x8(%ebp),%eax
  800d23:	ff d0                	call   *%eax
  800d25:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800d28:	ff 4d 1c             	decl   0x1c(%ebp)
  800d2b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800d2f:	7f e6                	jg     800d17 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800d31:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800d34:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d3f:	53                   	push   %ebx
  800d40:	51                   	push   %ecx
  800d41:	52                   	push   %edx
  800d42:	50                   	push   %eax
  800d43:	e8 0c 2d 00 00       	call   803a54 <__umoddi3>
  800d48:	83 c4 10             	add    $0x10,%esp
  800d4b:	05 14 42 80 00       	add    $0x804214,%eax
  800d50:	8a 00                	mov    (%eax),%al
  800d52:	0f be c0             	movsbl %al,%eax
  800d55:	83 ec 08             	sub    $0x8,%esp
  800d58:	ff 75 0c             	pushl  0xc(%ebp)
  800d5b:	50                   	push   %eax
  800d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5f:	ff d0                	call   *%eax
  800d61:	83 c4 10             	add    $0x10,%esp
}
  800d64:	90                   	nop
  800d65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d68:	c9                   	leave  
  800d69:	c3                   	ret    

00800d6a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800d6a:	55                   	push   %ebp
  800d6b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d6d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d71:	7e 1c                	jle    800d8f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	8b 00                	mov    (%eax),%eax
  800d78:	8d 50 08             	lea    0x8(%eax),%edx
  800d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7e:	89 10                	mov    %edx,(%eax)
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8b 00                	mov    (%eax),%eax
  800d85:	83 e8 08             	sub    $0x8,%eax
  800d88:	8b 50 04             	mov    0x4(%eax),%edx
  800d8b:	8b 00                	mov    (%eax),%eax
  800d8d:	eb 40                	jmp    800dcf <getuint+0x65>
	else if (lflag)
  800d8f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d93:	74 1e                	je     800db3 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800d95:	8b 45 08             	mov    0x8(%ebp),%eax
  800d98:	8b 00                	mov    (%eax),%eax
  800d9a:	8d 50 04             	lea    0x4(%eax),%edx
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	89 10                	mov    %edx,(%eax)
  800da2:	8b 45 08             	mov    0x8(%ebp),%eax
  800da5:	8b 00                	mov    (%eax),%eax
  800da7:	83 e8 04             	sub    $0x4,%eax
  800daa:	8b 00                	mov    (%eax),%eax
  800dac:	ba 00 00 00 00       	mov    $0x0,%edx
  800db1:	eb 1c                	jmp    800dcf <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800db3:	8b 45 08             	mov    0x8(%ebp),%eax
  800db6:	8b 00                	mov    (%eax),%eax
  800db8:	8d 50 04             	lea    0x4(%eax),%edx
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbe:	89 10                	mov    %edx,(%eax)
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc3:	8b 00                	mov    (%eax),%eax
  800dc5:	83 e8 04             	sub    $0x4,%eax
  800dc8:	8b 00                	mov    (%eax),%eax
  800dca:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800dcf:	5d                   	pop    %ebp
  800dd0:	c3                   	ret    

00800dd1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800dd1:	55                   	push   %ebp
  800dd2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800dd4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800dd8:	7e 1c                	jle    800df6 <getint+0x25>
		return va_arg(*ap, long long);
  800dda:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddd:	8b 00                	mov    (%eax),%eax
  800ddf:	8d 50 08             	lea    0x8(%eax),%edx
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
  800de5:	89 10                	mov    %edx,(%eax)
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dea:	8b 00                	mov    (%eax),%eax
  800dec:	83 e8 08             	sub    $0x8,%eax
  800def:	8b 50 04             	mov    0x4(%eax),%edx
  800df2:	8b 00                	mov    (%eax),%eax
  800df4:	eb 38                	jmp    800e2e <getint+0x5d>
	else if (lflag)
  800df6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dfa:	74 1a                	je     800e16 <getint+0x45>
		return va_arg(*ap, long);
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dff:	8b 00                	mov    (%eax),%eax
  800e01:	8d 50 04             	lea    0x4(%eax),%edx
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
  800e07:	89 10                	mov    %edx,(%eax)
  800e09:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0c:	8b 00                	mov    (%eax),%eax
  800e0e:	83 e8 04             	sub    $0x4,%eax
  800e11:	8b 00                	mov    (%eax),%eax
  800e13:	99                   	cltd   
  800e14:	eb 18                	jmp    800e2e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800e16:	8b 45 08             	mov    0x8(%ebp),%eax
  800e19:	8b 00                	mov    (%eax),%eax
  800e1b:	8d 50 04             	lea    0x4(%eax),%edx
  800e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e21:	89 10                	mov    %edx,(%eax)
  800e23:	8b 45 08             	mov    0x8(%ebp),%eax
  800e26:	8b 00                	mov    (%eax),%eax
  800e28:	83 e8 04             	sub    $0x4,%eax
  800e2b:	8b 00                	mov    (%eax),%eax
  800e2d:	99                   	cltd   
}
  800e2e:	5d                   	pop    %ebp
  800e2f:	c3                   	ret    

00800e30 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800e30:	55                   	push   %ebp
  800e31:	89 e5                	mov    %esp,%ebp
  800e33:	56                   	push   %esi
  800e34:	53                   	push   %ebx
  800e35:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e38:	eb 17                	jmp    800e51 <vprintfmt+0x21>
			if (ch == '\0')
  800e3a:	85 db                	test   %ebx,%ebx
  800e3c:	0f 84 af 03 00 00    	je     8011f1 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800e42:	83 ec 08             	sub    $0x8,%esp
  800e45:	ff 75 0c             	pushl  0xc(%ebp)
  800e48:	53                   	push   %ebx
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	ff d0                	call   *%eax
  800e4e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e51:	8b 45 10             	mov    0x10(%ebp),%eax
  800e54:	8d 50 01             	lea    0x1(%eax),%edx
  800e57:	89 55 10             	mov    %edx,0x10(%ebp)
  800e5a:	8a 00                	mov    (%eax),%al
  800e5c:	0f b6 d8             	movzbl %al,%ebx
  800e5f:	83 fb 25             	cmp    $0x25,%ebx
  800e62:	75 d6                	jne    800e3a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800e64:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800e68:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800e6f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800e76:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800e7d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e84:	8b 45 10             	mov    0x10(%ebp),%eax
  800e87:	8d 50 01             	lea    0x1(%eax),%edx
  800e8a:	89 55 10             	mov    %edx,0x10(%ebp)
  800e8d:	8a 00                	mov    (%eax),%al
  800e8f:	0f b6 d8             	movzbl %al,%ebx
  800e92:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800e95:	83 f8 55             	cmp    $0x55,%eax
  800e98:	0f 87 2b 03 00 00    	ja     8011c9 <vprintfmt+0x399>
  800e9e:	8b 04 85 38 42 80 00 	mov    0x804238(,%eax,4),%eax
  800ea5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ea7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800eab:	eb d7                	jmp    800e84 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ead:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800eb1:	eb d1                	jmp    800e84 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800eb3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800eba:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ebd:	89 d0                	mov    %edx,%eax
  800ebf:	c1 e0 02             	shl    $0x2,%eax
  800ec2:	01 d0                	add    %edx,%eax
  800ec4:	01 c0                	add    %eax,%eax
  800ec6:	01 d8                	add    %ebx,%eax
  800ec8:	83 e8 30             	sub    $0x30,%eax
  800ecb:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800ece:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed1:	8a 00                	mov    (%eax),%al
  800ed3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ed6:	83 fb 2f             	cmp    $0x2f,%ebx
  800ed9:	7e 3e                	jle    800f19 <vprintfmt+0xe9>
  800edb:	83 fb 39             	cmp    $0x39,%ebx
  800ede:	7f 39                	jg     800f19 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ee0:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ee3:	eb d5                	jmp    800eba <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ee5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ee8:	83 c0 04             	add    $0x4,%eax
  800eeb:	89 45 14             	mov    %eax,0x14(%ebp)
  800eee:	8b 45 14             	mov    0x14(%ebp),%eax
  800ef1:	83 e8 04             	sub    $0x4,%eax
  800ef4:	8b 00                	mov    (%eax),%eax
  800ef6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800ef9:	eb 1f                	jmp    800f1a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800efb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800eff:	79 83                	jns    800e84 <vprintfmt+0x54>
				width = 0;
  800f01:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800f08:	e9 77 ff ff ff       	jmp    800e84 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800f0d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800f14:	e9 6b ff ff ff       	jmp    800e84 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800f19:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800f1a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f1e:	0f 89 60 ff ff ff    	jns    800e84 <vprintfmt+0x54>
				width = precision, precision = -1;
  800f24:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f27:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800f2a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800f31:	e9 4e ff ff ff       	jmp    800e84 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800f36:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800f39:	e9 46 ff ff ff       	jmp    800e84 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800f3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f41:	83 c0 04             	add    $0x4,%eax
  800f44:	89 45 14             	mov    %eax,0x14(%ebp)
  800f47:	8b 45 14             	mov    0x14(%ebp),%eax
  800f4a:	83 e8 04             	sub    $0x4,%eax
  800f4d:	8b 00                	mov    (%eax),%eax
  800f4f:	83 ec 08             	sub    $0x8,%esp
  800f52:	ff 75 0c             	pushl  0xc(%ebp)
  800f55:	50                   	push   %eax
  800f56:	8b 45 08             	mov    0x8(%ebp),%eax
  800f59:	ff d0                	call   *%eax
  800f5b:	83 c4 10             	add    $0x10,%esp
			break;
  800f5e:	e9 89 02 00 00       	jmp    8011ec <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800f63:	8b 45 14             	mov    0x14(%ebp),%eax
  800f66:	83 c0 04             	add    $0x4,%eax
  800f69:	89 45 14             	mov    %eax,0x14(%ebp)
  800f6c:	8b 45 14             	mov    0x14(%ebp),%eax
  800f6f:	83 e8 04             	sub    $0x4,%eax
  800f72:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800f74:	85 db                	test   %ebx,%ebx
  800f76:	79 02                	jns    800f7a <vprintfmt+0x14a>
				err = -err;
  800f78:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800f7a:	83 fb 64             	cmp    $0x64,%ebx
  800f7d:	7f 0b                	jg     800f8a <vprintfmt+0x15a>
  800f7f:	8b 34 9d 80 40 80 00 	mov    0x804080(,%ebx,4),%esi
  800f86:	85 f6                	test   %esi,%esi
  800f88:	75 19                	jne    800fa3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800f8a:	53                   	push   %ebx
  800f8b:	68 25 42 80 00       	push   $0x804225
  800f90:	ff 75 0c             	pushl  0xc(%ebp)
  800f93:	ff 75 08             	pushl  0x8(%ebp)
  800f96:	e8 5e 02 00 00       	call   8011f9 <printfmt>
  800f9b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f9e:	e9 49 02 00 00       	jmp    8011ec <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800fa3:	56                   	push   %esi
  800fa4:	68 2e 42 80 00       	push   $0x80422e
  800fa9:	ff 75 0c             	pushl  0xc(%ebp)
  800fac:	ff 75 08             	pushl  0x8(%ebp)
  800faf:	e8 45 02 00 00       	call   8011f9 <printfmt>
  800fb4:	83 c4 10             	add    $0x10,%esp
			break;
  800fb7:	e9 30 02 00 00       	jmp    8011ec <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800fbc:	8b 45 14             	mov    0x14(%ebp),%eax
  800fbf:	83 c0 04             	add    $0x4,%eax
  800fc2:	89 45 14             	mov    %eax,0x14(%ebp)
  800fc5:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc8:	83 e8 04             	sub    $0x4,%eax
  800fcb:	8b 30                	mov    (%eax),%esi
  800fcd:	85 f6                	test   %esi,%esi
  800fcf:	75 05                	jne    800fd6 <vprintfmt+0x1a6>
				p = "(null)";
  800fd1:	be 31 42 80 00       	mov    $0x804231,%esi
			if (width > 0 && padc != '-')
  800fd6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fda:	7e 6d                	jle    801049 <vprintfmt+0x219>
  800fdc:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800fe0:	74 67                	je     801049 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800fe2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fe5:	83 ec 08             	sub    $0x8,%esp
  800fe8:	50                   	push   %eax
  800fe9:	56                   	push   %esi
  800fea:	e8 12 05 00 00       	call   801501 <strnlen>
  800fef:	83 c4 10             	add    $0x10,%esp
  800ff2:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ff5:	eb 16                	jmp    80100d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ff7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ffb:	83 ec 08             	sub    $0x8,%esp
  800ffe:	ff 75 0c             	pushl  0xc(%ebp)
  801001:	50                   	push   %eax
  801002:	8b 45 08             	mov    0x8(%ebp),%eax
  801005:	ff d0                	call   *%eax
  801007:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80100a:	ff 4d e4             	decl   -0x1c(%ebp)
  80100d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801011:	7f e4                	jg     800ff7 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801013:	eb 34                	jmp    801049 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801015:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801019:	74 1c                	je     801037 <vprintfmt+0x207>
  80101b:	83 fb 1f             	cmp    $0x1f,%ebx
  80101e:	7e 05                	jle    801025 <vprintfmt+0x1f5>
  801020:	83 fb 7e             	cmp    $0x7e,%ebx
  801023:	7e 12                	jle    801037 <vprintfmt+0x207>
					putch('?', putdat);
  801025:	83 ec 08             	sub    $0x8,%esp
  801028:	ff 75 0c             	pushl  0xc(%ebp)
  80102b:	6a 3f                	push   $0x3f
  80102d:	8b 45 08             	mov    0x8(%ebp),%eax
  801030:	ff d0                	call   *%eax
  801032:	83 c4 10             	add    $0x10,%esp
  801035:	eb 0f                	jmp    801046 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801037:	83 ec 08             	sub    $0x8,%esp
  80103a:	ff 75 0c             	pushl  0xc(%ebp)
  80103d:	53                   	push   %ebx
  80103e:	8b 45 08             	mov    0x8(%ebp),%eax
  801041:	ff d0                	call   *%eax
  801043:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801046:	ff 4d e4             	decl   -0x1c(%ebp)
  801049:	89 f0                	mov    %esi,%eax
  80104b:	8d 70 01             	lea    0x1(%eax),%esi
  80104e:	8a 00                	mov    (%eax),%al
  801050:	0f be d8             	movsbl %al,%ebx
  801053:	85 db                	test   %ebx,%ebx
  801055:	74 24                	je     80107b <vprintfmt+0x24b>
  801057:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80105b:	78 b8                	js     801015 <vprintfmt+0x1e5>
  80105d:	ff 4d e0             	decl   -0x20(%ebp)
  801060:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801064:	79 af                	jns    801015 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801066:	eb 13                	jmp    80107b <vprintfmt+0x24b>
				putch(' ', putdat);
  801068:	83 ec 08             	sub    $0x8,%esp
  80106b:	ff 75 0c             	pushl  0xc(%ebp)
  80106e:	6a 20                	push   $0x20
  801070:	8b 45 08             	mov    0x8(%ebp),%eax
  801073:	ff d0                	call   *%eax
  801075:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801078:	ff 4d e4             	decl   -0x1c(%ebp)
  80107b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80107f:	7f e7                	jg     801068 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801081:	e9 66 01 00 00       	jmp    8011ec <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801086:	83 ec 08             	sub    $0x8,%esp
  801089:	ff 75 e8             	pushl  -0x18(%ebp)
  80108c:	8d 45 14             	lea    0x14(%ebp),%eax
  80108f:	50                   	push   %eax
  801090:	e8 3c fd ff ff       	call   800dd1 <getint>
  801095:	83 c4 10             	add    $0x10,%esp
  801098:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80109b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80109e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010a4:	85 d2                	test   %edx,%edx
  8010a6:	79 23                	jns    8010cb <vprintfmt+0x29b>
				putch('-', putdat);
  8010a8:	83 ec 08             	sub    $0x8,%esp
  8010ab:	ff 75 0c             	pushl  0xc(%ebp)
  8010ae:	6a 2d                	push   $0x2d
  8010b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b3:	ff d0                	call   *%eax
  8010b5:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8010b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010be:	f7 d8                	neg    %eax
  8010c0:	83 d2 00             	adc    $0x0,%edx
  8010c3:	f7 da                	neg    %edx
  8010c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010c8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8010cb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010d2:	e9 bc 00 00 00       	jmp    801193 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8010d7:	83 ec 08             	sub    $0x8,%esp
  8010da:	ff 75 e8             	pushl  -0x18(%ebp)
  8010dd:	8d 45 14             	lea    0x14(%ebp),%eax
  8010e0:	50                   	push   %eax
  8010e1:	e8 84 fc ff ff       	call   800d6a <getuint>
  8010e6:	83 c4 10             	add    $0x10,%esp
  8010e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010ec:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8010ef:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010f6:	e9 98 00 00 00       	jmp    801193 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8010fb:	83 ec 08             	sub    $0x8,%esp
  8010fe:	ff 75 0c             	pushl  0xc(%ebp)
  801101:	6a 58                	push   $0x58
  801103:	8b 45 08             	mov    0x8(%ebp),%eax
  801106:	ff d0                	call   *%eax
  801108:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80110b:	83 ec 08             	sub    $0x8,%esp
  80110e:	ff 75 0c             	pushl  0xc(%ebp)
  801111:	6a 58                	push   $0x58
  801113:	8b 45 08             	mov    0x8(%ebp),%eax
  801116:	ff d0                	call   *%eax
  801118:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80111b:	83 ec 08             	sub    $0x8,%esp
  80111e:	ff 75 0c             	pushl  0xc(%ebp)
  801121:	6a 58                	push   $0x58
  801123:	8b 45 08             	mov    0x8(%ebp),%eax
  801126:	ff d0                	call   *%eax
  801128:	83 c4 10             	add    $0x10,%esp
			break;
  80112b:	e9 bc 00 00 00       	jmp    8011ec <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801130:	83 ec 08             	sub    $0x8,%esp
  801133:	ff 75 0c             	pushl  0xc(%ebp)
  801136:	6a 30                	push   $0x30
  801138:	8b 45 08             	mov    0x8(%ebp),%eax
  80113b:	ff d0                	call   *%eax
  80113d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801140:	83 ec 08             	sub    $0x8,%esp
  801143:	ff 75 0c             	pushl  0xc(%ebp)
  801146:	6a 78                	push   $0x78
  801148:	8b 45 08             	mov    0x8(%ebp),%eax
  80114b:	ff d0                	call   *%eax
  80114d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801150:	8b 45 14             	mov    0x14(%ebp),%eax
  801153:	83 c0 04             	add    $0x4,%eax
  801156:	89 45 14             	mov    %eax,0x14(%ebp)
  801159:	8b 45 14             	mov    0x14(%ebp),%eax
  80115c:	83 e8 04             	sub    $0x4,%eax
  80115f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801161:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801164:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80116b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801172:	eb 1f                	jmp    801193 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801174:	83 ec 08             	sub    $0x8,%esp
  801177:	ff 75 e8             	pushl  -0x18(%ebp)
  80117a:	8d 45 14             	lea    0x14(%ebp),%eax
  80117d:	50                   	push   %eax
  80117e:	e8 e7 fb ff ff       	call   800d6a <getuint>
  801183:	83 c4 10             	add    $0x10,%esp
  801186:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801189:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80118c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801193:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801197:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80119a:	83 ec 04             	sub    $0x4,%esp
  80119d:	52                   	push   %edx
  80119e:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011a1:	50                   	push   %eax
  8011a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8011a5:	ff 75 f0             	pushl  -0x10(%ebp)
  8011a8:	ff 75 0c             	pushl  0xc(%ebp)
  8011ab:	ff 75 08             	pushl  0x8(%ebp)
  8011ae:	e8 00 fb ff ff       	call   800cb3 <printnum>
  8011b3:	83 c4 20             	add    $0x20,%esp
			break;
  8011b6:	eb 34                	jmp    8011ec <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8011b8:	83 ec 08             	sub    $0x8,%esp
  8011bb:	ff 75 0c             	pushl  0xc(%ebp)
  8011be:	53                   	push   %ebx
  8011bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c2:	ff d0                	call   *%eax
  8011c4:	83 c4 10             	add    $0x10,%esp
			break;
  8011c7:	eb 23                	jmp    8011ec <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8011c9:	83 ec 08             	sub    $0x8,%esp
  8011cc:	ff 75 0c             	pushl  0xc(%ebp)
  8011cf:	6a 25                	push   $0x25
  8011d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d4:	ff d0                	call   *%eax
  8011d6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8011d9:	ff 4d 10             	decl   0x10(%ebp)
  8011dc:	eb 03                	jmp    8011e1 <vprintfmt+0x3b1>
  8011de:	ff 4d 10             	decl   0x10(%ebp)
  8011e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e4:	48                   	dec    %eax
  8011e5:	8a 00                	mov    (%eax),%al
  8011e7:	3c 25                	cmp    $0x25,%al
  8011e9:	75 f3                	jne    8011de <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8011eb:	90                   	nop
		}
	}
  8011ec:	e9 47 fc ff ff       	jmp    800e38 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8011f1:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8011f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011f5:	5b                   	pop    %ebx
  8011f6:	5e                   	pop    %esi
  8011f7:	5d                   	pop    %ebp
  8011f8:	c3                   	ret    

008011f9 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8011f9:	55                   	push   %ebp
  8011fa:	89 e5                	mov    %esp,%ebp
  8011fc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8011ff:	8d 45 10             	lea    0x10(%ebp),%eax
  801202:	83 c0 04             	add    $0x4,%eax
  801205:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801208:	8b 45 10             	mov    0x10(%ebp),%eax
  80120b:	ff 75 f4             	pushl  -0xc(%ebp)
  80120e:	50                   	push   %eax
  80120f:	ff 75 0c             	pushl  0xc(%ebp)
  801212:	ff 75 08             	pushl  0x8(%ebp)
  801215:	e8 16 fc ff ff       	call   800e30 <vprintfmt>
  80121a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80121d:	90                   	nop
  80121e:	c9                   	leave  
  80121f:	c3                   	ret    

00801220 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801220:	55                   	push   %ebp
  801221:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801223:	8b 45 0c             	mov    0xc(%ebp),%eax
  801226:	8b 40 08             	mov    0x8(%eax),%eax
  801229:	8d 50 01             	lea    0x1(%eax),%edx
  80122c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801232:	8b 45 0c             	mov    0xc(%ebp),%eax
  801235:	8b 10                	mov    (%eax),%edx
  801237:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123a:	8b 40 04             	mov    0x4(%eax),%eax
  80123d:	39 c2                	cmp    %eax,%edx
  80123f:	73 12                	jae    801253 <sprintputch+0x33>
		*b->buf++ = ch;
  801241:	8b 45 0c             	mov    0xc(%ebp),%eax
  801244:	8b 00                	mov    (%eax),%eax
  801246:	8d 48 01             	lea    0x1(%eax),%ecx
  801249:	8b 55 0c             	mov    0xc(%ebp),%edx
  80124c:	89 0a                	mov    %ecx,(%edx)
  80124e:	8b 55 08             	mov    0x8(%ebp),%edx
  801251:	88 10                	mov    %dl,(%eax)
}
  801253:	90                   	nop
  801254:	5d                   	pop    %ebp
  801255:	c3                   	ret    

00801256 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801256:	55                   	push   %ebp
  801257:	89 e5                	mov    %esp,%ebp
  801259:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80125c:	8b 45 08             	mov    0x8(%ebp),%eax
  80125f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801262:	8b 45 0c             	mov    0xc(%ebp),%eax
  801265:	8d 50 ff             	lea    -0x1(%eax),%edx
  801268:	8b 45 08             	mov    0x8(%ebp),%eax
  80126b:	01 d0                	add    %edx,%eax
  80126d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801270:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801277:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80127b:	74 06                	je     801283 <vsnprintf+0x2d>
  80127d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801281:	7f 07                	jg     80128a <vsnprintf+0x34>
		return -E_INVAL;
  801283:	b8 03 00 00 00       	mov    $0x3,%eax
  801288:	eb 20                	jmp    8012aa <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80128a:	ff 75 14             	pushl  0x14(%ebp)
  80128d:	ff 75 10             	pushl  0x10(%ebp)
  801290:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801293:	50                   	push   %eax
  801294:	68 20 12 80 00       	push   $0x801220
  801299:	e8 92 fb ff ff       	call   800e30 <vprintfmt>
  80129e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8012a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012a4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8012a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8012aa:	c9                   	leave  
  8012ab:	c3                   	ret    

008012ac <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8012ac:	55                   	push   %ebp
  8012ad:	89 e5                	mov    %esp,%ebp
  8012af:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8012b2:	8d 45 10             	lea    0x10(%ebp),%eax
  8012b5:	83 c0 04             	add    $0x4,%eax
  8012b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8012bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8012be:	ff 75 f4             	pushl  -0xc(%ebp)
  8012c1:	50                   	push   %eax
  8012c2:	ff 75 0c             	pushl  0xc(%ebp)
  8012c5:	ff 75 08             	pushl  0x8(%ebp)
  8012c8:	e8 89 ff ff ff       	call   801256 <vsnprintf>
  8012cd:	83 c4 10             	add    $0x10,%esp
  8012d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8012d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012d6:	c9                   	leave  
  8012d7:	c3                   	ret    

008012d8 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8012d8:	55                   	push   %ebp
  8012d9:	89 e5                	mov    %esp,%ebp
  8012db:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  8012de:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012e2:	74 13                	je     8012f7 <readline+0x1f>
		cprintf("%s", prompt);
  8012e4:	83 ec 08             	sub    $0x8,%esp
  8012e7:	ff 75 08             	pushl  0x8(%ebp)
  8012ea:	68 90 43 80 00       	push   $0x804390
  8012ef:	e8 62 f9 ff ff       	call   800c56 <cprintf>
  8012f4:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8012f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8012fe:	83 ec 0c             	sub    $0xc,%esp
  801301:	6a 00                	push   $0x0
  801303:	e8 54 f5 ff ff       	call   80085c <iscons>
  801308:	83 c4 10             	add    $0x10,%esp
  80130b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  80130e:	e8 fb f4 ff ff       	call   80080e <getchar>
  801313:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801316:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80131a:	79 22                	jns    80133e <readline+0x66>
			if (c != -E_EOF)
  80131c:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801320:	0f 84 ad 00 00 00    	je     8013d3 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801326:	83 ec 08             	sub    $0x8,%esp
  801329:	ff 75 ec             	pushl  -0x14(%ebp)
  80132c:	68 93 43 80 00       	push   $0x804393
  801331:	e8 20 f9 ff ff       	call   800c56 <cprintf>
  801336:	83 c4 10             	add    $0x10,%esp
			return;
  801339:	e9 95 00 00 00       	jmp    8013d3 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80133e:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801342:	7e 34                	jle    801378 <readline+0xa0>
  801344:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80134b:	7f 2b                	jg     801378 <readline+0xa0>
			if (echoing)
  80134d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801351:	74 0e                	je     801361 <readline+0x89>
				cputchar(c);
  801353:	83 ec 0c             	sub    $0xc,%esp
  801356:	ff 75 ec             	pushl  -0x14(%ebp)
  801359:	e8 68 f4 ff ff       	call   8007c6 <cputchar>
  80135e:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801361:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801364:	8d 50 01             	lea    0x1(%eax),%edx
  801367:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80136a:	89 c2                	mov    %eax,%edx
  80136c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136f:	01 d0                	add    %edx,%eax
  801371:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801374:	88 10                	mov    %dl,(%eax)
  801376:	eb 56                	jmp    8013ce <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801378:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80137c:	75 1f                	jne    80139d <readline+0xc5>
  80137e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801382:	7e 19                	jle    80139d <readline+0xc5>
			if (echoing)
  801384:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801388:	74 0e                	je     801398 <readline+0xc0>
				cputchar(c);
  80138a:	83 ec 0c             	sub    $0xc,%esp
  80138d:	ff 75 ec             	pushl  -0x14(%ebp)
  801390:	e8 31 f4 ff ff       	call   8007c6 <cputchar>
  801395:	83 c4 10             	add    $0x10,%esp

			i--;
  801398:	ff 4d f4             	decl   -0xc(%ebp)
  80139b:	eb 31                	jmp    8013ce <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  80139d:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8013a1:	74 0a                	je     8013ad <readline+0xd5>
  8013a3:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8013a7:	0f 85 61 ff ff ff    	jne    80130e <readline+0x36>
			if (echoing)
  8013ad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013b1:	74 0e                	je     8013c1 <readline+0xe9>
				cputchar(c);
  8013b3:	83 ec 0c             	sub    $0xc,%esp
  8013b6:	ff 75 ec             	pushl  -0x14(%ebp)
  8013b9:	e8 08 f4 ff ff       	call   8007c6 <cputchar>
  8013be:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8013c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c7:	01 d0                	add    %edx,%eax
  8013c9:	c6 00 00             	movb   $0x0,(%eax)
			return;
  8013cc:	eb 06                	jmp    8013d4 <readline+0xfc>
		}
	}
  8013ce:	e9 3b ff ff ff       	jmp    80130e <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  8013d3:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  8013d4:	c9                   	leave  
  8013d5:	c3                   	ret    

008013d6 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8013d6:	55                   	push   %ebp
  8013d7:	89 e5                	mov    %esp,%ebp
  8013d9:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8013dc:	e8 04 0f 00 00       	call   8022e5 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  8013e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013e5:	74 13                	je     8013fa <atomic_readline+0x24>
		cprintf("%s", prompt);
  8013e7:	83 ec 08             	sub    $0x8,%esp
  8013ea:	ff 75 08             	pushl  0x8(%ebp)
  8013ed:	68 90 43 80 00       	push   $0x804390
  8013f2:	e8 5f f8 ff ff       	call   800c56 <cprintf>
  8013f7:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8013fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801401:	83 ec 0c             	sub    $0xc,%esp
  801404:	6a 00                	push   $0x0
  801406:	e8 51 f4 ff ff       	call   80085c <iscons>
  80140b:	83 c4 10             	add    $0x10,%esp
  80140e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801411:	e8 f8 f3 ff ff       	call   80080e <getchar>
  801416:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801419:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80141d:	79 23                	jns    801442 <atomic_readline+0x6c>
			if (c != -E_EOF)
  80141f:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801423:	74 13                	je     801438 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  801425:	83 ec 08             	sub    $0x8,%esp
  801428:	ff 75 ec             	pushl  -0x14(%ebp)
  80142b:	68 93 43 80 00       	push   $0x804393
  801430:	e8 21 f8 ff ff       	call   800c56 <cprintf>
  801435:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801438:	e8 c2 0e 00 00       	call   8022ff <sys_enable_interrupt>
			return;
  80143d:	e9 9a 00 00 00       	jmp    8014dc <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801442:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801446:	7e 34                	jle    80147c <atomic_readline+0xa6>
  801448:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80144f:	7f 2b                	jg     80147c <atomic_readline+0xa6>
			if (echoing)
  801451:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801455:	74 0e                	je     801465 <atomic_readline+0x8f>
				cputchar(c);
  801457:	83 ec 0c             	sub    $0xc,%esp
  80145a:	ff 75 ec             	pushl  -0x14(%ebp)
  80145d:	e8 64 f3 ff ff       	call   8007c6 <cputchar>
  801462:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801465:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801468:	8d 50 01             	lea    0x1(%eax),%edx
  80146b:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80146e:	89 c2                	mov    %eax,%edx
  801470:	8b 45 0c             	mov    0xc(%ebp),%eax
  801473:	01 d0                	add    %edx,%eax
  801475:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801478:	88 10                	mov    %dl,(%eax)
  80147a:	eb 5b                	jmp    8014d7 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  80147c:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801480:	75 1f                	jne    8014a1 <atomic_readline+0xcb>
  801482:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801486:	7e 19                	jle    8014a1 <atomic_readline+0xcb>
			if (echoing)
  801488:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80148c:	74 0e                	je     80149c <atomic_readline+0xc6>
				cputchar(c);
  80148e:	83 ec 0c             	sub    $0xc,%esp
  801491:	ff 75 ec             	pushl  -0x14(%ebp)
  801494:	e8 2d f3 ff ff       	call   8007c6 <cputchar>
  801499:	83 c4 10             	add    $0x10,%esp
			i--;
  80149c:	ff 4d f4             	decl   -0xc(%ebp)
  80149f:	eb 36                	jmp    8014d7 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  8014a1:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8014a5:	74 0a                	je     8014b1 <atomic_readline+0xdb>
  8014a7:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8014ab:	0f 85 60 ff ff ff    	jne    801411 <atomic_readline+0x3b>
			if (echoing)
  8014b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8014b5:	74 0e                	je     8014c5 <atomic_readline+0xef>
				cputchar(c);
  8014b7:	83 ec 0c             	sub    $0xc,%esp
  8014ba:	ff 75 ec             	pushl  -0x14(%ebp)
  8014bd:	e8 04 f3 ff ff       	call   8007c6 <cputchar>
  8014c2:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  8014c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014cb:	01 d0                	add    %edx,%eax
  8014cd:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  8014d0:	e8 2a 0e 00 00       	call   8022ff <sys_enable_interrupt>
			return;
  8014d5:	eb 05                	jmp    8014dc <atomic_readline+0x106>
		}
	}
  8014d7:	e9 35 ff ff ff       	jmp    801411 <atomic_readline+0x3b>
}
  8014dc:	c9                   	leave  
  8014dd:	c3                   	ret    

008014de <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8014de:	55                   	push   %ebp
  8014df:	89 e5                	mov    %esp,%ebp
  8014e1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8014e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014eb:	eb 06                	jmp    8014f3 <strlen+0x15>
		n++;
  8014ed:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8014f0:	ff 45 08             	incl   0x8(%ebp)
  8014f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f6:	8a 00                	mov    (%eax),%al
  8014f8:	84 c0                	test   %al,%al
  8014fa:	75 f1                	jne    8014ed <strlen+0xf>
		n++;
	return n;
  8014fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8014ff:	c9                   	leave  
  801500:	c3                   	ret    

00801501 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801501:	55                   	push   %ebp
  801502:	89 e5                	mov    %esp,%ebp
  801504:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801507:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80150e:	eb 09                	jmp    801519 <strnlen+0x18>
		n++;
  801510:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801513:	ff 45 08             	incl   0x8(%ebp)
  801516:	ff 4d 0c             	decl   0xc(%ebp)
  801519:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80151d:	74 09                	je     801528 <strnlen+0x27>
  80151f:	8b 45 08             	mov    0x8(%ebp),%eax
  801522:	8a 00                	mov    (%eax),%al
  801524:	84 c0                	test   %al,%al
  801526:	75 e8                	jne    801510 <strnlen+0xf>
		n++;
	return n;
  801528:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80152b:	c9                   	leave  
  80152c:	c3                   	ret    

0080152d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80152d:	55                   	push   %ebp
  80152e:	89 e5                	mov    %esp,%ebp
  801530:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801533:	8b 45 08             	mov    0x8(%ebp),%eax
  801536:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801539:	90                   	nop
  80153a:	8b 45 08             	mov    0x8(%ebp),%eax
  80153d:	8d 50 01             	lea    0x1(%eax),%edx
  801540:	89 55 08             	mov    %edx,0x8(%ebp)
  801543:	8b 55 0c             	mov    0xc(%ebp),%edx
  801546:	8d 4a 01             	lea    0x1(%edx),%ecx
  801549:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80154c:	8a 12                	mov    (%edx),%dl
  80154e:	88 10                	mov    %dl,(%eax)
  801550:	8a 00                	mov    (%eax),%al
  801552:	84 c0                	test   %al,%al
  801554:	75 e4                	jne    80153a <strcpy+0xd>
		/* do nothing */;
	return ret;
  801556:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801559:	c9                   	leave  
  80155a:	c3                   	ret    

0080155b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80155b:	55                   	push   %ebp
  80155c:	89 e5                	mov    %esp,%ebp
  80155e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801561:	8b 45 08             	mov    0x8(%ebp),%eax
  801564:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801567:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80156e:	eb 1f                	jmp    80158f <strncpy+0x34>
		*dst++ = *src;
  801570:	8b 45 08             	mov    0x8(%ebp),%eax
  801573:	8d 50 01             	lea    0x1(%eax),%edx
  801576:	89 55 08             	mov    %edx,0x8(%ebp)
  801579:	8b 55 0c             	mov    0xc(%ebp),%edx
  80157c:	8a 12                	mov    (%edx),%dl
  80157e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801580:	8b 45 0c             	mov    0xc(%ebp),%eax
  801583:	8a 00                	mov    (%eax),%al
  801585:	84 c0                	test   %al,%al
  801587:	74 03                	je     80158c <strncpy+0x31>
			src++;
  801589:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80158c:	ff 45 fc             	incl   -0x4(%ebp)
  80158f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801592:	3b 45 10             	cmp    0x10(%ebp),%eax
  801595:	72 d9                	jb     801570 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801597:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80159a:	c9                   	leave  
  80159b:	c3                   	ret    

0080159c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80159c:	55                   	push   %ebp
  80159d:	89 e5                	mov    %esp,%ebp
  80159f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8015a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8015a8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015ac:	74 30                	je     8015de <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8015ae:	eb 16                	jmp    8015c6 <strlcpy+0x2a>
			*dst++ = *src++;
  8015b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b3:	8d 50 01             	lea    0x1(%eax),%edx
  8015b6:	89 55 08             	mov    %edx,0x8(%ebp)
  8015b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015bc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015bf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8015c2:	8a 12                	mov    (%edx),%dl
  8015c4:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8015c6:	ff 4d 10             	decl   0x10(%ebp)
  8015c9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015cd:	74 09                	je     8015d8 <strlcpy+0x3c>
  8015cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d2:	8a 00                	mov    (%eax),%al
  8015d4:	84 c0                	test   %al,%al
  8015d6:	75 d8                	jne    8015b0 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8015d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015db:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8015de:	8b 55 08             	mov    0x8(%ebp),%edx
  8015e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015e4:	29 c2                	sub    %eax,%edx
  8015e6:	89 d0                	mov    %edx,%eax
}
  8015e8:	c9                   	leave  
  8015e9:	c3                   	ret    

008015ea <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8015ea:	55                   	push   %ebp
  8015eb:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8015ed:	eb 06                	jmp    8015f5 <strcmp+0xb>
		p++, q++;
  8015ef:	ff 45 08             	incl   0x8(%ebp)
  8015f2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8015f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f8:	8a 00                	mov    (%eax),%al
  8015fa:	84 c0                	test   %al,%al
  8015fc:	74 0e                	je     80160c <strcmp+0x22>
  8015fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801601:	8a 10                	mov    (%eax),%dl
  801603:	8b 45 0c             	mov    0xc(%ebp),%eax
  801606:	8a 00                	mov    (%eax),%al
  801608:	38 c2                	cmp    %al,%dl
  80160a:	74 e3                	je     8015ef <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80160c:	8b 45 08             	mov    0x8(%ebp),%eax
  80160f:	8a 00                	mov    (%eax),%al
  801611:	0f b6 d0             	movzbl %al,%edx
  801614:	8b 45 0c             	mov    0xc(%ebp),%eax
  801617:	8a 00                	mov    (%eax),%al
  801619:	0f b6 c0             	movzbl %al,%eax
  80161c:	29 c2                	sub    %eax,%edx
  80161e:	89 d0                	mov    %edx,%eax
}
  801620:	5d                   	pop    %ebp
  801621:	c3                   	ret    

00801622 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801622:	55                   	push   %ebp
  801623:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801625:	eb 09                	jmp    801630 <strncmp+0xe>
		n--, p++, q++;
  801627:	ff 4d 10             	decl   0x10(%ebp)
  80162a:	ff 45 08             	incl   0x8(%ebp)
  80162d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801630:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801634:	74 17                	je     80164d <strncmp+0x2b>
  801636:	8b 45 08             	mov    0x8(%ebp),%eax
  801639:	8a 00                	mov    (%eax),%al
  80163b:	84 c0                	test   %al,%al
  80163d:	74 0e                	je     80164d <strncmp+0x2b>
  80163f:	8b 45 08             	mov    0x8(%ebp),%eax
  801642:	8a 10                	mov    (%eax),%dl
  801644:	8b 45 0c             	mov    0xc(%ebp),%eax
  801647:	8a 00                	mov    (%eax),%al
  801649:	38 c2                	cmp    %al,%dl
  80164b:	74 da                	je     801627 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80164d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801651:	75 07                	jne    80165a <strncmp+0x38>
		return 0;
  801653:	b8 00 00 00 00       	mov    $0x0,%eax
  801658:	eb 14                	jmp    80166e <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80165a:	8b 45 08             	mov    0x8(%ebp),%eax
  80165d:	8a 00                	mov    (%eax),%al
  80165f:	0f b6 d0             	movzbl %al,%edx
  801662:	8b 45 0c             	mov    0xc(%ebp),%eax
  801665:	8a 00                	mov    (%eax),%al
  801667:	0f b6 c0             	movzbl %al,%eax
  80166a:	29 c2                	sub    %eax,%edx
  80166c:	89 d0                	mov    %edx,%eax
}
  80166e:	5d                   	pop    %ebp
  80166f:	c3                   	ret    

00801670 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801670:	55                   	push   %ebp
  801671:	89 e5                	mov    %esp,%ebp
  801673:	83 ec 04             	sub    $0x4,%esp
  801676:	8b 45 0c             	mov    0xc(%ebp),%eax
  801679:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80167c:	eb 12                	jmp    801690 <strchr+0x20>
		if (*s == c)
  80167e:	8b 45 08             	mov    0x8(%ebp),%eax
  801681:	8a 00                	mov    (%eax),%al
  801683:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801686:	75 05                	jne    80168d <strchr+0x1d>
			return (char *) s;
  801688:	8b 45 08             	mov    0x8(%ebp),%eax
  80168b:	eb 11                	jmp    80169e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80168d:	ff 45 08             	incl   0x8(%ebp)
  801690:	8b 45 08             	mov    0x8(%ebp),%eax
  801693:	8a 00                	mov    (%eax),%al
  801695:	84 c0                	test   %al,%al
  801697:	75 e5                	jne    80167e <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801699:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80169e:	c9                   	leave  
  80169f:	c3                   	ret    

008016a0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
  8016a3:	83 ec 04             	sub    $0x4,%esp
  8016a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8016ac:	eb 0d                	jmp    8016bb <strfind+0x1b>
		if (*s == c)
  8016ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b1:	8a 00                	mov    (%eax),%al
  8016b3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8016b6:	74 0e                	je     8016c6 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8016b8:	ff 45 08             	incl   0x8(%ebp)
  8016bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016be:	8a 00                	mov    (%eax),%al
  8016c0:	84 c0                	test   %al,%al
  8016c2:	75 ea                	jne    8016ae <strfind+0xe>
  8016c4:	eb 01                	jmp    8016c7 <strfind+0x27>
		if (*s == c)
			break;
  8016c6:	90                   	nop
	return (char *) s;
  8016c7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016ca:	c9                   	leave  
  8016cb:	c3                   	ret    

008016cc <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8016cc:	55                   	push   %ebp
  8016cd:	89 e5                	mov    %esp,%ebp
  8016cf:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8016d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8016d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8016db:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8016de:	eb 0e                	jmp    8016ee <memset+0x22>
		*p++ = c;
  8016e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016e3:	8d 50 01             	lea    0x1(%eax),%edx
  8016e6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8016e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ec:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8016ee:	ff 4d f8             	decl   -0x8(%ebp)
  8016f1:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8016f5:	79 e9                	jns    8016e0 <memset+0x14>
		*p++ = c;

	return v;
  8016f7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016fa:	c9                   	leave  
  8016fb:	c3                   	ret    

008016fc <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8016fc:	55                   	push   %ebp
  8016fd:	89 e5                	mov    %esp,%ebp
  8016ff:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801702:	8b 45 0c             	mov    0xc(%ebp),%eax
  801705:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801708:	8b 45 08             	mov    0x8(%ebp),%eax
  80170b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80170e:	eb 16                	jmp    801726 <memcpy+0x2a>
		*d++ = *s++;
  801710:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801713:	8d 50 01             	lea    0x1(%eax),%edx
  801716:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801719:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80171c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80171f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801722:	8a 12                	mov    (%edx),%dl
  801724:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801726:	8b 45 10             	mov    0x10(%ebp),%eax
  801729:	8d 50 ff             	lea    -0x1(%eax),%edx
  80172c:	89 55 10             	mov    %edx,0x10(%ebp)
  80172f:	85 c0                	test   %eax,%eax
  801731:	75 dd                	jne    801710 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801733:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801736:	c9                   	leave  
  801737:	c3                   	ret    

00801738 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801738:	55                   	push   %ebp
  801739:	89 e5                	mov    %esp,%ebp
  80173b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80173e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801741:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801744:	8b 45 08             	mov    0x8(%ebp),%eax
  801747:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80174a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80174d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801750:	73 50                	jae    8017a2 <memmove+0x6a>
  801752:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801755:	8b 45 10             	mov    0x10(%ebp),%eax
  801758:	01 d0                	add    %edx,%eax
  80175a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80175d:	76 43                	jbe    8017a2 <memmove+0x6a>
		s += n;
  80175f:	8b 45 10             	mov    0x10(%ebp),%eax
  801762:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801765:	8b 45 10             	mov    0x10(%ebp),%eax
  801768:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80176b:	eb 10                	jmp    80177d <memmove+0x45>
			*--d = *--s;
  80176d:	ff 4d f8             	decl   -0x8(%ebp)
  801770:	ff 4d fc             	decl   -0x4(%ebp)
  801773:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801776:	8a 10                	mov    (%eax),%dl
  801778:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80177b:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80177d:	8b 45 10             	mov    0x10(%ebp),%eax
  801780:	8d 50 ff             	lea    -0x1(%eax),%edx
  801783:	89 55 10             	mov    %edx,0x10(%ebp)
  801786:	85 c0                	test   %eax,%eax
  801788:	75 e3                	jne    80176d <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80178a:	eb 23                	jmp    8017af <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80178c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80178f:	8d 50 01             	lea    0x1(%eax),%edx
  801792:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801795:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801798:	8d 4a 01             	lea    0x1(%edx),%ecx
  80179b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80179e:	8a 12                	mov    (%edx),%dl
  8017a0:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8017a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8017a5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017a8:	89 55 10             	mov    %edx,0x10(%ebp)
  8017ab:	85 c0                	test   %eax,%eax
  8017ad:	75 dd                	jne    80178c <memmove+0x54>
			*d++ = *s++;

	return dst;
  8017af:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017b2:	c9                   	leave  
  8017b3:	c3                   	ret    

008017b4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8017b4:	55                   	push   %ebp
  8017b5:	89 e5                	mov    %esp,%ebp
  8017b7:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8017ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8017c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c3:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8017c6:	eb 2a                	jmp    8017f2 <memcmp+0x3e>
		if (*s1 != *s2)
  8017c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017cb:	8a 10                	mov    (%eax),%dl
  8017cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017d0:	8a 00                	mov    (%eax),%al
  8017d2:	38 c2                	cmp    %al,%dl
  8017d4:	74 16                	je     8017ec <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8017d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017d9:	8a 00                	mov    (%eax),%al
  8017db:	0f b6 d0             	movzbl %al,%edx
  8017de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017e1:	8a 00                	mov    (%eax),%al
  8017e3:	0f b6 c0             	movzbl %al,%eax
  8017e6:	29 c2                	sub    %eax,%edx
  8017e8:	89 d0                	mov    %edx,%eax
  8017ea:	eb 18                	jmp    801804 <memcmp+0x50>
		s1++, s2++;
  8017ec:	ff 45 fc             	incl   -0x4(%ebp)
  8017ef:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8017f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8017f5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017f8:	89 55 10             	mov    %edx,0x10(%ebp)
  8017fb:	85 c0                	test   %eax,%eax
  8017fd:	75 c9                	jne    8017c8 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8017ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801804:	c9                   	leave  
  801805:	c3                   	ret    

00801806 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801806:	55                   	push   %ebp
  801807:	89 e5                	mov    %esp,%ebp
  801809:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80180c:	8b 55 08             	mov    0x8(%ebp),%edx
  80180f:	8b 45 10             	mov    0x10(%ebp),%eax
  801812:	01 d0                	add    %edx,%eax
  801814:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801817:	eb 15                	jmp    80182e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801819:	8b 45 08             	mov    0x8(%ebp),%eax
  80181c:	8a 00                	mov    (%eax),%al
  80181e:	0f b6 d0             	movzbl %al,%edx
  801821:	8b 45 0c             	mov    0xc(%ebp),%eax
  801824:	0f b6 c0             	movzbl %al,%eax
  801827:	39 c2                	cmp    %eax,%edx
  801829:	74 0d                	je     801838 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80182b:	ff 45 08             	incl   0x8(%ebp)
  80182e:	8b 45 08             	mov    0x8(%ebp),%eax
  801831:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801834:	72 e3                	jb     801819 <memfind+0x13>
  801836:	eb 01                	jmp    801839 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801838:	90                   	nop
	return (void *) s;
  801839:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80183c:	c9                   	leave  
  80183d:	c3                   	ret    

0080183e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80183e:	55                   	push   %ebp
  80183f:	89 e5                	mov    %esp,%ebp
  801841:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801844:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80184b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801852:	eb 03                	jmp    801857 <strtol+0x19>
		s++;
  801854:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801857:	8b 45 08             	mov    0x8(%ebp),%eax
  80185a:	8a 00                	mov    (%eax),%al
  80185c:	3c 20                	cmp    $0x20,%al
  80185e:	74 f4                	je     801854 <strtol+0x16>
  801860:	8b 45 08             	mov    0x8(%ebp),%eax
  801863:	8a 00                	mov    (%eax),%al
  801865:	3c 09                	cmp    $0x9,%al
  801867:	74 eb                	je     801854 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801869:	8b 45 08             	mov    0x8(%ebp),%eax
  80186c:	8a 00                	mov    (%eax),%al
  80186e:	3c 2b                	cmp    $0x2b,%al
  801870:	75 05                	jne    801877 <strtol+0x39>
		s++;
  801872:	ff 45 08             	incl   0x8(%ebp)
  801875:	eb 13                	jmp    80188a <strtol+0x4c>
	else if (*s == '-')
  801877:	8b 45 08             	mov    0x8(%ebp),%eax
  80187a:	8a 00                	mov    (%eax),%al
  80187c:	3c 2d                	cmp    $0x2d,%al
  80187e:	75 0a                	jne    80188a <strtol+0x4c>
		s++, neg = 1;
  801880:	ff 45 08             	incl   0x8(%ebp)
  801883:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80188a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80188e:	74 06                	je     801896 <strtol+0x58>
  801890:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801894:	75 20                	jne    8018b6 <strtol+0x78>
  801896:	8b 45 08             	mov    0x8(%ebp),%eax
  801899:	8a 00                	mov    (%eax),%al
  80189b:	3c 30                	cmp    $0x30,%al
  80189d:	75 17                	jne    8018b6 <strtol+0x78>
  80189f:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a2:	40                   	inc    %eax
  8018a3:	8a 00                	mov    (%eax),%al
  8018a5:	3c 78                	cmp    $0x78,%al
  8018a7:	75 0d                	jne    8018b6 <strtol+0x78>
		s += 2, base = 16;
  8018a9:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8018ad:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8018b4:	eb 28                	jmp    8018de <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8018b6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018ba:	75 15                	jne    8018d1 <strtol+0x93>
  8018bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bf:	8a 00                	mov    (%eax),%al
  8018c1:	3c 30                	cmp    $0x30,%al
  8018c3:	75 0c                	jne    8018d1 <strtol+0x93>
		s++, base = 8;
  8018c5:	ff 45 08             	incl   0x8(%ebp)
  8018c8:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8018cf:	eb 0d                	jmp    8018de <strtol+0xa0>
	else if (base == 0)
  8018d1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018d5:	75 07                	jne    8018de <strtol+0xa0>
		base = 10;
  8018d7:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8018de:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e1:	8a 00                	mov    (%eax),%al
  8018e3:	3c 2f                	cmp    $0x2f,%al
  8018e5:	7e 19                	jle    801900 <strtol+0xc2>
  8018e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ea:	8a 00                	mov    (%eax),%al
  8018ec:	3c 39                	cmp    $0x39,%al
  8018ee:	7f 10                	jg     801900 <strtol+0xc2>
			dig = *s - '0';
  8018f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f3:	8a 00                	mov    (%eax),%al
  8018f5:	0f be c0             	movsbl %al,%eax
  8018f8:	83 e8 30             	sub    $0x30,%eax
  8018fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018fe:	eb 42                	jmp    801942 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801900:	8b 45 08             	mov    0x8(%ebp),%eax
  801903:	8a 00                	mov    (%eax),%al
  801905:	3c 60                	cmp    $0x60,%al
  801907:	7e 19                	jle    801922 <strtol+0xe4>
  801909:	8b 45 08             	mov    0x8(%ebp),%eax
  80190c:	8a 00                	mov    (%eax),%al
  80190e:	3c 7a                	cmp    $0x7a,%al
  801910:	7f 10                	jg     801922 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801912:	8b 45 08             	mov    0x8(%ebp),%eax
  801915:	8a 00                	mov    (%eax),%al
  801917:	0f be c0             	movsbl %al,%eax
  80191a:	83 e8 57             	sub    $0x57,%eax
  80191d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801920:	eb 20                	jmp    801942 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801922:	8b 45 08             	mov    0x8(%ebp),%eax
  801925:	8a 00                	mov    (%eax),%al
  801927:	3c 40                	cmp    $0x40,%al
  801929:	7e 39                	jle    801964 <strtol+0x126>
  80192b:	8b 45 08             	mov    0x8(%ebp),%eax
  80192e:	8a 00                	mov    (%eax),%al
  801930:	3c 5a                	cmp    $0x5a,%al
  801932:	7f 30                	jg     801964 <strtol+0x126>
			dig = *s - 'A' + 10;
  801934:	8b 45 08             	mov    0x8(%ebp),%eax
  801937:	8a 00                	mov    (%eax),%al
  801939:	0f be c0             	movsbl %al,%eax
  80193c:	83 e8 37             	sub    $0x37,%eax
  80193f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801942:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801945:	3b 45 10             	cmp    0x10(%ebp),%eax
  801948:	7d 19                	jge    801963 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80194a:	ff 45 08             	incl   0x8(%ebp)
  80194d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801950:	0f af 45 10          	imul   0x10(%ebp),%eax
  801954:	89 c2                	mov    %eax,%edx
  801956:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801959:	01 d0                	add    %edx,%eax
  80195b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80195e:	e9 7b ff ff ff       	jmp    8018de <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801963:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801964:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801968:	74 08                	je     801972 <strtol+0x134>
		*endptr = (char *) s;
  80196a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80196d:	8b 55 08             	mov    0x8(%ebp),%edx
  801970:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801972:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801976:	74 07                	je     80197f <strtol+0x141>
  801978:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80197b:	f7 d8                	neg    %eax
  80197d:	eb 03                	jmp    801982 <strtol+0x144>
  80197f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801982:	c9                   	leave  
  801983:	c3                   	ret    

00801984 <ltostr>:

void
ltostr(long value, char *str)
{
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
  801987:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80198a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801991:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801998:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80199c:	79 13                	jns    8019b1 <ltostr+0x2d>
	{
		neg = 1;
  80199e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8019a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a8:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8019ab:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8019ae:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8019b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b4:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8019b9:	99                   	cltd   
  8019ba:	f7 f9                	idiv   %ecx
  8019bc:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8019bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019c2:	8d 50 01             	lea    0x1(%eax),%edx
  8019c5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8019c8:	89 c2                	mov    %eax,%edx
  8019ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019cd:	01 d0                	add    %edx,%eax
  8019cf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8019d2:	83 c2 30             	add    $0x30,%edx
  8019d5:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8019d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019da:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8019df:	f7 e9                	imul   %ecx
  8019e1:	c1 fa 02             	sar    $0x2,%edx
  8019e4:	89 c8                	mov    %ecx,%eax
  8019e6:	c1 f8 1f             	sar    $0x1f,%eax
  8019e9:	29 c2                	sub    %eax,%edx
  8019eb:	89 d0                	mov    %edx,%eax
  8019ed:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8019f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019f3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8019f8:	f7 e9                	imul   %ecx
  8019fa:	c1 fa 02             	sar    $0x2,%edx
  8019fd:	89 c8                	mov    %ecx,%eax
  8019ff:	c1 f8 1f             	sar    $0x1f,%eax
  801a02:	29 c2                	sub    %eax,%edx
  801a04:	89 d0                	mov    %edx,%eax
  801a06:	c1 e0 02             	shl    $0x2,%eax
  801a09:	01 d0                	add    %edx,%eax
  801a0b:	01 c0                	add    %eax,%eax
  801a0d:	29 c1                	sub    %eax,%ecx
  801a0f:	89 ca                	mov    %ecx,%edx
  801a11:	85 d2                	test   %edx,%edx
  801a13:	75 9c                	jne    8019b1 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801a15:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801a1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a1f:	48                   	dec    %eax
  801a20:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801a23:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a27:	74 3d                	je     801a66 <ltostr+0xe2>
		start = 1 ;
  801a29:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801a30:	eb 34                	jmp    801a66 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801a32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a35:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a38:	01 d0                	add    %edx,%eax
  801a3a:	8a 00                	mov    (%eax),%al
  801a3c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801a3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a42:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a45:	01 c2                	add    %eax,%edx
  801a47:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801a4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a4d:	01 c8                	add    %ecx,%eax
  801a4f:	8a 00                	mov    (%eax),%al
  801a51:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801a53:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a56:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a59:	01 c2                	add    %eax,%edx
  801a5b:	8a 45 eb             	mov    -0x15(%ebp),%al
  801a5e:	88 02                	mov    %al,(%edx)
		start++ ;
  801a60:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801a63:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a69:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a6c:	7c c4                	jl     801a32 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801a6e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801a71:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a74:	01 d0                	add    %edx,%eax
  801a76:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801a79:	90                   	nop
  801a7a:	c9                   	leave  
  801a7b:	c3                   	ret    

00801a7c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801a7c:	55                   	push   %ebp
  801a7d:	89 e5                	mov    %esp,%ebp
  801a7f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801a82:	ff 75 08             	pushl  0x8(%ebp)
  801a85:	e8 54 fa ff ff       	call   8014de <strlen>
  801a8a:	83 c4 04             	add    $0x4,%esp
  801a8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801a90:	ff 75 0c             	pushl  0xc(%ebp)
  801a93:	e8 46 fa ff ff       	call   8014de <strlen>
  801a98:	83 c4 04             	add    $0x4,%esp
  801a9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801a9e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801aa5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801aac:	eb 17                	jmp    801ac5 <strcconcat+0x49>
		final[s] = str1[s] ;
  801aae:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ab1:	8b 45 10             	mov    0x10(%ebp),%eax
  801ab4:	01 c2                	add    %eax,%edx
  801ab6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  801abc:	01 c8                	add    %ecx,%eax
  801abe:	8a 00                	mov    (%eax),%al
  801ac0:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801ac2:	ff 45 fc             	incl   -0x4(%ebp)
  801ac5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ac8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801acb:	7c e1                	jl     801aae <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801acd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801ad4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801adb:	eb 1f                	jmp    801afc <strcconcat+0x80>
		final[s++] = str2[i] ;
  801add:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ae0:	8d 50 01             	lea    0x1(%eax),%edx
  801ae3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801ae6:	89 c2                	mov    %eax,%edx
  801ae8:	8b 45 10             	mov    0x10(%ebp),%eax
  801aeb:	01 c2                	add    %eax,%edx
  801aed:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801af0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af3:	01 c8                	add    %ecx,%eax
  801af5:	8a 00                	mov    (%eax),%al
  801af7:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801af9:	ff 45 f8             	incl   -0x8(%ebp)
  801afc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801aff:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b02:	7c d9                	jl     801add <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801b04:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b07:	8b 45 10             	mov    0x10(%ebp),%eax
  801b0a:	01 d0                	add    %edx,%eax
  801b0c:	c6 00 00             	movb   $0x0,(%eax)
}
  801b0f:	90                   	nop
  801b10:	c9                   	leave  
  801b11:	c3                   	ret    

00801b12 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801b12:	55                   	push   %ebp
  801b13:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801b15:	8b 45 14             	mov    0x14(%ebp),%eax
  801b18:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801b1e:	8b 45 14             	mov    0x14(%ebp),%eax
  801b21:	8b 00                	mov    (%eax),%eax
  801b23:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b2a:	8b 45 10             	mov    0x10(%ebp),%eax
  801b2d:	01 d0                	add    %edx,%eax
  801b2f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801b35:	eb 0c                	jmp    801b43 <strsplit+0x31>
			*string++ = 0;
  801b37:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3a:	8d 50 01             	lea    0x1(%eax),%edx
  801b3d:	89 55 08             	mov    %edx,0x8(%ebp)
  801b40:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801b43:	8b 45 08             	mov    0x8(%ebp),%eax
  801b46:	8a 00                	mov    (%eax),%al
  801b48:	84 c0                	test   %al,%al
  801b4a:	74 18                	je     801b64 <strsplit+0x52>
  801b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4f:	8a 00                	mov    (%eax),%al
  801b51:	0f be c0             	movsbl %al,%eax
  801b54:	50                   	push   %eax
  801b55:	ff 75 0c             	pushl  0xc(%ebp)
  801b58:	e8 13 fb ff ff       	call   801670 <strchr>
  801b5d:	83 c4 08             	add    $0x8,%esp
  801b60:	85 c0                	test   %eax,%eax
  801b62:	75 d3                	jne    801b37 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801b64:	8b 45 08             	mov    0x8(%ebp),%eax
  801b67:	8a 00                	mov    (%eax),%al
  801b69:	84 c0                	test   %al,%al
  801b6b:	74 5a                	je     801bc7 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801b6d:	8b 45 14             	mov    0x14(%ebp),%eax
  801b70:	8b 00                	mov    (%eax),%eax
  801b72:	83 f8 0f             	cmp    $0xf,%eax
  801b75:	75 07                	jne    801b7e <strsplit+0x6c>
		{
			return 0;
  801b77:	b8 00 00 00 00       	mov    $0x0,%eax
  801b7c:	eb 66                	jmp    801be4 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801b7e:	8b 45 14             	mov    0x14(%ebp),%eax
  801b81:	8b 00                	mov    (%eax),%eax
  801b83:	8d 48 01             	lea    0x1(%eax),%ecx
  801b86:	8b 55 14             	mov    0x14(%ebp),%edx
  801b89:	89 0a                	mov    %ecx,(%edx)
  801b8b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b92:	8b 45 10             	mov    0x10(%ebp),%eax
  801b95:	01 c2                	add    %eax,%edx
  801b97:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801b9c:	eb 03                	jmp    801ba1 <strsplit+0x8f>
			string++;
  801b9e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba4:	8a 00                	mov    (%eax),%al
  801ba6:	84 c0                	test   %al,%al
  801ba8:	74 8b                	je     801b35 <strsplit+0x23>
  801baa:	8b 45 08             	mov    0x8(%ebp),%eax
  801bad:	8a 00                	mov    (%eax),%al
  801baf:	0f be c0             	movsbl %al,%eax
  801bb2:	50                   	push   %eax
  801bb3:	ff 75 0c             	pushl  0xc(%ebp)
  801bb6:	e8 b5 fa ff ff       	call   801670 <strchr>
  801bbb:	83 c4 08             	add    $0x8,%esp
  801bbe:	85 c0                	test   %eax,%eax
  801bc0:	74 dc                	je     801b9e <strsplit+0x8c>
			string++;
	}
  801bc2:	e9 6e ff ff ff       	jmp    801b35 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801bc7:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801bc8:	8b 45 14             	mov    0x14(%ebp),%eax
  801bcb:	8b 00                	mov    (%eax),%eax
  801bcd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801bd4:	8b 45 10             	mov    0x10(%ebp),%eax
  801bd7:	01 d0                	add    %edx,%eax
  801bd9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801bdf:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801be4:	c9                   	leave  
  801be5:	c3                   	ret    

00801be6 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801be6:	55                   	push   %ebp
  801be7:	89 e5                	mov    %esp,%ebp
  801be9:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801bec:	a1 04 50 80 00       	mov    0x805004,%eax
  801bf1:	85 c0                	test   %eax,%eax
  801bf3:	74 1f                	je     801c14 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801bf5:	e8 1d 00 00 00       	call   801c17 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801bfa:	83 ec 0c             	sub    $0xc,%esp
  801bfd:	68 a4 43 80 00       	push   $0x8043a4
  801c02:	e8 4f f0 ff ff       	call   800c56 <cprintf>
  801c07:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801c0a:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801c11:	00 00 00 
	}
}
  801c14:	90                   	nop
  801c15:	c9                   	leave  
  801c16:	c3                   	ret    

00801c17 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
  801c1a:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801c1d:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801c24:	00 00 00 
  801c27:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801c2e:	00 00 00 
  801c31:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801c38:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  801c3b:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801c42:	00 00 00 
  801c45:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801c4c:	00 00 00 
  801c4f:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801c56:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801c59:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801c60:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801c63:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801c6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c6d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c72:	2d 00 10 00 00       	sub    $0x1000,%eax
  801c77:	a3 50 50 80 00       	mov    %eax,0x805050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  801c7c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801c83:	a1 20 51 80 00       	mov    0x805120,%eax
  801c88:	c1 e0 04             	shl    $0x4,%eax
  801c8b:	89 c2                	mov    %eax,%edx
  801c8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c90:	01 d0                	add    %edx,%eax
  801c92:	48                   	dec    %eax
  801c93:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801c96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c99:	ba 00 00 00 00       	mov    $0x0,%edx
  801c9e:	f7 75 f0             	divl   -0x10(%ebp)
  801ca1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ca4:	29 d0                	sub    %edx,%eax
  801ca6:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  801ca9:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801cb0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801cb3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801cb8:	2d 00 10 00 00       	sub    $0x1000,%eax
  801cbd:	83 ec 04             	sub    $0x4,%esp
  801cc0:	6a 06                	push   $0x6
  801cc2:	ff 75 e8             	pushl  -0x18(%ebp)
  801cc5:	50                   	push   %eax
  801cc6:	e8 b0 05 00 00       	call   80227b <sys_allocate_chunk>
  801ccb:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801cce:	a1 20 51 80 00       	mov    0x805120,%eax
  801cd3:	83 ec 0c             	sub    $0xc,%esp
  801cd6:	50                   	push   %eax
  801cd7:	e8 25 0c 00 00       	call   802901 <initialize_MemBlocksList>
  801cdc:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  801cdf:	a1 48 51 80 00       	mov    0x805148,%eax
  801ce4:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  801ce7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ceb:	75 14                	jne    801d01 <initialize_dyn_block_system+0xea>
  801ced:	83 ec 04             	sub    $0x4,%esp
  801cf0:	68 c9 43 80 00       	push   $0x8043c9
  801cf5:	6a 29                	push   $0x29
  801cf7:	68 e7 43 80 00       	push   $0x8043e7
  801cfc:	e8 a1 ec ff ff       	call   8009a2 <_panic>
  801d01:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d04:	8b 00                	mov    (%eax),%eax
  801d06:	85 c0                	test   %eax,%eax
  801d08:	74 10                	je     801d1a <initialize_dyn_block_system+0x103>
  801d0a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d0d:	8b 00                	mov    (%eax),%eax
  801d0f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d12:	8b 52 04             	mov    0x4(%edx),%edx
  801d15:	89 50 04             	mov    %edx,0x4(%eax)
  801d18:	eb 0b                	jmp    801d25 <initialize_dyn_block_system+0x10e>
  801d1a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d1d:	8b 40 04             	mov    0x4(%eax),%eax
  801d20:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801d25:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d28:	8b 40 04             	mov    0x4(%eax),%eax
  801d2b:	85 c0                	test   %eax,%eax
  801d2d:	74 0f                	je     801d3e <initialize_dyn_block_system+0x127>
  801d2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d32:	8b 40 04             	mov    0x4(%eax),%eax
  801d35:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d38:	8b 12                	mov    (%edx),%edx
  801d3a:	89 10                	mov    %edx,(%eax)
  801d3c:	eb 0a                	jmp    801d48 <initialize_dyn_block_system+0x131>
  801d3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d41:	8b 00                	mov    (%eax),%eax
  801d43:	a3 48 51 80 00       	mov    %eax,0x805148
  801d48:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d4b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801d51:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d54:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801d5b:	a1 54 51 80 00       	mov    0x805154,%eax
  801d60:	48                   	dec    %eax
  801d61:	a3 54 51 80 00       	mov    %eax,0x805154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  801d66:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d69:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  801d70:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d73:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  801d7a:	83 ec 0c             	sub    $0xc,%esp
  801d7d:	ff 75 e0             	pushl  -0x20(%ebp)
  801d80:	e8 b9 14 00 00       	call   80323e <insert_sorted_with_merge_freeList>
  801d85:	83 c4 10             	add    $0x10,%esp

}
  801d88:	90                   	nop
  801d89:	c9                   	leave  
  801d8a:	c3                   	ret    

00801d8b <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801d8b:	55                   	push   %ebp
  801d8c:	89 e5                	mov    %esp,%ebp
  801d8e:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d91:	e8 50 fe ff ff       	call   801be6 <InitializeUHeap>
	if (size == 0) return NULL ;
  801d96:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d9a:	75 07                	jne    801da3 <malloc+0x18>
  801d9c:	b8 00 00 00 00       	mov    $0x0,%eax
  801da1:	eb 68                	jmp    801e0b <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  801da3:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801daa:	8b 55 08             	mov    0x8(%ebp),%edx
  801dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db0:	01 d0                	add    %edx,%eax
  801db2:	48                   	dec    %eax
  801db3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801db6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801db9:	ba 00 00 00 00       	mov    $0x0,%edx
  801dbe:	f7 75 f4             	divl   -0xc(%ebp)
  801dc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dc4:	29 d0                	sub    %edx,%eax
  801dc6:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  801dc9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801dd0:	e8 74 08 00 00       	call   802649 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801dd5:	85 c0                	test   %eax,%eax
  801dd7:	74 2d                	je     801e06 <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  801dd9:	83 ec 0c             	sub    $0xc,%esp
  801ddc:	ff 75 ec             	pushl  -0x14(%ebp)
  801ddf:	e8 52 0e 00 00       	call   802c36 <alloc_block_FF>
  801de4:	83 c4 10             	add    $0x10,%esp
  801de7:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  801dea:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801dee:	74 16                	je     801e06 <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  801df0:	83 ec 0c             	sub    $0xc,%esp
  801df3:	ff 75 e8             	pushl  -0x18(%ebp)
  801df6:	e8 3b 0c 00 00       	call   802a36 <insert_sorted_allocList>
  801dfb:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  801dfe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e01:	8b 40 08             	mov    0x8(%eax),%eax
  801e04:	eb 05                	jmp    801e0b <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  801e06:	b8 00 00 00 00       	mov    $0x0,%eax

}
  801e0b:	c9                   	leave  
  801e0c:	c3                   	ret    

00801e0d <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801e0d:	55                   	push   %ebp
  801e0e:	89 e5                	mov    %esp,%ebp
  801e10:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  801e13:	8b 45 08             	mov    0x8(%ebp),%eax
  801e16:	83 ec 08             	sub    $0x8,%esp
  801e19:	50                   	push   %eax
  801e1a:	68 40 50 80 00       	push   $0x805040
  801e1f:	e8 ba 0b 00 00       	call   8029de <find_block>
  801e24:	83 c4 10             	add    $0x10,%esp
  801e27:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  801e2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e2d:	8b 40 0c             	mov    0xc(%eax),%eax
  801e30:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  801e33:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e37:	0f 84 9f 00 00 00    	je     801edc <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  801e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e40:	83 ec 08             	sub    $0x8,%esp
  801e43:	ff 75 f0             	pushl  -0x10(%ebp)
  801e46:	50                   	push   %eax
  801e47:	e8 f7 03 00 00       	call   802243 <sys_free_user_mem>
  801e4c:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  801e4f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e53:	75 14                	jne    801e69 <free+0x5c>
  801e55:	83 ec 04             	sub    $0x4,%esp
  801e58:	68 c9 43 80 00       	push   $0x8043c9
  801e5d:	6a 6a                	push   $0x6a
  801e5f:	68 e7 43 80 00       	push   $0x8043e7
  801e64:	e8 39 eb ff ff       	call   8009a2 <_panic>
  801e69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e6c:	8b 00                	mov    (%eax),%eax
  801e6e:	85 c0                	test   %eax,%eax
  801e70:	74 10                	je     801e82 <free+0x75>
  801e72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e75:	8b 00                	mov    (%eax),%eax
  801e77:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e7a:	8b 52 04             	mov    0x4(%edx),%edx
  801e7d:	89 50 04             	mov    %edx,0x4(%eax)
  801e80:	eb 0b                	jmp    801e8d <free+0x80>
  801e82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e85:	8b 40 04             	mov    0x4(%eax),%eax
  801e88:	a3 44 50 80 00       	mov    %eax,0x805044
  801e8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e90:	8b 40 04             	mov    0x4(%eax),%eax
  801e93:	85 c0                	test   %eax,%eax
  801e95:	74 0f                	je     801ea6 <free+0x99>
  801e97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e9a:	8b 40 04             	mov    0x4(%eax),%eax
  801e9d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ea0:	8b 12                	mov    (%edx),%edx
  801ea2:	89 10                	mov    %edx,(%eax)
  801ea4:	eb 0a                	jmp    801eb0 <free+0xa3>
  801ea6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea9:	8b 00                	mov    (%eax),%eax
  801eab:	a3 40 50 80 00       	mov    %eax,0x805040
  801eb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801eb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ec3:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801ec8:	48                   	dec    %eax
  801ec9:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(blk);
  801ece:	83 ec 0c             	sub    $0xc,%esp
  801ed1:	ff 75 f4             	pushl  -0xc(%ebp)
  801ed4:	e8 65 13 00 00       	call   80323e <insert_sorted_with_merge_freeList>
  801ed9:	83 c4 10             	add    $0x10,%esp
	}
}
  801edc:	90                   	nop
  801edd:	c9                   	leave  
  801ede:	c3                   	ret    

00801edf <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801edf:	55                   	push   %ebp
  801ee0:	89 e5                	mov    %esp,%ebp
  801ee2:	83 ec 28             	sub    $0x28,%esp
  801ee5:	8b 45 10             	mov    0x10(%ebp),%eax
  801ee8:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801eeb:	e8 f6 fc ff ff       	call   801be6 <InitializeUHeap>
	if (size == 0) return NULL ;
  801ef0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ef4:	75 0a                	jne    801f00 <smalloc+0x21>
  801ef6:	b8 00 00 00 00       	mov    $0x0,%eax
  801efb:	e9 af 00 00 00       	jmp    801faf <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  801f00:	e8 44 07 00 00       	call   802649 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801f05:	83 f8 01             	cmp    $0x1,%eax
  801f08:	0f 85 9c 00 00 00    	jne    801faa <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  801f0e:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801f15:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1b:	01 d0                	add    %edx,%eax
  801f1d:	48                   	dec    %eax
  801f1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f24:	ba 00 00 00 00       	mov    $0x0,%edx
  801f29:	f7 75 f4             	divl   -0xc(%ebp)
  801f2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f2f:	29 d0                	sub    %edx,%eax
  801f31:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  801f34:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  801f3b:	76 07                	jbe    801f44 <smalloc+0x65>
			return NULL;
  801f3d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f42:	eb 6b                	jmp    801faf <smalloc+0xd0>
		blk =alloc_block_FF(size);
  801f44:	83 ec 0c             	sub    $0xc,%esp
  801f47:	ff 75 0c             	pushl  0xc(%ebp)
  801f4a:	e8 e7 0c 00 00       	call   802c36 <alloc_block_FF>
  801f4f:	83 c4 10             	add    $0x10,%esp
  801f52:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  801f55:	83 ec 0c             	sub    $0xc,%esp
  801f58:	ff 75 ec             	pushl  -0x14(%ebp)
  801f5b:	e8 d6 0a 00 00       	call   802a36 <insert_sorted_allocList>
  801f60:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  801f63:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f67:	75 07                	jne    801f70 <smalloc+0x91>
		{
			return NULL;
  801f69:	b8 00 00 00 00       	mov    $0x0,%eax
  801f6e:	eb 3f                	jmp    801faf <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  801f70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f73:	8b 40 08             	mov    0x8(%eax),%eax
  801f76:	89 c2                	mov    %eax,%edx
  801f78:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801f7c:	52                   	push   %edx
  801f7d:	50                   	push   %eax
  801f7e:	ff 75 0c             	pushl  0xc(%ebp)
  801f81:	ff 75 08             	pushl  0x8(%ebp)
  801f84:	e8 45 04 00 00       	call   8023ce <sys_createSharedObject>
  801f89:	83 c4 10             	add    $0x10,%esp
  801f8c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  801f8f:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801f93:	74 06                	je     801f9b <smalloc+0xbc>
  801f95:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801f99:	75 07                	jne    801fa2 <smalloc+0xc3>
		{
			return NULL;
  801f9b:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa0:	eb 0d                	jmp    801faf <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  801fa2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fa5:	8b 40 08             	mov    0x8(%eax),%eax
  801fa8:	eb 05                	jmp    801faf <smalloc+0xd0>
		}
	}
	else
		return NULL;
  801faa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801faf:	c9                   	leave  
  801fb0:	c3                   	ret    

00801fb1 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801fb1:	55                   	push   %ebp
  801fb2:	89 e5                	mov    %esp,%ebp
  801fb4:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801fb7:	e8 2a fc ff ff       	call   801be6 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801fbc:	83 ec 08             	sub    $0x8,%esp
  801fbf:	ff 75 0c             	pushl  0xc(%ebp)
  801fc2:	ff 75 08             	pushl  0x8(%ebp)
  801fc5:	e8 2e 04 00 00       	call   8023f8 <sys_getSizeOfSharedObject>
  801fca:	83 c4 10             	add    $0x10,%esp
  801fcd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  801fd0:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801fd4:	75 0a                	jne    801fe0 <sget+0x2f>
	{
		return NULL;
  801fd6:	b8 00 00 00 00       	mov    $0x0,%eax
  801fdb:	e9 94 00 00 00       	jmp    802074 <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801fe0:	e8 64 06 00 00       	call   802649 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801fe5:	85 c0                	test   %eax,%eax
  801fe7:	0f 84 82 00 00 00    	je     80206f <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  801fed:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  801ff4:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801ffb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ffe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802001:	01 d0                	add    %edx,%eax
  802003:	48                   	dec    %eax
  802004:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802007:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80200a:	ba 00 00 00 00       	mov    $0x0,%edx
  80200f:	f7 75 ec             	divl   -0x14(%ebp)
  802012:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802015:	29 d0                	sub    %edx,%eax
  802017:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  80201a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201d:	83 ec 0c             	sub    $0xc,%esp
  802020:	50                   	push   %eax
  802021:	e8 10 0c 00 00       	call   802c36 <alloc_block_FF>
  802026:	83 c4 10             	add    $0x10,%esp
  802029:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  80202c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802030:	75 07                	jne    802039 <sget+0x88>
		{
			return NULL;
  802032:	b8 00 00 00 00       	mov    $0x0,%eax
  802037:	eb 3b                	jmp    802074 <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  802039:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80203c:	8b 40 08             	mov    0x8(%eax),%eax
  80203f:	83 ec 04             	sub    $0x4,%esp
  802042:	50                   	push   %eax
  802043:	ff 75 0c             	pushl  0xc(%ebp)
  802046:	ff 75 08             	pushl  0x8(%ebp)
  802049:	e8 c7 03 00 00       	call   802415 <sys_getSharedObject>
  80204e:	83 c4 10             	add    $0x10,%esp
  802051:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  802054:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  802058:	74 06                	je     802060 <sget+0xaf>
  80205a:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  80205e:	75 07                	jne    802067 <sget+0xb6>
		{
			return NULL;
  802060:	b8 00 00 00 00       	mov    $0x0,%eax
  802065:	eb 0d                	jmp    802074 <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  802067:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80206a:	8b 40 08             	mov    0x8(%eax),%eax
  80206d:	eb 05                	jmp    802074 <sget+0xc3>
		}
	}
	else
			return NULL;
  80206f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802074:	c9                   	leave  
  802075:	c3                   	ret    

00802076 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802076:	55                   	push   %ebp
  802077:	89 e5                	mov    %esp,%ebp
  802079:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80207c:	e8 65 fb ff ff       	call   801be6 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802081:	83 ec 04             	sub    $0x4,%esp
  802084:	68 f4 43 80 00       	push   $0x8043f4
  802089:	68 e1 00 00 00       	push   $0xe1
  80208e:	68 e7 43 80 00       	push   $0x8043e7
  802093:	e8 0a e9 ff ff       	call   8009a2 <_panic>

00802098 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802098:	55                   	push   %ebp
  802099:	89 e5                	mov    %esp,%ebp
  80209b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80209e:	83 ec 04             	sub    $0x4,%esp
  8020a1:	68 1c 44 80 00       	push   $0x80441c
  8020a6:	68 f5 00 00 00       	push   $0xf5
  8020ab:	68 e7 43 80 00       	push   $0x8043e7
  8020b0:	e8 ed e8 ff ff       	call   8009a2 <_panic>

008020b5 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8020b5:	55                   	push   %ebp
  8020b6:	89 e5                	mov    %esp,%ebp
  8020b8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020bb:	83 ec 04             	sub    $0x4,%esp
  8020be:	68 40 44 80 00       	push   $0x804440
  8020c3:	68 00 01 00 00       	push   $0x100
  8020c8:	68 e7 43 80 00       	push   $0x8043e7
  8020cd:	e8 d0 e8 ff ff       	call   8009a2 <_panic>

008020d2 <shrink>:

}
void shrink(uint32 newSize)
{
  8020d2:	55                   	push   %ebp
  8020d3:	89 e5                	mov    %esp,%ebp
  8020d5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020d8:	83 ec 04             	sub    $0x4,%esp
  8020db:	68 40 44 80 00       	push   $0x804440
  8020e0:	68 05 01 00 00       	push   $0x105
  8020e5:	68 e7 43 80 00       	push   $0x8043e7
  8020ea:	e8 b3 e8 ff ff       	call   8009a2 <_panic>

008020ef <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8020ef:	55                   	push   %ebp
  8020f0:	89 e5                	mov    %esp,%ebp
  8020f2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020f5:	83 ec 04             	sub    $0x4,%esp
  8020f8:	68 40 44 80 00       	push   $0x804440
  8020fd:	68 0a 01 00 00       	push   $0x10a
  802102:	68 e7 43 80 00       	push   $0x8043e7
  802107:	e8 96 e8 ff ff       	call   8009a2 <_panic>

0080210c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80210c:	55                   	push   %ebp
  80210d:	89 e5                	mov    %esp,%ebp
  80210f:	57                   	push   %edi
  802110:	56                   	push   %esi
  802111:	53                   	push   %ebx
  802112:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802115:	8b 45 08             	mov    0x8(%ebp),%eax
  802118:	8b 55 0c             	mov    0xc(%ebp),%edx
  80211b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80211e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802121:	8b 7d 18             	mov    0x18(%ebp),%edi
  802124:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802127:	cd 30                	int    $0x30
  802129:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80212c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80212f:	83 c4 10             	add    $0x10,%esp
  802132:	5b                   	pop    %ebx
  802133:	5e                   	pop    %esi
  802134:	5f                   	pop    %edi
  802135:	5d                   	pop    %ebp
  802136:	c3                   	ret    

00802137 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802137:	55                   	push   %ebp
  802138:	89 e5                	mov    %esp,%ebp
  80213a:	83 ec 04             	sub    $0x4,%esp
  80213d:	8b 45 10             	mov    0x10(%ebp),%eax
  802140:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802143:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802147:	8b 45 08             	mov    0x8(%ebp),%eax
  80214a:	6a 00                	push   $0x0
  80214c:	6a 00                	push   $0x0
  80214e:	52                   	push   %edx
  80214f:	ff 75 0c             	pushl  0xc(%ebp)
  802152:	50                   	push   %eax
  802153:	6a 00                	push   $0x0
  802155:	e8 b2 ff ff ff       	call   80210c <syscall>
  80215a:	83 c4 18             	add    $0x18,%esp
}
  80215d:	90                   	nop
  80215e:	c9                   	leave  
  80215f:	c3                   	ret    

00802160 <sys_cgetc>:

int
sys_cgetc(void)
{
  802160:	55                   	push   %ebp
  802161:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802163:	6a 00                	push   $0x0
  802165:	6a 00                	push   $0x0
  802167:	6a 00                	push   $0x0
  802169:	6a 00                	push   $0x0
  80216b:	6a 00                	push   $0x0
  80216d:	6a 01                	push   $0x1
  80216f:	e8 98 ff ff ff       	call   80210c <syscall>
  802174:	83 c4 18             	add    $0x18,%esp
}
  802177:	c9                   	leave  
  802178:	c3                   	ret    

00802179 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802179:	55                   	push   %ebp
  80217a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80217c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80217f:	8b 45 08             	mov    0x8(%ebp),%eax
  802182:	6a 00                	push   $0x0
  802184:	6a 00                	push   $0x0
  802186:	6a 00                	push   $0x0
  802188:	52                   	push   %edx
  802189:	50                   	push   %eax
  80218a:	6a 05                	push   $0x5
  80218c:	e8 7b ff ff ff       	call   80210c <syscall>
  802191:	83 c4 18             	add    $0x18,%esp
}
  802194:	c9                   	leave  
  802195:	c3                   	ret    

00802196 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802196:	55                   	push   %ebp
  802197:	89 e5                	mov    %esp,%ebp
  802199:	56                   	push   %esi
  80219a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80219b:	8b 75 18             	mov    0x18(%ebp),%esi
  80219e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021a1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021aa:	56                   	push   %esi
  8021ab:	53                   	push   %ebx
  8021ac:	51                   	push   %ecx
  8021ad:	52                   	push   %edx
  8021ae:	50                   	push   %eax
  8021af:	6a 06                	push   $0x6
  8021b1:	e8 56 ff ff ff       	call   80210c <syscall>
  8021b6:	83 c4 18             	add    $0x18,%esp
}
  8021b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021bc:	5b                   	pop    %ebx
  8021bd:	5e                   	pop    %esi
  8021be:	5d                   	pop    %ebp
  8021bf:	c3                   	ret    

008021c0 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8021c0:	55                   	push   %ebp
  8021c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8021c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c9:	6a 00                	push   $0x0
  8021cb:	6a 00                	push   $0x0
  8021cd:	6a 00                	push   $0x0
  8021cf:	52                   	push   %edx
  8021d0:	50                   	push   %eax
  8021d1:	6a 07                	push   $0x7
  8021d3:	e8 34 ff ff ff       	call   80210c <syscall>
  8021d8:	83 c4 18             	add    $0x18,%esp
}
  8021db:	c9                   	leave  
  8021dc:	c3                   	ret    

008021dd <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8021dd:	55                   	push   %ebp
  8021de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8021e0:	6a 00                	push   $0x0
  8021e2:	6a 00                	push   $0x0
  8021e4:	6a 00                	push   $0x0
  8021e6:	ff 75 0c             	pushl  0xc(%ebp)
  8021e9:	ff 75 08             	pushl  0x8(%ebp)
  8021ec:	6a 08                	push   $0x8
  8021ee:	e8 19 ff ff ff       	call   80210c <syscall>
  8021f3:	83 c4 18             	add    $0x18,%esp
}
  8021f6:	c9                   	leave  
  8021f7:	c3                   	ret    

008021f8 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8021f8:	55                   	push   %ebp
  8021f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 00                	push   $0x0
  802201:	6a 00                	push   $0x0
  802203:	6a 00                	push   $0x0
  802205:	6a 09                	push   $0x9
  802207:	e8 00 ff ff ff       	call   80210c <syscall>
  80220c:	83 c4 18             	add    $0x18,%esp
}
  80220f:	c9                   	leave  
  802210:	c3                   	ret    

00802211 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802211:	55                   	push   %ebp
  802212:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802214:	6a 00                	push   $0x0
  802216:	6a 00                	push   $0x0
  802218:	6a 00                	push   $0x0
  80221a:	6a 00                	push   $0x0
  80221c:	6a 00                	push   $0x0
  80221e:	6a 0a                	push   $0xa
  802220:	e8 e7 fe ff ff       	call   80210c <syscall>
  802225:	83 c4 18             	add    $0x18,%esp
}
  802228:	c9                   	leave  
  802229:	c3                   	ret    

0080222a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80222a:	55                   	push   %ebp
  80222b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80222d:	6a 00                	push   $0x0
  80222f:	6a 00                	push   $0x0
  802231:	6a 00                	push   $0x0
  802233:	6a 00                	push   $0x0
  802235:	6a 00                	push   $0x0
  802237:	6a 0b                	push   $0xb
  802239:	e8 ce fe ff ff       	call   80210c <syscall>
  80223e:	83 c4 18             	add    $0x18,%esp
}
  802241:	c9                   	leave  
  802242:	c3                   	ret    

00802243 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802243:	55                   	push   %ebp
  802244:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802246:	6a 00                	push   $0x0
  802248:	6a 00                	push   $0x0
  80224a:	6a 00                	push   $0x0
  80224c:	ff 75 0c             	pushl  0xc(%ebp)
  80224f:	ff 75 08             	pushl  0x8(%ebp)
  802252:	6a 0f                	push   $0xf
  802254:	e8 b3 fe ff ff       	call   80210c <syscall>
  802259:	83 c4 18             	add    $0x18,%esp
	return;
  80225c:	90                   	nop
}
  80225d:	c9                   	leave  
  80225e:	c3                   	ret    

0080225f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80225f:	55                   	push   %ebp
  802260:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802262:	6a 00                	push   $0x0
  802264:	6a 00                	push   $0x0
  802266:	6a 00                	push   $0x0
  802268:	ff 75 0c             	pushl  0xc(%ebp)
  80226b:	ff 75 08             	pushl  0x8(%ebp)
  80226e:	6a 10                	push   $0x10
  802270:	e8 97 fe ff ff       	call   80210c <syscall>
  802275:	83 c4 18             	add    $0x18,%esp
	return ;
  802278:	90                   	nop
}
  802279:	c9                   	leave  
  80227a:	c3                   	ret    

0080227b <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80227b:	55                   	push   %ebp
  80227c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80227e:	6a 00                	push   $0x0
  802280:	6a 00                	push   $0x0
  802282:	ff 75 10             	pushl  0x10(%ebp)
  802285:	ff 75 0c             	pushl  0xc(%ebp)
  802288:	ff 75 08             	pushl  0x8(%ebp)
  80228b:	6a 11                	push   $0x11
  80228d:	e8 7a fe ff ff       	call   80210c <syscall>
  802292:	83 c4 18             	add    $0x18,%esp
	return ;
  802295:	90                   	nop
}
  802296:	c9                   	leave  
  802297:	c3                   	ret    

00802298 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802298:	55                   	push   %ebp
  802299:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80229b:	6a 00                	push   $0x0
  80229d:	6a 00                	push   $0x0
  80229f:	6a 00                	push   $0x0
  8022a1:	6a 00                	push   $0x0
  8022a3:	6a 00                	push   $0x0
  8022a5:	6a 0c                	push   $0xc
  8022a7:	e8 60 fe ff ff       	call   80210c <syscall>
  8022ac:	83 c4 18             	add    $0x18,%esp
}
  8022af:	c9                   	leave  
  8022b0:	c3                   	ret    

008022b1 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8022b1:	55                   	push   %ebp
  8022b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8022b4:	6a 00                	push   $0x0
  8022b6:	6a 00                	push   $0x0
  8022b8:	6a 00                	push   $0x0
  8022ba:	6a 00                	push   $0x0
  8022bc:	ff 75 08             	pushl  0x8(%ebp)
  8022bf:	6a 0d                	push   $0xd
  8022c1:	e8 46 fe ff ff       	call   80210c <syscall>
  8022c6:	83 c4 18             	add    $0x18,%esp
}
  8022c9:	c9                   	leave  
  8022ca:	c3                   	ret    

008022cb <sys_scarce_memory>:

void sys_scarce_memory()
{
  8022cb:	55                   	push   %ebp
  8022cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8022ce:	6a 00                	push   $0x0
  8022d0:	6a 00                	push   $0x0
  8022d2:	6a 00                	push   $0x0
  8022d4:	6a 00                	push   $0x0
  8022d6:	6a 00                	push   $0x0
  8022d8:	6a 0e                	push   $0xe
  8022da:	e8 2d fe ff ff       	call   80210c <syscall>
  8022df:	83 c4 18             	add    $0x18,%esp
}
  8022e2:	90                   	nop
  8022e3:	c9                   	leave  
  8022e4:	c3                   	ret    

008022e5 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8022e5:	55                   	push   %ebp
  8022e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8022e8:	6a 00                	push   $0x0
  8022ea:	6a 00                	push   $0x0
  8022ec:	6a 00                	push   $0x0
  8022ee:	6a 00                	push   $0x0
  8022f0:	6a 00                	push   $0x0
  8022f2:	6a 13                	push   $0x13
  8022f4:	e8 13 fe ff ff       	call   80210c <syscall>
  8022f9:	83 c4 18             	add    $0x18,%esp
}
  8022fc:	90                   	nop
  8022fd:	c9                   	leave  
  8022fe:	c3                   	ret    

008022ff <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8022ff:	55                   	push   %ebp
  802300:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802302:	6a 00                	push   $0x0
  802304:	6a 00                	push   $0x0
  802306:	6a 00                	push   $0x0
  802308:	6a 00                	push   $0x0
  80230a:	6a 00                	push   $0x0
  80230c:	6a 14                	push   $0x14
  80230e:	e8 f9 fd ff ff       	call   80210c <syscall>
  802313:	83 c4 18             	add    $0x18,%esp
}
  802316:	90                   	nop
  802317:	c9                   	leave  
  802318:	c3                   	ret    

00802319 <sys_cputc>:


void
sys_cputc(const char c)
{
  802319:	55                   	push   %ebp
  80231a:	89 e5                	mov    %esp,%ebp
  80231c:	83 ec 04             	sub    $0x4,%esp
  80231f:	8b 45 08             	mov    0x8(%ebp),%eax
  802322:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802325:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802329:	6a 00                	push   $0x0
  80232b:	6a 00                	push   $0x0
  80232d:	6a 00                	push   $0x0
  80232f:	6a 00                	push   $0x0
  802331:	50                   	push   %eax
  802332:	6a 15                	push   $0x15
  802334:	e8 d3 fd ff ff       	call   80210c <syscall>
  802339:	83 c4 18             	add    $0x18,%esp
}
  80233c:	90                   	nop
  80233d:	c9                   	leave  
  80233e:	c3                   	ret    

0080233f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80233f:	55                   	push   %ebp
  802340:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802342:	6a 00                	push   $0x0
  802344:	6a 00                	push   $0x0
  802346:	6a 00                	push   $0x0
  802348:	6a 00                	push   $0x0
  80234a:	6a 00                	push   $0x0
  80234c:	6a 16                	push   $0x16
  80234e:	e8 b9 fd ff ff       	call   80210c <syscall>
  802353:	83 c4 18             	add    $0x18,%esp
}
  802356:	90                   	nop
  802357:	c9                   	leave  
  802358:	c3                   	ret    

00802359 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802359:	55                   	push   %ebp
  80235a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80235c:	8b 45 08             	mov    0x8(%ebp),%eax
  80235f:	6a 00                	push   $0x0
  802361:	6a 00                	push   $0x0
  802363:	6a 00                	push   $0x0
  802365:	ff 75 0c             	pushl  0xc(%ebp)
  802368:	50                   	push   %eax
  802369:	6a 17                	push   $0x17
  80236b:	e8 9c fd ff ff       	call   80210c <syscall>
  802370:	83 c4 18             	add    $0x18,%esp
}
  802373:	c9                   	leave  
  802374:	c3                   	ret    

00802375 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802375:	55                   	push   %ebp
  802376:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802378:	8b 55 0c             	mov    0xc(%ebp),%edx
  80237b:	8b 45 08             	mov    0x8(%ebp),%eax
  80237e:	6a 00                	push   $0x0
  802380:	6a 00                	push   $0x0
  802382:	6a 00                	push   $0x0
  802384:	52                   	push   %edx
  802385:	50                   	push   %eax
  802386:	6a 1a                	push   $0x1a
  802388:	e8 7f fd ff ff       	call   80210c <syscall>
  80238d:	83 c4 18             	add    $0x18,%esp
}
  802390:	c9                   	leave  
  802391:	c3                   	ret    

00802392 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802392:	55                   	push   %ebp
  802393:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802395:	8b 55 0c             	mov    0xc(%ebp),%edx
  802398:	8b 45 08             	mov    0x8(%ebp),%eax
  80239b:	6a 00                	push   $0x0
  80239d:	6a 00                	push   $0x0
  80239f:	6a 00                	push   $0x0
  8023a1:	52                   	push   %edx
  8023a2:	50                   	push   %eax
  8023a3:	6a 18                	push   $0x18
  8023a5:	e8 62 fd ff ff       	call   80210c <syscall>
  8023aa:	83 c4 18             	add    $0x18,%esp
}
  8023ad:	90                   	nop
  8023ae:	c9                   	leave  
  8023af:	c3                   	ret    

008023b0 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8023b0:	55                   	push   %ebp
  8023b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8023b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b9:	6a 00                	push   $0x0
  8023bb:	6a 00                	push   $0x0
  8023bd:	6a 00                	push   $0x0
  8023bf:	52                   	push   %edx
  8023c0:	50                   	push   %eax
  8023c1:	6a 19                	push   $0x19
  8023c3:	e8 44 fd ff ff       	call   80210c <syscall>
  8023c8:	83 c4 18             	add    $0x18,%esp
}
  8023cb:	90                   	nop
  8023cc:	c9                   	leave  
  8023cd:	c3                   	ret    

008023ce <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8023ce:	55                   	push   %ebp
  8023cf:	89 e5                	mov    %esp,%ebp
  8023d1:	83 ec 04             	sub    $0x4,%esp
  8023d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8023d7:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8023da:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8023dd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8023e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e4:	6a 00                	push   $0x0
  8023e6:	51                   	push   %ecx
  8023e7:	52                   	push   %edx
  8023e8:	ff 75 0c             	pushl  0xc(%ebp)
  8023eb:	50                   	push   %eax
  8023ec:	6a 1b                	push   $0x1b
  8023ee:	e8 19 fd ff ff       	call   80210c <syscall>
  8023f3:	83 c4 18             	add    $0x18,%esp
}
  8023f6:	c9                   	leave  
  8023f7:	c3                   	ret    

008023f8 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8023f8:	55                   	push   %ebp
  8023f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8023fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802401:	6a 00                	push   $0x0
  802403:	6a 00                	push   $0x0
  802405:	6a 00                	push   $0x0
  802407:	52                   	push   %edx
  802408:	50                   	push   %eax
  802409:	6a 1c                	push   $0x1c
  80240b:	e8 fc fc ff ff       	call   80210c <syscall>
  802410:	83 c4 18             	add    $0x18,%esp
}
  802413:	c9                   	leave  
  802414:	c3                   	ret    

00802415 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802415:	55                   	push   %ebp
  802416:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802418:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80241b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80241e:	8b 45 08             	mov    0x8(%ebp),%eax
  802421:	6a 00                	push   $0x0
  802423:	6a 00                	push   $0x0
  802425:	51                   	push   %ecx
  802426:	52                   	push   %edx
  802427:	50                   	push   %eax
  802428:	6a 1d                	push   $0x1d
  80242a:	e8 dd fc ff ff       	call   80210c <syscall>
  80242f:	83 c4 18             	add    $0x18,%esp
}
  802432:	c9                   	leave  
  802433:	c3                   	ret    

00802434 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802434:	55                   	push   %ebp
  802435:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802437:	8b 55 0c             	mov    0xc(%ebp),%edx
  80243a:	8b 45 08             	mov    0x8(%ebp),%eax
  80243d:	6a 00                	push   $0x0
  80243f:	6a 00                	push   $0x0
  802441:	6a 00                	push   $0x0
  802443:	52                   	push   %edx
  802444:	50                   	push   %eax
  802445:	6a 1e                	push   $0x1e
  802447:	e8 c0 fc ff ff       	call   80210c <syscall>
  80244c:	83 c4 18             	add    $0x18,%esp
}
  80244f:	c9                   	leave  
  802450:	c3                   	ret    

00802451 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802451:	55                   	push   %ebp
  802452:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802454:	6a 00                	push   $0x0
  802456:	6a 00                	push   $0x0
  802458:	6a 00                	push   $0x0
  80245a:	6a 00                	push   $0x0
  80245c:	6a 00                	push   $0x0
  80245e:	6a 1f                	push   $0x1f
  802460:	e8 a7 fc ff ff       	call   80210c <syscall>
  802465:	83 c4 18             	add    $0x18,%esp
}
  802468:	c9                   	leave  
  802469:	c3                   	ret    

0080246a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80246a:	55                   	push   %ebp
  80246b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80246d:	8b 45 08             	mov    0x8(%ebp),%eax
  802470:	6a 00                	push   $0x0
  802472:	ff 75 14             	pushl  0x14(%ebp)
  802475:	ff 75 10             	pushl  0x10(%ebp)
  802478:	ff 75 0c             	pushl  0xc(%ebp)
  80247b:	50                   	push   %eax
  80247c:	6a 20                	push   $0x20
  80247e:	e8 89 fc ff ff       	call   80210c <syscall>
  802483:	83 c4 18             	add    $0x18,%esp
}
  802486:	c9                   	leave  
  802487:	c3                   	ret    

00802488 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802488:	55                   	push   %ebp
  802489:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80248b:	8b 45 08             	mov    0x8(%ebp),%eax
  80248e:	6a 00                	push   $0x0
  802490:	6a 00                	push   $0x0
  802492:	6a 00                	push   $0x0
  802494:	6a 00                	push   $0x0
  802496:	50                   	push   %eax
  802497:	6a 21                	push   $0x21
  802499:	e8 6e fc ff ff       	call   80210c <syscall>
  80249e:	83 c4 18             	add    $0x18,%esp
}
  8024a1:	90                   	nop
  8024a2:	c9                   	leave  
  8024a3:	c3                   	ret    

008024a4 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8024a4:	55                   	push   %ebp
  8024a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8024a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024aa:	6a 00                	push   $0x0
  8024ac:	6a 00                	push   $0x0
  8024ae:	6a 00                	push   $0x0
  8024b0:	6a 00                	push   $0x0
  8024b2:	50                   	push   %eax
  8024b3:	6a 22                	push   $0x22
  8024b5:	e8 52 fc ff ff       	call   80210c <syscall>
  8024ba:	83 c4 18             	add    $0x18,%esp
}
  8024bd:	c9                   	leave  
  8024be:	c3                   	ret    

008024bf <sys_getenvid>:

int32 sys_getenvid(void)
{
  8024bf:	55                   	push   %ebp
  8024c0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8024c2:	6a 00                	push   $0x0
  8024c4:	6a 00                	push   $0x0
  8024c6:	6a 00                	push   $0x0
  8024c8:	6a 00                	push   $0x0
  8024ca:	6a 00                	push   $0x0
  8024cc:	6a 02                	push   $0x2
  8024ce:	e8 39 fc ff ff       	call   80210c <syscall>
  8024d3:	83 c4 18             	add    $0x18,%esp
}
  8024d6:	c9                   	leave  
  8024d7:	c3                   	ret    

008024d8 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8024d8:	55                   	push   %ebp
  8024d9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8024db:	6a 00                	push   $0x0
  8024dd:	6a 00                	push   $0x0
  8024df:	6a 00                	push   $0x0
  8024e1:	6a 00                	push   $0x0
  8024e3:	6a 00                	push   $0x0
  8024e5:	6a 03                	push   $0x3
  8024e7:	e8 20 fc ff ff       	call   80210c <syscall>
  8024ec:	83 c4 18             	add    $0x18,%esp
}
  8024ef:	c9                   	leave  
  8024f0:	c3                   	ret    

008024f1 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8024f1:	55                   	push   %ebp
  8024f2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8024f4:	6a 00                	push   $0x0
  8024f6:	6a 00                	push   $0x0
  8024f8:	6a 00                	push   $0x0
  8024fa:	6a 00                	push   $0x0
  8024fc:	6a 00                	push   $0x0
  8024fe:	6a 04                	push   $0x4
  802500:	e8 07 fc ff ff       	call   80210c <syscall>
  802505:	83 c4 18             	add    $0x18,%esp
}
  802508:	c9                   	leave  
  802509:	c3                   	ret    

0080250a <sys_exit_env>:


void sys_exit_env(void)
{
  80250a:	55                   	push   %ebp
  80250b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80250d:	6a 00                	push   $0x0
  80250f:	6a 00                	push   $0x0
  802511:	6a 00                	push   $0x0
  802513:	6a 00                	push   $0x0
  802515:	6a 00                	push   $0x0
  802517:	6a 23                	push   $0x23
  802519:	e8 ee fb ff ff       	call   80210c <syscall>
  80251e:	83 c4 18             	add    $0x18,%esp
}
  802521:	90                   	nop
  802522:	c9                   	leave  
  802523:	c3                   	ret    

00802524 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802524:	55                   	push   %ebp
  802525:	89 e5                	mov    %esp,%ebp
  802527:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80252a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80252d:	8d 50 04             	lea    0x4(%eax),%edx
  802530:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802533:	6a 00                	push   $0x0
  802535:	6a 00                	push   $0x0
  802537:	6a 00                	push   $0x0
  802539:	52                   	push   %edx
  80253a:	50                   	push   %eax
  80253b:	6a 24                	push   $0x24
  80253d:	e8 ca fb ff ff       	call   80210c <syscall>
  802542:	83 c4 18             	add    $0x18,%esp
	return result;
  802545:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802548:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80254b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80254e:	89 01                	mov    %eax,(%ecx)
  802550:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802553:	8b 45 08             	mov    0x8(%ebp),%eax
  802556:	c9                   	leave  
  802557:	c2 04 00             	ret    $0x4

0080255a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80255a:	55                   	push   %ebp
  80255b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80255d:	6a 00                	push   $0x0
  80255f:	6a 00                	push   $0x0
  802561:	ff 75 10             	pushl  0x10(%ebp)
  802564:	ff 75 0c             	pushl  0xc(%ebp)
  802567:	ff 75 08             	pushl  0x8(%ebp)
  80256a:	6a 12                	push   $0x12
  80256c:	e8 9b fb ff ff       	call   80210c <syscall>
  802571:	83 c4 18             	add    $0x18,%esp
	return ;
  802574:	90                   	nop
}
  802575:	c9                   	leave  
  802576:	c3                   	ret    

00802577 <sys_rcr2>:
uint32 sys_rcr2()
{
  802577:	55                   	push   %ebp
  802578:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80257a:	6a 00                	push   $0x0
  80257c:	6a 00                	push   $0x0
  80257e:	6a 00                	push   $0x0
  802580:	6a 00                	push   $0x0
  802582:	6a 00                	push   $0x0
  802584:	6a 25                	push   $0x25
  802586:	e8 81 fb ff ff       	call   80210c <syscall>
  80258b:	83 c4 18             	add    $0x18,%esp
}
  80258e:	c9                   	leave  
  80258f:	c3                   	ret    

00802590 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802590:	55                   	push   %ebp
  802591:	89 e5                	mov    %esp,%ebp
  802593:	83 ec 04             	sub    $0x4,%esp
  802596:	8b 45 08             	mov    0x8(%ebp),%eax
  802599:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80259c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8025a0:	6a 00                	push   $0x0
  8025a2:	6a 00                	push   $0x0
  8025a4:	6a 00                	push   $0x0
  8025a6:	6a 00                	push   $0x0
  8025a8:	50                   	push   %eax
  8025a9:	6a 26                	push   $0x26
  8025ab:	e8 5c fb ff ff       	call   80210c <syscall>
  8025b0:	83 c4 18             	add    $0x18,%esp
	return ;
  8025b3:	90                   	nop
}
  8025b4:	c9                   	leave  
  8025b5:	c3                   	ret    

008025b6 <rsttst>:
void rsttst()
{
  8025b6:	55                   	push   %ebp
  8025b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8025b9:	6a 00                	push   $0x0
  8025bb:	6a 00                	push   $0x0
  8025bd:	6a 00                	push   $0x0
  8025bf:	6a 00                	push   $0x0
  8025c1:	6a 00                	push   $0x0
  8025c3:	6a 28                	push   $0x28
  8025c5:	e8 42 fb ff ff       	call   80210c <syscall>
  8025ca:	83 c4 18             	add    $0x18,%esp
	return ;
  8025cd:	90                   	nop
}
  8025ce:	c9                   	leave  
  8025cf:	c3                   	ret    

008025d0 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8025d0:	55                   	push   %ebp
  8025d1:	89 e5                	mov    %esp,%ebp
  8025d3:	83 ec 04             	sub    $0x4,%esp
  8025d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8025d9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8025dc:	8b 55 18             	mov    0x18(%ebp),%edx
  8025df:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8025e3:	52                   	push   %edx
  8025e4:	50                   	push   %eax
  8025e5:	ff 75 10             	pushl  0x10(%ebp)
  8025e8:	ff 75 0c             	pushl  0xc(%ebp)
  8025eb:	ff 75 08             	pushl  0x8(%ebp)
  8025ee:	6a 27                	push   $0x27
  8025f0:	e8 17 fb ff ff       	call   80210c <syscall>
  8025f5:	83 c4 18             	add    $0x18,%esp
	return ;
  8025f8:	90                   	nop
}
  8025f9:	c9                   	leave  
  8025fa:	c3                   	ret    

008025fb <chktst>:
void chktst(uint32 n)
{
  8025fb:	55                   	push   %ebp
  8025fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8025fe:	6a 00                	push   $0x0
  802600:	6a 00                	push   $0x0
  802602:	6a 00                	push   $0x0
  802604:	6a 00                	push   $0x0
  802606:	ff 75 08             	pushl  0x8(%ebp)
  802609:	6a 29                	push   $0x29
  80260b:	e8 fc fa ff ff       	call   80210c <syscall>
  802610:	83 c4 18             	add    $0x18,%esp
	return ;
  802613:	90                   	nop
}
  802614:	c9                   	leave  
  802615:	c3                   	ret    

00802616 <inctst>:

void inctst()
{
  802616:	55                   	push   %ebp
  802617:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802619:	6a 00                	push   $0x0
  80261b:	6a 00                	push   $0x0
  80261d:	6a 00                	push   $0x0
  80261f:	6a 00                	push   $0x0
  802621:	6a 00                	push   $0x0
  802623:	6a 2a                	push   $0x2a
  802625:	e8 e2 fa ff ff       	call   80210c <syscall>
  80262a:	83 c4 18             	add    $0x18,%esp
	return ;
  80262d:	90                   	nop
}
  80262e:	c9                   	leave  
  80262f:	c3                   	ret    

00802630 <gettst>:
uint32 gettst()
{
  802630:	55                   	push   %ebp
  802631:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802633:	6a 00                	push   $0x0
  802635:	6a 00                	push   $0x0
  802637:	6a 00                	push   $0x0
  802639:	6a 00                	push   $0x0
  80263b:	6a 00                	push   $0x0
  80263d:	6a 2b                	push   $0x2b
  80263f:	e8 c8 fa ff ff       	call   80210c <syscall>
  802644:	83 c4 18             	add    $0x18,%esp
}
  802647:	c9                   	leave  
  802648:	c3                   	ret    

00802649 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802649:	55                   	push   %ebp
  80264a:	89 e5                	mov    %esp,%ebp
  80264c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80264f:	6a 00                	push   $0x0
  802651:	6a 00                	push   $0x0
  802653:	6a 00                	push   $0x0
  802655:	6a 00                	push   $0x0
  802657:	6a 00                	push   $0x0
  802659:	6a 2c                	push   $0x2c
  80265b:	e8 ac fa ff ff       	call   80210c <syscall>
  802660:	83 c4 18             	add    $0x18,%esp
  802663:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802666:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80266a:	75 07                	jne    802673 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80266c:	b8 01 00 00 00       	mov    $0x1,%eax
  802671:	eb 05                	jmp    802678 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802673:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802678:	c9                   	leave  
  802679:	c3                   	ret    

0080267a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80267a:	55                   	push   %ebp
  80267b:	89 e5                	mov    %esp,%ebp
  80267d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802680:	6a 00                	push   $0x0
  802682:	6a 00                	push   $0x0
  802684:	6a 00                	push   $0x0
  802686:	6a 00                	push   $0x0
  802688:	6a 00                	push   $0x0
  80268a:	6a 2c                	push   $0x2c
  80268c:	e8 7b fa ff ff       	call   80210c <syscall>
  802691:	83 c4 18             	add    $0x18,%esp
  802694:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802697:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80269b:	75 07                	jne    8026a4 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80269d:	b8 01 00 00 00       	mov    $0x1,%eax
  8026a2:	eb 05                	jmp    8026a9 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8026a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026a9:	c9                   	leave  
  8026aa:	c3                   	ret    

008026ab <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8026ab:	55                   	push   %ebp
  8026ac:	89 e5                	mov    %esp,%ebp
  8026ae:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026b1:	6a 00                	push   $0x0
  8026b3:	6a 00                	push   $0x0
  8026b5:	6a 00                	push   $0x0
  8026b7:	6a 00                	push   $0x0
  8026b9:	6a 00                	push   $0x0
  8026bb:	6a 2c                	push   $0x2c
  8026bd:	e8 4a fa ff ff       	call   80210c <syscall>
  8026c2:	83 c4 18             	add    $0x18,%esp
  8026c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8026c8:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8026cc:	75 07                	jne    8026d5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8026ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8026d3:	eb 05                	jmp    8026da <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8026d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026da:	c9                   	leave  
  8026db:	c3                   	ret    

008026dc <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8026dc:	55                   	push   %ebp
  8026dd:	89 e5                	mov    %esp,%ebp
  8026df:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026e2:	6a 00                	push   $0x0
  8026e4:	6a 00                	push   $0x0
  8026e6:	6a 00                	push   $0x0
  8026e8:	6a 00                	push   $0x0
  8026ea:	6a 00                	push   $0x0
  8026ec:	6a 2c                	push   $0x2c
  8026ee:	e8 19 fa ff ff       	call   80210c <syscall>
  8026f3:	83 c4 18             	add    $0x18,%esp
  8026f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8026f9:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8026fd:	75 07                	jne    802706 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8026ff:	b8 01 00 00 00       	mov    $0x1,%eax
  802704:	eb 05                	jmp    80270b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802706:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80270b:	c9                   	leave  
  80270c:	c3                   	ret    

0080270d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80270d:	55                   	push   %ebp
  80270e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802710:	6a 00                	push   $0x0
  802712:	6a 00                	push   $0x0
  802714:	6a 00                	push   $0x0
  802716:	6a 00                	push   $0x0
  802718:	ff 75 08             	pushl  0x8(%ebp)
  80271b:	6a 2d                	push   $0x2d
  80271d:	e8 ea f9 ff ff       	call   80210c <syscall>
  802722:	83 c4 18             	add    $0x18,%esp
	return ;
  802725:	90                   	nop
}
  802726:	c9                   	leave  
  802727:	c3                   	ret    

00802728 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802728:	55                   	push   %ebp
  802729:	89 e5                	mov    %esp,%ebp
  80272b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80272c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80272f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802732:	8b 55 0c             	mov    0xc(%ebp),%edx
  802735:	8b 45 08             	mov    0x8(%ebp),%eax
  802738:	6a 00                	push   $0x0
  80273a:	53                   	push   %ebx
  80273b:	51                   	push   %ecx
  80273c:	52                   	push   %edx
  80273d:	50                   	push   %eax
  80273e:	6a 2e                	push   $0x2e
  802740:	e8 c7 f9 ff ff       	call   80210c <syscall>
  802745:	83 c4 18             	add    $0x18,%esp
}
  802748:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80274b:	c9                   	leave  
  80274c:	c3                   	ret    

0080274d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80274d:	55                   	push   %ebp
  80274e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802750:	8b 55 0c             	mov    0xc(%ebp),%edx
  802753:	8b 45 08             	mov    0x8(%ebp),%eax
  802756:	6a 00                	push   $0x0
  802758:	6a 00                	push   $0x0
  80275a:	6a 00                	push   $0x0
  80275c:	52                   	push   %edx
  80275d:	50                   	push   %eax
  80275e:	6a 2f                	push   $0x2f
  802760:	e8 a7 f9 ff ff       	call   80210c <syscall>
  802765:	83 c4 18             	add    $0x18,%esp
}
  802768:	c9                   	leave  
  802769:	c3                   	ret    

0080276a <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80276a:	55                   	push   %ebp
  80276b:	89 e5                	mov    %esp,%ebp
  80276d:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802770:	83 ec 0c             	sub    $0xc,%esp
  802773:	68 50 44 80 00       	push   $0x804450
  802778:	e8 d9 e4 ff ff       	call   800c56 <cprintf>
  80277d:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802780:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802787:	83 ec 0c             	sub    $0xc,%esp
  80278a:	68 7c 44 80 00       	push   $0x80447c
  80278f:	e8 c2 e4 ff ff       	call   800c56 <cprintf>
  802794:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802797:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80279b:	a1 38 51 80 00       	mov    0x805138,%eax
  8027a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027a3:	eb 56                	jmp    8027fb <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8027a5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027a9:	74 1c                	je     8027c7 <print_mem_block_lists+0x5d>
  8027ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ae:	8b 50 08             	mov    0x8(%eax),%edx
  8027b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b4:	8b 48 08             	mov    0x8(%eax),%ecx
  8027b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8027bd:	01 c8                	add    %ecx,%eax
  8027bf:	39 c2                	cmp    %eax,%edx
  8027c1:	73 04                	jae    8027c7 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8027c3:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8027c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ca:	8b 50 08             	mov    0x8(%eax),%edx
  8027cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8027d3:	01 c2                	add    %eax,%edx
  8027d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d8:	8b 40 08             	mov    0x8(%eax),%eax
  8027db:	83 ec 04             	sub    $0x4,%esp
  8027de:	52                   	push   %edx
  8027df:	50                   	push   %eax
  8027e0:	68 91 44 80 00       	push   $0x804491
  8027e5:	e8 6c e4 ff ff       	call   800c56 <cprintf>
  8027ea:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8027ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8027f3:	a1 40 51 80 00       	mov    0x805140,%eax
  8027f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ff:	74 07                	je     802808 <print_mem_block_lists+0x9e>
  802801:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802804:	8b 00                	mov    (%eax),%eax
  802806:	eb 05                	jmp    80280d <print_mem_block_lists+0xa3>
  802808:	b8 00 00 00 00       	mov    $0x0,%eax
  80280d:	a3 40 51 80 00       	mov    %eax,0x805140
  802812:	a1 40 51 80 00       	mov    0x805140,%eax
  802817:	85 c0                	test   %eax,%eax
  802819:	75 8a                	jne    8027a5 <print_mem_block_lists+0x3b>
  80281b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80281f:	75 84                	jne    8027a5 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802821:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802825:	75 10                	jne    802837 <print_mem_block_lists+0xcd>
  802827:	83 ec 0c             	sub    $0xc,%esp
  80282a:	68 a0 44 80 00       	push   $0x8044a0
  80282f:	e8 22 e4 ff ff       	call   800c56 <cprintf>
  802834:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802837:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80283e:	83 ec 0c             	sub    $0xc,%esp
  802841:	68 c4 44 80 00       	push   $0x8044c4
  802846:	e8 0b e4 ff ff       	call   800c56 <cprintf>
  80284b:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80284e:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802852:	a1 40 50 80 00       	mov    0x805040,%eax
  802857:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80285a:	eb 56                	jmp    8028b2 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80285c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802860:	74 1c                	je     80287e <print_mem_block_lists+0x114>
  802862:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802865:	8b 50 08             	mov    0x8(%eax),%edx
  802868:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80286b:	8b 48 08             	mov    0x8(%eax),%ecx
  80286e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802871:	8b 40 0c             	mov    0xc(%eax),%eax
  802874:	01 c8                	add    %ecx,%eax
  802876:	39 c2                	cmp    %eax,%edx
  802878:	73 04                	jae    80287e <print_mem_block_lists+0x114>
			sorted = 0 ;
  80287a:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80287e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802881:	8b 50 08             	mov    0x8(%eax),%edx
  802884:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802887:	8b 40 0c             	mov    0xc(%eax),%eax
  80288a:	01 c2                	add    %eax,%edx
  80288c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288f:	8b 40 08             	mov    0x8(%eax),%eax
  802892:	83 ec 04             	sub    $0x4,%esp
  802895:	52                   	push   %edx
  802896:	50                   	push   %eax
  802897:	68 91 44 80 00       	push   $0x804491
  80289c:	e8 b5 e3 ff ff       	call   800c56 <cprintf>
  8028a1:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8028a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8028aa:	a1 48 50 80 00       	mov    0x805048,%eax
  8028af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028b6:	74 07                	je     8028bf <print_mem_block_lists+0x155>
  8028b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bb:	8b 00                	mov    (%eax),%eax
  8028bd:	eb 05                	jmp    8028c4 <print_mem_block_lists+0x15a>
  8028bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8028c4:	a3 48 50 80 00       	mov    %eax,0x805048
  8028c9:	a1 48 50 80 00       	mov    0x805048,%eax
  8028ce:	85 c0                	test   %eax,%eax
  8028d0:	75 8a                	jne    80285c <print_mem_block_lists+0xf2>
  8028d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028d6:	75 84                	jne    80285c <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8028d8:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8028dc:	75 10                	jne    8028ee <print_mem_block_lists+0x184>
  8028de:	83 ec 0c             	sub    $0xc,%esp
  8028e1:	68 dc 44 80 00       	push   $0x8044dc
  8028e6:	e8 6b e3 ff ff       	call   800c56 <cprintf>
  8028eb:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8028ee:	83 ec 0c             	sub    $0xc,%esp
  8028f1:	68 50 44 80 00       	push   $0x804450
  8028f6:	e8 5b e3 ff ff       	call   800c56 <cprintf>
  8028fb:	83 c4 10             	add    $0x10,%esp

}
  8028fe:	90                   	nop
  8028ff:	c9                   	leave  
  802900:	c3                   	ret    

00802901 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802901:	55                   	push   %ebp
  802902:	89 e5                	mov    %esp,%ebp
  802904:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802907:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80290e:	00 00 00 
  802911:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802918:	00 00 00 
  80291b:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802922:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  802925:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80292c:	e9 9e 00 00 00       	jmp    8029cf <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802931:	a1 50 50 80 00       	mov    0x805050,%eax
  802936:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802939:	c1 e2 04             	shl    $0x4,%edx
  80293c:	01 d0                	add    %edx,%eax
  80293e:	85 c0                	test   %eax,%eax
  802940:	75 14                	jne    802956 <initialize_MemBlocksList+0x55>
  802942:	83 ec 04             	sub    $0x4,%esp
  802945:	68 04 45 80 00       	push   $0x804504
  80294a:	6a 42                	push   $0x42
  80294c:	68 27 45 80 00       	push   $0x804527
  802951:	e8 4c e0 ff ff       	call   8009a2 <_panic>
  802956:	a1 50 50 80 00       	mov    0x805050,%eax
  80295b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80295e:	c1 e2 04             	shl    $0x4,%edx
  802961:	01 d0                	add    %edx,%eax
  802963:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802969:	89 10                	mov    %edx,(%eax)
  80296b:	8b 00                	mov    (%eax),%eax
  80296d:	85 c0                	test   %eax,%eax
  80296f:	74 18                	je     802989 <initialize_MemBlocksList+0x88>
  802971:	a1 48 51 80 00       	mov    0x805148,%eax
  802976:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80297c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80297f:	c1 e1 04             	shl    $0x4,%ecx
  802982:	01 ca                	add    %ecx,%edx
  802984:	89 50 04             	mov    %edx,0x4(%eax)
  802987:	eb 12                	jmp    80299b <initialize_MemBlocksList+0x9a>
  802989:	a1 50 50 80 00       	mov    0x805050,%eax
  80298e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802991:	c1 e2 04             	shl    $0x4,%edx
  802994:	01 d0                	add    %edx,%eax
  802996:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80299b:	a1 50 50 80 00       	mov    0x805050,%eax
  8029a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029a3:	c1 e2 04             	shl    $0x4,%edx
  8029a6:	01 d0                	add    %edx,%eax
  8029a8:	a3 48 51 80 00       	mov    %eax,0x805148
  8029ad:	a1 50 50 80 00       	mov    0x805050,%eax
  8029b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029b5:	c1 e2 04             	shl    $0x4,%edx
  8029b8:	01 d0                	add    %edx,%eax
  8029ba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029c1:	a1 54 51 80 00       	mov    0x805154,%eax
  8029c6:	40                   	inc    %eax
  8029c7:	a3 54 51 80 00       	mov    %eax,0x805154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  8029cc:	ff 45 f4             	incl   -0xc(%ebp)
  8029cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029d5:	0f 82 56 ff ff ff    	jb     802931 <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  8029db:	90                   	nop
  8029dc:	c9                   	leave  
  8029dd:	c3                   	ret    

008029de <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8029de:	55                   	push   %ebp
  8029df:	89 e5                	mov    %esp,%ebp
  8029e1:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  8029e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e7:	8b 00                	mov    (%eax),%eax
  8029e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8029ec:	eb 19                	jmp    802a07 <find_block+0x29>
	{
		if(blk->sva==va)
  8029ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8029f1:	8b 40 08             	mov    0x8(%eax),%eax
  8029f4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8029f7:	75 05                	jne    8029fe <find_block+0x20>
			return (blk);
  8029f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8029fc:	eb 36                	jmp    802a34 <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  8029fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802a01:	8b 40 08             	mov    0x8(%eax),%eax
  802a04:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802a07:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802a0b:	74 07                	je     802a14 <find_block+0x36>
  802a0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a10:	8b 00                	mov    (%eax),%eax
  802a12:	eb 05                	jmp    802a19 <find_block+0x3b>
  802a14:	b8 00 00 00 00       	mov    $0x0,%eax
  802a19:	8b 55 08             	mov    0x8(%ebp),%edx
  802a1c:	89 42 08             	mov    %eax,0x8(%edx)
  802a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a22:	8b 40 08             	mov    0x8(%eax),%eax
  802a25:	85 c0                	test   %eax,%eax
  802a27:	75 c5                	jne    8029ee <find_block+0x10>
  802a29:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802a2d:	75 bf                	jne    8029ee <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  802a2f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a34:	c9                   	leave  
  802a35:	c3                   	ret    

00802a36 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802a36:	55                   	push   %ebp
  802a37:	89 e5                	mov    %esp,%ebp
  802a39:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  802a3c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a41:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802a44:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  802a4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a4e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802a51:	75 65                	jne    802ab8 <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802a53:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a57:	75 14                	jne    802a6d <insert_sorted_allocList+0x37>
  802a59:	83 ec 04             	sub    $0x4,%esp
  802a5c:	68 04 45 80 00       	push   $0x804504
  802a61:	6a 5c                	push   $0x5c
  802a63:	68 27 45 80 00       	push   $0x804527
  802a68:	e8 35 df ff ff       	call   8009a2 <_panic>
  802a6d:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802a73:	8b 45 08             	mov    0x8(%ebp),%eax
  802a76:	89 10                	mov    %edx,(%eax)
  802a78:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7b:	8b 00                	mov    (%eax),%eax
  802a7d:	85 c0                	test   %eax,%eax
  802a7f:	74 0d                	je     802a8e <insert_sorted_allocList+0x58>
  802a81:	a1 40 50 80 00       	mov    0x805040,%eax
  802a86:	8b 55 08             	mov    0x8(%ebp),%edx
  802a89:	89 50 04             	mov    %edx,0x4(%eax)
  802a8c:	eb 08                	jmp    802a96 <insert_sorted_allocList+0x60>
  802a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a91:	a3 44 50 80 00       	mov    %eax,0x805044
  802a96:	8b 45 08             	mov    0x8(%ebp),%eax
  802a99:	a3 40 50 80 00       	mov    %eax,0x805040
  802a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aa8:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802aad:	40                   	inc    %eax
  802aae:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  802ab3:	e9 7b 01 00 00       	jmp    802c33 <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  802ab8:	a1 44 50 80 00       	mov    0x805044,%eax
  802abd:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  802ac0:	a1 40 50 80 00       	mov    0x805040,%eax
  802ac5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  802ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  802acb:	8b 50 08             	mov    0x8(%eax),%edx
  802ace:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ad1:	8b 40 08             	mov    0x8(%eax),%eax
  802ad4:	39 c2                	cmp    %eax,%edx
  802ad6:	76 65                	jbe    802b3d <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  802ad8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802adc:	75 14                	jne    802af2 <insert_sorted_allocList+0xbc>
  802ade:	83 ec 04             	sub    $0x4,%esp
  802ae1:	68 40 45 80 00       	push   $0x804540
  802ae6:	6a 64                	push   $0x64
  802ae8:	68 27 45 80 00       	push   $0x804527
  802aed:	e8 b0 de ff ff       	call   8009a2 <_panic>
  802af2:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802af8:	8b 45 08             	mov    0x8(%ebp),%eax
  802afb:	89 50 04             	mov    %edx,0x4(%eax)
  802afe:	8b 45 08             	mov    0x8(%ebp),%eax
  802b01:	8b 40 04             	mov    0x4(%eax),%eax
  802b04:	85 c0                	test   %eax,%eax
  802b06:	74 0c                	je     802b14 <insert_sorted_allocList+0xde>
  802b08:	a1 44 50 80 00       	mov    0x805044,%eax
  802b0d:	8b 55 08             	mov    0x8(%ebp),%edx
  802b10:	89 10                	mov    %edx,(%eax)
  802b12:	eb 08                	jmp    802b1c <insert_sorted_allocList+0xe6>
  802b14:	8b 45 08             	mov    0x8(%ebp),%eax
  802b17:	a3 40 50 80 00       	mov    %eax,0x805040
  802b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1f:	a3 44 50 80 00       	mov    %eax,0x805044
  802b24:	8b 45 08             	mov    0x8(%ebp),%eax
  802b27:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b2d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b32:	40                   	inc    %eax
  802b33:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  802b38:	e9 f6 00 00 00       	jmp    802c33 <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  802b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b40:	8b 50 08             	mov    0x8(%eax),%edx
  802b43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b46:	8b 40 08             	mov    0x8(%eax),%eax
  802b49:	39 c2                	cmp    %eax,%edx
  802b4b:	73 65                	jae    802bb2 <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802b4d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b51:	75 14                	jne    802b67 <insert_sorted_allocList+0x131>
  802b53:	83 ec 04             	sub    $0x4,%esp
  802b56:	68 04 45 80 00       	push   $0x804504
  802b5b:	6a 68                	push   $0x68
  802b5d:	68 27 45 80 00       	push   $0x804527
  802b62:	e8 3b de ff ff       	call   8009a2 <_panic>
  802b67:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b70:	89 10                	mov    %edx,(%eax)
  802b72:	8b 45 08             	mov    0x8(%ebp),%eax
  802b75:	8b 00                	mov    (%eax),%eax
  802b77:	85 c0                	test   %eax,%eax
  802b79:	74 0d                	je     802b88 <insert_sorted_allocList+0x152>
  802b7b:	a1 40 50 80 00       	mov    0x805040,%eax
  802b80:	8b 55 08             	mov    0x8(%ebp),%edx
  802b83:	89 50 04             	mov    %edx,0x4(%eax)
  802b86:	eb 08                	jmp    802b90 <insert_sorted_allocList+0x15a>
  802b88:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8b:	a3 44 50 80 00       	mov    %eax,0x805044
  802b90:	8b 45 08             	mov    0x8(%ebp),%eax
  802b93:	a3 40 50 80 00       	mov    %eax,0x805040
  802b98:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ba2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802ba7:	40                   	inc    %eax
  802ba8:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  802bad:	e9 81 00 00 00       	jmp    802c33 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802bb2:	a1 40 50 80 00       	mov    0x805040,%eax
  802bb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bba:	eb 51                	jmp    802c0d <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  802bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbf:	8b 50 08             	mov    0x8(%eax),%edx
  802bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc5:	8b 40 08             	mov    0x8(%eax),%eax
  802bc8:	39 c2                	cmp    %eax,%edx
  802bca:	73 39                	jae    802c05 <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  802bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcf:	8b 40 04             	mov    0x4(%eax),%eax
  802bd2:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  802bd5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bd8:	8b 55 08             	mov    0x8(%ebp),%edx
  802bdb:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  802bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  802be0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802be3:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  802be6:	8b 45 08             	mov    0x8(%ebp),%eax
  802be9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bec:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  802bee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf1:	8b 55 08             	mov    0x8(%ebp),%edx
  802bf4:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  802bf7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802bfc:	40                   	inc    %eax
  802bfd:	a3 4c 50 80 00       	mov    %eax,0x80504c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  802c02:	90                   	nop
				}
			}
		 }

	}
}
  802c03:	eb 2e                	jmp    802c33 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802c05:	a1 48 50 80 00       	mov    0x805048,%eax
  802c0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c11:	74 07                	je     802c1a <insert_sorted_allocList+0x1e4>
  802c13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c16:	8b 00                	mov    (%eax),%eax
  802c18:	eb 05                	jmp    802c1f <insert_sorted_allocList+0x1e9>
  802c1a:	b8 00 00 00 00       	mov    $0x0,%eax
  802c1f:	a3 48 50 80 00       	mov    %eax,0x805048
  802c24:	a1 48 50 80 00       	mov    0x805048,%eax
  802c29:	85 c0                	test   %eax,%eax
  802c2b:	75 8f                	jne    802bbc <insert_sorted_allocList+0x186>
  802c2d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c31:	75 89                	jne    802bbc <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  802c33:	90                   	nop
  802c34:	c9                   	leave  
  802c35:	c3                   	ret    

00802c36 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802c36:	55                   	push   %ebp
  802c37:	89 e5                	mov    %esp,%ebp
  802c39:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802c3c:	a1 38 51 80 00       	mov    0x805138,%eax
  802c41:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c44:	e9 76 01 00 00       	jmp    802dbf <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  802c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4c:	8b 40 0c             	mov    0xc(%eax),%eax
  802c4f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c52:	0f 85 8a 00 00 00    	jne    802ce2 <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  802c58:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c5c:	75 17                	jne    802c75 <alloc_block_FF+0x3f>
  802c5e:	83 ec 04             	sub    $0x4,%esp
  802c61:	68 63 45 80 00       	push   $0x804563
  802c66:	68 8a 00 00 00       	push   $0x8a
  802c6b:	68 27 45 80 00       	push   $0x804527
  802c70:	e8 2d dd ff ff       	call   8009a2 <_panic>
  802c75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c78:	8b 00                	mov    (%eax),%eax
  802c7a:	85 c0                	test   %eax,%eax
  802c7c:	74 10                	je     802c8e <alloc_block_FF+0x58>
  802c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c81:	8b 00                	mov    (%eax),%eax
  802c83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c86:	8b 52 04             	mov    0x4(%edx),%edx
  802c89:	89 50 04             	mov    %edx,0x4(%eax)
  802c8c:	eb 0b                	jmp    802c99 <alloc_block_FF+0x63>
  802c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c91:	8b 40 04             	mov    0x4(%eax),%eax
  802c94:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9c:	8b 40 04             	mov    0x4(%eax),%eax
  802c9f:	85 c0                	test   %eax,%eax
  802ca1:	74 0f                	je     802cb2 <alloc_block_FF+0x7c>
  802ca3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca6:	8b 40 04             	mov    0x4(%eax),%eax
  802ca9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cac:	8b 12                	mov    (%edx),%edx
  802cae:	89 10                	mov    %edx,(%eax)
  802cb0:	eb 0a                	jmp    802cbc <alloc_block_FF+0x86>
  802cb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb5:	8b 00                	mov    (%eax),%eax
  802cb7:	a3 38 51 80 00       	mov    %eax,0x805138
  802cbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ccf:	a1 44 51 80 00       	mov    0x805144,%eax
  802cd4:	48                   	dec    %eax
  802cd5:	a3 44 51 80 00       	mov    %eax,0x805144
			return element;
  802cda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdd:	e9 10 01 00 00       	jmp    802df2 <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  802ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ce8:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ceb:	0f 86 c6 00 00 00    	jbe    802db7 <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802cf1:	a1 48 51 80 00       	mov    0x805148,%eax
  802cf6:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802cf9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cfd:	75 17                	jne    802d16 <alloc_block_FF+0xe0>
  802cff:	83 ec 04             	sub    $0x4,%esp
  802d02:	68 63 45 80 00       	push   $0x804563
  802d07:	68 90 00 00 00       	push   $0x90
  802d0c:	68 27 45 80 00       	push   $0x804527
  802d11:	e8 8c dc ff ff       	call   8009a2 <_panic>
  802d16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d19:	8b 00                	mov    (%eax),%eax
  802d1b:	85 c0                	test   %eax,%eax
  802d1d:	74 10                	je     802d2f <alloc_block_FF+0xf9>
  802d1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d22:	8b 00                	mov    (%eax),%eax
  802d24:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d27:	8b 52 04             	mov    0x4(%edx),%edx
  802d2a:	89 50 04             	mov    %edx,0x4(%eax)
  802d2d:	eb 0b                	jmp    802d3a <alloc_block_FF+0x104>
  802d2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d32:	8b 40 04             	mov    0x4(%eax),%eax
  802d35:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3d:	8b 40 04             	mov    0x4(%eax),%eax
  802d40:	85 c0                	test   %eax,%eax
  802d42:	74 0f                	je     802d53 <alloc_block_FF+0x11d>
  802d44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d47:	8b 40 04             	mov    0x4(%eax),%eax
  802d4a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d4d:	8b 12                	mov    (%edx),%edx
  802d4f:	89 10                	mov    %edx,(%eax)
  802d51:	eb 0a                	jmp    802d5d <alloc_block_FF+0x127>
  802d53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d56:	8b 00                	mov    (%eax),%eax
  802d58:	a3 48 51 80 00       	mov    %eax,0x805148
  802d5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d69:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d70:	a1 54 51 80 00       	mov    0x805154,%eax
  802d75:	48                   	dec    %eax
  802d76:	a3 54 51 80 00       	mov    %eax,0x805154
			 element1->size =size;
  802d7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7e:	8b 55 08             	mov    0x8(%ebp),%edx
  802d81:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  802d84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d87:	8b 50 08             	mov    0x8(%eax),%edx
  802d8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d8d:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  802d90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d93:	8b 50 08             	mov    0x8(%eax),%edx
  802d96:	8b 45 08             	mov    0x8(%ebp),%eax
  802d99:	01 c2                	add    %eax,%edx
  802d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9e:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  802da1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da4:	8b 40 0c             	mov    0xc(%eax),%eax
  802da7:	2b 45 08             	sub    0x8(%ebp),%eax
  802daa:	89 c2                	mov    %eax,%edx
  802dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802daf:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  802db2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db5:	eb 3b                	jmp    802df2 <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802db7:	a1 40 51 80 00       	mov    0x805140,%eax
  802dbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dbf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dc3:	74 07                	je     802dcc <alloc_block_FF+0x196>
  802dc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc8:	8b 00                	mov    (%eax),%eax
  802dca:	eb 05                	jmp    802dd1 <alloc_block_FF+0x19b>
  802dcc:	b8 00 00 00 00       	mov    $0x0,%eax
  802dd1:	a3 40 51 80 00       	mov    %eax,0x805140
  802dd6:	a1 40 51 80 00       	mov    0x805140,%eax
  802ddb:	85 c0                	test   %eax,%eax
  802ddd:	0f 85 66 fe ff ff    	jne    802c49 <alloc_block_FF+0x13>
  802de3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802de7:	0f 85 5c fe ff ff    	jne    802c49 <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  802ded:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802df2:	c9                   	leave  
  802df3:	c3                   	ret    

00802df4 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802df4:	55                   	push   %ebp
  802df5:	89 e5                	mov    %esp,%ebp
  802df7:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  802dfa:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  802e01:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  802e08:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802e0f:	a1 38 51 80 00       	mov    0x805138,%eax
  802e14:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e17:	e9 cf 00 00 00       	jmp    802eeb <alloc_block_BF+0xf7>
		{
			c++;
  802e1c:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  802e1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e22:	8b 40 0c             	mov    0xc(%eax),%eax
  802e25:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e28:	0f 85 8a 00 00 00    	jne    802eb8 <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  802e2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e32:	75 17                	jne    802e4b <alloc_block_BF+0x57>
  802e34:	83 ec 04             	sub    $0x4,%esp
  802e37:	68 63 45 80 00       	push   $0x804563
  802e3c:	68 a8 00 00 00       	push   $0xa8
  802e41:	68 27 45 80 00       	push   $0x804527
  802e46:	e8 57 db ff ff       	call   8009a2 <_panic>
  802e4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4e:	8b 00                	mov    (%eax),%eax
  802e50:	85 c0                	test   %eax,%eax
  802e52:	74 10                	je     802e64 <alloc_block_BF+0x70>
  802e54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e57:	8b 00                	mov    (%eax),%eax
  802e59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e5c:	8b 52 04             	mov    0x4(%edx),%edx
  802e5f:	89 50 04             	mov    %edx,0x4(%eax)
  802e62:	eb 0b                	jmp    802e6f <alloc_block_BF+0x7b>
  802e64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e67:	8b 40 04             	mov    0x4(%eax),%eax
  802e6a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e72:	8b 40 04             	mov    0x4(%eax),%eax
  802e75:	85 c0                	test   %eax,%eax
  802e77:	74 0f                	je     802e88 <alloc_block_BF+0x94>
  802e79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7c:	8b 40 04             	mov    0x4(%eax),%eax
  802e7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e82:	8b 12                	mov    (%edx),%edx
  802e84:	89 10                	mov    %edx,(%eax)
  802e86:	eb 0a                	jmp    802e92 <alloc_block_BF+0x9e>
  802e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8b:	8b 00                	mov    (%eax),%eax
  802e8d:	a3 38 51 80 00       	mov    %eax,0x805138
  802e92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e95:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ea5:	a1 44 51 80 00       	mov    0x805144,%eax
  802eaa:	48                   	dec    %eax
  802eab:	a3 44 51 80 00       	mov    %eax,0x805144
				return block;
  802eb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb3:	e9 85 01 00 00       	jmp    80303d <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  802eb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebb:	8b 40 0c             	mov    0xc(%eax),%eax
  802ebe:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ec1:	76 20                	jbe    802ee3 <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  802ec3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec9:	2b 45 08             	sub    0x8(%ebp),%eax
  802ecc:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  802ecf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802ed2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802ed5:	73 0c                	jae    802ee3 <alloc_block_BF+0xef>
				{
					ma=tempi;
  802ed7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802eda:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  802edd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ee0:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802ee3:	a1 40 51 80 00       	mov    0x805140,%eax
  802ee8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802eeb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eef:	74 07                	je     802ef8 <alloc_block_BF+0x104>
  802ef1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef4:	8b 00                	mov    (%eax),%eax
  802ef6:	eb 05                	jmp    802efd <alloc_block_BF+0x109>
  802ef8:	b8 00 00 00 00       	mov    $0x0,%eax
  802efd:	a3 40 51 80 00       	mov    %eax,0x805140
  802f02:	a1 40 51 80 00       	mov    0x805140,%eax
  802f07:	85 c0                	test   %eax,%eax
  802f09:	0f 85 0d ff ff ff    	jne    802e1c <alloc_block_BF+0x28>
  802f0f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f13:	0f 85 03 ff ff ff    	jne    802e1c <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  802f19:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802f20:	a1 38 51 80 00       	mov    0x805138,%eax
  802f25:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f28:	e9 dd 00 00 00       	jmp    80300a <alloc_block_BF+0x216>
		{
			if(x==sol)
  802f2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f30:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802f33:	0f 85 c6 00 00 00    	jne    802fff <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802f39:	a1 48 51 80 00       	mov    0x805148,%eax
  802f3e:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802f41:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802f45:	75 17                	jne    802f5e <alloc_block_BF+0x16a>
  802f47:	83 ec 04             	sub    $0x4,%esp
  802f4a:	68 63 45 80 00       	push   $0x804563
  802f4f:	68 bb 00 00 00       	push   $0xbb
  802f54:	68 27 45 80 00       	push   $0x804527
  802f59:	e8 44 da ff ff       	call   8009a2 <_panic>
  802f5e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f61:	8b 00                	mov    (%eax),%eax
  802f63:	85 c0                	test   %eax,%eax
  802f65:	74 10                	je     802f77 <alloc_block_BF+0x183>
  802f67:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f6a:	8b 00                	mov    (%eax),%eax
  802f6c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f6f:	8b 52 04             	mov    0x4(%edx),%edx
  802f72:	89 50 04             	mov    %edx,0x4(%eax)
  802f75:	eb 0b                	jmp    802f82 <alloc_block_BF+0x18e>
  802f77:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f7a:	8b 40 04             	mov    0x4(%eax),%eax
  802f7d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f82:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f85:	8b 40 04             	mov    0x4(%eax),%eax
  802f88:	85 c0                	test   %eax,%eax
  802f8a:	74 0f                	je     802f9b <alloc_block_BF+0x1a7>
  802f8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f8f:	8b 40 04             	mov    0x4(%eax),%eax
  802f92:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802f95:	8b 12                	mov    (%edx),%edx
  802f97:	89 10                	mov    %edx,(%eax)
  802f99:	eb 0a                	jmp    802fa5 <alloc_block_BF+0x1b1>
  802f9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f9e:	8b 00                	mov    (%eax),%eax
  802fa0:	a3 48 51 80 00       	mov    %eax,0x805148
  802fa5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fa8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fb1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fb8:	a1 54 51 80 00       	mov    0x805154,%eax
  802fbd:	48                   	dec    %eax
  802fbe:	a3 54 51 80 00       	mov    %eax,0x805154
						 element1->size =size;
  802fc3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fc6:	8b 55 08             	mov    0x8(%ebp),%edx
  802fc9:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  802fcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcf:	8b 50 08             	mov    0x8(%eax),%edx
  802fd2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fd5:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  802fd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fdb:	8b 50 08             	mov    0x8(%eax),%edx
  802fde:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe1:	01 c2                	add    %eax,%edx
  802fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe6:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  802fe9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fec:	8b 40 0c             	mov    0xc(%eax),%eax
  802fef:	2b 45 08             	sub    0x8(%ebp),%eax
  802ff2:	89 c2                	mov    %eax,%edx
  802ff4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff7:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  802ffa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ffd:	eb 3e                	jmp    80303d <alloc_block_BF+0x249>
						 break;
			}
			x++;
  802fff:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  803002:	a1 40 51 80 00       	mov    0x805140,%eax
  803007:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80300a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80300e:	74 07                	je     803017 <alloc_block_BF+0x223>
  803010:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803013:	8b 00                	mov    (%eax),%eax
  803015:	eb 05                	jmp    80301c <alloc_block_BF+0x228>
  803017:	b8 00 00 00 00       	mov    $0x0,%eax
  80301c:	a3 40 51 80 00       	mov    %eax,0x805140
  803021:	a1 40 51 80 00       	mov    0x805140,%eax
  803026:	85 c0                	test   %eax,%eax
  803028:	0f 85 ff fe ff ff    	jne    802f2d <alloc_block_BF+0x139>
  80302e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803032:	0f 85 f5 fe ff ff    	jne    802f2d <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  803038:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80303d:	c9                   	leave  
  80303e:	c3                   	ret    

0080303f <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  80303f:	55                   	push   %ebp
  803040:	89 e5                	mov    %esp,%ebp
  803042:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  803045:	a1 2c 50 80 00       	mov    0x80502c,%eax
  80304a:	85 c0                	test   %eax,%eax
  80304c:	75 14                	jne    803062 <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  80304e:	a1 38 51 80 00       	mov    0x805138,%eax
  803053:	a3 60 51 80 00       	mov    %eax,0x805160
		hh=1;
  803058:	c7 05 2c 50 80 00 01 	movl   $0x1,0x80502c
  80305f:	00 00 00 
	}
	uint32 c=1;
  803062:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  803069:	a1 60 51 80 00       	mov    0x805160,%eax
  80306e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  803071:	e9 b3 01 00 00       	jmp    803229 <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  803076:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803079:	8b 40 0c             	mov    0xc(%eax),%eax
  80307c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80307f:	0f 85 a9 00 00 00    	jne    80312e <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  803085:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803088:	8b 00                	mov    (%eax),%eax
  80308a:	85 c0                	test   %eax,%eax
  80308c:	75 0c                	jne    80309a <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  80308e:	a1 38 51 80 00       	mov    0x805138,%eax
  803093:	a3 60 51 80 00       	mov    %eax,0x805160
  803098:	eb 0a                	jmp    8030a4 <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  80309a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80309d:	8b 00                	mov    (%eax),%eax
  80309f:	a3 60 51 80 00       	mov    %eax,0x805160
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  8030a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030a8:	75 17                	jne    8030c1 <alloc_block_NF+0x82>
  8030aa:	83 ec 04             	sub    $0x4,%esp
  8030ad:	68 63 45 80 00       	push   $0x804563
  8030b2:	68 e3 00 00 00       	push   $0xe3
  8030b7:	68 27 45 80 00       	push   $0x804527
  8030bc:	e8 e1 d8 ff ff       	call   8009a2 <_panic>
  8030c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030c4:	8b 00                	mov    (%eax),%eax
  8030c6:	85 c0                	test   %eax,%eax
  8030c8:	74 10                	je     8030da <alloc_block_NF+0x9b>
  8030ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030cd:	8b 00                	mov    (%eax),%eax
  8030cf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030d2:	8b 52 04             	mov    0x4(%edx),%edx
  8030d5:	89 50 04             	mov    %edx,0x4(%eax)
  8030d8:	eb 0b                	jmp    8030e5 <alloc_block_NF+0xa6>
  8030da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030dd:	8b 40 04             	mov    0x4(%eax),%eax
  8030e0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030e8:	8b 40 04             	mov    0x4(%eax),%eax
  8030eb:	85 c0                	test   %eax,%eax
  8030ed:	74 0f                	je     8030fe <alloc_block_NF+0xbf>
  8030ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f2:	8b 40 04             	mov    0x4(%eax),%eax
  8030f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030f8:	8b 12                	mov    (%edx),%edx
  8030fa:	89 10                	mov    %edx,(%eax)
  8030fc:	eb 0a                	jmp    803108 <alloc_block_NF+0xc9>
  8030fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803101:	8b 00                	mov    (%eax),%eax
  803103:	a3 38 51 80 00       	mov    %eax,0x805138
  803108:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80310b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803111:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803114:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80311b:	a1 44 51 80 00       	mov    0x805144,%eax
  803120:	48                   	dec    %eax
  803121:	a3 44 51 80 00       	mov    %eax,0x805144
				return element;
  803126:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803129:	e9 0e 01 00 00       	jmp    80323c <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  80312e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803131:	8b 40 0c             	mov    0xc(%eax),%eax
  803134:	3b 45 08             	cmp    0x8(%ebp),%eax
  803137:	0f 86 ce 00 00 00    	jbe    80320b <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  80313d:	a1 48 51 80 00       	mov    0x805148,%eax
  803142:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  803145:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803149:	75 17                	jne    803162 <alloc_block_NF+0x123>
  80314b:	83 ec 04             	sub    $0x4,%esp
  80314e:	68 63 45 80 00       	push   $0x804563
  803153:	68 e9 00 00 00       	push   $0xe9
  803158:	68 27 45 80 00       	push   $0x804527
  80315d:	e8 40 d8 ff ff       	call   8009a2 <_panic>
  803162:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803165:	8b 00                	mov    (%eax),%eax
  803167:	85 c0                	test   %eax,%eax
  803169:	74 10                	je     80317b <alloc_block_NF+0x13c>
  80316b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80316e:	8b 00                	mov    (%eax),%eax
  803170:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803173:	8b 52 04             	mov    0x4(%edx),%edx
  803176:	89 50 04             	mov    %edx,0x4(%eax)
  803179:	eb 0b                	jmp    803186 <alloc_block_NF+0x147>
  80317b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80317e:	8b 40 04             	mov    0x4(%eax),%eax
  803181:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803186:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803189:	8b 40 04             	mov    0x4(%eax),%eax
  80318c:	85 c0                	test   %eax,%eax
  80318e:	74 0f                	je     80319f <alloc_block_NF+0x160>
  803190:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803193:	8b 40 04             	mov    0x4(%eax),%eax
  803196:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803199:	8b 12                	mov    (%edx),%edx
  80319b:	89 10                	mov    %edx,(%eax)
  80319d:	eb 0a                	jmp    8031a9 <alloc_block_NF+0x16a>
  80319f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031a2:	8b 00                	mov    (%eax),%eax
  8031a4:	a3 48 51 80 00       	mov    %eax,0x805148
  8031a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031b5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031bc:	a1 54 51 80 00       	mov    0x805154,%eax
  8031c1:	48                   	dec    %eax
  8031c2:	a3 54 51 80 00       	mov    %eax,0x805154
				 element1->size =size;
  8031c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8031cd:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  8031d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d3:	8b 50 08             	mov    0x8(%eax),%edx
  8031d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031d9:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  8031dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031df:	8b 50 08             	mov    0x8(%eax),%edx
  8031e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e5:	01 c2                	add    %eax,%edx
  8031e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ea:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  8031ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8031f3:	2b 45 08             	sub    0x8(%ebp),%eax
  8031f6:	89 c2                	mov    %eax,%edx
  8031f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031fb:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  8031fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803201:	a3 60 51 80 00       	mov    %eax,0x805160
				 return element1;
  803206:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803209:	eb 31                	jmp    80323c <alloc_block_NF+0x1fd>
			 }
		 c++;
  80320b:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  80320e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803211:	8b 00                	mov    (%eax),%eax
  803213:	85 c0                	test   %eax,%eax
  803215:	75 0a                	jne    803221 <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  803217:	a1 38 51 80 00       	mov    0x805138,%eax
  80321c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80321f:	eb 08                	jmp    803229 <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  803221:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803224:	8b 00                	mov    (%eax),%eax
  803226:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  803229:	a1 44 51 80 00       	mov    0x805144,%eax
  80322e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803231:	0f 85 3f fe ff ff    	jne    803076 <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  803237:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80323c:	c9                   	leave  
  80323d:	c3                   	ret    

0080323e <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80323e:	55                   	push   %ebp
  80323f:	89 e5                	mov    %esp,%ebp
  803241:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  803244:	a1 44 51 80 00       	mov    0x805144,%eax
  803249:	85 c0                	test   %eax,%eax
  80324b:	75 68                	jne    8032b5 <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  80324d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803251:	75 17                	jne    80326a <insert_sorted_with_merge_freeList+0x2c>
  803253:	83 ec 04             	sub    $0x4,%esp
  803256:	68 04 45 80 00       	push   $0x804504
  80325b:	68 0e 01 00 00       	push   $0x10e
  803260:	68 27 45 80 00       	push   $0x804527
  803265:	e8 38 d7 ff ff       	call   8009a2 <_panic>
  80326a:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803270:	8b 45 08             	mov    0x8(%ebp),%eax
  803273:	89 10                	mov    %edx,(%eax)
  803275:	8b 45 08             	mov    0x8(%ebp),%eax
  803278:	8b 00                	mov    (%eax),%eax
  80327a:	85 c0                	test   %eax,%eax
  80327c:	74 0d                	je     80328b <insert_sorted_with_merge_freeList+0x4d>
  80327e:	a1 38 51 80 00       	mov    0x805138,%eax
  803283:	8b 55 08             	mov    0x8(%ebp),%edx
  803286:	89 50 04             	mov    %edx,0x4(%eax)
  803289:	eb 08                	jmp    803293 <insert_sorted_with_merge_freeList+0x55>
  80328b:	8b 45 08             	mov    0x8(%ebp),%eax
  80328e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803293:	8b 45 08             	mov    0x8(%ebp),%eax
  803296:	a3 38 51 80 00       	mov    %eax,0x805138
  80329b:	8b 45 08             	mov    0x8(%ebp),%eax
  80329e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032a5:	a1 44 51 80 00       	mov    0x805144,%eax
  8032aa:	40                   	inc    %eax
  8032ab:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  8032b0:	e9 8c 06 00 00       	jmp    803941 <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  8032b5:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8032ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  8032bd:	a1 38 51 80 00       	mov    0x805138,%eax
  8032c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  8032c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c8:	8b 50 08             	mov    0x8(%eax),%edx
  8032cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032ce:	8b 40 08             	mov    0x8(%eax),%eax
  8032d1:	39 c2                	cmp    %eax,%edx
  8032d3:	0f 86 14 01 00 00    	jbe    8033ed <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  8032d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032dc:	8b 50 0c             	mov    0xc(%eax),%edx
  8032df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032e2:	8b 40 08             	mov    0x8(%eax),%eax
  8032e5:	01 c2                	add    %eax,%edx
  8032e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ea:	8b 40 08             	mov    0x8(%eax),%eax
  8032ed:	39 c2                	cmp    %eax,%edx
  8032ef:	0f 85 90 00 00 00    	jne    803385 <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  8032f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f8:	8b 50 0c             	mov    0xc(%eax),%edx
  8032fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fe:	8b 40 0c             	mov    0xc(%eax),%eax
  803301:	01 c2                	add    %eax,%edx
  803303:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803306:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  803309:	8b 45 08             	mov    0x8(%ebp),%eax
  80330c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  803313:	8b 45 08             	mov    0x8(%ebp),%eax
  803316:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80331d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803321:	75 17                	jne    80333a <insert_sorted_with_merge_freeList+0xfc>
  803323:	83 ec 04             	sub    $0x4,%esp
  803326:	68 04 45 80 00       	push   $0x804504
  80332b:	68 1b 01 00 00       	push   $0x11b
  803330:	68 27 45 80 00       	push   $0x804527
  803335:	e8 68 d6 ff ff       	call   8009a2 <_panic>
  80333a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803340:	8b 45 08             	mov    0x8(%ebp),%eax
  803343:	89 10                	mov    %edx,(%eax)
  803345:	8b 45 08             	mov    0x8(%ebp),%eax
  803348:	8b 00                	mov    (%eax),%eax
  80334a:	85 c0                	test   %eax,%eax
  80334c:	74 0d                	je     80335b <insert_sorted_with_merge_freeList+0x11d>
  80334e:	a1 48 51 80 00       	mov    0x805148,%eax
  803353:	8b 55 08             	mov    0x8(%ebp),%edx
  803356:	89 50 04             	mov    %edx,0x4(%eax)
  803359:	eb 08                	jmp    803363 <insert_sorted_with_merge_freeList+0x125>
  80335b:	8b 45 08             	mov    0x8(%ebp),%eax
  80335e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803363:	8b 45 08             	mov    0x8(%ebp),%eax
  803366:	a3 48 51 80 00       	mov    %eax,0x805148
  80336b:	8b 45 08             	mov    0x8(%ebp),%eax
  80336e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803375:	a1 54 51 80 00       	mov    0x805154,%eax
  80337a:	40                   	inc    %eax
  80337b:	a3 54 51 80 00       	mov    %eax,0x805154
							}

						}
		          }
		}
}
  803380:	e9 bc 05 00 00       	jmp    803941 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803385:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803389:	75 17                	jne    8033a2 <insert_sorted_with_merge_freeList+0x164>
  80338b:	83 ec 04             	sub    $0x4,%esp
  80338e:	68 40 45 80 00       	push   $0x804540
  803393:	68 1f 01 00 00       	push   $0x11f
  803398:	68 27 45 80 00       	push   $0x804527
  80339d:	e8 00 d6 ff ff       	call   8009a2 <_panic>
  8033a2:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8033a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ab:	89 50 04             	mov    %edx,0x4(%eax)
  8033ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b1:	8b 40 04             	mov    0x4(%eax),%eax
  8033b4:	85 c0                	test   %eax,%eax
  8033b6:	74 0c                	je     8033c4 <insert_sorted_with_merge_freeList+0x186>
  8033b8:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8033bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8033c0:	89 10                	mov    %edx,(%eax)
  8033c2:	eb 08                	jmp    8033cc <insert_sorted_with_merge_freeList+0x18e>
  8033c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c7:	a3 38 51 80 00       	mov    %eax,0x805138
  8033cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033cf:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033dd:	a1 44 51 80 00       	mov    0x805144,%eax
  8033e2:	40                   	inc    %eax
  8033e3:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  8033e8:	e9 54 05 00 00       	jmp    803941 <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  8033ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f0:	8b 50 08             	mov    0x8(%eax),%edx
  8033f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033f6:	8b 40 08             	mov    0x8(%eax),%eax
  8033f9:	39 c2                	cmp    %eax,%edx
  8033fb:	0f 83 20 01 00 00    	jae    803521 <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  803401:	8b 45 08             	mov    0x8(%ebp),%eax
  803404:	8b 50 0c             	mov    0xc(%eax),%edx
  803407:	8b 45 08             	mov    0x8(%ebp),%eax
  80340a:	8b 40 08             	mov    0x8(%eax),%eax
  80340d:	01 c2                	add    %eax,%edx
  80340f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803412:	8b 40 08             	mov    0x8(%eax),%eax
  803415:	39 c2                	cmp    %eax,%edx
  803417:	0f 85 9c 00 00 00    	jne    8034b9 <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  80341d:	8b 45 08             	mov    0x8(%ebp),%eax
  803420:	8b 50 08             	mov    0x8(%eax),%edx
  803423:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803426:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  803429:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80342c:	8b 50 0c             	mov    0xc(%eax),%edx
  80342f:	8b 45 08             	mov    0x8(%ebp),%eax
  803432:	8b 40 0c             	mov    0xc(%eax),%eax
  803435:	01 c2                	add    %eax,%edx
  803437:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80343a:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  80343d:	8b 45 08             	mov    0x8(%ebp),%eax
  803440:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  803447:	8b 45 08             	mov    0x8(%ebp),%eax
  80344a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803451:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803455:	75 17                	jne    80346e <insert_sorted_with_merge_freeList+0x230>
  803457:	83 ec 04             	sub    $0x4,%esp
  80345a:	68 04 45 80 00       	push   $0x804504
  80345f:	68 2a 01 00 00       	push   $0x12a
  803464:	68 27 45 80 00       	push   $0x804527
  803469:	e8 34 d5 ff ff       	call   8009a2 <_panic>
  80346e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803474:	8b 45 08             	mov    0x8(%ebp),%eax
  803477:	89 10                	mov    %edx,(%eax)
  803479:	8b 45 08             	mov    0x8(%ebp),%eax
  80347c:	8b 00                	mov    (%eax),%eax
  80347e:	85 c0                	test   %eax,%eax
  803480:	74 0d                	je     80348f <insert_sorted_with_merge_freeList+0x251>
  803482:	a1 48 51 80 00       	mov    0x805148,%eax
  803487:	8b 55 08             	mov    0x8(%ebp),%edx
  80348a:	89 50 04             	mov    %edx,0x4(%eax)
  80348d:	eb 08                	jmp    803497 <insert_sorted_with_merge_freeList+0x259>
  80348f:	8b 45 08             	mov    0x8(%ebp),%eax
  803492:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803497:	8b 45 08             	mov    0x8(%ebp),%eax
  80349a:	a3 48 51 80 00       	mov    %eax,0x805148
  80349f:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034a9:	a1 54 51 80 00       	mov    0x805154,%eax
  8034ae:	40                   	inc    %eax
  8034af:	a3 54 51 80 00       	mov    %eax,0x805154
							}

						}
		          }
		}
}
  8034b4:	e9 88 04 00 00       	jmp    803941 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8034b9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034bd:	75 17                	jne    8034d6 <insert_sorted_with_merge_freeList+0x298>
  8034bf:	83 ec 04             	sub    $0x4,%esp
  8034c2:	68 04 45 80 00       	push   $0x804504
  8034c7:	68 2e 01 00 00       	push   $0x12e
  8034cc:	68 27 45 80 00       	push   $0x804527
  8034d1:	e8 cc d4 ff ff       	call   8009a2 <_panic>
  8034d6:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8034dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8034df:	89 10                	mov    %edx,(%eax)
  8034e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e4:	8b 00                	mov    (%eax),%eax
  8034e6:	85 c0                	test   %eax,%eax
  8034e8:	74 0d                	je     8034f7 <insert_sorted_with_merge_freeList+0x2b9>
  8034ea:	a1 38 51 80 00       	mov    0x805138,%eax
  8034ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8034f2:	89 50 04             	mov    %edx,0x4(%eax)
  8034f5:	eb 08                	jmp    8034ff <insert_sorted_with_merge_freeList+0x2c1>
  8034f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fa:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803502:	a3 38 51 80 00       	mov    %eax,0x805138
  803507:	8b 45 08             	mov    0x8(%ebp),%eax
  80350a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803511:	a1 44 51 80 00       	mov    0x805144,%eax
  803516:	40                   	inc    %eax
  803517:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  80351c:	e9 20 04 00 00       	jmp    803941 <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  803521:	a1 38 51 80 00       	mov    0x805138,%eax
  803526:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803529:	e9 e2 03 00 00       	jmp    803910 <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  80352e:	8b 45 08             	mov    0x8(%ebp),%eax
  803531:	8b 50 08             	mov    0x8(%eax),%edx
  803534:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803537:	8b 40 08             	mov    0x8(%eax),%eax
  80353a:	39 c2                	cmp    %eax,%edx
  80353c:	0f 83 c6 03 00 00    	jae    803908 <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  803542:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803545:	8b 40 04             	mov    0x4(%eax),%eax
  803548:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  80354b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80354e:	8b 50 08             	mov    0x8(%eax),%edx
  803551:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803554:	8b 40 0c             	mov    0xc(%eax),%eax
  803557:	01 d0                	add    %edx,%eax
  803559:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  80355c:	8b 45 08             	mov    0x8(%ebp),%eax
  80355f:	8b 50 0c             	mov    0xc(%eax),%edx
  803562:	8b 45 08             	mov    0x8(%ebp),%eax
  803565:	8b 40 08             	mov    0x8(%eax),%eax
  803568:	01 d0                	add    %edx,%eax
  80356a:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  80356d:	8b 45 08             	mov    0x8(%ebp),%eax
  803570:	8b 40 08             	mov    0x8(%eax),%eax
  803573:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803576:	74 7a                	je     8035f2 <insert_sorted_with_merge_freeList+0x3b4>
  803578:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80357b:	8b 40 08             	mov    0x8(%eax),%eax
  80357e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803581:	74 6f                	je     8035f2 <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  803583:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803587:	74 06                	je     80358f <insert_sorted_with_merge_freeList+0x351>
  803589:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80358d:	75 17                	jne    8035a6 <insert_sorted_with_merge_freeList+0x368>
  80358f:	83 ec 04             	sub    $0x4,%esp
  803592:	68 84 45 80 00       	push   $0x804584
  803597:	68 43 01 00 00       	push   $0x143
  80359c:	68 27 45 80 00       	push   $0x804527
  8035a1:	e8 fc d3 ff ff       	call   8009a2 <_panic>
  8035a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a9:	8b 50 04             	mov    0x4(%eax),%edx
  8035ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8035af:	89 50 04             	mov    %edx,0x4(%eax)
  8035b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035b8:	89 10                	mov    %edx,(%eax)
  8035ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035bd:	8b 40 04             	mov    0x4(%eax),%eax
  8035c0:	85 c0                	test   %eax,%eax
  8035c2:	74 0d                	je     8035d1 <insert_sorted_with_merge_freeList+0x393>
  8035c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c7:	8b 40 04             	mov    0x4(%eax),%eax
  8035ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8035cd:	89 10                	mov    %edx,(%eax)
  8035cf:	eb 08                	jmp    8035d9 <insert_sorted_with_merge_freeList+0x39b>
  8035d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d4:	a3 38 51 80 00       	mov    %eax,0x805138
  8035d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8035df:	89 50 04             	mov    %edx,0x4(%eax)
  8035e2:	a1 44 51 80 00       	mov    0x805144,%eax
  8035e7:	40                   	inc    %eax
  8035e8:	a3 44 51 80 00       	mov    %eax,0x805144
  8035ed:	e9 14 03 00 00       	jmp    803906 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  8035f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f5:	8b 40 08             	mov    0x8(%eax),%eax
  8035f8:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8035fb:	0f 85 a0 01 00 00    	jne    8037a1 <insert_sorted_with_merge_freeList+0x563>
  803601:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803604:	8b 40 08             	mov    0x8(%eax),%eax
  803607:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80360a:	0f 85 91 01 00 00    	jne    8037a1 <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  803610:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803613:	8b 50 0c             	mov    0xc(%eax),%edx
  803616:	8b 45 08             	mov    0x8(%ebp),%eax
  803619:	8b 48 0c             	mov    0xc(%eax),%ecx
  80361c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80361f:	8b 40 0c             	mov    0xc(%eax),%eax
  803622:	01 c8                	add    %ecx,%eax
  803624:	01 c2                	add    %eax,%edx
  803626:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803629:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  80362c:	8b 45 08             	mov    0x8(%ebp),%eax
  80362f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  803636:	8b 45 08             	mov    0x8(%ebp),%eax
  803639:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  803640:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803643:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  80364a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80364d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803654:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803658:	75 17                	jne    803671 <insert_sorted_with_merge_freeList+0x433>
  80365a:	83 ec 04             	sub    $0x4,%esp
  80365d:	68 04 45 80 00       	push   $0x804504
  803662:	68 4d 01 00 00       	push   $0x14d
  803667:	68 27 45 80 00       	push   $0x804527
  80366c:	e8 31 d3 ff ff       	call   8009a2 <_panic>
  803671:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803677:	8b 45 08             	mov    0x8(%ebp),%eax
  80367a:	89 10                	mov    %edx,(%eax)
  80367c:	8b 45 08             	mov    0x8(%ebp),%eax
  80367f:	8b 00                	mov    (%eax),%eax
  803681:	85 c0                	test   %eax,%eax
  803683:	74 0d                	je     803692 <insert_sorted_with_merge_freeList+0x454>
  803685:	a1 48 51 80 00       	mov    0x805148,%eax
  80368a:	8b 55 08             	mov    0x8(%ebp),%edx
  80368d:	89 50 04             	mov    %edx,0x4(%eax)
  803690:	eb 08                	jmp    80369a <insert_sorted_with_merge_freeList+0x45c>
  803692:	8b 45 08             	mov    0x8(%ebp),%eax
  803695:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80369a:	8b 45 08             	mov    0x8(%ebp),%eax
  80369d:	a3 48 51 80 00       	mov    %eax,0x805148
  8036a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036ac:	a1 54 51 80 00       	mov    0x805154,%eax
  8036b1:	40                   	inc    %eax
  8036b2:	a3 54 51 80 00       	mov    %eax,0x805154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  8036b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036bb:	75 17                	jne    8036d4 <insert_sorted_with_merge_freeList+0x496>
  8036bd:	83 ec 04             	sub    $0x4,%esp
  8036c0:	68 63 45 80 00       	push   $0x804563
  8036c5:	68 4e 01 00 00       	push   $0x14e
  8036ca:	68 27 45 80 00       	push   $0x804527
  8036cf:	e8 ce d2 ff ff       	call   8009a2 <_panic>
  8036d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d7:	8b 00                	mov    (%eax),%eax
  8036d9:	85 c0                	test   %eax,%eax
  8036db:	74 10                	je     8036ed <insert_sorted_with_merge_freeList+0x4af>
  8036dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e0:	8b 00                	mov    (%eax),%eax
  8036e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036e5:	8b 52 04             	mov    0x4(%edx),%edx
  8036e8:	89 50 04             	mov    %edx,0x4(%eax)
  8036eb:	eb 0b                	jmp    8036f8 <insert_sorted_with_merge_freeList+0x4ba>
  8036ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f0:	8b 40 04             	mov    0x4(%eax),%eax
  8036f3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8036f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036fb:	8b 40 04             	mov    0x4(%eax),%eax
  8036fe:	85 c0                	test   %eax,%eax
  803700:	74 0f                	je     803711 <insert_sorted_with_merge_freeList+0x4d3>
  803702:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803705:	8b 40 04             	mov    0x4(%eax),%eax
  803708:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80370b:	8b 12                	mov    (%edx),%edx
  80370d:	89 10                	mov    %edx,(%eax)
  80370f:	eb 0a                	jmp    80371b <insert_sorted_with_merge_freeList+0x4dd>
  803711:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803714:	8b 00                	mov    (%eax),%eax
  803716:	a3 38 51 80 00       	mov    %eax,0x805138
  80371b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80371e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803727:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80372e:	a1 44 51 80 00       	mov    0x805144,%eax
  803733:	48                   	dec    %eax
  803734:	a3 44 51 80 00       	mov    %eax,0x805144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  803739:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80373d:	75 17                	jne    803756 <insert_sorted_with_merge_freeList+0x518>
  80373f:	83 ec 04             	sub    $0x4,%esp
  803742:	68 04 45 80 00       	push   $0x804504
  803747:	68 4f 01 00 00       	push   $0x14f
  80374c:	68 27 45 80 00       	push   $0x804527
  803751:	e8 4c d2 ff ff       	call   8009a2 <_panic>
  803756:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80375c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80375f:	89 10                	mov    %edx,(%eax)
  803761:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803764:	8b 00                	mov    (%eax),%eax
  803766:	85 c0                	test   %eax,%eax
  803768:	74 0d                	je     803777 <insert_sorted_with_merge_freeList+0x539>
  80376a:	a1 48 51 80 00       	mov    0x805148,%eax
  80376f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803772:	89 50 04             	mov    %edx,0x4(%eax)
  803775:	eb 08                	jmp    80377f <insert_sorted_with_merge_freeList+0x541>
  803777:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80377a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80377f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803782:	a3 48 51 80 00       	mov    %eax,0x805148
  803787:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80378a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803791:	a1 54 51 80 00       	mov    0x805154,%eax
  803796:	40                   	inc    %eax
  803797:	a3 54 51 80 00       	mov    %eax,0x805154
  80379c:	e9 65 01 00 00       	jmp    803906 <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  8037a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a4:	8b 40 08             	mov    0x8(%eax),%eax
  8037a7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8037aa:	0f 85 9f 00 00 00    	jne    80384f <insert_sorted_with_merge_freeList+0x611>
  8037b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b3:	8b 40 08             	mov    0x8(%eax),%eax
  8037b6:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8037b9:	0f 84 90 00 00 00    	je     80384f <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  8037bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037c2:	8b 50 0c             	mov    0xc(%eax),%edx
  8037c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8037cb:	01 c2                	add    %eax,%edx
  8037cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037d0:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  8037d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  8037dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8037e7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037eb:	75 17                	jne    803804 <insert_sorted_with_merge_freeList+0x5c6>
  8037ed:	83 ec 04             	sub    $0x4,%esp
  8037f0:	68 04 45 80 00       	push   $0x804504
  8037f5:	68 58 01 00 00       	push   $0x158
  8037fa:	68 27 45 80 00       	push   $0x804527
  8037ff:	e8 9e d1 ff ff       	call   8009a2 <_panic>
  803804:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80380a:	8b 45 08             	mov    0x8(%ebp),%eax
  80380d:	89 10                	mov    %edx,(%eax)
  80380f:	8b 45 08             	mov    0x8(%ebp),%eax
  803812:	8b 00                	mov    (%eax),%eax
  803814:	85 c0                	test   %eax,%eax
  803816:	74 0d                	je     803825 <insert_sorted_with_merge_freeList+0x5e7>
  803818:	a1 48 51 80 00       	mov    0x805148,%eax
  80381d:	8b 55 08             	mov    0x8(%ebp),%edx
  803820:	89 50 04             	mov    %edx,0x4(%eax)
  803823:	eb 08                	jmp    80382d <insert_sorted_with_merge_freeList+0x5ef>
  803825:	8b 45 08             	mov    0x8(%ebp),%eax
  803828:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80382d:	8b 45 08             	mov    0x8(%ebp),%eax
  803830:	a3 48 51 80 00       	mov    %eax,0x805148
  803835:	8b 45 08             	mov    0x8(%ebp),%eax
  803838:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80383f:	a1 54 51 80 00       	mov    0x805154,%eax
  803844:	40                   	inc    %eax
  803845:	a3 54 51 80 00       	mov    %eax,0x805154
  80384a:	e9 b7 00 00 00       	jmp    803906 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  80384f:	8b 45 08             	mov    0x8(%ebp),%eax
  803852:	8b 40 08             	mov    0x8(%eax),%eax
  803855:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803858:	0f 84 e2 00 00 00    	je     803940 <insert_sorted_with_merge_freeList+0x702>
  80385e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803861:	8b 40 08             	mov    0x8(%eax),%eax
  803864:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803867:	0f 85 d3 00 00 00    	jne    803940 <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  80386d:	8b 45 08             	mov    0x8(%ebp),%eax
  803870:	8b 50 08             	mov    0x8(%eax),%edx
  803873:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803876:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  803879:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80387c:	8b 50 0c             	mov    0xc(%eax),%edx
  80387f:	8b 45 08             	mov    0x8(%ebp),%eax
  803882:	8b 40 0c             	mov    0xc(%eax),%eax
  803885:	01 c2                	add    %eax,%edx
  803887:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80388a:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  80388d:	8b 45 08             	mov    0x8(%ebp),%eax
  803890:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  803897:	8b 45 08             	mov    0x8(%ebp),%eax
  80389a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8038a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038a5:	75 17                	jne    8038be <insert_sorted_with_merge_freeList+0x680>
  8038a7:	83 ec 04             	sub    $0x4,%esp
  8038aa:	68 04 45 80 00       	push   $0x804504
  8038af:	68 61 01 00 00       	push   $0x161
  8038b4:	68 27 45 80 00       	push   $0x804527
  8038b9:	e8 e4 d0 ff ff       	call   8009a2 <_panic>
  8038be:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8038c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c7:	89 10                	mov    %edx,(%eax)
  8038c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8038cc:	8b 00                	mov    (%eax),%eax
  8038ce:	85 c0                	test   %eax,%eax
  8038d0:	74 0d                	je     8038df <insert_sorted_with_merge_freeList+0x6a1>
  8038d2:	a1 48 51 80 00       	mov    0x805148,%eax
  8038d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8038da:	89 50 04             	mov    %edx,0x4(%eax)
  8038dd:	eb 08                	jmp    8038e7 <insert_sorted_with_merge_freeList+0x6a9>
  8038df:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8038e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ea:	a3 48 51 80 00       	mov    %eax,0x805148
  8038ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038f9:	a1 54 51 80 00       	mov    0x805154,%eax
  8038fe:	40                   	inc    %eax
  8038ff:	a3 54 51 80 00       	mov    %eax,0x805154
								}
								break;
  803904:	eb 3a                	jmp    803940 <insert_sorted_with_merge_freeList+0x702>
  803906:	eb 38                	jmp    803940 <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  803908:	a1 40 51 80 00       	mov    0x805140,%eax
  80390d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803910:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803914:	74 07                	je     80391d <insert_sorted_with_merge_freeList+0x6df>
  803916:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803919:	8b 00                	mov    (%eax),%eax
  80391b:	eb 05                	jmp    803922 <insert_sorted_with_merge_freeList+0x6e4>
  80391d:	b8 00 00 00 00       	mov    $0x0,%eax
  803922:	a3 40 51 80 00       	mov    %eax,0x805140
  803927:	a1 40 51 80 00       	mov    0x805140,%eax
  80392c:	85 c0                	test   %eax,%eax
  80392e:	0f 85 fa fb ff ff    	jne    80352e <insert_sorted_with_merge_freeList+0x2f0>
  803934:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803938:	0f 85 f0 fb ff ff    	jne    80352e <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  80393e:	eb 01                	jmp    803941 <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  803940:	90                   	nop
							}

						}
		          }
		}
}
  803941:	90                   	nop
  803942:	c9                   	leave  
  803943:	c3                   	ret    

00803944 <__udivdi3>:
  803944:	55                   	push   %ebp
  803945:	57                   	push   %edi
  803946:	56                   	push   %esi
  803947:	53                   	push   %ebx
  803948:	83 ec 1c             	sub    $0x1c,%esp
  80394b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80394f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803953:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803957:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80395b:	89 ca                	mov    %ecx,%edx
  80395d:	89 f8                	mov    %edi,%eax
  80395f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803963:	85 f6                	test   %esi,%esi
  803965:	75 2d                	jne    803994 <__udivdi3+0x50>
  803967:	39 cf                	cmp    %ecx,%edi
  803969:	77 65                	ja     8039d0 <__udivdi3+0x8c>
  80396b:	89 fd                	mov    %edi,%ebp
  80396d:	85 ff                	test   %edi,%edi
  80396f:	75 0b                	jne    80397c <__udivdi3+0x38>
  803971:	b8 01 00 00 00       	mov    $0x1,%eax
  803976:	31 d2                	xor    %edx,%edx
  803978:	f7 f7                	div    %edi
  80397a:	89 c5                	mov    %eax,%ebp
  80397c:	31 d2                	xor    %edx,%edx
  80397e:	89 c8                	mov    %ecx,%eax
  803980:	f7 f5                	div    %ebp
  803982:	89 c1                	mov    %eax,%ecx
  803984:	89 d8                	mov    %ebx,%eax
  803986:	f7 f5                	div    %ebp
  803988:	89 cf                	mov    %ecx,%edi
  80398a:	89 fa                	mov    %edi,%edx
  80398c:	83 c4 1c             	add    $0x1c,%esp
  80398f:	5b                   	pop    %ebx
  803990:	5e                   	pop    %esi
  803991:	5f                   	pop    %edi
  803992:	5d                   	pop    %ebp
  803993:	c3                   	ret    
  803994:	39 ce                	cmp    %ecx,%esi
  803996:	77 28                	ja     8039c0 <__udivdi3+0x7c>
  803998:	0f bd fe             	bsr    %esi,%edi
  80399b:	83 f7 1f             	xor    $0x1f,%edi
  80399e:	75 40                	jne    8039e0 <__udivdi3+0x9c>
  8039a0:	39 ce                	cmp    %ecx,%esi
  8039a2:	72 0a                	jb     8039ae <__udivdi3+0x6a>
  8039a4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8039a8:	0f 87 9e 00 00 00    	ja     803a4c <__udivdi3+0x108>
  8039ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8039b3:	89 fa                	mov    %edi,%edx
  8039b5:	83 c4 1c             	add    $0x1c,%esp
  8039b8:	5b                   	pop    %ebx
  8039b9:	5e                   	pop    %esi
  8039ba:	5f                   	pop    %edi
  8039bb:	5d                   	pop    %ebp
  8039bc:	c3                   	ret    
  8039bd:	8d 76 00             	lea    0x0(%esi),%esi
  8039c0:	31 ff                	xor    %edi,%edi
  8039c2:	31 c0                	xor    %eax,%eax
  8039c4:	89 fa                	mov    %edi,%edx
  8039c6:	83 c4 1c             	add    $0x1c,%esp
  8039c9:	5b                   	pop    %ebx
  8039ca:	5e                   	pop    %esi
  8039cb:	5f                   	pop    %edi
  8039cc:	5d                   	pop    %ebp
  8039cd:	c3                   	ret    
  8039ce:	66 90                	xchg   %ax,%ax
  8039d0:	89 d8                	mov    %ebx,%eax
  8039d2:	f7 f7                	div    %edi
  8039d4:	31 ff                	xor    %edi,%edi
  8039d6:	89 fa                	mov    %edi,%edx
  8039d8:	83 c4 1c             	add    $0x1c,%esp
  8039db:	5b                   	pop    %ebx
  8039dc:	5e                   	pop    %esi
  8039dd:	5f                   	pop    %edi
  8039de:	5d                   	pop    %ebp
  8039df:	c3                   	ret    
  8039e0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8039e5:	89 eb                	mov    %ebp,%ebx
  8039e7:	29 fb                	sub    %edi,%ebx
  8039e9:	89 f9                	mov    %edi,%ecx
  8039eb:	d3 e6                	shl    %cl,%esi
  8039ed:	89 c5                	mov    %eax,%ebp
  8039ef:	88 d9                	mov    %bl,%cl
  8039f1:	d3 ed                	shr    %cl,%ebp
  8039f3:	89 e9                	mov    %ebp,%ecx
  8039f5:	09 f1                	or     %esi,%ecx
  8039f7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8039fb:	89 f9                	mov    %edi,%ecx
  8039fd:	d3 e0                	shl    %cl,%eax
  8039ff:	89 c5                	mov    %eax,%ebp
  803a01:	89 d6                	mov    %edx,%esi
  803a03:	88 d9                	mov    %bl,%cl
  803a05:	d3 ee                	shr    %cl,%esi
  803a07:	89 f9                	mov    %edi,%ecx
  803a09:	d3 e2                	shl    %cl,%edx
  803a0b:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a0f:	88 d9                	mov    %bl,%cl
  803a11:	d3 e8                	shr    %cl,%eax
  803a13:	09 c2                	or     %eax,%edx
  803a15:	89 d0                	mov    %edx,%eax
  803a17:	89 f2                	mov    %esi,%edx
  803a19:	f7 74 24 0c          	divl   0xc(%esp)
  803a1d:	89 d6                	mov    %edx,%esi
  803a1f:	89 c3                	mov    %eax,%ebx
  803a21:	f7 e5                	mul    %ebp
  803a23:	39 d6                	cmp    %edx,%esi
  803a25:	72 19                	jb     803a40 <__udivdi3+0xfc>
  803a27:	74 0b                	je     803a34 <__udivdi3+0xf0>
  803a29:	89 d8                	mov    %ebx,%eax
  803a2b:	31 ff                	xor    %edi,%edi
  803a2d:	e9 58 ff ff ff       	jmp    80398a <__udivdi3+0x46>
  803a32:	66 90                	xchg   %ax,%ax
  803a34:	8b 54 24 08          	mov    0x8(%esp),%edx
  803a38:	89 f9                	mov    %edi,%ecx
  803a3a:	d3 e2                	shl    %cl,%edx
  803a3c:	39 c2                	cmp    %eax,%edx
  803a3e:	73 e9                	jae    803a29 <__udivdi3+0xe5>
  803a40:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803a43:	31 ff                	xor    %edi,%edi
  803a45:	e9 40 ff ff ff       	jmp    80398a <__udivdi3+0x46>
  803a4a:	66 90                	xchg   %ax,%ax
  803a4c:	31 c0                	xor    %eax,%eax
  803a4e:	e9 37 ff ff ff       	jmp    80398a <__udivdi3+0x46>
  803a53:	90                   	nop

00803a54 <__umoddi3>:
  803a54:	55                   	push   %ebp
  803a55:	57                   	push   %edi
  803a56:	56                   	push   %esi
  803a57:	53                   	push   %ebx
  803a58:	83 ec 1c             	sub    $0x1c,%esp
  803a5b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803a5f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803a63:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a67:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803a6b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803a6f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803a73:	89 f3                	mov    %esi,%ebx
  803a75:	89 fa                	mov    %edi,%edx
  803a77:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a7b:	89 34 24             	mov    %esi,(%esp)
  803a7e:	85 c0                	test   %eax,%eax
  803a80:	75 1a                	jne    803a9c <__umoddi3+0x48>
  803a82:	39 f7                	cmp    %esi,%edi
  803a84:	0f 86 a2 00 00 00    	jbe    803b2c <__umoddi3+0xd8>
  803a8a:	89 c8                	mov    %ecx,%eax
  803a8c:	89 f2                	mov    %esi,%edx
  803a8e:	f7 f7                	div    %edi
  803a90:	89 d0                	mov    %edx,%eax
  803a92:	31 d2                	xor    %edx,%edx
  803a94:	83 c4 1c             	add    $0x1c,%esp
  803a97:	5b                   	pop    %ebx
  803a98:	5e                   	pop    %esi
  803a99:	5f                   	pop    %edi
  803a9a:	5d                   	pop    %ebp
  803a9b:	c3                   	ret    
  803a9c:	39 f0                	cmp    %esi,%eax
  803a9e:	0f 87 ac 00 00 00    	ja     803b50 <__umoddi3+0xfc>
  803aa4:	0f bd e8             	bsr    %eax,%ebp
  803aa7:	83 f5 1f             	xor    $0x1f,%ebp
  803aaa:	0f 84 ac 00 00 00    	je     803b5c <__umoddi3+0x108>
  803ab0:	bf 20 00 00 00       	mov    $0x20,%edi
  803ab5:	29 ef                	sub    %ebp,%edi
  803ab7:	89 fe                	mov    %edi,%esi
  803ab9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803abd:	89 e9                	mov    %ebp,%ecx
  803abf:	d3 e0                	shl    %cl,%eax
  803ac1:	89 d7                	mov    %edx,%edi
  803ac3:	89 f1                	mov    %esi,%ecx
  803ac5:	d3 ef                	shr    %cl,%edi
  803ac7:	09 c7                	or     %eax,%edi
  803ac9:	89 e9                	mov    %ebp,%ecx
  803acb:	d3 e2                	shl    %cl,%edx
  803acd:	89 14 24             	mov    %edx,(%esp)
  803ad0:	89 d8                	mov    %ebx,%eax
  803ad2:	d3 e0                	shl    %cl,%eax
  803ad4:	89 c2                	mov    %eax,%edx
  803ad6:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ada:	d3 e0                	shl    %cl,%eax
  803adc:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ae0:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ae4:	89 f1                	mov    %esi,%ecx
  803ae6:	d3 e8                	shr    %cl,%eax
  803ae8:	09 d0                	or     %edx,%eax
  803aea:	d3 eb                	shr    %cl,%ebx
  803aec:	89 da                	mov    %ebx,%edx
  803aee:	f7 f7                	div    %edi
  803af0:	89 d3                	mov    %edx,%ebx
  803af2:	f7 24 24             	mull   (%esp)
  803af5:	89 c6                	mov    %eax,%esi
  803af7:	89 d1                	mov    %edx,%ecx
  803af9:	39 d3                	cmp    %edx,%ebx
  803afb:	0f 82 87 00 00 00    	jb     803b88 <__umoddi3+0x134>
  803b01:	0f 84 91 00 00 00    	je     803b98 <__umoddi3+0x144>
  803b07:	8b 54 24 04          	mov    0x4(%esp),%edx
  803b0b:	29 f2                	sub    %esi,%edx
  803b0d:	19 cb                	sbb    %ecx,%ebx
  803b0f:	89 d8                	mov    %ebx,%eax
  803b11:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803b15:	d3 e0                	shl    %cl,%eax
  803b17:	89 e9                	mov    %ebp,%ecx
  803b19:	d3 ea                	shr    %cl,%edx
  803b1b:	09 d0                	or     %edx,%eax
  803b1d:	89 e9                	mov    %ebp,%ecx
  803b1f:	d3 eb                	shr    %cl,%ebx
  803b21:	89 da                	mov    %ebx,%edx
  803b23:	83 c4 1c             	add    $0x1c,%esp
  803b26:	5b                   	pop    %ebx
  803b27:	5e                   	pop    %esi
  803b28:	5f                   	pop    %edi
  803b29:	5d                   	pop    %ebp
  803b2a:	c3                   	ret    
  803b2b:	90                   	nop
  803b2c:	89 fd                	mov    %edi,%ebp
  803b2e:	85 ff                	test   %edi,%edi
  803b30:	75 0b                	jne    803b3d <__umoddi3+0xe9>
  803b32:	b8 01 00 00 00       	mov    $0x1,%eax
  803b37:	31 d2                	xor    %edx,%edx
  803b39:	f7 f7                	div    %edi
  803b3b:	89 c5                	mov    %eax,%ebp
  803b3d:	89 f0                	mov    %esi,%eax
  803b3f:	31 d2                	xor    %edx,%edx
  803b41:	f7 f5                	div    %ebp
  803b43:	89 c8                	mov    %ecx,%eax
  803b45:	f7 f5                	div    %ebp
  803b47:	89 d0                	mov    %edx,%eax
  803b49:	e9 44 ff ff ff       	jmp    803a92 <__umoddi3+0x3e>
  803b4e:	66 90                	xchg   %ax,%ax
  803b50:	89 c8                	mov    %ecx,%eax
  803b52:	89 f2                	mov    %esi,%edx
  803b54:	83 c4 1c             	add    $0x1c,%esp
  803b57:	5b                   	pop    %ebx
  803b58:	5e                   	pop    %esi
  803b59:	5f                   	pop    %edi
  803b5a:	5d                   	pop    %ebp
  803b5b:	c3                   	ret    
  803b5c:	3b 04 24             	cmp    (%esp),%eax
  803b5f:	72 06                	jb     803b67 <__umoddi3+0x113>
  803b61:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803b65:	77 0f                	ja     803b76 <__umoddi3+0x122>
  803b67:	89 f2                	mov    %esi,%edx
  803b69:	29 f9                	sub    %edi,%ecx
  803b6b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803b6f:	89 14 24             	mov    %edx,(%esp)
  803b72:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b76:	8b 44 24 04          	mov    0x4(%esp),%eax
  803b7a:	8b 14 24             	mov    (%esp),%edx
  803b7d:	83 c4 1c             	add    $0x1c,%esp
  803b80:	5b                   	pop    %ebx
  803b81:	5e                   	pop    %esi
  803b82:	5f                   	pop    %edi
  803b83:	5d                   	pop    %ebp
  803b84:	c3                   	ret    
  803b85:	8d 76 00             	lea    0x0(%esi),%esi
  803b88:	2b 04 24             	sub    (%esp),%eax
  803b8b:	19 fa                	sbb    %edi,%edx
  803b8d:	89 d1                	mov    %edx,%ecx
  803b8f:	89 c6                	mov    %eax,%esi
  803b91:	e9 71 ff ff ff       	jmp    803b07 <__umoddi3+0xb3>
  803b96:	66 90                	xchg   %ax,%ax
  803b98:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803b9c:	72 ea                	jb     803b88 <__umoddi3+0x134>
  803b9e:	89 d9                	mov    %ebx,%ecx
  803ba0:	e9 62 ff ff ff       	jmp    803b07 <__umoddi3+0xb3>

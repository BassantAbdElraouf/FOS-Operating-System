
obj/user/tst_malloc_2:     file format elf32-i386


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
  800031:	e8 80 03 00 00       	call   8003b6 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
	char a;
	short b;
	int c;
};
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	81 ec 94 00 00 00    	sub    $0x94,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  800042:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800046:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004d:	eb 29                	jmp    800078 <_main+0x40>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004f:	a1 20 40 80 00       	mov    0x804020,%eax
  800054:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80005a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005d:	89 d0                	mov    %edx,%eax
  80005f:	01 c0                	add    %eax,%eax
  800061:	01 d0                	add    %edx,%eax
  800063:	c1 e0 03             	shl    $0x3,%eax
  800066:	01 c8                	add    %ecx,%eax
  800068:	8a 40 04             	mov    0x4(%eax),%al
  80006b:	84 c0                	test   %al,%al
  80006d:	74 06                	je     800075 <_main+0x3d>
			{
				fullWS = 0;
  80006f:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800073:	eb 12                	jmp    800087 <_main+0x4f>
void _main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800075:	ff 45 f0             	incl   -0x10(%ebp)
  800078:	a1 20 40 80 00       	mov    0x804020,%eax
  80007d:	8b 50 74             	mov    0x74(%eax),%edx
  800080:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800083:	39 c2                	cmp    %eax,%edx
  800085:	77 c8                	ja     80004f <_main+0x17>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800087:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  80008b:	74 14                	je     8000a1 <_main+0x69>
  80008d:	83 ec 04             	sub    $0x4,%esp
  800090:	68 00 35 80 00       	push   $0x803500
  800095:	6a 1a                	push   $0x1a
  800097:	68 1c 35 80 00       	push   $0x80351c
  80009c:	e8 51 04 00 00       	call   8004f2 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	6a 00                	push   $0x0
  8000a6:	e8 2a 16 00 00       	call   8016d5 <malloc>
  8000ab:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/


	int Mega = 1024*1024;
  8000ae:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000b5:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	char minByte = 1<<7;
  8000bc:	c6 45 e7 80          	movb   $0x80,-0x19(%ebp)
	char maxByte = 0x7F;
  8000c0:	c6 45 e6 7f          	movb   $0x7f,-0x1a(%ebp)
	short minShort = 1<<15 ;
  8000c4:	66 c7 45 e4 00 80    	movw   $0x8000,-0x1c(%ebp)
	short maxShort = 0x7FFF;
  8000ca:	66 c7 45 e2 ff 7f    	movw   $0x7fff,-0x1e(%ebp)
	int minInt = 1<<31 ;
  8000d0:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
	int maxInt = 0x7FFFFFFF;
  8000d7:	c7 45 d8 ff ff ff 7f 	movl   $0x7fffffff,-0x28(%ebp)

	void* ptr_allocations[20] = {0};
  8000de:	8d 95 68 ff ff ff    	lea    -0x98(%ebp),%edx
  8000e4:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ee:	89 d7                	mov    %edx,%edi
  8000f0:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		ptr_allocations[0] = malloc(2*Mega-kilo);
  8000f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000f5:	01 c0                	add    %eax,%eax
  8000f7:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000fa:	83 ec 0c             	sub    $0xc,%esp
  8000fd:	50                   	push   %eax
  8000fe:	e8 d2 15 00 00       	call   8016d5 <malloc>
  800103:	83 c4 10             	add    $0x10,%esp
  800106:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
		char *byteArr = (char *) ptr_allocations[0];
  80010c:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800112:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  800115:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800118:	01 c0                	add    %eax,%eax
  80011a:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80011d:	48                   	dec    %eax
  80011e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = minByte ;
  800121:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800124:	8a 55 e7             	mov    -0x19(%ebp),%dl
  800127:	88 10                	mov    %dl,(%eax)
		byteArr[lastIndexOfByte] = maxByte ;
  800129:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80012c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80012f:	01 c2                	add    %eax,%edx
  800131:	8a 45 e6             	mov    -0x1a(%ebp),%al
  800134:	88 02                	mov    %al,(%edx)

		ptr_allocations[1] = malloc(2*Mega-kilo);
  800136:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800139:	01 c0                	add    %eax,%eax
  80013b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80013e:	83 ec 0c             	sub    $0xc,%esp
  800141:	50                   	push   %eax
  800142:	e8 8e 15 00 00       	call   8016d5 <malloc>
  800147:	83 c4 10             	add    $0x10,%esp
  80014a:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
		short *shortArr = (short *) ptr_allocations[1];
  800150:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800156:	89 45 cc             	mov    %eax,-0x34(%ebp)
		int lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  800159:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80015c:	01 c0                	add    %eax,%eax
  80015e:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800161:	d1 e8                	shr    %eax
  800163:	48                   	dec    %eax
  800164:	89 45 c8             	mov    %eax,-0x38(%ebp)
		shortArr[0] = minShort;
  800167:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80016a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80016d:	66 89 02             	mov    %ax,(%edx)
		shortArr[lastIndexOfShort] = maxShort;
  800170:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800173:	01 c0                	add    %eax,%eax
  800175:	89 c2                	mov    %eax,%edx
  800177:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80017a:	01 c2                	add    %eax,%edx
  80017c:	66 8b 45 e2          	mov    -0x1e(%ebp),%ax
  800180:	66 89 02             	mov    %ax,(%edx)

		ptr_allocations[2] = malloc(3*kilo);
  800183:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800186:	89 c2                	mov    %eax,%edx
  800188:	01 d2                	add    %edx,%edx
  80018a:	01 d0                	add    %edx,%eax
  80018c:	83 ec 0c             	sub    $0xc,%esp
  80018f:	50                   	push   %eax
  800190:	e8 40 15 00 00       	call   8016d5 <malloc>
  800195:	83 c4 10             	add    $0x10,%esp
  800198:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		int *intArr = (int *) ptr_allocations[2];
  80019e:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8001a4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		int lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
  8001a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001aa:	01 c0                	add    %eax,%eax
  8001ac:	c1 e8 02             	shr    $0x2,%eax
  8001af:	48                   	dec    %eax
  8001b0:	89 45 c0             	mov    %eax,-0x40(%ebp)
		intArr[0] = minInt;
  8001b3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8001b6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8001b9:	89 10                	mov    %edx,(%eax)
		intArr[lastIndexOfInt] = maxInt;
  8001bb:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8001be:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001c5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8001c8:	01 c2                	add    %eax,%edx
  8001ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001cd:	89 02                	mov    %eax,(%edx)

		ptr_allocations[3] = malloc(7*kilo);
  8001cf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8001d2:	89 d0                	mov    %edx,%eax
  8001d4:	01 c0                	add    %eax,%eax
  8001d6:	01 d0                	add    %edx,%eax
  8001d8:	01 c0                	add    %eax,%eax
  8001da:	01 d0                	add    %edx,%eax
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	50                   	push   %eax
  8001e0:	e8 f0 14 00 00       	call   8016d5 <malloc>
  8001e5:	83 c4 10             	add    $0x10,%esp
  8001e8:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
		struct MyStruct *structArr = (struct MyStruct *) ptr_allocations[3];
  8001ee:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8001f4:	89 45 bc             	mov    %eax,-0x44(%ebp)
		int lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  8001f7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8001fa:	89 d0                	mov    %edx,%eax
  8001fc:	01 c0                	add    %eax,%eax
  8001fe:	01 d0                	add    %edx,%eax
  800200:	01 c0                	add    %eax,%eax
  800202:	01 d0                	add    %edx,%eax
  800204:	c1 e8 03             	shr    $0x3,%eax
  800207:	48                   	dec    %eax
  800208:	89 45 b8             	mov    %eax,-0x48(%ebp)
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  80020b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80020e:	8a 55 e7             	mov    -0x19(%ebp),%dl
  800211:	88 10                	mov    %dl,(%eax)
  800213:	8b 55 bc             	mov    -0x44(%ebp),%edx
  800216:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800219:	66 89 42 02          	mov    %ax,0x2(%edx)
  80021d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800220:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800223:	89 50 04             	mov    %edx,0x4(%eax)
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  800226:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800229:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800230:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800233:	01 c2                	add    %eax,%edx
  800235:	8a 45 e6             	mov    -0x1a(%ebp),%al
  800238:	88 02                	mov    %al,(%edx)
  80023a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80023d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800244:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800247:	01 c2                	add    %eax,%edx
  800249:	66 8b 45 e2          	mov    -0x1e(%ebp),%ax
  80024d:	66 89 42 02          	mov    %ax,0x2(%edx)
  800251:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800254:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80025b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80025e:	01 c2                	add    %eax,%edx
  800260:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800263:	89 42 04             	mov    %eax,0x4(%edx)

		//Check that the values are successfully stored
		if (byteArr[0] 	!= minByte 	|| byteArr[lastIndexOfByte] 	!= maxByte) panic("Wrong allocation: stored values are wrongly changed!");
  800266:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800269:	8a 00                	mov    (%eax),%al
  80026b:	3a 45 e7             	cmp    -0x19(%ebp),%al
  80026e:	75 0f                	jne    80027f <_main+0x247>
  800270:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800273:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800276:	01 d0                	add    %edx,%eax
  800278:	8a 00                	mov    (%eax),%al
  80027a:	3a 45 e6             	cmp    -0x1a(%ebp),%al
  80027d:	74 14                	je     800293 <_main+0x25b>
  80027f:	83 ec 04             	sub    $0x4,%esp
  800282:	68 30 35 80 00       	push   $0x803530
  800287:	6a 45                	push   $0x45
  800289:	68 1c 35 80 00       	push   $0x80351c
  80028e:	e8 5f 02 00 00       	call   8004f2 <_panic>
		if (shortArr[0] != minShort || shortArr[lastIndexOfShort] 	!= maxShort) panic("Wrong allocation: stored values are wrongly changed!");
  800293:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800296:	66 8b 00             	mov    (%eax),%ax
  800299:	66 3b 45 e4          	cmp    -0x1c(%ebp),%ax
  80029d:	75 15                	jne    8002b4 <_main+0x27c>
  80029f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8002a2:	01 c0                	add    %eax,%eax
  8002a4:	89 c2                	mov    %eax,%edx
  8002a6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8002a9:	01 d0                	add    %edx,%eax
  8002ab:	66 8b 00             	mov    (%eax),%ax
  8002ae:	66 3b 45 e2          	cmp    -0x1e(%ebp),%ax
  8002b2:	74 14                	je     8002c8 <_main+0x290>
  8002b4:	83 ec 04             	sub    $0x4,%esp
  8002b7:	68 30 35 80 00       	push   $0x803530
  8002bc:	6a 46                	push   $0x46
  8002be:	68 1c 35 80 00       	push   $0x80351c
  8002c3:	e8 2a 02 00 00       	call   8004f2 <_panic>
		if (intArr[0] 	!= minInt 	|| intArr[lastIndexOfInt] 		!= maxInt) panic("Wrong allocation: stored values are wrongly changed!");
  8002c8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8002cb:	8b 00                	mov    (%eax),%eax
  8002cd:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8002d0:	75 16                	jne    8002e8 <_main+0x2b0>
  8002d2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8002d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002dc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8002df:	01 d0                	add    %edx,%eax
  8002e1:	8b 00                	mov    (%eax),%eax
  8002e3:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8002e6:	74 14                	je     8002fc <_main+0x2c4>
  8002e8:	83 ec 04             	sub    $0x4,%esp
  8002eb:	68 30 35 80 00       	push   $0x803530
  8002f0:	6a 47                	push   $0x47
  8002f2:	68 1c 35 80 00       	push   $0x80351c
  8002f7:	e8 f6 01 00 00       	call   8004f2 <_panic>

		if (structArr[0].a != minByte 	|| structArr[lastIndexOfStruct].a != maxByte) 	panic("Wrong allocation: stored values are wrongly changed!");
  8002fc:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8002ff:	8a 00                	mov    (%eax),%al
  800301:	3a 45 e7             	cmp    -0x19(%ebp),%al
  800304:	75 16                	jne    80031c <_main+0x2e4>
  800306:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800309:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800310:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800313:	01 d0                	add    %edx,%eax
  800315:	8a 00                	mov    (%eax),%al
  800317:	3a 45 e6             	cmp    -0x1a(%ebp),%al
  80031a:	74 14                	je     800330 <_main+0x2f8>
  80031c:	83 ec 04             	sub    $0x4,%esp
  80031f:	68 30 35 80 00       	push   $0x803530
  800324:	6a 49                	push   $0x49
  800326:	68 1c 35 80 00       	push   $0x80351c
  80032b:	e8 c2 01 00 00       	call   8004f2 <_panic>
		if (structArr[0].b != minShort 	|| structArr[lastIndexOfStruct].b != maxShort) 	panic("Wrong allocation: stored values are wrongly changed!");
  800330:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800333:	66 8b 40 02          	mov    0x2(%eax),%ax
  800337:	66 3b 45 e4          	cmp    -0x1c(%ebp),%ax
  80033b:	75 19                	jne    800356 <_main+0x31e>
  80033d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800340:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800347:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80034a:	01 d0                	add    %edx,%eax
  80034c:	66 8b 40 02          	mov    0x2(%eax),%ax
  800350:	66 3b 45 e2          	cmp    -0x1e(%ebp),%ax
  800354:	74 14                	je     80036a <_main+0x332>
  800356:	83 ec 04             	sub    $0x4,%esp
  800359:	68 30 35 80 00       	push   $0x803530
  80035e:	6a 4a                	push   $0x4a
  800360:	68 1c 35 80 00       	push   $0x80351c
  800365:	e8 88 01 00 00       	call   8004f2 <_panic>
		if (structArr[0].c != minInt 	|| structArr[lastIndexOfStruct].c != maxInt) 	panic("Wrong allocation: stored values are wrongly changed!");
  80036a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80036d:	8b 40 04             	mov    0x4(%eax),%eax
  800370:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800373:	75 17                	jne    80038c <_main+0x354>
  800375:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800378:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80037f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800382:	01 d0                	add    %edx,%eax
  800384:	8b 40 04             	mov    0x4(%eax),%eax
  800387:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80038a:	74 14                	je     8003a0 <_main+0x368>
  80038c:	83 ec 04             	sub    $0x4,%esp
  80038f:	68 30 35 80 00       	push   $0x803530
  800394:	6a 4b                	push   $0x4b
  800396:	68 1c 35 80 00       	push   $0x80351c
  80039b:	e8 52 01 00 00       	call   8004f2 <_panic>


	}

	cprintf("Congratulations!! test malloc (2) completed successfully.\n");
  8003a0:	83 ec 0c             	sub    $0xc,%esp
  8003a3:	68 68 35 80 00       	push   $0x803568
  8003a8:	e8 f9 03 00 00       	call   8007a6 <cprintf>
  8003ad:	83 c4 10             	add    $0x10,%esp

	return;
  8003b0:	90                   	nop
}
  8003b1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8003b4:	c9                   	leave  
  8003b5:	c3                   	ret    

008003b6 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8003b6:	55                   	push   %ebp
  8003b7:	89 e5                	mov    %esp,%ebp
  8003b9:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8003bc:	e8 61 1a 00 00       	call   801e22 <sys_getenvindex>
  8003c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8003c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003c7:	89 d0                	mov    %edx,%eax
  8003c9:	c1 e0 03             	shl    $0x3,%eax
  8003cc:	01 d0                	add    %edx,%eax
  8003ce:	01 c0                	add    %eax,%eax
  8003d0:	01 d0                	add    %edx,%eax
  8003d2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003d9:	01 d0                	add    %edx,%eax
  8003db:	c1 e0 04             	shl    $0x4,%eax
  8003de:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003e3:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8003e8:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ed:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8003f3:	84 c0                	test   %al,%al
  8003f5:	74 0f                	je     800406 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8003f7:	a1 20 40 80 00       	mov    0x804020,%eax
  8003fc:	05 5c 05 00 00       	add    $0x55c,%eax
  800401:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800406:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80040a:	7e 0a                	jle    800416 <libmain+0x60>
		binaryname = argv[0];
  80040c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80040f:	8b 00                	mov    (%eax),%eax
  800411:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800416:	83 ec 08             	sub    $0x8,%esp
  800419:	ff 75 0c             	pushl  0xc(%ebp)
  80041c:	ff 75 08             	pushl  0x8(%ebp)
  80041f:	e8 14 fc ff ff       	call   800038 <_main>
  800424:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800427:	e8 03 18 00 00       	call   801c2f <sys_disable_interrupt>
	cprintf("**************************************\n");
  80042c:	83 ec 0c             	sub    $0xc,%esp
  80042f:	68 bc 35 80 00       	push   $0x8035bc
  800434:	e8 6d 03 00 00       	call   8007a6 <cprintf>
  800439:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80043c:	a1 20 40 80 00       	mov    0x804020,%eax
  800441:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800447:	a1 20 40 80 00       	mov    0x804020,%eax
  80044c:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800452:	83 ec 04             	sub    $0x4,%esp
  800455:	52                   	push   %edx
  800456:	50                   	push   %eax
  800457:	68 e4 35 80 00       	push   $0x8035e4
  80045c:	e8 45 03 00 00       	call   8007a6 <cprintf>
  800461:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800464:	a1 20 40 80 00       	mov    0x804020,%eax
  800469:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80046f:	a1 20 40 80 00       	mov    0x804020,%eax
  800474:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80047a:	a1 20 40 80 00       	mov    0x804020,%eax
  80047f:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800485:	51                   	push   %ecx
  800486:	52                   	push   %edx
  800487:	50                   	push   %eax
  800488:	68 0c 36 80 00       	push   $0x80360c
  80048d:	e8 14 03 00 00       	call   8007a6 <cprintf>
  800492:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800495:	a1 20 40 80 00       	mov    0x804020,%eax
  80049a:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8004a0:	83 ec 08             	sub    $0x8,%esp
  8004a3:	50                   	push   %eax
  8004a4:	68 64 36 80 00       	push   $0x803664
  8004a9:	e8 f8 02 00 00       	call   8007a6 <cprintf>
  8004ae:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8004b1:	83 ec 0c             	sub    $0xc,%esp
  8004b4:	68 bc 35 80 00       	push   $0x8035bc
  8004b9:	e8 e8 02 00 00       	call   8007a6 <cprintf>
  8004be:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8004c1:	e8 83 17 00 00       	call   801c49 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8004c6:	e8 19 00 00 00       	call   8004e4 <exit>
}
  8004cb:	90                   	nop
  8004cc:	c9                   	leave  
  8004cd:	c3                   	ret    

008004ce <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8004ce:	55                   	push   %ebp
  8004cf:	89 e5                	mov    %esp,%ebp
  8004d1:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8004d4:	83 ec 0c             	sub    $0xc,%esp
  8004d7:	6a 00                	push   $0x0
  8004d9:	e8 10 19 00 00       	call   801dee <sys_destroy_env>
  8004de:	83 c4 10             	add    $0x10,%esp
}
  8004e1:	90                   	nop
  8004e2:	c9                   	leave  
  8004e3:	c3                   	ret    

008004e4 <exit>:

void
exit(void)
{
  8004e4:	55                   	push   %ebp
  8004e5:	89 e5                	mov    %esp,%ebp
  8004e7:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004ea:	e8 65 19 00 00       	call   801e54 <sys_exit_env>
}
  8004ef:	90                   	nop
  8004f0:	c9                   	leave  
  8004f1:	c3                   	ret    

008004f2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004f2:	55                   	push   %ebp
  8004f3:	89 e5                	mov    %esp,%ebp
  8004f5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004f8:	8d 45 10             	lea    0x10(%ebp),%eax
  8004fb:	83 c0 04             	add    $0x4,%eax
  8004fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800501:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800506:	85 c0                	test   %eax,%eax
  800508:	74 16                	je     800520 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80050a:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80050f:	83 ec 08             	sub    $0x8,%esp
  800512:	50                   	push   %eax
  800513:	68 78 36 80 00       	push   $0x803678
  800518:	e8 89 02 00 00       	call   8007a6 <cprintf>
  80051d:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800520:	a1 00 40 80 00       	mov    0x804000,%eax
  800525:	ff 75 0c             	pushl  0xc(%ebp)
  800528:	ff 75 08             	pushl  0x8(%ebp)
  80052b:	50                   	push   %eax
  80052c:	68 7d 36 80 00       	push   $0x80367d
  800531:	e8 70 02 00 00       	call   8007a6 <cprintf>
  800536:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800539:	8b 45 10             	mov    0x10(%ebp),%eax
  80053c:	83 ec 08             	sub    $0x8,%esp
  80053f:	ff 75 f4             	pushl  -0xc(%ebp)
  800542:	50                   	push   %eax
  800543:	e8 f3 01 00 00       	call   80073b <vcprintf>
  800548:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80054b:	83 ec 08             	sub    $0x8,%esp
  80054e:	6a 00                	push   $0x0
  800550:	68 99 36 80 00       	push   $0x803699
  800555:	e8 e1 01 00 00       	call   80073b <vcprintf>
  80055a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80055d:	e8 82 ff ff ff       	call   8004e4 <exit>

	// should not return here
	while (1) ;
  800562:	eb fe                	jmp    800562 <_panic+0x70>

00800564 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800564:	55                   	push   %ebp
  800565:	89 e5                	mov    %esp,%ebp
  800567:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80056a:	a1 20 40 80 00       	mov    0x804020,%eax
  80056f:	8b 50 74             	mov    0x74(%eax),%edx
  800572:	8b 45 0c             	mov    0xc(%ebp),%eax
  800575:	39 c2                	cmp    %eax,%edx
  800577:	74 14                	je     80058d <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800579:	83 ec 04             	sub    $0x4,%esp
  80057c:	68 9c 36 80 00       	push   $0x80369c
  800581:	6a 26                	push   $0x26
  800583:	68 e8 36 80 00       	push   $0x8036e8
  800588:	e8 65 ff ff ff       	call   8004f2 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80058d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800594:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80059b:	e9 c2 00 00 00       	jmp    800662 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8005a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005a3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ad:	01 d0                	add    %edx,%eax
  8005af:	8b 00                	mov    (%eax),%eax
  8005b1:	85 c0                	test   %eax,%eax
  8005b3:	75 08                	jne    8005bd <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8005b5:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8005b8:	e9 a2 00 00 00       	jmp    80065f <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8005bd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005c4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005cb:	eb 69                	jmp    800636 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8005cd:	a1 20 40 80 00       	mov    0x804020,%eax
  8005d2:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005d8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005db:	89 d0                	mov    %edx,%eax
  8005dd:	01 c0                	add    %eax,%eax
  8005df:	01 d0                	add    %edx,%eax
  8005e1:	c1 e0 03             	shl    $0x3,%eax
  8005e4:	01 c8                	add    %ecx,%eax
  8005e6:	8a 40 04             	mov    0x4(%eax),%al
  8005e9:	84 c0                	test   %al,%al
  8005eb:	75 46                	jne    800633 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005ed:	a1 20 40 80 00       	mov    0x804020,%eax
  8005f2:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005f8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005fb:	89 d0                	mov    %edx,%eax
  8005fd:	01 c0                	add    %eax,%eax
  8005ff:	01 d0                	add    %edx,%eax
  800601:	c1 e0 03             	shl    $0x3,%eax
  800604:	01 c8                	add    %ecx,%eax
  800606:	8b 00                	mov    (%eax),%eax
  800608:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80060b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80060e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800613:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800615:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800618:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80061f:	8b 45 08             	mov    0x8(%ebp),%eax
  800622:	01 c8                	add    %ecx,%eax
  800624:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800626:	39 c2                	cmp    %eax,%edx
  800628:	75 09                	jne    800633 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80062a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800631:	eb 12                	jmp    800645 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800633:	ff 45 e8             	incl   -0x18(%ebp)
  800636:	a1 20 40 80 00       	mov    0x804020,%eax
  80063b:	8b 50 74             	mov    0x74(%eax),%edx
  80063e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800641:	39 c2                	cmp    %eax,%edx
  800643:	77 88                	ja     8005cd <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800645:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800649:	75 14                	jne    80065f <CheckWSWithoutLastIndex+0xfb>
			panic(
  80064b:	83 ec 04             	sub    $0x4,%esp
  80064e:	68 f4 36 80 00       	push   $0x8036f4
  800653:	6a 3a                	push   $0x3a
  800655:	68 e8 36 80 00       	push   $0x8036e8
  80065a:	e8 93 fe ff ff       	call   8004f2 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80065f:	ff 45 f0             	incl   -0x10(%ebp)
  800662:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800665:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800668:	0f 8c 32 ff ff ff    	jl     8005a0 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80066e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800675:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80067c:	eb 26                	jmp    8006a4 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80067e:	a1 20 40 80 00       	mov    0x804020,%eax
  800683:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800689:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80068c:	89 d0                	mov    %edx,%eax
  80068e:	01 c0                	add    %eax,%eax
  800690:	01 d0                	add    %edx,%eax
  800692:	c1 e0 03             	shl    $0x3,%eax
  800695:	01 c8                	add    %ecx,%eax
  800697:	8a 40 04             	mov    0x4(%eax),%al
  80069a:	3c 01                	cmp    $0x1,%al
  80069c:	75 03                	jne    8006a1 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80069e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006a1:	ff 45 e0             	incl   -0x20(%ebp)
  8006a4:	a1 20 40 80 00       	mov    0x804020,%eax
  8006a9:	8b 50 74             	mov    0x74(%eax),%edx
  8006ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006af:	39 c2                	cmp    %eax,%edx
  8006b1:	77 cb                	ja     80067e <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8006b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006b6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8006b9:	74 14                	je     8006cf <CheckWSWithoutLastIndex+0x16b>
		panic(
  8006bb:	83 ec 04             	sub    $0x4,%esp
  8006be:	68 48 37 80 00       	push   $0x803748
  8006c3:	6a 44                	push   $0x44
  8006c5:	68 e8 36 80 00       	push   $0x8036e8
  8006ca:	e8 23 fe ff ff       	call   8004f2 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8006cf:	90                   	nop
  8006d0:	c9                   	leave  
  8006d1:	c3                   	ret    

008006d2 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8006d2:	55                   	push   %ebp
  8006d3:	89 e5                	mov    %esp,%ebp
  8006d5:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8006d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006db:	8b 00                	mov    (%eax),%eax
  8006dd:	8d 48 01             	lea    0x1(%eax),%ecx
  8006e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006e3:	89 0a                	mov    %ecx,(%edx)
  8006e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8006e8:	88 d1                	mov    %dl,%cl
  8006ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006ed:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006f4:	8b 00                	mov    (%eax),%eax
  8006f6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006fb:	75 2c                	jne    800729 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8006fd:	a0 24 40 80 00       	mov    0x804024,%al
  800702:	0f b6 c0             	movzbl %al,%eax
  800705:	8b 55 0c             	mov    0xc(%ebp),%edx
  800708:	8b 12                	mov    (%edx),%edx
  80070a:	89 d1                	mov    %edx,%ecx
  80070c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80070f:	83 c2 08             	add    $0x8,%edx
  800712:	83 ec 04             	sub    $0x4,%esp
  800715:	50                   	push   %eax
  800716:	51                   	push   %ecx
  800717:	52                   	push   %edx
  800718:	e8 64 13 00 00       	call   801a81 <sys_cputs>
  80071d:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800720:	8b 45 0c             	mov    0xc(%ebp),%eax
  800723:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800729:	8b 45 0c             	mov    0xc(%ebp),%eax
  80072c:	8b 40 04             	mov    0x4(%eax),%eax
  80072f:	8d 50 01             	lea    0x1(%eax),%edx
  800732:	8b 45 0c             	mov    0xc(%ebp),%eax
  800735:	89 50 04             	mov    %edx,0x4(%eax)
}
  800738:	90                   	nop
  800739:	c9                   	leave  
  80073a:	c3                   	ret    

0080073b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80073b:	55                   	push   %ebp
  80073c:	89 e5                	mov    %esp,%ebp
  80073e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800744:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80074b:	00 00 00 
	b.cnt = 0;
  80074e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800755:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800758:	ff 75 0c             	pushl  0xc(%ebp)
  80075b:	ff 75 08             	pushl  0x8(%ebp)
  80075e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800764:	50                   	push   %eax
  800765:	68 d2 06 80 00       	push   $0x8006d2
  80076a:	e8 11 02 00 00       	call   800980 <vprintfmt>
  80076f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800772:	a0 24 40 80 00       	mov    0x804024,%al
  800777:	0f b6 c0             	movzbl %al,%eax
  80077a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800780:	83 ec 04             	sub    $0x4,%esp
  800783:	50                   	push   %eax
  800784:	52                   	push   %edx
  800785:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80078b:	83 c0 08             	add    $0x8,%eax
  80078e:	50                   	push   %eax
  80078f:	e8 ed 12 00 00       	call   801a81 <sys_cputs>
  800794:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800797:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80079e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8007a4:	c9                   	leave  
  8007a5:	c3                   	ret    

008007a6 <cprintf>:

int cprintf(const char *fmt, ...) {
  8007a6:	55                   	push   %ebp
  8007a7:	89 e5                	mov    %esp,%ebp
  8007a9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8007ac:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  8007b3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bc:	83 ec 08             	sub    $0x8,%esp
  8007bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8007c2:	50                   	push   %eax
  8007c3:	e8 73 ff ff ff       	call   80073b <vcprintf>
  8007c8:	83 c4 10             	add    $0x10,%esp
  8007cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007d1:	c9                   	leave  
  8007d2:	c3                   	ret    

008007d3 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8007d3:	55                   	push   %ebp
  8007d4:	89 e5                	mov    %esp,%ebp
  8007d6:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007d9:	e8 51 14 00 00       	call   801c2f <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007de:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e7:	83 ec 08             	sub    $0x8,%esp
  8007ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8007ed:	50                   	push   %eax
  8007ee:	e8 48 ff ff ff       	call   80073b <vcprintf>
  8007f3:	83 c4 10             	add    $0x10,%esp
  8007f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007f9:	e8 4b 14 00 00       	call   801c49 <sys_enable_interrupt>
	return cnt;
  8007fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800801:	c9                   	leave  
  800802:	c3                   	ret    

00800803 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800803:	55                   	push   %ebp
  800804:	89 e5                	mov    %esp,%ebp
  800806:	53                   	push   %ebx
  800807:	83 ec 14             	sub    $0x14,%esp
  80080a:	8b 45 10             	mov    0x10(%ebp),%eax
  80080d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800810:	8b 45 14             	mov    0x14(%ebp),%eax
  800813:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800816:	8b 45 18             	mov    0x18(%ebp),%eax
  800819:	ba 00 00 00 00       	mov    $0x0,%edx
  80081e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800821:	77 55                	ja     800878 <printnum+0x75>
  800823:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800826:	72 05                	jb     80082d <printnum+0x2a>
  800828:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80082b:	77 4b                	ja     800878 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80082d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800830:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800833:	8b 45 18             	mov    0x18(%ebp),%eax
  800836:	ba 00 00 00 00       	mov    $0x0,%edx
  80083b:	52                   	push   %edx
  80083c:	50                   	push   %eax
  80083d:	ff 75 f4             	pushl  -0xc(%ebp)
  800840:	ff 75 f0             	pushl  -0x10(%ebp)
  800843:	e8 48 2a 00 00       	call   803290 <__udivdi3>
  800848:	83 c4 10             	add    $0x10,%esp
  80084b:	83 ec 04             	sub    $0x4,%esp
  80084e:	ff 75 20             	pushl  0x20(%ebp)
  800851:	53                   	push   %ebx
  800852:	ff 75 18             	pushl  0x18(%ebp)
  800855:	52                   	push   %edx
  800856:	50                   	push   %eax
  800857:	ff 75 0c             	pushl  0xc(%ebp)
  80085a:	ff 75 08             	pushl  0x8(%ebp)
  80085d:	e8 a1 ff ff ff       	call   800803 <printnum>
  800862:	83 c4 20             	add    $0x20,%esp
  800865:	eb 1a                	jmp    800881 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800867:	83 ec 08             	sub    $0x8,%esp
  80086a:	ff 75 0c             	pushl  0xc(%ebp)
  80086d:	ff 75 20             	pushl  0x20(%ebp)
  800870:	8b 45 08             	mov    0x8(%ebp),%eax
  800873:	ff d0                	call   *%eax
  800875:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800878:	ff 4d 1c             	decl   0x1c(%ebp)
  80087b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80087f:	7f e6                	jg     800867 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800881:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800884:	bb 00 00 00 00       	mov    $0x0,%ebx
  800889:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80088c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80088f:	53                   	push   %ebx
  800890:	51                   	push   %ecx
  800891:	52                   	push   %edx
  800892:	50                   	push   %eax
  800893:	e8 08 2b 00 00       	call   8033a0 <__umoddi3>
  800898:	83 c4 10             	add    $0x10,%esp
  80089b:	05 b4 39 80 00       	add    $0x8039b4,%eax
  8008a0:	8a 00                	mov    (%eax),%al
  8008a2:	0f be c0             	movsbl %al,%eax
  8008a5:	83 ec 08             	sub    $0x8,%esp
  8008a8:	ff 75 0c             	pushl  0xc(%ebp)
  8008ab:	50                   	push   %eax
  8008ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8008af:	ff d0                	call   *%eax
  8008b1:	83 c4 10             	add    $0x10,%esp
}
  8008b4:	90                   	nop
  8008b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008b8:	c9                   	leave  
  8008b9:	c3                   	ret    

008008ba <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008ba:	55                   	push   %ebp
  8008bb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008bd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008c1:	7e 1c                	jle    8008df <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c6:	8b 00                	mov    (%eax),%eax
  8008c8:	8d 50 08             	lea    0x8(%eax),%edx
  8008cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ce:	89 10                	mov    %edx,(%eax)
  8008d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d3:	8b 00                	mov    (%eax),%eax
  8008d5:	83 e8 08             	sub    $0x8,%eax
  8008d8:	8b 50 04             	mov    0x4(%eax),%edx
  8008db:	8b 00                	mov    (%eax),%eax
  8008dd:	eb 40                	jmp    80091f <getuint+0x65>
	else if (lflag)
  8008df:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008e3:	74 1e                	je     800903 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e8:	8b 00                	mov    (%eax),%eax
  8008ea:	8d 50 04             	lea    0x4(%eax),%edx
  8008ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f0:	89 10                	mov    %edx,(%eax)
  8008f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f5:	8b 00                	mov    (%eax),%eax
  8008f7:	83 e8 04             	sub    $0x4,%eax
  8008fa:	8b 00                	mov    (%eax),%eax
  8008fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800901:	eb 1c                	jmp    80091f <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800903:	8b 45 08             	mov    0x8(%ebp),%eax
  800906:	8b 00                	mov    (%eax),%eax
  800908:	8d 50 04             	lea    0x4(%eax),%edx
  80090b:	8b 45 08             	mov    0x8(%ebp),%eax
  80090e:	89 10                	mov    %edx,(%eax)
  800910:	8b 45 08             	mov    0x8(%ebp),%eax
  800913:	8b 00                	mov    (%eax),%eax
  800915:	83 e8 04             	sub    $0x4,%eax
  800918:	8b 00                	mov    (%eax),%eax
  80091a:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80091f:	5d                   	pop    %ebp
  800920:	c3                   	ret    

00800921 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800921:	55                   	push   %ebp
  800922:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800924:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800928:	7e 1c                	jle    800946 <getint+0x25>
		return va_arg(*ap, long long);
  80092a:	8b 45 08             	mov    0x8(%ebp),%eax
  80092d:	8b 00                	mov    (%eax),%eax
  80092f:	8d 50 08             	lea    0x8(%eax),%edx
  800932:	8b 45 08             	mov    0x8(%ebp),%eax
  800935:	89 10                	mov    %edx,(%eax)
  800937:	8b 45 08             	mov    0x8(%ebp),%eax
  80093a:	8b 00                	mov    (%eax),%eax
  80093c:	83 e8 08             	sub    $0x8,%eax
  80093f:	8b 50 04             	mov    0x4(%eax),%edx
  800942:	8b 00                	mov    (%eax),%eax
  800944:	eb 38                	jmp    80097e <getint+0x5d>
	else if (lflag)
  800946:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80094a:	74 1a                	je     800966 <getint+0x45>
		return va_arg(*ap, long);
  80094c:	8b 45 08             	mov    0x8(%ebp),%eax
  80094f:	8b 00                	mov    (%eax),%eax
  800951:	8d 50 04             	lea    0x4(%eax),%edx
  800954:	8b 45 08             	mov    0x8(%ebp),%eax
  800957:	89 10                	mov    %edx,(%eax)
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	8b 00                	mov    (%eax),%eax
  80095e:	83 e8 04             	sub    $0x4,%eax
  800961:	8b 00                	mov    (%eax),%eax
  800963:	99                   	cltd   
  800964:	eb 18                	jmp    80097e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800966:	8b 45 08             	mov    0x8(%ebp),%eax
  800969:	8b 00                	mov    (%eax),%eax
  80096b:	8d 50 04             	lea    0x4(%eax),%edx
  80096e:	8b 45 08             	mov    0x8(%ebp),%eax
  800971:	89 10                	mov    %edx,(%eax)
  800973:	8b 45 08             	mov    0x8(%ebp),%eax
  800976:	8b 00                	mov    (%eax),%eax
  800978:	83 e8 04             	sub    $0x4,%eax
  80097b:	8b 00                	mov    (%eax),%eax
  80097d:	99                   	cltd   
}
  80097e:	5d                   	pop    %ebp
  80097f:	c3                   	ret    

00800980 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800980:	55                   	push   %ebp
  800981:	89 e5                	mov    %esp,%ebp
  800983:	56                   	push   %esi
  800984:	53                   	push   %ebx
  800985:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800988:	eb 17                	jmp    8009a1 <vprintfmt+0x21>
			if (ch == '\0')
  80098a:	85 db                	test   %ebx,%ebx
  80098c:	0f 84 af 03 00 00    	je     800d41 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800992:	83 ec 08             	sub    $0x8,%esp
  800995:	ff 75 0c             	pushl  0xc(%ebp)
  800998:	53                   	push   %ebx
  800999:	8b 45 08             	mov    0x8(%ebp),%eax
  80099c:	ff d0                	call   *%eax
  80099e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a4:	8d 50 01             	lea    0x1(%eax),%edx
  8009a7:	89 55 10             	mov    %edx,0x10(%ebp)
  8009aa:	8a 00                	mov    (%eax),%al
  8009ac:	0f b6 d8             	movzbl %al,%ebx
  8009af:	83 fb 25             	cmp    $0x25,%ebx
  8009b2:	75 d6                	jne    80098a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009b4:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009b8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009bf:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009c6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009cd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8009d7:	8d 50 01             	lea    0x1(%eax),%edx
  8009da:	89 55 10             	mov    %edx,0x10(%ebp)
  8009dd:	8a 00                	mov    (%eax),%al
  8009df:	0f b6 d8             	movzbl %al,%ebx
  8009e2:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009e5:	83 f8 55             	cmp    $0x55,%eax
  8009e8:	0f 87 2b 03 00 00    	ja     800d19 <vprintfmt+0x399>
  8009ee:	8b 04 85 d8 39 80 00 	mov    0x8039d8(,%eax,4),%eax
  8009f5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009f7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009fb:	eb d7                	jmp    8009d4 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009fd:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a01:	eb d1                	jmp    8009d4 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a03:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a0a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a0d:	89 d0                	mov    %edx,%eax
  800a0f:	c1 e0 02             	shl    $0x2,%eax
  800a12:	01 d0                	add    %edx,%eax
  800a14:	01 c0                	add    %eax,%eax
  800a16:	01 d8                	add    %ebx,%eax
  800a18:	83 e8 30             	sub    $0x30,%eax
  800a1b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a1e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a21:	8a 00                	mov    (%eax),%al
  800a23:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a26:	83 fb 2f             	cmp    $0x2f,%ebx
  800a29:	7e 3e                	jle    800a69 <vprintfmt+0xe9>
  800a2b:	83 fb 39             	cmp    $0x39,%ebx
  800a2e:	7f 39                	jg     800a69 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a30:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a33:	eb d5                	jmp    800a0a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a35:	8b 45 14             	mov    0x14(%ebp),%eax
  800a38:	83 c0 04             	add    $0x4,%eax
  800a3b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a41:	83 e8 04             	sub    $0x4,%eax
  800a44:	8b 00                	mov    (%eax),%eax
  800a46:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a49:	eb 1f                	jmp    800a6a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a4b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a4f:	79 83                	jns    8009d4 <vprintfmt+0x54>
				width = 0;
  800a51:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a58:	e9 77 ff ff ff       	jmp    8009d4 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a5d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a64:	e9 6b ff ff ff       	jmp    8009d4 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a69:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a6a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a6e:	0f 89 60 ff ff ff    	jns    8009d4 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a74:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a77:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a7a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a81:	e9 4e ff ff ff       	jmp    8009d4 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a86:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a89:	e9 46 ff ff ff       	jmp    8009d4 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a8e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a91:	83 c0 04             	add    $0x4,%eax
  800a94:	89 45 14             	mov    %eax,0x14(%ebp)
  800a97:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9a:	83 e8 04             	sub    $0x4,%eax
  800a9d:	8b 00                	mov    (%eax),%eax
  800a9f:	83 ec 08             	sub    $0x8,%esp
  800aa2:	ff 75 0c             	pushl  0xc(%ebp)
  800aa5:	50                   	push   %eax
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	ff d0                	call   *%eax
  800aab:	83 c4 10             	add    $0x10,%esp
			break;
  800aae:	e9 89 02 00 00       	jmp    800d3c <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ab3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab6:	83 c0 04             	add    $0x4,%eax
  800ab9:	89 45 14             	mov    %eax,0x14(%ebp)
  800abc:	8b 45 14             	mov    0x14(%ebp),%eax
  800abf:	83 e8 04             	sub    $0x4,%eax
  800ac2:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ac4:	85 db                	test   %ebx,%ebx
  800ac6:	79 02                	jns    800aca <vprintfmt+0x14a>
				err = -err;
  800ac8:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800aca:	83 fb 64             	cmp    $0x64,%ebx
  800acd:	7f 0b                	jg     800ada <vprintfmt+0x15a>
  800acf:	8b 34 9d 20 38 80 00 	mov    0x803820(,%ebx,4),%esi
  800ad6:	85 f6                	test   %esi,%esi
  800ad8:	75 19                	jne    800af3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ada:	53                   	push   %ebx
  800adb:	68 c5 39 80 00       	push   $0x8039c5
  800ae0:	ff 75 0c             	pushl  0xc(%ebp)
  800ae3:	ff 75 08             	pushl  0x8(%ebp)
  800ae6:	e8 5e 02 00 00       	call   800d49 <printfmt>
  800aeb:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800aee:	e9 49 02 00 00       	jmp    800d3c <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800af3:	56                   	push   %esi
  800af4:	68 ce 39 80 00       	push   $0x8039ce
  800af9:	ff 75 0c             	pushl  0xc(%ebp)
  800afc:	ff 75 08             	pushl  0x8(%ebp)
  800aff:	e8 45 02 00 00       	call   800d49 <printfmt>
  800b04:	83 c4 10             	add    $0x10,%esp
			break;
  800b07:	e9 30 02 00 00       	jmp    800d3c <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b0c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0f:	83 c0 04             	add    $0x4,%eax
  800b12:	89 45 14             	mov    %eax,0x14(%ebp)
  800b15:	8b 45 14             	mov    0x14(%ebp),%eax
  800b18:	83 e8 04             	sub    $0x4,%eax
  800b1b:	8b 30                	mov    (%eax),%esi
  800b1d:	85 f6                	test   %esi,%esi
  800b1f:	75 05                	jne    800b26 <vprintfmt+0x1a6>
				p = "(null)";
  800b21:	be d1 39 80 00       	mov    $0x8039d1,%esi
			if (width > 0 && padc != '-')
  800b26:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b2a:	7e 6d                	jle    800b99 <vprintfmt+0x219>
  800b2c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b30:	74 67                	je     800b99 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b32:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b35:	83 ec 08             	sub    $0x8,%esp
  800b38:	50                   	push   %eax
  800b39:	56                   	push   %esi
  800b3a:	e8 0c 03 00 00       	call   800e4b <strnlen>
  800b3f:	83 c4 10             	add    $0x10,%esp
  800b42:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b45:	eb 16                	jmp    800b5d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b47:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b4b:	83 ec 08             	sub    $0x8,%esp
  800b4e:	ff 75 0c             	pushl  0xc(%ebp)
  800b51:	50                   	push   %eax
  800b52:	8b 45 08             	mov    0x8(%ebp),%eax
  800b55:	ff d0                	call   *%eax
  800b57:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b5a:	ff 4d e4             	decl   -0x1c(%ebp)
  800b5d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b61:	7f e4                	jg     800b47 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b63:	eb 34                	jmp    800b99 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b65:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b69:	74 1c                	je     800b87 <vprintfmt+0x207>
  800b6b:	83 fb 1f             	cmp    $0x1f,%ebx
  800b6e:	7e 05                	jle    800b75 <vprintfmt+0x1f5>
  800b70:	83 fb 7e             	cmp    $0x7e,%ebx
  800b73:	7e 12                	jle    800b87 <vprintfmt+0x207>
					putch('?', putdat);
  800b75:	83 ec 08             	sub    $0x8,%esp
  800b78:	ff 75 0c             	pushl  0xc(%ebp)
  800b7b:	6a 3f                	push   $0x3f
  800b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b80:	ff d0                	call   *%eax
  800b82:	83 c4 10             	add    $0x10,%esp
  800b85:	eb 0f                	jmp    800b96 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b87:	83 ec 08             	sub    $0x8,%esp
  800b8a:	ff 75 0c             	pushl  0xc(%ebp)
  800b8d:	53                   	push   %ebx
  800b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b91:	ff d0                	call   *%eax
  800b93:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b96:	ff 4d e4             	decl   -0x1c(%ebp)
  800b99:	89 f0                	mov    %esi,%eax
  800b9b:	8d 70 01             	lea    0x1(%eax),%esi
  800b9e:	8a 00                	mov    (%eax),%al
  800ba0:	0f be d8             	movsbl %al,%ebx
  800ba3:	85 db                	test   %ebx,%ebx
  800ba5:	74 24                	je     800bcb <vprintfmt+0x24b>
  800ba7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bab:	78 b8                	js     800b65 <vprintfmt+0x1e5>
  800bad:	ff 4d e0             	decl   -0x20(%ebp)
  800bb0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bb4:	79 af                	jns    800b65 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bb6:	eb 13                	jmp    800bcb <vprintfmt+0x24b>
				putch(' ', putdat);
  800bb8:	83 ec 08             	sub    $0x8,%esp
  800bbb:	ff 75 0c             	pushl  0xc(%ebp)
  800bbe:	6a 20                	push   $0x20
  800bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc3:	ff d0                	call   *%eax
  800bc5:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bc8:	ff 4d e4             	decl   -0x1c(%ebp)
  800bcb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bcf:	7f e7                	jg     800bb8 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bd1:	e9 66 01 00 00       	jmp    800d3c <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bd6:	83 ec 08             	sub    $0x8,%esp
  800bd9:	ff 75 e8             	pushl  -0x18(%ebp)
  800bdc:	8d 45 14             	lea    0x14(%ebp),%eax
  800bdf:	50                   	push   %eax
  800be0:	e8 3c fd ff ff       	call   800921 <getint>
  800be5:	83 c4 10             	add    $0x10,%esp
  800be8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800beb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bf1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bf4:	85 d2                	test   %edx,%edx
  800bf6:	79 23                	jns    800c1b <vprintfmt+0x29b>
				putch('-', putdat);
  800bf8:	83 ec 08             	sub    $0x8,%esp
  800bfb:	ff 75 0c             	pushl  0xc(%ebp)
  800bfe:	6a 2d                	push   $0x2d
  800c00:	8b 45 08             	mov    0x8(%ebp),%eax
  800c03:	ff d0                	call   *%eax
  800c05:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c0e:	f7 d8                	neg    %eax
  800c10:	83 d2 00             	adc    $0x0,%edx
  800c13:	f7 da                	neg    %edx
  800c15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c18:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c1b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c22:	e9 bc 00 00 00       	jmp    800ce3 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c27:	83 ec 08             	sub    $0x8,%esp
  800c2a:	ff 75 e8             	pushl  -0x18(%ebp)
  800c2d:	8d 45 14             	lea    0x14(%ebp),%eax
  800c30:	50                   	push   %eax
  800c31:	e8 84 fc ff ff       	call   8008ba <getuint>
  800c36:	83 c4 10             	add    $0x10,%esp
  800c39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c3c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c3f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c46:	e9 98 00 00 00       	jmp    800ce3 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c4b:	83 ec 08             	sub    $0x8,%esp
  800c4e:	ff 75 0c             	pushl  0xc(%ebp)
  800c51:	6a 58                	push   $0x58
  800c53:	8b 45 08             	mov    0x8(%ebp),%eax
  800c56:	ff d0                	call   *%eax
  800c58:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c5b:	83 ec 08             	sub    $0x8,%esp
  800c5e:	ff 75 0c             	pushl  0xc(%ebp)
  800c61:	6a 58                	push   $0x58
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	ff d0                	call   *%eax
  800c68:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c6b:	83 ec 08             	sub    $0x8,%esp
  800c6e:	ff 75 0c             	pushl  0xc(%ebp)
  800c71:	6a 58                	push   $0x58
  800c73:	8b 45 08             	mov    0x8(%ebp),%eax
  800c76:	ff d0                	call   *%eax
  800c78:	83 c4 10             	add    $0x10,%esp
			break;
  800c7b:	e9 bc 00 00 00       	jmp    800d3c <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c80:	83 ec 08             	sub    $0x8,%esp
  800c83:	ff 75 0c             	pushl  0xc(%ebp)
  800c86:	6a 30                	push   $0x30
  800c88:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8b:	ff d0                	call   *%eax
  800c8d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c90:	83 ec 08             	sub    $0x8,%esp
  800c93:	ff 75 0c             	pushl  0xc(%ebp)
  800c96:	6a 78                	push   $0x78
  800c98:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9b:	ff d0                	call   *%eax
  800c9d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ca0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca3:	83 c0 04             	add    $0x4,%eax
  800ca6:	89 45 14             	mov    %eax,0x14(%ebp)
  800ca9:	8b 45 14             	mov    0x14(%ebp),%eax
  800cac:	83 e8 04             	sub    $0x4,%eax
  800caf:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cb4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cbb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cc2:	eb 1f                	jmp    800ce3 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cc4:	83 ec 08             	sub    $0x8,%esp
  800cc7:	ff 75 e8             	pushl  -0x18(%ebp)
  800cca:	8d 45 14             	lea    0x14(%ebp),%eax
  800ccd:	50                   	push   %eax
  800cce:	e8 e7 fb ff ff       	call   8008ba <getuint>
  800cd3:	83 c4 10             	add    $0x10,%esp
  800cd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cd9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cdc:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ce3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ce7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cea:	83 ec 04             	sub    $0x4,%esp
  800ced:	52                   	push   %edx
  800cee:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cf1:	50                   	push   %eax
  800cf2:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf5:	ff 75 f0             	pushl  -0x10(%ebp)
  800cf8:	ff 75 0c             	pushl  0xc(%ebp)
  800cfb:	ff 75 08             	pushl  0x8(%ebp)
  800cfe:	e8 00 fb ff ff       	call   800803 <printnum>
  800d03:	83 c4 20             	add    $0x20,%esp
			break;
  800d06:	eb 34                	jmp    800d3c <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d08:	83 ec 08             	sub    $0x8,%esp
  800d0b:	ff 75 0c             	pushl  0xc(%ebp)
  800d0e:	53                   	push   %ebx
  800d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d12:	ff d0                	call   *%eax
  800d14:	83 c4 10             	add    $0x10,%esp
			break;
  800d17:	eb 23                	jmp    800d3c <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d19:	83 ec 08             	sub    $0x8,%esp
  800d1c:	ff 75 0c             	pushl  0xc(%ebp)
  800d1f:	6a 25                	push   $0x25
  800d21:	8b 45 08             	mov    0x8(%ebp),%eax
  800d24:	ff d0                	call   *%eax
  800d26:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d29:	ff 4d 10             	decl   0x10(%ebp)
  800d2c:	eb 03                	jmp    800d31 <vprintfmt+0x3b1>
  800d2e:	ff 4d 10             	decl   0x10(%ebp)
  800d31:	8b 45 10             	mov    0x10(%ebp),%eax
  800d34:	48                   	dec    %eax
  800d35:	8a 00                	mov    (%eax),%al
  800d37:	3c 25                	cmp    $0x25,%al
  800d39:	75 f3                	jne    800d2e <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d3b:	90                   	nop
		}
	}
  800d3c:	e9 47 fc ff ff       	jmp    800988 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d41:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d42:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d45:	5b                   	pop    %ebx
  800d46:	5e                   	pop    %esi
  800d47:	5d                   	pop    %ebp
  800d48:	c3                   	ret    

00800d49 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d49:	55                   	push   %ebp
  800d4a:	89 e5                	mov    %esp,%ebp
  800d4c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d4f:	8d 45 10             	lea    0x10(%ebp),%eax
  800d52:	83 c0 04             	add    $0x4,%eax
  800d55:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d58:	8b 45 10             	mov    0x10(%ebp),%eax
  800d5b:	ff 75 f4             	pushl  -0xc(%ebp)
  800d5e:	50                   	push   %eax
  800d5f:	ff 75 0c             	pushl  0xc(%ebp)
  800d62:	ff 75 08             	pushl  0x8(%ebp)
  800d65:	e8 16 fc ff ff       	call   800980 <vprintfmt>
  800d6a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d6d:	90                   	nop
  800d6e:	c9                   	leave  
  800d6f:	c3                   	ret    

00800d70 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d70:	55                   	push   %ebp
  800d71:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d76:	8b 40 08             	mov    0x8(%eax),%eax
  800d79:	8d 50 01             	lea    0x1(%eax),%edx
  800d7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d85:	8b 10                	mov    (%eax),%edx
  800d87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8a:	8b 40 04             	mov    0x4(%eax),%eax
  800d8d:	39 c2                	cmp    %eax,%edx
  800d8f:	73 12                	jae    800da3 <sprintputch+0x33>
		*b->buf++ = ch;
  800d91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d94:	8b 00                	mov    (%eax),%eax
  800d96:	8d 48 01             	lea    0x1(%eax),%ecx
  800d99:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d9c:	89 0a                	mov    %ecx,(%edx)
  800d9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800da1:	88 10                	mov    %dl,(%eax)
}
  800da3:	90                   	nop
  800da4:	5d                   	pop    %ebp
  800da5:	c3                   	ret    

00800da6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800da6:	55                   	push   %ebp
  800da7:	89 e5                	mov    %esp,%ebp
  800da9:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dac:	8b 45 08             	mov    0x8(%ebp),%eax
  800daf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800db2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800db8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbb:	01 d0                	add    %edx,%eax
  800dbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dc0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dc7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dcb:	74 06                	je     800dd3 <vsnprintf+0x2d>
  800dcd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dd1:	7f 07                	jg     800dda <vsnprintf+0x34>
		return -E_INVAL;
  800dd3:	b8 03 00 00 00       	mov    $0x3,%eax
  800dd8:	eb 20                	jmp    800dfa <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dda:	ff 75 14             	pushl  0x14(%ebp)
  800ddd:	ff 75 10             	pushl  0x10(%ebp)
  800de0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800de3:	50                   	push   %eax
  800de4:	68 70 0d 80 00       	push   $0x800d70
  800de9:	e8 92 fb ff ff       	call   800980 <vprintfmt>
  800dee:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800df1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800df4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800dfa:	c9                   	leave  
  800dfb:	c3                   	ret    

00800dfc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800dfc:	55                   	push   %ebp
  800dfd:	89 e5                	mov    %esp,%ebp
  800dff:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e02:	8d 45 10             	lea    0x10(%ebp),%eax
  800e05:	83 c0 04             	add    $0x4,%eax
  800e08:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e0b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0e:	ff 75 f4             	pushl  -0xc(%ebp)
  800e11:	50                   	push   %eax
  800e12:	ff 75 0c             	pushl  0xc(%ebp)
  800e15:	ff 75 08             	pushl  0x8(%ebp)
  800e18:	e8 89 ff ff ff       	call   800da6 <vsnprintf>
  800e1d:	83 c4 10             	add    $0x10,%esp
  800e20:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e23:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e26:	c9                   	leave  
  800e27:	c3                   	ret    

00800e28 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e28:	55                   	push   %ebp
  800e29:	89 e5                	mov    %esp,%ebp
  800e2b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e2e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e35:	eb 06                	jmp    800e3d <strlen+0x15>
		n++;
  800e37:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e3a:	ff 45 08             	incl   0x8(%ebp)
  800e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e40:	8a 00                	mov    (%eax),%al
  800e42:	84 c0                	test   %al,%al
  800e44:	75 f1                	jne    800e37 <strlen+0xf>
		n++;
	return n;
  800e46:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e49:	c9                   	leave  
  800e4a:	c3                   	ret    

00800e4b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e4b:	55                   	push   %ebp
  800e4c:	89 e5                	mov    %esp,%ebp
  800e4e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e51:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e58:	eb 09                	jmp    800e63 <strnlen+0x18>
		n++;
  800e5a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e5d:	ff 45 08             	incl   0x8(%ebp)
  800e60:	ff 4d 0c             	decl   0xc(%ebp)
  800e63:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e67:	74 09                	je     800e72 <strnlen+0x27>
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6c:	8a 00                	mov    (%eax),%al
  800e6e:	84 c0                	test   %al,%al
  800e70:	75 e8                	jne    800e5a <strnlen+0xf>
		n++;
	return n;
  800e72:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e75:	c9                   	leave  
  800e76:	c3                   	ret    

00800e77 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e77:	55                   	push   %ebp
  800e78:	89 e5                	mov    %esp,%ebp
  800e7a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e80:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e83:	90                   	nop
  800e84:	8b 45 08             	mov    0x8(%ebp),%eax
  800e87:	8d 50 01             	lea    0x1(%eax),%edx
  800e8a:	89 55 08             	mov    %edx,0x8(%ebp)
  800e8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e90:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e93:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e96:	8a 12                	mov    (%edx),%dl
  800e98:	88 10                	mov    %dl,(%eax)
  800e9a:	8a 00                	mov    (%eax),%al
  800e9c:	84 c0                	test   %al,%al
  800e9e:	75 e4                	jne    800e84 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ea0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ea3:	c9                   	leave  
  800ea4:	c3                   	ret    

00800ea5 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ea5:	55                   	push   %ebp
  800ea6:	89 e5                	mov    %esp,%ebp
  800ea8:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800eab:	8b 45 08             	mov    0x8(%ebp),%eax
  800eae:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800eb1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800eb8:	eb 1f                	jmp    800ed9 <strncpy+0x34>
		*dst++ = *src;
  800eba:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebd:	8d 50 01             	lea    0x1(%eax),%edx
  800ec0:	89 55 08             	mov    %edx,0x8(%ebp)
  800ec3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ec6:	8a 12                	mov    (%edx),%dl
  800ec8:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800eca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecd:	8a 00                	mov    (%eax),%al
  800ecf:	84 c0                	test   %al,%al
  800ed1:	74 03                	je     800ed6 <strncpy+0x31>
			src++;
  800ed3:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ed6:	ff 45 fc             	incl   -0x4(%ebp)
  800ed9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800edc:	3b 45 10             	cmp    0x10(%ebp),%eax
  800edf:	72 d9                	jb     800eba <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ee1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ee4:	c9                   	leave  
  800ee5:	c3                   	ret    

00800ee6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ee6:	55                   	push   %ebp
  800ee7:	89 e5                	mov    %esp,%ebp
  800ee9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
  800eef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ef2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ef6:	74 30                	je     800f28 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ef8:	eb 16                	jmp    800f10 <strlcpy+0x2a>
			*dst++ = *src++;
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	8d 50 01             	lea    0x1(%eax),%edx
  800f00:	89 55 08             	mov    %edx,0x8(%ebp)
  800f03:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f06:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f09:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f0c:	8a 12                	mov    (%edx),%dl
  800f0e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f10:	ff 4d 10             	decl   0x10(%ebp)
  800f13:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f17:	74 09                	je     800f22 <strlcpy+0x3c>
  800f19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1c:	8a 00                	mov    (%eax),%al
  800f1e:	84 c0                	test   %al,%al
  800f20:	75 d8                	jne    800efa <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f22:	8b 45 08             	mov    0x8(%ebp),%eax
  800f25:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f28:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f2e:	29 c2                	sub    %eax,%edx
  800f30:	89 d0                	mov    %edx,%eax
}
  800f32:	c9                   	leave  
  800f33:	c3                   	ret    

00800f34 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f34:	55                   	push   %ebp
  800f35:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f37:	eb 06                	jmp    800f3f <strcmp+0xb>
		p++, q++;
  800f39:	ff 45 08             	incl   0x8(%ebp)
  800f3c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f42:	8a 00                	mov    (%eax),%al
  800f44:	84 c0                	test   %al,%al
  800f46:	74 0e                	je     800f56 <strcmp+0x22>
  800f48:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4b:	8a 10                	mov    (%eax),%dl
  800f4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f50:	8a 00                	mov    (%eax),%al
  800f52:	38 c2                	cmp    %al,%dl
  800f54:	74 e3                	je     800f39 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f56:	8b 45 08             	mov    0x8(%ebp),%eax
  800f59:	8a 00                	mov    (%eax),%al
  800f5b:	0f b6 d0             	movzbl %al,%edx
  800f5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f61:	8a 00                	mov    (%eax),%al
  800f63:	0f b6 c0             	movzbl %al,%eax
  800f66:	29 c2                	sub    %eax,%edx
  800f68:	89 d0                	mov    %edx,%eax
}
  800f6a:	5d                   	pop    %ebp
  800f6b:	c3                   	ret    

00800f6c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f6c:	55                   	push   %ebp
  800f6d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f6f:	eb 09                	jmp    800f7a <strncmp+0xe>
		n--, p++, q++;
  800f71:	ff 4d 10             	decl   0x10(%ebp)
  800f74:	ff 45 08             	incl   0x8(%ebp)
  800f77:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f7a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7e:	74 17                	je     800f97 <strncmp+0x2b>
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
  800f83:	8a 00                	mov    (%eax),%al
  800f85:	84 c0                	test   %al,%al
  800f87:	74 0e                	je     800f97 <strncmp+0x2b>
  800f89:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8c:	8a 10                	mov    (%eax),%dl
  800f8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f91:	8a 00                	mov    (%eax),%al
  800f93:	38 c2                	cmp    %al,%dl
  800f95:	74 da                	je     800f71 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f97:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f9b:	75 07                	jne    800fa4 <strncmp+0x38>
		return 0;
  800f9d:	b8 00 00 00 00       	mov    $0x0,%eax
  800fa2:	eb 14                	jmp    800fb8 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	0f b6 d0             	movzbl %al,%edx
  800fac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	0f b6 c0             	movzbl %al,%eax
  800fb4:	29 c2                	sub    %eax,%edx
  800fb6:	89 d0                	mov    %edx,%eax
}
  800fb8:	5d                   	pop    %ebp
  800fb9:	c3                   	ret    

00800fba <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fba:	55                   	push   %ebp
  800fbb:	89 e5                	mov    %esp,%ebp
  800fbd:	83 ec 04             	sub    $0x4,%esp
  800fc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fc6:	eb 12                	jmp    800fda <strchr+0x20>
		if (*s == c)
  800fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcb:	8a 00                	mov    (%eax),%al
  800fcd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fd0:	75 05                	jne    800fd7 <strchr+0x1d>
			return (char *) s;
  800fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd5:	eb 11                	jmp    800fe8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fd7:	ff 45 08             	incl   0x8(%ebp)
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	8a 00                	mov    (%eax),%al
  800fdf:	84 c0                	test   %al,%al
  800fe1:	75 e5                	jne    800fc8 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fe3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fe8:	c9                   	leave  
  800fe9:	c3                   	ret    

00800fea <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fea:	55                   	push   %ebp
  800feb:	89 e5                	mov    %esp,%ebp
  800fed:	83 ec 04             	sub    $0x4,%esp
  800ff0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ff6:	eb 0d                	jmp    801005 <strfind+0x1b>
		if (*s == c)
  800ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffb:	8a 00                	mov    (%eax),%al
  800ffd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801000:	74 0e                	je     801010 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801002:	ff 45 08             	incl   0x8(%ebp)
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	8a 00                	mov    (%eax),%al
  80100a:	84 c0                	test   %al,%al
  80100c:	75 ea                	jne    800ff8 <strfind+0xe>
  80100e:	eb 01                	jmp    801011 <strfind+0x27>
		if (*s == c)
			break;
  801010:	90                   	nop
	return (char *) s;
  801011:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801014:	c9                   	leave  
  801015:	c3                   	ret    

00801016 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801016:	55                   	push   %ebp
  801017:	89 e5                	mov    %esp,%ebp
  801019:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80101c:	8b 45 08             	mov    0x8(%ebp),%eax
  80101f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801022:	8b 45 10             	mov    0x10(%ebp),%eax
  801025:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801028:	eb 0e                	jmp    801038 <memset+0x22>
		*p++ = c;
  80102a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80102d:	8d 50 01             	lea    0x1(%eax),%edx
  801030:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801033:	8b 55 0c             	mov    0xc(%ebp),%edx
  801036:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801038:	ff 4d f8             	decl   -0x8(%ebp)
  80103b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80103f:	79 e9                	jns    80102a <memset+0x14>
		*p++ = c;

	return v;
  801041:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801044:	c9                   	leave  
  801045:	c3                   	ret    

00801046 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801046:	55                   	push   %ebp
  801047:	89 e5                	mov    %esp,%ebp
  801049:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80104c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801052:	8b 45 08             	mov    0x8(%ebp),%eax
  801055:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801058:	eb 16                	jmp    801070 <memcpy+0x2a>
		*d++ = *s++;
  80105a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80105d:	8d 50 01             	lea    0x1(%eax),%edx
  801060:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801063:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801066:	8d 4a 01             	lea    0x1(%edx),%ecx
  801069:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80106c:	8a 12                	mov    (%edx),%dl
  80106e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801070:	8b 45 10             	mov    0x10(%ebp),%eax
  801073:	8d 50 ff             	lea    -0x1(%eax),%edx
  801076:	89 55 10             	mov    %edx,0x10(%ebp)
  801079:	85 c0                	test   %eax,%eax
  80107b:	75 dd                	jne    80105a <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801080:	c9                   	leave  
  801081:	c3                   	ret    

00801082 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801082:	55                   	push   %ebp
  801083:	89 e5                	mov    %esp,%ebp
  801085:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801088:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80108e:	8b 45 08             	mov    0x8(%ebp),%eax
  801091:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801094:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801097:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80109a:	73 50                	jae    8010ec <memmove+0x6a>
  80109c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80109f:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a2:	01 d0                	add    %edx,%eax
  8010a4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010a7:	76 43                	jbe    8010ec <memmove+0x6a>
		s += n;
  8010a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ac:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8010af:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b2:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010b5:	eb 10                	jmp    8010c7 <memmove+0x45>
			*--d = *--s;
  8010b7:	ff 4d f8             	decl   -0x8(%ebp)
  8010ba:	ff 4d fc             	decl   -0x4(%ebp)
  8010bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c0:	8a 10                	mov    (%eax),%dl
  8010c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c5:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8010c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ca:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010cd:	89 55 10             	mov    %edx,0x10(%ebp)
  8010d0:	85 c0                	test   %eax,%eax
  8010d2:	75 e3                	jne    8010b7 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010d4:	eb 23                	jmp    8010f9 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d9:	8d 50 01             	lea    0x1(%eax),%edx
  8010dc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010df:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010e2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010e5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010e8:	8a 12                	mov    (%edx),%dl
  8010ea:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ef:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010f2:	89 55 10             	mov    %edx,0x10(%ebp)
  8010f5:	85 c0                	test   %eax,%eax
  8010f7:	75 dd                	jne    8010d6 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010f9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010fc:	c9                   	leave  
  8010fd:	c3                   	ret    

008010fe <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010fe:	55                   	push   %ebp
  8010ff:	89 e5                	mov    %esp,%ebp
  801101:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801104:	8b 45 08             	mov    0x8(%ebp),%eax
  801107:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80110a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801110:	eb 2a                	jmp    80113c <memcmp+0x3e>
		if (*s1 != *s2)
  801112:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801115:	8a 10                	mov    (%eax),%dl
  801117:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80111a:	8a 00                	mov    (%eax),%al
  80111c:	38 c2                	cmp    %al,%dl
  80111e:	74 16                	je     801136 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801120:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801123:	8a 00                	mov    (%eax),%al
  801125:	0f b6 d0             	movzbl %al,%edx
  801128:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80112b:	8a 00                	mov    (%eax),%al
  80112d:	0f b6 c0             	movzbl %al,%eax
  801130:	29 c2                	sub    %eax,%edx
  801132:	89 d0                	mov    %edx,%eax
  801134:	eb 18                	jmp    80114e <memcmp+0x50>
		s1++, s2++;
  801136:	ff 45 fc             	incl   -0x4(%ebp)
  801139:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80113c:	8b 45 10             	mov    0x10(%ebp),%eax
  80113f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801142:	89 55 10             	mov    %edx,0x10(%ebp)
  801145:	85 c0                	test   %eax,%eax
  801147:	75 c9                	jne    801112 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801149:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80114e:	c9                   	leave  
  80114f:	c3                   	ret    

00801150 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801150:	55                   	push   %ebp
  801151:	89 e5                	mov    %esp,%ebp
  801153:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801156:	8b 55 08             	mov    0x8(%ebp),%edx
  801159:	8b 45 10             	mov    0x10(%ebp),%eax
  80115c:	01 d0                	add    %edx,%eax
  80115e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801161:	eb 15                	jmp    801178 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801163:	8b 45 08             	mov    0x8(%ebp),%eax
  801166:	8a 00                	mov    (%eax),%al
  801168:	0f b6 d0             	movzbl %al,%edx
  80116b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116e:	0f b6 c0             	movzbl %al,%eax
  801171:	39 c2                	cmp    %eax,%edx
  801173:	74 0d                	je     801182 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801175:	ff 45 08             	incl   0x8(%ebp)
  801178:	8b 45 08             	mov    0x8(%ebp),%eax
  80117b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80117e:	72 e3                	jb     801163 <memfind+0x13>
  801180:	eb 01                	jmp    801183 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801182:	90                   	nop
	return (void *) s;
  801183:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801186:	c9                   	leave  
  801187:	c3                   	ret    

00801188 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801188:	55                   	push   %ebp
  801189:	89 e5                	mov    %esp,%ebp
  80118b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80118e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801195:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80119c:	eb 03                	jmp    8011a1 <strtol+0x19>
		s++;
  80119e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a4:	8a 00                	mov    (%eax),%al
  8011a6:	3c 20                	cmp    $0x20,%al
  8011a8:	74 f4                	je     80119e <strtol+0x16>
  8011aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ad:	8a 00                	mov    (%eax),%al
  8011af:	3c 09                	cmp    $0x9,%al
  8011b1:	74 eb                	je     80119e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8011b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b6:	8a 00                	mov    (%eax),%al
  8011b8:	3c 2b                	cmp    $0x2b,%al
  8011ba:	75 05                	jne    8011c1 <strtol+0x39>
		s++;
  8011bc:	ff 45 08             	incl   0x8(%ebp)
  8011bf:	eb 13                	jmp    8011d4 <strtol+0x4c>
	else if (*s == '-')
  8011c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c4:	8a 00                	mov    (%eax),%al
  8011c6:	3c 2d                	cmp    $0x2d,%al
  8011c8:	75 0a                	jne    8011d4 <strtol+0x4c>
		s++, neg = 1;
  8011ca:	ff 45 08             	incl   0x8(%ebp)
  8011cd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011d4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011d8:	74 06                	je     8011e0 <strtol+0x58>
  8011da:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011de:	75 20                	jne    801200 <strtol+0x78>
  8011e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e3:	8a 00                	mov    (%eax),%al
  8011e5:	3c 30                	cmp    $0x30,%al
  8011e7:	75 17                	jne    801200 <strtol+0x78>
  8011e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ec:	40                   	inc    %eax
  8011ed:	8a 00                	mov    (%eax),%al
  8011ef:	3c 78                	cmp    $0x78,%al
  8011f1:	75 0d                	jne    801200 <strtol+0x78>
		s += 2, base = 16;
  8011f3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011f7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011fe:	eb 28                	jmp    801228 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801200:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801204:	75 15                	jne    80121b <strtol+0x93>
  801206:	8b 45 08             	mov    0x8(%ebp),%eax
  801209:	8a 00                	mov    (%eax),%al
  80120b:	3c 30                	cmp    $0x30,%al
  80120d:	75 0c                	jne    80121b <strtol+0x93>
		s++, base = 8;
  80120f:	ff 45 08             	incl   0x8(%ebp)
  801212:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801219:	eb 0d                	jmp    801228 <strtol+0xa0>
	else if (base == 0)
  80121b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80121f:	75 07                	jne    801228 <strtol+0xa0>
		base = 10;
  801221:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801228:	8b 45 08             	mov    0x8(%ebp),%eax
  80122b:	8a 00                	mov    (%eax),%al
  80122d:	3c 2f                	cmp    $0x2f,%al
  80122f:	7e 19                	jle    80124a <strtol+0xc2>
  801231:	8b 45 08             	mov    0x8(%ebp),%eax
  801234:	8a 00                	mov    (%eax),%al
  801236:	3c 39                	cmp    $0x39,%al
  801238:	7f 10                	jg     80124a <strtol+0xc2>
			dig = *s - '0';
  80123a:	8b 45 08             	mov    0x8(%ebp),%eax
  80123d:	8a 00                	mov    (%eax),%al
  80123f:	0f be c0             	movsbl %al,%eax
  801242:	83 e8 30             	sub    $0x30,%eax
  801245:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801248:	eb 42                	jmp    80128c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80124a:	8b 45 08             	mov    0x8(%ebp),%eax
  80124d:	8a 00                	mov    (%eax),%al
  80124f:	3c 60                	cmp    $0x60,%al
  801251:	7e 19                	jle    80126c <strtol+0xe4>
  801253:	8b 45 08             	mov    0x8(%ebp),%eax
  801256:	8a 00                	mov    (%eax),%al
  801258:	3c 7a                	cmp    $0x7a,%al
  80125a:	7f 10                	jg     80126c <strtol+0xe4>
			dig = *s - 'a' + 10;
  80125c:	8b 45 08             	mov    0x8(%ebp),%eax
  80125f:	8a 00                	mov    (%eax),%al
  801261:	0f be c0             	movsbl %al,%eax
  801264:	83 e8 57             	sub    $0x57,%eax
  801267:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80126a:	eb 20                	jmp    80128c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
  80126f:	8a 00                	mov    (%eax),%al
  801271:	3c 40                	cmp    $0x40,%al
  801273:	7e 39                	jle    8012ae <strtol+0x126>
  801275:	8b 45 08             	mov    0x8(%ebp),%eax
  801278:	8a 00                	mov    (%eax),%al
  80127a:	3c 5a                	cmp    $0x5a,%al
  80127c:	7f 30                	jg     8012ae <strtol+0x126>
			dig = *s - 'A' + 10;
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
  801281:	8a 00                	mov    (%eax),%al
  801283:	0f be c0             	movsbl %al,%eax
  801286:	83 e8 37             	sub    $0x37,%eax
  801289:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80128c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80128f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801292:	7d 19                	jge    8012ad <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801294:	ff 45 08             	incl   0x8(%ebp)
  801297:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80129a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80129e:	89 c2                	mov    %eax,%edx
  8012a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012a3:	01 d0                	add    %edx,%eax
  8012a5:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8012a8:	e9 7b ff ff ff       	jmp    801228 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8012ad:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8012ae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012b2:	74 08                	je     8012bc <strtol+0x134>
		*endptr = (char *) s;
  8012b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8012ba:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8012bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012c0:	74 07                	je     8012c9 <strtol+0x141>
  8012c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c5:	f7 d8                	neg    %eax
  8012c7:	eb 03                	jmp    8012cc <strtol+0x144>
  8012c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012cc:	c9                   	leave  
  8012cd:	c3                   	ret    

008012ce <ltostr>:

void
ltostr(long value, char *str)
{
  8012ce:	55                   	push   %ebp
  8012cf:	89 e5                	mov    %esp,%ebp
  8012d1:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012db:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012e6:	79 13                	jns    8012fb <ltostr+0x2d>
	{
		neg = 1;
  8012e8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f2:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012f5:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012f8:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fe:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801303:	99                   	cltd   
  801304:	f7 f9                	idiv   %ecx
  801306:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801309:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80130c:	8d 50 01             	lea    0x1(%eax),%edx
  80130f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801312:	89 c2                	mov    %eax,%edx
  801314:	8b 45 0c             	mov    0xc(%ebp),%eax
  801317:	01 d0                	add    %edx,%eax
  801319:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80131c:	83 c2 30             	add    $0x30,%edx
  80131f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801321:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801324:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801329:	f7 e9                	imul   %ecx
  80132b:	c1 fa 02             	sar    $0x2,%edx
  80132e:	89 c8                	mov    %ecx,%eax
  801330:	c1 f8 1f             	sar    $0x1f,%eax
  801333:	29 c2                	sub    %eax,%edx
  801335:	89 d0                	mov    %edx,%eax
  801337:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80133a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80133d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801342:	f7 e9                	imul   %ecx
  801344:	c1 fa 02             	sar    $0x2,%edx
  801347:	89 c8                	mov    %ecx,%eax
  801349:	c1 f8 1f             	sar    $0x1f,%eax
  80134c:	29 c2                	sub    %eax,%edx
  80134e:	89 d0                	mov    %edx,%eax
  801350:	c1 e0 02             	shl    $0x2,%eax
  801353:	01 d0                	add    %edx,%eax
  801355:	01 c0                	add    %eax,%eax
  801357:	29 c1                	sub    %eax,%ecx
  801359:	89 ca                	mov    %ecx,%edx
  80135b:	85 d2                	test   %edx,%edx
  80135d:	75 9c                	jne    8012fb <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80135f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801366:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801369:	48                   	dec    %eax
  80136a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80136d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801371:	74 3d                	je     8013b0 <ltostr+0xe2>
		start = 1 ;
  801373:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80137a:	eb 34                	jmp    8013b0 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80137c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80137f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801382:	01 d0                	add    %edx,%eax
  801384:	8a 00                	mov    (%eax),%al
  801386:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801389:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80138c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138f:	01 c2                	add    %eax,%edx
  801391:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801394:	8b 45 0c             	mov    0xc(%ebp),%eax
  801397:	01 c8                	add    %ecx,%eax
  801399:	8a 00                	mov    (%eax),%al
  80139b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80139d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a3:	01 c2                	add    %eax,%edx
  8013a5:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013a8:	88 02                	mov    %al,(%edx)
		start++ ;
  8013aa:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013ad:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013b3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013b6:	7c c4                	jl     80137c <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013b8:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013be:	01 d0                	add    %edx,%eax
  8013c0:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013c3:	90                   	nop
  8013c4:	c9                   	leave  
  8013c5:	c3                   	ret    

008013c6 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013c6:	55                   	push   %ebp
  8013c7:	89 e5                	mov    %esp,%ebp
  8013c9:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013cc:	ff 75 08             	pushl  0x8(%ebp)
  8013cf:	e8 54 fa ff ff       	call   800e28 <strlen>
  8013d4:	83 c4 04             	add    $0x4,%esp
  8013d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013da:	ff 75 0c             	pushl  0xc(%ebp)
  8013dd:	e8 46 fa ff ff       	call   800e28 <strlen>
  8013e2:	83 c4 04             	add    $0x4,%esp
  8013e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013f6:	eb 17                	jmp    80140f <strcconcat+0x49>
		final[s] = str1[s] ;
  8013f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fe:	01 c2                	add    %eax,%edx
  801400:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801403:	8b 45 08             	mov    0x8(%ebp),%eax
  801406:	01 c8                	add    %ecx,%eax
  801408:	8a 00                	mov    (%eax),%al
  80140a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80140c:	ff 45 fc             	incl   -0x4(%ebp)
  80140f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801412:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801415:	7c e1                	jl     8013f8 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801417:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80141e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801425:	eb 1f                	jmp    801446 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801427:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80142a:	8d 50 01             	lea    0x1(%eax),%edx
  80142d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801430:	89 c2                	mov    %eax,%edx
  801432:	8b 45 10             	mov    0x10(%ebp),%eax
  801435:	01 c2                	add    %eax,%edx
  801437:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80143a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143d:	01 c8                	add    %ecx,%eax
  80143f:	8a 00                	mov    (%eax),%al
  801441:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801443:	ff 45 f8             	incl   -0x8(%ebp)
  801446:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801449:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80144c:	7c d9                	jl     801427 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80144e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801451:	8b 45 10             	mov    0x10(%ebp),%eax
  801454:	01 d0                	add    %edx,%eax
  801456:	c6 00 00             	movb   $0x0,(%eax)
}
  801459:	90                   	nop
  80145a:	c9                   	leave  
  80145b:	c3                   	ret    

0080145c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80145c:	55                   	push   %ebp
  80145d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80145f:	8b 45 14             	mov    0x14(%ebp),%eax
  801462:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801468:	8b 45 14             	mov    0x14(%ebp),%eax
  80146b:	8b 00                	mov    (%eax),%eax
  80146d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801474:	8b 45 10             	mov    0x10(%ebp),%eax
  801477:	01 d0                	add    %edx,%eax
  801479:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80147f:	eb 0c                	jmp    80148d <strsplit+0x31>
			*string++ = 0;
  801481:	8b 45 08             	mov    0x8(%ebp),%eax
  801484:	8d 50 01             	lea    0x1(%eax),%edx
  801487:	89 55 08             	mov    %edx,0x8(%ebp)
  80148a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80148d:	8b 45 08             	mov    0x8(%ebp),%eax
  801490:	8a 00                	mov    (%eax),%al
  801492:	84 c0                	test   %al,%al
  801494:	74 18                	je     8014ae <strsplit+0x52>
  801496:	8b 45 08             	mov    0x8(%ebp),%eax
  801499:	8a 00                	mov    (%eax),%al
  80149b:	0f be c0             	movsbl %al,%eax
  80149e:	50                   	push   %eax
  80149f:	ff 75 0c             	pushl  0xc(%ebp)
  8014a2:	e8 13 fb ff ff       	call   800fba <strchr>
  8014a7:	83 c4 08             	add    $0x8,%esp
  8014aa:	85 c0                	test   %eax,%eax
  8014ac:	75 d3                	jne    801481 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b1:	8a 00                	mov    (%eax),%al
  8014b3:	84 c0                	test   %al,%al
  8014b5:	74 5a                	je     801511 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ba:	8b 00                	mov    (%eax),%eax
  8014bc:	83 f8 0f             	cmp    $0xf,%eax
  8014bf:	75 07                	jne    8014c8 <strsplit+0x6c>
		{
			return 0;
  8014c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c6:	eb 66                	jmp    80152e <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8014cb:	8b 00                	mov    (%eax),%eax
  8014cd:	8d 48 01             	lea    0x1(%eax),%ecx
  8014d0:	8b 55 14             	mov    0x14(%ebp),%edx
  8014d3:	89 0a                	mov    %ecx,(%edx)
  8014d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8014df:	01 c2                	add    %eax,%edx
  8014e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e4:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014e6:	eb 03                	jmp    8014eb <strsplit+0x8f>
			string++;
  8014e8:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ee:	8a 00                	mov    (%eax),%al
  8014f0:	84 c0                	test   %al,%al
  8014f2:	74 8b                	je     80147f <strsplit+0x23>
  8014f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f7:	8a 00                	mov    (%eax),%al
  8014f9:	0f be c0             	movsbl %al,%eax
  8014fc:	50                   	push   %eax
  8014fd:	ff 75 0c             	pushl  0xc(%ebp)
  801500:	e8 b5 fa ff ff       	call   800fba <strchr>
  801505:	83 c4 08             	add    $0x8,%esp
  801508:	85 c0                	test   %eax,%eax
  80150a:	74 dc                	je     8014e8 <strsplit+0x8c>
			string++;
	}
  80150c:	e9 6e ff ff ff       	jmp    80147f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801511:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801512:	8b 45 14             	mov    0x14(%ebp),%eax
  801515:	8b 00                	mov    (%eax),%eax
  801517:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80151e:	8b 45 10             	mov    0x10(%ebp),%eax
  801521:	01 d0                	add    %edx,%eax
  801523:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801529:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80152e:	c9                   	leave  
  80152f:	c3                   	ret    

00801530 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801530:	55                   	push   %ebp
  801531:	89 e5                	mov    %esp,%ebp
  801533:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801536:	a1 04 40 80 00       	mov    0x804004,%eax
  80153b:	85 c0                	test   %eax,%eax
  80153d:	74 1f                	je     80155e <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80153f:	e8 1d 00 00 00       	call   801561 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801544:	83 ec 0c             	sub    $0xc,%esp
  801547:	68 30 3b 80 00       	push   $0x803b30
  80154c:	e8 55 f2 ff ff       	call   8007a6 <cprintf>
  801551:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801554:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80155b:	00 00 00 
	}
}
  80155e:	90                   	nop
  80155f:	c9                   	leave  
  801560:	c3                   	ret    

00801561 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801561:	55                   	push   %ebp
  801562:	89 e5                	mov    %esp,%ebp
  801564:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801567:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80156e:	00 00 00 
  801571:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801578:	00 00 00 
  80157b:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801582:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  801585:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80158c:	00 00 00 
  80158f:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801596:	00 00 00 
  801599:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  8015a0:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  8015a3:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  8015aa:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  8015ad:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  8015b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015bc:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015c1:	a3 50 40 80 00       	mov    %eax,0x804050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  8015c6:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8015cd:	a1 20 41 80 00       	mov    0x804120,%eax
  8015d2:	c1 e0 04             	shl    $0x4,%eax
  8015d5:	89 c2                	mov    %eax,%edx
  8015d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015da:	01 d0                	add    %edx,%eax
  8015dc:	48                   	dec    %eax
  8015dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8015e8:	f7 75 f0             	divl   -0x10(%ebp)
  8015eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ee:	29 d0                	sub    %edx,%eax
  8015f0:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  8015f3:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8015fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801602:	2d 00 10 00 00       	sub    $0x1000,%eax
  801607:	83 ec 04             	sub    $0x4,%esp
  80160a:	6a 06                	push   $0x6
  80160c:	ff 75 e8             	pushl  -0x18(%ebp)
  80160f:	50                   	push   %eax
  801610:	e8 b0 05 00 00       	call   801bc5 <sys_allocate_chunk>
  801615:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801618:	a1 20 41 80 00       	mov    0x804120,%eax
  80161d:	83 ec 0c             	sub    $0xc,%esp
  801620:	50                   	push   %eax
  801621:	e8 25 0c 00 00       	call   80224b <initialize_MemBlocksList>
  801626:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  801629:	a1 48 41 80 00       	mov    0x804148,%eax
  80162e:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  801631:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801635:	75 14                	jne    80164b <initialize_dyn_block_system+0xea>
  801637:	83 ec 04             	sub    $0x4,%esp
  80163a:	68 55 3b 80 00       	push   $0x803b55
  80163f:	6a 29                	push   $0x29
  801641:	68 73 3b 80 00       	push   $0x803b73
  801646:	e8 a7 ee ff ff       	call   8004f2 <_panic>
  80164b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80164e:	8b 00                	mov    (%eax),%eax
  801650:	85 c0                	test   %eax,%eax
  801652:	74 10                	je     801664 <initialize_dyn_block_system+0x103>
  801654:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801657:	8b 00                	mov    (%eax),%eax
  801659:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80165c:	8b 52 04             	mov    0x4(%edx),%edx
  80165f:	89 50 04             	mov    %edx,0x4(%eax)
  801662:	eb 0b                	jmp    80166f <initialize_dyn_block_system+0x10e>
  801664:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801667:	8b 40 04             	mov    0x4(%eax),%eax
  80166a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80166f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801672:	8b 40 04             	mov    0x4(%eax),%eax
  801675:	85 c0                	test   %eax,%eax
  801677:	74 0f                	je     801688 <initialize_dyn_block_system+0x127>
  801679:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80167c:	8b 40 04             	mov    0x4(%eax),%eax
  80167f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801682:	8b 12                	mov    (%edx),%edx
  801684:	89 10                	mov    %edx,(%eax)
  801686:	eb 0a                	jmp    801692 <initialize_dyn_block_system+0x131>
  801688:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80168b:	8b 00                	mov    (%eax),%eax
  80168d:	a3 48 41 80 00       	mov    %eax,0x804148
  801692:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801695:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80169b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80169e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8016a5:	a1 54 41 80 00       	mov    0x804154,%eax
  8016aa:	48                   	dec    %eax
  8016ab:	a3 54 41 80 00       	mov    %eax,0x804154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  8016b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016b3:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  8016ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016bd:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  8016c4:	83 ec 0c             	sub    $0xc,%esp
  8016c7:	ff 75 e0             	pushl  -0x20(%ebp)
  8016ca:	e8 b9 14 00 00       	call   802b88 <insert_sorted_with_merge_freeList>
  8016cf:	83 c4 10             	add    $0x10,%esp

}
  8016d2:	90                   	nop
  8016d3:	c9                   	leave  
  8016d4:	c3                   	ret    

008016d5 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8016d5:	55                   	push   %ebp
  8016d6:	89 e5                	mov    %esp,%ebp
  8016d8:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016db:	e8 50 fe ff ff       	call   801530 <InitializeUHeap>
	if (size == 0) return NULL ;
  8016e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016e4:	75 07                	jne    8016ed <malloc+0x18>
  8016e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8016eb:	eb 68                	jmp    801755 <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  8016ed:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8016f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8016f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016fa:	01 d0                	add    %edx,%eax
  8016fc:	48                   	dec    %eax
  8016fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801700:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801703:	ba 00 00 00 00       	mov    $0x0,%edx
  801708:	f7 75 f4             	divl   -0xc(%ebp)
  80170b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80170e:	29 d0                	sub    %edx,%eax
  801710:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  801713:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80171a:	e8 74 08 00 00       	call   801f93 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80171f:	85 c0                	test   %eax,%eax
  801721:	74 2d                	je     801750 <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  801723:	83 ec 0c             	sub    $0xc,%esp
  801726:	ff 75 ec             	pushl  -0x14(%ebp)
  801729:	e8 52 0e 00 00       	call   802580 <alloc_block_FF>
  80172e:	83 c4 10             	add    $0x10,%esp
  801731:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  801734:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801738:	74 16                	je     801750 <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  80173a:	83 ec 0c             	sub    $0xc,%esp
  80173d:	ff 75 e8             	pushl  -0x18(%ebp)
  801740:	e8 3b 0c 00 00       	call   802380 <insert_sorted_allocList>
  801745:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  801748:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80174b:	8b 40 08             	mov    0x8(%eax),%eax
  80174e:	eb 05                	jmp    801755 <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  801750:	b8 00 00 00 00       	mov    $0x0,%eax

}
  801755:	c9                   	leave  
  801756:	c3                   	ret    

00801757 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801757:	55                   	push   %ebp
  801758:	89 e5                	mov    %esp,%ebp
  80175a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  80175d:	8b 45 08             	mov    0x8(%ebp),%eax
  801760:	83 ec 08             	sub    $0x8,%esp
  801763:	50                   	push   %eax
  801764:	68 40 40 80 00       	push   $0x804040
  801769:	e8 ba 0b 00 00       	call   802328 <find_block>
  80176e:	83 c4 10             	add    $0x10,%esp
  801771:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  801774:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801777:	8b 40 0c             	mov    0xc(%eax),%eax
  80177a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  80177d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801781:	0f 84 9f 00 00 00    	je     801826 <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  801787:	8b 45 08             	mov    0x8(%ebp),%eax
  80178a:	83 ec 08             	sub    $0x8,%esp
  80178d:	ff 75 f0             	pushl  -0x10(%ebp)
  801790:	50                   	push   %eax
  801791:	e8 f7 03 00 00       	call   801b8d <sys_free_user_mem>
  801796:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  801799:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80179d:	75 14                	jne    8017b3 <free+0x5c>
  80179f:	83 ec 04             	sub    $0x4,%esp
  8017a2:	68 55 3b 80 00       	push   $0x803b55
  8017a7:	6a 6a                	push   $0x6a
  8017a9:	68 73 3b 80 00       	push   $0x803b73
  8017ae:	e8 3f ed ff ff       	call   8004f2 <_panic>
  8017b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b6:	8b 00                	mov    (%eax),%eax
  8017b8:	85 c0                	test   %eax,%eax
  8017ba:	74 10                	je     8017cc <free+0x75>
  8017bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017bf:	8b 00                	mov    (%eax),%eax
  8017c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017c4:	8b 52 04             	mov    0x4(%edx),%edx
  8017c7:	89 50 04             	mov    %edx,0x4(%eax)
  8017ca:	eb 0b                	jmp    8017d7 <free+0x80>
  8017cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017cf:	8b 40 04             	mov    0x4(%eax),%eax
  8017d2:	a3 44 40 80 00       	mov    %eax,0x804044
  8017d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017da:	8b 40 04             	mov    0x4(%eax),%eax
  8017dd:	85 c0                	test   %eax,%eax
  8017df:	74 0f                	je     8017f0 <free+0x99>
  8017e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e4:	8b 40 04             	mov    0x4(%eax),%eax
  8017e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017ea:	8b 12                	mov    (%edx),%edx
  8017ec:	89 10                	mov    %edx,(%eax)
  8017ee:	eb 0a                	jmp    8017fa <free+0xa3>
  8017f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017f3:	8b 00                	mov    (%eax),%eax
  8017f5:	a3 40 40 80 00       	mov    %eax,0x804040
  8017fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801803:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801806:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80180d:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801812:	48                   	dec    %eax
  801813:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(blk);
  801818:	83 ec 0c             	sub    $0xc,%esp
  80181b:	ff 75 f4             	pushl  -0xc(%ebp)
  80181e:	e8 65 13 00 00       	call   802b88 <insert_sorted_with_merge_freeList>
  801823:	83 c4 10             	add    $0x10,%esp
	}
}
  801826:	90                   	nop
  801827:	c9                   	leave  
  801828:	c3                   	ret    

00801829 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801829:	55                   	push   %ebp
  80182a:	89 e5                	mov    %esp,%ebp
  80182c:	83 ec 28             	sub    $0x28,%esp
  80182f:	8b 45 10             	mov    0x10(%ebp),%eax
  801832:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801835:	e8 f6 fc ff ff       	call   801530 <InitializeUHeap>
	if (size == 0) return NULL ;
  80183a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80183e:	75 0a                	jne    80184a <smalloc+0x21>
  801840:	b8 00 00 00 00       	mov    $0x0,%eax
  801845:	e9 af 00 00 00       	jmp    8018f9 <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  80184a:	e8 44 07 00 00       	call   801f93 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80184f:	83 f8 01             	cmp    $0x1,%eax
  801852:	0f 85 9c 00 00 00    	jne    8018f4 <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  801858:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80185f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801862:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801865:	01 d0                	add    %edx,%eax
  801867:	48                   	dec    %eax
  801868:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80186b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80186e:	ba 00 00 00 00       	mov    $0x0,%edx
  801873:	f7 75 f4             	divl   -0xc(%ebp)
  801876:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801879:	29 d0                	sub    %edx,%eax
  80187b:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  80187e:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  801885:	76 07                	jbe    80188e <smalloc+0x65>
			return NULL;
  801887:	b8 00 00 00 00       	mov    $0x0,%eax
  80188c:	eb 6b                	jmp    8018f9 <smalloc+0xd0>
		blk =alloc_block_FF(size);
  80188e:	83 ec 0c             	sub    $0xc,%esp
  801891:	ff 75 0c             	pushl  0xc(%ebp)
  801894:	e8 e7 0c 00 00       	call   802580 <alloc_block_FF>
  801899:	83 c4 10             	add    $0x10,%esp
  80189c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  80189f:	83 ec 0c             	sub    $0xc,%esp
  8018a2:	ff 75 ec             	pushl  -0x14(%ebp)
  8018a5:	e8 d6 0a 00 00       	call   802380 <insert_sorted_allocList>
  8018aa:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  8018ad:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8018b1:	75 07                	jne    8018ba <smalloc+0x91>
		{
			return NULL;
  8018b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8018b8:	eb 3f                	jmp    8018f9 <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  8018ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018bd:	8b 40 08             	mov    0x8(%eax),%eax
  8018c0:	89 c2                	mov    %eax,%edx
  8018c2:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8018c6:	52                   	push   %edx
  8018c7:	50                   	push   %eax
  8018c8:	ff 75 0c             	pushl  0xc(%ebp)
  8018cb:	ff 75 08             	pushl  0x8(%ebp)
  8018ce:	e8 45 04 00 00       	call   801d18 <sys_createSharedObject>
  8018d3:	83 c4 10             	add    $0x10,%esp
  8018d6:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  8018d9:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8018dd:	74 06                	je     8018e5 <smalloc+0xbc>
  8018df:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8018e3:	75 07                	jne    8018ec <smalloc+0xc3>
		{
			return NULL;
  8018e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ea:	eb 0d                	jmp    8018f9 <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  8018ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018ef:	8b 40 08             	mov    0x8(%eax),%eax
  8018f2:	eb 05                	jmp    8018f9 <smalloc+0xd0>
		}
	}
	else
		return NULL;
  8018f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018f9:	c9                   	leave  
  8018fa:	c3                   	ret    

008018fb <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
  8018fe:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801901:	e8 2a fc ff ff       	call   801530 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801906:	83 ec 08             	sub    $0x8,%esp
  801909:	ff 75 0c             	pushl  0xc(%ebp)
  80190c:	ff 75 08             	pushl  0x8(%ebp)
  80190f:	e8 2e 04 00 00       	call   801d42 <sys_getSizeOfSharedObject>
  801914:	83 c4 10             	add    $0x10,%esp
  801917:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  80191a:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  80191e:	75 0a                	jne    80192a <sget+0x2f>
	{
		return NULL;
  801920:	b8 00 00 00 00       	mov    $0x0,%eax
  801925:	e9 94 00 00 00       	jmp    8019be <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80192a:	e8 64 06 00 00       	call   801f93 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80192f:	85 c0                	test   %eax,%eax
  801931:	0f 84 82 00 00 00    	je     8019b9 <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  801937:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  80193e:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801945:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801948:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80194b:	01 d0                	add    %edx,%eax
  80194d:	48                   	dec    %eax
  80194e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801951:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801954:	ba 00 00 00 00       	mov    $0x0,%edx
  801959:	f7 75 ec             	divl   -0x14(%ebp)
  80195c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80195f:	29 d0                	sub    %edx,%eax
  801961:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  801964:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801967:	83 ec 0c             	sub    $0xc,%esp
  80196a:	50                   	push   %eax
  80196b:	e8 10 0c 00 00       	call   802580 <alloc_block_FF>
  801970:	83 c4 10             	add    $0x10,%esp
  801973:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  801976:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80197a:	75 07                	jne    801983 <sget+0x88>
		{
			return NULL;
  80197c:	b8 00 00 00 00       	mov    $0x0,%eax
  801981:	eb 3b                	jmp    8019be <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  801983:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801986:	8b 40 08             	mov    0x8(%eax),%eax
  801989:	83 ec 04             	sub    $0x4,%esp
  80198c:	50                   	push   %eax
  80198d:	ff 75 0c             	pushl  0xc(%ebp)
  801990:	ff 75 08             	pushl  0x8(%ebp)
  801993:	e8 c7 03 00 00       	call   801d5f <sys_getSharedObject>
  801998:	83 c4 10             	add    $0x10,%esp
  80199b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  80199e:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  8019a2:	74 06                	je     8019aa <sget+0xaf>
  8019a4:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  8019a8:	75 07                	jne    8019b1 <sget+0xb6>
		{
			return NULL;
  8019aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8019af:	eb 0d                	jmp    8019be <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  8019b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019b4:	8b 40 08             	mov    0x8(%eax),%eax
  8019b7:	eb 05                	jmp    8019be <sget+0xc3>
		}
	}
	else
			return NULL;
  8019b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019be:	c9                   	leave  
  8019bf:	c3                   	ret    

008019c0 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8019c0:	55                   	push   %ebp
  8019c1:	89 e5                	mov    %esp,%ebp
  8019c3:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8019c6:	e8 65 fb ff ff       	call   801530 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8019cb:	83 ec 04             	sub    $0x4,%esp
  8019ce:	68 80 3b 80 00       	push   $0x803b80
  8019d3:	68 e1 00 00 00       	push   $0xe1
  8019d8:	68 73 3b 80 00       	push   $0x803b73
  8019dd:	e8 10 eb ff ff       	call   8004f2 <_panic>

008019e2 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
  8019e5:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8019e8:	83 ec 04             	sub    $0x4,%esp
  8019eb:	68 a8 3b 80 00       	push   $0x803ba8
  8019f0:	68 f5 00 00 00       	push   $0xf5
  8019f5:	68 73 3b 80 00       	push   $0x803b73
  8019fa:	e8 f3 ea ff ff       	call   8004f2 <_panic>

008019ff <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
  801a02:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a05:	83 ec 04             	sub    $0x4,%esp
  801a08:	68 cc 3b 80 00       	push   $0x803bcc
  801a0d:	68 00 01 00 00       	push   $0x100
  801a12:	68 73 3b 80 00       	push   $0x803b73
  801a17:	e8 d6 ea ff ff       	call   8004f2 <_panic>

00801a1c <shrink>:

}
void shrink(uint32 newSize)
{
  801a1c:	55                   	push   %ebp
  801a1d:	89 e5                	mov    %esp,%ebp
  801a1f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a22:	83 ec 04             	sub    $0x4,%esp
  801a25:	68 cc 3b 80 00       	push   $0x803bcc
  801a2a:	68 05 01 00 00       	push   $0x105
  801a2f:	68 73 3b 80 00       	push   $0x803b73
  801a34:	e8 b9 ea ff ff       	call   8004f2 <_panic>

00801a39 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801a39:	55                   	push   %ebp
  801a3a:	89 e5                	mov    %esp,%ebp
  801a3c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a3f:	83 ec 04             	sub    $0x4,%esp
  801a42:	68 cc 3b 80 00       	push   $0x803bcc
  801a47:	68 0a 01 00 00       	push   $0x10a
  801a4c:	68 73 3b 80 00       	push   $0x803b73
  801a51:	e8 9c ea ff ff       	call   8004f2 <_panic>

00801a56 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
  801a59:	57                   	push   %edi
  801a5a:	56                   	push   %esi
  801a5b:	53                   	push   %ebx
  801a5c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a62:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a65:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a68:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a6b:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a6e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a71:	cd 30                	int    $0x30
  801a73:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a76:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a79:	83 c4 10             	add    $0x10,%esp
  801a7c:	5b                   	pop    %ebx
  801a7d:	5e                   	pop    %esi
  801a7e:	5f                   	pop    %edi
  801a7f:	5d                   	pop    %ebp
  801a80:	c3                   	ret    

00801a81 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a81:	55                   	push   %ebp
  801a82:	89 e5                	mov    %esp,%ebp
  801a84:	83 ec 04             	sub    $0x4,%esp
  801a87:	8b 45 10             	mov    0x10(%ebp),%eax
  801a8a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a8d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a91:	8b 45 08             	mov    0x8(%ebp),%eax
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	52                   	push   %edx
  801a99:	ff 75 0c             	pushl  0xc(%ebp)
  801a9c:	50                   	push   %eax
  801a9d:	6a 00                	push   $0x0
  801a9f:	e8 b2 ff ff ff       	call   801a56 <syscall>
  801aa4:	83 c4 18             	add    $0x18,%esp
}
  801aa7:	90                   	nop
  801aa8:	c9                   	leave  
  801aa9:	c3                   	ret    

00801aaa <sys_cgetc>:

int
sys_cgetc(void)
{
  801aaa:	55                   	push   %ebp
  801aab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 01                	push   $0x1
  801ab9:	e8 98 ff ff ff       	call   801a56 <syscall>
  801abe:	83 c4 18             	add    $0x18,%esp
}
  801ac1:	c9                   	leave  
  801ac2:	c3                   	ret    

00801ac3 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801ac3:	55                   	push   %ebp
  801ac4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801ac6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	52                   	push   %edx
  801ad3:	50                   	push   %eax
  801ad4:	6a 05                	push   $0x5
  801ad6:	e8 7b ff ff ff       	call   801a56 <syscall>
  801adb:	83 c4 18             	add    $0x18,%esp
}
  801ade:	c9                   	leave  
  801adf:	c3                   	ret    

00801ae0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801ae0:	55                   	push   %ebp
  801ae1:	89 e5                	mov    %esp,%ebp
  801ae3:	56                   	push   %esi
  801ae4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801ae5:	8b 75 18             	mov    0x18(%ebp),%esi
  801ae8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801aeb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801aee:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af1:	8b 45 08             	mov    0x8(%ebp),%eax
  801af4:	56                   	push   %esi
  801af5:	53                   	push   %ebx
  801af6:	51                   	push   %ecx
  801af7:	52                   	push   %edx
  801af8:	50                   	push   %eax
  801af9:	6a 06                	push   $0x6
  801afb:	e8 56 ff ff ff       	call   801a56 <syscall>
  801b00:	83 c4 18             	add    $0x18,%esp
}
  801b03:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b06:	5b                   	pop    %ebx
  801b07:	5e                   	pop    %esi
  801b08:	5d                   	pop    %ebp
  801b09:	c3                   	ret    

00801b0a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b0a:	55                   	push   %ebp
  801b0b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b10:	8b 45 08             	mov    0x8(%ebp),%eax
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	52                   	push   %edx
  801b1a:	50                   	push   %eax
  801b1b:	6a 07                	push   $0x7
  801b1d:	e8 34 ff ff ff       	call   801a56 <syscall>
  801b22:	83 c4 18             	add    $0x18,%esp
}
  801b25:	c9                   	leave  
  801b26:	c3                   	ret    

00801b27 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b27:	55                   	push   %ebp
  801b28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	ff 75 0c             	pushl  0xc(%ebp)
  801b33:	ff 75 08             	pushl  0x8(%ebp)
  801b36:	6a 08                	push   $0x8
  801b38:	e8 19 ff ff ff       	call   801a56 <syscall>
  801b3d:	83 c4 18             	add    $0x18,%esp
}
  801b40:	c9                   	leave  
  801b41:	c3                   	ret    

00801b42 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b42:	55                   	push   %ebp
  801b43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 09                	push   $0x9
  801b51:	e8 00 ff ff ff       	call   801a56 <syscall>
  801b56:	83 c4 18             	add    $0x18,%esp
}
  801b59:	c9                   	leave  
  801b5a:	c3                   	ret    

00801b5b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	6a 0a                	push   $0xa
  801b6a:	e8 e7 fe ff ff       	call   801a56 <syscall>
  801b6f:	83 c4 18             	add    $0x18,%esp
}
  801b72:	c9                   	leave  
  801b73:	c3                   	ret    

00801b74 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b74:	55                   	push   %ebp
  801b75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 0b                	push   $0xb
  801b83:	e8 ce fe ff ff       	call   801a56 <syscall>
  801b88:	83 c4 18             	add    $0x18,%esp
}
  801b8b:	c9                   	leave  
  801b8c:	c3                   	ret    

00801b8d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b8d:	55                   	push   %ebp
  801b8e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	ff 75 0c             	pushl  0xc(%ebp)
  801b99:	ff 75 08             	pushl  0x8(%ebp)
  801b9c:	6a 0f                	push   $0xf
  801b9e:	e8 b3 fe ff ff       	call   801a56 <syscall>
  801ba3:	83 c4 18             	add    $0x18,%esp
	return;
  801ba6:	90                   	nop
}
  801ba7:	c9                   	leave  
  801ba8:	c3                   	ret    

00801ba9 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ba9:	55                   	push   %ebp
  801baa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	ff 75 0c             	pushl  0xc(%ebp)
  801bb5:	ff 75 08             	pushl  0x8(%ebp)
  801bb8:	6a 10                	push   $0x10
  801bba:	e8 97 fe ff ff       	call   801a56 <syscall>
  801bbf:	83 c4 18             	add    $0x18,%esp
	return ;
  801bc2:	90                   	nop
}
  801bc3:	c9                   	leave  
  801bc4:	c3                   	ret    

00801bc5 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801bc5:	55                   	push   %ebp
  801bc6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	ff 75 10             	pushl  0x10(%ebp)
  801bcf:	ff 75 0c             	pushl  0xc(%ebp)
  801bd2:	ff 75 08             	pushl  0x8(%ebp)
  801bd5:	6a 11                	push   $0x11
  801bd7:	e8 7a fe ff ff       	call   801a56 <syscall>
  801bdc:	83 c4 18             	add    $0x18,%esp
	return ;
  801bdf:	90                   	nop
}
  801be0:	c9                   	leave  
  801be1:	c3                   	ret    

00801be2 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801be2:	55                   	push   %ebp
  801be3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 0c                	push   $0xc
  801bf1:	e8 60 fe ff ff       	call   801a56 <syscall>
  801bf6:	83 c4 18             	add    $0x18,%esp
}
  801bf9:	c9                   	leave  
  801bfa:	c3                   	ret    

00801bfb <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801bfb:	55                   	push   %ebp
  801bfc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	ff 75 08             	pushl  0x8(%ebp)
  801c09:	6a 0d                	push   $0xd
  801c0b:	e8 46 fe ff ff       	call   801a56 <syscall>
  801c10:	83 c4 18             	add    $0x18,%esp
}
  801c13:	c9                   	leave  
  801c14:	c3                   	ret    

00801c15 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c15:	55                   	push   %ebp
  801c16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 0e                	push   $0xe
  801c24:	e8 2d fe ff ff       	call   801a56 <syscall>
  801c29:	83 c4 18             	add    $0x18,%esp
}
  801c2c:	90                   	nop
  801c2d:	c9                   	leave  
  801c2e:	c3                   	ret    

00801c2f <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801c2f:	55                   	push   %ebp
  801c30:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 13                	push   $0x13
  801c3e:	e8 13 fe ff ff       	call   801a56 <syscall>
  801c43:	83 c4 18             	add    $0x18,%esp
}
  801c46:	90                   	nop
  801c47:	c9                   	leave  
  801c48:	c3                   	ret    

00801c49 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801c49:	55                   	push   %ebp
  801c4a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 14                	push   $0x14
  801c58:	e8 f9 fd ff ff       	call   801a56 <syscall>
  801c5d:	83 c4 18             	add    $0x18,%esp
}
  801c60:	90                   	nop
  801c61:	c9                   	leave  
  801c62:	c3                   	ret    

00801c63 <sys_cputc>:


void
sys_cputc(const char c)
{
  801c63:	55                   	push   %ebp
  801c64:	89 e5                	mov    %esp,%ebp
  801c66:	83 ec 04             	sub    $0x4,%esp
  801c69:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c6f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	50                   	push   %eax
  801c7c:	6a 15                	push   $0x15
  801c7e:	e8 d3 fd ff ff       	call   801a56 <syscall>
  801c83:	83 c4 18             	add    $0x18,%esp
}
  801c86:	90                   	nop
  801c87:	c9                   	leave  
  801c88:	c3                   	ret    

00801c89 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 16                	push   $0x16
  801c98:	e8 b9 fd ff ff       	call   801a56 <syscall>
  801c9d:	83 c4 18             	add    $0x18,%esp
}
  801ca0:	90                   	nop
  801ca1:	c9                   	leave  
  801ca2:	c3                   	ret    

00801ca3 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801ca3:	55                   	push   %ebp
  801ca4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	ff 75 0c             	pushl  0xc(%ebp)
  801cb2:	50                   	push   %eax
  801cb3:	6a 17                	push   $0x17
  801cb5:	e8 9c fd ff ff       	call   801a56 <syscall>
  801cba:	83 c4 18             	add    $0x18,%esp
}
  801cbd:	c9                   	leave  
  801cbe:	c3                   	ret    

00801cbf <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801cbf:	55                   	push   %ebp
  801cc0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cc2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	52                   	push   %edx
  801ccf:	50                   	push   %eax
  801cd0:	6a 1a                	push   $0x1a
  801cd2:	e8 7f fd ff ff       	call   801a56 <syscall>
  801cd7:	83 c4 18             	add    $0x18,%esp
}
  801cda:	c9                   	leave  
  801cdb:	c3                   	ret    

00801cdc <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801cdc:	55                   	push   %ebp
  801cdd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cdf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	52                   	push   %edx
  801cec:	50                   	push   %eax
  801ced:	6a 18                	push   $0x18
  801cef:	e8 62 fd ff ff       	call   801a56 <syscall>
  801cf4:	83 c4 18             	add    $0x18,%esp
}
  801cf7:	90                   	nop
  801cf8:	c9                   	leave  
  801cf9:	c3                   	ret    

00801cfa <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801cfa:	55                   	push   %ebp
  801cfb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cfd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d00:	8b 45 08             	mov    0x8(%ebp),%eax
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	52                   	push   %edx
  801d0a:	50                   	push   %eax
  801d0b:	6a 19                	push   $0x19
  801d0d:	e8 44 fd ff ff       	call   801a56 <syscall>
  801d12:	83 c4 18             	add    $0x18,%esp
}
  801d15:	90                   	nop
  801d16:	c9                   	leave  
  801d17:	c3                   	ret    

00801d18 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801d18:	55                   	push   %ebp
  801d19:	89 e5                	mov    %esp,%ebp
  801d1b:	83 ec 04             	sub    $0x4,%esp
  801d1e:	8b 45 10             	mov    0x10(%ebp),%eax
  801d21:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801d24:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d27:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2e:	6a 00                	push   $0x0
  801d30:	51                   	push   %ecx
  801d31:	52                   	push   %edx
  801d32:	ff 75 0c             	pushl  0xc(%ebp)
  801d35:	50                   	push   %eax
  801d36:	6a 1b                	push   $0x1b
  801d38:	e8 19 fd ff ff       	call   801a56 <syscall>
  801d3d:	83 c4 18             	add    $0x18,%esp
}
  801d40:	c9                   	leave  
  801d41:	c3                   	ret    

00801d42 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d42:	55                   	push   %ebp
  801d43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d45:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d48:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 00                	push   $0x0
  801d51:	52                   	push   %edx
  801d52:	50                   	push   %eax
  801d53:	6a 1c                	push   $0x1c
  801d55:	e8 fc fc ff ff       	call   801a56 <syscall>
  801d5a:	83 c4 18             	add    $0x18,%esp
}
  801d5d:	c9                   	leave  
  801d5e:	c3                   	ret    

00801d5f <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d5f:	55                   	push   %ebp
  801d60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d62:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d65:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d68:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	51                   	push   %ecx
  801d70:	52                   	push   %edx
  801d71:	50                   	push   %eax
  801d72:	6a 1d                	push   $0x1d
  801d74:	e8 dd fc ff ff       	call   801a56 <syscall>
  801d79:	83 c4 18             	add    $0x18,%esp
}
  801d7c:	c9                   	leave  
  801d7d:	c3                   	ret    

00801d7e <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d7e:	55                   	push   %ebp
  801d7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d81:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d84:	8b 45 08             	mov    0x8(%ebp),%eax
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	52                   	push   %edx
  801d8e:	50                   	push   %eax
  801d8f:	6a 1e                	push   $0x1e
  801d91:	e8 c0 fc ff ff       	call   801a56 <syscall>
  801d96:	83 c4 18             	add    $0x18,%esp
}
  801d99:	c9                   	leave  
  801d9a:	c3                   	ret    

00801d9b <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801d9b:	55                   	push   %ebp
  801d9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 1f                	push   $0x1f
  801daa:	e8 a7 fc ff ff       	call   801a56 <syscall>
  801daf:	83 c4 18             	add    $0x18,%esp
}
  801db2:	c9                   	leave  
  801db3:	c3                   	ret    

00801db4 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801db4:	55                   	push   %ebp
  801db5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801db7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dba:	6a 00                	push   $0x0
  801dbc:	ff 75 14             	pushl  0x14(%ebp)
  801dbf:	ff 75 10             	pushl  0x10(%ebp)
  801dc2:	ff 75 0c             	pushl  0xc(%ebp)
  801dc5:	50                   	push   %eax
  801dc6:	6a 20                	push   $0x20
  801dc8:	e8 89 fc ff ff       	call   801a56 <syscall>
  801dcd:	83 c4 18             	add    $0x18,%esp
}
  801dd0:	c9                   	leave  
  801dd1:	c3                   	ret    

00801dd2 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801dd2:	55                   	push   %ebp
  801dd3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	50                   	push   %eax
  801de1:	6a 21                	push   $0x21
  801de3:	e8 6e fc ff ff       	call   801a56 <syscall>
  801de8:	83 c4 18             	add    $0x18,%esp
}
  801deb:	90                   	nop
  801dec:	c9                   	leave  
  801ded:	c3                   	ret    

00801dee <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801dee:	55                   	push   %ebp
  801def:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801df1:	8b 45 08             	mov    0x8(%ebp),%eax
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	50                   	push   %eax
  801dfd:	6a 22                	push   $0x22
  801dff:	e8 52 fc ff ff       	call   801a56 <syscall>
  801e04:	83 c4 18             	add    $0x18,%esp
}
  801e07:	c9                   	leave  
  801e08:	c3                   	ret    

00801e09 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801e09:	55                   	push   %ebp
  801e0a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	6a 00                	push   $0x0
  801e16:	6a 02                	push   $0x2
  801e18:	e8 39 fc ff ff       	call   801a56 <syscall>
  801e1d:	83 c4 18             	add    $0x18,%esp
}
  801e20:	c9                   	leave  
  801e21:	c3                   	ret    

00801e22 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801e22:	55                   	push   %ebp
  801e23:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 03                	push   $0x3
  801e31:	e8 20 fc ff ff       	call   801a56 <syscall>
  801e36:	83 c4 18             	add    $0x18,%esp
}
  801e39:	c9                   	leave  
  801e3a:	c3                   	ret    

00801e3b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801e3b:	55                   	push   %ebp
  801e3c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	6a 04                	push   $0x4
  801e4a:	e8 07 fc ff ff       	call   801a56 <syscall>
  801e4f:	83 c4 18             	add    $0x18,%esp
}
  801e52:	c9                   	leave  
  801e53:	c3                   	ret    

00801e54 <sys_exit_env>:


void sys_exit_env(void)
{
  801e54:	55                   	push   %ebp
  801e55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e57:	6a 00                	push   $0x0
  801e59:	6a 00                	push   $0x0
  801e5b:	6a 00                	push   $0x0
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 23                	push   $0x23
  801e63:	e8 ee fb ff ff       	call   801a56 <syscall>
  801e68:	83 c4 18             	add    $0x18,%esp
}
  801e6b:	90                   	nop
  801e6c:	c9                   	leave  
  801e6d:	c3                   	ret    

00801e6e <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801e6e:	55                   	push   %ebp
  801e6f:	89 e5                	mov    %esp,%ebp
  801e71:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e74:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e77:	8d 50 04             	lea    0x4(%eax),%edx
  801e7a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e7d:	6a 00                	push   $0x0
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	52                   	push   %edx
  801e84:	50                   	push   %eax
  801e85:	6a 24                	push   $0x24
  801e87:	e8 ca fb ff ff       	call   801a56 <syscall>
  801e8c:	83 c4 18             	add    $0x18,%esp
	return result;
  801e8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e92:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e95:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e98:	89 01                	mov    %eax,(%ecx)
  801e9a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea0:	c9                   	leave  
  801ea1:	c2 04 00             	ret    $0x4

00801ea4 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ea4:	55                   	push   %ebp
  801ea5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ea7:	6a 00                	push   $0x0
  801ea9:	6a 00                	push   $0x0
  801eab:	ff 75 10             	pushl  0x10(%ebp)
  801eae:	ff 75 0c             	pushl  0xc(%ebp)
  801eb1:	ff 75 08             	pushl  0x8(%ebp)
  801eb4:	6a 12                	push   $0x12
  801eb6:	e8 9b fb ff ff       	call   801a56 <syscall>
  801ebb:	83 c4 18             	add    $0x18,%esp
	return ;
  801ebe:	90                   	nop
}
  801ebf:	c9                   	leave  
  801ec0:	c3                   	ret    

00801ec1 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ec1:	55                   	push   %ebp
  801ec2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 25                	push   $0x25
  801ed0:	e8 81 fb ff ff       	call   801a56 <syscall>
  801ed5:	83 c4 18             	add    $0x18,%esp
}
  801ed8:	c9                   	leave  
  801ed9:	c3                   	ret    

00801eda <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801eda:	55                   	push   %ebp
  801edb:	89 e5                	mov    %esp,%ebp
  801edd:	83 ec 04             	sub    $0x4,%esp
  801ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801ee6:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801eea:	6a 00                	push   $0x0
  801eec:	6a 00                	push   $0x0
  801eee:	6a 00                	push   $0x0
  801ef0:	6a 00                	push   $0x0
  801ef2:	50                   	push   %eax
  801ef3:	6a 26                	push   $0x26
  801ef5:	e8 5c fb ff ff       	call   801a56 <syscall>
  801efa:	83 c4 18             	add    $0x18,%esp
	return ;
  801efd:	90                   	nop
}
  801efe:	c9                   	leave  
  801eff:	c3                   	ret    

00801f00 <rsttst>:
void rsttst()
{
  801f00:	55                   	push   %ebp
  801f01:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801f03:	6a 00                	push   $0x0
  801f05:	6a 00                	push   $0x0
  801f07:	6a 00                	push   $0x0
  801f09:	6a 00                	push   $0x0
  801f0b:	6a 00                	push   $0x0
  801f0d:	6a 28                	push   $0x28
  801f0f:	e8 42 fb ff ff       	call   801a56 <syscall>
  801f14:	83 c4 18             	add    $0x18,%esp
	return ;
  801f17:	90                   	nop
}
  801f18:	c9                   	leave  
  801f19:	c3                   	ret    

00801f1a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801f1a:	55                   	push   %ebp
  801f1b:	89 e5                	mov    %esp,%ebp
  801f1d:	83 ec 04             	sub    $0x4,%esp
  801f20:	8b 45 14             	mov    0x14(%ebp),%eax
  801f23:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801f26:	8b 55 18             	mov    0x18(%ebp),%edx
  801f29:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f2d:	52                   	push   %edx
  801f2e:	50                   	push   %eax
  801f2f:	ff 75 10             	pushl  0x10(%ebp)
  801f32:	ff 75 0c             	pushl  0xc(%ebp)
  801f35:	ff 75 08             	pushl  0x8(%ebp)
  801f38:	6a 27                	push   $0x27
  801f3a:	e8 17 fb ff ff       	call   801a56 <syscall>
  801f3f:	83 c4 18             	add    $0x18,%esp
	return ;
  801f42:	90                   	nop
}
  801f43:	c9                   	leave  
  801f44:	c3                   	ret    

00801f45 <chktst>:
void chktst(uint32 n)
{
  801f45:	55                   	push   %ebp
  801f46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 00                	push   $0x0
  801f50:	ff 75 08             	pushl  0x8(%ebp)
  801f53:	6a 29                	push   $0x29
  801f55:	e8 fc fa ff ff       	call   801a56 <syscall>
  801f5a:	83 c4 18             	add    $0x18,%esp
	return ;
  801f5d:	90                   	nop
}
  801f5e:	c9                   	leave  
  801f5f:	c3                   	ret    

00801f60 <inctst>:

void inctst()
{
  801f60:	55                   	push   %ebp
  801f61:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f63:	6a 00                	push   $0x0
  801f65:	6a 00                	push   $0x0
  801f67:	6a 00                	push   $0x0
  801f69:	6a 00                	push   $0x0
  801f6b:	6a 00                	push   $0x0
  801f6d:	6a 2a                	push   $0x2a
  801f6f:	e8 e2 fa ff ff       	call   801a56 <syscall>
  801f74:	83 c4 18             	add    $0x18,%esp
	return ;
  801f77:	90                   	nop
}
  801f78:	c9                   	leave  
  801f79:	c3                   	ret    

00801f7a <gettst>:
uint32 gettst()
{
  801f7a:	55                   	push   %ebp
  801f7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f7d:	6a 00                	push   $0x0
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 00                	push   $0x0
  801f83:	6a 00                	push   $0x0
  801f85:	6a 00                	push   $0x0
  801f87:	6a 2b                	push   $0x2b
  801f89:	e8 c8 fa ff ff       	call   801a56 <syscall>
  801f8e:	83 c4 18             	add    $0x18,%esp
}
  801f91:	c9                   	leave  
  801f92:	c3                   	ret    

00801f93 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f93:	55                   	push   %ebp
  801f94:	89 e5                	mov    %esp,%ebp
  801f96:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f99:	6a 00                	push   $0x0
  801f9b:	6a 00                	push   $0x0
  801f9d:	6a 00                	push   $0x0
  801f9f:	6a 00                	push   $0x0
  801fa1:	6a 00                	push   $0x0
  801fa3:	6a 2c                	push   $0x2c
  801fa5:	e8 ac fa ff ff       	call   801a56 <syscall>
  801faa:	83 c4 18             	add    $0x18,%esp
  801fad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801fb0:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801fb4:	75 07                	jne    801fbd <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801fb6:	b8 01 00 00 00       	mov    $0x1,%eax
  801fbb:	eb 05                	jmp    801fc2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801fbd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fc2:	c9                   	leave  
  801fc3:	c3                   	ret    

00801fc4 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801fc4:	55                   	push   %ebp
  801fc5:	89 e5                	mov    %esp,%ebp
  801fc7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fca:	6a 00                	push   $0x0
  801fcc:	6a 00                	push   $0x0
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 2c                	push   $0x2c
  801fd6:	e8 7b fa ff ff       	call   801a56 <syscall>
  801fdb:	83 c4 18             	add    $0x18,%esp
  801fde:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801fe1:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801fe5:	75 07                	jne    801fee <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801fe7:	b8 01 00 00 00       	mov    $0x1,%eax
  801fec:	eb 05                	jmp    801ff3 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801fee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ff3:	c9                   	leave  
  801ff4:	c3                   	ret    

00801ff5 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ff5:	55                   	push   %ebp
  801ff6:	89 e5                	mov    %esp,%ebp
  801ff8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ffb:	6a 00                	push   $0x0
  801ffd:	6a 00                	push   $0x0
  801fff:	6a 00                	push   $0x0
  802001:	6a 00                	push   $0x0
  802003:	6a 00                	push   $0x0
  802005:	6a 2c                	push   $0x2c
  802007:	e8 4a fa ff ff       	call   801a56 <syscall>
  80200c:	83 c4 18             	add    $0x18,%esp
  80200f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802012:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802016:	75 07                	jne    80201f <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802018:	b8 01 00 00 00       	mov    $0x1,%eax
  80201d:	eb 05                	jmp    802024 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80201f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802024:	c9                   	leave  
  802025:	c3                   	ret    

00802026 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802026:	55                   	push   %ebp
  802027:	89 e5                	mov    %esp,%ebp
  802029:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80202c:	6a 00                	push   $0x0
  80202e:	6a 00                	push   $0x0
  802030:	6a 00                	push   $0x0
  802032:	6a 00                	push   $0x0
  802034:	6a 00                	push   $0x0
  802036:	6a 2c                	push   $0x2c
  802038:	e8 19 fa ff ff       	call   801a56 <syscall>
  80203d:	83 c4 18             	add    $0x18,%esp
  802040:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802043:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802047:	75 07                	jne    802050 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802049:	b8 01 00 00 00       	mov    $0x1,%eax
  80204e:	eb 05                	jmp    802055 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802050:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802055:	c9                   	leave  
  802056:	c3                   	ret    

00802057 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802057:	55                   	push   %ebp
  802058:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80205a:	6a 00                	push   $0x0
  80205c:	6a 00                	push   $0x0
  80205e:	6a 00                	push   $0x0
  802060:	6a 00                	push   $0x0
  802062:	ff 75 08             	pushl  0x8(%ebp)
  802065:	6a 2d                	push   $0x2d
  802067:	e8 ea f9 ff ff       	call   801a56 <syscall>
  80206c:	83 c4 18             	add    $0x18,%esp
	return ;
  80206f:	90                   	nop
}
  802070:	c9                   	leave  
  802071:	c3                   	ret    

00802072 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802072:	55                   	push   %ebp
  802073:	89 e5                	mov    %esp,%ebp
  802075:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802076:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802079:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80207c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80207f:	8b 45 08             	mov    0x8(%ebp),%eax
  802082:	6a 00                	push   $0x0
  802084:	53                   	push   %ebx
  802085:	51                   	push   %ecx
  802086:	52                   	push   %edx
  802087:	50                   	push   %eax
  802088:	6a 2e                	push   $0x2e
  80208a:	e8 c7 f9 ff ff       	call   801a56 <syscall>
  80208f:	83 c4 18             	add    $0x18,%esp
}
  802092:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802095:	c9                   	leave  
  802096:	c3                   	ret    

00802097 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802097:	55                   	push   %ebp
  802098:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80209a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80209d:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a0:	6a 00                	push   $0x0
  8020a2:	6a 00                	push   $0x0
  8020a4:	6a 00                	push   $0x0
  8020a6:	52                   	push   %edx
  8020a7:	50                   	push   %eax
  8020a8:	6a 2f                	push   $0x2f
  8020aa:	e8 a7 f9 ff ff       	call   801a56 <syscall>
  8020af:	83 c4 18             	add    $0x18,%esp
}
  8020b2:	c9                   	leave  
  8020b3:	c3                   	ret    

008020b4 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8020b4:	55                   	push   %ebp
  8020b5:	89 e5                	mov    %esp,%ebp
  8020b7:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8020ba:	83 ec 0c             	sub    $0xc,%esp
  8020bd:	68 dc 3b 80 00       	push   $0x803bdc
  8020c2:	e8 df e6 ff ff       	call   8007a6 <cprintf>
  8020c7:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8020ca:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8020d1:	83 ec 0c             	sub    $0xc,%esp
  8020d4:	68 08 3c 80 00       	push   $0x803c08
  8020d9:	e8 c8 e6 ff ff       	call   8007a6 <cprintf>
  8020de:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8020e1:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8020e5:	a1 38 41 80 00       	mov    0x804138,%eax
  8020ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020ed:	eb 56                	jmp    802145 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8020ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020f3:	74 1c                	je     802111 <print_mem_block_lists+0x5d>
  8020f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f8:	8b 50 08             	mov    0x8(%eax),%edx
  8020fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020fe:	8b 48 08             	mov    0x8(%eax),%ecx
  802101:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802104:	8b 40 0c             	mov    0xc(%eax),%eax
  802107:	01 c8                	add    %ecx,%eax
  802109:	39 c2                	cmp    %eax,%edx
  80210b:	73 04                	jae    802111 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80210d:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802111:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802114:	8b 50 08             	mov    0x8(%eax),%edx
  802117:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211a:	8b 40 0c             	mov    0xc(%eax),%eax
  80211d:	01 c2                	add    %eax,%edx
  80211f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802122:	8b 40 08             	mov    0x8(%eax),%eax
  802125:	83 ec 04             	sub    $0x4,%esp
  802128:	52                   	push   %edx
  802129:	50                   	push   %eax
  80212a:	68 1d 3c 80 00       	push   $0x803c1d
  80212f:	e8 72 e6 ff ff       	call   8007a6 <cprintf>
  802134:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802137:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80213d:	a1 40 41 80 00       	mov    0x804140,%eax
  802142:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802145:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802149:	74 07                	je     802152 <print_mem_block_lists+0x9e>
  80214b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214e:	8b 00                	mov    (%eax),%eax
  802150:	eb 05                	jmp    802157 <print_mem_block_lists+0xa3>
  802152:	b8 00 00 00 00       	mov    $0x0,%eax
  802157:	a3 40 41 80 00       	mov    %eax,0x804140
  80215c:	a1 40 41 80 00       	mov    0x804140,%eax
  802161:	85 c0                	test   %eax,%eax
  802163:	75 8a                	jne    8020ef <print_mem_block_lists+0x3b>
  802165:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802169:	75 84                	jne    8020ef <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80216b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80216f:	75 10                	jne    802181 <print_mem_block_lists+0xcd>
  802171:	83 ec 0c             	sub    $0xc,%esp
  802174:	68 2c 3c 80 00       	push   $0x803c2c
  802179:	e8 28 e6 ff ff       	call   8007a6 <cprintf>
  80217e:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802181:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802188:	83 ec 0c             	sub    $0xc,%esp
  80218b:	68 50 3c 80 00       	push   $0x803c50
  802190:	e8 11 e6 ff ff       	call   8007a6 <cprintf>
  802195:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802198:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80219c:	a1 40 40 80 00       	mov    0x804040,%eax
  8021a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021a4:	eb 56                	jmp    8021fc <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8021a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021aa:	74 1c                	je     8021c8 <print_mem_block_lists+0x114>
  8021ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021af:	8b 50 08             	mov    0x8(%eax),%edx
  8021b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021b5:	8b 48 08             	mov    0x8(%eax),%ecx
  8021b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8021be:	01 c8                	add    %ecx,%eax
  8021c0:	39 c2                	cmp    %eax,%edx
  8021c2:	73 04                	jae    8021c8 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8021c4:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8021c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cb:	8b 50 08             	mov    0x8(%eax),%edx
  8021ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8021d4:	01 c2                	add    %eax,%edx
  8021d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d9:	8b 40 08             	mov    0x8(%eax),%eax
  8021dc:	83 ec 04             	sub    $0x4,%esp
  8021df:	52                   	push   %edx
  8021e0:	50                   	push   %eax
  8021e1:	68 1d 3c 80 00       	push   $0x803c1d
  8021e6:	e8 bb e5 ff ff       	call   8007a6 <cprintf>
  8021eb:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8021ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8021f4:	a1 48 40 80 00       	mov    0x804048,%eax
  8021f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802200:	74 07                	je     802209 <print_mem_block_lists+0x155>
  802202:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802205:	8b 00                	mov    (%eax),%eax
  802207:	eb 05                	jmp    80220e <print_mem_block_lists+0x15a>
  802209:	b8 00 00 00 00       	mov    $0x0,%eax
  80220e:	a3 48 40 80 00       	mov    %eax,0x804048
  802213:	a1 48 40 80 00       	mov    0x804048,%eax
  802218:	85 c0                	test   %eax,%eax
  80221a:	75 8a                	jne    8021a6 <print_mem_block_lists+0xf2>
  80221c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802220:	75 84                	jne    8021a6 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802222:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802226:	75 10                	jne    802238 <print_mem_block_lists+0x184>
  802228:	83 ec 0c             	sub    $0xc,%esp
  80222b:	68 68 3c 80 00       	push   $0x803c68
  802230:	e8 71 e5 ff ff       	call   8007a6 <cprintf>
  802235:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802238:	83 ec 0c             	sub    $0xc,%esp
  80223b:	68 dc 3b 80 00       	push   $0x803bdc
  802240:	e8 61 e5 ff ff       	call   8007a6 <cprintf>
  802245:	83 c4 10             	add    $0x10,%esp

}
  802248:	90                   	nop
  802249:	c9                   	leave  
  80224a:	c3                   	ret    

0080224b <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80224b:	55                   	push   %ebp
  80224c:	89 e5                	mov    %esp,%ebp
  80224e:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802251:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802258:	00 00 00 
  80225b:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802262:	00 00 00 
  802265:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  80226c:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  80226f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802276:	e9 9e 00 00 00       	jmp    802319 <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  80227b:	a1 50 40 80 00       	mov    0x804050,%eax
  802280:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802283:	c1 e2 04             	shl    $0x4,%edx
  802286:	01 d0                	add    %edx,%eax
  802288:	85 c0                	test   %eax,%eax
  80228a:	75 14                	jne    8022a0 <initialize_MemBlocksList+0x55>
  80228c:	83 ec 04             	sub    $0x4,%esp
  80228f:	68 90 3c 80 00       	push   $0x803c90
  802294:	6a 42                	push   $0x42
  802296:	68 b3 3c 80 00       	push   $0x803cb3
  80229b:	e8 52 e2 ff ff       	call   8004f2 <_panic>
  8022a0:	a1 50 40 80 00       	mov    0x804050,%eax
  8022a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022a8:	c1 e2 04             	shl    $0x4,%edx
  8022ab:	01 d0                	add    %edx,%eax
  8022ad:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8022b3:	89 10                	mov    %edx,(%eax)
  8022b5:	8b 00                	mov    (%eax),%eax
  8022b7:	85 c0                	test   %eax,%eax
  8022b9:	74 18                	je     8022d3 <initialize_MemBlocksList+0x88>
  8022bb:	a1 48 41 80 00       	mov    0x804148,%eax
  8022c0:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8022c6:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8022c9:	c1 e1 04             	shl    $0x4,%ecx
  8022cc:	01 ca                	add    %ecx,%edx
  8022ce:	89 50 04             	mov    %edx,0x4(%eax)
  8022d1:	eb 12                	jmp    8022e5 <initialize_MemBlocksList+0x9a>
  8022d3:	a1 50 40 80 00       	mov    0x804050,%eax
  8022d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022db:	c1 e2 04             	shl    $0x4,%edx
  8022de:	01 d0                	add    %edx,%eax
  8022e0:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8022e5:	a1 50 40 80 00       	mov    0x804050,%eax
  8022ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022ed:	c1 e2 04             	shl    $0x4,%edx
  8022f0:	01 d0                	add    %edx,%eax
  8022f2:	a3 48 41 80 00       	mov    %eax,0x804148
  8022f7:	a1 50 40 80 00       	mov    0x804050,%eax
  8022fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022ff:	c1 e2 04             	shl    $0x4,%edx
  802302:	01 d0                	add    %edx,%eax
  802304:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80230b:	a1 54 41 80 00       	mov    0x804154,%eax
  802310:	40                   	inc    %eax
  802311:	a3 54 41 80 00       	mov    %eax,0x804154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  802316:	ff 45 f4             	incl   -0xc(%ebp)
  802319:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80231f:	0f 82 56 ff ff ff    	jb     80227b <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  802325:	90                   	nop
  802326:	c9                   	leave  
  802327:	c3                   	ret    

00802328 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802328:	55                   	push   %ebp
  802329:	89 e5                	mov    %esp,%ebp
  80232b:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  80232e:	8b 45 08             	mov    0x8(%ebp),%eax
  802331:	8b 00                	mov    (%eax),%eax
  802333:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802336:	eb 19                	jmp    802351 <find_block+0x29>
	{
		if(blk->sva==va)
  802338:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80233b:	8b 40 08             	mov    0x8(%eax),%eax
  80233e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802341:	75 05                	jne    802348 <find_block+0x20>
			return (blk);
  802343:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802346:	eb 36                	jmp    80237e <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  802348:	8b 45 08             	mov    0x8(%ebp),%eax
  80234b:	8b 40 08             	mov    0x8(%eax),%eax
  80234e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802351:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802355:	74 07                	je     80235e <find_block+0x36>
  802357:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80235a:	8b 00                	mov    (%eax),%eax
  80235c:	eb 05                	jmp    802363 <find_block+0x3b>
  80235e:	b8 00 00 00 00       	mov    $0x0,%eax
  802363:	8b 55 08             	mov    0x8(%ebp),%edx
  802366:	89 42 08             	mov    %eax,0x8(%edx)
  802369:	8b 45 08             	mov    0x8(%ebp),%eax
  80236c:	8b 40 08             	mov    0x8(%eax),%eax
  80236f:	85 c0                	test   %eax,%eax
  802371:	75 c5                	jne    802338 <find_block+0x10>
  802373:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802377:	75 bf                	jne    802338 <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  802379:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80237e:	c9                   	leave  
  80237f:	c3                   	ret    

00802380 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802380:	55                   	push   %ebp
  802381:	89 e5                	mov    %esp,%ebp
  802383:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  802386:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80238b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80238e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  802395:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802398:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80239b:	75 65                	jne    802402 <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80239d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023a1:	75 14                	jne    8023b7 <insert_sorted_allocList+0x37>
  8023a3:	83 ec 04             	sub    $0x4,%esp
  8023a6:	68 90 3c 80 00       	push   $0x803c90
  8023ab:	6a 5c                	push   $0x5c
  8023ad:	68 b3 3c 80 00       	push   $0x803cb3
  8023b2:	e8 3b e1 ff ff       	call   8004f2 <_panic>
  8023b7:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8023bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c0:	89 10                	mov    %edx,(%eax)
  8023c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c5:	8b 00                	mov    (%eax),%eax
  8023c7:	85 c0                	test   %eax,%eax
  8023c9:	74 0d                	je     8023d8 <insert_sorted_allocList+0x58>
  8023cb:	a1 40 40 80 00       	mov    0x804040,%eax
  8023d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8023d3:	89 50 04             	mov    %edx,0x4(%eax)
  8023d6:	eb 08                	jmp    8023e0 <insert_sorted_allocList+0x60>
  8023d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023db:	a3 44 40 80 00       	mov    %eax,0x804044
  8023e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e3:	a3 40 40 80 00       	mov    %eax,0x804040
  8023e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023f2:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023f7:	40                   	inc    %eax
  8023f8:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  8023fd:	e9 7b 01 00 00       	jmp    80257d <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  802402:	a1 44 40 80 00       	mov    0x804044,%eax
  802407:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  80240a:	a1 40 40 80 00       	mov    0x804040,%eax
  80240f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  802412:	8b 45 08             	mov    0x8(%ebp),%eax
  802415:	8b 50 08             	mov    0x8(%eax),%edx
  802418:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80241b:	8b 40 08             	mov    0x8(%eax),%eax
  80241e:	39 c2                	cmp    %eax,%edx
  802420:	76 65                	jbe    802487 <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  802422:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802426:	75 14                	jne    80243c <insert_sorted_allocList+0xbc>
  802428:	83 ec 04             	sub    $0x4,%esp
  80242b:	68 cc 3c 80 00       	push   $0x803ccc
  802430:	6a 64                	push   $0x64
  802432:	68 b3 3c 80 00       	push   $0x803cb3
  802437:	e8 b6 e0 ff ff       	call   8004f2 <_panic>
  80243c:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802442:	8b 45 08             	mov    0x8(%ebp),%eax
  802445:	89 50 04             	mov    %edx,0x4(%eax)
  802448:	8b 45 08             	mov    0x8(%ebp),%eax
  80244b:	8b 40 04             	mov    0x4(%eax),%eax
  80244e:	85 c0                	test   %eax,%eax
  802450:	74 0c                	je     80245e <insert_sorted_allocList+0xde>
  802452:	a1 44 40 80 00       	mov    0x804044,%eax
  802457:	8b 55 08             	mov    0x8(%ebp),%edx
  80245a:	89 10                	mov    %edx,(%eax)
  80245c:	eb 08                	jmp    802466 <insert_sorted_allocList+0xe6>
  80245e:	8b 45 08             	mov    0x8(%ebp),%eax
  802461:	a3 40 40 80 00       	mov    %eax,0x804040
  802466:	8b 45 08             	mov    0x8(%ebp),%eax
  802469:	a3 44 40 80 00       	mov    %eax,0x804044
  80246e:	8b 45 08             	mov    0x8(%ebp),%eax
  802471:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802477:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80247c:	40                   	inc    %eax
  80247d:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  802482:	e9 f6 00 00 00       	jmp    80257d <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  802487:	8b 45 08             	mov    0x8(%ebp),%eax
  80248a:	8b 50 08             	mov    0x8(%eax),%edx
  80248d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802490:	8b 40 08             	mov    0x8(%eax),%eax
  802493:	39 c2                	cmp    %eax,%edx
  802495:	73 65                	jae    8024fc <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802497:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80249b:	75 14                	jne    8024b1 <insert_sorted_allocList+0x131>
  80249d:	83 ec 04             	sub    $0x4,%esp
  8024a0:	68 90 3c 80 00       	push   $0x803c90
  8024a5:	6a 68                	push   $0x68
  8024a7:	68 b3 3c 80 00       	push   $0x803cb3
  8024ac:	e8 41 e0 ff ff       	call   8004f2 <_panic>
  8024b1:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8024b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ba:	89 10                	mov    %edx,(%eax)
  8024bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bf:	8b 00                	mov    (%eax),%eax
  8024c1:	85 c0                	test   %eax,%eax
  8024c3:	74 0d                	je     8024d2 <insert_sorted_allocList+0x152>
  8024c5:	a1 40 40 80 00       	mov    0x804040,%eax
  8024ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8024cd:	89 50 04             	mov    %edx,0x4(%eax)
  8024d0:	eb 08                	jmp    8024da <insert_sorted_allocList+0x15a>
  8024d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d5:	a3 44 40 80 00       	mov    %eax,0x804044
  8024da:	8b 45 08             	mov    0x8(%ebp),%eax
  8024dd:	a3 40 40 80 00       	mov    %eax,0x804040
  8024e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024ec:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8024f1:	40                   	inc    %eax
  8024f2:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  8024f7:	e9 81 00 00 00       	jmp    80257d <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  8024fc:	a1 40 40 80 00       	mov    0x804040,%eax
  802501:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802504:	eb 51                	jmp    802557 <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  802506:	8b 45 08             	mov    0x8(%ebp),%eax
  802509:	8b 50 08             	mov    0x8(%eax),%edx
  80250c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250f:	8b 40 08             	mov    0x8(%eax),%eax
  802512:	39 c2                	cmp    %eax,%edx
  802514:	73 39                	jae    80254f <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  802516:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802519:	8b 40 04             	mov    0x4(%eax),%eax
  80251c:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  80251f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802522:	8b 55 08             	mov    0x8(%ebp),%edx
  802525:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  802527:	8b 45 08             	mov    0x8(%ebp),%eax
  80252a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80252d:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  802530:	8b 45 08             	mov    0x8(%ebp),%eax
  802533:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802536:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  802538:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253b:	8b 55 08             	mov    0x8(%ebp),%edx
  80253e:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  802541:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802546:	40                   	inc    %eax
  802547:	a3 4c 40 80 00       	mov    %eax,0x80404c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  80254c:	90                   	nop
				}
			}
		 }

	}
}
  80254d:	eb 2e                	jmp    80257d <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  80254f:	a1 48 40 80 00       	mov    0x804048,%eax
  802554:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802557:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80255b:	74 07                	je     802564 <insert_sorted_allocList+0x1e4>
  80255d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802560:	8b 00                	mov    (%eax),%eax
  802562:	eb 05                	jmp    802569 <insert_sorted_allocList+0x1e9>
  802564:	b8 00 00 00 00       	mov    $0x0,%eax
  802569:	a3 48 40 80 00       	mov    %eax,0x804048
  80256e:	a1 48 40 80 00       	mov    0x804048,%eax
  802573:	85 c0                	test   %eax,%eax
  802575:	75 8f                	jne    802506 <insert_sorted_allocList+0x186>
  802577:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80257b:	75 89                	jne    802506 <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  80257d:	90                   	nop
  80257e:	c9                   	leave  
  80257f:	c3                   	ret    

00802580 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802580:	55                   	push   %ebp
  802581:	89 e5                	mov    %esp,%ebp
  802583:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802586:	a1 38 41 80 00       	mov    0x804138,%eax
  80258b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80258e:	e9 76 01 00 00       	jmp    802709 <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  802593:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802596:	8b 40 0c             	mov    0xc(%eax),%eax
  802599:	3b 45 08             	cmp    0x8(%ebp),%eax
  80259c:	0f 85 8a 00 00 00    	jne    80262c <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  8025a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025a6:	75 17                	jne    8025bf <alloc_block_FF+0x3f>
  8025a8:	83 ec 04             	sub    $0x4,%esp
  8025ab:	68 ef 3c 80 00       	push   $0x803cef
  8025b0:	68 8a 00 00 00       	push   $0x8a
  8025b5:	68 b3 3c 80 00       	push   $0x803cb3
  8025ba:	e8 33 df ff ff       	call   8004f2 <_panic>
  8025bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c2:	8b 00                	mov    (%eax),%eax
  8025c4:	85 c0                	test   %eax,%eax
  8025c6:	74 10                	je     8025d8 <alloc_block_FF+0x58>
  8025c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cb:	8b 00                	mov    (%eax),%eax
  8025cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025d0:	8b 52 04             	mov    0x4(%edx),%edx
  8025d3:	89 50 04             	mov    %edx,0x4(%eax)
  8025d6:	eb 0b                	jmp    8025e3 <alloc_block_FF+0x63>
  8025d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025db:	8b 40 04             	mov    0x4(%eax),%eax
  8025de:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8025e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e6:	8b 40 04             	mov    0x4(%eax),%eax
  8025e9:	85 c0                	test   %eax,%eax
  8025eb:	74 0f                	je     8025fc <alloc_block_FF+0x7c>
  8025ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f0:	8b 40 04             	mov    0x4(%eax),%eax
  8025f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025f6:	8b 12                	mov    (%edx),%edx
  8025f8:	89 10                	mov    %edx,(%eax)
  8025fa:	eb 0a                	jmp    802606 <alloc_block_FF+0x86>
  8025fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ff:	8b 00                	mov    (%eax),%eax
  802601:	a3 38 41 80 00       	mov    %eax,0x804138
  802606:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802609:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80260f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802612:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802619:	a1 44 41 80 00       	mov    0x804144,%eax
  80261e:	48                   	dec    %eax
  80261f:	a3 44 41 80 00       	mov    %eax,0x804144
			return element;
  802624:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802627:	e9 10 01 00 00       	jmp    80273c <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  80262c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262f:	8b 40 0c             	mov    0xc(%eax),%eax
  802632:	3b 45 08             	cmp    0x8(%ebp),%eax
  802635:	0f 86 c6 00 00 00    	jbe    802701 <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  80263b:	a1 48 41 80 00       	mov    0x804148,%eax
  802640:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802643:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802647:	75 17                	jne    802660 <alloc_block_FF+0xe0>
  802649:	83 ec 04             	sub    $0x4,%esp
  80264c:	68 ef 3c 80 00       	push   $0x803cef
  802651:	68 90 00 00 00       	push   $0x90
  802656:	68 b3 3c 80 00       	push   $0x803cb3
  80265b:	e8 92 de ff ff       	call   8004f2 <_panic>
  802660:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802663:	8b 00                	mov    (%eax),%eax
  802665:	85 c0                	test   %eax,%eax
  802667:	74 10                	je     802679 <alloc_block_FF+0xf9>
  802669:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80266c:	8b 00                	mov    (%eax),%eax
  80266e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802671:	8b 52 04             	mov    0x4(%edx),%edx
  802674:	89 50 04             	mov    %edx,0x4(%eax)
  802677:	eb 0b                	jmp    802684 <alloc_block_FF+0x104>
  802679:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80267c:	8b 40 04             	mov    0x4(%eax),%eax
  80267f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802684:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802687:	8b 40 04             	mov    0x4(%eax),%eax
  80268a:	85 c0                	test   %eax,%eax
  80268c:	74 0f                	je     80269d <alloc_block_FF+0x11d>
  80268e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802691:	8b 40 04             	mov    0x4(%eax),%eax
  802694:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802697:	8b 12                	mov    (%edx),%edx
  802699:	89 10                	mov    %edx,(%eax)
  80269b:	eb 0a                	jmp    8026a7 <alloc_block_FF+0x127>
  80269d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026a0:	8b 00                	mov    (%eax),%eax
  8026a2:	a3 48 41 80 00       	mov    %eax,0x804148
  8026a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026b3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026ba:	a1 54 41 80 00       	mov    0x804154,%eax
  8026bf:	48                   	dec    %eax
  8026c0:	a3 54 41 80 00       	mov    %eax,0x804154
			 element1->size =size;
  8026c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8026cb:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  8026ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d1:	8b 50 08             	mov    0x8(%eax),%edx
  8026d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d7:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  8026da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026dd:	8b 50 08             	mov    0x8(%eax),%edx
  8026e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e3:	01 c2                	add    %eax,%edx
  8026e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e8:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  8026eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8026f1:	2b 45 08             	sub    0x8(%ebp),%eax
  8026f4:	89 c2                	mov    %eax,%edx
  8026f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f9:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  8026fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ff:	eb 3b                	jmp    80273c <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802701:	a1 40 41 80 00       	mov    0x804140,%eax
  802706:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802709:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80270d:	74 07                	je     802716 <alloc_block_FF+0x196>
  80270f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802712:	8b 00                	mov    (%eax),%eax
  802714:	eb 05                	jmp    80271b <alloc_block_FF+0x19b>
  802716:	b8 00 00 00 00       	mov    $0x0,%eax
  80271b:	a3 40 41 80 00       	mov    %eax,0x804140
  802720:	a1 40 41 80 00       	mov    0x804140,%eax
  802725:	85 c0                	test   %eax,%eax
  802727:	0f 85 66 fe ff ff    	jne    802593 <alloc_block_FF+0x13>
  80272d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802731:	0f 85 5c fe ff ff    	jne    802593 <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  802737:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80273c:	c9                   	leave  
  80273d:	c3                   	ret    

0080273e <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80273e:	55                   	push   %ebp
  80273f:	89 e5                	mov    %esp,%ebp
  802741:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  802744:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  80274b:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  802752:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802759:	a1 38 41 80 00       	mov    0x804138,%eax
  80275e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802761:	e9 cf 00 00 00       	jmp    802835 <alloc_block_BF+0xf7>
		{
			c++;
  802766:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  802769:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276c:	8b 40 0c             	mov    0xc(%eax),%eax
  80276f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802772:	0f 85 8a 00 00 00    	jne    802802 <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  802778:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80277c:	75 17                	jne    802795 <alloc_block_BF+0x57>
  80277e:	83 ec 04             	sub    $0x4,%esp
  802781:	68 ef 3c 80 00       	push   $0x803cef
  802786:	68 a8 00 00 00       	push   $0xa8
  80278b:	68 b3 3c 80 00       	push   $0x803cb3
  802790:	e8 5d dd ff ff       	call   8004f2 <_panic>
  802795:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802798:	8b 00                	mov    (%eax),%eax
  80279a:	85 c0                	test   %eax,%eax
  80279c:	74 10                	je     8027ae <alloc_block_BF+0x70>
  80279e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a1:	8b 00                	mov    (%eax),%eax
  8027a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027a6:	8b 52 04             	mov    0x4(%edx),%edx
  8027a9:	89 50 04             	mov    %edx,0x4(%eax)
  8027ac:	eb 0b                	jmp    8027b9 <alloc_block_BF+0x7b>
  8027ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b1:	8b 40 04             	mov    0x4(%eax),%eax
  8027b4:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bc:	8b 40 04             	mov    0x4(%eax),%eax
  8027bf:	85 c0                	test   %eax,%eax
  8027c1:	74 0f                	je     8027d2 <alloc_block_BF+0x94>
  8027c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c6:	8b 40 04             	mov    0x4(%eax),%eax
  8027c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027cc:	8b 12                	mov    (%edx),%edx
  8027ce:	89 10                	mov    %edx,(%eax)
  8027d0:	eb 0a                	jmp    8027dc <alloc_block_BF+0x9e>
  8027d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d5:	8b 00                	mov    (%eax),%eax
  8027d7:	a3 38 41 80 00       	mov    %eax,0x804138
  8027dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027ef:	a1 44 41 80 00       	mov    0x804144,%eax
  8027f4:	48                   	dec    %eax
  8027f5:	a3 44 41 80 00       	mov    %eax,0x804144
				return block;
  8027fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fd:	e9 85 01 00 00       	jmp    802987 <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  802802:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802805:	8b 40 0c             	mov    0xc(%eax),%eax
  802808:	3b 45 08             	cmp    0x8(%ebp),%eax
  80280b:	76 20                	jbe    80282d <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  80280d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802810:	8b 40 0c             	mov    0xc(%eax),%eax
  802813:	2b 45 08             	sub    0x8(%ebp),%eax
  802816:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  802819:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80281c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80281f:	73 0c                	jae    80282d <alloc_block_BF+0xef>
				{
					ma=tempi;
  802821:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802824:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  802827:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80282a:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  80282d:	a1 40 41 80 00       	mov    0x804140,%eax
  802832:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802835:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802839:	74 07                	je     802842 <alloc_block_BF+0x104>
  80283b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283e:	8b 00                	mov    (%eax),%eax
  802840:	eb 05                	jmp    802847 <alloc_block_BF+0x109>
  802842:	b8 00 00 00 00       	mov    $0x0,%eax
  802847:	a3 40 41 80 00       	mov    %eax,0x804140
  80284c:	a1 40 41 80 00       	mov    0x804140,%eax
  802851:	85 c0                	test   %eax,%eax
  802853:	0f 85 0d ff ff ff    	jne    802766 <alloc_block_BF+0x28>
  802859:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80285d:	0f 85 03 ff ff ff    	jne    802766 <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  802863:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  80286a:	a1 38 41 80 00       	mov    0x804138,%eax
  80286f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802872:	e9 dd 00 00 00       	jmp    802954 <alloc_block_BF+0x216>
		{
			if(x==sol)
  802877:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80287a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80287d:	0f 85 c6 00 00 00    	jne    802949 <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802883:	a1 48 41 80 00       	mov    0x804148,%eax
  802888:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  80288b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80288f:	75 17                	jne    8028a8 <alloc_block_BF+0x16a>
  802891:	83 ec 04             	sub    $0x4,%esp
  802894:	68 ef 3c 80 00       	push   $0x803cef
  802899:	68 bb 00 00 00       	push   $0xbb
  80289e:	68 b3 3c 80 00       	push   $0x803cb3
  8028a3:	e8 4a dc ff ff       	call   8004f2 <_panic>
  8028a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028ab:	8b 00                	mov    (%eax),%eax
  8028ad:	85 c0                	test   %eax,%eax
  8028af:	74 10                	je     8028c1 <alloc_block_BF+0x183>
  8028b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028b4:	8b 00                	mov    (%eax),%eax
  8028b6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8028b9:	8b 52 04             	mov    0x4(%edx),%edx
  8028bc:	89 50 04             	mov    %edx,0x4(%eax)
  8028bf:	eb 0b                	jmp    8028cc <alloc_block_BF+0x18e>
  8028c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028c4:	8b 40 04             	mov    0x4(%eax),%eax
  8028c7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8028cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028cf:	8b 40 04             	mov    0x4(%eax),%eax
  8028d2:	85 c0                	test   %eax,%eax
  8028d4:	74 0f                	je     8028e5 <alloc_block_BF+0x1a7>
  8028d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028d9:	8b 40 04             	mov    0x4(%eax),%eax
  8028dc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8028df:	8b 12                	mov    (%edx),%edx
  8028e1:	89 10                	mov    %edx,(%eax)
  8028e3:	eb 0a                	jmp    8028ef <alloc_block_BF+0x1b1>
  8028e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028e8:	8b 00                	mov    (%eax),%eax
  8028ea:	a3 48 41 80 00       	mov    %eax,0x804148
  8028ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028fb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802902:	a1 54 41 80 00       	mov    0x804154,%eax
  802907:	48                   	dec    %eax
  802908:	a3 54 41 80 00       	mov    %eax,0x804154
						 element1->size =size;
  80290d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802910:	8b 55 08             	mov    0x8(%ebp),%edx
  802913:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  802916:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802919:	8b 50 08             	mov    0x8(%eax),%edx
  80291c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80291f:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  802922:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802925:	8b 50 08             	mov    0x8(%eax),%edx
  802928:	8b 45 08             	mov    0x8(%ebp),%eax
  80292b:	01 c2                	add    %eax,%edx
  80292d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802930:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  802933:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802936:	8b 40 0c             	mov    0xc(%eax),%eax
  802939:	2b 45 08             	sub    0x8(%ebp),%eax
  80293c:	89 c2                	mov    %eax,%edx
  80293e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802941:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  802944:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802947:	eb 3e                	jmp    802987 <alloc_block_BF+0x249>
						 break;
			}
			x++;
  802949:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  80294c:	a1 40 41 80 00       	mov    0x804140,%eax
  802951:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802954:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802958:	74 07                	je     802961 <alloc_block_BF+0x223>
  80295a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295d:	8b 00                	mov    (%eax),%eax
  80295f:	eb 05                	jmp    802966 <alloc_block_BF+0x228>
  802961:	b8 00 00 00 00       	mov    $0x0,%eax
  802966:	a3 40 41 80 00       	mov    %eax,0x804140
  80296b:	a1 40 41 80 00       	mov    0x804140,%eax
  802970:	85 c0                	test   %eax,%eax
  802972:	0f 85 ff fe ff ff    	jne    802877 <alloc_block_BF+0x139>
  802978:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80297c:	0f 85 f5 fe ff ff    	jne    802877 <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  802982:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802987:	c9                   	leave  
  802988:	c3                   	ret    

00802989 <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802989:	55                   	push   %ebp
  80298a:	89 e5                	mov    %esp,%ebp
  80298c:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  80298f:	a1 28 40 80 00       	mov    0x804028,%eax
  802994:	85 c0                	test   %eax,%eax
  802996:	75 14                	jne    8029ac <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  802998:	a1 38 41 80 00       	mov    0x804138,%eax
  80299d:	a3 60 41 80 00       	mov    %eax,0x804160
		hh=1;
  8029a2:	c7 05 28 40 80 00 01 	movl   $0x1,0x804028
  8029a9:	00 00 00 
	}
	uint32 c=1;
  8029ac:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  8029b3:	a1 60 41 80 00       	mov    0x804160,%eax
  8029b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  8029bb:	e9 b3 01 00 00       	jmp    802b73 <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  8029c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8029c6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029c9:	0f 85 a9 00 00 00    	jne    802a78 <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  8029cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d2:	8b 00                	mov    (%eax),%eax
  8029d4:	85 c0                	test   %eax,%eax
  8029d6:	75 0c                	jne    8029e4 <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  8029d8:	a1 38 41 80 00       	mov    0x804138,%eax
  8029dd:	a3 60 41 80 00       	mov    %eax,0x804160
  8029e2:	eb 0a                	jmp    8029ee <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  8029e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e7:	8b 00                	mov    (%eax),%eax
  8029e9:	a3 60 41 80 00       	mov    %eax,0x804160
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  8029ee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029f2:	75 17                	jne    802a0b <alloc_block_NF+0x82>
  8029f4:	83 ec 04             	sub    $0x4,%esp
  8029f7:	68 ef 3c 80 00       	push   $0x803cef
  8029fc:	68 e3 00 00 00       	push   $0xe3
  802a01:	68 b3 3c 80 00       	push   $0x803cb3
  802a06:	e8 e7 da ff ff       	call   8004f2 <_panic>
  802a0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a0e:	8b 00                	mov    (%eax),%eax
  802a10:	85 c0                	test   %eax,%eax
  802a12:	74 10                	je     802a24 <alloc_block_NF+0x9b>
  802a14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a17:	8b 00                	mov    (%eax),%eax
  802a19:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a1c:	8b 52 04             	mov    0x4(%edx),%edx
  802a1f:	89 50 04             	mov    %edx,0x4(%eax)
  802a22:	eb 0b                	jmp    802a2f <alloc_block_NF+0xa6>
  802a24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a27:	8b 40 04             	mov    0x4(%eax),%eax
  802a2a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a32:	8b 40 04             	mov    0x4(%eax),%eax
  802a35:	85 c0                	test   %eax,%eax
  802a37:	74 0f                	je     802a48 <alloc_block_NF+0xbf>
  802a39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a3c:	8b 40 04             	mov    0x4(%eax),%eax
  802a3f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a42:	8b 12                	mov    (%edx),%edx
  802a44:	89 10                	mov    %edx,(%eax)
  802a46:	eb 0a                	jmp    802a52 <alloc_block_NF+0xc9>
  802a48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a4b:	8b 00                	mov    (%eax),%eax
  802a4d:	a3 38 41 80 00       	mov    %eax,0x804138
  802a52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a55:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a5e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a65:	a1 44 41 80 00       	mov    0x804144,%eax
  802a6a:	48                   	dec    %eax
  802a6b:	a3 44 41 80 00       	mov    %eax,0x804144
				return element;
  802a70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a73:	e9 0e 01 00 00       	jmp    802b86 <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  802a78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a7b:	8b 40 0c             	mov    0xc(%eax),%eax
  802a7e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a81:	0f 86 ce 00 00 00    	jbe    802b55 <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802a87:	a1 48 41 80 00       	mov    0x804148,%eax
  802a8c:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802a8f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a93:	75 17                	jne    802aac <alloc_block_NF+0x123>
  802a95:	83 ec 04             	sub    $0x4,%esp
  802a98:	68 ef 3c 80 00       	push   $0x803cef
  802a9d:	68 e9 00 00 00       	push   $0xe9
  802aa2:	68 b3 3c 80 00       	push   $0x803cb3
  802aa7:	e8 46 da ff ff       	call   8004f2 <_panic>
  802aac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aaf:	8b 00                	mov    (%eax),%eax
  802ab1:	85 c0                	test   %eax,%eax
  802ab3:	74 10                	je     802ac5 <alloc_block_NF+0x13c>
  802ab5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ab8:	8b 00                	mov    (%eax),%eax
  802aba:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802abd:	8b 52 04             	mov    0x4(%edx),%edx
  802ac0:	89 50 04             	mov    %edx,0x4(%eax)
  802ac3:	eb 0b                	jmp    802ad0 <alloc_block_NF+0x147>
  802ac5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac8:	8b 40 04             	mov    0x4(%eax),%eax
  802acb:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ad0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad3:	8b 40 04             	mov    0x4(%eax),%eax
  802ad6:	85 c0                	test   %eax,%eax
  802ad8:	74 0f                	je     802ae9 <alloc_block_NF+0x160>
  802ada:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802add:	8b 40 04             	mov    0x4(%eax),%eax
  802ae0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ae3:	8b 12                	mov    (%edx),%edx
  802ae5:	89 10                	mov    %edx,(%eax)
  802ae7:	eb 0a                	jmp    802af3 <alloc_block_NF+0x16a>
  802ae9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aec:	8b 00                	mov    (%eax),%eax
  802aee:	a3 48 41 80 00       	mov    %eax,0x804148
  802af3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802afc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b06:	a1 54 41 80 00       	mov    0x804154,%eax
  802b0b:	48                   	dec    %eax
  802b0c:	a3 54 41 80 00       	mov    %eax,0x804154
				 element1->size =size;
  802b11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b14:	8b 55 08             	mov    0x8(%ebp),%edx
  802b17:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  802b1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1d:	8b 50 08             	mov    0x8(%eax),%edx
  802b20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b23:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  802b26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b29:	8b 50 08             	mov    0x8(%eax),%edx
  802b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2f:	01 c2                	add    %eax,%edx
  802b31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b34:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  802b37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b3a:	8b 40 0c             	mov    0xc(%eax),%eax
  802b3d:	2b 45 08             	sub    0x8(%ebp),%eax
  802b40:	89 c2                	mov    %eax,%edx
  802b42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b45:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  802b48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b4b:	a3 60 41 80 00       	mov    %eax,0x804160
				 return element1;
  802b50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b53:	eb 31                	jmp    802b86 <alloc_block_NF+0x1fd>
			 }
		 c++;
  802b55:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  802b58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5b:	8b 00                	mov    (%eax),%eax
  802b5d:	85 c0                	test   %eax,%eax
  802b5f:	75 0a                	jne    802b6b <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  802b61:	a1 38 41 80 00       	mov    0x804138,%eax
  802b66:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802b69:	eb 08                	jmp    802b73 <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  802b6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6e:	8b 00                	mov    (%eax),%eax
  802b70:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802b73:	a1 44 41 80 00       	mov    0x804144,%eax
  802b78:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802b7b:	0f 85 3f fe ff ff    	jne    8029c0 <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  802b81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b86:	c9                   	leave  
  802b87:	c3                   	ret    

00802b88 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802b88:	55                   	push   %ebp
  802b89:	89 e5                	mov    %esp,%ebp
  802b8b:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  802b8e:	a1 44 41 80 00       	mov    0x804144,%eax
  802b93:	85 c0                	test   %eax,%eax
  802b95:	75 68                	jne    802bff <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802b97:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b9b:	75 17                	jne    802bb4 <insert_sorted_with_merge_freeList+0x2c>
  802b9d:	83 ec 04             	sub    $0x4,%esp
  802ba0:	68 90 3c 80 00       	push   $0x803c90
  802ba5:	68 0e 01 00 00       	push   $0x10e
  802baa:	68 b3 3c 80 00       	push   $0x803cb3
  802baf:	e8 3e d9 ff ff       	call   8004f2 <_panic>
  802bb4:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802bba:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbd:	89 10                	mov    %edx,(%eax)
  802bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc2:	8b 00                	mov    (%eax),%eax
  802bc4:	85 c0                	test   %eax,%eax
  802bc6:	74 0d                	je     802bd5 <insert_sorted_with_merge_freeList+0x4d>
  802bc8:	a1 38 41 80 00       	mov    0x804138,%eax
  802bcd:	8b 55 08             	mov    0x8(%ebp),%edx
  802bd0:	89 50 04             	mov    %edx,0x4(%eax)
  802bd3:	eb 08                	jmp    802bdd <insert_sorted_with_merge_freeList+0x55>
  802bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd8:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  802be0:	a3 38 41 80 00       	mov    %eax,0x804138
  802be5:	8b 45 08             	mov    0x8(%ebp),%eax
  802be8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bef:	a1 44 41 80 00       	mov    0x804144,%eax
  802bf4:	40                   	inc    %eax
  802bf5:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802bfa:	e9 8c 06 00 00       	jmp    80328b <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  802bff:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802c04:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  802c07:	a1 38 41 80 00       	mov    0x804138,%eax
  802c0c:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  802c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c12:	8b 50 08             	mov    0x8(%eax),%edx
  802c15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c18:	8b 40 08             	mov    0x8(%eax),%eax
  802c1b:	39 c2                	cmp    %eax,%edx
  802c1d:	0f 86 14 01 00 00    	jbe    802d37 <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  802c23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c26:	8b 50 0c             	mov    0xc(%eax),%edx
  802c29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2c:	8b 40 08             	mov    0x8(%eax),%eax
  802c2f:	01 c2                	add    %eax,%edx
  802c31:	8b 45 08             	mov    0x8(%ebp),%eax
  802c34:	8b 40 08             	mov    0x8(%eax),%eax
  802c37:	39 c2                	cmp    %eax,%edx
  802c39:	0f 85 90 00 00 00    	jne    802ccf <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  802c3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c42:	8b 50 0c             	mov    0xc(%eax),%edx
  802c45:	8b 45 08             	mov    0x8(%ebp),%eax
  802c48:	8b 40 0c             	mov    0xc(%eax),%eax
  802c4b:	01 c2                	add    %eax,%edx
  802c4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c50:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802c53:	8b 45 08             	mov    0x8(%ebp),%eax
  802c56:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c60:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802c67:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c6b:	75 17                	jne    802c84 <insert_sorted_with_merge_freeList+0xfc>
  802c6d:	83 ec 04             	sub    $0x4,%esp
  802c70:	68 90 3c 80 00       	push   $0x803c90
  802c75:	68 1b 01 00 00       	push   $0x11b
  802c7a:	68 b3 3c 80 00       	push   $0x803cb3
  802c7f:	e8 6e d8 ff ff       	call   8004f2 <_panic>
  802c84:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8d:	89 10                	mov    %edx,(%eax)
  802c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c92:	8b 00                	mov    (%eax),%eax
  802c94:	85 c0                	test   %eax,%eax
  802c96:	74 0d                	je     802ca5 <insert_sorted_with_merge_freeList+0x11d>
  802c98:	a1 48 41 80 00       	mov    0x804148,%eax
  802c9d:	8b 55 08             	mov    0x8(%ebp),%edx
  802ca0:	89 50 04             	mov    %edx,0x4(%eax)
  802ca3:	eb 08                	jmp    802cad <insert_sorted_with_merge_freeList+0x125>
  802ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802cad:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb0:	a3 48 41 80 00       	mov    %eax,0x804148
  802cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cbf:	a1 54 41 80 00       	mov    0x804154,%eax
  802cc4:	40                   	inc    %eax
  802cc5:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802cca:	e9 bc 05 00 00       	jmp    80328b <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802ccf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cd3:	75 17                	jne    802cec <insert_sorted_with_merge_freeList+0x164>
  802cd5:	83 ec 04             	sub    $0x4,%esp
  802cd8:	68 cc 3c 80 00       	push   $0x803ccc
  802cdd:	68 1f 01 00 00       	push   $0x11f
  802ce2:	68 b3 3c 80 00       	push   $0x803cb3
  802ce7:	e8 06 d8 ff ff       	call   8004f2 <_panic>
  802cec:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf5:	89 50 04             	mov    %edx,0x4(%eax)
  802cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfb:	8b 40 04             	mov    0x4(%eax),%eax
  802cfe:	85 c0                	test   %eax,%eax
  802d00:	74 0c                	je     802d0e <insert_sorted_with_merge_freeList+0x186>
  802d02:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802d07:	8b 55 08             	mov    0x8(%ebp),%edx
  802d0a:	89 10                	mov    %edx,(%eax)
  802d0c:	eb 08                	jmp    802d16 <insert_sorted_with_merge_freeList+0x18e>
  802d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d11:	a3 38 41 80 00       	mov    %eax,0x804138
  802d16:	8b 45 08             	mov    0x8(%ebp),%eax
  802d19:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d21:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d27:	a1 44 41 80 00       	mov    0x804144,%eax
  802d2c:	40                   	inc    %eax
  802d2d:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802d32:	e9 54 05 00 00       	jmp    80328b <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  802d37:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3a:	8b 50 08             	mov    0x8(%eax),%edx
  802d3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d40:	8b 40 08             	mov    0x8(%eax),%eax
  802d43:	39 c2                	cmp    %eax,%edx
  802d45:	0f 83 20 01 00 00    	jae    802e6b <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  802d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4e:	8b 50 0c             	mov    0xc(%eax),%edx
  802d51:	8b 45 08             	mov    0x8(%ebp),%eax
  802d54:	8b 40 08             	mov    0x8(%eax),%eax
  802d57:	01 c2                	add    %eax,%edx
  802d59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d5c:	8b 40 08             	mov    0x8(%eax),%eax
  802d5f:	39 c2                	cmp    %eax,%edx
  802d61:	0f 85 9c 00 00 00    	jne    802e03 <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  802d67:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6a:	8b 50 08             	mov    0x8(%eax),%edx
  802d6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d70:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  802d73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d76:	8b 50 0c             	mov    0xc(%eax),%edx
  802d79:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7c:	8b 40 0c             	mov    0xc(%eax),%eax
  802d7f:	01 c2                	add    %eax,%edx
  802d81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d84:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802d87:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802d91:	8b 45 08             	mov    0x8(%ebp),%eax
  802d94:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802d9b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d9f:	75 17                	jne    802db8 <insert_sorted_with_merge_freeList+0x230>
  802da1:	83 ec 04             	sub    $0x4,%esp
  802da4:	68 90 3c 80 00       	push   $0x803c90
  802da9:	68 2a 01 00 00       	push   $0x12a
  802dae:	68 b3 3c 80 00       	push   $0x803cb3
  802db3:	e8 3a d7 ff ff       	call   8004f2 <_panic>
  802db8:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc1:	89 10                	mov    %edx,(%eax)
  802dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc6:	8b 00                	mov    (%eax),%eax
  802dc8:	85 c0                	test   %eax,%eax
  802dca:	74 0d                	je     802dd9 <insert_sorted_with_merge_freeList+0x251>
  802dcc:	a1 48 41 80 00       	mov    0x804148,%eax
  802dd1:	8b 55 08             	mov    0x8(%ebp),%edx
  802dd4:	89 50 04             	mov    %edx,0x4(%eax)
  802dd7:	eb 08                	jmp    802de1 <insert_sorted_with_merge_freeList+0x259>
  802dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddc:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802de1:	8b 45 08             	mov    0x8(%ebp),%eax
  802de4:	a3 48 41 80 00       	mov    %eax,0x804148
  802de9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802df3:	a1 54 41 80 00       	mov    0x804154,%eax
  802df8:	40                   	inc    %eax
  802df9:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802dfe:	e9 88 04 00 00       	jmp    80328b <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802e03:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e07:	75 17                	jne    802e20 <insert_sorted_with_merge_freeList+0x298>
  802e09:	83 ec 04             	sub    $0x4,%esp
  802e0c:	68 90 3c 80 00       	push   $0x803c90
  802e11:	68 2e 01 00 00       	push   $0x12e
  802e16:	68 b3 3c 80 00       	push   $0x803cb3
  802e1b:	e8 d2 d6 ff ff       	call   8004f2 <_panic>
  802e20:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802e26:	8b 45 08             	mov    0x8(%ebp),%eax
  802e29:	89 10                	mov    %edx,(%eax)
  802e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2e:	8b 00                	mov    (%eax),%eax
  802e30:	85 c0                	test   %eax,%eax
  802e32:	74 0d                	je     802e41 <insert_sorted_with_merge_freeList+0x2b9>
  802e34:	a1 38 41 80 00       	mov    0x804138,%eax
  802e39:	8b 55 08             	mov    0x8(%ebp),%edx
  802e3c:	89 50 04             	mov    %edx,0x4(%eax)
  802e3f:	eb 08                	jmp    802e49 <insert_sorted_with_merge_freeList+0x2c1>
  802e41:	8b 45 08             	mov    0x8(%ebp),%eax
  802e44:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e49:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4c:	a3 38 41 80 00       	mov    %eax,0x804138
  802e51:	8b 45 08             	mov    0x8(%ebp),%eax
  802e54:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e5b:	a1 44 41 80 00       	mov    0x804144,%eax
  802e60:	40                   	inc    %eax
  802e61:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802e66:	e9 20 04 00 00       	jmp    80328b <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  802e6b:	a1 38 41 80 00       	mov    0x804138,%eax
  802e70:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e73:	e9 e2 03 00 00       	jmp    80325a <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  802e78:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7b:	8b 50 08             	mov    0x8(%eax),%edx
  802e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e81:	8b 40 08             	mov    0x8(%eax),%eax
  802e84:	39 c2                	cmp    %eax,%edx
  802e86:	0f 83 c6 03 00 00    	jae    803252 <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  802e8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8f:	8b 40 04             	mov    0x4(%eax),%eax
  802e92:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  802e95:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e98:	8b 50 08             	mov    0x8(%eax),%edx
  802e9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e9e:	8b 40 0c             	mov    0xc(%eax),%eax
  802ea1:	01 d0                	add    %edx,%eax
  802ea3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  802ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea9:	8b 50 0c             	mov    0xc(%eax),%edx
  802eac:	8b 45 08             	mov    0x8(%ebp),%eax
  802eaf:	8b 40 08             	mov    0x8(%eax),%eax
  802eb2:	01 d0                	add    %edx,%eax
  802eb4:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  802eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eba:	8b 40 08             	mov    0x8(%eax),%eax
  802ebd:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802ec0:	74 7a                	je     802f3c <insert_sorted_with_merge_freeList+0x3b4>
  802ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec5:	8b 40 08             	mov    0x8(%eax),%eax
  802ec8:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802ecb:	74 6f                	je     802f3c <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  802ecd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ed1:	74 06                	je     802ed9 <insert_sorted_with_merge_freeList+0x351>
  802ed3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ed7:	75 17                	jne    802ef0 <insert_sorted_with_merge_freeList+0x368>
  802ed9:	83 ec 04             	sub    $0x4,%esp
  802edc:	68 10 3d 80 00       	push   $0x803d10
  802ee1:	68 43 01 00 00       	push   $0x143
  802ee6:	68 b3 3c 80 00       	push   $0x803cb3
  802eeb:	e8 02 d6 ff ff       	call   8004f2 <_panic>
  802ef0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef3:	8b 50 04             	mov    0x4(%eax),%edx
  802ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef9:	89 50 04             	mov    %edx,0x4(%eax)
  802efc:	8b 45 08             	mov    0x8(%ebp),%eax
  802eff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f02:	89 10                	mov    %edx,(%eax)
  802f04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f07:	8b 40 04             	mov    0x4(%eax),%eax
  802f0a:	85 c0                	test   %eax,%eax
  802f0c:	74 0d                	je     802f1b <insert_sorted_with_merge_freeList+0x393>
  802f0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f11:	8b 40 04             	mov    0x4(%eax),%eax
  802f14:	8b 55 08             	mov    0x8(%ebp),%edx
  802f17:	89 10                	mov    %edx,(%eax)
  802f19:	eb 08                	jmp    802f23 <insert_sorted_with_merge_freeList+0x39b>
  802f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1e:	a3 38 41 80 00       	mov    %eax,0x804138
  802f23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f26:	8b 55 08             	mov    0x8(%ebp),%edx
  802f29:	89 50 04             	mov    %edx,0x4(%eax)
  802f2c:	a1 44 41 80 00       	mov    0x804144,%eax
  802f31:	40                   	inc    %eax
  802f32:	a3 44 41 80 00       	mov    %eax,0x804144
  802f37:	e9 14 03 00 00       	jmp    803250 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  802f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3f:	8b 40 08             	mov    0x8(%eax),%eax
  802f42:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802f45:	0f 85 a0 01 00 00    	jne    8030eb <insert_sorted_with_merge_freeList+0x563>
  802f4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4e:	8b 40 08             	mov    0x8(%eax),%eax
  802f51:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802f54:	0f 85 91 01 00 00    	jne    8030eb <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  802f5a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f5d:	8b 50 0c             	mov    0xc(%eax),%edx
  802f60:	8b 45 08             	mov    0x8(%ebp),%eax
  802f63:	8b 48 0c             	mov    0xc(%eax),%ecx
  802f66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f69:	8b 40 0c             	mov    0xc(%eax),%eax
  802f6c:	01 c8                	add    %ecx,%eax
  802f6e:	01 c2                	add    %eax,%edx
  802f70:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f73:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802f76:	8b 45 08             	mov    0x8(%ebp),%eax
  802f79:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802f80:	8b 45 08             	mov    0x8(%ebp),%eax
  802f83:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  802f8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  802f94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f97:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802f9e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fa2:	75 17                	jne    802fbb <insert_sorted_with_merge_freeList+0x433>
  802fa4:	83 ec 04             	sub    $0x4,%esp
  802fa7:	68 90 3c 80 00       	push   $0x803c90
  802fac:	68 4d 01 00 00       	push   $0x14d
  802fb1:	68 b3 3c 80 00       	push   $0x803cb3
  802fb6:	e8 37 d5 ff ff       	call   8004f2 <_panic>
  802fbb:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc4:	89 10                	mov    %edx,(%eax)
  802fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc9:	8b 00                	mov    (%eax),%eax
  802fcb:	85 c0                	test   %eax,%eax
  802fcd:	74 0d                	je     802fdc <insert_sorted_with_merge_freeList+0x454>
  802fcf:	a1 48 41 80 00       	mov    0x804148,%eax
  802fd4:	8b 55 08             	mov    0x8(%ebp),%edx
  802fd7:	89 50 04             	mov    %edx,0x4(%eax)
  802fda:	eb 08                	jmp    802fe4 <insert_sorted_with_merge_freeList+0x45c>
  802fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdf:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe7:	a3 48 41 80 00       	mov    %eax,0x804148
  802fec:	8b 45 08             	mov    0x8(%ebp),%eax
  802fef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ff6:	a1 54 41 80 00       	mov    0x804154,%eax
  802ffb:	40                   	inc    %eax
  802ffc:	a3 54 41 80 00       	mov    %eax,0x804154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  803001:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803005:	75 17                	jne    80301e <insert_sorted_with_merge_freeList+0x496>
  803007:	83 ec 04             	sub    $0x4,%esp
  80300a:	68 ef 3c 80 00       	push   $0x803cef
  80300f:	68 4e 01 00 00       	push   $0x14e
  803014:	68 b3 3c 80 00       	push   $0x803cb3
  803019:	e8 d4 d4 ff ff       	call   8004f2 <_panic>
  80301e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803021:	8b 00                	mov    (%eax),%eax
  803023:	85 c0                	test   %eax,%eax
  803025:	74 10                	je     803037 <insert_sorted_with_merge_freeList+0x4af>
  803027:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302a:	8b 00                	mov    (%eax),%eax
  80302c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80302f:	8b 52 04             	mov    0x4(%edx),%edx
  803032:	89 50 04             	mov    %edx,0x4(%eax)
  803035:	eb 0b                	jmp    803042 <insert_sorted_with_merge_freeList+0x4ba>
  803037:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303a:	8b 40 04             	mov    0x4(%eax),%eax
  80303d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803042:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803045:	8b 40 04             	mov    0x4(%eax),%eax
  803048:	85 c0                	test   %eax,%eax
  80304a:	74 0f                	je     80305b <insert_sorted_with_merge_freeList+0x4d3>
  80304c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304f:	8b 40 04             	mov    0x4(%eax),%eax
  803052:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803055:	8b 12                	mov    (%edx),%edx
  803057:	89 10                	mov    %edx,(%eax)
  803059:	eb 0a                	jmp    803065 <insert_sorted_with_merge_freeList+0x4dd>
  80305b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305e:	8b 00                	mov    (%eax),%eax
  803060:	a3 38 41 80 00       	mov    %eax,0x804138
  803065:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803068:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80306e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803071:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803078:	a1 44 41 80 00       	mov    0x804144,%eax
  80307d:	48                   	dec    %eax
  80307e:	a3 44 41 80 00       	mov    %eax,0x804144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  803083:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803087:	75 17                	jne    8030a0 <insert_sorted_with_merge_freeList+0x518>
  803089:	83 ec 04             	sub    $0x4,%esp
  80308c:	68 90 3c 80 00       	push   $0x803c90
  803091:	68 4f 01 00 00       	push   $0x14f
  803096:	68 b3 3c 80 00       	push   $0x803cb3
  80309b:	e8 52 d4 ff ff       	call   8004f2 <_panic>
  8030a0:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8030a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a9:	89 10                	mov    %edx,(%eax)
  8030ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ae:	8b 00                	mov    (%eax),%eax
  8030b0:	85 c0                	test   %eax,%eax
  8030b2:	74 0d                	je     8030c1 <insert_sorted_with_merge_freeList+0x539>
  8030b4:	a1 48 41 80 00       	mov    0x804148,%eax
  8030b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030bc:	89 50 04             	mov    %edx,0x4(%eax)
  8030bf:	eb 08                	jmp    8030c9 <insert_sorted_with_merge_freeList+0x541>
  8030c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c4:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8030c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cc:	a3 48 41 80 00       	mov    %eax,0x804148
  8030d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030db:	a1 54 41 80 00       	mov    0x804154,%eax
  8030e0:	40                   	inc    %eax
  8030e1:	a3 54 41 80 00       	mov    %eax,0x804154
  8030e6:	e9 65 01 00 00       	jmp    803250 <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  8030eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ee:	8b 40 08             	mov    0x8(%eax),%eax
  8030f1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8030f4:	0f 85 9f 00 00 00    	jne    803199 <insert_sorted_with_merge_freeList+0x611>
  8030fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fd:	8b 40 08             	mov    0x8(%eax),%eax
  803100:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803103:	0f 84 90 00 00 00    	je     803199 <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  803109:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80310c:	8b 50 0c             	mov    0xc(%eax),%edx
  80310f:	8b 45 08             	mov    0x8(%ebp),%eax
  803112:	8b 40 0c             	mov    0xc(%eax),%eax
  803115:	01 c2                	add    %eax,%edx
  803117:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80311a:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  80311d:	8b 45 08             	mov    0x8(%ebp),%eax
  803120:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  803127:	8b 45 08             	mov    0x8(%ebp),%eax
  80312a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803131:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803135:	75 17                	jne    80314e <insert_sorted_with_merge_freeList+0x5c6>
  803137:	83 ec 04             	sub    $0x4,%esp
  80313a:	68 90 3c 80 00       	push   $0x803c90
  80313f:	68 58 01 00 00       	push   $0x158
  803144:	68 b3 3c 80 00       	push   $0x803cb3
  803149:	e8 a4 d3 ff ff       	call   8004f2 <_panic>
  80314e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803154:	8b 45 08             	mov    0x8(%ebp),%eax
  803157:	89 10                	mov    %edx,(%eax)
  803159:	8b 45 08             	mov    0x8(%ebp),%eax
  80315c:	8b 00                	mov    (%eax),%eax
  80315e:	85 c0                	test   %eax,%eax
  803160:	74 0d                	je     80316f <insert_sorted_with_merge_freeList+0x5e7>
  803162:	a1 48 41 80 00       	mov    0x804148,%eax
  803167:	8b 55 08             	mov    0x8(%ebp),%edx
  80316a:	89 50 04             	mov    %edx,0x4(%eax)
  80316d:	eb 08                	jmp    803177 <insert_sorted_with_merge_freeList+0x5ef>
  80316f:	8b 45 08             	mov    0x8(%ebp),%eax
  803172:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803177:	8b 45 08             	mov    0x8(%ebp),%eax
  80317a:	a3 48 41 80 00       	mov    %eax,0x804148
  80317f:	8b 45 08             	mov    0x8(%ebp),%eax
  803182:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803189:	a1 54 41 80 00       	mov    0x804154,%eax
  80318e:	40                   	inc    %eax
  80318f:	a3 54 41 80 00       	mov    %eax,0x804154
  803194:	e9 b7 00 00 00       	jmp    803250 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  803199:	8b 45 08             	mov    0x8(%ebp),%eax
  80319c:	8b 40 08             	mov    0x8(%eax),%eax
  80319f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8031a2:	0f 84 e2 00 00 00    	je     80328a <insert_sorted_with_merge_freeList+0x702>
  8031a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ab:	8b 40 08             	mov    0x8(%eax),%eax
  8031ae:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8031b1:	0f 85 d3 00 00 00    	jne    80328a <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  8031b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ba:	8b 50 08             	mov    0x8(%eax),%edx
  8031bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c0:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  8031c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c6:	8b 50 0c             	mov    0xc(%eax),%edx
  8031c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8031cf:	01 c2                	add    %eax,%edx
  8031d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d4:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  8031d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031da:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  8031e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8031eb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031ef:	75 17                	jne    803208 <insert_sorted_with_merge_freeList+0x680>
  8031f1:	83 ec 04             	sub    $0x4,%esp
  8031f4:	68 90 3c 80 00       	push   $0x803c90
  8031f9:	68 61 01 00 00       	push   $0x161
  8031fe:	68 b3 3c 80 00       	push   $0x803cb3
  803203:	e8 ea d2 ff ff       	call   8004f2 <_panic>
  803208:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80320e:	8b 45 08             	mov    0x8(%ebp),%eax
  803211:	89 10                	mov    %edx,(%eax)
  803213:	8b 45 08             	mov    0x8(%ebp),%eax
  803216:	8b 00                	mov    (%eax),%eax
  803218:	85 c0                	test   %eax,%eax
  80321a:	74 0d                	je     803229 <insert_sorted_with_merge_freeList+0x6a1>
  80321c:	a1 48 41 80 00       	mov    0x804148,%eax
  803221:	8b 55 08             	mov    0x8(%ebp),%edx
  803224:	89 50 04             	mov    %edx,0x4(%eax)
  803227:	eb 08                	jmp    803231 <insert_sorted_with_merge_freeList+0x6a9>
  803229:	8b 45 08             	mov    0x8(%ebp),%eax
  80322c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803231:	8b 45 08             	mov    0x8(%ebp),%eax
  803234:	a3 48 41 80 00       	mov    %eax,0x804148
  803239:	8b 45 08             	mov    0x8(%ebp),%eax
  80323c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803243:	a1 54 41 80 00       	mov    0x804154,%eax
  803248:	40                   	inc    %eax
  803249:	a3 54 41 80 00       	mov    %eax,0x804154
								}
								break;
  80324e:	eb 3a                	jmp    80328a <insert_sorted_with_merge_freeList+0x702>
  803250:	eb 38                	jmp    80328a <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  803252:	a1 40 41 80 00       	mov    0x804140,%eax
  803257:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80325a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80325e:	74 07                	je     803267 <insert_sorted_with_merge_freeList+0x6df>
  803260:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803263:	8b 00                	mov    (%eax),%eax
  803265:	eb 05                	jmp    80326c <insert_sorted_with_merge_freeList+0x6e4>
  803267:	b8 00 00 00 00       	mov    $0x0,%eax
  80326c:	a3 40 41 80 00       	mov    %eax,0x804140
  803271:	a1 40 41 80 00       	mov    0x804140,%eax
  803276:	85 c0                	test   %eax,%eax
  803278:	0f 85 fa fb ff ff    	jne    802e78 <insert_sorted_with_merge_freeList+0x2f0>
  80327e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803282:	0f 85 f0 fb ff ff    	jne    802e78 <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  803288:	eb 01                	jmp    80328b <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  80328a:	90                   	nop
							}

						}
		          }
		}
}
  80328b:	90                   	nop
  80328c:	c9                   	leave  
  80328d:	c3                   	ret    
  80328e:	66 90                	xchg   %ax,%ax

00803290 <__udivdi3>:
  803290:	55                   	push   %ebp
  803291:	57                   	push   %edi
  803292:	56                   	push   %esi
  803293:	53                   	push   %ebx
  803294:	83 ec 1c             	sub    $0x1c,%esp
  803297:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80329b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80329f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8032a3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8032a7:	89 ca                	mov    %ecx,%edx
  8032a9:	89 f8                	mov    %edi,%eax
  8032ab:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8032af:	85 f6                	test   %esi,%esi
  8032b1:	75 2d                	jne    8032e0 <__udivdi3+0x50>
  8032b3:	39 cf                	cmp    %ecx,%edi
  8032b5:	77 65                	ja     80331c <__udivdi3+0x8c>
  8032b7:	89 fd                	mov    %edi,%ebp
  8032b9:	85 ff                	test   %edi,%edi
  8032bb:	75 0b                	jne    8032c8 <__udivdi3+0x38>
  8032bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8032c2:	31 d2                	xor    %edx,%edx
  8032c4:	f7 f7                	div    %edi
  8032c6:	89 c5                	mov    %eax,%ebp
  8032c8:	31 d2                	xor    %edx,%edx
  8032ca:	89 c8                	mov    %ecx,%eax
  8032cc:	f7 f5                	div    %ebp
  8032ce:	89 c1                	mov    %eax,%ecx
  8032d0:	89 d8                	mov    %ebx,%eax
  8032d2:	f7 f5                	div    %ebp
  8032d4:	89 cf                	mov    %ecx,%edi
  8032d6:	89 fa                	mov    %edi,%edx
  8032d8:	83 c4 1c             	add    $0x1c,%esp
  8032db:	5b                   	pop    %ebx
  8032dc:	5e                   	pop    %esi
  8032dd:	5f                   	pop    %edi
  8032de:	5d                   	pop    %ebp
  8032df:	c3                   	ret    
  8032e0:	39 ce                	cmp    %ecx,%esi
  8032e2:	77 28                	ja     80330c <__udivdi3+0x7c>
  8032e4:	0f bd fe             	bsr    %esi,%edi
  8032e7:	83 f7 1f             	xor    $0x1f,%edi
  8032ea:	75 40                	jne    80332c <__udivdi3+0x9c>
  8032ec:	39 ce                	cmp    %ecx,%esi
  8032ee:	72 0a                	jb     8032fa <__udivdi3+0x6a>
  8032f0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8032f4:	0f 87 9e 00 00 00    	ja     803398 <__udivdi3+0x108>
  8032fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8032ff:	89 fa                	mov    %edi,%edx
  803301:	83 c4 1c             	add    $0x1c,%esp
  803304:	5b                   	pop    %ebx
  803305:	5e                   	pop    %esi
  803306:	5f                   	pop    %edi
  803307:	5d                   	pop    %ebp
  803308:	c3                   	ret    
  803309:	8d 76 00             	lea    0x0(%esi),%esi
  80330c:	31 ff                	xor    %edi,%edi
  80330e:	31 c0                	xor    %eax,%eax
  803310:	89 fa                	mov    %edi,%edx
  803312:	83 c4 1c             	add    $0x1c,%esp
  803315:	5b                   	pop    %ebx
  803316:	5e                   	pop    %esi
  803317:	5f                   	pop    %edi
  803318:	5d                   	pop    %ebp
  803319:	c3                   	ret    
  80331a:	66 90                	xchg   %ax,%ax
  80331c:	89 d8                	mov    %ebx,%eax
  80331e:	f7 f7                	div    %edi
  803320:	31 ff                	xor    %edi,%edi
  803322:	89 fa                	mov    %edi,%edx
  803324:	83 c4 1c             	add    $0x1c,%esp
  803327:	5b                   	pop    %ebx
  803328:	5e                   	pop    %esi
  803329:	5f                   	pop    %edi
  80332a:	5d                   	pop    %ebp
  80332b:	c3                   	ret    
  80332c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803331:	89 eb                	mov    %ebp,%ebx
  803333:	29 fb                	sub    %edi,%ebx
  803335:	89 f9                	mov    %edi,%ecx
  803337:	d3 e6                	shl    %cl,%esi
  803339:	89 c5                	mov    %eax,%ebp
  80333b:	88 d9                	mov    %bl,%cl
  80333d:	d3 ed                	shr    %cl,%ebp
  80333f:	89 e9                	mov    %ebp,%ecx
  803341:	09 f1                	or     %esi,%ecx
  803343:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803347:	89 f9                	mov    %edi,%ecx
  803349:	d3 e0                	shl    %cl,%eax
  80334b:	89 c5                	mov    %eax,%ebp
  80334d:	89 d6                	mov    %edx,%esi
  80334f:	88 d9                	mov    %bl,%cl
  803351:	d3 ee                	shr    %cl,%esi
  803353:	89 f9                	mov    %edi,%ecx
  803355:	d3 e2                	shl    %cl,%edx
  803357:	8b 44 24 08          	mov    0x8(%esp),%eax
  80335b:	88 d9                	mov    %bl,%cl
  80335d:	d3 e8                	shr    %cl,%eax
  80335f:	09 c2                	or     %eax,%edx
  803361:	89 d0                	mov    %edx,%eax
  803363:	89 f2                	mov    %esi,%edx
  803365:	f7 74 24 0c          	divl   0xc(%esp)
  803369:	89 d6                	mov    %edx,%esi
  80336b:	89 c3                	mov    %eax,%ebx
  80336d:	f7 e5                	mul    %ebp
  80336f:	39 d6                	cmp    %edx,%esi
  803371:	72 19                	jb     80338c <__udivdi3+0xfc>
  803373:	74 0b                	je     803380 <__udivdi3+0xf0>
  803375:	89 d8                	mov    %ebx,%eax
  803377:	31 ff                	xor    %edi,%edi
  803379:	e9 58 ff ff ff       	jmp    8032d6 <__udivdi3+0x46>
  80337e:	66 90                	xchg   %ax,%ax
  803380:	8b 54 24 08          	mov    0x8(%esp),%edx
  803384:	89 f9                	mov    %edi,%ecx
  803386:	d3 e2                	shl    %cl,%edx
  803388:	39 c2                	cmp    %eax,%edx
  80338a:	73 e9                	jae    803375 <__udivdi3+0xe5>
  80338c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80338f:	31 ff                	xor    %edi,%edi
  803391:	e9 40 ff ff ff       	jmp    8032d6 <__udivdi3+0x46>
  803396:	66 90                	xchg   %ax,%ax
  803398:	31 c0                	xor    %eax,%eax
  80339a:	e9 37 ff ff ff       	jmp    8032d6 <__udivdi3+0x46>
  80339f:	90                   	nop

008033a0 <__umoddi3>:
  8033a0:	55                   	push   %ebp
  8033a1:	57                   	push   %edi
  8033a2:	56                   	push   %esi
  8033a3:	53                   	push   %ebx
  8033a4:	83 ec 1c             	sub    $0x1c,%esp
  8033a7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8033ab:	8b 74 24 34          	mov    0x34(%esp),%esi
  8033af:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8033b3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8033b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8033bb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8033bf:	89 f3                	mov    %esi,%ebx
  8033c1:	89 fa                	mov    %edi,%edx
  8033c3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8033c7:	89 34 24             	mov    %esi,(%esp)
  8033ca:	85 c0                	test   %eax,%eax
  8033cc:	75 1a                	jne    8033e8 <__umoddi3+0x48>
  8033ce:	39 f7                	cmp    %esi,%edi
  8033d0:	0f 86 a2 00 00 00    	jbe    803478 <__umoddi3+0xd8>
  8033d6:	89 c8                	mov    %ecx,%eax
  8033d8:	89 f2                	mov    %esi,%edx
  8033da:	f7 f7                	div    %edi
  8033dc:	89 d0                	mov    %edx,%eax
  8033de:	31 d2                	xor    %edx,%edx
  8033e0:	83 c4 1c             	add    $0x1c,%esp
  8033e3:	5b                   	pop    %ebx
  8033e4:	5e                   	pop    %esi
  8033e5:	5f                   	pop    %edi
  8033e6:	5d                   	pop    %ebp
  8033e7:	c3                   	ret    
  8033e8:	39 f0                	cmp    %esi,%eax
  8033ea:	0f 87 ac 00 00 00    	ja     80349c <__umoddi3+0xfc>
  8033f0:	0f bd e8             	bsr    %eax,%ebp
  8033f3:	83 f5 1f             	xor    $0x1f,%ebp
  8033f6:	0f 84 ac 00 00 00    	je     8034a8 <__umoddi3+0x108>
  8033fc:	bf 20 00 00 00       	mov    $0x20,%edi
  803401:	29 ef                	sub    %ebp,%edi
  803403:	89 fe                	mov    %edi,%esi
  803405:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803409:	89 e9                	mov    %ebp,%ecx
  80340b:	d3 e0                	shl    %cl,%eax
  80340d:	89 d7                	mov    %edx,%edi
  80340f:	89 f1                	mov    %esi,%ecx
  803411:	d3 ef                	shr    %cl,%edi
  803413:	09 c7                	or     %eax,%edi
  803415:	89 e9                	mov    %ebp,%ecx
  803417:	d3 e2                	shl    %cl,%edx
  803419:	89 14 24             	mov    %edx,(%esp)
  80341c:	89 d8                	mov    %ebx,%eax
  80341e:	d3 e0                	shl    %cl,%eax
  803420:	89 c2                	mov    %eax,%edx
  803422:	8b 44 24 08          	mov    0x8(%esp),%eax
  803426:	d3 e0                	shl    %cl,%eax
  803428:	89 44 24 04          	mov    %eax,0x4(%esp)
  80342c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803430:	89 f1                	mov    %esi,%ecx
  803432:	d3 e8                	shr    %cl,%eax
  803434:	09 d0                	or     %edx,%eax
  803436:	d3 eb                	shr    %cl,%ebx
  803438:	89 da                	mov    %ebx,%edx
  80343a:	f7 f7                	div    %edi
  80343c:	89 d3                	mov    %edx,%ebx
  80343e:	f7 24 24             	mull   (%esp)
  803441:	89 c6                	mov    %eax,%esi
  803443:	89 d1                	mov    %edx,%ecx
  803445:	39 d3                	cmp    %edx,%ebx
  803447:	0f 82 87 00 00 00    	jb     8034d4 <__umoddi3+0x134>
  80344d:	0f 84 91 00 00 00    	je     8034e4 <__umoddi3+0x144>
  803453:	8b 54 24 04          	mov    0x4(%esp),%edx
  803457:	29 f2                	sub    %esi,%edx
  803459:	19 cb                	sbb    %ecx,%ebx
  80345b:	89 d8                	mov    %ebx,%eax
  80345d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803461:	d3 e0                	shl    %cl,%eax
  803463:	89 e9                	mov    %ebp,%ecx
  803465:	d3 ea                	shr    %cl,%edx
  803467:	09 d0                	or     %edx,%eax
  803469:	89 e9                	mov    %ebp,%ecx
  80346b:	d3 eb                	shr    %cl,%ebx
  80346d:	89 da                	mov    %ebx,%edx
  80346f:	83 c4 1c             	add    $0x1c,%esp
  803472:	5b                   	pop    %ebx
  803473:	5e                   	pop    %esi
  803474:	5f                   	pop    %edi
  803475:	5d                   	pop    %ebp
  803476:	c3                   	ret    
  803477:	90                   	nop
  803478:	89 fd                	mov    %edi,%ebp
  80347a:	85 ff                	test   %edi,%edi
  80347c:	75 0b                	jne    803489 <__umoddi3+0xe9>
  80347e:	b8 01 00 00 00       	mov    $0x1,%eax
  803483:	31 d2                	xor    %edx,%edx
  803485:	f7 f7                	div    %edi
  803487:	89 c5                	mov    %eax,%ebp
  803489:	89 f0                	mov    %esi,%eax
  80348b:	31 d2                	xor    %edx,%edx
  80348d:	f7 f5                	div    %ebp
  80348f:	89 c8                	mov    %ecx,%eax
  803491:	f7 f5                	div    %ebp
  803493:	89 d0                	mov    %edx,%eax
  803495:	e9 44 ff ff ff       	jmp    8033de <__umoddi3+0x3e>
  80349a:	66 90                	xchg   %ax,%ax
  80349c:	89 c8                	mov    %ecx,%eax
  80349e:	89 f2                	mov    %esi,%edx
  8034a0:	83 c4 1c             	add    $0x1c,%esp
  8034a3:	5b                   	pop    %ebx
  8034a4:	5e                   	pop    %esi
  8034a5:	5f                   	pop    %edi
  8034a6:	5d                   	pop    %ebp
  8034a7:	c3                   	ret    
  8034a8:	3b 04 24             	cmp    (%esp),%eax
  8034ab:	72 06                	jb     8034b3 <__umoddi3+0x113>
  8034ad:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8034b1:	77 0f                	ja     8034c2 <__umoddi3+0x122>
  8034b3:	89 f2                	mov    %esi,%edx
  8034b5:	29 f9                	sub    %edi,%ecx
  8034b7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8034bb:	89 14 24             	mov    %edx,(%esp)
  8034be:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8034c2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8034c6:	8b 14 24             	mov    (%esp),%edx
  8034c9:	83 c4 1c             	add    $0x1c,%esp
  8034cc:	5b                   	pop    %ebx
  8034cd:	5e                   	pop    %esi
  8034ce:	5f                   	pop    %edi
  8034cf:	5d                   	pop    %ebp
  8034d0:	c3                   	ret    
  8034d1:	8d 76 00             	lea    0x0(%esi),%esi
  8034d4:	2b 04 24             	sub    (%esp),%eax
  8034d7:	19 fa                	sbb    %edi,%edx
  8034d9:	89 d1                	mov    %edx,%ecx
  8034db:	89 c6                	mov    %eax,%esi
  8034dd:	e9 71 ff ff ff       	jmp    803453 <__umoddi3+0xb3>
  8034e2:	66 90                	xchg   %ax,%ax
  8034e4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8034e8:	72 ea                	jb     8034d4 <__umoddi3+0x134>
  8034ea:	89 d9                	mov    %ebx,%ecx
  8034ec:	e9 62 ff ff ff       	jmp    803453 <__umoddi3+0xb3>

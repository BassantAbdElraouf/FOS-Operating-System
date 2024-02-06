
obj/user/tst_air:     file format elf32-i386


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
  800031:	e8 15 0b 00 00       	call   800b4b <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <user/air.h>
int find(int* arr, int size, int val);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec fc 01 00 00    	sub    $0x1fc,%esp
	int envID = sys_getenvid();
  800044:	e8 55 25 00 00       	call   80259e <sys_getenvid>
  800049:	89 45 bc             	mov    %eax,-0x44(%ebp)

	// *************************************************************************************************
	/// Shared Variables Region ************************************************************************
	// *************************************************************************************************

	int numOfCustomers = 15;
  80004c:	c7 45 b8 0f 00 00 00 	movl   $0xf,-0x48(%ebp)
	int flight1Customers = 3;
  800053:	c7 45 b4 03 00 00 00 	movl   $0x3,-0x4c(%ebp)
	int flight2Customers = 8;
  80005a:	c7 45 b0 08 00 00 00 	movl   $0x8,-0x50(%ebp)
	int flight3Customers = 4;
  800061:	c7 45 ac 04 00 00 00 	movl   $0x4,-0x54(%ebp)

	int flight1NumOfTickets = 8;
  800068:	c7 45 a8 08 00 00 00 	movl   $0x8,-0x58(%ebp)
	int flight2NumOfTickets = 15;
  80006f:	c7 45 a4 0f 00 00 00 	movl   $0xf,-0x5c(%ebp)

	char _customers[] = "customers";
  800076:	8d 85 6a ff ff ff    	lea    -0x96(%ebp),%eax
  80007c:	bb 16 40 80 00       	mov    $0x804016,%ebx
  800081:	ba 0a 00 00 00       	mov    $0xa,%edx
  800086:	89 c7                	mov    %eax,%edi
  800088:	89 de                	mov    %ebx,%esi
  80008a:	89 d1                	mov    %edx,%ecx
  80008c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  80008e:	8d 85 5e ff ff ff    	lea    -0xa2(%ebp),%eax
  800094:	bb 20 40 80 00       	mov    $0x804020,%ebx
  800099:	ba 03 00 00 00       	mov    $0x3,%edx
  80009e:	89 c7                	mov    %eax,%edi
  8000a0:	89 de                	mov    %ebx,%esi
  8000a2:	89 d1                	mov    %edx,%ecx
  8000a4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  8000a6:	8d 85 4f ff ff ff    	lea    -0xb1(%ebp),%eax
  8000ac:	bb 2c 40 80 00       	mov    $0x80402c,%ebx
  8000b1:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000b6:	89 c7                	mov    %eax,%edi
  8000b8:	89 de                	mov    %ebx,%esi
  8000ba:	89 d1                	mov    %edx,%ecx
  8000bc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  8000be:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
  8000c4:	bb 3b 40 80 00       	mov    $0x80403b,%ebx
  8000c9:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000ce:	89 c7                	mov    %eax,%edi
  8000d0:	89 de                	mov    %ebx,%esi
  8000d2:	89 d1                	mov    %edx,%ecx
  8000d4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000d6:	8d 85 2b ff ff ff    	lea    -0xd5(%ebp),%eax
  8000dc:	bb 4a 40 80 00       	mov    $0x80404a,%ebx
  8000e1:	ba 15 00 00 00       	mov    $0x15,%edx
  8000e6:	89 c7                	mov    %eax,%edi
  8000e8:	89 de                	mov    %ebx,%esi
  8000ea:	89 d1                	mov    %edx,%ecx
  8000ec:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000ee:	8d 85 16 ff ff ff    	lea    -0xea(%ebp),%eax
  8000f4:	bb 5f 40 80 00       	mov    $0x80405f,%ebx
  8000f9:	ba 15 00 00 00       	mov    $0x15,%edx
  8000fe:	89 c7                	mov    %eax,%edi
  800100:	89 de                	mov    %ebx,%esi
  800102:	89 d1                	mov    %edx,%ecx
  800104:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  800106:	8d 85 05 ff ff ff    	lea    -0xfb(%ebp),%eax
  80010c:	bb 74 40 80 00       	mov    $0x804074,%ebx
  800111:	ba 11 00 00 00       	mov    $0x11,%edx
  800116:	89 c7                	mov    %eax,%edi
  800118:	89 de                	mov    %ebx,%esi
  80011a:	89 d1                	mov    %edx,%ecx
  80011c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  80011e:	8d 85 f4 fe ff ff    	lea    -0x10c(%ebp),%eax
  800124:	bb 85 40 80 00       	mov    $0x804085,%ebx
  800129:	ba 11 00 00 00       	mov    $0x11,%edx
  80012e:	89 c7                	mov    %eax,%edi
  800130:	89 de                	mov    %ebx,%esi
  800132:	89 d1                	mov    %edx,%ecx
  800134:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  800136:	8d 85 e3 fe ff ff    	lea    -0x11d(%ebp),%eax
  80013c:	bb 96 40 80 00       	mov    $0x804096,%ebx
  800141:	ba 11 00 00 00       	mov    $0x11,%edx
  800146:	89 c7                	mov    %eax,%edi
  800148:	89 de                	mov    %ebx,%esi
  80014a:	89 d1                	mov    %edx,%ecx
  80014c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  80014e:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  800154:	bb a7 40 80 00       	mov    $0x8040a7,%ebx
  800159:	ba 09 00 00 00       	mov    $0x9,%edx
  80015e:	89 c7                	mov    %eax,%edi
  800160:	89 de                	mov    %ebx,%esi
  800162:	89 d1                	mov    %edx,%ecx
  800164:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  800166:	8d 85 d0 fe ff ff    	lea    -0x130(%ebp),%eax
  80016c:	bb b0 40 80 00       	mov    $0x8040b0,%ebx
  800171:	ba 0a 00 00 00       	mov    $0xa,%edx
  800176:	89 c7                	mov    %eax,%edi
  800178:	89 de                	mov    %ebx,%esi
  80017a:	89 d1                	mov    %edx,%ecx
  80017c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  80017e:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  800184:	bb ba 40 80 00       	mov    $0x8040ba,%ebx
  800189:	ba 0b 00 00 00       	mov    $0xb,%edx
  80018e:	89 c7                	mov    %eax,%edi
  800190:	89 de                	mov    %ebx,%esi
  800192:	89 d1                	mov    %edx,%ecx
  800194:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  800196:	8d 85 b9 fe ff ff    	lea    -0x147(%ebp),%eax
  80019c:	bb c5 40 80 00       	mov    $0x8040c5,%ebx
  8001a1:	ba 03 00 00 00       	mov    $0x3,%edx
  8001a6:	89 c7                	mov    %eax,%edi
  8001a8:	89 de                	mov    %ebx,%esi
  8001aa:	89 d1                	mov    %edx,%ecx
  8001ac:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  8001ae:	8d 85 af fe ff ff    	lea    -0x151(%ebp),%eax
  8001b4:	bb d1 40 80 00       	mov    $0x8040d1,%ebx
  8001b9:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001be:	89 c7                	mov    %eax,%edi
  8001c0:	89 de                	mov    %ebx,%esi
  8001c2:	89 d1                	mov    %edx,%ecx
  8001c4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  8001c6:	8d 85 a5 fe ff ff    	lea    -0x15b(%ebp),%eax
  8001cc:	bb db 40 80 00       	mov    $0x8040db,%ebx
  8001d1:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001d6:	89 c7                	mov    %eax,%edi
  8001d8:	89 de                	mov    %ebx,%esi
  8001da:	89 d1                	mov    %edx,%ecx
  8001dc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _clerk[] = "clerk";
  8001de:	c7 85 9f fe ff ff 63 	movl   $0x72656c63,-0x161(%ebp)
  8001e5:	6c 65 72 
  8001e8:	66 c7 85 a3 fe ff ff 	movw   $0x6b,-0x15d(%ebp)
  8001ef:	6b 00 
	char _custCounterCS[] = "custCounterCS";
  8001f1:	8d 85 91 fe ff ff    	lea    -0x16f(%ebp),%eax
  8001f7:	bb e5 40 80 00       	mov    $0x8040e5,%ebx
  8001fc:	ba 0e 00 00 00       	mov    $0xe,%edx
  800201:	89 c7                	mov    %eax,%edi
  800203:	89 de                	mov    %ebx,%esi
  800205:	89 d1                	mov    %edx,%ecx
  800207:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  800209:	8d 85 82 fe ff ff    	lea    -0x17e(%ebp),%eax
  80020f:	bb f3 40 80 00       	mov    $0x8040f3,%ebx
  800214:	ba 0f 00 00 00       	mov    $0xf,%edx
  800219:	89 c7                	mov    %eax,%edi
  80021b:	89 de                	mov    %ebx,%esi
  80021d:	89 d1                	mov    %edx,%ecx
  80021f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  800221:	8d 85 7b fe ff ff    	lea    -0x185(%ebp),%eax
  800227:	bb 02 41 80 00       	mov    $0x804102,%ebx
  80022c:	ba 07 00 00 00       	mov    $0x7,%edx
  800231:	89 c7                	mov    %eax,%edi
  800233:	89 de                	mov    %ebx,%esi
  800235:	89 d1                	mov    %edx,%ecx
  800237:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800239:	8d 85 74 fe ff ff    	lea    -0x18c(%ebp),%eax
  80023f:	bb 09 41 80 00       	mov    $0x804109,%ebx
  800244:	ba 07 00 00 00       	mov    $0x7,%edx
  800249:	89 c7                	mov    %eax,%edi
  80024b:	89 de                	mov    %ebx,%esi
  80024d:	89 d1                	mov    %edx,%ecx
  80024f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	struct Customer * custs;
	custs = smalloc(_customers, sizeof(struct Customer)*numOfCustomers, 1);
  800251:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800254:	c1 e0 03             	shl    $0x3,%eax
  800257:	83 ec 04             	sub    $0x4,%esp
  80025a:	6a 01                	push   $0x1
  80025c:	50                   	push   %eax
  80025d:	8d 85 6a ff ff ff    	lea    -0x96(%ebp),%eax
  800263:	50                   	push   %eax
  800264:	e8 55 1d 00 00       	call   801fbe <smalloc>
  800269:	83 c4 10             	add    $0x10,%esp
  80026c:	89 45 a0             	mov    %eax,-0x60(%ebp)
	//sys_createSharedObject("customers", sizeof(struct Customer)*numOfCustomers, 1, (void**)&custs);


	{
		int f1 = 0;
  80026f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		for(;f1<flight1Customers; ++f1)
  800276:	eb 2e                	jmp    8002a6 <_main+0x26e>
		{
			custs[f1].booked = 0;
  800278:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80027b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800282:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800285:	01 d0                	add    %edx,%eax
  800287:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			custs[f1].flightType = 1;
  80028e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800291:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800298:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80029b:	01 d0                	add    %edx,%eax
  80029d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
	//sys_createSharedObject("customers", sizeof(struct Customer)*numOfCustomers, 1, (void**)&custs);


	{
		int f1 = 0;
		for(;f1<flight1Customers; ++f1)
  8002a3:	ff 45 e4             	incl   -0x1c(%ebp)
  8002a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002a9:	3b 45 b4             	cmp    -0x4c(%ebp),%eax
  8002ac:	7c ca                	jl     800278 <_main+0x240>
		{
			custs[f1].booked = 0;
			custs[f1].flightType = 1;
		}

		int f2=f1;
  8002ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		for(;f2<f1+flight2Customers; ++f2)
  8002b4:	eb 2e                	jmp    8002e4 <_main+0x2ac>
		{
			custs[f2].booked = 0;
  8002b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002b9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8002c0:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8002c3:	01 d0                	add    %edx,%eax
  8002c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			custs[f2].flightType = 2;
  8002cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002cf:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8002d6:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8002d9:	01 d0                	add    %edx,%eax
  8002db:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
			custs[f1].booked = 0;
			custs[f1].flightType = 1;
		}

		int f2=f1;
		for(;f2<f1+flight2Customers; ++f2)
  8002e1:	ff 45 e0             	incl   -0x20(%ebp)
  8002e4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002e7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8002ea:	01 d0                	add    %edx,%eax
  8002ec:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002ef:	7f c5                	jg     8002b6 <_main+0x27e>
		{
			custs[f2].booked = 0;
			custs[f2].flightType = 2;
		}

		int f3=f2;
  8002f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002f4:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for(;f3<f2+flight3Customers; ++f3)
  8002f7:	eb 2e                	jmp    800327 <_main+0x2ef>
		{
			custs[f3].booked = 0;
  8002f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002fc:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800303:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800306:	01 d0                	add    %edx,%eax
  800308:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			custs[f3].flightType = 3;
  80030f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800312:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800319:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80031c:	01 d0                	add    %edx,%eax
  80031e:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
			custs[f2].booked = 0;
			custs[f2].flightType = 2;
		}

		int f3=f2;
		for(;f3<f2+flight3Customers; ++f3)
  800324:	ff 45 dc             	incl   -0x24(%ebp)
  800327:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80032a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80032d:	01 d0                	add    %edx,%eax
  80032f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800332:	7f c5                	jg     8002f9 <_main+0x2c1>
			custs[f3].booked = 0;
			custs[f3].flightType = 3;
		}
	}

	int* custCounter = smalloc(_custCounter, sizeof(int), 1);
  800334:	83 ec 04             	sub    $0x4,%esp
  800337:	6a 01                	push   $0x1
  800339:	6a 04                	push   $0x4
  80033b:	8d 85 5e ff ff ff    	lea    -0xa2(%ebp),%eax
  800341:	50                   	push   %eax
  800342:	e8 77 1c 00 00       	call   801fbe <smalloc>
  800347:	83 c4 10             	add    $0x10,%esp
  80034a:	89 45 9c             	mov    %eax,-0x64(%ebp)
	*custCounter = 0;
  80034d:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800350:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* flight1Counter = smalloc(_flight1Counter, sizeof(int), 1);
  800356:	83 ec 04             	sub    $0x4,%esp
  800359:	6a 01                	push   $0x1
  80035b:	6a 04                	push   $0x4
  80035d:	8d 85 4f ff ff ff    	lea    -0xb1(%ebp),%eax
  800363:	50                   	push   %eax
  800364:	e8 55 1c 00 00       	call   801fbe <smalloc>
  800369:	83 c4 10             	add    $0x10,%esp
  80036c:	89 45 98             	mov    %eax,-0x68(%ebp)
	*flight1Counter = flight1NumOfTickets;
  80036f:	8b 45 98             	mov    -0x68(%ebp),%eax
  800372:	8b 55 a8             	mov    -0x58(%ebp),%edx
  800375:	89 10                	mov    %edx,(%eax)

	int* flight2Counter = smalloc(_flight2Counter, sizeof(int), 1);
  800377:	83 ec 04             	sub    $0x4,%esp
  80037a:	6a 01                	push   $0x1
  80037c:	6a 04                	push   $0x4
  80037e:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
  800384:	50                   	push   %eax
  800385:	e8 34 1c 00 00       	call   801fbe <smalloc>
  80038a:	83 c4 10             	add    $0x10,%esp
  80038d:	89 45 94             	mov    %eax,-0x6c(%ebp)
	*flight2Counter = flight2NumOfTickets;
  800390:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800393:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  800396:	89 10                	mov    %edx,(%eax)

	int* flight1BookedCounter = smalloc(_flightBooked1Counter, sizeof(int), 1);
  800398:	83 ec 04             	sub    $0x4,%esp
  80039b:	6a 01                	push   $0x1
  80039d:	6a 04                	push   $0x4
  80039f:	8d 85 2b ff ff ff    	lea    -0xd5(%ebp),%eax
  8003a5:	50                   	push   %eax
  8003a6:	e8 13 1c 00 00       	call   801fbe <smalloc>
  8003ab:	83 c4 10             	add    $0x10,%esp
  8003ae:	89 45 90             	mov    %eax,-0x70(%ebp)
	*flight1BookedCounter = 0;
  8003b1:	8b 45 90             	mov    -0x70(%ebp),%eax
  8003b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* flight2BookedCounter = smalloc(_flightBooked2Counter, sizeof(int), 1);
  8003ba:	83 ec 04             	sub    $0x4,%esp
  8003bd:	6a 01                	push   $0x1
  8003bf:	6a 04                	push   $0x4
  8003c1:	8d 85 16 ff ff ff    	lea    -0xea(%ebp),%eax
  8003c7:	50                   	push   %eax
  8003c8:	e8 f1 1b 00 00       	call   801fbe <smalloc>
  8003cd:	83 c4 10             	add    $0x10,%esp
  8003d0:	89 45 8c             	mov    %eax,-0x74(%ebp)
	*flight2BookedCounter = 0;
  8003d3:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8003d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* flight1BookedArr = smalloc(_flightBooked1Arr, sizeof(int)*flight1NumOfTickets, 1);
  8003dc:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003df:	c1 e0 02             	shl    $0x2,%eax
  8003e2:	83 ec 04             	sub    $0x4,%esp
  8003e5:	6a 01                	push   $0x1
  8003e7:	50                   	push   %eax
  8003e8:	8d 85 05 ff ff ff    	lea    -0xfb(%ebp),%eax
  8003ee:	50                   	push   %eax
  8003ef:	e8 ca 1b 00 00       	call   801fbe <smalloc>
  8003f4:	83 c4 10             	add    $0x10,%esp
  8003f7:	89 45 88             	mov    %eax,-0x78(%ebp)
	int* flight2BookedArr = smalloc(_flightBooked2Arr, sizeof(int)*flight2NumOfTickets, 1);
  8003fa:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003fd:	c1 e0 02             	shl    $0x2,%eax
  800400:	83 ec 04             	sub    $0x4,%esp
  800403:	6a 01                	push   $0x1
  800405:	50                   	push   %eax
  800406:	8d 85 f4 fe ff ff    	lea    -0x10c(%ebp),%eax
  80040c:	50                   	push   %eax
  80040d:	e8 ac 1b 00 00       	call   801fbe <smalloc>
  800412:	83 c4 10             	add    $0x10,%esp
  800415:	89 45 84             	mov    %eax,-0x7c(%ebp)

	int* cust_ready_queue = smalloc(_cust_ready_queue, sizeof(int)*numOfCustomers, 1);
  800418:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80041b:	c1 e0 02             	shl    $0x2,%eax
  80041e:	83 ec 04             	sub    $0x4,%esp
  800421:	6a 01                	push   $0x1
  800423:	50                   	push   %eax
  800424:	8d 85 e3 fe ff ff    	lea    -0x11d(%ebp),%eax
  80042a:	50                   	push   %eax
  80042b:	e8 8e 1b 00 00       	call   801fbe <smalloc>
  800430:	83 c4 10             	add    $0x10,%esp
  800433:	89 45 80             	mov    %eax,-0x80(%ebp)

	int* queue_in = smalloc(_queue_in, sizeof(int), 1);
  800436:	83 ec 04             	sub    $0x4,%esp
  800439:	6a 01                	push   $0x1
  80043b:	6a 04                	push   $0x4
  80043d:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  800443:	50                   	push   %eax
  800444:	e8 75 1b 00 00       	call   801fbe <smalloc>
  800449:	83 c4 10             	add    $0x10,%esp
  80044c:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
	*queue_in = 0;
  800452:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800458:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* queue_out = smalloc(_queue_out, sizeof(int), 1);
  80045e:	83 ec 04             	sub    $0x4,%esp
  800461:	6a 01                	push   $0x1
  800463:	6a 04                	push   $0x4
  800465:	8d 85 d0 fe ff ff    	lea    -0x130(%ebp),%eax
  80046b:	50                   	push   %eax
  80046c:	e8 4d 1b 00 00       	call   801fbe <smalloc>
  800471:	83 c4 10             	add    $0x10,%esp
  800474:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
	*queue_out = 0;
  80047a:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800480:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	// *************************************************************************************************
	/// Semaphores Region ******************************************************************************
	// *************************************************************************************************
	sys_createSemaphore(_flight1CS, 1);
  800486:	83 ec 08             	sub    $0x8,%esp
  800489:	6a 01                	push   $0x1
  80048b:	8d 85 af fe ff ff    	lea    -0x151(%ebp),%eax
  800491:	50                   	push   %eax
  800492:	e8 a1 1f 00 00       	call   802438 <sys_createSemaphore>
  800497:	83 c4 10             	add    $0x10,%esp
	sys_createSemaphore(_flight2CS, 1);
  80049a:	83 ec 08             	sub    $0x8,%esp
  80049d:	6a 01                	push   $0x1
  80049f:	8d 85 a5 fe ff ff    	lea    -0x15b(%ebp),%eax
  8004a5:	50                   	push   %eax
  8004a6:	e8 8d 1f 00 00       	call   802438 <sys_createSemaphore>
  8004ab:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore(_custCounterCS, 1);
  8004ae:	83 ec 08             	sub    $0x8,%esp
  8004b1:	6a 01                	push   $0x1
  8004b3:	8d 85 91 fe ff ff    	lea    -0x16f(%ebp),%eax
  8004b9:	50                   	push   %eax
  8004ba:	e8 79 1f 00 00       	call   802438 <sys_createSemaphore>
  8004bf:	83 c4 10             	add    $0x10,%esp
	sys_createSemaphore(_custQueueCS, 1);
  8004c2:	83 ec 08             	sub    $0x8,%esp
  8004c5:	6a 01                	push   $0x1
  8004c7:	8d 85 b9 fe ff ff    	lea    -0x147(%ebp),%eax
  8004cd:	50                   	push   %eax
  8004ce:	e8 65 1f 00 00       	call   802438 <sys_createSemaphore>
  8004d3:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore(_clerk, 3);
  8004d6:	83 ec 08             	sub    $0x8,%esp
  8004d9:	6a 03                	push   $0x3
  8004db:	8d 85 9f fe ff ff    	lea    -0x161(%ebp),%eax
  8004e1:	50                   	push   %eax
  8004e2:	e8 51 1f 00 00       	call   802438 <sys_createSemaphore>
  8004e7:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore(_cust_ready, 0);
  8004ea:	83 ec 08             	sub    $0x8,%esp
  8004ed:	6a 00                	push   $0x0
  8004ef:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  8004f5:	50                   	push   %eax
  8004f6:	e8 3d 1f 00 00       	call   802438 <sys_createSemaphore>
  8004fb:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore(_custTerminated, 0);
  8004fe:	83 ec 08             	sub    $0x8,%esp
  800501:	6a 00                	push   $0x0
  800503:	8d 85 82 fe ff ff    	lea    -0x17e(%ebp),%eax
  800509:	50                   	push   %eax
  80050a:	e8 29 1f 00 00       	call   802438 <sys_createSemaphore>
  80050f:	83 c4 10             	add    $0x10,%esp

	int s=0;
  800512:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
	for(s=0; s<numOfCustomers; ++s)
  800519:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800520:	eb 78                	jmp    80059a <_main+0x562>
	{
		char prefix[30]="cust_finished";
  800522:	8d 85 56 fe ff ff    	lea    -0x1aa(%ebp),%eax
  800528:	bb 10 41 80 00       	mov    $0x804110,%ebx
  80052d:	ba 0e 00 00 00       	mov    $0xe,%edx
  800532:	89 c7                	mov    %eax,%edi
  800534:	89 de                	mov    %ebx,%esi
  800536:	89 d1                	mov    %edx,%ecx
  800538:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80053a:	8d 95 64 fe ff ff    	lea    -0x19c(%ebp),%edx
  800540:	b9 04 00 00 00       	mov    $0x4,%ecx
  800545:	b8 00 00 00 00       	mov    $0x0,%eax
  80054a:	89 d7                	mov    %edx,%edi
  80054c:	f3 ab                	rep stos %eax,%es:(%edi)
		char id[5]; char sname[50];
		ltostr(s, id);
  80054e:	83 ec 08             	sub    $0x8,%esp
  800551:	8d 85 51 fe ff ff    	lea    -0x1af(%ebp),%eax
  800557:	50                   	push   %eax
  800558:	ff 75 d8             	pushl  -0x28(%ebp)
  80055b:	e8 03 15 00 00       	call   801a63 <ltostr>
  800560:	83 c4 10             	add    $0x10,%esp
		strcconcat(prefix, id, sname);
  800563:	83 ec 04             	sub    $0x4,%esp
  800566:	8d 85 fc fd ff ff    	lea    -0x204(%ebp),%eax
  80056c:	50                   	push   %eax
  80056d:	8d 85 51 fe ff ff    	lea    -0x1af(%ebp),%eax
  800573:	50                   	push   %eax
  800574:	8d 85 56 fe ff ff    	lea    -0x1aa(%ebp),%eax
  80057a:	50                   	push   %eax
  80057b:	e8 db 15 00 00       	call   801b5b <strcconcat>
  800580:	83 c4 10             	add    $0x10,%esp
		sys_createSemaphore(sname, 0);
  800583:	83 ec 08             	sub    $0x8,%esp
  800586:	6a 00                	push   $0x0
  800588:	8d 85 fc fd ff ff    	lea    -0x204(%ebp),%eax
  80058e:	50                   	push   %eax
  80058f:	e8 a4 1e 00 00       	call   802438 <sys_createSemaphore>
  800594:	83 c4 10             	add    $0x10,%esp
	sys_createSemaphore(_cust_ready, 0);

	sys_createSemaphore(_custTerminated, 0);

	int s=0;
	for(s=0; s<numOfCustomers; ++s)
  800597:	ff 45 d8             	incl   -0x28(%ebp)
  80059a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80059d:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8005a0:	7c 80                	jl     800522 <_main+0x4ea>
	// start all clerks and customers ******************************************************************
	// *************************************************************************************************

	//3 clerks
	uint32 envId;
	envId = sys_create_env(_taircl, (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8005a2:	a1 20 50 80 00       	mov    0x805020,%eax
  8005a7:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8005ad:	a1 20 50 80 00       	mov    0x805020,%eax
  8005b2:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8005b8:	89 c1                	mov    %eax,%ecx
  8005ba:	a1 20 50 80 00       	mov    0x805020,%eax
  8005bf:	8b 40 74             	mov    0x74(%eax),%eax
  8005c2:	52                   	push   %edx
  8005c3:	51                   	push   %ecx
  8005c4:	50                   	push   %eax
  8005c5:	8d 85 7b fe ff ff    	lea    -0x185(%ebp),%eax
  8005cb:	50                   	push   %eax
  8005cc:	e8 78 1f 00 00       	call   802549 <sys_create_env>
  8005d1:	83 c4 10             	add    $0x10,%esp
  8005d4:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
	sys_run_env(envId);
  8005da:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8005e0:	83 ec 0c             	sub    $0xc,%esp
  8005e3:	50                   	push   %eax
  8005e4:	e8 7e 1f 00 00       	call   802567 <sys_run_env>
  8005e9:	83 c4 10             	add    $0x10,%esp

	envId = sys_create_env(_taircl, (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8005ec:	a1 20 50 80 00       	mov    0x805020,%eax
  8005f1:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8005f7:	a1 20 50 80 00       	mov    0x805020,%eax
  8005fc:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800602:	89 c1                	mov    %eax,%ecx
  800604:	a1 20 50 80 00       	mov    0x805020,%eax
  800609:	8b 40 74             	mov    0x74(%eax),%eax
  80060c:	52                   	push   %edx
  80060d:	51                   	push   %ecx
  80060e:	50                   	push   %eax
  80060f:	8d 85 7b fe ff ff    	lea    -0x185(%ebp),%eax
  800615:	50                   	push   %eax
  800616:	e8 2e 1f 00 00       	call   802549 <sys_create_env>
  80061b:	83 c4 10             	add    $0x10,%esp
  80061e:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
	sys_run_env(envId);
  800624:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80062a:	83 ec 0c             	sub    $0xc,%esp
  80062d:	50                   	push   %eax
  80062e:	e8 34 1f 00 00       	call   802567 <sys_run_env>
  800633:	83 c4 10             	add    $0x10,%esp

	envId = sys_create_env(_taircl, (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800636:	a1 20 50 80 00       	mov    0x805020,%eax
  80063b:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800641:	a1 20 50 80 00       	mov    0x805020,%eax
  800646:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80064c:	89 c1                	mov    %eax,%ecx
  80064e:	a1 20 50 80 00       	mov    0x805020,%eax
  800653:	8b 40 74             	mov    0x74(%eax),%eax
  800656:	52                   	push   %edx
  800657:	51                   	push   %ecx
  800658:	50                   	push   %eax
  800659:	8d 85 7b fe ff ff    	lea    -0x185(%ebp),%eax
  80065f:	50                   	push   %eax
  800660:	e8 e4 1e 00 00       	call   802549 <sys_create_env>
  800665:	83 c4 10             	add    $0x10,%esp
  800668:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
	sys_run_env(envId);
  80066e:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800674:	83 ec 0c             	sub    $0xc,%esp
  800677:	50                   	push   %eax
  800678:	e8 ea 1e 00 00       	call   802567 <sys_run_env>
  80067d:	83 c4 10             	add    $0x10,%esp

	//customers
	int c;
	for(c=0; c< numOfCustomers;++c)
  800680:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  800687:	eb 6d                	jmp    8006f6 <_main+0x6be>
	{
		envId = sys_create_env(_taircu, (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800689:	a1 20 50 80 00       	mov    0x805020,%eax
  80068e:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800694:	a1 20 50 80 00       	mov    0x805020,%eax
  800699:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80069f:	89 c1                	mov    %eax,%ecx
  8006a1:	a1 20 50 80 00       	mov    0x805020,%eax
  8006a6:	8b 40 74             	mov    0x74(%eax),%eax
  8006a9:	52                   	push   %edx
  8006aa:	51                   	push   %ecx
  8006ab:	50                   	push   %eax
  8006ac:	8d 85 74 fe ff ff    	lea    -0x18c(%ebp),%eax
  8006b2:	50                   	push   %eax
  8006b3:	e8 91 1e 00 00       	call   802549 <sys_create_env>
  8006b8:	83 c4 10             	add    $0x10,%esp
  8006bb:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
		if (envId == E_ENV_CREATION_ERROR)
  8006c1:	83 bd 74 ff ff ff ef 	cmpl   $0xffffffef,-0x8c(%ebp)
  8006c8:	75 17                	jne    8006e1 <_main+0x6a9>
			panic("NO AVAILABLE ENVs... Please reduce the num of customers and try again");
  8006ca:	83 ec 04             	sub    $0x4,%esp
  8006cd:	68 40 3d 80 00       	push   $0x803d40
  8006d2:	68 95 00 00 00       	push   $0x95
  8006d7:	68 86 3d 80 00       	push   $0x803d86
  8006dc:	e8 a6 05 00 00       	call   800c87 <_panic>

		sys_run_env(envId);
  8006e1:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8006e7:	83 ec 0c             	sub    $0xc,%esp
  8006ea:	50                   	push   %eax
  8006eb:	e8 77 1e 00 00       	call   802567 <sys_run_env>
  8006f0:	83 c4 10             	add    $0x10,%esp
	envId = sys_create_env(_taircl, (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
	sys_run_env(envId);

	//customers
	int c;
	for(c=0; c< numOfCustomers;++c)
  8006f3:	ff 45 d4             	incl   -0x2c(%ebp)
  8006f6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006f9:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8006fc:	7c 8b                	jl     800689 <_main+0x651>

		sys_run_env(envId);
	}

	//wait until all customers terminated
	for(c=0; c< numOfCustomers;++c)
  8006fe:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  800705:	eb 18                	jmp    80071f <_main+0x6e7>
	{
		sys_waitSemaphore(envID, _custTerminated);
  800707:	83 ec 08             	sub    $0x8,%esp
  80070a:	8d 85 82 fe ff ff    	lea    -0x17e(%ebp),%eax
  800710:	50                   	push   %eax
  800711:	ff 75 bc             	pushl  -0x44(%ebp)
  800714:	e8 58 1d 00 00       	call   802471 <sys_waitSemaphore>
  800719:	83 c4 10             	add    $0x10,%esp

		sys_run_env(envId);
	}

	//wait until all customers terminated
	for(c=0; c< numOfCustomers;++c)
  80071c:	ff 45 d4             	incl   -0x2c(%ebp)
  80071f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800722:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  800725:	7c e0                	jl     800707 <_main+0x6cf>
	{
		sys_waitSemaphore(envID, _custTerminated);
	}

	env_sleep(1500);
  800727:	83 ec 0c             	sub    $0xc,%esp
  80072a:	68 dc 05 00 00       	push   $0x5dc
  80072f:	e8 ef 32 00 00       	call   803a23 <env_sleep>
  800734:	83 c4 10             	add    $0x10,%esp

	//print out the results
	int b;
	for(b=0; b< (*flight1BookedCounter);++b)
  800737:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  80073e:	eb 45                	jmp    800785 <_main+0x74d>
	{
		cprintf("cust %d booked flight 1, originally ordered %d\n", flight1BookedArr[b], custs[flight1BookedArr[b]].flightType);
  800740:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800743:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80074a:	8b 45 88             	mov    -0x78(%ebp),%eax
  80074d:	01 d0                	add    %edx,%eax
  80074f:	8b 00                	mov    (%eax),%eax
  800751:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800758:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80075b:	01 d0                	add    %edx,%eax
  80075d:	8b 10                	mov    (%eax),%edx
  80075f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800762:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800769:	8b 45 88             	mov    -0x78(%ebp),%eax
  80076c:	01 c8                	add    %ecx,%eax
  80076e:	8b 00                	mov    (%eax),%eax
  800770:	83 ec 04             	sub    $0x4,%esp
  800773:	52                   	push   %edx
  800774:	50                   	push   %eax
  800775:	68 98 3d 80 00       	push   $0x803d98
  80077a:	e8 bc 07 00 00       	call   800f3b <cprintf>
  80077f:	83 c4 10             	add    $0x10,%esp

	env_sleep(1500);

	//print out the results
	int b;
	for(b=0; b< (*flight1BookedCounter);++b)
  800782:	ff 45 d0             	incl   -0x30(%ebp)
  800785:	8b 45 90             	mov    -0x70(%ebp),%eax
  800788:	8b 00                	mov    (%eax),%eax
  80078a:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80078d:	7f b1                	jg     800740 <_main+0x708>
	{
		cprintf("cust %d booked flight 1, originally ordered %d\n", flight1BookedArr[b], custs[flight1BookedArr[b]].flightType);
	}

	for(b=0; b< (*flight2BookedCounter);++b)
  80078f:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  800796:	eb 45                	jmp    8007dd <_main+0x7a5>
	{
		cprintf("cust %d booked flight 2, originally ordered %d\n", flight2BookedArr[b], custs[flight2BookedArr[b]].flightType);
  800798:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80079b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007a2:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8007a5:	01 d0                	add    %edx,%eax
  8007a7:	8b 00                	mov    (%eax),%eax
  8007a9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8007b0:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8007b3:	01 d0                	add    %edx,%eax
  8007b5:	8b 10                	mov    (%eax),%edx
  8007b7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007ba:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8007c1:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8007c4:	01 c8                	add    %ecx,%eax
  8007c6:	8b 00                	mov    (%eax),%eax
  8007c8:	83 ec 04             	sub    $0x4,%esp
  8007cb:	52                   	push   %edx
  8007cc:	50                   	push   %eax
  8007cd:	68 c8 3d 80 00       	push   $0x803dc8
  8007d2:	e8 64 07 00 00       	call   800f3b <cprintf>
  8007d7:	83 c4 10             	add    $0x10,%esp
	for(b=0; b< (*flight1BookedCounter);++b)
	{
		cprintf("cust %d booked flight 1, originally ordered %d\n", flight1BookedArr[b], custs[flight1BookedArr[b]].flightType);
	}

	for(b=0; b< (*flight2BookedCounter);++b)
  8007da:	ff 45 d0             	incl   -0x30(%ebp)
  8007dd:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8007e0:	8b 00                	mov    (%eax),%eax
  8007e2:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8007e5:	7f b1                	jg     800798 <_main+0x760>
		cprintf("cust %d booked flight 2, originally ordered %d\n", flight2BookedArr[b], custs[flight2BookedArr[b]].flightType);
	}

	//check out the final results and semaphores
	{
		int f1 = 0;
  8007e7:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		for(;f1<flight1Customers; ++f1)
  8007ee:	eb 33                	jmp    800823 <_main+0x7eb>
		{
			if(find(flight1BookedArr, flight1NumOfTickets, f1) != 1)
  8007f0:	83 ec 04             	sub    $0x4,%esp
  8007f3:	ff 75 cc             	pushl  -0x34(%ebp)
  8007f6:	ff 75 a8             	pushl  -0x58(%ebp)
  8007f9:	ff 75 88             	pushl  -0x78(%ebp)
  8007fc:	e8 05 03 00 00       	call   800b06 <find>
  800801:	83 c4 10             	add    $0x10,%esp
  800804:	83 f8 01             	cmp    $0x1,%eax
  800807:	74 17                	je     800820 <_main+0x7e8>
			{
				panic("Error, wrong booking for user %d\n", f1);
  800809:	ff 75 cc             	pushl  -0x34(%ebp)
  80080c:	68 f8 3d 80 00       	push   $0x803df8
  800811:	68 b5 00 00 00       	push   $0xb5
  800816:	68 86 3d 80 00       	push   $0x803d86
  80081b:	e8 67 04 00 00       	call   800c87 <_panic>
	}

	//check out the final results and semaphores
	{
		int f1 = 0;
		for(;f1<flight1Customers; ++f1)
  800820:	ff 45 cc             	incl   -0x34(%ebp)
  800823:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800826:	3b 45 b4             	cmp    -0x4c(%ebp),%eax
  800829:	7c c5                	jl     8007f0 <_main+0x7b8>
			{
				panic("Error, wrong booking for user %d\n", f1);
			}
		}

		int f2=f1;
  80082b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80082e:	89 45 c8             	mov    %eax,-0x38(%ebp)
		for(;f2<f1+flight2Customers; ++f2)
  800831:	eb 33                	jmp    800866 <_main+0x82e>
		{
			if(find(flight2BookedArr, flight2NumOfTickets, f2) != 1)
  800833:	83 ec 04             	sub    $0x4,%esp
  800836:	ff 75 c8             	pushl  -0x38(%ebp)
  800839:	ff 75 a4             	pushl  -0x5c(%ebp)
  80083c:	ff 75 84             	pushl  -0x7c(%ebp)
  80083f:	e8 c2 02 00 00       	call   800b06 <find>
  800844:	83 c4 10             	add    $0x10,%esp
  800847:	83 f8 01             	cmp    $0x1,%eax
  80084a:	74 17                	je     800863 <_main+0x82b>
			{
				panic("Error, wrong booking for user %d\n", f2);
  80084c:	ff 75 c8             	pushl  -0x38(%ebp)
  80084f:	68 f8 3d 80 00       	push   $0x803df8
  800854:	68 be 00 00 00       	push   $0xbe
  800859:	68 86 3d 80 00       	push   $0x803d86
  80085e:	e8 24 04 00 00       	call   800c87 <_panic>
				panic("Error, wrong booking for user %d\n", f1);
			}
		}

		int f2=f1;
		for(;f2<f1+flight2Customers; ++f2)
  800863:	ff 45 c8             	incl   -0x38(%ebp)
  800866:	8b 55 cc             	mov    -0x34(%ebp),%edx
  800869:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80086c:	01 d0                	add    %edx,%eax
  80086e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800871:	7f c0                	jg     800833 <_main+0x7fb>
			{
				panic("Error, wrong booking for user %d\n", f2);
			}
		}

		int f3=f2;
  800873:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800876:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		for(;f3<f2+flight3Customers; ++f3)
  800879:	eb 4c                	jmp    8008c7 <_main+0x88f>
		{
			if(find(flight1BookedArr, flight1NumOfTickets, f3) != 1 || find(flight2BookedArr, flight2NumOfTickets, f3) != 1)
  80087b:	83 ec 04             	sub    $0x4,%esp
  80087e:	ff 75 c4             	pushl  -0x3c(%ebp)
  800881:	ff 75 a8             	pushl  -0x58(%ebp)
  800884:	ff 75 88             	pushl  -0x78(%ebp)
  800887:	e8 7a 02 00 00       	call   800b06 <find>
  80088c:	83 c4 10             	add    $0x10,%esp
  80088f:	83 f8 01             	cmp    $0x1,%eax
  800892:	75 19                	jne    8008ad <_main+0x875>
  800894:	83 ec 04             	sub    $0x4,%esp
  800897:	ff 75 c4             	pushl  -0x3c(%ebp)
  80089a:	ff 75 a4             	pushl  -0x5c(%ebp)
  80089d:	ff 75 84             	pushl  -0x7c(%ebp)
  8008a0:	e8 61 02 00 00       	call   800b06 <find>
  8008a5:	83 c4 10             	add    $0x10,%esp
  8008a8:	83 f8 01             	cmp    $0x1,%eax
  8008ab:	74 17                	je     8008c4 <_main+0x88c>
			{
				panic("Error, wrong booking for user %d\n", f3);
  8008ad:	ff 75 c4             	pushl  -0x3c(%ebp)
  8008b0:	68 f8 3d 80 00       	push   $0x803df8
  8008b5:	68 c7 00 00 00       	push   $0xc7
  8008ba:	68 86 3d 80 00       	push   $0x803d86
  8008bf:	e8 c3 03 00 00       	call   800c87 <_panic>
				panic("Error, wrong booking for user %d\n", f2);
			}
		}

		int f3=f2;
		for(;f3<f2+flight3Customers; ++f3)
  8008c4:	ff 45 c4             	incl   -0x3c(%ebp)
  8008c7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8008ca:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8008cd:	01 d0                	add    %edx,%eax
  8008cf:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8008d2:	7f a7                	jg     80087b <_main+0x843>
			{
				panic("Error, wrong booking for user %d\n", f3);
			}
		}

		assert(sys_getSemaphoreValue(envID, _flight1CS) == 1);
  8008d4:	83 ec 08             	sub    $0x8,%esp
  8008d7:	8d 85 af fe ff ff    	lea    -0x151(%ebp),%eax
  8008dd:	50                   	push   %eax
  8008de:	ff 75 bc             	pushl  -0x44(%ebp)
  8008e1:	e8 6e 1b 00 00       	call   802454 <sys_getSemaphoreValue>
  8008e6:	83 c4 10             	add    $0x10,%esp
  8008e9:	83 f8 01             	cmp    $0x1,%eax
  8008ec:	74 19                	je     800907 <_main+0x8cf>
  8008ee:	68 1c 3e 80 00       	push   $0x803e1c
  8008f3:	68 4a 3e 80 00       	push   $0x803e4a
  8008f8:	68 cb 00 00 00       	push   $0xcb
  8008fd:	68 86 3d 80 00       	push   $0x803d86
  800902:	e8 80 03 00 00       	call   800c87 <_panic>
		assert(sys_getSemaphoreValue(envID, _flight2CS) == 1);
  800907:	83 ec 08             	sub    $0x8,%esp
  80090a:	8d 85 a5 fe ff ff    	lea    -0x15b(%ebp),%eax
  800910:	50                   	push   %eax
  800911:	ff 75 bc             	pushl  -0x44(%ebp)
  800914:	e8 3b 1b 00 00       	call   802454 <sys_getSemaphoreValue>
  800919:	83 c4 10             	add    $0x10,%esp
  80091c:	83 f8 01             	cmp    $0x1,%eax
  80091f:	74 19                	je     80093a <_main+0x902>
  800921:	68 60 3e 80 00       	push   $0x803e60
  800926:	68 4a 3e 80 00       	push   $0x803e4a
  80092b:	68 cc 00 00 00       	push   $0xcc
  800930:	68 86 3d 80 00       	push   $0x803d86
  800935:	e8 4d 03 00 00       	call   800c87 <_panic>

		assert(sys_getSemaphoreValue(envID, _custCounterCS) ==  1);
  80093a:	83 ec 08             	sub    $0x8,%esp
  80093d:	8d 85 91 fe ff ff    	lea    -0x16f(%ebp),%eax
  800943:	50                   	push   %eax
  800944:	ff 75 bc             	pushl  -0x44(%ebp)
  800947:	e8 08 1b 00 00       	call   802454 <sys_getSemaphoreValue>
  80094c:	83 c4 10             	add    $0x10,%esp
  80094f:	83 f8 01             	cmp    $0x1,%eax
  800952:	74 19                	je     80096d <_main+0x935>
  800954:	68 90 3e 80 00       	push   $0x803e90
  800959:	68 4a 3e 80 00       	push   $0x803e4a
  80095e:	68 ce 00 00 00       	push   $0xce
  800963:	68 86 3d 80 00       	push   $0x803d86
  800968:	e8 1a 03 00 00       	call   800c87 <_panic>
		assert(sys_getSemaphoreValue(envID, _custQueueCS) ==  1);
  80096d:	83 ec 08             	sub    $0x8,%esp
  800970:	8d 85 b9 fe ff ff    	lea    -0x147(%ebp),%eax
  800976:	50                   	push   %eax
  800977:	ff 75 bc             	pushl  -0x44(%ebp)
  80097a:	e8 d5 1a 00 00       	call   802454 <sys_getSemaphoreValue>
  80097f:	83 c4 10             	add    $0x10,%esp
  800982:	83 f8 01             	cmp    $0x1,%eax
  800985:	74 19                	je     8009a0 <_main+0x968>
  800987:	68 c4 3e 80 00       	push   $0x803ec4
  80098c:	68 4a 3e 80 00       	push   $0x803e4a
  800991:	68 cf 00 00 00       	push   $0xcf
  800996:	68 86 3d 80 00       	push   $0x803d86
  80099b:	e8 e7 02 00 00       	call   800c87 <_panic>

		assert(sys_getSemaphoreValue(envID, _clerk) == 3);
  8009a0:	83 ec 08             	sub    $0x8,%esp
  8009a3:	8d 85 9f fe ff ff    	lea    -0x161(%ebp),%eax
  8009a9:	50                   	push   %eax
  8009aa:	ff 75 bc             	pushl  -0x44(%ebp)
  8009ad:	e8 a2 1a 00 00       	call   802454 <sys_getSemaphoreValue>
  8009b2:	83 c4 10             	add    $0x10,%esp
  8009b5:	83 f8 03             	cmp    $0x3,%eax
  8009b8:	74 19                	je     8009d3 <_main+0x99b>
  8009ba:	68 f4 3e 80 00       	push   $0x803ef4
  8009bf:	68 4a 3e 80 00       	push   $0x803e4a
  8009c4:	68 d1 00 00 00       	push   $0xd1
  8009c9:	68 86 3d 80 00       	push   $0x803d86
  8009ce:	e8 b4 02 00 00       	call   800c87 <_panic>

		assert(sys_getSemaphoreValue(envID, _cust_ready) == -3);
  8009d3:	83 ec 08             	sub    $0x8,%esp
  8009d6:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  8009dc:	50                   	push   %eax
  8009dd:	ff 75 bc             	pushl  -0x44(%ebp)
  8009e0:	e8 6f 1a 00 00       	call   802454 <sys_getSemaphoreValue>
  8009e5:	83 c4 10             	add    $0x10,%esp
  8009e8:	83 f8 fd             	cmp    $0xfffffffd,%eax
  8009eb:	74 19                	je     800a06 <_main+0x9ce>
  8009ed:	68 20 3f 80 00       	push   $0x803f20
  8009f2:	68 4a 3e 80 00       	push   $0x803e4a
  8009f7:	68 d3 00 00 00       	push   $0xd3
  8009fc:	68 86 3d 80 00       	push   $0x803d86
  800a01:	e8 81 02 00 00       	call   800c87 <_panic>

		assert(sys_getSemaphoreValue(envID, _custTerminated) ==  0);
  800a06:	83 ec 08             	sub    $0x8,%esp
  800a09:	8d 85 82 fe ff ff    	lea    -0x17e(%ebp),%eax
  800a0f:	50                   	push   %eax
  800a10:	ff 75 bc             	pushl  -0x44(%ebp)
  800a13:	e8 3c 1a 00 00       	call   802454 <sys_getSemaphoreValue>
  800a18:	83 c4 10             	add    $0x10,%esp
  800a1b:	85 c0                	test   %eax,%eax
  800a1d:	74 19                	je     800a38 <_main+0xa00>
  800a1f:	68 50 3f 80 00       	push   $0x803f50
  800a24:	68 4a 3e 80 00       	push   $0x803e4a
  800a29:	68 d5 00 00 00       	push   $0xd5
  800a2e:	68 86 3d 80 00       	push   $0x803d86
  800a33:	e8 4f 02 00 00       	call   800c87 <_panic>

		int s=0;
  800a38:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
		for(s=0; s<numOfCustomers; ++s)
  800a3f:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  800a46:	e9 96 00 00 00       	jmp    800ae1 <_main+0xaa9>
		{
			char prefix[30]="cust_finished";
  800a4b:	8d 85 33 fe ff ff    	lea    -0x1cd(%ebp),%eax
  800a51:	bb 10 41 80 00       	mov    $0x804110,%ebx
  800a56:	ba 0e 00 00 00       	mov    $0xe,%edx
  800a5b:	89 c7                	mov    %eax,%edi
  800a5d:	89 de                	mov    %ebx,%esi
  800a5f:	89 d1                	mov    %edx,%ecx
  800a61:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800a63:	8d 95 41 fe ff ff    	lea    -0x1bf(%ebp),%edx
  800a69:	b9 04 00 00 00       	mov    $0x4,%ecx
  800a6e:	b8 00 00 00 00       	mov    $0x0,%eax
  800a73:	89 d7                	mov    %edx,%edi
  800a75:	f3 ab                	rep stos %eax,%es:(%edi)
			char id[5]; char cust_finishedSemaphoreName[50];
			ltostr(s, id);
  800a77:	83 ec 08             	sub    $0x8,%esp
  800a7a:	8d 85 2e fe ff ff    	lea    -0x1d2(%ebp),%eax
  800a80:	50                   	push   %eax
  800a81:	ff 75 c0             	pushl  -0x40(%ebp)
  800a84:	e8 da 0f 00 00       	call   801a63 <ltostr>
  800a89:	83 c4 10             	add    $0x10,%esp
			strcconcat(prefix, id, cust_finishedSemaphoreName);
  800a8c:	83 ec 04             	sub    $0x4,%esp
  800a8f:	8d 85 fc fd ff ff    	lea    -0x204(%ebp),%eax
  800a95:	50                   	push   %eax
  800a96:	8d 85 2e fe ff ff    	lea    -0x1d2(%ebp),%eax
  800a9c:	50                   	push   %eax
  800a9d:	8d 85 33 fe ff ff    	lea    -0x1cd(%ebp),%eax
  800aa3:	50                   	push   %eax
  800aa4:	e8 b2 10 00 00       	call   801b5b <strcconcat>
  800aa9:	83 c4 10             	add    $0x10,%esp
			assert(sys_getSemaphoreValue(envID, cust_finishedSemaphoreName) ==  0);
  800aac:	83 ec 08             	sub    $0x8,%esp
  800aaf:	8d 85 fc fd ff ff    	lea    -0x204(%ebp),%eax
  800ab5:	50                   	push   %eax
  800ab6:	ff 75 bc             	pushl  -0x44(%ebp)
  800ab9:	e8 96 19 00 00       	call   802454 <sys_getSemaphoreValue>
  800abe:	83 c4 10             	add    $0x10,%esp
  800ac1:	85 c0                	test   %eax,%eax
  800ac3:	74 19                	je     800ade <_main+0xaa6>
  800ac5:	68 84 3f 80 00       	push   $0x803f84
  800aca:	68 4a 3e 80 00       	push   $0x803e4a
  800acf:	68 de 00 00 00       	push   $0xde
  800ad4:	68 86 3d 80 00       	push   $0x803d86
  800ad9:	e8 a9 01 00 00       	call   800c87 <_panic>
		assert(sys_getSemaphoreValue(envID, _cust_ready) == -3);

		assert(sys_getSemaphoreValue(envID, _custTerminated) ==  0);

		int s=0;
		for(s=0; s<numOfCustomers; ++s)
  800ade:	ff 45 c0             	incl   -0x40(%ebp)
  800ae1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800ae4:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  800ae7:	0f 8c 5e ff ff ff    	jl     800a4b <_main+0xa13>
			ltostr(s, id);
			strcconcat(prefix, id, cust_finishedSemaphoreName);
			assert(sys_getSemaphoreValue(envID, cust_finishedSemaphoreName) ==  0);
		}

		cprintf("Congratulations, All reservations are successfully done... have a nice flight :)\n");
  800aed:	83 ec 0c             	sub    $0xc,%esp
  800af0:	68 c4 3f 80 00       	push   $0x803fc4
  800af5:	e8 41 04 00 00       	call   800f3b <cprintf>
  800afa:	83 c4 10             	add    $0x10,%esp
	}

}
  800afd:	90                   	nop
  800afe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b01:	5b                   	pop    %ebx
  800b02:	5e                   	pop    %esi
  800b03:	5f                   	pop    %edi
  800b04:	5d                   	pop    %ebp
  800b05:	c3                   	ret    

00800b06 <find>:


int find(int* arr, int size, int val)
{
  800b06:	55                   	push   %ebp
  800b07:	89 e5                	mov    %esp,%ebp
  800b09:	83 ec 10             	sub    $0x10,%esp

	int result = 0;
  800b0c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

	int i;
	for(i=0; i<size;++i )
  800b13:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800b1a:	eb 22                	jmp    800b3e <find+0x38>
	{
		if(arr[i] == val)
  800b1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b1f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	01 d0                	add    %edx,%eax
  800b2b:	8b 00                	mov    (%eax),%eax
  800b2d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b30:	75 09                	jne    800b3b <find+0x35>
		{
			result = 1;
  800b32:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
			break;
  800b39:	eb 0b                	jmp    800b46 <find+0x40>
{

	int result = 0;

	int i;
	for(i=0; i<size;++i )
  800b3b:	ff 45 f8             	incl   -0x8(%ebp)
  800b3e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b41:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800b44:	7c d6                	jl     800b1c <find+0x16>
			result = 1;
			break;
		}
	}

	return result;
  800b46:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b49:	c9                   	leave  
  800b4a:	c3                   	ret    

00800b4b <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800b4b:	55                   	push   %ebp
  800b4c:	89 e5                	mov    %esp,%ebp
  800b4e:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800b51:	e8 61 1a 00 00       	call   8025b7 <sys_getenvindex>
  800b56:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800b59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b5c:	89 d0                	mov    %edx,%eax
  800b5e:	c1 e0 03             	shl    $0x3,%eax
  800b61:	01 d0                	add    %edx,%eax
  800b63:	01 c0                	add    %eax,%eax
  800b65:	01 d0                	add    %edx,%eax
  800b67:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b6e:	01 d0                	add    %edx,%eax
  800b70:	c1 e0 04             	shl    $0x4,%eax
  800b73:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800b78:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800b7d:	a1 20 50 80 00       	mov    0x805020,%eax
  800b82:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800b88:	84 c0                	test   %al,%al
  800b8a:	74 0f                	je     800b9b <libmain+0x50>
		binaryname = myEnv->prog_name;
  800b8c:	a1 20 50 80 00       	mov    0x805020,%eax
  800b91:	05 5c 05 00 00       	add    $0x55c,%eax
  800b96:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800b9b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b9f:	7e 0a                	jle    800bab <libmain+0x60>
		binaryname = argv[0];
  800ba1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba4:	8b 00                	mov    (%eax),%eax
  800ba6:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800bab:	83 ec 08             	sub    $0x8,%esp
  800bae:	ff 75 0c             	pushl  0xc(%ebp)
  800bb1:	ff 75 08             	pushl  0x8(%ebp)
  800bb4:	e8 7f f4 ff ff       	call   800038 <_main>
  800bb9:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800bbc:	e8 03 18 00 00       	call   8023c4 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800bc1:	83 ec 0c             	sub    $0xc,%esp
  800bc4:	68 48 41 80 00       	push   $0x804148
  800bc9:	e8 6d 03 00 00       	call   800f3b <cprintf>
  800bce:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800bd1:	a1 20 50 80 00       	mov    0x805020,%eax
  800bd6:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800bdc:	a1 20 50 80 00       	mov    0x805020,%eax
  800be1:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800be7:	83 ec 04             	sub    $0x4,%esp
  800bea:	52                   	push   %edx
  800beb:	50                   	push   %eax
  800bec:	68 70 41 80 00       	push   $0x804170
  800bf1:	e8 45 03 00 00       	call   800f3b <cprintf>
  800bf6:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800bf9:	a1 20 50 80 00       	mov    0x805020,%eax
  800bfe:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800c04:	a1 20 50 80 00       	mov    0x805020,%eax
  800c09:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800c0f:	a1 20 50 80 00       	mov    0x805020,%eax
  800c14:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800c1a:	51                   	push   %ecx
  800c1b:	52                   	push   %edx
  800c1c:	50                   	push   %eax
  800c1d:	68 98 41 80 00       	push   $0x804198
  800c22:	e8 14 03 00 00       	call   800f3b <cprintf>
  800c27:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800c2a:	a1 20 50 80 00       	mov    0x805020,%eax
  800c2f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800c35:	83 ec 08             	sub    $0x8,%esp
  800c38:	50                   	push   %eax
  800c39:	68 f0 41 80 00       	push   $0x8041f0
  800c3e:	e8 f8 02 00 00       	call   800f3b <cprintf>
  800c43:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800c46:	83 ec 0c             	sub    $0xc,%esp
  800c49:	68 48 41 80 00       	push   $0x804148
  800c4e:	e8 e8 02 00 00       	call   800f3b <cprintf>
  800c53:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800c56:	e8 83 17 00 00       	call   8023de <sys_enable_interrupt>

	// exit gracefully
	exit();
  800c5b:	e8 19 00 00 00       	call   800c79 <exit>
}
  800c60:	90                   	nop
  800c61:	c9                   	leave  
  800c62:	c3                   	ret    

00800c63 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800c63:	55                   	push   %ebp
  800c64:	89 e5                	mov    %esp,%ebp
  800c66:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800c69:	83 ec 0c             	sub    $0xc,%esp
  800c6c:	6a 00                	push   $0x0
  800c6e:	e8 10 19 00 00       	call   802583 <sys_destroy_env>
  800c73:	83 c4 10             	add    $0x10,%esp
}
  800c76:	90                   	nop
  800c77:	c9                   	leave  
  800c78:	c3                   	ret    

00800c79 <exit>:

void
exit(void)
{
  800c79:	55                   	push   %ebp
  800c7a:	89 e5                	mov    %esp,%ebp
  800c7c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800c7f:	e8 65 19 00 00       	call   8025e9 <sys_exit_env>
}
  800c84:	90                   	nop
  800c85:	c9                   	leave  
  800c86:	c3                   	ret    

00800c87 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800c87:	55                   	push   %ebp
  800c88:	89 e5                	mov    %esp,%ebp
  800c8a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800c8d:	8d 45 10             	lea    0x10(%ebp),%eax
  800c90:	83 c0 04             	add    $0x4,%eax
  800c93:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800c96:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800c9b:	85 c0                	test   %eax,%eax
  800c9d:	74 16                	je     800cb5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800c9f:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800ca4:	83 ec 08             	sub    $0x8,%esp
  800ca7:	50                   	push   %eax
  800ca8:	68 04 42 80 00       	push   $0x804204
  800cad:	e8 89 02 00 00       	call   800f3b <cprintf>
  800cb2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800cb5:	a1 00 50 80 00       	mov    0x805000,%eax
  800cba:	ff 75 0c             	pushl  0xc(%ebp)
  800cbd:	ff 75 08             	pushl  0x8(%ebp)
  800cc0:	50                   	push   %eax
  800cc1:	68 09 42 80 00       	push   $0x804209
  800cc6:	e8 70 02 00 00       	call   800f3b <cprintf>
  800ccb:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800cce:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd1:	83 ec 08             	sub    $0x8,%esp
  800cd4:	ff 75 f4             	pushl  -0xc(%ebp)
  800cd7:	50                   	push   %eax
  800cd8:	e8 f3 01 00 00       	call   800ed0 <vcprintf>
  800cdd:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800ce0:	83 ec 08             	sub    $0x8,%esp
  800ce3:	6a 00                	push   $0x0
  800ce5:	68 25 42 80 00       	push   $0x804225
  800cea:	e8 e1 01 00 00       	call   800ed0 <vcprintf>
  800cef:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800cf2:	e8 82 ff ff ff       	call   800c79 <exit>

	// should not return here
	while (1) ;
  800cf7:	eb fe                	jmp    800cf7 <_panic+0x70>

00800cf9 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800cf9:	55                   	push   %ebp
  800cfa:	89 e5                	mov    %esp,%ebp
  800cfc:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800cff:	a1 20 50 80 00       	mov    0x805020,%eax
  800d04:	8b 50 74             	mov    0x74(%eax),%edx
  800d07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0a:	39 c2                	cmp    %eax,%edx
  800d0c:	74 14                	je     800d22 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800d0e:	83 ec 04             	sub    $0x4,%esp
  800d11:	68 28 42 80 00       	push   $0x804228
  800d16:	6a 26                	push   $0x26
  800d18:	68 74 42 80 00       	push   $0x804274
  800d1d:	e8 65 ff ff ff       	call   800c87 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800d22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800d29:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d30:	e9 c2 00 00 00       	jmp    800df7 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800d35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d38:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d42:	01 d0                	add    %edx,%eax
  800d44:	8b 00                	mov    (%eax),%eax
  800d46:	85 c0                	test   %eax,%eax
  800d48:	75 08                	jne    800d52 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800d4a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800d4d:	e9 a2 00 00 00       	jmp    800df4 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800d52:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800d59:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800d60:	eb 69                	jmp    800dcb <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800d62:	a1 20 50 80 00       	mov    0x805020,%eax
  800d67:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d6d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d70:	89 d0                	mov    %edx,%eax
  800d72:	01 c0                	add    %eax,%eax
  800d74:	01 d0                	add    %edx,%eax
  800d76:	c1 e0 03             	shl    $0x3,%eax
  800d79:	01 c8                	add    %ecx,%eax
  800d7b:	8a 40 04             	mov    0x4(%eax),%al
  800d7e:	84 c0                	test   %al,%al
  800d80:	75 46                	jne    800dc8 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800d82:	a1 20 50 80 00       	mov    0x805020,%eax
  800d87:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d8d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d90:	89 d0                	mov    %edx,%eax
  800d92:	01 c0                	add    %eax,%eax
  800d94:	01 d0                	add    %edx,%eax
  800d96:	c1 e0 03             	shl    $0x3,%eax
  800d99:	01 c8                	add    %ecx,%eax
  800d9b:	8b 00                	mov    (%eax),%eax
  800d9d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800da0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800da3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800da8:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800daa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dad:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	01 c8                	add    %ecx,%eax
  800db9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800dbb:	39 c2                	cmp    %eax,%edx
  800dbd:	75 09                	jne    800dc8 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800dbf:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800dc6:	eb 12                	jmp    800dda <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800dc8:	ff 45 e8             	incl   -0x18(%ebp)
  800dcb:	a1 20 50 80 00       	mov    0x805020,%eax
  800dd0:	8b 50 74             	mov    0x74(%eax),%edx
  800dd3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800dd6:	39 c2                	cmp    %eax,%edx
  800dd8:	77 88                	ja     800d62 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800dda:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800dde:	75 14                	jne    800df4 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800de0:	83 ec 04             	sub    $0x4,%esp
  800de3:	68 80 42 80 00       	push   $0x804280
  800de8:	6a 3a                	push   $0x3a
  800dea:	68 74 42 80 00       	push   $0x804274
  800def:	e8 93 fe ff ff       	call   800c87 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800df4:	ff 45 f0             	incl   -0x10(%ebp)
  800df7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dfa:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800dfd:	0f 8c 32 ff ff ff    	jl     800d35 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800e03:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e0a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800e11:	eb 26                	jmp    800e39 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800e13:	a1 20 50 80 00       	mov    0x805020,%eax
  800e18:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800e1e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e21:	89 d0                	mov    %edx,%eax
  800e23:	01 c0                	add    %eax,%eax
  800e25:	01 d0                	add    %edx,%eax
  800e27:	c1 e0 03             	shl    $0x3,%eax
  800e2a:	01 c8                	add    %ecx,%eax
  800e2c:	8a 40 04             	mov    0x4(%eax),%al
  800e2f:	3c 01                	cmp    $0x1,%al
  800e31:	75 03                	jne    800e36 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800e33:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e36:	ff 45 e0             	incl   -0x20(%ebp)
  800e39:	a1 20 50 80 00       	mov    0x805020,%eax
  800e3e:	8b 50 74             	mov    0x74(%eax),%edx
  800e41:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e44:	39 c2                	cmp    %eax,%edx
  800e46:	77 cb                	ja     800e13 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800e48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e4b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800e4e:	74 14                	je     800e64 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800e50:	83 ec 04             	sub    $0x4,%esp
  800e53:	68 d4 42 80 00       	push   $0x8042d4
  800e58:	6a 44                	push   $0x44
  800e5a:	68 74 42 80 00       	push   $0x804274
  800e5f:	e8 23 fe ff ff       	call   800c87 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800e64:	90                   	nop
  800e65:	c9                   	leave  
  800e66:	c3                   	ret    

00800e67 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800e67:	55                   	push   %ebp
  800e68:	89 e5                	mov    %esp,%ebp
  800e6a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800e6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e70:	8b 00                	mov    (%eax),%eax
  800e72:	8d 48 01             	lea    0x1(%eax),%ecx
  800e75:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e78:	89 0a                	mov    %ecx,(%edx)
  800e7a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7d:	88 d1                	mov    %dl,%cl
  800e7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e82:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800e86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e89:	8b 00                	mov    (%eax),%eax
  800e8b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800e90:	75 2c                	jne    800ebe <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800e92:	a0 24 50 80 00       	mov    0x805024,%al
  800e97:	0f b6 c0             	movzbl %al,%eax
  800e9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e9d:	8b 12                	mov    (%edx),%edx
  800e9f:	89 d1                	mov    %edx,%ecx
  800ea1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ea4:	83 c2 08             	add    $0x8,%edx
  800ea7:	83 ec 04             	sub    $0x4,%esp
  800eaa:	50                   	push   %eax
  800eab:	51                   	push   %ecx
  800eac:	52                   	push   %edx
  800ead:	e8 64 13 00 00       	call   802216 <sys_cputs>
  800eb2:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800eb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800ebe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec1:	8b 40 04             	mov    0x4(%eax),%eax
  800ec4:	8d 50 01             	lea    0x1(%eax),%edx
  800ec7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eca:	89 50 04             	mov    %edx,0x4(%eax)
}
  800ecd:	90                   	nop
  800ece:	c9                   	leave  
  800ecf:	c3                   	ret    

00800ed0 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800ed0:	55                   	push   %ebp
  800ed1:	89 e5                	mov    %esp,%ebp
  800ed3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800ed9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800ee0:	00 00 00 
	b.cnt = 0;
  800ee3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800eea:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800eed:	ff 75 0c             	pushl  0xc(%ebp)
  800ef0:	ff 75 08             	pushl  0x8(%ebp)
  800ef3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ef9:	50                   	push   %eax
  800efa:	68 67 0e 80 00       	push   $0x800e67
  800eff:	e8 11 02 00 00       	call   801115 <vprintfmt>
  800f04:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800f07:	a0 24 50 80 00       	mov    0x805024,%al
  800f0c:	0f b6 c0             	movzbl %al,%eax
  800f0f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800f15:	83 ec 04             	sub    $0x4,%esp
  800f18:	50                   	push   %eax
  800f19:	52                   	push   %edx
  800f1a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800f20:	83 c0 08             	add    $0x8,%eax
  800f23:	50                   	push   %eax
  800f24:	e8 ed 12 00 00       	call   802216 <sys_cputs>
  800f29:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800f2c:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800f33:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800f39:	c9                   	leave  
  800f3a:	c3                   	ret    

00800f3b <cprintf>:

int cprintf(const char *fmt, ...) {
  800f3b:	55                   	push   %ebp
  800f3c:	89 e5                	mov    %esp,%ebp
  800f3e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800f41:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800f48:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f51:	83 ec 08             	sub    $0x8,%esp
  800f54:	ff 75 f4             	pushl  -0xc(%ebp)
  800f57:	50                   	push   %eax
  800f58:	e8 73 ff ff ff       	call   800ed0 <vcprintf>
  800f5d:	83 c4 10             	add    $0x10,%esp
  800f60:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800f63:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f66:	c9                   	leave  
  800f67:	c3                   	ret    

00800f68 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800f68:	55                   	push   %ebp
  800f69:	89 e5                	mov    %esp,%ebp
  800f6b:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800f6e:	e8 51 14 00 00       	call   8023c4 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800f73:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f76:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f79:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7c:	83 ec 08             	sub    $0x8,%esp
  800f7f:	ff 75 f4             	pushl  -0xc(%ebp)
  800f82:	50                   	push   %eax
  800f83:	e8 48 ff ff ff       	call   800ed0 <vcprintf>
  800f88:	83 c4 10             	add    $0x10,%esp
  800f8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800f8e:	e8 4b 14 00 00       	call   8023de <sys_enable_interrupt>
	return cnt;
  800f93:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f96:	c9                   	leave  
  800f97:	c3                   	ret    

00800f98 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800f98:	55                   	push   %ebp
  800f99:	89 e5                	mov    %esp,%ebp
  800f9b:	53                   	push   %ebx
  800f9c:	83 ec 14             	sub    $0x14,%esp
  800f9f:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fa5:	8b 45 14             	mov    0x14(%ebp),%eax
  800fa8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800fab:	8b 45 18             	mov    0x18(%ebp),%eax
  800fae:	ba 00 00 00 00       	mov    $0x0,%edx
  800fb3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800fb6:	77 55                	ja     80100d <printnum+0x75>
  800fb8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800fbb:	72 05                	jb     800fc2 <printnum+0x2a>
  800fbd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800fc0:	77 4b                	ja     80100d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800fc2:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800fc5:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800fc8:	8b 45 18             	mov    0x18(%ebp),%eax
  800fcb:	ba 00 00 00 00       	mov    $0x0,%edx
  800fd0:	52                   	push   %edx
  800fd1:	50                   	push   %eax
  800fd2:	ff 75 f4             	pushl  -0xc(%ebp)
  800fd5:	ff 75 f0             	pushl  -0x10(%ebp)
  800fd8:	e8 fb 2a 00 00       	call   803ad8 <__udivdi3>
  800fdd:	83 c4 10             	add    $0x10,%esp
  800fe0:	83 ec 04             	sub    $0x4,%esp
  800fe3:	ff 75 20             	pushl  0x20(%ebp)
  800fe6:	53                   	push   %ebx
  800fe7:	ff 75 18             	pushl  0x18(%ebp)
  800fea:	52                   	push   %edx
  800feb:	50                   	push   %eax
  800fec:	ff 75 0c             	pushl  0xc(%ebp)
  800fef:	ff 75 08             	pushl  0x8(%ebp)
  800ff2:	e8 a1 ff ff ff       	call   800f98 <printnum>
  800ff7:	83 c4 20             	add    $0x20,%esp
  800ffa:	eb 1a                	jmp    801016 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800ffc:	83 ec 08             	sub    $0x8,%esp
  800fff:	ff 75 0c             	pushl  0xc(%ebp)
  801002:	ff 75 20             	pushl  0x20(%ebp)
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	ff d0                	call   *%eax
  80100a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80100d:	ff 4d 1c             	decl   0x1c(%ebp)
  801010:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801014:	7f e6                	jg     800ffc <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801016:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801019:	bb 00 00 00 00       	mov    $0x0,%ebx
  80101e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801021:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801024:	53                   	push   %ebx
  801025:	51                   	push   %ecx
  801026:	52                   	push   %edx
  801027:	50                   	push   %eax
  801028:	e8 bb 2b 00 00       	call   803be8 <__umoddi3>
  80102d:	83 c4 10             	add    $0x10,%esp
  801030:	05 34 45 80 00       	add    $0x804534,%eax
  801035:	8a 00                	mov    (%eax),%al
  801037:	0f be c0             	movsbl %al,%eax
  80103a:	83 ec 08             	sub    $0x8,%esp
  80103d:	ff 75 0c             	pushl  0xc(%ebp)
  801040:	50                   	push   %eax
  801041:	8b 45 08             	mov    0x8(%ebp),%eax
  801044:	ff d0                	call   *%eax
  801046:	83 c4 10             	add    $0x10,%esp
}
  801049:	90                   	nop
  80104a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80104d:	c9                   	leave  
  80104e:	c3                   	ret    

0080104f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80104f:	55                   	push   %ebp
  801050:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801052:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801056:	7e 1c                	jle    801074 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
  80105b:	8b 00                	mov    (%eax),%eax
  80105d:	8d 50 08             	lea    0x8(%eax),%edx
  801060:	8b 45 08             	mov    0x8(%ebp),%eax
  801063:	89 10                	mov    %edx,(%eax)
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	8b 00                	mov    (%eax),%eax
  80106a:	83 e8 08             	sub    $0x8,%eax
  80106d:	8b 50 04             	mov    0x4(%eax),%edx
  801070:	8b 00                	mov    (%eax),%eax
  801072:	eb 40                	jmp    8010b4 <getuint+0x65>
	else if (lflag)
  801074:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801078:	74 1e                	je     801098 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80107a:	8b 45 08             	mov    0x8(%ebp),%eax
  80107d:	8b 00                	mov    (%eax),%eax
  80107f:	8d 50 04             	lea    0x4(%eax),%edx
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	89 10                	mov    %edx,(%eax)
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	8b 00                	mov    (%eax),%eax
  80108c:	83 e8 04             	sub    $0x4,%eax
  80108f:	8b 00                	mov    (%eax),%eax
  801091:	ba 00 00 00 00       	mov    $0x0,%edx
  801096:	eb 1c                	jmp    8010b4 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801098:	8b 45 08             	mov    0x8(%ebp),%eax
  80109b:	8b 00                	mov    (%eax),%eax
  80109d:	8d 50 04             	lea    0x4(%eax),%edx
  8010a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a3:	89 10                	mov    %edx,(%eax)
  8010a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a8:	8b 00                	mov    (%eax),%eax
  8010aa:	83 e8 04             	sub    $0x4,%eax
  8010ad:	8b 00                	mov    (%eax),%eax
  8010af:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8010b4:	5d                   	pop    %ebp
  8010b5:	c3                   	ret    

008010b6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8010b6:	55                   	push   %ebp
  8010b7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8010b9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8010bd:	7e 1c                	jle    8010db <getint+0x25>
		return va_arg(*ap, long long);
  8010bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c2:	8b 00                	mov    (%eax),%eax
  8010c4:	8d 50 08             	lea    0x8(%eax),%edx
  8010c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ca:	89 10                	mov    %edx,(%eax)
  8010cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cf:	8b 00                	mov    (%eax),%eax
  8010d1:	83 e8 08             	sub    $0x8,%eax
  8010d4:	8b 50 04             	mov    0x4(%eax),%edx
  8010d7:	8b 00                	mov    (%eax),%eax
  8010d9:	eb 38                	jmp    801113 <getint+0x5d>
	else if (lflag)
  8010db:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010df:	74 1a                	je     8010fb <getint+0x45>
		return va_arg(*ap, long);
  8010e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e4:	8b 00                	mov    (%eax),%eax
  8010e6:	8d 50 04             	lea    0x4(%eax),%edx
  8010e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ec:	89 10                	mov    %edx,(%eax)
  8010ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f1:	8b 00                	mov    (%eax),%eax
  8010f3:	83 e8 04             	sub    $0x4,%eax
  8010f6:	8b 00                	mov    (%eax),%eax
  8010f8:	99                   	cltd   
  8010f9:	eb 18                	jmp    801113 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8010fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fe:	8b 00                	mov    (%eax),%eax
  801100:	8d 50 04             	lea    0x4(%eax),%edx
  801103:	8b 45 08             	mov    0x8(%ebp),%eax
  801106:	89 10                	mov    %edx,(%eax)
  801108:	8b 45 08             	mov    0x8(%ebp),%eax
  80110b:	8b 00                	mov    (%eax),%eax
  80110d:	83 e8 04             	sub    $0x4,%eax
  801110:	8b 00                	mov    (%eax),%eax
  801112:	99                   	cltd   
}
  801113:	5d                   	pop    %ebp
  801114:	c3                   	ret    

00801115 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801115:	55                   	push   %ebp
  801116:	89 e5                	mov    %esp,%ebp
  801118:	56                   	push   %esi
  801119:	53                   	push   %ebx
  80111a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80111d:	eb 17                	jmp    801136 <vprintfmt+0x21>
			if (ch == '\0')
  80111f:	85 db                	test   %ebx,%ebx
  801121:	0f 84 af 03 00 00    	je     8014d6 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801127:	83 ec 08             	sub    $0x8,%esp
  80112a:	ff 75 0c             	pushl  0xc(%ebp)
  80112d:	53                   	push   %ebx
  80112e:	8b 45 08             	mov    0x8(%ebp),%eax
  801131:	ff d0                	call   *%eax
  801133:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801136:	8b 45 10             	mov    0x10(%ebp),%eax
  801139:	8d 50 01             	lea    0x1(%eax),%edx
  80113c:	89 55 10             	mov    %edx,0x10(%ebp)
  80113f:	8a 00                	mov    (%eax),%al
  801141:	0f b6 d8             	movzbl %al,%ebx
  801144:	83 fb 25             	cmp    $0x25,%ebx
  801147:	75 d6                	jne    80111f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801149:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80114d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801154:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80115b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801162:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801169:	8b 45 10             	mov    0x10(%ebp),%eax
  80116c:	8d 50 01             	lea    0x1(%eax),%edx
  80116f:	89 55 10             	mov    %edx,0x10(%ebp)
  801172:	8a 00                	mov    (%eax),%al
  801174:	0f b6 d8             	movzbl %al,%ebx
  801177:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80117a:	83 f8 55             	cmp    $0x55,%eax
  80117d:	0f 87 2b 03 00 00    	ja     8014ae <vprintfmt+0x399>
  801183:	8b 04 85 58 45 80 00 	mov    0x804558(,%eax,4),%eax
  80118a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80118c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801190:	eb d7                	jmp    801169 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801192:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801196:	eb d1                	jmp    801169 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801198:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80119f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8011a2:	89 d0                	mov    %edx,%eax
  8011a4:	c1 e0 02             	shl    $0x2,%eax
  8011a7:	01 d0                	add    %edx,%eax
  8011a9:	01 c0                	add    %eax,%eax
  8011ab:	01 d8                	add    %ebx,%eax
  8011ad:	83 e8 30             	sub    $0x30,%eax
  8011b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8011b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b6:	8a 00                	mov    (%eax),%al
  8011b8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8011bb:	83 fb 2f             	cmp    $0x2f,%ebx
  8011be:	7e 3e                	jle    8011fe <vprintfmt+0xe9>
  8011c0:	83 fb 39             	cmp    $0x39,%ebx
  8011c3:	7f 39                	jg     8011fe <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8011c5:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8011c8:	eb d5                	jmp    80119f <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8011ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8011cd:	83 c0 04             	add    $0x4,%eax
  8011d0:	89 45 14             	mov    %eax,0x14(%ebp)
  8011d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d6:	83 e8 04             	sub    $0x4,%eax
  8011d9:	8b 00                	mov    (%eax),%eax
  8011db:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8011de:	eb 1f                	jmp    8011ff <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8011e0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011e4:	79 83                	jns    801169 <vprintfmt+0x54>
				width = 0;
  8011e6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8011ed:	e9 77 ff ff ff       	jmp    801169 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8011f2:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8011f9:	e9 6b ff ff ff       	jmp    801169 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8011fe:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8011ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801203:	0f 89 60 ff ff ff    	jns    801169 <vprintfmt+0x54>
				width = precision, precision = -1;
  801209:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80120c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80120f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801216:	e9 4e ff ff ff       	jmp    801169 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80121b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80121e:	e9 46 ff ff ff       	jmp    801169 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801223:	8b 45 14             	mov    0x14(%ebp),%eax
  801226:	83 c0 04             	add    $0x4,%eax
  801229:	89 45 14             	mov    %eax,0x14(%ebp)
  80122c:	8b 45 14             	mov    0x14(%ebp),%eax
  80122f:	83 e8 04             	sub    $0x4,%eax
  801232:	8b 00                	mov    (%eax),%eax
  801234:	83 ec 08             	sub    $0x8,%esp
  801237:	ff 75 0c             	pushl  0xc(%ebp)
  80123a:	50                   	push   %eax
  80123b:	8b 45 08             	mov    0x8(%ebp),%eax
  80123e:	ff d0                	call   *%eax
  801240:	83 c4 10             	add    $0x10,%esp
			break;
  801243:	e9 89 02 00 00       	jmp    8014d1 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801248:	8b 45 14             	mov    0x14(%ebp),%eax
  80124b:	83 c0 04             	add    $0x4,%eax
  80124e:	89 45 14             	mov    %eax,0x14(%ebp)
  801251:	8b 45 14             	mov    0x14(%ebp),%eax
  801254:	83 e8 04             	sub    $0x4,%eax
  801257:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801259:	85 db                	test   %ebx,%ebx
  80125b:	79 02                	jns    80125f <vprintfmt+0x14a>
				err = -err;
  80125d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80125f:	83 fb 64             	cmp    $0x64,%ebx
  801262:	7f 0b                	jg     80126f <vprintfmt+0x15a>
  801264:	8b 34 9d a0 43 80 00 	mov    0x8043a0(,%ebx,4),%esi
  80126b:	85 f6                	test   %esi,%esi
  80126d:	75 19                	jne    801288 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80126f:	53                   	push   %ebx
  801270:	68 45 45 80 00       	push   $0x804545
  801275:	ff 75 0c             	pushl  0xc(%ebp)
  801278:	ff 75 08             	pushl  0x8(%ebp)
  80127b:	e8 5e 02 00 00       	call   8014de <printfmt>
  801280:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801283:	e9 49 02 00 00       	jmp    8014d1 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801288:	56                   	push   %esi
  801289:	68 4e 45 80 00       	push   $0x80454e
  80128e:	ff 75 0c             	pushl  0xc(%ebp)
  801291:	ff 75 08             	pushl  0x8(%ebp)
  801294:	e8 45 02 00 00       	call   8014de <printfmt>
  801299:	83 c4 10             	add    $0x10,%esp
			break;
  80129c:	e9 30 02 00 00       	jmp    8014d1 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8012a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a4:	83 c0 04             	add    $0x4,%eax
  8012a7:	89 45 14             	mov    %eax,0x14(%ebp)
  8012aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ad:	83 e8 04             	sub    $0x4,%eax
  8012b0:	8b 30                	mov    (%eax),%esi
  8012b2:	85 f6                	test   %esi,%esi
  8012b4:	75 05                	jne    8012bb <vprintfmt+0x1a6>
				p = "(null)";
  8012b6:	be 51 45 80 00       	mov    $0x804551,%esi
			if (width > 0 && padc != '-')
  8012bb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012bf:	7e 6d                	jle    80132e <vprintfmt+0x219>
  8012c1:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8012c5:	74 67                	je     80132e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8012c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012ca:	83 ec 08             	sub    $0x8,%esp
  8012cd:	50                   	push   %eax
  8012ce:	56                   	push   %esi
  8012cf:	e8 0c 03 00 00       	call   8015e0 <strnlen>
  8012d4:	83 c4 10             	add    $0x10,%esp
  8012d7:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8012da:	eb 16                	jmp    8012f2 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8012dc:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8012e0:	83 ec 08             	sub    $0x8,%esp
  8012e3:	ff 75 0c             	pushl  0xc(%ebp)
  8012e6:	50                   	push   %eax
  8012e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ea:	ff d0                	call   *%eax
  8012ec:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8012ef:	ff 4d e4             	decl   -0x1c(%ebp)
  8012f2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012f6:	7f e4                	jg     8012dc <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8012f8:	eb 34                	jmp    80132e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8012fa:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8012fe:	74 1c                	je     80131c <vprintfmt+0x207>
  801300:	83 fb 1f             	cmp    $0x1f,%ebx
  801303:	7e 05                	jle    80130a <vprintfmt+0x1f5>
  801305:	83 fb 7e             	cmp    $0x7e,%ebx
  801308:	7e 12                	jle    80131c <vprintfmt+0x207>
					putch('?', putdat);
  80130a:	83 ec 08             	sub    $0x8,%esp
  80130d:	ff 75 0c             	pushl  0xc(%ebp)
  801310:	6a 3f                	push   $0x3f
  801312:	8b 45 08             	mov    0x8(%ebp),%eax
  801315:	ff d0                	call   *%eax
  801317:	83 c4 10             	add    $0x10,%esp
  80131a:	eb 0f                	jmp    80132b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80131c:	83 ec 08             	sub    $0x8,%esp
  80131f:	ff 75 0c             	pushl  0xc(%ebp)
  801322:	53                   	push   %ebx
  801323:	8b 45 08             	mov    0x8(%ebp),%eax
  801326:	ff d0                	call   *%eax
  801328:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80132b:	ff 4d e4             	decl   -0x1c(%ebp)
  80132e:	89 f0                	mov    %esi,%eax
  801330:	8d 70 01             	lea    0x1(%eax),%esi
  801333:	8a 00                	mov    (%eax),%al
  801335:	0f be d8             	movsbl %al,%ebx
  801338:	85 db                	test   %ebx,%ebx
  80133a:	74 24                	je     801360 <vprintfmt+0x24b>
  80133c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801340:	78 b8                	js     8012fa <vprintfmt+0x1e5>
  801342:	ff 4d e0             	decl   -0x20(%ebp)
  801345:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801349:	79 af                	jns    8012fa <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80134b:	eb 13                	jmp    801360 <vprintfmt+0x24b>
				putch(' ', putdat);
  80134d:	83 ec 08             	sub    $0x8,%esp
  801350:	ff 75 0c             	pushl  0xc(%ebp)
  801353:	6a 20                	push   $0x20
  801355:	8b 45 08             	mov    0x8(%ebp),%eax
  801358:	ff d0                	call   *%eax
  80135a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80135d:	ff 4d e4             	decl   -0x1c(%ebp)
  801360:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801364:	7f e7                	jg     80134d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801366:	e9 66 01 00 00       	jmp    8014d1 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80136b:	83 ec 08             	sub    $0x8,%esp
  80136e:	ff 75 e8             	pushl  -0x18(%ebp)
  801371:	8d 45 14             	lea    0x14(%ebp),%eax
  801374:	50                   	push   %eax
  801375:	e8 3c fd ff ff       	call   8010b6 <getint>
  80137a:	83 c4 10             	add    $0x10,%esp
  80137d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801380:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801383:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801386:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801389:	85 d2                	test   %edx,%edx
  80138b:	79 23                	jns    8013b0 <vprintfmt+0x29b>
				putch('-', putdat);
  80138d:	83 ec 08             	sub    $0x8,%esp
  801390:	ff 75 0c             	pushl  0xc(%ebp)
  801393:	6a 2d                	push   $0x2d
  801395:	8b 45 08             	mov    0x8(%ebp),%eax
  801398:	ff d0                	call   *%eax
  80139a:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80139d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013a3:	f7 d8                	neg    %eax
  8013a5:	83 d2 00             	adc    $0x0,%edx
  8013a8:	f7 da                	neg    %edx
  8013aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013ad:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8013b0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8013b7:	e9 bc 00 00 00       	jmp    801478 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8013bc:	83 ec 08             	sub    $0x8,%esp
  8013bf:	ff 75 e8             	pushl  -0x18(%ebp)
  8013c2:	8d 45 14             	lea    0x14(%ebp),%eax
  8013c5:	50                   	push   %eax
  8013c6:	e8 84 fc ff ff       	call   80104f <getuint>
  8013cb:	83 c4 10             	add    $0x10,%esp
  8013ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013d1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8013d4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8013db:	e9 98 00 00 00       	jmp    801478 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8013e0:	83 ec 08             	sub    $0x8,%esp
  8013e3:	ff 75 0c             	pushl  0xc(%ebp)
  8013e6:	6a 58                	push   $0x58
  8013e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013eb:	ff d0                	call   *%eax
  8013ed:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8013f0:	83 ec 08             	sub    $0x8,%esp
  8013f3:	ff 75 0c             	pushl  0xc(%ebp)
  8013f6:	6a 58                	push   $0x58
  8013f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fb:	ff d0                	call   *%eax
  8013fd:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801400:	83 ec 08             	sub    $0x8,%esp
  801403:	ff 75 0c             	pushl  0xc(%ebp)
  801406:	6a 58                	push   $0x58
  801408:	8b 45 08             	mov    0x8(%ebp),%eax
  80140b:	ff d0                	call   *%eax
  80140d:	83 c4 10             	add    $0x10,%esp
			break;
  801410:	e9 bc 00 00 00       	jmp    8014d1 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801415:	83 ec 08             	sub    $0x8,%esp
  801418:	ff 75 0c             	pushl  0xc(%ebp)
  80141b:	6a 30                	push   $0x30
  80141d:	8b 45 08             	mov    0x8(%ebp),%eax
  801420:	ff d0                	call   *%eax
  801422:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801425:	83 ec 08             	sub    $0x8,%esp
  801428:	ff 75 0c             	pushl  0xc(%ebp)
  80142b:	6a 78                	push   $0x78
  80142d:	8b 45 08             	mov    0x8(%ebp),%eax
  801430:	ff d0                	call   *%eax
  801432:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801435:	8b 45 14             	mov    0x14(%ebp),%eax
  801438:	83 c0 04             	add    $0x4,%eax
  80143b:	89 45 14             	mov    %eax,0x14(%ebp)
  80143e:	8b 45 14             	mov    0x14(%ebp),%eax
  801441:	83 e8 04             	sub    $0x4,%eax
  801444:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801446:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801449:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801450:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801457:	eb 1f                	jmp    801478 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801459:	83 ec 08             	sub    $0x8,%esp
  80145c:	ff 75 e8             	pushl  -0x18(%ebp)
  80145f:	8d 45 14             	lea    0x14(%ebp),%eax
  801462:	50                   	push   %eax
  801463:	e8 e7 fb ff ff       	call   80104f <getuint>
  801468:	83 c4 10             	add    $0x10,%esp
  80146b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80146e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801471:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801478:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80147c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80147f:	83 ec 04             	sub    $0x4,%esp
  801482:	52                   	push   %edx
  801483:	ff 75 e4             	pushl  -0x1c(%ebp)
  801486:	50                   	push   %eax
  801487:	ff 75 f4             	pushl  -0xc(%ebp)
  80148a:	ff 75 f0             	pushl  -0x10(%ebp)
  80148d:	ff 75 0c             	pushl  0xc(%ebp)
  801490:	ff 75 08             	pushl  0x8(%ebp)
  801493:	e8 00 fb ff ff       	call   800f98 <printnum>
  801498:	83 c4 20             	add    $0x20,%esp
			break;
  80149b:	eb 34                	jmp    8014d1 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80149d:	83 ec 08             	sub    $0x8,%esp
  8014a0:	ff 75 0c             	pushl  0xc(%ebp)
  8014a3:	53                   	push   %ebx
  8014a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a7:	ff d0                	call   *%eax
  8014a9:	83 c4 10             	add    $0x10,%esp
			break;
  8014ac:	eb 23                	jmp    8014d1 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8014ae:	83 ec 08             	sub    $0x8,%esp
  8014b1:	ff 75 0c             	pushl  0xc(%ebp)
  8014b4:	6a 25                	push   $0x25
  8014b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b9:	ff d0                	call   *%eax
  8014bb:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8014be:	ff 4d 10             	decl   0x10(%ebp)
  8014c1:	eb 03                	jmp    8014c6 <vprintfmt+0x3b1>
  8014c3:	ff 4d 10             	decl   0x10(%ebp)
  8014c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c9:	48                   	dec    %eax
  8014ca:	8a 00                	mov    (%eax),%al
  8014cc:	3c 25                	cmp    $0x25,%al
  8014ce:	75 f3                	jne    8014c3 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8014d0:	90                   	nop
		}
	}
  8014d1:	e9 47 fc ff ff       	jmp    80111d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8014d6:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8014d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014da:	5b                   	pop    %ebx
  8014db:	5e                   	pop    %esi
  8014dc:	5d                   	pop    %ebp
  8014dd:	c3                   	ret    

008014de <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8014de:	55                   	push   %ebp
  8014df:	89 e5                	mov    %esp,%ebp
  8014e1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8014e4:	8d 45 10             	lea    0x10(%ebp),%eax
  8014e7:	83 c0 04             	add    $0x4,%eax
  8014ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8014ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f0:	ff 75 f4             	pushl  -0xc(%ebp)
  8014f3:	50                   	push   %eax
  8014f4:	ff 75 0c             	pushl  0xc(%ebp)
  8014f7:	ff 75 08             	pushl  0x8(%ebp)
  8014fa:	e8 16 fc ff ff       	call   801115 <vprintfmt>
  8014ff:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801502:	90                   	nop
  801503:	c9                   	leave  
  801504:	c3                   	ret    

00801505 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801505:	55                   	push   %ebp
  801506:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801508:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150b:	8b 40 08             	mov    0x8(%eax),%eax
  80150e:	8d 50 01             	lea    0x1(%eax),%edx
  801511:	8b 45 0c             	mov    0xc(%ebp),%eax
  801514:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801517:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151a:	8b 10                	mov    (%eax),%edx
  80151c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151f:	8b 40 04             	mov    0x4(%eax),%eax
  801522:	39 c2                	cmp    %eax,%edx
  801524:	73 12                	jae    801538 <sprintputch+0x33>
		*b->buf++ = ch;
  801526:	8b 45 0c             	mov    0xc(%ebp),%eax
  801529:	8b 00                	mov    (%eax),%eax
  80152b:	8d 48 01             	lea    0x1(%eax),%ecx
  80152e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801531:	89 0a                	mov    %ecx,(%edx)
  801533:	8b 55 08             	mov    0x8(%ebp),%edx
  801536:	88 10                	mov    %dl,(%eax)
}
  801538:	90                   	nop
  801539:	5d                   	pop    %ebp
  80153a:	c3                   	ret    

0080153b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80153b:	55                   	push   %ebp
  80153c:	89 e5                	mov    %esp,%ebp
  80153e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801541:	8b 45 08             	mov    0x8(%ebp),%eax
  801544:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801547:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80154d:	8b 45 08             	mov    0x8(%ebp),%eax
  801550:	01 d0                	add    %edx,%eax
  801552:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801555:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80155c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801560:	74 06                	je     801568 <vsnprintf+0x2d>
  801562:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801566:	7f 07                	jg     80156f <vsnprintf+0x34>
		return -E_INVAL;
  801568:	b8 03 00 00 00       	mov    $0x3,%eax
  80156d:	eb 20                	jmp    80158f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80156f:	ff 75 14             	pushl  0x14(%ebp)
  801572:	ff 75 10             	pushl  0x10(%ebp)
  801575:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801578:	50                   	push   %eax
  801579:	68 05 15 80 00       	push   $0x801505
  80157e:	e8 92 fb ff ff       	call   801115 <vprintfmt>
  801583:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801586:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801589:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80158c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80158f:	c9                   	leave  
  801590:	c3                   	ret    

00801591 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801591:	55                   	push   %ebp
  801592:	89 e5                	mov    %esp,%ebp
  801594:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801597:	8d 45 10             	lea    0x10(%ebp),%eax
  80159a:	83 c0 04             	add    $0x4,%eax
  80159d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8015a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8015a6:	50                   	push   %eax
  8015a7:	ff 75 0c             	pushl  0xc(%ebp)
  8015aa:	ff 75 08             	pushl  0x8(%ebp)
  8015ad:	e8 89 ff ff ff       	call   80153b <vsnprintf>
  8015b2:	83 c4 10             	add    $0x10,%esp
  8015b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8015b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015bb:	c9                   	leave  
  8015bc:	c3                   	ret    

008015bd <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8015bd:	55                   	push   %ebp
  8015be:	89 e5                	mov    %esp,%ebp
  8015c0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8015c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015ca:	eb 06                	jmp    8015d2 <strlen+0x15>
		n++;
  8015cc:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8015cf:	ff 45 08             	incl   0x8(%ebp)
  8015d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d5:	8a 00                	mov    (%eax),%al
  8015d7:	84 c0                	test   %al,%al
  8015d9:	75 f1                	jne    8015cc <strlen+0xf>
		n++;
	return n;
  8015db:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015de:	c9                   	leave  
  8015df:	c3                   	ret    

008015e0 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8015e0:	55                   	push   %ebp
  8015e1:	89 e5                	mov    %esp,%ebp
  8015e3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015ed:	eb 09                	jmp    8015f8 <strnlen+0x18>
		n++;
  8015ef:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015f2:	ff 45 08             	incl   0x8(%ebp)
  8015f5:	ff 4d 0c             	decl   0xc(%ebp)
  8015f8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015fc:	74 09                	je     801607 <strnlen+0x27>
  8015fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801601:	8a 00                	mov    (%eax),%al
  801603:	84 c0                	test   %al,%al
  801605:	75 e8                	jne    8015ef <strnlen+0xf>
		n++;
	return n;
  801607:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80160a:	c9                   	leave  
  80160b:	c3                   	ret    

0080160c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80160c:	55                   	push   %ebp
  80160d:	89 e5                	mov    %esp,%ebp
  80160f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801612:	8b 45 08             	mov    0x8(%ebp),%eax
  801615:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801618:	90                   	nop
  801619:	8b 45 08             	mov    0x8(%ebp),%eax
  80161c:	8d 50 01             	lea    0x1(%eax),%edx
  80161f:	89 55 08             	mov    %edx,0x8(%ebp)
  801622:	8b 55 0c             	mov    0xc(%ebp),%edx
  801625:	8d 4a 01             	lea    0x1(%edx),%ecx
  801628:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80162b:	8a 12                	mov    (%edx),%dl
  80162d:	88 10                	mov    %dl,(%eax)
  80162f:	8a 00                	mov    (%eax),%al
  801631:	84 c0                	test   %al,%al
  801633:	75 e4                	jne    801619 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801635:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801638:	c9                   	leave  
  801639:	c3                   	ret    

0080163a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80163a:	55                   	push   %ebp
  80163b:	89 e5                	mov    %esp,%ebp
  80163d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801640:	8b 45 08             	mov    0x8(%ebp),%eax
  801643:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801646:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80164d:	eb 1f                	jmp    80166e <strncpy+0x34>
		*dst++ = *src;
  80164f:	8b 45 08             	mov    0x8(%ebp),%eax
  801652:	8d 50 01             	lea    0x1(%eax),%edx
  801655:	89 55 08             	mov    %edx,0x8(%ebp)
  801658:	8b 55 0c             	mov    0xc(%ebp),%edx
  80165b:	8a 12                	mov    (%edx),%dl
  80165d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80165f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801662:	8a 00                	mov    (%eax),%al
  801664:	84 c0                	test   %al,%al
  801666:	74 03                	je     80166b <strncpy+0x31>
			src++;
  801668:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80166b:	ff 45 fc             	incl   -0x4(%ebp)
  80166e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801671:	3b 45 10             	cmp    0x10(%ebp),%eax
  801674:	72 d9                	jb     80164f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801676:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801679:	c9                   	leave  
  80167a:	c3                   	ret    

0080167b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80167b:	55                   	push   %ebp
  80167c:	89 e5                	mov    %esp,%ebp
  80167e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801681:	8b 45 08             	mov    0x8(%ebp),%eax
  801684:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801687:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80168b:	74 30                	je     8016bd <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80168d:	eb 16                	jmp    8016a5 <strlcpy+0x2a>
			*dst++ = *src++;
  80168f:	8b 45 08             	mov    0x8(%ebp),%eax
  801692:	8d 50 01             	lea    0x1(%eax),%edx
  801695:	89 55 08             	mov    %edx,0x8(%ebp)
  801698:	8b 55 0c             	mov    0xc(%ebp),%edx
  80169b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80169e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8016a1:	8a 12                	mov    (%edx),%dl
  8016a3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8016a5:	ff 4d 10             	decl   0x10(%ebp)
  8016a8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016ac:	74 09                	je     8016b7 <strlcpy+0x3c>
  8016ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b1:	8a 00                	mov    (%eax),%al
  8016b3:	84 c0                	test   %al,%al
  8016b5:	75 d8                	jne    80168f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8016b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ba:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8016bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8016c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016c3:	29 c2                	sub    %eax,%edx
  8016c5:	89 d0                	mov    %edx,%eax
}
  8016c7:	c9                   	leave  
  8016c8:	c3                   	ret    

008016c9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8016c9:	55                   	push   %ebp
  8016ca:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8016cc:	eb 06                	jmp    8016d4 <strcmp+0xb>
		p++, q++;
  8016ce:	ff 45 08             	incl   0x8(%ebp)
  8016d1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8016d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d7:	8a 00                	mov    (%eax),%al
  8016d9:	84 c0                	test   %al,%al
  8016db:	74 0e                	je     8016eb <strcmp+0x22>
  8016dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e0:	8a 10                	mov    (%eax),%dl
  8016e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e5:	8a 00                	mov    (%eax),%al
  8016e7:	38 c2                	cmp    %al,%dl
  8016e9:	74 e3                	je     8016ce <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8016eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ee:	8a 00                	mov    (%eax),%al
  8016f0:	0f b6 d0             	movzbl %al,%edx
  8016f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f6:	8a 00                	mov    (%eax),%al
  8016f8:	0f b6 c0             	movzbl %al,%eax
  8016fb:	29 c2                	sub    %eax,%edx
  8016fd:	89 d0                	mov    %edx,%eax
}
  8016ff:	5d                   	pop    %ebp
  801700:	c3                   	ret    

00801701 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801701:	55                   	push   %ebp
  801702:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801704:	eb 09                	jmp    80170f <strncmp+0xe>
		n--, p++, q++;
  801706:	ff 4d 10             	decl   0x10(%ebp)
  801709:	ff 45 08             	incl   0x8(%ebp)
  80170c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80170f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801713:	74 17                	je     80172c <strncmp+0x2b>
  801715:	8b 45 08             	mov    0x8(%ebp),%eax
  801718:	8a 00                	mov    (%eax),%al
  80171a:	84 c0                	test   %al,%al
  80171c:	74 0e                	je     80172c <strncmp+0x2b>
  80171e:	8b 45 08             	mov    0x8(%ebp),%eax
  801721:	8a 10                	mov    (%eax),%dl
  801723:	8b 45 0c             	mov    0xc(%ebp),%eax
  801726:	8a 00                	mov    (%eax),%al
  801728:	38 c2                	cmp    %al,%dl
  80172a:	74 da                	je     801706 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80172c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801730:	75 07                	jne    801739 <strncmp+0x38>
		return 0;
  801732:	b8 00 00 00 00       	mov    $0x0,%eax
  801737:	eb 14                	jmp    80174d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801739:	8b 45 08             	mov    0x8(%ebp),%eax
  80173c:	8a 00                	mov    (%eax),%al
  80173e:	0f b6 d0             	movzbl %al,%edx
  801741:	8b 45 0c             	mov    0xc(%ebp),%eax
  801744:	8a 00                	mov    (%eax),%al
  801746:	0f b6 c0             	movzbl %al,%eax
  801749:	29 c2                	sub    %eax,%edx
  80174b:	89 d0                	mov    %edx,%eax
}
  80174d:	5d                   	pop    %ebp
  80174e:	c3                   	ret    

0080174f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80174f:	55                   	push   %ebp
  801750:	89 e5                	mov    %esp,%ebp
  801752:	83 ec 04             	sub    $0x4,%esp
  801755:	8b 45 0c             	mov    0xc(%ebp),%eax
  801758:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80175b:	eb 12                	jmp    80176f <strchr+0x20>
		if (*s == c)
  80175d:	8b 45 08             	mov    0x8(%ebp),%eax
  801760:	8a 00                	mov    (%eax),%al
  801762:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801765:	75 05                	jne    80176c <strchr+0x1d>
			return (char *) s;
  801767:	8b 45 08             	mov    0x8(%ebp),%eax
  80176a:	eb 11                	jmp    80177d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80176c:	ff 45 08             	incl   0x8(%ebp)
  80176f:	8b 45 08             	mov    0x8(%ebp),%eax
  801772:	8a 00                	mov    (%eax),%al
  801774:	84 c0                	test   %al,%al
  801776:	75 e5                	jne    80175d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801778:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80177d:	c9                   	leave  
  80177e:	c3                   	ret    

0080177f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80177f:	55                   	push   %ebp
  801780:	89 e5                	mov    %esp,%ebp
  801782:	83 ec 04             	sub    $0x4,%esp
  801785:	8b 45 0c             	mov    0xc(%ebp),%eax
  801788:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80178b:	eb 0d                	jmp    80179a <strfind+0x1b>
		if (*s == c)
  80178d:	8b 45 08             	mov    0x8(%ebp),%eax
  801790:	8a 00                	mov    (%eax),%al
  801792:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801795:	74 0e                	je     8017a5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801797:	ff 45 08             	incl   0x8(%ebp)
  80179a:	8b 45 08             	mov    0x8(%ebp),%eax
  80179d:	8a 00                	mov    (%eax),%al
  80179f:	84 c0                	test   %al,%al
  8017a1:	75 ea                	jne    80178d <strfind+0xe>
  8017a3:	eb 01                	jmp    8017a6 <strfind+0x27>
		if (*s == c)
			break;
  8017a5:	90                   	nop
	return (char *) s;
  8017a6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017a9:	c9                   	leave  
  8017aa:	c3                   	ret    

008017ab <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8017ab:	55                   	push   %ebp
  8017ac:	89 e5                	mov    %esp,%ebp
  8017ae:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8017b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8017b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8017bd:	eb 0e                	jmp    8017cd <memset+0x22>
		*p++ = c;
  8017bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017c2:	8d 50 01             	lea    0x1(%eax),%edx
  8017c5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8017c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017cb:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8017cd:	ff 4d f8             	decl   -0x8(%ebp)
  8017d0:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8017d4:	79 e9                	jns    8017bf <memset+0x14>
		*p++ = c;

	return v;
  8017d6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017d9:	c9                   	leave  
  8017da:	c3                   	ret    

008017db <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
  8017de:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8017e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8017e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ea:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8017ed:	eb 16                	jmp    801805 <memcpy+0x2a>
		*d++ = *s++;
  8017ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017f2:	8d 50 01             	lea    0x1(%eax),%edx
  8017f5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017fb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8017fe:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801801:	8a 12                	mov    (%edx),%dl
  801803:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801805:	8b 45 10             	mov    0x10(%ebp),%eax
  801808:	8d 50 ff             	lea    -0x1(%eax),%edx
  80180b:	89 55 10             	mov    %edx,0x10(%ebp)
  80180e:	85 c0                	test   %eax,%eax
  801810:	75 dd                	jne    8017ef <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801812:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801815:	c9                   	leave  
  801816:	c3                   	ret    

00801817 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801817:	55                   	push   %ebp
  801818:	89 e5                	mov    %esp,%ebp
  80181a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80181d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801820:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801823:	8b 45 08             	mov    0x8(%ebp),%eax
  801826:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801829:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80182c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80182f:	73 50                	jae    801881 <memmove+0x6a>
  801831:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801834:	8b 45 10             	mov    0x10(%ebp),%eax
  801837:	01 d0                	add    %edx,%eax
  801839:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80183c:	76 43                	jbe    801881 <memmove+0x6a>
		s += n;
  80183e:	8b 45 10             	mov    0x10(%ebp),%eax
  801841:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801844:	8b 45 10             	mov    0x10(%ebp),%eax
  801847:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80184a:	eb 10                	jmp    80185c <memmove+0x45>
			*--d = *--s;
  80184c:	ff 4d f8             	decl   -0x8(%ebp)
  80184f:	ff 4d fc             	decl   -0x4(%ebp)
  801852:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801855:	8a 10                	mov    (%eax),%dl
  801857:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80185a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80185c:	8b 45 10             	mov    0x10(%ebp),%eax
  80185f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801862:	89 55 10             	mov    %edx,0x10(%ebp)
  801865:	85 c0                	test   %eax,%eax
  801867:	75 e3                	jne    80184c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801869:	eb 23                	jmp    80188e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80186b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80186e:	8d 50 01             	lea    0x1(%eax),%edx
  801871:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801874:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801877:	8d 4a 01             	lea    0x1(%edx),%ecx
  80187a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80187d:	8a 12                	mov    (%edx),%dl
  80187f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801881:	8b 45 10             	mov    0x10(%ebp),%eax
  801884:	8d 50 ff             	lea    -0x1(%eax),%edx
  801887:	89 55 10             	mov    %edx,0x10(%ebp)
  80188a:	85 c0                	test   %eax,%eax
  80188c:	75 dd                	jne    80186b <memmove+0x54>
			*d++ = *s++;

	return dst;
  80188e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801891:	c9                   	leave  
  801892:	c3                   	ret    

00801893 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
  801896:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801899:	8b 45 08             	mov    0x8(%ebp),%eax
  80189c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80189f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8018a5:	eb 2a                	jmp    8018d1 <memcmp+0x3e>
		if (*s1 != *s2)
  8018a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018aa:	8a 10                	mov    (%eax),%dl
  8018ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018af:	8a 00                	mov    (%eax),%al
  8018b1:	38 c2                	cmp    %al,%dl
  8018b3:	74 16                	je     8018cb <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8018b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018b8:	8a 00                	mov    (%eax),%al
  8018ba:	0f b6 d0             	movzbl %al,%edx
  8018bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018c0:	8a 00                	mov    (%eax),%al
  8018c2:	0f b6 c0             	movzbl %al,%eax
  8018c5:	29 c2                	sub    %eax,%edx
  8018c7:	89 d0                	mov    %edx,%eax
  8018c9:	eb 18                	jmp    8018e3 <memcmp+0x50>
		s1++, s2++;
  8018cb:	ff 45 fc             	incl   -0x4(%ebp)
  8018ce:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8018d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8018d4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018d7:	89 55 10             	mov    %edx,0x10(%ebp)
  8018da:	85 c0                	test   %eax,%eax
  8018dc:	75 c9                	jne    8018a7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8018de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018e3:	c9                   	leave  
  8018e4:	c3                   	ret    

008018e5 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8018e5:	55                   	push   %ebp
  8018e6:	89 e5                	mov    %esp,%ebp
  8018e8:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8018eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8018ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f1:	01 d0                	add    %edx,%eax
  8018f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8018f6:	eb 15                	jmp    80190d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8018f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fb:	8a 00                	mov    (%eax),%al
  8018fd:	0f b6 d0             	movzbl %al,%edx
  801900:	8b 45 0c             	mov    0xc(%ebp),%eax
  801903:	0f b6 c0             	movzbl %al,%eax
  801906:	39 c2                	cmp    %eax,%edx
  801908:	74 0d                	je     801917 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80190a:	ff 45 08             	incl   0x8(%ebp)
  80190d:	8b 45 08             	mov    0x8(%ebp),%eax
  801910:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801913:	72 e3                	jb     8018f8 <memfind+0x13>
  801915:	eb 01                	jmp    801918 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801917:	90                   	nop
	return (void *) s;
  801918:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80191b:	c9                   	leave  
  80191c:	c3                   	ret    

0080191d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80191d:	55                   	push   %ebp
  80191e:	89 e5                	mov    %esp,%ebp
  801920:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801923:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80192a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801931:	eb 03                	jmp    801936 <strtol+0x19>
		s++;
  801933:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801936:	8b 45 08             	mov    0x8(%ebp),%eax
  801939:	8a 00                	mov    (%eax),%al
  80193b:	3c 20                	cmp    $0x20,%al
  80193d:	74 f4                	je     801933 <strtol+0x16>
  80193f:	8b 45 08             	mov    0x8(%ebp),%eax
  801942:	8a 00                	mov    (%eax),%al
  801944:	3c 09                	cmp    $0x9,%al
  801946:	74 eb                	je     801933 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801948:	8b 45 08             	mov    0x8(%ebp),%eax
  80194b:	8a 00                	mov    (%eax),%al
  80194d:	3c 2b                	cmp    $0x2b,%al
  80194f:	75 05                	jne    801956 <strtol+0x39>
		s++;
  801951:	ff 45 08             	incl   0x8(%ebp)
  801954:	eb 13                	jmp    801969 <strtol+0x4c>
	else if (*s == '-')
  801956:	8b 45 08             	mov    0x8(%ebp),%eax
  801959:	8a 00                	mov    (%eax),%al
  80195b:	3c 2d                	cmp    $0x2d,%al
  80195d:	75 0a                	jne    801969 <strtol+0x4c>
		s++, neg = 1;
  80195f:	ff 45 08             	incl   0x8(%ebp)
  801962:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801969:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80196d:	74 06                	je     801975 <strtol+0x58>
  80196f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801973:	75 20                	jne    801995 <strtol+0x78>
  801975:	8b 45 08             	mov    0x8(%ebp),%eax
  801978:	8a 00                	mov    (%eax),%al
  80197a:	3c 30                	cmp    $0x30,%al
  80197c:	75 17                	jne    801995 <strtol+0x78>
  80197e:	8b 45 08             	mov    0x8(%ebp),%eax
  801981:	40                   	inc    %eax
  801982:	8a 00                	mov    (%eax),%al
  801984:	3c 78                	cmp    $0x78,%al
  801986:	75 0d                	jne    801995 <strtol+0x78>
		s += 2, base = 16;
  801988:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80198c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801993:	eb 28                	jmp    8019bd <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801995:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801999:	75 15                	jne    8019b0 <strtol+0x93>
  80199b:	8b 45 08             	mov    0x8(%ebp),%eax
  80199e:	8a 00                	mov    (%eax),%al
  8019a0:	3c 30                	cmp    $0x30,%al
  8019a2:	75 0c                	jne    8019b0 <strtol+0x93>
		s++, base = 8;
  8019a4:	ff 45 08             	incl   0x8(%ebp)
  8019a7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8019ae:	eb 0d                	jmp    8019bd <strtol+0xa0>
	else if (base == 0)
  8019b0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019b4:	75 07                	jne    8019bd <strtol+0xa0>
		base = 10;
  8019b6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8019bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c0:	8a 00                	mov    (%eax),%al
  8019c2:	3c 2f                	cmp    $0x2f,%al
  8019c4:	7e 19                	jle    8019df <strtol+0xc2>
  8019c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c9:	8a 00                	mov    (%eax),%al
  8019cb:	3c 39                	cmp    $0x39,%al
  8019cd:	7f 10                	jg     8019df <strtol+0xc2>
			dig = *s - '0';
  8019cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d2:	8a 00                	mov    (%eax),%al
  8019d4:	0f be c0             	movsbl %al,%eax
  8019d7:	83 e8 30             	sub    $0x30,%eax
  8019da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019dd:	eb 42                	jmp    801a21 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8019df:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e2:	8a 00                	mov    (%eax),%al
  8019e4:	3c 60                	cmp    $0x60,%al
  8019e6:	7e 19                	jle    801a01 <strtol+0xe4>
  8019e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019eb:	8a 00                	mov    (%eax),%al
  8019ed:	3c 7a                	cmp    $0x7a,%al
  8019ef:	7f 10                	jg     801a01 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8019f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f4:	8a 00                	mov    (%eax),%al
  8019f6:	0f be c0             	movsbl %al,%eax
  8019f9:	83 e8 57             	sub    $0x57,%eax
  8019fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019ff:	eb 20                	jmp    801a21 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801a01:	8b 45 08             	mov    0x8(%ebp),%eax
  801a04:	8a 00                	mov    (%eax),%al
  801a06:	3c 40                	cmp    $0x40,%al
  801a08:	7e 39                	jle    801a43 <strtol+0x126>
  801a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0d:	8a 00                	mov    (%eax),%al
  801a0f:	3c 5a                	cmp    $0x5a,%al
  801a11:	7f 30                	jg     801a43 <strtol+0x126>
			dig = *s - 'A' + 10;
  801a13:	8b 45 08             	mov    0x8(%ebp),%eax
  801a16:	8a 00                	mov    (%eax),%al
  801a18:	0f be c0             	movsbl %al,%eax
  801a1b:	83 e8 37             	sub    $0x37,%eax
  801a1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a24:	3b 45 10             	cmp    0x10(%ebp),%eax
  801a27:	7d 19                	jge    801a42 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801a29:	ff 45 08             	incl   0x8(%ebp)
  801a2c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a2f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801a33:	89 c2                	mov    %eax,%edx
  801a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a38:	01 d0                	add    %edx,%eax
  801a3a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801a3d:	e9 7b ff ff ff       	jmp    8019bd <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801a42:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801a43:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a47:	74 08                	je     801a51 <strtol+0x134>
		*endptr = (char *) s;
  801a49:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a4c:	8b 55 08             	mov    0x8(%ebp),%edx
  801a4f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801a51:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a55:	74 07                	je     801a5e <strtol+0x141>
  801a57:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a5a:	f7 d8                	neg    %eax
  801a5c:	eb 03                	jmp    801a61 <strtol+0x144>
  801a5e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801a61:	c9                   	leave  
  801a62:	c3                   	ret    

00801a63 <ltostr>:

void
ltostr(long value, char *str)
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
  801a66:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801a69:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801a70:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801a77:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a7b:	79 13                	jns    801a90 <ltostr+0x2d>
	{
		neg = 1;
  801a7d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801a84:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a87:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801a8a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801a8d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801a90:	8b 45 08             	mov    0x8(%ebp),%eax
  801a93:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801a98:	99                   	cltd   
  801a99:	f7 f9                	idiv   %ecx
  801a9b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801a9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801aa1:	8d 50 01             	lea    0x1(%eax),%edx
  801aa4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801aa7:	89 c2                	mov    %eax,%edx
  801aa9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aac:	01 d0                	add    %edx,%eax
  801aae:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ab1:	83 c2 30             	add    $0x30,%edx
  801ab4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801ab6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ab9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801abe:	f7 e9                	imul   %ecx
  801ac0:	c1 fa 02             	sar    $0x2,%edx
  801ac3:	89 c8                	mov    %ecx,%eax
  801ac5:	c1 f8 1f             	sar    $0x1f,%eax
  801ac8:	29 c2                	sub    %eax,%edx
  801aca:	89 d0                	mov    %edx,%eax
  801acc:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801acf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ad2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801ad7:	f7 e9                	imul   %ecx
  801ad9:	c1 fa 02             	sar    $0x2,%edx
  801adc:	89 c8                	mov    %ecx,%eax
  801ade:	c1 f8 1f             	sar    $0x1f,%eax
  801ae1:	29 c2                	sub    %eax,%edx
  801ae3:	89 d0                	mov    %edx,%eax
  801ae5:	c1 e0 02             	shl    $0x2,%eax
  801ae8:	01 d0                	add    %edx,%eax
  801aea:	01 c0                	add    %eax,%eax
  801aec:	29 c1                	sub    %eax,%ecx
  801aee:	89 ca                	mov    %ecx,%edx
  801af0:	85 d2                	test   %edx,%edx
  801af2:	75 9c                	jne    801a90 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801af4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801afb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801afe:	48                   	dec    %eax
  801aff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801b02:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801b06:	74 3d                	je     801b45 <ltostr+0xe2>
		start = 1 ;
  801b08:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801b0f:	eb 34                	jmp    801b45 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801b11:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b14:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b17:	01 d0                	add    %edx,%eax
  801b19:	8a 00                	mov    (%eax),%al
  801b1b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801b1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b21:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b24:	01 c2                	add    %eax,%edx
  801b26:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801b29:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b2c:	01 c8                	add    %ecx,%eax
  801b2e:	8a 00                	mov    (%eax),%al
  801b30:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801b32:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b35:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b38:	01 c2                	add    %eax,%edx
  801b3a:	8a 45 eb             	mov    -0x15(%ebp),%al
  801b3d:	88 02                	mov    %al,(%edx)
		start++ ;
  801b3f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801b42:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b48:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b4b:	7c c4                	jl     801b11 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801b4d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801b50:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b53:	01 d0                	add    %edx,%eax
  801b55:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801b58:	90                   	nop
  801b59:	c9                   	leave  
  801b5a:	c3                   	ret    

00801b5b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
  801b5e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801b61:	ff 75 08             	pushl  0x8(%ebp)
  801b64:	e8 54 fa ff ff       	call   8015bd <strlen>
  801b69:	83 c4 04             	add    $0x4,%esp
  801b6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801b6f:	ff 75 0c             	pushl  0xc(%ebp)
  801b72:	e8 46 fa ff ff       	call   8015bd <strlen>
  801b77:	83 c4 04             	add    $0x4,%esp
  801b7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801b7d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801b84:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b8b:	eb 17                	jmp    801ba4 <strcconcat+0x49>
		final[s] = str1[s] ;
  801b8d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b90:	8b 45 10             	mov    0x10(%ebp),%eax
  801b93:	01 c2                	add    %eax,%edx
  801b95:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b98:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9b:	01 c8                	add    %ecx,%eax
  801b9d:	8a 00                	mov    (%eax),%al
  801b9f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801ba1:	ff 45 fc             	incl   -0x4(%ebp)
  801ba4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ba7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801baa:	7c e1                	jl     801b8d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801bac:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801bb3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801bba:	eb 1f                	jmp    801bdb <strcconcat+0x80>
		final[s++] = str2[i] ;
  801bbc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bbf:	8d 50 01             	lea    0x1(%eax),%edx
  801bc2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801bc5:	89 c2                	mov    %eax,%edx
  801bc7:	8b 45 10             	mov    0x10(%ebp),%eax
  801bca:	01 c2                	add    %eax,%edx
  801bcc:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801bcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd2:	01 c8                	add    %ecx,%eax
  801bd4:	8a 00                	mov    (%eax),%al
  801bd6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801bd8:	ff 45 f8             	incl   -0x8(%ebp)
  801bdb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bde:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801be1:	7c d9                	jl     801bbc <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801be3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801be6:	8b 45 10             	mov    0x10(%ebp),%eax
  801be9:	01 d0                	add    %edx,%eax
  801beb:	c6 00 00             	movb   $0x0,(%eax)
}
  801bee:	90                   	nop
  801bef:	c9                   	leave  
  801bf0:	c3                   	ret    

00801bf1 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801bf1:	55                   	push   %ebp
  801bf2:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801bf4:	8b 45 14             	mov    0x14(%ebp),%eax
  801bf7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801bfd:	8b 45 14             	mov    0x14(%ebp),%eax
  801c00:	8b 00                	mov    (%eax),%eax
  801c02:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c09:	8b 45 10             	mov    0x10(%ebp),%eax
  801c0c:	01 d0                	add    %edx,%eax
  801c0e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c14:	eb 0c                	jmp    801c22 <strsplit+0x31>
			*string++ = 0;
  801c16:	8b 45 08             	mov    0x8(%ebp),%eax
  801c19:	8d 50 01             	lea    0x1(%eax),%edx
  801c1c:	89 55 08             	mov    %edx,0x8(%ebp)
  801c1f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c22:	8b 45 08             	mov    0x8(%ebp),%eax
  801c25:	8a 00                	mov    (%eax),%al
  801c27:	84 c0                	test   %al,%al
  801c29:	74 18                	je     801c43 <strsplit+0x52>
  801c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2e:	8a 00                	mov    (%eax),%al
  801c30:	0f be c0             	movsbl %al,%eax
  801c33:	50                   	push   %eax
  801c34:	ff 75 0c             	pushl  0xc(%ebp)
  801c37:	e8 13 fb ff ff       	call   80174f <strchr>
  801c3c:	83 c4 08             	add    $0x8,%esp
  801c3f:	85 c0                	test   %eax,%eax
  801c41:	75 d3                	jne    801c16 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801c43:	8b 45 08             	mov    0x8(%ebp),%eax
  801c46:	8a 00                	mov    (%eax),%al
  801c48:	84 c0                	test   %al,%al
  801c4a:	74 5a                	je     801ca6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801c4c:	8b 45 14             	mov    0x14(%ebp),%eax
  801c4f:	8b 00                	mov    (%eax),%eax
  801c51:	83 f8 0f             	cmp    $0xf,%eax
  801c54:	75 07                	jne    801c5d <strsplit+0x6c>
		{
			return 0;
  801c56:	b8 00 00 00 00       	mov    $0x0,%eax
  801c5b:	eb 66                	jmp    801cc3 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801c5d:	8b 45 14             	mov    0x14(%ebp),%eax
  801c60:	8b 00                	mov    (%eax),%eax
  801c62:	8d 48 01             	lea    0x1(%eax),%ecx
  801c65:	8b 55 14             	mov    0x14(%ebp),%edx
  801c68:	89 0a                	mov    %ecx,(%edx)
  801c6a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c71:	8b 45 10             	mov    0x10(%ebp),%eax
  801c74:	01 c2                	add    %eax,%edx
  801c76:	8b 45 08             	mov    0x8(%ebp),%eax
  801c79:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c7b:	eb 03                	jmp    801c80 <strsplit+0x8f>
			string++;
  801c7d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c80:	8b 45 08             	mov    0x8(%ebp),%eax
  801c83:	8a 00                	mov    (%eax),%al
  801c85:	84 c0                	test   %al,%al
  801c87:	74 8b                	je     801c14 <strsplit+0x23>
  801c89:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8c:	8a 00                	mov    (%eax),%al
  801c8e:	0f be c0             	movsbl %al,%eax
  801c91:	50                   	push   %eax
  801c92:	ff 75 0c             	pushl  0xc(%ebp)
  801c95:	e8 b5 fa ff ff       	call   80174f <strchr>
  801c9a:	83 c4 08             	add    $0x8,%esp
  801c9d:	85 c0                	test   %eax,%eax
  801c9f:	74 dc                	je     801c7d <strsplit+0x8c>
			string++;
	}
  801ca1:	e9 6e ff ff ff       	jmp    801c14 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801ca6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801ca7:	8b 45 14             	mov    0x14(%ebp),%eax
  801caa:	8b 00                	mov    (%eax),%eax
  801cac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801cb3:	8b 45 10             	mov    0x10(%ebp),%eax
  801cb6:	01 d0                	add    %edx,%eax
  801cb8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801cbe:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801cc3:	c9                   	leave  
  801cc4:	c3                   	ret    

00801cc5 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801cc5:	55                   	push   %ebp
  801cc6:	89 e5                	mov    %esp,%ebp
  801cc8:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801ccb:	a1 04 50 80 00       	mov    0x805004,%eax
  801cd0:	85 c0                	test   %eax,%eax
  801cd2:	74 1f                	je     801cf3 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801cd4:	e8 1d 00 00 00       	call   801cf6 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801cd9:	83 ec 0c             	sub    $0xc,%esp
  801cdc:	68 b0 46 80 00       	push   $0x8046b0
  801ce1:	e8 55 f2 ff ff       	call   800f3b <cprintf>
  801ce6:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801ce9:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801cf0:	00 00 00 
	}
}
  801cf3:	90                   	nop
  801cf4:	c9                   	leave  
  801cf5:	c3                   	ret    

00801cf6 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801cf6:	55                   	push   %ebp
  801cf7:	89 e5                	mov    %esp,%ebp
  801cf9:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801cfc:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801d03:	00 00 00 
  801d06:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801d0d:	00 00 00 
  801d10:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801d17:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  801d1a:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801d21:	00 00 00 
  801d24:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801d2b:	00 00 00 
  801d2e:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801d35:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801d38:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801d3f:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801d42:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801d49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d4c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d51:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d56:	a3 50 50 80 00       	mov    %eax,0x805050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  801d5b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801d62:	a1 20 51 80 00       	mov    0x805120,%eax
  801d67:	c1 e0 04             	shl    $0x4,%eax
  801d6a:	89 c2                	mov    %eax,%edx
  801d6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d6f:	01 d0                	add    %edx,%eax
  801d71:	48                   	dec    %eax
  801d72:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801d75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d78:	ba 00 00 00 00       	mov    $0x0,%edx
  801d7d:	f7 75 f0             	divl   -0x10(%ebp)
  801d80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d83:	29 d0                	sub    %edx,%eax
  801d85:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  801d88:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801d8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d92:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d97:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d9c:	83 ec 04             	sub    $0x4,%esp
  801d9f:	6a 06                	push   $0x6
  801da1:	ff 75 e8             	pushl  -0x18(%ebp)
  801da4:	50                   	push   %eax
  801da5:	e8 b0 05 00 00       	call   80235a <sys_allocate_chunk>
  801daa:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801dad:	a1 20 51 80 00       	mov    0x805120,%eax
  801db2:	83 ec 0c             	sub    $0xc,%esp
  801db5:	50                   	push   %eax
  801db6:	e8 25 0c 00 00       	call   8029e0 <initialize_MemBlocksList>
  801dbb:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  801dbe:	a1 48 51 80 00       	mov    0x805148,%eax
  801dc3:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  801dc6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801dca:	75 14                	jne    801de0 <initialize_dyn_block_system+0xea>
  801dcc:	83 ec 04             	sub    $0x4,%esp
  801dcf:	68 d5 46 80 00       	push   $0x8046d5
  801dd4:	6a 29                	push   $0x29
  801dd6:	68 f3 46 80 00       	push   $0x8046f3
  801ddb:	e8 a7 ee ff ff       	call   800c87 <_panic>
  801de0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801de3:	8b 00                	mov    (%eax),%eax
  801de5:	85 c0                	test   %eax,%eax
  801de7:	74 10                	je     801df9 <initialize_dyn_block_system+0x103>
  801de9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dec:	8b 00                	mov    (%eax),%eax
  801dee:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801df1:	8b 52 04             	mov    0x4(%edx),%edx
  801df4:	89 50 04             	mov    %edx,0x4(%eax)
  801df7:	eb 0b                	jmp    801e04 <initialize_dyn_block_system+0x10e>
  801df9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801dfc:	8b 40 04             	mov    0x4(%eax),%eax
  801dff:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801e04:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e07:	8b 40 04             	mov    0x4(%eax),%eax
  801e0a:	85 c0                	test   %eax,%eax
  801e0c:	74 0f                	je     801e1d <initialize_dyn_block_system+0x127>
  801e0e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e11:	8b 40 04             	mov    0x4(%eax),%eax
  801e14:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e17:	8b 12                	mov    (%edx),%edx
  801e19:	89 10                	mov    %edx,(%eax)
  801e1b:	eb 0a                	jmp    801e27 <initialize_dyn_block_system+0x131>
  801e1d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e20:	8b 00                	mov    (%eax),%eax
  801e22:	a3 48 51 80 00       	mov    %eax,0x805148
  801e27:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e2a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e30:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e33:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e3a:	a1 54 51 80 00       	mov    0x805154,%eax
  801e3f:	48                   	dec    %eax
  801e40:	a3 54 51 80 00       	mov    %eax,0x805154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  801e45:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e48:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  801e4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e52:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  801e59:	83 ec 0c             	sub    $0xc,%esp
  801e5c:	ff 75 e0             	pushl  -0x20(%ebp)
  801e5f:	e8 b9 14 00 00       	call   80331d <insert_sorted_with_merge_freeList>
  801e64:	83 c4 10             	add    $0x10,%esp

}
  801e67:	90                   	nop
  801e68:	c9                   	leave  
  801e69:	c3                   	ret    

00801e6a <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801e6a:	55                   	push   %ebp
  801e6b:	89 e5                	mov    %esp,%ebp
  801e6d:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e70:	e8 50 fe ff ff       	call   801cc5 <InitializeUHeap>
	if (size == 0) return NULL ;
  801e75:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e79:	75 07                	jne    801e82 <malloc+0x18>
  801e7b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e80:	eb 68                	jmp    801eea <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  801e82:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801e89:	8b 55 08             	mov    0x8(%ebp),%edx
  801e8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e8f:	01 d0                	add    %edx,%eax
  801e91:	48                   	dec    %eax
  801e92:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e98:	ba 00 00 00 00       	mov    $0x0,%edx
  801e9d:	f7 75 f4             	divl   -0xc(%ebp)
  801ea0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ea3:	29 d0                	sub    %edx,%eax
  801ea5:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  801ea8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801eaf:	e8 74 08 00 00       	call   802728 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801eb4:	85 c0                	test   %eax,%eax
  801eb6:	74 2d                	je     801ee5 <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  801eb8:	83 ec 0c             	sub    $0xc,%esp
  801ebb:	ff 75 ec             	pushl  -0x14(%ebp)
  801ebe:	e8 52 0e 00 00       	call   802d15 <alloc_block_FF>
  801ec3:	83 c4 10             	add    $0x10,%esp
  801ec6:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  801ec9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801ecd:	74 16                	je     801ee5 <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  801ecf:	83 ec 0c             	sub    $0xc,%esp
  801ed2:	ff 75 e8             	pushl  -0x18(%ebp)
  801ed5:	e8 3b 0c 00 00       	call   802b15 <insert_sorted_allocList>
  801eda:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  801edd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ee0:	8b 40 08             	mov    0x8(%eax),%eax
  801ee3:	eb 05                	jmp    801eea <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  801ee5:	b8 00 00 00 00       	mov    $0x0,%eax

}
  801eea:	c9                   	leave  
  801eeb:	c3                   	ret    

00801eec <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801eec:	55                   	push   %ebp
  801eed:	89 e5                	mov    %esp,%ebp
  801eef:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  801ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef5:	83 ec 08             	sub    $0x8,%esp
  801ef8:	50                   	push   %eax
  801ef9:	68 40 50 80 00       	push   $0x805040
  801efe:	e8 ba 0b 00 00       	call   802abd <find_block>
  801f03:	83 c4 10             	add    $0x10,%esp
  801f06:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  801f09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f0c:	8b 40 0c             	mov    0xc(%eax),%eax
  801f0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  801f12:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f16:	0f 84 9f 00 00 00    	je     801fbb <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  801f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1f:	83 ec 08             	sub    $0x8,%esp
  801f22:	ff 75 f0             	pushl  -0x10(%ebp)
  801f25:	50                   	push   %eax
  801f26:	e8 f7 03 00 00       	call   802322 <sys_free_user_mem>
  801f2b:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  801f2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f32:	75 14                	jne    801f48 <free+0x5c>
  801f34:	83 ec 04             	sub    $0x4,%esp
  801f37:	68 d5 46 80 00       	push   $0x8046d5
  801f3c:	6a 6a                	push   $0x6a
  801f3e:	68 f3 46 80 00       	push   $0x8046f3
  801f43:	e8 3f ed ff ff       	call   800c87 <_panic>
  801f48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4b:	8b 00                	mov    (%eax),%eax
  801f4d:	85 c0                	test   %eax,%eax
  801f4f:	74 10                	je     801f61 <free+0x75>
  801f51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f54:	8b 00                	mov    (%eax),%eax
  801f56:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f59:	8b 52 04             	mov    0x4(%edx),%edx
  801f5c:	89 50 04             	mov    %edx,0x4(%eax)
  801f5f:	eb 0b                	jmp    801f6c <free+0x80>
  801f61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f64:	8b 40 04             	mov    0x4(%eax),%eax
  801f67:	a3 44 50 80 00       	mov    %eax,0x805044
  801f6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6f:	8b 40 04             	mov    0x4(%eax),%eax
  801f72:	85 c0                	test   %eax,%eax
  801f74:	74 0f                	je     801f85 <free+0x99>
  801f76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f79:	8b 40 04             	mov    0x4(%eax),%eax
  801f7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f7f:	8b 12                	mov    (%edx),%edx
  801f81:	89 10                	mov    %edx,(%eax)
  801f83:	eb 0a                	jmp    801f8f <free+0xa3>
  801f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f88:	8b 00                	mov    (%eax),%eax
  801f8a:	a3 40 50 80 00       	mov    %eax,0x805040
  801f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f92:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fa2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801fa7:	48                   	dec    %eax
  801fa8:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(blk);
  801fad:	83 ec 0c             	sub    $0xc,%esp
  801fb0:	ff 75 f4             	pushl  -0xc(%ebp)
  801fb3:	e8 65 13 00 00       	call   80331d <insert_sorted_with_merge_freeList>
  801fb8:	83 c4 10             	add    $0x10,%esp
	}
}
  801fbb:	90                   	nop
  801fbc:	c9                   	leave  
  801fbd:	c3                   	ret    

00801fbe <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801fbe:	55                   	push   %ebp
  801fbf:	89 e5                	mov    %esp,%ebp
  801fc1:	83 ec 28             	sub    $0x28,%esp
  801fc4:	8b 45 10             	mov    0x10(%ebp),%eax
  801fc7:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801fca:	e8 f6 fc ff ff       	call   801cc5 <InitializeUHeap>
	if (size == 0) return NULL ;
  801fcf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801fd3:	75 0a                	jne    801fdf <smalloc+0x21>
  801fd5:	b8 00 00 00 00       	mov    $0x0,%eax
  801fda:	e9 af 00 00 00       	jmp    80208e <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  801fdf:	e8 44 07 00 00       	call   802728 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801fe4:	83 f8 01             	cmp    $0x1,%eax
  801fe7:	0f 85 9c 00 00 00    	jne    802089 <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  801fed:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801ff4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ff7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffa:	01 d0                	add    %edx,%eax
  801ffc:	48                   	dec    %eax
  801ffd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802000:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802003:	ba 00 00 00 00       	mov    $0x0,%edx
  802008:	f7 75 f4             	divl   -0xc(%ebp)
  80200b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80200e:	29 d0                	sub    %edx,%eax
  802010:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  802013:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  80201a:	76 07                	jbe    802023 <smalloc+0x65>
			return NULL;
  80201c:	b8 00 00 00 00       	mov    $0x0,%eax
  802021:	eb 6b                	jmp    80208e <smalloc+0xd0>
		blk =alloc_block_FF(size);
  802023:	83 ec 0c             	sub    $0xc,%esp
  802026:	ff 75 0c             	pushl  0xc(%ebp)
  802029:	e8 e7 0c 00 00       	call   802d15 <alloc_block_FF>
  80202e:	83 c4 10             	add    $0x10,%esp
  802031:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  802034:	83 ec 0c             	sub    $0xc,%esp
  802037:	ff 75 ec             	pushl  -0x14(%ebp)
  80203a:	e8 d6 0a 00 00       	call   802b15 <insert_sorted_allocList>
  80203f:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  802042:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802046:	75 07                	jne    80204f <smalloc+0x91>
		{
			return NULL;
  802048:	b8 00 00 00 00       	mov    $0x0,%eax
  80204d:	eb 3f                	jmp    80208e <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  80204f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802052:	8b 40 08             	mov    0x8(%eax),%eax
  802055:	89 c2                	mov    %eax,%edx
  802057:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80205b:	52                   	push   %edx
  80205c:	50                   	push   %eax
  80205d:	ff 75 0c             	pushl  0xc(%ebp)
  802060:	ff 75 08             	pushl  0x8(%ebp)
  802063:	e8 45 04 00 00       	call   8024ad <sys_createSharedObject>
  802068:	83 c4 10             	add    $0x10,%esp
  80206b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  80206e:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  802072:	74 06                	je     80207a <smalloc+0xbc>
  802074:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  802078:	75 07                	jne    802081 <smalloc+0xc3>
		{
			return NULL;
  80207a:	b8 00 00 00 00       	mov    $0x0,%eax
  80207f:	eb 0d                	jmp    80208e <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  802081:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802084:	8b 40 08             	mov    0x8(%eax),%eax
  802087:	eb 05                	jmp    80208e <smalloc+0xd0>
		}
	}
	else
		return NULL;
  802089:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80208e:	c9                   	leave  
  80208f:	c3                   	ret    

00802090 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802090:	55                   	push   %ebp
  802091:	89 e5                	mov    %esp,%ebp
  802093:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802096:	e8 2a fc ff ff       	call   801cc5 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80209b:	83 ec 08             	sub    $0x8,%esp
  80209e:	ff 75 0c             	pushl  0xc(%ebp)
  8020a1:	ff 75 08             	pushl  0x8(%ebp)
  8020a4:	e8 2e 04 00 00       	call   8024d7 <sys_getSizeOfSharedObject>
  8020a9:	83 c4 10             	add    $0x10,%esp
  8020ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  8020af:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8020b3:	75 0a                	jne    8020bf <sget+0x2f>
	{
		return NULL;
  8020b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ba:	e9 94 00 00 00       	jmp    802153 <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8020bf:	e8 64 06 00 00       	call   802728 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8020c4:	85 c0                	test   %eax,%eax
  8020c6:	0f 84 82 00 00 00    	je     80214e <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  8020cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  8020d3:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8020da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020e0:	01 d0                	add    %edx,%eax
  8020e2:	48                   	dec    %eax
  8020e3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8020e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8020ee:	f7 75 ec             	divl   -0x14(%ebp)
  8020f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020f4:	29 d0                	sub    %edx,%eax
  8020f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  8020f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fc:	83 ec 0c             	sub    $0xc,%esp
  8020ff:	50                   	push   %eax
  802100:	e8 10 0c 00 00       	call   802d15 <alloc_block_FF>
  802105:	83 c4 10             	add    $0x10,%esp
  802108:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  80210b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80210f:	75 07                	jne    802118 <sget+0x88>
		{
			return NULL;
  802111:	b8 00 00 00 00       	mov    $0x0,%eax
  802116:	eb 3b                	jmp    802153 <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  802118:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80211b:	8b 40 08             	mov    0x8(%eax),%eax
  80211e:	83 ec 04             	sub    $0x4,%esp
  802121:	50                   	push   %eax
  802122:	ff 75 0c             	pushl  0xc(%ebp)
  802125:	ff 75 08             	pushl  0x8(%ebp)
  802128:	e8 c7 03 00 00       	call   8024f4 <sys_getSharedObject>
  80212d:	83 c4 10             	add    $0x10,%esp
  802130:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  802133:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  802137:	74 06                	je     80213f <sget+0xaf>
  802139:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  80213d:	75 07                	jne    802146 <sget+0xb6>
		{
			return NULL;
  80213f:	b8 00 00 00 00       	mov    $0x0,%eax
  802144:	eb 0d                	jmp    802153 <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  802146:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802149:	8b 40 08             	mov    0x8(%eax),%eax
  80214c:	eb 05                	jmp    802153 <sget+0xc3>
		}
	}
	else
			return NULL;
  80214e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802153:	c9                   	leave  
  802154:	c3                   	ret    

00802155 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802155:	55                   	push   %ebp
  802156:	89 e5                	mov    %esp,%ebp
  802158:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80215b:	e8 65 fb ff ff       	call   801cc5 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802160:	83 ec 04             	sub    $0x4,%esp
  802163:	68 00 47 80 00       	push   $0x804700
  802168:	68 e1 00 00 00       	push   $0xe1
  80216d:	68 f3 46 80 00       	push   $0x8046f3
  802172:	e8 10 eb ff ff       	call   800c87 <_panic>

00802177 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802177:	55                   	push   %ebp
  802178:	89 e5                	mov    %esp,%ebp
  80217a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80217d:	83 ec 04             	sub    $0x4,%esp
  802180:	68 28 47 80 00       	push   $0x804728
  802185:	68 f5 00 00 00       	push   $0xf5
  80218a:	68 f3 46 80 00       	push   $0x8046f3
  80218f:	e8 f3 ea ff ff       	call   800c87 <_panic>

00802194 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802194:	55                   	push   %ebp
  802195:	89 e5                	mov    %esp,%ebp
  802197:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80219a:	83 ec 04             	sub    $0x4,%esp
  80219d:	68 4c 47 80 00       	push   $0x80474c
  8021a2:	68 00 01 00 00       	push   $0x100
  8021a7:	68 f3 46 80 00       	push   $0x8046f3
  8021ac:	e8 d6 ea ff ff       	call   800c87 <_panic>

008021b1 <shrink>:

}
void shrink(uint32 newSize)
{
  8021b1:	55                   	push   %ebp
  8021b2:	89 e5                	mov    %esp,%ebp
  8021b4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8021b7:	83 ec 04             	sub    $0x4,%esp
  8021ba:	68 4c 47 80 00       	push   $0x80474c
  8021bf:	68 05 01 00 00       	push   $0x105
  8021c4:	68 f3 46 80 00       	push   $0x8046f3
  8021c9:	e8 b9 ea ff ff       	call   800c87 <_panic>

008021ce <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8021ce:	55                   	push   %ebp
  8021cf:	89 e5                	mov    %esp,%ebp
  8021d1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8021d4:	83 ec 04             	sub    $0x4,%esp
  8021d7:	68 4c 47 80 00       	push   $0x80474c
  8021dc:	68 0a 01 00 00       	push   $0x10a
  8021e1:	68 f3 46 80 00       	push   $0x8046f3
  8021e6:	e8 9c ea ff ff       	call   800c87 <_panic>

008021eb <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8021eb:	55                   	push   %ebp
  8021ec:	89 e5                	mov    %esp,%ebp
  8021ee:	57                   	push   %edi
  8021ef:	56                   	push   %esi
  8021f0:	53                   	push   %ebx
  8021f1:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8021f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021fa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021fd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802200:	8b 7d 18             	mov    0x18(%ebp),%edi
  802203:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802206:	cd 30                	int    $0x30
  802208:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80220b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80220e:	83 c4 10             	add    $0x10,%esp
  802211:	5b                   	pop    %ebx
  802212:	5e                   	pop    %esi
  802213:	5f                   	pop    %edi
  802214:	5d                   	pop    %ebp
  802215:	c3                   	ret    

00802216 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802216:	55                   	push   %ebp
  802217:	89 e5                	mov    %esp,%ebp
  802219:	83 ec 04             	sub    $0x4,%esp
  80221c:	8b 45 10             	mov    0x10(%ebp),%eax
  80221f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802222:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802226:	8b 45 08             	mov    0x8(%ebp),%eax
  802229:	6a 00                	push   $0x0
  80222b:	6a 00                	push   $0x0
  80222d:	52                   	push   %edx
  80222e:	ff 75 0c             	pushl  0xc(%ebp)
  802231:	50                   	push   %eax
  802232:	6a 00                	push   $0x0
  802234:	e8 b2 ff ff ff       	call   8021eb <syscall>
  802239:	83 c4 18             	add    $0x18,%esp
}
  80223c:	90                   	nop
  80223d:	c9                   	leave  
  80223e:	c3                   	ret    

0080223f <sys_cgetc>:

int
sys_cgetc(void)
{
  80223f:	55                   	push   %ebp
  802240:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802242:	6a 00                	push   $0x0
  802244:	6a 00                	push   $0x0
  802246:	6a 00                	push   $0x0
  802248:	6a 00                	push   $0x0
  80224a:	6a 00                	push   $0x0
  80224c:	6a 01                	push   $0x1
  80224e:	e8 98 ff ff ff       	call   8021eb <syscall>
  802253:	83 c4 18             	add    $0x18,%esp
}
  802256:	c9                   	leave  
  802257:	c3                   	ret    

00802258 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802258:	55                   	push   %ebp
  802259:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80225b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80225e:	8b 45 08             	mov    0x8(%ebp),%eax
  802261:	6a 00                	push   $0x0
  802263:	6a 00                	push   $0x0
  802265:	6a 00                	push   $0x0
  802267:	52                   	push   %edx
  802268:	50                   	push   %eax
  802269:	6a 05                	push   $0x5
  80226b:	e8 7b ff ff ff       	call   8021eb <syscall>
  802270:	83 c4 18             	add    $0x18,%esp
}
  802273:	c9                   	leave  
  802274:	c3                   	ret    

00802275 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802275:	55                   	push   %ebp
  802276:	89 e5                	mov    %esp,%ebp
  802278:	56                   	push   %esi
  802279:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80227a:	8b 75 18             	mov    0x18(%ebp),%esi
  80227d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802280:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802283:	8b 55 0c             	mov    0xc(%ebp),%edx
  802286:	8b 45 08             	mov    0x8(%ebp),%eax
  802289:	56                   	push   %esi
  80228a:	53                   	push   %ebx
  80228b:	51                   	push   %ecx
  80228c:	52                   	push   %edx
  80228d:	50                   	push   %eax
  80228e:	6a 06                	push   $0x6
  802290:	e8 56 ff ff ff       	call   8021eb <syscall>
  802295:	83 c4 18             	add    $0x18,%esp
}
  802298:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80229b:	5b                   	pop    %ebx
  80229c:	5e                   	pop    %esi
  80229d:	5d                   	pop    %ebp
  80229e:	c3                   	ret    

0080229f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80229f:	55                   	push   %ebp
  8022a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8022a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a8:	6a 00                	push   $0x0
  8022aa:	6a 00                	push   $0x0
  8022ac:	6a 00                	push   $0x0
  8022ae:	52                   	push   %edx
  8022af:	50                   	push   %eax
  8022b0:	6a 07                	push   $0x7
  8022b2:	e8 34 ff ff ff       	call   8021eb <syscall>
  8022b7:	83 c4 18             	add    $0x18,%esp
}
  8022ba:	c9                   	leave  
  8022bb:	c3                   	ret    

008022bc <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8022bc:	55                   	push   %ebp
  8022bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8022bf:	6a 00                	push   $0x0
  8022c1:	6a 00                	push   $0x0
  8022c3:	6a 00                	push   $0x0
  8022c5:	ff 75 0c             	pushl  0xc(%ebp)
  8022c8:	ff 75 08             	pushl  0x8(%ebp)
  8022cb:	6a 08                	push   $0x8
  8022cd:	e8 19 ff ff ff       	call   8021eb <syscall>
  8022d2:	83 c4 18             	add    $0x18,%esp
}
  8022d5:	c9                   	leave  
  8022d6:	c3                   	ret    

008022d7 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8022d7:	55                   	push   %ebp
  8022d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8022da:	6a 00                	push   $0x0
  8022dc:	6a 00                	push   $0x0
  8022de:	6a 00                	push   $0x0
  8022e0:	6a 00                	push   $0x0
  8022e2:	6a 00                	push   $0x0
  8022e4:	6a 09                	push   $0x9
  8022e6:	e8 00 ff ff ff       	call   8021eb <syscall>
  8022eb:	83 c4 18             	add    $0x18,%esp
}
  8022ee:	c9                   	leave  
  8022ef:	c3                   	ret    

008022f0 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8022f0:	55                   	push   %ebp
  8022f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8022f3:	6a 00                	push   $0x0
  8022f5:	6a 00                	push   $0x0
  8022f7:	6a 00                	push   $0x0
  8022f9:	6a 00                	push   $0x0
  8022fb:	6a 00                	push   $0x0
  8022fd:	6a 0a                	push   $0xa
  8022ff:	e8 e7 fe ff ff       	call   8021eb <syscall>
  802304:	83 c4 18             	add    $0x18,%esp
}
  802307:	c9                   	leave  
  802308:	c3                   	ret    

00802309 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802309:	55                   	push   %ebp
  80230a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80230c:	6a 00                	push   $0x0
  80230e:	6a 00                	push   $0x0
  802310:	6a 00                	push   $0x0
  802312:	6a 00                	push   $0x0
  802314:	6a 00                	push   $0x0
  802316:	6a 0b                	push   $0xb
  802318:	e8 ce fe ff ff       	call   8021eb <syscall>
  80231d:	83 c4 18             	add    $0x18,%esp
}
  802320:	c9                   	leave  
  802321:	c3                   	ret    

00802322 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802322:	55                   	push   %ebp
  802323:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802325:	6a 00                	push   $0x0
  802327:	6a 00                	push   $0x0
  802329:	6a 00                	push   $0x0
  80232b:	ff 75 0c             	pushl  0xc(%ebp)
  80232e:	ff 75 08             	pushl  0x8(%ebp)
  802331:	6a 0f                	push   $0xf
  802333:	e8 b3 fe ff ff       	call   8021eb <syscall>
  802338:	83 c4 18             	add    $0x18,%esp
	return;
  80233b:	90                   	nop
}
  80233c:	c9                   	leave  
  80233d:	c3                   	ret    

0080233e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80233e:	55                   	push   %ebp
  80233f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802341:	6a 00                	push   $0x0
  802343:	6a 00                	push   $0x0
  802345:	6a 00                	push   $0x0
  802347:	ff 75 0c             	pushl  0xc(%ebp)
  80234a:	ff 75 08             	pushl  0x8(%ebp)
  80234d:	6a 10                	push   $0x10
  80234f:	e8 97 fe ff ff       	call   8021eb <syscall>
  802354:	83 c4 18             	add    $0x18,%esp
	return ;
  802357:	90                   	nop
}
  802358:	c9                   	leave  
  802359:	c3                   	ret    

0080235a <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80235a:	55                   	push   %ebp
  80235b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80235d:	6a 00                	push   $0x0
  80235f:	6a 00                	push   $0x0
  802361:	ff 75 10             	pushl  0x10(%ebp)
  802364:	ff 75 0c             	pushl  0xc(%ebp)
  802367:	ff 75 08             	pushl  0x8(%ebp)
  80236a:	6a 11                	push   $0x11
  80236c:	e8 7a fe ff ff       	call   8021eb <syscall>
  802371:	83 c4 18             	add    $0x18,%esp
	return ;
  802374:	90                   	nop
}
  802375:	c9                   	leave  
  802376:	c3                   	ret    

00802377 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802377:	55                   	push   %ebp
  802378:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80237a:	6a 00                	push   $0x0
  80237c:	6a 00                	push   $0x0
  80237e:	6a 00                	push   $0x0
  802380:	6a 00                	push   $0x0
  802382:	6a 00                	push   $0x0
  802384:	6a 0c                	push   $0xc
  802386:	e8 60 fe ff ff       	call   8021eb <syscall>
  80238b:	83 c4 18             	add    $0x18,%esp
}
  80238e:	c9                   	leave  
  80238f:	c3                   	ret    

00802390 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802390:	55                   	push   %ebp
  802391:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802393:	6a 00                	push   $0x0
  802395:	6a 00                	push   $0x0
  802397:	6a 00                	push   $0x0
  802399:	6a 00                	push   $0x0
  80239b:	ff 75 08             	pushl  0x8(%ebp)
  80239e:	6a 0d                	push   $0xd
  8023a0:	e8 46 fe ff ff       	call   8021eb <syscall>
  8023a5:	83 c4 18             	add    $0x18,%esp
}
  8023a8:	c9                   	leave  
  8023a9:	c3                   	ret    

008023aa <sys_scarce_memory>:

void sys_scarce_memory()
{
  8023aa:	55                   	push   %ebp
  8023ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8023ad:	6a 00                	push   $0x0
  8023af:	6a 00                	push   $0x0
  8023b1:	6a 00                	push   $0x0
  8023b3:	6a 00                	push   $0x0
  8023b5:	6a 00                	push   $0x0
  8023b7:	6a 0e                	push   $0xe
  8023b9:	e8 2d fe ff ff       	call   8021eb <syscall>
  8023be:	83 c4 18             	add    $0x18,%esp
}
  8023c1:	90                   	nop
  8023c2:	c9                   	leave  
  8023c3:	c3                   	ret    

008023c4 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8023c4:	55                   	push   %ebp
  8023c5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8023c7:	6a 00                	push   $0x0
  8023c9:	6a 00                	push   $0x0
  8023cb:	6a 00                	push   $0x0
  8023cd:	6a 00                	push   $0x0
  8023cf:	6a 00                	push   $0x0
  8023d1:	6a 13                	push   $0x13
  8023d3:	e8 13 fe ff ff       	call   8021eb <syscall>
  8023d8:	83 c4 18             	add    $0x18,%esp
}
  8023db:	90                   	nop
  8023dc:	c9                   	leave  
  8023dd:	c3                   	ret    

008023de <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8023de:	55                   	push   %ebp
  8023df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8023e1:	6a 00                	push   $0x0
  8023e3:	6a 00                	push   $0x0
  8023e5:	6a 00                	push   $0x0
  8023e7:	6a 00                	push   $0x0
  8023e9:	6a 00                	push   $0x0
  8023eb:	6a 14                	push   $0x14
  8023ed:	e8 f9 fd ff ff       	call   8021eb <syscall>
  8023f2:	83 c4 18             	add    $0x18,%esp
}
  8023f5:	90                   	nop
  8023f6:	c9                   	leave  
  8023f7:	c3                   	ret    

008023f8 <sys_cputc>:


void
sys_cputc(const char c)
{
  8023f8:	55                   	push   %ebp
  8023f9:	89 e5                	mov    %esp,%ebp
  8023fb:	83 ec 04             	sub    $0x4,%esp
  8023fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802401:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802404:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802408:	6a 00                	push   $0x0
  80240a:	6a 00                	push   $0x0
  80240c:	6a 00                	push   $0x0
  80240e:	6a 00                	push   $0x0
  802410:	50                   	push   %eax
  802411:	6a 15                	push   $0x15
  802413:	e8 d3 fd ff ff       	call   8021eb <syscall>
  802418:	83 c4 18             	add    $0x18,%esp
}
  80241b:	90                   	nop
  80241c:	c9                   	leave  
  80241d:	c3                   	ret    

0080241e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80241e:	55                   	push   %ebp
  80241f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802421:	6a 00                	push   $0x0
  802423:	6a 00                	push   $0x0
  802425:	6a 00                	push   $0x0
  802427:	6a 00                	push   $0x0
  802429:	6a 00                	push   $0x0
  80242b:	6a 16                	push   $0x16
  80242d:	e8 b9 fd ff ff       	call   8021eb <syscall>
  802432:	83 c4 18             	add    $0x18,%esp
}
  802435:	90                   	nop
  802436:	c9                   	leave  
  802437:	c3                   	ret    

00802438 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802438:	55                   	push   %ebp
  802439:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80243b:	8b 45 08             	mov    0x8(%ebp),%eax
  80243e:	6a 00                	push   $0x0
  802440:	6a 00                	push   $0x0
  802442:	6a 00                	push   $0x0
  802444:	ff 75 0c             	pushl  0xc(%ebp)
  802447:	50                   	push   %eax
  802448:	6a 17                	push   $0x17
  80244a:	e8 9c fd ff ff       	call   8021eb <syscall>
  80244f:	83 c4 18             	add    $0x18,%esp
}
  802452:	c9                   	leave  
  802453:	c3                   	ret    

00802454 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802454:	55                   	push   %ebp
  802455:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802457:	8b 55 0c             	mov    0xc(%ebp),%edx
  80245a:	8b 45 08             	mov    0x8(%ebp),%eax
  80245d:	6a 00                	push   $0x0
  80245f:	6a 00                	push   $0x0
  802461:	6a 00                	push   $0x0
  802463:	52                   	push   %edx
  802464:	50                   	push   %eax
  802465:	6a 1a                	push   $0x1a
  802467:	e8 7f fd ff ff       	call   8021eb <syscall>
  80246c:	83 c4 18             	add    $0x18,%esp
}
  80246f:	c9                   	leave  
  802470:	c3                   	ret    

00802471 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802471:	55                   	push   %ebp
  802472:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802474:	8b 55 0c             	mov    0xc(%ebp),%edx
  802477:	8b 45 08             	mov    0x8(%ebp),%eax
  80247a:	6a 00                	push   $0x0
  80247c:	6a 00                	push   $0x0
  80247e:	6a 00                	push   $0x0
  802480:	52                   	push   %edx
  802481:	50                   	push   %eax
  802482:	6a 18                	push   $0x18
  802484:	e8 62 fd ff ff       	call   8021eb <syscall>
  802489:	83 c4 18             	add    $0x18,%esp
}
  80248c:	90                   	nop
  80248d:	c9                   	leave  
  80248e:	c3                   	ret    

0080248f <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80248f:	55                   	push   %ebp
  802490:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802492:	8b 55 0c             	mov    0xc(%ebp),%edx
  802495:	8b 45 08             	mov    0x8(%ebp),%eax
  802498:	6a 00                	push   $0x0
  80249a:	6a 00                	push   $0x0
  80249c:	6a 00                	push   $0x0
  80249e:	52                   	push   %edx
  80249f:	50                   	push   %eax
  8024a0:	6a 19                	push   $0x19
  8024a2:	e8 44 fd ff ff       	call   8021eb <syscall>
  8024a7:	83 c4 18             	add    $0x18,%esp
}
  8024aa:	90                   	nop
  8024ab:	c9                   	leave  
  8024ac:	c3                   	ret    

008024ad <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8024ad:	55                   	push   %ebp
  8024ae:	89 e5                	mov    %esp,%ebp
  8024b0:	83 ec 04             	sub    $0x4,%esp
  8024b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8024b6:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8024b9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8024bc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8024c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c3:	6a 00                	push   $0x0
  8024c5:	51                   	push   %ecx
  8024c6:	52                   	push   %edx
  8024c7:	ff 75 0c             	pushl  0xc(%ebp)
  8024ca:	50                   	push   %eax
  8024cb:	6a 1b                	push   $0x1b
  8024cd:	e8 19 fd ff ff       	call   8021eb <syscall>
  8024d2:	83 c4 18             	add    $0x18,%esp
}
  8024d5:	c9                   	leave  
  8024d6:	c3                   	ret    

008024d7 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8024d7:	55                   	push   %ebp
  8024d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8024da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e0:	6a 00                	push   $0x0
  8024e2:	6a 00                	push   $0x0
  8024e4:	6a 00                	push   $0x0
  8024e6:	52                   	push   %edx
  8024e7:	50                   	push   %eax
  8024e8:	6a 1c                	push   $0x1c
  8024ea:	e8 fc fc ff ff       	call   8021eb <syscall>
  8024ef:	83 c4 18             	add    $0x18,%esp
}
  8024f2:	c9                   	leave  
  8024f3:	c3                   	ret    

008024f4 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8024f4:	55                   	push   %ebp
  8024f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8024f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802500:	6a 00                	push   $0x0
  802502:	6a 00                	push   $0x0
  802504:	51                   	push   %ecx
  802505:	52                   	push   %edx
  802506:	50                   	push   %eax
  802507:	6a 1d                	push   $0x1d
  802509:	e8 dd fc ff ff       	call   8021eb <syscall>
  80250e:	83 c4 18             	add    $0x18,%esp
}
  802511:	c9                   	leave  
  802512:	c3                   	ret    

00802513 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802513:	55                   	push   %ebp
  802514:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802516:	8b 55 0c             	mov    0xc(%ebp),%edx
  802519:	8b 45 08             	mov    0x8(%ebp),%eax
  80251c:	6a 00                	push   $0x0
  80251e:	6a 00                	push   $0x0
  802520:	6a 00                	push   $0x0
  802522:	52                   	push   %edx
  802523:	50                   	push   %eax
  802524:	6a 1e                	push   $0x1e
  802526:	e8 c0 fc ff ff       	call   8021eb <syscall>
  80252b:	83 c4 18             	add    $0x18,%esp
}
  80252e:	c9                   	leave  
  80252f:	c3                   	ret    

00802530 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802530:	55                   	push   %ebp
  802531:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802533:	6a 00                	push   $0x0
  802535:	6a 00                	push   $0x0
  802537:	6a 00                	push   $0x0
  802539:	6a 00                	push   $0x0
  80253b:	6a 00                	push   $0x0
  80253d:	6a 1f                	push   $0x1f
  80253f:	e8 a7 fc ff ff       	call   8021eb <syscall>
  802544:	83 c4 18             	add    $0x18,%esp
}
  802547:	c9                   	leave  
  802548:	c3                   	ret    

00802549 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802549:	55                   	push   %ebp
  80254a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80254c:	8b 45 08             	mov    0x8(%ebp),%eax
  80254f:	6a 00                	push   $0x0
  802551:	ff 75 14             	pushl  0x14(%ebp)
  802554:	ff 75 10             	pushl  0x10(%ebp)
  802557:	ff 75 0c             	pushl  0xc(%ebp)
  80255a:	50                   	push   %eax
  80255b:	6a 20                	push   $0x20
  80255d:	e8 89 fc ff ff       	call   8021eb <syscall>
  802562:	83 c4 18             	add    $0x18,%esp
}
  802565:	c9                   	leave  
  802566:	c3                   	ret    

00802567 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802567:	55                   	push   %ebp
  802568:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80256a:	8b 45 08             	mov    0x8(%ebp),%eax
  80256d:	6a 00                	push   $0x0
  80256f:	6a 00                	push   $0x0
  802571:	6a 00                	push   $0x0
  802573:	6a 00                	push   $0x0
  802575:	50                   	push   %eax
  802576:	6a 21                	push   $0x21
  802578:	e8 6e fc ff ff       	call   8021eb <syscall>
  80257d:	83 c4 18             	add    $0x18,%esp
}
  802580:	90                   	nop
  802581:	c9                   	leave  
  802582:	c3                   	ret    

00802583 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802583:	55                   	push   %ebp
  802584:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802586:	8b 45 08             	mov    0x8(%ebp),%eax
  802589:	6a 00                	push   $0x0
  80258b:	6a 00                	push   $0x0
  80258d:	6a 00                	push   $0x0
  80258f:	6a 00                	push   $0x0
  802591:	50                   	push   %eax
  802592:	6a 22                	push   $0x22
  802594:	e8 52 fc ff ff       	call   8021eb <syscall>
  802599:	83 c4 18             	add    $0x18,%esp
}
  80259c:	c9                   	leave  
  80259d:	c3                   	ret    

0080259e <sys_getenvid>:

int32 sys_getenvid(void)
{
  80259e:	55                   	push   %ebp
  80259f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8025a1:	6a 00                	push   $0x0
  8025a3:	6a 00                	push   $0x0
  8025a5:	6a 00                	push   $0x0
  8025a7:	6a 00                	push   $0x0
  8025a9:	6a 00                	push   $0x0
  8025ab:	6a 02                	push   $0x2
  8025ad:	e8 39 fc ff ff       	call   8021eb <syscall>
  8025b2:	83 c4 18             	add    $0x18,%esp
}
  8025b5:	c9                   	leave  
  8025b6:	c3                   	ret    

008025b7 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8025b7:	55                   	push   %ebp
  8025b8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8025ba:	6a 00                	push   $0x0
  8025bc:	6a 00                	push   $0x0
  8025be:	6a 00                	push   $0x0
  8025c0:	6a 00                	push   $0x0
  8025c2:	6a 00                	push   $0x0
  8025c4:	6a 03                	push   $0x3
  8025c6:	e8 20 fc ff ff       	call   8021eb <syscall>
  8025cb:	83 c4 18             	add    $0x18,%esp
}
  8025ce:	c9                   	leave  
  8025cf:	c3                   	ret    

008025d0 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8025d0:	55                   	push   %ebp
  8025d1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8025d3:	6a 00                	push   $0x0
  8025d5:	6a 00                	push   $0x0
  8025d7:	6a 00                	push   $0x0
  8025d9:	6a 00                	push   $0x0
  8025db:	6a 00                	push   $0x0
  8025dd:	6a 04                	push   $0x4
  8025df:	e8 07 fc ff ff       	call   8021eb <syscall>
  8025e4:	83 c4 18             	add    $0x18,%esp
}
  8025e7:	c9                   	leave  
  8025e8:	c3                   	ret    

008025e9 <sys_exit_env>:


void sys_exit_env(void)
{
  8025e9:	55                   	push   %ebp
  8025ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8025ec:	6a 00                	push   $0x0
  8025ee:	6a 00                	push   $0x0
  8025f0:	6a 00                	push   $0x0
  8025f2:	6a 00                	push   $0x0
  8025f4:	6a 00                	push   $0x0
  8025f6:	6a 23                	push   $0x23
  8025f8:	e8 ee fb ff ff       	call   8021eb <syscall>
  8025fd:	83 c4 18             	add    $0x18,%esp
}
  802600:	90                   	nop
  802601:	c9                   	leave  
  802602:	c3                   	ret    

00802603 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802603:	55                   	push   %ebp
  802604:	89 e5                	mov    %esp,%ebp
  802606:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802609:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80260c:	8d 50 04             	lea    0x4(%eax),%edx
  80260f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802612:	6a 00                	push   $0x0
  802614:	6a 00                	push   $0x0
  802616:	6a 00                	push   $0x0
  802618:	52                   	push   %edx
  802619:	50                   	push   %eax
  80261a:	6a 24                	push   $0x24
  80261c:	e8 ca fb ff ff       	call   8021eb <syscall>
  802621:	83 c4 18             	add    $0x18,%esp
	return result;
  802624:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802627:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80262a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80262d:	89 01                	mov    %eax,(%ecx)
  80262f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802632:	8b 45 08             	mov    0x8(%ebp),%eax
  802635:	c9                   	leave  
  802636:	c2 04 00             	ret    $0x4

00802639 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802639:	55                   	push   %ebp
  80263a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80263c:	6a 00                	push   $0x0
  80263e:	6a 00                	push   $0x0
  802640:	ff 75 10             	pushl  0x10(%ebp)
  802643:	ff 75 0c             	pushl  0xc(%ebp)
  802646:	ff 75 08             	pushl  0x8(%ebp)
  802649:	6a 12                	push   $0x12
  80264b:	e8 9b fb ff ff       	call   8021eb <syscall>
  802650:	83 c4 18             	add    $0x18,%esp
	return ;
  802653:	90                   	nop
}
  802654:	c9                   	leave  
  802655:	c3                   	ret    

00802656 <sys_rcr2>:
uint32 sys_rcr2()
{
  802656:	55                   	push   %ebp
  802657:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802659:	6a 00                	push   $0x0
  80265b:	6a 00                	push   $0x0
  80265d:	6a 00                	push   $0x0
  80265f:	6a 00                	push   $0x0
  802661:	6a 00                	push   $0x0
  802663:	6a 25                	push   $0x25
  802665:	e8 81 fb ff ff       	call   8021eb <syscall>
  80266a:	83 c4 18             	add    $0x18,%esp
}
  80266d:	c9                   	leave  
  80266e:	c3                   	ret    

0080266f <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80266f:	55                   	push   %ebp
  802670:	89 e5                	mov    %esp,%ebp
  802672:	83 ec 04             	sub    $0x4,%esp
  802675:	8b 45 08             	mov    0x8(%ebp),%eax
  802678:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80267b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80267f:	6a 00                	push   $0x0
  802681:	6a 00                	push   $0x0
  802683:	6a 00                	push   $0x0
  802685:	6a 00                	push   $0x0
  802687:	50                   	push   %eax
  802688:	6a 26                	push   $0x26
  80268a:	e8 5c fb ff ff       	call   8021eb <syscall>
  80268f:	83 c4 18             	add    $0x18,%esp
	return ;
  802692:	90                   	nop
}
  802693:	c9                   	leave  
  802694:	c3                   	ret    

00802695 <rsttst>:
void rsttst()
{
  802695:	55                   	push   %ebp
  802696:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802698:	6a 00                	push   $0x0
  80269a:	6a 00                	push   $0x0
  80269c:	6a 00                	push   $0x0
  80269e:	6a 00                	push   $0x0
  8026a0:	6a 00                	push   $0x0
  8026a2:	6a 28                	push   $0x28
  8026a4:	e8 42 fb ff ff       	call   8021eb <syscall>
  8026a9:	83 c4 18             	add    $0x18,%esp
	return ;
  8026ac:	90                   	nop
}
  8026ad:	c9                   	leave  
  8026ae:	c3                   	ret    

008026af <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8026af:	55                   	push   %ebp
  8026b0:	89 e5                	mov    %esp,%ebp
  8026b2:	83 ec 04             	sub    $0x4,%esp
  8026b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8026b8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8026bb:	8b 55 18             	mov    0x18(%ebp),%edx
  8026be:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8026c2:	52                   	push   %edx
  8026c3:	50                   	push   %eax
  8026c4:	ff 75 10             	pushl  0x10(%ebp)
  8026c7:	ff 75 0c             	pushl  0xc(%ebp)
  8026ca:	ff 75 08             	pushl  0x8(%ebp)
  8026cd:	6a 27                	push   $0x27
  8026cf:	e8 17 fb ff ff       	call   8021eb <syscall>
  8026d4:	83 c4 18             	add    $0x18,%esp
	return ;
  8026d7:	90                   	nop
}
  8026d8:	c9                   	leave  
  8026d9:	c3                   	ret    

008026da <chktst>:
void chktst(uint32 n)
{
  8026da:	55                   	push   %ebp
  8026db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8026dd:	6a 00                	push   $0x0
  8026df:	6a 00                	push   $0x0
  8026e1:	6a 00                	push   $0x0
  8026e3:	6a 00                	push   $0x0
  8026e5:	ff 75 08             	pushl  0x8(%ebp)
  8026e8:	6a 29                	push   $0x29
  8026ea:	e8 fc fa ff ff       	call   8021eb <syscall>
  8026ef:	83 c4 18             	add    $0x18,%esp
	return ;
  8026f2:	90                   	nop
}
  8026f3:	c9                   	leave  
  8026f4:	c3                   	ret    

008026f5 <inctst>:

void inctst()
{
  8026f5:	55                   	push   %ebp
  8026f6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8026f8:	6a 00                	push   $0x0
  8026fa:	6a 00                	push   $0x0
  8026fc:	6a 00                	push   $0x0
  8026fe:	6a 00                	push   $0x0
  802700:	6a 00                	push   $0x0
  802702:	6a 2a                	push   $0x2a
  802704:	e8 e2 fa ff ff       	call   8021eb <syscall>
  802709:	83 c4 18             	add    $0x18,%esp
	return ;
  80270c:	90                   	nop
}
  80270d:	c9                   	leave  
  80270e:	c3                   	ret    

0080270f <gettst>:
uint32 gettst()
{
  80270f:	55                   	push   %ebp
  802710:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802712:	6a 00                	push   $0x0
  802714:	6a 00                	push   $0x0
  802716:	6a 00                	push   $0x0
  802718:	6a 00                	push   $0x0
  80271a:	6a 00                	push   $0x0
  80271c:	6a 2b                	push   $0x2b
  80271e:	e8 c8 fa ff ff       	call   8021eb <syscall>
  802723:	83 c4 18             	add    $0x18,%esp
}
  802726:	c9                   	leave  
  802727:	c3                   	ret    

00802728 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802728:	55                   	push   %ebp
  802729:	89 e5                	mov    %esp,%ebp
  80272b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80272e:	6a 00                	push   $0x0
  802730:	6a 00                	push   $0x0
  802732:	6a 00                	push   $0x0
  802734:	6a 00                	push   $0x0
  802736:	6a 00                	push   $0x0
  802738:	6a 2c                	push   $0x2c
  80273a:	e8 ac fa ff ff       	call   8021eb <syscall>
  80273f:	83 c4 18             	add    $0x18,%esp
  802742:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802745:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802749:	75 07                	jne    802752 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80274b:	b8 01 00 00 00       	mov    $0x1,%eax
  802750:	eb 05                	jmp    802757 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802752:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802757:	c9                   	leave  
  802758:	c3                   	ret    

00802759 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802759:	55                   	push   %ebp
  80275a:	89 e5                	mov    %esp,%ebp
  80275c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80275f:	6a 00                	push   $0x0
  802761:	6a 00                	push   $0x0
  802763:	6a 00                	push   $0x0
  802765:	6a 00                	push   $0x0
  802767:	6a 00                	push   $0x0
  802769:	6a 2c                	push   $0x2c
  80276b:	e8 7b fa ff ff       	call   8021eb <syscall>
  802770:	83 c4 18             	add    $0x18,%esp
  802773:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802776:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80277a:	75 07                	jne    802783 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80277c:	b8 01 00 00 00       	mov    $0x1,%eax
  802781:	eb 05                	jmp    802788 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802783:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802788:	c9                   	leave  
  802789:	c3                   	ret    

0080278a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80278a:	55                   	push   %ebp
  80278b:	89 e5                	mov    %esp,%ebp
  80278d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802790:	6a 00                	push   $0x0
  802792:	6a 00                	push   $0x0
  802794:	6a 00                	push   $0x0
  802796:	6a 00                	push   $0x0
  802798:	6a 00                	push   $0x0
  80279a:	6a 2c                	push   $0x2c
  80279c:	e8 4a fa ff ff       	call   8021eb <syscall>
  8027a1:	83 c4 18             	add    $0x18,%esp
  8027a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8027a7:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8027ab:	75 07                	jne    8027b4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8027ad:	b8 01 00 00 00       	mov    $0x1,%eax
  8027b2:	eb 05                	jmp    8027b9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8027b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027b9:	c9                   	leave  
  8027ba:	c3                   	ret    

008027bb <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8027bb:	55                   	push   %ebp
  8027bc:	89 e5                	mov    %esp,%ebp
  8027be:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8027c1:	6a 00                	push   $0x0
  8027c3:	6a 00                	push   $0x0
  8027c5:	6a 00                	push   $0x0
  8027c7:	6a 00                	push   $0x0
  8027c9:	6a 00                	push   $0x0
  8027cb:	6a 2c                	push   $0x2c
  8027cd:	e8 19 fa ff ff       	call   8021eb <syscall>
  8027d2:	83 c4 18             	add    $0x18,%esp
  8027d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8027d8:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8027dc:	75 07                	jne    8027e5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8027de:	b8 01 00 00 00       	mov    $0x1,%eax
  8027e3:	eb 05                	jmp    8027ea <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8027e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027ea:	c9                   	leave  
  8027eb:	c3                   	ret    

008027ec <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8027ec:	55                   	push   %ebp
  8027ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8027ef:	6a 00                	push   $0x0
  8027f1:	6a 00                	push   $0x0
  8027f3:	6a 00                	push   $0x0
  8027f5:	6a 00                	push   $0x0
  8027f7:	ff 75 08             	pushl  0x8(%ebp)
  8027fa:	6a 2d                	push   $0x2d
  8027fc:	e8 ea f9 ff ff       	call   8021eb <syscall>
  802801:	83 c4 18             	add    $0x18,%esp
	return ;
  802804:	90                   	nop
}
  802805:	c9                   	leave  
  802806:	c3                   	ret    

00802807 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802807:	55                   	push   %ebp
  802808:	89 e5                	mov    %esp,%ebp
  80280a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80280b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80280e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802811:	8b 55 0c             	mov    0xc(%ebp),%edx
  802814:	8b 45 08             	mov    0x8(%ebp),%eax
  802817:	6a 00                	push   $0x0
  802819:	53                   	push   %ebx
  80281a:	51                   	push   %ecx
  80281b:	52                   	push   %edx
  80281c:	50                   	push   %eax
  80281d:	6a 2e                	push   $0x2e
  80281f:	e8 c7 f9 ff ff       	call   8021eb <syscall>
  802824:	83 c4 18             	add    $0x18,%esp
}
  802827:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80282a:	c9                   	leave  
  80282b:	c3                   	ret    

0080282c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80282c:	55                   	push   %ebp
  80282d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80282f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802832:	8b 45 08             	mov    0x8(%ebp),%eax
  802835:	6a 00                	push   $0x0
  802837:	6a 00                	push   $0x0
  802839:	6a 00                	push   $0x0
  80283b:	52                   	push   %edx
  80283c:	50                   	push   %eax
  80283d:	6a 2f                	push   $0x2f
  80283f:	e8 a7 f9 ff ff       	call   8021eb <syscall>
  802844:	83 c4 18             	add    $0x18,%esp
}
  802847:	c9                   	leave  
  802848:	c3                   	ret    

00802849 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802849:	55                   	push   %ebp
  80284a:	89 e5                	mov    %esp,%ebp
  80284c:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80284f:	83 ec 0c             	sub    $0xc,%esp
  802852:	68 5c 47 80 00       	push   $0x80475c
  802857:	e8 df e6 ff ff       	call   800f3b <cprintf>
  80285c:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80285f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802866:	83 ec 0c             	sub    $0xc,%esp
  802869:	68 88 47 80 00       	push   $0x804788
  80286e:	e8 c8 e6 ff ff       	call   800f3b <cprintf>
  802873:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802876:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80287a:	a1 38 51 80 00       	mov    0x805138,%eax
  80287f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802882:	eb 56                	jmp    8028da <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802884:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802888:	74 1c                	je     8028a6 <print_mem_block_lists+0x5d>
  80288a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288d:	8b 50 08             	mov    0x8(%eax),%edx
  802890:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802893:	8b 48 08             	mov    0x8(%eax),%ecx
  802896:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802899:	8b 40 0c             	mov    0xc(%eax),%eax
  80289c:	01 c8                	add    %ecx,%eax
  80289e:	39 c2                	cmp    %eax,%edx
  8028a0:	73 04                	jae    8028a6 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8028a2:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8028a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a9:	8b 50 08             	mov    0x8(%eax),%edx
  8028ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028af:	8b 40 0c             	mov    0xc(%eax),%eax
  8028b2:	01 c2                	add    %eax,%edx
  8028b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b7:	8b 40 08             	mov    0x8(%eax),%eax
  8028ba:	83 ec 04             	sub    $0x4,%esp
  8028bd:	52                   	push   %edx
  8028be:	50                   	push   %eax
  8028bf:	68 9d 47 80 00       	push   $0x80479d
  8028c4:	e8 72 e6 ff ff       	call   800f3b <cprintf>
  8028c9:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8028cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8028d2:	a1 40 51 80 00       	mov    0x805140,%eax
  8028d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028de:	74 07                	je     8028e7 <print_mem_block_lists+0x9e>
  8028e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e3:	8b 00                	mov    (%eax),%eax
  8028e5:	eb 05                	jmp    8028ec <print_mem_block_lists+0xa3>
  8028e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8028ec:	a3 40 51 80 00       	mov    %eax,0x805140
  8028f1:	a1 40 51 80 00       	mov    0x805140,%eax
  8028f6:	85 c0                	test   %eax,%eax
  8028f8:	75 8a                	jne    802884 <print_mem_block_lists+0x3b>
  8028fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028fe:	75 84                	jne    802884 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802900:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802904:	75 10                	jne    802916 <print_mem_block_lists+0xcd>
  802906:	83 ec 0c             	sub    $0xc,%esp
  802909:	68 ac 47 80 00       	push   $0x8047ac
  80290e:	e8 28 e6 ff ff       	call   800f3b <cprintf>
  802913:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802916:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80291d:	83 ec 0c             	sub    $0xc,%esp
  802920:	68 d0 47 80 00       	push   $0x8047d0
  802925:	e8 11 e6 ff ff       	call   800f3b <cprintf>
  80292a:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80292d:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802931:	a1 40 50 80 00       	mov    0x805040,%eax
  802936:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802939:	eb 56                	jmp    802991 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80293b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80293f:	74 1c                	je     80295d <print_mem_block_lists+0x114>
  802941:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802944:	8b 50 08             	mov    0x8(%eax),%edx
  802947:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80294a:	8b 48 08             	mov    0x8(%eax),%ecx
  80294d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802950:	8b 40 0c             	mov    0xc(%eax),%eax
  802953:	01 c8                	add    %ecx,%eax
  802955:	39 c2                	cmp    %eax,%edx
  802957:	73 04                	jae    80295d <print_mem_block_lists+0x114>
			sorted = 0 ;
  802959:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80295d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802960:	8b 50 08             	mov    0x8(%eax),%edx
  802963:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802966:	8b 40 0c             	mov    0xc(%eax),%eax
  802969:	01 c2                	add    %eax,%edx
  80296b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296e:	8b 40 08             	mov    0x8(%eax),%eax
  802971:	83 ec 04             	sub    $0x4,%esp
  802974:	52                   	push   %edx
  802975:	50                   	push   %eax
  802976:	68 9d 47 80 00       	push   $0x80479d
  80297b:	e8 bb e5 ff ff       	call   800f3b <cprintf>
  802980:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802983:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802986:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802989:	a1 48 50 80 00       	mov    0x805048,%eax
  80298e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802991:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802995:	74 07                	je     80299e <print_mem_block_lists+0x155>
  802997:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299a:	8b 00                	mov    (%eax),%eax
  80299c:	eb 05                	jmp    8029a3 <print_mem_block_lists+0x15a>
  80299e:	b8 00 00 00 00       	mov    $0x0,%eax
  8029a3:	a3 48 50 80 00       	mov    %eax,0x805048
  8029a8:	a1 48 50 80 00       	mov    0x805048,%eax
  8029ad:	85 c0                	test   %eax,%eax
  8029af:	75 8a                	jne    80293b <print_mem_block_lists+0xf2>
  8029b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029b5:	75 84                	jne    80293b <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8029b7:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8029bb:	75 10                	jne    8029cd <print_mem_block_lists+0x184>
  8029bd:	83 ec 0c             	sub    $0xc,%esp
  8029c0:	68 e8 47 80 00       	push   $0x8047e8
  8029c5:	e8 71 e5 ff ff       	call   800f3b <cprintf>
  8029ca:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8029cd:	83 ec 0c             	sub    $0xc,%esp
  8029d0:	68 5c 47 80 00       	push   $0x80475c
  8029d5:	e8 61 e5 ff ff       	call   800f3b <cprintf>
  8029da:	83 c4 10             	add    $0x10,%esp

}
  8029dd:	90                   	nop
  8029de:	c9                   	leave  
  8029df:	c3                   	ret    

008029e0 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8029e0:	55                   	push   %ebp
  8029e1:	89 e5                	mov    %esp,%ebp
  8029e3:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8029e6:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8029ed:	00 00 00 
  8029f0:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8029f7:	00 00 00 
  8029fa:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802a01:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  802a04:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802a0b:	e9 9e 00 00 00       	jmp    802aae <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802a10:	a1 50 50 80 00       	mov    0x805050,%eax
  802a15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a18:	c1 e2 04             	shl    $0x4,%edx
  802a1b:	01 d0                	add    %edx,%eax
  802a1d:	85 c0                	test   %eax,%eax
  802a1f:	75 14                	jne    802a35 <initialize_MemBlocksList+0x55>
  802a21:	83 ec 04             	sub    $0x4,%esp
  802a24:	68 10 48 80 00       	push   $0x804810
  802a29:	6a 42                	push   $0x42
  802a2b:	68 33 48 80 00       	push   $0x804833
  802a30:	e8 52 e2 ff ff       	call   800c87 <_panic>
  802a35:	a1 50 50 80 00       	mov    0x805050,%eax
  802a3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a3d:	c1 e2 04             	shl    $0x4,%edx
  802a40:	01 d0                	add    %edx,%eax
  802a42:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802a48:	89 10                	mov    %edx,(%eax)
  802a4a:	8b 00                	mov    (%eax),%eax
  802a4c:	85 c0                	test   %eax,%eax
  802a4e:	74 18                	je     802a68 <initialize_MemBlocksList+0x88>
  802a50:	a1 48 51 80 00       	mov    0x805148,%eax
  802a55:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802a5b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802a5e:	c1 e1 04             	shl    $0x4,%ecx
  802a61:	01 ca                	add    %ecx,%edx
  802a63:	89 50 04             	mov    %edx,0x4(%eax)
  802a66:	eb 12                	jmp    802a7a <initialize_MemBlocksList+0x9a>
  802a68:	a1 50 50 80 00       	mov    0x805050,%eax
  802a6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a70:	c1 e2 04             	shl    $0x4,%edx
  802a73:	01 d0                	add    %edx,%eax
  802a75:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a7a:	a1 50 50 80 00       	mov    0x805050,%eax
  802a7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a82:	c1 e2 04             	shl    $0x4,%edx
  802a85:	01 d0                	add    %edx,%eax
  802a87:	a3 48 51 80 00       	mov    %eax,0x805148
  802a8c:	a1 50 50 80 00       	mov    0x805050,%eax
  802a91:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a94:	c1 e2 04             	shl    $0x4,%edx
  802a97:	01 d0                	add    %edx,%eax
  802a99:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aa0:	a1 54 51 80 00       	mov    0x805154,%eax
  802aa5:	40                   	inc    %eax
  802aa6:	a3 54 51 80 00       	mov    %eax,0x805154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  802aab:	ff 45 f4             	incl   -0xc(%ebp)
  802aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ab4:	0f 82 56 ff ff ff    	jb     802a10 <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  802aba:	90                   	nop
  802abb:	c9                   	leave  
  802abc:	c3                   	ret    

00802abd <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802abd:	55                   	push   %ebp
  802abe:	89 e5                	mov    %esp,%ebp
  802ac0:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  802ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac6:	8b 00                	mov    (%eax),%eax
  802ac8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802acb:	eb 19                	jmp    802ae6 <find_block+0x29>
	{
		if(blk->sva==va)
  802acd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802ad0:	8b 40 08             	mov    0x8(%eax),%eax
  802ad3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802ad6:	75 05                	jne    802add <find_block+0x20>
			return (blk);
  802ad8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802adb:	eb 36                	jmp    802b13 <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  802add:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae0:	8b 40 08             	mov    0x8(%eax),%eax
  802ae3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802ae6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802aea:	74 07                	je     802af3 <find_block+0x36>
  802aec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802aef:	8b 00                	mov    (%eax),%eax
  802af1:	eb 05                	jmp    802af8 <find_block+0x3b>
  802af3:	b8 00 00 00 00       	mov    $0x0,%eax
  802af8:	8b 55 08             	mov    0x8(%ebp),%edx
  802afb:	89 42 08             	mov    %eax,0x8(%edx)
  802afe:	8b 45 08             	mov    0x8(%ebp),%eax
  802b01:	8b 40 08             	mov    0x8(%eax),%eax
  802b04:	85 c0                	test   %eax,%eax
  802b06:	75 c5                	jne    802acd <find_block+0x10>
  802b08:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802b0c:	75 bf                	jne    802acd <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  802b0e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b13:	c9                   	leave  
  802b14:	c3                   	ret    

00802b15 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802b15:	55                   	push   %ebp
  802b16:	89 e5                	mov    %esp,%ebp
  802b18:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  802b1b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b20:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802b23:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  802b2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802b30:	75 65                	jne    802b97 <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802b32:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b36:	75 14                	jne    802b4c <insert_sorted_allocList+0x37>
  802b38:	83 ec 04             	sub    $0x4,%esp
  802b3b:	68 10 48 80 00       	push   $0x804810
  802b40:	6a 5c                	push   $0x5c
  802b42:	68 33 48 80 00       	push   $0x804833
  802b47:	e8 3b e1 ff ff       	call   800c87 <_panic>
  802b4c:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802b52:	8b 45 08             	mov    0x8(%ebp),%eax
  802b55:	89 10                	mov    %edx,(%eax)
  802b57:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5a:	8b 00                	mov    (%eax),%eax
  802b5c:	85 c0                	test   %eax,%eax
  802b5e:	74 0d                	je     802b6d <insert_sorted_allocList+0x58>
  802b60:	a1 40 50 80 00       	mov    0x805040,%eax
  802b65:	8b 55 08             	mov    0x8(%ebp),%edx
  802b68:	89 50 04             	mov    %edx,0x4(%eax)
  802b6b:	eb 08                	jmp    802b75 <insert_sorted_allocList+0x60>
  802b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b70:	a3 44 50 80 00       	mov    %eax,0x805044
  802b75:	8b 45 08             	mov    0x8(%ebp),%eax
  802b78:	a3 40 50 80 00       	mov    %eax,0x805040
  802b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b80:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b87:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b8c:	40                   	inc    %eax
  802b8d:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  802b92:	e9 7b 01 00 00       	jmp    802d12 <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  802b97:	a1 44 50 80 00       	mov    0x805044,%eax
  802b9c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  802b9f:	a1 40 50 80 00       	mov    0x805040,%eax
  802ba4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  802ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  802baa:	8b 50 08             	mov    0x8(%eax),%edx
  802bad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bb0:	8b 40 08             	mov    0x8(%eax),%eax
  802bb3:	39 c2                	cmp    %eax,%edx
  802bb5:	76 65                	jbe    802c1c <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  802bb7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bbb:	75 14                	jne    802bd1 <insert_sorted_allocList+0xbc>
  802bbd:	83 ec 04             	sub    $0x4,%esp
  802bc0:	68 4c 48 80 00       	push   $0x80484c
  802bc5:	6a 64                	push   $0x64
  802bc7:	68 33 48 80 00       	push   $0x804833
  802bcc:	e8 b6 e0 ff ff       	call   800c87 <_panic>
  802bd1:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bda:	89 50 04             	mov    %edx,0x4(%eax)
  802bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  802be0:	8b 40 04             	mov    0x4(%eax),%eax
  802be3:	85 c0                	test   %eax,%eax
  802be5:	74 0c                	je     802bf3 <insert_sorted_allocList+0xde>
  802be7:	a1 44 50 80 00       	mov    0x805044,%eax
  802bec:	8b 55 08             	mov    0x8(%ebp),%edx
  802bef:	89 10                	mov    %edx,(%eax)
  802bf1:	eb 08                	jmp    802bfb <insert_sorted_allocList+0xe6>
  802bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf6:	a3 40 50 80 00       	mov    %eax,0x805040
  802bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfe:	a3 44 50 80 00       	mov    %eax,0x805044
  802c03:	8b 45 08             	mov    0x8(%ebp),%eax
  802c06:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c0c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c11:	40                   	inc    %eax
  802c12:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  802c17:	e9 f6 00 00 00       	jmp    802d12 <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  802c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1f:	8b 50 08             	mov    0x8(%eax),%edx
  802c22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c25:	8b 40 08             	mov    0x8(%eax),%eax
  802c28:	39 c2                	cmp    %eax,%edx
  802c2a:	73 65                	jae    802c91 <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802c2c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c30:	75 14                	jne    802c46 <insert_sorted_allocList+0x131>
  802c32:	83 ec 04             	sub    $0x4,%esp
  802c35:	68 10 48 80 00       	push   $0x804810
  802c3a:	6a 68                	push   $0x68
  802c3c:	68 33 48 80 00       	push   $0x804833
  802c41:	e8 41 e0 ff ff       	call   800c87 <_panic>
  802c46:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4f:	89 10                	mov    %edx,(%eax)
  802c51:	8b 45 08             	mov    0x8(%ebp),%eax
  802c54:	8b 00                	mov    (%eax),%eax
  802c56:	85 c0                	test   %eax,%eax
  802c58:	74 0d                	je     802c67 <insert_sorted_allocList+0x152>
  802c5a:	a1 40 50 80 00       	mov    0x805040,%eax
  802c5f:	8b 55 08             	mov    0x8(%ebp),%edx
  802c62:	89 50 04             	mov    %edx,0x4(%eax)
  802c65:	eb 08                	jmp    802c6f <insert_sorted_allocList+0x15a>
  802c67:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6a:	a3 44 50 80 00       	mov    %eax,0x805044
  802c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c72:	a3 40 50 80 00       	mov    %eax,0x805040
  802c77:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c81:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c86:	40                   	inc    %eax
  802c87:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  802c8c:	e9 81 00 00 00       	jmp    802d12 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802c91:	a1 40 50 80 00       	mov    0x805040,%eax
  802c96:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c99:	eb 51                	jmp    802cec <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  802c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9e:	8b 50 08             	mov    0x8(%eax),%edx
  802ca1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca4:	8b 40 08             	mov    0x8(%eax),%eax
  802ca7:	39 c2                	cmp    %eax,%edx
  802ca9:	73 39                	jae    802ce4 <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  802cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cae:	8b 40 04             	mov    0x4(%eax),%eax
  802cb1:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  802cb4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cb7:	8b 55 08             	mov    0x8(%ebp),%edx
  802cba:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  802cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802cc2:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  802cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ccb:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  802ccd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd0:	8b 55 08             	mov    0x8(%ebp),%edx
  802cd3:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  802cd6:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802cdb:	40                   	inc    %eax
  802cdc:	a3 4c 50 80 00       	mov    %eax,0x80504c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  802ce1:	90                   	nop
				}
			}
		 }

	}
}
  802ce2:	eb 2e                	jmp    802d12 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802ce4:	a1 48 50 80 00       	mov    0x805048,%eax
  802ce9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cf0:	74 07                	je     802cf9 <insert_sorted_allocList+0x1e4>
  802cf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf5:	8b 00                	mov    (%eax),%eax
  802cf7:	eb 05                	jmp    802cfe <insert_sorted_allocList+0x1e9>
  802cf9:	b8 00 00 00 00       	mov    $0x0,%eax
  802cfe:	a3 48 50 80 00       	mov    %eax,0x805048
  802d03:	a1 48 50 80 00       	mov    0x805048,%eax
  802d08:	85 c0                	test   %eax,%eax
  802d0a:	75 8f                	jne    802c9b <insert_sorted_allocList+0x186>
  802d0c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d10:	75 89                	jne    802c9b <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  802d12:	90                   	nop
  802d13:	c9                   	leave  
  802d14:	c3                   	ret    

00802d15 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802d15:	55                   	push   %ebp
  802d16:	89 e5                	mov    %esp,%ebp
  802d18:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802d1b:	a1 38 51 80 00       	mov    0x805138,%eax
  802d20:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d23:	e9 76 01 00 00       	jmp    802e9e <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  802d28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2b:	8b 40 0c             	mov    0xc(%eax),%eax
  802d2e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d31:	0f 85 8a 00 00 00    	jne    802dc1 <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  802d37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d3b:	75 17                	jne    802d54 <alloc_block_FF+0x3f>
  802d3d:	83 ec 04             	sub    $0x4,%esp
  802d40:	68 6f 48 80 00       	push   $0x80486f
  802d45:	68 8a 00 00 00       	push   $0x8a
  802d4a:	68 33 48 80 00       	push   $0x804833
  802d4f:	e8 33 df ff ff       	call   800c87 <_panic>
  802d54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d57:	8b 00                	mov    (%eax),%eax
  802d59:	85 c0                	test   %eax,%eax
  802d5b:	74 10                	je     802d6d <alloc_block_FF+0x58>
  802d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d60:	8b 00                	mov    (%eax),%eax
  802d62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d65:	8b 52 04             	mov    0x4(%edx),%edx
  802d68:	89 50 04             	mov    %edx,0x4(%eax)
  802d6b:	eb 0b                	jmp    802d78 <alloc_block_FF+0x63>
  802d6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d70:	8b 40 04             	mov    0x4(%eax),%eax
  802d73:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7b:	8b 40 04             	mov    0x4(%eax),%eax
  802d7e:	85 c0                	test   %eax,%eax
  802d80:	74 0f                	je     802d91 <alloc_block_FF+0x7c>
  802d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d85:	8b 40 04             	mov    0x4(%eax),%eax
  802d88:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d8b:	8b 12                	mov    (%edx),%edx
  802d8d:	89 10                	mov    %edx,(%eax)
  802d8f:	eb 0a                	jmp    802d9b <alloc_block_FF+0x86>
  802d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d94:	8b 00                	mov    (%eax),%eax
  802d96:	a3 38 51 80 00       	mov    %eax,0x805138
  802d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802da4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dae:	a1 44 51 80 00       	mov    0x805144,%eax
  802db3:	48                   	dec    %eax
  802db4:	a3 44 51 80 00       	mov    %eax,0x805144
			return element;
  802db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbc:	e9 10 01 00 00       	jmp    802ed1 <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  802dc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc4:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc7:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dca:	0f 86 c6 00 00 00    	jbe    802e96 <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802dd0:	a1 48 51 80 00       	mov    0x805148,%eax
  802dd5:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802dd8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ddc:	75 17                	jne    802df5 <alloc_block_FF+0xe0>
  802dde:	83 ec 04             	sub    $0x4,%esp
  802de1:	68 6f 48 80 00       	push   $0x80486f
  802de6:	68 90 00 00 00       	push   $0x90
  802deb:	68 33 48 80 00       	push   $0x804833
  802df0:	e8 92 de ff ff       	call   800c87 <_panic>
  802df5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df8:	8b 00                	mov    (%eax),%eax
  802dfa:	85 c0                	test   %eax,%eax
  802dfc:	74 10                	je     802e0e <alloc_block_FF+0xf9>
  802dfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e01:	8b 00                	mov    (%eax),%eax
  802e03:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e06:	8b 52 04             	mov    0x4(%edx),%edx
  802e09:	89 50 04             	mov    %edx,0x4(%eax)
  802e0c:	eb 0b                	jmp    802e19 <alloc_block_FF+0x104>
  802e0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e11:	8b 40 04             	mov    0x4(%eax),%eax
  802e14:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e1c:	8b 40 04             	mov    0x4(%eax),%eax
  802e1f:	85 c0                	test   %eax,%eax
  802e21:	74 0f                	je     802e32 <alloc_block_FF+0x11d>
  802e23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e26:	8b 40 04             	mov    0x4(%eax),%eax
  802e29:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e2c:	8b 12                	mov    (%edx),%edx
  802e2e:	89 10                	mov    %edx,(%eax)
  802e30:	eb 0a                	jmp    802e3c <alloc_block_FF+0x127>
  802e32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e35:	8b 00                	mov    (%eax),%eax
  802e37:	a3 48 51 80 00       	mov    %eax,0x805148
  802e3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e3f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e48:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e4f:	a1 54 51 80 00       	mov    0x805154,%eax
  802e54:	48                   	dec    %eax
  802e55:	a3 54 51 80 00       	mov    %eax,0x805154
			 element1->size =size;
  802e5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e5d:	8b 55 08             	mov    0x8(%ebp),%edx
  802e60:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  802e63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e66:	8b 50 08             	mov    0x8(%eax),%edx
  802e69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e6c:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  802e6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e72:	8b 50 08             	mov    0x8(%eax),%edx
  802e75:	8b 45 08             	mov    0x8(%ebp),%eax
  802e78:	01 c2                	add    %eax,%edx
  802e7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7d:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  802e80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e83:	8b 40 0c             	mov    0xc(%eax),%eax
  802e86:	2b 45 08             	sub    0x8(%ebp),%eax
  802e89:	89 c2                	mov    %eax,%edx
  802e8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8e:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  802e91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e94:	eb 3b                	jmp    802ed1 <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802e96:	a1 40 51 80 00       	mov    0x805140,%eax
  802e9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ea2:	74 07                	je     802eab <alloc_block_FF+0x196>
  802ea4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea7:	8b 00                	mov    (%eax),%eax
  802ea9:	eb 05                	jmp    802eb0 <alloc_block_FF+0x19b>
  802eab:	b8 00 00 00 00       	mov    $0x0,%eax
  802eb0:	a3 40 51 80 00       	mov    %eax,0x805140
  802eb5:	a1 40 51 80 00       	mov    0x805140,%eax
  802eba:	85 c0                	test   %eax,%eax
  802ebc:	0f 85 66 fe ff ff    	jne    802d28 <alloc_block_FF+0x13>
  802ec2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ec6:	0f 85 5c fe ff ff    	jne    802d28 <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  802ecc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ed1:	c9                   	leave  
  802ed2:	c3                   	ret    

00802ed3 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802ed3:	55                   	push   %ebp
  802ed4:	89 e5                	mov    %esp,%ebp
  802ed6:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  802ed9:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  802ee0:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  802ee7:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802eee:	a1 38 51 80 00       	mov    0x805138,%eax
  802ef3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ef6:	e9 cf 00 00 00       	jmp    802fca <alloc_block_BF+0xf7>
		{
			c++;
  802efb:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  802efe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f01:	8b 40 0c             	mov    0xc(%eax),%eax
  802f04:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f07:	0f 85 8a 00 00 00    	jne    802f97 <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  802f0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f11:	75 17                	jne    802f2a <alloc_block_BF+0x57>
  802f13:	83 ec 04             	sub    $0x4,%esp
  802f16:	68 6f 48 80 00       	push   $0x80486f
  802f1b:	68 a8 00 00 00       	push   $0xa8
  802f20:	68 33 48 80 00       	push   $0x804833
  802f25:	e8 5d dd ff ff       	call   800c87 <_panic>
  802f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2d:	8b 00                	mov    (%eax),%eax
  802f2f:	85 c0                	test   %eax,%eax
  802f31:	74 10                	je     802f43 <alloc_block_BF+0x70>
  802f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f36:	8b 00                	mov    (%eax),%eax
  802f38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f3b:	8b 52 04             	mov    0x4(%edx),%edx
  802f3e:	89 50 04             	mov    %edx,0x4(%eax)
  802f41:	eb 0b                	jmp    802f4e <alloc_block_BF+0x7b>
  802f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f46:	8b 40 04             	mov    0x4(%eax),%eax
  802f49:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f51:	8b 40 04             	mov    0x4(%eax),%eax
  802f54:	85 c0                	test   %eax,%eax
  802f56:	74 0f                	je     802f67 <alloc_block_BF+0x94>
  802f58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5b:	8b 40 04             	mov    0x4(%eax),%eax
  802f5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f61:	8b 12                	mov    (%edx),%edx
  802f63:	89 10                	mov    %edx,(%eax)
  802f65:	eb 0a                	jmp    802f71 <alloc_block_BF+0x9e>
  802f67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6a:	8b 00                	mov    (%eax),%eax
  802f6c:	a3 38 51 80 00       	mov    %eax,0x805138
  802f71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f74:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f84:	a1 44 51 80 00       	mov    0x805144,%eax
  802f89:	48                   	dec    %eax
  802f8a:	a3 44 51 80 00       	mov    %eax,0x805144
				return block;
  802f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f92:	e9 85 01 00 00       	jmp    80311c <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  802f97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9a:	8b 40 0c             	mov    0xc(%eax),%eax
  802f9d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fa0:	76 20                	jbe    802fc2 <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  802fa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa5:	8b 40 0c             	mov    0xc(%eax),%eax
  802fa8:	2b 45 08             	sub    0x8(%ebp),%eax
  802fab:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  802fae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fb1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802fb4:	73 0c                	jae    802fc2 <alloc_block_BF+0xef>
				{
					ma=tempi;
  802fb6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fb9:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  802fbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fbf:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802fc2:	a1 40 51 80 00       	mov    0x805140,%eax
  802fc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fce:	74 07                	je     802fd7 <alloc_block_BF+0x104>
  802fd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd3:	8b 00                	mov    (%eax),%eax
  802fd5:	eb 05                	jmp    802fdc <alloc_block_BF+0x109>
  802fd7:	b8 00 00 00 00       	mov    $0x0,%eax
  802fdc:	a3 40 51 80 00       	mov    %eax,0x805140
  802fe1:	a1 40 51 80 00       	mov    0x805140,%eax
  802fe6:	85 c0                	test   %eax,%eax
  802fe8:	0f 85 0d ff ff ff    	jne    802efb <alloc_block_BF+0x28>
  802fee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ff2:	0f 85 03 ff ff ff    	jne    802efb <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  802ff8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802fff:	a1 38 51 80 00       	mov    0x805138,%eax
  803004:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803007:	e9 dd 00 00 00       	jmp    8030e9 <alloc_block_BF+0x216>
		{
			if(x==sol)
  80300c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80300f:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  803012:	0f 85 c6 00 00 00    	jne    8030de <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  803018:	a1 48 51 80 00       	mov    0x805148,%eax
  80301d:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  803020:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  803024:	75 17                	jne    80303d <alloc_block_BF+0x16a>
  803026:	83 ec 04             	sub    $0x4,%esp
  803029:	68 6f 48 80 00       	push   $0x80486f
  80302e:	68 bb 00 00 00       	push   $0xbb
  803033:	68 33 48 80 00       	push   $0x804833
  803038:	e8 4a dc ff ff       	call   800c87 <_panic>
  80303d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803040:	8b 00                	mov    (%eax),%eax
  803042:	85 c0                	test   %eax,%eax
  803044:	74 10                	je     803056 <alloc_block_BF+0x183>
  803046:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803049:	8b 00                	mov    (%eax),%eax
  80304b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80304e:	8b 52 04             	mov    0x4(%edx),%edx
  803051:	89 50 04             	mov    %edx,0x4(%eax)
  803054:	eb 0b                	jmp    803061 <alloc_block_BF+0x18e>
  803056:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803059:	8b 40 04             	mov    0x4(%eax),%eax
  80305c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803061:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803064:	8b 40 04             	mov    0x4(%eax),%eax
  803067:	85 c0                	test   %eax,%eax
  803069:	74 0f                	je     80307a <alloc_block_BF+0x1a7>
  80306b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80306e:	8b 40 04             	mov    0x4(%eax),%eax
  803071:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803074:	8b 12                	mov    (%edx),%edx
  803076:	89 10                	mov    %edx,(%eax)
  803078:	eb 0a                	jmp    803084 <alloc_block_BF+0x1b1>
  80307a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80307d:	8b 00                	mov    (%eax),%eax
  80307f:	a3 48 51 80 00       	mov    %eax,0x805148
  803084:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803087:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80308d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803090:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803097:	a1 54 51 80 00       	mov    0x805154,%eax
  80309c:	48                   	dec    %eax
  80309d:	a3 54 51 80 00       	mov    %eax,0x805154
						 element1->size =size;
  8030a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8030a8:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  8030ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ae:	8b 50 08             	mov    0x8(%eax),%edx
  8030b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030b4:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  8030b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ba:	8b 50 08             	mov    0x8(%eax),%edx
  8030bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c0:	01 c2                	add    %eax,%edx
  8030c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c5:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  8030c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8030ce:	2b 45 08             	sub    0x8(%ebp),%eax
  8030d1:	89 c2                	mov    %eax,%edx
  8030d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d6:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  8030d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030dc:	eb 3e                	jmp    80311c <alloc_block_BF+0x249>
						 break;
			}
			x++;
  8030de:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8030e1:	a1 40 51 80 00       	mov    0x805140,%eax
  8030e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030ed:	74 07                	je     8030f6 <alloc_block_BF+0x223>
  8030ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f2:	8b 00                	mov    (%eax),%eax
  8030f4:	eb 05                	jmp    8030fb <alloc_block_BF+0x228>
  8030f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8030fb:	a3 40 51 80 00       	mov    %eax,0x805140
  803100:	a1 40 51 80 00       	mov    0x805140,%eax
  803105:	85 c0                	test   %eax,%eax
  803107:	0f 85 ff fe ff ff    	jne    80300c <alloc_block_BF+0x139>
  80310d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803111:	0f 85 f5 fe ff ff    	jne    80300c <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  803117:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80311c:	c9                   	leave  
  80311d:	c3                   	ret    

0080311e <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  80311e:	55                   	push   %ebp
  80311f:	89 e5                	mov    %esp,%ebp
  803121:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  803124:	a1 28 50 80 00       	mov    0x805028,%eax
  803129:	85 c0                	test   %eax,%eax
  80312b:	75 14                	jne    803141 <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  80312d:	a1 38 51 80 00       	mov    0x805138,%eax
  803132:	a3 60 51 80 00       	mov    %eax,0x805160
		hh=1;
  803137:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  80313e:	00 00 00 
	}
	uint32 c=1;
  803141:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  803148:	a1 60 51 80 00       	mov    0x805160,%eax
  80314d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  803150:	e9 b3 01 00 00       	jmp    803308 <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  803155:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803158:	8b 40 0c             	mov    0xc(%eax),%eax
  80315b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80315e:	0f 85 a9 00 00 00    	jne    80320d <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  803164:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803167:	8b 00                	mov    (%eax),%eax
  803169:	85 c0                	test   %eax,%eax
  80316b:	75 0c                	jne    803179 <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  80316d:	a1 38 51 80 00       	mov    0x805138,%eax
  803172:	a3 60 51 80 00       	mov    %eax,0x805160
  803177:	eb 0a                	jmp    803183 <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  803179:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80317c:	8b 00                	mov    (%eax),%eax
  80317e:	a3 60 51 80 00       	mov    %eax,0x805160
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  803183:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803187:	75 17                	jne    8031a0 <alloc_block_NF+0x82>
  803189:	83 ec 04             	sub    $0x4,%esp
  80318c:	68 6f 48 80 00       	push   $0x80486f
  803191:	68 e3 00 00 00       	push   $0xe3
  803196:	68 33 48 80 00       	push   $0x804833
  80319b:	e8 e7 da ff ff       	call   800c87 <_panic>
  8031a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031a3:	8b 00                	mov    (%eax),%eax
  8031a5:	85 c0                	test   %eax,%eax
  8031a7:	74 10                	je     8031b9 <alloc_block_NF+0x9b>
  8031a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ac:	8b 00                	mov    (%eax),%eax
  8031ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031b1:	8b 52 04             	mov    0x4(%edx),%edx
  8031b4:	89 50 04             	mov    %edx,0x4(%eax)
  8031b7:	eb 0b                	jmp    8031c4 <alloc_block_NF+0xa6>
  8031b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031bc:	8b 40 04             	mov    0x4(%eax),%eax
  8031bf:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031c7:	8b 40 04             	mov    0x4(%eax),%eax
  8031ca:	85 c0                	test   %eax,%eax
  8031cc:	74 0f                	je     8031dd <alloc_block_NF+0xbf>
  8031ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d1:	8b 40 04             	mov    0x4(%eax),%eax
  8031d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031d7:	8b 12                	mov    (%edx),%edx
  8031d9:	89 10                	mov    %edx,(%eax)
  8031db:	eb 0a                	jmp    8031e7 <alloc_block_NF+0xc9>
  8031dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e0:	8b 00                	mov    (%eax),%eax
  8031e2:	a3 38 51 80 00       	mov    %eax,0x805138
  8031e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031fa:	a1 44 51 80 00       	mov    0x805144,%eax
  8031ff:	48                   	dec    %eax
  803200:	a3 44 51 80 00       	mov    %eax,0x805144
				return element;
  803205:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803208:	e9 0e 01 00 00       	jmp    80331b <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  80320d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803210:	8b 40 0c             	mov    0xc(%eax),%eax
  803213:	3b 45 08             	cmp    0x8(%ebp),%eax
  803216:	0f 86 ce 00 00 00    	jbe    8032ea <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  80321c:	a1 48 51 80 00       	mov    0x805148,%eax
  803221:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  803224:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803228:	75 17                	jne    803241 <alloc_block_NF+0x123>
  80322a:	83 ec 04             	sub    $0x4,%esp
  80322d:	68 6f 48 80 00       	push   $0x80486f
  803232:	68 e9 00 00 00       	push   $0xe9
  803237:	68 33 48 80 00       	push   $0x804833
  80323c:	e8 46 da ff ff       	call   800c87 <_panic>
  803241:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803244:	8b 00                	mov    (%eax),%eax
  803246:	85 c0                	test   %eax,%eax
  803248:	74 10                	je     80325a <alloc_block_NF+0x13c>
  80324a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80324d:	8b 00                	mov    (%eax),%eax
  80324f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803252:	8b 52 04             	mov    0x4(%edx),%edx
  803255:	89 50 04             	mov    %edx,0x4(%eax)
  803258:	eb 0b                	jmp    803265 <alloc_block_NF+0x147>
  80325a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80325d:	8b 40 04             	mov    0x4(%eax),%eax
  803260:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803265:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803268:	8b 40 04             	mov    0x4(%eax),%eax
  80326b:	85 c0                	test   %eax,%eax
  80326d:	74 0f                	je     80327e <alloc_block_NF+0x160>
  80326f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803272:	8b 40 04             	mov    0x4(%eax),%eax
  803275:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803278:	8b 12                	mov    (%edx),%edx
  80327a:	89 10                	mov    %edx,(%eax)
  80327c:	eb 0a                	jmp    803288 <alloc_block_NF+0x16a>
  80327e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803281:	8b 00                	mov    (%eax),%eax
  803283:	a3 48 51 80 00       	mov    %eax,0x805148
  803288:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80328b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803291:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803294:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80329b:	a1 54 51 80 00       	mov    0x805154,%eax
  8032a0:	48                   	dec    %eax
  8032a1:	a3 54 51 80 00       	mov    %eax,0x805154
				 element1->size =size;
  8032a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8032ac:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  8032af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b2:	8b 50 08             	mov    0x8(%eax),%edx
  8032b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032b8:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  8032bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032be:	8b 50 08             	mov    0x8(%eax),%edx
  8032c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c4:	01 c2                	add    %eax,%edx
  8032c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032c9:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  8032cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8032d2:	2b 45 08             	sub    0x8(%ebp),%eax
  8032d5:	89 c2                	mov    %eax,%edx
  8032d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032da:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  8032dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032e0:	a3 60 51 80 00       	mov    %eax,0x805160
				 return element1;
  8032e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032e8:	eb 31                	jmp    80331b <alloc_block_NF+0x1fd>
			 }
		 c++;
  8032ea:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  8032ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f0:	8b 00                	mov    (%eax),%eax
  8032f2:	85 c0                	test   %eax,%eax
  8032f4:	75 0a                	jne    803300 <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  8032f6:	a1 38 51 80 00       	mov    0x805138,%eax
  8032fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8032fe:	eb 08                	jmp    803308 <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  803300:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803303:	8b 00                	mov    (%eax),%eax
  803305:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  803308:	a1 44 51 80 00       	mov    0x805144,%eax
  80330d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  803310:	0f 85 3f fe ff ff    	jne    803155 <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  803316:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80331b:	c9                   	leave  
  80331c:	c3                   	ret    

0080331d <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80331d:	55                   	push   %ebp
  80331e:	89 e5                	mov    %esp,%ebp
  803320:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  803323:	a1 44 51 80 00       	mov    0x805144,%eax
  803328:	85 c0                	test   %eax,%eax
  80332a:	75 68                	jne    803394 <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  80332c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803330:	75 17                	jne    803349 <insert_sorted_with_merge_freeList+0x2c>
  803332:	83 ec 04             	sub    $0x4,%esp
  803335:	68 10 48 80 00       	push   $0x804810
  80333a:	68 0e 01 00 00       	push   $0x10e
  80333f:	68 33 48 80 00       	push   $0x804833
  803344:	e8 3e d9 ff ff       	call   800c87 <_panic>
  803349:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80334f:	8b 45 08             	mov    0x8(%ebp),%eax
  803352:	89 10                	mov    %edx,(%eax)
  803354:	8b 45 08             	mov    0x8(%ebp),%eax
  803357:	8b 00                	mov    (%eax),%eax
  803359:	85 c0                	test   %eax,%eax
  80335b:	74 0d                	je     80336a <insert_sorted_with_merge_freeList+0x4d>
  80335d:	a1 38 51 80 00       	mov    0x805138,%eax
  803362:	8b 55 08             	mov    0x8(%ebp),%edx
  803365:	89 50 04             	mov    %edx,0x4(%eax)
  803368:	eb 08                	jmp    803372 <insert_sorted_with_merge_freeList+0x55>
  80336a:	8b 45 08             	mov    0x8(%ebp),%eax
  80336d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803372:	8b 45 08             	mov    0x8(%ebp),%eax
  803375:	a3 38 51 80 00       	mov    %eax,0x805138
  80337a:	8b 45 08             	mov    0x8(%ebp),%eax
  80337d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803384:	a1 44 51 80 00       	mov    0x805144,%eax
  803389:	40                   	inc    %eax
  80338a:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  80338f:	e9 8c 06 00 00       	jmp    803a20 <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  803394:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803399:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  80339c:	a1 38 51 80 00       	mov    0x805138,%eax
  8033a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  8033a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a7:	8b 50 08             	mov    0x8(%eax),%edx
  8033aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033ad:	8b 40 08             	mov    0x8(%eax),%eax
  8033b0:	39 c2                	cmp    %eax,%edx
  8033b2:	0f 86 14 01 00 00    	jbe    8034cc <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  8033b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033bb:	8b 50 0c             	mov    0xc(%eax),%edx
  8033be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033c1:	8b 40 08             	mov    0x8(%eax),%eax
  8033c4:	01 c2                	add    %eax,%edx
  8033c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c9:	8b 40 08             	mov    0x8(%eax),%eax
  8033cc:	39 c2                	cmp    %eax,%edx
  8033ce:	0f 85 90 00 00 00    	jne    803464 <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  8033d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033d7:	8b 50 0c             	mov    0xc(%eax),%edx
  8033da:	8b 45 08             	mov    0x8(%ebp),%eax
  8033dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8033e0:	01 c2                	add    %eax,%edx
  8033e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033e5:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  8033e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033eb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  8033f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8033fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803400:	75 17                	jne    803419 <insert_sorted_with_merge_freeList+0xfc>
  803402:	83 ec 04             	sub    $0x4,%esp
  803405:	68 10 48 80 00       	push   $0x804810
  80340a:	68 1b 01 00 00       	push   $0x11b
  80340f:	68 33 48 80 00       	push   $0x804833
  803414:	e8 6e d8 ff ff       	call   800c87 <_panic>
  803419:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80341f:	8b 45 08             	mov    0x8(%ebp),%eax
  803422:	89 10                	mov    %edx,(%eax)
  803424:	8b 45 08             	mov    0x8(%ebp),%eax
  803427:	8b 00                	mov    (%eax),%eax
  803429:	85 c0                	test   %eax,%eax
  80342b:	74 0d                	je     80343a <insert_sorted_with_merge_freeList+0x11d>
  80342d:	a1 48 51 80 00       	mov    0x805148,%eax
  803432:	8b 55 08             	mov    0x8(%ebp),%edx
  803435:	89 50 04             	mov    %edx,0x4(%eax)
  803438:	eb 08                	jmp    803442 <insert_sorted_with_merge_freeList+0x125>
  80343a:	8b 45 08             	mov    0x8(%ebp),%eax
  80343d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803442:	8b 45 08             	mov    0x8(%ebp),%eax
  803445:	a3 48 51 80 00       	mov    %eax,0x805148
  80344a:	8b 45 08             	mov    0x8(%ebp),%eax
  80344d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803454:	a1 54 51 80 00       	mov    0x805154,%eax
  803459:	40                   	inc    %eax
  80345a:	a3 54 51 80 00       	mov    %eax,0x805154
							}

						}
		          }
		}
}
  80345f:	e9 bc 05 00 00       	jmp    803a20 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  803464:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803468:	75 17                	jne    803481 <insert_sorted_with_merge_freeList+0x164>
  80346a:	83 ec 04             	sub    $0x4,%esp
  80346d:	68 4c 48 80 00       	push   $0x80484c
  803472:	68 1f 01 00 00       	push   $0x11f
  803477:	68 33 48 80 00       	push   $0x804833
  80347c:	e8 06 d8 ff ff       	call   800c87 <_panic>
  803481:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803487:	8b 45 08             	mov    0x8(%ebp),%eax
  80348a:	89 50 04             	mov    %edx,0x4(%eax)
  80348d:	8b 45 08             	mov    0x8(%ebp),%eax
  803490:	8b 40 04             	mov    0x4(%eax),%eax
  803493:	85 c0                	test   %eax,%eax
  803495:	74 0c                	je     8034a3 <insert_sorted_with_merge_freeList+0x186>
  803497:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80349c:	8b 55 08             	mov    0x8(%ebp),%edx
  80349f:	89 10                	mov    %edx,(%eax)
  8034a1:	eb 08                	jmp    8034ab <insert_sorted_with_merge_freeList+0x18e>
  8034a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a6:	a3 38 51 80 00       	mov    %eax,0x805138
  8034ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ae:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034bc:	a1 44 51 80 00       	mov    0x805144,%eax
  8034c1:	40                   	inc    %eax
  8034c2:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  8034c7:	e9 54 05 00 00       	jmp    803a20 <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  8034cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8034cf:	8b 50 08             	mov    0x8(%eax),%edx
  8034d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034d5:	8b 40 08             	mov    0x8(%eax),%eax
  8034d8:	39 c2                	cmp    %eax,%edx
  8034da:	0f 83 20 01 00 00    	jae    803600 <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  8034e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e3:	8b 50 0c             	mov    0xc(%eax),%edx
  8034e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e9:	8b 40 08             	mov    0x8(%eax),%eax
  8034ec:	01 c2                	add    %eax,%edx
  8034ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034f1:	8b 40 08             	mov    0x8(%eax),%eax
  8034f4:	39 c2                	cmp    %eax,%edx
  8034f6:	0f 85 9c 00 00 00    	jne    803598 <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  8034fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ff:	8b 50 08             	mov    0x8(%eax),%edx
  803502:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803505:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  803508:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80350b:	8b 50 0c             	mov    0xc(%eax),%edx
  80350e:	8b 45 08             	mov    0x8(%ebp),%eax
  803511:	8b 40 0c             	mov    0xc(%eax),%eax
  803514:	01 c2                	add    %eax,%edx
  803516:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803519:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  80351c:	8b 45 08             	mov    0x8(%ebp),%eax
  80351f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  803526:	8b 45 08             	mov    0x8(%ebp),%eax
  803529:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803530:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803534:	75 17                	jne    80354d <insert_sorted_with_merge_freeList+0x230>
  803536:	83 ec 04             	sub    $0x4,%esp
  803539:	68 10 48 80 00       	push   $0x804810
  80353e:	68 2a 01 00 00       	push   $0x12a
  803543:	68 33 48 80 00       	push   $0x804833
  803548:	e8 3a d7 ff ff       	call   800c87 <_panic>
  80354d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803553:	8b 45 08             	mov    0x8(%ebp),%eax
  803556:	89 10                	mov    %edx,(%eax)
  803558:	8b 45 08             	mov    0x8(%ebp),%eax
  80355b:	8b 00                	mov    (%eax),%eax
  80355d:	85 c0                	test   %eax,%eax
  80355f:	74 0d                	je     80356e <insert_sorted_with_merge_freeList+0x251>
  803561:	a1 48 51 80 00       	mov    0x805148,%eax
  803566:	8b 55 08             	mov    0x8(%ebp),%edx
  803569:	89 50 04             	mov    %edx,0x4(%eax)
  80356c:	eb 08                	jmp    803576 <insert_sorted_with_merge_freeList+0x259>
  80356e:	8b 45 08             	mov    0x8(%ebp),%eax
  803571:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803576:	8b 45 08             	mov    0x8(%ebp),%eax
  803579:	a3 48 51 80 00       	mov    %eax,0x805148
  80357e:	8b 45 08             	mov    0x8(%ebp),%eax
  803581:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803588:	a1 54 51 80 00       	mov    0x805154,%eax
  80358d:	40                   	inc    %eax
  80358e:	a3 54 51 80 00       	mov    %eax,0x805154
							}

						}
		          }
		}
}
  803593:	e9 88 04 00 00       	jmp    803a20 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  803598:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80359c:	75 17                	jne    8035b5 <insert_sorted_with_merge_freeList+0x298>
  80359e:	83 ec 04             	sub    $0x4,%esp
  8035a1:	68 10 48 80 00       	push   $0x804810
  8035a6:	68 2e 01 00 00       	push   $0x12e
  8035ab:	68 33 48 80 00       	push   $0x804833
  8035b0:	e8 d2 d6 ff ff       	call   800c87 <_panic>
  8035b5:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8035bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8035be:	89 10                	mov    %edx,(%eax)
  8035c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c3:	8b 00                	mov    (%eax),%eax
  8035c5:	85 c0                	test   %eax,%eax
  8035c7:	74 0d                	je     8035d6 <insert_sorted_with_merge_freeList+0x2b9>
  8035c9:	a1 38 51 80 00       	mov    0x805138,%eax
  8035ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8035d1:	89 50 04             	mov    %edx,0x4(%eax)
  8035d4:	eb 08                	jmp    8035de <insert_sorted_with_merge_freeList+0x2c1>
  8035d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035de:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e1:	a3 38 51 80 00       	mov    %eax,0x805138
  8035e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035f0:	a1 44 51 80 00       	mov    0x805144,%eax
  8035f5:	40                   	inc    %eax
  8035f6:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  8035fb:	e9 20 04 00 00       	jmp    803a20 <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  803600:	a1 38 51 80 00       	mov    0x805138,%eax
  803605:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803608:	e9 e2 03 00 00       	jmp    8039ef <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  80360d:	8b 45 08             	mov    0x8(%ebp),%eax
  803610:	8b 50 08             	mov    0x8(%eax),%edx
  803613:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803616:	8b 40 08             	mov    0x8(%eax),%eax
  803619:	39 c2                	cmp    %eax,%edx
  80361b:	0f 83 c6 03 00 00    	jae    8039e7 <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  803621:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803624:	8b 40 04             	mov    0x4(%eax),%eax
  803627:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  80362a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80362d:	8b 50 08             	mov    0x8(%eax),%edx
  803630:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803633:	8b 40 0c             	mov    0xc(%eax),%eax
  803636:	01 d0                	add    %edx,%eax
  803638:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  80363b:	8b 45 08             	mov    0x8(%ebp),%eax
  80363e:	8b 50 0c             	mov    0xc(%eax),%edx
  803641:	8b 45 08             	mov    0x8(%ebp),%eax
  803644:	8b 40 08             	mov    0x8(%eax),%eax
  803647:	01 d0                	add    %edx,%eax
  803649:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  80364c:	8b 45 08             	mov    0x8(%ebp),%eax
  80364f:	8b 40 08             	mov    0x8(%eax),%eax
  803652:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803655:	74 7a                	je     8036d1 <insert_sorted_with_merge_freeList+0x3b4>
  803657:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80365a:	8b 40 08             	mov    0x8(%eax),%eax
  80365d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803660:	74 6f                	je     8036d1 <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  803662:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803666:	74 06                	je     80366e <insert_sorted_with_merge_freeList+0x351>
  803668:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80366c:	75 17                	jne    803685 <insert_sorted_with_merge_freeList+0x368>
  80366e:	83 ec 04             	sub    $0x4,%esp
  803671:	68 90 48 80 00       	push   $0x804890
  803676:	68 43 01 00 00       	push   $0x143
  80367b:	68 33 48 80 00       	push   $0x804833
  803680:	e8 02 d6 ff ff       	call   800c87 <_panic>
  803685:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803688:	8b 50 04             	mov    0x4(%eax),%edx
  80368b:	8b 45 08             	mov    0x8(%ebp),%eax
  80368e:	89 50 04             	mov    %edx,0x4(%eax)
  803691:	8b 45 08             	mov    0x8(%ebp),%eax
  803694:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803697:	89 10                	mov    %edx,(%eax)
  803699:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80369c:	8b 40 04             	mov    0x4(%eax),%eax
  80369f:	85 c0                	test   %eax,%eax
  8036a1:	74 0d                	je     8036b0 <insert_sorted_with_merge_freeList+0x393>
  8036a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a6:	8b 40 04             	mov    0x4(%eax),%eax
  8036a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8036ac:	89 10                	mov    %edx,(%eax)
  8036ae:	eb 08                	jmp    8036b8 <insert_sorted_with_merge_freeList+0x39b>
  8036b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b3:	a3 38 51 80 00       	mov    %eax,0x805138
  8036b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8036be:	89 50 04             	mov    %edx,0x4(%eax)
  8036c1:	a1 44 51 80 00       	mov    0x805144,%eax
  8036c6:	40                   	inc    %eax
  8036c7:	a3 44 51 80 00       	mov    %eax,0x805144
  8036cc:	e9 14 03 00 00       	jmp    8039e5 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  8036d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d4:	8b 40 08             	mov    0x8(%eax),%eax
  8036d7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8036da:	0f 85 a0 01 00 00    	jne    803880 <insert_sorted_with_merge_freeList+0x563>
  8036e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e3:	8b 40 08             	mov    0x8(%eax),%eax
  8036e6:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8036e9:	0f 85 91 01 00 00    	jne    803880 <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  8036ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036f2:	8b 50 0c             	mov    0xc(%eax),%edx
  8036f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f8:	8b 48 0c             	mov    0xc(%eax),%ecx
  8036fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036fe:	8b 40 0c             	mov    0xc(%eax),%eax
  803701:	01 c8                	add    %ecx,%eax
  803703:	01 c2                	add    %eax,%edx
  803705:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803708:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  80370b:	8b 45 08             	mov    0x8(%ebp),%eax
  80370e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  803715:	8b 45 08             	mov    0x8(%ebp),%eax
  803718:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  80371f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803722:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  803729:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80372c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803733:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803737:	75 17                	jne    803750 <insert_sorted_with_merge_freeList+0x433>
  803739:	83 ec 04             	sub    $0x4,%esp
  80373c:	68 10 48 80 00       	push   $0x804810
  803741:	68 4d 01 00 00       	push   $0x14d
  803746:	68 33 48 80 00       	push   $0x804833
  80374b:	e8 37 d5 ff ff       	call   800c87 <_panic>
  803750:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803756:	8b 45 08             	mov    0x8(%ebp),%eax
  803759:	89 10                	mov    %edx,(%eax)
  80375b:	8b 45 08             	mov    0x8(%ebp),%eax
  80375e:	8b 00                	mov    (%eax),%eax
  803760:	85 c0                	test   %eax,%eax
  803762:	74 0d                	je     803771 <insert_sorted_with_merge_freeList+0x454>
  803764:	a1 48 51 80 00       	mov    0x805148,%eax
  803769:	8b 55 08             	mov    0x8(%ebp),%edx
  80376c:	89 50 04             	mov    %edx,0x4(%eax)
  80376f:	eb 08                	jmp    803779 <insert_sorted_with_merge_freeList+0x45c>
  803771:	8b 45 08             	mov    0x8(%ebp),%eax
  803774:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803779:	8b 45 08             	mov    0x8(%ebp),%eax
  80377c:	a3 48 51 80 00       	mov    %eax,0x805148
  803781:	8b 45 08             	mov    0x8(%ebp),%eax
  803784:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80378b:	a1 54 51 80 00       	mov    0x805154,%eax
  803790:	40                   	inc    %eax
  803791:	a3 54 51 80 00       	mov    %eax,0x805154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  803796:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80379a:	75 17                	jne    8037b3 <insert_sorted_with_merge_freeList+0x496>
  80379c:	83 ec 04             	sub    $0x4,%esp
  80379f:	68 6f 48 80 00       	push   $0x80486f
  8037a4:	68 4e 01 00 00       	push   $0x14e
  8037a9:	68 33 48 80 00       	push   $0x804833
  8037ae:	e8 d4 d4 ff ff       	call   800c87 <_panic>
  8037b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b6:	8b 00                	mov    (%eax),%eax
  8037b8:	85 c0                	test   %eax,%eax
  8037ba:	74 10                	je     8037cc <insert_sorted_with_merge_freeList+0x4af>
  8037bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037bf:	8b 00                	mov    (%eax),%eax
  8037c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037c4:	8b 52 04             	mov    0x4(%edx),%edx
  8037c7:	89 50 04             	mov    %edx,0x4(%eax)
  8037ca:	eb 0b                	jmp    8037d7 <insert_sorted_with_merge_freeList+0x4ba>
  8037cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037cf:	8b 40 04             	mov    0x4(%eax),%eax
  8037d2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8037d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037da:	8b 40 04             	mov    0x4(%eax),%eax
  8037dd:	85 c0                	test   %eax,%eax
  8037df:	74 0f                	je     8037f0 <insert_sorted_with_merge_freeList+0x4d3>
  8037e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037e4:	8b 40 04             	mov    0x4(%eax),%eax
  8037e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8037ea:	8b 12                	mov    (%edx),%edx
  8037ec:	89 10                	mov    %edx,(%eax)
  8037ee:	eb 0a                	jmp    8037fa <insert_sorted_with_merge_freeList+0x4dd>
  8037f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037f3:	8b 00                	mov    (%eax),%eax
  8037f5:	a3 38 51 80 00       	mov    %eax,0x805138
  8037fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803803:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803806:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80380d:	a1 44 51 80 00       	mov    0x805144,%eax
  803812:	48                   	dec    %eax
  803813:	a3 44 51 80 00       	mov    %eax,0x805144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  803818:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80381c:	75 17                	jne    803835 <insert_sorted_with_merge_freeList+0x518>
  80381e:	83 ec 04             	sub    $0x4,%esp
  803821:	68 10 48 80 00       	push   $0x804810
  803826:	68 4f 01 00 00       	push   $0x14f
  80382b:	68 33 48 80 00       	push   $0x804833
  803830:	e8 52 d4 ff ff       	call   800c87 <_panic>
  803835:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80383b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80383e:	89 10                	mov    %edx,(%eax)
  803840:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803843:	8b 00                	mov    (%eax),%eax
  803845:	85 c0                	test   %eax,%eax
  803847:	74 0d                	je     803856 <insert_sorted_with_merge_freeList+0x539>
  803849:	a1 48 51 80 00       	mov    0x805148,%eax
  80384e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803851:	89 50 04             	mov    %edx,0x4(%eax)
  803854:	eb 08                	jmp    80385e <insert_sorted_with_merge_freeList+0x541>
  803856:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803859:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80385e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803861:	a3 48 51 80 00       	mov    %eax,0x805148
  803866:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803869:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803870:	a1 54 51 80 00       	mov    0x805154,%eax
  803875:	40                   	inc    %eax
  803876:	a3 54 51 80 00       	mov    %eax,0x805154
  80387b:	e9 65 01 00 00       	jmp    8039e5 <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  803880:	8b 45 08             	mov    0x8(%ebp),%eax
  803883:	8b 40 08             	mov    0x8(%eax),%eax
  803886:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803889:	0f 85 9f 00 00 00    	jne    80392e <insert_sorted_with_merge_freeList+0x611>
  80388f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803892:	8b 40 08             	mov    0x8(%eax),%eax
  803895:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803898:	0f 84 90 00 00 00    	je     80392e <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  80389e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038a1:	8b 50 0c             	mov    0xc(%eax),%edx
  8038a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8038aa:	01 c2                	add    %eax,%edx
  8038ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8038af:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  8038b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  8038bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8038bf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8038c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8038ca:	75 17                	jne    8038e3 <insert_sorted_with_merge_freeList+0x5c6>
  8038cc:	83 ec 04             	sub    $0x4,%esp
  8038cf:	68 10 48 80 00       	push   $0x804810
  8038d4:	68 58 01 00 00       	push   $0x158
  8038d9:	68 33 48 80 00       	push   $0x804833
  8038de:	e8 a4 d3 ff ff       	call   800c87 <_panic>
  8038e3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8038e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ec:	89 10                	mov    %edx,(%eax)
  8038ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8038f1:	8b 00                	mov    (%eax),%eax
  8038f3:	85 c0                	test   %eax,%eax
  8038f5:	74 0d                	je     803904 <insert_sorted_with_merge_freeList+0x5e7>
  8038f7:	a1 48 51 80 00       	mov    0x805148,%eax
  8038fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8038ff:	89 50 04             	mov    %edx,0x4(%eax)
  803902:	eb 08                	jmp    80390c <insert_sorted_with_merge_freeList+0x5ef>
  803904:	8b 45 08             	mov    0x8(%ebp),%eax
  803907:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80390c:	8b 45 08             	mov    0x8(%ebp),%eax
  80390f:	a3 48 51 80 00       	mov    %eax,0x805148
  803914:	8b 45 08             	mov    0x8(%ebp),%eax
  803917:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80391e:	a1 54 51 80 00       	mov    0x805154,%eax
  803923:	40                   	inc    %eax
  803924:	a3 54 51 80 00       	mov    %eax,0x805154
  803929:	e9 b7 00 00 00       	jmp    8039e5 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  80392e:	8b 45 08             	mov    0x8(%ebp),%eax
  803931:	8b 40 08             	mov    0x8(%eax),%eax
  803934:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803937:	0f 84 e2 00 00 00    	je     803a1f <insert_sorted_with_merge_freeList+0x702>
  80393d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803940:	8b 40 08             	mov    0x8(%eax),%eax
  803943:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803946:	0f 85 d3 00 00 00    	jne    803a1f <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  80394c:	8b 45 08             	mov    0x8(%ebp),%eax
  80394f:	8b 50 08             	mov    0x8(%eax),%edx
  803952:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803955:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  803958:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80395b:	8b 50 0c             	mov    0xc(%eax),%edx
  80395e:	8b 45 08             	mov    0x8(%ebp),%eax
  803961:	8b 40 0c             	mov    0xc(%eax),%eax
  803964:	01 c2                	add    %eax,%edx
  803966:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803969:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  80396c:	8b 45 08             	mov    0x8(%ebp),%eax
  80396f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  803976:	8b 45 08             	mov    0x8(%ebp),%eax
  803979:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803980:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803984:	75 17                	jne    80399d <insert_sorted_with_merge_freeList+0x680>
  803986:	83 ec 04             	sub    $0x4,%esp
  803989:	68 10 48 80 00       	push   $0x804810
  80398e:	68 61 01 00 00       	push   $0x161
  803993:	68 33 48 80 00       	push   $0x804833
  803998:	e8 ea d2 ff ff       	call   800c87 <_panic>
  80399d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8039a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8039a6:	89 10                	mov    %edx,(%eax)
  8039a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ab:	8b 00                	mov    (%eax),%eax
  8039ad:	85 c0                	test   %eax,%eax
  8039af:	74 0d                	je     8039be <insert_sorted_with_merge_freeList+0x6a1>
  8039b1:	a1 48 51 80 00       	mov    0x805148,%eax
  8039b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8039b9:	89 50 04             	mov    %edx,0x4(%eax)
  8039bc:	eb 08                	jmp    8039c6 <insert_sorted_with_merge_freeList+0x6a9>
  8039be:	8b 45 08             	mov    0x8(%ebp),%eax
  8039c1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8039c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8039c9:	a3 48 51 80 00       	mov    %eax,0x805148
  8039ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8039d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039d8:	a1 54 51 80 00       	mov    0x805154,%eax
  8039dd:	40                   	inc    %eax
  8039de:	a3 54 51 80 00       	mov    %eax,0x805154
								}
								break;
  8039e3:	eb 3a                	jmp    803a1f <insert_sorted_with_merge_freeList+0x702>
  8039e5:	eb 38                	jmp    803a1f <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  8039e7:	a1 40 51 80 00       	mov    0x805140,%eax
  8039ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8039ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039f3:	74 07                	je     8039fc <insert_sorted_with_merge_freeList+0x6df>
  8039f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039f8:	8b 00                	mov    (%eax),%eax
  8039fa:	eb 05                	jmp    803a01 <insert_sorted_with_merge_freeList+0x6e4>
  8039fc:	b8 00 00 00 00       	mov    $0x0,%eax
  803a01:	a3 40 51 80 00       	mov    %eax,0x805140
  803a06:	a1 40 51 80 00       	mov    0x805140,%eax
  803a0b:	85 c0                	test   %eax,%eax
  803a0d:	0f 85 fa fb ff ff    	jne    80360d <insert_sorted_with_merge_freeList+0x2f0>
  803a13:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a17:	0f 85 f0 fb ff ff    	jne    80360d <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  803a1d:	eb 01                	jmp    803a20 <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  803a1f:	90                   	nop
							}

						}
		          }
		}
}
  803a20:	90                   	nop
  803a21:	c9                   	leave  
  803a22:	c3                   	ret    

00803a23 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803a23:	55                   	push   %ebp
  803a24:	89 e5                	mov    %esp,%ebp
  803a26:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803a29:	8b 55 08             	mov    0x8(%ebp),%edx
  803a2c:	89 d0                	mov    %edx,%eax
  803a2e:	c1 e0 02             	shl    $0x2,%eax
  803a31:	01 d0                	add    %edx,%eax
  803a33:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803a3a:	01 d0                	add    %edx,%eax
  803a3c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803a43:	01 d0                	add    %edx,%eax
  803a45:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803a4c:	01 d0                	add    %edx,%eax
  803a4e:	c1 e0 04             	shl    $0x4,%eax
  803a51:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803a54:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803a5b:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803a5e:	83 ec 0c             	sub    $0xc,%esp
  803a61:	50                   	push   %eax
  803a62:	e8 9c eb ff ff       	call   802603 <sys_get_virtual_time>
  803a67:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803a6a:	eb 41                	jmp    803aad <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803a6c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803a6f:	83 ec 0c             	sub    $0xc,%esp
  803a72:	50                   	push   %eax
  803a73:	e8 8b eb ff ff       	call   802603 <sys_get_virtual_time>
  803a78:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803a7b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803a7e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a81:	29 c2                	sub    %eax,%edx
  803a83:	89 d0                	mov    %edx,%eax
  803a85:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803a88:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803a8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a8e:	89 d1                	mov    %edx,%ecx
  803a90:	29 c1                	sub    %eax,%ecx
  803a92:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803a95:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803a98:	39 c2                	cmp    %eax,%edx
  803a9a:	0f 97 c0             	seta   %al
  803a9d:	0f b6 c0             	movzbl %al,%eax
  803aa0:	29 c1                	sub    %eax,%ecx
  803aa2:	89 c8                	mov    %ecx,%eax
  803aa4:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803aa7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803aaa:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ab0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803ab3:	72 b7                	jb     803a6c <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803ab5:	90                   	nop
  803ab6:	c9                   	leave  
  803ab7:	c3                   	ret    

00803ab8 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803ab8:	55                   	push   %ebp
  803ab9:	89 e5                	mov    %esp,%ebp
  803abb:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803abe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803ac5:	eb 03                	jmp    803aca <busy_wait+0x12>
  803ac7:	ff 45 fc             	incl   -0x4(%ebp)
  803aca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803acd:	3b 45 08             	cmp    0x8(%ebp),%eax
  803ad0:	72 f5                	jb     803ac7 <busy_wait+0xf>
	return i;
  803ad2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803ad5:	c9                   	leave  
  803ad6:	c3                   	ret    
  803ad7:	90                   	nop

00803ad8 <__udivdi3>:
  803ad8:	55                   	push   %ebp
  803ad9:	57                   	push   %edi
  803ada:	56                   	push   %esi
  803adb:	53                   	push   %ebx
  803adc:	83 ec 1c             	sub    $0x1c,%esp
  803adf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803ae3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803ae7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803aeb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803aef:	89 ca                	mov    %ecx,%edx
  803af1:	89 f8                	mov    %edi,%eax
  803af3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803af7:	85 f6                	test   %esi,%esi
  803af9:	75 2d                	jne    803b28 <__udivdi3+0x50>
  803afb:	39 cf                	cmp    %ecx,%edi
  803afd:	77 65                	ja     803b64 <__udivdi3+0x8c>
  803aff:	89 fd                	mov    %edi,%ebp
  803b01:	85 ff                	test   %edi,%edi
  803b03:	75 0b                	jne    803b10 <__udivdi3+0x38>
  803b05:	b8 01 00 00 00       	mov    $0x1,%eax
  803b0a:	31 d2                	xor    %edx,%edx
  803b0c:	f7 f7                	div    %edi
  803b0e:	89 c5                	mov    %eax,%ebp
  803b10:	31 d2                	xor    %edx,%edx
  803b12:	89 c8                	mov    %ecx,%eax
  803b14:	f7 f5                	div    %ebp
  803b16:	89 c1                	mov    %eax,%ecx
  803b18:	89 d8                	mov    %ebx,%eax
  803b1a:	f7 f5                	div    %ebp
  803b1c:	89 cf                	mov    %ecx,%edi
  803b1e:	89 fa                	mov    %edi,%edx
  803b20:	83 c4 1c             	add    $0x1c,%esp
  803b23:	5b                   	pop    %ebx
  803b24:	5e                   	pop    %esi
  803b25:	5f                   	pop    %edi
  803b26:	5d                   	pop    %ebp
  803b27:	c3                   	ret    
  803b28:	39 ce                	cmp    %ecx,%esi
  803b2a:	77 28                	ja     803b54 <__udivdi3+0x7c>
  803b2c:	0f bd fe             	bsr    %esi,%edi
  803b2f:	83 f7 1f             	xor    $0x1f,%edi
  803b32:	75 40                	jne    803b74 <__udivdi3+0x9c>
  803b34:	39 ce                	cmp    %ecx,%esi
  803b36:	72 0a                	jb     803b42 <__udivdi3+0x6a>
  803b38:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803b3c:	0f 87 9e 00 00 00    	ja     803be0 <__udivdi3+0x108>
  803b42:	b8 01 00 00 00       	mov    $0x1,%eax
  803b47:	89 fa                	mov    %edi,%edx
  803b49:	83 c4 1c             	add    $0x1c,%esp
  803b4c:	5b                   	pop    %ebx
  803b4d:	5e                   	pop    %esi
  803b4e:	5f                   	pop    %edi
  803b4f:	5d                   	pop    %ebp
  803b50:	c3                   	ret    
  803b51:	8d 76 00             	lea    0x0(%esi),%esi
  803b54:	31 ff                	xor    %edi,%edi
  803b56:	31 c0                	xor    %eax,%eax
  803b58:	89 fa                	mov    %edi,%edx
  803b5a:	83 c4 1c             	add    $0x1c,%esp
  803b5d:	5b                   	pop    %ebx
  803b5e:	5e                   	pop    %esi
  803b5f:	5f                   	pop    %edi
  803b60:	5d                   	pop    %ebp
  803b61:	c3                   	ret    
  803b62:	66 90                	xchg   %ax,%ax
  803b64:	89 d8                	mov    %ebx,%eax
  803b66:	f7 f7                	div    %edi
  803b68:	31 ff                	xor    %edi,%edi
  803b6a:	89 fa                	mov    %edi,%edx
  803b6c:	83 c4 1c             	add    $0x1c,%esp
  803b6f:	5b                   	pop    %ebx
  803b70:	5e                   	pop    %esi
  803b71:	5f                   	pop    %edi
  803b72:	5d                   	pop    %ebp
  803b73:	c3                   	ret    
  803b74:	bd 20 00 00 00       	mov    $0x20,%ebp
  803b79:	89 eb                	mov    %ebp,%ebx
  803b7b:	29 fb                	sub    %edi,%ebx
  803b7d:	89 f9                	mov    %edi,%ecx
  803b7f:	d3 e6                	shl    %cl,%esi
  803b81:	89 c5                	mov    %eax,%ebp
  803b83:	88 d9                	mov    %bl,%cl
  803b85:	d3 ed                	shr    %cl,%ebp
  803b87:	89 e9                	mov    %ebp,%ecx
  803b89:	09 f1                	or     %esi,%ecx
  803b8b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803b8f:	89 f9                	mov    %edi,%ecx
  803b91:	d3 e0                	shl    %cl,%eax
  803b93:	89 c5                	mov    %eax,%ebp
  803b95:	89 d6                	mov    %edx,%esi
  803b97:	88 d9                	mov    %bl,%cl
  803b99:	d3 ee                	shr    %cl,%esi
  803b9b:	89 f9                	mov    %edi,%ecx
  803b9d:	d3 e2                	shl    %cl,%edx
  803b9f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ba3:	88 d9                	mov    %bl,%cl
  803ba5:	d3 e8                	shr    %cl,%eax
  803ba7:	09 c2                	or     %eax,%edx
  803ba9:	89 d0                	mov    %edx,%eax
  803bab:	89 f2                	mov    %esi,%edx
  803bad:	f7 74 24 0c          	divl   0xc(%esp)
  803bb1:	89 d6                	mov    %edx,%esi
  803bb3:	89 c3                	mov    %eax,%ebx
  803bb5:	f7 e5                	mul    %ebp
  803bb7:	39 d6                	cmp    %edx,%esi
  803bb9:	72 19                	jb     803bd4 <__udivdi3+0xfc>
  803bbb:	74 0b                	je     803bc8 <__udivdi3+0xf0>
  803bbd:	89 d8                	mov    %ebx,%eax
  803bbf:	31 ff                	xor    %edi,%edi
  803bc1:	e9 58 ff ff ff       	jmp    803b1e <__udivdi3+0x46>
  803bc6:	66 90                	xchg   %ax,%ax
  803bc8:	8b 54 24 08          	mov    0x8(%esp),%edx
  803bcc:	89 f9                	mov    %edi,%ecx
  803bce:	d3 e2                	shl    %cl,%edx
  803bd0:	39 c2                	cmp    %eax,%edx
  803bd2:	73 e9                	jae    803bbd <__udivdi3+0xe5>
  803bd4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803bd7:	31 ff                	xor    %edi,%edi
  803bd9:	e9 40 ff ff ff       	jmp    803b1e <__udivdi3+0x46>
  803bde:	66 90                	xchg   %ax,%ax
  803be0:	31 c0                	xor    %eax,%eax
  803be2:	e9 37 ff ff ff       	jmp    803b1e <__udivdi3+0x46>
  803be7:	90                   	nop

00803be8 <__umoddi3>:
  803be8:	55                   	push   %ebp
  803be9:	57                   	push   %edi
  803bea:	56                   	push   %esi
  803beb:	53                   	push   %ebx
  803bec:	83 ec 1c             	sub    $0x1c,%esp
  803bef:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803bf3:	8b 74 24 34          	mov    0x34(%esp),%esi
  803bf7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803bfb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803bff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c03:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c07:	89 f3                	mov    %esi,%ebx
  803c09:	89 fa                	mov    %edi,%edx
  803c0b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c0f:	89 34 24             	mov    %esi,(%esp)
  803c12:	85 c0                	test   %eax,%eax
  803c14:	75 1a                	jne    803c30 <__umoddi3+0x48>
  803c16:	39 f7                	cmp    %esi,%edi
  803c18:	0f 86 a2 00 00 00    	jbe    803cc0 <__umoddi3+0xd8>
  803c1e:	89 c8                	mov    %ecx,%eax
  803c20:	89 f2                	mov    %esi,%edx
  803c22:	f7 f7                	div    %edi
  803c24:	89 d0                	mov    %edx,%eax
  803c26:	31 d2                	xor    %edx,%edx
  803c28:	83 c4 1c             	add    $0x1c,%esp
  803c2b:	5b                   	pop    %ebx
  803c2c:	5e                   	pop    %esi
  803c2d:	5f                   	pop    %edi
  803c2e:	5d                   	pop    %ebp
  803c2f:	c3                   	ret    
  803c30:	39 f0                	cmp    %esi,%eax
  803c32:	0f 87 ac 00 00 00    	ja     803ce4 <__umoddi3+0xfc>
  803c38:	0f bd e8             	bsr    %eax,%ebp
  803c3b:	83 f5 1f             	xor    $0x1f,%ebp
  803c3e:	0f 84 ac 00 00 00    	je     803cf0 <__umoddi3+0x108>
  803c44:	bf 20 00 00 00       	mov    $0x20,%edi
  803c49:	29 ef                	sub    %ebp,%edi
  803c4b:	89 fe                	mov    %edi,%esi
  803c4d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803c51:	89 e9                	mov    %ebp,%ecx
  803c53:	d3 e0                	shl    %cl,%eax
  803c55:	89 d7                	mov    %edx,%edi
  803c57:	89 f1                	mov    %esi,%ecx
  803c59:	d3 ef                	shr    %cl,%edi
  803c5b:	09 c7                	or     %eax,%edi
  803c5d:	89 e9                	mov    %ebp,%ecx
  803c5f:	d3 e2                	shl    %cl,%edx
  803c61:	89 14 24             	mov    %edx,(%esp)
  803c64:	89 d8                	mov    %ebx,%eax
  803c66:	d3 e0                	shl    %cl,%eax
  803c68:	89 c2                	mov    %eax,%edx
  803c6a:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c6e:	d3 e0                	shl    %cl,%eax
  803c70:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c74:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c78:	89 f1                	mov    %esi,%ecx
  803c7a:	d3 e8                	shr    %cl,%eax
  803c7c:	09 d0                	or     %edx,%eax
  803c7e:	d3 eb                	shr    %cl,%ebx
  803c80:	89 da                	mov    %ebx,%edx
  803c82:	f7 f7                	div    %edi
  803c84:	89 d3                	mov    %edx,%ebx
  803c86:	f7 24 24             	mull   (%esp)
  803c89:	89 c6                	mov    %eax,%esi
  803c8b:	89 d1                	mov    %edx,%ecx
  803c8d:	39 d3                	cmp    %edx,%ebx
  803c8f:	0f 82 87 00 00 00    	jb     803d1c <__umoddi3+0x134>
  803c95:	0f 84 91 00 00 00    	je     803d2c <__umoddi3+0x144>
  803c9b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803c9f:	29 f2                	sub    %esi,%edx
  803ca1:	19 cb                	sbb    %ecx,%ebx
  803ca3:	89 d8                	mov    %ebx,%eax
  803ca5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803ca9:	d3 e0                	shl    %cl,%eax
  803cab:	89 e9                	mov    %ebp,%ecx
  803cad:	d3 ea                	shr    %cl,%edx
  803caf:	09 d0                	or     %edx,%eax
  803cb1:	89 e9                	mov    %ebp,%ecx
  803cb3:	d3 eb                	shr    %cl,%ebx
  803cb5:	89 da                	mov    %ebx,%edx
  803cb7:	83 c4 1c             	add    $0x1c,%esp
  803cba:	5b                   	pop    %ebx
  803cbb:	5e                   	pop    %esi
  803cbc:	5f                   	pop    %edi
  803cbd:	5d                   	pop    %ebp
  803cbe:	c3                   	ret    
  803cbf:	90                   	nop
  803cc0:	89 fd                	mov    %edi,%ebp
  803cc2:	85 ff                	test   %edi,%edi
  803cc4:	75 0b                	jne    803cd1 <__umoddi3+0xe9>
  803cc6:	b8 01 00 00 00       	mov    $0x1,%eax
  803ccb:	31 d2                	xor    %edx,%edx
  803ccd:	f7 f7                	div    %edi
  803ccf:	89 c5                	mov    %eax,%ebp
  803cd1:	89 f0                	mov    %esi,%eax
  803cd3:	31 d2                	xor    %edx,%edx
  803cd5:	f7 f5                	div    %ebp
  803cd7:	89 c8                	mov    %ecx,%eax
  803cd9:	f7 f5                	div    %ebp
  803cdb:	89 d0                	mov    %edx,%eax
  803cdd:	e9 44 ff ff ff       	jmp    803c26 <__umoddi3+0x3e>
  803ce2:	66 90                	xchg   %ax,%ax
  803ce4:	89 c8                	mov    %ecx,%eax
  803ce6:	89 f2                	mov    %esi,%edx
  803ce8:	83 c4 1c             	add    $0x1c,%esp
  803ceb:	5b                   	pop    %ebx
  803cec:	5e                   	pop    %esi
  803ced:	5f                   	pop    %edi
  803cee:	5d                   	pop    %ebp
  803cef:	c3                   	ret    
  803cf0:	3b 04 24             	cmp    (%esp),%eax
  803cf3:	72 06                	jb     803cfb <__umoddi3+0x113>
  803cf5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803cf9:	77 0f                	ja     803d0a <__umoddi3+0x122>
  803cfb:	89 f2                	mov    %esi,%edx
  803cfd:	29 f9                	sub    %edi,%ecx
  803cff:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d03:	89 14 24             	mov    %edx,(%esp)
  803d06:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d0a:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d0e:	8b 14 24             	mov    (%esp),%edx
  803d11:	83 c4 1c             	add    $0x1c,%esp
  803d14:	5b                   	pop    %ebx
  803d15:	5e                   	pop    %esi
  803d16:	5f                   	pop    %edi
  803d17:	5d                   	pop    %ebp
  803d18:	c3                   	ret    
  803d19:	8d 76 00             	lea    0x0(%esi),%esi
  803d1c:	2b 04 24             	sub    (%esp),%eax
  803d1f:	19 fa                	sbb    %edi,%edx
  803d21:	89 d1                	mov    %edx,%ecx
  803d23:	89 c6                	mov    %eax,%esi
  803d25:	e9 71 ff ff ff       	jmp    803c9b <__umoddi3+0xb3>
  803d2a:	66 90                	xchg   %ax,%ax
  803d2c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803d30:	72 ea                	jb     803d1c <__umoddi3+0x134>
  803d32:	89 d9                	mov    %ebx,%ecx
  803d34:	e9 62 ff ff ff       	jmp    803c9b <__umoddi3+0xb3>

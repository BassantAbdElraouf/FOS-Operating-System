
obj/user/tst_air_clerk:     file format elf32-i386


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
  800031:	e8 e7 05 00 00       	call   80061d <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>
#include <user/air.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 9c 01 00 00    	sub    $0x19c,%esp
	int parentenvID = sys_getparentenvid();
  800044:	e8 59 20 00 00       	call   8020a2 <sys_getparentenvid>
  800049:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// Get the shared variables from the main program ***********************************

	char _customers[] = "customers";
  80004c:	8d 45 ae             	lea    -0x52(%ebp),%eax
  80004f:	bb 95 37 80 00       	mov    $0x803795,%ebx
  800054:	ba 0a 00 00 00       	mov    $0xa,%edx
  800059:	89 c7                	mov    %eax,%edi
  80005b:	89 de                	mov    %ebx,%esi
  80005d:	89 d1                	mov    %edx,%ecx
  80005f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  800061:	8d 45 a2             	lea    -0x5e(%ebp),%eax
  800064:	bb 9f 37 80 00       	mov    $0x80379f,%ebx
  800069:	ba 03 00 00 00       	mov    $0x3,%edx
  80006e:	89 c7                	mov    %eax,%edi
  800070:	89 de                	mov    %ebx,%esi
  800072:	89 d1                	mov    %edx,%ecx
  800074:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  800076:	8d 45 93             	lea    -0x6d(%ebp),%eax
  800079:	bb ab 37 80 00       	mov    $0x8037ab,%ebx
  80007e:	ba 0f 00 00 00       	mov    $0xf,%edx
  800083:	89 c7                	mov    %eax,%edi
  800085:	89 de                	mov    %ebx,%esi
  800087:	89 d1                	mov    %edx,%ecx
  800089:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  80008b:	8d 45 84             	lea    -0x7c(%ebp),%eax
  80008e:	bb ba 37 80 00       	mov    $0x8037ba,%ebx
  800093:	ba 0f 00 00 00       	mov    $0xf,%edx
  800098:	89 c7                	mov    %eax,%edi
  80009a:	89 de                	mov    %ebx,%esi
  80009c:	89 d1                	mov    %edx,%ecx
  80009e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000a0:	8d 85 6f ff ff ff    	lea    -0x91(%ebp),%eax
  8000a6:	bb c9 37 80 00       	mov    $0x8037c9,%ebx
  8000ab:	ba 15 00 00 00       	mov    $0x15,%edx
  8000b0:	89 c7                	mov    %eax,%edi
  8000b2:	89 de                	mov    %ebx,%esi
  8000b4:	89 d1                	mov    %edx,%ecx
  8000b6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000b8:	8d 85 5a ff ff ff    	lea    -0xa6(%ebp),%eax
  8000be:	bb de 37 80 00       	mov    $0x8037de,%ebx
  8000c3:	ba 15 00 00 00       	mov    $0x15,%edx
  8000c8:	89 c7                	mov    %eax,%edi
  8000ca:	89 de                	mov    %ebx,%esi
  8000cc:	89 d1                	mov    %edx,%ecx
  8000ce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  8000d0:	8d 85 49 ff ff ff    	lea    -0xb7(%ebp),%eax
  8000d6:	bb f3 37 80 00       	mov    $0x8037f3,%ebx
  8000db:	ba 11 00 00 00       	mov    $0x11,%edx
  8000e0:	89 c7                	mov    %eax,%edi
  8000e2:	89 de                	mov    %ebx,%esi
  8000e4:	89 d1                	mov    %edx,%ecx
  8000e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  8000e8:	8d 85 38 ff ff ff    	lea    -0xc8(%ebp),%eax
  8000ee:	bb 04 38 80 00       	mov    $0x803804,%ebx
  8000f3:	ba 11 00 00 00       	mov    $0x11,%edx
  8000f8:	89 c7                	mov    %eax,%edi
  8000fa:	89 de                	mov    %ebx,%esi
  8000fc:	89 d1                	mov    %edx,%ecx
  8000fe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  800100:	8d 85 27 ff ff ff    	lea    -0xd9(%ebp),%eax
  800106:	bb 15 38 80 00       	mov    $0x803815,%ebx
  80010b:	ba 11 00 00 00       	mov    $0x11,%edx
  800110:	89 c7                	mov    %eax,%edi
  800112:	89 de                	mov    %ebx,%esi
  800114:	89 d1                	mov    %edx,%ecx
  800116:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  800118:	8d 85 1e ff ff ff    	lea    -0xe2(%ebp),%eax
  80011e:	bb 26 38 80 00       	mov    $0x803826,%ebx
  800123:	ba 09 00 00 00       	mov    $0x9,%edx
  800128:	89 c7                	mov    %eax,%edi
  80012a:	89 de                	mov    %ebx,%esi
  80012c:	89 d1                	mov    %edx,%ecx
  80012e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  800130:	8d 85 14 ff ff ff    	lea    -0xec(%ebp),%eax
  800136:	bb 2f 38 80 00       	mov    $0x80382f,%ebx
  80013b:	ba 0a 00 00 00       	mov    $0xa,%edx
  800140:	89 c7                	mov    %eax,%edi
  800142:	89 de                	mov    %ebx,%esi
  800144:	89 d1                	mov    %edx,%ecx
  800146:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  800148:	8d 85 09 ff ff ff    	lea    -0xf7(%ebp),%eax
  80014e:	bb 39 38 80 00       	mov    $0x803839,%ebx
  800153:	ba 0b 00 00 00       	mov    $0xb,%edx
  800158:	89 c7                	mov    %eax,%edi
  80015a:	89 de                	mov    %ebx,%esi
  80015c:	89 d1                	mov    %edx,%ecx
  80015e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  800160:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800166:	bb 44 38 80 00       	mov    $0x803844,%ebx
  80016b:	ba 03 00 00 00       	mov    $0x3,%edx
  800170:	89 c7                	mov    %eax,%edi
  800172:	89 de                	mov    %ebx,%esi
  800174:	89 d1                	mov    %edx,%ecx
  800176:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  800178:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  80017e:	bb 50 38 80 00       	mov    $0x803850,%ebx
  800183:	ba 0a 00 00 00       	mov    $0xa,%edx
  800188:	89 c7                	mov    %eax,%edi
  80018a:	89 de                	mov    %ebx,%esi
  80018c:	89 d1                	mov    %edx,%ecx
  80018e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  800190:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800196:	bb 5a 38 80 00       	mov    $0x80385a,%ebx
  80019b:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001a0:	89 c7                	mov    %eax,%edi
  8001a2:	89 de                	mov    %ebx,%esi
  8001a4:	89 d1                	mov    %edx,%ecx
  8001a6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _clerk[] = "clerk";
  8001a8:	c7 85 e3 fe ff ff 63 	movl   $0x72656c63,-0x11d(%ebp)
  8001af:	6c 65 72 
  8001b2:	66 c7 85 e7 fe ff ff 	movw   $0x6b,-0x119(%ebp)
  8001b9:	6b 00 
	char _custCounterCS[] = "custCounterCS";
  8001bb:	8d 85 d5 fe ff ff    	lea    -0x12b(%ebp),%eax
  8001c1:	bb 64 38 80 00       	mov    $0x803864,%ebx
  8001c6:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001cb:	89 c7                	mov    %eax,%edi
  8001cd:	89 de                	mov    %ebx,%esi
  8001cf:	89 d1                	mov    %edx,%ecx
  8001d1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  8001d3:	8d 85 c6 fe ff ff    	lea    -0x13a(%ebp),%eax
  8001d9:	bb 72 38 80 00       	mov    $0x803872,%ebx
  8001de:	ba 0f 00 00 00       	mov    $0xf,%edx
  8001e3:	89 c7                	mov    %eax,%edi
  8001e5:	89 de                	mov    %ebx,%esi
  8001e7:	89 d1                	mov    %edx,%ecx
  8001e9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  8001eb:	8d 85 bf fe ff ff    	lea    -0x141(%ebp),%eax
  8001f1:	bb 81 38 80 00       	mov    $0x803881,%ebx
  8001f6:	ba 07 00 00 00       	mov    $0x7,%edx
  8001fb:	89 c7                	mov    %eax,%edi
  8001fd:	89 de                	mov    %ebx,%esi
  8001ff:	89 d1                	mov    %edx,%ecx
  800201:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800203:	8d 85 b8 fe ff ff    	lea    -0x148(%ebp),%eax
  800209:	bb 88 38 80 00       	mov    $0x803888,%ebx
  80020e:	ba 07 00 00 00       	mov    $0x7,%edx
  800213:	89 c7                	mov    %eax,%edi
  800215:	89 de                	mov    %ebx,%esi
  800217:	89 d1                	mov    %edx,%ecx
  800219:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	struct Customer * customers = sget(parentenvID, _customers);
  80021b:	83 ec 08             	sub    $0x8,%esp
  80021e:	8d 45 ae             	lea    -0x52(%ebp),%eax
  800221:	50                   	push   %eax
  800222:	ff 75 e4             	pushl  -0x1c(%ebp)
  800225:	e8 38 19 00 00       	call   801b62 <sget>
  80022a:	83 c4 10             	add    $0x10,%esp
  80022d:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int* flight1Counter = sget(parentenvID, _flight1Counter);
  800230:	83 ec 08             	sub    $0x8,%esp
  800233:	8d 45 93             	lea    -0x6d(%ebp),%eax
  800236:	50                   	push   %eax
  800237:	ff 75 e4             	pushl  -0x1c(%ebp)
  80023a:	e8 23 19 00 00       	call   801b62 <sget>
  80023f:	83 c4 10             	add    $0x10,%esp
  800242:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int* flight2Counter = sget(parentenvID, _flight2Counter);
  800245:	83 ec 08             	sub    $0x8,%esp
  800248:	8d 45 84             	lea    -0x7c(%ebp),%eax
  80024b:	50                   	push   %eax
  80024c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024f:	e8 0e 19 00 00       	call   801b62 <sget>
  800254:	83 c4 10             	add    $0x10,%esp
  800257:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* flight1BookedCounter = sget(parentenvID, _flightBooked1Counter);
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	8d 85 6f ff ff ff    	lea    -0x91(%ebp),%eax
  800263:	50                   	push   %eax
  800264:	ff 75 e4             	pushl  -0x1c(%ebp)
  800267:	e8 f6 18 00 00       	call   801b62 <sget>
  80026c:	83 c4 10             	add    $0x10,%esp
  80026f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	int* flight2BookedCounter = sget(parentenvID, _flightBooked2Counter);
  800272:	83 ec 08             	sub    $0x8,%esp
  800275:	8d 85 5a ff ff ff    	lea    -0xa6(%ebp),%eax
  80027b:	50                   	push   %eax
  80027c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80027f:	e8 de 18 00 00       	call   801b62 <sget>
  800284:	83 c4 10             	add    $0x10,%esp
  800287:	89 45 d0             	mov    %eax,-0x30(%ebp)

	int* flight1BookedArr = sget(parentenvID, _flightBooked1Arr);
  80028a:	83 ec 08             	sub    $0x8,%esp
  80028d:	8d 85 49 ff ff ff    	lea    -0xb7(%ebp),%eax
  800293:	50                   	push   %eax
  800294:	ff 75 e4             	pushl  -0x1c(%ebp)
  800297:	e8 c6 18 00 00       	call   801b62 <sget>
  80029c:	83 c4 10             	add    $0x10,%esp
  80029f:	89 45 cc             	mov    %eax,-0x34(%ebp)
	int* flight2BookedArr = sget(parentenvID, _flightBooked2Arr);
  8002a2:	83 ec 08             	sub    $0x8,%esp
  8002a5:	8d 85 38 ff ff ff    	lea    -0xc8(%ebp),%eax
  8002ab:	50                   	push   %eax
  8002ac:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002af:	e8 ae 18 00 00       	call   801b62 <sget>
  8002b4:	83 c4 10             	add    $0x10,%esp
  8002b7:	89 45 c8             	mov    %eax,-0x38(%ebp)

	int* cust_ready_queue = sget(parentenvID, _cust_ready_queue);
  8002ba:	83 ec 08             	sub    $0x8,%esp
  8002bd:	8d 85 27 ff ff ff    	lea    -0xd9(%ebp),%eax
  8002c3:	50                   	push   %eax
  8002c4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c7:	e8 96 18 00 00       	call   801b62 <sget>
  8002cc:	83 c4 10             	add    $0x10,%esp
  8002cf:	89 45 c4             	mov    %eax,-0x3c(%ebp)

	int* queue_out = sget(parentenvID, _queue_out);
  8002d2:	83 ec 08             	sub    $0x8,%esp
  8002d5:	8d 85 14 ff ff ff    	lea    -0xec(%ebp),%eax
  8002db:	50                   	push   %eax
  8002dc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002df:	e8 7e 18 00 00       	call   801b62 <sget>
  8002e4:	83 c4 10             	add    $0x10,%esp
  8002e7:	89 45 c0             	mov    %eax,-0x40(%ebp)

	while(1==1)
	{
		int custId;
		//wait for a customer
		sys_waitSemaphore(parentenvID, _cust_ready);
  8002ea:	83 ec 08             	sub    $0x8,%esp
  8002ed:	8d 85 09 ff ff ff    	lea    -0xf7(%ebp),%eax
  8002f3:	50                   	push   %eax
  8002f4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002f7:	e8 47 1c 00 00       	call   801f43 <sys_waitSemaphore>
  8002fc:	83 c4 10             	add    $0x10,%esp

		//dequeue the customer info
		sys_waitSemaphore(parentenvID, _custQueueCS);
  8002ff:	83 ec 08             	sub    $0x8,%esp
  800302:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800308:	50                   	push   %eax
  800309:	ff 75 e4             	pushl  -0x1c(%ebp)
  80030c:	e8 32 1c 00 00       	call   801f43 <sys_waitSemaphore>
  800311:	83 c4 10             	add    $0x10,%esp
		{
			//cprintf("*queue_out = %d\n", *queue_out);
			custId = cust_ready_queue[*queue_out];
  800314:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800317:	8b 00                	mov    (%eax),%eax
  800319:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800320:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800323:	01 d0                	add    %edx,%eax
  800325:	8b 00                	mov    (%eax),%eax
  800327:	89 45 bc             	mov    %eax,-0x44(%ebp)
			*queue_out = *queue_out +1;
  80032a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80032d:	8b 00                	mov    (%eax),%eax
  80032f:	8d 50 01             	lea    0x1(%eax),%edx
  800332:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800335:	89 10                	mov    %edx,(%eax)
		}
		sys_signalSemaphore(parentenvID, _custQueueCS);
  800337:	83 ec 08             	sub    $0x8,%esp
  80033a:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800340:	50                   	push   %eax
  800341:	ff 75 e4             	pushl  -0x1c(%ebp)
  800344:	e8 18 1c 00 00       	call   801f61 <sys_signalSemaphore>
  800349:	83 c4 10             	add    $0x10,%esp

		//try reserving on the required flight
		int custFlightType = customers[custId].flightType;
  80034c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80034f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800356:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800359:	01 d0                	add    %edx,%eax
  80035b:	8b 00                	mov    (%eax),%eax
  80035d:	89 45 b8             	mov    %eax,-0x48(%ebp)
		//cprintf("custId dequeued = %d, ft = %d\n", custId, customers[custId].flightType);

		switch (custFlightType)
  800360:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800363:	83 f8 02             	cmp    $0x2,%eax
  800366:	0f 84 90 00 00 00    	je     8003fc <_main+0x3c4>
  80036c:	83 f8 03             	cmp    $0x3,%eax
  80036f:	0f 84 05 01 00 00    	je     80047a <_main+0x442>
  800375:	83 f8 01             	cmp    $0x1,%eax
  800378:	0f 85 f8 01 00 00    	jne    800576 <_main+0x53e>
		{
		case 1:
		{
			//Check and update Flight1
			sys_waitSemaphore(parentenvID, _flight1CS);
  80037e:	83 ec 08             	sub    $0x8,%esp
  800381:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  800387:	50                   	push   %eax
  800388:	ff 75 e4             	pushl  -0x1c(%ebp)
  80038b:	e8 b3 1b 00 00       	call   801f43 <sys_waitSemaphore>
  800390:	83 c4 10             	add    $0x10,%esp
			{
				if(*flight1Counter > 0)
  800393:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800396:	8b 00                	mov    (%eax),%eax
  800398:	85 c0                	test   %eax,%eax
  80039a:	7e 46                	jle    8003e2 <_main+0x3aa>
				{
					*flight1Counter = *flight1Counter - 1;
  80039c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80039f:	8b 00                	mov    (%eax),%eax
  8003a1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8003a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003a7:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  8003a9:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8003ac:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8003b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003b6:	01 d0                	add    %edx,%eax
  8003b8:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight1BookedArr[*flight1BookedCounter] = custId;
  8003bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003c2:	8b 00                	mov    (%eax),%eax
  8003c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003cb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8003ce:	01 c2                	add    %eax,%edx
  8003d0:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8003d3:	89 02                	mov    %eax,(%edx)
					*flight1BookedCounter =*flight1BookedCounter+1;
  8003d5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003d8:	8b 00                	mov    (%eax),%eax
  8003da:	8d 50 01             	lea    0x1(%eax),%edx
  8003dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003e0:	89 10                	mov    %edx,(%eax)
				else
				{

				}
			}
			sys_signalSemaphore(parentenvID, _flight1CS);
  8003e2:	83 ec 08             	sub    $0x8,%esp
  8003e5:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  8003eb:	50                   	push   %eax
  8003ec:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003ef:	e8 6d 1b 00 00       	call   801f61 <sys_signalSemaphore>
  8003f4:	83 c4 10             	add    $0x10,%esp
		}

		break;
  8003f7:	e9 91 01 00 00       	jmp    80058d <_main+0x555>
		case 2:
		{
			//Check and update Flight2
			sys_waitSemaphore(parentenvID, _flight2CS);
  8003fc:	83 ec 08             	sub    $0x8,%esp
  8003ff:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800405:	50                   	push   %eax
  800406:	ff 75 e4             	pushl  -0x1c(%ebp)
  800409:	e8 35 1b 00 00       	call   801f43 <sys_waitSemaphore>
  80040e:	83 c4 10             	add    $0x10,%esp
			{
				if(*flight2Counter > 0)
  800411:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800414:	8b 00                	mov    (%eax),%eax
  800416:	85 c0                	test   %eax,%eax
  800418:	7e 46                	jle    800460 <_main+0x428>
				{
					*flight2Counter = *flight2Counter - 1;
  80041a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80041d:	8b 00                	mov    (%eax),%eax
  80041f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800422:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800425:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  800427:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80042a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800431:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800434:	01 d0                	add    %edx,%eax
  800436:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight2BookedArr[*flight2BookedCounter] = custId;
  80043d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800440:	8b 00                	mov    (%eax),%eax
  800442:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800449:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80044c:	01 c2                	add    %eax,%edx
  80044e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800451:	89 02                	mov    %eax,(%edx)
					*flight2BookedCounter =*flight2BookedCounter+1;
  800453:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800456:	8b 00                	mov    (%eax),%eax
  800458:	8d 50 01             	lea    0x1(%eax),%edx
  80045b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80045e:	89 10                	mov    %edx,(%eax)
				else
				{

				}
			}
			sys_signalSemaphore(parentenvID, _flight2CS);
  800460:	83 ec 08             	sub    $0x8,%esp
  800463:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800469:	50                   	push   %eax
  80046a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80046d:	e8 ef 1a 00 00       	call   801f61 <sys_signalSemaphore>
  800472:	83 c4 10             	add    $0x10,%esp
		}
		break;
  800475:	e9 13 01 00 00       	jmp    80058d <_main+0x555>
		case 3:
		{
			//Check and update Both Flights
			sys_waitSemaphore(parentenvID, _flight1CS); sys_waitSemaphore(parentenvID, _flight2CS);
  80047a:	83 ec 08             	sub    $0x8,%esp
  80047d:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  800483:	50                   	push   %eax
  800484:	ff 75 e4             	pushl  -0x1c(%ebp)
  800487:	e8 b7 1a 00 00       	call   801f43 <sys_waitSemaphore>
  80048c:	83 c4 10             	add    $0x10,%esp
  80048f:	83 ec 08             	sub    $0x8,%esp
  800492:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800498:	50                   	push   %eax
  800499:	ff 75 e4             	pushl  -0x1c(%ebp)
  80049c:	e8 a2 1a 00 00       	call   801f43 <sys_waitSemaphore>
  8004a1:	83 c4 10             	add    $0x10,%esp
			{
				if(*flight1Counter > 0 && *flight2Counter >0 )
  8004a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004a7:	8b 00                	mov    (%eax),%eax
  8004a9:	85 c0                	test   %eax,%eax
  8004ab:	0f 8e 99 00 00 00    	jle    80054a <_main+0x512>
  8004b1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004b4:	8b 00                	mov    (%eax),%eax
  8004b6:	85 c0                	test   %eax,%eax
  8004b8:	0f 8e 8c 00 00 00    	jle    80054a <_main+0x512>
				{
					*flight1Counter = *flight1Counter - 1;
  8004be:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004c1:	8b 00                	mov    (%eax),%eax
  8004c3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8004c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004c9:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  8004cb:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8004ce:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8004d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004d8:	01 d0                	add    %edx,%eax
  8004da:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight1BookedArr[*flight1BookedCounter] = custId;
  8004e1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004e4:	8b 00                	mov    (%eax),%eax
  8004e6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ed:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004f0:	01 c2                	add    %eax,%edx
  8004f2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8004f5:	89 02                	mov    %eax,(%edx)
					*flight1BookedCounter =*flight1BookedCounter+1;
  8004f7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004fa:	8b 00                	mov    (%eax),%eax
  8004fc:	8d 50 01             	lea    0x1(%eax),%edx
  8004ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800502:	89 10                	mov    %edx,(%eax)

					*flight2Counter = *flight2Counter - 1;
  800504:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800507:	8b 00                	mov    (%eax),%eax
  800509:	8d 50 ff             	lea    -0x1(%eax),%edx
  80050c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80050f:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  800511:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800514:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80051b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80051e:	01 d0                	add    %edx,%eax
  800520:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight2BookedArr[*flight2BookedCounter] = custId;
  800527:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80052a:	8b 00                	mov    (%eax),%eax
  80052c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800533:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800536:	01 c2                	add    %eax,%edx
  800538:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80053b:	89 02                	mov    %eax,(%edx)
					*flight2BookedCounter =*flight2BookedCounter+1;
  80053d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800540:	8b 00                	mov    (%eax),%eax
  800542:	8d 50 01             	lea    0x1(%eax),%edx
  800545:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800548:	89 10                	mov    %edx,(%eax)
				else
				{

				}
			}
			sys_signalSemaphore(parentenvID, _flight2CS); sys_signalSemaphore(parentenvID, _flight1CS);
  80054a:	83 ec 08             	sub    $0x8,%esp
  80054d:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800553:	50                   	push   %eax
  800554:	ff 75 e4             	pushl  -0x1c(%ebp)
  800557:	e8 05 1a 00 00       	call   801f61 <sys_signalSemaphore>
  80055c:	83 c4 10             	add    $0x10,%esp
  80055f:	83 ec 08             	sub    $0x8,%esp
  800562:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  800568:	50                   	push   %eax
  800569:	ff 75 e4             	pushl  -0x1c(%ebp)
  80056c:	e8 f0 19 00 00       	call   801f61 <sys_signalSemaphore>
  800571:	83 c4 10             	add    $0x10,%esp
		}
		break;
  800574:	eb 17                	jmp    80058d <_main+0x555>
		default:
			panic("customer must have flight type\n");
  800576:	83 ec 04             	sub    $0x4,%esp
  800579:	68 60 37 80 00       	push   $0x803760
  80057e:	68 8f 00 00 00       	push   $0x8f
  800583:	68 80 37 80 00       	push   $0x803780
  800588:	e8 cc 01 00 00       	call   800759 <_panic>
		}

		//signal finished
		char prefix[30]="cust_finished";
  80058d:	8d 85 9a fe ff ff    	lea    -0x166(%ebp),%eax
  800593:	bb 8f 38 80 00       	mov    $0x80388f,%ebx
  800598:	ba 0e 00 00 00       	mov    $0xe,%edx
  80059d:	89 c7                	mov    %eax,%edi
  80059f:	89 de                	mov    %ebx,%esi
  8005a1:	89 d1                	mov    %edx,%ecx
  8005a3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8005a5:	8d 95 a8 fe ff ff    	lea    -0x158(%ebp),%edx
  8005ab:	b9 04 00 00 00       	mov    $0x4,%ecx
  8005b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8005b5:	89 d7                	mov    %edx,%edi
  8005b7:	f3 ab                	rep stos %eax,%es:(%edi)
		char id[5]; char sname[50];
		ltostr(custId, id);
  8005b9:	83 ec 08             	sub    $0x8,%esp
  8005bc:	8d 85 95 fe ff ff    	lea    -0x16b(%ebp),%eax
  8005c2:	50                   	push   %eax
  8005c3:	ff 75 bc             	pushl  -0x44(%ebp)
  8005c6:	e8 6a 0f 00 00       	call   801535 <ltostr>
  8005cb:	83 c4 10             	add    $0x10,%esp
		strcconcat(prefix, id, sname);
  8005ce:	83 ec 04             	sub    $0x4,%esp
  8005d1:	8d 85 63 fe ff ff    	lea    -0x19d(%ebp),%eax
  8005d7:	50                   	push   %eax
  8005d8:	8d 85 95 fe ff ff    	lea    -0x16b(%ebp),%eax
  8005de:	50                   	push   %eax
  8005df:	8d 85 9a fe ff ff    	lea    -0x166(%ebp),%eax
  8005e5:	50                   	push   %eax
  8005e6:	e8 42 10 00 00       	call   80162d <strcconcat>
  8005eb:	83 c4 10             	add    $0x10,%esp
		sys_signalSemaphore(parentenvID, sname);
  8005ee:	83 ec 08             	sub    $0x8,%esp
  8005f1:	8d 85 63 fe ff ff    	lea    -0x19d(%ebp),%eax
  8005f7:	50                   	push   %eax
  8005f8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005fb:	e8 61 19 00 00       	call   801f61 <sys_signalSemaphore>
  800600:	83 c4 10             	add    $0x10,%esp

		//signal the clerk
		sys_signalSemaphore(parentenvID, _clerk);
  800603:	83 ec 08             	sub    $0x8,%esp
  800606:	8d 85 e3 fe ff ff    	lea    -0x11d(%ebp),%eax
  80060c:	50                   	push   %eax
  80060d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800610:	e8 4c 19 00 00       	call   801f61 <sys_signalSemaphore>
  800615:	83 c4 10             	add    $0x10,%esp
	}
  800618:	e9 cd fc ff ff       	jmp    8002ea <_main+0x2b2>

0080061d <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80061d:	55                   	push   %ebp
  80061e:	89 e5                	mov    %esp,%ebp
  800620:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800623:	e8 61 1a 00 00       	call   802089 <sys_getenvindex>
  800628:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80062b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80062e:	89 d0                	mov    %edx,%eax
  800630:	c1 e0 03             	shl    $0x3,%eax
  800633:	01 d0                	add    %edx,%eax
  800635:	01 c0                	add    %eax,%eax
  800637:	01 d0                	add    %edx,%eax
  800639:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800640:	01 d0                	add    %edx,%eax
  800642:	c1 e0 04             	shl    $0x4,%eax
  800645:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80064a:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80064f:	a1 20 50 80 00       	mov    0x805020,%eax
  800654:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80065a:	84 c0                	test   %al,%al
  80065c:	74 0f                	je     80066d <libmain+0x50>
		binaryname = myEnv->prog_name;
  80065e:	a1 20 50 80 00       	mov    0x805020,%eax
  800663:	05 5c 05 00 00       	add    $0x55c,%eax
  800668:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80066d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800671:	7e 0a                	jle    80067d <libmain+0x60>
		binaryname = argv[0];
  800673:	8b 45 0c             	mov    0xc(%ebp),%eax
  800676:	8b 00                	mov    (%eax),%eax
  800678:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  80067d:	83 ec 08             	sub    $0x8,%esp
  800680:	ff 75 0c             	pushl  0xc(%ebp)
  800683:	ff 75 08             	pushl  0x8(%ebp)
  800686:	e8 ad f9 ff ff       	call   800038 <_main>
  80068b:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80068e:	e8 03 18 00 00       	call   801e96 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800693:	83 ec 0c             	sub    $0xc,%esp
  800696:	68 c8 38 80 00       	push   $0x8038c8
  80069b:	e8 6d 03 00 00       	call   800a0d <cprintf>
  8006a0:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006a3:	a1 20 50 80 00       	mov    0x805020,%eax
  8006a8:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8006ae:	a1 20 50 80 00       	mov    0x805020,%eax
  8006b3:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8006b9:	83 ec 04             	sub    $0x4,%esp
  8006bc:	52                   	push   %edx
  8006bd:	50                   	push   %eax
  8006be:	68 f0 38 80 00       	push   $0x8038f0
  8006c3:	e8 45 03 00 00       	call   800a0d <cprintf>
  8006c8:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8006cb:	a1 20 50 80 00       	mov    0x805020,%eax
  8006d0:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8006d6:	a1 20 50 80 00       	mov    0x805020,%eax
  8006db:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8006e1:	a1 20 50 80 00       	mov    0x805020,%eax
  8006e6:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8006ec:	51                   	push   %ecx
  8006ed:	52                   	push   %edx
  8006ee:	50                   	push   %eax
  8006ef:	68 18 39 80 00       	push   $0x803918
  8006f4:	e8 14 03 00 00       	call   800a0d <cprintf>
  8006f9:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006fc:	a1 20 50 80 00       	mov    0x805020,%eax
  800701:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800707:	83 ec 08             	sub    $0x8,%esp
  80070a:	50                   	push   %eax
  80070b:	68 70 39 80 00       	push   $0x803970
  800710:	e8 f8 02 00 00       	call   800a0d <cprintf>
  800715:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800718:	83 ec 0c             	sub    $0xc,%esp
  80071b:	68 c8 38 80 00       	push   $0x8038c8
  800720:	e8 e8 02 00 00       	call   800a0d <cprintf>
  800725:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800728:	e8 83 17 00 00       	call   801eb0 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80072d:	e8 19 00 00 00       	call   80074b <exit>
}
  800732:	90                   	nop
  800733:	c9                   	leave  
  800734:	c3                   	ret    

00800735 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800735:	55                   	push   %ebp
  800736:	89 e5                	mov    %esp,%ebp
  800738:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80073b:	83 ec 0c             	sub    $0xc,%esp
  80073e:	6a 00                	push   $0x0
  800740:	e8 10 19 00 00       	call   802055 <sys_destroy_env>
  800745:	83 c4 10             	add    $0x10,%esp
}
  800748:	90                   	nop
  800749:	c9                   	leave  
  80074a:	c3                   	ret    

0080074b <exit>:

void
exit(void)
{
  80074b:	55                   	push   %ebp
  80074c:	89 e5                	mov    %esp,%ebp
  80074e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800751:	e8 65 19 00 00       	call   8020bb <sys_exit_env>
}
  800756:	90                   	nop
  800757:	c9                   	leave  
  800758:	c3                   	ret    

00800759 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800759:	55                   	push   %ebp
  80075a:	89 e5                	mov    %esp,%ebp
  80075c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80075f:	8d 45 10             	lea    0x10(%ebp),%eax
  800762:	83 c0 04             	add    $0x4,%eax
  800765:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800768:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80076d:	85 c0                	test   %eax,%eax
  80076f:	74 16                	je     800787 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800771:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800776:	83 ec 08             	sub    $0x8,%esp
  800779:	50                   	push   %eax
  80077a:	68 84 39 80 00       	push   $0x803984
  80077f:	e8 89 02 00 00       	call   800a0d <cprintf>
  800784:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800787:	a1 00 50 80 00       	mov    0x805000,%eax
  80078c:	ff 75 0c             	pushl  0xc(%ebp)
  80078f:	ff 75 08             	pushl  0x8(%ebp)
  800792:	50                   	push   %eax
  800793:	68 89 39 80 00       	push   $0x803989
  800798:	e8 70 02 00 00       	call   800a0d <cprintf>
  80079d:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8007a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a3:	83 ec 08             	sub    $0x8,%esp
  8007a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8007a9:	50                   	push   %eax
  8007aa:	e8 f3 01 00 00       	call   8009a2 <vcprintf>
  8007af:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007b2:	83 ec 08             	sub    $0x8,%esp
  8007b5:	6a 00                	push   $0x0
  8007b7:	68 a5 39 80 00       	push   $0x8039a5
  8007bc:	e8 e1 01 00 00       	call   8009a2 <vcprintf>
  8007c1:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8007c4:	e8 82 ff ff ff       	call   80074b <exit>

	// should not return here
	while (1) ;
  8007c9:	eb fe                	jmp    8007c9 <_panic+0x70>

008007cb <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8007cb:	55                   	push   %ebp
  8007cc:	89 e5                	mov    %esp,%ebp
  8007ce:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8007d1:	a1 20 50 80 00       	mov    0x805020,%eax
  8007d6:	8b 50 74             	mov    0x74(%eax),%edx
  8007d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007dc:	39 c2                	cmp    %eax,%edx
  8007de:	74 14                	je     8007f4 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8007e0:	83 ec 04             	sub    $0x4,%esp
  8007e3:	68 a8 39 80 00       	push   $0x8039a8
  8007e8:	6a 26                	push   $0x26
  8007ea:	68 f4 39 80 00       	push   $0x8039f4
  8007ef:	e8 65 ff ff ff       	call   800759 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8007f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8007fb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800802:	e9 c2 00 00 00       	jmp    8008c9 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800807:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80080a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800811:	8b 45 08             	mov    0x8(%ebp),%eax
  800814:	01 d0                	add    %edx,%eax
  800816:	8b 00                	mov    (%eax),%eax
  800818:	85 c0                	test   %eax,%eax
  80081a:	75 08                	jne    800824 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80081c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80081f:	e9 a2 00 00 00       	jmp    8008c6 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800824:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80082b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800832:	eb 69                	jmp    80089d <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800834:	a1 20 50 80 00       	mov    0x805020,%eax
  800839:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80083f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800842:	89 d0                	mov    %edx,%eax
  800844:	01 c0                	add    %eax,%eax
  800846:	01 d0                	add    %edx,%eax
  800848:	c1 e0 03             	shl    $0x3,%eax
  80084b:	01 c8                	add    %ecx,%eax
  80084d:	8a 40 04             	mov    0x4(%eax),%al
  800850:	84 c0                	test   %al,%al
  800852:	75 46                	jne    80089a <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800854:	a1 20 50 80 00       	mov    0x805020,%eax
  800859:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80085f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800862:	89 d0                	mov    %edx,%eax
  800864:	01 c0                	add    %eax,%eax
  800866:	01 d0                	add    %edx,%eax
  800868:	c1 e0 03             	shl    $0x3,%eax
  80086b:	01 c8                	add    %ecx,%eax
  80086d:	8b 00                	mov    (%eax),%eax
  80086f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800872:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800875:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80087a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80087c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80087f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800886:	8b 45 08             	mov    0x8(%ebp),%eax
  800889:	01 c8                	add    %ecx,%eax
  80088b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80088d:	39 c2                	cmp    %eax,%edx
  80088f:	75 09                	jne    80089a <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800891:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800898:	eb 12                	jmp    8008ac <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80089a:	ff 45 e8             	incl   -0x18(%ebp)
  80089d:	a1 20 50 80 00       	mov    0x805020,%eax
  8008a2:	8b 50 74             	mov    0x74(%eax),%edx
  8008a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008a8:	39 c2                	cmp    %eax,%edx
  8008aa:	77 88                	ja     800834 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8008ac:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008b0:	75 14                	jne    8008c6 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8008b2:	83 ec 04             	sub    $0x4,%esp
  8008b5:	68 00 3a 80 00       	push   $0x803a00
  8008ba:	6a 3a                	push   $0x3a
  8008bc:	68 f4 39 80 00       	push   $0x8039f4
  8008c1:	e8 93 fe ff ff       	call   800759 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8008c6:	ff 45 f0             	incl   -0x10(%ebp)
  8008c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8008cf:	0f 8c 32 ff ff ff    	jl     800807 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8008d5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008dc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8008e3:	eb 26                	jmp    80090b <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8008e5:	a1 20 50 80 00       	mov    0x805020,%eax
  8008ea:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8008f0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008f3:	89 d0                	mov    %edx,%eax
  8008f5:	01 c0                	add    %eax,%eax
  8008f7:	01 d0                	add    %edx,%eax
  8008f9:	c1 e0 03             	shl    $0x3,%eax
  8008fc:	01 c8                	add    %ecx,%eax
  8008fe:	8a 40 04             	mov    0x4(%eax),%al
  800901:	3c 01                	cmp    $0x1,%al
  800903:	75 03                	jne    800908 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800905:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800908:	ff 45 e0             	incl   -0x20(%ebp)
  80090b:	a1 20 50 80 00       	mov    0x805020,%eax
  800910:	8b 50 74             	mov    0x74(%eax),%edx
  800913:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800916:	39 c2                	cmp    %eax,%edx
  800918:	77 cb                	ja     8008e5 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80091a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80091d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800920:	74 14                	je     800936 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800922:	83 ec 04             	sub    $0x4,%esp
  800925:	68 54 3a 80 00       	push   $0x803a54
  80092a:	6a 44                	push   $0x44
  80092c:	68 f4 39 80 00       	push   $0x8039f4
  800931:	e8 23 fe ff ff       	call   800759 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800936:	90                   	nop
  800937:	c9                   	leave  
  800938:	c3                   	ret    

00800939 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800939:	55                   	push   %ebp
  80093a:	89 e5                	mov    %esp,%ebp
  80093c:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80093f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800942:	8b 00                	mov    (%eax),%eax
  800944:	8d 48 01             	lea    0x1(%eax),%ecx
  800947:	8b 55 0c             	mov    0xc(%ebp),%edx
  80094a:	89 0a                	mov    %ecx,(%edx)
  80094c:	8b 55 08             	mov    0x8(%ebp),%edx
  80094f:	88 d1                	mov    %dl,%cl
  800951:	8b 55 0c             	mov    0xc(%ebp),%edx
  800954:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800958:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095b:	8b 00                	mov    (%eax),%eax
  80095d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800962:	75 2c                	jne    800990 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800964:	a0 24 50 80 00       	mov    0x805024,%al
  800969:	0f b6 c0             	movzbl %al,%eax
  80096c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80096f:	8b 12                	mov    (%edx),%edx
  800971:	89 d1                	mov    %edx,%ecx
  800973:	8b 55 0c             	mov    0xc(%ebp),%edx
  800976:	83 c2 08             	add    $0x8,%edx
  800979:	83 ec 04             	sub    $0x4,%esp
  80097c:	50                   	push   %eax
  80097d:	51                   	push   %ecx
  80097e:	52                   	push   %edx
  80097f:	e8 64 13 00 00       	call   801ce8 <sys_cputs>
  800984:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800987:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800990:	8b 45 0c             	mov    0xc(%ebp),%eax
  800993:	8b 40 04             	mov    0x4(%eax),%eax
  800996:	8d 50 01             	lea    0x1(%eax),%edx
  800999:	8b 45 0c             	mov    0xc(%ebp),%eax
  80099c:	89 50 04             	mov    %edx,0x4(%eax)
}
  80099f:	90                   	nop
  8009a0:	c9                   	leave  
  8009a1:	c3                   	ret    

008009a2 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8009a2:	55                   	push   %ebp
  8009a3:	89 e5                	mov    %esp,%ebp
  8009a5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009ab:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009b2:	00 00 00 
	b.cnt = 0;
  8009b5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009bc:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8009bf:	ff 75 0c             	pushl  0xc(%ebp)
  8009c2:	ff 75 08             	pushl  0x8(%ebp)
  8009c5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009cb:	50                   	push   %eax
  8009cc:	68 39 09 80 00       	push   $0x800939
  8009d1:	e8 11 02 00 00       	call   800be7 <vprintfmt>
  8009d6:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8009d9:	a0 24 50 80 00       	mov    0x805024,%al
  8009de:	0f b6 c0             	movzbl %al,%eax
  8009e1:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8009e7:	83 ec 04             	sub    $0x4,%esp
  8009ea:	50                   	push   %eax
  8009eb:	52                   	push   %edx
  8009ec:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009f2:	83 c0 08             	add    $0x8,%eax
  8009f5:	50                   	push   %eax
  8009f6:	e8 ed 12 00 00       	call   801ce8 <sys_cputs>
  8009fb:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8009fe:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800a05:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a0b:	c9                   	leave  
  800a0c:	c3                   	ret    

00800a0d <cprintf>:

int cprintf(const char *fmt, ...) {
  800a0d:	55                   	push   %ebp
  800a0e:	89 e5                	mov    %esp,%ebp
  800a10:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a13:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800a1a:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a20:	8b 45 08             	mov    0x8(%ebp),%eax
  800a23:	83 ec 08             	sub    $0x8,%esp
  800a26:	ff 75 f4             	pushl  -0xc(%ebp)
  800a29:	50                   	push   %eax
  800a2a:	e8 73 ff ff ff       	call   8009a2 <vcprintf>
  800a2f:	83 c4 10             	add    $0x10,%esp
  800a32:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a35:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a38:	c9                   	leave  
  800a39:	c3                   	ret    

00800a3a <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a3a:	55                   	push   %ebp
  800a3b:	89 e5                	mov    %esp,%ebp
  800a3d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a40:	e8 51 14 00 00       	call   801e96 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a45:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a48:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4e:	83 ec 08             	sub    $0x8,%esp
  800a51:	ff 75 f4             	pushl  -0xc(%ebp)
  800a54:	50                   	push   %eax
  800a55:	e8 48 ff ff ff       	call   8009a2 <vcprintf>
  800a5a:	83 c4 10             	add    $0x10,%esp
  800a5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a60:	e8 4b 14 00 00       	call   801eb0 <sys_enable_interrupt>
	return cnt;
  800a65:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a68:	c9                   	leave  
  800a69:	c3                   	ret    

00800a6a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a6a:	55                   	push   %ebp
  800a6b:	89 e5                	mov    %esp,%ebp
  800a6d:	53                   	push   %ebx
  800a6e:	83 ec 14             	sub    $0x14,%esp
  800a71:	8b 45 10             	mov    0x10(%ebp),%eax
  800a74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a77:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a7d:	8b 45 18             	mov    0x18(%ebp),%eax
  800a80:	ba 00 00 00 00       	mov    $0x0,%edx
  800a85:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a88:	77 55                	ja     800adf <printnum+0x75>
  800a8a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a8d:	72 05                	jb     800a94 <printnum+0x2a>
  800a8f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a92:	77 4b                	ja     800adf <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a94:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a97:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a9a:	8b 45 18             	mov    0x18(%ebp),%eax
  800a9d:	ba 00 00 00 00       	mov    $0x0,%edx
  800aa2:	52                   	push   %edx
  800aa3:	50                   	push   %eax
  800aa4:	ff 75 f4             	pushl  -0xc(%ebp)
  800aa7:	ff 75 f0             	pushl  -0x10(%ebp)
  800aaa:	e8 49 2a 00 00       	call   8034f8 <__udivdi3>
  800aaf:	83 c4 10             	add    $0x10,%esp
  800ab2:	83 ec 04             	sub    $0x4,%esp
  800ab5:	ff 75 20             	pushl  0x20(%ebp)
  800ab8:	53                   	push   %ebx
  800ab9:	ff 75 18             	pushl  0x18(%ebp)
  800abc:	52                   	push   %edx
  800abd:	50                   	push   %eax
  800abe:	ff 75 0c             	pushl  0xc(%ebp)
  800ac1:	ff 75 08             	pushl  0x8(%ebp)
  800ac4:	e8 a1 ff ff ff       	call   800a6a <printnum>
  800ac9:	83 c4 20             	add    $0x20,%esp
  800acc:	eb 1a                	jmp    800ae8 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800ace:	83 ec 08             	sub    $0x8,%esp
  800ad1:	ff 75 0c             	pushl  0xc(%ebp)
  800ad4:	ff 75 20             	pushl  0x20(%ebp)
  800ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  800ada:	ff d0                	call   *%eax
  800adc:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800adf:	ff 4d 1c             	decl   0x1c(%ebp)
  800ae2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800ae6:	7f e6                	jg     800ace <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800ae8:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800aeb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800af0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800af3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800af6:	53                   	push   %ebx
  800af7:	51                   	push   %ecx
  800af8:	52                   	push   %edx
  800af9:	50                   	push   %eax
  800afa:	e8 09 2b 00 00       	call   803608 <__umoddi3>
  800aff:	83 c4 10             	add    $0x10,%esp
  800b02:	05 b4 3c 80 00       	add    $0x803cb4,%eax
  800b07:	8a 00                	mov    (%eax),%al
  800b09:	0f be c0             	movsbl %al,%eax
  800b0c:	83 ec 08             	sub    $0x8,%esp
  800b0f:	ff 75 0c             	pushl  0xc(%ebp)
  800b12:	50                   	push   %eax
  800b13:	8b 45 08             	mov    0x8(%ebp),%eax
  800b16:	ff d0                	call   *%eax
  800b18:	83 c4 10             	add    $0x10,%esp
}
  800b1b:	90                   	nop
  800b1c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b1f:	c9                   	leave  
  800b20:	c3                   	ret    

00800b21 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b21:	55                   	push   %ebp
  800b22:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b24:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b28:	7e 1c                	jle    800b46 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2d:	8b 00                	mov    (%eax),%eax
  800b2f:	8d 50 08             	lea    0x8(%eax),%edx
  800b32:	8b 45 08             	mov    0x8(%ebp),%eax
  800b35:	89 10                	mov    %edx,(%eax)
  800b37:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3a:	8b 00                	mov    (%eax),%eax
  800b3c:	83 e8 08             	sub    $0x8,%eax
  800b3f:	8b 50 04             	mov    0x4(%eax),%edx
  800b42:	8b 00                	mov    (%eax),%eax
  800b44:	eb 40                	jmp    800b86 <getuint+0x65>
	else if (lflag)
  800b46:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b4a:	74 1e                	je     800b6a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4f:	8b 00                	mov    (%eax),%eax
  800b51:	8d 50 04             	lea    0x4(%eax),%edx
  800b54:	8b 45 08             	mov    0x8(%ebp),%eax
  800b57:	89 10                	mov    %edx,(%eax)
  800b59:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5c:	8b 00                	mov    (%eax),%eax
  800b5e:	83 e8 04             	sub    $0x4,%eax
  800b61:	8b 00                	mov    (%eax),%eax
  800b63:	ba 00 00 00 00       	mov    $0x0,%edx
  800b68:	eb 1c                	jmp    800b86 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6d:	8b 00                	mov    (%eax),%eax
  800b6f:	8d 50 04             	lea    0x4(%eax),%edx
  800b72:	8b 45 08             	mov    0x8(%ebp),%eax
  800b75:	89 10                	mov    %edx,(%eax)
  800b77:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7a:	8b 00                	mov    (%eax),%eax
  800b7c:	83 e8 04             	sub    $0x4,%eax
  800b7f:	8b 00                	mov    (%eax),%eax
  800b81:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b86:	5d                   	pop    %ebp
  800b87:	c3                   	ret    

00800b88 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b88:	55                   	push   %ebp
  800b89:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b8b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b8f:	7e 1c                	jle    800bad <getint+0x25>
		return va_arg(*ap, long long);
  800b91:	8b 45 08             	mov    0x8(%ebp),%eax
  800b94:	8b 00                	mov    (%eax),%eax
  800b96:	8d 50 08             	lea    0x8(%eax),%edx
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	89 10                	mov    %edx,(%eax)
  800b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba1:	8b 00                	mov    (%eax),%eax
  800ba3:	83 e8 08             	sub    $0x8,%eax
  800ba6:	8b 50 04             	mov    0x4(%eax),%edx
  800ba9:	8b 00                	mov    (%eax),%eax
  800bab:	eb 38                	jmp    800be5 <getint+0x5d>
	else if (lflag)
  800bad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bb1:	74 1a                	je     800bcd <getint+0x45>
		return va_arg(*ap, long);
  800bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb6:	8b 00                	mov    (%eax),%eax
  800bb8:	8d 50 04             	lea    0x4(%eax),%edx
  800bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbe:	89 10                	mov    %edx,(%eax)
  800bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc3:	8b 00                	mov    (%eax),%eax
  800bc5:	83 e8 04             	sub    $0x4,%eax
  800bc8:	8b 00                	mov    (%eax),%eax
  800bca:	99                   	cltd   
  800bcb:	eb 18                	jmp    800be5 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	8b 00                	mov    (%eax),%eax
  800bd2:	8d 50 04             	lea    0x4(%eax),%edx
  800bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd8:	89 10                	mov    %edx,(%eax)
  800bda:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdd:	8b 00                	mov    (%eax),%eax
  800bdf:	83 e8 04             	sub    $0x4,%eax
  800be2:	8b 00                	mov    (%eax),%eax
  800be4:	99                   	cltd   
}
  800be5:	5d                   	pop    %ebp
  800be6:	c3                   	ret    

00800be7 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800be7:	55                   	push   %ebp
  800be8:	89 e5                	mov    %esp,%ebp
  800bea:	56                   	push   %esi
  800beb:	53                   	push   %ebx
  800bec:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bef:	eb 17                	jmp    800c08 <vprintfmt+0x21>
			if (ch == '\0')
  800bf1:	85 db                	test   %ebx,%ebx
  800bf3:	0f 84 af 03 00 00    	je     800fa8 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800bf9:	83 ec 08             	sub    $0x8,%esp
  800bfc:	ff 75 0c             	pushl  0xc(%ebp)
  800bff:	53                   	push   %ebx
  800c00:	8b 45 08             	mov    0x8(%ebp),%eax
  800c03:	ff d0                	call   *%eax
  800c05:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c08:	8b 45 10             	mov    0x10(%ebp),%eax
  800c0b:	8d 50 01             	lea    0x1(%eax),%edx
  800c0e:	89 55 10             	mov    %edx,0x10(%ebp)
  800c11:	8a 00                	mov    (%eax),%al
  800c13:	0f b6 d8             	movzbl %al,%ebx
  800c16:	83 fb 25             	cmp    $0x25,%ebx
  800c19:	75 d6                	jne    800bf1 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c1b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c1f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c26:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c2d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c34:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c3e:	8d 50 01             	lea    0x1(%eax),%edx
  800c41:	89 55 10             	mov    %edx,0x10(%ebp)
  800c44:	8a 00                	mov    (%eax),%al
  800c46:	0f b6 d8             	movzbl %al,%ebx
  800c49:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c4c:	83 f8 55             	cmp    $0x55,%eax
  800c4f:	0f 87 2b 03 00 00    	ja     800f80 <vprintfmt+0x399>
  800c55:	8b 04 85 d8 3c 80 00 	mov    0x803cd8(,%eax,4),%eax
  800c5c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c5e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c62:	eb d7                	jmp    800c3b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c64:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c68:	eb d1                	jmp    800c3b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c6a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c71:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c74:	89 d0                	mov    %edx,%eax
  800c76:	c1 e0 02             	shl    $0x2,%eax
  800c79:	01 d0                	add    %edx,%eax
  800c7b:	01 c0                	add    %eax,%eax
  800c7d:	01 d8                	add    %ebx,%eax
  800c7f:	83 e8 30             	sub    $0x30,%eax
  800c82:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c85:	8b 45 10             	mov    0x10(%ebp),%eax
  800c88:	8a 00                	mov    (%eax),%al
  800c8a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c8d:	83 fb 2f             	cmp    $0x2f,%ebx
  800c90:	7e 3e                	jle    800cd0 <vprintfmt+0xe9>
  800c92:	83 fb 39             	cmp    $0x39,%ebx
  800c95:	7f 39                	jg     800cd0 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c97:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c9a:	eb d5                	jmp    800c71 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c9c:	8b 45 14             	mov    0x14(%ebp),%eax
  800c9f:	83 c0 04             	add    $0x4,%eax
  800ca2:	89 45 14             	mov    %eax,0x14(%ebp)
  800ca5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca8:	83 e8 04             	sub    $0x4,%eax
  800cab:	8b 00                	mov    (%eax),%eax
  800cad:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800cb0:	eb 1f                	jmp    800cd1 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800cb2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cb6:	79 83                	jns    800c3b <vprintfmt+0x54>
				width = 0;
  800cb8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800cbf:	e9 77 ff ff ff       	jmp    800c3b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800cc4:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800ccb:	e9 6b ff ff ff       	jmp    800c3b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800cd0:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800cd1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cd5:	0f 89 60 ff ff ff    	jns    800c3b <vprintfmt+0x54>
				width = precision, precision = -1;
  800cdb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cde:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ce1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800ce8:	e9 4e ff ff ff       	jmp    800c3b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ced:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800cf0:	e9 46 ff ff ff       	jmp    800c3b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800cf5:	8b 45 14             	mov    0x14(%ebp),%eax
  800cf8:	83 c0 04             	add    $0x4,%eax
  800cfb:	89 45 14             	mov    %eax,0x14(%ebp)
  800cfe:	8b 45 14             	mov    0x14(%ebp),%eax
  800d01:	83 e8 04             	sub    $0x4,%eax
  800d04:	8b 00                	mov    (%eax),%eax
  800d06:	83 ec 08             	sub    $0x8,%esp
  800d09:	ff 75 0c             	pushl  0xc(%ebp)
  800d0c:	50                   	push   %eax
  800d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d10:	ff d0                	call   *%eax
  800d12:	83 c4 10             	add    $0x10,%esp
			break;
  800d15:	e9 89 02 00 00       	jmp    800fa3 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d1a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d1d:	83 c0 04             	add    $0x4,%eax
  800d20:	89 45 14             	mov    %eax,0x14(%ebp)
  800d23:	8b 45 14             	mov    0x14(%ebp),%eax
  800d26:	83 e8 04             	sub    $0x4,%eax
  800d29:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d2b:	85 db                	test   %ebx,%ebx
  800d2d:	79 02                	jns    800d31 <vprintfmt+0x14a>
				err = -err;
  800d2f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d31:	83 fb 64             	cmp    $0x64,%ebx
  800d34:	7f 0b                	jg     800d41 <vprintfmt+0x15a>
  800d36:	8b 34 9d 20 3b 80 00 	mov    0x803b20(,%ebx,4),%esi
  800d3d:	85 f6                	test   %esi,%esi
  800d3f:	75 19                	jne    800d5a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d41:	53                   	push   %ebx
  800d42:	68 c5 3c 80 00       	push   $0x803cc5
  800d47:	ff 75 0c             	pushl  0xc(%ebp)
  800d4a:	ff 75 08             	pushl  0x8(%ebp)
  800d4d:	e8 5e 02 00 00       	call   800fb0 <printfmt>
  800d52:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d55:	e9 49 02 00 00       	jmp    800fa3 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d5a:	56                   	push   %esi
  800d5b:	68 ce 3c 80 00       	push   $0x803cce
  800d60:	ff 75 0c             	pushl  0xc(%ebp)
  800d63:	ff 75 08             	pushl  0x8(%ebp)
  800d66:	e8 45 02 00 00       	call   800fb0 <printfmt>
  800d6b:	83 c4 10             	add    $0x10,%esp
			break;
  800d6e:	e9 30 02 00 00       	jmp    800fa3 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d73:	8b 45 14             	mov    0x14(%ebp),%eax
  800d76:	83 c0 04             	add    $0x4,%eax
  800d79:	89 45 14             	mov    %eax,0x14(%ebp)
  800d7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d7f:	83 e8 04             	sub    $0x4,%eax
  800d82:	8b 30                	mov    (%eax),%esi
  800d84:	85 f6                	test   %esi,%esi
  800d86:	75 05                	jne    800d8d <vprintfmt+0x1a6>
				p = "(null)";
  800d88:	be d1 3c 80 00       	mov    $0x803cd1,%esi
			if (width > 0 && padc != '-')
  800d8d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d91:	7e 6d                	jle    800e00 <vprintfmt+0x219>
  800d93:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d97:	74 67                	je     800e00 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d99:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d9c:	83 ec 08             	sub    $0x8,%esp
  800d9f:	50                   	push   %eax
  800da0:	56                   	push   %esi
  800da1:	e8 0c 03 00 00       	call   8010b2 <strnlen>
  800da6:	83 c4 10             	add    $0x10,%esp
  800da9:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800dac:	eb 16                	jmp    800dc4 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800dae:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800db2:	83 ec 08             	sub    $0x8,%esp
  800db5:	ff 75 0c             	pushl  0xc(%ebp)
  800db8:	50                   	push   %eax
  800db9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbc:	ff d0                	call   *%eax
  800dbe:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800dc1:	ff 4d e4             	decl   -0x1c(%ebp)
  800dc4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dc8:	7f e4                	jg     800dae <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dca:	eb 34                	jmp    800e00 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800dcc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800dd0:	74 1c                	je     800dee <vprintfmt+0x207>
  800dd2:	83 fb 1f             	cmp    $0x1f,%ebx
  800dd5:	7e 05                	jle    800ddc <vprintfmt+0x1f5>
  800dd7:	83 fb 7e             	cmp    $0x7e,%ebx
  800dda:	7e 12                	jle    800dee <vprintfmt+0x207>
					putch('?', putdat);
  800ddc:	83 ec 08             	sub    $0x8,%esp
  800ddf:	ff 75 0c             	pushl  0xc(%ebp)
  800de2:	6a 3f                	push   $0x3f
  800de4:	8b 45 08             	mov    0x8(%ebp),%eax
  800de7:	ff d0                	call   *%eax
  800de9:	83 c4 10             	add    $0x10,%esp
  800dec:	eb 0f                	jmp    800dfd <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800dee:	83 ec 08             	sub    $0x8,%esp
  800df1:	ff 75 0c             	pushl  0xc(%ebp)
  800df4:	53                   	push   %ebx
  800df5:	8b 45 08             	mov    0x8(%ebp),%eax
  800df8:	ff d0                	call   *%eax
  800dfa:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dfd:	ff 4d e4             	decl   -0x1c(%ebp)
  800e00:	89 f0                	mov    %esi,%eax
  800e02:	8d 70 01             	lea    0x1(%eax),%esi
  800e05:	8a 00                	mov    (%eax),%al
  800e07:	0f be d8             	movsbl %al,%ebx
  800e0a:	85 db                	test   %ebx,%ebx
  800e0c:	74 24                	je     800e32 <vprintfmt+0x24b>
  800e0e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e12:	78 b8                	js     800dcc <vprintfmt+0x1e5>
  800e14:	ff 4d e0             	decl   -0x20(%ebp)
  800e17:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e1b:	79 af                	jns    800dcc <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e1d:	eb 13                	jmp    800e32 <vprintfmt+0x24b>
				putch(' ', putdat);
  800e1f:	83 ec 08             	sub    $0x8,%esp
  800e22:	ff 75 0c             	pushl  0xc(%ebp)
  800e25:	6a 20                	push   $0x20
  800e27:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2a:	ff d0                	call   *%eax
  800e2c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e2f:	ff 4d e4             	decl   -0x1c(%ebp)
  800e32:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e36:	7f e7                	jg     800e1f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e38:	e9 66 01 00 00       	jmp    800fa3 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e3d:	83 ec 08             	sub    $0x8,%esp
  800e40:	ff 75 e8             	pushl  -0x18(%ebp)
  800e43:	8d 45 14             	lea    0x14(%ebp),%eax
  800e46:	50                   	push   %eax
  800e47:	e8 3c fd ff ff       	call   800b88 <getint>
  800e4c:	83 c4 10             	add    $0x10,%esp
  800e4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e52:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e58:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e5b:	85 d2                	test   %edx,%edx
  800e5d:	79 23                	jns    800e82 <vprintfmt+0x29b>
				putch('-', putdat);
  800e5f:	83 ec 08             	sub    $0x8,%esp
  800e62:	ff 75 0c             	pushl  0xc(%ebp)
  800e65:	6a 2d                	push   $0x2d
  800e67:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6a:	ff d0                	call   *%eax
  800e6c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e75:	f7 d8                	neg    %eax
  800e77:	83 d2 00             	adc    $0x0,%edx
  800e7a:	f7 da                	neg    %edx
  800e7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e7f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e82:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e89:	e9 bc 00 00 00       	jmp    800f4a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e8e:	83 ec 08             	sub    $0x8,%esp
  800e91:	ff 75 e8             	pushl  -0x18(%ebp)
  800e94:	8d 45 14             	lea    0x14(%ebp),%eax
  800e97:	50                   	push   %eax
  800e98:	e8 84 fc ff ff       	call   800b21 <getuint>
  800e9d:	83 c4 10             	add    $0x10,%esp
  800ea0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ea3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ea6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ead:	e9 98 00 00 00       	jmp    800f4a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800eb2:	83 ec 08             	sub    $0x8,%esp
  800eb5:	ff 75 0c             	pushl  0xc(%ebp)
  800eb8:	6a 58                	push   $0x58
  800eba:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebd:	ff d0                	call   *%eax
  800ebf:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ec2:	83 ec 08             	sub    $0x8,%esp
  800ec5:	ff 75 0c             	pushl  0xc(%ebp)
  800ec8:	6a 58                	push   $0x58
  800eca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecd:	ff d0                	call   *%eax
  800ecf:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ed2:	83 ec 08             	sub    $0x8,%esp
  800ed5:	ff 75 0c             	pushl  0xc(%ebp)
  800ed8:	6a 58                	push   $0x58
  800eda:	8b 45 08             	mov    0x8(%ebp),%eax
  800edd:	ff d0                	call   *%eax
  800edf:	83 c4 10             	add    $0x10,%esp
			break;
  800ee2:	e9 bc 00 00 00       	jmp    800fa3 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800ee7:	83 ec 08             	sub    $0x8,%esp
  800eea:	ff 75 0c             	pushl  0xc(%ebp)
  800eed:	6a 30                	push   $0x30
  800eef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef2:	ff d0                	call   *%eax
  800ef4:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ef7:	83 ec 08             	sub    $0x8,%esp
  800efa:	ff 75 0c             	pushl  0xc(%ebp)
  800efd:	6a 78                	push   $0x78
  800eff:	8b 45 08             	mov    0x8(%ebp),%eax
  800f02:	ff d0                	call   *%eax
  800f04:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f07:	8b 45 14             	mov    0x14(%ebp),%eax
  800f0a:	83 c0 04             	add    $0x4,%eax
  800f0d:	89 45 14             	mov    %eax,0x14(%ebp)
  800f10:	8b 45 14             	mov    0x14(%ebp),%eax
  800f13:	83 e8 04             	sub    $0x4,%eax
  800f16:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f18:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f1b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f22:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f29:	eb 1f                	jmp    800f4a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f2b:	83 ec 08             	sub    $0x8,%esp
  800f2e:	ff 75 e8             	pushl  -0x18(%ebp)
  800f31:	8d 45 14             	lea    0x14(%ebp),%eax
  800f34:	50                   	push   %eax
  800f35:	e8 e7 fb ff ff       	call   800b21 <getuint>
  800f3a:	83 c4 10             	add    $0x10,%esp
  800f3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f40:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f43:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f4a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f51:	83 ec 04             	sub    $0x4,%esp
  800f54:	52                   	push   %edx
  800f55:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f58:	50                   	push   %eax
  800f59:	ff 75 f4             	pushl  -0xc(%ebp)
  800f5c:	ff 75 f0             	pushl  -0x10(%ebp)
  800f5f:	ff 75 0c             	pushl  0xc(%ebp)
  800f62:	ff 75 08             	pushl  0x8(%ebp)
  800f65:	e8 00 fb ff ff       	call   800a6a <printnum>
  800f6a:	83 c4 20             	add    $0x20,%esp
			break;
  800f6d:	eb 34                	jmp    800fa3 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f6f:	83 ec 08             	sub    $0x8,%esp
  800f72:	ff 75 0c             	pushl  0xc(%ebp)
  800f75:	53                   	push   %ebx
  800f76:	8b 45 08             	mov    0x8(%ebp),%eax
  800f79:	ff d0                	call   *%eax
  800f7b:	83 c4 10             	add    $0x10,%esp
			break;
  800f7e:	eb 23                	jmp    800fa3 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f80:	83 ec 08             	sub    $0x8,%esp
  800f83:	ff 75 0c             	pushl  0xc(%ebp)
  800f86:	6a 25                	push   $0x25
  800f88:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8b:	ff d0                	call   *%eax
  800f8d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f90:	ff 4d 10             	decl   0x10(%ebp)
  800f93:	eb 03                	jmp    800f98 <vprintfmt+0x3b1>
  800f95:	ff 4d 10             	decl   0x10(%ebp)
  800f98:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9b:	48                   	dec    %eax
  800f9c:	8a 00                	mov    (%eax),%al
  800f9e:	3c 25                	cmp    $0x25,%al
  800fa0:	75 f3                	jne    800f95 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800fa2:	90                   	nop
		}
	}
  800fa3:	e9 47 fc ff ff       	jmp    800bef <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800fa8:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800fa9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fac:	5b                   	pop    %ebx
  800fad:	5e                   	pop    %esi
  800fae:	5d                   	pop    %ebp
  800faf:	c3                   	ret    

00800fb0 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800fb0:	55                   	push   %ebp
  800fb1:	89 e5                	mov    %esp,%ebp
  800fb3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800fb6:	8d 45 10             	lea    0x10(%ebp),%eax
  800fb9:	83 c0 04             	add    $0x4,%eax
  800fbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800fbf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc2:	ff 75 f4             	pushl  -0xc(%ebp)
  800fc5:	50                   	push   %eax
  800fc6:	ff 75 0c             	pushl  0xc(%ebp)
  800fc9:	ff 75 08             	pushl  0x8(%ebp)
  800fcc:	e8 16 fc ff ff       	call   800be7 <vprintfmt>
  800fd1:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800fd4:	90                   	nop
  800fd5:	c9                   	leave  
  800fd6:	c3                   	ret    

00800fd7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fd7:	55                   	push   %ebp
  800fd8:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800fda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdd:	8b 40 08             	mov    0x8(%eax),%eax
  800fe0:	8d 50 01             	lea    0x1(%eax),%edx
  800fe3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe6:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800fe9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fec:	8b 10                	mov    (%eax),%edx
  800fee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff1:	8b 40 04             	mov    0x4(%eax),%eax
  800ff4:	39 c2                	cmp    %eax,%edx
  800ff6:	73 12                	jae    80100a <sprintputch+0x33>
		*b->buf++ = ch;
  800ff8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffb:	8b 00                	mov    (%eax),%eax
  800ffd:	8d 48 01             	lea    0x1(%eax),%ecx
  801000:	8b 55 0c             	mov    0xc(%ebp),%edx
  801003:	89 0a                	mov    %ecx,(%edx)
  801005:	8b 55 08             	mov    0x8(%ebp),%edx
  801008:	88 10                	mov    %dl,(%eax)
}
  80100a:	90                   	nop
  80100b:	5d                   	pop    %ebp
  80100c:	c3                   	ret    

0080100d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80100d:	55                   	push   %ebp
  80100e:	89 e5                	mov    %esp,%ebp
  801010:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
  801016:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801019:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80101f:	8b 45 08             	mov    0x8(%ebp),%eax
  801022:	01 d0                	add    %edx,%eax
  801024:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801027:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80102e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801032:	74 06                	je     80103a <vsnprintf+0x2d>
  801034:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801038:	7f 07                	jg     801041 <vsnprintf+0x34>
		return -E_INVAL;
  80103a:	b8 03 00 00 00       	mov    $0x3,%eax
  80103f:	eb 20                	jmp    801061 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801041:	ff 75 14             	pushl  0x14(%ebp)
  801044:	ff 75 10             	pushl  0x10(%ebp)
  801047:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80104a:	50                   	push   %eax
  80104b:	68 d7 0f 80 00       	push   $0x800fd7
  801050:	e8 92 fb ff ff       	call   800be7 <vprintfmt>
  801055:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801058:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80105b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80105e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801061:	c9                   	leave  
  801062:	c3                   	ret    

00801063 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801063:	55                   	push   %ebp
  801064:	89 e5                	mov    %esp,%ebp
  801066:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801069:	8d 45 10             	lea    0x10(%ebp),%eax
  80106c:	83 c0 04             	add    $0x4,%eax
  80106f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801072:	8b 45 10             	mov    0x10(%ebp),%eax
  801075:	ff 75 f4             	pushl  -0xc(%ebp)
  801078:	50                   	push   %eax
  801079:	ff 75 0c             	pushl  0xc(%ebp)
  80107c:	ff 75 08             	pushl  0x8(%ebp)
  80107f:	e8 89 ff ff ff       	call   80100d <vsnprintf>
  801084:	83 c4 10             	add    $0x10,%esp
  801087:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80108a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80108d:	c9                   	leave  
  80108e:	c3                   	ret    

0080108f <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80108f:	55                   	push   %ebp
  801090:	89 e5                	mov    %esp,%ebp
  801092:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801095:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80109c:	eb 06                	jmp    8010a4 <strlen+0x15>
		n++;
  80109e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8010a1:	ff 45 08             	incl   0x8(%ebp)
  8010a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a7:	8a 00                	mov    (%eax),%al
  8010a9:	84 c0                	test   %al,%al
  8010ab:	75 f1                	jne    80109e <strlen+0xf>
		n++;
	return n;
  8010ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010b0:	c9                   	leave  
  8010b1:	c3                   	ret    

008010b2 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8010b2:	55                   	push   %ebp
  8010b3:	89 e5                	mov    %esp,%ebp
  8010b5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010bf:	eb 09                	jmp    8010ca <strnlen+0x18>
		n++;
  8010c1:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010c4:	ff 45 08             	incl   0x8(%ebp)
  8010c7:	ff 4d 0c             	decl   0xc(%ebp)
  8010ca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010ce:	74 09                	je     8010d9 <strnlen+0x27>
  8010d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d3:	8a 00                	mov    (%eax),%al
  8010d5:	84 c0                	test   %al,%al
  8010d7:	75 e8                	jne    8010c1 <strnlen+0xf>
		n++;
	return n;
  8010d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010dc:	c9                   	leave  
  8010dd:	c3                   	ret    

008010de <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010de:	55                   	push   %ebp
  8010df:	89 e5                	mov    %esp,%ebp
  8010e1:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8010e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8010ea:	90                   	nop
  8010eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ee:	8d 50 01             	lea    0x1(%eax),%edx
  8010f1:	89 55 08             	mov    %edx,0x8(%ebp)
  8010f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010fa:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010fd:	8a 12                	mov    (%edx),%dl
  8010ff:	88 10                	mov    %dl,(%eax)
  801101:	8a 00                	mov    (%eax),%al
  801103:	84 c0                	test   %al,%al
  801105:	75 e4                	jne    8010eb <strcpy+0xd>
		/* do nothing */;
	return ret;
  801107:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80110a:	c9                   	leave  
  80110b:	c3                   	ret    

0080110c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80110c:	55                   	push   %ebp
  80110d:	89 e5                	mov    %esp,%ebp
  80110f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801112:	8b 45 08             	mov    0x8(%ebp),%eax
  801115:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801118:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80111f:	eb 1f                	jmp    801140 <strncpy+0x34>
		*dst++ = *src;
  801121:	8b 45 08             	mov    0x8(%ebp),%eax
  801124:	8d 50 01             	lea    0x1(%eax),%edx
  801127:	89 55 08             	mov    %edx,0x8(%ebp)
  80112a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80112d:	8a 12                	mov    (%edx),%dl
  80112f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801131:	8b 45 0c             	mov    0xc(%ebp),%eax
  801134:	8a 00                	mov    (%eax),%al
  801136:	84 c0                	test   %al,%al
  801138:	74 03                	je     80113d <strncpy+0x31>
			src++;
  80113a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80113d:	ff 45 fc             	incl   -0x4(%ebp)
  801140:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801143:	3b 45 10             	cmp    0x10(%ebp),%eax
  801146:	72 d9                	jb     801121 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801148:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80114b:	c9                   	leave  
  80114c:	c3                   	ret    

0080114d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80114d:	55                   	push   %ebp
  80114e:	89 e5                	mov    %esp,%ebp
  801150:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801153:	8b 45 08             	mov    0x8(%ebp),%eax
  801156:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801159:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80115d:	74 30                	je     80118f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80115f:	eb 16                	jmp    801177 <strlcpy+0x2a>
			*dst++ = *src++;
  801161:	8b 45 08             	mov    0x8(%ebp),%eax
  801164:	8d 50 01             	lea    0x1(%eax),%edx
  801167:	89 55 08             	mov    %edx,0x8(%ebp)
  80116a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80116d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801170:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801173:	8a 12                	mov    (%edx),%dl
  801175:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801177:	ff 4d 10             	decl   0x10(%ebp)
  80117a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80117e:	74 09                	je     801189 <strlcpy+0x3c>
  801180:	8b 45 0c             	mov    0xc(%ebp),%eax
  801183:	8a 00                	mov    (%eax),%al
  801185:	84 c0                	test   %al,%al
  801187:	75 d8                	jne    801161 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801189:	8b 45 08             	mov    0x8(%ebp),%eax
  80118c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80118f:	8b 55 08             	mov    0x8(%ebp),%edx
  801192:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801195:	29 c2                	sub    %eax,%edx
  801197:	89 d0                	mov    %edx,%eax
}
  801199:	c9                   	leave  
  80119a:	c3                   	ret    

0080119b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80119b:	55                   	push   %ebp
  80119c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80119e:	eb 06                	jmp    8011a6 <strcmp+0xb>
		p++, q++;
  8011a0:	ff 45 08             	incl   0x8(%ebp)
  8011a3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a9:	8a 00                	mov    (%eax),%al
  8011ab:	84 c0                	test   %al,%al
  8011ad:	74 0e                	je     8011bd <strcmp+0x22>
  8011af:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b2:	8a 10                	mov    (%eax),%dl
  8011b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b7:	8a 00                	mov    (%eax),%al
  8011b9:	38 c2                	cmp    %al,%dl
  8011bb:	74 e3                	je     8011a0 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c0:	8a 00                	mov    (%eax),%al
  8011c2:	0f b6 d0             	movzbl %al,%edx
  8011c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c8:	8a 00                	mov    (%eax),%al
  8011ca:	0f b6 c0             	movzbl %al,%eax
  8011cd:	29 c2                	sub    %eax,%edx
  8011cf:	89 d0                	mov    %edx,%eax
}
  8011d1:	5d                   	pop    %ebp
  8011d2:	c3                   	ret    

008011d3 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8011d3:	55                   	push   %ebp
  8011d4:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8011d6:	eb 09                	jmp    8011e1 <strncmp+0xe>
		n--, p++, q++;
  8011d8:	ff 4d 10             	decl   0x10(%ebp)
  8011db:	ff 45 08             	incl   0x8(%ebp)
  8011de:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8011e1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011e5:	74 17                	je     8011fe <strncmp+0x2b>
  8011e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ea:	8a 00                	mov    (%eax),%al
  8011ec:	84 c0                	test   %al,%al
  8011ee:	74 0e                	je     8011fe <strncmp+0x2b>
  8011f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f3:	8a 10                	mov    (%eax),%dl
  8011f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f8:	8a 00                	mov    (%eax),%al
  8011fa:	38 c2                	cmp    %al,%dl
  8011fc:	74 da                	je     8011d8 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8011fe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801202:	75 07                	jne    80120b <strncmp+0x38>
		return 0;
  801204:	b8 00 00 00 00       	mov    $0x0,%eax
  801209:	eb 14                	jmp    80121f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80120b:	8b 45 08             	mov    0x8(%ebp),%eax
  80120e:	8a 00                	mov    (%eax),%al
  801210:	0f b6 d0             	movzbl %al,%edx
  801213:	8b 45 0c             	mov    0xc(%ebp),%eax
  801216:	8a 00                	mov    (%eax),%al
  801218:	0f b6 c0             	movzbl %al,%eax
  80121b:	29 c2                	sub    %eax,%edx
  80121d:	89 d0                	mov    %edx,%eax
}
  80121f:	5d                   	pop    %ebp
  801220:	c3                   	ret    

00801221 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801221:	55                   	push   %ebp
  801222:	89 e5                	mov    %esp,%ebp
  801224:	83 ec 04             	sub    $0x4,%esp
  801227:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80122d:	eb 12                	jmp    801241 <strchr+0x20>
		if (*s == c)
  80122f:	8b 45 08             	mov    0x8(%ebp),%eax
  801232:	8a 00                	mov    (%eax),%al
  801234:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801237:	75 05                	jne    80123e <strchr+0x1d>
			return (char *) s;
  801239:	8b 45 08             	mov    0x8(%ebp),%eax
  80123c:	eb 11                	jmp    80124f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80123e:	ff 45 08             	incl   0x8(%ebp)
  801241:	8b 45 08             	mov    0x8(%ebp),%eax
  801244:	8a 00                	mov    (%eax),%al
  801246:	84 c0                	test   %al,%al
  801248:	75 e5                	jne    80122f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80124a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80124f:	c9                   	leave  
  801250:	c3                   	ret    

00801251 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801251:	55                   	push   %ebp
  801252:	89 e5                	mov    %esp,%ebp
  801254:	83 ec 04             	sub    $0x4,%esp
  801257:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80125d:	eb 0d                	jmp    80126c <strfind+0x1b>
		if (*s == c)
  80125f:	8b 45 08             	mov    0x8(%ebp),%eax
  801262:	8a 00                	mov    (%eax),%al
  801264:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801267:	74 0e                	je     801277 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801269:	ff 45 08             	incl   0x8(%ebp)
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
  80126f:	8a 00                	mov    (%eax),%al
  801271:	84 c0                	test   %al,%al
  801273:	75 ea                	jne    80125f <strfind+0xe>
  801275:	eb 01                	jmp    801278 <strfind+0x27>
		if (*s == c)
			break;
  801277:	90                   	nop
	return (char *) s;
  801278:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80127b:	c9                   	leave  
  80127c:	c3                   	ret    

0080127d <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80127d:	55                   	push   %ebp
  80127e:	89 e5                	mov    %esp,%ebp
  801280:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801283:	8b 45 08             	mov    0x8(%ebp),%eax
  801286:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801289:	8b 45 10             	mov    0x10(%ebp),%eax
  80128c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80128f:	eb 0e                	jmp    80129f <memset+0x22>
		*p++ = c;
  801291:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801294:	8d 50 01             	lea    0x1(%eax),%edx
  801297:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80129a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80129d:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80129f:	ff 4d f8             	decl   -0x8(%ebp)
  8012a2:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8012a6:	79 e9                	jns    801291 <memset+0x14>
		*p++ = c;

	return v;
  8012a8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012ab:	c9                   	leave  
  8012ac:	c3                   	ret    

008012ad <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8012ad:	55                   	push   %ebp
  8012ae:	89 e5                	mov    %esp,%ebp
  8012b0:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8012b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8012bf:	eb 16                	jmp    8012d7 <memcpy+0x2a>
		*d++ = *s++;
  8012c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c4:	8d 50 01             	lea    0x1(%eax),%edx
  8012c7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012cd:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012d0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012d3:	8a 12                	mov    (%edx),%dl
  8012d5:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8012d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8012da:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012dd:	89 55 10             	mov    %edx,0x10(%ebp)
  8012e0:	85 c0                	test   %eax,%eax
  8012e2:	75 dd                	jne    8012c1 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8012e4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012e7:	c9                   	leave  
  8012e8:	c3                   	ret    

008012e9 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8012e9:	55                   	push   %ebp
  8012ea:	89 e5                	mov    %esp,%ebp
  8012ec:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8012ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8012fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012fe:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801301:	73 50                	jae    801353 <memmove+0x6a>
  801303:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801306:	8b 45 10             	mov    0x10(%ebp),%eax
  801309:	01 d0                	add    %edx,%eax
  80130b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80130e:	76 43                	jbe    801353 <memmove+0x6a>
		s += n;
  801310:	8b 45 10             	mov    0x10(%ebp),%eax
  801313:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801316:	8b 45 10             	mov    0x10(%ebp),%eax
  801319:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80131c:	eb 10                	jmp    80132e <memmove+0x45>
			*--d = *--s;
  80131e:	ff 4d f8             	decl   -0x8(%ebp)
  801321:	ff 4d fc             	decl   -0x4(%ebp)
  801324:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801327:	8a 10                	mov    (%eax),%dl
  801329:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80132c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80132e:	8b 45 10             	mov    0x10(%ebp),%eax
  801331:	8d 50 ff             	lea    -0x1(%eax),%edx
  801334:	89 55 10             	mov    %edx,0x10(%ebp)
  801337:	85 c0                	test   %eax,%eax
  801339:	75 e3                	jne    80131e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80133b:	eb 23                	jmp    801360 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80133d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801340:	8d 50 01             	lea    0x1(%eax),%edx
  801343:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801346:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801349:	8d 4a 01             	lea    0x1(%edx),%ecx
  80134c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80134f:	8a 12                	mov    (%edx),%dl
  801351:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801353:	8b 45 10             	mov    0x10(%ebp),%eax
  801356:	8d 50 ff             	lea    -0x1(%eax),%edx
  801359:	89 55 10             	mov    %edx,0x10(%ebp)
  80135c:	85 c0                	test   %eax,%eax
  80135e:	75 dd                	jne    80133d <memmove+0x54>
			*d++ = *s++;

	return dst;
  801360:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801363:	c9                   	leave  
  801364:	c3                   	ret    

00801365 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801365:	55                   	push   %ebp
  801366:	89 e5                	mov    %esp,%ebp
  801368:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80136b:	8b 45 08             	mov    0x8(%ebp),%eax
  80136e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801371:	8b 45 0c             	mov    0xc(%ebp),%eax
  801374:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801377:	eb 2a                	jmp    8013a3 <memcmp+0x3e>
		if (*s1 != *s2)
  801379:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80137c:	8a 10                	mov    (%eax),%dl
  80137e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801381:	8a 00                	mov    (%eax),%al
  801383:	38 c2                	cmp    %al,%dl
  801385:	74 16                	je     80139d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801387:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80138a:	8a 00                	mov    (%eax),%al
  80138c:	0f b6 d0             	movzbl %al,%edx
  80138f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801392:	8a 00                	mov    (%eax),%al
  801394:	0f b6 c0             	movzbl %al,%eax
  801397:	29 c2                	sub    %eax,%edx
  801399:	89 d0                	mov    %edx,%eax
  80139b:	eb 18                	jmp    8013b5 <memcmp+0x50>
		s1++, s2++;
  80139d:	ff 45 fc             	incl   -0x4(%ebp)
  8013a0:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8013a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013a9:	89 55 10             	mov    %edx,0x10(%ebp)
  8013ac:	85 c0                	test   %eax,%eax
  8013ae:	75 c9                	jne    801379 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013b5:	c9                   	leave  
  8013b6:	c3                   	ret    

008013b7 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8013b7:	55                   	push   %ebp
  8013b8:	89 e5                	mov    %esp,%ebp
  8013ba:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8013bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8013c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c3:	01 d0                	add    %edx,%eax
  8013c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8013c8:	eb 15                	jmp    8013df <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cd:	8a 00                	mov    (%eax),%al
  8013cf:	0f b6 d0             	movzbl %al,%edx
  8013d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d5:	0f b6 c0             	movzbl %al,%eax
  8013d8:	39 c2                	cmp    %eax,%edx
  8013da:	74 0d                	je     8013e9 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013dc:	ff 45 08             	incl   0x8(%ebp)
  8013df:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8013e5:	72 e3                	jb     8013ca <memfind+0x13>
  8013e7:	eb 01                	jmp    8013ea <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8013e9:	90                   	nop
	return (void *) s;
  8013ea:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013ed:	c9                   	leave  
  8013ee:	c3                   	ret    

008013ef <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013ef:	55                   	push   %ebp
  8013f0:	89 e5                	mov    %esp,%ebp
  8013f2:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8013f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8013fc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801403:	eb 03                	jmp    801408 <strtol+0x19>
		s++;
  801405:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801408:	8b 45 08             	mov    0x8(%ebp),%eax
  80140b:	8a 00                	mov    (%eax),%al
  80140d:	3c 20                	cmp    $0x20,%al
  80140f:	74 f4                	je     801405 <strtol+0x16>
  801411:	8b 45 08             	mov    0x8(%ebp),%eax
  801414:	8a 00                	mov    (%eax),%al
  801416:	3c 09                	cmp    $0x9,%al
  801418:	74 eb                	je     801405 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80141a:	8b 45 08             	mov    0x8(%ebp),%eax
  80141d:	8a 00                	mov    (%eax),%al
  80141f:	3c 2b                	cmp    $0x2b,%al
  801421:	75 05                	jne    801428 <strtol+0x39>
		s++;
  801423:	ff 45 08             	incl   0x8(%ebp)
  801426:	eb 13                	jmp    80143b <strtol+0x4c>
	else if (*s == '-')
  801428:	8b 45 08             	mov    0x8(%ebp),%eax
  80142b:	8a 00                	mov    (%eax),%al
  80142d:	3c 2d                	cmp    $0x2d,%al
  80142f:	75 0a                	jne    80143b <strtol+0x4c>
		s++, neg = 1;
  801431:	ff 45 08             	incl   0x8(%ebp)
  801434:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80143b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80143f:	74 06                	je     801447 <strtol+0x58>
  801441:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801445:	75 20                	jne    801467 <strtol+0x78>
  801447:	8b 45 08             	mov    0x8(%ebp),%eax
  80144a:	8a 00                	mov    (%eax),%al
  80144c:	3c 30                	cmp    $0x30,%al
  80144e:	75 17                	jne    801467 <strtol+0x78>
  801450:	8b 45 08             	mov    0x8(%ebp),%eax
  801453:	40                   	inc    %eax
  801454:	8a 00                	mov    (%eax),%al
  801456:	3c 78                	cmp    $0x78,%al
  801458:	75 0d                	jne    801467 <strtol+0x78>
		s += 2, base = 16;
  80145a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80145e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801465:	eb 28                	jmp    80148f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801467:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80146b:	75 15                	jne    801482 <strtol+0x93>
  80146d:	8b 45 08             	mov    0x8(%ebp),%eax
  801470:	8a 00                	mov    (%eax),%al
  801472:	3c 30                	cmp    $0x30,%al
  801474:	75 0c                	jne    801482 <strtol+0x93>
		s++, base = 8;
  801476:	ff 45 08             	incl   0x8(%ebp)
  801479:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801480:	eb 0d                	jmp    80148f <strtol+0xa0>
	else if (base == 0)
  801482:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801486:	75 07                	jne    80148f <strtol+0xa0>
		base = 10;
  801488:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80148f:	8b 45 08             	mov    0x8(%ebp),%eax
  801492:	8a 00                	mov    (%eax),%al
  801494:	3c 2f                	cmp    $0x2f,%al
  801496:	7e 19                	jle    8014b1 <strtol+0xc2>
  801498:	8b 45 08             	mov    0x8(%ebp),%eax
  80149b:	8a 00                	mov    (%eax),%al
  80149d:	3c 39                	cmp    $0x39,%al
  80149f:	7f 10                	jg     8014b1 <strtol+0xc2>
			dig = *s - '0';
  8014a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a4:	8a 00                	mov    (%eax),%al
  8014a6:	0f be c0             	movsbl %al,%eax
  8014a9:	83 e8 30             	sub    $0x30,%eax
  8014ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014af:	eb 42                	jmp    8014f3 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8014b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b4:	8a 00                	mov    (%eax),%al
  8014b6:	3c 60                	cmp    $0x60,%al
  8014b8:	7e 19                	jle    8014d3 <strtol+0xe4>
  8014ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bd:	8a 00                	mov    (%eax),%al
  8014bf:	3c 7a                	cmp    $0x7a,%al
  8014c1:	7f 10                	jg     8014d3 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8014c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c6:	8a 00                	mov    (%eax),%al
  8014c8:	0f be c0             	movsbl %al,%eax
  8014cb:	83 e8 57             	sub    $0x57,%eax
  8014ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014d1:	eb 20                	jmp    8014f3 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8014d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d6:	8a 00                	mov    (%eax),%al
  8014d8:	3c 40                	cmp    $0x40,%al
  8014da:	7e 39                	jle    801515 <strtol+0x126>
  8014dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014df:	8a 00                	mov    (%eax),%al
  8014e1:	3c 5a                	cmp    $0x5a,%al
  8014e3:	7f 30                	jg     801515 <strtol+0x126>
			dig = *s - 'A' + 10;
  8014e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e8:	8a 00                	mov    (%eax),%al
  8014ea:	0f be c0             	movsbl %al,%eax
  8014ed:	83 e8 37             	sub    $0x37,%eax
  8014f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8014f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014f6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014f9:	7d 19                	jge    801514 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8014fb:	ff 45 08             	incl   0x8(%ebp)
  8014fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801501:	0f af 45 10          	imul   0x10(%ebp),%eax
  801505:	89 c2                	mov    %eax,%edx
  801507:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80150a:	01 d0                	add    %edx,%eax
  80150c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80150f:	e9 7b ff ff ff       	jmp    80148f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801514:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801515:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801519:	74 08                	je     801523 <strtol+0x134>
		*endptr = (char *) s;
  80151b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151e:	8b 55 08             	mov    0x8(%ebp),%edx
  801521:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801523:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801527:	74 07                	je     801530 <strtol+0x141>
  801529:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80152c:	f7 d8                	neg    %eax
  80152e:	eb 03                	jmp    801533 <strtol+0x144>
  801530:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801533:	c9                   	leave  
  801534:	c3                   	ret    

00801535 <ltostr>:

void
ltostr(long value, char *str)
{
  801535:	55                   	push   %ebp
  801536:	89 e5                	mov    %esp,%ebp
  801538:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80153b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801542:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801549:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80154d:	79 13                	jns    801562 <ltostr+0x2d>
	{
		neg = 1;
  80154f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801556:	8b 45 0c             	mov    0xc(%ebp),%eax
  801559:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80155c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80155f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801562:	8b 45 08             	mov    0x8(%ebp),%eax
  801565:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80156a:	99                   	cltd   
  80156b:	f7 f9                	idiv   %ecx
  80156d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801570:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801573:	8d 50 01             	lea    0x1(%eax),%edx
  801576:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801579:	89 c2                	mov    %eax,%edx
  80157b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157e:	01 d0                	add    %edx,%eax
  801580:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801583:	83 c2 30             	add    $0x30,%edx
  801586:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801588:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80158b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801590:	f7 e9                	imul   %ecx
  801592:	c1 fa 02             	sar    $0x2,%edx
  801595:	89 c8                	mov    %ecx,%eax
  801597:	c1 f8 1f             	sar    $0x1f,%eax
  80159a:	29 c2                	sub    %eax,%edx
  80159c:	89 d0                	mov    %edx,%eax
  80159e:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8015a1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015a4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015a9:	f7 e9                	imul   %ecx
  8015ab:	c1 fa 02             	sar    $0x2,%edx
  8015ae:	89 c8                	mov    %ecx,%eax
  8015b0:	c1 f8 1f             	sar    $0x1f,%eax
  8015b3:	29 c2                	sub    %eax,%edx
  8015b5:	89 d0                	mov    %edx,%eax
  8015b7:	c1 e0 02             	shl    $0x2,%eax
  8015ba:	01 d0                	add    %edx,%eax
  8015bc:	01 c0                	add    %eax,%eax
  8015be:	29 c1                	sub    %eax,%ecx
  8015c0:	89 ca                	mov    %ecx,%edx
  8015c2:	85 d2                	test   %edx,%edx
  8015c4:	75 9c                	jne    801562 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8015c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8015cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015d0:	48                   	dec    %eax
  8015d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8015d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8015d8:	74 3d                	je     801617 <ltostr+0xe2>
		start = 1 ;
  8015da:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8015e1:	eb 34                	jmp    801617 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8015e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e9:	01 d0                	add    %edx,%eax
  8015eb:	8a 00                	mov    (%eax),%al
  8015ed:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8015f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f6:	01 c2                	add    %eax,%edx
  8015f8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8015fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015fe:	01 c8                	add    %ecx,%eax
  801600:	8a 00                	mov    (%eax),%al
  801602:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801604:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801607:	8b 45 0c             	mov    0xc(%ebp),%eax
  80160a:	01 c2                	add    %eax,%edx
  80160c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80160f:	88 02                	mov    %al,(%edx)
		start++ ;
  801611:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801614:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801617:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80161a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80161d:	7c c4                	jl     8015e3 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80161f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801622:	8b 45 0c             	mov    0xc(%ebp),%eax
  801625:	01 d0                	add    %edx,%eax
  801627:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80162a:	90                   	nop
  80162b:	c9                   	leave  
  80162c:	c3                   	ret    

0080162d <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80162d:	55                   	push   %ebp
  80162e:	89 e5                	mov    %esp,%ebp
  801630:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801633:	ff 75 08             	pushl  0x8(%ebp)
  801636:	e8 54 fa ff ff       	call   80108f <strlen>
  80163b:	83 c4 04             	add    $0x4,%esp
  80163e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801641:	ff 75 0c             	pushl  0xc(%ebp)
  801644:	e8 46 fa ff ff       	call   80108f <strlen>
  801649:	83 c4 04             	add    $0x4,%esp
  80164c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80164f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801656:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80165d:	eb 17                	jmp    801676 <strcconcat+0x49>
		final[s] = str1[s] ;
  80165f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801662:	8b 45 10             	mov    0x10(%ebp),%eax
  801665:	01 c2                	add    %eax,%edx
  801667:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80166a:	8b 45 08             	mov    0x8(%ebp),%eax
  80166d:	01 c8                	add    %ecx,%eax
  80166f:	8a 00                	mov    (%eax),%al
  801671:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801673:	ff 45 fc             	incl   -0x4(%ebp)
  801676:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801679:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80167c:	7c e1                	jl     80165f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80167e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801685:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80168c:	eb 1f                	jmp    8016ad <strcconcat+0x80>
		final[s++] = str2[i] ;
  80168e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801691:	8d 50 01             	lea    0x1(%eax),%edx
  801694:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801697:	89 c2                	mov    %eax,%edx
  801699:	8b 45 10             	mov    0x10(%ebp),%eax
  80169c:	01 c2                	add    %eax,%edx
  80169e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8016a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a4:	01 c8                	add    %ecx,%eax
  8016a6:	8a 00                	mov    (%eax),%al
  8016a8:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8016aa:	ff 45 f8             	incl   -0x8(%ebp)
  8016ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016b0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016b3:	7c d9                	jl     80168e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8016b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8016bb:	01 d0                	add    %edx,%eax
  8016bd:	c6 00 00             	movb   $0x0,(%eax)
}
  8016c0:	90                   	nop
  8016c1:	c9                   	leave  
  8016c2:	c3                   	ret    

008016c3 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8016c3:	55                   	push   %ebp
  8016c4:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8016c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8016c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8016cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8016d2:	8b 00                	mov    (%eax),%eax
  8016d4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016db:	8b 45 10             	mov    0x10(%ebp),%eax
  8016de:	01 d0                	add    %edx,%eax
  8016e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016e6:	eb 0c                	jmp    8016f4 <strsplit+0x31>
			*string++ = 0;
  8016e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016eb:	8d 50 01             	lea    0x1(%eax),%edx
  8016ee:	89 55 08             	mov    %edx,0x8(%ebp)
  8016f1:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f7:	8a 00                	mov    (%eax),%al
  8016f9:	84 c0                	test   %al,%al
  8016fb:	74 18                	je     801715 <strsplit+0x52>
  8016fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801700:	8a 00                	mov    (%eax),%al
  801702:	0f be c0             	movsbl %al,%eax
  801705:	50                   	push   %eax
  801706:	ff 75 0c             	pushl  0xc(%ebp)
  801709:	e8 13 fb ff ff       	call   801221 <strchr>
  80170e:	83 c4 08             	add    $0x8,%esp
  801711:	85 c0                	test   %eax,%eax
  801713:	75 d3                	jne    8016e8 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801715:	8b 45 08             	mov    0x8(%ebp),%eax
  801718:	8a 00                	mov    (%eax),%al
  80171a:	84 c0                	test   %al,%al
  80171c:	74 5a                	je     801778 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80171e:	8b 45 14             	mov    0x14(%ebp),%eax
  801721:	8b 00                	mov    (%eax),%eax
  801723:	83 f8 0f             	cmp    $0xf,%eax
  801726:	75 07                	jne    80172f <strsplit+0x6c>
		{
			return 0;
  801728:	b8 00 00 00 00       	mov    $0x0,%eax
  80172d:	eb 66                	jmp    801795 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80172f:	8b 45 14             	mov    0x14(%ebp),%eax
  801732:	8b 00                	mov    (%eax),%eax
  801734:	8d 48 01             	lea    0x1(%eax),%ecx
  801737:	8b 55 14             	mov    0x14(%ebp),%edx
  80173a:	89 0a                	mov    %ecx,(%edx)
  80173c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801743:	8b 45 10             	mov    0x10(%ebp),%eax
  801746:	01 c2                	add    %eax,%edx
  801748:	8b 45 08             	mov    0x8(%ebp),%eax
  80174b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80174d:	eb 03                	jmp    801752 <strsplit+0x8f>
			string++;
  80174f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801752:	8b 45 08             	mov    0x8(%ebp),%eax
  801755:	8a 00                	mov    (%eax),%al
  801757:	84 c0                	test   %al,%al
  801759:	74 8b                	je     8016e6 <strsplit+0x23>
  80175b:	8b 45 08             	mov    0x8(%ebp),%eax
  80175e:	8a 00                	mov    (%eax),%al
  801760:	0f be c0             	movsbl %al,%eax
  801763:	50                   	push   %eax
  801764:	ff 75 0c             	pushl  0xc(%ebp)
  801767:	e8 b5 fa ff ff       	call   801221 <strchr>
  80176c:	83 c4 08             	add    $0x8,%esp
  80176f:	85 c0                	test   %eax,%eax
  801771:	74 dc                	je     80174f <strsplit+0x8c>
			string++;
	}
  801773:	e9 6e ff ff ff       	jmp    8016e6 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801778:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801779:	8b 45 14             	mov    0x14(%ebp),%eax
  80177c:	8b 00                	mov    (%eax),%eax
  80177e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801785:	8b 45 10             	mov    0x10(%ebp),%eax
  801788:	01 d0                	add    %edx,%eax
  80178a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801790:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801795:	c9                   	leave  
  801796:	c3                   	ret    

00801797 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801797:	55                   	push   %ebp
  801798:	89 e5                	mov    %esp,%ebp
  80179a:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80179d:	a1 04 50 80 00       	mov    0x805004,%eax
  8017a2:	85 c0                	test   %eax,%eax
  8017a4:	74 1f                	je     8017c5 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8017a6:	e8 1d 00 00 00       	call   8017c8 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8017ab:	83 ec 0c             	sub    $0xc,%esp
  8017ae:	68 30 3e 80 00       	push   $0x803e30
  8017b3:	e8 55 f2 ff ff       	call   800a0d <cprintf>
  8017b8:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8017bb:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  8017c2:	00 00 00 
	}
}
  8017c5:	90                   	nop
  8017c6:	c9                   	leave  
  8017c7:	c3                   	ret    

008017c8 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8017c8:	55                   	push   %ebp
  8017c9:	89 e5                	mov    %esp,%ebp
  8017cb:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  8017ce:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  8017d5:	00 00 00 
  8017d8:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  8017df:	00 00 00 
  8017e2:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  8017e9:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  8017ec:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  8017f3:	00 00 00 
  8017f6:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  8017fd:	00 00 00 
  801800:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801807:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  80180a:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801811:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801814:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  80181b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80181e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801823:	2d 00 10 00 00       	sub    $0x1000,%eax
  801828:	a3 50 50 80 00       	mov    %eax,0x805050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  80182d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801834:	a1 20 51 80 00       	mov    0x805120,%eax
  801839:	c1 e0 04             	shl    $0x4,%eax
  80183c:	89 c2                	mov    %eax,%edx
  80183e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801841:	01 d0                	add    %edx,%eax
  801843:	48                   	dec    %eax
  801844:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801847:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80184a:	ba 00 00 00 00       	mov    $0x0,%edx
  80184f:	f7 75 f0             	divl   -0x10(%ebp)
  801852:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801855:	29 d0                	sub    %edx,%eax
  801857:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  80185a:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801861:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801864:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801869:	2d 00 10 00 00       	sub    $0x1000,%eax
  80186e:	83 ec 04             	sub    $0x4,%esp
  801871:	6a 06                	push   $0x6
  801873:	ff 75 e8             	pushl  -0x18(%ebp)
  801876:	50                   	push   %eax
  801877:	e8 b0 05 00 00       	call   801e2c <sys_allocate_chunk>
  80187c:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80187f:	a1 20 51 80 00       	mov    0x805120,%eax
  801884:	83 ec 0c             	sub    $0xc,%esp
  801887:	50                   	push   %eax
  801888:	e8 25 0c 00 00       	call   8024b2 <initialize_MemBlocksList>
  80188d:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  801890:	a1 48 51 80 00       	mov    0x805148,%eax
  801895:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  801898:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80189c:	75 14                	jne    8018b2 <initialize_dyn_block_system+0xea>
  80189e:	83 ec 04             	sub    $0x4,%esp
  8018a1:	68 55 3e 80 00       	push   $0x803e55
  8018a6:	6a 29                	push   $0x29
  8018a8:	68 73 3e 80 00       	push   $0x803e73
  8018ad:	e8 a7 ee ff ff       	call   800759 <_panic>
  8018b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018b5:	8b 00                	mov    (%eax),%eax
  8018b7:	85 c0                	test   %eax,%eax
  8018b9:	74 10                	je     8018cb <initialize_dyn_block_system+0x103>
  8018bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018be:	8b 00                	mov    (%eax),%eax
  8018c0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8018c3:	8b 52 04             	mov    0x4(%edx),%edx
  8018c6:	89 50 04             	mov    %edx,0x4(%eax)
  8018c9:	eb 0b                	jmp    8018d6 <initialize_dyn_block_system+0x10e>
  8018cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018ce:	8b 40 04             	mov    0x4(%eax),%eax
  8018d1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8018d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018d9:	8b 40 04             	mov    0x4(%eax),%eax
  8018dc:	85 c0                	test   %eax,%eax
  8018de:	74 0f                	je     8018ef <initialize_dyn_block_system+0x127>
  8018e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018e3:	8b 40 04             	mov    0x4(%eax),%eax
  8018e6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8018e9:	8b 12                	mov    (%edx),%edx
  8018eb:	89 10                	mov    %edx,(%eax)
  8018ed:	eb 0a                	jmp    8018f9 <initialize_dyn_block_system+0x131>
  8018ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018f2:	8b 00                	mov    (%eax),%eax
  8018f4:	a3 48 51 80 00       	mov    %eax,0x805148
  8018f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018fc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801902:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801905:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80190c:	a1 54 51 80 00       	mov    0x805154,%eax
  801911:	48                   	dec    %eax
  801912:	a3 54 51 80 00       	mov    %eax,0x805154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  801917:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80191a:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  801921:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801924:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  80192b:	83 ec 0c             	sub    $0xc,%esp
  80192e:	ff 75 e0             	pushl  -0x20(%ebp)
  801931:	e8 b9 14 00 00       	call   802def <insert_sorted_with_merge_freeList>
  801936:	83 c4 10             	add    $0x10,%esp

}
  801939:	90                   	nop
  80193a:	c9                   	leave  
  80193b:	c3                   	ret    

0080193c <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80193c:	55                   	push   %ebp
  80193d:	89 e5                	mov    %esp,%ebp
  80193f:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801942:	e8 50 fe ff ff       	call   801797 <InitializeUHeap>
	if (size == 0) return NULL ;
  801947:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80194b:	75 07                	jne    801954 <malloc+0x18>
  80194d:	b8 00 00 00 00       	mov    $0x0,%eax
  801952:	eb 68                	jmp    8019bc <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  801954:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80195b:	8b 55 08             	mov    0x8(%ebp),%edx
  80195e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801961:	01 d0                	add    %edx,%eax
  801963:	48                   	dec    %eax
  801964:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801967:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80196a:	ba 00 00 00 00       	mov    $0x0,%edx
  80196f:	f7 75 f4             	divl   -0xc(%ebp)
  801972:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801975:	29 d0                	sub    %edx,%eax
  801977:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  80197a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801981:	e8 74 08 00 00       	call   8021fa <sys_isUHeapPlacementStrategyFIRSTFIT>
  801986:	85 c0                	test   %eax,%eax
  801988:	74 2d                	je     8019b7 <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  80198a:	83 ec 0c             	sub    $0xc,%esp
  80198d:	ff 75 ec             	pushl  -0x14(%ebp)
  801990:	e8 52 0e 00 00       	call   8027e7 <alloc_block_FF>
  801995:	83 c4 10             	add    $0x10,%esp
  801998:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  80199b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80199f:	74 16                	je     8019b7 <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  8019a1:	83 ec 0c             	sub    $0xc,%esp
  8019a4:	ff 75 e8             	pushl  -0x18(%ebp)
  8019a7:	e8 3b 0c 00 00       	call   8025e7 <insert_sorted_allocList>
  8019ac:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  8019af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019b2:	8b 40 08             	mov    0x8(%eax),%eax
  8019b5:	eb 05                	jmp    8019bc <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  8019b7:	b8 00 00 00 00       	mov    $0x0,%eax

}
  8019bc:	c9                   	leave  
  8019bd:	c3                   	ret    

008019be <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
  8019c1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  8019c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c7:	83 ec 08             	sub    $0x8,%esp
  8019ca:	50                   	push   %eax
  8019cb:	68 40 50 80 00       	push   $0x805040
  8019d0:	e8 ba 0b 00 00       	call   80258f <find_block>
  8019d5:	83 c4 10             	add    $0x10,%esp
  8019d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  8019db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019de:	8b 40 0c             	mov    0xc(%eax),%eax
  8019e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  8019e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8019e8:	0f 84 9f 00 00 00    	je     801a8d <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  8019ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f1:	83 ec 08             	sub    $0x8,%esp
  8019f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8019f7:	50                   	push   %eax
  8019f8:	e8 f7 03 00 00       	call   801df4 <sys_free_user_mem>
  8019fd:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  801a00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a04:	75 14                	jne    801a1a <free+0x5c>
  801a06:	83 ec 04             	sub    $0x4,%esp
  801a09:	68 55 3e 80 00       	push   $0x803e55
  801a0e:	6a 6a                	push   $0x6a
  801a10:	68 73 3e 80 00       	push   $0x803e73
  801a15:	e8 3f ed ff ff       	call   800759 <_panic>
  801a1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a1d:	8b 00                	mov    (%eax),%eax
  801a1f:	85 c0                	test   %eax,%eax
  801a21:	74 10                	je     801a33 <free+0x75>
  801a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a26:	8b 00                	mov    (%eax),%eax
  801a28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a2b:	8b 52 04             	mov    0x4(%edx),%edx
  801a2e:	89 50 04             	mov    %edx,0x4(%eax)
  801a31:	eb 0b                	jmp    801a3e <free+0x80>
  801a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a36:	8b 40 04             	mov    0x4(%eax),%eax
  801a39:	a3 44 50 80 00       	mov    %eax,0x805044
  801a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a41:	8b 40 04             	mov    0x4(%eax),%eax
  801a44:	85 c0                	test   %eax,%eax
  801a46:	74 0f                	je     801a57 <free+0x99>
  801a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a4b:	8b 40 04             	mov    0x4(%eax),%eax
  801a4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a51:	8b 12                	mov    (%edx),%edx
  801a53:	89 10                	mov    %edx,(%eax)
  801a55:	eb 0a                	jmp    801a61 <free+0xa3>
  801a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a5a:	8b 00                	mov    (%eax),%eax
  801a5c:	a3 40 50 80 00       	mov    %eax,0x805040
  801a61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a64:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a6d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801a74:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801a79:	48                   	dec    %eax
  801a7a:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(blk);
  801a7f:	83 ec 0c             	sub    $0xc,%esp
  801a82:	ff 75 f4             	pushl  -0xc(%ebp)
  801a85:	e8 65 13 00 00       	call   802def <insert_sorted_with_merge_freeList>
  801a8a:	83 c4 10             	add    $0x10,%esp
	}
}
  801a8d:	90                   	nop
  801a8e:	c9                   	leave  
  801a8f:	c3                   	ret    

00801a90 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801a90:	55                   	push   %ebp
  801a91:	89 e5                	mov    %esp,%ebp
  801a93:	83 ec 28             	sub    $0x28,%esp
  801a96:	8b 45 10             	mov    0x10(%ebp),%eax
  801a99:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a9c:	e8 f6 fc ff ff       	call   801797 <InitializeUHeap>
	if (size == 0) return NULL ;
  801aa1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801aa5:	75 0a                	jne    801ab1 <smalloc+0x21>
  801aa7:	b8 00 00 00 00       	mov    $0x0,%eax
  801aac:	e9 af 00 00 00       	jmp    801b60 <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  801ab1:	e8 44 07 00 00       	call   8021fa <sys_isUHeapPlacementStrategyFIRSTFIT>
  801ab6:	83 f8 01             	cmp    $0x1,%eax
  801ab9:	0f 85 9c 00 00 00    	jne    801b5b <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  801abf:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801ac6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801acc:	01 d0                	add    %edx,%eax
  801ace:	48                   	dec    %eax
  801acf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ad2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ad5:	ba 00 00 00 00       	mov    $0x0,%edx
  801ada:	f7 75 f4             	divl   -0xc(%ebp)
  801add:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ae0:	29 d0                	sub    %edx,%eax
  801ae2:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  801ae5:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  801aec:	76 07                	jbe    801af5 <smalloc+0x65>
			return NULL;
  801aee:	b8 00 00 00 00       	mov    $0x0,%eax
  801af3:	eb 6b                	jmp    801b60 <smalloc+0xd0>
		blk =alloc_block_FF(size);
  801af5:	83 ec 0c             	sub    $0xc,%esp
  801af8:	ff 75 0c             	pushl  0xc(%ebp)
  801afb:	e8 e7 0c 00 00       	call   8027e7 <alloc_block_FF>
  801b00:	83 c4 10             	add    $0x10,%esp
  801b03:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  801b06:	83 ec 0c             	sub    $0xc,%esp
  801b09:	ff 75 ec             	pushl  -0x14(%ebp)
  801b0c:	e8 d6 0a 00 00       	call   8025e7 <insert_sorted_allocList>
  801b11:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  801b14:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b18:	75 07                	jne    801b21 <smalloc+0x91>
		{
			return NULL;
  801b1a:	b8 00 00 00 00       	mov    $0x0,%eax
  801b1f:	eb 3f                	jmp    801b60 <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  801b21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b24:	8b 40 08             	mov    0x8(%eax),%eax
  801b27:	89 c2                	mov    %eax,%edx
  801b29:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801b2d:	52                   	push   %edx
  801b2e:	50                   	push   %eax
  801b2f:	ff 75 0c             	pushl  0xc(%ebp)
  801b32:	ff 75 08             	pushl  0x8(%ebp)
  801b35:	e8 45 04 00 00       	call   801f7f <sys_createSharedObject>
  801b3a:	83 c4 10             	add    $0x10,%esp
  801b3d:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  801b40:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801b44:	74 06                	je     801b4c <smalloc+0xbc>
  801b46:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801b4a:	75 07                	jne    801b53 <smalloc+0xc3>
		{
			return NULL;
  801b4c:	b8 00 00 00 00       	mov    $0x0,%eax
  801b51:	eb 0d                	jmp    801b60 <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  801b53:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b56:	8b 40 08             	mov    0x8(%eax),%eax
  801b59:	eb 05                	jmp    801b60 <smalloc+0xd0>
		}
	}
	else
		return NULL;
  801b5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b60:	c9                   	leave  
  801b61:	c3                   	ret    

00801b62 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801b62:	55                   	push   %ebp
  801b63:	89 e5                	mov    %esp,%ebp
  801b65:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b68:	e8 2a fc ff ff       	call   801797 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801b6d:	83 ec 08             	sub    $0x8,%esp
  801b70:	ff 75 0c             	pushl  0xc(%ebp)
  801b73:	ff 75 08             	pushl  0x8(%ebp)
  801b76:	e8 2e 04 00 00       	call   801fa9 <sys_getSizeOfSharedObject>
  801b7b:	83 c4 10             	add    $0x10,%esp
  801b7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  801b81:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801b85:	75 0a                	jne    801b91 <sget+0x2f>
	{
		return NULL;
  801b87:	b8 00 00 00 00       	mov    $0x0,%eax
  801b8c:	e9 94 00 00 00       	jmp    801c25 <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801b91:	e8 64 06 00 00       	call   8021fa <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b96:	85 c0                	test   %eax,%eax
  801b98:	0f 84 82 00 00 00    	je     801c20 <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  801b9e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  801ba5:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801bac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801baf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bb2:	01 d0                	add    %edx,%eax
  801bb4:	48                   	dec    %eax
  801bb5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801bb8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bbb:	ba 00 00 00 00       	mov    $0x0,%edx
  801bc0:	f7 75 ec             	divl   -0x14(%ebp)
  801bc3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bc6:	29 d0                	sub    %edx,%eax
  801bc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  801bcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bce:	83 ec 0c             	sub    $0xc,%esp
  801bd1:	50                   	push   %eax
  801bd2:	e8 10 0c 00 00       	call   8027e7 <alloc_block_FF>
  801bd7:	83 c4 10             	add    $0x10,%esp
  801bda:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  801bdd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801be1:	75 07                	jne    801bea <sget+0x88>
		{
			return NULL;
  801be3:	b8 00 00 00 00       	mov    $0x0,%eax
  801be8:	eb 3b                	jmp    801c25 <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  801bea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bed:	8b 40 08             	mov    0x8(%eax),%eax
  801bf0:	83 ec 04             	sub    $0x4,%esp
  801bf3:	50                   	push   %eax
  801bf4:	ff 75 0c             	pushl  0xc(%ebp)
  801bf7:	ff 75 08             	pushl  0x8(%ebp)
  801bfa:	e8 c7 03 00 00       	call   801fc6 <sys_getSharedObject>
  801bff:	83 c4 10             	add    $0x10,%esp
  801c02:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  801c05:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801c09:	74 06                	je     801c11 <sget+0xaf>
  801c0b:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  801c0f:	75 07                	jne    801c18 <sget+0xb6>
		{
			return NULL;
  801c11:	b8 00 00 00 00       	mov    $0x0,%eax
  801c16:	eb 0d                	jmp    801c25 <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  801c18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c1b:	8b 40 08             	mov    0x8(%eax),%eax
  801c1e:	eb 05                	jmp    801c25 <sget+0xc3>
		}
	}
	else
			return NULL;
  801c20:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c25:	c9                   	leave  
  801c26:	c3                   	ret    

00801c27 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801c27:	55                   	push   %ebp
  801c28:	89 e5                	mov    %esp,%ebp
  801c2a:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c2d:	e8 65 fb ff ff       	call   801797 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801c32:	83 ec 04             	sub    $0x4,%esp
  801c35:	68 80 3e 80 00       	push   $0x803e80
  801c3a:	68 e1 00 00 00       	push   $0xe1
  801c3f:	68 73 3e 80 00       	push   $0x803e73
  801c44:	e8 10 eb ff ff       	call   800759 <_panic>

00801c49 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801c49:	55                   	push   %ebp
  801c4a:	89 e5                	mov    %esp,%ebp
  801c4c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801c4f:	83 ec 04             	sub    $0x4,%esp
  801c52:	68 a8 3e 80 00       	push   $0x803ea8
  801c57:	68 f5 00 00 00       	push   $0xf5
  801c5c:	68 73 3e 80 00       	push   $0x803e73
  801c61:	e8 f3 ea ff ff       	call   800759 <_panic>

00801c66 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801c66:	55                   	push   %ebp
  801c67:	89 e5                	mov    %esp,%ebp
  801c69:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c6c:	83 ec 04             	sub    $0x4,%esp
  801c6f:	68 cc 3e 80 00       	push   $0x803ecc
  801c74:	68 00 01 00 00       	push   $0x100
  801c79:	68 73 3e 80 00       	push   $0x803e73
  801c7e:	e8 d6 ea ff ff       	call   800759 <_panic>

00801c83 <shrink>:

}
void shrink(uint32 newSize)
{
  801c83:	55                   	push   %ebp
  801c84:	89 e5                	mov    %esp,%ebp
  801c86:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c89:	83 ec 04             	sub    $0x4,%esp
  801c8c:	68 cc 3e 80 00       	push   $0x803ecc
  801c91:	68 05 01 00 00       	push   $0x105
  801c96:	68 73 3e 80 00       	push   $0x803e73
  801c9b:	e8 b9 ea ff ff       	call   800759 <_panic>

00801ca0 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
  801ca3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ca6:	83 ec 04             	sub    $0x4,%esp
  801ca9:	68 cc 3e 80 00       	push   $0x803ecc
  801cae:	68 0a 01 00 00       	push   $0x10a
  801cb3:	68 73 3e 80 00       	push   $0x803e73
  801cb8:	e8 9c ea ff ff       	call   800759 <_panic>

00801cbd <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801cbd:	55                   	push   %ebp
  801cbe:	89 e5                	mov    %esp,%ebp
  801cc0:	57                   	push   %edi
  801cc1:	56                   	push   %esi
  801cc2:	53                   	push   %ebx
  801cc3:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ccc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ccf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cd2:	8b 7d 18             	mov    0x18(%ebp),%edi
  801cd5:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801cd8:	cd 30                	int    $0x30
  801cda:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801cdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ce0:	83 c4 10             	add    $0x10,%esp
  801ce3:	5b                   	pop    %ebx
  801ce4:	5e                   	pop    %esi
  801ce5:	5f                   	pop    %edi
  801ce6:	5d                   	pop    %ebp
  801ce7:	c3                   	ret    

00801ce8 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
  801ceb:	83 ec 04             	sub    $0x4,%esp
  801cee:	8b 45 10             	mov    0x10(%ebp),%eax
  801cf1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801cf4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	52                   	push   %edx
  801d00:	ff 75 0c             	pushl  0xc(%ebp)
  801d03:	50                   	push   %eax
  801d04:	6a 00                	push   $0x0
  801d06:	e8 b2 ff ff ff       	call   801cbd <syscall>
  801d0b:	83 c4 18             	add    $0x18,%esp
}
  801d0e:	90                   	nop
  801d0f:	c9                   	leave  
  801d10:	c3                   	ret    

00801d11 <sys_cgetc>:

int
sys_cgetc(void)
{
  801d11:	55                   	push   %ebp
  801d12:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 01                	push   $0x1
  801d20:	e8 98 ff ff ff       	call   801cbd <syscall>
  801d25:	83 c4 18             	add    $0x18,%esp
}
  801d28:	c9                   	leave  
  801d29:	c3                   	ret    

00801d2a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801d2a:	55                   	push   %ebp
  801d2b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801d2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d30:	8b 45 08             	mov    0x8(%ebp),%eax
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	6a 00                	push   $0x0
  801d39:	52                   	push   %edx
  801d3a:	50                   	push   %eax
  801d3b:	6a 05                	push   $0x5
  801d3d:	e8 7b ff ff ff       	call   801cbd <syscall>
  801d42:	83 c4 18             	add    $0x18,%esp
}
  801d45:	c9                   	leave  
  801d46:	c3                   	ret    

00801d47 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801d47:	55                   	push   %ebp
  801d48:	89 e5                	mov    %esp,%ebp
  801d4a:	56                   	push   %esi
  801d4b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801d4c:	8b 75 18             	mov    0x18(%ebp),%esi
  801d4f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d52:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d55:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d58:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5b:	56                   	push   %esi
  801d5c:	53                   	push   %ebx
  801d5d:	51                   	push   %ecx
  801d5e:	52                   	push   %edx
  801d5f:	50                   	push   %eax
  801d60:	6a 06                	push   $0x6
  801d62:	e8 56 ff ff ff       	call   801cbd <syscall>
  801d67:	83 c4 18             	add    $0x18,%esp
}
  801d6a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d6d:	5b                   	pop    %ebx
  801d6e:	5e                   	pop    %esi
  801d6f:	5d                   	pop    %ebp
  801d70:	c3                   	ret    

00801d71 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801d71:	55                   	push   %ebp
  801d72:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801d74:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d77:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	52                   	push   %edx
  801d81:	50                   	push   %eax
  801d82:	6a 07                	push   $0x7
  801d84:	e8 34 ff ff ff       	call   801cbd <syscall>
  801d89:	83 c4 18             	add    $0x18,%esp
}
  801d8c:	c9                   	leave  
  801d8d:	c3                   	ret    

00801d8e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801d8e:	55                   	push   %ebp
  801d8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	ff 75 0c             	pushl  0xc(%ebp)
  801d9a:	ff 75 08             	pushl  0x8(%ebp)
  801d9d:	6a 08                	push   $0x8
  801d9f:	e8 19 ff ff ff       	call   801cbd <syscall>
  801da4:	83 c4 18             	add    $0x18,%esp
}
  801da7:	c9                   	leave  
  801da8:	c3                   	ret    

00801da9 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801da9:	55                   	push   %ebp
  801daa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	6a 00                	push   $0x0
  801db6:	6a 09                	push   $0x9
  801db8:	e8 00 ff ff ff       	call   801cbd <syscall>
  801dbd:	83 c4 18             	add    $0x18,%esp
}
  801dc0:	c9                   	leave  
  801dc1:	c3                   	ret    

00801dc2 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801dc2:	55                   	push   %ebp
  801dc3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 0a                	push   $0xa
  801dd1:	e8 e7 fe ff ff       	call   801cbd <syscall>
  801dd6:	83 c4 18             	add    $0x18,%esp
}
  801dd9:	c9                   	leave  
  801dda:	c3                   	ret    

00801ddb <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801ddb:	55                   	push   %ebp
  801ddc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	6a 00                	push   $0x0
  801de8:	6a 0b                	push   $0xb
  801dea:	e8 ce fe ff ff       	call   801cbd <syscall>
  801def:	83 c4 18             	add    $0x18,%esp
}
  801df2:	c9                   	leave  
  801df3:	c3                   	ret    

00801df4 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801df4:	55                   	push   %ebp
  801df5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	ff 75 0c             	pushl  0xc(%ebp)
  801e00:	ff 75 08             	pushl  0x8(%ebp)
  801e03:	6a 0f                	push   $0xf
  801e05:	e8 b3 fe ff ff       	call   801cbd <syscall>
  801e0a:	83 c4 18             	add    $0x18,%esp
	return;
  801e0d:	90                   	nop
}
  801e0e:	c9                   	leave  
  801e0f:	c3                   	ret    

00801e10 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e10:	55                   	push   %ebp
  801e11:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	ff 75 0c             	pushl  0xc(%ebp)
  801e1c:	ff 75 08             	pushl  0x8(%ebp)
  801e1f:	6a 10                	push   $0x10
  801e21:	e8 97 fe ff ff       	call   801cbd <syscall>
  801e26:	83 c4 18             	add    $0x18,%esp
	return ;
  801e29:	90                   	nop
}
  801e2a:	c9                   	leave  
  801e2b:	c3                   	ret    

00801e2c <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e2c:	55                   	push   %ebp
  801e2d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	ff 75 10             	pushl  0x10(%ebp)
  801e36:	ff 75 0c             	pushl  0xc(%ebp)
  801e39:	ff 75 08             	pushl  0x8(%ebp)
  801e3c:	6a 11                	push   $0x11
  801e3e:	e8 7a fe ff ff       	call   801cbd <syscall>
  801e43:	83 c4 18             	add    $0x18,%esp
	return ;
  801e46:	90                   	nop
}
  801e47:	c9                   	leave  
  801e48:	c3                   	ret    

00801e49 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801e49:	55                   	push   %ebp
  801e4a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 00                	push   $0x0
  801e50:	6a 00                	push   $0x0
  801e52:	6a 00                	push   $0x0
  801e54:	6a 00                	push   $0x0
  801e56:	6a 0c                	push   $0xc
  801e58:	e8 60 fe ff ff       	call   801cbd <syscall>
  801e5d:	83 c4 18             	add    $0x18,%esp
}
  801e60:	c9                   	leave  
  801e61:	c3                   	ret    

00801e62 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801e65:	6a 00                	push   $0x0
  801e67:	6a 00                	push   $0x0
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	ff 75 08             	pushl  0x8(%ebp)
  801e70:	6a 0d                	push   $0xd
  801e72:	e8 46 fe ff ff       	call   801cbd <syscall>
  801e77:	83 c4 18             	add    $0x18,%esp
}
  801e7a:	c9                   	leave  
  801e7b:	c3                   	ret    

00801e7c <sys_scarce_memory>:

void sys_scarce_memory()
{
  801e7c:	55                   	push   %ebp
  801e7d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	6a 00                	push   $0x0
  801e89:	6a 0e                	push   $0xe
  801e8b:	e8 2d fe ff ff       	call   801cbd <syscall>
  801e90:	83 c4 18             	add    $0x18,%esp
}
  801e93:	90                   	nop
  801e94:	c9                   	leave  
  801e95:	c3                   	ret    

00801e96 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801e96:	55                   	push   %ebp
  801e97:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 13                	push   $0x13
  801ea5:	e8 13 fe ff ff       	call   801cbd <syscall>
  801eaa:	83 c4 18             	add    $0x18,%esp
}
  801ead:	90                   	nop
  801eae:	c9                   	leave  
  801eaf:	c3                   	ret    

00801eb0 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801eb0:	55                   	push   %ebp
  801eb1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801eb3:	6a 00                	push   $0x0
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 14                	push   $0x14
  801ebf:	e8 f9 fd ff ff       	call   801cbd <syscall>
  801ec4:	83 c4 18             	add    $0x18,%esp
}
  801ec7:	90                   	nop
  801ec8:	c9                   	leave  
  801ec9:	c3                   	ret    

00801eca <sys_cputc>:


void
sys_cputc(const char c)
{
  801eca:	55                   	push   %ebp
  801ecb:	89 e5                	mov    %esp,%ebp
  801ecd:	83 ec 04             	sub    $0x4,%esp
  801ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ed6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801eda:	6a 00                	push   $0x0
  801edc:	6a 00                	push   $0x0
  801ede:	6a 00                	push   $0x0
  801ee0:	6a 00                	push   $0x0
  801ee2:	50                   	push   %eax
  801ee3:	6a 15                	push   $0x15
  801ee5:	e8 d3 fd ff ff       	call   801cbd <syscall>
  801eea:	83 c4 18             	add    $0x18,%esp
}
  801eed:	90                   	nop
  801eee:	c9                   	leave  
  801eef:	c3                   	ret    

00801ef0 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ef0:	55                   	push   %ebp
  801ef1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ef3:	6a 00                	push   $0x0
  801ef5:	6a 00                	push   $0x0
  801ef7:	6a 00                	push   $0x0
  801ef9:	6a 00                	push   $0x0
  801efb:	6a 00                	push   $0x0
  801efd:	6a 16                	push   $0x16
  801eff:	e8 b9 fd ff ff       	call   801cbd <syscall>
  801f04:	83 c4 18             	add    $0x18,%esp
}
  801f07:	90                   	nop
  801f08:	c9                   	leave  
  801f09:	c3                   	ret    

00801f0a <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801f0a:	55                   	push   %ebp
  801f0b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f10:	6a 00                	push   $0x0
  801f12:	6a 00                	push   $0x0
  801f14:	6a 00                	push   $0x0
  801f16:	ff 75 0c             	pushl  0xc(%ebp)
  801f19:	50                   	push   %eax
  801f1a:	6a 17                	push   $0x17
  801f1c:	e8 9c fd ff ff       	call   801cbd <syscall>
  801f21:	83 c4 18             	add    $0x18,%esp
}
  801f24:	c9                   	leave  
  801f25:	c3                   	ret    

00801f26 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801f26:	55                   	push   %ebp
  801f27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f29:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2f:	6a 00                	push   $0x0
  801f31:	6a 00                	push   $0x0
  801f33:	6a 00                	push   $0x0
  801f35:	52                   	push   %edx
  801f36:	50                   	push   %eax
  801f37:	6a 1a                	push   $0x1a
  801f39:	e8 7f fd ff ff       	call   801cbd <syscall>
  801f3e:	83 c4 18             	add    $0x18,%esp
}
  801f41:	c9                   	leave  
  801f42:	c3                   	ret    

00801f43 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f43:	55                   	push   %ebp
  801f44:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f46:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f49:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 00                	push   $0x0
  801f50:	6a 00                	push   $0x0
  801f52:	52                   	push   %edx
  801f53:	50                   	push   %eax
  801f54:	6a 18                	push   $0x18
  801f56:	e8 62 fd ff ff       	call   801cbd <syscall>
  801f5b:	83 c4 18             	add    $0x18,%esp
}
  801f5e:	90                   	nop
  801f5f:	c9                   	leave  
  801f60:	c3                   	ret    

00801f61 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f61:	55                   	push   %ebp
  801f62:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f64:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f67:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	6a 00                	push   $0x0
  801f70:	52                   	push   %edx
  801f71:	50                   	push   %eax
  801f72:	6a 19                	push   $0x19
  801f74:	e8 44 fd ff ff       	call   801cbd <syscall>
  801f79:	83 c4 18             	add    $0x18,%esp
}
  801f7c:	90                   	nop
  801f7d:	c9                   	leave  
  801f7e:	c3                   	ret    

00801f7f <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801f7f:	55                   	push   %ebp
  801f80:	89 e5                	mov    %esp,%ebp
  801f82:	83 ec 04             	sub    $0x4,%esp
  801f85:	8b 45 10             	mov    0x10(%ebp),%eax
  801f88:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801f8b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f8e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f92:	8b 45 08             	mov    0x8(%ebp),%eax
  801f95:	6a 00                	push   $0x0
  801f97:	51                   	push   %ecx
  801f98:	52                   	push   %edx
  801f99:	ff 75 0c             	pushl  0xc(%ebp)
  801f9c:	50                   	push   %eax
  801f9d:	6a 1b                	push   $0x1b
  801f9f:	e8 19 fd ff ff       	call   801cbd <syscall>
  801fa4:	83 c4 18             	add    $0x18,%esp
}
  801fa7:	c9                   	leave  
  801fa8:	c3                   	ret    

00801fa9 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801fa9:	55                   	push   %ebp
  801faa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801fac:	8b 55 0c             	mov    0xc(%ebp),%edx
  801faf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb2:	6a 00                	push   $0x0
  801fb4:	6a 00                	push   $0x0
  801fb6:	6a 00                	push   $0x0
  801fb8:	52                   	push   %edx
  801fb9:	50                   	push   %eax
  801fba:	6a 1c                	push   $0x1c
  801fbc:	e8 fc fc ff ff       	call   801cbd <syscall>
  801fc1:	83 c4 18             	add    $0x18,%esp
}
  801fc4:	c9                   	leave  
  801fc5:	c3                   	ret    

00801fc6 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801fc6:	55                   	push   %ebp
  801fc7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801fc9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fcc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 00                	push   $0x0
  801fd6:	51                   	push   %ecx
  801fd7:	52                   	push   %edx
  801fd8:	50                   	push   %eax
  801fd9:	6a 1d                	push   $0x1d
  801fdb:	e8 dd fc ff ff       	call   801cbd <syscall>
  801fe0:	83 c4 18             	add    $0x18,%esp
}
  801fe3:	c9                   	leave  
  801fe4:	c3                   	ret    

00801fe5 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801fe5:	55                   	push   %ebp
  801fe6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801fe8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801feb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fee:	6a 00                	push   $0x0
  801ff0:	6a 00                	push   $0x0
  801ff2:	6a 00                	push   $0x0
  801ff4:	52                   	push   %edx
  801ff5:	50                   	push   %eax
  801ff6:	6a 1e                	push   $0x1e
  801ff8:	e8 c0 fc ff ff       	call   801cbd <syscall>
  801ffd:	83 c4 18             	add    $0x18,%esp
}
  802000:	c9                   	leave  
  802001:	c3                   	ret    

00802002 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802002:	55                   	push   %ebp
  802003:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	6a 00                	push   $0x0
  80200b:	6a 00                	push   $0x0
  80200d:	6a 00                	push   $0x0
  80200f:	6a 1f                	push   $0x1f
  802011:	e8 a7 fc ff ff       	call   801cbd <syscall>
  802016:	83 c4 18             	add    $0x18,%esp
}
  802019:	c9                   	leave  
  80201a:	c3                   	ret    

0080201b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80201b:	55                   	push   %ebp
  80201c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80201e:	8b 45 08             	mov    0x8(%ebp),%eax
  802021:	6a 00                	push   $0x0
  802023:	ff 75 14             	pushl  0x14(%ebp)
  802026:	ff 75 10             	pushl  0x10(%ebp)
  802029:	ff 75 0c             	pushl  0xc(%ebp)
  80202c:	50                   	push   %eax
  80202d:	6a 20                	push   $0x20
  80202f:	e8 89 fc ff ff       	call   801cbd <syscall>
  802034:	83 c4 18             	add    $0x18,%esp
}
  802037:	c9                   	leave  
  802038:	c3                   	ret    

00802039 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802039:	55                   	push   %ebp
  80203a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80203c:	8b 45 08             	mov    0x8(%ebp),%eax
  80203f:	6a 00                	push   $0x0
  802041:	6a 00                	push   $0x0
  802043:	6a 00                	push   $0x0
  802045:	6a 00                	push   $0x0
  802047:	50                   	push   %eax
  802048:	6a 21                	push   $0x21
  80204a:	e8 6e fc ff ff       	call   801cbd <syscall>
  80204f:	83 c4 18             	add    $0x18,%esp
}
  802052:	90                   	nop
  802053:	c9                   	leave  
  802054:	c3                   	ret    

00802055 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802055:	55                   	push   %ebp
  802056:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802058:	8b 45 08             	mov    0x8(%ebp),%eax
  80205b:	6a 00                	push   $0x0
  80205d:	6a 00                	push   $0x0
  80205f:	6a 00                	push   $0x0
  802061:	6a 00                	push   $0x0
  802063:	50                   	push   %eax
  802064:	6a 22                	push   $0x22
  802066:	e8 52 fc ff ff       	call   801cbd <syscall>
  80206b:	83 c4 18             	add    $0x18,%esp
}
  80206e:	c9                   	leave  
  80206f:	c3                   	ret    

00802070 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802070:	55                   	push   %ebp
  802071:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802073:	6a 00                	push   $0x0
  802075:	6a 00                	push   $0x0
  802077:	6a 00                	push   $0x0
  802079:	6a 00                	push   $0x0
  80207b:	6a 00                	push   $0x0
  80207d:	6a 02                	push   $0x2
  80207f:	e8 39 fc ff ff       	call   801cbd <syscall>
  802084:	83 c4 18             	add    $0x18,%esp
}
  802087:	c9                   	leave  
  802088:	c3                   	ret    

00802089 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802089:	55                   	push   %ebp
  80208a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80208c:	6a 00                	push   $0x0
  80208e:	6a 00                	push   $0x0
  802090:	6a 00                	push   $0x0
  802092:	6a 00                	push   $0x0
  802094:	6a 00                	push   $0x0
  802096:	6a 03                	push   $0x3
  802098:	e8 20 fc ff ff       	call   801cbd <syscall>
  80209d:	83 c4 18             	add    $0x18,%esp
}
  8020a0:	c9                   	leave  
  8020a1:	c3                   	ret    

008020a2 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8020a2:	55                   	push   %ebp
  8020a3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8020a5:	6a 00                	push   $0x0
  8020a7:	6a 00                	push   $0x0
  8020a9:	6a 00                	push   $0x0
  8020ab:	6a 00                	push   $0x0
  8020ad:	6a 00                	push   $0x0
  8020af:	6a 04                	push   $0x4
  8020b1:	e8 07 fc ff ff       	call   801cbd <syscall>
  8020b6:	83 c4 18             	add    $0x18,%esp
}
  8020b9:	c9                   	leave  
  8020ba:	c3                   	ret    

008020bb <sys_exit_env>:


void sys_exit_env(void)
{
  8020bb:	55                   	push   %ebp
  8020bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8020be:	6a 00                	push   $0x0
  8020c0:	6a 00                	push   $0x0
  8020c2:	6a 00                	push   $0x0
  8020c4:	6a 00                	push   $0x0
  8020c6:	6a 00                	push   $0x0
  8020c8:	6a 23                	push   $0x23
  8020ca:	e8 ee fb ff ff       	call   801cbd <syscall>
  8020cf:	83 c4 18             	add    $0x18,%esp
}
  8020d2:	90                   	nop
  8020d3:	c9                   	leave  
  8020d4:	c3                   	ret    

008020d5 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8020d5:	55                   	push   %ebp
  8020d6:	89 e5                	mov    %esp,%ebp
  8020d8:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8020db:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020de:	8d 50 04             	lea    0x4(%eax),%edx
  8020e1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020e4:	6a 00                	push   $0x0
  8020e6:	6a 00                	push   $0x0
  8020e8:	6a 00                	push   $0x0
  8020ea:	52                   	push   %edx
  8020eb:	50                   	push   %eax
  8020ec:	6a 24                	push   $0x24
  8020ee:	e8 ca fb ff ff       	call   801cbd <syscall>
  8020f3:	83 c4 18             	add    $0x18,%esp
	return result;
  8020f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020fc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8020ff:	89 01                	mov    %eax,(%ecx)
  802101:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802104:	8b 45 08             	mov    0x8(%ebp),%eax
  802107:	c9                   	leave  
  802108:	c2 04 00             	ret    $0x4

0080210b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80210b:	55                   	push   %ebp
  80210c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80210e:	6a 00                	push   $0x0
  802110:	6a 00                	push   $0x0
  802112:	ff 75 10             	pushl  0x10(%ebp)
  802115:	ff 75 0c             	pushl  0xc(%ebp)
  802118:	ff 75 08             	pushl  0x8(%ebp)
  80211b:	6a 12                	push   $0x12
  80211d:	e8 9b fb ff ff       	call   801cbd <syscall>
  802122:	83 c4 18             	add    $0x18,%esp
	return ;
  802125:	90                   	nop
}
  802126:	c9                   	leave  
  802127:	c3                   	ret    

00802128 <sys_rcr2>:
uint32 sys_rcr2()
{
  802128:	55                   	push   %ebp
  802129:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80212b:	6a 00                	push   $0x0
  80212d:	6a 00                	push   $0x0
  80212f:	6a 00                	push   $0x0
  802131:	6a 00                	push   $0x0
  802133:	6a 00                	push   $0x0
  802135:	6a 25                	push   $0x25
  802137:	e8 81 fb ff ff       	call   801cbd <syscall>
  80213c:	83 c4 18             	add    $0x18,%esp
}
  80213f:	c9                   	leave  
  802140:	c3                   	ret    

00802141 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802141:	55                   	push   %ebp
  802142:	89 e5                	mov    %esp,%ebp
  802144:	83 ec 04             	sub    $0x4,%esp
  802147:	8b 45 08             	mov    0x8(%ebp),%eax
  80214a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80214d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802151:	6a 00                	push   $0x0
  802153:	6a 00                	push   $0x0
  802155:	6a 00                	push   $0x0
  802157:	6a 00                	push   $0x0
  802159:	50                   	push   %eax
  80215a:	6a 26                	push   $0x26
  80215c:	e8 5c fb ff ff       	call   801cbd <syscall>
  802161:	83 c4 18             	add    $0x18,%esp
	return ;
  802164:	90                   	nop
}
  802165:	c9                   	leave  
  802166:	c3                   	ret    

00802167 <rsttst>:
void rsttst()
{
  802167:	55                   	push   %ebp
  802168:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80216a:	6a 00                	push   $0x0
  80216c:	6a 00                	push   $0x0
  80216e:	6a 00                	push   $0x0
  802170:	6a 00                	push   $0x0
  802172:	6a 00                	push   $0x0
  802174:	6a 28                	push   $0x28
  802176:	e8 42 fb ff ff       	call   801cbd <syscall>
  80217b:	83 c4 18             	add    $0x18,%esp
	return ;
  80217e:	90                   	nop
}
  80217f:	c9                   	leave  
  802180:	c3                   	ret    

00802181 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802181:	55                   	push   %ebp
  802182:	89 e5                	mov    %esp,%ebp
  802184:	83 ec 04             	sub    $0x4,%esp
  802187:	8b 45 14             	mov    0x14(%ebp),%eax
  80218a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80218d:	8b 55 18             	mov    0x18(%ebp),%edx
  802190:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802194:	52                   	push   %edx
  802195:	50                   	push   %eax
  802196:	ff 75 10             	pushl  0x10(%ebp)
  802199:	ff 75 0c             	pushl  0xc(%ebp)
  80219c:	ff 75 08             	pushl  0x8(%ebp)
  80219f:	6a 27                	push   $0x27
  8021a1:	e8 17 fb ff ff       	call   801cbd <syscall>
  8021a6:	83 c4 18             	add    $0x18,%esp
	return ;
  8021a9:	90                   	nop
}
  8021aa:	c9                   	leave  
  8021ab:	c3                   	ret    

008021ac <chktst>:
void chktst(uint32 n)
{
  8021ac:	55                   	push   %ebp
  8021ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8021af:	6a 00                	push   $0x0
  8021b1:	6a 00                	push   $0x0
  8021b3:	6a 00                	push   $0x0
  8021b5:	6a 00                	push   $0x0
  8021b7:	ff 75 08             	pushl  0x8(%ebp)
  8021ba:	6a 29                	push   $0x29
  8021bc:	e8 fc fa ff ff       	call   801cbd <syscall>
  8021c1:	83 c4 18             	add    $0x18,%esp
	return ;
  8021c4:	90                   	nop
}
  8021c5:	c9                   	leave  
  8021c6:	c3                   	ret    

008021c7 <inctst>:

void inctst()
{
  8021c7:	55                   	push   %ebp
  8021c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8021ca:	6a 00                	push   $0x0
  8021cc:	6a 00                	push   $0x0
  8021ce:	6a 00                	push   $0x0
  8021d0:	6a 00                	push   $0x0
  8021d2:	6a 00                	push   $0x0
  8021d4:	6a 2a                	push   $0x2a
  8021d6:	e8 e2 fa ff ff       	call   801cbd <syscall>
  8021db:	83 c4 18             	add    $0x18,%esp
	return ;
  8021de:	90                   	nop
}
  8021df:	c9                   	leave  
  8021e0:	c3                   	ret    

008021e1 <gettst>:
uint32 gettst()
{
  8021e1:	55                   	push   %ebp
  8021e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8021e4:	6a 00                	push   $0x0
  8021e6:	6a 00                	push   $0x0
  8021e8:	6a 00                	push   $0x0
  8021ea:	6a 00                	push   $0x0
  8021ec:	6a 00                	push   $0x0
  8021ee:	6a 2b                	push   $0x2b
  8021f0:	e8 c8 fa ff ff       	call   801cbd <syscall>
  8021f5:	83 c4 18             	add    $0x18,%esp
}
  8021f8:	c9                   	leave  
  8021f9:	c3                   	ret    

008021fa <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8021fa:	55                   	push   %ebp
  8021fb:	89 e5                	mov    %esp,%ebp
  8021fd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802200:	6a 00                	push   $0x0
  802202:	6a 00                	push   $0x0
  802204:	6a 00                	push   $0x0
  802206:	6a 00                	push   $0x0
  802208:	6a 00                	push   $0x0
  80220a:	6a 2c                	push   $0x2c
  80220c:	e8 ac fa ff ff       	call   801cbd <syscall>
  802211:	83 c4 18             	add    $0x18,%esp
  802214:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802217:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80221b:	75 07                	jne    802224 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80221d:	b8 01 00 00 00       	mov    $0x1,%eax
  802222:	eb 05                	jmp    802229 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802224:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802229:	c9                   	leave  
  80222a:	c3                   	ret    

0080222b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80222b:	55                   	push   %ebp
  80222c:	89 e5                	mov    %esp,%ebp
  80222e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802231:	6a 00                	push   $0x0
  802233:	6a 00                	push   $0x0
  802235:	6a 00                	push   $0x0
  802237:	6a 00                	push   $0x0
  802239:	6a 00                	push   $0x0
  80223b:	6a 2c                	push   $0x2c
  80223d:	e8 7b fa ff ff       	call   801cbd <syscall>
  802242:	83 c4 18             	add    $0x18,%esp
  802245:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802248:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80224c:	75 07                	jne    802255 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80224e:	b8 01 00 00 00       	mov    $0x1,%eax
  802253:	eb 05                	jmp    80225a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802255:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80225a:	c9                   	leave  
  80225b:	c3                   	ret    

0080225c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80225c:	55                   	push   %ebp
  80225d:	89 e5                	mov    %esp,%ebp
  80225f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802262:	6a 00                	push   $0x0
  802264:	6a 00                	push   $0x0
  802266:	6a 00                	push   $0x0
  802268:	6a 00                	push   $0x0
  80226a:	6a 00                	push   $0x0
  80226c:	6a 2c                	push   $0x2c
  80226e:	e8 4a fa ff ff       	call   801cbd <syscall>
  802273:	83 c4 18             	add    $0x18,%esp
  802276:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802279:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80227d:	75 07                	jne    802286 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80227f:	b8 01 00 00 00       	mov    $0x1,%eax
  802284:	eb 05                	jmp    80228b <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802286:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80228b:	c9                   	leave  
  80228c:	c3                   	ret    

0080228d <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80228d:	55                   	push   %ebp
  80228e:	89 e5                	mov    %esp,%ebp
  802290:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802293:	6a 00                	push   $0x0
  802295:	6a 00                	push   $0x0
  802297:	6a 00                	push   $0x0
  802299:	6a 00                	push   $0x0
  80229b:	6a 00                	push   $0x0
  80229d:	6a 2c                	push   $0x2c
  80229f:	e8 19 fa ff ff       	call   801cbd <syscall>
  8022a4:	83 c4 18             	add    $0x18,%esp
  8022a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8022aa:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8022ae:	75 07                	jne    8022b7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8022b0:	b8 01 00 00 00       	mov    $0x1,%eax
  8022b5:	eb 05                	jmp    8022bc <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8022b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022bc:	c9                   	leave  
  8022bd:	c3                   	ret    

008022be <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8022be:	55                   	push   %ebp
  8022bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8022c1:	6a 00                	push   $0x0
  8022c3:	6a 00                	push   $0x0
  8022c5:	6a 00                	push   $0x0
  8022c7:	6a 00                	push   $0x0
  8022c9:	ff 75 08             	pushl  0x8(%ebp)
  8022cc:	6a 2d                	push   $0x2d
  8022ce:	e8 ea f9 ff ff       	call   801cbd <syscall>
  8022d3:	83 c4 18             	add    $0x18,%esp
	return ;
  8022d6:	90                   	nop
}
  8022d7:	c9                   	leave  
  8022d8:	c3                   	ret    

008022d9 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8022d9:	55                   	push   %ebp
  8022da:	89 e5                	mov    %esp,%ebp
  8022dc:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8022dd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022e0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e9:	6a 00                	push   $0x0
  8022eb:	53                   	push   %ebx
  8022ec:	51                   	push   %ecx
  8022ed:	52                   	push   %edx
  8022ee:	50                   	push   %eax
  8022ef:	6a 2e                	push   $0x2e
  8022f1:	e8 c7 f9 ff ff       	call   801cbd <syscall>
  8022f6:	83 c4 18             	add    $0x18,%esp
}
  8022f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022fc:	c9                   	leave  
  8022fd:	c3                   	ret    

008022fe <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8022fe:	55                   	push   %ebp
  8022ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802301:	8b 55 0c             	mov    0xc(%ebp),%edx
  802304:	8b 45 08             	mov    0x8(%ebp),%eax
  802307:	6a 00                	push   $0x0
  802309:	6a 00                	push   $0x0
  80230b:	6a 00                	push   $0x0
  80230d:	52                   	push   %edx
  80230e:	50                   	push   %eax
  80230f:	6a 2f                	push   $0x2f
  802311:	e8 a7 f9 ff ff       	call   801cbd <syscall>
  802316:	83 c4 18             	add    $0x18,%esp
}
  802319:	c9                   	leave  
  80231a:	c3                   	ret    

0080231b <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80231b:	55                   	push   %ebp
  80231c:	89 e5                	mov    %esp,%ebp
  80231e:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802321:	83 ec 0c             	sub    $0xc,%esp
  802324:	68 dc 3e 80 00       	push   $0x803edc
  802329:	e8 df e6 ff ff       	call   800a0d <cprintf>
  80232e:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802331:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802338:	83 ec 0c             	sub    $0xc,%esp
  80233b:	68 08 3f 80 00       	push   $0x803f08
  802340:	e8 c8 e6 ff ff       	call   800a0d <cprintf>
  802345:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802348:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80234c:	a1 38 51 80 00       	mov    0x805138,%eax
  802351:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802354:	eb 56                	jmp    8023ac <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802356:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80235a:	74 1c                	je     802378 <print_mem_block_lists+0x5d>
  80235c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235f:	8b 50 08             	mov    0x8(%eax),%edx
  802362:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802365:	8b 48 08             	mov    0x8(%eax),%ecx
  802368:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80236b:	8b 40 0c             	mov    0xc(%eax),%eax
  80236e:	01 c8                	add    %ecx,%eax
  802370:	39 c2                	cmp    %eax,%edx
  802372:	73 04                	jae    802378 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802374:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802378:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237b:	8b 50 08             	mov    0x8(%eax),%edx
  80237e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802381:	8b 40 0c             	mov    0xc(%eax),%eax
  802384:	01 c2                	add    %eax,%edx
  802386:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802389:	8b 40 08             	mov    0x8(%eax),%eax
  80238c:	83 ec 04             	sub    $0x4,%esp
  80238f:	52                   	push   %edx
  802390:	50                   	push   %eax
  802391:	68 1d 3f 80 00       	push   $0x803f1d
  802396:	e8 72 e6 ff ff       	call   800a0d <cprintf>
  80239b:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80239e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8023a4:	a1 40 51 80 00       	mov    0x805140,%eax
  8023a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023b0:	74 07                	je     8023b9 <print_mem_block_lists+0x9e>
  8023b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b5:	8b 00                	mov    (%eax),%eax
  8023b7:	eb 05                	jmp    8023be <print_mem_block_lists+0xa3>
  8023b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8023be:	a3 40 51 80 00       	mov    %eax,0x805140
  8023c3:	a1 40 51 80 00       	mov    0x805140,%eax
  8023c8:	85 c0                	test   %eax,%eax
  8023ca:	75 8a                	jne    802356 <print_mem_block_lists+0x3b>
  8023cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023d0:	75 84                	jne    802356 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8023d2:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8023d6:	75 10                	jne    8023e8 <print_mem_block_lists+0xcd>
  8023d8:	83 ec 0c             	sub    $0xc,%esp
  8023db:	68 2c 3f 80 00       	push   $0x803f2c
  8023e0:	e8 28 e6 ff ff       	call   800a0d <cprintf>
  8023e5:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8023e8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8023ef:	83 ec 0c             	sub    $0xc,%esp
  8023f2:	68 50 3f 80 00       	push   $0x803f50
  8023f7:	e8 11 e6 ff ff       	call   800a0d <cprintf>
  8023fc:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8023ff:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802403:	a1 40 50 80 00       	mov    0x805040,%eax
  802408:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80240b:	eb 56                	jmp    802463 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80240d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802411:	74 1c                	je     80242f <print_mem_block_lists+0x114>
  802413:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802416:	8b 50 08             	mov    0x8(%eax),%edx
  802419:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80241c:	8b 48 08             	mov    0x8(%eax),%ecx
  80241f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802422:	8b 40 0c             	mov    0xc(%eax),%eax
  802425:	01 c8                	add    %ecx,%eax
  802427:	39 c2                	cmp    %eax,%edx
  802429:	73 04                	jae    80242f <print_mem_block_lists+0x114>
			sorted = 0 ;
  80242b:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80242f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802432:	8b 50 08             	mov    0x8(%eax),%edx
  802435:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802438:	8b 40 0c             	mov    0xc(%eax),%eax
  80243b:	01 c2                	add    %eax,%edx
  80243d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802440:	8b 40 08             	mov    0x8(%eax),%eax
  802443:	83 ec 04             	sub    $0x4,%esp
  802446:	52                   	push   %edx
  802447:	50                   	push   %eax
  802448:	68 1d 3f 80 00       	push   $0x803f1d
  80244d:	e8 bb e5 ff ff       	call   800a0d <cprintf>
  802452:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802455:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802458:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80245b:	a1 48 50 80 00       	mov    0x805048,%eax
  802460:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802463:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802467:	74 07                	je     802470 <print_mem_block_lists+0x155>
  802469:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246c:	8b 00                	mov    (%eax),%eax
  80246e:	eb 05                	jmp    802475 <print_mem_block_lists+0x15a>
  802470:	b8 00 00 00 00       	mov    $0x0,%eax
  802475:	a3 48 50 80 00       	mov    %eax,0x805048
  80247a:	a1 48 50 80 00       	mov    0x805048,%eax
  80247f:	85 c0                	test   %eax,%eax
  802481:	75 8a                	jne    80240d <print_mem_block_lists+0xf2>
  802483:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802487:	75 84                	jne    80240d <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802489:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80248d:	75 10                	jne    80249f <print_mem_block_lists+0x184>
  80248f:	83 ec 0c             	sub    $0xc,%esp
  802492:	68 68 3f 80 00       	push   $0x803f68
  802497:	e8 71 e5 ff ff       	call   800a0d <cprintf>
  80249c:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80249f:	83 ec 0c             	sub    $0xc,%esp
  8024a2:	68 dc 3e 80 00       	push   $0x803edc
  8024a7:	e8 61 e5 ff ff       	call   800a0d <cprintf>
  8024ac:	83 c4 10             	add    $0x10,%esp

}
  8024af:	90                   	nop
  8024b0:	c9                   	leave  
  8024b1:	c3                   	ret    

008024b2 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8024b2:	55                   	push   %ebp
  8024b3:	89 e5                	mov    %esp,%ebp
  8024b5:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8024b8:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8024bf:	00 00 00 
  8024c2:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8024c9:	00 00 00 
  8024cc:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8024d3:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  8024d6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8024dd:	e9 9e 00 00 00       	jmp    802580 <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  8024e2:	a1 50 50 80 00       	mov    0x805050,%eax
  8024e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024ea:	c1 e2 04             	shl    $0x4,%edx
  8024ed:	01 d0                	add    %edx,%eax
  8024ef:	85 c0                	test   %eax,%eax
  8024f1:	75 14                	jne    802507 <initialize_MemBlocksList+0x55>
  8024f3:	83 ec 04             	sub    $0x4,%esp
  8024f6:	68 90 3f 80 00       	push   $0x803f90
  8024fb:	6a 42                	push   $0x42
  8024fd:	68 b3 3f 80 00       	push   $0x803fb3
  802502:	e8 52 e2 ff ff       	call   800759 <_panic>
  802507:	a1 50 50 80 00       	mov    0x805050,%eax
  80250c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80250f:	c1 e2 04             	shl    $0x4,%edx
  802512:	01 d0                	add    %edx,%eax
  802514:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80251a:	89 10                	mov    %edx,(%eax)
  80251c:	8b 00                	mov    (%eax),%eax
  80251e:	85 c0                	test   %eax,%eax
  802520:	74 18                	je     80253a <initialize_MemBlocksList+0x88>
  802522:	a1 48 51 80 00       	mov    0x805148,%eax
  802527:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80252d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802530:	c1 e1 04             	shl    $0x4,%ecx
  802533:	01 ca                	add    %ecx,%edx
  802535:	89 50 04             	mov    %edx,0x4(%eax)
  802538:	eb 12                	jmp    80254c <initialize_MemBlocksList+0x9a>
  80253a:	a1 50 50 80 00       	mov    0x805050,%eax
  80253f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802542:	c1 e2 04             	shl    $0x4,%edx
  802545:	01 d0                	add    %edx,%eax
  802547:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80254c:	a1 50 50 80 00       	mov    0x805050,%eax
  802551:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802554:	c1 e2 04             	shl    $0x4,%edx
  802557:	01 d0                	add    %edx,%eax
  802559:	a3 48 51 80 00       	mov    %eax,0x805148
  80255e:	a1 50 50 80 00       	mov    0x805050,%eax
  802563:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802566:	c1 e2 04             	shl    $0x4,%edx
  802569:	01 d0                	add    %edx,%eax
  80256b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802572:	a1 54 51 80 00       	mov    0x805154,%eax
  802577:	40                   	inc    %eax
  802578:	a3 54 51 80 00       	mov    %eax,0x805154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  80257d:	ff 45 f4             	incl   -0xc(%ebp)
  802580:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802583:	3b 45 08             	cmp    0x8(%ebp),%eax
  802586:	0f 82 56 ff ff ff    	jb     8024e2 <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  80258c:	90                   	nop
  80258d:	c9                   	leave  
  80258e:	c3                   	ret    

0080258f <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80258f:	55                   	push   %ebp
  802590:	89 e5                	mov    %esp,%ebp
  802592:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  802595:	8b 45 08             	mov    0x8(%ebp),%eax
  802598:	8b 00                	mov    (%eax),%eax
  80259a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80259d:	eb 19                	jmp    8025b8 <find_block+0x29>
	{
		if(blk->sva==va)
  80259f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025a2:	8b 40 08             	mov    0x8(%eax),%eax
  8025a5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8025a8:	75 05                	jne    8025af <find_block+0x20>
			return (blk);
  8025aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025ad:	eb 36                	jmp    8025e5 <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  8025af:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b2:	8b 40 08             	mov    0x8(%eax),%eax
  8025b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8025b8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8025bc:	74 07                	je     8025c5 <find_block+0x36>
  8025be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025c1:	8b 00                	mov    (%eax),%eax
  8025c3:	eb 05                	jmp    8025ca <find_block+0x3b>
  8025c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8025cd:	89 42 08             	mov    %eax,0x8(%edx)
  8025d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d3:	8b 40 08             	mov    0x8(%eax),%eax
  8025d6:	85 c0                	test   %eax,%eax
  8025d8:	75 c5                	jne    80259f <find_block+0x10>
  8025da:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8025de:	75 bf                	jne    80259f <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  8025e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025e5:	c9                   	leave  
  8025e6:	c3                   	ret    

008025e7 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8025e7:	55                   	push   %ebp
  8025e8:	89 e5                	mov    %esp,%ebp
  8025ea:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  8025ed:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8025f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8025f5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  8025fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ff:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802602:	75 65                	jne    802669 <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802604:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802608:	75 14                	jne    80261e <insert_sorted_allocList+0x37>
  80260a:	83 ec 04             	sub    $0x4,%esp
  80260d:	68 90 3f 80 00       	push   $0x803f90
  802612:	6a 5c                	push   $0x5c
  802614:	68 b3 3f 80 00       	push   $0x803fb3
  802619:	e8 3b e1 ff ff       	call   800759 <_panic>
  80261e:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802624:	8b 45 08             	mov    0x8(%ebp),%eax
  802627:	89 10                	mov    %edx,(%eax)
  802629:	8b 45 08             	mov    0x8(%ebp),%eax
  80262c:	8b 00                	mov    (%eax),%eax
  80262e:	85 c0                	test   %eax,%eax
  802630:	74 0d                	je     80263f <insert_sorted_allocList+0x58>
  802632:	a1 40 50 80 00       	mov    0x805040,%eax
  802637:	8b 55 08             	mov    0x8(%ebp),%edx
  80263a:	89 50 04             	mov    %edx,0x4(%eax)
  80263d:	eb 08                	jmp    802647 <insert_sorted_allocList+0x60>
  80263f:	8b 45 08             	mov    0x8(%ebp),%eax
  802642:	a3 44 50 80 00       	mov    %eax,0x805044
  802647:	8b 45 08             	mov    0x8(%ebp),%eax
  80264a:	a3 40 50 80 00       	mov    %eax,0x805040
  80264f:	8b 45 08             	mov    0x8(%ebp),%eax
  802652:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802659:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80265e:	40                   	inc    %eax
  80265f:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  802664:	e9 7b 01 00 00       	jmp    8027e4 <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  802669:	a1 44 50 80 00       	mov    0x805044,%eax
  80266e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  802671:	a1 40 50 80 00       	mov    0x805040,%eax
  802676:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  802679:	8b 45 08             	mov    0x8(%ebp),%eax
  80267c:	8b 50 08             	mov    0x8(%eax),%edx
  80267f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802682:	8b 40 08             	mov    0x8(%eax),%eax
  802685:	39 c2                	cmp    %eax,%edx
  802687:	76 65                	jbe    8026ee <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  802689:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80268d:	75 14                	jne    8026a3 <insert_sorted_allocList+0xbc>
  80268f:	83 ec 04             	sub    $0x4,%esp
  802692:	68 cc 3f 80 00       	push   $0x803fcc
  802697:	6a 64                	push   $0x64
  802699:	68 b3 3f 80 00       	push   $0x803fb3
  80269e:	e8 b6 e0 ff ff       	call   800759 <_panic>
  8026a3:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8026a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ac:	89 50 04             	mov    %edx,0x4(%eax)
  8026af:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b2:	8b 40 04             	mov    0x4(%eax),%eax
  8026b5:	85 c0                	test   %eax,%eax
  8026b7:	74 0c                	je     8026c5 <insert_sorted_allocList+0xde>
  8026b9:	a1 44 50 80 00       	mov    0x805044,%eax
  8026be:	8b 55 08             	mov    0x8(%ebp),%edx
  8026c1:	89 10                	mov    %edx,(%eax)
  8026c3:	eb 08                	jmp    8026cd <insert_sorted_allocList+0xe6>
  8026c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c8:	a3 40 50 80 00       	mov    %eax,0x805040
  8026cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d0:	a3 44 50 80 00       	mov    %eax,0x805044
  8026d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026de:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8026e3:	40                   	inc    %eax
  8026e4:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  8026e9:	e9 f6 00 00 00       	jmp    8027e4 <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  8026ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f1:	8b 50 08             	mov    0x8(%eax),%edx
  8026f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026f7:	8b 40 08             	mov    0x8(%eax),%eax
  8026fa:	39 c2                	cmp    %eax,%edx
  8026fc:	73 65                	jae    802763 <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  8026fe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802702:	75 14                	jne    802718 <insert_sorted_allocList+0x131>
  802704:	83 ec 04             	sub    $0x4,%esp
  802707:	68 90 3f 80 00       	push   $0x803f90
  80270c:	6a 68                	push   $0x68
  80270e:	68 b3 3f 80 00       	push   $0x803fb3
  802713:	e8 41 e0 ff ff       	call   800759 <_panic>
  802718:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80271e:	8b 45 08             	mov    0x8(%ebp),%eax
  802721:	89 10                	mov    %edx,(%eax)
  802723:	8b 45 08             	mov    0x8(%ebp),%eax
  802726:	8b 00                	mov    (%eax),%eax
  802728:	85 c0                	test   %eax,%eax
  80272a:	74 0d                	je     802739 <insert_sorted_allocList+0x152>
  80272c:	a1 40 50 80 00       	mov    0x805040,%eax
  802731:	8b 55 08             	mov    0x8(%ebp),%edx
  802734:	89 50 04             	mov    %edx,0x4(%eax)
  802737:	eb 08                	jmp    802741 <insert_sorted_allocList+0x15a>
  802739:	8b 45 08             	mov    0x8(%ebp),%eax
  80273c:	a3 44 50 80 00       	mov    %eax,0x805044
  802741:	8b 45 08             	mov    0x8(%ebp),%eax
  802744:	a3 40 50 80 00       	mov    %eax,0x805040
  802749:	8b 45 08             	mov    0x8(%ebp),%eax
  80274c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802753:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802758:	40                   	inc    %eax
  802759:	a3 4c 50 80 00       	mov    %eax,0x80504c
				}
			}
		 }

	}
}
  80275e:	e9 81 00 00 00       	jmp    8027e4 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802763:	a1 40 50 80 00       	mov    0x805040,%eax
  802768:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80276b:	eb 51                	jmp    8027be <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  80276d:	8b 45 08             	mov    0x8(%ebp),%eax
  802770:	8b 50 08             	mov    0x8(%eax),%edx
  802773:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802776:	8b 40 08             	mov    0x8(%eax),%eax
  802779:	39 c2                	cmp    %eax,%edx
  80277b:	73 39                	jae    8027b6 <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  80277d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802780:	8b 40 04             	mov    0x4(%eax),%eax
  802783:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  802786:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802789:	8b 55 08             	mov    0x8(%ebp),%edx
  80278c:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  80278e:	8b 45 08             	mov    0x8(%ebp),%eax
  802791:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802794:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  802797:	8b 45 08             	mov    0x8(%ebp),%eax
  80279a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80279d:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  80279f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8027a5:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  8027a8:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8027ad:	40                   	inc    %eax
  8027ae:	a3 4c 50 80 00       	mov    %eax,0x80504c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  8027b3:	90                   	nop
				}
			}
		 }

	}
}
  8027b4:	eb 2e                	jmp    8027e4 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  8027b6:	a1 48 50 80 00       	mov    0x805048,%eax
  8027bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027c2:	74 07                	je     8027cb <insert_sorted_allocList+0x1e4>
  8027c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c7:	8b 00                	mov    (%eax),%eax
  8027c9:	eb 05                	jmp    8027d0 <insert_sorted_allocList+0x1e9>
  8027cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d0:	a3 48 50 80 00       	mov    %eax,0x805048
  8027d5:	a1 48 50 80 00       	mov    0x805048,%eax
  8027da:	85 c0                	test   %eax,%eax
  8027dc:	75 8f                	jne    80276d <insert_sorted_allocList+0x186>
  8027de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027e2:	75 89                	jne    80276d <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  8027e4:	90                   	nop
  8027e5:	c9                   	leave  
  8027e6:	c3                   	ret    

008027e7 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8027e7:	55                   	push   %ebp
  8027e8:	89 e5                	mov    %esp,%ebp
  8027ea:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  8027ed:	a1 38 51 80 00       	mov    0x805138,%eax
  8027f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027f5:	e9 76 01 00 00       	jmp    802970 <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  8027fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fd:	8b 40 0c             	mov    0xc(%eax),%eax
  802800:	3b 45 08             	cmp    0x8(%ebp),%eax
  802803:	0f 85 8a 00 00 00    	jne    802893 <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  802809:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80280d:	75 17                	jne    802826 <alloc_block_FF+0x3f>
  80280f:	83 ec 04             	sub    $0x4,%esp
  802812:	68 ef 3f 80 00       	push   $0x803fef
  802817:	68 8a 00 00 00       	push   $0x8a
  80281c:	68 b3 3f 80 00       	push   $0x803fb3
  802821:	e8 33 df ff ff       	call   800759 <_panic>
  802826:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802829:	8b 00                	mov    (%eax),%eax
  80282b:	85 c0                	test   %eax,%eax
  80282d:	74 10                	je     80283f <alloc_block_FF+0x58>
  80282f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802832:	8b 00                	mov    (%eax),%eax
  802834:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802837:	8b 52 04             	mov    0x4(%edx),%edx
  80283a:	89 50 04             	mov    %edx,0x4(%eax)
  80283d:	eb 0b                	jmp    80284a <alloc_block_FF+0x63>
  80283f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802842:	8b 40 04             	mov    0x4(%eax),%eax
  802845:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80284a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284d:	8b 40 04             	mov    0x4(%eax),%eax
  802850:	85 c0                	test   %eax,%eax
  802852:	74 0f                	je     802863 <alloc_block_FF+0x7c>
  802854:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802857:	8b 40 04             	mov    0x4(%eax),%eax
  80285a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80285d:	8b 12                	mov    (%edx),%edx
  80285f:	89 10                	mov    %edx,(%eax)
  802861:	eb 0a                	jmp    80286d <alloc_block_FF+0x86>
  802863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802866:	8b 00                	mov    (%eax),%eax
  802868:	a3 38 51 80 00       	mov    %eax,0x805138
  80286d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802870:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802876:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802879:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802880:	a1 44 51 80 00       	mov    0x805144,%eax
  802885:	48                   	dec    %eax
  802886:	a3 44 51 80 00       	mov    %eax,0x805144
			return element;
  80288b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288e:	e9 10 01 00 00       	jmp    8029a3 <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  802893:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802896:	8b 40 0c             	mov    0xc(%eax),%eax
  802899:	3b 45 08             	cmp    0x8(%ebp),%eax
  80289c:	0f 86 c6 00 00 00    	jbe    802968 <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  8028a2:	a1 48 51 80 00       	mov    0x805148,%eax
  8028a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  8028aa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028ae:	75 17                	jne    8028c7 <alloc_block_FF+0xe0>
  8028b0:	83 ec 04             	sub    $0x4,%esp
  8028b3:	68 ef 3f 80 00       	push   $0x803fef
  8028b8:	68 90 00 00 00       	push   $0x90
  8028bd:	68 b3 3f 80 00       	push   $0x803fb3
  8028c2:	e8 92 de ff ff       	call   800759 <_panic>
  8028c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ca:	8b 00                	mov    (%eax),%eax
  8028cc:	85 c0                	test   %eax,%eax
  8028ce:	74 10                	je     8028e0 <alloc_block_FF+0xf9>
  8028d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d3:	8b 00                	mov    (%eax),%eax
  8028d5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028d8:	8b 52 04             	mov    0x4(%edx),%edx
  8028db:	89 50 04             	mov    %edx,0x4(%eax)
  8028de:	eb 0b                	jmp    8028eb <alloc_block_FF+0x104>
  8028e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e3:	8b 40 04             	mov    0x4(%eax),%eax
  8028e6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ee:	8b 40 04             	mov    0x4(%eax),%eax
  8028f1:	85 c0                	test   %eax,%eax
  8028f3:	74 0f                	je     802904 <alloc_block_FF+0x11d>
  8028f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f8:	8b 40 04             	mov    0x4(%eax),%eax
  8028fb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028fe:	8b 12                	mov    (%edx),%edx
  802900:	89 10                	mov    %edx,(%eax)
  802902:	eb 0a                	jmp    80290e <alloc_block_FF+0x127>
  802904:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802907:	8b 00                	mov    (%eax),%eax
  802909:	a3 48 51 80 00       	mov    %eax,0x805148
  80290e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802911:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802917:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80291a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802921:	a1 54 51 80 00       	mov    0x805154,%eax
  802926:	48                   	dec    %eax
  802927:	a3 54 51 80 00       	mov    %eax,0x805154
			 element1->size =size;
  80292c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80292f:	8b 55 08             	mov    0x8(%ebp),%edx
  802932:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  802935:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802938:	8b 50 08             	mov    0x8(%eax),%edx
  80293b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293e:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  802941:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802944:	8b 50 08             	mov    0x8(%eax),%edx
  802947:	8b 45 08             	mov    0x8(%ebp),%eax
  80294a:	01 c2                	add    %eax,%edx
  80294c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294f:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  802952:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802955:	8b 40 0c             	mov    0xc(%eax),%eax
  802958:	2b 45 08             	sub    0x8(%ebp),%eax
  80295b:	89 c2                	mov    %eax,%edx
  80295d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802960:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  802963:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802966:	eb 3b                	jmp    8029a3 <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802968:	a1 40 51 80 00       	mov    0x805140,%eax
  80296d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802970:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802974:	74 07                	je     80297d <alloc_block_FF+0x196>
  802976:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802979:	8b 00                	mov    (%eax),%eax
  80297b:	eb 05                	jmp    802982 <alloc_block_FF+0x19b>
  80297d:	b8 00 00 00 00       	mov    $0x0,%eax
  802982:	a3 40 51 80 00       	mov    %eax,0x805140
  802987:	a1 40 51 80 00       	mov    0x805140,%eax
  80298c:	85 c0                	test   %eax,%eax
  80298e:	0f 85 66 fe ff ff    	jne    8027fa <alloc_block_FF+0x13>
  802994:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802998:	0f 85 5c fe ff ff    	jne    8027fa <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  80299e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029a3:	c9                   	leave  
  8029a4:	c3                   	ret    

008029a5 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8029a5:	55                   	push   %ebp
  8029a6:	89 e5                	mov    %esp,%ebp
  8029a8:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  8029ab:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  8029b2:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  8029b9:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8029c0:	a1 38 51 80 00       	mov    0x805138,%eax
  8029c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029c8:	e9 cf 00 00 00       	jmp    802a9c <alloc_block_BF+0xf7>
		{
			c++;
  8029cd:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  8029d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8029d6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029d9:	0f 85 8a 00 00 00    	jne    802a69 <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  8029df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029e3:	75 17                	jne    8029fc <alloc_block_BF+0x57>
  8029e5:	83 ec 04             	sub    $0x4,%esp
  8029e8:	68 ef 3f 80 00       	push   $0x803fef
  8029ed:	68 a8 00 00 00       	push   $0xa8
  8029f2:	68 b3 3f 80 00       	push   $0x803fb3
  8029f7:	e8 5d dd ff ff       	call   800759 <_panic>
  8029fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ff:	8b 00                	mov    (%eax),%eax
  802a01:	85 c0                	test   %eax,%eax
  802a03:	74 10                	je     802a15 <alloc_block_BF+0x70>
  802a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a08:	8b 00                	mov    (%eax),%eax
  802a0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a0d:	8b 52 04             	mov    0x4(%edx),%edx
  802a10:	89 50 04             	mov    %edx,0x4(%eax)
  802a13:	eb 0b                	jmp    802a20 <alloc_block_BF+0x7b>
  802a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a18:	8b 40 04             	mov    0x4(%eax),%eax
  802a1b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a23:	8b 40 04             	mov    0x4(%eax),%eax
  802a26:	85 c0                	test   %eax,%eax
  802a28:	74 0f                	je     802a39 <alloc_block_BF+0x94>
  802a2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2d:	8b 40 04             	mov    0x4(%eax),%eax
  802a30:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a33:	8b 12                	mov    (%edx),%edx
  802a35:	89 10                	mov    %edx,(%eax)
  802a37:	eb 0a                	jmp    802a43 <alloc_block_BF+0x9e>
  802a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3c:	8b 00                	mov    (%eax),%eax
  802a3e:	a3 38 51 80 00       	mov    %eax,0x805138
  802a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a46:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a56:	a1 44 51 80 00       	mov    0x805144,%eax
  802a5b:	48                   	dec    %eax
  802a5c:	a3 44 51 80 00       	mov    %eax,0x805144
				return block;
  802a61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a64:	e9 85 01 00 00       	jmp    802bee <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  802a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a6f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a72:	76 20                	jbe    802a94 <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  802a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a77:	8b 40 0c             	mov    0xc(%eax),%eax
  802a7a:	2b 45 08             	sub    0x8(%ebp),%eax
  802a7d:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  802a80:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a83:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802a86:	73 0c                	jae    802a94 <alloc_block_BF+0xef>
				{
					ma=tempi;
  802a88:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802a8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  802a8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a91:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802a94:	a1 40 51 80 00       	mov    0x805140,%eax
  802a99:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a9c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aa0:	74 07                	je     802aa9 <alloc_block_BF+0x104>
  802aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa5:	8b 00                	mov    (%eax),%eax
  802aa7:	eb 05                	jmp    802aae <alloc_block_BF+0x109>
  802aa9:	b8 00 00 00 00       	mov    $0x0,%eax
  802aae:	a3 40 51 80 00       	mov    %eax,0x805140
  802ab3:	a1 40 51 80 00       	mov    0x805140,%eax
  802ab8:	85 c0                	test   %eax,%eax
  802aba:	0f 85 0d ff ff ff    	jne    8029cd <alloc_block_BF+0x28>
  802ac0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ac4:	0f 85 03 ff ff ff    	jne    8029cd <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  802aca:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802ad1:	a1 38 51 80 00       	mov    0x805138,%eax
  802ad6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ad9:	e9 dd 00 00 00       	jmp    802bbb <alloc_block_BF+0x216>
		{
			if(x==sol)
  802ade:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ae1:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802ae4:	0f 85 c6 00 00 00    	jne    802bb0 <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802aea:	a1 48 51 80 00       	mov    0x805148,%eax
  802aef:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802af2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802af6:	75 17                	jne    802b0f <alloc_block_BF+0x16a>
  802af8:	83 ec 04             	sub    $0x4,%esp
  802afb:	68 ef 3f 80 00       	push   $0x803fef
  802b00:	68 bb 00 00 00       	push   $0xbb
  802b05:	68 b3 3f 80 00       	push   $0x803fb3
  802b0a:	e8 4a dc ff ff       	call   800759 <_panic>
  802b0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b12:	8b 00                	mov    (%eax),%eax
  802b14:	85 c0                	test   %eax,%eax
  802b16:	74 10                	je     802b28 <alloc_block_BF+0x183>
  802b18:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b1b:	8b 00                	mov    (%eax),%eax
  802b1d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b20:	8b 52 04             	mov    0x4(%edx),%edx
  802b23:	89 50 04             	mov    %edx,0x4(%eax)
  802b26:	eb 0b                	jmp    802b33 <alloc_block_BF+0x18e>
  802b28:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b2b:	8b 40 04             	mov    0x4(%eax),%eax
  802b2e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b33:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b36:	8b 40 04             	mov    0x4(%eax),%eax
  802b39:	85 c0                	test   %eax,%eax
  802b3b:	74 0f                	je     802b4c <alloc_block_BF+0x1a7>
  802b3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b40:	8b 40 04             	mov    0x4(%eax),%eax
  802b43:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802b46:	8b 12                	mov    (%edx),%edx
  802b48:	89 10                	mov    %edx,(%eax)
  802b4a:	eb 0a                	jmp    802b56 <alloc_block_BF+0x1b1>
  802b4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b4f:	8b 00                	mov    (%eax),%eax
  802b51:	a3 48 51 80 00       	mov    %eax,0x805148
  802b56:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b59:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b5f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b62:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b69:	a1 54 51 80 00       	mov    0x805154,%eax
  802b6e:	48                   	dec    %eax
  802b6f:	a3 54 51 80 00       	mov    %eax,0x805154
						 element1->size =size;
  802b74:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b77:	8b 55 08             	mov    0x8(%ebp),%edx
  802b7a:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  802b7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b80:	8b 50 08             	mov    0x8(%eax),%edx
  802b83:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b86:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  802b89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8c:	8b 50 08             	mov    0x8(%eax),%edx
  802b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b92:	01 c2                	add    %eax,%edx
  802b94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b97:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  802b9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9d:	8b 40 0c             	mov    0xc(%eax),%eax
  802ba0:	2b 45 08             	sub    0x8(%ebp),%eax
  802ba3:	89 c2                	mov    %eax,%edx
  802ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba8:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  802bab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bae:	eb 3e                	jmp    802bee <alloc_block_BF+0x249>
						 break;
			}
			x++;
  802bb0:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802bb3:	a1 40 51 80 00       	mov    0x805140,%eax
  802bb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bbb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bbf:	74 07                	je     802bc8 <alloc_block_BF+0x223>
  802bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc4:	8b 00                	mov    (%eax),%eax
  802bc6:	eb 05                	jmp    802bcd <alloc_block_BF+0x228>
  802bc8:	b8 00 00 00 00       	mov    $0x0,%eax
  802bcd:	a3 40 51 80 00       	mov    %eax,0x805140
  802bd2:	a1 40 51 80 00       	mov    0x805140,%eax
  802bd7:	85 c0                	test   %eax,%eax
  802bd9:	0f 85 ff fe ff ff    	jne    802ade <alloc_block_BF+0x139>
  802bdf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802be3:	0f 85 f5 fe ff ff    	jne    802ade <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  802be9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bee:	c9                   	leave  
  802bef:	c3                   	ret    

00802bf0 <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802bf0:	55                   	push   %ebp
  802bf1:	89 e5                	mov    %esp,%ebp
  802bf3:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  802bf6:	a1 28 50 80 00       	mov    0x805028,%eax
  802bfb:	85 c0                	test   %eax,%eax
  802bfd:	75 14                	jne    802c13 <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  802bff:	a1 38 51 80 00       	mov    0x805138,%eax
  802c04:	a3 60 51 80 00       	mov    %eax,0x805160
		hh=1;
  802c09:	c7 05 28 50 80 00 01 	movl   $0x1,0x805028
  802c10:	00 00 00 
	}
	uint32 c=1;
  802c13:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  802c1a:	a1 60 51 80 00       	mov    0x805160,%eax
  802c1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802c22:	e9 b3 01 00 00       	jmp    802dda <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  802c27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2a:	8b 40 0c             	mov    0xc(%eax),%eax
  802c2d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c30:	0f 85 a9 00 00 00    	jne    802cdf <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  802c36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c39:	8b 00                	mov    (%eax),%eax
  802c3b:	85 c0                	test   %eax,%eax
  802c3d:	75 0c                	jne    802c4b <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  802c3f:	a1 38 51 80 00       	mov    0x805138,%eax
  802c44:	a3 60 51 80 00       	mov    %eax,0x805160
  802c49:	eb 0a                	jmp    802c55 <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  802c4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c4e:	8b 00                	mov    (%eax),%eax
  802c50:	a3 60 51 80 00       	mov    %eax,0x805160
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  802c55:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c59:	75 17                	jne    802c72 <alloc_block_NF+0x82>
  802c5b:	83 ec 04             	sub    $0x4,%esp
  802c5e:	68 ef 3f 80 00       	push   $0x803fef
  802c63:	68 e3 00 00 00       	push   $0xe3
  802c68:	68 b3 3f 80 00       	push   $0x803fb3
  802c6d:	e8 e7 da ff ff       	call   800759 <_panic>
  802c72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c75:	8b 00                	mov    (%eax),%eax
  802c77:	85 c0                	test   %eax,%eax
  802c79:	74 10                	je     802c8b <alloc_block_NF+0x9b>
  802c7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c7e:	8b 00                	mov    (%eax),%eax
  802c80:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c83:	8b 52 04             	mov    0x4(%edx),%edx
  802c86:	89 50 04             	mov    %edx,0x4(%eax)
  802c89:	eb 0b                	jmp    802c96 <alloc_block_NF+0xa6>
  802c8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c8e:	8b 40 04             	mov    0x4(%eax),%eax
  802c91:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c99:	8b 40 04             	mov    0x4(%eax),%eax
  802c9c:	85 c0                	test   %eax,%eax
  802c9e:	74 0f                	je     802caf <alloc_block_NF+0xbf>
  802ca0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca3:	8b 40 04             	mov    0x4(%eax),%eax
  802ca6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ca9:	8b 12                	mov    (%edx),%edx
  802cab:	89 10                	mov    %edx,(%eax)
  802cad:	eb 0a                	jmp    802cb9 <alloc_block_NF+0xc9>
  802caf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb2:	8b 00                	mov    (%eax),%eax
  802cb4:	a3 38 51 80 00       	mov    %eax,0x805138
  802cb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cbc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ccc:	a1 44 51 80 00       	mov    0x805144,%eax
  802cd1:	48                   	dec    %eax
  802cd2:	a3 44 51 80 00       	mov    %eax,0x805144
				return element;
  802cd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cda:	e9 0e 01 00 00       	jmp    802ded <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  802cdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ce5:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ce8:	0f 86 ce 00 00 00    	jbe    802dbc <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802cee:	a1 48 51 80 00       	mov    0x805148,%eax
  802cf3:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802cf6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802cfa:	75 17                	jne    802d13 <alloc_block_NF+0x123>
  802cfc:	83 ec 04             	sub    $0x4,%esp
  802cff:	68 ef 3f 80 00       	push   $0x803fef
  802d04:	68 e9 00 00 00       	push   $0xe9
  802d09:	68 b3 3f 80 00       	push   $0x803fb3
  802d0e:	e8 46 da ff ff       	call   800759 <_panic>
  802d13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d16:	8b 00                	mov    (%eax),%eax
  802d18:	85 c0                	test   %eax,%eax
  802d1a:	74 10                	je     802d2c <alloc_block_NF+0x13c>
  802d1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d1f:	8b 00                	mov    (%eax),%eax
  802d21:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d24:	8b 52 04             	mov    0x4(%edx),%edx
  802d27:	89 50 04             	mov    %edx,0x4(%eax)
  802d2a:	eb 0b                	jmp    802d37 <alloc_block_NF+0x147>
  802d2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d2f:	8b 40 04             	mov    0x4(%eax),%eax
  802d32:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d3a:	8b 40 04             	mov    0x4(%eax),%eax
  802d3d:	85 c0                	test   %eax,%eax
  802d3f:	74 0f                	je     802d50 <alloc_block_NF+0x160>
  802d41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d44:	8b 40 04             	mov    0x4(%eax),%eax
  802d47:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d4a:	8b 12                	mov    (%edx),%edx
  802d4c:	89 10                	mov    %edx,(%eax)
  802d4e:	eb 0a                	jmp    802d5a <alloc_block_NF+0x16a>
  802d50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d53:	8b 00                	mov    (%eax),%eax
  802d55:	a3 48 51 80 00       	mov    %eax,0x805148
  802d5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d5d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d66:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d6d:	a1 54 51 80 00       	mov    0x805154,%eax
  802d72:	48                   	dec    %eax
  802d73:	a3 54 51 80 00       	mov    %eax,0x805154
				 element1->size =size;
  802d78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d7b:	8b 55 08             	mov    0x8(%ebp),%edx
  802d7e:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  802d81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d84:	8b 50 08             	mov    0x8(%eax),%edx
  802d87:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d8a:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  802d8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d90:	8b 50 08             	mov    0x8(%eax),%edx
  802d93:	8b 45 08             	mov    0x8(%ebp),%eax
  802d96:	01 c2                	add    %eax,%edx
  802d98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d9b:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  802d9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da1:	8b 40 0c             	mov    0xc(%eax),%eax
  802da4:	2b 45 08             	sub    0x8(%ebp),%eax
  802da7:	89 c2                	mov    %eax,%edx
  802da9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dac:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  802daf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db2:	a3 60 51 80 00       	mov    %eax,0x805160
				 return element1;
  802db7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dba:	eb 31                	jmp    802ded <alloc_block_NF+0x1fd>
			 }
		 c++;
  802dbc:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  802dbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc2:	8b 00                	mov    (%eax),%eax
  802dc4:	85 c0                	test   %eax,%eax
  802dc6:	75 0a                	jne    802dd2 <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  802dc8:	a1 38 51 80 00       	mov    0x805138,%eax
  802dcd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802dd0:	eb 08                	jmp    802dda <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  802dd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd5:	8b 00                	mov    (%eax),%eax
  802dd7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802dda:	a1 44 51 80 00       	mov    0x805144,%eax
  802ddf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802de2:	0f 85 3f fe ff ff    	jne    802c27 <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  802de8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ded:	c9                   	leave  
  802dee:	c3                   	ret    

00802def <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802def:	55                   	push   %ebp
  802df0:	89 e5                	mov    %esp,%ebp
  802df2:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  802df5:	a1 44 51 80 00       	mov    0x805144,%eax
  802dfa:	85 c0                	test   %eax,%eax
  802dfc:	75 68                	jne    802e66 <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802dfe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e02:	75 17                	jne    802e1b <insert_sorted_with_merge_freeList+0x2c>
  802e04:	83 ec 04             	sub    $0x4,%esp
  802e07:	68 90 3f 80 00       	push   $0x803f90
  802e0c:	68 0e 01 00 00       	push   $0x10e
  802e11:	68 b3 3f 80 00       	push   $0x803fb3
  802e16:	e8 3e d9 ff ff       	call   800759 <_panic>
  802e1b:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802e21:	8b 45 08             	mov    0x8(%ebp),%eax
  802e24:	89 10                	mov    %edx,(%eax)
  802e26:	8b 45 08             	mov    0x8(%ebp),%eax
  802e29:	8b 00                	mov    (%eax),%eax
  802e2b:	85 c0                	test   %eax,%eax
  802e2d:	74 0d                	je     802e3c <insert_sorted_with_merge_freeList+0x4d>
  802e2f:	a1 38 51 80 00       	mov    0x805138,%eax
  802e34:	8b 55 08             	mov    0x8(%ebp),%edx
  802e37:	89 50 04             	mov    %edx,0x4(%eax)
  802e3a:	eb 08                	jmp    802e44 <insert_sorted_with_merge_freeList+0x55>
  802e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e44:	8b 45 08             	mov    0x8(%ebp),%eax
  802e47:	a3 38 51 80 00       	mov    %eax,0x805138
  802e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e56:	a1 44 51 80 00       	mov    0x805144,%eax
  802e5b:	40                   	inc    %eax
  802e5c:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  802e61:	e9 8c 06 00 00       	jmp    8034f2 <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  802e66:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  802e6e:	a1 38 51 80 00       	mov    0x805138,%eax
  802e73:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  802e76:	8b 45 08             	mov    0x8(%ebp),%eax
  802e79:	8b 50 08             	mov    0x8(%eax),%edx
  802e7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e7f:	8b 40 08             	mov    0x8(%eax),%eax
  802e82:	39 c2                	cmp    %eax,%edx
  802e84:	0f 86 14 01 00 00    	jbe    802f9e <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  802e8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e8d:	8b 50 0c             	mov    0xc(%eax),%edx
  802e90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e93:	8b 40 08             	mov    0x8(%eax),%eax
  802e96:	01 c2                	add    %eax,%edx
  802e98:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9b:	8b 40 08             	mov    0x8(%eax),%eax
  802e9e:	39 c2                	cmp    %eax,%edx
  802ea0:	0f 85 90 00 00 00    	jne    802f36 <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  802ea6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea9:	8b 50 0c             	mov    0xc(%eax),%edx
  802eac:	8b 45 08             	mov    0x8(%ebp),%eax
  802eaf:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb2:	01 c2                	add    %eax,%edx
  802eb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb7:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802eba:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802ece:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ed2:	75 17                	jne    802eeb <insert_sorted_with_merge_freeList+0xfc>
  802ed4:	83 ec 04             	sub    $0x4,%esp
  802ed7:	68 90 3f 80 00       	push   $0x803f90
  802edc:	68 1b 01 00 00       	push   $0x11b
  802ee1:	68 b3 3f 80 00       	push   $0x803fb3
  802ee6:	e8 6e d8 ff ff       	call   800759 <_panic>
  802eeb:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef4:	89 10                	mov    %edx,(%eax)
  802ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef9:	8b 00                	mov    (%eax),%eax
  802efb:	85 c0                	test   %eax,%eax
  802efd:	74 0d                	je     802f0c <insert_sorted_with_merge_freeList+0x11d>
  802eff:	a1 48 51 80 00       	mov    0x805148,%eax
  802f04:	8b 55 08             	mov    0x8(%ebp),%edx
  802f07:	89 50 04             	mov    %edx,0x4(%eax)
  802f0a:	eb 08                	jmp    802f14 <insert_sorted_with_merge_freeList+0x125>
  802f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f14:	8b 45 08             	mov    0x8(%ebp),%eax
  802f17:	a3 48 51 80 00       	mov    %eax,0x805148
  802f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f26:	a1 54 51 80 00       	mov    0x805154,%eax
  802f2b:	40                   	inc    %eax
  802f2c:	a3 54 51 80 00       	mov    %eax,0x805154
							}

						}
		          }
		}
}
  802f31:	e9 bc 05 00 00       	jmp    8034f2 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802f36:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f3a:	75 17                	jne    802f53 <insert_sorted_with_merge_freeList+0x164>
  802f3c:	83 ec 04             	sub    $0x4,%esp
  802f3f:	68 cc 3f 80 00       	push   $0x803fcc
  802f44:	68 1f 01 00 00       	push   $0x11f
  802f49:	68 b3 3f 80 00       	push   $0x803fb3
  802f4e:	e8 06 d8 ff ff       	call   800759 <_panic>
  802f53:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802f59:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5c:	89 50 04             	mov    %edx,0x4(%eax)
  802f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f62:	8b 40 04             	mov    0x4(%eax),%eax
  802f65:	85 c0                	test   %eax,%eax
  802f67:	74 0c                	je     802f75 <insert_sorted_with_merge_freeList+0x186>
  802f69:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f6e:	8b 55 08             	mov    0x8(%ebp),%edx
  802f71:	89 10                	mov    %edx,(%eax)
  802f73:	eb 08                	jmp    802f7d <insert_sorted_with_merge_freeList+0x18e>
  802f75:	8b 45 08             	mov    0x8(%ebp),%eax
  802f78:	a3 38 51 80 00       	mov    %eax,0x805138
  802f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f80:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f85:	8b 45 08             	mov    0x8(%ebp),%eax
  802f88:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f8e:	a1 44 51 80 00       	mov    0x805144,%eax
  802f93:	40                   	inc    %eax
  802f94:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  802f99:	e9 54 05 00 00       	jmp    8034f2 <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  802f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa1:	8b 50 08             	mov    0x8(%eax),%edx
  802fa4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fa7:	8b 40 08             	mov    0x8(%eax),%eax
  802faa:	39 c2                	cmp    %eax,%edx
  802fac:	0f 83 20 01 00 00    	jae    8030d2 <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  802fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb5:	8b 50 0c             	mov    0xc(%eax),%edx
  802fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbb:	8b 40 08             	mov    0x8(%eax),%eax
  802fbe:	01 c2                	add    %eax,%edx
  802fc0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fc3:	8b 40 08             	mov    0x8(%eax),%eax
  802fc6:	39 c2                	cmp    %eax,%edx
  802fc8:	0f 85 9c 00 00 00    	jne    80306a <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  802fce:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd1:	8b 50 08             	mov    0x8(%eax),%edx
  802fd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fd7:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  802fda:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fdd:	8b 50 0c             	mov    0xc(%eax),%edx
  802fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe3:	8b 40 0c             	mov    0xc(%eax),%eax
  802fe6:	01 c2                	add    %eax,%edx
  802fe8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802feb:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802fee:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803002:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803006:	75 17                	jne    80301f <insert_sorted_with_merge_freeList+0x230>
  803008:	83 ec 04             	sub    $0x4,%esp
  80300b:	68 90 3f 80 00       	push   $0x803f90
  803010:	68 2a 01 00 00       	push   $0x12a
  803015:	68 b3 3f 80 00       	push   $0x803fb3
  80301a:	e8 3a d7 ff ff       	call   800759 <_panic>
  80301f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803025:	8b 45 08             	mov    0x8(%ebp),%eax
  803028:	89 10                	mov    %edx,(%eax)
  80302a:	8b 45 08             	mov    0x8(%ebp),%eax
  80302d:	8b 00                	mov    (%eax),%eax
  80302f:	85 c0                	test   %eax,%eax
  803031:	74 0d                	je     803040 <insert_sorted_with_merge_freeList+0x251>
  803033:	a1 48 51 80 00       	mov    0x805148,%eax
  803038:	8b 55 08             	mov    0x8(%ebp),%edx
  80303b:	89 50 04             	mov    %edx,0x4(%eax)
  80303e:	eb 08                	jmp    803048 <insert_sorted_with_merge_freeList+0x259>
  803040:	8b 45 08             	mov    0x8(%ebp),%eax
  803043:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803048:	8b 45 08             	mov    0x8(%ebp),%eax
  80304b:	a3 48 51 80 00       	mov    %eax,0x805148
  803050:	8b 45 08             	mov    0x8(%ebp),%eax
  803053:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80305a:	a1 54 51 80 00       	mov    0x805154,%eax
  80305f:	40                   	inc    %eax
  803060:	a3 54 51 80 00       	mov    %eax,0x805154
							}

						}
		          }
		}
}
  803065:	e9 88 04 00 00       	jmp    8034f2 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  80306a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80306e:	75 17                	jne    803087 <insert_sorted_with_merge_freeList+0x298>
  803070:	83 ec 04             	sub    $0x4,%esp
  803073:	68 90 3f 80 00       	push   $0x803f90
  803078:	68 2e 01 00 00       	push   $0x12e
  80307d:	68 b3 3f 80 00       	push   $0x803fb3
  803082:	e8 d2 d6 ff ff       	call   800759 <_panic>
  803087:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80308d:	8b 45 08             	mov    0x8(%ebp),%eax
  803090:	89 10                	mov    %edx,(%eax)
  803092:	8b 45 08             	mov    0x8(%ebp),%eax
  803095:	8b 00                	mov    (%eax),%eax
  803097:	85 c0                	test   %eax,%eax
  803099:	74 0d                	je     8030a8 <insert_sorted_with_merge_freeList+0x2b9>
  80309b:	a1 38 51 80 00       	mov    0x805138,%eax
  8030a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8030a3:	89 50 04             	mov    %edx,0x4(%eax)
  8030a6:	eb 08                	jmp    8030b0 <insert_sorted_with_merge_freeList+0x2c1>
  8030a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ab:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b3:	a3 38 51 80 00       	mov    %eax,0x805138
  8030b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030c2:	a1 44 51 80 00       	mov    0x805144,%eax
  8030c7:	40                   	inc    %eax
  8030c8:	a3 44 51 80 00       	mov    %eax,0x805144
							}

						}
		          }
		}
}
  8030cd:	e9 20 04 00 00       	jmp    8034f2 <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  8030d2:	a1 38 51 80 00       	mov    0x805138,%eax
  8030d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030da:	e9 e2 03 00 00       	jmp    8034c1 <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  8030df:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e2:	8b 50 08             	mov    0x8(%eax),%edx
  8030e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e8:	8b 40 08             	mov    0x8(%eax),%eax
  8030eb:	39 c2                	cmp    %eax,%edx
  8030ed:	0f 83 c6 03 00 00    	jae    8034b9 <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  8030f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f6:	8b 40 04             	mov    0x4(%eax),%eax
  8030f9:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  8030fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ff:	8b 50 08             	mov    0x8(%eax),%edx
  803102:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803105:	8b 40 0c             	mov    0xc(%eax),%eax
  803108:	01 d0                	add    %edx,%eax
  80310a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  80310d:	8b 45 08             	mov    0x8(%ebp),%eax
  803110:	8b 50 0c             	mov    0xc(%eax),%edx
  803113:	8b 45 08             	mov    0x8(%ebp),%eax
  803116:	8b 40 08             	mov    0x8(%eax),%eax
  803119:	01 d0                	add    %edx,%eax
  80311b:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  80311e:	8b 45 08             	mov    0x8(%ebp),%eax
  803121:	8b 40 08             	mov    0x8(%eax),%eax
  803124:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803127:	74 7a                	je     8031a3 <insert_sorted_with_merge_freeList+0x3b4>
  803129:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312c:	8b 40 08             	mov    0x8(%eax),%eax
  80312f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803132:	74 6f                	je     8031a3 <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  803134:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803138:	74 06                	je     803140 <insert_sorted_with_merge_freeList+0x351>
  80313a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80313e:	75 17                	jne    803157 <insert_sorted_with_merge_freeList+0x368>
  803140:	83 ec 04             	sub    $0x4,%esp
  803143:	68 10 40 80 00       	push   $0x804010
  803148:	68 43 01 00 00       	push   $0x143
  80314d:	68 b3 3f 80 00       	push   $0x803fb3
  803152:	e8 02 d6 ff ff       	call   800759 <_panic>
  803157:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315a:	8b 50 04             	mov    0x4(%eax),%edx
  80315d:	8b 45 08             	mov    0x8(%ebp),%eax
  803160:	89 50 04             	mov    %edx,0x4(%eax)
  803163:	8b 45 08             	mov    0x8(%ebp),%eax
  803166:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803169:	89 10                	mov    %edx,(%eax)
  80316b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316e:	8b 40 04             	mov    0x4(%eax),%eax
  803171:	85 c0                	test   %eax,%eax
  803173:	74 0d                	je     803182 <insert_sorted_with_merge_freeList+0x393>
  803175:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803178:	8b 40 04             	mov    0x4(%eax),%eax
  80317b:	8b 55 08             	mov    0x8(%ebp),%edx
  80317e:	89 10                	mov    %edx,(%eax)
  803180:	eb 08                	jmp    80318a <insert_sorted_with_merge_freeList+0x39b>
  803182:	8b 45 08             	mov    0x8(%ebp),%eax
  803185:	a3 38 51 80 00       	mov    %eax,0x805138
  80318a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318d:	8b 55 08             	mov    0x8(%ebp),%edx
  803190:	89 50 04             	mov    %edx,0x4(%eax)
  803193:	a1 44 51 80 00       	mov    0x805144,%eax
  803198:	40                   	inc    %eax
  803199:	a3 44 51 80 00       	mov    %eax,0x805144
  80319e:	e9 14 03 00 00       	jmp    8034b7 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  8031a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a6:	8b 40 08             	mov    0x8(%eax),%eax
  8031a9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8031ac:	0f 85 a0 01 00 00    	jne    803352 <insert_sorted_with_merge_freeList+0x563>
  8031b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b5:	8b 40 08             	mov    0x8(%eax),%eax
  8031b8:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8031bb:	0f 85 91 01 00 00    	jne    803352 <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  8031c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031c4:	8b 50 0c             	mov    0xc(%eax),%edx
  8031c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ca:	8b 48 0c             	mov    0xc(%eax),%ecx
  8031cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8031d3:	01 c8                	add    %ecx,%eax
  8031d5:	01 c2                	add    %eax,%edx
  8031d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031da:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  8031dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  8031e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ea:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  8031f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  8031fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031fe:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803205:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803209:	75 17                	jne    803222 <insert_sorted_with_merge_freeList+0x433>
  80320b:	83 ec 04             	sub    $0x4,%esp
  80320e:	68 90 3f 80 00       	push   $0x803f90
  803213:	68 4d 01 00 00       	push   $0x14d
  803218:	68 b3 3f 80 00       	push   $0x803fb3
  80321d:	e8 37 d5 ff ff       	call   800759 <_panic>
  803222:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803228:	8b 45 08             	mov    0x8(%ebp),%eax
  80322b:	89 10                	mov    %edx,(%eax)
  80322d:	8b 45 08             	mov    0x8(%ebp),%eax
  803230:	8b 00                	mov    (%eax),%eax
  803232:	85 c0                	test   %eax,%eax
  803234:	74 0d                	je     803243 <insert_sorted_with_merge_freeList+0x454>
  803236:	a1 48 51 80 00       	mov    0x805148,%eax
  80323b:	8b 55 08             	mov    0x8(%ebp),%edx
  80323e:	89 50 04             	mov    %edx,0x4(%eax)
  803241:	eb 08                	jmp    80324b <insert_sorted_with_merge_freeList+0x45c>
  803243:	8b 45 08             	mov    0x8(%ebp),%eax
  803246:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80324b:	8b 45 08             	mov    0x8(%ebp),%eax
  80324e:	a3 48 51 80 00       	mov    %eax,0x805148
  803253:	8b 45 08             	mov    0x8(%ebp),%eax
  803256:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80325d:	a1 54 51 80 00       	mov    0x805154,%eax
  803262:	40                   	inc    %eax
  803263:	a3 54 51 80 00       	mov    %eax,0x805154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  803268:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80326c:	75 17                	jne    803285 <insert_sorted_with_merge_freeList+0x496>
  80326e:	83 ec 04             	sub    $0x4,%esp
  803271:	68 ef 3f 80 00       	push   $0x803fef
  803276:	68 4e 01 00 00       	push   $0x14e
  80327b:	68 b3 3f 80 00       	push   $0x803fb3
  803280:	e8 d4 d4 ff ff       	call   800759 <_panic>
  803285:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803288:	8b 00                	mov    (%eax),%eax
  80328a:	85 c0                	test   %eax,%eax
  80328c:	74 10                	je     80329e <insert_sorted_with_merge_freeList+0x4af>
  80328e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803291:	8b 00                	mov    (%eax),%eax
  803293:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803296:	8b 52 04             	mov    0x4(%edx),%edx
  803299:	89 50 04             	mov    %edx,0x4(%eax)
  80329c:	eb 0b                	jmp    8032a9 <insert_sorted_with_merge_freeList+0x4ba>
  80329e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a1:	8b 40 04             	mov    0x4(%eax),%eax
  8032a4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ac:	8b 40 04             	mov    0x4(%eax),%eax
  8032af:	85 c0                	test   %eax,%eax
  8032b1:	74 0f                	je     8032c2 <insert_sorted_with_merge_freeList+0x4d3>
  8032b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b6:	8b 40 04             	mov    0x4(%eax),%eax
  8032b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032bc:	8b 12                	mov    (%edx),%edx
  8032be:	89 10                	mov    %edx,(%eax)
  8032c0:	eb 0a                	jmp    8032cc <insert_sorted_with_merge_freeList+0x4dd>
  8032c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c5:	8b 00                	mov    (%eax),%eax
  8032c7:	a3 38 51 80 00       	mov    %eax,0x805138
  8032cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032df:	a1 44 51 80 00       	mov    0x805144,%eax
  8032e4:	48                   	dec    %eax
  8032e5:	a3 44 51 80 00       	mov    %eax,0x805144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  8032ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032ee:	75 17                	jne    803307 <insert_sorted_with_merge_freeList+0x518>
  8032f0:	83 ec 04             	sub    $0x4,%esp
  8032f3:	68 90 3f 80 00       	push   $0x803f90
  8032f8:	68 4f 01 00 00       	push   $0x14f
  8032fd:	68 b3 3f 80 00       	push   $0x803fb3
  803302:	e8 52 d4 ff ff       	call   800759 <_panic>
  803307:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80330d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803310:	89 10                	mov    %edx,(%eax)
  803312:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803315:	8b 00                	mov    (%eax),%eax
  803317:	85 c0                	test   %eax,%eax
  803319:	74 0d                	je     803328 <insert_sorted_with_merge_freeList+0x539>
  80331b:	a1 48 51 80 00       	mov    0x805148,%eax
  803320:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803323:	89 50 04             	mov    %edx,0x4(%eax)
  803326:	eb 08                	jmp    803330 <insert_sorted_with_merge_freeList+0x541>
  803328:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803330:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803333:	a3 48 51 80 00       	mov    %eax,0x805148
  803338:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803342:	a1 54 51 80 00       	mov    0x805154,%eax
  803347:	40                   	inc    %eax
  803348:	a3 54 51 80 00       	mov    %eax,0x805154
  80334d:	e9 65 01 00 00       	jmp    8034b7 <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  803352:	8b 45 08             	mov    0x8(%ebp),%eax
  803355:	8b 40 08             	mov    0x8(%eax),%eax
  803358:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80335b:	0f 85 9f 00 00 00    	jne    803400 <insert_sorted_with_merge_freeList+0x611>
  803361:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803364:	8b 40 08             	mov    0x8(%eax),%eax
  803367:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80336a:	0f 84 90 00 00 00    	je     803400 <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  803370:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803373:	8b 50 0c             	mov    0xc(%eax),%edx
  803376:	8b 45 08             	mov    0x8(%ebp),%eax
  803379:	8b 40 0c             	mov    0xc(%eax),%eax
  80337c:	01 c2                	add    %eax,%edx
  80337e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803381:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  803384:	8b 45 08             	mov    0x8(%ebp),%eax
  803387:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  80338e:	8b 45 08             	mov    0x8(%ebp),%eax
  803391:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803398:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80339c:	75 17                	jne    8033b5 <insert_sorted_with_merge_freeList+0x5c6>
  80339e:	83 ec 04             	sub    $0x4,%esp
  8033a1:	68 90 3f 80 00       	push   $0x803f90
  8033a6:	68 58 01 00 00       	push   $0x158
  8033ab:	68 b3 3f 80 00       	push   $0x803fb3
  8033b0:	e8 a4 d3 ff ff       	call   800759 <_panic>
  8033b5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033be:	89 10                	mov    %edx,(%eax)
  8033c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c3:	8b 00                	mov    (%eax),%eax
  8033c5:	85 c0                	test   %eax,%eax
  8033c7:	74 0d                	je     8033d6 <insert_sorted_with_merge_freeList+0x5e7>
  8033c9:	a1 48 51 80 00       	mov    0x805148,%eax
  8033ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8033d1:	89 50 04             	mov    %edx,0x4(%eax)
  8033d4:	eb 08                	jmp    8033de <insert_sorted_with_merge_freeList+0x5ef>
  8033d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033de:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e1:	a3 48 51 80 00       	mov    %eax,0x805148
  8033e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033f0:	a1 54 51 80 00       	mov    0x805154,%eax
  8033f5:	40                   	inc    %eax
  8033f6:	a3 54 51 80 00       	mov    %eax,0x805154
  8033fb:	e9 b7 00 00 00       	jmp    8034b7 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  803400:	8b 45 08             	mov    0x8(%ebp),%eax
  803403:	8b 40 08             	mov    0x8(%eax),%eax
  803406:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803409:	0f 84 e2 00 00 00    	je     8034f1 <insert_sorted_with_merge_freeList+0x702>
  80340f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803412:	8b 40 08             	mov    0x8(%eax),%eax
  803415:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  803418:	0f 85 d3 00 00 00    	jne    8034f1 <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  80341e:	8b 45 08             	mov    0x8(%ebp),%eax
  803421:	8b 50 08             	mov    0x8(%eax),%edx
  803424:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803427:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  80342a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80342d:	8b 50 0c             	mov    0xc(%eax),%edx
  803430:	8b 45 08             	mov    0x8(%ebp),%eax
  803433:	8b 40 0c             	mov    0xc(%eax),%eax
  803436:	01 c2                	add    %eax,%edx
  803438:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343b:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  80343e:	8b 45 08             	mov    0x8(%ebp),%eax
  803441:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  803448:	8b 45 08             	mov    0x8(%ebp),%eax
  80344b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803452:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803456:	75 17                	jne    80346f <insert_sorted_with_merge_freeList+0x680>
  803458:	83 ec 04             	sub    $0x4,%esp
  80345b:	68 90 3f 80 00       	push   $0x803f90
  803460:	68 61 01 00 00       	push   $0x161
  803465:	68 b3 3f 80 00       	push   $0x803fb3
  80346a:	e8 ea d2 ff ff       	call   800759 <_panic>
  80346f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803475:	8b 45 08             	mov    0x8(%ebp),%eax
  803478:	89 10                	mov    %edx,(%eax)
  80347a:	8b 45 08             	mov    0x8(%ebp),%eax
  80347d:	8b 00                	mov    (%eax),%eax
  80347f:	85 c0                	test   %eax,%eax
  803481:	74 0d                	je     803490 <insert_sorted_with_merge_freeList+0x6a1>
  803483:	a1 48 51 80 00       	mov    0x805148,%eax
  803488:	8b 55 08             	mov    0x8(%ebp),%edx
  80348b:	89 50 04             	mov    %edx,0x4(%eax)
  80348e:	eb 08                	jmp    803498 <insert_sorted_with_merge_freeList+0x6a9>
  803490:	8b 45 08             	mov    0x8(%ebp),%eax
  803493:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803498:	8b 45 08             	mov    0x8(%ebp),%eax
  80349b:	a3 48 51 80 00       	mov    %eax,0x805148
  8034a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034aa:	a1 54 51 80 00       	mov    0x805154,%eax
  8034af:	40                   	inc    %eax
  8034b0:	a3 54 51 80 00       	mov    %eax,0x805154
								}
								break;
  8034b5:	eb 3a                	jmp    8034f1 <insert_sorted_with_merge_freeList+0x702>
  8034b7:	eb 38                	jmp    8034f1 <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  8034b9:	a1 40 51 80 00       	mov    0x805140,%eax
  8034be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034c5:	74 07                	je     8034ce <insert_sorted_with_merge_freeList+0x6df>
  8034c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ca:	8b 00                	mov    (%eax),%eax
  8034cc:	eb 05                	jmp    8034d3 <insert_sorted_with_merge_freeList+0x6e4>
  8034ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8034d3:	a3 40 51 80 00       	mov    %eax,0x805140
  8034d8:	a1 40 51 80 00       	mov    0x805140,%eax
  8034dd:	85 c0                	test   %eax,%eax
  8034df:	0f 85 fa fb ff ff    	jne    8030df <insert_sorted_with_merge_freeList+0x2f0>
  8034e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034e9:	0f 85 f0 fb ff ff    	jne    8030df <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  8034ef:	eb 01                	jmp    8034f2 <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  8034f1:	90                   	nop
							}

						}
		          }
		}
}
  8034f2:	90                   	nop
  8034f3:	c9                   	leave  
  8034f4:	c3                   	ret    
  8034f5:	66 90                	xchg   %ax,%ax
  8034f7:	90                   	nop

008034f8 <__udivdi3>:
  8034f8:	55                   	push   %ebp
  8034f9:	57                   	push   %edi
  8034fa:	56                   	push   %esi
  8034fb:	53                   	push   %ebx
  8034fc:	83 ec 1c             	sub    $0x1c,%esp
  8034ff:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803503:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803507:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80350b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80350f:	89 ca                	mov    %ecx,%edx
  803511:	89 f8                	mov    %edi,%eax
  803513:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803517:	85 f6                	test   %esi,%esi
  803519:	75 2d                	jne    803548 <__udivdi3+0x50>
  80351b:	39 cf                	cmp    %ecx,%edi
  80351d:	77 65                	ja     803584 <__udivdi3+0x8c>
  80351f:	89 fd                	mov    %edi,%ebp
  803521:	85 ff                	test   %edi,%edi
  803523:	75 0b                	jne    803530 <__udivdi3+0x38>
  803525:	b8 01 00 00 00       	mov    $0x1,%eax
  80352a:	31 d2                	xor    %edx,%edx
  80352c:	f7 f7                	div    %edi
  80352e:	89 c5                	mov    %eax,%ebp
  803530:	31 d2                	xor    %edx,%edx
  803532:	89 c8                	mov    %ecx,%eax
  803534:	f7 f5                	div    %ebp
  803536:	89 c1                	mov    %eax,%ecx
  803538:	89 d8                	mov    %ebx,%eax
  80353a:	f7 f5                	div    %ebp
  80353c:	89 cf                	mov    %ecx,%edi
  80353e:	89 fa                	mov    %edi,%edx
  803540:	83 c4 1c             	add    $0x1c,%esp
  803543:	5b                   	pop    %ebx
  803544:	5e                   	pop    %esi
  803545:	5f                   	pop    %edi
  803546:	5d                   	pop    %ebp
  803547:	c3                   	ret    
  803548:	39 ce                	cmp    %ecx,%esi
  80354a:	77 28                	ja     803574 <__udivdi3+0x7c>
  80354c:	0f bd fe             	bsr    %esi,%edi
  80354f:	83 f7 1f             	xor    $0x1f,%edi
  803552:	75 40                	jne    803594 <__udivdi3+0x9c>
  803554:	39 ce                	cmp    %ecx,%esi
  803556:	72 0a                	jb     803562 <__udivdi3+0x6a>
  803558:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80355c:	0f 87 9e 00 00 00    	ja     803600 <__udivdi3+0x108>
  803562:	b8 01 00 00 00       	mov    $0x1,%eax
  803567:	89 fa                	mov    %edi,%edx
  803569:	83 c4 1c             	add    $0x1c,%esp
  80356c:	5b                   	pop    %ebx
  80356d:	5e                   	pop    %esi
  80356e:	5f                   	pop    %edi
  80356f:	5d                   	pop    %ebp
  803570:	c3                   	ret    
  803571:	8d 76 00             	lea    0x0(%esi),%esi
  803574:	31 ff                	xor    %edi,%edi
  803576:	31 c0                	xor    %eax,%eax
  803578:	89 fa                	mov    %edi,%edx
  80357a:	83 c4 1c             	add    $0x1c,%esp
  80357d:	5b                   	pop    %ebx
  80357e:	5e                   	pop    %esi
  80357f:	5f                   	pop    %edi
  803580:	5d                   	pop    %ebp
  803581:	c3                   	ret    
  803582:	66 90                	xchg   %ax,%ax
  803584:	89 d8                	mov    %ebx,%eax
  803586:	f7 f7                	div    %edi
  803588:	31 ff                	xor    %edi,%edi
  80358a:	89 fa                	mov    %edi,%edx
  80358c:	83 c4 1c             	add    $0x1c,%esp
  80358f:	5b                   	pop    %ebx
  803590:	5e                   	pop    %esi
  803591:	5f                   	pop    %edi
  803592:	5d                   	pop    %ebp
  803593:	c3                   	ret    
  803594:	bd 20 00 00 00       	mov    $0x20,%ebp
  803599:	89 eb                	mov    %ebp,%ebx
  80359b:	29 fb                	sub    %edi,%ebx
  80359d:	89 f9                	mov    %edi,%ecx
  80359f:	d3 e6                	shl    %cl,%esi
  8035a1:	89 c5                	mov    %eax,%ebp
  8035a3:	88 d9                	mov    %bl,%cl
  8035a5:	d3 ed                	shr    %cl,%ebp
  8035a7:	89 e9                	mov    %ebp,%ecx
  8035a9:	09 f1                	or     %esi,%ecx
  8035ab:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8035af:	89 f9                	mov    %edi,%ecx
  8035b1:	d3 e0                	shl    %cl,%eax
  8035b3:	89 c5                	mov    %eax,%ebp
  8035b5:	89 d6                	mov    %edx,%esi
  8035b7:	88 d9                	mov    %bl,%cl
  8035b9:	d3 ee                	shr    %cl,%esi
  8035bb:	89 f9                	mov    %edi,%ecx
  8035bd:	d3 e2                	shl    %cl,%edx
  8035bf:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035c3:	88 d9                	mov    %bl,%cl
  8035c5:	d3 e8                	shr    %cl,%eax
  8035c7:	09 c2                	or     %eax,%edx
  8035c9:	89 d0                	mov    %edx,%eax
  8035cb:	89 f2                	mov    %esi,%edx
  8035cd:	f7 74 24 0c          	divl   0xc(%esp)
  8035d1:	89 d6                	mov    %edx,%esi
  8035d3:	89 c3                	mov    %eax,%ebx
  8035d5:	f7 e5                	mul    %ebp
  8035d7:	39 d6                	cmp    %edx,%esi
  8035d9:	72 19                	jb     8035f4 <__udivdi3+0xfc>
  8035db:	74 0b                	je     8035e8 <__udivdi3+0xf0>
  8035dd:	89 d8                	mov    %ebx,%eax
  8035df:	31 ff                	xor    %edi,%edi
  8035e1:	e9 58 ff ff ff       	jmp    80353e <__udivdi3+0x46>
  8035e6:	66 90                	xchg   %ax,%ax
  8035e8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8035ec:	89 f9                	mov    %edi,%ecx
  8035ee:	d3 e2                	shl    %cl,%edx
  8035f0:	39 c2                	cmp    %eax,%edx
  8035f2:	73 e9                	jae    8035dd <__udivdi3+0xe5>
  8035f4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8035f7:	31 ff                	xor    %edi,%edi
  8035f9:	e9 40 ff ff ff       	jmp    80353e <__udivdi3+0x46>
  8035fe:	66 90                	xchg   %ax,%ax
  803600:	31 c0                	xor    %eax,%eax
  803602:	e9 37 ff ff ff       	jmp    80353e <__udivdi3+0x46>
  803607:	90                   	nop

00803608 <__umoddi3>:
  803608:	55                   	push   %ebp
  803609:	57                   	push   %edi
  80360a:	56                   	push   %esi
  80360b:	53                   	push   %ebx
  80360c:	83 ec 1c             	sub    $0x1c,%esp
  80360f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803613:	8b 74 24 34          	mov    0x34(%esp),%esi
  803617:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80361b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80361f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803623:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803627:	89 f3                	mov    %esi,%ebx
  803629:	89 fa                	mov    %edi,%edx
  80362b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80362f:	89 34 24             	mov    %esi,(%esp)
  803632:	85 c0                	test   %eax,%eax
  803634:	75 1a                	jne    803650 <__umoddi3+0x48>
  803636:	39 f7                	cmp    %esi,%edi
  803638:	0f 86 a2 00 00 00    	jbe    8036e0 <__umoddi3+0xd8>
  80363e:	89 c8                	mov    %ecx,%eax
  803640:	89 f2                	mov    %esi,%edx
  803642:	f7 f7                	div    %edi
  803644:	89 d0                	mov    %edx,%eax
  803646:	31 d2                	xor    %edx,%edx
  803648:	83 c4 1c             	add    $0x1c,%esp
  80364b:	5b                   	pop    %ebx
  80364c:	5e                   	pop    %esi
  80364d:	5f                   	pop    %edi
  80364e:	5d                   	pop    %ebp
  80364f:	c3                   	ret    
  803650:	39 f0                	cmp    %esi,%eax
  803652:	0f 87 ac 00 00 00    	ja     803704 <__umoddi3+0xfc>
  803658:	0f bd e8             	bsr    %eax,%ebp
  80365b:	83 f5 1f             	xor    $0x1f,%ebp
  80365e:	0f 84 ac 00 00 00    	je     803710 <__umoddi3+0x108>
  803664:	bf 20 00 00 00       	mov    $0x20,%edi
  803669:	29 ef                	sub    %ebp,%edi
  80366b:	89 fe                	mov    %edi,%esi
  80366d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803671:	89 e9                	mov    %ebp,%ecx
  803673:	d3 e0                	shl    %cl,%eax
  803675:	89 d7                	mov    %edx,%edi
  803677:	89 f1                	mov    %esi,%ecx
  803679:	d3 ef                	shr    %cl,%edi
  80367b:	09 c7                	or     %eax,%edi
  80367d:	89 e9                	mov    %ebp,%ecx
  80367f:	d3 e2                	shl    %cl,%edx
  803681:	89 14 24             	mov    %edx,(%esp)
  803684:	89 d8                	mov    %ebx,%eax
  803686:	d3 e0                	shl    %cl,%eax
  803688:	89 c2                	mov    %eax,%edx
  80368a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80368e:	d3 e0                	shl    %cl,%eax
  803690:	89 44 24 04          	mov    %eax,0x4(%esp)
  803694:	8b 44 24 08          	mov    0x8(%esp),%eax
  803698:	89 f1                	mov    %esi,%ecx
  80369a:	d3 e8                	shr    %cl,%eax
  80369c:	09 d0                	or     %edx,%eax
  80369e:	d3 eb                	shr    %cl,%ebx
  8036a0:	89 da                	mov    %ebx,%edx
  8036a2:	f7 f7                	div    %edi
  8036a4:	89 d3                	mov    %edx,%ebx
  8036a6:	f7 24 24             	mull   (%esp)
  8036a9:	89 c6                	mov    %eax,%esi
  8036ab:	89 d1                	mov    %edx,%ecx
  8036ad:	39 d3                	cmp    %edx,%ebx
  8036af:	0f 82 87 00 00 00    	jb     80373c <__umoddi3+0x134>
  8036b5:	0f 84 91 00 00 00    	je     80374c <__umoddi3+0x144>
  8036bb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8036bf:	29 f2                	sub    %esi,%edx
  8036c1:	19 cb                	sbb    %ecx,%ebx
  8036c3:	89 d8                	mov    %ebx,%eax
  8036c5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8036c9:	d3 e0                	shl    %cl,%eax
  8036cb:	89 e9                	mov    %ebp,%ecx
  8036cd:	d3 ea                	shr    %cl,%edx
  8036cf:	09 d0                	or     %edx,%eax
  8036d1:	89 e9                	mov    %ebp,%ecx
  8036d3:	d3 eb                	shr    %cl,%ebx
  8036d5:	89 da                	mov    %ebx,%edx
  8036d7:	83 c4 1c             	add    $0x1c,%esp
  8036da:	5b                   	pop    %ebx
  8036db:	5e                   	pop    %esi
  8036dc:	5f                   	pop    %edi
  8036dd:	5d                   	pop    %ebp
  8036de:	c3                   	ret    
  8036df:	90                   	nop
  8036e0:	89 fd                	mov    %edi,%ebp
  8036e2:	85 ff                	test   %edi,%edi
  8036e4:	75 0b                	jne    8036f1 <__umoddi3+0xe9>
  8036e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8036eb:	31 d2                	xor    %edx,%edx
  8036ed:	f7 f7                	div    %edi
  8036ef:	89 c5                	mov    %eax,%ebp
  8036f1:	89 f0                	mov    %esi,%eax
  8036f3:	31 d2                	xor    %edx,%edx
  8036f5:	f7 f5                	div    %ebp
  8036f7:	89 c8                	mov    %ecx,%eax
  8036f9:	f7 f5                	div    %ebp
  8036fb:	89 d0                	mov    %edx,%eax
  8036fd:	e9 44 ff ff ff       	jmp    803646 <__umoddi3+0x3e>
  803702:	66 90                	xchg   %ax,%ax
  803704:	89 c8                	mov    %ecx,%eax
  803706:	89 f2                	mov    %esi,%edx
  803708:	83 c4 1c             	add    $0x1c,%esp
  80370b:	5b                   	pop    %ebx
  80370c:	5e                   	pop    %esi
  80370d:	5f                   	pop    %edi
  80370e:	5d                   	pop    %ebp
  80370f:	c3                   	ret    
  803710:	3b 04 24             	cmp    (%esp),%eax
  803713:	72 06                	jb     80371b <__umoddi3+0x113>
  803715:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803719:	77 0f                	ja     80372a <__umoddi3+0x122>
  80371b:	89 f2                	mov    %esi,%edx
  80371d:	29 f9                	sub    %edi,%ecx
  80371f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803723:	89 14 24             	mov    %edx,(%esp)
  803726:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80372a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80372e:	8b 14 24             	mov    (%esp),%edx
  803731:	83 c4 1c             	add    $0x1c,%esp
  803734:	5b                   	pop    %ebx
  803735:	5e                   	pop    %esi
  803736:	5f                   	pop    %edi
  803737:	5d                   	pop    %ebp
  803738:	c3                   	ret    
  803739:	8d 76 00             	lea    0x0(%esi),%esi
  80373c:	2b 04 24             	sub    (%esp),%eax
  80373f:	19 fa                	sbb    %edi,%edx
  803741:	89 d1                	mov    %edx,%ecx
  803743:	89 c6                	mov    %eax,%esi
  803745:	e9 71 ff ff ff       	jmp    8036bb <__umoddi3+0xb3>
  80374a:	66 90                	xchg   %ax,%ax
  80374c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803750:	72 ea                	jb     80373c <__umoddi3+0x134>
  803752:	89 d9                	mov    %ebx,%ecx
  803754:	e9 62 ff ff ff       	jmp    8036bb <__umoddi3+0xb3>

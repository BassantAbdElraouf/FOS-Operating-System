
obj/user/tst_air_customer:     file format elf32-i386


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
  800031:	e8 dc 03 00 00       	call   800412 <libmain>
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
  80003e:	81 ec 8c 01 00 00    	sub    $0x18c,%esp
	int32 parentenvID = sys_getparentenvid();
  800044:	e8 6e 1c 00 00       	call   801cb7 <sys_getparentenvid>
  800049:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	char _customers[] = "customers";
  80004c:	8d 45 c2             	lea    -0x3e(%ebp),%eax
  80004f:	bb a9 35 80 00       	mov    $0x8035a9,%ebx
  800054:	ba 0a 00 00 00       	mov    $0xa,%edx
  800059:	89 c7                	mov    %eax,%edi
  80005b:	89 de                	mov    %ebx,%esi
  80005d:	89 d1                	mov    %edx,%ecx
  80005f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  800061:	8d 45 b6             	lea    -0x4a(%ebp),%eax
  800064:	bb b3 35 80 00       	mov    $0x8035b3,%ebx
  800069:	ba 03 00 00 00       	mov    $0x3,%edx
  80006e:	89 c7                	mov    %eax,%edi
  800070:	89 de                	mov    %ebx,%esi
  800072:	89 d1                	mov    %edx,%ecx
  800074:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  800076:	8d 45 a7             	lea    -0x59(%ebp),%eax
  800079:	bb bf 35 80 00       	mov    $0x8035bf,%ebx
  80007e:	ba 0f 00 00 00       	mov    $0xf,%edx
  800083:	89 c7                	mov    %eax,%edi
  800085:	89 de                	mov    %ebx,%esi
  800087:	89 d1                	mov    %edx,%ecx
  800089:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  80008b:	8d 45 98             	lea    -0x68(%ebp),%eax
  80008e:	bb ce 35 80 00       	mov    $0x8035ce,%ebx
  800093:	ba 0f 00 00 00       	mov    $0xf,%edx
  800098:	89 c7                	mov    %eax,%edi
  80009a:	89 de                	mov    %ebx,%esi
  80009c:	89 d1                	mov    %edx,%ecx
  80009e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000a0:	8d 45 83             	lea    -0x7d(%ebp),%eax
  8000a3:	bb dd 35 80 00       	mov    $0x8035dd,%ebx
  8000a8:	ba 15 00 00 00       	mov    $0x15,%edx
  8000ad:	89 c7                	mov    %eax,%edi
  8000af:	89 de                	mov    %ebx,%esi
  8000b1:	89 d1                	mov    %edx,%ecx
  8000b3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000b5:	8d 85 6e ff ff ff    	lea    -0x92(%ebp),%eax
  8000bb:	bb f2 35 80 00       	mov    $0x8035f2,%ebx
  8000c0:	ba 15 00 00 00       	mov    $0x15,%edx
  8000c5:	89 c7                	mov    %eax,%edi
  8000c7:	89 de                	mov    %ebx,%esi
  8000c9:	89 d1                	mov    %edx,%ecx
  8000cb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  8000cd:	8d 85 5d ff ff ff    	lea    -0xa3(%ebp),%eax
  8000d3:	bb 07 36 80 00       	mov    $0x803607,%ebx
  8000d8:	ba 11 00 00 00       	mov    $0x11,%edx
  8000dd:	89 c7                	mov    %eax,%edi
  8000df:	89 de                	mov    %ebx,%esi
  8000e1:	89 d1                	mov    %edx,%ecx
  8000e3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  8000e5:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  8000eb:	bb 18 36 80 00       	mov    $0x803618,%ebx
  8000f0:	ba 11 00 00 00       	mov    $0x11,%edx
  8000f5:	89 c7                	mov    %eax,%edi
  8000f7:	89 de                	mov    %ebx,%esi
  8000f9:	89 d1                	mov    %edx,%ecx
  8000fb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  8000fd:	8d 85 3b ff ff ff    	lea    -0xc5(%ebp),%eax
  800103:	bb 29 36 80 00       	mov    $0x803629,%ebx
  800108:	ba 11 00 00 00       	mov    $0x11,%edx
  80010d:	89 c7                	mov    %eax,%edi
  80010f:	89 de                	mov    %ebx,%esi
  800111:	89 d1                	mov    %edx,%ecx
  800113:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  800115:	8d 85 32 ff ff ff    	lea    -0xce(%ebp),%eax
  80011b:	bb 3a 36 80 00       	mov    $0x80363a,%ebx
  800120:	ba 09 00 00 00       	mov    $0x9,%edx
  800125:	89 c7                	mov    %eax,%edi
  800127:	89 de                	mov    %ebx,%esi
  800129:	89 d1                	mov    %edx,%ecx
  80012b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  80012d:	8d 85 28 ff ff ff    	lea    -0xd8(%ebp),%eax
  800133:	bb 43 36 80 00       	mov    $0x803643,%ebx
  800138:	ba 0a 00 00 00       	mov    $0xa,%edx
  80013d:	89 c7                	mov    %eax,%edi
  80013f:	89 de                	mov    %ebx,%esi
  800141:	89 d1                	mov    %edx,%ecx
  800143:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  800145:	8d 85 1d ff ff ff    	lea    -0xe3(%ebp),%eax
  80014b:	bb 4d 36 80 00       	mov    $0x80364d,%ebx
  800150:	ba 0b 00 00 00       	mov    $0xb,%edx
  800155:	89 c7                	mov    %eax,%edi
  800157:	89 de                	mov    %ebx,%esi
  800159:	89 d1                	mov    %edx,%ecx
  80015b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  80015d:	8d 85 11 ff ff ff    	lea    -0xef(%ebp),%eax
  800163:	bb 58 36 80 00       	mov    $0x803658,%ebx
  800168:	ba 03 00 00 00       	mov    $0x3,%edx
  80016d:	89 c7                	mov    %eax,%edi
  80016f:	89 de                	mov    %ebx,%esi
  800171:	89 d1                	mov    %edx,%ecx
  800173:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  800175:	8d 85 07 ff ff ff    	lea    -0xf9(%ebp),%eax
  80017b:	bb 64 36 80 00       	mov    $0x803664,%ebx
  800180:	ba 0a 00 00 00       	mov    $0xa,%edx
  800185:	89 c7                	mov    %eax,%edi
  800187:	89 de                	mov    %ebx,%esi
  800189:	89 d1                	mov    %edx,%ecx
  80018b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  80018d:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800193:	bb 6e 36 80 00       	mov    $0x80366e,%ebx
  800198:	ba 0a 00 00 00       	mov    $0xa,%edx
  80019d:	89 c7                	mov    %eax,%edi
  80019f:	89 de                	mov    %ebx,%esi
  8001a1:	89 d1                	mov    %edx,%ecx
  8001a3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _clerk[] = "clerk";
  8001a5:	c7 85 f7 fe ff ff 63 	movl   $0x72656c63,-0x109(%ebp)
  8001ac:	6c 65 72 
  8001af:	66 c7 85 fb fe ff ff 	movw   $0x6b,-0x105(%ebp)
  8001b6:	6b 00 
	char _custCounterCS[] = "custCounterCS";
  8001b8:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8001be:	bb 78 36 80 00       	mov    $0x803678,%ebx
  8001c3:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001c8:	89 c7                	mov    %eax,%edi
  8001ca:	89 de                	mov    %ebx,%esi
  8001cc:	89 d1                	mov    %edx,%ecx
  8001ce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  8001d0:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  8001d6:	bb 86 36 80 00       	mov    $0x803686,%ebx
  8001db:	ba 0f 00 00 00       	mov    $0xf,%edx
  8001e0:	89 c7                	mov    %eax,%edi
  8001e2:	89 de                	mov    %ebx,%esi
  8001e4:	89 d1                	mov    %edx,%ecx
  8001e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  8001e8:	8d 85 d3 fe ff ff    	lea    -0x12d(%ebp),%eax
  8001ee:	bb 95 36 80 00       	mov    $0x803695,%ebx
  8001f3:	ba 07 00 00 00       	mov    $0x7,%edx
  8001f8:	89 c7                	mov    %eax,%edi
  8001fa:	89 de                	mov    %ebx,%esi
  8001fc:	89 d1                	mov    %edx,%ecx
  8001fe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800200:	8d 85 cc fe ff ff    	lea    -0x134(%ebp),%eax
  800206:	bb 9c 36 80 00       	mov    $0x80369c,%ebx
  80020b:	ba 07 00 00 00       	mov    $0x7,%edx
  800210:	89 c7                	mov    %eax,%edi
  800212:	89 de                	mov    %ebx,%esi
  800214:	89 d1                	mov    %edx,%ecx
  800216:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	// Get the shared variables from the main program ***********************************

	struct Customer * customers = sget(parentenvID, _customers);
  800218:	83 ec 08             	sub    $0x8,%esp
  80021b:	8d 45 c2             	lea    -0x3e(%ebp),%eax
  80021e:	50                   	push   %eax
  80021f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800222:	e8 50 15 00 00       	call   801777 <sget>
  800227:	83 c4 10             	add    $0x10,%esp
  80022a:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int* custCounter = sget(parentenvID, _custCounter);
  80022d:	83 ec 08             	sub    $0x8,%esp
  800230:	8d 45 b6             	lea    -0x4a(%ebp),%eax
  800233:	50                   	push   %eax
  800234:	ff 75 e4             	pushl  -0x1c(%ebp)
  800237:	e8 3b 15 00 00       	call   801777 <sget>
  80023c:	83 c4 10             	add    $0x10,%esp
  80023f:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int* cust_ready_queue = sget(parentenvID, _cust_ready_queue);
  800242:	83 ec 08             	sub    $0x8,%esp
  800245:	8d 85 3b ff ff ff    	lea    -0xc5(%ebp),%eax
  80024b:	50                   	push   %eax
  80024c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024f:	e8 23 15 00 00       	call   801777 <sget>
  800254:	83 c4 10             	add    $0x10,%esp
  800257:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* queue_in = sget(parentenvID, _queue_in);
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	8d 85 32 ff ff ff    	lea    -0xce(%ebp),%eax
  800263:	50                   	push   %eax
  800264:	ff 75 e4             	pushl  -0x1c(%ebp)
  800267:	e8 0b 15 00 00       	call   801777 <sget>
  80026c:	83 c4 10             	add    $0x10,%esp
  80026f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	// *********************************************************************************

	int custId, flightType;
	sys_waitSemaphore(parentenvID, _custCounterCS);
  800272:	83 ec 08             	sub    $0x8,%esp
  800275:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80027b:	50                   	push   %eax
  80027c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80027f:	e8 d4 18 00 00       	call   801b58 <sys_waitSemaphore>
  800284:	83 c4 10             	add    $0x10,%esp
	{
		custId = *custCounter;
  800287:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80028a:	8b 00                	mov    (%eax),%eax
  80028c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		//cprintf("custCounter= %d\n", *custCounter);
		*custCounter = *custCounter +1;
  80028f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800292:	8b 00                	mov    (%eax),%eax
  800294:	8d 50 01             	lea    0x1(%eax),%edx
  800297:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80029a:	89 10                	mov    %edx,(%eax)
	}
	sys_signalSemaphore(parentenvID, _custCounterCS);
  80029c:	83 ec 08             	sub    $0x8,%esp
  80029f:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8002a5:	50                   	push   %eax
  8002a6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a9:	e8 c8 18 00 00       	call   801b76 <sys_signalSemaphore>
  8002ae:	83 c4 10             	add    $0x10,%esp

	//wait on one of the clerks
	sys_waitSemaphore(parentenvID, _clerk);
  8002b1:	83 ec 08             	sub    $0x8,%esp
  8002b4:	8d 85 f7 fe ff ff    	lea    -0x109(%ebp),%eax
  8002ba:	50                   	push   %eax
  8002bb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002be:	e8 95 18 00 00       	call   801b58 <sys_waitSemaphore>
  8002c3:	83 c4 10             	add    $0x10,%esp

	//enqueue the request
	flightType = customers[custId].flightType;
  8002c6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8002c9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8002d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002d3:	01 d0                	add    %edx,%eax
  8002d5:	8b 00                	mov    (%eax),%eax
  8002d7:	89 45 cc             	mov    %eax,-0x34(%ebp)
	sys_waitSemaphore(parentenvID, _custQueueCS);
  8002da:	83 ec 08             	sub    $0x8,%esp
  8002dd:	8d 85 11 ff ff ff    	lea    -0xef(%ebp),%eax
  8002e3:	50                   	push   %eax
  8002e4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002e7:	e8 6c 18 00 00       	call   801b58 <sys_waitSemaphore>
  8002ec:	83 c4 10             	add    $0x10,%esp
	{
		cust_ready_queue[*queue_in] = custId;
  8002ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002f2:	8b 00                	mov    (%eax),%eax
  8002f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002fb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002fe:	01 c2                	add    %eax,%edx
  800300:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800303:	89 02                	mov    %eax,(%edx)
		*queue_in = *queue_in +1;
  800305:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800308:	8b 00                	mov    (%eax),%eax
  80030a:	8d 50 01             	lea    0x1(%eax),%edx
  80030d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800310:	89 10                	mov    %edx,(%eax)
	}
	sys_signalSemaphore(parentenvID, _custQueueCS);
  800312:	83 ec 08             	sub    $0x8,%esp
  800315:	8d 85 11 ff ff ff    	lea    -0xef(%ebp),%eax
  80031b:	50                   	push   %eax
  80031c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80031f:	e8 52 18 00 00       	call   801b76 <sys_signalSemaphore>
  800324:	83 c4 10             	add    $0x10,%esp

	//signal ready
	sys_signalSemaphore(parentenvID, _cust_ready);
  800327:	83 ec 08             	sub    $0x8,%esp
  80032a:	8d 85 1d ff ff ff    	lea    -0xe3(%ebp),%eax
  800330:	50                   	push   %eax
  800331:	ff 75 e4             	pushl  -0x1c(%ebp)
  800334:	e8 3d 18 00 00       	call   801b76 <sys_signalSemaphore>
  800339:	83 c4 10             	add    $0x10,%esp

	//wait on finished
	char prefix[30]="cust_finished";
  80033c:	8d 85 ae fe ff ff    	lea    -0x152(%ebp),%eax
  800342:	bb a3 36 80 00       	mov    $0x8036a3,%ebx
  800347:	ba 0e 00 00 00       	mov    $0xe,%edx
  80034c:	89 c7                	mov    %eax,%edi
  80034e:	89 de                	mov    %ebx,%esi
  800350:	89 d1                	mov    %edx,%ecx
  800352:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800354:	8d 95 bc fe ff ff    	lea    -0x144(%ebp),%edx
  80035a:	b9 04 00 00 00       	mov    $0x4,%ecx
  80035f:	b8 00 00 00 00       	mov    $0x0,%eax
  800364:	89 d7                	mov    %edx,%edi
  800366:	f3 ab                	rep stos %eax,%es:(%edi)
	char id[5]; char sname[50];
	ltostr(custId, id);
  800368:	83 ec 08             	sub    $0x8,%esp
  80036b:	8d 85 a9 fe ff ff    	lea    -0x157(%ebp),%eax
  800371:	50                   	push   %eax
  800372:	ff 75 d0             	pushl  -0x30(%ebp)
  800375:	e8 d0 0d 00 00       	call   80114a <ltostr>
  80037a:	83 c4 10             	add    $0x10,%esp
	strcconcat(prefix, id, sname);
  80037d:	83 ec 04             	sub    $0x4,%esp
  800380:	8d 85 77 fe ff ff    	lea    -0x189(%ebp),%eax
  800386:	50                   	push   %eax
  800387:	8d 85 a9 fe ff ff    	lea    -0x157(%ebp),%eax
  80038d:	50                   	push   %eax
  80038e:	8d 85 ae fe ff ff    	lea    -0x152(%ebp),%eax
  800394:	50                   	push   %eax
  800395:	e8 a8 0e 00 00       	call   801242 <strcconcat>
  80039a:	83 c4 10             	add    $0x10,%esp
	sys_waitSemaphore(parentenvID, sname);
  80039d:	83 ec 08             	sub    $0x8,%esp
  8003a0:	8d 85 77 fe ff ff    	lea    -0x189(%ebp),%eax
  8003a6:	50                   	push   %eax
  8003a7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003aa:	e8 a9 17 00 00       	call   801b58 <sys_waitSemaphore>
  8003af:	83 c4 10             	add    $0x10,%esp

	//print the customer status
	if(customers[custId].booked == 1)
  8003b2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003b5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8003bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003bf:	01 d0                	add    %edx,%eax
  8003c1:	8b 40 04             	mov    0x4(%eax),%eax
  8003c4:	83 f8 01             	cmp    $0x1,%eax
  8003c7:	75 18                	jne    8003e1 <_main+0x3a9>
	{
		cprintf("cust %d: finished (BOOKED flight %d) \n", custId, flightType);
  8003c9:	83 ec 04             	sub    $0x4,%esp
  8003cc:	ff 75 cc             	pushl  -0x34(%ebp)
  8003cf:	ff 75 d0             	pushl  -0x30(%ebp)
  8003d2:	68 60 35 80 00       	push   $0x803560
  8003d7:	e8 46 02 00 00       	call   800622 <cprintf>
  8003dc:	83 c4 10             	add    $0x10,%esp
  8003df:	eb 13                	jmp    8003f4 <_main+0x3bc>
	}
	else
	{
		cprintf("cust %d: finished (NOT BOOKED) \n", custId);
  8003e1:	83 ec 08             	sub    $0x8,%esp
  8003e4:	ff 75 d0             	pushl  -0x30(%ebp)
  8003e7:	68 88 35 80 00       	push   $0x803588
  8003ec:	e8 31 02 00 00       	call   800622 <cprintf>
  8003f1:	83 c4 10             	add    $0x10,%esp
	}

	//customer is terminated
	sys_signalSemaphore(parentenvID, _custTerminated);
  8003f4:	83 ec 08             	sub    $0x8,%esp
  8003f7:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  8003fd:	50                   	push   %eax
  8003fe:	ff 75 e4             	pushl  -0x1c(%ebp)
  800401:	e8 70 17 00 00       	call   801b76 <sys_signalSemaphore>
  800406:	83 c4 10             	add    $0x10,%esp

	return;
  800409:	90                   	nop
}
  80040a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80040d:	5b                   	pop    %ebx
  80040e:	5e                   	pop    %esi
  80040f:	5f                   	pop    %edi
  800410:	5d                   	pop    %ebp
  800411:	c3                   	ret    

00800412 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800412:	55                   	push   %ebp
  800413:	89 e5                	mov    %esp,%ebp
  800415:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800418:	e8 81 18 00 00       	call   801c9e <sys_getenvindex>
  80041d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800420:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800423:	89 d0                	mov    %edx,%eax
  800425:	c1 e0 03             	shl    $0x3,%eax
  800428:	01 d0                	add    %edx,%eax
  80042a:	01 c0                	add    %eax,%eax
  80042c:	01 d0                	add    %edx,%eax
  80042e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800435:	01 d0                	add    %edx,%eax
  800437:	c1 e0 04             	shl    $0x4,%eax
  80043a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80043f:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800444:	a1 20 40 80 00       	mov    0x804020,%eax
  800449:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80044f:	84 c0                	test   %al,%al
  800451:	74 0f                	je     800462 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800453:	a1 20 40 80 00       	mov    0x804020,%eax
  800458:	05 5c 05 00 00       	add    $0x55c,%eax
  80045d:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800462:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800466:	7e 0a                	jle    800472 <libmain+0x60>
		binaryname = argv[0];
  800468:	8b 45 0c             	mov    0xc(%ebp),%eax
  80046b:	8b 00                	mov    (%eax),%eax
  80046d:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800472:	83 ec 08             	sub    $0x8,%esp
  800475:	ff 75 0c             	pushl  0xc(%ebp)
  800478:	ff 75 08             	pushl  0x8(%ebp)
  80047b:	e8 b8 fb ff ff       	call   800038 <_main>
  800480:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800483:	e8 23 16 00 00       	call   801aab <sys_disable_interrupt>
	cprintf("**************************************\n");
  800488:	83 ec 0c             	sub    $0xc,%esp
  80048b:	68 dc 36 80 00       	push   $0x8036dc
  800490:	e8 8d 01 00 00       	call   800622 <cprintf>
  800495:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800498:	a1 20 40 80 00       	mov    0x804020,%eax
  80049d:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8004a3:	a1 20 40 80 00       	mov    0x804020,%eax
  8004a8:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8004ae:	83 ec 04             	sub    $0x4,%esp
  8004b1:	52                   	push   %edx
  8004b2:	50                   	push   %eax
  8004b3:	68 04 37 80 00       	push   $0x803704
  8004b8:	e8 65 01 00 00       	call   800622 <cprintf>
  8004bd:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8004c0:	a1 20 40 80 00       	mov    0x804020,%eax
  8004c5:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8004cb:	a1 20 40 80 00       	mov    0x804020,%eax
  8004d0:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8004d6:	a1 20 40 80 00       	mov    0x804020,%eax
  8004db:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8004e1:	51                   	push   %ecx
  8004e2:	52                   	push   %edx
  8004e3:	50                   	push   %eax
  8004e4:	68 2c 37 80 00       	push   $0x80372c
  8004e9:	e8 34 01 00 00       	call   800622 <cprintf>
  8004ee:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004f1:	a1 20 40 80 00       	mov    0x804020,%eax
  8004f6:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8004fc:	83 ec 08             	sub    $0x8,%esp
  8004ff:	50                   	push   %eax
  800500:	68 84 37 80 00       	push   $0x803784
  800505:	e8 18 01 00 00       	call   800622 <cprintf>
  80050a:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80050d:	83 ec 0c             	sub    $0xc,%esp
  800510:	68 dc 36 80 00       	push   $0x8036dc
  800515:	e8 08 01 00 00       	call   800622 <cprintf>
  80051a:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80051d:	e8 a3 15 00 00       	call   801ac5 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800522:	e8 19 00 00 00       	call   800540 <exit>
}
  800527:	90                   	nop
  800528:	c9                   	leave  
  800529:	c3                   	ret    

0080052a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80052a:	55                   	push   %ebp
  80052b:	89 e5                	mov    %esp,%ebp
  80052d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800530:	83 ec 0c             	sub    $0xc,%esp
  800533:	6a 00                	push   $0x0
  800535:	e8 30 17 00 00       	call   801c6a <sys_destroy_env>
  80053a:	83 c4 10             	add    $0x10,%esp
}
  80053d:	90                   	nop
  80053e:	c9                   	leave  
  80053f:	c3                   	ret    

00800540 <exit>:

void
exit(void)
{
  800540:	55                   	push   %ebp
  800541:	89 e5                	mov    %esp,%ebp
  800543:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800546:	e8 85 17 00 00       	call   801cd0 <sys_exit_env>
}
  80054b:	90                   	nop
  80054c:	c9                   	leave  
  80054d:	c3                   	ret    

0080054e <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80054e:	55                   	push   %ebp
  80054f:	89 e5                	mov    %esp,%ebp
  800551:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800554:	8b 45 0c             	mov    0xc(%ebp),%eax
  800557:	8b 00                	mov    (%eax),%eax
  800559:	8d 48 01             	lea    0x1(%eax),%ecx
  80055c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80055f:	89 0a                	mov    %ecx,(%edx)
  800561:	8b 55 08             	mov    0x8(%ebp),%edx
  800564:	88 d1                	mov    %dl,%cl
  800566:	8b 55 0c             	mov    0xc(%ebp),%edx
  800569:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80056d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800570:	8b 00                	mov    (%eax),%eax
  800572:	3d ff 00 00 00       	cmp    $0xff,%eax
  800577:	75 2c                	jne    8005a5 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800579:	a0 24 40 80 00       	mov    0x804024,%al
  80057e:	0f b6 c0             	movzbl %al,%eax
  800581:	8b 55 0c             	mov    0xc(%ebp),%edx
  800584:	8b 12                	mov    (%edx),%edx
  800586:	89 d1                	mov    %edx,%ecx
  800588:	8b 55 0c             	mov    0xc(%ebp),%edx
  80058b:	83 c2 08             	add    $0x8,%edx
  80058e:	83 ec 04             	sub    $0x4,%esp
  800591:	50                   	push   %eax
  800592:	51                   	push   %ecx
  800593:	52                   	push   %edx
  800594:	e8 64 13 00 00       	call   8018fd <sys_cputs>
  800599:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80059c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80059f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005a8:	8b 40 04             	mov    0x4(%eax),%eax
  8005ab:	8d 50 01             	lea    0x1(%eax),%edx
  8005ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005b1:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005b4:	90                   	nop
  8005b5:	c9                   	leave  
  8005b6:	c3                   	ret    

008005b7 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005b7:	55                   	push   %ebp
  8005b8:	89 e5                	mov    %esp,%ebp
  8005ba:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005c0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005c7:	00 00 00 
	b.cnt = 0;
  8005ca:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005d1:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8005d4:	ff 75 0c             	pushl  0xc(%ebp)
  8005d7:	ff 75 08             	pushl  0x8(%ebp)
  8005da:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005e0:	50                   	push   %eax
  8005e1:	68 4e 05 80 00       	push   $0x80054e
  8005e6:	e8 11 02 00 00       	call   8007fc <vprintfmt>
  8005eb:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8005ee:	a0 24 40 80 00       	mov    0x804024,%al
  8005f3:	0f b6 c0             	movzbl %al,%eax
  8005f6:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005fc:	83 ec 04             	sub    $0x4,%esp
  8005ff:	50                   	push   %eax
  800600:	52                   	push   %edx
  800601:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800607:	83 c0 08             	add    $0x8,%eax
  80060a:	50                   	push   %eax
  80060b:	e8 ed 12 00 00       	call   8018fd <sys_cputs>
  800610:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800613:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80061a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800620:	c9                   	leave  
  800621:	c3                   	ret    

00800622 <cprintf>:

int cprintf(const char *fmt, ...) {
  800622:	55                   	push   %ebp
  800623:	89 e5                	mov    %esp,%ebp
  800625:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800628:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80062f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800632:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800635:	8b 45 08             	mov    0x8(%ebp),%eax
  800638:	83 ec 08             	sub    $0x8,%esp
  80063b:	ff 75 f4             	pushl  -0xc(%ebp)
  80063e:	50                   	push   %eax
  80063f:	e8 73 ff ff ff       	call   8005b7 <vcprintf>
  800644:	83 c4 10             	add    $0x10,%esp
  800647:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80064a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80064d:	c9                   	leave  
  80064e:	c3                   	ret    

0080064f <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80064f:	55                   	push   %ebp
  800650:	89 e5                	mov    %esp,%ebp
  800652:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800655:	e8 51 14 00 00       	call   801aab <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80065a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80065d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800660:	8b 45 08             	mov    0x8(%ebp),%eax
  800663:	83 ec 08             	sub    $0x8,%esp
  800666:	ff 75 f4             	pushl  -0xc(%ebp)
  800669:	50                   	push   %eax
  80066a:	e8 48 ff ff ff       	call   8005b7 <vcprintf>
  80066f:	83 c4 10             	add    $0x10,%esp
  800672:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800675:	e8 4b 14 00 00       	call   801ac5 <sys_enable_interrupt>
	return cnt;
  80067a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80067d:	c9                   	leave  
  80067e:	c3                   	ret    

0080067f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80067f:	55                   	push   %ebp
  800680:	89 e5                	mov    %esp,%ebp
  800682:	53                   	push   %ebx
  800683:	83 ec 14             	sub    $0x14,%esp
  800686:	8b 45 10             	mov    0x10(%ebp),%eax
  800689:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80068c:	8b 45 14             	mov    0x14(%ebp),%eax
  80068f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800692:	8b 45 18             	mov    0x18(%ebp),%eax
  800695:	ba 00 00 00 00       	mov    $0x0,%edx
  80069a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80069d:	77 55                	ja     8006f4 <printnum+0x75>
  80069f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006a2:	72 05                	jb     8006a9 <printnum+0x2a>
  8006a4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006a7:	77 4b                	ja     8006f4 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006a9:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006ac:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006af:	8b 45 18             	mov    0x18(%ebp),%eax
  8006b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b7:	52                   	push   %edx
  8006b8:	50                   	push   %eax
  8006b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8006bc:	ff 75 f0             	pushl  -0x10(%ebp)
  8006bf:	e8 28 2c 00 00       	call   8032ec <__udivdi3>
  8006c4:	83 c4 10             	add    $0x10,%esp
  8006c7:	83 ec 04             	sub    $0x4,%esp
  8006ca:	ff 75 20             	pushl  0x20(%ebp)
  8006cd:	53                   	push   %ebx
  8006ce:	ff 75 18             	pushl  0x18(%ebp)
  8006d1:	52                   	push   %edx
  8006d2:	50                   	push   %eax
  8006d3:	ff 75 0c             	pushl  0xc(%ebp)
  8006d6:	ff 75 08             	pushl  0x8(%ebp)
  8006d9:	e8 a1 ff ff ff       	call   80067f <printnum>
  8006de:	83 c4 20             	add    $0x20,%esp
  8006e1:	eb 1a                	jmp    8006fd <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006e3:	83 ec 08             	sub    $0x8,%esp
  8006e6:	ff 75 0c             	pushl  0xc(%ebp)
  8006e9:	ff 75 20             	pushl  0x20(%ebp)
  8006ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ef:	ff d0                	call   *%eax
  8006f1:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006f4:	ff 4d 1c             	decl   0x1c(%ebp)
  8006f7:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006fb:	7f e6                	jg     8006e3 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006fd:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800700:	bb 00 00 00 00       	mov    $0x0,%ebx
  800705:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800708:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80070b:	53                   	push   %ebx
  80070c:	51                   	push   %ecx
  80070d:	52                   	push   %edx
  80070e:	50                   	push   %eax
  80070f:	e8 e8 2c 00 00       	call   8033fc <__umoddi3>
  800714:	83 c4 10             	add    $0x10,%esp
  800717:	05 b4 39 80 00       	add    $0x8039b4,%eax
  80071c:	8a 00                	mov    (%eax),%al
  80071e:	0f be c0             	movsbl %al,%eax
  800721:	83 ec 08             	sub    $0x8,%esp
  800724:	ff 75 0c             	pushl  0xc(%ebp)
  800727:	50                   	push   %eax
  800728:	8b 45 08             	mov    0x8(%ebp),%eax
  80072b:	ff d0                	call   *%eax
  80072d:	83 c4 10             	add    $0x10,%esp
}
  800730:	90                   	nop
  800731:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800734:	c9                   	leave  
  800735:	c3                   	ret    

00800736 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800736:	55                   	push   %ebp
  800737:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800739:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80073d:	7e 1c                	jle    80075b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80073f:	8b 45 08             	mov    0x8(%ebp),%eax
  800742:	8b 00                	mov    (%eax),%eax
  800744:	8d 50 08             	lea    0x8(%eax),%edx
  800747:	8b 45 08             	mov    0x8(%ebp),%eax
  80074a:	89 10                	mov    %edx,(%eax)
  80074c:	8b 45 08             	mov    0x8(%ebp),%eax
  80074f:	8b 00                	mov    (%eax),%eax
  800751:	83 e8 08             	sub    $0x8,%eax
  800754:	8b 50 04             	mov    0x4(%eax),%edx
  800757:	8b 00                	mov    (%eax),%eax
  800759:	eb 40                	jmp    80079b <getuint+0x65>
	else if (lflag)
  80075b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80075f:	74 1e                	je     80077f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800761:	8b 45 08             	mov    0x8(%ebp),%eax
  800764:	8b 00                	mov    (%eax),%eax
  800766:	8d 50 04             	lea    0x4(%eax),%edx
  800769:	8b 45 08             	mov    0x8(%ebp),%eax
  80076c:	89 10                	mov    %edx,(%eax)
  80076e:	8b 45 08             	mov    0x8(%ebp),%eax
  800771:	8b 00                	mov    (%eax),%eax
  800773:	83 e8 04             	sub    $0x4,%eax
  800776:	8b 00                	mov    (%eax),%eax
  800778:	ba 00 00 00 00       	mov    $0x0,%edx
  80077d:	eb 1c                	jmp    80079b <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80077f:	8b 45 08             	mov    0x8(%ebp),%eax
  800782:	8b 00                	mov    (%eax),%eax
  800784:	8d 50 04             	lea    0x4(%eax),%edx
  800787:	8b 45 08             	mov    0x8(%ebp),%eax
  80078a:	89 10                	mov    %edx,(%eax)
  80078c:	8b 45 08             	mov    0x8(%ebp),%eax
  80078f:	8b 00                	mov    (%eax),%eax
  800791:	83 e8 04             	sub    $0x4,%eax
  800794:	8b 00                	mov    (%eax),%eax
  800796:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80079b:	5d                   	pop    %ebp
  80079c:	c3                   	ret    

0080079d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80079d:	55                   	push   %ebp
  80079e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007a0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007a4:	7e 1c                	jle    8007c2 <getint+0x25>
		return va_arg(*ap, long long);
  8007a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a9:	8b 00                	mov    (%eax),%eax
  8007ab:	8d 50 08             	lea    0x8(%eax),%edx
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	89 10                	mov    %edx,(%eax)
  8007b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b6:	8b 00                	mov    (%eax),%eax
  8007b8:	83 e8 08             	sub    $0x8,%eax
  8007bb:	8b 50 04             	mov    0x4(%eax),%edx
  8007be:	8b 00                	mov    (%eax),%eax
  8007c0:	eb 38                	jmp    8007fa <getint+0x5d>
	else if (lflag)
  8007c2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007c6:	74 1a                	je     8007e2 <getint+0x45>
		return va_arg(*ap, long);
  8007c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cb:	8b 00                	mov    (%eax),%eax
  8007cd:	8d 50 04             	lea    0x4(%eax),%edx
  8007d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d3:	89 10                	mov    %edx,(%eax)
  8007d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d8:	8b 00                	mov    (%eax),%eax
  8007da:	83 e8 04             	sub    $0x4,%eax
  8007dd:	8b 00                	mov    (%eax),%eax
  8007df:	99                   	cltd   
  8007e0:	eb 18                	jmp    8007fa <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e5:	8b 00                	mov    (%eax),%eax
  8007e7:	8d 50 04             	lea    0x4(%eax),%edx
  8007ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ed:	89 10                	mov    %edx,(%eax)
  8007ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f2:	8b 00                	mov    (%eax),%eax
  8007f4:	83 e8 04             	sub    $0x4,%eax
  8007f7:	8b 00                	mov    (%eax),%eax
  8007f9:	99                   	cltd   
}
  8007fa:	5d                   	pop    %ebp
  8007fb:	c3                   	ret    

008007fc <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007fc:	55                   	push   %ebp
  8007fd:	89 e5                	mov    %esp,%ebp
  8007ff:	56                   	push   %esi
  800800:	53                   	push   %ebx
  800801:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800804:	eb 17                	jmp    80081d <vprintfmt+0x21>
			if (ch == '\0')
  800806:	85 db                	test   %ebx,%ebx
  800808:	0f 84 af 03 00 00    	je     800bbd <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80080e:	83 ec 08             	sub    $0x8,%esp
  800811:	ff 75 0c             	pushl  0xc(%ebp)
  800814:	53                   	push   %ebx
  800815:	8b 45 08             	mov    0x8(%ebp),%eax
  800818:	ff d0                	call   *%eax
  80081a:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80081d:	8b 45 10             	mov    0x10(%ebp),%eax
  800820:	8d 50 01             	lea    0x1(%eax),%edx
  800823:	89 55 10             	mov    %edx,0x10(%ebp)
  800826:	8a 00                	mov    (%eax),%al
  800828:	0f b6 d8             	movzbl %al,%ebx
  80082b:	83 fb 25             	cmp    $0x25,%ebx
  80082e:	75 d6                	jne    800806 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800830:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800834:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80083b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800842:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800849:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800850:	8b 45 10             	mov    0x10(%ebp),%eax
  800853:	8d 50 01             	lea    0x1(%eax),%edx
  800856:	89 55 10             	mov    %edx,0x10(%ebp)
  800859:	8a 00                	mov    (%eax),%al
  80085b:	0f b6 d8             	movzbl %al,%ebx
  80085e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800861:	83 f8 55             	cmp    $0x55,%eax
  800864:	0f 87 2b 03 00 00    	ja     800b95 <vprintfmt+0x399>
  80086a:	8b 04 85 d8 39 80 00 	mov    0x8039d8(,%eax,4),%eax
  800871:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800873:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800877:	eb d7                	jmp    800850 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800879:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80087d:	eb d1                	jmp    800850 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80087f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800886:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800889:	89 d0                	mov    %edx,%eax
  80088b:	c1 e0 02             	shl    $0x2,%eax
  80088e:	01 d0                	add    %edx,%eax
  800890:	01 c0                	add    %eax,%eax
  800892:	01 d8                	add    %ebx,%eax
  800894:	83 e8 30             	sub    $0x30,%eax
  800897:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80089a:	8b 45 10             	mov    0x10(%ebp),%eax
  80089d:	8a 00                	mov    (%eax),%al
  80089f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008a2:	83 fb 2f             	cmp    $0x2f,%ebx
  8008a5:	7e 3e                	jle    8008e5 <vprintfmt+0xe9>
  8008a7:	83 fb 39             	cmp    $0x39,%ebx
  8008aa:	7f 39                	jg     8008e5 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008ac:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008af:	eb d5                	jmp    800886 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b4:	83 c0 04             	add    $0x4,%eax
  8008b7:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bd:	83 e8 04             	sub    $0x4,%eax
  8008c0:	8b 00                	mov    (%eax),%eax
  8008c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008c5:	eb 1f                	jmp    8008e6 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008c7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008cb:	79 83                	jns    800850 <vprintfmt+0x54>
				width = 0;
  8008cd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008d4:	e9 77 ff ff ff       	jmp    800850 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008d9:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008e0:	e9 6b ff ff ff       	jmp    800850 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008e5:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008e6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ea:	0f 89 60 ff ff ff    	jns    800850 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008f6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008fd:	e9 4e ff ff ff       	jmp    800850 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800902:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800905:	e9 46 ff ff ff       	jmp    800850 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80090a:	8b 45 14             	mov    0x14(%ebp),%eax
  80090d:	83 c0 04             	add    $0x4,%eax
  800910:	89 45 14             	mov    %eax,0x14(%ebp)
  800913:	8b 45 14             	mov    0x14(%ebp),%eax
  800916:	83 e8 04             	sub    $0x4,%eax
  800919:	8b 00                	mov    (%eax),%eax
  80091b:	83 ec 08             	sub    $0x8,%esp
  80091e:	ff 75 0c             	pushl  0xc(%ebp)
  800921:	50                   	push   %eax
  800922:	8b 45 08             	mov    0x8(%ebp),%eax
  800925:	ff d0                	call   *%eax
  800927:	83 c4 10             	add    $0x10,%esp
			break;
  80092a:	e9 89 02 00 00       	jmp    800bb8 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80092f:	8b 45 14             	mov    0x14(%ebp),%eax
  800932:	83 c0 04             	add    $0x4,%eax
  800935:	89 45 14             	mov    %eax,0x14(%ebp)
  800938:	8b 45 14             	mov    0x14(%ebp),%eax
  80093b:	83 e8 04             	sub    $0x4,%eax
  80093e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800940:	85 db                	test   %ebx,%ebx
  800942:	79 02                	jns    800946 <vprintfmt+0x14a>
				err = -err;
  800944:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800946:	83 fb 64             	cmp    $0x64,%ebx
  800949:	7f 0b                	jg     800956 <vprintfmt+0x15a>
  80094b:	8b 34 9d 20 38 80 00 	mov    0x803820(,%ebx,4),%esi
  800952:	85 f6                	test   %esi,%esi
  800954:	75 19                	jne    80096f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800956:	53                   	push   %ebx
  800957:	68 c5 39 80 00       	push   $0x8039c5
  80095c:	ff 75 0c             	pushl  0xc(%ebp)
  80095f:	ff 75 08             	pushl  0x8(%ebp)
  800962:	e8 5e 02 00 00       	call   800bc5 <printfmt>
  800967:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80096a:	e9 49 02 00 00       	jmp    800bb8 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80096f:	56                   	push   %esi
  800970:	68 ce 39 80 00       	push   $0x8039ce
  800975:	ff 75 0c             	pushl  0xc(%ebp)
  800978:	ff 75 08             	pushl  0x8(%ebp)
  80097b:	e8 45 02 00 00       	call   800bc5 <printfmt>
  800980:	83 c4 10             	add    $0x10,%esp
			break;
  800983:	e9 30 02 00 00       	jmp    800bb8 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800988:	8b 45 14             	mov    0x14(%ebp),%eax
  80098b:	83 c0 04             	add    $0x4,%eax
  80098e:	89 45 14             	mov    %eax,0x14(%ebp)
  800991:	8b 45 14             	mov    0x14(%ebp),%eax
  800994:	83 e8 04             	sub    $0x4,%eax
  800997:	8b 30                	mov    (%eax),%esi
  800999:	85 f6                	test   %esi,%esi
  80099b:	75 05                	jne    8009a2 <vprintfmt+0x1a6>
				p = "(null)";
  80099d:	be d1 39 80 00       	mov    $0x8039d1,%esi
			if (width > 0 && padc != '-')
  8009a2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009a6:	7e 6d                	jle    800a15 <vprintfmt+0x219>
  8009a8:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009ac:	74 67                	je     800a15 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009b1:	83 ec 08             	sub    $0x8,%esp
  8009b4:	50                   	push   %eax
  8009b5:	56                   	push   %esi
  8009b6:	e8 0c 03 00 00       	call   800cc7 <strnlen>
  8009bb:	83 c4 10             	add    $0x10,%esp
  8009be:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009c1:	eb 16                	jmp    8009d9 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009c3:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009c7:	83 ec 08             	sub    $0x8,%esp
  8009ca:	ff 75 0c             	pushl  0xc(%ebp)
  8009cd:	50                   	push   %eax
  8009ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d1:	ff d0                	call   *%eax
  8009d3:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009d6:	ff 4d e4             	decl   -0x1c(%ebp)
  8009d9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009dd:	7f e4                	jg     8009c3 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009df:	eb 34                	jmp    800a15 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009e1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009e5:	74 1c                	je     800a03 <vprintfmt+0x207>
  8009e7:	83 fb 1f             	cmp    $0x1f,%ebx
  8009ea:	7e 05                	jle    8009f1 <vprintfmt+0x1f5>
  8009ec:	83 fb 7e             	cmp    $0x7e,%ebx
  8009ef:	7e 12                	jle    800a03 <vprintfmt+0x207>
					putch('?', putdat);
  8009f1:	83 ec 08             	sub    $0x8,%esp
  8009f4:	ff 75 0c             	pushl  0xc(%ebp)
  8009f7:	6a 3f                	push   $0x3f
  8009f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fc:	ff d0                	call   *%eax
  8009fe:	83 c4 10             	add    $0x10,%esp
  800a01:	eb 0f                	jmp    800a12 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a03:	83 ec 08             	sub    $0x8,%esp
  800a06:	ff 75 0c             	pushl  0xc(%ebp)
  800a09:	53                   	push   %ebx
  800a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0d:	ff d0                	call   *%eax
  800a0f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a12:	ff 4d e4             	decl   -0x1c(%ebp)
  800a15:	89 f0                	mov    %esi,%eax
  800a17:	8d 70 01             	lea    0x1(%eax),%esi
  800a1a:	8a 00                	mov    (%eax),%al
  800a1c:	0f be d8             	movsbl %al,%ebx
  800a1f:	85 db                	test   %ebx,%ebx
  800a21:	74 24                	je     800a47 <vprintfmt+0x24b>
  800a23:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a27:	78 b8                	js     8009e1 <vprintfmt+0x1e5>
  800a29:	ff 4d e0             	decl   -0x20(%ebp)
  800a2c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a30:	79 af                	jns    8009e1 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a32:	eb 13                	jmp    800a47 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a34:	83 ec 08             	sub    $0x8,%esp
  800a37:	ff 75 0c             	pushl  0xc(%ebp)
  800a3a:	6a 20                	push   $0x20
  800a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3f:	ff d0                	call   *%eax
  800a41:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a44:	ff 4d e4             	decl   -0x1c(%ebp)
  800a47:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a4b:	7f e7                	jg     800a34 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a4d:	e9 66 01 00 00       	jmp    800bb8 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a52:	83 ec 08             	sub    $0x8,%esp
  800a55:	ff 75 e8             	pushl  -0x18(%ebp)
  800a58:	8d 45 14             	lea    0x14(%ebp),%eax
  800a5b:	50                   	push   %eax
  800a5c:	e8 3c fd ff ff       	call   80079d <getint>
  800a61:	83 c4 10             	add    $0x10,%esp
  800a64:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a67:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a70:	85 d2                	test   %edx,%edx
  800a72:	79 23                	jns    800a97 <vprintfmt+0x29b>
				putch('-', putdat);
  800a74:	83 ec 08             	sub    $0x8,%esp
  800a77:	ff 75 0c             	pushl  0xc(%ebp)
  800a7a:	6a 2d                	push   $0x2d
  800a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7f:	ff d0                	call   *%eax
  800a81:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a8a:	f7 d8                	neg    %eax
  800a8c:	83 d2 00             	adc    $0x0,%edx
  800a8f:	f7 da                	neg    %edx
  800a91:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a94:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a97:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a9e:	e9 bc 00 00 00       	jmp    800b5f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800aa3:	83 ec 08             	sub    $0x8,%esp
  800aa6:	ff 75 e8             	pushl  -0x18(%ebp)
  800aa9:	8d 45 14             	lea    0x14(%ebp),%eax
  800aac:	50                   	push   %eax
  800aad:	e8 84 fc ff ff       	call   800736 <getuint>
  800ab2:	83 c4 10             	add    $0x10,%esp
  800ab5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800abb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ac2:	e9 98 00 00 00       	jmp    800b5f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ac7:	83 ec 08             	sub    $0x8,%esp
  800aca:	ff 75 0c             	pushl  0xc(%ebp)
  800acd:	6a 58                	push   $0x58
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad2:	ff d0                	call   *%eax
  800ad4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ad7:	83 ec 08             	sub    $0x8,%esp
  800ada:	ff 75 0c             	pushl  0xc(%ebp)
  800add:	6a 58                	push   $0x58
  800adf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae2:	ff d0                	call   *%eax
  800ae4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ae7:	83 ec 08             	sub    $0x8,%esp
  800aea:	ff 75 0c             	pushl  0xc(%ebp)
  800aed:	6a 58                	push   $0x58
  800aef:	8b 45 08             	mov    0x8(%ebp),%eax
  800af2:	ff d0                	call   *%eax
  800af4:	83 c4 10             	add    $0x10,%esp
			break;
  800af7:	e9 bc 00 00 00       	jmp    800bb8 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800afc:	83 ec 08             	sub    $0x8,%esp
  800aff:	ff 75 0c             	pushl  0xc(%ebp)
  800b02:	6a 30                	push   $0x30
  800b04:	8b 45 08             	mov    0x8(%ebp),%eax
  800b07:	ff d0                	call   *%eax
  800b09:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b0c:	83 ec 08             	sub    $0x8,%esp
  800b0f:	ff 75 0c             	pushl  0xc(%ebp)
  800b12:	6a 78                	push   $0x78
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	ff d0                	call   *%eax
  800b19:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1f:	83 c0 04             	add    $0x4,%eax
  800b22:	89 45 14             	mov    %eax,0x14(%ebp)
  800b25:	8b 45 14             	mov    0x14(%ebp),%eax
  800b28:	83 e8 04             	sub    $0x4,%eax
  800b2b:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b30:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b37:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b3e:	eb 1f                	jmp    800b5f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b40:	83 ec 08             	sub    $0x8,%esp
  800b43:	ff 75 e8             	pushl  -0x18(%ebp)
  800b46:	8d 45 14             	lea    0x14(%ebp),%eax
  800b49:	50                   	push   %eax
  800b4a:	e8 e7 fb ff ff       	call   800736 <getuint>
  800b4f:	83 c4 10             	add    $0x10,%esp
  800b52:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b55:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b58:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b5f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b66:	83 ec 04             	sub    $0x4,%esp
  800b69:	52                   	push   %edx
  800b6a:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b6d:	50                   	push   %eax
  800b6e:	ff 75 f4             	pushl  -0xc(%ebp)
  800b71:	ff 75 f0             	pushl  -0x10(%ebp)
  800b74:	ff 75 0c             	pushl  0xc(%ebp)
  800b77:	ff 75 08             	pushl  0x8(%ebp)
  800b7a:	e8 00 fb ff ff       	call   80067f <printnum>
  800b7f:	83 c4 20             	add    $0x20,%esp
			break;
  800b82:	eb 34                	jmp    800bb8 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b84:	83 ec 08             	sub    $0x8,%esp
  800b87:	ff 75 0c             	pushl  0xc(%ebp)
  800b8a:	53                   	push   %ebx
  800b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8e:	ff d0                	call   *%eax
  800b90:	83 c4 10             	add    $0x10,%esp
			break;
  800b93:	eb 23                	jmp    800bb8 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b95:	83 ec 08             	sub    $0x8,%esp
  800b98:	ff 75 0c             	pushl  0xc(%ebp)
  800b9b:	6a 25                	push   $0x25
  800b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba0:	ff d0                	call   *%eax
  800ba2:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ba5:	ff 4d 10             	decl   0x10(%ebp)
  800ba8:	eb 03                	jmp    800bad <vprintfmt+0x3b1>
  800baa:	ff 4d 10             	decl   0x10(%ebp)
  800bad:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb0:	48                   	dec    %eax
  800bb1:	8a 00                	mov    (%eax),%al
  800bb3:	3c 25                	cmp    $0x25,%al
  800bb5:	75 f3                	jne    800baa <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800bb7:	90                   	nop
		}
	}
  800bb8:	e9 47 fc ff ff       	jmp    800804 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bbd:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bbe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bc1:	5b                   	pop    %ebx
  800bc2:	5e                   	pop    %esi
  800bc3:	5d                   	pop    %ebp
  800bc4:	c3                   	ret    

00800bc5 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bc5:	55                   	push   %ebp
  800bc6:	89 e5                	mov    %esp,%ebp
  800bc8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bcb:	8d 45 10             	lea    0x10(%ebp),%eax
  800bce:	83 c0 04             	add    $0x4,%eax
  800bd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bd4:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd7:	ff 75 f4             	pushl  -0xc(%ebp)
  800bda:	50                   	push   %eax
  800bdb:	ff 75 0c             	pushl  0xc(%ebp)
  800bde:	ff 75 08             	pushl  0x8(%ebp)
  800be1:	e8 16 fc ff ff       	call   8007fc <vprintfmt>
  800be6:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800be9:	90                   	nop
  800bea:	c9                   	leave  
  800beb:	c3                   	ret    

00800bec <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf2:	8b 40 08             	mov    0x8(%eax),%eax
  800bf5:	8d 50 01             	lea    0x1(%eax),%edx
  800bf8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfb:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c01:	8b 10                	mov    (%eax),%edx
  800c03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c06:	8b 40 04             	mov    0x4(%eax),%eax
  800c09:	39 c2                	cmp    %eax,%edx
  800c0b:	73 12                	jae    800c1f <sprintputch+0x33>
		*b->buf++ = ch;
  800c0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c10:	8b 00                	mov    (%eax),%eax
  800c12:	8d 48 01             	lea    0x1(%eax),%ecx
  800c15:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c18:	89 0a                	mov    %ecx,(%edx)
  800c1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c1d:	88 10                	mov    %dl,(%eax)
}
  800c1f:	90                   	nop
  800c20:	5d                   	pop    %ebp
  800c21:	c3                   	ret    

00800c22 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c22:	55                   	push   %ebp
  800c23:	89 e5                	mov    %esp,%ebp
  800c25:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c31:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
  800c37:	01 d0                	add    %edx,%eax
  800c39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c3c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c43:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c47:	74 06                	je     800c4f <vsnprintf+0x2d>
  800c49:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c4d:	7f 07                	jg     800c56 <vsnprintf+0x34>
		return -E_INVAL;
  800c4f:	b8 03 00 00 00       	mov    $0x3,%eax
  800c54:	eb 20                	jmp    800c76 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c56:	ff 75 14             	pushl  0x14(%ebp)
  800c59:	ff 75 10             	pushl  0x10(%ebp)
  800c5c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c5f:	50                   	push   %eax
  800c60:	68 ec 0b 80 00       	push   $0x800bec
  800c65:	e8 92 fb ff ff       	call   8007fc <vprintfmt>
  800c6a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c70:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c76:	c9                   	leave  
  800c77:	c3                   	ret    

00800c78 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c78:	55                   	push   %ebp
  800c79:	89 e5                	mov    %esp,%ebp
  800c7b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c7e:	8d 45 10             	lea    0x10(%ebp),%eax
  800c81:	83 c0 04             	add    $0x4,%eax
  800c84:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c87:	8b 45 10             	mov    0x10(%ebp),%eax
  800c8a:	ff 75 f4             	pushl  -0xc(%ebp)
  800c8d:	50                   	push   %eax
  800c8e:	ff 75 0c             	pushl  0xc(%ebp)
  800c91:	ff 75 08             	pushl  0x8(%ebp)
  800c94:	e8 89 ff ff ff       	call   800c22 <vsnprintf>
  800c99:	83 c4 10             	add    $0x10,%esp
  800c9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ca2:	c9                   	leave  
  800ca3:	c3                   	ret    

00800ca4 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ca4:	55                   	push   %ebp
  800ca5:	89 e5                	mov    %esp,%ebp
  800ca7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800caa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cb1:	eb 06                	jmp    800cb9 <strlen+0x15>
		n++;
  800cb3:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cb6:	ff 45 08             	incl   0x8(%ebp)
  800cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbc:	8a 00                	mov    (%eax),%al
  800cbe:	84 c0                	test   %al,%al
  800cc0:	75 f1                	jne    800cb3 <strlen+0xf>
		n++;
	return n;
  800cc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cc5:	c9                   	leave  
  800cc6:	c3                   	ret    

00800cc7 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cc7:	55                   	push   %ebp
  800cc8:	89 e5                	mov    %esp,%ebp
  800cca:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ccd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cd4:	eb 09                	jmp    800cdf <strnlen+0x18>
		n++;
  800cd6:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cd9:	ff 45 08             	incl   0x8(%ebp)
  800cdc:	ff 4d 0c             	decl   0xc(%ebp)
  800cdf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ce3:	74 09                	je     800cee <strnlen+0x27>
  800ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce8:	8a 00                	mov    (%eax),%al
  800cea:	84 c0                	test   %al,%al
  800cec:	75 e8                	jne    800cd6 <strnlen+0xf>
		n++;
	return n;
  800cee:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cf1:	c9                   	leave  
  800cf2:	c3                   	ret    

00800cf3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cf3:	55                   	push   %ebp
  800cf4:	89 e5                	mov    %esp,%ebp
  800cf6:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cff:	90                   	nop
  800d00:	8b 45 08             	mov    0x8(%ebp),%eax
  800d03:	8d 50 01             	lea    0x1(%eax),%edx
  800d06:	89 55 08             	mov    %edx,0x8(%ebp)
  800d09:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d0c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d0f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d12:	8a 12                	mov    (%edx),%dl
  800d14:	88 10                	mov    %dl,(%eax)
  800d16:	8a 00                	mov    (%eax),%al
  800d18:	84 c0                	test   %al,%al
  800d1a:	75 e4                	jne    800d00 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d1f:	c9                   	leave  
  800d20:	c3                   	ret    

00800d21 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d21:	55                   	push   %ebp
  800d22:	89 e5                	mov    %esp,%ebp
  800d24:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d27:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d2d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d34:	eb 1f                	jmp    800d55 <strncpy+0x34>
		*dst++ = *src;
  800d36:	8b 45 08             	mov    0x8(%ebp),%eax
  800d39:	8d 50 01             	lea    0x1(%eax),%edx
  800d3c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d42:	8a 12                	mov    (%edx),%dl
  800d44:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d49:	8a 00                	mov    (%eax),%al
  800d4b:	84 c0                	test   %al,%al
  800d4d:	74 03                	je     800d52 <strncpy+0x31>
			src++;
  800d4f:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d52:	ff 45 fc             	incl   -0x4(%ebp)
  800d55:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d58:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d5b:	72 d9                	jb     800d36 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d5d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d60:	c9                   	leave  
  800d61:	c3                   	ret    

00800d62 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d62:	55                   	push   %ebp
  800d63:	89 e5                	mov    %esp,%ebp
  800d65:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d6e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d72:	74 30                	je     800da4 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d74:	eb 16                	jmp    800d8c <strlcpy+0x2a>
			*dst++ = *src++;
  800d76:	8b 45 08             	mov    0x8(%ebp),%eax
  800d79:	8d 50 01             	lea    0x1(%eax),%edx
  800d7c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d82:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d85:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d88:	8a 12                	mov    (%edx),%dl
  800d8a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d8c:	ff 4d 10             	decl   0x10(%ebp)
  800d8f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d93:	74 09                	je     800d9e <strlcpy+0x3c>
  800d95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d98:	8a 00                	mov    (%eax),%al
  800d9a:	84 c0                	test   %al,%al
  800d9c:	75 d8                	jne    800d76 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800da1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800da4:	8b 55 08             	mov    0x8(%ebp),%edx
  800da7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800daa:	29 c2                	sub    %eax,%edx
  800dac:	89 d0                	mov    %edx,%eax
}
  800dae:	c9                   	leave  
  800daf:	c3                   	ret    

00800db0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800db0:	55                   	push   %ebp
  800db1:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800db3:	eb 06                	jmp    800dbb <strcmp+0xb>
		p++, q++;
  800db5:	ff 45 08             	incl   0x8(%ebp)
  800db8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbe:	8a 00                	mov    (%eax),%al
  800dc0:	84 c0                	test   %al,%al
  800dc2:	74 0e                	je     800dd2 <strcmp+0x22>
  800dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc7:	8a 10                	mov    (%eax),%dl
  800dc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcc:	8a 00                	mov    (%eax),%al
  800dce:	38 c2                	cmp    %al,%dl
  800dd0:	74 e3                	je     800db5 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd5:	8a 00                	mov    (%eax),%al
  800dd7:	0f b6 d0             	movzbl %al,%edx
  800dda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddd:	8a 00                	mov    (%eax),%al
  800ddf:	0f b6 c0             	movzbl %al,%eax
  800de2:	29 c2                	sub    %eax,%edx
  800de4:	89 d0                	mov    %edx,%eax
}
  800de6:	5d                   	pop    %ebp
  800de7:	c3                   	ret    

00800de8 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800de8:	55                   	push   %ebp
  800de9:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800deb:	eb 09                	jmp    800df6 <strncmp+0xe>
		n--, p++, q++;
  800ded:	ff 4d 10             	decl   0x10(%ebp)
  800df0:	ff 45 08             	incl   0x8(%ebp)
  800df3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800df6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dfa:	74 17                	je     800e13 <strncmp+0x2b>
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dff:	8a 00                	mov    (%eax),%al
  800e01:	84 c0                	test   %al,%al
  800e03:	74 0e                	je     800e13 <strncmp+0x2b>
  800e05:	8b 45 08             	mov    0x8(%ebp),%eax
  800e08:	8a 10                	mov    (%eax),%dl
  800e0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0d:	8a 00                	mov    (%eax),%al
  800e0f:	38 c2                	cmp    %al,%dl
  800e11:	74 da                	je     800ded <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e13:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e17:	75 07                	jne    800e20 <strncmp+0x38>
		return 0;
  800e19:	b8 00 00 00 00       	mov    $0x0,%eax
  800e1e:	eb 14                	jmp    800e34 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e20:	8b 45 08             	mov    0x8(%ebp),%eax
  800e23:	8a 00                	mov    (%eax),%al
  800e25:	0f b6 d0             	movzbl %al,%edx
  800e28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2b:	8a 00                	mov    (%eax),%al
  800e2d:	0f b6 c0             	movzbl %al,%eax
  800e30:	29 c2                	sub    %eax,%edx
  800e32:	89 d0                	mov    %edx,%eax
}
  800e34:	5d                   	pop    %ebp
  800e35:	c3                   	ret    

00800e36 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e36:	55                   	push   %ebp
  800e37:	89 e5                	mov    %esp,%ebp
  800e39:	83 ec 04             	sub    $0x4,%esp
  800e3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e42:	eb 12                	jmp    800e56 <strchr+0x20>
		if (*s == c)
  800e44:	8b 45 08             	mov    0x8(%ebp),%eax
  800e47:	8a 00                	mov    (%eax),%al
  800e49:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e4c:	75 05                	jne    800e53 <strchr+0x1d>
			return (char *) s;
  800e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e51:	eb 11                	jmp    800e64 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e53:	ff 45 08             	incl   0x8(%ebp)
  800e56:	8b 45 08             	mov    0x8(%ebp),%eax
  800e59:	8a 00                	mov    (%eax),%al
  800e5b:	84 c0                	test   %al,%al
  800e5d:	75 e5                	jne    800e44 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e64:	c9                   	leave  
  800e65:	c3                   	ret    

00800e66 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e66:	55                   	push   %ebp
  800e67:	89 e5                	mov    %esp,%ebp
  800e69:	83 ec 04             	sub    $0x4,%esp
  800e6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e72:	eb 0d                	jmp    800e81 <strfind+0x1b>
		if (*s == c)
  800e74:	8b 45 08             	mov    0x8(%ebp),%eax
  800e77:	8a 00                	mov    (%eax),%al
  800e79:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e7c:	74 0e                	je     800e8c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e7e:	ff 45 08             	incl   0x8(%ebp)
  800e81:	8b 45 08             	mov    0x8(%ebp),%eax
  800e84:	8a 00                	mov    (%eax),%al
  800e86:	84 c0                	test   %al,%al
  800e88:	75 ea                	jne    800e74 <strfind+0xe>
  800e8a:	eb 01                	jmp    800e8d <strfind+0x27>
		if (*s == c)
			break;
  800e8c:	90                   	nop
	return (char *) s;
  800e8d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e90:	c9                   	leave  
  800e91:	c3                   	ret    

00800e92 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e92:	55                   	push   %ebp
  800e93:	89 e5                	mov    %esp,%ebp
  800e95:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e98:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e9e:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ea4:	eb 0e                	jmp    800eb4 <memset+0x22>
		*p++ = c;
  800ea6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea9:	8d 50 01             	lea    0x1(%eax),%edx
  800eac:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800eaf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eb2:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800eb4:	ff 4d f8             	decl   -0x8(%ebp)
  800eb7:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800ebb:	79 e9                	jns    800ea6 <memset+0x14>
		*p++ = c;

	return v;
  800ebd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ec0:	c9                   	leave  
  800ec1:	c3                   	ret    

00800ec2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ec2:	55                   	push   %ebp
  800ec3:	89 e5                	mov    %esp,%ebp
  800ec5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ec8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ece:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ed4:	eb 16                	jmp    800eec <memcpy+0x2a>
		*d++ = *s++;
  800ed6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ed9:	8d 50 01             	lea    0x1(%eax),%edx
  800edc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800edf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ee2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ee5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ee8:	8a 12                	mov    (%edx),%dl
  800eea:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800eec:	8b 45 10             	mov    0x10(%ebp),%eax
  800eef:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ef2:	89 55 10             	mov    %edx,0x10(%ebp)
  800ef5:	85 c0                	test   %eax,%eax
  800ef7:	75 dd                	jne    800ed6 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ef9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800efc:	c9                   	leave  
  800efd:	c3                   	ret    

00800efe <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800efe:	55                   	push   %ebp
  800eff:	89 e5                	mov    %esp,%ebp
  800f01:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f07:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f10:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f13:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f16:	73 50                	jae    800f68 <memmove+0x6a>
  800f18:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f1b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1e:	01 d0                	add    %edx,%eax
  800f20:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f23:	76 43                	jbe    800f68 <memmove+0x6a>
		s += n;
  800f25:	8b 45 10             	mov    0x10(%ebp),%eax
  800f28:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f2b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f31:	eb 10                	jmp    800f43 <memmove+0x45>
			*--d = *--s;
  800f33:	ff 4d f8             	decl   -0x8(%ebp)
  800f36:	ff 4d fc             	decl   -0x4(%ebp)
  800f39:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f3c:	8a 10                	mov    (%eax),%dl
  800f3e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f41:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f43:	8b 45 10             	mov    0x10(%ebp),%eax
  800f46:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f49:	89 55 10             	mov    %edx,0x10(%ebp)
  800f4c:	85 c0                	test   %eax,%eax
  800f4e:	75 e3                	jne    800f33 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f50:	eb 23                	jmp    800f75 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f52:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f55:	8d 50 01             	lea    0x1(%eax),%edx
  800f58:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f5b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f5e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f61:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f64:	8a 12                	mov    (%edx),%dl
  800f66:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f68:	8b 45 10             	mov    0x10(%ebp),%eax
  800f6b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f6e:	89 55 10             	mov    %edx,0x10(%ebp)
  800f71:	85 c0                	test   %eax,%eax
  800f73:	75 dd                	jne    800f52 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f75:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f78:	c9                   	leave  
  800f79:	c3                   	ret    

00800f7a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f7a:	55                   	push   %ebp
  800f7b:	89 e5                	mov    %esp,%ebp
  800f7d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
  800f83:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f89:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f8c:	eb 2a                	jmp    800fb8 <memcmp+0x3e>
		if (*s1 != *s2)
  800f8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f91:	8a 10                	mov    (%eax),%dl
  800f93:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f96:	8a 00                	mov    (%eax),%al
  800f98:	38 c2                	cmp    %al,%dl
  800f9a:	74 16                	je     800fb2 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f9f:	8a 00                	mov    (%eax),%al
  800fa1:	0f b6 d0             	movzbl %al,%edx
  800fa4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	0f b6 c0             	movzbl %al,%eax
  800fac:	29 c2                	sub    %eax,%edx
  800fae:	89 d0                	mov    %edx,%eax
  800fb0:	eb 18                	jmp    800fca <memcmp+0x50>
		s1++, s2++;
  800fb2:	ff 45 fc             	incl   -0x4(%ebp)
  800fb5:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fb8:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fbe:	89 55 10             	mov    %edx,0x10(%ebp)
  800fc1:	85 c0                	test   %eax,%eax
  800fc3:	75 c9                	jne    800f8e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fc5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fca:	c9                   	leave  
  800fcb:	c3                   	ret    

00800fcc <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fcc:	55                   	push   %ebp
  800fcd:	89 e5                	mov    %esp,%ebp
  800fcf:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800fd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd8:	01 d0                	add    %edx,%eax
  800fda:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fdd:	eb 15                	jmp    800ff4 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe2:	8a 00                	mov    (%eax),%al
  800fe4:	0f b6 d0             	movzbl %al,%edx
  800fe7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fea:	0f b6 c0             	movzbl %al,%eax
  800fed:	39 c2                	cmp    %eax,%edx
  800fef:	74 0d                	je     800ffe <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ff1:	ff 45 08             	incl   0x8(%ebp)
  800ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ffa:	72 e3                	jb     800fdf <memfind+0x13>
  800ffc:	eb 01                	jmp    800fff <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ffe:	90                   	nop
	return (void *) s;
  800fff:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801002:	c9                   	leave  
  801003:	c3                   	ret    

00801004 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801004:	55                   	push   %ebp
  801005:	89 e5                	mov    %esp,%ebp
  801007:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80100a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801011:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801018:	eb 03                	jmp    80101d <strtol+0x19>
		s++;
  80101a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	8a 00                	mov    (%eax),%al
  801022:	3c 20                	cmp    $0x20,%al
  801024:	74 f4                	je     80101a <strtol+0x16>
  801026:	8b 45 08             	mov    0x8(%ebp),%eax
  801029:	8a 00                	mov    (%eax),%al
  80102b:	3c 09                	cmp    $0x9,%al
  80102d:	74 eb                	je     80101a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80102f:	8b 45 08             	mov    0x8(%ebp),%eax
  801032:	8a 00                	mov    (%eax),%al
  801034:	3c 2b                	cmp    $0x2b,%al
  801036:	75 05                	jne    80103d <strtol+0x39>
		s++;
  801038:	ff 45 08             	incl   0x8(%ebp)
  80103b:	eb 13                	jmp    801050 <strtol+0x4c>
	else if (*s == '-')
  80103d:	8b 45 08             	mov    0x8(%ebp),%eax
  801040:	8a 00                	mov    (%eax),%al
  801042:	3c 2d                	cmp    $0x2d,%al
  801044:	75 0a                	jne    801050 <strtol+0x4c>
		s++, neg = 1;
  801046:	ff 45 08             	incl   0x8(%ebp)
  801049:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801050:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801054:	74 06                	je     80105c <strtol+0x58>
  801056:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80105a:	75 20                	jne    80107c <strtol+0x78>
  80105c:	8b 45 08             	mov    0x8(%ebp),%eax
  80105f:	8a 00                	mov    (%eax),%al
  801061:	3c 30                	cmp    $0x30,%al
  801063:	75 17                	jne    80107c <strtol+0x78>
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	40                   	inc    %eax
  801069:	8a 00                	mov    (%eax),%al
  80106b:	3c 78                	cmp    $0x78,%al
  80106d:	75 0d                	jne    80107c <strtol+0x78>
		s += 2, base = 16;
  80106f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801073:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80107a:	eb 28                	jmp    8010a4 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80107c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801080:	75 15                	jne    801097 <strtol+0x93>
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	8a 00                	mov    (%eax),%al
  801087:	3c 30                	cmp    $0x30,%al
  801089:	75 0c                	jne    801097 <strtol+0x93>
		s++, base = 8;
  80108b:	ff 45 08             	incl   0x8(%ebp)
  80108e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801095:	eb 0d                	jmp    8010a4 <strtol+0xa0>
	else if (base == 0)
  801097:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80109b:	75 07                	jne    8010a4 <strtol+0xa0>
		base = 10;
  80109d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a7:	8a 00                	mov    (%eax),%al
  8010a9:	3c 2f                	cmp    $0x2f,%al
  8010ab:	7e 19                	jle    8010c6 <strtol+0xc2>
  8010ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b0:	8a 00                	mov    (%eax),%al
  8010b2:	3c 39                	cmp    $0x39,%al
  8010b4:	7f 10                	jg     8010c6 <strtol+0xc2>
			dig = *s - '0';
  8010b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b9:	8a 00                	mov    (%eax),%al
  8010bb:	0f be c0             	movsbl %al,%eax
  8010be:	83 e8 30             	sub    $0x30,%eax
  8010c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010c4:	eb 42                	jmp    801108 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c9:	8a 00                	mov    (%eax),%al
  8010cb:	3c 60                	cmp    $0x60,%al
  8010cd:	7e 19                	jle    8010e8 <strtol+0xe4>
  8010cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d2:	8a 00                	mov    (%eax),%al
  8010d4:	3c 7a                	cmp    $0x7a,%al
  8010d6:	7f 10                	jg     8010e8 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010db:	8a 00                	mov    (%eax),%al
  8010dd:	0f be c0             	movsbl %al,%eax
  8010e0:	83 e8 57             	sub    $0x57,%eax
  8010e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010e6:	eb 20                	jmp    801108 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010eb:	8a 00                	mov    (%eax),%al
  8010ed:	3c 40                	cmp    $0x40,%al
  8010ef:	7e 39                	jle    80112a <strtol+0x126>
  8010f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f4:	8a 00                	mov    (%eax),%al
  8010f6:	3c 5a                	cmp    $0x5a,%al
  8010f8:	7f 30                	jg     80112a <strtol+0x126>
			dig = *s - 'A' + 10;
  8010fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fd:	8a 00                	mov    (%eax),%al
  8010ff:	0f be c0             	movsbl %al,%eax
  801102:	83 e8 37             	sub    $0x37,%eax
  801105:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801108:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80110b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80110e:	7d 19                	jge    801129 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801110:	ff 45 08             	incl   0x8(%ebp)
  801113:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801116:	0f af 45 10          	imul   0x10(%ebp),%eax
  80111a:	89 c2                	mov    %eax,%edx
  80111c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80111f:	01 d0                	add    %edx,%eax
  801121:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801124:	e9 7b ff ff ff       	jmp    8010a4 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801129:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80112a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80112e:	74 08                	je     801138 <strtol+0x134>
		*endptr = (char *) s;
  801130:	8b 45 0c             	mov    0xc(%ebp),%eax
  801133:	8b 55 08             	mov    0x8(%ebp),%edx
  801136:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801138:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80113c:	74 07                	je     801145 <strtol+0x141>
  80113e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801141:	f7 d8                	neg    %eax
  801143:	eb 03                	jmp    801148 <strtol+0x144>
  801145:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801148:	c9                   	leave  
  801149:	c3                   	ret    

0080114a <ltostr>:

void
ltostr(long value, char *str)
{
  80114a:	55                   	push   %ebp
  80114b:	89 e5                	mov    %esp,%ebp
  80114d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801150:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801157:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80115e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801162:	79 13                	jns    801177 <ltostr+0x2d>
	{
		neg = 1;
  801164:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80116b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801171:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801174:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801177:	8b 45 08             	mov    0x8(%ebp),%eax
  80117a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80117f:	99                   	cltd   
  801180:	f7 f9                	idiv   %ecx
  801182:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801185:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801188:	8d 50 01             	lea    0x1(%eax),%edx
  80118b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80118e:	89 c2                	mov    %eax,%edx
  801190:	8b 45 0c             	mov    0xc(%ebp),%eax
  801193:	01 d0                	add    %edx,%eax
  801195:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801198:	83 c2 30             	add    $0x30,%edx
  80119b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80119d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011a0:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011a5:	f7 e9                	imul   %ecx
  8011a7:	c1 fa 02             	sar    $0x2,%edx
  8011aa:	89 c8                	mov    %ecx,%eax
  8011ac:	c1 f8 1f             	sar    $0x1f,%eax
  8011af:	29 c2                	sub    %eax,%edx
  8011b1:	89 d0                	mov    %edx,%eax
  8011b3:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8011b6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011b9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011be:	f7 e9                	imul   %ecx
  8011c0:	c1 fa 02             	sar    $0x2,%edx
  8011c3:	89 c8                	mov    %ecx,%eax
  8011c5:	c1 f8 1f             	sar    $0x1f,%eax
  8011c8:	29 c2                	sub    %eax,%edx
  8011ca:	89 d0                	mov    %edx,%eax
  8011cc:	c1 e0 02             	shl    $0x2,%eax
  8011cf:	01 d0                	add    %edx,%eax
  8011d1:	01 c0                	add    %eax,%eax
  8011d3:	29 c1                	sub    %eax,%ecx
  8011d5:	89 ca                	mov    %ecx,%edx
  8011d7:	85 d2                	test   %edx,%edx
  8011d9:	75 9c                	jne    801177 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e5:	48                   	dec    %eax
  8011e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011ed:	74 3d                	je     80122c <ltostr+0xe2>
		start = 1 ;
  8011ef:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011f6:	eb 34                	jmp    80122c <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8011f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fe:	01 d0                	add    %edx,%eax
  801200:	8a 00                	mov    (%eax),%al
  801202:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801205:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801208:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120b:	01 c2                	add    %eax,%edx
  80120d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801210:	8b 45 0c             	mov    0xc(%ebp),%eax
  801213:	01 c8                	add    %ecx,%eax
  801215:	8a 00                	mov    (%eax),%al
  801217:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801219:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80121c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121f:	01 c2                	add    %eax,%edx
  801221:	8a 45 eb             	mov    -0x15(%ebp),%al
  801224:	88 02                	mov    %al,(%edx)
		start++ ;
  801226:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801229:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80122c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80122f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801232:	7c c4                	jl     8011f8 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801234:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801237:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123a:	01 d0                	add    %edx,%eax
  80123c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80123f:	90                   	nop
  801240:	c9                   	leave  
  801241:	c3                   	ret    

00801242 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801242:	55                   	push   %ebp
  801243:	89 e5                	mov    %esp,%ebp
  801245:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801248:	ff 75 08             	pushl  0x8(%ebp)
  80124b:	e8 54 fa ff ff       	call   800ca4 <strlen>
  801250:	83 c4 04             	add    $0x4,%esp
  801253:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801256:	ff 75 0c             	pushl  0xc(%ebp)
  801259:	e8 46 fa ff ff       	call   800ca4 <strlen>
  80125e:	83 c4 04             	add    $0x4,%esp
  801261:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801264:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80126b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801272:	eb 17                	jmp    80128b <strcconcat+0x49>
		final[s] = str1[s] ;
  801274:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801277:	8b 45 10             	mov    0x10(%ebp),%eax
  80127a:	01 c2                	add    %eax,%edx
  80127c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80127f:	8b 45 08             	mov    0x8(%ebp),%eax
  801282:	01 c8                	add    %ecx,%eax
  801284:	8a 00                	mov    (%eax),%al
  801286:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801288:	ff 45 fc             	incl   -0x4(%ebp)
  80128b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80128e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801291:	7c e1                	jl     801274 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801293:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80129a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012a1:	eb 1f                	jmp    8012c2 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012a6:	8d 50 01             	lea    0x1(%eax),%edx
  8012a9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012ac:	89 c2                	mov    %eax,%edx
  8012ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b1:	01 c2                	add    %eax,%edx
  8012b3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b9:	01 c8                	add    %ecx,%eax
  8012bb:	8a 00                	mov    (%eax),%al
  8012bd:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012bf:	ff 45 f8             	incl   -0x8(%ebp)
  8012c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012c8:	7c d9                	jl     8012a3 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d0:	01 d0                	add    %edx,%eax
  8012d2:	c6 00 00             	movb   $0x0,(%eax)
}
  8012d5:	90                   	nop
  8012d6:	c9                   	leave  
  8012d7:	c3                   	ret    

008012d8 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012d8:	55                   	push   %ebp
  8012d9:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012db:	8b 45 14             	mov    0x14(%ebp),%eax
  8012de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8012e7:	8b 00                	mov    (%eax),%eax
  8012e9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f3:	01 d0                	add    %edx,%eax
  8012f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012fb:	eb 0c                	jmp    801309 <strsplit+0x31>
			*string++ = 0;
  8012fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801300:	8d 50 01             	lea    0x1(%eax),%edx
  801303:	89 55 08             	mov    %edx,0x8(%ebp)
  801306:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801309:	8b 45 08             	mov    0x8(%ebp),%eax
  80130c:	8a 00                	mov    (%eax),%al
  80130e:	84 c0                	test   %al,%al
  801310:	74 18                	je     80132a <strsplit+0x52>
  801312:	8b 45 08             	mov    0x8(%ebp),%eax
  801315:	8a 00                	mov    (%eax),%al
  801317:	0f be c0             	movsbl %al,%eax
  80131a:	50                   	push   %eax
  80131b:	ff 75 0c             	pushl  0xc(%ebp)
  80131e:	e8 13 fb ff ff       	call   800e36 <strchr>
  801323:	83 c4 08             	add    $0x8,%esp
  801326:	85 c0                	test   %eax,%eax
  801328:	75 d3                	jne    8012fd <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80132a:	8b 45 08             	mov    0x8(%ebp),%eax
  80132d:	8a 00                	mov    (%eax),%al
  80132f:	84 c0                	test   %al,%al
  801331:	74 5a                	je     80138d <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801333:	8b 45 14             	mov    0x14(%ebp),%eax
  801336:	8b 00                	mov    (%eax),%eax
  801338:	83 f8 0f             	cmp    $0xf,%eax
  80133b:	75 07                	jne    801344 <strsplit+0x6c>
		{
			return 0;
  80133d:	b8 00 00 00 00       	mov    $0x0,%eax
  801342:	eb 66                	jmp    8013aa <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801344:	8b 45 14             	mov    0x14(%ebp),%eax
  801347:	8b 00                	mov    (%eax),%eax
  801349:	8d 48 01             	lea    0x1(%eax),%ecx
  80134c:	8b 55 14             	mov    0x14(%ebp),%edx
  80134f:	89 0a                	mov    %ecx,(%edx)
  801351:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801358:	8b 45 10             	mov    0x10(%ebp),%eax
  80135b:	01 c2                	add    %eax,%edx
  80135d:	8b 45 08             	mov    0x8(%ebp),%eax
  801360:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801362:	eb 03                	jmp    801367 <strsplit+0x8f>
			string++;
  801364:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801367:	8b 45 08             	mov    0x8(%ebp),%eax
  80136a:	8a 00                	mov    (%eax),%al
  80136c:	84 c0                	test   %al,%al
  80136e:	74 8b                	je     8012fb <strsplit+0x23>
  801370:	8b 45 08             	mov    0x8(%ebp),%eax
  801373:	8a 00                	mov    (%eax),%al
  801375:	0f be c0             	movsbl %al,%eax
  801378:	50                   	push   %eax
  801379:	ff 75 0c             	pushl  0xc(%ebp)
  80137c:	e8 b5 fa ff ff       	call   800e36 <strchr>
  801381:	83 c4 08             	add    $0x8,%esp
  801384:	85 c0                	test   %eax,%eax
  801386:	74 dc                	je     801364 <strsplit+0x8c>
			string++;
	}
  801388:	e9 6e ff ff ff       	jmp    8012fb <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80138d:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80138e:	8b 45 14             	mov    0x14(%ebp),%eax
  801391:	8b 00                	mov    (%eax),%eax
  801393:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80139a:	8b 45 10             	mov    0x10(%ebp),%eax
  80139d:	01 d0                	add    %edx,%eax
  80139f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013a5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013aa:	c9                   	leave  
  8013ab:	c3                   	ret    

008013ac <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8013ac:	55                   	push   %ebp
  8013ad:	89 e5                	mov    %esp,%ebp
  8013af:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8013b2:	a1 04 40 80 00       	mov    0x804004,%eax
  8013b7:	85 c0                	test   %eax,%eax
  8013b9:	74 1f                	je     8013da <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8013bb:	e8 1d 00 00 00       	call   8013dd <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8013c0:	83 ec 0c             	sub    $0xc,%esp
  8013c3:	68 30 3b 80 00       	push   $0x803b30
  8013c8:	e8 55 f2 ff ff       	call   800622 <cprintf>
  8013cd:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8013d0:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8013d7:	00 00 00 
	}
}
  8013da:	90                   	nop
  8013db:	c9                   	leave  
  8013dc:	c3                   	ret    

008013dd <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8013dd:	55                   	push   %ebp
  8013de:	89 e5                	mov    %esp,%ebp
  8013e0:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  8013e3:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  8013ea:	00 00 00 
  8013ed:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  8013f4:	00 00 00 
  8013f7:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  8013fe:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  801401:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801408:	00 00 00 
  80140b:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801412:	00 00 00 
  801415:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80141c:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  80141f:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801426:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801429:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801430:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801433:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801438:	2d 00 10 00 00       	sub    $0x1000,%eax
  80143d:	a3 50 40 80 00       	mov    %eax,0x804050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  801442:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801449:	a1 20 41 80 00       	mov    0x804120,%eax
  80144e:	c1 e0 04             	shl    $0x4,%eax
  801451:	89 c2                	mov    %eax,%edx
  801453:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801456:	01 d0                	add    %edx,%eax
  801458:	48                   	dec    %eax
  801459:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80145c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80145f:	ba 00 00 00 00       	mov    $0x0,%edx
  801464:	f7 75 f0             	divl   -0x10(%ebp)
  801467:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80146a:	29 d0                	sub    %edx,%eax
  80146c:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  80146f:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801476:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801479:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80147e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801483:	83 ec 04             	sub    $0x4,%esp
  801486:	6a 06                	push   $0x6
  801488:	ff 75 e8             	pushl  -0x18(%ebp)
  80148b:	50                   	push   %eax
  80148c:	e8 b0 05 00 00       	call   801a41 <sys_allocate_chunk>
  801491:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801494:	a1 20 41 80 00       	mov    0x804120,%eax
  801499:	83 ec 0c             	sub    $0xc,%esp
  80149c:	50                   	push   %eax
  80149d:	e8 25 0c 00 00       	call   8020c7 <initialize_MemBlocksList>
  8014a2:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  8014a5:	a1 48 41 80 00       	mov    0x804148,%eax
  8014aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  8014ad:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8014b1:	75 14                	jne    8014c7 <initialize_dyn_block_system+0xea>
  8014b3:	83 ec 04             	sub    $0x4,%esp
  8014b6:	68 55 3b 80 00       	push   $0x803b55
  8014bb:	6a 29                	push   $0x29
  8014bd:	68 73 3b 80 00       	push   $0x803b73
  8014c2:	e8 43 1c 00 00       	call   80310a <_panic>
  8014c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014ca:	8b 00                	mov    (%eax),%eax
  8014cc:	85 c0                	test   %eax,%eax
  8014ce:	74 10                	je     8014e0 <initialize_dyn_block_system+0x103>
  8014d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014d3:	8b 00                	mov    (%eax),%eax
  8014d5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014d8:	8b 52 04             	mov    0x4(%edx),%edx
  8014db:	89 50 04             	mov    %edx,0x4(%eax)
  8014de:	eb 0b                	jmp    8014eb <initialize_dyn_block_system+0x10e>
  8014e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014e3:	8b 40 04             	mov    0x4(%eax),%eax
  8014e6:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8014eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014ee:	8b 40 04             	mov    0x4(%eax),%eax
  8014f1:	85 c0                	test   %eax,%eax
  8014f3:	74 0f                	je     801504 <initialize_dyn_block_system+0x127>
  8014f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014f8:	8b 40 04             	mov    0x4(%eax),%eax
  8014fb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014fe:	8b 12                	mov    (%edx),%edx
  801500:	89 10                	mov    %edx,(%eax)
  801502:	eb 0a                	jmp    80150e <initialize_dyn_block_system+0x131>
  801504:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801507:	8b 00                	mov    (%eax),%eax
  801509:	a3 48 41 80 00       	mov    %eax,0x804148
  80150e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801511:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801517:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80151a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801521:	a1 54 41 80 00       	mov    0x804154,%eax
  801526:	48                   	dec    %eax
  801527:	a3 54 41 80 00       	mov    %eax,0x804154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  80152c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80152f:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  801536:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801539:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  801540:	83 ec 0c             	sub    $0xc,%esp
  801543:	ff 75 e0             	pushl  -0x20(%ebp)
  801546:	e8 b9 14 00 00       	call   802a04 <insert_sorted_with_merge_freeList>
  80154b:	83 c4 10             	add    $0x10,%esp

}
  80154e:	90                   	nop
  80154f:	c9                   	leave  
  801550:	c3                   	ret    

00801551 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801551:	55                   	push   %ebp
  801552:	89 e5                	mov    %esp,%ebp
  801554:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801557:	e8 50 fe ff ff       	call   8013ac <InitializeUHeap>
	if (size == 0) return NULL ;
  80155c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801560:	75 07                	jne    801569 <malloc+0x18>
  801562:	b8 00 00 00 00       	mov    $0x0,%eax
  801567:	eb 68                	jmp    8015d1 <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  801569:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801570:	8b 55 08             	mov    0x8(%ebp),%edx
  801573:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801576:	01 d0                	add    %edx,%eax
  801578:	48                   	dec    %eax
  801579:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80157c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80157f:	ba 00 00 00 00       	mov    $0x0,%edx
  801584:	f7 75 f4             	divl   -0xc(%ebp)
  801587:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80158a:	29 d0                	sub    %edx,%eax
  80158c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  80158f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801596:	e8 74 08 00 00       	call   801e0f <sys_isUHeapPlacementStrategyFIRSTFIT>
  80159b:	85 c0                	test   %eax,%eax
  80159d:	74 2d                	je     8015cc <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  80159f:	83 ec 0c             	sub    $0xc,%esp
  8015a2:	ff 75 ec             	pushl  -0x14(%ebp)
  8015a5:	e8 52 0e 00 00       	call   8023fc <alloc_block_FF>
  8015aa:	83 c4 10             	add    $0x10,%esp
  8015ad:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  8015b0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8015b4:	74 16                	je     8015cc <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  8015b6:	83 ec 0c             	sub    $0xc,%esp
  8015b9:	ff 75 e8             	pushl  -0x18(%ebp)
  8015bc:	e8 3b 0c 00 00       	call   8021fc <insert_sorted_allocList>
  8015c1:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  8015c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015c7:	8b 40 08             	mov    0x8(%eax),%eax
  8015ca:	eb 05                	jmp    8015d1 <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  8015cc:	b8 00 00 00 00       	mov    $0x0,%eax

}
  8015d1:	c9                   	leave  
  8015d2:	c3                   	ret    

008015d3 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8015d3:	55                   	push   %ebp
  8015d4:	89 e5                	mov    %esp,%ebp
  8015d6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  8015d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015dc:	83 ec 08             	sub    $0x8,%esp
  8015df:	50                   	push   %eax
  8015e0:	68 40 40 80 00       	push   $0x804040
  8015e5:	e8 ba 0b 00 00       	call   8021a4 <find_block>
  8015ea:	83 c4 10             	add    $0x10,%esp
  8015ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  8015f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8015f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  8015f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015fd:	0f 84 9f 00 00 00    	je     8016a2 <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  801603:	8b 45 08             	mov    0x8(%ebp),%eax
  801606:	83 ec 08             	sub    $0x8,%esp
  801609:	ff 75 f0             	pushl  -0x10(%ebp)
  80160c:	50                   	push   %eax
  80160d:	e8 f7 03 00 00       	call   801a09 <sys_free_user_mem>
  801612:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  801615:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801619:	75 14                	jne    80162f <free+0x5c>
  80161b:	83 ec 04             	sub    $0x4,%esp
  80161e:	68 55 3b 80 00       	push   $0x803b55
  801623:	6a 6a                	push   $0x6a
  801625:	68 73 3b 80 00       	push   $0x803b73
  80162a:	e8 db 1a 00 00       	call   80310a <_panic>
  80162f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801632:	8b 00                	mov    (%eax),%eax
  801634:	85 c0                	test   %eax,%eax
  801636:	74 10                	je     801648 <free+0x75>
  801638:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80163b:	8b 00                	mov    (%eax),%eax
  80163d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801640:	8b 52 04             	mov    0x4(%edx),%edx
  801643:	89 50 04             	mov    %edx,0x4(%eax)
  801646:	eb 0b                	jmp    801653 <free+0x80>
  801648:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80164b:	8b 40 04             	mov    0x4(%eax),%eax
  80164e:	a3 44 40 80 00       	mov    %eax,0x804044
  801653:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801656:	8b 40 04             	mov    0x4(%eax),%eax
  801659:	85 c0                	test   %eax,%eax
  80165b:	74 0f                	je     80166c <free+0x99>
  80165d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801660:	8b 40 04             	mov    0x4(%eax),%eax
  801663:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801666:	8b 12                	mov    (%edx),%edx
  801668:	89 10                	mov    %edx,(%eax)
  80166a:	eb 0a                	jmp    801676 <free+0xa3>
  80166c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80166f:	8b 00                	mov    (%eax),%eax
  801671:	a3 40 40 80 00       	mov    %eax,0x804040
  801676:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801679:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80167f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801682:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801689:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80168e:	48                   	dec    %eax
  80168f:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(blk);
  801694:	83 ec 0c             	sub    $0xc,%esp
  801697:	ff 75 f4             	pushl  -0xc(%ebp)
  80169a:	e8 65 13 00 00       	call   802a04 <insert_sorted_with_merge_freeList>
  80169f:	83 c4 10             	add    $0x10,%esp
	}
}
  8016a2:	90                   	nop
  8016a3:	c9                   	leave  
  8016a4:	c3                   	ret    

008016a5 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8016a5:	55                   	push   %ebp
  8016a6:	89 e5                	mov    %esp,%ebp
  8016a8:	83 ec 28             	sub    $0x28,%esp
  8016ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ae:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016b1:	e8 f6 fc ff ff       	call   8013ac <InitializeUHeap>
	if (size == 0) return NULL ;
  8016b6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016ba:	75 0a                	jne    8016c6 <smalloc+0x21>
  8016bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8016c1:	e9 af 00 00 00       	jmp    801775 <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  8016c6:	e8 44 07 00 00       	call   801e0f <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016cb:	83 f8 01             	cmp    $0x1,%eax
  8016ce:	0f 85 9c 00 00 00    	jne    801770 <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  8016d4:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8016db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e1:	01 d0                	add    %edx,%eax
  8016e3:	48                   	dec    %eax
  8016e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ef:	f7 75 f4             	divl   -0xc(%ebp)
  8016f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f5:	29 d0                	sub    %edx,%eax
  8016f7:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  8016fa:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  801701:	76 07                	jbe    80170a <smalloc+0x65>
			return NULL;
  801703:	b8 00 00 00 00       	mov    $0x0,%eax
  801708:	eb 6b                	jmp    801775 <smalloc+0xd0>
		blk =alloc_block_FF(size);
  80170a:	83 ec 0c             	sub    $0xc,%esp
  80170d:	ff 75 0c             	pushl  0xc(%ebp)
  801710:	e8 e7 0c 00 00       	call   8023fc <alloc_block_FF>
  801715:	83 c4 10             	add    $0x10,%esp
  801718:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  80171b:	83 ec 0c             	sub    $0xc,%esp
  80171e:	ff 75 ec             	pushl  -0x14(%ebp)
  801721:	e8 d6 0a 00 00       	call   8021fc <insert_sorted_allocList>
  801726:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  801729:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80172d:	75 07                	jne    801736 <smalloc+0x91>
		{
			return NULL;
  80172f:	b8 00 00 00 00       	mov    $0x0,%eax
  801734:	eb 3f                	jmp    801775 <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  801736:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801739:	8b 40 08             	mov    0x8(%eax),%eax
  80173c:	89 c2                	mov    %eax,%edx
  80173e:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801742:	52                   	push   %edx
  801743:	50                   	push   %eax
  801744:	ff 75 0c             	pushl  0xc(%ebp)
  801747:	ff 75 08             	pushl  0x8(%ebp)
  80174a:	e8 45 04 00 00       	call   801b94 <sys_createSharedObject>
  80174f:	83 c4 10             	add    $0x10,%esp
  801752:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  801755:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801759:	74 06                	je     801761 <smalloc+0xbc>
  80175b:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  80175f:	75 07                	jne    801768 <smalloc+0xc3>
		{
			return NULL;
  801761:	b8 00 00 00 00       	mov    $0x0,%eax
  801766:	eb 0d                	jmp    801775 <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  801768:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80176b:	8b 40 08             	mov    0x8(%eax),%eax
  80176e:	eb 05                	jmp    801775 <smalloc+0xd0>
		}
	}
	else
		return NULL;
  801770:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801775:	c9                   	leave  
  801776:	c3                   	ret    

00801777 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801777:	55                   	push   %ebp
  801778:	89 e5                	mov    %esp,%ebp
  80177a:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80177d:	e8 2a fc ff ff       	call   8013ac <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801782:	83 ec 08             	sub    $0x8,%esp
  801785:	ff 75 0c             	pushl  0xc(%ebp)
  801788:	ff 75 08             	pushl  0x8(%ebp)
  80178b:	e8 2e 04 00 00       	call   801bbe <sys_getSizeOfSharedObject>
  801790:	83 c4 10             	add    $0x10,%esp
  801793:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  801796:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  80179a:	75 0a                	jne    8017a6 <sget+0x2f>
	{
		return NULL;
  80179c:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a1:	e9 94 00 00 00       	jmp    80183a <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8017a6:	e8 64 06 00 00       	call   801e0f <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017ab:	85 c0                	test   %eax,%eax
  8017ad:	0f 84 82 00 00 00    	je     801835 <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  8017b3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  8017ba:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8017c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017c7:	01 d0                	add    %edx,%eax
  8017c9:	48                   	dec    %eax
  8017ca:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8017cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d5:	f7 75 ec             	divl   -0x14(%ebp)
  8017d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017db:	29 d0                	sub    %edx,%eax
  8017dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  8017e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e3:	83 ec 0c             	sub    $0xc,%esp
  8017e6:	50                   	push   %eax
  8017e7:	e8 10 0c 00 00       	call   8023fc <alloc_block_FF>
  8017ec:	83 c4 10             	add    $0x10,%esp
  8017ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  8017f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8017f6:	75 07                	jne    8017ff <sget+0x88>
		{
			return NULL;
  8017f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8017fd:	eb 3b                	jmp    80183a <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  8017ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801802:	8b 40 08             	mov    0x8(%eax),%eax
  801805:	83 ec 04             	sub    $0x4,%esp
  801808:	50                   	push   %eax
  801809:	ff 75 0c             	pushl  0xc(%ebp)
  80180c:	ff 75 08             	pushl  0x8(%ebp)
  80180f:	e8 c7 03 00 00       	call   801bdb <sys_getSharedObject>
  801814:	83 c4 10             	add    $0x10,%esp
  801817:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  80181a:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  80181e:	74 06                	je     801826 <sget+0xaf>
  801820:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  801824:	75 07                	jne    80182d <sget+0xb6>
		{
			return NULL;
  801826:	b8 00 00 00 00       	mov    $0x0,%eax
  80182b:	eb 0d                	jmp    80183a <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  80182d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801830:	8b 40 08             	mov    0x8(%eax),%eax
  801833:	eb 05                	jmp    80183a <sget+0xc3>
		}
	}
	else
			return NULL;
  801835:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80183a:	c9                   	leave  
  80183b:	c3                   	ret    

0080183c <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80183c:	55                   	push   %ebp
  80183d:	89 e5                	mov    %esp,%ebp
  80183f:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801842:	e8 65 fb ff ff       	call   8013ac <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801847:	83 ec 04             	sub    $0x4,%esp
  80184a:	68 80 3b 80 00       	push   $0x803b80
  80184f:	68 e1 00 00 00       	push   $0xe1
  801854:	68 73 3b 80 00       	push   $0x803b73
  801859:	e8 ac 18 00 00       	call   80310a <_panic>

0080185e <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80185e:	55                   	push   %ebp
  80185f:	89 e5                	mov    %esp,%ebp
  801861:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801864:	83 ec 04             	sub    $0x4,%esp
  801867:	68 a8 3b 80 00       	push   $0x803ba8
  80186c:	68 f5 00 00 00       	push   $0xf5
  801871:	68 73 3b 80 00       	push   $0x803b73
  801876:	e8 8f 18 00 00       	call   80310a <_panic>

0080187b <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80187b:	55                   	push   %ebp
  80187c:	89 e5                	mov    %esp,%ebp
  80187e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801881:	83 ec 04             	sub    $0x4,%esp
  801884:	68 cc 3b 80 00       	push   $0x803bcc
  801889:	68 00 01 00 00       	push   $0x100
  80188e:	68 73 3b 80 00       	push   $0x803b73
  801893:	e8 72 18 00 00       	call   80310a <_panic>

00801898 <shrink>:

}
void shrink(uint32 newSize)
{
  801898:	55                   	push   %ebp
  801899:	89 e5                	mov    %esp,%ebp
  80189b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80189e:	83 ec 04             	sub    $0x4,%esp
  8018a1:	68 cc 3b 80 00       	push   $0x803bcc
  8018a6:	68 05 01 00 00       	push   $0x105
  8018ab:	68 73 3b 80 00       	push   $0x803b73
  8018b0:	e8 55 18 00 00       	call   80310a <_panic>

008018b5 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8018b5:	55                   	push   %ebp
  8018b6:	89 e5                	mov    %esp,%ebp
  8018b8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018bb:	83 ec 04             	sub    $0x4,%esp
  8018be:	68 cc 3b 80 00       	push   $0x803bcc
  8018c3:	68 0a 01 00 00       	push   $0x10a
  8018c8:	68 73 3b 80 00       	push   $0x803b73
  8018cd:	e8 38 18 00 00       	call   80310a <_panic>

008018d2 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018d2:	55                   	push   %ebp
  8018d3:	89 e5                	mov    %esp,%ebp
  8018d5:	57                   	push   %edi
  8018d6:	56                   	push   %esi
  8018d7:	53                   	push   %ebx
  8018d8:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018db:	8b 45 08             	mov    0x8(%ebp),%eax
  8018de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018e4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018e7:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018ea:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018ed:	cd 30                	int    $0x30
  8018ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018f5:	83 c4 10             	add    $0x10,%esp
  8018f8:	5b                   	pop    %ebx
  8018f9:	5e                   	pop    %esi
  8018fa:	5f                   	pop    %edi
  8018fb:	5d                   	pop    %ebp
  8018fc:	c3                   	ret    

008018fd <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018fd:	55                   	push   %ebp
  8018fe:	89 e5                	mov    %esp,%ebp
  801900:	83 ec 04             	sub    $0x4,%esp
  801903:	8b 45 10             	mov    0x10(%ebp),%eax
  801906:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801909:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80190d:	8b 45 08             	mov    0x8(%ebp),%eax
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	52                   	push   %edx
  801915:	ff 75 0c             	pushl  0xc(%ebp)
  801918:	50                   	push   %eax
  801919:	6a 00                	push   $0x0
  80191b:	e8 b2 ff ff ff       	call   8018d2 <syscall>
  801920:	83 c4 18             	add    $0x18,%esp
}
  801923:	90                   	nop
  801924:	c9                   	leave  
  801925:	c3                   	ret    

00801926 <sys_cgetc>:

int
sys_cgetc(void)
{
  801926:	55                   	push   %ebp
  801927:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	6a 01                	push   $0x1
  801935:	e8 98 ff ff ff       	call   8018d2 <syscall>
  80193a:	83 c4 18             	add    $0x18,%esp
}
  80193d:	c9                   	leave  
  80193e:	c3                   	ret    

0080193f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80193f:	55                   	push   %ebp
  801940:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801942:	8b 55 0c             	mov    0xc(%ebp),%edx
  801945:	8b 45 08             	mov    0x8(%ebp),%eax
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	52                   	push   %edx
  80194f:	50                   	push   %eax
  801950:	6a 05                	push   $0x5
  801952:	e8 7b ff ff ff       	call   8018d2 <syscall>
  801957:	83 c4 18             	add    $0x18,%esp
}
  80195a:	c9                   	leave  
  80195b:	c3                   	ret    

0080195c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
  80195f:	56                   	push   %esi
  801960:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801961:	8b 75 18             	mov    0x18(%ebp),%esi
  801964:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801967:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80196a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80196d:	8b 45 08             	mov    0x8(%ebp),%eax
  801970:	56                   	push   %esi
  801971:	53                   	push   %ebx
  801972:	51                   	push   %ecx
  801973:	52                   	push   %edx
  801974:	50                   	push   %eax
  801975:	6a 06                	push   $0x6
  801977:	e8 56 ff ff ff       	call   8018d2 <syscall>
  80197c:	83 c4 18             	add    $0x18,%esp
}
  80197f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801982:	5b                   	pop    %ebx
  801983:	5e                   	pop    %esi
  801984:	5d                   	pop    %ebp
  801985:	c3                   	ret    

00801986 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801989:	8b 55 0c             	mov    0xc(%ebp),%edx
  80198c:	8b 45 08             	mov    0x8(%ebp),%eax
  80198f:	6a 00                	push   $0x0
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	52                   	push   %edx
  801996:	50                   	push   %eax
  801997:	6a 07                	push   $0x7
  801999:	e8 34 ff ff ff       	call   8018d2 <syscall>
  80199e:	83 c4 18             	add    $0x18,%esp
}
  8019a1:	c9                   	leave  
  8019a2:	c3                   	ret    

008019a3 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019a3:	55                   	push   %ebp
  8019a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	ff 75 0c             	pushl  0xc(%ebp)
  8019af:	ff 75 08             	pushl  0x8(%ebp)
  8019b2:	6a 08                	push   $0x8
  8019b4:	e8 19 ff ff ff       	call   8018d2 <syscall>
  8019b9:	83 c4 18             	add    $0x18,%esp
}
  8019bc:	c9                   	leave  
  8019bd:	c3                   	ret    

008019be <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 09                	push   $0x9
  8019cd:	e8 00 ff ff ff       	call   8018d2 <syscall>
  8019d2:	83 c4 18             	add    $0x18,%esp
}
  8019d5:	c9                   	leave  
  8019d6:	c3                   	ret    

008019d7 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019d7:	55                   	push   %ebp
  8019d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 0a                	push   $0xa
  8019e6:	e8 e7 fe ff ff       	call   8018d2 <syscall>
  8019eb:	83 c4 18             	add    $0x18,%esp
}
  8019ee:	c9                   	leave  
  8019ef:	c3                   	ret    

008019f0 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019f0:	55                   	push   %ebp
  8019f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 0b                	push   $0xb
  8019ff:	e8 ce fe ff ff       	call   8018d2 <syscall>
  801a04:	83 c4 18             	add    $0x18,%esp
}
  801a07:	c9                   	leave  
  801a08:	c3                   	ret    

00801a09 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a09:	55                   	push   %ebp
  801a0a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	ff 75 0c             	pushl  0xc(%ebp)
  801a15:	ff 75 08             	pushl  0x8(%ebp)
  801a18:	6a 0f                	push   $0xf
  801a1a:	e8 b3 fe ff ff       	call   8018d2 <syscall>
  801a1f:	83 c4 18             	add    $0x18,%esp
	return;
  801a22:	90                   	nop
}
  801a23:	c9                   	leave  
  801a24:	c3                   	ret    

00801a25 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a25:	55                   	push   %ebp
  801a26:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	ff 75 0c             	pushl  0xc(%ebp)
  801a31:	ff 75 08             	pushl  0x8(%ebp)
  801a34:	6a 10                	push   $0x10
  801a36:	e8 97 fe ff ff       	call   8018d2 <syscall>
  801a3b:	83 c4 18             	add    $0x18,%esp
	return ;
  801a3e:	90                   	nop
}
  801a3f:	c9                   	leave  
  801a40:	c3                   	ret    

00801a41 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a41:	55                   	push   %ebp
  801a42:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	ff 75 10             	pushl  0x10(%ebp)
  801a4b:	ff 75 0c             	pushl  0xc(%ebp)
  801a4e:	ff 75 08             	pushl  0x8(%ebp)
  801a51:	6a 11                	push   $0x11
  801a53:	e8 7a fe ff ff       	call   8018d2 <syscall>
  801a58:	83 c4 18             	add    $0x18,%esp
	return ;
  801a5b:	90                   	nop
}
  801a5c:	c9                   	leave  
  801a5d:	c3                   	ret    

00801a5e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a5e:	55                   	push   %ebp
  801a5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 0c                	push   $0xc
  801a6d:	e8 60 fe ff ff       	call   8018d2 <syscall>
  801a72:	83 c4 18             	add    $0x18,%esp
}
  801a75:	c9                   	leave  
  801a76:	c3                   	ret    

00801a77 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a77:	55                   	push   %ebp
  801a78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	ff 75 08             	pushl  0x8(%ebp)
  801a85:	6a 0d                	push   $0xd
  801a87:	e8 46 fe ff ff       	call   8018d2 <syscall>
  801a8c:	83 c4 18             	add    $0x18,%esp
}
  801a8f:	c9                   	leave  
  801a90:	c3                   	ret    

00801a91 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a91:	55                   	push   %ebp
  801a92:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 0e                	push   $0xe
  801aa0:	e8 2d fe ff ff       	call   8018d2 <syscall>
  801aa5:	83 c4 18             	add    $0x18,%esp
}
  801aa8:	90                   	nop
  801aa9:	c9                   	leave  
  801aaa:	c3                   	ret    

00801aab <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801aab:	55                   	push   %ebp
  801aac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 13                	push   $0x13
  801aba:	e8 13 fe ff ff       	call   8018d2 <syscall>
  801abf:	83 c4 18             	add    $0x18,%esp
}
  801ac2:	90                   	nop
  801ac3:	c9                   	leave  
  801ac4:	c3                   	ret    

00801ac5 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801ac5:	55                   	push   %ebp
  801ac6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 14                	push   $0x14
  801ad4:	e8 f9 fd ff ff       	call   8018d2 <syscall>
  801ad9:	83 c4 18             	add    $0x18,%esp
}
  801adc:	90                   	nop
  801add:	c9                   	leave  
  801ade:	c3                   	ret    

00801adf <sys_cputc>:


void
sys_cputc(const char c)
{
  801adf:	55                   	push   %ebp
  801ae0:	89 e5                	mov    %esp,%ebp
  801ae2:	83 ec 04             	sub    $0x4,%esp
  801ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801aeb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	50                   	push   %eax
  801af8:	6a 15                	push   $0x15
  801afa:	e8 d3 fd ff ff       	call   8018d2 <syscall>
  801aff:	83 c4 18             	add    $0x18,%esp
}
  801b02:	90                   	nop
  801b03:	c9                   	leave  
  801b04:	c3                   	ret    

00801b05 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b05:	55                   	push   %ebp
  801b06:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 16                	push   $0x16
  801b14:	e8 b9 fd ff ff       	call   8018d2 <syscall>
  801b19:	83 c4 18             	add    $0x18,%esp
}
  801b1c:	90                   	nop
  801b1d:	c9                   	leave  
  801b1e:	c3                   	ret    

00801b1f <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b1f:	55                   	push   %ebp
  801b20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b22:	8b 45 08             	mov    0x8(%ebp),%eax
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	ff 75 0c             	pushl  0xc(%ebp)
  801b2e:	50                   	push   %eax
  801b2f:	6a 17                	push   $0x17
  801b31:	e8 9c fd ff ff       	call   8018d2 <syscall>
  801b36:	83 c4 18             	add    $0x18,%esp
}
  801b39:	c9                   	leave  
  801b3a:	c3                   	ret    

00801b3b <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b3b:	55                   	push   %ebp
  801b3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b41:	8b 45 08             	mov    0x8(%ebp),%eax
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	52                   	push   %edx
  801b4b:	50                   	push   %eax
  801b4c:	6a 1a                	push   $0x1a
  801b4e:	e8 7f fd ff ff       	call   8018d2 <syscall>
  801b53:	83 c4 18             	add    $0x18,%esp
}
  801b56:	c9                   	leave  
  801b57:	c3                   	ret    

00801b58 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b58:	55                   	push   %ebp
  801b59:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	52                   	push   %edx
  801b68:	50                   	push   %eax
  801b69:	6a 18                	push   $0x18
  801b6b:	e8 62 fd ff ff       	call   8018d2 <syscall>
  801b70:	83 c4 18             	add    $0x18,%esp
}
  801b73:	90                   	nop
  801b74:	c9                   	leave  
  801b75:	c3                   	ret    

00801b76 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b76:	55                   	push   %ebp
  801b77:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b79:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	52                   	push   %edx
  801b86:	50                   	push   %eax
  801b87:	6a 19                	push   $0x19
  801b89:	e8 44 fd ff ff       	call   8018d2 <syscall>
  801b8e:	83 c4 18             	add    $0x18,%esp
}
  801b91:	90                   	nop
  801b92:	c9                   	leave  
  801b93:	c3                   	ret    

00801b94 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b94:	55                   	push   %ebp
  801b95:	89 e5                	mov    %esp,%ebp
  801b97:	83 ec 04             	sub    $0x4,%esp
  801b9a:	8b 45 10             	mov    0x10(%ebp),%eax
  801b9d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ba0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ba3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  801baa:	6a 00                	push   $0x0
  801bac:	51                   	push   %ecx
  801bad:	52                   	push   %edx
  801bae:	ff 75 0c             	pushl  0xc(%ebp)
  801bb1:	50                   	push   %eax
  801bb2:	6a 1b                	push   $0x1b
  801bb4:	e8 19 fd ff ff       	call   8018d2 <syscall>
  801bb9:	83 c4 18             	add    $0x18,%esp
}
  801bbc:	c9                   	leave  
  801bbd:	c3                   	ret    

00801bbe <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801bbe:	55                   	push   %ebp
  801bbf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801bc1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	52                   	push   %edx
  801bce:	50                   	push   %eax
  801bcf:	6a 1c                	push   $0x1c
  801bd1:	e8 fc fc ff ff       	call   8018d2 <syscall>
  801bd6:	83 c4 18             	add    $0x18,%esp
}
  801bd9:	c9                   	leave  
  801bda:	c3                   	ret    

00801bdb <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801bdb:	55                   	push   %ebp
  801bdc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bde:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801be1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be4:	8b 45 08             	mov    0x8(%ebp),%eax
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	51                   	push   %ecx
  801bec:	52                   	push   %edx
  801bed:	50                   	push   %eax
  801bee:	6a 1d                	push   $0x1d
  801bf0:	e8 dd fc ff ff       	call   8018d2 <syscall>
  801bf5:	83 c4 18             	add    $0x18,%esp
}
  801bf8:	c9                   	leave  
  801bf9:	c3                   	ret    

00801bfa <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801bfa:	55                   	push   %ebp
  801bfb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bfd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c00:	8b 45 08             	mov    0x8(%ebp),%eax
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	52                   	push   %edx
  801c0a:	50                   	push   %eax
  801c0b:	6a 1e                	push   $0x1e
  801c0d:	e8 c0 fc ff ff       	call   8018d2 <syscall>
  801c12:	83 c4 18             	add    $0x18,%esp
}
  801c15:	c9                   	leave  
  801c16:	c3                   	ret    

00801c17 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 1f                	push   $0x1f
  801c26:	e8 a7 fc ff ff       	call   8018d2 <syscall>
  801c2b:	83 c4 18             	add    $0x18,%esp
}
  801c2e:	c9                   	leave  
  801c2f:	c3                   	ret    

00801c30 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c30:	55                   	push   %ebp
  801c31:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c33:	8b 45 08             	mov    0x8(%ebp),%eax
  801c36:	6a 00                	push   $0x0
  801c38:	ff 75 14             	pushl  0x14(%ebp)
  801c3b:	ff 75 10             	pushl  0x10(%ebp)
  801c3e:	ff 75 0c             	pushl  0xc(%ebp)
  801c41:	50                   	push   %eax
  801c42:	6a 20                	push   $0x20
  801c44:	e8 89 fc ff ff       	call   8018d2 <syscall>
  801c49:	83 c4 18             	add    $0x18,%esp
}
  801c4c:	c9                   	leave  
  801c4d:	c3                   	ret    

00801c4e <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c4e:	55                   	push   %ebp
  801c4f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c51:	8b 45 08             	mov    0x8(%ebp),%eax
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	50                   	push   %eax
  801c5d:	6a 21                	push   $0x21
  801c5f:	e8 6e fc ff ff       	call   8018d2 <syscall>
  801c64:	83 c4 18             	add    $0x18,%esp
}
  801c67:	90                   	nop
  801c68:	c9                   	leave  
  801c69:	c3                   	ret    

00801c6a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c6a:	55                   	push   %ebp
  801c6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	50                   	push   %eax
  801c79:	6a 22                	push   $0x22
  801c7b:	e8 52 fc ff ff       	call   8018d2 <syscall>
  801c80:	83 c4 18             	add    $0x18,%esp
}
  801c83:	c9                   	leave  
  801c84:	c3                   	ret    

00801c85 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c85:	55                   	push   %ebp
  801c86:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 02                	push   $0x2
  801c94:	e8 39 fc ff ff       	call   8018d2 <syscall>
  801c99:	83 c4 18             	add    $0x18,%esp
}
  801c9c:	c9                   	leave  
  801c9d:	c3                   	ret    

00801c9e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 03                	push   $0x3
  801cad:	e8 20 fc ff ff       	call   8018d2 <syscall>
  801cb2:	83 c4 18             	add    $0x18,%esp
}
  801cb5:	c9                   	leave  
  801cb6:	c3                   	ret    

00801cb7 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801cb7:	55                   	push   %ebp
  801cb8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 04                	push   $0x4
  801cc6:	e8 07 fc ff ff       	call   8018d2 <syscall>
  801ccb:	83 c4 18             	add    $0x18,%esp
}
  801cce:	c9                   	leave  
  801ccf:	c3                   	ret    

00801cd0 <sys_exit_env>:


void sys_exit_env(void)
{
  801cd0:	55                   	push   %ebp
  801cd1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 23                	push   $0x23
  801cdf:	e8 ee fb ff ff       	call   8018d2 <syscall>
  801ce4:	83 c4 18             	add    $0x18,%esp
}
  801ce7:	90                   	nop
  801ce8:	c9                   	leave  
  801ce9:	c3                   	ret    

00801cea <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801cea:	55                   	push   %ebp
  801ceb:	89 e5                	mov    %esp,%ebp
  801ced:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801cf0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cf3:	8d 50 04             	lea    0x4(%eax),%edx
  801cf6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	52                   	push   %edx
  801d00:	50                   	push   %eax
  801d01:	6a 24                	push   $0x24
  801d03:	e8 ca fb ff ff       	call   8018d2 <syscall>
  801d08:	83 c4 18             	add    $0x18,%esp
	return result;
  801d0b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d0e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d11:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d14:	89 01                	mov    %eax,(%ecx)
  801d16:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d19:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1c:	c9                   	leave  
  801d1d:	c2 04 00             	ret    $0x4

00801d20 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d20:	55                   	push   %ebp
  801d21:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	ff 75 10             	pushl  0x10(%ebp)
  801d2a:	ff 75 0c             	pushl  0xc(%ebp)
  801d2d:	ff 75 08             	pushl  0x8(%ebp)
  801d30:	6a 12                	push   $0x12
  801d32:	e8 9b fb ff ff       	call   8018d2 <syscall>
  801d37:	83 c4 18             	add    $0x18,%esp
	return ;
  801d3a:	90                   	nop
}
  801d3b:	c9                   	leave  
  801d3c:	c3                   	ret    

00801d3d <sys_rcr2>:
uint32 sys_rcr2()
{
  801d3d:	55                   	push   %ebp
  801d3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 25                	push   $0x25
  801d4c:	e8 81 fb ff ff       	call   8018d2 <syscall>
  801d51:	83 c4 18             	add    $0x18,%esp
}
  801d54:	c9                   	leave  
  801d55:	c3                   	ret    

00801d56 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d56:	55                   	push   %ebp
  801d57:	89 e5                	mov    %esp,%ebp
  801d59:	83 ec 04             	sub    $0x4,%esp
  801d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d62:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	50                   	push   %eax
  801d6f:	6a 26                	push   $0x26
  801d71:	e8 5c fb ff ff       	call   8018d2 <syscall>
  801d76:	83 c4 18             	add    $0x18,%esp
	return ;
  801d79:	90                   	nop
}
  801d7a:	c9                   	leave  
  801d7b:	c3                   	ret    

00801d7c <rsttst>:
void rsttst()
{
  801d7c:	55                   	push   %ebp
  801d7d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	6a 28                	push   $0x28
  801d8b:	e8 42 fb ff ff       	call   8018d2 <syscall>
  801d90:	83 c4 18             	add    $0x18,%esp
	return ;
  801d93:	90                   	nop
}
  801d94:	c9                   	leave  
  801d95:	c3                   	ret    

00801d96 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d96:	55                   	push   %ebp
  801d97:	89 e5                	mov    %esp,%ebp
  801d99:	83 ec 04             	sub    $0x4,%esp
  801d9c:	8b 45 14             	mov    0x14(%ebp),%eax
  801d9f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801da2:	8b 55 18             	mov    0x18(%ebp),%edx
  801da5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801da9:	52                   	push   %edx
  801daa:	50                   	push   %eax
  801dab:	ff 75 10             	pushl  0x10(%ebp)
  801dae:	ff 75 0c             	pushl  0xc(%ebp)
  801db1:	ff 75 08             	pushl  0x8(%ebp)
  801db4:	6a 27                	push   $0x27
  801db6:	e8 17 fb ff ff       	call   8018d2 <syscall>
  801dbb:	83 c4 18             	add    $0x18,%esp
	return ;
  801dbe:	90                   	nop
}
  801dbf:	c9                   	leave  
  801dc0:	c3                   	ret    

00801dc1 <chktst>:
void chktst(uint32 n)
{
  801dc1:	55                   	push   %ebp
  801dc2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	ff 75 08             	pushl  0x8(%ebp)
  801dcf:	6a 29                	push   $0x29
  801dd1:	e8 fc fa ff ff       	call   8018d2 <syscall>
  801dd6:	83 c4 18             	add    $0x18,%esp
	return ;
  801dd9:	90                   	nop
}
  801dda:	c9                   	leave  
  801ddb:	c3                   	ret    

00801ddc <inctst>:

void inctst()
{
  801ddc:	55                   	push   %ebp
  801ddd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	6a 00                	push   $0x0
  801de9:	6a 2a                	push   $0x2a
  801deb:	e8 e2 fa ff ff       	call   8018d2 <syscall>
  801df0:	83 c4 18             	add    $0x18,%esp
	return ;
  801df3:	90                   	nop
}
  801df4:	c9                   	leave  
  801df5:	c3                   	ret    

00801df6 <gettst>:
uint32 gettst()
{
  801df6:	55                   	push   %ebp
  801df7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	6a 00                	push   $0x0
  801e03:	6a 2b                	push   $0x2b
  801e05:	e8 c8 fa ff ff       	call   8018d2 <syscall>
  801e0a:	83 c4 18             	add    $0x18,%esp
}
  801e0d:	c9                   	leave  
  801e0e:	c3                   	ret    

00801e0f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e0f:	55                   	push   %ebp
  801e10:	89 e5                	mov    %esp,%ebp
  801e12:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	6a 00                	push   $0x0
  801e1b:	6a 00                	push   $0x0
  801e1d:	6a 00                	push   $0x0
  801e1f:	6a 2c                	push   $0x2c
  801e21:	e8 ac fa ff ff       	call   8018d2 <syscall>
  801e26:	83 c4 18             	add    $0x18,%esp
  801e29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e2c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e30:	75 07                	jne    801e39 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e32:	b8 01 00 00 00       	mov    $0x1,%eax
  801e37:	eb 05                	jmp    801e3e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e39:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e3e:	c9                   	leave  
  801e3f:	c3                   	ret    

00801e40 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e40:	55                   	push   %ebp
  801e41:	89 e5                	mov    %esp,%ebp
  801e43:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e46:	6a 00                	push   $0x0
  801e48:	6a 00                	push   $0x0
  801e4a:	6a 00                	push   $0x0
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 00                	push   $0x0
  801e50:	6a 2c                	push   $0x2c
  801e52:	e8 7b fa ff ff       	call   8018d2 <syscall>
  801e57:	83 c4 18             	add    $0x18,%esp
  801e5a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e5d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e61:	75 07                	jne    801e6a <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e63:	b8 01 00 00 00       	mov    $0x1,%eax
  801e68:	eb 05                	jmp    801e6f <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e6f:	c9                   	leave  
  801e70:	c3                   	ret    

00801e71 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e71:	55                   	push   %ebp
  801e72:	89 e5                	mov    %esp,%ebp
  801e74:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e77:	6a 00                	push   $0x0
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 00                	push   $0x0
  801e7d:	6a 00                	push   $0x0
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 2c                	push   $0x2c
  801e83:	e8 4a fa ff ff       	call   8018d2 <syscall>
  801e88:	83 c4 18             	add    $0x18,%esp
  801e8b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e8e:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e92:	75 07                	jne    801e9b <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e94:	b8 01 00 00 00       	mov    $0x1,%eax
  801e99:	eb 05                	jmp    801ea0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ea0:	c9                   	leave  
  801ea1:	c3                   	ret    

00801ea2 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ea2:	55                   	push   %ebp
  801ea3:	89 e5                	mov    %esp,%ebp
  801ea5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 00                	push   $0x0
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 2c                	push   $0x2c
  801eb4:	e8 19 fa ff ff       	call   8018d2 <syscall>
  801eb9:	83 c4 18             	add    $0x18,%esp
  801ebc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ebf:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ec3:	75 07                	jne    801ecc <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ec5:	b8 01 00 00 00       	mov    $0x1,%eax
  801eca:	eb 05                	jmp    801ed1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ecc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ed1:	c9                   	leave  
  801ed2:	c3                   	ret    

00801ed3 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ed3:	55                   	push   %ebp
  801ed4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 00                	push   $0x0
  801eda:	6a 00                	push   $0x0
  801edc:	6a 00                	push   $0x0
  801ede:	ff 75 08             	pushl  0x8(%ebp)
  801ee1:	6a 2d                	push   $0x2d
  801ee3:	e8 ea f9 ff ff       	call   8018d2 <syscall>
  801ee8:	83 c4 18             	add    $0x18,%esp
	return ;
  801eeb:	90                   	nop
}
  801eec:	c9                   	leave  
  801eed:	c3                   	ret    

00801eee <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801eee:	55                   	push   %ebp
  801eef:	89 e5                	mov    %esp,%ebp
  801ef1:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ef2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ef5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ef8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801efb:	8b 45 08             	mov    0x8(%ebp),%eax
  801efe:	6a 00                	push   $0x0
  801f00:	53                   	push   %ebx
  801f01:	51                   	push   %ecx
  801f02:	52                   	push   %edx
  801f03:	50                   	push   %eax
  801f04:	6a 2e                	push   $0x2e
  801f06:	e8 c7 f9 ff ff       	call   8018d2 <syscall>
  801f0b:	83 c4 18             	add    $0x18,%esp
}
  801f0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f11:	c9                   	leave  
  801f12:	c3                   	ret    

00801f13 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f13:	55                   	push   %ebp
  801f14:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f16:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f19:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1c:	6a 00                	push   $0x0
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 00                	push   $0x0
  801f22:	52                   	push   %edx
  801f23:	50                   	push   %eax
  801f24:	6a 2f                	push   $0x2f
  801f26:	e8 a7 f9 ff ff       	call   8018d2 <syscall>
  801f2b:	83 c4 18             	add    $0x18,%esp
}
  801f2e:	c9                   	leave  
  801f2f:	c3                   	ret    

00801f30 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f30:	55                   	push   %ebp
  801f31:	89 e5                	mov    %esp,%ebp
  801f33:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f36:	83 ec 0c             	sub    $0xc,%esp
  801f39:	68 dc 3b 80 00       	push   $0x803bdc
  801f3e:	e8 df e6 ff ff       	call   800622 <cprintf>
  801f43:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f46:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f4d:	83 ec 0c             	sub    $0xc,%esp
  801f50:	68 08 3c 80 00       	push   $0x803c08
  801f55:	e8 c8 e6 ff ff       	call   800622 <cprintf>
  801f5a:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f5d:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f61:	a1 38 41 80 00       	mov    0x804138,%eax
  801f66:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f69:	eb 56                	jmp    801fc1 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f6b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f6f:	74 1c                	je     801f8d <print_mem_block_lists+0x5d>
  801f71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f74:	8b 50 08             	mov    0x8(%eax),%edx
  801f77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f7a:	8b 48 08             	mov    0x8(%eax),%ecx
  801f7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f80:	8b 40 0c             	mov    0xc(%eax),%eax
  801f83:	01 c8                	add    %ecx,%eax
  801f85:	39 c2                	cmp    %eax,%edx
  801f87:	73 04                	jae    801f8d <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f89:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f90:	8b 50 08             	mov    0x8(%eax),%edx
  801f93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f96:	8b 40 0c             	mov    0xc(%eax),%eax
  801f99:	01 c2                	add    %eax,%edx
  801f9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9e:	8b 40 08             	mov    0x8(%eax),%eax
  801fa1:	83 ec 04             	sub    $0x4,%esp
  801fa4:	52                   	push   %edx
  801fa5:	50                   	push   %eax
  801fa6:	68 1d 3c 80 00       	push   $0x803c1d
  801fab:	e8 72 e6 ff ff       	call   800622 <cprintf>
  801fb0:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fb9:	a1 40 41 80 00       	mov    0x804140,%eax
  801fbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fc1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fc5:	74 07                	je     801fce <print_mem_block_lists+0x9e>
  801fc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fca:	8b 00                	mov    (%eax),%eax
  801fcc:	eb 05                	jmp    801fd3 <print_mem_block_lists+0xa3>
  801fce:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd3:	a3 40 41 80 00       	mov    %eax,0x804140
  801fd8:	a1 40 41 80 00       	mov    0x804140,%eax
  801fdd:	85 c0                	test   %eax,%eax
  801fdf:	75 8a                	jne    801f6b <print_mem_block_lists+0x3b>
  801fe1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fe5:	75 84                	jne    801f6b <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801fe7:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801feb:	75 10                	jne    801ffd <print_mem_block_lists+0xcd>
  801fed:	83 ec 0c             	sub    $0xc,%esp
  801ff0:	68 2c 3c 80 00       	push   $0x803c2c
  801ff5:	e8 28 e6 ff ff       	call   800622 <cprintf>
  801ffa:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801ffd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802004:	83 ec 0c             	sub    $0xc,%esp
  802007:	68 50 3c 80 00       	push   $0x803c50
  80200c:	e8 11 e6 ff ff       	call   800622 <cprintf>
  802011:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802014:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802018:	a1 40 40 80 00       	mov    0x804040,%eax
  80201d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802020:	eb 56                	jmp    802078 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802022:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802026:	74 1c                	je     802044 <print_mem_block_lists+0x114>
  802028:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202b:	8b 50 08             	mov    0x8(%eax),%edx
  80202e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802031:	8b 48 08             	mov    0x8(%eax),%ecx
  802034:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802037:	8b 40 0c             	mov    0xc(%eax),%eax
  80203a:	01 c8                	add    %ecx,%eax
  80203c:	39 c2                	cmp    %eax,%edx
  80203e:	73 04                	jae    802044 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802040:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802044:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802047:	8b 50 08             	mov    0x8(%eax),%edx
  80204a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204d:	8b 40 0c             	mov    0xc(%eax),%eax
  802050:	01 c2                	add    %eax,%edx
  802052:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802055:	8b 40 08             	mov    0x8(%eax),%eax
  802058:	83 ec 04             	sub    $0x4,%esp
  80205b:	52                   	push   %edx
  80205c:	50                   	push   %eax
  80205d:	68 1d 3c 80 00       	push   $0x803c1d
  802062:	e8 bb e5 ff ff       	call   800622 <cprintf>
  802067:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80206a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802070:	a1 48 40 80 00       	mov    0x804048,%eax
  802075:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802078:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80207c:	74 07                	je     802085 <print_mem_block_lists+0x155>
  80207e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802081:	8b 00                	mov    (%eax),%eax
  802083:	eb 05                	jmp    80208a <print_mem_block_lists+0x15a>
  802085:	b8 00 00 00 00       	mov    $0x0,%eax
  80208a:	a3 48 40 80 00       	mov    %eax,0x804048
  80208f:	a1 48 40 80 00       	mov    0x804048,%eax
  802094:	85 c0                	test   %eax,%eax
  802096:	75 8a                	jne    802022 <print_mem_block_lists+0xf2>
  802098:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80209c:	75 84                	jne    802022 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80209e:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8020a2:	75 10                	jne    8020b4 <print_mem_block_lists+0x184>
  8020a4:	83 ec 0c             	sub    $0xc,%esp
  8020a7:	68 68 3c 80 00       	push   $0x803c68
  8020ac:	e8 71 e5 ff ff       	call   800622 <cprintf>
  8020b1:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8020b4:	83 ec 0c             	sub    $0xc,%esp
  8020b7:	68 dc 3b 80 00       	push   $0x803bdc
  8020bc:	e8 61 e5 ff ff       	call   800622 <cprintf>
  8020c1:	83 c4 10             	add    $0x10,%esp

}
  8020c4:	90                   	nop
  8020c5:	c9                   	leave  
  8020c6:	c3                   	ret    

008020c7 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8020c7:	55                   	push   %ebp
  8020c8:	89 e5                	mov    %esp,%ebp
  8020ca:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8020cd:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  8020d4:	00 00 00 
  8020d7:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  8020de:	00 00 00 
  8020e1:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  8020e8:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  8020eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8020f2:	e9 9e 00 00 00       	jmp    802195 <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  8020f7:	a1 50 40 80 00       	mov    0x804050,%eax
  8020fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020ff:	c1 e2 04             	shl    $0x4,%edx
  802102:	01 d0                	add    %edx,%eax
  802104:	85 c0                	test   %eax,%eax
  802106:	75 14                	jne    80211c <initialize_MemBlocksList+0x55>
  802108:	83 ec 04             	sub    $0x4,%esp
  80210b:	68 90 3c 80 00       	push   $0x803c90
  802110:	6a 42                	push   $0x42
  802112:	68 b3 3c 80 00       	push   $0x803cb3
  802117:	e8 ee 0f 00 00       	call   80310a <_panic>
  80211c:	a1 50 40 80 00       	mov    0x804050,%eax
  802121:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802124:	c1 e2 04             	shl    $0x4,%edx
  802127:	01 d0                	add    %edx,%eax
  802129:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80212f:	89 10                	mov    %edx,(%eax)
  802131:	8b 00                	mov    (%eax),%eax
  802133:	85 c0                	test   %eax,%eax
  802135:	74 18                	je     80214f <initialize_MemBlocksList+0x88>
  802137:	a1 48 41 80 00       	mov    0x804148,%eax
  80213c:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802142:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802145:	c1 e1 04             	shl    $0x4,%ecx
  802148:	01 ca                	add    %ecx,%edx
  80214a:	89 50 04             	mov    %edx,0x4(%eax)
  80214d:	eb 12                	jmp    802161 <initialize_MemBlocksList+0x9a>
  80214f:	a1 50 40 80 00       	mov    0x804050,%eax
  802154:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802157:	c1 e2 04             	shl    $0x4,%edx
  80215a:	01 d0                	add    %edx,%eax
  80215c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802161:	a1 50 40 80 00       	mov    0x804050,%eax
  802166:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802169:	c1 e2 04             	shl    $0x4,%edx
  80216c:	01 d0                	add    %edx,%eax
  80216e:	a3 48 41 80 00       	mov    %eax,0x804148
  802173:	a1 50 40 80 00       	mov    0x804050,%eax
  802178:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80217b:	c1 e2 04             	shl    $0x4,%edx
  80217e:	01 d0                	add    %edx,%eax
  802180:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802187:	a1 54 41 80 00       	mov    0x804154,%eax
  80218c:	40                   	inc    %eax
  80218d:	a3 54 41 80 00       	mov    %eax,0x804154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  802192:	ff 45 f4             	incl   -0xc(%ebp)
  802195:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802198:	3b 45 08             	cmp    0x8(%ebp),%eax
  80219b:	0f 82 56 ff ff ff    	jb     8020f7 <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  8021a1:	90                   	nop
  8021a2:	c9                   	leave  
  8021a3:	c3                   	ret    

008021a4 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8021a4:	55                   	push   %ebp
  8021a5:	89 e5                	mov    %esp,%ebp
  8021a7:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  8021aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ad:	8b 00                	mov    (%eax),%eax
  8021af:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021b2:	eb 19                	jmp    8021cd <find_block+0x29>
	{
		if(blk->sva==va)
  8021b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021b7:	8b 40 08             	mov    0x8(%eax),%eax
  8021ba:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8021bd:	75 05                	jne    8021c4 <find_block+0x20>
			return (blk);
  8021bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021c2:	eb 36                	jmp    8021fa <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  8021c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c7:	8b 40 08             	mov    0x8(%eax),%eax
  8021ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021d1:	74 07                	je     8021da <find_block+0x36>
  8021d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021d6:	8b 00                	mov    (%eax),%eax
  8021d8:	eb 05                	jmp    8021df <find_block+0x3b>
  8021da:	b8 00 00 00 00       	mov    $0x0,%eax
  8021df:	8b 55 08             	mov    0x8(%ebp),%edx
  8021e2:	89 42 08             	mov    %eax,0x8(%edx)
  8021e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e8:	8b 40 08             	mov    0x8(%eax),%eax
  8021eb:	85 c0                	test   %eax,%eax
  8021ed:	75 c5                	jne    8021b4 <find_block+0x10>
  8021ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021f3:	75 bf                	jne    8021b4 <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  8021f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021fa:	c9                   	leave  
  8021fb:	c3                   	ret    

008021fc <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8021fc:	55                   	push   %ebp
  8021fd:	89 e5                	mov    %esp,%ebp
  8021ff:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  802202:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802207:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80220a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  802211:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802214:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802217:	75 65                	jne    80227e <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802219:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80221d:	75 14                	jne    802233 <insert_sorted_allocList+0x37>
  80221f:	83 ec 04             	sub    $0x4,%esp
  802222:	68 90 3c 80 00       	push   $0x803c90
  802227:	6a 5c                	push   $0x5c
  802229:	68 b3 3c 80 00       	push   $0x803cb3
  80222e:	e8 d7 0e 00 00       	call   80310a <_panic>
  802233:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802239:	8b 45 08             	mov    0x8(%ebp),%eax
  80223c:	89 10                	mov    %edx,(%eax)
  80223e:	8b 45 08             	mov    0x8(%ebp),%eax
  802241:	8b 00                	mov    (%eax),%eax
  802243:	85 c0                	test   %eax,%eax
  802245:	74 0d                	je     802254 <insert_sorted_allocList+0x58>
  802247:	a1 40 40 80 00       	mov    0x804040,%eax
  80224c:	8b 55 08             	mov    0x8(%ebp),%edx
  80224f:	89 50 04             	mov    %edx,0x4(%eax)
  802252:	eb 08                	jmp    80225c <insert_sorted_allocList+0x60>
  802254:	8b 45 08             	mov    0x8(%ebp),%eax
  802257:	a3 44 40 80 00       	mov    %eax,0x804044
  80225c:	8b 45 08             	mov    0x8(%ebp),%eax
  80225f:	a3 40 40 80 00       	mov    %eax,0x804040
  802264:	8b 45 08             	mov    0x8(%ebp),%eax
  802267:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80226e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802273:	40                   	inc    %eax
  802274:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  802279:	e9 7b 01 00 00       	jmp    8023f9 <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  80227e:	a1 44 40 80 00       	mov    0x804044,%eax
  802283:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  802286:	a1 40 40 80 00       	mov    0x804040,%eax
  80228b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  80228e:	8b 45 08             	mov    0x8(%ebp),%eax
  802291:	8b 50 08             	mov    0x8(%eax),%edx
  802294:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802297:	8b 40 08             	mov    0x8(%eax),%eax
  80229a:	39 c2                	cmp    %eax,%edx
  80229c:	76 65                	jbe    802303 <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  80229e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022a2:	75 14                	jne    8022b8 <insert_sorted_allocList+0xbc>
  8022a4:	83 ec 04             	sub    $0x4,%esp
  8022a7:	68 cc 3c 80 00       	push   $0x803ccc
  8022ac:	6a 64                	push   $0x64
  8022ae:	68 b3 3c 80 00       	push   $0x803cb3
  8022b3:	e8 52 0e 00 00       	call   80310a <_panic>
  8022b8:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8022be:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c1:	89 50 04             	mov    %edx,0x4(%eax)
  8022c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c7:	8b 40 04             	mov    0x4(%eax),%eax
  8022ca:	85 c0                	test   %eax,%eax
  8022cc:	74 0c                	je     8022da <insert_sorted_allocList+0xde>
  8022ce:	a1 44 40 80 00       	mov    0x804044,%eax
  8022d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8022d6:	89 10                	mov    %edx,(%eax)
  8022d8:	eb 08                	jmp    8022e2 <insert_sorted_allocList+0xe6>
  8022da:	8b 45 08             	mov    0x8(%ebp),%eax
  8022dd:	a3 40 40 80 00       	mov    %eax,0x804040
  8022e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e5:	a3 44 40 80 00       	mov    %eax,0x804044
  8022ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022f3:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022f8:	40                   	inc    %eax
  8022f9:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  8022fe:	e9 f6 00 00 00       	jmp    8023f9 <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  802303:	8b 45 08             	mov    0x8(%ebp),%eax
  802306:	8b 50 08             	mov    0x8(%eax),%edx
  802309:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80230c:	8b 40 08             	mov    0x8(%eax),%eax
  80230f:	39 c2                	cmp    %eax,%edx
  802311:	73 65                	jae    802378 <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802313:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802317:	75 14                	jne    80232d <insert_sorted_allocList+0x131>
  802319:	83 ec 04             	sub    $0x4,%esp
  80231c:	68 90 3c 80 00       	push   $0x803c90
  802321:	6a 68                	push   $0x68
  802323:	68 b3 3c 80 00       	push   $0x803cb3
  802328:	e8 dd 0d 00 00       	call   80310a <_panic>
  80232d:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802333:	8b 45 08             	mov    0x8(%ebp),%eax
  802336:	89 10                	mov    %edx,(%eax)
  802338:	8b 45 08             	mov    0x8(%ebp),%eax
  80233b:	8b 00                	mov    (%eax),%eax
  80233d:	85 c0                	test   %eax,%eax
  80233f:	74 0d                	je     80234e <insert_sorted_allocList+0x152>
  802341:	a1 40 40 80 00       	mov    0x804040,%eax
  802346:	8b 55 08             	mov    0x8(%ebp),%edx
  802349:	89 50 04             	mov    %edx,0x4(%eax)
  80234c:	eb 08                	jmp    802356 <insert_sorted_allocList+0x15a>
  80234e:	8b 45 08             	mov    0x8(%ebp),%eax
  802351:	a3 44 40 80 00       	mov    %eax,0x804044
  802356:	8b 45 08             	mov    0x8(%ebp),%eax
  802359:	a3 40 40 80 00       	mov    %eax,0x804040
  80235e:	8b 45 08             	mov    0x8(%ebp),%eax
  802361:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802368:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80236d:	40                   	inc    %eax
  80236e:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  802373:	e9 81 00 00 00       	jmp    8023f9 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802378:	a1 40 40 80 00       	mov    0x804040,%eax
  80237d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802380:	eb 51                	jmp    8023d3 <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  802382:	8b 45 08             	mov    0x8(%ebp),%eax
  802385:	8b 50 08             	mov    0x8(%eax),%edx
  802388:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238b:	8b 40 08             	mov    0x8(%eax),%eax
  80238e:	39 c2                	cmp    %eax,%edx
  802390:	73 39                	jae    8023cb <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  802392:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802395:	8b 40 04             	mov    0x4(%eax),%eax
  802398:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  80239b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80239e:	8b 55 08             	mov    0x8(%ebp),%edx
  8023a1:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  8023a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8023a9:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  8023ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8023af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023b2:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  8023b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8023ba:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  8023bd:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023c2:	40                   	inc    %eax
  8023c3:	a3 4c 40 80 00       	mov    %eax,0x80404c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  8023c8:	90                   	nop
				}
			}
		 }

	}
}
  8023c9:	eb 2e                	jmp    8023f9 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  8023cb:	a1 48 40 80 00       	mov    0x804048,%eax
  8023d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023d7:	74 07                	je     8023e0 <insert_sorted_allocList+0x1e4>
  8023d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023dc:	8b 00                	mov    (%eax),%eax
  8023de:	eb 05                	jmp    8023e5 <insert_sorted_allocList+0x1e9>
  8023e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e5:	a3 48 40 80 00       	mov    %eax,0x804048
  8023ea:	a1 48 40 80 00       	mov    0x804048,%eax
  8023ef:	85 c0                	test   %eax,%eax
  8023f1:	75 8f                	jne    802382 <insert_sorted_allocList+0x186>
  8023f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023f7:	75 89                	jne    802382 <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  8023f9:	90                   	nop
  8023fa:	c9                   	leave  
  8023fb:	c3                   	ret    

008023fc <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8023fc:	55                   	push   %ebp
  8023fd:	89 e5                	mov    %esp,%ebp
  8023ff:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802402:	a1 38 41 80 00       	mov    0x804138,%eax
  802407:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80240a:	e9 76 01 00 00       	jmp    802585 <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  80240f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802412:	8b 40 0c             	mov    0xc(%eax),%eax
  802415:	3b 45 08             	cmp    0x8(%ebp),%eax
  802418:	0f 85 8a 00 00 00    	jne    8024a8 <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  80241e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802422:	75 17                	jne    80243b <alloc_block_FF+0x3f>
  802424:	83 ec 04             	sub    $0x4,%esp
  802427:	68 ef 3c 80 00       	push   $0x803cef
  80242c:	68 8a 00 00 00       	push   $0x8a
  802431:	68 b3 3c 80 00       	push   $0x803cb3
  802436:	e8 cf 0c 00 00       	call   80310a <_panic>
  80243b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243e:	8b 00                	mov    (%eax),%eax
  802440:	85 c0                	test   %eax,%eax
  802442:	74 10                	je     802454 <alloc_block_FF+0x58>
  802444:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802447:	8b 00                	mov    (%eax),%eax
  802449:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80244c:	8b 52 04             	mov    0x4(%edx),%edx
  80244f:	89 50 04             	mov    %edx,0x4(%eax)
  802452:	eb 0b                	jmp    80245f <alloc_block_FF+0x63>
  802454:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802457:	8b 40 04             	mov    0x4(%eax),%eax
  80245a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80245f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802462:	8b 40 04             	mov    0x4(%eax),%eax
  802465:	85 c0                	test   %eax,%eax
  802467:	74 0f                	je     802478 <alloc_block_FF+0x7c>
  802469:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246c:	8b 40 04             	mov    0x4(%eax),%eax
  80246f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802472:	8b 12                	mov    (%edx),%edx
  802474:	89 10                	mov    %edx,(%eax)
  802476:	eb 0a                	jmp    802482 <alloc_block_FF+0x86>
  802478:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247b:	8b 00                	mov    (%eax),%eax
  80247d:	a3 38 41 80 00       	mov    %eax,0x804138
  802482:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802485:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80248b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802495:	a1 44 41 80 00       	mov    0x804144,%eax
  80249a:	48                   	dec    %eax
  80249b:	a3 44 41 80 00       	mov    %eax,0x804144
			return element;
  8024a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a3:	e9 10 01 00 00       	jmp    8025b8 <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  8024a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8024ae:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024b1:	0f 86 c6 00 00 00    	jbe    80257d <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  8024b7:	a1 48 41 80 00       	mov    0x804148,%eax
  8024bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  8024bf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024c3:	75 17                	jne    8024dc <alloc_block_FF+0xe0>
  8024c5:	83 ec 04             	sub    $0x4,%esp
  8024c8:	68 ef 3c 80 00       	push   $0x803cef
  8024cd:	68 90 00 00 00       	push   $0x90
  8024d2:	68 b3 3c 80 00       	push   $0x803cb3
  8024d7:	e8 2e 0c 00 00       	call   80310a <_panic>
  8024dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024df:	8b 00                	mov    (%eax),%eax
  8024e1:	85 c0                	test   %eax,%eax
  8024e3:	74 10                	je     8024f5 <alloc_block_FF+0xf9>
  8024e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e8:	8b 00                	mov    (%eax),%eax
  8024ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024ed:	8b 52 04             	mov    0x4(%edx),%edx
  8024f0:	89 50 04             	mov    %edx,0x4(%eax)
  8024f3:	eb 0b                	jmp    802500 <alloc_block_FF+0x104>
  8024f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f8:	8b 40 04             	mov    0x4(%eax),%eax
  8024fb:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802500:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802503:	8b 40 04             	mov    0x4(%eax),%eax
  802506:	85 c0                	test   %eax,%eax
  802508:	74 0f                	je     802519 <alloc_block_FF+0x11d>
  80250a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80250d:	8b 40 04             	mov    0x4(%eax),%eax
  802510:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802513:	8b 12                	mov    (%edx),%edx
  802515:	89 10                	mov    %edx,(%eax)
  802517:	eb 0a                	jmp    802523 <alloc_block_FF+0x127>
  802519:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80251c:	8b 00                	mov    (%eax),%eax
  80251e:	a3 48 41 80 00       	mov    %eax,0x804148
  802523:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802526:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80252c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80252f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802536:	a1 54 41 80 00       	mov    0x804154,%eax
  80253b:	48                   	dec    %eax
  80253c:	a3 54 41 80 00       	mov    %eax,0x804154
			 element1->size =size;
  802541:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802544:	8b 55 08             	mov    0x8(%ebp),%edx
  802547:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  80254a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254d:	8b 50 08             	mov    0x8(%eax),%edx
  802550:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802553:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  802556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802559:	8b 50 08             	mov    0x8(%eax),%edx
  80255c:	8b 45 08             	mov    0x8(%ebp),%eax
  80255f:	01 c2                	add    %eax,%edx
  802561:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802564:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  802567:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256a:	8b 40 0c             	mov    0xc(%eax),%eax
  80256d:	2b 45 08             	sub    0x8(%ebp),%eax
  802570:	89 c2                	mov    %eax,%edx
  802572:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802575:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  802578:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80257b:	eb 3b                	jmp    8025b8 <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  80257d:	a1 40 41 80 00       	mov    0x804140,%eax
  802582:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802585:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802589:	74 07                	je     802592 <alloc_block_FF+0x196>
  80258b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258e:	8b 00                	mov    (%eax),%eax
  802590:	eb 05                	jmp    802597 <alloc_block_FF+0x19b>
  802592:	b8 00 00 00 00       	mov    $0x0,%eax
  802597:	a3 40 41 80 00       	mov    %eax,0x804140
  80259c:	a1 40 41 80 00       	mov    0x804140,%eax
  8025a1:	85 c0                	test   %eax,%eax
  8025a3:	0f 85 66 fe ff ff    	jne    80240f <alloc_block_FF+0x13>
  8025a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ad:	0f 85 5c fe ff ff    	jne    80240f <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  8025b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025b8:	c9                   	leave  
  8025b9:	c3                   	ret    

008025ba <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8025ba:	55                   	push   %ebp
  8025bb:	89 e5                	mov    %esp,%ebp
  8025bd:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  8025c0:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  8025c7:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  8025ce:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8025d5:	a1 38 41 80 00       	mov    0x804138,%eax
  8025da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025dd:	e9 cf 00 00 00       	jmp    8026b1 <alloc_block_BF+0xf7>
		{
			c++;
  8025e2:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  8025e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8025eb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025ee:	0f 85 8a 00 00 00    	jne    80267e <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  8025f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f8:	75 17                	jne    802611 <alloc_block_BF+0x57>
  8025fa:	83 ec 04             	sub    $0x4,%esp
  8025fd:	68 ef 3c 80 00       	push   $0x803cef
  802602:	68 a8 00 00 00       	push   $0xa8
  802607:	68 b3 3c 80 00       	push   $0x803cb3
  80260c:	e8 f9 0a 00 00       	call   80310a <_panic>
  802611:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802614:	8b 00                	mov    (%eax),%eax
  802616:	85 c0                	test   %eax,%eax
  802618:	74 10                	je     80262a <alloc_block_BF+0x70>
  80261a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261d:	8b 00                	mov    (%eax),%eax
  80261f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802622:	8b 52 04             	mov    0x4(%edx),%edx
  802625:	89 50 04             	mov    %edx,0x4(%eax)
  802628:	eb 0b                	jmp    802635 <alloc_block_BF+0x7b>
  80262a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262d:	8b 40 04             	mov    0x4(%eax),%eax
  802630:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802638:	8b 40 04             	mov    0x4(%eax),%eax
  80263b:	85 c0                	test   %eax,%eax
  80263d:	74 0f                	je     80264e <alloc_block_BF+0x94>
  80263f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802642:	8b 40 04             	mov    0x4(%eax),%eax
  802645:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802648:	8b 12                	mov    (%edx),%edx
  80264a:	89 10                	mov    %edx,(%eax)
  80264c:	eb 0a                	jmp    802658 <alloc_block_BF+0x9e>
  80264e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802651:	8b 00                	mov    (%eax),%eax
  802653:	a3 38 41 80 00       	mov    %eax,0x804138
  802658:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802661:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802664:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80266b:	a1 44 41 80 00       	mov    0x804144,%eax
  802670:	48                   	dec    %eax
  802671:	a3 44 41 80 00       	mov    %eax,0x804144
				return block;
  802676:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802679:	e9 85 01 00 00       	jmp    802803 <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  80267e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802681:	8b 40 0c             	mov    0xc(%eax),%eax
  802684:	3b 45 08             	cmp    0x8(%ebp),%eax
  802687:	76 20                	jbe    8026a9 <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  802689:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268c:	8b 40 0c             	mov    0xc(%eax),%eax
  80268f:	2b 45 08             	sub    0x8(%ebp),%eax
  802692:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  802695:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802698:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80269b:	73 0c                	jae    8026a9 <alloc_block_BF+0xef>
				{
					ma=tempi;
  80269d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8026a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  8026a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026a6:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8026a9:	a1 40 41 80 00       	mov    0x804140,%eax
  8026ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026b5:	74 07                	je     8026be <alloc_block_BF+0x104>
  8026b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ba:	8b 00                	mov    (%eax),%eax
  8026bc:	eb 05                	jmp    8026c3 <alloc_block_BF+0x109>
  8026be:	b8 00 00 00 00       	mov    $0x0,%eax
  8026c3:	a3 40 41 80 00       	mov    %eax,0x804140
  8026c8:	a1 40 41 80 00       	mov    0x804140,%eax
  8026cd:	85 c0                	test   %eax,%eax
  8026cf:	0f 85 0d ff ff ff    	jne    8025e2 <alloc_block_BF+0x28>
  8026d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026d9:	0f 85 03 ff ff ff    	jne    8025e2 <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  8026df:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8026e6:	a1 38 41 80 00       	mov    0x804138,%eax
  8026eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026ee:	e9 dd 00 00 00       	jmp    8027d0 <alloc_block_BF+0x216>
		{
			if(x==sol)
  8026f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026f6:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8026f9:	0f 85 c6 00 00 00    	jne    8027c5 <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  8026ff:	a1 48 41 80 00       	mov    0x804148,%eax
  802704:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802707:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80270b:	75 17                	jne    802724 <alloc_block_BF+0x16a>
  80270d:	83 ec 04             	sub    $0x4,%esp
  802710:	68 ef 3c 80 00       	push   $0x803cef
  802715:	68 bb 00 00 00       	push   $0xbb
  80271a:	68 b3 3c 80 00       	push   $0x803cb3
  80271f:	e8 e6 09 00 00       	call   80310a <_panic>
  802724:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802727:	8b 00                	mov    (%eax),%eax
  802729:	85 c0                	test   %eax,%eax
  80272b:	74 10                	je     80273d <alloc_block_BF+0x183>
  80272d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802730:	8b 00                	mov    (%eax),%eax
  802732:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802735:	8b 52 04             	mov    0x4(%edx),%edx
  802738:	89 50 04             	mov    %edx,0x4(%eax)
  80273b:	eb 0b                	jmp    802748 <alloc_block_BF+0x18e>
  80273d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802740:	8b 40 04             	mov    0x4(%eax),%eax
  802743:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802748:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80274b:	8b 40 04             	mov    0x4(%eax),%eax
  80274e:	85 c0                	test   %eax,%eax
  802750:	74 0f                	je     802761 <alloc_block_BF+0x1a7>
  802752:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802755:	8b 40 04             	mov    0x4(%eax),%eax
  802758:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80275b:	8b 12                	mov    (%edx),%edx
  80275d:	89 10                	mov    %edx,(%eax)
  80275f:	eb 0a                	jmp    80276b <alloc_block_BF+0x1b1>
  802761:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802764:	8b 00                	mov    (%eax),%eax
  802766:	a3 48 41 80 00       	mov    %eax,0x804148
  80276b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80276e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802774:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802777:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80277e:	a1 54 41 80 00       	mov    0x804154,%eax
  802783:	48                   	dec    %eax
  802784:	a3 54 41 80 00       	mov    %eax,0x804154
						 element1->size =size;
  802789:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80278c:	8b 55 08             	mov    0x8(%ebp),%edx
  80278f:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  802792:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802795:	8b 50 08             	mov    0x8(%eax),%edx
  802798:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80279b:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  80279e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a1:	8b 50 08             	mov    0x8(%eax),%edx
  8027a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a7:	01 c2                	add    %eax,%edx
  8027a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ac:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  8027af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8027b5:	2b 45 08             	sub    0x8(%ebp),%eax
  8027b8:	89 c2                	mov    %eax,%edx
  8027ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bd:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  8027c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027c3:	eb 3e                	jmp    802803 <alloc_block_BF+0x249>
						 break;
			}
			x++;
  8027c5:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8027c8:	a1 40 41 80 00       	mov    0x804140,%eax
  8027cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027d4:	74 07                	je     8027dd <alloc_block_BF+0x223>
  8027d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d9:	8b 00                	mov    (%eax),%eax
  8027db:	eb 05                	jmp    8027e2 <alloc_block_BF+0x228>
  8027dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8027e2:	a3 40 41 80 00       	mov    %eax,0x804140
  8027e7:	a1 40 41 80 00       	mov    0x804140,%eax
  8027ec:	85 c0                	test   %eax,%eax
  8027ee:	0f 85 ff fe ff ff    	jne    8026f3 <alloc_block_BF+0x139>
  8027f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027f8:	0f 85 f5 fe ff ff    	jne    8026f3 <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  8027fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802803:	c9                   	leave  
  802804:	c3                   	ret    

00802805 <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802805:	55                   	push   %ebp
  802806:	89 e5                	mov    %esp,%ebp
  802808:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  80280b:	a1 28 40 80 00       	mov    0x804028,%eax
  802810:	85 c0                	test   %eax,%eax
  802812:	75 14                	jne    802828 <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  802814:	a1 38 41 80 00       	mov    0x804138,%eax
  802819:	a3 5c 41 80 00       	mov    %eax,0x80415c
		hh=1;
  80281e:	c7 05 28 40 80 00 01 	movl   $0x1,0x804028
  802825:	00 00 00 
	}
	uint32 c=1;
  802828:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  80282f:	a1 5c 41 80 00       	mov    0x80415c,%eax
  802834:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802837:	e9 b3 01 00 00       	jmp    8029ef <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  80283c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80283f:	8b 40 0c             	mov    0xc(%eax),%eax
  802842:	3b 45 08             	cmp    0x8(%ebp),%eax
  802845:	0f 85 a9 00 00 00    	jne    8028f4 <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  80284b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80284e:	8b 00                	mov    (%eax),%eax
  802850:	85 c0                	test   %eax,%eax
  802852:	75 0c                	jne    802860 <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  802854:	a1 38 41 80 00       	mov    0x804138,%eax
  802859:	a3 5c 41 80 00       	mov    %eax,0x80415c
  80285e:	eb 0a                	jmp    80286a <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  802860:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802863:	8b 00                	mov    (%eax),%eax
  802865:	a3 5c 41 80 00       	mov    %eax,0x80415c
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  80286a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80286e:	75 17                	jne    802887 <alloc_block_NF+0x82>
  802870:	83 ec 04             	sub    $0x4,%esp
  802873:	68 ef 3c 80 00       	push   $0x803cef
  802878:	68 e3 00 00 00       	push   $0xe3
  80287d:	68 b3 3c 80 00       	push   $0x803cb3
  802882:	e8 83 08 00 00       	call   80310a <_panic>
  802887:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80288a:	8b 00                	mov    (%eax),%eax
  80288c:	85 c0                	test   %eax,%eax
  80288e:	74 10                	je     8028a0 <alloc_block_NF+0x9b>
  802890:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802893:	8b 00                	mov    (%eax),%eax
  802895:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802898:	8b 52 04             	mov    0x4(%edx),%edx
  80289b:	89 50 04             	mov    %edx,0x4(%eax)
  80289e:	eb 0b                	jmp    8028ab <alloc_block_NF+0xa6>
  8028a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a3:	8b 40 04             	mov    0x4(%eax),%eax
  8028a6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ae:	8b 40 04             	mov    0x4(%eax),%eax
  8028b1:	85 c0                	test   %eax,%eax
  8028b3:	74 0f                	je     8028c4 <alloc_block_NF+0xbf>
  8028b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b8:	8b 40 04             	mov    0x4(%eax),%eax
  8028bb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028be:	8b 12                	mov    (%edx),%edx
  8028c0:	89 10                	mov    %edx,(%eax)
  8028c2:	eb 0a                	jmp    8028ce <alloc_block_NF+0xc9>
  8028c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c7:	8b 00                	mov    (%eax),%eax
  8028c9:	a3 38 41 80 00       	mov    %eax,0x804138
  8028ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028e1:	a1 44 41 80 00       	mov    0x804144,%eax
  8028e6:	48                   	dec    %eax
  8028e7:	a3 44 41 80 00       	mov    %eax,0x804144
				return element;
  8028ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ef:	e9 0e 01 00 00       	jmp    802a02 <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  8028f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8028fa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028fd:	0f 86 ce 00 00 00    	jbe    8029d1 <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802903:	a1 48 41 80 00       	mov    0x804148,%eax
  802908:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  80290b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80290f:	75 17                	jne    802928 <alloc_block_NF+0x123>
  802911:	83 ec 04             	sub    $0x4,%esp
  802914:	68 ef 3c 80 00       	push   $0x803cef
  802919:	68 e9 00 00 00       	push   $0xe9
  80291e:	68 b3 3c 80 00       	push   $0x803cb3
  802923:	e8 e2 07 00 00       	call   80310a <_panic>
  802928:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80292b:	8b 00                	mov    (%eax),%eax
  80292d:	85 c0                	test   %eax,%eax
  80292f:	74 10                	je     802941 <alloc_block_NF+0x13c>
  802931:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802934:	8b 00                	mov    (%eax),%eax
  802936:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802939:	8b 52 04             	mov    0x4(%edx),%edx
  80293c:	89 50 04             	mov    %edx,0x4(%eax)
  80293f:	eb 0b                	jmp    80294c <alloc_block_NF+0x147>
  802941:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802944:	8b 40 04             	mov    0x4(%eax),%eax
  802947:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80294c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80294f:	8b 40 04             	mov    0x4(%eax),%eax
  802952:	85 c0                	test   %eax,%eax
  802954:	74 0f                	je     802965 <alloc_block_NF+0x160>
  802956:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802959:	8b 40 04             	mov    0x4(%eax),%eax
  80295c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80295f:	8b 12                	mov    (%edx),%edx
  802961:	89 10                	mov    %edx,(%eax)
  802963:	eb 0a                	jmp    80296f <alloc_block_NF+0x16a>
  802965:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802968:	8b 00                	mov    (%eax),%eax
  80296a:	a3 48 41 80 00       	mov    %eax,0x804148
  80296f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802972:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802978:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80297b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802982:	a1 54 41 80 00       	mov    0x804154,%eax
  802987:	48                   	dec    %eax
  802988:	a3 54 41 80 00       	mov    %eax,0x804154
				 element1->size =size;
  80298d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802990:	8b 55 08             	mov    0x8(%ebp),%edx
  802993:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  802996:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802999:	8b 50 08             	mov    0x8(%eax),%edx
  80299c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80299f:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  8029a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a5:	8b 50 08             	mov    0x8(%eax),%edx
  8029a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ab:	01 c2                	add    %eax,%edx
  8029ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b0:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  8029b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8029b9:	2b 45 08             	sub    0x8(%ebp),%eax
  8029bc:	89 c2                	mov    %eax,%edx
  8029be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c1:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  8029c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c7:	a3 5c 41 80 00       	mov    %eax,0x80415c
				 return element1;
  8029cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029cf:	eb 31                	jmp    802a02 <alloc_block_NF+0x1fd>
			 }
		 c++;
  8029d1:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  8029d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d7:	8b 00                	mov    (%eax),%eax
  8029d9:	85 c0                	test   %eax,%eax
  8029db:	75 0a                	jne    8029e7 <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  8029dd:	a1 38 41 80 00       	mov    0x804138,%eax
  8029e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8029e5:	eb 08                	jmp    8029ef <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  8029e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ea:	8b 00                	mov    (%eax),%eax
  8029ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  8029ef:	a1 44 41 80 00       	mov    0x804144,%eax
  8029f4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8029f7:	0f 85 3f fe ff ff    	jne    80283c <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  8029fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a02:	c9                   	leave  
  802a03:	c3                   	ret    

00802a04 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802a04:	55                   	push   %ebp
  802a05:	89 e5                	mov    %esp,%ebp
  802a07:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  802a0a:	a1 44 41 80 00       	mov    0x804144,%eax
  802a0f:	85 c0                	test   %eax,%eax
  802a11:	75 68                	jne    802a7b <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802a13:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a17:	75 17                	jne    802a30 <insert_sorted_with_merge_freeList+0x2c>
  802a19:	83 ec 04             	sub    $0x4,%esp
  802a1c:	68 90 3c 80 00       	push   $0x803c90
  802a21:	68 0e 01 00 00       	push   $0x10e
  802a26:	68 b3 3c 80 00       	push   $0x803cb3
  802a2b:	e8 da 06 00 00       	call   80310a <_panic>
  802a30:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a36:	8b 45 08             	mov    0x8(%ebp),%eax
  802a39:	89 10                	mov    %edx,(%eax)
  802a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3e:	8b 00                	mov    (%eax),%eax
  802a40:	85 c0                	test   %eax,%eax
  802a42:	74 0d                	je     802a51 <insert_sorted_with_merge_freeList+0x4d>
  802a44:	a1 38 41 80 00       	mov    0x804138,%eax
  802a49:	8b 55 08             	mov    0x8(%ebp),%edx
  802a4c:	89 50 04             	mov    %edx,0x4(%eax)
  802a4f:	eb 08                	jmp    802a59 <insert_sorted_with_merge_freeList+0x55>
  802a51:	8b 45 08             	mov    0x8(%ebp),%eax
  802a54:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a59:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5c:	a3 38 41 80 00       	mov    %eax,0x804138
  802a61:	8b 45 08             	mov    0x8(%ebp),%eax
  802a64:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a6b:	a1 44 41 80 00       	mov    0x804144,%eax
  802a70:	40                   	inc    %eax
  802a71:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802a76:	e9 8c 06 00 00       	jmp    803107 <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  802a7b:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a80:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  802a83:	a1 38 41 80 00       	mov    0x804138,%eax
  802a88:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  802a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8e:	8b 50 08             	mov    0x8(%eax),%edx
  802a91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a94:	8b 40 08             	mov    0x8(%eax),%eax
  802a97:	39 c2                	cmp    %eax,%edx
  802a99:	0f 86 14 01 00 00    	jbe    802bb3 <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  802a9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa2:	8b 50 0c             	mov    0xc(%eax),%edx
  802aa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa8:	8b 40 08             	mov    0x8(%eax),%eax
  802aab:	01 c2                	add    %eax,%edx
  802aad:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab0:	8b 40 08             	mov    0x8(%eax),%eax
  802ab3:	39 c2                	cmp    %eax,%edx
  802ab5:	0f 85 90 00 00 00    	jne    802b4b <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  802abb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802abe:	8b 50 0c             	mov    0xc(%eax),%edx
  802ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac4:	8b 40 0c             	mov    0xc(%eax),%eax
  802ac7:	01 c2                	add    %eax,%edx
  802ac9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802acc:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802acf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  802adc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802ae3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ae7:	75 17                	jne    802b00 <insert_sorted_with_merge_freeList+0xfc>
  802ae9:	83 ec 04             	sub    $0x4,%esp
  802aec:	68 90 3c 80 00       	push   $0x803c90
  802af1:	68 1b 01 00 00       	push   $0x11b
  802af6:	68 b3 3c 80 00       	push   $0x803cb3
  802afb:	e8 0a 06 00 00       	call   80310a <_panic>
  802b00:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b06:	8b 45 08             	mov    0x8(%ebp),%eax
  802b09:	89 10                	mov    %edx,(%eax)
  802b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0e:	8b 00                	mov    (%eax),%eax
  802b10:	85 c0                	test   %eax,%eax
  802b12:	74 0d                	je     802b21 <insert_sorted_with_merge_freeList+0x11d>
  802b14:	a1 48 41 80 00       	mov    0x804148,%eax
  802b19:	8b 55 08             	mov    0x8(%ebp),%edx
  802b1c:	89 50 04             	mov    %edx,0x4(%eax)
  802b1f:	eb 08                	jmp    802b29 <insert_sorted_with_merge_freeList+0x125>
  802b21:	8b 45 08             	mov    0x8(%ebp),%eax
  802b24:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b29:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2c:	a3 48 41 80 00       	mov    %eax,0x804148
  802b31:	8b 45 08             	mov    0x8(%ebp),%eax
  802b34:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b3b:	a1 54 41 80 00       	mov    0x804154,%eax
  802b40:	40                   	inc    %eax
  802b41:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802b46:	e9 bc 05 00 00       	jmp    803107 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802b4b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b4f:	75 17                	jne    802b68 <insert_sorted_with_merge_freeList+0x164>
  802b51:	83 ec 04             	sub    $0x4,%esp
  802b54:	68 cc 3c 80 00       	push   $0x803ccc
  802b59:	68 1f 01 00 00       	push   $0x11f
  802b5e:	68 b3 3c 80 00       	push   $0x803cb3
  802b63:	e8 a2 05 00 00       	call   80310a <_panic>
  802b68:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b71:	89 50 04             	mov    %edx,0x4(%eax)
  802b74:	8b 45 08             	mov    0x8(%ebp),%eax
  802b77:	8b 40 04             	mov    0x4(%eax),%eax
  802b7a:	85 c0                	test   %eax,%eax
  802b7c:	74 0c                	je     802b8a <insert_sorted_with_merge_freeList+0x186>
  802b7e:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b83:	8b 55 08             	mov    0x8(%ebp),%edx
  802b86:	89 10                	mov    %edx,(%eax)
  802b88:	eb 08                	jmp    802b92 <insert_sorted_with_merge_freeList+0x18e>
  802b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8d:	a3 38 41 80 00       	mov    %eax,0x804138
  802b92:	8b 45 08             	mov    0x8(%ebp),%eax
  802b95:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ba3:	a1 44 41 80 00       	mov    0x804144,%eax
  802ba8:	40                   	inc    %eax
  802ba9:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802bae:	e9 54 05 00 00       	jmp    803107 <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  802bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb6:	8b 50 08             	mov    0x8(%eax),%edx
  802bb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bbc:	8b 40 08             	mov    0x8(%eax),%eax
  802bbf:	39 c2                	cmp    %eax,%edx
  802bc1:	0f 83 20 01 00 00    	jae    802ce7 <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  802bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bca:	8b 50 0c             	mov    0xc(%eax),%edx
  802bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd0:	8b 40 08             	mov    0x8(%eax),%eax
  802bd3:	01 c2                	add    %eax,%edx
  802bd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd8:	8b 40 08             	mov    0x8(%eax),%eax
  802bdb:	39 c2                	cmp    %eax,%edx
  802bdd:	0f 85 9c 00 00 00    	jne    802c7f <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  802be3:	8b 45 08             	mov    0x8(%ebp),%eax
  802be6:	8b 50 08             	mov    0x8(%eax),%edx
  802be9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bec:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  802bef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bf2:	8b 50 0c             	mov    0xc(%eax),%edx
  802bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf8:	8b 40 0c             	mov    0xc(%eax),%eax
  802bfb:	01 c2                	add    %eax,%edx
  802bfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c00:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802c03:	8b 45 08             	mov    0x8(%ebp),%eax
  802c06:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c10:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802c17:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c1b:	75 17                	jne    802c34 <insert_sorted_with_merge_freeList+0x230>
  802c1d:	83 ec 04             	sub    $0x4,%esp
  802c20:	68 90 3c 80 00       	push   $0x803c90
  802c25:	68 2a 01 00 00       	push   $0x12a
  802c2a:	68 b3 3c 80 00       	push   $0x803cb3
  802c2f:	e8 d6 04 00 00       	call   80310a <_panic>
  802c34:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3d:	89 10                	mov    %edx,(%eax)
  802c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c42:	8b 00                	mov    (%eax),%eax
  802c44:	85 c0                	test   %eax,%eax
  802c46:	74 0d                	je     802c55 <insert_sorted_with_merge_freeList+0x251>
  802c48:	a1 48 41 80 00       	mov    0x804148,%eax
  802c4d:	8b 55 08             	mov    0x8(%ebp),%edx
  802c50:	89 50 04             	mov    %edx,0x4(%eax)
  802c53:	eb 08                	jmp    802c5d <insert_sorted_with_merge_freeList+0x259>
  802c55:	8b 45 08             	mov    0x8(%ebp),%eax
  802c58:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c60:	a3 48 41 80 00       	mov    %eax,0x804148
  802c65:	8b 45 08             	mov    0x8(%ebp),%eax
  802c68:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c6f:	a1 54 41 80 00       	mov    0x804154,%eax
  802c74:	40                   	inc    %eax
  802c75:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802c7a:	e9 88 04 00 00       	jmp    803107 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802c7f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c83:	75 17                	jne    802c9c <insert_sorted_with_merge_freeList+0x298>
  802c85:	83 ec 04             	sub    $0x4,%esp
  802c88:	68 90 3c 80 00       	push   $0x803c90
  802c8d:	68 2e 01 00 00       	push   $0x12e
  802c92:	68 b3 3c 80 00       	push   $0x803cb3
  802c97:	e8 6e 04 00 00       	call   80310a <_panic>
  802c9c:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca5:	89 10                	mov    %edx,(%eax)
  802ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  802caa:	8b 00                	mov    (%eax),%eax
  802cac:	85 c0                	test   %eax,%eax
  802cae:	74 0d                	je     802cbd <insert_sorted_with_merge_freeList+0x2b9>
  802cb0:	a1 38 41 80 00       	mov    0x804138,%eax
  802cb5:	8b 55 08             	mov    0x8(%ebp),%edx
  802cb8:	89 50 04             	mov    %edx,0x4(%eax)
  802cbb:	eb 08                	jmp    802cc5 <insert_sorted_with_merge_freeList+0x2c1>
  802cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc0:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc8:	a3 38 41 80 00       	mov    %eax,0x804138
  802ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cd7:	a1 44 41 80 00       	mov    0x804144,%eax
  802cdc:	40                   	inc    %eax
  802cdd:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802ce2:	e9 20 04 00 00       	jmp    803107 <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  802ce7:	a1 38 41 80 00       	mov    0x804138,%eax
  802cec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cef:	e9 e2 03 00 00       	jmp    8030d6 <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  802cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf7:	8b 50 08             	mov    0x8(%eax),%edx
  802cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfd:	8b 40 08             	mov    0x8(%eax),%eax
  802d00:	39 c2                	cmp    %eax,%edx
  802d02:	0f 83 c6 03 00 00    	jae    8030ce <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  802d08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0b:	8b 40 04             	mov    0x4(%eax),%eax
  802d0e:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  802d11:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d14:	8b 50 08             	mov    0x8(%eax),%edx
  802d17:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d1a:	8b 40 0c             	mov    0xc(%eax),%eax
  802d1d:	01 d0                	add    %edx,%eax
  802d1f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  802d22:	8b 45 08             	mov    0x8(%ebp),%eax
  802d25:	8b 50 0c             	mov    0xc(%eax),%edx
  802d28:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2b:	8b 40 08             	mov    0x8(%eax),%eax
  802d2e:	01 d0                	add    %edx,%eax
  802d30:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  802d33:	8b 45 08             	mov    0x8(%ebp),%eax
  802d36:	8b 40 08             	mov    0x8(%eax),%eax
  802d39:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802d3c:	74 7a                	je     802db8 <insert_sorted_with_merge_freeList+0x3b4>
  802d3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d41:	8b 40 08             	mov    0x8(%eax),%eax
  802d44:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802d47:	74 6f                	je     802db8 <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  802d49:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d4d:	74 06                	je     802d55 <insert_sorted_with_merge_freeList+0x351>
  802d4f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d53:	75 17                	jne    802d6c <insert_sorted_with_merge_freeList+0x368>
  802d55:	83 ec 04             	sub    $0x4,%esp
  802d58:	68 10 3d 80 00       	push   $0x803d10
  802d5d:	68 43 01 00 00       	push   $0x143
  802d62:	68 b3 3c 80 00       	push   $0x803cb3
  802d67:	e8 9e 03 00 00       	call   80310a <_panic>
  802d6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6f:	8b 50 04             	mov    0x4(%eax),%edx
  802d72:	8b 45 08             	mov    0x8(%ebp),%eax
  802d75:	89 50 04             	mov    %edx,0x4(%eax)
  802d78:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d7e:	89 10                	mov    %edx,(%eax)
  802d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d83:	8b 40 04             	mov    0x4(%eax),%eax
  802d86:	85 c0                	test   %eax,%eax
  802d88:	74 0d                	je     802d97 <insert_sorted_with_merge_freeList+0x393>
  802d8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8d:	8b 40 04             	mov    0x4(%eax),%eax
  802d90:	8b 55 08             	mov    0x8(%ebp),%edx
  802d93:	89 10                	mov    %edx,(%eax)
  802d95:	eb 08                	jmp    802d9f <insert_sorted_with_merge_freeList+0x39b>
  802d97:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9a:	a3 38 41 80 00       	mov    %eax,0x804138
  802d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da2:	8b 55 08             	mov    0x8(%ebp),%edx
  802da5:	89 50 04             	mov    %edx,0x4(%eax)
  802da8:	a1 44 41 80 00       	mov    0x804144,%eax
  802dad:	40                   	inc    %eax
  802dae:	a3 44 41 80 00       	mov    %eax,0x804144
  802db3:	e9 14 03 00 00       	jmp    8030cc <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  802db8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbb:	8b 40 08             	mov    0x8(%eax),%eax
  802dbe:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802dc1:	0f 85 a0 01 00 00    	jne    802f67 <insert_sorted_with_merge_freeList+0x563>
  802dc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dca:	8b 40 08             	mov    0x8(%eax),%eax
  802dcd:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802dd0:	0f 85 91 01 00 00    	jne    802f67 <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  802dd6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dd9:	8b 50 0c             	mov    0xc(%eax),%edx
  802ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddf:	8b 48 0c             	mov    0xc(%eax),%ecx
  802de2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de5:	8b 40 0c             	mov    0xc(%eax),%eax
  802de8:	01 c8                	add    %ecx,%eax
  802dea:	01 c2                	add    %eax,%edx
  802dec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802def:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802df2:	8b 45 08             	mov    0x8(%ebp),%eax
  802df5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dff:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  802e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e09:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  802e10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e13:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802e1a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e1e:	75 17                	jne    802e37 <insert_sorted_with_merge_freeList+0x433>
  802e20:	83 ec 04             	sub    $0x4,%esp
  802e23:	68 90 3c 80 00       	push   $0x803c90
  802e28:	68 4d 01 00 00       	push   $0x14d
  802e2d:	68 b3 3c 80 00       	push   $0x803cb3
  802e32:	e8 d3 02 00 00       	call   80310a <_panic>
  802e37:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e40:	89 10                	mov    %edx,(%eax)
  802e42:	8b 45 08             	mov    0x8(%ebp),%eax
  802e45:	8b 00                	mov    (%eax),%eax
  802e47:	85 c0                	test   %eax,%eax
  802e49:	74 0d                	je     802e58 <insert_sorted_with_merge_freeList+0x454>
  802e4b:	a1 48 41 80 00       	mov    0x804148,%eax
  802e50:	8b 55 08             	mov    0x8(%ebp),%edx
  802e53:	89 50 04             	mov    %edx,0x4(%eax)
  802e56:	eb 08                	jmp    802e60 <insert_sorted_with_merge_freeList+0x45c>
  802e58:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e60:	8b 45 08             	mov    0x8(%ebp),%eax
  802e63:	a3 48 41 80 00       	mov    %eax,0x804148
  802e68:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e72:	a1 54 41 80 00       	mov    0x804154,%eax
  802e77:	40                   	inc    %eax
  802e78:	a3 54 41 80 00       	mov    %eax,0x804154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  802e7d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e81:	75 17                	jne    802e9a <insert_sorted_with_merge_freeList+0x496>
  802e83:	83 ec 04             	sub    $0x4,%esp
  802e86:	68 ef 3c 80 00       	push   $0x803cef
  802e8b:	68 4e 01 00 00       	push   $0x14e
  802e90:	68 b3 3c 80 00       	push   $0x803cb3
  802e95:	e8 70 02 00 00       	call   80310a <_panic>
  802e9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9d:	8b 00                	mov    (%eax),%eax
  802e9f:	85 c0                	test   %eax,%eax
  802ea1:	74 10                	je     802eb3 <insert_sorted_with_merge_freeList+0x4af>
  802ea3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea6:	8b 00                	mov    (%eax),%eax
  802ea8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802eab:	8b 52 04             	mov    0x4(%edx),%edx
  802eae:	89 50 04             	mov    %edx,0x4(%eax)
  802eb1:	eb 0b                	jmp    802ebe <insert_sorted_with_merge_freeList+0x4ba>
  802eb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb6:	8b 40 04             	mov    0x4(%eax),%eax
  802eb9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ebe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec1:	8b 40 04             	mov    0x4(%eax),%eax
  802ec4:	85 c0                	test   %eax,%eax
  802ec6:	74 0f                	je     802ed7 <insert_sorted_with_merge_freeList+0x4d3>
  802ec8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecb:	8b 40 04             	mov    0x4(%eax),%eax
  802ece:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ed1:	8b 12                	mov    (%edx),%edx
  802ed3:	89 10                	mov    %edx,(%eax)
  802ed5:	eb 0a                	jmp    802ee1 <insert_sorted_with_merge_freeList+0x4dd>
  802ed7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eda:	8b 00                	mov    (%eax),%eax
  802edc:	a3 38 41 80 00       	mov    %eax,0x804138
  802ee1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ef4:	a1 44 41 80 00       	mov    0x804144,%eax
  802ef9:	48                   	dec    %eax
  802efa:	a3 44 41 80 00       	mov    %eax,0x804144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  802eff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f03:	75 17                	jne    802f1c <insert_sorted_with_merge_freeList+0x518>
  802f05:	83 ec 04             	sub    $0x4,%esp
  802f08:	68 90 3c 80 00       	push   $0x803c90
  802f0d:	68 4f 01 00 00       	push   $0x14f
  802f12:	68 b3 3c 80 00       	push   $0x803cb3
  802f17:	e8 ee 01 00 00       	call   80310a <_panic>
  802f1c:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f25:	89 10                	mov    %edx,(%eax)
  802f27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2a:	8b 00                	mov    (%eax),%eax
  802f2c:	85 c0                	test   %eax,%eax
  802f2e:	74 0d                	je     802f3d <insert_sorted_with_merge_freeList+0x539>
  802f30:	a1 48 41 80 00       	mov    0x804148,%eax
  802f35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f38:	89 50 04             	mov    %edx,0x4(%eax)
  802f3b:	eb 08                	jmp    802f45 <insert_sorted_with_merge_freeList+0x541>
  802f3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f40:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f48:	a3 48 41 80 00       	mov    %eax,0x804148
  802f4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f50:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f57:	a1 54 41 80 00       	mov    0x804154,%eax
  802f5c:	40                   	inc    %eax
  802f5d:	a3 54 41 80 00       	mov    %eax,0x804154
  802f62:	e9 65 01 00 00       	jmp    8030cc <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  802f67:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6a:	8b 40 08             	mov    0x8(%eax),%eax
  802f6d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802f70:	0f 85 9f 00 00 00    	jne    803015 <insert_sorted_with_merge_freeList+0x611>
  802f76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f79:	8b 40 08             	mov    0x8(%eax),%eax
  802f7c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802f7f:	0f 84 90 00 00 00    	je     803015 <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  802f85:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f88:	8b 50 0c             	mov    0xc(%eax),%edx
  802f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8e:	8b 40 0c             	mov    0xc(%eax),%eax
  802f91:	01 c2                	add    %eax,%edx
  802f93:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f96:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802f99:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802fad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fb1:	75 17                	jne    802fca <insert_sorted_with_merge_freeList+0x5c6>
  802fb3:	83 ec 04             	sub    $0x4,%esp
  802fb6:	68 90 3c 80 00       	push   $0x803c90
  802fbb:	68 58 01 00 00       	push   $0x158
  802fc0:	68 b3 3c 80 00       	push   $0x803cb3
  802fc5:	e8 40 01 00 00       	call   80310a <_panic>
  802fca:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd3:	89 10                	mov    %edx,(%eax)
  802fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd8:	8b 00                	mov    (%eax),%eax
  802fda:	85 c0                	test   %eax,%eax
  802fdc:	74 0d                	je     802feb <insert_sorted_with_merge_freeList+0x5e7>
  802fde:	a1 48 41 80 00       	mov    0x804148,%eax
  802fe3:	8b 55 08             	mov    0x8(%ebp),%edx
  802fe6:	89 50 04             	mov    %edx,0x4(%eax)
  802fe9:	eb 08                	jmp    802ff3 <insert_sorted_with_merge_freeList+0x5ef>
  802feb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fee:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff6:	a3 48 41 80 00       	mov    %eax,0x804148
  802ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803005:	a1 54 41 80 00       	mov    0x804154,%eax
  80300a:	40                   	inc    %eax
  80300b:	a3 54 41 80 00       	mov    %eax,0x804154
  803010:	e9 b7 00 00 00       	jmp    8030cc <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  803015:	8b 45 08             	mov    0x8(%ebp),%eax
  803018:	8b 40 08             	mov    0x8(%eax),%eax
  80301b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80301e:	0f 84 e2 00 00 00    	je     803106 <insert_sorted_with_merge_freeList+0x702>
  803024:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803027:	8b 40 08             	mov    0x8(%eax),%eax
  80302a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80302d:	0f 85 d3 00 00 00    	jne    803106 <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  803033:	8b 45 08             	mov    0x8(%ebp),%eax
  803036:	8b 50 08             	mov    0x8(%eax),%edx
  803039:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303c:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  80303f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803042:	8b 50 0c             	mov    0xc(%eax),%edx
  803045:	8b 45 08             	mov    0x8(%ebp),%eax
  803048:	8b 40 0c             	mov    0xc(%eax),%eax
  80304b:	01 c2                	add    %eax,%edx
  80304d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803050:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  803053:	8b 45 08             	mov    0x8(%ebp),%eax
  803056:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  80305d:	8b 45 08             	mov    0x8(%ebp),%eax
  803060:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803067:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80306b:	75 17                	jne    803084 <insert_sorted_with_merge_freeList+0x680>
  80306d:	83 ec 04             	sub    $0x4,%esp
  803070:	68 90 3c 80 00       	push   $0x803c90
  803075:	68 61 01 00 00       	push   $0x161
  80307a:	68 b3 3c 80 00       	push   $0x803cb3
  80307f:	e8 86 00 00 00       	call   80310a <_panic>
  803084:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80308a:	8b 45 08             	mov    0x8(%ebp),%eax
  80308d:	89 10                	mov    %edx,(%eax)
  80308f:	8b 45 08             	mov    0x8(%ebp),%eax
  803092:	8b 00                	mov    (%eax),%eax
  803094:	85 c0                	test   %eax,%eax
  803096:	74 0d                	je     8030a5 <insert_sorted_with_merge_freeList+0x6a1>
  803098:	a1 48 41 80 00       	mov    0x804148,%eax
  80309d:	8b 55 08             	mov    0x8(%ebp),%edx
  8030a0:	89 50 04             	mov    %edx,0x4(%eax)
  8030a3:	eb 08                	jmp    8030ad <insert_sorted_with_merge_freeList+0x6a9>
  8030a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8030ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b0:	a3 48 41 80 00       	mov    %eax,0x804148
  8030b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030bf:	a1 54 41 80 00       	mov    0x804154,%eax
  8030c4:	40                   	inc    %eax
  8030c5:	a3 54 41 80 00       	mov    %eax,0x804154
								}
								break;
  8030ca:	eb 3a                	jmp    803106 <insert_sorted_with_merge_freeList+0x702>
  8030cc:	eb 38                	jmp    803106 <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  8030ce:	a1 40 41 80 00       	mov    0x804140,%eax
  8030d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030da:	74 07                	je     8030e3 <insert_sorted_with_merge_freeList+0x6df>
  8030dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030df:	8b 00                	mov    (%eax),%eax
  8030e1:	eb 05                	jmp    8030e8 <insert_sorted_with_merge_freeList+0x6e4>
  8030e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8030e8:	a3 40 41 80 00       	mov    %eax,0x804140
  8030ed:	a1 40 41 80 00       	mov    0x804140,%eax
  8030f2:	85 c0                	test   %eax,%eax
  8030f4:	0f 85 fa fb ff ff    	jne    802cf4 <insert_sorted_with_merge_freeList+0x2f0>
  8030fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030fe:	0f 85 f0 fb ff ff    	jne    802cf4 <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  803104:	eb 01                	jmp    803107 <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  803106:	90                   	nop
							}

						}
		          }
		}
}
  803107:	90                   	nop
  803108:	c9                   	leave  
  803109:	c3                   	ret    

0080310a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80310a:	55                   	push   %ebp
  80310b:	89 e5                	mov    %esp,%ebp
  80310d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803110:	8d 45 10             	lea    0x10(%ebp),%eax
  803113:	83 c0 04             	add    $0x4,%eax
  803116:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803119:	a1 60 41 80 00       	mov    0x804160,%eax
  80311e:	85 c0                	test   %eax,%eax
  803120:	74 16                	je     803138 <_panic+0x2e>
		cprintf("%s: ", argv0);
  803122:	a1 60 41 80 00       	mov    0x804160,%eax
  803127:	83 ec 08             	sub    $0x8,%esp
  80312a:	50                   	push   %eax
  80312b:	68 48 3d 80 00       	push   $0x803d48
  803130:	e8 ed d4 ff ff       	call   800622 <cprintf>
  803135:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803138:	a1 00 40 80 00       	mov    0x804000,%eax
  80313d:	ff 75 0c             	pushl  0xc(%ebp)
  803140:	ff 75 08             	pushl  0x8(%ebp)
  803143:	50                   	push   %eax
  803144:	68 4d 3d 80 00       	push   $0x803d4d
  803149:	e8 d4 d4 ff ff       	call   800622 <cprintf>
  80314e:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803151:	8b 45 10             	mov    0x10(%ebp),%eax
  803154:	83 ec 08             	sub    $0x8,%esp
  803157:	ff 75 f4             	pushl  -0xc(%ebp)
  80315a:	50                   	push   %eax
  80315b:	e8 57 d4 ff ff       	call   8005b7 <vcprintf>
  803160:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  803163:	83 ec 08             	sub    $0x8,%esp
  803166:	6a 00                	push   $0x0
  803168:	68 69 3d 80 00       	push   $0x803d69
  80316d:	e8 45 d4 ff ff       	call   8005b7 <vcprintf>
  803172:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803175:	e8 c6 d3 ff ff       	call   800540 <exit>

	// should not return here
	while (1) ;
  80317a:	eb fe                	jmp    80317a <_panic+0x70>

0080317c <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80317c:	55                   	push   %ebp
  80317d:	89 e5                	mov    %esp,%ebp
  80317f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  803182:	a1 20 40 80 00       	mov    0x804020,%eax
  803187:	8b 50 74             	mov    0x74(%eax),%edx
  80318a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80318d:	39 c2                	cmp    %eax,%edx
  80318f:	74 14                	je     8031a5 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  803191:	83 ec 04             	sub    $0x4,%esp
  803194:	68 6c 3d 80 00       	push   $0x803d6c
  803199:	6a 26                	push   $0x26
  80319b:	68 b8 3d 80 00       	push   $0x803db8
  8031a0:	e8 65 ff ff ff       	call   80310a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8031a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8031ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8031b3:	e9 c2 00 00 00       	jmp    80327a <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8031b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031bb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8031c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c5:	01 d0                	add    %edx,%eax
  8031c7:	8b 00                	mov    (%eax),%eax
  8031c9:	85 c0                	test   %eax,%eax
  8031cb:	75 08                	jne    8031d5 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8031cd:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8031d0:	e9 a2 00 00 00       	jmp    803277 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8031d5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8031dc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8031e3:	eb 69                	jmp    80324e <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8031e5:	a1 20 40 80 00       	mov    0x804020,%eax
  8031ea:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8031f0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8031f3:	89 d0                	mov    %edx,%eax
  8031f5:	01 c0                	add    %eax,%eax
  8031f7:	01 d0                	add    %edx,%eax
  8031f9:	c1 e0 03             	shl    $0x3,%eax
  8031fc:	01 c8                	add    %ecx,%eax
  8031fe:	8a 40 04             	mov    0x4(%eax),%al
  803201:	84 c0                	test   %al,%al
  803203:	75 46                	jne    80324b <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803205:	a1 20 40 80 00       	mov    0x804020,%eax
  80320a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803210:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803213:	89 d0                	mov    %edx,%eax
  803215:	01 c0                	add    %eax,%eax
  803217:	01 d0                	add    %edx,%eax
  803219:	c1 e0 03             	shl    $0x3,%eax
  80321c:	01 c8                	add    %ecx,%eax
  80321e:	8b 00                	mov    (%eax),%eax
  803220:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803223:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803226:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80322b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80322d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803230:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803237:	8b 45 08             	mov    0x8(%ebp),%eax
  80323a:	01 c8                	add    %ecx,%eax
  80323c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80323e:	39 c2                	cmp    %eax,%edx
  803240:	75 09                	jne    80324b <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  803242:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803249:	eb 12                	jmp    80325d <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80324b:	ff 45 e8             	incl   -0x18(%ebp)
  80324e:	a1 20 40 80 00       	mov    0x804020,%eax
  803253:	8b 50 74             	mov    0x74(%eax),%edx
  803256:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803259:	39 c2                	cmp    %eax,%edx
  80325b:	77 88                	ja     8031e5 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80325d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803261:	75 14                	jne    803277 <CheckWSWithoutLastIndex+0xfb>
			panic(
  803263:	83 ec 04             	sub    $0x4,%esp
  803266:	68 c4 3d 80 00       	push   $0x803dc4
  80326b:	6a 3a                	push   $0x3a
  80326d:	68 b8 3d 80 00       	push   $0x803db8
  803272:	e8 93 fe ff ff       	call   80310a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803277:	ff 45 f0             	incl   -0x10(%ebp)
  80327a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80327d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803280:	0f 8c 32 ff ff ff    	jl     8031b8 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803286:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80328d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803294:	eb 26                	jmp    8032bc <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803296:	a1 20 40 80 00       	mov    0x804020,%eax
  80329b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8032a1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8032a4:	89 d0                	mov    %edx,%eax
  8032a6:	01 c0                	add    %eax,%eax
  8032a8:	01 d0                	add    %edx,%eax
  8032aa:	c1 e0 03             	shl    $0x3,%eax
  8032ad:	01 c8                	add    %ecx,%eax
  8032af:	8a 40 04             	mov    0x4(%eax),%al
  8032b2:	3c 01                	cmp    $0x1,%al
  8032b4:	75 03                	jne    8032b9 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8032b6:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8032b9:	ff 45 e0             	incl   -0x20(%ebp)
  8032bc:	a1 20 40 80 00       	mov    0x804020,%eax
  8032c1:	8b 50 74             	mov    0x74(%eax),%edx
  8032c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032c7:	39 c2                	cmp    %eax,%edx
  8032c9:	77 cb                	ja     803296 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8032cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ce:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8032d1:	74 14                	je     8032e7 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8032d3:	83 ec 04             	sub    $0x4,%esp
  8032d6:	68 18 3e 80 00       	push   $0x803e18
  8032db:	6a 44                	push   $0x44
  8032dd:	68 b8 3d 80 00       	push   $0x803db8
  8032e2:	e8 23 fe ff ff       	call   80310a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8032e7:	90                   	nop
  8032e8:	c9                   	leave  
  8032e9:	c3                   	ret    
  8032ea:	66 90                	xchg   %ax,%ax

008032ec <__udivdi3>:
  8032ec:	55                   	push   %ebp
  8032ed:	57                   	push   %edi
  8032ee:	56                   	push   %esi
  8032ef:	53                   	push   %ebx
  8032f0:	83 ec 1c             	sub    $0x1c,%esp
  8032f3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8032f7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8032fb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8032ff:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803303:	89 ca                	mov    %ecx,%edx
  803305:	89 f8                	mov    %edi,%eax
  803307:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80330b:	85 f6                	test   %esi,%esi
  80330d:	75 2d                	jne    80333c <__udivdi3+0x50>
  80330f:	39 cf                	cmp    %ecx,%edi
  803311:	77 65                	ja     803378 <__udivdi3+0x8c>
  803313:	89 fd                	mov    %edi,%ebp
  803315:	85 ff                	test   %edi,%edi
  803317:	75 0b                	jne    803324 <__udivdi3+0x38>
  803319:	b8 01 00 00 00       	mov    $0x1,%eax
  80331e:	31 d2                	xor    %edx,%edx
  803320:	f7 f7                	div    %edi
  803322:	89 c5                	mov    %eax,%ebp
  803324:	31 d2                	xor    %edx,%edx
  803326:	89 c8                	mov    %ecx,%eax
  803328:	f7 f5                	div    %ebp
  80332a:	89 c1                	mov    %eax,%ecx
  80332c:	89 d8                	mov    %ebx,%eax
  80332e:	f7 f5                	div    %ebp
  803330:	89 cf                	mov    %ecx,%edi
  803332:	89 fa                	mov    %edi,%edx
  803334:	83 c4 1c             	add    $0x1c,%esp
  803337:	5b                   	pop    %ebx
  803338:	5e                   	pop    %esi
  803339:	5f                   	pop    %edi
  80333a:	5d                   	pop    %ebp
  80333b:	c3                   	ret    
  80333c:	39 ce                	cmp    %ecx,%esi
  80333e:	77 28                	ja     803368 <__udivdi3+0x7c>
  803340:	0f bd fe             	bsr    %esi,%edi
  803343:	83 f7 1f             	xor    $0x1f,%edi
  803346:	75 40                	jne    803388 <__udivdi3+0x9c>
  803348:	39 ce                	cmp    %ecx,%esi
  80334a:	72 0a                	jb     803356 <__udivdi3+0x6a>
  80334c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803350:	0f 87 9e 00 00 00    	ja     8033f4 <__udivdi3+0x108>
  803356:	b8 01 00 00 00       	mov    $0x1,%eax
  80335b:	89 fa                	mov    %edi,%edx
  80335d:	83 c4 1c             	add    $0x1c,%esp
  803360:	5b                   	pop    %ebx
  803361:	5e                   	pop    %esi
  803362:	5f                   	pop    %edi
  803363:	5d                   	pop    %ebp
  803364:	c3                   	ret    
  803365:	8d 76 00             	lea    0x0(%esi),%esi
  803368:	31 ff                	xor    %edi,%edi
  80336a:	31 c0                	xor    %eax,%eax
  80336c:	89 fa                	mov    %edi,%edx
  80336e:	83 c4 1c             	add    $0x1c,%esp
  803371:	5b                   	pop    %ebx
  803372:	5e                   	pop    %esi
  803373:	5f                   	pop    %edi
  803374:	5d                   	pop    %ebp
  803375:	c3                   	ret    
  803376:	66 90                	xchg   %ax,%ax
  803378:	89 d8                	mov    %ebx,%eax
  80337a:	f7 f7                	div    %edi
  80337c:	31 ff                	xor    %edi,%edi
  80337e:	89 fa                	mov    %edi,%edx
  803380:	83 c4 1c             	add    $0x1c,%esp
  803383:	5b                   	pop    %ebx
  803384:	5e                   	pop    %esi
  803385:	5f                   	pop    %edi
  803386:	5d                   	pop    %ebp
  803387:	c3                   	ret    
  803388:	bd 20 00 00 00       	mov    $0x20,%ebp
  80338d:	89 eb                	mov    %ebp,%ebx
  80338f:	29 fb                	sub    %edi,%ebx
  803391:	89 f9                	mov    %edi,%ecx
  803393:	d3 e6                	shl    %cl,%esi
  803395:	89 c5                	mov    %eax,%ebp
  803397:	88 d9                	mov    %bl,%cl
  803399:	d3 ed                	shr    %cl,%ebp
  80339b:	89 e9                	mov    %ebp,%ecx
  80339d:	09 f1                	or     %esi,%ecx
  80339f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8033a3:	89 f9                	mov    %edi,%ecx
  8033a5:	d3 e0                	shl    %cl,%eax
  8033a7:	89 c5                	mov    %eax,%ebp
  8033a9:	89 d6                	mov    %edx,%esi
  8033ab:	88 d9                	mov    %bl,%cl
  8033ad:	d3 ee                	shr    %cl,%esi
  8033af:	89 f9                	mov    %edi,%ecx
  8033b1:	d3 e2                	shl    %cl,%edx
  8033b3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8033b7:	88 d9                	mov    %bl,%cl
  8033b9:	d3 e8                	shr    %cl,%eax
  8033bb:	09 c2                	or     %eax,%edx
  8033bd:	89 d0                	mov    %edx,%eax
  8033bf:	89 f2                	mov    %esi,%edx
  8033c1:	f7 74 24 0c          	divl   0xc(%esp)
  8033c5:	89 d6                	mov    %edx,%esi
  8033c7:	89 c3                	mov    %eax,%ebx
  8033c9:	f7 e5                	mul    %ebp
  8033cb:	39 d6                	cmp    %edx,%esi
  8033cd:	72 19                	jb     8033e8 <__udivdi3+0xfc>
  8033cf:	74 0b                	je     8033dc <__udivdi3+0xf0>
  8033d1:	89 d8                	mov    %ebx,%eax
  8033d3:	31 ff                	xor    %edi,%edi
  8033d5:	e9 58 ff ff ff       	jmp    803332 <__udivdi3+0x46>
  8033da:	66 90                	xchg   %ax,%ax
  8033dc:	8b 54 24 08          	mov    0x8(%esp),%edx
  8033e0:	89 f9                	mov    %edi,%ecx
  8033e2:	d3 e2                	shl    %cl,%edx
  8033e4:	39 c2                	cmp    %eax,%edx
  8033e6:	73 e9                	jae    8033d1 <__udivdi3+0xe5>
  8033e8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8033eb:	31 ff                	xor    %edi,%edi
  8033ed:	e9 40 ff ff ff       	jmp    803332 <__udivdi3+0x46>
  8033f2:	66 90                	xchg   %ax,%ax
  8033f4:	31 c0                	xor    %eax,%eax
  8033f6:	e9 37 ff ff ff       	jmp    803332 <__udivdi3+0x46>
  8033fb:	90                   	nop

008033fc <__umoddi3>:
  8033fc:	55                   	push   %ebp
  8033fd:	57                   	push   %edi
  8033fe:	56                   	push   %esi
  8033ff:	53                   	push   %ebx
  803400:	83 ec 1c             	sub    $0x1c,%esp
  803403:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803407:	8b 74 24 34          	mov    0x34(%esp),%esi
  80340b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80340f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803413:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803417:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80341b:	89 f3                	mov    %esi,%ebx
  80341d:	89 fa                	mov    %edi,%edx
  80341f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803423:	89 34 24             	mov    %esi,(%esp)
  803426:	85 c0                	test   %eax,%eax
  803428:	75 1a                	jne    803444 <__umoddi3+0x48>
  80342a:	39 f7                	cmp    %esi,%edi
  80342c:	0f 86 a2 00 00 00    	jbe    8034d4 <__umoddi3+0xd8>
  803432:	89 c8                	mov    %ecx,%eax
  803434:	89 f2                	mov    %esi,%edx
  803436:	f7 f7                	div    %edi
  803438:	89 d0                	mov    %edx,%eax
  80343a:	31 d2                	xor    %edx,%edx
  80343c:	83 c4 1c             	add    $0x1c,%esp
  80343f:	5b                   	pop    %ebx
  803440:	5e                   	pop    %esi
  803441:	5f                   	pop    %edi
  803442:	5d                   	pop    %ebp
  803443:	c3                   	ret    
  803444:	39 f0                	cmp    %esi,%eax
  803446:	0f 87 ac 00 00 00    	ja     8034f8 <__umoddi3+0xfc>
  80344c:	0f bd e8             	bsr    %eax,%ebp
  80344f:	83 f5 1f             	xor    $0x1f,%ebp
  803452:	0f 84 ac 00 00 00    	je     803504 <__umoddi3+0x108>
  803458:	bf 20 00 00 00       	mov    $0x20,%edi
  80345d:	29 ef                	sub    %ebp,%edi
  80345f:	89 fe                	mov    %edi,%esi
  803461:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803465:	89 e9                	mov    %ebp,%ecx
  803467:	d3 e0                	shl    %cl,%eax
  803469:	89 d7                	mov    %edx,%edi
  80346b:	89 f1                	mov    %esi,%ecx
  80346d:	d3 ef                	shr    %cl,%edi
  80346f:	09 c7                	or     %eax,%edi
  803471:	89 e9                	mov    %ebp,%ecx
  803473:	d3 e2                	shl    %cl,%edx
  803475:	89 14 24             	mov    %edx,(%esp)
  803478:	89 d8                	mov    %ebx,%eax
  80347a:	d3 e0                	shl    %cl,%eax
  80347c:	89 c2                	mov    %eax,%edx
  80347e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803482:	d3 e0                	shl    %cl,%eax
  803484:	89 44 24 04          	mov    %eax,0x4(%esp)
  803488:	8b 44 24 08          	mov    0x8(%esp),%eax
  80348c:	89 f1                	mov    %esi,%ecx
  80348e:	d3 e8                	shr    %cl,%eax
  803490:	09 d0                	or     %edx,%eax
  803492:	d3 eb                	shr    %cl,%ebx
  803494:	89 da                	mov    %ebx,%edx
  803496:	f7 f7                	div    %edi
  803498:	89 d3                	mov    %edx,%ebx
  80349a:	f7 24 24             	mull   (%esp)
  80349d:	89 c6                	mov    %eax,%esi
  80349f:	89 d1                	mov    %edx,%ecx
  8034a1:	39 d3                	cmp    %edx,%ebx
  8034a3:	0f 82 87 00 00 00    	jb     803530 <__umoddi3+0x134>
  8034a9:	0f 84 91 00 00 00    	je     803540 <__umoddi3+0x144>
  8034af:	8b 54 24 04          	mov    0x4(%esp),%edx
  8034b3:	29 f2                	sub    %esi,%edx
  8034b5:	19 cb                	sbb    %ecx,%ebx
  8034b7:	89 d8                	mov    %ebx,%eax
  8034b9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8034bd:	d3 e0                	shl    %cl,%eax
  8034bf:	89 e9                	mov    %ebp,%ecx
  8034c1:	d3 ea                	shr    %cl,%edx
  8034c3:	09 d0                	or     %edx,%eax
  8034c5:	89 e9                	mov    %ebp,%ecx
  8034c7:	d3 eb                	shr    %cl,%ebx
  8034c9:	89 da                	mov    %ebx,%edx
  8034cb:	83 c4 1c             	add    $0x1c,%esp
  8034ce:	5b                   	pop    %ebx
  8034cf:	5e                   	pop    %esi
  8034d0:	5f                   	pop    %edi
  8034d1:	5d                   	pop    %ebp
  8034d2:	c3                   	ret    
  8034d3:	90                   	nop
  8034d4:	89 fd                	mov    %edi,%ebp
  8034d6:	85 ff                	test   %edi,%edi
  8034d8:	75 0b                	jne    8034e5 <__umoddi3+0xe9>
  8034da:	b8 01 00 00 00       	mov    $0x1,%eax
  8034df:	31 d2                	xor    %edx,%edx
  8034e1:	f7 f7                	div    %edi
  8034e3:	89 c5                	mov    %eax,%ebp
  8034e5:	89 f0                	mov    %esi,%eax
  8034e7:	31 d2                	xor    %edx,%edx
  8034e9:	f7 f5                	div    %ebp
  8034eb:	89 c8                	mov    %ecx,%eax
  8034ed:	f7 f5                	div    %ebp
  8034ef:	89 d0                	mov    %edx,%eax
  8034f1:	e9 44 ff ff ff       	jmp    80343a <__umoddi3+0x3e>
  8034f6:	66 90                	xchg   %ax,%ax
  8034f8:	89 c8                	mov    %ecx,%eax
  8034fa:	89 f2                	mov    %esi,%edx
  8034fc:	83 c4 1c             	add    $0x1c,%esp
  8034ff:	5b                   	pop    %ebx
  803500:	5e                   	pop    %esi
  803501:	5f                   	pop    %edi
  803502:	5d                   	pop    %ebp
  803503:	c3                   	ret    
  803504:	3b 04 24             	cmp    (%esp),%eax
  803507:	72 06                	jb     80350f <__umoddi3+0x113>
  803509:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80350d:	77 0f                	ja     80351e <__umoddi3+0x122>
  80350f:	89 f2                	mov    %esi,%edx
  803511:	29 f9                	sub    %edi,%ecx
  803513:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803517:	89 14 24             	mov    %edx,(%esp)
  80351a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80351e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803522:	8b 14 24             	mov    (%esp),%edx
  803525:	83 c4 1c             	add    $0x1c,%esp
  803528:	5b                   	pop    %ebx
  803529:	5e                   	pop    %esi
  80352a:	5f                   	pop    %edi
  80352b:	5d                   	pop    %ebp
  80352c:	c3                   	ret    
  80352d:	8d 76 00             	lea    0x0(%esi),%esi
  803530:	2b 04 24             	sub    (%esp),%eax
  803533:	19 fa                	sbb    %edi,%edx
  803535:	89 d1                	mov    %edx,%ecx
  803537:	89 c6                	mov    %eax,%esi
  803539:	e9 71 ff ff ff       	jmp    8034af <__umoddi3+0xb3>
  80353e:	66 90                	xchg   %ax,%ax
  803540:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803544:	72 ea                	jb     803530 <__umoddi3+0x134>
  803546:	89 d9                	mov    %ebx,%ecx
  803548:	e9 62 ff ff ff       	jmp    8034af <__umoddi3+0xb3>

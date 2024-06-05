![image](https://github.com/lielocks/WIL/assets/107406265/c545b2ce-2b1f-4d51-b292-95976d34bb01)

컴퓨터는 베이스로 **CPU 와 메모리** 로 구성되어 있다.

Input - 컴퓨터로 들어가는 데이터

Output - 다시 컴퓨터에서 장치로 돌아가는 데이터

메모리라는 건 CPU 의 작업 공간이다.

**CPU 에서 매 클럭 cycle 마다 메모리에서 Instruction 기계어를 하나씩 읽어서 실행** 하게 된다.

IO 디바이스는 별개의 장치들 

DISK 는 I/O 두 기능을 다한다.

이 I/O 디바이스들은 이 디바이스들을 전담하는 작은 CPU 들이 붙어있다.

그걸 **Device Controller** 라고 한다.

Disk 의 내부를 통제하는건 (헤더를 어떻게 움직일지 ..) Disk Controller 가 한다.

<br>

CPU 안에는 메모리보다 빠른 **Register** 가 있다.

**`modebit`** - CPU 에서 실행되는게 OS 인지 사용자 program 인지 구분해준다.

*CPU 는 하나의 instruction 을 수행하고 나면 Interrupt 에 들어온게 있는지 확인한다.*

**`TIMER`** - 처음에는 OS 가 CPU 를 가지고 있다가 사용자 프로그램이 실행되면 CPU 를 넘겨주는데 넘겨주기 전에 Timer 에 값을 세팅하고 넘겨준다.

<br>

사용자 프로그램의 instruction 이 이 Timer 에 할당된 시간(1초도 안되는 ms)을 넘으면 CPU 에 Interrupt 를 건다.

Interrupt 를 걸면 Interrupt Line 에 들어가고, CPU 는 사용자 프로그램에서 다시 OS 로 넘어가게 된다.

<br>

한 프로그램이 CPU 를 사용하다가 I/O 작업을 해야되면 CPU 를 OS 에 넘겨준다. (System Call)

사용자 프로그램은 I/O 작업을 직접할 수 없고, OS 를 통해서만 하게 되어있다. (보안적 문제로)

OS 가 해당하는 작업을 I/O Controller 에게 시킨다.

근데 이 작업은 오래 걸리니까, 요청한 프로그램 말고 다른 프로그램에게 CPU 를 넘겨준다. 

I/O 요청했던 프로그램은 언제 다시 CPU 를 받냐 하면 I/O Controller 가 요청한 작업이 끝나서,

자신의 local buffer 에 들어오게 되면 Controller 가 CPU 에게 Interrupt 를 건다.

<br>

Interrupt 가 들어오면 CPU 제어권이 실행중인 프로그램에서 OS 에 돌아오게 된다.

그럼 CPU 가 들어온 값을 보고, OS 는 Input 으로 들어온 값을 요청했던 프로그램 메모리에 넣어주고 방금전에 Interrupt 된 프로그램에 다시 제어권을 주고 그 친구의 시간이 끝나면 
Round Robin 으로 돌리면서 Input 요청을 받아 준비가 완료된 프로그램에 다시 제어권을 주게 된다.


![image](https://github.com/lielocks/WIL/assets/107406265/46ad6d48-9185-478b-a751-ce9845492057)

0 일때? OS 가 CPU 에서 쓰일 때 Kernel Mode 라고 한다.

1 일때? User Mode

Modebit 의 역할은? 0 일때는 메모리 접근 뿐만 아니라 I/O 디바이스 접근 instruction 도 사용 가능하다.

1 일때는 제한된 instruction 만 사용할 수 있게 된다.

보호와 보안의 목적으로 나눠져있다.

![image](https://github.com/lielocks/WIL/assets/107406265/5e6bf86a-6570-4e18-bfad-175e2af27bf2)

특정 프로그램이 독점하는 것을 방지하기 위해 있다.

Timer 값이 0이되면 프로그램의 권한을 뺏을 수 있다.

![image](https://github.com/lielocks/WIL/assets/107406265/88dd5f4a-f163-4cb9-a07a-8a9a9a47fa7c)

I/O 디바이스를 접근하는 작은 CPU 라고 보면 된다.

일종의 data register 인 local buffer 를 가진다.

<br>

**DMA(Direct Memory Access) Controller**

![image](https://github.com/lielocks/WIL/assets/107406265/b6e17738-f623-492d-a230-30fb481c81ba)

직접 메모리를 접근할 수 있는 Controller 이다.

원래는 메모리에 접근할 수 있는 장치는 CPU 뿐이었는데 DMA 도 접근할 수 있게 되어있다.

![image](https://github.com/lielocks/WIL/assets/107406265/ca3f3d53-4205-4f3d-a1b2-4bb17ba6abef)

I/O 장치가 너무 자주 Interrupt 를 거니까 CPU 가 너무 멈추게 된다.

DMA 역할은 I/O 작업들의 요청이 들어왔을때, I/O 의 local buffer data 를 메모리에 옮기는 일을 CPU 가 하기에는 손해가 크다.

DMA 가 이 데이터를 메모리에 복사하는 역할을 한다.

![image](https://github.com/lielocks/WIL/assets/107406265/29e83141-f11f-4098-a3b6-ab001666fc37)

사용자 프로그램이 직접 I/O 를 못하고 OS 를 통해서만 할 수 있다.

파일을 읽어와야 할때 어떻게 할지, OS 에 부탁을 해야하는 등을 System Call 이라고 한다.

사용자 프로그램이 OS 에 I/O 요청을 하는 것이고 소프트웨어적으로 Interrupt Line 을 건다.

![image](https://github.com/lielocks/WIL/assets/107406265/dc0cb86f-3580-4788-9867-f6db45345c48)

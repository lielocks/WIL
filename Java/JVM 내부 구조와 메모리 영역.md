JVM (Java Virtual Machine)은 Java 언어에서만 사용하는 것이 아니다.

Kotlin, Scala 언어에서도 JVM 동작 방식을 그대로 따른다.

따라서 JVM 을 정확히 이해하면 추후에 Java 에서 파생된 모던 언어를 이해하는데 있어 수월해지며, 내부에서 정확히 어떻게 동작을 해서 코드가 실행이 되는지 개념을 알면 코드 최적화나 리팩토링을 하는데 매우 도움이 된다.

![image](https://github.com/lielocks/WIL/assets/107406265/e3d0d8cf-705c-45f6-b99f-a2b4e77bddce)

위의 그림은 Java application 의 구동원리를 간략하게 그려본 것인데, 
지금부터 우리가 배울 **JVM (자바 가상 머신)** 실행 부분은 빨간 박스를 친 부분인, compile 된 **.class 파일을 어떠한 처리를 거쳐 program 을 실행** 하는 과정이다.


<br>


## 자바 가상 머신 (JVM) 의 동작 방식

자바 가상 머신(Java Virtual Machine) 인 JVM 의 역할은 Java application 을 _Class Loader 를 통해 읽어 Java API 와 함께 실행_ 하는 것이다.

다음은 _Java source 파일을 어떤 동작으로 코드를 읽는지에 대한_ 간단한 요약 도식이다.

![image](https://github.com/lielocks/WIL/assets/107406265/590f154c-fd5d-4846-abcb-bd7b6dce7c79)

1. Java Program 을 실행하면 JVM 은 OS 로부터 Memory 를 할당받는다.

2. **Java Compiler (javac)** 가 **`Java source code (.java)` 를 `Java byte code (.class)` 로** compile 한다.

3. **Class Loader** 는 동적 loading 을 통해 필요한 Class 들을 loading 및 link 하여 **Runtime Data Area (실질적인 Memory 를 할당 받아 관리하는 영역)** 에 올린다.

4. **Runtime Data Area** 에 로딩된 byte code 는 **Execution Engine** 을 통해 _해석_ 된다.

5. 이 과정에서 **Execution Engine** 에 의해 **Garbage Collector 의 작동** 과 **Thread 동기화** 가 이루어진다.


<br>


## 자바 가상 머신 (JVM) 의 구조

JVM 동작 방식을 간략하게 알아봤으니 이제 구성 요소를 상세히 알아보자.

다음은 위에서 다뤄본 JVM 동작 과정 중 **Class Loader ↔ Execution Engine ↔ Runtime Data Area** 부분을 좀더 상세화한 도식이다.

![image](https://github.com/lielocks/WIL/assets/107406265/0bd47d9c-04a1-4848-b46e-4b4c75f422b5)

이처럼 JVM 은 아래와 같이 구성되어 있다.

+ **클래스 로더 (Class Loader)**

+ **실행 엔진 (Execution Engine)**

  + 인터프리터 (Interpreter)
  + JIT 컴파일러 (JIT Compiler)
  + 가비지 컬렉터 (Garbage Collector)
 
+ **런타임 데이터 영역 (Runtime Data Area)**

  + Method 영역
  + Heap 영역 
  + PC Register
  + Stack 영역
  + Native Method Stack
 
+ **JNI 네이티브 메소드 인터페이스 (Native Method Interface)**

+ **네이티브 메서드 라이브러리 (Native Method Library)**


<br>


### 클래스 로더 Class Loader

![image](https://github.com/lielocks/WIL/assets/107406265/90909d94-b2ab-45bd-9432-797910bf12bd)

**클래스 로더** 는 **`JVM 내로 클래스 파일(*.class) 을 동적으로 load`** 하고, **`Link 를 통해 배치하는 작업`** 을 수행하는 모듈이다.

즉, 로드된 **byte code(.class) 들을 엮어서 `JVM 의 Memory 영역인 Runtime Data Areas` 에 배치** 한다.

Class 를 Memory 에 올리는 loading 기능은 한번에 Memory 에 올리지 않고, Application 에서 필요한 경우 동적으로 Memory 에 적재하게 된다.

Class 파일의 loading 순서는 다음과 같이 3단계로 구성된다. **Loading -> Linking -> Initialization**

![image](https://github.com/lielocks/WIL/assets/107406265/820e967f-be0c-44a2-925b-f175528641a5)

<br>

1. ***Loading (로드)*** : Class 파일을 가져와서 JVM 의 **Memory 에 load** 한다.

2. ***Linking (링크)*** : Class 파일을 사용하기 위해 **검증** 하는 과정이다.

   1. ***Verifying (검증)*** : 읽어들인 Class 가 JVM 명세에 명시된 대로 구성되어 있는지 검사한다.

   2. ***Preparing (준비)*** : Class 가 필요로 하는 Memory 를 할당한다.

   3. ***Resolving (분석)*** : Class 의 상수 pool 내 모든 symbolic reference 를 direct reference 로 변경한다.

3. ***Initialization (초기화)*** : Class 변수들을 **적절한 값으로 초기화** 한다. (static 필드들을 설정된 값으로 초기화 등)


<br>


### 실행 엔진 Execution Engine

실행 엔진은 Class Loader 를 통해 `Runtime Data Area 에 배치된 byte code` 를 **명령어 단위로 읽어서 실행** 한다.

Java byte code(*.class) 는 기계가 바로 수행할 수 있는 언어보다는 virtual machine 이 이해할 수 있는 **중간 레벨로 compile 된 code** 이다.

그래서 Execution Engine 은 이와 같은 byte code 를 실제로 JVM 내부에서 *기계가 실행할 수 있는 형태로 변경* 해준다.

이 수행 과정에서 실행 엔진은 **인터프리터** 와 **JIT 컴파일러** 두가지 방식을 혼합하여 byte code 를 실행한다.

![image](https://github.com/lielocks/WIL/assets/107406265/cd6a2e48-2d49-423b-ba87-315089e2f07e)

<br>

+ **인터프리터 (Interpreter)**

Byte code 명령어를 **하나씩 읽어서 해석하고 바로 실행** 한다.

_JVM 안에서 byte code_ 는 `기본적으로 Interpreter 방식으로 동작` 한다.

다만 같은 method 라도 _여러번 호출이 된다면 매번 해석하고 수행해야 돼서 전체적인 속도는 느리다._


<br>


+ **JIT 컴파일러 (Just-In-Time Compiler)**

위의 Interpreter 의 단점을 보완하기 위해 도입된 방식으로 

반복되는 코드를 발견하여 **byte code 전체를 Compile 하여 Native Code 로 변경** 하고 이후에는 해당 method 를 더 이상 interpreting 하지 않고 `caching` 해두었다가 **Native code 로 직접 실행** 하는 방식이다.

하나씩 interpreting 하여 실행하는 것이 아니라, compile 된 Native code 를 실행하는 것이기 때문에 전체적인 실행 속도는 interpreting 방식보다 빠르다.

하지만 byte code 를 Native Code 로 변환하는 데에도 비용이 소요되므로, JVM 은 모든 코드를 JIT Compiler 방식으로 실행하지 않고 **Interpreter 방식을 사용하다 일정 기준이 넘어가면 JIT Compile 방식** 으로 명령어를 실행하는 식으로 진행한다.


> **Native code** 란, JAVA 에서 부모가 되는  C언어나, C++, 어셈블리어로 구성된 코드를 의미한다.


<br>


+ **가비지 컬렉터 (Garbage Collector)**

![image](https://github.com/lielocks/WIL/assets/107406265/b0b8979d-5f89-4694-bc99-e646a31bf073)

JVM 은 **가비지 컬렉터 (garbage collector)** 를 이용하여 **`Heap Memory 영역에서 더는 사용하지 않는 Memory 를 자동으로 회수`** 해준다.

C언어 같은 경우 직접 개발자가 메모리를 해제해줘야 되지만, JAVA 는 이 Garbage Collector 를 이용해 자동으로 Memory 를 실시간 최적화 시켜준다.

따라서 개발자가 따로 Memory 를 관리하지 않아도 되므로, 더욱 손쉽게 programming 할 수 있도록 해준다.

일반적으로 자동으로 실행되지만, 단 GC 가 실행되는 시간은 정해져 있지 않다.

특히 Full GC 가 발생하는 경우, _GC 를 제외한 모든 thread 가 중지되기 때문에_ 장애가 발생할 수 있다.


> _수동으로 GC 를 실행하기위해 System.gc()_ 라는 메소드를 사용할수 있지만, _함수 실제 실행은 보장되지는 않는다._


<br>


### 런타임 데이터 영역 Runtime Data Area

![image](https://github.com/lielocks/WIL/assets/107406265/267e4c2a-4580-4f53-af2e-689e1714b37f)

**Runtime Data Area** 는 쉽게 말하면 **`JVM 의 Memory 영역`** 으로 **Java application 을 실행할 때 사용되는 데이터들을 적재** 하는 영역이다.

런타임 데이터 영역은 위 그림과 같이 크게 Method Area, Heap Area, Stack Area, PC Register, Native Method Stack 로 나눌 수 있다.

![image](https://github.com/lielocks/WIL/assets/107406265/db9940bc-fafa-466b-87e1-250eb2c4880b)

이때 **`Method Area, Heap Area`** 는 **모든 Thread 가 공유** 하는 영역이고, 나머지 **`Stack Area, PC Register, Native Method Stack`** 은 **각 Thread 마다 생성되는 개별 영역** 이다.

따라서 위의 그림을 좀더 자세히 표현하자면 다음과 같은 도식이 된다.

![image](https://github.com/lielocks/WIL/assets/107406265/46ba6347-fa43-4920-b838-0a1c06006e23)


<br>


+ **메서드 영역 Method Area**

**Method 영역** 은 *JVM 이 시작될 때 생성되는 공간* 으로 **byte code(.class)** 를 처음 Memory 공간에 올릴 때 **초기화되는 대상을 저장** 하기 위한 Memory 공간이다.

JVM 이 동작하고 Class 가 load 될 때 적재돼서 **Program 이 종료될 때까지 저장** 된다.


> **메서드 영역(Method Area) 은 `Class Area` 나 `Static Area` 로도 불리운다.**


<br>


모든 **Thread 가 공유** 하는 영역이라 다음과 같이 _초기화 코드 정보들_ 이 저장되게 된다.

+ ***Field Info*** : 멤버 변수의 이름, 데이터 타입, 접근 제어자의 정보

+ ***Method Info*** : Method 이름, return 타입, 함수 매개변수, 접근 제어자의 정보

+ ***Type Info*** : Class 인지 Interface 인지 여부 저장, Type 의 속성, 이름 Super Class 의 이름


<br>


![image](https://github.com/lielocks/WIL/assets/107406265/6e0cd71c-c088-4265-983b-c4ea26bf05a2)

간단히 말하자면 Method 영역에는 **Static Field** 와 **Class 구조만** 을 갖고 있다고 할수있다.
			

> **※ Method Area / Runtime Constant Pool 의 사용기간 및 Thread 공유 범위 ※**
> 
> - JVM 시작시 생성
>   
> - Program 종료 시까지
>   
> - 명시적으로 null 선언 시


<br>


**[Runtime Constant Pool]**

![image](https://github.com/lielocks/WIL/assets/107406265/70026cdb-7aad-4187-8aac-ff05c2c87d43)

![image](https://github.com/lielocks/WIL/assets/107406265/9230d746-5393-4b96-9fce-326e51d8cae0)

- Method 영역에 존재하는 별도의 관리영역
   
- *각 Class / Interface 마다 별도의 Constant Pool table* 이 존재하는데, **Class 생성할때 참조해야할 정보들을 constant 로** 가지고 있는 영역이다.

- JVM 은 이 Constant Pool 을 통해 해당 method 나 field 의 실제 Memory 상 address 를 찾아 참조한다.
   
- 정리하면 **Constant 자료형을 저장하여 참조하고 중복을 막는 역할** 을 수행한다.


<br>


> ***참고 : 선언 위치에 따른 변수의 종류***
>
> ![image](https://github.com/lielocks/WIL/assets/107406265/99ca9c1d-4541-4543-9756-8e386757eca7)


<br>


+ **힙 영역 Heap Area**

Heap 영역은 Method 영역와 함께 모든 Thread 가 공유하며, JVM 이 관리하는 Program 상에서 데이터를 저장하기 위해 Runtime 시 동적으로 할당하여 사용하는 영역이다.

즉, **new 연산자로 생성되는 Class 와 Instance 변수, Array 타입 등 Reference Type이 저장** 되는 곳이다.

당연히 **`Method Area 영역에 저장된 Class 만이 생성이 되어 적재된다.`** (당연한 소리이긴 하다)

![image](https://github.com/lielocks/WIL/assets/107406265/185b405d-d42f-4960-9916-a7d7b80c8926)


> **※ Heap 영역의 사용기간 및 Thread 공유 범위 ※**
>  
> - 객체가 더 이상 사용되지 않거나 명시적으로 null 선언 시
>   
> - GC(Garbage Collection) 대상


유의할점은 Heap 영역에 생성된 객체와 배열은 **Reference Type** 으로서, _JVM Stack 영역의 변수나 다른 객체의 field 에서 참조된다_ 는 점이다.

즉, Heap 의 참조 주소는 "Stack" 이 갖고 있고, 해당 객체를 통해서만 Heap 영역에 있는 Instance 를 핸들링할 수 있는 것이다.

![image](https://github.com/lielocks/WIL/assets/107406265/8b05ea51-cb6d-43e7-8bb7-89b71a0f673c)

만일 참조하는 변수나 필드가 없다면 의미 없는 객체가 되기 때문에 이것을 쓰레기로 취급하고 JVM 은 쓰레기 수집기인 **Garbage Collector** 를 실행시켜 쓰레기 객체를 Heap 영역에서 자동으로 제거된다.
 
이처럼 Heap 영역은 `Garbage Collection 에 대상이 되는 공간` 이다.

그리고 효율적인 Garbage Collection 을 수행하기 위해서 세부적으로 다음과 같이 5가지 영역으로 나뉘게 된다.

![image](https://github.com/lielocks/WIL/assets/107406265/e0d6ec65-a0ac-4cf4-a557-578e09f78d7d)


<br>


이렇게 다섯가지 영역(Eden, survivor 0, survivor 1, Old, Permanent)으로 나뉜 Heap 영역은 다시 물리적으로 **Young Generation** 과 **Old Generation** 영역으로 구분되게 되는데 다음과 같다.

+ ***Young Generation*** : 생명 주기가 짧은 객체를 GC 대상으로 하는 영역
  
  + ***Eden*** : `new` 를 통해 새로 생성된 객체가 위치. 정기적인 쓰레기 수집 후 살아남은 객체들은 Survivor로 이동
    
  + ***Survivor 0 / Survivor 1*** : 각 영역이 채워지게 되면, 살아남은 객체는 비워진 Survivor 로 순차적으로 이동

+ ***Old Generation*** : 생명 주기가 긴 객체를 GC 대상으로 하는 영역. Young Generation 에서 마지막까지 살아남은 객체가 이동


<br>


### 스택 영역 Stack Area

Stack 영역은 `int, long, boolean 등 기본 자료형` 을 생성할 때 저장하는 공간으로, **임시적으로 사용되는 변수나 정보들이 저장되는 영역** 이다.

![image](https://github.com/lielocks/WIL/assets/107406265/ed932664-058e-4894-ac7a-56c9a2fed077)

자료구조 Stack 은 마지막에 들어온 값이 먼저 나가는 LIFO  구조로 push 와 pop 기능 사용방식으로 동작한다.

Method 호출 시마다 각각의 **Stack Frame(그 method 만을 위한 공간)** 이 생성되고 
_Method 안에서 사용되는 값들_ 을 저장하고, _호출된 Method 의 매개변수, 지역변수, return 값 및 연산 시 일어나는 값들_ 을 임시로 저장한다.

그리고 Method 수행이 끝나면 frame 별로 삭제된다.


<br>

   

> **[스택 프레임 (Stack Frame)]**
>
> Method 가 호출될때마다 frame 이 만들어지며, 현재 실행 중인 Method 상태 정보를 저장하는 곳이다.
> 
> Method 호출 범위가 종료되면 Stack 에서 제거된다.
>
> Stack Frame 에 쌓이는 데이터는 `Method 의 매개변수, 지역변수, return 값, 연산시 결과값` 등이 있다.


<br>


단, 데이터의 타입에 따라 Stack 과 Heap 에 저장되는 방식이 다르다는 점은 유의해야 한다.

+ `기본 원시(Primitive) type 변수` 는 **Stack** 영역에 **직접** 값을 가진다.

+ `참조 type 변수` 는 **Heap** 영역이나 **Method** 영역의 **객체 주소** 를 가진다.


<br>



> ***원시 타입, 참조 타입***
>
> **[원시 타입]**
>
> ![image](https://github.com/lielocks/WIL/assets/107406265/f24e9a10-78d0-414d-bc5a-0f216fb07c1c)
>
> **[참조 타입]**
>
> 참조 타입은 기본 타입을 제외한 타입으로, **객체의 주소** 를 저장하는 타입이다.
>
> `문자열, array, 열거형 상수 Enum constants, class, interface` 등이 있다.
>
> Java 에서 실제 객체는 JVM Heap 영역에 저장되며, 참조 타입 변수는 실제 객체의 주소를 JVM Stack 영역에 저장한다.
>
> ***그리고 객체를 사용할 때마다 참조 변수에 저장된 객체의 주소를 불러와 사용하게 된다.***
>
> Person p = new Person(); 이라는 코드를 작성했다면 p 라는 이름의 memory 공간이 Stack 영역에 생성되고, 생성된 p 의 Instance 는 Heap 영역에 생성된다.
>
> 즉, **Stack 영역에 생성된 참조 변수 p** 는 **Heap 영역에 생성된 p 의 Instance 주소 값** 을 가지게 된다.
>
> ![image](https://github.com/lielocks/WIL/assets/107406265/9273dd93-db1d-4502-86be-8efbe51e096e)
>
> **`Primitive type`** 은 `Stack 영역` 에 존재한다.
> 
> 반면 **`Reference type`** 은 Stack 영역에는 **참조 값만** 있고, **실제 값** 은 **`Heap 영역`** 에 존재한다.
> 
> `Reference type` 은 최소 2번 Memory 접근을 해야 하고, 일부 타입의 경우 값을 필요로 할 때 `UnBoxing 과정` (ex. Double → double, Integer → int)을 거쳐야 하므로 Primitive type 과 비교해서 _접근 속도가 느린 편_ 이다.


<br>


예를 들어 `Person p = new Person();` 와 같이 Class 를 생성할 경우,

**`new 에 의해 생성된 Class`** 는 **Heap Area 에 저장** 되고, **Stack Area** 에는 **`생성된 클래스의 참조인 p` 만 저장** 된다.

![image](https://github.com/lielocks/WIL/assets/107406265/43acb671-cc89-4d8b-b4ab-909bd9a108a0)

Stack 영역은 각 Thread 마다 하나씩 존재하며, Thread 가 시작될 때 할당된다.

Process 가 Memory 에 load 될 때 Stack size 가 고정되어 있어, Runtime 시에 Stack size 를 바꿀 수는 없다.

만일 고정된 크기의 JVM Stack 에서 Program 실행 중 Memory 크기가 충분하지 않다면 StackOverFlowError가 발생하게 된다.

Thread 를 종료하면 Runtime Stack 도 사라진다.

![image](https://github.com/lielocks/WIL/assets/107406265/7c16ea4b-b833-4f60-9ed7-d657e796e38d)

여기까지 배운 Method 영역, Heap 영역, Thread 영역을 한 그림으로 표시하자면 다음과 같이 도식이 그려지게 된다.

![image](https://github.com/lielocks/WIL/assets/107406265/38b8fa50-ad5d-4917-9399-df45d2f6f9fe)

<br>

### PC Register Program Counter Register

**PC Register** 는 Thread 가 시작될 때, **현재 수행중인 JVM 명령어 주소를 저장** 하는 공간이다.

JVM 명령의 주소는 Thread 가 어떤 부분을 무슨 명령으로 실행해야 할 지에 대한 기록을 가지고 있다.

일반적으로 Program 의 실행은 **CPU 에서 명령어(Instruction)를 수행** 하는 과정으로 이루어진다.

이때 CPU 는 _연산을 수행하는 동안 필요한 정보_ 를 **`register 라고 하는 CPU 내의 기억장치`** 를 이용하게 된다.

예를 들어, `A 와 B 라는 데이터` 와 `피연산 값인 Operand` 가 있고 이를 더하라는 `연산 Instruction` 이 있다고 하자.

A 와 B, 그리고 더하라는 연산이 순차적으로 진행이 되게 되는데, 이때 A 를 받고 B 를 받는 동안 이 값을 CPU 가 어딘가에 기억해 두어야 할 필요가 생긴다.

이 공간이 바로 **CPU 내의 기억장치 `Register`** 이다.

![image](https://github.com/lielocks/WIL/assets/107406265/9a3f8841-62e6-4c08-bfa6-9bad22b0d11c)

하지만 **Java 의 PC Register** 는 위의 `CPU Register` 와 다르다.

자바는 OS 나 CPU 의 입장에서는 하나의 Process 이기 때문에 JVM 의 resource 를 이용해야 한다.

그래서 Java 는 *CPU 에 직접 연산을 수행하도록 하는 것이 아닌,* **`현재 작업하는 내용을 CPU 에게 연산으로 제공`** 해야 하며, **`이를 위한 buffer 공간`** 으로 **PC Register 라는 Memory 영역** 을 만들게 된 것이다 !

따라서 JVM 은 *Stack 에서 비연산값 Operand 를 뽑아* 별도의 Memory 공간인 PC Register 에 저장하는 방식을 취한다.

![image](https://github.com/lielocks/WIL/assets/107406265/98ac5c16-bd31-4840-ba35-3a52af3d3bd8)

만약에 Thread 가 Java method 를 수행하고 있으면 JVM 명령(Instruction) 의 주소를 PC Register 에 저장한다. 

그러다 만약 Java 가 아닌 다른 언어 (C언어, 어셈블리) 의 Method 를 수행하고 있다면, undefined 상태가 된다.

왜냐하면 Java 에서는 이 두 경우를 따로 처리하기 때문이다.

이 부분이 바로 뒤에 언급하게 될 Native Method Stack 공간이다.


<br>


### 네이티브 메서드 스택 (Native Method Stack)

**네이티브 메서드 스택** 는 Java code 가 compile 되어 생성되는 byte code 가 아닌 실제 실행할 수 있는 **기계어로 작성된 프로그램을 실행** 시키는 영역이다.

또한 **자바 이외의 언어(C, C++, 어셈블리 등)로 작성된 네이티브 코드를 실행**하기 위한 공간이기도 하다.

사용되는 Memory 영역으로 일반적인 C 스택을 사용한다.

위에서 배운 **JIT 컴파일러** 에 의해 변환된 Native Code 역시 여기에서 실행이 된다고 보면 된다.

![image](https://github.com/lielocks/WIL/assets/107406265/76acca76-7e0e-4c26-b237-31d8065db010)


<br>


_일반적으로 Method 를 실행하는 경우 JVM Stack 에 쌓이다가_ 해당 Method 내부에 Native 방식을 사용하는 Method 가 있다면 해당 Method 는 Native Stack 에 쌓인다.

그리고 Native Method 가 수행이 끝나면 다시 Java Stack 으로 돌아와 다시 작업을 수행한다.

그래서 Native code 로 되어 있는 함수의 호출을 Java program 내에서도 직접 수행할 수 있고 그 결과를 받아올 수도 있는 것이다.

Native Method Stack 은 바로 다음에 배울 **네이티브 메소드 인터페이스 (JNI)** 와 연결되어 있는데, JNI 가 사용되면 Native Method Stack 에 byte code 로 전환되어 저장되게 된다.


<br>


### JNI (Java Native Interface)

**JNI** 는 Java 가 다른 언어로 만들어진 application 과 상호 작용할 수 있는 인터페이스를 제공하는 프로그램이다.

위에서 다뤄봤듯이, JNI 는 JVM 이 Native Method 를 적재하고 수행할 수 있도록 한다.

하지만 실질적으로 제대로 동작하는 언어는 C / C++ 정도 밖에 없다고 한다.

![image](https://github.com/lielocks/WIL/assets/107406265/a3a7a78e-4602-4c72-ad18-0006d105ae66)


<br>


### Native Method Library

C, C++로 작성된 library 를 칭한다.

만일 header 가 필요하면 JNI 는 이 library 를 loading 해 실행한다.

![image](https://github.com/lielocks/WIL/assets/107406265/c30655f3-c70d-4dc4-a47e-a3c7913e6702)


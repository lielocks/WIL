JVM(자바 가상 머신)은 자바 언어에서만 사용하는 것이 아니다. 
코틀린, 스칼라 언어에서도 JVM 동작 방식을 그대로 따른다.

따라서 JVM을 정확히 이해하면 추후에 자바에서 파생된 모던 언어를 이해하는데 있어 수월해지며, 내부에서 정확히 어떻게 동작을 해서 코드가 실행이 되는지 개념을 알면 코드 최적화나 리팩토링을 하는데 매우 도움이 된다.

![image](https://github.com/lielocks/WIL/assets/107406265/e3d0d8cf-705c-45f6-b99f-a2b4e77bddce)

위의 그림은 자바 애플리케이션의 구동원리를 간략하게 그려본 것인데, 
지금부터 우리가 배울 **JVM(자바 가상 머신)** 실행 부분은 빨간 박스를 친 부분인, 컴파일된 **.class 파일을 어떠한 처리를 거쳐 프로그램을 실행** 하는 과정이다.

<br>

## 자바 가상 머신 (JVM) 의 동작 방식

자바 가상 머신(Java Virtual Machine)인 JVM의 역할은 자바 어플리케이션을 클래스 로더를 통해 읽어 자바 API 와 함께 실행하는 것이다.

다음은 자바 소스 파일을 어떤 동작으로 코드를 읽는지에 대한 **간단한 요약 도식** 이다.

![image](https://github.com/lielocks/WIL/assets/107406265/590f154c-fd5d-4846-abcb-bd7b6dce7c79)

1. 자바 프로그램을 실행하면 JVM 은 OS 로부터 메모리를 할당받는다.

2. 자바 컴파일러 (javac) 가 자바 소스코드 (.java) 를 자바 바이트 코드 (.class) 로 컴파일한다.

3. **Class Loader** 는 동적 로딩을 통해 필요한 클래스들을 로딩 및 링크하여 **Runtime Data Area (실질적인 메모리를 할당 받아 관리하는 영역)** 에 올린다.

4. **Runtime Data Area** 에 로딩 된 바이트 코드는 **Execution Engine** 을 통해 해석된다.

5. 이 과정에서 **Execution Engine** 에 의해 **Garbage Collector** 의 작동과 **Thread** 동기화가 이루어진다.


<br>


## 자바 가상 머신 (JVM) 의 구조

JVM 동작 방식을 간략하게 알아봤으니 이제 구성 요소를 상세히 알아보자.
다음은 위에서 다뤄본 JVM 동작 과정 중 **Class Loader ↔ Execution Engine ↔ Runtime Data Area** 부분을 좀더 상세화 한 도식이다.

![image](https://github.com/lielocks/WIL/assets/107406265/0bd47d9c-04a1-4848-b46e-4b4c75f422b5)

이처럼 JVM 은 아래와 같이 구성되어 있다.

+ **클래스 로더 (Class Loader)**

+ **실행 엔진 (Execution Engine)**
  + 인터프리터 (Interpreter)
  + JIT 컴파일러 (JIT Compiler)
  + 가비지 컬렉터 (Garbage Collector)
 
+ **런타임 데이터 영역 (Runtime Data Area)**
  + 메소드 영역 Method Area
  + Heap 영역 
  + PC Register
  + Stack 영역
  + Native Method Stack
 
+ **JNI 네이티브 메소드 인터페이스 (Native Method Interface)**

+ **네이티브 메서드 라이브러리 (Native Method Library)**

<br>

### 클래스 로더 Class Loader

![image](https://github.com/lielocks/WIL/assets/107406265/90909d94-b2ab-45bd-9432-797910bf12bd)

**클래스 로더** 는 **`JVM 내로 클래스 파일(*.class) 을 동적으로 로드`** 하고, **`링크를 통해 배치하는 작업`** 을 수행하는 모듈이다.

즉, 로드된 **바이트 코드(.class)들을 엮어서 JVM의 메모리 영역인 Runtime Data Areas 에 배치** 한다.

클래스를 메모리에 올리는 로딩 기능은 한번에 메모리에 올리지 않고, 어플리케이션에서 필요한 경우 동적으로 메모리에 적재하게 된다.

클래스 파일의 로딩 순서는 다음과 같이 3단계로 구성된다. (Loading -> Linking -> Initialization)

![image](https://github.com/lielocks/WIL/assets/107406265/820e967f-be0c-44a2-925b-f175528641a5)

<br>

1. ***Loading (로드)*** : 클래스 파일을 가져와서 JVM 의 **메모리에 로드** 한다.

2. ***Linking (링크)*** : 클래스 파일을 사용하기 위해 **검증** 하는 과정이다.

   1. ***Verifying (검증)*** : 읽어들인 클래스가 JVM 명세에 명시된 대로 구성되어 있는지 검사한다.

   2. ***Preparing (준비)*** : 클래스가 필요로 하는 메모리를 할당한다.

   3. ***Resolving (분석)*** : 클래스의 상수 풀 내 모든 symbolic reference 를 direct reference 로 변경한다.

4. ***Initialization (초기화)*** : 클래스 변수들을 **적절한 값으로 초기화** 한다. (static 필드들을 설정된 값으로 초기화 등)


<br>


### 실행 엔진 Execution Engine

실행 엔진은 클래스 로더를 통해 런타임 데이터 영역에 배치된 **바이트 코드를 명령어 단위로 읽어서 실행** 한다.

자바 바이트 코드(*.class) 는 기계가 바로 수행할 수 있는 언어보다는 가상머신이 이해할 수 있는 중간 레벨로 컴파일 된 코드이다.

그래서 실행 엔진은 이와 같은 바이트 코드를 실제로 JVM 내부에서 기계가 실행할 수 있는 형태로 변경해준다.

이 수행 과정에서 실행 엔진은 **인터프리터** 와 **JIT 컴파일러** 두가지 방식을 혼합하여 바이트 코드를 실행한다.

![image](https://github.com/lielocks/WIL/assets/107406265/cd6a2e48-2d49-423b-ba87-315089e2f07e)

<br>

+ **인터프리터 (Interpreter)**

바이트 코드 **명령어를 하나씩 읽어서 해석하고 바로 실행** 한다.

JVM 안에서 바이트코드는 기본적으로 인터프리터 방식으로 동작한다.
다만 같은 메소드라도 여러번 호출이 된다면 매번 해석하고 수행해야 돼서 전체적인 속도는 느리다.

<br>

+ **JIT 컴파일러 (Just-In-Time Compiler)**

위의 Interpreter 의 단점을 보완하기 위해 도입된 방식으로 반복되는 코드를 발견하여 **바이트 코드 전체를 컴파일하여 Native Code 로 변경** 하고 이후에는 해당 
메서드를 더 이상 인터프리팅 하지 않고 캐싱해 두었다가 **네이티브 코드로 직접 실행** 하는 방식이다.

하나씩 인터프리팅하여 실행하는 것이 아니라, 컴파일된 네이티브 코드를 실행하는 것이기 때문에 전체적인 실행 속도는 인터프리팅 방식보다 빠르다.

하지만 바이트코드를 Native Code 로 변환하는 데에도 비용이 소요되므로, JVM 은 모든 코드를 JIT 컴파일러 방식으로 실행하지 않고 인터프리터 방식을 사용하다 일정 기준이 넘어가면 JIT 컴파일 방식으로 명령어를 실행하는 식으로 진행한다.

>
> **네이티브 코드** 란, JAVA 에서 부모가 되는  C언어나, C++, 어셈블리어로 구성된 코드를 의미한다.
>

<br>

+ **가비지 컬렉터 (Garbage Collector)**

![image](https://github.com/lielocks/WIL/assets/107406265/b0b8979d-5f89-4694-bc99-e646a31bf073)

자바 가상 머신은 **가비지 컬렉터 (garbage collector)** 를 이용하여 **`Heap 메모리 영역에서 더는 사용하지 않는 메모리를 자동으로 회수`** 해준다.

C언어 같은 경우 직접 개발자가 메모리를 해제해줘야 되지만, JAVA는 이 가비지 컬렉터를 이용해 자동으로 메모리를 실시간 최적화 시켜준다. 따라서 개발자가 따로 메모리를 관리하지 않아도 되므로, 더욱 손쉽게 프로그래밍을 할 수 있도록 해준다.

일반적으로 자동으로 실행되지만, 단 GC(가비지 컬렉터) 가 실행되는 시간은 정해져 있지 않다.

특히 Full GC 가 발생하는 경우, GC 를 제외한 모든 스레드가 중지되기 때문에 장애가 발생할 수 있다.

>
> 수동으로 GC(가비지 컬렉터)를 실행하기위해 System.gc() 라는 메소드를 사용할수 있지만, 함수 실제 실행은 보장되지는 않는다.
>

<br>

### 런타임 데이터 영역 Runtime Data Area

![image](https://github.com/lielocks/WIL/assets/107406265/267e4c2a-4580-4f53-af2e-689e1714b37f)

**런타입 데이터 영역** 은 쉽게 말하면 **JVM의 메모리 영역** 으로 **`자바 애플리케이션을 실행할 때 사용되는 데이터들을 적재`** 하는 영역이다.

런타임 데이터 영역은 위 그림과 같이 크게 Method Area, Heap Area, Stack Area, PC Register, Native Method Stack로 나눌 수 있다.

![image](https://github.com/lielocks/WIL/assets/107406265/db9940bc-fafa-466b-87e1-250eb2c4880b)

이때 **`Method Area, Heap Area`** 는 **모든 쓰레드 (Thread) 가 공유** 하는 영역이고, 나머지 **`Stack Area, PC Register, Native Method Stack`** 은 **각 thread 마다 생성되는 개별 영역** 이다.

따라서 위의 그림을 좀더 자세히 표현하자면 다음과 같은 도식이 된다.

![image](https://github.com/lielocks/WIL/assets/107406265/46ba6347-fa43-4920-b838-0a1c06006e23)


<br>


+ **메서드 영역 Method Area**

**메서드 영역** 은 JVM이 시작될 때 생성되는 공간으로 **바이트 코드(.class)** 를 처음 메모리 공간에 올릴 때
**초기화되는 대상을 저장** 하기 위한 메모리 공간이다.

JVM 이 동작하고 클래스가 로드될 때 적재돼서 **프로그램이 종료될 때까지 저장** 된다.

>
> 메서드 영역(Method Area) 은 Class Area 나 Static Area 로도 불리운다.
>

모든 **Thread 가 공유** 하는 영역이라 다음과 같이 초기화 코드 정보들이 저장되게 된다.

+ ***Field Info*** : 멤버 변수의 이름, 데이터 타입, 접근 제어자의 정보

+ ***Method Info*** : 메소드 이름, return 타입, 함수 매개변수, 접근 제어자의 정보

+ ***Type Info*** : Class 인지 Interface 인지 여부 저장, Type의 속성, 이름 Super Class의 이름

![image](https://github.com/lielocks/WIL/assets/107406265/6e0cd71c-c088-4265-983b-c4ea26bf05a2)

간단히 말하자면 메서드 영역에는 **Static 필드** 와 **클래스 구조만** 을 갖고 있다고 할수있다.
			
>
> **※ 메소드 영역 / 런타임 상수 풀의 사용기간 및 스레드 공유 범위**
> - JVM 시작시 생성
> - 프로그램 종료 시까지
> - 명시적으로 null 선언 시
>

<br>

>
> [Runtime Constant Pool]
>
> ![image](https://github.com/lielocks/WIL/assets/107406265/70026cdb-7aad-4187-8aac-ff05c2c87d43)
>
> - Method 영역에 존재하는 별도의 관리영역
> - 각 클래스 / 인터페이스 마다 별도의 constant pool 테이블이 존재하는데, **클래스 생성할때 참조해야할 정보들을 상수로** 가지고 있는 영역이다.
>
> - JVM 은 이 Constant Pool 을 통해 해당 메서드나 필드의 실제 메모리상 주소를 찾아 참조한다.
> - 정리하면 **상수 자료형을 저장하여 참조하고 중복을 막는 역할** 을 수행한다.
>

<br>

+ **힙 영역 Heap Area**

힙 영역은 메서드 영역와 함께 모든 쓰레드가 공유하며, JVM이 관리하는 프로그램 상에서 데이터를 저장하기 위해 런타임 시 동적으로 할당하여 사용하는 영역이다.

즉, **new 연산자로 생성되는 클래스와 인스턴스 변수, 배열 타입 등 Reference Type이 저장** 되는 곳이다.
당연히 Method Area 영역에 저장된 클래스만이 생성이 되어 적재된다. (당연한 소리이긴 하다)

![image](https://github.com/lielocks/WIL/assets/107406265/185b405d-d42f-4960-9916-a7d7b80c8926)

>
> ※ 힙 영역의 사용기간 및 스레드 공유 범위
> - 객체가 더 이상 사용되지 않거나 명시적으로 null 선언 시
> - GC(Garbage Collection) 대상
>

유의할점은 힙 영역에 생성된 객체와 배열은 **Reference Type** 으로서, JVM 스택 영역의 변수나 다른 객체의 필드에서 참조된다는 점이다.

즉, 힙의 참조 주소는 "스택"이 갖고 있고 해당 객체를 통해서만 힙 영역에 있는 인스턴스를 핸들링할 수 있는 것이다.

![image](https://github.com/lielocks/WIL/assets/107406265/8b05ea51-cb6d-43e7-8bb7-89b71a0f673c)

만일 참조하는 변수나 필드가 없다면 의미 없는 객체가 되기 때문에 이것을 쓰레기로 취급하고 JVM은 쓰레기 수집기인 **Garbage Collector** 를 실행시켜 쓰레기 객체를 힙 영역에서 자동으로 제거된다.
 
이처럼 `힙 영역은 가비지 컬렉션에 대상이 되는 공간` 이다.
그리고 효율적인 가비지 컬렉션을 수행하기 위해서 세부적으로 다음과 같이 5가지 영역으로 나뉘게 된다.

![image](https://github.com/lielocks/WIL/assets/107406265/e0d6ec65-a0ac-4cf4-a557-578e09f78d7d)

<br>

이렇게 다섯가지 영역(Eden, survivor 0, survivor 1, Old, Permanent)으로 나뉜 힙 영역은 다시 물리적으로 **Young Generation** 과 **Old Generation** 영역으로 구분되게 되는데 다음과 같다.

+ ***Young Generation*** : 생명 주기가 짧은 객체를 GC 대상으로 하는 영역.
  + ***Eden*** : new를 통해 새로 생성된 객체가 위치. 정기적인 쓰레기 수집 후 살아남은 객체들은 Survivor로 이동
  + ***Survivor 0 / Survivor 1*** : 각 영역이 채워지게 되면, 살아남은 객체는 비워진 Survivor로 순차적으로 이동


+ ***Old Generation*** : 생명 주기가 긴 객체를 GC 대상으로 하는 영역. Young Generation에서 마지막까지 살아남은 객체가 이동

<br>

### 스택 영역 Stack Area

스택 영역은 int, long, boolean 등 기본 자료형을 생성할 때 저장하는 공간으로, **임시적으로 사용되는 변수나 정보들이 저장되는 영역** 이다.

![image](https://github.com/lielocks/WIL/assets/107406265/ed932664-058e-4894-ac7a-56c9a2fed077)

자료구조 Stack은 마지막에 들어온 값이 먼저 나가는 LIFO  구조로 push와 pop 기능 사용방식으로 동작한다.
 

메서드 호출 시마다 각각의 **스택 프레임(그 메서드만을 위한 공간)** 이 생성되고 메서드 안에서 사용되는 값들을 저장하고, 호출된 메서드의 매개변수, 지역변수, 리턴 값 및 연산 시 일어나는 값들을 임시로 저장한다.

그리고 메서드 수행이 끝나면 프레임별로 삭제된다.


<br>

   
>
> **[스택 프레임 (Stack Frame)]**
> 메서드가 호출될때마다 frame 이 만들어지며, 현재 실행 중인 메서드 상태 정보를 저장하는 곳이다.
> 메서드 호출 범위가 종료되면 stack 에서 제거된다.
>
> stack frame 에 쌓이는 데이터는 메서드의 매개변수, 지역변수, return 값, 연산시 결과값 등이 있다.
>

<br>

단, 데이터의 타입에 따라 stack 과 heap 에 저장되는 방식이 다르다는 점은 유의해야 한다.

+ 기본(원시) 타입 변수는 stack 영역에 직접 값을 가진다.

+ 참조타입 변수는 heap 영역이나 method 영역의 객체 주소를 가진다.

<br>

>
> *원시 타입, 참조 타입*
>
> **[원시 타입]**
> ![image](https://github.com/lielocks/WIL/assets/107406265/f24e9a10-78d0-414d-bc5a-0f216fb07c1c)
>
> **[참조 타입]**
>
> 참조 타입은 기본 타입을 제외한 타입으로, 객체의 주소를 저장하는 타입이다. 문자열, 배열, 열거형 상수, 클래스, 인터페이스 등이 있다. Java에서 실제 객체는 JVM 힙 영역에 저장되며, 참조 타입 변수는 실제 객체의 주소를 JVM 스택 영역에 저장한다.
>
> ***그리고 객체를 사용할 때마다 참조 변수에 저장된 객체의 주소를 불러와 사용하게 된다.***
>
> Person p = new Person(); 이라는 코드를 작성했다면 p라는 이름의 메모리 공간이 스택 영역에 생성되고, 생성된 p의 인스턴스는 힙 영역에 생성된다, 즉, **스택 영역에 생성된 참조 변수 p** 는 **힙 영역에 생성된 p의 인스턴스 주소 값** 을 가지게 된다.
>
> ![image](https://github.com/lielocks/WIL/assets/107406265/9273dd93-db1d-4502-86be-8efbe51e096e)
>
> `원시 타입`은 `스택 영역`에 존재한다.
> 반면 `참조 타입`은 스택 영역에는 참조 값만 있고, `실제 값은 힙 영역`에 존재한다.
> `참조 타입`은 최소 2번 메모리 접근을 해야 하고, 일부 타입의 경우 값을 필요로 할 때 `언박싱 과정`(ex. Double → double, Integer → int)을 거쳐야 하므로 원시 타입과 비교해서 `접근 속도가 느린 편`이다.
>

<br>

예를 들어 `Person p = new Person();` 와 같이 클래스를 생성할 경우,
new 에 의해 생성된 **클래스는 Heap Area 에 저장** 되고, **Stack Area 에는** 생성된 클래스의 참조인 **p만 저장** 된다.

![image](https://github.com/lielocks/WIL/assets/107406265/43acb671-cc89-4d8b-b4ab-909bd9a108a0)

스택 영역은 각 스레드마다 하나씩 존재하며, 스레드가 시작될 때 할당된다.

프로세스가 메모리에 로드 될 때 스택 사이즈가 고정되어 있어, 런타임 시에 스택 사이즈를 바꿀 수는 없다.

만일 고정된 크기의 JVM 스택에서 프로그램 실행 중 메모리 크기가 충분하지 않다면 StackOverFlowError가 발생하게 된다.

쓰레드를 종료하면 런타임 스택도 사라진다.

![image](https://github.com/lielocks/WIL/assets/107406265/7c16ea4b-b833-4f60-9ed7-d657e796e38d)

여기까지 배운 메소드 영역, 힙 영역, 스레드 영역을 한 그림으로 표시하자면 다음과 같이 도식이 그려지게 된다.

![image](https://github.com/lielocks/WIL/assets/107406265/38b8fa50-ad5d-4917-9399-df45d2f6f9fe)

<br>

### PC Register Program Counter Register

**PC 레지스터** 는 쓰레드가 시작될 때, **현재 수행중인 JVM 명령어 주소를 저장** 하는 공간이다.

JVM 명령의 주소는 쓰레드가 어떤 부분을 무슨 명령으로 실행해야 할 지에 대한 기록을 가지고 있다.

일반적으로 프로그램의 실행은 **CPU에서 명령어 (Instruction) 을 수행** 하는 과정으로 이루어진다.
이때 CPU 는 연산을 수행하는 동안 필요한 정보를 `register라고 하는 CPU 내의 기억장치` 를 이용하게 된다.

예를 들어, A와 B라는 데이터와 피연산 값인 **Operand** 가 있고 이를 더하라는 연산 **Instruction** 이 있다고 하자.

A와 B, 그리고 더하라는 연산이 순차적으로 진행이 되게 되는데, 이때 A를 받고 B를 받는 동안 이 값을 CPU가 어딘가에 기억해 두어야 할 필요가 생긴다.
이 공간이 바로 CPU 내의 기억장치 **Register** 이다.

![image](https://github.com/lielocks/WIL/assets/107406265/9a3f8841-62e6-4c08-bfa6-9bad22b0d11c)

하지만 **자바의 PC Register** 는 위의 `cpu Register` 와 다르다.

자바는 OS 나 CPU 의 입장에서는 하나의 프로세스이기 때문에 가상 머신(JVM)의 리소스를 이용해야 한다.

그래서 자바는 CPU에 직접 연산을 수행하도록 하는 것이 아닌, **`현재 작업하는 내용을 CPU에게 연산으로 제공`** 해야 하며, **`이를 위한 버퍼 공간`** 으로 **PC Register 라는 메모리 영역** 을 만들게 된 것이다 !

따라서 JVM은 스택에서 비연산값 Operand를 뽑아 별도의 메모리 공간인 PC Register 에 저장하는 방식을 취한다.

![image](https://github.com/lielocks/WIL/assets/107406265/98ac5c16-bd31-4840-ba35-3a52af3d3bd8)

만약에 스레드가 자바 메소드를 수행하고 있으면 JVM 명령(Instruction) 의 주소를 PC Register 에 저장한다. 

그러다 만약 자바가 아닌 다른 언어 (C언어, 어셈블리) 의 메서드를 수행하고 있다면, undefined 상태가 된다.

왜냐하면 자바에서는 이 두 경우를 따로 처리하기 때문이다.
이 부분이 바로 뒤에 언급하게 될 Native Method Stack 공간이다.

<br>

### 네이티브 메서드 스택 (Native Method Stack)

**네이티브 메서드 스택**는 자바 코드가 컴파일되어 생성되는 바이트 코드가 아닌 실제 실행할 수 있는 **기계어로 작성된 프로그램을 실행** 시키는 영역이다.

또한 **자바 이외의 언어(C, C++, 어셈블리 등)로 작성된 네이티브 코드를 실행**하기 위한 공간이기도 하다.

사용되는 메모리 영역으로 일반적인 C 스택을 사용한다.

위에서 배운 **JIT 컴파일러** 에 의해 변환된 Native Code 역시 여기에서 실행이 된다고 보면 된다.
![image](https://github.com/lielocks/WIL/assets/107406265/76acca76-7e0e-4c26-b237-31d8065db010)

<br>

일반적으로 메소드를 실행하는 경우 JVM 스택에 쌓이다가 해당 메소드 내부에 네이티브 방식을 사용하는 메소드가 있다면 해당 메소드는 네이티브 스택에 쌓인다.

그리고 네이티브 메소드가 수행이 끝나면 다시 자바 스택으로 돌아와 다시 작업을 수행한다.

그래서 네이티브 코드로 되어 있는 함수의 호출을 자바 프로그램 내에서도 직접 수행할 수 있고 그 결과를 받아올 수도 있는 것이다.

네이티브 메소드 스택은 바로 다음에 배울 **네이티브 메소드 인터페이스 (JNI)** 와 연결되어 있는데, JNI 가 사용되면 네이티브 메서드 스택에 바이트 코드로 전환되어 저장되게 된다.

<br>

### JNI (Java Native Interface)

**JNI** 는 자바가 다른 언어로 만들어진 어플리케이션과 상호 작용할 수 있는 인터페이스를 제공하는 프로그램이다.

위에서 다뤄봤듯이, JNI는 JVM이 Native Method를 적재하고 수행할수 있도로 한다.
하지만 실질적으로 제대로 동작하는 언어는 C / C++ 정도 밖에 없다고 한다.

![image](https://github.com/lielocks/WIL/assets/107406265/a3a7a78e-4602-4c72-ad18-0006d105ae66)

<br>

### Native Method Library

C, C++로 작성된 라이브러리를 칭한다.
만일 헤더가 필요하면 JNI는 이 라이브러리를 로딩해 실행한다.

![image](https://github.com/lielocks/WIL/assets/107406265/c30655f3-c70d-4dc4-a47e-a3c7913e6702)


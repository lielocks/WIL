## Node.js

웹의 역사에서부터 천천히 출발해보자.

1990년 Tim Berners lee 가 WEB 을 창시했다.

이때의 웹은 정적인 체계의 웹이였다.
  
Marc Andreessen 에 의해  Netscape 라는 대중적 웹브라우저가 등장하게 되었고

Brendan Eich 에 의해 JavaScript 등장하고 웹에 동적인 체계를 탑재하게 되었다.
  
즉, 사용자와 상호작용이 가능해졌다는 이야기이다.

WEB 이라는 울타리안에 갇혀있던 JavaScript, 대중성을 중시해서 천대 받던 JavaScript 가 재조명 받게되는 계기가 있었다.

<br>


**2004 년, Gmail 등장이다.** 
  
순수한 웹기술(HTML, JavaScript 등)을 통해서 만들었음에도 불구하고 뛰어난 성능을 보인 것이다.

이어서 GMap 도 순수 웹기술로 구축되었고 이 또한 개발자들에게 신선한 충격을 주었다.

이 후로 자바스크립트의 성장세는 계속된다.

2008년 구글이 Chrome의 성능 향상을 위해 JavaScript Engine 개발하였다.

그것이 V8 이고 이것을 오픈소스로 공개하여 수많은 개발자들을 이끌었다.

그리고 2009년 Ryan Dal 이 *JavaScript 언어로 구현된 서버 사이드 언어 Node.js* 를 내보인다.

그렇다면,

***Web Browser 에서 작동하는 JavaScript와 Node.js 차이는 무엇인가 ?***

<br>

JavaScript 라는 단어에는 두가지의 의미가 혼재되어있다.

**`language`** 로서의 JavaScript 와 

**`Run Time(언어가 작동하는 환경)`** 으로의 JavaScript 이다.

프로그래밍 세계에서 잠깐 벗어나서 실생활의 구체적인 예로 접근을 해보자.

JavaScript 언어를 '한국어(일상 우리가 사용하는 언어)'라고 한다면 그 한국어를 통해서 병원엘 가거나 법원에 가는 등에 가서 일을 처리할 수 있다.

즉, JavaScript 란 프로그래밍 언어로 Web Browser 를 제어하거나 서버를 제어할 수 있다.

<br>

둘 다 JavaScript 의 문법을 기반으로 한다. 하지만 다른 함수를 사용한다.

예를 들면 alert 라는 함수는 Only Web 에서 작동하는 함수이며 서버에서는 사용할 수 없다.

alert 이란 함수는 *Node.js 라는 runtime 에는 없는 함수* 라는 말이 된다.

Node.js 에 alert 이라는 명령어를 입력하는 것은 법원에 가서 아프니까 약달라고 하는 꼴이다.

<br>

Node.js는 **V8 Javascript Engine** 과 **libuv 및 C/C++ 에 의존성을 가진 Javascript Runtime** 입니다. 

Runtime 은 Javascript 로 된 program 을 실행할 수 있는 program 입니다. 

예를 들어 Java 코드는 Java 실행 환경인 **`JRE(Java Runtime Environment)`** 위에서 실행됩니다. 

C# 코드는 CLR(Common Language Runtime) 이라는 Runtime 에서 실행됩니다.

> 반면 C 언어는 runtime 없이 코드를 실행합니다. C 언어처럼 compile 한 결과물이 특정 CPU 의 기계어인 언어를 Native 언어라고 합니다.

<br>

![image](https://github.com/lielocks/WIL/assets/107406265/539b635f-e29b-4fac-8c84-e6ca1947b1ee)

Node.js 는 각 계층이 각 하단에 있는 API 를 사용하는 계층의 집합으로 설계되어 있습니다. 

즉 사용자 코드(Javascript) 는 

1️⃣ Node.js 의 API 를 사용하고, 

2️⃣ Node.js API 는 C++에 바인딩 되어 있는 source 이거나 직접 만든 

3️⃣ C++ 애드온을 호출합니다. 

4️⃣ C++ 에서는 **V8** 을 사용해 Javascript 를 해석(JIT Compiler) 및 최적화하고 어떤 코드냐에 따라 C/C++ 종속성이 있는 코드를 실행합니다. 

또한 DNS, HTTP 파서, OpenSSL, zlib 이외의 C/C++ 코드들은 

5️⃣ **libuv 의 API** 를 사용해 해당 운영체제에 알맞는 API 를 사용합니다.

<br>

Node.js 의 구성요소 중 특히 V8 과 libuv 가 중요합니다. 

V8 은 Javascript 코드를 실행하도록 해 주고, libuv 는 event loop 및 OS 계층 기능을 사용하도록 API를 제공합니다. 

Node.js의 구성요소를 다음 표에 간략히 설명해두었습니다.

![image](https://github.com/lielocks/WIL/assets/107406265/d6d58794-ef37-4866-b232-b08dbc492c06)

<br>

### Javascript 실행을 위한 V8 Engine

V8 은 C++ 로 만든 오픈 소스 Javascript Engine 입니다. 

‘Engine’ 은 사용자가 작성한 코드를 실행하는 프로그램을 말합니다. 

Engine 은 parser, compiler, interpreter, garbage collector, call stack, heap 으로 구성되어 있습니다. 

V8 엔진은 Javascript 를 실행 할 수 있는 Engine 이며, **interpreter 역할을 하는 이그니션** 과 **compiler 역할을 하는 터보팬** 을 사용해 compile 합니다.

다음은 V8 Engine 이 어떤 방식으로 Javascript source 를 compile 하는지 나타내는 그림입니다.

![image](https://github.com/lielocks/WIL/assets/107406265/287779eb-4c55-47c5-89a0-a7dd52a0487f)

Javascript 코드는 

1️⃣ 파서에 전달되어 → 2️⃣ 추상 구문 트리로 만들 어집니다. 

이후 3️⃣ 이그니션 interpreter 에 전달되면 → 이그니션은 추상 구문 트리를

4️⃣ Bytecode 로 만듭니다. 

5️⃣ 최적화가 필요한 경우이면 터보팬으로 넘깁니다. 

그러면 5️⃣ 터보팬에서 compile 과정을 걸쳐서 6️⃣ Binary code 가 됩니다. 

최적화가 잘 안 된 경우는 7️⃣ 다시 최적화를 해제하고 이그니션의 interpreter 기능을 사용합니다.

<br>


이처럼 interpreter 와 compiler 의 장점을 동시에 가지고 있는 프로그램을 JIT(just-in time) compiler 라고 합니다. 

속도가 빠르며, 적재적소에 최적화할 수 있다는 장점과 compiler 와 interpreter 가 동시에 실행되어 메모리를 더 많이 쓴다는 단점이 있습니다.

![image](https://github.com/lielocks/WIL/assets/107406265/8b199b29-abcd-4f56-b6d0-2ccb9e145194)

<br>

### Event loop 와 OS 단 비동기 API 및 thread pool 을 지원하는 libuv

V8 Engine 을 사용해서 Server 에서 Javascript 를 실행할 수 있다는 것을 이제 알았습니다. 

그러면 Node.js 는 HTTP, 파일, socket 통신 IO 기능 등 Javascript 에는 없는 기능을 어떻게 제공하는 걸까요?

<br>

Node.js 는 이 문제를 **`libuv`** 라는 C++ 라이브러리를 사용해 해결합니다.
(libuv 는 **비동기 입출력, event 기반** 에 초점을 맞춘 라이브러리입니다). 

그래서 Javascript 언어에서 C++ 코드를 실행 할 수 있게 해두었습니다. 

Javascript 로 C++ 코드를 감싸서 사용합니다(C++ 바인딩이라고 합 니다).

![image](https://github.com/lielocks/WIL/assets/107406265/c04c6b9d-afa0-4536-884b-8abceb49a120)

libuv 는 다양한 플랫폼에서 사용할 수 있는 Event loop 를 제공합니다.

(Linux 는 epoll, Window 는 IOCP, MAC OS 는 kqueue, SunOS 는 이벤트 포트)

또한 네트워크, 파일 IO, DNS, thread pool 기능을 추가로 제공합니다. 

Node.js 에서는 **C++ binding 기능** 으로 Javascript 에서 libuv 의 API 를 사용합니다.

<br>

### Node.js 아키텍처

지금까지 Node.js 를 구성하는 주요한 항목을 살펴보았습니다. 

요약하면 Node.js는 Javascript 코드 실행에 필요한 runtime 으로 V8 Engine 을 사용하고, Javascript Runtime 에 필요한 event loop 및 OS 시스템 API 를 사용하는 데는 libuv 라이브러리를 사용합니다. 

Node.js 애플리케이션의 코드가 어떻게 실행되는지를 살펴봅시다.

![image](https://github.com/lielocks/WIL/assets/107406265/8a08ac49-7401-400a-b570-27ad34b08f12)

1️⃣ 애플리케이션에서 요청이 발생합니다. V8 Engine 은 Javascript 코드로 된 요청을 bytecode 나 기계어로 변경합니다. 

2️⃣ Javascript 로 작성된 Node.js 의 API 는 C++ 로 작성된 코드를 사용합니다. 

3️⃣ V8 Engine 은 event loop 로 libuv 를 사용하고 전달된 요청을 libuv 내부의 Event Queue 추가합니다. 

4️⃣ Event Queue 에 쌓인 요청은 event loop 에 전달되고, OS kernel 에 비동기 처리를 맡깁니다. 

OS 내부적으로 비동기 처리가 힘든 경우(DB, DNS 룩업, 파일 처리 등)는 worker thread 에서 처리합니다. 

5️⃣ OS 의 kernel 또는 worker thread 가 완료한 작업은 다시 event loop 로 전달됩니다. 

6️⃣ Event loop 에서는 callback 으로 전달된 요청에 대한 완료 처리를 하고 넘깁니다. 

7️⃣ 완료 처리된 응답을 Node.js 애플리케이션으로 전달합니다.

<br>

## Node.js 로 만드는 server

### 작고 빈번한 요청을 처리하는 서비스에 어울린다

+ Single Thread 이기 때문에 하나의 커다란 요청보다 간단한 요청 처리에 어울린다

+ 예를 들어 network streaming , 채팅 등 작고 빈번한 요청의 서비스들.

+ 또한 비동기로 요청을 처리하기 때문에 처리가 끝나면 바로 응답한다. 즉, 응답 속도가 빠르다

+ 심지어 **`async, await`** 의 등장으로 비동기 처리 로직을 작성하는 난이도도 쉬워졌다.

<br>

### 로직이 간단한 서비스

+ Nodejs 는 runtime 에 에러가 발생할 수 있기 때문에 프로그램 복잡도와 위험도가 비례한다.

+ 또한 서버에 체크 로직이 많으면 callback 지옥에 빠질 수도 있다. (async, await 로 어느정도 해결 가능!)

+ Node.js 가 원인을 알 수 없는 이유로 종료되는 경우는 없다. 주로 예외처리를 하지 않은 개발자의 실수가 원인이기 때문에, 개발복잡도가 올라가면 실수할 가능성이 높아진다.

<br>


### 빠르게 개발해야 할 때

+ NPM 생태계에서 다른 패키지 도움을 받아 개발 효율을 높일 수 있으며 개발 환경 자체가 그리 복잡하지 않기 때문에 빠르게 개발을 진행할 수 있다.

+ 웬만한 기능은 이미 NPM package 에 존재한다.

<br>


### 데이터 포맷으로 JSON 을 사용할 때

+ Javascript 자체가 **JSON** 을 지원하기에 적합하다.

+ Database 로 **MongoDB / Elasticsearch** 등을 사용한다면 시너지가 더 발생한다.

## NodeJS Event Loop 방식

![image](https://github.com/lielocks/WIL/assets/107406265/edc3af10-f69c-4167-bdff-a0589adbf377)

실제로 V8 과 같은 Javascript Engine 은 단일 호출 스택(Call Stack)을 사용하며, 요청이 들어올 때마다 해당 요청을 순차적으로 호출 스택에 담아 처리할 뿐이다. 

그렇다면 **`비동기 요청`** 은 어떻게 이루어지며, **`동시성에 대한 처리`** 는 누가 하는 걸까? 

바로 이 Javascript Engine 을 구동하는 환경, 즉 **브라우저나 Node.js** 가 담당한다. 

![image](https://github.com/lielocks/WIL/assets/107406265/50246517-c394-4fcf-a918-4ae4ca4246e5)

이 그림에서도 브라우저의 환경과 비슷한 구조를 볼 수 있다. 

잘 알려진 대로 Node.js 는 Non-Blocking IO 를 지원하기 위해 **`libuv`** 라이브러리를 사용하며, 이 libuv 가 **Event Loop 를 제공한다.** 

Javascript Engine 은 비동기 작업을 위해 Node.js 의 API를 호출하며, 이때 넘겨진 callback 은 libuv 의 event loop 를 통해 스케줄 되고 실행된다.

Javascript 가 'Single Thread' 기반의 언어라는 말은 'Javascript Engine 이 단일 호출 스택을 사용한다'는 관점에서만 사실이다. 

실제 Javascript 가 구동되는 환경(브라우저, Node.js 등) 에서는 주로 여러 개의 thread 가 사용되며, 

이러한 구동 환경이 단일 호출 스택을 사용하는 Javascript Engine 과 상호 연동하기 위해 사용하는 장치가 바로 **`'Event Loop'`** 인 것이다.

![image](https://github.com/lielocks/WIL/assets/107406265/7da95c91-b85d-4cda-a846-6432361c491a)

즉, Event Loop 만 single thread 라서 req, res 이 single thread 인 거지 뒤에서 열심히 일하는 worker(IO 처리) 들은 여러 개(multi thread)이다.

Event Loop 만 blocking 안되게 만들면, worker 들은 알아서 일을 나눠 가지고 돌아간다.

Node.js 는 IO 작업을 백그라운드에서 비동기적으로 처리함으로써, IO 작업이 완료될 때까지 기다리지 않고 다른 작업을 수행할 수 있다. 

이는 CPU 가 다른 요청을 처리하거나 유휴 상태로 들어가지 않고 계속 CPU 가 쉬지 않고 다른 요청들을 받아 작업을 처리할 수 있도록 도와준다.
 
<br>

## Redis Documents

Redis Document 에서 single thread 로 검색해 보면 다음과 같은 글을 볼 수 있습니다.

Redis는 single thread 이며 **`multiplexing`** 이란 기술을 사용하여 단일 프로세스가 모든 클라이언트 요청을 처리합니다.

모든 요청이 순차적으로 처리되며, 이는 **Node.js** 의 작동 방식과 매우 유사합니다.

Redis 2.4 부터는 디스크 I/O 와 관련된 느린 I/O 작업을 백그라운드에서 수행하기 위해 여러 개의 thread 를 사용하지만 Redis 가 단일 thread 를 사용하여 모든 요청을 처리한다는 사실은 바뀌지 않습니다.

단일 thread 의 결과는 요청이 느리게 처리될 때 다른 모든 클라이언트가 이 요청이 처리될 때까지 기다립니다.

이런 사유 때문에 Redis를 사용할 때는 명령의 알고리즘 시간 복잡도가 문서화되어 있고 잘 확인하여 사용해야 합니다.

> 프로덕션 환경에서 KEYS 명령어를 사용하면 안 되는 이유

<br>

### Multiplexing

![image](https://github.com/lielocks/WIL/assets/107406265/61da3972-a0b1-4e9f-b729-90259413628d)

하나의 통신 채널을 통해 다량의 데이터를 전송하는 데 사용되는 기술입니다.

매 요청마다 새로운 process 나 thread 를 생성하는 게 아니라 요청의 개수와 상관없이 **한 개의 process 나 thread** 를 이용하여 작업을 처리합니다.

<br>

모든 작업처리는 단일 call stack 에서 이루어지고 비동기 처리는 **Queue 를 이용하여 `event loop`** 방식으로 동작합니다.

*여러 개의 socket 이 동시에 연결되어 있고,* 이들을 관찰하면서 들어오는 작업을 처리합니다.

<br>

1. Redis 는 새로운 클라이언트 연결, 클라이언트에서 들어오는 데이터 또는 I/O 작업 완료와 같은 event 가 발생하기를 기다리는 **단일 event loop** 를 사용합니다.

2. 새 클라이언트가 Redis 에 연결되면 event loop 에 등록되고 event loop 는 들어오는 데이터에 대한 연결을 모니터링합니다.

3. 클라이언트로부터 데이터가 도착하면 event loop 는 event 유형을 결정하고 그에 따라 처리합니다.

4. 클라이언트의 요청에 I/O 작업이 필요한 경우 event loop 는 다른 클라이언트의 연결의 진행을 차단하지 않고 작업을 **비동기** 적으로 수행합니다.

5. event loop 가 여러 클라이언트의 이벤트를 처리할 때 각 클라이언트에 대해 보류 중인 작업 대기열을 유지 관리합니다. 이를 통해 Redis 는 실제 처리가 단일 thread 내에서 발생하더라도 동시에 여러 클라이언트에 서비스를 제공할 수 있습니다.

<br> 

단일 thread event 기반 아키텍처를 사용함으로써 Redis 는 thread 동기화, context switching 으로 발생하는 리로스 경합 및 오버헤드, 복잡성을 방지합니다.

<br>

### Redis MultiThread?

위에서도 I/O 작업등을 백그라운드에서 처리할 때 여러 개의 thread 를 사용한다고 명시되어 있습니다.

실제로 redis 의 thread 를 조회해 보면 여러 개가 쓰여있습니다.

하지만 하나의 thread 에서만 명령을 처리하고 나머지 쓰레드들은 `disk 를 flush 하거나 파일을 닫기 위해 OS 작업`이 되는것을 해당 thread 에서 처리하게 되면 다른 작업이 느려지기 때문에 **해당 작업들을 OS 레벨에서 비동기로 처리**합니다.

즉, Single Thread 라는 의미는 ***클라이언트의 요청인 Redis 의 명령어를 처리하는 것에만*** 유의미합니다.

초반에 개요에서 게시한 글에서도 Redis 6.0 에서 `ThreadedIO 로 Multi Thread 를 지원하여 2.5배 성능을 빠르게` 하였지만 여전히 **명령의 실행은 Single Thread 로 실행되기 때문에 Atomic 이 깨지지 않습니다.**

<br>

### Single Thread 로 빠른데 Multi Thread 를 도입한 이유는?

Redis의 성능 병목 현상중 하나인 **`네트워크 IO 작업`** 때문입니다.

프로젝트에서 일부 큰 Key-Value 쌍을 삭제해야 하는 경우 단시간에 삭제할 수 없으면 단일 thread 의 경우 후속 작업이 차단됩니다.

 

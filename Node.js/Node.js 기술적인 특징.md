Node.js 이전의 Javascript 는 브라우저에서 주로 실행되는 언어였습니다. 

브라우저에는 V8 같은 **Javascript Engine** 이 들어 있습니다. 

언어 자체가 **Single Thread** 이고, **이벤트 기반(event driven)** 아키텍처입니다. 

따라서 Javascript Runtime 인 Node.js 도 자연스럽게 Single Thread 로 구현되고 event 기반 아키텍처를 구현했습니다. 

이번 절에서는 이러한 Node.js 의 기술적인 특징을 알아봅시다.

<br>

### Single Thread

Javascript Engine(V8) 은 Javascript 를 실행하는 **`Heap`** 과 **`Call Stack`** 을 가지고 있습니다. 

그리고 Single thread 로 실행됩니다. Single thread 라는 이야기는 *Call Stack 이 하나만* 있다는 말입니다. 

Call Stack 이 하나이므로 *한번에 하나의 작업만* 가능합니다.

![image](https://github.com/lielocks/WIL/assets/107406265/2c80780a-76b8-4470-9a9a-56a4fb0fea85)

```javascript
function func1() {
  console.log("1");
  func2();
  return;
}

function func2() {
  console.log("2");
  return;
}
```

```
func1();
// 결괏값
1
2
```

func1(), func2() 함수 2개가 있습니다. 

코드에서는 func1() 만 실행하고 func1() 에서는 1 을 출력 후 func2() 를 실행합니다. 

1과 2가 출력될 때까지 **Call Stack** 에는 어떤 일이 일어나는지 알아봅시다.

![image](https://github.com/lielocks/WIL/assets/107406265/cc45cba0-bf92-449e-b575-c56bf93151b8)

1️⃣ 코드에서 func1() 을 최초로 실행하므로 `func1()` 이 **Call Stack 에 추가**됩니다. 

2️⃣ func1() 함수 몸체 첫 번째 줄에 있는 `console.log(“1”)` 이 **Call Stack 에 추가**됩니다. 

3️⃣ console.log(“1”) 함수가 실행 완료되어 1이 출력되고, console.log(“1”) 함수는 Call Stack 에서 **제거**됩니다. 

4️⃣ Call Stack 에 `func2()` 함수가 추가됩니다. 

5️⃣ func2() 에 있는 `console.log(“2”)` 함수가 Call Stack 에 추가됩니다. 

6️⃣ console.log(“2”) 함수가 실행 완료되어 2가 출력되고, `console.log(“2”)` 함수는 Call Stack 에서 제거됩니다. 

7️⃣ 함수 func2() 의 return 이 실행되어 종료되고, Call Stack 에서 제거됩니다. 

8️⃣ 함수 func1() 의 return 이 실행되어 종료되고, Call Stack 에서 제거됩니다.

<br>

Call Stack 이 어떤 것인지 이해했으니, 비동기 처리로 넘어가봅시다.

<br>

### Event 기반 아키텍처

Node.js 처럼 Single Thread 로 요청을 처리하는 server 가 있습니다. 

한 번에 하나를 처리하는 server 에 0.1 초가 걸리는 요청이 동시에 100 개가 온다면 마지막에 요청한 사람은 10 초를 기다려야 응답을 받을 수 있습니다. 

Multi thread 를 지원하는 언어라면 thread 를 100개 만들어서 동시에 처리할 수 있지만 *single thread 인 Javascript 는 그렇게 할 수 없습니다.*

어떻게 하면 요청을 **하나의 thread 로 동시에** 처리할 수 있을까요?

![image](https://github.com/lielocks/WIL/assets/107406265/dbe8bc9f-6f14-4b86-9141-38ec3f5ffb6c)

방법은 Event 기반 아키텍처를 적용하는 겁니다. 

Call Stack 에 쌓인 작업을 다른 곳에서 처리한 다음 -> 처리가 완료되었을 때 알림 -> 을 받으면 thread 가 하나라도 빠르게 처리할 수 있습니다.

<br>

예를 들어 커피숍을 들 수 있습니다. 

카운터에서 주문을 완료하면 주문은 제조를 하는 직원에게 건네집니다. 

카운터는 커피가 나올 때까지 기다리지 않고 다음 고객의 주문을 받습니다. 

진동벨을 받은 고객은 진동벨이 울릴 때까지 기다렸다가 울리면 주문한 음료를 받아갑니다. 

이때 줄을 섰던 순서와는 다르게 빠르게 제조된 음료가 먼저 나올 수 있습니다.

<br>

이런 방식으로 처리하는 것이 Event 기반 아키텍처입니다. 

Node.js 에서는 동시 요청을 어떻게 처리하는지 알아봅시다.

![image](https://github.com/lielocks/WIL/assets/107406265/d1f8b181-d0c4-4639-b277-a3690255ba1f)

Javascript 코드는 

1️⃣ V8 의 Call Stack 에 쌓이고 **I/O 처리**가 필요한 코드는 **`Event Loop`** 로 보내게 됩니다. 

2️⃣ Event Loop 에서는 말그대로 Loop 를 실행하면서 **OS 또는 Thread Worker 에 I/O 처리를 맡기게** 됩니다. 

3️⃣ Thread Worker 와 OS 는 받은 요청에 대한 결과를 Event Loop 로 돌려주고 

4️⃣ Event Loop 에서는 결괏값에 대한 코드를 **Call Stack 에 다시 추가**합니다.

<br>

전반적인 동작을 확인했으니 이번에는 간단한 코드를 사용해 Event Loop 를 살펴봅시다.

<br>

```javascript
console.log("1");
setTimeout(() =>  console.log(2), 1000);
console.log("3");
```

```
// 결괏값
1
3
// (1초후)
2
```

1️⃣ 소스 코드의 첫 번째 라인을 읽어서 Call Stack 에 `console.log(“1”)` 함수가 추가됩니다.

![image](https://github.com/lielocks/WIL/assets/107406265/e7e5f8ba-ab0c-4606-8e57-f887608e2e34)

2️⃣ Call Stack 에 있는 console.log(“1”) 이 실행되어서 1이 출력됩니다.

![image](https://github.com/lielocks/WIL/assets/107406265/37e05cfe-e3f6-4680-8fad-f5db45bba886)

3️⃣ Call Stack 에 `setTimeout()` 이 추가됩니다.

![image](https://github.com/lielocks/WIL/assets/107406265/9990f6b3-d5cf-4d35-adc6-13388988fca2)

4️⃣ setTimeout() 은 Node.js API 입니다. 주어진 시간 동안 대기합니다.

![image](https://github.com/lielocks/WIL/assets/107406265/c67a6fce-1b36-4a4e-a2dc-439513ab0961)

5️⃣ setTimeout() 이 기다리는 동안 `console.log(“3”)` 을 Call Stack 에 추가합니다.

![image](https://github.com/lielocks/WIL/assets/107406265/5ac7cd2d-62b8-4857-a3bc-10d87ff03103)

6️⃣ console.log(“3”) 을 실행해서 3을 출력합니다.

![image](https://github.com/lielocks/WIL/assets/107406265/794c2404-4ec0-491d-b291-2d892ed82a2c)

7️⃣ 지정된 시간이 지나고 Node.js API 에서 setTimeout() 을 Event Loop 의 **Task Queue** 로 추가합니다.

![image](https://github.com/lielocks/WIL/assets/107406265/0c9438d4-2e2a-4246-a2fc-6c3a5215dbf3)

8️⃣ Task Queue 에 추가된 setTimeout() 을 Event Loop 의 각 단계를 진행하면서 Call Stack 에 다시 추가합니다.

![image](https://github.com/lielocks/WIL/assets/107406265/202f1a41-e442-4918-b2d3-6ef8572e5958)

9️⃣ Call Stack 에 추가한 setTimeout() 을 실행해 2를 출력합니다.

![image](https://github.com/lielocks/WIL/assets/107406265/33b8db16-4a33-4bf6-a9a0-7342cc64b4b9)

> `setTimeout()` 의 두 번째 인수로 0 을 넣어도 똑같은 결과가 나옵니다.
>
> Node.js API 영역에서 기다리는 시간이 0 일뿐 **Task Queue 에 추가하고 Event Loop 를 통해서 Call Stack 에 추가하는 것**은 동일하기 때문입니다.

<br>

Node.js 는 오래 걸리는 일을 Event Loop 에 맡긴다는 사실을 알게 되었습니다. 

Event 기반 아키텍처를 구현했기에, 10ms 인 요청이 동시에 100 개가 오더라도 Node.js 는 그 요청을 거의 동시에 처리할 수 있습니다.

<br>

### Event Loop

Node.js 에서는 Event 기반 아키텍처를 구축하는 데 **반응자 패턴(reactor pattern)** 을 사용했습니다. 

반응자 패턴은 Event 디멀티플렉서와 Event Queue 로 구성됩니다. 

반응자 패턴은 Event 를 추가하는 주체와 해당 Event 를 실행하는 주체를 분리(decoupling) 하는 구조입니다. 

반응자 패턴에서 **Event Loop** 는 필수입니다. 

<br>

Node.js 의 Event Loop 는 **libuv** 에 있습니다. 

각 OS 의 계층(IOCP, kqueue, epoll, 이벤트 포트)을 추상화한 기능을 제공합니다. 

libuv 소스 파일의 **`uv_run()`** 함수를 살펴보면 다음과 같은 while 문을 사용해 반복 실행합니다.

```c
int uv_run(uv_loop_t* loop, uv_run_mode mode) {
    r = uv__loop_alive(loop);
    if (!r)
        uv__update_time(loop);
    while (r != 0 && loop->stop_flag == 0) {
        uv__update_time(loop);
        uv__run_timers(loop);
        ran_pending = uv__run_pending(loop);
        uv__run_idle(loop);
        uv__run_prepare(loop);
        uv__io_poll(loop, timeout);
        uv__metrics_update_idle_time(loop);
        uv__run_check(loop);
        uv__run_closing_handles(loop);
        r = uv__loop_alive(loop);
    }
// 이하 생략
```

![image](https://github.com/lielocks/WIL/assets/107406265/c5156af5-e0f0-499a-ae05-74fdfed6eec1)

Event Loop 는 여러 개의 **FIFO Queue** 로 이루어져 있습니다. 

각 단계를 돌면서 각 Queue 에 쌓인 event 를 모두 처리합니다. 

1️⃣ Event Loop 의 시작 및 각 반복(iteration) 의 마지막에 **Loop 가 활성화** 상태인지 체크합니다. 

2️⃣ **Timer** 단계에서는 타이머 큐(timer queue)를 처리합니다. setTimeout( ), setInterval( )을 여기서 처리합니다. 

3️⃣ 펜딩 pending I/O callback 단계에서는 다음 **반복(iteration) 으로 연기된 callback** 을 처리합니다. 

4️⃣ 유휴(Idle) , 준비(prepare) 단계는 내부적으로만 사용됩니다. 

5️⃣ 폴 Poll 단계에서는 **새로운 연결**(socket 등)을 맺고, 파일 읽기 등의 작업을 합니다. 각 작업은 비동기 I/O 를 사용하거나 Thread Pool 을 사용합니다. 

6️⃣ 검사(check) 단계에서는 `setImmediate()` 를 처리합니다. 

7️⃣ 종료 callback 단계에서는 callback 의 종료 처리(파일 디스크립터 닫기 등)를 합니다.

<br>

여기서 `nextTickQueue` 와 `microTaskQueue` 는 조금 특별한 장치입니다. 

번호를 매겨놓지 않은 이유는 각 단계의 사이마다 nextTickQueue 와 microTaskQueue 에 있는 작업을 먼저 실행하기 때문입니다. 

즉 **Timer 단계가 끝나면** nextTickQueue 와 microTaskQueue 를 실행합니다. 

또한 **펜딩 I/O 콜백 단계가 끝나면** 그 사이에 쌓인 nextTickQueue 와 microTaskQueue 를 실행합니다. 

따라서 nextTickQueue 와 microTaskQueue 에 코드를 추가하면 조금은 우선 순위가 올라갑니다. 

<br>

Node.js 의 `process.nextTick()` 함수로 nextTickQueue 에 작업을 추가할 수 있습니다. 

microTaskQueue 에는 **Promise 로 만든 callback 함수**가 추가됩니다. 

*Promise 는 비동기 함수를 동기 함수처럼 사용하는 객체입니다.* 

nextTickQueue 가 microTaskQueue 보다 우선순위가 높습니다. 

즉 `process.nextTick()` 으로 작성된 코드가 **Promise 로 작성된 코드보다 먼저** 실행됩니다.

<br>

Call Stack 이 하나지만, event 동시 처리를 어떻게 하는지 살펴보았습니다. 

Event Loop 에서 OS 의 비동기 I/O 기능을 사용하거나, 또는 Thread Pool 을 사용해서 모든 작업을 비동기로 처리했습니다. 

Event Loop 에서는 여러 Queue 를 사용해 특정 우선순위대로 작업들을 처리해줍니다.

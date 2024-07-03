## node.js는 기존의 multi thread와 어떻게 다를까 ?

우리가 server side 언어로 개발한 서버 프로그램은 수많은 클라이언트의 요청을 처리할 수 있어야 합니다. 

기존의 java, .net, php..의 경우 multi thread 방법으로 클라이언트의 요청을 처리하였습니다.

<br> 

즉 각각의 클라이언트의 요청에 thread 를 할당하여 thread 에서 클라이언트의 요청을 처리하는 방식을 선택하였습니다. 

`apacha tomcat` 의 경우 default thread pool size(200개) 를 두어 thread pool 의 thread 를 사용하여 클라이언트 요청을 처리하였습니다.

하지만 위와 같은 방법은 문제점이 있는데요.

1. 클라이언트의 요청이 증가함에 따라(이를 처리하는 thread의 수가 증가) memory 사용량 증가

2. 여러개의 thread 를 처리함에 있어서 over head(context switching) 증가

3. CPU 의 유휴

<br>

여기서 주의깊게 살펴봐야 하는 부분은 **3.CPU의 유휴** 입니다. 

여기서 유휴는 CPU 를 사용하지 않고 놀게 놔둔다(?)를 의미하는데요, 어떻게 하면 CPU 를 최대로 활용할지 고민해도 모자랄판에, 프로세스가 CPU 를 받고도 사용하지 않는다면 이는 큰 *자원낭비*가 됩니다.

아래의 코드를 보겠습니다.

```javascript
const result = DB.query('select * from user') // 동기작업

// waiting.........

doSomething(result)
```

<br>

Thread 가 CPU 를 할당 받으면 DB 에서 데이터를 조회하여 doSomething 함수를 실행할 것입니다. 

근데 만약, CPU를 할당 받은 시간에 아직 DB 에서 값이 조회되지 않았다면 doSomething 함수를 실행할 수 없습니다.

CPU 가 하는 일이라곤 단지 DB 에서 조회한 결과값을 받기를 기다릴 뿐입니다. 이는 곧 *CPU 낭비*가 되겠죠. 

node.js는 이런 낭비되는 CPU 를 줄이며, 기존과 다른 방법으로 접근합니다.

<br>

클라이언트 요청마다 매번 thread 를 만드는 것이 아닌 single thread 를 사용하여 각 클라이언트 요청을 처리합니다. 

single thread 를 하기 때문에 많은 thread 를 사용하는 것보다는 memory 를 덜 사용하고, context switching 의 빈도수가 적을 것입니다. 

또한 race condition 문제도 덜 하겠죠. 

대신 single thread 를 사용하기 때문에 시간이 오래 걸리는 작업을 처리하면 다른 클라이언트 요청을 처리하지 못할 것입니다. 이는 이후에 살펴볼 libuv 에서 살펴 보겠습니다.

<br>

## node.js가 말하는 single thread

node.js를 사용하는 사람이라면 누구나 node.js 가 single thread 라는 것을 알고 있을 것입니다. 

하지만, node.js 는 single thread 가 아니라 내부적으로 여러개의 thread 를 사용하고 있다고도 하는데요, 사실 둘다 맞는 말입니다.

<br>

node.js가 single thread 라는 것은 event loop 가 single thread 라는 것을 의미하며, 내부적으로 여러개의 thread 를 사용한다고 하는 것은 **`libuv 의 thread pool`** 을 의미합니다. 

뭐 어쨌든 node.js는 single thread 입니다. 진짜 그런지 눈으로 확인해보죠.

```javascript
...
router.get("/test", function (req, res, next) {
  const start = Date.now();

  while (Date.now() < start + 5000) {}
  res.json({ test: "after 5s" });
  ...
});
```

/test로 요청을 보내면 5초후에 응답을 보냅니다.

n개의 요청을 보냈을 때 만약 event loop 가 정말 single thread 라면 각각의 요청은 이전의 요청시간 +5s만큼의 시간이 걸릴 것입니다.

(2개의 탭을 띄어놓고 거의 동시에 요청을 보냄)

![image](https://github.com/lielocks/WIL/assets/107406265/6bc2bb2c-a932-4de6-9bb4-e63befdedd0d)

결과를 보면 첫번째 요청을 5.00s, 두번째 요청은 9.64s 만에 응답이 왔습니다. 

만약 node.js, 즉 event loop 가 single thread 가 아니라면 두개의 요청을 모두 5.00s 가 걸려야 할 것입니다. 

=> JavaScript 코드 자체가 실행되는 **Event Loop 는 single thread** 입니다

<br>

위의 결과를 보고 생각할 수 있는 점은, Event Loop 를 막으면 안된다는 것입니다. 

즉 첫번째 요청을 모두 처리 한 후에 두번째 요청을 처리하기 때문에(Event Loop -> single thread 이기 때문에), /test에서 너무 오래 걸리는 작업, 예를 들어 `큰 파일을 동기적으로 읽거나, for문 을 10억번 반복하거나` 등의 작업을 하지 않아야 합니다. 

이는 node.js의 공식문서에서 Don't Block the Event Loop 에서 확인할 수 있습니다.

<br> 

지금까지의 내용을 정리해보면, node.js 는 기존의 방법과는 다른 single thread 를 사용하여 클라이언트 요청을 처리하며 `context switching, memory의 과사용, race condition, cpu 의 유휴 처리` 에서 이점이 있습니다.

<br>

## node.js는 여러개의 thread를 사용한다.

생각해보면 node.js 가 정말 single thread 만 사용한다면 아무도 node.js 에 관심을 주지 않을 것입니다. 

만약 정말로 /test 에서 10초가 걸리는 작업이 있을 때는 어떻게 할까요. 

이를 CPU intensive 한 작업이라고 하는데요, 

node.js 묘듈중에 대표적으로 `crypto 모듈`이 있습니다. 

pbkdf2 method 는 시간이 오래 걸리는 작업이므로 event loop 에서 작업을 처리하면 다른 요청은 아주 오래 기다려야 할 것입니다. 

<br>

node.js 는 내부적으로 **libuv 에 thread pool** 를 가지고 있으며(기본 4개), 시간이 오래 걸리는 작업은 thread pool 에서 처리하고 있습니다. 

이번에는 /test 를 호출하여 응답 시간을 측정하는 것이 아닌 pbkdf2 작업의 완료시간을 측정하겠습니다.

```javascript
router.get('/test', function(req, res, next) {
  const start = Date.now()
  crypto.pbkdf2('a', 'b', 500000, 512, 'sha512', () => {
    console.log(`pbkdf2 completed  : ${Date.now() - start}`)
  })
  res.send('crypto pbkdf2')
})
```

node.js 는 single thread 이기 때문에 이전과 마찬가지로 첫번째 요청을 모두 처리하고 두번째 요청을 처리할까요 ?

```
GET /test 304 0.783 ms - -
GET /test 304 0.760 ms - -
pbkdf2 completed  : 2907
pbkdf2 completed  : 2835
```

node.js 의 libuv 는 내부적으로 thread pool 을 사용하고 있으며 CPU intensive 한 작업은 thread pool 에서 처리됩니다. 

그렇기 때문에 *두개의 요청이 모두 같은시간에 처리*가 되는 것이죠.

<br> 

사실 **`default thread pool size 가 4`** 이기 때문에 동시에 처리된 것입니다. 

만약 `process.env.UV_THREADPOOL_SIZE = 1` 로 thread pool 을 수정하면 출력결과는 아래와 같이 됩니다.

```
process.env.UV_THREADPOOL_SIZE = 1

GET /test 304 5.954 ms - -
pbkdf2 completed  : 2937
GET /test 304 2555.791 ms - -
pbkdf2 completed  : 5446
```

가용 thread 가 1개 밖에 없으니깐 첫번째 요청이 thread 를 모두 사용하고 반납하면 2번째 요청이 thread 를 사용하기 때문에 위와 같은 결과가 나오게 됩니다. 

<br>

그러면 thread pool size 를 많이 늘리면 더 좋은거 아냐? 라고 생각할 수도 있지만, 꼭 그렇지 만은 않습니다. 

실제로 thread 를 처리하는 것은 CPU, 즉 물리 core 이기 때문에 **thread 수를 늘리면 그만큼 context switching 이 늘어나기 때문에** 보통 `물리 core 수만큼 thread pool size 설정`하기를 권장하고 있습니다.

<br>

## libuv

![image](https://github.com/lielocks/WIL/assets/107406265/70fc7d1a-67ce-4729-8cb9-615488055625)

애초에 javascript 는 브라우저에서 dom 을 조작하던 녀석 입니다. 

하지만 node.js 의 등장으로 javascript 를 사용하여 파일을 읽을 수 있게 되었습니다(물론 다른 기능도 많음). 

<br>

node.js 는 크게 V8 와 libuv 로 구성되어 있습니다. 

**V8** 은 javascript 코드를 파싱하고 실행하는 javascript engine이고, **libuv** 가 javascript 가 파일을 읽고/쓰고/삭제하고, network I/O, event loop, thread pool..등의 기능을 제공합니다.

<br>

libuv 공식문서를 보면 libuv 를 다음과 같이 소개하고 있습니다.

> libuv is a multi-platform support library with a focus on **asynchronous I/O.** 
>
> It was primarily developed for use by Node.js, but it’s also used by Luvit, Julia, pyuv, and others.

<br>

node.js 에서 libuv 는 다음의 역할을 하고 있습니다.

+ Full-featured event loop backed by epoll, kqueue, IOCP, event ports.
+ Asynchronous TCP and UDP sockets
+ Asynchronous DNS resolution
+ Asynchronous file and file system operations
+ File system events
+ ANSI escape code controlled TTY
+ IPC with socket sharing, using Unix domain sockets or named pipes (Windows)
+ Child processes
+ Thread pool
+ Signal handling
+ High resolution clock
+ Threading and synchronization primitives
 
<br>


libuv 는 기본적으로 `kernel` 에서 지원하고 있는 **비동기 작업** 을 알고 있기 때문에, node.js 에서 파일, DB I/O 작업, 네트워크 I/O을 수행하게 되면, 해당 작업은 kernel API 를 사용하여 처리됩니다. 

이후 작업이 완료되면 해당 이벤트가 event loop 의 phase 에 들어가 처리됩니다.

<br>

이렇게 kernel API 를 사용하지 못하는 경우 thread pool 로 넘기게 되는데, 대표적인 예로 위에서 살펴본 crypty 모듈의 경우 CPU intensive 한 작업이기 때문에 event loop 에서 실행되면 안되며, thread pool에서 처리됩니다. 

반대로 http 모듈을 사용하는 network I/O 의 경우 kernel API 를 사용하기 때문에 http 요청을 할때마다 바로 처리됩니다.

<br>

thread pool에서 처리되는 작업들은 다음과 같습니다.

- file system : fs.FSWatcher()와 synchronous fs 제외

- DNS : dns.lookup(), dns.lookupService()

- Crypto : crypto.pbkdf2(), crypto.scrypt(), crypto.randomBytes(), crypto.randomFill(), ...

- Zlib : synchronous API 제외

- ...


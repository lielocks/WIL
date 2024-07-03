![image](https://github.com/lielocks/WIL/assets/107406265/ca19c97e-cbe1-4835-9c37-aea004133441)

Single thread 기반의 event loop 를 활용하여 처리하는 Node.JS 서버가 있고,

thread pool 이 2개 존재하는 (최대 2개까지 multi thread 를 할당할 수 있는) Spring 서버가 있다고 칩시다.

각각의 서버에 0.1초, 5초, 13초, 7초, 10초가 걸리는 작업(예시)을 아주 작은 텀을 두고 순서대로 요청할 것입니다.

각각의 시간이 발생하는 경우가 연산(직접 구현한 long-time JS코드라 가정)을 요구한다고 가정해봅시다.

그러한 경우, 다음과 같을 것입니다.

<br>

### Spring

![image](https://github.com/lielocks/WIL/assets/107406265/da6316e8-c125-46cb-9d08-6a7384a847b2)

(0.1 -> task a)

요청에 대해서 할당해줄 수 있는 Thread(pool) 가 생기기 전에는 할당이 안되기 때문에, 이미 할당된 thread 에서의 작업이 끝나면 다음 작업들이 할당이 됩니다.

종합적인 시간은 **`22초 + context switching`** 등에서 발생하는 시간(ms 단위)이 됩니다.

<br>

### Node

![image](https://github.com/lielocks/WIL/assets/107406265/2a13fe2e-3d6c-4cf5-a02c-f9111d5dc057)

Single thread 인 event loop 에서 전부 처리하므로 모든 작업을 순차적으로 이어서하는데 걸리는 시간이 발생합니다.

<br>

## 작업의 지연시간이 (I/O, 비동기함수)에 의해 발생하는 경우

각각의 시간이 발생하는 경우가 `I/O(database I/O, setTimeout 이라 가정)` 을 요구한다고 가정해봅시다.

그러한 경우, 다음과 같을 것입니다.

<br>

### Spring

![image](https://github.com/lielocks/WIL/assets/107406265/d02d23ce-8722-48ae-ab86-e5c3f4a71535)

연산 코드와 처리 방식이 동일한 것처럼 보이지만, I/O 와 같은 작업은 요청 처리를 위해 할당받은 thread 가 대기하게 됩니다.

Thread 내에서 사실 연산 + I/O 로 이루어지는데, 한 thread 에서 I/O 와 연산을 동기적으로 처리한다는 뜻입니다.

<br>

### Node (중요)

![image](https://github.com/lielocks/WIL/assets/107406265/2ce0e474-b3e5-43ec-8c93-078252266b56)

libuv 는 multi thread 로 동작하는 라이브러리로 비동기 I/O 를 내보내고, callback 으로 신호를 받아오기 때문에, 빠르게 I/O가 종료되는 순으로 처리가 가능합니다.

>  I/O 작업이 완료되면, 해당 thread 는 callback 함수를 event loop 에 반환합니다. Event loop 는 이 callback 을 받아서 실행합니다.

(이해를 위한 그림일 뿐, 저렇게 동작하지는 않습니다.)

<br>

## 그러면, Node 의 I/O 처리해주는 libuv 의 multi thread 갯수와, Spring의 multi thread 갯수가 같으면 성능이 똑같은 것이 아닐까? 

하지만, Node 가 완전히 비동기적으로 I/O'만' 을 처리할 수 있다는 점이 의미하는 바는,

I/O 에 관한 모든 multi thread(libuv) 가 동작 중에 있더라도, `단순 연산 or 요청(event loop 에서 처리되는 코드)` 을 처리할 수 있다는 점입니다.

Spring 은 그게 안 됩니다. 이를 예시를 들어 시각화해서 보여드리겠습니다.

<br>

### Spring

![image](https://github.com/lielocks/WIL/assets/107406265/5405b30b-0dee-4b89-bf64-d2f6b0ac7f3a)

Spring 은 사용중인 모든 thread 가 I/O 처리 중이라면, I/O 가 끝나기 전까지 non I/O 요청이라도 처리할 수 없습니다.

<br>

### Node

![image](https://github.com/lielocks/WIL/assets/107406265/e2911c50-2e92-419f-8a66-23bde75e0724)

Node 는 I/O 를 처리하기 위한 모든 Multi thread 가 사용 중이더라도, Spring 과는 달리 비동기로 동작하는 외부 thread(인 느낌)입니다.

독립적인 외부 I/O 처리 Thread(libuv의 thread) 에서 다시 Main single thread 로 신호를 보내줄 때까지, 그 사이에 Main thread 에서 non I/O 에 대한 요청이 처리가 가능합니다.

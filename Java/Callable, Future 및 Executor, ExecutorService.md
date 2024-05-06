이번에는 자바5 부터 Multi Thread 기반의 동시성 프로그래밍을 위해 추가된 Executor, ExecutorService, ScheduledExecutorService와 Callable, Future를 살펴보도록 하겠습니다.

<br>


## 1. Callable 과 Future 인터페이스에 대한 이해 및 사용법

### [Thread 와 Runnable 의 단점 및 한계]

Thread와 Runnable을 직접 사용하는 방식은 다음과 같은 한계점이 있다. 

+ 지나치게 저수준의 API(쓰레드의 생성)에 의존함

+ 값의 반환이 불가능

+ 매번 thread 생성과 종료하는 오버헤드가 발생

+ thread 들의 관리가 어려움

 
먼저 thraed 를 어떻게 만드는지는 애플리케이션 개발자의 관심과는 거리가 먼데, Thread와 Runnable를 통한 thread 의 생성과 실행은 *너무 저수준의 API* 를 필요로 한다. 

그리고 thread 의 작업이 끝난 후 결과를 반환받는 것도 불가능하다. 

또한 thread 를 사용하려면 항상 새롭게 thread 를 생성해야 하는데, 이는 비용이 많이 드는 작업이며 직접 thread 를 만드는 만큼 관리 역시 어렵다. 

그래서 Java는 쓰레드를 위한 기술들을 꾸준히 발전시키고 있는데, 먼저 Java5에서 **결과를 반환하도록 추가된 Callable과 Future** 를 알아보도록 하자.

<br>


### [Callable 인터페이스]

기존의 Runnable 인터페이스는 **결과를 반환할 수 없다** 는 한계점이 있었다.

반환값을 얻으려면 공용 메모리나 pipe 등을 사용해야 했는데, 이러한 작업은 상당히 번거롭다.

그래서 *Runnable 의 발전된 형태* 로써, Java5 에 함께 추가된 **generic 을 사용해 결과를 받을 수 있는 `Callable`** 이 추가되었다.

```java
@FunctionalInterface
public interface Callable<V> {
    V call() throws Exception;
}
```

<br>


### [Future 인터페이스]

*Callable 인터페이스의 구현체인 작업(Task)* 은 가용 가능한 thread 가 없어서 실행이 미뤄질 수 있고, 작업 시간이 오래 걸릴 수도 있다. 

그래서 `실행 결과를 바로 받지 못하고 미래의 어느 시점에 얻을 수 있는데,` **미래에 완료된 Callable 의 반환값** 을 구하기 위해 사용되는 것이 **`Future`** 이다. 

즉, Future는 **비동기 작업** 을 갖고 있어 미래에 실행 결과를 얻도록 도와준다. 

이를 위해 비동기 작업의 `현재 상태를 확인하고, 기다리며, 결과를 얻는 방법` 등을 제공한다. 

Future 인터페이스는 다음과 같은데, 각각의 메소드들에 대해 살펴보도록 하자.

```java
public interface Future<V> {

    boolean cancel(boolean mayInterruptIfRunning);

    boolean isCancelled();

    boolean isDone();

    V get() throws InterruptedException, ExecutionException;

    V get(long timeout, TimeUnit unit)
        throws InterruptedException, ExecutionException, TimeoutException;
}
```

<br>

+ get

  + 블로킹 방식으로 결과를 가져옴

  + 타임아웃 설정 가능


+ isDone, isCancelled

  + isDone은 작업의 완료 여부, isCancelled는 작업의 취소 여부를 반환함

  + 완료 여부를 boolean으로 반환

+ cancel

  + 작업을 취소시키며, 취소 여부를 boolean으로 반환함

  + cancle 후에 isDone()는 항상 true를 반환함

<br>

 
cancle 의 파라미터로는 boolean 값을 전달할 수 있는데, **true** 를 전달하면 `thread 를 interrupt 시켜 InterrepctException` 을 발생시키고 **false** 를 전달하면 `진행중인 작업이 끝날때까지 대기` 한다. 

cancle 은 작업이 이미 정상적으로 완료되어 취소할 수 없는 경우에는 false를, 그렇지 않으면 true를 반환한다. 

그 외에도 작업이 이미 취소되었거나 취소가 불가능한 경우에도 false가 반환될 수 있다.
 
<br>

 
아래의 코드는 3초가 걸리는 작업의 결과를 얻기 위해 get을 호출하고 있다. 

get은 결과를 기다리는 블로킹 요청이므로 아래의 실행은 적어도 3초가 걸리며, 작업이 끝나고 isDone 이 true가 되면 아래의 실행은 종료된다. 

그 외에도 다양한 예시 코드들을 작성해두었는데, 나머지는 깃허브에서 참고하도록 하자.


```java
@Test
void future() {
    ExecutorService executorService = Executors.newSingleThreadExecutor();

    Callable<String> callable = new Callable<String>() {
        @Override
        public String call() throws InterruptedException {
            Thread.sleep(3000L);
            return "Thread: " + Thread.currentThread().getName();
        }
    };


    // It takes 3 seconds by blocking(블로킹에 의해 3초 걸림)
    Future<String> future = executorService.submit(callable);

    System.out.println(future.get());

    executorService.shutdown();
}
```

<br>


## 2. Executors, Executor, ExecutorService 등에 대한 이해 및 사용법

Java5 에는 thread 의 생성과 관리를 위한 Thread pool 을 위한 기능들도 추가되었는데, 

이번에는 Thread Pool 을 위한 Executor, ExecutorService, ScheduledExecutorService와 Thread Pool 생성을 도와주는 팩토리 클래스인 Executor까지 살펴보도록 하자.

![image](https://github.com/lielocks/WIL/assets/107406265/3b0dc068-b6bc-4123-bd71-c2f3ac17b4a6)

<br>


### [Executor 인터페이스]

*동시에 여러 요청을 처리해야 하는 경우에 매번 새로운 thread 를 만드는 것은 비효율적* 이다. 

그래서 `thread 를 미리 만들어두고 재사용` 하기 위한 **쓰레드 풀(Thread Pool)** 이 등장하게 되었는데, **`Executor`** 인터페이스는 **Thread Pool 의 구현** 을 위한 인터페이스이다. 

이러한 Executor 인터페이스를 간단히 정리하면 다음과 같다.

+ 등록된 작업(Runnable)을 실행하기 위한 인터페이스

+ 작업 등록과 작업 실행 중에서 작업 실행만을 책임짐

<br>

 
thraed 는 크게 **작업의 등록** 과 **실행** 으로 나누어진다. 

그 중에서도 Executor 인터페이스는 **`인터페이스 분리 원칙(Interface Segregation Principle)`** 에 맞게 **등록된 작업을 실행하는 책임만** 갖는다. 

그래서 **전달받은 작업(Runnable)을 실행하는 메소드만** 가지고 있다.

```java
public interface Executor {

   void execute(Runnable command);

}
```

<br>


Executor 인터페이스는 개발자들이 해당 작업의 실행과 thread 의 사용 및 scheduling 등으로부터 벗어날 수 있도록 도와준다. 

단순히 전달받은 Runnable 작업을 사용하는 코드를 Executor로 구현하면 다음과 같다.

```java
@Test
void executorRun() {
    final Runnable runnable = () -> System.out.println("Thread: " + Thread.currentThread().getName());

    Executor executor = new RunExecutor();
    executor.execute(runnable);
}

static class RunExecutor implements Executor {

    @Override
    public void execute(final Runnable command) {
        command.run();
    }
}
```

<br>


하지만 위와 같은 코드는 단순히 객체의 메소드를 호출하는 것이므로, 새로운 thread 가 아닌 `main thread` 에서 실행이 된다. 

만약 위의 코드를 새로운 thread 에서 실행시킬면 Executor의 execute 메소드를 다음과 같이 수정하면 된다. 

```java
@Test
void executorRun() {
    final Runnable runnable = () -> System.out.println("Thread: " + Thread.currentThread().getName());

    Executor executor = new StartExecutor();
    executor.execute(runnable);
}

static class StartExecutor implements Executor {

    @Override
    public void execute(final Runnable command) {
        new Thread(command).start();
    }
}
```

<br>


### [ExecutorService 인터페이스]

**`ExecutorService`** 는 **작업(Runnable, Callable) 등록** 을 위한 인터페이스이다. 

ExecutorService는 Executor를 상속받아서 작업 등록 뿐만 아니라 **`실행을 위한 책임`** 도 갖는다. 

그래서 ***Thread Pool 은 기본적으로 ExecutorService 인터페이스를 구현*** 한다. 

대표적으로 `ThreadPoolExecutor` 가 ExecutorService의 구현체인데, **ThreadPoolExecutor 내부에 있는 Blocking Queue 에 작업들을 등록** 해둔다.

![image](https://github.com/lielocks/WIL/assets/107406265/85b841a3-4158-4ad0-a852-f06fe25a8efd)


위와 같이 크기가 2인 Thread Pool 이 있다고 하자. 

각각의 thread 는 작업들을 할당받아 처리하는데, 만약 사용가능한 thread 가 없다면 작업은 queue 에 대기하게 된다. 

그러다가 thread 가 작업을 끝내면 다음 작업을 할당받게 되는 것이다.

이러한 **`ExecutorService`** 가 제공하는 퍼블릭 메소드들은 다음과 같이 분류 가능하다.

+ life cycle 관리를 위한 기능들

+ 비동기 작업을 위한 기능들

<br>


**life cycle 관리를 위한 기능들**

**`ExecutorService`** 는 Executor의 상태 확인과 작업 종료 등 life cycle 관리를 위한 메소드들을 제공하고 있다. 
 
+ *shutdown*

  + 새로운 작업들을 더 이상 받아들이지 않음

  + 호출 전에 제출된 작업들은 그대로 실행이 끝나고 종료됨(Graceful Shutdown)

+ *shutdownNow*

  + shutdown 기능에 더해 이미 제출된 작업들을 interrupt 시킴
  
  + 실행을 위해 대기중인 작업 목록(List<Runnable>)을 반환함

+ *isShutdown*

  + Executor의 shutdown 여부를 반환함

+ *isTerminated*

  + shutdown 실행 후 모든 작업의 종료 여부를 반환함

+ *awaitTermination*

  + shutdown 실행 후, 지정한 시간 동안 모든 작업이 종료될 때 까지 대기함

  + 지정한 시간 내에 모든 작업이 종료되었는지 여부를 반환함

<br>


ExecutorService 를 만들어 작업을 실행하면, ***shutdown 이 호출되기 전까지*** `계속해서 다음 작업을 대기` 하게 된다. 

그러므로 *작업이 완료되었다면* **`반드시 shutdown을 명시적으로 호출`** 해주어야 한다. 

```java
@Test
void shutdown() {
    ExecutorService executorService = Executors.newFixedThreadPool(10);
    Runnable runnable = () -> System.out.println("Thread: " + Thread.currentThread().getName());
    executorService.execute(runnable);

    // shutdown 호출
    executorService.shutdown();

    // shutdown 호출 이후에는 새로운 작업들을 받을 수 없음, 에러 발생
    RejectedExecutionException result = assertThrows(RejectedExecutionException.class, () -> executorService.execute(runnable));
    assertThat(result).isInstanceOf(RejectedExecutionException.class);
}
```

<br>


만약 **작업 실행 후에 shtudown 을 해주지 않으면 다음과 같이 프로세스가 끝나지 않고,** 계속해서 다음 작업을 기다리게 된다. 

다음의 메인 메소드를 실행해보면 애플리케이션이 끝나지 않음을 확인할 수 있다.

```java
public static void main(String[] args) {
    ExecutorService executorService = Executors.newFixedThreadPool(10);
    Runnable runnable = () -> System.out.println("Thread: " + Thread.currentThread().getName());
    executorService.execute(runnable);

    executorService.shutdown();
}
```

<br>


shutdown 과 shutdownNow 시에 중요한 것은, 만약 실행중인 작업들에서 interrupt 여부에 따른 처리 코드가 없다면 계속 실행된다는 것이다. 

그러므로 필요하다면 다음과 같이 인터럽트 시에 추가적인 조치를 구현해야 한다.

```java
@Test
void shutdownNow() throws InterruptedException {
    Runnable runnable = () -> {
        System.out.println("Start");
        while (true) {
            if (Thread.currentThread().isInterrupted()) {
                System.out.println("Interrupted");
                break;
            }
        }
        System.out.println("End");
    };

    ExecutorService executorService = Executors.newFixedThreadPool(10);
    executorService.execute(runnable);

    executorService.shutdownNow();
    Thread.sleep(1000L);
}
```

<br>


**비동기 작업을 위한 기능들**

ExecutorService 는 `Runnable과 Callable을 작업으로 사용` 하기 위한 메소드를 제공한다. 

동시에 *여러 작업들을 실행* 시키는 메소드도 제공하고 있는데, **비동기 작업의 진행을 추적할 수 있도록 `Future` 를 반환한다.** 

반환된 Future 들은 모두 실행된 것이므로 반환된 `isDone 은 true` 이다. 

하지만 작업들은 정상적으로 종료되었을 수도 있고, 예외에 의해 종료되었을 수도 있으므로 **항상 성공한 것은 아니다.** 

이러한 **`ExecutorService가 갖는 비동기 작업`** 을 위한 메소드들을 정리하면 다음과 같다.
 

+ *submit*

  + 실행할 작업들을 추가하고, 작업의 상태와 결과를 포함하는 Future를 반환함

  + `Future 의 get` 을 호출하면 성공적으로 작업이 완료된 후 **결과** 를 얻을 수 있음

+ *invokeAll*

  + `모든 결과가 나올 때 까지 대기` 하는 **blocking** 방식의 요청

  + 동시에 주어진 작업들을 모두 실행하고, 전부 끝나면 *각각의 상태와 결과를 갖는 List<Future>을 반환함*

+ *invokeAny*

  + 가장 빨리 실행된 결과가 나올 때 까지 대기하는 blocking 방식의 요청

  + 동시에 주어진 작업들을 모두 실행하고, 가장 빨리 완료된 하나의 결과를 Future로 반환받음

<br>


ExecutorService 의 구현체로는 AbstractExecutorService가 있는데, ExecutorService의 메소드들(submit, invokeAll, invokeAny)에 대한 기본 구현들을 제공한다. 

`invokeAll` 은 **최대 Thread Pool 의 크기만큼 작업을 동시에 실행** 시킨다. 

그러므로 thread 가 충분하다면 동시에 실행되는 작업들 중에서 가장 오래 걸리는 작업만큼 시간이 소요된다. 

하지만 만약 thread 가 부족하다면 대기되는 작업들이 발생하므로 가장 오래 걸리는 작업의 시간에 더해 추가 시간이 필요하다.

```java
@Test
void invokeAll() throws InterruptedException, ExecutionException {
    ExecutorService executorService = Executors.newFixedThreadPool(10);
    Instant start = Instant.now();

    Callable<String> hello = () -> {
        Thread.sleep(1000L);
        final String result = "Hello";
        System.out.println("result = " + result);
        return result;
    };

    Callable<String> mang = () -> {
        Thread.sleep(4000L);
        final String result = "Java";
        System.out.println("result = " + result);
        return result;
    };

    Callable<String> kyu = () -> {
        Thread.sleep(2000L);
        final String result = "kyu";
        System.out.println("result = " + result);
        return result;
    };

    List<Future<String>> futures = executorService.invokeAll(Arrays.asList(hello, mang, kyu));
    for(Future<String> f : futures) {
        System.out.println(f.get());
    }

    System.out.println("time = " + Duration.between(start, Instant.now()).getSeconds());
    executorService.shutdown();
}
```

<br>


`invokeAny` 는 *가장 빨리 끝난 작업 결과만* 을 구하므로, 동시에 실행한 작업들 중에서 가장 짧게 걸리는 작업만큼 시간이 걸린다. 

또한 가장 빠르게 처리된 작업 외의 나머지 작업들은 완료되지 않았으므로 cancel 처리되며, 작업이 진행되는 동안 작업들이 수정되면 결과가 정의되지 않는다. 

```java
@Test
void invokeAny() throws InterruptedException, ExecutionException {
    ExecutorService executorService = Executors.newFixedThreadPool(10);
    Instant start = Instant.now();

    Callable<String> hello = () -> {
        Thread.sleep(1000L);
        final String result = "Hello";
        System.out.println("result = " + result);
        return result;
    };

    Callable<String> mang = () -> {
        Thread.sleep(4000L);
        final String result = "Java";
        System.out.println("result = " + result);
        return result;
    };

    Callable<String> kyu = () -> {
        Thread.sleep(2000L);
        final String result = "kyu";
        System.out.println("result = " + result);
        return result;
    };

    String result = executorService.invokeAny(Arrays.asList(hello, mang, kyu));
    System.out.println("result = " + result + " time = " + Duration.between(start, Instant.now()).getSeconds());

    executorService.shutdown();
}
```

<br>


### [ScheduledExecutorService 인터페이스]

ScheduledExecutorService는 ExecutorService를 상속받는 인터페이스로써, 특정 시간 이후에 또는 주기적으로 작업을 실행시키는 메소드가 추가되었다. 

그래서 특정 시간대에 작업을 실행하거나 주기적으로 작업을 실행하고 싶을때 등에 사용할 수 있다. 

+ *schedule*

  + 특정 시간(delay) 이후에 작업을 실행시킴

+ *scheduleAtFixedRate*

  + 특정 시간(delay) 이후 처음 작업을 실행시킴

  + 작업이 실행되고 특정 시간마다 작업을 실행시킴

+ *scheduleWithFixedDelay*

  + 특정 시간(delay) 이후 처음 작업을 실행시킴

  + 작업이 완료되고 특정 시간이 지나면 작업을 실행시킴


<br>


가장 먼저 scheduleAtFixedRate 를 살펴보도록 하자. 

예를 들어 *1초가 걸리는 작업* 이 있고, *실행 주기(rate)를 2초* 로 설정했다고 하자. 

scheduleAtFixedRate 는 특정 시간마다 작업을 반복시키는 것이므로, 해당 작업은 다음과 같이 실행될 것이다.

1. 0:00 작업 실행

2. 0:01 작업 종료

3. 1초 대기(0:00초에 실행되어 rate가 2초이므로, 0:02초에 실행되어야 함)

4. 0:02 작업 실행

5. 0:03 작업 종료

6. 1초 대기(0:02초에 실행되어 rate가 2초이므로, 0:04초에 실행되어야 함)

7. 0:04 작업 실행

8. 0:05 작업 종료

<br>


scheduleWithFixedDelay는 조금 다르게 실행된다. 

예를 들어 `1초가 걸리는 작업` 이 있고, `실행 텀(delay)를 2초` 로 설정했다고 하자. 

scheduleWithFixedDelay는 이전 작업이 끝나고 나서 특정 시간 이후에 작업을 실행하므로, 실행 결과는 다음과 같을 것이다.

1. 0:00 작업 실행

2. 0:01 작업 종료

3. 2초 delay

4. 0:03 작업 실행

5. 0:04 작업 종료

6. 2초 delay

7. 0:06 작업 실행

8. 0:07 작업 종료

<br>


### [Executors]

앞서 살펴본 `Executor, ExecutorService, ScheduledExecutorService 는 Thread Pool 을 위한 인터페이스` 이다. 

*직접 thread 를 다루는 것은 번거로우므로,* 이를 **도와주는 팩토리 클래스인 `Executors`** 가 등장하게 되었다. 

**Executors** 는 고수준(High-Level) 의 **동시성 프로그래밍 모델** 로써 `Executor, ExecutorService 또는 SchedueledExecutorService 를 구현한 Thread Pool` 을 **손쉽게 생성** 해준다.
 

+ *newFixedThreadPool*

  + 고정된 쓰레드 개수를 갖는 Thread Pool 을 생성함

  + **ExecutorService 인터페이스를 구현한 ThreadPoolExecutor** 객체가 생성됨

+ *newCachedThredPool*

  + 필요할 때 필요한 만큼의 쓰레드를 풀 생성함

  + 이미 생성된 쓰레드가 있다면 이를 재활용 할 수 있음

+ *newScheculedThreadPool*

  + 일정 시간 뒤 혹은 주기적으로 실행되어야 하는 작업을 위한 쓰레드 풀을 생성함

  + ScheduledExecutorService 인터페이스를 구현한 ScheduledThreadPoolExecutor 객체가 생성됨

+ *newSingleThreadExecutor, newSingleThreadScheduledExecutor*

  + **1개의 thread 만을 갖는 Thread Pool** 을 생성함
  
  + 각각 newFixedThreadPool와 newScheculedThreadPool에 1개의 thread 만을 생성하도록 한 것임

<br>


Executors를 통해 thread 의 개수 및 종류를 정할 수 있으며, 이를 통해 thread 생성과 실행 및 관리가 매우 용이해진다. 

하지만 ***Thread Pool 을 생성 시에는 주의*** 해야 한다. 

만약 newFixedThreadPool 을 사용해 2개의 thread 를 갖는 Thread Pool 을 생성했는데, 3개의 작업을 동시에 실행시킨다면 1개의 작업은 실행되지 못한다. 

그러다가 thread 가 작업을 끝내고 반환되어 가용가능한 thread 가 생기면 남은 작업이 실행된다.
 
<br>
 
 
Java5 에서 좋은 기능들이 많이 추가되었지만 `Java5 에 등장한 Future` 는 결과를 얻으려면 **blocking 방식으로 대기** 를 해야 한다는 단점이 있다. 

`Future 에 처리 결과에 대한 callback 을 정의` 하면 이러한 문제를 쉽게 해결할 수 있는데, 이를 보완하여 Java8에 추가된 것이 바로 **`CompletableFuture`** 이다. 


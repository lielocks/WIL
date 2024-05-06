## 1. CompletableFuture에 대한 이해

### [Future 의 단점 및 한계]

Java5 에 Future 가 추가되면서 비동기 작업에 대한 결과값을 반환 받을 수 있게 되었다.

하지만 **Future** 는 다음과 같은 *한계점* 이 있었다.

+ 외부에서 완료시킬 수 없고, get 의 timeout 설정으로만 완료 가능

+ `blocking 코드(get)` 를 통해서만 이후의 결과를 처리할 수 있음

+ 여러 Future를 조합할 수 없음 ex) 회원 정보를 가져오고, 알림을 발송하는 등

+ 여러 작업을 조합하거나 예외 처리할 수 없음

<br>


Future 는 *외부에서 작업을 완료시킬 수 없고,* *작업 완료* 는 오직 `get 호출 시에 timeout 으로만 가능` 하다. 

또한 **비동기 작업의 응답에 추가 작업** 을 하려면 `get` 을 호출해야 하는데, get 은 **`blocking 호출이므로 좋지 않다.`** 

또한 *여러 Future 들을 조합할 수도 없으며,* 예외가 발생한 경우에 이를 위한 *예외처리도 불가능* 하다. 

그래서 Java8 에서는 이러한 문제를 모두 해결한 **CompletableFuture** 가 등장하게 되었다.

<br>


### [CompletableFuture 클래스]

CompletableFuture는 *기존의 Future를 기반으로 외부에서 완료시킬 수 있어서* **CompletableFuture** 라는 이름을 갖게 되었다. 

Future 외에도 **CompletionStage** 인터페이스도 구현하고 있는데, CompletionStage 는 **`작업들을 중첩시키거나 완료 후 callback`** 을 위해 추가되었다. 

예를 들어 Future에서는 불가능했던 "몇 초 이내에 응답이 안 오면 기본값을 반환한다." 와 같은 작업이 가능해진 것이다. 

즉, Future의 진화된 형태로써 외부에서 작업을 완료시킬 수 있을 뿐만 아니라 콜백 등록 및 Future 조합 등이 가능하다는 것이다.

<br>

## 2. CompletableFuture의 기능들 및 예시코드

### [ Future의 단점 및 한계 ]

CompletableFuture 가 갖는 작업의 종류는 크게 다음과 같이 구분할 수 있는데, 이에 대해서는 자세히 코드로 살펴보도록 하자.

+ 비동기 작업 실행

+ 작업 콜백

+ 작업 조합

+ 예외 처리

<br>


**비동기 작업 실행**

+ *runAsync*

  + 반환값이 **없는** 경우
 
  + **비동기** 로 작업 실행 call
 
+ *supplyAsync*

  + 반환값이 **있는** 경우
 
  + **비동기** 로 작업 실행 call
 
<br>

**runAsync** 는 반환값이 없으므로 **`void`** 타입이며, 

아래의 코드를 실행해보면 `future 가 별도의 thread` 에서 실행됨을 확인할 수 있다.

```java
@Test
void runAsync() throws ExecutionException, InterruptedException {
    CompletableFuture<Void> future = CompletableFuture.runAsync(() -> {
        System.out.println("Thread: " + Thread.currentThread().getName());
    });

    future.get();
    System.out.println("Thread: " + Thread.currentThread().getName());
}
```

**supplyAsync** 는 runAsync와 달리 `반환값이 존재` 한다. 

그래서 **비동기 작업** 의 결과를 받아올 수 있다.


```java
@Test
void supplyAsync() throws ExecutionException, InterruptedException {

    CompletableFuture<String> future = CompletableFuture.supplyAsync(() -> {
        return "Thread: " + Thread.currentThread().getName();
    });

    System.out.println(future.get());
    System.out.println("Thread: " + Thread.currentThread().getName());
}
```

<br>


runAsync 와 supplyAsync 는 기본적으로 자바7에 추가된 `ForkJoinPool 의 commonPool()` 을 사용해 작업을 **실행할 thread 를 Thread Pool 로부터 얻어** 실행시킨다. 

만약 원하는 Thread Pool 을 사용하려면, `ExecutorService 를 parameter` 로 넘겨주면 된다. 


<br>


**작업 콜백**

+ *thenApply*

  + 반환 값을 받아서 다른 값을 반환함
 
  + 함수형 인터페이스 Function을 파라미터로 받음

+ *thenAccpet*

  + 반환 값을 받아 처리하고 값을 반환하지 않음

  + 함수형 인터페이스 Consumer를 파라미터로 받음

+ *thenRun*

  + 반환 값을 받지 않고 다른 작업을 실행함
 
  + 함수형 인터페이스 Runnable을 파라미터로 받음

<br>
 
 
Java8 에는 다양한 함수형 인터페이스들이 추가되었는데, CompletableFuture 역시 이들을 callback 으로 등록할 수 있게 한다. 

그래서 비동기 실행이 끝난 후에 전달 받은 작업 callback 을 실행시켜주는데, **thenApply** 는 `값을 받아서 다른 값을 반환` 시켜주는 callback 이다.

```java
@Test
void thenApply() throws ExecutionException, InterruptedException {
    CompletableFuture<String> future = CompletableFuture.supplyAsync(() -> {
        return "Thread: " + Thread.currentThread().getName();
    }).thenApply(s -> {
        return s.toUpperCase();
    });

    System.out.println(future.get());
}
```

<br>


**thenAccept** 는 `반환 값을 받아서 사용하고, 값을 반환하지는 않는` 콜백이다.

```java
@Test
void thenAccept() throws ExecutionException, InterruptedException {
    CompletableFuture<Void> future = CompletableFuture.supplyAsync(() -> {
        return "Thread: " + Thread.currentThread().getName();
    }).thenAccept(s -> {
        System.out.println(s.toUpperCase());
    });

    future.get();
}
```

<br>

 
**thenRun** 은 `반환 값을 받지 않고, 그냥 다른 작업을 실행` 하는 콜백이다. 

```java
@Test
void thenRun() throws ExecutionException, InterruptedException {
    CompletableFuture<Void> future = CompletableFuture.supplyAsync(() -> {
        return "Thread: " + Thread.currentThread().getName();
    }).thenRun(() -> {
        System.out.println("Thread: " + Thread.currentThread().getName());
    });

    future.get();
}
```
 
<br>
 
 
**작업 조합**

+ *thenCompose*

  + `두 작업이 이어서 실행` 하도록 조합하며, **앞선 작업의 결과를 받아서 사용** 할 수 있음

  + 함수형 인터페이스 Function 을 파라미터로 받음

+ *thenCombine*

  + 두 작업을 독립적으로 실행하고, `둘 다 완료되었을 때` callback 을 실행함

  + 함수형 인터페이스 Function 을 parameter 로 받음

+ *allOf*

  + 여러 작업들을 **동시** 에 실행하고, `모든 작업 결과에 콜백` 을 실행함

+ *anyOf*

  + 여러 작업들 중에서 `가장 빨리 끝난 하나의 결과에 콜백` 을 실행함

<br>


아래에서 살펴볼 thenCompose와 thenCombine 예제의 실행 결과는 같지만 동작 과정은 다르다. 

먼저 **thenCompose** 를 살펴보면 hello Future가 먼저 실행된 후에 ***반환된 값을 매개변수로 다음 Future를 실행** 한다.

```java
@Test
void thenCompose() throws ExecutionException, InterruptedException {
    CompletableFuture<String> hello = CompletableFuture.supplyAsync(() -> {
        return "Hello";
    });

    // Future 간에 연관 관계가 있는 경우
    CompletableFuture<String> future = hello.thenCompose(this::mangKyu);
    System.out.println(future.get());
}

private CompletableFuture<String> mangKyu(String message) {
    return CompletableFuture.supplyAsync(() -> {
        return message + " " + "MangKyu";
    });
}
```

<br>


하지만 **thenCombine** 은 각각의 작업들이 `독립적` 으로 실행되고, 얻어진 두 결과를 조합해서 작업을 처리한다.

```java
@Test
void thenCombine() throws ExecutionException, InterruptedException {
    CompletableFuture<String> hello = CompletableFuture.supplyAsync(() -> {
        return "Hello";
    });

    CompletableFuture<String> mangKyu = CompletableFuture.supplyAsync(() -> {
        return "MangKyu";
    });

    CompletableFuture<String> future = hello.thenCombine(mangKyu, (h, w) -> h + " " + w);
    System.out.println(future.get());
}
```

<br>


그 다음은 **allOf** 와 **anyOf** 를 살펴볼 차례이다. 

아래의 코드를 실행해보면 모든 결과에 callback 이 적용됨을 확인할 수 있다.

```java
@Test
void allOf() throws ExecutionException, InterruptedException {
    CompletableFuture<String> hello = CompletableFuture.supplyAsync(() -> {
        return "Hello";
    });

    CompletableFuture<String> mangKyu = CompletableFuture.supplyAsync(() -> {
        return "MangKyu";
    });

    List<CompletableFuture<String>> futures = List.of(hello, mangKyu);

    CompletableFuture<List<String>> result = CompletableFuture.allOf(futures.toArray(new CompletableFuture[futures.size()]))
            .thenApply(v -> futures.stream().
                    map(CompletableFuture::join).
                    collect(Collectors.toList()));

    result.get().forEach(System.out::println);
}
```

<br>


반면에 **anyOf** 의 경우에는 가장 빨리 끝난 1개의 작업에 대해서만 콜백이 실행됨을 확인할 수 있다. 

```java
@Test
void anyOf() throws ExecutionException, InterruptedException {
    CompletableFuture<String> hello = CompletableFuture.supplyAsync(() -> {
        try {
            Thread.sleep(1000L);
        } catch (InterruptedException e) {
            throw new RuntimeException(e);
        }

        return "Hello";
    });

    CompletableFuture<String> mangKyu = CompletableFuture.supplyAsync(() -> {
        return "MangKyu";
    });

    CompletableFuture<Void> future = CompletableFuture.anyOf(hello, mangKyu).thenAccept(System.out::println);
    future.get();
}
```

<br>


**예외 처리**

+ *exeptionally*

  + 발생한 에러를 받아서 예외를 처리함

  + 함수형 인터페이스 Function을 파라미터로 받음

+ *handle, handleAsync*

  + (결과값, 에러)를 반환받아 에러가 발생한 경우와 아닌 경우 모두를 처리할 수 있음

  + 함수형 인터페이스 BiFunction을 파라미터로 받음

<br>


각각에 대해 throw 하는 경우와 throw 하지 않는 경우를 모두 실행시켜보도록 하자. 

아래의 @ParameterizedTest 는 동일한 테스트를 다른 parameter 로 여러 번 실행할 수 있도록 도와주는데, 

실행해보면 `throw 여부` 에 따라 실행 결과가 달라짐을 확인할 수 있다.

```java
@ParameterizedTest
@ValueSource(booleans =  {true, false})
void exceptionally(boolean doThrow) throws ExecutionException, InterruptedException {
    CompletableFuture<String> future = CompletableFuture.supplyAsync(() -> {
        if (doThrow) {
            throw new IllegalArgumentException("Invalid Argument");
        }

        return "Thread: " + Thread.currentThread().getName();
    }).exceptionally(e -> {
        return e.getMessage();
    });

    System.out.println(future.get());
}

java.lang.IllegalArgumentException: Invalid Argument
// Thread: ForkJoinPool.commonPool-worker-19
```

<br>


마찬가지로 handle을 실행해보면 throw 여부에 따라 실행 결과가 달라짐을 확인할 수 있다. 

```java
@ParameterizedTest
@ValueSource(booleans =  {true, false})
void handle(boolean doThrow) throws ExecutionException, InterruptedException {
    CompletableFuture<String> future = CompletableFuture.supplyAsync(() -> {
        if (doThrow) {
            throw new IllegalArgumentException("Invalid Argument");
        }

        return "Thread: " + Thread.currentThread().getName();
    }).handle((result, e) -> {
        return e == null
                ? result
                : e.getMessage();
    });

    System.out.println(future.get());
}
```

그 외에도 아직 완료되지 않았으면 get을 바로 호출하고, 실패 시에 주어진 exception을 던지게 하는 completeExceptionally와

강제로 예외를 발생시키는 obtrudeException과 예외적으로 완료되었는지를 반환하는 isCompletedExceptionally 등과 같은 기능들도 있으니, 

관련해서는 추가적으로 살펴보도록 하자.


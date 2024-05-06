## Future

Java5 부터 사용되던 Future 인터페이스는 `java.util.concurrency` 패키지에서 **비동기** 작업의 결과 값을 받는 용도로 사용했다.

하지만 **여러 Future 의 결괏값을 조합하거나, 예외를 효과적으로 핸들링할 수가 없었다.**

그리고 Future 는 ***오직 get 호출로만 작업 완료*** 가 가능한데, **`get 은 작업이 완료될 때까지 대기하는 blocking 호출`** 이므로 비동기 작업 응답에 추가 작업을 하기 적합하지 않다.


```java
public interface Future<V> {
    ...
    V get() throws InterruptedException, ExecutionException;

    V get(long timeout, TimeUnit unit) throws InterruptedException, ExecutionException, TimeoutException;
}
```

+ get() : 작업이 **완료될 때까지 대기**

+ get(long timeout, TimeUnit unit) : *작업이 완료될때까지* **설정한 시간 동안 대기** 하며, 시간 내 작업 미완료 시 `TimeoutException` 발생

<br>


## CompletableFuture

Java8 에서는 이러한 문제들을 모두 해결한 CompletabelFuture 가 소개되었다.

```java
public class CompletableFuture<T> implements Future<T>, CompletionStage<T> {
    ...
}
```

CompletableFuture 클래스는 **`Future`** 인터페이스를 구현함과 동시에 **`CompletionStage`** 인터페이스를 구현한다.

**`CompletionStage`** 의 특징을 살펴보면 *CompletableFuture 의 장점* 을 알 수 있다.

<br>


> **CompletionStage 는 결국은 계산이 완료될 것이라는 의미의 약속이다.**

`계산의 완료` 는 단일 단계의 완료뿐만 아니라 *다른 여러 단계* 혹은 *다른 여러 단계 중의 하나* 로 이어질 수 있음도 포함한다. 

또한, *각 단계* 에서 발생한 에러를 관리하고 전달할 수 있다.

※ **비동기 연산 Step** 을 제공해서 chaining 형태로 조합이 가능하며, 완료 후 callback 이 가능하다.

<br>


### 기본적인 사용 방법

**-runAsync**

반환 값이 `없는` 경우 비동기 작업 실행

```java
CompletableFuture<Void> cf = CompletableFuture.runAsync(() -> System.out.println("Hello World!"));
cf.join(); // Hello World!
```

runAsync() 는 Runnable 타입을 parameter 로 전달하기 때문에 **어떤 결과 값을 담지 않는다.**

<br>


**-supplyAsync**

반환 값이 `있는` 경우 비동기 작업 실행

```java
CompletableFuture<String> cf = CompletableFuture.supplyAsync(() ->  "Hello World!");
System.out.println(cf.join()); // Hello World!
```

반면, supplyAsync() 는 supplier 타입을 넘기기 때문에 반환 값이 존재한다.

<br>


또한, 결과를 get() 또는 join() 메소드로 가져올 수 있는데 각 차이점은 다음과 같다.

+ get() : Future 인터페이스에 정의된 메서드로 **checked exception** 인 **`InterruptedException`** 과 **`ExecutionException`** 을 던지므로 예외 처리 로직이 반드시 필요하다.

+ join() - CompletableFuture에 정의되어 있으며, **checked exception** 을 발생시키지 않는 대신 **unchecked `CompletionException`** 이 발생된다.

일반적으로 join()을 사용하는 것이 권장되지만, *예외 처리에 대한 추가 로직* 이 필요할 때 혹은 *timeout 설정* 을 해야 하는 경우 `get()` 을 사용하자.

runAsync 와 supplyAsync 는 기본적으로 `ForkJoinPool 의 commonPool()` 을 사용해 작업을 실행한 thread 를 Thread Pool 로부터 얻어 실행시킨다. 

만약 원하는 Thread Pool 을 사용하려면, ExecutorService 를 parameter 로 넘겨주면 된다.


> **작업 콜백**
> 
> 비동기 실행이 끝난 후에 다음과 같이 chaining 형태로 작성하여 전달 받은 작업 콜백을 실행시켜 준다.

<br>


**-thenApply**

`함수형 인터페이스 Function` 타입을 parameter 로 받으며, 반환 값을 받아서 다른 값을 반환해주는 콜백이다.

thenApply 는 **앞선 계산의 결과** 를 콜백 함수로 전달된 Function을 실행한다.

```java
CompletableFuture<String> cf = CompletableFuture.supplyAsync(() -> {
    return "hello world!";
}).thenApply(s -> {
    return s.toUpperCase();
});
System.out.println(cf.join()); // HELLO WORLD!
```

<br>


**-thenAccpet**

`함수형 인터페이스 Consumer` 를 parameter 로 받으며, **반환 값을 받아 처리하고 값을 반환하지 않는** 콜백이다.

```java
CompletableFuture<Void> cf = CompletableFuture.supplyAsync(() -> {
    return "hello world!";})
.thenAccept(System.out::println);

cf.join(); // hello world!
```

<br>


**-thenRun**

`함수형 인터페이스 Runnable` 을 parameter 로 받으며, 반환 값을 받지 않고 그냥 다른 작업을 처리하고 값을 반환하지 않는 콜백이다.

```java
CompletableFuture<Void> cf = CompletableFuture.supplyAsync(() -> {
    return "hello world!";
}).thenRun(() -> System.out.println("hello coco world!"));

cf.join(); // hello coco world!;
```

<br>


### 비동기 작업 콜백

**-thenApplyAsync**

앞선 계산의 결과를 콜백 함수로 전달된 Function 을 별도의 thread 에서 비동기적으로 실행한다.

```java
CompletableFuture<String> cf = CompletableFuture.supplyAsync(() -> {
    return "hello world!";
}).thenApplyAsync(s -> {
    return s.toUpperCase();});
System.out.println(cf.join()); // HELLO WORLD!
```

<br>


**-thenAcceptAsync**

앞선 계산의 결과를 콜백 함수로 전달된 Consumer 를 별도의 thread 에서 비동기적으로 실행한다.

```java
CompletableFuture<Void> cf = CompletableFuture.supplyAsync(() -> {
return "hello world!";
}).thenAcceptAsync(System.out::println); 

cf.join(); // hello world!
```

<br>


**-thenRunAsync**

앞선 계산의 결과와 상관없이 주어진 작업을 별도의 thread 에서 비동기적으로 실행한다.

```java
CompletableFuture<Void> cf = CompletableFuture.supplyAsync(() -> {
    return "hello world!";
}).thenRunAsync(() -> System.out.println("hello coco world!"));

cf.join(); // hello coco world!
```


※ xxxAsync 가 붙은 메소드는 기본적으로 `ForkJoinPool의 commonPool` 을 사용하며, 두 번째 인수를 받는 오버로드 메소드에서 다른 Thread Executor를 선택적으로 사용할 수도 있다.
 
비동기 작업 콜백 메소드들은 주로 병렬로 수행되는 작업이나 I/O 작업과 같이 시간이 오래 걸리는 작업을 할 때 유용하게 활용된다.

<br>


### 다른 비동기 작업과 조합하기

**-thenCompose**

두 작업을 이어서 실행하도록 조합하며, 앞선 작업의 결과를 받아서 사용할 수 있다.

함수형 인터페이스 Function 을 parameter 로 받는다.

```java
CompletableFuture<String> hello = CompletableFuture.supplyAsync(() -> {
    return "Hello";
});

CompletableFuture<String> helloWorld = hello.thenCompose(this::world);

System.out.println(helloWorld.join()); // Hello World!

private CompletableFuture<String> world(String message) {
    return CompletableFuture.supplyAsync(() -> {
      return message + " " + "World!";
    });
}
```

<br>


**-thenCombine**

각 작업을 독립적으로 실행하고, 모두 완료되었을 때 결과를 받아서 사용할 수 있다.

함수형 인터페이스 Function 을 parameter 로 받는다.

```java
CompletableFuture<String> hello = CompletableFuture.supplyAsync(() -> {
    return "Hello";
});

CompletableFuture<String> world = CompletableFuture.supplyAsync(() -> {
    return "World!";
});

CompletableFuture<String> cf = hello.thenCombine(world, (h, w) -> h + " " + w);

System.out.println(cf.join()); // Hello World!
```

<br>


**-allOf**

여러 작업들을 **동시에** 실행하고, **모든 작업 결과에 콜백** 을 실행한다.

```java
CompletableFuture<String> hello = CompletableFuture.supplyAsync(() -> {
    return "Hello";
});

CompletableFuture<String> world = CompletableFuture.supplyAsync(() -> {
    return "World!";
});

List<CompletableFuture<String>> futures = List.of(hello, world);

CompletableFuture<List<String>> result = CompletableFuture.allOf(futures.toArray(new CompletableFuture[futures.size()]))
    .thenApply(v -> futures.stream()
        .map(CompletableFuture::join)
        .collect(Collectors.toList()));

System.out.println(result.join()); // [Hello, World!]

result.join().forEach(System.out::println);
// Hello
// World!
```

<br>


**-anyOf**

여러 작업들 중에 **가장 빨리 끝난 하나** 의 결과에 콜백을 실행한다.

```java
CompletableFuture<String> hello = CompletableFuture.supplyAsync(() -> {
    try {
        Thread.sleep(100);
    } catch (InterruptedException e) {} 

    return "Hello";
});

CompletableFuture<String> world = CompletableFuture.supplyAsync(() -> {
    return "World!";}
);

CompletableFuture<Void> anyOfFuture = CompletableFuture.anyOf(hello, world)
    .thenAccept(System.out::println);

anyOfFuture.join(); // World!
```

<br>


### Error Handling

*Future 에서 에러 핸들링 할 수 없던 문제* 를 CompletableFuture는 어떻게 해결했는지 알아보자.
 
**-exceptionally**

발생한 에러를 받아서 예외를 처리한다.

함수형 인터페이스 Function 을 파라미터로 받는다.

```java
CompletableFuture<String> cf = CompletableFuture.supplyAsync(() -> {
    int divisionByZero = 2 / 0;
    return "success";
}).exceptionally(e -> { // e is wrapped with CompletionException
    return e.toString();
});

System.out.println(cf.join()); // java.util.concurrent.CompletionException: java.lang.ArithmeticException: / by zero
```

<br>


**-handle**

(결과값, 에러)를 반환받아 에러가 발생한 경우와 아닌 경우 모두를 처리할 수 있다.

함수형 인터페이스 BiFunction을 파라미터로 받는다.

```java
CompletableFuture<String> cf = CompletableFuture.supplyAsync(() -> {
    int divisionByZero = 2 / 0;
    return "success";
}).handle((result, e) -> { // e is wrapped with CompletionException
    return e == null ? result : e.toString();
});;

System.out.println(cf.join()); // java.util.concurrent.CompletionException: java.lang.ArithmeticException: / by zero
```

<br>
 
여기까지 비동기 처리를 위한 CompletableFuture 사용 방법에 대해 알아보았고, 다음 글에 이어서 ThreadPoolTaskExecutor 설정으로 보다 효과적으로 비동기 처리 하는 방법을 알아보도록 하자.
출처: https://dev-coco.tistory.com/185 [슬기로운 개발생활:티스토리]

# 1. Thread와 Runnable에 대한 이해 및 사용법

### [ 쓰레드와 자바의 멀티 쓰레드 ] ###

쓰레드란 프로그램 실행의 가장 작은 단위이다. 일반적으로 자바 애플리케이션을 만들어 실행하면 1개의 메인(main) 쓰레드에 의해 프로그램이 실행된다. 하지만 1개의 쓰레드 만으로는 동시에 여러 작업을 할 수 없다. 동시에 여러 작업을 처리하고 싶다면, 별도의 쓰레드를 만들어 실행시켜줘야 하는데, 자바는 멀티 쓰레드 기반으로 동시성 프로그래밍을 지원하기 위한 방법들을 계속해서 발전시켜 왔다.
그 중에서 Thread와 Runnable은 자바 초기부터 멀티 쓰레드를 위해 제공되었던 기술인데, 이 두가지에 대해 먼저 알아보도록 하자.
 
![image](https://github.com/lielocks/WIL/assets/107406265/cac0f604-5b4b-4a48-8e1a-4aafbac0ca37)


### [ Thread 클래스 ] ###

Thread는 쓰레드 생성을 위해 Java에서 미리 구현해둔 클래스이다. Thread는 기본적으로 다음과 같은 메소드들을 제공한다.

+ sleep

  + 현재 쓰레드 멈추기
  + 자원을 놓아주지는 않고, 제어권을 넘겨주므로 데드락이 발생할 수 있음


+ interupt

  + 다른 쓰레드를 깨워서 interruptedException 을 발생시킴
  + Interupt가 발생한 쓰레드는 예외를 catch하여 다른 작업을 할 수 있음


+ join

  + 다른 쓰레드의 작업이 끝날 때 까지 기다리게 함
  + 쓰레드의 순서를 제어할 때 사용할 수 있음


Thread 클래스로 쓰레드를 구현하려면 이를 상속받는 클래스를 만들고, 내부에서 run 메소드를 구현해야 한다. 
그리고 Thread의 start 메소드를 호출하면 run 메소드가 실행된다. 실행 결과를 보면 main 쓰레드가 아닌 별도의 쓰레드에서 실행됨을 확인할 수 있다.



```java
@Test
void threadStart() {
    Thread thread = new MyThread();

    thread.start();
    System.out.println("Hello: " + Thread.currentThread().getName());
}

static class MyThread extends Thread {
    @Override
    public void run() {
        System.out.println("Thread: " + Thread.currentThread().getName());
    }
}

// 출력 결과
// Hello: main
// Thread: Thread-2
```



여기서 run을 직접 호출하는 것이 아니라 **start를 호출**하는 것에 주의해야 한다. 우리는 해당 메소드의 실행을 별도의 쓰레드로 하고 싶은 것인데, run을 직접 호출하는 것은 메인 쓰레드에서 객체의 메소드를 호출하는 것에 불과하다. 
이를 별도의 쓰레드로 실행시키려면 JVM의 도움이 필요하다. 그래서 start를 호출하는 것인데, start 메소드를 자세히 살펴보도록 하자.


```java
public synchronized void start() {
    if (threadStatus != 0)
        throw new IllegalThreadStateException();

    group.add(this);

    boolean started = false;
    try {
        start0();
        started = true;
    } finally {
        try {
            if (!started) {
                group.threadStartFailed(this);
            }
        } catch (Throwable ignore) {
        
        }
    }
}
```



위의 코드를 보면 알 수 있듯이 start는 크게 다음과 같은 과정으로 진행된다.

1. 쓰레드가 실행 가능한지 검사함
2. 쓰레드를 쓰레드 그룹에 추가함
3. 쓰레드를 JVM이 실행시킴

 

**1. 쓰레드가 실행 가능한지 검사함**



쓰레드는 New, Runnable, Waiting, Timed Waiting, Terminated 총 5가지 상태가 있다. start 가장 처음에는 해당 쓰레드가 실행 가능한 상태인지(0인지) 확인한다. 
그리고 만약 쓰레드가 New(0) 상태가 아니라면 IllegalThreadStateException 예외를 발생시킨다.



![image](https://github.com/lielocks/WIL/assets/107406265/2268e31f-1742-41c9-8e15-4260b88f06f9)


**2. 쓰레드를 쓰레드 그룹에 추가함**



그 다음 쓰레드 그룹에 해당 쓰레드를 추가시킨다. 



여기서 쓰레드 그룹이란 서로 관련있는 쓰레드를 하나의 그룹으로 묶어 다루기 위한 장치인데, 자바에서는 `ThreadGroup` 클래스를 제공한다. 

쓰레드 그룹에 해당 쓰레드를 추가하면 쓰레드 그룹에 실행 준비된 쓰레드가 있음을  알려주고, 관련 작업들이 내부적으로 진행된다.
 
 







 
**3. 쓰레드를 JVM이 실행시킴**


그리고 start0 메소드를 호출하는데, 이것은 native 메소드로 선언되어 있다. 

이것은 **JVM**에 의해 호출되는데, 이것이 내부적으로 run을 호출하는 것이다. 

그리고 쓰레드의 상태 역시 **Runnable**로 바뀌게 된다. 그래서 start는 여러 번 호출하는 것이 불가능하고 1번만 가능하다.



```java
private native void start0();
```



만약 다음과 같이 run을 직접 호출하면 새롭게 쓰레드가 만들어지지 않고, 메인 쓰레드에 의해 해당 메소드가 실행됨을 확인할 수 있다. 

또한 여러 번 실행해도 아무런 문제가 없다. 그리고 출력 결과를 보면 main 메소드에 의해 실행됨을 실제로 확인할 수 있다.




```java
@Test
void threadRun() {
    Thread thread = new MyThread();

    thread.run();
    thread.run();
    thread.run();
    System.out.println("Hello: " + Thread.currentThread().getName());
}

// 출력 결과
// Thread: main
// Thread: main
// Thread: main
// Hello: main
```





#### [ Runnable 인터페이스 ] ####

Runnbale 인터페이스는 1개의 메소드 만을 갖는 함수형 인터페이스이다. 그렇기 때문에 람다로도 사용 가능하다.



```java
@FunctionalInterface
public interface Runnable {

    public abstract void run();
    
}
```


이것은 쓰레드를 구현하기 위한 템플릿에 해당하는데, 

해당 인터페이스의 구현체를 만들고 Thread 객체 생성 시에 넘겨주면 실행 가능하다. 

앞서 살펴본 Thread 클래스는 반드시 run 메소드를 구현해야 했는데, Thread 클래스가 Runnable를 구현하고 있기 때문이다.




```java
public class Thread implements Runnable {
    ...
}
```

 
기존에 Thread로 작성되었던 코드를 Runnable로 변경하면 다음과 같다. 
마찬가지로 별도의 쓰레드에서 실행됨을 확인할 수 있다.






```java
@Test
void runnable() {
    Runnable runnable = new Runnable() {
        @Override
        public void run() {
            System.out.println("Thread: " + Thread.currentThread().getName());
        }
    };

    Thread thread = new Thread(runnable);
    thread.start();
    System.out.println("Hello: " + Thread.currentThread().getName());
}

// 출력 결과
// Hello: main
// Thread: Thread-1
```
 








## Thread 와 Runnable의 비교 ##

Runnable은 익명 객체 및 람다로 사용할 수 있지만, Thread는 별도의 클래스를 만들어야 한다는 점에서 번거롭다. 

또한 Java에서는 다중 상속이 불가능하므로 ***Thread 클래스를 상속받으면 다른 클래스를 상속받을 수 없어서 좋지 않다.***

또한 Thread 클래스를 상속받으면 Thread 클래스에 구현된 코드들에 의해 더 많은 자원(메모리와 시간 등)을 필요로 하므로 Runnable이 주로 사용된다. 


물론 Thread 관련 기능의 확장이 필요한 경우에는 Thread 클래스를 상속받아 구현해야 할 때도 있다. 

하지만 거의 대부분의 경우에는  Runnable 인터페이스를 사용하면 해결 가능하다.


![image](https://github.com/lielocks/WIL/assets/107406265/c065ebe1-0eca-424f-8f62-226d7472b530)




#### [ Thread와 Runnable의 단점 및 한계 ] #### 


하지만 위에 코드를 통해 보았듯이 Thread와 Runnable을 직접 사용하는 방식은 다음과 같은 한계점이 있다. 

+ 지나치게 저수준의 API(쓰레드의 생성)에 의존함
+ 값의 반환이 불가능
+ 매번 쓰레드 생성과 종료하는 오버헤드가 발생
+ 쓰레드들의 관리가 어려움

 
먼저 Thread와 Runnable은 쓰레드를 생성하는데 너무 저수준의 API들을 필요로 한다. 

쓰레드를 어떻게 만드는지는 애플리케이션을 만드는 개발자의 관심사와는 거리가 멀다. 

그리고 쓰레드의 작업이 끝난 후의 결과 값을 반환받는 것도 불가능하다. 

또한 쓰레드를 사용하려면 항상 새롭게 쓰레드를 생성하고 종료해야 하는데, 이는 비용이 많이 드는 작업들며 직접 쓰레드를 만드는 만큼 쓰레드의 관리 역시 어렵다.


---

*reference : https://mangkyu.tistory.com/258*


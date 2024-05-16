## Multi Thread 환경에서의 ArrayList 와 Vector

ArrayList 와 Vector 클래스 모두 배열(Array)를 기반으로 한 collection 이다.

실제 두 메서드 구성 및 사용법을 보면 거의 비슷하며 기능상 **동일** 하다. 

하지만 한 가지 다른 점이 있는데 바로 메서드에 **`synchronized(동기화)`** 키워드 유무이다. 

그리고 이 synchronized 키워드는 Java 에서 매우 중요한 개념이다.

![image](https://github.com/lielocks/WIL/assets/107406265/d734b86f-1501-4b31-b717-96066b4091ca)


Java 는 기본적으로 Multi Thread 환경을 고려한 프로그래밍 언어이다. 

그래서 자바스크립트와 같은 왠만한 Interpreter 언어 보단 성능이 좋다. 

그러나 각 thread 마다 어느 데이터에 **동시에 접근하여 삽입과 삭제와 같은 수정** 을 행할 경우 개발자 의도와는 다르게 오동작의 문제점이 발생하게 된다. 

이를 **`경쟁 상태(Race Condition)`** 이라고 부른다.


<br>



바로 이러한 문제 현상을 해결하는 것이 synchronized 키워드이다. 

메서드에 synchronized 를 추가할경우 동기화 처리가 되어 동시 접근을 방어하기 때문이다. 

그러나 반대로 synchronized 키워드 때문에 프로그램 성능이 떨어질수도 있다는 문제점이 있다.


<br>


![image](https://github.com/lielocks/WIL/assets/107406265/41d188f5-f44d-4123-9878-4fb623b68dd5)


<br>


### [ ArrayList 는 동기화가 되어 있지 않다 ] 

Multi Thread 환경에서 ArrayList 컬렉션을 다룰 때 주의할 점이 있다.

ArrayList 는 동기화가 되어있지 않기 때문에 **다수의 thread 가 동시에 접근** 할 경우 문제가 터질 수 있다. 

예를 들어 다수의 thread 가 동시에 ArrayList 에 요소를 삽입하거나 삭제할때, 배열 index 가 넘어가거나 등 충돌이 발생하여 비정상적인 동작이나 예외가 발생할 소지가 생길 수 있다.

> 즉, ***ArrayList는 동기화가 되지 않아 Multi Thread 환경에서 안전(Thread Safe) 하지 않는다고 하는 것이다.***

![image](https://github.com/lielocks/WIL/assets/107406265/b78faa2d-6025-4575-8448-bec06024e941)


<br>


동기화에 대해 이해하기 위해서 실생활로 예를 들자면 ATM 에서 예금 인출 하는 행위를 생각해보면 된다.

만일 10만원 에서 5만원, 2만원을 차례로 인출하면 결과적으로 3만원 이 남아야 할 것이다. 

그런데 두 기기에서 **동시에 인출** 한다고 가정해보자. 

각 ATM 기기 A와 B에서 잔액을 읽고, 인출 금액을 거기서 빼고, 다시 계산된 잔액을 고객 계좌에 작성한다고 한다면, 

이를 **병렬적으로 동시에** 수행을 하게 된다면 다음과 같은 순서가 꼬여버리는 사태가 발생할 수 도 있다.

![image](https://github.com/lielocks/WIL/assets/107406265/fe5e0094-7937-4ead-9c1e-036d52906677)


이런 순으로 ATM A가 잔액을 고객 계좌에 다시 쓰기(write) 하기 전에, B가 계좌에서 차감되지 않은 잔액을 미리 읽어버린다면(read), 

최종적으로 고객 계좌에 쓰여지는 잔액은 8만원 이 되게 된다. 

그래서 **A가 일을 하는 동안 다른 ATM기 는 고객 계좌에 접근할 수 없도록** 해줄 필요가 있는데 이것이 동기화 처리이다.


<br>


따라서 결론은 ArrayList는 동기화(Synchronized) 처리가 안되어 있기 때문에 Multi Thread 환경에서 리스트의 메서드를 무작정 호출한다면, 

위의 ATM 예시처럼 리스트에 값이 올바르게 적재되지 않을 수 있다는 위험요소를 지니고 있다는 소리이다.


<br>


### [ Vector 는 동기화되어 있다 ]

반면 Vector 은 ArrayList 와 달리 기본적으로 **동기화 처리가 되어 있다.**

![image](https://github.com/lielocks/WIL/assets/107406265/efa4b345-938e-4935-ac6c-e8c889a52d1e)

각 메서드에 아래와 같이 synchronized 키워드가 명시되어 있는데, **`synchronized 처리된 메서드`** 는 **두개 이상의 thread 가 하나의 method 에 동시에 접근** 을 할 때 **Race condition(경쟁상태) 이 발생하지 않도록 한다.**  

![image](https://github.com/lielocks/WIL/assets/107406265/6df7e6b2-5ab7-456d-9598-b640431987b9)

한마디로 하나의 thread 가 해당 method 를 실행하는 동안 다른 thread 가 접근하지 못하도록 method 를 잠금(lock)을 거는 것으로 이해하면 된다. 

마치 아래 그림 처럼 `thread-1` 이 method 에 진입하는 순간 **나머지 thread-2 ~ 4 의 접근을 제한하고,** 

`thread-1` 이 완료가 되고 나서야 **다음 thread 인 thread-3 을 접근시키고 다시 막는다.**

![image](https://github.com/lielocks/WIL/assets/107406265/55c0a968-0277-4fec-84a1-dbe601132018)

그래서 Vector 클래스를 Multi Thread 환경에서 안전하게 사용할 수 있는 컬렉션이게 된다.


<br>



### [ ArrayList 와 Vector 동기화 유무 확인하기 ]

그럼 실제로 synchronized 키워드가 없는 메서드를 가진 ArrayList와 synchronized 키워드가 있는 메서드를 가진 Vector의 멀티 쓰레드 환경에서의 동작 차이를 살펴보자. 

동기화 유무를 확인하는 로직은 다음과 같다.


<br>



1. ArrayList 와 Vector 컬렉션을 생성한다.

2. thread 2개를 생성한다.

3. 각 thread 마다 ArryList와 Vector 객체에 요소를 추가하는 `add()` 메서드를 1만번 반복한다.


<br>


두개의 thread 에서 행해지니 최종 결과값으로는 각 컬렉션에는 **2만번의 `add()`** 메서드가 동작하여 size 는 **20000** 이 되게 될 것이다.

```java
import java.util.*;

public class Main {
    public static void main(String[] args) {
        ArrayList<Integer> list = new ArrayList<>();
        Vector<Integer> vec = new Vector<>();

        // 각 thread 마다 1만번을 돌아 컬렉션에 요소를 추가한다. (두개 thread 니까 총 컬렉션에 요소가 2만개 추가된다)
        new Thread(() -> {
            for(int i = 0; i < 10000; i++) {
                list.add(1);
                vec.add(1);
            }
        }).start();

        new Thread(() -> {
            for(int i = 0; i < 10000; i++) {
                list.add(1);
                vec.add(1);
            }
        }).start();

        // 출력
        new Thread(() -> {
            try {
                Thread.sleep(2000);  // thread 가 다 돌때까지 2초 대기

                System.out.println("ArrayList의 추가된 요소 갯수 size : " + list.size());
                System.out.println("Vector의 추가된 요소 갯수 size : " + vec.size());
            } catch (InterruptedException ignored) {}
        }).start();
    }
}
```

![image](https://github.com/lielocks/WIL/assets/107406265/15fade3a-1619-442d-a799-d6cfded0b35c)


<br>


하지만 결과를 보면 **`Vector`** 은 예상대로 size 값이 **20000** 이지만, **`ArrayList`** 는 size 값이 어딘가 **빠진 값** 이 들어온 것을 볼 수 있다. 

왜냐하면 **synchronized 키워드가 없는 `ArrayList 의 add()`** 메서드를 각 thread 가 동시에 메서드를 호출 하게 되어 **한쪽이 씹혀버렸기 때문** 이다. 

위에서 예시를 든 ATM 인출과 같은 현상이다.

![image](https://github.com/lielocks/WIL/assets/107406265/a817796b-3fb0-4115-b705-175101fe5f80)


<br>


### [ Vector 단점과 동기화 문제점 ]

여기까지보면 Vector 은 ArrayList 와 달리 동기화가 되어 있어서 당연히 더 좋아 보일지도 모르겠지만, 문제는 **오히려 메서드마다 동기화가 되어 있어 단점** 을 가지게 된다.


<br>


**강제 동기화로 인해 느려진 성능**

동기화 라는게 말이 좋아보이는거지, 동시에 처리되도 문제가 발생 안한다는 것은, 동시에 처리되지 못하게 하였다는 뜻이며, 이는 동시에 하면 10초 안에 처리될 수 있는 것을 동기화 때문에 20초 가 걸린다는 뜻이다.

즉, Vector 은 메서드들이 기본적으로 synchronized 가 걸려있기 때문에 Race condition(경쟁상태)를 따지지 않아도 되는 환경에서도 메서드를 실행하면 **동기화 여부를 따지느라** 일반적인 메서드보다 속도가 느려질 수 있다 **`(Overhead)`** 는 점이다.


<br>



**완벽하지 않은 Vector의 동기화**

그리고 웃기게도 Vector의 동기화 처리는 완벽한 동기화가 아니다.

이게 무슨 말이냐 하면, 코드에서 살펴보듯이 *Vector 클래스의 메소드에 대해서는 synchronized 처리가 되어있지만,* 

**`Vector 인스턴스 자체` 에 대해서는 동기화 처리가 되어있지 않기 때문에 동시 access 에 한해서 여전히 thread 에 안전하지 않은 것이다.**

다음 예제 코드를 통해 이해해보자. 

Vector 컬렉션을 만들고, 두개의 Multi Thread 환경에서 vec 인스턴스 변수를 다루는 예제이다.


<br>


1. 첫번째 쓰레드에서는 vec 객체에 요소를 add하고 get 하여 출력하고

2. 두번째 쓰레드에서는 요소를 remove 한다.

```java
import java.util.*;

public class Main {
    public static void main(String[] args) {
        Vector<Integer> vec = new Vector<>();

        new Thread(() -> {
            vec.add(1);
            vec.add(2);
            vec.add(3);
            System.out.println(vec.get(0));
            System.out.println(vec.get(1));
            System.out.println(vec.get(2));
        }).start();

        new Thread(() -> {
            vec.remove(0);
            vec.remove(0);
            vec.remove(0);
        }).start();

        // 출력
        new Thread(() -> {
            try {
                Thread.sleep(1000); // 쓰레드가 다 돌때까지 1초 대기

                System.out.println("Vector size : " + vec.size());
            } catch (InterruptedException ignored) {
            }
        }).start();
    }
}
```

![image](https://github.com/lielocks/WIL/assets/107406265/aa0d04eb-7608-44e2-893f-0556a3dab99d)

결과는 처참하게도 `ArrayIndexOutOfBoundsException` 예외가 발생하게 된다. 

왜냐하면 첫번째 thread 에서 요소를 추가하고 get 하려는데, 두번째 thread 에서 요소를 remove 하고 내부 배열을 줄였기 때문에 존재하지 않은 요소가 들어있던 범위를 벗어난 index 를 참조하려고 했기 때문이다.


<br>


***분명 Vector은 동기화가 되어있을텐데 왜 이런 현상이 일어나는 것일까?***

Vector의 동기화는 **메서드에만 synchronized 키워드** 로 되어 있어 **메서드 자체 실행으로는 Thread-Safe** 하지만, 

**`Vector instance 객체 자체` 에는 동기화가 되어있지 않기 때문에, thread 들이 동시다발적으로 `객체에 접근해 메서드를 호출`하였기 때문에 위와 같은 race condition 현상이 나타나는 것이다.**
 

<br>


### [ Vector의 동기화 추가 처리하기 ]

따라서 **`synchronized 블록`을 통해 Vector 객체 자체를 따로 동기화 처리** 를 하여야 한다.

```java
import java.util.*;

public class Main {
    public static void main(String[] args) {
        Vector<Integer> vec = new Vector<>();

        new Thread(() -> {
            synchronized (vec) { // vec 객체 자체를 동기화 처리함
                vec.add(1);
                vec.add(2);
                vec.add(3);
                System.out.println(vec.get(0));
                System.out.println(vec.get(1));
                System.out.println(vec.get(2));
            }
        }).start();

        new Thread(() -> {
            synchronized (vec) { // vec 객체 자체를 동기화 처리함
                vec.remove(0);
                vec.remove(0);
                vec.remove(0);
            }
        }).start();

        // 출력
        new Thread(() -> {
            try {
                Thread.sleep(1000); // 쓰레드가 다 돌때까지 1초 대기

                System.out.println("Vector size : " + vec.size());
            } catch (InterruptedException ignored) {}
        }).start();
    }
}
```

![image](https://github.com/lielocks/WIL/assets/107406265/376035dd-a497-4277-8a53-63800afda179)

`vec` 변수 자체를 동기화 처리하니 정상적으로 코드가 실행됨을 볼 수 있다. (size 값을 보면 remove도 잘 동작 되었다)

따라서 정리하자면, 결과적으로 **Single Thread 환경에서는 동기화가 덕지덕지 붙어 있는 느린 Vector** 를 쓸 이유가 없고, **Multi Thread 환경에서도 thread 에 안전하지 않기 때문에** Vector 를 쓸 이유가 더욱 더 없다.


<br>


### [ ArrayList 동기화 처리하기 ]

그렇다면 ArrayList 는 Multi Thread 환경에서는 절대 못 쓰는 컬렉션일까?

이를 위해 Java 에서는 별도로 Collections 클래스에서 **`synchronizedList()`** 메서드를 통해 **동기화 처리가 된 List** 를 만들어주는 기능을 지원해준다. 

ArrayList 뿐만 아니라 LinkedList 및 다른 컬렉션 역시 자료구조의 특성을 유지하면서도 동기화 처리가 된 콜렉션들을 만들어주기 때문에 현업에서 자주 사용된다.

```java
/* ArrayList 동기화 처리 */
List<String> l1 = Collections.synchronizedList(new ArrayList<>());

/* LinkedList 동기화 처리 */
List<String> l2 = Collections.synchronizedList(new LinkedList<>());

/* HashSet 동기화 처리 */
Set<String> s = Collections.synchronizedSet(new HashSet<>());

/* HashMap 동기화 처리 */
Map<String> m = Collections.synchronizedMap(new HashMap<>());
```


<br>


## ArrayList vs Vector 선택하기

![image](https://github.com/lielocks/WIL/assets/107406265/d807683c-885b-4107-8cf3-432bb956b58e)

||Vector|ArrayList|
|---|---|---|
|동기화|동기|비동기|
|Thread Safe|안전, 한 번에 하나의 thread 만 access 가능|불안전, 여러 thread 가 동시에 accesss 가능|
|성능|비교적 느림|동기화되지 않았기 때문에 비교적 빠름|
|크기 증가|최대 index 초과 시 현재 배열 크기의 100% 증가|최대 index 초과 시 현재 배열 크기의 50% 증가|
|사용|성능 저하로 사용 지양|동기화 처리 시에도 사용 권장|


<br>


ArrayList 나 Vector 컬렉션은 둘다 배열 기반의 리스트이다. 그렇다면 어떤 컬렉션을 사용하는것이 옳을까?

정답은 그냥 생각할 필요없이 **ArrayList 컬렉션** 을 쓰던대로 사용하면 된다.

Vector 클래스는 Java 에 컬렉션 프레임워크(Collection Framework) 라는 개념이 나오기 전부터 존재했던 아주 오래된 클래스이며, 내부적으로도 **안정하지 않은 클래스이기 때문에 `deprecated`** 되어 더이상 사용을 권하지 않는다. 

그리고 위에서 학습했듯이 Vector 메서드는 항상 동기화한다는 점때문에 overhead 가 발생해 ArrayList보다 성능이 크게 떨어진다.


<br>


### [ ArrayList vs Vector 속도 비교 ]

```java
import java.util.*;

public class Main {
    public static void main(String[] args) {
        List<Integer> list = new ArrayList<Integer>();
        Vector<Integer> vec = new Vector<>();

        new Thread(() -> {
            long startTime = System.currentTimeMillis(); // 코드 시작 시간
			
            // 천만번 add 하기
            for(int i = 0; i < 10000000; i++) {
                list.add(1);
            }

            long endTime = System.currentTimeMillis(); // 코드 끝난 시간

            long durationTimeSec = endTime - startTime;
            System.out.println("ArrayList 속도 : " + durationTimeSec + "m/s"); // 밀리세컨드 출력
        }).start();

        new Thread(() -> {
            long startTime = System.currentTimeMillis(); // 코드 시작 시간
			
            // 천만번 add 하기
            for(int i = 0; i < 10000000; i++) {
                vec.add(1);
            }

            long endTime = System.currentTimeMillis(); // 코드 끝난 시간

            long durationTimeSec = endTime - startTime;
            System.out.println("Vector 속도 : " + durationTimeSec + "m/s"); // 밀리세컨드 출력
        }).start();
    }
}
```

![image](https://github.com/lielocks/WIL/assets/107406265/60c5c3e9-68dc-422d-bad0-f1dbc612290f)

당장 코드로 확인해봐도 거의 2배 차이가 난다. 

따라서 동기화가 굳이 필요하지 않은 장면에서는 ArrayList를 쓰는 게 좋다. 

심지어 동기화 동작이 필요하더라도 위에서 배웠듯이 Collections 클래스의 **`synchronizedList()` 메서드를 통해 ArrayList** 컬렉션을 동기화 처리가 된 자료구조로 변환이 가능하다.


<br>


### [ synchronizedList  vs Vector 속도 비교 ]

보너스로 **synchronizedList 처리된 ArrayList** 와 **Vector** 중 어느게 속도가 빠를지 궁금하여 비교해보았다. 

위의 ArrayList 와 Vector의 속도 비교 예제에서 list 변수를 synchronizedList 처리된 ArrayList로 바꾸고 속도를 계산해보았더니 Vector 클래스보다는 성능이 낮게 나오는 걸 볼 수 있다.

```java
List<Integer> list = Collections.synchronizedList(new ArrayList<Integer>());
```

![image](https://github.com/lielocks/WIL/assets/107406265/017508eb-8656-46db-a5b5-bfe5a857b1a7)

하지만 일단 *Vector 클래스 자체가 deprecated 된 클래스이며*

Collections.synchronizedList() 메서드는 ArrayList 뿐만 아니라 **LinkedList 자료구조도 linked 상태를 유지하며 동기화 객체로 변환이 가능** 하기 때문에 훨씬 사용처와 응용 폭이 넓기 때문에 비교는 무의미하다고 보면 된다.


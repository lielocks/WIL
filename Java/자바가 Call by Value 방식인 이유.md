### [ Call by Value / Call by Reference ]

+ *Call by Value (값에 의한 호출)*

  + `값을 복사` 하여 처리한다.

  + **변수의 `복사본` 이 전달** 되며, **원래 값이 수정되지 않는다.**

  + **실제 인수는 `다른` 메모리 위치**에 생성된다.

+ *Call by Reference (참조에 의한 호출)*

  + `값의 주소를 참조` 하여 **직접 값** 에 영향을 준다.

  + **변수 자체** 가 전달되며, **원래 값** 이 수정된다.

  + **실제 인수는 `같은` 메모리 위치** 에 생성된다.


<br>


### 자바의 Call by Value 동작 방식

자바의 데이터 타입은 다음과 같이 크게 두 가지로 나누어진다.


+ **`원시 타입(primitive type)`**

  Numeric Type(byte, short, int, float, long, double, char), Boolean Type(boolean)

+ **`참조 타입(reference type)`** 

  Class Type, Interface Type, Array Type, Enum Type, 기타 참조 타입(String 등)


<br>


그래서 `메소드 parameter` 로 *원시 타입* 을 전달하는 것과 *참조 타입* 을 전달하는 것에는 동작 방식에 차이가 있다.

<br>


### 원시 타입(primitive type) 전달 방식

```java
public class CallByExampleTest {

    @Test
    void primitiveTest() {
      int v = 10;

      add(v);

      assertThat(v).isEqualTo(10);
    }

    void add(int num) {
      num++;
    }
}
```

<br>


위 코드는 int 타입의 변수 v를 add 함수를 통해 1을 더해주고 있다.

하지만 결과 값은 여전히 10이다.

primitiveTest()의 v 변수와 add()의 num은 아예 연관 없는 변수이기 때문이다.

아래 그림으로 보면 한눈에 이해하기 쉬울 것이다.

![image](https://github.com/lielocks/WIL/assets/107406265/03eceded-4361-4127-988a-e84c9b63ca46)

자바에서 `변수` 를 선언하면 기본적으로 `Stack` 메모리 영역에 할당된다.

Stack 영역 내부에 **primitiveTest()와 add()의 영역이 각각 나뉘어 있고,** **`서로 다른 변수`** 가 존재한다.

그래서 num 값에 1을 더해도 v 변수는 아무런 영향이 없다.

따라서 **원시 타입의 전달** 은 ***값을 복사해서 전달하는 Call by Value 방식으로 동작한다*** 는 것을 알 수 있다.

<br>


### 참조 타입(reference type) 전달 방식

참조 타입은 원시 타입과 조금 다르다.

변수는 Stack 영역에 생성되지만, 객체는 Heap 영역에 위치하며, 

Stack 영역에 있는 변수가 Heap 영역에 있는 객체를 바라보고 있는 형태다.


```java
public class CallByExampleTest {

    @Test
    void referenceTest() {
        int[] arr = { 10 }; // 주소 : 0x001

        add(arr);

        assertThat(arr[0]).isEqualTo(11);
    }

    void add(int[] arrArg) {
        arrArg[0]++; // 주소 : 0x001
    }
}
```

`변수의 참조(주소) 값을 복사` 해서 전달해 referenceTest() 영역과 add() 영역의 변수들은 **모두 동일한 객체의 주소(0x001)** 를 바라보고 있다. 

아래 단계별 그림을 보자.

![image](https://github.com/lielocks/WIL/assets/107406265/7b249a45-eb2e-46dd-88ce-e70e3ae1645f)

![image](https://github.com/lielocks/WIL/assets/107406265/63525420-9527-4e08-b6fa-8888aa60374a)

![image](https://github.com/lielocks/WIL/assets/107406265/863f690c-cf46-4e60-acad-5e3967e69d3d)

`add() 에서 생긴 변수` 가 **같은 주소 값을 참조** 하고 있기 때문에 값이 변경되었다.

> ***결국 주소 값을 넘기고 원본 값이 변경되니까 Call by Reference 아닌가?🤔 싶을 수 있지만,***

*자바의 참조* 와 *Call by Reference 의 참조* 는 약간 다른 의미를 가지고 있다.

*자바에서 참조* 의 의미는 **객체가 Heap 에 저장된 위치를 가리키는 메모리 주소** 이다.

*실제 객체에 대한 참조가 아니라* **`객체에 접근하고 조작하는 방법`** 이라고 볼 수 있다.

*Call by Reference* 는 **`참조 자체`** 를 넘기기 때문에 **새로운 객체를 할당하면 원본 변수도 영향을 받는다.**

다음 예시 코드를 보자.


```java
public class CallByExampleTest {

    @Test
    void referenceTest() {
        int[] arr = { 10 }; // 0x001

        newArr(arr);

        assertThat(arr).isEqualTo("0x001");
    }

    void newArr(int[] arrArg) {
        arrArg = new int[]{ 20 }; // 0x002
    }
}
```

전달받은 값을 새로운 객체로 변경해도 원본 변수는 변하지 않는다.

따라서 참조 타입 역시 Call by Value 방식으로 동작함을 보여준다.

newArr()가 종료되고 사용되지 않는 객체(0x002)는 Garbage Collector에 의해 수거될 것이다.

![image](https://github.com/lielocks/WIL/assets/107406265/ad3956e7-9e02-40a7-8e72-c8aeaaa89e51)

결국 자바는 항상 Call by Value 방식으로 데이터를 전달하고, 

핵심은 **호출자 변수와 수신자 parameter 는 Stack 영역내에서 각각 독립적으로 존재하는 다른 변수** 라는 것이다.

<br>


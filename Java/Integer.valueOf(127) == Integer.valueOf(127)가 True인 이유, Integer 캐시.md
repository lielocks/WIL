## 1. 문제 상황 소개

### [ 문제 상황 소개 ]

다음과 같은 테스트 코드가 있다고 할 때, 출력 결과를 예상해보도록 하자.


```java
@Test
void compareInteger() {
    Integer num1 = 128;
    System.out.println(num1 == Integer.valueOf(128));

    Integer num2 = 127;
    System.out.println(num2 == Integer.valueOf(127));
    
    System.out.println(Integer.valueOf(127) == Integer.valueOf(127));
}
```

실제 출력 결과는 다음과 같다.

```
false
true
true
```


<br>



**별도의 참조(reference)** 를 할당 받았으므로 *모두 false* 가 나와야 할 것 같은데 실제로는 false, true, true가 나온다. 

이제부터 왜 이러한 결과가 나왔는지 알아보도록 하자.


<br>


## 2. Integer.valueOf(127) == Integer.valueOf(127)가 True인 이유, Integer 캐시

### [ 원시 타입(Primitive Type)과 참조 타입(Reference Type) ]

원시 타입에는 **`char, int, float, double, boolean`** 등이 있는데, **값을 직접 들고 있는 타입** 이다. 

그래서 다음과 같이 int 값을 비교하는 것은 **실제 값** 을 비교하는 것이므로 **항상 true** 가 나온다.

```java
@Test
void compareInteger() {
    System.out.println(128 == 128);
}
```

<br>


**참조 타입** 에는 class 와 interface 등이 있다. 

프로그래밍을 하다 보면 *원시 타입을 객체로 다뤄야하는 경우* 가 있는데, 이때 **원시 타입을 담도록 만들어진 클래스를 `래퍼 클래스(Wrapper Class)`** 라고 한다. 

대표적으로 **`Character, Integer, Float, Double, Boolean`** 등이 있다.

Java 에서는 **compiler** 가 **원시 타입과 참조 타입을 서로 호환가능하도록88 도와준다. 

예를 들어서 다음과 같이 `int` 값을 `Integer 라는 Wrapper 클래스` 에 담을 수 있는 것은 **compiler 가 Wrapper 클래스로 자동으로 감싸주기 때문이다.**


```java
Integer num1 = 128;

// 컴파일러가 원시 타입을 참조 타입으로 바꿔줌
Integer num1 = Integer.valueOf(128);
```


<br>


그러므로 처음 봤던 테스트 코드는 다음과 같이 정리 가능하고, 출력 결과는 true, false로 동일하다.

```java
@Test
void compareInteger() {
    System.out.println(Integer.valueOf(128) == Integer.valueOf(128));

    System.out.println(Integer.valueOf(127) == Integer.valueOf(127));
}
```


<br>


**`참조 타입`** 은 **실제 객체가 아니라 객체의 주소** 를 저장하고 있다. 

**Wrapper Class 역시 참조 타입인 클래스의 일종** 이므로, **객체가 별도의 주소에 할당된다.** 

즉, `Integer.valueOf(128)` 에 의해 **매번 다른 객체** 가 만들어지므로 == 으로 비교를 하면 false 가 나온다.

하지만 Integer.valueOf(127) 에 의해 만들어지는 객체는 비교하면 true 가 나오는데, 이는 ***Integer 가 내부에서 캐싱을 사용해 동일한 객체를 반환하기 때문이다.*** 

이어서 ***Integer 캐시*** 에 대해 자세히 살펴보도록 하자.


<br>


### [ Integer 캐시(Integer Cache) ]

Integer 클래스의 valueOf 메소드의 소스코드를 보면 다음과 같다. 단순한 코드라 어려움 없이 쉽게 읽을 수 있다.

```java
@HotSpotIntrinsicCandidate
public static Integer valueOf(int i) {
    if (i >= IntegerCache.low && i <= IntegerCache.high)
        return IntegerCache.cache[i + (-IntegerCache.low)];
    return new Integer(i);
}
```


<br>


**`IntegerCache.low`** 는 **-128** 이고, **`high`** 는 **127** 이다. 

즉, Integer는 내부에서 **-128 부터 127 까지의 Integer 객체를 미리 `캐싱`** 해두고, *해당 범위의 값을 요청하면 캐싱된 값을 반환* 하는 것이다. 

> 그래서 **해당 범위의 값을 비교하면 `같은 참조` 를 갖게 되므로 `true` 가 나온다.**
>
> ***해당 범위의 값은 매우 자주 사용되기 때문에 메모리를 절약하고자 캐싱을 해두고 있는 것이다.***

실제로 자바 Integer 클래스의 Inner Static Class 로 **IntegerCache** 라는 클래스가 선언되어 있음을 확인할 수 있다.

![image](https://github.com/lielocks/WIL/assets/107406265/55be66b3-2d60-4f9b-8ba1-fb9ab2273de1)

**`IntegerCache 의 static block`** 에서 값을 메모리에 초기화하고 있으므로, **cache 는 class 가 memory 로 로딩될 때 초기화된다.** 

캐싱은 Integer 뿐만 아니라 Byte, Short, Long Character 클래스에도 적용된다. 범위는 조금씩 다른데, 정리하면 다음과 같다.

+ *Byte, Short, Long* : -127부터 127까지

+ *Integer* : -128부터 127까지

+ *Character* : 0부터 127까지


<br>


 
캐시될 범위는 JVM 옵션 중 하나인 **`-XX:AutoBoxCacheMax`** 로 조절할 수 있다. 

하지만 이는 **Integer 에만** 적용 가능하며 다른 클래스의 경우에는 범위를 조절할 수 없으므로 참고하도록 하자.

참고로 이렇듯 자주 사용되는 객체를 재사용하여 메모리를 절약하는 디자인 패턴을 **`플라이웨이트 패턴 (flyweight pattern)`** 이라고 한다. 

당연하게도 *이때 공유되는 객체는 불변 객체* 여야만 한다. 

플라이웨이트가 불변 객체가 아니라면 어떤 코드가 플라이웨이트 객체를 임의로 수정할 경우, 해당 객체를 공유하고 있는 다른 코드에 영향을 미치기 때문이다.

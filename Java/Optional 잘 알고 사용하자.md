# 2022.10.29 언제 Optional 을 사용해야 하는가?

### [ Optional이 만들어진 이유와 의도 ]

**Java8** 부터 Null 아니 Null 이 아닌 값을 저장하는 Container Class 인 Optional 이 추가되었다.

![image](https://github.com/lielocks/WIL/assets/107406265/4822d433-a708-4e4a-8225-f8d76adbbd70)


Java 언어의 아키텍트(설계자) 인 Brian Goetz는 Optional 에 대해 다음과 같이 정의하였다.


<br>


> ***Optional is intended to provide a limited mechanism for library method return types where there needed to be a clear way to represent “no result," and using null for such was overwhelmingly likely to cause errors.***


<br>


위의 내용을 정리하면 Optional 은 null 을 반환하면 오류가 발생할 가능성이 매우 높은 경우에 

**'결과 없음'을 명확하게 드러내기 위해 메소드의 반환 타입으로 사용되도록 매우 제한적인 경우로 설계** 되었다는 것이다. 

이러한 설계 목적에 부합하게 실제로 Optional 을 잘못 사용하면 많은 부작용(Side Effect)이 발생하게 되는데, 어떠한 문제가 발생할 수 있는지 자세히 살펴보도록 하자.


<br>


### [ Optional 이 위험한 이유, Optional 을 올바르게 사용해야 하는 이유 ]

Optional 을 사용하면 코드가 Null-Safe 해지고, 가독성이 좋아지며 어플리케이션이 안정적이 된다는 등과 같은 얘기들을 많이 접할 수 있다. 

하지만 이는 Optional 을 *목적에 맞게 올바르게* 사용했을 때의 이야기이고, Optional을 남발하는 코드는 오히려 다음과 같은 부작용(Side-Effect)를 유발할 수 있다.


<br>


**NullPointerException 대신 NoSuchElementException가 발생함**

만약 Optional 로 받은 변수를 값이 있는지 판단하지 않고 접근하려고 한다면 `NoSuchElementException`가 발생하게 된다.

```java
Optional<User> optionalUser = ... ;

// optional이 갖는 value가 없으면 NoSuchElementException 발생
User user = optionalUser.get();
```


<br>

 
Null-Safe 하기 위해 Optional을 사용하였는데, 

**값의 존재 여부를 판단하지 않고 접근** 한다면 NullPointerException는 피해도 `NoSuchElementException` 가 발생할 수 있다.


<br>


**이전에는 없었던 새로운 문제들이 발생함**

Optional 을 사용하면 문제가 되는 대표적인 경우가 **`직렬화(Serialize)`** 를 할 때이다. 

기본적으로 **Optional 은 직렬화를 지원하지 않아서** *cache 나 Message Queue 등과 연동할 때 문제가 발생* 할 수 있다. 

Optional을 사용함으로써 오히려 새로운 문제가 발생할 수 있는 것이다.


```java
public class User implements Serializable {

    private Optional<String> name;

}
```

<br>


물론 *Jackson 처럼 라이브러리에서 Optional 이 있을 경우* 값을 wrap, unwrap 하도록 지원해주기도 하지만 해당 라이브러리의 *스펙을 파악해야 한다는 점* 등에서 오히려 불편함을 느낄 수 있다.

참고로 Jackson 라이브러리는 `jackson-modules-java8 project` 프로젝트부터 **Optional 을 지원** 하여 empty 일 경우에는 null 을, 값이 있는 경우에는 값을 꺼내서 처리하도록 지원하고 있다. 

또한 Cacheable, CacheEvict, CachePut 과 같은 Spring 의 Cache 추상화 기술들은 Spring4 부터 이러한 wrap, unwrap을 지원하고 있다.
 

<br>


**코드의 가독성을 떨어뜨림**

예를 들어 다음과 같이 Optional을 받아서 값을 꺼낸다고 하자. 

우리는 앞에서 살펴본대로 *optionalUser 의 값이 비어있으면 NoSuchElementException* 가 발생할 수 있으므로 다음과 같이 값의 유무를 검사하고 꺼내도록 코드를 작성하였다.

```java
public void temp(Optional<User> optionalUser) {
    User user = optionalUser.orElseThrow(IllegalStateException::new);

    // 이후의 후처리 작업 진행...
}
```

그런데 위와 같은 코드는 또 다시 NPE 를 유발할 수 있다. 

왜냐하면 **optionalUser 객체 자체가 null** 일 수 있기 때문이다. 


<br>


그러면 우리는 이러한 문제를 해결하기 위해 다음과 같이 코드를 수정해야 한다.

```java
public void temp(Optional<User> optionalUser) {
    if (optionalUser != null && optionalUser.isPresent()) {
        // 이후의 후처리 작업 진행...
    }
    
    throw new IllegalStateException();
}
```

이러한 코드는 *오히려 값의 유무를 2번 검사* 하게 하여 단순히 null을 사용했을 때보다 코드가 복잡해졌다. 

그 외에도 Optional의 제네릭 타입 때문에도 불필요하게 코드 글자수까지 늘어났다. 

이렇듯 Optional 을 올바르게 사용하지 못하고 남용하면 오히려 가독성이 떨어질 수 있다.


<br>


**시간적, 공간적 비용(또는 오버헤드)이 증가함**

+ 공간적 비용: **Optional 은 객체를 감싸는 컨테이너** 이므로 Optional 객체 자체를 저장하기 위한 메모리가 추가로 필요하다.
  
+ 시간적 비용: **Optional 안에 있는 객체를 얻기 위해서는 Optional 객체를 통해 접근** 해야 하므로 접근 비용이 증가한다.


<br>


어떤 글에서는 Optional 을 사용하면 단순 값을 사용했을 때보다 메모리 사용량이 **4배** 정도 증가한다고 한다. 

그 외에도 Optional 은 **Serializable 하지 않는** 등의 문제가 있으므로 이를 해결하기 위해 추가적인 개발 시간이 소요될 수 있다.
 
하지만 위에서 설명한 예시들의 대부분은 Optional 을 올바르게 사용하지 않았기 때문에 발생하는 것이다. 

Optional 은 만들어진 의도가 상당히 명확한 만큼 목적에 맞게 올바르게 사용되어야 한다. 아래에서는 올바른 Optional 사용을 위한 가이드를 소개한다.


<br>


## 올바른 Optional 사용법 가이드

### [ Optional 변수에 Null을 할당하지 말아라. ]

Optional 은 컨테이너/박싱 클래스일 뿐이며, Optional 변수에 null을 할당하는 것은 Optional 변수 자체가 null인지 또 검사해야 하는 문제를 야기한다. 

> 그러므로 **값이 없는 경우** 라면 ***Optional.empty()로 초기화*** 하도록 하자. 

```java
// AVOID
public Optional<Cart> fetchCart() {

    Optional<Cart> emptyCart = null;
    ...
}
```

<br>


### [ 값이 없을 때 Optional.orElseX()로 기본 값을 반환하라 ]

Optional의 장점 중 하나는 함수형 인터페이스를 통해 가독성좋고 유연한 코드를 작성할 수 있다는 것이다. 

가급적이면 **isPresent()로 검사하고 get()으로 값을 꺼내기보다는** **`orElseGet`** 등을 활용해 처리하도록 하자.

```java
private String findDefaultName() {
    return ...;
}

// AVOID
public String findUserName(long id) {

    Optional<String> optionalName = ... ;

    if (optionalName.isPresent()) {
        return optionalName.get();
    } else {
        return findDefaultName();
    }
}

// PREFER
public String findUserName(long id) {

    Optional<String> optionalName = ... ;
    return optionalName.orElseGet(this::findDefaultName);
}
```

<br>


**`orElseGet`** 은 **값이 준비되어 있지 않은 경우** , **`orElse`** 는 **값이 준비되어 있는 경우** 에 사용하면 된다. 

만약 **null 을 반환해야 하는 경우라면 orElse(null)** 을 활용하도록 하자. 

만약 **값이 없어서 throw** 해야하는 경우라면 **`orElseThrow`** 를 사용하면 되고 그 외에도 다양한 메소드들이 있으니 적당히 활용하면 된다.

추가적으로 Java9 부터는 **`ifPresentOrElse`** 도 지원하고 있으며, Java 10 부터는 **orElseThrow()의 기본으로 NoSuchElementException()** 를 던질 수 있다. 

만약 Java8 이나 9 를 사용중이라면 명시적으로 넘겨주면 된다.


<br>


### [ 단순히 값을 얻으려는 목적으로만 Optional 을 사용하지 마라 ]

단순히 값을 얻으려고 Optional을 사용하는 것은 Optional을 남용하는 대표적인 경우이다. 

이러한 경우에는 굳이 Optional을 사용해 비용을 낭비하는 것 보다는 **직접 값** 을 다루는 것이 좋다.

```java
// AVOID
public String findUserName(long id) {
    String name = ... ;

    return Optional.ofNullable(name).orElse("Default");
}

// PREFER
public String findUserName(long id) {
    String name = ... ;

    return name == null
      ? "Default"
      : name;
}
```


<br>


### [ 생성자, 수정자, 메소드 파라미터 등으로 Optional 을 넘기지 마라 ]

***Optional 을 parameter 로 넘기는 것은 상당히 의미없는 행동이다.***

왜냐하면 넘겨온 파라미터를 위해 **자체 null 체크** 도 추가로 해주어야 하고, 코드도 복잡해지는 등 상당히 번거로워지기 때문이다. 

**Optional 은 반환 타입으로 대체 동작을 사용하기 위해 고안된 것임** 을 명심해야 하며, 앞서 설명한대로 **Serializable 을 구현하지 않으므로 필드 값으로 사용하지 않아야 한다.**

```java
// AVOID
public class User {

    private final String name;
    private final Optional<String> postcode;

    public Customer(String name, Optional<String> postcode) {
        this.name = Objects.requireNonNull(name, () -> "Cannot be null");
        this.postcode = postcode;
    }

    public Optional<String> getName() {
        return Optional.ofNullable(name);
    }

    public Optional<String> getPostcode() {
        return postcode;
    }
}
```

Optional 을 **접근자** 에 적용하는 경우도 마찬가지이다. 

위의 예시에서 `name 을 얻기 위해 Optional.ofNullable() 로 반환`하고 있는데, 

Brian Goetz 는 **Getter에 Optional을 얹어 반환하는 것을 두고 `남용`** 하는 것이라고 얘기하였다.

> I think routinely using it as a **return value for getters** would definitely be over-use.
>
> - Brian Goetz(Java Architect) -


<br>


### [ Collection의 경우 Optional이 아닌 빈 Collection 을 사용하라 ]

Collection 의 경우 굳이 Optional 로 감쌀 필요가 없다. 

오히려 **빈 Collection을 사용** 하는 것이 깔끔하고, 처리가 가볍다.

```java
// AVOID
public Optional<List<User>> getUserList() {
    List<User> userList = ...; // null이 올 수 있음

    return Optional.ofNullable(items);
}


// PREFER
public List<User> getUserList() {
    List<User> userList = ...; // null이 올 수 있음

    return items == null
      ? Collections.emptyList()
      : userList;
}
```


<br>


아래의 경우도 사용을 피해야 하는 케이스이다. 

Optional은 비싸기 때문에 최대한 사용을 지양해야 한다 !

아래의 케이스라면 **map 에 `getOrDefault` 메소드** 가 있으니 이걸 활용하는 것이 훨씬 좋다.

```java
// AVOID
public Map<String, Optional<String>> getUserNameMap() {
    Map<String, Optional<String>> items = new HashMap<>();
    items.put("I1", Optional.ofNullable(...));
    items.put("I2", Optional.ofNullable(...));

    Optional<String> item = items.get("I1");

    if (item == null) {
        return "Default Name"
    } else {
        return item.orElse("Default Name");
    }
}


// PREFER
public Map<String, String> getUserNameMap() {
    Map<String, String> items = new HashMap<>();
    items.put("I1", ...);
    items.put("I2", ...);

    return items.getOrDefault("I1", "Default Name");
}
```

<br>


### [ 반환 타입으로만 사용하라 ]

Optional 은 **반환 타입으로써 에러가 발생할 수 있는 경우에 결과 없음을 명확히 드러내기 위해** 만들어졌으며, 

**Stream API 와 결합되어 유연한 체이닝 api** 를 만들기 위해 탄생한 것이다. 

예를 들어 *Stream API 의 findFirst() 나 findAny()* 로 값을 찾는 경우에 어떤 것을 반환하는게 합리적일지 Java 언어를 설계하는 사람이 되어 고민해보자. 

언어를 만드는 사람의 입장에서는 **Null 을 반환하는 것보다 `값의 유무를 나타내는 객체`를 반환** 하는 것이 합리적일 것이다. 

Java 언어 설계자들은 이러한 고민 끝에 Optional 을 만든 것이다.

그러므로 Optional이 설계된 목적에 맞게 *반환 타입으로만 사용* 되어야 한다.

Optional을 잘못 사용하는 것은 비용은 증가시키는 반면에 코드 품질은 오히려 악화시킨다. 
그러므로 위에서 정리한 규칙을 준수하며 올바른 방식으로 Optional을 사용하도록 하자 !

# 2022.10.29 <Optional = Null이 될 수 있는 객체를 감싸는 Wrapper Class>

### [ Optional이 만들어진 이유와 의도 ]

Optional is intended to provide a limited mechanism for library method return types where there needed to be a clear way to represent “no result," and using null for such was overwhelmingly likely to cause errors.

위의 내용을 정리하면 Optional은 null을 반환하면 오류가 발생할 가능성이 매우 높은 경우에 **'결과 없음'을 명확하게 드러내기 위해 메소드의 반환 타입으로 사용되도록 매우 제한적인 경우로 설계**되었다는 것이다. 

### [ 올바른 Optional 사용법 가이드 ]

✔ Optional 변수에 Null을 할당하지 말아라값이 없을 때 Optional.orElseX()로 기본 값을 반환하라

Optional 변수에 Null을 할당하지 말아라

Optional은 컨테이너/박싱 클래스일 뿐이며, Optional 변수에 null을 할당하는 것은 Optional 변수 자체가 null인지 또 검사해야 하는 문제를 야기한다. 

→ 그러므로 값이 없는 경우라면 *Optional.empty()로 초기화* 하도록 하자. 

```java
// AVOID
public Optional<Cart> fetchCart() {

    Optional<Cart> emptyCart = null;
    ...
}
```


✔ 값이 없을 때 Optional.orElseX()로 기본 값을 반환하라

Optional의 장점 중 하나는 함수형 인터페이스를 통해 가독성좋고 유연한 코드를 작성할 수 있다는 것이다. 

가급적이면 isPresent()로 검사하고 get()으로 값을 꺼내기 보다는 orElseGet 등을 활용해 처리하도록 하자.

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

orElseGet은 값이 준비되어 있지 않은 경우, orElse는 값이 준비되어 있는 경우에 사용하면 된다. 

만약 null을 반환해야 하는 경우라면 **orElse(null)을 활용** 하도록 하자. 

만약 값이 없어서 throw해야하는 경우라면 orElseThrow를 사용하면 되고 

그 외에도 다양한 메소드들이 있으니 적당히 활용하면 된다.

추가적으로 Java9 부터는 ifPresentOrElse도 지원하고 있으며,

*Java 10부터는 orElseThrow()의 기본으로 NoSuchElementException()를 던질 수 있다.*



✔ 단순히 값을 얻으려는 목적으로만 Optional을 사용하지 마라

단순히 값을 얻으려고 Optional을 사용하는 것은 Optional을 남용하는 대표적인 경우이다. 

이러한 경우에는 굳이 Optional을 사용해 비용을 낭비하는 것 보다는 직접 값을 다루는 것이 좋다.

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


✔ 생성자, 수정자, 메소드 파라미터 등으로 Optional을 넘기지 마라

Optional을 파라미터로 넘기는 것은 상당히 의미없는 행동이다. 

왜냐하면 넘겨온 파라미터를 위해 자체 null체크도 추가로 해주어야 하고,

코드도 복잡해지는 등 상당히 번거로워지기 때문이다. 

Optional은 반환 타입으로 대체 동작을 사용하기 위해 고안된 것임을 명심해야 하며, 앞서 설명한대로 Serializable을 구현하지 않으므로 *필드 값으로 사용하지 않아야 한다*.

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

Optional을 접근자에 적용하는 경우도 마찬가지이다. 

위의 예시에서 name을 얻기 위해 Optional.ofNullable()로 반환하고 있는데, 

Brian Goetz는 *Getter에 Optional을 얹어 반환하는 것을 두고 남용*하는 것이라고 얘기하였다.

I think routinely using it as a return value for getters would definitely be over-use.
- Brian Goetz(Java Architect) -

- Collection의 경우 Optional이 아닌 빈 Collection을 사용하라

Collection의 경우 굳이 Optional로 감쌀 필요가 없다. 

오히려 *빈 Collection을 사용*하는 것이 깔끔하고, 처리가 가볍다.

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

아래의 경우도 사용을 피해야 하는 케이스이다. 

Optional은 비싸기 때문에 최대한 사용을 지양해야 한다 !

아래의 케이스라면 **map에 getOrDefault 메소드**가 있으니 이걸 활용하는 것이 훨씬 좋다.

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

✔ 반환 타입으로만 사용하라

Optional은 반환 타입으로써 에러가 발생할 수 있는 경우에 결과 없음을 명확히 드러내기 위해 만들어졌으며, 

Stream API와 결합되어 유연한 체이닝 api를 만들기 위해 탄생한 것이다. 

예를 들어 Stream API의 findFirst()나 findAny()로 값을 찾는 경우에 어떤 것을 반환하는게 합리적일지 Java 언어를 설계하는 사람이 되어 고민해보자. 

언어를 만드는 사람의 입장에서는 Null을 반환하는 것보다 값의 유무를 나타내는 객체를 반환하는 것이 합리적일 것이다. 

Java 언어 설계자들은 이러한 고민 끝에 Optional을 만든 것이다.

그러므로 Optional이 설계된 목적에 맞게 *반환 타입으로만 사용*되어야 한다.

Optional을 잘못 사용하는 것은 비용은 증가시키는 반면에 코드 품질은 오히려 악화시킨다. 
그러므로 위에서 정리한 규칙을 준수하며 올바른 방식으로 Optional을 사용하도록 하자 !

# Entity Class에 Lombok @NoArgsConstructor(access=PROTECTED) 를 붙이는 이유

코드를 작성하면서 습관적으로 Entity Class에

@NoArgsConstructor(access = AccessLevel.PROTECTED)  Lombok 어노테이션을 붙여왔다.

이번에 아래 내용에 대해 명확하게 정리하고자 한다.

**0. Lombok의 @NoArgsConstructor 어노테이션이란**

**1. JPA의 Entity Class에 @NoArgsConstructor (기본 생성자) 가 필요한 이유**

**2. JPA의 Entity Class에서 기본 생성자의 access level을 Public 또는 Protected로 제한하는 이유**

**3. @NoArgsConstructor의 access level을 Protected로 제한하였을 때의 장점**

<br>

### 0. Lombok의 @NoArgsConstructor 어노테이션이란

Lombok에는 @NoArgsConstructor라는 어노테이션이 존재한다.

해당 어노테이션을 붙이면, **'매개변수가 없는 생성자'** 를 생성해준다.

```java
@NoArgsConstructor
public class TestEntity {
    private String name;
    
    public TestEntity() {
    }
}
```

위처럼 매개변수가 없는 기본 생성자가 이미 존재하는 상태에서 @NoArgsConstructor 어노테이션을 추가하면 아래와 같은 컴파일 오류가 발생한다.

![image](https://github.com/lielocks/WIL/assets/107406265/f4fc122e-24b7-4f32-a511-bc7804c59033)

> 오류 - '매개변수가 없는 생성자가 이미 정의되어 있다'

<br>

### 1. JPA 의 Entity class 에 @NoArgsConstructor (기본 생성자) 가 필요한 이유

JPA 공식 문서에는 Entity Class의 요구사항에 대해 다음과 같은 내용이 포함되어 있다.

<br>

![image](https://github.com/lielocks/WIL/assets/107406265/ce3beaae-9d17-4df3-93d6-77c0b75bca84)

<br>

> Entity Class 는 반드시 매개변수가 없는 public 또는 protected 의 생성자를 가져야 한다.

<br>

우리는 Entity Class 인스턴스를 생성할 때 보통 매개변수가 없는 기본 생성자를 사용할 일이 거의 없다.

그렇다면 왜 JPA의 Entity Class에는 매개변수가 없는 기본 생성자를 만들어야 할까?

JPA 는 **Entity 객체를 인스턴스화** 하고 `필드에 값을 채워넣기 위해` **Reflection** 을 사용해 
`런타임 시점에 동적으로` **기본 생성자를 통해** **`클래스를 인스턴스화하여 값을 매핑`** 하기 때문이다.

이 때, Entity Class 에 기본생성자가 존재하지 않는다면

JPA 는 Entity 객체를 동적으로 인스턴스화 할 수 없으므로 JPA 의 기능을 원활하게 사용하지 못한다.

<br>

### 2. JPA의 Entity Class에서 기본 생성자의 access level을 Public 또는 Protected로 제한하는 이유

그렇다면 기본 생성자의 접근제어자를 왜 `Private이 아닌` **Public** 또는 **Protected** 로만 제한할까? 

JPA는 다른 Entity와 연관관계를 갖는 Entity를 조회할 때

1. 연관된 Entity 객체를 함께 가져오는 **즉시로딩(EAGER)**

2. 연관된 Entity 객체를 실제로 조회할 때 가져오는 **지연로딩(LAZY)**

두 가지 전략을 선택하여 사용할 수 있다.


**`즉시로딩(EAGER)`** 의 경우에는 Entity 조회 시 **연관된 Entity 객체를 즉시 조회** 하지만,

**`지연로딩(LAZY)`** 의 경우에는 Entity 조회 시 연관된 Entity 객체는 **Proxy 객체** 로 존재한다.

이 때, 연관된 Proxy Entity 객체에 직접 접근 할 때, 쿼리가 수행되며 실제 값을 가져오는 것이다.


```java
@Entity
public class Bar {

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
}

//=============

@Entity
public class Foo {

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "bar_id")
    private Bar bar;
	
    ...
}
```

다음과 같이 Bar Entity와 1:1로 연관관계를 맺는 Foo Entity가 있을 때,

FetchType을 **`EAGER`** 로 설정하고 아래와 같이 foo와 연관관계를 가지는 bar의 class type을 조회하면 **실제 객체가 존재** 한다.

```java
@Test
void entityTest() {
    Bar bar = new Bar();
    em.persist(bar);

    Foo foo = new Foo();
    foo.setBar(bar);

    em.persist(foo);

    em.flush();
    em.clear();

    Foo findFoo = em.createQuery("select f from Foo f where f.id = :fooId", Foo.class)
            .setParameter("fooId", foo.getId())
            .getSingleResult();

	// Output : class com.example.entitytest.test.Bar
    System.out.println(findFoo.getBar().getClass());
}
```

반면, FetchType을 **`LAZY`** 로 설정하고 아래와 같이 foo와 연관관계를 가지는 bar의 class type을 조회하면 **Proxy 객체** 가 존재한다.

```java
@Test
void entityTest() {
    Bar bar = new Bar();
    em.persist(bar);

    Foo foo = new Foo();
    foo.setBar(bar);

    em.persist(foo);

    em.flush();
    em.clear();

    Foo findFoo = em.createQuery("select f from Foo f where f.id = :fooId", Foo.class)
            .setParameter("fooId", foo.getId())
            .getSingleResult();

	// Output : class com.example.entitytest.test.Bar$HibernateProxy$olFRLETn
    System.out.println(findFoo.getBar().getClass());
}
```

<br>

LAZY(지연로딩)로 설정하게 되면 이처럼 연관관계를 가지는 Entity 객체는 Proxy 객체로 가져오게 되는데,

이 때 Proxy 객체는 **Entity Class를 상속** 받아 만들어진 객체이므로 Entity의 기본생성자에 대한 접근제어자가 `Private` 일 시,
Entity Class를 상속 받을 수 없어 Proxy 객체를 생성 할 수 없다.

즉, JPA가 **Entity Class를 상속받는 Proxy 객체를 생성** 하기 위해 Entity Class의 기본생성자는 Public 또는 Protected의 접근제어자를 가져야 한다.

<br>

### 3. @NoArgsConstructor의 access level을 Protected로 제한하였을 때의 장점

JPA의 Entity Class는 Public 또는 Protected의 접근제어자를 가지는 `기본 생성자` 를 가져야 함을 알게 되었다.

그렇다면 @NoArgsConstructor(access = AccessLevel.PROTECTED) 와 같이 기본 생성자를 Public이 아닌 **Protected로 제한** 하였을 때 가지는 장점은 무엇일까?

<br>

기본적으로 `객체를 생성` 하고 `값을 채워넣는 방식` 은 크게 3가지로 분류된다.

1. 기본생성자를 통해 객체 생성 - **`setter`** 를 통해 필드값 주입

2. **`매개변수를 가지는 생성자`** 를 통해 **객체 생성과 동시에 필드값 초기화**

   ```java
   public class User {
    private String username;
    private String email;

    // 기본 생성자를 protected로 제한 (JPA 용)
    protected User() {}

    // 정적 팩토리 메서드
    public static User createUser(String username, String email) {
        return new User(username, email);
    }

    // 생성자는 private으로 하여 직접 호출 불가능하게 함
    private User(String username, String email) {
        this.username = username;
        this.email = email;
    }

    // getter 메서드만 제공
    public String getUsername() {
        return username;
    }

    public String getEmail() {
        return email;
    }
   }
   ```
   
<br>

3. **`정적 팩토리 메서드 (static factory method)`** 또는 **`빌더 (builder) 패턴`** 을 통해 **객체 생성과 동시에 필드값 초기화**

   ```java
   public class User {
    private String username;
    private String email;
    private String phoneNumber;

    // 기본 생성자는 protected로 제한
    protected User() {}

    // 빌더를 통해 User 객체를 생성
    private User(UserBuilder builder) {
        this.username = builder.username;
        this.email = builder.email;
        this.phoneNumber = builder.phoneNumber;
    }

    // UserBuilder 클래스
    public static class UserBuilder {
        private String username; // 필수 필드
        private String email;    // 필수 필드
        private String phoneNumber; // 선택 필드

        // UserBuilder 클래스의 생성자
        public UserBuilder(String username, String email) {
            this.username = username;
            this.email = email;
        }

        // 선택 필드를 설정하는 메서드
        public UserBuilder phoneNumber(String phoneNumber) {
            this.phoneNumber = phoneNumber; // 전화번호 설정
            return this; // 메서드 체이닝을 위해 현재 UserBuilder 객체를 반환
        }

        // User 객체를 생성하는 메서드
        public User build() {
            return new User(this); // 생성된 UserBuilder를 사용하여 User 객체 생성
        }
    }

         // Getter 메서드들
         public String getUsername() {
             return username;
         }

         public String getEmail() {
             return email;
         }

         public String getPhoneNumber() {
             return phoneNumber;
         }
     }
   ```

   ```java
   User user = new User.UserBuilder("john_doe", "john@example.com")
                   .phoneNumber("010-1234-5678") // 메서드 체이닝
                   .build(); // User 객체 생성
   ```

<br>

첫 번째, 기본생성자로 객체 생성 후 setter를 통해 필드값을 주입하는 방법은 **객체 값의 변경 가능성을 열어두는 것** 이므로 권장하는 방법이 아니다. 
setter를 통해 언제 어디서든 객체의 값이 변경될 수 있으므로 추후 객체의 값이 어디서 변경되었는지 `추적하기 어렵고` , 객체의 `일관성 유지에도 좋지 않다.`

<br>

setter를 권장하지 않는다는 것은, **객체 생성과 동시에 필드값을 초기화함으로써 객체의 일관성을 유지** 하는 `2,3의 방법이 권장된다` 는 것이다.

(* 이펙티브 자바 도서에는 메서드 이름으로 의미있는 이름을 가질 수 있고, 객체 생성 시 캡슐화가 가능한 정적 팩토리 메서드를 권장한다고 나와있다.)

2, 3의 방법을 권장하게 됨으로써 객체 생성 시 아무런 매개변수를 가지지 않는 기본생성자는 그저 JPA의 Entity Class의 요구사항 이외에는 사용할 일이 없게 된다. 
이러한 기본 생성자를 Public으로 열어두는 것은 여러 위치에서 무분별한 객체 생성을 야기하는 원인이 된다.

<br>

이러한 이유로, **객체의 변경점을 줄이고** 객체의 일관성을 유지하기 위해 **`매개변수를 가지는 생성자`** 또는 **`정적 팩토리 메서드`** 를 통해 객체를 생성할 수 있도록 하고 

**무분별한 객체 생성을 방지** 하기 위해 기본 생성자의 접근제어자는 **`Protected`** 로 제한함으로써 최대한 접근 범위를 작게 가져가는 것이다.

<br>

### 정리

JPA는 `Reflection API` 를 사용하여 `객체를 생성` 하기 때문에 **기본 생성자가 필요** 하고, **`지연로딩(LAZY)`** 으로 인해 생성된 **프록시 객체** 를 사용하기 위해서는 *private로 선언이 불가능* 하기 때문이다.

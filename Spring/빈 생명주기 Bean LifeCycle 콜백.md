## Bean 이 뭘까?

먼저 Bean 을 이해하기 위해 **`스프링 컨테이너 (Spring Container or IoC Container)`** 에 대해서 알 필요가 있습니다.

java 어플리케이션은 어플리케이션 동작을 제공하는 객체들로 이루어져 있습니다.

이때, 객체들은 독립적으로 동작한는 것 보다 서로 상호작용하여 동작하는 경우가 많습니다.

이렇게 **상호작용하는 객체** 를 **`'객체의 의존성'`** 이라고 표현합니다.

Spring 에서는 *Spring Container 에 객체들을 생성하면* **객체끼리 의존성을 주입(DI; Dependency Injection) 하는 역할** 을 해줍니다.

그리고 Spring Container 에 등록한 객체들을 **`Bean 빈`** 이라고 합니다.

<br>


## Spring Container 에 Bean 을 등록하는 두가지 방법

### 1. Component Scan 과 자동 의존관계 설정

Spring Boot 에서 **사용자 클래스를 Spring Bean 으로 동록** 하는 가장 쉬운 방법은 클래스 선언부 위에 **`@Component`** 어노테이션을 사용하는 것입니다.

`@Controller, @Service, @Repository` 는 모두 **@Component 를 포함** 하고 있으며

해당 어노테이션으로 등록된 클래스들은 **Spring Container 에 자동으로 생성되어 Spring Bean 으로 등록** 됩니다.

![image](https://github.com/lielocks/WIL/assets/107406265/91879114-e889-4da5-857f-04b7e6c569ea)

![image](https://github.com/lielocks/WIL/assets/107406265/62dbafbf-1e1b-423a-a75c-483dafb3476f)

![image](https://github.com/lielocks/WIL/assets/107406265/e9182b34-07b9-4579-aa08-93ca7d5dc3e3)


<br>


### 2. 자바 코드로 직접 Spring Bean 등록

이번에는 수동으로 스프링 빈을 등록하는 방법에 대해 알아보겠습니다. 

수동으로 스프링 빈을 등록하려면 자바 설정 클래스를 만들어 사용 해야 합니다.

설정 클래스를 만들고 **`@Configuration`** 어노테이션을 클래스 **선언부 위에 추가** 하면 됩니다. 

그리고 `특정 타입을 리턴하는 메소드` 를 만들고, **`@Bean`** 어노테이션을 붙여주면 **자동으로 해당 타입의 Bean 객체가 생성** 됩니다. 

![image](https://github.com/lielocks/WIL/assets/107406265/52310612-13af-4690-ba3d-7b6d55f54057)

`MemberRepository는 인터페이스` 이고, `MemoryMemberRepository가 구현체` 이기 때문에 **MemoryMemberRepository를 new** 해줍니다.

**@Bean** 어노테이션의 주요 내용은 아래와 같습니다.

+ **`@Configuration`** 설정된 클래스의 **메소드** 에서 사용가능

+ `메소드의 return 객체` 가 **`Spring Bean 객체`** 임을 선언함

+ *Bean 의 이름* 은 기본적으로 **메소드의 이름**

+ **`@Bean(name="name")`** 으로 이름 변경 가능

+ **`@Scope`** 를 통해 **객체 생성을 조정** 할 수 있음

+ **`@Component`** 어노테이션을 통해 **@Configuration 없이도 Bean 객체를 생성** 할 수도 있음

+ Bean 객체에 `init(), destroy() 등 life cycle method` 를 추가한 다음 **@Bean에서 지정** 할 수 있음


<br>


어노테이션 하나로 해결되는 1번 방법이 간단하고 많이 사용되고 있지만, 상황에 따라 2번 방법도 사용됩니다.

-  1번방법을 사용해서 개발을 진행하다 MemberRepository를 변경해야 할 상황이 생기면 1번 방법은 일일이 변경해줘야 하지만,

   2번 방법을 사용하면 다른건 건들일 필요 없이 @Configuration에 등록된 @Bean 만 수정해주면 되므로, 수정이 용이합니다.


<br>


### 등록된 Spring Bean 을 @Autowired 로 사용하기

스프링 부트의 경우 `@Component, @Service, @Controller, @Repository, @Bean, @Configuration` 등으로
**bean 들을 등록** 하고 **필요한 곳에서 `@Autowired` 를 통해 의존성 주입을 받아 사용** 하는 것이 일반적입니다.

<br>


## Bean LifeCycle 콜백 알아보기

Spring 의 **`IoC 컨테이너`** 는 **Bean 객체들을 책임지고 의존성을 관리** 한다.

*객체들을 관리한다는 것* 은 **객체의 생성부터 소멸까지의 생명주기(LifeCycle) 관리** 를 개발자가 아닌 **container 가 대신 해준다** 는 말이다.

**객체 관리의 주체** 가 **`프레임워크(Container)`** 가 되기 때문에 개발자는 로직에 집중할 수 있는 장점이 있다.

<br>


## 빈 생명주기 콜백의 필요성

먼저 **`Callback`** 에 대해 설명하면, 주로 callback 함수를 부를 때 사용되는 용어이며 *Callback 함수를 등록* 하면 **특정 event 가 발생했을 때 해당 method 가 호출** 된다.

즉, 조건에 따라 실행될 수도 실행되지 않을 수도 있는 개념이다.

보통 프로젝트를 하다보면 `DB연결, 네트워크 소켓 연결` 등과 같이 시작 시점에 미리 연결한 뒤 어플리케이션 종료시점에 연결을 종료해야 하는 경우 **객체의 초기화 및 종료 작업** 이 필요할 것이다.
(Ex. Connection Pool 의 connect & disconnect)

Spring Bean 도 위와 같은 원리로 **초기화 작업** 과 **종료 작업** 이 나눠서 진행된다.

간단히 말해서 **`객체 생성 -> 의존관계 주입`** 이라는 Life Cycle 을 가진다.

즉, Spring Bean 은 **의존관계 주입이 다 끝난 다음에야** 필요한 데이터를 사용할 수 있는 준비가 완료된다.


<br>


## 의존성 주입 과정

![image](https://github.com/lielocks/WIL/assets/107406265/59312b9b-ed0c-4a5c-929e-0c7bdebc549a)

가장 처음에는 Spring IoC 컨테이너가 만들어지는 과정이 일어난다.

위의 그림은 SpringBoot 에서 Component-Scan 으로 `Bean 등록을 시작` 하는 과정을 그림으로 표현한 것이다.

![image](https://github.com/lielocks/WIL/assets/107406265/093ad5a8-37b3-4fdb-b942-2b1600dd1730)

위와 같이 **`@Configuration`** 방법을 통해 Bean 으로 등록할 수 있는 어노테이션들과 설정 파일들을 읽어 IoC 컨테이너 안에 Bean 으로 등록시킨다.

<br>


![image](https://github.com/lielocks/WIL/assets/107406265/9e9b67e1-b68b-4d9f-abbf-ecee5114986f)

그리고 의존 관계를 주입하기 전의 준비 단계가 존재한다.

이 단계에서 객체의 생성이 일어난다.

여기서 한가지 알고 넘어가야 할 부분 !

+ 생성자 주입 : **`객체의 생성` 과 `의존관계 주입` 이 동시에 일어남**

+ Setter, Field 주입 : **`객체의 생성 -> 의존관계 주입`** 으로 Life Cycle 이 나누어져 있음

<br>


즉, 생성자 주입은 위의 그림이 동시에 진행된다는 뜻이다.

왜 생성자 주입은 동시에 일어나는 것일까?

<br>


```java
@Controller
public class CocoController {
    private final CocoService cocoService;

    public CocoController(CocoService cocoService) {
        this.cocoService = cocoService;
    }
}
```


자바에서 new 연산을 호출하면 생성자가 호출 된다.

Controller 클래스에 존재하는 Service 클래스와의 의존관계가 존재하지 않는다면, 

다음과 같이 Controller 클래스는 객체 생성이 불가능할 것이다.

> Java 에서 생성자가 하나라도 정의되어 있는 경우에는 기본 생성자가 자동으로 생성되지 않기 때문입니다.


<br>


```java
public class Main {
    public static void main(String[] args) {

        // CocoController controller = new CocoController(); // 컴파일 에러

        CocoController controller1 = new CocoController(new CocoService());
    }
}
```

그렇기 때문에 **생성자 주입** 에서는 **객체 생성, 의존관계 주입이 하나의 단계에서** 일어나는 것이다.

이를 통해 얻는 이점은 다음과 같다.

1. null을 주입하지 않는 한 `NullPointerException` 은 발생하지 않는다.
  
2. 의존관계를 주입하지 않은 경우 객체를 생성할 수 없다. 즉, **의존관계에 대한 내용을 외부로 노출** 시킴으로써 **`컴파일 타임에 오류`** 를 잡아낼 수 있다.
  
이번에는 setter 주입의 경우를 보겠다.

<br>


```java
@Controller
public class CocoController {

    private CocoService cocoService;

    @Autowired
    public void setCocoService(CocoService cocoService) {
        this.cocoService = cocoService;
    }
}
```

<br>


`setter 주입` 의 경우 Controller 객체를 만들 때 **의존 관계는 필요하지 않다.**

즉, `생성자 주입과는 다르게` Controller 객체를 만들때 **Service 객체와 의존 관계가 없어도** Controller 객체를 만들 수 있다.

따라서 **객체 생성 → 의존 관계 주입의 단계로 나누어서 Bean LifeCycle** 이 진행된다.

![image](https://github.com/lielocks/WIL/assets/107406265/292cddb5-d27d-47d1-84ad-7a030dc846f2)

그래서 위와 같이 코드에 작성한 의존관계를 보고 IoC 컨테이너에서 의존성 주입을 해준다.


<br>


## Spring Bean 이벤트 Life Cycle

먼저 스프링 Bean의 LifeCycle을 보면 다음과 같다.


> **스프링 IoC 컨테이너 생성 → 스프링 빈 생성 → 의존관계 주입 → `초기화 콜백 메소드 호출` → 사용 → `소멸 전 콜백 메소드 호출` → 스프링 종료**


Spring 은 *의존관계 주입이 완료되면* **Spring Bean 에게 콜백 메소드를 통해 `초기화 시점` 을 알려주며,** 

*Spring Container 가 종료되기 직전* 에도 **소멸 콜백 메소드를 통해 `소멸 시점`** 을 알려준다.

그렇다면, 다음과 같은 질문을 던져볼 수 있겠다.

<br>


> ***Spring Bean Life Cycle 을 압축시키기 위해*** **`생성자 주입을 통해 bean 생성과 초기화를 동시에`** ***진행하면 되지 않을까?***

<br>


### "객체의 생성과 초기화를 분리하자."

+ **생성자**는 `파라미터` 를 받고, `메모리를 할당해서 객체를 생성` 하는 책임을 가진다. 

+ 반면에 **초기화** 는 `이렇게 생성된 값들을 활용` 해서 **외부 connection 을 연결하는 등 무거운 동작** 을 수행한다. 

따라서 `생성자 안에서 무거운 초기화 작업을 함께 하는 것` 보다는 **`객체를 생성하는 부분과 초기화 하는 부분을 명확하게 나누는 것`** 이 유지보수 관점에서 좋다. 

물론, 초기화 작업이 내부 값들만 약간 변경하는 정도로 단순한 경우에는 생성자에서 한번에 처리하는게 나을 수 있다.


<br>


## Bean 생명주기 콜백 3가지

### 1. 인터페이스 (InitializaingBean, DisposableBean)

```java
public class ExampleBean implements InitializingBean, DisposableBean {

    @Override
    public void afterPropertiesSet() throws Exception {
        // 초기화 콜백 (의존관계 주입이 끝나면 호출)
    }

    @Override
    public void destroy() throws Exception {
        // 소멸 전 콜백 (메모리 반납, 연결 종료와 같은 과정)
    }
}
```

<br>


+ **InitalizingBean** 은 `afterPropertiesSet()` 메서드로 초기화를 지원한다. (의존관계 주입이 끝난 후에 초기화 진행)

+ **DisposableBean** 은 `destroy()` 메서드로 소멸을 지원한다. (Bean 종료 전에 마무리 작업, 예를 들면 자원해재 (close() 등) )

이 방식의 단점

+ InitalizingBean, DisposableBean 인터페이스는**spring 전용 interface** 이다. 해당 코드가 **`interface 에 의존`** 한다.

+ `초기화, 소멸 메서드` 를 **override** 하기 때문에 **메서드명을 변경할 수 없다.**

+ 코드를 커스터마이징 할 수 없는 외부 라이브러리에 적용 불가능하다.

스프링 초창기에 나온 방법이며 지금은 거의 사용 X


<br>


### 2. 설정 정보에서 초기화 메서드, 종료 메서드 지정

```java
public class ExampleBean {

    public void initialize() throws Exception {
        // 초기화 콜백 (의존관계 주입이 끝나면 호출)
    }

    public void close() throws Exception {
        // 소멸 전 콜백 (메모리 반납, 연결 종료와 같은 과정)
    }
}

@Configuration
classLifeCycleConfig {

    @Bean(initMethod = "initialize", destroyMethod = "close")
    public ExampleBean exampleBean() {
        // 생략
    }
}
```

<br>


이 방식의 장점 

+ `메서드명` 을 자유롭게 부여 가능하다.

+ spring code 에 **의존하지 않는다.**

+ `설정 정보` 를 사용하기 때문에 code 를 커스터마이징 할 수 없는 **외부 라이브러리에서도 적용 가능** 하다.


<br>


이 방식의 단점

+ Bean 지정시 initMethod 와 destroyMethod 를 직접 지정해야 하기에 번거롭다.


**[ @Bean 의 destroyMethod 속성의 특징 ]**

라이브러리는 대부분 종료 메서드명이 `close` 혹은 `shutdown` 이다.

@Bean 의 destroyMethod 는 기본값이 inferred(추론)으로 등록 

즉, `close, shutdown` 이라는 이름의 메서드가 **종료 메서드라고 추론하고 자동으로 호출** 해준다.

*즉, 종료 메서드를 따로 부여하지 않더라도 잘 작동한다.*

*추론 기능을 사용하기 싫다면* 명시적으로 **`destroyMethod=" " 이라고 지정`** 해줘야 한다.


<br>


### 3. @PostConstruct, @PreDestroy 어노테이션

```java
import javax.annotation.PostConstruct;
import javax.annotation.PreDestroy;

public class ExampleBean {

    @PostConstruct
    public void initialize() throws Exception {
        // 초기화 콜백 (의존관계 주입이 끝나면 호출)
    }

    @PreDestroy
    public void close() throws Exception {
        // 소멸 전 콜백 (메모리 반납, 연결 종료와 같은 과정)
    }
}
```

이 방식의 장점

+ 최신 spring 에서 가장 권장하는 방법이다.

+ 어노테이션 하나만 붙이면 되므로 매우 편리하다.

+ package 가 javax.annotation.xxx 이다. Spring 에 종속적인 기술이 아닌 `JSR-250이라는 자바 표준` 이다. 따라서 **spring 이 아닌 다른 컨테이너에서도** 동작한다.

+ **Component Scan** 과 잘 어울린다.


이 방식의 단점

+ Customizing 이 불가능한 **외부 라이브러리에서 적용이 불가능** 하다.

  + `외부 라이브러리에서 초기화, 종료` 를 해야 할 경우 두번째 방법 @Bean 의 initMethod 와 destroyMethod 속성을 사용하자.




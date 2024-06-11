## 1. Spring 의 AOP proxy 구현 방법(JDK Dynamic Proxy, CGLib Proxy)

### [AOP 에 대한 이해]

AOP 는 부가 기능을 핵심 기능으로부터 분리하기 위해 등장한 기술이다.

부가 기능을 분리함으로써 우리는 해당 로직을 재사용할 수 있고, 핵심 기능은 핵심 역할에만 집중할 수 있도록 도와준다.

**Spring 의 AOP 는 기본적으로 proxy 방식으로 동작** 하도록 되어 있는데, Spring 에서 AOP 를 활용하기 위해서는 `@EnableAspectJAutoProxy` annotation 을 붙여주어야 하며, 

이에 대한 옵션으로 proxyTarget Class 가 있다.

그리고 이 옵션을 주지 않으면 Spring Bean 을 찾지 못하는 등의 에러가 발생할 수 있는데, 

이를 이해하기 위해서 우리가 수동으로 구현하는 프록시 방식과 Spring이 자동으로 구현하는 프록시 방식에 대해 알아보고 왜 이 옵션이 생기게 되었는지 이해보도록 하자.

<br>

### [수동으로 직접 Proxy 구현]

앞서 설명하였듯이 AOP를 구현하는 기본적인 방법은 proxy pattern 을 이용하는 것인데, 우리가 수동으로 직접 AOP를 구현하고자 한다면 다음과 같이 구현할 수 있다.

예를 들어 다음과 같은 DiscountController 와 DiscountService 및 구현체(RateDiscountService) 가 있다고 하자.

```java
@RestController
@RequiredArgsConstructor
public class DiscountController {
    private final DiscountService discountService;
} 

public interface DiscountService {

    int discount();

}

@Service
public class RateDiscountService implements DiscountService {

    @Override
    public int discount() {
        ...
    }

}
```

<br>

우리는 RateDiscountService 의 discount 메소드가 호출되기 이전에 부가 기능을 적용하기 위해 다음과 같이 인터페이스를 구현(implements) 하여 Proxy 객체를 직접 생성할 수 있다.

```java
@Service
public class RateDiscountServiceProxy implements DiscountService {
   
    // 여기서는 RateDiscountService에 해당한다.
    private DiscountService discountService;    

    public DiscountServiceProxy(DiscountService discountService) {
        this.discountService = discountService;
    }

    @Override
    public int discount() {
        // 1. 메소드 호출 전의 부가 기능 처리

        // 2. 실제메소드 호출
        this.discountService.discount()

        // 3. 메소드 호출 후의 부가 기능 처리
    }
}
```

<br>

위와 같이 실제 객체의 메소드가 호출 전 / 후 에 처리해야 하는 부가기능을 추가함으로써 AOP 를 구현할 수 있다.

하지만 이러한 방식은 다음과 같은 문제점을 가지고 있다.

1. 불필요하게 DiscountService 타입의 Bean 이 2개 등록됨

2. DI(Dependency Injection, 의존성 주입) 시에 문제가 발생할 수 있음

Spring 이 1개의 타입에 대해 **불필요하게 여러개의 Bean 을 관리** 해야 할 뿐만 아니라 해당 타입의 Bean 이 여러개이므로 **의존성 주입 시에도 문제가 발생할 여지** 가 있는 것이다.

물론 변수 이름이나 지시자 등으로 피할 수 있지만 이는 번거롭다.

<br>

### [Spring 의 JDK Dynamic Proxy 구현]

위와 같은 문제를 해결하기 위해 Spring 은 Java 언어 차원에서 제공하는 **자동 proxy 생성기를 통해 직접 proxy 객체를 생성** 한 후에 특별한 처리를 해주는데, 이를 **`JDK 동적 Proxy`** 또는 **`JDK Dynamic Proxy`** 라고 부른다.

Spring 은 proxy 를 구현할 때 proxy 를 구현한 객체(RateDiscountServiceProxy) 를 마치 실제 빈(RateDiscountService) 인 것처럼 포장하고, 2개의 Bean 을 모두 등록하는 것이 아니라 ***실제 Bean 을 proxy 가 적용된 Bean 으로 바꿔친다.***

<br>

이러한 방식이 가능한 이유는 proxy 구현 대상(RateDiscountService) 이 인터페이스(DiscountService)를 implements 하고 있으며, 

Spring 이 proxy 구현체(RateDiscountServiceProxy)를 만들때 proxy 대상과 동일한 인터페이스(DiscountService)를 implements 하도록 했기 때문이다. 

즉, proxy 대상(RateDiscountService) 과 proxy 구현체(RateDiscountServiceProxy) 모두 동일한 인터페이스(DiscountService) 타입 및 구현체이기 때문에 기존의 RateDiscountService Bean 을 RateDiscountServiceProxy 로 바꿔치기 하고, Bean 후처리기를 통해 이미 정의된 의존 관계 역시 바꿀 수 있는 것이다.

이를 그림으로 표현하면 다음과 같다.

![image](https://github.com/lielocks/WIL/assets/107406265/cf74db86-b33a-408f-91a0-cbd5e9a33bb3)

기존에는 왼쪽과 같이 실제 Bean 과 Proxy Bean 2개가 Spring Container 에 등록되었다면, Spring 이 JDK Dynamic Proxy 를 구현할 때에는 **Proxy Bean 을 실제 Bean 처럼 구현하고 기존의 Bean 을 대체하도록** 하는 것이다.

이러한 방식은 괜찮아 보이지만 만약 *실제 Bean 을 직접 참조하고 있는 경우*라면 문제가 발생한다.

위의 예제에서 문제가 발생하지 않은 이유는 실제 Bean(RateDiscountService) 이 DiscountService 라는 인터페이스에 의존하고 있고, DiscountController 에서도 DiscountService 에 의존하고 있기 때문이다.

하지만 만약 다음과 같이 결제를 담당하는 PaymentService 에서 구체 클래스(RateDiscountService) 를 주입받고 있다면 어떻게 될까?

```java
@Service
@RequiredArgsConstructor
public class PaymentService {

    private final RateDiscountService rateDiscountService;

}
```
 
Spring 이 새롭게 추가한 RateDiscountServiceProxy 는 DiscountService 인터페이스를 implements 한 class 이지 RateDiscountService 를 상속받은 class 가 아니다. 

그래서 RateDiscountService 타입의 **Bean 을 찾을 수 없어 에러가 발생하게 된다.**

![image](https://github.com/lielocks/WIL/assets/107406265/57ff96bf-581d-483f-b1dd-5f560d6264a7)

또한 JDK Dynamic Proxy 는 interface 를 기반으로 proxy 객체를 생성하는데, **interface 를 구현한 class 가 아니면 proxy 객체를 생성할 수 없다.**

즉, JDK Dynamic Proxy 는 다음과 같은 두가지 한계점이 있다.

+ Proxy 를 적용하기 위해서 반드시 interface 를 생성해야 함

+ 구체 class 로는 Bean 을 주입받을 수 없고, 반드시 interface 로만 주입받아야 함

<br>

하지만 실제 개발을 하다보면 interface 없이 구체 class 에 의존하는 경우도 많은데, AOP 를 적용하기 위해 모든 Bean 들에게 interface 를 만들어주는 것은 상당히 번거롭다. 

또한 구체 class 에 의존해야 하는 경우에는 Bean 을 찾을 수 없어서 에러가 발생하므로 대처가 어렵다. 

이러한 이유로 Spring 은 JDK Dynamic Proxy 방식이 아닌 또 다른 proxy 구현 방식을 구현하였다.

<br>

### [Spring 의 CGLib Proxy 구현]

위와 같은 문제를 해결하기 위해서는 Spring 이 구현해주는 Proxy 객체가 interface(DiscountService)를 기반으로 하지 않고 class(RateDiscountService)를 구현한 객체여야 한다. 

즉, **Class 상속을 기반으로 proxy 를 구현** 하도록 강제해야 하는 것이다.

```java
public class RateDiscountServiceProxy extends RateDiscountService {

    ...  
}
```

<br>

그러면 Spring 은 RateDiscountServiceProxy 를 구현할 때 위와 같이 RateDiscountService 를 상속받아 구현하는데, 이러한 **Class 기반의 proxy 를 구현하기 위해서는 `bytecode` 를 조작** 해야 한다. 

그래서 Spring 은 `CGLib 이라는 byte 조작 library` 를 통해 Class 상속으로 proxy 를 구현함으로써 JDK Dynamic Proxy 의한 문제를 완전히 해결하고 있다. 

CGLib 을 이용한 proxy 방식은 Class 기반의 proxy 이므로 interface 가 없어도 적용 가능하며, interface 가 구현된 Bean 의 경우에도 interface 주입과 구체 class 주입이 모두 가능하다. 

대신 CGLib proxy 는 상속을 이용하므로 기본 생성자를 필요로 하며, *생성자가 2번 호출*되고 *final class 나 final method 면 안된다*는 제약이 있다.
 

<br>

## 2. @EnableAspectJAutoProxy 의 proxyTargetClass

### [@EnableAspectJAutoProxy의 proxyTargetClass]

Spring framework 는 proxy 를 구현할 때 *기존의 방식처럼 interface 를 구현하도록 할 것인지(JDK Dynamic Proxy)* 또는 *해당 Class 를 byte 조작하여 직접 구현하도록 할 것인지(CGLib)* 에 대한 옵션을 제공하고 있는데, 이것이 바로 **`proxyTargetClass`** 이다. 

```java
@SpringBootApplication
@EnableAspectJAutoProxy(proxyTargetClass = true)
public class AtddMembershipApplication {

	public static void main(String[] args) {
		SpringApplication.run(AtddMembershipApplication.class, args);
	}

}
```

<br>

일반적으로 **interface 주입에 의한 문제를 예방하고자 `proxyTargetClass 를 true`** 로 주는 경우가 많은데, SpringBoot 를 사용하고 있다면 더이상 이러한 옵션을 부여하지 않아도 된다. 

왜냐하면 SpringBoot 에서는 CGLib library 가 안정화되었다고 판단하여 proxyTargetClass 옵션의 기본값을 true 로 사용하고 있다.

![image](https://github.com/lielocks/WIL/assets/107406265/5a99d7b4-6d09-4af1-98e9-1359db22b84e)

CGLib 은 원래 외부 library 지만 Spring 이 3.2부터 이를 내장시켰다. 

그리고 objenesis 라는 특별한 library 를 사용해 기본 생성자 없이 객체 생성이 가능하며 생성자가 2번 호출되는 문제 역시 해결하여 스프링 4.0 에서 발전시켰다. 

그리고 이제 더 이상 final 을 제외한 CGLib 의 한계점이 존재하지 않으니 스프링 부트 2.0에서는 기본값으로 설정해둔 것이다.

<br>

여기서 하나 주의할 점은 **@EnableAspectJAutoProxy 어노테이션의 기본값이 true 로 바뀐 것이 아니라는 점** 이다. 

@EnableAspectJAutoProxy 는 SpringBoot 가 아닌 Spring 에서 만들어진 어노테이션이므로 해당 어노테이션의 기본값은 false가 맞다.

```java
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Import(AspectJAutoProxyRegistrar.class)
public @interface EnableAspectJAutoProxy {

	boolean proxyTargetClass() default false;

	boolean exposeProxy() default false;

}
```

위에서 proxyTargetClass 옵션의 기본값을 true 로 바꾼 것은 SpringBoot 에만 해당된다.

SpringBoot 는 애플리케이션을 실행할 때 AutoConfigure 를 위한 정보들을 `spring-boot-autoconfigure` 의 `spring-configuration-metadata.json` 에서 관리하고 있다.

![image](https://github.com/lielocks/WIL/assets/107406265/719fb01a-6da3-4402-93a9-bf3e1a47bdb6)

<br>

그리고 AutoConfigure 를 진행할 때 해당 값을 참조해서 설정을 진행한다. 

그러므로 proxyTargetClass 의 기본값이 true 라는 것은 Spring MVC 가 아닌 SpringBoot 에서만 해당하는 내용이다. 

만약 SpringBoot 에서 proxyTargetClass 의 값을 false 로 설정하려면 property 에서 `spring.aop.proxy-target-class를 false` 로 주면 된다.

```xml
spring.aop.proxy-target-class=false
```

<br>

만약 spring-boot-starter-aop 의존성이 추가되어 있다면 AopAutoConfiguration 을 통한 자동 설정에 의해 @EnableAspectJAutoProxy 를 추가하지 않아도 된다.

<br>

### [정리 및 요약]

원래 spring 은 proxy target 객체에 interface 가 있다면 그 interface 를 구현한 JDK Dynamic Proxy 방식으로 객체를 생성하고, interface 가 없다면 CGLib 를 이용한 Class proxy 를 만든다.

1. Interface 를 구현하고 있는지 확인함

2. Interface 를 구현하고 있으면 JDK Dynamic Proxy 방식으로 객체를 생성

3. Interface 를 구현하지 않으면 CGLib 방식으로 객체를 생성

<br>

하지만 JDK Dynamic Proxy 방식은 2가지 한계점이 있다.

+ Proxy 를 적용하기 위해 반드시 Interface 를 생성해야 함

+ 구체 Class 로는 Bean 을 주입받을 수 없고, 반드시 Interface 로만 주입받아야 함

<br>

그래서 Spring 은 CGLib 방식의 Proxy 를 강제하는 옵션을 제공하고 있는데, 이것이 바로 **`proxyTargetClass`** 이며, 이 값을 **true** 로 지정해주면 Spring 은 interface 가 있더라도 무시하고 Class Proxy 를 만들게 된다.

SpringBoot 에서는 CGLib library 가 갖는 단점들을 모두 해결하였고, proxyTargetClass 옵션의 기본값을 true 로 사용하고 있다.

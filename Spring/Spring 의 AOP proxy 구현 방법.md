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


# @Configuration 과 bytecode 조작의 마법


Spring Container 는 Singleton Registry 이다. 
따라서 Spring Bean 이 singleton 이 되도록 보장해주어야 한다. 

그런데 Spring 이 자바 코드까지 어떻게 하기는 어렵다. 
저 자바 코드를 보면 분명 3번 호출되어야 하는 것이 맞다.

그래서 Spring 은 Class 의 bytecode 를 조작하는 library 를 사용한다.

모든 비밀은 `@Configuration` 을 적용한 `AppConfig` 에 있다.

다음 코드를 보자.

</br> 

```java
@Test
void configurationDeep() {
  ApplicationContext ac = new AnnotationConfigApplicationContext(AppConfig.class); // AppConfig 도 Spring Bean 으로 등록된다.
  AppConfig bean = ac.getBean(AppConfig.class);
  System.out.println("bean = " + bean.getClass());
  // 출력 : bean = class hello.core.AppConfig$$EnhancerBySpringCGLIB$$bd479d70
}
```

</br> 

사실 `AnnotationConfigApplicationContext` 에 파라미터로 넘긴 값은 Spring Bean 으로 등록된다. 

그래서 **`AppConfig`** 도 Spring Bean 이 된다.

**`AppConfig`** Spring Bean 을 조회해서 Class 정보를 출력해보자.

</br> 

```text
bean = class hello.core.AppConfig$$EnhancerBySpringCGLIB$$bd479d70
```

</br> 

*순수한 Class* 라면 다음과 같이 출력되어야 한다.

`class hello.core.AppConfig`

그런데 예상과는 다르게 Class 명에 `xxxCGLIB`가 붙으면서 상당히 복잡해진 것을 볼 수 있다. 

이것은 내가 만든 Class 가 아니라 스프링이 **CGLIB 라는 bytecode 조작 library 를 사용**해서 AppConfig Class 를 상속받은 임의의 다른 Class 를 만들고, 
그 다른 Class 를 Spring Bean 으로 등록한 것이다!


**그림**
![image](https://github.com/lielocks/WIL/assets/107406265/9794f268-327d-4443-b5be-d7b29c12bd83)

그 임의의 다른 Class 가 바로 singleton 이 보장되도록 해준다. 아마도 다음과 같이 bytecode 를 조작해서 작성되어 있을 것이다.

(실제로는 CGLIB 의 내부 기술을 사용하는데 매우 복잡하다.)


**AppConfig@CGLIB 예상 코드**


```java
@Bean
public MemberRepository memberRepository() {
  if (memoryMemberRepository가 이미 Spring Container 에 등록되어 있으면?) {
    return Spring Container 에서 찾아서 반환;
  } else { // Spring Container 에 없으면 기존 로직을 호출해서 MemoryMemberRepository 를 생성하고 Spring Container 에 등록
    return 반환
    }
}
```

@Bean 이 붙은 메서드마다 이미 Spring Bean 이 존재하면 존재하는 Bean 을 반환하고, `Spring Bean 이 없으면 생성해서 Spring Bean 으로 등록하고 반환하는 코드`가 동적으로 만들어진다.

*덕분에 Singleton 이 보장되는 것이다.*


**참고** AppConfig@CGLIB 는 AppConfig 의 자식 타입이므로, AppConfig 타입으로 조회 할 수 있다.

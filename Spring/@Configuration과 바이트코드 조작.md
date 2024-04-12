# @Configuration과 바이트코드 조작의 마법


스프링 컨테이너는 싱글톤 레지스트리다. 
따라서 스프링 빈이 싱글톤이 되도록 보장해주어야 한다. 

그런데 스프링이 자바 코드까지 어떻게 하기는 어렵다. 
저 자바 코드를 보면 분명 3번 호출되어야 하는 것이 맞다.

그래서 스프링은 클래스의 바이트코드를 조작하는 라이브러리를 사용한다.
모든 비밀은 `@Configuration` 을 적용한 `AppConfig` 에 있다.
다음 코드를 보자.

</br> 

```java
@Test
void configurationDeep() {
  ApplicationContext ac = new AnnotationConfigApplicationContext(AppConfig.class); //AppConfig도 스프링 빈으로 등록된다.
  AppConfig bean = ac.getBean(AppConfig.class);
  System.out.println("bean = " + bean.getClass());
  //출력: bean = class hello.core.AppConfig$$EnhancerBySpringCGLIB$$bd479d70
}
```

</br> 

사실 `AnnotationConfigApplicationContext` 에 파라미터로 넘긴 값은 스프링 빈으로 등록된다. 그래서 `AppConfig` 도 스프링 빈이 된다.
`AppConfig` 스프링 빈을 조회해서 클래스 정보를 출력해보자.

</br> 

```text
bean = class hello.core.AppConfig$$EnhancerBySpringCGLIB$$bd479d70
```

</br> 

순수한 클래스라면 다음과 같이 출력되어야 한다.
`class hello.core.AppConfig`

그런데 예상과는 다르게 클래스 명에 `xxxCGLIB`가 붙으면서 상당히 복잡해진 것을 볼 수 있다. 
이것은 내가 만든 클래스가 아니라 스프링이 **CGLIB라는 바이트코드 조작 라이브러리를 사용**해서 AppConfig 클래스를 상속받은 임의의 다른 클래스를 만들고, 
그 다른 클래스를 스프링 빈으로 등록한 것이다!


**그림**
![image](https://github.com/lielocks/WIL/assets/107406265/9794f268-327d-4443-b5be-d7b29c12bd83)

그 임의의 다른 클래스가 바로 싱글톤이 보장되도록 해준다. 아마도 다음과 같이 바이트 코드를 조작해서 작성되어 있을 것이다.

(실제로는 CGLIB의 내부 기술을 사용하는데 매우 복잡하다.)


**AppConfig@CGLIB 예상 코드**


```java
@Bean
public MemberRepository memberRepository() {
  if (memoryMemberRepository가 이미 스프링 컨테이너에 등록되어 있으면?) {
    return 스프링 컨테이너에서 찾아서 반환;
  } else { //스프링 컨테이너에 없으면 기존 로직을 호출해서 MemoryMemberRepository를 생성하고 스프링 컨테이너에 등록
    return 반환
    }
}
```

@Bean이 붙은 메서드마다 이미 스프링 빈이 존재하면 존재하는 빈을 반환하고, `스프링 빈이 없으면 생성해서 스프링 빈으로 등록하고 반환하는 코드`가 동적으로 만들어진다.
*덕분에 싱글톤이 보장되는 것이다.*


**참고** AppConfig@CGLIB는 AppConfig의 자식 타입이므로, AppConfig 타입으로 조회 할 수 있다.

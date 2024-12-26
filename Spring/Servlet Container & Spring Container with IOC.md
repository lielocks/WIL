![image](https://github.com/user-attachments/assets/550717d1-0fba-45ea-bea8-054204e37665)

## Spring Container는 어떻게 생성되는가?

![image](https://github.com/user-attachments/assets/b04b09af-a9f5-43fa-ac40-9849b25917b1)

![image](https://github.com/user-attachments/assets/0bb0a362-cf27-4f70-8b32-c6d3f068d8af)


Spring Container는 Bean 생명주기를 관리한다. 

Bean 을 관리하기 위해 **IoC** 가 이용된다. 

Spring Container 에는 BeanFactory 가 있고, ApplicationContext 는 이를 상속한다. 

이 두 개의 컨테이너로 의존성 주입된 빈들을 제어할 수 있다.

1. WebApplication 이 실행되면, **WAS(Tomcat, ServletContainer per process)** 에 의해 `web.xml` 이 로딩된다.

2. `web.xml` 에 등록되어 있는 ContextLoaderListener 가 Java Class 파일로 생성된다. 

   **ContextLoaderListener** 는 ServletContextListener 인터페이스를 implements 한 것으로서, root-content.xml 또는 ApplicationContext.xml 에 따라 **ApplicationContext** 를 생성한다.

   **ApplicationContext 에는 Spring Bean 이 등록되고 공유되는 곳** 인데, Servlet Context 는 Spring Bean 에 접근하려면 Application Context 를 참조해야 한다. 

   ***ApplicationContext 도 ServletContainer 에 단 한 번만 초기화되는 Servlet 이다.***

3. ApplicationContext.xml 에 등록되어 있는 설정에 따라 Spring Container 가 구동되며, 이 때 개발자가 작성한 비즈니스 로직과 DAO, VO 등의 객체가 생성된다.

4. Client 로부터 Web Application 요청이 왔다.

   **Spring 의 DispatcherServlet 도 Servlet 이니 이 때 딱 한 번만 생성된다.** 

   DispatcherServlet 은 Front Controller 패턴을 구현한 것이다. 

   처음에 Request 가 들어오면, Dispatcher Servlet 으로 간다. 

   web.xml 에는 servlet 이 등록되어 있는데, Dispatcher Servlet 도 Servlet 이기 때문에 web.xml 에 등록이 되어 있다. 

   모든 요청이 오면 Dispatcher Servlet 로 가라고 하고 등록을 시켜 놓는다.

5. 그러면 그에 맞는 요청에 따라 적절한 Controller 를 찾는다.

   **Handler > Controller** 보다 더 큰 개념인데, handler mapping 을 통해서 요청에 맞는 controller 를 찾아준다.

   HandlerMapping 에는 BeanNameHandlerMapping 이 있어, Bean 이름과 Url 을 Mapping 하는 방식이 default 로 지정되어 있다.

6. HandlerMapping 에서 찾은 Handler(Controller)의 method 를 호출하고, 이를 ModelAndView 형태로 바꿔준다.

<br>

![image](https://github.com/user-attachments/assets/6388ae59-7d8d-4a44-824f-5ca26cfda9b8)


결국 개발자가 작성한 비즈니스 로직도 ServletContainer 가 관리하게 되고, **`Spring MVC`** 도 **ServletContainer 가 관리하고 있는 Servlet 한 개** 를 의미한다. 

Spring MVC 로 들어가는 모든 요청과 응답은 DispatcherServlet 이 관리하고 있는 것이다. 

물론 Spring Container 는 Spring 의 자체 Configuration 에 의해 생성되기는 하다. 

(Spring Boot uses Spring configuration to bootstrap itself and the embedded Servlet container.)

<br>


아무튼 요는 **Servlet Container는 Process 하나에 배정되어 있는 것이요, 이에 따르는 요청들은 Thread 별로 처리하도록 ThreadPool에서 역할을 배정시키는 것이다.** 

**그 중, 클라이언트가 임의의 servlet 을 실행하라고 요청했는데 만약 최초의 요청이면 `init()` 을 실행하고, 아니라면 새로 servlet 을 만들지 않고 Method 영역에 있는 servlet 을 참고해서 `service()` 를 실행하는 것이다.** 

이렇게 개발자가 아닌 프로그램에 의해 객체들이 관리되는 것을 **IoC(Inversion of Control)** 라고 한다.

<br>


> Spring Web MVC 가 없던 과거에는, URL 마다 Servlet 를 생성하고 Web.xml 로 Servlet 로 관리했다.
> 
> URL 마다 servlet 이 하나씩 필요하다 보니, 매번 Servlet instance 를 만들어야 했다.
> 
> 그런데 **Dispatcher Servlet** 이 도입된 이후에는 **`FrontController 패턴`** 을 활용할 수 있게 되면서 매번 servlet instance 를 만들 필요가 없어졌다.
> 
> 또한, **View 를 강제로 분리** 하는 효과도 볼 수 있게 되었다.

<br>

---

## Spring Boot는 어떻게 동작하는가?

Spring Boot 는 **Embedded Tomcat** 을 갖고 있다. 

원래는 web.xml 에 URL 별로 일일이 Bean 을 매칭시켜야 하지만, 그러는 것은 불가능하니 MVC 패턴을 활용하여 *Model(business logic), View(화면), Controller(최초 Request를 받는 곳)* 으로 나누고 개발을 하는 것이다. 

실행 흐름은 다음과 같다.

1. DispatcherServlet 이 Spring 에 @Bean 으로 등록되어진다.

2. DispatcherServlet Context 에 servlet 을 등록한다.

3. Servlet Container Fileter 에 등록설정 해놓은 filter 들을 등록한다.

4. DispatcherServlet 에 각종 handler mapping(자원 url) 들이 등록된다. (Controller Bean 들이 다 생성되어 Singleton 으로 관리되어 진다.)

<br>

여기서 **`DispatcherServlet`** 은 **FrameworkServlet** 을 상속하고, 이는 또 다시 **HttpServlet** 을 상속한다. 

여기서 주의할 점은, ServletContainer 처럼 요청이 왔을 때 객체를 생성하는 것이 아니라 **이미 @Controller 가 @Bean Singleton 으로 등록되어 있다는 것** 을 상기할 필요가 있다.

<br>

1. `FrameworkServlet.service()` 가 호출되면

2. `FrameworkServlet.service()` 는 `dispatch.doService()` 를 호출하고

3. `dispatch.doService()` 는 `dispatch.doDispatch()` 를 실행하고

4. `doDispatch()` 는 AbstractHandlerMapping 에서 **Handler(Controller)** 를 가져온다.

5. Interceptor 를 지나서 해당 Controller Method 로 이동한다.

6. 해당 Handler 는 ModelAndView 를 return 한다.

   @RestController 라면 컨버터를 이용하여 바로 결과값을 return 할 것이다.

   View 에 대한 정보가 있으면 ViewResolver 에 들려 View 객체를 얻고, View 를 통해 rendering 을 한다.

<br>


## rootApplicationContext vs childApplicationContext

![image](https://github.com/user-attachments/assets/f1d4b5ac-aade-4020-9fb3-f223404db949)

Spring Web MVC 에는 총 3가지의 **Context** 가 존재한다. 

하나는 **`ServletContext`** 이다. 

Servlet API 에서 제공하는 context 로 모든 servlet 이 공유하는 context 이다. 

특히, Spring Web MVC 에서는 ServletContext 가 WebApplicationContext 를 가지고 있다. 

또 하나는 **`ApplicationContext`** 로, Spring 에서 만든 Application 에 대한 context를 가지고 있다.

<br>

마지막으로, **`WebApplicationContext`** 란 Spring 의 ApplicationContext 를 확장한 인터페이스로, Web Application 에서 필요한 몇 가지 기능을 추가한 인터페이스다. 

예를 들면 WebApplicationContext 의 구현체는 `getServletContext` 라는 메소드를 통해 ServletContext 를 얻을 수 있다. 

Spring의 DispatcherServlet 은 web.xml 을 통하여 WebApplicationContext 를 바탕으로 자기 자신을 설정한다.

![image](https://github.com/user-attachments/assets/9d5bf72b-8c2f-45b1-a48b-f7f540a0e66e)

Context 는 계층 구조를 가질 수 있는데, 예를 들어 부모-자식 관계이거나 상속 관계일 수 있다. 

하나의 root WebApplicationContext(또는 root-context.xml) 밑에 여러 개의 child WebApplicationContext(또는 servlet-context.xml) 를 가질 수 있다. 

Data Repository 나 business service 와 같이 공통 자원은 root에 두고, DispatcherServlet 마다 자신만의 child Context 를 갖도록 만들어 자신들의 Servlet 에서만 사용할 빈들을 가지고 있도록 한다.

![image](https://github.com/user-attachments/assets/1f9e15e2-b794-40d4-93c1-ab7ca8b98e15)
> RootWebApplicationContext 와 Servlet(child) WebApplicationContext 는 서로 부모-자식 관계이다

<br>

---

## Servlet 은 어떻게 Spring Container 를 look-up 하나?

그렇다면 다음과 같은 질문이 생긴다. 

Servlet 은 어떻게 Spring Container 를 look-up 할 지를 결정하나? 어떠한 방식으로 Spring Container 와 소통하는 걸까?

> **`Spring 의 Bean`** 은 Servlet 이라기 보다는, **Container 가 Reflection 을 통해 만들어낸 POJO** 라고 볼 수 있다.
>
> Servlet 은 이러한 POJO 를 바탕으로, Spring Container 에서 look-up 해서 Servlet Container 에 올려 마치 servlet 처럼 사용하도록 한다.
>
> 예를 들어, **Spring 의 Object 들이 HttpRequest 를 listening 할 수 있도록 내부적으로 Proxy 역할을 해주는 것이다.**

<br>


Spring Container 는 Bean Initializing 작업을 거친다. 

Spring Container 에서 Bean 은 Bean Definition 객체로 정의해둔 후, 객체를 생성한다. 

Bean 생성 시 Bean Definition 정의에 따라 객체 생성에 대한 정보를 참조한다. 

이후, **Java Reflection 을 통해 객체를 생성** 한다.

<br>

**Container 가 Bean 생성 시,** Service-Locator 패턴으로 의존성을 주입하며 생성한다. 

**`Service-Locator`** 패턴은, cache 라는 map 객체에서 home 객체를 찾은 결과를 보관하여 저장한다. 

먼저 cache 에서 해당 객체를 찾아보고, 존재하지 않으면 memory 에서 해당 객체를 찾는 방식이다. 

Memory 에서 찾으면 0.01ms 도 소요되지 않으므로, 큰 성능 향상을 가져올 수 있겠다. 

객체를 사용하는 곳에서 생성해서, 객체 간에 강한 결합도를 갖는 것이 아니다. 

외부 container 에서 생성된 객체를 주입함으로서 객체 결합도를 낮추는 효과가 있다.

```java
public class ServiceLocator {
    private InitialContext ic;
    private Map cache;
    private static ServiceLocator serviceLocator;

    static {
    	serviceLocator = new ServiceLocator();
    }

    private ServiceLocator() {
    	cacheMap = Collections.synchronizedMap(new HashMap());
    }

    public InitialContext getInitalContext() throws Exception {
    	try {
        	if (ic == null) {
            	ic = new InitialContext();
            }
        } catch (Exception e) {
        	throw e;
        }
        return ic;
    }

    public static ServiceLocator getInstance() {
    	return serviceLocator;
    }
    
    public EJBLocalHome getLocalHome(String jndiHomeName) throws Exception {
    	EJBLoclaHome home = null;
  	try {
   		if (cache.containsKey(jndiHomeName)) {
    		home = (EJBLocalHome)cache.get(jndiHomeName);
   		} else {
    			home = (EJBLocalHome)getInitialContext().lookup(jndiHomeName);
    			cache.put(jndiHomeName, home);
   		}
  	} catch (Exception e) {
   		throw new Exception(e.getMessage());
  	}
  	return home;
    }
}
```

Spring framework 를 시작하면, Spring Container 가 initialize 되고, @ComponentScan 으로 정의한 Component 를 찾아 Bean 으로 등록하는 절차를 수행한다.

먼저, Scan을 통해 Bean 타겟을 찾아 BeanDefinition을 정의한다.

![image](https://github.com/user-attachments/assets/212354a9-eb10-4fa7-a235-eb1d6dd4fb6a)

이후, `org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory` 클래스에서 createBeanInstance 생성 method 를 찾을 수 있다.

![image](https://github.com/user-attachments/assets/28682e82-71b7-4311-b359-78697f60c633)

실제 Bean 을 생성하는 코드는 `org.springframework.beans.BeanUtil` 에 있다.

![image](https://github.com/user-attachments/assets/92c3b143-424b-4eaa-a27c-ba72fdca41bc)

<br>

Sample Container 를 만든다고 가정하자.

```java
// Inject.java
@Retention(RetentionPolicy.RUNTIME)
public @interface Inject {
}

// SampleContainer.java
public class SampleContainer {
    public static <T> T getObject(Class<T> clazz) {
        T instance = createInstance(clazz);

        for (Field field : clazz.getDeclaredFields()) {

            if (field.getDeclaredAnnotation(Inject.class) != null) {
                Object filedInstance = createInstance(field.getType());
                try {
                    field.setAccessible(true);
                    field.set(instance, filedInstance);
                } catch (IllegalAccessException e) {
                    throw new RuntimeException("fail to set field", e);
                }
            }

        }
        return instance;
    }

    private static <T> T createInstance(Class<T> clazz) {
        try {
            return clazz.getConstructor().newInstance();
        } catch (InstantiationException | InvocationTargetException | NoSuchMethodException | IllegalAccessException e) {
            throw new RuntimeException("fail to create instance", e);
        }
    }
}

// SampleComponent.java
public class SampleComponent {

    @Inject
    private SampleRepository sampleRepository;

    public void doSomething() {
        List<String> results = sampleRepository.findAll();
        for (String str : results) {
            System.out.println("result : " + str);
        }
    }

}

// SampleRepository.java
public class SampleRepository {
    public List<String> findAll() {
        return Arrays.asList("AA", "BB", "CC");
    }
}

// Main.java
public class Main {
    public static void main(String[] args) {
        SampleComponent sampleComponent = SampleContainer.getObject(SampleComponent.class);
        sampleComponent.doSomething();
    }
}
```

위 코드를 잘 보면, 

SampleContainer 에서 SampleComponent 객체를 생성할 때, **Reflection 을 통해 객체를 생성** 하고 

@Inject 로 주입되는 SampleRepository 또한 **Reflection** 으로 넣어주는 것을 알 수 있다.

<br>

## 결론

**`Apache Tomcat`** 은 process 로 동작한다. 

**`Apache`** 는 **Web Server** 이고, **`Tomcat`** 은 **ServletContext** 인데 **Apache 하나는 필요에 따라 여러 개의 Tomcat Instances** 를 가질 수 있다. 

**Tomcat 하나** 는 **Single Servlet** 이다. 

**`Tomcat 의 Instance`** 는 **각각 Instance 마다 Acceptor Thread 한 개** 가 있고, **Dedicated Thread Pool** 을 보유하고 있다. 

**`Tomcat`** 은 기본적으로 **one thread per request** 를 주장하고 있기 때문에, **HTTP Request 하나가 들어올 때 하나의 Thread** 를 배정한다. 

Request 가 종료되면 Thread Pool 에 돌려주어 해당 Thread 를 재사용할 수 있도록 한다.

<br>

**Instance 하나** 는 **여러 Thread 가 공유하는 ServletContainer** 를 의미한다. 

Servlet 이 생성될 때, ServletContainer 에 이미 만들어지지 않았다면 새로 만든다. 

Servlet 을 이미 만든 적이 있다면, 이를 재사용한다. 

그렇기 때문에 **Servlet 은 재사용이 가능한 형태로 Stateless 하면서 Immutable** 하게 구현해야 한다. 

상태가 없는 객체를 공유하기 때문에 별도의 동기화 과정은 필요하지 않다. 

<br>

*따라서 Controller 가 수십회건 수만회건 요청을 받아도 문제가 생기지 않는다.*

![image](https://github.com/user-attachments/assets/f5e9d911-ebac-43ca-a295-c28fedbcd23f)

Servlet 의 종류에는 **`@WebServlet`** 과 **`Spring @Bean`** 이 있다. 

어디서 관리하느냐에 차이다. 

**Tomcat** 이 관리하냐? **Spring** 이 관리하냐? 

**Bean** 의 경우에는 **POJO 와 설정(Configuration Metadata)** 을 **Spring 이 제공하는 Container(DI Container, 또는 IoC Container) 에 주입** 시키면 Bean 으로 등록되고 사용이 가능하다. 

결국 Spring 을 쓴다는 것은 **Spring 으로 Servlet 을 다루겠다** 는 뜻이다. 

***Spring MVC*** 역시 Servlet Container 가 관리하고 있는 ***Servlet*** 이다.

> **그래서 Servlet 없이 Spring MVC 만 있으면 된다고 하는것** 은 *비지니스 로직을 Spring 을 통해 처리하겠다* 는 것이지 **Servlet 이 필요없다는 얘기가 아니다.**

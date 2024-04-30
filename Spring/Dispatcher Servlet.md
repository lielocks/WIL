## 1. Dispatcher-Servlet 디스패처 서블릿의 개념

***Dispatcher-Servlet 디스패처 서블릿이란?***

<br>

디스패처 서블릿의 dispatch 는 "보내다" 라는 뜻을 가지고 있습니다.

그리고 이러한 단어를 포함하는 디스패처 서블릿은 **HTTP 프로토콜로 들어오는 모든 요청을 가장 먼저 받아 
적합한 controller 에 위임해주는 프론트 컨트롤러(Front Controller)** 라고 정의할 수 있습니다.

이것을 보다 자세히 설명하자면, `클라이언트로부터 어떠한 요청` 이 오면 *Tomcat(톰캣) 과 같은 서블릿 컨테이너가 요청을 받게 됩니다.*

그리고 이 모든 요청을 **프론트 컨트롤러인 디스패처 서블릿이 가장 먼저** 받게 됩니다.

그러면 디스패처 서블릿은 **`공통적인 작업을 먼저 처리`** 한 후에 **해당 요청을 처리해야 하는 컨트롤러를 찾아서 작업을 위임** 합니다.

여기서 Front Controller (프론트 컨트롤러) 라는 용어가 사용되는데, 

Front Controller 는 주로 서블릿 컨테이너의 제일 앞에서 서버로 들어오는 클라이언트의 모든 요청을 받아서 처리해주는 컨트롤러로써,

MVC 구조에서 함께 사용되는 디자인 패턴입니다.

<br>

### [Dispatcher-Servlet 디스패처 서블릿 의 장점]

Spring MVC 는 Dispatcher Servlet 이 등장함에 따라 web.xml 의 역할을 상당히 축소시켜주었습니다.

과거에는 모든 서블릿을 URL 매핑을 위해 web.xml 에 모두 등록해주어야 했지만,

**Dispatcher-Servlet 이 해당 어플리케이션으로 들어오는 모든 요청을 핸들링** 해주고 **`공통 작업을 처리`** 해주면서 
상당히 편리하게 이용할 수 있게 되었습니다.

우리는 controller 를 구현해두기만 하면 Dispatcher Servlet 이 알아서 적합한 컨트롤러로 위임을 해주는 구조가 되었습니다.

<br>

### [정적 자원 Static Resources 의 처리]

Dispatcher Servlet 이 요청을 Controller 로 넘겨주는 방식은 효율적으로 보입니다.

하지만 Dispatcher Servlet 이 모든 요청을 처리하다 보니 이미지나 HTML/CSS/JavaScript 등과 같은 정적 파일에 대한 요청마저 모두 가로채는 까닭에 
정적자원(Static Resources) 를 불러오지 못하는 상황도 발생하곤 했습니다.

이러한 문제를 해결하기 위해 개발자들이 고안한 2가지 방법 !

1. 정적 자원 요청과 어플리케이션 요청을 분리

2. 어플리케이션 요청을 탐색하고 없으면 정적 자원 요청으로 처리

<br>

### 1. 정적 자원 요청과 어플리케이션 요청을 분리

이에 대한 해결책은 두가지가 있는데 첫번째 클라이언트의 요청을 2가지로 분리하여 구분하는 것입니다.

+ /apps 의 URL 로 접근하면 Dispatcher Servlet 이 담당한다.

+ /resources 의 URL 로 접근하면 Dispatcher Servlet이 컨트롤할 수 없으므로 담당하지 않는다.

<br>

이러한 방식은 괜찮지만 상당히 코드가 지저분해지며, 코든 요청에 대해서 저런 URL 을 붙여주어야 하므로 직관적인 설계 X.

그래서 이러한 방법의 한계를 느끼고 다음의 방법으로 처리를 하게 되었습니다.

<br>

### 2. 어플리케이션 요청을 탐색하고 없으면 정적 자원 요청으로 처리

두번째 방법은 Dispatcher Servlet 이 요청을 처리할 컨트롤러를 먼저 찾고,

**`요청에 대한 컨트롤러를 찾을 수 없는 경우에,`** **2차적으로 설정된 자원 (Resource) 경로를 탐색하여 자원을 탐색** 하는 것입니다.

이렇게 영역을 분리하면 효율적인 리소스 관리를 지원할 뿐 아니라 추후에 확장을 용이하게 해준다는 장점이 있습니다.

<br>

## 2. Dispatcher-Servlet 의 동작 과정

앞서 설명한대로 디스패처 서블릿은 적합한 컨트롤러와 메소드를 찾아 요청을 위임해야 합니다. 

Dispatcher Servlet의 처리 과정을 살펴보면 다음과 같습니다.

![image](https://github.com/lielocks/WIL/assets/107406265/240d45f4-5f7f-4a40-b235-947e80b5f90a)

1. 클라이언트의 요청을 Dispatcher Servlet 이 받음

2. 요청 정보를 통해 요청을 위임할 Controller 를 찾음

3. 요청을 Controller 로 위임할 Handler Adapter 를 찾아서 전달함

4. Handler Adapther 가 Controller 로 요청을 위임함

5. Business Logic 을 처리함

6. Controller 가 반환값을 반환함

7. Handler Adapther 가 반환값을 처리함

8. 서버의 응답을 클라이언트로 반환함

<br>

### 1. 클라이언트의 요청을 Dispatcher Servlet 이 받음

앞서 설명하였듯 디스패처 서블릿은 가장 먼저 요청을 받는 Front Controller 입니다.

Servlet Context(Web Context) 에서 필터들을 지나 Spring Context 에서 Dispatcher Servlet 이 가장 먼저 요청을 받게 됩니다.

이를 그림으로 표현하면 다음과 같습니다.

실제로는 Interceptor 가 Controller 로 요청을 위임하지는 않으므로, 아래의 그림은 처리 순서를 도식화한 것으로만 이해하면 됩니다.

![image](https://github.com/lielocks/WIL/assets/107406265/6dbe38fd-07e4-425d-8d04-d96d065370b3)

<br>

### 2. 요청 정보를 통해 요청을 위임할 Controller 를 찾음

Dispatcher Servlet 은 요청을 처리할 Handler(Controller)를 찾고 해당 객체의 메서드를 호출합니다.
따라서 가장 먼저 어느 controller 가 요청을 처리할 수 있는지를 식별해야 하는데, 해당 역할을 하는 것이 바로 HandlerMapping 입니다.

최근에는 @Controller 에 @ReqeustMapping 관련 어노테이션을 사용해 controller 를 작성하는 것이 일반적입니다.

하지만 예전 스펙을 따라 Controller 인터페이스를 구현하여 controller 를 작성할 수도 있습니다.
즉, controller 를 구현하는 방법이 다양하기 때문에 spring 은 HandlerMapping 인터페이스를 만들어두고, 다양한 구현 방법에 따라 요청을 처리할 대상을 찾도록 되어 있습니다.

오늘날 흔한 @Controller 방식은 RequestMappingHandlerMapping 가 처리합니다.
이는 @Controller 로 작성된 모든 컨트롤러를 찾고 파싱하여 HashMap 으로 <요청 정보, 처리할 대상> 관리합니다.

여기서 처리할 대상은 HandlerMethod 객체로 controller, method 등을 갖고 있는데, 이는 spring 이 reflection 을 이용해 요청을 위임하기 때문입니다.

그래서 요청이 오면 (Http Method, URI) 등을 사용해 요청 정보를 만들고,
HashMap 에서 요청을 처리할 대상(Handler Method) 를 찾은 후에 HandlerExecutionChain 으로 감싸서 반환합니다.

HandlerExecutionChain 으로 감싸는 이유는 controller 로 요청을 넘겨주기 전에 처리해야 하는 interceptor 등을 포함하기 위해서 입니다.

<br>

### 3. 요청을 Controller 로 위임할 Handler Adapter 를 찾아서 전달함

이후에 controller 로 요청을 위임해야 하는데, Dispatcher Servlet 은 controller 로 요청을 직접 이ㅜ임하는 것이 아니라 HandlerAdapter 를 통해 위임합니다.
그 이유는 앞서 설명하였듯 controller 의 구현 방식이 다양하기 때문입니다.

spring 은 꽤나 오래 전에 (2004년) 만들어진 프레임워크로, 트렌드를 굉장히 잘 따라갑니다.
프로그래밍 흐름에 맞게 spring 역시 변화를 따라가게 되었는데, 그러면서 다양한 코드 작성 방식을 지원하게 되었습니다.
과거에는 컨트롤러를 Controller 인터페이스로 구현하였는데, 
Ruby On Rails가 어노테이션 기반으로 관례를 이용한 프로그래밍을 내세워 혁신을 일으키면서 spring 역시 이를 도입하게 되었습니다.

그래서 다양하게 작성되는 controller 에 대응하기 위해 spring 은 **Handler Adapter 라는 어댑터 인터페이스를 통해 adapter pattern 을 적용함으로써 controller 의 구현 방식에 상관없이 요청을 위임** 할 수 있도록 하였습니다.

<br>

### 4. Handler Adapther 가 Controller 로 요청을 위임함

Handler Adapter 가 controller 로 요청을 위임한 전 / 후에 **공통적인 전 / 후처리 과정이 필요** 합니다.

대표적으로 interceptor 들을 포함해 요청 시에 @RequestParam, @RequestBody 등을 처리하기 위한 ArgumentResolver 들과 
응답 시에 ResponseEntity 의 Body 를 Json 으로 직렬화하는 등의 처리를 하는 ReturnValueHandler 등이 handler adapter 에서 처리됩니다.

ArgumentResolver 등을 통해 파라미터가 준비되면 reflection 을 이용해 controller 로 요청을 위임합니다.

<br>

### 5. business logic 을 처리함

이후에 controller 는 service 를 호출하고 우리가 작성한 business logic 들이 진행됩니다.

<br>

### 6. controller 가 반환값을 반환함

business logic 이 처리된 후에는 controller 가 반환값을 반환합니다. 

응답 데이터를 사용하는 경우에는 주로 **`ResponseEntity`** 를 반환하게 되고, 응답 페이지를 보여주는 경우라면 String으로 View의 이름을 반환할 수도 있습니다. 
요즘 프론트엔드와 백엔드를 분리하고, MSA로 가고 있는 시대에서는 주로 ResponseEntity를 반환합니다.

<br>

### 7. Handler Adapther 가 반환값을 처리함

HandlerAdapter는 controller 로부터 받은 응답을 `응답 처리기인 ReturnValueHandler` 가 후처리한 후에 Dispatcher Servlet 으로 돌려줍니다. 

만약 컨트롤러가 ResponseEntity를 반환하면 **`HttpEntityMethodProcessor`** 가 **MessageConverter를 사용해 응답 객체를 직렬화하고 응답 상태(HttpStatus)를 설정** 합니다. 

만약 컨트롤러가 View 이름을 반환하면 ViewResolver를 통해 View를 반환합니다.

<br>

### 8. 서버의 응답을 클라이언트로 반환함

Dispatcher Servlet 을 통해 반환되는 응답은 다시 필터들을 거쳐 클라이언트에게 반환됩니다. 

이때 응답이 데이터라면 그대로 반환되지만, 응답이 화면이라면 View의 이름에 맞는 View를 찾아서 반환해주는 **`ViewResolver`** 가 적절한 화면을 내려줍니다.
 
<br>



# Spring 에서 API에 매핑되는 컨트롤러와 메소드 조회하여 직접 호출하기(HandlerMapping과 HandlerMethod)

최근에 어디에선가 API 에 매힝되는 controller 와 method 를 찾는 방법이 있냐는 질문을 보게 되었는데요.

마침 최근에 Dispatcher Servlet 코드를 보면서, Dispatcher Servlet 이 어떻게 controller 로 요청을 위임하는지 알게 되었는데 이번에는 어떻게 이러한 문제를 해결할 수 있는지 살펴보겠습니다.

<br>

## 1. HandlerMapping 과 HandlerMethod 간단히 살펴보기

### [핸들러 매핑 HandlerMapping]

**핸들러 매핑(HandlerMapping)과 RequestMappingHandlerMapping 클래스**

spring 은 controller 와 method 정보를 관리하고 있다가, *요청이 왔을 때* Dispatcher Servlet 이 어느 controller 가 이를 처리해야 하는지 식별하고 위임한다.

controller 에는 **`@RequestMapping`** 관련 어노테이션이 사용되므로 이를 기반으로 **요청 매핑 정보를 관리** 하고, `요청이 왔을 때` **이를 처리하는 대상(Handler)를 찾는 클래스가 바로 RequestMappingHandlerMapping** 이다.

이러한 **`RequestMappingHandlerMapping`** 은 **`AbstractHandlerMethodMapping`** 를 상속받고 있으며, **`AbstractHandlerMethodMapping`** 에서 내부적으로 관리하는 **`MappingRegistry`** 클래스를 가지고 있다.

<br>

```java
public abstract class AbstractHandlerMethodMapping<T> extends AbstractHandlerMapping implements InitializingBean {

    private final MappingRegistry mappingRegistry = new MappingRegistry();
    
    class MappingRegistry {

        private final Map<T, MappingRegistration<T>> registry = new HashMap<>();

        ...
    }

    ...
    
    static class MappingRegistration<T> {

        private final T mapping;

        private final HandlerMethod handlerMethod;

        private final Set<String> directPaths;

        @Nullable
        private final String mappingName;

        private final boolean corsConfig;
    }
    
    ...
}

public abstract class RequestMappingInfoHandlerMapping extends AbstractHandlerMethodMapping<RequestMappingInfo> {

}

public class RequestMappingHandlerMapping extends RequestMappingInfoHandlerMapping
		implements MatchableHandlerMapping, EmbeddedValueResolverAware {

}
```

**실제로 요청 매핑 정보를 관리** 하는 곳은 **`MappingRegistry`** 라는 클래스이다. 그러므로 MappingRegistry에 대해 살펴보도록 하자.
 
<br>

### MappingRegistry 의 registry 클래스

MappingRegistry 는 매핑 정보를 관리하는 클래스이며, 실제 매핑 정보는 MappingRegistry 의 registry 변수에서 관리된다.

registry 는 HashMap 으로써 (key, value) 로 각각 (요청 정보, 요청을 처리할 대상 정보) 을 저장하는데,

spring 어플리케이션은 실행될 때 **모든 controller 를 parsing 해서 해당 정보들을 다음과 같이 관리** 한다.

![image](https://github.com/lielocks/WIL/assets/107406265/8141eb76-2f49-45a8-8a6c-c1cb78416f0f)

<br>

그리고 각각의 Key, Value 클래스는 각각 다음과 같은 특징을 지닌다.

+ **Key (요청 정보)**

  + 클래스 : RequestMappingInfo
 
  + 특징 : Http Method 와 URI를 포함해 header, parameter 등의 조건을 가짐
 
+ **Value (요청을 처리할 대상 정보)**

  + 클래스 : MappingRegistration
 
  + 특징 : RequestMappingInfo 와 HandlerMethod 등으로 구성됨

<br>

여기서 우리는 **`HandlerMethod`** 에 주목해야 한다. 

**`HandlerMethod`** 에는 **매핑되는 controller 의 메소드와 controller bean 정보(controller bean 이름 또는 controller bean 이 될 수 있음) 및 bean factory** 등이 저장되어 있다. 

(왜 이러한 것들을 가지고 있는지는 뒤에서 설명된다.)

Dispatcher Servlet 은 요청이 오면 ***요청 정보를 파싱해 RequestMappingInfo 객체를 생성*** 하고, ***Map의 key로써 요청을 처리할 대상 정보를 꺼낸다.***

이를 위해 당연히 RequestMappingInfo의 hashCode는 오버라이딩 되어있다.

<br>

그리고 Value 값인 MappingRegistration 객체가 갖고 있는 **HandlerMethod를 사용해서 controller 에 요청을 위임** 하는 것이다. 

그러므로 우리도 `Dispatcher Servlet 이 동작하는 것처럼` RequestMappingInfo 객체를 생성하고 Value 값을 가져오면 될 것 같은데, 
실제로 코드를 작성할 때에는 조금 다르게 처리를 해야 한다. 관련 내용은 실제로 코드를 작성하면서 살펴보도록 하자.

그리고 그 전에 handler adapter 가 필요한 이유를 찾아보도록 하자.

<br>

### 핸들러 어댑터 HandlerAdapter

**핸들러 어댑터가 필요한 이유**

Dispatcher Servlet 은 controller 로 요청을 직접 위임하는 것이 아니라 HandlerAdapter 를 통해 controller 로 위임한다.

이때 adapter 인터페이스가 필요한 이유는 controller 의 구현 방식이 다양하기 떄문이다. 

최근에는 @Controller에 @RequestMapping 관련 어노테이션을 사용해 controller 클래스를 주로 작성하지만, Controller 인터페이스를 구현하여 컨트롤러 클래스를 작성할 수도 있다.

spring 은 **`HandlerAdapter`** 라는 adapter 인터페이스를 통해 **adapter pattern 을 적용함으로써 controller 의 구현 방식에 상관 없이 요청을 위임** 할 수 있는 것이다.

<br>

### 핸들러 어댑터(HandlerAdapter)와 RequestMappingHandlerAdapter

`@Controller에 @RequestMapping 관련 어노테이션으로 구현된 controller` 가 요청을 처리할 대상이면 **`RequestMappingHandlerMapping`** 가 찾아진다. 

그리고 `찾아진 HandlerMapping 을 처리할 adapter` 를 찾아야 하는데, 이를 처리할 어댑터는 **`RequestMappingHandlerAdapter`**이다. 

대부분 controller 는 위와 같이 구현되므로 RequestMappingHandlerAdapter 에 의해 **요청이 controller 로 위임된다** 고 생각하면 된다.

그러면 이제 API에 매핑되는 controller 와 메소드를 직접 호출해보도록 하자.
 
<br>

## 2. Spring API에 매핑되는 컨트롤러와 메소드 가져와서 직접 호출하기

[API 에 매핑되는 controller 와 메서드 가져와서 직접 호출하기]

예를 들어 다음과 같은 ProductController가 있다고 할 때, 이 컨트롤러의 메소드를 직접 호출해보도록 하자.

```java
@RestController
@RequiredArgsConstructor
public class ProductController {

    @GetMapping("/product/test")
    public ResponseEntity<MyResponse> temp() throws MangKyuCustomException {
        final MyResponse response = MyResponse.builder()
                .name("MangKyu")
                .desc("MangKyu's Tistory")
                .age(29)
                .build();
        return ResponseEntity.ok(response);
    }
}
```

<br>

### 1. Controller 생성 및 RequestMappingHandlerMapping 주입받기

가장 먼저 해야할 작업은 Controller 를 만들고, **요청 정보를 관리하는 `RequestMappingHandlerMapping` 를 주입받는 것** 이다.

스프링에서는 생성자 주입을 권장하고 있으므로 생성자 주입을 받으며, URI는 모든 요청에 매핑되는 API를 추가해주도록 하자. 

반환 타입은 `Object` 로 해두는데, 이에 대해서는 뒤에서 다시 한번 살펴보도록 하자.

```java
@RestController
@RequiredArgsConstructor
public class AdminController {

    private final RequestMappingHandlerMapping mapping;

    @RequestMapping("/**")
    public Object forceCall() {

    }
    
}
```

<br>

### 2. 요청 매핑 정보 조회 

이제 주입받은 **`RequestMappingHandlerMapping`** 을 통해 **요청 매핑 정보를 조회** 해야 한다. 

그런데 문제는 RequestMappingHandlerMapping가 **MappingRegistry를 반환하는 Getter 메소드가 없다는 것** 인데, 

대신 **`(Key, Value)로 (RequestMappingInfo, HandlerMethod)`** 를 반환하는 **getHandlerMethods 메소드** 를 제공하고 있으므로, 이를 이용하도록 하자.

```java
@RestController
@RequiredArgsConstructor
public class AdminController {

    private final RequestMappingHandlerMapping mapping;

    @GetMapping("/**")
    public Object forceCall() {
        final Map<RequestMappingInfo, HandlerMethod> handlerMethods = mapping.getHandlerMethods();

    }

}
```

<br>

### 3. 요청 정보에 맞는 HandlerMethod 조회

앞서 설명하였듯 Dispatcher Servlet 은 equals와 hashcode가 오버라이딩된 **RequestMappingInfo 객체를 만들어서 Value 값을 꺼내온다** 고 하였다. 

**`RequestMappingInfo 객체 생성`** 은 `HttpServletRequest를 파라미터로 받는` **getMatchingCondition** 를 이용하면 된다.


```java
public class RequestMappingInfo implements RequestCondition<RequestMappingInfo> {

    ...

    public RequestMappingInfo getMatchingCondition(HttpServletRequest request) {
        RequestMethodsRequestCondition methods = this.methodsCondition.getMatchingCondition(request);
        if (methods == null) {
            return null;
        }
        ParamsRequestCondition params = this.paramsCondition.getMatchingCondition(request);
        if (params == null) {
            return null;
        }
        HeadersRequestCondition headers = this.headersCondition.getMatchingCondition(request);
        if (headers == null) {
            return null;
        }
        ConsumesRequestCondition consumes = this.consumesCondition.getMatchingCondition(request);
        if (consumes == null) {
            return null;
        }
        ProducesRequestCondition produces = this.producesCondition.getMatchingCondition(request);
        if (produces == null) {
            return null;
        }
        PathPatternsRequestCondition pathPatterns = null;
        if (this.pathPatternsCondition != null) {
            pathPatterns = this.pathPatternsCondition.getMatchingCondition(request);
            if (pathPatterns == null) {
                return null;
            }
        }
        PatternsRequestCondition patterns = null;
        if (this.patternsCondition != null) {
            patterns = this.patternsCondition.getMatchingCondition(request);
            if (patterns == null) {
                return null;
            }
		}
        RequestConditionHolder custom = this.customConditionHolder.getMatchingCondition(request);
        if (custom == null) {
            return null;
        }
        return new RequestMappingInfo(this.name, pathPatterns, patterns,
            methods, params, headers, consumes, produces, custom, this.options);
    }
    
    ...

}
```

<br>

getMatchingCondition 메소드는 **HttpServletRequest로 해당 RequestMappingInfo 객체와 매칭되면 동일한 RequestMappingInfo를 새로 생성하여 반환하고 그렇지 않으면 null을 반환** 한다. 

이를 활용해서 매칭되는 RequestMappingInfo를 찾을 수 있다.

```java
@RestController
@RequiredArgsConstructor
public class AdminController {

    private final RequestMappingHandlerMapping mapping;

    @GetMapping("/**")
    public Object forceCall(final HttpServletRequest request) throws InvocationTargetException, IllegalAccessException {
        final Map<RequestMappingInfo, HandlerMethod> handlerMethods = mapping.getHandlerMethods();

        final RequestMappingInfo result = handlerMethods.keySet().stream()
                .filter(v -> v.getMatchingCondition(request) != null)
                .findAny()
                .orElseThrow(() -> new IllegalArgumentException("Invalid Argument"));
    }

}
```

<br>

하지만 우리는 현재 ProductController라는 명확한 타겟을 호출하려고 하므로, RequestMappingInfo를 직접 만들어보도록 하자. 

**`RequestMappingInfo`** 는 **빌더 패턴(Builder Pattern)** 을 지원하고 있어서 빌더를 이용하면 된다.

```java
@RestController
@RequiredArgsConstructor
public class AdminController {

    private final RequestMappingHandlerMapping mapping;

    @GetMapping("/**")
    public Object forceCall(final HttpServletRequest request) throws InvocationTargetException, IllegalAccessException {
        final Map<RequestMappingInfo, HandlerMethod> handlerMethods = mapping.getHandlerMethods();

        final RequestMappingInfo.BuilderConfiguration builderConfiguration = new RequestMappingInfo.BuilderConfiguration();
        builderConfiguration.setPatternParser(new PathPatternParser());
        final RequestMappingInfo targetRequestMappingInfo = RequestMappingInfo.paths("/product/test")
                .methods(RequestMethod.GET)
                .options(builderConfiguration).build();

    }

}
```

<br>

위의 코드에서 주의할 점은 **BuilderConfiguration을 만들어 `PathPatternParser` 객체를 생성한 후에 options까지 넣어주어야 한다는 것** 이다. 

앞서 설명하였듯 RequestMappingInfo는 hashCode가 오버라이딩 되어있으므로, options를 넣어주지 않으면 `Spring에서 관리하는 RequestMappingInfo` 와 `우리가 생성한 RequestMappingInfo` 의 **hashcode가 달라져 null이 반환** 된다.

위와 같이 `RequestMappingInfo를 생성하였으면` 이제 **map에서 HandlerMethod를 조회** 하면 된다.

```java
@RestController
@RequiredArgsConstructor
public class AdminController {

    private final RequestMappingHandlerMapping mapping;

    @GetMapping("/**")
    public Object forceCall(final HttpServletRequest request) throws InvocationTargetException, IllegalAccessException {
        final Map<RequestMappingInfo, HandlerMethod> handlerMethods = mapping.getHandlerMethods();

        final RequestMappingInfo.BuilderConfiguration builderConfiguration = new RequestMappingInfo.BuilderConfiguration();
        builderConfiguration.setPatternParser(new PathPatternParser());
        final RequestMappingInfo targetRequestMappingInfo = RequestMappingInfo.paths("/product/test")
                .methods(RequestMethod.GET)
                .options(builderConfiguration).build();

        final HandlerMethod result = handlerMethods.get(targetRequestMappingInfo);
    }

}
```

<br>

### 4. controller 의 method 호출

이제 HandlerMethod 에 대해 알아보자.

앞서 설명하였듯 **HandlerMethod 에는 매핑되는 controller 의 메서드와 controller bean 이름 (또는 controller bean) 및 Bean Facotry 등이 저장** 되어 있다.

각각의 특징이다.

+ **매핑되는 controller 의 메서드**

  + Reflection 패키지의 Method 객체
 
  + Method 를 호출(invoke)하기 위해서는 method 의 주인인 Bean 객체를 필요로 함
 

+ **Bean 정보 (controller bean 이름 또는 controller bean)**

  + Object 타입으로써 controller bean 이름 or controller bean 이 될 수 있음
 
  + 기본적으로 Controller bean 이름을 갖고 있으며, bean 객체 조회를 위해 사용됨
 
  + `HandlerMethod 의 createWithResolvedBean` 을 호출하면 bean 이름이 아닌 **실제 bean을 갖는 HandlerMehtod 객체를 생성함**
 
+ **Bean Factory**

  + spring boot 가 관리하는 bean 들을 가지고 있음
 
  + controller 의 method 를 호출하기 위한 bean 객체 조회를 위해 사용됨

<br>

**HandlerMethod 에 저장된 Reflection 패키지의 Method를 호출(Invoke)** 하기 위해서는 `메소드의 주인인 객체를 넘겨주어야 한다.` 

그런데 HandlerMethod 는 `기본적으로 controller bean 이름` 을 갖고 있으므로, **`Bean Factory` 를 통해 `controller 객체` 를 찾아서 Method 를 호출 시에 넘겨주도록 Bean Factory를 가지고 있는 것** 이다.

Controller 빈 이름만 있는 **`HandlerMethod 객체의 createWithResolvedBean`** 를 호출하면 *빈 이름 대신* **실제 빈을 갖는 HandlerMethod 객체가 반환** 되며, 이러한 내용을 코드로 작성하여 코드를 완성하면 다음과 같다.


```java
@RestController
@RequiredArgsConstructor
public class AdminController {

    private final RequestMappingHandlerMapping mapping;

    @GetMapping("/**")
    public Object forceCall(final HttpServletRequest request) throws InvocationTargetException, IllegalAccessException {
        final Map<RequestMappingInfo, HandlerMethod> handlerMethods = mapping.getHandlerMethods();

        final RequestMappingInfo.BuilderConfiguration builderConfiguration = new RequestMappingInfo.BuilderConfiguration();
        builderConfiguration.setPatternParser(new PathPatternParser());
        final RequestMappingInfo targetRequestMappingInfo = RequestMappingInfo.paths("/product/test")
                .methods(RequestMethod.GET)
                .options(builderConfiguration).build();

        final HandlerMethod result = handlerMethods.get(targetRequestMappingInfo);
        final HandlerMethod handlerMethod = result.createWithResolvedBean();
        return handlerMethod.getMethod().invoke(handlerMethod.getBean());
    }

}
```

<br>

Method 객체는 controller 의 메서드이므로 **`invoke`** 하면 **controller method 가 직접 호출** 된다.

그런데 **method 객체의 invoke 반환값은 예측할 수 없으므로** 당연히 **`Method 객체의 invoke 메서드 반환값은 Object`** 이다.

이러한 이유로 컨트롤러의 반환값을 Object로 한 것이다.

실제로 위와 같이 작성된 스프링 애플리케이션을 실행하고 테스트 해보면 원하는 대로 결과가 반환됨의 확인할 수 있다.

![image](https://github.com/lielocks/WIL/assets/107406265/f949364e-7975-47aa-891c-71dafd504284)


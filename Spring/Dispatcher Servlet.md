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

앞서 설명하였듯 디스패처 서블릿은 가장 먼저 요청을 받는 **`Front Controller`** 입니다.

Servlet Context(Web Context) 에서 필터들을 지나 Spring Context 에서 Dispatcher Servlet 이 가장 먼저 요청을 받게 됩니다.

이를 그림으로 표현하면 다음과 같습니다.

실제로는 `Interceptor 가 Controller 로 요청을 위임하지는 않으므로,` 아래의 그림은 처리 순서를 도식화한 것으로만 이해하면 됩니다.

![image](https://github.com/lielocks/WIL/assets/107406265/6dbe38fd-07e4-425d-8d04-d96d065370b3)

<br>

### 2. 요청 정보를 통해 요청을 위임할 Controller 를 찾음

Dispatcher Servlet 은 **요청을 처리할 Handler(Controller)** 를 찾고 **해당 객체의 메서드를 호출** 합니다.
따라서 가장 먼저 *어느 controller 가 요청을 처리할 수 있는지를 식별* 해야 하는데, 해당 역할을 하는 것이 바로 **`HandlerMapping`** 입니다.

최근에는 @Controller 에 @ReqeustMapping 관련 어노테이션을 사용해 controller 를 작성하는 것이 일반적입니다.

하지만 예전 스펙을 따라 Controller 인터페이스를 구현하여 controller 를 작성할 수도 있습니다.
즉, controller 를 구현하는 방법이 다양하기 때문에 spring 은 **HandlerMapping 인터페이스** 를 만들어두고, 다양한 구현 방법에 따라 요청을 처리할 대상을 찾도록 되어 있습니다.

오늘날 흔한 @Controller 방식은 **`RequestMappingHandlerMapping`** 가 처리합니다.
이는 @Controller 로 작성된 **모든 컨트롤러를 찾고 파싱하여 HashMap 으로 <요청 정보, 처리할 대상> 관리** 합니다.

여기서 `처리할 대상은 HandlerMethod 객체` 로 controller, method 등을 갖고 있는데, 이는 **spring 이 reflection 을 이용해 요청을 위임** 하기 때문입니다.

그래서 요청이 오면 `(Http Method, URI) 등을 사용해 요청 정보를 만들고,`
**HashMap 에서 요청을 처리할 대상(Handler Method) 를 찾은 후** 에 **`HandlerExecutionChain 으로 감싸서 반환`** 합니다.

HandlerExecutionChain 으로 감싸는 이유는 **controller 로 요청을 넘겨주기 전에 처리해야 하는 interceptor 등을 포함하기 위해서** 입니다.

<br>

### 3. 요청을 Controller 로 위임할 Handler Adapter 를 찾아서 전달함

이후에 controller 로 요청을 위임해야 하는데, Dispatcher Servlet 은 *controller 로 요청을 직접 위임하는 것이 아니라* **`HandlerAdapter 를 통해 위임`** 합니다.
그 이유는 앞서 설명하였듯 controller 의 구현 방식이 **다양** 하기 때문입니다.

spring 은 꽤나 오래 전에 (2004년) 만들어진 프레임워크로, 트렌드를 굉장히 잘 따라갑니다.
프로그래밍 흐름에 맞게 spring 역시 변화를 따라가게 되었는데, 그러면서 다양한 코드 작성 방식을 지원하게 되었습니다.

과거에는 컨트롤러를 Controller 인터페이스로 구현하였는데, 
Ruby On Rails가 어노테이션 기반으로 관례를 이용한 프로그래밍을 내세워 혁신을 일으키면서 spring 역시 이를 도입하게 되었습니다.

그래서 다양하게 작성되는 controller 에 대응하기 위해 spring 은 **Handler Adapter 라는 어댑터 인터페이스를 통해 adapter pattern 을 적용함으로써 controller 의 구현 방식에 상관없이 요청을 위임** 할 수 있도록 하였습니다.

<br>

### 4. Handler Adapther 가 Controller 로 요청을 위임함

`Handler Adapter 가 controller 로 요청을 위임한 전 / 후` 에 **공통적인 전 / 후처리 과정이 필요** 합니다.

대표적으로 *interceptor 들을 포함해 요청 시에 @RequestParam, @RequestBody 등을 처리* 하기 위한 **`ArgumentResolver`** 들과 

*응답 시에 ResponseEntity 의 Body 를 Json 으로 직렬화하는 등의 처리* 를 하는 **`ReturnValueHandler`** 등이 **handler adapter 에서 처리** 됩니다.

ArgumentResolver 등을 통해 파라미터가 준비되면 reflection 을 이용해 **controller 로 요청을 위임합니다.**

<br>

### 5. business logic 을 처리함

이후에 controller 는 service 를 호출하고 우리가 작성한 business logic 들이 진행됩니다.

<br>

### 6. controller 가 반환값을 반환함

business logic 이 처리된 후에는 controller 가 반환값을 반환합니다. 

응답 데이터를 사용하는 경우에는 주로 **`ResponseEntity`** 를 반환하게 되고, 응답 페이지를 보여주는 경우라면 String으로 View의 이름을 반환할 수도 있습니다. 

요즘 프론트엔드와 백엔드를 분리하고, MSA로 가고 있는 시대에서는 주로 **`ResponseEntity`** 를 반환합니다.

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

<br>

# SpringBoot 소스 코드와 DispatcherServlet  동작 과정 살펴보기

## 1. DispatcherServlet 디스패처 서블릿 동작 과정

Dispatcher Servlet 은 **모든 요청을 가장 먼저 받는 Front Controller** 이다.

Dispatcher Servlet 을 이해하기 위해 가장 먼저 계층 구조부터 살펴보자.

![image](https://github.com/lielocks/WIL/assets/107406265/77c957e6-b9c4-4d05-b87f-e4ee01936456)

<br>

위의 여기서 우리가 주목해야 할 부분은 크게 다음과 같다.

+ **HttpServlet**

  + Http 서블릿을 구현하기 위한 J2EE 스펙의 추상 클래스
 
  + 특정 HTTP 메서드를 지원하기 위해서는 doX 메서드를 오버라이딩 해야 함 (template method pattern)
 
  + doPatch 는 지원하지 않음 (아래에서 살펴볼 예정)
 
<br>

+ **HttpServletBean**

  + HttpServlet 을 Spring 이 구현한 추상 클래스
 
  + Spring 이 모든 유형의 servlet 구현을 위해 정의한 공통 클래스
 
<br>

+ **FrameworkServlet**

  + Spring web Framework 의 기반이 되는 servlet
 
  + doX 메서드를 오버라이딩하고 있으며, doX 요청들을 공통된 요청 처리 메서드인 processRequest 로 전달함
 
  + processRequest 에서 실제 요청 핸들링은 추상 메서드 doService 로 위임됨 (template method pattern)
 
<br>

+ **DispatcherServlet**

  + Controller 로 요청을 전달하는 중앙 집중형 Front controller(Servlet 구현체)
 
  + 실제 요청을 처리하는 doService 를 구현하고 있음

<br>

Dispatcher Servlet 이 요청을 받아서 controller 로 위임하는 과정을 자세히 살펴보자.

1. `Servlet 요청 / 응답` 을 `HTTP Servlet 요청 / 응답` 으로 변환

2. `HTTP Method` 에 따른 처리 작업 진행

3. 요청에 대한 `공통 처리` 작업 진행

4. `Controller 로 요청을 위임`

   1. 요청에 매핑되는 **HandlerExecutionChain** 조회
  
   2. 요청을 처리할 **HandlerAdapter** 조회
  
   3. HandlerAdapter 를 통해 **Controller Method 호출** (HandlerExecutionChain 처리)

<br>

### 1. Servlet 요청 / 응답을 HTTP Servlet 요청 / 응답으로 변환

HTTP 요청은 등록된 필터들을 거쳐 Dispatcher Servlet 이 처리하게 되는데,

**가장 먼저 요청을 받는 부분** 은 **`부모 클래스인 HttpServlet 에 구현된 service 메서드`** 이다.

```java
public abstract class HttpServlet extends GenericServlet {

    ...

    @Override
    public void service(ServletRequest req, ServletResponse res)
        throws ServletException, IOException {

        HttpServletRequest  request;
        HttpServletResponse response;

        try {
            request = (HttpServletRequest) req;
            response = (HttpServletResponse) res;
        } catch (ClassCastException e) {
            throw new ServletException(lStrings.getString("http.non_http"));
        }
        service(request, response);
    }

    protected void service(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {
        ...
    }
    
    ...
}
```

service 에서는 먼저 **Servlet 관련 Request / Response 객체를 HTTP 관련 Request / Resposne 로 (캐스팅)** 해준다.

캐스팅 시에 에러가 발생하면 HTTP 요청이 아니므로 에러를 던진다.

<br>

### 2. HTTP Method 에 따른 처리 작업 진행

그리고 `HttpServletRequest 객체를 parameter 로 갖는 service 메서드` 를 호출하는데, HttpServlet 에도 service 가 있지만 

**자식 클래스인 FrameworkServlet 에 service 가 오버라이딩 되어 있어 자식의 메서드가 호출** 된다.

해당 로직을 보면 다음과 같다.

```java
public abstract class FrameworkServlet extends HttpServletBean implements ApplicationContextAware {

    ...

    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

	HttpMethod httpMethod = HttpMethod.resolve(request.getMethod());
	if (httpMethod == HttpMethod.PATCH || httpMethod == null) {
	    processRequest(request, response);
	}
	else {
	    super.service(request, response);
	}
	
	...
    }
}
```

<br>

자식 클래스인 FrameworkServlet 의 service 는 PATCH 메서드인 경우 processRequest 를 호출하고,

PATCH 메서드가 아니면 다시 부모 클래스인 HttpServlet 의 service 를 호출해주고 있다.

이상하게도 PATCH 메서드만 이러한 흐름을 거치는 이유는 PATCH 메서드의 탄생과 관련이 있다.

과거 HTTP 표준에는 PATCH 메소드가 존재하지 않았다. 
그러다가 2010년도에 Ruby on Rails가 부분 수정의 필요를 주장하였고, 2010년도에 공식 HTTP 프로토콜로 추가되었다.

이러한 이유로 javax의 HttpServlet에는 doPatch 메소드가 존재하지 않아서 Spring 개발팀은 PATCH 요청을 처리하고자 **자체적으로 개발한 FrameworkServlet** 를 거쳐 PATCH라면 핸들링하고, 

그렇지 않은 경우에는 **다시 자바 표준 기술인 부모 클래스 HttpServlet** 이 처리하도록 대응한 것이다. 

`PATCH가 아닌 경우에 처리되는 로직` 은 다음과 같다.

```java
public abstract class HttpServlet extends GenericServlet {

    ...

    protected void service(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {

        String method = req.getMethod();

        if (method.equals(METHOD_GET)) {
            ... // lastModifed에 따른 doGet 처리(요약함)
            doGet(req, resp);

        } else if (method.equals(METHOD_HEAD)) {
            long lastModified = getLastModified(req);
            maybeSetLastModified(resp, lastModified);
            doHead(req, resp);

        } else if (method.equals(METHOD_POST)) {
            doPost(req, resp);

        } else if (method.equals(METHOD_PUT)) {
            doPut(req, resp);

        } else if (method.equals(METHOD_DELETE)) {
            doDelete(req, resp);

        } else if (method.equals(METHOD_OPTIONS)) {
            doOptions(req,resp);

        } else if (method.equals(METHOD_TRACE)) {
            doTrace(req,resp);

        } else {
            ... // 에러 처리
        }
    }

    ...
}
```

HttpServlet 에서는 요청 메서드에 따라 필요한 처리와 doX 메서드를 호출해주고 있다.

그러면 `doX 메서드를 오버라이딩 하고 있는 자식 클래스` 인 **FrameworkServlet 으로 다시 요청** 이 이어지게 된다.

PATCH 를 제외한 메서드들에 대해 Template Method Pattern 이 적용된 것이다.

`오버라이딩된 doX 메서드` 는 다음과 같이 구현되어 있다.


```java
public abstract class FrameworkServlet extends HttpServletBean implements ApplicationContextAware {

    ... 

    @Override
    protected final void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        processRequest(request, response);
    }
    
    @Override
    protected final void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        processRequest(request, response);
    }

    ...
}
```

<br>

각각의 doX 메서드에서는 HTTP Method 에 맞는 작업을 하는데, doGet 에서 lastModified 관련 처리를 해주는 것 말고는 거의 없다.

그리고 결국 모든 doX 메서드들은 processRequest 를 거치게 되는데, 해당 과정을 살펴보자.

<br>

### 3. 요청에 대한 공통 처리 작업 진행

**오버라이딩된 doX 메서드** 는 모두 **`request 를 처리하는 processRequest 메서드`** 를 호출하고 있다.

```java
protected final void processRequest(HttpServletRequest request, HttpServletResponse response)
		    throws ServletException, IOException {

    ... // LocaleContextHolder 처리 등 생략

    try {
        doService(request, response);
    } catch (ServletException | IOException ex) {
        failureCause = ex;
        throw ex;
    } catch (Throwable ex) {
        failureCause = ex;
        throw new NestedServletException("Request processing failed", ex);
    } finally {
        ... // 후처리 진행
    }
}

protected abstract void doService(HttpServletRequest request, HttpServletResponse response)
        throws Exception;
```

<br>

**`processRequest`** 에서는 **request 에 대한 공통 작업** 을 한 후에, 드디어 **doService** 를 호출하고 있다.

앞서 설명한대로 **`doService`** 는 Template Method Pattern 이 적용된 추상 메서드이므로 **자식 클래스인 DispatcherServlet** 에 가야 해당 코드를 볼 수 있다.

DispatcherServlet 의 doService 코드는 다음과 같다.

<br>

```java
public class DispatcherServlet extends FrameworkServlet {

    ...

    @Override
    protected void doService(HttpServletRequest request, HttpServletResponse response) throws Exception {
        logRequest(request);

        ... // flash map 등의 처리 진행

        try {
            doDispatch(request, response);
        } finally {
            ... // 후처리 진행
        }
    }

    ...

}
```

<br>

processRequest 와 doService 에서는 LocaleContextHolder 와 flashMap 등에 대한 공통 처리 작업이 진행되는데, 그렇게 중요하지 않다.

우리가 주목해야 할 부분은 HTTP 요청을 controller 로 위임해주는 doDispatch 이므로 바로 해당 단계로 넘어가보자.

<br>

### 4. Controller 로 요청을 위임

여기서부터 이제 중요하다. 

**Controller 로 요청을 위임하는 doDispatch** 는 크게 다음의 3가지 단계로 나뉜다.

1. 요청에 매핑되는 **`HandlerMapping (HandlerExecutionChain)`** 조회

2. 요청을 처리하는 **`HandlerAdapter`** 조회

3. **HandlerAdapter 를 통해 controller method 호출** (HandlerExecutionChain 처리)

<br>

doDispatch 코드는 다음과 같은데, 마찬가지로 각각의 단계에 대해 세부적으로 살펴보자.

```java
protected void doDispatch(HttpServletRequest request, HttpServletResponse response) throws Exception {
    HttpServletRequest processedRequest = request;
    HandlerExecutionChain mappedHandler = null;
    boolean multipartRequestParsed = false;

    WebAsyncManager asyncManager = WebAsyncUtils.getAsyncManager(request);

    try {
        ModelAndView mv = null;
        Exception dispatchException = null;

        try {
            processedRequest = checkMultipart(request);
            multipartRequestParsed = (processedRequest != request);

            // 1. 요청에 패핑되는 HandlerMapping (HandlerExecutionChain) 조회
            mappedHandler = getHandler(processedRequest);
            if (mappedHandler == null) {
                noHandlerFound(processedRequest, response);
                return;
            }

            // 2. 요청을 처리할 HandlerAdapter 조회
            HandlerAdapter ha = getHandlerAdapter(mappedHandler.getHandler());

            ...

            // 3. HandlerAdapter를 통해 컨트롤러 메소드 호출(HandlerExecutionChain 처리)
            mv = ha.handle(processedRequest, response, mappedHandler.getHandler());

            ... // 후처리 진행(인터셉터 등)
        } catch (Exception ex) {
            dispatchException = ex;
        } catch (Throwable err) {
            // As of 4.3, we're processing Errors thrown from handler methods as well,
            // making them available for @ExceptionHandler methods and other scenarios.
            dispatchException = new NestedServletException("Handler dispatch failed", err);
        }
        processDispatchResult(processedRequest, response, mappedHandler, mv, dispatchException);
    } catch (Exception ex) {
        triggerAfterCompletion(processedRequest, response, mappedHandler, ex);
    } catch (Throwable err) {
        triggerAfterCompletion(processedRequest, response, mappedHandler,
            new NestedServletException("Handler processing failed", err));
    } finally {
        ... // 후처리 진행
    }
}
```

<br>

**1. 요청에 매핑되는 HandlerMapping (HandlerExecutionChain) 조회**

doDispatch 에서도 우리가 볼 부분은 그렇게 많지 않은데, 가장 먼저 볼 부분은 **HandlerMapping 에 해당하는 HandlerExecutionChain 을 조회하는 부분이다.**

**`HandlerExecutionChain`** 은 **HandlerMethod 와 Interceptor 들로 구성된다.**

HandlerMethod 에는 `매핑되는 controller 의 메서드` 와 `controller bean 이름(또는 controller bean) 및 Bean Factory` 등이 저장되어 있는데, 다음과 같은 특징을 지닌다.

+ **매핑되는 controller 의 메서드**

  + Reflection 패키지의 Method 객체
 
  + Method 를 호출(invoke) 하기 위해서는 method 의 주인인 Bean 객체를 필요로 함
 
<br>

+ **Bean 정보** (Controller bean 이름 or controller bean)

  + Object 타입으로써 controller bean 이름(기본) or controller bean 이 될 수 있음
 
  + 기본적으로 controller bean 이름을 갖고 있으며, bean 객체 조회를 위해 사용됨
 
  + HandlerMethod 의 createWithResolvedBean 을 호출하면 bean 이름이 아닌 실제 bean 을 갖는 HandlerMethod 객체를 생성함
 
<br>

+ **Bean Factory**

  + Spring Boot 가 관리하는 bean 들을 가지고 있음
 
  + Controller 의 method 를 호출하기 위한 bean 객체 조회를 위해 사용됨

<br>

HandlerMethod 에 저장된 Method 객체를 호출(invoke) 하기 위해서는 method 의 주인인 객체를 넘겨줘야 한다.

그런데 HandlerMethod 는 기본적으로 controller bean 이름을 갖고 있으므로, Bean Factory 를 통해 controller 객체를 찾아서 Method 를 호출 시에 넘겨주도록 Bean Factory 를 가지고 있는 것이다.

Controller Bean 이름만 있는 HandlerMethod 객체의 createWithResolvedBean 을 호출하면 bean 이름 대신 `실제 bean 을 갖는 HandlerMethod 객체가 반환된다.`

Dispatcher Servlet 이 HandlerMethod 가 아닌 **HandlerExecutionChain 을 얻는 이유는 공통 처리를 위한 interceptor 가 존재하기 때문이다.**

이제 HandlerExecutionChain를 찾는 getHandler부터 봐보도록 하자. getHandler 코드는 다음과 같다.

```java
@Nullable
protected HandlerExecutionChain getHandler(HttpServletRequest request) throws Exception {
    if (this.handlerMappings != null) {
        for (HandlerMapping mapping : this.handlerMappings) {
            HandlerExecutionChain handler = mapping.getHandler(request);
            if (handler != null) {
                return handler;
            }
        }
    }
    return null;
}
```

<br>

getHandler에서는 HandlerMapping 목록을 순회하여 `HandlerExecutionChain` 를 찾는다. 

최근에는 컨트롤러를 @Controller와 @RequestMapping 관련 어노테이션으로 작성하므로, 이를 처리하는 RequestMappingHandlerMapping가 HandlerExecutionChain를 생성해 반환한다. 

해당 과정을 자세히 살펴보기 위해 **`getHandlerInternal`** 를 보도록 하자.

```java
@Override
@Nullable
public final HandlerExecutionChain getHandler(HttpServletRequest request) throws Exception {
    Object handler = getHandlerInternal(request);
    if (handler == null) {
        handler = getDefaultHandler();
    }
    if (handler == null) {
        return null;
    }
    // Bean name or resolved handler?
    ...

    HandlerExecutionChain executionChain = getHandlerExecutionChain(handler, request);

    ... // CORS 및 기타 처리

    }

    return executionChain;
}
```

HandlerMethod를 찾는 `RequestMappingHandlerMapping의 getHandlerInternal` 는 내부적으로 다시 **추상 부모 클래스인 AbstractHandlerMethodMapping의 `getHandlerInternal`**로 위임되는데, 

해당 코드를 보면 다음과 같다.


```java
@Override
@Nullable
protected HandlerMethod getHandlerInternal(HttpServletRequest request) throws Exception {
    String lookupPath = initLookupPath(request);
    this.mappingRegistry.acquireReadLock();
    try {
        HandlerMethod handlerMethod = lookupHandlerMethod(lookupPath, request);
        return (handlerMethod != null ? handlerMethod.createWithResolvedBean() : null);
    } finally {
        this.mappingRegistry.releaseReadLock();
    }
}
```

가장 먼저 API URI인 lookupPath를 찾아주고, mappingRegistry에 대해 *readLock을 얻은 다음에 HandlerMethod* 를 찾고 있다.

실제로 조회한 **HandlerMethod** 의 예시를 보면 다음과 같은데, `빈 으름과 빈팩토리, 메소드 객체` 가 있는 것을 볼 수 있다.

![image](https://github.com/lielocks/WIL/assets/107406265/f55cba09-fe9a-4b94-b45a-8825db028ce6)

<br>

이러한 HandlerMethod 를 찾는 lookupHandlerMethod 는 코드로 보지 말고 설명으로만 읽고 넘어가도록 하자.

Spring 은 어플리케이션이 초기화때 **모든 controller 를 파싱** 해서 `(요청정보, 요청 정보를 처리할 대상)` 을 관리해둔다.

그리고 요청이 들어오면 가장 먼저 URI 를 기준으로 매핑되는 후보군들을 찾는다.

만약 동일한 URI 에 대해 POST, PUT 메서드가 있으면 2개의 후보군이 찾아진다.

그리고 HTTP Method 와 다른 조건들을 통해 완전히 매핑되는지 검사한다.

매핑 정보는 다음과 같은 RequestMappingInfo 클래스이다.

![image](https://github.com/lielocks/WIL/assets/107406265/8a37859f-fe41-4890-8665-6f5d4068fe8d)

<br>

그러면 다시 이제 요청을 처리할 대상을 찾는 **`getHandler`** 로 넘어오도록 하자.

```java
@Override
@Nullable
public final HandlerExecutionChain getHandler(HttpServletRequest request) throws Exception {
    Object handler = getHandlerInternal(request);
    if (handler == null) {
        handler = getDefaultHandler();
    }
    if (handler == null) {
        return null;
    }
    // Bean name or resolved handler?
    ...

    HandlerExecutionChain executionChain = getHandlerExecutionChain(handler, request);

    ... // CORS 및 기타 처리

    }

    return executionChain;
}
```

<br>

위와 같이 찾아진 **HandlerMethod** 는 최종적으로 **HandlerExecutionChain 으로 반환** 된다.

왜냐하면 `controller 에 요청을 위임하기 전에 처리해야 하는 interceptor` 들이 있으므로,
**HandlerMethod 와 interceptor 를 갖는** **`HandlerExecutionChain 을 만들어 반환`** 해주는 것이다.

그럼 다시 Dispatcher Servlet 으로 넘어와서 이번에는 HandlerAdpater 를 조회하는 로직을 보도록 하자.

<br>

**2. 요청을 처리할 Handler Adapter 조회**

Dispatcher Servlet 은 ***HandlerExecutionChain 을 직접 실행하지 않고,***
**HandlerAdpater 라는 어댑터 인터페이스를 통해 실행한다.**

과거에는 controller 를 interface 로 만들었는데, 최근에는 어노테이션으로 만드는 방식이 주로 이용된다.

즉 다양하게 controller 를 만들 수 있는데, format 이 다르므로 HandlerAdpater 라는 어댑터 interface 를 둠으로써 controller 의 구현 방식에 상관없이 요청을 위임하도록 adapter interface 를 사용한 것이다.

**doDispatch 에서는 getHandlerAdapter 를 통해 HandlerAdapter 를 조회한다.**

```java
protected void doDispatch(HttpServletRequest request, HttpServletResponse response) throws Exception {
    HttpServletRequest processedRequest = request;
    HandlerExecutionChain mappedHandler = null;
    boolean multipartRequestParsed = false;

    WebAsyncManager asyncManager = WebAsyncUtils.getAsyncManager(request);

    try {
        ModelAndView mv = null;
        Exception dispatchException = null;

        try {
            processedRequest = checkMultipart(request);
            multipartRequestParsed = (processedRequest != request);

            // 1. 요청에 패핑되는 HandlerExecutionChain 조회
            mappedHandler = getHandler(processedRequest);
            if (mappedHandler == null) {
                noHandlerFound(processedRequest, response);
                return;
            }

            // 2. 요청을 처리할 HandlerAdapter 조회
            HandlerAdapter ha = getHandlerAdapter(mappedHandler.getHandler());

            ...

            // 3. HandlerAdapter를 통해 컨트롤러 메소드 호출(HandlerExecutionChain 처리)
            mv = ha.handle(processedRequest, response, mappedHandler.getHandler());

            ... // 후처리 진행(인터셉터 등)
        } catch (Exception ex) {
            dispatchException = ex;
        } catch (Throwable err) {
            // As of 4.3, we're processing Errors thrown from handler methods as well,
            // making them available for @ExceptionHandler methods and other scenarios.
            dispatchException = new NestedServletException("Handler dispatch failed", err);
        }
        processDispatchResult(processedRequest, response, mappedHandler, mv, dispatchException);
    } catch (Exception ex) {
        triggerAfterCompletion(processedRequest, response, mappedHandler, ex);
    } catch (Throwable err) {
        triggerAfterCompletion(processedRequest, response, mappedHandler,
            new NestedServletException("Handler processing failed", err));
    } finally {
        ... // 후처리 진행
    }
}
```

<br>

*어노테이션(@RequestMapping) 으로 구현된 controller 에 대한 API 요청* 인 경우에는 *RequestMapping HandlerAdapter* 가 찾아진다.

하지만 컨트롤러는 Controller 인터페이스로 구현하는 등 다양하게 구성이 가능하므로,
spring 은 **controller 구현 방식에 따라 호환 가능** 하도록 **`adapter interface 인 Handler Adapter`** 를 생성하였다. 

<br>

**3. HandlerAdapter 를 통해 controller method 호출 (HandlerExecutionChain 처리)**

HandlerAdapter 를 통해 HandlerExecutionChain을 처리하는데, 내부적으로 interceptor 를 가지고 있어 공통적인 전 / 후 처리 과정이 처리된다.

대표적으로 
+ **controller method 호출 전에는 적합한 parameter 를 만들어 넣어주어야 하며(ArgumentResolver)**,

+ **호출 후에는 메세지 컨버터를 통해 ResponseEntity 의 Body 를 찾아 Json 직렬화하는 등(ReturnValueHandler)** 이 필요하다.

`적합한 HandlerAdapter 가 HandlerExectutionChain 을 모두 찾았으면` 이제 **Handler Adapter 가 요청을 처리** 할 차례이다.

AbstractHandlerMethodAdapter 를 보면 **handle 메서드** 가 다음과 같이 구현되어 있다.

```java
@Override
@Nullable
public final ModelAndView handle(HttpServletRequest request, HttpServletResponse response, Object handler)
      throws Exception {

   return handleInternal(request, response, (HandlerMethod) handler);
}

@Nullable
   protected abstract ModelAndView handleInternal(HttpServletRequest request,
      HttpServletResponse response, HandlerMethod handlerMethod) throws Exception;
```

<br>

요청의 종류에 따라 HandlerAdapter 구현체가 달라지고, 그에 따라 전 / 후 처리가 달라지므로 세부 구현을 구체 클래스로 위임하는 Template Method Pattern 이 또 사용된 것 !

대표적으로 `@Controller 로 작성된 controller 를 처리하는` **RequestMappingHandlerAdapter** 를 살펴보면 RequestMappingHandlerAdapter 의 **handleInternal 은 실제로 요청을 위임하는 `invokeHandlerMethod` 를 호출** 한다.

```java
@Override
protected ModelAndView handleInternal(HttpServletRequest request,
      HttpServletResponse response, HandlerMethod handlerMethod) throws Exception {

   ModelAndView mav;
   checkRequest(request);

   // Execute invokeHandlerMethod in synchronized block if required.
   if (this.synchronizeOnSession) {
      ... // 생략
   } else {
      // No synchronization on session demanded at all...
      mav = invokeHandlerMethod(request, response, handlerMethod);
   }

   ...
      
   return mav;
}
```

여기서 InvokeHandlerMethod가 **컨트롤러로 요청을 위임하는 곳** 이므로 해당 코드를 살펴보도록 하자.

```java
@Nullable
protected ModelAndView invokeHandlerMethod(HttpServletRequest request,
      HttpServletResponse response, HandlerMethod handlerMethod) throws Exception {

   ServletWebRequest webRequest = new ServletWebRequest(request, response);
   try {
      WebDataBinderFactory binderFactory = getDataBinderFactory(handlerMethod);
      ModelFactory modelFactory = getModelFactory(handlerMethod, binderFactory);

      ServletInvocableHandlerMethod invocableMethod = createInvocableHandlerMethod(handlerMethod);
      if (this.argumentResolvers != null) {
         invocableMethod.setHandlerMethodArgumentResolvers(this.argumentResolvers);
      }
      if (this.returnValueHandlers != null) {
         invocableMethod.setHandlerMethodReturnValueHandlers(this.returnValueHandlers);
      }
      
      ...

      invocableMethod.invokeAndHandle(webRequest, mavContainer);
      
      ...

      return getModelAndView(mavContainer, modelFactory, webRequest);
   } finally {
      webRequest.requestCompleted();
   }
}
```

<br>

 
여기서 먼저 주목할 부분은 **HandlerMethod가 ServletInvocableHandlerMethod로 재탄생** 한다는 것이다. 

**`HandlerExecutionChain`** 에는 **공통적인 전 / 후 처리** 가 진행된다고 하였는데, 이러한 작업에는 대표적으로 ***컨트롤러의 파라미터를 처리하는 ArgumentResolver*** 와 ***반환값을 처리하는 ReturnValueHandler*** 가 있다.

즉, **`ServletInvocableHandlerMethod`** 로 다시 만드는 이유는 **HandlerMethod와 함께 argumentResolver나 returnValueHandlers 등을 추가해 공통 전 / 후 처리** 를 하기 위함이다. 

세팅이 끝나면 ServletInvocableHandlerMethod의 **invokeAndHandle** 로 이어진다.

<br>

```java
public void invokeAndHandle(ServletWebRequest webRequest, ModelAndViewContainer mavContainer,
      Object... providedArgs) throws Exception {

   Object returnValue = invokeForRequest(webRequest, mavContainer, providedArgs);
   setResponseStatus(webRequest);

   ... 

   try {
      this.returnValueHandlers.handleReturnValue(
            returnValue, getReturnValueType(returnValue), mavContainer, webRequest);
   }
   catch (Exception ex) {
      ...
      throw ex;
   }
}
```

<br>

그리고는 바로 부모 클래스인 InvocableHandlerMethod의 invokeForRequest로 이어진다.

```java
@Nullable
public Object invokeForRequest(NativeWebRequest request, @Nullable ModelAndViewContainer mavContainer,
      Object... providedArgs) throws Exception {

   Object[] args = getMethodArgumentValues(request, mavContainer, providedArgs);
   if (logger.isTraceEnabled()) {
	logger.trace("Arguments: " + Arrays.toString(args));
   }
   return doInvoke(args);
}
```

<br>

invokeForRequest에서는 먼저 메소드 호출을 위해 필요한 인자값을 처리한다.

`@RequestHeader, @CookieValue 및 @PathVariable` 등도 모두 spring 이 만들어둔 **ArgumentResolver에 의해 처리** 가 되는데, 이러한 인자값을 만드는 작업이 **`getMethodArgumentValues`** 내에서 처리가 된다. 

그리고 **doInvoke에서 만들어진 인자값(args)** 을 통해 **컨트롤러의 메소드를 호출** 한다.
(getMethodArgumentValues에서 ArgumentResolver를 이용해 인자값을 처리하는 과정에는 컴포지트 패턴이 적용되어 있는데, 후처리하는 과정에서도 동일하게 사용되므로 이따가 살펴보도록 하자.)
 
`doInvoke` 는 부모 클래스인 InvocableHandlerMethod에 다음과 같이 구현되어 있다.

```java
@Nullable
protected Object doInvoke(Object... args) throws Exception {
   Method method = getBridgedMethod();
   try {
      if (KotlinDetector.isSuspendingFunction(method)) {
         return CoroutinesUtils.invokeSuspendingFunction(method, getBean(), args);
      }
      return method.invoke(getBean(), args);
   } catch (IllegalArgumentException ex) {
      ... // IllegalArgumentException 처리
   } catch (InvocationTargetException ex) {
      ... // Unwrap for HandlerExceptionResolvers ...
   }
}
```

<br>

가장 먼저 요청을 처리할 controller 의 method 객체 (Java 의 리플렉션 method)를 꺼내온다.

그리고 Method 객체의 invoke 를 통해서(Reflection 을 사용해서) 실제 controller 에게 위임을 해준다.

Controller 에서 성공적으로 작업을 처리한 후에 ResponseEntity 를 반환했다면 **invokeAndHandler 의 returnValue 로** 해당 객체가 온다.

```java
private HandlerMethodReturnValueHandlerComposite returnValueHandlers;

public void invokeAndHandle(ServletWebRequest webRequest, ModelAndViewContainer mavContainer,
        Object... providedArgs) throws Exception {

    Object returnValue = invokeForRequest(webRequest, mavContainer, providedArgs);

    ...

    try {
        this.returnValueHandlers.handleReturnValue(
            returnValue, getReturnValueType(returnValue), mavContainer, webRequest);
        } catch (Exception ex) {
            ...
        }
    }
}
```

<br>

그 다음에는 응답에 대한 후처리를 할 차례인데, 후처리는 returnValueHandlers를 통해 처리된다.

ArgumentResolver로 요청을 전처리하는 과정과 ReturnValueHandler로 후처리하는 과정 모두에는 컴포지트 패턴이 적용되어 있다. 

`요청` 을 처리하기 위한 인터페이스로 **HandlerMethodArgumentResolver** 가 있다면, `응답` 을 처리하기 위한 인터페이스로는 **HandlerMethodReturnValueHandler** 가 있다.

```java
public interface HandlerMethodReturnValueHandler {

boolean supportsReturnType(MethodParameter returnType);

void handleReturnValue(@Nullable Object returnValue, MethodParameter returnType,
         ModelAndViewContainer mavContainer, NativeWebRequest webRequest) throws Exception;

}
```

<br>

응답에 따라 다양한 형태로 처리하기 위해서 이를 list 로 가지고 있으며,
supportsReturnType 으로 처리 가능한 구현체인지를 판별해야 한다.

Spring 은 HandlerMethodReturnValueHandler 인터페이스 목록을 가지고 있는 컴포지트 객체인 HandlerMethodReturnValueHandlerComposite를 만들어두고 HandlerMethodReturnValueHandler를 구현받도록 하여 컴포지트 패턴을 적용하고 있다.


```java
public class HandlerMethodReturnValueHandlerComposite implements HandlerMethodReturnValueHandler {

   private final List<HandlerMethodReturnValueHandler> returnValueHandlers = new ArrayList<>();

   @Override
   public boolean supportsReturnType(MethodParameter returnType) {
      return getReturnValueHandler(returnType) != null;
   }

   @Nullable
   private HandlerMethodReturnValueHandler getReturnValueHandler(MethodParameter returnType) {
      for (HandlerMethodReturnValueHandler handler : this.returnValueHandlers) {
         if (handler.supportsReturnType(returnType)) {
            return handler;
         }
      }
      return null;
   }

   @Override
   public void handleReturnValue(@Nullable Object returnValue, MethodParameter returnType,
         ModelAndViewContainer mavContainer, NativeWebRequest webRequest) throws Exception {

      HandlerMethodReturnValueHandler handler = selectHandler(returnValue, returnType);
      if (handler == null) {
         throw new IllegalArgumentException("Unknown return value type: " + returnType.getParameterType().getName());
      }
      handler.handleReturnValue(returnValue, returnType, mavContainer, webRequest);
   }

   ...

}
```

<br>

오버라이딩된 supportsReturnType 메소드의 경우에는 **리스트를 순회하여 처리 가능한 핸들러** 가 있을 경우에 true를 반환하게 하였으며, handleReturnValue의 경우에는 처리 가능한 핸들러를 찾아서 **해당 핸들러의 handleReturnValue 호출** 을 해주고 있다. 

아주 적절하게 컴포지트 패턴을 적용해서 문제를 해결함을 확인할 수 있다.

`ResponseEntity` 객체를 반환한 경우에는 컴포지트 객체가 갖는 HandlerMethodReturnValueHandler 구현체 중에서 `HttpEntityMethodProcessor` 가 사용된다. 

HttpEntityMethodProcessor 내부에서는 Response를 set해주고, 응답 가능한 MediaType인지 검사한 후에 적절한 MessageConverter를 선택해 응답을 처리하고 결과를 반환한다.


<br>


## 2. Dispatcher Servlet 의 초기화 과정

마지막으로 디스패처 서블릿의 초기화 과정 중 일부만 살펴보도록 하자.
 
[ DispatcherServlet(디스패처 서블릿)의 초기화 과정 ]

앞서 설명하였듯 **`Dispatcher Servlet`** 은 J2EE 스펙의 **HttpServlet 클래스를 확장한 서블릿 기반의 기술** 이다. 

그러므로 Dispatcher Servlet 역시 **일반적인 서블릿의 라이프사이클을 따르게 되는데** 서블릿의 라이프사이클은 다음과 같다.

![image](https://github.com/lielocks/WIL/assets/107406265/05f8c132-165e-4638-8c45-f2fe0e468957)

+ **초기화** : 요청이 들어오면 servlet 이 web container 에 등록되어 있는지 확인하고, 없으면 초기화를 진행함

+ **요청 처리** : 요청이 들어오면 각각의 HTTP method 에 맞게 요청을 처리함

+ **소멸** : Web Container 가 Servlet 에 종료 요청을 하여 종료시에 처리해야 하는 작업들을 처리함

<br>

클라이언트로부터 요청이 오면 Web Container 는 먼저 servlet 이 초기화 되었는지를 확인하고, 초기화되지 않았다면 **`init()`** 메소드를 호출해 초기화를 진행한다. 

init() 메소드는 **첫 요청이 왔을 때 한번만** 실행되기 때문에 **`servlet 의 쓰레드에서 공통적으로 필요로 하는 작업들이 진행`** 된다. 

그 작업들 중에는 Dispatcher Servlet 이 controller 로 요청을 위임하고 받은 결과를 처리하기 위한 도구들을 준비하는 과정이 있다. 

Dispatcher Servlet 은 요청을 처리하기 위해 다음과 같은 도구들을 필요로 한다.

+ Multipart 파일 업로드를 위한 MultipartResolver

+ Locale을 결정하기 위한 LocaleResolver

+ 요청을 처리할 컨트롤러를 찾기 위한 HandlerMapping

+ 요청을 컨트롤러로 위임하기 위한 HandlerAdapter

+ 뷰를 반환하기 위한 ViewResolver

+ 기타 등등

<br>

**Spring 은 Lazy-Init 전략** 을 사용해 애플리케이션을 빠르게 구동하도록 하고 있어서, `첫 요청이 와서 servlet 초기화가 진행될 때` ***Application Context 로부터 해당 빈을 찾아서 설정(Set)*** 해준다. 

*그리고 이는 spring 의 첫 요청을 느리게 만드는 원인* 이다. 

Dispatcher Servlet 의 초기화 화 로직은 다음과 같이 구현되어 있다. (부모 클래스 부분은 생략한 것이다.)


```java
@Override
protected void onRefresh(ApplicationContext context) {
    initStrategies(context);
}

protected void initStrategies(ApplicationContext context) {
    initMultipartResolver(context);
    initLocaleResolver(context);
    initThemeResolver(context);
    initHandlerMappings(context);
    initHandlerAdapters(context);
    initHandlerExceptionResolvers(context);
    initRequestToViewNameTranslator(context);
    initViewResolvers(context);
    initFlashMapManager(context);
}
```

<br>

위의 코드에서 도구들을 초기화하는 메소드 이름이 `initStrategies` 인 이유는 **전략 패턴** 이 적용되었기 때문이다. 

대표적으로 **뷰를 반환하기 위한 도구인 ViewResolver** 를 중심으로 살펴보도록 하자. 

**ViewResolver** 에는 전략 패턴이 적용되었으므로 **`인터페이스`** 이다. 

ViewResolver 외에 다른 모든 도구들도 전략 패턴을 적용하므로 인터페이스를 갖고 있고, **인터페이스 타입** 으로 선언되어 있다.

<br>

```java
public interface ViewResolver {

    @Nullable
    View resolveViewName(String viewName, Locale locale) throws Exception;

}
```

Spring 은 기본적으로 `ContentNegotiatingViewResolver, BeanNameViewResolver, InternalResourceViewResolver` 를 **Bean 으로 등록** 해둔다. 

그리고 개발자가 추가한 Thymeleaf나 Mustache와 같은 **템플릿 엔진** 을 위한 ViewResolver도 추가될 수 있다. (Spring Boot 에서는 해당 의존성을 추가하면 자동으로 등록된다.) 

결국 실제로 어떤 구현체가 사용될지는 애플리케이션 실행 후에야 알 수 있다. 
그래서 spring은 유연하게 도구들을 사용할 수 있도록 `전략 패턴` 을 적용하였으며 **여러 ViewResolver가 동작 가능하도록 List로 ViewResolver** 를 가지고 있다.
 
그런데 spring 은 ViewResolver에 추가적으로 컴포지트 클래스인 ViewResolverComposite를 만들어 **`컴포지트 패턴`** 까지 적용하고 있는데, 그 이유는 **WebMvcConfigurer** 와 관련이 있다. 

Spring 에서는 `Interceptor 나 CORS 처리` 등 **웹 기능을 확장하기 위해서 WebMvcConfigurer 인터페이스를 구현한 설정 클래스를 만들어준다.**

그리고 여기서도 ViewResolver를 직접 등록해줄 수 있는데, `여기서 등록된 빈들은 CompositeViewResolver` 에 등록이 된다. 

예를 들어 다음과 같은 설정 클래스를 추가했다고 하자.

```java
@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    @Override
    public void configureViewResolvers(ViewResolverRegistry registry) {
        registry.viewResolver(new MyViewResolver());
    }

    static class MyViewResolver implements ViewResolver {
        @Override
        public View resolveViewName(String viewName, Locale locale) throws Exception {
            return null;
        }
    }

    @Bean
    public MangKyuViewResolver mangKyuViewResolver() {
        return new MangKyuViewResolver();
    }

    static class MangKyuViewResolver implements ViewResolver {
        @Override
        public View resolveViewName(String viewName, Locale locale) throws Exception {
            return null;
        }
    }
}
```

<br>

MyViewResolver는 WebMvcConfigurer를 통해 등록되었으므로 ViewResolverComposite에 추가가 되고, MangKyuViewResolver는 직접 빈을 등록해준 것이므로 List 안에 등록이 된다. 

최종적으로 **Dispatcher Servlet 의 List<ViewResolver>** 는 다음과 같이 구성 된다.

+ ContentNegotiatingViewResolver

+ BeanNameViewResolver

+ MangKyuViewResolver

+ ViewResolverComposite

  + MyViewResolver

+ InternalResourceViewResolver

<br>


첫 요청이 느린 문제를 해결하는 방법은 스프링 애플리케이션이 실행된 후에 아무런 API를 호출해 서블릿 초기화를 시키면 된다. 존재하지 않는 URI라 할지라도 디스패처 서블릿은 첫 요청을 받아들이기 위해 초기화 과정을 진행한다.


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


<br>


## JIT 컴파일러의 웜업(Warm - Up)

### [자바 언어의 동작 방식]

첫 요청이 오래 걸리는 주된 이유는 JVM 의 JIT 컴파일러와 연관이 있다.

그러므로 우리는 java 언어의 동작 방식을 살펴보아야 하는데, 그 전에 C, C++, GoLang, Rust 등과 같은 컴파일 언어의 동작 과정부터 살펴보도록 하자.

컴파일 언어는 컴파일 과정에서 바로 기계어를 만들어낸다.

그리고 컴파일시에 코드 최적화까지 진행하여 처리 성능이 상당히 뛰어나다.

대신 생성된 기계어가 빌드 환경(CPU 아키텍처)에 종속적이라서, 플랫폼이 바뀐다면 다시 빌드해야 하는 문제가 있다.

![image](https://github.com/lielocks/WIL/assets/107406265/801d3811-ee8a-4124-8c12-c54be70d9c00)


<br>


하지만 자바는 이러한 **`플랫폼 종속적인 문제`** 를 해결하고자 **JVM** 을 도입하였고, 그래서 동작 과정이 조금 다르다.

자바는 먼저 작성된 Source Code 를 Byte Code 로 compile 하는데, Byte Code 는 주로 JAR 또는 WAR로 아카이브하여 활용하게 된다. 

JVM은 아카이빙된 파일을 구동하는데, **`실시간으로 Byte Code 를 기계어로 번역하면 CPU가 해당 기계어를 처리한다.`** 

이러한 구조 덕분에 Java는 플랫폼에 종속되지 않게 되었지만, 코드를 실행할 때 **Byte Code 를 기계어로 번역하는 작업** 때문에 성능이 느려졌다. 

그래서 이러한 문제를 해결하고자 JIT 컴파일러를 도입하여 사용하고 있다.

![image](https://github.com/lielocks/WIL/assets/107406265/6019592b-cb2d-407a-8af0-cdb9266578c6)


<br>


### [ JIT 컴파일러(Just In Time Compiler)의 웜업(Warm-Up) 문제 ]

*자바는 성능 문제를 해결* 하고자 **적시에 기계어를 만들어낸다** 는 의미의 **`JIT(Just In Time) 컴파일러`** 를 도입하여 사용하고 있다. 

JIT 컴파일러는 핫스팟이라고도 불리는데, JDK 1.3부터 반영되어 있다. 

**`JIT 컴파일러`** 는 **바이트 코드를 기계어로 번역하는 과정에서 캐시를 활용** 한다. 

그래서 **`이미 번역된 기계어를 재사용`** 할 수 있도록 하며, 그에 더해 런타임 환경에 맞춰 코드도 최적화함으로써 성능을 향상시킨다.

하지만 문제는 `애플리케이션이 시작될 때에는` **캐싱된 기계어가 없다는 것** 이고, 그래서 ***스프링에서 첫 요청이 오래걸리는 것*** 이다. 

만약 *요청이 많은 서비스에서 캐싱된 기계어가 없는 상태* 라면 `배포 직후에는 응답 지연이 발생` 하여 문제가 발생할 수 있다.

![image](https://github.com/lielocks/WIL/assets/107406265/9599f55b-1008-4f4e-8058-0771635701c7)

그래서 **애플리케이션 시작 후에 강제로 로직을 호출하여 기계어를 캐싱해두는 작업** 이 필요한데, 이를 **`warm-up`** 이라고 한다. 

트래픽이 많은 서비스라면 warm-up 작업은 반드시 고려되어야 한다. 

참고로 위에서 설명한 서블릿 초기화 보다는 **JIT 컴파일러 부분이 훨씬 성능에 크게 영향** 을 미친다.


<br>


## SpringBoot 실행 후에 초기화 코드를 넣는 3가지 방법과 이벤트 리스너(CommandLineRunner, ApplicationRunner, EventListener)

애플리케이션이 실행된 후에 초기화 등의 이유로 1회 특정한 코드의 실행을 필요로 할 수 있다. 스프링 부트에는 이러한 문제를 해결하기 위해 다음과 같은 3가지 방식을 사용할 수 있다.
 

### [커맨드라인 파라미터를 위한 CommandLineRunner]

**CommandLineRunner 를 구현하는 클래스 생성**

CommandLineRunner는 스프링 부트 1.0에 추가된 **함수형 인터페이스로써 스프링 애플리케이션이 구동된 후에 실행되어야 하는 빈을 정의** 하기 위해 사용된다. 

CommandLineRunner는 파라미터로 String 타입의 가변 인자를 받고 있으며 인터페이스 이름 그대로 **`커맨드 라인으로 받은 스트링 타입의 인자를 파라미터로 받아서 사용`** 하기 위해 만들어졌다. 

CommandLineRunner는 이를 구현하는 클래스를 정의하고 빈이 등록하면 애플리케이션이 구동된 후에 자동으로 run 메소드가 실행된다.


```java
@Component
class MangKyuCommandLineRunner implements CommandLineRunner {

    @Override
    public void run(String... args) {
        System.out.println("MangKyu");
    }
    
}
```

<br>


**CommandLineRunner를 람다식으로 구현**

우리가 필요로 하는 작업은 `애플리케이션 실행 후에 1회 초기화 작업` 인데, 위와 같이 *클래스로 만드는 것은 무거우며 번거롭다.* 

CommandLineRunner는 함수형 인터페이스이므로 다음과 같이 **main 클래스에 @Bean과 함께 람다식으로 구현하여 간소화** 할 수 있다.

```java
@SpringBootApplication
public class TestingApplication {

    public static void main(String[] args) {
        SpringApplication.run(TestingApplication.class, args);
    }

    @Bean
    public CommandLineRunner commandLineRunner() {
        return args -> System.out.println("MangKyu");
    }
}
```

<br>

 
@Bean은 @Configuration이 있는 클래스 안에서만 동작하는데, **@SpringBootApplication** 이 갖고 있는 `@SpringBootConfiguration 안에 @Configuration이 존재` 하므로 **메인 클래스 역시 빈으로 등록이 되어 가능** 한 것이다.


<br>


### [ 다양한 파라미터를 위한 ApplicationRunner ]

**ApplicationRunner** 역시 마찬가지로 함수형 인터페이스로써 **`스프링 애플리케이션이 구동된 후에 실행되어야 하는 빈을 정의`** 하기 위한 인터페이스이다. 

목적 자체는 동일하지만 ApplicationRunner는 CommandLineRunner와 달리 **다양한 종류의 파라미터** 를 받아서 실행하는 경우에 사용할 수 있다. 

CommandLineRunner는 스프링 부트 1.0에 추가된 반면에 ApplicationRunner는 스프링 부트 2.0에 추가되었다. 

ApplicationRunner도 비슷하게 이 인터페이스를 구현하는 클래스를 등록할수도 있고 람다식으로 직접 사용할 수도 있다.


```java
@SpringBootApplication
public class TestingApplication {

    public static void main(String[] args) {
        SpringApplication.run(TestingApplication.class, args);
    }

    @Bean
    public ApplicationRunner applicationRunner() {
        return args -> System.out.println("MangKyu");
    }
}
```

<br>


### [ 이벤트 수신을 위한 EventListener ]

**이벤트 리스너 등록 및 이벤트 발행**

Spring 은 초기부터 `Application Context 내부` 에서 **특정 타입의 event 를 던지고, 이를 listen 하는 Listener 에게 전달해주는 메커니즘** 을 사용하고 있었다. 

그리고 우리가 이를 애플리케이션 레벨에서 이용할 수도 있는데, **특정 타입의 이벤트를 수신하기 위해서는 해당 Listener 를 구현해 bean 으로 등록** 해두면 된다. 

event 를 수신하는 Listener 를 등록하고 event 를 발행하는 코드는 다음과 같다.


```java
@SpringBootApplication
public class TestingApplication {

    public static void main(String[] args) {
        ConfigurableApplicationContext context = SpringApplication.run(TestingApplication.class, args);

        context.addApplicationListener(new ApplicationListener<ApplicationEvent>() {
            @Override
            public void onApplicationEvent(ApplicationEvent event) {
                System.out.println("MangKyu");
            }
        });

        context.publishEvent(new ApplicationEvent(context) {

        });
    }
}
```

<br>


ApplicationEvent의 생정자는 Object 타입을 받고 있는데, 이벤트를 발행하는 객체를 넣는 용도로 존재한다. 

위의 코드에서는 **ApplicationContext 객체** 를 넣어주었다. 

ApplicationListener는 역시 함수형 인터페이스이므로 람다식으로 간소화할 수 있다.


```java
@SpringBootApplication
public class TestingApplication {

    public static void main(String[] args) {
        ConfigurableApplicationContext context = SpringApplication.run(TestingApplication.class, args);

        context.addApplicationListener(event -> System.out.println("MangKyu"));

        context.publishEvent(new ApplicationEvent(context) {

        });
    }
}
```

<br>


**@EventListener 를 사용한 이벤트 리스너 등록**

하지만 위와 같이 이벤트 리스너를 직접 구현하는 방식은 상당히 번거롭다. 

그래서 스프링 4.2부터는 @EventListener 어노테이션이 추가되었는데, **@EventListener** 를 **`spring bean 안에 구현해두면 Listener가 동작`** 하게 된다. 

*spring 은 애플리케이션이 준비되었을 때* **ApplicationReadyEvent 타입의 이벤트를 발행** 하므로, 애플리케이션이 준비되었을 때 어떤 코드를 실행하기 위해서는 다음과 같이 이용할 수 있다.


```java
@SpringBootApplication
public class TestingApplication {

    public static void main(String[] args) {
        SpringApplication.run(TestingApplication.class, args);
    }

    @EventListener(ApplicationReadyEvent.class)
    public void init() {
        System.out.println("MangKyu");
    }
    
    @EventListener
    public void init(ApplicationReadyEvent event) {
        System.out.println("MangKyu");
    }
}
```

<br>


앞서 @EventListener 는 spring bean 안에 넣어야 한다고 했는데, 앞서 살펴보았듯 **main class 역시 spring bean 으로 등록되므로 main class 안에서 @EventListener 사용이 가능** 하다. 

또한 @EventListener는 여러 타입의 메세지를 받을 수 있는데, 특정 타입의 메세지를 받기 위해서는 @EventListener 어노테이션에 이벤트 타입을 넣어주면 되며, 

만약 해당 타입이 파라미터로 필요하다면 어노테이션에 적어줄 필요 없이 파라미터로만 명시해주어도 된다.

spring 은 `ApplicationReadyEvent 타입의 이벤트를 1회만 발행` 하는데, 위의 코드에서는 **수신하는 Listener 가 2개가 존재** 한다. 

**`Event Listener`** 는 기본적으로 **Multi Casting 관계이므로 동일한 타입의 여러 listener 가 등록되었다면 모든 listener 가 이벤트를 받게 된다.**


<br>


**Custom Event 와 Custom Event Listener 의 구현**

ApplicationListener 의 제네릭 타입으로 **ApplicationEvent 하위의 이벤트 클래스를 주면 해당 타입의 event 만을 받도록** 구현할 수 있다. 

또한 직접 `Listener 어노테이션` 을 구현할 수도 있는데, 이를 코드로 작성하면 다음과 같다.


```java
@SpringBootApplication
public class TestingApplication {

    public static void main(String[] args) {
        ConfigurableApplicationContext context = SpringApplication.run(TestingApplication.class, args);
        context.publishEvent(new MangKyuEvent(context, "MangKyuEvent"));
    }

    static class MangKyuEvent extends ApplicationEvent {

        private final String message;

        public MangKyuEvent(Object source, String message) {
            super(source);
            this.message = message;
        }
    }

    @Target(ElementType.METHOD)
    @Retention(RetentionPolicy.RUNTIME)
    @EventListener
    @interface MangKyuListener {

    }

    @MangKyuListener
    public void mangKyuEvent(MangKyuEvent mangKyuEvent) {
        System.out.println(mangKyuEvent.message);
    }

}
```

<br>


이러한 이벤트를 발행하고 listener 를 통해 수신하는 개발 방식은 **bean 들 사이의 관계를 끊어 느슨하게 함으로써 결합도를 낮출 수 있다.** 

또한 이를 중심으로 개발하는 설계 등을 **`이벤트 주도 설계(Event Driven Architecture)`** 등이라고도 한다.

spring boot 에서는 애플리케이션의 시점에 따라 이벤트를 발행하기 위해 ApplicationEvent를 상속받는 SpringApplicationEvent 추상클래스를 구현해두었고, 
다음과 같은 구현체들 역시 만들어두었다. 

아래의 내용들은 공식 문서에서 참고한 내용들이다.

+ ApplicationStartingEvent

  + 애플리케이션이 실행되고나서 가능한 빠른 시점에 발행됨
  
  + Environment와 ApplicationContext는 준비되지 않았지만 listener 들은 등록이 되었음
  
  + 이벤트 발행 source 로 SpringApplication 이 넘어오는데, 이후 내부 상태가 바뀌므로 내부 상태의 변경은 최소화해야 함


<br>


+ ApplicationContextInitializedEvent

  + 애플리케이션이 시작되고 애플리케이션 컨텍스트가 준비되었으며 initializer가 호출되었음
  
  + 하지만 빈 정보들은 불러와지기 전에 발행됨


<br>


+ ApplicationEnvironmentPreparedEvent

  + 애플리케이션이 실행되고 Environment가 준비되었을 때 발행됨


<br>


+ ApplicationPreparedEvent

  + 애플리케이션이 시작되고 애플리케이션 컨텍스트가 완전히 준비되었지만 refresh 되기 전에 발행됨

  + 빈 정보들은 불러와졌으며 Environment 역시 준비가 된 상태임


<br>


+ ApplicationStartedEvent

  + 애플리케이션 컨텍스트가 refesh 되고나서 발행됨
  
  + ApplicationRunner와 CommandLineRunner가 실행되기 전의 시점임


<br>


+ ApplicationReadyEvent

  + 애플리케이션이 요청을 받아서 처리할 준비가 되었을 때 발행됨
  
  + 이벤트 발행 source로 SpringApplication이 넘어오는데, 이후에 초기화 스텝이 진행되므로 내부 변경은 최소화해야 함


<br>


+ ApplicationFailedEvent

  + 애플리케이션이 실행에 실패했을 때 발행됨


<br>


위의 3가지 중에서 편한 방법을 이용하면 애플리케이션 실행 시에 warm-up을 시킴으로써 첫 요청이 느린 문제를 해결할 수 있다. 

물론 EventListener 는 비지니스 로직에서 불필요하게 연관관계가 복잡해지는 문제들을 해결하기 위해서도 사용할 수 있다. 

이러한 경우에 만약 트랜잭션과 연관된 작업이라면 @TransactionalEventListener를 사용해주면 된다.
 


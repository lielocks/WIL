## 1. Servlet 서블릿

Servlet 을 한줄로 정의하자면 아래와 같습니다.

![image](https://github.com/lielocks/WIL/assets/107406265/923dfae6-b1ac-4bd1-9a2a-5bbfc143f448)

간단히 말해서, Servlet 이란 **Java 를 사용하여 Web 을 만들기 위해 필요한 기술** 입니다.

그런데 좀더 들어가서 설명하면 **Client 가 어떠한 요청을 하면 `그에 대한 결과를 다시 전송`** 해주어야 하는데,

이러한 역할을 하는 Java program 입니다.


<br>


예를 들어, 어떠한 사용자가 로그인을 하려고 할 때, 사용자는 id 와 pw 를 입력하고, 로그인 버튼을 누릅니다.

그때 Server 는 Client 의 id 와 pw 를 확인하고, 다음 페이지를 띄워주어야 하는데, 

이러한 역할을 수행하는 것이 바로 **`Servlet`** 입니다.


<br>


> ***그래서 Servlet 은 `Java 로 구현된 CGI` 라고 흔히 말합니다.***


<br>


### Servlet 특징

+ Client 의 요청에 대해 **동적** 으로 작동하는 Web application component

+ **html**  을 사용하여 요청에 응답한다.

+ **Java Thread** 를 이용하여 동작한다.

+ MVC 패턴에서 **Controller** 로 이용된다.

+ HTTP protocol service 를 지원하는 `javax.servlet.http.HttpServlet` 클래스를 상속받는다.

+ *UDP* 보다 처리 속도가 **느리다.**

+ `HTML 변경 시` Servlet 을 **recompile** 해야 하는 단점이 있다.


<br>


일반적으로 Web Server 는 *정적인 페이지만을* 제공합니다. 

그렇기 때문에 **동적인 페이지** 를 제공하기 위해서 **Web Server 는 `다른 곳에 도움을 요청하여` 동적인 페이지를 작성해야 합니다.**

동적인 페이지로는 임의의 이미지만을 보여주는 페이지와 같이 ***사용자가 요청한 시점에 페이지를 생성해서 전달해주는 것*** 을 의미합니다.

여기서 Web Server 가 **동적인 페이지를 제공할 수 있도록 도와주는 application** 이 **`Servlet`** 이며, 동적인 페이지를 **생성** 하는 application 이 **`CGI`** 입니다.


<br>


### [Servlet 동작 방식]

![image](https://github.com/lielocks/WIL/assets/107406265/58c6e5b8-df80-4894-a81b-4bcba5ae8aa0)

1. *사용자(Client) 가 URL 을 입력하면* **HTTP Requset 가 Servlet Container 로 전송** 합니다.

2. *요청을 전송받은 Servlet Container* 는 **HttpServletRequest, HttpServletResponse 객체를 생성** 합니다.

3. `web.xml` 을 기반으로 **사용자가 요청한 URL 이 `어느 Servlet 에 대한 요청`인지** 찾습니다.

4. 해당 Servlet 에서 `service 메소드`를 호출한 후 **Client 의 GET, POST 여부에 따라 `doGet()` 또는 `doPost()`를 호출** 합니다.

5. doGet() or doPost() 메소드는 **동적 페이지를 생성한 후 HttpServletResponse 객체에 응답** 을 보냅니다.

6. 응답이 끝나면 **HttpServletRequest, HttpServletResponse 두 객체를 소멸** 시킵니다.


<br>


***CGI (Common Gateway Interface) 란?***

> **`CGI`** 는 *특별한 라이브러리나 도구를 의미하는 것이 아니고,* 별도로 제작된 **`Web Server 와 program 간의 교환 방식`** 입니다.
>
> **`CGI 방식`** 은 *어떠한 프로그래밍 언어로도 구현이 가능하며,* 별도로 만들어 놓은 **program 에 HTML 의 Get or Post 방법으로 client 의 데이터를 환경변수로 전달하고,**
>
> **Program 의 표준 출력 결과를 client 에게 전송** 하는 것입니다.
>
> 즉, Java application 코딩을 하듯 **Web 브라우저용 출력 화면** 을 만드는 방법입니다.


<br>


***HTTP 프로토콜을 이용한 server 와 client 의 통신 과정은?***

> Client 는 정보를 얻기 위해 **server 로 HTTP 요청을 전송** 하고, server 는 이를 해석하여 *static 자원에 대한 요청* 일 경우 자원을 반환해주고,
>
> **그렇지 않은 경우 `CGI 프로그램`을 실행시켜 해당 결과를 return 해줍니다.**
>
> 이때 **server** 는 **CGI 프로그램에게 요청을 전달** 해주고, **결과를 전달받기 위한 `pipeline`을 연결** 합니다.
>
> 그래서 **`CGI 프로그램`** 은 **입력에 대한 서비스를 수행하고, 결과를 client 에게 전달하기 위해 결과 페이지에 해당하는 MIME 타입의 `컨텐츠 데이터를 Web server 와 연결된 pipeline 에 출력하여 server 에 전달` 합니다.**
>
> **`Server`** 는 **pipeline 을 통해 CGI 프로그램에서 출력한 결과 페이지의 데이터를 읽어, HTTP 응답 header 를 생성하여 데이터를 함께 반환** 해줍니다.


<br>


## 2. Servlet Container 서블릿 컨테이너

Servlet Container 는 servlet 을 이해했다면 상당히 쉽게 이해할 수 있습니다.

![image](https://github.com/lielocks/WIL/assets/107406265/656e6c46-2c6e-44ff-b35b-b21dcf52aaf2)

우리가 **Server 에 Servlet 을 만들었다고 해서 스스로 작동하는 것이 아니고** **`Servlet을 관리해주는 것`** 이 필요한데, 
그러한 역할을 하는 것이 바로 **`Servlet Container`** 입니다. 

예를 들어, `Servlet` 이 ***어떠한 역할을 수행하는 정의서*** 라고 보면, `Servlet Container` 는 ***그 정의서를 보고 수행*** 한다고 볼 수 있습니다. 

Servlet Container 는 **client 의 요청(Request)을 받아주고 응답(Response)할 수 있게, Web server 와 Socket 으로 통신** 하며 대표적인 예로 **`톰캣(Tomcat)`** 이 있습니다. 

**`Tomcat`** 은 실제로 Web server 와 통신하여 **JSP(Java Server Page)와 Servlet이 작동하는 환경** 을 제공해줍니다.


<br>


### [Servlet Container 역할]

1. **Web Server 와의 통신** 지원

   + Servlet Container 는 **`Servlet 과 Web Server`** 가 손쉽게 통신할 수 있게 해줍니다.
  
   + 일반적으로 우리는 socket 을 만들고 listen, accept 등을 해야하지만 **Servelt Container 는 이러한 기능을 API 로 제공** 하여 복잡한 과정을 생략할 수 있게 해줍니다.
  
   + 그래서 개발자가 Servlet 에 구현해야 할 business logic 에 대해서만 초점을 두게끔 도와줍니다.


<br>


2. **Servlet 생명주기(Life Cycle)** 관리

   + Servlet Container 는 **Servlet 의 탄생과 죽음을 관리** 합니다.
  
   + ***Servlet Class 를 로딩하여 인스턴스화*** 하고, ***초기화 메서드를 호출*** 하고, 요청이 들어오면 ***적절한 Servlet Method*** 를 호출합니다.
  
   + 또한 서블릿이 생명을 다한 순간에는 적절하게 **`Garbage Collection`** 을 진행하여 편의를 제공합니다.


<br>


3. **Multi Thread 지원 및 관리**

   + Servlet Container 는 **요청이 올때마다 새로운 Java thread 를 하나 생성** 하는데, HTTP 서비스 메서드를 실행하고 나면, **thread 는 자동으로 죽게됩니다.**
  
   + 원래는 thread 를 관리해야 하지만 server 가 다중 thread 를 생성 및 운영해주니 thread 의 안정성에 대해서 걱정하지 않아도 됩니다.


<br>  


4. **선언적인 보안 관리**

   + Servlet Container 를 사용하면 개발자는 `보안에 관련된 내용` 을 servlet 또는 java class 에 구현해놓지 않아도 됩니다.
  
   + 일반적으로 보안 관리는 **XML 배포 서술자에다 기록** 하므로, 보안에 대해 수정할 일이 생겨도 java source code 를 수정하여 다시 compile 하지 않아도 보안관리가 가능합니다.


<br>


위에서 Servlet Container 는 servlet 의 생명주기를 관리한다고 적어놓았습니다.
그렇다면 이번에는 추가적으로 **servlet 의 생명주기** 에 대해서 자세히 알아보도록 하겠습니다.


<br>


### [ Servlet 생명주기 ]

![image](https://github.com/lielocks/WIL/assets/107406265/f0b1df2d-8343-49f4-ad47-739ea4616ff6)

1. Client 의 요청이 들어오면 Container 는 **해당 servlet** 이 memory 에 있는지 확인하고, 없을 경우 **`init()` 메서드를 호출하여 적재합니다.**

     init() 메서드는 처음 **한번만** 실행되기 때문에, servlet 의 thread 에서 공통적으로 사용해야 하는 것이 있다면 **`overriding`** 하여 구현하면 됩니다.

     *실행 중 servlet 이 변경* 될 경우, **기존 servlet 을 파괴하고 init()을 통해 새로운 내용을 다시 메모리에 적재** 합니다.


<br>


2. init() 이 호출된 후 client 의 요청에 따라서 **service()** 메서드를 통해 요청에 대한 응답이 **`doGet()`** 과 **`doPost()`** 로 분기됩니다.

   이때 Servlet Container 가 `client 의 요청이 오면 가장 먼저 처리하는 과정`으로 생성된 **HttpServletRequest, HttpServletResponse 에 의해 request 와 response 객체가 제공됩니다.**


<br>


3. Container 가 servlet 에 종료 요청을 하면 **`destroy()`** 메서드가 호출되는데 마찬가지로 **한번만** 실행되며,

   종료시에 처리해야 하는 작업들은 destroy() 메서드를 overriding 하여 구현하면 됩니다.


<br>


## 3. JSP (Java Server Page)

지금까지 이해를 잘 했다면 JSP 에 대해서도 어렵지 않게 받아들일 수 있을 것입니다!

![image](https://github.com/lielocks/WIL/assets/107406265/360f39a3-a314-4efd-8744-31c7d092eef8)

**Servlet** 은 **`java source code 속에 HTML 코드가`** 들어가는 형태인데, 

**JSP** 는 이와 반대로 **`HTML 소스코드 속에 java source code 가 들어가는 구조`** 를 갖는 **Web application programming 기술** 입니다. 


<br>


HTML 속에서 java code 는 **`<% 소스코드 %>`** 또는 **`<%= 소스코드 =%>`** 형태로 들어갑니다. 

**`Java 소스코드`** 로 작성된 이 부분은 *Web 브라우저로 보내는 것이 아니라* **Web Server 에서 실행되는 부분** 입니다.

웹 프로그래머가 소스코드를 수정 할 경우에도 디자인 부분을 제외하고 **Java 소스코드만 수정하면 되기에** 효율을 높여줍니다. 

또한 compile 과 같은 과정을 할 필요없이 JSP 페이지를 작성하여 **Web Server 의 directory 에 추가만 하면 사용이 가능** 합니다. 

Servlet 규칙은 꽤나 복잡하기 때문에 JSP 가 나오게 되었는데 **`JSP`** 는 **WAS(Web Application Server)에 의하여 Servlet Class 로 변환하여 사용되어** 집니다. 


<br>


### [JSP 동작 구조]

![image](https://github.com/lielocks/WIL/assets/107406265/254a524c-c2f3-4d67-ab57-fe577ef899d9)

Web Server 가 사용자로부터 servlet 에 대한 요청을 받으면 ***servlet container 에 그 요청을 넘깁니다.***

요청을 받은 container 는 **HTTP Request** 와 **HTTP Response** 객체를 만들어, 이들을 통해 **servlet doPost() 나 doGet() 메서드 중 하나를 호출** 합니다.

만약 *servlet 만 사용하여 사용자가 요청한 Web page 를 보여주려면* **out 객체의 println 메서드를 사용하여 HTML 문서를 작성** 해야 하는데 

이는 추가 / 수정을 어렵게 하고, 가독성도 떨어지기 때문에 **`JSP` 를 사용하여 business 로직과 presentation 로직을 분리** 합니다.


<br>


여기서 servlet 은 **`데이터의 입력, 수정 등에 대한 제어를 JSP 에게`** 넘겨서 **프레젠테이션 로직** 을 수행한 후 **servlet container 에게 Response 를 전달** 합니다.

이렇게 만들어진 결과물은 **사용자가 해당 페이지를 요청하면 compile 이 되어 `java 파일을 통해 .class 파일`이 만들어지고, 두 로직이 결합되어 `클래스화`** 되는 것을 확인할 수 있다.

즉, *out 객체의 println 메서드를 사용해서 구현해야 하는 번거로움* 을 **JSP** 가 대신 수행해줍니다.

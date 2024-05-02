## 1. OpenFeign이란? Open Feign 소개 및 역사

### [OpenFeign 이란?]

Open Feign은 Netflix에 의해 처음 만들어진 **`Declarative(선언적인) HTTP Client 도구`** 로써, **외부 API 호출** 을 쉽게할 수 있도록 도와준다. 

여기서 “선언적인” 이란 어노테이션 사용을 의미하는데, Open Feign은 `Interface 에 어노테이션들만 붙여주면` 구현이 된다. 

이러한 방식은 Spring Data JPA와 유사하며, 상당히 편리하게 개발을 할 수 있도록 도와준다.


```java
@FeignClient(name = "ExchangeRateOpenFeign", url = "${exchange.currency.api.uri}")
public interface ExchangeRateOpenFeign {

    @GetMapping
    ExchangeRateResponse call(
            @RequestHeader String apiKey,
            @RequestParam Currency source,
            @RequestParam Currency currencies);

}
```

<br>

### [OpenFeign 의 역사]

OpenFeign의 초기 모델인 Feign은 `Eureka, Ribbon 등을 포함하는 Netflix OSS 프로젝트` 의 일부로써 Netflix에 의해 만들고 공개되었다. 

Netflix OSS가 공개되고 나서 Spring Cloud 진영은 `Spring Cloud Netflix` 라는 프로젝트로 **Netflix OSS를 Spring Cloud 생태계** 로 포함시켰는데, 
**Feign은 단독으로 사용될 수 있도록 별도의 starter로 제공되었다.**

이후에 넷플릭스는 내부적으로 feign의 사용 및 개발을 중단하기로 결정하였고, OpenFeign이라는 새로운 이름과 함께 오픈소스 커뮤니티로 넘겨졌다. 

Spring Cloud는 Open Feign 역시 스프링 클라우드 생태계로 통합하였고, 이 과정에서 기존의 Feign 자체 어노테이션과 JAX-RS 어노테이션만 사용 가능했던 부분을 **Spring MVC 어노테이션을 지원** 하도록 추가했다. 

그리고 추가적으로 Spring에서 사용되는 것과 동일한 `HttpMessageConverters` 를 사용하도록 확장하였다. 

그 외에도 다른 Spring Cloud 기술인 `Eureka, CircuitBreaker, LoadBalancer를 통합하여 load-balanced` 된 **http client** 를 제공하고자 하였다.

![image](https://github.com/lielocks/WIL/assets/107406265/fa963891-9fc5-4f19-9eb1-e288ee5ce6a8)


<br>


### [OpenFeign 의 장점]

+ Interface 와 어노테이션 기반으로 작성할 코드가 줄어들음

+ 익숙한 `Spring MVC 어노테이션` 으로 개발이 가능함

+ 다른 **Spring Cloud 기술들** (Eureka, Circuit Breaker, LoadBalancer) 과의 통합이 쉬움

 
OpenFeign의 가장 큰 장점은 인터페이스와 어노테이션 기반으로 작성할 코드가 줄어든다는 것이다. 

아래의 코드는 **환율 조회 API를 RestTemplate** 으로 작성한 것인데, 요즘 같이 **API 호출이 잦은 MSA 의 시대에서 이런 코드를 반복한다는 것은 번거롭다.


```java
@Component
@RequiredArgsConstructor
class ExchangeRateRestTemplate {

    private final RestTemplate restTemplate;
    private final ExchangeRateProperties properties;
    private static final String API_KEY = "apikey";

    public ExchangeRateResponse call(final Currency source, final Currency target) {
        return restTemplate.exchange(
                        createApiUri(source, target),
                        HttpMethod.GET,
                        new HttpEntity<>(createHttpHeaders()),
                        ExchangeRateResponse.class)
                .getBody();
    }

    private String createApiUri(final Currency source, final Currency target) {
        return UriComponentsBuilder.fromHttpUrl(properties.getUri())
                .queryParam("source", source.name())
                .queryParam("currencies", target.name())
                .encode()
                .toUriString();
    }

    private HttpHeaders createHttpHeaders() {
        final HttpHeaders headers = new HttpHeaders();
        headers.add(API_KEY, properties.getKey());
        return headers;
    }
}
```

<br>


위의 코드를 OpenFeign으로 작성하면 아래의 코드로 끝이다. OpenFeign으로 코드를 작성하면 생산성이 상당히 높아질 것이라는 장점은 직접 쳐보지 않아도 느낄 수 있을 것이다.

```java
@FeignClient(name = "ExchangeRateOpenFeign", url = "${exchange.currency.api.uri}")
public interface ExchangeRateOpenFeign {

    @GetMapping
    ExchangeRateResponse call(
            @RequestHeader String apiKey,
            @RequestParam Currency source,
            @RequestParam Currency currencies);

}
```

<br>


### [ OpenFeign의 단점 및 한계 ]

+ 기본 Http Client 가 Http2 를 지원하지 않음 → Http Client에 대한 추가 설정 필요

+ 공식적으로 Reactive 모델을 지원하지 않음 → 비공식 오픈소스 라이브러리로 사용 가능

+ 경우에 따라서 애플리케이션이 뜰 대 초기화 에러가 발생할 수 있음 → Object Provider로 대응 필요

+ 테스트 도구를 제공하지 않음 → 별도의 설정 파일을 작성하여 대응 필요

 
다른 부분보다 테스트 도구를 제공하지 않는다는 점은 꽤나 치명적이다. 

왜냐하면 어노테이션과 인터페이스 기반으로 프로그래밍하는 만큼 테스트를 통해 코드에 문제가 없는지, API 호출이 정상적으로 되는지 빠르게 확인할 필요가 있기 때문이다. 

<br>


## 2. OpenFeign 시작하기

### 1. 의존성 추가하기

Open Feign은 Spring Cloud 기반의 기술이므로 **Spring Cloud** 에 대한 의존성이 필요하다.

Spring Cloud 문서를 보면 현재의 Spring Boot 버전에 맞는 버전이 명시되어 있는데, 적합한 버전을 확인한다.

![image](https://github.com/lielocks/WIL/assets/107406265/c2f32879-7128-4fc9-8adf-cb31db31c8ef)

그리고 이를 참고하여 Spring Cloud 의존성을 먼저 추가해줘야 한다. 아래의 예시는 SpringBoot 2.7을 기준으로 작성되었다.

```
ext {
    set('springCloudVersion', "2021.0.4")
}

dependencyManagement {
    imports {
        mavenBom "org.springframework.cloud:spring-cloud-dependencies:${springCloudVersion}"
    }
}
```
  
그리고 Open Feign 의존성을 추가해주면 된다.

```
implementation 'org.springframework.cloud:spring-cloud-starter-openfeign'
```

<br>


### 2. OpenFeign 활성화하기

OpenFeign을 활성화하려면 다른 스프링 부트 기능들과 유사하게 `@EnableFeignClients` 어노테이션을 붙여주면 된다. 

OpenFeign을 활성화하려면 기본적으로 main 클래스에 붙여주면 된다.


```java
@EnableFeignClients
@SpringBootApplication
public class OpenFeignSampleApplication {

    public static void main(String[] args) {
        SpringApplication.run(OpenFeignSampleApplication.class, args);
    }
}
```

<br>


하지만 Main 클래스에 @Enable 어노테이션을 붙여주는 것은 SpringBoot가 제공하는 테스트에 영향을 줄 수 있다. 

그러므로 `별도의 Config 파일로` 만들어주는 것이 좋다. 

별도의 파일로 설정할 경우에는 **feign 인터페이스들의 위치를 반드시 지정** 해주어야 하는데, `componentScan 처럼 baseBackes로 지정해주거나` , `clients로 직접 클래스들을 지정` 해줘도 된다. 

일반적으로 아래와 같이 **패키지** 로 지정하면 된다.


```java
@Configuration
@EnableFeignClients("com.mangkyu.openfeign")
class OpenFeignConfig {

}
```

<br>


### 3. FeignClient 구현하기
**`API 호출을 수행할 클라이언트`** 는 **interface 에 @FeignClient 어노테이션** 을 붙여주면 된다. 

그리고 **value 와 url 설정** 이 필요한데 `url 에는 호출할 주소` 를, `value 에는 임의의 client 의 이름` 을 적어주면 된다. 

value 는 다른 스프링 클라우드와의 통합 시에 SpringCloud LoadBalancer Client를 만드는 데 사용된다는데 중요하지 않으므로 넘어가도 되지만, 필수값이므로 반드시 입력해주어야 한다. 

value와 url에는 placeholder가 사용가능하므로 프로퍼티에 작성해둔 값을 사용하면 된다.


```java
@FeignClient(name = "ExchangeRateOpenFeign", url = "${exchange.currency.api.uri}")
public interface ExchangeRateOpenFeign {

    @GetMapping
    ExchangeRateResponse call(
            @RequestHeader String apiKey,
            @RequestParam Currency source,
            @RequestParam Currency currencies);

}
```

<br>


OpenFeign은 스프링 어노테이션으로 구현이 가능하므로 별도의 학습이 필요없다. 

하지만 Open Feign의 기능이 필요해질 수도 있는데, 필요 시에 검색해서 사용하면 된다. 

예를 들어 여러 파라미터를 한번에 넘겨주고 싶은 경우에는 @SpringQueryMap 등이 사용 가능하다. 

또한 스프링은 아래와 같은 풀네임으로 FeignClient의 빈 이름을 설정하는데, 필요하다면 qualifers로 별칭을 지정할 수 있다.
ex) com.mangkyu.openfeign.app.openfeign.ExchangeRateOpenFeign
 
 
만약 `동적인 URI` 로 호출이 필요하다면, 기존에 url에는 아무 값이나 넣고 **URI를 파라미터로** 사용해 호출해주면 된다. 

```java
@FeignClient(name = "ExchangeRateOpenFeign", url = "USE_DYNAMIC_URI")
public interface DynamicUrlOpenFeign {

    @GetMapping
    ExchangeRateResponse call(
            URI uri
            @RequestHeader String apiKey,
            @RequestParam Currency source,
            @RequestParam Currency currencies);

}
```

<br>


## 4. OpenFeign 타임아웃(Timeout), 재시도(Retry), 로깅(Logging) 등 설정하기

OpenFeign의 설정은 `yml` 과 `Java config` 모두로 할 수 있다. 

만약 yml과 Java config 모두 존재한다면 **YML** 의 정보가 Java config를 덮어씌우며 **우선순위** 를 가진다. 

하지만 이러한 우선순위 설정은 바꿔줄 수 있으며, 심지어 `Feign Client 별로 다르게` 가져갈 수도 있다. 

클라이언트별로 설정을 다르게 가져가려면, **@Configuration 이 붙은 설정 클래스를 FeignClient 에 붙여주면** 된다.

이번에는 이러한 기본적인 지식을 바탕으로 타임아웃(Timeout), 재시도(Retry), 로깅(Logging) 등을 설정해보자.
 
<br>

 
### [ 타임아웃(Timeout) 설정하기 ]

OpenFeign이 Defaut로 갖는 tiemout 설정은 다음과 같다.

+ **connectTimeout** : 1000

+ **readTimeout** : 60000


만약 connectionTimeout과 readTimeout을 모두 5초로 변경해서 사용하려면 다음과 같이 설정할 수 있다. 아래와 같이 설정하면 모든 Feign Client들의 타임아웃이 5초로 적용된다.

![image](https://github.com/lielocks/WIL/assets/107406265/271dff11-c7a8-4a6c-9ce7-3e33eb4f9ff3)

<br>


### [ 재시도(Retry) 설정하기 ]

Feign은 기본적으로 **`Retryer.NEVER_RETRY`** 를 등록하여 Retry를 시도하지 않으므로 Retry를 시키려면 추가적인 설정이 필요하다. 

예를 들어 **0.1초의 간격** 으로 시작해 **최대 3초의 간격으로 간격이 점점 증가** 하며, **최대 5번 재시도** 하는 Retryer는 다음과 같이 설정할 수 있다.

다만 Feign 이 제공하는 Retryer 는 IOException 이 발생한 경우에만 처리되므로, 이외의 경우에도 재시도가 필요하다면 Spring-Retry 를 이용하거나 에러디코더 혹은 인터셉터로 직접 구현하는 등의 방법을 사용해야 한다.


```java
@Configuration
@EnableFeignClients("com.mangkyu.openfeign")
class OpenFeignConfig {

    @Bean
    Retryer.Default retryer() {
        // 0.1초의 간격으로 시작해 최대 3초의 간격으로 점점 증가하며, 최대5번 재시도한다.
        return new Retryer.Default(100L, TimeUnit.SECONDS.toMillis(3L), 5);
    }
}
```


재시도는 조심해서 설정되어야 한다.

만약 어떤 서버에서 장애가 발생해서 *이제 막 복구* 가 되었는데,

우리의 서버가 재시도(Retry)를 적용하여 수 많은 동시 요청을 보내게 된다면 **다시 장애를 유발하는 Retry Storm** 을 일으킬 수 있기 때문이다.


<br>


### [ 요청/응답 로깅(Logging) 설정하기 ]

Logger의 이름은 전체 interface 이름이며, Feign Client들마다 만들어진다.

Feign은 남길 로그에 따라 4가지 수준을 제공한다.

+ **NONE** : 로깅하지 않음(기본값)

+ **BASIC** : 요청 메소드와 URI와 응답 상태와 실행시간만 로깅함

+ **HEADERS** : 요청과 응답 헤더와 함께 기본 정보들을 남김

+ **FULL** : 요청과 응답에 대한 헤더와 바디, 메타 데이터를 남김

 
만약 로그 수준을 FULL로 하고 싶다면 다음과 같이 **`Logger.Level`** 을 **빈으로 등록**  해주면 된다.


```java
@Configuration
@EnableFeignClients("com.mangkyu.openfeign")
class OpenFeignConfig {

    @Bean
    Logger.Level feignLoggerLevel() {
        return Logger.Level.FULL;
    }
}
```


여기서 주의 사항이 있는데, **Feign 은 DEBUG 레벨로만** 로그를 남길 수 있다. 

그러므로 반드시 **로그 레벨이 DEBUG** 로 설정이 되어 있어야 한다. 

간단하게 설정 파일에서 다음과 같이 수정해줄 수 있으며, 이것 역시 클라이언트 별로도 적용 가능하다.


```
logging:
    level:
        com.mangkyu.openfeign.app.openfeign: DEBUG
```

 
만약 이를 INFO 레벨로 남기고 싶다면 별도의 로깅 설정이 필요한데, Feign이 제공하는 Logger를 확장하거나 인터셉터를 사용하는 방법이 있다. 

이 링크를 따라 들어가면 Logger를 확장한 예시 코드가 나와 있다. 

참고로 예시 코드는 클라이언트 별로 로그가 남지 않는다는 단점이 있다. 

대신 인터셉터 등을 활용할 수도 있으므로, 충분히 커스터마이징이 가능하다.


<br>


### [ LocalDate, LocalDateTime, LocalTime 등을 위한 설정하기 ]

`주고 받는 데이터 타입` 으로 LocalDate, LocalDateTime, LocalTime 등이 사용된다면 제대로 처리가 되지 않는다. 

그러므로 **DateTimer과 관련된 formatter 추가 설정** 이 필요하다. 

Java8 이상에서는 해당 타입들이 자주 사용되므로 기본적으로 등록해두면 좋다.

```java
@Bean
public FeignFormatterRegistrar dateTimeFormatterRegistrar() {
    return registry -> {
        DateTimeFormatterRegistrar registrar = new DateTimeFormatterRegistrar();
        registrar.setUseIsoFormat(true);
        registrar.registerFormatters(registry);
    };
}
```

<br>

 
또한 `spring boot 버전이나 의존성` 에 따라 **ObjectMapper** 가 해당 타입들을 **Serialize, Deserialize 하기 위한 라이브러리가 존재하지 않을 수도 있다.** 

만약 실패한다면 아래의 2가지 의존성을 추가해주면 된다.

```
implementation 'com.fasterxml.jackson.datatype:jackson-datatype-jdk8'
implementation 'com.fasterxml.jackson.datatype:jackson-datatype-jsr310'
```

<br>


### [ OpenFeign 테스트 설정 ]

OpenFeign은 인터페이스와 어노테이션 기반으로 코드를 구현하는 만큼 테스트 없이는 작성한 코드에 문제가 없는지 확인하기가 어렵다. 

또한 외부 API 호출의 경우 단독으로 사용되기 보다는 다른 로직들과 결합되어 호출이 진행되어 테스트 하기도 까다롭다. 

그러므로 손쉽게 OpenFeign 부분만을 테스트할 수 있다면 매우 유용하다. 

Spring Data Jpa는 @DataJpaTest를 이용해 손쉽게 테스트를 작성할 수 있는데, **OpenFeign 은 테스팅 도구를 지원하지 않으므로** **`@FeignTest 를 직접 만들어주면 된다.`**

먼저 다음과 같이 FeignTest를 위해 필요한 클래스들을 포함하는 **FeignTextContext** 라는 클래스를 만들어준다.

```java
@ImportAutoConfiguration({
        OpenFeignConfig.class,
        CustomPropertiesConfig.class,
        FeignAutoConfiguration.class,
        HttpMessageConvertersAutoConfiguration.class,
})
class FeignTestContext {

}
```

<br>


위에서 **`FeignAutoConfiguration.class`** 와 **`HttpMessageConvertersAutoConfiguration.class`** 는 **반드시 포함** 시켜야 하는 것들이다. 

이것들에 더해 개발 환경에 맞는 클래스들 **`(OpenFeignConfig.class, CustomPropertiesConfig.class)`** 를 추가해주면 된다. 

위에서는 테스트 코드에 `Properties가 사용되어` **`CustomPropertiesConfig`** 라는 직접 구현한 프로퍼티 설정 클래스까지 추가하였다.

그리고 **이러한 설정들을 메타 정보로 사용하는** **`@FeignTest 어노테이션`** 을 만들어주면 된다.


```java
@SpringBootTest(
        classes = {FeignTestContext.class},
        properties = {
                "spring.profiles.active=local"
        })
@Target({ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
public @interface FeignTest {
}
```

<br>


이렇게 만든 어노테이션을 사용하면 다음과 같이 편리하게 테스트 코드를 작성할 수 있다.


```java
@Slf4j
@FeignTest
class ExchangeRateOpenFeignTestWithFeignTest {

    @Autowired
    private ExchangeRateOpenFeign openFeign;
    @Autowired
    private ExchangeRateProperties properties;

    @Test
    void 환율조회() {
        ExchangeRateResponse result = openFeign.call(properties.getKey(), Currency.USD, Currency.KRW);
        assertThat(result).isNotNull();

        log.info("result: {}", result);
    }
}
```

<br>


### [ OpenFeign 빈 Body 설정 ]
이번에 설명한 부분은 OpenFeign 12.0 버전에 수정되었다. 

그러므로 사용중인 OpenFeign의 버전을 확인한 후에 적용하도록 하자.

+ Fixes missing Content-Length header when body is empty by @c00ler in #1778
 
OpenFeign으로 `POST 나 PUT` 등의 요청을 보낼때, **Body가 없을 수 있다.**

그런데 OpenFeign은 Body가 없어도 Content-Length을 자동으로 추가해주지 않는다. 

그리고 나의 경우에는 *Content-Length를 추가해도 다른 서버에서 제대로 처리가 되지 않고,* `411 Length Required 에러` 를 응답받았다. 

관련된 이슈는 다른 사람들에게도 재현되는 것으로 보이고, 대응이 필요하다. 

그래서 Body가 비어있고, GET이나 DELETE가 아닌 경우에는 **반드시 빈 Body를 넣어 요청하도록 Interceptor 를 추가** 하였다. 

만약 Content-Length를 0으로 추가해도 동일하게 411 에러가 발생한다면, 빈 Body를 추가해주도록 하자.


```java
@Configuration
@EnableFeignClients(basePackages = "com.worksmobile.eco.ecoapi")
class FeignConfig {

    @Bean
    public RequestInterceptor requestInterceptor() {
        return requestTemplate -> {
            if(ArrayUtils.isEmpty(requestTemplate.body()) && !isGetOrDelete(requestTemplate)) {
                // body가 비어있는 경우에 요청을 보내면 411 에러가 생김 https://github.com/OpenFeign/feign/issues/1251
                // content-length로 처리가 안되어서 빈 값을 항상 보내주도록 함
                requestTemplate.body("{}");
            }
        };
    }

    private boolean isGetOrDelete(RequestTemplate requestTemplate) {
        return Request.HttpMethod.GET.name().equals(requestTemplate.method())
            || Request.HttpMethod.DELETE.name().equals(requestTemplate.method());
    }
    
    ...
    
}
```

<br>

 
### [ 기타 등등 ]

위에서 설명한 것들 외에도 에러 응답에 따른 후처리를 위한 ErrorDecoder와 같은 것들도 제공하고 있다. 

그러므로 필요에 따라서 적합한 모델을 사용해주면 된다. 


```java
public class CustomErrorDecoder implements ErrorDecoder {
    @Override
    public Exception decode(String methodKey, Response response) {

        switch (response.status()){
            case 400:
                return new BadRequestException();
            case 404:
                return new NotFoundException();
            default:
                return new Exception("Generic error");
        }
    }
}
```

<br>


## 5. OpenFeign 사용 시 주의 사항

### [ 마지막 슬래시(/) 제거 ]

API 요청을 보내야 하는 고객의 URI가 슬래시(/)로 끝났다. 

그래서 해당 URI로 요청을 보내 보니 마지막 슬래시가 없는 URI로 요청을 전송하고 있었다. 

```
요청 URI: http://www.naver.com/test/
ASIS: http://www.naver.com/test
BOBE: http://www.naver.com/test/
```

<br>

 
OpenFeign 소스 코드를 확인해보니 **요청 URI가 슬래시(/)로 끝나는 경우 해당 부분을 제거해주는 로직** 이 RequestTemplate 클래스에 명시적으로 구현되어 있다. 


```
    if (target.endsWith("/")) {
      target = target.substring(0, target.length() - 1);
    }
```

 
그래서 찾아보니 해당 건과 관련된 이슈가 이미 등록된 적이 있었고, 다음과 같은 답변이 달렸다. 

URI 템플릿 명세에 따라 대상을 분할해야 한다고 하는데, 자세히는 이해하지 못했고 여기서 할 책임이 아니라는 것 같다.


<br>

![image](https://github.com/lielocks/WIL/assets/107406265/4fd3a788-2871-439a-99be-4065ee460b1a)


어쨌든 마지막 슬래시가 제거되고 있기 때문에, interceptor 등을 사용해서 별도의 설정을 해주어야 할 듯 하다. 
 
 참고로 Spring은 이거를 어떻게 처리하는지 궁금해서 찾아보니 역시 예상한대로 "/users"와 "/users/"는 `별도의 URI` 로 구분되고 있었다.


<br>


# OpenFeign에 Resilence4J 서킷 브레이커 적용하는 방법과 예시 및 주의사항

## 1. Resilence4J 라이브러리와 구성 요소

[ Resilience4J란? ]

Resilience4J 는 함수형 프로그래밍으로 설계된 **경량(lightweight) 장애 허용(fault tolerance)** 라이브러리로, **서킷브레이커 패턴** 을 위해 사용된다. 

**`fault-tolerance`** 란 *하나 이상의 구성 요소에 문제가 생겨도* ***시스템이 중단없이 계속 작동할 수 있는 시스템*** 을 의미한다. 

Resilience4J를 적용하면 외부 서비스에 장애가 발생하여도 자신의 시스템은 계속 작동할 수 있는 것이다.

참고로 `자바 진영의 서킷 브레이커 라이브러리` 로는 **Hystrix** 도 있다. 

Hystrix는 넷플릭스에서 만든 오픈소스인데, deprecated되었으므로 **Resilience4J** 를 사용하면 된다. 

Hystrix에서도 Resilience4J 사용을 권장하고 있다.

![image](https://github.com/lielocks/WIL/assets/107406265/97d0f4ee-f828-4a7d-a8af-350dbbb3e153)

<br>


### [ Resilience4J의 구성 요소 ]

Resilience4J에는 여러 가지 코어 모듈이 존재하는데, 설정 가능한 부분들이므로 살펴보도록 하자.

+ CircuitBreaker

+ Bulkhead

+ RateLimiter

+ Retry

+ TimeLimiter

…

<br>

**CircuitBreaker 모듈**

CircuitBreaker는 **일반적인 서킷 브레이커의 상태(CLOSED, OPEN, HALF_OPEN)** 에 맞게 **유한 상태 기계(Finite state machine, FSM)를 구현한 모듈** 로, 

아래의 기본 상태에 더해 **`DISABLED`** 와 **`FORCED_OPEN`** 이라는 특수한 상태 2개를 추가하였다.

![image](https://github.com/lielocks/WIL/assets/107406265/c2b8f94f-00e7-4b5b-b5f5-2e48e50053ae)


 
CircuitBreaker 는 호출 결과를 저장하고 집계하기 위해 **슬라이딩 윈도우** 를 사용한다. 

슬라이딩 윈도우는 **마지막 N번의 호출 결과를 기반으로 하는 `count-based sliding window(횟수 기반 슬라이딩 윈도우)`** 와 **마지막 N초의 결과를 기반으로 하는 `time-based sliding window(시간 기반 슬라이딩 윈도우)`** 가 있다.

**느린 호출율과 호출 실패율** 이 `서킷브레이커에 설정된 임계값` 보다 *크거나 같다면* `CLOSED` 에서 `OPEN` 으로 상태가 변경된다. 

모든 예외 발생은 실패로 간주되므로, 특정 예외만 실패로 간주하고 싶다면 예외 목록을 정의해주면 된다. 

그러면 나머지 예외들은 성공으로 간주되며, 혹시나 예외 발생 부분은 결과에서 ignore 하고 싶다면 해당 설정 역시 가능하다. 

참고로 이때 **최소 호출 수** 가 있어서, *일정 호출 수가 기록된 후에* **느린 호출율과 호출 실패율이 계산** 된다.

CircuitBreaker는 **`서킷이 OPEN 상태`** 라면 `CallNotPermittedException` 을 발생시킨다. 

그리고 `특정 시간이 지나 HALF_OPEN 상태` 로 바뀌고 **설정된 수의 요청만을 허용** 하고 나머지는 동일하게 예외를 발생시킨다. 

그리고 동일하게 느린 호출율과 호출 실패율에 따라 서킷의 상태를 OPEN 또는 CLOSED 로 변경한다.

그리고 앞서 설명하였듯 Resilience4J는 **`DISABLED`** 와 **`FORCED_OPEN`** 이라는 2가지 특별한 상태를 지원한다. 

**`DISABLED`** 는 **서킷브레이커를 비활성화하여 항상 요청을 허용하는 상태**이며, 
**`FORCED_OPEN`** 는 **강제로 서킷을 열어두어 항상 요청을 거부** 하는 상태이다. 

해당 상태에서는 `상태 전환을 trigger` 하거나 `서킷브레이커를 reset` 하는 것이다.

참고로 서킷브레이커는 다음과 같이 **Thread-safe** 하다.

+ 서빗브레이커의 상태는 AtomicReference에 저장됨

+ 서킷브레이커는 atomic 기능을 사용하여 부작용없는 함수로 상태를 업데이트함

+ 슬라이딩 윈도우에서 요청을 기록하고 스냅샷을 읽는 작업은 동기적으로 처리됨

<br>


즉, 서킷브레이커는 **원자성이 보장** 되며 *특정 시점에 하나의 쓰레드만이* **서킷브레이커의 상태나 슬라이딩 윈도우를 업데이트** 할 수 있는 것이다. 

그러나 서킷브레이커는 **함수 호출을 동기화하지 않는다.** 

만약 그렇게 하면 이는 `엄청난 성능적인 약점과 병목` 이 될 것이다. 

예를 들어 슬라이딩 윈도우의 크기가 15라고 할지라도, 20개의 쓰레드가 CLOSED 상태에서 호출 여부를 묻는다면 `모든 쓰레드는 요청을 보낼 것` 이다. 

**슬라이딩 윈도우는 동시에 요청가능한 수가 아니며,** 해당 설정은 **`Bulkhead`** 에서 지원하는 것이다.

![image](https://github.com/lielocks/WIL/assets/107406265/a5deb3f5-f460-49d3-82aa-bb1e3d8c70b2)


<br>


**Bulkhead 모듈**

Resilience4j는 Retry를 위한 **인메모리 RetryRegistry** 를 제공해준다. 그 외에 자세한 설정이나 내용은 공식 문서를 참고하도록 하자.

<br>
 

**TimeLimiter 모듈**

CircuitBreaker 모듈처럼 **시간 제한을 위한 인메모리 TimeLimiter** 역시 제공된다. 

TimeLimiter 역시 global 설정과 instance별 설정이 가능하며, 2가지 옵션을 제공해준다.

+ timeoutDuration

+ cancelRunningFuture

Resilience4j는 함수형 기반의 라이브러리인만큼 내부적으로 **`Java의 Future`** 로 요청을 실행한다. 

위의 timeoutDuration 은 Future 의 timemout 으로 설정되며, 주어진 시간이 지났을 때 해당 Future 를 취소시킬지 여부를 설정한다.
 

<br>


## 2. OpenFeign에 Resilience4J 적용하기

### 1. 의존성 추가

가장 먼저 Resilience4J 적용에 필요한 의존성을 추가해주어야 한다.

![image](https://github.com/lielocks/WIL/assets/107406265/e7899ae1-7ca0-4d50-8fcf-1b9142294e2e)
 
<br>

 
### 2. 설정 파일 추가

그 다음으로 Feign에 서킷브레이커 적용을 활성화해야 하는데, `feign.circuitbreak.enabled` 값으로 해당 값을 true로 설정해주면 된다. 

해당 설정은 FeignAutoConfiguration에 의해 적용되며, 참고로 Spring-Cloud-OpenFeign 4.0.0-SNAPSHOT 버전부터는 `spring.cloud.openfeign.circuitbreaker.enabled` 값으로 변경되었다.

![image](https://github.com/lielocks/WIL/assets/107406265/9c7d2e7c-61bd-4aa6-967a-33200fa4a19a)

이후에는 서킷브레이커와 관련된 설정을 넣어야 하는데, circuitBreaker 모듈은 다음의 설정들을 제공해준다.

![image](https://github.com/lielocks/WIL/assets/107406265/36e897cc-2855-4892-8d4f-1b0a7b21e26d)


여기서 circuitBreaker 인스턴스와 timeLimiter 인스턴스만 활용하며, 모두 default 인스턴스만 설정해두었다. 

timeLimiter 인스턴스가 하나인 이유는 모두 동일한 값을 사용하기 때문이며, circuitBreaker 인스턴스가 1개인 이유는 뒤에서 다룰 예정이다. 

위의 설정값은 각자의 환경마다 달라질 수 있으므로 직접 커스터마이징하면 된다. 

TimeLimiter는 아래에서 다시 살펴보도록 예정이다.


```
resilience4j:
  circuitbreaker:
    configs:
      default:
        waitDurationInOpenState: 30s # HALF_OPEN 상태로 빨리 전환되어 장애가 복구 될 수 있도록 기본값(60s)보다 작게 설정
        slowCallRateThreshold: 80 # slowCall 발생 시 서버 스레드 점유로 인해 장애가 생길 수 있으므로 기본값(100)보다 조금 작게 설정
        slowCallDurationThreshold: 5s # 위와 같은 이유로 5초를 slowCall로 판단함. 해당 값은 TimeLimiter의 timeoutDuration보다 작아야 함
        registerHealthIndicator: true
    instances:
      default:
        baseConfig: default
  timelimiter:
    configs:
      default:
        timeoutDuration: 6s # slowCallDurationThreshold보다는 크게 설정되어야 함
        cancelRunningFuture: true
```

**yaml 파일** 을 이용하면 **설정값을 바탕으로 자동 설정(AutoConfig)** 이 되는데, `공통으로 사용할 값들은 configs` 에 정의하고 `개별 인스턴스 설정은 instances` 에 작성해주면 된다. 

Resilience4J는 *Thread-safe와 원자성 보장을 제공* 하는 **ConcurrentHashMap 기반의 인메모리 CircuitBreakerRegistry** 를 제공해준다. 

해당 객체에서 설정 내용이 관리되며, CircuitBreaker 객체를 얻어올 수 있다.


<br>

### 3. recordFailurePredicate 작성

**recordFailurePredicate** 는 *어떤 예외* 를 Fail로 기록할 것인지를 결정하기 위한 Predicate 설정이다. 

해당 클래스에서 true를 반환하면 요청 실패로 기록되며, **실패가 쌓이면 서킷이 OPEN 상태** 로 변경되게 된다. 

OpenFeign 과 연동하는 상황에서는 기본적으로 아래와 같이 작성할 수 있으며, 상황에 따라 커스터마이징해주면 된다.

```java
public class DefaultExceptionRecordFailurePredicate implements Predicate<Throwable> {

    // 반환값이 True면 Fail로 기록됨
    @Override
    public boolean test(Throwable t) {
        // occurs in @CircuitBreaker TimeLimiter
        if (t instanceof TimeoutException) {
            return true;
        }

        // occurs in @OpenFeign
        if (t instanceof RetryableException) {
            return true;
        }

        return t instanceof FeignException.FeignServerException;
    }

}
```

<br>


만약 timeLimiter에 설정한 연결 시간을 초과하거나 커넥션에 실패했다면 `TimeoutException` 이 발생하는데, 해당 경우에는 **서킷을 열어서 요청을 차단해야 하므로 `true` 를 반환** 하도록 하였다. 

또한 `RetryableException` 은 **Feign 에서 던지는 Retry 가능한 예외** 인데, 해당 예외도 true로 반환하도록 하였다. 

이는 상황에 따라 달라질 수 있으므로 false로 반환이 필요하다면 수정해주도록 하자. 

그리고 그 외에 `FeignException 중에서 FeignServerException` 이라면 true를 반환하도록 되어있다.

해당 Predicate 클래스를 적용하려면 *yaml 설정 파일에 recordFailurePredicate 내용을 추가* 해주어야 한다.


```
resilience4j:
  circuitbreaker:
    configs:
      default:
        waitDurationInOpenState: 30s # HALF_OPEN 상태로 빨리 전환되어 장애가 복구 될 수 있도록 기본값(60s)보다 작게 설정
        slowCallRateThreshold: 80 # slowCall 발생 시 서버 스레드 점유로 인해 장애가 생길 수 있으므로 기본값(100)보다 조금 작게 설정
        slowCallDurationThreshold: 5s # 위와 같은 이유로 5초를 slowCall로 판단함. 해당 값은 TimeLimiter의 timeoutDuration보다 작아야 함
        registerHealthIndicator: true
        recordFailurePredicate: com.mangkyu.openfeign.app.openfeign.circuit.DefaultExceptionRecordFailurePredicate
    instances:
      default:
        baseConfig: default
  timelimiter:
    configs:
      default:
        timeoutDuration: 6s # slowCallDurationThreshold보다는 크게 설정되어야 함
        cancelRunningFuture: true
```

<br>


### 4. CircuitBreakerNameResolver 작성

CircuitBreaker 인스턴스는 여러 개로 관리될 수 있다. 

예를 들어 배달앱이라면 “관리자 서버”, “주문 서버” 등이 있고, 각각을 FeignClient로 호출할 것이다. 

서로 다른 서버들이 **`별도의 CircuitBreaker 인스턴스로 관리되지 않으면`** **“관리자 서버”만 문제있는 상황에서 “주문 서버”로의 요청도 막힐 수 있다.**

그래서 이를 처리하기 위한 `CircuitBreaker 인스턴스` 를 지정해주어야 하는데, OpenFeign 은 **해당 FeignClient 가 어떤 인스턴스를 적용할지 식별** 할 수 있는 **`CircuitBreakerNameResolver 인터페이스`** 를 제공해준다.

해당 인터페이스를 구현하지 않으면 기본적으로 FeignClient의 이름과 메소드를 조합하여 사용하는 DefaultCircuitBreakerNameResolver가 사용된다. 

만약 숫자와 알파벳만으로 설정을 하고 싶다면 alphanumeric-ids 옵션을 주면 된다. 

하지만 이번에는 **Host를 기준으로 적용하도록 직접 Resolver 를 구현** 하였고, 다음과 같다.

참고로 이때 CircuitBreaker 인스턴스를 찾지 못한다면 인메모리에 새로운 인스턴스를 생성하게 된다.

따라서 앞에서 했던 설정에서 default 인스턴스 외에는 별도로 미리 생성해두지 않은 것이다.


```java
@Component
@Slf4j
public class HostNameCircuitBreakerNameResolver implements CircuitBreakerNameResolver {

    @Override
    public String resolveCircuitBreakerName(String feignClientName, Target<?> target, Method method) {
        String url = target.url();
        try {
            return new URL(url).getHost();
        } catch (MalformedURLException e) {
            log.error("MalformedURLException is ouccered: {}", url);
            return "default";
        }
    }

}
```

<br>


### 5. CallNotPermittedException 예외 처리

서킷이 **`OPEN 상태`** 로 바뀌면 **더 이상 요청이 전달되지 않는다.** 

대신 **요청을 차단** 하고 바로 `CallNotPermittedException` 예외를 발생시킨다. 

그러므로 각각의 예외 처리 방법에 맞게 CallNotPermittedException 예외를 처리해주어야 한다.

일반적으로 **ControllerAdvice** 를 사용하고 있을 것인데, 그렇다면 해당 클래스에 아래의 내용을 추가 및 구현하면 된다.


```java
@ExceptionHandler(CallNotPermittedException.class)
    public ResponseEntity<?> handleCallNotPermittedException(CallNotPermittedException e) {
        return ResponseEntity.internalServerError()
                .body(Collections.singletonMap("code", "InternalServerError"));
}
```

 
이후에는 테스트를 해주면 되는데, **CircuitBreakerRegistry를 주입받고 다음과 같은 API 를 작성** 해서 사용하면 된다.


```java
@GetMapping("/circuit/close")
public ResponseEntity<Void> close(@RequestParam String name) {
    circuitBreakerRegistry.circuitBreaker(name)
            .transitionToClosedState();
    return ResponseEntity.ok().build();
}

@GetMapping("/circuit/open")
public ResponseEntity<Void> open(@RequestParam String name) {
    circuitBreakerRegistry.circuitBreaker(name)
            .transitionToOpenState();
    return ResponseEntity.ok().build();
}

@GetMapping("/circuit/status")
public ResponseEntity<CircuitBreaker.State> status(@RequestParam String name) {
    CircuitBreaker.State state = circuitBreakerRegistry.circuitBreaker(name)
            .getState();
    return ResponseEntity.ok(state);
}

@GetMapping("/circuit/all")
public ResponseEntity<Void> all() {
    Seq<CircuitBreaker> circuitBreakers = circuitBreakerRegistry.getAllCircuitBreakers();
    for (CircuitBreaker circuitBreaker : circuitBreakers) {
        log.error("circuitName={}, state={}", circuitBreaker.getName(), circuitBreaker.getState());
    }
    return ResponseEntity.ok().build();
}
```
 
 
<br>


### 6. Fallback 처리

요청이 실패하였을때 기본값 반환 등으로 Fallback 처리가 필요할 수 있다. 

그런 경우에는 Open Feign이 제공하는 Fallback 기능을 사용하면 된다. 

Fallback은 메소드 구현 또는 팩토리 구현 등으로 처리할 수 있는데, 관련 내용은 공식 문서에 담겨져 있다. 


<br>


## 2. OpenFeign에 Resilience4J 적용 시에 주의 사항

+ Fallback이 없는 경우의 에러 처리

+ TimeLimiter의 Timeout 설정

<br>

 
### [ Fallback이 없는 경우의 에러 처리 ]

Open Feign은 Spring Cloud가 제공하는 라이브러리이며, Open Feign이 서킷 브레이커를 적용하는 방법 역시 Spring Cloud 가 제공하는 **Spring Cloud CircuitBreaker** 를 기반으로 한다.

Spring Cloud CircuitBreaker는 일관된 서킷 브레이커 적용을 위한 interface 를 제공하는데, 해당 인터페이스에서 **Fallback 이 없는 경우라면 예외를 반드시 `NoFallbackAvailableException` 으로 감싸서 반환하도록 하고 있다.**

물론 일반적으로 사용되는 예외 처리기인 @ExceptionHandler 는 Exception 의 cause 가 있을 경우에 cause로 에러 처리를 해주고 있어서, 큰 문제가 없을 수 있다. 

하지만 그럼에도 불구하고 다음과 같이 실제 **`cause 에 해당하는 에러를 출력`** 해주는 것이 좋다.


```java
@ExceptionHandler(NoFallbackAvailableException.class)
public ResponseEntity<Object> noFallbackAvailableException(HttpServletRequest request, NoFallbackAvailableException e) {
    log.warn("uri: {}, exception : ", request.getRequestURI(), e.getCause());
    return handleExceptionInternal(CommonErrorCode.INTERNAL_SERVER_ERROR);
}
```

<br>


### [ TimeLimiter의 Timeout 설정 ]

위의 yaml 설정에서 작성했던 **`TimeLimiter의 timeout`** 은 **클라이언트로 작업을 위임하는 시간** 이라고 보면 되는데, 그래서 해당 설정 값은 상당히 중요하다. 

Resilience4J는 함수형 기반의 라이브러리인만큼 내부적으로 **`java.concurrenct`** 패키지의 도구들을 이용하는데, **해당 값은 Java Future 객체의 get에 전달** 된다.

예를 들어 timeout 값이 3초로 되어 있고, API 응답이 4초가 걸린다고 하자. 그러면 아래와 같은 상황이 발생할 수 있다.

1. 작업 처리 시간을 3초로 설정함(TimeLimiter)

2. 해당 요청 처리가 일시적으로 4초로 지연됨

3. 작업 처리 시간이 만료되어 Fallback 처리 또는 예외 발생

4. 작업 처리 시간이 만료되었으므로 Retry 등도 처리하지 않음


<br>

 
**TimeLimiter의 timeout은 전체 작업 처리 시간의 timeout** 에 해당한다. 

그러므로 위와 같은 경우라면 작업 처리 시간이 만료되었으므로 Retry 등도 시도하지 않을 것이다. 

이러한 상황이 생기지 않도록 timeout 값은 신중히 설정되어야 한다.

기본적으로 `TimeLimiter 의 timeout 값` 은 `CircuitBreaker의 slowCallDurationThreshold와 OpenFeign의 connectionTimeout, readTimeout` 보다는 **크게** 설정되어야 한다. 

그래야 응답이 조금 오래걸리는 상황에서도 정상적으로 처리가 가능하다. 

그 외에 slowCall 에 대해서도 재시도를 고려한다면 조금 더 큰 값으로 설정해줄 수도 있을 것이다.


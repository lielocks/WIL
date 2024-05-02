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




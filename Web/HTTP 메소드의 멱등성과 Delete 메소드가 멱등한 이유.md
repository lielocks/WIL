HTTP 메소드의 속성으로 *안전* , *멱등* , *캐시가능* 이 있는데, 

이번에는 그 중에서 멱등이 무엇이고 **`Patch` 가 멱등하지 않은 이유와 `Delete` 가 멱등한 이유** 에 대해서 살펴보도록 하겠습니다.
 

<br>


## 1. HTTP 메소드의 멱등성(Idempotence)이란?

*HTTP 메소드의 속성* 중에 `안전(Safe), 캐시(Cacheable)과 함께 멱등성(Idempotence)` 이 있다. 

RFC 7231 스펙 문서에 보면 **멱등성** 이란 ***“여러 번 동일한 요청을 보냈을 때, 서버에 미치는 의도된 영향이 동일한 경우”*** 라고 정의되어 있다. 

그리고 Safe 요청들(GET, HEAD 등) 에 더해 PUT, DELETE 가 멱등한 HTTP 메소드라고 나와있다.

![image](https://github.com/lielocks/WIL/assets/107406265/7bff6d8b-a68c-47f1-ba16-b48fdba790bb)


<br>


### [HTTP 메서드의 멱등성이 필요한 이유]

HTTP 멱등성이 필요한 이유는 **`요청의 재시도`** 때문이다. 

만약 HTTP 요청이 멱등하다면, *요청이 실패한 경우에 주저없이 재시도 요청* 을 하면 된다. 

하지만 만약 HTTP 요청이 멱등하지 않다면, *리소스가 이미 처리되었는데 중복 요청* 을 보낼 수 있다. 

예를 들어 이미 결제된 요청인데, 중간에 연결이 끊겨서 다시 결제 요청을 보내서 문제를 일으킬 수 있는 것이다. 

그래서 client 는 무지성으로 재시도 요청을 보내면 안되고, 멱등성을 고려하여 재시도 요청을 해야 한다.
 

<br>


## 2. HTTP 메소드의 멱등 여부

![image](https://github.com/lielocks/WIL/assets/107406265/94b4eb56-37db-480e-9d26-d151da7c3e1a)


<br>


### [GET 요청 시에 장애가 발생한 경우]

예를 들어 GET 요청을 여러번 했더니 로그가 지나치게 많이 저장되어 문제가 발생하였다고 하자. 

비록 서버에 문제가 생겼지만 해당 문제는 HTTP 메소드의 구현에 따른 사이드이펙트이며, 장애는 서버에서 발생하였으며 리소스에는 영향이 없으므로 GET 요청은 멱등한 것이다.

안전(Safe)와 마찬가지로 멱등성은 오직 사용자 요청에 의한 리소스 만을 고려하며, 구현에 따른 부작용은 고려하지 않는다. 

또한 재요청 중간에 리소스가 변경된 것 역시도 고려하지 않는다. 

예를 들어 요청이 아래와 같은 순서로 들어왔다고 하자. 

1번 요청과 3번 요청의 결과는 다르지만, 이는 외부 요인에 의해 변경되었으므로 고려 대상이 아니다.

1. User1: GET → name: MangKyu, age:20

2. User2: PATCH → name: MangKyu, age:30

3. User1: GET → name: MangKyu, age:30


<br>


### [PATCH 메서드가 멱등하지 않은 이유]

예를 들어 name에 해당하는 값을 변경하고자 할 때 PATCH를 사용할 수 있다. 

예를 들어 우리는 아래와 같이 요청을 N번 날려도 항상 동일한 결과를 응답받게 된다. 

1. PATCH → {name: ”MangKyu”}

2. PATCH → {name: ”MangKyu”}


<br>


그래서 PATCH를 멱등하다고 착각할 수 있는데, 문제는 PATCH 가 보다 범용적으로 사용된다는 것이다. 

예를 들어 “name” 필드를 보내면 `값을 추가(append)` 하는 요청 역시 PATCH 가 사용된다. 

그러면 *PATCH 요청* 에 의한 **결과는 매번 달라지게 될 것이다.** 

그러므로 PATCH 메소드는 **항상 멱등** 하다고 볼 수 없다.

1. PATCH → name: [”MangKyu”]

2. PATCH → name: [”MangKyu”, ”MangKyu”]

3. PATCH → name: [”MangKyu”, ”MangKyu”, ”MangKyu”]


<br>


### [DELETE 메소드가 멱등한 이유]

예를 들어 자원이 있는 상태에서 우리가 다음과 같이 사용자 삭제 요청을 보냈다고 하자. 

처음에는 성공 응답(200)을 받았지만, 동일한 요청을 보냈더니 에러 응답(404)을 받은 것이다.

1. DELETE → 200 OK

2. DELETE → 404 NOT FOUND

 
DELETE 를 사용하면 클라이언트가 받는 응답 상태 코드가 달라질 수 있음에도 불구하고 **DELETE 메소드는 멱등하다.** 

왜냐하면 **`멱등성의 기준이 “상태 코드”가 아니기 때문이다.`** 

앞서 살펴본대로 공식 문서의 설명에 따르면 멱등성은 ***“서버에 미치는 의도된 영향이 동일한가?”*** 이다. 

DELETE 의 목적은 *리소스를 삭제하여 서버에 리소스가 없도록 만드는 것이고,* **DELETE 를 여러 번 호출해도 응답 상태와 무관하게 리소스가 없는 상태를 유지하도록 한다.** 

그러므로 HTTP DELETE 메소드는 멱등한 것이다.

결국 멱등성은 **`리소스 관점`** 에서 생각하는 것이 중요하다. 

> ***여러 번 요청해도 리소스가 동일하다면 멱등한 것으로 봐도 된다.***
 

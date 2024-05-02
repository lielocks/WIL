## 1. 트랜잭션의 시작과 종료 및 전파 속성 (Transaction Propagation)

[트랜잭션의 시작과 종료]

트랜잭션은 시작 지점과 끝나는 지점이 존재한다. 

시작하는 방법은 1가지이지만 끝나는 방법은 2가지이다. 

트랜잭션이 끝나는 방법에는 **모든 작업을 확정짓는 `커밋(commit)`** 과 **모든 작업을 무효화하는 `롤백(rollback)`** 이 있다.
 

<br>


### 트랜잭션의 시작

트랜잭션은 **하나의 Connection 을 가져와 사용하다가 닫는 사이** 에서 일어난다.

**트랜잭션의 시작과 종료는 Connectino 객체를 통해 이뤄지기 때문** 이다.

`JDBC` 의 기본 설정은 DB 작업을 수행한 직후에 바로 커밋을 하는 `자동 커밋 옵션이 활성화` 되어 있다. 

그러므로 *JDBC에서 트랜잭션을 시작* 하려면 **`자동 커밋 옵션을 false`** 로 해주어야 하는데, 그러면 새로운 트랜잭션이 시작되게 만들 수 있다.

```java
public void executeQuery() throws SQLException {
    Connection connection = dataSource.getConnection();
    connection.setAutoCommit(false);
    // 트랜잭션 시작
    
    ...
}
```

<br>


스프링을 이용하면 **내부적으로 커넥션을 갖고 있는 추상화된 `트랜잭션 매니저`** 를 이용하게 된다. 

이 때에는 다음과 같이 트랜잭션을 시작하게 되고, 자동 커밋 옵션을 변경하는 등의 작업은 Transaction Manager 내부에서 진행된다.


```java
public void executeQuery() throws SQLException {
    TransactionStatus status = transactionManager.getTransaction(new DefaultTransactionDefinition());
    // 트랜잭션 시작
    
    ...
}
```

<br>


### 트랜잭션의 종료

하나의 트랜잭션이 사작되면 **commit() or rollback() 이 호출될때까지가 하나의 transaction** 으로 묶인다.

이렇게 *setAutoCommit(false) 로 transaction 의 시작을 선언* 하고 *commit() or rollback() 으로 transaction 을 종료하는 작업* 을 **`transaction 의 경계 설정`** 이라고 한다.

**Transaction 의 경계** 는 **`하나의 Connection`** 을 통해 진행되므로 **`transaction 의 경계` 는 하나의 connection 이 만들어지고 닫히는 범위 안에 존재한다.**

```java
public void executeQuery() throws SQLException {
    TransactionStatus status = transactionManager.getTransaction(new DefaultTransactionDefinition());
    // 트랜잭션 시작
    
    try {
        // 쿼리 실행
        ...
            
        transactionManager.commit(status);
    } catch (Exception e) {
        transactionManager.rollback(status);
    }
}
```

<br>


### [ 트랜잭션 전파 속성(Transaction Propagation)이란? ]

Spring 이 제공하는 **`선언적 트랜잭션(트랜잭션 어노테이션, @Transactional)` 의 장점** 중 하나는 ***여러 transaction 을 묶어서 커다란 하나의 transaction 경계를 만들 수 있다는 점*** 이다.

작업을 하다보면 `기존에 transaction 이 진행중` 일때 `추가적인 transaction 을 진행` 해야 하는 경우가 있다.

이미 transaction 이 진행중 일때 transaction 진행을 어떻게 할지 결정하는 것이 **`전파 속성 (Propagation)`** 이다.

전파 속성에 따라 기존의 transaction 에 참여할 수도, 별도의 transaction 으로 진행할수도, error 를 발생시키는 등 여러 선택을 할 수 있다.

이렇게 하나의 transaction 이 다른 transaction 을 만나는 상황을 그림으로 나타낸 것이다.

![image](https://github.com/lielocks/WIL/assets/107406265/6560f9df-8d30-46bb-9a37-fa02d2a16a90)


<br>


### [ 물리 트랜잭션과 논리 트랜잭션 ]

**Transaction** 은 *데이터베이스에서 제공하는 기술* 이므로 **`Connection 객체`** 를 통해 처리한다. 

그래서 `1개의 트랜잭션을 사용한다` 는 것은 `하나의 connection 객체를 사용한다` 는 것이고, 
실제 **데이터베이스의 트랜잭션을 사용한다** 는 점에서 **`물리 트랜잭션`** 이라고도 한다.

앞서 설명하였듯 `트랜잭션 전파 속성` 에 따라서 *외부 트랜잭션과 내부 트랜잭션이 동일한 트랜잭션을 사용* 할 수도 있다. 

하지만 `spring 의 입장` 에서는 **Transaction Manager 를 통해 트랜잭션을 처리하는 곳** 이 `2군데` 이다. 

그래서 `실제 DB 트랜잭션` 과 `spring 이 처리하는 트랜잭션 영역을 구분` 하기 위해 spring 은 **`논리 트랜잭션`** 이라는 개념을 추가하였다. 

예를 들어 다음의 그림은 `외부 트랜잭션` 과 `내부 트랜잭션` 이 **1개의 물리 트랜잭션(커넥션)** 을 사용하는 경우이다.

![image](https://github.com/lielocks/WIL/assets/107406265/8f67becf-b481-4ec1-bdc0-c3fba166c970)


<br>


이 경우에는 `2개의 트랜잭션 범위가 존재` 하기 때문에 **개별 논리 트랜잭션이 존재** 하지만, 실제로는 **1개의 물리 트랜잭션이 사용된다.** 

만약 `트랜잭션 전파 없이` **1개의 트랜잭션만 사용** 되면 **`물리 트랜잭션만 존재`** 하고, `트랜잭션 전파가 사용될 때` **`논리 트랜잭션 개념`** 이 사용된다. 

이러한 물리 트랜잭션과 논리 트랜잭션을 정리하면 다음과 같다.

+ 물리 트랜잭션 : 실제 DB 에 적용되는 transaction 으로, connection 을 통해 commit / rollback 하는 단위

+ 논리 트랜잭션 : Spring 이 Transaction Manager 를 통해 트랜잭션을 처리하는 단위

<br>


*기존의 트랜잭션이 진행중일 때* `또 다른 트랜잭션이 사용` 되면 복잡한 상황이 발생한다. 

Spring 은 논리 트랜잭션이라는 개념을 도입함으로써 상황에 대한 설명을 쉽게 만들고, 다음과 같은 단순한 원칙을 세울수 있었다.

+ **모든 논리 트랜잭션이 commit 되어야** ***물리 트랜잭션이 commit 됨***

+ `하나의 논리 트랜잭션이라도 rollback 되면` **물리 트랜잭션은 rollback 됨**
 
 
논리 트랜잭션을 기반으로 단순한 원칙을 세움으로써 2개 이상의 트랜잭션을 다루는 경우에 대한 이해가 상당히 쉬워진다. 

실제로 트랜잭션들이 마주하는 상황에서 어떠한 전파 속성들이 있는지 살펴보도록 하자.
 
 
<br>


## 2. 다양한 스프링의 트랜잭션 전파 속성

### [ REQUIRED 속성과 REQUIRES_NEW 속성 ]

Spring 에는 7가지 전파 속성이 존재하는데, **REQUIRED** 와 **REQUIRES_NEW** 를 바탕으로 어떻게 진행되는지 살펴보도록 하자.  

**REQUIRED** 와 **REQUIRES_NEW** 를 이해하면 나머지는 응용이 가능하므로, 두 케이스만 자세히 살펴보도록 하자.
 
 
<br>


### REQUIRED

REQUIRED 는 spring 이 제공하는 기본적인(DEFAULT) 전파 속성으로, **기본적으로 `2개의 논리 transaction` 을 묶어 `1개의 물리 트랜잭션` 을 사용** 하는 것이다.

앞선 예시로 살펴본 경우가 REQUIRED 에 해당하며, **내부 트랜잭션은 기존에 존재하는 외부 트랜잭션에 참여** 하게 된다.

![image](https://github.com/lielocks/WIL/assets/107406265/e3fd8e76-6f7e-4c49-9cf0-f538c901f7c1)

<br>

여기서 `참여한다` 는 것은 **외부 트랜잭션을 그대로 이어간다** 는 뜻이며, **`외부 트랜잭션의 범위`** 가 **내부까지 확장** 되는 것이다.

그러므로 ***내부 트랜잭션은 새로운 물리 트랜잭션을 사용하지 않는다.*** 

하지만 `Transaction Manager 에 의해 관리되는 논리 트랜잭션` 이 존재하므로 **`commit`** 은 내부 1회, 외부 1회해서 **총 2회** 실행된다.

물론 `내부 트랜잭션` 은 `논리 트랜잭션` 이기 때문에 commit 을 호출해도 **즉시 commit 되지는 않고,** **외부 트랜잭션이 최종적으로 commit 될 때 실제로 commit** 이 된다. 

Rollback 역시 비슷한데, `내부 트랜잭션` 에서 rollback 을 하여도 **즉시 rollback 되지 않는다.**

`물리 트랜잭션` 이 rollback 될 때 실제 rollback 이 처리되는데, `논리 트랜잭션들 중에서 1개라도 rollback` 되었다면 **rollback** 된다. 

**`물리 트랜잭션`** 은 **실제 Connection 에 rollback / commit 을 호출** 하는 것이므로 **해당 트랜잭션이 끝나는 것이다.**

<br>


### REQUIRES_NEW

REQUIRES_NEW 는 `외부 트랜잭션과 내부 트랜잭션` 을 **완전히 분리** 하는 전파 속성이다.

그래서 **2개의 물리 트랜잭션** 이 사용되며, `각각 트랜잭션` 별로 **commit 과 rollback** 이 수행된다.

이를 그림으로 표현하면 다음과 같다.

![image](https://github.com/lielocks/WIL/assets/107406265/35381602-9142-42d6-a32d-91ecfd9e5b9b)

<br>

두 개는 서로 다른 물리 트랜잭션이므로, **`내부 트랜잭션 rollback`** 이 **외부 트랜잭션 rollback 에 영향을 주지 않는다.**

그러므로 내부 트랜잭션의 rollback 호출은 실제 connection 에 rollback 을 호출하는 것이므로 transaction 이 끝나게 된다.

`서로 다른 물리 transaction 을 별도로 가진다는 것` 은 **각각의 DB Connection** 이 사용된다는 것이다.

즉, `1개의 HTTP 요청` 에 대해 `2개의 connection` 이 사용되는 것이다. 

내부 트랜잭션이 처리 중일때는 꺼내진 외부 트랜잭션이 대기하는데, 이는 DB connection 을 고갈시킬 수 있다.

그러므로 조심해서 사용해야 하며, 만약 REQURES_NEW 없이 해결 가능하다면 대안책(별도의 클래스를 두기 등)을 사용하는 것이 좋다.

REQUIRED와 REQUIRES_NEW를 이해했다면 나머지는 응용이므로, 간단히 어떻게 동작하는지 살펴보도록 하자.

<br>

### [ 다양한 트랜잭션 전파 속성 ]

앞서 설명하였듯 스프링은 총 7가지 전파 속성을 제공한다. 각각에 대해 요약해서 정리하면 다음과 같다.

+ REQUIRED

+ SUPPORTS

+ MANDATORY

+ REQUIRES_NEW

+ NOT_SUPPORTED

+ NEVER

+ NESTED

<br>


### REQUIRED

+ 의미 : **트랜잭션이 필요함 (없으면 새로 만듬)**

+ 기존 트랜잭션 없음 : 새로운 트랜잭션을 생성함

+ 기존 트랜잭션이 있음 : 기존 트랜잭션에 참여함

REQUIRED 는 디폴트 속성으로써 모든 Transaction Manager 가 지원하는 속성이다. 

별도의 설정이 없다면 REQUIRED 로 트랜잭션이 진행된다.

<br>

### SUPPORTS

+ 의미 : 트랜잭션이 있으면 지원함 **(트랜잭션이 없어도 됨)**

+ 기존 트랜잭션 없음 : 트랜잭션 없이 진행함

+ 기존 트랜잭션이 있음 : 기존 트랜잭션에 참여함

<br>


### MANDATORY

+ 의미: 트랜잭션이 **의무** 임 (트랜잭션이 반드시 필요함)

+ 기존 트랜잭션 없음: `IllegalTransactionStateException 예외` 발생

+ 기존 트랜잭션이 있음: 기존 트랜잭션에 참여함

<br>


### REQUIRES_NEW

+ 의미 : **항상 새로운** 트랜잭션이 필요함

+ 기존 트랜잭션 없음 : 새로운 트랜잭션을 생성함

+ 기존 트랜잭션이 있음 : **기존 트랜잭션을 보류** 시키고 새로운 트랜잭션을 **생성함**

<br>


### NOT_SUPPORTED

+ 의미: 트랜잭션을 지원하지 않음 **(트랜잭션 없이 진행함)**

+ 기존 트랜잭션 없음: 트랜잭션 없이 진행함

+ 기존 트랜잭션이 있음: 기존 트랜잭션을 **보류** 시키고 트랜잭션 **없이 진행함**


<br>


### NEVER

+ 의미: **트랜잭션을 사용하지 않음 (기존 트랜잭션도 허용하지 않음)**

+ 기존 트랜잭션 없음: 트랜잭션 없이 진행

+ 기존 트랜잭션이 있음: `IllegalTransactionStateException 예외` 발생


<br>

### NESTED

+ 의미: **중첩(자식)** 트랜잭션 을 생성함

+ 기존 트랜잭션 없음: 새로운 트랜잭션을 생성함

+ 기존 트랜잭션이 있음: **중첩** 트랜잭션을 만듬


**NESTED** 는 **이미 진행중인 트랜잭션에 중첩(자식) 트랜잭션을 만드는 것** 으로, `독립적인 트랜잭션을 만드는 REQUIRES_NEW` 와 **다르다.** 

`NESTED 에 의한 중첩 트랜잭션` 은 **부모 트랜잭션의 영향(commit 과 rollback)을 받지만,** `중첩 트랜잭션` 이 **외부에 영향을 주지는 않는다.**

즉, `중첩 트랜잭션이 rollback 되어도 외부 트랜잭션은 commit 이 가능` 하지만 `외부 트랜잭션이 rollback 되면 중첩 트랜잭션은 함께 rollback` 되는 것이다. 

NESTED 는 JDBC의 savepoint 기능을 사용하는데, DB Driver 가 이를 지원하는지 확인이 필요하며 JPA에서 사용이 불가능하다.

<br>


## 3. 트랜잭션의 전파 속성 요약

![image](https://github.com/lielocks/WIL/assets/107406265/3af6acc4-e476-4918-b3e9-2da335ba2b66)





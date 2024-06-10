# 2022.09.16 EntityManager Jpa 활용 영속성 #

### Entity Manager Factory 와 Entity Manager

+ JPA 는 thread 가 하나 생성될 때 마다(매 요청마다) EntityManagerFactory 에서 EntityManager 를 생성한다.
+ **`EntityManager`** 는 내부적으로 **DB Connection Pool 을 사용해서 DB 에 붙는다.**

![image](https://github.com/lielocks/WIL/assets/107406265/ea6f3379-8a89-4925-95ca-8fdc0a05ab69)


### Persistence Context 영속성 컨텍스트
+ 영속성 컨텍스트는 JPA를 이해하는데 가장 중요한 용어이다.
  + ***Entity 를 영구 저장하는 환경*** 이라는 뜻
  + EntityManager.persist(entity);
  + 앞의 예제에서 persist() 로 DB 에 객체를 저장하는 것이라고 배웠지만, 실제로는 DB 에 저장하는 것이 아니라, 영속성 컨텍스트를 통해서 **entity 를 영속화** 한다는 뜻이다.
  + 정확히 말하면 **persist() 시점에는 Persistence Context** 에 저장한다. **`DB 저장은 이후`** 이다.

+ Entity Manager? Persistence Context?
  + 영속성 컨텍스트는 논리적인 개념이다. 눈에 보이지 않는다. Entity Manager 를 통해서 ***Persistence Context 에 접근한다.***
   ![image](https://github.com/lielocks/WIL/assets/107406265/8121a01c-e437-4630-96ec-720a9edd864c)
  + Spring 에서 Entity Manager를 주입 받아서 쓰면, 같은 Transaction 의 범위에 있는 EntityManager 는 동일 Persistence Context 에 접근한다.

<br>

### Entity 의 생명 주기

![image](https://github.com/lielocks/WIL/assets/107406265/786276c1-814c-4490-bdad-0828145f364c)

+ **비영속 (New / Transient)**
  + 영속성 컨텍스트와 전혀 관계가 없는 상태 // 객체를 **`생성만`** 한 상태 (비영속)

  ```java
  Member member = new Member();
  member.setId("member1");
  member.setUsername("회원1");
  ```

<br>

+ **영속 (Managed)**
  + 영속성 컨텍스트에 **저장된** 상태
  + Entity 가 영속성 컨텍스트에 의해 관리된다. 이때 DB 에 저장 되지 않는다. ***영속 상태가 된다고 DB 에 query 가 날라가지 않는다.***
  + Transaction 의 **`commit`** 시점에 영속성 컨텍스트에 있는 정보들이 DB 에 쿼리로 날라간다. // 객체를 생성한 상태 (비영속)
    ```java
    Member member = new Member();
    member.setId("member1");
    member.setUsername("회원1");
    ​EntityManager em = emf.createEntityManager();
    em.getTransaction().begin();​// 객체를 저장한 상태(영속)
    em.persist(member);
    ```

<br>

+ **준영속(detached)**
  + 영속성 컨텍스트에 **저장되었다가 분리된** 상태 // Member Entity 를 영속성 컨텍스트에서 분리, 준영속 상태
  ```java
  em.detach(member);
  ```
  
<br>

+ **삭제(removed)**
  + 삭제된 상태 DB 에서도 날린다. // 객체를 삭제한 상태
  ```java
  em.remove(member);
  ```

<br>

## Persistence Context 의 이점

Application 과 DB 사이 왜 중간에 영속성 컨텍스트가 있냐. 왜 필요하냐. 아래와 같은 개념들이 가능하려면, 영속성 컨텍스트가 존재해야 한다.

<br>

### 1차 캐시

![image](https://github.com/lielocks/WIL/assets/107406265/59622b67-0644-4a32-8661-07701a49f7ab)

+ Persistence Context(Entity Manager) 에는 내부에 1차 캐시가 존재한다.
+ Entity 를 Persistence Context 에 저장하는 순간 -> 1차 캐시에 **`key`** : @Id 로 선언한 필드 값 **`value`** : 해당 entity 자체로 캐시에 저장된다.
+ 1차 캐시가 있으면 어떤 이점이 있을까?
  + 조회할 때 이점이 생긴다.
    + `find()` 가 일어나는 순간, Entity Manager 내부의 1차 캐시를 먼저 찾는다.
    + 1차 캐시에 entity 가 존재하면 바로 반환한다. DB 에 들리지 않는다.
  + 주의! 1차 캐시는 글로벌하지 않다. 해당 thread 하나가 시작할때부터 끝날때까지 잠깐 쓰는거다.
  + *공유하지 않는 캐시* 가 100 명 한테 요청 100 개 오면, Entity Manager 100 개 생기고 1차 캐시도 100 개 생긴다.
  + Thread 종료되면, 그때 다 사라진다. Transaction 의 범위 안에서만 사용하는 굉장히 짧은 cache layer 이다. *전체에서 쓰는 글로벌 캐시는 2차 캐시라고 한다.*


```java
Member member = new Member();
member.setId("member1");
member.setUsername("회원1");
​...

​// 1차 캐시에 저장됨
em.persist(member);​

// 1차 캐시에서 조회
Member findMember = em.find(Member.class, "Member1");
```

+ 1차 캐시에 데이터가 없다면?
  + DB 에서 조회 한다.
  + member2 를 조회하는데 1차 캐시에 해당 entity 가 없다. 그러면 DB 에서 꺼내온다.
  + 그리고 1차 캐시에 저장한다. 그 후에 member2 를 반환한다.
  + 다시 member2 를 조회하면, 1차 캐시에 있는 member2 가 반환된다.
  + SELECT 쿼리가 안나간다. **한 Transaction 내에서**
 
<br>

### 동일성(identity) 보장

+ 영속 엔티티의 동일성을 보장한다.
+ *1차 캐시 덕분에* member1 을 두번 조회해도 다를 객체가 아니다. **같은 레퍼런스** 가 된다.
+ 1차 캐시로 반복 가능한 읽기(REPEATABLE READ) 등급의 트랜잭션 격리 수준을 DB 가 아닌 Application 차원에서 제공한다.

  ```java
  Member a = em.find(Member.class, "Member1");
  Member b = em.find(Member.class, "Member2");
  ​System.out.println(a == b); // 동일성 비교 true
  ```

<br>

### Transaction 을 지원하는 쓰기 지연(transactional write-behind) - Entity 등록

![image](https://github.com/lielocks/WIL/assets/107406265/d7b1d5e0-604f-4027-907b-7c59a18f0ccf)


+ Transaction 내부에서 **`persist()`** 가 일어날 때, **entity 들을 1차 캐시에 저장** 하고, 논리적으로 **`쓰기 지연 SQL 저장소`** 라는 곳에 **INSERT 쿼리들을 생성해서 쌓아 놓는다.**
+ DB 에 바로 넣지 않고 기다린다. 언제 넣냐. **`commit()`** 하는 시점에 DB 에 동시에 쿼리들을 쫙 보낸다.
+ (쿼리를 보내는 방식은 동시 or 하나씩 옵션에 따라) 이렇게 **쌓여있는 쿼리들을 DB 에 보내는 동작** 이 **`flush()`** 이다.
+ flush() 는 **1차 캐시를 지우지는 않는다.** 쿼리들을 DB 에 날려서 **DB 와 싱크를 맞추는 역할** 을 한다.
+ 실제로 쿼리를 보내고 나서, commit() 한다. 트랜잭션을 commit 하게 되면, flush() 와 commit() 두가지 일을 하게 되는 것이다.

```java
EntityManager em = emf.createEntityManager();
EntityTransaction transaction = em.getTransaction();
// 엔티티 매니저는 데이터 변경시 트랜잭션을 시작해야 한다.
transaction.begin();
// 트랜잭션 시작
​em.persist(memberA);
em.persist(memberB);
// 이때까지 INSERT SQL을 데이터베이스에 보내지 않는다.​
// 커밋하는 순간 데이터베이스에 INSERT SQL을 보낸다.
transaction.commit(); // 트랜잭션 커밋
```


+ `persistence.xml` 에 아래와 같은 옵션을 줄 수 있다.
+ JDBC 일괄 처리 옵션으로 커밋 직전까지 *insert 쿼리를 해당 사이즈 만큼 모아서 한번에 처리한다.*

```
<property name="hibernate.jdbc.batch_size" value=10/>
```

<br>

### 변경 감지(Dirty Checking) 

- Entity 수정
  Entity 수정이 일어나면 update() 나 persist() 로 persistence context 에 알려줘야 하지 않을까?

```java
EntityManager em = emf.createEntityManager();
EntityTransaction transaction = em.getTransaction();
transaction.begin(); // 트랜잭션 시작
​// 영속 엔티티 조회
Member memberA = em.find(Member.class, "memberA");​
// 영속 엔티티 수정
memberA.setUsername("nj");
memberA.setAge(27);​
//em.update(member) 또는 em.persist(member)로 다시 저장해야 하지 않을까?

​transaction.commit(); // 트랜잭션 커밋
```


+ Entity 데이터만 수정하면 끝이다.
+ 데이터만 set 하고 transaction 을 commit 하면 자동으로 UPDATE Query 가 나간다.
+ ***어떻게 이게 가능할까?***
+ 변경 감지를 Dirty Checking 이라고 한다!
+ 사실은 **1차 캐시에 저장할 때 동시에 `스냅샷 필드`도 저장한다.**
+ 그러고나서 commit() 또는 flush() 가 일어날 때 entity 와 snapshot 을 비교해서, 변경사항이 있으면 UPDATE SQL 을 알아서 만들어서 DB 에 저장한다.
![image](https://github.com/lielocks/WIL/assets/107406265/94f7cdce-a471-40e3-906f-f3a1696f584e)

+ update() 만들면 되지 왜 이렇게 복잡한 방법으로 처리하나...
  + 사상 때문이다.
  + 우리는 java collection 에서, list 에서 값을 변경하고 list 에 다시 그 값을 담지 않는다.
  + 값을 변경하면 변경된 list 가 유지되는 것과 같은 컨셉이다.
  + 따라서, 영속상태의 entity 를 가져와서 값만 바꾸면 수정은 끝이다.
  + entity 수정시 기본적으로 전체 필드 다 업데이트, 변경된 필드만 반영 되도록 할 수도 있음. **@DynamicUpdate**
 
<br>

### 엔티티 삭제

```java
Member memberA = em.find(Member.class, "memberA");
​em.remove(memberA); // 엔티티 삭제삭제는 위의 매커니즘이랑 같고, 트랜잭션의 commit 시점에 DELETE 쿼리가 나간다.
```

<br>

## flush 플러쉬
+ 플러시는 persistence context 의 변경 내용을 DB 에 반영한다.
+ Transaction commit 이 일어날 때 flush 가 동작하는데, `쓰기 지연 저장소에 쌓아 놨던 INSERT, UPDATE, DELETE SQL` 들이 DB 에 날라간다.
+ 쉽게 얘기해서 **persistence context 의 변경 사항들과 DB 를 싱크하는 작업이다.**

<br>

### flush 발생 ### 
+ flush 가 발생하면 어떤 일이 생기나 ?
  + 변경을 감지한다. Dirty Checking.
  + 수정된 entity 를 쓰기 지연 SQL 저장소에 등록한다.
  + 쓰기 지연 SQL 저장소의 쿼리를 DB 에 전송한다. (등록, 수정, 삭제 SQL) flush 가 발생한다고 commit 이 이루어지는게 아니고, flush 다음에 commit 이 일어난다.


### 영속성 컨텍스트를 Flush 하는 방법 ###
+ `em.flush()` 로 직접 호출

  ```java
  // 영속 Member member = new Member(200L, "A");
  em.persist(member);​
  em.flush();
  ​System.out.println("flush 직접 호출하면 쿼리가 commit 전 flush 호출 시점에 나감");​
  transaction.commit();
  ```

+ **Transaction commit** 시 flush 자동 호출
+ **JPQL 쿼리 실행** 하면 flush 자동 호출
  + JPQL 쿼리 실행시 flush 가 자동으로 호출되는 이유는 아래와 같이 member 1, 2, 3 을 영속화한 상태에서 쿼리는 안날라간 상태
  + JPQL 로 SELECT 쿼리를 날리려고 하면 저장되어 있는 값이 없어서 문제가 생길 수 있다.
  + JPA 는 이런 상황을 방지하고자 JPQL 실행 전에 무조건 **flush() 로 DB 와의 싱크** 를 맞춘 다음에 **JPQL 쿼리를 날리도록** 설정 되어 있다.
  + 그래서 아래의 상황에서는 JPQL 로 멤버들을 조회할 수 있다.

  ```java
  em.persist(memberA);
  em.persist(memberA);
  em.persist(memberA);​
  // 중간에 JPQL 실행
  query = em.createQuery("select m from Member m", Member.class);
  List<Member> members = query.getResultList();
  ```


+ flush 가 일어나면 1차 캐시가 삭제될까?
-> 삭제 되지 않는다.
-> 쓰기 지연 SQL 저장소에 있는 쿼리들만 **DB 에 전송** 되고 ***1차 캐시는 남아있다.***

<br>

### 플러시 모드 옵션 ###
+ em.setFlushMode(FlushModeType.COMMIT);
  + **FlushModeType.AUTO**
    + Commit 이나 쿼리를 실행할 때 flush(기본값)
  + **FlushModeType.COMMIT**
    + Commit 할때만 flush


### flush 정리 ###
+ flush 는 영속성 컨텍스트를 비우지 않는다. 오해하면 안된다.
+ flush 는 **`영속성 컨텍스트의 변경 내용`** 을 **DB 에 동기화 한다.**
+ flush 가 동작할 수 있는 이유는 DB **transaction이라는 작업 단위(개념)** 가 있기 때문이다.
+ 어쨋든 transaction 이 시작되고 commit 되는 시점에만 동기화 해주면 되기 때문에, 그 사이에서 flush 매커니즘의 동작이 가능한 것이다.
+ JPA 는 기본적으로 데이터를 맞추거나 동시성에 관련된 것들은 DB Transaction 에 위임한다. 참고로 알아두자.

<br>

## 준영속 상태

+ **영속 상태**
  + **`영속성 컨텍스트의 1차 캐시에 올라간 상태`** 가 영속 상태이다. **Entity Manager 가 관리하는 상태.**
  + em.persist() 로 영속성 컨텍스트에 저장한 상태도 영속 상태이지만, **`em.find()`** 로 조회를 할 때, **영속성 컨텍스트 1차 캐시에 없어서 DB 에서 조회해와서 1차 캐시에 저장한 상태** 도 **영속 상태** 다.
  + 코드로 보면
    + ***em.find()가 일어 날때, 1차 캐시에 없으므로 DB 에서 조회한 entity 를 1차 캐시에 넣는다. 영속상태가 됐다.***
    + setName 으로 이름을 바꾸고 commit 하려니까, Dirty Checking 이 일어나서 1차 캐시의 entity 와 snapshot 이 다른 것을 감지하고 UPDATE Query 를 날리게 된다.
    ```java
    Member member = em.find(Member.class, 150L);​
    member.setName("AAAAA");
    transaction.commit();
    ```

<br>

+ **준영속 상태** - 영속 상태의 엔티티가 영속성 컨텍스트에서 분리된 상태 (detached)
  + em.detach(member); 로 멤버를 영속성 컨텍스트에서 분리하고 transactino 을 commit 하면, 아무 일도 일어나지 않는다.
  + `JPA 가 관리 하지 않는 객체`가 된다. 실제로 아래에선 UPDATE Query 가 나가지 않는다.
    ```java
    Member member = em.find(Member.class, 150L);
    member.setName("AAAAA");

    ​em.detach(member);
    ​transaction.commit();
    ```

<br>
    
+ 영속성 컨텍스트가 제공하는 기능을 사용하지 못함. Query 안나감.
+ 준영속 상태로 만드는 방법
  + em.detach(entity) - 특정 entity 만 준영속 상태로 전환
  + em.clear() - persistent context 완전히 초기화
  + 아래 코드의 경우 `첫번째 find` 에서 멤버를 SELECT 해서 영속성 컨텍스트에 저장하고 영속성 컨텍스트를 초기화 했다.
  + 그러고나서 같은 아이디를 가지는 멤버를 다시 조회했을때는 SELECT 쿼리가 다시 나간다.
  + 총 2번의 SELECT 쿼리가 발생한다. clear는 테스트 케이스 작성시에 도움이 된다.
    ```java
    Member member = em.find(Member.class, 150L);
    member.setName("AAAAA");
    ​em.clear();
    ​Member member1 = em.find(Member.class, 150L);​
    transaction.commit();
    ```



---
    
*reference* https://ict-nroo.tistory.com/130


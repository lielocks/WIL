# 1. JPA (Java Persistent API) 와 ORM (Object Relational Mapping)

JPA 란 **자바 ORM 기술에 대한 API 표준 명세** 를 의미합니다.

JPA 는 **`ORM 을 사용하기 위한 인터페이스를 모아둔 것`** 이며, 
JPA 를 사용하기 위해서는 JPA 를 구현한 `Hibernate, EclipseLink, DataNucleus` 같은 ORM 프레임워크를 사용해야 합니다.

![image](https://github.com/lielocks/WIL/assets/107406265/54ae2545-a890-4343-b1a3-5867a79cfb43)

<br>

### ORM

그렇다면 ORM 은 무엇일까요?

**ORM** 이란 **`객체와 DB의 테이블이 매핑`** 을 이루는 것을 말합니다. (Java 진영에 국한된 기술은 아닙니다.)

즉, **객체가 테이블이 되도록 매핑시켜주는 것** 을 말합니다.

**ORM** 을 이용하면 SQL Query 가 아닌 **직관적인 코드(메서드)로서 데이터를 조작** 할 수 있습니다.

<br>

예를 들어, User 테이블의 데이터를 출력하기 위해서는 **`MySQL`** 에서는 `SELECT * FROM user;` 라는 query를 실행해야 하지만,

**`ORM`** 을 사용하면 User 테이블과 매핑된 객체를 user라 할 때, `user.findAll()` 라는 **메서드 호출** 로 데이터 조회가 가능합니다.

<br>

query 를 직접 작성하지 않고 메서드 호출만으로 query 가 수행되다 보니, ORM 을 사용하면 **생산성이 매우 높아집니다.**

그러나 **query 가 복잡해지면 ORM 으로 표현하는데 한계** 가 있고, 성능이 `raw query 에 비해 느리다` 는 단점이 있는데요,

그래서 나중에 다루게 될 `JPQL, QueryDSL` 등을 사용하거나 한 프로젝트 내에서 `Mybatis와 JPA를 같이` 사용하기도 합니다.

<br>

Java 에서 DB를 다룰 때, JDBC 를 직접 사용하는 것보다 Mybatis를 사용했을 때 코드가 간결해지고 유지보수가 편했다는 것을 느꼈습니다.

**Hibernate** 를 배우게 되면 Mybatis보다 코드가 더 간결하며, 더 객체 지향적이고 생산성이 매우 높다는 것을 느끼게 될 것입니다.

<br>

# 2. Mybatis vs Hibernate

JPA를 구현한 여러 프레임워크가 있지만 Hibernate가 JPA를 주도하고 있기 때문에 JPA를 Hibernate라 생각하고 혼용해서 사용하도록 하겠습니다.

먼저, 전 세계 개발자들은 Mybatis와 Hibernate 중 어떤 것을 더 많이 사용하는지 알아보겠습니다.

![image](https://github.com/lielocks/WIL/assets/107406265/4295bd8e-e5a1-4056-a0e3-c107ca79d3ff)

동아시아를 제외하고 대부분 나라에서는 **Hibernate** 를 압도적으로 많이 사용하고 있다는 것을 알 수 있습니다.

그만큼 `JDBC를 직접 사용하는 Mybatis` 보다 `JDBC를 노출하지 않고 ORM 기술을 사용` 하는 **`JPA`** 를 선호한다는 것을 알 수 있습니다.

( JPA도 분명 단점이 존재하기 때문에 서비스에 따라 Mybatis를 사용할 지 JPA를 사용할 지 결정해야 합니다. )


이제 JPA가 이렇게 인기가 많아지게 된 배경을 살펴보기로 하겠습니다.

<br>

# 3. JPA 탄생 배경

Mybatis에서는 테이블 마다 비슷한 CRUD SQL을 계속 반복적으로 사용했었습니다.

소규모라도 **Mybatis** 로 애플리케이션을 만들어 보셨다면, `DAO 개발이 매우 반복` 되는 작업이며, 이 작업이 매우 귀찮다는 경험을 해보았을 것입니다.

<br>

또한 테이블에 컬럼이 하나 추가된다면 이와 관련된 *모든 DAO의 SQL문을 수정* 해야 합니다.

즉, **`DAO와 테이블은 강한 의존성`** 을 갖고 있습니다.

<br>

이러한 이유로 SQL 을 자동으로 생성해주는 툴이 개발 되기도 했지만, 반복 작업은 마찬가지였고 큰 효과가 없었습니다.

그 이유는 **객체 모델링보다 데이터 중심 모델링 (테이블 설계) 을 우선시했으며,
객체지향의 장점(추상화, 캡슐화, 정보은닉, 상속, 다형성)을 사용하지 않고 객체를 단순히 데이터 전달 목적( VO, DTO )에만 사용했기 때문입니다.**

다시 말하면 객체지향 개발자들이 개발하고 있는 방법이 전혀 객체 지향적이지 않다는 것을 느끼게 된 것입니다.

아래의 모델링은 `Book` 과 `Album` 테이블의 공통된 컬럼인 `name과 price` 를 `Item` 이라는 테이블에 정의하여 상속받도록 한 **객체 지향 모델링(OOM)** 입니다.

![image](https://github.com/lielocks/WIL/assets/107406265/19c8c8a0-fd55-4150-97d4-436942892bb8)

ERD에서 사용하는 데이터 모델링과 달리 객체지향 모델링에는 **상속** 이라는 개념이 있습니다.

모델링을 위와 같이 객체 지향적으로 설계 했을 때, `SQL을 작성해야 하는 JDBC` 로 사용하기 위해서는 ERD로 다시 바꿔줘야 하는데 ERD에서는 상속 관계를 표현하기가 `까다롭습니다.`

<br>

그런데 객체 지향 설계에 대해서, **`상속 관계를 잘 표현 해주는 데이터 모델링`** 으로 바꿔주는 기술이 있다면?

그리고 상속 관계에 있는 테이블에 대해 **`Join`** 도 알아서 해결 해준다면 객체 지향적인 설계가 가능할 것입니다.

<br>

정리하자면 JDBC API를 사용했을 때의 문제는 다음과 같습니다.

+ 유사한 `CURD SQL` 반복 작업
  
+ 객체를 `단순히 데이터 전달` 목적으로 사용할 뿐, 객체 지향적이지 못함 ( 페러다임 불일치 )

그래서 **객체와 테이블을 매핑 시켜주는 ORM** 이 주목 받기 시작했고, 자바 진영에서는 ***JPA*** 라는 표준 스펙이 정의 되었습니다.

<br>

### JPA (Java Persistence API)

![image](https://github.com/lielocks/WIL/assets/107406265/dc65274f-a72d-48ad-8e50-7c41d22c9a64)

+ **자바 ORM 기술에 대한 표준 명세** 로, `JAVA` 에서 제공하는 API 이다. 스프링에서 제공하는 것 X

+ 자바 어플리케이션에서 관계형 **데이터베이스를 사용하는 방식** 을 정의한 `인터페이스` 이다.

  + 여기서 중요하게 여겨야 할 부분은, **`JPA`** 는 말 그대로 **`인터페이스`** 라는 점이다.

    JPA 는 특정 기능을 하는 *라이브러리가 아니다.*

    스프링의 PSA 에 의해서 (POJO 를 사용하면서 특정 기술을 사용하기 위해) 표준 인터페이스를 정해 두었는데, 그 중 ORM 을 사용하기 위해 만든 인터페이스가 JPA 이다.

+ 기존 EJB 에서 제공되던 엔티티 빈을 대체하는 기술이다.

+ `ORM` 이기 때문에 **자바 클래스와 DB 테이블을 매핑** 한다. (SQL 을 매핑하지 않는다.)

<br>

> **SQL Mapper 와 ORM**
>
> + **`ORM`** 은 **DB 테이블을 자바 객체로 매핑** 함으로써 `객체간의 관계를 바탕으로 SQL 을 자동으로 생성` 하지만 **`Mapper`** 는 **SQL 을 명시** 해주어야 한다.
>
> + **`ORM`** 은 **RDB 의 관계를 Object 에 반영** 하는 것이 목적이라면, **`Mapper`** 는 **단순히 필드를 매핑** 시키는 것이 목적이라는 지향점의 차이가 있다. 

<br>

### SQL Mapper 
+ `SQL` ← mapping → `Object 필드`
  
+ `SQL문` 으로 **직접 DB 조작**

+ Mybatis, JdbcTemplate

<br>

### ORM (Object-Relation Mapping/객체-관계 매핑)
+ `DB 데이터` ← mapping → `Object 필드`

  + `객체` 를 통해 **간접적** 으로 DB 데이터를 다룬다.

+ `객체` 와 `DB 의 데이터` 를 **자동으로 매핑** 해준다.
  + SQL 쿼리가 아니라 **메서드** 로 데이터를 조작할 수 있다.
 
  + **`객체간 관계`** 를 바탕으로 `SQL 을 자동 생성`
  + 한다.
 
+ Persistence API 라고 할 수 있다.

+ JPA, Hibernate

<br>

### JDBC 

![image](https://github.com/lielocks/WIL/assets/107406265/cacb6a12-6d2e-4b28-b1a4-48a0d8c8d7aa)

**`JDBC`** 는 **DB 에 접근할 수 있도록 자바에서 제공하는 API** 이다.

모든 **`JAVA Data Access 기술의 근간`** 이다. -> 모든 `Persistance Framework` 는 내부적으로 `JDBC API` 를 사용한다.

<br>

### Spring-Data-JPA

![image](https://github.com/lielocks/WIL/assets/107406265/027e0d62-3e63-4a42-94dc-0357c9c7c30c)

JPA은 ORM을 위한 자바 EE 표준이며 Spring-Data-JPA는 JPA를 쉽게 사용하기 위해 스프링에서 제공하고 있는 프레임워크이다.

추상화 정도는 `Spring-Data-JPA` -> `Hibernate` -> `JPA` 이다.

`Hibernate` 를 쓰는 것과 `Spring Data JPA` 를 쓰는 것 사이에는 큰 차이가 없지만

+ 구현체 교체의 용이성

+ 저장소 교체의 용이성

이라는 이유에서 **Spring Data JPA** 를 사용하는것이 더 좋다.

> 자바의 Redis 클라이언트가 Jdis에서 Lettuce 로 대세가 넘어갈 때 `Spring Data Redis` 를 사용하면 아주 쉽게 교체가 가능했다.
> Spring Data JPA, Spring Data MongoDB, Spring Data Redis등 `Spring Data의 하위 프로젝트들` 은 findAll(), save() 등을 **동일한 인터페이스** 로 가지고 있기 때문에 **저장소를 교체해도 기본적인 기능이 변하지 않는다.**

<br>

### JPA 동작 과정

![image](https://github.com/lielocks/WIL/assets/107406265/97558f37-86f8-4a0b-9adf-72b828cd7543)

JPA 는 어플리케이션과 JDBC 사이에서 동작한다.

개발자가 JPA 를 사용하면, **JPA 내부에서 JDBC API 를 사용하여 SQL 을 호출하여 DB 와 통신** 한다.

즉, 개발자가 직접 JDBC API 를 쓰는 것이 아니다.

+ **INSERT**

![image](https://github.com/lielocks/WIL/assets/107406265/0a0b7eca-31eb-4af8-bba5-8fc1123bca37)

`MemberDAO` 에서 객체를 저장하고 싶을 때 개발자는 `JPA` 에 **Member 객체를 넘긴다.**

JPA는

1. `Member entity` 를 분석한다.

2. `INSERT SQL` 을 생성한다.

3. **JDBC API** 를 사용하여 `SQL` 을 `DB` 에 날린다.

<br>

+ **FIND**

![image](https://github.com/lielocks/WIL/assets/107406265/3cfc9e66-68fa-4a36-ab92-4ff1acbcb291)

개발자는 `member의 pk 값` 을 **JPA 에 넘긴다.**

JPA는

1. `entity 의 매핑 정보` 를 바탕으로 **적절한 SELECT SQL을 생성** 한다.

2. **JDBC API** 를 사용하여 `SQL` 을 `DB` 에 날린다.

3. `DB` 로부터 **결과** 를 받아온다.

4. `결과(ResultSet)` 를 **객체에 모두 매핑** 한다.

   `쿼리` 를 **JPA가 만들어 주기 때문에** **`Object와 RDB 간의 패러다임 불일치를 해결`** 할 수 있다.

<br>

### JPA 특징

1. `데이터` 를 **객체지향적으로 관리** 할 수 있기 때문에 개발자는 비즈니스 로직에 집중할 수 있고 객체지향 개발이 가능하다.

2. **`자바 객체와 DB 테이블 사이의 매핑 설정`** 을 통해 SQL을 생성한다.

3. **`객체를 통해 쿼리를 작성`** 할 수 있는 **JPQL(Java Persistence Query Language)** 를 지원

4. JPA는 성능 향상을 위해 **`지연 로딩이나 즉시 로딩`** 과 같은 몇가지 기법을 제공하는데 이것을 잘 활용하면 **SQL을 직접 사용하는 것과 유사한 성능** 을 얻을 수 있다.

<br>


### JPA를 왜 사용해야 할까

1. `sql 중심적인 개발` 에서 **객체 중심적인 개발** 이 가능하다.

  sql 코드의 반복 -> `객체지향` 과 `관계지향 데이터베이스` 의 페러다임 불일치

  Object -> [SQL 변환] -> RDB에 저장
  [개발자 == **SQL 매퍼** ] 라고 할만큼 SQL 작업을 너무 많이 하고 있다.

2. 생산성이 증가

  `간단한 메소드` 로 CRUD가 가능하다

3. 유지보수가 쉽다
  기존: 필드 변경 시 모든 SQL을 수정해야 한다.
  JPA: **`필드만`** 추가하면 된다. SQL은 JPA가 처리하기 때문에 손댈 것이 없다.

4. **`Object와 RDB`** 간의 패러다임 불일치 해결


<br>

# 4. Hibernate 특징

### JPA Hiberante

하이버네이트는 JPA 구현체의 한 종류이다.

JPA는 DB와 자바 객체를 매핑하기 위한 인터페이스(API)를 제공하고 JPA 구현체(하이버네이트)는 이 인터페이스를 구현한 것이다.

하이버네이트 외에도 `EclipseLink, DataNucleus, OpenJPA, TopLink Essentials` 등이 있다.

![image](https://github.com/lielocks/WIL/assets/107406265/a151e854-7b8f-4a60-bf73-5c69cee5e37f)

+ Hibernate가 SQL을 직접 사용하지 않는다고 해서 JDBC API를 사용하지 않는다는 것은 아니다.

  + `Hibernate가 지원하는 메서드 내부` 에서는 **JDBC API** 가 동작하고 있으며, 단지 *개발자가 직접 SQL을 직접 작성하지 않을 뿐* 이다.

+ **HQL(Hibernate Query Language)** 이라 불리는 매우 강력한 쿼리 언어를 포함하고 있다.

  + HQL은 SQL과 매우 비슷하며 추가적인 컨벤션을 정의할 수도 있다.

  + HQL은 완전히 **`객체 지향적`** 이며 이로써 `상속, 다형성, 관계` 등의 객체지향의 강점을 누릴 수 있다.

  + HQL은 **쿼리 결과로 객체를 반환** 하며 프로그래머에 의해 `생성` 되고 `직접적으로 접근` 할 수 있다.

  + HQL은 SQL에서는 지원하지 않는 **`페이지네이션`** 이나 **`동적 프로파일링`** 과 같은 향상된 기능을 제공한다.

  + HQL은 여러 테이블을 작업할 때 **명시적인 join을 요구하지 않는다.**

<br>

### 영속성

`데이터를 생성한 프로그램이 종료` 되어도 **사라지지 않는 데이터** 의 특성을 말한다.

영속성을 갖지 않으면 데이터는 **메모리에서만 존재** 하게 되고 프로그램이 종료되면 해당 데이터는 **모두 사라지게 된다.**

그래서 우리는 데이터를 파일이나 DB에 영구 저장함으로써 데이터에 영속성을 부여한다.

<br>

### Persistance Layer

프로그램의 아키텍처에서 **데이터에 영속성을 부여해주는 계층** 을 말한다.

JDBC를 이용해 직접 구현이 가능하나 보통은 `Persistance Framework` 를 사용한다.

![image](https://github.com/lielocks/WIL/assets/107406265/1149e979-6e8e-460b-b27c-b3b53da86eaa)

**프레젠테이션 계층 (Presentation layer)** - `UI 계층 (UI layer)` 이라고도 함

**애플리케이션 계층 (Application layer)** - `서비스 계층 (Service layer)` 이라고도 함

**비즈니스 논리 계층 (Business logic layer)** - `도메인 계층 (Domain layer)` 이라고도 함

**데이터 접근 계층 (Data access layer)** - `영속 계층 (Persistence layer)` 이라고도 함

<br>

**Persistance Framework**

JDBC 프로그래밍의 복잡함이나 번거로움 없이 *간단한 작업만으로* DB와 연동되는 시스템을 빠르게 개발할 수 있고 안정적인 구동을 보장한다.

Persistance Framework는 `SQL Mapper` 와 `ORM` 으로 나눌 수 있다.

<br>

### JPA 에서의 영속성

![image](https://github.com/lielocks/WIL/assets/107406265/32de5b5a-24ef-423c-9289-c7a0482fbdca)

JPA의 핵심 내용은 엔티티가 영속성 컨텍스트에 포함되어 있냐 아니냐로 갈린다. 

JPA의 Entity Manager 가 활성화된 상태로 트랜잭션(@Transactional) 안에서 DB에서 데이터를 가져오면 이 데이터는 영속성 컨텍스트가 유지된 상태이다. 
이 상태에서 해당 데이터 값을 변경하면 트랜잭션이 끝나는 시적에 해당 테이블에 변경 내용을 반영하게 된다. 

따라서 우리는 엔티티 객체의 필드 값만 변경해주면 별도로 update()쿼리를 날릴 필요가 없게 된다! 

이 개념을 더티 체킹이라고 한다.

Spring Data Jpa를 사용하면 기본으로 엔티티 매니저가 활성화되어있는 상태이다.

> **영속 컨텍스트**
> 
> 엔티티를 담고 있는 **집합**
>
> JPA 는 **`영속 컨텍스트에 속한 엔티티`** 를 DB에 반영한다. 엔티티를 검색, 삭제, 추가 하게 되면 영속 컨텍스트의 내용이 DB에 반영된다.
>
> `영속 컨텍스트` 는 직접 접근이 불가능하고 **`Entity Manager를 통해서만`**  접근이 가능하다.

<br>

### JPA 성능 최적화

기본적으로 `중간 계층` 이 있는 경우 아래의 방법으로 성능을 개선할 수 있는 기능이 존재한다.

1. 모아서 쓰는 **버퍼링** 기능

2. 읽을 때 쓰는 **캐싱** 기능

JPA 도 JDBC API와 DB 사이에 존재하기 때문에 위의 두 기능이 존재한다.

1. **1차 캐시와 동일성(identity) 보장 - 캐싱 기능**
   
`같은 트랜잭션` 안에서는 `같은 엔티티` 를 반환 - 약간의 조회 성능 향상 (크게 도움 X)

```java
    String memberId = "100";
    
    Member m1 = jpa.find(Member.class, memberId); // SQL
    
    Member m2 = jpa.find(Member.class, memberId); // 캐시 (SQL 1번만 실행, m1을 가져옴)
    
    println(m1 == m2) // true
```

결과적으로, **SQL을 한 번만** 실행한다.

DB Isolation Level이 Read Commit이어도 애플리케이션에서 `Repeatable Read 보장`

<br>

2. **트랜잭션을 지원하는 쓰기 지연(transactional write-behind) - 버퍼링 기능**
   
**INSERT**

```java
/** 1. 트랜잭션을 커밋할 때까지 INSERT SQL을 모음 */

transaction.begin(); // [트랜잭션] 시작

em.persist(memberA);

em.persist(memberB);

em.persist(memberC);

// -- 여기까지 INSERT SQL을 데이터베이스에 보내지 않는다.

// 커밋하는 순간 데이터베이스에 INSERT SQL을 모아서 보낸다. --

/** 2. JDBC BATCH SQL 기능을 사용해서 한번에 SQL 전송 */

transaction.commit(); // [트랜잭션] 커밋
```

+ **`[트랜잭션]을 commit`** 할 때까지 `INSERT SQL` 을 **메모리에 쌓는다.**

  이렇게 하지 않으면 `DB에 INSERT Query를 날리기 위한 네트워크를 3번` 타게 된다.

+ **`JDBC Batch SQL`** 기능을 사용해서 **한 번에 SQL을 전송** 한다.

  JDBC Batch를 사용하면 코드가 굉장히 지저분해진다.

  **지연 로딩 전략(Lazy Loading)** 옵션을 사용한다.

<br>

**UPDATE**

```java
/** 1. UPDATE, DELETE로 인한 로우(ROW)락 시간 최소화 */

transaction.begin(); // [트랜잭션] 시작

changeMember(memberA);

deleteMember(memberB);

비즈니스_로직_수행(); // 비즈니스 로직 수행 동안 DB 로우 락이 걸리지 않는다.

// 커밋하는 순간 데이터베이스에 UPDATE, DELETE SQL을 보낸다.

/** 2. 트랜잭션 커밋 시 UPDATE, DELETE SQL 실행하고, 바로 커밋 */

transaction.commit(); // [트랜잭션] 커밋
```

+ UPDATE, DELETE로 인한 로우(ROW)락 시간 최소화

+ 트랜잭션 커밋 시 UPDATE, DELETE SQL 실행하고, 바로 커밋

<br>

Hibernate를 사용하면 위의 문제들을 해결할 수 있습니다.

그리고 항상 완벽한 기술은 없듯이 Hibernate에도 단점이 존재하는데, 지금부터 Hibernate의 장단점을 알아보겠습니다.

<br>

### 장점

1. **생산성**
   
+ Hibernate는 SQL를 직접 사용하지 않고, **메서드 호출만** 으로 쿼리가 수행됩니다.

+ 즉, SQL 반복 작업을 하지 않으므로 생산성이 매우 높아집니다.

  + 그런데 SQL을 직접 사용하지 않는다고 해서 SQL을 몰라도 된다는 것은 아닙니다.

  + Hibernate가 수행한 쿼리를 `콘솔` 로 출력하도록 설정을 할 수 있는데, 쿼리를 보면서 의도한 대로 쿼리가 짜여졌는지, 성능은 어떠한지에 대한 모니터링이 필요하기 때문에 SQL을 잘 알아야 합니다.

<br>

2. **유지보수**
   
+ `테이블 컬럼이 하나 변경` 되었을 경우,

  + Mybatis에서는 관련 DAO의 파라미터, 결과, SQL 등을 `모두 확인하여 수정` 해야 함

  + JPA를 사용하면 **JPA가 이런 일들을 대신** 해주기 때문에 유지보수 측면에서 좋습니다.

<br>

3. **특정 벤더에 종속적이지 않음**
   
+ 여러 DB 벤더( MySQL, Oracle 등.. )마다 SQL 사용이 조금씩 다르기 때문에 애플리케이션 개발 시 처음 선택한 DB를 나중에 바꾸는 것은 매우 어렵습니다.

+ 그런데 JPA는 **추상화된 데이터 `접근 계층` 을 제공** 하기 때문에 특정 벤더에 종속적이지 않습니다.

  + 즉, `설정 파일` 에서 JPA에게 어떤 DB를 사용하고 있는지 알려주기만 하면 **얼마든지 DB를 바꿀 수가 있습니다.**

<br>

### 단점

1. **성능**
   
+ 메서드 호출로 쿼리를 실행한다는 것은 `내부적으로 많은 동작` 이 있다는 것을 의미하므로, `직접 SQL을 호출` 하는 것보다 **성능이 떨어질 수 있습니다.**

+ 실제로 `초기의 ORM` 은 쿼리가 제대로 수행되지 않았고, 성능도 좋지 못했다고 합니다.

  + 그러나 지금은 많이 발전하여, 좋은 성능을 보여주고 있고 계속 발전하고 있습니다.

<br>

2. **세밀함**

+ **메서드 호출** 로 SQL을 실행하기 때문에 세밀함이 떨어집니다. 또한 **`객체간의 매핑( Entity Mapping )`** 이 잘못되거나**`JPA를 잘못 사용`** 하여 의도하지 않은 동작을 할 수도 있구요.

+ **복잡한 통계 분석 쿼리** 를 메서드 호출로 처리하는 것은 힘든 일입니다.

  + 이것을 보완하기 위해 JPA에서는 SQL과 유사한 기술인 `JPQL` 을 지원합니다.

  + 물론 SQL 자체 쿼리를 작성할 수 있도록 지원도 하고 있습니다.

<br>

3. **러닝커브**

+ JPA를 잘 사용하기 위해서는 알아야 할 것이 많습니다.

+ 그래서 이러한 복잡성을 해결하고자 최근에는 **`Spring Data JDBC`** 가 주목을 받고 있습니다. ( 2018-09-21 첫 1.0.0 RELEASE )

<br>

# 5. 정리

JPA가 SQL을 직접 작성하지 않는다고 해서 JDBC API를 사용하지 않는다는 것은 아닙니다.

**`Hibernate가 지원하는 메서드 내부`** 에서는 **JDBC API가 동작** 하고 있으며, 단지 개발자가 `직접 SQL을 직접 작성하지 않을 뿐` 입니다.

그래서 JPA에서 수행하는 쿼리가 내 의도대로 실행이 된건지 모니터링을 할 줄 알아야 합니다.

<br>

JPA는 통계 쿼리처럼 복잡한 SQL을 수행하기 힘들기 때문에, 비즈니스에 따라 `Mybatis` 를 사용할 지 `Hibernate` 를 사용할 지 상황에 맞는 선택이 중요할 것입니다.

처음에 살펴본 구글 트렌드를 볼 때 우리나라는 대부분 `Mybatis` 를 사용하고 있는데, 그 이유는 우리나라 시장 대부분이 `SI` , `금융 시장` 이기 때문입니다.

비즈니스가 매우 **복잡** 하고, 안정성을 중요시 하는 서비스일 경우에는 JPA보다 **SQL을 작성하는 것이 더 좋다** 는 의도일 것입니다.

이미 SQL을 사용하여 개발된 애플리케이션이라면 JPA로 바꾸는 일도 쉽지 않기 때문에, 우리나라에서는 JPA가 많이 사용되지 못하는 것 같습니다.

그런데 최근에는 `서비스 업체, 신규 프로젝트들` 은 **`JPA`** 를 많이 사용하고 있는 것 같네요.

<br>

ORM은 꾸준히 발전하고 있는 기술이며, 저는 높은 생산성을 자랑하는 ORM을 매우 좋아합니다.

처음 접한 프레임워크가 `Ruby on Rails` 였는데, `ROR에서는 ORM이 내장` 되어 있습니다.

그 영향인지는 몰라도 Node.js 공부할 때도 ORM이 있는지 먼저 찾았었네요.

역시나 `자바` 에서도 `Hibernate` 라는 멋진 기술이 있었습니다.






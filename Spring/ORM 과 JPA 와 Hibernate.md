# 1. JPA (Java Persistent API) 와 ORM (Object Relational Mapping)

JPA 란 자바 ORM(Object Relational Mapping) 기술에 대한 API 표준 명세를 의미합니다.

JPA 는 특정 기능을 하는 라이브러리가 아니고, **ORM 을 사용하기 위한 인터페이스** 를 모아둔 것입니다.  

JPA 는 java application 에서 관계형 데이터베이스를 어떻게 사용해야 하는지를 정의하는 방법중 한 가지 입니다.

<br>

JPA 는 *단순히 명세이기 때문에* 구현이 없습니다.

JPA 를 정의한 `javax.persistence` 패키지의 대부분은 *interface , enum , Exception, 그리고  Annotation* 들로 이루어져 있습니다.

JPA 의 핵심이 되는 **EntityManager** 는 아래와 같이 **`javax.persistence 패키지 안에 interface`** 로 정의되어 있습니다.

```java
package javax.persistence;

import ...

public interface EntityManager {

  public void persist(Object entity);

  public <T> T merge(T entity);

  public void remove(Object entity);

  public <T> T find(Class<T> entityClass, Object primaryKey);     // More interface methods...

}
```

<br>

JPA 를 사용하기 위해서는 JPA 를 구현한 **Hibernate, EclipseLink, DataNucleus 같은 ORM 프레임워크** 를 사용해야 합니다.

우리가 Hibernate 를 많이 사용하는 이유는 가장 범용적으로 다양한 기능을 제공하기 때문입니다.

![image](https://github.com/lielocks/WIL/assets/107406265/54ae2545-a890-4343-b1a3-5867a79cfb43)

<br>

### ORM

그렇다면 ORM 은 무엇일까요?

**ORM** 이란 **객체와 DB의 테이블이 매핑** 을 이루는 것을 말합니다. (Java 진영에 국한된 기술은 아닙니다.)

즉, **객체가 테이블이 되도록 매핑시켜주는 것** 을 말합니다.

**ORM** 을 이용하면 SQL Query 가 아닌 **직관적인 코드(메서드)로서 데이터를 조작** 할 수 있습니다.

<br>

예를 들어, User 테이블의 데이터를 출력하기 위해서는 **MySQL** 에서는 `SELECT * FROM user;` 라는 query를 실행해야 하지만,

**ORM** 을 사용하면 User 테이블과 매핑된 객체를 user 라 할 때, `user.findAll()` 라는 **method 호출** 로 데이터 조회가 가능합니다.

<br>

query 를 직접 작성하지 않고 메서드 호출만으로 query 가 수행되다 보니, ORM 을 사용하면 **생산성이 매우 높아집니다.**

그러나 **query 가 복잡해지면 ORM 으로 표현하는데 한계** 가 있고, 성능이 *raw query 에 비해 느리다* 는 단점이 있는데요,

그래서 나중에 다루게 될 *JPQL, QueryDSL* 등을 사용하거나 한 프로젝트 내에서 Mybatis 와 JPA 를 같이 사용하기도 합니다.

<br>

# 2. Hibernate

Hibernate 는 *JPA 의 구현체 중 하나* 입니다.  
Hibernate 는 SQL 을 사용하지 않고 직관적인 코드(메소드)를 사용해 데이터를 조작할 수 있습니다.  
Hibernate 가 SQL 을 직접 사용하지 않는다고 해서 **JDBC API 를 사용하지 않는 것은 아닙니다.**  
Hibernate 가 지원하는 `메소드 내부에서는 JDBC API` 가 동작하고 있으며, 단지 개발자가 직접 SQL 을 작성하지 않을 뿐 입니다.  

![image](https://github.com/user-attachments/assets/6665082a-5bf7-45d5-a098-52ffaba6b34b)

**`JPA 와 Hibernate`** 는 마치 **`java 의 interface 와 해당 interface 를 구현한 class`** 와 같은 관계입니다.

![image](https://github.com/user-attachments/assets/dcf743d0-1e15-4088-83df-1a12d0d2fa6e)

위 사진은 JPA 와 Hibernate 의 상속 및 구현 관계를 나타낸 것입니다.

**JPA** 의 핵심인 `EntityManagerFactory , EntityManager , EntityTransaction` 을 

**Hibernate** 에서는 각각 `SessionFactory , Session , Transaction` 으로 상속받고 각각 Impl로 구현하고 있음을 확인할 수 있습니다.

<br>

# 3. JPA 탄생 배경

Mybatis에서는 테이블 마다 비슷한 CRUD SQL 을 계속 반복적으로 사용했었습니다.

소규모라도 **Mybatis** 로 애플리케이션을 만들어 보셨다면, *DAO 개발이 매우 반복* 되는 작업입니다.

<br>

또한 테이블에 컬럼이 하나 추가된다면 이와 관련된 *모든 DAO의 SQL문을 수정* 해야 합니다.

즉, *DAO와 테이블은 강한 의존성* 을 갖고 있습니다.

<br>

이러한 이유로 SQL 을 자동으로 생성해주는 툴이 개발 되기도 했지만, 반복 작업은 마찬가지였고 큰 효과가 없었습니다.

그 이유는 **객체 모델링보다 데이터 중심 모델링 (테이블 설계) 을 우선시했으며,
객체지향의 장점(추상화, 캡슐화, 정보은닉, 상속, 다형성)을 사용하지 않고 객체를 단순히 데이터 전달 목적( VO, DTO )에만 사용했기 때문입니다.**

다시 말하면 객체지향 개발자들이 개발하고 있는 방법이 전혀 객체 지향적이지 않다는 것을 느끼게 된 것입니다.

아래의 모델링은 `Book` 과 `Album` 테이블의 공통된 컬럼인 `name 과 price` 를 `Item` 이라는 테이블에 정의하여 상속받도록 한 **객체 지향 모델링(OOM)** 입니다.

![image](https://github.com/lielocks/WIL/assets/107406265/19c8c8a0-fd55-4150-97d4-436942892bb8)

ERD 에서 사용하는 데이터 모델링과 달리 객체지향 모델링에는 **상속** 이라는 개념이 있습니다.

모델링을 위와 같이 객체 지향적으로 설계 했을 때, `SQL 을 작성해야 하는 JDBC` 로 사용하기 위해서는 ERD 로 다시 바꿔줘야 하는데 ERD 에서는 상속 관계를 표현하기가 `까다롭습니다.`

<br>

그런데 객체 지향 설계에 대해서, **`상속 관계를 잘 표현 해주는 데이터 모델링`** 으로 바꿔주는 기술이 있다면?

그리고 상속 관계에 있는 테이블에 대해 **`Join`** 도 알아서 해결 해준다면 객체 지향적인 설계가 가능할 것입니다.

<br>

정리하자면 JDBC API 를 사용했을 때의 문제는 다음과 같습니다.

+ 유사한 CRUD SQL 반복 작업
  
+ 객체를 *단순히 데이터 전달 목적* 으로 사용할 뿐, 객체 지향적이지 못함 ( 페러다임 불일치 )

그래서 **객체와 테이블을 매핑 시켜주는 ORM** 이 주목 받기 시작했고, 자바 진영에서는 ***JPA*** 라는 표준 스펙이 정의 되었습니다.

<br>

### JPA (Java Persistence API)

![image](https://github.com/lielocks/WIL/assets/107406265/dc65274f-a72d-48ad-8e50-7c41d22c9a64)

+ **자바 ORM 기술에 대한 표준 명세** 로, `JAVA` 에서 제공하는 API 이다. 스프링에서 제공하는 것 X

+ 자바 어플리케이션에서 관계형 **데이터베이스를 사용하는 방식** 을 정의한 `인터페이스` 이다.

  + 여기서 중요하게 여겨야 할 부분은, **JPA** 는 말 그대로 **`인터페이스`** 라는 점이다.

    JPA 는 특정 기능을 하는 *라이브러리가 아니다.*

    스프링의 PSA 에 의해서 (POJO 를 사용하면서 특정 기술을 사용하기 위해) 표준 인터페이스를 정해 두었는데, 그 중 ORM 을 사용하기 위해 만든 인터페이스가 JPA 이다.

+ 기존 EJB 에서 제공되던 Entity Bean 을 대체하는 기술이다.

+ `ORM` 이기 때문에 **자바 클래스와 DB 테이블을 매핑** 한다. (SQL 을 매핑하지 않는다.)

<br>

> **SQL Mapper 와 ORM**
>
> + **`ORM`** 은 **DB 테이블을 자바 객체로 매핑** 함으로써 `객체간의 관계를 바탕으로 SQL 을 자동으로 생성` 하지만 **`Mapper`** 는 **SQL 을 명시** 해주어야 한다.
>
> + **`ORM`** 은 **RDB 의 관계를 Object 에 반영** 하는 것이 목적이라면, **`Mapper`** 는 **단순히 field 를 mapping** 시키는 것이 목적이라는 지향점의 차이가 있다. 

<br>

### SQL Mapper 

+ `SQL` ← mapping → `Object 필드`
  
+ `SQL문` 으로 **직접 DB 조작**

+ Mybatis, JdbcTemplate

<br>

### ORM (Object-Relation Mapping / 객체-관계 매핑)

+ `DB 데이터` ← mapping → `Object 필드`

  + `객체` 를 통해 **간접적** 으로 DB 데이터를 다룬다.

+ `객체` 와 `DB 의 데이터` 를 **자동으로 매핑** 해준다.

  + SQL 쿼리가 아니라 **메서드** 로 데이터를 조작할 수 있다.
 
  + **`객체간 관계`** 를 바탕으로 `SQL 을 자동 생성` 한다.
 
+ Persistence API 라고 할 수 있다.

+ JPA, Hibernate

<br>

### JDBC 

![image](https://github.com/lielocks/WIL/assets/107406265/cacb6a12-6d2e-4b28-b1a4-48a0d8c8d7aa)

**`JDBC`** 는 **DB 에 접근할 수 있도록 자바에서 제공하는 API** 이다.

모든 **`JAVA Data Access 기술의 근간`** 이다. -> 모든 `Persistence Framework` 는 내부적으로 `JDBC API` 를 사용한다.

<br>

### Spring-Data-JPA

![image](https://github.com/lielocks/WIL/assets/107406265/027e0d62-3e63-4a42-94dc-0357c9c7c30c)

Spring Data JPA 는 Spring 에서 제공하는 모듈 중 하나로 JPA 를 쉽고 편하게 사용할 수 있도록 도와줍니다.

기존에 JPA 를 사용하려면 *EntityManager* 를 주입받아 사용해야 하지만,

Spring Data JPA 는 JPA 를 한단계 더 추상화 시킨 **Repository 인터페이스** 를 제공합니다.

*Spring Data JPA 가 JPA 를 추상화했다* 는 말은, `Spring Data JPA 의 Repository 의 구현`에서 **JPA 를 사용하고 있다** 는 것입니다.

사용자가 Repository 인터페이스에 정해진 규칙대로 메소드를 입력하면, 
Spring 이 알아서 해당 메소드 이름에 **적합한 쿼리를 날리는 구현체를 만들어서 Bean 으로 등록** 해줍니다.

> 자바의 Redis 클라이언트가 Jdis에서 Lettuce 로 대세가 넘어갈 때 `Spring Data Redis` 를 사용하면 아주 쉽게 교체가 가능했다.
> Spring Data JPA, Spring Data MongoDB, Spring Data Redis등 `Spring Data의 하위 프로젝트들` 은 findAll(), save() 등을 **동일한 인터페이스** 로 가지고 있기 때문에 **저장소를 교체해도 기본적인 기능이 변하지 않는다.**

<br>

### JPA 동작 과정

![image](https://github.com/user-attachments/assets/63486897-93a0-44db-ae43-0c51e833bf09)

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
    기존: 필드 변경 시 모든 SQL 을 수정해야 한다.
    JPA: **`필드만`** 추가하면 된다. SQL 은 JPA 가 처리하기 때문에 손댈 것이 없다.

4. **`Object와 RDB`** 간의 패러다임 불일치 해결


<br>

# 4. Hibernate 특징

### JPA Hiberante

Hibernate 는 JPA 구현체의 한 종류이다.

JPA 는 DB 와 자바 객체를 mapping 하기 위한 인터페이스(API)를 제공하고 JPA 구현체(Hibernate) 는 이 인터페이스를 구현한 것이다.

Hibernate 외에도 `EclipseLink, DataNucleus, OpenJPA, TopLink Essentials` 등이 있다.

![image](https://github.com/lielocks/WIL/assets/107406265/a151e854-7b8f-4a60-bf73-5c69cee5e37f)

+ Hibernate 가 SQL을 직접 사용하지 않는다고 해서 JDBC API를 사용하지 않는다는 것은 아니다.

  + `Hibernate 가 지원하는 메서드 내부` 에서는 **JDBC API** 가 동작하고 있으며, 단지 *개발자가 직접 SQL을 직접 작성하지 않을 뿐* 이다.

+ **HQL(Hibernate Query Language)** 이라 불리는 매우 강력한 쿼리 언어를 포함하고 있다.

  + HQL은 SQL과 매우 비슷하며 추가적인 컨벤션을 정의할 수도 있다.

  + HQL은 완전히 **`객체 지향적`** 이며 이로써 `상속, 다형성, 관계` 등의 객체지향의 강점을 누릴 수 있다.

  + HQL은 **쿼리 결과로 객체를 반환** 하며 프로그래머에 의해 `생성` 되고 `직접적으로 접근` 할 수 있다.

  + HQL은 SQL에서는 지원하지 않는 **`페이지네이션`** 이나 **`동적 프로파일링`** 과 같은 향상된 기능을 제공한다.

  + HQL은 여러 테이블을 작업할 때 **명시적인 join을 요구하지 않는다.**

<br>

### 영속성

`데이터를 생성한 프로그램이 종료` 되어도 **사라지지 않는 데이터** 의 특성을 말한다.

영속성을 갖지 않으면 데이터는 **memory 에서만 존재** 하게 되고 프로그램이 종료되면 해당 데이터는 **모두 사라지게 된다.**

그래서 우리는 데이터를 파일이나 DB 에 영구 저장함으로써 데이터에 영속성을 부여한다.

<br>

### Persistence Layer

프로그램의 아키텍처에서 **데이터에 영속성을 부여해주는 계층** 을 말한다.

JDBC 를 이용해 직접 구현이 가능하나 보통은 `Persistence Framework` 를 사용한다.

![image](https://github.com/lielocks/WIL/assets/107406265/1149e979-6e8e-460b-b27c-b3b53da86eaa)

**프레젠테이션 계층 (Presentation layer)** - `UI 계층 (UI layer)` 이라고도 함

**애플리케이션 계층 (Application layer)** - `서비스 계층 (Service layer)` 이라고도 함

**비즈니스 논리 계층 (Business logic layer)** - `도메인 계층 (Domain layer)` 이라고도 함

**데이터 접근 계층 (Data access layer)** - `영속 계층 (Persistence layer)` 이라고도 함

<br>

**Persistence Framework**

JDBC 프로그래밍의 복잡함이나 번거로움 없이 *간단한 작업만으로* DB 와 연동되는 시스템을 빠르게 개발할 수 있고 안정적인 구동을 보장한다.

Persistence Framework는 `SQL Mapper` 와 `ORM` 으로 나눌 수 있다.

<br>

### JPA 에서의 영속성

![image](https://github.com/lielocks/WIL/assets/107406265/32de5b5a-24ef-423c-9289-c7a0482fbdca)

JPA의 핵심 내용은 엔티티가 영속성 컨텍스트에 포함되어 있냐 아니냐로 갈린다. 

JPA의 Entity Manager 가 활성화된 상태로 트랜잭션(@Transactional) 안에서 DB에서 데이터를 가져오면 이 데이터는 영속성 컨텍스트가 유지된 상태이다. 
이 상태에서 해당 데이터 값을 변경하면 트랜잭션이 끝나는 시적에 해당 테이블에 변경 내용을 반영하게 된다. 

따라서 우리는 엔티티 객체의 필드 값만 변경해주면 별도로 update() 쿼리를 날릴 필요가 없게 된다! 

이 개념을 Dirty Checking 이라고 한다.

Spring data jpa 를 사용하면 기본으로 Entity Manager 가 활성화되어있는 상태이다.

> **Persistence Context**
> 
> entity 를 담고 있는 **집합**
>
> JPA 는 **`영속 컨텍스트에 속한 entity`** 를 DB에 반영한다. Entity 를 검색, 삭제, 추가 하게 되면 영속 컨텍스트의 내용이 DB 에 반영된다.
>
> `Persistence Context` 는 직접 접근이 불가능하고 **`Entity Manager 를 통해서만`**  접근이 가능하다.

<br>

### JPA 성능 최적화

기본적으로 `중간 계층` 이 있는 경우 아래의 방법으로 성능을 개선할 수 있는 기능이 존재한다.

1. 모아서 쓰는 **버퍼링** 기능

2. 읽을 때 쓰는 **캐싱** 기능

JPA 도 JDBC API 와 DB 사이에 존재하기 때문에 위의 두 기능이 존재한다.

1. **1차 캐시와 동일성(identity) 보장 - Caching 기능**
   
`같은 transaction` 안에서는 `같은 entity` 를 반환 - 약간의 조회 성능 향상 (크게 도움 X)

```java
    String memberId = "100";
    
    Member m1 = jpa.find(Member.class, memberId); // SQL
    
    Member m2 = jpa.find(Member.class, memberId); // 캐시 (SQL 1번만 실행, m1을 가져옴)
    
    println(m1 == m2) // true
```

결과적으로, **SQL 을 한 번만** 실행한다.

DB Isolation Level 이 Read Commit 이어도 애플리케이션에서 `Repeatable Read 보장`

<br>

2. **Transaction 을 지원하는 쓰기 지연(transactional write-behind) - Buffering 기능**
   
**INSERT**

```java
/** 1. transaction 을 commit 할 때까지 INSERT SQL 을 모음 */

transaction.begin(); // [Transaction] start

em.persist(memberA);

em.persist(memberB);

em.persist(memberC);

// -- 여기까지 INSERT SQL 을 DB 에 보내지 않는다.

// Commit 하는 순간 DB 에 INSERT SQL 을 모아서 보낸다. --

/** 2. JDBC BATCH SQL 기능을 사용해서 한번에 SQL 전송 */

transaction.commit(); // [Transaction] commit
```

+ **`[트랜잭션]을 commit`** 할 때까지 `INSERT SQL` 을 **memory 에 쌓는다.**

  이렇게 하지 않으면 `DB 에 INSERT Query 를 날리기 위한 네트워크를 3번` 타게 된다.

+ **`JDBC Batch SQL`** 기능을 사용해서 **한 번에 SQL 을 전송** 한다.

  JDBC Batch 를 사용하면 코드가 굉장히 지저분해진다.

  **지연 로딩 전략(Lazy Loading)** 옵션을 사용한다.

<br>

**UPDATE**

```java
/** 1. UPDATE, DELETE로 인한 ROW Lock 시간 최소화 */

transaction.begin(); // [Transaction] 시작

changeMember(memberA);

deleteMember(memberB);

비즈니스_로직_수행(); // Business logic 수행 동안 DB row lock 이 걸리지 않는다.

// Commit 하는 순간 DB 에 UPDATE, DELETE SQL 을 보낸다.

/** 2. Transaction commit 시 UPDATE, DELETE SQL 실행하고, 바로 commit */

transaction.commit(); // [Transaction] commit
```

+ UPDATE, DELETE 로 인한 ROW Lock 시간 최소화

+ Transaction commit 시 UPDATE, DELETE SQL 실행하고, 바로 commit

<br>

Hibernate 를 사용하면 위의 문제들을 해결할 수 있습니다.

그리고 항상 완벽한 기술은 없듯이 Hibernate 에도 단점이 존재하는데, 지금부터 Hibernate 의 장단점을 알아보겠습니다.

<br>

### 장점

**1. 생산성**

+ Hibernate 는 SQL 을 직접 사용하지 않고, *메소드 호출만으로 query 가 수행* 된다.

  즉, 반복적인 SQL 작업과 CRUD 작업을 직접 하지 않으므로 생산성이 매우 높아진다.

<br>

**2. 유지보수**

+ 테이블 컬럼이 변경되었을 경우, Mybatis 에서는 관련 DAO 의 파라미터, 결과, SQL 등을 모두 확인하여 수정해야 하지만

  JPA 는 JPA 가 이런 일들을 대신 해주기 때문에 유지보수 측면에서 좋다.

<br>

**3. 객체지향적 개발**

+ 객체지향적으로 데이터를 관리할 수 있기 때문에 비즈니스 로직에 집중할 수 있다.

  로직을 쿼리에 집중하기 보다 **객체 자체** 에 집중할 수 있다.

<br>

**4. 특정 벤더에 종속적이지 않다.**

+ 여러 DB 벤더(MySQL, ORACLE 등 . .)마다 SQL 사용이 조금씩 다르기 때문에 어플리케이션 개발 시 처음 선택한 DB 를 나중에 바꾸는 것은 매우 어렵다.

  하지만 JPA는 추상화된 데이터 접근 계층을 제공하기 때문에 특정 벤더에 종속적이지 않다.

+ 설정 파일에서 JPA 에게 어떤 DB 를 사용하고 있는지 알려주기만 하면 얼마든지 DB 를 변경할 수 있다.

<br>

### 단점

**1. 어렵다.**

+ 많은 내용이 감싸져 있기 때문에 JPA를 잘 사용하기 위해서는 알아야 할 것이 많다.

+ 잘 이해하고 사용하지 않으면 데이터 손실이 있을 수 있다.

<br>

**2. 성능**

+ 메소드 호출로 쿼리를 실행하는 것은 내부적으로 많은 동작이 있다는 것을 의미하므로, 직접 SQL을 호출하는것보다 성능이 떨어질 수 있다.
  실제로 초기의 ORM은 쿼리가 제대로 수행되지 않았고, 성능도 좋지 못했다고 한다.
  그러나 지금은 많이 발전하고 있고, 좋은 성능을 보여주고 있다.

<br>

**3. 세밀함이 떨어진다.**

+ 메소드 호출로 SQL 을 실행하기 때문에 세밀함이 떨어진다.
  또한 객체간의 매핑(Entity Mapping) 이 잘못되거나 JPA 를 잘못 사용하여 의도하지 않은 동작을 할 수도 있다.

+ 복잡한 통계 분석 쿼리를 메소드 호출로 처리하는 것은 힘들다.

+ 이것을 보완하기 위해 JPA에서는 SQL과 유사한 기술인 JPQL을 지원한다.
  SQL 자체 쿼리를 작성할 수 있도록 지원도 하고 있다.

<br>

# 5. 정리

### Hibernate 와 Spring Data JPA 의 차이점

Hibernate 는 JPA 구현체이고, Spring Data JPA 는 **JPA 에 대한 데이터 접근의 추상화** 라고 말할 수 있습니다.

Spring Data JPA 는 GenericDao 라는 커스텀 구현체를 제공합니다. 

이것의 메소드의 명칭으로 JPA 쿼리들을 생성할 수 있습니다.
 
Spring Data 를 사용하면 Hibernate, Eclipse Link 등의 JPA 구현체를 사용할 수 있습니다.

또 한가지는 @Transaction 어노테이션을 통해 트랜잭션 영역을 선언하여 관리할 수 있습니다.
 
Hibernate 는 낮은 결합도의 이점을 살린 ORM 프레임워크로써 API 레퍼런스를 제공합니다.

여기서 반드시 기억해야할 점은 Spring Data JPA 는 항상 Hibernate 와 같은 **JPA 구현체** 가 필요합니다.

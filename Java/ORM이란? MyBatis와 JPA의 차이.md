오늘은 개발을 편리하게 해주는 **Object Mapping 기술인 `MyBatis`** 와 **ORM(Object Relational Mapping) 기술인 `JPA`** 에 대해 알아보도록 하겠습니다.


<br>


## 1. ORM(Object Relation Mapping)이란?

**ORM** 이란 **객체(Object) 와 DB 의 테이블을 Mapping 시켜 RDB 테이블을 객체지향적으로 사용** 하게 해주는 기술이다.

*`RDB 테이블` 은 객체지향적 특성(상속, 다형성, 레퍼런스) 등이 없어서* Java 와 같은 객체지향적 언어로 접근하는 것이 쉽지 않다.

이러한 상황에서 **ORM** 을 사용하면 보다 **객체지향적으로 RDB 를 사용** 할 수 있다.

**`Java 에서 사용하는 대표적인 ORM`** 으로는 **JPA** 와 **그의 구현체인 Hibernate** 가 있다.

JPA(Java Persistence API) 가 등장하기 이전에는 MyBatis 라는 Object Mapping 기술을 이용하였는데,
*MyBatis 는 Java 클래스 코드와 직접 작성한 SQL 코드를 Mapping 시켜주어야 했다.* 

반면 **JPA 와 같은 ORM 기술** 은 **객체가 DB 에 연결되기 때문에, SQL 을 직접 작성하지 않고 표준 인터페이스 기반으로 처리한다** 는 점에서 차이가 있다.

Google Trend 조사에 따르면 전 세계적으로 MyBatis << Hibernate 를 많이 사용하는 추세이다. 

하지만 우리나라에서는 아직까지도 MyBatis를 사용하는 곳이 상당히 많다.

![image](https://github.com/lielocks/WIL/assets/107406265/1d1e810a-8a5e-4d0c-9856-cb3ef0a96846)


<br>


### [ MyBatis VS Hibernate 비교 ]

+ 우리나라의 시장은 대부분이 SI 또는 금융이기 때문에 비지니스가 매우 복잡하다.

  또한 안정성과 속도를 중요시하기 때문에 직접 작성하는 Mybatis을 사용하는 것이 나을 수 있다.

+ 하지만 MyBatis 는 쿼리를 직접 작성해야 하기 때문에 Hibernate 에 능숙해진다면 생산성을 상당히 높힐 수 있다.
  
+ JPA 를 사용하면 통계나 동적 쿼리 같은 복잡한 쿼리를 처리하는 것이 어려우므로 QueryDSL을 함께 이용한다.

+ MyBatis와 Hibernate 모두 각각의 특징을 갖고 있기 때문에 상황에 맞는 적합한 ORM을 사용하는 것이 중요하다.


<br>



## 2. ORM 활용 예제

### [ ORM을 사용하지 않은 코드 - JDBC의 활용 ]

ORM 을 사용하지 않은 코드는 아래와 같다. 

아래의 코드는 사용자 데이터를 추가하는 코드인데, ***Java Object 와 RDB 가 Mapping 되지 않기 때문에*** 각각의 query parameter 에 **사용자 데이터를 직접 Set 해서 DB 에 저장** 하고 있다. 

이러한 코드는 상당히 가독성이 떨어지며 작업이 불편한데, **ORM** 을 사용하면 보다 편리하게 작업을 할 수 있다.

```java
public void insertUser(User user){
    String query = " INSERT INTO user (email, name, pw) VALUES (?, ?, ?)";

    PreparedStatement preparedStmt = conn.prepareStatement(query);
    preparedStmt.setString (1, user.getEmail());
    preparedStmt.setString (2, user.getName());
    preparedStmt.setString (3, user.getPW());

    // execute the preparedstatement
    preparedStmt.execute();
}
```


<br>



### [ MyBatis를 사용한 코드 ]

MyBatis 는 오픈소스 라이브러리이다. 

하지만 spring 은 spring-data 프로젝트를 통해 자주 사용되는 라이브러리들을 편리하게 이용하도록 도와주는 프로젝트를 진행하고 있는데, mybatis 역시 spring-data-mybatis 프로젝트가 존재한다. 

아래의 내용들은 `spring-data-mybatis` 를 기반으로 작성된 내용이다.

MyBatis 는 기본적으로 Database 처리를 위한 **Mapper 인터페이스** 와 **Mapper.xml 파일** 을 사용한다. 

`Repository 에서 메소드의 이름` 은 **queryId 에 매핑** 되며 **xml 파일에서 해당 쿼리의 id 를 기준으로 쿼리를 실행** 한다.

```java
@Mapper
@Repository
public interface UserMapper {
    insertUser(User user);
}
```

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">

<mapper namespace="mang.blog.user.userMapper">

    <insert id="insertUser" parameterType = "user">
        INSERT USER(
            email, name, pw, 
        )VALUES(
            #{email}, #{name}, #{pw}
        )
    </insert>

</mapper>
```


<br>


### [ JPA를 사용한 코드 ]

Spring 은 역시 JPA를 위해 `spring-data-jpa` 라는 프로젝트를 제공하고 있다. 

아래의 내용은 spring-data-jpa 를 기반으로 작성한 내용이다.

**JPA** 는 **Java 객체와 테이블을 매핑시키는 ORM 기술** 이므로 다음과 같이 Java 클래스에 매핑 정보를 넣어주어야 한다.

```java
@Entity
@Table(name = "user")
@Getter
@Builder
@NoArgsConstructor(force = true)
@AllArgsConstructor
public class User extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String email;
    private String name;
    private String pw;
}
```


<br>


그러면 다음과 같이 DB에 데이터를 저장하기 위한 **Repository** 를 구현할 수 있다.

```java
public interface UserRepository extends JpaRepository <User, Long> {

}
```

JpaRepository 는 기본적인 CRUD 를 제공하고 있으므로 우리는 다음과 같이 UserRepository 의 save 만 호출해주면 데이터가 저장된다. 

그리고 findById 를 이용하면 해당 객체를 꺼낼 수 있다.

```java
@Service
@RequiredArgsConstructor
@Transactional(readonly = true)
public class UserService {

    private final UserRepository userRepository;

    @Transactional
    public User findUserAndUpdateName(Long id) {
        User user = userRepository.findById(id);
        user.setName("변경된 이름");
    }
}
```

위의 예제에는 id 값으로 사용자를 조회하고 갱신을 해주는데, 별도의 **Update 쿼리를 해주고 있지 않다.**

이러한 이유는 JPA 라는 ORM 기술에 의해 **DB 에서 조회한 데이터들이 `객체로 연결`** 되어 있고, **객체의 값을 수정하는 것 = DB의 값을 수정하는 것** 이기 때문이다. 

> ***해당 메소드가 종료될 때*** **`Update 쿼리`** 가 **JPA의 값이 변경 유무를 감지하는 Dirty Checking 이후에 나가게 된다.** 

이를 통해 **JPA** 는 MyBatis 와 달리 ***쿼리를 직접 작성지 않음*** 을 확인할 수 있다.


<br>



## 3. MyBatis보다 JPA를 사용해야 하는 이유

### [ MyBatis보다 JPA를 사용해야 하는 이유 ]

이제는 MyBatis 가 아닌 **JPA** 를 이용해야 하는 시대가 왔다고 생각한다. 

왜냐하면 **JPA** 를 사용하면 MyBatis 에 비해 다음과 같은 장점들을 누릴 수 있기 때문이다.

1. Entity 에 맞는 table 생성 + DB 생성을 편리

2. **객체 지향 중심** 의 개발

3. 테스트 작성이 용이

4. 기본적인 CRUD 자동화

5. 복잡한 쿼리는 **QueryDSL** 을 사용해 처리


<br>


**Entity 에 맞는 table 생성 + DB 생성을 편리**

JPA 는 설정에 따라 **`mapping 된 객체`를 바탕으로 table 을 자동으로 만들어준다.**

물론 자동 생성되는 이름이 가독성이 떨어져서 이대로 사용하기에는 부족하지만, 그래도 직접 *모든 DDL 을 작성하는 것보다는* 편리함을 제공해준다. 


<br>



**객체 지향 중심의 개발**

JPA 는 객체를 이용하면 우리는 table 에 mapping 되는 class 를 더욱 객체 지향적으로 개발할 수 있다. 

그리고 이러한 방향은 객체 지향 언어인 Java에 더욱 잘 맞는다.


<br>



**테스트 작성이 용이**

JPA 를 사용하면 얻을 수 있는 큰 장점 중 하나가 바로 테스트를 작성하기 쉬워진다는 것이다.

Repository 계층은 데이터베이스와 데이터를 주고 받는 계층이므로 단위 테스트로 작성하기 보다 **DB 와 연결하여 실제 쿼리를 날리는 `통합 테스트`**로 진행하는 것이 좋다. 

위에서 살펴보았듯 JPA 는 table 을 자동으로 만들어주므로 테스트를 작성하기에 매우 좋다.

Spring 은 Repository 테스트를 위한 `@DataJpaTest` 를 제공하고 있는데, @DataJpaTest를 이용하면 기본적으로 Inmemory DB(h2)로 연결이 된다. 

그리고 table 생성 옵션을 주면 우리는 순쉽게 Repository 계층을 테스트할 수 있다.

```java
@JpaTestConfig
class UserRepositoryTest {

    @Autowired
    private UserRepository userRepository;

    @Test
    public void selectUserByEmail() {
        // given
        final String email = "test@mangkyu.com"

        // when
        final User result userRepository.findByEmail(email);

        // then
        assertThat(result.getEmail()).isEqualTo(email);
    }
}
```


<br>


**기본적인 CRUD 자동화**

JPA 는 **`table 과 객체를 mapping` 시키는 기술이므로 기본적인 CRUD** 가 제공된다. 

MyBatis 를 이용한다면 간단한 CRUD 쿼리들도 모두 작성해주어야 하는 것에 반해 JPA 를 이용하면 생산성을 높일 수 있다.
 


<br>



**복잡한 쿼리는 QueryDSL을 사용해 처리**

MyBatis 의 장점 중 하나는 직접 쿼리를 작성하므로 복잡한 쿼리를 다루기 유용하다는 것입니다. 

실제로 JPA를 이용하다보면 동적 쿼리를 처리하기가 매우 어렵다.

하지만 이러한 경우에는 MyBatis 를 이용하기보다 **QueryDSL 이라는 오픈소스** 를 사용한다면 문제를 해결할 수 있다. 

아래의 코드는 QueryDSL 을 이용한 예시이며 java 언어로 매우 직관적인 쿼리를 작성할 수 있다는 장점이 있다.

```java
@Repository
@RequiredArgsConstructor
public class QuizRepositoryImpl {

    private final JPAQueryFactory query;

    @Override
    public User search(final String email) {
        final QUser qUser = QUser.user;

        final User user = query.selectFrom(qUser)
                .where(qUser.email.equalsIgnoreCase(email))
                .fetch();
        return user;
    }
}
```


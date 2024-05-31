# 낙관적 락, 비관적 락에 대해

JPA 를 사용하여 DB 와 연결된 어플리케이션을 개발할 때, **동시성 처리** 와 관련된 이슈가 발생할 수 있다.

이러한 이슈를 해결하기 위한 방법 중 하나로 Lock 을 사용하는 것이다.

DB 의 row 단위 Lock 을 살펴보면 Shared Lock, Exclusive Lock 두가지가 있다.

<br>

## 낙관적 락 Optimistic Lock

낙관적 락은 충돌이 거의 발생하지 않을 것이라고 가정하고, 충돌이 발생한 경우에 대비하는 방식이다.

낙관적 락은 JPA 에서 Version 속성을 이용하여 구현할 수 있다.

낙관적 락의 특징으로는 충돌 발생 확률이 낮고, 지속적인 lock 으로 인한 성능 저하를 막을 수 있다.

<br>

### 1. Entity

```java
@Entity
public class SampleEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Version
    private Long version;

    private String data;
}
```

<br>

### 2. Repository

```java
@Repository
public interface SampleEntityRepository extends JpaRepository<SampleEntity, Long> {
}
```

<br>

### 3. Service

```java
@Service
public class SampleEntityService {

    @Autowired
    private SampleEntityRepository sampleEntityRepository;

    public SampleEntity updateData(Long id, String newData) {
        SampleEntity sampleEntity = sampleEntityRepository.findById(id).orElseThrow();
        sampleEntity.setData(newData);
        return sampleEntityRepository.save(sampleEntity);
    }
}
```

작동 원리로는 SampleEntity 클래스에 @Version annotation 을 이용하여 version 필드로 지정한다.

데이터를 수정할 때 같은 id 값이지만 다른 사용자에 의한 변경이 발생하면 version 값이 다르게 되고, 이때 예외가 발생하므로 충돌로부터 안전하게 처리할 수 있다.

<br>

### 낙관적 락 LockModeType

+ **OPTIMISTIC**

  + Transaction 시작 시 Version 점검이 수행되고, Transaction 종료 시에도 Version 점검이 수행된다.
 
  + Version 이 다르면 Transaction 이 rollback 된다.

+ **OPTIMISTIC_FORCE_INCREMENT**

  + 낙관적 락을 사용하면서 추가로 Version 을 강제로 증가시킨다.
 
  + 단순 Read 를 하는 경우에도 Version 을 update 한다.
 
  + **`관계를 가진 다른 Entity 가 수정`** 되면 Version 이 변경된다. (ex 댓글이 수정되면 게시글도 Version 이 변경된다)
 
+ **READ**

  + OPTIMISTIC 과 동일하다.
 
+ **WRITE**

  + OPTIMISTIC_FORCE_INCREMENT 과 동일하다.
 
+ **NONE**

  + Entity 에 @Version 이 적용된 필드가 있으면 낙관적 락을 적용한다.

<br>

## 비관적 락 Pessimistic Lock

비관적 락은 충돌이 발생할 확률이 높다고 가정하여, 실제로 데이터에 엑세스 하기 전에 먼저 Lock 을 걸어 충돌을 예방하는 방식이다.

비관적 락은 JPA 에서 제공하는 **`LockModeType`** 을 사용하여 구현할 수 있다.

<br>

### 1. Repository

```java
@Repository
public interface SampleEntityRepository extends JpaRepository<SampleEntity, Long> {
}
```

<br>

### 2. Service

```java
@Service
public class SampleEntityService {
    @Autowired
    private SampleEntityRepository sampleEntityRepository;

    @Autowired
    private EntityManager entityManager;

    @Transactional
    public SampleEntity updateDataWithPessimisticLock(Long id, String newData) {
        SampleEntity sampleEntity = entityManager.find(SampleEntity.class, id, LockModeType.PESSIMISTIC_WRITE);
        sampleEntity.setData(newData);
        entityManager.flush();
        return sampleEntity;
    }
}
```

위 코드를 설명해보면 EntityManager 의 find 메서드에 **Lock type(LockModeType.PESSIMISTIC_WRITE)** 을 지정하여 데이터에 Lock 을 걸어두고,

변경 작업이 끝난 후에 Lock 을 해제한다.

이를 통해 다른 transaction 이 동시에 수정할 수 없어 동시성 처리 이슈를 방지할 수 있게 된다.

<br>

### 비관적 락 LockModeType

+ **PESSIMISTIC_READ**

  + 다른 Transaction 에서 읽기만 가능 (Share Lock)

<br>

+ **PESSIMISTIC_WRITE**

  + 다른 Transaction 에서 읽기도 못하고 쓰기도 못함 (Exclusive Lock)
 
  + DB 의 Exclusive Lock 을 사용하는 방법이다. Version 필드를 사용하지 않는다.

    + `select ... for update` 형태인 것을 볼 수 있다.

  ![image](https://github.com/lielocks/WIL/assets/107406265/0845215b-1f8a-46bf-9f8a-42426c1984ab)

  1. 첫번째 Transaction 이 Exclusive Lock 을 획득한다.
 
  2. 두번째 Transaction 이 Exclusive Lock 획득하려 하지만 첫번째 Transaction 이 Lock 을 가지고 있기 때문에 대기상태가 된다.
 
  3. 첫번째 Transaction 이 종료된 이후에야 두번째 Transaction 이 Lock 을 획득하고 update 를 처리한다.
 
<br>

+ **PESSIMISTIC_FORCE_INCREMENT**

  + 다른 Transaction 에서 읽기도 못하고 쓰기도 못함 + 추가적으로 Versioning 을 수행한다.

    + mysql 8.0 이상인 경우 for update 에 **`no wait`** 추가 된다.
   
  + Read 만 하는 경우에도 Version 을 update 한다.
    

<br>

### 낙관적 락 Optimistic Lock 장단점

+ 장점 : 리소스 경쟁이 적고 Lock 으로 인한 성능 저하가 적다.

+ 단점 : 충돌 발생 시 처리해야 할 외부 요인이 존재한다.

<br>

### 비관적 락 Pessimistic Lock 장단점

+ 장점 : 충둘 발생을 미연에 방지하고 데이터의 일관성을 유지할 수 있다.

+ 단점 : 동시 처리 성능 저하 및 교착상태(DeadLock) 발생 가능성이 있다.

<br>

**충돌 발생 확률이 낮고 성능 저하를 예방** 하려면 **`낙관적 락`** 을 사용하면 되고,

**충돌을 미연에 방지하고 데이터의 일관성을 유지** 하려면 **`비관적 락`** 을 사용하면 된다.

선택한 Lock 방식에 따라 JPA 를 효과적으로 사용하여 동시성 처리 이슈를 해결할 수 있다.

이번에는 트랜잭션 격리 수준(Isolation Level)에 대해 알아보도록 하겠습니다. 

아래의 내용은 RealMySQL과 MySQL 공식 문서 등을 참고하여 작성하였으며, 모든 내용은 InnoDB를 기준으로 설명합니다. 

해당 내용을 완벽하기 이해하기 위해서는 MySQL이 제공하는 스토리지 엔진 수준의 락에 대해 알고 있어야 합니다.

<br>

## 1. 트랜잭션의 격리 수준(Transaction Isolation Level)

트랜잭션의 격리 수준(Isolation Level) 이란 **여러 트랜잭션이 동시에 처리될 때, 특정 트랜잭션이 `다른 트랜잭션에서 변경하거나 조회하는 데이터` 를 볼 수 있게 허용할지 여부** 를 결정하는 것이다. 

트랜잭션의 격리 수준은 *격리(고립) 수준이 높은 순서대로* SERIALIZABLE, REPEATABLE READ, READ COMMITTED, READ UNCOMMITED가 존재한다. 

참고로 아래의 예제들은 모두 `자동 커밋(AUTO COMMIT)이 false` 인 상태에서만 발생한다.

+ SERIALIZABLE

+ REPEATABLE READ

+ READ COMMITTED

+ READ UNCOMMITED

<br>


### [SERIALIZABLE]

SERIALIZABLE 은 *가장 엄격한* 격리 수준으로, 이름 그대로 **트랜잭션을 순차적으로 진행** 시킨다. 

SERIALIZABLE 에서 **여러 트랜잭션이 동일한 레코드에 동시 접근할 수 없으므로,** 어떠한 데이터 부정합 문제도 발생하지 않는다. 

하지만 트랜잭션이 순차적으로 처리되어야 하므로 **`동시 처리 성능이 매우 떨어진다.`**

MySQL 에서 `SELECT FOR SHARE/UPDATE` 는 대상 레코드에 각각 **`읽기/쓰기 잠금`** 을 거는 것이다. 

하지만 순수한 SELECT 작업은 아무런 레코드 잠금 없이 실행되는데, 잠금 없는 일관된 읽기(Non-locking consistent read)란 순수한 SELECT 문을 통한 잠금 없는 읽기를 의미하는 것이다.

하지만 **SERIALIZABLE** 격리 수준에서는 **순수한 SELECT 작업에서도 대상 레코드에 넥스트 키 락을 읽기 잠금(공유락, Shared Lock)으로 건다.** 

따라서 한 트랜잭션에서 넥스트 키 락이 걸린 레코드를 *다른 트랜잭션에서는 절대 추가/수정/삭제할 수 없다.* 

SERIALIZABLE 은 가장 안전하지만 가장 성능이 떨어지므로, 극단적으로 안전한 작업이 필요한 경우가 아니라면 사용해서는 안된다.
 
<br>


### [REPEATABLE READ]

일반적인 `RDBMS` 는 **변경 전의 레코드를 언두 공간에 백업** 해둔다. 

그러면 ***변경 전/후 데이터가 모두 존재*** 하므로,

> *동일한 레코드에 대해 여러 버전의 데이터* 가 존재한다고 하여 이를 **`MVCC(Multi-Version Concurrency Control, 다중 버전 동시성 제어)`** 라고 부른다. 

MVCC 를 통해 트랜잭션이 rollback 된 경우에 데이터를 복원할 수 있을 뿐만 아니라, 서로 다른 트랜잭션 간에 접근할 수 있는 데이터를 세밀하게 제어할 수 있다. 

*각각의 트랜잭션* 은 `순차 증가하는 고유한 트랜잭션 번호` 가 존재하며, *백업 레코드* 에는 `어느 트랜잭션에 의해 백업되었는지 트랜잭션 번호를 함께 저장` 한다. 

그리고 해당 데이터가 불필요해진다고 판단하는 시점에 주기적으로 백그라운드 thread 를 통해 삭제한다.
 
REPEATABLE READ 는 MVCC 를 이용해 **한 트랜잭션 내에서 동일한 결과를 보장하지만, 새로운 레코드가 추가되는 경우에 부정합** 이 생길 수 있다. 

이러한 REPEATABLE READ의 동작 방식을 자세히 살펴보도록 하자.

예를 들어 트랜잭션을 시작하고, id = 50 인 레코드를 조회하면 1건 조회되는 상황이라고 하자. 

아직 트랜잭션은 종료되지 않았다. 

참고로 트랜잭션을 시작한 SELECT와 그렇지 않은 SELECT의 차이는 뒤에서 다시 살펴보도록 하자.

![image](https://github.com/lielocks/WIL/assets/107406265/4a331429-7d89-42ad-85c0-98dee1741afa)

그리고 이때 다른 사용자 A의 트랜잭션에서 id=50인 레코드를 갱신하는 상황이라고 하자. 

그러면 MVCC를 통해 기존 데이터는 변경되지만, 백업된 데이터가 언두 로그에 남게 된다.

![image](https://github.com/lielocks/WIL/assets/107406265/f17bcd09-c673-4398-b7e3-5203413a9f6e)

이전에 사용자 B가 데이터를 조회했던 트랜잭션은 아직 종료되지 않은 상황에서, 사용자 B가 다시 한번 동일한 SELECT 문을 실행하면 어떻게 될까? 

그 결과는 다음과 같다.

![image](https://github.com/lielocks/WIL/assets/107406265/7aef00ab-53fb-4c12-9986-5553f957e5ea)

`사용자 B의 트랜잭션은(10)` `사용자 A의 트랜잭션(12)` 이 시작하기 전에 *이미 시작된 상태* 다. 

이때 **REPEATABLE READ** 는 **트랜잭션 번호를 참고하여 `자신보다 먼저 실행된 트랜잭션의 데이터만` 을 조회한다.** 

만약 *테이블에 자신보다 이후에 실행된 트랜잭션의 데이터가 존재한다면* **언두 로그** 를 참고해서 데이터를 조회한다.

따라서 사용자 A의 트랜잭션이 시작되고 커밋까지 되었지만, **해당 A 트랜잭션(12)는 현재 B 트랜잭션(10)보다 나중에 실행되었기 때문에 조회 결과로 기존과 동일한 데이터** 를 얻게 된다. 

즉, **REPEATABLE READ** 는 `어떤 트랜잭션이 읽은 데이터를 다른 트랜잭션이 수정하더라도` **동일한 결과를 반환** 할 것을 보장해준다.
 
앞서 설명하였듯 REPEATABLE READ 는 `새로운 레코드의 추가까지는 막지 않는다` 고 하였다. 

따라서 *SELECT 로 조회한 경우* **`트랜잭션이 끝나기 전에 다른 트랜잭션에 의해 추가된 레코드가 발견`** 될 수 있는데, 이를 **유령 읽기(Phantom Read)** 라고 한다. 

하지만 MVCC 덕분에 일반적인 조회에서 `유령 읽기(Phantom Read)는 발생하지 않는다.`

왜냐하면 *자신보다 나중에 실행된 트랜잭션이 추가한 레코드는 무시* 하면 되기 때문이다. 

이러한 상황을 그림으로 표현하면 다음과 같다.

![image](https://github.com/lielocks/WIL/assets/107406265/62798f34-fac4-4f36-baec-846037d8c9a5)

그렇다면 언제 `유령 읽기` 가 발생하는 것일까? 바로 `잠금이 사용되는 경우` 이다. 

**MySQL** 은 다른 RDBMS와 다르게 특수한 **갭 락** 이 존재하기 때문에, 동작이 다른 부분이 있으므로 일반적인 *RDBMS 경우부터* 살펴보도록 하자.

<br>


마찬가지로 사용자 B가 먼저 데이터를 조회하는데, 이번에는 `SELECT FOR UPDATE` 를 이용해 **쓰기 잠금** 을 걸었다. 

여기서 `SELECT … FOR UPDATE` 구문은 **베타적 잠금(비관적 잠금, 쓰기 잠금)** 을 거는 것이다. 

**읽기 잠금** 을 걸려면 `SELECT FOR SHARE` 구문을 사용해야 한다. 

*락은 트랜잭션이 commit 또는 rollback 될 때 해제된다.* 

그리고 *사용자 A가 새로운 데이터를 INSERT* 하는 상황이라고 하자. 

일반적인 `DBMS 에서는 갭락이 존재하지 않으므로` **id = 50인 레코드만 잠금** 이 걸린 상태이고, **사용자 A의 요청은 잠금 없이 즉시 실행** 된다. 

![image](https://github.com/lielocks/WIL/assets/107406265/21791212-8e33-4305-a74a-5f8f24f0f098)

이때 사용자 B가 *동일한 쓰기 잠금 쿼리로 다시 한번 데이터를 조회* 하면, 이번에는 `2건` 의 데이터가 조회된다. 

동일한 트랜잭션 내에서도 새로운 레코드가 추가되는 경우에 조회 결과가 달라지는데, 이렇듯 **다른 트랜젹션에서 수행한 작업에 의해 레코드가 안보였다 보였다 하는 현상** 을 **`Phantom Read(유령 읽기)`** 라고 한다. 

이는 ***다른 트랜잭션에서 새로운 레코드를 추가하거나 삭제하는 경우 발생*** 할 수 있다.

![image](https://github.com/lielocks/WIL/assets/107406265/57c7352c-8730-4ad0-b8ae-8125d421b595)

이 경우에도 `MVCC` 를 통해 해결될 것 같지만, ***두 번째 실행되는 SELECT FOR UPDATE 때문에 그럴 수 없다.*** 

왜냐하면 **`잠금있는 읽기`** 는 *데이터 조회가 언두 로그가 아닌 테이블에서 수행* 되기 때문이다. 

**`잠금있는 읽기`** 는 테이블에 변경이 일어나지 않도록 **테이블에 잠금을 걸고 테이블에서 데이터를 조회한다.**

잠금이 없는 경우처럼 언두 로그를 바라보고 언두 로그를 잠그는 것은 불가능한데, 그 이유는 ***언두 로그가 append only 형태이므로 잠금 장치가 없기 때문이다.***

따라서 `SELECT FOR UPDATE` 나 `SELECT FOR SHARE` 로 레코드를 조회하는 경우에는 언두 영역의 데이터가 아니라 **테이블의 레코드** 를 가져오게 되고, 이로 인해 **Phantom Read** 가 발생하는 것이다.
 

<br>


하지만 **MySQL 에는 갭 락** 이 존재하기 때문에 *위의 상황에서 문제가 발생하지 않는다.*

사용자 B 가 `SELECT FOR UPDATE` 로 데이터를 조회한 경우에 **MySQL** 은 **`id가 50인 레코드에는 레코드 락`** , **`id가 50보다 큰 범위에는 갭 락으로 넥스트 키 락`** 을 건다. 


<br>


> ***넥스트 키 락***
>
> Next Key Lock 은 **`갭 락 + 레코드 락`** 합친 잠금이다.
> 
> ![image](https://github.com/lielocks/WIL/assets/107406265/0e7b7872-c8c3-4c69-8bea-90f6e7d06a16)



<br>



따라서 *사용자 A가 id가 51인 member를 INSERT* 시도한다면, **B의 트랜잭션이 종료(커밋 또는 롤백)될 때 까지 기다리다가, 대기를 지나치게 오래 하면 락 타임아웃** 이 발생하게 된다.

![image](https://github.com/lielocks/WIL/assets/107406265/5d4fcecd-4f84-4b49-86a5-259d14de1c1a)

> 따라서 **일반적으로 MySQL의 REAPEATABLE READ 에서는 Phantom Read 가 발생하지 않는다.** 

*MySQL에서 Phantom Read가 발생하는 거의 유일한 케이스* 는 다음과 같다. 

사용자 B는 트랜잭션을 시작하고, *잠금없는 SELECT 문으로 데이터를 조회* 하였다. 

그리고 *사용자 A는 INSERT 문을 사용해 데이터를 추가* 하였다. 

이때 잠금이 없으므로 **바로 COMMIT** 된다. 

하지만 사용자 B가 `SELECT FOR UPDATE` 로 조회를 했다면, 언두 로그가 아닌 **테이블로부터 레코드를 조회하므로 Phantom Read** 가 발생한다.

![image](https://github.com/lielocks/WIL/assets/107406265/972726f6-0965-4922-b9a5-302f829be4a3)

<br>

하지만 이러한 케이스는 거의 존재하지 않으므로, ***MySQL 의 REPEATABLE READ 에서는 PHANTOM READ가 발생하지 않는다*** 고 봐도 된다. 

아래는 MySQL 기준으로 정리된 내용이다.

+ `SELECT FOR UPDATE` 이후 `SELECT` : 갭락 때문에 팬텀리드 X

+ `SELECT FOR UPDATE` 이후 `SELECT FOR UPDATE` : 갭락 때문에 팬텀리드 X

+ `SELECT` 이후 `SELECT` : MVCC 때문에 팬텀리드 X

+ `SELECT` 이후 `SELECT FOR UPDATE` : 팬텀 리드 O

<br>


마지막으로 *트랜잭션 내에서 실행되는 SELECT* 와 *트랜잭션 없이 실행되는 SELECT* 의 차이를 살펴보도록 하자. 

**REPEATABLE READ** 에서는 **`트랜잭션 번호`** 를 바탕으로 *실제 테이블 데이터와 언두 영역의 데이터 등을 비교* 하며 어떤 데이터를 조회할 지 판단한다. 

*즉, 트랜잭션 안에서 실행되는 SELECT 라면 항상 일관된 데이터를 조회하게 된다.* 

하지만 트랜잭션 없이 실행된다면, 데이터의 정합성이 깨지는 상황이 생길 수 있다. 

커밋된 데이터만을 보여주는 READ COMMITTED 수준에서는 둘의 차이가 거의 없다.

<br>


### [READ COMMITED]

READ COMMITTED 는 **`commit 된 데이터만 조회`** 할 수 있다. 

READ COMMITTED 는 *REPEATABLE READ 에서 발생하는 Phantom Read* 에 더해 **Non-Repeatable Read(반복 읽기 불가능) 문제까지** 발생한다.

예를 들어 사용자 A가 트랜잭션을 시작하여 어떤 데이터를 변경하였고, 아직 commit 은 하지 않은 상태라고 하자. 

그러면 테이블은 먼저 갱신되고, 언두 로그로 변경 전의 데이터가 백업되는데, 이를 그림으로 표현하면 다음과 같다.

![image](https://github.com/lielocks/WIL/assets/107406265/1b6945d3-16cc-4c6b-bc89-7ddcf4b2bbc8)

이때 `사용자 B가 데이터를 조회` 하려고 하면, **READ COMMITTED 에서는 커밋된 데이터만 조회** 할 수 있으므로, REPEATABLE READ 와 마찬가지로 `언두 로그에서 변경 전의 데이터를 찾아서 반환` 하게 된다. 

최종적으로 사용자 A가 트랜잭션을 commit 하면 **그때부터 다른 트랜잭션에서도 새롭게 변경된 값을 참조** 할 수 있는 것이다.

![image](https://github.com/lielocks/WIL/assets/107406265/4af39251-457b-4a57-b77a-98a4c476a968)

하지만 READ COMMITTED 는 **`Non-Repeatable Read(반복 읽기 불가능)`** 문제가 발생할 수 있다.

예를 들어 사용자 B가 트랜잭션을 시작하고 name = “Minkyu” 인 레코드를 조회했다고 하자. 

해당 조건을 만족하는 레코드는 아직 존재하지 않으므로 아무 것도 반환되지 않는다.

![image](https://github.com/lielocks/WIL/assets/107406265/38c3d6d2-c73c-46d0-ab78-3065c7dc4406)

그러다가 *사용자 A가 UPDATE 문을 수행하여 해당 조건을 만족하는 레코드가 생겼다고 하자.* 

사용자 A의 작업은 **commit 까지 완료된 상태** 이다. 

이때 *사용자 B가 다시 동일한 조건으로 레코드를 조회하면 어떻게 될까?* 

READ COMMITTED 는 **commit 된 데이터는 조회할 수 있도록 허용하므로 결과가 나오게 된다.**

![image](https://github.com/lielocks/WIL/assets/107406265/db72ac27-b7ec-45ed-a502-b93ba491854c)

READ COMMITTED 에서 **반복 읽기** 를 수행하면 **`다른 트랜잭션의 커밋 여부` 에 따라 조회 결과가 달라질 수 있다.** 

따라서 이러한 데이터 부정합 문제를 **Non-Repeatable Read(반복 읽기 불가능)** 라고 한다.

Non-Repeatable Read 는 일반적인 경우에는 크게 문제가 되지 않지만, *하나의 트랜잭션에서 동일한 데이터를 여러 번 읽고 변경하는 작업* 이 금전적인 처리와 연결되면 문제가 생길 수 있다. 

예를 들어 `어떤 트랜잭션에서는 오늘 입금된 총 합을 계산` 하고 있는데, **다른 트랜잭션에서 계속해서 입금 내역을 commit** 하는 상황이라고 하자. 

그러면 READ COMMITTED 에서는 같은 트랜잭션일지라도 ***조회할 때마다 입금된 내역이 달라지므로*** 문제가 생길 수 있는 것이다. 

따라서 격리 수준이 어떻게 동작하는지, 그리고 격리 수준에 따라 어떠한 결과가 나오는지 예측할 수 있어야 한다.

READ COMMITTED 수준에서는 *애초에 commit 된 데이터만 읽을 수 있기 때문에* `트랜잭션 내에서 실행되는 SELECT` 와 `트랜잭션 밖에서 실행되는 SELECT` 의 **차이가 별로 없다.**

<br>


### [READ UNCOMMITED]

READ UNCOMMITTED 는 **`커밋하지 않은 데이터 조차도 접근`** 할 수 있는 격리 수준이다. 

READ UNCOMMITTED 에서는 다른 트랜잭션의 작업이 commit 또는 rollback 되지 않아도 **즉시 보이게** 된다.

예를 들어 사용자 A의 트랜잭션에서 INSERT 를 통해 데이터를 추가했다고 하자. 

아직 commit 또는 rollback 이 되지 않은 상태임에도 불구하고 **READ UNCOMMITTED 는 변경된 데이터에 접근할 수 있다.** 

이를 그림으로 표현하면 다음과 같다.

![image](https://github.com/lielocks/WIL/assets/107406265/3f8c9303-ccc6-4ce1-91ac-2deb9450aca6)

이렇듯 *어떤 트랜잭션의 작업이 완료되지 않았는데도,* **다른 트랜잭션에서 볼 수 있는 부정합 문제**를 **Dirty Read(오손 읽기)** 라고 한다. 

Dirty Read는 데이터가 조회되었다가 사라지는 현상을 초래하므로 시스템에 상당한 혼란을 주게 된다. 

만약 위의 경우에 사용자 A가 commit 이 아닌 rollback 을 수행한다면 어떻게 될까?

![image](https://github.com/lielocks/WIL/assets/107406265/e67ab00d-1811-437a-9b97-cc7421f10aaa)

`사용자 B의 트랜잭션은 id = 51인 데이터를 계속 처리` 하고 있을 텐데, *다시 데이터를 조회하니 결과가 존재하지 않는 상황* 이 생긴다. 

이러한 Dirty Read 상황은 시스템에 상당한 버그를 초래할 것이다.

그래서 READ UNCOMMITTED 는 RDBMS 표준에서 인정하지 않을 정도로 정합성에 문제가 많은 격리 수준이다. 

따라서 ***MySQL을 사용한다면 최소한 READ COMMITTED 이상의 격리 수준을 사용해야 한다.***
 

<br>


## 2. 트랜잭션의 격리 수준(Transaction Isolation Level) 요약

### [정리 및 요약]

앞서 살펴본 내용을 정리하면 다음과 같다. 

READ UNCOMMITTED는 부정합 문제가 지나치게 발생하고, SERIALIZABLE 은 동시성이 상당히 떨어지므로 **READ COMMITTED 또는 REPEATABLE READ** 를 사용하면 된다. 

참고로 `Oracle` 에서는 **`READ COMMITTED`** 를 기본으로 사용하며, `MySQL` 에서는 **`REPEATABLE READ`** 를 기본으로 사용한다. 

![image](https://github.com/lielocks/WIL/assets/107406265/9533aebc-74fa-4bfe-b02c-3e6dbcfe110d)

<br>


격리 수준이 높아질수록 MySQL 서버의 처리 성능이 많이 떨어질 것으로 생각하는데, 사실 SERIALIZABLE 이 아니라면 `크게 성능 개선 및 저하는 발생하지 않는다.` 

그 이유는 결국 *언두 로그를 통해 레코드를 참조하는 과정이 거의 동일* 하기 때문이다. 

따라서 **MySQL 은 갭 락을 통해 Phantom Read 까지 거의 발생하지 않고, READ COMMITTED 보다는 동시 처리 성능은 뛰어난 REPEATABLE READ 를 사용** 한다.


단일 쿼리로는 해결할 수 없는 로직을 처리할 때 필요한 개념인 트랜잭션에 대해 알아보고, Spring에서 어떻게 활용하는지 확인해보도록 하겠습니다.

<br>


## 1. 동시성 제어(Concurrency Control)

동시성 제어란 **DBMS 가 다수의 사용자 사이에서 `동시에 작용하는 다중 트랜잭션의 상호간섭 작용` 에서 Database를 보호하는 것** 을 의미한다. 

일반적으로 *동시성을 허용하면 일관성이 낮아지게 되며* 이를 그래프로 나타내면 아래와 같다.

<br>


![image](https://github.com/lielocks/WIL/assets/107406265/948a83c0-bc69-49da-966d-3e2aad74e900)

<br>


다수 사용자의 동시 접속을 위해 DBMS 는 동시성 제어를 할 수 있도록 **Lock 기능** 과 **SET TRANSACTION 명령어** 를 이용해 트랜잭션의 격리성 수준을 조정할 수 있는 기능도 제공한다. 

이렇게 동시성을 제어하는 방법에는 `낙관적 동시성 제어` 와 `비관적 동시성 제어` 가 있다.

<br>


### 낙관적 동시성 제어 (Optimistic Concurrency Control)

+ 사용자들이 `같은 데이터를 동시에 수정하지 않을 것` 이라고 가정

+ 데이터를 *읽는 시점에 Lock 을 걸지 않는 대신* **수정 시점에 값이 변경됐는지를 반드시 검사**

<br>


### 비관적 동시성 제어 (Pessimistic Concurrency Control)

+ 사용자들이 `같은 데이터를 동시에 수정` 할 것이라고 가정

+ 데이터를 *읽는 시점에 Lock* 을 걸고, **transaction 이 완료될때까지 이를 유지**

+ `SELECT 시점에 Lock 을 거는 비관적 동시성 제어` 는 시스템의 동시성을 심각하게 떨어뜨릴 수 있어서 **`wait` 또는 `nowait` 옵션과 함께 사용**해야 한다.

<br>


동시성 제어의 목표는 동시에 **실행되는 transaction 수를 최대화** 하면서 **`입력, 수정, 삭제, 검색 시` 데이터의 무결성을 유지** 하는데 있다.

따라서 *동시 업데이트가 거의 없는 경우라면 낙관적 락 optimistic lock* 을 사용하면 되지만, *그렇지 않다면 비관적 제어* 를 사용해야 한다.

<br>


### [공유락(Shared Lock) 배타락(Exclusive Lock)]

**비관적 동시성 제어** 를 위한 대표적인 방법으로 **`Lock`** 이 있는데, 크게 `공유락(Shared Lock)` 과 `배타락(Exclusive Lock)` 이 있다.

+ *공유락 (Shared Lock)* : **읽기** 잠금

+ *배타락 (Exclusive Lock)* : **쓰기** 잠금

<br>


**동일한 레코드에 대해 각각 공유락과 배타락을 가져간 경우의 동작은 다음과 같다.**

+ `1번 transaction` 이 **공유락** 을 가져간 경우

  + `2번 transaction` 이 data 를 *읽는* 경우는 데이터가 일관되므로, `2번 transaction` 이 **또 다른 공유락을 가져가면서 동시에 처리함**
 
  + `2번 transaction` 이 data 를 *쓰는* 경우는 1번 transaction 과 데이터가 달라질 수 있으므로 **1번 transaction 종료까지 기다려야 함**

+ `1번 transaction` 이 **배타락** 을 가져간 경우

  + `2번 transaction` 이 데이터를 *읽는* 경우, 1번 transaction 이 데이터를 변경할 수 있으므로 **기다림**
 
  + `2번 transaction` 이 데이터를 *쓰는* 경우에도, 1번 transaction 이 데이터를 변경할 수 있으므로 **기다림**
 
<br>


> **참고로 획득한 락을 해제하는 방법은 결국 commit 과 rollback 밖에 없다**

이러한 방식의 일반적인 Locking 메커니즘은 구현이 간단한 반면에 아래와 같은 문제점을 가진다.

<br>


### [Locking 메커니즘의 문제점]

+ *읽기 작업과 쓰기 작업이 서로 방해를 일으키기 때문에* 동시성 문제가 발생

+ 데이터 일관성에 문제가 생기는 경우도 있어서 Lock 을 더 오래 유지하거나 테이블 레벨의 Lock 을 사용해야 하고, 동시성 저하가 발생


이러한 문제점들을 해결하기 위해 MVCC(Multi-Version Concurrency Control, 다중 버전 동시성 제어) 가 탄생하게 되었다.
 

<br>


## 2. MVCC(Multi-Version Concurrency Control, 다중 버전 동시성 제어)

MVCC 는 **동시 접근을 허용하는 데이터베이스에서 동시성을 제어하기 위해 사용하는 방법** 중 하나이다.

MVCC 의 원본의 데이터와 변경중인 데이터를 동시에 유지하는 방식으로, 원본 데이터에 대한 Snapshot 을 백업하여 보관한다.

만약 두가지 버전의 데이터가 존재하는 상황에서 새로운 사용자가 데이터에 접근하면 **`데이터베이스의 Snapshot`** 을 읽는다.

그러다가 *변경이 취소* 되면 `원본 Snapshot 을 바탕으로 데이터를 복구` 하고, 만약 *변경이 완료* 되면 `최종적으로 disk 에 반영` 하는 방식으로 동작한다.

결국 MVCC 는 snapshot 을 이용하는 방식으로, 기존의 데이터를 덮어 씌우는게 아니라 *기존의 데이터를 바탕으로 이전 버전의 데이터와 비교* 해서 변경된 내용을 기록한다.

이렇게 해서 하나의 데이터에 대해 여러 버전의 데이터가 존재하게 되고, 사용자는 **마지막 버전의 데이터를 읽게 된다.** 

<br>


이러한 구조를 지닌 MVCC의 특징을 정리하면 아래와 같다.

+ 일반적인 RDBMS 보다 매우 빠르게 작동

+ 사용하지 않는 데이터가 계속 쌓이게 되므로 데이터를 정리하는 시스템이 필요

+ 데이터 버전이 충돌하면 어플리케이션 영역에서 이러한 문제를 해결해야 함

<br>


**`MVCC 의 접근 방식`** 은 **잠금을 필요로 하지 않기 때문에 일반적인 RDBMS 보다 매우 빠르게 작동** 한다.

또한 *데이터를 읽기 시작할 때,* **다른 사람이 그 데이터를 삭제하거나 수정하더라도 영향을 받지 않고 데이터를 사용** 할 수 있다.

대신 사용하지 않는 데이터가 계속 쌓이게 되므로 **데이터를 정리하는 시스템이 필요** 하다.

MVCC 모델은 하나의 데이터에 대한 여러 버전의 데이터를 허용하기 때문에 **데이터 버전이 충돌될 수 있으므로 `어플리케이션 영역` 에서 이러한 문제를 해결해야 한다.**

또한 UNDO 블록 I/O, CR Copy 생성, CR 블록 캐싱 같은 *부가적인 작업의 overhead* 발생한다. 

이러한 구조의 MVCC 는 문장수준과 트랜잭션 수준의 읽기 일관성이 존재한다.

<br>


### [MySQL에서의 MVCC(Multi-Version Concurrency Control)]

`MySQL 의 InnoDB` 에서는 **Undo Log 를 활용해 MVCC 기능** 을 구현한다. 이해를 위해 실제 쿼리문 예시를 보자.

예를 들어 아래와 같은 CREATE 쿼리문이 실행되었다고 하자.


```sql
CREATE TABLE member (
    id INT NOT NULL,
    name VARCHAR(20) NOT NULL,
    area VARCHAR(100) NOT NULL,
    PRIMARY KEY(m_id),
    INDEX idx_area(area)
)

INSERT INTO member(id, name, area) VALUES (1, "MangKyu", "서울");
```

<br>


그러면 데이터는 다음과 같은 상태로 저장이 된다. Memory 와 Disk 에 모두 해당 데이터가 동일하게 저장되는 것이다.

![image](https://github.com/lielocks/WIL/assets/107406265/5fc25874-6230-4ac3-8601-99b48c60db36)

<br>


그리고 다음과 같은 UPDATE 문을 실행시켰다고 하자.

```sql
UPDATE member SET area = "경기" WHERE id = 1;
```

UPDATE 문이 실행된 결과를 그림으로 표현하면 다음과 같다. 

<br>


> 먼저 *COMMIT 실행 여부와 무관하게* **`InnoDB 버퍼 풀`** 은 **새로운 값으로 갱신** 된다.
>
> 그리고 **`Undo 로그`** 에는 **변경 전의 값들만 복사된다.** 
>
> 그리고 **`InnoDB 버퍼 풀`** 의 내용은 **백그라운드 thread 를 통해 disk 에 기록되는데, disk 에도 반영되었는지 여부는 시점에 따라 다를 수 있어서 ?로 표시해두었다.** 

![image](https://github.com/lielocks/WIL/assets/107406265/f7041925-8605-4423-8623-9bfc42f3d783)

<br>


*COMMIT 이나 ROLLBACK 이 호출되지 않은 상태* 에서 다른 사용자가 아래와 같은 쿼리로 **데이터를 조회하면 어떤 결과가 반환될까?**

```sql
SELECT * FROM member WHERE id = 1;
```

<br>

 
그 결과는 **`트랜잭션의 격리 수준(Isolation Level)`** 에 따라 다르다. 

만약 `commit 되지 않은 내용도 조회하도록 해주는 READ_UNCOMMITTED` 라면 **버퍼 풀의 데이터를 읽어서 반환하며, 이는 commit 여부와 무관하게 변경된 데이터를 읽어 반환** 하는 것이다.

만약 `READ_COMMITED 이나 그 이상의 격리 수준(REPEATABLE_READ, SERIALIZABLE)` 이라면 **변경되기 이전의 Undo 로그 영역의 데이터** 를 반환하게 된다. 

> **이것이 가능한 이유는 하나의 데이터에 대해 여러 버전을 관리하는 `MVCC` 덕분이다.**

여기서 Undo Log 영역의 데이터는 commit 혹은 rollback 을 호출하여 InnoDB 버퍼풀도 이전의 데이터로 복구되고, 
더 이상 언두 영역을 필요로 하는 트랜잭션이 더는 없을 때 비로소 삭제된다.


Database lock을 이해하는 것은 동시성 문제를 해결하는데 중요한 요소입니다. 

다양한 Lock의 종류 중 가장 중요한 Read Lock, Write Lock, Race condition 그리고 명시적 락에 대해서 어떻게 동작을 하는지 자세히 알아보겠습니다.

롤토체스 TFT 와 관련된 예를 들도록 하겠습니다.

말파이트와 피오라 두 캐릭터가 있는데 여신의 눈물(이후부터 줄여서 여눈)이라는 아이템을 서로 가지려고 하는 상황을 예로 들어봅니다.

```sql
CREATE DATABASE TFT;
CREATE TABLE item(
  id serial NOT NULL,
  name character varying,
  selected integer NOT NULL DEFAULT 0,
  CONSTRAINT item_pk PRIMARY KEY (id)
);
INSERT INTO item(name) VALUES ('Tears of goddess');
```

TFT라는 게임이름의 데이터베이스에 item 테이블을 생성하고 여신의 눈물(Tears of goddess)정보를 추가하였습니다.

<br>

### Read lock — AccessShareLock

먼저, 말파이트와 피오라가 현재 선택할 수 있는 아이템이 무엇이 있는지 확인하려고 정보를 조회해봅니다.

```sql
Fiora > begin; select * from item;
 id |  name               | selected
----+---------------------+----------
  1 | tears of goddess    |     0
(1 rows)
```

```sql
Malphite > begin; select * from item;
 id |  name               | selected
----+---------------------+----------
  1 | tears of goddess    |     0
(1 rows)
```


BEGIN 명령어를 실행하면, 이후 실행하는 SQL명령문은 transaction 으로 묶이게 되어 commit 또는 rollback을 하게 될 때 까지 DB 에 반영되지 않습니다. 

Postgresql에서는 `pg_catalog` 라는 스키마에 다양한 메타정보를 관리합니다. 

그 중 **`pg_locks view`** 는 database server 에 현재 transaction 에서 잡혀있는 lock 에 대한 정보를 제공해줍니다.

다른 세션에서 lock 정보를 확인해봅시다.

```sql
Monitor> select locktype, relation::regclass, mode, transactionid tid, pid, granted from pg_catalog.pg_locks where not pid=pg_backend_pid();
locktype    | relation  |      mode       | tid | pid  | granted
------------+-----------+-----------------+-----+------+---------
 relation   | item_pk   | AccessShareLock |     | 1010 | t
 relation   | item      | AccessShareLock |     | 1010 | t
 virtualxid |           | ExclusiveLock   |     | 1010 | t
 relation   | item_pk   | AccessShareLock |     | 1018 | t
 relation   | item      | AccessShareLock |     | 1018 | t
 virtualxid |           | ExclusiveLock   |     | 1018 | t
(6 rows)
```

(PID 1018 은 Fiora, PID 1010 Malphite 입니다)

결과중 다섯번째 줄을 보면, 피오라가 item 테이블에 **AccessShareLock** 을 요청하고, 허용되었다(Granted) 라는 정보를 확인할 수 있습니다.

여기서 AccessShareLock 은 SELECT 명령문으로 잡히는 락입니다. 참고로 모든 transaction 은 locktype 이 `virtualxid(PostgreSQL 에서 virtual transaction ID)` 에 **ExclusiveLock** 을 잡고 있습니다.

<br>

### Write Lock — RowExclusiveLock

피오라가 말파이트보다 먼저 여신의 눈물을 선택한 상황입니다.

```sql
Fiora> update item set selected=selected+1 where id=1;
UPDATE 1
Malphite> select * from item;
 id |  name               | selected
----+---------------------+----------
  1 | tears of goddess    |     1
(1 rows)
```

피오라가 이미 여눈을 가져갔지만 말파이트는 아직도 모르고 있습니다.

데이터의 정합성과 무결성을 정하는 격리수준인 Isolation level이 대부분의 Database에서는 Read Committed로 되어있습니다. 

이는 Commit을 한 정보만 다른 세션 또는 트렌젝션에서 확인할 수 있다는 의미입니다. 

따라서 아직 말파이트는 피오라가 **commit 하지 않은 정보를 볼 수 없던 것입니다.**

```sql
locktype       |relation|       mode       | tid  | pid  |ranted
---------------+---------+-----------------+------+------+-------
 relation      | item_pk | AccessShareLock  |      | 1010 | t
 relation      | item    | AccessShareLock  |      | 1010 | t
 virtualxid    |         | ExclusiveLock    |      | 1010 | t    
 relation      | item_pk | AccessShareLock  |      | 1018 | t
 relation      | item    | AccessShareLock  |      | 1018 | t
 virtualxid    |         | ExclusiveLock    |      | 1018 | t
 relation      | item_pk | RowExclusiveLock |      | 1018 | t
 relation      | item    | RowExclusiveLock |      | 1018 | t
 transactionid |         | ExclusiveLock    | 5659 | 1018 | t
(9 rows)
```

(PID 1018 은 Fiora, PID 1010 Malphite 입니다)

기존의 Lock 정보에서 **3개의 락** 이 추가되었습니다. 

item 테이블에 Primary key 1에 대하여 Write lock 인 **`RowExclusiveLock`** 이 잡혔습니다. 

Update, Delete, Insert 명령문으로 데이터를 수정하려고 할 때 이 락을 잡습니다.

RowExclusiveLock 은 ExclusiveLock 중 하나로 `배타적 잠금 또는 쓰기잠금` 으로 해석할 수 있습니다. 

데이터를 변경할 때 다른사람이 동시에 바꿀 수 없도록 쓰기잠금을 걸고 쓰기를 마치면 잠금을 해제합니다. 

당연히 쓰기잠금이 걸려있을 때는 다른 잠금을 걸 수 없습니다.

추가적으로, 마지막 줄 처럼 Database 에 상태를 변경하려는 모든 transaction 에 Transaction id 가 부여되고 transaction 이 종료될 때 까지 유지됩니다.

<br>


### Race Condition — ShareLock

Fiora가 여눈을 선택했는데, 말파이트도 여눈을 선택하는 상황입니다.

```sql
Malphite> update item set selected=selected+1 where id=1;
```

Fiora는 동일한 명령문을 실행했을 때 바로 UPDATE 1 이라는 결과가 나왔지만 Malphite는 아무 결과 없이 그대로 멈춰있습니다.

이제 Lock 정보를 조회해봅시다.

```sql
locktype       | relation  |       mode       | tid  | pid  |granted
---------------+-----------+------------------+------+------+-------
 relation      | item_pk   | AccessShareLock  |      | 1010 | t
 relation      | item_pk   | RowExclusiveLock |      | 1010 | t
 relation      | item      | AccessShareLock  |      | 1010 | t
 relation      | item_pk   | AccessShareLock  |      | 1018 | t
 relation      | item_pk   | RowExclusiveLock |      | 1018 | t
 relation      | item      | AccessShareLock  |      | 1018 | t
 relation      | item      | RowExclusiveLock |      | 1018 | t
 virtualxid    |           | ExclusiveLock    |      | 1018 | t
 transactionid |           | ExclusiveLock    | 5659 | 1018 | t
 
 relation      | item      | RowExclusiveLock |      | 1010 | t
 tuple         | item      | ExclusiveLock    |      | 1010 | t
 virtualxid    |           | ExclusiveLock    |      | 1010 | t
 transactionid |           | ExclusiveLock    | 5660 | 1010 | t
 transactionid |           | ShareLock        | 5659 | 1010 | f
(14 rows)
```

(PID 1018 은 Fiora, PID 1010 Malphite 입니다)

위에서 언급했던 것 처럼 데이터를 수정하려고 할 때는 **`Transactionid`** 가 할당됩니다. 

따라서 말파이트에게도 transactionid locktype 에 tid 가 부여되었습니다.

처음보는 ShareLock 이 추가되었습니다. 

ShareLock은 공유잠금 또는 읽기잠금이라는 뜻입니다. 

데이터를 읽을 때 공유잠금을 걸지만, 이름처럼 다른 공유잠금은 걸 수 있습니다. 

하지만! **쓰기잠금은 걸 수 없습니다.** 반대로 쓰기잠금이 걸려있을 때는 공유잠금을 걸 수 없습니다.

ShareLock 은 동시 데이터를 변경할 때 생기는 문제를 보호하기 위하여 먼저 Lock을 잡은 Transactionid 에 공유를 요청하는 Lock입니다. 

피오라가가 먼저 **`ExclusiveLock`** 을 잡고 있기 때문에 **ShareLock 과 Conflict 되어 Lock 이 granted 되지 않았습니다.**

따라서 피오라의 ExclusiveLock 이 해제될 때 까지 말파이트의 요청은 **대기** 가 됩니다.

<br>


![image](https://github.com/lielocks/WIL/assets/107406265/7ae39a08-4739-4884-b039-88ea815afe80)

> explicit-locking

<br>


pg_catalog 에는 **`pg_stat_activity`** 라는 현재 실행되는 쿼리들을 보여주는 view가 있습니다.

```sql
Monitor> SELECT query,state,pid FROM pg_catalog.pg_stat_activity;
                   query                      |    state      | pid
----------------------------------------------+---------------+----
update item set selected=selected+1 where id=1|active         |1010
update item set selected=selected+1 where id=1|idle in trans..|1018
(2 rows)
```

피오라의 쿼리는 실행이 완료되었고 transaction 이 끝나길 기다리기 때문에 `idle in transaction` 상태이고, 말파이트는 피오라를 기다리는 상태이기 때문에 `active` 상태입니다.

<br>


pg_lock 과 pg_statc_activity 를 `pid` 기준으로 조인하면 경합상태를 한눈에 확인할 수 있습니다.

```sql
Monitor> SELECT blockeda.pid AS blocked_pid, blockeda.query as blocked_query,
  blockinga.pid AS blocking_pid, blockinga.query as blocking_query
FROM pg_catalog.pg_locks blockedl
JOIN pg_stat_activity blockeda ON blockedl.pid = blockeda.pid
JOIN pg_catalog.pg_locks blockingl ON(blockingl.transactionid=blockedl.transactionid
  AND blockedl.pid != blockingl.pid)
JOIN pg_stat_activity blockinga ON blockingl.pid = blockinga.pid
WHERE NOT blockedl.granted ;

blocked_pid  |              blocked_query               | blocking_pid |              blocking_query
-------------+-------------------------------------------+--------------+-------------------------------------------
        1010 | update item set selected=selected+1 where id=1; |
1018 | update item set selected=selected+1 where id=1;
(1 row)
```

(PID 1018 은 Fiora, PID 1010 Malphite 입니다) 

명확하게 피오라의 쿼리가 말파이트의 쿼리를 **Block** 하고 있는 것을 확인할 수 있습니다.

이제 피오라가 Commit 또는 Rollback을 하게되면 어떻게 되는지 보도록 하겠습니다.

```sql
Fiora> commit;
COMMIT
Malphite>
UPDATE 1
Malphite> select * from item;
 id |  name               | selected
----+---------------------+----------
  1 | tears of goddess    |     1
(1 rows)
```

피오라가 transaction 을 종료하자 말파이트의 대기중인 쿼리가 실행되었습니다.

```sql
locktype       | relation  |       mode     | tid  | pid  | granted
------------- -+-----------+------------------+------+------+-------
 virtualxid    |           | ExclusiveLock    |      | 1010 | t
 relation      | item_pk   | AccessShareLock  |      | 1010 | t
 relation      | item      | AccessShareLock  |      | 1010 | t
 relation      | item_pk   | RowExclusiveLock |      | 1010 | t
 relation      | item      | RowExclusiveLock |      | 1010 | t
 transactionid |           | ExclusiveLock    | 5660 | 1010 | t
(6 rows)
```

Lock 정보를 보면 피오라가 잡았던 모든 Lock 이 해제되고 말파이트의 **모든 Lock 과 granted 되지 않았던 ShareLock 이 사라진 것** 을 볼 수 있습니다.

<br>


### Explicit Locking (명시적인 Lock)

**1. Table lock—AccessExclusiveLock**

```sql
Fiora> BEGIN; Lock table item in ACCESS EXCLUSIVE MODE;
BEGIN
LOCK TABLE
Malphite> BEGIN; select * from item;
BEGIN
```

피오라가 아이템정보를 독점하고 싶어합니다. 따라서 테이블 전체에 **`AccessExclusiveLock`** 을 걸었습니다. 

AccessExclusiveLock 은 select 를 포함한 **모든 Lock과 conflict 됩니다.**

따라서 말파이트의 Read lock(AccessShareLock) 이 granted 되지 않았습니다.

위의 명령문으로 상품 테이블 Lock 을 잡게 됩니다. 

이후 말파이트의 해당 테이블의 레코드에 대한 모든 명령문은 모두 대기를 해야합니다. 

피오라가 transaction 을 종료하면 말파이트의 조회결과가 출력됩니다.

```sql
locktype  | relation |        mode           | tid | pid  | granted
------------+----------+---------------------+-----+------+---------
 virtualxid |          | ExclusiveLock       |     | 1010 | t
 virtualxid |          | ExclusiveLock       |     | 1018 | t
 relation   | item     | AccessShareLock     |     | 1010 | f
 relation   | item     | AccessExclusiveLock |     | 1018 | t
(4 rows)
```

(PID 1018 은 Fiora, PID 1010 Malphite 입니다)

<br>

**2. RowLock — RowShareLock**

`SELECT FOR UPDATE` 문은 Select 명령문 마지막에 붙여서 쓰는 명령어입니다. 

Select 의 조회결과에 **RowShareLock** 을 걸어서 쓰기잠금(ExclusiveLock)을 걸지 못하도록 하여 **해당 row 에 데이터를 변경하는 것을 막을 수 있습니다.**

```sql
Fiora> BEGIN; SELECT * FROM item WHERE id=1 FOR UPDATE;
BEGIN
 id |  name               | selected
----+---------------------+----------
  1 | tears of goddess    |     2
(1 row)
```

Lock 정보를 확인해보면 RowShareLock 을 획득하였습니다.

```sql
 locktype      | relation  |      mode       | tid  | pid  | granted
---------------+-----------+-----------------+------+------+--------
 relation      | item_pk   | AccessShareLock |      | 1018 | t
 relation      | item      | RowShareLock    |      | 1018 | t
 virtualxid    |           | ExclusiveLock   |      | 1018 | t
 transactionid |           | ExclusiveLock   | 5189 | 1018 | t
(4 rows)
```

피오라가 RowShareLock을 건 데이터를 말파이트가 수정하려고하면 어떻게 될까요?

```sql
Malphite>update item set selected=selected+1 where id=1;
BEGIN
locktype       |relation|       mode       | tid  | pid  | granted
---------------+--------+------------------+------+------+-------
 relation      | item_pk| RowExclusiveLock |      | 1010 | t
 relation      | item   | RowExclusiveLock |      | 1010 | t
 virtualxid    |        | ExclusiveLock    |      | 1010 | t
 relation      | item_pk| AccessShareLock  |      | 1018 | t
 relation      | item   | RowShareLock     |      | 1018 | t
 virtualxid    |        | ExclusiveLock    |      | 1018 | t
 transactionid |        | ExclusiveLock    | 5193 | 1018 | t
 transactionid |        | ShareLock        | 5193 | 1010 | f
 transactionid |        | ExclusiveLock    | 5194 | 1010 | t
 tuple         | item   | ExclusiveLock    |      | 1010 | t
(10 rows)
```

(PID 1018 은 Fiora, PID 1010 Malphite 입니다)

RaceCondition 일 때 Lock 정보와 매우 흡사합니다. 

**피오라가 Lock 을 잡고 있기 때문에 말파이트는 ShareLock 을 요청하고 granted 되지 않았습니다.**

<br>

### Lock monitor view

위와 같은 `lock 정보(pg_locks)`와 `실행중인 쿼리(pg_stat_activity)`를 join 한 **view** 를 생성하여 한눈에 모니터링을 할 수 있습니다.

```sql
CREATE VIEW lock_monitor AS(
SELECT
  COALESCE(blockingl.relation::regclass::text,blockingl.locktype) as locked_item,
  now() - blockeda.query_start AS waiting_duration, blockeda.pid AS blocked_pid,
  blockeda.query as blocked_query, blockedl.mode as blocked_mode,
  blockinga.pid AS blocking_pid, blockinga.query as blocking_query,
  blockingl.mode as blocking_mode
FROM pg_catalog.pg_locks blockedl
JOIN pg_stat_activity blockeda ON blockedl.pid = blockeda.pid
JOIN pg_catalog.pg_locks blockingl ON(
  ( (blockingl.transactionid=blockedl.transactionid) OR
  (blockingl.relation=blockedl.relation AND blockingl.locktype=blockedl.locktype)
  ) AND blockedl.pid != blockingl.pid)
JOIN pg_stat_activity blockinga ON blockingl.pid = blockinga.pid
  AND blockinga.datid = blockeda.datid
WHERE NOT blockedl.granted
AND blockinga.datname = current_database()
);
```


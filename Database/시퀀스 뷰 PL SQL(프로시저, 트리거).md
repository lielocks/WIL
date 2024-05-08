## 뷰(view)

+ 뷰(View) 는 하나 이상의 테이블을 합하여 만든 가상의 테이블

+ *편리성*

  미리 정의된 view 를 일반 테이블처럼 사용할 수 있기 때문에 편리함.

  또 사용자가 필요한 정보만 요구에 맞게 가공하여 view 로 만들어 쓸 수 있음

+ *재사용성*

  자주 사용되는 질의 를 view 로 미리 정의해 놓을 수 있음

+ *보안성*

  각 사용자별로 필요한 데이터만 선별하여 보여줄 수 있음.

  중요한 질의의 경우 질의 내용을 암호화할 수 있음


![image](https://github.com/lielocks/WIL/assets/107406265/e2f6a69a-b9d3-4856-bccd-31776b3cd2e5)

<br>


### [뷰(view) 의 생성]

![image](https://github.com/lielocks/WIL/assets/107406265/bb8bddd7-4f18-44ac-bcfe-07efae670a3e)

<br>


### [뷰(view) 의 수정]

![image](https://github.com/lielocks/WIL/assets/107406265/993b821f-4806-451e-bbb5-c72adc6af95b)

<br>


### [뷰(view) 의 삭제]

![image](https://github.com/lielocks/WIL/assets/107406265/8bc89cae-494c-46de-ad2c-e7f949bc60b5)

<br>


## 시퀀스 (sequence)

**시퀀스(sequence)** : 유일한 값을 생성해주는 오라클 객체, 자동증가(넘버링)

  이는 시퀀스를 생성하여 마치 `기본키(primary key)` 와 같이 순차적으로 증가하는 칼럼을 자동으로 생성해줍니다.

- 시퀀스는 이런 성질 때문에 대량의 데이터를 다룰 때 기본키의 값을 생성하기 위해 사용하고

  시퀀스는 테이블과는 독립적으로 저장되고 만들어지기 때문에 하나의 시퀀스를 생성하여 여러 테이블에 적용하여 활용하면 좋습니다

```sql
생성 방법
-- create sequence 시쿼스 이름 start with 시작 숫자 increment by 증가량;
 
--[1] 샘플 테이블 생성
create table memos(
 num  number(4) constraint memos_num_pk primary key,
 name  varchar2(20) constraint memos_name_nn not null,
 postDate  Date default(sysdate)
);
 
--[2] 해당 테이블의 시퀀스 생성
create sequence memos_seq start with 1 increment by 1;
-- memos_seq : 시퀀스의 이름
-- start with 1 : 시작 숫자
-- increment by 1 : 증감량
 
--[3] 데이터 입력 : 일련번호 포함
insert into memos(num, name) values(memos_seq.nextVal , '홍길동');
insert into memos(num, name) values(memos_seq.nextVal , '이순신');
insert into memos(num, name) values(memos_seq.nextVal , '강감찬');
insert into memos(num, name) values(memos_seq.nextVal , '유관순');
insert into memos(num, name) values(memos_seq.nextVal , '장영실');
 
select * from memos;
 
--[4] 현재 시퀀스가 어디까지 증가되어져 있는지 확인.
select memos_seq.nextVal, memos_seq.currval from dual;
 
--[5] 시퀀스 수정 : 최대 증가값을 14까지로 제한.
alter sequence memos_seq  maxvalue  14;
insert into memos(num, name) values(memos_seq.nextVal, '안중근');
insert into memos(num, name) values(memos_seq.nextVal, '김구');
insert into memos(num, name) values(memos_seq.nextVal, '세종대왕');
insert into memos(num, name) values(memos_seq.nextVal, '안중근');
insert into memos(num, name) values(memos_seq.nextVal, '김구');
select * from memos;
 
--[6] 시퀀스 삭제
drop sequence memos_seq;
--[7] 시퀀스 재생성 : 14 다음 숫자부터 시작하게 하여 기존 레코드와 중복 되지 않게 합니다
create sequence memos_seq start with 15 increment by 1;
```

<br>


**뷰** : 실제 데이터는 건들지 않고 원하는 내용만 가져다 모아서 확인할 수 있는 가상의 테이블. 뷰는 실제 테이블에 제한적으로 접근하도록 하여 보안에도 유리함.

**시퀀스** : 기본키를 효과적으로 사용하기 위한 일련번호 자동 생성기이다

<br>


## PL / SQL

### [PL/SQL 이란?]

+ **`Procedural Language` / `Structured Query Language`** 로 응용 프로그램을 작성하는데 사용하는 **oracle 전용 SQL 언어**
  
+ *SQL 전용 언어* 로 `SQL 문에 변수, 제어, 입출력 등의 프로그래밍 기능을 추가` 하여 SQL 만으로 처리하기 어려운 문제 해결

+ PL/SQL 은 **SQL Developer에서 바로 작성하고 compile 한 후 결과를 실행함**

+ PL/SQL 에는 *프로시저, 트리거, 사용자 정의 함수* 등이 있다.

<br>


### [프로시저(PROCEDURE)]

+ 프로시저를 정의하려면 `CREATE PROCEDURE` 문을 사용해야 한다.

+ PL/SQL 은 *선언부(BEGIN)* 와 *실행부(END)* 로 구성된다. 

+ *선언부* 에서는 **변수와 매개변수를 선언** 하고, *실행부* 에서는 **프로그램 로직을 구현** 한다.

+ *매개변수(parameter)* 는 **저장 프로시저가 호출될 때 그 프로시저에 전달되는 값** 이다.

+ *변수(Variable)* 는 **저장 프로시저나 트리거 내에서 사용되는 값임**

+ 주석은 `/*와 */ 사이` 또는 `-- 다음에` 기술하면 된다.

<br>


프로시저는 프로그래밍에서 **함수** 와 유사합니다. 

프로시저를 실행하는데 *필요한 매개변수* 를 받고, 프로시저의 구현에 필요한 *변수는 선언부에 선언* 을 하고 *로직은 실행부에* 구성을 합니다. 

그렇기에 아래의 프로시저처럼 ***Insert 와 같이 여러번 자주 실행해야 하는 SQL문들을 프로시저로 구현*** 해두면 상당한 편리성을 얻을 수 있습니다.

![image](https://github.com/lielocks/WIL/assets/107406265/6104b62e-a290-44ea-9a98-589525086de8)


*동일한 값이 있는지를 검사하기 위한 프로시저* 는 아래와 같이 구현할 수 있습니다. 

예를 들어 같은 책 제목을 가진 도서가 있는지를 검사하는 프로시저를 작성하고자 할 때, **mycount 라는 변수** 를 두어 내가 원하는 책 제목을 가진 책들이 도서목록에 몇 개 있나 개수를 세주어야 합니다. 

그러므로 **`Begin(선언부)`** 에 **mycount라는 변수를 선언해두고** **`End(실행부)`** 에서는 **If/else 와 같은 제어문** 을 사용하여 mycount==0 인 경우와 그렇지 않은 경우를 나누어 처리해주면 됩니다.

![image](https://github.com/lielocks/WIL/assets/107406265/7fa099f7-0a60-4697-b423-314a2fc96d17)

<br>


우리는 프로시저가 **한 번에 한 행씩 처리하기를 원하는 경우** 가 있는데 

이러한 경우에 **`커서(Cursor)`** 를 활용하여 *테이블의 행을 순서대로* 가리키도록 하고, 필요한 경우에 그 행의 데이터를 추출할 수 있습니다. 

커서와 관련된 키워드는 아래와 같습니다.

![image](https://github.com/lielocks/WIL/assets/107406265/3234776c-e613-4cc0-a1d4-759c44571cfe)


판매 도서 목록에 대한 이윤을 계산하는 프로시저를 작성한다고 할 때, 우리는 *행마다 값을 확인하여 처리* 를 해주어야 합니다. 

<br>


그래서 **프로시저 선언부** 에서 **`Cursor - IS -`** 를 활용하여 *커서를 만들어주고,* 

**`Open -`** 를 활용하여 *커서를 열어주고* 

**`Fetch - INTO -`** 하여 *데이터를 추출한 후에 반복문이 종료되면 Close 함수를 이용하여 커서의 사용을 끝내면 됩니다.* 

그리고 이를 전체 프로시저로 작성하면 아래와 같습니다.

<br>


![image](https://github.com/lielocks/WIL/assets/107406265/e5ba5661-4bbd-44e8-bf15-c4b51b291382)

<br>


## 트리거(Trigger) 란?

트리거(Trigger)란 영어로 방아쇠라는 뜻인데, 방아쇠를 당기면 그로 인해 총기 내부에서 알아서 일련의 작업을 실행하고 총알이 날아갑니다. 

<br>


> 이처럼 데이터베이스에서도 ***트리거(Trigger)*** 는 *특정 테이블에 INSERT, DELETE, UPDATE 같은 DML 문이 수행* 되었을 때, **데이터베이스에서 자동으로 동작** 하도록 작성된 프로그램입니다. 

> ***트리거(Trigger)*** 는 BEFORE 트리거와 AFTER 트리거가 있다.

즉 사용자가 직접 호출하는 것이 아니라, 데이터베이스에서 *자동적으로 호출* 하는 것이 가장 큰 특징입니다. 

트리거(Trigger)는 *테이블* 과 *view 데이터베이스 작업* 을 대상으로 정의할 수 있으며, 
*전체 트랜잭션 작업* 에 대해 발생되는 트리거(Trigger)와 *각행에 대해 발생* 되는 트리거(Trigger)가 있습니다.

<br>


*BEFORE 트리거* 란 `해당 프로시저의 실행 이전에 자동으로 먼저 실행` 되는 프로시저이며, 

*AFTER 트리거* 란 `해당 프로시저가 실행된 후에 자동으로 실행` 되는 프로시저입니다. 

![image](https://github.com/lielocks/WIL/assets/107406265/960d1b90-0b2a-45da-8191-41ff4d4479cf)

<br>


아래의 그림에서는 새로운 도서가 *Book 테이블에 삽입된 후 백업* 을 위해 **Book_log 테이블에 같은 내용을 삽입하는 트리거** 를 보여주고 있습니다. 

`AFTER INSERT ON Book FOR EACH ROW` 구문은 **Book 테이블에 값이 추가되면 실행하는 트리거** 임을 명시해주고 있고, 

`실행부(END)` 에서는 **Book_log 테이블에 데이터를 백업** 해두고 있습니다.

![image](https://github.com/lielocks/WIL/assets/107406265/4b2ac649-e278-450c-b01c-46c0198fcd4f)

<br>


### [사용자 정의 함수]

+ 사용자 정의 함수는 수학의 함수와 마찬가지로 *입력된 값을 가공하여 결과를 돌려준다.*

아래의 함수는 판매된 도서에 대한 이익을 계산하는 함수입니다.

**RETURN 값이 INT 형** 임과 *그 값이 사용자가 선언한 변수임* 을 적어주고 있고, 
**인자로는 price** 라는 판매 가격을 받고 있습니다.

![image](https://github.com/lielocks/WIL/assets/107406265/44a2f360-c26f-46af-a51a-3f253792cc0b)

<br>


### [프로시저, 트리거, 사용자 정의 함수 비교]

![image](https://github.com/lielocks/WIL/assets/107406265/befc457c-2ab8-48fa-b42c-f6e42c96439f)


<br>


### 트리거(Trigger)가 적용되는 예

다음과 같은 상황에서 트리거(Trigger)를 사용할 수 있습니다. 

어떤 쇼핑몰에 하루에 수만 건의 주문이 들어옵니다. 

주문데이터는 `주문일자, 주문상품, 수량, 가격` 이 있으며, 수천명의 임직원이 `일자별, 상품별 총 판매수량과 총 판매가격으로 구성된 주문 실적` 을 실시간으로 온라인상에 조회를 했을 때, 

한사람의 임직원이 조회할 때마다 *수만 건의 데이터를 읽고 계산* 해야합니다. 

만약 임직원이 수만명이고, 데이터가 수백만건이라면, 또 거의 동시다발적으로 실시간 조회가 요청된다면 시스템 퍼포먼스가 떨어질 것입니다.

따라서! **트리거(Trigger)** 를 사용하여 `주문한 건이 입력될 때마다`, 일자별 상품별로 판매수량과 판매금액을 집계하여 집계자료를 보관하도록 만들어보겠습니다. 

먼저 관련된 테이블을 생성해보겠습니다.

<br>


![image](https://github.com/lielocks/WIL/assets/107406265/52742548-9b2c-436b-85a0-4d8ddad920ed)

<br>


테이블은 다음과 같습니다. 

`주문정보테이블` 에 실시간으로 데이터가 입력될 때마다 trigger 가 발동되어 자동으로 `일자별판매집계테이블` 에 일자별, *상품별 판매수량과 판매금액* 을 계산해 업데이트 하는 작업을 하도록 하고, 

사용자들은 **미리 계산된** `일자별판매집계테이블` 을 조회하게 하여 *실시간 조회* 를 지원하게 하는 것입니다.

<br>


### 트리거(Trigger) 구현

자, 이제 2개 테이블을 CREATE, DDL을 통해 만들어보겠습니다.

```sql
CREATE TABLE ORDER_LIST(

    ORDER_DATE  CHAR(8) NOT NULL,
    PRODUCT     VARCHAR2(10) NOT NULL,
    QTY         NUMBER NOT NULL,
    AMOUNT      NUMBER NOT NULL
);
```

```sql
CREATE TABLE SALES_PER_DATE(
    SALE_DATE   CHAR(8) NOT NULL,
    PRODUCT     VARCHAR2(10) NOT NULL,
    QTY         NUMBER NOT NULL,
    AMOUNT      NUMBER NOT NULL
);
```

```sql
SELECT *
FROM ORDER_LIST

SELECT *
FROM SALES_PER_DATE
```

조회를 해보면 다음과 같습니다.

![image](https://github.com/lielocks/WIL/assets/107406265/602ee887-4153-49b6-af6a-d7a3e16340cf)

![image](https://github.com/lielocks/WIL/assets/107406265/62206a2d-9e04-4c6c-aaa9-c00fc59249d4)

아직 2개 테이블 다 데이터가 없음을 확인할 수 있습니다. 

이제 트리거(Trigger)를 만들어 보겠습니다. 

트리거(Trigger)를 구현하기 위해 우선 `절차형 SQL` 과 `PL/SQL` 을 알아야합니다. 

절차형 SQL과 PL/SQL을 안다는 전제하에 트리거(Trigger)를 구현해보겠습니다.

<br>


![image](https://github.com/lielocks/WIL/assets/107406265/db6576a7-e1e5-407a-89e1-0d9d71033020)

<br>

**8 ~ 14 Line** 

**`Trigger`** 를 선언합니다. 

order_list 테이블에 insert 가 발생하면 그 이후 each row 즉 `각 행에 해당 트리거(Trigger)를 적용` 한다라는 뜻입니다. 

또한, *declare 선언문에는 변수를 선언* 합니다. 

order_list 테이블에 있는 order_date, product Type에 맞게 `o_date, o_prod 변수` 를 선언합니다.

<br>

**15 ~17 Line**

`new` 는 **트리거(Trigger)에서 사용하는 구조체** 입니다. new 는 *새로 입력된 레코드 값* 을 담고 있습니다.

o_date 에 `새로 들어온 order_date 값` 을 , o_prod 에 `새로 들어온 product 값` 을 저장합니다.

<br>

**18 ~ 26 Line**

`sales_per_date 테이블` 에 update 구문을 실행하는데, `기존에 있는 qty, amount 를 누적합` 해서 다시 **Set** 합니다. 

여기서 `where문` 을 통해 *현재 새로 들어온 날짜과 상품이 일치하는 데이터만* 해당 update문을 실행하도록 조건을 걸었습니다. 

또한 만약 해당 조건에 *모두 해당되지 않는다면, if sql%notfound* 구문이 실행됩니다. 

기존에 있던 레코드 값이 아니고 전혀 새로운 레코드이기 때문에 insert 구문을 통해 새로 들어온 데이터를 새로 삽입합니다. 

끝으로 `/ 부분` 은 **트리거(Trigger)를 실행하는 실행명령어** 입니다.

<br>

위 구문을 실행하면, 이제 *2개 테이블에 트리거(Trigger)* 가 적용된 것입니다. 

<br>


이제 `order_list 테이블` 에 레코드를 insert 해서 `sales_per_date 테이블` 에 트리거(Trigger)가 자동으로 동작하여, 데이터 값을 자동으로 계산하고 반영하는지 확인해보겠습니다!

ORDER_LIST 테이블에 아래와 같이 데이터 값을 삽입해보겠습니다.

**-> INSERT INTO ORDER_LIST VALUES('20120901','MONOPACK',10,300000)**

삽입후 ORDER_LIST, SALES_PER_DATE 테이블 조회를 해보겠습니다.

ORDER_LIST 정상적으로 값이 삽입되었습니다.

<br>


![image](https://github.com/lielocks/WIL/assets/107406265/75c38cdc-b37c-4abf-94a6-32e9aa6f5d1a)

**트리거** 에 의해서 SALES_PER_DATE 에도 정상적으로 값이 삽입되어있습니다.

![image](https://github.com/lielocks/WIL/assets/107406265/a673689a-8e68-482b-80a4-cb4c3dbfce4c)

자. 다시한번 값을 삽입하고 테이블을 확인해보겠습니다.

**-> INSERT INTO ORDER_LIST VALUES('20120901','MONOPACK',20,600000);**

ORDER_LIST 를 조회하면 지금까지 삽입한 값들이 리스트로 있습니다.

![image](https://github.com/lielocks/WIL/assets/107406265/654e4c1e-2ded-4abd-a939-0723196bacbb)

`SALES_PER_DATE 테이블` 은 **트리거** 에 의해서 *주문날짜별 상품별 물량과 가격이 합산* 되어 업데이트 되어있음을 확인할 수 있습니다.

![image](https://github.com/lielocks/WIL/assets/107406265/f3bf56d9-310f-47a8-aca2-e523123ccfc0)

<br>


## 트리거(Trigger)와 트랜잭션(Transaction)의 상관관계

이번에는 다른 상품으로 주문 데이터를 입력한 후 두 테이블의 결과를 조회해보고 `트랜잭션을 ROLLBACK` 해보겠습니다. 

판매 데이터의 **입력취소** 가 일어나면, `주문 정보 테이블(ORDER_LIST)` 과 `판매 집계테이블(SALES_PER_DATE )` 에 *동시에 입력(수정) 취소가 일어나는지* 확인해보기 위함입니다.

**-> INSERT INTO ORDER_LIST VALUES('20120901','MULTIPACK',10,300000);**

ORDER_LIST 에 정상적으로 판매 데이터가 삽입되었습니다. 

![image](https://github.com/lielocks/WIL/assets/107406265/1c3b66fc-9e57-4731-81cc-03e56bb62bbf)

SALES_PER_DATE 테이블은 **트리거** 에 의해 판매날짜별, 상품별 누적 물량과 가격이 업데이트 되었습니다.

![image](https://github.com/lielocks/WIL/assets/107406265/ff56fd5e-9a50-4fdd-a15f-bede52154fea)

이제 **`ROLLBACK;`** 명령어를 실행해보겠습니다. 

`ORDER_LIST 테이블` 에 *방금 삽입한 판매데이터가 취소* 되었습니다.

![image](https://github.com/lielocks/WIL/assets/107406265/cb61d0b1-3fc6-4573-a9eb-fa887b2c497e)

`SALES_PER_DATE 테이블` 에도 똑같이 **트리거** 로 입력된 데이터 정보까지 ***하나의 트랜잭션으로 인식하여 입력 취소가 되었습니다.***

![image](https://github.com/lielocks/WIL/assets/107406265/39ac86a0-8d42-4df3-a671-c17acb66a6bb)

<br>

즉, **트리거**는 데이터베이스에 의해 `자동 호출`되지만 

**결국 `INSERT, UPDATE, DELETE 구문과 하나의 트랜잭션 안에서` 일어나는 일련의 작업들이라 할 수 있습니다.** 

(추가로 트리거는 Begin ~ End 절에서 COMMIT , ROLLBACK 을 사용할 수 없습니다.)


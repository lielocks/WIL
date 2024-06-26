## B-tree

`이진트리` 는 일반적으로 하나의 노드에 하나의 값, 최대 2개의 자식으로 구성되어 있습니다.

하지만 **B-tree 는 하나의 노드에 여러 개의 값을 가질 수 있고 쵀대 자식이 2개 이상일 수 있습니다.**

아래 사진처럼, B-tree 는 3개의 값, 4개의 자식이 있을 수 있습니다.

![image](https://github.com/lielocks/WIL/assets/107406265/da513b5c-254f-4cdf-a753-aed06c1df3a7)

하나의 노드의 최대 자식수가 3개이면 3차 B-tree 4개이면 4차 B-tree 라고 합니다.
최대 자식수의 개수에 따라서 1,2,3,... M차 B-tree 가 있습니다.

(m차 B-tree 이면 하나의 노드가 가지는 키의 최대개수는 m-1 입니다)

<br>

> 대량의 데이터를 처리해야 할 때, 검색 구조의 경우 하나의 노드에 많은 데이터를 가질 수 있다는 점은 상당히 큰 장점이다.
>
> 대량의 데이터는 메모리보다 블럭 단위로 입출력하는 하드디스크 or SSD에 저장해야하기 때문!
>
> ex) 한 블럭이 1024 바이트면, 2바이트를 읽으나 1024바이트를 읽으나 똑같은 입출력 비용 발생.
>
> 따라서 **하나의 노드를 모두 1024바이트로 꽉 채워서 조절** 할 수 있으면 입출력에 있어서 효율적인 구성을 갖출 수 있다.
>
> → B-Tree는 이러한 장점을 토대로 많은 데이터베이스 시스템의 인덱스 저장 방법으로 애용하고 있음

<br>

### 노드의 구분

![image](https://github.com/lielocks/WIL/assets/107406265/b7d84e1b-745f-4132-b4e0-9befdee80dc4)

+ **루트 (root) 노드** : 최상단에 위치한 노드

+ **리프 (leaf) 노드** : 자식이 없는 최하단에 위치한 노드

+ **내부 (internal) 노드** : 루트노드와 리프노드를 제외한 모드 노드

<br>

### B-tree 구조

Knuth에 따르면 B-tree는 다음과 같이 정의할 수 있습니다.
 

> 1. 모든 노드들은 최대 m개의 자식을 가질 수 있습니다.
> 2. k개의 자식을 가진 리프가 아닌 노드는 k-1개의 키를 가지고 있습니다.
> 3. 모든 내부 노드는 최소 [m/2]개의 자식을 가져야 합니다
> 4. 모든 리프 노드들은 같은 레벨에 있어야 합니다
> 5. 리프가 아닌 모든 노드들은 최소 2개 이상의 자식을 가져야 합니다
 
(참고로 ⌈m/2⌉ 은 반올림입니다.)

m =3 인 3차 B-tree를 예시로 들겠습니다.

<br>

**1. 모든 노드들은 최대 m개의 자식을 가질 수 있습니다. (3개)**

![image](https://github.com/lielocks/WIL/assets/107406265/b377c2f1-f4cc-42fa-bb77-4ce7ef70acac)

<br>

**2. k개의 자식을 가진 리프가 아닌 노드는 k-1 개의 key를 가지고 있습니다.**

![image](https://github.com/lielocks/WIL/assets/107406265/5da49023-2205-496f-b993-39031dfe334f)

<br>

**3. 모든 내부 노드는 최소 [m/2] 개의 자식을 가져야 합니다. (2개)**

![image](https://github.com/lielocks/WIL/assets/107406265/4da351e8-863e-44c3-b896-9b1e248e5bec)

<br>

**4. 모든 리프 노드들은 같은 레벨에 있어야 합니다**

![image](https://github.com/lielocks/WIL/assets/107406265/ada6fa3c-d515-423c-b907-154ab2bedde7)

<br>

**5. 리프가 아닌 모든 노드들은 최소 2개 이상의 자식을 가져야 합니다.**

![image](https://github.com/lielocks/WIL/assets/107406265/ef3789c6-13e7-4b80-b6ec-57bfd8eac054)

<br>

## B+tree
B-tree를 개선해서 B-tree가 등장했습니다. 


가장 큰 2가지 특징은 다음과 같습니다.

+ 모든 리프 노드들은 **Linked List** 형태로 서로 연결되어 있어 임의 접근이나 순차 접근 모두 성능이 우수하다.

+ **실제 데이터는 리프노드에만 저장된다.** 내부 노드들은 단지 키만 가지고 있고 올바른 리프 노드로 연결해 주는 라우팅 기능을 한다.

<br>

리프 노드들만 d1, d2... d7 데이터를 가집니다. B+tree 는 **중복 키** 를 가집니다. 

왜냐하면 내부 노드들은 데이터를 가지고 있지 않기 때문에 리프 노드들이 데이터를 가지고 있지 않기 때문에 **`리프노드들이 키와 데이터를 모두 가지고 있어야 하기 때문입니다.`**

(3, 5 가 중본 키를 가집니다.)

![image](https://github.com/lielocks/WIL/assets/107406265/ab4f1a24-8735-43cc-a8cb-d5dacce5f998)

<br>

아래 B+tree 는 사실상 리프 노드의 키들과 그 이외에 키들이 같은 경우입니다.

![image](https://github.com/lielocks/WIL/assets/107406265/a448f799-eb1d-4117-8427-fc1ba61ea95f)

<br>

B+tree 는 실제 데이터를 리프 노드에만 저장하므로 B-tree 에 비해 같은 노드에 더 많은 키를 저장할 수 있습니다.

데이터를 찾기 위해 리프 노드까지 탐색을 해야 하는데 **Linked List로 연결되어 있어 full scan 시 리프 노드들만 순차 탐색하면 되기 때문에 탐색에 유리합니다.**

반면 B-tree 는 모든 노드를 탐색해야 합니다.

![image](https://github.com/lielocks/WIL/assets/107406265/484a9b0d-d6af-41d5-9692-2b08ec52e1e9)

<br>

### 데이터베이스에서의 B-tree

메인 메모리는 주요 저장소로, 제한적인 공간 때문에 모든 데이터를 저장할 수 없습니다.
따라서, `보조 저장소` 를 사용하는데, **page 라고 부르는 Magnetic Disk 에 저장** 해서 비용을 줄입니다.

Disk에서 메모리로 데이터를 전송하기 위해서는 Disk 읽기를 해야 합니다.
비록 page 에서 하나의 데이터만 조회하고 싶어도, Disk 는 모든 페이지 접근을 수행합니다.
Disk 는 메인메모리만큼 빠르지 않은데, 읽기를 할때마다 찾기와 회전 지연이 있기 때문입니다.
Disk 에 접근이 많아질수록, 검색에 필요한 시간은 길어집니다.


**DBMS는 B-tree의 인덱싱을 활용해 특정 데이터를 찾기 위한 읽기 작업의 빈도를 낮춥니다.** 
B-tree가 구성되어 있으므로, 각각의 노드는 메모리에서 하나의 페이지를 담당하여 각 노드가 최소한 절반을 채워두도록 하여 읽기 접근의 횟수를 줄입니다.

<br>

### B-tree와 B+tree의 비교

![image](https://github.com/lielocks/WIL/assets/107406265/5077d0c5-496f-4c1d-8fba-6541da5ad074)

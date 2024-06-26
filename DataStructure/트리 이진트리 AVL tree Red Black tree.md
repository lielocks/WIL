## 트리 (Tree) 의 개념

트리는 노드로 이루어진 자료구조로 스택이나 큐와 같은 선형 구조가 아닌 비선형 자료구조이다.

트리는 계층적 관계를 표현하는 자료구조이다.

아래와 같은 특징들이 있다.

<br>

1. 트리는 하나의 root node 를 갖는다.

2. root node 는 0 개 이상의 자식 노드를 갖는다.

3. 자식 노드 또한 0개 이상의 자식 노드를 갖는다.

4. 노드 (node) 들과 노드들을 연결하는 간선 (edge) 들로 구성되어 있다.

<br>

+ **트리에는 cycle 이 존재할 수 없다.** 여기서 사이클이란 `시작 노드에서 출발해 다른 노드를 거쳐 다시 시작 노드로 돌아올 수 있는 것.`

  ![image](https://github.com/lielocks/WIL/assets/107406265/5784ec0e-1c5f-4cf0-bbd4-b0c317328839)

+ 트리는 cycle 이 없는 하나의 연결 그래프 (Connected Graph) 라고 할 수 있다.

+ 트리의 노드는 self-loop 가 존재해서는 안된다.

![image](https://github.com/lielocks/WIL/assets/107406265/04e636ac-f87c-4991-9f04-19f2c8244df4)

+ N개의 노드를 갖는 트리는 항상 N-1 개의 간선 (edge) 를 갖는다.

+ 모든 자식 노드는 한개의 부모 노드만을 갖는다.

<br>

### 트리와 관련된 용어

![image](https://github.com/lielocks/WIL/assets/107406265/8031d64f-ccf8-4862-ade9-bbfe10a1bff6)

+ **루트 노드 root node** : 부모가 없는 노드로 트리는 **`단 하나의 루트 노드`** 를 가진다. (ex : A)

+ **단말 노드 leaf node** : 자식이 없는 노드로 terminal 노드라고도 부른다. (ex : D, E, C)

+ **내부 노드 internal node** : 단말 노드가 아닌 노드 (ex : A, B)

+ **간선 (edge)** : 노드를 연결하는 선

+ **형제 (sibling)** : 같은 부모 노드를 갖는 노드들 (ex : D-E / B-C)

+ **노드의 깊이 (depth)** : 루트 노드에서 어떤 노드에 도달하기 위해 거쳐야 하는 간선의 수 (ex : D 의 depth -> 2)

+ **노드의 레벨(level)** : 트리의 특정 깊이를 가지는 노드의 집합 (ex : level 1- {B, C})

  트리에서는 각 층별로 숫자를 매겨서 이를 트리의 Level(레벨)이라고 한다.
  
  레벨의 값은 0 부터 시작하고 따라서 루트 노드의 레벨은 0 이다.

  그리고 트리의 최고 레벨을 가리켜 해당 트리의 height(높이)라고 한다.

+ **노드의 차수(degree)** : 자식 노드의 개수 (ex : B의 degree -> 2, C의 degree -> 0)

+ **트리의 차수(degree of tree)** : 트리의 최대 차수 (ex : 위 트리의 차수는 2 이다)

<br>

## 트리의 종류

### 1. 이진 트리 (Binary Tree)

이진트리는 각 노드가 **`최대 두 개의 자식`** 을 갖는 트리를 뜻한다. 
즉, **모든 노드들이 둘 이하(0,1,2 개)의 자식을 가진 트리이다.**  

![image](https://github.com/lielocks/WIL/assets/107406265/55e93ad2-dd04-4c53-999b-7ac72eeab636)

![image](https://github.com/lielocks/WIL/assets/107406265/7b6acc16-6585-4553-bb68-abde104a0b16)

이진 트리는 전위 순회, 중위 순회, 후위 순회를 통해 탐색할 수 있다.

<br>


### 2. 이진 탐색 트리 (Binary Search Tree, BST)

**왼쪽 자식은 부모보다 작고 오른쪽 자식은 부모보다 큰 이진 트리** 이다.

즉, 현재 노드를 기준으로 L 작은수, R 큰수

![image](https://github.com/lielocks/WIL/assets/107406265/be034f25-1cbe-4116-854a-ca4506bcf372)


+ 규칙 1. 이진 탐색 트리의 노드에 **저장된 키는 유일** 하다.

+ 규칙 2. 부모의 키가 **왼쪽 자식 노드** 의 키보다 크다.

+ 규칙 3. 부모의 키가 **오른쪽 자식 노드** 의 키보다 작다.

+ 규칙 4. 왼쪽과 오른쪽 **서브트리도** 이진 탐색 트리이다.
   
<br>

BST는 삽입, 삭제, 탐색과정에서 모두 트리의 높이만큼 탐색하기 때문에 **`O(logN)`** 의 시간 복잡도를 가진다.
문제는 `트리가 Skewed Tree(편향 트리) 가 되어버렸을 때` 결국 배열과 다름 없어지고 시간 복잡도는 **`O(N)`** 이 된다.

중위순회(inorder traversal)를 하면, 오름차순으로 정렬된 순서로 Key값을 얻을 수 있다.

< 이진 트리의 3가지 순회방법>


+ **전위 순회 preorder traverse** : Root를 제일 먼저 순회 **`Root L R`**
    1. Root 출력
    2. Left child 출력
    3. Left leaf로 갈때까지 반복
    4. Root 출력후 Right child 기준으로 반복 (Right leaf로 갈때까지)

+ **후위 순회 postorder traverse** : Root를 제일 마지막에 순회 **`L R Root`**
    1. Left leaf 이동 및 출력
    2. Right child 출력
    3. Parent node 출력
    4. 위로 올라가며 반복
    5. Root 출력후 Right child 기준으로 반복

+ **중위 순회 inorder traverse** : Root를 중간에 순회 **`L Root R`**
    1. Left leaf 이동 및 출력
    2. Parent node 출력
    3. Right child 출력
    4. 한 레벨씩 위로 올라가며 반복
    5. Root 출력후 Right child 기준으로 반복

![image](https://github.com/lielocks/WIL/assets/107406265/1adb7497-637d-4c1a-9d40-260a2d72e224)


<br>


### 3. 완전 이진 트리 (Complete Binary Tree)

+ 완전 이진 트리 Complete Binary Tree

![image](https://github.com/lielocks/WIL/assets/107406265/8c9c515e-da92-4f67-994e-eac20f61eff5)

    
1. 완전 이진트리는 **마지막 레벨을 제외 하고 모든 레벨이 완전히 채워져 있다.**
   
2. **`마지막 레벨은 꽉 차 있지 않아도 되지만,`** 노드가 왼쪽에서 오른쪽으로 채워저야 한다.
    
3. 완전 이진 트리는 배열을 사용해 효율적으로 표현 가능하다. 완전 이진 트리의 개념은 힙(heap)과 관련이 있다.

 
![image](https://github.com/lielocks/WIL/assets/107406265/c2401bbf-7d90-486d-b18d-3ca2e62dc5cb)

![image](https://github.com/lielocks/WIL/assets/107406265/4a667eb9-6868-4525-84b9-7bb453b579ee)

마지막 레벨을 제외한 모든 서브트리의 레벨이 같아야 하고, 마지막 레벨은 왼쪽부터 채워져 있어야한다.

**레벨이 다 맞고 왼쪽부터 채워져 있는 트리**

<br>

### 4. 정 이진 트리 (Full Binary Tree)

![image](https://github.com/lielocks/WIL/assets/107406265/9d041266-39be-4d38-b687-253e68236589)

**모든 노드가 0개 또는 2개의 자식 노드를 갖는 트리** 이다.

(자식을 하나만 가진 노드가 없어야 함)

<br>


![image](https://github.com/lielocks/WIL/assets/107406265/16bada95-d955-4cb1-afbd-3acdf85d6f06)

<br>

### 5. 완전 이진 탐색 트리 (Complete Binary Search Tree)

**완전 이진 트리 Complete Binary Tree 성질을 가지는 이진 탐색 트리** 이다.

![image](https://github.com/lielocks/WIL/assets/107406265/a339acd4-3ab2-4326-b45b-3aaffbba5ef2)

편향된 이진 탐색 트리와 다르게 **`항상 O(log n)의 검색 속도`** 를 보장한다.
하지만 트리에 자료가 삽입될 때 마다 완전 이진 탐색 트리의 형태를 유지하기 위해
트리의 모양을 바꾸어야 하기 때문에 *삽입 시 시간이 많이 소요* 된다.

따라서 삽입이 적고 탐색이 많은 경우에 유리하며
삽입하는 빈도수가 높아지면 효율성이 떨어지고 이를 해결한 것이 **AVL트리** 이다.

<br>

### 6. 포화 이진 트리 (Perfect Binary Tree)

**정 이진 트리 full binary tree** + **완전 이진 트리 complete binary tree** 인 경우이다.

**`모든 리프 노드의 레벨이 동일`** 하고 **`모든 레벨이 가득 채워져 있는 트리`** 이다.

**즉 모든 노드가 두개의 자식 노드를 가지며 모든 리프 노드가 동일한 깊이 또는 레벨을 갖는다.**

![image](https://github.com/lielocks/WIL/assets/107406265/7aab9c09-23e9-4373-9bd3-0caab8eda7f2)

완벽한 피라미드 형태로, **`모든 노드의 자식이 2개씩`** 있다.

(해당 트리 노드의 갯수는 2^3-1 = 7 Root 제외 모든 노드는 자식을 2개씩 가지고 있으므로 -1 을 해준다.)

![image](https://github.com/lielocks/WIL/assets/107406265/d64f058b-98df-4b04-9e64-ad997aea92df)

<br>

### 7. 편향 이진 트리 (Skewed Binary Tree)

같은 높이의 이진 트리 중에서 최소 개수의 노드 개수를 가지면서 왼쪽 혹은 오른쪽 sub tree 만을 가지는 이진트리이다.

즉 **모든 노드가 왼쪽에 있거나 반대로 오른쪽에 있는 트리** 이다.

![image](https://github.com/lielocks/WIL/assets/107406265/ca48e2c4-9b5b-4d3e-8d02-aa7e32fe0939)

각 부모 노드가 오직 한 개의 연관 자식 노드를 갖는 트리이다.

`사향 이진 트리(Degenerate (or Pathological) Tree)` 라고도 부른다.

**Linked List 성능** 과 동일하다.

<br>

### 8. 균형 이진 트리 (Balanced Binary Tree)

높이 균형이 맞춰진 이진트리이다.

**왼쪽과 오른쪽 트리의 높이차이가 모두 1만큼 나는 트리** 이다.

![image](https://github.com/lielocks/WIL/assets/107406265/55445d5b-541a-4dd9-b68b-c8ebd228166a)

예로는 `AVL(높이 균형 이진 탐색 트리)` 과 `Red-Black 트리` 가 있다.

<br>

### 9. 높이 균형 이진 탐색 트리 (Adelson-Velsky and Landis, AVL 트리)
**스스로 균형을 잡는 이진 탐색 트리** 이다.

![image](https://github.com/lielocks/WIL/assets/107406265/2b168ddb-5013-4b13-acd5-de1d32c53501)

균형을 잡을 때 핵심되는 것은 바로 **Balance Factor** 라는 것인데
Balance Factor 는 `왼쪽과 오른쪽의 자식의 높이 차이` 를 뜻한다.
이 때 균형이 잡혔다는 것은 BF가 `최대 1까지 차이나는 것, 즉 -1부터 1까지일 때`를 의미한다.

이진 탐색 트리는 삽입, 삭제, 탐색 모두 평균은 O(logN)이지만 최악은 O(N)인데,
**AVL 트리** 는 삽입, 삭제, 탐색 모두 평균이든 최악의 경우든 **O(logN)** 이다.

AVL 트리에서 삽입, 삭제 연산을 수행할 때 트리의 균형을 유지하기 위해 LL-회전, RR-회전, LR-회전, RL-회전연산이 사용된다.

<br>

### 10. Red-Black 트리

**자가 균형 이진 탐색 트리** 이다.

RBT(Red-Black Tree)는 BST(Binary Search Tree) 를 기반으로하는 트리 형식의 자료구조이다. 

결론부터 말하자면 Red-Black Tree 에 데이터를 저장하게되면 Search, Insert, Delete 에 O(log n)의 시간 복잡도가 소요된다. 

동일한 노드의 개수일 때, depth 를 최소화하여 시간 복잡도를 줄이는 것이 핵심 아이디어이다. 

동일한 노드의 개수일 때, **`depth 가 최소가 되는 경우`** 는 tree 가 **complete binary tree** 인 경우이다.

![image](https://github.com/lielocks/WIL/assets/107406265/edb0e741-6c7a-4333-ad5a-2681dd4fd0b0)

1. 모든 노드는 빨간색 혹은 검은색이다.

2. **루트 노드** 는 **검은색** 이다.

3. 모든 **리프 노드(NIL)들** 은 **검은색** 이다. 

4. 어떤 **노드의 색깔이 red** 라면 **두 개의 children 의 색깔은 모두 black** 이다.

5. 각 노드에 대해서 노드로부터 descendant leaves (자식 노드와 그 자식들을 총칭) 까지의 단순 경로는 모두 같은 수의 black nodes 들을 포함하고 있다.


![image](https://github.com/lielocks/WIL/assets/107406265/31547dfd-7523-4b0b-a52c-104c45e0025d)


이를 해당 노드의 Black-Height라고 한다. 
  
*cf) Black-Height : 노드 x 로부터 노드 x 를 포함하지 않은 leaf node 까지의 simple path 상에 있는 black nodes 들의 개수*

<br>

### Red-Black Tree 의 특징

1.  **Binary Search Tree** 이므로 BST 의 특징을 모두 갖는다. BST 의 worst case 단점을 개선
2.  Root node 부터 leaf node 까지의 모든 경로 중 최소 경로와 최대 경로의 크기 비율은 2 보다 크지 않다. 이러한 상태를 `balanced` 상태라고 한다.
3.  노드의 child 가 없을 경우 child 를 가리키는 포인터는 **NIL 값을 저장** 한다. 이러한 NIL 들을 `leaf node` 로 간주한다.

_RBT 는 BST 의 삽입, 삭제 연산 과정에서 발생할 수 있는 문제점을 해결하기 위해 만들어진 자료구조이다. 
이를 어떻게 해결한 것인가?_

<br>

### 삽입

우선 BST 의 특성을 유지하면서 노드를 삽입을 한다. 그리고 삽입된 노드의 색깔을 **RED 로** 지정한다. 

Red 로 지정하는 이유는 Black-Height 변경을 최소화하기 위함이다. 

삽입 결과 RBT 의 특성 위배(violation)시 노드의 색깔을 조정하고, Black-Height 가 위배되었다면 rotation 을 통해 height 를 조정한다. 

이러한 과정을 통해 RBT 의 동일한 height 에 존재하는 internal node 들의 Black-height 가 같아지게 되고 최소 경로와 최대 경로의 크기 비율이 2 미만으로 유지된다.

![image](https://github.com/lielocks/WIL/assets/107406265/fbb6f6b0-25b0-410e-9389-3a7e46046b49)

![image](https://github.com/lielocks/WIL/assets/107406265/b58c5bec-0c0d-4fbc-b62b-8e5c356b3a3a)

![image](https://github.com/lielocks/WIL/assets/107406265/52718e05-dbe3-4f19-aafb-483da8c256dd)

![image](https://github.com/lielocks/WIL/assets/107406265/c70a37e7-339c-4dec-8615-d24af161107c)

![image](https://github.com/lielocks/WIL/assets/107406265/d0be9aac-49de-4ce0-bcf7-0188712cfb99)

![image](https://github.com/lielocks/WIL/assets/107406265/818c00a4-6418-48e1-bae8-03cfe39a7eef)


<br>

### 삭제

삭제도 삽입과 마찬가지로 BST 의 특성을 유지하면서 해당 노드를 삭제한다. 

삭제될 노드의 child 의 개수에 따라 rotation 방법이 달라지게 된다. 

그리고 만약 지워진 노드의 색깔이 Black 이라면 Black-Height 가 1 감소한 경로에 black node 가 1 개 추가되도록 rotation 하고 노드의 색깔을 조정한다. 

지워진 노드의 색깔이 red 라면 Violation 이 발생하지 않으므로 RBT 가 그대로 유지된다.

Java Collection 에서 TreeMap 도 내부적으로 RBT 로 이루어져 있고, HashMap 에서의 `Separate Chaining`에서도 사용된다. 그만큼 효율이 좋고 중요한 자료구조이다.

![image](https://github.com/lielocks/WIL/assets/107406265/7347438d-4a43-4a5f-bb4a-cd638e367dfd)

![image](https://github.com/lielocks/WIL/assets/107406265/bd0578d0-9396-486e-89dc-e950abef9098)

![image](https://github.com/lielocks/WIL/assets/107406265/fbf7ef9f-0cb3-4e23-80eb-6d6bd149a030)

![image](https://github.com/lielocks/WIL/assets/107406265/930ceeac-1cbc-491f-8314-6dba8f9de41b)

![image](https://github.com/lielocks/WIL/assets/107406265/6ffb4180-3a92-4a71-8cd7-c3845a58def7)

![image](https://github.com/lielocks/WIL/assets/107406265/608722f7-ebe6-47d0-84d9-721e1023b172)

![image](https://github.com/lielocks/WIL/assets/107406265/dc992e35-7175-4c53-a4e3-6fb9eebed816)

![image](https://github.com/lielocks/WIL/assets/107406265/f8c52771-f4a4-4d1b-a0b9-9e10cf6a615f)

<br>

이진 탐색 트리와 달리 **최악의 경우에도 O(log n)의 시간복잡도** 로 삽입, 삭제, 검색을 할 수 있기 때문에 사용한다.

AVL 트리는 균형을 엄격하게 유지하는데, **`red-black tree는 색상이 추가되어 여유롭게 균형을 유지`** 하기 때문에 **AVL 트리에 비하여 삽입, 삭제가 빠르다.**

<br>

### 왜 Red Black tree가 AVL tree보다 많이 쓰일까?

두 트리 모두 삽입, 삭제, 검색시 **O(logN)** 의 시간이 소요되는건 똑같다.

하지만 **AVL tree 는 트리의 밸런스가 좀 더 엄격하게 유지되기 때문에 `탐색` 에 유리** 하고
**Red Black tree 는 밸런싱을 느슨하게 하기 때문에 AVL tree에 비해 탐색엔 불리하지만 `삽입, 삭제` 에 유리** 하다.

![image](https://github.com/lielocks/WIL/assets/107406265/cec83c60-3314-410e-8c72-f672c6ecc4af)

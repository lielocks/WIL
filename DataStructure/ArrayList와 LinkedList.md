# ArrayList vs LinkedList 특징 & 성능 비교
															
														
### LinkedList vs ArrayList 특징 비교 

LinkedList가 각기 노드를 두고 주소 포인터를 링크하는 식으로 자료를 구성한 이유는 
ArrayList가 배열을 이용하여 요소를 저장함으로써 발생하는 단점을 극복하기 위해 고안되었기 때문이다.
																	
![image](https://github.com/lielocks/WIL/assets/107406265/93d643bc-4970-491e-80f3-db6cfd5f4b16)

</br>

### ArrayList 의 문제점

ArrayList 는 배열 공간 (capacity) 가 꽉차거나, 요소 중간에 삽입을 행하려 할때 **`기존의 배열을 복사해서 요소를 뒤로 한칸씩 일일히 이동`** 해야 하는 작업이 필요하다.

이러한 부가적인 연산은 시스템의 성능 저하로 이어져 삽입 / 삭제가 빈번하게 발생하는 process 의 경우 치명적 !

그리고 자료들이 지속적으로 삭제되는 과정에서 ArrayList 에서는 그 공간만큼 낭비되는 메모리가 많아지게 되고 또한 resizing 처리에서 시간이 소모된다.

![image](https://github.com/lielocks/WIL/assets/107406265/00dce451-3498-451b-8851-eb8d9bc6a8af)

</br>

### LinkedList 의 장단점

반면, LinkedList 는 불연속적으로 존재하는 데이터들을 서로 연결 (link) 한 형태로 구성되어 있기 때문에 **공간의 제약이 존재하지 않으며** 

삽입 역시 node 가 가리키는 pointer 만 바꿔주면 되기 때문에 배열처럼 데이터를 이동하기 위해 복사하는 과정이 없어

**`삽입 / 삭제 처리 속도가 빠르다.`** 

따라서 **`삽입 / 삭제`** 가 빈번하게 발생하는 process의 경우 **LinkedList** 를 사용하여 시스템 구현하는 것이 바람직.
</br>
하지만 LinkedList에도 단점이 존재!

**요소를 get** 하는 과정에서 ArrayList 와 굉장한 성능 차이 !

+ **`ArrayList`** 에서는 무작위 접근 (random access) 이 가능하지만

+ **`LinkedList`** 에서는 순차 접근 (sequential access) 만이 가능하기 때문이다.

+ 예를 들어 n개의 자료를 저장할 때, ArrayList는 자료들을 **`하나의 연속적인 묶음`** 으로 묶어 저장하는 반면

+ LinkedList는 자료들을 저장 공간에 **`불연속적인 단위`** 로 저장하게 된다.

이를 그림으로 표현하자면, 아래 빌딩 그림을 메모리(RAM) 으로 비유하고 각기 방을 데이터라고 비유하자면,
ArrayList는 연속적인 묶음으로 되어있지만,
LinkedList는 각기 다른 방에 저장되어 있고 link로 연결되어 있음을 볼 수 있다. 

![image](https://github.com/lielocks/WIL/assets/107406265/239b494e-7e2d-49b0-bd4c-3a62be5b1560)

그래서 **`LinkedList`** 는 메모리 이곳저곳에 산재해 저장되어 있는 node들을 접근하는데 있어 ArrayList 보다 당연히 **`긴 지연 시간`** 이 소모되게 된다.

특히 Singly Linked List는 단방향성만 갖고 있기 때문에 index를 이용하여 자료를 검색한는 어플리케이션에는 적합하지 않다.

LinkedList의 또 다른 단점은 참조자를 위해 **추가적인 메모리를 할당**해야 하는 점 이다. 

배열 같은 경우 그냥 데이터 그대로만 저장하면 되지만, LinkedList의 node 같은 경우 데이터 이외에 `next` 나 `prev` 같은 참조자도 저장해야 되기 때문에 추가적인 공간이 더 필요 할 수 밖에 없다.
![image](https://github.com/lielocks/WIL/assets/107406265/1cc7bcfd-0a7f-458d-bbcd-fa0aabb756de)

</br>

## LinkedList vs ArrayList 성능 비교

### 시간 복잡도 비교


LinkedList를 처음 배우는 새내기들이 착각하는 것이, 요소를 추가하는 것과 요소를 삭제하는 것의 시간복잡도가 오로지 O(1) 이라는 점이다. 

맨 앞이나 맨 뒤 요소만 추가하고 삭제한다고 가정하면 시간복잡도는 O(1)이 맞지만, 중간에 요소를 추가 / 삭제 한다면 그 중간 위치까지 탐색을 해야 하므로 최종적으로 **`O(N)`** 이 된다.

>
>Tip
>
>그래도 탐색 시간 (search time) 에 시간이 그리 소요되지 않으면 ArrayList 보다 삽입 속도가 빠르기 때문에
>표기가 저렇지 왠만한 상황에서는 LinkedList가 ArrayList 보다 우위로 보면 된다.
>


![image](https://github.com/lielocks/WIL/assets/107406265/c1d3834d-46cb-495c-a89c-82edd1c07289)

위의 표에서 ArrayList에서 첫번쨰 삽입이 O(N)인 이유는 무조건적으로 요소들을 뒤로 이동해야 하기 때문이다.

그리고 마지막 위치 삽입이 O(1) 또는 O(N) 이 되는 이유는 만일 공간 부족으로 인해 배열 복사가 일어나면 시간이 소요되기 때문이다.

</br>

### 실제 성능 측정

두 리스트에 대해 실제 메서드 동작 시간을 측정한 그래프이다.

조회 (get) 시에는 arrayList 가 우위지만 삽입 / 삭제 (add / remove) 시에는 LinkedList가 뛰어난 성능을 보여준다.

![image](https://github.com/lielocks/WIL/assets/107406265/1e6453a6-e15c-4863-91f8-a78f432de7e3)

</br>

```java
public static void main(String[] args) {
    //추가할 데이터의 개수를 고려해서 크기를 지정해야함
    ArrayList<Number> al = new ArrayList<>();
    LinkedList<Number> ll = new LinkedList<>();

    System.out.println("+++ 순차적으로 추가하기 +++");
    System.out.println("ArrayList  : " + add1(al));
    System.out.println("LinkedList : " + add1(ll));
    System.out.println();

    System.out.println("+++ 중간에 추가하기 +++");
    System.out.println("ArrayList  : " + add2(al));
    System.out.println("LinkedList : " + add2(ll));
    System.out.println();

    System.out.println("+++ 접근시간 테스트 +++");
    System.out.println("ArrayList  : " + access(al));
    System.out.println("LinkedList : " + access(ll));
    System.out.println();

    System.out.println("+++ 중간에서 삭제하기 +++");
    System.out.println("ArrayList  : " + remove2(al));
    System.out.println("LinkedList : " + remove2(ll));
    System.out.println();

    System.out.println("+++ 순차적으로 삭제하기 +++");
    System.out.println("ArrayList  : " + remove1(al));
    System.out.println("LinkedList : " + remove1(ll));
    System.out.println();
}
```

</br>

```java
public static long add1(List list) {
    long start = System.nanoTime();
    for (int i = 0; i < 10000; i++)
        list.add(i + 1);
    long end = System.nanoTime();
    return end - start;
}

public static long add2(List list) {
    long start = System.nanoTime();
    for (int i = 0; i < 10000; i++)
        list.add(500, 1);
    long end = System.nanoTime();
    return end - start;
}

public static long remove1(List list) {
    long start = System.nanoTime();
    for (int i = list.size() - 1; i >= 0; i--)
        list.remove(i);
    long end = System.nanoTime();
    return end - start;
}

public static long remove2(List list) {
    long start = System.nanoTime();
    for (int i = 0; i < 10000; i++)
        list.remove(500);
    long end = System.nanoTime();
    return end - start;
}

public static long access(List list) {
    long start = System.nanoTime();
    for (int i = 0; i < 10000; i++)
        list.get(i);
    long end = System.nanoTime();
    return end - start;
}
```

</br>

![image](https://github.com/lielocks/WIL/assets/107406265/4ca34147-04ba-4213-a0f4-57ea53f7b09c)

</br>

1. [순차 추가] 가 Linkedlist가 우위인 이유는 ArrayList는 공간 부족으로 인한 배열 복사가 일어나기 때문이다.

2. [중간 추가] 가 LinkedList가 우위인 이유는 ArrayList는 배열 복사 및 데이터 이동 (shift) 가 발생하기 때문이다.

3. [접근 시간] 이 ArrayList가 우위인 이유는 메모리 저장 구조상 배열은 연속된 공간에 저장되고 index로 단번에 access 하기 때문이다.

4. [중간 삭제] 가 LinkedList가 우위인 이유는 요소 이동 없이 그저 node의 pointing만 교체만 하면 되기 때문이다.

5. [순차 삭제] 가 ArrayList가 우위인 이유는 아무래도 node 의 link를 끊고 하는 작업 보단 배열에서 요소를 삭제하는게 더 빠르기 때문이다.

6. </br>

### LinkedList는 의외로 잘 사용되지 않는다

보통 ArrayList와 LinkedList 중 어느걸 사용하면 되냐고 묻는다면, *삽입 / 삭제가 빈번하면 LinkedList* 를, 
*요소 가져오기가 빈번* 하면 ArrayList를 사용하면 된다 라고들 가르쳐주지만 사실 **성능면에서 둘은 큰 차이가 없다.** 

예를 들어 ArrayList는 Resizing 과정에서 배열 복사하는 추가 시간이 들지만, 배열을 새로 만들고 for문을 돌려 기존 요소를 일일히 대입하는 그러한 처리가 아니라,

내부적으로 잘 튜닝이 되고 최적화되어 있어 우리가 생각하는 것처럼 전혀 느리지않다.

위의 성능 코드 예시 역시 두각을 나타내기 위해 극단적으로 nanomillisec 로 비교해서 그렇지 체감상 차이 큰 편 X.

또한 외국 사례를 검색하여 살펴보면 LinkedList를 사용하는 사례 << ArrayList 사용 사례 

Java의 collection frameword 등 java 플랫폼의 설계와 구현을 주도한 조슈아 블로치 본인도 자신이 설계했지만 잘 사용하지 않는다고 말할 정도.

FIFO(선입선출)이 빈번할 경우, ArrayList 경우 첫번째에 요소를 추가할 때마다 자주 데이터 이동(shift)가 일어나기 때문에 

큐(queue)를 사용해야 할때 LinkedList를 사용한다 라고 말하지만, 차라리 그런경우엔 따로 `ArrayDeQue` 라는 더욱 최적화된 컬렉션을 쓰는 것이 훨씬 좋다.

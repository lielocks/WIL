# Java Collections Framework 종류

## Java Collection Framework

자바 새내기분들은 컬렉션 프레임워크라는 단어에 뭔가 거창하고 어려운 느낌이 들수 있겠지만, 
그냥 자료 구조(Data Structure) 종류의 형태들을 자바 클래스로 구현한 모음집 이라고 보면 된다.

예를들어 C언어에서 LinkedList 라는 자료구조를 사용하려면 직접 구현해야 되지만 자바 개발자는 그냥 인스턴스화만 하면 사용이 가능하다.
즉, 데이터를 저장하는 자료 구조와 데이터를 처리하는 알고리즘을 구조화하여 class 로 구현해 놓은 것이 Java Collection Framework (JCF) 이다.

물론 자바도 직접 자료 구조 class를 만들어 사용할 수는 있겠지만, 알고리즘의 속도와 안정성에 있어 java 언어 개발자들이 
수십년에 걸쳐 JVM에 최적화시켜 개량해왔기 때문에,
만일 java 프로그래밍에서 자료 구조를 사용할 일이 있다면 Collection Framework를 가져와 사용하면 된다.

</br>

### 컬렉션 프레임워크 장점

java 만의 collection framework의 장점들 !

+ 인터페이스와 다형성을 이용한 개체지향적 설계를 통해 표준화되어 있기 때문에, 사용법 익히기 좋고 재사용성 높다.

+ 데이터 구조 및 알고리즘의 고성능 구현을 제공하여 프로그램의 성능과 품질을 향상시킨다.

+ 관련 없는 API 간의 상호 운용성을 제공한다. (상위 인터페이스 타입으로 업캐스팅하여 사용)

+ 이미 구현되어있는 API를 사용하면 되기에, 새로운 API를 익히고 설계하는 시간이 줄어든다.

+ 소프트웨어 재사용을 촉진한다. 만일 자바에서 지원하지 않는 새로운 자료구조가 필요하다면, 컬렉션들을 재활용하여 좁합하여 새로운 알고리즘을 만들어낼 수 있다.

>
> Tip
>
> 컬렉션 프레임워크에 저장할 수 있는 데이터는 오로지 **객체(Object)** 뿐이다.
> 즉, int형이나 double형 같은 자바의 primitive data type 은 적재를 못한다는 말이다.
> 따라서 primitive 타입을 wrapper 타입으로 변환하여 Integer 객체나 Double 객체로 박싱(Boxing)하여 저장하여야 한다.
> 또한 객체를 담는 다는 것은 곧 **`주소값을 담는다는 것`** 이니, *null도 저장이 가능* 하다
>

</br>

## 컬렉션 프레임워크 종류
![image](https://github.com/lielocks/WIL/assets/107406265/40143a84-bd9e-4fa1-86e8-1a0e8e1abe72)

컬렉션 프레임워크는 크게 **Collection 인터페이스** 와 **Map 인터페이스** 로 나뉜다.

List 와 Set 인터페이스를 구현한 컬렉션 클래스들은 공통부분이 많기 때문에, 
공통된 부분을 모은 Collection 인터페이스로 상속 되어있다. 

Map 인터페이스 컬렉션들은 `두개의 데이터를 묶어 한쌍으로 다루기 때문에` Collection 인터페이스와 따로 분리되어 있다.

>
> Tip
> 대부분의 컬렉션 클래스들은 List, Set , Map 중의 하나를 구현하고 있으며,
> 구현한 인터페이스의 이름이 클래스 이름에 포함되는 특징이 있다. (ArrayList, HashSet, HashMap ... 등)
>
> 그러나 Vector, Stack, Hashtable, Properties 와 같은 클래스들은 컬렉션 프레임워크가 만들어지기 이전부터 존재하던 것이기 때문에 컬렉션 프레임워크의 명명법을 따르지 않는다.
> 또한 Vector 나 Hashtable 과 같은 기존의 컬렉션 클래스들은 호환을 위해 남겨진 것이므로 가급적 사용하지 않는 것이 좋다.

</br>

### Iterable 인터페이스
![image](https://github.com/lielocks/WIL/assets/107406265/fb2b1c86-7e55-499b-b620-83eedea1b530)

+ 컬렉션 인터페이스들의 가장 최상위 인터페이시ㅡ

+ 컬렉션들을 배우다 보면 자료들을 순회할때 iterator 객체를 다뤄보게 될텐데, 이 이터레이터 객체를 관리하는 interface 로 보면 된다.

  ![image](https://github.com/lielocks/WIL/assets/107406265/5fd48c16-0f4e-4d39-b8e2-cf1616a92fa3)

>
> Tip
>
> 참고로 Map은 iterable 인터페이스를 상속받지 않기 때문이 iterator()와 spliterator()는 Map 컬렉션에 구현이 되어 있지 않다.
>
> 따라서 직접적으로 Map 컬렉션을 순회할수는 없고 스트림(Stream)을 사용하거나 간접적으로 키를 Collection으로 반환하여 루프문으로 순회하는 식을 이용한다.

</br>

### Collection 인처페이스 
![image](https://github.com/lielocks/WIL/assets/107406265/69134800-e7a2-4b6d-a7bc-55b7434403b1)

+ List, Set, Queue 에 상속을 하는 **실질적인 최상위 컬렉션 타입**

+ 즉 업캐스팅으로 다양한 종류의 컬렉션 자료형을 받아 자료를 삽입하거나 삭제, 탐색 기능을 할 수 있다. (다형성)

![image](https://github.com/lielocks/WIL/assets/107406265/3a179655-b89d-43ab-b5ee-e126ced5112a)
![image](https://github.com/lielocks/WIL/assets/107406265/24f7e9ea-e40e-41f9-9305-a0ad2446eafe)

>
> Tip
> JDK 1.8 부터는 함수형 프로그래밍을 위해 parallelStream, removeIf, stream, forEach default 메서드가 추가되었다.
>


```java
Collection<Number> col1 = new ArrayList<>();
col1.add(1);

Collection<Number> col2 = new HashSet<>();
col1.add(1);

Collection<Number> col3 = new LinkedList<>();
col1.add(1);
```

*Collection 인터페이스의 메서드를 보면 요소(객체)에 대한 추가, 삭제, 탐색은 다형성 기능으로 사용이 가능하지만, 
데이터를 get 하는 메서드는 보이지 않는다. 
왜냐하면 각 컬렉션 자료형 마다 구현하는 자료 구조가 제각각 이기 때문에 최상위 타입으로 조회하기 까다롭기 때문이다.*

</br>

### List 인터페이스 
![image](https://github.com/lielocks/WIL/assets/107406265/82975663-7914-4e97-a658-5461fe65ba12)

+ 저장 순서가 유지되는 컬렉션을 구현하는 데 사용

+ 같은 요소의 중복 저장을 허용

+ 배열과 마찬가지로 index 로 요소에 접근

+ List 와 Array 의 가장 큰 차이는 List 는 **자료형 크기** 가 고정이 아닌 **동적으로 늘어났다 줄어들 수 있다** 는 점이다. (가변)

+ **요소 사이에 빈공간을 허용하지 않아** 삽입 / 삭제 할때마다 배열 이동이 일어난다.

![image](https://github.com/lielocks/WIL/assets/107406265/9952a094-e215-4db8-81af-a53989bdd6eb)

</br>

### ArrayList 클래스

![image](https://github.com/lielocks/WIL/assets/107406265/1702c761-fb68-4e61-89eb-c1e8ed17bff0)

+ 배열을 이용하여 만든 List

+ 데이터의 저장순서과 유지되고 중복을 허용

+ 데이터량에 따라 공간 (capacity) 가 자동으로 늘어나거나 줄어들음

+ 단방향 포인터 구조로 자료에 대한 순차적인 접근에 강점이 있어 **조회가 빠르다.**

+ 하지만, **`삽입 / 삭제가 느리다`** 는 단점이 있다. 단, 순차적으로 추가 / 삭제 하는 경우에는 가장 빠르다.

```java
List<String> arrayList = new ArrayList<>();

arrayList.add("Hello");
arrayList.add("World");

arrayList.get(0) // "Hello"
```

</br>

### LinkedList 클래스
![image](https://github.com/lielocks/WIL/assets/107406265/2dd3b0ad-d256-4b31-870a-f849157dce61)

+ 노드 (객체)를 연결하여 list 처럼 만든 컬렉션 (array 가 아님)

+ 데이터의 **`중간 삽입, 삭제가 빈번할 경우 빠른 성능`** 을 보장한다.

+ 하지만 **임의의 요소에 대한 접근** 성능은 좋지 않다.

+ 자바의 LinkedList 는 Doubly LinkedList(양방향 포인터 구조) 로 이루어져 있다.

+ LinkedList 는 리스트 용도 이외에도 stack, queue, tree 등의 자료구조의 근간이 된다.

```java
List<String> linkedList = new LinkedList<>();

linkedList.add("Hello");
linkedList.add("World");

linkedList.get(0); // "Hello"
```

</br>

### Vector 클래스

![image](https://github.com/lielocks/WIL/assets/107406265/a9496e4b-80ef-430b-a509-47153cbe0ad6)

+ ArrayList 의 구형 버전 ( 내부 구성이 거의 비슷 )

+ ArrayList 와의 차이는 모든 메소드가 동기화(synchronized) 되어있어 Thread-Safe 하다는 점이다.

+ 구버전 java와 호환성을 위해 남겨두었으나 잘 쓰이지는 X.

>
> Tip
>
> 만일 현업에서 컬렉션에 동기화가 필요하면 Collections.synchronizedList() 메서드를 이용해 ArrayList를 동기화 처리하여 사용한다.

```java
List<Integer> vector = new Vector<>();

vector.add(10);
vector.add(20);

vector.get(0); // 10
```

</br>

### Stack 클래스

![image](https://github.com/lielocks/WIL/assets/107406265/dc35866c-5062-4cfb-951d-7126420f491e)

+ 후입선출 LIFO Last-In-First-Out 자료구조

+ 마지막에 들어온 원소가 처음으로 나간다.

+ 들어올떄는 push 나갈때는 pop

+ Stack 은 Vector를 상속하기 때문에 문제점이 많아 잘 안쓰이고 `ArrayDeque` 사용


```java
Stack<Integer> stack = new Stack<>();

stack.push(30);
stack.push(50);

stack.pop(); // 50
stack.pop(); // 30
```

</br>

### Queue 인터페이스

![image](https://github.com/lielocks/WIL/assets/107406265/049484e8-eff1-4e84-9945-78f328cb083d)

+ 선입선출 FIFO First-In-First-Out 구조

+ 처음 들어온 원소가 가장 먼저 나간다

+ java에서는 Queue 는 interface 이고 필요에 따라 Queue collection 을 골라 사용할 수 있다.

![image](https://github.com/lielocks/WIL/assets/107406265/66a6e559-86da-499c-9a32-301f7faf0e6e)

</br>

### PriorityQueue 클래스

![image](https://github.com/lielocks/WIL/assets/107406265/98748b04-b1dc-4150-8fdf-3521fb34433a)

+ 우선 순위를 가지는 큐 (우선 순위 큐)

+ 일반적인 큐와는 조금 다르게, 원소에 **우선 순위(priority)** 를 부여하여 우선 순위가 높은 순으로 정렬되고 꺼낸다.

+ 수행할 작업이 여러개 있고 시간이 제한되어 있을 때 우선순위가 높은 것부터 수행할 때 쓰인다. (네트워크 제어, 작업 scheduling)

+ 우선순위 큐에 저장할 객체는 필수적으로 **Comparable interface** 를 구현해야 한다.
  `compareTo()` 메서드 로직에 따라 자료 객체의 우선순위를 결정하는 식으로 동작되기 때문이다.

+ 저장 공간으로 배열을 사용하며, 각 요소를 heap 형태로 저장한다.

+ null 저장 불가능

* 힙(heap)은 이진 트리의 한 종류로 우선순위가 가장 높은 자료를 루트 노드로 갱신한다는 점으로, 가장 큰 값이나 가장 작은 값을 빠르게 찾을 수 있다는 특징이 있다.*

</br>

```java
// 우선순위 큐에 저장할 객체는 필수적으로 Comparable를 구현
class Student implements Comparable<Student> {
    String name; // 학생 이름
    int priority; // 우선순위 값

    public Student(String name, int priority) {
        this.name = name;
        this.priority = priority;
    }

    @Override
    public int compareTo(Student user) {
        // Student의 priority 필드값을 비교하여 우선순위를 결정하여 정렬
        if (this.priority < user.priority) {
            return -1;
        } else if (this.priority == user.priority) {
            return 0;
        } else {
            return 1;
        }
    }

    @Override
    public String toString() {
        return "Student{" +
                "name='" + name + '\'' +
                ", priority=" + priority +
                '}';
    }
}
```

</br>

```java
public static void main(String[] args) {

    // 오름차순 우선순위 큐
    Queue<Student> priorityQueue = new PriorityQueue<>();

    priorityQueue.add(new Student("주몽", 5));
    priorityQueue.add(new Student("세종", 9));
    priorityQueue.add(new Student("홍길동", 1));
    priorityQueue.add(new Student("임꺽정", 2));

    // 우선순위 대로 정렬되어 있음
    System.out.println(priorityQueue);
    // [Student{name='홍길동', priority=1}, Student{name='임꺽정', priority=2}, Student{name='주몽', priority=5}, Student{name='세종', priority=9}]

    // 우선순위가 가장 높은 값을 참조
    System.out.println(priorityQueue.peek()); // Student{name='홍길동', priority=1}

    // 차례대로 꺼내기
    System.out.println(priorityQueue.poll()); // Student{name='홍길동', priority=1}
    System.out.println(priorityQueue.poll()); // Student{name='임꺽정', priority=2}
    System.out.println(priorityQueue.poll()); // Student{name='주몽', priority=5}
    System.out.println(priorityQueue.poll()); // Student{name='세종', priority=9}
}
```

</br>

### Deque 인터페이스
![image](https://github.com/lielocks/WIL/assets/107406265/dfb926e8-2d61-40b4-89a1-639d214fe1ff)


+ Deque (Double-Ended Queue) 는 양쪽으로 넣고 뺴는 것이 가능한 큐를 말한다.

+ stack 과 queue 를 하나로 합쳐놓은 것과 같으며 stack 으로 사용할 수도 있고, queue 로 사용할 수도 있다.

+ Deque 의 조상은 Queue 이며, 구현체로 ArrayDeque 와 LinkedList 가 있다.

</br>

### ArrayDeque 클래스

![image](https://github.com/lielocks/WIL/assets/107406265/057a5967-8096-4e87-940d-45471c79968c)

+ stack 으로 사용할때 Stack 클래스보다 빠르며, 대기열로 사용할 때는 LinkedList 보다 빠르다.

+ 사이즈에 제한 X

+ null 요소는 저장되지 않는다.

![image](https://github.com/lielocks/WIL/assets/107406265/ea283a77-2370-4ae0-96f2-92c59d8dcfa1)

</br>

```java
Deque<Integer> deque = new ArrayDeque<>();

deque.offerLast(100); // [100]
deque.offerFirst(10); // [10, 100]
deque.offerFirst(20); // [20, 10, 100]
deque.offerLast(30); // [20, 10, 100, 30]

deque.pollFirst(); // 20 <- [10, 100, 30]
deque.pollLast(); // [10, 100] -> 30
deque.pollFirst(); // 10 <- [100]
deque.pollLast(); // [] -> 100
```

</br>

### LinkedList 클래스

![image](https://github.com/lielocks/WIL/assets/107406265/0b20914f-0c23-477a-a60c-32f00305b140)

+ LinkedList 는 List interface 와 Queue Interface를 동시에 상속받고 있기 때문에, Stack / Queue 로서도 응용이 가능하다.

+ 실제로 LinkedList 클래스에 큐 동작과 관련된 메서드를 지원한다. (push, pop, poll, peek, offer .. 등)

</br>

```java
Queue<String> linkedList = new LinkedList<>(); // Queue 타입으로 받음

linkedList.offer("Hello");
linkedList.offer("World");
linkedList.offer("Power");

linkedList.poll(); // "Hello" - 선입선출

System.out.println(linkedList); // [World, Power]
```

</br>

>
> Tip
>
> 큐(queue)는 데이터를 꺼낼 때 항상 첫 번째 저장된 데이터를 삭제하므로, ArrayList와 같은 배열 기반의 컬렉션 클래스를 사용한다면,
>
> 데이터를 꺼낼 때마다 빈 공간을 채우기 위해 데이터의 이동 & 복사가 발생하므로 비효율적이다.
>
> 그래서 큐는 ArrayList보다 데이터의 추가/삭제가 용이한 **LinkedList로 구현** 하는 것이 적합하다.

</br>

### Set 인터페이스

![image](https://github.com/lielocks/WIL/assets/107406265/8168dcd0-b8fe-446a-a48e-103ef669e375)

+ 데이터의 **중복을 허용하지 않고 순서를 유지하지 않는** 데이터의 집합 리스트

+ 순서 자체가 없으므로 index 로 객체를 검색해서 가져오는 `get(index)` 메서드도 존재하지 않는다.

+ 중복 저장이 불가능 심지어 null 값도 하나만 저장할 수 있다.

![image](https://github.com/lielocks/WIL/assets/107406265/79a225c5-4280-4ada-9828-34b3f9cc9e24)

</br>

### HashSet 클래스

![image](https://github.com/lielocks/WIL/assets/107406265/f19ae8a3-4ce6-4784-bf93-caaee4b88bb5)


+ 배열과 연결 node 를 결합한 자료구조 형태

+ 가장 빠른 임의 검색 접근 속도를 가진다

+ 추가, 삭제, 검색, 접근성이 모두 뛰어나다

+ 대신 순서를 전혀 예측할 수 없다

```java
Set<Integer> hashSet = new HashSet<>();

hashSet.add(10);
hashSet.add(20);
hashSet.add(30);
hashSet.add(10); // 중복된 요소 추가

hashSet.size(); // 3 - 중복된건 카운트 X

hashSet.toString(); // [20, 10, 30] - 자료 순서가 뒤죽박죽
```
</br>

### LinkedHashSet 클래스

+ 순서를 가지는 Set 자료

+ 추가된 순서 또는 가장 최근에 접근한 순서대로 접근 가능

+ 만일 중복을 제거하는 동시에 저장한 **순서를 유지** 하고 싶다면, HashSet 대신 LinkedHashSet 을 사용하면 된다.

```java
Set<Integer> linkedHashSet = new LinkedHashSet<>();

linkedHashSet.add(10);
linkedHashSet.add(20);
linkedHashSet.add(30);
linkedHashSet.add(10); // 중복된 수 추가

linkedHashSet.size(); // 3 - 중복된건 카운트 X

linkedHashSet.toString(); // [10, 20, 30] - 대신 자료가 들어온 순서대로 출력
```

</br>

### TreeSet 클래스

![image](https://github.com/lielocks/WIL/assets/107406265/d6d73e2c-1403-40c7-9367-fd3098d44431)

+ 이진 검색 트리 (binary search tree) 자료구조의 형태로 데이터를 저장

+ 중복을 허용하지 않고, 순서를 가지지 않는다

+ 대신 **데이터를 정렬** 하여 저장하고 있다는 특징이다.

+ 정렬, 검색, 범위 검색 에 높은 성능 !

```java
Set<Integer> treeSet = new TreeSet<>();

treeSet.add(7);
treeSet.add(4);
treeSet.add(9);
treeSet.add(1);
treeSet.add(5);

treeSet.toString(); // [1, 4, 5, 7, 9] - 자료가 알아서 정렬됨
```

</br>

![image](https://github.com/lielocks/WIL/assets/107406265/53e668be-357f-4abe-a994-f5931b9c7076)

</br>

### EnumSet 추상 클래스

+ Enum 클래스와 함께 동작하는 Set 컬렉션이다.

+ 중복 되지 않은 상수 그룹을 나타내는데 사용된다.
  
+ 산술 비트 연산을 사용하여 구현되므로 HashSet 보다 훨씬 빠르며, 적은 메모리를 사용한다.
  
+ 단, enum 타입의 요소값만 저장할 수 있고, 모든 요소들은 동인한 enum 객체에 소속되어야 한다.

+ EnumSet은 추상 클래스고 이를 상속한 RegularEnumSet 혹은 JumboEnumSet 객체를 사용하게 된다.


```java
enum Color {
    RED, YELLOW, GREEN, BLUE, BLACK, WHITE
}

public class Client {
    public static void main(String[] args) {
        // 정적 팩토리 메서드를 통해 RegularEnumSet 혹은 JumboEnumSet 을 반환
        // 만일 enum 상수 원소 갯수가 64개 이하면 RegularEnumSet, 이상이면 JumboEnumSet 객체를 반환
        EnumSet<Color> enumSet = EnumSet.allOf(Color.class);

        for (Color color : enumSet) {
            System.out.println(color);
        }

        enumSet.size(); // 6

        enumSet.toString(); // [RED, YELLOW, GREEN, BLUE, BLACK, WHITE]
    }
}
```

</br>

## Map 인터페이스

![image](https://github.com/lielocks/WIL/assets/107406265/f2221153-97ed-47d7-b6ff-7a0bd26137bf)

+ 키 Key 와 값 Value 의 쌍으로 연관지어 이루어진 데이터의 집합

+ **값 (Value) 는 중복돼서 저장될 수 있지만,** **`key는 해당 Map에서 고유`** 해야 한다.

+ 만일 기존에 저장된 데이터와 중복된 키와 값을 저장하면 기존의 값은 없어지고 마지막에 저장된 값이 남게 된다.

+ 저장 순서가 유지 X

![image](https://github.com/lielocks/WIL/assets/107406265/3bf4fc70-8897-416c-b8f0-22766eb5fb93)
![image](https://github.com/lielocks/WIL/assets/107406265/21054027-1bc2-44c8-8ec4-ce7a7b78020e)


>
> Tip
>
> Map 인터페이스의 메소드를 보면, `Key값을 반환할때 Set 인터페이스 타입`으로 반환하고, `Value값을 반환할때 Collection 타입`으로 반환하는걸 볼 수 있다.
>
> Map 인터페이스에서 값(value)은 중복을 허용하기 때문에 Collection 타입으로 반환하고, 키(key)는 **`중복을 허용하지 않기 때문에 Set 타입으로 반환`** 하는 것이다.

</br>

### Map.Entry 인터페이스
+ Map.Entry 인터페이스는 Map 인터페이스 안에 있는 내부 인터페이스이다.

+ Map 에 저장되는 key - value 쌍의 Node 내부 클래스가 이를 구현하고 있다.

+ Map 자료구조를 보다 객체지향적인 설계를 하도록 유도하기 위한 것이다.

![image](https://github.com/lielocks/WIL/assets/107406265/09805714-b01d-4d94-b0cc-94076df83701)
![image](https://github.com/lielocks/WIL/assets/107406265/77bfb79c-ad0c-423c-9867-82ab51fd8743)

</br>

```java
Map<String, Integer> map = new HashMap<>();
map.put("a", 1);
map.put("b", 2);
map.put("c", 3);

// Map.Entry 인터페이스를 구현하고 있는 Key-Value 쌍을 가지고 있는 HashMap의 Node 객체들의 Set 집합을 반환
Set<Map.Entry<String, Integer>> entry = map.entrySet();

System.out.println(entry); // [1=a, 2=b, 3=c]

// Set을 순회하면서 Map.Entry를 구현한 Node 객체에서 key와 value를 얻어 출력
for (Map.Entry<String, Integer> e : entry) {
    System.out.printf("{ %s : %d }\n", e.getKey(), e.getValue());
}
```

</br>

![image](https://github.com/lielocks/WIL/assets/107406265/9b28904d-fd98-4113-aabd-4ccb68505569)

</br>

### HashMap 클래스

![image](https://github.com/lielocks/WIL/assets/107406265/30008aa9-9be3-4f70-bde4-8ac9369ebd00)


+ Hashtable을 보완한 컬렉션

+ 배열과 연결이 결합된 Hashing형태로, 키(key)와 값(value)을 묶어 하나의 데이터로 저장한다

+ 중복을 허용하지 않고 순서를 보장하지 않는다

+ 키와 값으로 null이 허용된다

+ 추가, 삭제, 검색, 접근성이 모두 뛰어나다

+ HashMap은 비동기로 작동하기 때문에 멀티 쓰레드 환경에서는 어울리지않는다 (대신 ConcurrentHashMap 사용)

```java
Map<String, String> hashMap = new HashMap<>();

hashMap.put("love", "사랑");
hashMap.put("apple", "사과");
hashMap.put("baby", "아기");

hashMap.get("apple"); // "사과"

// hashmap의 key값들을 set 집합으로 반환하고 순회
for(String key : hashMap.keySet()) {
    System.out.println(key + " => " + hashMap.get(key));
}
/*
love => 사랑
apple => 사과
baby => 아기
*/
```

</br>

### LinkedHashMap 클래스

![image](https://github.com/lielocks/WIL/assets/107406265/e661ae2d-00af-4849-bfd8-f05daa4c5f7b)

+ HashMap 을 상속하기 때문에 흡사하지만, Enyry 들이 연결 리스트를 구성하여 **데이터의 순서를 보장** 한다.

+ 일반적으로 Map 자료구조는 순서를 가지지 않지만, LinkedHashMap 은 들어온 순서대로 순서를 가진다.

```java
Map<Integer, String> hashMap = new HashMap<>();

hashMap.put(10000000, "one");
hashMap.put(20000000, "two");
hashMap.put(30000000, "tree");
hashMap.put(40000000, "four");
hashMap.put(50000000, "five");

for(Integer key : hashMap.keySet()) {
    System.out.println(key + " => " + hashMap.get(key)); // HashMap 정렬 안됨
}

// ----------------------------------------------

Map<Integer, String> linkedHashMap = new LinkedHashMap<>();

linkedHashMap.put(10000000, "one");
linkedHashMap.put(20000000, "two");
linkedHashMap.put(30000000, "tree");
linkedHashMap.put(40000000, "four");
linkedHashMap.put(50000000, "five");

for(Integer key : linkedHashMap.keySet()) {
    System.out.println(key + " => " + linkedHashMap.get(key)); // LinkedHashMap 정렬됨
}
```

</br>

![image](https://github.com/lielocks/WIL/assets/107406265/2eddfe80-ab1a-4269-857a-4c857cc61d84)

</br>

### TreeMap 클래스

![image](https://github.com/lielocks/WIL/assets/107406265/aeea737b-a954-4e10-a5c9-a99cbe60c025)

+ 이진 검색 트리의 형태로 키와 값의 쌍으로 이루어진 데이터를 저장 (TreeSet 과 같은 원리)

+ TreeMap 은 SortedMap 인터페이스를 구현하고 있어 **Key 값을 기준으로 정렬** 되는 특징을 가지고 있다.

+ 정렬된 순서로 키 / 값 쌍을 저장하므로 빠른 검색 (특히 범위 검색) 이 가능하다.

+ 단, 키와 값을 저장하는 동시에 정렬을 행하기 때문에 저장시간이 다소 오래 걸린다.

+ 정렬되는 순서는 숫자 -> 알파벳 대문자 -> 알파벳 소문자 -> 한글 순이다.

```java
Map<Integer, String> treeMap = new TreeMap<>();

treeMap.put(1, "Toby");
treeMap.put(2, "Ruth");
treeMap.put(3, "jennifer");
treeMap.put(4, "Mark");
treeMap.put(5, "Dan");
treeMap.put(6, "Gail");

for(Integer key : treeMap.keySet()) {
    System.out.println(key + " => " + treeMap.get(key));
}
/*
1 => Toby
2 => Ruth
3 => jennifer
4 => Mark
5 => Dan
6 => Gail
*/
```

</br>

### HashTable 클래스
![image](https://github.com/lielocks/WIL/assets/107406265/c6cfac29-d907-4af0-912c-1b161fdab41a)

+ 자바 초기 버전에 나온 레거시 클래스

+ Key 를 특정 해시 함수를 통해 hasing 한 후 나온 결과를 배열의 index 를 사용하여 Value 를 찾는 방식으로 동작된다.

+ HashMap 보다는 느리지만 동기화가 기본 지원된다.

+ 키와 값으로 null 이 허용 X

```java
Map<String, Integer> hashtable = new HashMap<>();

hashtable.put("연필", 200);
hashtable.put("볼펜", 3000);
hashtable.put("샤프", 300);
hashtable.put("필통", 15000);

for (String key : hashtable.keySet()) {
    System.out.println(key + " => " + hashtable.get(key));
}
/*
필통 => 15000
볼펜 => 3000
샤프 => 300
연필 => 200
*/
```

</br>

### Properties 클래스

+ `Properties(String, String)` 의 형태로 저장하는 단순화된 `key-value` 컬렉션

+ 주로 어플리케이션의 환경 설정과 관련된 속성 파일인 `.properties` 를 설정하는데 사용된다.

```java
Properties AppProps = new Properties();

// Properties 컬렉션에 String : String 구조의 데이터 추가
AppProps.setProperty("Backcolor", "White");
AppProps.setProperty("Forecolor", "Blue");
AppProps.setProperty("FontSize", "12");

// test.properties 파일에 Properties 자료들을 저장
Path PropertyFile = Paths.get("test.properties");

try (Writer propWriter = Files.newBufferedWriter(PropertyFile)) {
    AppProps.store(propWriter, "Property File Test");

} catch (IOException e) {
    e.printStackTrace();
}
```

![image](https://github.com/lielocks/WIL/assets/107406265/8dee063d-91f3-4e2f-8374-dcb615784e19)


---

## 컬렉션 프레임워크 선택 시점

지금 까지 자바의 컬렉션 프레임워크 자료구조 종류에 대해 간단히 알아보았다. 
워낙 종류도 많고 똑같은 자료구조 이지만 각 쓰임새와 특징에 따라 나누니 정리하기가 까다롭다.

그렇다고 컬렉션 마다 일일히 특징을 외우기 보다는, 아래 그림을 통해 언제 어느때에 어떤 컬렉션을 선택하여 사용하면 좋을지 추적해보자.

![image](https://github.com/lielocks/WIL/assets/107406265/0270fba6-ca12-4c2f-bcee-de64776fd56e)


+ ArrayList
  + 리스트 자료구조를 사용한다면 기본 선택
  + 임의의 요소에 대한 접근성이 뛰어남
  + 순차적인 추가/삭제 제일 빠름
  + 요소의 추가/삭제 불리


+ LinkedList
  + 요소의 추가/삭제 유리
  + 임의의 요소에 대한 접근성이 좋지 않음


+ HashMap / HashSet
  + 해싱을 이용해 임의의 요소에 대한 추가/삭제/검색/접근성 모두 뛰어남  
  + 검색에 최고성능 ( get 메서드의 성능이 **O(1)** )


+ TreeMap / TreeSet
  + **`요소 정렬`** 이 필요할때
  + 검색(특히 범위검색)에 적합
  + 그래도 검색 성능은 HashMap보다 떨어짐


+ LinkedHashMap / LinkedHashSet : HashMap과 HashSet에 **저장 순서 유지 기능** 을 추가

+ Queue : 스택(LIFO) / 큐(FIFO) 자료구조가 필요하면 ArrayDeque 사용
+ Stack, Hashtable : 가급적 사용 X (deprecated)




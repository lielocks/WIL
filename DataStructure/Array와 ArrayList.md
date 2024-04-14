# Array(배열) 자료구조 알아보기 (java based code)

### 배열이란?

배열(Array)은 자료구조 중 하나로, 동일한 데이터 타입의 요소들을 연속된 메모리 공간에 저장하는 방법이다. 
배열은 인덱스(index)를 사용해 각 요소에 접근할 수 있다. 
이러한 특징 때문에 배열은 데이터의 순서를 유지하고, 특정 위치의 요소에 빠르게 접근할 수 있는 장점이 있다.

</br>

### 배열의 장점 및 단점 

**장점**

1. 빠른 접근 : 배열은 index를 사용하여 요소에 빠르게 접근할 수 있다. index를 알고 있다면 원하는 위치의 요소에 상수시간 `(O(1))` 에 접근할 수 있다.

2. 메모리 공간의 효율성 : 배열은 연속된 메모리 공간에 요소를 저장하므로 메모리 공간 효율적 사용 가능!
   또한, 요소들은 순서대로 저장되기 때문에 인접한 요소들에 대한 캐시 지역성이 좋아 성능 향상에 도움을 줄 수 있다.

3. 다차원 배열 : 배열은 다차원으로 선언할 수 있다. 이를 통해 행렬과 같은 다차원 데이터를 표현할 수 있다.


</br>

**단점**

1. 크기 제한 : 배열은 생성할 때 크기를 정하고 이 크기를 변경할 수 없다. 따라서 미리 최대 크기를 예상하여 배열을 생성해야 하며,
   크기를 동적으로 조정할 수 없는 제약이 있다.

2. 삽입과 삭제의 어려움 : 배열은 요소를 삽입하거나 삭제하는 작업에 비용이 크다.
   배열의 중간에 요소를 삽입하거나 삭제할 경우 해당 위치 이후의 요소들을 모두 이동시켜야 한다.
   이로 인해 시간 복잡도가 `O(N)` 이 되어 성능 저하 발생할 수 있다.

</br>

### Java 에서의 배열 선언 및 사용 방법

**배열 선언과 초기화**

+ 배열을 선언하기 위해서는 배열의 타입과 크기를 지정해야 한다.

+ 다음은 int 타입의 배열을 선언하고 크기가 5인 배열을 초기화하는 예시이다.

  ```java
  int[] numbers = new int[5];
  ```


  **배열에 값 할당**

  + 배열에 값을 할당하려면 index를 사용해 특정 위치에 값을 대입한다.
 
  + index는 0부터 배열의 크기보다 1 작은 값까지 유효하다.
 
  + 다음은 배열의 index 0부터 4까지 값을 할당하는 예시이다.
 
  ```java
  numbers[0] = 10;
  numbers[1] = 20;
  numbers[2] = 30;
  numbers[3] = 40;
  numbers[4] = 50;
  ```


  **배열의 값 참조**

  + 배열의 값을 참조하기 위해서도 index를 사용한다.
 
  + 다음은 배열의 index 2에 해당하는 값을 출력하는 예시다.
 
    ```java
    System.out.println(numbers[2]);
    ```


  **배열의 길이**

  + 배열의 길이는 length 속성을 사용하여 알 수 있다.
    
  + 다음은 배열의 길이를 출력하는 예시다.
 
    ```java
    System.out.println(numbers.length); // 5
    ```


### ArrayList란 ? 

앞서 말했듯 배열 (Array)는 정적인 크기를 가지고 있기 때문에 크기를 변경할 수 없다.

만약 크기를 동적으로 변경해야 한다면, Java 에서는 ArrayList 와 같은 동적 배열 사용할 수 있다.

</br>

**ArrayList의 특징과 동작 방식**

1. 동적 크기 조정 : ArrayList는 내부적으로 배열을 사용, 요소를 추가하거나 삭제할 때 필요에 따라 크기를 동적으로 조정할 수 있다.
   크기가 자동으로 조정되므로 크기 제한이 없고, 유연하게 요소를 관리할 수 있다는 장점이 있다.

2. 제네릭 타입 : ArrayList 는 제네릭을 사용하여 요소의 타입을 지정할 수 있다.
   예를 들어, ArrayList<Integer> 는 정수형 요소만 저장하는 List를 생성한다.
   이를 통해 타입 안정성을 제공하며, 잘못된 타입의 요소를 추가하는 것을 방지할 수 있다.

3. 요소 접근 : ArrayList 는 index를 사용해 요소에 접근할 수 있다.
   index는 0부터 시작하며, 해당 index에 접근하여 값을 읽거나 변경할 수 있다.
   index를 사용하여 요소에 빠르게 접근할 수 있다.

4. 요소 추가와 삭제 : ArrayList는 요소를 추가하거나 삭제하는 메서드를 제공한다.
   add() 메서드로 list의 끝에 요소를 추가하거나, 특정 index에 요소를 삽입할 수 있다.
   remove() 메서드를 사용하면 특정 index나 값에 해당하는 요소를 삭제할 수 있다.
   이렇게 ArrayList 는 `내부적으로 요소를 이동시키는 작업`을 처리하기 때문에 사용자는 이에 대한 고려를 하지 않아도 된다.

5. 반복과 순회 : ArrayList는 for 반복문이나 **Iterator** 를 사용하여 요소를 반복하고 순회할 수 있다.
   이를 통해 리스트의 모든 요소에 접근 가능하다.

6. 기타 가능 : ArrayList는 다양한 메서드를 제공하며 요소의 검색, 정렬, 복사, 부분 리스트 생성 등의 기능을 수행할 수 있다.
   예를 들어, contains() 메서드를 사용하여 특정 값이 리스트에 있는지 확인할 수 있다.

</br>

정리해보면 ArrayList는 배열과 비교해 크기 조정과 요소 추가 / 삭제가 효율적인 유연성과 편리성을 제공하는 자료구조라고 볼 수 있다.

하지만, 요소의 추가 / 삭제 작업이 빈번하게 발생하는 경우에는 성능이 저하될 수 있으며, 특정 위치의 요소에 접근할 때는 배열보다 느릴 수 있다.

따라서, **요소의 추가 / 삭제 가 빈번하지 않고 요소의 순차적인 접근이 주로 필요한 경우에 ArrayList를 활용하는 것** 이 적합하다.


**Java에서의 ArrayList 사용 방법 예제**

```java
import java.util.ArrayList;

public class ArrayListExample {
    public static void main(String[] args) {
        // Integer 타입의 요소를 저장하는 ArrayList 생성
        ArrayList<Integer> numbers = new ArrayList<>();

        // 요소 추가
        numbers.add(10);
        numbers.add(20);
        numbers.add(30);

        // 요소 접근
        System.out.println(numbers.get(0)); // 10
        System.out.println(numbers.get(1)); // 20
        System.out.println(numbers.get(2)); // 30

        // 요소 수정
        numbers.set(1, 50);

        // 요소 삭제
        numbers.remove(0);

        // 리스트 크기 출력
        System.out.println(numbers.size()); // 2

        // 리스트 순회
        for (int i = 0; i < numbers.size(); i++) {
            System.out.println(numbers.get(i));
        }
    }
}
```


### Array 와 ArrayList의 공통점

**1. add() and get() method**

Array와 ArrayList는 요소를 추가하거나 가져올 때의 성능은 비슷하다. 두 작업 모두 일정한 시간에 실행된다.

**2. Duplicate elements**

둘 다 중복되는 요소를 저장할 수 있다.

**3. Null Values**

Null 값을 저장할 수 있고 index를 사용하여 값을 참조할 수 있다.

**4. 순서**

순서가 지정되지 않음.

</br>


### Array 와 ArrayList의 차이점

가장 큰 차이점은 `길이를 조정`할 수 있는가? 없는가? 이다.

Java의 Array는 `고정 길이` 이다. 
따라서, 정해진 길이의 배열을 모두 채우면, 새로운 데이터를 추가하고 싶을 경우 새로운 배열을 만들어주어야 한다.

Java의 ArrayList는 `가변 길이` 이다. 하지만 내부적으론 배열로 구성되어 있다. 
ArrayList는 Default로 10개의 공간을 가진 배열로 시작. 
하지만 최적화(지연 초기화)로 인해 막 생성하면 0개의 사이즈로 시작된다. 
다만, 편리함의 대가로 Array보다 살짝 느리니 Array로 충분히 처리 가능하다거나 코딩 테스트나 알고리즘을 풀 때에는 Array를 활용해주는 것이 좋을 것 같다.

### 1. Resizable
+ Array : Array는 static하다(길이 고정). Array 객체를 생성한 후에는 Array의 길이를 마음대로 변경할 수 없다.
  
+ ArrayList : ArrayList는 사이즈가 dynamic 동적이다.
  각각의 ArrayList Object는 ArrayList의 size를 나타내는 `capacity 인스턴스 변수`를 가지고 있다.   ArrayList에 요소들이 더해지면 ArrayList의 capacity 또한 자동적으로 늘어난다.
  만약 설정한 capacity를 넘어서 더 많은 객체가 들어오면, 배열 크기를 **1.5배** 증가시킨다.


```java
  /**
 * Increases the capacity to ensure that it can hold at least the
 * number of elements specified by the minimum capacity argument.
 *
 * @param minCapacity the desired minimum capacity
 */
private void grow(int minCapacity) {
    // overflow-conscious code
    int oldCapacity = elementData.length;
    int newCapacity = oldCapacity + (oldCapacity >> 1); //기존 용량 + 기존 용량 /2 (우측 shift 연산)
    if (newCapacity - minCapacity < 0)
        newCapacity = minCapacity;
    if (newCapacity - MAX_ARRAY_SIZE > 0)
        newCapacity = hugeCapacity(minCapacity);
    // minCapacity is usually close to size, so this is a win:
    elementData = Arrays.copyOf(elementData, newCapacity);
}
```


다시 한번 정리하자면, element를 add하려고 할때, capacity가 배열의 길이와 같아지면 일반적으로 **기존의 용량 + 기존 용량/2** 만큼 크기가 늘어난 배열에 기존의 배열을 copy해준다.


+ **Q. ArrayList는 저장용량을 지정해주지 않지 않나요?** Default 저장용량은 10이다.
![image](https://github.com/lielocks/WIL/assets/107406265/87510107-5a62-4117-adac-2b3eee55a581)


```java
// DEFAULT_CAPACITY=10
// 기본 저장용량 10으로 리스트 생성
List<String> list = new ArrayList<>(); 

// 저장 용량을 100으로 설정해 ArrayList 생성 
List<String> list = new ArrayList<>(100);
```

</br>

### 2. Performance

+ Array와 ArrayList의 성능은 수행되는 작업에 따라 달라진다.

+ resize() operation : `ArrayList의 자동 크기 조정`은 임시 배열을 사용하여 이전 배열의 요소를 새 배열로 복사하기 때문에 *성능이 저하*된다.

+ ArrayList의 자동 resize는 성능을 낮출 것이다
  (old array에서 new array로 요소들을 옮길 때 임시 array를 사용하기 때문에)
  ArrayList는 resizing하는 동안 내부적으로 Array의 지원을 받는다.
  (내부적으로 native method인 System.arrayCopy(...)를 사용하기 때문에)

+ add() or get() operation : Array나 ArrayList로 부터 요소를 얻거나 추가할 때는 거의 비슷한 성능을 보인다.

</br>

### 3. Primitives

+ Array : primitive type, Object

+ ArrayList : ArrayList 는 primitive data types (**`Primitive data types represent single values, and they are not objects. int, float, double, char, boolean etc..`**) 을 가질 수 없다. **오직 Object 만** 가질 수 있다.

+ 사람들은 ArrayList 가 primitive type 을 저장할 수 있다는 오해를 하는데 X !!!

```java
ArrayList<int> arrList //primitive data types X
ArrayList<Integer> arrList //wrapper Class O
```

```java
ArrayList arrayListToObject = new ArrayList();
arrayListToObject.add(23); // try to add 23 (primitive)
```

+ JVM 은 Autoboxing (내부적으로 primitive type 을 타입에 상응하는 Object 로 변환해주는 것 int -> Integer) 을 통해 ArrayList에 Object 만 저장되도록 한다.
  따라서, 위의 코드는 내부적으로 아래와 같이 수행된다.

```java
arrayListToObject.add(new Integer(23));
```

</br>

### 4. Iterating the values

+ Array : for loop / for each loop 를 통해 array를 순회할 수 있다.

+ ArrayList : iterator 를 사용해 ArrayList를 순회할 수 있다.

  ```
  java.lang.Object
	- java.util.AbstractCollection<E>
    	- java.util.AbstractList<E>
        	- java.util.ArrayList<E>
  // Iterator는 Collection 인터페이스의 일부 메서드인 iterator()를 통해서만 얻을 수 있기 때문에 ArrayList만 iterator 사용 가능
  ```

</br>

### 5. Type - Safety

+ Array : Array 는 동종 data structure 이다. 따라서 Array 는 특정 데이터 타입의 primitives 나 특정 클래스의 objects 만을 저장할 수 있다. 만약 명시된 타입이 아닌 다른 데이터 유형을 Array 에 저장할 경우 ArrayStoreException 이 발생한다.

```java
String temp[] = new String[2]; // creates a String array of size 2
```

```java
temp[0]  = new Integer(12); // throws ArrayStoreException
```
</br>

### 6. Length 

+ Array : Array의 길이를 반환하는 length 변수

```java
int arrayObject[] = new int[3];
int arrayLength = arrayObject.length;
```

+ ArrayList : size() 메소드

```java
int len = arrayList.size();    // uses arrayListObject size method
```
</br>

### 7. Adding elements
+ Array : Assign operator(=)를 사용하여 요소를 추가한다.
+ ArrayList : add() 메소드를 사용하여 요소를 추가한다.

</br>

![image](https://github.com/lielocks/WIL/assets/107406265/d3218219-ab38-42a4-9358-d1bc678598ae)


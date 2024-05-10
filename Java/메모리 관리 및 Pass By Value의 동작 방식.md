개발을 하다 보면 함수의 파라미터로 변수를 넘겨주어야 한다. 

각 언어마다 변수를 넘겨주는 방법(Pass By Value, Pass By Reference)이 다른데, 이를 정확히 인지하지 못하면 예상치 못한 버그를 발생시킬 수 있다. 

이번에는 Java 가 어떠한 방식으로 파라미터를 전달하는지 살펴보도록 하자.
 

<br>


## 1. 메모리 할당에 대한 이해

어떠한 변수를 선언한다는 것은 메모리를 할당한다는 것을 의미한다. 

변수를 선언하기 위해 할당되는 메모리로는 크게 Stack 과 Heap 이 있다. 

**`Stack`** 영역에는 **함수의 호출과 함께 지역 변수 또는 매개변수** 등이 할당되며 정렬된 방식으로 메모리가 할당되고 해제된다. 

반면에 **`Heap`** 영역에는 **클래스 변수(또는 인스턴스 변수) 또는 객체(object)** 등이 할당되며, 우연하고 무질서하게 메모리가 할당된다. 

(그래서 JVM 은 무질서하게 관리되는 **Heap 영역을 위주로** Garbage Collector 를 통해 메모리의 해제를 관리한다.)

이러한 기초 지식을 바탕으로 *지역에 존재하는 원시 변수* 와 *객체의 메모리 할당* 을 먼저 살펴보도록 하자.

(`인스턴스 변수로 존재하는 원시변수` 는 **Heap** 영역에서 관리됩니다. 아래의 설명에서는 지역에 존재하는 원시 변수인 Local Primitive Value를 기준으로 설명하고 있습니다.)


<br>


> ***Stack*** 에 할당되는 변수들의 종류

```java
public class StackVariables {
    public static void main(String[] args) {
        // 지역 변수: Stack에 할당됨
        int a = 10;
        double b = 20.5;
        boolean c = true;
        char d = 'A';
        String e = "Hello";
        
        // 메서드 호출
        method();
    }
    
    public static void method() {
        // 메서드 내의 지역 변수: Stack에 할당됨
        int x = 100;
        String y = "World";
    }
}
```

> ***Heap*** 에 할당되는 변수들의 종류 

```java
public class HeapVariables {
    // 인스턴스 변수: Heap에 할당됨
    int[] array = new int[10];
    String name = "John";
    MyClass obj = new MyClass();
    
    public static void main(String[] args) {
        // 객체 생성: Heap에 할당됨
        HeapVariables hv = new HeapVariables();
        
        // 객체의 인스턴스 변수 접근
        hv.array[0] = 5;
        hv.name = "Alice";
    }
}

class MyClass {
    // 인스턴스 변수: Heap에 할당됨
    int value;
    double weight;
}
```


<br>


### [원시 변수(Primitive Value)의 메모리 할당 ]

Java에서 변수는 객체가 아닌 실제 값들인 int, double, float boolean 등과 같은 원시 값(Primitive Value)들이 존재한다. 

예를 들어 다음과 같이 함수 내에서 지역 변수로 원시 변수들을 선언하였다고 가정하자.

```java
public void test() {
    // Primitive Value
    int x = 3;
    float y = 10.012f;
    boolean isTrue = true;
}
```
 
그렇다면 메모리에서는 해당 내용이 다음과 같이 스택 영역에 할당된다. 

**Stack 영역에 실제 값들이 저장** 되는 것이다.

![image](https://github.com/lielocks/WIL/assets/107406265/f355e0e3-3f99-4378-864f-848f33c105d2)

<br>


### [ 객체(Object)의 메모리 할당 ]

원시변수는 스택 영역에 실제 값들이 할당되었다. 

하지만 객체는 원시변수와 다르게 값이 할당된다. 예를 들어 다음과 같은 String 객체를 추가로 생성하였다고 하자.

```java
public void test() {
    // Primitive Value
    int x = 3;
    float y = 101.012f;
    boolean isTrue = true;
    
    // Object
    String name = "MangKyu";
}
```

<br>


그렇다면 메모리에 값은 다음과 같이 할당된다. 

먼저 **객체** 의 경우 **Heap 영역에 실제 값** 이 할당된다. 

그리고 이에 접근하기 위해 **Stack 영역에는 Heap 영역에 존재하는 값의 `실제 주소`** 가 저장되고, C/C++에서는 이를 포인터(pointer)라고 부른다. 

> 즉, **`Stack 영역`** 에는 **실제 값이 존재하는 Heap 영역의 주소** 가 저장된다는 것이다.

![image](https://github.com/lielocks/WIL/assets/107406265/a51afb7f-6c3a-4f92-8c71-c5e882caabc1)


<br>


여기에 더해 다음과 같이 크기가 3 인 String 배열을 추가적으로 선언하였다고 하자.


```java
public void test() {
    // Primitive Value
    int x = 3;
    float y = 101.012f;
    boolean isTrue = true;
    
    // Object
    String name = "MangKyu";
    
    String[] names = new String[3];
    names[0] = "I";
    names[1] = "am";
    names[2] = new String("MangKyu");
    
}
```

여기에 더해 다음과 같이 크기가 3인 String 배열을 추가적으로 *선언* 하였다고 하자. 

**`배열도 객체`** 이기 때문에 다음과 같이 메모리가 할당되게 된다.

![image](https://github.com/lielocks/WIL/assets/107406265/9b930c95-96e4-48fc-ad79-ffa2cb4b8d1d)


여기서 주목해야 할 것은 크게 세가지가 있다. 

먼저 앞서 설명한대로 **`Heap 영역`** 은 Stack 영역과 다르게 **무질서하게** 메모리 공간을 활용한다는 것이다. 

또한 두 번째로 **`객체의 메모리 할당`** 인 경우 **Stack 영역에 실제 값을 참조하기 위한 Reference(참조값)** 이 저장되고 이를 통해 참조하여 실제 값에 접근한다는 것이다. 

세번째로는 배열의 경우 또 **그 배열의 인덱스마다 참조값** 이 할당되며 이를 통해 접근한다는 것이다.
 

<br>


## 문제 파헤쳐보며 Pass By Value 이해하기

### [ 문제 ]

```java
class Dog {

    private String name;

    public Dog (String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

}

public class Main {

    public static void main(String[] args) {
        int x = 10;
        int[] y = {2, 3, 4};
        Dog dog1 = new Dog("강아지1");
        Dog dog2 = new Dog("강아지2");

        // 함수 실행
        foo(x, y, dog1, dog2);

        // 어떤 결과가 출력될 것 같은지 혹은 값이 어떻게 변할지 예상해보세요!
        System.out.println("x = " + x);
        System.out.println("y = " + y[0]);
        System.out.println("dog1.name = " + dog1.getName());
        System.out.println("dog2.name = " + dog2.getName());
    }

    public static void foo(int x, int[] y, Dog dog1, Dog dog2) {
        x++;
        y[0]++;
        dog1 = new Dog("이름 바뀐 강아지1");
        dog2.setName("이름 바뀐 강아지2");
    }

}
```

<br>


### [변수의 할당]

우선 위의 문제에서는 4가지 변수를 할당해주고 있고, 이를 그림으로 표현하면 다음과 같다.

![image](https://github.com/lielocks/WIL/assets/107406265/402c9e82-321e-4573-9827-651f8adc28e9)

여기까지 이해를 하였으면 이제 foo 함수의 호출을 진행하여보자.


<br>


### [foo 호출 및 실행 - int x ]

foo() 함수는 먼저 int x를 첫 번째 파라미터로 받고 있고, 해당 값을 1 증가시키고 있다. 

이 경우 `Pass By Value` 는 다음과 같이 동작하게 된다.

먼저 *Stack 영역에 파라미터가 할당된다.* 

즉, **`새로운 x` 가 Stack 에 10 의 값으로 생성** 되는 것이다. 

그리고 foo 는 x 의 값을 증가시키고 있는데, 기존의 x가 아닌 **새로운 x 값을 증가** 시키고 있다. 

그렇기 때문에 **`기존의 x` 는 10 으로 값이 유지되고,** **`새로운 x`** 가 10 이 할당된 후에 **11 로 증가되는 것이다.** 

![image](https://github.com/lielocks/WIL/assets/107406265/2ca66297-808d-4b0c-9432-206473d14c49)

> 그리고 **foo 가 종료** 되면 **`새로운 x` 는 Stack 영역에서 해제** 된다. 

그렇기 때문에 foo를 호출한 후에 x를 출력하면 **기존의 x가 출력되는 것이다.**


<br>


### [ foo 호출 및 실행 - int[] y ]

foo() 함수는 두 번째 파라미터로 *int 형 배열 y* 를 받고 있다. 

Pass By Value 로 동작하는 Java 는 역시 **`Stack` 에 새로운 파라미터인 int[] y 를 할당** 할 것이다. 

이를 그림으로 표현하면 다음과 같다.

![image](https://github.com/lielocks/WIL/assets/107406265/20cc6db8-f54e-4778-b71d-6d74a9dac514)


<br>


그리고 y 의 0 번째 인덱스에 존재하는 값을 1 증가시키고 있는데, 앞선 x 와는 상황이 다르다. 

그러한 이유는 `새로운 y가 할당되긴 하였지만` **배열의 주소** 를 가리키고 있기 때문이다. 

해당 y 가 `기존의 y` 이든 `새로운 y` 이든 **실제 배열의 주소로 접근하여 값을 1 증가** 시키고 있기 때문에 ***foo가 종료된 후에도 배열의 값은 변화*** 하게 된다.

![image](https://github.com/lielocks/WIL/assets/107406265/da9df230-dc80-490c-a01d-0ed93569b816)


<br>


### [ foo 호출 및 실행 - Dog dog1 ]

foo() 함수는 세 번째 파라미터로 Dog 클래스의 인스턴스인 dog1 을 받고 있다. 

Pass By Value 로 동작하는 Java 는 역시 **`Stack` 에 새로운 파라미터인 dog1** 을 생성하게 되고, y 와 마찬가지로 **dog1 은 객체이기 때문에 dog1 의 `주소` 를 값** 으로 갖게 된다. 

![image](https://github.com/lielocks/WIL/assets/107406265/5afebbdc-d79a-4931-921c-34faf3505abd)


<br>


그리고 foo 함수에서 진행하는 연산을 살펴보자. 

foo 함수는 dog1 을 새로 생성하고 있다. 

그렇기 때문에 **`Heap` 영역에는 새로운 dog1** 이 생성될 것이고, **`Stack` 에서 가리키는 주소값** 은 **새로운 dog1** 을 가리키게 될 것이다.

![image](https://github.com/lielocks/WIL/assets/107406265/02eacb6b-17b0-460e-a640-12765cb06517)

마찬가지로 foo 함수가 종료되면 *새로운 dog1 은 소멸되고* **기존의 dog1 에는 변화가 없다.**


<br>


### [ foo 호출 및 실행 - Dog dog2 ]

마지막으로 foo() 함수는 네 번째 파라미터로 Dog 클래스의 인스턴스인 dog2 를 받고 있다. 

dog1 때와 마찬가지로 **`Stack`** 영역에는 새로운 dog2 가 할당되고, **실제 dog2 의 주소값** 을 가리키고 있다.

![image](https://github.com/lielocks/WIL/assets/107406265/df1ebfd7-b43c-44cb-85e5-351f0944a715)


<br>


하지만 dog2가 수행하는 연산은 dog1과 다르다. 

dog2 는 새로운 값을 할당하는 것이 아니라, **주소값을 통해 Heap 영역에 존재하는 객체에 접근하여 `set` 을 통해 값을 변화** 시켜주고 있다. 

![image](https://github.com/lielocks/WIL/assets/107406265/cabc10b9-ebf7-46ea-9362-8a90ea677d8b)

foo() 함수가 종료되면 어떻게 될 것인가? 

*Stack 영역에 할당된 새로운 dog2는 소멸될 것이다.*

하지만 Heap 영역에 존재하는 값은 변하였기 때문에 foo 함수가 종료된 후에 dog2 의 name 을 출력해보면 "이름 바뀐 강아지2"가 출력되는 것이다.


<br>


### [ foo 종료 ]

foo 함수가 종료되면 foo 함수에서 사용했던 파라미터들은 모두 사라지고 다음과 같은 값들만 남게 된다.

![image](https://github.com/lielocks/WIL/assets/107406265/f1240379-64de-47c5-81a2-362aba2448f3)

이러한 결과를 바탕으로 출력 결과를 예상하면 다음과 같다.

```
x = 10
y = 3
dog1.name = 강아지1
dog2.name = 이름 바뀐 강아지2
```

이러한 동작 방식과 결과를 갖게 되는 이유는 Java가 Pass By Value(또는 Call By Value)로 동작하기 때문이다. 

개발을 하다 보면 함수의 파라미터로 변수를 넘겨주어야 한다. 

각 언어마다 변수를 넘겨주는 방법(Pass By Value, Pass By Reference)이 다른데, 이를 정확히 인지하지 못하면 예상치 못한 버그를 발생시킬 수 있다. 

이번에는 두가지 방법의 차이점을 알아보도록 하자.


<br>


## 2. Pass By Value(Call By Value)에 대한 이해

### [ Pass By Value(값에 의한 전달)의 의미 ]

**Pass By Value(값에 의한 전달)** 는 **복사된 데이터를 전달하여 구성함으로써, 값을 수정하여도 원본의 데이터에는 영향을 주지 않도록** 하는 방식이다.

예를 들어 다음과 같은 어떤 int 값을 파라미터로 넘기는 process 함수가 있다라고 가정하자.


```c
#include <iostream>

using namespace std;

void process(int value) {
    cout << "Value passed into function: " << value << endl;
    value = 10;
    cout << "Value before leaving function: " << value << endl;
}

int main() {
    int someValue = 7;
    cout << "Value before function call: " << someValue << endl;
    process(someValue);
    cout << "Value after function call: " << someValue << endl;
    return 0;
}
```

위의 process 함수는 매개변수로 전달받은 int형 값인 value 를 10 으로 변경하고 있다. 

위의 프로그램을 실행한 결과를 예측해보고, 실제 출력 결과와 비교해보자.

```
Value before function call: 7                                                                                                                                                    
Value passed into function: 7                                                                                                                                                    
Value before leaving function: 10                                                                                                                                                
Value after function call: 7
```


process 내에서 해당 값을 수정하여도, `해당 해당 함수가 종료` 되고 나면 **원본의 값은 기존의 상태** 를 유지하고 있다. 

그러한 이유는 해당 과정이 Pass By Value 방식으로 동작하였기 때문이며, 이를 함수의 Call Stack 을 통해 자세히 살펴보도록 하자.


<br>


### [ Pass By Value(값에 의한 전달)의 동작 방식 ]

우리가 어떤 함수를 호출한다고 하면 Stack 메모리에 *먼저 함수의 `Return Address` 가 쌓이게 되고 그 위에 `매개변수`* 등의 값이 쌓이게 된다. 

위에서 보여준 코드를 기준으로 메모리 할당을 그림으로 표현하면 다음과 같다.

![image](https://github.com/lielocks/WIL/assets/107406265/1cc99b69-c267-400c-9523-3a8960257d2f)

먼저 우리는 main 함수를 호출하였기 때문에 main 함수의 내용이 Stack에 먼저 존재할 것이고, 그 중에서 지역 변수로 선언한 someValue 가 존재할 것이다. 

이후에 process 라는 함수를 호출하는 상황이라고 한다면, 먼저 Return Address 가 Stack 에 쌓이고, 그 다음으로 process 의 파라미터인 int형 변수 value 역시 쌓이게 된다.


<br>


그런데 여기서 우리가 주목해야 할 부분은 메모리에 할당된 main 함수의 someValue 는 그대로 유지된 상태로, **7 이라는 값만을 참고하고 복사하여 새롭게 메모리를 할당** 한다는 점이다. 

실제로 main 함수의 someValue 의 주소값은 `0x07040` 이지만, process 함수의 파라미터인 value 의 주소값은 `0x07000` 이라는 점에서 두 변수는 값만 같을뿐 다른 존재임을 확인할 수 있다.

그렇다면 process 함수로 전달받은 파라미터 value에 어떤 값이 더해지고 빼지고 곱해진 상태로 process 함수가 종료된다면 어떻게 되겠는가? 

process 를 위해 할당된 Call Stack 이 pop될 것이고 해당 메모리는 모두 소멸될 것이다.

![image](https://github.com/lielocks/WIL/assets/107406265/9a720897-abbd-412d-966c-7795f74014da)

그렇기 때문에 *process가 종료된 이후* main 함수에서 someValue 를 다시 출력하여 보아도 7 이라는 **기존의 값** 을 유지하는 것이다. 

그리고 이렇게 어떤 함수를 호출할 때 **파라미터로 값을 복사하여 전달하는 방식** 을 **`Pass By Value`** 라고 한다. 
 

<br>



## 3. Pass By Reference(Call By Reference)에 대한 이해

### [ Pass By Reference(참조에 의한 전달)의 의미 ]

몇몇 언어들에서는 pass by reference 와 pass by pointer 를 다른 기술로 정의하기도 한다. 

하지만 이론적으로 **pass by reference** 가 **어떤 alias 를 구성하여 실제 값에 접근하는 것이라는 관점에서,** `pass by pointer` 는 **alias 로 주소값을 넘겨주었을 뿐** 이기 때문에 동일한 기술이라고 볼 수 있다.

Pass By Reference(참조에 의한 전달) 는 주소 값을 전달하여 실제 값에 대한 Alias를 구성함으로써, 값을 수정하면 원본의 데이터가 수정되도록 하는 방식이다. 

C++에서는 참조값을 전달하기 위해 &를 사용하는데, 위에서 설명했던 process 함수를 참조값을 전달하도록 수정하면 다음과 같다.


```c++
#include <iostream>

using namespace std;

// value 앞에 &가 추가됨
void process(int& value) {
    cout << "Value passed into function: " << value << endl;
    value = 10;
    cout << "Value before leaving function: " << value << endl;
}

int main() {
    int someValue = 7;
    cout << "Value before function call: " << someValue << endl;
    process(someValue);
    cout << "Value after function call: " << someValue << endl;
    return 0;
}
```

위의 process 함수 역시 매개변수로 전달받은 int 형 값인 value 를 10으로 변경하고 있다. 

위의 프로그램을 실행한 결과를 예측해보고, 실제 출력 결과와 비교해보자.

```
Value before function call: 7                                                                                                                                                      
Value passed into function: 7                                                                                                                                                      
Value before leaving function: 10                                                                                                                                                  
Value after function call: 10 
```

이번에는 실제 값에 대한 Alias 를 넘겼기 때문에 process 함수에서 값을 변경하면 실제 main 함수의 someValue 에도 영향을 주게 된다. 

이러한 Pass By Reference의 동작 방식 역시 함수의 Call Stack을 통해 자세히 살펴보도록 하자.


<br>


### [ Pass By Reference(참조에 의한 전달)의 동작 방식 ]

앞에서 살펴봤던 것과 마찬가지로 Stack 메모리에 먼저 process 함수의 Return Address가 쌓이게 되고 그 위에 매개변수 등의 값이 쌓이게 된다. 

하지만 *Pass By Value 에서는 `실제 값` 이 쌓였던 것과 다르게* **Pass By Reference** 에서는 **`실제 값의 주소`** 가 쌓이게 된다. 

이를 그림으로 표현하면 다음과 같다.

![image](https://github.com/lielocks/WIL/assets/107406265/73d146a6-a658-4e9a-802d-7163b3d2c2d4)

`process 함수에서 파라미터로 전달받은 value` 는 **someValue 가 저장된 값을 참조하는 Alias** 이며 value 를 10으로 변경하는 것은 **value 가 가리키는 메모리(실제 someValue가 저장되어 있는 메모리)의 값을 7에서 10으로 변경** 하는 것이다. 

그렇기 때문에 process 함수 종료 후에 someValue 를 출력하여 확인해보면 10으로 변경이 된 것을 확인할 수 있다.


<br>


## 4. Java에서 Pass By Value의 동작 방식

### [ Java에서 Pass By Value의 동작 방식 ]

앞의 포스팅에서 Java는 Pass By Value로 동작한다고 설명하였다. 

실제로 Java Language Specification의 (Section 4.3) 에서는 *원시 값이든 객체든 상관없이* **모든 데이터를 Pass By Value** 로 전달한다고 나와 있다.

이러한 규칙은 표면적으로 상당히 쉬워보인다. 

하지만 앞의 포스팅에서 살펴보았듯 **원시 값은 `Stack 메모리` 에 실제 값** 이 저장되고, **객체는 `실제 메모리를 참고하기 위한 값` 이 저장** 된다는 것을 확인하였다. 

그렇기 때문에 Java 에서는 객체에 한해 확장된 규칙이 적용된다. 

그것은 *객체와 관련되어 복사 후 전달되는 값* 은 **실제 메모리를 가리키는 Reference(참조값) 인 `포인터`** 라는 것이다.

Java 에서 *객체를 생성* 할 때 `Dog dog = new Dog()` 과 같은 표현을 사용한다. 

여기서 dog 은 실제로 생성된 Dog 클래스의 객체를 저장하고 있는 것이 아니고, Dog 클래스의 객체가 저장된 **주소값(포인터 값)** 을 가지고 있는 것이다. 

그리고 `Java 에서 객체를 전달한다` 고 하면 이러한 `dog 변수가 복제되어 전달된다.` 

Object Section (Section 4.3.1) 에 따르면 Java 언어에서는 이를 **Object Reference** 라고 부르며, ***객체가 전달될 때마다 복제된다.***

Object Reference를 통해서는 다음과 같은 연산들이 가능하다.

+ Field 값으로의 접근

+ Method Invocation

+ The Cast Operator

+ String의 + 연산자

+ instanceof 연산자

+ == 또는 != 또는 ? :


<br>


그렇기 때문에 우리는 Java 에서 *어떤 객체가 파라미터* 로 전달되었을 때, **필드값에 접근하여 해당 값을 수정** 하는 것은 가능하지만 ***그 객체 자체는 변경 불가능*** 한 것이다. 

이를 그림으로 표현하면 다음과 같다. 

![image](https://github.com/lielocks/WIL/assets/107406265/4e1b20ec-ed24-4997-8875-0b412de6c3af)

기존의 예시와는 다르게 이번에는 main 함수에서 Foo 클래스에 대한 객체를 생성하고, 이를 process 함수의 파라미터로 넘기고 있다. 

앞서 설명한대로 Java 에서는 `Pass By Value` 에 따라 **Foo 객체가 존재하는 주소(0x07070)를 갖는 someFoo 변수를 복사하여 전달** 함으로써, process 의 함수가 주소값을 통해 필드값에 접근하는 것을 도와주고 있다. 

하지만 process 가 종료되면 copied pointer(0x07000) 는 소멸되고, *foo 객체 자체에 변경사항이 있었다면* **해당 부분 역시 반영되지 않는다.**


<br>



분명 누군가는 Java의 객체 전달 방식이 Pass By Reference 가 아닌가 혼란이 올 수 있다. 

하지만 앞서 정의되었던 Pass By Reference 의 정의를 살펴보면 이를 해결할 수 있다. 

`Pass By Reference(참조에 의한 전달)` 는 **주소 값을 전달하여 실제 값에 대한 Alias 를 구성함** 으로써, **값을 수정하면 원본의 데이터가 수정** 되도록 하는 방식이라고 정의하였다. 

Java 에서 객체를 전달하는 방식에는 분명 *주소값* 이 전달되고 있지만, 이는 **`그저 someFoo 에 대한 복사본`** 일 뿐이다. 

물론 process 의 파라미터로 전달받은 foo 역시도 *실제 주소값* 을 참조하고 있기 때문에 foo 의 setValue 를 통해 실제 객체의 필드값을 수정하면 변하게 된다. 

하지만 이는 **그저 `객체의 주소값으로 객체의 필드 값에 접근` 하여 값을 변경하는 것일 뿐,** ***실제 객체 자체에 변화를 주는 것이 아니다.***

이를 이해하기 위해 process 에 객체를 변경하는 코드를 추가하여 살펴보도록 하자.

```java
class Foo {

    private int value;

    public Foo(int value) {
        this.value = value;
    }

    public int getValue() {
        return value;
    }

    public void setValue(int value) {
        this.value = value;
    }

}

public class Main {

    public static void main(String[] args) {
        Foo someFoo = new Foo(7);
        process(someFoo);
        System.out.println(someFoo.getValue());
    }

    public static void process(Foo foo) {
        // 주소 값을 통해 필드 값을 변경
        foo.setValue(10);

        // 객체 자체를 변경하는 것은 영향 X
        foo = new Foo(15);
    }

}
```

위의 process 함수에서는 파라미터로 전달받은 foo 객체를 15 라는 값을 지닌 새로운 객체로 변경하고 있다. 

process 함수가 종료되면 어떻게 되겠는가? 당연히 **10** 이라는 값을 유지하게 된다. 

그러한 이유는 foo 는 Pass By Reference 처럼 실제 객체에 대한 Alias 가 아니라, 그저 *someValue 가 복사되어 전달된 Reference* 이기 때문이며, Java 가 Pass By Value 방식으로 동작하기 때문이다. 

Java가 Pass By Reference 방식으로 동작하였다면 process 함수가 종료된 후에도 15 라는 값으로 유지되었을 것이다. 


<br>


## 4. 요약

### [ Pass By Value와 Pass By Reference 차이 ]

![image](https://github.com/lielocks/WIL/assets/107406265/30bbd1dc-0b94-4743-83be-1d5e96ff4ccf)



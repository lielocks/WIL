## 1. Static 정리

Java 에서 Static 키워드를 사용한다는 것은 메모리에 한번 할당되어 프로그램이 종료될 때 해제되는 것을 의미합니다. 

이를 정확히 이해하기 위해서는 메모리 영역에 대한 이해가 필요합니다.


<br>


### [ Static의 메모리 ]

![image](https://github.com/lielocks/WIL/assets/107406265/185078c5-630b-45a2-8292-319e825321bb)


<br>


일반적으로 우리가 만든 **Class 는 `Static 영역` 에 생성되고,** **new 연산을 통해 생성한 객체는 `Heap 영역`** 에 생성됩니다. 

**객체의 생성시에 할당된 Heap 영역의 메모리** 는 **`Garbage Collector`** 를 통해 수시로 관리를 받습니다. 

하지만 Static 키워드를 통해 **`Static 영역에 할당된 메모리`** 는 **모든 객체가 공유하는 메모리라는 장점** 을 지니지만, 

***Garbage Collector 의 관리 영역 밖에 존재*** 하므로 Static 을 자주 사용하면 프로그램의 종료시까지 *메모리가 할당된 채로 존재* 하므로 자주 사용하게 되면 시스템의 퍼포먼스에 **악영향** 을 주게 됩니다.


<br>


![image](https://github.com/lielocks/WIL/assets/107406265/375998e7-eac2-473f-81e9-756e8c9175bb)

<br>


> **Static 변수** 는 메모리 구조상에서 **`Data 영역`** 에 저장되며 이는 **메모리상에 한번 할당되면 프로그램이 종료될때 해제된다** 는 것을 의미한다.
>
> Class 가 여러번 생성되어도 클래스 내부 **`Static 변수` 는 딱 한번만 생성** 된다.



<br>



### [ Static 변수 특징 ]

+ Static 변수는 **class 변수** 이다.

+ *객체를 생성하지 않고도* **Static 자원에 접근이 가능하다.**

Static 변수와 static 메서드는 Static 메모리 영역에 존재하므로 객체가 생성되기 이전에 이미 할당되어 있습니다.

그렇기 때문에 객체의 생성 없이 바로 접근(사용)할 수 있습니다.


```java
public class MyCalculator {
    public static String appName = "MyCalculator";
	    
	public static int add(int x, int y) {
	    return x + y;
	}

	public int min(int x, int y) {
	    return x - y;
	}
}

MyCalculator.add(1, 2);   //  static 메소드 이므로 객체 생성 없이 사용 가능
MyCalculator.min(1, 2);   //  static 메소드가 아니므로 객체 생성후에 사용가능


MyCalculator cal = new MyCalculator();
cal.add(1, 2);   // o 가능은 하지만 권장하지 않는 방법
cal.min(1, 2);   // o
```


<br>



## 2. Static 변수(정적 변수)

![image](https://github.com/lielocks/WIL/assets/107406265/62a71345-afaf-4c1d-b0bc-c1d5ddec2fac)

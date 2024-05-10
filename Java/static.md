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



### [ Static 변수 특징 ]

+ Static 변수는 **class 변수** 이다.

+ *객체를 생성하지 않고도* **Static 자원에 접근이 가능하다.**


<br>


**Static 변수와 static 메서드는 Static 메모리 영역에 존재하므로 `객체가 생성되기 이전에 이미 할당` 되어 있습니다.**

**그렇기 때문에 `객체의 생성 없이 바로 접근(사용)` 할 수 있습니다.**


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

Java 에서 Static 변수는 *메모리에 한번 할당되어 프로그램이 종료될 때 해제* 되는 변수로, **메모리에 한번 할당되므로 여러 객체가 해당 메모리를 공유** 하게 됩니다.

이해를 높이기 위해 코드를 추가하겠습니다.

예를 들어, 세상 모든 사람의 이름이 'MangKyu'인 세상에 살고있다고 가정을 하겠습니다. 이럴때면 우리는 아래와 같이 객체를 만들 수 있습니다

```java
public class Person {
    private String name = "MangKyu";
	    
	public void printName() {
	    System.out.println(this.name);
	}
}
```

하지만 위와 같은 클래스를 통해 100명의 Person 객체를 생성하면, "MangKyu"라는 같은 값을 갖는 메모리가 100개나 중복해서 생성되게 됩니다. 

이러한 경우에 **static** 을 사용하여 **여러 객체가 하나의 메모리를 참조** 하도록 하면 메모리 효율이 더욱 높아질 것입니다. 

또한 "MangKyu" 라는 이름은 **`결코 변하지 않는 값이므로 final`** 키워드를 붙여주며, 일반적으로 Static 은 **`상수의 값을 갖는 경우가 많으므로 public`** 으로 선언을 하여 사용합니다. 

이러한 이유로, 일반적으로 static 변수는 public 및 final과 함께 사용되어 `public static final` 로 활용 됩니다. 

```java
public class Person {
    public static final String name = "MangKyu";
         
    public static void printName() {
        System.out.println(this.name);
    }
}
```


<br>



## 3. Static 메소드(정적 메소드)

```java
public class MyClass {
    // 정적(static) 변수
    static int staticVariable = 10;
    // 인스턴스 변수
    int instanceVariable = 20;

    // 정적(static) 메서드
    public static void staticMethod() {
        // 정적 메서드에서는 정적 변수(staticVariable)에 접근할 수 있음
        System.out.println("Static variable inside static method: " + staticVariable);
        // 정적 메서드에서는 인스턴스 변수(instanceVariable)에 접근할 수 없음
        // System.out.println("Instance variable inside static method: " + instanceVariable); // 에러 발생
    }

    // 일반(non-static) 메서드
    public void instanceMethod() {
        // 인스턴스 메서드에서는 정적 변수(staticVariable)에 접근할 수 있음
        System.out.println("Static variable inside instance method: " + staticVariable);
        // 인스턴스 메서드에서는 인스턴스 변수(instanceVariable)에 접근할 수 있음
        System.out.println("Instance variable inside instance method: " + instanceVariable);
    }
}
```

```java
public class Main {
    public static void main(String[] args) {
        // 객체 생성 없이 정적 메서드 호출 가능
        MyClass.staticMethod();

        // 객체 생성
        MyClass obj = new MyClass();

        // 인스턴스 메서드 호출을 위해 객체 생성 후 호출
        obj.instanceMethod();
    }
}
```

<br>



Static Method 는 **객체의 생성 없이 호출이 가능** 하며, 객체에서는 호출이 가능은 하지만 지양하고 있습니다. 

일반적으로는 유틸리티 관련 함수들은 여러 번 사용되므로 static 메소드로 구현을 하는 것이 적합한데, static 메소드를 사용하는 대표적인 *Util Class 로는 java.util.Math* 가 있습니다. 

우리는 해당 클래스를 아래와 같이 사용합니다.


```java
public class Test {
    private String name1 = "MangKyu";
    private static String name2 = "MangKyu";
 
    public static void printMax(int x, int y) {
        System.out.println(Math.max(x, y));
    }
         
    public static void printName(){
       // System.out.println(name1); 불가능한 호출
       System.out.println(name2);
    
}
```


우리는 두 수의 최대값을 구하는 경우에 Math 클래스를 사용하는데, **`static 메소드로 선언된 max 함수`** 를 **초기화 없이 사용** 합니다. 

하지만 static 메소드에서는 **static 이 선언되지 않은 변수에 접근이 불가능** 한데, 메모리 할당과 연관지어 생각해보면 당연합니다. 

우리가 `Test.printName()` 을 사용하려고 하는데, **`name1` 은 new 연산을 통해 객체가 생성된 후에 메모리가 할당** 됩니다. 

하지만 **static 메소드는 객체의 생성 없이 접근하는 함수** 이므로, 할당되지 않은 메모리 영역에 접근을 하므로 문제가 발생하게 됩니다. 

그러므로 static 메소드에서 접근하기 위한 변수는 반드시 static 변수로 선언되어야 합니다.


> ***헷갈려서 요약해봄***
>
> 정적(static) 메소드는 **클래스 레벨** 에서 사용되며, **특정 객체의 인스턴스에 종속되지 않습니다.**
>
> 따라서 **`static 메서드`** 는 **객체의 instance 가 생성되지 않은 상태에서도 호출될 수 있습니다.**
>
> 이러한 특성으로 인해 **`static 메소드`** 는 **특정 객체의 상태에 의존하지 않고, 클래스의 전반적인 동작** 을 수행할 때 사용됩니다.
>
> 클래스의 instance 를 생성하지 않고도 직접 호출할 수 있기 때문에, static 메소드는 ***클래스와 관련된 utility 기능이나 공통된 동작*** 을 구현하는 데 유용합니다.



<br>



## 4. 실제 Static 변수와 Static 메소드의 활용

### 1. Static 변수

일반적으로 상수들만 모아서 사용하며 상수의 변수명은 대문자와 _를 조합하여 이름짓는다. 

또한 상속을 방지하기 위해 final class로 선언을 한다.

```java
public final class AppConstants {
 
    public static final String APP_NAME = "MyApp";
    public static final String PREF_NAME = "MyPref";        
 
}
```

### 2. Static 메소드

마찬가지로 상속을 방지하기 위해 final class로 선언을 하고, 유틸 관련된 함수들을 모아둔다.

```java
import java.text.SimpleDateFormat;
import java.util.Date;
import android.util.Patterns;
 
public final class CommonUtils {
 
    public static String getCurrentDate() {
        Date date = new Date();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyMMdd");
        return dateFormat.format(date);
    }
     
    public static boolean isEmailValid(String email) {
        return Patterns.EMAIL_ADDRESS.matcher(email).matches();
    }
     
}
```


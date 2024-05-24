자바에서는 String 문자열 생성 방식은 두가지가 있다.

**1. String literal**

**2. new String()**

두개는 어떤 차이가 있을까?

둘의 차이는 저장되는 **저장공간(메모리) 의 차이** 이다.

**new 연산자** 를 사용하여 String 을 생성하게 되면 객체로 생성이 되어 **`Heap`** 메모리 영역에 저장이 되고,
**리터럴 (literal)** 을 사용하여 String 을 생성할 경우 **`String constant pool`** 이라는 영역에 생성이 된다.

literal 을 사용하여 생성할 때 constant pool 에 같은 값이 존재한다면 생성되는 객체는 이미 존재하고 있는 값을 참조하게 된다.

```java
String str1 = new String("Hello"); 
String str2 = "Hello"; 
String str3 = "Hello";
```
![image](https://github.com/lielocks/WIL/assets/107406265/97756fea-873e-44ac-8cda-8be84aaf2678)

<br>

literal 로 생성한 **str2와 str3은 동일한 객체** 를 바라보지만,

new String() 으로 생성한 **str1은 다른 메모리 주소의 객체** 를 바라본다.

+ **String literal** 로 생성한 객체는 "String Contant poll" 에 들어간다.

+ **String literal** 로 생성한 객체가 이미 "String Constant pool" 영역에 존재한다면, 해당 객체는 이미 생성되어 있는 String Constant Pool 의 reference 를 참조한다.

+ **new 연산자로 생성한 String 객체** 는 같은 값이 String Pool 에 존재하더라도, Heap 영역에 별도로 객체를 생성한다.

<br>

### equals 와 ==

**equals** 는 **값이 동일한지** 를 비교하고, **==는 메모리상 동일한 객체** 인지를 비교한다.

```java
String str1 = new String("Hello"); 
String str2 = "Hello"; 
String str3 = "Hello";

System.out.println(str1.equals(str2)); // (1) true 
System.out.println(str1 == str2); // (2) false 
System.out.println(str2 == str3); // (3) true
```

1. 값이 동일한지를 비교하여 `new 연산자를 사용하여 생성한 "Hello"` 와 `literal을 사용하여 생성한 "Hello"` 와 동일

2. **메모리상 동일한 객체** 인지를 비교하기 때문에 String Constant Pool 에 저장되어 있는 str2 와 heap 메모리에 별도의 객체로 저장되어 있는 str1 은 동일하지 않다고 나옴.

3. str2, str3 모두 literal 을 사용하여 생성한 동일한 문자열이기 때문에 동일한 String Constant Pool 의 주소값을 바라봄 -> 동일

> String Constant Pool 에 한번 저장된 문자열은 소스코드에서 동일한 문자열에 대해 **재사용** 하여 메모리를 절약하는 역할을 합니다.

![image](https://github.com/lielocks/WIL/assets/107406265/d283efdb-3c16-47f6-8876-02053a6a7de2)


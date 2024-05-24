우리는 많은 시간 Java 를 이용해서 다양한 소프트웨어를 개발하면서 들었던 말이 있다.

*Java 는 JVM 이 있기 때문에 플랫폼에 종속적이지 않고 이식성이 뛰어나다.*
 
그 이유에 대해서 생각해본 경험이 있는가?

오늘은 위의 JVM 과 이식성을 이해하기 위해 꼭 알아야 하는 **Java Bytecode** 에 대해서 알아보려 한다.

<br>


## Java Bytecode, 자바 바이트코드

우리는 Java 소프트웨어를 개발하기 위해서 JDK 를 설치하고 Java 소프트웨어를 실행시키기 위해서 JRE 를 설치한다.

또한 개발을 하면 실행 결과를 확인하기 위해서 **Compile 과정** 을 거치게 되는데, 이 Compile 은 바로 JDK 나 JRE 에 함께 포함되는 **`javac.exe` 실행파일이 수행하는 것** 이다.

이는 개발자가 작성한 `.java` 파일을 JVM 이 이해할 수 있도록 하는 Bytecode 로 변환하고 `.class` 파일을 만드는 것을 의미하는데,

`.class` 파일에 존재하는 데이터가 바로 **Java Bytecode** 인 것이다.

![image](https://github.com/lielocks/WIL/assets/107406265/603d575e-9c2e-41a9-8ad8-eda384244656)

> 주의해야 할 점이 ***Compile 결과*** 라고 해서 `C 나 C++ 이 compile 하면 생성하는 기계어`와 동일하게 생각하면 안된다.
>
> 기계어는 JVM 이 다른 module 을 통해서 생성하고 실행하는데, 이 과정에서 C 나 C++ 에 비해 조금 느린 성능을 내는 것이다.

<br>

Java Bytecode 는 우리가 개발한 Java Program(code) 를 배포하는 가장 작은 단위라고 한다.

<br>


## Java Bytecode 확인하기

우리가 직접 Java Bytecode 를 생성하고 확인해보자
 
다음과 같은 java 코드가 있다고 가정해보겠다.

```java
public class Wonit {
  public static void main(String[] args) {
    String name = "워닉";
    int age = 25;

    Person blogger = new Person(name, age);

    blogger.print();
  }
}

class Person {
  String name;
  int age;

  Person(String name, int age) {
    this.name = name;
    this.age = age;
  }

  void print() {
    System.out.println("블로그 주인의 이름은 " + name + " 이며 나이는 " + age + " 이다");
  }
}
```

이제 이 코드를 Compile 해보자.

IDE 를 통해서 Compile 을 해도 동일한 결과가 나오겠지만 지금 만큼은 `javac.exe` 를 이용해서 직접 Compile 해보자!

![image](https://github.com/lielocks/WIL/assets/107406265/081cdf04-362d-471d-85a8-5afd55467a9c)

하나의 파일에서 작성했지만 우리는 2개의 Class 를 생성했기 때문에 결국 Compile 되는 코드는 2개의 Class 파일이 생성되었다.

![image](https://github.com/lielocks/WIL/assets/107406265/c4878ba6-3cf6-4fbc-b512-cb07074d4a93)

그리고 이 데이터를 HexD 나 Hex Viewer 로 확인한다면 Byte 형태로 직접 확인할 수 있지만 `javap` 로 deCompiling 을 하고 보기 편하게 바꿔보자.

```
$ javap -v -p -s Wonit.class
```

그렴 결과로 다음과 같은 분석 결과가 나오게 된다.

![image](https://github.com/lielocks/WIL/assets/107406265/b392e0bb-7c8f-4588-869d-f50f288e5499)


<br>


## Java Bytecode 의 구성요소

Java Bytecode 의 구성요소는 많이 있지만 크게 3가지가 존재한다고 보자

+ Class Format

+ Type 의 표현

+ Constant Pool

+ Instruction Set


<br>


### Class Format

위의 Java Bytecode 는 나름의 format 이 정해져있고, 해당 format 으로 표현이 된다.

우리가 Compile 한 코드는

![image](https://github.com/lielocks/WIL/assets/107406265/156880bd-e52a-4cb3-806e-d92530771ec9)

에 해당하는데, 이 format 은 다음과 같은 형식으로 구성되어 있다.

![image](https://github.com/lielocks/WIL/assets/107406265/2adc6ef7-7295-42ea-9d47-efd6e093b27c)

+ **magic**

  + Class 파일의 첫 4 byte 로 Java Class 파일이 맞는지 구분하는 용도로 쓰인다. PE Header 나 Image Signature 과 같은 용도라고 보고 CAFEBABE 라는 이름을 갖고 있다.

+ **minor_version, major_version**

  + Class 의 Version 을 나타낸다. 즉, JDK 1.6 이냐 1.8 이냐 를 구분하는데, 각각 JDK version 에 따라 다른 수가 나오게 된다

+ **constant_pool_count**

  + Class 파일의 상수 풀(Constant Pool) 의 갯수를 나타내는 용도로 사용된다.

+ **access_flags**

  + 주로 Class 의 public, final 과 같은 modifier 정보를 나타낸다.

+ **interface_count**

  + Class 가 구현한 인터페이스의 개수와 각 인터페이스에 대한 constant_pool 내의 index 를 나타낸다.


<br>


### Type 의 표현

Java Bytecode 의 표현은 우리가 사용할 수 있는 모든 Type 을 Bytecode Expression 으로 변환할 수 있다.

대표적인 타입은

+ `B` : byte

+ `C` : char

+ `I` : int

+ `L<classname>;` : reference

정도가 있다.

예를 들어서 다음과 같은 코드가 있다면

![image](https://github.com/lielocks/WIL/assets/107406265/aee71dc8-5ea0-497e-9b2e-8373c4ab1132)

**Type 의 표현** 으로 다음과 같이 표현할 수 있다.

![image](https://github.com/lielocks/WIL/assets/107406265/634e40d2-c10d-4f1a-8fb3-b8a15b96ab04)


<br>


### Constant Pool

JVM 은 Host OS 의 Memory 를 최대한 효율적으로 이용하도록 설계가 되어있다.

이를 위해서 JVM 은 Constant Pool 이라는 전략을 사용하는데, JVM 이 동적으로 코드를 실행시킬 때 모든 데이터를 즉시 생성하는 것이 아니라 

Constant Pool 에 저장하고 **Constant Pool 에 존재하는 데이터** 를 우선적으로 가져와 메모리를 더욱 효율적으로 사용할 수 있게 되는 것이다.

`# 형태의 해시코드` 로 시작하는 것이 특징이다.


<br>


### Instruction Set

Java Bytecode 는 **Compile 된 결과로 생성되는 코드** 이므로 일종의 **명령어 집합** 이라고 할 수 있다.

이를 **`JVM Instruction Set`** 이라고 한다.

**명령어** 는 당연하게 OpCode 와 Operands 로 구성되는데 Java Bytecode 에서는 **`1 Byte 의 OpCode`** 와 **`2 Byte 의 Operands`** 로 구성된다.

1 Byte의 OpCode 이므로 사용가능한 총 명령어의 수는 256개가 된다.

우리가 deCompile 한 결과에서 찾아볼 수 있다.

![image](https://github.com/lielocks/WIL/assets/107406265/10e7083f-28ea-4212-8030-afaec606227c)

우리가 짠 소스코드의 Java Bytecode 를 분석하기 위해서 알아야할 몇가지 명령어를 알아보자

+ `aload` : local variable 을 stack 에 push 한다

+ `ldc` : constant pool 에서부터 #index 에 해당하는 데이터를 가져온다

+ `astore` : local variable 에 값을 저장한다.

+ `invokespecial` : instance Method 를 호출하고 결과를 stack 에 push한다.

+ `new` : 새로운 객체를 생성한다.

+ `invokevirtual` : 메서드를 호출한다.

+ `dup` : stack 에 있는 top 을 복사한다.


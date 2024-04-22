## 인터페이스 vs 추상클래스 비교

![image](https://github.com/lielocks/WIL/assets/107406265/65e4e207-73bb-4598-b02e-826fcc9821f8)
![image](https://github.com/lielocks/WIL/assets/107406265/8fbb883b-ecc6-4bd6-bb31-4ab708d514fc)

<br>

## 인터페이스 정리

+ 내부의 모든 메서드는 `public abstract` 로 정의 (default 메소드 제외)

+ 내부의 모든 필드는 `public static final` **상수**

+ 클래스에 **다중 구현** 지원

+ **인터페이스 끼리는 다중 상속** 지원

+ 인터페이스에도 `static` `final` `private` 제어자를 붙여 클래스와 같이 **구체적인 메서드** 를 가질 수 있음.

  따라서 하위 멤버의 중복 메서드 통합을 어느정도 할 수 있겠지만, 필드는 상수이기 때문에 중복 필드 통합은 불가능

+ 인터페이스는 부모 자식 관계인 상속에 얽매이지 않고, 공통 기능이 필요할 때마다 추상 메서드를 정의해놓고 구현(implement) 하는 식으로 추상클래스보다 **자유롭게 붙였다 뗏다 사용**

+ **인터페이스는 클래스와 별도로 구현 객체가 같은 동작을 한다는 것을 보장하기 위해 사용하는 것에 초점**

+ 다중 구현이 된다는 점을 이용해, 내부 멤버가 없는 빈 껍데기 인터페이스를 선언하여 **마커 인터페이스** 로서 이용 가능

+ 보통 `xxxable` 이런 형식으로 인터페이스 네이밍 규칙을 따름

<br>

## 추상 클래스 정리

+ 추상 클래스는 하위 클래스들의 공통점들을 모아 추상화하여 만든 클래스

+ 추상 클래스는 다중 상속이 불가능하여 **단일 상속** 만 허용한다.

+ 추상클래스는 추상 메소드 외에 일반클래스와 같이 **일반적인 필드, 메서드, 생성자** 를 가질 수 있다.

+ 이러한 특징으로, 추상클래스는 **추상화(추상 메서드)를 하면서 중복되는 클래스 멤버들을 통합 및 확장**을 할 수 있다.

+ 같은 추상화인 인터페이스와 다른 점은, 추상클래스는 **클래스간의 연관 관계를 구축**하는 것에 초점을 둔다.

<br>

## 인터페이스 vs 추상클래스 사용처

인터페이스나 추상클래스나 둘이 똑같이 추상 메소드를 통해 상속 / 구현을 통한 메소드 강제 구현 규칙을 가지는 추상화 클래스이다.

다만 이 둘은 각각 고유의 몇몇 특징들을 가지고 있는데, 이러한 특징으로 인해 각각 사용처가 갈리게 된다. 
또한 기능적인 부분 뿐만 아니라 인터페이스와 추상클래스가 내포하고있는 논리적인 의미로서도 사용처가 나뉜다.

예를들어 이 둘은 대표적으로 **`'다중 상속'`** 기능 여부의 차이가 있지만, 이것이 포인트가 아니라 이에 따른 사용 목적이 다르다는 것에 포인트를 맞춰야 한다.

+ **인터페이스** : `implements` 라는 키워드 처럼 인터페이스에 정의된 메서드를 각 클래스의 목적에 맞게 기능을 구현하는 느낌

+ **추상 클래스** : `extends` 키워드를 사용해서 자신의 기능들을 하위 클래스로 확장 시키는 느낌

<br>

## 추상클래스를 사용하는 경우

+ 상속 받을 클래스들이 공통으로 가지는 메소드와 필드가 많아 **중복 멤버 통합** 을 할 때

+ 멤버에 public 이외에 접근자 (protected, private) 선언이 필요한 경우

+ non-static, non-final 필드 선언이 필요한 경우 (각 인스턴스에서 상태 변경을 위한 메소드가 필요한 경우)

+ 요구사항과 함께 구현 세부 정보의 일부 기능만 지정했을 때

+ 하위 클래스가 오버라이드하여 재정의하는 기능들을 공유하기 위한 상속 개념을 사용할 때

+ **추상 클래스**는 이를 상속할 각 객체들의 공통점을 찾아 추상화시켜 놓은 것으로,
  상속 관계를 타고 올라갔을 때 같은 부모 클래스를 상속하며 부모 클래스가 가진 기능들을 구현해야 할 경우 사용한다.

<br>

### 중복 멤버 통합

`중복되는 멤버를 통합해주는 기능`은 본래 추상 클래스의 기능이라기 보단 그냥 ***클래스의 기능*** 이라고 하는게 옳다.

다만 같은 추상화 개념인 인터페이스와 차이점을 두기 위해, **상수 밖에 정의 못하는 인터페이스에서는 할 수 없는 기능**이 추상 클래스 중복 멤버 통합이라고 보면 된다.

![image](https://github.com/lielocks/WIL/assets/107406265/1a8a1712-3841-483d-9492-0fab26a0f5dc)

```java
class NewlecExam {
    int kor; // 중복되는 멤버
    int eng; // 중복되는 멤버
    int math; // 중복되는 멤버
    int com;

    void total(){} // 중복되는 멤버
    void avg(){} // 중복되는 멤버
}

class YBMExam{
    int kor; // 중복되는 멤버
    int eng; // 중복되는 멤버
    int math; // 중복되는 멤버
    int toeic;

    void total(){} // 중복되는 멤버
    void avg(){} // 중복되는 멤버
}
```

<br>

위의 다양한 종류의 Exam 시험 클래스에서 공통적으로 보는 국어, 영어, 수학 멤버 필드를 상속(extends)을 통해 상위 클래스로 묶고, 

메서드도 통합하며 추상화(abstract)를 해주면서 나중에 다른 종류의 Exam 클래스를 추가/확장 하는데 있어 유연한 구조적인 객체 지향 설계를 만들 수 있게 된다.

![image](https://github.com/lielocks/WIL/assets/107406265/63c20f62-493b-484e-808d-e7f2c3c383d2)

```java
abstract class Exam {
    int kor;
    int eng;
    int math;

    abstract void total();
    abstract void avg();
}

class NewlecExam extends Exam {
    int com;

    void total(){}
    void avg(){}
}

class YBMExam extends Exam {
    int toeic;

    void total(){}
    void avg(){}
}
```

<br>

### 추상 클래스의 다형성 이용 설계

추상 클래스의 다형성이나 인터페이스의 다형성이나 둘이 클래스 타입을 통합한다는 취지의 기능은 똑같다.

다만, 언제 어느 때에 어느 상황에 다형성을 사용하느냐에 따른 **순서 차이** 로 추상클래스와 인터페이스의 다형성을 분리해 보았다.

이 부분은 이론적인 면이 강하기 때문에 이해하는데 있어 어려움이 있을 수 있다. 다만 확실히 이해한다면 언제 어느때에 추상클래스와 인터페이스를 적재적소에 만들어 사용할지에 대한 케이스를 결정하는데 도움이 될 수 있을 것이다.


추상 클래스는 클라이언트(ExamConsole)에서 자료형을 사용하기 전에 **미리 논리적인 클래스 상속 구조를 만들어 놓고 사용**이 결정되는 느낌이라고 보면 된다.

예를들어 위의 Exam 주제의 논리적인 상속 구조의 객체들을 클라이언트(ExamConsole)에서 다형성으로 통합적으로 받아 사용할때, 
필드로 추상 클래스 타입으로 선언하고 생성자에서 매개변수로 `new NewlecExam()` 혹은 `new YBMExam()` 객체로 받아와 업캐스팅으로 초기화함으로써, 
다양한 Exam 자식 클래스들을 다형성으로 다룰 수 있게 된다.

![image](https://github.com/lielocks/WIL/assets/107406265/42b9177f-4e5e-456f-8fa9-29f9223f21d8)

```java
public class ExamConsole {
	Exam exam; // 상위 추상 클래스 타입으로 선언
    
    // 생성자 매개변수로 new NewlecExam() 혹은 new YBMExam() 생성자가 들어와 필드를 초기화
    ExamConsole(Exam e) {
    	this.exam = e; // 업캐스팅 초기화
    }

    void input() {}
    void print() {}
}
```

<br>

정리하자면, 인터페이스나 추상 클래스나 다형성을 이용할 수 있는데, 추상클래스를 통한 다형성을 이용할 때에는,

**부모 추상 클래스와 논리적으로 관련이 있는 확장된 자식 클래스들을 다룬다는 점에서,**

클라이언트와 추상화 객체들은 **의미적으로 관계로 묶여 있다** 라고 볼 수 있다.

<br>

### 명확한 계층 구조 추상화
단순한 중복 멤버 제거를 떠나서, `클래스끼리` **명확한 계층 구조** 가 필요할때도 추상클래스를 사용한다.

공통된 기능 구현이 필요하거나, 공통으로 지켜야 할 규칙도 있을때 상속을 통해 구조화 하여 재정의(overriding)을 통해 구현한다.

이는 기능이라기 보단 **설계 원칙 이론** 에 가까운데, 아직 객체 지향의 추상화에 익숙하지 않으면, 인터페이스와의 차이점이 애매해 잘 와닿지 않은 부분일 수도 있다. (이론이란 원래 그런거니까)

기억해야 할 부분은 추상클래스나 인터페이스나 추상 메소드를 이용한 구현 원칙을 강제한다는 점은 같지만, 추상클래스는 `'클래스로서'` **클래스와 의미있는 연관 관계** 를 구축할때 사용된다라고 보면 된다.

의미있는 연관 관계란, 부모와 자식 간의 논리적으로 묶여있는 관계라고 보면 된다. 삼각형, 원, 마름모를 도형이라는 관계로 묶거나, 사자, 호랑이, 고양이를 동물이라는 관계로 묶는, **단어 그 자체** 에 논리성과 의미성이 있는 연관 관계로 떠올리면 된다.

예를들어, 대용량 SMS sender를 구현하는데 여러 통신사들이 다른 통신탑(tower)을 갖고 있어서 접속하는데 있어 각각 다른 구현이 필요하며(establish Connection With Your Tower), 

공통으로 지켜야할 규칙인 방해 금지 모드(check If Do Not Disturb Mode)도 있는 스펙일때 먼저 추상 클래스로 공통 분모들을 추상화로 구현하고, 

상속을 통해 여러 통신사 클래스를 확장하여 구현하는 식으로 객체 지향 설계 원칙 대로 프로그램을 구성할수 가 있다.

```java
/* SMS를 보내는 추상화된 코드 */
abstract class SMSSender {

    abstract public void establishConnectionWithYourTower();

    public void sendSMS() {
        establishConnectionWithYourTower();
        checkIfDoNotDisturbMode();
        // ...
        destroyConnectionWithYourTower();
    }

    abstract public void destroyConnectionWithYourTower();

    public void checkIfDoNotDisturbMode() {
        // 추상 클래스 안에서 구현
    }
}
```

```java
/* SMSSender를 통신사 클래스들이 상속 */
class SKT extends SMSSender {
    @Override
    public void establishConnectionWithYourTower() {
        // SKT 방식으로 커넥션 맺기
    }

    @Override
    public void destroyConnectionWithYourTower() {
        // SKT 방식으로 커넥션 종료
    }
}

class LG extends SMSSender {
    @Override
    public void establishConnectionWithYourTower() {
        // LG 방식으로 커넥션 맺기
    }

    @Override
    public void destroyConnectionWithYourTower() {
        // LG 방식으로 커넥션 종료
    }
}
```

<br>

## 인터페이스를 사용하는 경우

+ 어플리케이션의 기능을 정의해야 하지만 그 구현 방식이나 대상에 대해 추상화 할 때

+ **서로 관련성이 없는 클래스들을 묶어 주고** 싶을 때 (형제 관계)

+ **다중 상속(구현)** 을 통한 추상화 설계를 해야 할때

+ 특정 데이터 타입의 행동을 명시하고 싶은데, 어디서 그 행동이 구현되는지는 신경쓰지 않는 경우

+ 클래스와 별도로 **구현 객체가 같은 동작을 한다는 것을 보장** 하기 위해 사용

<br>

### 자유로운 타입 묶음

인터페이스의 가장 큰 특징은 상속에 구애 받지 않은 상속(구현) 가 가능하다는 것이다.

상속(extends)는 뭔가 클래스끼리 **논리적인 타입 묶음의 의미** 가 있다면, 구현(implements)은 **자유로운 타입 묶음의 의미** 이다. 
그래서 서로 논리적이지 않고 관련이 적은 클래스끼리 필요에 의해 ***형제 타입*** 처럼 묶어 버릴 수 있다.
 
다음과 같이 Creature 라는 최상위 추상 클래스와 그 하위 추상 클래스인 Animal, Fish 가 있고, 각 추상 클래스를 구체적으로 의미 부여해 구현한 Parrot, Tiger, People 클래스와 Whale 클래스가 있다고 가정하자.

![image](https://github.com/lielocks/WIL/assets/107406265/9c499d2d-0bdf-4fb3-94e6-381fa9281181)

위의 상속 관계도 그림을 코드로 표현하자면 다음과 같다.

```java
// 추상 클래스 (조상 클래스)
abstract class Creature { }

// 추상 클래스 (부모 클래스)
abstract class Animal extends Creature { }
abstract class Fish extends Creature { }

// 자식 클래스
class Parrot extends Animal { }
class Tiger extends Animal { }
class People extends Animal { }

class Whale extends Fish { }
```

<br>

이렇게 상속 관계를 설정해 놓고 동작을 하는 메소드를 추가해야 하는데, 만일 수영 동작을 하는 `swimming() 메소드`를 각 자식 클래스에 추가해야 한다고 하자.

이때 나중에 확장을 위해 **추상화 원칙** 을 따라야 한다고 한다. 
그러면 부모나 조상 클래스에 추상 메소드를 추가해야 하는데, 수영은 고래(Whale) 과 사람(People)만 할수 있으니 이를 동시에 포함하는 Creature 추상 클래스에서 추상 메소드를 추가해야 한다. 
(호랑이와 앵무새는 수영을 못한다고 가정한다)

하지만 Creature 추상 클래스에 추상 메소드를 추가하면, 곧 이를 상속하는 모든 자손/자식 클래스에서 반드시 메소드를 구체화 해야한다는 규칙 때문에 
실제로 수영을 못하는 호랑이(Tiger)와 앵무새(Parrot) 클래스에서도 메소드를 구현해야 하는 ***강제성*** 이 생기게 된다.

```java
// 추상 클래스 (조상 클래스)
abstract class Creature { 
	abstract void swimming(); // 수영 동작을 하는 추상 메소드
}

// 추상 클래스 (부모 클래스)
abstract class Animal extends Creature { }
abstract class Fish extends Creature { }

// 자식 클래스
class Parrot extends Animal {
	void swimming() {} // 앵무새는 수영을 할수 없지만 상속 관계로 인해 강제적으로 메소드를 구현해야하는 사태가 일어난다.
}
class Tiger extends Animal {
	void swimming() {} // 호랑이는 수영을 할수 없지만 상속 관계로 인해 강제적으로 메소드를 구현해야하는 사태가 일어난다.
}
class People extends Animal {
	void swimming() {
    	// ...
    } 
}

class Whale extends Fish {
	void swimming() {
		// ...
    } 
}
```

<br>

물론 메소드를 선언하기만 하고 빈칸으로 놔두면 되기는 하지만, 이는 객체 지향 설계에 위반될 뿐만 아니라 나중에 유지보수 면에서도 마이너스 적인 효과가 된다.

 
따라서 상속에 얽매히지 않는 인터페이스에 추상 메소드를 선언하고 이를 구현(implements) 하면서 **자유로운 타입 묶음을 통해 추상화를 이루게 하는 것** 이다.

![image](https://github.com/lielocks/WIL/assets/107406265/e1d88fe8-b818-4ded-8c8a-31dc221e9638)

```java
abstract class Creature { }

abstract class Animal extends Creature { }
abstract class Fish extends Creature { }

// 수영 동작 추상 메소드를 따로 인터페이스를 만들어 넣는다.
interface Swimmable {
    void swimming();
}

class Tiger extends Animal { }
class Parrot extends Animal { }
class People extends Animal implements Swimmable{ // 인터페이스를 구현함으로써 동작이 필요한 클래스에만 따로 상속에 구애받지않고 묶음
    @Override
    public void swimming() {}
}

class Whale extends Fish implements Swimmable{ // 인터페이스를 구현함으로써 동작이 필요한 클래스에만 따로 상속에 구애받지않고 묶음
    @Override
    public void swimming() {}
}
```

<br>

이외에, 날아 다니는 동작 메서드나, 말하는 동작 메서드를 각각 `인터페이스마다 분리하여 선언` 하고 이를 `각 자식 클래스에 자유롭게 상속시킴` 으로써 **보다 구조화된 객체 지향 설계** 를 추구 할 수 있는 것이다.

![image](https://github.com/lielocks/WIL/assets/107406265/581da0a2-41e5-4ebb-8bea-93f29a0edb28)

```java
abstract class Creature { }

abstract class Animal extends Creature { }
abstract class Fish extends Creature { }

interface Flyable {
    void flying();
}

interface Talkable {
    void talking();
}

interface Swimmable {
    void swimming();
}

class Tiger extends Animal { }
class Parrot extends Animal implements Talkable{
    @Override
    public void talking() {
        
    }
}
class People extends Animal implements Talkable, Swimmable{ // 필요에 따라 적재적소에 다중으로 여러개 추가(구현)이 가능함
    @Override
    public void talking() {}

    @Override
    public void swimming() {}
}

class Whale extends Fish implements Swimmable{
    @Override
    public void swimming() {}
}
```

<br>

### 인터페이스 다형성 이용 설계

추상클래스는 클라이언트에서 자료형을 사용하기 전에 **`미리 논리적인 클래스 상속 구조를 만들어 놓고 사용이 결정`** 되는 느낌이라면, 

인터페이스는 반대로 먼저든 나중이든 **`그때 그때 필요에 따라 구현해서 자유롭게 붙였다 땟다`** 하는 느낌으로 보면 된다.

**외부 파일에 데이터를 저장하는 라이브러리** 를 가져와 사용한다고 가정해보자.

이 라이브러리 안에는 Filesaver 클래스를 이용해 외부 파일로 데이터를 저장한다. 
이때 Filesaver 클래스를 보면 `필드 변수로 Storable 인터페이스 타입의 객체를 선언` 하여 `save() 메서드` 에서 인터페이스 타입 객체를 이용하는 것을 볼 수 있다.
즉, Filesaver 클래스는 구체적인 클래스 타입으로 통신하는 것이 아닌 ***인터페이스 라는 중개 타입을 이용하여 통신*** 하는 것이다.

![image](https://github.com/lielocks/WIL/assets/107406265/ad9744f7-61cc-4c05-b297-5f7de6b4b437)

```java
// 클래스 데이터를 외부 파일로 저장 가능하게 만드는 인터페이스
interface Storable {
    int getData();
}

// 외부 파일에 데이터를 저장하는 클래스
class FileSaver {
    Storable target; // 인터페이스 타입의 객체를 필드로 선언
    
    FileSaver(Storable target) {
    	this.target = target;
    }
    
    int save() {
        int data = target.getData(); // 인터페이스 객체 필드의 메서드를 실행하여 값을 가져와 사용
        // ...
    }
}
```

<br>

그래서 Exam, File, Rectangle 같은 ** 전혀 연관 관계가 없는 클래스** 들을 FileSaver 클래스에 전달해서 데이터를 파일로 저장하기 위해선, 

**인터페이스로 타입 통합** 하여 `형제 관계`를 구성하여 FileSaver 클래스의 인터페이스 객체 필드로 넘기는 식으로, 상속에 얽매히지 않은 자유로운 인터페이스의 다형성을 이용하는 것으로 볼 수 있는 것이다.

![image](https://github.com/lielocks/WIL/assets/107406265/7814a159-007f-4f31-9bc7-05254e3d8819)

```java
class Exam implements Storable { // 인터페이스를 구현함으로서 클래스끼리 형제 관계를 맺음 
    int kor;
    int eng;
    int math;

    void total(){}
    void avg(){}

    // 인터페이스 통신 메소드 구현
    int getData(){
        // ...
    }
}

class File implements Storable { // 인터페이스를 구현함으로서 클래스끼리 형제 관계를 맺음 
    String src;
    
    boolean isFile(){}
    void mkDir(){}
    
    // 인터페이스 통신 메소드 구현
    int getData(){
        // ...
    }
}
```

<br>

만일 **분석 라이브러리** 를 사용한다고 했을때 Analyzer 클래스에서 통신으로 사용되는 Calculateable 인터페이스 타입 객체 필드에 Exam 클래스를 전달하기 위해 역시 다중 구현이 가능하다는 점을 이용해 Caculateable 인터페이스를 implements만 하면 되는 일이 된다.

![image](https://github.com/lielocks/WIL/assets/107406265/64e07183-123d-4599-bcca-835a4fb56e95)

```java
interface Caculatable {
    void total();
    void avg();
}

class Analyzer {
	Caculatable caculate;
    
    void result() {}
    // ...
}

class Exam implements Storable, Caculatable { // 인터페이스를 구현함으로서 클래스끼리 형제 관계를 맺음
    int kor;
    int eng;
    int math;

    void total(){}
    void avg(){}
    int getData(){}
}
```

<br>

정리하자면, 인터페이스의 다형성은 **부모 자식 클래스와 달리 논리적으로 관련이 없는 별개의 클래스들을 다룬다는 점**에서,

**상속 관계에 얽매히지 않고 구현(implements) 만 하면 자유롭게 다형성** 을 이용할 수 있다고 보면 된다.

<br>

### 마커 인터페이스

`자바의 마커 인터페이스` 는 일반적인 인터페이스와 동일하지만 사실상 아무 메소드도 선언하지 않은 ***빈 껍데기 인터페이스*** 를 말한다. 예를 들면 아래와 같다.

```java
interface XXXable{ // 아무런 내부 내용이 없는 빈 껍데기 인터페이스
}
```

<br>

얼핏 보기엔 인터페이스의 존재 원리와 반하는 형태이다.
다만 인터페이스를 자유롭게 다중 상속이 가능하다는 점에서 착안하여 이러한 형태로도 응용 사용이 가능한 것으로 보면 된다.
아무 내용도 없어서 쓸모가 없어 보이지만, 마커 인터페이스의 역할은 오로지 **객체의 타입과 관련된 정보만을 제공해주기만** 한다.
 
다음 예시 코드를 봐보자.

상위 클래스 Animal을 만들고 그 하위들로 Lion, Chicken, Snake ...등 여러가지 동물 클래스들을 만들어 상속 관계를 맺었다. 
이때 born 이라는 메서드에서 Animal 타입의 매개변수를 받고 **새끼를 낳는 동물** 인지 **알을 낳는 동물** 인지 구분하기 위해 일일히 `instanceof 연산자로 클래스 타입을 구분` 하였다.

```java
class Animal {
    public static void born(Animal a) {
        if(a instanceof Lion) {
            System.out.println("새끼를 낳았습니다.");
        } else if(a instanceof Chicken) {
            System.out.println("알을 낳았습니다.");
        } else if(a instanceof Snake) {
            System.out.println("알을 낳았습니다.");
        }
        // ...
    }
}

class Lion extends Animal { }
class Chicken extends Animal { }
class Snake extends Animal { }
```

<br>

하지만 이러한 방식은 자식 클래스 갯수가 많으면 많을 수록 코드가 난잡해지고 길어진다는 단점이 있다.

따라서 아무런 내용이 없는 빈 껍데기 인터페이스를 선언하고 적절한 클래스에 implements 시킴으로써, 
추상화, 다형성 이런걸 떠나서 그냥 **`단순한 타입 체크용`**으로 사용하는 것이다. 그러면 조건문 코드도 다음과 같이 심플해질 수 있다.

```java
// 새끼를 낮을 수 있다는 표식 역할을 해주는 마커 인터페이스
interface Breedable {}

class Animal {
    public static void born(Animal a) {
        if(a instanceof Breedable) {
            System.out.println("새끼를 낳았습니다.");
        } else {
            System.out.println("알을 낳았습니다.");
        }
    }
}

class Lion extends Animal implements Breedable { }
class Chicken extends Animal { }
class Snake extends Animal { }
```

>
> 이러한 마커 인터페이스의 대표적인 자바 인터페이스로는 Serializable, Cloneable 정도 있다.
        
<br>

## 인터페이스 + 추상클래스 조합

이처럼 각각 인터페이스와 추상클래스의 차이점을 알기위해 각 고유한 특징에 따른 개별 사용처에 대해 학습했지만, 사실 이 둘은 같이 조합되어 많이 사용되기도 한다.

가장 큰 특징이라고 할 수 있는 **추상 클래스의 중복 멤버 통합** 과 **인터페이스의 다중 상속 기능** 을 ***동시에 사용***하기 위해서다. 
따라서 이 둘을 같이 사용하는 여러가지 코드 패턴들이 나왔고, 이것이 한번쯤 들어본 디자인 패턴의 근간이 되었다고 보면 된다.

<br>

### 추상클래스에 인터페이스 일부 구현 방법

추상 클래스에 인터페이스를 implements 하고, 인터페이스의 추상 메소드를 아예 구현하지 않거나, 혹은 일부만 구현하는 식으로 통합된 추상화 클래스를 만들수 있다.

```java
interface Animal {
    void walk();
    void run();
    void breed();
}

// Animal 인터페이스를 일부만 구현하는 포유류 추상 클래스
abstract class Mammalia implements Animal {
    public void walk() { ... }
    public void run() { ... }
    // breed() 메서드는 자식 클래스에서 구체적으로 구현하도록 일부로 구현하지 않음 (추상 메서드로 처리)
}

// 인터페이스 + 추상 클래스를 상속하여 사용
class Lion extends Mammalia {
    @Override
    public void breed() { ... }
}
```

<br>

## Interface - Abstract- Concrete Class 디자인 패턴

객체 지향 프로그래밍을 해보면 **디자인 패턴** 이라는 단어를 한번쯤은 들어본 적이 있을 것이다.
디자인 패턴은 거창한 논문 이론 그런것 없이 우리가 지금까지 배운 인터페이스와 추상 클래스를 이용한 클래스 설계 패턴일 뿐이다.

`인터페이스` 는 정말 강력한 녀석이지만 `필드는 상수만 가능` 하며, **중복된 필드가 있을 경우** 인터페이스로 해결할 수 없다는 단점이 있다. 
이때는 어쩔 수 없이 추상 클래스를 사용하여야 한다. 
그렇다고 `추상 클래스`를 남용하면 ***단일 상속만 되는 제한 때문에 클래스의 의존성이 커지게 된다.***

따라서 이러한 서로간의 제약들을 극복할 여러 조합 방법이 **인터페이스 - 추상클래스 - 클래스 구현 디자인 패턴** 이다.
 
아직 디자인 패턴을 배울 정도의 기반과 짬이 되지는 않지만 인터페이스와 추상클래스를 보다 이해하는데 있어 한번쯤 경험해 보는 것이 좋을 것 같아 간단한 패턴 예제를 가져와 봤다.
 
예를들어 다른 개발자로부터 다음과 같은 표준화 인터페이스 코드를 전달 받았다고 가정하자.

```java
interface IShape {
    void setOpacity(double opacity); // 도형 투명도 지정
    void setColor(String color); // 도형 색깔 지정
    void draw(); // 도형 그리기
}
```

<br>

우리는 이 Shape 인터페이스에 적힌 스펙대로 도형 클래스를 설계 하여야 한다.

그래서 설계에 맞게 다음과 같이 Rectangle 과 Square 클래스를 만들고 인터페이스를 구현하여 추상 메소드를 구체화 하였다.

```java
interface IShape {
    void setOpacity(double opacity);
    void setColor(String color);
    void draw();
}

// 인터페이스 설계서에 따라 클래스를 구현
class Rectangle implements IShape {
    double opacity; // ! 중복
    String color; // ! 중복

    public void setOpacity(double opacity) { // ! 중복
        this.opacity = opacity;
    }
    public void setColor(String color) { // ! 중복
        this.color = color;
    }

    public void draw() {
        System.out.println("draw Rectangle with");
        System.out.println(opacity);
        System.out.println(color);
    }
}

// 인터페이스 설계서에 따라 클래스를 구현
class Square implements IShape {
    double opacity; // ! 중복
    String color; // ! 중복

    public void setOpacity(double opacity) { // ! 중복
        this.opacity = opacity;
    }
    public void setColor(String color) { // ! 중복
        this.color = color;
    }

    public void draw() {
        System.out.println("draw Rectangle with");
        System.out.println(opacity);
        System.out.println(color);
    }
}

public class Pattern {
    public static void main(String[] args) {
        IShape[] rec = { new Rectangle(), new Square() };

        rec[0].setOpacity(0.7);
        rec[0].setColor("red");
        rec[0].draw();

        rec[1].setOpacity(0.3);
        rec[1].setColor("yellow");
        rec[1].draw();
    }
}
```

<br>

하지만 한눈에 봐도 중복된 코드가 눈에 보인다.

`인터페이스`는 기본적으로 ***중복되는 멤버에 대해 클래스와 같이 묶어주는 역할을 못한다.*** 
인터페이스에 선언할 수 있는 필드는 **오로지 상수** 이며, 디폴트 메서드가 있더라도 한계가 있다.
 
이런 문제점을 해결할 수 있는 방법이 인터페이스(interface)와 구체 클래스(concrete class) **`중간에 추상 클래스(abstract class)를 하나 두고`** 
**공통되는 부분을 모아 두는 것이다.**

위의 예제에서 공통된 부분을 추상 클래스로 따로 뽑아 모으면 다음과 같아지게 된다.

```java
abstract class Shape implements IShape { // 인터페이스를 상속하는 추상클래스
	// 중복되는 멤버들을 모아놓고
    protected double opacity;
    protected String color;

    public void setOpacity(double opacity) {
        this.opacity = opacity;
    }
    public void setColor(String color) {
        this.color = color;
    }
    
    // void draw(); 는 구체화 안함
}
```
그리고 실제 구현 클래스인 Rectangle 과 Square 클래스에서는 추상 클래스 Shape를 extends 하고 인터페이스의 draw() 메소드 부분만 구체화 해주면 된다.

```java
class Rectangle extends Shape {
    public void draw() {
        System.out.println("draw Rectangle with");
        System.out.println(opacity);
        System.out.println(color);
    }
}

class Square extends Shape {
    public void draw() {
        System.out.println("draw Rectangle with");
        System.out.println(opacity);
        System.out.println(color);
    }
}
```

<br>

이런식으로 자바에서 제공하는 재료들을 이용하여 각자의 위치에 맞게 여러 조합적인 코드를 짜는 것이 디자인 패턴인 것이다.

다만 위의 방법은 중복 제거에 효과적이지만, 클래스 상속을 기반으로 하고 있기 때문에 `다른 클래스를 상속 받아야 하는 경우에는 이 패턴을 활용할 수 없다` 는 단점이 존재한다. 
이런 경우에는 유명한 디자인 패턴인 Adapter 패턴을 이용하기도 한다. (이름 존재 정도만 알고 넘어가자)


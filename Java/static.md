# static을 써야 하는 이유 → 일관된 값 유지 가능

클래스 내에서 선언된 인스턴스 변수는 해당 클래스의 인스턴스들 간에 값이 공유되지만, **`static`** 키워드를 사용하여 선언된 클래스 변수는 클래스 레벨에서 값이 공유됩니다. 따라서, 클래스 변수는 클래스의 모든 인스턴스들이 같은 값을 참조하게 됩니다.

**static** 키워드를 사용하지 않고 **long minx = Long.MAX_VALUE**와 같이 인스턴스 변수로 선언한다면, 각 인스턴스마다 **minx** 변수가 독립적으로 생성되어 값을 유지하게 됩니다. 이렇게 되면 **solution** 메서드에서 **minx** 값을 업데이트해도 다른 인스턴스에서는 해당 업데이트가 반영되지 않습니다. 

따라서, **static** 키워드를 사용하여 클래스 변수로 선언하는 것이 필요합니다.

**static** 키워드를 사용하여 클래스 변수로 선언한 경우, 해당 변수는 클래스 레벨에서 하나의 값만 유지되어 모든 인스턴스에서 동일한 값을 참조할 수 있습니다. 이는 **solution** 메서드에서 **minx**, **miny**, **maxx**, **maxy** 값을 업데이트하고 다른 메서드에서 이 값을 참조할 때 일관성을 유지하는 데 도움이 됩니다.

```java
class Example {
static int count = 0; // 클래스 변수

public void increaseCount() {
    count++; // count 값을 증가시킴
}

public static void main(String[] args) {
    Example ex1 = new Example();
    Example ex2 = new Example();

    ex1.increaseCount();
    System.out.println(ex1.count); // 출력: 1

    ex2.increaseCount();
    System.out.println(ex2.count); // 출력: 2

    System.out.println(Example.count); // 출력: 2 (클래스 이름으로도 접근 가능)
	}
}
```

위의 코드에서 `count`는 **`static`** 키워드로 선언된 클래스 변수입니다. 이 변수는 **`Example`** 클래스의 모든 인스턴스들이 공유하는 값입니다. **`increaseCount`** 메서드는 **`count`** 값을 증가시키는 역할을 합니다.

**`main`** 메서드에서 **`ex1`**과 **`ex2`**라는 두 개의 **`Example`** 인스턴스를 생성하고, 각각의 인스턴스를 통해 **`increaseCount`** 메서드를 호출하여 **`count`** 값을 증가시킵니다. 그 결과, **`ex1.count`**는 1이 되고, **`ex2.count`**는 2가 됩니다. 또한, **`Example.count`**를 통해 클래스 변수에 접근하여 동일한 값을 확인할 수 있습니다.

이처럼 **`static`** 키워드를 사용하면 클래스 변수를 인스턴스들 간에 공유하여 사용할 수 있으며, 일관된 값을 유지할 수 있습니다.

```java
class Example {
long count = 0; // 인스턴스 변수

public void increaseCount() {
    count++; // count 값을 증가시킴
}

public static void main(String[] args) {
    Example ex1 = new Example();
    Example ex2 = new Example();

    ex1.increaseCount();
    System.out.println(ex1.count); // 출력: 1

    ex2.increaseCount();
    System.out.println(ex2.count); // 출력: 1

    // System.out.println(Example.count); // 오류: 인스턴스 변수는 클래스 이름으로 직접 접근 불가
	}
}
```

> 위의 코드에서 **`count`**는 **`long`** 타입의 인스턴스 변수입니다. 이 변수는 **`Example`** 클래스의 각 인스턴스마다 개별적으로 가지는 값입니다. **`increaseCount`** 메서드는 **`count`** 값을 증가시키는 역할을 합니다.
> 
> 
> > **`main`** 메서드에서 **`ex1`**과 **`ex2`**라는 두 개의 **`Example`** 인스턴스를 생성하고, 각각의 인스턴스를 통해 **`increaseCount`** 메서드를 호출하여 **`count`** 값을 증가시킵니다. 하지만 각 인스턴스는 독립적인 상태를 유지하므로 **`ex1.count`**와 **`ex2.count`**는 서로에게 영향을 주지 않고 각각 1로 유지됩니다.
> > 
> 
> > **`static`** 키워드를 사용하지 않았을 때의 주요 차이점은 인스턴스 변수는 개별 인스턴스에 속하며, 클래스 변수는 모든 인스턴스들이 공유한다는 점입니다.
> > 

1. **데이터 공유** : **`static`** 변수는 클래스의 모든 인스턴스들에 의해 공유됩니다. 따라서 한 인스턴스에서 **`static`** 변수의 값을 변경하면, 이 변경된 값은 다른 모든 인스턴스에서도 볼 수 있습니다. 이를 통해 데이터를 효율적으로 공유하고 관리할 수 있습니다.
2. **메모리 효율성** : **`static`** 변수는 해당 클래스의 모든 인스턴스가 공유하므로, 인스턴스마다 해당 변수를 저장하는 메모리 공간을 할당할 필요가 없습니다. 이는 메모리 사용량을 줄이고 성능을 향상시킵니다.
3. **전역 접근성** : **`static`** 변수는 해당 클래스의 어떤 인스턴스에서도 접근할 수 있습니다. 이는 다른 메서드나 클래스에서 쉽게 참조하고 사용할 수 있다는 장점을 제공합니다.
4. **상수 값 저장** : **`static final`** 키워드를 함께 사용하여 **`static`** 변수를 상수로 선언할 수 있습니다. 이는 변하지 않는 값을 저장하고 공유할 때 유용합니다.
5. **프로그램 초기화** : **`static`** 블록을 사용하여 클래스가 처음으로 로드될 때 초기화 작업을 수행할 수 있습니다. 이는 프로그램이 시작될 때 필요한 초기화 코드를 실행하는 데 사용됩니다.

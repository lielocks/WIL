## 1. 다양한 Garbage Collection 알고리즘

JVM 이 메모리를 자동으로 관리해주는 것은 개발자의 입장에서 상당한 메리트이다. 

하지만 문제는 GC를 수행하기 위해 Stop The World에 의해 `애플리케이션이 중지되는 것` 에 있다. 

**Heap의 사이즈가 커지면서 애플리케이션의 지연(Suspend) 현상** 이 두드러지게 되었고, 이를 막기 위해 다양한 Garbage Collection(가비지 컬렉션) 알고리즘을 지원하고 있다. 

<br>

### [Serial GC]

Serial GC 의 `Young 영역` 은 앞서 설명한 알고리즘 **(Mark and Sweep)** 대로 수행된다.

하지만 `Old 영역` 에서는 **Mark Sweep Compact** 알고리즘이 사용되는데, 기존의 Mark Sweep 에 *Compact 라는 작업이 추가* 되었다.

**`Compact`** 는 Heap 영역을 정리하기 위한 단계로 유효한 객체들이 연속되게 쌓이도록 **Heap 의 가장 앞 부분부터 채워서** `객체가 존재하는 부분 / 객체 존재하지 않는 부분` 으로 나누는 것이다.

![image](https://github.com/lielocks/WIL/assets/107406265/54014e88-e562-471b-a7d3-cb38b63972c2)

`Serial GC` 는 *서버의 CPU 코어가 1개* 일 때 사용하기 위해 개발되었으며, 

모든 Garbage Collection 일을 처리하기 위해 **1개의 thread 만** 을 이용한다.

그렇기 때문에 CPU 의 코어가 여러 개인 운영 서버에서 `Serial GC를 사용하는 것은 반드시 피해야 한다.`

<br>

### [Parallel GC]

Parallel GC 는 Throughput GC 로도 알려져 있으며, 기본적인 처리 과정은 Serial GC 와 동일하다.

하지만 Parallel GC 는 **`여러개의 thread` 를 통해 Parallel 하게 GC를 수행함** 으로써 ***GC의 오버헤드를 상당히 줄여준다.***

Parallel GC 는 `Multi Processor 또는 Multi Thread Machine` 에서 중간 규모부터 대규모의 데이터를 처리하는 어플리케이션을 위해 고안되었으며,

옵션을 통해 어플리케이션의 **`최대 지연시간`** 또는 **`GC 를 수행할 thread 의 갯수`** 를 설정해줄 수 있다.

![image](https://github.com/lielocks/WIL/assets/107406265/5a891266-981f-4542-92a8-078c6d84eaaa)

Parallel GC 가 **GC 의 오버헤드를 상당히 줄여주었고** , Java8까지 `기본 가비지 컬렉터(Default Garbage Collector)` 로 사용되었다. 

그럼에도 불구하고 Application이 멈추는 것은 피할 수 없었고, 이러한 부분을 개선하기 위해 다른 알고리즘이 더 등장하게 되었다.

<br>

### [Parallel Old GC]

Parallel Old GC 는 JDK5 update6부터 제공한 GC 이며, 앞서 설명한 Parallel GC 와 Old 영역의 GC 알고리즘만 다르다. 

**`Parallel Old GC`** 에서는 Mark Sweep Compact가 아닌 **Mark Summary Compaction** 이 사용되는데, Summary 단계에서는 ***앞서 GC를 수행한 영역에 대해서 별도로 살아있는 객체를 색별한다는 점*** 에서 다르며 조금 더 복잡하다.

<br>

### [CMS (Concurrent Mark Sweep) GC]

CMS( **Concurrent Mark Sweep** ) GC 는 **Parallel GC 와 마찬가지로 여러개의 쓰레드** 를 이용한다.

하지만 `기존의 Serial GC 나 Parallel GC 와는 다르게` Mark Sweep 알고리즘을 **`Concurrent`** 하게 수행하게 된다.

![image](https://github.com/lielocks/WIL/assets/107406265/ab448a71-83bc-432e-967f-40b0611bd421)

이러한 CMS GC 는 애플리케이션의 지연 시간을 최소화 하기 위해 고안되었으며, **`애플리케이션이 구동중일 때`** **프로세서의 자원을 공유하여 이용가능** 해야 한다. 

CMS GC 가 수행될 때에는 자원이 GC 를 위해서도 사용되므로 응답이 느려질 순 있지만 **응답이 멈추지는 않게 된다.**

하지만 이러한 CMS GC 는 다른 GC 방식보다 *메모리와 CPU 를 더 많이* 필요로 하며, 
**`Compaction 단계를 수행하지 않는다`** 는 단점이 있다.

이 때문에 시스템이 장기적으로 운영되다가 `조각난 메모리들이 많아` *Compaction 단계가 수행되면 오히려 Stop The World 시간이 길어지는 문제* 가 발생할 수 있다.

![image](https://github.com/lielocks/WIL/assets/107406265/67a013f0-69fd-494a-ba26-23f8ba5fd224)

만약 GC가 수행되면서 98% 이상의 시간이 CMS GC에 소요되고, 2% 이하의 시간이 Heap의 정리에 사용된다면 CMS GC에 의해 OutOfMemoryError가 던져질 것이다. 

물론 이를 disable 하는 옵션이 있지만, CMS GC는 Java9 버젼부터 deprecated 되었고 결국 Java14에서는 사용이 중지되었기 때문에 굳이 알아볼 필요는 없을 것 같다.

<br>

### [G1 (Garbage First) GC]



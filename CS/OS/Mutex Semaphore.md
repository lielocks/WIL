## 1. 세마포어(Semaphore)와 뮤텍스(Mutex)

세마포어와 뮤텍스는 모두 동기화를 이용되는 도구이지만 차이가 있다. 자세한 내용은 아래와 같다.

<br>

 
### [ Mutex(뮤텍스) ]

![image](https://github.com/lielocks/WIL/assets/107406265/4312ba34-44fe-47d5-8557-5c9f788d1ac3)

Mutex 는 *자원에 대한 접근을 동기화* 하기 위해 사용되는 **`상호배제`** 기술이다.

이것은 프로그램이 시작될 때 고유한 이름으로 생성된다.

뮤텍스는 **Locking 메커니즘으로 오직 하나의 thread 만이 동일한 시점에 mutex 를 얻어 critical section 에 들어올 수 있다.**

그리고 오직 `이 thread 만이 임계 영역에서 나갈 때` *mutex 를 해제* 할 수 있다.

```
wait (mutex);
…..
Critical Section
…..
signal (mutex);
```

<br>


위의 수도 코드는 mutex 의 과정을 보여주고 있는데, `lock 을 얻은 thread 만이` **critical section 을 나갈 때 lock 을 해제** 해줄 수 있다.

이러한 이유는 ***mutex 가 1개의 lock 만을 갖는 Locking 메커니즘*** 이기 때문이다.

<br>


### [ Semaphore(세마포어) ]

![image](https://github.com/lielocks/WIL/assets/107406265/f5b0535f-1f8b-43d7-8ec5-f991b3d23041)

세마포어는 **`Signaling 메커니즘`** 이라는 점에서 mutex 와 다르다.

semaphore 는 **lock 을 걸지 않은 thread 도 Signal 을 보내 lock 을 해제할 수 있다** 는 점에서,

*wait 함수를 호출한 thread 만이 siganl 함수를 호출할 수 있는 mutex* 와 다르다.

semaphore 는 동기화를 위해 **`wait`** 와 **`signal`** 이라는 2개의 atomic operations 를 사용한다.

`wait` 를 호출하면 *semaphore 의 count 를 1 줄이고,* `semaphore 의 count 가 0보다 작거나 같아질 경우` 에 **lock** 이 실행된다.

```java
struct semaphore {
    int count;
    queueType queue;
};

void semWait (semaphore s) {
    s.count--;
    if (s.count <= 0) {
    	// 락이 걸리고 공유 자원에 접근할 수 없음
    }
} 

void semSignal (semaphore s) {
    s.count++;
    if (s.count <= 0) {
    	// 아직 락에 걸려 대기중인 프로세스가 있음
    }
}
```

`semaphore 의 count 가 0보다 작거나 같아져` **동기화** 가 실행된 상황에, 

`다른 thread 가 signal 함수를 호출` 하면 **semaphore 의 count 가 1 증가** 하고, 

해당 `thread 는 lock 에서 나올 수 있다.`

semaphore 는 크게 **`Counting Semaphores`** , **`Binary Semaphore`** 2종류가 있다.

**`Counting Semaphore`** 는 semaphore 의 count 가 양의 정수값을 가지며, 설정한 값만큼 thread 를 허용하고 그 이상의 thread 가 자원에 접근하면 lock 이 실행된다.

**`Binary Semaphore`** 는 semaphore 의 count 가 1이며 mutex 처럼 사용될 수 있다.

(mutex 는 절대로 semaphore 처럼 사용될 수 없다.)

<br>


## 2. 세마포어(Semaphore) vs 뮤텍스(Mutex) 차이

### [ 세마포어와 뮤텍스 차이 정리 ]

Mutex 는 **`Locking 메커니즘`** 으로 **lock 을 걸은 thread 만이** *critical section 을 나갈때* **lock 을 해제** 할 수 있다. 

하지만 Semaphore 는 **`Signaling 메커니즘`** 으로 **lock 을 걸지 않은 thread** 도 *signal을 사용해* **lock 을 해제** 할 수 있다. 

*Semaphore 의 count 를 1로 설정하면 mutex 처럼 활용* 할 수 있다.

+ *Mutex* 는 동기화 대상이 오직 1개일 때 사용하며, *Semaphore* 는 동기화 대상이 1개 이상일 때 사용합니다.

+ *Mutex* 는 자원을 소유할 수 있고 책임을 가지는 반면, *Semaphore* 는 **자원 소유가 불가** 합니다.

+ *Mutex* 는 상태가 0,1 뿐이므로 Lock 을 가질 수 없고 소유하고 있는 thread 만이 이 Mutex 를 해제할 수 있습니다.

  반면 *Semaphore* 는 Semaphore 를 소유하지 않는 thread 가 Semaphore 를 해제할 수 있습니다.

+ *Semaphore* 는 **system 범위** 에 걸쳐 있고 파일 시스템 상의 파일로 존재합니다.

  반면, *Mutex* 는 **process 의 범위** 를 가지며 process 종료될 때 자동으로 clean up 됩니다.


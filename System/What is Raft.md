## Raft Consensus

![image](https://github.com/lielocks/WIL/assets/107406265/d7f424db-d93c-49f4-831c-e4924f18cc2d)

> *Raft (땟목) 합의 알고리즘의 마스코트 로고*

2014년 USENIX 에서 발표된 “In Search of an Understandable Consensus Algorithm” 라는 논문에서 소개한 Raft 합의 알고리즘에 대해 다루어보고자 한다. 

Raft 는 현재 `Kubernetes 의 etcd`, `Apache Kafka` 등에서 많이 채택되고 있는 non-Byzantine 환경의 합의 알고리즘이다. 

논문 제목에 있는 Understanable 을 직역하면 “이해할 수 있는” 이라는 뜻이다. 

그러면 이해할 수 없는 알고리즘도 있는건가? 바로 한 번 알아보자

<br>

### Raft | 등장 배경

Raft 논문은 제목에서 알 수 있듯이 이해가능한(Understanbility) 합의 알고리즘을 만드는데 목적을 가지고 있다. 

Raft 의 등장 이전에는 분산 시스템의 거장 Lesile Lamport 에 의해 만들어진 Paxos 가 대세를 이루었는데 스탠포드 대학의 학생인 본인들이 Paxos 를 이해하는데 거의 1년 가까이 걸릴 정도로 어려웠기 때문에 새로운 합의 알고리즘을 만들려고 했다고 한다.

![image](https://github.com/lielocks/WIL/assets/107406265/91b26dec-3a18-4d6d-b807-71b0244a22f9)

<br>

### 복제 상태 머신 (Replicated State Machine)

합의 알고리즘은 대부분 복제 상태 머신을 구현하기 위해서 사용되는 수단이다. 

블록체인도 마찬가지로 분산 시스템에서 각 node 가 동일한 상태를 가지는 것을 목표로 하기 때문에 복제 상태 머신의 한 종류라고 할 수 있다.

<br>

복제 상태 머신에서는 다수의 node 가 cluster를 구성하고 있는 상황에서 일부 장애가 발생하더라도 전체 시스템은 문제 없이 동작할 수 있도록 한다.

이런 특징 덕분에 대규모 분산 시스템에서 다양한 종류의 장애 허용 문제를 해결하기 위해 사용되며 대표적으로 kafka 에서 이용하는 Apache Zookeeper 와 Kubernetes 에서 이용하는 etcd 등이 있다.

![image](https://github.com/lielocks/WIL/assets/107406265/7531597c-c506-49f0-a32e-64c250869bfd)

> *[그림 2] 복제 상태 머신의 아키텍처*


구현 방식

<br>

Raft 는 복제 log(Replicated Log) 를 구성해서 복제 상태 머신을 구현한다. 

복제 log는 cluster에 연결된 모든 node 에 대해서 사용자의 명령어를 동일한 순서로 저장하는 것을 목표로 한다. 

일관된 log를 잘 복제하면 cluster의 각 node 의 상태 머신(State Machine) 이 명령어를 순차적으로 해석해서 동일한 상태를 만든다. 

메시지는 결정론적 명령만을 수행하기 때문에 항상 동일한 상태가 만들어 질 것을 보장한다.

<br>

클라이언트는 합의 모듈(Consensus Module) 에 log 기록을 요청하고 이를 다른 서버와 통신해서 서로 다른 노드에 저장된 복제 log가 최종 일관성을 가질 것을 보장한다. 

궁극적으로, 다수의 node 는 마치 하나의 단일 node 처럼 동작할 수 있고 신뢰할 수 있는 환경이 된다.


> 분산 시스템에서 **신뢰할 수 있는(highly reliable)** 은 일부 장애가 발생하더라도 시스템은 동작하여 항상 신뢰하여 사용할 수 있는 환경을 말한다.

<br>

복제 상태 머신은 다음의 속성을 만족해야 한다.

+ **안정성** | non-Byzantine 조건에서 안정성을 갖춰야 한다. (네트워크 딜레이, 분할, 패킷 손실, 중복 전송 등)

+ **가용성** | 다수의 서버가 동작할 수 있고 서로 통신이 가능한 상황이라면 모든 기능은 동작해야한다.

  따라서 5개의 cluster 로 구성되어 있으면 최대 2개의 장애 허용성을 가진다.

  각 서버는 일시적인 중단인 것으로 여겨지며 나중에 복구된다. ( cluster 탈퇴와 장애는 다르다 )

+ log의 일관성을 맞추기 위해 타이밍에 의존하지 말아야 한다. ( 고장난 시계와 급격한 메시지 지연은 가용성 문제를 일으킬 수 있다 )

+ 다수의 cluster 가 하나의 라운드에서 응답 했다면 바로 성공할 수 있어야 한다. 소수의 느린 서버가 전체 시스템 성능에 영향을 미치면 안된다.

<br>

이해하기 쉬운 consensus 만들기

앞서 말했듯, Raft 는 기존에 이해하기 어려웠던 Paxos 를 대체하기 위해 만들어졌다. 

컴퓨터 공학에서는 복잡한 문제를 쉬운 작은 문제로 쪼개서 해결하는 분할/정복 이라는 개념이 존재하는데 Raft 도 이 개념을 이용한다. 

Raft 는 합의 알고리즘을 크게 **(1) leader  선출, (2) log 복제, (3) 안정성 보장** 이라는 3가지 문제로 나눠서 해결하고 이를 하나의 consensus module 로 만들기로 한다.

---

### leader  선출 ( Leader Election )

![image](https://github.com/lielocks/WIL/assets/107406265/652e4d3d-9c1a-4c1e-9c0b-95c56644f3e7)

> *각 노드는 follower, 후보, leader  세 가지 중 하나의 상태를 가진다.*

노드는 한 순간에 하나의 상태만을 가진다. 

노드는 내부적으로 임기(Term) 제도를 운영하고 있다. 

3대, 4대 대통령으로 부르듯이 임기도 1씩 증가하며 매 임기마다 하나의 leader 를 선출한다.

+ **리더 ( Leader )** | 정상적인 상황에서는 cluster는 **`하나의 leader `** 와 **`N-1 개의 follower`** 로 구성된다.

  leader 는 클라이언트의 모든 요청을 수신 받으며 로컬에 log를 적재하고 모든 follower 에게 전달한다.

+ **팔로워 ( follower  )** | follower 는 클라어인트로 받은 요청을 leader 로 리다이렉트 하고, leader 의 요청은 수신하여 처리하는 수동적인 역할만 한다.

+ **후보 ( Candidate )** | 새로운 leader 를 선출하기 위해 후보가 된 상태이다.

<br>

leader  node 는 주기적으로 heartbeat 메시지를 node 로 전파하는데, follower node 가 임의의 시간 동안 leader 로부터 메시지를 받지 못하면 연결에 문제가 있는 것으로 간주하고 아래 두 가지 행동을 한다.

1. 저장된 임기 번호를 1 증가 하고 즉시, 새로운 선거를 진행한다.

2. 본인이 스스로 후보가 되어 자신에게 투표를 하고 다른 node 들에게 투표 요청 RequestVote 메시지를 보낸다.

<br>

임기의 시작은 선거와 함께 시작한다. 

*스스로 후보*가 되어 선거를 시작하는 경우 발생하는 경우는 3가지이다. 

① 과반수의 투표를 받아 당선되거나 

② 다른 node 가 leader 가 되는 경우 그리고, 

③ 승자가 없이 투표가 종료되는 경우이다. 

② 의 경우는, 본인이 제출한 임기(Term) 번호보다 높은 번호로 당선된 leader 가 있으면 후보에서 follower 로 상태를 변경하고 leader 로 등록한다. 

③ 은 운이 없게도 모든 노드가 스스로에게 셀프 투표하고 모든 노드에게 전파하는 경우 투표가 동률로 결렬되는 경우이다.

<br>

**랜덤 타임아웃 제도**

Raft 에서는 ③의 경우가 적게 발생하도록, 선거의 타임아웃을 150–300ms 사이로 node 마다 랜덤하게 할당한다. 

저자들은 원래 초기에 node 별로 우선순위를 두는 랭킹 시스템을 생각했었는데 이것 저것 해본 결과 랜덤 타임아웃 제도가 제일 설계가 쉬웠다고 한다.

<br>

### log 복제 ( Log Replication )

Raft 에서 log는 **위치 값, 임기 번호, 상태 변경 명령** 세 가지로 구성된 **`엔트리(Entry) 의 집합`** 이다. 

아래 [그림 4] 에서는 각 node 별로 저장하는 복제 log 정보가 나타난다. 

동일한 index 와 임기 번호가 같다면 같은 명령을 저장해야 하고, 이전에 저장된 모든 log가 동일함을 보장한다.

![image](https://github.com/lielocks/WIL/assets/107406265/7e9092f4-8f85-4dc8-8fa3-bdd150a143ac)

> *[그림 4] Raft에서 각 노드가 저장하는 log*

**commit   엔트리 (committed entries)**

[그림 4]를 보면, commit 엔트리의 index 값이 7인 것을 알 수 있다. 

log 엔트리는 leader 가 생성하고, 과반수 이상의 서버에 복제되면 commit 된 것으로 간주한다. 

commit  할 때는 이전에 생성한 모든 log 까지 한꺼번에 commit 한다. 

한 번 commit 된 엔트리는 이후의 다음 임기의 leader 들에게 반드시 포함될 것을 보장하는데, 이를 **Leader Completeness** 라고 부른다.

<br>

실용적으로는, commit 된 엔트리만이 상태 머신에서 이행되며 상태를 변경한다. 

즉, Raft 에서는 전체 cluster에 걸쳐서 동일한 index 에는 동일한 log 명령어만이 상태 머신에서 실행됨을 보장해야 한다.

<br>

**log 매칭 (Log Matching Property)**

만약 두 log 가 동일한 index 와 동일한 임기 번호를 가진다면 해당 index 까지의 모든 엔트리가 동일함을 보장하는 속성을 log 매칭이라고 한다. 

leader 는 새로운 엔트리를 다른 서버로 전파할 때 **`AppendEntries RPC`** 를 호출하는데 이 때 인자값으로 바로 이전 log의 index 와 임기번호, 그리고 leader 의 commit   index 를 같이 넘긴다.

<br>

이를 통해 일관성을 확인할 수 있는데, 만약 요청을 수신받은 follower 가 본인의 log 에서 index 와 임기번호가 일치하는 엔트리가 없으면 요청을 거부한다.

만약 일치하는게 있다면 성공 메시지를 리턴하는데, 성공 메시지를 받은 leader  입장에서는 본인의 log와 follower 의 log가 일치함을 알 수 있다.

이 과정은 연역되기 때문에 0 번 index 부터 시작해서 N 번째 까지 반복하면 메시지가 동일함을 알 수 있다.

> leader 는 한 index 에 최대 한 번의 엔트리만 추가하고, 한 임기에는 한 명의 leader 만 존재하는 속성을 생각하면 굳이 메시지의 내용을 확인하지 않고도 메시지가 동일함이 보장된다.

![image](https://github.com/lielocks/WIL/assets/107406265/62a6e97c-a901-4d68-b891-32ecf7ce59b4)

> *[그림 5] log는 다양한 상황에서 불일치 할 수 있다.*


**log의 일치성**

<br>

각 서버의 log는 다양한 상황 때문에 불일치 할 수 있다. 

현재 leader 는 임기 번호 8번으로 log index 가 11인 상황이다. 

(a)-(b)는 단순히 log가 아직 복제가 안된 상황이며, (c)-(d)는 commit 이 안된 추가 메시지가 존재하는 상황이다. 

(e)-(f)는 log가 유실되었으며, 추가 메시지 둘 다 가지고 있는 상황이다. 

(f)의 경우를 조금 더 보자면, 본인이 임기 3번에 leader 가 되었으나 log를 하나도 복제하지 못하고 다른 서버와 연결이 유실된 경우라고 볼 수 있다. 

그래서 (a)-(e)까지의 노드의 log 엔트리가 임기 1에서 임기 4로 건너뛴 상황이다.

<br>

이 상황에서 Raft는 follower 의 log를 leader 의 log로 덮어 씌우는 것으로 문제를 해결하는데, 특정 제약 조건이 붙으면 이 상황이 더 안전하다고 한다. 

이는 안정성 항목에서 좀 더 자세히 다룬다. 

follower 의 상태를 맞추기 위해 leader 는 follower 와 동일한 log를 가진 index 를 찾아서 이후 index 의 log 를 follower 에서 모두 제거한 후 자신의 log 를 복제한다.

<br>

이 동작은 **`AppendEntries RPC`** 를 통해 이루어지는데, 이는 **하나의 log만을** 추가한다. 

leader 는 모든 follower 에 대해 nextEntry index 를 내부적으로 저장하고 있는데, 당선되는 경우에는 본인 log 의 최신 index 를 값으로 가지고 있다가 AppendEntries RPC 를 보내본다. 

만약 실패한다면 이 값을 1씩 감소 시켜서 성공할 때 까지 반복한다.

> 만약, follower 의 log index 가 3이고 현재 leader 의 index 가 100이라면 성공하는 RPC 호출을 찾기위해 97번을 호출해야 한다.
>
> 저자들은 이 상황을 최적화 할 수 있는 방법이 있다고만 논문에서 말했는데, 필자가 생각해보면 이분 탐색을 하면 호출 회수를 log로 줄일 수 있다.
>
> 저자들이 생각한 방법을 알고 싶다면 확장 버전(extended)의 논문을 참고 하면 된다.

<br>

**안정성 ( Safety )**

이전 장에서 Raft 의 기본 동작 방식에 대해서 설명하였는데, 사실 이것만 가지고는 충분하지 않다. 

follower 가 leader 가 commit 한 메시지를 수신받지 못하고 본인이 leader 가 되어서 메시지를 덮어 씌우는 상황이 연출되어서 각 서버의 상태 머신이 서로 다른 메시지를 이행할 수 있다. 

안정성 항목에서는 이런 상황을 방지하기 위해 취해지는 여러 방법을 소개한다.

<br>

**선거 제약 (Election Restriction)**

모든 합의 알고리즘에서 leader 는 최종적으로 모든 commit 된 log를 저장해야 한다. 

일부 합의 알고리즘은 commit 된 log 를 가지고 있지 않아도 leader 로 선출될 수 있기 때문에 follower 들이 commit log 를 leader 로 전송해주는 추가 적인 매커니즘이 필요하다. 

Raft 는 이런 방식이 추가적인 복잡성을 야기한다고 해서 쉬운 방법을 택한다.

<br>

우선, 후보 node 가 당선되기 위해서는 cluster 내 다수의 node 에게 연락해야 한다. 

이는 연락한 node 들 중 다수는 반드시 commit 된 log를 가지고 있음을 의미한다. 

투표 요청(Request Vote) RPC 에는 후보의 log 가 인자값으로 존재하는데, 투표자는 본인의 임기 번호가 더 높거나, log index 가 더 큰 경우 해당 투표 요청을 거부한다. 

따라서, 모든 당선된 leader 는 반드시 commit 된 log 를 가지고 있음을 보장된다.

<br>

**commit 규칙 ( Commit Rules )**

Raft 에서는 이전 임기의 메시지가 단순히 과반수 이상 서버에 복제되었다고 commit 으로 간주하지 않고, ***반드시 현재 임기의 메시지가 복제되어야지만,*** commit 으로 간주한다. 

앞서, commit 은 상태 머신이 어떤 엔트리를 실행할 지 결정하는 값이기 때문에 중요하다고 설명했다.

![image](https://github.com/lielocks/WIL/assets/107406265/7fb68197-9fa9-43f6-a92c-276c8ffc4d6e)

> *[그림 6] 왜 leader 가 이전 메시지가 복제되었다고 해서 commit 으로 간주할 수 없는지 보여준다.*

위 [그림 6]은 leader 가 왜 이전 메시지가 다수에 복제되었다고 해서 commit 으로 간주할 수 없는지 보여준다.

천천히 따라가보자. 서술상 편의를 위해 임기번호 3번을 가진 엔트리를 (Term 3 E) 라고 표기하겠다.

+ (a) : S1이 leader 가 된 상황으로, (Term 2 E)를 S2에 복제했다.

+ (b) : S5가 leader 로 당선된 상황이다. 위 선거 제약에 따르면, S1, S2에 대해서는 거절 당했겠지만 S3,S4 그리고 본인에게 던진 투표 까지 해서 당선이 가능한 상황이다. 그리고 (Term 3 E)를 본인 log에 기록한다.

+ (c) : 다시 S1이 4대 leader 로 당선되면서 (Term 4 E)를 본인 log에 기록하고, 가지고 있던 과거 엔트리인 (Term 2 E)를 S3에 복제한 상황이다. 여기서 leader 는 (Term 2 E)가 과반수인 세 노드에 복제되었다고 해서 commit 할 수 있다고 간주할 수 없다.

+ (d) : S5의 임기 번호가 더 높기 때문에 (S2-S4)로부터 표를 받아 당선할 수 있으며 log 를 복제하면 이전 것을 덮어 씌우기 때문에 과거 임기 번호를 가진 log가 복제되었다고 commit 으로 간주할 수 없다.

+ (e) : 반대로, S1이 무난히 (Term 4 E)를 과반수에 복제한다면, S5는 당선할 수 없기 때문에 3번 index 까지 commit 해서 상태 머신을 수행할 수 있다.

> ![image](https://github.com/lielocks/WIL/assets/107406265/1d48a475-2e27-43ce-b669-4ea7b563ec8c)

<br>

### 멤버쉽 변경 (Membership Changes)

이전까지 모든 예시는, cluster 의 멤버가 정적인 상황을 가정했다면 이제는 Raft 에서 어떻게 멤버쉽을 변경하는지 알아보려고 한다. 

가장 단순한 방법은 모든 서버를 셧다운 시키고 서버를 추가한 다음, 실행하는 건데 이는 실용적으로 봤을 때는 쓸모가 없기 때문에 동적으로 멤버를 추가할 수 있어야 한다.

<br>

하지만, 분산 서버에서는 모든 설정을 한 순간에 변경할 수 없기 때문에 반드시 2명의 leader 가 선출되는 상황이 연출될 수 있다. 

아래 [그림 7]을 보면, 3개의 서버로 구성된 C_old cluster에서 5개의 서버로 구성된 cluster C_new 로 전환하는 과정이다. 

초록색은 과거의 설정 정보가 반영되는 시점을 나타내고 파랑색은 새로운 설정 정보가 반영되는 시점을 나타낸다. 

설정 정보가 반영되는 타이밍 때문에 과반 수를 판단하는 정보가 달라서 2명의 leader 가 선출될 수 있음을 보여준다.

![image](https://github.com/lielocks/WIL/assets/107406265/539f4f85-c48d-4770-b66b-1b336bcf77ef)

> *[그림 7] 3개의 서버에서 5개로 증가시키는 모습*

Raft 에서는 이 문제를 해결하기 위해, **스스로 결합 합의(join consensus)** 라고 부르는 방법을 사용한다. 

이 방법의 기본 아이디어는 서버 별로 새로운 설정 정보로 전환하기 까지 시간을 두는 것을 허용하는 것이다. 

방법론적으로는 새로운 설정 정보를 log 엔트리에 포함시키고 이것을 대다수 노드에 복제 되어 commit 되고 나서야 새로운 설정 정보를 활용한다. 

이런 결합 합의 방식에서는 아래 3가지 문제가 나타날 수 있다.

![image](https://github.com/lielocks/WIL/assets/107406265/95aa2312-a3fd-421a-9b5b-446b0c3f2e5f)

> *[그림 8] 설정 정보가 변경되는 과정, Dashed Line은 commit 되지 않은 정보를, 실선은 commit 된 정보를 나타낸다.*

1. 새롭게 참여한 서버가 아직 아무런 log도 저장하지 못한 상황, 만약 이 서버가 바로 투표에 참여하면 절대 leader 로 선출되지 못하기 때문에 가용하지 못하기 때문에 Raft에서는 설정 변경 전에 투표권이 없는(Non-Voting) 멤버로 참여시켜서 먼저 동기화가 완료하고 결합 합의를 진행한다.

2. 현재 leader 가 새로운 설정 정보에는 포함되어 있지 않은 경우이다.

   이 경우에 leader 는 본인이 C_new 설정 정보가 담긴 엔트리를 commit 한 경우 스스로 follower 상태로 변경하고 사임한다.

3. 새로운 설정에선 삭제된 멤버가 cluster를 망칠 수 있다는 이슈가 있다.

   우선 새 집단에서 제외 되었기 때문에 heartbeat 메시지를 수신 받지 않는다.

   따라서, 스스로 후보 상태로 변경해서 선거를 진행하려고 하기 때문에 현재 leader 가 follower 상태로 변경될 수 있다.

   Raft에서는 단순히 cluster 내 노드들이 현재 자신이 leader 가 존재한다고 믿는 상태라면 투표를 거부하여 이 문제를 해결한다.

<br>

### 결론

Raft 논문에서는 성능 항목은 간략하게 나타나 있어서 잠깐 소개하고 마무리하고자 한다. 

우선, 성능과 관련된 항목은 새로운 leader 가 선출되기 까지 leader 가 없이 대기하는 시간이 얼마나 짧은지를 선거 타임 아웃 시간 파라미터마다 보여준다. 

저자들은 선거 상황 자체를 가혹하게 만들기 위해 일부러 log를 다르게 저장해서 일부 노드는 선거에서 의도적으로 패배할 수 밖에 없게 설정해 두었다.

![image](https://github.com/lielocks/WIL/assets/107406265/ad08c6ce-08e6-42c4-9a8a-8197015a7a3b)

> *[그림 9] Leader가 다운되었음을 인지하고 교체하는데 까지 걸리는 시간, 각 설정마다 1000번씩 시뮬레이션을 실행하고 점을 그래프상에 찍었다.*

[그림 9]에서 위 그래프는 랜덤으로 설정되는 타임아웃 시간 범위가 짧은 경우이다. 

예를 들어, 고정된 타임아웃 시간을 가진 150–150ms 의 경우 투표가 결렬되는 경우가 많아 10초 이상까지 leader 가 존재하지 않는 상황이 나타난다. 

아래 그래프가 논문의 저자들이 주장하고 싶었던 근거가 될 것 같은데 랜덤 타임아웃의 범위가 클 수록 투표가 분할되지 않고 안정적으로 leader 를 빠르게 선출할 수 있음을 보여준다.
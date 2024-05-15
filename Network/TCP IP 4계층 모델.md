# TCP / IP 개념 정리 (선수 지식)

### IP (인터넷 프로토콜)

+ 지정한 IP 주소에 데이터의 조각들을 패킷(Packet) 이라는 통신 단위로 최대한 **빨리 목적지로 보내는 역할**

+ 조각들의 순서가 뒤바뀌거나 일부가 누락되더라도 크게 상관하지 않고 보내는데 집중을 한다.

+ 그래서 IP 프로토콜은 packet 의 순서 보장도 할 수 없고 packet 이 중간에 유실되어도 이에 대한 방안이 없다.


<br>


## TCP (전송 제어 프로토콜)

![image](https://github.com/lielocks/WIL/assets/107406265/9f7d4683-9c14-44fb-a701-f106739d66fb)

+ Packet 데이터의 전달을 보증하고 **보낸 순서대로** 받게 해준다.

+ 도착한 조각을 점검하여 줄을 세우고 망가졌거나 빠진 조각을 다시 요청하는 식으로 순서를 보증.

+ TCP 는 데이터를 상대방에게 확실하게 보내기 위해서 **`3 way Handshaking`** 이라는 방법을 사용하고 있다.

  이 방법은 packet 을 보내고 잘 보내졌는지 여부를 상대에게 확인하러 간다.

+ 한마디로 TCP 는 IP 의 문제를 보완해주는 녀석


<br>


### TCP 3 way handshake

본격적으로 상대 client 와 연결되기 전에 **가상 연결** 을 해서 packet 으로 보내서 확인하는 동작이다.

+ **`SYN`** : 접속 요청

+ **`ACK`** : 요청 수락


<br>


![image](https://github.com/lielocks/WIL/assets/107406265/f0e3f938-4e25-459f-8512-e69de5b46996)

1. **`Client -> Server`** : SYN packet 전송

2. **`Server -> Client`** : SYN + ACK packet 전송

3. **`Client -> Server`** : ACK + 데이터 packet 전송

4. 데이터 packet 전송


<br>


### TCP 순서 보장 방법

1. Client 에서 packet 1, packet 2, packet 3 순서로 전송

2. Server 에서 packet 1, packet 3, packet 2 순서로 받음

3. Server 에서 packet 2번 부터 다시 보내라고 Client 에게 요청 (TCP 기본 동작)

![image](https://github.com/lielocks/WIL/assets/107406265/5a12268e-cafa-45d4-9b65-d63154eb398c)


> **TIP**
>
> 이렇게 **packet 을 순서대로 제어할 수 있는 이유** 는 **TCP 데이터 안에** **`전송 제어, 순서, 정보들`** 이 있기 때문이다.
>
> 그래서 TCP 는 신뢰할 수 있는 protocol 이라고 얘기한다.


<br>


## UDP (사용자 데이터그램 프로토콜)

+ **비연결지향적** 프로토콜

+ 데이터 전달 보증 X

+ 순서 보장 X

+ TCP 에 비교해서 기능이 거의 없어 단순하지만 **오로지 빠르게 packet 을 보내는** 목적

+ **IP 와 거의 같다** 고 보면 된다. **`PORT` 와 `CheckSum(메세지 검증해주는 데이터)` 정도만 추가된** 형태이다.

+ IP 에 기능이 거의 추가되지 않은 하얀 도화지 같은 상태이기 때문에 최적화 및 커스터마이징이 용이하다.

![image](https://github.com/lielocks/WIL/assets/107406265/39e787e0-fdf3-4687-8351-d1f45a3321ad)


<br>


### TCP vs UDP 비교표

|TCP|UDP|
|:---:|:---:|
|연결지향형 프로토콜|비 연결지향형 프로토콜|
|Byte Stream 을 통한 연결|Message Stream 을 통한 연결|
|혼잡제어, 흐름제어|혼잡제어와 흐름제어 지원 X|
|순서 보장, 상대적으로 느림|순서 보장되지 않음, 상대적으로 빠름|
|신뢰성 있는 데이터 전송 - 안정적|데이터 전송 보장 X|
|Segment TCP packet|Datagram UDP packet|
|HTTP, Email, File transfer 에 사용|도메인, 실시간 동영상 서비스에서 사용|


<br>


## TCP / IP 4계층

**4층- 어플리케이션 계층** - **`HTTP, FTP, DNS, SMTP`**

**3층- 전송 계층** - **`TCP, UDP`**

**2층- 인터넷 계층** - **`IP`**

**1층- 네트워크 엑세스 계층** - **`Ethernet 이더넷`**

![image](https://github.com/lielocks/WIL/assets/107406265/664ea329-0c6b-4ef1-9973-46518dbf6afb)


<br>


### TCP / IP 4계층 종류

![image](https://github.com/lielocks/WIL/assets/107406265/e2423348-9a62-4f38-814f-9d6f9006de92)

**1. Network Layer (OSI 7계층에서 물리 + 데이터링크 계층)**

+ 이 계층은 Node-To-Node 간의 신뢰성 있는 데이터 전송을 담당하는 계층이다.

+ OSI 7 계층의 **물리 계층과 데이터링크 계층** 의 역할을 바로 이 계층이 담당하는 것으로 볼 수 있다.

+ 알맞은 하드웨어로 데이터가 전달되도록 MAC 주소를 핸들링 하는것 뿐 아니라, 데이터 packet 을 전기신호로 변환하여 선로를 통하여 전달할 수 있게 준비 해준다.

![image](https://github.com/lielocks/WIL/assets/107406265/a93180c7-055d-4bf7-857f-f3cc9a510e80)


<br>


**2. Internet Layer (OSI 7계층에서 네트워크 계층)**

+ **IP** 를 담당하는 계층

+ IP 를 사용하여 데이터의 원천지(origin) 와 목적지(destination) 에 관한 정보를 첨부한다.

+ IP 는 복잡한 네트워크 망을 통하여 가장 효율적인 방법으로 데이터의 작으 조각들을 빨리 보내는 일을 한다.

+ 따라서 IP 는 packet 전달 여부를 보증하지 않고, **경로를 설정하여 어떻게든 빨리 보내도록** 한다.

|Protocol|Content|
|---|---|
|IP|비연결의 서비스를 제공하며, 발신지와 목적지까지의 routing 경로를 설정|
|ICMP|IP 제어와 메세지 기능을 담당|
|ARP|IP 주소를 이용해 상대방의 MAC 주소를 알아오는 프로토콜(Broadcast 요청, Unicast 응답)|
|RARP|MAC 주소에 해당하는 IP 주소를 알아오는 프로토콜(Broadcast 요청, Unicast 응답)|


<br>


**3. Transport Layer (OSI 7계층에서 전송 계층)**

+ **TCP / UDP** 를 담당하는 계층

+ TCP 는 IP 위에서 동작하는 프로토콜로, **데이터의 전달을 보증** 하고 보낸 순서대로 받게 해준다.

+ 즉, 순서가 맞지 않거나 빠진 부분을 점검하여 다시 요청하는 일을 담당

|Protocol|Content|
|---|---|
|TCP(Transmission Control Protocol)|**연결 지향적(Connection Oriented)** <br> 신뢰적, 흐름제어, 에러제어 (순서번호, ACK 번호 사용) <br> ACK 받지 못한 모든 데이터는 재전송 <br> 장점은 보장된 Segment 로 전달하기에 신뢰성 있다 <br> 단점은 연결을 위한 초기 설정 시간이 걸린다|
|UDP(User Datagram Protocol)|**비연결 지향적(Connectionless Oriented)** <br> 비신뢰적, 데이터를 보낸 후에 잘 도착했는지 검사하는 기능이 없다 <br> 장점은 빠르며, 연결을 맺지 않으므로 제어 프레임 전송을 할 필요가 없기에 네트워크 부하를 줄일 수 있다 <br> 신뢰성보다는 고속성을 요구하는 MultiMedia 응용 등에 일부 사용되고 있다|


<br>


**4. Application Layer (OSI 7 계층에서 5, 6, 7 계층)**

+ **HTTP / FTP** 를 담당하는 계층

+ OSI 7 계층의 5계층부터 7계층까지의 기능을 담당하고 있다.

+ Server 나 Client 응용 프로그램이 이 계층에서 동작한다.

+ 우리가 알고 있는 브라우저나 telnet 같은 서비스가 이 계층에 동작


|Protocol|Content|
|---|---|
|DNS(Domain Name Server)|인터넷에서 사용하는 이름을 해당 IP 주소로 변화해주는 서비스
|SNMP(Simple Network Management Protocol)|네트워크 장비를 모니터링하고 제어하는 프로토콜|
|FTP(File Transfer Protocol)|TCP 환경에서 파일 전송 프로토콜|
|TFTP(Trival File Transfer Protocol)|UDP 환경에서 파일 전송 프로토콜|
|HTTP(Hypertext Transfer Protocol)|Web 상에서 정보를 주고받을 수 있는 프로토콜|


<br>



## TCP / IP 4계층 동작 순서

![image](https://github.com/lielocks/WIL/assets/107406265/791ac3a5-deda-443d-828a-29fc15d5b645)

1. 송신측 client 의 애플리케이션 계층에서 어느 웹 페이지를 보고 싶다라는 HTTP 요청을 지시한다.

2. 그 다음에 있는 트랜스포트 계층에서는 애플리케이션 계층에서 받은 데이터(HTTP 메시지)를 통신하기 쉽게 조각내어 **안내 번호와 port 번호(TCP 패킷)를 붙여 네트워크 계층에 전달** 한다.

3. 네트워크 계층에서 데이터에 IP packet 을 추가해서 링크 계층에 전달한다.

4. 링크 계층에서는 **수신지 MAC 주소와 이더넷 프레임** 을 추가한다. 

5. 이로써 네트워크를 통해 송신할 준비가 되었다.

6. 수신측 서버는 링크 계층에서 데이터를 받아들여 순서대로 위의 계층에 전달하여 애플리케이션 계층까지 도달한다.

7. 수신측 애플리케이션 계층에 도달하게 되면 클라이언트가 발신했던 **HTTP 리퀘스트를 수신** 할 수 있다.

> **TIP**
>
> 현재 OSI 7계층보다는 TCP/IP 4계층이 더 많이 활용되고 있다.
>
> OSI 7계층은 이론적인 느낌이라면 TCP / IP 4계층은 이론을 **실제로** 사용한다는 느낌이다.


<br>


**네이버 접속 시나리오**

1. 웹 브라우저에 `www.naver.com` 입력.

2. **DNS로** 네이버 Server **`IP 주소 할당`**

3. 응용 계층(L4)에서 메세지 데이터 패킹(HTTP 메시지)

4. 전송 계층(L3)에서 **PORT 정보(출발지, 목적지), 전송제어 정보, 순서 정보, 검증 정보 패킹 (TCP)**

5. 인터넷 계층(L2)에서 **IP 정보(출발지, 목적지) 패킹**
   
6. 네트워크 엑세스(L1) 계층에서 **MAC 주소 패킹**

7. 게이트웨이를 통해 인터넷망 접속

8. Router 를 통해 목적지(네이버 서버)를 찾아 연결

9. 네이버 서버에 도착하면 packet 을 하나 하나 까면서 목적 port 에 메세지 데이터 전달하여 다시 응답


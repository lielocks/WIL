# TCP / IP 프로토콜 계층 ~ 네트워크 계층에서 주로 쓰이는 프로토콜 알아보자 !

![image](https://github.com/lielocks/WIL/assets/107406265/0e089b0e-b133-4fed-913b-37f18e0544bd)


<br>


## IP란 ? (Internet Protocol)

네트워크 상에서 컴퓨터는 다른 컴퓨터와 구별될 수 있도록 고유번호를 가진다.

이것은 인터넷에 접속할 때 컴퓨터 각각에 부여 받는 주소 or 전화번호와 같다.

+ 네트워크 계층에 속하는 프로토콜

+ **실제 packet 을 전달하는 역할** 을 한다.


</br>

### IP 헤더란 ?

IP packet 의 앞부분에서 **주소 등 각종 제어 정보** 를 담고 있는 부분이다.

</br>


### IPV4 헤더 구성 ( IP Header Format )

![image](https://github.com/lielocks/WIL/assets/107406265/c8f3a77b-c977-4458-acf1-e8f599771ca6)

![image](https://github.com/lielocks/WIL/assets/107406265/e3eed27a-3bdb-4b7a-b38c-e20e4022f9ea)

IP 헤더는 IP 패킷의 앞부분에 위치하며 IP 주소를 비롯한 각종 제어정보를 담고 있다. 

IPv4 헤더는 고정 부분 20바이트와 가변 부분 0~40바이트로 구성되어 있다. 

옵션을 지정하지 않았을 때의 *최소 크기는 20 바이트* 이다.

</br>

**Header Length**

헤더 길이는 **4 바이트** 를 기본 단위로 헤더의 길이를 규정하는 영역이다.

`IPv4 에서는 header length 가 가변` 이므로 이를 규정하는 영역이 필요하다.

기본값은 5 로서, 최소 크기는 20 바이트이고, 옵션 영역을 사용하면 60 바이트까지 확장 가능하다.


</br>


**DS**

DS(Differentiated Service, 차등 서비스) 는 IP packet 전송 시 우선순위와 혼잡 알림을 위한 **8 비트** 의 영역이다. 

**`앞의 6 비트`** 는 *요구되는 서비스 질에 따른 차등 서비스를 나타내는 DS 필드* 로 사용되고, **`뒤의 2 비트`** 는 *혼잡 정도를 알리는 ECN(Explicit Congestion Notification) 필드* 로 사용된다. 

DS 필드에는 서비스 품질 유형을 나타내는 DSCP(Differentiated Service Code Point) 값이 들어간다.

</br>


**Total Length 전체 길이**

전체 길이(Total Length)는 **헤더와 데이터를 합한 IP packet total length 를 `byte` 단위로 나타낸다.** 

최댓값은 65,535 바이트 이다.


<br>


**Flags**

플래그(Flags)는 packet 의 분할 여부에 대한 정보를 나타내는 **3 비트** 의 영역이다. 

**첫 번째 비트** 는 예비용을 항상 **`0`** 으로 설정하며, **두 번째 비트** 는 **`DF(Don't Fragment)`** , **세 번째 비트** 는 **`MF(More Fragment)`** 이다. 

**`DF`** 는 *데이터를 단편화할 것인지 판단* 하는 역할을 하며, **`0`** 이면 분할이 **가능** 하고 **`1`** 이면 분할하지 **말라** 는 의미이다. 

**`MF`** 는 단편이 더 있는지 판단하는 역할을 하며, **`0`** 이면 **마지막 단편** 이라는 뜻이고 **`1`** 이면 **아직 수신되지 않은 단편이 있다** 는 의미이다.


</br>


**Fragment Offset**

단편 오프셋(Fragment Offset) 은 **분할된 packet 을 재조립할 수 있도록 원래 위치를 알려주는 영역** 으로, 

**`byte 를 8로 나눈 값`** 을 사용한다.


</br>


**TOS ( Type Of Service )**

인터넷에 제공되는 QOS 기능을 위한 *서비스 형식 필드* ( 요구되는 서비스 품질을 나타냄 )


</br>


**Identification**

식별자(Identification)는 **IP packet 을 식별하기 위해** 사용된다. 

이 영역의 값을 참조하면 *어느 원본 packet 으로부터 분할되었는지* 를 알 수 있다.

***Datagram 의 조각을 구분하기 위해 사용되는 필드***


</br>


**TTL ( Time To Live )**

`IP packet 수명`

*수신지에 도착하지 못한 packet 이 network 에 남으면 결과적으로 network 의 자원을 심각하게 잠식할 수 있다.*

TTL(Time to Live, 패킷 수명) 은 이를 **방지** 하는 옵션으로, **router 를 지날 때마다 `TTL 값을 하나씩 감소` 시키고 `값이 0 이 된 packet 을 받으면 폐기` 하도록 한다.**


폐기된 packet 을 수신하면 전송지에 이를 알리는 메시지를 보낸다.

<br>

**IP Option**

부가적인 서비스 식별을 위한 필드

</br>

**Protocol Identifier**

어느 *상위계층 protocol* 이 **데이터 내에 포함되었는가** 를 보여줌

( ICMP -> 1 / IGMP -> 2 / TCP -> 6 / EGP -> 8 / UDP -> 17 / OSPF -> 89 등 )


</br>


**Total Packet Length**

IP header 및 데이터를 포함한 ( **IP packet 전체의 길이를 byte 단위로 길이를 표시한 최댓값** : **`2의 16승 -1`** )


</br>


**Header Checksum**

Header Checksum 은 **network 를 통해 packet 이 전송될 때 발생한 오류를 검출** 하기 위해 사용되는 영역이다.

데이터 전체가 아닌 **헤드의 오류만** 검출하며, 오류가 검출되면 복구하지 않고 폐기한다.

Header 를 2 byte 씩 무두 잘라 더하고, 발생한 올림 영역까지 더한 후 1의 보수 연산을 수행해 계산한다.


</br>


**Source Address 전송지 주소**

전송지 주소(Source Address)는 **packet 을 전송하는 host 의 주소** 를 나타내는 영역이다.

</br>


**Destination Address 수신지 주소**

수신지 주소(Destination Address)는 **packet 을 수신하는 host 의 주소** 를 나타내는 영역이다.


</br>


### IPv4 의 문제점

+ IP 주소 부족 문제

+ 취약한 인터넷 보안

<br>


### IPv6 의 등장

1. IP 주소 공간의 크기를 32비트에서 **`128비트`** 로 증가

2. 주소 부족 문제를 근본적으로 해결

3. 주소 공간의 확장으로 인해 하나의 주소를 **`여러 계층`** 으로 나누어 다양한 방법으로 사용 가능

4. IPv4 에는 없던 *보안 기능* 이 추가됨
   + 인증 절차, 데이터 무결성 보호, 선택적인 메시지 발신자 확인 기능 지원
  
5. *종단간 암호화 기능* 을 지원하기 때문에 패킷에 대한 변조 방지

6. 자동 주소 설정
   + 자동으로 로컬 IPv6 주소를 생성. 라우터가 제공하는 네트워크 프리픽스 정보와 MAC 주소를 사용


<br>


### IPv6 헤더 구성 ( IP Header Format )

![image](https://github.com/lielocks/WIL/assets/107406265/fc5cadd3-2899-4440-bebf-20bc25935cbd)


+ **IPv6 기본 헤더**

  - 확장 헤더를 포함하지 않은 경우의 기본 헤더 (40 bytes)


+ **IPv6 확장 헤더**                                       

  - 기본 고정 header 뒤 payload 내에 선택적인 확장 header 들이 뒤따라옴


<br>


### IPv6 기본헤더(Basic Header) 필드 (8개)

+ **Version  (4 비트)**
     
  - **IPv4** 이면 **`4 (0100)`** , **IPv6** 이면 **`6 (0110)`**   


<br>


+ **Traffic Class 또는 Priority (8 비트)**
  
   + ***IPv4 일때의 TOS 필드*** 와 유사
    
      + IP packet 마다 서로 다른 서비스 요구사항을 구분하기 위함
    
      + 따라서, 민감한 실시간 응용 및 긴급하지 않은 데이터 packet 간의 차별적 구분 가능


<br>


 + **Flow Label (20 비트)**
   
  - IP 를 **연결지향적 프로토콜** 로 사용할 수 있게 함

       . 실시간 서비스 등 같이 우선권을 주기위하여 특정 트래픽 Flow 에 대한 라벨링

<br>


+ **Payload length (16 비트)**
  
   - Payload 부의 Length (확장헤더 + 상위계층 데이터) < 216(65536) 까지 가능


<br>


+ **Next header (8 비트) IPv6 확장헤더 참조**
   
   - 기본헤더 다음에 위치하는 확장 헤더의 종류를 표시

        . IPv4의 protocol 번호와 같은 역할


<br>


+ **Hop limit (8 비트)**
    
  - **`IPv4 의 TTL`** 과 같은 역할


<br>


+ **Source address (128 비트)**
     
     - 발신처 주소


+ **Destination address (128 비트)**
     
     - 목적지 주소
     
        - 만일, 소스 라우팅일 경우에 다음 router 주소를 나타냄


<br>


### IPv6 패킷 구성

+ **기본 헤더** : packet 의 기본적인 정보와 송수신 주소 등, 전송에 필수적인 정보로 구성

+ **확장 헤더 (Extension Header)** : 추가적인 전송 기능이 필요할때 사용됨

+ **데이터 필드** : Ip 상위 protocol 에서 사용하는 부분. *TCP segment 나 UDP datagram 등이 될 수 있음*


<br>

  
### IPv4 IPv6 차이점

![image](https://github.com/lielocks/WIL/assets/107406265/d1271d64-35c1-4a40-a7bb-8b32c68e60b7)


<br>


## ARP (Address Reolution Protocol) : MAC 주소와 IP 주소의 연결고리

![image](https://github.com/lielocks/WIL/assets/107406265/d2cd2819-ac10-47e0-b1ef-29356e636ad9)


**ARP (Address Resolution Protocol - 주소 결정 프로토콜)**

![image](https://github.com/lielocks/WIL/assets/107406265/49e431f9-5883-4c02-ab0a-91863c70465d)

ARP는 Address Resolution Protocol의 약자로 **IP 주소를 MAC 주소와 매칭 시키기 위한 프로토콜** 입니다. 


<br>


ARP 를 사용하는 이유는 

*로컬 네트워크(LAN, Local Area Network) 에서 단말과 단말 간 통신* 을 하기 위해서는 **`IP 주소와 함께 MAC 주소를 이용`** 하게 되는데, 

**IP 주소** 를 **`MAC Address와 매칭하여 목적지 IP의 단말이 소유한 MAC 주소를 향해 제대로 찾아가기 위함`** 입니다. 


<br>



***왜 IP 주소를 MAC 주소로 매칭하여야 할까요?***

그 이유를 알기 위해서는 LAN(Local Address Network)과 MAC 주소에 대해 이 해해야 합니다. 
먼저 LAN(Local Address Network)와 MAC 주소에 대해 설명하고 ARP 를 정의하도록 하겠습니다!


<br>


### LAN (Local Address Network) 이란?

![image](https://github.com/lielocks/WIL/assets/107406265/65584cfb-fb15-430b-b966-8b7273f7006d)


<br>


위키백과에서 서술한 LAN(Local Address Network)의 정의입니다. 

사실 저렇게만 들어서는 LAN의 정의를 알기 어렵습니다. 

보통 네트워크를 정의할 때는 IP 주소와 Subnetmask를 이용하여 정의하기 마련인데 위의 정의는 꽤 추상적이군요. 

그렇지만 아무리 큰 규모의 네트워크일지라도 *같은 IP 대역을 공유한다면 그것은 근거리 네트워크* 이기 때문입니다.


<br>


오리뎅이님은 LAN의 정의를 **'ARP Request가 미치는 영역'** 이라고 말씀하셨습니다. 

**`ARP Request Packet`** 이 전달되기만 한다면 **LAN** 이라고 보는 것이죠. 

*같은 IP 대역을 공유 하는 LAN 에서 단말간 통신* 을 하기 위해, 

다시 말해 *Layer 2 에서의 통신에서 사용자는 IP 주소를 목적지로 지정하지만 `실제로는 MAC 주소를 이용`해 목적지를 찾습니다.*

이에 **`IP 주소와 MAC 주소를 매칭` 하기 위해 ARP 가 사용된다** 는 것을 의미합니다. 

아래 그림을 보시면 `중앙에 하나의 L2 Switch` 를 두고 *컴퓨터들을 연결하여 LAN 을 구성한 것* 을 볼 수 있습니다.


<br>


![image](https://github.com/lielocks/WIL/assets/107406265/ed71c02b-c7a2-45b4-bf73-196d9fe9c8fd)


<br>


위의 구성에서 PCO(192.168.1.1) 이 PC1(192.168.1.2) 와 통신을 하기 위해서 사용자는 목적지를 192.168.1.2로 잡지만 ,

실제 목적지는 PC1의 IP 주소와 함께 MAC 주소를 목적지로 지정하고 이를 활용하여 전달합니다.


<br>


### MAC 주소란 ?

MAC 주소란 말을 자주 들어보셨을거라 생각합니다. 

IP Address 와 늘 함께 언급되는 주소이지요. 

**DataLink 계층에서 통신을 위한 네트워크 인터페이스에 할당된 고유 식별자** 로 `Network Interface Card(NIC)` 를 가진 단말이라면 공장에서 출고될 때 부여되고 **평생** 사용하는 **`고유한 주소`** 를 의미합니다. 

> 즉 **LAN(Local Address Network) 에서 목적지와 통신하기 위한 실질적인 주소** 가 바로 **`MAC 주소`** 입니다.

![image](https://github.com/lielocks/WIL/assets/107406265/bc0e353c-e967-42e5-8275-6bff7a66a60b)


<br>


네트워크 장비 혹은 컴퓨터는 모두 MAC 주소를 갖습니다. 

좀 더 자세히 말하면 *네트워크 장비 혹은 컴퓨터가 갖는 Network Interface Card* 마다 **MAC 주소** 를 갖고 있지요.

그리고 위에서도 언급하였지만 LAN(Local Address Network, Layer 2) 에서는 **`IP 주소를 MAC 주소에 매칭`** 하여 통신합니다.


<br>


그런데 이렇게 생각할 수 있습니다. 

> ***통신하는데 IP 주소만 필요한 것 아닐까요?***
>
> ***왜 MAC 주소까지 필요한 것일까요?***
>
> ***거꾸로 MAC 주소가 고유하다면 그냥 인터넷에서 MAC 주소를 쓰면 되는거 아닐까요?***


<br>


### 왜 MAC 주소가 필요한가?

저는 대학생 시절 버스를 타고 학교와 집을 오고 갔습니다. 
그리고 그 버스는 내비게이션이 아닌 도로 표지판을 보고 서울에서 성남으로 향했지요. 
그 시절을 떠올리며 '서울 특별시 광진구 화양동 43'에서 '성남시 분당구 야탑동 24'으로 간다고 생각해보겠습니다.

![image](https://github.com/lielocks/WIL/assets/107406265/6e3005bd-d9c2-4437-afe7-fc18bd48a5e6)

화양동을 출발하여 남쪽으로 내려갑니다. 

도로 표지판을 보니 성남으로 가기 위해서는 잠실대교를 건너 송파구의 석촌동, 문정동을 지나면 문정동 옆에 복정동으로 향하는 도로가 있다고 합니다. 
그 길을 따라 갑니다. 
성남시 수정구 복정동에 도착하니 도로 표지판에 분당구 야탑동으로 가려면 중원구 성남동을 지나가야 한다고 하네요. 성남동을 지나 드디어 야탑동에 도착했습니다! 

그런데 말입니다... 야탑동 24가 어디죠...? 
막상 야탑동에 도착하니 야탑동 24가 어디인지 써있는 도로 표지판이 없습니다.


이런 경우 주변의 물리적인 지형지물을 통해 야탑동 24의 위치를 찾아낼 수 있습니다.
야탑동 24라는 곳이 친구 집이라면 친구에게 전화해 "한국전자부품연구원 위에 보면 야탑천이 시작되는 곳이 있는데 거기에 있어"라는 답변을 얻을 수 있을 겁니다.

**'야탑동 24'라는 행정적 주소는 제도에 따라 변할 수 있지만 '야탑천이 시작되는 곳'이라는 물리적인 주소는 결코 변하지 않습니다.**

`논리적 주소인 IP 주소`와 `물리적 주소인 MAC 주소`의 관계 또한 `행정적 주소`와 `물리적 주소`와 흐름이 같다고 볼 수 있습니다.

<br>

![image](https://github.com/lielocks/WIL/assets/107406265/e855e8e3-a511-4c69-bedc-c60d0615066c)


**IP 주소는 끊임없이 변화합니다.**

MAC 주소 체계가 없는 상황을 가정하고 IP 주소만 있는 상황에서 PC0 사용자가 자신의 IP를 192.168.1.2로 바꾼다면 PCO와 PC1 모두 192.168.1.2 IP를 갖게 될 것이고 원래 IP 192.168.1.2 주인이 누군지 알 길이 없게 됩니다. 

사람은 동명이인이라도 주민번호가 다르기 때문에 구별할 수 있지만요. 

고유한 정보인 MAC 주소 또한 웬만해서는 변하지 않습니다. 
그렇기에 MAC 주소를 사용하여 전달하는 것이 확실하기에 그런 것이 아닌가 싶습니다.

거꾸로 인터넷 상에서 IP 주소 없이 변화하지 않는 고유한 주소인 MAC 주소를 사용하여 라우팅을 한다면... 각 고유한 주소를 라우팅 테이블에 일일이 입력하다간 라우터가 다운되고 말겁니다. 
숫자가 매우 많아질테니까 말이죠. 
IP 주소는 연속성을 갖기 때문 에 IP 주소 다수를 한 줄로 지정해줄 수 있으니 편리하지요.

<br>

### 그렇다면 ARP란 무엇인가?

단말간 통신에서 양쪽 단말은 IP 를 이용하여 목적지를 지정하지만 실제 데이터 이동을 위해 **MAC 주소**를 함께 이용합니다. 

이를 위해 필요한 것이 바로 **Address Resolution Protocol(ARP)** 이며 **IP 주소와 MAC 주소를 일대일 매칭하여 LAN(Layer 2)에서 목적지를 제대로 찾아갈 수 있도록** 돕습니다. 

IP 주소와 MAC 주소를 일대일 대응하여 테이블로 정리하고 목적지 IP에 맞는 목적지 MAC 주소로 전달하지요. 

이것을 **ARP Table** 이라 부릅니다. 
**`IP 주소와 MAC 주소를 일대일 매칭시킨 정보를 정리해둔 Table`** 을 뜻합니다.

![image](https://github.com/lielocks/WIL/assets/107406265/5768a62b-1d9d-4bce-b467-82c2b3c54196)

위 그림을 보시면 PCO의 ARP Table에 다른 PC들의 IP 주소와 함께 MAC 주소가 일 대일 매칭되어 관리되고 있는 것을 보실 수 있습니다. 

사용자가 데이터를 보내기 위해 목적지 IP 주소를 지정한다면 PCO은 ARP Table에 있는 MAC 주소를 보고 해당 MAC 주소의 소유 PC로 전달하는 것이죠.

![image](https://github.com/lielocks/WIL/assets/107406265/c7b5973b-4042-4676-b576-69634a3b84db)

중간에서 데이터를 전달하는 스위치 또한 자신의 Port에 연결된 PC 들의 MAC 주소 정보를 갖고 있습니다. 

어느 Port에서 어느 PC의 MAC 주소가 올라오는지 알아야 PC에게서 전달받은 데이터를 전달할 때 목적지 MAC 주소를 올바르게 지정할 수 있기 때문이죠. 

참고로 위 스위치의 MAC Table은 PCO에서 PO 1,2,3으로 Ping 명령을 실시 한 후의 결과입니다. 

LAN 에서의 통신은 MAC 주소를 이용한다는 것을 알 수 있지요.


<br>


### ARP Table 생성 과정

이번에는 ARP Table의 생성 과정에 대해 알아보겠습니다. 

IP 주소와 MAC 주소가 구비되어있다 하더라도 다른 PC의 IP 주소와 MAC 주소를 모르면 데이터를 전달할 수 없겠죠. 

그래서 ARP Table을 생성하여 **다른 PC들에 대한 주소 정보를 확보** 하는 것이 필요합니다.

![image](https://github.com/lielocks/WIL/assets/107406265/45e554ae-2d68-420f-af56-c077de969d3d)

위의 그림을 토대로 순차적으로 설명하겠습니다. 

여기서 짚고 넘어가야 할 점은 PC 0, 1,2,3뿐만 아니라 *모든 단말들은 자신만의 Routing Table 이 있어* 자신이 보내려는 packet 의 목적지 IP가 자신이 소속된 IP 대역인지 아닌지 알 수 있다는 것입니다.

<br>

![image](https://github.com/lielocks/WIL/assets/107406265/b86d59d4-705e-4794-baa8-d9c10c0e937d)


이렇게 ARP 프로토콜을 이용하여 각 장비들은 서로의 MAC주소와 IP주소를 매칭시키는 작업을 하고 이를 ARP테이블에 기록해 둡니다.

![image](https://github.com/lielocks/WIL/assets/107406265/d704450d-2753-4d7b-b943-879fe0be8c79)


<br>


### ARP 패킷의 구조

![image](https://github.com/lielocks/WIL/assets/107406265/6d857b7f-6ef1-4bd6-ba8c-6f68ffb3840e)


ARP packet 의 구조입니다. 여러가지 알 수 없는 항목들이 많은데 우리는 이중에서 몇가지에만 집중할 것입니다.

**`ARP packet 의 목적`** 은 **내가 알고 있는 IP 주소의 MAC 주소를 찾는 것** 이라는 것을 꼭 기억해야 합니다. 각 항목들의 의미는 아래와 같습니다.


<br>


**1. 출발지 MAC 주소, 목적지 MAC 주소**

송신지 MAC주소는 AA(생략)인데 이거 모든 애들한테 전달해줘!

여기서 모든 애들한테 전달해줘라고 했기 때문에 목적지 MAC 주소에는 브로드캐스트 주소인 FF:FF:FF:FF:FF:FF로 채워지게 됩니다.


**2. 송신지 MAC 주소, 송신지 IP 주소**

야!! 나 MAC주소는 AA이고 IP주소는 1.1.1.1인데!!


**3. 수신지 MAC 주소, 수신지 IP 주소**

너 1.1.1.2 맞지?? 너 MAC 주소가 뭐지??

 

다른 항목들에 대해서는 우리가 다 외울 수 없을 뿐더러 정확히 위의 항목 3가지에 대해서 ARP가 저러한 의미를 담고 있구나라고 생각하시면 됩니다.


<br>


## RARP

**[ Reverse Address Resolution Protocol ]**

**`물리적 주소인 MAC Address`** 를 **`논리적 주소인 IP Address 로 변환`** 하는 **역주소변환 프로토콜** 이다.


<br>


**IP 호스트가 자신의 물리 네트워크 주소(MAC) 은 알지만** ***최초 자신의 논리적인 IP 주소를 모르는 경우,***

***서버로부터 IP 주소를 요청하기 위해*** **`자신의 MAC 정보를 담고 있는 RARP Request 메시지`** 를 만들어서 **broadcast** 함으로써 사용한다.

`해당 메시지를 수신한 RARP Server` 는 **`요청자의 MAC 주소에 대응하는 IP 주소 정보를 담은 RARP 응답(Reply) 메시지`** 를 만들어서 **요청자의 MAC 주소로 unicast** 방식으로 응답을 준다.

![image](https://github.com/lielocks/WIL/assets/107406265/222fb9e6-0b07-4eff-9b40-53e30d045900)

![image](https://github.com/lielocks/WIL/assets/107406265/dd57eed0-3fb6-42ff-9ff7-d52283592fa0)


<br>


## ICMP (Internet Control Message Protocol) 이란?

ICMP 는 인터넷 제어 메시지 프로토콜이다.

**오류 메세지를 전송받는데** 주로 쓰인다.


> [ 위키 정의 ]
>
> ICMP 메세지들은 일반적으로 IP 동작에서 진단이나 제어로 사용되거나 오류에 대한 응답으로 만들어진다.
>
> ICMP 오류들은 원래 packet 의 source IP 주소로 보내지게 된다.
>


<br>


### ICMP 의 용도는?

+ 인터넷 / 통신 상에서 발생한 일반적인 상황에 대한 보고 (report)

+ 인터넷 / 통신 상에서 발생한 오류에 대한 보고

+ 위험한 상황에 대한 경보


<br>


### ICMP 의 기능은?

+ IP 프로토콜을 이용하여 ICMP 메세지 전달

+ 네트워크 계층에 속하여 네트워크 관리 프로토콜의 역할 수행

  + 여기서 포인트는 종단간 데이터 수송 역할 X
 
<br>

![image](https://github.com/lielocks/WIL/assets/107406265/c1bfb3e7-85c4-4b3f-9cc1-5624b1b83ee1)

TCP/IP 계층에서의 ICMP가 어디에 속하는 지를 나타내는 그림입니다. 

기억해야 할 것은 ?!

**-> ICMP 프로토콜은 Network 계층에 속하며 IP 프로토콜과 같이 사용한다 !**

<br>

### ICMP 사용 명령어
1. Ping 명령어 : 상대방 호스트의 작동 여부 및 응답시간 측정하는데 사용

   + Echo Request : ICMP 질의메세지 요청

   + Echo Reply : ICMP 응답메세지 요청


3. Tracert 명령어 : 목적지까지의 라이팅 경로 추적을 하기 위해 사용

   + Time Exceeded 확인 가능

  
<br>


> **traceroute**
>
> 네트워크 경로를 조사하기 위한 명령이다 출발지에서 TTL 값을 1로 세팅해서 보낸다.
> 그러면 다음 라우터에서는 TTL 값이 0 이 되어 목적지까지 도달하지 못하고 드랍된다.
> 목적지에 도달하지 못하고 드랍되면 출발지에서 TTL 값을 2로 다시 세팅하고 보낸다.
> 이런식으로 목적지까지 도달하지 못하면 도달할 때까지 TTL 값을 +1씩 하여 진행한다.
>
> TTL 은 어떤 라우터를 경유하는지 정보를 목록으로 표시한다.
> ping 이 정상적으로 완료되지 않은 경우는 이 명령을 사용하여 경로상에서 오류를 일으키고 있는 위치를 찾아낼 수 있다.
> 또한 경로상에 존재하는 각 라우터로부터 response 시간을 잴 수도 있으므로 네트워크의 병목 부분(경로상에서 통신 속도가 안 나는 요인이 되는 부분)을 파악할 수 있다.


<br>


### ICMP 패킷 헤더 구조 

![image](https://github.com/lielocks/WIL/assets/107406265/54acc325-2dcf-4278-b7a0-70565b338a24)

<br>

**ICMP 헤더** 는 그림에선 5개로 보이지만 기본적으로 4개로 구성되어 있다.

+ **ICMP Type** : ICMP 의 메세지를 구별

+ **ICMP Code** : 메세지 내용에 다한 추가 정보 (즉, ICMP TYPE 에 대한 상세 정보)

+ **ICMP Checksum** : ICMP 의 값이 변조 여부를 확인

+ **ICMP 메세지1, 메세지2** : ICMP TYPE 에 따라 내용이 가변적으로 들어가는 내용

   + **`메세지 1`**

      + ICMP TYPE 3 (DESTINATION UNREACHABLE)

      + ICMP TYPE 11 (TIME EXCEEDED) 등에서는 사용되지 않으므로 0 이 채워짐


   + **`메세지 2`**

      + ICMP TYPE 8 (ECHO REQUEST)

      + ICMP TYPE 0 (ECHO REPLY) 같은 메세지에서 특정 값이 주어짐


<br>


내용을 읽어본다면 결국 ICMP 는 TYPE 에 따라 종류가 다양합니다. 

그 중 많이 볼 수 있는 메세지 들을 아래 표에 정리해 봤어요.

![image](https://github.com/lielocks/WIL/assets/107406265/73beefdc-6cc6-4547-8465-732c4197e81b)


<br>


### Wireshark 를 통해 본 ICMP

이번엔 실제 덤프를 통해서 패킷을 살펴볼게요.

**ICMP TYPE - REQUEST**

ICMP 구조에 따라 Type 8, Code 0, Checksum, Data 를 확인할 수 있네요

type 이 Request 이기 때문에 메세지 1(data) 에 특정값 (abcdefg .. 이하 생략) 이 채워져 있네요

![image](https://github.com/lielocks/WIL/assets/107406265/6035359d-be2e-4936-95e1-cd4c19500504)


<br>


**ICMP TYPE - Reply  [응답이 정상적인 경우]**

Type 0, Code 0, Checksum 도 정상적이네요

또 동일하게  Reply 이기 때문에 메세지 1(data)에 특정값으로 채워져 있는 것을 확인할 수 있습니다


![image](https://github.com/lielocks/WIL/assets/107406265/2c4dec14-8cef-4971-9b9e-ef215d86416d)


<br>


**ICMP TYPE - Destination Unreachable [응답이 비정상적인경우]**

어떠한 이유로 인해 packet 이 정상적으로 도달하지 못하는 경우 이에 대한 응답메세지를 보내는데, Unreachable 도 그 중 하나입니다.

Type 3, Code 13, Checksum 도 정상적인데, 차이점은 메세지 2(data)에 실패한 packet 의 정보(IPV4, ICMP)가 담겨있는 것을 볼 수 있죠


![image](https://github.com/lielocks/WIL/assets/107406265/9b116b07-9746-4aa4-a5c6-6a6ec73b0e2b)


<br>


## IGMP (Internet Group Management Protocol)

**특정 그룹에 속하는 모든 host 에 메시지를 전송하는 방식** 을 **`멀티캐스팅(Multicasting)`** 이라고 한다.

   + **IGMP** 는 **TCP / IP 프로토콜 집합이 `동적 멀티캐스팅`을 수행하기 위해 사용하는 표준 프로토콜**

그리고 이때 필요한 Routing Algorithm 을 **`멀티캐스트 라우팅(Multicast Routing)`** 이라고 한다.

IGMP 프로토콜은 *여러 호스트(수신자)에게 채널이 효과적으로 전송* 되게 하기 위해, Multicast Network 를 기반으로 구성되는 IPTV 서비스에 많이 사용되고 있다.

![image](https://github.com/lielocks/WIL/assets/107406265/8349e4cd-f5f0-4192-8c36-c9d72d2d1c95)


<br>


### IGMP 동작 과정

*자신이 IGMP 메시지에 표시된 Multicast address 의 멤버임을 다른 host 와 router 에 알리기 위한 용도* 로 **IGMP** 를 사용한다.

즉 A 그룹에 가입하려면 해당 Multicast Address 를 표기한 IGMP 보고 메시지를 전송해야 하는데, IGMP 헤더의 Group Address 필드에 가입을 원하는 Multicast address 를 기록한다.

Multicasy Router 가 그룹에 속한 멤버 목록을 유효하게 관리하려면 IGMP 질의 메시지를 사용해 주기적으로 확인하는 과정이 필요하다.

개별 host 가 자신의 그룹 멤버를 유지하려면 B 처럼 IGMP 보고 메시지를 사용해 IGMP 질의에 응답해야 한다.

C 처럼 router 의 질의 메시지에 대해 host 의 보고 메시지 응답이 이루어지지 않으면 그룹에서 탈퇴한 것으로 간주된다.

![image](https://github.com/lielocks/WIL/assets/107406265/1ae835b3-2bcb-400d-92be-f88c0b89b3ed)


<br>


**host 측면에서 이용한다.**

Multicast 데이터의 수신을 원하는 host 들이 IGMP를 사용하여 router 에게 요청하거나

더 이상 수신을 원하지 않으면 그만 전송하라 중지 요청을 한다.

즉, host 들은 Multicast group 에 가입/ 탈퇴 한다고 router 에게 요청하는 용도입니다.


<br>


**Router 측면에서 사용**

Router 는 IGMP 를 통하여 Multicast Group 에 가입한 host 들을 감시하게 된다.

따라서 주기적으로 Multicast Group 에 가입한 host 들에게 **`IGMP packet`** 을 사용하여 질의하는 용도. 

이러한 Multicast Group 멤버들은 **`SHOW IP IGMP GROUP`** 를 통하여 확인할 수 있다.
 
Expires 시간내에 host 로부터 IGMP packet 을 수신하지 못한다면 아래내용은 삭제된다.

만일 Router 가 이를 감시하지 않을 시 다음과 같은 일이 발생할 수 있다.


<br>


한 host 가 Multicast 를 이용하여 파일을 다운로드 하는중에 전력이 차단되서 PC 전원이 차단된다면 이 host 는 Multicast Group 의 탈퇴 메시지를 전송하지 못하게 된다.

Router 는 이러한 사실을 모르고 계속 가입되어 있는줄 착각하고 Multicast Packet 을 지속하여 전송할 것이다.

이런다면 쓸데없이 *대역폭 낭비와 router 자원의 낭비* 를 발생시킨다. 

따라서, **`Router`** 는 **IGMP 를 통하여 Multicast Group 에 가입한 host 들을 감시** 하는 역할을 수행한다.


<br>


**IGMP 메시지의 전송**


IGMP 는 **IP 프로토콜과 동등한 계층의 기능** 을 수행한다.

***그러나 바로 `DataLink Layer 로 보내지지 않고,` IP packet 에 캡슐화되어 보내진다.**

IGMP 메시지는 **`IP 프로토콜의 데이터로 처리`** 되기 때문에 **IP packet 의 header 에 실려서 계층 2 프로토콜로 전달된다.**

![image](https://github.com/lielocks/WIL/assets/107406265/ed05e9a7-72c4-4e62-bfd0-1a9c70dd416e)


<br>


**IGMP 취약점**

IGMP 프로토콜의 구조는 매우 단순하며 별도의 인증 과정을 거쳐 가입(Join) 하는 기능을 제공하지 않기 때문에, ***보안 면에서 매우 취약*** 하다는 단점을 가지고 있다.

공격자는 정상적인 사용자가 발신하는 IGMP 메시지처럼 보이도록 위조하여 IPTV서비스 상의 프리미엄 채널을 가로채어 시청하거나, 

현재 시청하고 있지 않는 여러 개의 채널을 요청해서 네트워크 내에 있는 모든 채널의 품질을 저하시키는 등의 공격을 할 수 있다.

ICMP 와 마찬가지로 **`디도스 공격`** 에 이용될수 있다

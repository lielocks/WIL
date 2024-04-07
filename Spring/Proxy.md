## 2022.10.22 Proxy (* instanceof Entity) ##


![Untitled](https://github.com/lielocks/WIL/assets/107406265/7b3312b9-e596-4560-863a-eb2a2456dcf2)


## 프록시의 특징 ##

+ 프록시 객체는 처음 사용할때 한번만 초기화
+ 프록시 객체를 초기화할 때 , 프록시 객체가 실제 엔티티로 바뀌는건 아님. 초기화되면 **프록시 객체를 통해서 실제 엔티티에 접근 가능**
+ 프록시 객체는 원본 엔티티를 상속 받음. 따라서 타입 체크시 주의 ! ( == 비교 실패, 대신 instance of 를 사용 )
+ 영속성 컨텍스트에 찾는 엔티티가 이미 있으면 **em.getReference()** 를 호출해도 실제 엔티티 반환
+ 영속성 컨텍스트의 도움을 받을 수 없는 준영속 상태일 때, 프록시를 초기화하면 문제 발생
  ( hibernate 는 *org.hibernate.LazyInitializationException* 예외를 터트림 )

  

# Weather App

### URLSession 이란?

특정한 URL을 활용하여 Data를 Download,Upload하기 위한 API입니다.

### URLSession Life Cycle

1. **Session Configuration**을 결정하고 **Session**을 생성
2. 통신할 **URL**과 **Requset** 객체를 설정
3. 사용할 **Task** 를 결정하고 그에 맞는 **completion Hander** 나 **Delegate** 메소드를 작성
4. 해당 **Task**를 실행
5. **Task** 완료 후 **Completion Handler** 클로저 호출

# Current Weather API 활용

[https://openweathermap.org](https://openweathermap.org/)

## 구현

- URLSession을 사용하여 가져온 Json Data 와 구조체를 매핑하기 위에 Codable프로토콜 사용하겠습니다
    - 만약 Json데이터로 불러온 데이터의 이름이 아닌 다른 이름으로 하고 싶다면 CodingKey프로토콜 사용

![스크린샷 2024-03-26 오전 4.52.44.png](Weather%20App%2002d6bfa6759d488d930bfbad9bf7b747/%25E1%2584%2589%25E1%2585%25B3%25E1%2584%258F%25E1%2585%25B3%25E1%2584%2585%25E1%2585%25B5%25E1%2586%25AB%25E1%2584%2589%25E1%2585%25A3%25E1%2586%25BA_2024-03-26_%25E1%2584%258B%25E1%2585%25A9%25E1%2584%258C%25E1%2585%25A5%25E1%2586%25AB_4.52.44.png)

---

PostMan을 활용하여 API 호출 후 그게 알맞은

Struct Model 생성

![postManImg](https://ibb.co/NFvJM24)

# 위치 기반 불러오기

---

먼저 **CoreLocation**의 import 해주고 **CLLocationManagerDelegate** 프로토콜 선언을 해줍니다 

- **CoreLocation이란?**
    - 기기의 지리적 위치와 방향을 얻는 행위입니다
- **CLLocationManagerDelegate이란?**
    - Location manager 객체와 관련된 것들로 부터 이벤트를 받아올 때 사용됩니다
- **Location manager이란?**
    - 이 클래스의 인스턴스들은 Core Location 서비스들을 시작하고 멈추고 구성하기 위해 사용됩니다

# 결과물

---

[https://youtu.be/KNBItDnmNEs](https://youtu.be/KNBItDnmNEs)

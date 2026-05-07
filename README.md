# 토익 성적 분석기 (Flutter Mobile Application)

 ## Introduction

 분포 차트 (Distribution Chart)     |  일정 시트 (Date Sheet)
:-------------------------:|:-------------------------:
<img width="320" height="463" alt="image" src="https://github.com/user-attachments/assets/811b68ce-23d0-42c0-8a54-f9f8db368304" /> | <img width="321" height="470" alt="image" src="https://github.com/user-attachments/assets/e76b1537-c7d2-45b8-9e3d-b4be7e1267ed" />


기록 차트 (History Sheet)     | 원스토어 등록 (ONE Store)
 :------------------------:|:-------------------------:
<img width="320" height="472" alt="image" src="https://github.com/user-attachments/assets/9e00b40c-11a7-44ff-9bd6-e2995e240a8d" /> | <img width="428" height="633" alt="image" src="https://github.com/user-attachments/assets/94413ecd-d105-498d-8aa9-ca5d1de4b44e" />


 * **토익 성적 분석기**은 **Flutter / Dart** 로 작성된 모바일 어플리케이션입니다.<br>

   외국어 학습 정보 제공 및 계획 수립 기능을 제공합니다.
 
   *이 프로그램은 (주)와이비엠넷으로부터 시험 결과 데이터를 제공받습니다.*

 ## Funtionality
 
> ### Analysis
> * 전국 원자력발전소의 방사선량 및 안전도를 조회할 수 있다.
> * 특정 원자력발전소에 속하는 관측소들의 방사선량을 조회할 수 있다.
> * 새로고침하여 데이터를 최신 정보로 갱신할 수 있다.

> ### Radioactivity warning
> * 기준치 이상의 방사선량이 관측되면 경고 알림을 발신한다.
> * 기준치를 커스터마이징 할 수 있다.
> * 가상의 발전소를 통해 경고 알람 기능의 작동 여부를 점검할 수 있다.

 ## Project Overview
> ### Language
> Java (1.8)

> ### IDE
> Android Studio (Ape) 
 
> ### REST API
> * (주)한수원의 실시간 방사선량 OPEN API를 HTTPS 통신으로 접근한다.
> * XML format으로 된 데이터를 parsing 하여 어플리케이션 모델로 변환한다.

 ## Author
 * 조성원 (Sung Won Jo / David Jo)
 
     📧 waterbottle54@naver.com
   
     📚 [Portfolio](https://www.devsungwonjo.pe.kr/)
   
     📹 [Youtube Channel](https://www.youtube.com/@vanilla03034)
   
 ## Version History
 * **1.01** (2021.5): First Release
   ![](https://github.com/waterbottle54/radiaton-monitor/blob/main/onestore.png)

 ## Acknowledgments
 * (주)한국수력원자력 (KHNP Co.,Ltd.)
 * https://www.data.go.kr/data/15001091/openapi.do#tab_layer_prcuse_exam


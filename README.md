# 토익 성적 분석기 (Flutter Mobile Application)

 ## Introduction

 분포 차트 (Distribution Chart)     |  일정 시트 (Date Sheet)
:-------------------------:|:-------------------------:
<img width="321" height="479" alt="image" src="https://github.com/user-attachments/assets/5206d02b-e6bf-4091-b8fc-949ff4580ccb" /> | <img width="321" height="470" alt="image" src="https://github.com/user-attachments/assets/e76b1537-c7d2-45b8-9e3d-b4be7e1267ed" />


기록 차트 (History Sheet)     | 원스토어 (ONE Store)
 :------------------------:|:-------------------------:
<img width="320" height="472" alt="image" src="https://github.com/user-attachments/assets/9e00b40c-11a7-44ff-9bd6-e2995e240a8d" /> | <img width="399" height="514" alt="image" src="https://github.com/user-attachments/assets/2e0d5255-8a00-45d0-8863-d272e8d796b8" />


 * **토익 성적 분석기**은 **Flutter / Dart** 로 작성된 모바일 어플리케이션입니다.<br>

   외국어 학습 정보 및 분석 기능을 제공합니다.
 
   *이 프로그램은 (주)와이비엠넷으로부터 시험 결과 데이터를 제공받습니다.*

 ## Funtionality
 
> ### Analysis
> * 특정 회차의 점수 분포 및 누적 분포를 차트로 조회할 수 있다. 
> * Catmull Rom spline 을 적용하여 이산 데이터를 연속적으로 표현한다.
> * 버튼(FloatingActionButton)을 클릭하여 점수를 SQLite DB에 기록할 수 있다.

> ### Date Picker
> * Bottom Sheet으로부터 데이터를 제공받고자 하는 회차를 선택할 수 있다.
> * Firebase (Firestore) 에 원격으로 저장된 데이터를 쿼리한다.

> ### History 
> * Analysis 화면에서 추가한 기록을 SQLite DB로부터 불러오고 차트로 보일 수 있다.

 ## Project Overview
> ### Language / Framework
> Dart / Flutter

> ### IDE
> Android Studio
 
 ## Author
 * 조성원 (Sung Won Jo / David Jo)
 
     📧 waterbottle54@naver.com
   
 ## Version History
 * **1.01** (2021.5): First Release
   ![](https://github.com/waterbottle54/radiaton-monitor/blob/main/onestore.png)

 ## Acknowledgments
 * (주)한국수력원자력 (KHNP Co.,Ltd.)
 * https://www.data.go.kr/data/15001091/openapi.do#tab_layer_prcuse_exam


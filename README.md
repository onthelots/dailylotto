# 데일리로또 
> 매일 만나는 나만의 행운번호
- 랜덤 번호 생성은 이제 그만! 당신의 선택과 운세를 분석해 AI가 맞춤형 로또 번호를 추천하는 서비스입니다.

#### <a href="https://momentous-wallet-0f7.notion.site/1a81c3f0e003806980e5e8bd7732fa83?pvs=4"><img src="https://img.shields.io/badge/HomePage-009BD5?style=flat&logo=Notion&logoColor=white"/> <a href="https://apps.apple.com/kr/app/%EB%8D%B0%EC%9D%BC%EB%A6%AC%EB%A1%9C%EB%98%90/id6742641988"><img src="https://img.shields.io/badge/AppStore-000000?style=flat&logo=AppStore&logoColor=white"/> <a href="https://www.figma.com/design/MYK0TassNj2fG4hVPaYZlY/daily_lotto_design?node-id=86-700&t=WqObIinlzsDwdsbQ-1"><img src="https://img.shields.io/badge/Figma-F24E1E?style=flat&logo=figma&logoColor=white"/></a>


<br>

![screenshot_combine](https://github.com/user-attachments/assets/e44e74dd-49a8-4388-93cc-06147e0c179b)

<br> 

# 목차

[1-프로젝트 소개](#1-프로젝트-소개)

- [1-1 개요](#1-1-개요)
- [1-2 개발환경](#1-2-개발환경)

[2-앱-디자인](#2-앱-디자인)
- [2-1 Screen Flow](#2-1-Screen-Flow)
- [2-2 Architecture](#2-2-Architecture)

[3-프로젝트 특징](#3-프로젝트-특징)

[4-프로젝트 세부과정](#4-프로젝트-세부과정)

[5-업데이트 및 리팩토링 사항](#5-업데이트-및-리팩토링-사항)


--- 

## 1-프로젝트 소개

### 1-1 개요
`당신의 선택과 운세를 분석해 AI가 맞춤형 로또 번호를 추천해드립니다.`
- **개발기간** : 2025.02 - 2025.03 (약 4주)
- **참여인원** : 1인 (개인 프로젝트)
- **주요내용**

  - 단순한 랜덤 번호 생성이 아닌, 사용자의 답변을 기반으로 CHAT GPT를 통한 로또번호 및 오늘의 운세 생성
  - 생성번호 리스트, 최근 회차와 생성번호 결과 매칭, 주차별 생성 과정 등 다양한 어트랙션 제공
  - 사용자의 앱 실행 빈도를 높이기 위한 Functions Scheduler 호출을 통한 주기적 FCM 발송 (Topic)

<br>

### 1-2 개발환경
- **활용기술 외 키워드**
  - Flutter
    - 사용자 (iOS, Android)
   
  - 상태관리 : BloC, Cubit, Provider
  - DI : get_it
  - Server : Firebase (Functions, Messaging, FireStore)
  - LLM : CHAT GPT
  - DB : HIVE, Shared Preferences

<br>

## 2-앱 디자인

### 2-1 Screen Flow
`메인 화면 내 앱 주요기능 노출을 통한 사용자 편의성 제고`
- 주 기능인 '번호 생성', '당첨여부 확인'과 같은 기능을 전면에 배치
- 과도한 정보 제공을 지양하고자 앱 실행 시 필요한 정보를 즉각적으로 파악할 수 있도록 함

`번호 수집이란 어트랙션을 강조하기 위해 요일별 진행 상황 기능 구현`
- 매일, 최대 1회까지 가능한 번호 수집 및 생성 과정에 대한 기록을 파악하도록 함
- 이미 추첨이 종료된 회차에 대한 정보와 내가 생성한 번호의 결과를 나타내어 사용자의 주기적 참여를 유도
  
![app flow](https://github.com/user-attachments/assets/cd803d7d-d21f-4984-9ed6-e44c0c255f59)



<br>

### 2-2 Architecture
`Firebase Functions의 Scheduler를 활용한 주요 데이터 갱신`
- LLM API를 활용한 질문세트 생성 및 로또 번호 생성기능을 도입
- 공지사항, 사용자 알림, 추첨 결과 확인 등 앱 실행빈도를 높이기 위한 Notification 기능 구현

`Bloc, Provider, Cubit을 활용한 상태관리, Clean Architecture 적용`
- 원활한 유지보수 및 기능 추가를 위한 Clean Architecture 적용
- 앱 전역에서 사용하는 상태와 특정 화면에서 사용하는 상태를 별도로 분리하여 주입(Get_it Locator), 적용 (Provider)
- 앱 실행 시, 갱신이 필요한 '최신 회차 결과'를 비롯하여 Trigger를 통한 즉각적인 DB 업데이트 (Listener, Trigger)

![architecture](https://github.com/user-attachments/assets/4e72c249-8cfe-417b-b89f-b5eeaba4ddd5)


<br>

## 3-프로젝트 특징
### 3-1 앱의 전반적인 기능과 알림허용과 관련된 사항을 소개하기 위한 Splash Screen 구현
- '로또 번호' 생성과 관련된 모호하고 추상적인 개념에 대하여 현재 앱의 정체성을 간략히 소개함
- 주요 기능 중 하나인 알림과 관련된 사항에 대하여 사용자의 권한 허용을 유도함

<table>
  <tr>
    <td align="center"><img src="https://github.com/user-attachments/assets/748d5b36-0c7b-4f71-aa36-0f8c5061d22a" width="250" height="541"/></td>
    <td align="center"><img src="https://github.com/user-attachments/assets/9d201138-7d56-44b5-a456-189ee15b84b9" width="250" height="541"/></td>
    <td align="center"><img src="https://github.com/user-attachments/assets/d995b8fb-7fc8-4a1d-9bba-c82a14cb15de" width="250" height="541"/></td>
  </tr>
  <tr>
    <td align="center">Splash 1</td>
    <td align="center">Splash 2</td>
    <td align="center">Splash 3</td>
  </tr>
</table>

<br>


### 3-2 하루 한번 제공되는 번호 생성 기회와 회차별 진행상황 파악
- 매일 1회 기회를 통하여 로또 번호를 생성할 수 있으며, 이에 따른 결과로 현재 회차별 진행상황을 파악함
- DB(HIVE) 내 사용자 생성 데이터를 저장하고, 이를 실제 동행복권에서 제공하는 회차별 결과 API와 매칭함
- 아침, 점심, 저녁으로 시간대를 구분하여 동적으로 AppBar 디자인(+Lottie)을 변경함으로서 생동감을 부여함

<table>
  <tr>
    <td align="center"><img src="https://github.com/user-attachments/assets/eacd3328-9a65-472a-b227-ebc8f6c34ad5" width="250" height="541"/></td>
    <td align="center"><img src="https://github.com/user-attachments/assets/a2adf22a-d094-4144-9bbf-5ab1f8441caf" width="250" height="541"/></td>
    <td align="center"><img src="https://github.com/user-attachments/assets/3f3cc263-7fc3-4dbb-bf04-9f7cf1e2c7bb" width="250" height="541"/></td>
  </tr>
  <tr>
    <td align="center">Home Screen</td>
    <td align="center">Weekly Screen</td>
    <td align="center">Round List</td>
  </tr>
</table>

<br>

### 3-3 LLM을 통해 생성된 질문과 사용자의 답변을 기반으로 한 로또번호 및 운세 추천
- CHAT GPT(LLM) 모델 API을 통해 특정 상황에 대한 질문과 답변을 생성한 후, 답변에 따라 2차 분석을 실시함
- 생성된 로또 번호 및 오늘의 운세를 함께 제공함으로서 신뢰성 있는 서비스 제공 도모
- 이전 회차 (최신 추첨회차)와 사용자의 생성번호 값을 비교함으로서 당첨/낙첨 여부를 알림

<table>
  <tr>
    <td align="center"><img src="https://github.com/user-attachments/assets/9712174f-6f91-43b0-8449-5c81d563d1d5" width="250" height="541"/></td>
    <td align="center"><img src="https://github.com/user-attachments/assets/35649ac2-46df-40e0-a0aa-251c3f182f2b" width="250" height="541"/></td>
    <td align="center"><img src="https://github.com/user-attachments/assets/e8570bee-f14b-4d7d-b78d-ba09775e8898" width="250" height="541"/></td>
  </tr>
  <tr>
    <td align="center">Question</td>
    <td align="center">Daily Result</td>
    <td align="center">Latest Result</td>
  </tr>
</table>

<br>


### 3-4 알림 및 테마기능 설정
- 전체 알림 설정 이외, Topic 별 알림 설정 기능을 통해 사용자의 알림 선택권을 부여함
- 일반적인 시스템, 다크, 화이트 모드 제공

<table>
  <tr>
    <td align="center"><img src="https://github.com/user-attachments/assets/7ab3c4da-9da3-44ce-b811-e3be98614e43" width="250" height="541"/></td>
    <td align="center"><img src="https://github.com/user-attachments/assets/1423785c-eb75-4bd1-bb4b-56686192287a" width="250" height="541"/></td>
    <td align="center"><img src="https://github.com/user-attachments/assets/c504145b-0738-4d6a-92cf-8d01c0301b2c" width="250" height="541"/></td>
  </tr>
  <tr>
    <td align="center">MyPage</td>
    <td align="center">Topic Setting</td>
    <td align="center">Theme Setting</td>
  </tr>
</table>


<br>


## 4-프로젝트 세부과정
### 4-1 Figma를 활용한 Mock-up, App Flow 구현
> 빠른 개발을 위해 디자인 목업 실시
- 색상 팔레트 및 메인테마, 앱 아이콘 등 초기 앱 세팅에 필요한 사항을 선행 작업
- 전반적인 앱 흐름 파악과 빠른 UI 작업을 위해 Figma를 통해 Components 생성

<a href="https://www.figma.com/design/MYK0TassNj2fG4hVPaYZlY/daily_lotto_design?node-id=86-700&t=WqObIinlzsDwdsbQ-1"><img src="https://img.shields.io/badge/Figma-F24E1E?style=flat&logo=figma&logoColor=white"/>


![app_design_figma](https://github.com/user-attachments/assets/81a80590-7452-4eb7-8f1e-04d5f8ee024b)



<br>

### 4-2 LLM, Notification을 위한 Functions 작업 진행
> 공통적으로 활용되는 데이터의 생성 및 관리를 위한 Node.js deploy 실시
- 회차별 당첨번호 갱신, 매일 새롭게 생성되는 질문세트, AI 번호 생성, 주기적 알림 등
- 관련된 주요 기능을 우선 테스트하기 위하여 Firestore functions을 활용하여 google console scheduler 내 적용

![Group 68](https://github.com/user-attachments/assets/c85a2375-14a2-4ce1-8fed-6aff38da9be2)



<br>

### 4-3 개발 및 지원체계 구축
> 사전에 구축한 Figma components를 기반으로 한 빠른 UI 화면 구축 실시
- 앱 테마 및 색상, 공통적인 서비스 (Shared_preference, HIVE, 앱 버전관리, Route) 작업 실시
- Components 별 Constraint와 Size를 기반으로 Widgets 생성
- 공식 페이지, 개인정보 처리방침 외 관련된 지원체계 생성 및 구축

<br>

### 4-4 상태관리를 위한 DI 주입 및 BloC Providing 실시
> 구현된 화면 별, 필요한 데이터 주입 및 Environment에 따른 테스트 실시
- 공통 데이터(-> main), 특정 화면 내 사용되는 상태값으로 구분하여 Provider 생성
- Consumer, Listener, Builder를 적절하게 사용함으로서 불필요한 리빌딩을 줄임


<br>

## 5-업데이트 및 리팩토링 사항
### 5-1 우선 순위별 개선항목
1) Issue
- [ ] empty

2) Develop
- [ ] 사용자 별 생성 번호 분석 기능 구현

<br>

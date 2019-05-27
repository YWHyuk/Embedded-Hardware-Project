# Embedded Hardware Project
## 1. Introduction
***
## 2. Development process
### 2.1 Demo model (마감 5/7일까지)
<img src="https://github.com/YWHyuk/Embedded-Hardware-Project/blob/master/img/Demo%20version.png" width="90%"></img>

> 라인 모듈, 버튼 모듈, 스코어 모듈로 구성된다. 

> 난수 발생기를 버튼 입력을 대신하여, 라인에 노트를 추가하고, 생성된 노트는 스코어로 전달되어, 점수를 증가시킨다. 
### 2.1.1. line module(양원혁)
<img src="https://github.com/YWHyuk/Embedded-Hardware-Project/blob/master/img/line%20module.png" width="90%"></img>

* **Input**: random 비트 3개, clock 비트 1개, nclr 비트 1개(저장된 레지스터를 초기화)
* **Ouput**: line[7:0] 벡터 비트 3개
* **Branch**: line 

### 2.1.2. button module(장현준)
<img src="https://github.com/YWHyuk/Embedded-Hardware-Project/blob/master/img/button%20module.png" width="90%"></img>

* **Input**: button 비트 3개, clock 비트 1개
* **Ouput**: output 비트 3개
* **Branch**: button

### 2.1.3. score module(임종화)
<img src="https://github.com/YWHyuk/Embedded-Hardware-Project/blob/master/img/score%20module.png" width="90%"></img>

* **Input**: score 비트 2개, reset 비트 1개
* **Output**: BCD[3:0] 벡터 비트 6개
* **Description**: score 비트 1번은 1점, score 비트 2번은 2점, 둘 다 켜지면 3점
* **Branch**: score

### 2.1.4. RNG module(양원혁)
<img src="https://github.com/YWHyuk/Embedded-Hardware-Project/blob/master/img/RNG%20module.png" width="90%"></img>

* **Input**: noise 비트 1개, clock 비트 1개
* **Output**: o[31:0] 
* **Description**: 의사 난수 발생은 linear feedback shift register로 발생되며, US 특허 6,581,078 B1를 참고하였다. 




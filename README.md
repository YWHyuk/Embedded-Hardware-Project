# Embedded Hardware Project
## 1. Introduction
***
## 2. Development process
### 2.1. LineAndDetector module(양원혁)
<img src="https://github.com/YWHyuk/Embedded-Hardware-Project/blob/RNG/img/LineAndDetector.png" width="90%"></img>
* **Input**: random 비트 3개, btn 입력 3개, nclr(모듈 전체 초기화)
* **Ouput**: score 벡터, line 벡터 3개
* **Branch**: RNG
* **Description**: 적절한 버튼입력에 대해 노트 클리어, 점수 시그널 전달.
#### 2.1.1 line module
<img src="https://github.com/YWHyuk/Embedded-Hardware-Project/blob/RNG/img/line%20module.png" width="90%"></img>

* **Input**: random 비트 3개, clock 비트 1개, nclr 벡터 3개(저장된 레지스터를 초기화)
* **Ouput**: line[7:0] 벡터 비트 3개
* **Branch**: RNG 
#### 2.1.2 ThreeBitDetector module
<img src="https://github.com/YWHyuk/Embedded-Hardware-Project/blob/RNG/img/ThreeBitDetector.png" width="90%"></img>

* **Input**: btn 입력 1개, clock, reg 1 비트
* **Ouput**: score, nclr
* **Branch**: RNG
* **Description**: 감시하는 레지스터에 버튼 입력이 적절하게 들어오면 해당 레지스터를 clear한다.

***

### 2.2. button module(장현준)
<img src="https://github.com/YWHyuk/Embedded-Hardware-Project/blob/master/img/button%20module.png" width="90%"></img>

* **Input**: button 비트 3개, clock 비트 1개
* **Ouput**: output 비트 3개
* **Branch**: button

### 2.3. score module(임종화)
<img src="https://github.com/YWHyuk/Embedded-Hardware-Project/blob/master/img/score%20module.png" width="90%"></img>

* **Input**: score 비트 2개, reset 비트 1개
* **Output**: BCD[3:0] 벡터 비트 6개
* **Description**: score 비트 1번은 1점, score 비트 2번은 2점, 둘 다 켜지면 3점
* **Branch**: score

### 2.4. RNG module(양원혁)
<img src="https://github.com/YWHyuk/Embedded-Hardware-Project/blob/master/img/RNG%20module.png" width="90%"></img>

* **Input**: noise 비트 1개, clock 비트 1개
* **Output**: o[31:0] 
* **Description**: 의사 난수 발생은 linear feedback shift register로 발생되며, US 특허 6,581,078 B1를 참고하였다. 




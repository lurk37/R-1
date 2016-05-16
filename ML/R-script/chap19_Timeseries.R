############################
시계열분석
############################
# 시계열(Time-Series) : 관측치 또는 통계량의 변화를 시간의 움직임에 
# 따라서 기록하고, 이것을 계열화한 것을 의미한다.
# 시계열 데이터 : 통계숫자를 시간의 흐름에 따라 일정한 간격마다
# 기록한 통계열을 의미한다.
# 관련분야 : 경기예측, 판매예측, 주식시장분석, 예산분석, 투자연구 등
#x축이 시계!! y축이 데이터
#정상성 시계열 - AR(자기회귀모형), MA(이동평균모형), ARIM(AR+MA)
#비정상 시계열 - ARIMA(자동으로 모형선택)

############################
# 시계열 추세선 시각화
############################

data() # WWWusage   Internet Usage per Minute
WWWusage
str(WWWusage) 

# 추세선 시각화
plot(WWWusage, type="l", col='red')

# 데이터프레임 생성 
InternetUsage <- WWWusage # 인터넷 사용시간 벡터 생성
Minute<- c(1:100) 

Timeseries <- data.frame(Minute,InternetUsage)
head(Timeseries)

library(ggplot2)
# 추세선 그리기 
ggplot(Timeseries, aes(x=Minute, y=InternetUsage)) + geom_point(color="blue")
ggplot(Timeseries, aes(x=Minute, y=InternetUsage))+ geom_line(color="red")

#----------------------------------------------------

# [실습] 시계열 데이터 추세선 시각화 
data(EuStockMarkets) #유럽 주식 데이터 
head(EuStockMarkets)

EuStock<- data.frame(EuStockMarkets)
head(EuStock)

# 단일 시계열 데이터 추세선 
plot(EuStock$DAX[1:1000], type="l", col='red') # 선 그래프 시각화 

# 다중 시계열 데이터 추세선
plot.ts(cbind(EuStock$DAX[1:1000],EuStock$SMI[1:1000]),main="주가지수 추세선")
#----------------------------------------------------


#-----------------------------------------------
#  연습문제1 - 추세선 시각화 관련
#-----------------------------------------------
# <연습문제1> 시계열 데이터를 대상으로 다음과 같은 조건으로 추세선을 시각화 하시오.

# <데이터 셋 준비>
data(EuStockMarkets)
head(EuStockMarkets)
EuStock<- data.frame(EuStockMarkets)
head(EuStock)
data()
# 조건1) Second 벡터(1~500)=c(1:500)와 DAX 벡터(DAX 컬럼의 1001~1500 벡터) 생성
str(EuStock)

series1=c(1:500)
series2=EuStock[1001:1500,1]

# 조건2) Second와 DAX 벡터 이용 데이터프레임(EuStock.df) 생성
EuStock.df=data.frame(series1,series2)
head(EuStock.df)
# 조건3) ggplot()함수를 이용하여 X축(Second), Y축(DAX) 형태로 시계열 데이터를 	  
#          점과 선으로 추세선 시각화(선색 : orange, 점색 : green)
ggplot(EuStock.df,aes(series1,series2))+geom_point(col='green')+geom_smooth(col='orange')

# 조건4) qplot()함수를 이용하여 추세선과 표준오차 시각화
#      힌트 : geom=c("point", "smooth"), method="auto" 속성 이용


############################
# 시계열모형 추정 예측 
############################

# 1. 시계열 모형 
# Forecasting Functions for Time Series and Linear Models
#주요함수
#auto.arima(): 시계열 모형 생성 함수
#forecast(): 모형을 이용해, 미래 예측

# 패키지 설치 
install.packages("forecast") 
library(forecast) 

# 단계 1 : 시계열 데이터 시각화  
WWWusage
plot(WWWusage, type="l", col='blue')

# 단계 2 + 3 : 정상성 시계열 변환 -> 시계열 모형 생성 
#정상성: 
arima <- auto.arima(WWWusage)

# 단계 4 : 시계열 모형으로 미래 예측 
p <- forecast(arima, h=30) # 향후 30분 예측 
plot(p) 

# 2. 시계열 데이터 생성과 미래 예측

# (1) 시계열 데이터 생성 
input <- c(3180,3000,3200,3100,3300,3200,3400,3550,3200,3400,3300,3700) 
input 
#ts 시계열 데이터로 형 변환 2015년 2월 시작, 12개월
tsdata <- ts(input, start=c(2015, 2), frequency=12) # Time Series
tsdata  

# (2) 추세선 시각화
plot(tsdata, type="l", col='red')

# (3) 모형의 적합도 - 선형모형 
time <- c(1:12)
summary(lm(tsdata ~ time))

# (4) 시계열 모형 추정  
tsdata2 <- auto.arima(tsdata) # 시계열 데이터 이용 


# (5) 시계열모형 추정으로 미래값 예측
tsdata3 <- forecast(tsdata2) # 미래값 예측-시계열모형 예측
tsdata3
plot(tsdata3) # 미래값 예측 도식화 


# 3. 시계열 데이터 파일로 미래 예측

# (1) 데이터 파일 가져오기 
setwd("C:/Rwork/ML/data")
goods <- read.csv("Sales.csv", header = TRUE) 
goods

# (2) 시계열 데이터 생성 
tsGoods <- ts(goods$Food, start=c(2015, 1), frequency=12) 
tsGoods 

# (3) 시계열모형 추정
tsGoods2 <- auto.arima(tsGoods) # 시계열모형 추정
tsGoods2


# (4) 시계열모형으로 미래예측
plot(forecast(tsGoods2)) # # - 기본 예측개월(2년) 

########################################
# 시계열모형 생성 -> 예측 -> 모형 검정  
########################################

# 1) 데이터 준비 
data <- c(45, 56, 45, 43, 69, 75, 58, 59, 66, 64, 62, 65, 
          55, 49, 67, 55, 71, 78, 71, 65, 69, 43, 70, 75, 
          56, 56, 65, 55, 82, 85, 75, 77, 77, 69, 79, 89)
length(data)# 36

# 2) 시계열 자료 생성 
tsdata <- ts(data, start=c(2016, 1), frequency=12)
tsdata 

# 3) 추세선 확인 - 요인 확인 
ts.plot(tsdata) 
# plot(tsdata) 동일함 

# 4) 시계열 분해
# (1) 시계열 분해와 변동 요인 확인
m <- decompose(tsdata)
attributes(m) # 분해된 속성 보기 

# (2) 변동요인 시각화 
plot(m)    

# (3) 시계열 데이터에서 특정 요인 제거
plot(tsdata - m$seasonal) # 계절요인 제거 
plot(tsdata - m$trend)    # 추세요인 제거
plot(tsdata - m$seasonal - m$trend) # 계절요인, 추세요인 제거(불규칙요인 출력) 
plot(tsdata - m$seasonal - m$trend - m$random) # 변동요인 모두 제거 

# 5) 모형 타당성 검정(선형 모형) : 
# 시계열은 시간이라는 반응변수(독립변수)에 의해서 어떤 설명변수(종속변수)를
# 나타내는 것을 말한다. 

# 선형회귀모형으로 타당성 검정 
# 형식) lm(formula=y ~ x, data=result) # x : 독립변수,  y: 종속변수 

length(tsdata) # 36
index <- 1:36
cnt <- 36/3 # 시계열 데이터수/년도 = 12
cnt
time <- index/cnt # 시계열 데이터수/cnt
time

# 계절주기 방정식 : 단순선형모형 이용, pi = 3.141593
model<- lm(tsdata ~ sin(time*2*pi)+ cos(time*2*pi))

plot(time, tsdata, pch='@') # 산점도 
lines(time, predict(model), col='red', lwd=2)

# 타당성 검정 
summary(model)


# 6) 최적의 시계열 모형 생성 
library(forecast) 
auto.arima(tsdata)  # 자동으로 최적의 ARIMA 모형 제공

fit <- auto.arima(tsdata)
attributes(fit) # 관련 변수 확인 - residuals(잔차)

# 7) 시계열 모형으로 미래 예측
fore <- forecast(fit)
plot(forecast(fit)) 

# 8) 시계열 모형 검정
# 잔차항 분석으로 시계열 모형의 검정 방법 2가지
# Barlett검정 방법과 Box-Ljung(박스-륭) 검정 방법이 있다.

# <실습>
x <- rnorm(100) # 100 난수 발생
x
Box.test(x, lag=1, type = "Ljung") 

# <모형 검정>
# 시계열 모형의 잔차항으로 모형 검정 
Box.test(fore$residuals, lag=1, type = "Ljung")


# <연습문제2> 시계열 데이터를 대상으로 다음과 같은 조건으로 시계열 모형을 생성하고, 미래를 예측하시오.
# <데이터 셋 준비>
# 문제1에서 생성된 EuStock.df 데이터프레임 이용
EuStock.df
# 조건1) 시계열 자료 생성 : DAX 칼럼을 대상으로 2001년1월 기준 시계열 자료 생성 
tsdata <- ts(EuStock.df$series2, start=c(2001, 1), frequency=12)
plot(tsdata)
# 조건2) 시계열 자료 분해 
#   (1) stl()함수 이용 분해 시각화
plot(stl(tsdata,'periodic'))

#   (2) decompose()함수 이용 분해 시각화, 불규칙요인만 시각화 
m <- decompose(tsdata)
attributes(m)
plot(m)

# 조건3) ARIMA 시계열 모형 생성 

fit=auto.arima(tsdata) 

# 조건4) 모형으로 미래값 예측(3년) : 향후 3년의 미래를 90%와 95% 신뢰수준으로  각각 예측 및 시각화
#forecast(model, h=36, level=c(90,95))

plot(forecast(fit, h=36, level=c(30))) 

plot(forecast(fit, h=36, level=c(95))) 

#Air Passengers Forecast 문제
#http://rstudio-pubs-static.s3.amazonaws.com/47545_68f444951de2461a8afd933d2e839412.html




# 1. 척도별 기술통계량

# 기술통계량의 유형 
# 대푯값 : 평균(Mean), 합계(Sum), 중위수(Median), 최빈수(mode), 사분위수(quartile) 등
# 산포도 : 분산(Variance), 표준편차(Standard deviation), 최소값(Minimum), 최대값(Maximum), 범위(Range) 등 
# 비대칭도 : 왜도(Skewness), 첨도(Kurtosis)

# - 실습파일 가져오기
setwd("c:/Rwork/Part-III")
data <- read.csv("descriptive.csv", header=TRUE)
head(data) # 데이터셋 확인

# 전체 데이터 특성 보기
dim(data) # 차원보기
length(data) # 열 길이
length(data$survey) # 컬럼 관찰치  
str(data) # 데이터 구조보기 
summary(data) # 요약통계량

# 1) 명목척도 변수의 기술통계량

length(data$gender) # 명목척도
summary(data$gender) # 명목척도 의미없음
table(data$gender) # 성별 빈도수 - outlier 확인(0, 5)

data <- subset(data,data$gender==1 | data$gender==2) # 성별 outlier제거
x <- table(data$gender) # 빈도수 저장
x 
barplot(x) # 범주형 시각화 -> 막대차트

prop.table(x) # 빈도수 비율 계산
y <-  prop.table(x)
round(y*100, 2) #백분율 적용(소수점 2자리)


# 2) 서열척도 변수의 기술통계량

length(data$level) # 학력수준 - 서열
summary(data$level) # 명목척도와 함께 의미없음
table(data$level)  # 빈도분석 - 의미있음

x1 <- table(data$level) # 각 학력수준에 빈도수 저장
x1
barplot(x1) # 명목/서열척도 -> 막대차트

# 3) 등간척도 변수의 기술통계량

survey <- data$survey
survey

summary(survey) # 만족도(5점 척도) -> 2.605(평균)
x1<-table(survey) # 빈도수
x1

hist(survey) # 등간척도 시각화 -> 히스토그림

# 4) 비율척도 변수의 기술통계량

length(data$cost)
summary(data$cost) # 요약통계량 - 의미있음(mean)
mean(data$cost) # NA
data$cost

# 데이터 정제 - 결측치 제거 및 outlier 제거
plot(data$cost)
data <- subset(data,data$cost >= 2 & data$cost <= 10) # 총점기준
data
x<- data$cost
x

##### cost 변수의 대푯값 ####
mean(x) # 평균 : 5.354
median(x) # 중위수 :  5.4   
sort(x) # 오름차순 
sort(x, decreasing=T) # 내림차순  
quantile(x, 1/4) # 1 사분위수 - 25%, 4.6
quantile(x, 3/4) # 3 사분위수 - 75%, 6.2
########################

#최빈수 검색
x=round(runif(100,min=1,max=100))
x1=table(x)
x_max=max(table(x))
which(x1==x_max)

#### cost 변수의 산포도 #####

var(x) # 분산
# [1] 1.296826

sd(x) # 표준편차는 분산의 양의 제곱근
# [1] 1.138783 

min(x) # 최소값
max(x) # 최대값
range(x) # 범위(min ~ max)
#########################

# 연속형(등간/비율척도) 시각화 : 히스토그램 의미없음
table(data$cost) # cost 빈도수
hist(data$cost) #  

# 연속형 -> 범주화(리코딩) : 1,2,3
data$cost2[data$cost >=1 & data$cost <=3] <-1
data$cost2[data$cost >=4 & data$cost <=6] <-2
data$cost2[data$cost >=7] <-3

# 5) cost 비율척도 기술통계량 구하기
attach(data) #data를 붙여라!      
length(cost)
summary(cost) # 요약통계량 - 의미있음(mean)
mean(cost) # 가장 의미있음
min(cost)
max(cost)
range(cost) # min ~ max
sort(cost) # 오름차순 
sort(cost, decreasing=T) # 내림차순
detach(data) # attach(data) 해제

# NA가 있는 경우 -> NA 출력
test <-c(1:5,NA,10:20)
min(test) 
max(test) 
range(test) 
mean(test)   

# 결측치 데이터 제거 후 통계량 구하기
min(test, na.rm=T) 
max(test, na.rm=T)
range(test, na.rm=T) 
mean(test, na.rm=T)

# 6) 비대칭도 구하기
# 비대칭도 : 분포의 기울어진 방향의 정도와 중심에 집중되는 정도를 나타내는 척도  

install.packages("moments")  # 왜도/첨도 사용을 위한 패키지 설치   
library(moments)
cost <- data$cost     

# 왜도
skewness(cost) # 0보다 작으면 왼쪽 꼬리, 크면 오른쪽 꼬리

# 첨도 
kurtosis(cost) # 2.683438   # 정규분포 첨도는 3  

hist(cost,freq = F) # 히스토그램으로 왜도/첨도 확인

#귀무가설: 정규분포와 차이가 없다
#대립가설: 정규분포와 차이가 있다 p<0.05
shapiro.test(x)

#  2. 패키지 이용 기술통계량 구하기     

########################<기술통계 패키지1>######################
install.packages("Hmisc") # 패키지 설치
library(Hmisc) # 메모리 로딩

# 전체 변수 대상 기술통계량 제공 - 평균,중위수,분산,표준편차,valid.n 
describe(data) # Hmisc 패키지에서 제공되는 함수

# 개별 변수 기술통계량
describe(data$gender) # 명목척도 
describe(data$age) # 비율척도
##############################################################

########################<기술통계 패키지2>#######################
install.packages("prettyR")
library(prettyR)

# 전체 변수 대상 기술통계량 제공     
freq(data) # 각 변수별 : 빈도수, 결측치(NA), 백분율
# 개별 변수 대상
freq(data$gender) # 빈도수, 결측치(NA), 비율 
###############################################################

# --------------------------------------------------------------------------
# <기술통계량 분석 관련 연습문제>
# --------------------------------------------------------------------------

#  3. 기술통계량 보고서 작성법

# 1) 거주지역 
data$resident2[data$resident == 1] <-"특별시"
data$resident2[data$resident >=2 & data$resident <=4] <-"광역시"
data$resident2[data$resident == 5] <-"시구군"

x<- table(data$resident2)
prop.table(x) # 비율 계산 
y <-  prop.table(x)
round(y*100, 2) #백분율 적용(소수점 2자리)


# 2) 성별
data$gender2[data$gender== 1] <-"남자"
data$gender2[data$gender== 2] <-"여자"
x<- table(data$gender2)

prop.table(x) # 비율 계산 
y <-  prop.table(x)
round(y*100, 2) #백분율 적용(소수점 2자리)


# 3) 나이
summary(data$age)# 40 ~ 69
data$age2[data$age <= 45] <-"중년층"
data$age2[data$age >=46 & data$age <=59] <-"장년층"
data$age2[data$age >= 60] <-"노년층"
x<- table(data$age2)
x
prop.table(x) # 비율 계산 
y <-  prop.table(x)
round(y*100, 2) #백분율 적용(소수점 2자리)


# 4) 학력수준
data$level2[data$level== 1] <-"고졸"
data$level2[data$level== 2] <-"대졸"
data$level2[data$level== 3] <-"대학원졸"

x<- table(data$level2)
prop.table(x) # 비율 계산 
y <-  prop.table(x)
round(y*100, 2) #백분율 적용(소수점 2자리)

# 5) 합격여부
data$pass2[data$pass== 1] <-"합격"
data$pass2[data$pass== 2] <-"실패"
y<- table(data$pass2)
y
prop.table(x) # 비율 계산
y <-  prop.table(x)
round(y*100, 2) #백분율 적용(소수점 2자리)

head(data)

describe(data)
summary(data$cost) 
sum(data$cost) 

describe(data)
summary(data$survey) 
sum(data$survey, na.rm=T) 

# <논문/보고서 에서 표본의 인구통계적특성 결과 제시 방법>


# 기술통계량 정제 데이터 저장 
getwd()
setwd("c:/Rwork/Part-III")
write.csv(data,"cleanDescriptive.csv", quote=F, row.names=F) # 행 이름 제거





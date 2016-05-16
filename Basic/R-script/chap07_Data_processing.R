# 1. 탐색적 데이터 분석

# 실습 데이터 읽어오기

setwd("C:/Rwork/Part-II")
dataset <- read.csv("dataset.csv", header=TRUE) # 헤더가 있는 경우
#부모에 따라 자녀의 합격여부
#1) 데이터 셋 보기

# 데이터셋 전체 보기
View(dataset) # 뷰어창 출력

# 간단이 앞쪽/뒤쪽 조회
head(dataset) 
tail(dataset) 

# 2) 데이터 셋 구조보기
names(dataset) # 변수명(컬럼)
attributes(dataset) # names(), class, row.names
str(dataset) # 데이터 구조보기

# 3) 데이터 셋 조회 
dataset$age 
dataset$resident
length(dataset$age) # data 수-300개 

x <- dataset$gender # 조회결과 변수 저장
y <- dataset$price
x;y

plot(dataset$price) # 산점도 형태 전반적인 가격분포 보기
# $기호 대신 [""]기호를 이용한 변수 조회
dataset["gender"] 
dataset["price"]

# 색인(index)으로 변수의 위치값 조회
dataset[2] # 두번째 컬럼
dataset[6] # 여섯번째 컬럼
dataset[3,] # 3번째 관찰치(행) 전체
dataset[,3] # 3번째 변수(열) 전체

# dataset 데이터 중 변수를 2개 이상 조회하는 경우
dataset[c("job","price")]
dataset[c(2,6)] 

dataset[c(1,2,3)] 
dataset[c(1:3)] 
dataset[c(2,4:6,3,1)] 

# 2. 결측치 처리 - NA 

summary(dataset$price) 
sum(dataset$price) # NA 출력

# 결측데이터 제거 방법1
sum(dataset$price, na.rm=T) # 2362.9

# 결측데이터 제거 방법2 
price2 <- na.omit(dataset$price) 
sum(price2) # 2362.9
length(price2) # 270 -> 30개 제거

# 3. 극단치 발견과 정제

# 1) 범주형 변수 극단치 처리
gender <- dataset$gender

# outlier 확인
hist(gender) # 히스토그램
table(gender) # 빈도수
pie(table(gender)) # 파이 차트

# gender 변수 정제(1,2)
data <- subset(dataset,dataset$gender==1 | dataset$gender==2)
data # gender변수 데이터 정제
length(data$gender) # 297개 - 3개 정제됨
pie(table(data$gender))

# 2) 비율척도 극단치 처리
dataset$price # 세부데이터 보기
length(dataset$price) #300개(NA포함)
plot(dataset$price) # 산점도 
summary(dataset$price) # 범위확인

# price변수 정제
data <- subset(dataset, dataset$price >= 2 & dataset$price <= 8)
#summary 결과 바탕으로 그냥 가격 범위를 저렇게 지정함 2~8
length(data$price) 
stem(data$price) # 줄기와 잎 도표보기
#줄기 - 잎, 2.1 1개 2.3은 2개
# -------------------------------------------------------------
# <실습문제1> age 변수를 대상으로 outlier를 확인하시오.

# <실습문제2> age 변수를 대상으로 20~69세 범위로 정제하시오.
# -------------------------------------------------------------
dataset$age
plot(dataset$age)
hist(dataset$age)
summary(dataset$age)

#4. 역코딩 - 긍정순서(5~1)
#만족도 조사 1. 매우만족 5.매우 불만족
#이런경우를 1을 5로 바꾸자. 그래야 점수가 높을 때 만족인 줄 앎
survey <- data$survey
csurvey <- 6-survey # 역코딩
csurvey
survey  # 역코딩 결과와 비교
data$survey <- csurvey # survery 수정
head(data) # survey 결과 확인

# -------------------------------------------------------------
# <실습문제3> 직급(position)순서(1급 -> 5급, 5급 -> 1급)으로 역코딩 하시오.
# -------------------------------------------------------------
position=data$position
position2=6-position
data$position2=position2
data[,c('position','position2')]

# 5. 코딩변경 - 나이 기준 변수 리코딩
data$age2[data$age <= 30] <-"청년층"
data$age2[data$age > 30 & data$age <=45] <-"중년층"
data$age2[data$age > 45] <-"장년층"

#6.파생변수 생성 - 기존 데이터로 새로운 변수 생성
data$resident2[data$resident == 1] <-"특별시"
data$resident2[data$resident >=2 & data$resident <=4] <-"광역시"
data$resident2[data$resident == 5] <-"시구군"
head(data) # data 테이블 전체 - age2 컬럼 생성
head(data[c("resident","resident2")]) # 2개만 지정

# -------------------------------------------------------------
# <연습문제>
# 1. resident변수의 NA 값을 제거한 후 data 변수에 저장하시오.
summary(data$resident)
length(data$resident)
a=na.omit(data$resident)
length(a)

b=subset(data1, data1$resident!='NA')
c=data1[data1$resident!='NA',]
d=data1[!is.na(data1$resident),]

#####!!!!!!!!!! ==NA 이런거 절대 쓰지마 NA판별은 is.na!!!!####
stranger=subset(data, data$age=='NA')
stranger=subset(data, is.na(data$age))
stranger1=subset(data, !is.na(data$age))


# 2. gender변수를 대상으로 1 -> 남자, 2 -> 여자 형태로 리코딩하여 
#    gender2변수에 추가한 후 파이차트로 결과를 확인하시오.
summary(data$gender)
data$gender2[data$gender==1]='남자'
data$gender2[data$gender==2]='여자'
pie(table(data$gender2))
View(data)

# 3. 나이를 30세 이하-> 1, 30~45-> 2, 45이상-> 3 으로 리코딩하여
#    age3변수에 추가한 후 age, age2, age3 변수 3개만 확인하시오.
# -------------------------------------------------------------
data$age3[data$age<=30]=1
data$age3[data$age>30&data$age<=45]=2
data$age3[data$age>45]=3

table(data$age3)
data[c('age','age3')]

# 7.정제된 데이터 및 표본 셈플링
getwd()
setwd("c:/Rwork/Part-II")

# (1) 정제된 데이터 저장
write.csv(data,"cleanData.csv", quote=F, row.names=F) 

# (2) 저장된 파일 불러오기/확인
data <- read.csv("cleanData.csv", header=TRUE)
data 
length(data$age) # 길이 확인

# (3) 표본 셈플링
choice <- sample(1:nrow(data),30) # 30개 무작위 추출

choice2 <- sample(nrow(data), 30) #sample과 동일

choice3 <- sample(50:nrow(data), 30) # 50~end

choice4 <- sample(c(50:100), 30) # 50~100


#다양한 범위를 지정해서 무작위 셈플링
sample(c(10:50, 40:150, 160:190),30)

# 마지막 행수 직접 입력
choicePrice <- sample(1:234,30) 
choicePrice # 셈플링 결과 

# 특정 변수 대상 셈플링 불가

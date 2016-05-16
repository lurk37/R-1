############################
#### 선형회귀 분석
############################

# 의료비 예측
# - 의료보험 가입자 1,338명을 대상으로 한 데이터 셋으로 의료비 인상 예측 

# 1. 데이터 셋 가져오기
setwd('C:/Rwork/ML/data')
insurance <- read.csv('insurance.csv', header = T) # insurance.csv
str(insurance)
#$ age     : int  19 18 28 33 32 31 46 37 37 60 ...
#$ sex     : Factor w/ 2 levels "female","male": 1 2 2 2 2 1 1 1 2 1 ...
#$ bmi     : num표준22, 고도비만 30이상  27.9 33.8 33 22.7 28.9 ...
#$ children: int자녀수  0 1 3 0 0 0 1 3 2 0 ...
#$ smoker  : Factor w/ 2 levels "no","yes": 2 1 1 1 1 1 1 1 1 1 ...
#$ region  : Factor w/ 4 levels "northeast","northwest",..: 4 3 3 2 2 3 3 2 1 2 ...
#$ charges : num의료비  16885 1726 4449 21984 3867
# 2. 데이터 탐색
# 1) 의료비 분포 보기 
summary(insurance$charges)
#Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#1122    4740    9382   13270   16640   63770

max(table(insurance$charges)) #2
mod=table(insurance$charges)
which(mod==2)
#1639.5631 
#평균 > 중위수 > 최빈수 : 오른쪽 비대칭(왼쪽으로 기울어짐)

# 2) 수치형 칼럼 간의 상관관계보기 
cor(insurance[c('age', 'bmi', 'children', 'charges')])
pairs(insurance[c('age', 'bmi', 'children', 'charges')])

# 3) 상관관계 시각화 
library(psych)
pairs.panels(insurance[c('age', 'bmi', 'children', 'charges')])


# 3. 회귀모델 생성
# 1) 데이터 셋 생성(7:3 비율) 
set.seed(123) # random 결과를 동일하게
idx = sample(1:nrow(insurance), 0.7*nrow(insurance))
training_ins = insurance[idx, ]
testing_ins = insurance[-idx, ]
dim(training_ins) # 936   7
dim(testing_ins) # 402   7

# 2) 회귀모델 생성
model_ins <- lm(charges ~ age + children + bmi + sex + smoker, data=training_ins)

model_ins # 절편과 기울기 보기
#(Intercept)          age     children          bmi      sexmale    smokeryes  
#-11831.9        252.0        512.4        320.3       -137.0      24114.1 

# 4. 회귀모델 평가
summary(model_ins) # Adjusted R-squared:  0.7466


# 5. 회귀모델 성능 평가 - 검정 데이터 이용
pred <- predict(model_ins, testing_ins)
pred # 검정데이터의 의료비(charges) 예측 

# 상관계수로 성능 평가 - 수치 예측이기 때문에 
cor(pred, testing_ins$charges)

#------------------------------------------------
#  모델 설명력 향상 - 비선형 x변수 추가 
#------------------------------------------------
# 모델 설명력 : 예측값(y)이 관측값(x)을 얼마나 잘 설명하는 척도
# x변수와 y변수 간의 상관성과 관련있음 -> R-squared = 상관계수^2
cor(insurance$charges,insurance$age) #0.2990082
#혹시 비선형 관계 이지 않을까?
plot(insurance$charges,insurance$age)
#오, 먼가 패턴이 있긴 하다!
test=insurance[insurance$charges<=10000,]
cor(test$charges,test$age) #0.9570132
plot(test$charges,test$age)

training_ins$age2=training_ins$age^2
#고차항 y= a + b*x + b*x^2
model_ins <- lm(charges ~ age2 + children + bmi + sex + smoker, data=training_ins)
summary(model_ins)
#기존 0.7466  -> 0.7487

###########################################
#  모델 설명력 향상 - 상호작용 x변수 추가 
###########################################
#ex) 비만이면서 흡연자는 의료비 상승 효과
#bmi * smoker
#bmi : 30이상이면 고도비만 1, 아니면 0 으로 처리 -> bmi2 칼럼
training_ins$bmi2=ifelse(training_ins$bmi>=30,1,0)
head(training_ins[,c('bmi','bmi2')])

#smoker 칼럼
head(training_ins)
str(training_ins)
# $ smoker  : Factor w/ 2 levels "no","yes": 1 2 1 1 1 1 1 1 1 1 ...
# smoker - no(1),yes(2) 얘랑 smoker*bmi를 곱하면 흡연자가 가장 숫자가 무조건 높게 나옴
#2를 곱하기 때문, 조정이 필요함--> bmi2 - 비만(1) 노비만(0)--> 비만이 아닌사람은 0으로 처리했기 때문에 상관없음

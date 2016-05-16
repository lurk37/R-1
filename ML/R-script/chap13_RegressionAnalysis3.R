###################################
#### 수치예측 관련 모델
###################################
#회귀트리: 분류방식으로 y값 예측 - rpart package
#모델트리: 선형회귀 모델 y값 예측 - RWeka package
#공통점: y를 수치로 예측하는 모델

#문)iris데이터 회귀트리와 모델트리 모델 생성
#꽃의 분류에 관한 예측력을 비교 
#조건1) x 변수 : 1~4컬럼 y변수 5칼럼
#조건2) 모델 평가는 요약통계량과 상관계수 이용

# 1. 회귀트리
#------------------------------------
install.packages('rpart')
install.packages('rpart.plot')
library(rpart) # 회귀트리 모델 생성  
library(rpart.plot) # 회귀트리 시각화 

# 1) 데이터 셋 가져오기
data(iris)

# 2) 데이터 분석/데이터 셋 생성 

iris$Species=as.numeric(iris$Species)
str(iris)
train_iris=iris[sample(1:nrow(iris),nrow(iris)*0.7),]
test_iris=iris[-sample(1:nrow(iris),nrow(iris)*0.7),]

# 3) 회귀트리 모델 생성  

model <- rpart(Species ~ ., data = train_iris)
model  #중요변수 확인 -> Petal.Length<2.5

# 회귀트리 시각화 
rpart.plot(model) # 회귀트리  

# 4) 모델 성능 평가 - 검정 데이터 이용 
pred <- predict(model, test_iris)

# (1) 요약통계량으로 평가 
summary(pred)
summary(test_iris$Species)

# (2) 상관계수로 평가 
cor(pred, test_iris$Species) #0.9858377

# 2. 모델트리(선형회귀모델 적용)  
#------------------------------------
install.packages('RWeka')
library(RWeka)
#LinearRegression()
# M5P() 얘가 더 좋아
# 3) 모델트리 모델 생성  
model_wine <- M5P(Species ~ ., data = train_iris) 
model_wine

# 4) 모델 성능 평가 - 검정 데이터 이용 
pred2 <- predict(model_wine, test_iris)

# (1) 요약통계량으로 평가 
summary(pred2)
summary(test_iris$Species)

# (2) 상관계수로 평가 
cor(pred2, test_iris$Species)
#0.9858698

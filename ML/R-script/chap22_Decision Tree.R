############################################
########### Decision Tree: 분류모형 ########
############################################

install.packages('rpart.plot')

library(rpart) # rpart() : 분류모델 생성 
library(rpart.plot) # prp() : rpart 시각화 패키지 

# 단계1. 실습데이터 생성 
data(iris)
set.seed(415)
idx = sample(1:nrow(iris), 0.7*nrow(iris))
train = iris[idx, ]
test = iris[-idx, ]
dim(train) # 105 5
dim(test) # 45  5

table(train$Species)
# 단계2. 분류모델 생성 
# rpart(y변수 ~ x변수, data)
model = rpart(Species~., data=train) # iris의 꽃의 종류(Species) 분류 
model

# 분류모델 시각화 - rpart.plot 패키지 제공 
prp(model)  

# 분류결과 상세 시각화 
plot(model) # 트리 프레임 보임
text(model, use.n=T) # 텍스트 추가
post(model, file="") # 타원제공 - rpart 패키지 제공 


# 단계3. 분류모델 평가  
pred <- predict(model, test, type="class")

# 1) 분류모델로 분류된 y변수 보기 
table(pred)

# 2) 분류모델 성능 평가 
table(pred, test$Species)


##################################################
# Decision Tree 응용실습 : 기상데이터 분석
##################################################
# 날씨 관련 데이터를 이용하여 내일 비 유무 분류

# 단계1. 실습 데이터 생성 
weatherAUS = read.csv(file.choose()) # weatherAUS.csv
dim(weatherAUS) # [1] 36881    24
names(weatherAUS) 

# Date, Location, RainToday, RISK_MM 칼럼 제외 
weatherAUS = weatherAUS[ ,c(-1,-2, -22, -23)]

set.seed(415)
idx = sample(1:nrow(weatherAUS), 0.7*nrow(weatherAUS))
train_w = weatherAUS[idx, ]
test_w  = weatherAUS[-idx, ]
dim(train_w) # 25816    20
dim(test_w) # [1] 11065    20

# 훈련데이터의 y변수 빈도수 
table(train_w$RainTomorrow)
#   No   Yes 
#19349  6019

# 단계2. 분류모델 생성 - na.action=na.omit : NA 제거 
model = rpart(RainTomorrow~., data=train_w, na.action = na.omit)
model


prp(model) # 분류모델 시각화

# 분류결과 상세 시각화 
plot(model) # 트리 프레임 보임
text(model, use.n=T) # 텍스트 추가
post(model, file="") # 타원제공 - rpart 패키지 제공 

# 단계3. 분류모델 성능 평가

pred = predict(model, test_w, type="class")

table(pred, test_w$RainTomorrow)

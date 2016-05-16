##################################################
#Neural Network 
##################################################
# 신경망(neural network) 기법은 반복적인 학습 과정을 거쳐 데이터에 내재되어 있는 
# 패턴을 찾아내고 이를 일반화함으로써 대용량 데이터로부터 의사결정에 필요한 
# 유용한 정보를 찾아내는 블랙박스 기법이다. 
# 여러 분야의 다양한 문제에 적용될 수 있고, 독립변수와 종속변수의 관계를 살피기가 
# 어려운 복잡한 데이터에 대해서도 좋은 결과를 주는 것으로 알려져 있다. 
# 하지만, 분류나 예측 결과만을 제공할 뿐 결과가 어떻게 나왔는가에 대한 
# 이유를 설명하지 못한다.

# 주요 패키지 : nnet, neuralnet 

##################################################
# Neural Network : nnet
##################################################
install.packages("nnet") # 뉴럴네트워크 
library(nnet)
?nnet
#################################
# [ANN 기초 실습] 
#################################

# 1) data frame 생성 
df = data.frame(
  x2 = c(1:6),
  x1 = c(6:1),
  y = factor(c('n','n','n','y','y','y'))
)
str(df)
df

# 2) 분류모형 생성 - nnet(formula, size = hidden 수) 
model_net1 = nnet(y ~ ., df, size = 1) # size는 분석자가 지정


# network, input, output 보기 
model_net1
#a 2-1-1 network with 5 weights #x-1-x 히든레이어 1개

# 가중치(weights) 내용 보기 
summary(model_net1) 
names(model_net1)

# 3) 분류모형 예측
model_net1$fitted.values # 변수 이용 
#          [,1]
#1 6.039043e-06 0에 가까워
#2 6.039043e-06 0에 가까워
#3 6.111250e-06 0에 가까워
#4 9.999841e-01 1에 가까워
#5 9.999842e-01 1에 가까워
#6 9.999842e-01 1에 가까워
predict(model_net1, df) # 함수 이용

p<- predict(model_net1, df, type="class") # 분류 결과(y변수) 

# 4. 분류정확도 
table(p, df$y) 

#################################
# [iris 이용 ANN 실습] 
#################################

data(iris)
set.seed(123) # random 결과를 동일하게 지
idx = sample(1:nrow(iris), 0.7*nrow(iris))
training = iris[idx, ]
testing = iris[-idx, ]
training
testing
names(training)
nrow(training) # 105(70%)


# 분류모델 생성  
model_net_iris = nnet(Species ~ ., training, size = 3) # weights:  27
#size는 은닉층 노드 수, 정규화 없이 신경망 만들기
#nnet()이용하여 backprop
#model_net_iris = nnet(Species ~ ., training, size = 3, entropy=T, abstol=0.01) # weights:  27

summary(model_net_iris) # 27개 가중치 확인 

#names 함수를 이용하여 nnet 함수의 결과에서 제공하는 항목들 보기
names(model_net_iris)


# 분류모델 평가 
predict(model_net_iris, testing) # testing data에 대한 확률값 보기 
predict(model_net_iris, testing, type = "class") # 분류 결과 보기 


# 혼돈 매트릭스 적용 
table(predict(model_net_iris, testing, type = "class"), testing$Species)


#------------------------------------------------------------
# [ANN 고려사항] 
# 과적합(overfitting)을 피하기 위해서 정규화 과정이 필요
# 최적의 Hidden layer 찾기  
#------------------------------------------------------------

##################################################
#Neural Network 응용실습 : spamfiltering
##################################################

# 단계1. 실습 데이터 가져오기
load(file.choose()) # sms_data_total.RData
ls() # 메모리 확인 -> [1] "test_sms"  "train_sms" 

# 단계2. 데이터 탐색 
dim(train_sms) # [1] 4180   74
dim(test_sms) # [1] 1394   74
names(train_sms)
table(train_sms$type) # sms 메시지 유형 

# 단계3. 모델 생성 
model_net_sms = nnet(type ~ ., train_sms, size = 10)

# 단계4. 분류모델 평가 
table(test_sms$type, predict(model_net_sms, test_sms, type = "class"))


##################################################
#Neural Network 문제 : 기상데이터 분석
##################################################
# 조건> hidden layer : 3 or 10

weatherAUS = read.csv(file.choose())	#weatherAUS.csv
names(weatherAUS)
weatherAUS = weatherAUS[ ,c(-1,-2, -22, -23)] # 칼럼 제외 

set.seed(123)
idx = sample(1:nrow(weatherAUS), 0.7*nrow(weatherAUS))
training_w = weatherAUS[idx, ]
testing_w  = weatherAUS[-idx, ]

dim(training_w) # [1] 25816    20
dim(testing_w) # [1] 11065    20
length(training_w) # 20개 칼럼 

# na 제거 
training_w2 = na.omit(training_w)
testing_w2 = na.omit(testing_w)
dim(training_w2) # [1] 12199    20
dim(testing_w2) # [1]  5179    20

# 훈련데이터의 y변수 빈도  
table(training_w2$RainTomorrow)
#  No  Yes 
#9423 2776 

# 검정데이터의 y변수 빈도  
table(testing_w2$RainTomorrow)
#  No  Yes 
#4003 1176

# 분류모델 생성 
model_w3 <- nnet(RainTomorrow ~ ., data = training_w2, size=3)
model_w10 <- nnet(RainTomorrow ~ ., data = training_w2, size=10)



# 분류모델 평가
pre_w3 <- predict(model_w3, testing_w2, type = 'class')
table(pre_w3)

pre_w10 <- predict(model_w10, testing_w2, type = 'class')

# 분류 정확도 계산 
t <- table(pre_w3, testing_w2$RainTomorrow) # Yes 분류 못함
(t[1,1]+t[2,2]) / nrow(testing_w2) # Error 발생 

t2<- table(pre_w10, testing_w2$RainTomorrow) # 81% 
(3285+891) / nrow(testing_w2)
(t2[1,1]+t2[2,2]) / nrow(testing_w2)

# 문) NN 모델을 적용하여 최적의 hidden layer node수를 찾으시오.
# 조건1> 은닉노드 수 범위 : 1 ~ 15
# 조건2> 예외처리(Exception) : Yes를 분류하지 못한 경우 
#    -> Error 원인 : t[2,2]가 없어서 연산이 불가능 
#    -> 해결방안 : t[2,2]가 없으면 정분류율 연산을 skip
# 힌트) 예측치의 값(Y의 범주값)을 이용한다.

# 조건3> 정분류율을 내림차순 정렬하여 출력 
# [참고] kNN 분류에서 최적의 K값 찾기 

result <- numeric() # 1. 빈 숫자형 벡터 생성
hidden <- numeric()
h <- 1:15 # 은닉노드 수 
for(i in h){
  cat("h = ", i, '\n')
  model_w <- nnet(RainTomorrow ~ ., data = training_w2, size=i)
  pred <- predict(model_w, testing_w2, type = 'class')
  t <- table(pred, testing_w2$RainTomorrow)
  print(t)
  class <-  ifelse(pred == 'Yes', 1, 0)
  if(sum(class) >= 1){ # No, Yes 모두 분류 
    # 2. 예외처리(Exception) 내용 추가 
    # 3. 분류정확도를 result 변수에 저장
    re = (t[1,1]+t[2,2]) / nrow(testing_w2)
    result[i] = re # i변수 이용 벡터 저장  
    cat('분류정확도 = ', re, '\n')
    hidden[i] <- i # 은닉노드 수 
  }else{
    hidden[i]<-0 # Yes 분류 못한 경우 
  }
}

# 분류정확도 내림차순 정렬 
sort(result, decreasing = T) # 내림차순 정렬 
hidden


##################################################
# Neural Network : neuralnet 
##################################################
# - 가장 최근에 나온 패키지 
# - !!y변수에 수치 데이터만 가능(범주형 변수 안됨)
# - 예) yes, no -> 1, 0 변환 
# - 은닉노드를 갖는 선형회귀 분석 방법과 유사 
# - Back Propagation 알고리즘 적용 

install.packages('neuralnet')
library(neuralnet)

data("iris")
set.seed(123) # random 결과를 동일하게 지
idx = sample(1:nrow(iris), 0.7*nrow(iris))
training_iris = iris[idx, ]
testing_iris = iris[-idx, ]
dim(training_iris) # 105   6
dim(testing_iris) # 45  6

# 1) 숫자형으로 변환 Species2 칼럼 생성 
training_iris$Species2[training_iris$Species == 'setosa'] <- 1 
training_iris$Species2[training_iris$Species == 'versicolor'] <- 2 
training_iris$Species2[training_iris$Species == 'virginica'] <- 3
training_iris$Species <- NULL # 기존 문자열 칼럼 제거 
head(training_iris); tail(training_iris)

testing_iris$Species2[testing_iris$Species == 'setosa'] <- 1 
testing_iris$Species2[testing_iris$Species == 'versicolor'] <- 2 
testing_iris$Species2[testing_iris$Species == 'virginica'] <- 3
testing_iris$Species <- NULL # 기존 문자열 칼럼 제거 
head(testing_iris); tail(testing_iris)

# 2) 정규화 함수 정의 : 0 ~ 1 범위로 정규화 
normal <- function(x){
  return (( x - min(x)) / (max(x) - min(x)))
}

# 칼럼 값 정규화 - 전체 칼럼값의 규모를 축소(0~1)
training_nor <- as.data.frame(lapply(training_iris,normal))
summary(training_nor) # 0 ~ 1 확인

testing_nor <- as.data.frame(lapply(testing_iris,normal))
summary(testing_nor) # 0 ~ 1 확인


# 3) 분류모델 생성 - 은닉 노드 1개 
# 형식) neuralnet(formula, data, hidden) 
model_net = neuralnet(Species2 ~ Sepal.Length+Sepal.Width+Petal.Length+Petal.Width, 
                      data=training_nor, hidden = 1, linear.output=FALSE)
model_net
plot(model_net) # Neural Network 모형으로 시각화 
#
# 4) 모델 성능 평가 - compute() 함수 이용 검정 데이터 예측 생성
# 모델의 정확도를 평가하기 위해서 predict() 대신 compute()함수 이용
# 예측된 꽃의 분류와 실제 값(test set) 사이의 상관관계 측정 
model_result <- compute(model_net, testing_nor[c(1:4)])
model_result$net.result # 분류 예측값 보기  

# 상관분석 : 두 수치 벡터 값의 상관계수로 두 변수 간 선형관계의 강도 측정 
cor(model_result$net.result, testing_nor$Species2)


# 5) 분류모델 성능 향상 : 은닉노드 2개 지정(backprop 적용)  
model_net = neuralnet(Species2 ~ Sepal.Length+Sepal.Width+Petal.Length+Petal.Width, 
                      data=training_nor, hidden = 2, linear.output=FALSE,
                      algorithm="backprop", learningrate=0.01) 
# algorithm="backprop" : 역전파 알고리즘 적용 
# y 설명한 것을 다시 x를 설명하게 하는 알고리즘?
# learningrate : backprop 사용시 설정
model_net

model_result <- compute(model_net, testing_nor[c(1:4)])
cor(model_result$net.result, testing_nor$Species2)  

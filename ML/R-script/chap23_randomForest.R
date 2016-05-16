##################################################
#randomForest
##################################################
# 결정트리(Decision tree)에서 파생된 모델 
# 랜덤포레스트는 앙상블 학습기법을 사용한 모델
# 앙상블 학습 : 새로운 데이터에 대해서 여러 개의 Tree로 학습한 다음, 
# 학습 결과들을 종합해서 예측하는 모델(PPT 참고)
# DT보다 성능 향상, 과적합 문제를 해결
#분류절차 : 여러개 Tree 학습 -> 모델 -> 종합(Voting) -> 예측
#DT vs RF
#DT: 한 개의 훈련데이터(Tree)로 학습하여 모델 생성
#RF: 여러개의 훈련데이터(Tree)로 학습하여 모델 생성

# 랜덤포레스트 구성방법(2가지)
# 1. 결정 트리를 만들 때 데이터의 일부만을 복원 추출하여 트리 생성 
#  -> 데이터 일부만을 사용해 포레스트 구성 
# 2. 트리의 자식 노드를 나눌때 일부 변수만 적용하여 노드 분류
#  -> 변수 일부만을 사용해 포레스트 구성 
# [해설] 위 2가지 방법을 혼용하여 랜덤하게 Tree(학습데이터)를 구성한다.

# 새로운 데이터 예측 방법
# - 여러 개의 결정트리가 내놓은 예측 결과를 투표방식(voting) 방식으로 선택 


install.packages('randomForest')
library(randomForest) # randomForest()함수 제공 

data(iris)

# 1. 랜덤 포레스트 모델 생성 
# 형식) randomForest(y ~ x, data, ntree, mtry)
#mtry 몇 개의 변수로 자식노드(가지수)를 나눌 것인가(내필기)
#자식 노드로 구분할 변수 개수 지정(강사님필기) 
model = randomForest(Species~., data=iris)  
#분로오차, 정분류율, 혼돈 matrix 제공
#따라서 별도의 모델 성능 평가 과정이 필요 없음
#앞에서 배운 것들 다 성능평가 과정 있었음...(table, t[1,1]+t[2,2]/nrow(test)막 이런거...)

# 2. 파라미터 조정 300개의 Tree와 4개의 변수 적용 모델 생성 
model = randomForest(Species~., data=iris, 
                     ntree=300, mtry=4, na.action=na.omit )
model


# 3. 최적의 파리미터(ntree, mtry) 찾기
# - 최적의 분류모델 생성을 위한 파라미터 찾기

ntree <- c(400, 500, 600)
mtry <- c(2:4)
#조합
#400-2, 400-3 400-4 
#500-2 500-3 500-4
#600-2 600-3 600-4

# 2개 vector이용 data frame 생성 
param <- data.frame(n=ntree, m=mtry)
param

for(n in param$n){# 400-600반복
  cat('ntree=',n)
  for(m in param$m){# 2-4 반복
    cat(', mtry=',m,'\n')
    model=randomForest(Species~.,data = iris,
                       ntree=n,mtry=m,na.action = na.omit)
    print(model)}
}

#주요 변수 평가를 위한 모델 생성# importance 추가해야 밑에 결과치 볼 수 있음
model2 = randomForest(Species~., data=iris, importance = T)
model2

#RF 패키지 제공 함수
importance(model2)
#MeanDecreaseAccuracy 컬럼 값으로 중요변수 파악(Petal.Length가 가장 중요변)
#MeanDecreaseGini:노드 불순도 개선에 기여하는 변수
varImpPlot(model2)

#####################################################
#randomForest: 병렬 처리(데이터 분류 방식)  
#####################################################

install.packages('foreach')
library(foreach)

m <- matrix(c(1:9), 3, 3)
m

# 칼럼 수 만큼 반복하여 각 칼럼의 평균 리턴 
# 형식) foreach(반복수) %do% 반복작업 
foreach(i=1:ncol(m)) %do% mean(m[,i]) # list type 출력

foreach(i=1:ncol(m),.combine=c) %do% mean(m[,i]) # vector type 출력

foreach(i=1:ncol(m),.combine=rbind) %do% mean(m[,i]) #row 단위로 출력

#600 Tree -> 200 씩 3개로 분류 병렬처리
model_iris=foreach(n=rep(200,3))%do%
  randomForest(Species~., data=iris, ntree=n)
model_iris
#combine 옵션
model_iris=foreach(n=rep(200,3), .combine = combine)%do% #3개를 한꺼번에 묶어서 계산함
  randomForest(Species~., data=iris, ntree=n)
model_iris

#####################################################
#randomForest: 병렬 처리(multi core 방식) 
#####################################################
library(randomForest) 
library(foreach)
install.packages('doParallel')
library(doParallel) 

# 멀티코어(4개 cpu 사용) 방식의 병렬 처리
registerDoParallel(cores=4) # multicore수 4개 지정  
getDoParWorkers() # 현재 사용 가능한 core 수 보기 

system.time(
  rf_iris <- foreach(ntree=rep(250, 8), .combine=combine, .multicombine=TRUE, .packages = 'randomForest') %dopar%
    randomForest(Species~., data=iris, ntree=ntree, na.action=na.omit )
)

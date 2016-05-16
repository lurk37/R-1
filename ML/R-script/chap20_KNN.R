##################################################
#  k-Nearest Neighbors(kNN) 알고리즘 분류모형    #
##################################################
# 최근접 이웃(kNN) : k개의 인접한 값을 찾아서 분류 
# 비모수적 방법의 분류모형 -> y를 몰라도 돌려도 됨
# 거리를 기반으로 계산하여 분류모형 생성(수치만 가능)
# 게으른 학습: traing을 학습하지 않고 바로 test랑 돌림
# 유클리드안 거리 계산법 적용 
#NA처리 못함, 전처리 필요
#ex)토마토 -> 과일? or 야채?
#cf. K개 알고리즘: k-means: 군집분석
# kNN 개념 예제(p.102) - 1-과일2개, 2-단백질2개, 3-채소2개 
#grape <- c(8, 5) # 과일(단맛, 아삭거림)
#fish <- c(2, 3) # 단백질 
#carot <- c(7, 10) # 채소
#orange <- c(7, 3) # 과일
#celery <- c(3, 8) # 채소
#cheese <- c(1, 1) # 단백질 

# 1. train data 생성
# y변수 factor vector : 분류그룹y(1-과일, 2-단백질, 3-채소)
#x1: 단맛 x2: 아삭거림
train_df = data.frame(x1 = c(8, 2, 7, 7, 3, 1), 
                      x2 = c(5, 3, 10, 3, 8, 1), 
                      y=factor(c(1, 2, 3, 1, 3, 2)))
train_df
plot(train_df$x1, train_df$x2, col=train_df$y, xlab='단맛', ylab='아삭거림')

#------------------------------------------------------------
# !새로운 데이터가 들어왔다! 토마토 : 단맛=6, 아삭거림=4 일때 어떤 분류에 속하는가 ?
#------------------------------------------------------------
# 유클리드안 거리계산식 적용 : 두 점의 차, 제곱, 합, 제곱근
sqrt((8-6)^2 + (5-4)^2) # 포도와 토마토 - 2.236068
sqrt((7-6)^2 + (10-4)^2) # 당근과 토마토 - 6.082763
sqrt((7-6)^2 + (3-4)^2) # 오랜지와 토마토 - 1.414214
sqrt((3-6)^2 + (8-4)^2) # 셀러리와 토마토 - 5

#[해석]
#k=1 -> 1NN: 오렌지 1.414214
#k=3 -> 3NN: 오렌지, 포도, 샐러리 -> 과일(2),야채(1) -> Voting -> 토마토는 과일이닷!

# 2. test data 생성 : 새로운 항목 - 토마토(6,4), 땅콩(3,6), 사과(10,9)
test_df = data.frame(x1=c(6,3,10), x2=c(4,6,9))
test_df

# 3. kNN 분류모델 생성 
library(class) # knn()함수 제공 

# k값(최근접 개수) 구하기 #train데이터로~
sqrt(length(train_df$y)) # 6의 제곱근 : 2.44949 -> 홀수값 지정(홀수가 효율이 좋데) 

# 형식) knn(훈련데이터, 검정데이터, 훈련데이터 y변수, k)
knn(train_df[, -3], test_df, train_df$y, k=3) # prob=TRUE : 예측 의미
#[1] 1 3 1  
#Levels: 1 2 3


###############################
# kNN 분류모형 : 간단 실습    # 
###############################
# 1. data 생성 
data(iris)
set.seed(415) # random 결과를 동일하게 지정
idx = sample(1:nrow(iris), 0.7*nrow(iris))
training = iris[idx, ]
testing = iris[-idx, ]
training
testing
names(training)

# 2. 분류모델 생성 
model.knn = knn(training[, -5], testing[, -5], training$Species, k = 3, prob=TRUE)
model.knn
summary(model.knn)

# 3. 분류모델 평가(검정데이터 적용) 
table(model.knn, testing$Species)


# 4. 분류모델 성능 평가 - 분류 정확도 
# 분류정확도 = 정분류 / test set 길이 
(14+14+13)/nrow(testing)#0.9111111

###############################
# kNN 분류모델 : 응용 실습    # 
###############################

# 1. 데이터셋 가져오기 
#"wdbc_data.csv" : 유방암 진단결과 데이터 셋
# Wisconsin Diagnostic Breast Cancer (WDBC) : 위스콘신 유방암 센터 
#https://archive.ics.uci.edu/ml/machine-learning-databases/breast-cancer-wisconsin/
#wdbc.data 파일로 제공
#1. Title: Wisconsin Diagnostic Breast Cancer (WDBC) : 
#  2. Source Information
#a) Creators:
#  Dr. William H. Wolberg, General Surgery Dept., University of
#Wisconsin,  Clinical Sciences Center, Madison, WI 53792
#wolberg@eagle.surgery.wisc.edu

#W. Nick Street, Computer Sciences Dept., University of
#Wisconsin, 1210 West Dayton St., Madison, WI 53706
#street@cs.wisc.edu  608-262-6619

#Olvi L. Mangasarian, Computer Sciences Dept., University of
#Wisconsin, 1210 West Dayton St., Madison, WI 53706
#olvi@cs.wisc.edu
#b) Donor: Nick Street
#c) Date: November 1995
#3 .569개 관측치와 32개 칼럼 구성
#a) 위스콘신 유방암 센터에서 유방암 진단결과를 기록한 데이터 셋
#b) id, diagnosis(진단결과-M(악성),B(양성)), 30개 수치'
wdbc <- read.csv('C:/Rwork/ML/data/wdbc_data.csv', stringsAsFactors = FALSE)
str(wdbc)


# 2. 데이터 탐색 및 전처리 
wdbc <- wdbc[-1] # id 칼럼 제외 
head(wdbc)
head(wdbc[, c('diagnosis')], 10)

# 1) 목표변수(y변수)를 factor형으로 변환 
wdbc$diagnosis <- factor(wdbc$diagnosis, levels = c("B", "M"))#순서가 없어서 levels 빼도 됨
str(wdbc$diagnosis)
# 백분율 적용 빈도수 보기  
table(wdbc$diagnosis)
prop.table(table(wdbc$diagnosis)) * 100

# 2) x변수 보기 : 30개 실험 측정치 칼럼 
summary(wdbc[,c(2:31)])
#->컬럼들끼리 중간값이 너무 달라
#->overfit 과적합 문제 생김 -> 정규화 시켜야함
# 3) 수치 데이터 정규화
#서로 다른 특징을 갖는 칼럼을 대상으로 유사한 범주값으로 값을 재조정하는 것
#ex)작은값 : 0, 중간 값 : 0.5, 큰 값: 1 으로 변형시킴
normalize <- function(x){ # 정규화를 위한 함수 정의 
  return ((x - min(x)) / (max(x) - min(x)))
}
normalize(c(123,0.0002,1453))
#[1] 0.08465232 0.00000000 1.00000000

# wdbc[2:31] : x변수에 해당한 칼럼 대상 정규화 수행 
wdbc_x <- as.data.frame(lapply(wdbc[2:31], normalize))
head(wdbc_x)
summary(wdbc_x) #정규화가 되었넹 확인!
class(wdbc_x) # [1] "data.frame"
nrow(wdbc_x) # [1] 569

# 4) 훈련데이터와 검정데이터 생성 : 7 : 3 비율 
set.seed(415) # 시드값 적용 - 동일한 랜덤값 제공 
idx = sample(1:nrow(wdbc_x), 0.7*nrow(wdbc_x))
wdbc_train = wdbc_x[idx, ] # 훈련 데이터 
wdbc_test = wdbc_x[-idx, ] # 검정 데이터 
dim(wdbc_train) # [1] 398  30
dim(wdbc_test) # [1] 171  30

# 원본 데이터에서 y변수가 포함된 칼럼값 저장 - 분류모델 결과 확인용  
wdbc_train_y <- wdbc[idx, 1] # 훈련 데이터의 diagnosis 칼럼 
wdbc_test_y <- wdbc[-idx, 1] # 검정 데이터의 diagnosis 칼럼 


# 3. kNN 분류모델 생성 

# k값 구하기 - 훈련데이터의 제곱근
dim(wdbc_train) # [1] 398  30
k = sqrt(398)
k # 19.94994 -> k = 19(홀수 지정 )
wdbc_pred <- knn(wdbc_train, wdbc_test, wdbc_train_y, k=19)
wdbc_pred # 분류예측모델 


# 4. kNN 분류모델 성능 평가 

# 검정데이터의 y변수와 분류모델 예측치와 비교 평가  
table(wdbc_pred, wdbc_test_y) # 행 : 분류예측치, 열 : 원본 data 

# 분류정확도 
(110+54)/ nrow(wdbc_test) # [1] 0.9590643 - 96% 정확도                 

#최적의 k 값 구하기 
k=5:25
result=numeric() 
for (i in k) {
  cat("k=",i,'\n')
  wdbc_pred <- knn(wdbc_train, wdbc_test, wdbc_train_y, k=i)
  t=table(wdbc_pred,wdbc_test_y)
  re=(t[1,1] + t[2,2])/nrow(wdbc_test)
  result[i]=re
  cat('분류정확도=',re,'\n')
}
####여기 필기 해야함 ####
# 문3) 가장 좋은 분류정확도를 갖는 k만 출력하시오.
for(i in k){
  #cat("k = ", i, '\n')
  wdbc_pred <- knn(wdbc_train, wdbc_test, wdbc_train_y, k = i)
  t <- table(wdbc_pred, wdbc_test_y)
  # print(t)
  # if()함수 이용하여 st[1]과 동일한 k만 출력 
  re = (t[1,1]+t[2,2]) / nrow(wdbc_test)
  if(re == st[1]){
    cat("k = ", i, '\n')
    print(t) # 혼돈 matrix 출력
    cat('분류 정확도: ')
    print(re) # 분류정확도 출력
  }
}



############여기까지 강사님 답변#########33
which(result==max(result, na.rm = T))


####################################
# 문제 : 기상데이터 분류분석
####################################
# 기상데이터를 이용하여 내일 비(RainTomorrow) 유무를 kNN 알고리즘을 적용하여 분류하시오.
# <조건1> y변수 : RainTomorrow, x 변수 : 1,2,22,23 칼럼을 제외한 나머지 
# <조건2> 7:3 비율로 train, test 데이터 분리
# <조건3> 모델 성능 향상을 위한 최적의 K값 찾기

#Weatehr data set
weatherAUS = read.csv('C:/Rwork/ML/data/weatherAUS.csv')	#weatherAUS.csv
str(weatherAUS)
t(colnames(weatherAUS))
weather=weatherAUS[,c(-1,-2,-22,-23)]
weather1=na.omit(weather) 
t(colnames(weather1))
weather1[,1:19]=as.numeric(weather1[,1:19])
weather1[,1:19]=as.numeric(weather1[,1:19])

as.numeric(weather1$WindGustDir)

str(weather1)
b=head(weather$Cloud9am)
as.numeric(b)

train=weather[sample(1:nrow(weather),0.7*nrow(weather)),]
test=weather[-sample(1:nrow(weather),0.7*nrow(weather)),]
dim(train);dim(test) #[1] 25816    20 [1] 11065    20

# k값(최근접 개수) 구하기
sqrt(nrow(train)) # 6의 제곱근 : 2.44949 -> 홀수값 지정(홀수가 효율이 좋데) 

# 형식) knn(훈련데이터, 검정데이터, 훈련데이터 y변수, k)
knn(train[, -20], test, train$RainTomorrow, k=160) # prob=TRUE : 예측 의미
#[1] 1 3 1  
#Levels: 1 2 3

dim(train)
str(train)

##################################################
# Naive Bayes 알고리즘 
##################################################
# 조건부 확률 적용 예측 
# 비교적 성능 우수
# 베이즈 이론 적용
#  -> 조건부 확률 이용 
#  -> 스펨 메시지 분류에 우수함
#대량의 데이터일 경우 더 훌륭함
#x변수 factor 도 가능, knn은 안됨

# 조건부 확률 : 사건 A가 발생한 상태에서 사건 B가 발생할 확률 
# P(B|A) = P(A|B) * P(B) / P(A)
#ex) 비아그라 단어가 포함된 sms 메시지 대상 스팸 확률
# p(A): 스팸(20%), p(B): 비아그라(5%) 
#p(B|A): 스팸 일 때, 비아그라 일 경우 (5/20=0.25)

#수식 1)
#P(스팸|비아그라) = P(비아그라|스팸)*p(스팸) / p(비아그라)

#수식 2)
#P(스팸|비아그라) = P(비아그라|스팸)/ p(비아그라)*p(스팸) 


##################################################
# Naive Bayes 기본실습 : iris
##################################################

# 패키지 설치 
install.packages('e1071')
library(e1071) # naiveBayes()함수 제공  #나이브 베이지 중에 얘가 젤 우수하데

# 1. train과 test 데이터 셋 생성  
data(iris)
set.seed(415) # random 결과를 동일하게 지정
idx = sample(1:nrow(iris), 0.7*nrow(iris)) # 7:3 비율 

train = iris[idx, ]
test = iris[-idx, ]
train; test
nrow(train) # 105

# 2. 분류모델 생성(분류기) : train data 이용    
# 형식) naiveBayes(train, class) - train : x변수, calss : y변수
model = naiveBayes(train[-5], train$Species) 
model # 105개 학습 데이터를 이용하여 x변수(4개)를 y변수로 학습시킴  


# 3. 분류모델 평가(예측기): test data 이용 
# 형식) predict(model, test, type='class')  #type class로 분류하겠다 = default
p <- predict(model, test, type='class') # test : y변수가 포함된 데이터 셋
p   

# 4. 분류모델 평가(예측결과 평가) 
table(p, test$Species) # 예측결과, 원형 test의 y변수   


# 분류 정확도

##################################################
# Naive Bayes 응용실습 : 기상데이터 분석
##################################################

# 1. 데이터 가져오기 
weatherAUS = read.csv(file.choose())	#weatherAUS.csv 선택 
weatherAUS = weatherAUS[ ,c(-1,-2, -22, -23)] # 칼럼 제외 

# 2. 데이터 생성/전처리  
set.seed(415)
idx = sample(1:nrow(weatherAUS), 0.7*nrow(weatherAUS))
train_w = weatherAUS[idx, ]
test_w  = weatherAUS[-idx, ]

head(train_w)
head(test_w)
dim(train_w) # [1] 25816    20
dim(test_w) # [1] 11065    20

train_w=na.omit(train_w)
test_w=na.omit(test_w)

# 3. 분류모델(분류기) 생성 : train data 이용    
# 형식2) niveBayes(y변수 ~ x변수, data)  
model = naiveBayes(RainTomorrow ~ ., data = train_w)
model

# 4. 분류모델 평가(예측기) : test data 이용 
# 형식) predict(model, test, type='class')
p<- predict(model, test_w)
table(p, test_w$RainTomorrow)



# ----------------------------------------------------------
# 가상데이터에 대한 정분류율, 오분류율, 정밀도, 민감도 
# ----------------------------------------------------------
tab <- table(p, test_w$RainTomorrow)

# 분류정확도 

#정밀도: 분류모델이 정답이라고 한 것 중 실제 정답 수
tab[2,2]/sum(tab[2,])

#민감도: 실제 참인 것 중에서 실제 정답 수 
tab[2,2]/sum(tab[,2])
#정밀도와 민감도는 반비례 관계

################################################
# Naive Bayes 문제 : spam 메시지 필터링
################################################
# Spam 메시지 데이터 셋을 이용하여 NB 분류모델을 생성하고.
# 정분류율/오분류율/정밀도를 구하시오. 

# 실습 데이터 가져오기(TM에서 전처리한 데이터) 
sms_data = read.csv('C:/Rwork/ML/data/sms_spam_tm.csv') # sms_spam_tm.csv
#sms_spam.csv 파일을 대상으로 tm 패키지에서 
#제공되는 함수들을 이용하여 문장을 단어로 추출하는 
#전처리 과정을 걸쳐서 DocumentTermMatrix 형태의 
#희소행렬로 만들어진 파일이다.
#<파일 내 희소행렬 구성 예> 
#  sms_type  aah    aaniy  aaooooright  aathilov   aathiwher	abbey	abdomen
#1	ham	NO	NO	NO	NO	NO	NO	NO
#2	ham	NO	NO	NO	NO	NO	NO	NO
#3	ham	NO	NO	NO	NO	NO	NO	NO
#4	spam	NO	NO	NO	NO	NO	NO	NO
#5	spam	NO	NO	NO	NO	NO	NO	NO
#6	ham	NO	NO	NO	NO	NO	NO	NO
#<column 설명>
#  sms_type : spam 또는 ham 구분 범주형 변수(y변수)
#두번째 이후 칼럼 : 해당 문서에 포함된 단어 유무를 NO/YEST로 나타냄(x 변수)
head(sms_data[,c(1:10)],3) # 1행 10칼럼(단어) 보기 
dim(sms_data) # [1] 5558(row) 6824(word)
table(sms_data$sms_type)

# 1. train과 test 데이터 셋 생성  
set.seed(415) # random 결과를 동일하게 지정
idx = sample(1:nrow(sms_data), 0.7*nrow(sms_data)) # 7:3 비율 

train = sms_data[idx, ]
test = sms_data[-idx, ]
nrow(train) 

# 2. 분류모델 생성(분류기) : train data 이용    
# 형식) naiveBayes(train, class) - train : x변수, calss : y변수
model = naiveBayes(train[,c(-1,-2)], train$sms_type) 

# 3. 분류모델 평가(예측기): test data 이용 
# 형식) predict(model, test, type='class')  #type class로 분류하겠다
p <- predict(model, test, type='class') # test : y변수가 포함된 데이터 셋
p   

# 4. 분류모델 평가(예측결과 평가) 
table(p, test$sms_type) # 예측결과, 원형 test의 y변수   
97.84
(1431+201)/nrow(test)



###################################################
# 연관분석(Association Analysis)
###################################################
# 활용분야
# - 대형 마트, 백화점, 쇼핑몰 등에서 고객의 장바구니에 들어있는 품목 간의 
#   관계를 탐구하는 용도
# ex) 고객들은 어떤 상품들을 동시에 구매하는가?
#   - 맥주를 구매한 고객은 주로 어떤 상품을 함께 구매하는가?

#########################################
# 1. 연관규칙 평가 척도
#########################################

# 연관규칙의 평가 척도
# 1. 지지도(support) : 전체자료에서 관련 품목의 거래 확률
#  -> A와 B를 포함한 거래수 / 전체 거래수
# 2. 신뢰도(confidence) : A가 구매될 때 B가 구매될 확률(조건부 확률)
#  -> A와 B를 포함한 거래수 / A를 포함한 거래수
# 3. 향상도(Lift) : 상품 간의 독립성과 상관성을 나타내는 척도 
#  -> 신뢰도 / B가 포함될 거래율

# <지지도와 신뢰도 예시>
# t1 : 라면,맥주,우유
# t2 : 라면,고기,우유
# t3 : 라면,과일,고기
# t4 : 고기,맥주,우유
# t5 : 라면,고기,우유
# t6 : 과일,우유

#         A -> B                지지도        신뢰도        향상도
# 맥주 -> 고기             1/6=0.166    1/2=0.5      0.5/(4/6)=0.75
#라면,맥주 ->우유          1/6          1/1             1/(5/6)=1.2

#  [해설]
# 지지도 : 지지율이 낮다는 의미는 A와 B 상품의 조합이 적다.(거래수가 작다.)
# 신뢰도 : 신뢰도가 낮다는 의미는 A 구매시 B를 구매할 거래수가 적다.
# 향상도 : 향상도가 1이상이면 A와 B 상품간의 상관성이 높다.(1미만 음의 상관)

## 연관성 규칙 분석을 위한 패키지
install.packages("arules") # association Rule
# read.transactions(), inspect(), apriori(), Adult 데이터셋 제공
library(arules) #read.transactions()함수 제공


# 1. transaction 객체 생성(파일 이용)
setwd("c:/Rwork/Part-IV")
tran<- read.transactions("tran.txt", format="basket", sep=",")
tran
# 2. transaction 데이터 보기
inspect(tran)

# 3. rule 발견(생성) - 지지도,신뢰도 = 0.1
# 형식) apriori(transaction data,  parameter=list(supp, conf))

rule<- apriori(tran, parameter = list(supp=0.3, conf=0.1)) # 16 rule
rule<- apriori(tran, parameter = list(supp=0.1, conf=0.1)) # 35 rule 
inspect(rule) # 규칙 보기


#########################################
# 2. 트랜잭션 객체 생성과 연관규칙 생성 
#########################################

#형식)
#read.transactions(file, format=c("basket", "single"),
#      sep = NULL, cols=NULL, rm.duplicates=FALSE,encoding="unknown")
#----------------------------------------------------------------------------------
# format : data set의 형식 지정(basket 또는 single)
# -> single :  transaction ID에 의해서 상품(item)이 대응된 경우
# -> basket : 여러개의 상품으로 구성 -> transaction ID 없이 여러 상품(item) 구성
# sep : 상품 구분자
# cols : single인 경우 읽을 컬럼 수 지정, basket은 생략(transaction ID가 없는 경우)
# rm.duplicates : 중복 트랜잭션 항목 제거
#----------------------------------------------------------------------------------

# (1) single 트랜잭션 객체 생성
setwd("c:/Rwork/Part-IV")
stran <- read.transactions("demo_single",format="single",cols=c(1,2)) 
inspect(stran)

# [실습] 중복 트랜잭션 객체 생성
stran2<- read.transactions("single_format.csv", format="single", sep=",", 
                           cols=c(1,2), rm.duplicates=T)
stran2
#transactions in sparse format with
#248 transactions (rows) and
#68 items (columns)


# (2) basket 트랜잭션 데이터 가져오기
btran <- read.transactions("demo_basket",format="basket",sep=",") 
inspect(btran) # 트랜잭션 데이터 보기
  
#-----------------------------------------------
#  연습문제1 - 트랜잭션 객체 생성 관련
#-----------------------------------------------
# <연습문제1> tranExam.csv 파일을 대상으로 single 형식으로 1~2컬럼만 
#                    중복항목을 제거하여 트랜잭션 객체를 생성하시오.

# transcation으로 가져오기(칼럼1 : Transaction ID, 칼럼2 : item)
setwd("c:/Rwork/Part-IV")
tranExam<- read.transactions("tranExam.csv",format="single", sep=",", cols=c(1,2), rm.duplicates=T)

# <조건1> 트랜잭션 데이터를 확인한다.
inspect(tranExam)
# <조건2> 각 item별로 빈도수를 구한다.

# <조건3> supp=0.3, conf=0.1를 지정한 후 발견된 규칙(rule) 수를 작성한다.
rule<- apriori(tranExam, parameter = list(supp=0.3, conf=0.1)) #  rule 

# <조건4> 10번째 규칙의 지지도, 신뢰도, 향상도 수치를  작성한다.
inspect(rule)




##############################################
# 3. 연관규칙 시각화(Adult 데이터 셋 이용)
##############################################
install.packages('arules')
library(arules)
data(Adult) # arules에서 제공되는 내장 데이터 로딩
################ Adult 데이터 셋 #################
# 32,000개의 관찰치와 15개의 변수로 구성되어 있음
# 종속변수에 의해서 년간 개인 수입이 5만달러이상 인지를
# 예측하는 데이터 셋으로 transactions 데이터로 읽어온
# 경우 48,842행과 115 항목으로 구성된다.
##############################################
str(Adult) # Formal class 'transactions' , 48842(행)
Adult
summary(Adult)

# [data.frame 형식으로 보기]
adult<- as(Adult, "data.frame") # data.frame형식으로 변경 
adult

# apriori() : 알고리즘을 적용하여 연관규칙을 발견하는 함수 
apriori(Adult) # support : 0.1(10%), confidence : 0.8(80%) 
#-----------------------------------------------------------------
# 지지도 10%, 신뢰도 80%이 적용된 연관규칙 6137 발견   
#-----------------------------------------------------------------

ar1<- apriori(Adult, parameter = list(supp=0.2)) # 지도도 높임
ar1<- apriori(Adult, parameter = list(supp=0.2, conf=0.95)) 
ar1<- apriori(Adult, parameter = list(supp=0.3, conf=0.95)) 
ar1<- apriori(Adult, parameter = list(supp=0.35, conf=0.95)) 
ar1<- apriori(Adult, parameter = list(supp=0.4, conf=0.95)) 

# 결과보기
inspect(head(ar1)) # 상위 6개 규칙 제공 -> inspect() 적용

# 데이터 정렬(lift(향상도)를 내림차순으로 상위 3개 레코드 출력)
inspect(head(sort(ar1, by="lift"),3)) # 1레코드만 -> 결혼여부,백인,남자,국적
ar1

## 연관성 규칙에 대한 데이터 시각화를 위한 패키지
install.packages("arulesViz") 
library(arulesViz) # rules값 대상 그래프를 그리는 패키지

plot(ar3) # 지지도(support), 신뢰도(conf) , 향상도(lift)에 대한 산포도
plot(ar4, method="graph") #  67 rule(s) 적용 연관 네트워크 그래프

#-------------------------------------
#  연습문제2 - 연관분석 관련  
#-------------------------------------
#<연습문제2> Adult 데이터셋을 대상으로 다음 조건에 맞게 연관분석을 수행하시오.

# <조건1> 최소 support가 0.5가 되고, 최소 confidence가 0.9가 되도록 연관규칙을 생성하시오.
ar1<- apriori(Adult, parameter = list(supp=0.5, conf=0.9)) 

# <조건2> 수행한 결과를 lift 기준으로 정렬하여 상위 10개 패턴을 확인한다.
inspect(head(sort(ar1, by="lift"),10)) 

# <조건3> 연관분석 결과 시각화 하시오.(산포도/네트워크형 그래프)
#-----------------------------------------------------------------------------------------

plot(ar1) # 지지도(support), 신뢰도(conf) , 향상도(lift)에 대한 산포도
plot(ar1, method="graph") #  67 rule(s) 적용 연관 네트워크 그래프


#########################################
# 4. 연관규칙 결과 해석
# - basket 형식의 transaction 객체 대상 
#########################################
setwd("c:/Rwork/Part-IV")
result <- read.transactions("basket_format.csv", format="basket")
result
summary(result) # 기술통계 제공
str(result) 

rules <- apriori(result, parameter=list(supp=0.1, conf=0.1)) 
inspect(rules) # 82개 규칙 - 연관성 조사 함수

# supp=0.3으로 지지도를 높인 경우 support가 0.3이상인 결과만 나옴
rules <- apriori(result, parameter=list(supp=0.3, conf=0.1)) 
rules 
inspect(rules) # 28개 규칙 

plot(rules) # 지지도와 신뢰도, 향상도에 대한 산포도 그래프
plot(rules, method="grouped")# LHS와 RHS 간의 지지도(size)와 향상도(color)

plot(rules, method="graph", control=list(type="items")) 
# 각 규칙별로 어떤 item들이 연관되어 있는지 네트워크 그래프로 보여줌

plot(rules, method="graph", interactive=TRUE, control=list(type="items"))
# interactive=TRUE 별도의 창 제공

#########################################
# 5. <<식료품점 파일 예제>> 
#########################################

# transactions 데이터 가져오기
data("Groceries")
str(Groceries)
Groceries
# <<식료품점 데이터 로딩>>
#data(Groceries)
#Groceries
#transactions in sparse format with
#9835 transactions (rows) and
#169 items (columns)

#itemFrequencyPlot(Groceries, topN=20, type="absolute") # 상위 20개 토픽
# 지지도 0.001, 신뢰도 0.8
rules <- apriori(Groceries, parameter=list(supp=0.001, conf=0.8))
# writing ... [410 rule(s)] done [0.00s].
inspect(rules) 

# 최대 길이 3이내로 규칙 생성
rules <- apriori(Groceries, parameter=list(supp=0.001, conf=0.8, maxlen=3))
# writing ... [29 rule(s)] done [0.00s].
inspect(rules) # 29개 규칙

# confidence(신뢰도) 기준 내림차순으로 규칙 정렬
rules <- sort(rules, decreasing=T, by="confidence")

library(arulesViz) # rules값 대상 그래프를 그리는 패키지
plot(rules, method="graph", control=list(type="items"))


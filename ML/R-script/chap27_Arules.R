# chap06_Arules
library(arules)


# 1. data 가져오기

# groceries.csv는 희소행렬구조(행: 거래, 열 : 식품) 
groceries <- read.transactions(file.choose(), sep = ',') # groceries.csv
groceries # 거래와 식품 정보 제공 


# 2. data 탐색/특성 보기 

# 1) 거래수/상품수, 주요 식품목록, 식품에 대한 거래수 제공 
summary(groceries)  


# 2) 거래에서 출현 빈도수가 높은 상위 15개 식품 시각화
itemFrequencyPlot(groceries, topN = 15)  


# 3) transction 거래 식품 보기
inspect(groceries[1:10])  


# 4) 상품빈도수 보기
itemFrequency(groceries[, 1:5]) 


# 5) 희소행렬에서 식품에 대한 거래 내역 시각화 
image(groceries[1:5]) # 5개 거래(row)에 대한 식품(column) 내역 시각화

image(sample(groceries, 50)) # 50개 거래 샘플의 식품 시각화 


# 3. 연관모델 생성 
arules <- apriori(groceries, parameter = list(support=0.1, confidence=0.8, minle=1)) # 0 rule
# parameter default : support=0.1, confidence=0.8, minle=1
arules <- apriori(groceries, parameter = list(support=0.01, confidence=0.08, minle=1)) # 472 rule

summary(arules) # 규칙이 갖고 있는 상품 수, 연관규칙 척도 제공  

inspect(arules) # 규칙 보기 

# 4. 연관모델 규칙 분석
inspect(sort(arules, by = 'lift')[1:10]) # 최상위 향상도 보기 

# 1) butter 식품과 자주 구매하는 식품 검색하기  
butter <- subset(arules, lhs %in% 'butter') #left에 있는 거 중에 butter만 포함되어 있는 룰만
butter # set of 8 rules 
inspect(butter) # 내용 보기 


# 2) 연관규칙 시각화
install.packages("arulesViz") 
library(arulesViz) # rules값 대상 그래프를 그리는 패키지

plot(butter) # 지지도(support), 신뢰도(conf) , 향상도(lift)에 대한 산포도
plot(butter, method="graph") #  butter 식품과 연관 상품 네트워크 그래프


# 3) 연관규칙에서 관련 상품찾기 

# (1) whole milk와 함께 구매하는 상품 검색 
milk <- subset(arules, lhs %in% 'whole milk')
milk # set of 73 rules 
inspect(milk)

# (2) berries
berries <- subset(arules, lhs %in% 'berries')
berries # set of 3 rules 
inspect(berries)

# (3) berries 또는 yogurt 일치 
beryog <- subset(arules, lhs %in% c('berries','yogurt'))
beryog # set of 52 rules 
inspect(beryog)


# (4) rhs에서 yogurt 보기 
yogurt <- subset(arules, rhs %in% 'yogurt') 
yogurt # set of 39 rules
inspect(yogurt)

# (5) rhs에서 포함 문자로 식품 검색
yogurt <- subset(arules, rhs %pin% 'other') 
#xxx other, other xxx 인 식품 검색 => pin
yogurt # set of 39 rules
inspect(yogurt)

# 문) 채소(vegetables)와 함께 구매하는 관련 규칙들 다음과 같이 분석하시오.
# 조건1> rhs(오른쪽) 대상 서브셋 작성
# 조건2> 향상도 상위 20에 해당하는 규칙 출력
# 조건3> 조건2의 결과를 대상으로 식품 간의 연관 네트워크 시각화

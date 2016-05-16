# chap06_Kmeans.R

##### k-평균(k-mean)을 활용한 군집화 -------------------
## 예제 : 10대들의 성향을 분석하여 마케팅에 활용
### SNS 계정을 가진 30,000명 대상 4개 기본정보와 36개 관심분야 데이터 수집  
#10대들의 성향을 분석하여 마케팅에 활용하기 위해서
#SNS 계정을 가진 30,000명을 대상으로 대상 4개 기본정보와 36개 관심분야를
#대상으로 수집한 데이터 셋이다.

#<주요 칼럼 설명>
#  gradyear : 업년도 
#gender : 성별 NA 발견 
#age : 나이
#friends : 친구수
#나머지 36개 : 관심분야 

## 1단계 : 데이터 준비와 살펴보기 ----
teens <- read.csv(file.choose()) # snsdata.csv
str(teens) # 'data.frame':	30000 obs. of  40 variables:


## 2단계 : 데이터 탐색 및 전처리

# 1) gender 변수 전처리 - 30,000개 관측치 유지
table(teens$gender)
table(teens$gender, useNA = "ifany") # NA 포함 빈도수 보기  

summary(teens$age) # NA's 5086

# 30,000개 관측치 유지 - 이상치는 NA 처리 
teens$age <- ifelse(teens$age >= 13 & teens$age < 20, teens$age, NA)
summary(teens$age) # NA's 5523


# 2) 나이 결측치 처리 - 30,000개 관측치 유지 
mean(teens$age, na.rm = T)

# 집단별 나이 - 졸업년도별 나이 평균계산  
aggregate(age ~ gradyear, data = teens, mean, na.rm = TRUE)

# 나이가 NA인 경우 졸업년도 평균 나이로 대체 
f = function(x){ mean(x, na.rm = T)} # NA 제거 평균계산

# f 함수를 적용하여 반복적으로 그룹의 평균 벡터 반환
avg <- ave(teens$age, teens$gradyear, FUN = f) # FUN = f
head(avg) 
length(avg) 

# NA이면 avg 변수값으로 대체 - ex) 2006 -> 18.65586 으로 대체됨  
teens$age <- ifelse(is.na(teens$age), avg, teens$age)
summary(teens$age) # NA 제거됨 



## 3단계 : 데이터 정규화 

# # 36개 관심분야 칼럼 대상 정규화 
interests <- teens[5:40]  
summary(interests)
interests_n <- as.data.frame(lapply(interests, scale))
#nomalrize하는거 scale
summary(interests_n)


## 4단계 : 데이터로 군집모델 생성 
teen_clusters <- kmeans(interests_n, 5) # k = 5


## 5단계 : 모델 성능 평가
# 군집의 크기 확인
teen_clusters$size # 각 군집 크기 
# 2154 16178  3789   774   707

# 각 군집 중앙점(centers) 확인
teen_clusters$centers # 양수이면 평균 이상 
#보통 학생들을 이렇게 나눠도 됨 
#결과랑 비교 한 번 해
# 1그룹(무기력) : 모든 칼럼 값이 음수(대부분 평균 이하 칼럼)
# 2그룹(브레인) : 대체적으로 스포츠 약함, (무기력 다음으로 평균 이하 칼럼 많음) 
# 3그룹(운동선수) : 스포츠 분야 평균 이상 
# 4그룹(외모지향) : 수영, 치어 점수, 성적 관심, 귀여움 높음
# 5그룹(범죄자) : 대체적으로 평균 이상 칼럼이 많음 


# 소속 군집 확인 
teen_clusters$cluster

## 5단계 : 모델 활용방안 
teens$cluster <- teen_clusters$cluster

# 처음 6개 데이터 확인
head(teens[, c("cluster", "gender", "age", "friends", "cute")])

# 군집별 평균 나이
aggregate(data = teens, age ~ cluster, mean)

# 군집별 여성 비율 - 여성 비율이 월등이 높음 
aggregate(data = teens, gender=='F' ~ cluster, mean)

# 군집별 친구 수의 평균
aggregate(data = teens, friends ~ cluster, mean)

# 군집별 cute 평균 
aggregate(data = teens, cute ~ cluster, mean)


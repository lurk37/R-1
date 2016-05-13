# chap02_ObjectType
# R에서 제공되는 자료구조 5가지 

# 1. Vector 자료구조 
# - 생성 함수 : c(), seq(), rep()

# vector 생성 예
c(1:10) # combine value
1:10
seq(1, 10, 2) # sequence value
rep(1:5, 2) # replicate value
rep(1:5, each=2)

# vector 처리 관련 함수 
x <- c(1,2,4,5,6)
y <- seq(1,10,3)
x;y
union(x, y) # 합집합 - 2  4  5  6  7 10
setdiff(x, y) # 차집합(x - y) - 2 5 6
intersect(x, y) # 교집합 - 1 4

# 벡터에 칼럼명 지정하기
age <- c(35, 45, 55, 65)
age
# age에 칼럼명 적용 
names(age) <- c('홍길동','이순신','강감찬','김유신')
age

age <- NULL
age

# vector에 data 참조 -> 색인(index)
a <- c(10, 20, 30)
a # [1] 10 [2] 20 [3] 30
a[2] ; a[3] # R은 index가 1부터 시작됨 

num <- c(1:50)
num[25]
num[c(10:30)]
length(num) # vector 길이 
num[10:(length(num)-10)] # 10~40
num[10:40]


#<연습문제1> 다음과 같은 벡터를 생성하시오.
#1) Vec1 벡터 변수를 만들고, "R" 문자가 5회 반복되도록 하시오.
Vec1 <- rep("R",5) 
#2) Vec2 벡터 변수에 1~10까지 3간격으로 연속된 정수를 만드시오.
Vec2 <- seq(1,10, by=3)
#3) Vec3에는 1~10까지 3간격으로 연속된 정수가 3회 반복되도록 만드시오.
Vec3 <- rep(Vec2, 3)
#4) Vec4에는 Vec2~Vec3가 모두 포함되는 벡터를 만드시오.
Vec4 <- c(Vec2, Vec3); Vec4
Vec4 <- c(Vec2, Vec3, Vec1); Vec4
#5) 25~ -15까지 5간격으로 벡터 생성- seq()함수 이용 
seq(25, -15, -5)
#6) Vec4에서 홀수번째 값들만 선택하여 Vec5에 할당하시오.(첨자 이용)
length(Vec4) # 벡터 개수 보기 함수
#[1] 16
Vec5 <- Vec4[seq(1,16, by=2)] # 홀수번째만 저장

Vec6 <- c(1:10)
Vec6
Vec6[-2] # - 제외 
Vec6[-c(5:8)]

# 2. Matrix 메모리 구조
# - 행과 열 구조 - 동일한 data type을 갖는다. 
# - 참조 방식 : 변수[행,열]
# - 생성함수 : matrix(), rbind(), cbind()
# - 처리함수 : apply() 

# matrix()함수 이용 
m <- matrix(c(1:5)) # vector -> matrix
m
m2 <- matrix(c(1:10), nrow = 2, byrow = T) # byrow = T : 행 우선 
m2

m3 <- matrix(c(1:9), nrow = 3, byrow = T) # byrow = T : 행 우선 
m3

# rbind(), cbind()
x <- c(1:5)
y <- c(6:10)
z <- c(11:15)
x;y;z

m4 <- rbind(x, y, z) # 행 단위로 행렬 객체 생성 
m4

m5 <- cbind(x, y, z) # 열 단위로 행렬 객체 생성 
m5

# apply() - matrix 데이터 처리 
?apply # apply(X, MARGIN, FUN, ...)
# x : matrix, attry
# MARGIN : 1(row) or 2(column)
# FUN : Function -> 내장함수, 사용자 정의함수 

x <- matrix(c(1:9), nrow = 3, byrow = T)
x

apply(x, 1, sum) # 6 15 24
apply(x, 2, sum) # 12 15 18

# 행/열 단위 평균(mean) 구하기 
apply(x, 1, mean) # 6 15 24
apply(x, 2, mean) # 12 15 18

# 행/열 단위 표준편차(sd) 구하기
apply(x, 1, sd) # 6 15 24
apply(x, 2, sd) # 12 15 18

# 사용자 정의함수 적용 예
f <- function(x){
      x * c(1,2,3) 
     }
f(10)

apply(x, 1, f)

# matrix에 칼럼명 지정 
colnames(x) <- c('one','two', 'three')
x

# 3. Array 자료구조
# - 3차원 배열구조 : 동일한 data type만 저장 
# - 참조형식 : 변수[행,열,면]
# - 생성함수 : array()
# - 자주 사용되지 않음 

vac <- c(1:12)
vac
arr <- array(vac, c(3,2,2))
arr
arr[,,1]
arr[3,1,2] 


data()
data("iris3")
iris3
str(iris3) # 붓꽃 데이터 셋 - 1, 2, 3면 
iris3[,,1] #  Sepal L.(받침길이) Sepal W.(넓이) Petal L.(꽃길이) Petal W.(넓이)
attributes(iris3) # "Setosa"-1    "Versicolor"-2 "Virginica"-3 

# 문1) Virginica 꽃을 대상으로 칼럼단위로 평균을 구하시오.
# 1) iris3 -> 3면만 추출, 변수 생성
iris_data <- iris3[,,3]
head(iris_data)
# 2) apply()함수 적용하여 칼럼단위 평균 계산
apply(iris_data, 2, mean)
round(apply(iris_data, 2, mean), 2) # 소수점 2자리까지 출력  

# 문2) 꽃의 종류별로 꽃받침의 평균 길이가 가장 큰 꽃은 어떤 꽃인가?
iris_data1 <- iris3[,,1]
iris_data2 <- iris3[,,2]
iris_data3 <- iris3[,,3]

re1 <- apply(iris_data1, 2, mean)
re2 <- apply(iris_data2, 2, mean)
re3 <- apply(iris_data3, 2, mean)

re1[1]; re2[1]; re3[1]


# 4. List 자료구조
# - 서로 다른 데이터 구조를 갖는다.
# - c : 구조체, python : dict
# - 생성함수 : list()
# - 처리함수 : lapply(), sapply()

# 2개 이상의 원소를 갖는 list 
num <- list(c(1:5), c(6:10))
num

# key = value
member <- list(name='hongkildong', age = 35, address='seoul', gender='man')
member
# list 접근형식 : 변수명$키 
member$address
member$name
# list에 값 수정 
member$name <- '홍길동'
member$name
# list에 원소 추가
member$id <- 'hong'
member$pwd <- '1234'
member # 추가된 key 확인

# lapply(), sapply()
x <- list(c(1:5))
y <- list(c(6:10))
x; y
# lapply(list, func)
lapply(c(x,y), max) # list type return
# 5  10
sapply(c(x,y), max) # vector type return
# [1]  5 10

person <- list('lee', '이순신', '45', '서울시')
person # list type 출력 

result <- unlist(person)
result # vector type 출력 


# 5. Data Frame 
# - R, Python에서 가장 많이 사용하는 자료구조
# - db에 table 구조(행렬)를 갖는다.
# - matrix와 유사하지만 칼럼단위로 상이한 데이터 저장 가능
# - 생성함수 : data.frame()
# - 처리함수 : apply(), 등 

# 1) Vector와 data.frame 이용 객체 

# vector - 1차 배열 
eno <- c(1:5)
ename <-c('hong','lee','kang','choi','kim')
epay <-c(250,350,250,450,300)
# data.frame 생성 - 2차원 
emp <- data.frame(eno, ename, epay)
emp

# 접근형식) 변수명$칼럼 
emp$epay

# 문) 전 사원의 급여 평균을 구하시오. 
pay <- emp$epay
mean(pay)

# 2) txt 파일을 이용하여 df 생성 
getwd()
setwd('c:/Rwork/Part-I')
txtemp <- read.table('emp.txt', header = T, sep = "")
txtemp
class(txtemp) # "data.frame"

# 3) csv 파일을 이용하여 df 생성 
csvemp <- read.csv('emp.csv', header = T) # 칼럼명 있음
csvemp
class(csvemp) #  "data.frame"

csvemp2 <- read.csv('emp2.csv', header = F) # 칼럼명 없음 
csvemp2 # V1   V2  V3

name <- c('번호', '이름', '급여')
csvemp2 <- read.csv('emp2.csv', header = F, col.names = name) # 칼럼명 없음 
csvemp2 # 번호   이름 급여

#<연습문제2> 다음의 벡터를 컬럼으로 갖는 데이터프레임을 생성하시오.

name <-c("최민수","유관순", "이순신","김유신","홍길동")
age <-c(55,45,45,53,15) #연령
gender <-c(1,2,1,1,1) #1:남자, 2: 여자
job <-c("연예인","주부","군인","직장인","학생")
sat <-c(3,4,2,5,5) # 만족도
grade <- c("C","C","A","D","A") # 등급 
total <-c(44.4,28.5,43.5,NA,27.1) #총구매금액(NA:결측치)

# <조건1> 위 7개 벡터를 user이름으로 데이터 프레임 생성
user <- data.frame(name,age,gender,job,sat,grade, total)
# <조건2> 성별(gender) 변수를 이용하여 히스토그램 그리기
hist(user$gender)
# <조건3> 만족도(sat) 변수를 이용하여 산점도 그리기
plot(user$sat)

r1 <- c(100,80,90)
r2 <- c(90,80,70)
r3 <- c(86,75,92)
Data <- data.frame(r1, r2, r3)

#<연습문제3> Data를 대상으로 apply()를 적용하여 행/열 방향으로 
# 내장 함수(max,mean())를 적용하시오.

# <조건1> 행/열 방향 max()함수 적용
apply(Data, 1, max);  apply(Data, 2, max)

# <조건2> 행/열 평균 mean()함수 적용(소숫점 2자리 까지 표현) 
#  힌트 : round(data, 자릿수)
round(apply(Data, 1, mean),2);  round(apply(Data, 2, mean),2)

# 칼럼 추가 
Data$r4 <- c(85,96,74)
Data
# 칼럼 삭제 
Data$r4 <- NULL

k <- c(85,78,91)
e <- c(85,78,63)
m <- c(75,85,69)
score <- data.frame(k, e, m)
score

# 문) score 객체를 대상으로 다음과 같이 처리하시오.
# 조건1> name 칼럼을 추가하시오.(이름 임의 작성)
name <- c('이순신','강호동','김유신')
score$name <- name
score
# 조건2> 각 학생의 평균(avg)을 구하고, score에 추가하시오.(apply 이용)
score$avg <- round(apply(score[1:3], 1, mean),2)
score
# 조건3> 과목별 총점을 구하시오.
tot <- apply(score[1:3], 2, sum)
tot

# score[행,열] -> score[index] # index -> 열 
score <- score[c(4,1,2,3,5)] # score[ ,c(4,1,2,3,5)]
score
score[1]
score[,1]
score[1, ] # 1행 
score[1,c(2:4)]


# 6. subset 만들기 - 조건에 만족하는 레코드 추출 
# 형식) 변수 <- subset(data, 조건)

x <- c(5:10)
y <- c(8:13)
x; y
xy.df <- data.frame(x, y)
xy.df
mode(xy.df); class(xy.df)

x1 <- subset(xy.df, xy.df$x >= 7)
x1; class(x1)

y1 <- subset(xy.df, xy.df$y > 10) 
y1; class(y1)

# 관계연산자 : >=, >, <, <=, ==, !=
# 논리연산자 : &(and), |(or), !(not)

# x가 8이상이고, y가 12이하인 레코드만 추출하여 xy에 저장하시오.
xy <- subset(xy.df, x>=8 & y <= 12)
xy


# 7. Data Frame Join -> 병합(merge)

height <- data.frame(id=c(1,2,3), h=c(160,165,175))
weight <- data.frame(id=c(1,2,3), w=c(56,85,66))
height; weight

person <- merge(height, weight, by.x = 'id', by.y = 'id')
person

#<연습문제4> kor(국어 점수 2개)과 eng(영어 점수 2개)를 id로 merge해서 
# score에 할당하시오.
# <score 결과>
#  id kor eng
#1  1  85  95
#2  2  75  86

k <- data.frame(id=c(1,2), kor=c(85,75))
e <- data.frame(id=c(1,2), eng=c(95,86))
score <- merge(k, e, by.x='id', by.y='id')
score


# 8. 문자열 처리와 정규표현식 
# - stringr 패키지 이용 
install.packages('stringr')
library(stringr)

str <- 'hong23lee33kang45'
str_extract(str, '[0-9]{2}') # 23
str_extract_all(str, '[0-9]{2}') # "23" "33" "45"

# 1. 횟수 관련 정규표현식 - [] : 1개, {n} : n만큼 
# [a-z]{2} # 소문자 2개 
# [A-Z]{3,} # 대문자 3개 이상 
# [가-히]{3,} # 한글 3개 이상 단어 추출 

str <- 'hongkildong105이순신34강감찬45choi56'
# 연속된 영문자 3개만 추출 
str_extract_all(str, '[a-z]{3}')
# 연속된 숫자 2개 이상 추출
str_extract_all(str, '[0-9]{2,}')
# 한글 이름 추출 
str_extract_all(str, '[가-히]{3,}')

# 2. 숫자 추출 정규표현식 
jumin <- '123456-3234567' # 6-[gender]
class(jumin)
str_extract(jumin, '[0-9]{6}-[1,2,3,4][0-9]{6}')
str_extract(jumin, '\\d{6}-[1,2,3,4]\\d{6}')

# 3. 단어 추출 정규표현식 - 제외(^) 정규표현식 
email <- '14kpjiju14@naver.com' # 14kpjiju$@naver.com
email
#str_extract(email, '[a-z]{4,}@[a-z]{3,}.[a-z]{2,}')
result <- str_extract(email, '[^0-9]\\w{4,}@\\w{3,}.\\w{2,}')
result
if(email == result){
  cat('올바른 이메일 양식입니다.')
}else{
  cat('올바른 이메일 양식이 아닙니다.')
}

# 4) 문자열 길이 구하기 
result
length(result) # 1
str_length(result) # 16

# 5) 문자열 위치(index) 구하기
result
str_locate(result, 'p') # 2
str_locate_all(result, 'j') # 3 5

# 6) 부분 문자열 만들기 
substr <- str_sub(result, 3, 6)
substr

# 7) 소문자, 대문자 변경 
str_to_upper(result) # 대문자 변환 
str_to_lower(result) # 소문자 변환 


# 8) 문자열 교체
str <-'김길동32홍길동35'
str_replace_all(str, '김길동', '홍길동')
str2 <- str_c(str,'강감찬45') # 문자열 추가 
str2

# 9) 문자열 분리
str <-'김길동32 이순신35 강강찬45'
str3<- str_split(str, ' ')
str3 # list 반환 
str3 <- unlist(str3) # vector 변환 
str3
str3[1]
str3[2]
str3[3]

# 10) 문자열 합치기 
string <- c('홍길동35', '이순신45', '강감찬55')
string[3]
result <- paste(string, collapse = ',')
result 

# <연습문제5> 다음의 Data2 객체를 대상으로 정규표현식을 적용하여 문자열을 처리하시오
Data2 <- c("2015-02-05 income1coin","2015-02-06 income2coin","2015-02-07 income3coin")

#<조건1> 일짜별 수입(코인 수)을 출력하시오. 
#        출력 결과) 1coin 2coin 3coin 
str_extract(Data2, "[0-9]{1}[a-z]{4}") # 숫자1개이후 영문자4개 등장
#<조건2> 위 벡터에서 연속하여 2개 이상 나오는 모든 숫자를 제거하시오.  
#        출력 결과) "-- income1coin" "-- income2coin" "-- income3coin"  
str_replace_all(Data2, "[0-9]{2}","")
#<조건3> 위 벡터에서 -를 /로 치환하시오.
str_replace_all(Data2, "-","/")
#<조건4> 모든 원소를 쉼표(,)에 의해서 하나의 문자열로 합치시오. 
# 힌트) paste()함수 이용
paste(Data2, collapse=",") 

# 문) 코인수의 합을 출력하시오. - 결과값 : 6 
coin <- str_extract(Data2, "[0-9][a-z]{4}")
coin # [1] "1coin" "2coin" "3coin"

# 1) 숫자만 추출 
ncoin <- str_extract_all(coin, '[0-9]')
ncoin # list
ncoin[2][1]
# 2) list -> vector 형변환 
vcoin <- unlist(ncoin)
vcoin[1];vcoin[3]
# 3) 숫자 형변환 및 계산 
sum <- as.numeric(vcoin[1]) + as.numeric(vcoin[2]) + as.numeric(vcoin[3])
cat('coin 합계 :', sum)


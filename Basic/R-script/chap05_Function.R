# Chap05_Function

# 1. 사용자 정의 함수
# - 사용자 정의한 함수를 의미
# 형식)  변수 <- function([매개변수]){ 수행문; return(값) }

# 1) 매개변수가 없는 함수 
f <- function(){
  cat('매개변수가 없는 함수')
}

# 함수 호출 
f()

# 2) 매개변수가 있는 함수 
f2 <- function(x, y){ # 가인수 
  cat('x = ', x, '\n')
  cat('y = ', y, '\n')
}

f2(5, 10) # 실인수 

# 문) 사칙연산을 계산하는 함수(calc)을 작성하시오.
# 사칙연산 : +, -, *, /, %%

calc <- function(x, y){
  cat('x + y =', (x+y), '\n')
  cat('x - y =', (x-y), '\n')
  cat('x * y =', (x*y), '\n')
  cat('x / y =', (x/y), '\n')
  cat('x %% y =', (x%%y), '\n')
}

calc(100, 50)

gugu <- function(i, j){
  # 구구단 출력 내용 
  for(x in i){
    # i 영역
    cat('****',x,'단 ****\n')
    for(y in j){
      # j 영역 
      cat(x, '*', y, '=', (x*y), '\n')
    }
    # i 영역 
    cat('\n')
  }
}

i <- 2:5
j <- 1:9
gugu(i, j)


# chap05_Function (연습문제)


#######################################################
#<연습문제> 다음 income 객체에서 날짜별 자판기의 코인 수가 3이상이면 
#  "수입금 GOOD", 그렇지 않으면 "수입금 Bad"를 출력하는 사용자 정의함수를
#   작성하시오.
income <- c("2016-04-05 income5coin", "2016-04-06 income2coin", 
            "2016-04-07 income4coin")

#  힌트) 사용 함수 : stringr 패키지 : str_extract(), str_replace()함수
#                    base 패키지 : 숫자변환 -> as.numeric()함수 

# <출력 결과>
#[1] "2016-04-05 income5coin" "2016-04-06 income2coin" "2016-04-07 income4coin"
#[1] 5
#[1] "수입금 Good"
#[1] 2
#[1] "수입금 Bad"
#[1] 4
#[1] "수입금 Good"

library(stringr)
vending <- function(x){ # 함수 정의 
  print(x) # income 문자열 출력
  for(i in x){ # income 원소만큼 반복 
    coin <- str_extract(i, '[0-9][a-z]{4}') # '숫자coin' 문자열 추출 
    coin <- str_replace(coin, '[a-z]{4}', '') # 'coin' 문자열 제거 
    print(coin) # coin수 출력
    coin <- as.numeric(coin) # 숫자형 변환 
    #re <- ifelse(coin <= 3, 'BAD', 'GOOD')
    #print(re)
    if(coin <= 3){ # 비교 판단 
      cat('수입금 Bad \n')
    }else{
      cat('수입금 Good \n')
    }
  }
}

vending(income) # 함수 호출 

# 파일 데이터 처리 
setwd('c:/Rwork/Part-I')
test <- read.csv('test.csv', header = T)
head(test)
str(test) # 'data.frame':	402 obs. of  5 variables:
summary(test)
table(test$A)

fa <- function(){
   a <- table(test$A) # 1. 빈도분석 
   cat('A 칼럼 빈도분석 결과 \n')
   print(a) # 2. 최댓값 
   cat('A 칼럼의 최댓값 \n')
   print(max(a))# 3. 최솟값
   cat('A 칼럼의 최솟값 \n')
   print(min(a))
}

fa()

#########################################
####  특수문자를 숫자로 변환하는 함수 ###
#########################################

library(stringr)
test <- "100$"
test <- str_replace(test, '\\$', '') # 특수문자 제거 
test <- as.numeric(test) # 숫자 형변환 
result <- test * 10
result

# 숫자를 활용하는 함수 정의 

# 1. 주식관련 파일 가져오기 
finviz <- read.csv(file.choose())
head(finviz)
str(finviz) # 6706 obs. of  69 variables:

# 2. 특수문자 처리하는 함수 정의
clean_numeric <- function(str){
  str <- str_replace_all(str, '\\%|\\$|\\,|\\(|\\)', '')
  result <- as.numeric(str)
  return(result) # 리턴 값 
}

string <- '($1,000%)'
string
result <- clean_numeric(string)

# 3. finviz 변수에 numeric 칼럼만 추출 
fac_col <- finviz[, 1:6]
num_col <- finviz[, 7:12]
rnum_col <- apply(num_col, 2, clean_numeric)

# factor 칼럼 + numeric 칼럼
finviz_result <- cbind(fac_col,rnum_col)
head(finviz_result)
class(finviz_result) # "data.frame"


# 2. 주요 R 내장 함수 

seq(-2, 2, by=.2) # 0.2씩 증가
seq(length=10, from=-5, by=.2) # -5부터 10개 생성 
rnorm(20, mean = 0, sd = 1) # 정규분포를 따르는 20개 데이터 생성
runif(20, min=0, max=100) # 0~100사이의 20개 난수 생성
sample(0:100, 20) # 0~100사이의 20개 sample 생성
vec<-1:10
min(vec)
max(vec)
range(vec)
mean(vec) # 평균
median(vec) # 중위수
sum(vec) 
prod(vec) # 데이터의 곱

factorial(5) # 팩토리얼=120
abs(-5)  # 절대값
sd(rnorm(10)) # 표준편차 구하기

table(x) # 빈도수 
sqrt(16) # 4 
4^2 # 16
# 나머지 구하기
5%%3 # 2
6%%2 # 0

x <- c(2,1,3,4,5)
y <- c(1:5)
x;y
sort(x) # 오름차순 
sort(x, decreasing = T) # 내림차순 
order(x) #  2 1 3 4 5
rank(x) # 2 1 3 4 5

# 상관분석 
cor(x, y) # 0.9 - 상관성 높다.

getwd()
setwd("c:/Rwork/Part-I")
excel <- read.csv("excel.csv", header=TRUE)
head(excel,10) 

#colMeans()함수 : 각 열의 평균 계산
colMeans(excel[1:5])
summary(excel)  


##################################
### 난수 생성과 확률분포     
##################################

# 1. 정규분포를 따르는 난수 생성 - 연속형(실수) 
# 형식) rnorm(n, mean=0, sd = 1)
n <- 1000
r <- rnorm(n, mean=0, sd=1)
r
hist(r)

# 2. 균등분포를 따르는 난수 생성 - 연속형(실수)
rf<- runif(n, min=0, max=1) # 0 < n < 1
hist(rf)

# 3. 이항분포를 따르는 난수 생성 - 이산형(정수)
# 형식) rbinom(n, size, prob=0.5)
n <- 10
rbinom(n, 1, prob = 1/2) # 1 = 0 or 1

test <- read.csv(file.choose(), header = T)
str(test) # 402 obs. of  5 variables:
x <- 1:nrow(test) # 402
x
row <- sample(1:nrow(test), nrow(test)*0.7 )
train <- test[row, ] # [row, column]
head(train)
test <- test[-row, ]# 30%
test
dim(train) # 281   5
dim(test) # 121   5


# 문) 주사위를 1000번 던져서 나오는 각 눈금수를 출력하시오.'
# <조건1> runif(n, min=, max = )
#   힌트 : 연속형 -> 이산형 : round()함수 적용 
# <조건2> table() 함수 이용 - 빈도수 구하기 
# <조건3> 빈도수를 히스토그램으로 작성하기 
n <- 1000
r<- round(runif(n, min=1, max=6)) # 반올림 
range(r) # 범위 
table(r) # 각 주사위 눈금 빈도수 
hist(r) # 히스토그램 
barplot(table(r)) # 막대차트 


######################################
#### class와 Object 생성 
######################################
# 객체지향 언어 - java, c++, Python, R

# 1. class - 설계도 
setClass('member', representation = list(
        id = 'character',
        pwd = 'character',
        name = 'character',
        gender = 'character',
        age = 'numeric',
        salay = 'numeric'
))

# Class(1) : Object(N)
# 2. Object - 결과물 
p1 <- new('member', id='hong',pwd='1234',
          name='홍길동',gender='man',age=35,salay=350 )
p1
p1@id
p2 <- new('member', id='lee',pwd='1234',
          name='이순신',gender='man',age=45,salay=450 )
p2@salay


# 자동차(car) 클래스를 정의하고, 2개의 Object를 생성하시오.
# <조건> cc, name, door, year
setClass('car', representation = list(
      cc = 'numeric',
      name ='character',
      door = 'numeric',
      year = 'numeric'
))

sonata <- new('car', cc=2500, name='소나타', door=4, year=2014)
test <- new('car', cc=1500, name='test', door=5, year=2014)
sonata




















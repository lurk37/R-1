# chap04_Control

# - 제어문 : 조건문과 반복문 

# 1. 조건문 : if(), ifelse(), ..

# 1) if(조건){참 수행문}else{ 거짓 수행문}
score <- scan() # 점수 
score <- score - 20
if(score >= 60){ # 산술,논리,관계 연산자 
  cat('합격했습니다.')
}else{
  cat('불합격 했습니다.')
}

result <- ''
if(score >= 60){ # 산술,논리,관계 연산자 
  result <- '합격했습니다.'
}else{
  result <- '불합격 했습니다.'
}
result

# if(조건1){ 조건1 참 }else if(조건2){ 조건2 참}else{ 조건1과 조건2 거짓 }
grade <- ''
score <- scan() # 점수
score # 82
if(score >= 90){ # 조건1 
  grade <- 'A'
}else if(score >= 80){ # 조건2 - 80 ~ 89
  grade <- 'B' 
}else if(score >= 70){  # 조건3 - 70 ~ 79 
  grade <- 'C'  
}else{  # 모두 거짓
  grade <- 'F'  # 69 이하
}
grade # "B"
cat('당신의 점수는' ,score, '이고\n학점은 ', grade, '입니다.' )

x <- 10/2 # 몫 
x
mod <- 10%%2  # 나머지 
mod # 0

# 키보드로 임의의 숫자를 입력받아서 짝수 또는 홀수로 판별하시오.
num <- scan()
if((num %% 2 == 0) | (num %% 5 == 0)) { # 2의 배수 또는 5의 배수 판별  
  cat('입력한 수는', num, '이고\n2의 배수 또는 5의 배수 입니다.')
}else{
  cat('입력한 수는', num, '이고\n2의 배수 또는 5의 배수가 아닙니다.')
}


# 2) ifelse(조건, 참, 거짓) : 3항 연산자 
score <- 85
ifelse(score >= 70, '양호', '노력')

excel <- read.csv(file.choose(), header = T) # excel.csv
excel
str(excel) # 'data.frame':	402 obs. of  5 variables:
names(excel) #  "q1" "q2" "q3" "q4" "q5"
q1 <- excel$q1
re <- ifelse(q1 >= 2, sqrt(q1), q1)
excel$q6 <- ifelse(q1 >= 4, sqrt(q1), q1 )
head(excel)

# 문) 다음과 같은 조건으로 q7의 칼럼을 추가하시오. 
# <조건> q1 값이 2~4인 경우 q1에 제곱을 적용하고, 그렇지 않으면 q1 추가
# 제곱 : q1^2
excel$q7 <- ifelse(q1>=2 & q1 <=4, q1^2, q1 )
head(excel)


# 3) switch문 : 다중선택문 -> value 리턴 
switch ('pwd', id= 'hong', pwd='1234', name='홍길동')


# 4) which문 : index 리턴
name <- c('hong','lee','kang','choi')
pay <- c(250,450,520,125)
which(name=='choi') # 4

emp <- data.frame(name, pay)
emp
which(emp$name == 'lee') # 2
which(emp$pay == 450) # 2


# iris 데이터 셋에서 꽃의 종류별 빈도수 
data(iris)
head(iris) # Species - 범주형 변수 
table(iris$Species) # 빈도수 보기 
#setosa versicolor  virginica 
#  50         50         50 


#<연습문제> 다음 client 데이터프레임을 대상으로 조건에 맞게 처리하시오.

name <-c("aaa","bbb","ccc","ddd")
gender <- c("F","M","M","F")
price <-c(50,65,45,75)
client <- data.frame(name,gender,price)
client
# <조건1> price가 65만원 이상인 고객은 "Best" 미만이면 
#     "Normal" 문자열을 result 변수에 넣고, client의 객체에 컬럼으로 추가하기
client$result <- ifelse(client$price >= 65, 'Best', 'Normal')
client
# <조건2> result의 빈도수를 구하시오. 힌트) table()함수 이용
table(client$result)

# <조건3> gender가 'M'이면 "Male", 'F'이면 "Female" 형식으로 client의 객체에
#  gender2 컬럼을 추가하고 빈도수 구하기

# ifelse() 사용 예 
client$gender2 <- ifelse(client$gender == 'M', 'Male', 'Female')
table(client$gender2)

# for(반복문) 사용 예 
gen <- character() # 빈 vector 객체 
cnt <- 0 # 카운터 변수 
for(g in client$gender){ # 성별 vector 원소 1개씩 넘김 
  cnt = cnt + 1 # 카운터 증가 
  if(g == 'M'){ # 'M'인 경우 
    gen[cnt] <- '남자'
  }else{ # 'F'인 경우 
    gen[cnt] <- '여자'
  }
}
client$gender3 <- gen # client에 칼럼 추가 
client


# 2. 반복문 
# - 조건식이 만족하면 일정한 수행문을 반복 실행하는 함수

# 1) for()
# 형식) for(변수 in vector)
x <- 1:5 # c(1:5)
x
for(i in x){ # java script for문 
  cat('i = ', i, '\n') # \n -> line skip
  cat('i*10 =', (i*10), '\n')
}

# 다중반복문 : 반복문 { 반복문{ } }
i <- 2:9
j <- 1:9
i;j
for(x in i){
  # i 영역
  cat('****',x,'단 ****\n')
  for(y in j){
    # j 영역 - i * j = 72반복
    cat(x, '*', y, '=', (x*y), '\n')
  }
  # i 영역 
  cat('\n')
}

# 문) 키보드로 임의의 정수를 입력받아서 1부터 해당 숫자만 1씩반복하여
# 짝수만 출력하시오. (num %% 2 == 0)

input <- scan()
i <- 1:input
cat('짝수 출력하기 \n')
for(cnt in i){
  if(cnt %% 2 == 0){
    cat(cnt, '\n')
  }
}
cat('홀수 출력하기 \n')
for(cnt in i){
  if(cnt %% 2 == 0){
    next
  }else{
    cat(cnt, '\n')
  }
}
# 3과목 점수 
kor <- c(80,85,40)
eng <- c(75,99,75)
mat <- c(76,78,56)
name <- c('홍길동','이순신','유관순') # 학생명은 키보드 입력 
name
# 평균과 총점은 for() 이용 
# 학생명, 국어, 영어, 수학, 평균,  총점 
# 홍길동   80    75     76   xx.xx  xxx
# 이순신    :
# 유관순    :

# data.frame -> student 이름으로 생성 
student <- data.frame(name,kor,eng,mat)
student

tot <- numeric() # 빈 vector 생성 
avg <- numeric() # 빈 vector 생성
str <- character() # 빈 vector 생성 

cnt <- 1:nrow(student)
cnt
for(i in cnt){ # i -> 기준변수 : index활용  
  tot[i] <- student$kor[i]+student$eng[i] + student$mat[i]
  avg[i] <- tot[i] / 3
}
student$avg <- round(avg,2)
student$tot <- tot
student

# 2) while(조건){  수행문 }
i <- 0
while( i < 10){ # 조건식 
  i <- i + 1 # 카운터 변수 
  print(i)
}


# 3) repeat{  수행문; 탈출조건   }
cnt <- 1
repeat{
  cat('cnt = ', cnt, '\n')
  if(cnt >= 5) break # exit 조건 
  cnt = cnt + 1
}




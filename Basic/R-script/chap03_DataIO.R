# chap03_DataIO

# 1. Data 불러오기 

# 1-1. 키보드 입력 
score <- scan() # 키보드 입력 
score
sum <- sum(score)
sum

# 문자 입력
name <- scan(what='')
name

df <- data.frame() # 빈 data frame 생성 
df <- edit(df)
df

# 1-2. file data 가져오기
getwd()
setwd('c:/Rwork/Part-I')

# (1) read.table()
# 칼럼명이 없는 파일 가져오기 
student <- read.table(file='student.txt')
student # V1   V2  V3 V4
# 칼럼명이 있는 경우 
student2 <- read.table(file='student1.txt', header = T)
student2
# 구분자가 있는 경우 
student3 <- read.table(file='student2.txt', header = T, sep=';')
student3
# 특수문자 -> NA 대체 
student4 <- read.table(file='student3.txt', header = T, na.strings = c('-','$'))
student4
class(student4) # "data.frame"

# 문) 키와 몸무게의 평균을 구하시오. (소숫점 2자리까지 표기)
height <- student4$키
weight <- student4$몸무게
round(mean(height, na.rm = T), 2) # 177.67
round(mean(weight, na.rm = T), 2) # 73.33


# (2) read.csv()
student5 <- read.csv(file = 'student4.txt', header = T, na.strings = c('-'))
student5
# 파일 선택 옵션 적용 
student5 <- read.csv(file.choose(), header = T ,na.strings = c('-'))

# (3) read.xlsx
# JRE : JAVA 가상머신 경로 설정 
Sys.setenv(JAVA_HOME='C:\\Program Files\\Java/jre1.8.0_77')
install.packages('rJava')
library(rJava)
# java home 디렉토리와 rJava 패키지 메모리 로딩 -> java 기반 패키지 사용 

install.packages('xlsx')
library(xlsx)

xls <- read.xlsx(file.choose(), sheetIndex = 1, encoding = 'UTF-8')
xls

# 1-3. 웹문서 가져오기 - P.78
# XML -> <Table> <tr> </td>
install.packages('XML')
library(XML)

info.url <- "http://infoplease.com/ipa/A0104652.html"
# stringsAsFactors=F : 순수한 문자열로 가져오기 
web <- readHTMLTable(info.url, header = T, which = 1, stringsAsFactors=F)
web

web2 <- web[1:53, ] 
web2 <- web2[c(-2, -28), ] # 2, 28행 제거 
web2 <- web2[c(-1,-2), ] # 1, 2행 제거 
web2

# 칼럼 지정 
names(web2) <- c('State',1980,1990,1995,2000,2003, 2006, 2009,2012)
web2

# 문) 2012년도 전체 합계와 평균을 구하시오.
# 전처리) 콤마 제거-> 숫자 변경 -> 합계/평균 
# stringr 패키지 이용, as.numeric() 
library(stringr)
y2012 <- web2$`2012`
head(y2012)

# 콤마 제거 
y2012 <- str_replace_all(y2012, ',','')
head(y2012)

# 숫자 변경
y2012 <- as.numeric(y2012)
head(y2012)
y2012_tot <- sum(y2012)
y2012_avg <- mean(y2012)
y2012_tot; y2012_avg

# 10개 주(State)를 대상으로 막대차트 시각화 
barplot(y2012[1:10], main='10개 주(State) 1인당 소득 자료', 
    col=rainbow(10), xlab='State', ylab='소득(단위:달러)')

# 2. 데이터 저장하기(출력)

# 2-1. 콘솔 출력

# 1) cat() 함수
x <- 10
y <- 20
z <- x * y

cat('x * y = ', z) # 문자열, 변수값 

# 2) print() 
print('x * y = ', z) # error -> 변수 또는 수식 
print (z)
print(z * 2)

# 2-2. 파일 저장하기 

# 1) sink()
Sys.setenv(JAVA_HOME='C:\\Program Files\\Java/jre1.8.0_77')
library(rJava)
library(xlsx)

setwd("c:/Rwork/output")
sink('studentxls.txt') # file open
studentxls <- read.xlsx(file.choose(), sheetIndex = 1, encoding = 'UTF-8')
studentxls
sink() # file close

# 2) write.table() 
studentxls
write.table(studentxls, 'studentxls2.txt')
write.table(studentxls, 'studentxls3.txt', row.names = FALSE, quote = FALSE)

# 3) write.xlsx() -> xlsx
write.xlsx(studentxls, 'student.xlsx')

# 4) write.cvs()
write.csv(studentxls, 'studentxls4.csv', row.names = F, quote = F)


# <연습문제> web2 데이터 프레임을 webInfo.csv 파일로 
#            저장한 후 데이터프레임으로 가져오시오.
# <조건1> "C:/Rwork/output" 디렉토리에 "webInfo.csv"로 저장
# 힌트) write.csv()함수 이용
setwd("C:/Rwork/output")
write.csv(web2,"webInfo.csv", row.names = F)  # 행이름과 따옴표가 없음
# <조건2> "webInfo.csv" 파일을 webData 데이터 프레임으로 가져와서 결과 확인
webData <- read.csv(file.choose(), header=T) # webInfo.csv 선택
# <조건3>  webData 데이트 셋 구조 보기 함수를 이용하여 관측치와 컬럼수 확인
str(webData) # 'data.frame':	49 obs. of  9 variables:
names(webData) <- c('State',1980,1990,1995,2000,2003,2006,2009,2012)
webData
# <조건4> 1980년과 1990년을 제외한 나머지 컬럼 대상으로 상위 6개 관측치 보기
head(webData[ ,c(-2,-3)])




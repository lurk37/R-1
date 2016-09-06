#chap08_Formal_InFormal 수업내용
# - 정형데이터와 비정형데이터 DB처리

#1. 정형 데이터 처리 - Oracle DB 데이터 처리
# DB(RDB) 연결 - ODBC, JDBC, DBI
# - Oracle/MySql 실습

# Maria DB 정형 데이터 처리

# - DB(RDB) 연결 방법 : ODBC와 JDBC 방식
# ODBC(Open DataBase Connectivity) 연결방식 : DB 접속을 위해서 DB을 열어주는 API
# JDBC(Java DataBase Connectivity) 연결방식 : JAVA로 작성된 프로그램으로 DBMS에 연결하는 API
# -> 자바로 만들어진 R 패키지 프로그램으로 DBMS에 연결하기 위해서는 JDBC의 API를 지원하는 
# RJDBC 패키지를 설치하면 된다.

# DB 연결
# 1. RJDBC 패키지에서 제공되는 JDBC()함수를 이용하여 해당 DBMS의 driver 지정
#형식 drv<-JDBC(driverClass="   ", 
          #classPath=" ")
          #classPath아는 법#
          #ojdbc가 오라클 클라이언트(ex:sqldeveloper)를 설치 후 폴더 검색에서 ojdbc를 검색 후 나오는 곳을 
          #붙여 넣기하면 된다. 

# 2. dbConnect()함수에 4개 인수(driver,url,id,password)를 적용하여 DB에 연결 
#형식: conn<-dbConnect(drv, "jdbc:mysql://<db_ip>:<db_port>/<dbname/SID>", "<id>", "<passwd>")

########### 포트번호와 DB명 확인 ##########
#1. Oracle10g
#C:\oraclexe\app\oracle\product\10.2.0\server\NETWORK\ADMIN
#폴더에서 listener.ora와 TNSNAMES.ora 파일에서 확인 및 추가 
#XE: 서버명, HOST : 호스트명, 1521 : 포트 번호

#2. Oracle11g :  데이터베이스 연동에 필요한 PORT와 SID  보기   
#1) PORT
#C:\app\choongang\product\11.2.0\dbhome_1\NETWORK\ADMIN
#에서 listener.ora 파일 내용에서 (PORT=1521)
#2) SID
#C:\app\choongang\product\11.2.0\dbhome_1\NETWORK\ADMIN
#에서 tnsnames.ora 파일 내용에서 SERVICE-NAME=orcl


# 패키지 설치
install.packages("rJava")
install.packages("DBI")
install.packages("RJDBC") 

# 패키지 로딩
#Sys.setenv(JAVA_HOME='C:\\Program Files\\Java\\jre1.8.0_77')<-환경변수 안되어 있으면 일케
library(RJDBC) 

############ Oracle 10g ##############
# driver  
drv<-JDBC(driverClass="oracle.jdbc.driver.OracleDriver", 
          classPath="C:\\oraclexe\\app\\oracle\\product\\10.2.0\\server\\jdbc\\lib\\ojdbc14.jar")
# db연동(driver, url,uid,upwd)   
#conn<-dbConnect(drv, "jdbc:oracle:thin:@//127.0.0.1:1521/xe","scott","tiger")
#10g와 11g는 DB경로가 다름 


############ Oracle 11g #################
# driver  
drv<-JDBC("oracle.jdbc.driver.OracleDriver", 
          "C:\\app\\user\\product\\11.2.0\\dbhome_1\\jdbc\\lib\\ojdbc6.jar")
# db연동(driver, url,uid,upwd)   
conn<-dbConnect(drv, "jdbc:oracle:thin:@//127.0.0.1:1521/orcl","scott","tiger")


################ MariaDB or MySql ###############
drv <- JDBC(driverClass="com.mysql.jdbc.Driver", 
            classPath="C:/mysql-connector-java-5.1.38/mysql-connector-java-5.1.38/mysql-connector-java-5.1.38-bin.jar")

# driver가 완전히 로드된 후 db를 연결한다.
conn <- dbConnect(drv, "jdbc:mysql://127.0.0.1:3306/work", "scott", "tiger")
#work는 아까 만든 테이블
#################class error#################
# db 연결과정에 다음과 같은 error message가 출력되면 시스템을 재부팅 후 다시 연결한다.
#Error in .jcall(drv@jdrv, "Ljava/sql/Connection;", "connect", as.character(url)[1],  : 
#java.lang.NoClassDefFoundError: Could not initialize class com.mysql.jdbc.Util

###############heap size error##############
#java.lang.OutOfMemoryError: Java heap space
#자바 메모리 사양 부족->heap size를 늘려주면 됨
options( java.parameters = "-Xmx8g" ) #8기가



# select문 작성과 실행
query = "SELECT * FROM student"
dbGetQuery(conn, query)

query='SELECT * FROM emp order by deptno desc'
dbGetQuery(conn, query)

#레코드 삭제
query='delete from student where sid=1001'
#레코드 수정
query="update student set address = '한양시' where sid=1002"



#1. 테이블의 컬럼 보기 
# 형식) dbListFields(con, "DBtable")

dbListFields(conn, "goods") # conn, table name

#2. 전체 테이블 목록 검색
query='select*from goods'
dbGetQuery(conn, query)

#3. 조건 검색
query='select*from goods where su>=3'
goodssu=dbGetQuery(conn, query)

#4. 레코드 추가
query = "insert into goods values(5,'테스트',3,450000)"
dbSendUpdate(conn,query) #DB업데이트

#5. 레코드 수정
query = "update goods set name='test2' where code=5"
dbSendUpdate(conn,query) #DB업데이트
#따옴표 갯수 중요함!

#6. 레코드 삭제
query = "delete from goods where code=5"
dbSendUpdate(conn,query) #DB업데이트

dbDisconnect(conn)#DB연결 종료

#emp 테이블

query2='select*from emp'
dbGetQuery(conn, query2)

query2='select*from '
dbGetQuery(conn, query2)


#join: 두 개 이상의 테이블 결과를 합치는 과정
join_query='select emp.ename, emp.job,dept.deptno, dept.dname from emp, dept where dept.deptno=emp.deptno'
#.<-해당 컬럼
joinAll=dbGetQuery(conn, join_query)

#subquery: main query(sub query)
#단일행 검색 결과 
sub_query='select * from dept where deptno = (select deptno from emp where deptno = 10)'
subALL=dbGetQuery(conn, sub_query)

#다중행 검색 결과
sub_query='select * from dept where deptno IN (select deptno from emp where deptno = 10)'
subALL=dbGetQuery(conn, sub_query)

#문)연봉 3,000 이상인 사원의 부서정보를 출력
sub_query='select * from dept where deptno IN (select deptno from emp where sal >= 3000)'
subALL=dbGetQuery(conn, sub_query)

#문) 직책이 '영업직'인 사원의 사번,이름,부서번호, 부서명을 출력
#select 버전
sub_query="select emp.empno,emp.ename,emp.deptno,dept.dname from emp,dept where dept.deptno = emp.deptno and emp.job='영업직'"
subALL=dbGetQuery(conn, sub_query)

#join 버전
join_query='select emp.job,emp.empno,emp.ename, dept.deptno, dept.dname from emp, dept where dept.deptno=emp.deptno'
#.<-해당 컬럼
joinAll=dbGetQuery(conn, join_query)
joinAll[joinAll$job=='영업직',]

#########################################################
# 2. 비정형 데이터 처리 - SNS 데이터 분석(텍스트 마이닝) 
#########################################################

# 분석 절차
#1단계 : 토픽분석(단어의 빈도수)
#2단계 : 연관어 분석(관련 단어 분석) 
#3단계 : 감성 분석(단어의 긍정/부정 분석) 

# 패키지 설치 및 로딩
# 1) java install : http://www.oracle.com
# -> java 프로그램 설치(64비트 환경 - R(64bit) - java(64bit))

# 2) rJava 설치 : R에서 java 사용을 위한 패키지
#install.packages("rJava")
Sys.setenv(JAVA_HOME='C:\\Program Files\\Java\\jre1.8.0_77')
library(rJava) # 로딩

# 3) install.packages
install.packages(c("KoNLP", "tm", "wordcloud"))

# 4) 패키지 로딩
library(KoNLP) 
library(tm)
library(wordcloud) 


##################################################
# 단계1 - 토픽분석(텍스트 마이닝) 
#- 시각화 : 단어 빈도수에 따른 워드 클라우드
###################################################

# 1. 텍스트 데이터(facebook_bigdata.txt) 가져오기
facebook <- file("C:/Rwork/Part-II/facebook_bigdata.txt", encoding="UTF-8")
facebook_data <- readLines(facebook) # 줄 단위 데이터 생성
head(facebook_data) # 앞부분 6줄 보기 - 줄 단위 문장 확인 
str(facebook_data) # chr [1:76]

# 2. Corpus : 텍스트 데이터 -> 자료집(documents) 생성(tm 패키지 제공)
facebook_corpus <- Corpus(VectorSource(facebook_data)) 

# 76개 자료집 보기 - 포함된 문자 수 제공
inspect(facebook_corpus)  

# 3. 분석 대상 자료집을 대상으로 NA 처리(공백)
facebook_corpus[is.na(facebook_corpus)]   <- " "
facebook_corpus 

# 4. 세종 사전 사용 및 단어 추가
useSejongDic() # 세종 사전 불러오기

# 세종 사전에 없는 단어 추가
mergeUserDic(data.frame(c("R 프로그래밍","페이스북","소셜네트워크"), c("ncn"))) 
# ncn -명사지시코드

# 5. 단어추출 사용자 함수 정의
# (1) 사용자 정의 함수 실행 순서 : 문자변환 -> 명사 단어추출 -> 공백으로 합침
exNouns <- function(x) { 
  paste(extractNoun(as.character(x)), collapse=" ")
}

# (2) exNouns 함수 이용 단어 추출 
# 형식) sapply(적용 데이터, 적용함수) 
facebook_nouns <- sapply(facebook_corpus, exNouns) 
# (3) 단어 추출 결과
#class(facebook_nouns) # [1] "character" -> Vector 타입
facebook_nouns[1] # 단어만 추출된 첫 줄 보기 

# 6. 데이터 전처리   
# (1) 추출된 단어 이용하여 자료집 생성
myCorputfacebook <- Corpus(VectorSource(facebook_nouns)) 
# (2) 데이터 전처리 
myCorputfacebook <- tm_map(myCorputfacebook, removePunctuation) # 문장부호 제거
myCorputfacebook <- tm_map(myCorputfacebook, removeNumbers) # 수치 제거
myCorputfacebook <- tm_map(myCorputfacebook, tolower) # 소문자 변경
myCorputfacebook <-tm_map(myCorputfacebook, removeWords, stopwords('english')) # 불용어제거
# (3) 전처리 결과 확인 
inspect(myCorputfacebook[1:5]) # 데이터 전처리 결과 확인

# 7. 단어 선별(단어 길이 2개 이상)
# (1) 자료집 -> 일반문서 변경
myCorputfacebook_txt <- tm_map(myCorputfacebook, PlainTextDocument) 
# (2) TermDocumentMatrix() : 단어 선별(단어길이 2개 이상인 단어 선별 -> matrix 변경)
myCorputfacebook_txt <- TermDocumentMatrix(myCorputfacebook_txt, control=list(wordLengths=c(2,Inf)))
myCorputfacebook_txt
# (3) matrix -> data.frame 변경(빈도분석을 위해서)
myTermfacebook.df <- as.data.frame(as.matrix(myCorputfacebook_txt)) 
dim(myTermfacebook.df) # [1] 876  76

# 8. 단어 빈도수 구하기(행 단위 합계 -> 내림차순 정렬)
wordResult <- sort(rowSums(myTermfacebook.df), decreasing=TRUE) # 빈도수로 내림차순 정렬
wordResult[1:10]
#빅데이터     사용     분석     처리     수집 
#      21       20       19       16       15  

# 9. wordcloud 생성 (디자인 적용전)
myName <- names(wordResult) # 단어 이름 생성 -> 빈도수의 이름 
wordcloud(myName, wordResult) # 단어구름 적용


#---------------<불필요한 단어 제거 시작 :  6 ~ 9단계 수행>-------------------
# 6. 데이터 전처리 - "사용", "하기" 단어 제거 
myCorputfacebook <- tm_map(myCorputfacebook, removePunctuation) # 문장부호 제거
myCorputfacebook <- tm_map(myCorputfacebook, removeNumbers) # 수치 제거
myCorputfacebook <- tm_map(myCorputfacebook, tolower) # 소문자 변경
myStopwords = c(stopwords('english'), "사용", "하기");
myCorputfacebook = tm_map(myCorputfacebook, removeWords, myStopwords);

# 7. 단어 선별(단어 길이 2개 이상)
myCorputfacebook_txt <- tm_map(myCorputfacebook, PlainTextDocument) 
myCorputfacebook_txt <- TermDocumentMatrix(myCorputfacebook_txt, control=list(wordLengths=c(2,Inf)))
myTermfacebook.df <- as.data.frame(as.matrix(myCorputfacebook_txt)) 
dim(myTermfacebook.df) # [1] 876  76

# 8. 단어 빈도수 구하기
wordResult <- sort(rowSums(myTermfacebook.df), decreasing=TRUE) # 빈도수로 내림차순 정렬
wordResult[1:10]
#빅데이터     분석     처리     수집     결과 
#21       19       16       15       13  

# 9. 단어 구름(wordcloud) 생성  생성 - 디자인 적용 전
myName <- names(wordResult) # 단어 이름 추출(빈도수 이름) 
wordcloud(myName, wordResult) # 단어구름 시각화 
#myName
#------------------<불필요한 단어 제거 종료 >-----------------------

# 10. 단어구름에 디자인 적용(빈도수, 색상, 랜덤, 회전 등)
# (1) 단어이름과 빈도수로 data.frame 생성
word.df <- data.frame(word=myName, freq=wordResult) 
str(word.df) # word, freq 변수

# (2) 단어 색상과 글꼴 지정
pal <- brewer.pal(12,"Paired") # 12가지 색상 pal <- brewer.pal(9,"Set1") # Set1~ Set3
# 폰트 설정세팅 : "맑은 고딕", "서울남산체 B"
windowsFonts(malgun=windowsFont("맑은 고딕"))  #windows

# (3) 단어 구름 시각화 - 별도의 창에 색상, 빈도수, 글꼴, 회전 등의 속성을 적용하여 
x11( ) # 별도의 창을 띄우는 함수
wordcloud(word.df$word, word.df$freq, 
          scale=c(5,1), min.freq=3, random.order=F, 
          rot.per=.1, colors=pal, family="malgun")
#wordcloud(단어, 빈도수, 5:1비율 크기,최소빈도수,랜덤순서,랜덤색상, 회전비율, 색상(파렛트),컬러,글꼴 )

# 11. 차트 시각화 
#(1) 상위 10개 토픽추출
topWord <- head(sort(wordResult, decreasing=T), 10) # 상위 10개 토픽추출 
# (2) 파일 차트 생성 
pie(topWord, col=rainbow(10), radius=1) # 파이 차트-무지개색, 원크기
# (3) 빈도수 백분율 적용 
pct <- round(topWord/sum(topWord)*100, 1) # 백분율
names(topWord)
# (4) 단어와 백분율 하나로 합친다.
lab <- paste(names(topWord), "\n", pct, "%")
# (5) 파이차트에 단어와 백분율을 레이블로 적용 
pie(topWord, main="SNS 빅데이터 관련 토픽분석", col=rainbow(10), cex=0.8, labels=lab)

###################################################
# 단계2 - 연관어 분석(단어와 단어 사이 연관성 분석) 
#   - 시각화 : 연관어 네트워크 시각화, 근접중심성 시각화
###################################################

# 한글 처리를 위한 패키지 설치
#install.packages("rJava")
Sys.setenv(JAVA_HOME='C:\\Program Files\\Java\\jre1.8.0_77')
library(rJava) # 아래와 같은 Error 발생 시 Sys.setenv()함수로 java 경로 지정

#install.packages("KoNLP")
library(KoNLP) # rJava 라이브러리가 필요함


# 1.텍스트 파일 가져오기
#----------------------------------------------------
marketing <- file("C:/Rwork/Part-II/marketing.txt", encoding="UTF-8")
marketing2 <- readLines(marketing) # 줄 단위 데이터 생성
# incomplete final line found on - Error 발생 시 UTF-8 인코딩 방식으로 재 저장
close(marketing) 
head(marketing2) # 앞부분 6줄 보기 - 줄 단위 문장 확인 
#----------------------------------------------------

# 2. 줄 단위 단어 추출
#----------------------------------------------------
# Map()함수 이용 줄 단위 단어 추출 : Map(f, ...) -> base)
lword <- Map(extractNoun, marketing2) 
length(lword) # [1] 472
lword <- unique(lword) # 중복제거방법1(전체 대상)
length(lword) # [1] 353(19개 제거)

lword <- sapply(lword, unique) # 중복제거방법2(줄 단위 대상) 
length(lword) # [1] 352(1개 제거)
str(lword) # List of 353
lword # 추출 단어 확인
#----------------------------------------------------

# 3. 전처리
#----------------------------------------------------
# 1) 길이가 2~4 사이의 단어 필터링 함수 정의
filter1 <- function(x){
  nchar(x) <= 4 && nchar(x) >= 2 && is.hangul(x)
}
# 2) Filter(f,x) -> filter1() 함수를 적용하여 x 벡터 단위 필터링 
filter2 <- function(x){
  Filter(filter1, x)
}
# is.hangul() : KoNLP 패키지 제공
# Filter(f, x) : base
# nchar() : base -> 문자 수 반환

# 3) 줄 단어 대상 필터링
lword <- sapply(lword, filter2)

lword # 추출 단어 확인(길이 1개 단어 삭제됨)


# 4. 트랜잭션 생성 : 연관분석을 위해서 단어를 트랜잭션으로 변환
#----------------------------------------------------
# arules 패키지 설치
install.packages("arules")
library(arules) 
#----------------------------
# arules 패키지 제공 기능
# - Adult,Groceries 데이터 셋
# - as(),apriori(),inspect(),labels(),crossTable()
#-----------------------------
wordtran <- as(lword, "transactions") # lword에 중복데이터가 있으면 error발생
wordtran

wordtable <- crossTable(wordtran) # 교차표 작성
wordtable


# 5.단어 간 연관규칙 산출
#----------------------------------------------------
# 트랜잭션 데이터를 대상으로 지지도와 신뢰도를 적용하여 연관규칙 생성
# 형식) apriori(data, parameter = NULL, appearance = NULL, control = NULL)
# data :  object of class transactions, 
# parameter : support 0.1, conﬁdence 0.8, and maxlen 10(연관단어 최대수) 
tranrules <- apriori(wordtran, parameter=list(supp=0.25, conf=0.05)) 
# 0.22 -> 84 rules, supp=0.25 -> 59 rules
# # 지지도와 신뢰도를 높이면 발견되는 규칙의 수가 줄어든다.

inspect(tranrules) # 연관규칙 생성 결과(59개) 보기


# 6.연관어 시각화 - rulemat[c(34:63),] # 연관규칙 결과- {} 제거(1~33)
#----------------------------------------------------
# (1) 연관단어 시각화를 위해서 데이터 구조 변경
rules <- labels(tranrules, ruleSep=" ") 
class(rules)
#[1] "character"
rules <- sapply(rules, strsplit, " ",  USE.NAMES=F) 
rulemat <- do.call("rbind", rules)
# sapply(), do.call() # base 패키지
rulemat
class(rulemat)
#[1] "matrix"


# (2) 연관어 시각화를 위한 igraph 패키지 설치
install.packages("igraph") # graph.edgelist(), plot.igraph(), closeness() 함수 제공
library(igraph)   

# (3) edgelist보기 - 연관단어를 정점 형태의 목록 제공 

ruleg <- graph.edgelist(rulemat[c(12:59),], directed=F) # [1,]~[11,] "{}" 제외
ruleg

# (4) edgelist 시각화
plot.igraph(ruleg, vertex.label=V(ruleg)$name,
            vertex.label.cex=1.2, vertex.label.color='black', 
            vertex.size=20, vertex.color='green', vertex.frame.color='blue')
# 정점(타원) 레이블 속성
# vertex.label=레이블명,vertex.label.cex=레이블 크기, vertex.label.color=레이블색
# 정점(타원) 속성 
# vertext.size= 정점 크기, vertex.color=정점 색, vertex.frame.color=정점 테두리 색

# 7.단어 근접중심성(closeness centrality) 파악
#----------------------------------------------------
closen <- closeness(ruleg) # edgelist 대상 단어 근접중심성 생성 
#closen <- closen[c(2:8)] # {} 항목제거
closen <- closen[c(1:10)] # 상위 1~10 단어 근접중심성 보기
plot(closen, col="red",xaxt="n", lty="solid", type="b", xlab="단어", ylab="closeness") 
points(closen, pch=16, col="navy") 
axis(1, seq(1, length(closen)), V(ruleg)$name[c(1:10)], cex=5)
# 중심성 : 노드(node)의 상대적 중요성을 나타내는 척도이다.
# plot, points(), axis() : graphics 패키지(기존 설치됨)




#############################################
# 단계3 - 감성 분석(단어의 긍정/부정 분석) 
#  - 시각화 : 파랑/빨강 -> 불만고객 시각화
#############################################

# 1) 데이터 가져오기("c:/Rwork/Part-II/reviews.csv") 
data<-read.csv("c:/Rwork/Part-II/reviews.csv") # file.choose() 파일 선택
head(data,2)
dim(data) # 100   2
str(data) # 변수명 : company, review <- 고객 인터뷰 내용
class(data)
# 2) 단어 사전에 단어추가

# 긍정단어와 부정단어를 카운터하여 긍정/부정 형태로 빈도 분석
#neg.txt : 부정어 사전
#pos.txt : 긍정어 사전

# (1) 긍정어/부정어 영어 사전 가져오기
setwd("C:/Rwork/Part-II")
posDic <- readLines("posDic.txt")
negDic <- readLines("negDic.txt")
length(posDic) # 2006
length(negDic) # 4783


# (2) 긍정어/부정어 단어 추가 
posDic.final <-c(posDic, 'victor')
negDic.final <-c(negDic, 'vanquished')
# 마지막에 단어 추가
posDic.final; 
negDic.final 

a=c('d','c')
a=c(a,'a')

# 3) 감성 분석 함수 정의-sentimental

# (1) 문자열 처리를 위한 패키지 로딩 
install.packages('plyr')
library(plyr) # laply()함수 제공
library(stringr) # str_split()함수 제공

# (2) 감성분석을 위한 함수 정의
sentimental = function(sentences, posDic, negDic){
  
  scores = laply(sentences, function(sentence, posDic, negDic) {
    
    sentence = gsub('[[:punct:]]', '', sentence) #문장부호 제거
    sentence = gsub('[[:cntrl:]]', '', sentence) #특수문자 제거
    sentence = gsub('\\d+', '', sentence) # 숫자 제거
    sentence = tolower(sentence) # 모두 소문자로 변경(단어가 모두 소문자 임)
    
    word.list = str_split(sentence, '\\s+') # 공백 기준으로 단어 생성 -> \\s+ : 공백 정규식, +(1개 이상) 
    words = unlist(word.list) # unlist() : list를 vector 객체로 구조변경
    
    pos.matches = match(words, posDic) # words의 단어를 posDic에서 matching
    neg.matches = match(words, negDic)
    
    pos.matches = !is.na(pos.matches) # NA 제거, 위치(숫자)만 추출
    neg.matches = !is.na(neg.matches)
    
    score = sum(pos.matches) - sum(neg.matches) # 긍정 - 부정    
    return(score)
  }, posDic, negDic)
  
  scores.df = data.frame(score=scores, text=sentences)
  return(scores.df)
}

# 4) 감성 분석 : 두번째 변수(review) 전체 레코드 대상 감성분석
result<-sentimental(data[,2], posDic.final, negDic.final)
result
names(result) # "score" "text" 
dim(result) # 100   2
result$text
result$score # 100 줄 단위로 긍정어/부정어 사전을 적용한 점수 합계

# score값을 대상으로 color 칼럼 추가
result$color[result$score >=1] <- "blue"
result$color[result$score ==0] <- "green"
result$color[result$score < 0] <- "red"

# 감성분석 결과 차트보기
plot(result$score, col=result$color) # 산포도 색생 적용
barplot(result$score, col=result$color, main ="감성분석 결과화면") # 막대차트


# 5) 단어의 긍정/부정 분석 

# (1) 감성분석 빈도수 
table(result$color)

# (2) score 칼럼 리코딩 
result$remark[result$score >=1] <- "긍정"
result$remark[result$score ==0] <- "중립"
result$remark[result$score < 0] <- "부정"

sentiment_result<- table(result$remark)
sentiment_result

# (3) 제목, 색상, 원크기
pie(sentiment_result, main="감성분석 결과", 
    col=c("blue","red","green"), radius=0.8) # ->  1.2

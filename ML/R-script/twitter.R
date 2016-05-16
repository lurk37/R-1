##########################
# twitter 데이터 크롤링  #
##########################

# 관련 패키지 설치 
install.packages("twitteR") # twitter 인증관련 함수 제공 
install.packages("ROAuth") # OAuthFactory 객체 제공 
library(twitteR)
library(ROAuth) 

# 트위터 인증
# [Details] - 3개 url 변수 생성
reqURL <- "https://api.twitter.com/oauth/request_token"
authURL <- "https://api.twitter.com/oauth/authorize"
accessURL <- "https://api.twitter.com/oauth/access_token"

# firstAppkimjs 앱 : [Keys and Access Tokens] - 4개 변수 : ##Site에서 받아온다.
apiKey <-  "4oSWIgRBJhgJp9ealN3roZESy" 
apiSecret <- "oNUyEwjLdpotKW07jUQBMUKLP0O3ftU8v2WNgIBABxmRFk9fBl" 
accessToken="219144141-8SZQM7mONquJXhQ9m1gqpVwyb4aNhS3e6yj96CtH"
accessTokenSecret="uCslQm4IELIgsyFLJAj1RfIqPEqyqEe47YjGVF0W3s794"

# 앱 키, 시크릿, URL 이용 twitter 접근 객체 생성
twitCred <- OAuthFactory$new(
  consumerKey = apiKey, 
  consumerSecret = apiSecret,
  requestURL = reqURL,
  accessURL = accessURL, 
  authURL = authURL
)

# twitter 접근객체를 이용하여 인증코드로 교환
# 인증코드를 트위터에서 받아온다. 
# RCurl 패키지 : HTTP/FTP, SSL/HTTPS 프로토콜 기반 요청/응답으로 인증 수행 
twitCred$handshake(
  cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")
)

# 실행순서 : 함수 실행 -> 트위터 로그인 -> 웹 인증 -> 인증 코드 복사 ->  
# 콘솔 창!!!!!!에 인증 코드 붙여넣기 -> 엔터 -> 인증수행 스크립트 실행 

# twitter 인증수행 : twitterR 패키지에서 제공하는 함수 실행
setup_twitter_oauth(apiKey, 
                    apiSecret,
                    accessToken,
                    accessTokenSecret)
# 함수 실행 -> 선택: 1(1: Yes)
# [1] "Using direct authentication"


# 트위터 단어 검색 - 1차 검색어, 2차 검색어 
install.packages("base64enc")
library(base64enc)
keyword <- enc2utf8("빅데이터") # UTF-8 인코딩 방식 지정 - base 패키지 


# 트위터 자료구조 보기
test<-searchTwitter(keyword, n=300) # twitteR 패키지 제공 
test
class(test) # [1] "list"

# list -> vector형 변환  
n <- 1: length(test)
test_vec <- vector() # vector 객체 생성 

for(i in n){
  test_vec[i] <- test[[i]]$getText()
}
test_vec

# data type과 구조보기 
class(test_vec); str(test_vec)

# csv 타입으로 파일 저장 
write.csv(test_vec, "c:/Rwork/ML/data/test.txt", quote = FALSE, row.names = FALSE)

test_txt <- file("C:/Rwork/ML/data/test.txt")
twitter <- readLines(test_txt)
str(twitter)

# 내용 추가
# 1. 연관어 분석
# 2. 감성분석
# 3. 토픽분석

# 한글 처리를 위한 패키지 설치
#install.packages("rJava")
#이거 안해줘도 되는데? Sys.setenv(JAVA_HOME='C:\\Program Files\\Java\\jre1.8.0_60')
library(rJava) # 아래와 같은 Error 발생 시 Sys.setenv()함수로 java 경로 지정

#install.packages("KoNLP")
library(KoNLP) # rJava 라이브러리가 필요함

# 2. 줄 단위 단어 추출
#----------------------------------------------------
# Map()함수 이용 줄 단위 단어 추출 : Map(f, ...) -> base)
lword <- Map(extractNoun, twitter) 
length(lword) 
# [1] 454
lword <- unique(lword) # 중복제거1(전체 대상)
length(lword) 
# [1] 180
lword <- sapply(lword, unique) # 중복제거2(줄 단위 대상) 
length(lword) 
# [1] 180
str(lword) # List of 34
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
#----------------------------------------------


# 4. 트랜잭션 생성 : 연관분석을 위해서 단어를 트랜잭션으로 변환
#----------------------------------------------------
# arules 패키지 설치
#install.packages("arules")
library(arules) 
#--------------------
# arules 패키지 제공 기능
# - Adult,Groceries 데이터 셋
# - as(),apriori(),inspect(),labels(),crossTable()
#-------------------
wordtran <- as(lword, "transactions") # lword에 중복데이터가 있으면 error발생

# 트랜잭션 객체를 열면 transaction(1회 거래) - 상품(item)
# 줄 -> transaction, 단어 -> items 
wordtran 
#transactions in sparse format with
#180 transactions (rows) and   <- 줄 수  
#401 items (columns) <- 트랜잭션에 대한 전체 단어수 

# 트랜잭션 내용 보기 -> 각 트랜잭션의 단어 보기
inspect(wordtran)  

# 동일한 단어끼리 교차테이블 작성 
wordtable <- crossTable(wordtran) # 교차표 작성
length(wordtable) # 6084
str(wordtable) # [1:78, 1:78] 
#----------------------------------------------------

# 5.단어 간 연관규칙 산출
#----------------------------------------------------
# 트랜잭션 데이터를 대상으로 지지도와 신뢰도를 적용하여 연관규칙 생성
# parameter : support 0.1, conﬁdence 0.8, and maxlen 10(연관단어 최대수) 
tranrules <- apriori(wordtran, parameter=list(supp=0.03, conf=0.8))  # 54 rule(s)
# 0.22 -> 84 rules, supp=0.25 -> 59 rules -> 23개  -> 84 rule(s) -> 86

inspect(tranrules) # 연관규칙 생성 결과(23개) 보기

# 6.연관어 시각화 - rulemat[c(11:23),] # 연관규칙 결과- {} 제거(1~33)

# (1) 데이터 구조 변경 : 연관규칙 결과 -> 행렬구조 변경(matrix 또는 data.frame) 
rules <- labels(tranrules, ruleSep=" ") # 연관규칙 레이블을 " "으로 구분하여 변경   
rules # 예) 59 {경영,마케팅}   => {자금} -> 59 "{경영,마케팅} {자금}"
class(rules)
#[1] "character"
#------------------------
# strsplit(), sapply(), do.call() - base 패키지 제공 
# 규칙을 공백으로 분리하여 list로 반환 
rules <- sapply(rules, strsplit, " ",  USE.NAMES=F) 
rules
class(rules) # [1] "list"
# 행 단위로 묶어서 matrix로 반환
rulemat <- do.call("rbind", rules)
rulemat
class(rulemat)
#[1] "matrix"
#-----------------------

# (2) 연관어 시각화를 위한 igraph 패키지 설치
#install.packages("igraph") # graph.edgelist(), plot.igraph(), closeness() 함수 제공
library(igraph)   

# (3) edgelist보기 - 연관단어를 정점 형태의 목록 제공 
ruleg <- graph.edgelist(rulemat[c(1:21),], directed=F) # [1,]~[11,] "{}" 제외


# (4) edgelist 시각화
X11()
plot.igraph(ruleg, vertex.label=V(ruleg)$name,
            vertex.label.cex=1.0, vertex.label.color='black', 
            vertex.size=20, vertex.color='green', vertex.frame.color='blue')
# 정점(타원) 레이블 속성
# vertex.label=레이블명,vertex.label.cex=레이블 크기, vertex.label.color=레이블색
# 정점(타원) 속성 
# vertext.size= 정점 크기, vertex.color=정점 색, vertex.frame.color=정점 테두리 색

# 7.단어 근접중심성(closeness centrality) 파악
closen <- closeness(ruleg) # edgelist 대상 단어 근접중심성 생성 
#closen <- closen[c(2:8)] # {} 항목제거
closen <- closen[c(1:10)] # 상위 1~10 단어 근접중심성 보기
plot(closen, col="red",xaxt="n", lty="solid", type="b", xlab="단어", ylab="closeness") 
points(closen, pch=16, col="navy") 
axis(1, seq(1, length(closen)), V(ruleg)$name[c(1:10)], cex=5)
# 중심성 : 노드(node)의 상대적 중요성을 나타내는 척도이다.
# plot, points(), axis() : graphics 패키지(기존 설치됨)

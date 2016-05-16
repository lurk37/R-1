# 텍스트 마이닝(Text Mining)
# - 정형화 되지 않은 텍스트를 대상으로 유용한 정보를 찾는 기술
# - 토픽분석, 연관어 분석, 감성분석 등
# - 텍스트 마이닝에서 가장 중요한 것은 형태소 분석
# - 형태소 분석 : 문장을 분해 가능한 최소한의 단위로 분리하는 작업이다. 
#install.packages(c('tm','SnowballC'))
library(tm) #tm_map(corpus객체, 함수)
library(SnowballC) # stemDocument()함수 제공 



# 1. sms_spam.csv 가져오기 - stringsAsFactors = FALSE : factor형으로 읽지 않음 
sms_data <- read.csv('C:/Rwork/ML/data/sms_spam.csv', stringsAsFactors = FALSE)
str(sms_data)
#'data.frame':	5558 obs. of  2 variables:
# $ type: chr  "ham" "ham" "ham" "spam" ...
# $ text: chr  "Hope you are having a good week. Just checking in" "K..give back my thanks."
                
# 2. 분석을 위한 데이터 처리 : sms 문장을 단어 단위로 생성해야 한다. 

data(crude)
str(crude)
#data. frame 은 말뭉치로 바꿔야 분석할 수 있음
#sms_corpus = Corpus(VectorSource(sms_data$text)) # 1) 말뭉치 생성(vector -> corpus 변환) 
#sms_corpus[[1]]$content #첫번째 컨턴츠 보기
sms_corpus = tm_map(crude, content_transformer(tolower))  # 2) 소문자 변경
sms_corpus[[4]]$content #네번째 컨턴츠 보기
sms_corpus = tm_map(sms_corpus, removeNumbers) # 3) 숫자 제거 
sms_corpus = tm_map(sms_corpus, removePunctuation) # 4) 문장부호(콤마 등) 제거 
stopwords("SMART") #등록된 단어 stopwords("English") 요즘엔 SMART 씀
sms_corpus = tm_map(sms_corpus, removeWords, stopwords("SMART")) # 5) stopwords(the, of, and 등) 제거  
sms_corpus = tm_map(sms_corpus, stripWhitespace) # 6) 여러 공백 제거(stopword 자리 공백 제거)   
sms_corpus = tm_map(sms_corpus, stemDocument) # 7) 유사 단어 어근 처리 
#complimentary -> complimentari 
sms_corpus = tm_map(sms_corpus, stripWhitespace) # 8) 여러 공백 제거(어근 처리 공백 제거)   
#희소행렬: row(doc), column(term)
sms_dtm = DocumentTermMatrix(sms_corpus) # 9) 문서와 단어 집계표 작성
# 단어 구름 시각화 
#install.packages('wordcloud')
library(wordcloud) # 단어 시각화(빈도수에 따라 크기 달라짐)

# 색상 12가지 적용 
pal <- brewer.pal(12,"Paired") # RColorBrewer 패키지 제공(wordcloud 설치 시 함께 설치됨)

t(sms_dtm) # <<TermDocumentMatrix (terms: 6822, documents: 5558)

sms_mt <- as.matrix(t(sms_dtm)) # 행렬 변경 

# 행 단위(단어수) 합계 -> 내림차순 정렬   
rsum <- sort(rowSums(sms_mt), decreasing=TRUE) 

# vector에서 칼럼명(단어명) 추출 
myNames <- names(rsum) # rsum 변수에서 칼럼명(단어이름) 추출  
myNames # 단어명 

# 단어와 빈도수를 이용하여 df 생성 
df <- data.frame(word=myNames, freq=rsum) 
head(df) # word freq

# wordCloud(단어(word), 빈도수(v), 기타 속성)
# random.order=T : 위치 랜덤 여부(F 권장) , rot.per=.1 : 회전수, colors : 색상, family : 글꼴 적용 
wordcloud(df$word, df$freq, min.freq=2, random.order=F, scale=c(4,0.7),
                            rot.per=.1, colors=pal, family="malgun") 

#단어 수 조정 - 단어 길이, 가중치 적용
sms_dtm #documents: 5558, terms: 6822)Maximal term length: 40
#단어 길이 너무 커 1자~ 8자
sms_dtm2 =DocumentTermMatrix(sms_corpus,
                             control=list(wordLengths=c(1,8),
                             weighting = weightTfIdf)) 
#단어길이 4자~무한대 조정
sms_dtm2 =DocumentTermMatrix(sms_corpus,
                             control=list(wordLengths=c(4,Inf),
                                          weighting = weightTfIdf)) 

#weightTfIdf
#출현빈도

#길이 8 인 단어 조회
term=sms_dtm2$dimnames$Terms
library(stringr)
term[str_length(term)>=8]

####빈도수 단어 찾기####
#tm 패키지에서 제공하는 함수
findFreqTerms(sms_tdm,lowfreq = 6)


####상관계수로 단어 찾기####
data <-  c("word1", "word1 word2","word1 word2 word3","word1 word2 word3 word4","word1 word2 word3 word4 word5")
frame <-  data.frame(data)
frame
data
#1                         word1
#2                   word1 word2
#3             word1 word2 word3
#4       word1 word2 word3 word4
#5 word1 word2 word3 word4 word5
test <-  Corpus(DataframeSource(frame))
dtm <-  DocumentTermMatrix(test)
as.matrix(dtm)
#Docs word1 word2 word3 word4 word5
#1     1     0     0     0     0
#2     1     1     0     0     0
#3     1     1     1     0     0
#4     1     1     1     1     0
#5     1     1     1     1     1
 
findAssocs(dtm, "word2", 0.2)  #전체텀에서 조건용어(word2)의 출현횟수와 비슷한 단어를 찾아
#word2 word3 word4 word5 
#1.00  0.61  0.41  0.25 
# Correlation word2 with word3
cor(c(0,1,1,1,1),c(0,0,1,1,1)) #[1] 0.6123724
# Correlation word2 with word4
cor(c(0,1,1,1,1),c(0,0,0,1,1)) #[1] 0.4082483
# Correlation word2 with word5
cor(c(0,1,1,1,1),c(0,0,0,0,1)) #[1] 0.25
######################################################
# 1. plyr 패키지 활용 - 데이터 병합
######################################################

install.packages('plyr')
library(plyr) # 패키지 로딩

# 병합할 데이터프레임 셋 만들기
x = data.frame(ID = c(1,2,3,4,5), height = c(160,171,173,162,165)) #5번 아이디가 없음
y = data.frame(ID = c(5,4,1,3,2), weight = c(55,73,60,57,80)) #6번 아이디가 없음

# 1. join() : plyr패키지 제공 함수
z <- join(x,y,by='ID') # ID컬럼으로 조인
z
#merge 로 병합: merge(x,y,'ID')

# left 조인
z <- join(x,y,by='ID') # ID컬럼으로 left 조인(왼쪽 변수 기준,여기서 x)

z <- join(x,y,by='ID', type='inner') # type='inner' : 값이 있는 것만 조인

z <- join(x,y,by='ID', type='full') # type='full' : 모든 항목 조인


# key값으로 병합하기

x = data.frame(key1 = c(1,1,2,2,3), 
               key2 = c('a','b','c','d','e'),
               val1 = c(10,20,30,40,50))
y = data.frame(key1 = c(3,2,2,1,1), 
               key2 = c('e','d','c','b','a'),
               val2 = c(500,400,300,200,100))

join(x,y,by=c('key1', 'key2'))


# 2. tapply() 함수 이용 - 그룹별 통계치 구하기
# 형식) tapply(적용data, 집단변수, 함수)

# 꽃의 종류별(Species)로 꽃받침 길이 평균 구하기
tapply(iris$Sepal.Length, iris$Species, mean) 

# 3. ddply() : plyr 패키지 제공 함수
# 형식) ddply(dataframe, .(집단변수), 요약집계, 컬럼명=함수(변수))

# 꽃의 종류별(Species)로 꽃받침 길이(Sepal.Length)의 평균 계산
a <- ddply(iris, .(Species), summarise, avg = mean(Sepal.Length))

################################################
# 2. dplyr 패키지 활용
################################################

# dplyr 패키지와 데이터 셋 hflight 설치
install.packages(c("dplyr", "hflights"))
library(dplyr)
library(hflights) 

# 1. tbl_df() 함수 : 데이터셋 화면창 안에서 한 눈(콘솔창)에 파악할 수 있는 데이터 구성
hflights_df <- tbl_df(hflights)

# 2. filter(dataframe, 조건1,조건2)함수를 이용한 데이터 추출
# 1월 1일 데이터 추출
filter(hflights_df, Month == 1 & DayofMonth == 1) #,은 & 임 
#filter(hflights_df, Month == 1, DayofMonth == 1) #,은 & 임 

# 1월 혹은 2월 데이터 추출
filter(hflights_df, Month == 1 | Month == 2) 

##!! 칼럼의 범위 지정 : Year~DayOfWeek 선택 #욤마는 쓸 만 할 수도
select(hflights_df, Year:DayOfWeek)

# 칼럼의 범위 제외 : Year부터 DayOfWeek 제외
select(hflights_df, -(Year:DayOfWeek))


# -------------------------------------------------------------
# <실습문제> Month 기준으로 내림차순 정렬하여  
#            Year, Month, AirTime, ArrDelay 컬럼을 선택하시오.
# -------------------------------------------------------------

# mutate()로 변수 추가 후, 새로 추가된 열을 select() 함수 변수 선택하기
select(mutate(hflights_df, gain = ArrDelay - DepDelay, 
              gain_per_hour = gain/(AirTime/60)), 
       Year, Month, ArrDelay, DepDelay,gain, gain_per_hour)

# 7. group_by(dataframe, 기준변수)함수를 이용한 그룹화

#  example : 항공기별 비행편수 20편 초과, 평균 비행거리 
#            2,000마일 이내의 평균 연착시간 구하기

# 4) 결측치 처리 : dist와 delay가 모두 1이상인 경우만 필터링
a=filter(result, dist>=1 & delay>=1)

# 1) 비행편수를 구하기 위해서 항공기별 그룹화 #파일 내부에 그룹화가 됨
planes <- group_by(hflights, TailNum) # TailNum : 항공기 일련번호 그룹
planes

# 2) 항공기별 필요한 변수(count,Distance,ArrDelay) 요약
planesInfo <- summarise(planes, count = n(), 
                        dist=mean(Distance, na.rm= T), 
                        delay=mean(ArrDelay, na.rm = T))
# n() : row값 리턴
# delay 내림차순, dist 오름차순 변수 순으로 정렬
arrange(planesInfo, desc(delay), dist)

######################################################
# 3. reshape2 패키지 활용
######################################################


install.packages('reshape2')
library(reshape2)

# 1. dcast()함수 이용 : 긴 형식 -> 넓은 형식 변경
# - '긴 형식'(Long format)을 '넓은 형식'(wide format)으로 모양 변경

data <- read.csv("c:/Rwork/Part-II/data.csv")
data

# data.csv 데이터 셋 구성 - 22개 관측치, 3개 변수
# Date : 구매날짜
# Customer : 고객ID
# Buy : 구매수량

# (1) '넓은 형식'(wide format)으로 변형
# 형식) dcast(데이터셋, 앞변수~뒤변수, 함수)
# 앞변수 : 행 구성, 뒷변수 : 칼럼 구성

wide <- dcast(data, Customer_ID ~ Date, sum)
wide 


# (2) 열 또는 행 단위 통계치 계산 함수 
# - colSums(), rowSums(), colMeans(), rowMeans()

# 고객별,날짜별 구매횟수의 합계 구하기
rowSums(wide) # 행 합계 -> 고객별
colSums(wide) # 열 합계 -> 날짜별

# - cbind와 rbind() 이용하여 원래 데이터 셋에 붙임 
wide <- cbind(wide, rowSums(wide)) # 컬럼으로 행 합계 붙임
wide <- rbind(wide, colSums(wide)) # 행으로 컬럼 합계 붙임
wide

# 2. melt() 함수 이용 : 넓은 형식 -> 긴 형식 변경
#   형식) melt(데이터셋, id='열이름 변수')

wide <- wide[-6,-9] # 6행과 9컬럼 제거
wide

# - 긴 형식 변경
long <- melt(wide, id='Customer_ID') 
long
# id변수를 기준으로 넓은 형식이 긴 형식으로 변경

#-----------------------------------------------------------
# < reshape2 패키지 관련 연습문제> 
#------------------------------------------------------------

# <연습문제> reshape2 패키지를 적용하여 각 다음 조건에 맞게 iris 데이터 셋을 처리하시오. 
# <조건1> 꽃의 종류를 기준으로 긴 형식(long format)으로 변경
iris.melt=melt(iris,id='Species')
# <조건2> 꽃의 종류별로 Sepal.Length 변수의 평균 구하기
group_species=group_by(iris, Species)

result=summarise(group_species, mean.Sepal.Length=mean(Sepal.Length))

dt_iris=as.data.table(iris)
dt_iris[,list(mean.Sepal.Length=mean(Sepal.Length)),Species]


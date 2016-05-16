#chap11_VisualizationAnalysis
# 1. lattice 패키지
install.packages("lattice")
library(lattice)

install.packages("mlmRev")
library(mlmRev)
data(Chem97) # Chem97 데이터 셋 로드
#mlmRev 패키지에서 제공되는 데이터 셋으로 1997년 영국 2,280개 학교
#31,022명 학생을 대상으로 A레벨(대학시험) 화학점수를 기록한 데이터 셋이다.
#전체 31,022개의 관측치와 8개의 변수로 구성되어 있다.
#주요 변수 : lea(Local Education Authority) : 지방교육청(범위:1~15),
#school :학교 id(범위 : 1~132), student : 학생 id(범위 : 1~1250)
#score : A레벨 화학점수(범위:0,2,4,6,8,10), gender : 성별(범위:M, F),
#age : 18.5세 기준 월수(범위 : -6~+5),
#gcsescore : GCSE 개인평균성적(범위 : 0 ~ 8 사이 실수)
#※ GCSE(General Certificate of Secondary Education)는 고등학교 재학 중에
#치루는 수학능력인증시험을 의미한다.

str(Chem97) # 차원보기
head(Chem97,30)

# 1.histogram : 변수 대상으로 백분율 적용 히스토그램 생성
# 형식1) (~x축, dataframe)
histogram(~gcsescore, data=Chem97) 

# 형식2) histogram(~x축 | 조건, dataframe)
histogram(~gcsescore | score, data=Chem97) 
histogram(~gcsescore | factor(score), data=Chem97) 

# 2.densityplot : 밀도 그래프
# 형식) (~x축 | 조건, dataframe, groups=변수)
densityplot(~gcsescore | factor(score), data=Chem97, 
            groups = gender, plot.points=T, auto.key = T) 


# 차트 작성을 위한 데이터 리모델링 

# 1) 데이터셋 가져오기
data(VADeaths)
VADeaths
str(VADeaths)

# 2) 데이터셋 구조보기
mode(VADeaths) # numeric
class(VADeaths) # matrix

# 3) 데이터 리모델링(함수에서 데이터 처리 목적)
# (1) matrix -> data.frame 변환
df <- as.data.frame(VADeaths)
str(df) 
class(df) 
df 

# (2) matrix -> data.table 변환 #wide->long 
dft <- as.data.frame.table(VADeaths)
str(dft)
class(dft) 
dft 


# 3.barchart : 막대 그래프
# 형식) (y~x | 조건, dataframe, layout)
barchart(Var1 ~ Freq | Var2, data=dft, layout=c(4,1))


# 4.dotplot : 점 그래프
# 형식) (y~x | 조건 , dataframe, layout)
dotplot(Var1 ~ Freq | Var2 , dft) 

# Var2변수 단위(그룹화)로 점을 연결하여 플로팅  
dotplot(Var1 ~ Freq, data=dft, groups=Var2, type="o", 
        auto.key=list(space="right", points=T, lines=T))


# 5.xyplot : xyplot()함수 확장
# 형식) (y축~x축| 조건, dataframe or list)
library(datasets)
str(airquality) # airqulity 테이터 셋 로드

# airquality의 Ozone(y),Wind(x) 산점도 플로팅
xyplot(Ozone ~ Wind, data=airquality) 

# Month변수 단위로 플로팅
xyplot(Ozone ~ Wind | Month, data=airquality) 
xyplot(Ozone ~ Wind | Month, data=airquality, layout=c(5,1))


head(quakes) # quakes 데이터셋 로드
str(quakes) 

# 지진발생 위치(위도와 경로)
xyplot(lat~long, data=quakes, pch=".")  
# 그래프를 변수에 저장
tplot<-xyplot(lat~long, data=quakes, pch=".")
# 그래프에 제목 추가
tplot2<-update(tplot,
               main="1964년 이후 태평양에서 발생한 지진위치")
print(tplot2)

# 6. equal.count() : 지정된 범위 대상 영역구분과 카운팅
# 형식) equal.count(data, number, overlap)

# (1) 지진의 깊이를 3영역으로 구분하여 카운팅
depthgroup<-equal.count(quakes$depth, number=3, overlap=0)


# (2) depthgroup변수 기준으로 플로팅
xyplot(lat ~ long | depthgroup, data=quakes,
       main="Fiji Earthquakes(depthgruop)",
       ylab="latitude", xlab="longitude", pch="@", col='red' )

# --------------------------------------------------------------------------
# <연습문제1> lattice 패키지 관련 
# --------------------------------------------------------------------------
# <연습문제1> quakes 데이터셋의 수심(depth)과 리히터규모(mag)가 동일한 패널에 
#   지진의 발생지가 산점도 그래프에 의해서 나타나도록 하시오.
head(quakes)

#조건1) 수심 3개 영역으로 범주화
depthgroup<-equal.count(quakes$depth, number=3, overlap=0)
class(depthgroup)
#조건2) 리히터규모 2개 영역으로 범주화
maggroup<-equal.count(quakes$mag, number=2, overlap=0)


#조건3) 수심과 리히터규모가 3행 2열 구조의 패널로 산점도 그래프 그리기
# 힌트1)  lattice 패키지의 equal.count()와 xyplot() 함수 이용
# 힌트2) 수심과 리히터규모 동시 표현 :  수심 * 리히터규모

quakes$depthgroup=depthgroup
quakes$maggroup=maggroup

xyplot(lat ~ long | maggroup*depthgroup, data=quakes, layout=c(3,2))


#<연습문제2> latticeExtra패키지에서 제공한 SeatacWeather 데이터 셋에서 
# 월 별로 최저기온과 최고기온을 선그래프로 플로팅 하시오.
# 힌트) xyplot() 함수 이용
# 힌트) 선그래프 : type="l"

# 7.cloud() :  3차원(위도, 경도, 깊이) 산점도 그래프
cloud(depth ~ lat * long , data=quakes,
      zlim=rev(range(quakes$depth)), 
      xlab="경도", ylab="위도", zlab="깊이")

##########################
# 삼성 주식데이터 시각화 #
##########################
samsung=read.csv('http://www.google.com/finance/historical?q=KRX%3A005930&ei=nroZV7nzC4SL0gSQoYTgBw&output=csv',header = T,encoding = 'UTF-8')

colnames(samsung)=c('Date','Open','High','Low','Close, Volume')

#일-월-연도 -> YYYY-mm-dd 로 변환
Sys.setlocale(locale='US')
sdate=samsung$Date
sdate2=as.Date(sdate,'%d-%b-%y')
head(sdate2)
class(sdate2)
samsung$sdate2=sdate2
samsung_kospi=head(samsung,15)
head(samsung)

library(lattice)
xyplot(High + Low ~ sdate2, data=samsung_kospi, type='o')



# 2. latticeExtra
# 격자 형태의 그래플 제공, 다차원 데이터를 격자형으로 동시에 표현

install.packages("latticeExtra")
library(latticeExtra)
data(SeatacWeather) # latticeExtra 데이터
SeatacWeather
str(SeatacWeather)

# --------------------------------------------------------------------------
# <연습문제2> lattice 패키지 관련 
# --------------------------------------------------------------------------

# 주요 함수 
#1. doubleYScale() : double y축 생성 그래프

# (1) y축:강수량(precip) ~ x축:일(day) | 조건:월(month) , 직선 그래프(type="h")
rain <- xyplot(precip ~ day | month, data=SeatacWeather, type="h")
print(rain) # 월별 강수량 직선 그래프

# (2) y축(최저기온+최고기온)~x축:일(day) | 조건월(month), 선그래프(type="l")
temp <- xyplot(min.temp + max.temp ~ day | month,
               data=SeatacWeather, type="l", layout=c(3,1)) # type=line
print(temp)

# (3) 기온(2)과 강수량(1) 그래프 통합-doubleYScale(latticeExtra 제공)
doubleYScale(temp, rain,  style1=0, style2=3, add.ylab2=T, 
             text=c("min", "max", "rain"), columns=3)

# 왼쪽 y축 style(style1=0), 오른쪽 y축 style(style2=3), 
# layout : temp 기준
# 왼쪽 y축이름(min.temp + max.temp)
# add.ylab2=T : 오른쪽 Y축이름(precip), text : 범례 추가

# 직전 그래프에 색상 추가 
update(trellis.last.object(), 
       par.settings=simpleTheme(col=c("green","red","blue")))


# 2. ecdfplot() : 누적분포함수 결과 그래프 생성
# New York Choral Society 합창단 성악가의 목소리 영역과 키 관계

data(singer, package = "lattice") 
head(singer)
str(singer) # 'data.frame': 235 obs. of  2 variables
names(singer)
# height voice.part
range(singer$height) # [1] 60 76
attributes(singer$voice.part) #변수의 속성보기

# Bass 2 서브셋 작성
data <- subset(singer, singer$voice.part=='Bass 2')
str(data) # [1] 26  2 -> Bass 2 관측치 26개
range(data$height) # [1] 66 75 -> Bass 2 키 범위
table(data$height) # Bass 2 키 빈도수
7/26 # [1] 0.2692308 

ecdfplot(~height | voice.part, data = singer)
# factor형 변수(voice.part)를 조건으로 height변수에 CDF 적용 누적분포함수 
# Empirical CDF : 
#  누적분포함수(Cumulative Distribution Functions)의 조건을 격자구조로 나타낸다.

#### 3. ggplot2 패키지####

install.packages("ggplot2") # 패키지 설치
library(ggplot2)

### ggplot2 패키지 제공 데이터 셋
data(diamonds) # 데이터 셋 가져오기
data(mtcars)
data(mpg) 

str(mpg) # map 데이터 셋 구조 보기
head(mpg) # map 데이터 셋 내용 보기 
summary(mpg) # 요약 통계량
table(mpg$drv) # 구동방식 빈도수 

# 1. qplot() 함수

# (1) 1개 변수 대상 기본 - 속이 꼭찬 막대 모양의 세로막대 그래프 
qplot(hwy, data=mpg) # 세로막대 그래프
#  fill 옵션 : hwy 변수를 대상으로 drv변수에 색 채우기(누적 막대그래프) 

qplot(hwy, data=mpg, fill=drv) # fill 옵션 적용
# binwidth 옵션 : 막대 폭 지정 옵션

qplot(hwy, data=mpg, fill=drv, binwidth=2) # binwidth 옵션 적용 
# facets 옵션 : drv변수 값으로 칼럼단위와 행 단위로 패널 생성

qplot(hwy, data=mpg, fill=drv, facets=.~ drv, binwidth=2) # 열 단위 패널 생성
qplot(hwy, data=mpg, fill=drv, facets=drv~., binwidth=2) # 행 단위 패널 생성


# (2) 2변수 대상 기본 - 속이 꽉찬 점 모양과 점의 크기는 1를 갖는 산점도 그래프
qplot(displ, hwy, data=mpg)# mpg 데이터셋의 displ과 hwy변수 이용
# displ, hwy 변수 대상으로 drv변수값으로 색상 적용 산점도 그래프
qplot(displ, hwy, data=mpg, color=drv)


# (3) 색상, 크기, 모양 적용
### ggplot2 패키지 제공 데이터 셋
head(mtcars)
str(mtcars) # ggplot2에서 제공하는 데이터 셋
qplot(wt, mpg, data=mtcars, color=factor(carb)) # 색상 적용
qplot(wt, mpg, data=mtcars, size=qsec, color=factor(carb)) # 크기 적용
qplot(wt, mpg, data=mtcars, size=qsec, color=factor(carb), shape=factor(cyl))#모양 적용 
mtcars$qsec


# (4) geom 옵션 
### ggplot2 패키지 제공 데이터 셋
head(diamonds) 

# geom="bar" -> clarity변수 대상 cut변수로 색 채우기
qplot(clarity, data=diamonds, fill=cut, geom="bar") # 레이아웃에 색 채우기
qplot(clarity, data=diamonds, colour=cut, geom="bar") # 테두리 색 적용


# geom="point"
qplot(wt, mpg, data=mtcars, size=qsec) # geom="point" 기본
qplot(wt, mpg, data=mtcars, size=qsec, geom="point")
# cyl 변수의 요인으로 point 크기 적용, carb 변수의 요인으로 포인트 색 적용
qplot(wt, mpg, data=mtcars, size=factor(cyl), color=factor(carb), geom="point")

# qsec변수로 포인트 크기 적용, cyl 변수의 요인으로 point 모양 적용
qplot(wt, mpg, data=mtcars, size=qsec, color=factor(carb), shape=factor(cyl), geom="point")

# geom="smooth"
qplot(wt, mpg, data=mtcars, geom=c("point", "smooth"))
qplot(wt, mpg, data=mtcars, color=factor(cyl), geom=c("point", "smooth"))
# cyl변수 요인으로 색상 적용


# geom="line"
qplot(mpg, wt, data=mtcars, color=factor(cyl), geom="line")
qplot(mpg, wt, data=mtcars, color=factor(cyl), geom="point") + geom_line()

#  geom="freqpoly"
qplot(clarity, data=diamonds, geom="freqpoly", group=cut, colour=cut)

# (5) position 옵션 
# 다양한 bar 차트 유형("identity",stacked, dodged, identity)

# 채우기-가장 큰 값을 기준으로 채우기형 막대그래프
qplot(clarity, data=diamonds, geom="bar", fill=cut, position="identity")
# 채우기-가장 적은 값을 기준으로 채우기형 막대그래프 
qplot(clarity, data=diamonds, geom="bar", fill=cut, position="fill")
# 스택형태-누적형-기본형
qplot(clarity, data=diamonds, geom="bar", fill=cut, position="stack")
# 다지-살짝 비키다
qplot(clarity, data=diamonds, geom="bar", fill=cut, position="dodge")

# 2. ggplot()함수

# (1) aes(x,y,color) 옵션 
# aes(x,y,color) 속성 = aesthetics : 미학
p <-ggplot(diamonds, aes(carat, price, color=cut))
p + geom_point() # point 추가 

# (2) geom_line() 레이어 추가 
p<- ggplot(mtcars, aes(mpg,wt,color=factor(cyl)))
p+geom_line() # line 추가

# (3) geom_point()함수  레이어 추가
p<- ggplot(mtcars, aes(mpg,wt,color=factor(cyl)))
p+geom_point()  # point 추가

# (4) geom_step() 레이어 추가
p<- ggplot(mtcars, aes(mpg,wt,color=factor(cyl)))
p+geom_step()  # step 추가

# (5) geom_bar() 레이어 추가
p<- ggplot(diamonds, aes(clarity))
p+geom_bar(aes(fill=cut), position="fill")  # bar 추가



# 3. ggsave()함수 : save image of plot on disk 

p<-ggplot(diamonds, aes(carat, price, color=cut))
p+geom_point()  # point 추가

ggsave(file="C:/Rwork/output/diamond_price.pdf") # 가장 최근 그래프 저장
ggsave(file="C:/Rwork/output/diamond_price.jpg", dpi=72)

# 변수에 저장된 그래프 저장 
p<- ggplot(diamonds, aes(clarity))
p<- p+geom_bar(aes(fill=cut), position="fill")  # bar 추가
ggsave(file="C:/Rwork/output/bar.png", plot=p, width=10, height=5)


# --------------------------------------------------------------------------
# <연습문제3> ggplot2 패키지 관련 
# --------------------------------------------------------------------------

# <연습문제3> diamonds 데이터 셋을 대상으로 x축에 carat변수, y축에 price변수를 지정하고, 
# clarity변수를 선 색으로 지정하여 미적 요소 맵핑 객체를 생성한 후 산점도 그래프 주변에 
# 부드러운 곡선이 추가되도록 레이아웃을 추가하시오.
ggplot(diamonds, aes(carat,price))+geom_point(aes(colour=clarity))+geom_smooth(colour='red')

##########ggmap##############
# 4. ggmap 패키지

# 지도 관련 패키지 설치
library(ggplot2)
#install.packages("ggmap") # ‘ggmap’와 ‘ggplot2’(우선 설치) 관련 패키지
library(ggmap)

# 1. get_googlemap() 함수

#  지도위치정보를 이용하여 지도정보를 생성하고, 지도 이미지 그리기  
#(e.g. "1600 pennsylvania avenue, washington dc" or "Baylor University") 

# (1) 지도위치정보 가져오기
gc<- geocode("seoul, korea", source="google") # geolocation API 이용
center <- as.numeric(gc)
center # 위도,경도


#(2) 지도 정보 생성하기
map <- get_googlemap(center = center, language="ko-KR", color = "bw", scale = 2 )
# bw :  black-and-white - 흰색 바탕에 검은색 글자
# scale :  1, 2, or 4 (scale = 2 : 1280x1280 pixels) 

# (3) 지도 이미지 그리기
ggmap(map, extent = 'device')
# extent : 지도가 그려질 크기를 지정하는 옵션
#  ("normal", "device", or "panel" (default))

# [실습] round(), get_googlemap()함수

# 2.  get_map함수(2번째 방법, 이게 더 많이씀!!!!)
map <- get_map(location ="london", zoom=14, maptype='roadmap', scale=2)
# get_map("중심지역", 확대비율, 지도유형) : ggmap에서 제공하는 함수 
ggmap(map, size=c(600,600), extent='device')

map <- get_map(location ="seoul", zoom=14, maptype='watercolor', scale=2)
ggmap(map, size=c(600,600), extent='device')

# zoom 차이
map <- get_map(location ="seoul", zoom=14, scale=2)
map <- get_map(location ="seoul", zoom=8, scale=2)
ggmap(map, size=c(600,600), extent='device')

# source 차이(서버로 해석하면 됨,stamen)
map <- get_map(location = "texas", zoom = 6, source = "stamen")
# stamen : maptype='satellite' 지원 안됨
map <- get_map(location ="seoul", source = "osm", zoom=8, maptype='watercolor')
ggmap(map, size=c(600,600), extent='device')
map <- get_map(location = "seoul",zoom=14)
ggmap(map, size=c(600,600), extent='device')

# 3. 레이어 적용 

# 실습 데이터-서울지역 4년제 대학교 위치 표시
university <- read.csv("C:/Rwork/Part-III/university.csv",header=T)
university # # 학교명","LAT","LON"

# (1)레이어1 : 정적 지도 생성
kor <- get_map("seoul", zoom=11, maptype = "watercolor")#roadmap
# maptype : roadmap, satellite, terrain, hybrid

# (2)레이어2 : 지도위에 포인트
ggmap(kor)+geom_point(data=university, aes(x=LON, y=LAT,color=factor(학교명)),size=3)
kor.map <- ggmap(kor)+geom_point(data=university, aes(x=LON, y=LAT,color=factor(학교명)),size=3)

# (3)레이어3 : 지도위에 텍스트 추가
kor.map + geom_text(data=university, aes(x=LON+0.01, y=LAT+0.01,label=학교명),size=5)
# LAT+0.01 : 텍스트 위치(포인트의 0.01 위쪽)
# geom_text : 텍스트 추가

# (4)지도 저장
# 넓이, 폭 적용 파일 저장
ggsave("C:/Rwork/output/university1.png",width=10.24,height=7.68)
# 밀도 적용 파일 저장#dpi(dot point, 해상도)
ggsave("C:/Rwork/output/university2.png",dpi=1000) # 9.21 x 7.68 in image

# --------------------------------------------------------------------------
# <연습문제4> ggmap  패키지 관련 - marker 표시
# --------------------------------------------------------------------------


# <연습문제4> roadmap 지도 유형으로 서울지역 주요 대학교에 마커를 표시하시오.
#조건1) get_googlemap() 이용
#조건2) 데이터 셋 : C:/Rwork/Part-III/university.csv"
#조건3) 지도 이미지 저장 : C:/Rwork/output/university.png

# 실습 데이터-서울지역 4년제 대학교 위치 표시
university <- read.csv("C:/Rwork/Part-III/university.csv",header=T)
university # # 학교명","LAT","LON"

#1) 마커 표시(x,y)
x=university$LON #경도
y=university$LAT #위도
df=data.frame(x,y)

#2) 지도 정보
map=get_googlemap('seoul',zoom=11, markers=df)

#3) 지도 출력
ggmap(map)

#<공간시각화 실습>

# 2015년도 06월 기준 대한민국 인구수
pop <- read.csv("C:/Rwork/Part-III/population201506.csv",header=T)
pop

region <- pop$지역명   
lon <- pop$LON # 위도
lat <- pop$LAT # 경도
house <- pop$세대수

# 위도,경도,세대수 이용 데이터프레임 생성
df <- data.frame(region, lon,lat,house)
df
# 지도정보 생성
map1 <- get_map("daegu", zoom=7 ,  maptype='watercolor')
#map1 <- get_map("daegu", zoom=7 ,  maptype='roadmap')

# 레이어1: 지도 플로팅
map2 <- ggmap(map1)
map2

# 레이어2 : 포인트 추가
map2 + geom_point(aes(x=lon,y=lat,colour=house,size=house),data=df)
map3 <- map2 + geom_point(aes(x=lon,y=lat,colour=house,size=house),data=df)

# 레이어3 : 텍스트 추가
map3 + geom_text(data=df, aes(x=lon+0.01, y=lat+0.18,label=region),size=3)

# 크기, 넓이, 폭 적용 파일 저장
ggsave("C:/Rwork/output/population201506.png",scale=1,width=10.24,height=7.68)
#---------------------------------------------------

# <다양한 지도 유형>

# maptype='terrain'
map1 <- get_map("daegu", zoom=7 ,  maptype='terrain')
map2 <- ggmap(map1)
map3 <- map2 + geom_point(aes(x=lon,y=lat,colour=house,size=house),data=df)
map3 + geom_text(data=df, aes(x=lon+0.01, y=lat+0.18,label=region),size=3)


# maptype='satellite'
map1 <- get_map("daegu", zoom=7 ,  maptype='satellite')
map2 <- ggmap(map1)
map3 <- map2 + geom_point(aes(x=lon,y=lat,colour=house,size=house),data=df)
map3 + geom_text(data=df, aes(x=lon+0.01,y=lat+0.18,colour=region,label=region),size=3)

# maptype='roadmap'
map1 <- get_map("daegu", zoom=7 ,  maptype='roadmap')
map2 <- ggmap(map1)
map3 <- map2 + geom_point(aes(x=lon,y=lat,colour=house,size=house),data=df)
map3 + geom_text(data=df, aes(x=lon+0.01, y=lat+0.18,label=region),size=3)

# maptype='hybrid'
map1 <- get_map("jeonju", zoom=7,  maptype='hybrid')
map2 <- ggmap(map1)
map3 <- map2 + geom_point(aes(x=lon,y=lat,colour=house,size=house),data=df)
map3 + geom_text(data=df, aes(x=lon+0.01, y=lat+0.18,label=region),size=3)
map3 + geom_density2d()
# 밀도레이어 그래프 추가(geom_density2d)


# --------------------------------------------------------------------------
# <연습문제5> ggmap  패키지 관련 
# --------------------------------------------------------------------------
# <연습문제5> 각 지역별 총인구수를  'roadmap' 타입으로 시각화 하시오.
#조건1) 지도 중심 지역 Jeonju, zoom=7
#조건2) 지역명으로 텍스트 표시
#조건3) 데이터 셋 : C:/Rwork/Part-III/population201506.csv 



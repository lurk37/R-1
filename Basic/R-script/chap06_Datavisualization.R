#chap06_Datavisualization

# 이산변수와 연속변수 시각화

#1. 이산변수 시각화

#1) 막대차트 시각화
install.packages("RSADBE")
library(RSADBE)
help("RSADBE") # Package 정보제공

data(Severity_Counts) # RSADBE 패키지 제공 데이터셋
str(Severity_Counts) 
Severity_Counts # 버그 측정 데이터 셋

# (1) 세로 막대 차트
barplot(Severity_Counts, ylim=c(0,12000), 
        col=rainbow(10), main ="소프트웨어 버그 측정 결과(BR/AR)",
        font.main=4)

# (2) 가로 막대 차트
# xlab : x축 이름, xlim : x축 값 범위, horiz=T : 가로막대
barplot(Severity_Counts,xlab="Bug Count", xlim=c(0,12000), 
        horiz=T, col=rainbow(10)) # 10가지 무지개 색

barplot(Severity_Counts,xlab="Bug Count", xlim=c(0,12000), 
        horiz=T, col=rep(c(2, 4),5)) # red와 blue 색상 5회 반복

barplot(Severity_Counts,xlab="Bug Count", xlim=c(0,12000), 
        horiz=T, col=rep(c(1, 7),5)) 
# 1 : 검정, 2: 빨강, 3: 초록, 4: 파랑, 5: 하늘색, 6: 자주색, 7 : 노랑색


data(Bug_Metrics_Software) # RSADBE 패키지 제공 데이터셋
Bug_Metrics_Software # 행렬 구조 - 1면(Before)과 2면(After) 구성
# 5개의 소프트웨어 별로 발표전과 후 버그 측정 결과를 3차원 배열구조로 제공

par(mfrow=c(1,2)) # 1행 2열 그래프 보기

# Before Bug(1면)
barplot(Bug_Metrics_Software[,,1], beside=T, 
        col=c("lightblue","mistyrose","lightcyan","lavender","cornsilk"),
        legend=c("JDT","PDE","Equinox","Lucene","Mylyn"))
title(main ="Before Release Bug Frequency",font.main=4) 


# After Bug(2면) 
barplot(Bug_Metrics_Software[,,2], beside=F,
        col=c("lightblue","mistyrose","lightcyan","lavender","cornsilk"),
        legend=c("JDT","PDE","Equinox","Lucene","Mylyn"))
title(main ="After Release Bug Frequency", font.main=4)

#2) 점 차트 시각화
par(mfrow=c(1,1)) # 1행 1열 그래프 보기

dotchart(Severity_Counts, col=9:10, lcolor="black", pch=1:2,
         labels=names(Severity_Counts),
         main="Dot Plot for the Before and After", cex=1.2)


#3) 파이 차트 시각화
class(Severity_Counts) # "numeric"

par(mfrow=c(1,2)) # 1행 2열 그래프 보기
pie(Severity_Counts[c(1,3,5,7,9)]) # Bugs.BR
title("Before Release Bug Frequency")
pie(Severity_Counts[c(2,4,6,8,10)]) # Bugs.AR
title("After Release Bug Frequency")


#GDP그래프 그리기
GDP=read.csv('http://databank.worldbank.org/data/download/GDP.csv')
GDP=GDP[-c(1:4),c(1,2,4,5)]
colnames(GDP)=c('code','rank','country','GDP')
GDP_G15=head(GDP,15)
str(GDP_G15)

GDP_G15[GDP_G15$code=='USA',c('code','rank')]

nation=GDP_G15$country

GDP_G15$GDP=as.numeric(str_replace_all(GDP_G15$GDP,',',''))
GDPP=as.numeric(str_replace_all(GDP_G15$GDP,',',''))

barplot(GDP_G15$GDP/1000,legend.text = nation,col=rainbow(15),
        ylab = "GDP(단위:1000$)",ylim = c(0,20000))

#2. 연속변수 시각화

#1) 상자 그래프 시각화


library(RSADBE)
data(resistivity) # RSADBE패키지에서 제공하는 데이터셋
class(resistivity) 
resistivity 
summary(resistivity)
par(mfrow=c(1,2))
boxplot(resistivity, range=0) # 두 Process 상자 그래프 시각화
boxplot(resistivity, range=0, notch=T) 
# notch=T : 중위수 비교시 사용되는 옵션

abline(h=0.140, lty=1, col='red') # 기준선 추가 #lty: 선의 유형

#2) 히스토그램 시각화
#install.packages("psych")
library(psych)
#psych 패키지 제공 데이터 셋 galton
# 자식과 부모의 키 사이의 관계
data(galton)  

par(mfrow=c(1,2))
hist(galton$parent,breaks="FD", xlab="Height to Parent",
     main="Histogram for Parent Height with Freedman-Diaconis",
     xlim=c(60,75))
# breaks="FD" : Freedman-Diaconis, 구간 너비


hist(galton$parent,breaks="Sturges", xlab="Height to Parent",
     main="Histogram for Parent Height with Sturges",
     xlim=c(60,75))
#breaks="Sturges"  : 구간 너비


hist(galton$child, xlab="Height to Child",
     main="Histogram for Child Height with Freedman-Diaconis",
     xlim=c(60,75), col="mistyrose")
# col="mistyrose" : 색상(흐릿한 장미) 적용
# col="magenta" : 색상(진홍색) 적용

#3) 산점도 시각화
price<- runif(10, min=1, max=100) # 난수 발생

plot(price)

par(mfrow=c(2,2)) # 2행 2열 차트 그리기
plot(price, type="l") # 유형 : 실선
plot(price, type="o") # 유형 : 원형과 실선
plot(price, type="h") # 직선
plot(price, type="s") # 계단(step)

# plot() 함수 속성 : pch : 연결점 문자타입-> plotting characher-번호(1~30)
plot(price, type="o", pch=5) # 빈 사각형
plot(price, type="o", pch=15)# 채워진 마름모
plot(price, type="o", pch=20, col="blue") 
plot(price, type="o", pch=20, col="orange", cex=1.5) 
#cex: 포인트 크기
plot(price, type="o", pch=20, col="green", cex=2.0, lwd=3) 

# ------------------------------------------------------------------- 
# <연습문제1> VADeaths 데이터를 이용하여 boxplot으로 시각화 하시오.
#   <조건> h=37 위치에 기준선 추가  
data("VADeaths")
boxplot(VADeaths,h=37)
abline(h=37, lty=1, col='red') # 기준선 추가 #lty: 선의 유

# <연습문제2> iris$Sepal.Width(꽃받침 넓이) 데이터를 이용하여 히스토그램으로 시각화 하시오.
#   <조건> col='green', xlim = c(2.0, 4.5), main='iris의 꽃받침 넓이 데이터 시각화'  
data(iris)
hist(iris$Sepal.Width,col = 'green',xlim = c(2.0,4.5),main='iris 꽃받침 넓이')

# <연습문제3>  iris 데이터 테이블을 대상으로 plot()함수를 이용하여 
#             다음 조건에 맞게 차트를 그리시오.
jpeg(file="C:/Rwork/Part-II/iris.jpg",width = 702,height = 90)
plot(iris[,1],iris[,3],col=iris$Species,main='iris 산포도 차트')
dev.off()
# 조건1) 1번 컬럼이 x축, 3번 컬럼을 y축으로 차트 그리기
# 조건2) 5번 컬럼(Species)으로 색상 지정하기
# 조건3) 제목 추가("iris 산포도 차트")
# 조건4) 차트 저장하기("C:/Rwork/Part-II/iris.jpg")

# ------------------------------------------------------------------- 

# 매출 추이 산점도 
sales <- read.csv("C:/Rwork/Part-II/sales.csv", header=TRUE) 
par(mfrow=c(1,1))
attach(sales) # sales 데이터 셋 이름 생략
#attach를 쓰면 sales$Quarter 일케 안쓰고 detach할 때까지 컬럼명만 적어도 인식하게 해

plot(Quarter, A, type="o", pch=18, col="blue", ylim=c(0, 2500), axes=T,ann=T)

# axes=F : x축/y축 눈금 제거, ann=F : x축/y축 이름 제거
plot(Quarter, A, type="o", pch=18, col="blue", ylim=c(0, 2500), axes=F,ann=F)

# X축 범위와 이름 추가
axis(1, at=1:4, lab=c("1분기", "2분기", "3분기", "4분기")) 
# y축 범위 추가
axis(2, ylim=c(0, 2500))  
text(3.7, 2300, "사업부A", cex=0.8) # 텍스트 추가

# 제목 추가
title(main="사업부 2015년 분기별 매출추이 비교", col.main="red", font.main=4) 
title(xlab="분기", col.lab="blue") 
title(ylab="매출액", col.lab="blue") 

par(new=T) # 그래프 추가
plot(Quarter, B, type="o", pch=15, col="red", ylim=c(0, 2500), axes=F, ann=F) 
text(3.7, 1600, "사업부B")

par(new=T) 
plot(Quarter, C, type="o", pch=17, col="green", ylim=c(0, 2500), axes=F, ann=F) 
text(3.7, 1100, "사업부C", cex=0.8)

par(new=T) 
plot(Quarter, D, type="o", pch=21, col="purple", ylim=c(0, 2500), axes=F, ann=F) 
text(3.7, 700, "사업부D", cex=0.8)

par(new=T) 
plot(Quarter, E, type="o", pch=25, col="orange", ylim=c(0, 2500), axes=F, ann=F) 
text(3.7, 400, "사업부E", cex=0.8)
detach(sales) # attach 해제


# x변수와 y변수의 회귀관계(galton 데이터 셋)
library(psych)
#psych 패키지 제공 데이터 셋 galton
# 자식과 부모의 키 사이의 관계
par(mfrow=c(1,1))
plot(child~parent, data=galton) # y ~ x
out = lm(child~parent, data=galton)
abline(out, col="red") 

# 동일데이터가 겹친 경우 시각화 표현
#1) 2개 vector 생성
x=c(1,2,3,4,2,4)
y=rep(2,6)
plot(x,y)#중첩된 point 크기 알 수 없다.

#2)데이터 프레임 변경
xy_df=as.data.frame(table(x,y))

#3) 동일 데이터 시각화
plot(x,y,cex=0.5*xy_df$Freq,pch='@',col='blue')

# (1) 데이터프레임으로 변환
freqData <- as.data.frame(table(galton$child, galton$parent))

names(freqData)=c("child","parent", "freq") # 컬럼명 지정

# (2) 프레임 -> 벡터 -> 수치데이터변환 -> 가중치 적용
parent <- as.numeric(as.vector(freqData$parent))
child <- as.numeric(as.vector(freqData$child))
plot(child~parent, pch=21, col="blue", bg="green",
     cex=0.15*freqData$freq, xlab="parent", ylab="child")


# 4) 변수 간의 비교 시각화
data(iris)

# 4개 변수 상호비교
pairs(iris[,1:4]) # Sepal.Length Sepal.Width Petal.Length Petal.Width

# Species=="virginica"인 경우만 4개 변수 상호비교
pairs(iris[iris$Species=="virginica", 1:4])
pairs(iris[iris$Species=="setosa", 1:4])

# 차트 결과 파일로 저장
setwd("C:/Rwork/Part-II") # 폴더 지정
jpeg("galton.jpg", width=720, height=480) # 픽셀 지정 가능

plot(child~parent, data=galton) # y ~ x
title(main="부모와 자식의 키 유전관계")
out = lm(child~parent, data=galton)
abline(out, col="red") 
dev.off() # 장치 종료 


seq(1,10,by=2)
#[1] 1 3 5 7 9
seq(1,10,length.out=5)
#[1]  1.00  3.25  5.50  7.75 10.00

rep(1,10)#1을 10번
rep(1:5,5)#1에서5까지 5번
rep(1:5,5,each=5)#1에서 5까지 5번 각각

rep(1:5,1:5)

#확률분포
#mean:1, sd=1로 default설정되어있음

dnorm#(density)
pnorm#(prob.)
qnorm#(quantile)
rnorm#(random)

x<-seq(-3,3,0.01)
plot(x,dnorm(x))
plot(x,dnorm(x),type="l",xlab="density",ylab="x",main="Density of std.normal")

pnorm(0.5)
pnorm(0)
pnorm(0.95)

x<-rnorm(100)
mean(x)
sd(x)
hist(x)#histogram

dbinom#이항분포
dpois#포아송분포

x<-dbinom(1000,100,0.3)
mean(x)
var(x)

#BINOMIAL
#x: # of  wins from NC
#n: # of games - should be fixed
#p: 성공확률 - should be fixed
#서로다른 사건들이 독립적이어야함

x<-matrix(1:20,nrow=4,ncol=5)
x<-matrix(1:20,nrow=4,ncol=5,byrow=T)#row부터 채우고 싶을 때

y<-matrix(101:120,nrow=4,ncol=5)

x+y
x*y
x/y

z<-matrix(1:20,nrow=5)

y<-x%*%z#matrix끼리 곱할 때 

det(y)

y<-matrix(rnorm(25),nrow=5)
solve(y)#inverse matrix
solve(y)%*%y
y%*%solve(y)

sample(10)#1에서10중 랜덤으로 나열

#sample(population,samplesize)
sample(50,5)

##########list###############

mylst<-list(id=12345,name="John",scores=c(80,75,100,60))
#list는 복수의 attribute를 가질 수 있다. 길이가 달라도 상관없음
mylst$id #특정list의 특정 attribute를 보고싶을 때
mylst[[2]]#특정list의 두번째 attribue를 보고싶을 때

mylst$parents.name<-c("Ana","Mike")#기존의 list에 새로운 attr.더하기

##############################

x<-matrix(sample(50,10),ncol=2)
which.min(x)#min값이 어디있는가?
sort(x)#순서대로 나열
sort(x,decreasing=T)
rank(x)#해당위치의 숫자가 몇번째?
cumsum(x)#누적합계
cumprod(x)

#variable간 scale이 다를 때, (ex. x1:0.1 0.0001 , x2:10 15, x3:1억, 490억)
#how to make the contribution of each variable to the distance similar? 
#Scale the variables first, and then compare the distance. 
#scale: 각각의 variable을 평균이 0 분산이 1이 되도록 만든다. 
#r package: cluster내의 daisy function이 기여도를 비슷하게 만든다. 
scale(x)#standarize

####################################################################################################################################################################################
#missing value가 있을 때 
#1)use the complete data only(remove missing variables)
#2)use the representative values(mean, median, mode)
#3)use the SLR . find x that has the highest corr with X3. 
#4)use the K-NN method

#(4)에 집중
#K-NN method: for each observation with missing values, find K-nearest observation and they apply method(2). 
#For example, obs 3 has a missing in salary value=>find 10 obs that are nearest to the obs 3. 
#Compare mean salary of these 10 obs, then finn in with this  value. 

#예를들어, 사람의 나이, 직업, 생일, 학력 연봉에 대한 데이터가 있을 때, x3의 연봉이 missing인 경우, x3과 비슷한 사람을 찾아서 

#what does 'K-nearest' mean?? 

#nearest need a 'distance measure' btwn obs

#all variables are Numeric => Euclidean distance

#그렇다면 categorical variable은 어떻게 하는가? 
#같으면 1, 다르면 0으로 표시. 


################k-nearest 

#k-nearest mean사용하기 위해 cluster패키시 사용
library(cluster)
##1)get distance matrix for obs 
#=>모든 함수가 numeric이면 dist함수 사용 가능.
#=>mixed type인 경우 cluster package의 daisy()사용한다. 
#ex.모두 numeric인 경우
x<-matrix(sample(20),nrow=5)
dist.x<-dist(x)#r에서는distance값을 vector로 저장
dist.x[1:4]#
#the number of distances: n(n-1)/2
length(dist.x)#x매트릭스의 관측치가 5개이기 때문에 n(n-1)/2에 의해 distance는 10개가 나옴
aa<-as.dist(dist.x,diag=T,upper=T)#distance matrix를 full matrix로 만들어줌
aa<-as.matrix(dist.x)
dim(aa)
aa[1,]#첫번째 obs와의 거리
sort(aa[1,])#가까운 순으로 나열함
  
#ex.mixed type인 경우
dist.mtx <- as.matrix(daisy(algae,stand=T))#stand=T:standarize, scale이 다른 경우, 기여도가 다 다르기 때문에.
  
central.value <- function(x) {
    if (is.numeric(x)) median(x,na.rm=T)
    else if (is.factor(x)) levels(x)[which.max(table(x))]
    else {
      f <- as.factor(x)
      levels(f)[which.max(table(f))]
    }
}


##1)AIC or BIC: "performance measure" 
#장점: computing is easy, 시간 적게소요
#단점: 모든 모형에 적용 가능하지 않다.
##2)minimizing CV(cross-validation)
#장점: 어떤 모형이든지 사용가능
#단점: 계산량이 많음



lm.a1 <- lm(a1 ~ .,data=clean.algae[,1:12])
#step#Choose a model by AIC in a Stepwise Algorithm 
step(object, scope, scale = 0,
direction = c("both", "backward", "forward"),
trace = 1, keep = NULL, steps = 1000, k = 2, ...)
#backward:2nd chance 없음, 앞에서부터 변수를 하나씩 삭제하며 AIC최소화
#forward:변수를 하나씩 추가하면서 min AIC찾음. 한번 들어오면 나가지 않음. 
#both: backward+forward

final.lm <- step(lm.a1)#defalut:"backward"

final.lm <- step(lm.a1,direction="both")

summary(final.lm)
summary(lm.a1)

extractAIC(lm.a1)
extractAIC(final.lm)

names(final.lm)
rss<-sum(final.lm$residuals^2)#RSS
n<-nrow(clean.algae)
n*log(rss/n)+2*7#n*log(rss/n)+2*p

AIC(final.lm)#final.lm<-최적의 모형


##variable selection
#최적의 모형(optimal model)
#1)goodness of fit;관측치~예측치 얼마나 비슷한가? 
#2)model simplicity;
##goodness of fit과 simplicity는 반비례하게 움직이기 때문에 AIC, BIC통해 중도점 찾아야함
#AIC,BIC

#Stepwise selection

#stepwise로 select된 변수가 모두 유의한가?
#유의하지 않은 경우~해당변수가 AIC,BIC최소화하는데 기여하므로 버리면 안된다. 
#test data에서의 performance는 AIC,BIC값이 작으면 작을수록 높아지기 때문에
#Model complexity와 prediction error그래프에서 train error는 계속 감소하는 경향, test error는 감소하다가 어느 포인트에서 증가하는 모양.test error의 pred.error가 최소점 찍는 model을 찾는 것이 궁극적인 목표. 

##TREE
#recursive binary splits with minimizing impurity 
#불순도를 최소화하는 반복적인 이분 분할법
#child node의 impurity 최소화하는 방향으로
#조건에 만족하면 왼쪽으로 감. 

#fitted value
#조건에 만족하는 끝에있는(맨왼쪽) y의 평균

#optimal tree;tree with minimum cv error
#cv error는 계산할 때마다 변함;random partition이기 때문에

##lm1,lm2 anova
anova(lm1,lm2)#RSS비교.귀무가설:두 모형이 통계적으로 다르다.->귀무가설 기각X,비슷하다~>간단한 모형으로 선택 

##(1)y:numeric~regression
#=>손실함수: RSS(관측치와 예측치의 차이의 제곱 합) 최소화하는 b값 추정
#마지막에 observed-fitted value plot그려서시각화 ~ 확인 

##(2)categorical~classification
#=>손실함수: missclassification rate(오분류율)=1/n(오분류 경우의 수 합)
#2x2 matrix(confusion matrix)생성
#A:true-true/B:true-false/C:false-true/D:false-false분류~오분류율=B+C/A+B+C+D

########Classification 
#input->classifier->output
#Decision Boundary: X와 O로 이루어진 특정공간에서 X와 O를 가르는 선

#(1)Logistic Regression(Decision Boundary가 linear인 경우)
#(2)LDA/QDA
#(3)Neural Network 
#(4)CART
#(5)SVM(Support Vector Machine)
#(6)Random Forest


###Logistic Regression 

#y=1 or 0 ; 많은 분류가 2 class(부도-건전, 합-불합...)
#log(p(y=1│x=x)/p(y=o│x=x))=xb+e

##실습
##Deviance = -2[Lm - Ls]:LM(현재모형 likelihood),LS(full모형)
#모형이 좋으면 likelihood값이 좋음. (LM-LS)의 절대값이 작을수록 좋은모형 

#Residual Deviance 
#AIC(2p+dev) p:# of coeff+intercept


############ Categorical explanatory variables ############

#categorical 변수는 dummy variable만들어줌

####QDA(Quadratic Discriminant Analysis)
#LDA는 구분선이 선형, QDA는 비선형이지만 LDA가 더 많이 쓰인다. 

#LDA/QDA-Logistic Regression과의 차이: Logistic Regression은 분포에 대한 가정이 없다.
#Logistic Regression은 어떠한 데이터에 대해서도 모델형성 가능. 설명변수로 categorical variable OK. 
#★LDA는 numerical explanatory variable이어야함. 

#LDA가 더 제한적인데 왜 LDA를 더 사용하는가? 
#data가 정규분포인 경우 LDA의 퍼포먼스가 더 좋음. 

#Logistic vs. LDA
# Robust - non-Robust;robust:x값으로 뭐든지 와도 ok. 
#x~N인 경우 performance(Logistic<LDA)
#tip:대부분의 function은 MASS library에서 커버하고있음. 


##실습

library(MASS)
data(iris)
summary(iris)
lda1<-lda(Species~.,data=iris)
plot(lda1)

lda1.pred<-predict(lda1,iris)
summary(lda1.pred)
lda1.pred

names(lda1)
lda1.pred$posterior[1:10,]#각각의 species로 분류될 확률;posterior=p(G=k│x=x)=πk*fk(x)/∑πk*fk(x)
lda1.pred$class[1:10]#iris data 1~10th row 분류된 클라스 

#오분류율 계산
table(iris$Species,lda1.pred$class)#가로:observed/세로:expected

1-mean(ifelse(iris$Species==lda1.pred$class,1,0))#오분류율


###neural network fitting시 고려사항###

##(1)입력변수의 type, shape에 아주 민감하다=>x에 작은 차이에도 결과가 크게 달라질 수 있음.

#asymmetric한 분포를 log취하면 symmetric한 형태로 바뀜.
#x가 범주형인 경우:balanced할수록 결과가 잘 나옴
#A(30), B(100), C(20)->unbalanced/#A(30), B(30), C(30)->"balanced"
#x가 연속형인경우:각 변수들의 range가 비슷할수록 결과가 잘 나옴
#range(=max-min)=>scaling해주자. 

#neural network는 아래로 꼭지점을 갖는 포물선모양 graph. 
library(nnet)
nnl<-nnet(Species~.,data=iris, size=10)

nnet(x, y, weights, size, Wts, mask,
linout = FALSE, entropy = FALSE, softmax = FALSE,
censored = FALSE, skip = FALSE, rang = 0.7, decay = 0,
maxit = 100, Hess = FALSE, trace = TRUE, MaxNWts = 1000,
abstol = 1.0e-4, reltol = 1.0e-8, ...)

#할 때마다 값이 다르게 나타남. 수렴하지 않는 경우 max iteration값을 늘려주는 것도 수렴할 가능성을 높여주는 방법.
#test data에서 performance가 좋은 모형이 최적의 모형이다. ~ CV error가 가장 작은 모형.

###Support Vector Machine(SVM)###

#Classification

#(1)log odds 계산해서 분류:logistic regression, LDA

#(2)Decision boundary를(classification해주는 구분선) modeling(fitting)
#margin:min distance from the decision boundary to the data point
##SVM:find the decision bundary tha maximizes this 'MARGIN'~이러한 dec. bdry는 unique하게 존재한다.

#margin이 클수록 왜 performance가 좋은가? 
#margin이 크다는 것은 오분류 할 확률이 낮다는 것을 의미. 
#big margin=>less error on a test data set


###SVM###
install.packages("e1071")
library(e1071)

## S3 method for class 'formula'
svm(formula, data = NULL, ..., subset, na.action = na.omit, scale = TRUE)

library(MASS)
data(cats)
?cats
summary(cats)

svm1<-svm(Sex~. ,data=cats)
summary(svm1)
#sv:decision boundary에 기여하는 obs. 

plot(cats)
plot(svm1,cats)

#boxplot 그리기
library(lattice)
bwplot(Sex~Bwt,data=cats)#body weight에 대해서 boxplot그린 결과 
bwplot(Sex~Hwt,data=cats)


###prediction
svm1.pred<-predict(svm1,cats)
svm1.pred#svm은 prediction값을 output으로 줌

#confusion matrix
table(cats$Sex,svm1.pred)

#misclassification rate
mean(ifelse(cats$Sex==svm1.pred,0,1))

#####Iris data로 해보기

data(iris)
summary(iris)

svm2<-svm(Species~.,data=iris)
svm2.pred<-predict(svm2,data=iris)

table(iris$Species,svm2.pred)

mean(ifelse(iris$Species==svm2.pred,0,1))

#변수가 두개 이상이기 때문에 plot그릴 때 특정변수 두개 지정해주어야함
plot(svm2,Petal.Length~Petal.Width,data=iris)

######plot그릴 때 어떤 변수 두개로 해야할지 tree를 통해 아이디어 얻기
install.packages("tree")
library(tree)

tr1<-tree(Species~.,data=iris)
plot(tr1);text(tr1)


#course homepage 'svm in R'파일 13페이지 참고
plot(svm2, iris, Petal.Width ~Petal.Length, slice = list(Sepal.Width = 3,Sepal.Length = 4))

##tuning
aa<-tune.svm(Species~.,data=iris,gamma=2^(-4:0),cost=c(1,10))
summary(aa)#결과값으로 나타나는 error는 CV error말하는 것임. 

bb<-tune.svm(Sex~.,data=cats,gamma=2^(-4:0),cost=c(1,10))
summary(bb)

#CV에러는 RANDOM PARTITIONING에의해 10번 fitting해서 나온 error값의 평균을 말한다. random partition으로 인해 구할 때마다 에러가 다르게 나타남.
#SVM은 모델의 설명력이 약하다는 단점이 있음. 

mybest<-bb$best.parameters
mybest[1]#best parameter gamma
mybest[2]#best parameter cost
svm3<-svm(Sex~.,data=cats,gamma=mybest[1],cost=mybest[2])

svm3.pred<-predict(svm3,cats)
table(cats$Sex,svm3.pred)
mean(ifelse(cats$Sex==svm3.pred,0,1)


####### Bagging (Bootstrap Aggregating) #######

#x1,x2,...,xn ; n개의 관측치가 있을 때 평균, 중앙값의 분포을 알고싶은 경우
#n개의 관측치에 대해 sampling(with replacement, 복원추출)

sample(x, size, replace = FALSE, prob = NULL)
x<-sample(1:20,10)
x
sample(x,10,replace=T)#복원추출

x<-1:10
sample(x)#x에 대해서 random permutation만 진행
sample(x,replace=T)#복원추출진행

#Bagging~n개의 관측치에 대해서 random sampling k번 진행~k개의 bootstrap이 만들어짐
#뽑힌 bootstrap의 mean, median분포 추정가능 

#방법론이 high variance low bias인 경우 bagging의 효과가 크다. 
#high variance, low bias인 방법론의 대표적인 예:tree
#low variance, high bias인 방법론의 대표적인 예:linear models

#bootstrap 만들기->각각의 bootsrap에 tree model fitting->output에 대해 평균취하기
#regression~평균, classification~majority voting
#ex)분류했을 때 A가 500개, B가 20개, C가 300개인 경우 A를 선택. 


##### Random Forest #####

#tree building
# : m개의 random predictor만을 사용하여 splitting variable을 찾자. =>TREE사이의 CORR을 낮춤. 

install.packages('randomForest')
library(randomForest)

rf1<-randomForest(Species~.,data=iris)
rf1

#rf1
'
Call:
randomForest(formula = Species ~ ., data = iris) 
Type of random forest: classification
Number of trees: 500
No. of variables tried at each split: 2

OOB estimate of  error rate: 4.67%
Confusion matrix:
setosa versicolor virginica class.error
setosa         50          0         0        0.00
versicolor      0         47         3        0.06
virginica       0          4        46        0.08
'
#설명변수 4개중 2개만 사용. 

plot(rf1)
#plotting했을 때 error의 fluctuation이 멈추는 부분정도로 bootstrap개수 지정해줘도 ok. 
#이 plot의 경우에는 100-200개 사이로 충분하다고 할 수 있음. 
                                                                      
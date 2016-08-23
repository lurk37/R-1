#주성분 분석
#Principal Component Analysis,PCA
#concept
#상관관계가 있는 변수들을 결합해 상관관계가 없는 변수로, 분산을 극대화 하는 분석, 변수를 축약하는데 사용
####1.데이터 정제####
#install.packages('HSAUR')
library(HSAUR)
data("heptathlon")
head(heptathlon)
'
올림픽 경기 기록
----------------     hurdles highjump  shot run200m longjump javelin run800m score
Joyner-Kersee (USA)   12.69     1.86 15.80   22.56     7.27   45.66  128.51  7291
John (GDR)            12.85     1.80 16.23   23.65     6.71   42.56  126.12  6897
Behmer (GDR)          13.20     1.83 14.20   23.10     6.68   44.54  124.20  6858
Sablovskaite (URS)    13.61     1.80 15.23   23.92     6.25   42.78  132.24  6540
종목에 따라 기록이 낮은 숫자가 좋은 것일 수도 있고 아닐 수도 있음
->which?
->hurdles run200m run800m 낮을 수록 좋은 숫자
->방향을 맞춰야함->how?
'
range(heptathlon$hurdles) #[1] 12.69 16.42
heptathlon$hurdles = max(heptathlon$hurdles)-heptathlon$hurdles
range(heptathlon$hurdles) #[1] 0.00 3.73

heptathlon$run200m = max(heptathlon$run200m)-heptathlon$run200m
heptathlon$run800m = max(heptathlon$run800m)-heptathlon$run800m

####2.산점도 확인####
score = which(colnames(heptathlon)=='score')
plot(heptathlon[,-score])

#->javelin(투창)빼고 변수간 양의 상관관계 보임

####3.상관계수 확인####
round(cor(heptathlon[,-score]),2)
'
hurdles highjump shot run200m longjump javelin run800m
hurdles     1.00     0.81 0.65    0.77     0.91    0.01    0.78
highjump    0.81     1.00 0.44    0.49     0.78    0.00    0.59
shot        0.65     0.44 1.00    0.68     0.74    0.27    0.42
run200m     0.77     0.49 0.68    1.00     0.82    0.33    0.62
longjump    0.91     0.78 0.74    0.82     1.00    0.07    0.70
javelin     0.01     0.00 0.27    0.33     0.07    1.00   -0.02
run800m     0.78     0.59 0.42    0.62     0.70   -0.02    1.00
'
#->javelin(투창)빼고 변수간 양의 상관관계 확인

####4.주성분 분석####
heptathlon_pca = prcomp(heptathlon[,-score], scale = T)

####5.중요 변수 확인####
summary(heptathlon_pca)
'
Importance of components:
                          PC1    PC2     PC3     PC4     PC5     PC6    PC7
Standard deviation     2.1119 1.0928 0.72181 0.67614 0.49524 0.27010 0.2214
Proportion of Variance 0.6372 0.1706 0.07443 0.06531 0.03504 0.01042 0.0070
Cumulative Proportion  0.6372 0.8078 0.88223 0.94754 0.98258 0.99300 1.0000
->PC1,PC2가 전체 변수를 81%를 설명함
'
plot(heptathlon$score,heptathlon_pca$x[,1])
#->Score과 PC1의 상관관계가 높은 것으로 보임
cor(heptathlon$score,heptathlon_pca$x[,1])
#[1] -0.9910978

####5.결론####
#첫 번째 주성분이 올림픽 7종 경기의 공식점수와 한 방향임을 알 수 있음
#->첫 번째 주성분으로 올림픽 7종 경기의 공식점수를 예측 할 수 있음

ddd

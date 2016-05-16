#################################
#   data.frame vs data.table    # 
#################################

install.packages('data.table')
library(data.table)

# 1) 다양한 indexing
x <- data.table(x = c(1:3), y = c('a', 'b', 'c'))
x; class(x) # "data.table" "data.frame"

data("iris")
iris
str(iris) # 'data.frame':	150 obs. of  5 variables:

# data.frame 형변환 
iris_frame <- as.data.frame(iris)
iris_frame
iris_frame$Species
iris_frame$Species[10:50]

# data.table 형변환  
iris_table <- as.data.table(iris)
iris_table

iris_table

iris_table[1, Sepal.Length]
iris_table[1, list(Sepal.Length, Species)]
iris_table[, mean(Sepal.Length)]
iris_table[, mean(Sepal.Length - Sepal.Width)]
iris_table[, list(se_avg = mean(Sepal.Length), pe_avg = mean(Petal.Length))]
#    se_avg pe_avg
#1: 5.843333  3.758

# 문1) 꽃받침의 길이와 넓이의 평균 및 합계를 구하여 특정 변수로 저장하시오.
iris_table[, list(sl_avg = mean(Sepal.Length), sl_tot = sum(Sepal.Length),
                  sw_avg = mean(Sepal.Width), sw_tot = sum(Sepal.Width))]
#      sl_avg sl_tot   sw_avg sw_tot
# 1: 5.843333  876.5 3.057333  458.6

# 문2) 문1를 대상으로 꽃의 종류별(Species)로 적용하시오.
iris_table
iris_table[, list(sl_avg = mean(Sepal.Length), sl_tot = sum(Sepal.Length),
                  sw_avg = mean(Sepal.Width), sw_tot = sum(Sepal.Width)),
           by=Species]
#      Species sl_avg sl_tot sw_avg sw_tot
#1:     setosa  5.006  250.3  3.428  171.4
#2: versicolor  5.936  296.8  2.770  138.5
#3:  virginica  6.588  329.4  2.974  148.7


# 2) 처리속도 
df <- data.frame(x = runif(260000), y = rep(LETTERS, each=10000))
df
str(df)
head(df)

x <- df[df$y=='C', ]
x
system.time(df[df$y=='C', ])
#사용자  시스템 elapsed 
#0.01    0.00    0.02 


# data.table() 변경 
dt <- data.table(df)
# 특정 칼럼을 key 지정 
setkey(dt, y) # dt 객체의 y 칼럼 지정 
system.time( dt[ J('C'), ]) # J('index')
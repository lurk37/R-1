
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
library(shiny)
library(nnet)
data(iris)
set.seed(123) # random 결과를 동일하게 지
idx = sample(1:nrow(iris), 0.7*nrow(iris))
training = iris[idx, ]
testing = iris[-idx, ]
training
testing
#이 앞 줄까지는 서버 한 번 열릴 때 실행 됨

shinyServer(function(input, output) {
  
  output$eval <- renderPrint({ #텍스트 양식으로 출력
    cat('Hidden node 수: ', input$size,'\n\n')
    #모델 생성
    model_net_iris = nnet(Species ~ ., training, size = input$size)
    #예측치 생성
    pre <-predict(model_net_iris, testing, type='class')
    # 3가지 꽃
    pre2<-names(table(pre))#예측치 빈도수 -> names()적용
    cnt=0
    for(i in pre2){
      cnt<-cnt + 1 
    }
    cat('혼돈 matrix')
    tab<-table(pre, testing$Species)
    print(tab)
    #3가지 꽃이 모두 분류된 경우만 정분류율 계산/출력
    #만약에 1,2 꽃만 생성된 경우 계산/출력은 skip
    if(cnt>=3){
      cat('모델의 정분류율')
      t<-(tab[1,1]+tab[2,2]+tab[3,3])/nrow(testing)
      print(t)
    }else{
      cat('해당 은닉노드수는 사용 불가\n')
    }
  })
  output$summary <- renderTable({ #플롯 양식으로 출력
    summary(testing[-5])
  })
  output$bplot <- renderPlot({ #플롯 양식으로 출력
    barplot(apply(testing[-5],2,mean, col=c(2:5)))
  })
})
  
    # generate bins based on input$bins from ui.R
 #   x    <- faithful[, 2]
  #  bins <- seq(min(x), max(x), length.out = input$bins + 1)

    # draw the histogram with the specified number of bins
   # hist(x, breaks = bins, col = 'darkgray', border = 'white')



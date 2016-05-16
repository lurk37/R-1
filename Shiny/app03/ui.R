
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("뉴럴 네트워크 모델 성능 평가"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      sliderInput("size",
                  "Number of size:", #hidden node 수
                  min = 1,
                  max = 5,
                  value = 1)
    ),

    # Show a plot of the generated distribution
    mainPanel(
      h3('iris NN 분류모델 성능평가 결과'),
      verbatimTextOutput("eval"), #서버에서 넘겨준 변수
      h3('iris[1:4] 칼럼에 대한 요약통계량'),
      tableOutput("summ"),
      h3('칼럼 시각화'),
      plotOutput('bplot')
    )
  )
))

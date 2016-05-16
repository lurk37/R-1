##################################################
#  다수의 웹 사이트에서 Web문서 수집
##################################################

library(XML) # 웹문서 처리 패키지 
# Web 문서에서 a 태그(link) 수집 -> 해당 사이트 web문서 수집

# 해당 사이트의 웹문서 태그 기준 웹문서 읽기- Speeches 내용을 기록한 웹문서  
html = htmlTreeParse("http://www.federalreserve.gov/newsevents/speech/2014speech.htm", 
                     useInternalNodes=TRUE, trim=TRUE)
class(html)
html # html 문서보기 

# xpathSApply() : 해당 속성의 데이터 수집
# - 현재 문서에서 a 태그의 href 속성만 수집 
# - xmlGetAttr : a태그에서 특정 속성값을 가져오는 역할
# <a href="www.naver.com">네이버 </a>
urls = xpathSApply( html, "//a", xmlGetAttr, "href")  
urls # list 반환 
#[[107]]
#[1] "/foia/about_foia.htm"

urls[[107]] # 107번째 리스트의 첫번째 원소 접근 - 원소 접근 어려움

# vector 변환 : 데이터 처리 용이성   
urls2 = unlist(urls) # list -> vector 변환 
urls2 # a태그의 href 속성 보기 - [103] "/foia/about_foia.htm" 

# url에서 'speech' 포함 url만 추출 
urls3 = urls2[!is.na(str_locate(urls2, "speech"))[,1]] # /newsevents/speech
urls3

# urls3 앞에 http://www.federalreserve.gov 붙임 - url 생성 
newUrls = paste("http://www.federalreserve.gov", urls3, sep="")
newUrls # [1] "http://www.federalreserve.gov/newsevents/speech/2016speech.htm" 

collected = character() # 각 url에서 데이터를 수집하여 collected 변수에 저장 
cnt = 1

# newUrls에 저장된 url 사이트 접속하여 본문 수집, collected 저장 
for(i in newUrls){ # newUrls[22:62]
  tmp = xpathSApply( htmlTreeParse(i, useInternalNodes=TRUE, trim=TRUE), "//p", xmlValue)
  if(length(tmp) > 0){
    cat( cnt, "th process\n") # 
    collected[cnt] = str_join(tmp, collapse=" ")
    cnt = cnt+1
  }
}
collected

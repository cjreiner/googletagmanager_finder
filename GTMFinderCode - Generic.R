#Find Missing GTM Code on any Website
#7/10/2020

#update the urls in line 9 and 17.
#line 16 assumes the urls on the sitemap do not incude the hostname.

#get sitemap and extract links
library(rvest)
sitemap <- read_html("https://www.example.com/sitemap.html")
links <- sitemap %>% html_nodes("a")
links2 <- as.data.frame(xml_attr(links,"href"))
colnames(links2) <- c('rawURL')
links2$rawURL <- as.character(links2$rawURL)

#append domain to links if not in http format
links2$appendMe <- !grepl('^http',links2$rawURL)
links2$finalURL <- ifelse(links2$appendMe==TRUE,paste0("https://www.example.com",links2$rawURL),links2$rawURL)

#loop through each page and check for GTM
for(i in 1:nrow(links2)){
#for(i in 1:10){ #this line is for testing us it instead of the line above to dry run 10 pages
  row <- links2[i,]
  page <- tryCatch(read_html(links2[i,c("finalURL")]),error = function(e){return(NA)})
  if(is.na(page)){
    row$foundGTMInHeadTag <- "404_error"
      if(i == 1){
        output <- row
      } else {
        output <- rbind(row,output)
      }
    next
  }
  
  head <- page %>% html_node("head")
  js <- head %>% html_nodes("script")
  if(length(js)!=0){
    for(j in 1:length(js)){
      if(grepl("googletagmanager",html_text(js[j]))==T){
        row$foundGTMInHeadTag <- "TRUE"
        break
      } else {
        row$foundGTMInHeadTag <- "FALSE"
      }
    }
  } else { row$foundGTMInHeadTag <- "FALSE" }
  if(i == 1){
    output <- row
  } else {
    output <- rbind(row,output)
  }
}

write.csv(output,"output.csv")
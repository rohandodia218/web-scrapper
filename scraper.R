library(rvest)
library(stringr)

#function to retrieve links from all pages of all volumes published after the given year

getlinks <- function(year){
  vols<- year-1999
  vols<-seq(vols,20,by=1)
  
  
  
  
  #set up our dataframe
  exles<-c()
  
  #for every journal volume from start year
  for(v in vols){ print(v)
    pages<-switch(v,1:9,1:12,
                  1:13,1:11,
                  1:7,1:7,1:5,1:8,
                  1:6,1:5,1:6,
                  1:7,1:5,
                  1:5,1:6,1:6,1:6,1:5,
                  1:5,1:2)
    #for every pages in the selected journal
    #get the article links
    for(i in pages){
      website = paste("https://genomebiology.biomedcentral.com/articles?tab=keyword&searchType=journalSearch&sort=PubDate&volume=", v, "&page=", i, sep = "")
      raw_html = readLines(website)
      html = (paste(raw_html, sep = "", collapse = ""))
      les = gregexpr("/articles/10.[0-9./a-z-]*", html)
      exles <-c(regmatches(html,les),exles)
    }
  }
  alnk<-unlist(exles)
  fl<-unique(alnk)
  print(length(fl))
  return(fl)
}
yr<-readline(prompt="enter a year between 2000 and 2019 ")
yr<-as.numeric(yr)
clinks<-getlinks(yr)
alinks<-paste0('https://genomebiology.biomedcentral.com',clinks)

#function to extract abstract
getabst<-function(l)
{
  
  abst<-c()
  url1<-paste('https://genomebiology.biomedcentral.com',l,sep = "")
  
  for (i in 1:length(url1)) 
  {
    wpage<-read_html(url1[i])
    #extracting abstract from Full_text link
    abst_html<-html_nodes(wpage, '#Abs1' )
    abst[i] <-c(html_text(abst_html),abst[i])
    
  }
  return(abst)
}
abstw<-getabst(clinks)
abst<-gsub("\\n","",abstw)
abst<-trimws(abst)

#abstract extracted

#function to extract email
getmail<-function(l)
{
  
  mail<-c()
  url1<-paste('https://genomebiology.biomedcentral.com',l,sep = "")
  
  for (i in 1:length(url1)) 
  {
    wpage<-read_html(url1[i])
    #extracting mail from Full_text link
    mail_html<-html_nodes(wpage,'.EmailAuthor')
    mail[i] <-c(html_attr(mail_html,"href"),mail[i])
    
  }
  return(mail)
}
email<-getmail(clinks)


#email extracted 


#fucntion to extract keywords
getkw<-function(l)
{
  
  kw<-c()
  url1<-paste('https://genomebiology.biomedcentral.com',l,sep = "")
  
  for (i in 1:length(url1)) 
  {
    wpage<-read_html(url1[i])
    #extracting Keywords from Full_text link
    kw_html<-html_nodes(wpage,'.c-keywords__item')
    kw[i] <-c(html_text(kw_html),kw[i])
    
  }
  return(kw)
}
KW<-getkw(clinks)
#KW


#function to extract authors
getauthors<-function(l)
{
  
  authors<-c()
  url1<-paste('https://genomebiology.biomedcentral.com',l,sep = "")
  
  for (i in 1:length(url1)) 
  {
    wpage<-read_html(url1[i])
    #extracting authors from Full_text link
    authors_html<-html_nodes(wpage,'.AuthorName')
    authors[i] <-c(html_text(authors_html),authors[i])
    
  }
  return(authors)
}
Authors<-getauthors(clinks)
#Authors

#Authors  extracted 

#fucntion to extract titles
gettitles<-function(l)
{
  
  titles<-c()
  url1<-paste('https://genomebiology.biomedcentral.com',l,sep = "")
  
  for (i in 1:length(url1)) 
  {
    wpage<-read_html(url1[i])
    #extracting titles  from Full_text link
    titles_html<-html_nodes(wpage,'.ArticleTitle')
    titles[i] <-c(html_text(titles_html),titles[i])
    
    
  }
  return(titles)
}
tit<-gettitles(clinks)


#titles  extracted 
















#function to extract pdate
getpdate<-function(l)
{
  
  pdate<-c()
  url1<-paste('https://genomebiology.biomedcentral.com',l,sep = "")
  
  for (i in 1:length(url1)) 
  {
    wpage<-read_html(url1[i])
    #extracting pub date from Full_text link
    pdate_html<-html_nodes(wpage, '.HistoryOnlineDate span' )
    pdate[i] <-c(html_text(pdate_html),pdate[i])
    
    
  }
  return(pdate)
}
pdata<-getpdate(clinks)
#print(length(pdata))

#pdata  extracted 






















#fucntion to extract content type
getct<-function(l)
{
  
  ct<-c()
  url1<-paste('https://genomebiology.biomedcentral.com',l,sep = "")
  
  for (i in 1:length(url1)) 
  {
    wpage<-read_html(url1[i])
    #extracting content type from Full_text link
    ct_html<-html_nodes(wpage, '.c-article-identifiers__item:nth-child(1)' )
    ct[i] <-c(html_text(ct_html),ct[i])
    
    
    
  }
  return(ct)
}
con_type<-getct(clinks)
#print(con_type)

#content type  extracted 











#function to extract full paper
getfp<-function(l)
{
  
  fp<-c()
  url1<-paste('https://genomebiology.biomedcentral.com',l,sep = "")
  
  for (i in 1:length(url1)) 
  {
    wpage<-read_html(url1[i])
    #extracting full text from Full_text link
    ct_html<-html_nodes(wpage, '#sec1 #sec2 #sec8' )
    fp[i] <-c(html_text(ct_html),fp[i])
    
    
    
  }
  return(fp)
}
Full_paper<-getfp(clinks)

#head(Full_paper)

#Full_paper extracted 









DOI<-gsub("/articles/","",clinks)

#data frame
df<-data.frame(DOI,link=alinks,Pub_Date=pdata,Content_type=con_type,Title=tit,Authors,Keywords=KW,Emails=email,abstract=abst,Full_paper)


#setwd("C:\\Users\\hp user\\Documents\\scraper")
write.table(df, file="GenomeBiology_biomedcentral.txt", sep = "\t", row.names = FALSE)


#fucntion to download all html files
htmldocs<-function(l)
{
  
  doi<-c()
  setwd("C:\\Users\\hp user\\Documents\\scraper\\htmldocs")
  
  url1<-paste('https://genomebiology.biomedcentral.com',l,sep = "")
  
  for (i in 1:length(url1)) 
  {
    print(i)
    wpage<-read_html(url1[i])
    #extracting Keywords from Full_text link
    doi_html<-html_nodes(wpage, '.u-text-inherit' )
    doi[i] <-html_attr(doi_html,"href")
    # download.file(url[i],"url specific to the file system in your computer")
    doi[i]<-gsub("https://doi.org/","",doi[i])
    doi[i]<-gsub("/","-",doi[i])
    download.file(url1[i], paste0( doi[i], ".html",sep=""))    
    
    
    
  }
  
}
htmldocs(clinks)















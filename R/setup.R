
install.packages(c("devtools","rstudioapi"), dependencies=TRUE, repos=c("http://rstudio.org/_packages", "http://cran.rstudio.com"))


library(devtools)
install.packages(c('Formula', 'acepack'))
install.packages(c("devtools","rstudioapi","shiny","miniUI","data.table","stringr","DT","XML","httr","tcltk","RCurl","Hmisc","readxl","RSelenium"), 
                 dependencies=TRUE, 
                 repos=c("http://rstudio.org/_packages", "http://cran.rstudio.com"))
install_github(
  repo = "dadrivr/FantasyFootballAnalyticsR",  
  subdir = "R Package/ffanalytics"
)



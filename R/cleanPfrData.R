
# clean PFR fantasy data

CleanPfrData <- function() {
  for (i in 2000:2015) {
    d <- read.csv(paste0('./data/PFR/pfr_fantasy_', i, '.csv'), skip=1, stringsAsFactors = F)
    out <- d[which(d[,1]!='Rk'),]
    out$namecode <- sapply(out$X, function(i) strsplit(i, '\\\\')[[1]][2])
    write.csv(out, file=paste0('./data/pfr_fantasy_', i, '.csv'), row.names=FALSE, quote=FALSE)
  }
  
  library(plyr)
  d <- lapply(
    setNames(2000:2015, 2000:2015), 
    function(year) {
      read.csv(paste0('./data/pfr_fantasy_', year, '.csv'), header=T, stringsAsFactors = F)
    }
  )
  for (i in 2000:2015) {
    unlink(paste0('./data/pfr_fantasy_', i, '.csv'))
  }
  
  df <- ldply(d, data.frame, .id="year")
  df$year <- as.numeric(as.character(df$year))
  df$quintile <- NA
  for (year in 2000:2015) {
    rk <- data.frame(Rk=df[which(df$year == year), 'Rk'])
    rk <- within(rk, quintile <- as.integer(cut(Rk, quantile(Rk, probs=0:5/5), include.lowest=TRUE)))
    df[which(df$year == year), 'quintile'] <- rk$quintile
  }
  
  
  library('sqldf')
  s <- "
  SELECT
    a.Rk as Rk_f1, a.quintile as q_f1, 
    b.*
  FROM df b
    LEFT JOIN df a
      on (a.year - 1) = b.year
      and a.namecode = b.namecode
  "
  FullDf <- sqldf(s)
  FullDf[which(FullDf$namecode == 'JameEd00'), c('year', 'Rk', 'Rk_f1', 'quintile', 'q_f1')]
  
  output_file <- './data/Pfr_FantasyData_AllSeasons.csv'
  write.csv(FullDf, output_file, row.names=FALSE, quote = FALSE)
  print("Clean dataset of Pro-Football-reference historical fantasy ranks output")
  print(paste0("The CSV is located in: ", output_file))
}









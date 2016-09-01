
# clean PFR fantasy data

for (i in 2000:2015) {
  d <- read.csv(paste0('./data/PFR/pfr_fantasy_', i, '.csv'), skip=1, stringsAsFactors = F)
  out <- d[which(d[,1]!='Rk'),]
  out$namecode <- sapply(out$X, function(i) strsplit(i, '\\\\')[[1]][2])
  write.csv(out, file=paste0('./data/clean/pfr_fantasy_', i, '.csv'), row.names=FALSE, quote=FALSE)
}

library(plyr)
d <- lapply(
  setNames(2000:2015, 2000:2015), 
  function(year) {
    read.csv(paste0('./data/clean/pfr_fantasy_', year, '.csv'), header=T, stringsAsFactors = F)
  }
)
for (i in 2000:2015) {
  unlink(paste0('./data/clean/pfr_fantasy_', i, '.csv'))
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
  a.*, b.Rk as Rk_l1, b.quintile as q_l1
FROM df a
  LEFT JOIN df b
    on (a.year - 1) = b.year
    and a.namecode = b.namecode
"
FullDf <- sqldf(s)
#tt[which(tt$namecode == 'JameEd00'), c('year', 'Rk', 'Rk_l1', 'quintile', 'q_l1')]

write.csv(FullDf, './data/Pfr_FantasyData_AllSeasons.csv', row.names=FALSE, quote = FALSE)








players <- read.csv(file.choose(), header=T)
attach(players)
playerData = players[,c("FTM","FTA")]
png(file="players_ft.png")
plot(x=playerData$FTM, y=playerData$FTA,
     xlab="FTM", ylab="FTA", main="Made and attemted free throws")
dev.off()
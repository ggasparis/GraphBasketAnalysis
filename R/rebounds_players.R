rb_players <- read.csv(file.choose(), header=T)
attach(rb_players)
rbplayerData = rb_players[,c("OREB","DREB")]
png(file="players_rb.png")
plot(x=rbplayerData$OREB, y=rbplayerData$DREB,
     xlab="OREB", ylab="DREB", main="Offensive & Defensive rebounds")
dev.off()

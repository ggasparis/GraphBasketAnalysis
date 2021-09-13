spider_plot = games_details %>%
  group_by(Player=PLAYER_NAME) %>%
  filter(GAME_ID > 21200463) %>%
  summarise(
    Rebs=sum(REB, na.rm=T),
    Steals=sum(STL, na.rm=T),
    Assists=sum(AST, na.rm=T),
    FG=sum(FGM, na.rm=T)
  )

maxxx = apply(spider_plot[,c("Rebs","Steals","Assists", "FG")],2,max)    
minnn = apply(spider_plot[,c("Rebs","Steals","Assists","FG")],2,min)    

spiderplot = spider_plot[c(509,802),c("Rebs","Steals","Assists","FG")]
rownames(spiderplot) <- c("Giannis","Leonard")

comp_plot(spiderplot,maxxx,minnn)



plotdataa = games_details %>%
  group_by(Player=PLAYER_NAME) %>%
  summarise(
    DRebs=mean(DREB, na.rm=T),
    ORebs=mean(OREB, na.rm=T),
    PlusMinus=mean(PLUS_MINUS, na.rm=T),
    Fg_pct=mean(FG_PCT, na.rm=T)
  )

maxxxx = apply(plotdataa[,c("DRebs","ORebs","PlusMinus","Fg_pct")],2,max)    
minnnn = apply(plotdataa[,c("DRebs","ORebs","PlusMinus","Fg_pct")],2,min)    

plot_dataa = plotdataa[c(787,1227),c("DRebs","ORebs","PlusMinus","Fg_pct")]
rownames(plot_dataa) <- c("Giannis","Leonard")

comp_plot(plot_dataa,maxxxx,minnnn)



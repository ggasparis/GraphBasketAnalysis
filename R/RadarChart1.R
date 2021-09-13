plotdata = games_details %>%
  group_by(Player=PLAYER_NAME) %>%
  summarise(
    Points=sum(PTS, na.rm=T),
    Fg=sum(FGM, na.rm=T),
    Blocks=sum(BLK, na.rm=T),
    Fg3=sum(FG3M, na.rm=T)
  )

maxxx = apply(plotdata[,c("Points","Fg","Blocks","Fg3")],2,max)    
minnn = apply(plotdata[,c("Points","Fg","Blocks","Fg3")],2,min)    

plot_data = plotdata[c(1369,936),c("Points","Fg","Blocks","Fg3")]
rownames(plot_data)<-c("Lebron","Harden")


comp_plot = function(data,maxxx,minnn){
  library(fmsb)
  data = rbind(maxxx, minnn, data)
  
  colors_border=c( rgb(0.2,0.5,0.5,0.9), rgb(0.8,0.2,0.5,0.9) , rgb(0.7,0.5,0.1,0.9) )
  colors_in=c( rgb(0.2,0.5,0.5,0.4), rgb(0.8,0.2,0.5,0.4) , rgb(0.7,0.5,0.1,0.4) )
  
  radarchart( data, axistype=1 , 
              pcol=colors_border , 
              pfcol=colors_in , 
              plwd=4 , 
              plty=1, 
              cglcol="grey", 
              cglty=1, 
              axislabcol="grey", 
              caxislabels=rep("",5), 
              cglwd=0.8, 
              vlcex=0.8)
  
  legend(x=0.5, 
         y=1.2, 
         legend = rownames(data[-c(1,2),]), 
         bty = "n", 
         pch=20 ,
         col=colors_in , 
         text.col = "black", 
         cex=1, 
         pt.cex=3)
}

comp_plot(plot_data,maxxx,minnn)



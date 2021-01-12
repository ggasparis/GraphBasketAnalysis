library(tidyverse)
#Points vs minutes played
ggplot(data = games_details, mapping = aes( x = MIN, y = PTS, color = START_POSITION, shape = START_POSITION)) +
  geom_point()
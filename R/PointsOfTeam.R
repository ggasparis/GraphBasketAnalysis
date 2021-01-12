library(tidyverse)
ggplot(data = games_details, mapping = aes(x = MIN, y = PTS, color = TEAM_ABBREVIATION == "MIL")) +
  geom_point()
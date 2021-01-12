games_details %>%
  filter(TEAM_ABBREVIATION=="MIL") %>%
  ggplot() + geom_point( mapping = aes(x = MIN, y = PTS, color = START_POSITION))
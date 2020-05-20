#play with converting moon phases to tide stage
library(tidyverse)
library(lubridate)
library(lunar)

dates <- data.frame(Date1 = as.Date(c("2000-01-01", "2000-01-05","2000-01-07",
                                      "2000-01-10", "2000-01-13","2000-01-15",
                                      "2000-01-17", "2000-01-20","2000-01-25",
                                      "2000-01-27","2000-01-30", "2000-02-02")))
  

dates$phase = lunar.phase(dates$Date1)
#that gives us the lunar phase in radians. However, 
#Both full moon and new moons are spring tides, whereas half moons are neap tides

dates$spring = abs(cos(dates$phase))


springneap = data.frame(phase = c("spring", "neap", "spring", "neap"),
                        stage = c(0, pi/2, pi, 3*pi/2))

#quick plot
dp = ggplot(data = dates)
dp+geom_point(aes(x = Date1, y = phase, color = "blue"))+
  geom_line(aes(x = Date1, y = phase, color = "blue"))+
  geom_point(aes(x = Date1, y = spring, color = "black"))+
  geom_hline(yintercept = springneap$stage)


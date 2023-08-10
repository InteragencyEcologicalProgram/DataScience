
plot_data <- function(data){
  ggplot(data, aes(x = WaterYear, y = Value, col = Scenario)) +
    geom_line() +
    facet_wrap(~River) +
    coord_cartesian(ylim = c(-18000, 18000))
}
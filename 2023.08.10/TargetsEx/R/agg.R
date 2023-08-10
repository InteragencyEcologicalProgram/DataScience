
agg_data <- function(data){
  data |>
    group_by(River, WaterYear, Scenario) |>
    summarise(Value = median(Value, na.rm = TRUE))
}

prep_data <- function(path_list){
  lapply(path_list, function(path){
    read.csv(path) |> 
      pivot_longer(cols = !c(WaterYear, Month),
                   names_to = "Scenario",
                   values_to = "Value")
  }) |> 
    bind_rows(.id = "River")
}

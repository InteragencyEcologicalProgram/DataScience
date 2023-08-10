
calc_diff <- function(inflow, outflow){
  left_join(rename(inflow, Inflow = Value),
            rename(outflow, Outflow = Value)) |>
    mutate(Value = Outflow - Inflow)
}
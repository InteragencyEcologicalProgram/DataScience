


Scale <- function(x) {
  out <- x / (max(x) - min(x))
  
  class(out) <- "Scale"
  
  out
  
}


library(dplyr)
library(ggplot2)

# Sequence ------------------------------------------------

x <- c()
val <- 1
while (val < 2.1) {
  x <- c(x, val)
  val <- val + 0.1
}
x
seq(1, 2, 0.1)

# Repeat ------------------------------------------------

x <- c()
for (i in 1:10){
  x <- c(x, "*")
}
x
rep("*", 10)

# Print ------------------------------------------------

for (i in 1:5){
  x <- c()
  for (j in 1:i){
    x <- c(x, "*")
  }
  cat(c(x, "\n"), sep = "")
}

for (i in 1:5){
  cat(c(rep("*", i), "\n"), sep = "")
}

# Fill Arrays ------------------------------------------------

out <- array(dim = c(3, 3, 3))
for (i in 1:3){
  for (j in 1:3){
    for (k in 1:3){
      out[i, j, k] <- i * j + k
    }
  }
}
out[, , 1]

# Manipulate Lists ------------------------------------------------

rlist <- list(A = data.frame(x = sample(10, 3), y = sample(10, 3)),
              B = data.frame(x = sample(10, 3), y = sample(10, 3)))
rlist

rlist[["A"]]$z <- rlist[["A"]]$x + rlist[["A"]]$y
rlist[["B"]]$z <- rlist[["B"]]$x + rlist[["B"]]$y

for (i in names(rlist)){
  rlist[[i]]$z <- rlist[[i]]$x + rlist[[i]]$y
}

for (i in names(rlist)){
  rlist[[i]] <- mutate(rlist[[i]], z = x + y)
}

rlist <- lapply(rlist, function(x){x$z = x$x + x$y; x})

# Generate Data ------------------------------------------------

sample5 <- function(x){
  sample(x, 5, replace = TRUE)
}

out_list <- list()
for (i in 1:20){
  out_list[[i]] <- data.frame(day = sort(runif(20, 0, 50)),
                              river_mile = c(sample5(20:16),
                                             sample5(15:11),
                                             sample5(10:6),
                                             sample5(5:1)))
}
out_df <- bind_rows(out_list, .id = "cohort_id")
head(out_df)

# Save Plots ------------------------------------------------

if (!dir.exists("figures")) dir.create("figures")
for (i in unique(out_df$cohort_id)){
  out_sub <- filter(out_df, cohort_id == i)
  ggplot(out_sub, aes(x = day, y = river_mile)) +
    geom_line() +
    geom_point() +
    labs(title = paste("Cohort", i))
  ggsave(paste0("Cohort_", i, ".png"), width = 6, height = 4, path = "figures")
}

# Write Files ------------------------------------------------

if (!dir.exists("output")) dir.create("output")
for (i in names(out_list)){
  write.csv(x = mutate(out_list[[i]], cohort_id = i),
            file = file.path("output", paste0("Cohort_", i, ".csv")),
            row.names = FALSE)
}

for (i in unique(out_df$cohort_id)){
  out_sub <- filter(out_df, cohort_id == i)
  write.csv(x = out_sub,
            file = file.path("output", paste0("Cohort_", i, ".csv")),
            row.names = FALSE)
}

# Read Files ------------------------------------------------

fn <- list.files(path = "output", pattern = "csv", full.names = TRUE)

in_list <- list()
for (i in seq_along(fn)){
  in_list[[i]] <- read.csv(fn[i])
}

in_list <- lapply(fn, read.csv)

# Split-Apply-Combine ------------------------------------------------

out_list <- list()
for (i in unique(PlantGrowth$group)){
  pg_sub <- filter(PlantGrowth, group == i)
  avg_weight_sub <- mean(pg_sub$weight)
  out_list[[i]] <- data.frame(avg_weight = avg_weight_sub)
}
out_list
bind_rows(out_list, .id = "group")

PlantGrowth %>% 
  group_by(group) %>% 
  summarise(avg_weight = mean(weight))


library(officer)
library(tidyverse)

# Example Plots -----------------------------------------------------------

austin_housing = txhousing %>% 
  filter(city == "Austin") %>% 
  mutate(month = factor(month.abb[month], levels = month.abb[1:12]))

ex_plot1 = ggplot(austin_housing, aes(x = date, y = median)) +
  geom_point(alpha = 0.6)

ex_plot2 = ggplot(austin_housing, aes(x = month, y = sales)) +
  geom_boxplot()


# Read Slides -------------------------------------------------------------

read_pptx("ExampleSlides1.pptx") %>% 
  pptx_summary() %>% 
  View()

# Add Plots to Slides -----------------------------------------------------

read_pptx("ExampleSlides1.pptx") %>% 
  on_slide(index = 2) %>% 
  ph_with(value = ex_plot1, location = ph_location_right()) %>% 
  on_slide(index = 3) %>% 
  ph_with(value = ex_plot2, location = ph_location_type(type = "body")) %>% 
  print(target = "ExampleSlides2.pptx")
  

# Remove and Replace Plots ------------------------------------------------

ex_plot1a = ggplot(austin_housing, aes(x = date, y = median)) +
  geom_point(alpha = 0.6) +
  theme_minimal()

ex_plot2a = ggplot(austin_housing, aes(x = month, y = sales)) +
  geom_boxplot() +
  theme_minimal()

read_pptx("ExampleSlides2.pptx") %>% 
  on_slide(index = 2) %>% 
  ph_with(value = ex_plot1a, location = ph_location_right()) %>% 
  on_slide(index = 3) %>% 
  ph_with(value = ex_plot2a, location = ph_location_type(type = "body")) %>% 
  print(target = "ExampleSlides3.pptx")

library(officer)
library(tidyverse)

# Example Plot ------------------------------------------------------------

ex_plot = ggplot(tibble(x = seq(-5, 5, 0.1), y = sin(x)), 
                 aes(x = x, y = y)) +
  geom_line() 

ex_cap = block_caption("Figure 1.1. Sine wave.", style = "Normal")

# Read Document -----------------------------------------------------------

read_docx("ExampleDocument1.docx") %>% 
  docx_summary() %>% 
  View()

# Add Plot to Document ----------------------------------------------------

# Option 1
read_docx("ExampleDocument1.docx") %>% 
  cursor_reach("match with cursor_reach") %>%    # put cursor at first place in doc where text is matched
  body_add_gg(value = ex_plot, height = 3.5) %>% 
  body_add_caption(ex_cap) %>% 
  print(target = "ExampleDocument2.docx")

# Option 2
# use indexes provided by `docx_summary`
# function to advance cursor to specified index
cursor_index <- function(x, index){
  x = cursor_begin(x)                 # put cursor at beginning of document
  for (i in 2:index){                 # advance cursor to specified index
    x = cursor_forward(x)
  }
  x
}

read_docx("ExampleDocument1.docx") %>% 
  cursor_index(4) %>%   
  body_add_gg(value = ex_plot, height = 3.5) %>%
  body_add_caption(ex_cap) %>% 
  print(target = "ExampleDocument2.docx")


# Remove and Replace ------------------------------------------------------

ex_plot2 = ggplot(tibble(x = seq(-5, 5, 0.1), y = cos(x)), 
                  aes(x = x, y = y)) +
  geom_line() 

ex_cap2 = block_caption("Figure 1.1. Cosine wave.", style = "Normal")

# Option 1
read_docx("ExampleDocument2.docx") %>% 
  cursor_reach("match with cursor_reach") %>% 
  cursor_forward() %>% 
  body_remove() %>%                         # remove plot
  body_remove() %>%                         # remove caption
  cursor_reach("match with cursor_reach") %>%
  body_add_gg(value = ex_plot2, height = 3.5) %>%
  body_add_caption(ex_cap2) %>%
  print(target = "ExampleDocument3.docx")

# Option 2
read_docx("ExampleDocument2.docx") %>% 
  docx_summary() %>% 
  View()

read_docx("ExampleDocument2.docx") %>% 
  cursor_index(5) %>% 
  body_remove() %>%                         # remove plot
  body_remove() %>%                         # remove caption
  cursor_index(4) %>% 
  body_add_gg(value = ex_plot2, height = 3.5) %>%
  body_add_caption(ex_cap2) %>%
  print(target = "ExampleDocument3.docx")


# Caution -----------------------------------------------------------------

# Need to be careful with state because all xml is stored and manipulated in temporary directory
# https://github.com/davidgohel/officer/issues/137#issuecomment-394163976

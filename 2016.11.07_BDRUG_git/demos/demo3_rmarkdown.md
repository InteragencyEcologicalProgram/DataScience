RMarkdown Demo on GitHub
================
Jason DuBois
November 4, 2016

### RMarkdown on GitHub

RMarkdown files (.Rmd) typically do not render well on GitHub. Though you can certainly push an .Rmd file to GitHub, there are a couple of options for improving the display.

1.  with output as `output: html_document` select Output Options --&gt; Advance tab --&gt; check `keep markdown source file` --&gt; click OK & note the change in the YAML header
    -   after you knit to hmtl you'll see a markdown file (.md) of the same name
    -   push this .md file to GitHub

2.  instead of `output: html_document` use `output: github_document`
    -   press the `Knit` button & note the .md file your project folder
    -   push this .md file to GitHub

### Plots on GitHub

We can easily include plots for files displayed on GitHub. Just do as you would for any .Rmd file. When you press the `Knit` button, note the addition of a folder in your working directory. This folder is named as <FILE NAME>\_files. Open this folder, and you should see another folder "figure-markdown\_github". This folder contains the .png file for the plot you just created. You must `push` this folder to GitHub for the figures to be visible in your .md file.

``` r
library(ggplot2)

ggplot(data = iris, mapping = aes(x = Sepal.Length, y = Sepal.Width)) +
  geom_point(mapping = aes(fill = Species), shape = 21, size = 3)
```

![](demo3_rmarkdown_files/figure-markdown_github/plots-1.png)

Adding code for demo purposes.

We can even include raw HTML and have it render.

adding `<a href="#top">return to top</a>` gives you below when rendered.

<a href="#top">return to top</a>

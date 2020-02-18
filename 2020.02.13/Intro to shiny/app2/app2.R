library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Old Faithful Geyser Data"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30),
            radioButtons("column",
                        "Column to plot:",
                        choices=c("Time between eruptions"=2, "Eruption time"=1)),
            actionButton("run",
                         "Run")
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    hist_plot <- eventReactive(input$run, {
        # generate bins based on input$bins from ui.R
        x    <- faithful[, as.integer(input$column)]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)
        
        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white')
    })

    output$distPlot <- renderPlot({
        hist_plot()
    })
}

# Run the application 
shinyApp(ui = ui, server = server)

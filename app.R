library(shiny)
library(r2d3)
library(dplyr)

ui <- fluidPage(
  numericInput("sampleSize",
               "Sample size:",
               value = 10,
               min = 5, max = 100,
               step = 5),
  
  actionButton("reset", "< Back"),
  
  d3Output("myPlot")  
)

server <- function(input, output, session) {
  
  monthly <- data.frame(
    month = factor(month.name, levels = month.name),
    value = sample(1000:2000, 12)
  )
  
  detailed <- expand.grid(
    month = factor(month.name, levels = month.name),
    channel = c("tv", "print", "internet", "poster", "youtube", "trade press", "radio", "cinema")
  ) %>% 
    as.data.frame() %>% 
    mutate(value = sample(x = 100:500, size = nrow(.)))
  
  
  DF <- list(monthly, detailed)
  
  
  data_to_plot <- reactiveValues(df = NULL)
  
  
  observeEvent(input$reset, {
    print("reset")
    data_to_plot$df <- DF[[1]]$value / max(DF[[1]]$value)
  })
  
  observeEvent(input$bar_clicked, {
    df <- DF[[2]]
    df <- df[df$month == month.name[as.numeric(input$bar_clicked) + 1], ]
    print(df)
    data_to_plot$df <- df$value / max(df$value)
  })
  
  
  
  output$myPlot <- renderD3({
    validate(
      need(data_to_plot$df, FALSE)
    )
    print(data_to_plot$df)
    r2d3(data_to_plot$df, script = "bar_plot.js")
  })
}

shinyApp(ui, server)
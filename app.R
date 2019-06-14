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
  
  fluidRow(
    column(4,
           d3Output("myPlot")  
           )
  )
    
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
  
  
  data_to_plot <- reactiveValues(df = {
    tdf <- DF[[1]]
    tdf$value <- DF[[1]]$value / max(DF[[1]]$value)
    tdf
    },
    mode = "monthly")
  
  
  observeEvent(input$reset, {
    print("reset")
    data_to_plot$df <- DF[[1]]
    data_to_plot$df$value <- DF[[1]]$value / max(DF[[1]]$value)
    data_to_plot$mode <- "monthly"
    data_to_plot$df <- r2d3(data_to_plot$df, script = "bar_plot.js")
  })
  
  observeEvent(input$bar_clicked, {
    if (data_to_plot$mode == "monthly") {
      df <- DF[[2]]
      df <- df[df$month == input$bar_clicked, ]
      print(df)
      data_to_plot$df <- df$value / max(df$value)
      data_to_plot$mode <-  "detailed"
      data_to_plot$df <- r2d3(data_to_plot$df, script = "bar_plot.js")  
    }
  })
  
  
  
  output$myPlot <- renderD3({
    validate(
      need(data_to_plot$df, FALSE)
    )
    
    data_to_plot$df
  })
}

shinyApp(ui, server)
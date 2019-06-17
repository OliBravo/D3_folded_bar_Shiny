library(shiny)
library(shinyjs)
library(r2d3)
library(dplyr)

ui <- fluidPage(
  
  useShinyjs(),
  
  
  hidden(actionButton("reset", "< Back")),
  
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
  
  
  data_to_plot <- reactiveValues(df = DF[[1]], mode = "monthly")
  
  observeEvent(input$reset, {
    print("reset")
    data_to_plot$df <- DF[[1]]
    # data_to_plot$df$value <- DF[[1]]$value / max(DF[[1]]$value)
    data_to_plot$mode <- "monthly"
    data_to_plot$df <- r2d3(data_to_plot$df, script = "bar_plot.js")
  }, ignoreInit = FALSE, ignoreNULL = FALSE)
  
  observeEvent(input$bar_clicked, {
    cond <- data_to_plot$mode == "monthly"
    shinyjs::toggle("reset", !cond)
    
    if (cond) {
      df <- DF[[2]]
      df <- df[df$month == input$bar_clicked, ]
      print(df)
      data_to_plot$df <- df
      # data_to_plot$df$value <- df$value / max(df$value)
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
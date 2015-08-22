
library(shiny)
library(tm)
load('FTL_10_percent.RData')
source('NTP.R')
source('WB.R')
source('KN.R')

shinyServer(function(input, output) {
  dataInput <- reactive({
    progress <- shiny::Progress$new()
    # Make sure it closes when we exit this reactive, even if there's an error
    on.exit(progress$close())
    
    progress$set(message = "...IN PROGRESS", value = 3)
    if (input$radio == 1){
      NTP(input$entry, input$n)
    } else if (input$radio == 2) {
      WB(input$entry, input$n)
    } else if (input$radio == 3) {
      KN(input$entry, input$n)
    }
  })
  output$text <- renderText({
    dataInput()
  })
  output$sent <- renderText({
    input$entry
  })
})
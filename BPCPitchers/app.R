library(dplyr)
library(ggplot2)
library(mgcv)
library(REdaS)
library(gridExtra)
source("data/Charts.R")

# Define UI for application that draws a histogram
ui <- fluidPage(
  tags$head(HTML("<title>Individualized Pitcher Reports</title> <link rel='icon' type='image/gif/jpg' href='bpc.jpg'>")),
  # Application title
  titlePanel(title = div("Individualized Pitcher Reports",img(src="bpc.jpg", width = 50, height = 50))),
  
  selectInput("pitcher",
              "Select Pitcher:",
              sort(unique(as.character(Pitchers$Pitcher)))),
  DT::dataTableOutput('arsenal'),
  h2("The Below Charts Show Whiffs Rates For Comparable MLB Fastballs By Spin and Movement"),
  h4("From Perspective of Catcher"),
  plotOutput('whiffplot'),
  selectInput("pitch",
              "Select Pitch Type:",
              c("Two Seam", "Cutter", "Slider", "Change Up", "Curveball")),
  DT::dataTableOutput('pitchcomp')
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$whiffplot <- renderPlot({
    whiff_chart(pitch_arsenal(input$pitcher), input$pitcher)
  })
  
  output$arsenal <- DT::renderDataTable(DT::datatable({
    data <- pitch_arsenal(input$pitcher)
  }, options = list(paging = FALSE, searching = FALSE),
  rownames= FALSE))
  
  output$pitchcomp <- DT::renderDataTable(DT::datatable({
    data <- pitch_comps(input$pitcher, input$pitch)
  }, options = list(paging = FALSE, searching = FALSE),
  rownames= FALSE))
}

# Run the application 
shinyApp(ui = ui, server = server)

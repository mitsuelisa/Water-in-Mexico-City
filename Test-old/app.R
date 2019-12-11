#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(markdown)
library(shiny)
library(leaflet)
library(ggmap)
library(tidyverse)



agua_cdmx_latlng <- readRDS("agua_cdmx_latlng.rds")

#Create a color palette
pal <- colorNumeric(
    palette = colorspace::heat_hcl,
    domain = agua_cdmx_latlng$consumo_total)

# Define UI for application that draws a histogram
ui <- navbarPage("Who is causing water stress in Mexico City?",
                 tabPanel("Interactive Map",
                          sidebarLayout(
                              sidebarPanel(
                                  radioButtons("plotType", "Circle Size",
                                               c("Total Consumed Cubic Meters in 2019"="p")
                                  )
                              ),
                              mainPanel(
                                  leafletOutput("plot"),
                                  
                                  
                              )
                          )
                 ),
                 tabPanel("About",
                          fluidRow(
                              column(6,
                                     includeMarkdown("about.Rmd")
                              ),
                              column(3,
                                     img(class="img-polaroid",
                                         src= "https://lh3.googleusercontent.com/QbpmcKaQ68U8Kxq2cMqWFiEc8iN5kLTrO5vcp7PQ1gJNQ3DZ5hxyPxxc9jWr_N_6GQ"
                                     )
                              )
                          )
                 )
)



# Define server logic required to draw a histogram

server <- function(input, output, session) {
    output$plot <- renderLeaflet({
        
        
        leaflet() %>%
            setView(lng = -99.1269, lat = 19.4978, zoom = 11) %>%
            setMaxBounds(-99.34196, 19.1356, -98.95071, 19.5751) %>%
            addProviderTiles(providers$CartoDB.Positron) %>%
            addCircleMarkers(lng = agua_cdmx_latlng$lng, lat = agua_cdmx_latlng$lat,
                             label = agua_cdmx_latlng$consumo_total,
                             weight = 0,
                             labelOptions = labelOptions(noHide = T),
                             fillColor = pal(agua_cdmx_latlng$consumo_total),
                             radius = agua_cdmx_latlng$consumo_total*.001)
        
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server)

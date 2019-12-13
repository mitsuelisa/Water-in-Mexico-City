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
library(wesanderson)
library(tidyverse)



agua_cdmx_latlng <- readRDS("agua_cdmx_latlng.rds")

#Create a color palette
pal <- colorFactor(
    palette = c("#85D4E3", "#9C964A", "#FAD77B"), agua_cdmx_latlng$bimestre)

# Define UI for application that draws a histogram
ui <- navbarPage("Who is causing water stress in Mexico City?",
                 tabPanel("Interactive Map",
                          sidebarLayout(
                              sidebarPanel(
                                  
                                  helpText("This map shows the top water consumers (total consumption) of Mexico City. The circle size represents the size of their consumption and the labels that pop up on hover mean the cubic meters they consumed. Move around the map to find out at block level who are the top consumers. The color shows Blue for the 1 bimester, olive for the 2 bimester, and yellow for the third bimester."),
                                  
                                  
                                  radioButtons("plotType", "Circle Size",
                                               c("Total Consumed Cubic Meters in 2019"="p")
                                  )
                              ),
                              mainPanel(
                                  leafletOutput("plot", width="100%",height="1000px"),
                                  
                                  
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
                             labelOptions = labelOptions(noHide = F),
                             fillColor = pal(agua_cdmx_latlng$bimestre),
                             radius = agua_cdmx_latlng$consumo_total*.0004)
        
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server)

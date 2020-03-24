library(leaflet)
library(RSQLite)
library(shiny)
db=dbConnect(SQLite(), dbname="mapdata.sqlite")
dbSendQuery(conn=db,
            "CREATE TABLE Map
            (Country TEXT,
            Emotion TEXT)")
dbSendQuery(conn=db,
            "INSERT INTO Map
            VALUES ('Germany', 'Happiness')")
dbSendQuery(conn=db,
            "INSERT INTO Map
            VALUES ('input$Country', 'input$Emotion')")
dbListFields(db, "Map")
dbDisconnect(db)
country_names=data@data$sovereignt
dat=data@data
chloro.palette = colorFactor(palette = c("#bbe7ff", "#ffc88c", "#bdf38d", "#fff6aa"), domain=data@data$mood)
mood=cbind("country"=country_names, "Joy"=0, "Anger"=0, "Fear"=0, "Grief"=0)
# Define UI ---- elements that are displayed on the page
ui <- fluidPage(
  titlePanel("How do you feel?"),
  sidebarLayout(
    sidebarPanel(
      h2("Your Country"),
      selectInput("Country", "Choose your country:", choices = country_names),
      selectInput("Emotion", "Choose your emotion:", choices=c("Joy", "Anger", "Fear", "Grief")),
      actionButton("Button1", label = "Submit")
tableOutput()
      ),
    mainPanel(
      h1("How does the World feel?"),
      leafletOutput("mymap")
                )
  )
)

# Define server logic ---- what are inputs and outputs
server <- function(input, output, session) {
 output$mymap=renderLeaflet({ 
   #output options must be saved to output$ and must be build with render function
   #render function builds reactive output to display in UI
   leaflet(data=dat) %>% 
    addTiles() %>% 
    addPolygons(data=data, weight=2, color = ~chloro.palette(data@data$mood)) %>%
    addLegend("topright", pal = chloro.palette, values = ~mood,
              title = "Mood",
              opacity = 1) %>%
    addScaleBar(position="topleft")
 })
}

# Run the app ----
shinyApp(ui = ui, server = server)


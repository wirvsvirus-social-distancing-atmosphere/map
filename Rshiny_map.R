library(leaflet)
library(RSQLite)
library(shiny)
db=dbConnect(SQLite(), dbname="mapdata.sqlite")
dbSendQuery(conn=db,
            "CREATE TABLE Map
            (UserID INTEGER,
            Country TEXT,
            Emotion TEXT)")
dbSendQuery(conn=db,
            "INSERT INTO Map
            VALUES (1, 'Germany', 'Happiness')")
dbListFields(db, "Map")
dbDisconnect(db)
country_names=data@data$sovereignt
dat=data@data
chloro.palette = colorFactor(palette = c("#bbe7ff", "#ffc88c", "#bdf38d", "#fff6aa"), domain=data@data$mood)
mood=cbind("country"=country_names, "Joy"=0, "Anger"=0, "Fear"=0, "Grief"=0)
# Define UI ----
ui <- fluidPage(
  titlePanel("How do you feel?"),
  sidebarLayout(
    sidebarPanel(
      h2("Your Country"),
      selectInput("Input1", "Choose your country:", choices = country_names),
      selectInput("Input2", "Choose your emotion:", choices=c("Joy", "Anger", "Fear", "Grief")),
      actionButton("Button1", label = "Submit")
tableOutput()
      ),
    mainPanel(
      h1("How does the World feel?"),
      leafletOutput("mymap")
                )
  )
)

# Define server logic ----
server <- function(input, output, session) {
 output$mymap=renderLeaflet({
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


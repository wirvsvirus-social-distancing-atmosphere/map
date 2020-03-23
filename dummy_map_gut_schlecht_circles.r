library(leaflet)
library(rjson)
library(geojsonio)
library(ggplot2)
library(rgdal)
library(sp)

setwd("C:/Users/danan/Desktop")
dummy_mood=rnorm(10000, 50, 20) 
dummy_coords=cbind(rnorm(10000, sd=15) * 2 + 13, rnorm(10000, sd=15) + 48)
dummy_heat_values=cbind.data.frame("value"=dummy_mood, "lat"=dummy_coords[,1], "long"=dummy_coords[,2])
dummy_heat_values$range= cut(dummy_heat_values$value, 
                         breaks = c(0,20,50,80,100), right=FALSE,
                         labels = c("Sadness[0-20)", "Anger[20-50)", "Happiness[50-80)", "Concern[80-100)"))
col.palette = colorFactor(palette = c("yellow", "red", "green", "orange"), domain=dummy_heat_values$range)

data=geojson_read("custom.geo.json", what="sp")

leaflet(data=dummy_heat_values) %>% 
  addTiles() %>% 
  addPolygons(data=data, weight=2, opacity=0.1) %>% 
  addCircleMarkers(lng=~lat,
                   lat=~long, 
                   opacity=0.3,
                   fillOpacity = 0.3,
                   radius = 1,
                   color = ~ col.palette(range), 
                   label = paste("Stimmung=", dummy_heat_values$range)) %>%
  addLegend(position="topright", 
            pal=col.palette, 
            values=~range,
            title="Mood") %>%
  addScaleBar(position = "topleft") 




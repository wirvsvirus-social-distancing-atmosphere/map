#Chloroplethenkarte
library(leaflet)
library(rjson)
library(geojsonio)
library(ggplot2)
library(rgdal)
library(sp)
library(maptools)


setwd("C:/Users/danan/Desktop")
 
sample=rep(x = c(1,2,3,4), 1000)
data=geojson_read("custom.geo.json", what="sp")
dummy_emotion=sample(x = sample, replace = F, size=175)
data@data$mood=dummy_emotion
dat=data@data
chloro.palette = colorFactor(palette = c("#bbe7ff", "#ffc88c", "#bdf38d", "#fff6aa"), domain=data@data$mood)

leaflet(data=dat) %>% 
  addTiles() %>% 
  addPolygons(data=data, weight=2, color = ~chloro.palette(data@data$mood)) %>%
  addLegend("topright", pal = chloro.palette, values = ~mood,
            title = "Mood",
            opacity = 1) %>%
  addScaleBar(position="topleft")


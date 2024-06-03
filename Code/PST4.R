##Nicolas Borda 202210560 - Carlos Eduardo Caceres 202210591
##R version 4.3.2 (2023-10-31 ucrt)

require(pacman)
p_load("tidyverse", "rio", "dplyr", "data.table", "janitor", "sf", "rvest", "ggplot2", "viridis")

## 1. Extraer la información de internet

## 1.1 Obtener las UR

url <- "https://eduard-martinez.github.io/pset-4.html"
webpage <- read_html(url)

url_full <- webpage %>%
  html_nodes("a") %>%
  html_attr("href") %>%
  unlist()


##1.2 Filtrar URL
url_subset <- url_full[grep("propiedad", url_full)]

#1.3 Extraer las tablas de los HTML
lista_tablas <- list()

for(i in seq_along(url_subset)) {
    webpage <- read_html(url_subset[i])
    tabla <- webpage %>%
             html_nodes("table") %>%
             html_table(fill = TRUE) %>%
             as.data.frame()
  lista_tablas[i] <- list(tabla[1, c("price", "lat", "lon")])
}

#1.4 Preparar informacion
db_house <- rbindlist(lista_tablas)


## 2. Manipular la información GIS ##

# 2.1 Cree un objeto sf
sf_house <- st_as_sf(db_house, coords = c("lon", "lat"), crs = 4326)
remove(sf_object)

# 2.2 Pintar Mapa
ggplot(data = sf_house) +
  geom_sf(aes(color = sf_house$price), size = 4) +
  scale_color_viridis(option = "D") + 
  ggtitle("Mapa de Puntos de Viviendas con Valor") +
  labs(color = "price")





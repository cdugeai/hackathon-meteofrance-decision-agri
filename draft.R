library(sf)
library(readr)
library(tidyr)
library(dplyr)
library(stringr)
library("rjson")

temp <- tempfile()
temp2 <- tempfile()

# Download the zip file and save to 'temp' 
URL <- "https://data.geopf.fr/telechargement/download/RPG/RPG_2-0__SHP_LAMB93_R84_2021-01-01/RPG_2-0__SHP_LAMB93_R84_2021-01-01.7z"

parcelles_42 <- st_read(
  "data/RPG_2-0__SHP_LAMB93_R84_2021-01-01/RPG/1_DONNEES_LIVRAISON_2021/RPG_2-0_SHP_LAMB93_R84_2021-01-01/PARCELLES_GRAPHIQUES.shp")

ilots_42 <- st_read(
  "data/RPG_2-0__SHP_LAMB93_R84_2021-01-01/RPG/1_DONNEES_LIVRAISON_2021/RPG_2-0_SHP_LAMB93_R84_2021-01-01/ILOTS_ANONYMES.shp")

communes_42 <- read_csv("data/v_commune_2023.csv") %>% filter(DEP=="42") 


communes_42_geo <- st_read(
  "data/geo/communes/georef-france-commune-millesime.shp")%>%
  mutate(geometry = st_transform(geometry, 4269))

parcelles_42_sample <- parcelles_42 %>% head(10)


parcelles_42_centroids <- parcelles_42_sample %>%
  count(ID_PARCEL, geometry, name = "n") %>%
  arrange(ID_PARCEL) %>%
  mutate(geometry = sf::st_centroid(geometry)) %>%
  mutate(geometry = st_transform(geometry, 4269))


parcelles_42_code_com <- 
  parcelles_42_centroids %>%
  st_join(., st_as_sf(communes_42_geo), join = st_nearest_feature) %>%
  dplyr::select(ID_PARCEL, n, com_code) %>%
  mutate(com_code_fix = str_extract(com_code, '[0-9]+'))


library(sf)
library(readr)
library(tidyr)
library(dplyr)
library(stringr)
library("rjson")

# Download the zip file and save to 'temp' 
URL <- "https://data.geopf.fr/telechargement/download/RPG/RPG_2-0__SHP_LAMB93_R84_2021-01-01/RPG_2-0__SHP_LAMB93_R84_2021-01-01.7z"

parcelles_R84 <- st_read(
  "data/RPG_2-0__SHP_LAMB93_R84_2021-01-01/RPG/1_DONNEES_LIVRAISON_2021/RPG_2-0_SHP_LAMB93_R84_2021-01-01/PARCELLES_GRAPHIQUES.shp")

#ilots_R84 <- st_read("data/RPG_2-0__SHP_LAMB93_R84_2021-01-01/RPG/1_DONNEES_LIVRAISON_2021/RPG_2-0_SHP_LAMB93_R84_2021-01-01/ILOTS_ANONYMES.shp")

communes_42 <- read_csv("data/v_commune_2023.csv") %>% filter(DEP=="42") 

## MAPPING parcelle <-> commune

communes_42_geo <- st_read(
  "data/geo/communes/georef-france-commune-millesime.shp")%>%
  mutate(geometry = st_transform(geometry, st_crs("WGS84")))

parcelles_R84_sample <- parcelles_R84 %>% arrange(ID_PARCEL) %>% head(10) %>%
  mutate(geometry = st_transform(geometry, st_crs("WGS84")))

parcelles_R84_sample %>%
  st_as_sf(., coords = c("x", "y"), agr = "constant") %>%
  st_write(., "data/out/parcelles_R84_sample_WGS84.geojson")


parcelles_R84_centroids <- parcelles_R84 %>%
  count(ID_PARCEL, geometry, name = "n") %>%
  arrange(ID_PARCEL) %>%
  mutate(geometry = sf::st_centroid(geometry)) %>%
  mutate(geometry = st_transform(geometry, st_crs("WGS84")))

parcelles_R84_centroids %>% 
  dplyr::mutate(lon = sf::st_coordinates(.)[,1],
                lat = sf::st_coordinates(.)[,2]) %>%
  write_csv("data/out/parcelles_R84_centroids.csv")

parcelles_R84_code_com <- 
  parcelles_R84_centroids %>%
  st_join(., st_as_sf(communes_42_geo), join = st_intersects) %>% #join = st_nearest_feature
  dplyr::select(ID_PARCEL, n, com_code) %>%
  mutate(com_code_fix = str_extract(com_code, '[0-9]+'))
#parcelles_R84_code_com <- read_csv("data/out/parcelles_R84_code_com.csv")

parcelles_D42_code_com <-
  parcelles_R84_code_com %>% 
  dplyr::filter(!is.na(com_code_fix)) 

parcelles_D42_code_com %>% 
  dplyr::mutate(lon = sf::st_coordinates(.)[,1],
                lat = sf::st_coordinates(.)[,2]) %>%
  as_tibble() %>%
  select(-geometry, -com_code, -n)%>% 
  write_csv("data/out/parcelles_D42_code_com.csv")
#parcelles_D42_code_com <- read_csv("data/out/parcelles_D42_code_com.csv") %>% st_as_sf(.,coords=c("lat","lon"), crs= st_crs("WGS84"))


parcelles_D42 <-
  parcelles_R84 %>%
  right_join(parcelles_D42_code_com %>% as_tibble()%>%select(ID_PARCEL), by="ID_PARCEL") %>%
  st_transform(st_crs("WGS84"))


## MAPPING parcelle <-> point SAFRAN


#safran_42_shp <- st_read("data/safran/safran_points-point.shp")

safran_R84_point <- read_delim("data/safran/aladin_safran_REF/indicesALADIN63_CNRM-CM5_24040815222841316.KEYuUOd9090U7BAAOOBBBB.txt", delim = ";") %>%
  select(point_id=Point, lat=Latitude, lon=Longitude) %>%
  count(point_id, lat, lon, name="n") %>%
  arrange(point_id) %>%
  st_as_sf(coords = c("lon","lat"), remove = FALSE, crs=st_crs("WGS84"))

# Pour chaque point SAFRAN du R84, on trouve les parcelles D42 correspondantes
# Les points SAFRAN hors D42 n'auront donc pas de parcelle correspondante
safran_42_mapped_parcelle <- safran_R84_point %>%
  st_join(., st_as_sf(st_make_valid(parcelles_D42)), join = st_intersects)


safran_42_mapped_parcelle %>%
  as_tibble() %>%
  select(-geometry, safran_point_id=point_id, lat, lon)%>% 
  write_csv("data/out/safran_42_mapped_parcelle.csv")


safran_42_mapped_parcelle %>% count(ID_PARCEL)

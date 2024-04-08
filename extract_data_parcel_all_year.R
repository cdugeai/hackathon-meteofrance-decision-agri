library(sf)
library(readr)
library(tidyr)
library(dplyr)
library(stringr)
library(nngeo)

parcelles_D42_centroids <- read_csv("data/out/parcelles_D42_centroids.csv") %>% mutate(ID_PARCEL=as.character(ID_PARCEL))

parcelles_D42_2021 <- st_read(
  "data/RPG/2021/RPG_2-0__SHP_LAMB93_R84_2021-01-01/RPG/1_DONNEES_LIVRAISON_2021/RPG_2-0_SHP_LAMB93_R84_2021-01-01/PARCELLES_GRAPHIQUES.shp") %>%
  right_join(parcelles_D42_centroids, by="ID_PARCEL") %>% mutate(year=2021)
parcelles_D42_2021 %>% as_tibble() %>% select(-geometry, -lat, -lon) %>% write_csv("data/out/RPG/parcelles_D42_2021.csv")
remove(parcelles_D42_2021)
gc()

parcelles_D42_2020 <- st_read(
  "data/RPG/2020/RPG_2-0__SHP_LAMB93_R84_2020-01-01/RPG/1_DONNEES_LIVRAISON_2020/RPG_2-0_SHP_LAMB93_R84_2020/PARCELLES_GRAPHIQUES.shp") %>%
  right_join(parcelles_D42_centroids, by="ID_PARCEL") %>% mutate(year=2020)
parcelles_D42_2020 %>% as_tibble() %>% select(-geometry, -lat, -lon) %>% write_csv("data/out/RPG/parcelles_D42_2020.csv")
remove(parcelles_D42_2020)
gc()

parcelles_D42_2019 <- st_read(
  "data/RPG/2019/RPG_2-0_SHP_LAMB93_R84-2019/RPG/1_DONNEES_LIVRAISON_2019/RPG_2-0_SHP_LAMB93_R84-2019/PARCELLES_GRAPHIQUES.shp") %>%
  right_join(parcelles_D42_centroids, by="ID_PARCEL") %>% mutate(year=2019)
parcelles_D42_2019 %>% as_tibble() %>% select(-geometry, -lat, -lon) %>%  write_csv("data/out/RPG/parcelles_D42_2019.csv")
remove(parcelles_D42_2019)
gc()


parcelles_D42_2016 <- st_read(
  "data/RPG/2016/RPG_2-0__SHP_LAMB93_R84-2016_2016-01-01/RPG/1_DONNEES_LIVRAISON_2016/RPG_2-0_SHP_LAMB93_R84-2016/PARCELLES_GRAPHIQUES.shp") %>%
  right_join(parcelles_D42_centroids, by="ID_PARCEL") %>% mutate(year=2016)
parcelles_D42_2016 %>% as_tibble() %>% select(-geometry, -lat, -lon) %>% write_csv("data/out/RPG/parcelles_D42_2016.csv")
remove(parcelles_D42_2016)
gc()


parcelles_D42_2015 <- st_read(
  "data/RPG/2015/RPG_2-0__SHP_LAMB93_R84-2015_2015-01-01/RPG/1_DONNEES_LIVRAISON_2015/RPG_2-0_SHP_LAMB93_R84-2015/PARCELLES_GRAPHIQUES.shp") %>%
  right_join(parcelles_D42_centroids, by="ID_PARCEL") %>% mutate(year=2015)
parcelles_D42_2015 %>% as_tibble() %>% select(-geometry, -lat, -lon) %>% write_csv("data/out/RPG/parcelles_D42_2015.csv") 
remove(parcelles_D42_2015)
gc()


df <- read_csv("data/out/RPG/parcelles_D42_2015.csv")


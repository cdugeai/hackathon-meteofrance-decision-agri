# Extraction des données SAFRAN décadaires
#   Données: https://meteo.data.gouv.fr/datasets/65e04035010927c797072b29

library(readr)
library(stringr)
library(magrittr)
library(dplyr)


grille_safran <- read_delim("data/safran/grilleSafran_utile.csv", delim=";") %>%
  mutate(LAMBX=as.double(stringr::str_sub(E_LambIIe, 1, -3)), LAMBY=as.double(stringr::str_sub(N_Lamb2e, 1, -3)))

safran_D42 <- read_csv("data/out/safran_D42_mapped_parcelle.csv") %>% filter(!is.na(ID_PARCEL)) %>% select(safran_point_id, lat, lon, ID_PARCEL) 

ds_1958_1959 <- read_delim("data/decad_sim/DECAD_SIM2_1958-1959.csv", delim = ";")

ds_1958_1959_D42 <-
  ds_1958_1959 %>%
  left_join(grille_safran, by=c("LAMBX", "LAMBY")) %>% 
  # On ne garde que les observations avec un safran_point_id (right join)
  right_join(safran_D42 %>% select(safran_point_id), by=join_by(idPoint==safran_point_id))

ds_1958_1959_D42 %>% write_csv("data/out/decad_sim/ds_1958_1959_D42.csv")

ds_2020_2024 <- read_delim("data/decad_sim/DECAD_SIM2_latest-2020-2024.csv", delim = ";")

ds_2020_2024_D42 <-
  ds_2020_2024 %>%
  left_join(grille_safran, by=c("LAMBX", "LAMBY")) %>% 
  # On ne garde que les observations avec un safran_point_id (right join)
  right_join(safran_D42 %>% select(safran_point_id), by=join_by(idPoint==safran_point_id))

ds_2020_2024_D42 %>% write_csv("data/out/decad_sim/ds_2020_2024_D42.csv")

ds_2020_2024_D42 %>% count(idPoint)

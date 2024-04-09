# Extraction des données SAFRAN décadaires
#   Données: https://meteo.data.gouv.fr/datasets/6569af36ba0c3d2f9d4bf98c

library(readr)
library(stringr)
library(magrittr)
library(dplyr)

stations_D42 <- read_csv("data/out/stations_D42_comm_code.csv") %>% mutate(NUM_POSTE=as.double(NUM_POSTE))

da_1950_2022 <- read_delim("data/decad_agro/DECADAGRO_42_previous-1950-2022.csv", delim = ";") %>% mutate(NUM_POSTE=as.double(NUM_POSTE))

da_1950_2022_D42 <-
  da_1950_2022 %>%
  right_join(stations_D42 %>% select(NUM_POSTE, com_code), by="NUM_POSTE")



da_1950_2022_D42 %>% write_csv("data/out/decad_agro/da_1950_2022_D42.csv")

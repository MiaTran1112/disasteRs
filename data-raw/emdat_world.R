## code to prepare `emdat_world` dataset goes here

emdat_world <- readxl::read_xlsx("data-raw/emdat_world.xlsx")|>
  janitor::clean_names()
usethis::use_data(emdat_world, overwrite = TRUE)



#' Create the map of natural disaster count in South-East Asian countries
#' @rdname ChiMai24
#' @details
#' This function focuses specifically on Southeast Asian countries. It uses the 
#' `rnaturalearth` package to fetch country shapes and joins this spatial data with 
#' disaster count data from the EM-DAT dataset. Countries without any disasters 
#' of the specified type and year are filled with a default neutral color.
#' @param year the year of the disaster
#' @param disaster_type the type of the disaster
#' @returns ggplot A map displaying the count of disasters for each country
#' @author ChiMai24
#' @import dplyr
#' @import ggplot2
#' @import rnaturalearth
#' @import sf
#' @import tidyr
#' @export
plot_disaster_map_sea <- function(disaster_type, year) {
  sea_map <- rnaturalearth::ne_countries(scale = "medium", returnclass = "sf") |>
    filter(admin %in% c("Vietnam", "Thailand", "Malaysia", "Indonesia", "Singapore", 
                        "Philippines", "Myanmar", "Cambodia", "Laos", "Brunei", "Timor-Leste"))
  
  filtered_emdat <- emdat_world |>
    filter(disaster_type == disaster_type, start_year == year)
  
  disaster_counts <- filtered_emdat |>
    group_by(country) |>
    summarise(count = n())
  
  sea_map_disaster <- sea_map |>
    left_join(disaster_counts, by = c("admin" = "country")) |>
    mutate(count = replace_na(count, 0))
  
  ggplot(data = sea_map_disaster) +
    geom_sf(aes(fill = count)) +
    scale_fill_gradientn(
      colors = c("slategray1", "slategray2", "slategray3", "slategray4"),
      na.value = "lightgray",
      name = "Disaster Count"
    ) +
    labs(title = paste(disaster_type, "Counts in Southeast Asia in", year)) +
    theme_minimal() +
    theme(legend.position = "bottom")
}

#' Create the map of natural disaster count for the world
#' @rdname ChiMai24
#' @details
#' Unlike `plot_disaster_map_sea`, which focuses on Southeast Asian countries, 
#' this function provides a global perspective. It uses global country shapes 
#' and disaster data to create a world map. This function is suitable for 
#' broader analyses involving all countries.
#' @param year the year of the disaster
#' @param disaster_type the type of the disaster
#' @returns ggplot A map displaying the count of disasters for each country
#' @author ChiMai24
#' @export
plot_disaster_map_world <- function(disaster_type, year) {
  world_map <- rnaturalearth::ne_countries(scale = "medium", returnclass = "sf")
  
  filtered_emdat <- emdat_world |>
    filter(disaster_type == disaster_type, start_year == year)
  
  disaster_counts <- filtered_emdat |>
    group_by(country) |>
    summarise(count = n())
  
  world_map_disaster <- world_map |>
    left_join(disaster_counts, by = c("admin" = "country")) |>
    mutate(count = replace_na(count, 0))
  
  ggplot(data = world_map_disaster) +
    geom_sf(aes(fill = count)) +
    scale_fill_gradientn(
      colors = c("slategray1", "slategray2", "slategray3", "slategray4"),
      na.value = "lightgray",
      name = "Disaster Count"
    ) +
    labs(title = paste(disaster_type, "Counts in The World in", year)) +
    theme_minimal() +
    theme(legend.position = "bottom")
}
#' @importFrom utils globalVariables
globalVariables(c("Location", "Country", "Start Year", "Start Month", "disaster_count", "num_year"))

#' This function analyzes the month with the most frequent peak disaster starts 
#' over a span of multiple years, and produces a bar plot showing the
#' frequency of peak months
#'
#' @author Mia Tran
#' 
#' @param data The data from EMDAT that users can freely scale when download
#' @param location Name of the place, maybe a city or a district to filter by
#' @param country Name of the country the place resides in to filter by
#' @returns A statement identifying the most frequent peak months of disaster
#' starts and a bar graph showing the frequency of peak disaster months.
#' #' @examples
#' file_path <- file.path("/Users/tranmaiphuong/Documents/SMITH/SOPHOMORE/SDS 270/public_emdat_2024-11-11.xlsx")
#' data <- readxl::read_excel(file_path)
#' disaster_month(data, "Hanoi", "Viet Nam")
#' @import dplyr
#' @export
disaster_month <- function(data, location, country) {
  # validate input data columns
  if (!all(c("Start Year", "Start Month", "Location", "Country") %in% colnames(data))) {
    stop("Input data must contain columns: 'Start Year', 'Start Month', 'Location', 'Country'.")
  }
  
  # filter by location and country
  location_data <- data |>
    dplyr::filter(location %in% Location & country == Country)
  
  # if input is invalid
  if (nrow(location_data) == 0) {
    stop("No data available for location: ", location, " and country: ", country,". \nPlease enter another location.")
  }
  
  # identify month with the highest disaster starts in each year
  peak_month_one_year <- location_data |>
    dplyr::group_by(`Start Year`, `Start Month`) |>
    dplyr::summarise(disaster_count = dplyr::n()) |>
    dplyr::slice_max(disaster_count) |>
    dplyr::ungroup() |>
    dplyr::count(`Start Month`, name = "num_year") # count how many times/year a month is peak
  
  
  # identify month with the most counts of disaster starts through years
  peak_month_all_time <- peak_month_one_year |>
    dplyr::slice_max(num_year) |> #still a df, have to convert to numeric to use month.abb()
    dplyr::pull(`Start Month`) # now numeric
  
  
  min_year <- min(location_data$`Start Year`)
  max_year <- max(location_data$`Start Year`)
  span <- max_year - min_year
  
  if (length(peak_month_all_time) == 1) {
    month_names <- month.abb[peak_month_all_time]
    cat("In the last", span, "years, the month most frequently having the largest number of disaster starts in", location, "is:", 
        month_names, "with a count of", max(peak_month_one_year$num_year), "times.\n")
  } else {
    month_names <- month.abb[peak_month_all_time]
    formatted_month_names <- paste(month_names, collapse = " and ")
    cat("In the last", span, "years, the months most frequently having the largest number of disaster starts in", location, "are:", 
        formatted_month_names, "with a count of", max(peak_month_one_year$num_year), "times.\n")
  }
 
  # plot the frequency of each month
  ggplot2::ggplot(peak_month_one_year, ggplot2::aes(x = factor(`Start Month`, 
                                                      levels = 1:12, 
                                                      labels = month.abb), 
                                           y = num_year)) +
    ggplot2::geom_bar(stat = "identity", fill = "skyblue") +
    ggplot2::labs(
      title = paste("Frequency of peak disaster start months in", location, "-", country),
      x = "Month",
      y = "Frequency of being peak month"
    ) +
    ggplot2::theme_minimal()
}
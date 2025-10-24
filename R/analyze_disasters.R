#' Analyze Disaster Impacts
#'
#' @description
#' Summarizes and visualizes disaster impacts (e.g., deaths, injuries, affected populations)
#' for a given disaster type and year.
#'
#' @param data A data frame containing disaster data. Defaults to \code{emdat_world}.
#' @param disaster_type The type of disaster to analyze (e.g., "Flood").
#' @param year The year to filter the data.
#' @param output Output type: \code{"summary"}, \code{"plot"}, or \code{"both"}. Defaults to \code{"both"}.
#'
#' @return A ggplot object or a summary table, depending on the \code{output} argument.
#'
#' #' @examples
#' library(ggplot2)
#' library(dplyr)
#' 
#' example_data <- data.frame(
#'   disaster_type = c("Flood", "Flood", "Earthquake"),
#'   start_year = c(2020, 2020, 2021),
#'   total_deaths = c(100, 50, 200),
#'   no_injured = c(300, 150, 400),
#'   total_affected = c(1000, 800, 2000)
#' )
#' analyze_disasters(example_data, "Flood", 2020, "plot")
#'
#' ![Flood Impacts](man/figures/analyze_disaster_flood_2000.png)
#'
#' @importFrom ggplot2 ggplot aes geom_bar labs theme_minimal scale_y_continuous
#' @importFrom dplyr filter mutate summarise
#' @importFrom tidyr pivot_longer
#' @importFrom scales comma
#' @export

analyze_disasters <- function(data = emdat_world, disaster_type, year, output = c("both", "summary", "plot")) {
  output <- match.arg(output)
  
  # Check for missing or invalid inputs
  if (missing(disaster_type) || missing(year)) {
    stop("Please provide both 'disaster_type' and 'year'.")
  }
  
  # Check for required columns
  if (!"disaster_type" %in% colnames(data) || !"start_year" %in% colnames(data) ||
      !"total_deaths" %in% colnames(data) || !"no_injured" %in% colnames(data) || !"total_affected" %in% colnames(data)) {
    stop("The dataset must contain columns: 'disaster_type', 'start_year', 'total_deaths', 'no_injured', and 'total_affected'.")
  }
  
  # Filter and clean data
  data <- data %>%
    filter(disaster_type == !!disaster_type, start_year == !!year) %>%
    mutate(
      total_deaths = ifelse(is.na(total_deaths), 0, total_deaths),
      no_injured = ifelse(is.na(no_injured), 0, no_injured),
      total_affected = ifelse(is.na(total_affected), 0, total_affected)
    ) #Here !! so that R treats it as a regular R object rather than directly tying it to a column
  
  if (nrow(data) == 0) {
    warning("No disasters found for the specified type and year.")
    return(NULL)
  }
  
  # Summarize the data
  summary <- data %>%
    summarise(
      Total_Deaths = sum(total_deaths, na.rm = TRUE),
      Total_Injured = sum(no_injured, na.rm = TRUE),
      Total_Affected = sum(total_affected, na.rm = TRUE)
    )
  
  # Pivot the data
  summary_long <- tidyr::pivot_longer(
    summary,
    cols = everything(),
    names_to = "Impact",
    values_to = "Count"
  )
  
  # Bar plot
  bar_plot <- ggplot(summary_long, aes(x = Impact, y = Count, fill = Impact)) +
    geom_bar(stat = "identity") +
    scale_y_continuous(trans = "log10", labels = scales::comma) +
    labs(
      title = paste("Impact of", disaster_type, "in", year),
      x = "Impact Type",
      y = "Count (Log Scale)"
    ) +
    theme_minimal()
  
  # Return based on user preference
  if (output == "summary") {
    return(summary)
  } else if (output == "plot") {
    return(bar_plot)
  } else {
    return(list(Summary = summary, Plot = bar_plot))
  }
}

# Suppress global variable warnings
utils::globalVariables(c("total_deaths", "no_injured", "total_affected", "Impact", "Count"))

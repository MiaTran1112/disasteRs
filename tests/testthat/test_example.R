# tests/testthat/test-example.R

library(testthat)
library(dplyr)

# Made up data with same structure as EMDAT data for testing Mia's function
data <- tibble::tibble(
  `Start Year` = c(2020, 2021, 2022, 2023),
  `Start Month` = c(1, 2, 3, 4),
  Location = c("Seoul", "Hanoi", "Northampton", "Amsterdam"),
  Country = c("Republic of Korea", "Viet Nam", "United States of America", "Netherlands")
)

# Test for Mia's disaster_month() function
# Test that the function throws an error when no data is available for the given location and country
test_that("disaster_month throws error for invalid location/country", {
  expect_error(disaster_month(data, "Tokyo", "Japan"), 
               "No data available for location: Tokyo and country: Japan. \nPlease enter another location.")
})

# Test that the function throws an error when there is a missing column(s)
test_that("disaster_month throws error for missing columns", {
  incomplete_data <- data |> 
    select(-`Start Year`) # Remove a required column
  expect_error(disaster_month(incomplete_data, "Seoul", "Republic of Korea"),
               "Input data must contain columns: 'Start Year', 'Start Month', 'Location', 'Country'.")
})

# Test that the function works for valid inputs
test_that("disaster_month works with valid input", {
  expect_no_error(disaster_month(data, "Hanoi", "Viet Nam"))
})

# Mock EM-DAT data for Chi's function testing
emdat <- tibble::tibble(
  disaster_type = c("Flood", "Earthquake", "Flood", "Typhoon"),
  start_year = c(2020, 2020, 2021, 2021),
  country = c("Vietnam", "Indonesia", "Thailand", "Philippines")
)

test_that("plot_disaster_map_sea returns a ggplot object for valid inputs", {
  result <- plot_disaster_map_sea("Flood", 2020)
  expect_s3_class(result, "ggplot") # Ensure the result is a ggplot object
})

test_that("plot_disaster_map_sea throws error for missing required columns", {
  incomplete_emdat <- emdat |> 
    select(-disaster_type) 
  expect_error(
    {
      emdat <<- incomplete_emdat 
      plot_disaster_map_sea("Flood", 2020)
    },
    "Input data must contain columns: 'disaster_type', 'start_year', 'country'."
  )
})

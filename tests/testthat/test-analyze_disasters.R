library(testthat)

# Test for valid inputs
test_that("analyze_disasters returns correct summary output", {
  test_data <- data.frame(
    disaster_type = c("Flood", "Storm"),
    start_year = c(2000, 2000),
    total_deaths = c(100, 50),
    no_injured = c(20, 30),
    total_affected = c(1000, 500)
  )
  result <- analyze_disasters(test_data, "Flood", 2000, "summary")
  expect_equal(result$Total_Deaths, 100)
  expect_equal(result$Total_Injured, 20)
  expect_equal(result$Total_Affected, 1000)
})

# Test for empty dataset
test_that("analyze_disasters handles empty filtered datasets", {
  test_data <- data.frame(
    disaster_type = c("Flood", "Storm"),
    start_year = c(1999, 1998),
    total_deaths = c(NA, NA),
    no_injured = c(NA, NA),
    total_affected = c(NA, NA)
  )
  result <- analyze_disasters(test_data, "Earthquake", 2005, "summary")
  expect_null(result)
})

# Test for missing inputs
test_that("analyze_disasters errors on missing inputs", {
  test_data <- data.frame(
    disaster_type = c("Flood", "Storm"),
    start_year = c(2000, 2001),
    total_deaths = c(100, 50),
    no_injured = c(20, 30),
    total_affected = c(1000, 500)
  )
  expect_error(analyze_disasters(test_data, year = 2000, output = "summary"))
})

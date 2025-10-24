#' Emdat World Dataset
#'
#' A dataset containing information about global disaster events. 
#' The dataset includes details on the location, country, year of occurrence, 
#' and type of disaster.
#'
#' @docType data
#' @usage data(emdat_world)
#' @format A data frame with the following columns:
#' \describe{
#'   \item{\code{Location}}{The name of the region where the disaster occurred (e.g., region name).}
#'   \item{\code{Country}}{The country where the region is located (e.g., country name).}
#'   \item{\code{Year}}{The year the disaster occurred.}
#'   \item{\code{Start Year}}{The year the disaster event began.}
#'   \item{\code{Disaster Type}}{The type of disaster that occurred (e.g., drought, flood, earthquake).}
#' }
#' @source \url{https://public.emdat.be/}

#' @title Create, Update, and Read the Directory Configuration File
#' 
#' @description The directory configuration file is a special file within the portalcasting directory setup and has its own set of functions. \cr \cr
#'              \code{write_directory_config} creates the YAML metadata configuration file. It is (and should only be) called from within \code{\link{setup_dir}}, as it captures information about the compute environment used to instantiate the directory. \cr \cr
#'              \code{read_directory_config} reads the YAML config file into the R session.
#'
#' @param quiet \code{logical} indicator if progress messages should be quieted.
#'
#' @param verbose \code{logical} indicator of whether or not to print out all of the information (and thus just the tidy messages).
#'
#' @param main \code{character} value of the name of the main component of the directory tree. Default value (\code{"."}) puts the forecasting directory in the present locations. Nesting the forecasting directory in a folder can be done by simply adding to the \code{main} input (see \code{Examples}).
#'
#' @param settings \code{list} of controls for the directory, with defaults set in \code{\link{directory_settings}} that should generally not need to be altered.
#'
#' @return \code{list} of directory configurations, \code{\link[base]{invisible}}-ly.
#'
#' @name directory_configuration_file
#'
NULL

#' @rdname directory_configuration_file
#'
#' @export
#'
write_directory_config <- function (main     = ".", 
                                    settings = directory_settings(), 
                                    quiet    = FALSE){

  config <- list(setup = list(date                  = as.character(Sys.Date()),
                              R_version             = sessionInfo()$R.version,
                              portalcasting_version = packageDescription("portalcasting", fields = "Version")),
                 tree  = list(main                  = main, 
                              subs                  = settings$subs),
                 raw   = settings$raw)

  write_yaml(x    = config, 
             file = file.path(main, settings$files$directory_config))

  invisible(config)

}



#' @rdname directory_configuration_file
#'
#' @export
#'
read_directory_config <- function (main     = ".", 
                                   settings = directory_settings(), 
                                   quiet    = FALSE){
  
  config <- tryCatch(
              read_yaml(file.path(main, settings$files$directory_config)),
              error = function(x){NA}, warning = function(x){NA})
  
  if (length(config) == 1 && is.na(config)) {

    stop("Directory configuration file is corrupted or missing")

  }

  invisible(config)

}


#' @rdname directory_configuration_file
#'
#' @export
#'
update_directory_config <- function (main     = ".", 
                                     settings = directory_settings(), 
                                     quiet    = FALSE,
                                     verbose  = FALSE){
  
  config <- read_directory_config(main     = main, 
                                  settings = settings,
                                  quiet    = quiet)

  # fix this so it grabs the actual values when `latest`

  config$raw$PortalData_version       <- settings$resources$PortalData$version
  config$raw$archive_version          <- ifnull(settings$resources$portalPredictions$version, "")
  config$raw$climate_forecast_version <- settings$resources$climate_forecast$version

  if (config$raw$PortalData_version == "latest") {

    config$raw$PortalData_version <- scan(file  = file.path(main, settings$subs$resources, "PortalData", "version.txt"),
                                          what  = "character", 
                                          quiet = !verbose)

  }

  write_yaml(x    = config, 
             file = file.path(main, settings$files$directory_config))

  invisible(config)

}


% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/directory_configuration_file.R
\name{directory_configuration_file}
\alias{directory_configuration_file}
\alias{write_directory_config}
\alias{read_directory_config}
\alias{update_directory_config}
\title{Create, Update, and Read the Directory Configuration File}
\usage{
write_directory_config(
  main = ".",
  settings = directory_settings(),
  quiet = FALSE
)

read_directory_config(
  main = ".",
  settings = directory_settings(),
  quiet = FALSE
)

update_directory_config(
  main = ".",
  settings = directory_settings(),
  quiet = FALSE,
  verbose = FALSE
)
}
\arguments{
\item{main}{\code{character} value of the name of the main component of the directory tree. Default value (\code{"."}) puts the forecasting directory in the present locations. Nesting the forecasting directory in a folder can be done by simply adding to the \code{main} input (see \code{Examples}).}

\item{settings}{\code{list} of controls for the directory, with defaults set in \code{\link{directory_settings}} that should generally not need to be altered.}

\item{quiet}{\code{logical} indicator if progress messages should be quieted.}

\item{verbose}{\code{logical} indicator of whether or not to print out all of the information (and thus just the tidy messages).}
}
\value{
\code{list} of directory configurations, \code{\link[base]{invisible}}-ly.
}
\description{
The directory configuration file is a special file within the portalcasting directory setup and has its own set of functions. \cr \cr
             \code{write_directory_config} creates the YAML metadata configuration file. It is (and should only be) called from within \code{\link{setup_dir}}, as it captures information about the compute environment used to instantiate the directory. \cr \cr
             \code{read_directory_config} reads the YAML config file into the R session.
}

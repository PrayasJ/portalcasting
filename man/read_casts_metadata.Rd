% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data_input_output.R
\name{read_casts_metadata}
\alias{read_casts_metadata}
\title{Read in the Casts Metadata File}
\usage{
read_casts_metadata(main = ".", settings = directory_settings(), quiet = FALSE)
}
\arguments{
\item{main}{\code{character} value of the name of the main component of the directory tree.}

\item{settings}{\code{list} of controls for the directory, with defaults set in \code{\link{directory_settings}} that should generally not need to be altered.}

\item{quiet}{\code{logical} indicator if progress messages should be quieted.}
}
\value{
Data requested.
}
\description{
Read in the casts metadata file. If the data file does not exist, an effort is made to create the file.
}

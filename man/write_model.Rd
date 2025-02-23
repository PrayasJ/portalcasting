% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/prepare_models.R
\name{write_model}
\alias{write_model}
\alias{model_template}
\title{Write Model Function Script into Directory}
\usage{
write_model(
  main = ".",
  model = NULL,
  settings = directory_settings(),
  quiet = FALSE,
  verbose = FALSE
)

model_template(
  main = ".",
  model = NULL,
  datasets = NULL,
  settings = directory_settings(),
  quiet = FALSE,
  verbose = FALSE
)
}
\arguments{
\item{main}{\code{character} value of the name of the main component of the directory tree.}

\item{model}{\code{character} name of a model function, the \code{function} itself, or its symbol (backquoted name).}

\item{settings}{\code{list} of controls for the directory, with defaults set in \code{\link{directory_settings}} that should generally not need to be altered.}

\item{quiet}{\code{logical} indicator if progress messages should be quieted.}

\item{verbose}{\code{logical} indicator of whether or not to print out all of the information (and thus just the tidy messages).}

\item{datasets}{\code{character} vector of dataset names for the model.}
}
\value{
\code{write_mode} \code{\link{write}}s the model script out and returns \code{NULL}, \code{\link[base]{invisible}}-ly.. \cr \cr
 \code{model_template}: \code{character}-valued text for a model script to be housed in the model directory. \cr \cr
 \code{control_list_arg}: \code{character}-valued text for part of a model script. \cr \cr
}
\description{
Writes a model's function as a script into the defined directory for use in forecasting. \cr \cr \code{model} can be input as a \code{character} string, symbol (backquoted name), or \code{function}, as \code{\link{match.fun}}
}
\examples{
 \donttest{
  create_dir()
  write_model("AutoArima")
  model_template()
  control_list_arg(runjags_control(nchains = 3), "runjags_control")
 }

}

% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/prepare_moons.R
\name{prepare moons}
\alias{prepare moons}
\alias{prep_moons}
\alias{add_future_moons}
\alias{forecast_future_moons}
\title{Prepare Lunar Data for the Portalcasting Repository}
\usage{
prep_moons(
  main = ".",
  lead = 365,
  origin = Sys.Date(),
  settings = directory_settings(),
  quiet = TRUE,
  verbose = FALSE
)

add_future_moons(
  main = ".",
  moons = NULL,
  lead = 365,
  origin = Sys.Date(),
  settings = directory_settings()
)

forecast_future_moons(moons = NULL, lead = 365, origin = Sys.Date())
}
\arguments{
\item{main}{\code{character} value of the name of the main component of the directory tree.}

\item{lead}{\code{integer} (or integer \code{numeric}) value for the number of days forward a cast will cover.}

\item{origin}{\code{Date} forecast origin, typically today's date (set using \code{\link{Sys.Date}}).}

\item{settings}{\code{list} of controls for the directory, with defaults set in \code{\link{directory_settings}} that should generally not need to be altered.}

\item{quiet}{\code{logical} indicator controlling if messages are printed.}

\item{verbose}{\code{logical} indicator of whether or not to print out all of the information or not (and thus just the tidy messages).}

\item{moons}{\code{data.frame} of moon data.}
}
\value{
Some version of a moons \code{data.frame}. \cr \cr. 
        \code{prep_moons}: fully appended and formatted \code{data.frame} (also saved out if \code{save = TRUE}). \cr 
        \code{add_future_moons}: fully appended and formatted \code{data.frame}. \cr 
        \code{forecast_future_moons}: moons \code{data.frame} to append to the existing \code{moons}.
}
\description{
Get time information (calendar dates, census periods, and newmoon numbers) associated with trapping events (achieved and missed) based on a lunar survey schedule. If needed, additional moons will be added to both the in-use and resources versions of the data table. \cr \cr
             \code{add_future_moons} adds future moon dates to the moon table, counting forward from \code{cast_date}. Because the \code{moons} table might not have the most recent moons, more rows than \code{lead} may need to be added to the table. \cr \cr. 
             \code{get_cast_future_moons} wraps around \code{\link[portalr]{get_future_moons}} to include any additional moons needed to achieve the full \code{lead} from \code{cast_date}. \cr \cr
}
\details{
Sometimes the resources moon data table is not fully up-to-date. Because the \code{portalr} functions \code{\link[portalr]{weather}} and \code{\link[portalr]{fcast_ndvi}} point to the resources moons data, that table needs to be updated to produce the correct current data table for casting.
}
\examples{
 \donttest{
  setup_dir()
  prep_moons()
 }

}


#' @title Measure Error and Fit Metrics for Forecasts
#' 
#' @description Summarize the cast-level errors or fits to the observations. \cr 
#'  Presently included are root mean square error and coverage.
#' 
#' @param cast_tab A \code{data.frame} of a cast's output. See \code{\link{read_cast_tab}}.
#'
#' @return \code{data.frame} of metrics for each cast for each species. 
#'
#' @export
#'
measure_cast_level_error <- function (cast_tab = NULL) {


  return_if_null(cast_tab)

  ucast_ids <- unique(cast_tab$cast_id)
  ncast_ids <- length(ucast_ids)
  uspecies  <- unique(cast_tab$species)
  nspecies  <- length(uspecies)
  RMSE      <- rep(NA, ncast_ids * nspecies)
  coverage  <- rep(NA, ncast_ids * nspecies)
  model     <- rep(NA, ncast_ids * nspecies)
  counter   <- 1

  for (i in 1:ncast_ids) {

    for (j in 1:nspecies) {

      ij          <- cast_tab$cast_id == ucast_ids[i] & cast_tab$species == uspecies[j]
      cast_tab_ij <- cast_tab[ij, ]
      err         <- cast_tab_ij$err

      if (!is.null(err)) {

        RMSE[counter] <- sqrt(mean(err^2, na.rm = TRUE))

      }

      covered <- cast_tab_ij$covered

      if (!is.null(covered)) {

        coverage[counter] <- mean(covered, na.rm = TRUE)            

      }

      if (length(cast_tab_ij$model) > 0) {

        model[counter] <- unique(cast_tab_ij$model)

      }

      counter <- counter + 1

    }

  }

  ids <- rep(ucast_ids, each = nspecies)
  spp <- rep(uspecies, ncast_ids)

  data.frame(cast_id  = ids, 
             species  = spp, 
             model    = model, 
             RMSE     = RMSE, 
             coverage = coverage)
}

#' @title Add the Associated Values to a Cast Tab
#' 
#' @description Add values to a cast's cast tab. If necessary components are missing (such as no observations added yet and the user requests errors), the missing components are added. \cr \cr
#'  \code{add_lead_to_cast_tab} adds a column of lead times. \cr \cr
#'  \code{add_obs_to_cast_tab} appends a column of observations. \cr \cr
#'  \code{add_err_to_cast_tab} adds a column of raw error values. \cr \cr
#'  \code{add_covered_to_cast_tab} appends a \code{logical} column indicating if the observation was within the prediction interval. 
#'
#' @details If a model interpolated a data set, \code{add_obs_to_cast_tab} adds the true (non-interpolated) observations so that model predictions are all compared to the same data.
#'
#' @param main \code{character} value of the name of the main component of the directory tree.
#' 
#' @param cast_tab A \code{data.frame} of a cast's output. See \code{\link{read_cast_tab}}.
#'
#' @param settings \code{list} of controls for the directory, with defaults set in \code{\link{directory_settings}} that should generally not need to be altered.
#'
#' @return \code{data.frame} of \code{cast_tab} with an additional column or columns if needed. 
#'
#' @name add to cast tab
#'
#' @export
#'
add_lead_to_cast_tab <- function (main     = ".", 
                                  settings = directory_settings(), 
                                  cast_tab = NULL) {

  return_if_null(cast_tab)
  cast_tab$lead <- cast_tab$moon - cast_tab$end_moon
  cast_tab

}

#' @rdname add-to-cast-tab
#'
#' @export
#'
add_err_to_cast_tab <- function (main     = ".", 
                                 settings = directory_settings(), 
                                 cast_tab = NULL) {


  return_if_null(cast_tab)
  if (is.null(cast_tab$obs)) {

    cast_tab <- add_obs_to_cast_tab(main     = main,
                                    settings = settings,
                                    cast_tab = cast_tab)
  }

  cast_tab$error <- cast_tab$estimate - cast_tab$obs
  cast_tab

}

#' @rdname add-to-cast-tab
#'
#' @export
#'
add_covered_to_cast_tab <- function (main     = ".", 
                                     settings = directory_settings(), 
                                     cast_tab = NULL) {


  return_if_null(cast_tab)
  if (is.null(cast_tab$obs)) {

    cast_tab <- add_obs_to_cast_tab(main     = main,
                                    settings = settings,
                                    cast_tab = cast_tab)

  }

  cast_tab$covered <- cast_tab$obs >= cast_tab$lower_pi & cast_tab$obs <= cast_tab$upper_pi 
  cast_tab$covered[is.na(cast_tab$obs)] <- NA
  cast_tab

}

#' @rdname add-to-cast-tab
#'
#' @export
#'
add_obs_to_cast_tab <- function (main     = ".", 
                                 settings = directory_settings(),
                                 cast_tab = NULL) {

  return_if_null(cast_tab)

  # patch
  colnames(cast_tab)[colnames(cast_tab) == "data_set"] <- "dataset"
  # patch

  cast_tab$obs   <- NA
  cast_dataset   <- gsub("_interp", "", cast_tab$dataset)
  ucast_dataset  <- unique(cast_dataset)
  ncast_datasets <- length(ucast_dataset)

  for (j in 1:ncast_datasets) {

    obs <- read_rodents_table(main           = main, 
                              settings       = settings,
                              dataset = ucast_dataset[j])


    matches <- which(cast_dataset == ucast_dataset[j])
    nmatches <- length(matches)
    obs_cols <- gsub("NA.", "NA", colnames(obs))

    for (i in 1:nmatches) {

      spot        <- matches[i]
      obs_moon    <- which(obs$newmoonnumber == cast_tab$moon[spot])
      obs_species <- which(obs_cols == cast_tab$species[spot])

      if (length(obs_moon) == 1 & length(obs_species) == 1) {

        cast_tab$obs[spot] <- obs[obs_moon, obs_species]

      }

    }

  }

  cast_tab 

}



#' @title Read in Cast Output From a Given Cast
#'
#' @description Read in the various output files of a cast or casts in the casts sub directory. 
#'
#' @param main \code{character} value of the name of the main component of the directory tree.
#'
#' @param cast_ids,cast_id \code{integer} (or integer \code{numeric}) value(s) representing the cast(s) of interest, as indexed within the directory in the \code{casts} sub folder. See the casts metadata file (\code{casts_metadata.csv}) for summary information. If \code{NULL} (the default), the most recently generated cast's output is read in. \cr 
#'  \code{cast_ids} can be NULL, one value, or more than one values, \code{cast_id} can only be NULL or one value.
#'
#' @param settings \code{list} of controls for the directory, with defaults set in \code{\link{directory_settings}} that should generally not need to be altered.
#'
#' @return 
#'  \code{read_cast_tab}: \code{data.frame} of the \code{cast_tab}. \cr \cr
#'  \code{read_cast_tabs}: \code{data.frame} of the \code{cast_tab}s with a \code{cast_id} column added to distinguish among casts. \cr \cr
#'  \code{read_cast_metadata}: \code{list} of \code{cast_metadata}. \cr \cr
#'  \code{read_model_fit}: a model fit \code{list}. \cr \cr
#'  \code{read_model_cast}: a model cast \code{list}.
#'
#' @name read cast output
#'
#' @export
#'
read_cast_tab <- function (main     = ".", 
                           cast_id  = NULL, 
                           settings = directory_settings()) {

  if (is.null(cast_id) ){

    casts_meta <- select_casts(main     = main,
                               settings = settings)
    cast_id    <- max(casts_meta$cast_id)

  }

  lpath <- paste0("cast_id_", cast_id, "_cast_tab.csv")
  cpath <- file.path(main, settings$subs$forecasts, lpath)

  if (!file.exists(cpath)) {

    stop("cast_id does not have a cast_table")

  }

  out <- read.csv(cpath) 


  # patch
  colnames(out)[colnames(out) %in% c("data_set", "dataset")] <- "dataset"
  # patch

  # patch
  out$dataset <- gsub("_interp", "", out$dataset)
  # patch

  na_conformer(out)

}

#' @rdname read-cast-output
#'
#' @export
#'
read_cast_tabs <- function (main     = ".", 
                            cast_ids  = NULL, 
                            settings = directory_settings()) {
  
  if (is.null(cast_ids)) {

    casts_meta <- select_casts(main     = main,
                               settings = settings)
    cast_ids   <- max(casts_meta$cast_id)

  }

  cast_tab <- read_cast_tab(main     = main,
                            cast_id  = cast_ids[1],
                            settings = settings)
  ncasts   <- length(cast_ids)


  if (ncasts > 1) {

    for (i in 2:ncasts) {

      cast_tab_i <- read_cast_tab(main     = main,
                                  cast_id  = cast_ids[i], 
                                  settings = settings)

      cast_tab   <- rbind(cast_tab, cast_tab_i)

    }

  }

  cast_tab

}

#' @rdname read-cast-output
#'
#' @export
#'
read_cast_metadata <- function (main     = ".", 
                                cast_id  = NULL, 
                                settings = directory_settings()) {
  
  if (is.null(cast_id)) {

    casts_meta <- select_casts(main = main)
    cast_id    <- max(casts_meta$cast_id)

  }

  lpath <- paste0("cast_id_", cast_id, "_metadata.yaml")
  cpath <- file.path(main, settings$subs$forecasts, lpath)

  if (!file.exists(cpath)) {

    stop("cast_id does not have a cast_metadata file")

  }

  read_yaml(cpath, eval.expr = TRUE) 

}


#' @rdname read-cast-output
#'
#' @export
#'
read_model_fit <- function (main     = ".", 
                            cast_id  = NULL, 
                            settings = directory_settings()) {
  
  if (is.null(cast_id)) {

    casts_meta <- select_casts(main     = main,
                               settings = settings)
    cast_id <- max(casts_meta$cast_id)

  }

  lpath <- paste0("cast_id_", cast_id, "_model_fits.json")
  cpath <- file.path(main, settings$subs$fits, lpath)

  if (!file.exists(cpath)) {

    stop("cast_id does not have a model_fits file")

  }

  read_in_json <- fromJSON(readLines(cpath))
  unserializeJSON(read_in_json)

}

#' @rdname read-cast-output
#'
#' @export
#'
read_model_cast <- function (main     = ".", 
                             cast_id  = NULL, 
                             settings = directory_settings()) {
  
  if (is.null(cast_id)) {

    casts_meta <- select_casts(main     = main,
                               settings = settings)
    cast_id <- max(casts_meta$cast_id)

  }

  lpath_json  <- paste0("cast_id_", cast_id, "_model_casts.json")
  cpath_json  <- file.path(main, settings$subs$forecasts, lpath_json)

  lpath_RData <- paste0("cast_id_", cast_id, "_model_casts.RData")
  cpath_RData  <- file.path(main, settings$subs$forecasts, lpath_RData)

  if (!file.exists(cpath_json)) {

    if (!file.exists(cpath_RData)) {

      stop("cast_id does not have a model_casts file")
  
    } else {

      model_casts <- NULL
      load(cpath_RData)
      model_casts

    }

  } else {

    read_in_json <- fromJSON(readLines(cpath_json))
    unserializeJSON(read_in_json)

  }

}


#' @title Find Casts that Fit Specifications
#'
#' @description Determines the casts that match user specifications. \cr
#'  Functionally, a wrapper on \code{\link{read_casts_metadata}} with filtering for specifications that provides a simple user interface to the large set of available casts via the metadata. 
#'
#' @param main \code{character} value of the name of the main component of the directory tree.
#'
#' @param cast_ids \code{integer} (or integer \code{numeric}) values representing the casts of interest, as indexed within the directory in the \code{casts} sub folder. See the casts metadata file (\code{casts_metadata.csv}) for summary information.
#'
#' @param end_moons \code{integer} (or integer \code{numeric}) newmoon numbers of the forecast origin. Default value is \code{NULL}, which equates to no selection with respect to \code{end_moon}.
#'
#' @param cast_groups \code{integer} (or integer \code{numeric}) value of the cast group to combine with an ensemble. If \code{NULL} (default), the most recent cast group is ensembled. 
#'
#' @param models \code{character} values of the names of the models to include. Default value is \code{NULL}, which equates to no selection with respect to \code{model}.
#'
#' @param datasets \code{character} values of the rodent data sets to include Default value is \code{NULL}, which equates to no selection with respect to \code{dataset}.
#'
#' @param quiet \code{logical} indicator if progress messages should be quieted.
#'
#' @param settings \code{list} of controls for the directory, with defaults set in \code{\link{directory_settings}} that should generally not need to be altered.
#'
#' @return \code{data.frame} of the \code{cast_tab}.
#'
#' @export
#'
select_casts <- function (main           = ".", 
                          settings       = directory_settings(), 
                          cast_ids       = NULL, 
                          cast_groups    = NULL,
                          end_moons      = NULL, 
                          models         = NULL, 
                          datasets       = NULL,
                          quiet          = FALSE) {


  casts_metadata <- read_casts_metadata(main     = main,
                                        settings = settings,
                                        quiet    = quiet)

  ucast_ids <- unique(casts_metadata$cast_id[casts_metadata$QAQC])
  cast_ids  <- ifnull(cast_ids, ucast_ids)
  match_id  <- casts_metadata$cast_id %in% cast_ids

  ucast_groups <- unique(casts_metadata$cast_group[casts_metadata$QAQC])
  cast_groups  <- ifnull(cast_groups, ucast_groups)
  match_group  <- casts_metadata$cast_group %in% cast_groups

  uend_moons     <- unique(casts_metadata$end_moon[casts_metadata$QAQC])
  end_moons      <- ifnull(end_moons, uend_moons)
  match_end_moon <- casts_metadata$end_moon %in% end_moons

  umodels     <- unique(casts_metadata$model[casts_metadata$QAQC])
  models      <- ifnull(models, umodels)
  match_model <- casts_metadata$model %in% models
  
  udatasets <- gsub("_interp", "", unique(casts_metadata$dataset[casts_metadata$QAQC]))
  datasets  <- ifnull(datasets, udatasets)

  match_dataset <- gsub("_interp", "", casts_metadata$dataset) %in% datasets
  
  QAQC <- casts_metadata$QAQC

  casts_metadata[match_id & match_end_moon & match_model & match_dataset & QAQC, ]

}



#' @title Save Cast Output to Files
#'
#' @description Save out any output from a cast of a model for a data set and update the cast metadata file accordingly to track the saved output. \cr
#'  Most users will want to at least save out model metadata and a table of predictions.
#'
#' @param cast Output from a model function (e.g., \code{\link{AutoArima}}) run on any rodents data set. Required to be a \code{list}, but otherwise has minimal strict requirements. \cr
#'  Names of the elements of the list (such as \code{"metadat"}) indicate the specific saving procedures that happens to each of them. See \code{Details} section for specifics. 
#'
#' @details Currently, four generalized output components are recognized and indicated by the names of the elements of \code{cast}. 
#'  \itemize{
#'   \item \code{"metadata"}: saved out with \code{\link[yaml]{write_yaml}}. Will
#'    typically be the model-specific metadata from the 
#'    \code{data/metadata.yaml} file, but can more generally be any 
#'    appropriate object (typically a \code{list}).  
#'   \item \code{"cast_tab"}: saved using \code{\link{write.csv}}, so is
#'    assumed to be a table such as a \code{matrix} or \code{data.frame} 
#'    or coercible to one. Used to summarize the output across instances
#'    of the model (across multiple species, for example). 
#'   \item \code{"model_fits"}: saved out as a serialized \code{JSON} file 
#'    via \code{\link[jsonlite]{serializeJSON}} and 
#'    \code{\link[jsonlite:read_json]{write_json}}, so quite flexible with respect to 
#'    specific object structure. Saving out a \code{list} of the actual model
#'    fit/return objects means that models do not need to be refit later.
#'   \item \code{"model_casts"}: saved out as a serialized \code{JSON} file 
#'    via \code{\link[jsonlite]{serializeJSON}} and 
#'    \code{\link[jsonlite:read_json]{write_json}}, so quite flexible with respect to 
#'    specific object structure. Is used to save \code{list}s
#'    of predictions across multiple instances of the model.
#'  }
#'
#' @param main \code{character} value of the name of the main component of the directory tree.
#'
#' @param settings \code{list} of controls for the directory, with defaults set in \code{\link{directory_settings}} that should generally not need to be altered.
#'
#' @param quiet \code{logical} indicator if progress messages should be quieted.
#'
#' @return Relevant elements are saved to external files, and \code{NULL} is returned.
#'
#' @examples
#'  \donttest{
#'   setup_dir() 
#'   out <- AutoArima()
#'   save_cast_output(out)
#'  }
#'
#' @export
#'
save_cast_output <- function (cast     = NULL, 
                              main     = ".", 
                              settings = directory_settings(), 
                              quiet    = FALSE) {

  cast_meta <- read_casts_metadata(main     = main, 
                                   settings = settings,
                                   quiet    = quiet)
  cast_ids  <- cast_meta$cast_id

  if (all(is.na(cast_ids))) {

    next_cast_id <- 1

  } else {

    next_cast_id <- max(cast_ids) + 1

  }

  dir_config    <- cast$metadata$directory_configuration
  pc_version    <- dir_config$setup$portalcasting_version
  new_cast_meta <- data.frame(cast_id               = next_cast_id,
                              cast_group            = cast$metadata$cast_group,
                              cast_date             = cast$metadata$time$cast_date,
                              start_moon            = cast$metadata$time$start_moon,
                              end_moon              = cast$metadata$time$end_moon,
                              lead_time             = cast$metadata$time$lead_time,
                              model                 = cast$metadata$models,
                              dataset               = gsub("_interp", "", cast$metadata$datasets),
                              portalcasting_version = pc_version,
                              QAQC                  = TRUE,
                              notes                 = NA)
  cast_meta     <- rbind(cast_meta, new_cast_meta)
  meta_path     <- file.path(main, settings$subs$forecasts, "casts_metadata.csv")
 
  write.csv(cast_meta, meta_path, row.names = FALSE)

  if (!is.null(cast$metadata)) {

    meta_filename <- paste0("cast_id_", next_cast_id, "_metadata.yaml")
    meta_path     <- file.path(main, settings$subs$forecasts, meta_filename)

    write_yaml(x    = cast$metadata,
               file = meta_path)

  }

  if (!is.null(cast$cast_tab)) {

    cast_tab_filename         <- paste0("cast_id_", next_cast_id, "_cast_tab.csv") 
    cast_tab_path             <- file.path(main, settings$subs$forecasts, cast_tab_filename)
    cast_tab                  <- cast$cast_tab
    cast_tab$cast_id          <- next_cast_id

    write.csv(x         = cast_tab,
              file      = cast_tab_path, 
              row.names = FALSE)

  }

  if (!is.null(cast$model_fits)) {

    model_fits_filename <- paste0("cast_id_", next_cast_id, "_model_fits.json") 
    model_fits_path     <- file.path(main, settings$subs$fits, model_fits_filename)
    model_fits          <- cast$model_fits
    model_fits          <- serializeJSON(model_fits)

    write_json(x    = model_fits, 
               path = model_fits_path)

  }

  if (!is.null(cast$model_casts)) {

    model_casts_filename <- paste0("cast_id_", next_cast_id, "_model_casts.json") 
    model_casts_path     <- file.path(main, settings$subs$forecasts, model_casts_filename)
    model_casts          <- cast$model_casts
    model_casts          <- serializeJSON(model_casts)

    write_json(x    = model_casts, 
               path = model_casts_path)

  }

  invisible()

}




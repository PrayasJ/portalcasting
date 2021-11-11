# Supporting [automated forecasting](https://github.com/weecology/portalPredictions) of [rodent populations](https://portal.weecology.org/)
[![R-CMD-check-release](https://github.com/weecology/portalcasting/actions/workflows/check-release.yaml/badge.svg)](https://github.com/weecology/portalcasting/actions/workflows/check-release.yaml)
[![Docker](https://img.shields.io/docker/cloud/build/weecology/portalcasting.svg)](https://hub.docker.com/repository/docker/weecology/portalcasting)
[![Codecov test coverage](https://img.shields.io/codecov/c/github/weecology/portalcasting/master.svg)](https://codecov.io/github/weecology/portalcasting/branch/master)
[![Lifecycle:maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)
[![License](http://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/weecology/portalPredictions/master/LICENSE)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3332973.svg)](https://doi.org/10.5281/zenodo.3332973)
[![NSF-1929730](https://img.shields.io/badge/NSF-1929730-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1929730)


<img src="man/figures/portalcasting.png" width="200px">   

## Overview

The `portalcasting` package contains the functions used for continuous analysis and forecasting of [Portal rodent populations](https://portal.weecology.org/) ([code repository](https://github.com/weecology/portalPredictions), [output website](http://portal.naturecast.org/), [Zenodo archive](https://doi.org/10.5281/zenodo.833438)).

`portalcasting`'s functions are also portable, allowing users to set up a fully-functional replica repository on a local or remote machine. This facilitates development and testing of new models
via a [sandbox](https://en.wikipedia.org/wiki/Sandbox_(software_development)) approach. 

## Status: Deployed, Active Development

The `portalcasting` package is deployed for use within the [Portal Predictions repository](https://github.com/weecology/portalPredictions), providing the underlying R code to populate the directory with up-to-date data, analyze the data, produce new forecasts, generate new output figures, and render a new version of the [website](http://portal.naturecast.org/). All of the code underlying the forecasting functionality has been migrated 
over from the [predictions repository](https://github.com/weecology/portalPredictions), which contains the code executed by the continuous integration. Having relocated the code here, the `portalcasting` package is the location for active development of the model set and additional functionality. 

We leverage a [software container](https://en.wikipedia.org/wiki/Operating-system-level_virtualization) to enable reproducibility of the [predictions repository](https://github.com/weecology/portalPredictions). Presently, we use a [Docker](https://hub.docker.com/r/weecology/portalcasting) image of the software environment to create a container for running the code. The image is automatically rebuilt when there is a new `portalcasting` release, tagged with both the `latest` and version-specific (`vX.X.X`) tags, and pushed to [DockerHub](https://hub.docker.com/r/weecology/portalcasting). 


Because the `latest` image is updated with releases, the current master branch code in `portalcasting` is not necessarily always being executed within the [predictions repository](https://github.com/weecology/portalPredictions). Rather, the most recent release is what is currently being executed. Presently, the `latest` image is built using `portalcasting` [v0.24.0](https://github.com/weecology/portalcasting/releases/tag/v0.24.0).

A development image (`dev`) is built from the master branch of `portalcasting` at every push to facilitate testing and should not be considered stable.

The API is moderately well defined at this point, but is still evolving.

## Installation

You can install the R package from github:

```r
install.packages("devtools")
devtools::install_github("weecology/portalcasting")
```

## Production environment

If you wish to spin up a local container from the `latest` `portalcasting` image (to ensure that you are using a copy of the current production environment for implementation of the `portalcasting` pipeline), you can run

```
sudo docker pull weecology/portalcasting
```
from a shell on a computer with [Docker](https://www.docker.com/) installed. A tutorial on using the image to spin up a container is forthcoming. 

## Usage

Get started with the ["how to set up a Portal Predictions directory" vignette](https://weecology.github.io/portalcasting/articles/getting_started.html)

If you are interested in adding a model to the preloaded [set of models](https://weecology.github.io/portalcasting/articles/current_models.html), see the ["adding a model" vignette](https://weecology.github.io/portalcasting/articles/adding_model_and_data.html). 

## Acknowledgements 

The motivating study—the Portal Project—has been funded nearly continuously since 1977 by the [National Science Foundation](http://nsf.gov/), most recently by [DEB-1622425](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1622425) to S. K. M. Ernest. Much of the computational work was supported by the [Gordon and Betty Moore Foundation’s Data-Driven Discovery Initiative](http://www.moore.org/programs/science/data-driven-discovery) through [Grant GBMF4563](http://www.moore.org/grants/list/GBMF4563) to E. P. White. 

We thank Henry Senyondo for help with continuous integration, Heather Bradley for logistical support, John Abatzoglou for assistance with climate forecasts, and James Brown for establishing the Portal Project. 

## Author Contributions

All authors conceived the ideas, designed methodology, and developed the automated forecasting system. J. L. Simonis led the transition of code from the [Portal Predictions repo](https://github.com/weecology/portalPredictions) to `portalcasting`. S. K. M. Ernest coded the `NaiveArima` model, H. Ye coded the `simplexEDM` model, and J. L. Simonis coded the `jags_RW` model.

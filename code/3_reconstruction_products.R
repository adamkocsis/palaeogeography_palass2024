# Part III. Static reconstruction products.
# 2024-12-10, Erlangen
# Ádám T. Kocsis & Elizabeth Downding

library(rgplates)
library(chronosphere)
library(terra)
library(via)

setwd("/mnt/sky/Dropbox/Teaching/Workshops/2024-12-09_rgplates_palass/palaeogeography_palass2024/")

#' Plot maps with smaller margins
#'
#' The default plotting margins of sf are somewhat large.
#'
#' @param ... Arguments passed to the plot() function
mplot <- function(...){
	par(mar=c(0.25,0.25,0.25,0.25))
	plot(...)
}

# the edge of the map
edge <- mapedge()

# The data objects depend on a specific version of a tectonic model.
# They are also made for specific reconstruction dates, that dictate the ages of point-reconstruction.
################################################################################
# A) Topographic reconstruction

# The Paleomap PaleoDEMs. These will be downloaded from Zenodo into the temporary directory.
dats <- chronosphere::datasets()

# the most up-to dat version
dems <- chronosphere::fetch(src="paleomap", ser="dem")
dems

# download them to project directory
dir.create("data/chronosphere", showWarnings=FALSE)

# the dems
dems <- chronosphere::fetch(src="paleomap", ser="dem", datadir="data/chronosphere")

# available ages
names(dems)

# accessing one, e.g. 90 Ma
# the values are expected averages for 5 Ma
# Sea-level changes much more rapidly.
# Scotese pers. comm (2023): expect +- 200m of sea level change!
plot(dems["90"])

# and offline version of the paleomap model
mod <- chronosphere::fetch("paleomap", "model",datadir="data/chronosphere")
mod

# if GPlates is installed, these files can be used for reconstruction in rgplates!
# the 'model' argument is a 'platemodel' object
plates90 <- rgplates::reconstruct("static_polygons", age=90, model=mod)

# overlay
plot(dems["90"])
plot(plates90$geometry, col="#FF000077", add=TRUE)


################################################################################
# B. The Emsian Trilobites
# The trilobite data
trilobites <- read.csv("data/PaleoDB/devonian_trilobites.csv", skip=15)

# The Emsian subset
emsian <- trilobites[which(trilobites$time_contain=="Emsian"), ]

# The collections
emsianCollections <- unique(emsian[, c("collection_no", "lng", "lat")])

# the mid of the Emsian is 400.45-the closest DEM is 400Ma.
# the paleocoordinates
paleoCoords <- rgplates::reconstruct(emsianCollections[, c("lng", "lat")], age=400, model=mod)

# coordinates
plot(dems["400"])
points(paleoCoords, pch=3, col="red")

################################################################################
# C) Other products work similarly
pmData <- chronosphere::datasets("paleomap")

# Paleomap paleocoastlines
pc <- chronosphere::fetch("paleomap", "paleocoastlines", datadir="data/chronosphere")
pc

# margin: 1400m isobath of DEMs
# coast: 0m isobath of DEMs
mplot(pc["65","margin"], col="#87cef6", border=NA)
mplot(pc["65","coast"], col="#94391c", border=NA, add=TRUE)

################################################################################
# D) Example climate model data

# 1) Original HadCM3L climate model output e.g. Valdes et al. 2021 (uses PALEOMAP model)
# https://research-information.bris.ac.uk/ws/portalfiles/portal/301051066/Full_text_PDF_final_published_version_.pdf
# -> https://www.paleo.bristol.ac.uk/ummodel/scripts/papers/Valdes_et_al_2021.html
# -> https://www.paleo.bristol.ac.uk/ummodel/users/Valdes_et_al_2021/new2/

# These are based on the PaleoDEM tectonic reconstructions, and are tied to 5Ma-interval reconstrutions!
# They are on their way to the chronosphere.


# 2) Post-processsed (all use the PALEOMAP model)
# a) Original HadCML3 mean annual precipitation (mm/day) resampled to 1x1degree resolution
precipitation <- chronosphere::fetch("paleomap", "rainfall", datadir="data/chronosphere")
precipitation
plot(precipitation["65"])

# b) Based on Valdes, et al. 2021 corrected by C. Scotese, 2021
# with lithological information (Annual mean air surface temperatures)
airTemps <- chronosphere::fetch("paleomap", "gmst", datadir="data/chronosphere")
airTemps


# 3) Resampled mean annual Sea surface temperatures (extrapolated to match
# the paleomap paleocoastlines) from Kocsis et al. 2021
tosExtrapolated<- chronosphere::fetch("SOM-kocsis-provinciality", datadir="data/chronosphere")
tosExtrapolated

# Extracting values
plot(tosExtrapolated["400"])

# collection data in emsianCollections - 400Ma, Paleomap model
paleoCoords <- rgplates::reconstruct(emsianCollections[, c("lng", "lat")], age=400, model=mod)
points(paleoCoords, col="red", pch=3)

# extract data from raster
tos <- terra::extract(tosExtrapolated["400"], paleoCoords)

# all combined
emsianAll <- cbind(emsianCollections, paleoCoords,tos)

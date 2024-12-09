# Part I. Exploring tectonic models with 'rgplates' (and plotting with sf)
# 2024-12-10, Erlangen
# Ádám T. Kocsis & Elizabeth Downding

# Attaching necessary extension packages
library(rgplates) # 0.5.0 - you will also need the 'httr2' and the 'geojsonsf' packages!

# setting working directory (or use `here`, if you like it)
setwd("/mnt/sky/Dropbox/Teaching/Workshops/2024-12-09_rgplates_palass/palaeogeography_palass2024")

########################################----------------------------------------
# A. Reconstruction of plates (using the GPlates Web Service) and plotting maps

# The partitioning polygons as they are, default model=MERDITH2021
# https://doi.org/10.1016/j.earscirev.2020.103477
# x: feature collection to reconstruct
# age: target age in Ma
poly <- rgplates::reconstruct(x="static_polygons", age=0)
poly

# plotting
plot(poly$geometry) # default margins are a bit big...

#' Plot maps with smaller margins
#'
#' The default plotting margins of sf are somewhat large.
#'
#' @param ... Arguments passed to the plot() function
mplot <- function(...){
	par(mar=c(0.25,0.25,0.25,0.25))
	plot(...)
}

# the same with smaller margins
mplot(poly$geometry) # default margins are a bit big...

# A deep-time reconstruction
plates200 <- rgplates::reconstruct("static_polygons", age=200)
mplot(plates200$geometry, col="gray", border=NA)

# present day boundaries on top
moderncoast200 <- rgplates::reconstruct("coastlines", age=200)
moderncoast200
mplot(moderncoast200$geometry, add=TRUE)

# ymin is not going to -90!
sf::st_bbox(plates200)

# background to plot the whole Earth
edge <- rgplates::mapedge()

# the whole thing together
mplot(edge, col="#1A6BB0")
mplot(plates200$geometry, col="white", border=NA, add=TRUE)
mplot(moderncoast200$geometry, col="gray80", add=TRUE, border=NA)


########################################----------------------------------------
# Exercise:
# Make a similar plot of the "static_polygons" and the "coastlines"
# for 66 million years ago!

################################################################################
# B. Comparing different models

# list of available models and feature collections
data(gws, package="rgplates")
View(gws)

########################################----------------------------------------
# Exercise:
# Plot the positions of the modern "coastlines"
# for 60 million years ago using the Paleomap model!

########################################----------------------------------------

# Overlaying two models MERDITH2021 vs. MULLER2022
# MULLER2022: (https://doi.org/10.5194/se-13-1127-2022)
plates400 <- rgplates::reconstruct("static_polygons", age=400)
plates400mu <- rgplates::reconstruct("static_polygons", age=400, model="MULLER2022")

# A comparison
mplot(edge)
mplot(plates400$geometry, col="#33358A88", border=NA, add=TRUE)
mplot(plates400mu$geometry, col="#69072088", add=TRUE, border=NA)


# Saving it as a png-file
dir.create("export", showWarnings=FALSE)
png("export/me-mu400.png", height=700, width=1400)
	mplot(edge)
	mplot(plates400$geometry, col="#33358A88", border=NA, add=TRUE)
	mplot(plates400mu$geometry, col="#69072088", add=TRUE, border=NA)
dev.off()

# With a bit of sf :)
sf::sf_use_s2(FALSE)
dir.create("export", showWarnings=FALSE)
png("export/me-mu400_unified.png", height=700, width=1400)
	mplot(edge)
	mplot(sf::st_union(sf::st_make_valid(plates400$geometry)), col="#33358A88", border=NA, add=TRUE)
	mplot(sf::st_union(sf::st_make_valid(plates400mu$geometry)), col="#69072088", add=TRUE, border=NA)
dev.off()

sf::sf_use_s2(TRUE)

################################################################################
# C. Some more customization

# Using the Merdith2021 model
mplot(edge)
mplot(plates400$geometry, col="#94391cAA", border=NA, add=TRUE)

# zoom into an area of interest
# locator(2)
mplot(edge, xlim=c(-115,-9), ylim=c(-50, 17))
mplot(plates400$geometry, col="#94391cAA", border=NA, add=TRUE)

# change the projection using sf::st_transform
# Requires a projection identifier, either
# - EPSG ID -> https://epsg.io
# - The long WKT (Well-Known Text) format
# - PROJ.4 string

# The Mollweide projection
epsg <- "ESRI:54009"

# the edge of the map
edgeProj <- sf::st_transform(edge, epsg)

# the plates
plates400Proj <- sf::st_transform(plates400, epsg)

# the same in mollweide
mplot(edgeProj)
mplot(plates400Proj$geometry, col="#94391c", border=NA, add=TRUE)


########################################----------------------------------------
# Home Exercise:
# Plot A map for the Triassic-Jurassic boundary (199.5Ma)
# using the Torsivk and Cocks (2017) model, in Robinson projection!
########################################----------------------------------------



# Part II. Point data and fossil localities
# 2024-12-10, Erlangen
# Ádám T. Kocsis

# Attaching necessary extension packages
library(rgplates) # 0.5.0 - you will also need the 'httr2' and the 'geojsonsf' packages to be installed!

# setting working directory (or use `here`, if you like that)
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

################################################################################
# A. Simple point reconstruction

# Example points
erlangen <- c(10.97, 49.58)
sydney <- c(151.19, -33.86)
cities <- rbind(erlangen,sydney)

# On the present day map
coast <- reconstruct("coastlines", age=0)
mplot(edge, col="gray", border=NA)
mplot(coast$geometry, col="white", border=NA, add=TRUE)
points(cities, col="red", pch=3)
mplot(edge, border="gray", add=TRUE)

# In deep time
plates300 <- reconstruct("static_polygons", age=300)

# x = a matrix of longitude-latitude coordinates
cities300 <- reconstruct(cities, age=300)

# an example plot
mplot(edge, col="gray", border=NA)
mplot(plates300$geometry, col="white", border=NA, add=TRUE)
points(cities300, col="red", pch=3)
mplot(edge, border="gray", add=TRUE)


################################################################################
# B. Fossil occurrences from the Paleobiology Database (Emsian stage)

# Example data (Devonian Trilobites from the Paleobiology Database: Liz's favorites!)
# https://paleobiodb.org/data1.2/occs/list.csv?datainfo&base_name=Trilobita&interval=Devonian&show=coords,timecompare
trilobites <- read.csv("data/PaleoDB/devonian_trilobites.csv", skip=15)

# time bins (ensuring that interval is in GTS stage!)
table(trilobites$time_contain)

# The Emsian subset
emsian <- trilobites[which(trilobites$time_contain=="Emsian"), ]

# According to the most recent ICS chart (https://stratigraphy.org/ICSchart/ChronostratChart2023-09.pdf)
# the Emsian has a range of more than 10 million years: 407.6 - 393.3 Ma

# We need to assume that all of these occurrences come from the same age.
# The simplest assumption is that this is the mid of the stage.
# This will be the target age of our reconstruction.
targetAge <- (407.6+393.3)/2

# The reconstruction to put things on (Using the Merdith et al model)
platesEmsian <- reconstruct("static_polygons", age=targetAge)

# The geography is tied to the collections, not the occurrences.
# It is fastest to do reconstruction only on the collections
emsianCollections <- unique(emsian[, c("collection_no", "lng", "lat")])

# the paleocoordinates
paleoCoords <- reconstruct(emsianCollections[, c("lng", "lat")], age=targetAge)

# added to the collection table
emsianCollections <- cbind(emsianCollections, paleoCoords)

# a plot
mplot(edge, col="gray", border=NA)
mplot(platesEmsian$geometry, col="white", border=NA, add=TRUE)
points(paleoCoords, col="red", pch=3)
mplot(edge, border="gray", add=TRUE)

# missing values are there because 'validtime=TRUE'!

# Data can be merged back with occurrences for statistical analyses
emsianMerged <- merge(
	emsian, # the occurrences
	emsianCollections[, c("collection_no", "paleolong", "paleolat")], # the necessary collection information
	by="collection_no",
	all=TRUE)



################################################################################
# C. Repeating the same for all stages of the Devonian.
# Goals:
# - Get paleocoordinates for these time-binned data.
# - Plot the collections that come from a time bin on the map that corresponds to it.

# We need the midpoints of the stages, which you can get in many different ways (packages, datasets, etc).
# If all else fails you can grab them from the ICS chart like this:
	#https://stratigraphy.org/ICSchart/ChronostratChart2023-09.pdf

	# the ages of the Devonian are
	bounds <- c(
		419.2, # bottom of the Devonian
		410.8,
		407.6,
		393.3,
		387.7,
		382.7,
		372.2,
		358.9 # bottom of the Carboniferous
	)

	# the names of the stages (on less then the bounds!)
	stageName <- c(
		"Lochkovian",
		"Pragian",
		"Emsian",
		"Eifelian",
		"Givetian",
		"Frasnian",
		"Famennian"
	)

	# the devonian ages
	bottom <- bounds[2:length(bounds)-1]
	top <- bounds[2:length(bounds)]

	# the middle of the age
	mid <- (top+bottom)/2
	names(mid) <- stageName


# 1. Plates
# We need all the plate reconstructions for these target ages.
# The age argumnet of reconstruct() is vectorized and will produce a list.
lPlates <- reconstruct("static_polygons", age=mid)

# result: a list of plate reconstructions
str(lPlates)


# 2. collections
# For efficiency: extract collection-level information again. Needed:
# - which collection?
# - where is it?
# - when was it deposited?
collections <- unique(trilobites[, c("collection_no", "lng", "lat", "time_contain")])

# the mid ages of the stages
collections$map <- mid[collections$time_contain]
table(collections$map)

# omit those collections where we had no good enough stratigraphy: i.e. no map assigned
collections <- collections[!is.na(collections$map),]

# Reconstructing the points:
# Every row in the collections table refer to one collections, so the geographic
# and stratigraphic information is aligned. Such 'pairwise' [(long-lat) - age] age
# reconstructions can be done with the `enumerate=FALSE` option
paleoCoordinates <- reconstruct(
	x=collections[, c("lng","lat")],
	age=collections$map,
	enumerate=FALSE
)

# add to the collection table (can be merged back to the occurrence records)
collections <- cbind(collections, paleoCoordinates)

# Plotting
dir.create("export", showWarnings=FALSE)
pdf("export/devonianTrilobites_merdith2021.pdf", width=14, height=7)

# for every stage
for(i in 1:length(mid)){

	# current Age
	curr <- mid[i]

	# plot the plates -order here matches that of mid!
	mplot(edge, col="gray", border=NA)
	mplot(lPlates[[i]]$geometry, col="white", border=NA, add=TRUE)

	# the current set of collections
	currentColls <- collections[which(collections$map==curr), ]
	points(currentColls[, c("paleolong","paleolat")], col="red", pch=3)

	# the boundary again
	mplot(edge, border="gray", add=TRUE)

	# a label for the plot
	label <- paste0(names(mid)[i], " stage, ", curr, "Ma")
	mtext(3, line=-1, text=label)


}

dev.off()

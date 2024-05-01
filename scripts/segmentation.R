library(link2GI)
library(terra)
library(listviewer)

# Connect to OTB
otblink <- link2GI::linkOTB()

# Define project root directory
projRootDir <- 'intermediaries'

# Path to input file
fn <- system.file("inputs/optical.tif", package = "terra")

# Algorithm keyword
algoKeyword <- "Segmentation"

# Function to run OTB segmentation
runSegment <- function(spatRadius, spatRange) {
  # Extract command list for the chosen algorithm 
  cmd <- parseOTBFunction(algo = algoKeyword, gili = otblink)
  
  # View help using listviewer
  listviewer::jsonedit(cmd$help)
  
  # Define mandatory arguments, with other arguments set to defaults
  cmd$input <- fn
  cmd$filter <- "meanshift"
  cmd$filter.meanshift.spatialr <- spatRadius
  cmd$filter.meanshift.ranger <- spatRange
  cmd$mode.vector.outmode <- "ulco"
  cmd$mode.vector.out <- file.path(projRootDir, paste0("sr_", spatRadius, "rr_", spatRange, ".shp"))
  
  # Check if output directory exists, if not, create it
  if (!dir.exists(projRootDir)) {
    dir.create(projRootDir)
  }
  
  # Run algorithm
  retStack <- runOTB(cmd, gili = otblink)
}

# Spatial radius and range values
spatRadius <- c(1, 40, 80)
spatRange <- c(1, 40, 80)

# Loop through spatial radius and range values
for (i in 1:length(spatRadius)) {
  radius <- spatRadius[i]
  range <- spatRange[i]
  
  # Run segmentation for current radius and range
  runSegment(radius, range)
}


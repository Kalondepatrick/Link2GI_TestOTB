library(link2GI)
library(terra)
library(listviewer)

# Connect to OTB
otblink <- link2GI::linkOTB()
projRootDir <- 'tmp'

# Check if output directory exists, if not, create it
if (!dir.exists(projRootDir)) {
  dir.create(projRootDir)
}


# Path to input file
fn <- system.file("inputs/optical.tif", package = "terra") 
#fn <- system.file("ex/logo.tif", package = "terra")

# Algorithm keyword
algoKeyword <- "Segmentation"

spatRadius = 20
spatRange = 20
# Function to run OTB segmentation

# Extract command list for the chosen algorithm 
cmd <- parseOTBFunction(algo = algoKeyword, gili = otblink)

# Define mandatory arguments, with other arguments set to defaults
#cmd$help  # drop the help entries
cmd$input_in <- fn   # NOTE it is nNOT input but input_in
cmd$filter <- "meanshift"
cmd$filter.meanshift.spatialr <- spatRadius
cmd$filter.meanshift.ranger <- spatRange
cmd$mode.vector.outmode <- "ulco"
cmd$mode.vector.out <- file.path(projRootDir, paste0("sr_", spatRadius, "rr_", spatRange, ".shp"))

# Run algorithm
retStack <- runOTB(cmd, gili = otblink)

plot (retStack)


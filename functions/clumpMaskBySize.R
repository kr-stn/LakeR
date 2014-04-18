clumpMaskBySize <- function (image, name, directory, size){
  ################### Detect clumps in a binary mask #######################
  ## Function:
  ## Detect clumps in an image and mask out every group of pixels smaller
  ## than a given threshold. Can be used to define a minimum size for
  ## automated lake detection.
  ##
  ## Author:
  ## Kersten Clauss
  ## kersten.clauss@gmail.com
  ##
  ## Arguments:
  ## image      - path to binary mask that can be imported with raster()
  ## name			  - name for the masked output image
  ## directory  - directory for output of masked image
  ## size       - threshold for keeping clumps (min. number of clumped pixels)
  ##########################################################################
  
  library(raster)
  library(igraph)
  
  IMAGE <- raster(image)
  
  ## clump image, directions is the number of adjoining pixels (see ?clump)
  IMAGE.clumped <- clump(IMAGE, directions=8, gaps=F)
  
  ## create frequency matrix of clump IDs
  clump.table <- table(getValues(IMAGE.clumped))
  clump.mat <- as.matrix(clump.table)
  
  ## find IDs of all clumps bigger than given size value
  ID.big.clumps <- which(clump.mat >= size)
  
  ## mask out smaller clumps, make mask binary and write image
  IMAGE.clumped.big <- match(IMAGE.clumped, ID.big.clumps, nomatch=0)
  IMAGE.clumped.big.rcl <- reclassify (IMAGE.clumped.big, rcl=c (-Inf,0,0,1,Inf,1))
  writeRaster(IMAGE.clumped.big.rcl, paste(directory, name, sep="/"), format="GTiff")
}
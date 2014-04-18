maskNDWILandsatQuan <- function (image, name, directory, training, quant){
  ################### Create a Binary NDWI Mask ############################
  ## Function:
  ## Create a binary Mask of an NDWI Image. The Threshold is calculated
  ## from the given quantile of a defined training site.
  ##
  ## Author:
  ## Kersten Clauss
  ## kersten.clauss@gmail.com
  ##
  ## Arguments:
  ## image      - path to NDWI raster image
  ## name			  - name for the masked image
  ## directory  - directory for output of masked image
  ## training	  - extent of a training site (known water area) as coordinate
  ##              vector
  ## quant      - quantile from which the threshold is determined
  ##########################################################################
  
  library(raster)
  library(rgdal)
  
  NDWI <- raster(image)
  TRAIN <- crop(NDWI, training) #crop according to coordinate vector
  
  quan.low <- quantile(TRAIN, probs=quant) #determine quantile
  thrs <- quan.low[1] #set as threshold
  
  classes <- matrix (c (-Inf,thrs,0,thrs,Inf,1),2,3,byrow=T) #matrix for reclassification
  
  WATER <- reclassify (NDWI, rcl=classes) #reclassify according to threshold; below ->0, above ->1
  writeRaster(WATER, paste(directory, name, sep="/"), format="GTiff") #write masked image
}

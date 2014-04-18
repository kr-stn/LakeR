maskNDWILandsat <- function (directory, name, green, nir, threshold=0.25){
################### Create a Binary NDWI Mask ############################
## Function:
## Calculate the Normalized Difference Water Index from Landsat 4/5 TM
## Bands, where each Band is represented as a single .tif.
##
## Author:
## Kersten Clauss
## kersten.clauss@gmail.com
##
## Arguments:
## directory	- directory for output of masked image
## name			- name for the masked image
## green		- Image containing the Green Band
##					(e.g. D:/scene1/LT51380402006138BKT00_B2.tif)
## nir			- Image containing the Near Infrared Band
##					(e.g. D:/scene1/LT51380402006138BKT00_B4.tif)
## threshold	- Threshold for Water classification
##########################################################################

  library(raster)
  library(rgdal)
  
  NDWI <- (raster(green) - raster(nir)) / (raster(green) + raster(nir)) #normalized difference water index calculation
  
  thrs <- threshold #threshold for reclassification
  classes <- matrix (c (-Inf,thrs,0,thrs,Inf,1),2,3,byrow=T) #matrix for reclassification
  
  WATER <- reclassify (NDWI, rcl=classes) #reclassify according to threshold; below ->0, above ->1
  writeRaster(WATER, paste(directory, name, sep="/"), format="GTiff") #write masked image
}
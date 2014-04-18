NDWILandsat <- function (directory, name, green, nir){
  ################### Create a NDWI Layer ############################
  ## Function:
  ## Calculate the Normalized Difference Water Index from Landsat 4/5
  ## TM Bands, where each Band is represented as a single GeoTiff.
  ##
  ## Author:
  ## Kersten Clauss
  ## kersten.clauss@gmail.com
  ##
  ## Arguments:
  ## directory  - directory for output of NDWI image
  ## name			- name for the output NDWI image
  ## green		- GeoTiff containing the Green Band
  ##					(e.g. D:/scene1/LT51380402006138BKT00_B2.tif)
  ## nir			- GeoTiff containing the Near Infrared Band
  ##					(e.g. D:/scene1/LT51380402006138BKT00_B4.tif)
  ##########################################################################
  
  library(raster)
  library(rgdal)
  
  NDWI <- (raster(green) - raster(nir)) / (raster(green) + raster(nir)) #normalized difference water index calculation
  
  writeRaster(NDWI, paste(directory, name, sep="/"), format="GTiff") #write NDWI image
}
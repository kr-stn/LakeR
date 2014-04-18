dn2RadianceLandsat <- function (directory, mtl){
########## Convert Digital Number to Radiance ############################
## Function:
## Convert Landsat 4/5 TM Images from Digital Number Pixel Values to
## Radiance Pixel Values and store them into a new subdirectory
## "radiance/". The Thermal Band is excluded.
##
## Author:
## Kersten Clauss
## kersten.clauss@gmail.com
##
## Arguments:
## directory	- directory containing the Landsat Images by Band
##					(e.g. /Scene1/LT51380402006138BKT00_B1.tif)
## mtl			- location of the Metadata file
##					(e.g. /Scene1/LT51380402006138BKT00_MTL.txt)
##########################################################################  
  
  library(raster)
  library(rgdal)

  setwd(directory)
  
  metadata <- readIniFile(mtl) #import *MTL.txt
  metadata <- metadata[,-1] #remove empty first column
  metadata[,2] <- gsub('\"', "", metadata[,2]) #remove backspaces (replace with nothing)
  
  ## create a vector containing all .tif-image filenames
  Images <- list.files(directory, pattern="(.tif)")
  
  ##delete Thermal Image from Vector
  Images <- Images[-grep("B6", Images)]

  
  ## create new subdirectory, if it allready exists a warning will be displayed, but the script continues
  directory.radiance <- paste(directory,"/radiance/",sep="")
  dir.create(file.path(directory.radiance))

  GainBand <- c() #create empty vector to store Gain for each band
  
  ## calculate gain for each band
  for (i in 1:length(Images)){
	Max <- paste("RADIANCE_MAXIMUM_BAND_", i, sep="")
	Min <- paste("RADIANCE_MINIMUM_BAND_", i, sep="")
	GainBand[i] <- (as.numeric(metadata[metadata[,1]==Max,2]) - as.numeric(metadata[metadata[,1]==Min,2])) / 255
    }

  ## calculate radiance for each image/band and export to subdirectory
  for (i in 1:length(Images)){
    Min <- paste("RADIANCE_MINIMUM_BAND_", i, sep="")
    Image.radiance <- GainBand[i] * raster(Images[i]) + as.numeric(metadata[metadata[,1]==Min,2])
    writeRaster(Image.radiance, paste(directory.radiance, Images[i], sep=""), format="GTiff") #write converted image into subdirectory
  } 
}

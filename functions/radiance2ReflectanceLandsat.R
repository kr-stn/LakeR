radiance2ReflectanceLandsat <- function (directory, mtl){
############# Convert Radiance to Reflectance ############################
## Function:
## Convert Landsat 4/5 TM Images from Radiance Pixel Values to Reflectance
## Pixel Values and store them into a new subdirectory "radiance/".
##
## Author:
## Kersten Clauss
## kersten.clauss@gmail.com
##
## Arguments:
## directory	- directory containing the Landsat Images by Band
##					(e.g. /radiance/LT51380402006138BKT00_B1.tif)
## mtl			- location of the Metadata file	
##					(e.g. /Scene1/LT51380402006138BKT00_MTL.txt)
##########################################################################

  library(raster)
  library(rgdal)
  library(landsat)
  
  setwd(directory)

  metadata <- readIniFile(mtl) #import *MTL.txt
  metadata <- metadata[,-1] #remove empty first column
  metadata[,2] <- gsub('\"', "", metadata[,2]) #remove backspaces (replace with nothing)
  
  ## create a vector containing all .tif-image filenames 
  Images <- list.files(directory, pattern="(.tif)") 
  
  ## create new subdirectory, if it allready exists a warning will be displayed, but the script continues
  directory.reflectance <- paste(directory,"/reflectance/",sep="")
  dir.create(file.path(directory.reflectance))
  
  ## calibration data according to Landsat Handbook
  esun1 <- 1969
  esun2 <- 1840
  esun3 <- 1551
  esun4 <- 1044
  esun5 <- 255.7
  esun7 <- 82.07
  esun.all <- c(esun1, esun2, esun3, esun4, esun5, esun7) #create ESUN vector
  
  distance.sun <- 1.0158 #Earth Sun Distance in AU
  
  ## calculate the solar zenith angle
  sea <- as.numeric(metadata[metadata[,1]=="SUN_ELEVATION",2]) #get sun elevation from metadata
  sza <- (90 - sea) / 180 * pi
  
  ## calculate reflectance for each band and write converted images
  for (i in 1:length(Images)){
    Image.reflectance <- (pi * raster(Images[i]) * distance.sun^2) / (esun.all[i] * cos(sza))
    writeRaster(Image.reflectance, paste(directory.reflectance, Images[i], sep=""), format="GTiff") #write converted image into subdirectory
   }
}
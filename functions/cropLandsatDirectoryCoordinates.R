cropLandsatDirectoryCoordinates <- function (directory, target){
  ########## Crop a Directory of Landsat Images ############################
  ## Function:
  ## Takes a directory of Landsat images, where each band is represented
  ## by a single .tif. Each image is cropped according to provided coordinates
  ## and saved in a new sub-directory dubbed "cropped/" with
  ## untouched filenames.
  ##
  ## Author:
  ## Kersten Clauss
  ## kersten.clauss@gmail.com
  ## 
  ## Arguments:
  ## directory  - Directory containing the Landsat Images by Band
  ##					(e.g. /Scene1/LT51380402006138BKT00_B1.tif,...)
  ## target		- Vector containing 4 coordinates (in UTM for Landsat)
  ##          (c(xmin, xmax, ymin, ymax) e.g. c(437175, 458775, 3076905, 3089715))
  ##########################################################################
  
  library(raster)
  library(rgdal)
  
  setwd(directory)
  ## create vector containing all image filenames
  Images <- dir(directory, pattern="(.TIF)") #edit the pattern (case sensitive!) if you want to exclude/include images

  ## create the subdirectory
  directory.cropped <- paste(directory,"/cropped/", sep="")
  dir.create(file.path(directory.cropped))
  
  for (i in 1:length(Images)){
    Image.cropped <- crop (raster(Images[i]), target) #crop images
    writeRaster(Image.cropped, paste(directory.cropped, Images[i], sep="")) #write into subdirectory, keep original name
  }
}
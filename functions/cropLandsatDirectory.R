cropLandsatDirectory <- function (directory, target){
  ########## Crop a Directory of Landsat Images ############################
  ## Function:
  ## Takes a directory of Landsat images, where each band is represented
  ## by a single .tif. Each image is cropped according to a given (cropped)
  ## image and saved in a new sub-directory dubbed "cropped/" with
  ## untouched filenames.
  ##
  ## Author:
  ## Kersten Clauss
  ## kersten.clauss@gmail.com
  ## 
  ## Arguments:
  ## directory  - Directory containing the Landsat Images by Band
  ##					(e.g. /Scene1/LT51380402006138BKT00_B1.tif,...)
  ## target		- any object containing geospaial information that
  ##					works with extent(e.g. /Scene1/cropped.tif)
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
    Image.cropped <- crop (raster(Images[i]), extent (raster(target))) #crop image
    writeRaster(Image.cropped, paste(directory.cropped, Images[i], sep="")) #write into subdirectory, keep original name
  }
}
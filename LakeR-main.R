########## Automated Landsat Preprocessing and NDWI-Masking ##############
## Function:
## Take a Folder with Subfolders of Landsat Scenes, Calculate Top of
## Athmosphere Reflectance and create a binary lake mask.
##
## Author:
## Kersten Clauss
## kersten.clauss@gmail.com
##
## Motivation:
## Use Free and Open Source Software to Process Free to Obtain
## Satellite Data. Create a Glacier Lake Inventory or Analyze Lake
## Growth with Minimal Investment of Time and Money.
##########################################################################

##########Config##########
##########################
# Provide Folder locations
# (be carefull with omitting trailing "/")
# directory of the functions
directory.script <- "/Volumes/Landsat/script/functions/"
#
# directory of the Landsat4/5 TM Scenes (LT7 currently not supported)
directory.landsat <- "/Volumes/Landsat/scenes/"
#
# cropped GeoTIFF as target for cropping process (cropping scenes before processing increases speed dramatically)
crop.target <- "/Volumes/Landsat/scenes/crop-example.tif"
#
# target coordinates for cropping with coordinates
crop.target.coords <- c(437175, 458775, 3076905, 3089715) #e.g. Tsho Rolpa Nepal
#
# threshhold for binary NDWI Mask
NDWI.threshold <- 0.25
#
# extent coordinates of training site (known water)
NDWI.training <- c(447975, 448275, 3082275, 3082485) #e.g. Tsho Rolpa Nepal
#
# minimum size for clump detection (=min. amount of adjoining pixels for lake classification)
clump.size <- 50
##########################
##########################

## download and install required packages
install.packages("raster")
install.packages("rgdal")
install.packages("landsat")
install.packages("igraph")
library(raster)
library(rgdal)
library(landsat)
library(igraph)

## load scripts
source(paste(directory.script, "cropLandsatDirectory.R", sep=""))
source(paste(directory.script, "cropLandsatDirectoryCoordinates.R", sep=""))
source(paste(directory.script, "dn2RadianceLandsat.R", sep=""))
source(paste(directory.script, "radiance2ReflectanceLandsat.R", sep=""))
source(paste(directory.script, "maskNDWILandsat.R", sep=""))
source(paste(directory.script, "NDWILandsat.R", sep=""))
source(paste(directory.script, "maskNDWILandsatQuan.R", sep=""))
source(paste(directory.script, "clumpMaskBySize.R", sep=""))

########## end of configuration / start of processing ##########

## create vector containing all subdirectories (NOT recursive)
directory.landsat.all <- list.dirs(path=directory.landsat, full.names=T, recursive=F)

## create name vector from landsat.directory.all
directory.landsat.all.unlist <- unlist(strsplit(directory.landsat.all, "\\/"))
directory.landsat.name <- directory.landsat.all.unlist[grep("LT", directory.landsat.all.unlist)]

## crop all bands in all folders according to given example
for (i in 1:length(directory.landsat.all))
{cropLandsatDirectory(directory=paste(directory.landsat.all[i],"/", sep=""), target=crop.target)}

## crop all bands in all folders according to given coordinates
for (i in 1:length(directory.landsat.all))
{cropLandsatDirectoryCoordinates(directory=paste(directory.landsat.all[i],"/", sep=""), target=crop.target.coords)}

## create vector containing all metadata files
metafiles <- list.files(path=directory.landsat.all, full.names=T, recursive=T, pattern="(MTL.txt)")

## calculate radiances from cropped images with according metadata
for (i in 1:length(directory.landsat.all))
{dn2RadianceLandsat(directory=paste(directory.landsat.all[i], "/cropped/", sep=""), mtl=metafiles[i])}

## calculate reflectance from radiances
for (i in 1:length(directory.landsat.all))
{radiance2ReflectanceLandsat(directory=paste(directory.landsat.all[i], "/cropped/radiance/", sep=""), mtl=metafiles[i])}

## create vector containing all preprocessed green bands
bands.green <- c()
for (i in 1:length(directory.landsat.all))
{bands.green[i] <- list.files(path=paste(directory.landsat.all[i], "/cropped/radiance/reflectance/", sep=""), full.names=T, recursive=F, pattern="(B2.)")}

## create vector containing all preprocessed near infrared bands
bands.nir <- c()
for (i in 1:length(directory.landsat.all))
{bands.nir[i] <- list.files(path=paste(directory.landsat.all[i], "/cropped/radiance/reflectance/", sep=""), full.names=T, recursive=F, pattern="(B4.)")}

## create binary NDWI Masks, write into according directories
for (i in 1:length(directory.landsat.all))
{maskNDWILandsat(directory=directory.landsat.all[i], name=paste("Mask-Thr-0-25", directory.landsat.name[i], sep=""), green=bands.green[i], nir=bands.nir[i], threshold=NDWI.threshold)}

## create NDWI Layers
for (i in 1:length(directory.landsat.all))
{NDWILandsat(directory=directory.landsat.all[i], name=paste("NDWI-",directory.landsat.name[i],sep=""), green=bands.green[i], nir=bands.nir[i]})

## create binary masks from NDWI Layers - Threshold is calculated from given quantile of training site (10% in this case)
for (i in 1:length(directory.landsat.all)){
  ndwi.image <- dir(directory.landsat.all[i], pattern="NDWI", full.names=T)
  maskNDWILandsatQuan(image=ndwi.image, training=NDWI.training, quant=0.1, directory=directory.landsat.all[i], name=paste("Mask-Thr-MinQuan-", directory.landsat.name[i], sep=""))}

## use binary mask for clump detection / minimum lake size filter
for (i in 1:length(directory.landsat.all)){
  ndwi.binary <- dir(directory.landsat.all[i], pattern="Mask-Thr-MinQuan", full.names=T)
  clumpMaskBySize(image=ndwi.binary, size=clump.size, directory=directory.landsat.all[i], name=paste("NDWI-clump-50-", directory.landsat.name[i], sep=""))}

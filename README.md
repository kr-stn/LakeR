This collection of scripts was developed as a proof of concept during a university course for processing large Landsat data sets with R and automatically detect lakes. The goal is to automatically create binary lake masks so one can evaluate
lake growth and lake distribution with minimal investment of time and money.

### Usage
There are two main processing chains that can be achieved with these scripts.

1. (crop) - calculate TOAR - create binary NDWI mask with threshold - (detect clumps to determine minimum lake size)
2. (crop) - calculate TOAR - create NDWI Layers - detect threshold from training site and mask image - (detect clumps to determine minimum lake size)

### Data
Ideally each Landsat scene is in its own subfolder and each band is represented as a single GeoTiff
(exactly as Landsat data is provided by the USGS).

### Author
Kersten Clauss

kersten.clauss@gmail.com

twitter.com/Fernerkundung

This was a course project during the course *Remote Sensing with R* at the *University of Erlangen-Nuernberg*.

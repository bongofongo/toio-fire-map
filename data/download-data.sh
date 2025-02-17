#!/bin/bash

modisUrl="https://firms.modaps.eosdis.nasa.gov/data/active_fire/modis-c6.1/csv/MODIS_C6_1_USA_contiguous_and_Hawaii_24h.csv"
snipUrl="https://firms.modaps.eosdis.nasa.gov/data/active_fire/suomi-npp-viirs-c2/csv/SUOMI_VIIRS_C2_USA_contiguous_and_Hawaii_24h.csv"
noaa20Url="https://firms.modaps.eosdis.nasa.gov/data/active_fire/noaa-20-viirs-c2/csv/J1_VIIRS_C2_USA_contiguous_and_Hawaii_24h.csv"
noaa21Url="https://firms.modaps.eosdis.nasa.gov/data/active_fire/noaa-21-viirs-c2/csv/J2_VIIRS_C2_USA_contiguous_and_Hawaii_24h.csv"
landstatUrl="https://firms.modaps.eosdis.nasa.gov/data/active_fire/landsat/csv/LANDSAT_USA_contiguous_and_Hawaii_24h.csv"

--output-document=newfile.txt

wget $modisUrl --output-document=modis.csv
wget $snipUrl --output-document=snip.csv
wget $noaa20Url --output-document=noaa20.csv
wget $noaa21Url --output-document=noaa21.csv
wget $landstatUrl --output-document=landstat.csv

#!/bin/bash

echo "Please enter time frame wanted "24h" or "48h" or "7d":"
read timeFrame

case "$timeFrame" in
    "24h")
        echo "You chose 24 hours."
        # Add code for 24h case here
        modisUrl="https://firms.modaps.eosdis.nasa.gov/data/active_fire/modis-c6.1/csv/MODIS_C6_1_USA_contiguous_and_Hawaii_24h.csv"
        snipUrl="https://firms.modaps.eosdis.nasa.gov/data/active_fire/suomi-npp-viirs-c2/csv/SUOMI_VIIRS_C2_USA_contiguous_and_Hawaii_24h.csv"
        noaa20Url="https://firms.modaps.eosdis.nasa.gov/data/active_fire/noaa-20-viirs-c2/csv/J1_VIIRS_C2_USA_contiguous_and_Hawaii_24h.csv"
        noaa21Url="https://firms.modaps.eosdis.nasa.gov/data/active_fire/noaa-21-viirs-c2/csv/J2_VIIRS_C2_USA_contiguous_and_Hawaii_24h.csv"
        landstatUrl="https://firms.modaps.eosdis.nasa.gov/data/active_fire/landsat/csv/LANDSAT_USA_contiguous_and_Hawaii_24h.csv"
        ;;
    "48h")
        echo "You chose 48 hours."
        # Add code for 48h case here
        modisUrl="https://firms.modaps.eosdis.nasa.gov/data/active_fire/modis-c6.1/csv/MODIS_C6_1_USA_contiguous_and_Hawaii_48h.csv"
        snipUrl="https://firms.modaps.eosdis.nasa.gov/data/active_fire/suomi-npp-viirs-c2/csv/SUOMI_VIIRS_C2_USA_contiguous_and_Hawaii_48h.csv"
        noaa20Url="https://firms.modaps.eosdis.nasa.gov/data/active_fire/noaa-20-viirs-c2/csv/J1_VIIRS_C2_USA_contiguous_and_Hawaii_48h.csv"
        noaa21Url="https://firms.modaps.eosdis.nasa.gov/data/active_fire/noaa-21-viirs-c2/csv/J2_VIIRS_C2_USA_contiguous_and_Hawaii_48h.csv"
        landstatUrl="https://firms.modaps.eosdis.nasa.gov/data/active_fire/landsat/csv/LANDSAT_USA_contiguous_and_Hawaii_48h.csv"
        ;;
    "7d")
        echo "You chose 7 days."
        # Add code for 7d case here
        modisUrl="https://firms.modaps.eosdis.nasa.gov/data/active_fire/modis-c6.1/csv/MODIS_C6_1_USA_contiguous_and_Hawaii_7d.csv"
        snipUrl="https://firms.modaps.eosdis.nasa.gov/data/active_fire/suomi-npp-viirs-c2/csv/SUOMI_VIIRS_C2_USA_contiguous_and_Hawaii_7d.csv"
        noaa20Url="https://firms.modaps.eosdis.nasa.gov/data/active_fire/noaa-20-viirs-c2/csv/J1_VIIRS_C2_USA_contiguous_and_Hawaii_7d.csv"
        noaa21Url="https://firms.modaps.eosdis.nasa.gov/data/active_fire/noaa-21-viirs-c2/csv/J2_VIIRS_C2_USA_contiguous_and_Hawaii_7d.csv"
        landstatUrl="https://firms.modaps.eosdis.nasa.gov/data/active_fire/landsat/csv/LANDSAT_USA_contiguous_and_Hawaii_7d.csv"
        ;;
    *)
        echo "Invalid input. Please enter 24h, 48h, or 7d."
        exit 1
        ;;
esac

# modisUrl="https://firms.modaps.eosdis.nasa.gov/data/active_fire/modis-c6.1/csv/MODIS_C6_1_USA_contiguous_and_Hawaii_24h.csv"
# snipUrl="https://firms.modaps.eosdis.nasa.gov/data/active_fire/suomi-npp-viirs-c2/csv/SUOMI_VIIRS_C2_USA_contiguous_and_Hawaii_24h.csv"
# noaa20Url="https://firms.modaps.eosdis.nasa.gov/data/active_fire/noaa-20-viirs-c2/csv/J1_VIIRS_C2_USA_contiguous_and_Hawaii_24h.csv"
# noaa21Url="https://firms.modaps.eosdis.nasa.gov/data/active_fire/noaa-21-viirs-c2/csv/J2_VIIRS_C2_USA_contiguous_and_Hawaii_24h.csv"
# landstatUrl="https://firms.modaps.eosdis.nasa.gov/data/active_fire/landsat/csv/LANDSAT_USA_contiguous_and_Hawaii_24h.csv"

# --output-document=newfile.txt

wget $modisUrl --output-document=data/modis.csv
wget $snipUrl --output-document=data/snip.csv
wget $noaa20Url --output-document=data/noaa20.csv
wget $noaa21Url --output-document=data/noaa21.csv
wget $landstatUrl --output-document=data/landstat.csv

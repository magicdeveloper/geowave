# Data Location 
# ~/Downloads/SourceData/shabak12-7-2020Data
# Install GDAL
geowave raster installgdal

cd /home/hadoopuser/Downloads/SourceData
# Configure GeoWave Data Stores


########################################


geowave store add -t rocksdb --gwNamespace geowave.shabak --dir .  shabaktest 
geowave index add -t spatial -c EPSG:4326 shabaktest   shabaktest-idx
geowave store list
geowave store describe shabaktest

geowave ingest localToGW  ~/Downloads/SourceData/shabak12-7-2020Data shabaktest  shabaktest-idx \
--geotools-raster.coverage Riyadh-Shabak \
--geotools-raster.histogram \
--geotools-raster.pyramid \
--geotools-raster.mergeStrategy no-data 
 
geowave stat recalc  shabaktest

geowave gs layer add shabaktest  --add all 

geowave store describe shabak

geowave store copy shabak shabaktest

geowave gs ds add -ds shabak shabak
geowave gs layer add shabak  --add vector 
geowave gs layer add shabak  --add raster --setStyle raster
# Remove 
geowave store list
geowave index rm shabaktest   shabaktest-idx 
geowave store clear shabaktest
geowave store rm shabaktest  
geowave store list

# Remove 

#####################################################
# New Ingest raster with vector geotools 
geowave store add -t rocksdb --gwNamespace geowave.shabaktest --dir . RiyadhStore
geowave index add -t spatial -c EPSG:4326 RiyadhStore Riyadh-idx
geowave store describe RiyadhStore

geowave ingest localToGW  ~/Downloads/SourceData/shabak12-7-2020Data \
RiyadhStore  Riyadh-idx \
--geotools-raster.coverage Riyadh \
--geotools-raster.histogram \
--geotools-raster.pyramid \
--geotools-raster.mergeStrategy no-data \

geowave ingest localToGW -f geotools-raster ~/Downloads/SourceData/shabak12-7-2020Data \
--geotools-raster.coverage ShabakRiyadh \
--geotools-raster.crs EPSG:4326 \
--geotools-raster.histogram \
--geotools-raster.pyramid \
--geotools-raster.mergeStrategy no-data \
--threads 2 \
shabaktestR  spatial-idx

geowave stat recalc  shabaktestR
geowave gs layer add RiyadhRst  --add all

geowave gs ds add -ds shabaktestR shabaktestR

geowave store list
geowave index rm shabaktestR   spatial-idx
geowave store clear shabaktestR
geowave store rm shabaktestR  
geowave index rm shabaktestV   spatial-idx
geowave store clear shabaktestV
geowave store rm shabaktestV  
geowave store rm RiyadhRst  
geowave store rm shabak  
geowave store rm shabak2  
 
geowave store list
 
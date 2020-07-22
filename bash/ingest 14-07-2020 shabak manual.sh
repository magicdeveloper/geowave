# Ingest 14-07-2020 shabak manual 
# انجست بلدي للتجريب برجاء لاتمسح  
geowave store listplugins
geowave store clear localraster 
geowave index rm localraster localraster-idx
geowave store rm localraster 
geowave gs ds rm localraster
geowave store list 
geowave store rm landsatraster
geowave store clear localvector 
geowave store rm gdelt 
geowave store list 
 
################################################
geowave store clear localraster 
geowave index rm localraster localraster-idx
geowave store rm localraster 
geowave gs ds rm localraster
geowave store list 
geowave store add -t rocksdb  --dir . localraster
geowave index add -t spatial -c EPSG:4326 localraster localraster-idx
geowave store list 
geowave ingest localToGW -f geotools-raster /home/hadoopuser/Downloads/SourceData/shabak12-7-2020Data \
--geotools-raster.coverage Myraster \
--geotools-raster.crs EPSG:4326 \
--geotools-raster.histogram \
--geotools-raster.pyramid \
--geotools-raster.mergeStrategy no-data \
--geotools-raster.separateBands true \
--threads 2 \
localraster  localraster-idx

geowave geoserver coveragestore add --coverageStore localraster-cov \
--interpolationOverride 0 \
--scaleTo8Bit false --workspace geowave localraster

#geowave gs cv add -cs localraster-cov localraster-cov

# geowave gs ds add -ds localraster-gs localraster --workspace geowave
# geowave gs ds getsa localraster-gs

geowave gs layer add localraster   --add all
################################################
StoreName="localraster"
Index="${StoreName}-idx"
DataPath="/home/hadoopuser/Downloads/SourceData/shabak12-7-2020Data"
CovStore="${StoreName}-cov"
gwNamespace="geowave.${StoreName}"

geowave index rm ${StoreName} $Index 
geowave store rm ${StoreName} 
geowave gs ds rm ${StoreName}

geowave store rm RiyadhX4
geowave store rm localraster
geowave store list 
geowave store add -t rocksdb  --dir . ${StoreName}
geowave index add -t spatial -c EPSG:4326 ${StoreName} $Index 
geowave store list 

geowave ingest localToGW -f geotools-raster $DataPath $StoreName $Index \
--geotools-raster.coverage $CovStore \
--geotools-raster.histogram \
--geotools-raster.pyramid \
--geotools-raster.mergeStrategy no-data \
--geotools-raster.separateBands true    \
--geotools-raster.crs EPSG:4326 \
--threads 2 \
--visibility public \
--geotools-raster.tileSize 512

geowave gs layer add localraster   --add all
localraster
geowave geoserver coverage add -cs $CovStore \
--workspace ${gwNamespace} ${CovStore}-sh \
-histo true \
-interp 0 \
-scale false 

geowave --debug


geowave explain geowave geoserver coverage add -cs $CovStore \
--workspace ${gwNamespace} ${CovStore}-sh
# geowave geoserver coveragestore add --coverageStore $CovStore  \
# --interpolationOverride 0 \
# --scaleTo8Bit false --workspace ${gwNamespace} ${StoreName}

geowave config geoserver http://hadoop-master:5050/geoserver --username admin --password geoserver

geowave explain ingest localToGW -f geotools-raster --geotools-raster.separateBands
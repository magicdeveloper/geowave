# Install GDAL
sudo geowave gs run
password : 0124512097
geowave raster installgdal

cd home/hadoopuser/datastores
cd /opt/geowave/lib/services/third-party/embedded-geoserver/geoserver/data
/opt/geowave/lib/services/third-party/embedded-geoserver/geoserver/data/geowave
# Configure GeoWave Data Stores

geowave config set geowave.console.default.echo.enabled=true
########################################
StoreName="Riyadh01"
Index="${StoreName}-idx"
gwNamespace="geowave.${StoreName}"
DataPath="/home/hadoopuser/Downloads/SourceData/shabak12-7-2020Data"
StorePath="/home/hadoopuser/datastores"
chmod 777 ${DataPath}
chmod 777 ${StorePath}
clear
echo "Data path contain:"
ls ${DataPath}
echo "--------------------------------------------------------------------------------"
echo "Start Adding GeoWave Store: ${StoreName} |  Index: ${Index} into NameSpace: ${$gwNamespace}"
geowave store add -t rocksdb --gwNamespace $gwNamespace --dir $StorePath $StoreName 
geowave index add -t spatial -c EPSG:4326 $StoreName $Index

ls ${StorePath}
sleep 5
clear
geowave store list
geowave store describe $StoreName 
geowave ingest localToGW $DataPath $StoreName $Index \
--geotools-raster.coverage $StoreName \
--geotools-raster.histogram \
--geotools-raster.pyramid \
--geotools-raster.mergeStrategy no-data 
echo "****************----- Complete Geowave Ingest to Store: ${StoreName} -----********************************"
sleep 5
clear
geowave store list
geowave store describe $StoreName 
echo "--------------------------------------------------------------------------------"


geowave stat recalc  $StoreName 
geowave gs layer add $StoreName   --add all

# Remove 
geowave index rm $StoreName $Index 
geowave store clear $StoreName 
geowave store rm $StoreName   
clear
geowave store list
clear
# Remove 

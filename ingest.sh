## bash /home/hadoopuser/Downloads/SourceData/abdalglil/ingest.sh
########################################
## dfine variables into bash
StoreName="RiyadhX1"
Index="${StoreName}-idx"
gwNamespace="geowave.${StoreName}"
DataPath="/home/hadoopuser/Downloads/SourceData/shabak12-7-2020Data"
StorePath="/home/hadoopuser/datastores"
chmod 777 ${DataPath}
chmod 777 ${StorePath}
echo "Complete Adding variables [Store:${StoreName} ,Index:${Index}, Namespace:${$gwNamespace}]"
echo "Data path contain:"
ls ${DataPath}
sleep 5
clear
########################################
## Install GDAL
geowave raster installgdal
geowave config set geowave.console.default.echo.enabled=true
########################################
## geowave add store,index and ingest data
echo "Start Adding GeoWave Store: ${StoreName} |  Index: ${Index} into NameSpace: ${$gwNamespace}"
echo ""
echo ""
geowave store add -t rocksdb --gwNamespace $gwNamespace --dir $StorePath $StoreName 
geowave index add -t spatial -c EPSG:4326 $StoreName $Index
echo "complete Adding GeoWave Store: ${StoreName} |  Index: ${Index} into NameSpace: ${$gwNamespace}"
echo "Store:"
ls ${StorePath}
sleep 5
clear
geowave store list
geowave store describe $StoreName 
echo ""
echo "****************----- Start Geowave Ingest to Store: ${StoreName} -----********************************"
echo ""

geowave ingest localToGW $DataPath $StoreName $Index \
--geotools-raster.coverage $StoreName \
--geotools-raster.histogram \
--geotools-raster.pyramid \
--geotools-raster.mergeStrategy no-data 
# sleep 5
# clear
echo ""
echo ""
echo "****************----- Complete Geowave Ingest to Store: ${StoreName} -----********************************"
echo ""
echo ""
geowave store list
echo "describe: ${StoreName}"
geowave store describe $StoreName 
########################################
## geowave  stat , addl layers to geoserver

echo ""
echo "Start gs layer add  ${StoreName} --add all"
geowave gs layer add $StoreName   --add all
echo ""
# echo "Start stat recalc  ${StoreName}"
# geowave stat recalc  $StoreName 
### geowave stat recalc  RiyadhX2 
# echo ""
echo "End Of Script"
########################################
## Remove geowave store
# StoreName="RiyadhX4"
# Index="${StoreName}-idx"
# geowave index rm $StoreName $Index 
# geowave store clear $StoreName 
# geowave store rm $StoreName   
# clear
# geowave store list
# clear


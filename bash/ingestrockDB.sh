#!/bin/bash

# bash /home/hadoopuser/Downloads/SourceData/abdalglil/bash/ingestrockDB.sh \
# -s RiyadhX4 \
# -d /home/hadoopuser/Downloads/SourceData/shabak12-7-2020Data \
# -p /home/hadoopuser/datastores
#-------------------------------------------------------------------

helpFunction()
{
   echo -e "\nHELP "
   echo "Usage: $0 -s StoreName -d DataPath "
   echo -e "\n\t-s --StoreName <name> \n\t\t- Stor Name must insert "
   echo -e "\n\t-d --DataPath <path> \n\t\t- The directory to Data that will ingest. "
   echo -e "\n\t-p --StorePath  <path> \n\t\t- defult: ./ \n\t\t- The directory to rockDB store."
   echo -e "\n\t-r --RemoveOld :[true | false] \n\t\t- defult:  true \n\t\t- remove old one [true or false]"
   echo -e "\n\t\t "
   exit 1 # Exit script after printing help
}

while getopts "s:d:p:r:" opt
do
   case "$opt" in
      s ) StoreName="$OPTARG" ;;
      d ) DataPath="$OPTARG" ;;
      p ) StorePath="$OPTARG" ;;   
      r ) RemoveOld="$OPTARG" ;;      
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Print helpFunction in case StorName or DataPath parameters are empty
if [ -z "$StoreName" ] || [ -z "$DataPath" ] 
then
   echo "StorName or DataPath parameters are empty";
   helpFunction
fi
# set defult value for StorePath if not exist ./
if [ -z "$StorePath" ] 
then
   StorePath="."
fi
# set defult value for RemoveOld if not exist 
if [ -z "$RemoveOld" ] 
then
   RemoveOld=true
fi
#--------------------------------------------------------------------------------
# Begin script in case all parameters are correct
#--------------------------------------------------------------------------------

## dfine variables into bash
echo -e "Begin script\n"
Index="${StoreName}-idx"
gwNamespace="geowave.${StoreName}"
CovStore="${StoreName}-raster"
echo -e "start ingest task with \n\t - Store: \e[30;48;5;82m${StoreName}\e[0m   \n\t - Index: \e[30;48;5;82m${Index}\e[0m \n\t - Namespace: \e[30;48;5;82m${gwNamespace}\e[0m \n\t - dataPath: ${DataPath} \n\t - StorePath: ${StorePath}\n"
echo -e "Data path contain:"
ls -l ${DataPath}
echo -e "-----------------------------------------------\n\n" 
sleep 2
#--------------------------------------------------------------------------------
## Remove old store
if [ "$RemoveOld" = true ]; then
   if [ -d "${StorePath}/${gwNamespace}" ] 
   then
         echo -e "Removeing old store:\e[30;48;5;82m ${StoreName} \e[0m\n"     
         geowave index rm $StoreName $Index 
         echo -e "remove index: \e[30;48;5;82m$Index \e[0m\n"   
         geowave store clear $StoreName 
         echo -e "clear store: \e[30;48;5;82m$StoreName \e[0m\n"  
         geowave store rm $StoreName   
         echo -e "remove store: \e[30;48;5;82m$StoreName \e[0m\n"   
         geowave store list
         echo -e "-----------------------------------------------\n"
         echo -e "\n\e[30;48;5;82m Complete Removeing store ${StoreName}  \e[0m\n"          
   
   else
      echo -e "\n\e[30;48;5;82mcan not remove store ${StoreName} does not exists\e[0m\n" 
   fi
   sleep 5
   clear
fi
echo -e "\n\n" 
#--------------------------------------------------------------------------------
## Install GDAL
geowave raster installgdal
geowave config set geowave.console.default.echo.enabled=true
#--------------------------------------------------------------------------------
## geowave add store,index and ingest data
echo -e "\n\e[30;48;5;82mAdding GeoWave Store: ${StoreName} |  Index: ${Index} into NameSpace: ${gwNamespace} \e[0m\n" 
geowave store add -t rocksdb --gwNamespace $gwNamespace --dir $StorePath $StoreName 
geowave index add -t spatial -c EPSG:4326 $StoreName $Index
echo "Store content:"
ls ${StorePath}
echo -e "complete Adding GeoWave Store: \e[30;48;5;82m${StoreName}\e[0m |  Index: \e[30;48;5;82m${Index}\e[0m into NameSpace: \e[30;48;5;82m${gwNamespace}\e[0m\n\n"
#--------------------------------------------------------------------------------
geowave store list
geowave store describe $StoreName 

#  #--------------------------------------------------------------------------------
# echo -e "\n add geoserver store: \e[30;48;5;82m${StoreName}\e[0m \n"
# geowave gs ds add -ds $StoreName $StoreName
echo -e "\n add coverge store: \e[30;48;5;82m${CovStore}\e[0m \n"
geowave gs cs add -cs $CovStore $StoreName \
--scaleTo8Bit false
-histo true \
-interp 1 
echo -e "\n coverge store list"
geowave gs cs list
echo -e "\n coverge store info: \e[30;48;5;82m${CovStore}\e[0m \n"
geowave gs cs get $CovStore 

echo -e "\n complete adding coverge store: \e[30;48;5;82m${CovStore}\e[0m \n"
geowave gs ds list 
# geowave gs ds get $StoreName
# geowave gs ds getsa $StoreName

# --------------------------------------------------------------------------------
echo -e "\n Start Geowave Ingest to Store: \e[30;48;5;82m${StoreName}\e[0m \n"
geowave ingest localToGW $DataPath $StoreName $Index \
--geotools-raster.coverage $StoreName \
--geotools-raster.histogram \
--geotools-raster.pyramid \
--geotools-raster.mergeStrategy no-data 

echo -e "\n\e[30;48;5;82m Complete Geowave Ingest to Store: ${StoreName}\e[0m \n\n"
geowave store list
#geowave gs cv add -cs $CovStore $StoreName
geowave gs layer add $StoreName --add raster
geowave gs cs list
geowave gs cs get $CovStore
geowave gs cv list $CovStore
geowave gs ds list 

echo -e "\n\e[7mEnd Of Script\e[0m \n\n"



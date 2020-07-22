# bash /home/hadoopuser/Downloads/SourceData/abdalglil/bash/ingestrockDB.sh \
# -s RiyadhX4 \
# -d /home/hadoopuser/Downloads/SourceData/shabak12-7-2020Data \
# -p /home/hadoopuser/datastores
##----------------------------------------------

StoreName="RiyadhX4"
Index="${StoreName}-idx"
gwNamespace="geowave.${StoreName}"
CovStore="${StoreName}-cov"
geowave gs cs add -cs mycov $StoreName \
-scale false \
-ws $gwNamespace

geowave store list
# geowave store describe $StoreName 

geowave gs ds list 
geowave gs ds getsa $StoreName

geowave gs ds add -ds $StoreName $StoreName

geowave gs cs add -cs $CovStore $StoreName \
-histo true \
-interp 0 \
-scale false \
-ws $gwNamespace

geowave gs ds list 
geowave gs ds getsa $StoreName


geowave gs cs add -cs mycov $StoreName \
-scale false \
-ws $gwNamespace



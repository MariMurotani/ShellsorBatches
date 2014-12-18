#!/bin/sh
# export path of tools
PATH=/usr/bin/:/bin/:/usr/local/bin/:/Users/murotanimari/Tools/jar_diff_batch/jad158g.mac.intel:/Users/murotanimari/Tools/jar_diff_batch/dex2jar-0.0.9.15:/Users/murotanimari/Tools/jar_diff_batch/:/Applications/adt-bundle-mac/sdk/build-tools/21.1.1/

# define of jar files
INPUT_DIR="input"
TMP_DIR="tmp"
EXE_DIR="tools"
EXPORT_DIR="export"

TARGET1="***********************.apk"
TARGET2="***********************.apk"

OUT1=${TARGET1/.apk/""}
OUT2=${TARGET2/.apk/""}
DEX="classes.dex"
DEXJAR="classes_dex2jar.jar"
AXMLPATH=/Users/murotanimari/Tools/jar_diff_batch/tools/AXMLPrinter2.jar

OUTJAVA1=$TMP_DIR'/'${OUT1}'/classes'
OUTJAVA2=$TMP_DIR'/'${OUT2}'/classes'
OUTSRC1=$EXPORT_DIR'/'${OUT1}'/src'
OUTSRC2=$EXPORT_DIR'/'${OUT2}'/src'
OUTRES1=$EXPORT_DIR'/'${OUT1}'/res'
OUTRES1=$EXPORT_DIR'/'${OUT2}'/res'

echo $OUT1 $OUT2
# create working drectory
[ ! -e $TMP_DIR ] && mkdir -p $TMP_DIR
rm -fR $TMP_DIR/*

[ ! -e $EXPORT_DIR ] && mkdir -p $EXPORT_DIR
rm -fR $EXPORT_DIR'/'${OUT1}; mkdir -p $EXPORT_DIR'/'${OUT1}
rm -fR $EXPORT_DIR'/'${OUT2}; mkdir -p $EXPORT_DIR'/'${OUT2}

rm -fR ${OUTJAVA1}; mkdir -p ${OUTJAVA1}
rm -fR ${OUTJAVA2}; mkdir -p ${OUTJAVA2}
mkdir ${OUTRES1};mkdir ${OUTRES2}

# unzip
unzip $INPUT_DIR'/'$TARGET1 -d $TMP_DIR'/'${OUT1} > /dev/null 
unzip $INPUT_DIR'/'$TARGET2 -d $TMP_DIR'/'${OUT2} > /dev/null

# dex decompile
tools/dex2jar-0.0.9.15/dex2jar.sh $TMP_DIR'/'${OUT1}'/'$DEX
tools/dex2jar-0.0.9.15/dex2jar.sh $TMP_DIR'/'${OUT2}'/'$DEX 

# dex unzip
unzip $TMP_DIR'/'${OUT1}'/'$DEXJAR -d ${OUTJAVA1}'/' > /dev/null
unzip $TMP_DIR'/'${OUT2}'/'$DEXJAR -d ${OUTJAVA2}'/' > /dev/null

# decode to java files
$EXE_DIR'/'jad158g.mac.intel/jad -o -8 -d $OUTSRC1 -s .java -r ${OUTJAVA1}'**/*.class'
$EXE_DIR'/'jad158g.mac.intel/jad -o -8 -d $OUTSRC2 -s .java -r ${OUTJAVA2}'**/*.class'

# copy assets
cp -R $TMP_DIR'/'${OUT1}'/assets' $EXPORT_DIR'/'${OUT1}'/'
cp -R $TMP_DIR'/'${OUT2}'/assets' $EXPORT_DIR'/'${OUT2}'/'

# export menifest from apk
aapt l -a $INPUT_DIR'/'${TARGET1} > $EXPORT_DIR'/'${OUT1}'/'AndroidManifest.xml
aapt l -a $INPUT_DIR'/'${TARGET2} > $EXPORT_DIR'/'${OUT2}'/'AndroidManifest.xml

# decode xml resource files
for i in "1" "2"
do
	pathFind='find ${TMP_DIR}/${OUT'$i'}/res -name "*.xml"'
        for FILENAME in `eval ${pathFind}`
        do
                DIRECTORYNAME=${FILENAME%/*}
		INDIRECTORY=${DIRECTORYNAME##*/}
		PUREFILENAME=`echo ${FILENAME} | sed -e "s/.*\/\(.*$\)/\1/"`
		EXPORTDIRECTORY=$EXPORT_DIR'/'${OUT1}'/res/'${INDIRECTORY}
		[ ! -e ${EXPORTDIRECTORY} ] && mkdir -p ${EXPORTDIRECTORY}

                OUTFILENAME=${EXPORTDIRECTORY}'/'${PUREFILENAME}
		echo 'FILE=>'${FILENAME}
		echo 'OUT=>'${OUTFILENAME}
		echo 'java -jar '${AXMLPATH} ${FILENAME}
		java -jar ${AXMLPATH} ${FILENAME}' > '${OUTFILENAME}
        done
done

# export diff of sources
#diff -R {$OUTSRC1} ${OUTSRC2}

# zip


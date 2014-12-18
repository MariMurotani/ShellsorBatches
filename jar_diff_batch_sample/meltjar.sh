#!/bin/sh
# export path of tools
PATH=/usr/bin/:/bin/:/Users/murotanimari/Tools/jar_diff_batch/jad158g.mac.intel:/Users/murotanimari/Tools/jar_diff_batch/dex2jar-0.0.9.15:/Users/murotanimari/Tools/jar_diff_batch/AXMLPrinter2.jar:/Applications/adt-bundle-mac/sdk/build-tools/21.1.0/

# define of jar files
INPUT_DIR="input"
TMP_DIR="tmp"
EXE_DIR="tools"
EXPORT_DIR="export"

DECODED_SRC="dec_src"
TARGET1="***********************.jar"
TARGET2="***********************.jar"
OUT1=${TARGET1/.jar/""}
OUT2=${TARGET2/.jar/""}
OUTSRC1=$EXPORT_DIR'/'${OUT1}'/src'
OUTSRC2=$EXPORT_DIR'/'${OUT2}'/src'

echo $OUT1 $OUT2
# create working drectory
[ ! -e $TMP_DIR ] && mkdir -p $TMP_DIR
rm -fR $TMP_DIR/*

[ ! -e $EXPORT_DIR ] && mkdir -p $EXPORT_DIR
rm -fR $EXPORT_DIR'/'${OUT1}; mkdir -p $EXPORT_DIR'/'${OUT1}
rm -fR $EXPORT_DIR'/'${OUT2}; mkdir -p $EXPORT_DIR'/'${OUT2}

# unzip
unzip $INPUT_DIR'/'$TARGET1 -d $TMP_DIR'/'${OUT1} 
unzip $INPUT_DIR'/'$TARGET2 -d $TMP_DIR'/'${OUT2}

# dex decompile
#echo dex2jar-0.0.9.15/dex2jar.sh $TMP_DIR'/'${OUT1}'/'classes.dex 
#echo dex2jar-0.0.9.15/dex2jar.sh $TMP_DIR'/'${OUT1}'/'classes.dex 

# dex unzip
#unzip $TMP_DIR'/'${OUT1}'/'$TARGET1
#unzip $TMP_DIR'/'${OUT2}'/'$TARGET2

# clean output directory
rm -fR $OUTSRC1'/*'
rm -fR $OUTSRC2'/*'

# decode to java files
$EXE_DIR'/'jad158g.mac.intel/jad -o -8 -d $OUTSRC1 -s .java -r **/*.class
$EXE_DIR'/'jad158g.mac.intel/jad -o -8 -d $OUTSRC1 -s .java -r **/*.class

# copy assets
cp -R $TMP_DIR'/'${OUT1}'/assets' $EXPORT_DIR'/'${OUT1}'/'
cp -R $TMP_DIR'/'${OUT2}'/assets' $EXPORT_DIR'/'${OUT2}'/'


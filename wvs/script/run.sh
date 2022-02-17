#!/bin/
set -x
work_path=$(cd `dirname $0`; pwd)

rm -rf $work_path/../../wvs_temp
cp -r -f $work_path/../../wvs $work_path/../../wvs_temp

lc_work_path=$work_path/../../wvs_temp
lib_work_path=$work_path/../../wvslib
# 
$work_path/HYCodeScan.app/Contents/MacOS/HYCodeScan --redefine -i $lc_work_path/wvs/Classes/wvs/WVS.h -i $lc_work_path/wvs/Classes/wvs/realprefix.pch -i $lib_work_path/prefix.pch -i $lib_work_path/prefix.pch
$work_path/HYCodeScan.app/Contents/MacOS/HYCodeScan --xcode --config $work_path/appConfig.json -p $lc_work_path/Example/Pods/Pods.xcodeproj

cp $lc_work_path/wvs/Classes/wvs/WVS.h $lc_work_path/Example/Pods/Headers/Public/wvl/
cp $lc_work_path/wvs/Classes/wvs/WVS.h $lc_work_path/Example/Pods/Headers/Public/wvs/

xcodebuild -workspace $lc_work_path/Example/wvs.xcworkspace -scheme wvs_Example -sdk iphonesimulator -configuration Release build -jobs 8
xcodebuild -workspace $lc_work_path/Example/wvs.xcworkspace -scheme wvs_Example -sdk iphoneos -configuration Release build -jobs 8
xcodebuild -workspace $lc_work_path/Example/wvs.xcworkspace -scheme wvl_Example -sdk iphonesimulator -configuration Release build -jobs 8
xcodebuild -workspace $lc_work_path/Example/wvs.xcworkspace -scheme wvl_Example -sdk iphoneos -configuration Release build -jobs 8

sh $lib_work_path/updateVersion.sh

productFolder="Example/Pods/Products/wvs"
for i in `ls $lc_work_path/$productFolder`; do
cp -r $lc_work_path/$productFolder/$i $lib_work_path/wvs/
done

productFolder="Example/Pods/Products/wvl"
for i in `ls $lc_work_path/$productFolder`; do
cp -r $lc_work_path/$productFolder/$i $lib_work_path/wvl/
done

cp $lc_work_path/wvs/Classes/wvs/WVS.h $lib_work_path/wvs/
cp $lc_work_path/wvs/Classes/wvs/WVS.h $lib_work_path/wvl/

function comit()
{
	cd $lib_work_path
	git add -u && git commit -m 'autobuild' && git push origin master
}

comit


sh $work_path/clean.sh
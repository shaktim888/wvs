set -x
work_path=$(cd `dirname $0`; pwd)

rm -rf $work_path/../../wvslib_temp
cp -r -f $work_path/../../wvslib $work_path/../../wvslib_temp
cd $work_path/../../wvslib

git filter-branch --force --index-filter 'git rm --cached -r --ignore-unmatch wvl' --prune-empty --tag-name-filter cat -- --all
git filter-branch --force --index-filter 'git rm --cached -r --ignore-unmatch wvs' --prune-empty --tag-name-filter cat -- --all

git push origin master:master --tags --force

rm -rf $work_path/../../wvslib/wvs
rm -rf $work_path/../../wvslib/wvl

cp -r -f $work_path/../../wvslib_temp/wvs $work_path/../../wvslib/wvs
cp -r -f $work_path/../../wvslib_temp/wvl $work_path/../../wvslib/wvl

git add -A && git commit -m 'autoClean' && git push origin master

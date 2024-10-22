set CURRENT_DIR=%CD%
cd c:/yigal/blog
git add .
git commit 
git push
cd c:/last/blog
git pull
git log --oneline| wc -l
if defined CURRENT_DIR (
  cd %CURRENT_DIR%
)
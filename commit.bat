set CURRENT_DIR=%CD%
cd c:/yigal/million_try3
git add .
git commit 
git push
cd c:/last/million_try3
git pull
git log --oneline| wc -l
if defined CURRENT_DIR (
  cd %CURRENT_DIR%
)
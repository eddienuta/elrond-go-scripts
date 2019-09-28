#This script clean all changes made on this folder and reload the latest version from github

cd ..
git reset --hard master && git pull

echo "# variables"
dateTime=$(date +%Y-%m-%d_%H-%M-%S)
scriptUrl="//contextgarden.net/standalone/setup/first-setup.sh"
scriptName="first-setup.sh"
subModulePath="ubuntu"

echo "# working dir: start"
readlink -f .

echo "# check if rsync is installed, install if not"
if [ ! -x "$(which rsync)" ]; then
  echo "# install rsync"
	sudo apt update
  sudo apt install rsync
else
    echo "# rsync already installed"
fi

echo "# remove directory $subModulePath recursively"
rm -rf "$subModulePath"

echo "# create path $subModulePath"
mkdir "$subModulePath"

echo "# change directory to $subModulePath"
cd "$subModulePath"

echo "# working dir: cd $subModulePath"
readlink -f .

echo "# get latest install script"
rsync -ptv rsync:$scriptUrl ./$scriptName || exit 1

echo "# execute install script"
sh ./$scriptName

echo "# create file $subModulePath/_updated_$dateTime.txt"
echo "# $dateTime" > "./_updated_$dateTime.txt"

echo "# change directory to parent"
cd ..

echo "# working dir: cd .."
readlink -f .

echo "# end"

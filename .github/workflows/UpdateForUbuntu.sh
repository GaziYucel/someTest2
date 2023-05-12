echo "# variables"
GITHUB_USERNAME=${1}
GITHUB_TOKEN=${2}
dateTime=${3}
branchName="update_for_ubuntu_$dateTime"
scriptUrl="//contextgarden.net/standalone/setup/first-setup.sh"
scriptName="first-setup.sh"
subModulePath="ubuntu"
message="Update $subModulePath on $dateTime"

echo "# working dir: start"
readlink -f .

echo "# setup git username / email: $GITHUB_USERNAME"
git config user.name "$GITHUB_USERNAME"
git config user.email "$GITHUB_USERNAME@users.noreply.github.com"

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

echo "# create file $subModulePath/_updated_$dateTime.txt"
echo "# $dateTime" > "./_updated_$dateTime.txt"

echo "# get latest install script"
#rsync -ptv rsync:$scriptUrl ./$scriptName || exit 1

echo "# execute install script"
#sh ./$scriptName

echo "# change directory to parent"
cd ..

echo "# working dir: cd .."
readlink -f .

echo "# checkout to new local branch with name $branchName"
git checkout -b "$branchName"

echo "# add directory $subModulePath recursively"
git add --all "$subModulePath"

echo "# commit all changes with message: $message"
git commit -m "$message"

echo "# push to new branch with name: $branchName"
git push -u origin "$branchName"

echo "# create pull request with label and body: $message"
gh pr create --title "$message" --body "$message"

echo "# end"

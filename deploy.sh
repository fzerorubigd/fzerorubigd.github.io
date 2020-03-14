#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

# Build the project. 
hugo -t hyde-x

# Add changes to git.
git add -A

# Commit changes.
msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -aSs -m "$msg"

# Push source and build repos.
git push origin hugo
# For prevent any conflict, simply delete the branch master on remote 
#git push origin :master
git subtree push --force --prefix=public git@github.com:fzerorubigd/fzerorubigd.github.io.git master

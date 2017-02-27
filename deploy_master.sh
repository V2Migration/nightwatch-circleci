#!/usr/bin/env bash
 
#################################################################
# This script is to deploy jekeyll site and commit + push master 
# branch to origin
#################################################################
 
DEPLOY_DIRECTORY=_site
TODAY=$(date +"%Y%m%d-%H%M%n")
COMMITMSG=
 
echo "## Deploying jekeyll:"
 
IS_HAS_UNCOMMITTED=git diff --exit-code --quiet --cached
 
if ! $IS_HAS_UNCOMMITTED; then
    echo Aborting due to uncommitted changes in the index >&2
    exit 1
fi
 
echo "## Remove `$DEPLOY_DIRECTORY` folder"
 
rm -rf './$DEPLOY_DIRECTORY'
 
# check again for sure
if [ ! -d "$DEPLOY_DIRECTORY" ]; then
    echo "Deploy directory '$DEPLOY_DIRECTORY' does not exist. Aborting." >&2
    exit 1
fi
 
echo "## Generating site"
gulp deploy # --> run 
 
# can avoid this line if you are in master...
echo "## Check out master..."
git checkout master
 
echo "## Commit all files..."
git add . --verbose --all
 
echo
 
read -p "Enter a git commit message: " COMMITMSG
echo "## Commiting: ${1}"
git commit --all --message "Site updated: $TODAY - $COMMITMSG"
 
echo "## Pushing generated site"
git push origin master
 
echo "## Deploy Complete!"
 
exit 0

#! /bin/bash

echo -n $(date +'%H:%M:%S') rsync $1 to $2 " ... "

set -o errexit
DOTGIT_DIRECTORY=$1/.git
if [ -d "${DOTGIT_DIRECTORY}" ]; then
  DOTGIT_SIZE=$(du -s ${DOTGIT_DIRECTORY} | cut -f1)
else
  DOTGIT_SIZE=0
fi

if (( "$DOTGIT_SIZE" > 20000 )); then
  EXCLUDE_GIT="--exclude .git"
  echo EXCLUDE_GIT=${EXCLUDE_GIT}
  echo DOTGIT_SIZE=${DOTGIT_SIZE}
else
  EXCLUDE_GIT=""
fi

rsync $1 --copy-links -r $EXCLUDE_GIT --exclude '*.d' --exclude '*.pyc' --exclude '*.swp' $2
RES=$?
echo rsync_git_once done with code $RES
exit $RES

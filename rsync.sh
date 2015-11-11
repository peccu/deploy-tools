#!/bin/bash
# USAGE: ./release.sh [-n] [-d dir]
# -n      remove "dry-run" option of rsync. (Default is set -n option to rsync)
# -d dir  specify sub-directory. (Default is today string YYYYMMDD)

# put this script in directory you want to sync.
# rsync local directory to $REMOTE_BASE/YYYYMMDD
# list ignore file patterns into .rsyncignore

# remote server name (needs ~/.ssh/config configuration)
REMOTE_SERVER=some-server
# deploy target directory path
REMOTE_BASE=/path/to/deploy/target

SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
TARGET_DIR=$(date "+%Y%m%d")

# parse options
DRY_RUN='-n'
while getopts "nd:" opts
do
  case $opts in
    n)
      DRY_RUN=''
      ;;
    d)
      TARGET_DIR=$OPTARG
      ;;
  esac
done

REMOTE_DIR=$REMOTE_BASE/$TARGET_DIR
echo sync $SCRIPT_DIR/ to $REMOTE_DIR/

rsync -c $DRY_RUN --delete --exclude-from=$SCRIPT_DIR/.rsyncignore -avz $SCRIPT_DIR/ $REMOTE_SERVER:$REMOTE_DIR/

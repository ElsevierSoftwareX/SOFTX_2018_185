#!/bin/bash

# Script for modifying Dockerfiles and building them

# OPTIONS:
# -f  = path to Dockerfile
# -t  = name and tag for Docker image

# FOR DEBUGGING:
# ./dockerBuild.sh -f Dockerfile_eof_elmer84_of6_debug -t eof_elmer84_of6:debug

# FOR DEPLOYING:
# ./dockerBuild.sh -f Dockerfile_eof_elmer84_of6 -t eof_elmer84_of6
# ./dockerBuild.sh -f Dockerfile_eof_elmer84_of6_swak4foam -t eof_elmer84_of6_swak4foam

# Run from main directory
cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"/..

# Function for searching string in string array
containsElement () {
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && return 0; done
  return 1
}

# Define options
while getopts ":f:t:" flag; do
  case "$flag" in
    f  ) dockerFile=$OPTARG ;; # DockerFile
    t  ) nameTag=$OPTARG ;;   # Name and tag
    \? ) echo "Unknown option: -$OPTARG" >&2; exit 1;;
    :  ) echo "Missing option argument for -$OPTARG" >&2; exit 1;;
    *  ) echo "Unexpected option ${flag}. Valid options are -f, -t" && exit 1;;
  esac
done

# Check if Dockerfile exists
if [ ! -f $dockerFile ]; then
  if [ ! -f docker/$dockerFile ]; then
    echo "ERROR: File '$dockerFile' not found!"
    exit 1
  else
    dockerFile="docker/$dockerFile"
  fi
fi

# Check name and tag
if [ -z "$nameTag" ]
then
  echo "ERROR: Docker name:tag is not specified! Tag is optional.."
  exit 1
fi

echo "Building $dockerFile"
docker build -t eof-library/$nameTag -f $dockerFile .

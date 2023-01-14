#!/bin/bash

DOCKER_BUILDKIT=1

echo Sudoku Backend local repo ${1}
echo Sudoku Frontend  local repo ${2}

cd ${1}
echo Building the BE image
make build
echo Saving the BE image
make save

cd ${2}
echo Building the FE image
make build-production
echo Saving the FE image
make save

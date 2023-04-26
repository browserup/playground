#!/bin/bash

echo "Baking"

export VERSION_TAG="LATEST"
docker buildx bake --push playground --set playground.args.VERSION_TAG=$VERSION_TAG


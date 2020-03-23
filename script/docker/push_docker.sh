#!/bin/sh -ex

docker tag privileges quay.io/nyulibraries/privileges:latest
docker tag privileges quay.io/nyulibraries/privileges:${CIRCLE_BRANCH//\//_}
docker tag privileges quay.io/nyulibraries/privileges:${CIRCLE_BRANCH//\//_}-${CIRCLE_SHA1}

docker push quay.io/nyulibraries/privileges:latest
docker push quay.io/nyulibraries/privileges:${CIRCLE_BRANCH//\//_}
docker push quay.io/nyulibraries/privileges:${CIRCLE_BRANCH//\//_}-${CIRCLE_SHA1}

docker tag privileges_dev quay.io/nyulibraries/privileges_test:latest
docker tag privileges_dev quay.io/nyulibraries/privileges_test:${CIRCLE_BRANCH//\//_}
docker tag privileges_dev quay.io/nyulibraries/privileges_test:${CIRCLE_BRANCH//\//_}-${CIRCLE_SHA1}

docker push quay.io/nyulibraries/privileges_test:latest
docker push quay.io/nyulibraries/privileges_test:${CIRCLE_BRANCH//\//_}
docker push quay.io/nyulibraries/privileges_test:${CIRCLE_BRANCH//\//_}-${CIRCLE_SHA1}

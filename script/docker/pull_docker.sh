#!/bin/sh -ex

docker pull quay.io/nyulibraries/privileges:${CIRCLE_BRANCH//\//_} || docker pull quay.io/nyulibraries/privileges:latest
docker pull quay.io/nyulibraries/privileges:dev-${CIRCLE_BRANCH//\//_} || docker pull quay.io/nyulibraries/privileges:dev-latest
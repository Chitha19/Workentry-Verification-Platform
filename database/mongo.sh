#!/usr/bin/env bash

docker run --rm --name mongo-db  -p 27017:27017 \
  -e MONGO_INITDB_ROOT_USERNAME=faceverify \
  -e MONGO_INITDB_ROOT_PASSWORD=faceverify1234 \
  -v /Users/ukekeilele/Desktop/Coding/flutter/Workentry-Verification-Platform/database/db:/data/db \
  mongo

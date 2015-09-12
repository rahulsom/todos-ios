#!/bin/bash

bundle install
bundle exec pod install

npm install -g appium
appium &

./gradlew -q check

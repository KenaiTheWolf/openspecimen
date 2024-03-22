#!/bin/bash
gradle idea
echo "Installing dependancies, this may take some time."
wait
cd www
wait
npm install @vue/cli
wait
npm install bower
wait
npm install gifsicle@1.0.3
wait
npm install optipng-bin
wait
bower install
wait
grunt build
echo "Begin Deployment."

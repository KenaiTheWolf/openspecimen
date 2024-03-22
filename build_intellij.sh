#!/bin/bash
cd "$(dirname "$0")"
./www/dependancysetup.sh
wait
cd "$(dirname "$0")"
gradle clean
gradle deploy


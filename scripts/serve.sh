#!/bin/bash
 
USAGE="serve.sh [--live-conf]"

# Get command line arguments
CONF="_config.yml"

for i in "$@"
do

case $i in
  -l|--live-conf)
  CONF="_config.yml"
  shift # past argument
  ;;
  -h|--help)
  echo $USAGE
  exit
  shift # past argument
  ;;
esac
done

echo "Serving site on localhost:4000"
echo ""
bundle exec jekyll serve --config ${CONF}

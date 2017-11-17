#!/bin/bash

USAGE="build.sh [--update-articles] [--live] [path/to/destination]"
DESTINATION='_site'
LIVE_DESTINATION='~/WWW'
US=$(pwd)

# Get command line arguments
for i in "$@"
do

case $i in
  -l|--live)
  DESTINATION=$LIVE_DESTINATION
  shift # past argument
  ;;
  -h|--help)
  echo $USAGE
  exit
  shift # past argument
  ;;
  *)
  DESTINATION=$key  # unknown option is destination folder
  ;;
esac
done

if [[ ! -d "${DESTINATION}" ]]; then
  echo "${DESTINATION} is not a directory, aborting"
  exit 1
fi

echo "Installing to ${DESTINATION}"

echo "Checking URLs"
find . -type f -name "*.md" -exec perl -pi -e 's#\(/#\({{ site.baseurl }}/#g' {} \;
find . -type f -name "*.html" -exec perl -pi -e 's#src="/"#src="{{ site.baseurl }}/#g' {} \;
find . -type f -name "*.html" -exec perl -pi -e 's#href="/"#href="{{ site.baseurl }}/#g' {} \;
find . -type f -name "*.md" -exec perl -pi -e 's#src="/"#src="{{ site.baseurl }}/#g' {} \;
find . -type f -name "*.md" -exec perl -pi -e 's#href="/"#href="{{ site.baseurl }}/#g' {} \;

echo "Installing site"
echo ""
bundle exec jekyll build --destination "${DESTINATION}"
if [ $? -eq 0 ]
then
  echo "Site built"
else
  echo "Failed to build site, aborting" >&2
  exit 1
fi

sleep 0.2

echo "Cleaning HTML"
echo ""
cd $DESTINATION
pwd
find . -type f -name "*.html" -exec ${US}/scripts/tidy.sh ${US}/scripts/tidy.conf {} \; 
if [ $? -eq 0 ]
then
  echo "HTML Tidy complete"
  echo ""
else
  echo "Failed to tidy HTML!!!" >&2
fi
 
echo "Gzipping sitemaps"
gzip -k sitemap.xml
gzip -k feed.xml

cd $US

echo Done

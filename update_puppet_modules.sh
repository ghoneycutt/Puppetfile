#!/bin/bash
#
# Simple script to update modules with librarian-puppet-simple and restart
# apache afterward.
#
# 2013 - Garrett Honeycutt - <code@garretthoneycutt.com>
#

LIBRARIAN_DIR=/var/local/puppet-modules
PUPPETFILE=${LIBRARIAN_DIR}/Puppetfile
LIBRARIAN_PUPPET=librarian-puppet
LIBRARIAN_PUPPET_FLAGS='--verbose'
CLEAN_CMD="${LIBRARIAN_PUPPET} clean ${LIBRARIAN_PUPPET_FLAGS}"
INSTALL_CMD="${LIBRARIAN_PUPPET} install ${LIBRARIAN_PUPPET_FLAGS}"

if [ ! -d $LIBRARIAN_DIR ]; then
  echo "LIBRARIAN_DIR (${LIBRARIAN_DIR}) does not exist."
  exit 1
fi

if [ ! -r $PUPPETFILE ]; then
  echo "PUPPETFILE (${PUPPETFILE}) does not exist or is not readable."
  exit 2
fi

cd $LIBRARIAN_DIR

$CLEAN_CMD
if [ $? != 0 ]; then
  echo "Cleaning the library with (${CLEAN_CMD}) did not exit successfully."
  exit 3
fi

$INSTALL_CMD
if [ $? != 0 ]; then
  echo "Installing the library with (${INSTALL_CMD}) did not exit successfully."
  exit 4
fi

service httpd restart
if [ $? != 0 ]; then
  echo "Restarting httpd did not exit successfully."
  exit 5
fi


exit 0

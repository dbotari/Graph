#!/bin/bash

# You may set the following variables inside script, or override corresponding
# variables when running the script
DEFAULT_DSBULK_PATH=/PATH/TO/dsbulk-1.4.2
DEFAULT_DEST_KS=paths_prod

# Allow to override these variables via environment variables set before executing script
DSBULK_PATH=${DSBULK_PATH:-$DEFAULT_DSBULK_PATH}
DEST_KS=${DEST_KS:-$DEFAULT_DEST_KS}

############################################
# Automated data loading 
# Assuming you set DSBULK_PATH and DEST_KS
############################################

# collect directory variables
OLDWD="`pwd`"
SCRIPTDIR="`dirname $0`"
cd "$SCRIPTDIR"

# determine which dsbulk to use, in the case you already have it installed
# the path that is set in the script, takes over the value from PATH
DSBULK=$DSBULK_PATH/bin/dsbulk
if [ ! -f "$DSBULK" ]; then
    DSBULK="`which dsbulk`"
    if [ -z "$DSBULK" ]; then
        echo "Please set DSBULK_PATH variable to top-level path of DSBulk distribution"
        echo "  or add directory with dsbulk to PATH, like, 'PATH=...dsbulk-1.3.4/bin:\$PATH'"
        exit 1
    fi
fi

############################################
# load the vertices
############################################
echo "Loading vertices into the graph $DEST_KS"

$DSBULK load -g $DEST_KS -v Address -url Address.csv -header true

echo "Completed loading vertices into the graph $DEST_KS."

############################################
# load the edges
############################################
echo "Loading edges into the graph $DEST_KS"

$DSBULK load -g $DEST_KS -e rated -from Address -to Address -url rated.csv -header true

echo "Completed loading edges into the graph $DEST_KS."

cd "$OLDWD"

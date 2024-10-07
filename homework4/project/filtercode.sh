#!/bin/bash

# Memorize script name
FILTER_SCRIPTNAME=`basename $0`

###### Functions #######################################################

#   This creates a log where you can see the code running
createlog(){
  FILTER_DATE=`date +%F`
  FILTER_LOGFILE=${FILTER_DATE}_${FILTER_SCRIPTNAME}.log
  touch $FILTER_LOGFILE
  if [[ $? != 0 ]]; then
     echo "cannot write logfile, exiting" 1>&2
     exit 1
  fi
  echo "Redirecting filter logs to $FILTER_LOGFILE"
}

# logging utility
# Adds a timestamp to a log message and writes to file created with createlog
# Usage:
#   log "message"
# If logfile missing use default CLEANER_LOGFILE
log(){
  if [[ "x$FILTER_LOGFILE" == "x" ]]; then
    echo "Undefined variable FILTER_LOGFILE, please check code: createlog() missing. Exiting" 1>&2
    exit 1
  fi
  FILTER_LOGMESSAGE=$1
  FILTER_LOGTIMESTAMP=`date -Iseconds`
  # Create timestamped message
  FILTER_OUTMESSAGE="[${FILTER_LOGTIMESTAMP} Filter]: $FILTER_LOGMESSAGE"
  # Output to screen
  echo $FILTER_OUTMESSAGE
  # Output to file
  echo $FILTER_OUTMESSAGE >> ${FILTER_LOGFILE}
}

###### Functions END =##################################################

# Exit immediately if the cleaningcode.sh script is not found
if [ ! -f 'cleaningcode.sh' ]; then
   echo "cleaningcode.sh script not found in $PWD. Cannot continue. Exiting"
   exit 1
fi
 
# Create logfile
createlog

# Get the first parameter from the command line:
# and put it in the variable FILTER_SMHIINPUT
FILTER_SMHIINPUT=$1

# Input parameter validation:
# Check that the variable FILTER_SMHIINPUT is defined, if not, 
# inform the user, show the script usage by calling the usage() 
# function in the library above and exit with error
# See Tutorial 4 Slide 45-47 and exercises 4.14, 4.15
if [[ "x$FILTER_SMHIINPUT" == 'x' ]]; then
   echo "Missing input file parameter, exiting" 1>&2
   usage
   exit 1
fi

# Extract filename:
# Extract the name of the file using the "basename" command 
# basename examples: https://www.geeksforgeeks.org/basename-command-in-linux-with-examples/
# then store it in a variable FILTER_DATAFILE
FILTER_DATAFILE=$(basename $FILTER_SMHIINPUT)

# Call cleaningcode

log "Calling cleaningcode.sh script"
./cleaningcode.sh $FILTER_SMHIINPUT

if [[ $? != 0 ]]; then
   echo "cleaningcode.sh failed, exiting..." 1>&2
   exit 1
fi

# cleaningcode.sh generates a filename that starts with baredata_<datafilename>
# So storing it in a variable for convenience.
CLEANER_BAREDATAFILENAME="baredata_$FILTER_DATAFILE"

log "Begin filtering..."

# Filtering
# WRITTEN BY ANDREAS PETERSSON, ELLEN BRANDT SAHLBERG, VERENA HEHL

# base output filename for filtering. The name can be changed to something more relevant.
FILTER_FILTEREDFILENAME="filtered_${FILTER_DATAFILE}"
#FILTERS THAT CAN BE USEFULL FOR THE PROJECT


# Select only measurements done over summer
FILTER_FILTERFILENAME_ONLYSUMMER="summer_$FILTER_FILTEREDFILENAME"
log "Filtering on only measurements taken in June, July and August, writing to $CLEANER_FILTERFILENAME_ONLYSUMMER"
if grep '\-\(06\|07\|08\)\-' $CLEANER_BAREDATAFILENAME > $FILTER_FILTERFILENAME_ONLYSUMMER; then
   echo "Filtering for only summer months was successful."
else
   echo "Error: Filtering for summer months failed."
   exit 1
fi 

# Select only measurements done over summer aswell as only taking the good mesurments 
FILTER_FILTERFILENAME_ONLYSUMMERANDG="summerandG_$FILTER_FILTEREDFILENAME"
log "Filtering on only measurements taken in June, July and August, marked as G writing to $CLEANER_FILTERFILENAME_ONLYSUMMERANDG"
if grep '\-\(06\|07\|08\)\-' $CLEANER_BAREDATAFILENAME | grep 'G' > $FILTER_FILTERFILENAME_ONLYSUMMERANDG; then
   echo "Filtering for summer and G only was successful." 
else
   echo "Error: Filtering for summer and G failed."
   exit 1
fi


# Select only measurements with temperature above 25 degrees
FILTER_FILTERFILENAME_ONLYABOVE25="onlyabove25_$FILTER_FILTEREDFILENAME"
log "Filtering only for temperatures above 25 degrees, writing to $FILTER_FILTERFILENAME_ONLYABOVE25"

if awk -F, '$3 > 25 {print $0}' $CLEANER_BAREDATAFILENAME > $FILTER_FILTERFILENAME_ONLYABOVE25; then
   echo "Filtering for above 25 degrees successful."
else 
   echo "Error: Filtering for above 25 degrees failed."
   exit 1
fi 

#Only select the good measurements (marked with G), disregard the measurements marked with Y
FILTER_FILTERFILENAME_ONLYG="onlyG_$FILTER_FILTEREDFILENAME"
log "Filtering on only measurements marked as G, writing to $FILTER_FILTERFILENAME_ONLYG"
if grep 'G' $CLEANER_BAREDATAFILENAME > $FILTER_FILTERFILENAME_ONLYG; then
   echo "Filtering for only G successful."
else 
   echo "Error: Filtering for only G failed."
   exit 1
fi

#Takes the temperature data for three different heights and saves it to three files with the respective dates
#for those heights.

#First we find three numbers for indexing. The lines represent a line with a different height.
line_number=$(grep -m 1 -n "Höjd" $FILTER_SMHIINPUT | cut -d: -f1)
next_line_number1=$((line_number + 1))
next_line_number2=$((line_number + 2))
next_line_number3=$((line_number + 3))

#Saves the height string as a variable
height1=$(sed -n "${next_line_number1}p" $FILTER_SMHIINPUT | cut -d';' -f3)
height2=$(sed -n "${next_line_number2}p" $FILTER_SMHIINPUT | cut -d';' -f3)
height3=$(sed -n "${next_line_number3}p" $FILTER_SMHIINPUT | cut -d';' -f3)

#Checks that we have enough height data to run the filter.
if [[ $height1 == '' ]]; then
   echo "Not enough height data. Needs at least data for 3 different heights." 1>&2
   exit 1
fi

if [[ $height2 == '' ]]; then
   echo "Not enough height data. Needs at least data for 3 different heights." 1>&2
   exit 1
fi

if [[ $height3 == '' ]]; then
   echo "Not enough height data. Needs at least data for 3 different heights." 1>&2
   exit 1
fi

#Saves the filtername
FILTER_FILTERFILENAME_heightfilter1="heightfilter{$height1}_$FILTER_FILTEREDFILENAME"
FILTER_FILTERFILENAME_heightfilter2="heightfilter{$height2}_$FILTER_FILTEREDFILENAME"
FILTER_FILTERFILENAME_heightfilter3="heightfilter{$height3}_$FILTER_FILTEREDFILENAME"

#Logging
log "Filtering dates for the height $height1, writing to $FILTER_FILTERFILENAME_heightfilter1"
log "Filtering dates for the height $height2, writing to $FILTER_FILTERFILENAME_heightfilter2"
log "Filtering dates for the height $height3, writing to $FILTER_FILTERFILENAME_heightfilter3"

#Saves the first dates for each height
start_date1=$(sed -n "${next_line_number1}p" $FILTER_SMHIINPUT | cut -d' ' -f1)
start_date2=$(sed -n "${next_line_number2}p" $FILTER_SMHIINPUT | cut -d' ' -f1)
start_date3=$(sed -n "${next_line_number3}p" $FILTER_SMHIINPUT | cut -d' ' -f1)

#Saves the last dates for each height
end_date1=$(sed -n "${next_line_number1}p" $FILTER_SMHIINPUT | cut -d';' -f2 | cut -d' ' -f1)
end_date2=$(sed -n "${next_line_number2}p" $FILTER_SMHIINPUT | cut -d';' -f2 | cut -d' ' -f1)
end_date3=$(sed -n "${next_line_number3}p" $FILTER_SMHIINPUT | cut -d';' -f2 | cut -d' ' -f1)

#Takes all the dates between start and end date and saves it on the file.
sed -n "/${start_date1}/,/${end_date1}/p" $CLEANER_BAREDATAFILENAME > $FILTER_FILTERFILENAME_heightfilter1 
sed -n "/${start_date2}/,/${end_date2}/p" $CLEANER_BAREDATAFILENAME > $FILTER_FILTERFILENAME_heightfilter2
sed -n "/${start_date3}/,/${end_date3}/p" $CLEANER_BAREDATAFILENAME > $FILTER_FILTERFILENAME_heightfilter3
#!/bin/bash 

# Rules for a good bash script
# Must be run in bash or zsh shell (not sh, not dash)
# Must define the various directories.
# Must generate logs.
# Can print error when there is a programming error.
# Must have a mechanism to exit the program safely.

# 1) Set up Default Variables

# date | time | timestamp

short_date=`date '+%F'`

current_time=`date '+%H%M%S'`

current_timestamp=`date '+%Y%m%d%H%M%S'`


# 2) Set up Paths - need input, output, script, log file path 


export BASE_FOLDER="/home/USERNAME"
export SCRIPT_FOLDER=$BASE_FOLDER"PATH/TO/FOLDER"
export INPUT_FOLDER=$BASE_FOLDER"PATH/TO/FOLDER"
export OUTPUT_FOLDER=$BASE_FODLER"PATH/TO/FOLDER"
export LOG_FOLDER=$BASE_FOLDER"PATH/TO/FOLDER"
export SHELL_NAME=$(basename "$0" | cut -d. -f1) # cuts off extenstion of filename
export LOG_FILE=${LOG_FOLDER}/${SHELL_NAME}_${current_timestamp}.log

# 3) set up log file rules

# https://stackoverflow.com/questions/49509264/explain-the-bash-command-exec-tee-log-file-21

exec > >(tee ${LOG_FILE}) 2>&1 

# 4) cd into the script folder that will run the py script

cd $INPUT_FOLDER
echo $(pwd)

# 5)  Download Data

echo "Starting Data Download" 

start_year=2020
end_year=2023
station_id=48549

echo "start_year: $(start_year)"
echo "end_year: $(end_year)"
echo "station_id: $(station_id)"

# run a loop to parse the years inbetween start and end year

for year in $(seq $start_year $end_year);
do wget  --content-disposition "https://climate.weather.gc.ca/climate_data/bulk_data_e.html?format=csv&stationID=${station_id}&Year=${year}&Month=2&Day=14&timeframe=1&submit= Download+Data";
done;


# $? = returns the last status of command/function with 0 being successful
RC1=$?

if [ ${RC1} != 0 ]; then
	echo "DOWNLOAD FAILED"
	echo "RETURN CODE: ${RC1}"
	exit 1
fi 



# 6) CD to scripts folder run py script and run script 

cd $SCRIPT_FOLDER
python3 climate.py

RC2=$?

if [ ${RC2} != 0 ]; then 
	echo "SCRIPT FAILED"
	echo "RETURN CODE: ${RC2}" 

fi


# 7) exit sh

echo "successful"
exit 0 




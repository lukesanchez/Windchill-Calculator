#!/bin/bash
#Created by: Luke Sanchez
#Last Modified: Oct. 16, 2020

airtemp=0
velocity=0
windchill=0
cin=0
cout=0
filename=""
quiet=0

PARSED_OPTIONS=$(getopt -n "$0"  -o vhcq --long "airtemp:,velocity:,help,version,cin,cout,quiet,file:"  -- "$@")

#Bad arguments, something has gone wrong with the getopt command.
if [ $? -ne 0 ];
then
echo "
Illegal Argument(s)

Usage: windchill --airtemp=<temp> --velocity=<speed> [-c | --cout] [--cin] [--file=<filename>] [-h | --help] [-q | --quiet] [-v | --version]
Try 'windchill --help' for more information.
"
  exit 1
fi

if 

eval set -- "$PARSED_OPTIONS"

while true; do
	case "$1" in

		-h|--help)
		echo "
Wind-Chill Calculator

Usage: windchill --airtemp=<temp> --velocity=<speed> [-c | --cout] [--cin] [--file=<filename>] [-h | --help] [-q | --quiet] [-v | --version]

Arguments
--airtemp=<temp>    The outside air temperature (in Fahrenheit by default)
--velocity=<speed>  The wind speed
-c | --cout         Display the wind-chill value in Celsius rather than Fahrenheit (Fahrenheit output is default)
--cin               The --airtemp value is in Celsius rather than Fahrenheit
--file=<filename>   Write all output to the specified file rather than the command line
-h | --help         Display this message
-q | --quiet        Do not display anything except the answer in the output
-v | --version      Display the version information
"
		exit 0
		shift;;

		-v|--version)
		echo "
Wind-Chill Calculator
Version: 20.10.1
Author: Luke Sanchez
Date: Oct. 15, 2020
"
		exit 0;;

		--airtemp)
		if [ "$2" -ge -58 ] && [ "$2" -le 41 ]
		then
			airtemp="$2";
			shift 2;
		else
			echo "An air temperature of ($2) is out of range [-58 - 41]."
			exit 4;
		fi;;

		--velocity)
		if [ "$2" -ge 2 ] && [ "$2" -le 50 ]
		then
			velocity="$2";
			shift 2;
		else
			echo "Wind speed ($2) is out of range [2 - 50]."
			exit 4;
		fi;;

		--cin)
			cin=1;
			shift;;

		-c|--cout)
			cout=1;
			shift;;

		--file)
			filename="$2";
			shift 2;;

		-q|--quiet)
			quiet=1;
			shift;;

		--)
		shift
		break;;

		*) echo "Unexpected option: $1 - this should not happen."
		exit 1;;
	esac
done

w=$(echo "scale=8; e(0.16 * l($velocity))" | bc -l)

if [ "$filename" != "" ]
then
	touch $filename

	if [ $cin == 1 ]
	then
		airtemp=$(echo "scale=8;((9/5) * $airtemp) + 32" |bc)
	fi

	windchill=`echo "35.74 + (0.6215 * $airtemp) - (35.75 * $w) + (0.4275 * $airte bollp * $w)" | bc`

	if [ $quiet == 1 ] && [ $cout == 1 ]
	then
		windchill=$(echo "scale=8;(5/9)*($windchill-32)"|bc)
		printf "\n%.3f\n\n" "$windchill" > $filename
		exit 0;
	fi

	if [ $quiet == 1 ]
	then
		printf "\n%.3f\n\n" "$windchill" > $filename
		exit 0;
	fi

	printf "\nWind-Chill Calculator\n" > $filename
	if [ $cin == 1 ]
	then
		airtemp=$(echo "scale=8;(5/9)*($airtemp-32)"|bc)
		printf "Outside Air Temperature (C): %.1f\n" "$airtemp" >> $filename
	else
		printf "Outside Air Temperature (F): %.1f\n" "$airtemp" >> $filename
	fi
	printf "Wind Speed: %d\n" "$velocity" >> $filename
	if [ $cout == 1 ]
	then
		windchill=$(echo "scale=8;(5/9)*($windchill-32)"|bc)
		printf "Wind-Chill (C): %.3f\n\n" "$windchill" >> $filename
	else
		printf "Wind-Chill (F): %.3f\n\n" "$windchill" >> $filename
	fi
fi

#If file not present

if [ "$filename" == "" ]
then
	if [ $cin == 1 ]
	then
		airtemp=$(echo "scale=8;((9/5) * $airtemp) + 32" |bc)
	fi

	windchill=`echo "35.74 + (0.6215 * $airtemp) - (35.75 * $w) + (0.4275 * $airtemp * $w)" | bc`

	if [ $quiet == 1 ] && [ $cout == 1 ]
	then
		windchill=$(echo "scale=8;(5/9)*($windchill-32)"|bc)
		printf "\n%.3f\n\n" "$windchill"
		exit 0;
	fi

	if [ $quiet == 1 ]
	then
		printf "\n%.3f\n\n" "$windchill"
		exit 0;
	fi

	printf "\nWind-Chill Calculator\n"
	if [ $cin == 1 ]
	then
		airtemp=$(echo "scale=8;(5/9)*($airtemp-32)"|bc)
		printf "Outside Air Temperature (C): %.1f\n" "$airtemp"
	else
		printf "Outside Air Temperature (F): %.1f\n" "$airtemp"
	fi
	printf "Wind Speed: %d\n" "$velocity"
	if [ $cout == 1 ]
	then
		windchill=$(echo "scale=8;(5/9)*($windchill-32)"|bc)
		printf "Wind-Chill (C): %.3f\n\n" "$windchill"
	else
		printf "Wind-Chill (F): %.3f\n\n" "$windchill"
	fi
fi

exit 0;

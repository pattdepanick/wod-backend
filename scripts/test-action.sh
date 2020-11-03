#!/bin/bash
ACTION=$1
echo "we are working on "$ACTION
if [ _"$1" = _"" ]; then
	echo "Syntax: test-action.sh <CREATE|CLEANUP|RESET>"
	echo "ACTION is mandatory"
	exit -1
fi
shift

# Check action
if [ $ACTION != "CREATE" ]  && [ $ACTION != "CLEANUP" ]  && [ $ACTION != "RESET" ]; then
	echo "Syntax: test-action.sh <CREATE|CLEANUP|RESET>"
	echo "A correct ACTION is mandatory"
	exit -1
fi
(
	echo "MAIL FROM: hpedev.hackshack@hpe.com"
	echo "RCPT TO: jupyter@`hostname`"
	echo "DATA"
	echo "Subject: $ACTION 396 4" 
	echo " "
	echo "WKSHP-API101"
	echo "."
) | telnet localhost 10026

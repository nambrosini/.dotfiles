#!/bin/sh

isNumber='^[0-9]+$'
commitFile="$HOME/.commitMsg"
ticketFile="$HOME/.kafka_ticket.sh"
ticket="KAFKA-"
msg="feat:" 

if [ $1 = 'new' ] || [ $1 = 'n' ]; then
        if [ $# -lt 2 ]; then
                echo 'Not enough arguments'
        fi

        if ! [[ $2 =~ $isNumber ]] ; then
           echo "error: Not a number" >&2; exit 1
        fi

        export TICKET="$ticket$2"
        if [ ! -f $ticketFile ]; then
                touch $ticketFile
        fi
        echo "export TICKET=$TICKET" > $ticketFile
        source $ticketFile
        # Set commit msg
        msg="$msg $TICKET"
        echo $msg > $commitFile
elif [ $1 = 'current' ] || [ $1 = 'c' ]; then
        echo $TICKET
else
        echo 'Command not found' $1
        exit 1
fi

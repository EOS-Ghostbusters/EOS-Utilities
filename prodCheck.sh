#!/bin/bash
PATH=/home/ubuntu/monitoring

MAINNETDIR=/home/ubuntu/monitoring
FILEDIR=/home/ubuntu/monitoring/unpaid_blocks.temp
SERVER_ADDR=<prod1 API>
SERVER_ADDR=<prod2 API>
WALLETPW=
#Signing key of the backup producer
SIGNING_KEY=
TELEGRAM=/home/ubuntu/monitoring/send-telegram.sh

if [[ $1 -eq 1 ]]; then
        echo "Creating blank unpaid_blocks.temp..."
        "-1">$FILEDIR
fi

OLD=$(<$FILEDIR)
echo "Old unpaid_blocks: $OLD"

UNPAID="$(/bin/bash $MAINNETDIR/cleos.sh get table eosio eosio producers -l 1000000 | /bin/grep -A 6 "<producer-name>" | /bin/grep unpaid_blocks | /bin/grep -oP '(?<= )[0-9]+')"
echo $UNPAID > $FILEDIR

if [[ $UNPAID -eq $OLD ]]; then
        echo "Producer is idle. Switching to secondary now..."
	$TELEGRAM "URGENT: Primary producer is idle! Attempting switch over to backup producer now"
        $MAINNETDIR/cleos.sh wallet unlock --password $WALLETPW
	curl -sL $SERVER_ADDR/v1/producer/pause 
        $MAINNETDIR/cleos.sh system regproducer <producer-name> $SIGNING_KEY "<URL>" <country code>
	curl -sL $SERVER_ADDR_2/v1/producer/start
	$MAINNETDIR/cleos.sh wallet lock
fi

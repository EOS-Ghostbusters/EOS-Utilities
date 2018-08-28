#!/bin/bash
NODEOS=/home/ubuntu/eos/build/programs/nodeos/nodeos
DATADIR=/home/ubuntu/trusted
./stop.sh
timestamp=$(/bin/date +%s)
$NODEOS --data-dir $DATADIR --config-dir $DATADIR --verbose-http-errors "$@" > stdout.txt 2> eos-$timestamp.log &  echo $! > nodeos.pid
/bin/rm -f eos.log
/bin/ln -s eos-$timestamp.log eos.log

#!/bin/bash

PATH=/home/ubuntu/trusted
cd $PATH
TIME=$(/bin/date +%s)
/bin/tar -cvf blocks."$TIME".tar ./blocks
/bin/gzip blocks."$TIME".tar
/bin/mv blocks."$TIME".tar.gz ./block-logs
/usr/bin/find $PATH/block-logs -mtime +1 -exec /bin/rm '{}' \;

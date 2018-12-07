#!/bin/bash
ibsDir=/was/logs/ibs/
delLog=$[ibsDir}del.log
diskUsedMax=80
dayCount=30
diskUsed=`df|awk '{if($7 == "/was") print $4}'|awk -F "%" '{print $1}'`
 
_date=`date "+%Y-%m-%d %H:%M:%S"`
 
if [  ! -d "${delLog}" ];then
    touch ${delLog}
    chmod 777 ${delLog}
fi
 
echo "--------begin ${_date}--------">>${delLog}
echo "The following documents satisfy the conditions in ${ibsDir} will clean">>${delLog}
 
while [ diskUsed -gt ${diskUsedMax} -a ${dayCount} -gt 0 ]
do
    ibsLogs=`find ${ibsDir} -name "check*" -type f -mtime +$((dayCount+360))`
    for ibsLog in ${ibsLogs}
    do
        echo "clean ibs log:${ibsLog}">>${delLog}
        rm -f ${ibsLog}
    done
    let dayCount-=1
    diskUsed=`df|awk '{if($7 == "/was") print $4}'|awk -F "%" '{print $1}'`
done

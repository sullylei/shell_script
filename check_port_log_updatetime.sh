#!/bin/bash
flag=1
netstat -n|grep 18305|awk '/^tcp/ {++S[$NF]} END {for(a in S) if(a == "CLOSE_WAIT") print S[a]}' >/tmp/mon29901.txt
a=`cat /tmp/check.txt`
#b=$a"YY"
#echo $a
if [ ! -d "$a" -a $((a*1)) -gt 5 ]
then
	#echo "未检测到29901端口，请系统管理员确认。"
	let flag=0
fi
#echo $flag

t=`date +'%M'`
t1=`date +'%H'`
t1=`expr $t1 + 0`
t2=`date +'%Y%m%d'`.txt
#i=`ls -l /app/logs/monitor/$t2|awk '{print $8}'|awk -F ":" '{print $2}'`
i=`stat "/app/logs/monitor/$(date +%Y%m%d).txt"|awk '$1=="Modify:"{ print $3}'|awk -F ":" '{print $2}'`
#h=`expr $t - $h`
i=`expr $t - $i`
if [ $t1 -ge 8 -a $t1 -lt 24 ] 
then
#  if [ $h -le 5 -o $i -le 5  ]
  if [ $i -le 5 ]
  then
       #echo "OK"
	flag=1
  else
        #echo "ERROR"
	flag=0
  fi

else 
 
# if [ $h -le 30 -o $i -le 30  ]
 if [ $i -le 30 ]
 then
	#echo "OK"
	flag=1
  else
        #echo "ERROR"
	flag=0
  fi
fi

if [ ${flag} -eq 1 ]
then
	echo "OK"
else
	echo "ERROR"
fi

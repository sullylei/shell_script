#!/bin/bash
transferDir=/home/sully/move_test

#transfer day
dayCount=3

#touch transfer log
transferLog=${transferDir}/transfer_to_dir_success.log
if [ ! -f "${transferLog}}" ]
then
        touch ${transferLog}
        chmod 777 ${transferLog}
fi
#控制日期
timeStamp=`date -d "3 days" +%s`
cd ${transferDir}
#当前时间
startTime=`date +'%Y-%m-%d %H:%M:%S'`
#打印开始时间
echo "${startTime} start transfer Dir:${transferDir}" >>${transferLog}
startSeconds=$(date --date="${startTime}" +%s);
#查询需处理的文件
transferFiles=`find ${transferDir} -maxdepth 1 -type f -mtime +${dayCount}`
#逐个文件处理
for transferFile in ${transferFiles}
do
        modifyDate=`stat "${transferFile}"|awk '$1=="Modify:"{print $2}'|awk -F "-" '{print $1""$2""$3}'`
        echo ${transferFile}    
        #get modifyTime second
        modifyDate1=`ls --full-time "${transferFile}"|awk '{print $6}'`
        modifyTime=`ls --full-time "${transferFile}"|awk '{print $7}'|awk -F "." '{print $1}'`
        modifyDateSecond=`date -d "${modifyDate1} ${modifyTime}" +%s`

        #check modify time
        if [ ${modifyDateSecond} -gt ${timeStamp} ]
        then
                echo ${modifyDateSecond}${timeStamp}
                continue
        fi

        #mkdir
        if [ ! -d "${transferDir}/${modifyDate}/" ]
        then
                mkdir -p ${transferDir}/${modifyDate}/
                chmod 774 ${transferDir}/${modifyDate}/
        fi

        #copy file
        mv ${transferFile} ${transferDir}/${modifyDate}/
        echo "move ${transferFile} success" >> ${transferLog}
done
endTime=`date +'%Y-%m-%d %H:%M:%S'`
endSeconds=$(date --date="${endTime}" +%s);
echo "运行时间：" $((endSeconds-startSeconds))"s"

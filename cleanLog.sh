umask 022

#bakdir=/was/bak
bakdir=/hisbackup/test
logdir=$bakdir/logs
todayis=`date +'%Y%m%d%H'`
logfile=$logdir/clear.$todayis.log
filelist=$logdir/file.$todayis.lst
bakfile=$bakdir/logsfile.$todayis.tar

echo " ********BEGIN***** "   >> $logfile

#to find old files in /was/tmp
echo "`date`: find file"        >> $logfile
find /was/tmp -type f -mtime +2 >  $filelist
echo "`date`: find file end"    >> $logfile

echo " *******`date`***** "   >> $logfile
echo " *****before tar***** " >> $logfile
df /was                       >> $logfile
#to tar files found before
echo "`date`: tar file"         >> $logfile
tar -cvf $bakfile -L $filelist  >  /dev/null
ls -ltr  $bakfile               >> $logfile
echo " ** tar ended****  "      >> $logfile
df /was                         >> $logfile
echo "`date`: tar file end"     >> $logfile

#compress tmp.tar
#to compress the tar file created just before
echo "`date`: compress file"       >> $logfile
gzip -9 $bakfile
echo "`date`: compress file end"   >> $logfile
echo " **compress tar file ended****  "  >> $logfile
df /was                                  >> $logfile
echo " ** compress tar file ended****  " >> $logfile

#to delete old files found before
echo "`date`: delete file"     >> $logfile
cat $filelist|xargs rm -f      > /dev/null
gzip $filelist
df /was                        >> $logfile
echo "`date`: delete file end" >> $logfile

#to delete old tar.gz and old file.lst
echo "`date`: delete bak file"                >> $logfile
find $bakdir -mtime +30 -type f | xargs rm -f >  /dev/null
echo "`date`: delete bak file end"            >>$logfile

echo " ** delete old file ended****  " >> $logfile
df /was                                >> $logfile
echo " **delete old file ended****  "  >> $logfile

#to rename file.lst so that things will be become easy 
#whiling looking for a specific tar file
#mv $bakdir/file.lst $bakdir/file.lst.`date +'%Y%m%d'`

echo "`date`: all finish"    >> $logfile
echo " *******`date`***** "  >> $logfile
echo " ********END***** "    >> $logfile
banner Finish                >> $logfile


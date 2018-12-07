#检查端口状态和相应的数量
netstat -n|grep 18305|awk '/^tcp/ {++S[$NF]} END {for(a in S)  print a,S[a]}'

#!/usr/bin/bash
tdnf update -y
tdnf install openjdk8 -y
if ! [ -x "$(command -v gawk)" ]; then
tdnf install gawk -y
else
echo "Already Installed"
fi
PID=`ps -ef | grep java | awk 'NR==1 {print $2}'`
if [[ ! -d /tmp/test ]] ; then
mkdir /tmp/test
else
echo "Directory Exists"
fi
jmap -dump:format=b,file=/tmp/test/HeapDump_jmap.bin "$PID"
jcmd "$PID" GC.heap_dump /tmp/test/HeapDump_jcmd.bin
jstack -l "$PID" > /tmp/test/ThreadDump.txt

exit 0

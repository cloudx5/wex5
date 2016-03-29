#!/bin/sh

cd `dirname $0`
HOME=$PWD
SRC_PATH="/mnt/mesos/sandbox"

echo "当前目录路径为[HOME]：$HOME"

if [ -d "$SRC_PATH/model" ];then
  echo "正在更新 model..."
  rm -rf $HOME/model
  mv -f $SRC_PATH/model $HOME

  echo "model 更新完毕"
  echo ""
else
  echo "APP 源码不完整，无法启动"
  echo "正在结束..."
  exit 1
fi

if [ -d "$SRC_PATH/doc" ];then
  echo "正在更新 doc..."
  rm -rf $HOME/data/doc
  mv -f $SRC_PATH/doc $HOME/data

  echo "doc 更新完毕"
  echo ""
fi

cd $HOME/mysql/bin
./startup.sh &

echo "MySQL 服务启动完毕"
echo ""

sleep 10

load_script(){
  TMP="tmp_script.sql"
  echo "" >$TMP
  for FILE_NAME in `ls -A $1`;do
    if [ -s "$1/$FILE_NAME" ];then
      echo "source $1/$FILE_NAME;" >>$TMP
    fi
  done
  echo "commit;" >>$TMP
  echo "quit" >>$TMP
  echo "" >>$TMP

  cat $TMP

  START_TIME=$(date "+%s")
  ./mysql -uroot -px5 x5 -ve "source $TMP" >/mnt/mesos/sandbox/sqlload.log 2>&1
  if [ $? -eq 0 ];then
    echo "[$?]脚本导入成功！共计用时: " `expr $(date "+%s") - ${START_TIME}` " 秒"
  else
    echo "[$?]脚本导入失败，正在结束..."
    exit 1
  fi
}

FILE_PATH="$SRC_PATH/sql"
file_list=`ls -A $FILE_PATH`
if [ "$file_list" ];then
  echo "开始初始化 SQL 脚本..."
  load_script $FILE_PATH
fi

echo "开始启动 Apache-tomcat 服务"
echo "正在配置服务启动参数..."
tmpstr="<version>`date +%d%M%S`</version>"
sed -i "s#<version>.*</version>#$tmpstr#g" $HOME/conf/server.xml
echo "正在启动 WEB 服务..."
cd $HOME/apache-tomcat/bin
./startup.sh

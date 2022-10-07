#!/bin/bash
set +e

# 后台启动nginx
/usr/sbin/nginx > /dev/null 2>&1

if [ "$ENABLE_MYSQL" = "false" ]; then
   echo "不启用内置MySQL数据库"
   if [ "$(command -v mysqld)" != "" ]; then
      apk del mysql
   fi
   java -jar ${FDD_DIR}/QL-Emotion.jar
else
   echo "即将启用内置MySQL数据库"
   ${FDD_DIR}/mysql.sh

# 检查MySQL是否启动成功
   pid=`ps -ef |grep "mysqld" | grep -v grep | awk '{print $1}'`
   #pid=`pgrep -f mysqld`
   if [ -n "$pid" ] && [ -d ${FDD_DIR}/mysql/${MYSQL_DATABASE} ]; then
      echo "[i] Mysql running successfully!!!"
      if [ ! -s ${FDD_DIR}/config/application.yml ]; then
         echo "检测到${FDD_DIR}/config目录下不存在application.yml配置文件，从示例文件夹中重新复制一份...\n"
         cp -rv ${FDD_DIR}/sample/* ${FDD_DIR}/config/
      fi
      java -jar ${FDD_DIR}/QL-Emotion.jar
   else
      echo "[!] Mysql running unsuccessfully! Please delete "${FDD_DIR#/}/mysql" folder and try again!!!"
   fi
fi

exec "$@"



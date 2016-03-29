#!/bin/sh

cd ..
export mysqlDir=$PWD
cd bin
export PATH=$PWD:$PATH
chmod a-w $mysqlDir/my.ini
chmod a+r+w -R $mysqlDir/data
chown -R mysql:mysql $mysqlDir/data
mysqld_safe --defaults-file=$mysqlDir/my.ini --basedir=$mysqlDir

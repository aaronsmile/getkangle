#!/bin/sh
yum -y install bzip2-devel libxml2-devel curl-devel db4-devel libjpeg-devel libpng-devel freetype-devel pcre-devel zlib-devel sqlite-devel libmcrypt-devel unzip bzip2
yum -y install mhash-devel openssl-devel
yum -y install libtool-ltdl libtool-ltdl-devel
PREFIX="/vhs/kangle/ext/tpl_php-7.2.0"
ZEND_ARCH="i386"
LIB="lib"
if test `arch` = "x86_64"; then
        LIB="lib64"
        ZEND_ARCH="x86_64"
fi

mkdir getkangle-src
cd getkangle-src
wget -c http://php.net/distributions/php-7.2.0.tar.bz2 -O php-7.2.0.tar.bz2
tar xjf php-7.2.0.tar.bz2
cd php-7.2.0
CONFIG_CMD="./configure --prefix=$PREFIX --with-config-file-scan-dir=$PREFIX/etc/php.d --with-libdir=$LIB --enable-fastcgi --with-mysql --with-mysqli --with-pdo-mysql --with-iconv-dir --with-freetype-dir --with-jpeg-dir --with-png-dir --with-zlib --with-libxml-dir=/usr/include/libxml2/libxml --enable-xml --disable-fileinfo --enable-magic-quotes --enable-safe-mode --enable-bcmath --enable-shmop --enable-sysvsem --enable-inline-optimization --with-curl --with-curlwrappers --enable-mbregex --enable-mbstring --enable-ftp --with-gd --enable-gd-native-ttf --with-openssl --enable-pcntl --enable-sockets --with-xmlrpc --enable-zip --enable-soap --with-pear --with-gettext --enable-calendar --with-openssl"
if [ -f /usr/include/mcrypt.h ]; then
        CONFIG_CMD="$CONFIG_CMD --with-mcrypt"
fi
#'./configure' --prefix=$PREFIX --with-config-file-scan-dir=$PREFIX/etc/php.d --with-libdir=$LIB '--enable-fastcgi' '--with-mysql' '--with-mysqli' --with-pdo-mysql '--with-iconv-dir' '--with-freetype-dir' '--with-jpeg-dir' '--with-png-dir' '--with-zlib' '--with-libxml-dir=/usr/include/libxml2/libxml' '--enable-xml' '--disable-fileinfo' '--enable-magic-quotes' '--enable-safe-mode' '--enable-bcmath' '--enable-shmop' '--enable-sysvsem' '--enable-inline-optimization' '--with-curl' '--with-curlwrappers' '--enable-mbregex' '--enable-mbstring' '--enable-ftp' '--with-gd' '--enable-gd-native-ttf' '--with-openssl' '--enable-pcntl' '--enable-sockets' '--with-xmlrpc' '--enable-zip' '--enable-soap' '--with-pear' '--with-gettext' '--enable-calendar'
#'./configure' --prefix=$PREFIX --with-config-file-scan-dir=$PREFIX/etc/php.d --with-libdir=$LIB '--enable-fastcgi' '--with-mysql' '--with-mysqli' --with-pdo-mysql '--with-iconv-dir' '--with-freetype-dir' '--with-jpeg-dir' '--with-png-dir' '--with-zlib' '--with-libxml-dir=/usr/include/libxml2/libxml' '--enable-xml' '--disable-fileinfo' '--enable-magic-quotes' '--enable-safe-mode' '--enable-bcmath' '--enable-shmop' '--enable-sysvsem' '--enable-inline-optimization' '--with-curl' '--with-curlwrappers' '--enable-mbregex' '--enable-mbstring' '--with-mcrypt' '--enable-ftp' '--with-gd' '--enable-gd-native-ttf' '--with-openssl' '--with-mhash' '--enable-pcntl' '--enable-sockets' '--with-xmlrpc' '--enable-zip' '--enable-soap' '--with-pear' '--with-gettext' '--enable-calendar'
$CONFIG_CMD
if test $? != 0; then
	echo $CONFIG_CMD
	echo "configure php error";
	exit 1
fi
make -j 4
make install
mkdir -p $PREFIX/etc/php.d
if [ ! -f $PREFIX/php-templete.ini ]; then
        cp php.ini-dist $PREFIX/php-templete.ini
fi
if [ ! -f $PREFIX/config.xml ]; then
        wget http://github.itzmx.com/bangteng/getkangle/master/php/7.2.0/config.xml -O $PREFIX/config.xml
fi
wget http://github.itzmx.com/bangteng/getkangle/master/php/7.2.0/php-templete.ini -O $PREFIX/php-templete.ini
cd ..
#install ioncube
wget -c http://www.ioncube.com/php-7.2.0-beta-loaders/ioncube_loaders_lin_x86-64_BETA.tar.gz
tar zxf ioncube_loaders_lin_x86-64_BETA.tar.gz
mkdir -p $PREFIX/ioncube
mv ioncube_loader_lin_7.2_10.1.0_beta.so $PREFIX/ioncube/ioncube_loader_lin_7.2_10.1.0_beta.so
#install apcu
wget -c http://pecl.php.net/get/apcu-5.1.8.tgz
tar zxf apcu-5.1.8.tgz
cd apcu-5.1.8
/vhs/kangle/ext/tpl_php-7.2.0/bin/phpize
./configure --with-php-config=/vhs/kangle/ext/tpl_php-7.2.0/bin/php-config
make -j 4
make install
cd ..
#install libmemcached
wget -c --no-check-certificate https://launchpad.net/libmemcached/1.0/1.0.18/+download/libmemcached-1.0.18.tar.gz
tar zxf libmemcached-1.0.18.tar.gz
cd libmemcached-1.0.18
./configure
make -j 4
make install
cd ..
#install memcached
wget -c --no-check-certificate https://github.com/php-memcached-dev/php-memcached/archive/master.tar.gz -O php-memcached-master.tar.gz
tar zxf php-memcached-master.tar.gz
cd php-memcached-master
/vhs/kangle/ext/tpl_php-7.2.0/bin/phpize
./configure --with-php-config=/vhs/kangle/ext/tpl_php-7.2.0/bin/php-config --disable-memcached-sasl
make -j 4
make install
cd ..
/vhs/kangle/bin/kangle -r
#/bin/bash
yum -y install wget epel-release
echo "timeout=120" >> /etc/yum.conf
yum -y install http://www.percona.com/downloads/percona-release/redhat/0.1-4/percona-release-0.1-4.noarch.rpm
yum -y install which file wget make automake gcc gcc-c++ pcre-devel zlib-devel openssl-devel sqlite-devel quota unzip bzip2 libevent-devel
ulimit -n 1048576
echo "* soft nofile 1048576" >> /etc/security/limits.conf
echo "* hard nofile 1048576" >> /etc/security/limits.conf
yum -y install Percona-Server-server-56
rm -rf /etc/my.cnf
wget http://github.itzmx.com/bangteng/getkangle/master/mysql/my.cnf -O /etc/my.cnf
service mysql restart
wget http://github.itzmx.com/bangteng/getkangle/master/shell/ep.el6.sh -O ep.el6.sh;sh ep.el6.sh
rm -rf /vhs/kangle/ext/tpl_php52/php-templete.ini
wget http://github.itzmx.com/bangteng/getkangle/master/easypanel/php-templete.ini -O /vhs/kangle/ext/tpl_php52/php-templete.ini
rm -rf /vhs/kangle/ext/tpl_php52/etc/php-node.ini
wget http://github.itzmx.com/bangteng/getkangle/master/easypanel/php-node.ini -O /vhs/kangle/ext/tpl_php52/etc/php-node.ini
yum -y install memcached php-pecl-memcache
yum -y install php-pecl-apc
rm -rf /etc/sysconfig/memcached
wget http://github.itzmx.com/bangteng/getkangle/master/memcached/memcached -O /etc/sysconfig/memcached
service memcached start
chkconfig --level 2345 memcached on
echo "127.0.0.1 download.safedog.cn" >> /etc/hosts
setenforce 0
wget http://github.itzmx.com/bangteng/getkangle/master/safedog/safedog_linux64.tar.gz
tar xzf safedog_linux64.tar.gz
cd safedog_linux64
chmod -R 777 install.py
./install.py
sdcmd webflag 0
sdcmd twreuse 1
sdcmd sshddenyflag 1
cd ..
#!/bin/bash

#关闭防火墙
systemctl disable firewalld
systemctl stop firewalld

#关闭selinux
setenforce 0
#永久关闭
sed -i "s/SELINUX=enforcing/SELINUX=disabled/" /etc/sysconfig/selinux
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config

#禁用swap
swapoff -a
#永久禁用
sed -i "s/.*swap.*/#&/" /etc/fstab

#修改内核参数
cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

#重新加载配置文件
sysctl --system

## 查看源
yum repolist
## 安装阿里源
cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/default_CentOS-Base.repo 
curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-8.repo
yum makecache



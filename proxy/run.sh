#!bin/sh

# 这行命令可以在运行过程中出现任何错误时终止服务
set -e

# envsubst用来替换之前设定的环境值 ${...} 替换通过template文件替换conf文件
envsubst < /etc/nginx/default.conf.tpl > /etc/nginx/conf.d/default.conf
# 让nginx不要用后台模式运行docker的好处就在于可以让这些后台程序在前台运行,log可以直接出现在docker log内
nginx -g 'daemon off;'
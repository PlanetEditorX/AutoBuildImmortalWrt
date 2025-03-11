#!/bin/bash
# Log file for debugging
LOGFILE="/tmp/uci-defaults-log.txt"

# 输出调试信息
echo "$(date '+%Y-%m-%d %H:%M:%S') - 安装插件..."

# 定义所需安装的包列表 下列插件你都可以自行删减
opkg update
opkg install curl luci-i18n-diskman-zh-cn luci-i18n-firewall-zh-cn luci-app-argon-config luci-i18n-argon-config-zh-cn luci-i18n-package-manager-zh-cn luci-i18n-ttyd-zh-cn luci-i18n-passwall-zh-cn luci-app-openclash luci-i18n-homeproxy-zh-cn openssh-sftp-server fdisk script-utils luci-i18n-samba4-zh-cn

# 构建镜像
echo "$(date '+%Y-%m-%d %H:%M:%S') - Building image with the following packages:"
echo "$PACKAGES"

echo "$(date '+%Y-%m-%d %H:%M:%S') - Build completed successfully."

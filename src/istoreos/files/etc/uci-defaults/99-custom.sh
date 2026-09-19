#!/bin/sh
# iStoreOS 容器首次启动时运行的脚本（位于 /etc/uci-defaults/99-custom.sh）
# 作用：设置容器单网卡 eth0 为静态IP，便于 macvlan 网络直接访问
LOGFILE="/tmp/uci-defaults-log.txt"
echo "Starting iStoreOS 99-custom.sh at $(date)" >> $LOGFILE

# 允许所有网口访问 WebUI
uci set firewall.@zone[1].input='ACCEPT'

# 统计物理网卡数量
count=0
ifnames=""
for iface in /sys/class/net/*; do
   iface_name=$(basename "$iface")
   if [ -e "$iface/device" ] && echo "$iface_name" | grep -Eq '^eth|^en'; then
      count=$((count + 1))
      ifnames="$ifnames $iface_name"
   fi
done
ifnames=$(echo "$ifnames" | awk '{$1=$1};1')
echo "physical ifaces: $ifnames" >> $LOGFILE

# 自定义网络（由构建 workflow 的 IPADDR/GATEWAY 变量注入）
custom_ip="192.168.1.3"
custom_gateway="192.168.1.2"
[ -n "$IPADDR" ] && custom_ip="$IPADDR"
[ -n "$GATEWAY" ] && custom_gateway="$GATEWAY"

# 单网口（容器/NAS 场景）：静态IP 绑 eth0，便于 macvlan 直达
if [ "$count" -ge 1 ]; then
   uci set network.lan.device='eth0'
   uci set network.lan.proto='static'
   uci set network.lan.ipaddr=$custom_ip
   uci set network.lan.gateway=$custom_gateway
   uci set network.lan.netmask='255.255.255.0'
   uci set network.lan.dns='223.5.5.5 1.1.1.1'
   uci delete network.wan 2>/dev/null
   echo "set lan static $custom_ip gw $custom_gateway at $(date)" >> $LOGFILE
fi

# 所有网口可访问网页终端与 SSH
uci delete ttyd.@ttyd[0].interface 2>/dev/null
uci set dropbear.@dropbear[0].Interface='' 2>/dev/null
uci commit

# 标记编译作者
FILE_PATH="/etc/openwrt_release"
[ -f "$FILE_PATH" ] && sed -i "s/DISTRIB_ID='[^']*'/DISTRIB_ID='iStoreOS'/" "$FILE_PATH"

exit 0
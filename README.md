# AutoBuildImmortalWrt
[![Github](https://img.shields.io/badge/RELEASE-%20AutoBuildImmortalWrt-123456?logo=github&logoColor=fff&labelColor=green&style=flat)](https://github.com/PlanetEditorX/AutoBuildImmortalWrt/releases)
[![Github](https://img.shields.io/badge/Docker%20Hub-%20yexundao/immortalwrt-blue?logo=docker)](https://hub.docker.com/repository/docker/yexundao/immortalwrt/tags)
[![GitHub](https://img.shields.io/github/license/PlanetEditorX/AutoBuildImmortalWrt.svg?label=LICENSE&logo=github&logoColor=%20)](https://github.com/PlanetEditorX/AutoBuildImmortalWrt/blob/main/LICENSE)

## fnOS使用
### 1.新建虚拟机，选择一个空的iso启动镜像，并设置uefi、cpu核心、内存等配置
- 创建空iso：``` touch test.iso ```

### 2.添加磁盘空间
- 选择创建的空iso文件

### 3.查看虚拟机详情，查看存储空间的路径
- 例如：```/vol1/vm/pool/5c4906c0-e2aa-4f31-9c4f-ab5e5b35fa35-fo34```

### 4.下载immortalwrt-24.10.0-x86-64-generic-squashfs-combined-efi.qcow2.gz
- 解压得到qcow2文件

### 5.上传qcow2文件到fnOS服务器上

### 6.移动该文件作为为虚拟机的存储空间
- 例如：```mv immortalwrt-24.10.0-x86-64-generic-squashfs-combined-efi.qcow2 /vol1/vm/pool/5c4906c0-e2aa-4f31-9c4f-ab5e5b35fa35-fo34```
### 7.启动，并通过ip地址访问
- 在发布页的固件地址查看管理ip，例如：```固件地址: 192.168.1.100```

---
# docker如何使用immortalwrt
## 一、设置网络
### 1.查看网卡名称，一般为eth0
  ```bash
  ip link show
  ```

### 2. Docker 中创建一个 macvlan 网络
  ```bash
  docker network create -d macvlan \
  --subnet=192.168.1.0/24 \
  --gateway=192.168.1.2 \
  -o parent=eth0 \
  macnet
  ```
  - `--subnet`：指定容器使用的子网，192.168.1.x的网段
  - `--gateway`：容器默认网关，192.168.1.2根据需求更改
  - `-o parent`：指定物理网卡接口，通常是eth0

### 3. 打印docker中的macvlan网络是否创建成功
  ```bash
  docker network ls
  ```
- 创建成功会增加一条网络
  ```bash
  NETWORK ID     NAME             DRIVER    SCOPE
  xxxxxxxxxxxx   macnet           macvlan   local
  ```

### 4.创建虚拟接口
  - macvlan 的一个特性是宿主机无法直接与容器通信。如果你的需求是让宿主机与 OpenWrt 容器通信，你需要在宿主机上创建一个虚拟接口（通常称为 macvlan 子接口），并将其加入同一 macvlan 网络。
    ```bash
    ip link add macvlan-shim link eth0 type macvlan mode bridge
    ip addr add 192.168.1.11/24 dev macvlan-shim
    ip link set macvlan-shim up
    ```

### 5.拉取镜像
  - latest/arm：最新arm版本
    ```bash
    docker pull yexundao/immortalwrt:latest
    ```
    或
    ```bash
    docker pull yexundao/immortalwrt:arm
    ```
  - amd：最新amd版本
    ```bash
    docker pull yexundao/immortalwrt:amd
    ```

### 6.创建容器
  ```bash
  docker run --name immortalwrt -d --network macnet --privileged --device=/dev/net/tun --cap-add=NET_ADMIN --restart=always yexundao/immortalwrt:latest /sbin/init
  ```
  - 默认为arm版本，启动后通过管理IP直接使用，无需后续操作

### 7.进入容器
  ```bash
  docker exec -it immortalwrt sh
  ```

---
## 安装Nikki
- 官方：https://github.com/nikkinikki-org/OpenWrt-nikki
- 教程：https://www.qichiyu.com/379.html

### 1.Add Feed(需要网络环境)
```bash
curl -s -L https://github.com/nikkinikki-org/OpenWrt-nikki/raw/refs/heads/main/feed.sh | ash
```
或使用前置代理
```bash
curl -s -L https://gh-proxy.com/https://github.com/nikkinikki-org/OpenWrt-nikki/raw/refs/heads/main/feed.sh | ash
```

### 2.Install
```bash
opkg install nikki
opkg install luci-app-nikki
opkg install luci-i18n-nikki-zh-cn
```

### 3.替换配置文件(可选)
- 下载：[```https://raw.githubusercontent.com/PlanetEditorX/AutoBuildImmortalWrt/refs/heads/main/src/nikki```](https://raw.githubusercontent.com/PlanetEditorX/AutoBuildImmortalWrt/refs/heads/main/src/config/nikki)
- 使用hfs传递文件：```curl http://192.168.1.x/nikki > nikki```
- 或通过其它方式传递nikki文件
- 替换`/etc/config/nikki`
- 到`网络`→`DHCP/DNS`→`常规`中关闭`DNS重定向`，避免`nikki`和`Dnsmasq`重复DNS劫持

### 4.配置文件中添加订阅并更新
- 插件配置中选择配置文件后启动

---
## clash 模板
https://github.com/PlanetEditorX/subconverter/raw/refs/heads/master/base/config/ACL4SSR_Online_Full_AdblockPlus.ini

---
## OpenClash-设置方案
https://github.com/Aethersailor/Custom_OpenClash_Rules/wiki/OpenClash-%E8%AE%BE%E7%BD%AE%E6%96%B9%E6%A1%88


---
## shellclash
- 手动下载config.yaml文件并上传到/tmp
- 复制clash_meta
  ```bash
  cp /etc/openclash/core/clash_meta /tmp/clash_meta
  ```
- crash启动

---
## ImmortalWrt 软件仓库镜像使用
https://help.mirrors.cernet.edu.cn/immortalwrt/

---
## 如何查询都有哪些插件?
https://mirrors.sjtug.sjtu.edu.cn/immortalwrt/releases/23.05.4/packages/aarch64_cortex-a53/luci/ <br>
https://mirrors.sjtug.sjtu.edu.cn/immortalwrt/releases/23.05.4/packages/x86_64/luci/

---
## ❤️其它GitHub Action项目推荐🌟
https://github.com/wukongdaily/RunFilesBuilder<br>
https://github.com/wukongdaily/DockerTarBuilder

---
## ❤️如何构建docker版ImmortalWrt
https://wkdaily.cpolar.top/15

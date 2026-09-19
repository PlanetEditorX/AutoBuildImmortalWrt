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
  - arm：最新arm版本
    ```bash
    docker pull yexundao/immortalwrt-arm:latest
    ```
  - amd：最新amd版本
    ```bash
    docker pull yexundao/immortalwrt-amd:latest
    ```

### 6.创建容器
  - arm版本
  ```bash
  docker run --name immortalwrt -d --network macnet --privileged --device=/dev/net/tun --cap-add=NET_ADMIN --restart=unless-stopped yexundao/immortalwrt-arm:latest /sbin/init
  ```
  - amd版本
  ```bash
  docker run --name immortalwrt -d --network macnet --privileged --device=/dev/net/tun --cap-add=NET_ADMIN --restart=unless-stopped yexundao/immortalwrt-amd:latest /sbin/init
  ```
  - 启动后通过管理IP直接使用，无需后续操作

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
https://github.com/PlanetEditorX/subconverter/raw/refs/heads/master/base/config/openclash.ini

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

---

# iStoreOS（Docker 版）

> 基于官方 iStoreOS **imagebuilder** 构建，自动跟踪 koolcenter 最新版本（armsr-armv8 / x86-64 双架构），产物推送到 Docker Hub，并可按需上传固件镜像到 GitHub Release。

## 文件结构

```
.github/workflows/build-istoreos-24.10.yml   ← iStoreOS 构建 workflow
src/istoreos/Dockerfile                       ← from scratch + rootfs
src/istoreos/files/etc/uci-defaults/99-custom.sh  ← 首次启动配置静态IP
```

## 前置条件（GitHub 仓库 Secrets）

在 `Settings → Secrets and variables → Actions` 配置：

| Secret | 说明 |
|--------|------|
| `DOCKER_USERNAME` | Docker Hub 用户名（推镜像用） |
| `DOCKER_PASSWORD` | Docker Hub Token/密码 |

`GITHUB_TOKEN` 自动提供。配置后到 `Actions` 标签页 **Run workflow** 即可；也可每周一 18:00（北京）自动触发。

> 注意：本 workflow 与 `build-immortalwrt-24.10-matrix.yml` 可并存，二者独立构建、互不影响。

## 目标产物

- **arm**（aarch64）：`DOCKER_USERNAME/istoreos-arm:latest` + 版本号
- **amd**（x86_64）：`DOCKER_USERNAME/istoreos-amd:latest` + 版本号

workflow 编译时默认把 `lan` 配成**单网卡静态 IP**（可在 Run workflow 输入 `IPADDR`/`GATEWAY`），容器起来即可用。

---

## 一、部署（macvlan 网络）

### 1. 创建 macvlan 网络
```bash
docker network create -d macvlan \
  --subnet=192.168.1.0/24 \
  --gateway=192.168.1.2 \
  -o parent=eth0 \
  istoreos_net
```
- `--gateway`：改成你的路由器真实地址
- `-o parent`：宿主机网卡名，通常是 `eth0`

### 2. 拉取镜像
```bash
# arm（aarch64，如本盒 B3 Pro）
docker pull DOCKER_USERNAME/istoreos-arm:latest
# amd（x86_64）
docker pull DOCKER_USERNAME/istoreos-amd:latest
```

### 3. 创建容器
```bash
docker run -d --name istoreos \
  --network istoreos_net --ip 192.168.1.203 \
  --privileged --restart unless-stopped \
  DOCKER_USERNAME/istoreos-arm:latest /sbin/init
```
- `--ip`：指定容器在 macvlan 网络的静态地址（需与网络同网段、避开路由 DHCP）
- `--privileged`：OpenWRT/iStoreOS 管理网络必须

### 4. 验证
```bash
# 局域网设备访问管理面
curl -I http://192.168.1.203
# 或浏览器打开 http://192.168.1.203  （默认 root，无密码/视镜像）
```

### 5.（可选）宿主与容器通信
macvlan 的宿主默认无法直连容器，若需在盒子上直接访问：
```bash
ip link add macvlan-shim link eth0 type macvlan mode bridge
ip addr add 192.168.1.11/24 dev macvlan-shim
ip link set macvlan-shim up
```

---

## 二、模块化管理
- 登录 LuCI 后，在 **iStore 软件中心** 一键安装路由器插件（OpenClash、PassWall、AdGuard、内网穿透等），比逐个 opkg 更便捷。
- 容器数据默认在内存，如需持久化配置，可挂载 overlay 卷：
  ```bash
  # 重建时加 -v /data/docker/istoreos:/overlay
  ```

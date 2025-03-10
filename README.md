# AutoBuildImmortalWrt
[![GitHub](https://img.shields.io/github/license/wukongdaily/AutoBuildImmortalWrt.svg?label=LICENSE&logo=github&logoColor=%20)](https://github.com/wukongdaily/AutoBuildImmortalWrt/blob/master/LICENSE)
![GitHub Stars](https://img.shields.io/github/stars/wukongdaily/AutoBuildImmortalWrt.svg?style=flat&logo=appveyor&label=Stars&logo=github)
![GitHub Forks](https://img.shields.io/github/forks/wukongdaily/AutoBuildImmortalWrt.svg?style=flat&logo=appveyor&label=Forks&logo=github) [![Github](https://img.shields.io/badge/RELEASE:AutoBuildImmortalWrt-123456?logo=github&logoColor=fff&labelColor=green&style=flat)](https://github.com/wukongdaily/AutoBuildImmortalWrt/releases) [![Bilibili](https://img.shields.io/badge/Bilibili-123456?logo=bilibili&logoColor=fff&labelColor=fb7299)](https://www.bilibili.com/video/BV1EG6VYCER3) [![操作步骤](https://img.shields.io/badge/YouTube-123456?logo=youtube&labelColor=ff0000)](https://youtu.be/xIVtUwZR6U0)

## 🤔 这是什么？
它是一个工作流。可快速构建 带docker且支持自定义固件大小的 immortalWrt
> 1、支持自定义固件大小 默认1GB <br>
> 2、支持预安装docker（可选）<br>
> 3、新增用户预设置pppoe拨号功能<br>


## 如何查询都有哪些插件?
https://mirrors.sjtug.sjtu.edu.cn/immortalwrt/releases/23.05.4/packages/aarch64_cortex-a53/luci/ <br>
https://mirrors.sjtug.sjtu.edu.cn/immortalwrt/releases/23.05.4/packages/x86_64/luci/

## ❤️其它GitHub Action项目推荐🌟 （建议收藏）⬇️
https://github.com/wukongdaily/RunFilesBuilder<br>
https://github.com/wukongdaily/DockerTarBuilder

## ❤️如何构建docker版ImmortalWrt（建议收藏）⬇️
https://wkdaily.cpolar.top/15
## fnOS使用
### 1.新建虚拟机，选择一个空的iso启动镜像，并设置uefi、cpu核心、内存等配置
- 创建空iso：``` touch test.iso ```
### 2.添加磁盘空间
### 3.查看虚拟机详情，查看存储空间的路径
- 比如：```bash /vol1/vm/pool/5c4906c0-e2aa-4f31-9c4f-ab5e5b35fa35-fo34```
### 4.下载immortalwrt-24.10.0-x86-64-generic-squashfs-combined-efi.qcow2.gz
- 解压得到qcow2文件
### 5.上传qcow2文件到fnOS服务器上
### 6.移动该文件作为为虚拟机的存储空间
- 比如：```bash mv immortalwrt-24.10.0-x86-64-generic-squashfs-combined-efi.qcow2 /vol1/vm/pool/5c4906c0-e2aa-4f31-9c4f-ab5e5b35fa35-fo34```
### 7.启动，并通过ip地址访问

#! /bin/bash
# Copyright (C) Juewuy

[ -z "$url" ] && url="https://fastly.jsdelivr.net/gh/juewuy/ShellCrash@master"
type bash &>/dev/null && shtype=bash || shtype=sh
echo='echo -e'
[ -n "$(echo -e | grep e)" ] && {
	echo "\033[31m不支持dash环境安装！请先输入bash命令后再运行安装命令！\033[0m"
	exit
}

echo "***********************************************"
echo "**                 欢迎使用                  **"
echo "**                ShellCrash                 **"
echo "**                             by  Juewuy    **"
echo "***********************************************"
#内置工具
dir_avail() {
	df $2 $1 | awk '{ for(i=1;i<=NF;i++){ if(NR==1){ arr[i]=$i; }else{ arr[i]=arr[i]" "$i; } } } END{ for(i=1;i<=NF;i++){ print arr[i]; } }' | grep -E 'Ava|可用' | awk '{print $2}'
}
setconfig() {
	configpath=$CRASHDIR/configs/ShellCrash.cfg
	[ -n "$(grep ${1} $configpath)" ] && sed -i "s#${1}=.*#${1}=${2}#g" $configpath || echo "${1}=${2}" >>$configpath
}
webget() {
	#参数【$1】代表下载目录，【$2】代表在线地址
	#参数【$3】代表输出显示，【$4】不启用重定向
	if curl --version >/dev/null 2>&1; then
		[ "$3" = "echooff" ] && progress='-s' || progress='-#'
		[ -z "$4" ] && redirect='-L' || redirect=''
		result=$(curl -w %{http_code} --connect-timeout 5 $progress $redirect -ko $1 $2)
		[ -n "$(echo $result | grep -e ^2)" ] && result="200"
	else
		if wget --version >/dev/null 2>&1; then
			[ "$3" = "echooff" ] && progress='-q' || progress='-q --show-progress'
			[ "$4" = "rediroff" ] && redirect='--max-redirect=0' || redirect=''
			certificate='--no-check-certificate'
			timeout='--timeout=3'
		fi
		[ "$3" = "echoon" ] && progress=''
		[ "$3" = "echooff" ] && progress='-q'
		wget $progress $redirect $certificate $timeout -O $1 $2
		[ $? -eq 0 ] && result="200"
	fi
}
error_down() {
	$echo "请参考 \033[32mhttps://github.com/juewuy/ShellCrash/blob/master/README_CN.md"
	$echo "\033[33m使用其他安装源重新安装！\033[0m"
}
#安装及初始化
gettar() {
	webget /tmp/ShellCrash.tar.gz "$url/bin/ShellCrash.tar.gz"
	if [ "$result" != "200" ]; then
		if [ -f ./ShellCrash.tar.gz ]; then
			echo "ShellCrash.tar.gz文件本地存在"
			cp ShellCrash.tar.gz /tmp/ShellCrash.tar.gz
		else
			$echo "\033[33m文件下载失败！\033[0m"
			error_down
			exit 1
		fi
	fi
	$CRASHDIR/start.sh stop 2>/dev/null
	#解压
	echo -----------------------------------------------
	echo 开始解压文件！
	mkdir -p $CRASHDIR >/dev/null
	tar -zxf '/tmp/ShellCrash.tar.gz' -C $CRASHDIR/ || tar -zxf '/tmp/ShellCrash.tar.gz' --no-same-owner -C $CRASHDIR/
	if [ -s $CRASHDIR/init.sh ]; then
		. $CRASHDIR/init.sh >/dev/null || $echo "\033[33m初始化失败，请尝试本地安装！\033[0m"
	else
		rm -rf /tmp/ShellCrash.tar.gz
		$echo "\033[33m文件解压失败！\033[0m"
		error_down
		exit 1
	fi
}
setdir() {
	echo -----------------------------------------------
	$echo "\033[33m注意：安装ShellCrash至少需要预留约1MB的磁盘空间\033[0m"
	#设置目录
	$echo " 在\033[32m/etc目录\033[0m下安装"
	dir=/etc
	echo -----------------------------------------------
	if [ ! -w $dir ]; then
		$echo "\033[31m没有$dir目录写入权限！请重新设置！\033[0m" && sleep 1 && setdir
	else
		$echo "目标目录\033[32m$dir\033[0m空间剩余：$(dir_avail $dir -h)"
		CRASHDIR=$dir/ShellCrash || setdir
	fi
}
install() {
	echo -----------------------------------------------
	echo 开始从服务器获取安装文件！
	echo -----------------------------------------------
	# 下载文件
	gettar
	echo -----------------------------------------------
	echo ShellCrash 已经安装成功!
	[ "$profile" = "~/.bashrc" ] && echo "请执行【. ~/.bashrc &> /dev/null】命令以加载环境变量！"
	[ -n "$(ls -l /bin/sh | grep -oE 'zsh')" ] && echo "请执行【. ~/.zshrc &> /dev/null】命令以加载环境变量！"
	echo -----------------------------------------------
	$echo "\033[33m输入\033[30;47m crash \033[0;33m命令即可管理！！！\033[0m"
	echo -----------------------------------------------
}

# https://fastly.jsdelivr.net/gh/juewuy/ShellCrash@master
echo "URL=$url"
#获取版本信息
webget /tmp/version "$url/bin/version" echooff
echo "Version Info:"
cat "/tmp/version"
[ "$result" = "200" ] && versionsh=$(cat /tmp/version | grep "versionsh" | awk -F "=" '{print $2}')
rm -rf /tmp/version

#输出
$echo "最新版本：\033[32m$versionsh\033[0m"
echo -----------------------------------------------

if [ -n "$CRASHDIR" ]; then
	echo -----------------------------------------------
	$echo "检测到旧的安装目录\033[36m$CRASHDIR\033[0m，是否覆盖安装？"
	$echo "\033[32m覆盖安装时不会移除配置文件！\033[0m"
	read -p "覆盖安装/卸载旧版本？(1/0) > " res
	if [ "$res" = "1" ]; then
		install
	elif [ "$res" = "0" ]; then
		rm -rf $CRASHDIR
		echo -----------------------------------------------
		$echo "\033[31m 旧版本文件已卸载！\033[0m"
		setdir
		install
	elif [ "$res" = "9" ]; then
		echo 测试模式，变更安装位置
		setdir
		install
	else
		$echo "\033[31m输入错误！已取消安装！\033[0m"
		exit 1
	fi
else
	setdir
	install
fi
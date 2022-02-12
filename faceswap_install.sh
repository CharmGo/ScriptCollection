#!/bin/bash

# 自定义变量
nowpath=`pwd`
content="#!/bin/bash \n
source ./venv_facewsap/bin/activate && python3 ./faceswap/faceswap.py gui
"


# 检查执行权限
function checkPermissions(){
	pre=id -u
	if [ $pre -gt 0 ];then
		echo -e "\033[31m请使用root权限运行\033[0m"
		exit
	fi
}


# 检查安装环境
function checkEnv(){
	# ======================================以下是检查git
	if [ -x /bin/git ];
	then
		echo -e "\033[34mgit已安装,将提取faceswap\033[0m"
		git clone --depth 1 https://github.com/deepfakes/faceswap.git
	else
		echo -e "\033[33m未安装git\033[0m"
		read -p "是否安装git[y/N]" choosgit
		if [ $choosgit = 'y' | $choosgit = 'Y' ];
			then
				sudo apt install git
			else
				echo -e "\033[31mgit未安装\033[0m"
				exit 0;
		fi
	fi

	# ======================================以下是检查py3
	if [ -x /bin/python3 ];
	then
		echo -e "\033[34mpython3已安装，将创建python虚拟环境\033[0m"
		python3 -m venv ./venv_facewsap
	else
		echo -e "\033[33m未安装python3\033[0m"
		read -n1 -p "是否安装python3[y/N]" choospy3
		if [ $choospy3 = 'y' | $choospy3 = 'Y' ]
			then
				sudo apt install python3 python3-tk
			else
				exit 0;
		fi
	fi
}

function install(){
	# sudo apt install python3-tk
	if [ -f ./venv_facewsap/bin/activate ];
		then
			echo -e "\033[34mpython虚拟环境已创建\033[0m"
			source ./venv_facewsap/bin/activate
		else
			echo -e "\033[31m未创建python3虚拟环境\033[0m"
			exit 0
	fi

	if [ -f ./faceswap/faceswap.py ];
		then
			echo -e "\033[34m已拉取faceswap项目\033[0m"
		else
			echo -e "\033[31m未已拉取faceswap项目\033[0m"
			exit 0
	fi

	source venv_facewsap/bin/activate
	
	echo -e "\033[35m用户选择：\033[0m"
	read -p "1.Nvidia GPU;2.AMD GPU;3.CPU[1/2/3]" user
	
	case $user in
		1) pip install -r ./faceswap/requirements_nvidia.txt
		;;
		2) pip install -r ./faceswap/requirements_amd.txt
		;;
		3) pip install -r ./faceswap/requirements_cpu.txt
		;;
		*) echo -e "\033[31m选择错误退出安装";
			exit 0
		;;
	esac
}

# 创建桌面软链接
function createSetupScript(){
    echo -e $content > setupFSgui.sh
    sudo chmod 755 setupFSgui.sh
    
    if [ -d ~/Desktop ]
        then
	ln -s $nowpath/setupFSgui.sh ~/Desktop
    elif [ -d ~/桌面 ]
        then    
	ln -s $nowpath/setupFSgui.sh ~/桌面
    fi
}

case $1 in
	''|"help")
		echo -e "\033[33m执行路径为：${nowpath} \033[0m"
		echo "$0 help 帮助信息"
		echo "$0 chenv 检查安装环境并拉取程序"
		echo "$0 install 开始安装"
		echo "$0 ln 创建桌面软链接"
	;;
	"chenv")
		echo "检查安装环境"
		checkEnv
	;;
	"install")
		install
	;;
	"ln") createSetupScript
	;;
esac

# checkPermissions
# checkEnv
# install
#ln 

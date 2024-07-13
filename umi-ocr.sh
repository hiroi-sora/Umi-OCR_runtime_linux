#!/bin/bash

# 确保工作目录为脚本所在目录
cd $(dirname ${BASH_SOURCE[0]})
# 记录当前目录
current_dir=$(pwd)
# 获取脚本的绝对路径并写入环境变量
export UMI_APP_PATH=$(realpath ${BASH_SOURCE[0]})

# 切换环境
if [ -f "UmiOCR-data/venv/activate.sh" ]; then
    cd UmiOCR-data/venv
    source activate.sh
    cd $current_dir
    echo "激活嵌入式 Python 环境。"
elif [ -f "UmiOCR-data/venv/bin/activate" ]; then
    source UmiOCR-data/venv/bin/activate
    echo "激活 Python 虚拟环境。"
else
    echo "使用默认 Python 环境。"
fi

echo "工作目录: $(pwd)"

# 通过指定环境中的Python解释器，启动主程序，传入命令行指令
python3 UmiOCR-data/main_linux.py "$@"

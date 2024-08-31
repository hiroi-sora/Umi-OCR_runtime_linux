#!/bin/bash

# 确保工作目录为脚本所在目录
cd $(dirname ${BASH_SOURCE[0]})
# 记录当前目录
current_dir=$(pwd)
# 获取脚本的绝对路径并写入环境变量
export UMI_APP_PATH=$(realpath ${BASH_SOURCE[0]})

# 检查 Python 环境
#   嵌入式环境
if [ -f "UmiOCR-data/.embeddable/activate.sh" ]; then
    cd UmiOCR-data/.embeddable
    source activate.sh
    cd $current_dir
    echo "Use the Python embeddable environment."
#   虚拟环境
elif [ -f "UmiOCR-data/.venv/bin/activate" ]; then
    source UmiOCR-data/.venv/bin/activate
    echo "Use the Python virtual environment."
#   默认环境
else
    echo "Use the default Python environment."
fi

echo "pwd: $(pwd)"

# 检查环境变量 HEADLESS ，为 true 时启用无头模式
if [ "$HEADLESS" == "true" ]; then
  echo "Use headless mode."
  # 删除可能存在的锁文件
  if [ -e /tmp/.X99-lock ]; then
    echo "Removing existing lock file..."
    rm -f /tmp/.X99-lock
  fi
  Xvfb :99 -screen 0 1024x768x16 & export DISPLAY=:99
else
  echo "Use GUI mode."
  if [ -z "$DISPLAY" ]; then
    echo "Error: \$DISPLAY is not set."
    exit 1
  fi
  # 使用 docker GUI 模式时，
  # 应挂载主机的 /tmp/.X11-unix 目录到容器内的相同路径。
  # 该操作可在 docker run 命令中完成，如下所示：
  # docker run -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY ……
fi

# 通过指定环境中的Python解释器，启动主程序，传入命令行指令
python3 UmiOCR-data/main_linux.py "$@"

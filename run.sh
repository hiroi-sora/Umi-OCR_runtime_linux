#!/bin/bash

# 确保工作目录为脚本所在目录
cd $(dirname ${BASH_SOURCE[0]})

# 通过虚拟环境中的Python解释器，启动主程序，传入命令行指令
UmiOCR-data/venv/bin/python3 UmiOCR-data/main_linux.py "$@"

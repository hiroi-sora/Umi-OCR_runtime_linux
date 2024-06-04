#!/bin/bash

# 激活虚拟环境
source $(dirname "\$0")/UmiOCR-data/venv/bin/activate

# 运行 main.py
python $(dirname "\$0")/UmiOCR-data/main_linux.py
# Umi-OCR
# OCR software, free and offline. 开源、免费的离线OCR软件。
# Website - https://github.com/hiroi-sora/Umi-OCR
# Author - hiroi-sora
#
# You are free to use, modify, and distribute Umi-OCR, but it must include
# the original author's copyright statement and the following license statement.
# 您可以免费地使用、修改和分发 Umi-OCR ，但必须包含原始作者的版权声明和下列许可声明。
"""
Copyright (c) 2023 hiroi-sora

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
"""


"""
===================================================
========== Umi-OCR Linux 运行环境初始化入口 ==========
===================================================

说明：
本文件负责 Linux 运行环境的初始化。

环境初始化后，调用正式入口 py_src/run.py 启动软件。
"""


import os
import sys
import traceback


def MessageBox(msg, type_="error"):
    info = "Umi-OCR Message"
    if type_ == "error":
        info = "【错误】 Umi-OCR Error"
    elif type_ == "warning":
        info = "【警告】 Umi-OCR Warning"
    # Linux 下没有通用的系统弹窗API，只能在控制台输出信息
    print(info, "\n", msg)
    return 0


os.MessageBox = MessageBox


def initRuntimeEnvironment():
    # 初始化工作目录
    script = os.path.abspath(__file__)  # 当前脚本路径
    cwd = os.path.dirname(script)  # 工作目录
    os.chdir(cwd)  # 重新设定工作目录（不在最顶层，而在 UmiOCR-data 文件夹下）


if __name__ == "__main__":
    try:
        initRuntimeEnvironment()  # 初始化运行环境
    except Exception as e:
        err = traceback.format_exc()
        MessageBox("Failed to initialize running environment!\n\n" + err)
        sys.exit(0)
    try:
        # 获取 run.sh 启动脚本路径
        app_path = os.path.abspath("../run.sh")
        # 启动正式入口
        from py_src.run import main

        main(app_path=app_path)
    except Exception as e:
        err = traceback.format_exc()
        MessageBox("Failed to startup main program!\n\n" + err)
        sys.exit(0)

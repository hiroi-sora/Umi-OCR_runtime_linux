<p align="center">
  <a href="https://github.com/hiroi-sora/Umi-OCR">
    <img width="200" height="128" src="https://tupian.li/images/2022/10/27/icon---256.png" alt="Umi-OCR">
  </a>
</p>

<p align="left">
    平台：
    <span>
    <a href="https://github.com/hiroi-sora/Umi-OCR_runtime_windows">
        Windows
    </a>
    </span>
    <span> • </span>
    <span>
        <b>Linux</b>
    </span>
</p>

<h1 align="center">Umi-OCR Linux 运行环境</h1>

本仓库为 [Umi-OCR](https://github.com/hiroi-sora/Umi-OCR) 的代码 提供 Linux 运行环境。

> [!NOTE]
> Umi-OCR Linux 处于测试阶段，使用时可能遇到一些问题。  
> 欢迎 Linux 用户参与测试、提出Issue、贡献PR。

<p align="center"><img src="https://github.com/hiroi-sora/Umi-OCR/assets/56373419/a300661e-0789-40bd-a3d6-41121c276e50" alt="预览.png" style="width: 80%;"></p>

### 已通过测试的系统

- Ubuntu `22.04`
- Debian `12.5`
- Kali `2023.3`

### Umi-OCR Linux 兼容情况

经验证，可正常使用的功能：

- [x] 批量OCR
- [x] 截图OCR（不支持`Wayland`，仅在`x`会话下可用）
- [x] 粘贴图片OCR
- [x] 批量文档OCR
- [x] 二维码生成/识别
- [x] HTTP 接口
- [x] 命令行调用
- [x] 一键添加到桌面、开始菜单快捷方式

受限的功能：

- [ ] 不支持 一键添加开机自启。（必须手动设置）
- [ ] 不支持 批量任务完成后自动关机/待机。
- [ ] 在`x`会话下截图受限。

### 硬件要求

> [!NOTE]
> 当前 Umi-OCR-Linux 仅具有 [PaddleOCR-json](https://github.com/hiroi-sora/PaddleOCR-json) 这一种 OCR 引擎，它只支持具有 **AVX指令集** 的CPU。  
> 未来，我们会添加更多的 OCR 引擎，支持更多硬件平台。  

检查CPU兼容性：

```sh
lscpu | grep avx
```

如果CPU支持AVX指令集，则会输出一行很长的结果，其中可以找到 `avx` 的字样，类似如下（省略部分内容）：

```
Flags:          ... avx ... avx2 ...
```

**如果看不到任何输出，这表明当前CPU不支持AVX指令集，暂时无法使用 Umi-OCR-Linux 。**

## 项目部署流程

### 创建项目目录

```sh
mkdir Umi-OCR_Project
cd Umi-OCR_Project
```

### 拉取最新源码

```sh
git clone --single-branch --branch main https://github.com/hiroi-sora/Umi-OCR.git
git clone https://github.com/hiroi-sora/Umi-OCR_runtime_linux.git
```

### 拷贝Linux环境所需脚本

`Umi-OCR_runtime_linux` 仓库中的所有文件，拷贝到主仓库 `Umi-OCR` 中。（不覆盖）

```sh
cp -r -n Umi-OCR_runtime_linux/{.,}* Umi-OCR
chmod +x Umi-OCR/umi-ocr.sh
```

### Python 运行环境

#### 方式一：下载我们提供的嵌入式运行环境包 [Release](https://github.com/hiroi-sora/Umi-OCR_runtime_linux/releases) 。

- 请在 [Release](https://github.com/hiroi-sora/Umi-OCR_runtime_linux/releases) 中查看最新的下载地址。

下载、解压、放置到 `UmiOCR-data` 目录。

```sh
wget https://github.com/hiroi-sora/Umi-OCR_runtime_linux/releases/download/2.1.3/Umi-OCR_v2.1.3_Linux_embeddable.tar.xz
tar -v -xf Umi-OCR_v2.1.3_Linux_embeddable.tar.xz
cp -r -n .embeddable Umi-OCR/UmiOCR-data/
```

<a id="venv"></a>

#### 方式二：使用系统已安装的 Python 解释器，创建虚拟环境。

<details>
<summary>展开</summary>
</br>

Umi-OCR 需要 `3.8 ~ 3.10` 的 Python 解释器。除此以外的版本，如 `3.11` ，会因为无法安装 `PySide2>=5.15` 库而无法完成部署。

您可以使用以下的方式来准备 Python 解释器。

1. 检查系统 Python 版本，如果 `3.8 ~ 3.10` ，那么可以继续步骤：
```sh
python3 --version
```

2. 安装工具：
```sh
sudo apt-get install python3-dev gcc libxcb-xinerama0
```

3. 在 `Umi-OCR/UmiOCR-data` 目录中，创建Python虚拟环境，安装依赖库：

```sh
cd Umi-OCR/UmiOCR-data
python3 -m venv .venv
source .venv/bin/activate
pip3 install -r ../requirements.txt
```

</details>

#### 方式三：使用 [pyenv](https://github.com/pyenv/pyenv) 安装额外的 Python 解释器。

<details>
<summary>展开</summary>
</br>

1. [安装 pyenv](https://github.com/pyenv/pyenv?tab=readme-ov-file#installation)

2. 安装构建工具
```sh
sudo apt install python3-dev gcc libxcb-xinerama0 \
        make wget llvm build-essential libbz2-dev \
        libncurses5-dev libgdbm-dev libnss3-dev \
        libssl-dev libffi-dev libreadline-dev libsqlite3-dev \
        zlib1g-dev liblzma-dev xz-utils tk-dev
```

3. 在 pyenv 内，虚拟安装 Python 3.10
```sh
pyenv install 3.10
```

4. 设置当前 Shell 的 Python 版本（不影响系统全局）
```sh
pyenv shell 3.10
```

5. 回到方式二，[创建虚拟环境](#venv)。

</details>

#### 方式四：自己准备 Python 嵌入式运行环境包。

<details>
<summary>展开</summary>
</br>

Python 嵌入式包的好处是完全与系统隔离，便于将部署完毕的 Umi-OCR 打包和分发。

在 Linux 下，Python 官方并未提供嵌入包，需要手动编译，或者使用第三方编译的模块。这里我们使用 [lmbelo/python3-embeddable](https://github.com/lmbelo/python3-embeddable) 项目。

1. 安装工具：
```sh
sudo apt-get install python3-dev gcc libxcb-xinerama0
```

2. 确保当前在 `Umi-OCR_Project` 目录中。下载 `python3-linux-3.10.4-x86_64` ，解压到 `.embeddable` 目录中。
```sh
wget https://github.com/lmbelo/python3-embeddable/releases/download/v1.0.0/python3-linux-3.10.4-x86_64.zip
unzip python3-linux-3.10.4-x86_64.zip -d .embeddable
```

3. 将嵌入式包复制到 `Umi-OCR/UmiOCR-data/` 。
```sh
cp -r -n .embeddable Umi-OCR/UmiOCR-data/
```

4. 激活该嵌入式环境。
```sh
cd Umi-OCR/UmiOCR-data/.embeddable  # 进入环境目录（必须！）
source activate.sh
python3 --version  # 应该打印 Python 3.10.4
```

5. 记录下 `python3` 和 `pip3` 指令的路径。
```sh
which python3
# /home/my/MyCode/Umi-OCR_Project/Umi-OCR/UmiOCR-data/.embeddable/bin/python3
which pip3
# /home/my/MyCode/Umi-OCR_Project/Umi-OCR/UmiOCR-data/.embeddable/bin/pip3
```

6. 将 pip3 指向的 python 路径，改为上面查到的 python 路径。
```sh
nano "/home/my/MyCode/Umi-OCR_Project/Umi-OCR/UmiOCR-data/.embeddable/bin/pip3"
```
开头有一行：
```sh
#!/usr/bin/python
```
改为：
```sh
#!/home/my/MyCode/Umi-OCR_Project/Umi-OCR/UmiOCR-data/.embeddable/bin/python3
```
保存，退出文件。
```sh
Ctrl+S, Ctrl+X
```

7. 下载项目依赖库。由于嵌入式python环境中 **没有SSL模块** ，无法通过常见的pip源进行下载（目前几乎所有http源都会被重定向到https）。因此，我们需要移花接木，先借助系统自带的原始pip进行下载，再转移到嵌入式pip中安装。

**另开一个控制台**，在 `Umi-OCR_Project` 目录中，执行：
```sh
pip3 download -r ./Umi-OCR/requirements.txt -d ./pip-temp/ --only-binary=:all: --python-version 3.10.4
```
**回到嵌入式环境的控制台**，在当前目录（`Umi-OCR/UmiOCR-data/.embeddable`）中，执行：
```
pip3 install ../../../pip-temp/*.whl
```

8. 完成。

</details>

### 部署 PaddleOCR-json

#### 方式一：简易部署

- 请在 [Umi-OCR_plugins/releases](https://github.com/hiroi-sora/Umi-OCR_plugins/releases) 中查看最新的下载地址。

下载、解压、放置到 `UmiOCR-data/plugins` 目录。

```sh
# 去到插件目录（如果没有则创建）
# mkdir UmiOCR-data/plugins
# cd UmiOCR-data/plugins
# 下载打包好的插件
wget https://github.com/hiroi-sora/Umi-OCR_plugins/releases/download/2.1.3_dev/linux_x64_PaddleOCR-json_v140_beta.tar.xz
# 解压，放置在当前路径（plugins目录）
tar -v -xf linux_x64_PaddleOCR-json_v140_beta.tar.xz
```

#### 方式二：源码部署


参考： [PaddleOCR-json 插件部署](https://github.com/hiroi-sora/Umi-OCR_plugins/tree/main/win_linux_PaddleOCR-json) 。

### 启动！

通过命令行启动：
```sh
./umi-ocr.sh
``` 

成功启动并进行OCR，如下所示：

![image](https://github.com/hiroi-sora/Umi-OCR_plugins/assets/56373419/3180619c-4568-43f7-bc4f-cf910d26b59c)

注： `umi-ocr.sh` 为程序启动脚本，需在控制台中运行。  

### 创建快捷方式

如果希望像普通桌面软件一样，双击运行程序、且不显示控制台窗口，可以在软件的 **全局设置** 中勾选 **桌面/开始菜单快捷方式** ，下次通过快捷方式图标启动软件。 

> 在不同 Linux 发行版中，系统路径可能有区别，导致 Umi 无法自动创建桌面/开始菜单快捷方式，此时请手动创建 `Umi-OCR.desktop` 文件，写入以下内容：（将 `path/to/Umi-OCR` 换成实际绝对路径）
>
> ```
> [Desktop Entry]
> Version=v2
> Type=Application
> Name=Umi-OCR
> Exec={path/to/Umi-OCR}/umi-ocr.sh
> Path={path/to/Umi-OCR}
> Icon={path/to/Umi-OCR}/UmiOCR-data/qt_res/images/icons/umiocr.ico
> Terminal=false
> ```

如果屏幕截图功能不可用（比如截图界面是纯黑的），进行下述操作：

### （可选）将显示服务器协议设置为 X 会话

在较新的 Linux 桌面发行版中，默认使用 `Wayland` 显示服务器协议。由于 Wayland 对权限管理较为严格，QT 框架无法抓取屏幕截图，或者只能获取到纯黑的图像。

如果您需要使用截图功能，请将显示服务器协议切换为 X 协议（如 `Xorg`）。以下是在 Ubuntu、Debian 等系统中进行切换的方法：

1. 在登录界面，点击右下角的齿轮图标。
2. 选择 `Xorg` 选项。
3. 重新登录系统。

如果已经登录了系统，可以先注销，然后按照上述步骤切换到 `Xorg`。

如果不需要使用截图功能，则无需进行此操作。

![image](https://github.com/hiroi-sora/PaddleOCR-json/assets/56373419/3f75d0eb-76bc-4f9d-b94a-b1dea9a83606)

### 命令行指令

参考主仓库 [命令行手册](https://github.com/hiroi-sora/Umi-OCR/blob/main/docs/README_CLI.md) ，将调用对象换成 `umi-ocr.sh` 。如：

```sh
./umi-ocr.sh  --screenshot
```

> [!NOTE]
> 注意，由于Linux平台的会话机制，冷启动时（即 Umi-OCR 未在运行），可能不会执行指令，或者输出多余的调试信息。  
> 建议先启动 Umi-OCR （通过命令行或者快捷方式启动均可），确保主进程已经运行。再在新的会话中，使用命令行指令来控制。  

### （可选）编辑器

- 如果需要对代码进行二次开发或调试，推荐使用 [VS Code](https://code.visualstudio.com/) 编辑器。
- 插件推荐：
  - [Python](https://marketplace.visualstudio.com/items?itemName=ms-python.python)
  - [Black Formatter](https://marketplace.visualstudio.com/items?itemName=ms-python.black-formatter) （Python规范格式化）
  - [QML](https://marketplace.visualstudio.com/items?itemName=bbenoist.QML) （提供qml语法高亮）
  - [QML Snippets](https://marketplace.visualstudio.com/items?itemName=ThomasVogelpohl.vsc-qml-snippets) （提供qml代码补全）
- 本仓库提供了 `.vscode` 项目配置文件。

---

## 关于项目结构

### 各仓库：

- [主仓库](https://github.com/hiroi-sora/Umi-OCR)
- [插件库](https://github.com/hiroi-sora/Umi-OCR_plugins)
- [Windows 运行库](https://github.com/hiroi-sora/Umi-OCR_runtime_windows)
- [Linux 运行库](https://github.com/hiroi-sora/Umi-OCR_runtime_linux) 👈

### 工程结构：

`**` 后缀表示本仓库(`Linux 运行库`)包含的内容。

```
Umi-OCR
├─ Umi-OCR.exe
├─ umi-ocr.sh **
├─ requirements.txt **
└─ UmiOCR-data
   ├─ main.py
   ├─ main_linux.py **
   ├─ version.py
   ├─ venv **
   │  └─ Python 虚拟环境
   ├─ qt_res
   │  └─ 项目qt资源，包括图标和qml源码
   ├─ py_src
   │  └─ 项目python源码
   ├─ plugins
   │  └─ 插件
   └─ i18n
      └─ 翻译文件
```
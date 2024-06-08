<p align="center">
  <a href="https://github.com/hiroi-sora/Umi-OCR">
    <img width="200" height="128" src="https://tupian.li/images/2022/10/27/icon---256.png" alt="Umi-OCR">
  </a>
</p>

<h1 align="center">Umi-OCR Linux 运行环境</h1>

本仓库为 [Umi-OCR](https://github.com/hiroi-sora/Umi-OCR) 的代码 提供 Linux 运行环境。

> [!NOTE]
> 项目开发中，尚未正式发布，使用时可能存在部分问题。  
> 欢迎 Linux 用户参与测试、提出Issue、贡献PR。  

### 测试系统

- Ubuntu `22.04`
- Debian `12.5`

### Umi-OCR Linux 兼容情况

经验证，初步可用的功能：

- [x] 批量OCR
- [x] 粘贴图片OCR
- [x] 批量文档OCR
- [x] HTTP OCR 接口

未完成/存在异常的功能：

- [ ] 截图OCR
- [ ] 添加开机自启、桌面快捷方式等

目前需要较繁琐的方式手动部署项目。未来将提供更方便的发行版。

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

### 项目部署流程

#### （可选）编辑器

- 建议 [VS Code](https://code.visualstudio.com/)
- 插件推荐：
  - [Python](https://marketplace.visualstudio.com/items?itemName=ms-python.python)
  - [Black Formatter](https://marketplace.visualstudio.com/items?itemName=ms-python.black-formatter) （Python规范格式化）
  - [QML](https://marketplace.visualstudio.com/items?itemName=bbenoist.QML) （提供qml语法高亮）
  - [QML Snippets](https://marketplace.visualstudio.com/items?itemName=ThomasVogelpohl.vsc-qml-snippets) （提供qml代码补全）
- 本仓库提供了 `/.vscode` 项目配置文件。

#### 创建开发目录

```sh
mkdir Umi-OCR_Project
cd Umi-OCR_Project
```

#### 拉取最新源码

```sh
git clone --single-branch --branch main https://github.com/hiroi-sora/Umi-OCR.git
git clone https://github.com/hiroi-sora/Umi-OCR_runtime_linux.git
```

#### 安装工具

```sh
sudo apt-get install python3-dev
sudo apt-get install gcc
```

#### 拷贝Linux环境所需脚本

`Umi-OCR_runtime_linux` 仓库中的所有文件，拷贝到主仓库 `Umi-OCR` 中。（不覆盖）

```sh
cp -r -n Umi-OCR_runtime_linux/{.,}* Umi-OCR
chmod +x Umi-OCR/run.sh
```

#### （可选） Python 3.10

检查当前版本：
```sh
python --version
```

Umi-OCR 依赖 `PySide2>=5.15` 库，它需要 `Python 3.8 ~ 3.10` 的环境。如果系统中没有版本符合的Python，那么请根据下列步骤，通过 [pyenv](https://github.com/pyenv/pyenv) 工具，安装 Python 3.10 。（也可以使用 conda 等工具安装。）


安装 [pyenv](https://github.com/pyenv/pyenv) ：
```sh
curl https://pyenv.run | bash

echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc

exec "$SHELL"
```

安装构建工具：
```sh
sudo apt install \
        make wget llvm build-essential libbz2-dev \
        libncurses5-dev libgdbm-dev libnss3-dev \
        libssl-dev libffi-dev libreadline-dev libsqlite3-dev \
        zlib1g-dev liblzma-dev xz-utils tk-dev
```

安装Python：
```sh
pyenv install 3.10
```

设置当前Shell的Python版本（不影响系统全局）：
```sh
pyenv shell 3.10
```

#### 创建Python虚拟环境，安装依赖库

```sh
cd Umi-OCR/UmiOCR-data
python3 --version  # 确保当前版本为 3.10 ！
python3 -m venv venv
source venv/bin/activate
pip3 install -r ../requirements.txt
```

#### 放置 PaddleOCR-json 插件

安装解压工具 p7zip ：
```sh
sudo apt-get install p7zip-full
```

（确保当前在 `Umi-OCR/UmiOCR-data` 目录下）

创建并转到插件目录：

```sh
mkdir -p plugins
cd plugins
```

下载 [linux_x64_PaddleOCR-json_v140_dev](https://github.com/hiroi-sora/Umi-OCR_plugins/releases/tag/2.1.3_dev) 插件并解压：

```sh
wget https://github.com/hiroi-sora/Umi-OCR_plugins/releases/download/2.1.3_dev/linux_x64_PaddleOCR-json_v140_dev.7z
7z x linux_x64_PaddleOCR-json_v140_dev.7z
```

回到 `Umi-OCR` 目录中
```sh
cd ../..
```

#### 启动！

通过命令行启动。或者通过 VS Code 调试运行。
```sh
./run.sh
```

成功启动并进行OCR，如下所示：

![image](https://github.com/hiroi-sora/Umi-OCR_plugins/assets/56373419/3180619c-4568-43f7-bc4f-cf910d26b59c)

（目前并非全部功能可以使用，比如截图功能可能有问题）

### 接下来的工作

1. 完善 Linux 平台相关接口。

- 解决 **无法截图** 的问题。
- 补充 `UmiOCR-data/main_linux.py` 中缺失的部分（标为`# TODO`）。
- 补充 `UmiOCR-data/py_src/platform/linux/linux_api.py` 中缺失的部分。
- 补充Linux环境下默认快捷键的键值。

2. 命令行相关。

- 将用户输入的命令行参数转交到 `main_linux.py` 。

3. 打包和发行

- 将项目打包为体积小、易于使用的软件包。

End. 基本完成Linux移植工作，继续检查、测试。
<p align="center">
  <a href="https://github.com/hiroi-sora/Umi-OCR">
    <img width="200" height="128" src="https://tupian.li/images/2022/10/27/icon---256.png" alt="Umi-OCR">
  </a>
</p>

<h1 align="center">Umi-OCR Linux 运行环境</h1>

本仓库为 [Umi-OCR](https://github.com/hiroi-sora/Umi-OCR) 的代码 提供Windows运行环境。

> [!NOTE]
> 项目开发中，尚未正式发布。  
> 欢迎有经验的 Linux 开发者参与工作、贡献PR。  

### 测试环境

- Ubuntu `22.04`
- Debian `12.5`

### 开发部署流程

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
cd ..
```

#### 启动！

```sh
./run.sh
```

或者，通过 VS Code 调试运行。

启动主界面如下：

![image](https://github.com/hiroi-sora/Umi-OCR_runtime_linux/assets/56373419/68c93488-1330-42fb-b2e1-d5dd11c773dc)

### 接下来的工作

1. 确保初始化正常。

从开始，到 `UmiOCR-data/py_src/run.py` ： `res = qtApp.exec_()` 的代码，确保其运行正常。

2. 完善 Linux 平台相关接口。

补充 `UmiOCR-data/main_linux.py` 中缺失的部分（标为`# TODO`）。

补充 `UmiOCR-data/py_src/platform/linux/linux_api.py` 中缺失的部分。

3. 确保HTTP服务器正常。

`UmiOCR-data/py_src/server/web_server.py` 相关的代码，理论上是跨平台兼容的，不过要检查下是否有坑。

4. 主界面正常显示。

完成以上的步骤后，理论上软件主界面可以正常显示出来了，但是因为没有 OCR 插件，所以会显示一个报错弹窗：

> **OCR API 列表中不存在underfined**

5. 开发 Linux 可用的OCR插件。

从 [插件仓库](https://github.com/hiroi-sora/Umi-OCR_plugins) 中选择插件，使其兼容Linux。

6. 快捷键相关。

完成以上的步骤后，理论上可以在软件界面中使用大部分功能了，但快捷键的键值映射还没完成。需要完善下述文件：

`UmiOCR-data\py_src\platform\linux\key_translator.py`

7. 命令行相关。

将用户输入 `run.sh` 的命令行参数转交到 `main_linux.py` 。

8. 打包和发行

寻找一种方法，将项目打包为体积小、易于使用的软件包。

End. 基本完成Linux移植工作，继续检查、测试。
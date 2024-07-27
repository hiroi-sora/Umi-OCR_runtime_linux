# Umi-OCR Docker 部署

## 1. 下载 Dockerfile
```sh
mkdir Umi-OCR-Docker
cd Umi-OCR-Docker
wget https://raw.githubusercontent.com/hiroi-sora/Umi-OCR_runtime_linux/main/Dockerfile
```

## 2. 构建镜像

```sh
docker build -t umi-ocr-paddle .
```
- 设置镜像名称为 `umi-ocr-paddle` 。（Dockerfile默认下载使用 PaddleOCR-json 引擎）

## 3. 运行容器

### 无头模式

适合在没有显示器的云服务器，或者不需要GUI界面时使用。Umi-OCR 提供 HTTP 接口服务。

```sh
docker run -d --name umi-ocr \
    -e HEADLESS=true \
    -p 1224:1224 \
    umi-ocr-paddle
```
说明：
- 设置容器名称为 `umi-ocr` 。你也可以设置为任意名称。
- 设置环境变量 `-e HEADLESS=true` 。
- 设置端口转发 `-p xxxx:1224` ，将容器内的1224端口转发给主机xxxx端口。
- 使用的镜像为 `umi-ocr-paddle` 。

### GUI 模式

适合在有显示器的 Xorg 桌面环境下使用，可使用截屏、文件导入等功能。

需要在主机上开放 X 服务权限，允许容器内的应用连接到宿主机桌面。

```sh
xhost +
```

```sh
docker run -d --name umi-ocr \
    -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY \
    -v /home:/home \
    -p 1224:1224 \
    umi-ocr-paddle
```
说明：
- 将 `/tmp/.X11-unix` 挂载到容器内，将主机显示器信息 `$DISPLAY` 传给容器内环境。
- 将主机 `home` 目录挂载到容器内的 **相同路径** ，使文件拖拽导入的功能生效。
  - 如果需要导入更多路径的文件，可自行挂载。注意，主机路径和容器路径必须相同。
- 容器运行后，等待数秒，即可在主机屏幕上显示 Umi-OCR 的窗口。

## 4. GUI 模式的控制

如果点击 Umi-OCR 窗口右上角的 × ，前台窗口会被关闭。但 Umi 仍会在后台活动，提供HTTP接口服务。

**重新打开窗口**  指令：

```sh
docker exec umi-ocr /bin/sh -c "/app/umi-ocr.sh --show"
```

**截图OCR** 指令：

```sh
docker exec umi-ocr /bin/sh -c "/app/umi-ocr.sh --screenshot"
```

更多指令请参考 [命令行手册](https://github.com/hiroi-sora/Umi-OCR/blob/main/docs/README_CLI.md) 。如果需要传入文件路径（如 `--path` 指令），请确保该文件所在的目录，在 `docker run` 时已通过 `-v` 挂载到容器中。

Docker GUI 模式可以使用大部分功能，就像主机中的普通应用一样：

- 访问宿主机内存，进行屏幕截图、粘贴图片。
- 访问宿主机硬盘，拖拽导入本地文件。（文件的祖先目录需要被挂载到容器中）

Docker 中部分功能受限，无法使用：

- 创建桌面、开始菜单快捷方式。
- 系统托盘区图标。

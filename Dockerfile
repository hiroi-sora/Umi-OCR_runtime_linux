# Umi-OCR Docker
# https://github.com/hiroi-sora/Umi-OCR
# https://github.com/hiroi-sora/Umi-OCR_runtime_linux

FROM debian:11-slim

LABEL app="Umi-OCR-Paddle"
LABEL maintainer="hiroi-sora"
LABEL version="2.1.3"
LABEL description="OCR software, free and offline."
LABEL license="MIT"
LABEL org.opencontainers.image.source="https://github.com/hiroi-sora/Umi-OCR_runtime_linux"

# 安装所需工具和QT依赖库
RUN apt-get update && apt-get install -y \
    wget xz-utils ttf-wqy-microhei xvfb \
    libglib2.0-0 libgssapi-krb5-2 libgl1-mesa-glx libfontconfig1 \
    libfreetype6 libxcb-icccm4 libxcb-image0 libxcb-keysyms1 \
    libxcb-render-util0 libxcb-render0 libxcb-shape0 libxcb-xkb1 \
    libxcb-xinerama0 libxkbcommon-x11-0 libxkbcommon0 libdbus-1-3 \
    && rm -rf /var/lib/apt/lists/*

# 工作目录
WORKDIR /app

# 可选1：将主机目录中的发行包，复制到容器内
# COPY Umi-OCR_Debian_x64_Paddle_2.1.3.tar.xz .
# 可选2：在线下载发行包
RUN wget https://github.com/hiroi-sora/Umi-OCR/releases/download/v2.1.3/Umi-OCR_Debian_x64_Paddle_2.1.3.tar.xz

# 解压压缩包，移动文件，删除多余的目录和压缩包
RUN tar -v -xf Umi-OCR_Debian_x64_Paddle_2.1.3.tar.xz && \
    mv Umi-OCR_Debian_x64_Paddle_2.1.3/* . && \
    rmdir Umi-OCR_Debian_x64_Paddle_2.1.3 && \
    rm Umi-OCR_Debian_x64_Paddle_2.1.3.tar.xz

# 下载最新的启动脚本
RUN wget -O umi-ocr.sh https://raw.githubusercontent.com/hiroi-sora/Umi-OCR_runtime_linux/main/umi-ocr.sh

# 写入 Umi-OCR 预配置项：
#    允许外部HTTP请求
#    切换到支持中文的字体
RUN printf "\
[Global]\n\
server.host=0.0.0.0\n\
ui.fontFamily=WenQuanYi Micro Hei\n\
ui.dataFontFamily=WenQuanYi Micro Hei\n\
" > ./UmiOCR-data/.settings


# 运行指令
ENTRYPOINT ["/app/umi-ocr.sh"]

#!/usr/bin/env bash

# 设置定量
## 当前脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
## 当前语言
CURRENT_LANG=0
## 构建目录
BUILD_DIR=$SCRIPT_DIR/Build
## 发布目录
RELEASE_DIR=$SCRIPT_DIR/Release
## 字体文件名称
FONT_NAME="MapleMono-CN-Medium"
## 字体下载URL
FONT_URL="https://github.com/subframe7536/maple-font/releases/download/v7.3/MapleMono-CN.zip"

# 本地化
recho() {
  if [ $CURRENT_LANG == 1 ]; then
    ### zh-Hans
    echo $1;
  else
    ### en-US
    echo $2;
  fi
}

# 创建目录
mkdir -p $BUILD_DIR/font
mkdir -p $BUILD_DIR/x1
mkdir -p $BUILD_DIR/x2
mkdir -p $RELEASE_DIR

# 下载并解压字体
curl -L $FONT_URL -o $BUILD_DIR/font.zip
unzip -o $BUILD_DIR/font.zip -d $BUILD_DIR/font

# 生成字体文件
grub-mkfont -o $BUILD_DIR/x1/"$FONT_NAME"_32.pf2 -s 32 -v $BUILD_DIR/font/$FONT_NAME.ttf
grub-mkfont -o $BUILD_DIR/x1/"$FONT_NAME"_48.pf2 -s 48 -v $BUILD_DIR/font/$FONT_NAME.ttf
grub-mkfont -o $BUILD_DIR/x2/"$FONT_NAME"_64.pf2 -s 64 -v $BUILD_DIR/font/$FONT_NAME.ttf
grub-mkfont -o $BUILD_DIR/x2/"$FONT_NAME"_96.pf2 -s 96 -v $BUILD_DIR/font/$FONT_NAME.ttf

rm -f $BUILD_DIR/font.zip
rm -rf $BUILD_DIR/font

# 复制字体到主题目录
find $SCRIPT_DIR -type d -name "568flat*" ! -name "568flat_x*" -exec cp -v $BUILD_DIR/x1/"$FONT_NAME"_32.pf2 {} \;
find $SCRIPT_DIR -type d -name "568flat*" ! -name "568flat_x*" -exec cp -v $BUILD_DIR/x1/"$FONT_NAME"_48.pf2 {} \;
find $SCRIPT_DIR -type d -name "568flat_x2*" -exec cp -v $BUILD_DIR/x2/"$FONT_NAME"_64.pf2 {} \;
find $SCRIPT_DIR -type d -name "568flat_x2*" -exec cp -v $BUILD_DIR/x2/"$FONT_NAME"_96.pf2 {} \;

# 复制组件图片
## 公共组件
find $SCRIPT_DIR -maxdepth 1 -type d -name "568flat*" -exec cp -v $SCRIPT_DIR/assets/Components/*.png {} \;
## 分辨率相关组件
find $SCRIPT_DIR -maxdepth 1 -type d -name "568flat*" ! -name "568flat_x*" -exec cp -v $SCRIPT_DIR/assets/Components/x1/*.png {} \;
find $SCRIPT_DIR -maxdepth 1 -type d -name "568flat_x2*" -exec cp -v $SCRIPT_DIR/assets/Components/x2/*.png {} \;
## 【已弃用】语言和分辨率相关组件
# find $SCRIPT_DIR -maxdepth 1 -type d -name "568flat*" ! -name "568flat_x*" ! -name "*-en" -exec cp -v $SCRIPT_DIR/assets/Components/x1/zh/*.png {} \;
# find $SCRIPT_DIR -maxdepth 1 -type d -name "568flat*-en" ! -name "568flat_x*" -exec cp -v $SCRIPT_DIR/assets/Components/x1/en/*.png {} \;
# find $SCRIPT_DIR -maxdepth 1 -type d ! -name "*-en" -name "568flat_x2*" -exec cp -v $SCRIPT_DIR/assets/Components/x2/zh/*.png {} \;
# find $SCRIPT_DIR -maxdepth 1 -type d -name "*-en" -name "568flat_x2*" -exec cp -v $SCRIPT_DIR/assets/Components/x2/en/*.png {} \;

# 打包主题
(cd $SCRIPT_DIR && find . -type d -name "568flat*" -exec zip -r $RELEASE_DIR/$(basename {}).zip {} \;)

ls $RELEASE_DIR

recho "构建完成，发布文件在 $RELEASE_DIR 目录" "Build completed, release files in $RELEASE_DIR directory"
#!/bin/bash

# 1. 如果不存在 build 文件夹，就新建一个（保持源码干净）
if [ ! -d "build" ]; then
    mkdir build
fi

# 2. 进入 build 文件夹
cd build

# 3. 运行 CMake 生成 Makefile
echo "====== 正在生成配置 ======"
cmake ..

# 4. 运行 make 进行编译
echo "====== 正在编译构建 ======"
make

# 5. 编译成功后，在终端直接运行生成的可执行文件
echo "====== 运行程序结果 ======"
if [ -f "./hello_world" ]; then
    ./hello_world
else
    echo "编译失败，未找到可执行文件。"
fi

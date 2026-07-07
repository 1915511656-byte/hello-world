# 声明 CMake 的最低版本要求
cmake_minimum_required(VERSION 3.10)

# 设置你的项目名称
project(HelloMacC)

# 指定 C 语言标准 (比如使用 C11 标准)
set(CMAKE_C_STANDARD 11)

# 生成可执行文件：第一个参数是编译出来的程序名，第二个参数是源码文件
add_executable(hello_world hello_world.c)

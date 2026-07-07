Git 核心操作与规范化流转笔记
# 1. 基础配置在首次使用 Git 时，必须配置作者信息，否则无法提交。
bash# 配置全局用户名和邮箱
git config --global user.name "你的名字"
git config --global user.email "你的邮箱"

查看当前已有的配置列表
git config --list
请谨慎使用此类代码。
# 2. 效率大杀器：设置别名 (Alias)
将复杂的原生命令简化为快捷键，大幅提升日常输入效率。
bash
git config --global alias.st status     # git st -> 查看工作区状态
git config --global alias.co checkout   # git co -> 切换分支
git config --global alias.ci commit     # git ci -> 提交代码
git config --global alias.br branch     # git br -> 管理分支
请谨慎使用此类代码。
# 3. 约定式提交规范 (Conventional Commits)
代码提交信息（Commit Message）需要带有特定前缀，方便后续追溯代码性质。
公式：git commit -m "类型: 本次修改做了什么事" (注意：冒号后有一个空格)
常用类型对照表：
feat: 引入新功能（Feature）
fix: 修复 
Bugdocs: 仅修改了文档、Markdown 文件（Documentation）
style: 修改代码格式、空格、分号等（不影响业务逻辑）
refactor: 代码重构（既不是新功能，也不是修 Bug）
# 4. 团队协作与分支保护开发流 (PR 流程)
在 GitHub 开启了 main 分支保护（Branch Protection / Rulesets）后，标准的开发和合入流程如下：
bash
步骤 1：在本地创建一个独立的功能/修复分支，并无缝切换过去
git checkout -b <新分支名称>

步骤 2：在本地修改文件后，标记所有变动的文件
git add .

步骤 3：提交修改到本地仓库，并附带规范的 Commit 信息
git commit -m "docs: 完善项目说明文档"

步骤 4：将这个新分支推送到 GitHub 远程仓库（注意：不是推送给 main）
git push origin <新分支名称>
请谨慎使用此类代码。后续网页端操作：登录 GitHub 进入仓库，点击黄色提示条的 Compare & pull request。填写描述后点击 Create pull request 建立合并请求（PR）。等待团队成员 Review 并 Approve（或者配置管理员 Bypass 绕过）。按钮变绿后，点击 Merge pull request 正式将代码合入主分支。

三、 C 语言工程化：
CMake + Shell 脚本一键构建告别原始的单文件 
clang hello.c 编译模式，采用工业级标准的多文件项目管理架构。
1. 软件安装 (Mac 专属)使用 Mac 的包管理器 Homebrew 全局安装 CMake。如果遇到 Auto-updating 卡住，可使用命令强制跳过更新直接安装：bashHOMEBREW_NO_AUTO_UPDATE=1 brew install cmake
请谨慎使用此类代码。
2. 标准工程目录结构text📁 你的项目文件夹/
├── 📄 .gitignore       <-- 过滤规则，写入 build/ 阻挡中间垃圾文件
├── 📄 hello_world.c    <-- 你的 C 语言源码文件
├── 📄 CMakeLists.txt   <-- CMake 配置文件
└── 📄 build.sh         <-- 一键自动化编译执行脚本
请谨慎使用此类代码。
3. 核心配置文件源码📄 CMakeLists.txtcmakecmake_minimum_required(VERSION 3.10) # 最低版本要求
project(HelloMacC)                   # 项目工程名称
set(CMAKE_C_STANDARD 11)             # 指定 C 语言标准为 C11

# 生成可执行文件：第一个参数为程序名，第二个参数为源码文件名
add_executable(hello_world hello_world.c)
请谨慎使用此类代码。📄 build.shbash#!/bin/bash

# 1. 保持源码干净，不存在 build 文件夹则新建
if [ ! -d "build" ]; then
    mkdir build
fi

# 2. 进入 build 目录
cd build

# 3. 运行 CMake 生成 Makefile
echo "====== 正在生成配置 ======"
cmake ..

# 4. 运行 make 进行编译构建
echo "====== 正在编译构建 ======"
make

# 5. 自动运行生成的可执行程序
echo "====== 运行程序结果 ======"
if [ -f "./hello_world" ]; then
    ./hello_world
else
    echo "编译失败，未找到可执行文件。"
fi
请谨慎使用此类代码。
4. 运行方式在终端里，新创建的 .sh 脚本需要先赋予其可执行权限，随后便可享受一键构建的极速体验：bashchmod +x build.sh  # 赋予执行权限（只需执行一次）
./build.sh         # 一键运行：自动创建、自动配置、自动编译、自动出结果！
请谨慎使用此类代码。
四、 VS Code 生产力进阶配置自动保存与格式化：在设置（Cmd + ,）中搜索 auto save 改为 afterDelay（打完字1秒自动保存）；搜索 format on save 并勾选，实现写完代码，自动保存并自动对齐排版。推荐高能插件：Git Graph / Git History：将 Git 提交历史变成精美的地铁线路图，可视化分支合并。Markdown All in One + Markdown Preview Enhanced：打造 Mac 上最高颜值的 Markdown 实时笔记白板。

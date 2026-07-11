# Git 核心操作与规范化流转笔记

---

## 一、基础配置

在首次使用 Git 时，必须配置作者信息，否则无法提交。

```bash
# 配置全局用户名和邮箱
git config --global user.name "你的名字"
git config --global user.email "你的邮箱"
```

查看当前已有的配置列表：

```bash
git config --list
```

---

## 二、效率大杀器：设置别名 (Alias)

将复杂的原生命令简化为快捷键，大幅提升日常输入效率。

```bash
git config --global alias.st status     # git st  → 查看工作区状态
git config --global alias.co checkout   # git co  → 切换分支
git config --global alias.ci commit     # git ci  → 提交代码
git config --global alias.br branch     # git br  → 管理分支
```

---

## 三、约定式提交规范 (Conventional Commits)

代码提交信息（Commit Message）需要带有特定前缀，方便后续追溯代码性质。

**公式：** `git commit -m "类型: 本次修改做了什么事"`

> ⚠️ 注意：冒号后有一个空格。

### 常用类型对照表

| 类型       | 含义                                             |
| ---------- | ------------------------------------------------ |
| `feat`     | 引入新功能（Feature）                            |
| `fix`      | 修复 Bug                                         |
| `docs`     | 仅修改了文档、Markdown 文件（Documentation）     |
| `style`    | 修改代码格式、空格、分号等（不影响业务逻辑）     |
| `refactor` | 代码重构（既不是新功能，也不是修 Bug）           |

---

## 四、团队协作与分支保护开发流 (PR 流程)

在 GitHub 开启了 `main` 分支保护（Branch Protection / Rulesets）后，标准的开发和合入流程如下：

### 本地操作步骤

```bash
# 步骤 1：在本地创建一个独立的功能/修复分支，并无缝切换过去
git checkout -b <新分支名称>

# 步骤 2：在本地修改文件后，标记所有变动的文件
git add .

# 步骤 3：提交修改到本地仓库，并附带规范的 Commit 信息
git commit -m "docs: 完善项目说明文档"

# 步骤 4：将这个新分支推送到 GitHub 远程仓库（注意：不是推送给 main）
git push origin <新分支名称>
```

### 后续网页端操作

1. 登录 GitHub 进入仓库，点击黄色提示条的 **Compare & pull request**
2. 填写描述后点击 **Create pull request** 建立合并请求（PR）
3. 等待团队成员 Review 并 Approve（或者配置管理员 Bypass 绕过）
4. 按钮变绿后，点击 **Merge pull request** 正式将代码合入主分支

---

## 五、C 语言工程化：CMake + Shell 脚本一键构建

告别原始的单文件 `clang hello.c` 编译模式，采用工业级标准的多文件项目管理架构。

### 1. 软件安装 (Mac 专属)

使用 Mac 的包管理器 Homebrew 全局安装 CMake。

> 💡 如果遇到 `Auto-updating` 卡住，可使用命令强制跳过更新直接安装：

```bash
HOMEBREW_NO_AUTO_UPDATE=1 brew install cmake
```

### 2. 标准工程目录结构

```
📁 你的项目文件夹/
├── 📄 .gitignore       ← 过滤规则，写入 build/ 阻挡中间垃圾文件
├── 📄 hello_world.c    ← 你的 C 语言源码文件
├── 📄 CMakeLists.txt   ← CMake 配置文件
└── 📄 build.sh         ← 一键自动化编译执行脚本
```

### 3. 核心配置文件源码

**📄 CMakeLists.txt**

```cmake
cmake_minimum_required(VERSION 3.10)  # 最低版本要求
project(HelloMacC)                    # 项目工程名称
set(CMAKE_C_STANDARD 11)              # 指定 C 语言标准为 C11

# 生成可执行文件：第一个参数为程序名，第二个参数为源码文件名
add_executable(hello_world hello_world.c)
```

**📄 build.sh**

```bash
#!/bin/bash

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
```

### 4. 运行方式

在终端里，新创建的 `.sh` 脚本需要先赋予其可执行权限，随后便可享受一键构建的极速体验：

```bash
chmod +x build.sh  # 赋予执行权限（只需执行一次）
./build.sh         # 一键运行：自动创建、自动配置、自动编译、自动出结果！
```

---

## 六、VS Code 生产力进阶配置

### 自动保存与格式化

- 在设置（`Cmd + ,`）中搜索 `auto save` 改为 `afterDelay`（打完字 1 秒自动保存）
- 搜索 `format on save` 并勾选，实现写完代码自动保存并自动对齐排版

### 推荐高能插件

| 插件                               | 作用                                                       |
| ---------------------------------- | ---------------------------------------------------------- |
| **Git Graph / Git History**        | 将 Git 提交历史变成精美的地铁线路图，可视化分支合并        |
| **Markdown All in One**            | 搭配 Markdown Preview Enhanced，打造高颜值 Markdown 实时笔记白板 |
| **Markdown Preview Enhanced**      | Markdown 实时预览增强                                      |

---

## 七、VS Code 多分支并行开发：避免冲突的四大绝招

在 VS Code 下同时推进好几个不同进度的分支，是开发中非常健康的"多任务并行"状态。频繁发生冲突的根本原因，通常是因为分支之间没有及时对齐，或者大家在没有最新的代码基础（Base）上各自开发。

掌握以下四个绝招，可以帮你把冲突发生率降低 90% 以上：

### 绝招一：开工前，先喂饱主分支（Sync 核心动作）

> 🚨 这是避免冲突的**第一铁律**。

很多冲突是因为你的功能分支从一开始就基于一个"老旧"的 `main` 分支拉出来的。

**做法：**
- 每次准备在新分支上写代码之前，或者每天早晨开工前
- 先在 VS Code 底部状态栏切换回 `main` 分支
- 点击左下角的"循环同步"按钮（或执行 `git pull`）

**结果：** 确保你本地的 `main` 是 GitHub 上最新的。在这个基础上再建立新分支开发，就能完美避开和别人已经合入的代码发生冲突。

### 绝招二：使用 Rebase（变基）让你的分支"向前穿越"

如果你的分支 `feature-A` 已经写了三天，而这三天里主分支 `main` 已经被别人合入了十几笔新提交，此时直接合并必有冲突。

**解法：** 在 VS Code 终端里切换到你的 `feature-A` 分支，执行：

```bash
git fetch origin
git rebase origin/main
```

> 💡 这行命令的意思是：把你的分支从三天前的"老 main"上拔出来，插到今天最新的"新 main"顶端去。

### 绝招三：善用 VS Code 极其强大的"冲突三路合并编辑器"

Git 命令行遇到冲突会满屏弹乱码，但在 VS Code 里处理冲突是一种享受。当提示冲突时：

1. 点击左侧**"源代码管理"**面板，冲突的文件会被标注一个醒目的 **C**（Conflict）
2. 双击打开它，VS Code 底部会弹出一个巨大的 **"在合并编辑器中打开 (Open in Merge Editor)"** 按钮，点它
3. 界面会变成极其直观的三栏：

| 栏位           | 内容                               |
| -------------- | ---------------------------------- |
| 左边（Current）  | 你自己当前分支改的内容             |
| 右边（Incoming） | 别人在另一个分支改的内容           |
| 底部（Result）   | 最终合并后的最终效果               |

你只需要像做单选题一样，勾选你想要左边的、右边的、还是两边都要。勾选完毕后点击右下角 **Complete Merge**，冲突瞬间解完。

### 绝招四：写到一半需要紧急切换分支？用 Stash（暂存）

**场景：** 你正在分支 A 写代码，突然需要紧急去分支 B 修复一个 Bug，但当前的分支 A 还没写完。直接切换分支，Git 会报错提示"未提交的代码会覆盖"。

❌ **错误做法：** 为了切换分支，瞎写一个 `commit -m "临时提交"`，这会污染你的 Git 历史。

✅ **正确做法：** 使用 VS Code 的暂存（Stash）功能：

1. 在 VS Code 左侧 Git 面板顶部的 **`...`（更多操作）** 菜单中
2. 选择 **暂存 (Stash) → 暂存（包含未跟踪文件）**
3. 你的工作区会瞬间变得干干净净，所有的临时修改都被放进了一个隐藏的"储物箱"里
4. 切换去别的分支救火
5. 救火完毕回来后，再次点击 **`...`** 菜单
6. 选择 **暂存 (Stash) → 弹出最新的暂存 (Pop Latest Stash)**
7. 你之前写到一半的代码就会像魔法一样原封不动地吐回来

---

## 八、如何删除一个分支

删除 Git 分支主要分为**删除本地分支**和**删除远程分支**，你可以选择在 VS Code 界面中用鼠标点，或者在终端里敲命令。

> ⚠️ **前置条件：** 你不能删除你当前正在处于的分支。比如你想删分支 A，必须先切换到分支 B（或 `main`），才能去删除 A。

### 方法一：VS Code 图形界面删除（最推荐 🖱️）

1. **查看所有分支：** 点击 VS Code 左下角状态栏的当前分支名称（或者按下快捷键 `Cmd + Shift + P`，输入 `Git: Checkout to...` 并回车）
2. **选择要删除的分支：** 在顶部弹出的分支列表中，找到你想删除的分支
3. **点击垃圾桶：** 鼠标悬停在那个分支名字上，右侧会出现一个小垃圾桶图标，点击它即可在本地删除

> 💡 如果你安装了之前推荐的 **Git Graph** 插件，可以直接在底部的分支树上，对着要删除的分支右键点击，选择 **Delete Branch**。

### 方法二：VS Code 终端命令删除（更快捷 💻）

打开 VS Code 的集成终端，确保先切换到其他分支（如 `main`）：

```bash
git checkout main
```

#### 仅删除本地分支

如果这个分支只是你在本地测试用的，没有推送到 GitHub：

```bash
# 温柔的删除：如果该分支有没合入的代码，Git 会拦截并警告你
git branch -d 分支名称

# 强制删除：如果你确定这个分支的代码不要了（大写 D）
git branch -D 分支名称
```

#### 同步删除 GitHub 远程的分支

如果你不仅想删本地的，还想把已经推送到 GitHub 上的那个分支一并抹去：

```bash
git push origin --delete 分支名称
```

执行完这行后，去 GitHub 网页端查看，该远程分支就会彻底消失。

> 💡 如果你在删除时遇到了类似 `error: The branch 'xxx' is not fully merged`（分支未完全合并）的报错拦截，代表你这个分支里还有没保存的修改。

---

## 九、远程分支的作用与清理

### 已经全部 Merge 到 main 了，远程分支还有什么用？

既然你的所有分支都已经成功合入（Merge）到了 `main` 分支，那么这些留在 GitHub 上的远程分支其实就已经完成了它们所有的历史使命，没有任何保留的必要了。在 Git 的标准工作流中，它们现在的身份叫做 **"僵尸分支（Stale Branches）"**。

### 它们曾经的作用是什么？

在你把代码合入 `main` 之前，这些远程分支有两个核心作用：

| 作用               | 说明                                                                         |
| ------------------ | ---------------------------------------------------------------------------- |
| 🌐 **网络云端备份**   | 防止你本地的 Mac 突然坏掉或丢失，代码在 GitHub 上有一份实时的安全备份         |
| 🔀 **开启 PR 的基石** | GitHub 必须依靠这个远程分支，才能在网页上把它的代码和 `main` 分支进行对比，展示给别人 Review |

### 现在已经 Merge 了，为什么应该删掉它们？

如果不清理这些已经合入的远程分支，会带来以下几个小烦恼：

- **污染视觉：** 随着你做的项目越来越多，GitHub 上的分支列表会变得极长，找真正有用的开发分支会像大海捞针
- **团队困惑：** 在团队协作中，别人看到这些分支还挂着，会误以为"这个功能是不是还没开发完？"或"是不是还有代码没合进去？"

> 🎯 **业界标准的做法是：一旦 Merge 成功，立刻将其删除。**

### 如何一劳永逸地清理它们？

不需要一个个去手动删，GitHub 和 Git 为我们提供了非常聪明的自动化清理方案：

#### 方案一：让 GitHub 网页自动帮你删（最推荐 ⚙️）

GitHub 自带一个"用完即焚"的功能，开启后，只要你点击了 **Merge pull request**，GitHub 会瞬间在服务器上自动把该分支删掉。

1. 打开你的 GitHub 仓库网页，进入 **Settings**
2. 在默认的 **General** 页面，往下滚动到 **Pull Requests** 区域
3. 勾选 **Automatically delete head branches**（自动删除头分支）

> ✅ 开启后，以后只要 PR 成功合入，远程分支就再也不需要你操心了。

## 十、GitHub 分支保护规则配置：如何设置需要 Review 才能合入

目前 GitHub 最推荐且最稳定的做法是使用 **Rulesets（规则集）**。请按照以下步骤在网页端操作：

### 1. 进入项目设置

打开浏览器，进入你的 GitHub 目标仓库主页，点击正上方菜单栏最右边的 **Settings**（⚙️ 图标）。

### 2. 新建规则集

在左侧菜单栏找到 **Code and automation** 板块，点击 **Rulesets**，然后点击右上角的 **New ruleset** → 选择 **New branch ruleset**。

### 3. 填写基础信息

| 字段               | 操作                                               |
| ------------------ | -------------------------------------------------- |
| **Ruleset Name**   | 随便填一个名字，比如 `protect-main`                 |
| **Enforcement status** | 必须把默认的 `Disabled` 改选为 **Active**（只有这样规则才会生效） |

### 4. 指定保护主分支

往下拉找到 **Target branches** 区域：

1. 点击 **Add target** 按钮
2. 选择 **Include by pattern**
3. 在弹出的输入框中精准填入：`main`（或者你的主分支名，如 `master`）

### 5. 开启 Review 拦截锁

往下拉找到 **Branch rules** 区域：

- 🔑 勾选 **Require a pull request before merging**（合并前需要 PR）
- 🔑 勾选后下方会自动展开，继续勾选 **Require approvals**（需要审批）
- 将所需的审批人数保持为 **1** 人即可

### 6. 给自己留个后门（用于自己测试）

页面往上滚一点，找到 **Bypass list**（绕过列表）区域：

1. 点击 **+ Add bypass**
2. 选择 **Repository Admin**（仓库管理员），确保右侧是 **Always**

> 💡 这样设置后，别人提交必须走 Review，而你自己测试时可以通过点击绿色的”管理员绕过”直接强行合入。

### 7. 保存

直接拉到页面最底部，点击绿色的 **Save changes** 保存按钮。

---

## 十一、本地文件夹推送到受保护分支

要把 Mac 本地的一个全新文件夹安全地推送到设置了保护的 `main` 分支（即通过提 PR、管理员绕过的流程合入），请在终端或 VS Code 内置终端里，严格按照以下步骤操作。

> 📁 假设你的本地文件夹叫 `my-algorithm-code`。

### 第一步：让 Git 认识这个文件夹（本地初始化）

```bash
# 进入该文件夹
cd 路径/my-algorithm-code

# 初始化本地 Git 仓库
git init

# 将默认分支改为 main（与 GitHub 保持一致）
git branch -M main
```

### 第二步：将本地与 GitHub 远程仓库建立连接

去 GitHub 网页上复制你那个仓库的 SSH 地址（例如 `git@github.com:你的用户名/仓库名.git`）。在终端运行以下命令，把远程仓库绑定为 `origin`：

```bash
git remote add origin 你的SSH地址
```

### 第三步：不能直推 main，必须建立本地”功能分支”

> 🚨 因为你刚刚在网页上开启了 `main` 分支的保护规则，如果直接往 `main` 分支 push 会被 GitHub 服务器拒绝。

新建并切换到一个临时分支（比如叫 `init-project`）：

```bash
git checkout -b init-project
```

保存本地文件变动并推送：

```bash
git add .
git commit -m “feat: 初始化算法练习项目文件夹”
git push origin init-project
```

### 第四步：去网页端提 PR 并用管理员身份合入

1. 打开浏览器进入你的 GitHub 仓库主页
2. 页面顶部会弹出一个黄色的提示条，点击 **Compare & pull request**
3. 点击绿色的 **Create pull request** 按钮
4. 进行合入：此时页面下方会显示红色拦截，提示需要 Review。但因为你在 Bypass list 里加了管理员，你只需要往下滚动，会看到一个带有黄色警告的按钮，直接点击 **Merge pull request**（或通过管理员权限强行合并），然后点击 **Confirm merge**

---

## 十二、远程仓库只有 init-project 分支，没有 main 分支怎么办

这属于正常现象！因为你建立的是一个完全空白的全新 GitHub 仓库，第一笔代码直接推向了 `init-project`，GitHub 服务器上目前就只有这一个孤零零的分支，甚至还没来得及诞生 `main` 分支。

我们要让它恢复成正常的以 `main` 为主分支、且受到保护的状态，只需要进行一次简单的”转换”和”重设”。

### 第一步：在 GitHub 网页端将它重命名为 main

因为现在仓库里只有这一个分支，它目前自动成为了你仓库的**默认分支（Default branch）**。直接在网页上把它改名即可：

1. 打开浏览器，进入你的 GitHub 仓库主页
2. 点击正上方横向菜单最右边的 **Settings**（⚙️ 设置）
3. 在左侧菜单栏点击 **Branches**（分支）
4. 在右侧的 **Default branch** 区域，你会看到 `init-project` 名字右侧有一个 ✏️（小铅笔/重命名）图标
5. 点击它，将名字修改为：`main`，然后点击 **Rename** 确认

### 第二步：在本地 Mac 终端同步改名并重新绑定

为了防止你本地的终端和远程的 GitHub 名字对不上（本地还叫 `init-project`，远程叫 `main`），在 Mac 终端运行以下三行命令，让它们重新同步对齐：

```bash
# 1. 把你本地当前的 init-project 分支也重命名为 main
git branch -m init-project main

# 2. 从 GitHub 拉取最新的分支状态，对齐云端名字
git fetch origin

# 3. 重新建立本地 main 和远程 main 的追踪绑定
git push -u origin main
```


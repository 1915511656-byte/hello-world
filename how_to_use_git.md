Git 核心操作与规范化流转笔记1. 基础配置在首次使用 Git 时，必须配置作者信息，否则无法提交。bash# 配置全局用户名和邮箱
git config --global user.name "你的名字"
git config --global user.email "你的邮箱"

# 查看当前已有的配置列表
git config --list
请谨慎使用此类代码。2. 效率大杀器：设置别名 (Alias)将复杂的原生命令简化为快捷键，大幅提升日常输入效率。bashgit config --global alias.st status     # git st -> 查看工作区状态
git config --global alias.co checkout   # git co -> 切换分支
git config --global alias.ci commit     # git ci -> 提交代码
git config --global alias.br branch     # git br -> 管理分支
请谨慎使用此类代码。3. 约定式提交规范 (Conventional Commits)代码提交信息（Commit Message）需要带有特定前缀，方便后续追溯代码性质。公式：git commit -m "类型: 本次修改做了什么事" (注意：冒号后有一个空格)常用类型对照表：feat: 引入新功能（Feature）fix: 修复 Bugdocs: 仅修改了文档、Markdown 文件（Documentation）style: 修改代码格式、空格、分号等（不影响业务逻辑）refactor: 代码重构（既不是新功能，也不是修 Bug）4. 团队协作与分支保护开发流 (PR 流程)在 GitHub 开启了 main 分支保护（Branch Protection / Rulesets）后，标准的开发和合入流程如下：bash# 步骤 1：在本地创建一个独立的功能/修复分支，并无缝切换过去
git checkout -b <新分支名称>

# 步骤 2：在本地修改文件后，标记所有变动的文件
git add .

# 步骤 3：提交修改到本地仓库，并附带规范的 Commit 信息
git commit -m "docs: 完善项目说明文档"

# 步骤 4：将这个新分支推送到 GitHub 远程仓库（注意：不是推送给 main）
git push origin <新分支名称>
请谨慎使用此类代码。后续网页端操作：登录 GitHub 进入仓库，点击黄色提示条的 Compare & pull request。填写描述后点击 Create pull request 建立合并请求（PR）。等待团队成员 Review 并 Approve（或者配置管理员 Bypass 绕过）。按钮变绿后，点击 Merge pull request 正式将代码合入主分支。
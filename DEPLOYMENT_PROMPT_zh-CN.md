# 部署提示词

将下面整段发给 Codex、WorkBuddy 或其他能操作本地 Godot 项目的 Agent：

```text
请部署 GitHub 仓库 https://github.com/hjh939325136-alt/godot-dual-grid-terrain-kit 中的 Godot Dual Grid Terrain Kit，并严格按仓库内 skills/godot-tilemapdual-deployment/SKILL.md 执行。

目标：在当前 Godot 项目里安装依赖、TileMapDual，并准备好将 AI 风车母图编译为可直接绘制的 Dual Grid 地形刷。

要求：
1. 先检查 Godot。需要 Godot 4.7.1；如果未安装，从官方页面 https://godotengine.org/download/archive/4.7.1-stable/ 安装兼容版本。
2. 确认 Python 3；安装 Pillow：python -m pip install Pillow。
3. 安装 TileMapDual v5.0.2：优先 git clone https://github.com/pablogila/TileMapDual.git。
4. 如果 GitHub 无法访问，先检查清华大学开源软件镜像站 https://mirrors.tuna.tsinghua.edu.cn/ 是否提供可用的 Godot 或 GitHub 镜像条目；不要把其他第三方代理伪称为清华镜像。
5. 如果清华镜像也没有可用条目，让我到 https://kcnz41bksl1c.feishu.cn/wiki/NZo0wb9Sci1TkekZSJBcFZunnjd 下载完整本地压缩包后再继续；本地包内含离线 TileMapDual 插件。
6. 将插件放入目标项目 addons/TileMapDual，并在 Godot 的 Project > Project Settings > Plugins 启用 TileMapDual。
7. 保持像素图 nearest filtering；不要把 Dual Grid 当成 47-piece Blob Autotile。
8. 后续生图必须使用 skills/dual-grid-windmill-creation/SKILL.md：先理解我的游戏玩法、风格和参考图，再提供无辅助线风车参考图与提示词；我会在陶泥儿美术工具里固定选 1K、1:1、Nano Banana。
9. 收到我回传的 1024×1024 风车原图后，使用两个核心脚本生成 TileMapDual 4×4 图集、TileSet、TileMapDual 场景与可直接绘制的地形刷。

验收：在 Godot 编辑器用 TileMap 面板的 Tiles 标签绘制逻辑格，Dual Grid 显示层自动拼接；测试实心块、走廊、凹角、凸角、洞和对角格，不能有白底、缝隙、模糊或错误转角。
```

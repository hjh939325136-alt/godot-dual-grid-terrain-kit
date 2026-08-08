# Godot Dual Grid Terrain Kit

将一张连续的“风车母图”编译为 Godot 4 可直接绘制的 Dual Grid 地形刷。

本包面向 2D 地图游戏。它不要求美术手工画完 15 张独立瓦片：先用固定风车参考图让图像模型生成连续地形，再用脚本确定性切分、重排，并创建 TileMapDual 可用的 TileSet 和场景。

## 你会得到什么

- `skills/dual-grid-windmill-creation`：和用户沟通、生图、验图、编译和生成地形刷的 Skill。
- `skills/godot-tilemapdual-deployment`：Godot 与 TileMapDual 的安装/离线部署 Skill。
- `assets/windmill-reference-clean.png`：固定风车图规范的无辅助线参考图。
- 两个核心脚本：母图编译器、Godot TileMapDual 图集/场景构建器。

## 快速流程

1. 让 Agent 使用 `dual-grid-windmill-creation`，先询问玩法、目标风格和参考图。
2. Agent 给出“无辅助线风车参考图 + 生图提示词”。
3. 在陶泥儿美术工具生图，固定选择：`1K`、`1:1`、`Nano Banana`。
4. 把原始 `1024x1024` PNG 交回 Agent。
5. Agent 使用编译脚本生成 15-piece 中间图集。
6. Agent 在 Godot 项目中运行构建脚本，得到 `TileMapDual` 节点、TileSet 和可绘制地形刷。

## 安装依赖

需要：

- Godot `4.7.1` 或兼容的 Godot 4.7。
- Python 3 和 Pillow：`python -m pip install Pillow`
- TileMapDual `v5.0.2`。

详情见 `skills/godot-tilemapdual-deployment/SKILL.md`。离线插件和完整包不在公开仓库中，网络部署失败时按部署 Skill 下载本地 ZIP。

## 编译母图

在复制核心脚本到目标 Godot 项目的前提下：

```powershell
python .\tools\compile_dual_grid_windmill.py .\art\windmill_master.png `
  --out-dir .\assets\compiled `
  --tile-size 256 `
  --background-mode transparent
```

若源图是纯色不透明背景，可用 `--background-mode key-top-left`，但只适用于背景色与地形边缘颜色明确不同的图片。

## 构建 Godot 地形刷

先将 `build_tilemapdual_scene.gd` 内的资源路径和 `TILE` 改为目标项目值。然后在项目根目录运行：

```powershell
godot --headless --path . --script res://tools/build_tilemapdual_scene.gd
```

打开生成的 `tilemapdual_demo.tscn`：选中 `TileMapDual` 节点，在 TileMap 面板的 `Tiles` 标签选择完整地形块，直接绘制逻辑格。插件自动生成半格偏移的显示地形。

## 重要边界

- Dual Grid 是 `15-piece`/四角掩码系统，不是 `47-piece Blob Autotile`。
- 风车母图是连续来源图，不是最终地图，不要让图像模型生成 15 张独立 tile。
- 紫色辅助线不能进入最终美术源图。
- 想透明就必须是真实 alpha；白色、米色、棋盘格都不是透明。
- TileMapDual 的世界图默认从 `Tiles` 面板绘制；Godot 普通 `Terrains` 页为空不代表插件失效。

## 离线与许可

本仓库其他文档和脚本采用 [MIT License](LICENSE)。

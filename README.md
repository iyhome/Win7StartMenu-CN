# Windows 7 Start Menu CN (Win7StartMenu-CN)

一个忠实还原经典 **Windows 7 开始菜单** 的 KDE Plasma 6 小部件（Plasmoid），内置 **简体中文翻译**，并将「所有程序」改为 **扁平列表**（不再有分类文件夹）。

本项目是 [walterdemacedorodrigues/Windows7StartMenu4KDE](https://github.com/walterdemacedorodrigues/Windows7StartMenu4KDE) 的 fork，而后者又 fork 自 DeepinMenu ClassicKDE ([https://store.kde.org/p/2180887](https://store.kde.org/p/2180887))。

---

## ✨ 与上游的差异

* 🗂️ **「所有程序」扁平化**：不再显示分类文件夹，所有程序按字母顺序排列为一个列表。
* 🌏 **简体中文翻译**：内置 `zh_CN` 翻译（界面标签如「所有程序」「收藏夹」「关机」等）。
* 🏷️ **插件 ID 与显示名**：`win7startmenu-cn` / `Windows 7 Start Menu CN`。

---

## 🧩 功能特性

* 🧭 **双栏布局**：左侧为应用程序列表，右侧为上下文操作（文档、计算机、控制面板等）。
* 🕵️ **搜索栏**：快速搜索应用程序、文件和系统组件。
* ⭐ **固定应用**：支持用户自定义固定的应用程序。
* 🕑 **最近使用**：自动列出频繁或最近打开的应用程序。
* 🔒 **电源操作**：右下角提供关机、重启、休眠、注销等选项。
* 👤 **用户头像与名称**：显示当前用户的头像和用户名。
* 📌 **跳转列表**：每行应用可展开显示最近文档及 `.desktop` 文件发布的任务。
* 🎨 **外观可配置**：菜单、应用列表和侧边栏可分别设置着色与不透明度，并支持 ClassicShell/OpenShell 圆球贴图。
* ⌨️ **键盘导航**：整个菜单（含跳转列表）均可无鼠标操作。
* 🙈 **隐藏应用**：可从列表中隐藏条目，并在设置中恢复。

---

## 📦 安装

### 方式一：命令行

```sh
kpackagetool6 --type Plasma/Applet --install Win7StartMenu-CN
# 若已安装，升级：
kpackagetool6 --type Plasma/Applet --upgrade Win7StartMenu-CN
systemctl --user restart plasma-plasmashell.service
```

### 方式二：图形界面

右键面板 → 添加小部件 → 获取新小部件 → 从本地文件安装，选择 `Win7StartMenu-CN.plasmoid`。

---

## 🌍 翻译

翻译位于 `translate/`，编译产物在 `contents/locale/`。修改 `*.po` 后：

```sh
cd translate && sh ./build.sh --restartplasma
```

已内置：西班牙语、法语、希伯来语、韩语、荷兰语、波兰语、巴西葡萄牙语、俄语、土耳其语，以及 **简体中文 (zh_CN)**。

---

## 🔗 仓库

GitHub: [https://github.com/iyhome/Win7StartMenu-CN](https://github.com/iyhome/Win7StartMenu-CN)

上游: [https://github.com/walterdemacedorodrigues/Windows7StartMenu4KDE](https://github.com/walterdemacedorodrigues/Windows7StartMenu4KDE)

---

## 📄 许可证

本项目使用 AGPL-3.0-or-later 许可证，与随附的 [`LICENSE`](LICENSE) 文件一致。

---

## 📣 致谢

* **Windows7StartMenu4KDE** by Walter Rodrigues
* **DeepinMenu ClassicKDE**
* **SevenStart** by WackyIdeas:
  [https://gitgud.io/wackyideas/aerothemeplasma/-/tree/master/plasma/plasmoids/io.gitgud.wackyideas.SevenStart](https://gitgud.io/wackyideas/aerothemeplasma/-/tree/master/plasma/plasmoids/io.gitgud.wackyideas.SevenStart)

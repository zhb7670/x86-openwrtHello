# x86-openwrtHello

**基于 GitHub Actions 的 OpenWrt X86 专用云编译项目**

fork 自 [OpenWrtAction](https://github.com/zhb7670/OpenWrtAction)，专为 X86 软路由打造，支持三大源码平台自动编译 + 源码更新监控。

---

## 🚀 功能特性

| 功能 | 说明 |
|------|------|
| **三源码平台** | OpenWrt 官方 / ImmortalWrt / Lean LEDE 同时编译 |
| **X86 only** | 只编译 X86 设备，节省 CI 时间 |
| **自动更新检测** | 每週二、五自动检查上游源码更新 |
| **自动编译触发** | 检测到更新后自动触发编译 |
| **GHCR 缓存** | 编译缓存复用，加速二次构建 |
| **自动重试** | 编译失败自动重试，最多 3 次 |
| **Release 自动发布** | 编译完成后固件自动发布到 Releases |

---

## 📋 支持的平台

- ✅ **OpenWrt** (官方源码, branch: openwrt-25.12)
- ✅ **ImmortalWrt** (抗干扰版, branch: openwrt-25.12)
- ✅ **LEDE** (Lean 大源码, branch: master)

所有平台均只编译 **X86** 架构。

---

## 🔧 使用方法

### 1️⃣ Fork 本仓库

点击右上角 **Fork**，创建你的专属仓库。

### 2️⃣ 添加 GitHub Token

> ⚠️ 必须添加 `MY_ADMIN_PAT` Secret，否则无法触发自动编译和发布 Release

1. 在 GitHub 创建 Personal Access Token (PAT)
   - 权限需要：`repo`, `packages`, `workflow`
2. 进入你的仓库 → **Settings → Secrets → Actions**
3. 添加 New Secret：
   - Name: `MY_ADMIN_PAT`
   - Value: 粘贴你创建的 Token

### 3️⃣ 手动触发编译

1. 进入仓库 → **Actions** 页面
2. 选择 **`Build-OpenWrt-X86`** → **Run workflow**
3. 选择源码平台（OpenWrt / ImmortalWrt / LEDE）
4. 点击 **Run workflow**

### 4️⃣ 自动编译（推荐）

开启 **`Update_Checker`** workflow 后：
- 每週二、五 (00:00 UTC) 自动检查上游源码更新
- 检测到更新后自动触发 **`Build-OpenWrt-X86`** 编译
- 编译完成后固件自动发布到 Releases

### 5️⃣ 修改定时检查频率

编辑 `.github/workflows/Update_Checker.yml` 中的 cron：

```yaml
schedule:
  - cron: '0 0 * * 2,5'   # 每周二、周五 00:00 UTC
```

常用 cron 表达式：

| 表达式 | 说明 |
|--------|------|
| `0 0 * * *` | 每天 00:00 |
| `0 0 * * 2,5` | 每周二、五 |
| `0 */6 * * *` | 每 6 小时 |
| `0 9 * * *` | 每天 09:00 |

---

## 📁 项目结构

```
x86-openwrtHello/
├── .github/workflows/
│   ├── Build-OpenWrt-X86.yml    # 主编译流程
│   ├── Update_Checker.yml       # 源码更新检查 + 自动触发
│   ├── Retry_Failure_Jobs.yml   # 失败任务重试
│   └── Retry_All_Jobs.yml       # 全部任务重试
│
├── compile_script/              # 编译脚本
│   ├── platforms.sh            # 平台定义（X86 only）
│   ├── update_checker.sh        # 源码 Hash 检测
│   └── ...
│
├── config/
│   ├── leanlede_config/X86.config
│   ├── immortalwrt_config/X86.config
│   ├── openwrt_config/X86.config
│   └── seed/                   # 插件/主题配置
│
├── diy_script/                  # DIY 补丁脚本
│   ├── lean_diy/
│   ├── immortalwrt_diy/
│   └── openwrt_diy/
│
└── library/                     # 预下载文件
```

---

## ⚙️ 自定义配置（可选）

### 修改插件/主题

编辑 `config/seed/` 下的配置文件：
- `lean_seed.config` — Lean/LEDE 插件
- `immortalwrt_seed.config` — ImmortalWrt 插件
- `openwrt_seed.config` — OpenWrt 插件

删除不需要的 `CONFIG_PACKAGE_luci-app-xxx=y` 行即可。

### 修改 feeds 软件源

编辑 `diy_script/custom_feeds_and_packages.sh`，增删软件源。

### 修改默认 IP / SSH 端口

编辑 `diy_script/*/diy-part2.sh`：
- 默认 IP：`192.168.1.1` → `10.10.0.253`
- SSH：Dropbear 改到 2222，OpenSSH 用 22

---

## ⚠️ 注意事项

1. **MY_ADMIN_PAT 必须添加**，否则 `Update_Checker` 无法触发编译
2. GitHub Actions 免费额度每月 2000 分钟，X86 编译一次约 1.5-2 小时
3. 不需要翻墙插件可以删掉对应 `CONFIG_PACKAGE_xxx=y` 行来减小固件体积

---

## 📝 协议

本项目基于 [MIT License](LICENSE)，继承自 [OpenWrtAction](https://github.com/zhb7670/OpenWrtAction)。

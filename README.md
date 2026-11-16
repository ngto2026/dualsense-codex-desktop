# DualSense Codex Desktop

用 DualSense Edge 在 Windows 上控制鼠标、打开 Codex 最近会话并触发 Typeless 听写。这套配置曾在 Pico 2 W 将手柄呈现为 USB DualSense Edge 的环境下使用。

## 使用

1. 从 GitHub Releases 下载 Windows x64 ZIP，解压到固定目录。
2. 连接 DualSense Edge。如果使用 Pico 2 W，确认 Windows 已识别 USB 手柄。
3. 双击 `Start-DualSense.vbs` 静默启动。JoyShockMapper 图标在系统托盘，可用托盘菜单打开窗口、切换配置或退出。
4. 如需登录自启，按 Win + R，输入 `shell:startup`，把 `Start-DualSense.vbs` 的**快捷方式**放进去。

启动默认进入开发模式，体感常开。若触发不到 Typeless，在 Typeless 的听写设置里录入 □ 对应的菜单键，或按当前快捷键修改开发配置的 `W`。如需手柄麦克风，请在 Typeless 的音频设置中选 DualSense Edge，再用输入电平确认。

## 键位

| 手柄 | 开发模式 |
| --- | --- |
| Fn + ↑ / Fn + ↓ | 开发 / 游戏模式 |
| R3 / R1 | R3 切换体感常开或按住 R1 启用 |
| × / R2 | 鼠标左键 / 右键 |
| 触控板 | 滑动移动光标，按下左击 |
| △ | 恢复或启动 Codex，切到最近会话 |
| □ / 麦克风键 | Typeless 听写（Windows 菜单键） |
| ○ / Options | Enter / Delete |
| 十字键 | 键盘方向键 |

游戏模式停用桌面输出。体感采用 `PLAYER_TURN`，慢转和快扫使用不同灵敏度。△ 通过 F24 调用后台脚本，使用 Windows 上的 Codex 应用快捷键切换到最近会话。

## 打包

`Build-Release.ps1` 使用固定版本的 [JoyShockMapper v3.6.1](https://github.com/Electronicks/JoyShockMapper/releases/tag/v3.6.1) Windows x64 包，叠加本仓库的配置和脚本。可传入现有上游 ZIP：

```powershell
.\Build-Release.ps1 -UpstreamZip 'C:\path\to\JoyShockMapper_x64.zip'
```

JoyShockMapper 的许可证随上游程序一并打包。

知名代理插件 Proxy SwitchyOmega 作者此前在社交平台发表推文，Chrome 预计在今年六月停用扩展 Manifest V2 ，届时 #SwitchyOmega 将会无法使用，望周知。说真的10年前的技术栈+最近6年没更新的项目，竟然还能用这么久……如有人愿意fork维护或更新到V3请随意，但预计工作量巨大。而且这些年前端技术早已更新换代无数次了，真的还不如重写。 ——[信息来源](https://twitter.com/_catus/status/1759413399270936672)

这意味着在 2024 年 6 月过后将无法使用继续使用这款软件，不过目前已有众多热心网友开发出类似功能插件支持新版的Manifest V3，可作为SwitchyOmega 替代插件。以下是一些推荐：

## ZeroOmega

**[github地址](https://github.com/zero-peak/ZeroOmega)** ：https://github.com/zero-peak/ZeroOmega

ZeroOmega 是在 Proxy SwitchyOmega 基础上修改而成，同时支持新版的 manifest V3 。ZeroOmega 的管理界面与 SwitchyOmega 几乎一模一样，从 SwitchOmega 迁移过来的用户可以无痛替换，配置文件也支持导入导出。目前 ZeroOmega 支持 Chrome 、Firefox 和 Edge 客户端。
![](https://i163.alianga.com/2025/09/20250305153551781.png)

好用的是支持 github 的gist 备份，避免了 google 备份老是出故障的问题
![](https://i163.alianga.com/2025/09/6f7aa2b9d2940ecd.png)

![](https://i163.alianga.com/2025/09/800b8961d1625e76.png)



## SmartProxy

**[github地址](https://github.com/salarcode/SmartProxy)**：https://github.com/salarcode/SmartProxy


![](https://i163.alianga.com/2025/09/20250305154731275.png)

SmartProxy的设计灵感来源于现已停止更新的AutoProxy和AutoProxy-ng。SmartProxy基于WebExtensions全新编写，功能比之前的代理软件更为强大。同时支持 Chrome 和 Firefox 客户端。

###### **主要特性：**

- 根据代理规则自动判断何时启用或禁用某些网站的代理
- 在多个激活的代理服务器之间轻松切换
- 一键轻松将当前站点添加到您的代理列表中
- 查看当前的网站项目和请求，并决定是否一键启用代理k
- 轻松地切换代理模式或启用所有域的代理
- 通过订阅支持代理API
- 备份/恢复设置和规则

###### **请注意：**

- 🚫 SmartProxy不提供任何类型的代理服务器。
- 👀 SmartProxy绝不追踪用户隐私。
- ⭐️ SmartProxy完全不含任何广告。

## Proxy Rock

**[github地址](https://github.com/proxy-rock/proxy-rock)**：https://github.com/proxy-rock/proxy-rock

鉴于 SwitchyOmega 不再维护，Proxy Rock插件的目标为无缝替代 SwitchyOmega 。使用方法均和其保持一致，目前还处于开发状态，使用 manifest v3 版本进行完全重构，核心的代理功能已全部支持。目前插件仅支持 Chrome。

![](https://i163.alianga.com/2025/09/Proxy-Rock.webp)

###### **主要特性：**

Proxy 模式，即 so（Switchy Omega） 中的 Proxy Profile，此模式下配置好本地的代理服务，根据请求 schema 选择对应的协议。

Auto 模式，即 so 中 Switch Profile，此模式下可以根据设置的 Host 规则路由到不同的 Proxy 中，也可以下载在线的 PAC 格式资源进行匹配后再转发。

Pac 模式，即 so 中 Pac Profile，此模式下直接使用在线或者手动录入的 PAC 内容作为配置规则。建议熟悉 PAC 文件的同学使用。

###### **规则切换**

插件栏中点击小图标，可将配置好的规则展现出来，点击即可进行切换，同样在配置页面可以选择是否在切换时进行刷新。

另外，配置的规则会根据名字生成唯一的颜色标识，选中的配置所对应的颜色同样会在状态栏插件中体现出来
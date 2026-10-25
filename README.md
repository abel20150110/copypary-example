# Copyparty 多协议文件服务

基于 [Copyparty](https://github.com/9001/copyparty) 单文件版的本地文件共享部署，提供 HTTP、WebDAV、FTP、FTPS、SFTP、SMB/CIFS 和 TFTP 访问方式。

本目录不是 Copyparty 的完整源码仓库，而是一组可直接运行的程序、启动脚本和协议配置。所有协议默认共享 `/home/ftpuser`，账号与各协议的访问权限通过配置文件管理。

- 当前随附版本：**Copyparty 1.20.25**（2026-10-06）
- 运行环境：Linux、Bash、Python 3
- 默认共享目录：`/home/ftpuser`
- 部署目录：`/opt/softwares/copyparty`

## 目录说明

| 文件 | 用途 |
| --- | --- |
| `copyparty-sfx.py` | Copyparty 单文件可执行程序 |
| `accounts.conf` | 各协议共用的账号配置，包含明文密码，必须妥善保护 |
| `webdav.conf` | HTTP 与 WebDAV 配置 |
| `ftp-only.conf` | FTP 配置 |
| `ftps-only.conf` | FTPS 配置 |
| `sftp-only.conf` | SFTP 配置 |
| `smb-only.conf` | SMB/CIFS 配置 |
| `tftp-only.conf` | TFTP 配置 |
| `start*.sh` | 各协议的启动脚本，均在前台运行 |
| `ftp.conf` | 旧进程和手工命令使用的兼容配置；新启动脚本不使用它 |

## 快速开始

### 1. 检查运行环境

```bash
cd /opt/softwares/copyparty
python3 copyparty-sfx.py --version
```

确认共享目录存在，并且运行服务的用户对该目录具有所需的操作系统权限：

```bash
ls -ld /home/ftpuser
```

### 2. 配置账号

账号统一保存在 `accounts.conf`：

```ini
[accounts]
your_username:your_strong_password
```

请将示例替换为自己的用户名和强密码，不要把真实密码提交到公开仓库。建议仅允许运行服务的用户读取该文件：

```bash
chmod 600 accounts.conf
```

### 3. 启动服务

例如启动 HTTP 与 WebDAV：

```bash
./startWebDav.sh
```

服务在前台运行，按 `Ctrl+C` 停止。启动后访问：

```text
http://服务器地址:3923/
```

其他协议见下表。除 WebDAV 外，各协议默认只监听 `127.0.0.1`，即仅允许本机连接。

| 协议 | 启动命令 | 默认监听地址与端口 | 默认共享权限 |
| --- | --- | --- | --- |
| HTTP + WebDAV | `./startWebDav.sh` | 所有网卡，TCP `3923` | `rw` |
| FTP | `./startFtpOnly.sh` | `127.0.0.1:2121`，被动端口 TCP `12000-12099` | `rw` |
| FTPS | `./startFtps.sh` | `127.0.0.1:2121`，被动端口 TCP `12000-12099` | `rw` |
| SFTP | `./startSftp.sh` | `127.0.0.1:2222` | `rw` |
| SMB/CIFS | `./startSmb.sh` | `127.0.0.1:1445` | `r` |
| TFTP | `./startTftp.sh` | `127.0.0.1:6969/udp`，数据端口 UDP `12000-12099` | 匿名只读 |

`startFtp.sh` 和 `startFtpWithConf.sh` 是兼容入口，都会转发到 `startFtpOnly.sh`。

## 各协议使用说明

### HTTP 与 WebDAV

```bash
./startWebDav.sh
```

- HTTP 页面和 WebDAV 共用 TCP `3923`。
- 配置中的 `i: ::` 表示监听所有网卡，局域网内其他设备可能直接访问。
- 当前账号具有上传和下载权限，但没有移动、重命名和永久删除权限。
- HTTP 不加密；不可信网络中应使用 HTTPS 反向代理，不要直接暴露到公网。

使用 curl 下载或上传文件：

```bash
# 下载
curl -u your_username http://127.0.0.1:3923/example.txt -o example.txt

# 上传
curl -u your_username -T ./example.txt http://127.0.0.1:3923/example.txt
```

执行后按提示输入密码即可。

### FTP

```bash
./startFtpOnly.sh
```

FTP 使用 TCP `2121` 作为控制端口，并使用 TCP `12000-12099` 作为被动数据端口。

> **注意：** FTP 的账号密码和文件内容均不加密，只应在可信网络中使用。需要加密传输时优先选择 SFTP 或正确配置证书后的 FTPS。

### FTPS

FTPS 需要可信证书、匹配的私钥以及 Python 环境中的 PyOpenSSL。脚本不会使用不安全的自动生成证书作为回退。

```bash
python3 -m pip install pyopenssl

COPYPARTY_TLS_CERT=/path/to/fullchain.pem \
COPYPARTY_TLS_KEY=/path/to/private-key.pem \
./startFtps.sh
```

证书和私钥必须可读，私钥不应向其他本机用户开放。未设置环境变量、缺少 PyOpenSSL 或证书不可读时，脚本会直接退出。

### SFTP

```bash
./startSftp.sh
```

SFTP 是基于 SSH 的文件传输协议，与 FTPS 不同。当前配置允许使用 `accounts.conf` 中的账号密码登录。

```bash
sftp -P 2222 your_username@127.0.0.1
```

如需更高安全性，可在 `sftp-only.conf` 中配置 `sftp-key` 用户公钥；确认密钥登录可用后，再考虑禁用 `sftp-pw` 密码登录。

### SMB/CIFS

Copyparty 当前版本明确警告 SMB 功能存在风险且可能不稳定，因此脚本默认拒绝启动。仅在隔离、可信的局域网中评估并接受风险后运行：

```bash
COPYPARTY_I_ACCEPT_SMB_RISK=1 ./startSmb.sh
```

- 默认仅监听本机，共享为只读。
- 不要启用 `smbw`，不要暴露到公网。
- 默认端口为非特权端口 `1445`；部分 SMB 客户端默认只连接 `445`，可能需要额外的端口映射。

### TFTP

```bash
./startTftp.sh
```

TFTP 没有用户名或密码认证。当前配置向所有允许连接的客户端提供匿名只读访问，默认通过监听地址和 `tftp-ipa` 限制为仅本机。

不要将 TFTP 暴露到公网，也不要在共享目录中放置任何不适合公开读取的文件。

## 权限说明

各协议配置中的卷权限采用 Copyparty ACL：

| 权限 | 含义 |
| --- | --- |
| `r` | 列出、读取和下载文件 |
| `w` | 写入和上传文件 |
| `rw` | 读取与写入，但不包含移动、重命名或永久删除 |
| `m` | 移动和重命名，需要与相应读写权限组合使用 |
| `d` | 永久删除，需要与相应权限组合使用 |

例如，在协议配置的 `accs` 段中为用户增加移动和删除权限：

```ini
[/]
/home/ftpuser
accs:
  rwmd: your_username
```

只授予实际需要的权限。除 ACL 外，运行服务的操作系统用户也必须拥有共享目录的相应文件系统权限。

## 允许局域网访问

修改配置前先停止服务，修改后重新启动。监听地址应优先设置为服务器的指定局域网地址，并配合防火墙限制来源，而不是直接暴露到公网。

| 协议 | 需要修改的配置 | 防火墙需要放行的端口 |
| --- | --- | --- |
| HTTP + WebDAV | `webdav.conf` 中的 `i`；默认已监听所有网卡 | TCP `3923` |
| FTP | `ftp-only.conf` 中的 `ftp-i` | TCP `2121`、`12000-12099` |
| FTPS | `ftps-only.conf` 中的 `ftp-i` | TCP `2121`、`12000-12099` |
| SFTP | `sftp-only.conf` 中的 `sftp-i` | TCP `2222` |
| SMB/CIFS | `smb-only.conf` 中的 `smb-i` | TCP `1445` |
| TFTP | `tftp-only.conf` 中的 `tftp-i` 和 `tftp-ipa` | UDP `6969`、`12000-12099` |

FTP/FTPS 位于 NAT 后方时，还需要将 `ftp-nat` 配置为客户端可访问的公网地址，并正确转发控制端口和完整被动端口范围。

## 后台运行与停止

启动脚本默认在前台运行，推荐交由 systemd、supervisord 等进程管理器托管。临时使用 `nohup` 时，可以分别保存日志和 PID：

```bash
cd /opt/softwares/copyparty
mkdir -p logs
nohup ./startWebDav.sh > logs/webdav.log 2>&1 &
echo $! > logs/webdav.pid
```

查看日志：

```bash
tail -f logs/webdav.log
```

停止该实例：

```bash
kill "$(cat logs/webdav.pid)"
rm -f logs/webdav.pid
```

不同协议应使用不同的日志和 PID 文件。不要使用模糊的 `pkill -f copyparty-sfx.py`，以免误停其他正在运行的 Copyparty 实例。

## 常见问题

### 启动时提示地址或端口已被占用

检查对应端口：

```bash
ss -lntup | grep -E ':(3923|2121|2222|1445|6969)\b'
```

停止旧实例，或在对应配置中修改端口；同时记得调整防火墙和客户端连接地址。

### 局域网设备无法连接

先确认服务并非只监听 `127.0.0.1`，再检查防火墙、云服务安全组及客户端是否使用了正确端口。FTP、FTPS 和 TFTP 还需要放行数据端口范围。

### 可以上传，但不能重命名或删除

这是当前 `rw` 权限的预期行为。确有需要时，在对应协议的卷 ACL 中增加 `m` 或 `d`，然后重启该服务。

### FTPS 启动失败

检查 `COPYPARTY_TLS_CERT`、`COPYPARTY_TLS_KEY` 是否指向可读的匹配文件，并确认运行脚本所用的 `python3` 环境可以执行 `import OpenSSL`。

### SMB 启动后立即退出

脚本要求显式设置 `COPYPARTY_I_ACCEPT_SMB_RISK=1`。该开关用于确认已了解风险，不代表 SMB 功能已经适合不可信网络或生产环境。

## 安全检查清单

- 使用强且唯一的密码，保护 `accounts.conf` 和旧配置 `ftp.conf` 中的账号信息。
- 不在 README、脚本、日志或公开仓库中记录真实密码和私钥。
- 不在不可信网络中使用明文 HTTP 或 FTP。
- 不向公网暴露 SMB 或 TFTP。
- 仅在确认需要时开放移动、重命名和删除权限。
- 定期检查监听地址、防火墙规则、共享目录内容及服务日志。
- 对外提供 WebDAV 时，优先使用 HTTPS 反向代理并限制访问来源。

## 上游项目

- Copyparty 项目主页：<https://github.com/9001/copyparty>
- 完整参数说明：运行 `python3 copyparty-sfx.py --help`

本目录中的协议参数以当前随附版本和实际配置为准；升级 `copyparty-sfx.py` 后，应重新核对参数兼容性与安全警告。

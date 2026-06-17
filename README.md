# 🛡️ Secure MTProto Proxy (Fake-TLS + Sponsor Channel)

![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
![Security](https://img.shields.io/badge/Security-Hardened-green?style=for-the-badge)
![Telegram](https://img.shields.io/badge/Telegram-2CA5E0?style=for-the-badge&logo=telegram&logoColor=white)

A production-grade, containerized implementation of the official Telegram MTProto Proxy. This repository is architected for maximum evasion against Deep Packet Inspection (DPI) firewalls using `ee` prefixed Fake-TLS secrets, while natively supporting promoted channels for monetization or brand visibility.

## 🏗️ Architecture & AppSec Highlights

- **DPI Evasion (Fake-TLS):** Prioritizes port 443 and utilizes high-reputation cover domains (default: `cloudflare.com`) to make traffic indistinguishable from standard HTTPS.
- **Least Privilege Execution:** Container capabilities are heavily restricted. `ALL` capabilities are dropped, selectively adding only `NET_BIND_SERVICE`, `CHOWN`, `SETUID`, `SETGID`, and `DAC_OVERRIDE` to minimize the blast radius of potential vulnerabilities.
- **High Concurrency:** OS-level file descriptor limits (`ulimits`) are tuned to `1048576` (soft/hard) to support massive concurrent user connections without socket starvation.
- **Automated Cryptography:** Dynamically generates cryptographically secure 16-byte hex secrets natively mapped to the SNI payload.

## 📋 Prerequisites

- A Linux-based server (Ubuntu/Debian recommended) with a public IP address.
- [Docker](https://docs.docker.com/get-docker/) and [Docker Compose](https://docs.docker.com/compose/install/) installed.
- Port `443` open on your server's firewall.

## 🚀 Quick Start

**1. Clone the repository**
```bash
git clone [https://github.com/visatk/mtg.git](https://github.com/visatk/mtg.git)
cd mtg

```

**2. Make the setup script executable**

```bash
chmod +x setup_mtproxy.sh

```

**3. Register your Proxy & Get an Ad Tag**
To monetize or promote a channel, you must register your proxy with Telegram:

1. Open Telegram and start a chat with [@MTProxybot](https://t.me/MTProxybot).
2. Send `/newproxy` and provide your server's public IP and port (e.g., `1.2.3.4:443`).
3. Generate a temporary secret or use a placeholder to complete registration.
4. Send `/myproxies`, select your proxy, and choose **"Set Ad"**.
5. Provide your channel username (e.g., `@MyChannel`).
6. The bot will reply with a 32-character hex **Ad Tag**. Save this.

**4. Deploy the Infrastructure**

```bash
./setup_mtproxy.sh

```

*When prompted, paste the 32-character Ad Tag obtained from `@MTProxybot`.*

The script will automatically generate your AppSec-compliant Fake-TLS secret, deploy the Docker container, and output your final shareable `t.me` connection link.

## ⚙️ Configuration Tuning

Modify `docker-compose.yml` to scale workers based on your CPU cores:

```yaml
    environment:
      - WORKERS=4 # Scale this to match your host's logical CPU cores

```

To change the Fake-TLS cover domain (if `cloudflare.com` is blocked in your target region), edit `setup_mtproxy.sh`:

```bash
COVER_DOMAIN="google.com" # Ensure this is a TLS 1.3 enabled domain

```

## 🔍 Troubleshooting

**Logs:**
View real-time connection and worker logs:

```bash
docker logs -f mtproxy

```

**Container Restart:**

```bash
docker-compose restart

```

## 📜 License

Distributed under the MIT License. See `LICENSE` for more information.

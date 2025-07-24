# 🛡️ Advanced Reconnaissance Tool

<div align="center">

**Professional Cybersecurity Reconnaissance Framework**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Bash](https://img.shields.io/badge/Language-Bash-green.svg)](https://www.gnu.org/software/bash/)
[![Platform](https://img.shields.io/badge/Platform-Linux-blue.svg)](https://www.linux.org/)
[![Version](https://img.shields.io/badge/Version-2.0-red.svg)](https://github.com/keym11/advanced-reconnaissance-tool)

*A comprehensive, automated reconnaissance framework for authorized security assessments*

[Features](#-features) • [Installation](#-installation) • [Usage](#-usage) • [Documentation](#-documentation) • [Contributing](#-contributing)

</div>

---

## 📋 **Table of Contents**

- [Overview](#-overview)
- [Features](#-features)
- [Prerequisites](#-prerequisites)
- [Installation](#-installation)
- [Quick Start](#-quick-start)
- [Usage Guide](#-usage-guide)
- [Output Structure](#-output-structure)
- [Examples](#-examples)
- [Legal & Ethics](#-legal--ethics)
- [Contributing](#-contributing)
- [License](#-license)
- [Acknowledgments](#-acknowledgments)

---

## 🎯 **Overview**

The **Advanced Reconnaissance Tool** is a professional-grade cybersecurity framework designed for authorized penetration testing and security assessments. Built with industry-standard tools and methodologies, it automates the reconnaissance phase of ethical hacking while maintaining a focus on legal and responsible use.

### **🎨 Why This Tool?**

- **🏢 Professional Grade**: Built with industry-standard tools used by professional pentesters
- **🚀 Automated Workflow**: Streamlines hours of manual reconnaissance into minutes
- **📊 Comprehensive Reporting**: Generates executive summaries and technical reports
- **🎯 Competition Ready**: Designed for cybersecurity competitions and educational use
- **🛡️ Ethical Focus**: Emphasizes authorized use and responsible disclosure

---

## ✨ **Features**

### **🔍 Core Reconnaissance Modules**

| Module | Description | Tools Used | Duration |
|--------|-------------|------------|----------|
| **🏠 Host Discovery** | Network connectivity and basic enumeration | `ping`, `host`, `dig` | 1-2 min |
| **🌐 DNS Enumeration** | Comprehensive DNS record analysis | `dig`, `host`, `nslookup` | 3-5 min |
| **🔍 Subdomain Discovery** | Multi-source subdomain enumeration | `subfinder`, `amass`, `custom` | 10-30 min |
| **🚪 Port Scanning** | Advanced port and service detection | `nmap`, `masscan` | 5-20 min |
| **🌍 Web Analysis** | HTTP/HTTPS application assessment | `gobuster`, `nikto`, `whatweb` | 15-45 min |
| **🔐 SSL/TLS Analysis** | Certificate and encryption assessment | `openssl`, `custom scripts` | 2-5 min |
| **📋 Intelligence Gathering** | WHOIS and domain registration data | `whois`, `custom parsing` | 1-2 min |

### **🎛️ Scan Types**

- **⚡ Quick Scan** (5-10 min): Basic discovery for rapid assessment
- **🔍 Standard Scan** (15-30 min): Comprehensive baseline reconnaissance  
- **🚀 Comprehensive Scan** (45-90 min): Complete professional-grade assessment
- **⚙️ Custom Scan** (Variable): User-selected modules for targeted analysis

### **💎 Professional Features**

- **🎨 Beautiful Interface**: Professional UI with progress bars and color coding
- **📊 Executive Reporting**: Business-ready summaries and technical reports
- **📁 Organized Output**: Structured directory hierarchy for easy analysis
- **🔄 Continuous Operation**: Menu-driven workflow for multiple targets
- **⚠️ Error Handling**: Professional error management and recovery
- **📝 Comprehensive Logging**: Detailed execution logs for audit trails

---

## 🔧 **Prerequisites**

### **System Requirements**
- **OS**: Ubuntu 20.04+ / Debian-based Linux distributions
- **Memory**: 2GB RAM minimum (4GB recommended)
- **Storage**: 1GB free space for tools and results
- **Network**: Internet connection for tool updates and intelligence gathering
- **Privileges**: sudo access for advanced scanning features

### **Required Tools**
The tool integrates these professional security applications:

**System Packages:**
```bash
nmap dnsutils curl whois netcat-openbsd masscan nikto whatweb openssl git golang-go
```

**Go-based Security Tools:**
```bash
subfinder amass gobuster httpx assetfinder
```

---

## 🚀 **Installation**

### **Automated Setup (Recommended)**

```bash
# Clone the repository
git clone https://github.com/keym11/advanced-reconnaissance-tool.git
cd advanced-reconnaissance-tool

# Make scripts executable
chmod +x recon.sh setup.sh

# Run automated setup (installs all dependencies)
./setup.sh

# Verify installation
./recon.sh --help
```

### **Manual Installation**

<details>
<summary>Click to expand manual installation steps</summary>

```bash
# Update system packages
sudo apt update && sudo apt upgrade -y

# Install system packages
sudo apt install -y nmap dnsutils curl whois netcat-openbsd masscan nikto whatweb openssl git golang-go

# Install Go-based tools
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/owasp-amass/amass/v4/...@master
go install github.com/OJ/gobuster/v3@latest

# Add Go binaries to PATH
echo 'export PATH=$PATH:$HOME/go/bin' >> ~/.bashrc
source ~/.bashrc

# Install wordlists
sudo git clone https://github.com/danielmiessler/SecLists.git /usr/share/seclists
```

</details>

---

## ⚡ **Quick Start**

```bash
# Basic usage - interactive mode
./recon.sh example.com

# Quick scan for rapid results
./recon.sh example.com quick

# Comprehensive scan for full assessment
./recon.sh example.com comprehensive

# Custom scan with selected modules
./recon.sh example.com custom
```

---

## ⚖️ **Legal & Ethics**

### **🚨 IMPORTANT LEGAL DISCLAIMER**

This tool is designed for **authorized security testing and educational purposes only**.

#### **✅ AUTHORIZED USES:**
- **Educational learning** in controlled environments
- **Authorized penetration testing** with written permission
- **Security assessments** on systems you own
- **Cybersecurity competitions** within defined scope
- **Professional security consulting** with proper contracts

#### **🚫 PROHIBITED USES:**
- Scanning systems **without explicit authorization**
- Any **illegal or unauthorized activities**
- Violating **terms of service** or computer misuse laws
- **Malicious attacks** or unauthorized access attempts

#### **📋 REQUIREMENTS:**
- ✅ **Always obtain written permission** before scanning any target
- ✅ **Respect scope limitations** and rules of engagement  
- ✅ **Follow responsible disclosure** for vulnerabilities found
- ✅ **Comply with local laws** and regulations
- ✅ **Use for educational purposes** and professional development

---

## 🤝 **Contributing**

We welcome contributions from the cybersecurity community! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

### **🎯 Ways to Contribute**
- 🐛 **Bug Reports**: Found an issue? Let us know!
- ✨ **Feature Requests**: Ideas for new reconnaissance modules
- 📖 **Documentation**: Improve guides and examples
- 🔧 **Code Improvements**: Performance and functionality enhancements

---

## 📄 **License**

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 **Acknowledgments**

### **🛠️ Integrated Security Tools**
- **[Nmap](https://nmap.org/)** - Network discovery and security auditing
- **[Subfinder](https://github.com/projectdiscovery/subfinder)** - Subdomain discovery tool
- **[Amass](https://github.com/OWASP/Amass)** - OWASP network mapping tool
- **[Gobuster](https://github.com/OJ/gobuster)** - Directory/file & DNS busting tool
- **[Nikto](https://cirt.net/Nikto2)** - Web server vulnerability scanner
- **[WhatWeb](https://github.com/urbanadventurer/WhatWeb)** - Web application fingerprinter

---

<div align="center">

**⭐ Star this repository if it helped you learn cybersecurity!**

**🔐 Remember: With great power comes great responsibility. Use ethically!**

---

*Built with ❤️ for the cybersecurity education community*

**Author**: saud and rashid  
**Contact**: [saud69262@gmail.com](mailto:saud69262@gmail.com)  
**GitHub**: [@keym11](https://github.com/keym11)

</div>

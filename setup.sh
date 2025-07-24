#!/bin/bash

# Setup script for Advanced Reconnaissance Tool
# This script installs all required dependencies

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=====================================================${NC}"
echo -e "${BLUE}      Advanced Reconnaissance Tool Setup${NC}"
echo -e "${BLUE}=====================================================${NC}"

# Check if running as root for some installations
check_root() {
    if [[ $EUID -eq 0 ]]; then
        echo -e "${YELLOW}[INFO]${NC} Running as root - good for system package installation"
    else
        echo -e "${YELLOW}[INFO]${NC} Running as user - may need sudo for some installations"
    fi
}

# Update system packages
update_system() {
    echo -e "\n${GREEN}[STEP 1]${NC} Updating system packages..."
    sudo apt update && sudo apt upgrade -y
}

# Install basic packages
install_basic_packages() {
    echo -e "\n${GREEN}[STEP 2]${NC} Installing basic reconnaissance tools..."
    
    local packages=(
        "nmap"
        "dnsutils"          # dig, host
        "curl"
        "whois"
        "netcat-openbsd"    # nc
        "masscan"
        "nikto"
        "whatweb"
        "openssl"
        "git"
        "wget"
        "unzip"
        "golang-go"         # for Go-based tools
    )
    
    for package in "${packages[@]}"; do
        echo -e "${YELLOW}[INSTALL]${NC} Installing $package..."
        if sudo apt install -y "$package"; then
            echo -e "${GREEN}[SUCCESS]${NC} $package installed"
        else
            echo -e "${RED}[ERROR]${NC} Failed to install $package"
        fi
    done
}

# Install Go-based tools
install_go_tools() {
    echo -e "\n${GREEN}[STEP 3]${NC} Installing Go-based reconnaissance tools..."
    
    # Setup Go environment
    if ! command -v go &> /dev/null; then
        echo -e "${RED}[ERROR]${NC} Go is not installed. Installing Go first..."
        wget https://go.dev/dl/go1.21.0.linux-amd64.tar.gz
        sudo tar -C /usr/local -xzf go1.21.0.linux-amd64.tar.gz
        echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
        export PATH=$PATH:/usr/local/go/bin
        rm go1.21.0.linux-amd64.tar.gz
    fi
    
    # Add Go bin to PATH
    export GOPATH=$HOME/go
    export PATH=$PATH:$GOPATH/bin
    echo 'export GOPATH=$HOME/go' >> ~/.bashrc
    echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.bashrc
    
    # Install subfinder
    echo -e "${YELLOW}[INSTALL]${NC} Installing subfinder..."
    go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
    
    # Install amass
    echo -e "${YELLOW}[INSTALL]${NC} Installing amass..."
    go install -v github.com/owasp-amass/amass/v4/...@master
    
    # Install gobuster
    echo -e "${YELLOW}[INSTALL]${NC} Installing gobuster..."
    go install github.com/OJ/gobuster/v3@latest
    
    # Install httpx
    echo -e "${YELLOW}[INSTALL]${NC} Installing httpx..."
    go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
    
    # Install assetfinder
    echo -e "${YELLOW}[INSTALL]${NC} Installing assetfinder..."
    go install github.com/tomnomnom/assetfinder@latest
}

# Install wordlists
install_wordlists() {
    echo -e "\n${GREEN}[STEP 4]${NC} Installing wordlists..."
    
    # Install SecLists
    if [[ ! -d "/usr/share/seclists" ]]; then
        echo -e "${YELLOW}[INSTALL]${NC} Installing SecLists..."
        sudo git clone https://github.com/danielmiessler/SecLists.git /usr/share/seclists
    else
        echo -e "${GREEN}[EXISTS]${NC} SecLists already installed"
    fi
    
    # Install dirb wordlists if not present
    if [[ ! -d "/usr/share/wordlists/dirb" ]]; then
        sudo apt install -y dirb
    fi
    
    # Create custom wordlist directory
    mkdir -p ~/.recon_wordlists
    
    # Download additional wordlists
    if [[ ! -f ~/.recon_wordlists/subdomains.txt ]]; then
        echo -e "${YELLOW}[DOWNLOAD]${NC} Downloading subdomain wordlist..."
        wget -O ~/.recon_wordlists/subdomains.txt https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/DNS/subdomains-top1million-5000.txt
    fi
    
    if [[ ! -f ~/.recon_wordlists/directories.txt ]]; then
        echo -e "${YELLOW}[DOWNLOAD]${NC} Downloading directory wordlist..."
        wget -O ~/.recon_wordlists/directories.txt https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/directory-list-2.3-medium.txt
    fi
}

# Setup script permissions and location
setup_script() {
    echo -e "\n${GREEN}[STEP 5]${NC} Setting up reconnaissance script..."
    
    # Make recon script executable
    if [[ -f "recon.sh" ]]; then
        chmod +x recon.sh
        echo -e "${GREEN}[SUCCESS]${NC} Made recon.sh executable"
        
        # Optional: Install to /usr/local/bin for system-wide access
        read -p "Install recon.sh to /usr/local/bin for system-wide access? (y/N): " install_global
        if [[ $install_global =~ ^[Yy]$ ]]; then
            sudo cp recon.sh /usr/local/bin/recon
            echo -e "${GREEN}[SUCCESS]${NC} Installed as 'recon' command system-wide"
        fi
    else
        echo -e "${RED}[ERROR]${NC} recon.sh not found in current directory"
    fi
}

# Configure environment
configure_environment() {
    echo -e "\n${GREEN}[STEP 6]${NC} Configuring environment..."
    
    # Create recon directory structure
    mkdir -p ~/recon/{scripts,wordlists,results}
    
    # Set environment variables
    cat >> ~/.bashrc << 'EOF'

# Reconnaissance Tool Configuration
export RECON_HOME="$HOME/recon"
export RECON_WORDLISTS="$HOME/.recon_wordlists"
alias recon-quick="recon.sh"
alias recon-full="recon.sh --comprehensive"
EOF
    
    echo -e "${GREEN}[SUCCESS]${NC} Environment configured"
}

# Final verification
verify_installation() {
    echo -e "\n${GREEN}[STEP 7]${NC} Verifying installation..."
    
    local tools=("nmap" "dig" "curl" "whois" "nc" "masscan" "nikto" "whatweb" "subfinder" "amass" "gobuster")
    local missing=()
    
    for tool in "${tools[@]}"; do
        if command -v "$tool" &> /dev/null; then
            echo -e "${GREEN}[✓]${NC} $tool"
        else
            echo -e "${RED}[✗]${NC} $tool"
            missing+=("$tool")
        fi
    done
    
    if [[ ${#missing[@]} -eq 0 ]]; then
        echo -e "\n${GREEN}[SUCCESS]${NC} All tools installed successfully!"
    else
        echo -e "\n${YELLOW}[WARNING]${NC} Missing tools: ${missing[*]}"
        echo "You may need to manually install these or add them to your PATH"
    fi
}

# Create usage examples
create_examples() {
    echo -e "\n${GREEN}[STEP 8]${NC} Creating usage examples..."
    
    cat > ~/recon/examples.txt << 'EOF'
Advanced Reconnaissance Tool - Usage Examples
============================================

Basic Usage:
-----------
./recon.sh example.com
./recon.sh 192.168.1.1

Scan Types:
----------
./recon.sh example.com quick          # Quick scan
./recon.sh example.com standard       # Standard scan  
./recon.sh example.com comprehensive  # Full scan

Interactive Mode:
----------------
./recon.sh example.com                # Shows menu

Output:
-------
Results are saved in: recon_TARGET_TIMESTAMP/
- nmap/           # Port scan results
- dns/            # DNS enumeration
- web/            # Web enumeration
- subdomains/     # Subdomain discovery
- vulnerabilities/ # Vulnerability scans
- recon.log       # Detailed logs

Best Practices:
--------------
1. Always get proper authorization before scanning
2. Use VPN for anonymity if needed
3. Respect rate limits and be ethical
4. Review logs for any errors or issues
5. Backup important results

Advanced Usage:
--------------
# Scan with custom timing
nmap -T1 target.com  # Paranoid (slowest)
nmap -T5 target.com  # Insane (fastest)

# Custom wordlists
gobuster dir -u http://target.com -w /usr/share/seclists/Discovery/Web-Content/big.txt

# SSL enumeration
nmap --script ssl-enum-ciphers -p 443 target.com
EOF
    
    echo -e "${GREEN}[SUCCESS]${NC} Examples created in ~/recon/examples.txt"
}

# Main setup function
main() {
    check_root
    update_system
    install_basic_packages
    install_go_tools
    install_wordlists
    setup_script
    configure_environment
    verify_installation
    create_examples
    
    echo -e "\n${BLUE}=====================================================${NC}"
    echo -e "${GREEN}[COMPLETE]${NC} Setup finished!"
    echo -e "${BLUE}=====================================================${NC}"
    echo ""
    echo -e "${YELLOW}Next steps:${NC}"
    echo "1. Source your bashrc: source ~/.bashrc"
    echo "2. Test the tool: ./recon.sh --help"
    echo "3. Run a test scan: ./recon.sh google.com quick"
    echo "4. Check examples: cat ~/recon/examples.txt"
    echo ""
    echo -e "${GREEN}Happy hunting! Use responsibly.${NC}"
}

# Run main function
main "$@"

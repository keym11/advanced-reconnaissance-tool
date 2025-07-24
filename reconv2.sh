#!/bin/bash

# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                    ADVANCED RECONNAISSANCE TOOL v2.0                        ║
# ║                        Professional Cybersecurity Suite                     ║
# ║                              Competition Edition                             ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

# Enhanced Color Palette
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly WHITE='\033[1;37m'
readonly GRAY='\033[0;37m'
readonly BOLD='\033[1m'
readonly DIM='\033[2m'
readonly UNDERLINE='\033[4m'
readonly BLINK='\033[5m'
readonly NC='\033[0m' # No Color

# Background Colors
readonly BG_RED='\033[41m'
readonly BG_GREEN='\033[42m'
readonly BG_BLUE='\033[44m'
readonly BG_CYAN='\033[46m'

# Global Variables
TARGET=""
OUTPUT_DIR=""
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
TOTAL_STEPS=0
CURRENT_STEP=0

# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                              VISUAL ELEMENTS                                 ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

# Enhanced Banner with Animation
show_banner() {
    clear
    echo -e "${BOLD}${CYAN}"
    cat << 'EOF'
    ╔══════════════════════════════════════════════════════════════════════════════╗
    ║                                                                              ║
    ║      ██████  ███████  ██████  ██████  ███    ██     ██    ██ ██████          ║
    ║      ██   ██ ██      ██      ██    ██ ████   ██     ██    ██      ██         ║
    ║      ██████  █████   ██      ██    ██ ██ ██  ██     ██    ██  █████          ║
    ║      ██   ██ ██      ██      ██    ██ ██  ██ ██      ██  ██  ██              ║
    ║      ██   ██ ███████  ██████  ██████  ██   ████       ████   ███████         ║
    ║                                                                              ║
    ║                    🛡️  ADVANCED RECONNAISSANCE TOOL  🛡️                        ║
    ║                                                                              ║
    ║                        ⚡ Professional Edition v2.0 ⚡                       ║
    ║                                                                              ║
    ╚══════════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    
    echo -e "${BOLD}${WHITE}                        🎯 CYBERSECURITY COMPETITION READY 🎯${NC}"
    echo -e "${DIM}${GRAY}                           Professional Penetration Testing Suite${NC}"
    echo ""
    echo -e "${YELLOW}${BOLD} ⚠️  WARNING: ${NC}${YELLOW}Use only on authorized targets with explicit permission${NC}"
    echo -e "${GREEN}${BOLD} ✅ LEGAL:   ${NC}${GREEN}Educational purposes and authorized security assessments${NC}"
    echo ""
    
    # Loading animation
    printf "${CYAN}${BOLD}[INFO]${NC} Initializing Advanced Reconnaissance Framework"
    for i in {1..3}; do
        printf "."
        sleep 0.3
    done
    echo -e " ${GREEN}✓${NC}"
    echo ""
}

# Progress Bar Function
show_progress() {
    local current=$1
    local total=$2
    local width=50
    local percentage=$((current * 100 / total))
    local completed=$((current * width / total))
    
    printf "\r${BOLD}${BLUE}[PROGRESS]${NC} ["
    
    # Fill completed portion
    for ((i=0; i<completed; i++)); do
        printf "${GREEN}█${NC}"
    done
    
    # Fill remaining portion
    for ((i=completed; i<width; i++)); do
        printf "${DIM}░${NC}"
    done
    
    printf "] ${BOLD}%d%%${NC} (Step %d/%d)" "$percentage" "$current" "$total"
}

# Enhanced Logging Functions
log_info() {
    local timestamp=$(date '+%H:%M:%S')
    echo -e "${BOLD}${GREEN}[${timestamp}]${NC} ${CYAN}ℹ️  INFO:${NC} $1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] INFO: $1" >> "$OUTPUT_DIR/recon.log"
}

log_success() {
    local timestamp=$(date '+%H:%M:%S')
    echo -e "${BOLD}${GREEN}[${timestamp}]${NC} ${GREEN}✅ SUCCESS:${NC} $1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] SUCCESS: $1" >> "$OUTPUT_DIR/recon.log"
}

log_error() {
    local timestamp=$(date '+%H:%M:%S')
    echo -e "${BOLD}${RED}[${timestamp}]${NC} ${BG_RED}${WHITE} ❌ ERROR ${NC} $1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: $1" >> "$OUTPUT_DIR/recon.log"
}

log_warning() {
    local timestamp=$(date '+%H:%M:%S')
    echo -e "${BOLD}${YELLOW}[${timestamp}]${NC} ${YELLOW}⚠️  WARNING:${NC} $1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] WARNING: $1" >> "$OUTPUT_DIR/recon.log"
}

log_critical() {
    local timestamp=$(date '+%H:%M:%S')
    echo -e "${BOLD}${RED}[${timestamp}]${NC} ${BG_RED}${WHITE}${BLINK} 🚨 CRITICAL ${NC} $1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] CRITICAL: $1" >> "$OUTPUT_DIR/recon.log"
}

# Section Headers
print_section() {
    echo ""
    echo -e "${BOLD}${BLUE}╔════════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${BLUE}║${NC} ${BOLD}${WHITE}$1${NC} ${BOLD}${BLUE}║${NC}"
    echo -e "${BOLD}${BLUE}╚════════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Subsection Headers
print_subsection() {
    echo ""
    echo -e "${BOLD}${CYAN}┌─────────────────────────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${BOLD}${CYAN}│${NC} ${BOLD}${YELLOW}🔍 $1${NC} ${BOLD}${CYAN}│${NC}"
    echo -e "${BOLD}${CYAN}└─────────────────────────────────────────────────────────────────────────────────┘${NC}"
}

# Spinner Animation
show_spinner() {
    local pid=$1
    local message=$2
    local spin='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    local i=0
    
    while kill -0 $pid 2>/dev/null; do
        printf "\r${BOLD}${CYAN}[SCANNING]${NC} ${spin:$i:1} $message"
        i=$(( (i+1) % 10 ))
        sleep 0.1
    done
    printf "\r${BOLD}${GREEN}[COMPLETE]${NC} ✅ $message\n"
}

# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                            SYSTEM FUNCTIONS                                  ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

# Enhanced Dependency Checker
check_dependencies() {
    print_section "🔧 DEPENDENCY VERIFICATION"
    
    local deps=("nmap" "dig" "curl" "whois" "host" "ping" "nc" "subfinder" "amass" "gobuster" "nikto" "whatweb" "masscan")
    local missing_deps=()
    local installed_count=0
    
    log_info "Checking system dependencies..."
    echo ""
    
    printf "${BOLD}${BLUE}%-20s %-10s %-15s${NC}\n" "TOOL" "STATUS" "VERSION"
    printf "${BLUE}%-50s${NC}\n" "────────────────────────────────────────────────────"
    
    for dep in "${deps[@]}"; do
        printf "%-20s " "$dep"
        if command -v "$dep" &> /dev/null; then
            printf "${GREEN}✅ FOUND${NC}    "
            # Try to get version
            local version=""
            case $dep in
                "nmap")     version=$(nmap --version 2>/dev/null | head -1 | cut -d' ' -f3) ;;
                "curl")     version=$(curl --version 2>/dev/null | head -1 | cut -d' ' -f2) ;;
                "subfinder") version=$(subfinder -version 2>/dev/null | cut -d' ' -f3) ;;
                *)          version="installed" ;;
            esac
            printf "${DIM}${GRAY}%s${NC}\n" "$version"
            installed_count=$((installed_count + 1))
        else
            printf "${RED}❌ MISSING${NC}  ${DIM}not found${NC}\n"
            missing_deps+=("$dep")
        fi
    done
    
    echo ""
    printf "${BOLD}${WHITE}SUMMARY: ${NC}"
    printf "${GREEN}%d installed${NC} / " "$installed_count"
    printf "${RED}%d missing${NC} / " "${#missing_deps[@]}"
    printf "${BLUE}%d total${NC}\n" "${#deps[@]}"
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        echo ""
        log_warning "Missing dependencies detected: ${missing_deps[*]}"
        echo -e "${YELLOW}┌─ INSTALLATION COMMANDS ─────────────────────────────────────────────────┐${NC}"
        echo -e "${YELLOW}│${NC} ${BOLD}System packages:${NC} sudo apt update && sudo apt install -y nmap dnsutils curl whois netcat-openbsd masscan nikto whatweb"
        echo -e "${YELLOW}│${NC} ${BOLD}Go-based tools:${NC}"
        echo -e "${YELLOW}│${NC}   go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest"
        echo -e "${YELLOW}│${NC}   go install -v github.com/owasp-amass/amass/v4/...@master"
        echo -e "${YELLOW}│${NC}   go install github.com/OJ/gobuster/v3@latest"
        echo -e "${YELLOW}└──────────────────────────────────────────────────────────────────────────┘${NC}"
        echo ""
        
        printf "${BOLD}${YELLOW}Continue without missing tools? [y/N]: ${NC}"
        read -r continue_choice
        if [[ ! $continue_choice =~ ^[Yy]$ ]]; then
            log_critical "Aborted by user due to missing dependencies"
            exit 1
        fi
    else
        log_success "All dependencies verified successfully!"
    fi
    
    sleep 1
}

# Enhanced Target Validation
validate_target() {
    print_subsection "🎯 TARGET VALIDATION"
    
    log_info "Validating target: $TARGET"
    
    # IP Address Pattern
    if [[ $TARGET =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        log_success "Target identified as IPv4 address: $TARGET"
        return 0
    # Domain Pattern
    elif [[ $TARGET =~ ^[a-zA-Z0-9][a-zA-Z0-9-]{1,61}[a-zA-Z0-9]\.[a-zA-Z]{2,}$ ]] || [[ $TARGET =~ ^[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$ ]]; then
        log_success "Target identified as domain name: $TARGET"
        
        # Additional DNS resolution check
        log_info "Performing DNS resolution check..."
        if host "$TARGET" >/dev/null 2>&1; then
            local ip_address=$(dig +short "$TARGET" A | head -1)
            log_success "DNS resolution successful: $TARGET → $ip_address"
        else
            log_warning "DNS resolution failed, but continuing with scan"
        fi
        return 0
    else
        log_error "Invalid target format. Expected: IP address (192.168.1.1) or domain (example.com)"
        return 1
    fi
}

# Enhanced Output Setup
setup_output() {
    print_subsection "📁 OUTPUT DIRECTORY SETUP"
    
    OUTPUT_DIR="recon_${TARGET}_${TIMESTAMP}"
    
    log_info "Creating output directory structure..."
    
    # Create main directory
    mkdir -p "$OUTPUT_DIR"
    
    # Create subdirectories with enhanced structure
    local directories=(
        "nmap/tcp"
        "nmap/udp"
        "nmap/scripts"
        "dns/records"
        "dns/zone_transfers"
        "web/headers"
        "web/directories"
        "web/technologies"
        "subdomains/sources"
        "vulnerabilities/web"
        "vulnerabilities/network"
        "ssl/certificates"
        "ssl/configuration"
        "intelligence/whois"
        "intelligence/contacts"
        "reports/executive"
        "reports/technical"
        "logs"
    )
    
    for dir in "${directories[@]}"; do
        mkdir -p "$OUTPUT_DIR/$dir"
        printf "${DIM}${GRAY}  └── Created: $dir${NC}\n"
    done
    
    log_success "Output directory created: $OUTPUT_DIR"
    echo -e "${BOLD}${BLUE}📂 Results Location:${NC} ${UNDERLINE}$(pwd)/$OUTPUT_DIR${NC}"
    sleep 1
}

# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                           RECONNAISSANCE MODULES                             ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

# Enhanced Host Discovery
host_discovery() {
    print_section "🏠 HOST DISCOVERY & INITIAL RECONNAISSANCE"
    CURRENT_STEP=$((CURRENT_STEP + 1))
    show_progress $CURRENT_STEP $TOTAL_STEPS
    
    log_info "Initiating host discovery protocol for $TARGET"
    
    # ICMP Connectivity Test
    print_subsection "🏓 ICMP CONNECTIVITY TEST"
    echo -e "${CYAN}Testing network connectivity and latency...${NC}"
    
    if ping -c 3 -W 3 "$TARGET" > "$OUTPUT_DIR/logs/ping_test.txt" 2>&1; then
        local avg_time=$(grep "rtt" "$OUTPUT_DIR/logs/ping_test.txt" | cut -d'=' -f2 | cut -d'/' -f2)
        log_success "Host is alive and responding (Average: ${avg_time}ms)"
        
        # Display ping statistics
        echo -e "${BOLD}${WHITE}📊 Ping Statistics:${NC}"
        grep "bytes from\|rtt" "$OUTPUT_DIR/logs/ping_test.txt" | while read -r line; do
            echo -e "${DIM}${GRAY}  │ $line${NC}"
        done
    else
        log_warning "ICMP ping failed - host may be blocking ICMP or offline"
        echo -e "${YELLOW}  └── Continuing with TCP-based connectivity tests...${NC}"
    fi
    
    # DNS Resolution
    print_subsection "🌐 DNS RESOLUTION ANALYSIS"
    echo -e "${CYAN}Performing comprehensive DNS resolution...${NC}"
    
    if command -v host &> /dev/null; then
        host "$TARGET" > "$OUTPUT_DIR/dns/basic_resolution.txt" 2>&1
        
        if grep -q "has address" "$OUTPUT_DIR/dns/basic_resolution.txt"; then
            log_success "DNS resolution successful"
            echo -e "${BOLD}${WHITE}🔍 DNS Records Found:${NC}"
            grep -E "(has address|mail is handled)" "$OUTPUT_DIR/dns/basic_resolution.txt" | while read -r line; do
                echo -e "${DIM}${GRAY}  │ $line${NC}"
            done
        else
            log_warning "DNS resolution may have issues"
        fi
    fi
    
    # Port Connectivity Test
    print_subsection "🚪 BASIC PORT CONNECTIVITY"
    echo -e "${CYAN}Testing common ports for connectivity...${NC}"
    
    local common_ports=(22 80 443 21 25 53 110 993 995)
    local open_ports=()
    
    for port in "${common_ports[@]}"; do
        if timeout 2 bash -c "</dev/tcp/$TARGET/$port" 2>/dev/null; then
            open_ports+=("$port")
            echo -e "${GREEN}  ✅ Port $port/tcp - OPEN${NC}"
        else
            echo -e "${DIM}${GRAY}  ❌ Port $port/tcp - CLOSED${NC}"
        fi
    done
    
    if [ ${#open_ports[@]} -gt 0 ]; then
        log_success "Found ${#open_ports[@]} open ports: ${open_ports[*]}"
    else
        log_warning "No common ports found open via TCP connect"
    fi
    
    echo ""
}

# Enhanced DNS Enumeration
dns_enumeration() {
    print_section "🌐 COMPREHENSIVE DNS ENUMERATION"
    CURRENT_STEP=$((CURRENT_STEP + 1))
    show_progress $CURRENT_STEP $TOTAL_STEPS
    
    log_info "Initiating comprehensive DNS intelligence gathering"
    
    # DNS Record Types Analysis
    print_subsection "📋 DNS RECORD ANALYSIS"
    
    local record_types=("A" "AAAA" "MX" "NS" "TXT" "SOA" "CNAME" "PTR")
    local records_found=0
    
    echo -e "${BOLD}${WHITE}📊 DNS Record Discovery:${NC}"
    printf "${BOLD}${BLUE}%-8s %-20s %-40s${NC}\n" "TYPE" "COUNT" "SAMPLE RECORD"
    printf "${BLUE}%-70s${NC}\n" "──────────────────────────────────────────────────────────────────────"
    
    for record in "${record_types[@]}"; do
        local output_file="$OUTPUT_DIR/dns/records/dns_${record,,}.txt"
        local count=0
        
        if command -v dig &> /dev/null; then
            dig +short "$TARGET" "$record" > "$output_file" 2>/dev/null
            count=$(wc -l < "$output_file" 2>/dev/null || echo 0)
            
            if [ "$count" -gt 0 ]; then
                records_found=$((records_found + 1))
                local sample=$(head -1 "$output_file" | cut -c1-35)
                printf "${GREEN}%-8s${NC} %-20s %-40s\n" "$record" "${count} records" "$sample"
            else
                printf "${DIM}${GRAY}%-8s${NC} ${DIM}%-20s %-40s${NC}\n" "$record" "0 records" "-"
            fi
        fi
    done
    
    echo ""
    log_success "DNS enumeration complete - $records_found record types found"
    
    # Zone Transfer Attempts
    print_subsection "🔄 DNS ZONE TRANSFER TESTING"
    echo -e "${CYAN}Attempting zone transfers against discovered nameservers...${NC}"
    
    if [ -f "$OUTPUT_DIR/dns/records/dns_ns.txt" ] && [ -s "$OUTPUT_DIR/dns/records/dns_ns.txt" ]; then
        local nameservers=$(cat "$OUTPUT_DIR/dns/records/dns_ns.txt")
        local transfer_count=0
        
        for ns in $nameservers; do
            echo -e "${YELLOW}  🔍 Testing: $ns${NC}"
            local transfer_file="$OUTPUT_DIR/dns/zone_transfers/zone_transfer_${ns}.txt"
            
            if dig @"$ns" "$TARGET" AXFR > "$transfer_file" 2>&1; then
                if grep -q "Transfer failed\|connection timed out\|REFUSED" "$transfer_file"; then
                    echo -e "${RED}    ❌ Transfer denied (secure)${NC}"
                else
                    transfer_count=$((transfer_count + 1))
                    echo -e "${GREEN}    ✅ Transfer successful!${NC}"
                    log_critical "Zone transfer successful from $ns - potential security issue!"
                fi
            else
                echo -e "${RED}    ❌ Transfer failed${NC}"
            fi
        done
        
        if [ $transfer_count -eq 0 ]; then
            log_success "All nameservers properly configured (zone transfers denied)"
        fi
    else
        log_warning "No nameservers found for zone transfer testing"
    fi
    
    # Reverse DNS
    if [[ $TARGET =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        print_subsection "🔄 REVERSE DNS LOOKUP"
        echo -e "${CYAN}Performing reverse DNS resolution...${NC}"
        
        if command -v dig &> /dev/null; then
            local reverse_result=$(dig +short -x "$TARGET")
            if [ -n "$reverse_result" ]; then
                echo "$reverse_result" > "$OUTPUT_DIR/dns/reverse_dns.txt"
                log_success "Reverse DNS: $TARGET → $reverse_result"
            else
                log_info "No reverse DNS record found"
            fi
        fi
    fi
    
    echo ""
}

# Enhanced Subdomain Enumeration
subdomain_enumeration() {
    print_section "🔍 ADVANCED SUBDOMAIN DISCOVERY"
    CURRENT_STEP=$((CURRENT_STEP + 1))
    show_progress $CURRENT_STEP $TOTAL_STEPS
    
    log_info "Launching multi-source subdomain enumeration"
    
    local total_subdomains=0
    
    # Subfinder Enumeration
    if command -v subfinder &> /dev/null; then
        print_subsection "🚀 SUBFINDER - PASSIVE DISCOVERY"
        echo -e "${CYAN}Running high-speed passive subdomain discovery...${NC}"
        
        printf "${YELLOW}  ⚡ Scanning"
        subfinder -d "$TARGET" -o "$OUTPUT_DIR/subdomains/sources/subfinder.txt" -silent 2>/dev/null &
        local pid=$!
        
        while kill -0 $pid 2>/dev/null; do
            printf "."
            sleep 0.5
        done
        wait $pid
        printf " ${GREEN}✓${NC}\n"
        
        if [[ -s "$OUTPUT_DIR/subdomains/sources/subfinder.txt" ]]; then
            local count=$(wc -l < "$OUTPUT_DIR/subdomains/sources/subfinder.txt")
            log_success "Subfinder discovered $count subdomains"
            total_subdomains=$((total_subdomains + count))
            
            # Show top discoveries
            echo -e "${BOLD}${WHITE}🎯 Top Discoveries:${NC}"
            head -5 "$OUTPUT_DIR/subdomains/sources/subfinder.txt" | while read -r subdomain; do
                echo -e "${DIM}${GRAY}  │ $subdomain${NC}"
            done
        else
            log_warning "Subfinder found no subdomains"
        fi
    else
        log_warning "Subfinder not available - skipping passive discovery"
    fi
    
    # Amass Enumeration
    if command -v amass &> /dev/null; then
        print_subsection "🧠 AMASS - INTELLIGENCE GATHERING"
        echo -e "${CYAN}Running comprehensive intelligence-based enumeration...${NC}"
        
        printf "${YELLOW}  🧠 Analyzing"
        timeout 300 amass enum -d "$TARGET" -o "$OUTPUT_DIR/subdomains/sources/amass.txt" 2>/dev/null &
        local pid=$!
        
        while kill -0 $pid 2>/dev/null; do
            printf "."
            sleep 1
        done
        wait $pid
        printf " ${GREEN}✓${NC}\n"
        
        if [[ -s "$OUTPUT_DIR/subdomains/sources/amass.txt" ]]; then
            local count=$(wc -l < "$OUTPUT_DIR/subdomains/sources/amass.txt")
            log_success "Amass discovered $count subdomains"
            total_subdomains=$((total_subdomains + count))
        else
            log_info "Amass completed with no additional subdomains"
        fi
    else
        log_warning "Amass not available - skipping intelligence gathering"
    fi
    
    # DNS Brute Force
    print_subsection "💪 DNS BRUTE FORCE ATTACK"
    echo -e "${CYAN}Performing targeted DNS brute force...${NC}"
    
    local common_subs=("www" "mail" "ftp" "admin" "test" "dev" "staging" "api" "app" "portal" "blog" "shop" "secure" "vpn" "remote" "backup" "db" "database" "cloud" "cdn")
    local found_count=0
    
    echo -e "${YELLOW}  💪 Testing common subdomains${NC}"
    printf "     Progress: "
    
    for i in "${!common_subs[@]}"; do
        local sub="${common_subs[$i]}"
        if host "${sub}.${TARGET}" > /dev/null 2>&1; then
            echo "${sub}.${TARGET}" >> "$OUTPUT_DIR/subdomains/sources/bruteforce.txt"
            found_count=$((found_count + 1))
            printf "${GREEN}✓${NC}"
        else
            printf "${DIM}·${NC}"
        fi
        
        # Progress indicator
        if (( (i + 1) % 5 == 0 )); then
            printf " "
        fi
    done
    
    echo ""
    if [ $found_count -gt 0 ]; then
        log_success "DNS brute force found $found_count subdomains"
        total_subdomains=$((total_subdomains + found_count))
    else
        log_info "DNS brute force found no additional subdomains"
    fi
    
    # Combine and Deduplicate Results
    print_subsection "📊 RESULTS AGGREGATION"
    echo -e "${CYAN}Combining and deduplicating all discoveries...${NC}"
    
    if ls "$OUTPUT_DIR/subdomains/sources/"*.txt >/dev/null 2>&1; then
        cat "$OUTPUT_DIR/subdomains/sources/"*.txt 2>/dev/null | sort -u > "$OUTPUT_DIR/subdomains/all_subdomains.txt"
        local unique_count=$(wc -l < "$OUTPUT_DIR/subdomains/all_subdomains.txt")
        
        log_success "Total unique subdomains discovered: $unique_count"
        
        # Create summary
        echo -e "${BOLD}${WHITE}📈 Discovery Summary:${NC}"
        echo -e "${GREEN}  ├── Total Found: $unique_count subdomains${NC}"
        echo -e "${BLUE}  ├── Sources Used: $(ls "$OUTPUT_DIR/subdomains/sources/"*.txt 2>/dev/null | wc -l)${NC}"
        echo -e "${PURPLE}  └── Saved to: all_subdomains.txt${NC}"
        
        # Show sample of findings
        if [ $unique_count -gt 0 ]; then
            echo -e "${BOLD}${WHITE}🎯 Sample Discoveries:${NC}"
            head -10 "$OUTPUT_DIR/subdomains/all_subdomains.txt" | while read -r subdomain; do
                echo -e "${DIM}${GRAY}  │ $subdomain${NC}"
            done
            
            if [ $unique_count -gt 10 ]; then
                echo -e "${DIM}${GRAY}  │ ... and $((unique_count - 10)) more${NC}"
            fi
        fi
    else
        log_warning "No subdomain results to combine"
    fi
    
    echo ""
}

# Enhanced Port Scanning
port_scanning() {
    print_section "🚪 ADVANCED PORT SCANNING & SERVICE DETECTION"
    CURRENT_STEP=$((CURRENT_STEP + 1))
    show_progress $CURRENT_STEP $TOTAL_STEPS
    
    log_info "Initiating comprehensive port scanning suite"
    
    # Quick Discovery Scan
    print_subsection "⚡ RAPID PORT DISCOVERY"
    echo -e "${CYAN}Performing high-speed port discovery scan...${NC}"
    
    if command -v nmap &> /dev/null; then
        printf "${YELLOW}  ⚡ Scanning top 1000 ports"
        nmap -T4 -F --open "$TARGET" -oN "$OUTPUT_DIR/nmap/tcp/quick_scan.txt" -oX "$OUTPUT_DIR/nmap/tcp/quick_scan.xml" 2>/dev/null &
        local pid=$!
        
        while kill -0 $pid 2>/dev/null; do
            printf "."
            sleep 1
        done
        wait $pid
        printf " ${GREEN}✓${NC}\n"
        
        # Extract and display open ports
        if grep -q "^[0-9].*open" "$OUTPUT_DIR/nmap/tcp/quick_scan.txt"; then
            local open_ports=$(grep "^[0-9]" "$OUTPUT_DIR/nmap/tcp/quick_scan.txt" | grep "open" | cut -d'/' -f1 | tr '\n' ',' | sed 's/,$//')
            local port_count=$(echo "$open_ports" | tr ',' '\n' | wc -l)
            
            log_success "Quick scan discovered $port_count open ports"
            
            echo -e "${BOLD}${WHITE}🎯 Open Ports Found:${NC}"
            grep "^[0-9].*open" "$OUTPUT_DIR/nmap/tcp/quick_scan.txt" | while read -r line; do
                local port=$(echo "$line" | cut -d'/' -f1)
                local service=$(echo "$line" | awk '{print $3}')
                echo -e "${GREEN}  ├── Port $port/tcp${NC} ${DIM}${GRAY}($service)${NC}"
            done
            
            # Detailed Service Detection
            if [[ -n $open_ports ]]; then
                print_subsection "🔍 DETAILED SERVICE DETECTION"
                echo -e "${CYAN}Performing deep service analysis on open ports...${NC}"
                
                printf "${YELLOW}  🔍 Analyzing services"
                nmap -T4 -sV -sC -p "$open_ports" "$TARGET" -oN "$OUTPUT_DIR/nmap/tcp/detailed_scan.txt" -oX "$OUTPUT_DIR/nmap/tcp/detailed_scan.xml" 2>/dev/null &
                local pid=$!
                
                while kill -0 $pid 2>/dev/null; do
                    printf "."
                    sleep 2
                done
                wait $pid
                printf " ${GREEN}✓${NC}\n"
                
                log_success "Service detection completed"
                
                # Display service information
                echo -e "${BOLD}${WHITE}🛠️  Detected Services:${NC}"
                grep -E "^[0-9]+/tcp.*open" "$OUTPUT_DIR/nmap/tcp/detailed_scan.txt" | while read -r line; do
                    echo -e "${BLUE}  │ $line${NC}"
                done
                
                # Vulnerability Scanning
                print_subsection "🛡️ VULNERABILITY ASSESSMENT"
                echo -e "${CYAN}Running security vulnerability checks...${NC}"
                
                printf "${YELLOW}  🛡️  Scanning for vulnerabilities"
                nmap -T4 --script vuln -p "$open_ports" "$TARGET" -oN "$OUTPUT_DIR/vulnerabilities/network/vuln_scan.txt" 2>/dev/null &
                local pid=$!
                
                while kill -0 $pid 2>/dev/null; do
                    printf "."
                    sleep 2
                done
                wait $pid
                printf " ${GREEN}✓${NC}\n"
                
                # Check for vulnerabilities
                if grep -q "VULNERABLE\|CVE-" "$OUTPUT_DIR/vulnerabilities/network/vuln_scan.txt"; then
                    local vuln_count=$(grep -c "VULNERABLE\|CVE-" "$OUTPUT_DIR/vulnerabilities/network/vuln_scan.txt")
                    log_critical "Found $vuln_count potential vulnerabilities!"
                    
                    echo -e "${BOLD}${RED}⚠️  Security Issues Detected:${NC}"
                    grep -E "VULNERABLE|CVE-" "$OUTPUT_DIR/vulnerabilities/network/vuln_scan.txt" | head -5 | while read -r line; do
                        echo -e "${RED}  │ $line${NC}"
                    done
                else
                    log_success "No obvious vulnerabilities detected"
                fi
            fi
        else
            log_warning "No open ports found in quick scan"
        fi
        
        # UDP Scan (if privileged)
        print_subsection "📡 UDP SERVICE DISCOVERY"
        echo -e "${CYAN}Scanning common UDP services...${NC}"
        
        printf "${YELLOW}  📡 UDP scan (requires privileges)"
        if sudo -n true 2>/dev/null; then
            sudo nmap -sU --top-ports 20 "$TARGET" -oN "$OUTPUT_DIR/nmap/udp/udp_scan.txt" 2>/dev/null &
            local pid=$!
            
            while kill -0 $pid 2>/dev/null; do
                printf "."
                sleep 1
            done
            wait $pid
            printf " ${GREEN}✓${NC}\n"
            
            if grep -q "open" "$OUTPUT_DIR/nmap/udp/udp_scan.txt"; then
                log_success "UDP services discovered"
            else
                log_info "No open UDP ports found"
            fi
        else
            printf " ${YELLOW}⚠${NC}\n"
            log_warning "UDP scan requires root privileges - skipped"
        fi
        
    else
        log_error "nmap not available - cannot perform port scanning"
    fi
    
    # Masscan (if available and privileged)
    if command -v masscan &> /dev/null && sudo -n true 2>/dev/null; then
        print_subsection "🚀 HIGH-SPEED PORT SCAN"
        echo -e "${CYAN}Running masscan for comprehensive port discovery...${NC}"
        
        printf "${YELLOW}  🚀 Masscan full range"
        sudo masscan -p1-65535 "$TARGET" --rate=1000 --output-format list --output-filename "$OUTPUT_DIR/nmap/tcp/masscan.txt" 2>/dev/null &
        local pid=$!
        
        timeout 120 bash -c "while kill -0 $pid 2>/dev/null; do printf '.'; sleep 1; done"
        printf " ${GREEN}✓${NC}\n"
        
        if [[ -s "$OUTPUT_DIR/nmap/tcp/masscan.txt" ]]; then
            local masscan_count=$(wc -l < "$OUTPUT_DIR/nmap/tcp/masscan.txt")
            log_success "Masscan discovered $masscan_count total ports"
        else
            log_info "Masscan completed - results in masscan.txt"
        fi
    fi
    
    echo ""
}

# Enhanced Service Enumeration
service_enumeration() {
    print_section "🌐 WEB SERVICE ENUMERATION & ANALYSIS"
    CURRENT_STEP=$((CURRENT_STEP + 1))
    show_progress $CURRENT_STEP $TOTAL_STEPS
    
    log_info "Analyzing web services and applications"
    
    # Extract HTTP/HTTPS ports
    local http_ports=()
    if [[ -f "$OUTPUT_DIR/nmap/tcp/detailed_scan.txt" ]]; then
        while IFS= read -r line; do
            if [[ $line =~ ^([0-9]+)/tcp.*open.*http ]]; then
                port=$(echo "$line" | cut -d'/' -f1)
                http_ports+=("$port")
            fi
        done < "$OUTPUT_DIR/nmap/tcp/detailed_scan.txt"
    fi
    
    # Add common HTTP ports if not found
    for common_port in 80 8080 443 8443; do
        if ! printf '%s\n' "${http_ports[@]}" | grep -q "^$common_port$"; then
            if timeout 3 bash -c "</dev/tcp/$TARGET/$common_port" 2>/dev/null; then
                http_ports+=("$common_port")
            fi
        fi
    done
    
    if [ ${#http_ports[@]} -eq 0 ]; then
        log_warning "No HTTP services detected"
        return
    fi
    
    log_success "Found ${#http_ports[@]} HTTP services on ports: ${http_ports[*]}"
    
    # Analyze each HTTP service
    for port in "${http_ports[@]}"; do
        print_subsection "🌐 WEB SERVICE ANALYSIS - PORT $port"
        
        # Determine protocol
        local protocol="http"
        if [[ $port == "443" ]] || [[ $port == "8443" ]]; then
            protocol="https"
        fi
        
        local url="${protocol}://${TARGET}:${port}"
        echo -e "${CYAN}Analyzing: $url${NC}"
        
        # HTTP Headers Analysis
        echo -e "${YELLOW}  📋 Analyzing HTTP headers...${NC}"
        if command -v curl &> /dev/null; then
            local headers_file="$OUTPUT_DIR/web/headers/headers_${port}.txt"
            curl -I -s --connect-timeout 10 "$url" > "$headers_file" 2>/dev/null
            
            if [[ -s "$headers_file" ]]; then
                echo -e "${GREEN}    ✅ Headers captured${NC}"
                
                # Extract key information
                local server=$(grep -i "^server:" "$headers_file" | cut -d' ' -f2- | tr -d '[:cntrl:]')
                local powered_by=$(grep -i "^x-powered-by:" "$headers_file" | cut -d' ' -f2- | tr -d '[:cntrl:]')
                
                if [[ -n $server ]]; then
                    echo -e "${BLUE}    │ Server: $server${NC}"
                fi
                if [[ -n $powered_by ]]; then
                    echo -e "${BLUE}    │ Powered by: $powered_by${NC}"
                fi
            else
                echo -e "${RED}    ❌ Failed to retrieve headers${NC}"
            fi
        fi
        
        # Technology Detection
        if command -v whatweb &> /dev/null; then
            echo -e "${YELLOW}  🔍 Technology detection...${NC}"
            local tech_file="$OUTPUT_DIR/web/technologies/whatweb_${port}.txt"
            whatweb "$url" --log-brief="$tech_file" 2>/dev/null
            
            if [[ -s "$tech_file" ]]; then
                echo -e "${GREEN}    ✅ Technologies identified${NC}"
                echo -e "${BLUE}    │ $(cat "$tech_file")${NC}"
            else
                echo -e "${RED}    ❌ Technology detection failed${NC}"
            fi
        fi
        
        # Directory Enumeration
        if command -v gobuster &> /dev/null; then
            echo -e "${YELLOW}  📁 Directory enumeration...${NC}"
            
            # Create basic wordlist if needed
            local wordlist="/usr/share/wordlists/dirb/common.txt"
            if [[ ! -f "$wordlist" ]]; then
                wordlist="$OUTPUT_DIR/web/basic_wordlist.txt"
                echo -e "admin\ntest\nbackup\nconfig\napi\nlogin\nadmin.php\nindex.php\ntest.php\nwp-admin\nwp-content\nupload\nimages\njs\ncss" > "$wordlist"
            fi
            
            local gobuster_file="$OUTPUT_DIR/web/directories/gobuster_${port}.txt"
            printf "${YELLOW}    📁 Scanning directories"
            gobuster dir -u "$url" -w "$wordlist" -o "$gobuster_file" -t 20 -q 2>/dev/null &
            local pid=$!
            
            # Show progress
            local count=0
            while kill -0 $pid 2>/dev/null && [ $count -lt 30 ]; do
                printf "."
                sleep 2
                count=$((count + 1))
            done
            
            if kill -0 $pid 2>/dev/null; then
                kill $pid 2>/dev/null
            fi
            wait $pid 2>/dev/null
            printf " ${GREEN}✓${NC}\n"
            
            if [[ -s "$gobuster_file" ]]; then
                local dir_count=$(wc -l < "$gobuster_file")
                echo -e "${GREEN}    ✅ Found $dir_count directories/files${NC}"
                
                # Show interesting findings
                if grep -q "200\|301\|302" "$gobuster_file"; then
                    echo -e "${BOLD}${WHITE}    🎯 Interesting Paths:${NC}"
                    grep "200\|301\|302" "$gobuster_file" | head -5 | while read -r line; do
                        echo -e "${DIM}${GRAY}      │ $line${NC}"
                    done
                fi
            else
                echo -e "${YELLOW}    ⚠️  No directories found${NC}"
            fi
        fi
        
        # Web Vulnerability Scanning
        if command -v nikto &> /dev/null; then
            echo -e "${YELLOW}  🛡️  Web vulnerability scan...${NC}"
            local nikto_file="$OUTPUT_DIR/vulnerabilities/web/nikto_${port}.txt"
            
            printf "${YELLOW}    🛡️  Running security checks"
            timeout 300 nikto -h "$url" -output "$nikto_file" -Format txt 2>/dev/null &
            local pid=$!
            
            while kill -0 $pid 2>/dev/null; do
                printf "."
                sleep 3
            done
            wait $pid
            printf " ${GREEN}✓${NC}\n"
            
            if [[ -s "$nikto_file" ]] && grep -q "0 item(s) reported" "$nikto_file"; then
                echo -e "${GREEN}    ✅ No obvious web vulnerabilities found${NC}"
            elif [[ -s "$nikto_file" ]]; then
                local vuln_count=$(grep -c "^\+" "$nikto_file" 2>/dev/null || echo "unknown")
                echo -e "${RED}    ⚠️  Web security issues detected ($vuln_count)${NC}"
            else
                echo -e "${YELLOW}    ⚠️  Vulnerability scan incomplete${NC}"
            fi
        fi
        
        echo ""
    done
}

# Enhanced SSL Analysis
ssl_analysis() {
    print_section "🔐 SSL/TLS SECURITY ANALYSIS"
    CURRENT_STEP=$((CURRENT_STEP + 1))
    show_progress $CURRENT_STEP $TOTAL_STEPS
    
    log_info "Analyzing SSL/TLS configuration and certificates"
    
    # Check for SSL services
    local ssl_ports=()
    
    # Common SSL ports
    for port in 443 993 995 465 587 636 989 990 992 993 995; do
        if timeout 3 bash -c "</dev/tcp/$TARGET/$port" 2>/dev/null; then
            ssl_ports+=("$port")
        fi
    done
    
    if [ ${#ssl_ports[@]} -eq 0 ]; then
        log_warning "No SSL/TLS services detected"
        return
    fi
    
    log_success "Found SSL/TLS services on ports: ${ssl_ports[*]}"
    
    for port in "${ssl_ports[@]}"; do
        print_subsection "🔐 SSL/TLS ANALYSIS - PORT $port"
        echo -e "${CYAN}Analyzing SSL configuration on port $port...${NC}"
        
        # Certificate Information
        echo -e "${YELLOW}  📜 Certificate analysis...${NC}"
        local cert_file="$OUTPUT_DIR/ssl/certificates/cert_${port}.txt"
        local cert_info_file="$OUTPUT_DIR/ssl/certificates/cert_info_${port}.txt"
        
        # Get certificate
        if echo | openssl s_client -connect "${TARGET}:${port}" -servername "$TARGET" 2>/dev/null | openssl x509 -noout -text > "$cert_file" 2>/dev/null; then
            echo -e "${GREEN}    ✅ Certificate retrieved${NC}"
            
            # Extract key information
            echo | openssl s_client -connect "${TARGET}:${port}" -servername "$TARGET" 2>/dev/null | openssl x509 -noout -subject -issuer -dates 2>/dev/null > "$cert_info_file"
            
            if [[ -s "$cert_info_file" ]]; then
                echo -e "${BOLD}${WHITE}    📋 Certificate Details:${NC}"
                while read -r line; do
                    echo -e "${BLUE}      │ $line${NC}"
                done < "$cert_info_file"
                
                # Check expiration
                local not_after=$(grep "notAfter" "$cert_info_file" | cut -d'=' -f2-)
                if [[ -n $not_after ]]; then
                    local exp_date=$(date -d "$not_after" +%s 2>/dev/null)
                    local current_date=$(date +%s)
                    local days_left=$(( (exp_date - current_date) / 86400 ))
                    
                    if [ $days_left -lt 30 ]; then
                        log_critical "Certificate expires in $days_left days!"
                    elif [ $days_left -lt 90 ]; then
                        log_warning "Certificate expires in $days_left days"
                    else
                        log_success "Certificate valid for $days_left days"
                    fi
                fi
            fi
        else
            echo -e "${RED}    ❌ Failed to retrieve certificate${NC}"
        fi
        
        # SSL Configuration Check
        echo -e "${YELLOW}  🔧 SSL configuration analysis...${NC}"
        local config_file="$OUTPUT_DIR/ssl/configuration/config_${port}.txt"
        
        # Check SSL protocols and ciphers
        {
            echo "=== SSL/TLS Protocol Support ==="
            echo "TLS 1.3: $(echo | openssl s_client -connect "${TARGET}:${port}" -tls1_3 2>&1 | grep -c "Protocol.*TLSv1.3")"
            echo "TLS 1.2: $(echo | openssl s_client -connect "${TARGET}:${port}" -tls1_2 2>&1 | grep -c "Protocol.*TLSv1.2")"
            echo "TLS 1.1: $(echo | openssl s_client -connect "${TARGET}:${port}" -tls1_1 2>&1 | grep -c "Protocol.*TLSv1.1")"
            echo "TLS 1.0: $(echo | openssl s_client -connect "${TARGET}:${port}" -tls1 2>&1 | grep -c "Protocol.*TLSv1")"
            echo ""
            echo "=== Cipher Information ==="
            echo | openssl s_client -connect "${TARGET}:${port}" 2>/dev/null | grep -E "(Protocol|Cipher|Server public key)"
        } > "$config_file" 2>/dev/null
        
        if [[ -s "$config_file" ]]; then
            echo -e "${GREEN}    ✅ Configuration analyzed${NC}"
            
            # Check for weak protocols
            if grep -q "TLS 1.0: 1\|TLS 1.1: 1" "$config_file"; then
                log_warning "Weak TLS protocols detected (TLS 1.0/1.1)"
            else
                log_success "Strong TLS protocols in use"
            fi
        else
            echo -e "${YELLOW}    ⚠️  Configuration analysis incomplete${NC}"
        fi
        
        echo ""
    done
}

# Enhanced WHOIS Lookup
whois_lookup() {
    print_section "📋 DOMAIN INTELLIGENCE GATHERING"
    CURRENT_STEP=$((CURRENT_STEP + 1))
    show_progress $CURRENT_STEP $TOTAL_STEPS
    
    log_info "Gathering domain registration and ownership intelligence"
    
    if command -v whois &> /dev/null; then
        print_subsection "🔍 WHOIS RECORD ANALYSIS"
        echo -e "${CYAN}Retrieving domain registration information...${NC}"
        
        local whois_file="$OUTPUT_DIR/intelligence/whois/whois_full.txt"
        local whois_summary="$OUTPUT_DIR/intelligence/whois/whois_summary.txt"
        
        printf "${YELLOW}  📋 Querying WHOIS database"
        whois "$TARGET" > "$whois_file" 2>&1 &
        local pid=$!
        
        while kill -0 $pid 2>/dev/null; do
            printf "."
            sleep 0.5
        done
        wait $pid
        printf " ${GREEN}✓${NC}\n"
        
        if [[ -s "$whois_file" ]]; then
            log_success "WHOIS information retrieved"
            
            # Extract key information
            {
                echo "=== DOMAIN REGISTRATION SUMMARY ==="
                grep -i "registrar:" "$whois_file" | head -1
                grep -i "creation date\|created:" "$whois_file" | head -1
                grep -i "registry expiry\|expir" "$whois_file" | head -1
                grep -i "updated date\|modified:" "$whois_file" | head -1
                echo ""
                echo "=== NAME SERVERS ==="
                grep -i "name server\|nserver:" "$whois_file" | head -5
                echo ""
                echo "=== REGISTRANT INFORMATION ==="
                grep -iE "registrant|admin|tech" "$whois_file" | grep -i "name:" | head -3
            } > "$whois_summary" 2>/dev/null
            
            if [[ -s "$whois_summary" ]]; then
                echo -e "${BOLD}${WHITE}📊 Key Information Extracted:${NC}"
                while read -r line; do
                    if [[ $line == "==="* ]]; then
                        echo -e "${BOLD}${BLUE}$line${NC}"
                    else
                        echo -e "${DIM}${GRAY}  │ $line${NC}"
                    fi
                done < "$whois_summary"
                
                # Check for privacy protection
                if grep -qi "privacy\|protected\|redacted" "$whois_file"; then
                    log_info "Domain uses privacy protection services"
                else
                    log_warning "Domain registration details may be publicly visible"
                fi
                
                # Check expiration
                if grep -qi "expir" "$whois_file"; then
                    echo -e "${YELLOW}  ⏰ Check expiration dates in full WHOIS output${NC}"
                fi
            else
                log_warning "Could not parse WHOIS information"
            fi
        else
            log_error "Failed to retrieve WHOIS information"
        fi
    else
        log_error "whois command not available"
    fi
    
    echo ""
}

# Enhanced Report Generation
generate_report() {
    print_section "📊 COMPREHENSIVE REPORT GENERATION"
    CURRENT_STEP=$((CURRENT_STEP + 1))
    show_progress $CURRENT_STEP $TOTAL_STEPS
    
    log_info "Generating comprehensive reconnaissance report"
    
    local exec_report="$OUTPUT_DIR/reports/executive/executive_summary.txt"
    local tech_report="$OUTPUT_DIR/reports/technical/detailed_findings.txt"
    local scan_start_time=$(stat -c %Y "$OUTPUT_DIR" 2>/dev/null || date +%s)
    local scan_duration=$(date -u -d@$(($(date +%s) - scan_start_time)) +%H:%M:%S)
    
    # Executive Summary
    print_subsection "📋 EXECUTIVE SUMMARY"
    
    cat > "$exec_report" << EOF
╔══════════════════════════════════════════════════════════════════════════════╗
║                           EXECUTIVE SUMMARY                                  ║
║                    Advanced Reconnaissance Report                            ║
╚══════════════════════════════════════════════════════════════════════════════╝

TARGET INFORMATION:
═══════════════════
🎯 Target: $TARGET
📅 Scan Date: $(date '+%Y-%m-%d %H:%M:%S %Z')
⏱️ Duration: $scan_duration
🛠️ Tool: Advanced Reconnaissance Tool v2.0

EXECUTIVE FINDINGS:
═══════════════════
EOF
    
    # Count findings
    local open_ports_count=0
    local subdomains_count=0
    local vulnerabilities_count=0
    local web_services_count=0
    
    # Open ports
    if [[ -f "$OUTPUT_DIR/nmap/tcp/detailed_scan.txt" ]]; then
        open_ports_count=$(grep -c "^[0-9].*open" "$OUTPUT_DIR/nmap/tcp/detailed_scan.txt" 2>/dev/null || echo 0)
        echo "🚪 Open Ports: $open_ports_count discovered" >> "$exec_report"
        
        if [ $open_ports_count -gt 0 ]; then
            echo "   └── Services: $(grep "^[0-9].*open" "$OUTPUT_DIR/nmap/tcp/detailed_scan.txt" | awk '{print $3}' | sort -u | tr '\n' ', ' | sed 's/,$//')" >> "$exec_report"
        fi
    fi
    
    # Subdomains
    if [[ -f "$OUTPUT_DIR/subdomains/all_subdomains.txt" ]]; then
        subdomains_count=$(wc -l < "$OUTPUT_DIR/subdomains/all_subdomains.txt" 2>/dev/null || echo 0)
        echo "🔍 Subdomains: $subdomains_count discovered" >> "$exec_report"
    fi
    
    # Web services
    web_services_count=$(ls "$OUTPUT_DIR/web/headers/"*.txt 2>/dev/null | wc -l)
    if [ $web_services_count -gt 0 ]; then
        echo "🌐 Web Services: $web_services_count analyzed" >> "$exec_report"
    fi
    
    # Vulnerabilities
    if [[ -f "$OUTPUT_DIR/vulnerabilities/network/vuln_scan.txt" ]]; then
        vulnerabilities_count=$(grep -c "VULNERABLE\|CVE-" "$OUTPUT_DIR/vulnerabilities/network/vuln_scan.txt" 2>/dev/null || echo 0)
        if [ $vulnerabilities_count -gt 0 ]; then
            echo "⚠️  Vulnerabilities: $vulnerabilities_count potential issues identified" >> "$exec_report"
        else
            echo "✅ Vulnerabilities: No obvious network vulnerabilities detected" >> "$exec_report"
        fi
    fi
    
    # Risk Assessment
    cat >> "$exec_report" << EOF

RISK ASSESSMENT:
════════════════
EOF
    
    if [ $vulnerabilities_count -gt 5 ]; then
        echo "🔴 RISK LEVEL: HIGH - Multiple vulnerabilities detected" >> "$exec_report"
    elif [ $vulnerabilities_count -gt 0 ] || [ $open_ports_count -gt 10 ]; then
        echo "🟡 RISK LEVEL: MEDIUM - Some security concerns identified" >> "$exec_report"
    else
        echo "🟢 RISK LEVEL: LOW - Basic security posture appears adequate" >> "$exec_report"
    fi
    
    cat >> "$exec_report" << EOF

RECOMMENDATIONS:
════════════════
• Review all open ports and disable unnecessary services
• Analyze discovered subdomains for potential security risks
• Implement proper SSL/TLS configuration if web services present
• Consider network segmentation and access controls
• Regular security assessments and vulnerability management

DETAILED FINDINGS:
════════════════
📁 Technical Details: See technical_report.txt
📁 Raw Data: Check individual module directories
📁 Logs: Review recon.log for execution details

═══════════════════════════════════════════════════════════════════════════════
Report generated by Advanced Reconnaissance Tool v2.0
$(date '+%Y-%m-%d %H:%M:%S %Z')
═══════════════════════════════════════════════════════════════════════════════
EOF
    
    log_success "Executive summary generated: $exec_report"
    
    # Display Summary Statistics
    print_subsection "📈 SCAN STATISTICS"
    
    echo -e "${BOLD}${WHITE}📊 Final Reconnaissance Summary:${NC}"
    
    # Fixed-width table with consistent spacing
    local table_width=70
    local col1_width=20
    local col2_width=46
    
    # Top border
    echo -e "${BLUE}┌$(printf '%*s' $table_width '' | tr ' ' '─')┐${NC}"
    
    # Header
    printf "${BLUE}│${NC}${BOLD} %-*s ${BLUE}│${NC}${BOLD} %-*s ${BLUE}│${NC}\n" $col1_width "Metric" $col2_width "Result"
    
    # Separator
    echo -e "${BLUE}├$(printf '%*s' $table_width '' | tr ' ' '─')┤${NC}"
    
    # Data rows with consistent formatting
    printf "${BLUE}│${NC} Target               ${BLUE}│${NC} %-*s ${BLUE}│${NC}\n" $col2_width "$TARGET"
    printf "${BLUE}│${NC} Scan Duration        ${BLUE}│${NC} %-*s ${BLUE}│${NC}\n" $col2_width "$scan_duration"
    printf "${BLUE}│${NC} Open Ports           ${BLUE}│${NC} %-*s ${BLUE}│${NC}\n" $col2_width "$open_ports_count"
    printf "${BLUE}│${NC} Subdomains Found     ${BLUE}│${NC} %-*s ${BLUE}│${NC}\n" $col2_width "$subdomains_count"
    printf "${BLUE}│${NC} Web Services         ${BLUE}│${NC} %-*s ${BLUE}│${NC}\n" $col2_width "$web_services_count"
    printf "${BLUE}│${NC} Vulnerabilities      ${BLUE}│${NC} %-*s ${BLUE}│${NC}\n" $col2_width "$vulnerabilities_count"
    printf "${BLUE}│${NC} Output Directory     ${BLUE}│${NC} %-*s ${BLUE}│${NC}\n" $col2_width "$(basename "$OUTPUT_DIR")"
    
    # Bottom border
    echo -e "${BLUE}└$(printf '%*s' $table_width '' | tr ' ' '─')┘${NC}"
    
    echo ""
    log_success "Comprehensive reconnaissance completed successfully!"
    echo -e "${BOLD}${GREEN}📂 All results saved to: ${UNDERLINE}$(pwd)/$OUTPUT_DIR${NC}"
}

# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                              MENU SYSTEM                                    ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

# Post-scan completion prompt
scan_completion_prompt() {
    echo ""
    echo -e "${BOLD}${GREEN}╔══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${GREEN}║${NC}                       ${BOLD}${WHITE}🎉 SCAN COMPLETED SUCCESSFULLY!${NC}                      ${BOLD}${GREEN}║${NC}"
    echo -e "${BOLD}${GREEN}╚══════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${BOLD}${BLUE}📊 Quick Actions:${NC}"
    echo -e "${GREEN}  ✅ Results saved to: $(basename "$OUTPUT_DIR")${NC}"
    echo -e "${GREEN}  ✅ Executive report generated${NC}"
    echo -e "${GREEN}  ✅ Ready for next operation${NC}"
    echo ""
    
    echo -e "${BOLD}${CYAN}┌─ What would you like to do next? ─────────────────────────────────────────────┐${NC}"
    echo -e "${BOLD}${CYAN}│${NC}                                                                               ${BOLD}${CYAN}│${NC}"
    echo -e "${BOLD}${CYAN}│${NC}  ${BOLD}${GREEN}1)${NC} 🔄 Return to Main Menu     Run another scan on this target        ${BOLD}${CYAN}│${NC}"
    echo -e "${BOLD}${CYAN}│${NC}  ${BOLD}${BLUE}2)${NC} 🎯 Change Target           Scan a different target                ${BOLD}${CYAN}│${NC}"
    echo -e "${BOLD}${CYAN}│${NC}  ${BOLD}${YELLOW}3)${NC} 📁 Open Results Folder     View generated reports and data        ${BOLD}${CYAN}│${NC}"
    echo -e "${BOLD}${CYAN}│${NC}  ${BOLD}${GRAY}4)${NC} ❌ Exit Application        Quit the reconnaissance tool           ${BOLD}${CYAN}│${NC}"
    echo -e "${BOLD}${CYAN}│${NC}                                                                               ${BOLD}${CYAN}│${NC}"
    echo -e "${BOLD}${CYAN}└───────────────────────────────────────────────────────────────────────────────┘${NC}"
    echo ""
    
    while true; do
        printf "${BOLD}${WHITE}Select your choice [1-4]: ${NC}"
        read -r choice
        
        case $choice in
            1)
                log_info "Returning to main menu for target: $TARGET"
                show_menu
                break
                ;;
            2)
                log_info "Changing target - requesting new target input"
                get_new_target
                break
                ;;
            3)
                log_info "Opening results folder: $OUTPUT_DIR"
                echo -e "\n${BOLD}${BLUE}📂 Results Location:${NC}"
                echo -e "${GREEN}  └── $(pwd)/$OUTPUT_DIR${NC}"
                echo -e "\n${DIM}${GRAY}You can also run: ${BOLD}ls -la $OUTPUT_DIR${NC}"
                echo -e "${DIM}${GRAY}Or open file manager: ${BOLD}xdg-open $OUTPUT_DIR${NC}"
                if command -v xdg-open &> /dev/null; then
                    printf "\n${BOLD}${YELLOW}Open folder in file manager? [y/N]: ${NC}"
                    read -r open_choice
                    if [[ $open_choice =~ ^[Yy]$ ]]; then
                        xdg-open "$OUTPUT_DIR" 2>/dev/null &
                        log_success "Results folder opened in file manager"
                    fi
                fi
                scan_completion_prompt  # Show the prompt again
                break
                ;;
            4)
                echo -e "\n${BOLD}${GREEN}╔══════════════════════════════════════════════════════════════════════════════╗${NC}"
                echo -e "${BOLD}${GREEN}║${NC}              ${BOLD}${WHITE}Thank you for using Advanced Reconnaissance Tool!${NC}            ${BOLD}${GREEN}║${NC}"
                echo -e "${BOLD}${GREEN}╚══════════════════════════════════════════════════════════════════════════════╝${NC}"
                echo -e "${DIM}${GRAY}                    Stay ethical, stay legal! 🛡️${NC}"
                echo -e "${BOLD}${BLUE}                   Happy hacking responsibly! 🎯${NC}\n"
                log_info "Application terminated by user"
                exit 0
                ;;
            *)
                log_error "Invalid choice: $choice"
                echo -e "${RED}Please select a valid option (1-4)${NC}\n"
                ;;
        esac
    done
}

# Function to get new target
get_new_target() {
    echo ""
    echo -e "${BOLD}${BLUE}╔══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${BLUE}║${NC}                           ${BOLD}${WHITE}🎯 NEW TARGET SELECTION${NC}                           ${BOLD}${BLUE}║${NC}"
    echo -e "${BOLD}${BLUE}╚══════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    while true; do
        echo -e "${BOLD}${WHITE}🎯 Enter new target (IP address or domain name):${NC}"
        printf "${CYAN}New Target: ${NC}"
        read -r NEW_TARGET
        
        if [[ -n "$NEW_TARGET" ]]; then
            local OLD_TARGET="$TARGET"
            TARGET="$NEW_TARGET"
            
            # Validate new target
            if validate_target; then
                log_success "Target changed: $OLD_TARGET → $TARGET"
                
                # Setup new output directory
                setup_output
                
                # Show menu for new target
                show_menu
                break
            else
                log_error "Invalid target format. Please try again."
                TARGET="$OLD_TARGET"  # Restore old target
                echo ""
            fi
        else
            log_warning "No target entered. Please provide a valid target."
            echo ""
        fi
    done
}

# Enhanced Main Menu
show_menu() {
    echo ""
    echo -e "${BOLD}${BLUE}╔══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${BLUE}║${NC}                         ${BOLD}${WHITE}🎯 SCAN TYPE SELECTION${NC}                          ${BOLD}${BLUE}║${NC}"
    echo -e "${BOLD}${BLUE}╚══════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    echo -e "${BOLD}${CYAN}┌─ Available Scan Types ────────────────────────────────────────────────────────┐${NC}"
    echo -e "${BOLD}${CYAN}│${NC}                                                                               ${BOLD}${CYAN}│${NC}"
    echo -e "${BOLD}${CYAN}│${NC}  ${BOLD}${GREEN}1)${NC} ${BOLD}⚡ Quick Scan${NC}         ${DIM}${GRAY}(5-10 min)${NC}   Basic discovery & ports      ${BOLD}${CYAN}│${NC}"
    echo -e "${BOLD}${CYAN}│${NC}  ${BOLD}${YELLOW}2)${NC} ${BOLD}🔍 Standard Scan${NC}      ${DIM}${GRAY}(15-30 min)${NC}  DNS + Ports + Web analysis   ${BOLD}${CYAN}│${NC}"
    echo -e "${BOLD}${CYAN}│${NC}  ${BOLD}${RED}3)${NC} ${BOLD}🚀 Comprehensive Scan${NC} ${DIM}${GRAY}(45-90 min)${NC}  Complete reconnaissance       ${BOLD}${CYAN}│${NC}"
    echo -e "${BOLD}${CYAN}│${NC}  ${BOLD}${PURPLE}4)${NC} ${BOLD}⚙️  Custom Scan${NC}       ${DIM}${GRAY}(Variable)${NC}   Select specific modules       ${BOLD}${CYAN}│${NC}"
    echo -e "${BOLD}${CYAN}│${NC}  ${BOLD}${GRAY}5)${NC} ${BOLD}❌ Exit${NC}               ${DIM}${GRAY}          ${NC}   Quit the application         ${BOLD}${CYAN}│${NC}"
    echo -e "${BOLD}${CYAN}│${NC}                                                                               ${BOLD}${CYAN}│${NC}"
    echo -e "${BOLD}${CYAN}└───────────────────────────────────────────────────────────────────────────────┘${NC}"
    echo ""
    
    printf "${BOLD}${WHITE}Select your choice [1-5]: ${NC}"
    read -r choice
    
    case $choice in
        1) quick_scan ;;
        2) standard_scan ;;
        3) comprehensive_scan ;;
        4) custom_scan ;;
        5) 
            echo -e "\n${BOLD}${GREEN}Thank you for using Advanced Reconnaissance Tool!${NC}"
            echo -e "${DIM}${GRAY}Stay ethical, stay legal! 🛡️${NC}\n"
            exit 0 
            ;;
        *) 
            log_error "Invalid choice: $choice"
            show_menu 
            ;;
    esac
}

# Scan Type Functions
quick_scan() {
    TOTAL_STEPS=3
    CURRENT_STEP=0
    
    log_info "Initiating Quick Scan protocol"
    host_discovery
    port_scanning
    generate_report
    
    # Return to menu after completion
    scan_completion_prompt
}

standard_scan() {
    TOTAL_STEPS=6
    CURRENT_STEP=0
    
    log_info "Initiating Standard Scan protocol"
    host_discovery
    dns_enumeration
    port_scanning
    service_enumeration
    whois_lookup
    generate_report
    
    # Return to menu after completion
    scan_completion_prompt
}

comprehensive_scan() {
    TOTAL_STEPS=8
    CURRENT_STEP=0
    
    log_info "Initiating Comprehensive Scan protocol"
    host_discovery
    dns_enumeration
    subdomain_enumeration
    port_scanning
    service_enumeration
    ssl_analysis
    whois_lookup
    generate_report
    
    # Return to menu after completion
    scan_completion_prompt
}

custom_scan() {
    echo ""
    echo -e "${BOLD}${PURPLE}╔══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${PURPLE}║${NC}                        ${BOLD}${WHITE}⚙️  CUSTOM MODULE SELECTION${NC}                       ${BOLD}${PURPLE}║${NC}"
    echo -e "${BOLD}${PURPLE}╚══════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    echo -e "${BOLD}${PURPLE}┌─ Available Modules ───────────────────────────────────────────────────────────┐${NC}"
    echo -e "${BOLD}${PURPLE}│${NC}                                                                               ${BOLD}${PURPLE}│${NC}"
    echo -e "${BOLD}${PURPLE}│${NC}  ${BOLD}${GREEN}1)${NC} 🏠 Host Discovery          Basic connectivity and DNS resolution    ${BOLD}${PURPLE}│${NC}"
    echo -e "${BOLD}${PURPLE}│${NC}  ${BOLD}${BLUE}2)${NC} 🌐 DNS Enumeration         Comprehensive DNS record analysis       ${BOLD}${PURPLE}│${NC}"
    echo -e "${BOLD}${PURPLE}│${NC}  ${BOLD}${CYAN}3)${NC} 🔍 Subdomain Discovery     Multi-source subdomain enumeration      ${BOLD}${PURPLE}│${NC}"
    echo -e "${BOLD}${PURPLE}│${NC}  ${BOLD}${RED}4)${NC} 🚪 Port Scanning           Advanced port and service detection      ${BOLD}${PURPLE}│${NC}"
    echo -e "${BOLD}${PURPLE}│${NC}  ${BOLD}${YELLOW}5)${NC} 🌍 Web Service Analysis    HTTP/HTTPS application enumeration      ${BOLD}${PURPLE}│${NC}"
    echo -e "${BOLD}${PURPLE}│${NC}  ${BOLD}${GREEN}6)${NC} 🔐 SSL/TLS Analysis        Certificate and encryption assessment    ${BOLD}${PURPLE}│${NC}"
    echo -e "${BOLD}${PURPLE}│${NC}  ${BOLD}${BLUE}7)${NC} 📋 WHOIS Intelligence      Domain registration information         ${BOLD}${PURPLE}│${NC}"
    echo -e "${BOLD}${PURPLE}│${NC}                                                                               ${BOLD}${PURPLE}│${NC}"
    echo -e "${BOLD}${PURPLE}└───────────────────────────────────────────────────────────────────────────────┘${NC}"
    echo ""
    
    printf "${BOLD}${WHITE}Enter module numbers (e.g., 1,3,4 or 1-4): ${NC}"
    read -r modules
    
    # Parse module selection
    local selected_modules=()
    IFS=',' read -ra MODULE_ARRAY <<< "$modules"
    
    for module in "${MODULE_ARRAY[@]}"; do
        module=$(echo "$module" | tr -d ' ')  # Remove spaces
        
        # Handle ranges (e.g., 1-4)
        if [[ $module =~ ^([0-9]+)-([0-9]+)$ ]]; then
            local start=${BASH_REMATCH[1]}
            local end=${BASH_REMATCH[2]}
            for ((i=start; i<=end; i++)); do
                if [[ $i -ge 1 && $i -le 7 ]]; then
                    selected_modules+=("$i")
                fi
            done
        # Handle single numbers
        elif [[ $module =~ ^[0-9]+$ ]] && [[ $module -ge 1 && $module -le 7 ]]; then
            selected_modules+=("$module")
        fi
    done
    
    # Remove duplicates and sort
    selected_modules=($(printf '%s\n' "${selected_modules[@]}" | sort -nu))
    
    if [ ${#selected_modules[@]} -eq 0 ]; then
        log_error "No valid modules selected"
        custom_scan
        return
    fi
    
    TOTAL_STEPS=$((${#selected_modules[@]} + 1))  # +1 for report generation
    CURRENT_STEP=0
    
    log_info "Custom scan initiated with ${#selected_modules[@]} modules: ${selected_modules[*]}"
    
    # Execute selected modules
    for module in "${selected_modules[@]}"; do
        case $module in
            1) host_discovery ;;
            2) dns_enumeration ;;
            3) subdomain_enumeration ;;
            4) port_scanning ;;
            5) service_enumeration ;;
            6) ssl_analysis ;;
            7) whois_lookup ;;
        esac
    done
    
    generate_report
    
    # Return to menu after completion
    scan_completion_prompt
}

# ╔══════════════════════════════════════════════════════════════════════════════╗
# ║                            MAIN EXECUTION                                   ║
# ╚══════════════════════════════════════════════════════════════════════════════╝

main() {
    # Show banner
    show_banner
    
    # Get initial target
    if [[ -z "$1" ]]; then
        echo -e "${BOLD}${WHITE}🎯 Enter target (IP address or domain name):${NC}"
        printf "${CYAN}Target: ${NC}"
        read -r TARGET
    else
        TARGET="$1"
    fi
    
    # Validate target
    if ! validate_target; then
        log_critical "Invalid target specified - aborting scan"
        exit 1
    fi
    
    # Check dependencies
    check_dependencies
    
    # Setup output directory
    setup_output
    
    # Initialize logging
    log_info "Advanced Reconnaissance Tool v2.0 initialized"
    log_info "Target: $TARGET"
    log_info "Output directory: $OUTPUT_DIR"
    log_info "Scan initiated by: $(whoami) on $(hostname)"
    
    # Show scan menu or execute direct scan
    if [[ -z "$2" ]]; then
        show_menu
    else
        case "$2" in
            "quick") quick_scan ;;
            "standard") standard_scan ;;
            "comprehensive") comprehensive_scan ;;
            "custom") custom_scan ;;
            *) 
                log_warning "Unknown scan type: $2 - showing menu"
                show_menu 
                ;;
        esac
    fi
}

# Execute main function with all arguments
main "$@"

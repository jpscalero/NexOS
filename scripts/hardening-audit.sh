#!/bin/bash
# NexOS Shield - Security Hardening Auditing Tool
# This script audits the system against NexOS Professional Security Standards.

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}==============================================${NC}"
echo -e "${BLUE}    NexOS Shield - Hardening Audit v0.1       ${NC}"
echo -e "${BLUE}==============================================${NC}"

ERRORS=0

check_point() {
    local desc=$1
    local cmd=$2
    local expected=$3
    
    echo -n "[ ] $desc... "
    local result=$(eval "$cmd")
    
    if [[ "$result" == *"$expected"* ]]; then
        echo -e "${GREEN}PASS${NC}"
    else
        echo -e "${RED}FAIL${NC}"
        ERRORS=$((ERRORS + 1))
    fi
}

# 1. Kernel Hardening
echo -e "\n${YELLOW}--- Kernel Hardening ---${NC}"
check_point "ASLR enabled" "cat /proc/sys/kernel/randomize_va_space" "2"
check_point "IPv4 Forwarding disabled" "cat /proc/sys/net/ipv4/ip_forward" "0"
check_point "ICMP Redirects disabled" "cat /proc/sys/net/ipv4/conf/all/accept_redirects" "0"

# 2. Access Control
echo -e "\n${YELLOW}--- Access Control ---${NC}"
check_point "AppArmor active" "aa-status --enabled 2>/dev/null && echo -n 'active' || echo -n 'inactive'" "active"
check_point "Root login via SSH disabled" "grep '^PermitRootLogin' /etc/ssh/sshd_config 2>/dev/null || echo 'no'" "no"

# 3. User & System
echo -e "\n${YELLOW}--- User & System ---${NC}"
check_point "Sudo NOPASSWD check" "grep -r 'NOPASSWD' /etc/sudoers.d/ 2>/dev/null | wc -l" "0"

# 4. OS Branding Accuracy
echo -e "\n${YELLOW}--- Branding Integrity ---${NC}"
check_point "OS-Release contains NexOS" "grep 'NAME=\"NexOS\"' /etc/os-release" "NexOS"

echo -e "\n${BLUE}==============================================${NC}"
if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}SUCCESS: The system meets all professional standards.${NC}"
else
    echo -e "${RED}ALERT: $ERRORS security baseline issues found.${NC}"
fi
echo -e "${BLUE}==============================================${NC}"

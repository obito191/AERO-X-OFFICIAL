#!/data/data/com.termux/files/usr/bin/bash

# Color Codes
R='\033[1;31m'
G='\033[1;32m'
Y='\033[1;33m'
B='\033[1;34m'
M='\033[1;35m'
C='\033[1;36m'
W='\033[1;37m'
N='\033[0m'

clear
echo -e "${C}==================================================${N}"
echo -e "${Y}      AERO X OFFICIAL - ADVANCED SETUP            ${N}"
echo -e "${C}==================================================${N}"
echo ""

# 1. Get User Input
echo -ne "${G}[+] Enter Your Name: ${W}"
read USER_NAME

if [ -z "$USER_NAME" ]; then
    USER_NAME="USER"
fi

# 2. Install Required Packages
echo -e "\n${Y}[*] Installing required packages... Please wait...${N}"
pkg update -y > /dev/null 2>&1
pkg install figlet toilet ruby ncurses-utils coreutils procps -y > /dev/null 2>&1
gem install lolcat > /dev/null 2>&1

# 3. Remove Default Login Message
touch ~/.hushlogin
rm -rf $PREFIX/etc/motd

# 4. Create Banner and Custom Prompt Script
cat << 'EOF' > ~/.aerox_banner.sh
#!/data/data/com.termux/files/usr/bin/bash

clear

# AERO X OFFICIAL Main Banner
figlet -f standard "AERO X" | lolcat
echo "==================================================" | lolcat
echo "       ⚡ POWERED BY AERO X OFFICIAL ⚡           " | lolcat
echo "==================================================" | lolcat

# Display User Name
figlet -f small "WELCOME __USER_NAME__" | lolcat

# Advanced System Dashboard
UPTIME_INFO=$(uptime -p 2>/dev/null | sed 's/up //')
RAM_INFO=$(free -m 2>/dev/null | awk '/Mem:/ { printf("%dMB / %dMB", $3, $2) }')
DISK_INFO=$(df -h /data 2>/dev/null | awk 'NR==2 {print $3 " / " $2 " (" $5 ")"}')

echo -e "\033[1;36m╭────────────────────────────────────────────────╮\033[0m"
echo -e "\033[1;36m│\033[0m \033[1;33m👤 User    :\033[0m \033[1;32m__USER_NAME__\033[0m"
echo -e "\033[1;36m│\033[0m \033[1;33m🛡️ System  :\033[0m \033[1;35mAERO X OFFICIAL V1.0\033[0m"
echo -e "\033[1;36m│\033[0m \033[1;33m📅 Date    :\033[0m \033[1;37m$(date +"%d %b %Y | %I:%M %p")\033[0m"
echo -e "\033[1;36m│\033[0m \033[1;33m⏳ Uptime  :\033[0m \033[1;37m${UPTIME_INFO:-Active}\033[0m"
echo -e "\033[1;36m│\033[0m \033[1;33m🧠 Memory  :\033[0m \033[1;37m${RAM_INFO:-N/A}\033[0m"
echo -e "\033[1;36m│\033[0m \033[1;33m💾 Storage :\033[0m \033[1;37m${DISK_INFO:-N/A}\033[0m"
echo -e "\033[1;36m╰────────────────────────────────────────────────╯\033[0m"
echo ""

# Custom Error Handler (Bash & Zsh Compatible)
command_not_found_handle() {
    echo ""
    echo -e "          \033[1;31mAERO X Error...*\033[0m"
    echo -e "             \033[1;33m(>_<)\033[0m"
    echo -e "             \033[1;36m<)  )╯\033[0m"
    echo -e "             \033[1;34m /  \\\\\033[0m"
    echo ""
    if [ -x /data/data/com.termux/files/usr/libexec/termux/command-not-found ]; then
        /data/data/com.termux/files/usr/libexec/termux/command-not-found "$1"
    else
        echo -e "\033[1;31mNo command '$1' found!\033[0m"
    fi
    return 127
}

command_not_found_handler() {
    command_not_found_handle "$@"
    return 127
}

# Custom Prompt Setup (Supports both Bash and Zsh)
if [ -n "$ZSH_VERSION" ]; then
    PROMPT=$'\n%{\e[1;32m%}┌──[%{\e[1;37m%}AERO X%{\e[1;33m%}@%{\e[1;36m%}__USER_NAME__%{\e[1;32m%}]─[%{\e[1;31m%}%~%{\e[1;32m%}]\n├──[%{\e[1;35m%}⏰ %*%{\e[1;32m%}]\n└─%{\e[1;36m%}>>> %{\e[0m%}'
else
    PS1='\n\[\e[1;32m\]┌──[\[\e[1;37m\]AERO X\[\e[1;33m\]@\[\e[1;36m\]__USER_NAME__\[\e[1;32m\]]─[\[\e[1;31m\]\w\[\e[1;32m\]]\n├──[\[\e[1;35m\]⏰ \t\[\e[1;32m\]]\n└─\[\e[1;36m\]>>> \[\e[0m\]'
fi
EOF

# 5. Set User Name Safely
sed -i "s|__USER_NAME__|$USER_NAME|g" ~/.aerox_banner.sh

# 6. Add to Termux Startup (.bashrc and .zshrc)
if ! grep -q "source ~/.aerox_banner.sh" ~/.bashrc 2>/dev/null; then
    echo "source ~/.aerox_banner.sh" >> ~/.bashrc
fi

if [ -f ~/.zshrc ]; then
    if ! grep -q "source ~/.aerox_banner.sh" ~/.zshrc 2>/dev/null; then
        echo "source ~/.aerox_banner.sh" >> ~/.zshrc
    fi
fi

echo -e "\n${G}[✔] AERO X OFFICIAL Banner Installed Successfully!${N}"
sleep 1
source ~/.aerox_banner.sh

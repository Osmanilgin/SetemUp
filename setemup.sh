#!/bin/bash

#used_colors
Green="\e[32m"
Red="\e[31m"
Magenta="\e[35m"
White="\e[97m"
Cyan='\e[36m'
Yellow="\e[33m"
LYellow="\e[93m"

#root check
if [ $EUID -ne 0 ]
  then echo -e "${Red}Script needs root privileges"
  exit
fi


#Banner
echo -e "
${LYellow} 
#  ███████╗███████╗████████╗███████╗███╗   ███╗██╗   ██╗██████╗  #
#  ██╔════╝██╔════╝╚══██╔══╝██╔════╝████╗ ████║██║   ██║██╔══██╗ #
#  ███████╗█████╗     ██║   █████╗  ██╔████╔██║██║   ██║██████╔╝ #
#  ╚════██║██╔══╝     ██║   ██╔══╝  ██║╚██╔╝██║██║   ██║██╔═══╝  #${Yellow}
#  ███████║███████╗   ██║   ███████╗██║ ╚═╝ ██║╚██████╔╝██║      #

------------------------------------------------------------------


"
# Check if the script is run with sudo
if [[ -n "$SUDO_USER" ]]; then
  # The script was run with sudo, so $SUDO_USER holds the original username
  username="$SUDO_USER"
elif [[ -n "$USER" ]]; then
  # The script was run without sudo, so $USER holds the current username
  username="$USER"
else
  # Fallback: Use 'whoami' command to get the current user
  username=$(whoami)
fi

# Display the username
echo "The script was started by: $username"
echo "The config files will be saved on $username 's home directory"

# Get the home directory of the specified username
user_home=$(getent passwd "$username" | awk -F ':' '{print $6}')

echo "Home directory: $user_home"

mkdir $user_home/setemup
cd $user_home/setemup

# apt update
echo -e "${Cyan} #######################  Updating apt  ########################${White}"
echo -e '\n'
apt-get update

#Very Basic setup
echo -e "${Magenta}-------------Checking basic commands... ------------------"
if ! command -v sudo &> : || ! command -v curl &> : || ! command -v wget &> : || ! command -v ifconfig &> : 
then
	echo -e "${Cyan}######## Installing sudo wget net-tools netcat-traditional ########${White}"
	apt install -y curl sudo wget net-tools netcat-traditional unzip nano software-properties-common &> :
	echo -e "${Green}####### Tools installed successfully ######"
else	
echo -e "${White}------------- Base binaries seems like installed -------------"
echo -e "\n"
fi

#Check Go 
go_v=$(go version) &> :
if ! command -v go &> :
then
    echo -e "${Cyan}--------  Go is not installed. Installing... ----------${White}"
    apt-get remove -y golang &> :
    rm -rf /usr/local/go &> :
    sudo add-apt-repository -y ppa:longsleep/golang-backports
    sudo apt update
    apt-get install -y golang-go &>:
    echo -e "${Green}--------  Go installed successfully! ----------${White}"
else
echo -e "${Green}Go is already installed, version: ${go_v:13}${END}"
fi
export GOPATH=$user_home/go/

#Check python3 
python_v=$(python3 --version) &> :
if ! command -v python &> :
then
    echo -e "${Cyan}--------Python3 is not installed. Installing.... ----------${White}"
    apt install python3 -y &> :
    if command -v python3 &> :
    then
        echo -e "${Green}--------  Python3 installed successfully! --------${White}"
    fi
else
    echo -e "${Green}Python is already installed, version:${python_v:6}${White}"
fi

#Check git 
git_v=$(git version) &> :
if ! command -v git &> :
then
    echo -e "${Cyan}--------Git is not installed. Installing.... ----------${White}"
    apt-get install git -y &> :
    if command -v git &> :
    then
        echo -e "${Green}----------  Git installed successfully! -------------${White}"
    fi
else
    echo -e "${Green}Git is already installed, version:${git_v:11}${White}"
fi

# Installing Tools
echo -e '\n'
echo -e "${Yellow}####################### Installing Tools #######################${White}"
echo -e '-----------------------'

#Subfinder
if ! command -v subfinder &> :
then
    echo -e "${Cyan}--------Subfinder----------${White}"
    go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
    mv $user_home/go/bin/subfinder /usr/bin
    if command -v subfinder &> :
    then
        echo -e "${Green}--------  Subfinder installed successfully! ----------${White}"
    fi
else
    echo -e "${Green}Subfinder is already installed.${White}"
fi

#Assetfinder
if ! command -v assetfinder &> :
then
    echo -e "${Cyan}--------Assetfinder----------${White}"
    go install github.com/tomnomnom/assetfinder@latest
    mv $user_home/go/bin/assetfinder /usr/bin
    if command -v assetfinder &> :
    then
        echo -e "${Green}--------  Assetfinder installed successfully!   ----------${White}"
    fi
else
    echo -e "${Green}Assetfinder is already installed.${White}"
fi

#fff
if ! command -v fff &> :
then
    echo -e "${Cyan}--------fff----------${White}"
    go install github.com/tomnomnom/fff@latest
    mv $user_home/go/bin/fff /usr/bin
    if command -v fff &> :
    then
        echo -e "${Green}--------  fff installed successfully! ----------${White}"
    fi
else
    echo -e "${Green}fff is already installed.${White}"
fi

#fff
if ! command -v ffuf &> :
then
    echo -e "${Cyan}--------Ffuf----------${White}"
    apt install -y ffuf
    if command -v ffuf &> :
    then
        echo -e "${Green}--------  Ffuf installed successfully! -----${White}"
    fi
else
    echo -e "${Green}Ffuf is already installed.${White}"
fi

#Feroxbuster
if ! command -v feroxbuster &> :
then
    echo -e "${Cyan}--------Feroxbuster----------${White}"
    curl -sL https://raw.githubusercontent.com/epi052/feroxbuster/main/install-nix.sh | bash -s /usr/bin/
    if command -v feroxbuster &> :
    then
        echo -e "${Green}--------  Feroxbuster installed successfully! ----------${White}"
    fi
else
    echo -e "${Green}Feroxbuster is already installed.${White}"
fi

#waybackurls
if ! command -v waybackurls &> :
then
    echo -e "${Cyan}--------waybackurls----------${White}"
    go install github.com/tomnomnom/waybackurls@latest
    mv $user_home/go/bin/waybackurls /usr/bin
    if command -v waybackurls &> :
    then
        echo -e "${Green}--------  waybackurls installed successfully!   ----------${White}"
    fi
else
    echo -e "${Green}waybackurls is already installed.${White}"
fi

#Amass
if ! command -v amass &> :
then
    echo -e "${Cyan}--------Amass----------${White}"
    go install  github.com/owasp-amass/amass/v4/...@master
    mv $user_home/go/bin/amass /usr/bin
    if command -v amass &> :
    then
        echo -e "${Green}--------  Amass installed successfully! ------${White}"
    fi
else
    echo -e "${Green}Amass is already installed.${White}"
fi

#httpx
if ! command -v httpx &> :
then
    echo -e "${Cyan}--------httpx----------${White}"
    go install github.com/projectdiscovery/httpx/cmd/httpx@latest
    mv $user_home/go/bin/httpx /usr/bin
    if command -v httpx &> :
    then
        echo -e "${Green}--------  httpx installed successfully! ------${White}"
    fi
else
    echo -e "${Green}httpx is already installed.${White}"
fi

#Haktrails
if ! command -v haktrails &> :
then
    echo -e "${Cyan}--------hacktrails----------${White}"
    go install  github.com/hakluke/haktrails@latest
    mv $user_home/go/bin/haktrails /usr/bin
    if command -v haktrails &> :
    then
        echo -e "${Green}--------  haktrails installed successfully! ----------${White}"
    fi
else
    echo -e "${Green}haktrails is already installed.${White}"
fi

#meg
if ! command -v meg &> :
then
    echo -e "${Cyan}--------meg----------${White}"
    go install github.com/tomnomnom/meg@latest
    mv $user_home/go/bin/meg /usr/bin
    if command -v meg &> :
    then
        echo -e "${Green}--------  meg installed successfully! ----${White}"
    fi
else
    echo -e "${Green}meg is already installed.${White}"
fi

#gau
if ! command -v gau &> :
then
    echo -e "${Cyan}--------gau----------${White}"
    go install github.com/lc/gau/v2/cmd/gau@latest
    mv $user_home/go/bin/gau /usr/bin
    if command -v gau &> :
    then
        echo -e "${Green}--------  gau installed successfully! -------${White}"
    fi
else
    echo -e "${Green}gau is already installed.${White}"
fi

#unfurl
if ! command -v unfurl &> :
then
    echo -e "${Cyan}--------unfurl----------${White}"
    go install github.com/tomnomnom/unfurl@latest
    mv $user_home/go/bin/unfurl /usr/bin
    if command -v unfurl &> :
    then
        echo -e "${Green}--------  unfurl installed successfully! ----${White}"
    fi
else
    echo -e "${Green}unfurl is already installed.${White}"
fi

#nmap
if ! command -v nmap &> :
then
    echo -e "${Cyan}--------nmap----------${White}"
    apt install -y nmap
    if command -v nmap &> :
    then
        echo -e "${Green}--------  nmap installed successfully! ----${White}"
    fi
else
    echo -e "${Green}nmap is already installed.${White}"
fi

#gf
if ! command -v gf &> :
then
    echo -e "${Cyan}--------gf----------${White}"
    go install github.com/tomnomnom/gf@latest
    git clone https://github.com/tomnomnom/gf.git 
    git clone https://github.com/Osmanilgin/Gf-Patterns
    curl -s https://raw.githubusercontent.com/tomnomnom/gf/master/gf-completion.zsh >> $user_home/.zshrc
    curl -s https://raw.githubusercontent.com/tomnomnom/gf/master/gf-completion.bash >> $user_home/.bashrc

    mkdir $user_home/.gf
    cp Gf-Patterns/*.json $user_home/.gf
    cp gf/examples/* $user_home/.gf
    mv $user_home/go/bin/gf /usr/bin
    if command -v gf &> :
    then
    	rm -rf gf Gf-Patterns
        echo -e "${Green}--------  gf installed successfully! ----${White}"
    fi
else
    echo -e "${Green}gf is already installed.${White}"
fi

#gospider
if ! command -v gospider &> :
then
    echo -e "${Cyan}--------gospider----------${White}"
    go install github.com/jaeles-project/gospider@latest
    mv $user_home/go/bin/gospider /usr/bin
    if command -v gospider &> :
    then
        echo -e "${Green}--------  gospider installed successfully! ----${White}"
    fi
else
    echo -e "${Green}gospider is already installed.${White}"
fi

#dalfox
if ! command -v dalfox &> :
then
    echo -e "${Cyan}--------dalfox----------${White}"
    go install github.com/hahwul/dalfox/v2@latest
    mv $user_home/go/bin/dalfox /usr/bin
    if command -v dalfox &> :
    then
        echo -e "${Green}--------  dalfox installed successfully! ----${White}"
    fi
else
    echo -e "${Green}dalfox is already installed.${White}"
fi

#qsreplace
if ! command -v qsreplace &> :
then
    echo -e "${Cyan}--------qsreplace----------${White}"
    go install github.com/tomnomnom/qsreplace@latest
    mv $user_home/go/bin/qsreplace /usr/bin
    if command -v qsreplace &> :
    then
        echo -e "${Green}--------  qsreplace installed successfully! ----${White}"
    fi
else
    echo -e "${Green}qsreplace is already installed.${White}"
fi

#wafw00f
if ! command -v wafw00f &> :
then
    echo -e "${Cyan}--------wafw00f----------${White}"
    git clone https://github.com/EnableSecurity/wafw00f.git
    python wafw00f/setup.py install
    cp wafw00f/wafw00f/bin/wafw00f /usr/bin/wafw00f
    if command -v wafw00f &> :
    then
        echo -e "${Green}--------  wafw00f installed successfully! ----${White}"
        rm -rf wafw00f
    fi
else
    echo -e "${Green}wafw00f is already installed.${White}"
fi

#anew
if ! command -v anew &> :
then
    echo -e "${Cyan}--------anew----------${White}"
    go install -v github.com/tomnomnom/anew@latest
    mv $user_home/go/bin/anew /usr/bin/
    if command -v anew &> :
    then
        echo -e "${Green}--------  anew installed successfully! ----${White}"
    fi
else
    echo -e "${Green}anew is already installed.${White}"
fi

#nuclei
if ! command -v nuclei &> :
then
    echo -e "${Cyan}--------nuclei----------${White}"
    go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
    mv $user_home/go/bin/nuclei /usr/bin
    if command -v nuclei &> :
    then
        echo -e "${Green}--------  nuclei installed successfully! ----${White}"
    fi
else
    echo -e "${Green}nuclei is already installed.${White}"
fi

#findomain
if ! command -v findomain &> :
then
    echo -e "${Cyan}--------findomain----------${White}"
    curl -LO https://github.com/findomain/findomain/releases/latest/download/findomain-linux-i386.zip
    unzip findomain-linux-i386.zip
    chmod +x findomain
    mv findomain /usr/bin/findomain
    rm findomain-linux-i386.zip
    if command -v findomain &> :
    then
        echo -e "${Green}--------  findomain installed successfully! ----${White}"
    fi
else
    echo -e "${Green}findomain is already installed.${White}"
fi
#--+bashrc-sync
BASHRC_VERSION="13.01.06(10)"

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups
# ... and ignore same sucessive entries.
export HISTCONTROL=ignoreboth

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

#unset color_prompt force_color_prompt

# enable programmable completion feature
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# ANSI color codes
RS="\[\033[0m\]"    # reset
HC="\[\033[1m\]"    # hicolor
UL="\[\033[4m\]"    # underline
INV="\[\033[7m\]"   # inverse background and foreground
FBLK="\[\033[30m\]" # foreground black
FRED="\[\033[31m\]" # foreground red
FGRN="\[\033[32m\]" # foreground green
FYEL="\[\033[33m\]" # foreground yellow
FBLE="\[\033[34m\]" # foreground blue
FMAG="\[\033[35m\]" # foreground magenta
FCYN="\[\033[36m\]" # foreground cyan
FWHT="\[\033[37m\]" # foreground white
BBLK="\[\033[40m\]" # background black
BRED="\[\033[41m\]" # background red
BGRN="\[\033[42m\]" # background green
BYEL="\[\033[43m\]" # background yellow
BBLE="\[\033[44m\]" # background blue
BMAG="\[\033[45m\]" # background magenta
BCYN="\[\033[46m\]" # background cyan
BWHT="\[\033[47m\]" # background white

# colors
BLACK='\e[0;30m'
BLUE='\e[0;34m'
GREEN='\e[0;32m'
CYAN='\e[0;36m'
RED='\e[0;31m'
PURPLE='\e[0;35m'
BROWN='\e[0;33m'
LIGHTGRAY='\e[0;37m'
DARKGRAY='\e[1;30m'
LIGHTBLUE='\e[1;34m'
LIGHTGREEN='\e[1;32m'
LIGHTCYAN='\e[1;36m'
LIGHTRED='\e[1;31m'
LIGHTPURPLE='\e[1;35m'
YELLOW='\e[1;33m'
WHITE='\e[1;37m'
RED='\e[1;31m'
NC='\e[0m' # No Color

# prompt
PS1="$HC$FRED[ $FGRN\u$FRED@$FGRN\h$FRED: $FGRN\w $FRED]\\$ $RS"
PS2="$HC$FRED> $RS"


########################################################################
# Alias definitions.
########################################################################
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable color support via aliases
eval "`dircolors -b`"
alias ls='ls --color=auto'
alias dir='ls --color=auto --format=vertical'
alias vdir='ls --color=auto --format=long'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias less='less -R'

# primary aliases 
alias lh='ls -lAh'
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'
alias df='df -h'
alias du='du -h'
alias ps='ps -f'
alias iddqd='sudo su -p -'
alias god='sudo su -p -'


# optional tool aliases
# only create the alias if the application is found
if [ -f /usr/bin/htop ]; then alias top='htop'; fi #htop
if [ -f /usr/bin/traceroute ]; then alias tracert='traceroute -n'; fi #traceroute
if [ -f /usr/bin/mutt ]; then alias mail='mutt'; fi #mutt
if [ -f /usr/bin/wodim ]; then alias burn='wodim -v dev=/dev/dvdrw driveropts=burnfree -sao'; fi #wodim
if [ -f /usr/bin/ipcalc ]; then alias ipcalc='ipcalc -b'; fi #ipcalc
if [ -f /usr/bin/rdesktop ]; then alias rdp='rdesktop -r clipboard:PRIMARYCLIPBOARD -x:l -g 1024x768'; fi #rdesktop
if [ -f /usr/bin/wikipedia2text ]; then alias wiki='wikipedia2text -p'; fi #wikipedia2text
if [ -f /usr/bin/weather ]; then alias weather='weather --id=KFDK'; fi #weather-util
if [ -f /usr/bin/deluge ]; then alias torrents='deluge -u console'; fi #deluge


########################################################################
# Functions
########################################################################
PUBLICIP_URL="https://nephelai.org/ip/"

function ii()   # Get current host related info.
{
    echo -e "\n${YELLOW}You are logged on as ${USER}@"`hostname -f`
    echo -e "\n${RED}Current date:$NC "`date`
    echo -e "\n${RED}Distribution:$NC "`lsb_release -d | sed "s/Description\:\t//g"` ; uname -a
    echo -e "\n${RED}Users logged on:$NC " ; w -h
    echo -e "\n${RED}Machine stats:$NC " ; uptime
    echo -e "\n${RED}Memory stats (in MB):$NC " ; free -om
    echo -e "\n${RED}Local IP Address(es):$NC "`ifconfig | grep "inet" | awk '/inet addr/ { print $2 }' | sed "s/addr://"`
    if ifconfig | grep -q "ppp0"; then
	echo -e "\n${RED}VPN Addresses:$NC ";
	echo -e "${RED}   Server:$NC "`/sbin/ifconfig ppp0 | awk '/P-t-P/ { print $3 } ' | sed -e s/P-t-P://`
	echo -e "${RED}   Client:$NC "`/sbin/ifconfig ppp0 | awk '/inet/ { print $2 }' | sed -e s/addr://`
    fi
    echo -e "\n${RED}ISP Address:$NC "`wget -qO- --no-cache --no-cookies ${PUBLICIP_URL} | sed -e 's/^[ \t]*//'`
    echo
}

function apt-history(){
      case "$1" in
        install)
              cat /var/log/dpkg.log | grep 'install '
              ;;
        upgrade|remove)
              cat /var/log/dpkg.log | grep $1
              ;;
        rollback)
              cat /var/log/dpkg.log | grep upgrade | \
                  grep "$2" -A10000000 | \
                  grep "$3" -B10000000 | \
                  awk '{print $4"="$5}'
              ;;
        *)
              cat /var/log/dpkg.log
              ;;
      esac
}

function update-bashrc()
{
    CS_URL=https://s3.amazonaws.com/Filesync-Linux/.bashrc
    CS_FILE=~/.bashrc.new
    CB_FILE=~/.bashrc.bak
    CR_FILE=~/.bashrc

    # download updated .bashrc
    wget --no-cache --no-cookies -c -t 3 -T 5 -O "${CS_FILE}" "${CS_URL}"

    # check for complete download
    CS_NEW_START=`grep "\-\-+bashrc\-sync" "${CS_FILE}"`
    CS_NEW_END=`grep "\-\-\-bashrc\-sync" "${CS_FILE}"`
    if [ -n "${CS_NEW_START}" ] && [ -n "${CS_NEW_END}" ]; then
       echo -e "${YELLOW}Downloaded Successful.$NC"
       diff ${CR_FILE} ${CS_FILE}
       cp ${CR_FILE} ${CB_FILE} 
       echo -e "${YELLOW}Backed up ${CR_FILE} to ${CB_FILE}.$NC"
       mv ${CS_FILE} ${CR_FILE}
       echo -e "${YELLOW}Moved new ${CS_FILE} to ${CR_FILE}.$NC"
    else
       rm -f "${CS_FILE}"
       echo -e "${YELLOW}Download Failed. Nothing Updated.$NC"
    fi
}

function initsys()
{
  case $1 in
    mail)
      INSTALL_LIST="mailx mutt"
      ;;
    tools)
      INSTALL_LIST="vim vim-runtime lynx w3m lfm htop wodim"
      ;;
    extract)
      INSTALL_LIST="p7zip unrar unzip"
      ;;
    network)
      INSTALL_LIST="nmap snmp smbfs samba-common sshfs traceroute ipcalc iperf iftop netdiag"
      ;;
    build)
      INSTALL_LIST="build-essential"
      ;;
    misc)
      INSTALL_LIST="weather-util wikipedia2text"
      ;;
    perl)
      INSTALL_LIST="perl"
      ;;
    php)
      INSTALL_LIST="php5-cli"
      ;;
    *)
      echo -e "Usage: initialize-system [mail|tools|network|misc|perl|php]"
      echo -e "Note: Must have sudo permission"
      return;
      ;;
  esac
  echo -e "${LIGHTPURPLE}Installing the following packages: ${WHITE}${INSTALL_LIST}$NC"
  if [ -n "${INSTALL_LIST}" ]; then
    sudo apt-get install ${INSTALL_LIST}
  fi
}

MINECRAFT_JAR="/usr/local/bin/minecraft.jar"
MINECRAFT_ICON_DIR="/usr/local/bin"

function minecraft-download()
{
  sudo wget --no-cache --no-cookies -O "${MINECRAFT_JAR}" https://s3.amazonaws.com/MinecraftDownload/launcher/minecraft.jar
  sudo wget --no-cache --no-cookies -O "${MINECRAFT_ICON_DIR}/minecraft_icon1.png" https://nephelai.org/minecraft/minecraft_icon1.png
  sudo wget --no-cache --no-cookies -O "${MINECRAFT_ICON_DIR}/minecraft_icon2.png" https://nephelai.org/minecraft/minecraft_icon2.png
}

function minecraft-start()
{
  /usr/bin/java -Xmx1024M -Xms512M -cp ${MINECRAFT_JAR} net.minecraft.LauncherFrame
}

#-------------------------------------------------------------
# Network
#-------------------------------------------------------------

function public-ip()
{
	echo -e "${RED}Public IP:$NC "`wget -qO- --no-cache --no-cookies ${PUBLICIP_URL} | sed -e 's/^[ \t]*//'`
}

function pppstatus()
{
	if [ -n "$1" ]; then
	   INT=`echo -e "$1" | awk '{print tolower($0) }'`
	else
	   INT=ppp0
	fi
        INT_STATUS=$(ifconfig -a -s | grep "${INT}")
        if [ ! -n "${INT_STATUS}" ]; then
           echo -e "${RED}Interface '${YELLOW}${INT}${RED}' Not Found.$NC"
           return;
        fi

	echo -e "${RED}Interface:$NC ${INT}"
	if [ -f "/var/run/${INT}.pid" ]; then
	   PPP_PID=`cat /var/run/${INT}.pid | sed -e 's/^[ \t]*//'`
	else
	   PPP_PID="Not Running"
	fi
	echo -e "${RED}Process ID:$NC ${PPP_PID}"
	echo -e "${RED}Interface Status:$NC " ; ifconfig ${INT} 
	echo -e "${RED}Routing Table:$NC " ; route -n
	echo -e "${RED}Logs:\n$NC==> /var/log/messages <== " ; grep "pppd\[${PPP_PID}\]" /var/log/messages | tail -n 10 
}

update-opendns()
{
  if [ -n "$1" ]; then
    echo -ne "${LIGHTPURPLE}"; /usr/bin/curl -m 60 -u $1 'https://updates.opendns.com/account/ddns.php?'
    echo -e "$NC"
  else
    echo -e "Usage: update-opendns [username]"
    echo -e "Example: update-opendns email@domain.com"
  fi
}

#-------------------------------------------------------------
# Log Reporting
#-------------------------------------------------------------

function syslog() { tail -n 25 -f /var/log/syslog | sed "s/\($1\)/[43;31m\1[0m/g" ; }
function msgs() { tail -n 25 -f /var/log/messages | sed "s/\($1\)/[43;31m\1[0m/g" ; }
function wwwlog() { tail -n 25 -f /var/log/lighttpd/error.log | sed "s/\($1\)/[43;31m\1[0m/g" ; }

#-------------------------------------------------------------
# File & string-related functions:
#-------------------------------------------------------------

function bu() { cp $1 ${1}-`date +%Y%m%d%H%M`.backup ; }

function trace() { tail -n 25 -f $1 | sed "s/\($2\)/[43;31m\1[0m/g" ; }

# Find a file with a pattern in name:
function ff() { find . -type f -iname '*'$*'*' -ls ; }

# Find a file with pattern $1 in name and Execute $2 on it:
function fe() { find . -type f -iname '*'${1:-}'*' -exec ${2:-file} {} \;  ; }

# Find a pattern in a set of files and highlight them:
# (needs a recent version of egrep)
function fstr()
{
    OPTIND=1
    local case=""
    local usage="fstr: find string in files.
Usage: fstr [-i] \"pattern\" [\"filename pattern\"] "
    while getopts :it opt
    do
        case "$opt" in
        i) case="-i " ;;
        *) echo "$usage"; return;;
        esac
    done
    shift $(( $OPTIND - 1 ))
    if [ "$#" -lt 1 ]; then
        echo "$usage"
        return;
    fi
    find . -type f -name "${2:-*}" -print0 | \
    xargs -0 egrep --color=always -sn ${case} "$1" 2>&- | more 

}

function cuttail() # cut last n lines in file, 10 by default
{
    nlines=${2:-10}
    sed -n -e :a -e "1,${nlines}!{P;N;D;};N;ba" $1
}

function lowercase()  # move filenames to lowercase
{
    for file ; do
        filename=${file##*/}
        case "$filename" in
        */*) dirname==${file%/*} ;;
        *) dirname=.;;
        esac
        nf=$(echo $filename | tr A-Z a-z)
        newname="${dirname}/${nf}"
        if [ "$nf" != "$filename" ]; then
            mv "$file" "$newname"
            echo "lowercase: $file --> $newname"
        else
            echo "lowercase: $file not changed."
        fi
    done
}

function swap()  # Swap 2 filenames around, if they exist
{
    local TMPFILE=tmp.$$ 

    [ $# -ne 2 ] && echo "swap: 2 arguments needed" && return 1
    [ ! -e $1 ] && echo "swap: $1 does not exist" && return 1
    [ ! -e $2 ] && echo "swap: $2 does not exist" && return 1

    mv "$1" $TMPFILE 
    mv "$2" "$1"
    mv $TMPFILE "$2"
}

function extract()      # Handy Extract Program.
{
     if [ -f $1 ] ; then
         case $1 in
             *.tar.bz2)   tar xvjf $1     ;;
             *.tar.gz)    tar xvzf $1     ;;
             *.bz2)       bunzip2 $1      ;;
             *.rar)       unrar x $1      ;;
             *.gz)        gunzip $1       ;;
             *.tar)       tar xvf $1      ;;
             *.tbz2)      tar xvjf $1     ;;
             *.tgz)       tar xvzf $1     ;;
             *.zip)       unzip $1        ;;
             *.Z)         uncompress $1   ;;
             *.7z)        7z x $1         ;;
             *)           echo "'$1' cannot be extracted via >extract<" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

#-------------------------------------------------------------
# Random
#-------------------------------------------------------------

# define a word via google.
# usage: define [-n N] WORD
#        where "N" is the number of records to display
define ()
{
  count=5 #set default
  usage="Usage: $0 [-n value] WORD\n"
  while getopts n: name
  do
    case $name in
      n)
          if [[ "$OPTARG" =~ ([0-9]+) ]]; then
            count=$OPTARG
          else
            echo -e "$usage"
            return
          fi
          ;;
      ?)  echo -e "$usage"
          return;;
    esac
  done
  shift $(($OPTIND - 1))
  word="$*"
  if [ ! -n "$word" ]; then
    echo -e "$usage"
    return;
  fi
  echo -e "${RED}Define: ${YELLOW}$word$NC"
  lynx -dump "http://www.google.com/search?hl=en&q=define%3A+${word}&btnG=Google+Search" | awk -v cnt="${count}" 'BEGIN {x=0; c=0} {
    if ($0~"\*") {x=1;c++}
    if (x==1 && c<=cnt) {print $0}
    if ($0~"\[") {x=0} }' | sed -e "/\[.*$/d"
}

########################################################################
# WELCOME SCREEN
########################################################################
echo -ne "${LIGHTGREEN}Hello, $USER. today is, "; date
echo -ne "${LIGHTPURPLE}"; uptime | sed "s/^\ //g"; echo ""
#---bashrc-sync

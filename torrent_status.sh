#!/bin/bash
# Requirements rTorrent, deluge & linux

option(){
answer=$1;
case "$answer" in
        1) rtorrent_restart ;;
        2) deluge_restart ;;
        3) rtorrent_status ;;
        4) deluge_status ;;
        5) hdd_usage ;;
        *) echo "1 or 2" ; exit;
esac;
}
rtorrent_restart(){
#reply=''
if pgrep -U $(whoami) rtorrent &>/dev/null ; then
echo -en "\e[32mrtorrent is running, do you want to restart it? yes/no \e[0m"
        read -p ":" reply
        if [[ "$reply" = 'yes' ]]; then
        echo -e "\e[33mrestarting rtorrent...\e[0m"
        screen -X -S rtorrent quit >&/dev/null
#       kill -9 $(pgrep -u $(whoami) rtorrent) >&/dev/null
#       kill -9 $(pgrep -u $(whoami) screen) >&/dev/null
#       kill -9 $(pgrep -u $(whoami) irssi) >&/dev/null

        screen -wipe >&/dev/null
#       rm -f /var/run/screen/S-$/$(whoami).rtorrent
#       rm -f /var/run/screen/S-$(whoami)/$(whoami).irssi >&/dev/null
#       rm -f ~/rtorrent/.session/rtorrent.lock
        screen -dm -S rtorrent rtorrent >&/dev/null
        sleep 1
        pgrep -U $(whoami) rtorrent >&/dev/null
        [[ $? = 0 ]]  && echo -e "\e[31mrtorrent restarted and is running\e[0m" || echo -e "\e[31mcan't start rtorrent, please contact support\e[0m"
        else
        echo -e "\e[31mexiting...\e[0m"
        fi
else
echo -e "\e[33mrestarting rtorrent...\e[0m"
screen -X -S rtorrent quit >&/dev/null
screen -wipe >&/dev/null
screen -dm -S rtorrent rtorrent >&/dev/null
sleep 1
pgrep -U $(whoami) rtorrent >&/dev/null
[[ $? = 0 ]] && echo -e "\e[31mrtorrent restarted and is running\e[0m" || echo -e "\e[31mcan't start rtorrent, please contact support\e[0m"
fi
}

deluge_restart(){
if [[ -f ~/.config/deluge/core.conf ]]; then
        if pgrep -U $(whoami) deluged &>/dev/null ; then
        echo -e "\e[32mdeluge is running, do you want to restart it? yes/no \e[0m"
        read -p ":" reply
                if [[ "$reply" = 'yes' ]]; then
                echo -e "\e[33mrestarting deluge...\e[0m"
                killall -I -9 deluged deluge-web
                sleep 1
                deluged && deluge-web -f
                sleep 1
                pgrep -U $(whoami) deluged &>/dev/null
                [[ $? = 0 ]] && echo -e "\e[31mdeluge restarted and is running\e[0m" || echo -e "\e[31mcan't start deluge, please contact support\e[0m"
                else
                echo -e "\e[31mexiting...\e[0m"
                exit
                fi
        else
        killall -I -9 deluged deluge-web
        sleep 1
        deluged && deluge-web -f
        sleep 1
        pgrep -U $(whoami) deluged &>/dev/null
        [[ $? = 0 ]] && echo -e "\e[31mdeluge restarted and is running\e[0m" || echo -e "\e[31mcan't start deluge, please contact support\e[0m"
        fi
else
echo -e "\e[31myou don't have deluge installed, exiting...\e[0m"
fi
}

rtorrent_status(){
pgrep -U $(whoami) rtorrent &>/dev/null && echo -e "\e[33mrtorrent is running\e[0m" || echo -e "\e[31mrtorrent is down\e[0m"
}

deluge_status(){
[[ -f ~/.config/deluge/core.conf ]] && pgrep -U $(whoami) deluge &>/dev/null && echo -e "\e[33mdeluge is running\e[0m" || echo -e "\e[31mdeluge is down\e[0m"
}

hdd_usage(){
echo -e "\e[33mused $(du -sh ~ | awk -F " " '{print $1}')iB\e[0m"
}

option $*

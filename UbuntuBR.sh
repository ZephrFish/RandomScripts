#!/bin/bash
# Linux Build Review Tool
# Must be run as Root

tarball="${HOSTNAME}-$(date +%Y-%m-%d).tar"
workdir="${PWD}/${HOSTNAME}-$(date +%Y-%m-%d)"

info(){ printf "\e[0;94m[*]\e[0m %s\n" "${*}"; }
error(){ printf "\e[0;91m[x]\e[0m %s\n" "${*}"; }
success(){ printf "\e[0;92m[+]\e[0m %s\n" "${*}"; }
warning(){ printf "\e[0;93m[!]\e[0m %s\n" "${*}"; }

got_root(){
    if [ $UID -ne 0 ]; then
        printf "\e[0;91mGot r00t?\e[0m\n"
        exit 1
    fi
}

create_workdir(){
    if [[ -d "$workdir" ]]; then
        error "$workdir exists"
        exit 2
    else
        success "Creating $workdir"
        mkdir "$workdir"
    fi
}

collect_data(){
    success "Changing to directory $workdir"
    success "Collecting data ..."

    cd "$workdir" && {
		### host overview
		hostname > 01-hostname.txt # hostname
		ifconfig > 02-ifconfig.txt # ip
		cat /etc/*-release > 03-release.txt # release

		### patch analysis
		uname -a > 04-uname.txt # kernel version
        	rpm -qa | sort  | pr -tw123 -4 > 05-InstalledProg.txt # installed programs

		### User access review
		grep 'x:0:' /etc/passwd > 06-UsersWithUID0.txt # Lists users with UID 0
		grep root /etc/group > 07-UsersInRootGroup.txt # Lists users in group root
		cat /etc/sudoers | grep "(" | grep -v "#" > 08-UsersInSudoersFile.txt # Lists users in sudoers file.

		### File Permissions
		mount > 09-MountedPoints.txt # see mount points.
 		ls -lah /etc/ > 10-EtcPermissions.txt # see /etc/ permissions
        	ls -lah /var/ > 11-VarPermissions.txt # see /var/ permissions
		find / -perm -4000 -exec ls -la {} \; > 12-SuidFilePermissions.txt # suid permissions

		# Network View
        	netstat -tulpna > 13-NetstatResults.txt
		iptables -nvL -t filter > 14-FirewallConfig.txt

        	success "Finding SUID files"

        	systemctl | grep running > 15-RunningServices.txt

        if [ $EUID -eq 0 ]; then
            success "Collecting privileged data"

            cp -R /etc . # Copy all etc files to current directory 

        fi
        cd "$OLDPWD"
        success "Data collected"
    } || {
        error "Cannot change dir to $workdir"
        exit 3
    }
}

create_tarball(){
    if [[ -f "$tarball" ]]; then
        error "$tarball already exists"
    else
        success "Creating $tarball"
        tar -cvf "$tarball" . || error "Failed to create $tarball"
    fi
}

cleanup(){
    success "Deleting $workdir"
    rm -rf "$workdir"
}

# =============================================================================

success "Starting at $(date)"

got_root

create_workdir

collect_data

create_tarball

cleanup

success "Done"

exit 0


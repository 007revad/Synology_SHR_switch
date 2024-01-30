#!/usr/bin/env bash
#------------------------------------------------------------------------------
# Switch between SHR and RAID Group for models that have SHR & SHR-2 disabled
#
# Github: https://github.com/007revad/Synology_SHR_switch
# Script verified at https://www.shellcheck.net/
#
# To run in a shell (replace /volume1/scripts/ with path to script):
# sudo /volume1/scripts/syno_shr_switch.sh
#------------------------------------------------------------------------------

scriptver="v1.0.11"
script=Synology_SHR_switch
repo="007revad/Synology_SHR_switch"
scriptname=syno_shr_switch

# Check BASH variable is bash
if [ ! "$(basename "$BASH")" = bash ]; then
    echo "This is a bash script. Do not run it with $(basename "$BASH")"
    printf \\a
    exit 1
fi

#echo -e "bash version: $(bash --version | head -1 | cut -d' ' -f4)\n"  # debug

# Shell Colors
#Black='\e[0;30m'   # ${Black}
Red='\e[0;31m'      # ${Red}
#Green='\e[0;32m'    # ${Green}
#Yellow='\e[0;33m'   # ${Yellow}
#Blue='\e[0;34m'    # ${Blue}
#Purple='\e[0;35m'  # ${Purple}
Cyan='\e[0;36m'     # ${Cyan}
#White='\e[0;37m'   # ${White}
Error='\e[41m'      # ${Error}
Off='\e[0m'         # ${Off}


usage(){ 
    cat <<EOF
$script $scriptver - by 007revad

Usage: $(basename "$0") [options]

Options:
  -c, --check      Check the currently set RAID type
  -h, --help       Show this help message
  -v, --version    Show the script version

EOF
    exit 0
}

scriptversion(){ 
    cat <<EOF
$script $scriptver - by 007revad

See https://github.com/$repo

EOF
    exit 0
}


# Save options used
args=("$@")


# Check for flags with getopt
if options="$(getopt -o abcdefghijklmnopqrstuvwxyz0123456789 -l \
    check,help,version,log,debug -- "$@")"; then
    eval set -- "$options"
    while true; do
        case "${1,,}" in
            -h|--help)          # Show usage options
                usage
                ;;
            -v|--version)       # Show script version
                scriptversion
                ;;
            -l|--log)           # Log
                log=yes
                ;;
            -d|--debug)         # Show and log debug info
                debug=yes
                ;;
            -c|--check)         # Show current raid type
                check=yes
                break
                ;;
            --)
                shift
                break
                ;;
            *)                  # Show usage options
                echo -e "Invalid option '$1'\n"
                usage "$1"
                ;;
        esac
        shift
    done
else
    usage
fi


if [[ $debug == "yes" ]]; then
    set -x
    export PS4='`[[ $? == 0 ]] || echo "\e[1;31;40m($?)\e[m\n "`:.$LINENO:'
fi


# Check script is running as root
if [[ $( whoami ) != "root" ]]; then
    echo -e "${Error}ERROR${Off} This script must be run as root or sudo!"
    exit 1
fi

# Show script version
#echo -e "$script $scriptver\ngithub.com/$repo\n"
echo "$script $scriptver"

# Get NAS model
model=$(cat /proc/sys/kernel/syno_hw_version)

# Get DSM full version
productversion=$(get_key_value /etc.defaults/VERSION productversion)
buildphase=$(get_key_value /etc.defaults/VERSION buildphase)
buildnumber=$(get_key_value /etc.defaults/VERSION buildnumber)
smallfixnumber=$(get_key_value /etc.defaults/VERSION smallfixnumber)

# Show DSM full version and model
if [[ $buildphase == GM ]]; then buildphase=""; fi
if [[ $smallfixnumber -gt "0" ]]; then smallfix="-$smallfixnumber"; fi
echo -e "$model DSM $productversion-$buildnumber$smallfix $buildphase\n"


#------------------------------------------------------------------------------
# Check latest release with GitHub API

# Get latest release info
# Curl timeout options:
# https://unix.stackexchange.com/questions/94604/does-curl-have-a-timeout
release=$(curl --silent -m 10 --connect-timeout 5 \
    "https://api.github.com/repos/$repo/releases/latest")

# Release version
tag=$(echo "$release" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
shorttag="${tag:1}"

# Get script location
# https://stackoverflow.com/questions/59895/
source=${BASH_SOURCE[0]}
while [ -L "$source" ]; do # Resolve $source until the file is no longer a symlink
    scriptpath=$( cd -P "$( dirname "$source" )" >/dev/null 2>&1 && pwd )
    source=$(readlink "$source")
    # If $source was a relative symlink, we need to resolve it
    # relative to the path where the symlink file was located
    [[ $source != /* ]] && source=$scriptpath/$source
done
scriptpath=$( cd -P "$( dirname "$source" )" >/dev/null 2>&1 && pwd )
scriptfile=$( basename -- "$source" )
echo "Running from: ${scriptpath}/$scriptfile"

#echo "Script location: $scriptpath"  # debug
#echo "Source: $source"               # debug
#echo "Script filename: $scriptfile"  # debug

#echo "tag: $tag"              # debug
#echo "scriptver: $scriptver"  # debug


cleanup_tmp(){ 
    # Delete downloaded .tar.gz file
    if [[ -f "/tmp/$script-$shorttag.tar.gz" ]]; then
        if ! rm "/tmp/$script-$shorttag.tar.gz"; then
            echo -e "${Error}ERROR${Off} Failed to delete"\
                "downloaded /tmp/$script-$shorttag.tar.gz!" >&2
        fi
    fi

    # Delete extracted tmp files
    if [[ -d "/tmp/$script-$shorttag" ]]; then
        if ! rm -r "/tmp/$script-$shorttag"; then
            echo -e "${Error}ERROR${Off} Failed to delete"\
                "downloaded /tmp/$script-$shorttag!" >&2
        fi
    fi
}


if ! printf "%s\n%s\n" "$tag" "$scriptver" |
        sort --check=quiet --version-sort >/dev/null ; then
    echo -e "\n${Cyan}There is a newer version of this script available.${Off}"
    echo -e "Current version: ${scriptver}\nLatest version:  $tag"
    scriptdl="$scriptpath/$script-$shorttag"
    if [[ -f ${scriptdl}.tar.gz ]] || [[ -f ${scriptdl}.zip ]]; then
        # They have the latest version tar.gz downloaded but are using older version
        echo "You have the latest version downloaded but are using an older version"
        sleep 10
    elif [[ -d $scriptdl ]]; then
        # They have the latest version extracted but are using older version
        echo "You have the latest version extracted but are using an older version"
        sleep 10
    else
        echo -e "${Cyan}Do you want to download $tag now?${Off} [y/n]"
        read -r -t 30 reply
        if [[ ${reply,,} == "y" ]]; then
            # Delete previously downloaded .tar.gz file and extracted tmp files
            cleanup_tmp

            if cd /tmp; then
                url="https://github.com/$repo/archive/refs/tags/$tag.tar.gz"
                if ! curl -JLO -m 30 --connect-timeout 5 "$url"; then
                    echo -e "${Error}ERROR${Off} Failed to download"\
                        "$script-$shorttag.tar.gz!"
                else
                    if [[ -f /tmp/$script-$shorttag.tar.gz ]]; then
                        # Extract tar file to /tmp/<script-name>
                        if ! tar -xf "/tmp/$script-$shorttag.tar.gz" -C "/tmp"; then
                            echo -e "${Error}ERROR${Off} Failed to"\
                                "extract $script-$shorttag.tar.gz!"
                        else
                            # Set script sh files as executable
                            if ! chmod a+x "/tmp/$script-$shorttag/"*.sh ; then
                                permerr=1
                                echo -e "${Error}ERROR${Off} Failed to set executable permissions"
                            fi

                            # Copy new script sh file to script location
                            if ! cp -p "/tmp/$script-$shorttag/${scriptname}.sh" "${scriptpath}/${scriptfile}";
                            then
                                copyerr=1
                                echo -e "${Error}ERROR${Off} Failed to copy"\
                                    "$script-$shorttag sh file(s) to:\n $scriptpath/${scriptfile}"
                            fi

                            # Copy new CHANGES.txt file to script location (if script on a volume)
                            if [[ $scriptpath =~ /volume* ]]; then
                                # Set permsissions on CHANGES.txt
                                if ! chmod 664 "/tmp/$script-$shorttag/CHANGES.txt"; then
                                    permerr=1
                                    echo -e "${Error}ERROR${Off} Failed to set permissions on:"
                                    echo "$scriptpath/CHANGES.txt"
                                fi

                                # Copy new CHANGES.txt file to script location
                                if ! cp -p "/tmp/$script-$shorttag/CHANGES.txt"\
                                    "${scriptpath}/${scriptname}_CHANGES.txt";
                                then
                                    echo -e "${Error}ERROR${Off} Failed to copy"\
                                        "$script-$shorttag/CHANGES.txt to:\n $scriptpath"
                                else
                                    changestxt=" and changes.txt"
                                fi
                            fi

                            # Delete downloaded tmp files
                            cleanup_tmp

                            # Notify of success (if there were no errors)
                            if [[ $copyerr != 1 ]] && [[ $permerr != 1 ]]; then
                                echo -e "\n$tag ${scriptfile}$changestxt downloaded to: ${scriptpath}\n"

                                # Reload script
                                printf -- '-%.0s' {1..79}; echo  # print 79 -
                                exec "${scriptpath}/$scriptfile" "${args[@]}"
                            fi
                        fi
                    else
                        echo -e "${Error}ERROR${Off}"\
                            "/tmp/$script-$shorttag.tar.gz not found!"
                        #ls /tmp | grep "$script"  # debug
                    fi
                fi
                cd "$scriptpath" || echo -e "${Error}ERROR${Off} Failed to cd to script location!"
            else
                echo -e "${Error}ERROR${Off} Failed to cd to /tmp!"
            fi
        fi
    fi
fi


synoinfo="/etc.defaults/synoinfo.conf"


#----------------------------------------------------------
# Check currently enabled RAID type

# Enable SHR
# support_syno_hybrid_raid="yes"
# supportraidgroup="no"
#
# Enable RAID Group
# support_syno_hybrid_raid="no"
# supportraidgroup="yes"

# Set short variables
sshr=support_syno_hybrid_raid
srg=supportraidgroup

# Check current setting
checkcurrent(){ 
    settingshr="$(get_key_value $synoinfo ${sshr})"
    settingraidgrp="$(get_key_value $synoinfo ${srg})"
    if [[ $settingshr == "yes" ]] && [[ $settingraidgrp != "yes" ]]; then
        echo -e "${Cyan}SHR${Off} ${1}enabled.\n" >&2
        enabled="shr"
    elif [[ $settingshr != "yes" ]] && [[ $settingraidgrp == "yes" ]]; then
        echo -e "${Cyan}RAID Group${Off} ${1}enabled.\n" >&2
        enabled="raidgrp"
    fi
}

#checkcurrent "is currently "
checkcurrent "is "
if [[ $check == "yes" ]]; then
    exit
fi


#--------------------------------------------------------------------
# Select RAID type

PS3="Select the RAID type: "
if [[ $enabled == "shr" ]]; then
    options=("RAID Group" "Restore" "Quit")
    #options=("RAID Group" "Quit")
elif [[ $enabled == "raidgrp" ]]; then
    options=("SHR" "Restore" "Quit")
    #options=("SHR" "Quit")
else
    #options=("SHR" "RAID Group" "Restore" "Quit")
    options=("SHR" "RAID Group" "Quit")
fi
select raid in "${options[@]}"; do
    case "$raid" in
        SHR)
            shr="yes"
            echo -e "You selected ${Cyan}SHR${Off}"
            if [[ $enabled == "shr" ]]; then
                echo -e "${Cyan}SHR${Off} is already enabled."
            else
                break
            fi
            ;;
        "RAID Group")
            raidgrp="yes"
            echo -e "You selected ${Cyan}RAID Group${Off}"
            if [[ $enabled == "raidgrp" ]]; then
                echo -e "${Cyan}RAID Group${Off} is already enabled."
            else
                break
            fi
            break
            ;;
        Restore)
            restore="yes"
            echo -e "You selected ${Cyan}Restore${Off}"
            break
            ;;
        Quit)
            echo -e "You selected ${Cyan}Quit${Off}"
            exit
            ;;
        *)
            echo -e "${Red}Invalid answer!${Off} Try again."
            ;;
    esac
done


#----------------------------------------------------------
# Restore from backup synoinfo.conf

if [[ $restore == "yes" ]]; then
    if [[ -f ${synoinfo}.bak ]]; then
        # Restore from backup
        #if cp -p "$synoinfo".bak "$synoinfo" ; then
        #    echo -e "\nSuccessfully restored from backup.\n"
        #    checkcurrent "is now "
        #    exit
        #else
        #    echo -e "\n${Error}ERROR${Off} Restore from backup failed!"
        #    exit 1
        #fi

        # Get default key values from backup
        defaultsrg=$(synogetkeyvalue "$synoinfo".bak "$srg")
        defaultsshr=$(synogetkeyvalue "$synoinfo".bak "$sshr")

        # Set key values to defaults
        if [[ $defaultsrg ]]; then
            #echo -e "\nset support_raid_group $defaultsrg"    # debug

            synosetkeyvalue "$synoinfo" "$srg" "$defaultsrg"
        else
            #echo -e "\nset support_raid_group no"             # debug

            synosetkeyvalue "$synoinfo" "$srg" "no"
        fi
        if [[ $defaultsshr ]]; then
            #echo "set support_syno_hybrid_raid $defaultsshr"  # debug

            synosetkeyvalue "$synoinfo" "$sshr" "$defaultsshr"
        else
            #echo "set support_syno_hybrid_raid no"            # debug

            synosetkeyvalue "$synoinfo" "$sshr" "no"
        fi

        echo
        checkcurrent "is "
    else
        echo -e "\n${Error}ERROR${Off} Backup synoinfo.conf not found!"
        exit 1
    fi
    exit
fi


#----------------------------------------------------------
# Backup synoinfo.conf

if [[ ! -f ${synoinfo}.bak ]]; then
    if cp -p "$synoinfo" "$synoinfo".bak ; then
        echo -e "\nsynoinfo.conf backed up."
    else
        echo -e "\n${Error}ERROR${Off} synoinfo.conf backup failed!"
        exit 1
    fi
else
    echo -e "\nsynoinfo.conf already backed up."
fi


#----------------------------------------------------------
# Edit synoinfo.conf

# Enable RAID Group
if [[ $raidgrp == "yes" ]]; then
    synosetkeyvalue "$synoinfo" "$srg" yes
    synosetkeyvalue "$synoinfo" "$sshr" no

    # Check if we enabled RAID Group
    settingshr="$(get_key_value $synoinfo ${sshr})"
    settingraidgrp="$(get_key_value $synoinfo ${srg})"
    if [[ $settingshr != "yes" ]] && [[ $settingraidgrp == "yes" ]]; then
        echo -e "\n${Cyan}RAID Group${Off} has been enabled.\n"
    else
        echo -e "\n${Error}ERROR${Off} Failed to enable RAID Group!"
    fi
fi


# Enable SHR
if [[ $shr == "yes" ]]; then
    synosetkeyvalue "$synoinfo" "$srg" no
    synosetkeyvalue "$synoinfo" "$sshr" yes

    # Check if we enabled SHR
    settingshr="$(get_key_value $synoinfo ${sshr})"
    settingraidgrp="$(get_key_value $synoinfo ${srg})"
    if [[ $settingshr == "yes" ]] && [[ $settingraidgrp != "yes" ]]; then
        echo -e "\n${Cyan}SHR${Off} has been enabled.\n"
    else
        echo -e "\n${Error}ERROR${Off} Failed to enable SHR!"
    fi
fi

exit


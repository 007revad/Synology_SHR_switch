# Synology SHR switch

<a href="https://github.com/007revad/Synology_SHR_switch/releases"><img src="https://img.shields.io/github/release/007revad/Synology_SHR_switch.svg"></a>
<a href="https://hits.seeyoufarm.com"><img src="https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2F007revad%2FSynology_RAID-F1_SHR_switch&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=views&edge_flat=false"/></a>
[![](https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=%23fe8e86)](https://github.com/sponsors/007revad)
[![committers.top badge](https://user-badge.committers.top/australia/007revad.svg)](https://user-badge.committers.top/australia/007revad)

### Description

Easily switch between SHR and RAID Groups

High-end Synology NAS models have RAID Groups enabled and SHR disabled. This script allows you to switch from SHR to RAID Groups, or from RAID Groups to SHR. It backs up the synoinfo.conf first, so you can restore it later if needed.

## Download the script

1. Download the latest version _Source code (zip)_ from https://github.com/007revad/Synology_SHR_Switch/releases
2. Save the download zip file to a folder on the Synology.
3. Unzip the zip file.

## How to run the script

**Run the script via SSH**

[How to enable SSH and login to DSM via SSH](https://kb.synology.com/en-global/DSM/tutorial/How_to_login_to_DSM_with_root_permission_via_SSH_Telnet)

```YAML
sudo -s /volume1/scripts/syno_shr_switch.sh
```
**Note:** Replace /volume1/scripts/ with the path to where the script is located.

**Options:**
```YAML
  -c, --check      Check the currently set RAID type
  -h, --help       Show this help message
  -v, --version    Show the script version
```

## Screenshots

<p align="center">Check currently set RAID type</p>
<p align="center"><img src="/images/raidgroup_shr-switch_check3.png"></p>

<p align="center">Switch to SHR</p>
<p align="center"><img src="/images/raidgroup_shr-switch_shr3.png"></p>

<p align="center">Switch to RAID Groups</p>
<p align="center"><img src="/images/raidgroup_shr-switch_raidgroup3.png"></p>

<p align="center">Restore from the backup</p>
<p align="center"><img src="/images/raidgroup_shr-switch_restored3.png"></p>


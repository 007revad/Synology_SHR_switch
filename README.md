# Synology SHR switch

<a href="https://github.com/007revad/Synology_RAID-F1_SHR_switch/releases"><img src="https://img.shields.io/github/release/007revad/Synology_RAID-F1_SHR_switch.svg"></a>
<a href="https://hits.seeyoufarm.com"><img src="https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2F007revad%2FSynology_RAID-F1_SHR_switch&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=hits&edge_flat=false"/></a>
[![](https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=%23fe8e86)](https://github.com/sponsors/007revad)
[![committers.top badge](https://user-badge.committers.top/australia/007revad.svg)](https://user-badge.committers.top/australia/007revad)

### Description

Easily switch between SHR and RAID Group

This script allows you to switch from SHR to RAID Group, or from RAID Group to SHR. It backs up the synoinfo.conf first, so you can restore it later if needed.

## Download the script

See <a href=images/how_to_download_generic.png/>How to download the script</a> for the easiest way to download the script.

## How to run the script

**Run the script via SSH**

```YAML
sudo -i /volume1/scripts/syno_raidf1_shr_switch.sh
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
<p align="center"><img src="/images/raidgroup_shr-switch_check.png"></p>

<p align="center">Switch to SHR</p>
<p align="center"><img src="/images/raidgroup_shr-switch_shr.png"></p>

<p align="center">Switch to RAID Group</p>
<p align="center"><img src="/images/raidgroup_shr-switch_raidgroup.png"></p>

<p align="center">Restore from the backup</p>
<p align="center"><img src="/images/raidgroup_shr-switch_restored.png"></p>


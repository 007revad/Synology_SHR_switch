# Synology RAID-F1 SHR switch

<a href="https://github.com/007revad/Synology_RAID-F1_SHR_switch/releases"><img src="https://img.shields.io/github/release/007revad/Synology_RAID-F1_SHR_switch.svg"></a>
<a href="https://hits.seeyoufarm.com"><img src="https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2F007revad%2FSynology_RAID-F1_SHR_switch&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=hits&edge_flat=false"/></a>
[![](https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=%23fe8e86)](https://github.com/sponsors/007revad)

### Description

Easily switch between SHR and RAID F1

This script allows you to switch from SHR to RAID F1, or from RAID F1 to SHR. It backs up the synoinfo.conf first, so you can restore it later if needed.

**Notes:** 

1. You need 3 or more SSD drives to be able to user RAID F1.

2. Changing to RAID F1 disables SHR, and changing to SHR disables RAID F1. 
    - I would ***not*** change from SHR to RAID F1 if you already have a storage pool containg data setup as SHR.
    - I would ***not*** change from RAID F1 to SHR if you already have a storage pool containg data setup as RAID F1.

### What is RAID F1

RAID F1 is Synology's RAID 5 for all flash (SSD) storage pools that tries to ensure that multiple SSD drives don't reach the end of thier life at the same time. F stands for flash, and 1 stands for 1-disk resiliency and 1-parity.

See Synology's <a href="https://global.download.synology.com/download/Document/Software/WhitePaper/Firmware/DSM/All/enu/Synology_RAID_F1_WP.pdf">RAID F1 whitepaper</a>

Also see: <a href="https://www.insight.com/en_US/content-and-resources/2017/01112017-rethinking-raid-in-all-flash-environments.html">Synology RAID F1: Rethinking RAID in all-Flash Environments</a>

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

<p align="center">Switch to RAID F1</p>
<p align="center"><img src="/images/raidf1_shr-switch_raidf12.png"></p>

<p align="center">Switch to SHR</p>
<p align="center"><img src="/images/raidf1_shr-switch_shr.png"></p>

<p align="center">Restore from the backup</p>
<p align="center"><img src="/images/raidf1_shr-switch_restored2.png"></p>

<p align="center">Check currently set RAID type</p>
<p align="center"><img src="/images/raidf1_shr-switch_check.png"></p>

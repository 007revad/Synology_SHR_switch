# Synology SHR switch

<a href="https://github.com/007revad/Synology_SHR_switch/releases"><img src="https://img.shields.io/github/release/007revad/Synology_SHR_switch.svg"></a>
<a href="https://hits.seeyoufarm.com"><img src="https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2F007revad%2FSynology_RAID-F1_SHR_switch&count_bg=%2379C83D&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=views&edge_flat=false"/></a>
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.com/paypalme/007revad)
[![](https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=%23fe8e86)](https://github.com/sponsors/007revad)
[![committers.top badge](https://user-badge.committers.top/australia/007revad.svg)](https://user-badge.committers.top/australia/007revad)

### Description

Easily switch between SHR and RAID Groups, or enable RAID-F1

- Allows you to enable RAID-F1 on Synology consumer NAS models that don't have RAID-F1 as an option.
  - Like a [DS1821+ with 3 NVMe drives in RAID-F1](/images/ds1821_3nvme_raidf1.png).
- Allows you to switch between SHR and RAID Groups.  
- The script backs up the original settings so it can restore them later if needed.

Note: RAID Groups only support RAID 5, RAID 6 and RAID F1

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

<p align="center">DS1821+ with RAID-F1</p>
<p align="center"><img src="/images/raidf1-2.png"></p>

<p align="center">Check currently set RAID type</p>
<p align="center"><img src="/images/check_raidf1.png"></p>

<p align="center">Enable RAID-F1</p>
<p align="center"><img src="/images/enable_raidf1.png"></p>

<p align="center">Switch to SHR</p>
<p align="center"><img src="/images/raidgroup_shr-switch_shr3.png"></p>

<p align="center">Switch to RAID Groups</p>
<p align="center"><img src="/images/raidgroup_shr-switch_raidgroup3.png"></p>

<p align="center">Restore from the backup</p>
<p align="center"><img src="/images/raidgroup_shr-switch_restored3.png"></p>


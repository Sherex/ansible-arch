# Ansible Arch
A playbook for installing and configuring my Arch devices.

## TODO
### Initial configuration from archiso
- Manual steps (use bash script?):
  - `git clone https://github.com/Sherex/ansible-arch`
  - `pacman -Sy python3 ansible`
  - Configure `group_vars/vars.yml` and `group_vars/vault.yml`
  - `ansible-playbook site.yml`
- [ ] Check if hostname is `archiso`
- [ ] Check if boot mode is UEFI
- [ ] Connect to internet
  - [ ] Config option for Wifi
  - [ ] Ethernet is automatic?
- [ ] Update clock
- [ ] Setup filesystem (BTRFS)
  - Filesystem root has
    - `/subvolumes/{root,home}` - Containing subvolumes
    - `/snapshots/{root,home}/$(iso8601 date)` - Containing snapshots of the subvolumes (used by snapper)
- [ ] Update mirrorlist
- [ ] Pacstrap with essentials
- [ ] Create fstab
  - Get partition UUIDs from fdisk's (or script version (sdisk?)) output
  - Mount `root` subvolume as `/`
  - Mount `home` subvolume as `/home/sherex`
- [ ] Set timezone and update time
- [ ] Set and generate localization
- [ ] Set hostname
- [ ] Install GRUB and configure it
- [ ] Instal Ansible and deps
- [ ] Run user role
- [ ] Run sudo role

### Running system configuration
- [ ] GnuPG
  - PGP client
  - `.gnupg` config
- [ ] [Starship](https://github.com/starship/starship) (terminal prompt)
- [ ] [Kanshi](https://sr.ht/~emersion/kanshi/) (Wayland output profiles)


## Usage
### Prerequisites
- 

```bash
git clone https://github.com/Sherex/ansible-arch

cd ansible-arch

ansible ansible-galaxy install -r requirements.yml

# TODO: Store vault on server and automate retrieval
# TODO: Create vault yaml template
# Transfer/create ansible-vault to/at ./group_vars/vault

ansible-playbook --ask-vault-pass site.yml
```
# Bazzite

[Bazzite](https://bazzite.gg/) The next generation of Linux gaming.

My goal is to get off of Windows 11 before Windows Copilot, Windows Recall and Windows Live accounuts are ubiquitous and can't be removed/avoided. Also when will WaaS (Windows as a Service) be a thing?

First get my laptop converted to the point where I don't need to use my PC, then convert my PC.
* Framework officially supports [Bazzite](https://knowledgebase.frame.work/en_us/officially-supported-vs-compatible-linux-distributions-ByVPFgyTs)
    > This has been the best out of box laptop experiance I've ever had. Everything worked, including a docking station
* PC has a GTX Nvidia card
    > Not clear if GTX is supported officially, as it seems related distos focus on Radeon and RTX.

## Install

1. Disable BIOS SecureBoot temporarily (I don't trust VenToy)
1. Installer
    1. LUKS
        > Sure, why not
    1. BTRFS
        > Yes please
1. Reboot
1. Enable Secure boot
    > Might not have to do this, I think I was prompted on the 1st boot to enroll the key, but I still had my VenToy USB drive attached and I explicity skipped it
    1. Run ```ujust enroll-secure-boot-key```
    1. Run ```reboot```
    1. Enroll key
    1. Enable BIOS Secure Boot
1. LUKS
    1. Run ~~```ujust setup-luks-tpm-unlock```~~
        > I don't think so. What is the point of having an encrypted drive if the key to unlock the drive is lost with the drive?

## OS

### Game Volume

* If single disk

    ```bash
    sudo rmdir /var/games
    sudo btrfs subvolume create /var/games
    ```

* If additional disk

  With a 2 drive system and letting bazzite installer auto allocate drives, seemed to cause me issues. I had 1 BTRFS volume using both drives. Drive performance was horrible.

  Undo combined volume:

    * 512GB nvme
    * 2TB HDD and this is a cheap slow HDD.

        Validate some BTRFS settings and making sure there is enough space on the 512GB nvme

        ```bash
        sudo btrfs filesystem show
        sudo btrfs filesystem df /var
        sudo btrfs filesystem usage /var
        ```

        Undo the RAID1 volume ```Metadata``` and ```System```

        ```bash
        sudo btrfs balance start -dconvert=single -mconvert=single -sconvert=single -f /var
        ```

        Remove the device

        ```bash
        sudo btrfs device remove /dev/mapper/luks-abcd
        ```

    Setup new device

    ```bash
    sudo wipefs -a /dev/mapper/luks-abcd
    sudo mkfs.btrfs -L data /dev/mapper/luks-abcd
    ```

    Mount can create subvolume

    ```bash
    sudo mount /dev/mapper/luks-abcd /var/games
    sudo btrfs subvolume create /var/games/games
    sudo umount /var/games
    sudo btrfs filesystem show # Get the uuid of the data partition
    sudo vi /etc/fstab # Add entry
    sudo mount /var/games
    # does it make sense to have nested subvolumes, I don't know, lets find out.
    sudo btrfs subvolume create /var/games/steam
    sudo btrfs subvolume create /var/games/lutris
    sudo vi /etc/fstab # Add entries
    sudo mount /var/games/lutris
    sudo mount /var/games/steam
    sudo chattr +C /var/games/steam # Disable CoW
    ```


Add users to games group using [work around](https://docs.fedoraproject.org/en-US/fedora-silverblue/troubleshooting/#_unable_to_add_user_to_group).

```bash
# add games group settings to /etc/group
grep -E '^games:' /usr/lib/group | sudo tee -a /etc/group
# add games group to all users
for user in $(cat /etc/passwd | cut -d: -f1);
do
    sudo usermod -a -G games $user
done

# use facls to maintaining games access to /var/games/steam
sudo setfacl -m g:games:rwx /var/games/steam
sudo setfacl -m g:games:rwx -d /var/games/steam
```

The intent is to be able to share as much of the Game installs as possible for a multi user PC. This should be doable with [Steam](#steam), but not for [Lutris](#lutris). Wine only allows a prefix to be run by the owner. So I'm going to try to rely on BTRFS dedupliction to save on disk space.

* /var/games
   * steam
        * game A
        * game B
        * game C
   * lutris
        * userA
            * battlenet
            * gog-galaxy
        * user B
            * battlenet
            * gog-galaxy



## Apps

Kinda confusing with all the layers of abstraction possible. Here is what Bazzite [suggests to manage software](https://docs.bazzite.gg/Installing_and_Managing_Software/)

Flatpacks and Distrobox both make the $HOME folder available from the host to the sand box. Flatpacks and Distrobox have different $PATH variables than the host.

Subheadings are in ranked order

Subheadings are in ranked order

### FlatPaks

[Flatpak](https://docs.bazzite.gg/Installing_and_Managing_Software/Flatpak/) - Universal package format using a permissions-based model and should be used for most graphical applications. Parallell to Android or IOS apps.

```bash
flatpak install com.brave.Browser
flatpak install com.google.Chrome
flatpak install com.makemkv.MakeMKV
flatpak install com.visualstudio.code
flatpak install fr.handbrake.ghb
flatpak install org.kde.gcompris
flatpak install org.keepassxc.KeePassXC
flatpak install org.libretro.RetroArch
```

#### Signal

* Store the database key encrypted in [kwallet6](https://github.com/flathub/org.signal.Signal?tab=readme-ov-file#options)
* Grant Signall access to [session-bus](https://docs.flatpak.org/en/latest/sandbox-permissions.html) to communicate to kwallet6

```bash
flatpak install org.signal.Signal
sudo flatpak override --env=SIGNAL_PASSWORD_STORE=kwallet6 --socket=session-bus org.signal.Signal
```

#### Visual Studio Code

Run commands on the host from inside the sandbox using [Shell Integrated Terminal](https://github.com/flathub/com.visualstudio.code?tab=readme-ov-file#use-host-shell-in-the-integrated-terminal)

Support for [SDKs](https://github.com/flathub/com.visualstudio.code?tab=readme-ov-file#support-for-language-extension) on the host system
* helm TODO 📝
* kubectl TODO 📝
* Powershell TODO 📝
* Python TODO 📝

### ujust

```shell
ujust bazzite-cli
# Enable BTRFS Snapshots
ujust configure-snapshots
# Enable BTRFS Dedup
just enable-deduplication
# Enable SSH
ujust toggle-ssh enable
# Enable Wake-on-LAN
ujust toggle-wol enable
```

### Homebrew

[Homebrew](https://docs.bazzite.gg/Installing_and_Managing_Software/Homebrew/) - Install applications intended to run inside of the terminal (CLI/TUI).
Parallell to homebrew on Mac OS X.

```bash
brew install ansible
brew isntall dysk
brew install kubecolor
brew install kubernetes-cli
brew install ncdu
brew install python@3.13
brew isntall sqlite
brew install wakeonlan
```

#### syncthing

Mesh file sync utility. Bazzite Portal tries to confince you to install Resilio Sync, a free product that requires registration and licensing... no thanks.

Currently I'm running with brew, looking to convert a container running in podman.

```shell
brew install syncthing
brew services start syncthing
```

Works well with KeePassXC, can have client open on multiple machines and after syncthing sync, KeePassXC detects the file change and reloads the file.

### Quadlet

### Distorbox

[Distrobox](https://docs.bazzite.gg/Installing_and_Managing_Software/Distrobox/) - Access to most Linux package managers for software that do not support Flatpak and Homebrew and for use as development boxes.
Parallell to WSL.
> Using for python scripts where libraries aren't installed locally and no compatilbe wheel files available via pip. Kinda annoying I need another environment to maintain, kinda nice that it doesn't pollute my main distro.

### AppImage

### rpm-ostree

## Gaming

### Steam

* Enable All Steam Games
   > Steam > Settings > Compatibility
    * Enable Steam Play for all other titles
    * Run other titles with ```Proton - Experimental```
* Move Storage
    > Defaults to ```~/.local/share/Steam```, create a [BTRFS sub volume for games](#game-volume) to share across user profiles?

    TODO 📝

### Lutris

Some games seem to work better with [Steam's](#steam) ```Proton - Experimental```. To get the ```Proton - Experimental```, you need to install a [Steam](#steam) game that requires it. For me it was ```AoE 4```.

#### Blizard Games

Used the [json](https://lutris.net/api/installers/battlenet-standard?format=json) file from [lutris](https://lutris.net/games/battlenet/).

The installation will look like it froze, hang in there, the installation will eventually fail, don't fret, it'll be fixed in the next step.

Use the ```Run EXE inside Wine prefix``` and re-ran the installer found in ```drive_c\Battle.net-Setup.exe```. Continue the installation.

Was able to login, however getting an [BLZBNTBNA00000005](https://us.battle.net/support/en/article/16531) error message while using ```GE-Proton```. Try ```Proton - Experimental```.

> Game > Configure > Runner options > Wine version > Proton - Experimental

#### GOG

Used the [json](https://lutris.net/api/installers/gog-galaxy-windows?format=json) file from [lutris](https://lutris.net/games/gog-galaxy/).

#### Open Rails

The game engine loads, but launching into a scenario fails. M$XDA error about not being able to finding dependencies

[Forum post](https://forums.lutris.net/t/open-rails-anyone/20998)

Running winetricks from Lutris throws odd errors.

Can't figure out how to get winetricks to work from cli.

### Epic Games

TODO 📝 I don't think i have an Epic Games account

### Riot Games

TODO 📝

### Emulators
 > Discover > RetroArch

# Bazzite

[Bazzite](https://bazzite.gg/) The next generation of Linux gaming.

My goal is to get off of Windows 11 before Windows Copilot, Windows Recall Windows Live accounuts are ubiquitous and can't be removed/avoided.

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

## Apps

Kinda confusing with all the layers of abstraction possible. Here is what Bazzite [suggests to manage software](https://docs.bazzite.gg/Installing_and_Managing_Software/)

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
flatpak install org.signal.Signal
```

#### Signal

Don't store the database key in [kwallet6](https://github.com/flathub/org.signal.Signal?tab=readme-ov-file#options)

```bash
sudo flatpak override --env=SIGNAL_PASSWORD_STORE=kwallet6 org.signal.Signal
```

#### Visual Studio Code

Run commands on th host from inside the sandbox using [Shell Integrated Terminal](https://github.com/flathub/com.visualstudio.code?tab=readme-ov-file#use-host-shell-in-the-integrated-terminal)

### Homebrew

[Homebrew](https://docs.bazzite.gg/Installing_and_Managing_Software/Homebrew/) - Install applications intended to run inside of the terminal (CLI/TUI).
Parallell to homebrew on Mac OS X.

```bash
brew install ansible
brew install kubecolor
brew install kubernetes-cli
brew install python@3.13
bbew install wakeonlan
```

### Distorbox

[Distrobox](https://docs.bazzite.gg/Installing_and_Managing_Software/Distrobox/) - Access to most Linux package managers for software that do not support Flatpak and Homebrew and for use as development boxes.
Parallell to WSL.
> Using for python scripts where libraries aren't installed locally and no compatilbe wheel files available via pip. Kinda annoying I need another environment to maintain, kinda nice that it doesn't pollute my main distro.

## Gaming

### Steam

* Enable All Steam Games
   > Steam > Settings > Compatibility 
* Move Storage
    > Defaults to ```~/.local/share/Steam```, create a BTRFS sub volume for games to share across user profiles?

    TODO

### Lutris

TODO

### Epic Games

TODO

### GOG

TODO

### Blizard Games

TODO

### Emulators
 > Discover > RetroArch
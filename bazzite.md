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

Flatpacks and Distrobox both make the $HOME folder available from the host to the sand box. Flatpacks and Distrobox have different $PATH variables than the host.

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

* Store the database key encrypted in [kwallet6](https://github.com/flathub/org.signal.Signal?tab=readme-ov-file#options)
* Grant Signall access to [session-bus](https://docs.flatpak.org/en/latest/sandbox-permissions.html) to communicate to kwallet6

```bash
sudo flatpak override --env=SIGNAL_PASSWORD_STORE=kwallet6 --socket=session-bus org.signal.Signal
```

#### Visual Studio Code

Run commands on the host from inside the sandbox using [Shell Integrated Terminal](https://github.com/flathub/com.visualstudio.code?tab=readme-ov-file#use-host-shell-in-the-integrated-terminal)

Support for [SDKs](https://github.com/flathub/com.visualstudio.code?tab=readme-ov-file#support-for-language-extension) on the host system
* helm TODO 📝
* kubectl TODO 📝
* Powershell TODO 📝
* Python TODO 📝

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

### Distorbox

[Distrobox](https://docs.bazzite.gg/Installing_and_Managing_Software/Distrobox/) - Access to most Linux package managers for software that do not support Flatpak and Homebrew and for use as development boxes.
Parallell to WSL.
> Using for python scripts where libraries aren't installed locally and no compatilbe wheel files available via pip. Kinda annoying I need another environment to maintain, kinda nice that it doesn't pollute my main distro.

## Gaming

### Steam

* Enable All Steam Games
   > Steam > Settings > Compatibility
    * Enable Steam Play for all other titles
    * Run other titles with ```Proton Experimental```
* Move Storage
    > Defaults to ```~/.local/share/Steam```, create a BTRFS sub volume for games to share across user profiles?

    TODO 📝

### Lutris

#### Blizard Games

Used the [json](https://lutris.net/api/installers/battlenet-standard?format=json) file from [lutris](https://lutris.net/games/battlenet/).

The installation will look like it froze, hang in there, the installation will eventually fail, don't fret.

Use the ```Run EXE inside Wine prefix``` and re-ran the installer found in ```drive_c\Battle.net-Setup.exe```. Continue the installation.

Was able to login, however getting an [BLZBNTBNA00000005](https://us.battle.net/support/en/article/16531) error message while using ```GE-Proton```.

I have no idea how I got Lutris to run Proton Experimental, I thought it was this, but it definelty is not. The symlink was broken.

> ~~Create a symlink to Proton from Steam[*](https://forums.lutris.net/t/using-proton-with-lutris/3846/3)~~
> 
> ```bash
> #ln -s $HOME/.steam/steam/steamapps/common/Proton*/dist $HOME/.local/share/lutris/runners/wine/proton
> ```
> 
> ~~Then update the game runner to use Proton Experimental~~

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
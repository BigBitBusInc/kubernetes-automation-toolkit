## Setup Vagrant on Windows

1. Install `VirtualBox`. Vagrant requires VirtualBox to create Virtual Machine. Navigate to https://www.virtualbox.org/wiki/Downloads to Download Virtual Box. Alternatively, if you have [HyperV enabled on your Windows PC](https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v) then you can use this instead of VirtualBox. Note that HyperV is not available on the "Home" edition of Windows 10.

2. Install `Vagrant`. Navigate to https://www.vagrantup.com/downloads to download latest version of Vagrant.

3. Install `Putty`. Navigate to https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html to download latest version of putty.


## Setup Vagrant on Mac

1. Install `Virtual box` using [direct download](https://www.virtualbox.org/wiki/Downloads) or use homebrew for installing it.<br/> `brew install virtualbox --cask`

2. Install `Vagrant` using [direct download](https://www.vagrantup.com/downloads.html) or use homebrew for installing it.<br/> `brew install vagrant --cask`


## Setup Vagrant on Linux
1. Install `Virtual box` by running: <br> `sudo apt update` <br> `sudo apt install virtualbox`

2. Download `Vagrant` Package with wget: <br> `curl -O https://releases.hashicorp.com/vagrant/2.2.14/vagrant_2.2.14_x86_64.deb`

3. Install Downloaded File by typing: <br> `sudo apt install ./vagrant_2.2.14_x86_64.deb`

4. Verify installation using: <br> `vagrant --version`

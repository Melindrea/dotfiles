# Ubuntu-only stuff. Abort if not Ubuntu.
[[ "$(cat /etc/issue 2> /dev/null)" =~ Ubuntu ]] || return 1

# VirtualBox
sudo sh -c "echo 'deb http://download.virtualbox.org/virtualbox/debian '$(lsb_release -cs)' contrib non-free' > /etc/apt/sources.list.d/virtualbox.list" && wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | sudo apt-key add -

# partner repository
sudo add-apt-repository "deb http://archive.canonical.com/ $(lsb_release -sc) partner"

# Spotify
sudo apt-add-repository -y "deb http://repository.spotify.com stable non-free"
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 94558F59

# VLC
sudo add-apt-repository -y ppa:videolan/stable-daily

#GIMP
sudo add-apt-repository -y ppa:otto-kesselgulasch/gimp

# Gnome3 packages
sudo add-apt-repository -y ppa:gnome3-team/gnome3

# Sublime Text
sudo add-apt-repository -y ppa:webupd8team/sublime-text-3

# LibDVDCSS
echo 'deb http://download.videolan.org/pub/debian/stable/ /' | sudo tee -a /etc/apt/sources.list.d/libdvdcss.list &&
echo 'deb-src http://download.videolan.org/pub/debian/stable/ /' | sudo tee -a /etc/apt/sources.list.d/libdvdcss.list &&
wget -O - http://download.videolan.org/pub/debian/videolan-apt.asc|sudo apt-key add -

# Dropbox
sudo apt-key adv --keyserver pgp.mit.edu --recv-keys 5044912E
sudo sh -c 'echo "deb http://linux.dropbox.com/ubuntu/ $(lsb_release -cs) main" >> /etc/apt/sources.list.d/dropbox.list'

# Ubuntu-Tweak
sudo add-apt-repository -y ppa:tualatrix/ppa

# Update APT.
e_header "Updating APT"
sudo dpkg --add-architecture i386
sudo apt-get -qq update
sudo apt-get -qq dist-upgrade

# Install APT packages.
packages=(
  build-essential libssl-dev openssl sshfs
  python-dev libxml2-dev libxslt1-dev
  apache2 mysql-server
  php5 php5-cli php5-mysql php5-mcrypt php5-xsl php5-curl sqlite php5-sqlite
  virtualbox-4.3 dkms
  skype
  gimp gimp-data gimp-plugin-registry gimp-data-extras
  vim
  spotify-client
  vlc libxine1-ffmpeg mencoder flac faac faad sox ffmpeg2theora libmpeg2-4 uudeview libmpeg3-1 mpeg3-utils mpegdemux liba52-dev mpeg2dec vorbis-tools id3v2 mpg321 mpg123 libflac++6 totem-mozilla icedax lame libmad0 libjpeg-progs libdvdcss2 libdvdread4 libdvdnav4 libswscale-extra-2 ubuntu-restricted-extras
  unace unrar zip unzip p7zip-full p7zip-rar sharutils rar uudeview mpack arj cabextract file-roller
  openjdk-7-jre
  flashplugin-installer
  virt-manager qemu-system
  texlive-full
  dropbox python-gpgme
  ubuntu-tweak
  sublime-text-installer
  conky-all lm-sensors
)

list=()
for package in "${packages[@]}"; do
  if [[ ! "$(dpkg -l "$package" 2>/dev/null | grep "^ii  $package")" ]]; then
    list=("${list[@]}" "$package")
  fi
done

if (( ${#list[@]} > 0 )); then
  e_header "Installing APT packages: ${list[*]}"
  for package in "${list[@]}"; do
    sudo apt-get -qq install "$package"
  done
fi

# Chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb &&
  sudo dpkg -i google-chrome-stable_current_amd64.deb &&
  rm -f google-chrome-stable_current_amd64.deb

# Scrivener
wget http://www.literatureandlatte.com/scrivenerforlinux/scrivener-1.7.2.3-amd64.deb &&
  sudo dpkg -i scrivener-1.7.2.3-amd64.deb &&
  rm -f scrivener-1.7.2.3-amd64.deb

# Vagrant
wget https://dl.bintray.com/mitchellh/vagrant/vagrant_1.6.3_x86_64.deb &&
  sudo dpkg -i vagrant_1.6.3_x86_64.deb &&
  rm -f vagrant_1.6.3_x86_64.deb

# Source Code Pro font
curl -L https://gist.githubusercontent.com/lucasdavila/3875946/raw/f62c8a26ad6648b00cd379704617d0b61338f59f/install_source_code_pro.sh | sh

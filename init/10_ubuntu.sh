# Ubuntu-only stuff. Abort if not Ubuntu.
[[ "$(cat /etc/issue 2> /dev/null)" =~ Ubuntu ]] || return 1

# VirtualBox
sudo sh -c "echo 'deb http://download.virtualbox.org/virtualbox/debian '$(lsb_release -cs)' contrib non-free' > /etc/apt/sources.list.d/virtualbox.list" && wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | sudo apt-key add -

# partner repository
sudo add-apt-repository "deb http://archive.canonical.com/ $(lsb_release -sc) partner"

# Update APT.
e_header "Updating APT"
sudo dpkg --add-architecture i386
sudo apt-get -qq update
sudo apt-get -qq dist-upgrade

# Install APT packages.
packages=(
  python-software-properties
  build-essential libssl-dev openssl
  python-dev libxml2-dev libxslt1-dev
  apache2 mysql-server
  php5 php5-cli php5-mysql php5-mcrypt php5-xsl php5-curl sqlite php5-sqlite
  virtualbox-4.3 dkms
  skype
  gimp
  vim
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

# Check if it exists?
sudo dpkg -i http://www.literatureandlatte.com/scrivenerforlinux/scrivener-1.6.1.1-beta.deb
echo "Don't forget to install Vagrant: http://vagrantup.com/downloads.html\n"
echo "Don't forget to install Sublime Text: http://www.sublimetext.com/3\n"
echo "Update the editor using: sudo update-alternatives –config editor option: vim.basic or vim\n"

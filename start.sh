#!/bin/bash -x
clear
profile=$(gsettings get org.gnome.Terminal.ProfilesList default)
profile=${profile:1:-1} # remove leading and trailing single quotes
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" login-shell true
#export DEBIAN_FRONTEND=noninteractive
# Exit on error
# set -o errexit

# Here's inverted commilla just in case `
if [[ -s "$HOME/.rvm/scripts/rvm" ]] ; then
  # First try to load from a user install
  source "$HOME/.rvm/scripts/rvm"
elif [[ -s "/usr/local/rvm/scripts/rvm" ]] ; then
  # Then try to load from a root install
  source "/usr/local/rvm/scripts/rvm"
fi

rails -v 2> /dev/null | grep -iq rails
if [[ $? -ne 0 ]]; then
  echo 'Installing Rails'
  echo progress-bar > ~/.curlrc
  gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
  \curl -sSL https://get.rvm.io | bash -s stable --ruby --rails
fi

if [[ -s "$HOME/.rvm/scripts/rvm" ]] ; then
  # First try to load from a user install
  source "$HOME/.rvm/scripts/rvm"
elif [[ -s "/usr/local/rvm/scripts/rvm" ]] ; then
  # Then try to load from a root install
  source "/usr/local/rvm/scripts/rvm"
else
  echo "ERROR: An RVM installation was not found.\n"
  exit 1
fi

ruby_latest=$(curl 'http://ftp.ruby-lang.org/pub/ruby/' 2> /dev/null | ruby -e "puts STDIN.each_line.map { |x| /ruby-\d\.\d\.\d/.match(x) }.compact.last")

rvm install $ruby_latest --default
# rvm use $ruby_latest
if ! grep -Fxq "gem: --no-ri --no-rdoc" ~/.gemrc; then
  echo "gem: --no-ri --no-rdoc" >> ~/.gemrc
fi
gem install bundler
gem update

exit $?
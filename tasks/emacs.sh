#apt remove -y --autoremove emacs emacs-common

sudo apt install -y emacs-gtk
sudo apt install -y ripgrep fd-find

rm -rf /home/"$USER"/.emacs.d/
git clone https://github.com/hlissner/doom-emacs ~/.emacs.d

echo "export PATH=$PATH:$HOME/.emacs.d/bin" >> ~/.bash_profile
source ~/.bash_profile

doom install
doom doctor

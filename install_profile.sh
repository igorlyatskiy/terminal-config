# Fail on any command.
set -eux pipefail

# Install plug-ins (you can git-pull to update them later).
(cd ~/.oh-my-zsh/custom/plugins && git clone https://github.com/zsh-users/zsh-syntax-highlighting)
(cd ~/.oh-my-zsh/custom/plugins && git clone https://github.com/zsh-users/zsh-autosuggestions)

# Replace the configs with the saved one.
sudo cp configs/.zshrc ~/.zshrc

# Copy the modified Agnoster Theme
sudo cp configs/igorlyatskiy-agnoster.zsh-theme ~/.oh-my-zsh/themes/igorlyatskiy-agnoster.zsh-theme

# Color Theme
dconf load /org/gnome/terminal/legacy/profiles:/:23a69c98-8a21-4dea-896c-458745bf40c3/ < configs/terminal_profile.dconf

# Add it to the default list in the terminal
add_list_id=23a69c98-8a21-4dea-896c-458745bf40c3
old_list=$(dconf read /org/gnome/terminal/legacy/profiles:/list | tr -d "]")

if [ -z "$old_list" ]
then
	front_list="["
else
	front_list="$old_list, "
fi

new_list="$front_list'$add_list_id']"
dconf write /org/gnome/terminal/legacy/profiles:/list "$new_list" 
dconf write /org/gnome/terminal/legacy/profiles:/default "'$add_list_id'"

# Switch the shell.
chsh -s $(which zsh)

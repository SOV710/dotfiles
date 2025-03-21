# install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# install go
wget https://go.dev/dl/go1.24.1.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.24.1.linux-amd64.tar.gz
rm go1.24.1.linux-amd64.tar.gz

# install fish
sudo apt-add-repository ppa:fish-shell/release-4
sudo apt update
sudo apt install fish

# install zoxide
cargo install zoxide --locked

# install starship
cargo install starship --locked

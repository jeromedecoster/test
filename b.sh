rm -fr /tmp/dots
mkdir -p /tmp/dots
cd /tmp/dots
wget -qO- https://github.com/jeromedecoster/test/archive/master.tar.gz | tar xz --strip 1

sudo rm -fr /usr/local/lib/dots
sudo cp -R /tmp/dots /usr/local/lib/dots

ls -1 /usr/local/lib/dots/bin | while read file; do
  sudo rm -f /usr/local/bin/$file
  sudo ln -s /usr/local/lib/dots/bin/$file /usr/local/bin/$file
done

ls -A1 /usr/local/lib/dots/user | while read file; do
  test -L ~/$file && rm -f ~/$file
  ln -s /usr/local/lib/dots/user/$file ~/$file 2>/dev/null
done

cat ~/.bashrc | grep -q "source ~/.bash_profile" || echo "source ~/.bash_profile" >> ~/.bashrc

sudo chown -R `whoami` /usr/local/lib/dots

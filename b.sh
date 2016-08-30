rm -fr /tmp/dots
mkdir -p /tmp/dots
cd /tmp/dots
wget -qO- https://github.com/jeromedecoster/test/archive/master.tar.gz | tar xz --strip 1

sudo rm -fr /usr/local/lib/dots
sudo cp -R /tmp/dots /usr/local/lib/dots

ls -1 /usr/local/lib/dots/bin | while read file; do
  rm -f /usr/local/bin/$file
  ln -s /usr/local/lib/dots/bin/$file /usr/local/bin/$file
done

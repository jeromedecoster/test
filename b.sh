rm -fr /tmp/dots
mkdir -p /tmp/dots
cd /tmp/dots
wget -qO- https://github.com/jeromedecoster/test/archive/master.tar.gz | tar xvz --strip 1
sudo cp -R /tmp/dots /usr/local/lib/dots

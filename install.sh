#!/bin/bash -x
# <udf name="blender_version" label="Choose the desired Blender version"
#      oneOf="v2.69,v2.70,v2.70a,v2.71,v2.72a,v2.72b,v2.75a,v2.76,2.78c,2.79" default="v2.79">
# <udf name="blender_site" label="Choose the site you would like to download Blender from"
#      oneOf="http://ftp.halifax.rwth-aachen.de/blender,http://download.blender.org">
# <udf name="bitwrk_branch" label="Choose the branch of BitWrk to run"
#      oneOf="master,experimental" default="master">
# <udf name="bitwrk_privkey" label="Set the desired Bitwrk private key in WIF format or leave empty to generate a new identity." default="">
BLENDER_VERSION=${BLENDER_VERSION-v2.79}
BLENDER_SITE=${BLENDER_SITE-http://ftp.halifax.rwth-aachen.de/blender}
BITWRK_BRANCH=${BITWRK_BRANCH-master}
if [[ -f ~bitwrk/.bitwrk-client/privatekey.wif ]]; then
  old_bitwrk_privkey=$(cat ~bitwrk/.bitwrk-client/privatekey.wif)
fi
BITWRK_PRIVKEY=${BITWRK_PRIVKEY-$old_bitwrk_privkey}
# source <ssinclude StackScriptID=1>
die() {
  echo ERROR $@
  sleep 30
  exit 1
}
export DEBIAN_FRONTEND=noninteractive
apt-get update && apt-get -y install blender git mercurial curl atop sysbench bzip2 python3 psmisc
#echo "deb http://ftp.us.debian.org/debian jessie main" >> /etc/apt/sources.list
echo "Disabling IPv6"
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
echo "net.ipv6.conf.all.disable_ipv6 = 1" > /etc/sysctl.d/01-disable-ipv6.conf
cd /opt
[[ -h blender ]] && rm blender
if [[ "$BLENDER_VERSION" = "v2.69" ]]; then
  wget $BLENDER_SITE/release/Blender2.69/blender-2.69-linux-glibc211-x86_64.tar.bz2
  tar xjf blender-2.69-linux-glibc211-x86_64.tar.bz2
  ln -s blender-2.69-linux-glibc211-x86_64/ blender
  articleprefix="net.bitwrk/blender/0/2.69"
elif [[ "$BLENDER_VERSION" = "v2.70" ]]; then
  wget $BLENDER_SITE/release/Blender2.70/blender-2.70-linux-glibc211-x86_64.tar.bz2
  tar xjf blender-2.70-linux-glibc211-x86_64.tar.bz2
  ln -s blender-2.70-linux-glibc211-x86_64/ blender
  articleprefix="net.bitwrk/blender/0/2.70"
elif [[ "$BLENDER_VERSION" = "v2.70a" ]]; then
  wget $BLENDER_SITE/release/Blender2.70/blender-2.70a-linux-glibc211-x86_64.tar.bz2
  tar xjf blender-2.70a-linux-glibc211-x86_64.tar.bz2
  ln -s blender-2.70a-linux-glibc211-x86_64/ blender
  articleprefix="net.bitwrk/blender/0/2.70"
elif [[ "$BLENDER_VERSION" = "v2.71" ]]; then
  wget $BLENDER_SITE/release/Blender2.71/blender-2.71-linux-glibc211-x86_64.tar.bz2
  tar xjf blender-2.71-linux-glibc211-x86_64.tar.bz2
  ln -s blender-2.71-linux-glibc211-x86_64/ blender
  articleprefix="net.bitwrk/blender/0/2.71"
elif [[ "$BLENDER_VERSION" = "v2.72a" ]]; then
  wget $BLENDER_SITE/release/Blender2.72/blender-2.72a-linux-glibc211-x86_64.tar.bz2
  tar xjf blender-2.72a-linux-glibc211-x86_64.tar.bz2
  ln -s blender-2.72a-linux-glibc211-x86_64/ blender
  articleprefix="net.bitwrk/blender/0/2.72"
elif [[ "$BLENDER_VERSION" = "v2.72b" ]]; then
  wget $BLENDER_SITE/release/Blender2.72/blender-2.72b-linux-glibc211-x86_64.tar.bz2
  tar xjf blender-2.72b-linux-glibc211-x86_64.tar.bz2
  ln -s blender-2.72b-linux-glibc211-x86_64/ blender
  articleprefix="net.bitwrk/blender/0/2.72"
elif [[ "$BLENDER_VERSION" = "v2.75a" ]]; then
  wget $BLENDER_SITE/release/Blender2.75/blender-2.75a-linux-glibc211-x86_64.tar.bz2
  tar xjf blender-2.75a-linux-glibc211-x86_64.tar.bz2
  ln -s blender-2.75a-linux-glibc211-x86_64/ blender
  articleprefix="net.bitwrk/blender/0/2.75"
elif [[ "$BLENDER_VERSION" = "v2.76" ]]; then
  wget -c $BLENDER_SITE/release/Blender2.76/blender-2.76-linux-glibc211-x86_64.tar.bz2
  tar xjf blender-2.76-linux-glibc211-x86_64.tar.bz2
  ln -s blender-2.76-linux-glibc211-x86_64/ blender
  articleprefix="net.bitwrk/blender/0/2.76"
elif [[ "$BLENDER_VERSION" = "v2.78c" ]]; then
  wget -c $BLENDER_SITE/release/Blender2.78/blender-2.78c-linux-glibc219-x86_64.tar.bz2
  tar xjf blender-2.78c-linux-glibc219-x86_64.tar.bz2
  ln -s blender-2.78c-linux-glibc219-x86_64/ blender
  articleprefix="net.bitwrk/blender/0/2.78"
elif [[ "$BLENDER_VERSION" = "v2.79" ]]; then
  wget -c $BLENDER_SITE/release/Blender2.79/blender-2.79-linux-glibc219-x86_64.tar.bz2
  tar xjf blender-2.79-linux-glibc219-x86_64.tar.bz2
  ln -s blender-2.79-linux-glibc219-x86_64/ blender
  articleprefix="net.bitwrk/blender/0/2.79"
else
  die "Unknown blender version $BLENDER_VERSION"
fi
if [[ -d ./go ]]; then
  rm -rf ./go/
fi
#wget -c https://go.googlecode.com/files/go1.2.1.linux-amd64.tar.gz
#wget -c https://storage.googleapis.com/golang/go1.3.3.linux-amd64.tar.gz
#wget -c https://storage.googleapis.com/golang/go1.4.linux-amd64.tar.gz
#wget -c https://storage.googleapis.com/golang/go1.7.5.linux-amd64.tar.gz
#wget -c https://storage.googleapis.com/golang/go1.8.linux-amd64.tar.gz
#wget -c https://redirector.gvt1.com/edgedl/go/go1.9.2.linux-amd64.tar.gz
wget -c https://dl.google.com/go/go1.12.9.linux-amd64.tar.gz
#tar xzf go1.2.1.linux-amd64.tar.gz
#tar xzf go1.3.3.linux-amd64.tar.gz
#tar xzf go1.4.linux-amd64.tar.gz
#tar xzf go1.7.5.linux-amd64.tar.gz
#tar xzf go1.8.linux-amd64.tar.gz
#tar xzf go1.9.2.linux-amd64.tar.gz
tar xzf go1.12.9.linux-amd64.tar.gz
useradd -m -s "/bin/bash" bitwrk
mkdir /var/log/bitwrk
chown bitwrk /var/log/bitwrk
cd ~bitwrk
mkdir -m 700 .bitwrk-client
chown bitwrk:bitwrk .bitwrk-client
if [[ -n "$BITWRK_PRIVKEY" ]]; then
  echo -n "$BITWRK_PRIVKEY" > .bitwrk-client/privatekey.wif
  chown bitwrk:bitwrk .bitwrk-client/privatekey.wif
  chmod 600 .bitwrk-client/privatekey.wif
fi
sed "s|__BITWRK_BRANCH__|$BITWRK_BRANCH|g; s|__ARTICLE_PREFIX__|$articleprefix|g" \
 > update.sh <<'EOF'
#!/bin/bash
set -e
set -x
articleprefix=__ARTICLE_PREFIX__
die() {
  echo "ERROR" $@
  exit 1
}
cd $HOME || die "Homedir not found"
if [ ! -d bitwrk ]; then
  git clone --recursive https://github.com/indyjo/bitwrk.git || die "Cloning failed"
fi
if [[ -n "__BITWRK_BRANCH__" ]]; then
  (cd bitwrk && git checkout "__BITWRK_BRANCH__") || die "Checkout of branch failed"
fi
cd bitwrk
git pull || die "Failed to git pull"
git submodule init && git submodule update || die "Failed to update submodules"
killall bitwrk-client || true
killall python3.5 || true
go=/opt/go/bin/go
export GOROOT=/opt/go
$go clean ./client || die "Failed to execute go clean"
($go build -o ./bitwrk-client ./client/cmd/bitwrk-client) || die "Failed to execute go build"
(nohup ./bitwrk-client -extport 8082 > /var/log/bitwrk/daemon.log 2>&1 &) || die "Failed to launch bitwrk daemon"
sleep 2
serve_blender() {
  id=$1
  cost=$2
  python3.5 blender-slave.py --blender /opt/blender/blender --max-cost $cost >/var/log/bitwrk/blender-$cost-$id.log 2>&1 &
}
grant_mandate() {
  articleid=$1
  price=$2
  curl -F action=permit -F type=SELL -F articleid="$articleid" -F price=$price \
     -F usetradesleft=on -F tradesleft=100000 -F validminutes=10 \
     http://localhost:8081/
}
cd bitwrk-blender/render_bitwrk
serve_blender 1 512M
serve_blender 2 512M
#serve_blender 3 2G
#serve_blender 4 2G
#serve_blender 5 8G
#serve_blender 6 8G
#serve_blender 7 32G
grant_mandate $articleprefix/512M uBTC0
grant_mandate $articleprefix/2G   uBTC26
grant_mandate $articleprefix/8G   uBTC99
grant_mandate $articleprefix/32G  uBTC444
EOF
chmod +x update.sh
su -c "./update.sh" bitwrk
sleep 30

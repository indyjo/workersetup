#!/bin/bash -x
# <udf name="blender_version" label="Choose the desired Blender version"
#      oneOf="v2.69,v2.70,v2.70a,v2.71,v2.72a,v2.72b,v2.75a,v2.76,2.78c,2.79" default="v2.79">
# <udf name="blender_site" label="Choose the site you would like to download Blender from"
#      oneOf="http://ftp.halifax.rwth-aachen.de/blender,http://download.blender.org">
# <udf name="bitwrk_branch" label="Choose the branch of BitWrk to run"
#      oneOf="master,experimental" default="master">
# <udf name="bitwrk_privkey" label="Set the desired Bitwrk private key in WIF format or leave empty to generate a new identity." default="">
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

BLENDER_VERSION=${BLENDER_VERSION-v2.79}
BLENDER_SITE=${BLENDER_SITE-http://ftp.halifax.rwth-aachen.de/blender}
BITWRK_BRANCH=${BITWRK_BRANCH-master}
PRICE=${PRICE-uBTC1}
WORKS_FOR=${WORKS_FOR=1BossYjJLFFXJ4atnQDQR4VLVPJntcqmqN}
EXECUTE=${EXECUTE-y}
KEY_FILE=${KEY_FILE-}

echo "Installing BitWrk from branch $BITWRK_BRANCH using Blender $BLENDER_VERSION"
echo "Blender download site is $BLENDER_SITE"

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

echo "Creating user bitwrk"
useradd -m -s "/bin/bash" bitwrk

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

echo "Generating update.sh"
sed "
s|__BITWRK_BRANCH__|$BITWRK_BRANCH|g
s|__ARTICLE_PREFIX__|$articleprefix|g
s|__PRICE__|$PRICE|g
s|__WORKS_FOR__|$WORKS_FOR|g
s|__KEY_FILE__|$KEY_FILE|g
" > ~bitwrk/update.sh < "$DIR/update.template.sh"

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

chmod +x update.sh

[[ "$EXECUTE" = "y" ]] && su -c "./update.sh" bitwrk


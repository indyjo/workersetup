#!/bin/bash
set -e
set -x
articleprefix="__ARTICLE_PREFIX__"
articlesuffix="512M"
price="__PRICE__"
bitwrk_branch="__BITWRK_BRANCH__"
works_for="__WORKS_FOR__"
key_file="__KEY_FILE__"

die() {
  echo "ERROR" $@
  exit 1
}
cd $HOME || die "Homedir not found"

(for i in {1..120}; do ping -q -c 1 -w 1 bitwrk.appspot.com && break; sleep 1; false; done) || die "Offline"

if [ ! -d bitwrk ]; then
  git clone --recursive https://github.com/indyjo/bitwrk.git || die "Cloning failed"
fi
if [[ -n "$bitwrk_branch" ]]; then
  (cd bitwrk && git checkout "$bitwrk_branch") || die "Checkout of branch failed"
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
($go build -o ./bitwrk-admin ./client/cmd/bitwrk-admin) || die "Failed to execute go build"

accountid=$(./bitwrk-admin info 2>&1 | grep Identity| sed 's/.*Identity: \(.*\)$/\1/g')
echo "My account ID: $accountid"

if [[ ! -z "$works_for" ]]; then
  ./bitwrk-admin relation worksfor "$works_for" true || die "Failed to establish worksfor relation"
fi

if [[ ! -z "$key_file" && -e "$key_file" ]]; then
  ./bitwrk-admin -identity "$key_file" relation trusts "$accountid" true || die "Failed to add account to trusts group"
  rm -f "$key_file" || die "Failed to remove key file $key_file"
fi

(nohup ./bitwrk-client -extport 8082 > /var/log/bitwrk/daemon.log 2>&1 &) || die "Failed to launch bitwrk daemon"
sleep 2
serve_blender() {
  local id=$1
  local cost=$2
  local trusted=--trusted
  if [[ -z "$key_file" ]]; then
    trusted=
  fi
  python3.5 blender-slave.py --blender /opt/blender/blender --max-cost $cost $trusted >/var/log/bitwrk/blender-$cost-$id.log 2>&1 &
}
grant_mandate() {
  local articleid=$1
  local price=$2
  local trusted='~trusted'
  if [[ -z "$key_file" ]]; then
    trusted=
  fi
  curl -F action=permit -F type=SELL -F articleid="$articleid$trusted" -F price="$price" \
     -F usetradesleft=on -F tradesleft=100000 -F validminutes=10 \
     http://localhost:8081/
}
cd bitwrk-blender/render_bitwrk
serve_blender 1 "$articlesuffix"
grant_mandate "$articleprefix/$articlesuffix" "$price"


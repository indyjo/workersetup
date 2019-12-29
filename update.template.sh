#!/bin/bash
set -e
set -x
articleprefix="__ARTICLE_PREFIX__"
articlesuffix="512M"
price="__PRICE__"
bitwrk_branch="__BITWRK_BRANCH__"

die() {
  echo "ERROR" $@
  exit 1
}
cd $HOME || die "Homedir not found"
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
  curl -F action=permit -F type=SELL -F articleid="$articleid" -F price="$price" \
     -F usetradesleft=on -F tradesleft=100000 -F validminutes=10 \
     http://localhost:8081/
}
cd bitwrk-blender/render_bitwrk
serve_blender 1 "$articlesuffix"
grant_mandate "$articleprefix/$articlesuffix" "$price"


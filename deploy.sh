#!/bin/bash -eux

function deploy () {
  basepath="/home/isucon/webapp" # To Be Changed

  for src in `$(find $basepath/all -type f)`; do
    dst="$(echo $src | sed "s/$basepath\/all//")"
    sudo cp $src $dst
  done
  for file in `$(find $basepath/$HOSTNAME -type f)`; do
    dst="$(echo $src | sed "s/$basepath\/$HOSTNAME//")"
    sudo cp $src $dst
  done

  (cd $basepath/go && go build -o app)

  sudo systemctl daemon-reload
  # sudo systemctl restart nginx
  # sudo systemctl restart mysql
  # sudo systemctl restart isucon.go

  sudo sysctl -p /etc/sysctl.d/99-isucon.conf

  # refresh
  source $basepath/deploy.sh
}

function sync () {
  git fetch && \
  git reset --hard origin/$1 # <username>/<branch_name>
}

#!/bin/bash

retry() {
    if eval "$@"; then
        return 0
    fi

    for i in 2 1; do
        sleep 3s
        echo "Retrying $i..."
        if eval "$@"; then
            return 0
        fi
    done
    return 1
}

if [ -f /.dockerenv ] || [ -f ./dockerinit ]; then
#    mkdir -p vendor/apt

    # Install phantomjs package
#    pushd vendor/apt
#    PHANTOMJS_FILE="phantomjs-$PHANTOMJS_VERSION-linux-x86_64"
#    if [ ! -d "$PHANTOMJS_FILE" ]; then
#        curl -q -L "https://s3.amazonaws.com/gitlab-build-helpers/$PHANTOMJS_FILE.tar.bz2" | tar jx
#    fi
#    cp "$PHANTOMJS_FILE/bin/phantomjs" "/usr/bin/"
#    popd

    # Try to install packages
#    retry 'apt-get update -yqqq; apt-get -o dir::cache::archives="vendor/apt" install -y -qq --allow-downgrades --allow-remove-essential --allow-change-held-packages \
#      libicu-dev libkrb5-dev cmake nodejs postgresql-client unzip'
#    ping -4 rubygems.org -c 5
#    curl -vO https://api.rubygems.org/specs.4.8.gz
#    wget https://api.rubygems.org/specs.4.8.gz

    export FLAGS=(--path vendor --retry 3)
else
    export PATH=$HOME/bin:/usr/local/bin:/usr/bin:/bin
fi

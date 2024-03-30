#! /bin/bash

# Create AMD64 Package
mkdir -p pika-builder-python3-workaround/DEBIAN
tee pika-builder-python3-workaround/DEBIAN/control <<'EOF'
Package: pika-builder-python3-workaround
Provides: python3 (= 3.12)
Version: 3.12
Maintainer: Cosmic Fusion
Architecture: amd64
Depends: python3
Description: python3 workaround package
EOF

dpkg-deb --build pika-builder-python3-workaround

# Move all debs to output

mkdir -p ./output
mv ./*.deb ./output/

# send debs to server
rsync -azP --include './' --include '*.deb' --exclude '*' ./output/ ferreo@direct.pika-os.com:/srv/www/incoming/

# add debs to repo
ssh ferreo@direct.pika-os.com 'aptly repo add -force-replace -remove-files pikauwu-canary /srv/www/incoming/'

# publish the repo
ssh ferreo@direct.pika-os.com 'aptly publish update -batch -skip-contents -force-overwrite pikauwu filesystem:pikarepo:'

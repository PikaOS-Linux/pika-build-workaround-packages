#! /bin/bash

# Create AMD64 Package
mkdir -p pika-builder-qt-workaround/DEBIAN
tee pika-builder-qt-workaround/DEBIAN/control <<'EOF'
Package: pika-builder-qt-workaround
Provides: qtbase-abi-5-15-10 (= 5.15.10-100cosmo4), qtwayland-client-abi-5-15-10 (= 5.15.10-100cosmo4)
Version: 5.15.10-100cosmo4
Maintainer: Cosmic Fusion
Architecture: amd64
Depends: qtbase-abi-5-15-12, qtwayland-client-abi-5-15-12
Description: QT workaround package
EOF

dpkg-deb --build pika-builder-qt-workaround

# Move all debs to output

mkdir -p ./output
mv ./*.deb ./output/

# send debs to server
rsync -azP --include './' --include '*.deb' --exclude '*' ./output/ ferreo@direct.pika-os.com:/srv/www/incoming/

# add debs to repo
ssh ferreo@direct.pika-os.com 'aptly repo add -force-replace -remove-files pikauwu-canary /srv/www/incoming/'

# publish the repo
ssh ferreo@direct.pika-os.com 'aptly publish update -batch -skip-contents -force-overwrite pikauwu filesystem:pikarepo:'

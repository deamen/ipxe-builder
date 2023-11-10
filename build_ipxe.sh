##
# To do, add support for private CA
# https://ipxe.org/crypto 
##
set -e
export container=$(buildah from docker.io/amd64/alpine:3.18)

pcbios_targets=("ipxe.pxe" "ipxe.kpxe" "ipxe.kkpxe" "ipxe.lkrn")

# Initialize the buildtargets string with ipxe.efi
build_targets="bin-x86_64-efi/ipxe.efi "

# Iterate through the pcbios_targets and construct the buildtargets string
for pcbios_target in "${pcbios_targets[@]}"; do
  build_targets+="bin-x86_64-pcbios/$pcbios_target "
done
export build_targets

buildah run $container wget -c https://ipxe.org/_media/certs/ca.crt -O /tmp/ipxe.org.crt

if [ -z $1 ]; then
  embedded_ca=""
  embedded_trust="TRUST=/tmp/ipxe.org.crt"
else
  embedded_ca="CERT=/tmp/$1"
  embedded_trust="TRUST=/tmp/$1,/tmp/ipxe.org.crt"
  buildah copy $container $1 /tmp/$1
fi

buildah config --label maintainer=""github.com/deamen"" $container

buildah config --env build_targets="$build_targets" $container
buildah run $container apk add git gcc make libc-dev perl openssl openssl-dev xz-dev syslinux xorriso coreutils

# DO not use shallow clone, the makefile requires full clone
buildah run $container git clone https://github.com/ipxe/ipxe.git

buildah config --workingdir "/ipxe/src" $container
# Set up build options
buildah copy $container set_up_build_options.sh .
buildah run $container sh set_up_build_options.sh

# build .efi, .pxe, .kpxe, .kkpxe, .lkrn only
# check https://ipxe.org/appnote/buildtargets for details
buildah run $container make -j$(nproc --ignore 1) ${embedded_ca} ${embedded_trust} ${build_targets}

copy_script="copy_artifacts.sh"
cat << 'EOF' >> $copy_script
#!/bin/sh
mnt=$(buildah mount $container)
cp $mnt/$1 ./out/$2
buildah umount $container
EOF
chmod a+x $copy_script
for source_file in ${build_targets}; do
  dest_file=$(echo $source_file | sed 's/.*\///')
  echo "Copying $source_file to out/$dest_file"
  buildah unshare ./$copy_script ipxe/src/$source_file $dest_file
done

rm ./$copy_script
buildah rm $container

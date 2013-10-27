#!/usr/bin/bashir

cd ..

bower install

# Common server and client libs
readonly CLIENT_LIB_DIR=jarkle/client/lib/external
THREE_PATH=bower_components/threejs/build/three.js
THREE_TARGET_PATH="${CLIENT_LIB_DIR}/three.js"
mkdir -p "${CLIENT_LIB_DIR}"
cp --verbose \
    "${THREE_PATH}" \
    "${THREE_TARGET_PATH}"

# XXX: Workaround for the var scope in meteor
# see https://groups.google.com/forum/#!topic/meteor-talk/R_wGMDics9g
echo "window.THREE = THREE;" >> "${THREE_TARGET_PATH}"


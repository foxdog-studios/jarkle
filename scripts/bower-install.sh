#!/usr/bin/bashir

cd ..

bower install

# Common server and client libs
readonly CLIENT_LIB_DIR=jarkle/client/lib/external
THREE_PATH=bower_components/threejs/build/three.js
THREE_LIB_DIR="${CLIENT_LIB_DIR}/lib"
THREE_TARGET_PATH="${THREE_LIB_DIR}/three.js"
OBJ_PATH=bower_components/threejs/examples/js/loaders/OBJMTLLoader.js
MTL_PATH=bower_components/threejs/examples/js/loaders/MTLLoader.js
CONTROLS_PATH=bower_components/threejs/examples/js/controls/TrackballControls.js
rm -rf "${CLIENT_LIB_DIR}"
mkdir -p "${CLIENT_LIB_DIR}"
mkdir -p "${THREE_LIB_DIR}"
# THREE is prerequisite of its plugins so put it in a lib folder
cp --verbose \
    "${THREE_PATH}" \
    "${THREE_TARGET_PATH}"
cp --verbose \
    "${OBJ_PATH}" \
    "${MTL_PATH}" \
    "${CONTROLS_PATH}" \
    "${CLIENT_LIB_DIR}"

# XXX: Workaround for the var scope in meteor
# see https://groups.google.com/forum/#!topic/meteor-talk/R_wGMDics9g
echo "window.THREE = THREE;" >> "${THREE_TARGET_PATH}"


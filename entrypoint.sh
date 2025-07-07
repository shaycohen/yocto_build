#!/bin/bash
set -e
set -x

cd /workspace

if [ ! -d ".repo" ]; then
  echo "Initializing repo..."
  repo init -u https://github.com/nxp-imx/imx-manifest -b imx-linux-hardknott -m imx-5.10.72-2.2.0.xml
  repo sync
fi

if [ ! -d "py38" ]; then
  python3 -m venv py38
fi

source py38/bin/activate

if [ ! -d "build" ]; then
  #MACHINE=imx8mm-evk DISTRO=fsl-imx-xwayland source setup-environment build
  MACHINE=$ARG_MACHINE DISTRO=$ARG_DISTRO source ./imx-setup-release.sh -b bld-xwayland
fi

cd /workspace/bld-xwayland/conf
[ -L machine ] || ln -s ../../sources/meta-imx/meta-bsp/conf/machine machine
[ -L distro ] || ln -s ../../sources/meta-imx/meta-sdk/conf/distro distro
cd /workspace/bld-xwayland

exec bitbake virtual/kernel -c configure


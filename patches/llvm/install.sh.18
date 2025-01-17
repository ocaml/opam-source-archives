#!/bin/bash -ex

llvm_config="$1"
libdir="$2"
cmake="$3"
make="$4"
action="$5"
link_mode="$6"

function filter_experimental_targets {
    sed 's/ARC//g' | sed 's/CSKY//g' | sed 's/DirectX//g' | sed 's/M68k//g' | sed 's/SPIRV//g' | sed 's/Xtensa//g' | xargs
}

function llvm_build {
    mkdir "build"
    "$cmake" -Bbuild -Sllvm \
        -DCMAKE_BUILD_TYPE="`"$llvm_config" --build-mode`" \
        -DLLVM_TARGETS_TO_BUILD="`"$llvm_config" --targets-built | filter_experimental_targets | sed 's/ /;/g'`" \
        -DLLVM_OCAML_EXTERNAL_LLVM_LIBDIR=`"$llvm_config" --libdir` \
        -DLLVM_LINK_LLVM_DYLIB=`[ $link_mode = "shared" ] && echo TRUE || echo FALSE` \
        -DLLVM_OCAML_OUT_OF_TREE=TRUE \
        -DLLVM_OCAML_INSTALL_PATH="${libdir}"
    $make -Cbuild ocaml_all
}

function llvm_install {
  if test -d "build"; then
    "$cmake" -Pbuild/bindings/ocaml/cmake_install.cmake
  fi
}

case "$action" in
"build")
  llvm_build
  ;;
"install")
  llvm_install
  ;;
*)
  echo "Action not recognized"
  exit 1
  ;;
esac

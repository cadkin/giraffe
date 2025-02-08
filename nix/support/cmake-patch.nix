# Patch provided from: https://github.com/mtpham99/nixshell-cpp23-stdmodule/tree/main
{
  lib, symlinkJoin,

  cmake,

  libcxx
}:

let
  cmake-ver = "${lib.versions.majorMinor cmake.version}";
  module-path = "share/cmake-${cmake-ver}/Modules/Compiler/Clang-CXX-CXXImportStd.cmake";
in symlinkJoin {
  name = "${cmake.name}-importstd-module-patched";

  paths = [ cmake ];

  postBuild = ''
    # copy binaries to avoid using original derivation
    for link in $(find $out/bin/ -type l); do
      cp --remove-destination $(readlink $link) $out/bin/
    done;

    # replace symlink to existing module with copy for editing
    cp --remove-destination $(readlink $out/${module-path}) $out/${module-path}

    # replace "libc++.modules.json" with full path
    # to libc++ module json in new copied module file
    sed -i 's#libc++.modules.json#${libcxx}/lib/libc++.modules.json#' $out/${module-path}
  '';
}

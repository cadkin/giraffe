{
    src, version,

    lib, stdenv, wrapQtAppsHook,

    cmake, ninja, clang-tools, qtbase,

    boost
}:

stdenv.mkDerivation rec {
  pname = "giraffe";

  inherit version;
  inherit src;

  nativeBuildInputs = [
    cmake
    ninja
    clang-tools
    wrapQtAppsHook
  ];

  buildInputs = [
    boost
    qtbase
  ];

  cmakeFlags = [
    # NOP
  ];

  # Workaround for missing libc++.modules.json for C++ modules.
  NIX_CFLAGS_COMPILE = "-B${stdenv.cc.libcxx}/lib";

  # Bug with LLVM, so disable for now.
  # https://github.com/llvm/llvm-project/issues/121709
  hardeningDisable = [
    "fortify"
  ];
}


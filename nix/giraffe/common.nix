{
    src, version,

    lib, stdenv,

    cmake,

    boost
}:

stdenv.mkDerivation rec {
  pname = "giraffe";

  inherit version;
  inherit src;

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    boost
  ];

  cmakeFlags = [
    # NOP
  ];
}


{
  description = "An experimental graph library taking full advantage of proposed C++26 features";

  inputs = {
    nixpkgs.url = "github:cadkin/nixpkgs/p2996";
    utils.url   = "github:numtide/flake-utils";
  };

  outputs = inputs @ { self, utils, ... }: utils.lib.eachDefaultSystem (system: rec {
    config = rec {
      pkgs = import inputs.nixpkgs {
        inherit system;
      };

      llvm = rec {
        packages = pkgs.llvmPackages_p2996;
        stdenv   = packages.libcxxStdenv;

        tooling = {
          # LLDB is currently broken on Bloomberg's fork, but we can use LLVM 19's LLDB.
          # https://github.com/bloomberg/clang-p2996/pull/24
          lldb = pkgs.llvmPackages_19.lldb;

          tools = packages.clang-tools.override {
            enableLibcxx = true;
          };

          cmake = pkgs.callPackage ./nix/support/cmake-patch.nix { inherit (packages) libcxx; };
        };
      };
    };

    packages = with config; rec {
      inherit pkgs;

      default = giraffe.devel;

      giraffe = {
        devel = pkgs.callPackage ./nix/giraffe/common.nix {
          inherit (llvm) stdenv;
          inherit (llvm.tooling) cmake;

          version = self.shortRev or self.dirtyShortRev;
          src     = self;
        };
      };
    };

    devShells = with config; rec {
      default = giraffeDev;

      giraffeDev = pkgs.mkShell.override { inherit (llvm) stdenv; } rec {
        name = "giraffeDev";

        packages = with pkgs; with config; [
          ninja
          git

          llvm.tooling.lldb
          llvm.tooling.tools
        ] ++ pkgs.lib.optionals (pkgs.stdenv.hostPlatform.isLinux) [
          cntr
        ] ++ self.outputs.packages.${system}.default.buildInputs
          ++ self.outputs.packages.${system}.default.nativeBuildInputs
          ++ self.outputs.packages.${system}.default.propagatedBuildInputs;

        # For dev, we want to disable hardening.
        hardeningDisable = [
          "bindnow"
          "format"
          "fortify"
          "fortify3"
          "pic"
          "relro"
          "stackprotector"
          "strictoverflow"
        ];

        # Ensure the locales point at the correct archive location.
        LOCALE_ARCHIVE = pkgs.lib.optional (pkgs.stdenv.hostPlatform.isLinux) (
          "${pkgs.glibcLocales}/lib/locale/locale-archive"
        );
      };
    };
  });
}

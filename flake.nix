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

      stdenv = llvm.stdenv;

      llvm = rec {
        packages = pkgs.llvmPackages_p2996;
        stdenv   = packages.libcxxStdenv;

        tooling = rec {
          # LLDB is currently broken on Bloomberg's fork, but we can use LLVM 19's LLDB.
          # https://github.com/bloomberg/clang-p2996/pull/24
          lldb = pkgs.llvmPackages_19.lldb;

          clang-tools = tools;

          tools = packages.clang-tools.override {
            enableLibcxx = true;
          };
        };
      };
    };

    lib = with config; {
      # NOP
    } // pkgs.lib;

    legacyPackages = with config; {
      giraffe = {
        devel = pkgs.qt6.callPackage ./nix/giraffe {
          inherit stdenv;
          inherit (llvm.tooling) clang-tools;

          version = self.shortRev or self.dirtyShortRev;
          src     = self;
        };
      };
    };

    packages = with config; rec {
      default = giraffe;
      giraffe = legacyPackages.giraffe.devel;
    };

    devShells = with config; rec {
      default = giraffeDev;

      giraffeDev = pkgs.mkShell.override { inherit stdenv; } rec {
        name = "giraffeDev";

        packages = with pkgs; with config; [
          git

          llvm.tooling.lldb
          llvm.tooling.tools
        ] ++ lib.optionals (stdenv.hostPlatform.isLinux) [
          cntr
        ];

        inputsFrom = [
          self.outputs.packages.${system}.default
        ];

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
        LOCALE_ARCHIVE = lib.optional (stdenv.hostPlatform.isLinux) (
          "${pkgs.glibcLocales}/lib/locale/locale-archive"
        );

        # Workaround for missing libc++.modules.json for C++ modules.
        # See: https://github.com/NixOS/nixpkgs/issues/370217
        NIX_CFLAGS_COMPILE = "-B${llvm.packages.libcxx}/lib";
      };
    };
  });
}

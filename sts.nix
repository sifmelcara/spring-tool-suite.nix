with import <nixpkgs> {};

stdenv.mkDerivation rec {
    name = "sts";
    version = "3.8.2";
    src = fetchurl {
      url = "http://download.springsource.com/release/STS/3.8.2.RELEASE/dist/e4.6/spring-tool-suite-3.8.2.RELEASE-e4.6.1-linux-gtk-x86_64.tar.gz";
      sha256 = "346cdea58a6246cb5ab127220ca0f5e24c436e50ea633c4b72f6faa013555f1a";
    };
    buildInputs = [ gtk xorg.libXtst openjdk makeWrapper tree ] ;
    libPath = stdenv.lib.makeLibraryPath [ gtk xorg.libXtst ];
    phases = [ "unpackPhase" "installPhase" "fixupPhase" ];
    installPhase = ''
      mkdir -p $out/bin
      cp -r sts-${version}.RELEASE $out/
      ln -s $out/sts-${version}.RELEASE/STS $out/bin/STS
    '';
    fixupPhase = ''
      cd $out/sts-${version}.RELEASE
      patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) STS
      wrapProgram $out/sts-${version}.RELEASE/STS --prefix LD_LIBRARY_PATH : $libPath
    ''; 
}

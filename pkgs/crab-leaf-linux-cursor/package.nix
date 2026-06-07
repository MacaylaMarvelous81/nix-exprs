{
  stdenvNoCC,
  requireFile,
}:
stdenvNoCC.mkDerivation {
  pname = "crab-leaf-linux-cursor";
  version = "0-unstable-2023-01-11";

  # Account required :(
  src = requireFile {
    name = "crab_leaf_linux_cursor_by_nekomarunosuke_dea7q36.tar.gz";
    url = "https://www.deviantart.com/nekomarunosuke/art/Crab-Leaf-Linux-Cursor-863683026";
    hash = "sha256-OFVweiCUJi3U3CB28yfG0w+Fb2PSfBBmT2AoumE1rSI=";
  };

  unpackPhase = ''
    runHook preUnpack

    tar xvzf "$src" -C .

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/icons"
    cp -r Crab_Leaf_Linux_Cursor "$out/share/icons/Crab_Leaf_Linux_Cursor"
    cp -r Crab_Leaf_Linux_Cursor_Left "$out/share/icons/Crab_Leaf_Linux_Cursor_Left"

    runHook postInstall
  '';
}

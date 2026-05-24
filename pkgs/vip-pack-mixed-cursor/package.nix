{
  stdenvNoCC,
  fetchzip,
  win2xcur,
}:
stdenvNoCC.mkDerivation {
  pname = "vip-pack-mixed-cursor";
  version = "0-unstable-2016-11-18";

  src = fetchzip {
    url = "https://www.rw-designer.com/cursor-downloadset/terraria-vip-pack.zip";
    stripRoot = false;
    hash = "sha256-05I2DHfb5zWPdPYqbDW96WGVAjDx6wXmJJG5Xncrmsk=";
  };

  nativeBuildInputs = [ win2xcur ];

  buildPhase = ''
    runHook preBuild

    mkdir output cursors
    win2xcur *.{ani,cur} -o output

    mv 'output/Wisp (Busy)' cursors/X_cursor
    ln -s X_cursor cursors/arrow
    ln -s X_cursor cursors/left_ptr
    mv 'output/SzGamer227 (Precision Select)' cursors/hand2
    ln -s hand2 cursors/cross
    ln -s hand2 cursors/crosshair
    ln -s hand2 cursors/tcross
    mv 'output/TehCooKids (Handwriting)' cursors/pencil
    mv 'output/Redigit (Text Select)' cursors/xterm
    mv 'output/Rgbunpro (Vertical Resize)' cursors/v_double_arrow
    mv 'output/Rgbunpro (Horizontal Resize)(Fixed Hotspot)' cursors/h_double_arrow
    mv 'output/Rgbunpro (Diagonal Resize 1)' cursors/top_left_corner
    ln -s top_left_corner cursors/bottom_right_corner
    mv 'output/Rgbunpro (Diagonal Resize 2)' cursors/top_right_corner
    ln -s top_right_corner cursors/bottom_left_corner
    mv 'output/Snickerbobble (Move)' cursors/fleur

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/icons/vip-pack-mixed"
    cp -r cursors "$out/share/icons/vip-pack-mixed/cursors"
    cat > "$out/share/icons/vip-pack-mixed/index.theme" <<EOF
    [Icon theme]
    Name=Terraria V.I.P Cursors mixed
    EOF

    runHook postInstall
  '';
}

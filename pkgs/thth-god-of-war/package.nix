{
  stdenvNoCC,
  fetchzip,
  win2xcur,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "thth-god-of-war";
  version = "0-unstable-2024-01-12";

  src = fetchzip {
    url = "https://www.rw-designer.com/cursor-downloadset/god-of-war.zip";
    stripRoot = false;
    hash = "sha256-nnLkhKeHL9S/7Ob9Blec2NdSy4fIRzDytmHD5UfJN4E=";
  };

  nativeBuildInputs = [
    (win2xcur.overrideAttrs (
      finalAttrs: prevAttrs: {
        version = "0.2.1";

        src = fetchFromGitHub {
          owner = "quantum5";
          repo = "win2xcur";
          rev = "v0.2.1";
          hash = "sha256-zr3zLbjbQAY7McoF89W2Dqgj49mpHDZZBS9zzhqTAm8=";
        };
      }
    ))
  ];

  buildPhase = ''
    runHook preBuild

    mkdir output cursors
    win2xcur *.{ani,cur} -o output

    mv 'output/normal cursor' cursors/X_cursor
    ln -s X_cursor cursors/arrow
    ln -s X_cursor cursors/left_ptr
    mv 'output/wib' cursors/hand2
    ln -s hand2 cursors/cross
    ln -s hand2 cursors/crosshair
    ln -s hand2 cursors/tcross
    mv 'output/text' cursors/xterm

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/icons/thth-god-of-war"
    cp -r cursors "$out/share/icons/thth-god-of-war/cursors"
    cat > "$out/share/icons/thth-god-of-war/index.theme" <<EOF
    [Icon theme]
    Name=GOD OF WAR Cursors
    EOF

    runHook postInstall
  '';
}

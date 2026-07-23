{
  fetchzip,
  mkWindowsApp,
  makeDesktopItem,
  copyDesktopItems,
  lib,

  wine,
  p7zip,
}:
let
  xeditGeneric = fetchzip {
    url = "https://github.com/TES5Edit/TES5Edit/releases/download/xedit-4.1.5f/xEdit.4.1.5f.7z";
    hash = "sha256-QfdMvgbzJ5cg89OGTAdvOORmShPNTUJySGS4Mwio9n8=";
    stripRoot = false;
    nativeBuildInputs = [ p7zip ];
  };
in
mkWindowsApp {
  inherit wine;

  pname = "sseedit";
  version = "4.1.5f";

  src = xeditGeneric;

  nativeBuildInputs = [ copyDesktopItems ];

  enableMonoBootPrompt = false;
  fileMap = {
    "$HOME/.local/share/Steam/steamapps/common/Skyrim Special Edition/Data" =
      "drive_c/file-maps/Skyrim Special Edition Data";
    "$HOME/.local/share/Steam/steamapps/compatdata/489830/pfx/drive_c/users/steamuser/Documents/My Games/Skyrim Special Edition" =
      "drive_c/file-maps/Skyrim Special Edition Savedata";
    "$HOME/.local/share/Steam/steamapps/compatdata/489830/pfx/drive_c/users/steamuser/AppData/Local/Skyrim Special Edition/Plugins.txt" =
      "drive_c/file-maps/Plugins.txt";
  };
  winAppInstall = ''
    install_dir="$WINEPREFIX/drive_c/sseedit"
    map_dir="$WINEPREFIX/drive_c/file-maps"

    ln -s "${xeditGeneric}" "$install_dir"
    mkdir -p "$map_dir"
  '';

  winAppRun = ''
    wine "$WINEPREFIX/drive_c/sseedit/xTESEdit.exe" \
      -SSE \
      -D:'C:\file-maps\Skyrim Special Edition Data' \
      -M:'C:\file-maps\Skyrim Special Edition Savedata\' \
      -P:'C:\file-maps\Plugins.txt' \
      "$ARGS"
  '';

  installPhase = ''
    runHook preInstall

    ln -s $out/bin/.launcher $out/bin/sseedit

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "sseedit";
      exec = "sseedit";
      desktopName = "SSEEdit";
      genericName = "Bethesda Module Editor";
      categories = [ "Development" ];
    })
  ];

  meta = {
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}

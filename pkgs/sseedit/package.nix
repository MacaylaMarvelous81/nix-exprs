{
  requireFile,
  mkWindowsApp,
  makeDesktopItem,
  copyDesktopItems,
  lib,

  wine,
  p7zip,
}:
let
  nexusArchive = requireFile {
    # Original filename is 'SSEEdit 4.1.5f-164-4-1-5f-1714283656.7z', but the name may cannot
    # contain a space.
    name = "SSEEdit-4.1.5f-164-4-1-5f-1714283656.7z";
    url = "https://www.nexusmods.com/skyrimspecialedition/mods/164";
    hash = "sha256-8kgK8HYoZ5d4bDD6+PB3VyPJ6F8fBRCsEH9omIgbQPA=";
  };
in
mkWindowsApp {
  inherit wine;

  pname = "sseedit";
  version = "4.1.5f";

  src = nexusArchive;
  dontUnpack = true;

  nativeBuildInputs = [ copyDesktopItems ];
  buildInputs = [ p7zip ];

  enableMonoBootPrompt = false;
  fileMap = {
    "$HOME/.local/share/Steam/steamapps/common/Skyrim Special Edition/Data" =
      "drive_c/sseedit/Skyrim Special Edition Data";
    "$HOME/.local/share/Steam/steamapps/compatdata/489830/pfx/drive_c/users/steamuser/Documents/My Games/Skyrim Special Edition" =
      "drive_c/sseedit/Skyrim Special Edition Savedata";
    "$HOME/.local/share/Steam/steamapps/compatdata/489830/pfx/drive_c/users/steamuser/AppData/Local/Skyrim Special Edition/Plugins.txt" =
      "drive_c/sseedit/Plugins.txt";
  };
  winAppInstall = ''
    install_dir="$WINEPREFIX/drive_c/sseedit"

    mkdir -p "$install_dir"
    7z x "-o$install_dir" "${nexusArchive}"
  '';

  winAppRun = ''
    wine "$WINEPREFIX/drive_c/sseedit/SSEEdit 4.1.5f/SSEEdit.exe" \
      -D:'C:\sseedit\Skyrim Special Edition Data' \
      -M:'C:\sseedit\Skyrim Special Edition Savedata\' \
      -P:'C:\sseedit\Plugins.txt' \
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

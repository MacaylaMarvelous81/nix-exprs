{
  requireFile,
  mkWindowsApp,
  lib,

  rpc-bridge,
  unzip,
  wineWowPackages,
  pkgsCross,
}:
let
  downloader = requireFile {
    name = "MarioDownloader.exe";
    message = ''
      Obtain the Mario Multiverse installer, rename it to MarioDownloader.exe, then run
        nix-store --add-fixed sha256 MarioDownloader.exe
      to add it to the Nix store.
    '';
    hash = "sha256-GNrTtiaQvju+mXVLwKVrqmnfnBkTGXhM4ro7TwfjN+w=";
  };
  dll = requireFile {
    name = "MarioMultiverse_DLL_Files_.zip";
    message = ''
      Download the Mario Multiverse DLL archive and use
        nix-store --add-fixed sha256 MarioMultiverse_DLL_Files_.zip
      to add it to the Nix store.
    '';
    hash = "sha256-NUdqlAsX5FU8yscpAoGFdfI7LI/IH+PSlPloNfElnyg=";
  };
  rpc-bridge' = rpc-bridge.override (prev: builtins.intersectAttrs prev pkgsCross.mingwW64);
in
  mkWindowsApp {
    pname = "sfmb";
    version = "0-unstable-2024-09-21";

    srcs = [ downloader dll ];
    sourceRoot = ".";
    dontUnpack = true;

    buildInputs = [ unzip ];

    wine = wineWowPackages.stable;

    enableMonoBootPrompt = false;
    wineArch = "win64";
    # this is automatically updating software
    persistRuntimeLayer = true;
    # enableVulkan = true;
    inhibitIdle = true;
    winAppInstall = ''
      gamedir="$WINEPREFIX/drive_c/sfmb"

      wine "${ rpc-bridge' }/opt/rpc-bridge/bridge.exe" --install
      
      mkdir -p "$gamedir"
      unzip "${ dll }" -d "$gamedir"
      cp ${ downloader } "$gamedir/MarioDownloader.exe"

      cd $gamedir
      WINEDLLOVERRIDES="ktmw32=n,b;$WINEDLLOVERRIDES" wine "$gamedir/MarioDownloader.exe"
    '';

    winAppRun = ''
      wine "$WINEPREFIX/drive_c/sfmb/Mario.exe" "$ARGS"
    '';

    installPhase = ''
      runHook preInstall

      ln -s $out/bin/.launcher $out/bin/sfmb

      runHook postInstall
    '';

    meta = {
      sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    };
  }

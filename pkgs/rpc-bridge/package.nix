{
  stdenv,
  fetchFromGitHub,
  lib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "rpc-bridge";
  version = "1.4.0.1";

  src = fetchFromGitHub {
    owner = "EnderIce2";
    repo = "rpc-bridge";
    rev = "v${ finalAttrs.version }";
    hash = "sha256-NB3GqwlJ1dkI+MmbjDEDhiAvvAtRHOdC/PEEyIP2i28=";
  };

  patchPhase = ''
    runHook prePatch
    substituteInPlace src/Makefile \
      --replace-fail '$(shell git rev-parse --short HEAD)' "" \
      --replace-fail '$(shell git rev-parse --abbrev-ref HEAD)' ""
    runHook postPatch
  '';

  installPhase = ''
    runHook preInstall
    install -Dm0755 build/bridge.exe $out/opt/rpc-bridge/bridge.exe
    install -Dm0755 build/bridge.sh $out/opt/rpc-bridge/bridge.sh
    install -Dm0755 build/launchd.sh $out/opt/rpc-bridge/launchd.sh
    runHook postInstall
  '';

  meta = {
    platforms = lib.platforms.windows;
  };
})

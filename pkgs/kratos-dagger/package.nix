{
  stdenvNoCC,
  requireFile,
}:
stdenvNoCC.mkDerivation {
  pname = "kratos-dagger";
  version = "0-unstable-2022-12-04";

  # A built-in fetcher is used because the response changes contents and thus cannot be the result of a fixed-output derivation.
  # src = builtins.fetchurl "https://api.opendesktop.org/ocs/v1/content/download/1949422/1";
  #
  # __noChroot = true;
  #
  # nativeBuildInputs = [
  #   libxml2
  #   wget
  # ];
  #
  # unpackPhase = ''
  #   runHook preUnpack
  #
  #   _downloadlink=$(xmllint --xpath '//ocs/data/content[@details="download"]/downloadlink/text()' "$src")
  #   wget -O kratos-dagger.tar.gz "$_downloadlink"
  #   tar -xzf kratos-dagger.tar.gz
  #
  #   runHook postUnpack
  # '';

  src = requireFile {
    name = "kratos-dagger.tar.gz";
    url = "https://www.gnome-look.org/p/1949422";
    hash = "sha256-c6z50RSFs18aTWJLu8njOFy5DhcQt0nTk1FCCVgLJZo=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/icons"
    cp -r . "$out/share/icons/kratos-dagger"

    runHook postInstall
  '';
}

{ pkgs, ... }:

pkgs.stdenvNoCC.mkDerivation {
  pname = "aspect";
  version = "2026.17.17";

  src = pkgs.fetchurl {
    url = "https://github.com/aspect-build/aspect-cli/releases/download/v2026.17.17/aspect-cli-x86_64-unknown-linux-musl";
    hash = "sha256-20WWjhFMIq8ODT3drftwkcgZg/Zkme7Z0B14K7CUg9A=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin"
    cp "$src" "$out/bin/aspect"
    chmod +x "$out/bin/aspect"
    runHook postInstall
  '';

  meta = with pkgs.lib; {
    description = "Aspect CLI";
    homepage = "https://github.com/aspect-build/aspect-cli";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = "aspect";
  };
}

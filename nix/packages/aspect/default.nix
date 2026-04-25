{ pkgs, inputs, ... }:

pkgs.rustPlatform.buildRustPackage rec {
  pname = "aspect";
  version = "unstable-${inputs.aspect-cli-src.shortRev or "unknown"}";

  src = inputs.aspect-cli-src;

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
    allowBuiltinFetchGit = true;
  };

  cargoBuildFlags = [
    "--package"
    "aspect-cli"
    "--bin"
    "aspect-cli"
  ];

  nativeBuildInputs = [
    pkgs.pkg-config
    pkgs.protobuf
  ];

  buildInputs = [ pkgs.openssl ];

  postInstall = ''
    mv "$out/bin/aspect-cli" "$out/bin/aspect"
  '';

  meta = with pkgs.lib; {
    description = "Aspect CLI";
    homepage = "https://github.com/aspect-build/aspect-cli";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ fromSource ];
    mainProgram = "aspect";
  };
}

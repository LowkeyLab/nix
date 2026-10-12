{ pkgs, inputs, ... }:

let
  aspectSrc = inputs.aspect-cli-src;

  cargoDeps = pkgs.runCommand "cargo-vendor-dir" { } ''
    cp -R --no-preserve=mode ${
      pkgs.rustPlatform.importCargoLock {
        lockFile = "${aspectSrc}/Cargo.lock";
        allowBuiltinFetchGit = true;
        extraRegistries = {
          "https://github.com/rust-lang/crates.io-index" = "https://static.crates.io/crates";
          "sparse+https://index.crates.io/" = "https://static.crates.io/crates";
        };
      }
    } "$out"

    # importCargoLock emits extra registry entries into Cargo's config as
    # sources. Cargo already treats crates.io aliases as the built-in
    # `crates-io` source, so remove those duplicate source blocks after the
    # vendor fetch has used them to route downloads to static.crates.io.
    ${pkgs.gawk}/bin/awk '
      /^\[source\."https:\/\/github\.com\/rust-lang\/crates\.io-index"\]$/ { skip = 1; next }
      /^\[source\."sparse\+https:\/\/index\.crates\.io\/"\]$/ { skip = 1; next }
      skip && /^\[/ { skip = 0 }
      !skip { print }
    ' "$out/.cargo/config.toml" > "$out/.cargo/config.toml.tmp"
    mv "$out/.cargo/config.toml.tmp" "$out/.cargo/config.toml"
  '';
in
pkgs.rustPlatform.buildRustPackage rec {
  pname = "aspect";
  version = "unstable-${inputs.aspect-cli-src.shortRev or "unknown"}";

  src = aspectSrc;

  inherit cargoDeps;

  postPatch = ''
    # Upstream's Cargo path override expects the copy normally prepared by
    # cargo patch-crate. Use the vendored source to keep this step offline.
    mkdir -p target/patch
    cp -RL --no-preserve=mode "${cargoDeps}/starlark-0.14.2" target/patch/starlark-0.14.2
    patch -d target/patch/starlark-0.14.2 -p1 < patches/starlark+0.14.2.patch

    # The integration-test daemon stand-in must exist in the Nix sandbox.
    substituteInPlace crates/aspect-cli/tests/exec_log_event.rs \
      --replace-fail '"/bin/sleep"' '"${pkgs.coreutils}/bin/sleep"'
  '';

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

  nativeCheckInputs = [ pkgs.git ];

  preCheck = ''
    # The fixture's fallback builds basil without Nix's profile and target.
    cargo build --offline --release --target ${pkgs.stdenv.hostPlatform.rust.rustcTarget} -p basil
    export BASIL_BIN="$PWD/target/${pkgs.stdenv.hostPlatform.rust.rustcTarget}/release/basil"

    # CLI integration tests extract builtins into a writable cache.
    export ASPECT_CLI_CACHE="$TMPDIR/aspect-cli-cache"
    # exec_log_event filters ASPECT_* but preserves the XDG cache setting.
    export XDG_CACHE_HOME="$TMPDIR/cache"
  '';

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

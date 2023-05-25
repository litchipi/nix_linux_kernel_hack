{ stdenv }: stdenv.mkDerivation {
  name = "custom_kernel_module";
  src = ./.;
  installPhase = ''
    touch $out
  '';
}

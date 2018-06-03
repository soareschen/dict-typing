{ mkDerivation, base, constraints, lens, stdenv }:
mkDerivation {
  pname = "dict-typing-demo";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base constraints lens ];
  license = stdenv.lib.licenses.isc;
}

{ mkDerivation, base, constraints, stdenv }:
mkDerivation {
  pname = "dict-typing-demo";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base constraints ];
  license = stdenv.lib.licenses.isc;
}

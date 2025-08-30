{ mkDerivation, base, blaze-html, blaze-markup, hspec, http-types
, ihp, ihp-hsx, lib, text, wai, wai-extra
}:
mkDerivation {
  pname = "ihp-sitemap";
  version = "1.4.0";
  src = ./../../ihp-sitemap;
  libraryHaskellDepends = [ base blaze-html blaze-markup ihp text ];
  testHaskellDepends = [
    base hspec http-types ihp ihp-hsx wai wai-extra
  ];
  description = "SEO";
  license = lib.licenses.mit;
}
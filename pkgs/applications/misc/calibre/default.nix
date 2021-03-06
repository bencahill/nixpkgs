{ stdenv, fetchurl, python, pyqt4, sip, popplerQt4, pkgconfig, libpng
, imagemagick, libjpeg, fontconfig, podofo, qt4, icu, sqlite
, pil, makeWrapper, unrar, chmlib, pythonPackages, xz, udisks, libusb1, libmtp
}:

stdenv.mkDerivation rec {
  name = "calibre-0.8.70";
  # 0.9.* versions won't build: https://bugs.launchpad.net/calibre/+bug/1094719

  src = fetchurl {
    url = "mirror://sourceforge/calibre/${name}.tar.xz";
    sha256 = "12avwp8r6cnrw6c32gmd2hksa9rszdb76zs6fcmr3n8r1wkwa71g";
  };

  inherit python;

  nativeBuildInputs = [ makeWrapper pkgconfig ];

  buildInputs =
    [ python pyqt4 sip popplerQt4 libpng imagemagick libjpeg
      fontconfig podofo qt4 pil chmlib icu
      pythonPackages.mechanize pythonPackages.lxml pythonPackages.dateutil
      pythonPackages.cssutils pythonPackages.beautifulsoup
      pythonPackages.sqlite3 sqlite udisks libusb1 libmtp
    ];

  installPhase = ''
    export HOME=$TMPDIR/fakehome
    export POPPLER_INC_DIR=${popplerQt4}/include/poppler
    export POPPLER_LIB_DIR=${popplerQt4}/lib
    export MAGICK_INC=${imagemagick}/include/ImageMagick
    export MAGICK_LIB=${imagemagick}/lib
    export FC_INC_DIR=${fontconfig}/include/fontconfig
    export FC_LIB_DIR=${fontconfig}/lib
    export PODOFO_INC_DIR=${podofo}/include/podofo
    export PODOFO_LIB_DIR=${podofo}/lib
    python setup.py install --prefix=$out

    PYFILES="$out/bin/* $out/lib/calibre/calibre/web/feeds/*.py
      $out/lib/calibre/calibre/ebooks/metadata/*.py
      $out/lib/calibre/calibre/ebooks/rtf2xml/*.py"

    sed -i "s/env python[0-9.]*/python/" $PYFILES
    for a in $out/bin/*; do
      wrapProgram $a --prefix PYTHONPATH : $PYTHONPATH --prefix LD_LIBRARY_PATH : ${unrar}/lib --prefix PATH : ${popplerQt4}/bin
    done
  '';

  meta = {
    description = "Comprehensive e-book software";
    homepage = http://calibre-ebook.com;
    license = "GPLv3";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}

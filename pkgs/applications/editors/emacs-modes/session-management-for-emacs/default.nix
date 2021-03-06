{stdenv, fetchurl, emacs}:

stdenv.mkDerivation rec {
  name = "session-management-for-emacs-2.2a";
  
  src = fetchurl {
    url = "http://downloads.sourceforge.net/project/emacs-session/session/2.2a/session-2.2a.tar.gz";
#    url = "mirror://sourceforge.net/sourceforge/emacs-session/session-2.2a.tar.gz";
    sha256 = "37dfba7420b5164eab90dafa9e8bf9a2c8f76505fe2fefa14a64e81fa76d0144";
  };

  buildInputs = [emacs];
  
  installPhase = ''
    mkdir -p "$out/share/emacs/site-lisp"
    cp lisp/*.el "$out/share/emacs/site-lisp/"
  '';

  meta = { 
    /* installation: add to your ~/.emacs
       (require 'session)
       (add-hook 'after-init-hook 'session-initialize)
    */
    description = "small session management for emacs";
    homepage = http://emacs-session.sourceforge.net/;
    license = "GPL";
  };
}

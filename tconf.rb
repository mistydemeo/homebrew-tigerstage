require 'formula'

class Tconf < Formula
  homepage 'http://www.opensource.apple.com'
  url 'http://opensource.apple.com/tarballs/TargetConfig/TargetConfig-14.tar.gz'
  sha1 '579cc3a2260288be46f400ce39fa62d272fdb503'

  depends_on 'coreosmakefiles' => :build

  keg_only :provided_by_osx,
    "This package includes a newer version of an official Apple development tool."

  def install
    # tconf expects a /-like layout
    inreplace 'Makefile', '/usr/', '/'
    makepath = Formula.factory('coreosmakefiles').libexec/'Makefiles'
    # CHOWN=true because the makefile tries to chown to root
    system "make", "install",
      "MAKEFILEPATH=#{makepath}", "DSTROOT=#{prefix}",
      "RC_ProjectName=TargetConfig", "CHOWN=true"
  end
end

require 'formula'

class XnuHeaders < Formula
  homepage 'http://www.opensource.apple.com'

  headers = {
    :tiger   => ['792.24.17', 'ac1c42ee5e3fcb1821e8c56706d63fb395989180'],
    :leopard => ['1228.15.4', 'd33e28f4db6973828e81f0f7ac366097eac80f9c'],
    :snow_leopard => ['1504.15.3', '7fe7b66f3db13a12137a33274f063e26facde45e'],
    :lion => ['1699.32.7', 'da3df48952b40ad3b8612c7f639b8bf0f92fb414'],
    :mountain_lion => ['2050.22.13', 'a002806d1e64505c6a98c10af26186454818a9ff']
  }

  vers, sh1 = headers[MacOS.version.to_sym]
  url     "http://www.opensource.apple.com/tarballs/xnu/xnu-#{vers}.tar.gz"
  sha1    sh1

  keg_only :provided_by_osx,
    "This package includes official development headers not installed by Apple."

  def install
    include.install Dir['bsd/*']
    # some makefiles look for this in System, for some unknown reason
    (include/'System').mkpath
    (include/'System/sys').make_symlink include/'sys'
    (include/'Makefile').unlink
  end
end

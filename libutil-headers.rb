require 'formula'

class LibutilHeaders < Formula
  homepage 'http://www.opensource.apple.com'
  url 'http://www.opensource.apple.com/tarballs/libutil/libutil-30.tar.gz'
  sha1 'aab5b3a4eac7eb0eef9104d60f69e0892afe0b1e'

  keg_only :provided_by_osx,
    "This package includes official development headers not installed by Apple."

  def install
    include.install Dir['*.h']
  end
end

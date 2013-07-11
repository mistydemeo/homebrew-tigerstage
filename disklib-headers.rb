require 'formula'

class DisklibHeaders < Formula
  homepage 'http://www.opensource.apple.com'
  url 'http://www.opensource.apple.com/tarballs/diskdev_cmds/diskdev_cmds-557.3.tar.gz'
  sha1 '757cd11db00a2b74e80ad794bd64640fae080bbd'

  keg_only 'The private headers from disklib are not normally installed.'

  def install
    include.install Dir['disklib/*.h']
  end
end

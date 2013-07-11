require 'formula'

class Coreosmakefiles < Formula
  homepage 'http://www.opensource.apple.com/'
  url 'http://www.opensource.apple.com/tarballs/CoreOSMakefiles/CoreOSMakefiles-75.tar.gz'
  sha1 'bb85beb3b285df3624e518b25e60123aa2a45bcc'

  def install
    # HACK - xcrun isn't guaranteed to exist in all Xcode versions,
    # like 2.5, so just replace this with something useless
    inreplace 'Standard/Commands.in' do |s|
      s.change_make_var! 'PATH_OF_COMMAND', '/bin/echo'
    end
    # Because we're installing into a Homebrew prefix, not /
    inreplace 'ReleaseControl/BSDCommon.make',
      '/usr/share/man', '/share/man'
    system "make", "install", "DSTROOT=#{libexec}"
  end

  def caveats; <<-EOS.undent
    These makefiles have been customized for use when installing Apple
    tools using Tigerbrew, and may not work for manual builds.
    EOS
  end
end

require 'formula'

class DiskdevCmds < Formula
  homepage 'http://www.opensource.apple.com'
  url 'http://www.opensource.apple.com/tarballs/diskdev_cmds/diskdev_cmds-557.3.tar.gz'
  sha1 '757cd11db00a2b74e80ad794bd64640fae080bbd'

  depends_on 'coreosmakefiles' => :build
  depends_on 'disklib-headers' => :build
  depends_on 'libutil-headers' => :build
  depends_on 'xnu-headers' => :build

  def install
    # The install paths are frequently a mess, so they need some tweaking
    # to fit within our install prefix that doesn't resemble / entirely
    #
    # original tool installs some things to /sbin, some to /usr/sbin
    %w[dev_mkdb edquota fdisk fuser quotaon repquota vsdbutil].each do |tool|
      inreplace "#{tool}.tproj/Makefile" do |s|
        s.change_make_var! 'Install_Dir', '/sbin'
      end
    end

    %w[fuser quota].each do |tool|
      inreplace "#{tool}.tproj/Makefile" do |s|
        s.change_make_var! 'Install_Dir', '/bin'
      end
    end

    inreplace 'disklib/Makefile' do |s|
      s.change_make_var! 'Install_Dir', '/lib'
    end

    inreplace 'vndevice.tproj/Makefile' do |s|
      s.change_make_var! 'Install_Dir', '/libexec'
    end

    # Because we customized BSDCommon.make to install the manfiles
    # where we want them
    inreplace 'quotaon.tproj/Makefile', '/usr/share/man', '/share/man'

    # two tools try to use `install` to install files as root-owned
    %w[fsck_hfs vsdbutil].each do |tool|
      inreplace "#{tool}.tproj/Makefile", "-o root -g wheel", ""
    end

    # vsdbutil tries to install its plist to /System under the install prefix
    inreplace 'vsdbutil.tproj/Makefile', '/System/Library/LaunchDaemons/com.apple.vsdbutil.plist', ''

    makepath = Formula.factory('coreosmakefiles').libexec/'Makefiles'
    # One makefile tries to chown a tool to root, which a regular
    # user account of course can't do
    system "make", "CHOWN=true",
      "MAKEFILEPATH=#{makepath}", "DSTROOT=#{prefix}",
      # These two paths only occur in fsck_hfs
      'HFS_INSTALLDIR=/Filesystems/hfs.fs',
      "INCINSTALLDIR=#{include}/fsck"
  end
end

# head is automatically determined for github sources? Though this means the
# head flag is less discoverable…
source "https://github.com/blah/tarball/1.2.3", "d3472204baa6865e98a0fa5d30c2ec01"
bottle :sf, "fbc31b43e4e843f1784e43031d83a8f8"
home "http://blah.com"

# NOTE it's mandatory for versions to parsable by Ruby's string-version
# parsing thingy. We will expand its capabilities so that common other
# examples work. If your versions don't parse then you'll need to make your
# own version comparator function.
# NOTE so that files in the cache can be figured out back to formula
# versions may not contain the '-' character, or we should redo how cached
# files are stored. ie. maybe directories, though it's neat seeing them all
# with a single `ls`

# also valid
source :apache_mirror, "foo", "HASHHASHHASH"
source Formula.new('gcc') # uses same download tarball as another formula
                          # eg GFortran compiles out of the GCC tarball

meta do
  supports_destdir true
  keg_only "Rationale"
  keg_only :dupe # you wouldn't do this twice, it's an example
end

generate :pc_file # generates and auto-fills pkg-config file

# no more optional deps, if a dep is optional it should be defined as a
# variant that is "on" by default

depends_on :arse
depends_on :pkgconfig, :build
depends_on :foo if variant "+bar"

# if dependents of this formula require ENV settings, add them here
dependent_ENV do
  ENV['FOO_FLAGS'] = "#{HOMEBREW_PREFIX}/bar"
end

# this dep requires the because field or it throws an exception
# we use it for deps that we don't want people to use, they have to justify it
depends_on :libiconv because "OS X iconv doesn't have a 64 bit symbol for iconv_open"

# it is pretty common for other PMs eg. RubyGems to want to install their
# stuff in a site packages directory like this. So we want to ensure that
# the symlinking starts from #{prefix}/lib/ruby and not below that.
proper_directory "/lib/ruby/#{version}"

# skip_clean no longer exists, but you can ask for specific stuff to be stripped if you like
strip :bin
strip Dir["lib/*.dylib"]

# patches require checksums if they are downloaded
# rationale: patches can do anything! The checksum is for security reasons
# since the patch can be from anywhere, we can't trust people not to be
# nefarious.
# so we can cache patches in brew2: #{name}-#{version}-#{checksum}.patch
patch "https://qt.gitorious.org/qt/qt/commit/91be12", 873434
patch "-p2d", "http://example.com/patch", 173434 # eg. lua requires the -d flag
patch "https://foo.com/config.h.ed", 473434 # supports ed files
patch DATA

variant '+dbus', "QtDBus module" do
  depends_on :dbus
  caveats "Displayed after install"
end

variant '+q3support', "deprecated Qt3Support module." do
  config << "-qt3support"
else
  config << "-no-qt3support"
end

# The minus sign indicates that the default is off
variant "-universal", "universal binary" do
  config << '-arch' << 'x86_64'
end

doctor do
  # perform tests here to check for common issues and then help user to 
  # resolve them
end

install do
  ENV :x11, :O4, :j1

  # deprecate inreplace
  # things should always use patch as it is more robust in the face of changes
  # to the underlying code, and if it doesn't work it stops the build
  # use of inreplace has to be quantified like so:
  inreplace 'configure' do |content|
    I_AM_USING_INREPLACE_BECAUSE_I_AM_LAZY
    content.gsub! '${PACKAGE_NAME}-${PACKAGE_VERSION}', '${PACKAGE_NAME}'
  end

  system "configure", *config
  system "make"
  system "make install"

  mv "foo", :bin

  # downloads to Caches/Homebrew/foo-manpages-#{version}.tar.bz2
  # filename is somewhat smartly determined so it looks pretty in the cache
  # but is still unique. Hash can be from cksum or md5.
  download "http://foo.com/bar-#{version}", 7868768 do
    mv Dir['*'], :bin
  end

  begin
    download "http://foo.com/foo-manpages-#{version}.tar.bz2", 474674 do
      mv Dir['*'], :man
    end
  rescue DownloadFailed
    # So, it's a non-essential download
    opoo "Couldn't download manpages"
  end
end

notice <<-EOS.undent
  Displayed before install
  In case you have some information that needs to be stated in advance.
  EOS

caveats "Displayed after install"
caveats "You can call these functions multiple times and the strings append"

test do
  system "identify", "/Library/Application Support/Apple/iChat Icons/Flags/Argentina.gif"
end


# note, we're dropping the clean step, so no skip_clean stuff

# we support some string replacements in patches eg. everything that starts
# HOMEBREW_ here
__END__
diff --git a/rscreen b/rscreen
index f0bbced..ce232c3 100755
--- a/rscreen
+++ b/rscreen
@@ -23,4 +23,4 @@ fi
 #AUTOSSH_PATH=/usr/local/bin/ssh
 export AUTOSSH_POLL AUTOSSH_LOGFILE AUTOSSH_DEBUG AUTOSSH_PATH AUTOSSH_GATETIME AUTOSSH_PORT
 
-autossh -M 20004 -t $1 "screen -e^Zz -D -R"
+autossh HOMEBREW_PREFIX HOMEBREW_CPPFLAGS HOMEBREW_LDFLAGS

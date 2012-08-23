require_relative 'env'
require 'pathname'
require 'tempfile'

class StringTest < MiniTest::Unit::TestCase
  def test_file?
    assert __FILE__.file?
  end

  def test_dot
    assert_equal "".realpath, ".".realpath
  end

  def test_children
    assert_equal ".".children, Dir["*"]
    assert_equal "..".children, Dir["../*"]
    cd ".." do
      assert_equal "test".children, Dir["test/*"]
    end
  end

  def test_kegpath
    keg = "#{Homebrew.CELLAR}/foo/0.9"
    assert_equal "#{keg}/bin/foo".kegpath, keg
    assert_raises(Errno::ENOENT) { "#{Homebrew.CELLAR}/arse/0.8".kegpath }
    assert_raises(ArgumentError) { __FILE__.kegpath }
  end

  def test_directory?
    assert __FILE__.dirname.directory?
  end

  def test_symlink?
    assert "/usr/lib/ruby".symlink?
  end

  def test_root?
    assert "/".root?
  end

  def test_realpath
    assert_equal "/usr/bin/ruby".realpath, "/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin/ruby"
  end

  def test_extname
    assert_equal "foo.bar".extname, ".bar"
  end

  def test_dirname
    assert_equal "/foo/bar".dirname, "/foo"
    assert_equal "/foo/bar/".dirname, "/foo"
  end

  def test_cleanpath
    assert_equal "/usr/../lib".cleanpath, "/lib"
  end

  def test_parent
    assert_equal "/usr/lib".parent, "/usr"
    assert_equal "/usr/lib/".parent, "/usr"
  end

  def test_find
    files = []
    "////bin///../bin////".find do |fn|
      files << fn
    end
    assert_equal files, Dir["/bin/*"]
    assert_raises(Errno::ENOENT) { "/arse".find{} }
    assert_raises(Errno::ENOTDIR) { __FILE__.find{} }
  end

  def test_relative_find
    files = []
    "/bin".relative_find do |fn|
      files << fn
    end
    FileUtils.cd "/bin" do
      assert_equal Dir["*"], files
    end
  end

  def test_to_pn
    assert_instance_of Pathname, "/".to_pn
    assert_equal Pathname.new("/"), "/".to_pn
  end

  def test_write
    assert_raises(RuntimeError) { __FILE__.write(LOREM_IPSUM) }

    fn = Tempfile.new('homebrew').path
    fn.write(LOREM_IPSUM, :force)
    assert_equal IO.read(fn), LOREM_IPSUM

    assert_raises(Errno::EISDIR){ __FILE__.dirname.write(LOREM_IPSUM, :force) }
  end
end

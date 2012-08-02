# All we do with Homebrew is path manipulations.
# Lets make our code more readable by extending String (where sensible).

class String
  def file?
    File.file? self
  end

  def directory?
    File.directory? self
  end

  def symlink?
    File.symlink? self
  end

  def root?
    to_pn.root?
  end

  def realpath
    to_pn.realpath.to_s
  end

  def extname
    File.extname self
  end

  def dirname
    File.dirname self
  end

  def cleanpath
    to_pn.cleanpath.to_s
  end

  def parent
    to_pn.parent.to_s
  end

  def find
    require 'find'
    Find.find self do |fn|
      yield fn unless fn == self
    end
  end

  def relative_find
    FileUtils.cd self do
      ".".find do |fullpath|
        yield fullpath[2..-1]
      end
    end
  end

  def to_pn
    require 'pathname'
    Pathname.new(self)
  end

  def write content
    raise "Will not overwrite: #{self}" if File.exist? self and not ARGV.force?
    FileUtils.mkdir_p(self)
    File.open(self, 'w'){ |f| f.write(content) }
  end
end

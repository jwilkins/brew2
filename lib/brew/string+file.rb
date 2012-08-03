# All we do with Homebrew is path manipulations.
# Lets make our code more readable by extending String (where sensible).
# Only extend with stuff that is not already in String (duh) and that makes
# sense only in the context of the string representing a file. Eg join is a
# File class method, but we don't add that here because it would make sense
# in the context of any string, not just string representing paths.

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

  def extname
    File.extname self
  end

  def dirname
    File.dirname self
  end

  def realpath
    to_pn.realpath.to_s
  end

  def cleanpath
    to_pn.cleanpath.to_s
  end

  # If path is a file in a keg then this will return the containing Keg object
  def kegpath
    path = self.realpath
    until path.root?
      return path if path.parent.parent == Homebrew.cellar
      path = path.parent.realpath # "realpath" prevents root? failing
    end
    raise ArgumentError, "#{path} is not inside a keg"
  end

  def parent
    to_pn.parent.to_s
  end

  def find
    raise Errno::ENOTDIR if file?
    require 'find'
    Find.find self do |fn|
      yield fn.cleanpath unless fn == self
    end
  end

  def relative_find
    FileUtils.cd self do
      ".".find do |fullpath|
        yield fullpath
      end
    end
  end

  def to_pn
    require 'pathname'
    Pathname.new(self)
  end

  def dot?
    self == "." or empty?
  end

  def children
    if dot?
      Dir["*"]
    else
      Dir["#{self}/*"]
    end
  end

  # TODO probably too generic and will cause bugs, move to IO
  def write content, *opts
    raise "Will not overwrite: #{self}" if File.exist? self and not opts.include? :force
    FileUtils.mkdir_p(self.dirname)
    File.open(self, 'w'){ |f| f.write(content) }
  end
end

# All we do with Homebrew is path manipulations.
# Lets make our code more readable by extending String (where sensible).

require 'fileutils'
require 'pathname'

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

  def realpath
    to_pn.realpath.to_s
  end

  def to_pn
    Pathname.new(self)
  end

  def write content
    raise "Will not overwrite: #{self}" if File.exist? self and not ARGV.force?
    FileUtils.mkdir_p(self)
    File.open(self, 'w'){ |f| f.write(content) }
  end
end

class HomebrewPrefix < Homebrew::Command
  def run
    puts self
  end
  def to_s
    Homebrew.prefix
  end
end

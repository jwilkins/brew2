class Help < Homebrew::Command
  requires_arg :formula
  can_be_empty

  flags {
    "[p]lonk" => "Does the finkyfinky"
    h: "DINKSDFKSJDKS"
  }
  
  def run args
    
  end
end
class Effect
  attr_reader(:name, :duration)
  
  ##
  # name nom de l'effet
  # duration durée en seconde de l'effet
  def initialize(name, duration)
    @name = name
    @duration = duration
  end
  
  def method_name
    
  end
  
  SLOW = Effect.new("slow", 5)
end

puts Effect::SLOW
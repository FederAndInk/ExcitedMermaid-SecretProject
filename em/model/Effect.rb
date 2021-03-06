class Effect
  attr_accessor(:starting_time)
  attr_reader(:name, :duration)
  ##
  # name nom de l'effet
  # duration durée en seconde de l'effet
  def initialize(name, duration)
    @name = name
    @duration = duration
    @starting_time = Time.now
  end
  
    
  def method_name 
    
  end
  
  def isDone?
    return Time.now > @starting_time + @duration
  end
  
  def self.getEffect(nameEffect)
    case nameEffect
    when "slow"
      effet =  SLOW.clone
    when "root"
      effet = ROOT.deep_dup
    when "blind"
      effet = BLIND.clone
    when "weakness"
      effet = WEAKNESS.clone
    when "strength"
      effet = STRENGTH.clone
    when "speed"
      effet = SPEED.clone
    end
    effet.starting_time = Time.now
    return effet
  end
  
  SLOW = Effect.new("slow", 5)
  ROOT = Effect.new("root", 5)
  BLIND = Effect.new("blind", 5)
  WEAKNESS = Effect.new("weakness", 5)
  STRENGTH = Effect.new("strength", 5)
  SPEED = Effect.new("speed", 5)
end
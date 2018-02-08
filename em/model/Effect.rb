class Effect
  attr_reader(:name, :duration,:starting_time)
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
  
  def getEffect(nameEffect)
    case nameEffect
    when "slow"
      effect = SLOW.clone
    when "root"
      effect = ROOT.clone
    when "blind"
      effect = BLIND.clone
    when "weakness"
      effect = WEAKNESS.clone
    when "strength"
      effect = STRENGTH.clone
    when "speed"
      effect = SPEED.clone
    end
    effect.starting_time = Time.now
    return effect
  end
  
  SLOW = Effect.new("slow", 5)
  ROOT = Effect.new("root", 5)
  BLIND = Effect.new("blind", 5)
  WEAKNESS = Effect.new("weakness", 5)
  STRENGTH = Effect.new("strength", 5)
  SPEED = Effect.new("speed", 5)
end

puts Effect::SLOW
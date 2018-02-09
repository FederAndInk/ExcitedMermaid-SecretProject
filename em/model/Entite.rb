#
#
#

require 'em/model/Actions'
require("em/model/Effect")
require 'em/model/ElementGraphique'
require 'observer'

class Entite < ElementGraphique
  include(Observable)
  #
  # Accessor Methods
  #
  attr_accessor :vie, :position, :hitbox , :effetsSubis
  attr_reader :vie_max
  def initialize(name, vie_max, posHb1_x,posHb1_y,posHb2_x,posHb2_y)
    super(name)

    @effetsSubis= Array.new
    
    @position = Hash.new(0)
    deplacer(0, 0)

    @hitbox = Array.new
    @hitbox[0]= {"x"=>posHb1_x,"y"=>posHb1_y}
    @hitbox[1]= {"x"=>posHb2_x,"y"=>posHb2_y}

    @vie_max = vie_max
    @vie = @vie_max
  end
  
  
  def addEffet(effet)
    if(effet.class.name == "Effet" && !subitEffet?(effet.name))
      @effetsSubis.push(Effect.getEffect(effet.name))
    end
  end
  
  def subitEffet?(nomEffet)
    answer = false
    effetsSubis.each { 
              |effet|
              if(effet.class.name == "Effect" && effet.name == nomEffet)
               answer = true
              end
            }
            
    return answer
  end

  def soigner(montantSoin)
    @vie += montantSoin
    if (@vie > @vie_max)
      @vie = @vie_max
    end
  end

  def perdreVie(degatsSubis,entiteAttaquante, effets)
    @vie -= degatsSubis
    puts self.name + " perd " + degatsSubis.to_s + "HP! (" + @vie.to_s + "HP restants)"
    @vie = @vie <=  0 ? 0 : @vie
    changed()
    notify_observers(Action::ENTITY_HIT, self)
    if(!effets.empty?)
      changed()
      notify_observers(Action::SUBIT_EFFETS, self, effets)
    end
    
    if @vie <=0
      changed()
      notify_observers(Action::ENTITY_DIED, self)
    end
  end

  def deplacer(x,y)
    
    deplaX = x - @position["x"]
    deplaY = y - @position["y"]
    malusX = 0
    malusY = 0
    bonusX = 0
    bonusY = 0
    
    if(subitEffet?(Effect::SLOW.name))
      malusX = deplaX *0.2
      malusY = deplaY *0.2
    end  
    if(subitEffet?(Effect::SPEED.name))
      bonusX = deplaX *0.2
      bonusY = deplaY *0.2
    end
    
    
    if(!subitEffet?(Effect::ROOT.name))
      @position["x"] += deplaX -malusX +bonusX
      @position["y"] += deplaY -malusY +bonusY
      changed()
      notify_observers(Action::ENTITY_MOVED, self)
    end
  end

  def getHitboxRel
    return @hitbox
  end

  def getHitboxAbs
    return [{"x"=>@position["x"]+@hitbox[0]["x"],"y"=>@position["y"]+@hitbox[0]["y"]},{"x"=>@position["x"]+@hitbox[1]["x"],"y"=>@position["y"]+@hitbox[1]["y"]}]
  end

  def isCollidedTo(entity)
    collision = true

    thisHB = getHitboxAbs
    entityHB = entity.getHitboxAbs

    if (entityHB[0]["x"] > thisHB[1]["x"] || entityHB[1]["x"] < thisHB[0]["x"] || entityHB[0]["y"] > thisHB[1]["y"] || entityHB[1]["y"] < thisHB[0]["y"])
      then
      collision = false
    end

    return collision
  end
end


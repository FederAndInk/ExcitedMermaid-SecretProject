#
#
#

require 'em/model/Actions'
require 'em/model/ElementGraphique'
require 'observer'

class Entite < ElementGraphique
  include(Observable)
  #
  # Accessor Methods
  #
  attr_accessor :vie, :position, :hitbox
  attr_reader :vie_max
  def initialize(name, vie_max, posHb1_x,posHb1_y,posHb2_x,posHb2_y)
    super(name)
    
    @position = Hash.new(0)
    deplacer(0, 0)

    @hitbox = Array.new
    @hitbox[0]= {"x"=>posHb1_x,"y"=>posHb1_y}
    @hitbox[1]= {"x"=>posHb2_x,"y"=>posHb2_y}

    @vie_max = vie_max
    @vie = @vie_max
  end

  def soigner(montantSoin)
    @vie += montantSoin
    if (@vie > @vie_max)
      @vie = @vie_max
    end
  end

  def perdreVie(degatsSubis,entiteAttaquante)
    @vie -= degatsSubis
    puts self.name + " perd " + degatsSubis.to_s + "HP! (" + @vie.to_s + "HP restants)"
    if @vie <=0
      changed()
      notify_observers(Action::ENTITY_DIED, self, entiteAttaquante)
    end
  end

  def deplacer(x,y)
    @position["x"] = x
    @position["y"] = y
    changed()
    notify_observers(Action::ENTITY_MOVED, self, self)
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


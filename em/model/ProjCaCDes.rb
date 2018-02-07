#
#
#
require 'em/model/Projectile'

class ProjCaCDes < Projectile
  #
  # Accessor Methods
  #
  attr_accessor :alreadyHitEntity, :angleDes, :r
  public
  def initialize(name,portee,posHb1_x,posHb1_y,posHb2_x,posHb2_y)
    super(name,portee,posHb1_x,posHb1_y,posHb2_x,posHb2_y)
    @r = Array.new(2)
  end

  def hit(entity)
    alreadyHitEntity.push(entity.name)
    entity.perdreVie(degats,self)
  end

  def deplacement
    x = @position["x"]*Math::cos(@angleDes) + @position["y"]*Math::sin(@angleDes) + @r[0]
    y =  -@position["x"]*Math::sin(@angleDes) + @position["y"]*Math::cos(@angleDes) + @r[1]
    deplacer(x,y)
  end

  def copyAndActive(name,degats,departAbs, direction, angleDes,entitySrc)
    newCopy = super(name,degats,departAbs, direction, entitySrc)

    newCopy.alreadyHitEntity = []

    newCopy.r = Array.new
    newCopy.r.push(-(@hitbox[1]["x"]*Math::cos(angleDes)) - (@hitbox[1]["y"]*Math::sin(angleDes)) + @hitbox[1]["x"])
    newCopy.r.push((@hitbox[1]["x"]*Math::sin(angleDes)) - (@hitbox[1]["y"]*Math::cos(angleDes)) + @hitbox[1]["y"])
    newCopy.angleDes = angleDes

    @@projectilesActifs.push(newCopy)

    return newCopy
  end
end
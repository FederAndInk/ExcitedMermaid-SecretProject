#
#
#
require 'em/model/Projectile'

class ProjCaCDes < Projectile
  #
  # Accessor Methods
  #
  attr_accessor :alreadyHitEntity, :angleDes, :r, :nbdepla
  public
  def initialize(name,portee,posHb1_x,posHb1_y,posHb2_x,posHb2_y,effets)
    super(name,portee,posHb1_x,posHb1_y,posHb2_x,posHb2_y,effets)
    @r = Array.new(2)
    @nbdepla = 0
  end
  
  def nextStep(entites)
    @nbdepla +=1
    puts ("Déplacement n°" + @nbdepla.to_s)
    super(entites)
  end

  def hit(entity)
    alreadyHitEntity.push(entity.name)
    entity.perdreVie(degats,self,@effets)
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
    newCopy.nbdepla = 0
    newCopy.angleDes = angleDes * Math::PI / 180
    newCopy.r.push(-((@hitbox[1]["x"]+departAbs[0])*Math::cos(newCopy.angleDes)) - ((@hitbox[1]["y"]+departAbs[1])*Math::sin(newCopy.angleDes)) + (@hitbox[1]["x"]+departAbs[0]))
    newCopy.r.push(((@hitbox[1]["x"]+departAbs[0])*Math::sin(newCopy.angleDes)) - ((@hitbox[1]["y"]+departAbs[1])*Math::cos(newCopy.angleDes)) + (@hitbox[1]["y"]+departAbs[1]))

    return newCopy
  end
  
def checkPortee
  anglemax = -90*Math::PI/180
  oui =  @position["x"] >=  @departAbs[0]*Math::cos(anglemax) + @departAbs[1]*Math::sin(anglemax) + -((@hitbox[1]["x"]+departAbs[0])*Math::cos(anglemax)) - ((@hitbox[1]["y"]+departAbs[1])*Math::sin(anglemax)) + (@hitbox[1]["x"]+departAbs[0])
  oui2 = @position["y"] >= -@departAbs[0]*Math::sin(anglemax) + @departAbs[1]*Math::cos(anglemax) +  ((@hitbox[1]["x"]+departAbs[0])*Math::sin(anglemax)) - ((@hitbox[1]["y"]+departAbs[1])*Math::cos(anglemax)) + (@hitbox[1]["y"]+departAbs[1])
    if(oui && oui2) 
      changed()
      notify_observers(Action::ENTITY_DIED, self, self)
    end
  end  
  protected
end
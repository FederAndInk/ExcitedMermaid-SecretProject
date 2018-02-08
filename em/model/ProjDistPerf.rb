require 'em/model/Projectile'

class ProjDistPerf < Projectile
  #
  # Accessor Methods
  #
  attr_accessor :alreadyHitEntity
  public
  
  def initialize(name,portee,posHb1_x,posHb1_y,posHb2_x,posHb2_y)
    super(name,portee,posHb1_x,posHb1_y,posHb2_x,posHb2_y)
 end  

  def hit(entity)
    alreadyHitEntity.push(entity.name)
    entity.perdreVie(degats,self,@effets)
  end
  
  def deplacement
    deplacer(position["x"] + direction[0],position["y"] + direction[1])
  end
  
def copyAndActive(name,degats,departAbs, direction, entitySrc)
    newCopy = super(name,degats,departAbs, direction, entitySrc)

#    puts entitySrc.class
#    if entitySrc.is_a?(Entite)
#      newCopy.name= name
#      newCopy.degats = degats
      newCopy.alreadyHitEntity = []
#      newCopy.deplacer(departAbs[0],departAbs[1])
#      newCopy.entitySrc= entitySrc
#      newCopy.direction= direction
#
#      @@projectilesActifs.push(newCopy)
#
#    else
#      puts "c'est pas une entite!"
#    end
    return newCopy
  end
end
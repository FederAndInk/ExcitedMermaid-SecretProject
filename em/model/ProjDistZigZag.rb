require 'em/model/Projectile'

class ProjDistZigZag < Projectile
  #
  # Accessor Methods
  #
  attr_accessor :y_limit
  public
  
  def initialize(name,portee,posHb1_x,posHb1_y,posHb2_x,posHb2_y,effets)
    super(name,portee,posHb1_x,posHb1_y,posHb2_x,posHb2_y,effets)
 end
  
  def hit(entity)
    self.perdreVie(vie_max,entity)
    entity.perdreVie(degats,self,@effets)
  end
  
  def deplacement
    if((direction[1] > 0 && position["y"] >= departAbs[1] +  y_limit ) || (direction[1] < 0 && position["y"] <= departAbs[1] - y_limit ))
          direction[1] = -direction[1]
        end
        deplacer(position["x"] + direction[0],position["y"] + direction[1])
  end
  
def copyAndActive(name,degats,departAbs, direction, entitySrc)
    newCopy = super(name,degats,departAbs, direction, entitySrc)

    puts entitySrc.class
    if entitySrc.is_a?(Entite)
      newCopy.name= name
      newCopy.degats = degats
      newCopy.y_limit = direction[1]*direction[1]
      newCopy.departAbs = departAbs
      newCopy.deplacer(departAbs[0],departAbs[1])
      newCopy.entitySrc= entitySrc
      newCopy.direction= direction

    else
      puts "c'est pas une entite!"
    end
    return newCopy
  end
  
end
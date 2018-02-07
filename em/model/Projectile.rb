#
# 
#
require 'em/model/Entite'


class Projectile < Entite

  @@projectilesActifs = Array.new
  
  #
  # Accessor Methods
  #
  attr_accessor :direction, :entitySrc


  public
  def self.projectilesActifs
    @@projectilesActifs
  end
  
  
  def initialize(posHb1_x,posHb1_y,posHb2_x,posHb2_y)
     super(1,-100,-100,posHb1_x,posHb1_y,posHb2_x,posHb2_y)
   end
  
  #
  # test si le projectile touche une entité,
  # - se détruit si oui
  # - avance sinon
  # si la fin du projectile alors il est détruit
  # * _entites_ array
  def nextStep(entites)
  end

  #
  # 
  # * _departAbs_ array
  # * _direction_ Integer
  def copyAndActive(departAbs, direction, entitySrc)
    newCopy = self.clone
    
    newCopy.deplacer(departAbs[0],departAbs[1])
    newCopy.entitySrc= entitySrc
    newCopy.direction= direction
    
    @@projectilesActifs.push(newCopy)
  end

  
  def isHit(entite)
    hit = false
    
    if(isHitable(entite) && isCollidedTo(entite))
      hit = true
    end
    return hit
  end
    
  def isHitable(entite)
    hitable = false
    
    if(entite.class.name != "Projectile" && (entite.class.superclass.name != "Projectile"))
      if(entitySrc.class.name == "Personnage")
        hitable = (entite.class.name != "Personnage")
      else 
        hitable = (entite.class.name == "Personnage")
      end 
    end
    return hitable
  end
  
  
  
  protected

  #
  # 
  # * _entite_ em_model_Entite
  

  private

end


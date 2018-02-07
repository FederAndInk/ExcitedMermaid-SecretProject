#
# 
#
require 'em/model/Projectile'
class DistBoule < Projectile

  #
  # Accessor Methods
  #


  public
  
  def initialize(name,posHb1_x,posHb1_y,posHb2_x,posHb2_y)
   super(name,posHb1_x,posHb1_y,posHb2_x,posHb2_y)
 end

  def nextStep(entites)
    entites.each { 
      |entity|
      if(isHit(entity))
        perdreVie(vie_max,entity)
      end
    }
    
    deplacer(position["x"] + direction[0],position["y"] + direction[1])
  end

end


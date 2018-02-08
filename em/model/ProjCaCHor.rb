#
# 
#
require 'em/model/Projectile'
class ProjCaCHor < Projectile

  #
  # Accessor Methods
  #


  public
  
  def initialize(name,portee,posHb1_x,posHb1_y,posHb2_x,posHb2_y)
   super(name,portee,posHb1_x,posHb1_y,posHb2_x,posHb2_y)
 end

  def hit(entity)
    self.perdreVie(vie_max,entity)
    entity.perdreVie(degats,self,@effets)
  end
  
  def deplacement
    deplacer(position["x"] + direction[0],position["y"] + direction[1])
  end
  
end
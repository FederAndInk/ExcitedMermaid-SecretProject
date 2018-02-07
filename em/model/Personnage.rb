#
# 
#
require 'em/model/Entite'
class Personnage < Entite

  #
  # Accessor Methods
  #


  public
  def initialize(name, vie_max,pos_x,pos_y,posHb1_x,posHb1_y,posHb2_x,posHb2_y)
     super(name, vie_max,pos_x,pos_y,posHb1_x,posHb1_y,posHb2_x,posHb2_y)
   end
  

  
  
end


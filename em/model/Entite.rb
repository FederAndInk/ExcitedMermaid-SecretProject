#
# 
#
require 'em/model/intVector'
require 'em/model/ModelActions'
require 'observer'

class Entite
  include(Observable)
  #
  # Accessor Methods
  #
  attr_accessor :vie, :position, :dimensions
  attr_reader :vie_max

   def initialize(vie_max,pos_x,pos_y,dim_x,dim_y)
     @position = Hash.new(0)
     @position["x"]=pos_x
     @position["y"]=pos_y
       
     @dimensions = Hash.new(0)
     @dimensions["x"]=dim_x
     @dimensions["y"]=dim_y
     
     @vie_max = vie_max
     @vie = @vie_max
   end
   
   def soigner(montantSoin)
     @vie += montantSoin
     if (@vie > @vie_max)
       @vie = @vie_max
     end
   end
   
   def perdreVie(degatsSubis)
     @vie -= degatsSubis
     if @vie <=0
       changed()
       notify_observers(ModelAction::ENTITY_DIED, self)
     end
   end
   
   def deplacer(x,y)
     @position["x"] += x
     @position["y"] += y
   end
      
   def getHitbox
     return [{"x"=>@position["x"],"y"=>@position["y"]},{"x"=>@position["x"]+@dimensions["x"],"y"=>@position["y"]+@dimensions["y"]}]
   end
end


#
#
#
require 'em/model/Entite'

class Ennemi < EntiteAttaquante

  #
  # Accessor Methods
  #

  public
  def initialize(name,vie_max,posHb1_x,posHb1_y,posHb2_x,posHb2_y, posArme, arme=nil)
    super(name,vie_max,posHb1_x,posHb1_y,posHb2_x,posHb2_y, posArme, arme)
  end

#  def deplacerEnnemi(hitboxJoueur)    
#    centreJoueur = [hitboxJoueur[1]["x"]-hitboxJoueur[0]["x"],hitboxJoueur[1]["y"]-hitboxJoueur[0]["y"]]
#    myCentre = [getHitboxAbs[1]["x"]-getHitboxAbs[0]["x"],getHitboxAbs[1]["y"]-getHitboxAbs[0]["y"]]
#    
#    directionX = 1
#    directionY = 1
#
#    if(myCentre[0] - centreJoueur[0] < 0)
#      directionX = 1
#    elsif(myCentre[0] - centreJoueur[0] > 0)
#      directionX = -1
#    else
#      directionX = 0
#    end
#    
#    if(myCentre[1] - centreJoueur[1] < 0)
#      directionY = 1
#    elsif(myCentre[1] - centreJoueur[1] > 0)
#      directionY = -1
#    else
#      directionY = 0
#    end
#    #deplacer(1000,1000)
#    deplacer(@position["x"] + directionX*20,@position["y"] + directionY*20)    
#  end
  
  def deplacerEnnemi(hitboxJoueur)    
    directionX = 0
    directionY = 0
    
    random = rand(3)
    puts random
    case random
    when 0
      directionX = (rand(2)==0)? 1000 : -1000
    when 1
      directionY = (rand(2)==0)? 1000 : -1000
    when 2
      directionX = (rand(2)==0)? 1000 : -1000
      directionY = (rand(2)==0)? 1000 : -1000
    end
    
    
    deplacer(@position["x"] + directionX,@position["y"] + directionY)    
      
    return Time.now
  end
  
  
  
end


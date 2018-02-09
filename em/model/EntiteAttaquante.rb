require 'em/model/Entite'

class EntiteAttaquante < Entite
  attr_accessor(:arme)
  def initialize(name, vie_max, posHb1_x,posHb1_y,posHb2_x,posHb2_y, posArme, arme = nil)
    super(name, vie_max, posHb1_x,posHb1_y,posHb2_x,posHb2_y)
    @arme = arme
    @posArme =posArme
  end

  def attaquer(direction)
    if(@arme != nil && !subitEffet?(Effect::BLIND.name))
      #gestion du sens d'attaque
      
      directionAttaque = 1
      if(direction[0]-@position["x"]<0)
      directionAttaque = -1
      end
      
      @arme.activer(@posArme,directionAttaque,self)
    end
  end

  def ramasserArme(arme)
    if(arme.class.name == "Arme" && @arme == nil && self.isCollidedTo(arme))
      @arme = arme
    end
  end
end
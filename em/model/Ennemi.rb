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

end


require("observer")
require("em/model/Actions")
require("em/model/ElementGraphique")

class Arme < ElementGraphique
  include(Observable)
  #
  # Accessor Methods
  #
  attr_reader(:durabilite, :durabiliteMax)

  public

  ##
  # 
  # * _durabilite_ Integer
  # * _projectiles_ array
  # liste des projectiles que l'arme va envoyer 
  #
  # * _effects_ array
  def initialize(name, durabilite, durabiliteMax, projectiles)
    super(name)
    
    @durabilite = durabilite
    @durabiliteMax = durabiliteMax
    @projectiles = projectiles
  end

  ## 
  # * _departAbs_ point de départ absolu de l'arme
  # * _direction_ Integer
  # la direction pointée du porteur de l'arme
  def activer(departAbs, direction, entitySrc)
    @projectiles.each { |proj|
      proj.copyAndActive(departAbs, direction, entitySrc)
    }
    @durabilite -= 1
    if @durabilite <= 0
      notify_observers(Action::WEAPON_BROKE,self)
    end
  end

  protected

  private

end


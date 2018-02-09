require("observer")
require("em/model/Actions")
require("em/model/Entite")
require("em/model/ProjCaCHor")
require("em/model/ProjCaCDes")
require("em/model/ProjDist")
require("em/model/ProjDistPerf")

class Arme < Entite
  include(Observable)
  #
  # Accessor Methods
  #
  attr_accessor(:weaponType, :durabilite, :durabiliteMax, :projectiles)

  public
  ##
  #
  # * _durabilite_ Integer
  # * _projectiles_ array
  # liste des projectiles que l'arme va envoyer
  #
  # * _effects_ array
  def initialize(name, degats, weaponType, durabilite, durabiliteMax, projectiles)
    super(name, 1, 200, 200, 450, 450)

    @degats = degats
    @weaponType = weaponType
    @durabilite = durabilite
    @durabiliteMax = durabiliteMax
    @projectiles = projectiles
  end

  ##
  # * _departAbs_ point de départ absolu de l'arme
  # * _direction_ Integer
  # la direction pointée du porteur de l'arme
  def activer(departAbs, direction, entitySrc)
    newProjs = []
    @projectiles.each { |proj|
      # TODO : ici il y avait que trois param
      # TODO : et il en faut 6 pour la chaise !! SEE : ProjCaCDes
      newProj = proj.copyAndActive(proj.name(), @degats, departAbs, direction, entitySrc)
      newProjs << newProj
      modifieur = 0
      if(subitEffet?(Effect::STRENGTH.name))
        modifieur +=1
      end
      if(subitEffet?(Effect::WEAKNESS.name))
        modifieur -=1
      end

      newProj.degats += modifieur
    }
    changed()
    notify_observers(Action::ADD_PROJECTILES, self, newProjs)
    @durabilite -= 1
    if @durabilite <= 0
      changed()
      notify_observers(Action::WEAPON_BROKE,self)
    end
  end

  def self.getArme(nameArme)
    case nameArme
    when "Regle"
      armeToClone =  REGLE
    when "Chaise"
      armeToClone = CHAISE
    when "Agrafeuse"
      armeToClone = AGRAFEUSE
    when "Shuriken"
      armeToClone = SHURIKEN
    end

    arme = armeToClone.clone

    arme.durabilite = armeToClone.durabilite
    arme.durabiliteMax = armeToClone.durabiliteMax
    arme.projectiles = armeToClone.projectiles

    arme.vie = armeToClone.vie
    arme.position = armeToClone.position
    arme.hitbox = armeToClone.hitbox
    arme.effetsSubis = armeToClone.effetsSubis
    return arme
  end

  REGLE = Arme.new("Regle", 1, WEAPONTYPE::MELEE, 5,5,[ProjCaCHor.new("Regle",60,10,140,250,180,[])])
  CHAISE = Arme.new("Chaise", 2, WEAPONTYPE::MELEE,5,5,[ProjCaCDes.new("Chaise",0,20,60,280,200,[Effect::ROOT,Effect::BLIND])])
  AGRAFEUSE = Arme.new("Agrafeuse", 1, WEAPONTYPE::RANGED,5,5,[ProjDistPerf.new("Agrafe",500,280,260,330,300,[Effect::SLOW])])
  SHURIKEN = Arme.new("Shuriken", 1, WEAPONTYPE::RANGED,5,5,[ProjDist.new("Shuriken",400,200,200,280,280,[])])
end


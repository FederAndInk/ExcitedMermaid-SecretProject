#
#
#
require 'em/model/Entite'

class Projectile < Entite

  @@projectilesActifs = Array.new

  #
  # Accessor Methods
  #
  attr_accessor :name, :direction, :entitySrc

  public
  def self.projectilesActifs
    @@projectilesActifs
  end

  def initialize(name,posHb1_x,posHb1_y,posHb2_x,posHb2_y)
    super(name, 1, posHb1_x, posHb1_y, posHb2_x, posHb2_y)
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
  def copyAndActive(name,departAbs, direction, entitySrc)
    newCopy = deep_clone()

    puts entitySrc.class
    if entitySrc.is_a?(Entite)
      newCopy.name= name
      newCopy.deplacer(departAbs[0],departAbs[1])
      newCopy.entitySrc= entitySrc
      newCopy.direction= direction

      @@projectilesActifs.push(newCopy)

    else
      puts "c'est pas une entite!"
    end
    return newCopy
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

  def deep_clone
    newClone = clone
    newClone.position = @position.clone
    return newClone
  end

  protected

  #
  #
  # * _entite_ em_model_Entite

  private

end


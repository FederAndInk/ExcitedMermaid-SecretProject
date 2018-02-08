#
#
#
require 'em/model/Entite'

class Projectile < Entite

  @@projectilesActifs = Array.new

  #
  # Accessor Methods
  #
  attr_accessor :name, :degats, :departAbs, :portee, :direction, :entitySrc, :effets

  public
  def self.projectilesActifs
    @@projectilesActifs
  end

  def initialize(name,portee,posHb1_x,posHb1_y,posHb2_x,posHb2_y,effets)
    @portee = portee
    super(name, 1, posHb1_x, posHb1_y, posHb2_x, posHb2_y)
    @departAbs = Array.new
    @effets = effets
  end

  #
  # test si le projectile touche une entité,
  # - se détruit si oui
  # - avance sinon
  # si la fin du projectile alors il est détruit
  # * _entites_ array
  def nextStep(entites)
    puts self.name + " en vie à la position (" + self.position["x"].to_s + "," + self.position["y"].to_s+")? : " + (self.vie <=0 ? "No" : "Yes")

    entites.each { 
          |entity|
          if(isHit(entity))
           hit(entity)
          end
        }
    self.checkPortee
    self.deplacement
  end

  #
  #
  # * _departAbs_ array
  # * _direction_ Integer
  def copyAndActive(name,degats,departAbs, direction, entitySrc)
    newCopy = deep_clone()

    puts entitySrc.class
    if entitySrc.is_a?(Entite)
      newCopy.name= name
      newCopy.degats = degats
      newCopy.departAbs = departAbs
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
      puts self.name + " touche " + entite.name
    end
    return hit
  end
  
  def hit(entity)
  end
  
  def deplacement
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
    newClone.hitbox = @hitbox
    
    return newClone
  end
  
  def checkPortee
    if((@direction[0] >= 0 && @position["x"] >= (@departAbs[0] + @portee)) || (@direction[0] <= 0 && @position["x"] <= (@departAbs[0] - @portee)))
      changed()
      notify_observers(Action::ENTITY_DIED, self, self)
    end
  end  
  protected

  #
  #
  # * _entite_ em_model_Entite

  private

end


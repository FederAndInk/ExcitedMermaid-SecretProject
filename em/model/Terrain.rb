require("em/model/Entite")
require("em/model/Personnage")
require("em/model/Ennemi")
require("em/model/Boss")
require("em/model/Projectile")
require("em/view/game")
require 'em/model/Personnage'
require 'em/model/Ennemi'

class Terrain
  @@entities = Hash.new()
  def self.getNewName(name)
    nameTmp = name
    i = 1
    while @@entities.has_key?(nameTmp)
      nameTmp = name + i.to_s
    end
    return nameTmp
  end
end

module EntiteList
  BLANCHON = {:name => "Blanchon", :entite => Personnage.new("Blanchon", 4, 0, 0, 0, 0)}
  CERET = {:name => "Ceret", :entite => Boss.new("Ceret", 4, 0, 0, 0, 0)}
end

class Terrain
  #
  # Accessor Methods
  #
  def initialize()
    @game = Game.new()
    @game.add_observer(self,:gameUpdate)

    newEntite(EntiteList::BLANCHON, 540, 920, true)
    @game.player=(@@entities["Blanchon"][1])

    newEntite(EntiteList::CERET, 4020, 1000)
    @game.boss=(@@entities["Ceret"][1])
    
    @threadIHM = Thread.new do
        ents = getEntitiesModel()
        for proj in Projectile::projectilesActifs
          proj.nextStep(ents)
          if isOut(proj)
            puts "delete projectile " + proj.name()
            vProj = @@entities[proj.name][1]
            vProj.
            Projectile::projectilesActifs.delete(proj)
          end
        end
      end
    end

    @game.show()

  end

  def entiteModelUpdate(action, mEntite, content = nil)
    vEntite = @@entities[mEntite.name][1]

    case action
    when Action::ENTITY_DIED
      puts ("entity : " + mEntite.name + " died")
#            vEntite.
    when Action::WEAPON_BROKE

    when Action::ENTITY_MOVED
      puts("#{vEntite.nameId()} move to #{mEntite.position['x']}, #{mEntite.position['y']}")
      vEntite.moveTo(mEntite.position['x'], mEntite.position['y'])
    end
  end

  def entityViewUpdate(action, vEntity)
    mEntite = @@entities[vEntity.nameId()][0]

    case action
    when Action::ENTITY_MOVED
      if mEntite
        mEntite.position = vEntity.getPosition()
        puts("#{vEntity.nameId()} is on #{mEntite.position['x']}, #{mEntite.position['y']}")
      end
    end
  end

  def gameUpdate

  end

  protected

  private

  def newEntite(perso, x, y, isPrio = false)
    entite = perso[:entite].clone
    entite.name=(Terrain.getNewName(perso[:entite].name()))
    entite.add_observer(self, :entiteModelUpdate)

    map = Hash[entite.name() => [entite, @game.newTeacher(perso[:name], entite.name(), self, isPrio)]]
    @@entities.merge!(map)

    entite.deplacer(x, y)
  end

  def getEntitiesModel
    ret = []
    for ent in @@entities
      ret << ent[0]
    end
    return ret
  end
  
  def isOut(entite)
    x = entite.position["x"]
    y = entite.position["y"]
    return x < 0 or y < 0 or x > @game.width() or y > @game.height()
  end
  
end

require("em/model/Entite")
require("em/model/Personnage")
require("em/model/Ennemi")
require("em/model/Boss")
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
  BLANCHON = {:name => "Blanchon", :entite => Personnage.new(Terrain.getNewName("Blanchon"), 4, 0, 0, 0, 0)}
  CERET = {:name => "Ceret", :entite => Personnage.new(Terrain.getNewName("Ceret"), 4, 0, 0, 0, 0)}
end

class Terrain
  #
  # Accessor Methods
  #
  def initialize()
    @game = Game.new()

    newEntite(EntiteList::BLANCHON, 540, 920)
    @game.player=(@@entities["Blanchon"][1])

#    newEntite(EntiteList::CERET, 4020, 1000)
    @threadIHM = Thread.new do
      while true
#        @@entities["Ceret"][1].moveLeft()
#        @@entities["Ceret"][1].setmoving()
        sleep(0.1)
      end
    end

    @game.show()

  end

  def entiteModelUpdate(action, mEntite)
    vEntite = @@entities[mEntite.name][1]

    case action
    when Action::ENTITY_DIED
      puts ("entity : " + mEntite.name + " died")
      #      vEntite
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
  protected

  private

  def newEntite(perso, x, y)
    entite = perso[:entite].clone
    entite.add_observer(self, :entiteModelUpdate)

    map = Hash[entite.name() => [entite, @game.newTeacher(perso[:name], entite.name(), self)]]
    @@entities.merge!(map)

    entite.deplacer(x, y)
  end

end

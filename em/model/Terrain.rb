require("em/model/Entite")
require("em/model/Personnage")
require("em/model/Ennemi")
require("em/model/Boss")
require("em/view/game")
require 'em/model/Personnage'
require 'em/model/Ennemi'
class Terrain
  #
  # Accessor Methods
  #
  
  def initialize()
    @game = Game.new()

    @entities = Hash.new()

    perso = newPerso("Blanchon")
    @entities.merge!(perso)

    @game.show()
  end

  def entiteUpdate(action, entite)
    case action
    when Action::ENTITY_DIED
      puts ("entity : " + entite.name + " died")
      #      @entities[entite.name]
    when Action::WEAPON_BROKE

    end
  end

  def entityViewUpdate(action, entity)
    case action
    when Action::ENTITY_MOVED
      entModel = @entities[entity.nameId()][0]
      if entModel
        entModel.position = entity.getPosition()
        puts("#{entity.nameId()} is on #{entModel.position['x']}, #{entModel.position['y']}")
      end
    end
  end
  protected

  private

  def newPerso(name)
    newName = getNewName(name)
    perso = Personnage.new(newName, 4, 0, 0, 0, 0, 0, 0)
    perso.add_observer(self, :entiteUpdate)
    map = Hash[newName => [perso, @game.newTeacher(name, newName, self)]]
    return map
  end

  def newEnnemi(name)

  end

  def newBoss(name)

  end

  def getNewName(name)
    nameTmp = name
    i = 1
    while @entities.has_key?(nameTmp)
      nameTmp = name + i.to_s
    end
    return nameTmp
  end

end
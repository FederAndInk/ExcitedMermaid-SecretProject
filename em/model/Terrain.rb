require("em/model/Entite")
require("em/model/Personnage")
require("em/model/Ennemi")
require("em/model/Boss")
require("em/view/game")
require 'em/model/Personnage'
require 'em/model/Ennemi'
require 'em/model/Arme'

class Terrain
  @@entities = Hash.new()
  @@armesAuSol = Hash.new
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
  BLANCHON = {:name => "Blanchon", :entite => Personnage.new(Terrain.getNewName("Blanchon"), 4, 0, 0, 0, 0,0)}
  CERET = {:name => "Ceret", :entite => Personnage.new(Terrain.getNewName("Ceret"), 4, 0, 0, 0, 0,0)}
end

class Terrain
  #
  # Accessor Methods
  #
  def initialize()
    @game = Game.new()
    
    @intervalleApparitionArme = 3
    @lastApparitionArme = Time.now 

    newEntite(EntiteList::BLANCHON, 540, 920)
    @game.player=(@@entities["Blanchon"][1])

    newEntite(EntiteList::CERET, 4020, 1000)
    @threadIHM = Thread.new do
      while true
        if((@lastApparitionArme + @intervalleApparitionArme <=Time.now) && (@@armesAuSol.length <3))
          newArmeAleatoireAuSol()
          @intervalleApparitionArme = rand(5...16)
          @lastApparitionArme = Time.now 
        end
      end
    end

   

    @game.show()

  end

  def armeModelUpdate(action, mArme)
    vArme = @@armesAuSol[mArme.name][1]
    
    case action
    when Action::WEAPON_BROKE
    when Action::ENTITY_MOVED
      puts("#{vArme.nameId()} move to #{mArme.position['x']}, #{mArme.position['y']}")
      vArme.moveTo(mArme.position['x'], mArme.position['y'])
    end

  end

  def entiteModelUpdate(action, mEntite)
    vEntite = @@entities[mEntite.name][1]

    case action
    when Action::ENTITY_DIED
      puts ("entity : " + mEntite.name + " died")
      #      vEntite

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

  def newArmeAleatoireAuSol
    i = rand(4)

    arme = nil
    case i
    when 0
      arme = Arme.getArme(Arme::REGLE.name)
    when 1
      arme = Arme.getArme(Arme::CHAISE.name)
    when 2
      arme = Arme.getArme(Arme::AGRAFEUSE.name)
    when 3
      arme = Arme.getArme(Arme::SHURIKEN.name)
    end
    arme.add_observer(self, :armeModelUpdate)

    newArmeName = Terrain.getNewName(arme.name)

    map = Hash[newArmeName => [arme, @game.newArme(arme.name(), newArmeName, self)]]
    @@armesAuSol.merge!(map)

    x = rand(210...3801)
    y = rand(770...2051)
    arme.deplacer(x, y)
  end

end

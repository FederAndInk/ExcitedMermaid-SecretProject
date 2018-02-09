require("em/model/Entite")
require("em/model/Personnage")
require("em/model/Ennemi")
require("em/model/Boss")
require("em/model/Projectile")
require("em/view/game")
require 'em/model/Personnage'
require 'em/model/Ennemi'
require 'em/model/Arme'
require 'mutex_m'

class Terrain
  @@entities = Hash.new()
  @@armesAuSol = Hash.new
  @@nbArmes = 0
  def self.armesAuSol
    return @@armesAuSol
  end

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
  BLANCHON = {:name => "Blanchon", :entite => Personnage.new("Blanchon", 4, 200, 200, 400, 400, 0)}
  CERET = {:name => "Ceret", :entite => Boss.new("Ceret", 4, 0, 0, 0, 0, 0)}
end

class Terrain
  #
  # Accessor Methods
  #
  def initialize(game)
    @game = game
    @game.add_observer(self,:gameUpdate)

    @intervalleApparitionArme = 3
    @lastApparitionArme = Time.now

    newEntite(EntiteList::BLANCHON, 540, 920, true)
    @game.player=(@@entities["Blanchon"][1])
    @player = @@entities["Blanchon"][0]
    @game.setPvP(@player.vie, @player.vie_max)

    newEntite(EntiteList::CERET, 4020, 1000)
    @game.boss=(@@entities["Ceret"][1])
    @boss = @@entities["Ceret"][0]
    @game.setPvB(@boss.vie, @boss.vie_max)

    @game.setFunction(lambda{
      # Arme distri loop
      if((@lastApparitionArme + @intervalleApparitionArme <=Time.now) && (@@nbArmes < 3))
        @@nbArmes += 1
        newArmeAleatoireAuSol()
        @intervalleApparitionArme = rand(5...26)
        @lastApparitionArme = Time.now
      end

      # projectile loop
      ents = Terrain.getEntitiesModel()
      for proj in Projectile::projectilesActifs
        proj.nextStep(ents)
        if isOut(proj)
          puts "delete projectile " + proj.name()
          vProj = @@entities[proj.name][1]
          vProj.setDead()
          Projectile::projectilesActifs.delete(proj)
        end
      end

      # ramasse arme loop
      if(!@player.arme())
        ramasse = false
        @@armesAuSol.each do |key, arme|
          @player.ramasserArme(arme[0])
          if(@player.arme() && !ramasse)
            ramasse = true
            vArme = arme[1]
            @game.player().setWeapon(vArme.name(), @player.arme().weaponType())
            vArme.delete()
            @@armesAuSol.delete(key)
            @@nbArmes -=1
          end
        end
      end
    })

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
      vEntite.setDead()

    when Action::ENTITY_MOVED
      vEntite.moveTo(mEntite.position['x'], mEntite.position['y'])
    when Action::ENTITY_HIT
      vEntite.setHit()
      if mEntite == @player
        @game.setPvP(mEntite.vie, mEntite.vie_max)
      elsif mEntite == @boss
        @game.setPvB(mEntite.vie, mEntite.vie_max)
      end
    end
  end

  def entityViewUpdate(action, vEntity)

    case action
    when Action::ENTITY_MOVED
      mEntite = @@entities[vEntity.nameId()][0]
      if mEntite
        mEntite.position = vEntity.getPosition()
      end
    end
  end

  def gameUpdate(action, content)
    case action
    when Action::USER_KEY
      case content
      when Gosu::MS_LEFT
        #       TODO @player.attaque
        @game.player.setAttack(Attaque::ESTOC)
      when Gosu::MS_RIGHT
        if rand(2) == 0
          for i in 0..6
            @game.player.moveUp()
          end
        else
          for i in 0..6
            @game.player.moveDown()
          end
        end
      when Gosu::KB_SPACE
        if @player.arme
          @game.player.setWeapon()
          @player.arme=nil
        end
      end
    end
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

  def addProjectile(proj)
    puts("add projectile")
    proj.add_observer(self, :entiteModelUpdate)
    newName = getNewName(proj.name())
    map = Hash[newName => [proj, @game.newTeacher(proj.name(), newName, self, false)]]
    proj.name=(newName)
    @@entities.merge!(map)
  end

  def self.getEntitiesModel
    ret = []
    for ent in @@entities
      ret << ent[0]
    end
    return ret
  end

  def isOut(entite)
    x = entite.position["x"]
    y = entite.position["y"]
    return ((x < 0) or (y < 0) or (x > @game.width()) or (y > @game.height()))
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
    Terrain::armesAuSol.merge!(map)

    x = rand(210..3800)
    x1 = rand(210..3800)
    y = rand(770..1800)
    y1 = rand(770..1800)

    x = rand(1..2) == 1 ? x : x1
    y = rand(1..2) == 1 ? y : y1

    arme.deplacer(x, y)

  end
end

require 'em/model/Entite'

def affiche(entite)
  puts " ----- Resume de l'entité ----- "
  puts "Vie de l'entité : " + entite.vie.to_s
  puts "Position de l'entité : (" + entite.position["x"].to_s + "," + entite.position["y"].to_s + ")"
  @Hitbox = entite.getHitboxAbs
  puts "Hitbox de l'entité :"
  puts "     Premier coin : (" + @Hitbox[0]["x"].to_s + "," + @Hitbox[0]["y"].to_s + ")"
  puts "     Deuxième coin : (" + @Hitbox[1]["x"].to_s + "," + @Hitbox[1]["y"].to_s + ")"
end

#--------------------Création------------------------------
vie= 20
pos_x= 100
pos_y= 100

puts "Création d'une entité de #{vie}HP, placée en (#{pos_x},#{pos_y})!" 
@test_entite = Entite.new(vie,pos_x,pos_y,10,10,30,30)
  
affiche(@test_entite)
  
puts ""
#--------------------Dégats------------------------------------
degats = 5
puts "On inflige  #{degats} dégats à l'entité!"
@test_entite.perdreVie(degats)

affiche(@test_entite)
  
puts ""
#----------------------Soins-----------------------------------
soin = 3
puts "On soigne l'entité de #{soin}HP!"
@test_entite.soigner(soin)

affiche(@test_entite)
  
puts ""
#---------------------------------------------------------------
dep_x = 20
dep_y = 40
puts "On déplace l'entité vers #{dep_x} en x, et #{dep_y} en y!"
#@test_entite.deplacer(dep_x,dep_y)

affiche(@test_entite)
  
puts ""
#---------------------------------------------------------------



#--------------------Création------------------------------
vie= 20
pos_x= 100
pos_y= 79

puts "Création d'une autre entité de #{vie}HP, placée en (#{pos_x},#{pos_y})!" 
@test_entite2 = Entite.new(vie,pos_x,pos_y,10,10,30,30)
  
affiche(@test_entite2)
  
puts ""

#---Test Collision
puts "Entité1 et Entité2 sont-ils en collision? : " + @test_entite.isCollidedTo(@test_entite2).to_s

puts ""


require 'em/model/Entite'

def affiche(entite)
  puts " ----- Resume de l'entité ----- "
  puts "Vie de l'entité : " + @test_entite.vie.to_s
  puts "Position de l'entité : (" + @test_entite.position["x"].to_s + "," + @test_entite.position["y"].to_s + ")"
  @Hitbox = @test_entite.getHitbox
  puts "Hitbox de l'entité :"
  puts "     Premier coin : (" + @Hitbox[0]["x"].to_s + "," + @Hitbox[0]["y"].to_s + ")"
  puts "     Deuxième coin : (" + @Hitbox[1]["x"].to_s + "," + @Hitbox[1]["y"].to_s + ")"
end

#--------------------Création------------------------------
vie= 20
pos_x= 100
pos_y= 100
dim_x= 20
dim_y= 20

puts "Création d'une entité de #{vie}HP, placée en (#{pos_x},#{pos_y}) et de dimension (#{dim_x},#{dim_y})!" 
@test_entite = Entite.new(20,100,100,20,20)
  
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
puts "On déplace l'entité de #{dep_x} en x, et #{dep_y} en y!"
@test_entite.deplacer(dep_x,dep_y)

affiche(@test_entite)
  
puts ""
#---------------------------------------------------------------
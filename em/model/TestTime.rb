require 'em/model/Effect'

starting_time = Time.now

while(Time.now - starting_time <5)
  
end

effet = Effect.getEffect(Effect::SLOW.name)
starting_time = effet.starting_time


while(!effet.isDone?)
  puts "Temps ecoulé = " + (Time.now - starting_time).to_s
end
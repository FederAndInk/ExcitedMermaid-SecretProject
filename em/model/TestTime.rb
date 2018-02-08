require 'em/model/Effect'

effet = Effect.getEffect(Effect::SLOW.name)
starting_time = effet.starting_time

while(!effet.isDone?)
  puts "Temps ecoulé = " + (Time.now - starting_time).to_s
end
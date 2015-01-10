# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
url = URI.parse("https://api.steampowered.com/IEconDOTA2_570/GetHeroes/v0001/?key=#{ENV['STEAM_WEB_API_KEY']}")
res = Net::HTTP::get(url)

heroes = JSON.load(res)['result']['heroes']

heroes.each do |hero|
  split_name = hero['name'].split('_')
  final_name = split_name - ['npc', 'dota', 'hero']
  final_name = final_name.join(' ')
  Hero.create(name: final_name, id: hero['id'])
end
# This ruby script uses an open API to return the people
# currently in space.
#
# Run it with the script "./whoInSpace.sh"

require 'net/http'
require 'json'

 # Get data from api
url = 'http://api.open-notify.org/astros.json'
uri = URI(url)
response = Net::HTTP.get(uri)

 # Parse data
json = JSON.parse(response)
count = json['number']
status = json['message']
people = json['people']

 # Error check on status
if status != 'success'
  puts "Data returned status of #{status}"
  exit
end

 # Error check on record size
if count.to_i != people.size
  puts "Data count mismatch:"
  puts "  count field returned "#{count}"
  puts "  but size of people object is "#{people.size}"
  exit
end

  # Find lengths of longest person and craft names
longest_name = 0
longest_craft = 0

people.each do |p|
  longest_name = p['name'].length if p['name'].length > longest_name
  longest_craft = p['craft'].length if p['craft'].length > longest_craft
end

name_str = 'Name'.ljust(longest_name,' ')
name_dashes = ''.ljust(longest_name,'-')
craft_str = 'Craft'.ljust(longest_craft,' ')
craft_dashes = ''.ljust(longest_craft,'-')

 # Output
puts "There are #{count} people in space right now:"
puts
puts "#{name_str} | #{craft_str}"
puts "#{name_dashes}-|-#{craft_dashes}"

people.each do |p|
  puts "#{p['name'].ljust(longest_name,' ')} | #{p['craft'].ljust(longest_craft,' ')}"
end

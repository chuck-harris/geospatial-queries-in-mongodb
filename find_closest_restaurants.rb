#!/usr/bin/ruby


require 'mongo'

client = Mongo::Client.new('mongodb://geocatering:Mango0523!@localhost:27017/geocater?retryWrites=true')
db = client.database

centers = client[:kidney_centers]
#centers = client[:amazon_centers]
restaurants = client[:restaurants]

centers.find( { 'state' => /.*/ }).each do |center|
  puts center

  nearby_restaurants_aggregate = restaurants.aggregate( [
                                { '$geoNear' => {
                                    'near' => center[:location],
                                    'maxDistance' => 32000,
                                    'spherical' => true,
                                    'distanceField' => "distance_in_miles",
                                    'distanceMultiplier' => 0.000621371
  }
  }
  ] )


  nearby_restaurants = Array.new
  nearby_restaurants_aggregate.each do |restaurant|
    puts restaurant
    nearby_restaurants << restaurant
  end


  centers.update_one( { '_id' => center[:_id]}, { '$set' => { 'nearby_restaurants' => nearby_restaurants }})

  puts "========================================================================================"
end


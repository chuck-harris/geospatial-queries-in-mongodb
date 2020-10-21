#!/usr/bin/ruby

require 'mongo'
require 'csv'

client = Mongo::Client.new('mongodb://geocatering:Mango0523!@localhost:27017/geocater?retryWrites=true')
db = client.database

kidney_centers = client[:kidney_centers]

CSV.open( 'kidney-centers-near-restaurants.csv', 'w') do |csv|

  header1 = Array::new
  header1 << "Kidney Centers"
  14.times { header1 << "" }

  header1 << "Kidney Center Geocode"
  15.times { header1 << "" }

  header1 << "Kidney Center Location"
  2.times { header1 << "" }

  header1 << "Nearest Restaurant"
  8.times { header1 << "" }

  csv << header1

  header2 = Array::new
  header2 << "MongoDB ID"
  header2 << "# of Dialysis Stations"
  header2 << "Address"
  header2 << "Certification or Recertification Date"
  header2 << "Chain Organization"
  header2 << "City"
  header2 << "County"
  header2 << "Facility Name"
  header2 << "Network"
  header2 << "Offers In-Center Hemodialysis"
  header2 << "Profit or Non-Profit"
  header2 << "Provider Number"
  header2 << "State"
  header2 << "Zip"
  header2 << ""

  header2 << "Address"
  header2 << "City"
  header2 << "State"
  header2 << "Zip"
  header2 << "Latitude"
  header2 << "Longitude"
  header2 << "Accuracy Score"
  header2 << "Accuracy Type"
  header2 << "Number"
  header2 << "Street"
  header2 << "Unit Type"
  header2 << "Unit Number"
  header2 << "County"
  header2 << "Country"
  header2 << "Source"
  header2 << ""

  header2 << "Type"
  header2 << "Coordinates"
  header2 << ""

  header2 << "Distance (Miles)"
  header2 << "RVP"
  header2 << "AD"
  header2 << "Restaurant #"
  header2 << "Name"
  header2 << "Address"
  header2 << "City"
  header2 << "State"
  header2 << "Zip"

  csv << header2

  kidney_centers.find( { 'nearby_restaurants.0' => { '$exists' => true } }).each do |center|
    puts center
    restaurant = center[:nearby_restaurants].first

    row = Array::new

    row << center["_id"]
    row << center["#_of_dialysis_stations"]
    row << center["address_line_1"]
    row << center["certification_or_recertification_date"]
    row << center["chain_orgainzation"]
    row << center["city"]
    row << center["county"]
    row << center["facility_name"]
    row << center["network"]
    row << center["offers_in_center_hemodialysis"]
    row << center["profit_or_non_profit"]
    row << center["provider_number"]
    row << center["state"]
    row << center["zip"]
    row << ""

    row << center["geocode"]["address_line_1"]
    row << center["geocode"]["city"]
    row << center["geocode"]["state"]
    row << center["geocode"]["zip"]
    row << center["geocode"]["latitude"]
    row << center["geocode"]["longitude"]
    row << center["geocode"]["accuracy_score"]
    row << center["geocode"]["accuracy_type"]
    row << center["geocode"]["number"]
    row << center["geocode"]["street"]
    row << center["geocode"]["unit_type"]
    row << center["geocode"]["unit_number"]
    row << center["geocode"]["county"]
    row << center["geocode"]["country"]
    row << center["geocode"]["source"]
    row << ""

    row << center["location"]["type"]
    row << center["location"]["coordinates"]
    row << ""

    row << center["nearby_restaurants"][0]["distance_in_miles"]
    row << center["nearby_restaurants"][0]["rvp"]
    row << center["nearby_restaurants"][0]["ad"]
    row << center["nearby_restaurants"][0]["restaurant_#"]
    row << center["nearby_restaurants"][0]["restaurant_name"]
    row << center["nearby_restaurants"][0]["address"]
    row << center["nearby_restaurants"][0]["city"]
    row << center["nearby_restaurants"][0]["state"]
    row << center["nearby_restaurants"][0]["zip"]



    #puts "----------------------------------------------------------------------------------------"

    #center[:nearby_restaurants].each do |restaurant|
      #puts restaurant
    #end

    csv << row

    #center.update( { '$set' => { 'nearby_restaurants' => nearby_restaurants }})

    #kidney_centers.update_one( { 'provider_number' => center[:provider_number]}, { '$set' => { 'nearby_restaurants' => nearby_restaurants }})

    puts "========================================================================================"
  end
end

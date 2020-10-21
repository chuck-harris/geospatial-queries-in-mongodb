#!/usr/bin/ruby

require 'json'
require 'csv'

class String
  def snakeCase
    self.gsub(/::/, '/').
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr("- ", "_").
        downcase
  end
end


#sourceFileName = "kidney-centers-1-2000.psv"
#geocodeFileName = "addresses-only-1-2000_geocodio_ea5784cc7e492f7aab816f6981d1768455c5debd.csv"
#outputFileName = "spliced-data.json"

if ARGV.size != 3 then
  print "ERROR: Must specify location_file geocode_file output_file\n"
  exit
end

sourceFileName = ARGV[0]
geocodeFileName = ARGV[1]
outputFileName = ARGV[2]

sourceLines = Array.new
geocodeLines = Array.new
File.open( sourceFileName ).each { |line| sourceLines << CSV.parse( line )[0] }
File.open( geocodeFileName ).each { |line| geocodeLines << CSV.parse( line )[0] }


if sourceLines.size != geocodeLines.size then
  print "Error: #{sourceFileName} is not the same size as #{geocodeFileName} (#{sourceLines.size} != #{geocodeLines.size})\n"
  exit
end

sourceFileColumns = sourceLines.shift.map{ |name| name.strip.gsub( '"', "" ).snakeCase }
geocodeFileColumns = geocodeLines.shift.map{ |name| name.strip.gsub( '"', "" ).snakeCase }

#print sourceFileColumns, "\n"
#print geocodeFileColumns
#
#
#print "#{sourceLines.size}\n"
#print "#{sourceLines[0]}\n"
#print "#{sourceLines[1]}\n"
#
#print "#{geocodeLines.size}\n"
#print "#{geocodeLines[0]}\n"
#print "#{geocodeLines[1]}\n"

documents = Array.new

geocodeLines.each_with_index do |line, index|
  if line.size != geocodeFileColumns.size then
    print "ERROR: Invalid number of columns in geocode file #{geocodeFileName} line #{index + 2}\n"
    exit
  end
end

sourceLines.each_with_index do |line,index|
  if line.size != sourceFileColumns.size then
      print "ERROR: Invalid number of columns in source file #{sourceFileName} line #{index + 2} ( #{line.size} != #{sourceFileColumns.size})\n"
      exit
  end
  document = Hash[sourceFileColumns.zip( line.map{ |value| !value.nil? && value.strip})]
  geocodeSubdocument = Hash[geocodeFileColumns.zip( geocodeLines[index].map{ |value| !value.nil? && value.strip})]
  document["geocode"] = geocodeSubdocument
  geoJsonPoint = { "type" => "Point", "coordinates" => [ geocodeSubdocument["longitude"].to_f, geocodeSubdocument[ "latitude"].to_f] }
  document["location"] = geoJsonPoint

  documents << document
end

File.open( outputFileName, "w" ).write( JSON.pretty_generate documents )


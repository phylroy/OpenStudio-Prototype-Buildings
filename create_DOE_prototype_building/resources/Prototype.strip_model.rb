require 'openstudio'
<<<<<<< HEAD
require_relative 'Prototype.utilities'

full_filename = ARGV[0]

if full_filename && (File.file?(full_filename) || File.file?(File.join(Dir.pwd, full_filename)))
	model = safe_load_model(full_filename)

	model = strip_model(model)

	new_path = OpenStudio::Path.new("#{Dir.pwd}/stripped_model.osm")

	model.save(new_path, true)

	puts "Stripped model was saved to #{new_path}"
else
	puts "Pass a valid file path to this script"
end
=======
require_relative 'prototype.utilities'

folder = "C:/Users/yixing/Dropbox/LBNL/10.OSM reference buildings/Hotel Large/IDF for geometry/"

filenames = ["ASHRAE90.1_HotelLarge_STD2007_San_Francisco", "ASHRAE90.1_HotelLarge_STD2010_San_Francisco", "ASHRAE90.1_HotelLarge_STD2013_San_Francisco","RefBldgLargeHotelPost1980_v1.4_7.2_3C_USA_CA_SAN_FRANCISCO"]

filenames.each do |filename|
  model = safe_load_model(folder + filename + ".osm")

  model = strip_model(model)

  new_path = OpenStudio::Path.new(filename + ".osm")
  model.save(new_path, true)

  puts "Stripped model was saved to #{filename}.osm"
end

>>>>>>> master

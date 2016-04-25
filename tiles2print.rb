# tiles2print.rb
require 'rmagick'
require 'csv'
include Magick

# CONSTANTS
output_dir = "output"
mbhost = 'http://localhost:3001'
tmstyle = '/Users/jeff/code/mb-classic-hikeOSM-print.tm2'
zoom = 15
#multiplier = 2.078125
multiplier = 1.0390625

csv_file = ARGV[0]

# Process for each entry in CSV file
CSV.foreach(csv_file) do |row|
	# Get the data from CSV
	name = row[0]
	west = row[1]
	south = row[2]
	east = row[3]
	north = row[4]

	# This is the link for making map in MB Studio Classic	
	mb_link = mbhost + "/static/#{zoom}/#{west},#{south},#{east},#{north}@#{multiplier}x.png?id=tmstyle://" + tmstyle

	# Call Mapbox Studio Classic and get the image
	#system("wget #{mb_link} -O #{output_dir}/#{name}.png")

	# Load the image and add a white border
	img = Magick::Image::read("#{output_dir}/#{name}.png").first
	img.format = "PNG"
	img.border!(300,300,"white")

	txt = Draw.new
	txt.font_family = "arial"
	txt.font = "fonts/Arial.ttf"
	txt.pointsize = 20
	txt.stroke = "#000000"
	txt.font_weight = 100
	# Add name to map
	img.annotate(txt, 0,0,0,150, name){
		txt.gravity = Magick::NorthGravity
		txt.pointsize = 54
	}
	# Add west coordinates to map
	img.annotate(txt, 0,0,260,220, "#{west}\xC2\xB0 E"){
		txt.gravity = Magick::SouthWestGravity
		txt.pointsize = 20
	}
	img.annotate(txt, 0,0,260,220, "#{west}\xC2\xB0 E"){
		txt.gravity = Magick::NorthWestGravity
	}
	# Add east coordinates to map
	img.annotate(txt, 0,0,260,220, "#{east}\xC2\xB0 E"){
		txt.gravity = Magick::SouthEastGravity
	}
	img.annotate(txt, 0,0,260,220, "#{east}\xC2\xB0 E"){
		txt.gravity = Magick::NorthEastGravity
	}
	# Add north coordinates to map
	img.annotate(txt, 0,0,150,290, "#{north}\xC2\xB0 N"){
		txt.gravity = Magick::NorthWestGravity
	}
	img.annotate(txt, 0,0,150,290, "#{north}\xC2\xB0 N"){
		txt.gravity = Magick::NorthEastGravity
	}
	# Add south coordinates to map
	img.annotate(txt, 0,0,150,290, "#{south}\xC2\xB0 N"){
		txt.gravity = Magick::SouthWestGravity
	}
	img.annotate(txt, 0,0,150,290, "#{south}\xC2\xB0 N"){
		txt.gravity = Magick::SouthEastGravity
	}

	# Now draw the lines
	line = Draw.new
	line.stroke('black')
	# Top line
	line.line(250, 299, img.columns-250, 299)
	line.draw(img)
	# Bottom line
	line.line(250, img.rows-299, img.columns-250, img.rows-299)
	line.draw(img)
	# Left line
	line.line(299, 250, 299, img.rows-250)
	line.draw(img)
	# Right line
	line.line(img.columns-299, 250, img.columns-299, img.rows-250)
	line.draw(img)


	img.write('test.png')
	# send_data img.to_blob, :stream => 'false', :filename => 'test.jpg', :type => 'image/jpeg', :disposition => 'inline'
	# watermark_text.annotate(img, 0,0,0,0, "foo bar bla") do
	# 	watermark_text.gravity = CenterGravity
	# 	self.pointsize = 50
	# 	self.font_family = "Arial"
	# 	self.font_weight = BoldWeight
	# 	self.stroke = "none"
	# end


	# Load map image into rmagick
	# mapImage = ImageList.new("#{output_dir}/#{name}.png")
	# mapWidth = mapImage.columns
	# mapHeight = mapImage.rows
	# print mapWidth
	# print mapHeight

	# Create new image, padding everything by 600px (assuming 300DPI, ie 2 inches on all sides)
	# newImage = Image.new(mapWidth+600,mapHeight+600)
	# newImage.write("newImage.png")
	# newList = ImageList.new("newImage.png")

	# Combine images
	# newStuff = newList.composite_layers(mapImage, operator=OverCompositeOp)
	# newStuff.write('ok.png')





	#list = ImageList.new(mapImage, newImage)
	# print mapImage.width

# Create a 100x100 red image.
# f = Image.new(100,100) { self.background_color = "red" }
# f.display
# exit


end

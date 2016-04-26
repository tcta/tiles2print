##################
# tiles2print.rb #
##################
# This utility outputs PDFs of a given set of areas (currently configured to work with Soviet quadrangles)
#  in 1:50000 and 1:25000 scales

require 'rmagick'
require 'csv'
include Magick

# CONSTANTS
output_dir = "output"
mbhost = 'http://localhost:3000'
tmstyle = '/Users/jeff/code/mb-classic-hikeOSM-print.tm2'
zoom50 = 14
zoom25 = 15
ptHeight50 = 1077 # This is the point height of the 50k PDF map - 8cm = 14.96in = 1077pts in PDFs; as there appears to be 19km distance from north to south - note this could be improved with more precise geocalculations
ptHeight25 = 2154
multiplier = 1.0390625 * 2 # increase this number to increase output resolution

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
	mb_link50 = mbhost + "/static/#{zoom50}/#{west},#{south},#{east},#{north}@#{multiplier}x.png?id=tmstyle://" + tmstyle
	mb_link25 = mbhost + "/static/#{zoom25}/#{west},#{south},#{east},#{north}@#{multiplier}x.png?id=tmstyle://" + tmstyle

	# Call Mapbox Studio Classic and get the images
	system("wget #{mb_link50} -O #{output_dir}/#{name}-50k.png")
	system("wget #{mb_link25} -O #{output_dir}/#{name}-25k.png")

	# Load the images and add a white border
	img50 = Magick::Image::read("#{output_dir}/#{name}-50k.png").first
	img25 = Magick::Image::read("#{output_dir}/#{name}-25k.png").first
	
	# Get the proportion of the images (x/y)
	img50Cols = img50.columns
	img50Rows = img50.rows
	proportion50 = (img50.columns.to_f/img50.rows.to_f)
	img25Cols = img25.columns
	img25Rows = img25.rows
	proportion25 = (img25.columns.to_f/img25.rows.to_f)

	# Add a border to the images
	img50.format = "PNG"
	img50.border!(300,300/proportion50,"white")
	img25.format = "PNG"
	img25.border!(300,300/proportion25,"white")

	# Get the y placement for horizontal lines and text (this changes based on latitude)
	yLine = 299/proportion50

	# Set up text object
	txt = Draw.new
	txt.font_family = "arial"
	txt.font = "fonts/Arial.ttf"
	txt.pointsize = 20
	txt.stroke = "#000000"
	txt.font_weight = 100
	# Add text to 50k image
	# Add name to map
	img50.annotate(txt, 0,0,0,150, name){
		txt.gravity = Magick::NorthGravity
		txt.pointsize = 54
	}
	# Add scale to map
	img50.annotate(txt, 0,0,0,150, "Scale: 1:50000\n1cm = 500m"){
		txt.gravity = Magick::SouthGravity
		txt.pointsize = 36
	}
	# Add west coordinates to map
	img50.annotate(txt, 0,0,260,220, "#{west}\xC2\xB0 E"){
		txt.gravity = Magick::SouthWestGravity
		txt.pointsize = 20
	}
	img50.annotate(txt, 0,0,260,220, "#{west}\xC2\xB0 E"){
		txt.gravity = Magick::NorthWestGravity
	}
	# Add east coordinates to map
	img50.annotate(txt, 0,0,260,220, "#{east}\xC2\xB0 E"){
		txt.gravity = Magick::SouthEastGravity
	}
	img50.annotate(txt, 0,0,260,220, "#{east}\xC2\xB0 E"){
		txt.gravity = Magick::NorthEastGravity
	}
	# Add north coordinates to map
	img50.annotate(txt, 0,0,150,yLine-10, "#{north}\xC2\xB0 N"){
		txt.gravity = Magick::NorthWestGravity
	}
	img50.annotate(txt, 0,0,150,yLine-10, "#{north}\xC2\xB0 N"){
		txt.gravity = Magick::NorthEastGravity
	}
	# Add south coordinates to map
	img50.annotate(txt, 0,0,150,yLine-10, "#{south}\xC2\xB0 N"){
		txt.gravity = Magick::SouthWestGravity
	}
	img50.annotate(txt, 0,0,150,yLine-10, "#{south}\xC2\xB0 N"){
		txt.gravity = Magick::SouthEastGravity
	}
	# Add text to 25k image
	# Add name to map
	img25.annotate(txt, 0,0,0,150, name){
		txt.gravity = Magick::NorthGravity
		txt.pointsize = 54
	}
	# Add scale to map
	img25.annotate(txt, 0,0,0,150, "Scale: 1:25000\n1cm = 250m"){
		txt.gravity = Magick::SouthGravity
		txt.pointsize = 36
	}
	# Add west coordinates to map
	img25.annotate(txt, 0,0,260,220, "#{west}\xC2\xB0 E"){
		txt.gravity = Magick::SouthWestGravity
		txt.pointsize = 20
	}
	img25.annotate(txt, 0,0,260,220, "#{west}\xC2\xB0 E"){
		txt.gravity = Magick::NorthWestGravity
	}
	# Add east coordinates to map
	img25.annotate(txt, 0,0,260,220, "#{east}\xC2\xB0 E"){
		txt.gravity = Magick::SouthEastGravity
	}
	img25.annotate(txt, 0,0,260,220, "#{east}\xC2\xB0 E"){
		txt.gravity = Magick::NorthEastGravity
	}
	# Add north coordinates to map
	img25.annotate(txt, 0,0,150,yLine-10, "#{north}\xC2\xB0 N"){
		txt.gravity = Magick::NorthWestGravity
	}
	img25.annotate(txt, 0,0,150,yLine-10, "#{north}\xC2\xB0 N"){
		txt.gravity = Magick::NorthEastGravity
	}
	# Add south coordinates to map
	img25.annotate(txt, 0,0,150,yLine-10, "#{south}\xC2\xB0 N"){
		txt.gravity = Magick::SouthWestGravity
	}
	img25.annotate(txt, 0,0,150,yLine-10, "#{south}\xC2\xB0 N"){
		txt.gravity = Magick::SouthEastGravity
	}

	# Now draw the lines on 50k
	line = Draw.new
	line.stroke('black')
	# Top line
	line.line(250, yLine, img50.columns-250, yLine)
	line.draw(img50)
	# Bottom line
	line.line(250, img50.rows-yLine, img50.columns-250, img50.rows-yLine)
	line.draw(img50)
	# Left line
	line.line(299, 250, 299, img50.rows-250)
	line.draw(img50)
	# Right line
	line.line(img50.columns-299, 250, img50.columns-299, img50.rows-250)
	line.draw(img50)
	
	# Now draw the lines on 25k
	line = Draw.new
	line.stroke('black')
	# Top line
	line.line(250, yLine, img25.columns-250, yLine)
	line.draw(img25)
	# Bottom line
	line.line(250, img25.rows-yLine, img25.columns-250, img25.rows-yLine)
	line.draw(img25)
	# Left line
	line.line(299, 250, 299, img25.rows-250)
	line.draw(img25)
	# Right line
	line.line(img25.columns-299, 250, img25.columns-299, img25.rows-250)
	line.draw(img25)

	# Output to make sure everything looks good
	#img50.write('test50.png')
	#img25.write('test25.png')

	# Now set up PDFs
	img50.format = "PDF"
	img25.format = "PDF"

	# First do 50k
	y = ptHeight50
	x = y * proportion50
	pix2point = (img50Rows/y.to_f)
	newX = img50.columns/pix2point
	newY = img50.rows/pix2point
	puts newX
	puts newY
	rect = Rectangle.new(newX, newY, 0, 0)
	img50.page = rect
	img50.write("#{output_dir}/#{name}-50k.pdf")

	# And 25k
	y = ptHeight25
	x = y * proportion25
	pix2point = (img25Rows/y.to_f)
	newX = img25.columns/pix2point
	newY = img25.rows/pix2point
	puts newX
	puts newY
	rect = Rectangle.new(newX, newY, 0, 0)
	img25.page = rect
	img25.write("#{output_dir}/#{name}-25k.pdf")



end

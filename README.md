# tiles2print
A utility for creating ready to print maps (and geoPDFs) from Mapbox Studio Classic

- Requires Mapbox Studio Classic
- Designed to work with our mb-classic-hikeOSM-print.tm2 style 
- Currently outputs at 1:50000 scale and 1:25000 scale (the 1:25000 print is twice as big, covers same area)
- Creates a map with a border that includes coordinates (matching the style gridlines) and title
- Outputs as PNG and PDF (TODO: convert to geoPDF)
- Can be quickly re-run to incorporate new changes in OpenStreetMap

### Setup
First, download and Install Mapbox Studio Classic (https://www.mapbox.com/mapbox-studio-classic/)

> The Installer from the link above does not work for us as expected. You can test if it will work by
> starting Mapbox Studio Classic and then opening your web browser to http://localhost:3000/. If you 
> see MB Studio in your browser, then this utility should be fine. If not, install from source like this:

Install node v0.10.x. (0.10.33 seems to work best). Then:

	git clone https://github.com/mapbox/mapbox-studio-classic.git
	cd mapbox-studio-classic
	npm install
	npm start

Now it should open in your web browser at http://localhost:3000/

MB Studio Classic must be running for this utility to work.

The utility requires ruby 1.9.x. If you are using rbenv to manage versions of ruby, you may need to switch to the correct version, ie:

	rbenv local 1.9.3-p547 

You also need ImageMagick, and the RMagick gem. This can be a pain if not done right. On OS X it seems easiest to use Homebrew:

	brew install ImageMagick
	gem install rmagick

Also seem to need ghostscript. On OS X install with Homebrew:

	brew install gs

Next clone this repo:

	git clone https://github.com/tcta/tiles2print.git

Test it:

	cd tiles2print/
	ruby tile2print.rb csv/test.csv

This should output several pretty maps in output/


### Projection and Coordinates
Unfortunately Mapbox tiles only come in Web Mercator projection, which does not lend itself very well to orientation on printed maps. To deal with the issue of orientation there are two means of orientation on these maps. The first are grid lines which are part of the hikeOSM-print style - these are approximately 1000 meters apart, close enough to be used as a measurement guide. (Note that the data itself is spaced 1330 meters apart - this is because in Mercator projection 1330 meters at the equator is equal to about 1000 meters in the Caucasus. You don't need to know this, just know that the lines appear 1000 meters apart.) The second means of orientation are the lat/lon coordinates, which are printed around the map. These do not necessarily line up with the gridlines, but can be used to orientate oneself based on lat/lon coordinates.

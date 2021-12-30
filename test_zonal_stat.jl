
using Markdown
using InteractiveUtils

using GeoDataFrames; const GDF=GeoDataFrames
using DataFrames
using Rasters
using Statistics
using GeoStats
using Dates

md"""
# Open the vector geojson files for the villages in Taiwan
- filter villages in Wufeng/Taichung
"""

startTime = now()

villages = GDF.read("./村里界圖20140313.json")
villages_taichung = villages[villages.COUNTYNAME .== "臺中市", :]
villages_wufeng = villages_taichung[villages_taichung.TOWNNAME .== "霧峰區", :]

md"""
# Open DEM for that area
"""

dem_path = "./DEM/n24_e120_1arc_v3.tif"
dem_model = Raster(dem_path)
mean_hight_wufeng = map(x -> mean(skipmissing(replace_missing(mask(dem_model; to=x)))), villages_wufeng.geom)
println((now() - startTime) / convert(Millisecond,Second(1)))

md"""
# Second Time
"""

startTime = now()
localStartTime = startTime

villages = GDF.read("./村里界圖20140313.json")
villages_taichung = villages[villages.COUNTYNAME .== "臺中市", :]
villages_wufeng = villages_taichung[villages_taichung.TOWNNAME .== "霧峰區", :]

print("Loading and FIltering Esri Shape File took: ")
println((now() - localStartTime) / convert(Millisecond,Second(1)))


md"""
# Open DEM for that area
"""
localStartTime = now()
dem_path = "./DEM/n24_e120_1arc_v3.tif"
dem_model = Raster(dem_path)
print("Opening the raster took: ")
println((now() - localStartTime) / convert(Millisecond,Second(1)))

localStartTime = now()
mean_height_wufeng = map(x -> mean(skipmissing(replace_missing(mask(dem_model; to=x)))), villages_wufeng.geom)
print("Zonal stat took: ")
println((now() - localStartTime) / convert(Millisecond,Second(1)))

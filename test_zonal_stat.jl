
using Markdown
using InteractiveUtils

using GeoDataFrames; const GDF=GeoDataFrames
using DataFrames
using BenchmarkTools
using Rasters
using Statistics
using GeoStats
using Dates
using ThreadTools
md"""
# Open the vector geojson files for the villages in Taiwan
- filter villages in Wufeng/Taichung
"""

villages = GDF.read("./村里界圖20140313.json")
@btime GDF.read("./村里界圖20140313.json")
villages_taichung = villages[villages.COUNTYNAME .== "臺中市", :]
villages_wufeng = villages_taichung[villages_taichung.TOWNNAME .== "霧峰區", :]


md"""
# Open DEM for that area
"""
dem_path = "./DEM/n24_e120_1arc_v3.tif"
dem_model = read(Raster(dem_path))
@btime read(Raster(dem_path))

mean_height_wufeng = tmap(x -> mean(skipmissing(replace_missing(mask(dem_model; to=x)))), villages_wufeng.geom)
@btime tmap(x -> mean(skipmissing(replace_missing(mask(dem_model; to=x)))), villages_wufeng.geom)

insertcols!(villages_wufeng, 1, :mean_heigth => mean_height_wufeng)
GDF.write("wufeng.gpkg", villages_wufeng)

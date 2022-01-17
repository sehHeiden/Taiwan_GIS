
using Markdown
using InteractiveUtils

using GeoDataFrames; const GDF=GeoDataFrames
using DataFrames
using BenchmarkTools
using Rasters
using Statistics
using ThreadTools

println(" nthreads = ", Threads.nthreads())

# Define a `zonal` function to do arbitrary zonal stats (should we include this in Rasters.jl?)
zonal(f, raster, geom) = map(x -> f(skipmissing(mask(crop(dem_model; to=x); with=x))), geom)

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

dem_models = map(x->read(Raster(x)), filter(x->occursin("n24", x),readdir("./DEM"; join=true)))
dem_mosaic = mosaic(first, dem_models...)
@btime mosaic(first, dem_models...)

# But this is MUCH faster. Rasters.jl could detect that
# these are tiles that match and dont overlap,
# and use `cat` for `mosaic` as well.
dem_mosaic = cat(dem_models...; dims=X)
@btime dem_mosaic = cat(dem_models...; dims=X)

mean_height_wufeng = zonal(mean, dem_mosaic, villages_wufeng.geom)
@btime mean_height_wufeng = zonal(mean, $dem_mosaic, $villages_wufeng.geom)

insertcols!(villages_wufeng, 1, :mean_heigth => mean_height_wufeng)
GDF.write("wufeng.gpkg", villages_wufeng)

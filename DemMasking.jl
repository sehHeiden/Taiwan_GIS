### A Pluto.jl notebook ###
# v0.14.0

using Markdown
using InteractiveUtils

# ╔═╡ 89a80da2-67c3-11ec-3332-19a75e4ba319
using GeoDataFrames; const GDF=GeoDataFrames
using DataFrames
using Rasters
using Statistics
using ThreadTools
using ArchGDAL

# ╔═╡ 3f264d56-6972-11ec-172b-71296aac93c5
md"""
# Open the vector geojson files for the villages in Taiwan
- filter villages in Wufeng/Taichung
"""

# ╔═╡ ce0cf89e-67c4-11ec-2610-19c12302f980
villages = GDF.read("./村里界圖20140313.json")

# ╔═╡ e37b37dc-67c3-11ec-2188-c5374a278014
villages_taichung = villages[villages.COUNTYNAME .== "臺中市", :]

# ╔═╡ 13891152-67e1-11ec-3d02-6d81250159e4
villages_wufeng = villages_taichung[villages_taichung.TOWNNAME .== "霧峰區", :]

# ╔═╡ 8a2ce8fa-6972-11ec-081f-174ec3151939
md"""
# Open DEM for that area
"""

# ╔═╡ 02e73622-67db-11ec-0227-5711068a2c47
dem_path = "./DEM/n24_e120_1arc_v3.tif"
dem_model = read(Raster(dem_path))
dem_models = (map(x->read(Raster(x)),
		               filter(x->occursin("n24", x), 
		                      readdir("./DEM"; join=true))))
typeof(dem_models)

# ╔═╡ b460e7d6-6c13-11ec-3309-11f1f5a5433e
dem_mosaic = mosaic(first, dem_models...)

# ╔═╡ 7acc64dc-67e0-11ec-3219-73cee8bd8999
mean_hight_wufeng = tmap(x -> mean(skipmissing(replace_missing(mask(dem_model; to=x)))), 
	villages_wufeng.geom)

# ╔═╡ 95eb9ce0-7151-11ec-372f-47bc4ed3d051


# ╔═╡ 42e40a26-6d89-11ec-288d-0dbbff7b94bf
difference(villages_wufeng.geom[1], villages_wufeng.geom[2],)

# ╔═╡ d1364702-7094-11ec-2e41-ab4946b741c6


# ╔═╡ ae34bc06-7097-11ec-1615-95c1b7f0dd75
closerings!(villages_wufeng.geom[1])

# ╔═╡ 4dbead78-7150-11ec-222e-85c6d0114a46


# ╔═╡ 49efc51c-7150-11ec-0005-3d3583473a69
union(villages_wufeng.geom)          

# ╔═╡ 451e41c6-7150-11ec-2cbc-bbaa1b7d14ff


# ╔═╡ c8bafbda-7097-11ec-1401-c36dc61cece8


# ╔═╡ Cell order:
# ╠═89a80da2-67c3-11ec-3332-19a75e4ba319
# ╠═3f264d56-6972-11ec-172b-71296aac93c5
# ╠═ce0cf89e-67c4-11ec-2610-19c12302f980
# ╠═e37b37dc-67c3-11ec-2188-c5374a278014
# ╠═13891152-67e1-11ec-3d02-6d81250159e4
# ╠═8a2ce8fa-6972-11ec-081f-174ec3151939
# ╠═02e73622-67db-11ec-0227-5711068a2c47
# ╠═b460e7d6-6c13-11ec-3309-11f1f5a5433e
# ╠═7acc64dc-67e0-11ec-3219-73cee8bd8999
# ╠═95eb9ce0-7151-11ec-372f-47bc4ed3d051
# ╠═42e40a26-6d89-11ec-288d-0dbbff7b94bf
# ╠═d1364702-7094-11ec-2e41-ab4946b741c6
# ╠═ae34bc06-7097-11ec-1615-95c1b7f0dd75
# ╠═4dbead78-7150-11ec-222e-85c6d0114a46
# ╠═49efc51c-7150-11ec-0005-3d3583473a69
# ╠═451e41c6-7150-11ec-2cbc-bbaa1b7d14ff
# ╠═c8bafbda-7097-11ec-1401-c36dc61cece8

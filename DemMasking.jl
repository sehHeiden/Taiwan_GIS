### A Pluto.jl notebook ###
# v0.14.0

using Markdown
using InteractiveUtils

# ╔═╡ 89a80da2-67c3-11ec-3332-19a75e4ba319
using GeoDataFrames; const GDF=GeoDataFrames
using DataFrames
using Rasters
using Statistics
using GeoStats
using Dates

# ╔═╡ 3f264d56-6972-11ec-172b-71296aac93c5
md"""
# Open the vector geojson files for the villages in Taiwan
- filter villages in Wufeng/Taichung
"""

# ╔═╡ f4a5b9f4-6973-11ec-2374-ff6aa73d30d4
startTime = now()

# ╔═╡ ce0cf89e-67c4-11ec-2610-19c12302f980
villages = GDF.read("/home/sebastian/Dokumente/Programmierung/Julia/Taiwan_GIS/村里界圖20140313.json")

# ╔═╡ e37b37dc-67c3-11ec-2188-c5374a278014
villages_taichung = villages[villages.COUNTYNAME .== "臺中市", :]

# ╔═╡ 13891152-67e1-11ec-3d02-6d81250159e4
villages_wufeng = villages_taichung[villages_taichung.TOWNNAME .== "霧峰區", :]

# ╔═╡ 8a2ce8fa-6972-11ec-081f-174ec3151939
md"""
# Open DEM for that area
"""

# ╔═╡ 02e73622-67db-11ec-0227-5711068a2c47
dem_path = "/home/sebastian/Dokumente/Programmierung/Julia/Taiwan_GIS/DEM/n24_e120_1arc_v3.tif"
dem_modell = Raster(dem_path)

# ╔═╡ 4450cc78-67e4-11ec-1354-7be7e9300f50
masked_dem = trim(mask(dem_modell; to=villages_wufeng.geom[1]))

# ╔═╡ 30771ef0-67df-11ec-0cb0-cd1c74499b2e
v2 = mean(skipmissing(replace_missing(masked_dem)))

# ╔═╡ 7acc64dc-67e0-11ec-3219-73cee8bd8999
mean_hight_wufeng = map(x -> mean(skipmissing(replace_missing(mask(dem_modell; to=x)))), 
	villages_wufeng.geom)

# ╔═╡ 7c788ff6-67e3-11ec-36bb-ed4cc01a3a3a
(now() - startTime) / convert(Millisecond,Second(1))

# ╔═╡ Cell order:
# ╠═89a80da2-67c3-11ec-3332-19a75e4ba319
# ╠═3f264d56-6972-11ec-172b-71296aac93c5
# ╠═f4a5b9f4-6973-11ec-2374-ff6aa73d30d4
# ╠═ce0cf89e-67c4-11ec-2610-19c12302f980
# ╠═e37b37dc-67c3-11ec-2188-c5374a278014
# ╠═13891152-67e1-11ec-3d02-6d81250159e4
# ╠═8a2ce8fa-6972-11ec-081f-174ec3151939
# ╠═02e73622-67db-11ec-0227-5711068a2c47
# ╠═4450cc78-67e4-11ec-1354-7be7e9300f50
# ╠═30771ef0-67df-11ec-0cb0-cd1c74499b2e
# ╠═7acc64dc-67e0-11ec-3219-73cee8bd8999
# ╠═7c788ff6-67e3-11ec-36bb-ed4cc01a3a3a

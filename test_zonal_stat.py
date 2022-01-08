from rioxarray import open_rasterio
from rioxarray.merge import merge_arrays
import geopandas as gpd
from rasterstats import zonal_stats
from time import time
from pathlib import Path


starttime = time()
villages = gpd.read_file("村里界圖20140313.json")
print(f"Loading vector takes {time() - starttime} s.")
villages_taichung = villages.loc[villages.COUNTYNAME == "臺中市", :]
villages_wufeng = villages_taichung.loc[villages_taichung.TOWNNAME == "霧峰區", :]

dem_path = r"./DEM/n24_e120_1arc_v3.tif"
starttime = time()
dem_model = open_rasterio(dem_path)
print(f"Loading raster takes {time() - starttime} s.")

dem_models = [open_rasterio(x) for x in Path("./DEM").iterdir() if "n24" in x.stem]
starttime = time()
dem_mosaic = merge_arrays(dem_models, method='first')
print(f"Merging 2 raster takes {time() - starttime} s.")

starttime = time()
mean_height_wufeng = zonal_stats(villages_wufeng.geometry, dem_model.data[0], stats=['mean', ],
                                 all_touched='false', affine=dem_model.rio.transform(), nodata=dem_model.rio.nodata)

print(f"Zonal stat takes {time() - starttime} s.")
mean_height_wufeng = [x['mean'] for x in mean_height_wufeng]

## pprint(mean_height_wufeng)

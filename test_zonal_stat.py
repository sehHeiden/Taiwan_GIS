from rioxarray import open_rasterio
import geopandas as gpd
from rasterstats import zonal_stats
from datetime import datetime
from pprint import pprint

startTime = datetime.now()

villages = gpd.read_file("村里界圖20140313.json")
villages_taichung = villages.loc[villages.COUNTYNAME == "臺中市", :]
villages_wufeng = villages_taichung.loc[villages_taichung.TOWNNAME == "霧峰區", :]

dem_path = r"./DEM/n24_e120_1arc_v3.tif"
dem_model = open_rasterio(dem_path)
mean_height_wufeng = zonal_stats(villages_wufeng.geometry, dem_model.data[0], stats=['mean', ],
                                 all_touched='false', affine=dem_model.rio.transform(), nodata=dem_model.rio.nodata)
mean_height_wufeng = [x['mean'] for x in mean_height_wufeng]
pprint(mean_height_wufeng)
print(datetime.now() - startTime)

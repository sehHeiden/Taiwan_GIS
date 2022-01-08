# Compare Execution time Python / Julia for Raster processing / zonal stat

using btime from BenchmarkTools.

|                          | Python | Julia | Speed-up |
|--------------------------|--------|-------|----------|
| unit                     | s      | s     |          |
| Loading vector (geojson) | 10.70  | 14.18 | 0.72     |
| Loading raster (tif)     | 0.0366 | 0.107 | 0.34     |
| Merging 2 raster         | 0.206  | 85.75 | 0.00024  |
| Zonal stat               | 0.520  | 94.64 | 0.0055   |

# Functions on Polygons
using Geopandas Series as [Pandas](https://geopandas.org/en/stable/docs/reference/geoseries.html)
(which applies the Shapely methods on the whole series).
None primary predicates exists. 

|           |                                                                             | binary predictors                                                                | set methods                 | constructive methods            |
|-----------|-----------------------------------------------------------------------------|----------------------------------------------------------------------------------|-----------------------------|---------------------------------|
| found     | boundary, distance                                                          | crosses, disjoint, intersects, overlaps , touches, within                        | difference, intersection    | buffer, boundary, centroid      |
| not found | area, bounds, total_bounds, length, geom_type, exterior, interiors, x, y, z | contains, geom_equals, geom_almost_equals, geom_equals_exact, covers, covered_by | symmetric_difference, union | convex_hull, envelope, simplify |   

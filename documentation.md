# Compare Execution time Python / Julia for Raster processing / zonal stat

using btime from BenchmarkTools for Julia and time in Python using the medium time of three runs.
I only see the speed-up while loading the vector on Windows, on Linux it seams to be slower.

|                          | Python | Julia  | Speed-up |
|--------------------------|--------|--------|----------|
| unit                     | s      | s      |          |
| Loading vector (geojson) | 18.15  | 11.07  | 1.55     |
| Loading raster (tif)     | 0.0330 | 0.0915 | 0.36     |
| Merging 2 raster         | 0.176  | 18.71  | 0.009    |
| Zonal stat               | 0.1070 | 44.22  | 0.0024   |

# Functions on Polygons
using [ArchGDAL](https://yeesian.com/ArchGDAL.jl/stable/geometries/#Immutable-Operations-2) as reference.

## Unary
Why union here?

|           | attributes                     | predicates       | Immutable Operations                           | mutable Operations |
|-----------|--------------------------------|------------------|------------------------------------------------|--------------------|
| found     | geomlength, geomarea           | issimple, isring | boundary,      convexhull   , buffer, centroid |                    |
| not found | geomdim, getcoorddim, envelope | isempty, isvalid | simplify, union                                | closerings!        |  


## Binary

|           | predictors                                                                 | Immutable Operations                      |
|-----------|----------------------------------------------------------------------------|-------------------------------------------|
| found     | intersects, equals, disjoint, touches, crosses, within, contains, overlaps | intersection, difference  , symdifference |
| not found |                                                                            | union                                     | 


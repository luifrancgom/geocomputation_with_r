# Load packages ----
library(sf)
library(spData)
library(spDataLarge)
library(tidyverse)
library(sfheaders)
library(terra)

# sf objects ----
class(world)
names(world)

# Visualization ----
plot(world)
plot(world, max.plot = 9)

# Summary ----
world["lifeExp"] |>
  summary()

world_mini <- world[1:2, 1:3]
world_mini

world$geom |>
  class()

# Tidyverse: st_read vs read_sf ----
world_dfr <- system.file(
  "shapes/world.gpkg",
  package = "spData"
) |>
  st_read()

world_tbl <- system.file(
  "shapes/world.gpkg",
  package = "spData"
) |>
  read_sf()

class(world_dfr)
class(world_tbl)

## Check this ----
world_tbl |>
  slice_head(n = 2) |>
  select(iso_a2, name_long) |>
  class()

### Basic maps ----

methods(plot)[methods(plot) == "plot.sf"]
world_asia <- world[world$continent == "Asia", ]
asia <- st_union(world_asia)
asia
plot(asia)

plot(world["continent"], reset = FALSE)

plot(world["continent"], reset = FALSE)
cex <- sqrt(world$pop) / 10000
# st_centroid: gives the centroid of a geometry
# for of_largest = TRUE it tells find the largest
# landmass (the mainland) and put the point in the
# center of that
# Many countries are multipoligons so by default a
# centroid might end up in the ocean between the
# mainland and an island
world_cents <- st_centroid(world, of_largest_polygon = TRUE)
plot(st_geometry(world_cents), add = TRUE, cex = cex)

world_cents |>
  glimpse()

india = world[world$name_long == "India", ]
# st_geometry: in this case the idea is to
# get the geometry from an sf object.
plot(st_geometry(india))

plot(
  st_geometry(india),
  lwd = 3,
  col = "gray",
  # c(bottom, left, top, right)
  # In that way you can expand the
  # boundaries of the map
  ## 0: No extra space at the bottom
  ## 0.2: Add 20% extra space to the left
  ## 0.1 :Add 10% extra space to the top
  ## 1: Add 100% extra space to the right
  expandBB = c(0, 0.2, 0.1, 1)
)
plot(st_geometry(world_asia), add = TRUE)

#### Using ggplot2 ----
asia |>
  ggplot() +
  geom_sf() +
  geom_sf(
    data = india,
    linewidth = 1
  ) +
  coord_sf(
    xlim = c(40, 120),
    ylim = c(0, 50),
    # ggplot2 adds about 5% extra space
    expand = FALSE
  )

### The sf class
lnd_point = st_point(c(0.1, 51.5)) # sfg object
lnd_geom = st_sfc(lnd_point, crs = "EPSG:4326") # sfc object
lnd_attrib = tibble(
  name = "London",
  temperature = 25,
  date = ymd("2023-06-21")
)
lnd_sf = st_sf(lnd_attrib, geometry = lnd_geom)

### Simple feature geometries (sfg)
multipoint_matrix = rbind(
  c(5, 2),
  c(1, 3),
  c(3, 4),
  c(3, 2)
)
class(multipoint_matrix)
st_multipoint(multipoint_matrix)

linestring_matrix = rbind(
  c(1, 5),
  c(4, 4),
  c(4, 1),
  c(2, 2),
  c(3, 2)
)
st_linestring(linestring_matrix)

## POLYGON
polygon_lists = list(
  rbind(
    c(1, 5),
    c(2, 2),
    c(4, 1),
    c(4, 4),
    c(1, 5)
  )
)
st_polygon(polygon_lists)

polygon_border = rbind(
  c(1, 5),
  c(2, 2),
  c(4, 1),
  c(4, 4),
  c(1, 5)
)
polygon_hole = rbind(
  c(2, 4),
  c(3, 4),
  c(3, 3),
  c(2, 3),
  c(2, 4)
)
polygon_with_hole_list = list(
  polygon_border,
  polygon_hole
)
st_polygon(polygon_with_hole_list)

# matrix
m = matrix(1:8, ncol = 2)
sfg_linestring(obj = m)

# dataframes
df = data.frame(x = 1:4, y = 4:1)
sfg_polygon(obj = df)

# Units ----
luxembourg <- world[world$name_long == "Luxembourg", ]
st_area(luxembourg)

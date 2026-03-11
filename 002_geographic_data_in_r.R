# Load packages ----
library(sf)
library(spData)
library(spDataLarge)
library(tidyverse)

# sf objects
class(world)
names(world)

# Visualization
plot(world)
plot(world, max.plot = 9)

# Summary
world["lifeExp"] |>
  summary()

world_mini <- world[1:2, 1:3]
world_mini

world$geom |>
  class()

# Tidyverse: st_read vs read_sf
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

## Check this
world_tbl |>
  slice_head(n = 2) |>
  select(iso_a2, name_long) |>
  class()

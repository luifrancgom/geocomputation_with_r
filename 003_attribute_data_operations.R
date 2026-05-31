# Load packages ----
library(sf)
library(terra)
library(tidyverse)
library(spData)

# Vector attribute subsetting ----
# Subset rows by position
world[1:6, ]
# Subset columns by position
world[, 1:3]
# Subset rows and columns by position
world[1:6, 1:3]
# Columns by name
world[, c("name_long", "pop")]
# Logical indices
world[, c(
  TRUE,
  TRUE,
  FALSE,
  FALSE,
  FALSE,
  FALSE,
  FALSE,
  TRUE,
  TRUE,
  FALSE,
  FALSE
)]

i_small = world$area_km2 < 10000
summary(i_small)
small_countries = world[i_small, ]
small_countries

world |>
  subset(area_km2 < 10000)

world |>
  select(name_long, population = pop)

world_agg1 = aggregate(
  pop ~ continent,
  FUN = sum,
  data = world,
  na.rm = TRUE
)

world_agg2 = aggregate(
  world["pop"],
  by = list(world$continent),
  FUN = sum,
  na.rm = TRUE
)

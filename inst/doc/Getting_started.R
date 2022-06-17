## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(pfocal)

## -----------------------------------------------------------------------------
size <- 1000
data <- matrix(nrow = size, ncol = size, 
               data = runif(n = size*size, min = 0, max = 10))
image(data, asp = 1)

## -----------------------------------------------------------------------------
kernel <- chebyshev_distance_kernel(10)
image(kernel, asp = 1)

## -----------------------------------------------------------------------------
convoluted <- pfocal(data = data, kernel = kernel, edge_value = 0)
image(convoluted, asp = 1)

## -----------------------------------------------------------------------------
pfocal_info_transform()

## -----------------------------------------------------------------------------
pfocal_info_reduce()

## -----------------------------------------------------------------------------
pfocal_info_mean_divisor()

## -----------------------------------------------------------------------------
fast_convoluted <- pfocal_fast_abs_rectangle(data = data, height = 10, width = 10)
image(fast_convoluted, asp = 1)

## -----------------------------------------------------------------------------
library(raster)
library(microbenchmark)

## -----------------------------------------------------------------------------
data_raster <- raster::raster(data)

mbm <- microbenchmark(
  "pfocal" = {
    pfocal_results <- pfocal::pfocal(data = data_raster, kernel = kernel, 
                                     transform_function = "MULTIPLY",
                                     reduce_function = "SUM", 
                                     mean_divider = "KERNEL_COUNT")
    gc()
  },
  "raster_focal" = {
    raster_focal_results <- raster::focal(x = data_raster, w = kernel, 
                                          fun = mean, pad = TRUE, padValue = 0)
    gc()
  },
  times = 100,
  unit = "s")
mbm

## -----------------------------------------------------------------------------
plot(mbm)


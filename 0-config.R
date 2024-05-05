##############################
# 0- Config
# @Title: How does a Bike Share Navigate Speedy Success?
# @Description: An analysis of differences in market segments for a bike share company
# Configuration file for setup and filepath specification
###############################

# Load Libraries
library(tidyverse)
library(lubridate)
library(ggmap)

bike_trips = read_csv('.../bike_trips.csv')

#Register API KEY for ggmaps
register_google("...")
#Operating Region in Downtown Chicago
chicago = get_map(c(left =-87.89, bottom = 41.65, right =-87.44, top = 42.1))

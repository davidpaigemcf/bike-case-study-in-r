##############################
# 3 - Tables & Analysis
##############################

# Table 1: average trip duration by type of membership
average_trip_duration = bike_trips %>% 
  group_by(member_casual) %>%
  summarise(
    count = n(),
    mean_duration = mean(ride_duration, na.rm = TRUE),
    median_duration = median(ride_duration, na.rm = TRUE),
    iqr_duration = IQR(ride_duration, na.rm = TRUE),
    sd_duration = sd(ride_duration, na.rm = TRUE)
  )

# Table 2: Memberships with the longest duration
longest_trips = bike_trips %>% 
  filter(ride_duration >= 60) %>% 
  select(ride_id, member_casual, ride_duration) %>% 
  arrange(-ride_duration) %>% 
  slice_head(n = 100) %>% 
  group_by(member_casual) %>% 
  summarise(count = n())

# Table 3: Bike Stations
bike_stations = bike_trips %>%
  group_by(start_station_id) %>%
  summarise(start_station_name = first(start_station_name),
            lat = round(first(start_lat), 2),
            lng = round(first(start_lng), 2),
            count = n()) %>% 
  distinct()

# Table 4: Top 10 Bike Stations
top_10(bike_stations)

# Tables 5 & 6: Top 10 stations by Rider Types
top_10_stations_by_type(bike_trips, "casual")
top_10_stations_by_type(bike_trips, "member")

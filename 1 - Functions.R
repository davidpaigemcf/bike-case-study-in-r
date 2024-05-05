##############################
# 1- Functions
# @Title: How does a Bike Share Navigate Speedy Success?
# @Description: Functions for Statistical Analyses and Plots
###############################


# Function to Correct mismatched date formats
#   Description: Replaces dates stored as an incorrect data type
correct_date_format = function(date_variable) {
  id_by_date = bike_trips %>% 
    select(ride_id, date_variable) %>% 
    mutate(date_variable = as.character(as_datetime(started_at, format = "%d/%m/%Y %H:%M"))
    ) %>% 
    drop_na()
  
  bike_trips = bike_trips %>% 
    left_join(id_by_date, by = c("ride_id" = "ride_id")) %>%
    mutate(date_variable = if_else(!is.na(started_at.y), started_at.y, started_at.x)) %>%
    select(-date_variable.x, -date_variable.y)
}

#Function to return the top 10 values for a variable in a table
top_10 = function(column = NULL) {
  bike_trips %>% 
    arrange(desc(count, column)) %>%
    head(n = 10) %>%
    select(name, count)
}

# Function to filter, round, group, summarize, and select top stations
top_10_stations_by_type = function(data, member_type) {
  data %>%
    filter(member_casual == member_type) %>%
    mutate(lat = round(start_lat, 2),
           lng = round(start_lng, 2)) %>%
    group_by(start_station_id, lat, lng) %>%
    summarise(name = unique(start_station_name),
              count = n()) %>%
    group_by(start_station_id) %>%
    top_n(1) %>%
    top_10()
}

#Function to Plot Ridership by a give time period eg. Day, Month, Hour
trips_by_period = function(time_period) {
  bike_trips %>%
    count(time_period, member_casual) %>%
    ggplot(aes(x = time_period, y = n, color = member_casual)) +
    geom_line(size = 1) +
    geom_point(size = 3) +
    labs(x = paste(time_period), 
         y = "No. of Riders", 
         title = "Bicycle Rides by Month")
}

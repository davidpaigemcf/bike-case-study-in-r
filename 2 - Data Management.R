##############################
# 2 - Data Management
# 2a - Dataset import, cleaning, and export
##############################

#Remove duplicates
bike_trips = bike_trips %>% distinct()

#Correctly store data types 
bike_trips = bike_trips %>% 
  mutate(rideable_type = as.factor(rideable_type),
         member_casual = as.factor(member_casual),
         started_at = as_datetime(started_at),
         ended_at = as_datetime(ended_at)
  ) 

# Uses regex to identify datetime columns (ending with at) and correctly format their dates
bike_trips = bike_trips %>%
  mutate(across(all_of("_at$"), correct_date_format))


#-----------------------------------
# 2b - Add new columns
#-----------------------------------

#Add the hour/day/weekday/month and duration from the date-time column
bike_trips =  bike_trips %>%
  mutate(bike_trips,
         hour = hour(started_at),
         month = month(started_at, label = TRUE),
         day = wday(started_at, label = TRUE),
         ride_duration = abs(difftime(ended_at, started_at, units = "secs"))
  )

##--------------------------------------------------------------
## IMPORTING THE DATA AND PACKAGES
##--------------------------------------------------------------

install.packages(c("tidyverse","ggmap"))
library(tidyverse)
library(lubridate)
library(ggmap)

bike_trip_data <- read_csv('.../bike_trip_data.csv')

##==============================================================
## CLEANING THE DATA
##==============================================================

# (1) Removed all duplicate rows
bike_trip_data <- bike_trip_data[!duplicated(bike_trip_data), ]

#(2) Removed row that couldn't parse because of invalid data type
bike_trip_data <- bike_trip_data[!bike_trip_data$ride_id == 'ride_id', ]
  #Check to make sure the rows are completely removed
  bike_trip_data %>% 
    filter(started_at == 'ride_id') %>% 
    View()

#(3) Correct mismatched date formats
  #First, create a subset of the data 'a' with the dates and their primary keys (ride_id)
  #Second, identify all of the dates that need to be set to yyy-mm-dd hh:mm and save as characters
  # This sets the correctly formatted dates to NA. Drop them using drop_na()
  #Fourth, join these fixed dates to the original dataset on ride_id, and then convert to datetime values

a <- bike_trip_data %>% select(ride_id, started_at, ended_at)
a <- mutate(a, 
            started_at = as.character(as_datetime(started_at, format = "%d/%m/%Y %H:%M")),
            ended_at = as.character(as_datetime(ended_at, format = "%d/%m/%Y %H:%M"))
          )
a <- a %>% drop_na()
bike_trip_data$started_at[match(a$ride_id, bike_trip_data$ride_id)] <- a$started_at
bike_trip_data$ended_at[match(a$ride_id, bike_trip_data$ride_id)] <- a$ended_at
# General format to match, original.data.frame$column[match(data.frame.1.id, data.frame.2.id)] <- new.data.frame$column
bike_trip_data <- mutate(bike_trip_data, 
                         started_at = as_datetime(started_at),
                         ended_at = as_datetime(ended_at))

#(4) Convert rideable_type and member_casual to factors
bike_trip_data <- mutate(bike_trip_data,
                         rideable_type = as.factor(rideable_type),
                         member_casual = as.factor(member_casual)
                      )

##==============================================================
## PREPARING THE DATA
##==============================================================

#Bike Station Names, IDs, & Coordinates
bike_stations <- bike_trip_data %>% 
  mutate(lat = round(start_lat, 2),
         lng = round(start_lng, 2)
         ) %>% 
  group_by(start_station_id, lat, lng) %>% 
  select(start_station_name, start_station_id, lat, lng) %>%
  summarise(name = unique(start_station_name),
            count = n()
          ) %>% 
  group_by(start_station_id) %>% 
  top_n(1)

#Remove duplicated bike stations
bike_stations <- bike_stations[!duplicated(bike_stations$name), ]
bike_stations <- bike_stations[!duplicated(bike_stations$start_station_id), ]

#Extracting the hour/day/weekday/month and duration from the date-time
bike_trip_data <- mutate(bike_trip_data,
            hour = hour(started_at),
            month = month(started_at, label = TRUE),
            day = wday(started_at, label = TRUE),
            duration_secs = abs(difftime(ended_at, started_at, units = "secs"))
          )

#Export Cleaned Data to .csv for Tableau
write_csv(bike_trip_data, '.../bike_trip_data.csv', col_names = TRUE)

##==============================================================
## SECTION 1: HOW MUCH TIME DO RIDERS SPEND?
##==============================================================

#How long do annual members spend riding compared to casual riders on average?
avg_trips <- bike_trip_data %>% 
  group_by(member_casual) %>%
  summarise(
    count = n(),
    mean_duration = mean(duration_secs, na.rm = TRUE),
    median_duration = median(duration_secs, na.rm = TRUE),
    iqr_duration = IQR(duration_secs, na.rm = TRUE),
    sd_duration = sd(duration_secs, na.rm = TRUE)
  )

ggplot(data = avg_trips) + 
  geom_col(mapping = aes(x= member_casual, y=mean_duration, fill = member_casual)) +
  labs(title = "Member vs. Casual Ridership Times", x = "Membership", y = "Mean Time") +
  theme(legend.position = "none")
#Conclusion: Casual riders spend more than twice as much mean time riding than members.
  #Their riding times are more sporadic than members, which implies members possibly ride for specific trips
  #Could it be that casual riders do it for exercise, or are visitors?

#Membership Types with the Longest Duration
longest_trips <- bike_trip_data %>% 
  filter(duration_secs >= 60) %>% 
  select(ride_id, member_casual, duration_secs) %>% 
  arrange(-duration_secs) %>% 
  slice_head(n = 100) 

longest_trips %>% 
  group_by(member_casual) %>% 
  summarise(count = n())
#Conclusion: Casual riders spend the top 100 longest times riding


#Graph showing Modal Ride Duration (n > 2401, confidence interval = 95%)
bike_trip_data %>% 
  group_by(member_casual, duration_secs) %>% 
  summarise(
    count = n()
  ) %>% 
  filter(count > 2401) %>%
  ggplot(mapping = aes(x=duration_secs, y = count, color = member_casual)) + 
  geom_smooth(se = FALSE) +
  labs(title = "Graph of Rider Duration", x = "Ride Duration / m", y = "No. of Rides", color = "Membership") + 
  theme(plot.title = element_text(hjust = 0.5)) +
  scale_x_time() 
  # scale_x_continuous(breaks = seq(0, 2000, by = 100))
#Conclusion: Casual riders spend around 10mins riding, while members spend around 20mins on average


##==============================================================
## SECTION 2: WHICH AREAS ARE MOST POPULAR?
##==============================================================

#Register ggmap API KEY
register_google("Place API KEY here")

#Map of Chicago
chicago <- get_map(c(left =-87.89, bottom = 41.65, right =-87.44, top = 42.1))

#Bike Station Locations in Chicago
ggmap(chicago, darken=c(0.5)) +
  geom_point(data = bike_stations, aes(x=lng, y=lat, size=count), alpha = 0.15, color="yellow")
#Conclusion: The most popular bike stations are located in Downtown Chicago
  
#Top 10 Most Popular Bike Stations in Chicago
bike_stations %>% 
  arrange(-count) %>% 
  head(n=10) %>%
  select(name, count)
#Conclusion: The most popular bike station is at Streeter Dr. & Grande Ave.


#Top 10 stations for Casual Riders
c <- bike_trip_data %>% 
  filter(member_casual == "casual") %>% 
  mutate(lat = round(start_lat, 2),
         lng = round(start_lng, 2)
  ) %>% 
  group_by(start_station_id, lat, lng) %>% 
  select(start_station_name, start_station_id, lat, lng) %>%
  summarise(name = unique(start_station_name),
            count = n()
  ) %>%
  group_by(start_station_id) %>% 
  top_n(1) %>% 
  arrange(-count) %>% 
  head(n=10)

ggplot(data = c, aes(x=reorder(name, count), y=count)) +
  geom_col(width=0.5, fill = "blue", color = "black", alpha = 0.8) +
  coord_flip() +
  theme(axis.title = element_blank(), text = element_text(size = 20))
#Conclusion: Not all popular stations are popular for casual riders

#Preferred Bike By Group
ggplot(data = bike_trip_data) +
  geom_bar(aes(x=member_casual, fill = rideable_type), position = "dodge", width = 0.5)+
  labs(x = "Membership Options", 
       y = "No. of Riders", 
       title = "Preferred Bikes by Members vs. Casual Riders") +
  scale_fill_brewer(palette = "Accent")
  #scale_fill_manual(values = c('#ef6c00','#009668','navy'))
#Conclusion: all members prefer classic bikes


##==============================================================
## SECTION 3: HOW DO BOTH GROUPS COMPARE OVER TIME?
##==============================================================

#How Do Riders Vary By Month?
bike_trip_data %>% 
  group_by(month, member_casual) %>% 
  summarise(
    month = unique(month),
    count = n()
  ) %>% 
  ggplot(aes (x=month, y=count)) +
  geom_line(aes(group = member_casual, color = member_casual), size = 1) +
  geom_point(aes(color = member_casual), size = 3)  +
  labs(x = "Months", 
       y = "No. of Riders", 
       title = "Bicycle Rides in 2021"
  )
#CONCLUSION: Most rides were booked in May and the least in January

#How Do Riders Vary By Day?
ggplot(data = bike_trip_data) +
  geom_bar(aes(x=day, fill = member_casual), position = "dodge", width = 0.5) +
  labs(x = "Days", 
       y = "No. of Riders", 
       title = "Bicycle Rides in 2021"
       ) +
  scale_fill_brewer(palette = "Accent")
#CONCLUSION: Members booked towards the midweek while casual riders booked on the weekends

#Preferred time & day of the Week To Book Rides for Casual Riders
bike_trip_data %>% 
  group_by(day, hour, member_casual) %>% 
  summarise (
    count  = n()
  ) %>% 
  ggplot(aes(x=day, y=desc(hour), fill=count)) +
  geom_tile(color = "white", lwd = 0.1, linetype = 1) +
  facet_wrap(~member_casual) +
  guides(fill = guide_colourbar(barwidth = 0.5,
                                barheight = 40)) +
  scale_fill_gradient(low = "white", high = "red") +
  theme_classic() +
  theme(axis.ticks.x = element_blank(),
        text = element_text(size = 20),
        axis.line = element_blank()
        ) +
  labs(x = NULL, 
       y = "Time of the Day"
  )
#CONCLUSION: Most members rode during the week during rush hour, while casual riders rode on the weekends

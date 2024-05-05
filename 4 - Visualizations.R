##############################
# 4 - Visualizations
###############################

# Plot 1: A bar graph of average trip duration by member type
ggplot(data = average_trip_duration) + 
  geom_col(mapping = aes(x= member_casual, y=mean_duration, fill = member_casual)) +
  labs(title = "Member vs. Casual Ridership Times", x = "Membership", y = "Mean Time") +
  theme(legend.position = "none")


# Plot 2: A Graph of Modal Ride Duration (n > 2401, confidence interval = 95%)
bike_trips %>% 
  group_by(member_casual, ride_duration) %>% 
  summarise(
    count = n()
  ) %>% 
  filter(count > 2401) %>%
  ggplot(mapping = aes(x=ride_duration, y = count, color = member_casual)) + 
  geom_smooth(se = FALSE) +
  labs(title = "Graph of Rider Duration", x = "Ride Duration / m", y = "No. of Rides", color = "Membership") + 
  theme(plot.title = element_text(hjust = 0.5)) +
  scale_x_time() 

# Plot 3: A map of Bike Station Locations in Chicago
ggmap(chicago, darken=c(0.5)) +
  geom_point(data = bike_stations, aes(x=lng, y=lat, size=count), alpha = 0.15, color="yellow")

# Plot 4: A Bar Chart of Top 10 Stations for Casual Riders
ggplot(data = top_10_stations_by_type(bike_trips, "casual"), aes(x=reorder(name, count), y=count)) +
  geom_col(width=0.5, fill = "blue", color = "black", alpha = 0.8) +
  coord_flip() +
  theme(axis.title = element_blank(), text = element_text(size = 20))

# Plot 5: A comparison of preferred bike type by rider
ggplot(data = bike_trips) +
  geom_bar(aes(x=member_casual, fill = rideable_type), position = "dodge", width = 0.5)+
  labs(x = "Membership Options", 
       y = "No. of Riders", 
       title = "Preferred Bikes by Members vs. Casual Riders") +
  scale_fill_brewer(palette = "Accent")

# Plots 6&7: Line Graphs of How Riders Vary By Month & Day
trips_by_period(month)
trips_by_period(day)

#Plot 8: Heat Graph of the Time & Day of the Week Users Ride the Most
bike_trips %>% 
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

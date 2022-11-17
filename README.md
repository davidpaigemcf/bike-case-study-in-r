# Analyzing Data from a Bike Sharing Service

I completed this case study as the capstone to my Google Data Analytics certificate. In this project, I used Excel and R to analyze data collected from a [bike-sharing service in Chicago](https://ride.divvybikes.com/data-license-agreement). I presented my findings in a [report](https://docs.google.com/presentation/d/1o1Zo2Nd1F44H0mtXycDwwzMb8F4x_zgNZuV0IZdqd6c/edit#slide=id.p). This project contains **6,392,409** records of data across 18 variables. The aim of the project was to increase conversions of casual to annual memberships by identifying key differences in each market segment.

## 🖥️ R Skills 
Data Cleaning, Data Wrangling, Data Visualization

### Packages
- tidyverse
- lubridate
- ggmap
- ggplot2

## 🧼 Data cleaning
The data was retrieved from a .csv file and compiled into one file. The data was stored in a secure local folder. I sorted rows by start date, and ensured its credibility. The data was incomplete, which would affect the second hypothesis in my study. I removed duplicate rows, converted dates the standard ISO 8601 format (yyyy-mm-dd hh:mm:ss), trimmed whitespaces, and placed data in their appropriate categories.


## ❓ Big Questions

### How much time do riders spend? 
*Explore how much time each group spends with the service to set clear goals for the target market* <br>
<img src="https://user-images.githubusercontent.com/118395567/202530683-a63f9c82-d0a1-4f05-a845-4edf4470a092.png" width="500"> <br>

For a population of 6,329,409 with a confidence level of 95%, an appropriate sample size was 2401 (see more details in the report). My conclusion was that casual riders spend around 10 minutes riding, while members spent around 20. This could be for a number of reasons, possibly because casual riders use the bikes less or travel to shorter distances. I also realized that casual riders are more sporadic than members. The mean time was skewed because of large casual rider times. It could be because they took the bike and left without returning it, or did not check in to an end station.

### Which areas are most popular? 
*Effectively market by identifying the most popular stations* <br>
<img src = "https://user-images.githubusercontent.com/118395567/202531354-faeac716-fe0c-4338-b9b5-874f4c1c68db.png" width="500"> <br>
The most popular bike stations are located in downtown Chicago. The most popular station is at the intersection of Streeter Dr. & Grand Ave. (ID 13022) Since we're focusing on converting casual riders, I found the most popular stations for casual users as follows: <br>
<img src="https://user-images.githubusercontent.com/118395567/202531951-c0307624-39db-4971-b831-bdf0ca705113.png" width = "500"><br>
Most casual riders use Streeter Dr. & Grand Ave. <br>
I realized that the stations that are most popular for everyone (see report) are not necessarily the most popular for casual riders. I also found that there was no distinct difference among bikes chosen for casual users. However, this data may be affected by the fact that quite a few rows are missing because of inaccurate/missing locations.

### How Do Both Groups Compare Over Time? <br>
*Examine historical data to identify potential trends in ridership* <br>
<img src="https://user-images.githubusercontent.com/118395567/202533304-3dc0b066-b291-4470-84ae-c216b3fc918c.png" width = "500"> <br>
I broke this down into two different time periods:
- By month, most riders were booked in May and the least in January. Comparatively, most members used the bikes in the winter months (Nov - Mar). However more casual users booked than members in summer(June - Aug).
- By day, the most popular riding times for casual riders were on weekends between 10:00 to 17:00, the most popular being on 2:00 PM Sundays. In comparison, members preferred riding during rush hour in the week- the most popular being at 5PM on Tuesdays 7 Wednesdays. This implies that casual users ride for leisure, while members ride more regularly. 

## 💬 Reflection
I enjoyed doing this project. I was able to use various packages to achieve my goals, and developed my understanding of them. Please feel free to share your thoughts and any suggestions to my code.

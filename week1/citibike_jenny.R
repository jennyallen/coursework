library(tidyverse)
library(lubridate)

########################################
# READ AND TRANSFORM THE DATA
########################################

# read one month of data
trips <- read_csv('201402-citibike-tripdata.csv')

# replace spaces in column names with underscores
names(trips) <- gsub(' ', '_', names(trips))

# convert dates strings to dates
trips <- mutate(trips, starttime = ymd_hms(starttime), stoptime = ymd_hms(stoptime), birth_year = as.numeric(birth_year))

# recode gender as a factor 0->"Unknown", 1->"Male", 2->"Female"
trips <- mutate(trips, gender = factor(gender, levels=c(0,1,2), labels = c("Unknown","Male","Female")))


########################################
# YOUR SOLUTIONS BELOW
########################################

# find the earliest and latest birth years (see help for max and min to deal with NAs)
trips %>%
  summarize(max_year = max(birth_year, na.rm = TRUE), min_year = min(birth_year, na.rm =TRUE))

# use filter and grepl to find all trips that either start or end on broadway
trips %>%
  filter(grepl('Broadway', start_station_name) | grepl('Broadway', end_station_name))

# do the same, but find all trips that both start and end on broadway
trips %>%
  filter(grepl('Broadway', start_station_name) & grepl('Broadway', end_station_name))

# find all unique station names
# this assumes that all stations are used as a start station at least once
trips %>%
  distinct(start_station_name) 

# count the number of trips by gender, the average trip time by gender, and the standard deviation in trip time by gender
# do this all at once, by using summarize() with multiple arguments
trips %>%
  group_by(gender) %>%
  summarize(count = n(), avg_trip = mean(tripduration), stdev_trip = sd(tripduration))

# find the 10 most frequent station-to-station trips
trips %>%
  group_by(start_station_name, end_station_name) %>%
  summarize(count = n()) %>%
  ungroup %>%
  arrange(desc(count)) %>%
  head(10)

# find the top 3 end stations for trips starting from each start station
trips %>%
  group_by(start_station_name, end_station_name) %>%
  summarize(count = n()) %>%
  group_by(start_station_name) %>%
  arrange(start_station_name, desc(count)) %>%
  slice(1:3)

# find the top 3 most common station-to-station trips by gender
trips %>%
  group_by(gender, start_station_name, end_station_name) %>%
  summarize(count = n()) %>%
  group_by(gender) %>%
  arrange(gender, desc(count)) %>%
  slice(1:3)

# find the day with the most trips
# tip: first add a column for year/month/day without time of day (use as.Date() or floor_date())
trips %>%
  group_by(gender, start_station_name, end_station_name) %>%
  summarize(count = n()) %>%
  group_by(gender) %>%
  arrange(gender, desc(count)) %>%
  slice(1:3)

# compute the average number of trips taken during each of the 24 hours of the day across the entire month
# what time(s) of day tend to be peak hour(s)?
trips %>%
  mutate(hr = hour(starttime)) %>%
  group_by(hr) %>%
  summarize(num_trips = n(), trips_per_day = num_trips / 31)

# peaks are at rush hour
# could have hard-coded the number of days at 31, but this is more flexible

# compute the maximum number of riders on the road and the time when this occurs
# tip: there are many ways to do this, but there's a very compact solution using gather(), mutate(), and arrange()
trips %>%
  mutate(trip_id = row_number()) %>%
  select(trip_id, starttime, stoptime) %>%
  gather("variable", "value", starttime, stoptime) %>%
  arrange(value) %>%
  mutate(delta = ifelse(variable == "starttime", 1, -1)) %>%
  mutate(concurrent_riders = cumsum(delta)) %>%
  filter(concurrent_riders == max(concurrent_riders))


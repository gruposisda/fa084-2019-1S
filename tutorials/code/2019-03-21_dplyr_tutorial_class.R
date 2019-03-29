#install.packages('nycflights13')
#install.packages('tidyverse')
flights
glimpse(flights)
str(flights)
voos = flights

dfvoo = as.data.frame(voos)
as.tibble(dfvoo)

library(dplyr)
# filter ------------------------------------------------------------------
unique(voos$carrier)

filter(voos,carrier == 'AA')

head(voos)
# Find all flights that:
# 
# Had an arrival delay of two or more hours
two_or_more_arr_delay = filter(voos, arr_delay >= 120)

# Flew to Houston (IAH or HOU)
glimpse(voos)
filter(voos, dest == 'IAH' | dest == 'HOU')

# Were operated by United, American, or Delta
filter(voos, carrier == 'UA' | carrier == 'AA')

# Departed in summer (July, August, and September)


# Arrived more than two hours late, but didn’t leave late
filter(voos, arr_delay > 120 & dep_delay <= 0)
colnames(voos)
# Were delayed by at least an hour, but made up over 30 minutes in flight
# Departed between midnight and 6am (inclusive)
#
#   
#How many flights have a missing dep_time?
sum(is.na(voos$dep_time))


# arrange -----------------------------------------------------------------

# Sort flights to find the most delayed flights. Find the flights that left earliest.
arrange(voos, dep_delay)
arrange(voos, desc(dep_delay))

# Sort flights to find the fastest flights.
arrange(voos, desc(air_time))
# Which flights travelled the longest? Which travelled the shortest?


# select ------------------------------------------------------------------
select(voos, -air_time, -dep_delay)


# mutate -----------------------------------------------------------------

#create a new column ("total_delay") by summing arr_delay and dep_delay
voos$total_delay = voos$dep_delay + voos$arr_delay
mutate(voos, total_delay = dep_delay + arr_delay)

#create a new column ("speed", in miles/hour) using air_time (minutes) and distance (miles)
voos = mutate(voos, air_time_h = air_time/60)
voos = mutate(voos, speed = distance/air_time)
select(voos, air_time_h, speed)

voos %>% mutate(air_time_h = air_time/60, speed = distance/air_time) %>% 
  select(air_time_h, speed)

#route

# group_by and summarise ------------------------------------------------


# gráfico chique ----------------------------------------------------------

by_dest <- group_by(flights, dest)
delay <- summarise(by_dest,
                   count = n(),
                   dist = mean(distance, na.rm = TRUE),
                   delay = mean(arr_delay, na.rm = TRUE)
)
delay <- filter(delay, count > 20, dest != "HNL")

# It looks like delays increase with distance up to ~750 miles 
# and then decrease. Maybe as flights get longer there's more 
# ability to make up delays in the air?
ggplot(data = delay, mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)







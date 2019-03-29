#install.packages('nycvoos13')
#install.packages('tidyverse')

library(nycvoos13)
library(tidyverse)

dim(voos)
voos = voos

#tibble vs data.frame
voos
df_voos = as.data.frame(voos)

# Pick observations by their values (filter()).
# Reorder the rows (arrange()).
# Pick variables by their names (select()).
# Create new variables with functions of existing variables (mutate()).
# Collapse many values down to a single summary (summarise()).

#jan and 1st day
filter(voos, month == 1, day == 1)
#dec or november
filter(voos, month == 11 | month == 12)
#outro jeito
nov_dec <- filter(voos, between(month,11,12))


#
filter(voos, !(arr_delay > 120 | dep_delay > 120))
filter(voos, arr_delay <= 120, dep_delay <= 120)

# Find all flights that:
# 
# Had an arrival delay of two or more hours
# Flew to Houston (IAH or HOU)
# Were operated by United, American, or Delta
# Departed in summer (July, August, and September)
# Arrived more than two hours late, but didn’t leave late
# Were delayed by at least an hour, but made up over 30 minutes in flight
# Departed between midnight and 6am (inclusive)
#
#   
#How many flights have a missing dep_time?
#What other variables are missing? What might these rows represent?



# arrange() ---------------------------------------------------------------

arrange(flights, year, month, day)
arrange(flights, desc(dep_delay))

#select() ----
select(flights, year, month, day)
select(flights, year:day)
select(flights, -(year:day))
rename(flights, tail_num = tailnum)
# starts_with("abc"): matches names that begin with “abc”.
# 
# ends_with("xyz"): matches names that end with “xyz”.
# 
# contains("ijk"): matches names that contain “ijk”.

# mutate ------------------------------------------------------------------

flights_sml <- select(flights, 
                      year:day, 
                      ends_with("delay"), 
                      distance, 
                      air_time
)


flights_sml

mutate(flights_sml,
       hours = air_time / 60
)



# group_by and summarise --------------------------------------------------


not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(
    avg_delay1 = mean(arr_delay),
    avg_delay2 = mean(arr_delay[arr_delay > 0]) # the average positive delay
  )



# fancy -------------------------------------------------------------------


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
#> `geom_smooth()` using method = 'loess' and formula 'y ~ x'





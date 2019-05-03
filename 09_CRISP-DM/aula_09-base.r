
library(tidyverse)

library(nycflights13)

#airlines, airports, planes, weather

dim(voos)
dim(gapminder)

library(nycflights13)
head(flights)

library(nycflights13)

dim(flights)

dfua = filter(flights, carrier == 'UA' )

dim(dfua)

df_arr_delay = filter(flights, arr_delay > 0)
dim(df_arr_delay)

flights %>% filter(arr_delay >= 120) %>% dim()

flights %>% filter(dest == 'IAH' | dest == 'HOU')  %>%  dim()

flights %>% filter(carrier == 'AA' | 
                   carrier == 'UA' | 
                   carrier == 'DL')  %>% dim()

flights  %>%  filter(dep_time > 0 & dep_time < 600)  %>%  dim()

#flights  %>% arrange(dep_time)

flights %>% arrange(desc(is.na(dep_delay)))

flights %>% arrange(desc(arr_delay)) %>% head(2)

flights %>% arrange(dep_delay) %>% head(2)

flights %>% arrange(desc(air_time)) %>% head(2)

flights %>% filter(dest == 'IAH') %>% arrange(desc(air_time)) %>% head(2)

colnames(flights)

select(flights, year, month, day, dep_time, arr_time) %>%  head(4)

select(flights, 1,2,3,4,8,10) %>% head(3)

select(flights, ends_with('time')) %>% head(2)

select(flights, dep_time, dep_delay, arr_time, arr_delay) %>%  head(2)

select(flights, year, month, day, starts_with('dep'), starts_with('arr')) %>%  head(2)

select(flights, year, year, day, day,arr_time,arr_time) %>%  head(2)
# nao funciona

select(flights, contains("time",ignore.case = FALSE))  %>% head(2)

flights_sml = select(flights, 
  year:day, 
  ends_with("delay"), 
  distance, 
  air_time
)

head(flights_sml)

flights_sml  %>% mutate(speed = distance/air_time * 60) %>% head()

flights_sml  %>% mutate(speed = distance/air_time * 60,
                        gain = dep_delay - arr_delay,
                        gain_per_hour = gain / (air_time/60))  %>%  head()

flights_sml %>% summarise(mean(distance), mean(air_time), mean(arr_delay))

not_cancelled = flights %>%  filter(!is.na(dep_delay) , !is.na(arr_delay))
dim(not_cancelled)

not_cancelled  %>% group_by(year, month, day) %>% summarise(mean(dep_delay))  %>% head(2)

not_cancelled  %>% group_by(year, month) %>% summarise(mead_atraso = mean(dep_delay),
                                                      meadia_atraso_mesmo = mean(dep_delay[dep_delay > 0])) 

head(not_cancelled)

not_cancelled %>% group_by(carrier) %>%
 summarise(delay = mean(dep_delay[dep_delay>0]), 
          delay_2 = mean(dep_delay)) %>%  arrange(desc(delay_2))

table1

cases = table4a  %>% gather('1999','2000',key = 'year', value = 'cases')
population = table4b %>% gather(-country, key = 'year', value = 'population')

not_cancelled %>% group_by(carrier) %>%
 summarise(delay = mean(dep_delay[dep_delay>0]), 
          delay_2 = mean(dep_delay)) %>%  arrange(desc(delay_2))

inner_join(cases, population) %>% arrange(country)

dim(table2)
head(table2)

table2 %>% spread(key = type, value = count)

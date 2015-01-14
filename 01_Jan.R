
# Problem 1: What was the average total time (in minutes) used by a bicycle in the data?
# Problem 2: What was the most popular day by trip frequency in this dataset?
# Problem 3 (harder): Assuming there are 30 bikes per station, find what date and time the bikes FIRST need to be rebalanced. As in, there are 0 bikes at a terminal for a customer to rent. 
# Problem 3 (easier): Assuming there are 30 bikes per station, find what date the bikes FIRST need to be rebalanced. As in, there are 0 bikes at a terminal for a customer to rent. Do this ignoring "Start.Date" and "End.Date" columns.



# create data dir first, if it does not exist
if (!file.exists("data")) {
  dir.create("data")
}

# CSV
## fileUrl <- "http://mandrillapp.com/track/click/30315607/s3-us-west-1.amazonaws.com?p=eyJzIjoiZG84bDF5dl9kUjNtY2hfelpjLXdtZmVZQVdRIiwidiI6MSwicCI6IntcInVcIjozMDMxNTYwNyxcInZcIjoxLFwidXJsXCI6XCJodHRwczpcXFwvXFxcL3MzLXVzLXdlc3QtMS5hbWF6b25hd3MuY29tXFxcL2RhdGF5ZWFyXFxcL2Jpa2VfdHJpcF9kYXRhLmNzdlwiLFwiaWRcIjpcIjE3MGE1MTFhNGYzNTRlNWY5YjhhMDMzMWM1NTUwODUxXCIsXCJ1cmxfaWRzXCI6W1wiMTVlYzMzNWM1NDRlMTM1ZDI0YjAwODE4ZjI5YTdkMmFkZjU2NWQ2MVwiXX0ifQ"
## download.file(fileUrl, destfile = "./data/bike_trip_data.csv", method = "curl")
list.files("./data")

# Dataset Description:
# A CSV of bicycle rental transactions for a rental company in California
bike_trip <- read.csv("./data/bike_trip_data.csv", colClasses = "character")
str(bike_trip)

# just cross checking
# Show columns with NAs in a data.frame
# http://stackoverflow.com/questions/10574061/show-columns-with-nas-in-a-data-frame
nacols <- function(df) {
  names(df[,!complete.cases(t(df))])
}
nacols(bike_trip)

# Trip ID,Duration,Start Date,Start Station,Start Terminal,End Date,End Station,End Terminal,
# Bike #,Subscription Type,Zip Code
# > str(bike_trip)
# 'data.frame':  144015 obs. of  11 variables:
#   $ Trip.ID          : chr  "4576" "4607" "4130" "4251" ...
# $ Duration         : chr  "63" "70" "71" "77" ...
# $ Start.Date       : chr  "8/29/13 14:13" "8/29/13 14:42" "8/29/13 10:16" "8/29/13 11:29" ...
# $ Start.Station    : chr  "South Van Ness at Market" "San Jose City Hall" "Mountain View City Hall" "San Jose City Hall" ...
# $ Start.Terminal   : chr  "66" "10" "27" "10" ...
# $ End.Date         : chr  "8/29/13 14:14" "8/29/13 14:43" "8/29/13 10:17" "8/29/13 11:30" ...
# $ End.Station      : chr  "South Van Ness at Market" "San Jose City Hall" "Mountain View City Hall" "San Jose City Hall" ...
# $ End.Terminal     : chr  "66" "10" "27" "10" ...
# $ Bike..           : chr  "520" "661" "48" "26" ...
# $ Subscription.Type: chr  "Subscriber" "Subscriber" "Subscriber" "Subscriber" ...
# $ Zip.Code         : chr  "94127" "95138" "97214" "95060" ...


# Problem 1:
  # What was the average total time (in minutes) used by a bicycle in the data?
bike_trip[, 2] <- as.numeric(bike_trip[, 2]) # cast  Duration to numeric
summary(bike_trip$Duration)
mean(bike_trip$Duration)
# 1230.91 ~ 1231 minutes => 20.51 hours

# Problem 2:
# What was the most popular day by trip frequency in this dataset?
# convert to time format
#  "8/29/13 14:13" "8/29/13 14:42"
start_date <- as.Date(strptime(bike_trip$Start.Date, "%m/%d/%y %H:%M"))
end_date   <- as.Date(strptime(bike_trip$End.Date,   "%m/%d/%y %H:%M"))
# build list of days as sequence between start and end date
# list_of_days <- mapply(function(x, y) seq(x,y,"day"), start_date[1:2000], end_date[1:2000])
# use loop below to get a single vector instead of a list of vectors returned by mapply
############ The following loop takes a few minutes
list_of_days <- vector()
for(iday in seq_along(end_date)){
  if(length(end_date[iday]) != 0){ 
    # use seq() to produce the list of days between begin and end date
    list_of_days <- append(list_of_days, seq.Date(start_date[iday], end_date[iday], "day"))
  }
}
#
sort(table(list_of_days))
# take the last element after sorting:
# 2013-09-25 <- 1269 times.


# Problem 3 (harder):
# Assuming there are 30 bikes per station, find what date and time the bikes
# FIRST need to be rebalanced. As in, there are 0 bikes at a terminal for a customer to rent. 
# 


# Problem 3 (easier):
# Assuming there are 30 bikes per station, find what date the bikes
# FIRST need to be rebalanced. As in, there are 0 bikes at a terminal for a customer to rent.
# Do this ignoring "Start.Date" and "End.Date" columns.
all_stations <- unique(bike_trip$Start.Station)
bikes_per_station <- rep(30, length(all_stations))
max_trips <- length(bike_trip$Trip.ID)
for (itrip in 1:max_trips){
  # add returning bikes
  #
  # remove parting bikes
  start_st <- bike_trip[itrip, 4]
  index_st <- all_stations[all_stations == start_st]
  all_stations[index_st] <- all_stations[index_st] - 1
}








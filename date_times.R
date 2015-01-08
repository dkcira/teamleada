x <- Sys.time()
x
unclass(x)
p <- as.POSIXlt(x)
p
unclass(p)
names(unclass(p))
p$sec

#
datestring <- c("January 10, 2012 10:40",  "December 9, 2011 9:10")
y <- strptime(datestring, "%B %d, %Y %H:%M")
y
class(y)


#
z <- as.Date("2012-01-01")
z
class(z)
z <- as.POSIXlt(z)
x-y

#
a <- as.Date("2012-03-01")
b <- as.Date("2012-02-28")
a-b

#
c <- as.POSIXct("2012-10-25 01:00:00")
d <- as.POSIXct("2012-10-25 06:00:00", tz = "GMT")
c-d


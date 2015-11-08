#the file named "household_power_consumption" has to be downloaded into your working directory
#read file into R
powerful<-read.table("household_power_consumption.txt",header=TRUE, sep=";")
#combine date and time columns
library(dplyr)
verypowerful<-mutate(powerful,datetime=paste(Date,Time, sep=" "))
#convert from character to date class
library(lubridate)
asdate<-dmy_hms(verypowerful$datetime)
#add the new colum with date class to the data frame
verypowerful$DateTime<-asdate
#select the columns

powerful1<-select(verypowerful,DateTime,Global_active_power,Global_reactive_power,Voltage,Global_intensity,Sub_metering_1,Sub_metering_2,Sub_metering_3)
powerful2<-powerful1[grep("2007-02-01",powerful1$DateTime),]
powerful3<-powerful1[grep("2007-02-02",powerful1$DateTime),]
power4<-rbind(powerful2,powerful3)
GAP<-as.numeric(paste(power4$Global_active_power))
par(mfrow=c(1,1))
hist(GAP,xlab="Global Active Power (kilowatts)",col= "red",main="Global Active Power")
#create PNG
dev.copy(png,file="Plot1.png")
dev.off()
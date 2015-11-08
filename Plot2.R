#download the file household_power_consumption into your working directory
#read file into R
powerful<-read.table("household_power_consumption.txt",header=TRUE, sep=";")
#combine Date and Time columns
library(dplyr)
verypowerful<-mutate(powerful,datetime=paste(Date,Time, sep=" "))
#convert datetime class from factor to Date 
library(lubridate)
asdate<-dmy_hms(verypowerful$datetime)
#add the new column to data frame
verypowerful$DateTime<-asdate
#convert the columns into numeric
verypowerful$Global_Active_Power<-as.numeric(paste(verypowerful$Global_active_power))
verypowerful$Global_Reactive_Power<-as.numeric(paste(verypowerful$Global_reactive_power))
verypowerful$VOLTAGE<-as.numeric(paste(verypowerful$Voltage))
verypowerful$Global_Intensity<-as.numeric(paste(verypowerful$Global_intensity))
verypowerful$Sub_Metering_1<-as.numeric(paste(verypowerful$Sub_metering_1))
verypowerful$Sub_Metering_2<-as.numeric(paste(verypowerful$Sub_metering_2))
verypowerful$Sub_Metering_3<-as.numeric(paste(verypowerful$Sub_metering_3))
#select only the desired columns 
powerful1<-select(verypowerful,DateTime,Global_Active_Power,Global_Reactive_Power,VOLTAGE,Global_Intensity,Sub_Metering_1,Sub_Metering_2,Sub_Metering_3)
#filter only the 1st and 2nd of February
powerful2<-powerful1[grep("2007-02-01",powerful1$DateTime),]
powerful3<-powerful1[grep("2007-02-02",powerful1$DateTime),]
power4<-rbind(powerful2,powerful3)
par(mar=c(2,4,2,2))
with(power4,plot(DateTime,Global_Active_Power,pch=".",ylab="Global Active Power (kilowatts)"))
lines(power4$DateTime,power4$Global_Active_Power)
#create PNG
dev.copy(png,file="Plot2.png")
dev.off()

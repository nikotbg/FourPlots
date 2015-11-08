#ensure the file household_power_consumption is downloaded into your working directory
#read the file inot R
powerful<-read.table("household_power_consumption.txt",header=TRUE, sep=";")
#combine Date and Time columns
library(dplyr)
verypowerful<-mutate(powerful,datetime=paste(Date,Time, sep=" "))
#convert datetime column to Date class and add to the data frame
library(lubridate)
asdate<-dmy_hms(verypowerful$datetime)
verypowerful$DateTime<-asdate
#convert the columns into numeric
verypowerful$Global_Active_Power<-as.numeric(paste(verypowerful$Global_active_power))
verypowerful$Global_Reactive_Power<-as.numeric(paste(verypowerful$Global_reactive_power))
verypowerful$VOLTAGE<-as.numeric(paste(verypowerful$Voltage))
verypowerful$Global_Intensity<-as.numeric(paste(verypowerful$Global_intensity))
verypowerful$Sub_Metering_1<-as.numeric(paste(verypowerful$Sub_metering_1))
verypowerful$Sub_Metering_2<-as.numeric(paste(verypowerful$Sub_metering_2))
verypowerful$Sub_Metering_3<-as.numeric(paste(verypowerful$Sub_metering_3))
#filter only the 1st and 2nd of February
powerful1<-select(verypowerful,DateTime,Global_Active_Power,Global_Reactive_Power,VOLTAGE,Global_Intensity,Sub_Metering_1,Sub_Metering_2,Sub_Metering_3)
powerful2<-powerful1[grep("2007-02-01",powerful1$DateTime),]
powerful3<-powerful1[grep("2007-02-02",powerful1$DateTime),]
power4<-rbind(powerful2,powerful3)
#melt the dataset to create long dataset 
library(reshape2)
melted<- melt(power4, id.vars = c("DateTime", "Global_Active_Power","Global_Reactive_Power","VOLTAGE","Global_Intensity"),
            variable.name = "Sub_Metering_variable", 
            value.name = "Sub_Metering_value")
par(mfcol=c(1,1))
par(mar=c(2,4,2,2))
with(melted,plot(DateTime,Sub_Metering_value,ylab="Energy sub metering",type="n"))

with(subset(melted,Sub_Metering_variable=="Sub_Metering_1"),lines(DateTime,Sub_Metering_value,pch=".",col="black"))
with(subset(melted,Sub_Metering_variable=="Sub_Metering_2"),lines(DateTime,Sub_Metering_value,pch=".",col="red"))
with(subset(melted,Sub_Metering_variable=="Sub_Metering_3"),lines(DateTime,Sub_Metering_value,pch=".",col="blue"))
legend("topright",cex=0.6,lwd=c(1,1,1),col=c("black","red","blue"),legend=c("Sub_Metering_1","Sub_Metering_2","Sub_Metering_3"))
#copy into PNG file
dev.copy(png,file="Plot3.png")
dev.off()

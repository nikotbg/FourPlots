#ensure the file household_power_consumption is downloaded into your working directory
#read the file inot R
powerful<-read.table("household_power_consumption.txt",header=TRUE, sep=";")
#create a combined column for Date and Time
library(dplyr)
verypowerful<-mutate(powerful,datetime=paste(Date,Time, sep=" "))
#convert the datetime column from factor to a Date class
library(lubridate)
asdate<-dmy_hms(verypowerful$datetime)
verypowerful$DateTime<-asdate
#convert all the columns (except datetime) into numeric class
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
#melt the dataset to create Sub_Metering_variable and Sub_metering_values
library(reshape2)
melted<- melt(power4, id.vars = c("DateTime", "Global_Active_Power","Global_Reactive_Power","VOLTAGE","Global_Intensity"),
            variable.name = "Sub_Metering_variable", 
            value.name = "Sub_Metering_value")
#set up the parameters
par(mfcol=c(2,2))
par(mar=c(4,4,2,2))
#add Plot
with(power4,plot(DateTime,Global_Active_Power,pch=".",xlab=" ",ylab="Global Active Power"))
lines(power4$DateTime,power4$Global_Active_Power)
#add Plot
with(melted,plot(DateTime,Sub_Metering_value,ylab="Energy sub metering",xlab=" ",type="n"))

with(subset(melted,Sub_Metering_variable=="Sub_Metering_1"),lines(DateTime,Sub_Metering_value,pch=".",col="black"))
with(subset(melted,Sub_Metering_variable=="Sub_Metering_2"),lines(DateTime,Sub_Metering_value,pch=".",col="red"))
with(subset(melted,Sub_Metering_variable=="Sub_Metering_3"),lines(DateTime,Sub_Metering_value,pch=".",col="blue"))
legend("topright",bty="n",lwd=c(1,1,1),cex=0.6,col=c("black","red","blue"),legend=c("Sub_Metering_1","Sub_Metering_2","Sub_Metering_3"))
#add Plot
with(power4,plot(DateTime,VOLTAGE,pch=".",xlab="datetime",ylab="Voltage"))
lines(power4$DateTime,power4$VOLTAGE)
#add Plot
with(power4,plot(DateTime,Global_Reactive_Power,pch=".",xlab="datetime",ylab="Global Reactive Power"))
lines(power4$DateTime,power4$Global_Reactive_Power)
#copying the Plot into PNG file
dev.copy(png,file="Plot4.png")
dev.off()

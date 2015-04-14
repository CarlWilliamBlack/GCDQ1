#Question 3:
setwd("C:/Users/Carl/Desktop/R Files")
#Had to install java x64 bit to be consitent with R x64
install.packages("xlsx")
library(xlsx)
#Set download as write-binary (wb) since xlsx is basically a binary file (zip)
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx",destfile = "C:/Users/Carl/Desktop/R Files/natgas.xlsx",mode='wb')
rowindex <- 18:23
colindex <- 7:15
dat <- read.xlsx("C:/Users/Carl/Desktop/R Files/natgas.xlsx", sheetIndex=1,colIndex=colindex,rowIndex=rowindex,header=TRUE)

#Question 4: 
install.packages("XML")
library(XML)
#removed the s after http - was not recognizing as xml
fileurl <- "http://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
doc <- xmlTreeParse(fileurl,useInternal = TRUE)
rootNode <- xmlRoot(doc)
xmlName(rootNode)
names(rootNode)
rootNode[[1]][[1]]
zipcode <- xpathSApply(rootNode,"//zipcode",xmlValue)
length(zipcode[zipcode==21231])

#Question5: What is the fastest way to calculate the average of pwgtp15 broken down by sex using data.table?
download.file("http://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv ",destfile = "C:/Users/Carl/Desktop/R Files/UScom.csv")
dateDownloaded <- date()
print(dateDownloaded)

install.packages(data.table)
library(data.table)

DT <- fread(input="UScom.csv", sep=",")
#Option 1: Slow
system.time(mean(DT[DT$SEX==1,]$pwgtp15)) 
system.time(mean(DT[DT$SEX==2,]$pwgtp15))
#Option 2: 
system.time(tapply(DT$pwgtp15,DT$SEX,mean))
tapply(DT$pwgtp15,DT$SEX,mean)
#Option 3:
system.time(DT[,mean(pwgtp15),by=SEX])
DT[,mean(pwgtp15),by=SEX]
#Option 4: CORRECT
system.time(sapply(split(DT$pwgtp15,DT$SEX),mean))
sapply(split(DT$pwgtp15,DT$SEX),mean)
#Option 5: Slow
system.time(rowMeans(DT)[DT$SEX==1]) 
system.time(rowMeans(DT)[DT$SEX==2])
#Option 6: Does not give right output
system.time(mean(DT$pwgtp15,by=DT$SEX))
mean(DT$pwgtp15,by=DT$SEX)

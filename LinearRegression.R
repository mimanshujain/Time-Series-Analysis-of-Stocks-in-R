# =====================================================================
# CSE487/587
# Author: Mimanshu Shisodia
# Email: mimanshu@buffalo.edu
# =====================================================================

# need to install the following two packages in CCR(at least)
# install.packages("forecast")
# install.packages("fpp")
# data path /gpfs/courses/cse587/spring2015/data/hw2/data
# Def: autoregressive integrated moving average (ARIMA) 
library(forecast)   
library(fpp)
# # 
stockList = "/gpfs/courses/cse587/spring2015/data/hw2/stocklist.txt"
fileDir = "/gpfs/courses/cse587/spring2015/data/hw2/data/"

# fileDir = "/home/sherlock/Desktop/Project2-DIC/Data/"
# stockList = "/home/sherlock/Desktop/Project2-DIC/stocklist.txt"

if(file.exists(stockList) == TRUE & file.info(stockList)[2] == FALSE & file.info(stockList)[1] > 0){
  
  resultLM = c()
  nameLM = c()
  maxLM = 0
  
  count = 1
  opener = file(stockList,open = "r")
  reader = readLines(opener, warn = FALSE)
  ptm = proc.time()
  for(i in 1:length(reader)){
    
    fileName = reader[i]
    if(fileName != ""){

      filePath = paste(fileDir,fileName,".csv",sep="")

      if(file.exists(filePath) & file.info(filePath)$size > 0){
        textData = read.csv(file = filePath, header = TRUE)

        if(nrow(textData) == 754){ 
          
          tsData = ts(rev(textData$Adj.Close),start=c(2012, 1),frequency=365)
          trainData = window(tsData, end=c(2014,14))
          testData = window(tsData, start=c(2014,15))
          MAE = matrix(NA,1,length(testData))      

          fitData = tslm(trainData ~ trend)
          forecastData = forecast(fitData, h=length(testData))
          
          for(i in 1:length(testData)){      
            MAE[1,i] = abs(forecastData$mean[i] - testData[i])
          }      
          totalErr = sum(MAE[1,1:10])

          if(count <= 10){
            resultLM[count] = totalErr
            nameLM[count] = fileName
            if(maxLM < totalErr){
              maxLM = totalErr 
            }                  
            count = count + 1
          }
          
          else{
            if(maxLM > totalErr){
              index = which.max(resultLM)
              resultLM[index] = totalErr
              nameLM[index] = fileName
              maxLM = max(resultLM)
            }          
          }        
        }  
      }
    }
  }
  close(opener)
  print("------RESULTS OF LINEAR REGRESSION FORECASTING------")
  pOrder = order(resultLM)
  for(i in 1:10){
    print(paste(i,nameLM[pOrder[i]],resultLM[pOrder[i]]))
  }
  
  elapsed = proc.time() - ptm
  print(paste("Total Time taken:",elapsed[3]))
}

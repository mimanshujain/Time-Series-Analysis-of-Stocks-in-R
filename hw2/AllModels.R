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
# 
stockList = "/gpfs/courses/cse587/spring2015/data/hw2/stocklist.txt"
fileDir = "/gpfs/courses/cse587/spring2015/data/hw2/data/"

# fileDir = "/home/sherlock/Desktop/Project2-DIC/short/"
# stockList = "/home/sherlock/Desktop/Project2-DIC/shortList.txt"

if(file.exists(stockList) == TRUE & file.info(stockList)$isdir == FALSE & file.info(stockList)$size > 0){
  
  resultAR = c()
  nameAR = c()
  maxAR = 0
  countAR = 1
  
  resultHM = c()
  nameHM = c()
  maxHM = 0
  countHM = 1
  
  resultLM = c()
  nameLM = c()
  maxLM = 0
  countLM = 1

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
              
#Calculation for HM
          MAE_HM = matrix(NA,1,length(testData))  
          fitDataHM= HoltWinters(trainData, gamma = FALSE)
          forecastDataHM = forecast(fitDataHM, h=length(testData))
          
          for(i in 1:length(testData)){      
            MAE_HM[1,i] = abs(forecastDataHM$mean[i] - testData[i])
          }   
                    
          totalErrHM = sum(MAE_HM[1,1:10])
          
          if(countHM <= 10){
            resultHM[countHM] = totalErrHM
            nameHM[countHM] = fileName
            if(maxHM < totalErrHM){
              maxHM = totalErrHM 
            }                  
            countHM = countHM + 1
          }
          
          else{
            
            if(maxHM > totalErrHM){
              
              index = which.max(resultHM)
              resultHM[index] = totalErrHM
              nameHM[index] = fileName
              maxHM = max(resultHM)
              
            }          
          }  
#Calculation for LM       
          MAE_LM = matrix(NA,1,length(testData))  
          fitDataLM = tslm(trainData ~ trend)
          forecastDataLM = forecast(fitDataLM, h=length(testData))
          
          for(i in 1:length(testData)){      
            MAE_LM[1,i] = abs(forecastDataLM$mean[i] - testData[i])
          }  
          totalErrLM = sum(MAE_LM[1,1:10])
          
          if(countLM <= 10){
            resultLM[countLM] = totalErrLM
            nameLM[countLM] = fileName
            if(maxLM < totalErrLM){
              maxLM = totalErrLM 
            }                  
            countLM = countLM + 1
          }
          
          else{
            
            if(maxLM > totalErrLM){
              
              index = which.max(resultLM)
              resultLM[index] = totalErrLM
              nameLM[index] = fileName
              maxLM = max(resultLM)
              
            }          
          }  
        }   
      }
    }
  }
  print("------RESULTS OF HOLTWINTERS FORECASTING------")
  pOrderHM = order(resultHM)
  for(i in 1:10){
    print(paste(i,nameHM[pOrderHM[i]],resultHM[pOrderHM[i]]))
  }
  print("------------------------------------------------------------")
  print("------RESULTS OF LINEAR REGRESSION FORECASTING------")
  pOrder = order(resultLM)
  for(i in 1:10){
    print(paste(i,nameLM[pOrder[i]],resultLM[pOrder[i]]))
  }  
  print("------------------------------------------------------------")
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
          
          fitDataAR = auto.arima(trainData)
          forecastData = forecast(fitDataAR, h=length(testData))
          
          for(i in 1:length(testData)){      
            
            MAE[1,i] = abs(forecastData$mean[i] - testData[i])
          }      
          totalErr = sum(MAE[1,1:10])
          
          if(countAR <= 10){
            resultAR[countAR] = totalErr
            nameAR[countAR] = fileName
            if(maxAR < totalErr){
              maxAR = totalErr 
            }                  
            countAR = countAR + 1
          }
          
          else{
            
            if(maxAR > totalErr){
              
              index = which.max(resultAR)
              resultAR[index] = totalErr
              nameAR[index] = fileName
              maxAR = max(resultAR)
            }          
          }        
        }   
      }
    }
  }
  close(opener)
  print("------RESULTS OF ARIMA FORECASTING------")
  pOrder = order(resultAR)
  for(i in 1:10){
    print(paste(i,nameAR[pOrder[i]],resultAR[pOrder[i]]))
  }
  
  #   write(resultAR,file = "/user/mimanshu/R_Proj/AM_Values.txt")
  #   write(nameAR,file = "/user/mimanshu/R_Proj/AM_Names.txt")
  
  elapsed = proc.time() - ptm
  print(paste("Total Time taken:",elapsed[3]))
}

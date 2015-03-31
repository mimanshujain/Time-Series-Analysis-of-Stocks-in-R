# Time-Series-Analysis-of-Stocks-in-R

#Introduction 
 
We   were   needed   to   use   R   to   implement   the   time­series   forecast   of   stocks   in   NASDAQ   of  
which   the   data   was   provided.   The   execution   of   R   code   has   to   be   done   in   CCR.   The  
approaches used are: 
● Linear Regression Model 
● Holt­Winters Model 
● ARIMA model 
 
#Package Usages 
 
● Forecast​
:   Provides   the   necessary   functionality   of   converting   and   evaluating   the   data  
for   time   series   analysis.   The   models   that   are   implemented   in   the   code   use   the   library  
function provided by this package 
● Fpp​
: This library has functionality that builds over the Forecast package. 
● Plotly​
: This is the Graphics library used. 
 
#Evaluation Metric 
 
The   MAE   (Mean   Absolute   Error)   is   a   common   measure   to   evaluate   error   in   time   series  
analysis.

#Goal of the Project 
 
● Based   on   the   above   metric   we   needed   to   find   stocks   with   best­forecasted  
performance,   i.e.   stocks   with   the   minimum   value   of   Sum   MAE   value.   Stock   which   are  
best fitting the model learned using the Models mentioned above. 
● Also   we   were   required   to   compare   three   techniques,   namely,   Linear   Regression  
Model, Holt­Winters Model, and ARIMA model. 

#Implementation and Result of Linear Regression Model 
 
Function used for calculation: 

● tslm(trainData ~ trend) 
○ tslm = Name of the function 
○ trainData   =   Adjusted   close   price   time   series   data   fetched   from   the   csv   file   for  
the first 744 days. 
○ trend   =   Seasonality   used   in   the   formula.   Uses   “dummy   variables”   for   seasons.  
In R, tslm automatically generates seasonal dummies for a ts object 

#Implementation and Result of Holt­Winters Model
 
Function used for calculation: 

● HoltWinters(trainData, gamma = FALSE) 
○ HoltWinters = An object of class "HoltWinters" 
○ trainData   =   Adjusted   close   price   time   series   data   fetched   from   the   csv   file   for  
the first 744 days. 
○ gamma = This parameter will do the exponential smoothing 

#Implementation and Result of ARIMA Model  
 
Function used for calculation: 

● auto.arima(trainData) 
○ auto.arima   =   Fit   best   ARIMA   model   to   univariate   time   series   (from  
documentation) 
○ trainData   =   Adjusted   close   price   time   series   data   fetched   from   the   csv   file   for  
the first 744 days.

#Problems Faced  
 
● While   executing   the   code,   the   values   were   changing   as   the   parameter   of   various   mode  
functions   were   changing.   Hence   the   experimentation   process   followed   was   focussed  
on getting the actual trends with the minimum error. 
● At   the   CCR,   the   Single   Node   8   core   machine   was   selected   in   the   SLURM   script   but  
this was leading to printing the value 8 times, each time for each core. 
● Also,   care   needed   when   dealing   with   the   non   existing   files   or   files   which   are   empty  
since the execution  may get halted in between and will be failed job.

#Comparison Between the Models 
 
Different   trends   were   observed   for   different   models.   The   reason   could   be   different   fitting   of   the  
training   data.   Since   the   models   are   trying   to   learn   a   generalized   representation   of   data   which  
results   in   a   Mathematical   equation   (Linear   or   Nonlinear,   depends   upon   the   model   and  
parameters   used).   When   the   test   data   is   given   to   this   equation,   it   will   generate   the   values   and  
we   will   calculate   the   value.   Now   the   deviation   of   this   calculated   value   with   respect   to   the  
actual   values   is   the   Error.   Since   we   are   getting   dissimilar   trends   for   different   models   we   can  
rightly say that the Equation differs for each case. 

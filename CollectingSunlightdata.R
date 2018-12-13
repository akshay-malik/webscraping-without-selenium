library(jsonlite)

# Function taking in a start and end year and looping over the API
# to collect sunrise and sunset for every 15th day of every month in those years

# The reason we use 15th day is because we do not know which day the crash actually took place from Penn DOT data
  collectSunlightData <- function(y, z){
    
    #To run through the City's proxy server
    Sys.getenv("http_proxy")
    
    
    #API for pulling weather data, date must be in format YEAR-MM-DD
    baselink <- "http://api.sunrise-sunset.org/json?lat=39.952583&lng=-75.165222&date="
    
    month <- c(1:12)
    day <- 15

    #lists to be collected
    sunriseList <- c()
    sunsetList <- c()
    dateList <- c()
    
    #Function for looping through all years 
    # y - start year
    # z - end year
    
    for (i in y:z) {
      
          # Looping for everymonth for every year "i"  
          for (j in month) {
            
            # assemble the date
            date <- paste(i, j, day, sep = "-")        
            
            # assemble the api
            api <- paste(baselink, date, sep = "") 
            api
            
            returnFromApi <- fromJSON(api)
            
        #####Sunrise
            sunriseGMT<- paste(date, returnFromApi$results$sunrise, sep = " ")
            sunriseGMT <- as.POSIXct(sunriseGMT,format='%Y-%m-%d %I:%M:%S %p', tz = "GMT")
            sunriseEST <- format(sunriseGMT, tz="EST") 
            sunriseTime <- substr(sunriseEST, 12, 21)
            
            #Adding it to the list
            sunriseList <- c(sunriseList, sunriseTime)  
            sunriseList
            
        #####Sunset
            sunsetGMT<- paste(date, returnFromApi$results$sunset, sep = " ")
            sunsetGMT <- as.POSIXct(sunsetGMT,format='%Y-%m-%d %I:%M:%S %p', tz = "GMT")
            sunsetEST <- format(sunsetGMT, tz="EST") 
            sunsetTime <- substr(sunsetEST, 12, 21)
            
            #Adding it to the list
            sunsetList <- c(sunsetList, sunsetTime)  
            sunsetList
            
        #####CompileDate   
            dateList <- c(dateList, date)
                        
        }
    }
    
    compiledata <- data.frame(dateList, sunriseList, sunsetList)
    names(compiledata) <- c("Date", "Sunrise Time (EST)", "Sunset Time (EST)")
    return(compiledata)
  }
  


finalData <- collectSunlightData(2013, 2017)


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
            risingDateTime <- paste(date, returnFromApi$results$sunrise, sep = " ")
            risingDateTime
            
            # convert time to date-time format and adjusting by 5 hrs to change UTC to EST 
            pulledsunrise <- as.POSIXct(risingDateTime, tz="EST") 
            sunrise <- pulledsunrise - 5*60*60
            sunrise
            
            #Adding it to the list
            sunriseList <- c(sunriseList, as.character(sunrise))  
            sunriseList
            
        #####Sunset
            settingDateTime <- paste(date, returnFromApi$results$sunrise, sep = " ")
            settingDateTime
            
            # convert time to date-time format and adjusting by 5 hrs to change UTC to EST 
            pulledsunset <- as.POSIXct(settingDateTime, tz="EST") 
            sunset <- pulledsunrise - 5*60*60
            sunset
            
            #Adding it to the list
            sunsetList <- c(sunsetList, as.character(sunrise))  
            sunsetList
            
                        
        }
    }
    
    compiledata <- data.frame(sunriseList, sunsetList)
    return(compiledata)
  }
  


finalData <- collectSunlightData(2013, 2017)


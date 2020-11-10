suppressMessages({
  library(sf)
  library(dbscan)
  library(spatstat)
  library(cluster)
  library(sp)
  library(rgeos)
  library(jsonlite)
  library(taRifx)
  library(geojsonio)
})

# Get worker function
dbscan_clusterer <- dget("R/dbscan_clusterer.R")
source("R/default_params.R")

process <- function(request_path,
                    result_path
) {
  
  #setwd(request_path)
  
  user_params <- fromJSON(readLines(file.path(request_path, 'request.json')))
  
  # Set all defaults
  params_with_defaults <- merge.list(user_params, defaults)
  write(toJSON(params_with_defaults, auto_unbox = T), stdout())
  
  # Run some tests?
  # If conducting adaptive sampling using exceedance prob, then need an exceedance threshold
  # preprocess_result <- preprocess_params(params) # Should return 0 if anything fails - return at first fail
  # 
  # if(preprocess_result == 0){
  #   return(0)
  # }
  
  # Run function
  result <- dbscan_clusterer(params_with_defaults,
                      result_path = result_path)
  
  # Return anything
  return(1)
}
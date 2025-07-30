# Test API code
# renv install packages
install(c("httr", "jsonlite"))

# library load
library(httr)
library(jsonlite)
library(glue)

apicall = GET("https://api.jolpi.ca//ergast/") # core api access
apicall = fromJSON(content(apicall, "text"), flatten = TRUE, simplifyVector = TRUE) # loads the API call json file
apicall_season <- map(apicall, ~ str_replace(.x, "/2025/", "/{season}/")) # replaces the fixed year with a variable for season


seasons <- GET(paste0(apicall$season,"?limit=76"))
seasons <- fromJSON(content(seasons, "text"), flatten = TRUE, simplifyVector = TRUE)

seasons <- seasons$MRData$SeasonTable$Seasons

season <- c(2022, 2025)
#drivers <- GET(glue(paste0(apicall_season$driver)))
#drivers <- fromJSON(content(drivers, "text"), flatten = TRUE, simplifyVector = TRUE)

#drivers <- drivers[["MRData"]][["DriverTable"]][["Drivers"]]

# Code downloads all drivers for all specififed seasons
drivers_all <- map_dfr(seasons$season, 
                       ~ {
                         Sys.sleep(5)  # Five secound deley to avoid hitting API rate limits
                         print(.x)
                         drivers <- GET(glue("https://api.jolpi.ca/ergast/f1/{.x}/drivers"))
                         drivers <- fromJSON(content(drivers, "text"), flatten = TRUE, simplifyVector = TRUE)
                         data <- drivers[["MRData"]][["DriverTable"]][["Drivers"]] %>% 
                           mutate(season = .x)
                       })

saveRDS(drivers_all, file.path("data", "drivers_all.rds"))

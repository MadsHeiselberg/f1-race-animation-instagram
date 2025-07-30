# Test API code
# renv install packages
install(c("httr", "jsonlite"))

# library load
library(httr)
library(jsonlite)
library(glue)

apicall = GET("https://api.jolpi.ca//ergast/")
apicall = fromJSON(content(apicall, "text"), flatten = TRUE, simplifyVector = TRUE)
apicall_season <- map(apicall, ~ str_replace(.x, "/2025/", "/{season}/"))



seasons <- GET(paste0(apicall$season,"?limit=76"))
seasons <- fromJSON(content(seasons, "text"), flatten = TRUE, simplifyVector = TRUE)

seasons <- seasons$MRData$SeasonTable$Seasons

season <- c(2022, 2025)
#drivers <- GET(glue(paste0(apicall_season$driver)))
#drivers <- fromJSON(content(drivers, "text"), flatten = TRUE, simplifyVector = TRUE)

#drivers <- drivers[["MRData"]][["DriverTable"]][["Drivers"]]

drivers_all <- map_dfr(seasons$season, 
                       ~ {
                         Sys.sleep(0.5)  # half-second delay
                         print(.x)
                         drivers <- GET(glue("https://api.jolpi.ca/ergast/f1/{.x}/drivers"))
                         drivers <- fromJSON(content(drivers, "text"), flatten = TRUE, simplifyVector = TRUE)
                         data <- drivers[["MRData"]][["DriverTable"]][["Drivers"]] %>% 
                           mutate(season = .x)
                       })



race_all <- map_dfr(2025, 
                       ~ {
                         Sys.sleep(0.5)  # half-second delay
                         print(.x)
                         api <- GET(glue("https://api.jolpi.ca/ergast/f1/{2000}/labs"))
                         api <- fromJSON(content(api, "text"), flatten = TRUE, simplifyVector = TRUE)
                         data <- api[["MRData"]][["RaceTable"]][["Races"]]%>% 
                           mutate(season = .x)
                       })
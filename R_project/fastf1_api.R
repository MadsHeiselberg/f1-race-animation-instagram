# Test API code
# renv install packages
install(c("httr", "jsonlite"))

# library load
library(httr)
library(jsonlite)

res = GET("https://api.jolpi.ca//ergast/f1/fastest/1/status/")

res

rawToChar(res$content)

data = fromJSON(rawToChar(res$content))
names(data)
names(data$MRData)

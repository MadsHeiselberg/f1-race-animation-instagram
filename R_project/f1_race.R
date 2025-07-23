#install.packages("f1dataR")
#install.packages("gganimate")
#install.packages("transformr")

library(f1dataR)

tryCatch(load_laps(season = 2022, round = 15), error = function(e) {
  message("Ensure fastf1 Python package is installed.")
  setup_fastf1()
})
library(gganimate)
library(ggplot2)
library(tidyverse)

# Load the data
laps <- load_laps(season = 2022, round = 15)
VER <- load_driver_telemetry(season = 2022, round = 15)

circuit <-load_circuit_details(season=2022)
session <- load_session_laps(season = 2022, round = 15, add_weather = TRUE)


# Make sure data is sorted
VER_ordered <- VER %>% arrange(time)


# Make a copy of the data without the time column
VER_static <- VER_ordered[, c("x", "y")]

ggplot() +
  # 🟢 Static full track path (not affected by animation)
  geom_path(data = VER_static, aes(x = x, y = y), 
            color = "grey70", size = 1) +
  
  # 🔴 Animated moving car
  geom_point(data = VER_ordered, aes(x = x, y = y, color = driver_code), 
             size = 3) +
  
  coord_equal() +
  theme_minimal() +
  labs(title = 'Driver Position: {frame_time}s') +
  transition_time(time) +
  ease_aes('linear') +
  shadow_mark(alpha = 0.3)


# ⬇️ Here's the important part
animate(p, nframes = 100, fps = 25, width = 800, height = 600, 
        renderer = gifski_renderer(), 
        # 👇 this tells gganimate not to strip out static layers
        keep_last = TRUE,
        static_layers = TRUE)
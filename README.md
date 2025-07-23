# f1-race-animation-instagram
Goal: Automatically post animated visualizations of F1 races to Instagram using OpenF1 data, leveraging Python for orchestration, R/gganimation for visualization, shell scripts for automation, and GitHub Actions for scheduling.

## Project Tasks to achieve the goal

#### R
- Data gathering from OpenF1 dataset.
- Plot racetrack in ggplot.
- Animate race for two drivers:
   	- Racing line
   	- Speed count
   	- Braking points
- Save animation in mp4 file format.

#### Python
- Generate an Instagram API token.
- Animation upload script.
- Automatic caption text generation.

#### Bash
- Script that runs R and Python scripts:
  - Selection of drivers
  - Generation of animation
  - Uploading of the animation

#### GitHub Actions automation
- Runs the bash script once a day.

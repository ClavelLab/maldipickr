# fusen container for maldipickr package development
# 2023-03-08
FROM rocker/tidyverse:4.2

RUN install2.r --repos https://thinkr-open.r-universe.dev --repos https://cloud.r-project.org --error --skipinstalled fusen MALDIquant MALDIquantForeign tidyverse tidygraph coop

# Add configuration file for Rstudio
RUN echo '{\
    "save_workspace": "never",\
    "always_save_history": false,\
    "reuse_sessions_for_project_links": true,\
    "help_font_size_points": 14,\
    "initial_working_directory": "/data",\
    "font_size_points": 14,\
    "posix_terminal_shell": "bash",\
    "server_editor_font_enabled": true,\
    "server_editor_font": "Hack"\
}' > /home/rstudio/.config/rstudio/rstudio-prefs.json

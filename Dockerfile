# fusen container for maldipickr package development
# 2023-03-08
FROM rocker/tidyverse:4.2

# Solving the libMagick++ library issue
RUN apt-get update \
    && apt-get -y install libmagick++-dev \
	## Remove packages in '/var/cache/' and 'var/lib'
	## to remove side-effects of apt-get update
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

RUN install2.r --repos https://thinkr-open.r-universe.dev --repos https://cloud.r-project.org --error --skipinstalled fusen MALDIquant MALDIquantForeign tidyverse tidygraph coop markdown styler magick

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

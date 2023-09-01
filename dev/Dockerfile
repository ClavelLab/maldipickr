# fusen container for maldipickr package development
# 2023-08-28
FROM rocker/tidyverse:4.3

# Solving the libMagick++ library issue
RUN apt-get update \
    && apt-get -y install libmagick++-dev qpdf \
	## Remove packages in '/var/cache/' and 'var/lib'
	## to remove side-effects of apt-get update
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /var/cache/* /var/lib/*

RUN install2.r --ncpus -1 --repos https://cloud.r-project.org --error --skipinstalled fusen MALDIquant MALDIquantForeign tidyverse coop markdown styler magick knitr rmarkdown spelling

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

#!/bin/bash

# Get the constants
source ddev-wp-setup-script/constants.sh

# Get the install settings
source ${ROOT_DIR}/settings.sh

echo '' # new line

# Confirm WP_USER_EMAIL is a valid email address before proceeding
if ! [[ "$WP_USER_EMAIL" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
  printf "${BRIGHT_RED}ERROR: ${WP_USER_EMAIL}${RESET}${RED} is not a valid email address. Please update the ${BRIGHT_RED}WP_USER_EMAIL${RESET}${RED} setting in ${BRIGHT_RED}settings.sh${RESET}${RED} with a valid email and rerun the install script.${RESET}\n\n"
  exit 1
fi

# Install WP Core Files in 'wordpress' directory with roots/wordpress composer package
printf "${BLUE}Adding WordPress core files with roots/wordpress composer package...${RESET}\n"
if [ -f composer.json ]; then
  composer config --no-interaction allow-plugins.roots/wordpress-core-installer true
  composer require --dev roots/wordpress
else
  composer init --author CassidyDC --require roots/wordpress:'*' --no-interaction
  composer config --no-interaction allow-plugins.roots/wordpress-core-installer true
  composer require --dev roots/wordpress
fi
echo '' # new line

# Create index.php file to point WP Core install to wordpress directory
printf "${BLUE}Creating index.php file...${RESET}\n"
if [ -f index.php ]; then
  printf "${BLACK}The index.php file already exists. Skipping creation.${RESET}\n\n"
else
  # Copy/Paste file
  cp ${ROOT_DIR}/files/index.php index.php
  # Print success message
  printf "${GREEN}File created at: ${BOLD}index.php${RESET}\n\n"
fi

# Create wp-cli.yml file to point wp-cli to wordpress core directory
printf "${BLUE}Creating wp-cli.yml file...${RESET}\n"
if [ -f wp-cli.yml ]; then
  printf "${BLACK}The wp-cli.yml file already exists. Skipping creation.${RESET}\n\n"
else
  # Copy/Paste file
  cp ${ROOT_DIR}/files/wp-cli.yml wp-cli.yml
  # Print success message
  printf "${GREEN}File created at: ${BOLD}wp-cli.yml${RESET}\n\n"
fi

# Set DDEV containers configuration
if [ -n "$CUSTOM_TABLE_PREFIX" ]; then
  printf "${BLUE}Setting DDEV configurations with a custom table prefix...${RESET}\n"
  ddev config --project-type=wordpress --project-name=$PROJECT_NAME_SLUG --web-environment-add="TABLE_PREFIX=$CUSTOM_TABLE_PREFIX"
else
  printf "${BLUE}Setting DDEV configurations...${RESET}\n"
  ddev config --project-type=wordpress --project-name=$PROJECT_NAME_SLUG
fi
echo '' # new line

# Add WP Config constants and set DDEV post-start hooks for restarts
if $ADD_WP_CONFIG_SETTINGS; then
  source ${MODULES_DIR}/ddev-hooks-module.sh

  # Create the log directory if it's set in the settings and doesn't yet exist
  if [ -n "$WP_DEBUG_LOG_VALUE" ] && [ "$WP_DEBUG_LOG_VALUE" != "false" ]; then
    LOG_DIR="$(dirname "$WP_DEBUG_LOG_VALUE")"

    if [ -n "$LOG_DIR" ]; then
      printf "${BLUE}Creating $LOG_DIR directory...${RESET}\n"
      if [ -d "$LOG_DIR" ]; then
        printf "${BLACK}The '$LOG_DIR' directory already exists. Skipping creation.${RESET}\n\n"
      else
        mkdir -p "$LOG_DIR"
        # Print success message
        printf "${GREEN}New directory created at: ${BOLD}${LOG_DIR}${RESET}\n\n"
      fi
    else
      printf "${RED}WP_DEBUG_LOG_VALUE is not set. Skipping directory creation.${RESET}\n\n"
    fi
  fi
fi

# Create themes directory
printf "${BLUE}Creating wp-content/themes directory...${RESET}\n"
if [ ! -d wp-content/themes ]; then
  mkdir -p wp-content/themes
  printf "${GREEN}Directory created at: ${BOLD}wp-content/themes${RESET}\n\n"
else
  printf "${BLACK}The wp-content/themes directory already exists. Skipping creation.${RESET}\n\n"
fi

# Create plugins directory
printf "${BLUE}Creating wp-content/plugins directory...${RESET}\n"
if [ ! -d wp-content/plugins ]; then
  mkdir -p wp-content/plugins
  printf "${GREEN}Directory created at: ${BOLD}wp-content/plugins${RESET}\n\n"
else
  printf "${BLACK}The wp-content/plugins directory already exists. Skipping creation.${RESET}\n\n"
fi

# Add Spatie Ray app files for development env.
if $INSTALL_RAY_CONNECTIONS; then
  source ${ROOT_DIR}/modules/ray-app-connections-module.sh
fi

# Add git and git assets.
if $INSTALL_GIT; then
  source ${ROOT_DIR}/modules/git-local-setup-module.sh
fi

# Build and start the project's Docker containers.
printf "${BLUE}Starting DDEV containers...${RESET}\n"
ddev start $PROJECT_NAME_SLUG
echo '' # new line

# Install WP with selected plugins and themes
source ${ROOT_DIR}/modules/wp-install-module.sh

printf "${MAGENTA}${BOLD}The ddev-wp-setup-script installation process is all finished! You may delete the /ddev-wp-setup-scripts directory if no errors were present.${RESET}\n\n"

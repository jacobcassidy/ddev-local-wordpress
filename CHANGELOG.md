# Changelog for `ddev-wp-setup-script`

## 2.1.0

_2025-07-22_

-   Added setting and post-start hook for custom WP table prefix.

## 2.0.0

_2025-07-21_

This version refactors the install setup to separate WordPress Core files from the rest of the files, including wp-content.

-   Replaced the default WordPress install with the `roots/wordpress` composer package for installing core files in the `wordpress` directory.
-   Added a root `index.php` file to point to the WP Core `wordpress/index.php` file.
-   Added a root `wp-cli.yml` file to point the WP CLI path to the `wordpress` directory.
-   Refactored `.gitignore` file and renamed it to `gitignore.txt` since it's a template and not suppose to act as a real .gitignore file in this repo.
-   Refactored and rename the `wp-starter-setup-module.sh` to `wp-install-module.sh`.
-   Refactored DDEV post-start hooks install order so they get added to wp-config.php on the first start (previously they were only added after a restart).
-   Renamed `wp-debug-log-setup-module.sh` to `ddev-post-start-hooks-module.sh`.

## 1.6.2

_2025-04-02_

-   Fixed typos.
-   Removed all development configuration files. (These files are now part of a separate repo located at `https://github.com/jacobcassidy/wp-dev-config-files`)
-   Renamed `config.sh` to `settings.sh`
-   Replaced `array()` with short syntax `[]`
-   Restructured file organization to simplify setup.
-   Updated AIO unlimited extension version.
-   Updated README.md content for file restructure.
-   Updated the default value for the local AIOMUE plugin to `false` since it's a paid plugin that needs a local file source.

## 1.6.1

_2024-12-04_

-   Added 2s sleep timing to post-start hooks to allow system to finalize before execution.

## 1.6.0

_2024-11-29_

-   Added check that email address is valid before running install script.
-   Separated WP download and install processes and included relevant messages.
-   Updated custom yellow terminal messages with black.

## 1.5.0

_2024-11-28_

-   Added `$HIDE_DASHBOARD_WIDGETS` setting to remove default WordPress dashboard widgets and welcome panel.
-   Updated `README.md` content for clarity.

## 1.4.1

_2024-11-27_

-   Updated configuration file to have individual controls for WP debugging and env settings.
-   Updated log directory creation logic to be dynamic.

## 1.4.0

_2024-11-27_

-   Added `SCRIPT_DEBUG` to setup.

## 1.3.4

_2024-11-25_

-   Fixed broken AIOMUE plugin unzip path.
-   Updated README with note on Query Monitor plugin installation option
-   Updated `$WP_SITE_TITLE` with default name and override option.

## 1.3.3

_2024-11-25_

-   Added installation option for Query Monitor plugin and AIOMUE local path variable.

## 1.3.2

_2024-11-24_

-   Added boolean install options for default and starter themes.
-   Fixed the `$PROJECT_TITLE` value by using `awk` for capitalizing the first letter of each word.
-   Updated the README to improve ability to quickly scan for the commands.

## 1.3.1

_2024-11-24_

-   Added the `$PROJECT_TITLE` variable.
-   Updated `$WP_SITE_TITLE` to use `$PROJECT_TITLE` variable.

## 1.3.0

_2024-11-24_

-   Added the `PROJECT_NAME_SLUG` variable for the ddev project name, which replaces whitespaces with dashes and uppercase letters with lowercase letters in the `$PROJECT_NAME` variable.
-   Updated `$WP_SITE_TITLE` to use `$PROJECT_NAME` variable.
-   Updated `DEFAULT_THEME_SLUG` value to `twentytwentyfive`.
-   Updated `PROJECT_NAME` logic to remove any leading symbols.
-   Updated cloned git removal message.

## 1.2.0

_2024-11-11_

-   Added `.dev-assets`, `.env` and `vendor` to .gitignore list.
-   Moved `constants.sh` inside `/modules`.

## 1.1.0

_2024-10-06_

-   Fixed WP debugging config settings getting overwritten when restarting DDEV with the addition of `wp-debug-log-setup-module.sh`.
-   Added boolean option for installing WP Debug.
-   Refactored order script are run in.
-   Added `CHANGELOG.md` file.
-   Updated terminal colors used for various messages.
-   Updated the `files/vscode-settings.json` file's CSS and HTML settings for formatting to WordPress Code Standard
-   Renamed and moved `./scripts/script-variables.sh` to `./constants.sh`.

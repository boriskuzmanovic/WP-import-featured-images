# WP-import-featured-images

##About

This script will connect to remote WP server via ```wp ssh``` and grab a list of all featured images. It will then filter the output and convert it to a ```wp media import``` format that is being ran on the local WP installation. You should not have any featured images in your local server. If you do, you will end up with duplicate media files on your server. Therefore, run this script only once! Don't worry, it will ask for confirmation to prevent accidental imports.

In any case, backup your ```uploads``` folder, as well as your WP database before running the script.

##Requirements
- WordPress
- [WP-CLI](https://github.com/wp-cli/wp-cli)
- [WP-CLI ssh](https://github.com/x-team/wp-cli-ssh)

##Installation

Clone this project and tweak the settings in import.sh.

##Running the script
To run the script type ```./import.sh``` in command line. When the script starts, it will ask you to confirm the import. Be careful! It will login to the remote server and import all featured images from it, creating duplicates in your Media if your site has. Other than a regular y/n answer, you can select [d]ryrun, to perform all but the final step of running WP-CLI media import commands. You can use the output of the dry-run to manually verify it prior to launching it in shell.

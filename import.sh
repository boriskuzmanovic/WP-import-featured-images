#!/bin/bash

# This script runs the following steps:
# 1. Uses 'wp ssh' to execute a SQL query on remote server to fetch a list of 
#    featured images.
# 2. This list is saved to a tab delimited dump file.
# 3. First line of this dump file is skipped (tail -n+2) and the rest is
#    formatted as a list of 'wp media import' commands. This is done in the
#    external PHP program.
# 4. The list is passed to bash for processing.

WP_CONTENT_DIR="/home/yh/public_html/wp-content" 
SCRIPT_DIR="/root/wp_import_featured_images"     # No trailing slash
DB_DUMP_FILE="$SCRIPT_DIR/db_dump"
HOST_ALIAS=rehab

read -p "Are you sure you want to import featured images ([y]es/[n]o/[d]ryrun)?" choice
case "$choice" in 
  y|Y )
    COMMAND=bash
    ;;
  n|N )
    exit
    ;;
  d|D )
    COMMAND=cat
    ;;
  * )
    echo "invalid"
    exit
    ;;
esac

cd $WP_CONTENT_DIR

wp ssh --host=$HOST_ALIAS db query <<ENDSQL > $DB_DUMP_FILE
SELECT  p2.ID att_id,
        p2.post_title att_title,
	p2.post_author,
	p2.post_content,
	p2.post_excerpt,
	p2.post_name,
	p.ID post_id,
	m.meta_id,
	( SELECT guid FROM wp_posts WHERE id = m.meta_value ) AS url 
FROM wp_posts p 
	JOIN wp_postmeta m ON  p.id = m.post_id
	JOIN wp_posts p2 ON p2.ID=m.meta_value
WHERE p.post_type =  'post'
AND p.post_status =  'publish'
AND m.meta_key =  '_thumbnail_id'
ENDSQL

# Generate command list. If dry run, display it. Otherwise, run the list.
tail -n+2 $DB_DUMP_FILE | php $SCRIPT_DIR/command_format.php | $COMMAND

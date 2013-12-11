<?
# This PHP code reads a line from standard input (db fields separated by tabs) and formats it 
# to conform to "wp media import" format as output.
# Note: Not all input fields are used.
while (FALSE !== ($line = fgets(STDIN))) {
   $line = chop($line);

   list($att_id, $att_title, $att_autor, $att_content, $att_excerpt, $att_slug, $post_id, $meta_id, $att_url) = preg_split("#\t#", $line);

   $command = sprintf("wp media import %s --post_id=%s",
      escapeshellarg($att_url),
      escapeshellarg($post_id)
   );

   if ($att_title) 
      $command .= " --title=" . escapeshellarg($att_title);

   if ($att_excerpt) 
      $command .= " --caption=" . escapeshellarg($att_excerpt);

   if ($att_content) 
      $command .= " --desc=" . escapeshellarg($att_content);

   echo $command . " --featured_image\n\n";
}

?>
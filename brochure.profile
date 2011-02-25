<?php
// $Id$

/**
 * Profiler library invocation
 *   All profile content should reside in brochure.info
 */

!function_exists('profiler_v2') ? require_once('libraries/profiler/profiler.inc') : FALSE;
profiler_v2('brochure'); 

/**
 * Custom setup code. Runs at the very end of the install process.
 */

function brochure_install() {

  // Hide all blocks
  db_query("UPDATE {blocks} SET status=0 WHERE theme='brochure_basic'");

  // Add superfish primary links to leaderboard
  db_query("INSERT INTO {blocks}(status, weight, region, module, delta, theme, cache, title) VALUES (1, 10, 'footer', 'superfish', '1', 'brochure_basic', -1, ' ');");

  // Add menu for documentation node
  $link = array(
    'menu_name' => 'menu-administration',
    'link_path' => 'node/1',
    'link_title' => 'Documentation',
  );
  menu_link_save($link);

}
 

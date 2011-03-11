<?php
// $Id$

/**
 * Custom setup code. Runs at the very end of the install process.
 */

function brochure_install() {

  // Hide all blocks
  db_query("UPDATE {blocks} SET status=0 WHERE theme='brochure_basic'");

  // Add superfish primary links to leaderboard
  db_query("INSERT INTO {blocks}(status, weight, region, module, delta, theme, cache, title) VALUES (1, 10, 'header', 'superfish', '1', 'brochure_basic', -1, ' ');");

  // Add menu for documentation node
  $link = array(
    'menu_name' => 'menu-administration',
    'link_path' => 'node/1',
    'link_title' => 'Documentation',
  );
  menu_link_save($link);

  // Insert default user-defined node types into the database. For a complete
  // list of available node type attributes, refer to the node type API
  // documentation at: http://api.drupal.org/api/HEAD/function/hook_node_info.
  $types = array(
    array(
      'type' => 'page',
      'name' => st('Page'),
      'module' => 'node',
      'description' => st("A <em>page</em>, similar in form to a <em>story</em>, is a simple method for
creating and displaying information that rarely changes, such as an \"About us\" section of a website. By
default, a <em>page</em> entry does not allow visitor comments and is not featured on the site's initial home
page."),
      'custom' => TRUE,
      'modified' => TRUE,
      'locked' => FALSE,
      'help' => '',
      'min_word_count' => '',
    ),
    array(
      'type' => 'story',
      'name' => st('Story'),
      'module' => 'node',
      'description' => st("A <em>story</em>, similar in form to a <em>page</em>, is ideal for creating and
displaying content that informs or engages website visitors. Press releases, site announcements, and informal
blog-like entries may all be created with a <em>story</em> entry. By default, a <em>story</em> entry is
automatically featured on the site's initial home page, and provides the ability to post comments."),
      'custom' => TRUE,
      'modified' => TRUE,
      'locked' => FALSE,
      'help' => '',
      'min_word_count' => '',
    ),
  );

  foreach ($types as $type) {
    $type = (object) _node_type_set_defaults($type);
    node_type_save($type);
    // Store some result for post-processing in the finished callback.
    $context['results'][] = t('Set up node type %type.', array('%type' => $type->name));
  }

  // Default page to not be promoted and have comments disabled.
  variable_set('node_options_page', array('status'));
  variable_set('comment_page', COMMENT_NODE_DISABLED);

  // Don't display date and author information for page nodes by default.
  $theme_settings = variable_get('theme_settings', array());
  $theme_settings['toggle_node_info_page'] = FALSE;
  variable_set('theme_settings', $theme_settings);

  // Update the menu router information.
  menu_rebuild();

}

/**
 * Profiler library invocation
 *   All profile content should reside in brochure.info
 */

!function_exists('profiler_v2') ? require_once('libraries/profiler/profiler.inc') : FALSE;
profiler_v2('brochure');



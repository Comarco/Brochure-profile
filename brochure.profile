<?php
// $Id: default.profile,v 1.22 2007/12/17 12:43:34 goba Exp $

/**
 * Return an array of the modules to be enabled when this profile is installed.
 *
 * @return
 *   An array of modules to enable.
 */
function brochure_profile_modules() {
  return array(
  'dblog',
  'color',
  'contact',
  'comment',
  'help',
  'locale',
  'menu',
  'path',
  'php', /* <= should deasapper in the near future */
  'search',
  'taxonomy',
  'translation',
  'upload',

/**
 *   Contrib modules
**/

  'adminrole',
  'admin_menu',
/*  'boxes',*/
  'bueditor',
  'ctools',
  'ctools_custom_content',
  'content',
  'context',
  'context_ui',
  'ctools',
  'custom_pagers',
  'devel', /* provisory */
  'diff', /* provisory */
  'features',
  'filefield',
  'filefield_paths',
  'fontyourface',
/*  'i18n', */
/*  'i18nblocks', */
/*  'i18ncck', */
/*  'i18nmenu', */
/*  'i18nstrings', */
/*  'i18nsync', */
/*  'i18ntaxonomy', */
/*  'i18nviews', */
  'imageapi',
  'imageapi_gd',
  'imagecache',
  'imagecache_autorotate',
  'imagecache_canvasactions',
  'imagecache_coloractions',
  'imagecache_customactions',
  'imagecache_effects',
  'imagecache_textactions',
  'imagecache_ui',
  'imagefield',
  'image_fupload_imagefield',
  'jquery_plugin',
  'jquery_ui',
  'bueditor',
  'image_fupload',
  'imce',
  'l10n_update',
  'libraries',
  'lightbox2',
  'link',
  'number',
  'optionwidgets',
  'page_manager',
  'panels',
  'prepopulate',
  'strongarm',
  'superfish',
  'skinr',
/*  'stylizer', */
/*  'sweaver', */
  'taxonomy_export',
  'text',
  'token',
  'views',
  'views_content',
  'views_slideshow',
  'views_slideshow_singleframe',
  'views_slideshow_thumbnailhover',
  'views_ui',

/**
 *   Features
**/
/*  'kt_basic', */
  'kt_bookmarks',
  'kt_block_header_image',
  'kt_bueditor_imce',
/*  'kt_i18n', */
  'kt_links',
  'kt_stories',
  'kt_simple_gallery',
/*  'ktodo', */
  'kt_brochure_layouts_boxes',
  );
}

function brochure_profile_details() {
  return array(
    'name' => 'Brochure website Devi 1',
    'description' => 'Create a simple brochure website',
 );
}

function brochure_profile_task_list() {
}

function brochure_profile_tasks(&$task, $url) {

  // Insert default user-defined node types into the database. For a complete
  // list of available node type attributes, refer to the node type API
  // documentation at: http://api.drupal.org/api/HEAD/function/hook_node_info.
  $types = array(
    array(
      'type' => 'page',
      'name' => st('Page'),
      'module' => 'node',
      'description' => st("A <em>page</em>, similar in form to a <em>story</em>, is a simple method for creating and displaying information that rarely changes, such as an \"About us\" section of a website. By default, a <em>page</em> entry does not allow visitor comments and is not featured on the site's initial home page."),
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
      'description' => st("A <em>story</em>, similar in form to a <em>page</em>, is ideal for creating and displaying content that informs or engages website visitors. Press releases, site announcements, and informal blog-like entries may all be created with a <em>story</em> entry. By default, a <em>story</em> entry is automatically featured on the site's initial home page, and provides the ability to post comments."),
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
  }

  // Default page to not be promoted and have comments disabled.
  variable_set('node_options_page', array('status'));
  variable_set('comment_page', COMMENT_NODE_DISABLED);

  // Don't display date and author information for page nodes by default.
  $theme_settings = variable_get('theme_settings', array());
  $theme_settings['toggle_node_info_page'] = FALSE;
  variable_set('theme_settings', $theme_settings);

  variable_set('install_profile', 'brochure');
  drupal_set_title(st("Configuring roles, blocks and theme"));

  // Enable adaptivetheme theme

  $theme = 'brochure_basic';
  drupal_set_message(st("Enabling Brochure_basic theme"));
  $themes = system_theme_data();
  $theme = 'brochure_basic';
  if (isset($themes[$theme])) {
    drupal_set_message('theme exists');
    system_initialize_theme_blocks($theme);
    db_query("UPDATE {system} SET status = 1 WHERE type = 'theme' AND name = '%s'", $theme);
    variable_set('theme_default', $theme);
    drupal_rebuild_theme_registry();
  }

  // Configure blocks

  // Hide all blocks
  db_query("UPDATE {blocks} SET status=0 WHERE theme='brochure_basic'");

  // Add superfish primary links to leaderboard
  db_query("INSERT INTO {blocks}(status, weight, region, module, delta, theme, cache, title) VALUES (1, 10, 'footer', 'superfish', '1', 'brochure_basic', -1, ' ');");

  // Nodes

  // Add documentation node

  $node->type = 'page';
  $node->status = 1;
  $node->title = 'Test';
  $node->body = 'You can start by editing this panel. You can also activate the sweaver module to be abble to changes colors and add some background images. This is worth the try. Full help will come eventually :P';

  node_save($node);

  // Add menu for documentation node

  $link = array(
    'menu_name' => 'menu-administration',
    'link_path' => 'node/'.$node->nid,
    'link_title' => 'Documentation',
  );

  menu_link_save($link);

  // Empty cache

  drupal_flush_all_caches();
}

/**
 * Implementation of hook_form_alter().
 *
 * Allows the profile to alter the site-configuration form. This is
 * called through custom invocation, so $form_state is not populated.
 */
//function brochure_form_alter(&$form, $form_state, $form_id) {
//  if ($form_id == 'install_configure') {
//    // Set default for site name field.
//    $form['site_information']['site_name']['#brochure_value'] = $_SERVER['SERVER_NAME'];
//  }
//}

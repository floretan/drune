<?php

/**
 * Implementation of hook_node_info().
 */
function drune_track_node_info() {
  $items = array(
    'track' => array(
      'name' => t('Track'),
      'base' => 'node_content',
      'description' => '',
      'has_title' => '1',
      'title_label' => t('Title'),
      'help' => '',
    ),
  );
  return $items;
}

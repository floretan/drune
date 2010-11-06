<?php

/**
 * Implementation of hook_user_default_permissions().
 */
function drune_track_user_default_permissions() {
  $permissions = array();

  // Exported permission: create track content
  $permissions['create track content'] = array(
    'name' => 'create track content',
    'roles' => array(),
  );

  // Exported permission: delete any track content
  $permissions['delete any track content'] = array(
    'name' => 'delete any track content',
    'roles' => array(),
  );

  // Exported permission: delete own track content
  $permissions['delete own track content'] = array(
    'name' => 'delete own track content',
    'roles' => array(),
  );

  // Exported permission: edit any track content
  $permissions['edit any track content'] = array(
    'name' => 'edit any track content',
    'roles' => array(),
  );

  // Exported permission: edit own track content
  $permissions['edit own track content'] = array(
    'name' => 'edit own track content',
    'roles' => array(),
  );

  return $permissions;
}

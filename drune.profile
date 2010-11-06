<?php
// $Id$

/**
 * Implements hook_form_FORM_ID_alter().
 *
 * Allows the profile to alter the site configuration form.
 */
function drune_form_install_configure_form_alter(&$form, $form_state) {
  // Set a standard site name.
  $form['site_information']['site_name']['#default_value'] = st('Drune');
}

/**
 * Implements hook_install_tasks().
 */
function drune_install_tasks() {
  $import_audio_files = variable_get('drune_import_audio_files', FALSE);
  $import_source_dir = variable_get('drune_import_source_dir', NULL);

  $tasks = array(
    'drune_setup' => array(
    ),
    'drune_config_form' => array(
      'display_name' => st('Drune Configuration'),
      'type' => 'form',
    ),
    'drune_import' => array(
      'display_name' => st('Import audio files'),
      'type' => 'batch',
      'run' => INSTALL_TASK_RUN_IF_REACHED,//$import_audio_files && isset($import_source_dir) ? INSTALL_TASK_RUN_IF_NOT_COMPLETED : INSTALL_TASK_SKIP,
    ),
  );

  return $tasks;
}

/**
 * Set up initial configuration.
 */
function drune_setup() {
}

/**
 * Form builder function 
 */
function drune_config_form($form_state) {
  drupal_set_title(st('Drune configuration'));
  $form = array();
  $form['drune_content_access'] = array(
    '#type' => 'checkbox',
    '#title' => st('Require a login to access your library'),
    '#default_value' => TRUE,
    '#description' => st('Disabling this option only if you will be installing Drune on a closed network. Making copyrighted music available online can be illegal.'),
  );

  $form['drune_import_audio_files'] = array(
    '#type' => 'checkbox',
    '#title' => st('Import existing audio files'),
    '#default_value' => variable_get('drune_import_audio_files', FALSE),
  );
  $form['drune_import_source_dir'] = array(
    '#type' => 'textfield',
    '#title' => st('Where are your files located?'),
    '#description' => st('Enter the absolute path to the directory where your music files are currently stored.'),
    '#default_value' => variable_get('drune_import_source_dir', NULL),
    '#states' => array(
      // Hide the settings when the cancel notify checkbox is disabled.
      'invisible' => array(
        'input[name="drune_import_audio_files"]' => array('checked' => FALSE),
      ),
    ),
  );

  $form[] = array(
    '#type' => 'submit',
    '#value' => st('Save and continue'),
  );

  return $form;
}

function drune_config_form_validate($form, &$form_state) {
  if ($form_state['values']['drune_import_audio_files']) {
    if (empty($form_state['values']['drune_import_source_dir'])) {
      form_set_error('drune_import_source_dir', st('You need to specify the directory from which audio files will be imported.'));
    }
    elseif (!is_dir($form_state['values']['drune_import_source_dir'])) {
      form_set_error('drune_import_source_dir', st('%dir is not a directory.', array('%dir' => $form_state['values']['drune_import_source_dir'])));
    }
  }
}

function drune_config_form_submit($form, &$form_state) {
  if ($form_state['values']['drune_import_audio_files']) {
    variable_set('drune_import_audio_files', $form_state['values']['drune_import_audio_files']);
    variable_set('drune_import_source_dir', $form_state['values']['drune_import_source_dir']);
  }
}

function drune_import() {
  $batch = array(
    'title' => st('Importing audio files'),
    'error_message' => st('The audio file import has encountered an error.'),
    'finished' => '_drune_import_finished',
  );
  $files = file_scan_directory(variable_get('drune_import_source_dir', NULL), "/.*\.mp3/");
  foreach ($files as $file) {
    $batch['operations'][] = array('_drune_import', array($file));
  }
  
  return $batch;
}

function _drune_import($file, &$context) {
  global $user;

  $node = (object) array(
    'uid' => $user->uid, 
    'type' => 'track',
    'title' => $file->filename,
  );
  $file = file_copy($file, 'public://music/' . $file->filename);
  $node->field_audio_file[LANGUAGE_NONE][] = (array)$file + array('display' => TRUE);
  node_save($node);
  $context['results'][] = print_r($file, TRUE);
  $context['message'] = st('Importing: @filename', array('@filename' => $file->filename));
}

function _drune_import_finished($success, $results, $operations) {
  drupal_set_message(st('Audio file import completed'));
}

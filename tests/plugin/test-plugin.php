<?php
/**
 * Plugin Name: Test Plugin
 * Plugin URI: https://example.com/test-plugin
 * Description: A test plugin for demonstration purposes.
 * Version: 1.0.0
 * Author: Your Name
 * Author URI: https://example.com
 * License: GPL-2.0+
 * License URI: http://www.gnu.org/licenses/gpl-2.0.txt
 * Text Domain: test-plugin
 * Domain Path: /languages
 */

// If this file is called directly, abort.
if (!defined('WPINC')) {
    die;
}

define('TEST_PLUGIN_VERSION', '1.0.0');

echo __('Hello World', 'test-plugin');

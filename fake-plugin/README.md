# Fake Plugin

This is a fake plugin created for testing the dev-workspace scripts.

## Purpose

This plugin is used to test the refactored build scripts and utilities without needing a real plugin repository.

## Structure

- `composer.json` - Plugin metadata and configuration
- `fake-plugin.php` - Main plugin file with version header
- `.rsync-filters-pre-build` - Files to exclude before build
- `.rsync-filters-post-build` - Files to exclude after build

## Testing

When you run `./run`, this plugin will be mounted at `/project` in the container, allowing you to test:

- `plugin-build build` - Build the plugin
- `plugin-name` - Get plugin name
- `plugin-slug` - Get plugin slug
- `plugin-version` - Get plugin version
- All other utility scripts

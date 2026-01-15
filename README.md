# DEV-WORKSPCE Docker Image for PublishPress Plugins

## Building

To build the image, you can run the following command:

```bash
./build
```

## Building and pushing to Docker Hub

To build and push the image to Docker Hub, you can run the following command:

```bash
./build-push
```

## Running

To run the image, you can use the following command:

```bash
./run
```

### Testing with a plugin

The commands you might want to test expect to find the WordPress plugin code in the
`/project` directory. You can run the following command to clone a plugin repository
to the `/project` directory (Please, replace the repository URL with the one you want to test):

```bash
git clone https://github.com/publishpress/PublishPress-Future.git /project
```

## Dropbox Integration

You can use the command `plugin-dropbox` (or `pdropbox` for backward compatibility, based on `droxul`) to upload built packages to Dropbox.
It requires create a Dropbox App and generate an access token. You can easily do this by
running `plugin-dropbox` (or `pdropbox`) the first time and following the instructions.

The uploaded files will be available in the folder you select when creatin the Dropbox App, which can
be an Scoped App (App Folder).

### Caching the Dropbox Access Token

In order to avoid having to generate a new access token every time you run the `pdropbox` command, you can
cache the access token in a file. The file will be created in the `/root` directory and will be named
`.dropbox_uploader`.

Make sure to include this file in the child dev-workspace image as a volume (`compose.yaml`), so the access token is
available in the next run.

### Unlinking Dropbox Account

If you want to unlink your Dropbox account, you can run `plugin-dropbox unlink` (or `pdropbox unlink` for backward compatibility).

### More Information

You can find more information about the `droxul` command in the [official repository](https://github.com/guillaumeisabelleevaluating/Dropbox-Uploader/).

## Commands available

The following commands are available in the image:

### Main Commands (Recommended)

- `composer` - PHP dependency manager
- `wp` - WordPress CLI
- `plugin-build` - Build the plugin package (main build command)
- `plugin-name` - Get the plugin name from composer.json
- `plugin-slug` - Get the plugin slug from composer.json
- `plugin-folder` - Get the plugin folder name from composer.json
- `plugin-version` - Get the plugin version
- `plugin-zipfile` - Get the plugin zip file name
- `plugin-file` - Get the plugin file path
- `plugin-dropbox` - Dropbox uploader for plugin packages
- `plugin-tests` - Run plugin tests
- `check-dependencies` - Check dependencies between free and pro plugins
- `merge-dependencies` - Merge dependencies from free plugin into pro plugin
- `parse-json` - Parse JSON files and retrieve the value of a key
- `find-long-paths` - List the longest paths in the plugin
- `github-login` - Set Github token and login user using Github CLI
- `get-ip` - Get the IP address of the host machine
- `workspace-version` - Show the version of the dev-workspace
- `test-bootstrap` - Bootstrap plugin files into test container volume

### Deprecated Commands (Backward Compatibility)

All old command names are still available in `scripts/deprecated-scripts/` for backward compatibility:
- `pbuild`, `pname`, `pslug`, `pfolder`, `pversion`, `pzipfile`, `pfile`, `pdropbox`
- `checkdep`, `mergedep`, `parsejson`, `longpath`, `ghlogin`, `getip`, `version`
- `pptests`, `testsbootstrap`

**Note**: While deprecated commands continue to work, new scripts should use the hyphenated command names above.

## Tools available

- bats - Testing framework for Bash scripts
- bet - "cat" command with syntax highlight
...

## How to test

Run the following command inside the container.


```bash
bats /tests/test_longpath.bats
```

## License

This project is licensed under the GNU GPL v3.0 License - see the [LICENSE](LICENSE) file for details.

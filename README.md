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

You can use the command `pdropbox` (based on `droxul`) to upload built packages to Dropbox.
It requires create a Dropbox App and generate an access token. You can easily do this by
running `pdropbox` the first time and following the instructions.

The uploaded files will be available in the folder you select when creatin the Dropbox App, which can
be an Scoped App (App Folder).

### Caching the Dropbox Access Token

In order to avoid having to generate a new access token every time you run the `pdropbox` command, you can
cache the access token in a file. The file will be created in the `/root` directory and will be named
`.dropbox_uploader`.

Make sure to include this file in the child dev-workspace image as a volume (`compose.yaml`), so the access token is
available in the next run.

### Unlinking Dropbox Account

If you want to unlink your Dropbox account, you can run `pdropbox unlink`.

### More Information

You can find more information about the `droxul` command in the [official repository](https://github.com/guillaumeisabelleevaluating/Dropbox-Uploader/).

## Commands available

The following commands are available in the image:

- `composer` - PHP dependency manager
- `wp` - WordPress CLI
- `checkdep` - Check dependencies between free and pro plugins
- `ghlogin` - Script to set Github token and login user using Github CLI
- `longpath` - Script to list the logest paths in the plugin
- `mergedep` - Script to merge dependencies from free plugin into pro plugin
- `parsejson` - a script to parse JSON files and retrieve the value of a key
- `pbuild` - Build the plugin package
- `pdropbox` - Dropbox uploader
- `pfile` - Script to get the file name of the plugin
- `pfolder` - Script to get the folder name of the plugin, where it is installed in WordPress
- `pname` - Script to get the plugin name
- `pslug` - Script to get the plugin slug
- `pversion` - Script to get the plugin version
- `pzipfile` - Script to get the plugin zip file name
- `version` - Show the version of the dev-workspace

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

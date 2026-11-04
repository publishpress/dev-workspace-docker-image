# Changelog

[8.2.1] - 4 Nov, 2026

- Changed: Workspace images now use `publishpress/dev-workspace-terminal:node-26` instead of `node-25`.
- Kept: `node-25` for MetaSlider. Node 25 is end of life and has no CVE-2026-111497 fix.

[8.2.0] - 3 Nov, 2026

- Changed: `generic` is the Debian Trixie image, tagged `publishpress/dev-workspace-terminal:generic`. It replaces both the Alpine `generic-8` build and `generic-debian`.
- Changed: `node-26` is the Debian image, based on `generic`. It replaces the Alpine `node-26` build and `node-26-debian`.
- Removed: GitHub CLI from `generic`. It was unused and linked Go 1.23.4 (CVE-2025-68121).
- Added: `make run` for the Node.js 26 image.
- Removed: tags `generic-debian` and `node-26-debian`. `node-25` and `node-18` still use the previously published Alpine tags `generic-8` and `generic-5`.

[8.1.0] - 30 Oct, 2026

- Added: Debian generic image `publishpress/dev-workspace-terminal:generic-debian`, based on `php:8.3-zts` (Debian Trixie). The tag has no version number.
- Added: The same PHP extensions as the Alpine generic image (gd, intl, gettext, mysqli, pdo_mysql, zip, and yaml 2.3.0), plus Composer 2.10.3, WP-CLI, Git, GitHub CLI, and Starship.
- Added: Node.js 26 Debian image `publishpress/dev-workspace-terminal:node-26-debian`, based on `generic-debian`, with Corepack 0.36.0 and Yarn Classic 1.22.22 as the default.
- Added: The Debian images drop root to the `/project` owner, or to `HOST_UID`/`HOST_GID`, using `gosu`.
- Changed: Built the Debian generic image in multiple stages. PHP is compiled on `php:8.3-zts` and copied onto `debian:trixie-slim` with only the shared libraries it needs. PHP CGI, PHPDBG, and the embed library are omitted.
- Changed: Installed the yaml extension from the GitHub 2.3.0 source archive instead of PECL.
- Changed: Shipped official Node.js 20 in `generic-debian`. `node-26-debian` replaces it with the official Node.js 26 Trixie build.

[8.0.0] - 22 Oct, 2026

- Added: Node.js 26 image based on the optimized generic image.
- Added: Corepack 0.36.0 to the Node.js 25 and 26 images, with Yarn 4 available per project while Yarn Classic 1.22.22 remains the default.
- Added: Starship prompt with Bash as the default interactive shell (Zsh and Oh My Zsh removed; legacy `.zshrc.local` configuration still supported).
- Added: PHP, Composer, Node.js, npm, and Yarn versions to the first line of the generic image Starship prompt, with command duration and Git status on the second line.
- Changed: Rebuilt the Node.js 25 image without duplicate Node.js installations or cross-Alpine library overlays, reducing its size by 29.1%.
- Changed: Rebuilt the generic image as a multi-stage PHP/Alpine image, reducing its size by 19.2% while retaining all development tools and PHP extensions.
- Changed: Removed duplicate PHP packages, unnecessary libraries, build-only dependencies, PHP CGI, PHPDBG, and PHP source files from the runtime image.
- Changed: Replaced the full OpenSSH package with the client-only package.
- Changed: Composer is copied from the pinned Composer 2.10.3 image.
- Changed: Removed duplicate GD and ZIP extension builds from the WordPress image, reducing its size by 6.4 MB.
- Changed: Pinned Composer 2.10.3 in the WP-CLI image and consolidated its setup layers.

[7.0.0] - 20 Oct, 2026

- Fixed: generic terminal image drops to the /project owner (or HOST_UID/HOST_GID) so build output is not root-owned.

[6.0.2] - 1 Sep, 2026

- Added: Centralized Docker build configuration in `make/docker.mk`, shared across all workspace and base makefiles
- Added: `make bootstrap-buildx` target to create the `publishpress-multiarch` buildx builder for multi-platform builds
- Added: `make build-local` target to build a single platform and load the image into the local Docker engine
- Changed: `make build` now uses buildx to build for `linux/amd64` and `linux/arm64` by default, fixing failures on Linux with the default Docker driver
- Changed: `make push` uses the `docker-container` buildx driver, enabling multi-platform pushes and registry cache export on Linux and macOS
- Changed: Updated the WordPress base image to `wordpress:7.1-php8.5-apache`

[6.0.1] - 29 Apr, 2026

- Changed: Removed the DEV_WORKSPACE_VERSION environment variable. This is now the responsibility of the dev-workspace composer library to define.

[6.0.0] - 31 Mar, 2026

- Changed: Removed scripts from the generic image. The scripts are now in the dev-worspace composer package.

[5.2.0] - 13 Mar, 2026

- Added: Add GitHub CLI client.

[5.1.3] - 27 Jan, 2026

- Fixed: Fix plugin zipfile naming by changing from plugin-slug to plugin-name.

[5.1.2] - 22 Jan, 2026

- Fixed: Fixed the deprecated `pbuild` command adding support for using the correct params of `build`.
- Fixed: Fixed ownership issue from git in the src folder when building from Github.
- Changed: Add deprecation warning to `pbuild`.

[5.1.1] - 21 Jan, 2026

- Added: Dockerfiles and makefiles for all plugin workspaces, enabling individual workspace image builds
- Added: `.zshrc.local` configuration files for all workspaces to customize environment variables per plugin
- Changed: Simplified the generic image build script in `base/generic/makefile` for better maintainability
- Added: Root-level makefile and `push-all.sh` script to streamline image deployment process
- Changed: Removed echo statements for PLUGIN_TYPE and PLUGIN_NAME from `.zshrc` to streamline configuration and reduce output clutter
- Changed: Updated `push-all.sh` script to use new workspace paths for plugin directories
- Changed: Adjusted environment variables and prompt settings in `.zshrc` files across all workspaces for consistent versioning

[5.1.0] - 16 Jan, 2026

- Changed: Refactored the image structure for faster building

[5.0.1] - 15 Jan, 2026

- Added: Human readable file sizes to the `ls` commands while building packages
- Changed: Moved the definition of the DEV_WORKSPACE_VERSION variable to the compose file, optimizing build runtime when updating the version

[5.0.0] - 15 Jan, 2026

- Added: Created modular utility scripts for UI functions (`echo-step.sh`, `echo-success.sh`, etc.) and build functions (`clean-dist.sh`, `build-to-dir.sh`, `pack-built-dir.sh`)
- Changed: Modularized `pbuild` script into individual utility scripts for better maintainability and reusability
- Changed: Renamed all scripts to use hyphenated descriptive names (e.g., `pbuild` → `build`, `pname` → `plugin-name`)
- Changed: All old script names are maintained in `scripts/deprecated-scripts/` directory as wrappers
- Changed: Updated PATH to include `deprecated-scripts/` directory for seamless backward compatibility
- Changed: Updated README.md with new command names and migration guide
- Changed: Improved Dev-workspace version formatting in `echo-header` and `workspace-version` scripts
- Changed: Updated Zsh prompt to include Dev-workspace version and improved formatting
- Changed: Improved output of the build command
- Changed: Removed obsolete files and added `.gitignore` for the fake-plugin test suite


[4.4.4] - 14 Jan, 2026

- Fixed: Permissions on files and folders inside the built package. Command `pbuild` updated to 1.4.3.
- Changed: Updated Composer to 2.9.3.

[4.4.3] - 22 Oct, 2025

- Changed: Enhanced .zshrc to source local configuration from ~/.zshrc.local if it exists, providing a way to customize user settings.

[4.4.2] - 22 Oct, 2025

- Added: Environment variables support for PLUGIN_NAME and PLUGIN_TYPE
- Changed: Updated Dockerfile to copy custom .zshrc after installation and modify compose.yaml to launch zsh as a login shell
- Changed: Enhanced .zshrc to set default values for PLUGIN_NAME and PLUGIN_TYPE
- Changed: Updated prompt color logic based on PLUGIN_TYPE
- Security: Fixed jq vulnerability (CVE-2024-53427, CVE-2024-23337, CVE-2025-48060) by updating to v1.8.0-r0
- Security: Fixed Alpine Linux yaml package vulnerability (CVSS 7.5) by upgrading from 0.2.5-r2

[4.4.1] - 21 Oct, 2025

- Changed: Updated base image to php:8.3-cli-alpine3.22.
- Changed: Enhanced makefile to support Docker image builds with provenance attestations and update build command for provenance mode.
- Security: Fixed libxml2 vulnerability (CVE-2025-49796) by verifying secure version
- Security: Fixed node-fetch vulnerability (CVE-2022-0235) by updating to v2.6.7
- Security: Fixed libgit2-sys vulnerability (CVE-2024-24577) by updating bat to v0.26.0

[4.4.0] - 8 Oct, 2025

- Changed: Updated `pbuild` applying "classmap-authoritative" optimization to composer dump autoloader instruction.

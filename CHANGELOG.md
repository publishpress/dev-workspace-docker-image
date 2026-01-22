# Changelog

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

# Changelog

## [5.0.0] 15 Jan, 2026

- **Refactoring**: Modularized `pbuild` script into individual utility scripts for better maintainability and reusability
- **Enhancement**: Renamed all scripts to use hyphenated descriptive names (e.g., `pbuild` → `build`, `pname` → `plugin-name`)
- **Enhancement**: Created modular utility scripts for UI functions (`echo-step.sh`, `echo-success.sh`, etc.) and build functions (`clean-dist.sh`, `build-to-dir.sh`, `pack-built-dir.sh`)
- **Backward Compatibility**: All old script names are maintained in `scripts/deprecated-scripts/` directory as wrappers
- **Enhancement**: Updated PATH to include `deprecated-scripts/` directory for seamless backward compatibility
- **Documentation**: Updated README.md with new command names and migration guide
- **Enhancement**: Improved Dev-workspace version formatting in `echo-header` and `workspace-version` scripts
- **Enhancement**: Updated Zsh prompt to include Dev-workspace version and improved formatting
- **Enhancement**: Improved output of the build command
- **Maintenance**: Removed obsolete files and added `.gitignore` for the fake-plugin test suite


## [4.4.4] 14 Jan, 2026

- Fix permissions on files and folders inside the built package. Command `pbuild` updated to 1.4.3.
- Update Composer to 2.9.3.

## [4.4.3] 22 Oct, 2025

- **Enhancement**: Enhance .zshrc to source local configuration from ~/.zshrc.local if it exists, providing a way to customize user settings.

## [4.4.2] 22 Oct, 2025

- **Security**: Fix jq vulnerability (CVE-2024-53427, CVE-2024-23337, CVE-2025-48060) by updating to v1.8.0-r0
- **Security**: Fix Alpine Linux yaml package vulnerability (CVSS 7.5) by upgrading from 0.2.5-r2
- **Enhancement**: Update Dockerfile to copy custom .zshrc after installation and modify compose.yaml to launch zsh as a login shell
- **Enhancement**: Add environment variables support for PLUGIN_NAME and PLUGIN_TYPE
- **Enhancement**: Enhance .zshrc to set default values for PLUGIN_NAME and PLUGIN_TYPE
- **Enhancement**: Update prompt color logic based on PLUGIN_TYPE

## [4.4.1] 21 Oct, 2025

- Update base image to php:8.3-cli-alpine3.22.
- Enhance makefile to support Docker image builds with provenance attestations and update build command for provenance mode.
- **Security**: Fix libxml2 vulnerability (CVE-2025-49796) by verifying secure version
- **Security**: Fix node-fetch vulnerability (CVE-2022-0235) by updating to v2.6.7
- **Security**: Fix libgit2-sys vulnerability (CVE-2024-24577) by updating bat to v0.26.0

## [4.4.0] 8 Oct, 2025

- Update `pbuild` applying "classmap-authoritative" optimization to composer dump autoloader instruction.

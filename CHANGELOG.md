# Changelog

## [4.4.2] 22 October, 2025

- **Security**: Fix jq vulnerability (CVE-2024-53427, CVE-2024-23337, CVE-2025-48060) by updating to v1.8.0-r0
- **Security**: Fix Alpine Linux yaml package vulnerability (CVSS 7.5) by upgrading from 0.2.5-r2
- **Enhancement**: Update Dockerfile to copy custom .zshrc after installation and modify compose.yaml to launch zsh as a login shell
- **Enhancement**: Add environment variables support for PLUGIN_NAME and PLUGIN_TYPE
- **Enhancement**: Enhance .zshrc to set default values for PLUGIN_NAME and PLUGIN_TYPE
- **Enhancement**: Update prompt color logic based on PLUGIN_TYPE

## [4.4.1] 21 October, 2025

- Update base image to php:8.3-cli-alpine3.22.
- Enhance makefile to support Docker image builds with provenance attestations and update build command for provenance mode.
- **Security**: Fix libxml2 vulnerability (CVE-2025-49796) by verifying secure version
- **Security**: Fix node-fetch vulnerability (CVE-2022-0235) by updating to v2.6.7
- **Security**: Fix libgit2-sys vulnerability (CVE-2024-24577) by updating bat to v0.26.0

## [4.4.0] 8 October, 2025

- Update pbuild applying "classmap-authoritative" optimization to composer dump autoloader instruction.

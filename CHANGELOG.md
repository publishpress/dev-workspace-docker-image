# Changelog

## [4.4.2] 21 October, 2025

### Security Fixes
- **CRITICAL**: Fix node-fetch vulnerability (CVE-2022-0235) by updating to version 2.6.7
  - Updated droxul to latest version (1.0.14)
  - Force installed node-fetch@2.6.7 globally to override vulnerable dependency
  - CVSS Score: 8.8 (High severity)

## [4.4.1] 21 October, 2025

- Update base image to php:8.3-cli-alpine3.22.
- Add apk upgrade command, and verify libxml2 version for security compliance.
- Enhance makefile to support Docker image builds with provenance attestations and update build command for provenance mode.

## [4.4.0] 8 October, 2025

- Update pbuild applying "classmap-authoritative" optimization to composer dump autoloader instruction.

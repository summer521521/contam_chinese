# Changelog

This file records notable changes to this project.

This project uses the version format `v<upstream-version>-zh.<revision>`, for example:

- `v3.4.0.8-zh.1`

## [Unreleased]

- Added a README link to `CONTAM_plugin` for MCP automation, project checks, and simulation workflows that can use `contam_chinese` release executables.

## [3.4.0.8-zh.1] - 2026-03-15

### Added

- Standard repository entry files: `README.md`, `NOTICE.md`, and `CHANGELOG.md`
- GitHub release template: `docs/RELEASE_TEMPLATE.md`
- Screenshot placeholder directory: `screenshots/`
- Chinese help HTML source and build materials
- Release packaging scripts: `tools/package_release.ps1` and `tools/package_release.cmd`

### Changed

- Defined the project as an unofficial Chinese-localized modified distribution based on NIST CONTAM
- Standardized the repository name as `contam_chinese`
- Standardized the repository description as `Unofficial Chinese localization for CONTAM (based on CONTAM 3.4.0.8)`
- Recorded the base program version as `3.4.0.8`
- Recorded the bundled tool version as `3.4.0.3`
- Changed the Chinese help build output to a locally ignored directory
- Restructured the public repository to exclude runnable binaries and keep only project assets and documentation
- Standardized the release program filename as `contamw3.exe`
- Simplified release packaging to archive the finished files in `local/release_seed/`

### Notes

- GitHub Releases serves as the distribution entry point for the final zip package.
- This file and `NOTICE.md` record the project version and release information.

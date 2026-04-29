# contam_chinese

Unofficial Chinese localization for CONTAM (based on CONTAM 3.4.0.8)

`contam_chinese` provides an unofficial Chinese-localized version of CONTAM. The runnable package is distributed through GitHub Releases, while this repository preserves project notes, version history, and localization assets.

## Download

The runnable package is available from GitHub Releases.

The current release package contains:

- `contamw3.exe`
- `ContamHelp.chm`
- `contamx3.exe`
- `prjup.exe`
- `simread.exe`
- `simcomp.exe`
- `olch2d32.dll`

## Usage

1. Download and extract the release archive.
2. Run `contamw3.exe`.
3. Open `ContamHelp.chm` for the Chinese help file.

## Automation With CONTAM_plugin

For AI-agent workflows, project inspection, ContamX simulation, MCP access, and ContamW-safe PRJ checks, use:

- [CONTAM_plugin](https://github.com/summer521521/CONTAM_plugin)

After extracting this `contam_chinese` release package, `CONTAM_plugin` can link to it through `CONTAM_CHINESE_HOME` or its `scripts/link-contam-chinese.ps1` helper. In that setup:

- `contam_chinese` provides the localized GUI executable and Chinese help package.
- `CONTAM_plugin` provides automation, project checks, simulation workflows, and result triage.

## Source And Modification Notice

This project is based on the official CONTAM release from NIST. The repository and release materials retain the following statements:

- `Based on CONTAM developed by NIST.`
- `This is an unofficial Chinese-localized modified distribution.`

This project is not an official NIST release and does not imply NIST endorsement.

## Base Version

As of `2026-03-16`, the latest version listed on the official NIST download page is `CONTAM 3.4.0.8`, released on `2026-01-08`. The same page states that the bundled `ContamX` version is `3.4.0.3`.

The main binaries in this release package have the following versions:

- `contamw3.exe`: `3.4.0.8`
- `contamx3.exe`: `3.4.0.3`
- `prjup.exe`: `3.4.0.3`
- `simread.exe`: `3.4.0.3`
- `simcomp.exe`: `3.4.0.3`

## Repository Contents

- `README.md`
  - project overview and download guidance
- `NOTICE.md`
  - source and modification notice
- `CHANGELOG.md`
  - version history
- `build_assets/`
  - program resource localization files, translation cache, and related scripts
- `tools/`
  - maintenance and packaging scripts
- `docs/`
  - supplementary project documents and release notes material
- `screenshots/`
  - screenshots used in the README and Releases

## Notes

The main entry points of this repository are:

- `README.md`
- GitHub Releases

Runnable files are distributed through Releases. The remaining repository contents preserve project materials and version information.

## References

- [NIST CONTAM Download Page](https://www.nist.gov/el/energy-and-environment-division-73200/nist-multizone-modeling/software/contam/download)
- [NIST CONTAM Software Page](https://www.nist.gov/services-resources/software/contam)
- [NIST TN 1887r1 Document](https://doi.org/10.6028/NIST.TN.1887r1)

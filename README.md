# linux-system-update-automation

Automated Linux system maintenance workflow covering APT, Snap, Flatpak, pipx, Docker, and Git repositories.

## Overview

This repository documents a practical system maintenance automation workflow for a Linux server environment.

The goal of the project is to centralize and automate updates across multiple package management systems and development environments, reducing manual maintenance work and improving system consistency.

## Current Workflow

The update process includes:

* APT package updates and upgrades
* Snap package refresh
* Flatpak application updates
* pipx-managed Python package upgrades
* Docker engine update and image refresh
* cleanup of unused Docker images
* automatic update of local Git repositories

## Features

* multi-source update automation
* support for multiple package managers
* safe fallback handling for update failures
* Docker image refresh and cleanup
* Git repository synchronization
* structured and readable execution flow
* designed for real-world server maintenance

## Goals

* reduce repetitive manual update tasks
* provide a unified update workflow for different ecosystems
* improve system hygiene and consistency
* document a reusable maintenance approach
* publish a sanitized version of a real-world script

## Environment

* Linux server
* Bash scripting
* APT / Snap / Flatpak
* pipx (Python tools)
* Docker
* Git

## Notes

This repository is based on a real maintenance script adapted into a public example.

AI tools (ChatGPT) were used for idea exploration, debugging, and documentation support. The final workflow was tested and adjusted manually in a real environment.

Sensitive information such as system-specific paths, repositories, and configuration details has been removed from this public version.

## Repository Structure

- `scripts/` – system maintenance and update automation scripts
- `docs/` – project notes and supporting documentation

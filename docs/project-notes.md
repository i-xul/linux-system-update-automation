# Project Notes

## Purpose

This project was created to automate system maintenance tasks across a Linux server environment.

The goal was to centralize updates from multiple package ecosystems into a single, repeatable workflow that reduces manual effort and improves system consistency.

## What I learned

During this project I learned more about:

- automating system maintenance with Bash scripting
- handling multiple package managers in a unified workflow
- implementing fallback logic for update failures
- managing Docker images and storage cleanup
- updating multiple Git repositories programmatically
- structuring scripts for readability and maintainability
- adapting a real-world maintenance script into a public portfolio example

## Practical lessons

One key insight from this project was that modern Linux environments often rely on multiple package ecosystems simultaneously.

Without automation, maintaining:

- APT packages
- Snap applications
- Flatpak apps
- pipx-managed tools
- Docker images
- Git repositories

quickly becomes repetitive and error-prone.

Another important lesson was that safe fallback logic (for example, handling failed upgrades) is essential for real-world automation scripts.

## Portfolio note

This repository is based on a real system maintenance workflow adapted into a public example.

Sensitive details such as system-specific configurations, paths, and repositories have been removed.

AI tools were used during development for ideation, debugging, and documentation, but the final workflow was tested and validated manually in a real environment.

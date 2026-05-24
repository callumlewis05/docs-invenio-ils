#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2025 CERN.
# SPDX-License-Identifier: MIT


npx markdownlint-cli docs/* && \
awesome_bot --allow-dupe --skip-save-results --allow-redirect docs/**/*.md && \
mkdocs build -v
rm -rf site/

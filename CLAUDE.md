# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**bla_tasks** is a Rails 8.1 API-only application using the "Solid Stack" (solid_cache, solid_queue, solid_cable) for SQLite-backed infrastructure instead of Redis. Deployed via Docker + Kamal.

## Commands

```bash
# Install dependencies and prepare database
bin/setup

# Start development server
bin/dev

# Run all tests
bin/rails test

# Run a single test file
bin/rails test test/models/user_test.rb

# Run a single test by line number
bin/rails test test/models/user_test.rb:10

# Lint
bin/rubocop -f github

# Security scan
bin/brakeman --no-pager

# Gem vulnerability audit
bin/bundler-audit

# Database migrations
bin/rails db:migrate
```

## Architecture

**API-only Rails app** — no views, sessions, or cookies. `ApplicationController` inherits from `ActionController::API`.

**Multi-database setup (production):** Four separate SQLite databases — `primary` (app data), `cache` (solid_cache), `queue` (solid_queue), `cable` (solid_cable). In development, a single `development.sqlite3` is used.

**Current models:**
- `User` — `email_address` (unique), `password_digest` (via `has_secure_password`)

**Testing:** Minitest with parallel execution (all processors). Fixtures in `test/fixtures/`. No additional test libraries.

**CI pipeline** (`.github/workflows/ci.yml`): Three jobs run in parallel — security scan (brakeman + bundler-audit), lint (rubocop), and tests.

**Linting style:** RuboCop with `rubocop-rails-omakase` (Basecamp's opinionated Rails style).

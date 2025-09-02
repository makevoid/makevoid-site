# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a personal portfolio site built with Ruby and the Roda framework that showcases GitHub repositories. It fetches repository data via GitHub's GraphQL API v4 and displays it in a minimalistic white UI with TailwindCSS.

## Common Development Commands

### Run the Application
```bash
bundle exec rackup -p 3000
# or
rake run
# or  
rake  # (default task)
```

Visit: http://localhost:3000

### Dependencies
```bash
bundle install
```

### Build and Deploy
```bash
rake compose_build           # Build docker container
rake compose_release        # Build and push to dockerhub
```

### GitHub API Tasks
```bash
rake graphql_dump           # Dump GraphQL schema to data/github_schema.json
rake repos                  # Test GitHub API call and display repos
rake reset                  # Clear GitHub API cache
```

### Cache Management
Cache files are stored in `tmp/cache/` and expire after 24 hours for normal web requests. Use `rake reset` to manually clear the GitHub API cache when needed.

## Architecture Overview

### Core Application Structure
- **app.rb**: Main Roda application class with routing
- **config/env.rb**: Environment configuration and dependency loading  
- **config.ru**: Rack configuration file

### Key Libraries & Frameworks
- **Roda**: Lightweight Ruby web framework with routing tree
- **HAML**: Template engine for views
- **GraphQL Client**: For GitHub API v4 integration
- **TailwindCSS**: Utility-first CSS framework (loaded via CDN)
- **Bulma**: CSS framework (legacy, being replaced by Tailwind)

### Data Layer
- **lib/gh.rb**: GitHub GraphQL API client and repository data fetching
- **lib/cache.rb**: File-based caching system (24-hour cache for API responses)
- **lib/monkeypatches.rb**: Extensions to GraphQL client for repository data

### Environment & Configuration
- **lib/env_lib.rb**: Custom environment variable loader
- **lib/social.rb**: Social media profile URLs configuration
- **lib/view_helpers.rb**: Template helper methods for title formatting

### Views Structure  
- **views/layout.haml**: Main layout template
- **views/index.haml**: Homepage displaying repository grid
- **views/_repo.haml**: Repository card partial template
- **views/_main_nav.haml**: Navigation partial (currently disabled)

### Static Assets
- **public/css/style.css**: Custom CSS overrides and utilities
- **public/img/**: Logo and social media icons
- **public/js/app.js**: Frontend JavaScript

## GitHub Integration

The application uses GitHub's GraphQL API v4 to fetch repository data:

- **Authentication**: Requires `GITHUB_TOKEN` environment variable
- **Query**: Fetches public repositories for user "makevoid" with metadata
- **Caching**: API responses cached in `tmp/cache/` for 24 hours
- **Filtering**: Repositories tagged with "v" topic are filtered out
- **Screenshots**: Looks for `screenshots/main.jpg` in each repo

## Environment Variables

Required environment variables (via .env files or environment):
- `GITHUB_TOKEN`: GitHub personal access token for API access
- `MIXPANEL_TOKEN`: Mixpanel analytics token
- `RACK_ENV`: Application environment (development/production)

### GitHub Token Configuration
The application searches for `GITHUB_TOKEN` in this order:
1. System environment variables (`GITHUB_TOKEN=your_token`)
2. `.env` and `.env.local` files (`GITHUB_TOKEN=your_token`)
3. `~/.github_token_readonly` file containing just the token

### Error Handling
The application provides specific error messages for:
- Missing GitHub token with instructions on where to set it
- 401 Unauthorized errors indicating expired/invalid tokens
- Missing user data from GitHub API

## Customization for Other Users

To fork this portfolio for another GitHub user:
1. Replace all instances of "makevoid" with target GitHub username
2. Update social media URLs in `lib/social.rb`
3. Replace logo images in `public/img/`
4. Update meta tags and titles in `views/layout.haml`

## Docker Support

The application includes Docker support:
- **Dockerfile**: Container definition
- **docker-compose.yml**: Multi-container orchestration
- Uses Puma web server in production
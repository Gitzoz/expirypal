# GitHub Pages Site

## Goal
Provide a public GitHub Pages site that explains the ExpiryCue product, links to the repository documentation, and presents the privacy-first positioning clearly.

## Non-goals
- Hosting any backend or interactive service
- Adding analytics, tracking, ads, cookies, or third-party embeds
- Replacing the authoritative markdown documentation in this repository
- Expanding app scope beyond the v1 specification

## User behavior
- Visitors can understand the purpose of ExpiryCue from a single landing page.
- Visitors can navigate to architecture, data model, notifications, testing, roadmap, changelog, and feature docs.
- Visitors can read a public summary of privacy and licensing constraints.
- Visitors can reach the GitHub repository directly from the site.

## Implementation summary
- The public site is implemented as a static HTML/CSS site under `docs/site/`.
- GitHub Actions deploys `docs/site/` to GitHub Pages.
- The site uses repository markdown docs as the source of truth and links back to them where appropriate.
- The site must not load external scripts, fonts, trackers, or remote assets.

## Tests
- Validate required Pages files exist.
- Validate key internal links resolve to repository files or site pages.
- Validate no external script, analytics, or tracking references exist in the site source.
- Continue running `scripts/test.sh` to ensure app validation remains green.

## Localization notes
- The GitHub Pages site is informational repository content, not the app UI.
- The public site must not claim language support beyond the app's English and German support.

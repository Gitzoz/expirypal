# ADR-0001: GitHub Pages Public Docs

## Context
ExpiryCue needs a public-facing landing page and documentation entrypoint that can be hosted directly from the repository without introducing product runtime dependencies or violating privacy constraints.

## Decision
Use a static HTML/CSS site in `docs/site/` and deploy it through GitHub Pages via GitHub Actions.

The site must:
- contain no analytics, tracking, ads, or external embeds
- contain no external fonts, scripts, or remote assets
- link back to authoritative repository documentation for detailed reference material
- stay aligned with `README.md`, `PRIVACY.md`, `ROADMAP.md`, and `docs/`

## Consequences
- The site is simple, portable, and has no build dependency for local editing.
- Public pages remain easy to audit for privacy compliance.
- Some content is summarized in HTML and must be updated when authoritative docs change.
- Deployment is repository infrastructure only and does not affect the app runtime stack.

## Alternatives Considered
- Jekyll-based site generation: rejected to avoid introducing an extra site framework and build-specific complexity.
- External docs platform: rejected because it adds operational dependency and weakens privacy/control guarantees.
- GitHub README only: rejected because it does not provide a focused public landing page or structured Pages experience.

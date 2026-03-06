# docs/site

Static public landing/docs site for GitHub Pages.

## Source of Truth

The repository markdown documents remain authoritative.

Use these as the primary content sources:
- `README.md`
- `PRIVACY.md`
- `ROADMAP.md`
- `docs/`

## Content Rule

If a public site page summarizes content from a markdown document, update the markdown document first and then update the static page.

## Update Workflow

1. Update authoritative markdown documentation.
2. Update `docs/site/` HTML/CSS pages.
3. Run the Pages validation script.
4. Run `scripts/test.sh`.

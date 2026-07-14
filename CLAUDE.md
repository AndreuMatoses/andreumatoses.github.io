# CLAUDE.md

Guidance for AI assistants working in this repo.

## What this is

A personal academic website (Andreu Matoses Gimenez) built with **Jekyll** and
hosted on **GitHub Pages**. Pushing to `main` triggers the GitHub Pages build —
there is no separate CI. This is a personal site: favor simplicity and easy
content editing over abstraction, defensive coding, or heavy comments.

The `README.md` is the user-facing "how to add content" guide (and is itself
served as a page at `/readme/`). This file is the maintainer/AI-facing map.

## Running locally

```shell
docker compose up   # serves http://localhost:4000 with livereload
```

Uses the `jekyll/jekyll` Docker image, so no local Ruby needed. `Gemfile` pins
the `github-pages` gem to match Pages' environment. Note the local Ruby toolchain
in this container is too new for the pinned Jekyll 3.x, so prefer Docker (or just
trust the Pages build) over `bundle exec jekyll` here.

## Layout of the codebase

```
_config.yml            Site config: title, collections, plugins, defaults
_data/
  navigation.yml       Top nav links (supports nested subpages)
  socials.yml          Social/contact icons (Bootstrap Icons)
  publications.json    ALL publications live here (see README for schema)
_layouts/
  base.html            <html>/<head>: CSS, fonts, MathJax, analytics
  default.html         base + navbar + centered container + footer
  page.html            Simple titled page (used for /pages/*.html by default)
  paper.html           Research/project pages (authors, links, body)
  post.html            Blog posts (date, optional collapsible TOC)
_includes/             Reusable snippets (see below)
_research/             One file per research project -> its own page
_posts/                Blog posts (YYYY-MM-DD-title.md)
assets/css|js|images|files|icons
index.html             Homepage (bio, news, research list)
publications.html      Publications page + inline search
education.html         The "Teaching" page (permalink /teaching/)
posts.html             Blog index (permalink /posts/)
404.html
```

### Layout inheritance
`base.html` → `default.html` → (`page.html` | `paper.html` | `post.html`).
Defaults in `_config.yml` auto-assign layouts:
- everything → `default`
- `pages` → `page`
- `_research/*` → `paper` (+ `usemathjax: true`)
- `_posts/*` → `post` (+ `usemathjax`, `show_toc`)

So a new `.html`/`.md` at the repo root just needs `title:` and `permalink:` —
the `page` layout is applied automatically.

### Key includes
- `project_card.html` — brutalist card for a research item (homepage list). Reads
  `title, authors, date, venue, description, cover_image, url, links`.
- `publication_item.html` — one publication row on the publications page.
- `navigation.html` / `footer.html` — nav bar and footer (both render socials).
- `figure.html` — centered responsive image: `{% include figure.html src=… width=… alt=… caption=… %}`
- `gallery.html` — image/video grid: `{% include gallery.html images=page.x n_columns=2 caption=… %}`
- `fix_link.html` — normalizes a link: passes external `://` URLs through, prepends
  `relative_url` to local paths. Use it for any asset/file link so it works under
  the site baseurl. `toc.html` is a vendored third-party TOC generator — don't edit.

## Common content tasks

- **Add a publication:** append an object to `_data/publications.json`. Ordering is
  by `date` (newest first), grouped by year and `type` (`journal|conference|workshop|thesis|other`).
- **Add a research project:** create `_research/<slug>.md` (or `.html`) with the same
  frontmatter shape as existing files. It becomes a `paper`-layout page and appears
  on the homepage research list. Set `ignore: true` to hide it, `redirect_to: <url>`
  to bounce the page elsewhere (via `jekyll-redirect-from`).
- **Add a blog post:** create `_posts/YYYY-MM-DD-title.md`. TOC and MathJax are on by default.
- **Edit homepage bio / news:** edit `index.html` directly (news is a hand-written `<ul>`).
- **Nav / socials / site title:** `_data/navigation.yml`, `_data/socials.yml`, `_config.yml`.
- **Link a local asset:** put it under `assets/`, then `{% include fix_link.html link='/assets/…' %}`
  (or `{{ '/assets/…' | relative_url }}` in markdown).

Both `.md` and `.html` work for research/posts — pick whichever is convenient and
keep the frontmatter consistent. MathJax uses `$…$` (inline) and `$$…$$` (display).

## Styling / CSS

- **Framework: Bootstrap 5**, vendored (not via CDN): `assets/css/bootstrap.css` +
  `assets/js/bootstrap.bundle.min.js`. Layout uses BS5 utilities heavily
  (`data-bs-toggle`, `bg-body-tertiary`, grid, spacing helpers).
- **Custom styles: `assets/css/style.scss`** — has empty `---` frontmatter so Jekyll's
  built-in Sass compiles it to `/assets/css/style.css` (referenced in `base.html`).
  Edit the `.scss`, never a generated `.css`. Notable custom pieces:
  - `.brutalist-card` — neo-brutalist offset-shadow card used for project cards
    (modifiers: `push-on-hover`, `shadow-on-hover`, `shadow-color-*`).
  - `.timeline`, `.news-list`, `.line-clamp-3`, `.link-underline-hover`, black text selection.
  - Responsive image tweaks (`.profile-img`, `.project-card-media`) via `@media` breakpoints.
  - Accent color is blue `#006bcf` (`a`, `.accent-color`).
- **Syntax highlighting:** `assets/css/codehighlight.css` (Rouge classes).
- **Fonts (Google Fonts, in `base.html`):** Poppins = body, Montserrat = titles/navbar.
- **Icons:** Bootstrap Icons 1.11.2 via CDN. **MathJax** and **Google Fonts** also via CDN.

## Non-standard / questionable things — do NOT perpetuate

Be critical about these rather than copying the pattern:

- **`assets/js/custom.js` is dead code.** It's a leftover from the "Source Themes
  Academic" theme, is never loaded by any layout, and references a `publications`
  array / `publications-container` element that don't exist. The real publications
  search is the inline `<script>` at the bottom of `publications.html`. Safe to delete.
- **Contact email:** the address `A.MatosesGimenez@tudelft.nl` appears in
  `_data/socials.yml` (as a `mailto:`) and in `index.html` (as display text). Keep the
  two in sync, and never put a literal `(at)` inside a `mailto:` href — it breaks the link.
- **`Public Sans` font is fetched but never used** (loaded in `base.html`, absent from
  the SCSS). Drop it from the Google Fonts URL to save a request.
- **`bootstrap.css.map` (~680 KB) is committed** — a sourcemap that ships nothing at
  runtime. It can be removed.
- **Mixed vendoring strategy:** Bootstrap CSS/JS are vendored but Bootstrap Icons,
  fonts, and MathJax come from CDNs. Fine for a personal site, but it means the page
  isn't fully self-hosted/offline-reproducible — keep in mind before claiming otherwise.
- **`education.html` serves the `/teaching/` page** (filename ≠ URL ≠ nav label
  "Teaching"). Not broken, just confusing; renaming to `teaching.html` would help.
- **Template scaffolding still present:** `_research/example.md` and
  `_posts/2023-12-19-welcome-to-jekyll.md` are examples, not real content.
- **`paper.html` uses `{{ page.content }}` instead of the idiomatic `{{ content }}`.**
  It happens to render correctly here (verified: markdown and includes are processed),
  so leave it — but prefer `{{ content }}` in any new layout.
- The publications search JS manipulates the DOM directly and is O(n²)-ish; the code
  itself flags this. It works and n is small — don't over-engineer it.

## Conventions

- Keep comments sparse and content easy to edit; this is a personal site.
- When adding a page, rely on the `_config.yml` layout defaults instead of setting
  `layout:` manually unless you need a specific one.
- Route every local asset/file link through `fix_link.html` or `relative_url`.
- Don't hand-edit generated output (`_site/`, compiled `*.css`); `_site/` is gitignored.

## Git workflow

- Small fixes (docs, typos, content edits, small tweaks) can be committed and
  pushed **directly to `main`** — no branch/PR needed. Pushing to `main` triggers
  the Pages deploy.
- Only create a feature branch (and PR) for **significant** changes — new
  sections/layouts, restructuring, or anything you'd want to review before it goes live.
- **Batch edits into one themed commit.** Every push to `main` retriggers the Pages
  build, so don't commit/push after each small edit — group related changes and commit
  once when a coherent chunk of work is done. Push when the batch is ready, not per-file.

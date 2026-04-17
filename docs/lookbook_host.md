# Lookbook Host App

This repository includes a minimal host Rails app in `lookbook_host/` to publish Maglev Lookbook previews from an engine repository.

## Why this app exists

- Keep preview classes as a single source of truth in `spec/components/previews`.
- Avoid generated/copied files that drift over time.
- Provide a deterministic app target for Docker and Kamal deployments.

Maglev’s preview layout uses `stylesheet_link_tag` and the importmap helpers. That requires **Propshaft** (or another asset pipeline) so `config.assets` exists and the engine can register its asset paths (`maglev/tailwind`, `maglev/application`, editor modules, etc.). Without it, previews load with almost no CSS/JS.

## How previews are wired

The host app config points both ViewComponent and Lookbook to:

- `../spec/components/previews`

No preview files are copied into `lookbook_host`.

## Local run

From repository root:

```bash
cd lookbook_host
bundle install
./bin/rails server
```

The host uses the **NullDB** Active Record adapter so you do not need `db:create`, `db:migrate`, or a running database server. Maglev still loads AR models; previews are not expected to run CMS queries.

NullDB still **reads `db/schema.rb`** to know column definitions when a model loads its schema. That file is committed in `lookbook_host` (aligned with `spec/dummy/db/schema.rb`). Do not delete it; refresh it if Maglev migrations change and you hit missing-column errors in development.

Then open: `http://localhost:3000/` (Lookbook is mounted at the app root).

### Use `./bin/rails`, not bare `bundle exec rails`

Rails’ CLI walks up from the current directory until it finds a `bin/rails`. If `lookbook_host/bin/rails` is missing (or you run the command from the repo root with the engine’s `Gemfile`), it can pick `maglev-mit/bin/rails` (the engine stub) instead. That loads the gem’s Rakefile and the wrong app. Always run Rails tasks from `lookbook_host` with `./bin/rails` (or `ruby bin/rails`).

## Docker

Build from repository root so the container includes `spec/components/previews`:

```bash
docker build -f lookbook_host/Dockerfile -t maglev-lookbook .
docker run --rm -p 3000:3000 \
  -e SECRET_KEY_BASE="$(openssl rand -hex 32)" \
  maglev-lookbook
```

## Kamal notes

- Build context must be repository root.
- Dockerfile should be `lookbook_host/Dockerfile`.
- Set a strong `SECRET_KEY_BASE` for the Lookbook deployment target.
- The app is **public** by default; use your proxy (IP allowlist, SSO, Cloudflare Access, etc.) if you need access control.

[![Build Status](https://github.com/maglevhq/maglev-core/actions/workflows/verify.yml/badge.svg)](https://github.com/maglevhq/maglev-core/actions/workflows/verify.yml)

# MaglevCMS

Visual page builder for Ruby on Rails (7.2+ and 8.x). Marketing and content people edit pages in the browser. Everything stays in your app—no separate CMS host or headless stack to run.

![MaglevCMS editor](https://github.com/user-attachments/assets/b3a1ad34-bbae-47d7-9661-7cec5342d027)

The editor is built on **Hotwire**, **Stimulus**, and **ViewComponent**. Assets ship with the engine (importmap + vendored JS). You do not need Node, Webpack, or Vite to use Maglev in production.

Sections, themes, and layouts are ordinary Rails: ERB, Haml, or Slim for templates; Tailwind, Bootstrap, or your own CSS; Stimulus or plain JavaScript for behavior. Maglev does not dictate your front-end beyond what the editor needs.

## Demo

[Live demo (SaaS edition)](https://demo-pro.maglev.dev) — includes features that exist only in the commercial SaaS product, but it shows how the editor feels in a real app.

## Documentation

- [Quickstart / installation](https://docs.maglev.dev/quickstart)
- [Full docs](https://docs.maglev.dev/)

## SaaS edition

Multi-tenant setups (several sites or customers in one Rails app), deeper white-labeling, and supported deployments are covered by [Maglev SaaS](https://www.maglev.dev/saas-edition). The OSS gem is the same core; SaaS adds hosting-oriented features and support.

## Tests

If you need a Maglev site inside the test suite, call `Maglev::GenerateSite.call` from your setup (see the docs for context).

## License

MIT — see [MIT-LICENSE](MIT-LICENSE) and [opensource.org/licenses/MIT](https://opensource.org/licenses/MIT).

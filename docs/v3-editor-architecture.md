# Maglev v3: New Editor Architecture

## Overview

Maglev v3 replaces the VueJS editor used in v2 with a Rails-native architecture built on:

- Server-rendered views
- `ViewComponent` for reusable UI building blocks
- `Stimulus` for client-side behavior
- `importmap` for JavaScript module loading

This move removes the JavaScript precompilation step from the editor stack.

## Why this changed

The move to Hotwire was driven by concrete product and developer-experience constraints observed in Maglev v2.

Main goals:

- Keep up with a stable stack: maintaining pace with VueJS major versions, Vite evolution, and state-management changes was too costly over time.
- Simplify integration and deployment in host Rails apps: the previous frontend stack made integration heavier and often slowed down app deployment workflows.
- Make editor UI customization realistic: in v2, developers often had to copy/paste and own a large part of the Vue editor app just to tweak small UI pieces.
- Rely on mature Rails-native tooling: Hotwire, Stimulus, and ViewComponent are now mature enough to support a robust editor architecture.

## Technical architecture

### Server-side rendering first

In v3, the server is the source of truth for editor rendering.  
Most editor UI is generated on the server and sent as HTML.

Benefits:

- Consistent rendering between environments
- Easier debugging through standard Rails traces and templates
- Reduced client-side state synchronization issues

### ViewComponent as the UI composition layer

Editor UI elements are composed with `ViewComponent` components.

Examples of componentized editor parts:

- Side panels and toolbars
- Form controls and inspectors
- Section wrappers and insertion controls
- Reusable feedback patterns (empty states, notices, action rows)

This gives a clear, testable structure to the editor UI and encourages encapsulation.

### Finding editor ViewComponents in the codebase

In this repository, editor-related components are mainly split into:

- `app/components/maglev/editor` for editor-specific settings and composition
- `app/components/maglev/uikit` for reusable UI primitives used by the editor

Each component usually has:

- A Ruby class (for example `*_component.rb`)
- A template (for example `*_component.html.erb`)

Useful places to explore:

- `app/components/maglev/editor/settings`
- `app/components/maglev/uikit/app_layout`
- `app/components/maglev/uikit/form`

### Stimulus for interaction

`Stimulus` controllers handle behavior on top of server-rendered HTML, such as:

- Toggling panels and contextual menus
- Wiring user actions to requests
- Managing lightweight local UI state
- Triggering save and publish actions

This keeps JavaScript focused on interaction, not full application rendering.

### No JS precompilation: importmap

Maglev v3 relies on `importmap` for JavaScript modules.  
There is no mandatory bundling/transpilation/precompilation step for editor code.

What this means technically:

- Fewer build dependencies
- Simpler CI/CD pipelines
- Lower friction for upgrades and maintenance

## Lookbook for local component development

Maglev uses `lookbook` to preview and iterate on `ViewComponent`-based UI.

In this repo:

- Lookbook is mounted at `/lookbook` in the dummy app routes.
- Component previews live in `spec/components/previews`.
- Development config points Lookbook to Maglev component paths in `spec/dummy/config/environments/development.rb`.

Run it locally:

```bash
cd spec/dummy
bin/rails db:prepare
bin/dev
```

Then open:

- `http://localhost:3000/lookbook`

This is the fastest way to test component-level UI changes without navigating the full editor flow.

## Super simple override example

One easy customization point is the editor topbar partial rendered by:

- `app/views/layouts/maglev/editor/application.html.erb`

It calls:

- `render 'layouts/maglev/editor/topbar'`

So in your host app, create:

- `app/views/layouts/maglev/editor/_topbar.html.erb`

Example override:

```erb
<% topbar.with_logo(root_path: "/", logo_url: maglev_editor_logo_url) %>

<% topbar.with_actions do %>
  <%= link_to "My docs", "/docs", class: "text-sm underline mr-4" %>
<% end %>
```

Because Rails app views take precedence over engine views, this lets you override part of the editor without forking Maglev.

## Developer impact

For teams extending Maglev:

- Prefer Rails views + `ViewComponent` for editor UI changes
- Use `Stimulus` for behavior attached to rendered DOM
- Keep business logic on the server and expose only the interaction hooks needed in JS

This model is closer to standard Rails conventions and generally reduces cross-layer complexity.

## User impact

For content editors and admins:

- The editor remains visual and interactive
- Actions feel more predictable because server state drives the UI
- Fewer frontend-tooling-related regressions
- More stable experience across updates

In short, v3 keeps the editing experience modern while simplifying the underlying architecture.

## Migration note from v2

If you previously customized the VueJS editor:

- Re-implement custom editor UI as `ViewComponent`
- Re-implement client interactions as `Stimulus` controllers
- Remove assumptions tied to SPA-managed client state

The migration effort is usually straightforward for Rails teams because customization points now follow familiar Rails patterns.

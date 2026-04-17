---
title: Maglev UIKit
label: Overview
landing: true
---

**Maglev** is a page-builder and CMS engine for Rails. The **editor** (layouts, sections, settings, and inline controls) is built from a shared library of **ViewComponents** and Stimulus controllers shipped with the engine.

**Maglev UIKit** is that library: buttons, forms, toolbars, modals, breadcrumbs, device toggles, and the rest of the patterns you see in the Maglev editor. Previews here document those components in isolation so you can:

- **Design and review** UI without running a full Maglev site or dummy app
- **Regression-check** styling and behavior when changing shared pieces
- **Onboard** contributors who need to touch editor chrome but not the whole CMS

Component previews live in the engine repo under `spec/components/previews`; this host app exists only to boot Rails, mount Lookbook, wire Maglev assets, and deploy a small public Lookbook (for example behind your own access control).

Use the **Previews** sidebar to open any scenario. **Inspect** shows source, notes, and embed options where Lookbook exposes them.

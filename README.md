# MaglevCMS — Page Builder for Ruby on Rails

![Screenshot of the MaglevCMS editor](https://github.com/user-attachments/assets/0dc61245-0cef-42dc-a65d-0e73909dcbba)

[![Build Status](https://github.com/maglevhq/maglev-core/actions/workflows/verify.yml/badge.svg)](https://github.com/maglevhq/maglev-core/actions/workflows/verify.yml)

**MaglevCMS** is a powerful, fully-integrated page builder for Ruby on Rails (7 & 8).  
It lets your non‑technical users create and edit marketing pages visually — right inside your Rails app — without compromising performance, security, or developer experience.

✅ **Built with Hotwire, Stimulus, and ViewComponent**  
🚫 **No Node.js, no React, no external build tooling**  
🧩 **Rails-native sections, themes, layouts & content system**  
🛠 **Works with any Rails app — from solo projects to large-scale SaaS**

> Designed for developers. Loved by marketing teams.

⚠️ The Hotwire/Stimulus/ViewComponent stack is currently available in the beta version 3 of MaglevCMS.

## 🧩 Use Your Stack, Your Way

Maglev is *unopinionated* when it comes to implement your Maglev layout/sections. You can:

- Build sections using **ERB**, **HAML**, or **Slim**
- Style them with **Tailwind CSS**, **Bootstrap**, or your own design system
- Add interactivity with **Stimulus**, **vanilla JS**, or even **jQuery** if you must 😉

No vendor lock-in. No complex build chains. Just Rails.

---

## ✨ Live Demo

Try Maglev in your browser:  
👉 [**SaaS Edition Demo**](https://demo-pro.maglev.dev)

This demo showcases the full capabilities of MaglevCMS, including advanced features available in the SaaS version.

---

## 📦 Getting Started

- 🚀 [Quickstart: Install Maglev in your app](https://docs.maglev.dev/quickstart)
- 📚 [Read the full documentation](https://docs.maglev.dev/)

---

## 💼 For Rails SaaS Founders

MaglevCMS SaaS Edition is built for **multi-tenant Rails applications**.  
It adds support for:

- Multiple sites, themes & tenants  
- Deep editor customization & white-labeling  
- Production support & custom features

We work closely with SaaS teams to ensure a seamless integration.  
➡️ [Learn more about the SaaS Edition](https://www.maglev.dev/saas-edition)

---

## 🧪 Testing

If for some reason you want your Maglev site to exist during your tests, you can use `Maglev::GenerateSite.call` in your setup block.

---

## 📄 License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
